; script to monitor system automatic services - script uses two files globalexclusions.txt and privateexclusions.txt
; Created by Michael Martin December 2010 Trilogy Technologies
;***********************************************************************
#include <file.au3>
#include <Array.au3>
#Include <Date.au3>
#include <Services.au3>

#NoTrayIcon

Dim $aSvchistory[20][3] ;Historical array used to keep track of services stopping
Dim $laststop = 0 ;used for historical array
Dim $aGlobal ;array for global exclusion list
Dim $aPrivate ;array for private exclusion list
Dim $Agenttmp ;Agent temp directory
Dim $x = 1 ; used in main loop
Dim $Custom ;does this machine have a custom exclusion list
Dim $GlobalExclusion ;path to the file 
Dim $PrivateExclusion ; path to the file 




;********************** Custom Values
if fileexists($agenttmp & "\servicemonitoring\servicemonitoring.ini") then 

;***********************
	Dim $EventSource = IniRead("servicemonitoring.ini","custombranding","EventSource","Trilogy Service Monitoring")
	Dim $EventID = IniRead("servicemonitoring.ini","custombranding","EventID","998")
	Dim $Looptime = IniRead("servicemonitoring.ini","custombranding","Looptime","2")
	dim $Logname = IniRead("servicemonitoring.ini","custombranding","Logname","trilogyservicemontoring.log")
	Global $sServiceName = IniRead("servicemonitoring.ini","custombranding","ServiceName","TrilogySM")
	Global $sServiceDisplayName = IniRead("servicemonitoring.ini","custombranding","ServiceDisplayName","TrilogyServiceMonitoring")
	Dim $Agenttmp = IniRead("servicemonitoring.ini","custombranding","AgentTemp","c:\itfocustemp")
	
	
Else ;no ini exists use default branding
	
	Dim $EventSource = "Trilogy Service Monitoring" ;In the event log what will the source be of the events that are logged by the application
	Dim $EventID = "998" ; In the event log what will the event ID of the events logged be
	Dim $Looptime = 2 ;How often will the system check the services - this is a minimum of 1 minute but recommeneded is longer 2 or above
	dim $Logname = "trilogyservicemonitor.log" ;the name of the log file to record information in - will default to c:\ logname
	Global $sServiceName = "TrilogySM"
	Global $sServiceDisplayName="TrilogyServiceMonitoring"
	Dim $Agenttmp = "c:\itfocustemp"

EndIF 

If $cmdline[0] = 1 Then
	Switch $cmdline[1]
		Case "-i"
			InstallService()
		Case "-u"
			RemoveService()
		Case Else
			exit 
		EndSwitch
		
EndIf
_Service_init($sServiceName)
Run("eventcreate /T Information /ID " & chr(34) & $EventID & chr(34) & " /L Application /SO " & Chr(34) & $EventSource & Chr(34) &" /D " & Chr(34) & "Application Servicemonitoring.exe has been started" & Chr(34), "", @SW_HIDE, 2)

if Isint($looptime) = 0 then $looptime = Int($looptime) ;$looptime if read from ini will be a string so needs to be converted to int 
$looptime = ($looptime * 60) * 1000 ;AutoIT sleep is milliseconds so need to convert Looptime to milliseconds
$logname = $agenttmp & "\servicemonitoring\" & $logname
$GlobalExclusion = $agenttmp & "\servicemonitoring\" & "globalexclusions.txt"
$PrivateExclusion = $agenttmp & "\servicemonitoring\" & "privateexclusions.txt"


;*****************************************************
; Read in the Global Exclusions file into the array
;*****************************************************

If fileexists($GlobalExclusion) Then
	If Not _FileReadToArray($Agenttmp & "\servicemonitoring\globalexclusions.txt",$aGlobal) Then
		_FileWriteLog($logname,"Error Could not read Globalexclusions.txt into array check file format")
		Exit
	EndIf
else 
	_FileWriteLog($logname,"Error Could not find file Globalexclusions.txt, file must exist")
	exit 
EndIf

;*****************************************************
; Read in the private exclusions file into the array
;*****************************************************
If fileexists($PrivateExclusion) Then

	If Not _FileReadToArray($Agenttmp & "\servicemonitoring\privateexclusions.txt",$aPrivate) Then
		_FileWriteLog($logname,"Error Could not read privateexclusions.txtt into array check file format")
		Exit
	EndIf
	$Custom = True 
	
else 
	_FileWriteLog($logname,"Error Could not find file privateexclusions.txt - no private exclusions will be added")
	$Custom = False ; no custom file exists so mark flag as false 
EndIf

_ArraySort($aGlobal) ; sort the arrays for binary search later

_ArraySort($aPrivate) 


 ; Run Function
;*****************************************************
MonitorServices()
Func MonitorServices()

While $x = 1 ; Never ending loop - to terminate application you need to end process
	
			$objWMI = ObjGet("winmgmts:\\localhost\root\CIMV2") ; WMI commands to interface to the system services
			$objItems = $objWMI.ExecQuery("Select * from Win32_Service where startmode like 'Auto' AND state like 'Stopped'", "WQL", 0x10 + 0x20)

			If IsObj($objItems) Then
				
			   For $objItem In $objItems
				;If $objitem.state = "Stopped" then ; if a service set to Auto has a stopped state then 
				 
					$resultglobal = _ArraySearch($aGlobal, $objitem.name) ; search global array for service name
									
					If $resultglobal = -1 Then ; We searched Global list and nothing was found move on to private list
						If $custom = True Then ; if a custom file exists
								$resultprivate = _ArraySearch($aPrivate, $objitem.name)		 ; Search private text file for service name
								If $resultprivate = -1 Then	; Not on custom ignore or global ignore - we need to action
									Serviceaction($objitem.name)
								endif 
						Else
							Serviceaction($objitem.name); Call serviceaction function and pass it our service name
						endif 		
					EndIf
									 
				;endif
				Next
			EndIf
			sleep($looptime) ; Default: sleep for 2 minutes before checking services again
			
