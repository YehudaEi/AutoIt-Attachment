	#include <Misc.au3>
	#include <Array.au3>
	#include <ServiceControl.au3>
	#include <GUIConstants.au3>
	#include <A3LClipboard.au3>
	#include <A3LScreencap.au3>
	#include <string.au3>

#region globalVar
	Global $AwhiteList = StringSplit("POWERPNT.EXE|mmc|IExplorer.exe|notepad.exe|RunAsSvc.exe|AutoIt3|SciTE.exe|taskmgr|blackandwhite|wmiprvse.exe|csrss.exe|nlsvc.exe|winlogon.exe|svchost.exe|ctfmon.exe|Explorer.exe|alg.exe|spoolsv.exe|lsass.exe|services.exe|System|smss.exe|ati2evxx.exe|atiptaxx.exe|rundll32.exe", "|")
	Global $Ablacklist = StringSplit("tlntsvr.exe|firefox.exe|daemon.exe|winampa.exe|msnmsgr.exe", "|")
	Global $Sblacklist = StringSplit("Tomcat5|irmon|RemoteRegistry|TlntSvr|Messenger|usnsvc", "|")
	global $Wblacklist = StringSplit("denied|Systeemeigenschappen", "|")
	global $userid = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\", "AltDefaultUserName") ;service runs as system account @UserName returns 'system'
	global $bevestigwindow
	global $notificationList
	global $resterend
	global $initialrun=0 ;notify GUI
#endregion

#region to see what to do with
	$bw_version = "Black and white 1.1"
	if WinExists($bw_version) then 
		MsgBox(64, "double run", "proces draait al") 
		Exit ;script is already running
	EndIf
	AutoItWinSetTitle($bw_version)
	opt("TrayIconHide", Not opt("TrayIconHide", "Default"))
#endregion
#region Hoofdprogramma
	$logFile = "CompleteLog.ini"
	$capspath = @DesktopDir&"\projecten\cap2\";
	$starttijd = "04:50"
	$eindtijd = "16:20"
	
	_CreateMainGui()
	DirCreate($capspath)
	_initiateLogFile($logfile)
	while  _checkTimer($starttijd, $eindtijd) 
		sleep(998)
	WEnd
	_portListener($logfile)
	_ListAllServices()
	while 1 
		_checkTimer($starttijd, $eindtijd)
		_portListener($logfile, "21|80|8080")
		_windowcheck($capspath)
		;_Processchek($capspath) 
		_Checkservices($capspath)
		sleep(100)
	WEnd
	
	func _exit()
	
	Exit
	;_logOffPC()
EndFunc
#endregion

#region GUI 
func _CreateMainGui()
	opt("GUIOnEventMode", 1)
	;createMainwindow
		opt("GUIOnEventMode", 1)
		$mainwindow=GUICreate("Examen", 310, 500,$DS_SETFOREGROUND, $WS_EX_DLGMODALFRAME)
		GUISetBkColor(0xffffcc)
		GUISetOnEvent($GUI_EVENT_CLOSE, "_createConfirmGui")
		GUICtrlSetLimit(-1,200)	; to limit horizontal scrolling
		
		$resterend=GUICtrlCreateEdit("test", 5, 5, 300, 25, $es_readonly)
		guictrlsetfont($resterend, 14, 500, '', "Arial")
		GUICtrlSetBkColor ($resterend, 0xffcc66 )
		GUICtrlSetColor($resterend,0xCC0033)
		
		GUICtrlCreateLabel("student: ", 25, 35, 100, 20)
		guictrlsetfont(-1, 8, 600, '', "Verdana")
		GUICtrlCreateLabel(StringUpper($userid), 160, 35, 175, 20)
		guictrlsetfont(-1, 8, 500, 2, "Verdana")
		
		GUICtrlCreateLabel("computer: ", 25, 60, 100, 20)
		guictrlsetfont(-1, 8, 600, '', "Verdana")
		GUICtrlCreateLabel(@computername, 160, 60, 175, 20)
		guictrlsetfont(-1, 8, 500, 2, "Verdana")
	
		GUICtrlCreateLabel("overtredingen", 25, 80, 200, 20)
		guictrlsetfont(-1, 8, 600, '', "Verdana")
		$notificationList=GUICtrlCreateList ("",40,100,250,300, $LBS_NOSEL, $WS_EX_TOPMOST)
		GUICtrlSetBkColor ($notificationList, 0xCCCCCC)
	
		$EndSession = GUICtrlCreateButton("examen stoppen", 100, 425, 100, 50)
		GUICtrlSetOnEvent($EndSession, "_createConfirmGui")
		
		GUISetState(@SW_SHOW)
