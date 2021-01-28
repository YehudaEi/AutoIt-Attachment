#region Script Options 
;** AUTOIT3 settings
#AutoIt3Wrapper_UseAnsi=N                       ;(Y/N) Use Ansi versions for AutoIt3a or AUT2EXEa. Default=N
#AutoIt3Wrapper_UseX64=N                        ;(Y/N) Use X64 versions for AutoIt3_x64 or AUT2EXE_x64. Default=N
#AutoIt3Wrapper_Version=P                       ;(B/P) Use Beta or Production for AutoIt3 and AUT2EXE. Default is P
#AutoIt3Wrapper_Run_Debug_Mode=N                ;(Y/N)Run Script with console debugging. Default=N
;===============================================================================================================
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=icon.ico 					;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=KupSvc.exe           ;Target exe/a3x filename.
#AutoIt3Wrapper_OutFile_Type=exe                ;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=2                   ;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                        ;(Y/N) Compress output program.  Default=Y
#AutoIt3Wrapper_Change2CUI=Y                    ;(Y/N) Change output program to CUI in stead of GUI. Default=N
;===============================================================================================================
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=Kill Unknown Processes             ;Comment field
#AutoIt3Wrapper_Res_Description=Enable White list processes     ;Description field
#AutoIt3Wrapper_Res_Fileversion=0.1.0.38
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=Y  	;(Y/N/P)AutoIncrement FileVersion After Aut2EXE is finished. default=N
;                                   	            P=Prompt, Will ask at Compilation time if you want to increase the versionnumber
#AutoIt3Wrapper_Res_Language=2057	                ;Resource Language code . default 2057=English (United Kingdom)
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2009 Franck Grieder      ;Copyright field
#AutoIt3Wrapper_res_requestedExecutionLevel=None    	;None, asInvoker, highestAvailable or requireAdministrator   (default=None)
#AutoIt3Wrapper_Res_SaveSource=Y                 	;(Y/N) Save a copy of the Scriptsource in the EXE resources. default=N
;
#AutoIt3Wrapper_res_field=Made By|Franck Grieder
#AutoIt3Wrapper_res_field=Email|franck dot grieder at free dot fr
#AutoIt3Wrapper_res_field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_res_field=Compile Date|%date% %time%
; Obfuscator
#AutoIt3Wrapper_Run_Obfuscator=Y                 ;(Y/N) Run Obfuscator before compilation. default=N
#obfuscator_parameters=/cs=0 /cn=0 /cf=0 /cv=0 /sf=1
#AutoIt3Wrapper_Run_cvsWrapper=V                 ;(Y/N/V) Run cvsWrapper to update the script source. default=N
#AutoIt3Wrapper_Add_Constants=n
#EndRegion

#Region Init
#include <KupIncService.au3> ;Thanks Arcker - http://www.autoitscript.com/forum/index.php?showtopic=80201
Global $ProcList,$h,$Recurse,$SleepingTime,$TrayIconHide,$list, $PID, $DisplayTips, $LearningMode, $FileStamp,$FileStampMem, $HotKeys, $MyINI=@ScriptDir&"\Kup.ini"
FileInstall("KupSvc.AU3",@TempDir&"\KupSvc.txt")
FileInstall("KupIncService.au3",@TempDir&"\KupIncService.txt")
FileInstall("Kup.txt",@ScriptDir&"\Kup.txt")
FileInstall("KupOn",@ScriptDir&"\KupOn")
FileInstall("Start.cmd",@ScriptDir&"\Start.cmd")
$LearningMode=Int(IniRead($MyINI,"Config","LearningMode","0"))
$sServiceName = "KUP_Service"
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "install", "-i", "/i","-install", "/install"
			InstallService()
		Case "remove", "-u", "/u", "-uninstall", "/uninstall", "/remove", "-remove"
			RemoveService()
		Case Else
			ConsoleWrite(" ========================================================" & @crlf)
			ConsoleWrite(" == Kill Unknown Processes Help =========================" & @crlf)
			ConsoleWrite(" ========================================================" & @crlf)
			ConsoleWrite(" parameters : " & @crlf)
			ConsoleWrite("  -i : install service" & @crlf)
			ConsoleWrite("  -u : remove service" & @crlf&@CRLF)
			ConsoleWrite(' Then type : Net Start "KUP Service" to start the service' & @crlf)
			ConsoleWrite(" For more help, please check Kup.txt..." & @crlf)
			ConsoleWrite(" ========================================================" & @crlf)
			Exit
			;start service.
	EndSwitch