wend

EndFunc

;*****************************************************

Func ServiceAction($servicename)
	
	;Check history array to see if we have seen this service recently if not add to history array
	;The history array is used so that if a service keeps stopping we don't just keep restarting if it fails more than 3 times
	;in a period of time we want to alert rather than just try to restart it although the app will keep restarting it.
	
		
	;write to eventlog that the service stopped for records
	Run("eventcreate /T Information /ID " & chr(34) & $EventID & chr(34) & " /L Application /SO " & Chr(34) & $EventSource & Chr(34) &" /D " & Chr(34) & "Service Monitoring " & $Servicename & " has stopped we are attempting to restart the service" & Chr(34), "", @SW_HIDE, 2)
	; Try to start the service
	runwait("net start " & chr(34) & $servicename & chr(34)) ;chr(34) = " we need to add this as the command needs the service wrapped in "" 
		
	;Check did the service restart work if not we need to log an error that will be picked up by Kaseya
	Sleep(3000) ;pause for 3 seconds
	if CheckServiceState($servicename) = 1 then 
			Run("eventcreate /T Error /ID " & chr(34) & $EventID & chr(34) & " /L Application /SO " & Chr(34) & $EventSource & Chr(34) &" /D " & Chr(34) & "Service Monitoring " & $Servicename & " has stopped restart attempt failed please action" & Chr(34), "", @SW_HIDE, 2)
	else 
			;Log to event log that the service did start successfully
			Run("eventcreate /T Information /ID " & chr(34) & $EventID & chr(34) & " /L Application /SO "& Chr(34) & $EventSource & Chr(34) & " /D " & Chr(34) & "Service Monitoring " & $Servicename & " has been restarted successfully" & Chr(34), "", @SW_HIDE, 2)
								
			$found = 0			;found to determine if we found the service name in the array or not
			If $Laststop > 0 then ; If laststop is zero it means there is nothing in the array so skip this section
					For $r = 0 to $Laststop - 1  ;loop the array up to the last value - 1
										
						
						if  _datediff('n',$aSvchistory[$r][2],_Now()) > 60 then ;Has this entry been in the array longer than 60 min if so delete it
							
							
							if $aSvchistory[$r][0] = $servicename then ; We found the service and it was last seen over 60 minutes ago reset the values back to the first round 
								$aSvchistory[$r][1] = 1
								$aSvchistory[$r][2] = _Now() ;Now = current time and date
								$found = 1 ; before we delete is this the service we are looking for if so flag $found
								ExitLoop
							Else 
								_arraydelete($aSvchistory,$r) ; delete entry from array
							Endif
						
						elseif $aSvchistory[$r][0] = $servicename Then 
							
							$found = 1 ; We found the service
							
							if $aSvchistory[$r][1] < 4 then ; Is the count less than 4 - if it is not < 4 we will alarm
								$aSvchistory[$r][1] = $aSvchistory[$r][1] + 1 ;We need to increment this value by 1, this is the count of how many times we have seen this service
								ExitLoop
							Else
								Run("eventcreate /T Error /ID " & chr(34) & $EventID & chr(34) & " /L Application /SO "& Chr(34) & $EventSource & Chr(34) & " /D " & Chr(34) & "Service Monitoring " & $Servicename & " has been restarted more than 3 times within the last 60 minutes please investigate the cause of this" & Chr(34), "", @SW_HIDE, 2)
								_arraydelete($aSvchistory,$r)	;delete the entry from the array
								ExitLoop 
							Endif 
						Endif 
					Next
			Endif 
		If $found = 0 then ; We did not find the service listed in our history array so we need to add it
			$aSvchistory[$Laststop][0] = $servicename
			$aSvchistory[$Laststop][1] = 1
			$aSvchistory[$Laststop][2] = _Now()
			$LastStop = $Laststop + 1
		Endif
			
	endif 
	
EndFunc

;*****************************************************

Func CheckServiceState($svc) ; Do a WMI query just for this service to see has it started if not report this back to previous script
	$objWMI = ObjGet("winmgmts:\\localhost\root\CIMV2") ; WMI commands to interface to the system services
			$objItems = $objWMI.ExecQuery("Select * from Win32_Service where Name like " & Chr(39) & $svc & Chr(39), "WQL", 0x10 + 0x20)

			If IsObj($objItems) Then
				For $objItem In $objItems
					
					If $objitem.state = "Stopped" then 
					
						Return(1) ; Return 1 if the service is stopped
					Else
						Return(0)
					EndIf
				next 
			
			EndIf
	
EndFunc

Func InstallService()
	_FileWriteLog($logname,"Installing service........")
		
	_Service_Create($sServiceName, $sServiceDisplayName, $SERVICE_WIN32_OWN_PROCESS, $SERVICE_AUTO_START, $SERVICE_ERROR_IGNORE,'"' & @WorkingDir & "\servicemonitoring" & '"')
	If @error Then
		_FileWriteLog($logname,"Problem Installing service, Error number is " & @error & @CRLF & " message : " & _WinAPI_GetLastErrorMessage())
		
	Else
		_FileWriteLog($logname,"Installation of service was successful")
	EndIf
	Exit
EndFunc   ;==>InstallService

Func RemoveService()
	_Service_Stop($sServiceName)
	_Service_Delete($sServiceName)
	If Not @error Then 	_FileWriteLog($logname,"Service Deleted Successfully")
	Exit
EndFunc   ;==>RemoveService
	
	
