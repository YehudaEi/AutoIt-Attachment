#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

;~ User State Migration Tool Front End
;~ Coded by Ian Maxwell (llewxam @ AutoIt forum)

Local $TargetBrowse, $Target, $TargetPath, $OfflineBrowse, $OfflinePath, $CreateGoButton, $RestoreGoButton, $Offline, $CustName, $RepairNumber, $Tech, $MSG, $LogFile, $TimesToRetry, $SecondsToWait, $AdvancedGUI

$XPMode = False
$NoCompress = True
$NoCompressArg = ""
$Overwrite = False
$OverwriteArg = ""
$OfflineEnabled = False
$OfflineArg = ""
$TimesToRetryArg = 3
$SecondsToWaitArg = 1

$WhatFunction = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE 2011", 480, 150, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 15)
FileInstall("right.jpg", @TempDir & "\right.jpg", 1)
GUICtrlCreatePic(@TempDir & "\right.jpg", 50, 20, 160, 120)
GUICtrlSetState(-1, $GUI_DISABLE)
FileInstall("left.jpg", @TempDir & "\left.jpg", 1)
GUICtrlCreatePic(@TempDir & "\left.jpg", 270, 20, 160, 120)
GUICtrlSetState(-1, $GUI_DISABLE)
$Create = GUICtrlCreateButton("CREATE Backup", 75, 62, 110, 20)
$Restore = GUICtrlCreateButton("RESTORE Backup", 295, 62, 110, 20)
$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
GUICtrlSetBkColor(-1, 0x00f700)
GUISetBkColor(0xb2ccff, $WhatFunction)
GUISetState(@SW_SHOW, $WhatFunction)
Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $Question Then _Question()
	If $MSG == $Create Then
		GUIDelete($WhatFunction)
		_CreateGUISimple()
		ExitLoop
	EndIf
	If $MSG == $Restore Then
		GUIDelete($WhatFunction)
		_RestoreGUI()
		ExitLoop
	EndIf
Until 1 = 2

Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $Question Then _Question()
	If $MSG == $TargetBrowse Then
		$TargetLocation = FileSelectFolder("Choose the location to save the backup data", "", 1)
		GUICtrlSetData($Target, $TargetLocation)
	EndIf
	If $MSG == $OfflineBrowse Then
		$OfflineLocation = FileSelectFolder("Select the WINDOWS folder on the OFFLINE drive", "")

		$ValidOfflinePath = False
		If FileExists($OfflineLocation & "\explorer.exe") Then $ValidOfflinePath = True
		If FileExists($OfflineLocation & "\system32") Then $ValidOfflinePath = True

		If $ValidOfflinePath = True Then
			GUICtrlSetData($OfflinePath, $OfflineLocation)
		Else
			$yesOrNo = MsgBox(4, "Path Error", "You have either not specified the Windows folder of the offline drive, or the operating system on that drive has been heavily corrupted.  Are you sure that the path specified is correct?" & @CR & @CR & $OfflineLocation)
			If $yesOrNo = 6 Then

			EndIf
		EndIf
	EndIf
	If $MSG == $CreateGoButton Then
		$Proceed = False
		_CreateExecute()
		If $Proceed == True Then
			GUICtrlSetState($CreateGoButton, $GUI_DISABLE)
			If $XPMode == True Then
				_Extract($XPMode)
				ShellExecuteWait(@TempDir & "\USMT\scanstate.exe", Chr(34) & $TargetPath & Chr(34) & " /targetxp /localonly /efs:decryptcopy" & $OverwriteArg & $NoCompressArg & " /r:" & $TimesToRetryArg & " /w:" & $SecondsToWaitArg & " /L:" & Chr(34) & $LogFile & Chr(34) & " /v:13 /c /all /i:" & @TempDir & "\USMT\MigApp.xml /i:" & @TempDir & "\USMT\MigSys.xml /i:" & @TempDir & "\USMT\MigUser.xml", @TempDir)
			Else
				_Extract($XPMode)
				ShellExecuteWait(@TempDir & "\USMT\scanstate.exe", Chr(34) & $TargetPath & Chr(34) & " /localonly /vsc /efs:decryptcopy" & $OverwriteArg & $NoCompressArg & $OfflineArg & " /r:" & $TimesToRetryArg & " /w:" & $SecondsToWaitArg & " /L:" & Chr(34) & $LogFile & Chr(34) & " /v:13 /c /all /i:" & @TempDir & "\USMT\MigApp.xml /i:" & @TempDir & "\USMT\MigDocs.xml /i:" & @TempDir & "\USMT\MigUser.xml", @TempDir)
			EndIf

			Do
				Sleep(1000)
			Until Not ProcessExists("scanstate.exe")
			MsgBox(0, "Done", "Finished backing up.")
			Exit
		EndIf
	EndIf
	If $MSG == $AdvancedGUI Then
		_CreateGUIAdvanced()

	EndIf
	If $MSG == $RestoreGoButton Then
		_RestoreExecute()
		MsgBox(0, "Done", "Finished restoring.")
		Exit
	EndIf





	If GUICtrlRead($Offline) == 1 And $OfflineEnabled == False Then
		$OfflineEnabled = True
		GUICtrlSetState($OfflinePath, $GUI_SHOW)
		GUICtrlSetState($OfflineBrowse, $GUI_SHOW)
	EndIf
	If GUICtrlRead($Offline) == 4 And $OfflineEnabled == True Then
		$OfflineEnabled = False
		GUICtrlSetState($OfflinePath, $GUI_HIDE)
		GUICtrlSetState($OfflineBrowse, $GUI_HIDE)
	EndIf