EndFunc
func _createConfirmGui()
	
	$bevestigwindow=GUICreate("examen stoppen?", 280, 150)
	GUISetFont(10, 450, "", "times new roman")
	GUICtrlCreateLabel("Bent u zeker dat je je examen wilt beëindigen?", 5, 5)
	GUICtrlCreateLabel("Als je op ja klikt wordt je examen beëindigd", 15,25)
	GUICtrlCreateLabel("en wordt je automatisch afgemeld uit windows", 8, 45)
	GUICtrlCreateLabel("klik op nee om je examen voort te zetten.", 20, 70)
	$EndSession = GUICtrlCreateButton("ja", 20, 100, 100, 25)
	$ResumeSession = GUICtrlCreateButton("nee", 150, 100, 100, 25)
	GUICtrlSetOnEvent($ResumeSession, "_resume")
	GUICtrlSetOnEvent($EndSession, "_exit")
	GUISetState(@SW_SHOW)

EndFunc
Func _notifyGui($tijd, $item)
	if $initialrun=0 Then
		GUICtrlSetData($notificationList, $tijd&" onrechtmatig gebruik van "&$item)
		GUISetState(@SW_RESTORE)
	EndIf
	
EndFunc
func _resume()
	GUIDelete($bevestigwindow)
EndFunc
#endregion

#region Logging
Func _UpdateLog($file, $section, $value, $key=-1)
	;$encrypt = _StringEncrypt(1, $value, "a"); om decrypt, de 1 in 0 wijzigen regel afgezet wegens zwaar
	switch $key
		case -1
			IniWriteSection($file, $section, $value)
		case Else
			iniwrite($file, $section, $key, $value) 
	EndSwitch
	
EndFunc ;update logfile
func _initiateLogFile($logfile)
	$stamp =_createTimestamp(0)
	_updateLog($logfile, "Studenteninfo", "Info over de huidige gebruiker.","/")
	_UpdateLog($logfile, "HIGH ALERT - programmatoegang", "Inbreuk op de applicatieblacklist. Timestamp van de inbreuk en de executable","/")
	_UpdateLog($logfile, "HIGH ALERT - window", "Inbreuk op de windowblacklist. Timestamp van de inbreuk en naam van het venster","/")
	_UpdateLog($logfile, "HIGH ALERT - service", "Inbreuk op de service blacklist. Timestamp van de inbreuk en de naam van de service.","/")
	_UpdateLog($logFile, "LOW ALERTS", "Programma die werden gesloten.  Deze staan noch op de black noch op de whitelist","/")
	_UpdateLog($logfile, "INITIAL - window", "lijst van alle windows die geopend zijn tijdens de sessie. (1 entry per window)","/")

	_UpdateLog($logFile, "Studenteninfo", $userid, "studentennummer")
	_UpdateLog($logFile, "Studenteninfo", @ComputerName, "pc nummer")
	_UpdateLog($logFile, "Studenteninfo", @IPAddress1, "ip adres")
	_UpdateLog($logFile, "Studenteninfo", "startsession", $stamp)
EndFunc
func _TakeScreencap($capspath, $stamp)
	GUISetState(@SW_HIDE)
	send("{printscreen}")
	_Clip_Empty()
	$sFileName= $capspath&"cap_"&$userid&"_"&$stamp&".bmp"
	_ScreenCap_Capture($sFileName)
	_Clip_SetData($sFileName)
	GUISetState(@SW_SHOW)
EndFunc
#endregion

#region varia
func _createTimestamp($mode)
	$stamp = 0
	switch $mode
	case 0
		$stamp = @MDAY&"/"&@MON&"/"&@YEAR&" : "&@HOUR&":"&@MIN&":"&@sec
	case 1
		$stamp = @HOUR&":"&@MIN&":"&@sec
	case 2
		$stamp = @MDAY&"/"&@MON&"/"&@YEAR
	EndSwitch
	return $stamp		
