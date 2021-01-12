Opt("ExpandVarStrings",1)
Opt("MustDeclareVars",1)
Opt("RunErrorsFatal",0)
#include <Array.au3>

;------------------------------------------------------------------------------------------------------
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Shaun Dunmall
; eMail:		  sdunmall@gmail.com
;------------------------------------------------------------------------------------------------------

TrayTip(@ScriptDir,"",500)

;Version	Description of Change
;1.0.0		Released into the wild.
;1.0.1		Changed processAuditRecording to seperate Users and Machines into different directories.
;1.1.0		Added File Existence auditing capabilities with the "FILEEXISTS" and "FILENOTEXISTS" actions.
;1.1.1		Amended File existence routine to allow for wildcard checking by removing * and ? where appropriate in the audit filenames
;1.1.2		Added some missing comments in the inital RUNLIST text file creation function, and some blank lines.
;			Also removed a few redundant lines of code from the deleteOldCopies function.
;1.1.3		Added $logThis global variable - to which OSVersion and OSBuild were added.
;1.1.4		Added password auditing facility, and move RELOAD action up, to be an early action.
;1.2.0		Refactored action routines - tidied up and 
;				combined/renamed ISRUNNING and ISNOTRUNNING into PROCESS, and FILEEXISTS and FILENOTEXISTS into FILE.
;1.3.0		Changed the order of the fields in RUNLIST.TXT
;			Combined USER and MACHINE fields to be one and the same.
;			Made two fields a minimum requirement - index and action.
;1.3.1		Corrected missing CheckPassword action
;1.3.2		Some general tidying up and refactoring.


Global $version="1.3.2"

; ********************************************************************************

;Default administrators - can be changed with an ADMINS action.
;THIS MUST BE YOU AND YOU MUST BE AN ADMINISTRATOR OR THE DEFAULT DIRECTORIES And
;EXAMPLE RUNLIST.TXT WON'T BE CREATED UPON FIRST RUN.
Global $admins="administrator sdunmall"

;Default directory that the script is run from.
;THIS MUST BE WHERE THE SCRIPT RUNS FROM OR THINGS WON'T WORK
Global $scriptDirectory="c:\RunNow"

;Default script name.
;The actual name of the running script may vary if RELOAD actions are used,
;in which case temporary file names are used so that the updates can take place.
;IF YOU CHANGE THE NAME OF THE SCRIPT, YOU MUST CHANGE IT HERE TOO.
Global $scriptDefaultName="RunNow"

; *********************************************************************************

;Default duration that a timed action is valid for after its start time
Global $defaultDuration=15	; Minutes

;Default time between checking for things to Do
;Can be changed with a SLEEP action
Global $sleepTime=20		; Seconds (Duty Cycle)


;-----------------------------
Global $indexField=0
Global $actionField=1
Global $machineField=2
Global $whenField=3
Global $durationField=4
;-----------------------------
Global $MaxRunListFieldCount=5
Global $MinRunListFieldCount=2
;-----------------------------

	
Global $activeUsers =  "$scriptDirectory$\AuditByUsers\@UserName@.txt"
Global $activeMachines = "$scriptDirectory$\AuditByMachines\@ComputerName@.txt"
Global $passwordAudit = "$scriptDirectory$\AuditByPassword\"
Global $isRunningProcessDir = "$scriptDirectory$\AuditByProcess\"
Global $fileExistsAuditDir = "$scriptDirectory$\AuditByFile\"
Global $RunList=$scriptDirectory&"\RunList.txt"
Global $actionedByMachine = $scriptDirectory & "\ActionedByMachine\" &@ComputerName&".txt"
Global $actionedByUser = $scriptDirectory & "\ActionedByUser\" &@UserName&".txt"
Global $logThis = "@ComputerName@ @IPAddress1@ @UserName@ @MDAY@/@MON@/@YEAR@ @HOUR@:@MIN@ Version:$Version$ @OSVersion@:@OSBuild@"