Until 1 = 2

Func _CreateGUISimple()
	If @OSVersion == "WIN_XP" Then
		FileInstall("XPTOXP.jpg", @TempDir & "\XPTOXP.jpg", 1)
		FileInstall("UPGRADE.jpg", @TempDir & "\UPGRADE.jpg", 1)
		$ToXPGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 150, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 15)
		GUICtrlCreatePic(@TempDir & "\XPTOXP.jpg", 50, 20, 160, 120)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreatePic(@TempDir & "\UPGRADE.jpg", 270, 20, 160, 120)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$XPToXPChoice = GUICtrlCreateButton("XP to XP", 75, 62, 110, 20)
		$XPToNewerChoice = GUICtrlCreateButton("XP to Vista/7", 295, 62, 110, 20)
		$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
		GUICtrlSetBkColor(-1, 0x00f700)
		GUISetBkColor(0xb2ccff, $ToXPGUI)
		GUISetState(@SW_SHOW, $ToXPGUI)
		Do
			$MSG = GUIGetMsg()
			If $MSG == $GUI_EVENT_CLOSE Then Exit
			If $MSG == $Question Then _Question()
			If $MSG == $XPToXPChoice Then
				$XPMode = True
				GUIDelete($ToXPGUI)
				ExitLoop
			EndIf
			If $MSG == $XPToNewerChoice Then
				GUIDelete($ToXPGUI)
				ExitLoop
			EndIf
		Until 1 = 2
	EndIf

	$CreateSimpleGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 250, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 200)
	GUICtrlCreateLabel("Specify the location to save the backup", 10, 10, 460, 20)
	$Target = GUICtrlCreateInput("", 10, 25, 430, 20)
	$TargetBrowse = GUICtrlCreateButton("...", 450, 25, 20, 20)
	GUICtrlCreateLabel("Customer Last Name:", 10, 65, 120, 20)
	$CustName = GUICtrlCreateInput("", 10, 80, 120, 20)
	GUICtrlCreateLabel("Repair Number:", 220, 65, 85, 20)
	$RepairNumber = GUICtrlCreateInput("", 220, 80, 85, 20)
	GUICtrlCreateLabel("Tech's Initials:", 383, 65, 85, 20)
	$Tech = GUICtrlCreateInput("", 383, 80, 85, 20)
	$Offline = GUICtrlCreateCheckbox("Specify a path for Offline recovery if not backing up this computer", 10, 125, 460, 20)
	GUICtrlCreateLabel("(IE: C;\Windows.old, E:\Windows etc)", 45, 145, 460, 20)
	$OfflinePath = GUICtrlCreateLabel("", 145, 168, 325, 25)
	GUICtrlSetFont(-1, 11, 500)
	$OfflineBrowse = GUICtrlCreateButton("Specify Location", 10, 165, 110, 25)
	GUICtrlSetState($OfflinePath, $GUI_HIDE)
	GUICtrlSetState($OfflineBrowse, $GUI_HIDE)
	$AdvancedGUI = GUICtrlCreateButton("Advanced Options", 360, 210, 110, 30)
	$CreateGoButton = GUICtrlCreateButton("GO", 10, 200, 80, 40)
	GUICtrlSetFont($CreateGoButton, 12)
	$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
	GUICtrlSetBkColor(-1, 0x00f700)
	GUISetBkColor(0xb2ccff, $CreateSimpleGUI)
	GUISetState(@SW_SHOW, $CreateSimpleGUI)