EndFunc
func _logOffPC()
	;Shutdown(0)
EndFunc
#endregion
#region black and whitelist
func _windowcheck($capspath)
	$winlist = WinList()
	for $i = 1 to ubound($winlist)-1
			$found = "INITIAL"
			for $x = 1 to UBound($WBlacklist)-1
				if StringInStr($WBlacklist[$x],$winlist[$i][0] ) Then
					$stamp = _createtimestamp(1)
					_TakeScreencap($capspath, $stamp)
					WinClose($WBlacklist[$x])
					_notifyGui($stamp, "w  "&$winlist[$i][0])
					$found = "HIGH ALERT"
				EndIf
			Next
			$stamp=_createTimeStamp(1)
			_UpdateLog($logFile, $found&" - window", $stamp, $winlist[$i][0])
	next ;end for WinList

EndFunc
Func _Processchek($capspath) 
   $process = ProcessList()
   for $x = 0 to UBound($process) -1  ;loop door de lijst van alle draaiende processen
		$result= "denied"
		$sev = "low"
		for $i = 1 to UBound($Ablacklist) - 1  ;loop door de blacklist
			If StringInStr($process[$x][0], $ABlacklist[$i]) Then ;proces van bl draait
				$sev="HIGH ALERT - programmatoegang"
			EndIf
		Next;end bl for
		if $result="denied" then ;proces not in blacklist
			for $i = 1 to UBound($AwhiteList) - 1 ;loop door de lijst van toegestane processen
				if StringInStr($process[$x][0], $AwhiteList[$i]) then ;proces van wl draait
					$result=0
					$result="approved"
				EndIf
			Next ;end wl for
		EndIf
		if StringCompare($result,"denied")=0 Then
			;ProcessClose($process[$x][0])
			$PID= ProcessExists($process[$x][0])
			$Timestamp = "a     "&@HOUR&":"&@MIN&":"&@sec 
			if $PID Then
				_UpdateLog($logFile, "programmaAccess "&$sev, $Timestamp,"id:"&$PID&" : "&$process[$x][0]&" ") 
				if $sev="HIGH ALERT - programmatoegang" Then
					_TakeScreencap($capspath, $timestamp)
					_notifyGUI($Timestamp, $process[$x][0])
				EndIf ;endif sev=high			
				RunWait("taskkill.exe /f /pid "&$PID,'', @sw_hide)
				
			EndIf ;endif $spid
		EndIf ;endif stringcompare denied
	Next ;for processlist
EndFunc   ;_CloseProcess
func _ListAllServices()
	$strComputer = "."
	$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\"&$strComputer&"\root\cimv2")
	
	if $objWMIService = 0 Then
		_updateLog($logFile, "initialServiceList", "failed", "WMI Connection Failure")
	EndIf
	
	$ServiceList = $objWMIService.execQuery("Select * from Win32_Service ")
	for $service in $ServiceList
		if _serviceRunning("", $service.Name) Then
			$timestamp = _createtimestamp(1)
			_updateLog($logFile, "initialServiceList", "running", $timestamp&"  :   "&$service.name)
		EndIf
	next
	
EndFunc ;initial list of running services
Func _Checkservices($capspath)
	for $x =1 to UBound($Sblacklist) -1
		$service = $Sblacklist[$x]
		if (_ServiceExists("",$service)) Then
			if(_ServiceRunning("",$service)) Then
				$Timestamp = "s     "&@HOUR&":"&@MIN&":"&@sec
				_TakeScreencap($capspath, $timestamp)
				_UpdateLog($logFile, "Services", $Timestamp, $service)
;				MsgBox(64, "Niet toegestane service actief", "De service " &$service& " mag niet gebruikt worden tijdens het examen en is terug stopgezet!")
				_notifyGUI($Timestamp, $service) 
				_stopService("",$service)
				if(_serviceRunning("",$service)) Then
						MsgBox(1, "failed stopping service", $service)
				EndIf
			EndIf
		EndIf
	next
