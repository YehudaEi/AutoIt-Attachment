;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	AUTHOR: 	xxxxxxxxxxxxxxxx(Scooby)
;;	DATE:		JULY 11, 2005
;;	NAME:		NICKNAME_DELETE_SETUP
;;	SCRIPT:		AutoIt v3.1.1.56
;;	PURPOSE:	Installation script for NICKNAME_DELETE.EXE
;;				
;;
;;	DESCRIPTION:	Files added/installed:
;;						%systemdrive%\scripts\nickname_delete.exe
;;						
;;					Scheduled Task Added:
;;						Task Name	: ATn (n represents AT job number)
;;						Task Job	: Run %stemdrive%\scripts\nickname_delete.exe
;;						Task Days	: Tasks run Monday through Friday for one week
;;									  If jobs are created after their scheduled run time
;;									  their first run day will be the following day.
;;						Task Time	: The scheduled tasks will run at 11:00am and 3:00pm
;;
;;					Services Effected:
;;						Service Name: Task Scheduler (Scheduler)
;;						Start Mode	: Service is set to Automatic
;;						State State	: Service is set to 'Started"
;;
;;	WMI Scheduled Task Paramter Cheat Sheet:
;; 	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/create_method_in_class_win32_scheduledjob.asp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Set Options/Includes

OPT ("RunErrorsFatal", 0)
OPT ("MustDeclareVars", 1)
OPT ("TrayIconDebug", 1)
OPT ("WinTitleMatchMode", 2)
OPT ("SendKeyDelay", 2)
#Include <string.au3>
#NoTrayIcon0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Declare Variables/Constants/Arrays

Const $INSTALLFILE = "NICKNAME_DELETE.LOG"
Const $SSERVICE = "Schedule"
Const $SSTARTMODE = "Auto"
Const $SSTARTSTATE = "Running"
Const $STRTIME1 = "1100" 
Const $STRTIME2 = "1500" 
Const $SYSTEMDRIVE = EnvGet("SystemDrive")
Dim $COLITEMS
Dim $COLLISTOFSERVICES
Dim $COPYCOMPLETE
Dim $DIRATTRIB
Dim $DIRCREATED
Dim $DIREXISTING
Dim $ERRJOBCREATED
Dim $JOBID1
Dim $JOBID2
Dim $JOBID_FILE
Dim $LOG
Dim $OBJITEM
Dim $OBJNEWJOB
Dim $OBJSERVICE
Dim $OBJWMISERVICE
Dim $SETMODE
Dim $SETSTATE
Dim $STIMEZONE
Global $WRITELOG
Global $SCOMPUTER = @ComputerName

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	FileInstalls/FileCopys


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;CREATE '%SYSTEMDRIVE%\SCRIPTS' DIRECTORY IF NOT EXISTING
If Not FileExists($SYSTEMDRIVE & "\scripts") Then
	DirCreate($SYSTEMDRIVE & "\scripts")
	$DIREXISTING = "NO"
Else
	$DIREXISTING = "YES"
EndIf