EndFunc   ;==>_CreateGUISimple

Func _CreateGUIAdvanced()
	If @OSVersion == "WIN_XP" Then
		FileInstall("XPTOXP.jpg", @TempDir & "\XPTOXP.jpg", 1)
		FileInstall("UPGRADE.jpg", @TempDir & "\UPGRADE.jpg", 1)
		$ToXPGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 150, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 15)
		GUICtrlCreatePic(@TempDir & "\XPTOXP.jpg", 50, 20, 160, 120)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreatePic(@TempDir & "\UPGRADE.jpg", 270, 20, 160, 120)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$XPToXPChoice = GUICtrlCreateButton("XP to XP", 75, 62, 110, 20)
		$XPToNewerChoice = GUICtrlCreateButton("XP to Vista/7", 295, 62, 110, 20)
		$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
		GUICtrlSetBkColor(-1, 0x00f700)
		GUISetBkColor(0xb2ccff, $ToXPGUI)
		GUISetState(@SW_SHOW, $ToXPGUI)
		Do
			$MSG = GUIGetMsg()
			If $MSG == $GUI_EVENT_CLOSE Then Exit
			If $MSG == $Question Then _Question()
			If $MSG == $XPToXPChoice Then
				$XPMode = True
				GUIDelete($ToXPGUI)
				ExitLoop
			EndIf
			If $MSG == $XPToNewerChoice Then
				GUIDelete($ToXPGUI)
				ExitLoop
			EndIf
		Until 1 = 2
	EndIf

	$CreateAdvancedGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 400, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 200)
	GUICtrlCreateLabel("Specify the location to save the backup", 10, 10, 460, 20)
	$Target = GUICtrlCreateInput("", 10, 25, 430, 20)
	$TargetBrowse = GUICtrlCreateButton("...", 450, 25, 20, 20)
	GUICtrlCreateLabel("Customer Last Name:", 10, 55, 120, 20)
	$CustName = GUICtrlCreateInput("", 10, 70, 120, 20)
	GUICtrlCreateLabel("Repair Number:", 150, 55, 85, 20)
	$RepairNumber = GUICtrlCreateInput("", 150, 70, 85, 20)
	GUICtrlCreateLabel("Tech's Initials:", 255, 55, 85, 20)
	$Tech = GUICtrlCreateInput("", 255, 70, 85, 20)
	$NoCompress = GUICtrlCreateCheckbox("Do not compress the data (Faster)", 10, 130, 460, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateLabel("Number of times to retry when an error occurs:", 10, 152, 220, 20)
	GUICtrlCreateLabel("(0-100, Default=3)", 270, 152, 100, 20)
	$TimesToRetry = GUICtrlCreateInput("3", 230, 150, 30, 20, $ES_CENTER)
	GUICtrlCreateLabel("Seconds to wait before retrying when an error occurs:", 10, 172, 255, 20)
	GUICtrlCreateLabel("(0-100, Default=1)", 305, 172, 100, 20)
	$SecondsToWait = GUICtrlCreateInput("1", 265, 170, 30, 20, $ES_CENTER)
	$Offline = GUICtrlCreateCheckbox("Specify a path for Offline recovery if not backing up this computer (NO XP TO XP!)", 10, 215, 460, 20)
	GUICtrlCreateLabel("IE: C;\Windows.old, E:\Windows etc", 26, 235, 460, 20)
	$OfflinePath = GUICtrlCreateLabel("", 145, 168, 325, 25)
	GUICtrlSetFont(-1, 11, 500)
	$OfflineBrowse = GUICtrlCreateButton("Specify Location", 10, 165, 110, 25)
	GUICtrlSetState($OfflinePath, $GUI_DISABLE)
	GUICtrlSetState($OfflineBrowse, $GUI_DISABLE)
	$AdvancedGUI = GUICtrlCreateButton("Advanced Settings", 360, 300, 110, 30)
	$CreateGoButton = GUICtrlCreateButton("GO", 200, 320, 80, 40)
	GUICtrlSetFont($CreateGoButton, 12)
	GUICtrlCreateLabel("(You can not downgrade to Windows XP from a newer version of Windows or migrate" & @CR & "from a 64bit OS to a 32bit OS with this tool)", 10, 365, 470, 40, $SS_CENTER)
	$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
	GUICtrlSetBkColor(-1, 0x00f700)
	GUISetBkColor(0xb2ccff, $CreateAdvancedGUI)
	GUISetState(@SW_SHOW, $CreateAdvancedGUI)
EndFunc   ;==>_CreateGUIAdvanced

Func _RestoreGUI()
	$RestoreGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 400, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 200)
	GUICtrlCreateLabel("Specify the location to restore the backup from", 10, 10, 460, 20)
	$Target = GUICtrlCreateInput("", 10, 25, 430, 20)
	$TargetBrowse = GUICtrlCreateButton("...", 450, 25, 20, 20)
	GUICtrlCreateLabel("Number of times to retry when an error occurs:", 10, 57, 220, 20)
	GUICtrlCreateLabel("(0-100, Default=3)", 270, 57, 100, 20)
	$TimesToRetry = GUICtrlCreateInput("3", 230, 55, 30, 20, $ES_CENTER)
	GUICtrlCreateLabel("Seconds to wait before retrying when an error occurs:", 10, 77, 255, 20)
	GUICtrlCreateLabel("(0-100, Default=1)", 305, 77, 100, 20)
	$SecondsToWait = GUICtrlCreateInput("1", 265, 75, 30, 20, $ES_CENTER)
	$RestoreGoButton = GUICtrlCreateButton("GO", 200, 320, 80, 40)
	GUICtrlSetFont($RestoreGoButton, 12)
	GUICtrlCreateLabel("(You can not downgrade to Windows XP from a newer version of Windows or migrate" & @CR & "from a 64bit OS to a 32bit OS with this tool)", 10, 365, 470, 40, $SS_CENTER)
	$Question = GUICtrlCreateButton("?", 460, 0, 20, 20)
	GUICtrlSetBkColor(-1, 0x00f700)
	GUISetBkColor(0xb2ccff, $RestoreGUI)
	GUISetState(@SW_SHOW, $RestoreGUI)