EndIf
_Service_init($sServiceName)
#EndRegion

#Region Main
Main()
Exit

Func Main()
	SetTip("Main"&@CR)
	$h=FileOpen(@ScriptDir&"\_KillUnknownProcesses.log",1)
	FileWrite($h,@YEAR&@MON&@MDAY&" - "&@HOUR&@MIN&@SEC&" - "&@ScriptFullPath&" Started"&@CRLF)
	FileClose($h)
	Init()
	If $Recurse=0 Then
		$h=FileOpen(@ScriptDir&"\_KillUnknownProcesses.log",1)
		_KillUnknownProcesses()
		FileClose($h)
	Else
		While 1
			$h=FileOpen(@ScriptDir&"\_KillUnknownProcesses.log",1)
			_KillUnknownProcesses()
			Sleep ($SleepingTime)
			FileClose($h)
			CheckIfIShouldStop()
		WEnd
	EndIf
EndFunc
#EndRegion
#Region Functions

Func InstallService()
	ConsoleWrite("Installing service, please wait" & @CRLF)
	_Service_Create("", $sServiceName, "KUP Service", '"' & @ScriptFullPath & '"')
	If @error Then
		ConsoleWrite("Problem installing KUP service, Error number is " & @error & @CRLF & " message  : " & _WinAPI_GetLastErrorMessage())
	Else
		ConsoleWrite("Installation of KUP service successful. Please use :"&@CRLF&'Net Start "KUP Service"'&@CRLF&"to start the service in Learning mode ...")
	EndIf
	Exit
EndFunc   ;==>InstallService

Func RemoveService()
	ConsoleWrite("Removing service, please wait" & @CRLF)
	_StopService("", $sServiceName)
	Sleep($SleepingTime)
	_DeleteService("", $sServiceName)
	if not @error then 
		ConsoleWrite("service removed successfully" & @crlf)
	Else
		ConsoleWrite("Error "&@error&" removing service. Please reboot..." & @crlf)
	EndIf
	Exit
EndFunc   ;==>RemoveService

Func Init()
	If IniRead($MyINI,"CurrentControlSet","Process","")<>@ScriptName Then 
		IniWrite($MyINI,"CurrentControlSet","Process",@ScriptName)
		$FileStampMem=FileGetTime($MyINI,0,1)
	EndIf
	$LearningMode=Int(IniRead($MyINI,"Config","LearningMode","0"))
	$ProcList=IniRead($MyINI,"Config","Processes","")
	If $Proclist="" Then
		_Setup()
		$LearningMode=1
	EndIf
	$Recurse=INT(IniRead($MyINI,"Config","Recurse","0"))
	$TrayIconHide=Int(IniRead($MyINI,"Config","TrayIconHide","1"))
	Opt("TrayIconHide",$TrayIconHide)
	$SleepingTime=IniRead($MyINI,"Config","SleepingTime","500")
	$DisplayTips=Int(IniRead($MyINI,"Config","DisplayTips","1"))
	If $DisplayTips=1 Then ShowActiveMode()
	$FileStampMem=FileGetTime($MyINI,0,1)
EndFunc

Func _KillUnknownProcesses()
	$FileStamp=FileGetTime($MyINI,0,1)
	If $FileStamp<>$FileStampMem Then Init()
	$list = ProcessList()
	For $i = 1 to $list[0][0]
		If StringInStr($ProcList,"|"&$list[$i][0]&"|")=0 Then
			If $LearningMode=1 Then
				$ProcList=IniRead($MyINI,"Config","Processes","")
				$BProcesses=IniRead($MyINI,"Config","BProcesses","")
				If $BProcesses<>"" Then
					If StringInStr($BProcesses,"|"&$list[$i][0]&"|")=0 Then
						If StringInStr($ProcList,"|"&$list[$i][0]&"|")=0 Then 
							$ProcList=$ProcList  & $list[$i][0] & "|"
							IniWrite($MyINI,"Config","Processes",$ProcList)
							SetTip("Process "&$list[$i][0]&" added",10,20,"Kill Unknown Processes")
						EndIf
					EndIf
				Else
					If StringInStr($ProcList,"|"&$list[$i][0]&"|")=0 Then 
						$ProcList=$ProcList  & $list[$i][0] & "|"
						IniWrite($MyINI,"Config","Processes",$ProcList)
						SetTip("Process "&$list[$i][0]&" added",10,20,"Kill Unknown Processes")
					EndIf
				EndIf
			Else
				$PID=ProcessExists($list[$i][0])
				FileWrite($h,@YEAR&@MON&@MDAY&" - "&@HOUR&@MIN&@SEC&" - Process "&$list[$i][0])
	 			ProcessClose($list[$i][0])
				ProcessWaitClose($list[$i][0],2)
				If ProcessExists($PID) Then
					$Res=" Could'nt be killed !"
				Else
					$Res=" Killed"
				Endif
				FileWrite($h," PID:"&$PID&$Res&@CRLF)
				SetTip("Process "&$list[$i][0]&" PID:"&$PID&$Res,10,20,"Kill Unknown Processes")
			EndIf
		EndIf
	Next
	Sleep($SleepingTime)
	SetTip("")