;PLACE A DATE AND TIME STAMP IN THE LOG FILE
$LOG = FileOpen($SYSTEMDRIVE & "\scripts\" & $INSTALLFILE, 1)
FileWriteLine($LOG, @CRLF)
FileWriteLine($LOG, @CRLF)
FileWriteLine($LOG, "***" & @MON & "-" & @MDAY & "-" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & "***")
FileClose($LOG)




;LOG WHETHER '%SYSTEMDRIVE%\SCRIPTS' EXISTED PRIOR TO INSTALLATION
;IF IT NEEDS TO BE CREATED LOG WHETHER OR NOT IT IS CREATED SUCCESSFULLY
If $DIREXISTING = "NO" And FileExists($SYSTEMDRIVE & "\scripts") Then
	$DIRCREATED = "YES"
Else
	$DIRCREATED = "NO"
EndIf
$WRITELOG = _Log("Directory '" & $SYSTEMDRIVE & "\scripts' existed", $DIREXISTING)
$WRITELOG = _Log("Directory '" & $SYSTEMDRIVE & "\scripts' created", $DIRCREATED)




;MAKES THE '%SYSTEMDRIVE%\SCRIPTS' DIRECTORY HIDDEN IF NOT ALREADY
$DIRATTRIB = FileGetAttrib($SYSTEMDRIVE & "\scripts")
If StringInStr($DIRATTRIB, "H") Then 
	$WRITELOG = _Log("Directory attribute set to 'HIDDEN'", "YES")
Else
	$WRITELOG = _Log("Directory attribute set to 'HIDDEN'", "NO")
	FileSetAttrib($SYSTEMDRIVE & "\scripts", "+H")
	$DIRATTRIB = FileGetAttrib($SYSTEMDRIVE & "\scripts")
	If StringInStr($DIRATTRIB, "H") Then 
		$WRITELOG = _Log("Directory attribute successfully changed to 'HIDDEN'", "YES")
	Else
		$WRITELOG = _Log("Directory attribute successfully changed to 'HIDDEN'", "NO")
	EndIf
EndIf




;VERIFY WINDOWS MANAGEMENT INSTRUMENTATION (WMI) IS INSTALLED (REQUIRED FOR NT WORKSTATIONS
;SEE KB815177
If Not FileExists(@SystemDir & "\WBEM") Then
	$WRITELOG = _Log("Is Windows Management Instrumentation (WMI) installed?", "NO")
	$WRITELOG = _Log("WMI is required to continue.....", "SCRIPT TERMINATING")
	Exit
EndIf




;PLACES COPY OF THE NICKNAME_DELETE.EXE SCRIPT IN '%SYSTEMDRIVE%\SCRIPTS' TO BE RUN AT BY SCHEDULED TASK
FileInstall("c:\includescripts\nickname_delete.exe", $SYSTEMDRIVE & "\scripts\NICKNAME_DELETE.EXE", 1)
If FileExists($SYSTEMDRIVE & "\scripts\nickname_delete.exe") Then
	$COPYCOMPLETE = "YES"
Else
	$COPYCOMPLETE = "NO"
EndIf
$WRITELOG = _Log("File copied to '" & $SYSTEMDRIVE & "\scripts' successfully", $COPYCOMPLETE)




;VERIFY SERVICE REQUIRED FOR TASK SCHEDULER IS SETUP CORRECTLY
$OBJWMISERVICE = objGet ("winmgmts:\\" & $SCOMPUTER & "\root\cimv2")
$COLLISTOFSERVICES = $objWMIService.ExecQuery ("Select * from Win32_Service Where Name ='" & $SSERVICE & "'")
For $OBJSERVICE in $COLLISTOFSERVICES
	$WRITELOG = _Log("Task Scheduler initial Start Mode", $OBJSERVICE.STARTMODE)
	$WRITELOG = _Log("Task Scheduler initial State Mode", $OBJSERVICE.STATE)
	
	If $OBJSERVICE.STARTMODE <> $SSTARTMODE Then
		$SETMODE = _SetStartMode($SSERVICE, $SSTARTMODE, $SCOMPUTER)
	EndIf
	
	If $OBJSERVICE.STATE <> $SSTARTSTATE Then
		$SETSTATE = _SetStartState($SSERVICE, $SSTARTSTATE, $SCOMPUTER)
	EndIf
Next




;GET TIMEZONE OFFSET IN ORDER TO SET SCHEDULED TASK RUN TIME
$OBJWMISERVICE = objGet ("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $SCOMPUTER & "\root\cimv2")
$COLITEMS = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For $OBJITEM in $COLITEMS
	$STIMEZONE = $OBJITEM.CURRENTTIMEZONE
Next 




;CREATE SCHEDULED TASK #1 TO RUN FOR 5 BUSINESS DAYS AT 9:00AM AND THEN DELETE ITSELF
$OBJWMISERVICE = objGet ("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $SCOMPUTER & "\root\cimv2")
$OBJNEWJOB = $objWMIService.Get ("Win32_ScheduledJob")
$ERRJOBCREATED = $objNewJob.Create ($SYSTEMDRIVE & "\scripts\nickname_delete.exe", "********" & $STRTIME1 & "00.000000" & $STIMEZONE,, 31,,, $JOBID1) 
$JOBID_FILE = FileOpen($SYSTEMDRIVE & "\scripts\AT" & $JOBID1 & ".TXT", 2)




;CREATE SCHEDULED TASK #2 TO RUN FOR 5 BUSINESS DAYS AT 3:00PM AND THEN DELETE ITSELF
$OBJWMISERVICE = objGet ("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $SCOMPUTER & "\root\cimv2")
$OBJNEWJOB = $objWMIService.Get ("Win32_ScheduledJob")
$ERRJOBCREATED = $objNewJob.Create ($SYSTEMDRIVE & "\scripts\nickname_delete.exe", "********" & $STRTIME2 & "00.000000" & $STIMEZONE,, 31,,, $JOBID2) 
$JOBID_FILE = FileOpen($SYSTEMDRIVE & "\scripts\AT" & $JOBID2 & ".TXT", 2)




Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	START FUNCTIONS
;;

;LOG FILE ROUTINE - OPENS AND CLOSES FILE FOR EACH ITERATION
;OPENING AND CLOSING WILL ALLOW FOR A PARTIAL LOG IF THE SCRIPT CRASHES/EXITS AT ANY POINT
Func _Log($SACTION, $SRESULT)
	Local $NACTIONLEN
	Local $NBUFFER
	Local $SBUFFER
	Local $NDESCRIPTIONLEN = 55
	
	$NACTIONLEN = StringLen($SACTION)
	If $NACTIONLEN < $NDESCRIPTIONLEN Then
		$NBUFFER = $NDESCRIPTIONLEN - $NACTIONLEN
		$SBUFFER = _StringRepeat(" ", $NBUFFER)
	Else
		$SBUFFER = " "
		$SACTION = StringLeft($SACTION, $NDESCRIPTIONLEN - 1)
	EndIf
	$LOG = FileOpen($SYSTEMDRIVE & "\scripts\" & $INSTALLFILE, 1)
	FileWriteLine($LOG, "          " & $SACTION & $SBUFFER & ": " & $SRESULT)
	FileClose($LOG)
EndFunc   ;==>_Log




;SET SERVICES STARTMODE TO '$sStartMode' (AUTOMATIC IN THIS INSTANCE)
Func _SetStartMode($SSERVICE, $SSTARTMODE, $SCOMPUTER)
	
	Local $OBJWMISERVICE
	Local $OBJMETHOD
	Local $OBJINPARAM
	Local $OBJOUTPARAM
	Local $SGETRETURNVALUE
	Local $SSTARTVALUE = "Automatic"
	
	$OBJWMISERVICE = objGet ("winmgmts:{impersonationLevel=impersonate}//" & $SCOMPUTER & _
			"/root/cimv2:Win32_Service=" & Chr(34) & $SSERVICE & Chr(34))
	$OBJMETHOD = $objWMIService.Methods_ ("ChangeStartMode")
	$OBJINPARAM = $objMethod.inParameters.SpawnInstance_ ()
	$OBJINPARAM.STARTMODE = $SSTARTVALUE
	$OBJOUTPARAM = $objWMIService.ExecMethod_ ("ChangeStartMode", $OBJINPARAM)
	
	$SGETRETURNVALUE = _GetReturnValue($OBJOUTPARAM.RETURNVALUE, $OBJWMISERVICE.NAME)
	$WRITELOG = _Log("Result of Start mode change to " & $SSTARTMODE, $SGETRETURNVALUE)
EndFunc   ;==>_SetStartMode




;SET SERVICES RUNNING STATE TO '$sState' (START IN THIS INSTANCE)
Func _SetStartState($SSERVICE, $SSTATE, $SCOMPUTER)
	Local $OBJSERVICE
	Local $OBJWMISERVICE
	Local $COLLISTOFSERVICES
	Local $SSTATEVALUE = "Start"
	Local $SRETURNVAL
	Local $SGETRETURNVALUE
	
	$OBJWMISERVICE = objGet ("winmgmts:\\" & $SCOMPUTER & "\root\cimv2")
	$COLLISTOFSERVICES = $objWMIService.ExecQuery ("Select * from Win32_Service Where Name ='" & $SSERVICE & "'")
	For $OBJSERVICE in $COLLISTOFSERVICES
		Select
			Case $SSTATEVALUE = "Start"
				$SRETURNVAL = $objService.StartService ()
			Case $SSTATEVALUE = "Stop"
				$SRETURNVAL = $objService.StopService ()
			Case $SSTATEVALUE = "Pause"
				$SRETURNVAL = $objService.PauseService ()
			Case $SSTATEVALUE = "Resume"
				$SRETURNVAL = $objService.ResumeService ()
		EndSelect 
	Next
	$SGETRETURNVALUE = _GetReturnValue($SRETURNVAL, $SSERVICE)
	$WRITELOG = _Log("Result of State mode change to " & $SSTATE, $SGETRETURNVALUE)
EndFunc   ;==>_SetStartState




;DECIPHERING RETURN VALUES FROM THE 'STARTMODE' AND 'RUNNING STATE' FUNCTIONS
Func _GetReturnValue($SRETURNVALUE, $SSERVICE)
	Local $SRETURNVALUEDESC
	
	If $SRETURNVALUE = 0 Then
		$SRETURNVALUE = "Mode of " & $SSERVICE & " changed successfully"
	Else
		Select
			Case $SRETURNVALUE = 1
				$SRETURNVALUEDESC = "Not Supported"
			Case $SRETURNVALUE = 2
				$SRETURNVALUEDESC = "Access Denied"
			Case $SRETURNVALUE = 3
				$SRETURNVALUEDESC = "Dependent Services Running"
			Case $SRETURNVALUE = 4
				$SRETURNVALUEDESC = "Invalid Service Control"
			Case $SRETURNVALUE = 5
				$SRETURNVALUEDESC = "Service Cannot Accept Control"
			Case $SRETURNVALUE = 6
				$SRETURNVALUEDESC = "Service Not Active"
			Case $SRETURNVALUE = 7
				$SRETURNVALUEDESC = "Service Request Timeout"
			Case $SRETURNVALUE = 8
				$SRETURNVALUEDESC = "Unknown Failure"
			Case $SRETURNVALUE = 9
				$SRETURNVALUEDESC = "Path Not Found"
			Case $SRETURNVALUE = 10
				$SRETURNVALUEDESC = "Service Already Running"
			Case $SRETURNVALUE = 11
				$SRETURNVALUEDESC = "Service Database Locked"
			Case $SRETURNVALUE = 12
				$SRETURNVALUEDESC = "Service Dependency Deleted"
			Case $SRETURNVALUE = 13
				$SRETURNVALUEDESC = "Service Dependency Failure"
			Case $SRETURNVALUE = 14
				$SRETURNVALUEDESC = "Service Disabled"
			Case $SRETURNVALUE = 15
				$SRETURNVALUEDESC = "Service Logon Failure"
			Case $SRETURNVALUE = 16
				$SRETURNVALUEDESC = "Service Marked For Deletion"
			Case $SRETURNVALUE = 17
				$SRETURNVALUEDESC = "Service No Thread"
			Case $SRETURNVALUE = 18
				$SRETURNVALUEDESC = "Status Circular Dependency"
			Case $SRETURNVALUE = 19
				$SRETURNVALUEDESC = "Status Duplicate Name"
			Case $SRETURNVALUE = 20
				$SRETURNVALUEDESC = "Status Invalid Name"
			Case $SRETURNVALUE = 21
				$SRETURNVALUEDESC = "Status Invalid Parameter"
			Case $SRETURNVALUE = 22
				$SRETURNVALUEDESC = "Status Invalid Service Account"
			Case $SRETURNVALUE = 23
				$SRETURNVALUEDESC = "Status Service Exists"
			Case $SRETURNVALUE = 24
				$SRETURNVALUEDESC = "Service Already Paused"
			Case Else
				$SRETURNVALUEDESC = "Description Unavailable"
		EndSelect
		$SRETURNVALUE = "Mode of " & $SSERVICE & " change failed - " & $SRETURNVALUEDESC
	EndIf
	Return $SRETURNVALUE
EndFunc   ;==>_GetReturnValue

;;
;;	END FUNCTIONS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;