;Arbitrary number of Entries that the timetable should hold
;This is Action entries only and doesn't include comment lines.
Global $MaxEntries=1000

;Make sure that only ONE copy is running at once.
checkForProperRunning()

;Ensure that all old temporary copies are deleted.
;Temporary copies are used when updating to a new version (RELOAD action)
deleteOldCopies()


;START of MAIN loop ------------------------------------------------------------------------------------
While 1
	
	;Create/clear array to hold all the RUNLIST entries
	Global $RunListEntry[$MaxEntries][$MaxRunListFieldCount]
	
	;This will hold the number of RUNLIST entries, once the RUNLIST files has been read in.
	Global $EntryCount=0
	
	Do
		;Load the TimeTable (RUNLIST.TXT) and make a note of how many entries it contains in $EntryCount.
		;If $EntryCount is false, i.e. no entries, then keep trying.
		$EntryCount=loadTimeTable()
	until $EntryCount
	
	
	;Okay, if we got this far, then the RUNLIST file has been loaded successfully.
	;Work through the list a line at a time.
	For	$this = 1 to $EntryCount
		
		;Does as it says on the tin, this should be fairly self explanatory.
		If itIsToday($this) and theTimeIsRight($this) Then
			If (forThisMachine($this) and hasNotDone($this,$actionedByMachine)) or (forThisUser($this) and hasNotDone($this,$actionedByUser)) then
				if StringUpper($RunListEntry[$this-1][$actionField])="QUIT" then Exit
				markAsDone($this,$actionedByMachine)
				markAsDone($this,$actionedByUser)
				performAction($this)
			EndIf
		EndIf
	Next
	Sleep($sleepTime*1000)
WEnd
Exit	
;END of MAIN loop ------------------------------------------------------------------------------------


;Make sure that there is only one copy running at a time.
;Also, make sure that we are running from our local C: drive.