EndFunc

Func _Setup()
	IniWrite($MyINI,"Config","BProcesses","|ctfmon.exe|")
	IniWrite($MyINI,"Config","WProcesses","|System|winlogon.exe|services.exe|lsass.exe|svchost.exe|explorer.exe|KupSvc.exe|iexplore.exe|")
	IniWrite($MyINI,"Config","Recurse","1")
	IniWrite($MyINI,"Config","SleepingTime","1000")
	IniWrite($MyINI,"Config","TrayIconHide","1")
	IniWrite($MyINI,"Config","DisplayTips","0")
	IniWrite($MyINI,"Config","LearningMode","1")
	SetTip("Creating white list ...", 10,10,"KillUnknownProcesses")
	If IniRead($MyINI,"Config","WProcesses","")<>"" Then
		$ProcList=IniRead($MyINI,"Config","WProcesses","")
		If StringRight($ProcList,1)<>"|" Then $ProcList=$ProcList  & "|"
	Else
		$ProcList="|"
	EndIf
	$BProcesses=IniRead($MyINI,"Config","BProcesses","")
	$list = ProcessList()
	For $i = 1 to $list[0][0]
		If $BProcesses<>"" Then
			If StringInStr($BProcesses,"|"&$list[$i][0]&"|")=0 Then
				If StringInStr($ProcList,"|"&$list[$i][0]&"|")=0 Then $ProcList=$ProcList  & $list[$i][0] & "|"
			EndIf
		Else
			If StringInStr($ProcList,"|"&$list[$i][0]&"|")=0 Then $ProcList=$ProcList  & $list[$i][0] & "|"
		EndIf
	Next
	IniWrite($MyINI,"Config","Processes",$ProcList)
	SetTip("Whitelist Created",10,10,"Kill Unknown Processes")
	Sleep(2000)
	SetTip("")
EndFunc

Func ShowActiveMode()
	If $LearningMode="1" Then
		SetTip("Learning mode activated ...",10,10,"Kill Unknown Processes")
	Else
		SetTip("Production mode ...",10,10,"Kill Unknown Processes")
	Endif
	Sleep($SleepingTime)
	SetTip("")
EndFunc

Func CheckIfIShouldStop()
	If FileExists(@ScriptDir&"\KUPOff") Then
		SetTip("CheckIfIShouldStop = KUPOFF exists => Shutting down"&@CR)
		IF $LearningMode=1 Then IniWrite($MyINI,"Config","LearningMode","0")
		FileMove(@ScriptDir&"\KUPOff",@ScriptDir&"\KUPOn")
		FileDelete(@ScriptDir&"\KUPOff")
		Sleep($SleepingTime)
		_StopService("", $sServiceName)
		Exit
	ElseIf FileExists(@ScriptDir&"\KUPL") Then
		SetTip("CheckIfIShouldStop = KUPL exists => LearningMode"&@CR)
		$LearningMode=1
		FileMove(@ScriptDir&"\KUPL",@ScriptDir&"\KUPOn")
		ShowActiveMode()
	ElseIf FileExists(@ScriptDir&"\KUPP") Then
		SetTip("CheckIfIShouldStop = KUPP exists => ProductionMode"&@CR)
		$LearningMode=0
		FileMove(@ScriptDir&"\KUPP",@ScriptDir&"\KUPOn")
		ShowActiveMode()
	EndIf
EndFunc

Func SetTip($Text,$x=10,$y=10,$Title="Kill Unknown Processes")
	If $DisplayTips=1 Then ToolTip($Text,$x,$y,$Title)
	If $Text<>"" Then
		$h=FileOpen(@ScriptDir&"\_KillUnknownProcesses.log",1)
		FileWrite($h,@YEAR&@MON&@MDAY&" - "&@HOUR&@MIN&@SEC&" - "&@ScriptFullPath&" "&$Text&@CRLF)
		FileClose($h)
	EndIf
EndFunc
#EndRegion