EndFunc ;Checkservices
#endregion
#region netstat
;--------------------------------------------------------------------------------------------
; Function: _portListener(logfile [,$portlist])
;	$logfile  = filepath and filename of the file to whom the logentries will be written.
;				if no path, it takes the working dir of the application
;	$portlist = (optional) list of ports (seperated by a | that needs to be monitored)
;
;Returns:
;	nothing
;----------------------------------------------------------------------------------------------
func _portListener($logfile, $portlist=0)	
	$resultnetstat = _doNetstat()
	Switch $portlist
		case 0
			_analyseNetstatresult($resultNetstat, $logfile)
		case Else
			_analyseNetstatresult($resultNetstat, $logfile, $portlist)
	EndSwitch
EndFunc
Func _DoNetstat()
local $netstat

$netstat_processId = run(@comspec & " /c netstat -an", '', @sw_hide,2)
while 1
	$netstatResult = StdoutRead($netstat_processId)	
	if @error then 
		ExitLoop
		return - 1
	EndIf
	if $netstatResult Then
		$netstat &= $netstatResult
	Else	
		sleep(10)
	endif
WEnd
Return $netstat
EndFunc
func _AnalyseNetstatResult($netstatresult, $logile, $port=0)
	local $portaction
	local $category
	$output_netstat = $netstatresult
	$output_netstat = StringSplit($output_netstat, @crlf)
	for $i = 8 to UBound($output_netstat) - 1  ;i=8 om de voorgaande columheader en titel niet op te nemen
		
		if $output_netstat[$i]<>"" then ;als geen lege lijn, behanel de regel 
			$category = "netstat"
			$entryfound = true ;hulpvar
			if $port <> 0 then
				$portlist = StringSplit($port, "|")
				$entryfound=FALSE
				for $z = 1 to UBound($portlist) -1
					if (StringInStr($output_netstat[$i], ":"&$portlist[$z])) Then 
						$entryfound = True
						$category = "monitoring van poort "&$portlist[$z]
					EndIf
				Next
			Endif ;$port not 0
			if $entryfound then
				Select   ;defines the action taken by port
				case StringInStr($output_netstat[$i], "luisteren")
					$action = "bezig met luisteren"
				case StringInStr($output_netstat[$i], "ESTABLISHED")
					$action = "ESTABLISHED"
				case StringInStr($output_netstat[$i], "time_wait")
					$action = "TIMEWAIT"
				case StringInStr($output_netstat[$i], "SYN_SENT")
					$action = "SYN_SENT"
				Case StringInStr($output_netstat[$i], "CLOSE_WAIT")
					$action = "close_wait"
				case Else
					$action = "none"			
				EndSelect ;end select of actions
				if $action <> "none" Then
					$output_netstat[$i]=StringStripWS($output_netstat[$i], 14)
					$output_line = StringSplit($output_netstat[$i], " ")	
					$local_address = $output_line[3]
					$external_address = $output_line[4]
					$stamp=_createtimestamp(0)
					switch $category
					case "Netstat"
							_updatelog($logfile, $category, $stamp, "local: "&$local_address&"external: "&$external_address&"Status: "&$action)
						case Else
							$stamp = _createTimestamp(1)
							_updatelog($logfile, $category, $stamp, "local: "&$local_address&"external: "&$external_address&"Status: "&$action)
					EndSwitch
				EndIf ;if action not none
			endif ;if entry found
		endif ;if no empty line
	Next ;for each netstatline
EndFunc
#end
#region timecheck
Func _checkTimer($starttijd, $eindtijd)
	$temp = StringSplit($starttijd, ":")
	$startuur=$temp[1]
	$startminuut=$temp[2]
	$temp=StringSplit($eindtijd, ":")
	$einduur=$temp[1]
	$eindminuut=$temp[2]
	$tijdnu= @hour&@min
	$started=0
	$starttijd=$startuur&$startminuut
	$eindtijd=$einduur&$eindminuut
	if int($starttijd) <= int($tijdnu) and int($tijdnu) <= int($eindtijd) Then
		;MsgBox(0, "started", "m")
		$started = 1
		GuiCtrlSetData($resterend, "examen eidigt over: "&(($einduur*60+$eindminuut)-(@hour*60+@min))& "minuten", "")
		return False
	EndIf
		
	if $started=0 Then
		MsgBox(0, "started", "sh"&$startuur&" sm"&$startminuut&" eh"&$einduur&" em"&$eindminuut)
		GUICtrlSetData($resterend, "Je examen is van "&$startuur&":"&$startminuut&" tot "&$einduur&":"&$eindminuut, "")
		return True
	EndIf
EndFunc
#endregion