Func checkForProperRunning()
	
	if StringLeft(@ScriptDir,1)<>"Z" Then
		; Do nothing as we're running locally
	Else
		if alreadyRunning() then
			exit ; As we don't want more than one copy of me running at once.
		Else
			; Copy from Z: drive to local drive
			FileCopy($scriptDirectory&"\"&$scriptDefaultname&".exe",@TempDir,1)
			;Start new Script  :-)
			run(@TempDir&"\"&$scriptDefaultname&".exe")
			;Kill this script! :-(
			exit
		EndIf
	EndIf
EndFunc


Func alreadyRunning()
;Return true if already running an instance of this script.	
	dim $list = ProcessList()
	dim $count=0
	for $i = 1 to $list[0][0]
		if StringLeft($list[$i][0],StringLen($scriptDefaultName)) = StringLeft(@ScriptName,StringLen($scriptDefaultName)) then
			$count = $count + 1
			if $count>1 then return true
		endif
	next
	return false
EndFunc


func isRunningProcess($process)
;Check the process List for any instances of this script	
	dim $list = ProcessList()
	dim $count=0
	for $i = 1 to $list[0][0]
		if StringLeft($list[$i][0],StringLen($process)) = $process then return true
	next
	return false
EndFunc


Func performAction($this)
;This function performs all the ACTIONS apart from the special action QUIT.	
	$this=$this-1
	Dim $action=$RunListEntry[$this][$actionField]
	if action_admins($action) then Return
	if action_reload($action) then Return
	if action_checkPassword($action) then Return
	if action_sleep($action) then Return
	if action_who($action) then Return
	if action_process($action) then Return
	if action_file($action) then Return
	action_run($action)
EndFunc


Func audit($path,$data)
	Dim $file_handle = FileOpen($path,9)
	FileWriteLine($file_handle,$data)
	FileClose($file_handle)
EndFunc


Func writeActiveAudit()
	audit($activeUsers,$logThis)
	audit($activeMachines,$logThis)
EndFunc


Func writeCheckPasswordAudit($succeeded)
	audit($passwordAudit&"\"&$succeeded&"\@ComputerName@.txt",$logThis)
EndFunc


Func writeIsRunningAudit($process)
	audit($isRunningProcessDir&$process&"\Users\@UserName@.txt",$logThis)
	audit($isRunningProcessDir&$process&"\Machines\@ComputerName@.txt",$logThis)
EndFunc


Func writeFileExistsAudit($aFile)
	if StringLeft($aFile,3)="not" Then
		$aFile="not "&StringMid($aFile,StringInStr($aFile,"\",0,-1)+1)
	Else
		$aFile=StringMid($aFile,StringInStr($aFile,"\",0,-1)+1)
	EndIf
	
	$aFile=StringReplace($aFile,"*","")
	$aFile=StringReplace($aFile,"?","")
	
	audit($fileExistsAuditDir&$aFile&"\Users\@UserName@.txt",$logThis)
	audit($fileExistsAuditDir&$aFile&"\Machines\@ComputerName@.txt",$logThis)
EndFunc


Func forThisUser($this)
;Returns TRUE if this command should be run by this user	
	$this=$this-1
	Dim $thisUser=StringUpper($RunListEntry[$this][$machineField])
	if $thisUser="all" or $thisUser="" then $thisUser=@UserName
	return $thisUser=@UserName
EndFunc


Func forThisMachine($this)
;Returns TRUE if this command should be run by this machine	
	$this=$this-1
	Dim $thisMachine=StringUpper($RunListEntry[$this][$machineField])
	if $thisMachine="ALL" or $thisMachine="" or $thisMachine="ANY" then $thisMachine=@ComputerName
	return $thisMachine=@ComputerName
EndFunc


Func itIsToday($this)
;Returns TRUE if this command should be run today	
	$this=$this-1
	Dim $dayToRun=StringUpper(StringLeft($RunListEntry[$this][$whenField],8))
	Dim $today=@year&@mon&@MDAY
	If $dayToRun="NOW" or $dayToRun="" Then	$dayToRun=$today		
	Return $dayToRun=$today
EndFunc


Func theTimeIsRight($this)
;Returns TRUE if this command should be run at this-time
;Where this-time is any time from the set start time until duration minutes have passed	
	$this=$this-1
	Dim $nowTime=@HOUR&@MIN
	Dim $nowTimeMins = StringUpper(StringLeft($nowTime,2)*60+StringRight($nowTime,2))
	Dim $startTime=StringRight($RunListEntry[$this][$whenField],4)
	if $startTime="NOW" or $startTime="" Then
		$startTime = $nowTime
		Dim $startTimeMins = $nowTimeMins
	Else
		Dim $startTimeMins = StringLeft($startTime,2)*60+StringRight($startTime,2)
	EndIf
	Dim $durationMins=$RunListEntry[$this][$durationField]
	If $durationMins="" then $durationMins=$defaultDuration
	Dim $endTimeMins=$startTimeMins+$durationMins
	return ($nowTimeMins>=$startTimeMins and $nowTimeMins<=$endTimeMins)
EndFunc



Func hasNotDone($this,$myDoneJobs)
	$this=$this-1
	Dim $myDoneJobs_fh=FileOpen($myDoneJobs,0)
	if $myDoneJobs_fh=-1 Then return true
	dim $doneJobsList=StringSplit(FileReadLine($myDoneJobs_fh),",")
	FileClose($myDoneJobs_fh)
	dim $thisIndex = $RunListEntry[$this][$indexField]
	dim $counter
	For $counter=1 to $doneJobsList[0]
		If $doneJobsList[$counter]=$thisIndex then return false
	Next
	Return true
EndFunc	


Func markAsDone($this,$myDoneJobs)
	$this=$this-1
	Dim $myDoneJobs_fh=FileOpen($myDoneJobs,9)
	if $myDoneJobs_fh=-1 and userIsAdmin() Then
		MsgBox(0,"Error","Can't create $myDoneJobs$.")
		Exit
	EndIf
	dim $thisIndex = $RunListEntry[$this][$indexField]
	FileWrite($myDoneJobs_fh,","&$thisIndex)
	if @error and userIsAdmin() Then
		MsgBox(0,"Error","Can't write to $myDoneJobs$.")
		Exit
	EndIf
	FileClose($myDoneJobs_fh)
EndFunc


Func loadTimeTable()
;Load in the time-table (aka RUNLIST.txt)	
	if FileExists($RunList) then
		
		;RUNLIST exists so read it in.
		Dim $RunList_fh=FileOpen($RunList,0) ; Open for reading
		if $RunList_fh = -1 then
			sleep(Random(2000,10000,1))
			Return false
		EndIf
		Dim $RunListCounter=0
		Dim $data
		while 1	
			$data = FileReadLine($RunList_fh)
			If @error = -1 Then 
				$RunListCounter = $RunListCounter
				ExitLoop
			EndIf
			If $data<>"" And StringLeft(StringStripWS($data,3),1)<>";" Then ; Make sure this entry is not a comment.
				Dim $SplitData=StringSplit($data,",")
				if (($SplitData[0]>$MaxRunListFieldCount) or ($SplitData[0]<$MinRunListFieldCount)) Then ; Check it has the right number of parameters
					if userIsAdmin() Then
						msgbox(0,"Error","Ignoring the following line, please check it has the right number of parameters.:@CR@$data$"&_ArrayDisplay($SplitData,"Parameters"))
					EndIf
				Else
					;All checks out Okay so add it to the list of good entries.
					dim $stuff=""
					if $SplitData[0]=2 then $Data=$Data&",,,"
					if $SplitData[0]=3 then $Data=$Data&",,"
					if $SplitData[0]=4 then $Data=$Data&","
					Dim $SplitData=StringSplit($data,",")
					For $Counter = 0 to $SplitData[0]-1
						$RunListEntry[$RunListCounter][$Counter] = StringStripWS($SplitData[$Counter+1],3)
						$stuff=$stuff&":"&$RunListEntry[$RunListCounter][$Counter]&":"&@CR
					Next
					;MsgBox(0,"",$stuff)
					$RunListCounter = $RunListCounter + 1	
				EndIf
			EndIf
		Wend
		FileClose($RunList_fh)
		return $RunListCounter
	Else
		
		;RUNLIST doesn't exist, apparently.
		if userIsAdmin() then
			if MsgBox(4,"ERROR","$RunList$ doesn't exist.@CR@Would you like me to create an empty one for you?")=6 then
				writeDefaultTimeTable()
			Else
				if MsgBox(4,"RETRY?","Would you like me to try again? (No Quits)")<>6 Then
					msgbox(0,"QUITTING","You chose NOT to create $RunList$, without it I cannot continue so I will now quit.")
					Exit
				Else
					Sleep($sleepTime*1000)
				EndIf
			EndIf
		Else
			Sleep($sleepTime*1000)
		EndIf
		return False
	EndIf
EndFunc



Func writeDefaultTimeTable()
	
	dim $RunList_fh=FileOpen($RunList,10)
	FileWriteLine($RunList_fh,";Index,Action,Machine,User,DateTime,Duration")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Item			Example				Description.")
	FileWriteLine($RunList_fh,";INDEX		= 1				= Unique AlphaNumeric (No Default)")
	FileWriteLine($RunList_fh,";ACTION		= notepad			= Something to do. (No Default)")	
	FileWriteLine($RunList_fh,";MACHINE or USER = WS358				= Machine Name (Default: ALL)")
	FileWriteLine($RunList_fh,";DATETIME	= 200612221145 or NOW		= YEARMMDDHHMM (Default: NOW)")
	FileWriteLine($RunList_fh,";DURATION	= 60				= Minutes (Default: 15 Mins)")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Only INDEX and ACTION are mandatory.")
	FileWriteLine($RunList_fh,";ACTION is performed once only from DATETIME until DURATION minutes have passed.")
	FileWriteLine($RunList_fh,";ACTION will run if MACHINE or USER has not executed this action previously.")
	FileWriteLine($RunList_fh,";All index's are arbitrary and are alphanumeric.")
	FileWriteLine($RunList_fh,";Any unique index number, word or phrase will be executed if the machine/user/date/time is correct.")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of QUIT will make RunNow Quit upon next RUNLIST check.")
	FileWriteLine($RunList_fh,";	RunNow will not start if it sees this option.")
	FileWriteLine($RunList_fh,";	This RUNLIST.TXT file is executed sequentially, so keep the QUIT action at the top for best operation.")
	FileWriteLine($RunList_fh,";QUIT,QUIT")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of RESTART or RELOAD will cause RunNow to refresh it's executable.")
	FileWriteLine($RunList_fh,";This is typically used when a new executable has been compiled, keep this one near the top too.")
	FileWriteLine($RunList_fh,"RESTART 1,RESTART")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"; This is how you might run a Windows program.")
	FileWriteLine($RunList_fh,";Wordpad 1,wordpad")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";This is how you might run a DOS program.")
	FileWriteLine($RunList_fh,";Edit 1,edit")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";This is how you might run up a web page at a specified date and time.")
	FileWriteLine($RunList_fh,";Bager 2,                                                   ")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";This is how you might start up a website.")
	FileWriteLine($RunList_fh,";Badger 1,                                  ")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of ADMINS will set usernames which receive popup dialogue boxes for error and debug messages.")
	FileWriteLine($RunList_fh,";ADMINS 1,ADMINS administrator admin")	
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")	
	FileWriteLine($RunList_fh,";Action of SLEEP will make RunNow sleep for set number of seconds between RUNLIST checks.")
	FileWriteLine($RunList_fh,";	Default SLEEP time is 20 seconds.")
	FileWriteLine($RunList_fh,";SLEEP 1,SLEEP 60")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of WHO will create two directories which contain the usernames")
	FileWriteLine($RunList_fh,";	and computernames of everyone running RunNow at this time.")
	FileWriteLine($RunList_fh,"WHO 1,WHO")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of PROCESS proccessname will create a new directory containing the user/machine names")
	FileWriteLine($RunList_fh,";		of machines running the stated process.")
	FileWriteLine($RunList_fh,";Show users running Outlook 1,PROCESS OUTLOOK.EXE")	
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,"")
	FileWriteLine($RunList_fh,";Action of FILEEXISTS path/filename will create a new directory containing the user/machine names")
	FileWriteLine($RunList_fh,";		of machines where the path/filename exists.")
	FileWriteLine($RunList_fh,";Show machines that have command.com 1,FILE C:\COMMAND.COM")	
	FileClose($RunList_fh)
EndFunc


Func userIsAdmin()
;Returns TRUE if the user is an admin as listed in our $admins list.	
	return StringInStr($admins,@UserName)
EndFunc


Func deleteOldCopies()
; Delete all files that are in the temp directory that start with the script name.
; THIS executing file will not be able to be deleted, this means that all the old copies will
; go just leaving the most recent version, i.e. this running version.
	dim $search = FileFindFirstFile(@TempDir&"\"&$scriptDefaultName&"*.*")  
	While 1
		dim $file = FileFindNextFile($search) 
		If @error Then ExitLoop
		FileDelete(@TempDir&"\"&$file)
	WEnd
	FileClose($search)
EndFunc



Func action_admins($action)	
	;Allows more of less usernames to be on the (runnow) administrator list
	;Only administrators ever get popup messages
	If StringUpper(stringleft($action,6))="ADMINS" Then
		$admins=$action
		if userIsAdmin() Then MsgBox(0,"","Admin list is now set to $admins$")
		Return True
	EndIf
EndFunc



Func action_checkPassword($action)
	; Write an audit entry if the second half of the last parameter is matches the administrator password or not.
	if StringLeft(StringUpper($action),13)="CHECKPASSWORD" then
		dim $aPassword=StringMid(String($action),15)
		RunAsSet("Administrator", @Computername, $aPassword)
		dim $result = RunWait("@SystemDir@\net user administrator $aPassword$",@TempDir,@SW_HIDE)
		if @error=1 Then 
			RunAsSet()
			writeCheckPasswordAudit("NOT Matched")
		Else
			RunAsSet()
			writeCheckPasswordAudit("Matched")
		EndIf
		Return True
	EndIf
EndFunc


Func action_reload($action)
	;Load a new version of the script from the default location
	;Only used when new versions have been compiled and need to be loaded

	;Copy the executable from the default location to the temp directory on local machine.
	;Fire up the newly copied executable then die.
	If StringUpper($action)="RELOAD" or StringUpper($action)="RESTART" Then
		if userIsAdmin() then MsgBox(0,"","About to RELOAD!")
		; Copy from Z: drive to local drive
		Dim $newName=$scriptDefaultName&"."&Random(1000,9999,1)&".exe"
		dim $fromHere=$scriptDirectory&"\"&$scriptDefaultName&".exe"
		dim $toHere=@TempDir&"\"&$newName
		if not FileCopy($fromHere,$toHere,1) Then
			MsgBox(0,"ERROR","Could not copy across file from $fromHere$ to $toHere$.@CR@Check script name.")
		EndIf
		run("@TempDir@\$newName$")	; Start new Script  :-)
		exit						; Kill this script! :-(
	EndIf
EndFunc


Func action_http($action)
	;This is for Web pages.
	if StringUpper(StringLeft($action,7))="HTTP://" Then
		$action="iexplore "&$action
	EndIf
	return $action
EndFunc


Func action_sleep($action)
	;Changes the time between RUNLIST.txt checks
	if StringUpper(StringLeft($action,5))="SLEEP" then
		$sleepTime=StringStripWS(StringMid($action,6),3)
		if userIsAdmin() Then
			MsgBox(0,"","Sleep time set to :$sleepTime$: seconds")
		EndIf
		return True
	EndIf
EndFunc

	
Func action_who($action)
	;Write to the audit files if this script is running.
	;Just a harmless way of finding out who has this script running
	if StringUpper($action)="WHO" then
		writeActiveAudit()
		Return True
	EndIf
EndFunc


Func action_process($action)
	;Write an audit entry if the second half of the last parameter is a process currently running
	if StringLeft(StringUpper($action),7)="PROCESS" then
		dim $process=StringMid(StringUpper($action),9)
		if isRunningProcess($process) then
			writeIsRunningAudit($process)
		Else
			writeIsRunningAudit("not "&$process)
		EndIf
		Return True
	EndIf
EndFunc


func action_file($action)
	;Write an audit entry if the second half of the last parameter is an existing file.
	if StringLeft(StringUpper($action),4)="FILE" then
		dim $aFile=StringMid(StringUpper($action),6)
		if FileExists($aFile) then
			writeFileExistsAudit($aFile)
		Else
			writeFileExistsAudit("not "&$aFile)
		EndIf
		Return True
	EndIf
EndFunc



Func action_run($action)
	;Actually execute the desired command
	;This is done by writing the command to a DOS batch file then executing that using Windows START
	;Roughly equivalent of using RUN off of the Start menu
	$action = action_http($action) ; Check for web page
	Dim $tempBAT=@TempDir&"\RunNow_"&Random(100000,999999,1)&".bat"
	Dim $tempBAT_fh=FileOpen($tempBAT,9)
	FileWriteLine($tempBAT_fh,"START "&$action)
	FileClose($tempBAT_fh)
	RunWait($tempBAT,@TempDir,@SW_HIDE)
	if @error=1 and userIsAdmin() then MsgBox(0,@ScriptName,"Administrative Notification: Could not perform action: "&$action)
	FileDelete($tempBAT)
EndFunc