EndFunc   ;==>_RestoreGUI

Func _CreateExecute()
	$TargetPath = GUICtrlRead($Target)
	$CustomerArg = GUICtrlRead($CustName)
	$RepairArg = GUICtrlRead($RepairNumber)
	$TechArg = GUICtrlRead($Tech)
	If $TargetPath <> "" And $CustomerArg <> "" And $RepairArg <> "" And $TechArg <> "" Then
		$Proceed = True
	Else
		MsgBox(16, "ERROR", "Please verify that you have filled in the Customer Last Name, Repair Number, and Tech's Initials fields.")
	EndIf
	If $Proceed == True Then
		$Proceed = False
		If StringRight($TargetPath, 1) == "\" Then $TargetPath = StringTrimRight($TargetPath, 1)
		$TargetPath &= StringUpper("\" & $CustomerArg & "-" & $RepairArg & "-" & $TechArg & "-" & @MON & @MDAY & StringMid(@YEAR, 3, 2))
		$LogFile = $TargetPath & ".txt"

;~ set options based on checkboxes



		If $OfflineEnabled == False Then
			$Proceed = True
		Else
			$OfflinePathArg = GUICtrlRead($OfflinePath)
			If $OfflineEnabled == True And $OfflinePathArg == "" Then
				MsgBox(16, "ERROR", "You have specified Offline mode but have not provided a valid path to the offline Windows installation.  Please set/confirm an offline Windows installation path.")
			Else
				$OfflineArg = "/offlineWinDir:" & Chr(34) & $OfflinePathArg & Chr(34)
				$Proceed = True
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_CreateExecute

Func _RestoreExecute()
	$TargetPath = GUICtrlRead($Target)
	If $TargetPath <> "" Then
		$TargetBreak = StringSplit($TargetPath, "\")
		$Last = $TargetBreak[0]
		$LogFile = "c:\" & $TargetBreak[$Last] & ".txt"
		$TimesToRetryArg = 3
		If GUICtrlRead($TimesToRetry) <> "" Then $TimesToRetryArg = GUICtrlRead($TimesToRetry)
		$SecondsToWaitArg = 1
		If GUICtrlRead($SecondsToWait) <> "" Then $SecondsToWaitArg = GUICtrlRead($SecondsToWait)
		$NoCompressArg = ""
		$FileCount = DirGetSize($TargetPath, 1)
		If $FileCount[1] > 1 Then $NoCompressArg = "/nocompress "
		GUICtrlDelete($RestoreGoButton)

		If @OSVersion == "WIN_XP" Then
			$XPMode = True
			_Extract($XPMode)
			ShellExecuteWait(@TempDir & "\USMT\loadstate.exe", Chr(34) & $TargetPath & Chr(34) & " /lac /lae " & $NoCompressArg & "/r:" & $TimesToRetryArg & " /w:" & $SecondsToWaitArg & " /L:" & Chr(34) & $LogFile & Chr(34) & " /v:13 /c /all /i:" & @TempDir & "\USMT\MigApp.xml /i:" & @TempDir & "\USMT\MigSys.xml /i:" & @TempDir & "\USMT\MigUser.xml", @TempDir)
		Else
			_Extract($XPMode)
			ShellExecuteWait(@TempDir & "\USMT\loadstate.exe", Chr(34) & $TargetPath & Chr(34) & " /lac /lae " & $NoCompressArg & "/r:" & $TimesToRetryArg & " /w:" & $SecondsToWaitArg & " /L:" & Chr(34) & $LogFile & Chr(34) & " /v:13 /c /all /i:" & @TempDir & "\USMT\MigApp.xml /i:" & @TempDir & "\USMT\MigDocs.xml /i:" & @TempDir & "\USMT\MigUser.xml", @TempDir)
		EndIf

		Do
			Sleep(1000)
		Until Not ProcessExists("loadstate.exe")
	EndIf
EndFunc   ;==>_RestoreExecute

Func _Extract($XPMode)
	FileInstall("7z.exe", @TempDir & "\7z.exe", 1)
	FileInstall("7z.dll", @TempDir & "\7z.dll", 1)
	DirRemove(@TempDir & "\USMT", 1)
	DirCreate(@TempDir & "\USMT")

	If $XPMode == True Then
		If @OSArch == "X86" Then
			FileInstall("USMT301x86.7z", @TempDir & "\USMT301x86.7z", 1)
			ShellExecuteWait(@TempDir & "\7z.exe", "e " & @TempDir & "\USMT301x86.7z", @TempDir & "\USMT")
		Else
			FileInstall("USMT301x64.7z", @TempDir & "\USMT301x64.7z", 1)
			ShellExecuteWait(@TempDir & "\7z.exe", "e " & @TempDir & "\USMT301x64.7z", @TempDir & "\USMT")
		EndIf
	Else
		If @OSArch == "X86" Then
			FileInstall("USMT401x86.7z", @TempDir & "\USMT401x86.7z", 1)
			ShellExecuteWait(@TempDir & "\7z.exe", "e " & @TempDir & "\USMT401x86.7z", @TempDir & "\USMT")
		Else
			FileInstall("USMT401x64.7z", @TempDir & "\USMT401x64.7z", 1)
			ShellExecuteWait(@TempDir & "\7z.exe", "e " & @TempDir & "\USMT401x64.7z", @TempDir & "\USMT")
		EndIf
	EndIf

	Sleep(500)
EndFunc   ;==>_Extract

Func _Question()
	$QuestionGUI = GUICreate("USMT Front End - MaxImuM AdVaNtAgE SofTWarE © 2011", 480, 400, @DesktopWidth / 2 - 240, @DesktopHeight / 2 - 200)
	GUICtrlCreateLabel("Build Date 02/13/2011", 355, 10, 460, 20)
	GUICtrlCreateLabel("This application is a front end for Microsoft's User State Migration Tool, and contains all USMT files. The User State Migration Tool is a Microsoft command line utility to copy user files and settings from one computer to another  USMT transfers user accounts, E-mai messages, settings, and contacts, photos, music, videos, Windows settings, program data files and settings, and Internet settings." & @CR & @CR & "This tool is designed to work with USMT 3.01 and USMT 4.01, the key difference between the versions being which versions of Windows they restore to.  USMT 3.01 is able to migrate Windows 2000 - Vista to Windows XP and Windows Vista.  USMT 4.01 is able to migrate Windows XP - 7 to Vista and 7.  USMT 4.01 is also able to migrate an " & Chr(34) & "offline" & Chr(34) & " drive, meaning a drive that is not the one being booted from." & @CR & @CR & "The options used in this front end have been customized for backing up only local user account data, so do not use this tool as-is in a network environment where capturing domain user data is important.  The XML files have also not been modified except to not migrate Start Menu files, so this tool may not be suitable if you need to include additional application settings or data than the default items for the respective versions of USMT.  Please refer to the various Microsoft Technet articles concerning USMT for details." & @CR & @CR & "The specific command lines used with all front end options set as default are as follows:" & @CR & @CR & "scanstate.exe $TargetPath /localonly /vsc /efs:decryptcopy /o /nocompress /r:3 /w:1 /L:$LogFile /v:13 /c /all /i:MigApp.xml /i:MigUser.xml /i:MigDocs.xml (or /i:MigSys.xml)" & @CR & @CR & "loadstate.exe $TargetPath /lac /lae /r:3 /w:1 /L:$LogFile /v:13 /c /all /i:MigApp.xml /i:MigUser.xml /i:MigDocs.xml (or /i:MigSys.xml)", 10, 40, 460, 360)
	GUISetBkColor(0xb2ccff, $QuestionGUI)
	GUISetState(@SW_SHOW, $QuestionGUI)
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then
			GUIDelete($QuestionGUI)
			ExitLoop
		EndIf
	Until 1 = 2
EndFunc   ;==>_Question
