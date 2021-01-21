;by MsCreatoR (G.Sandler).

#NoTrayIcon
#include <GuiConstants.au3>
#include <Constants.au3>
;

Global $AppName 			= "AutoIt Path Switcher"
Global $Config_File 		= StringTrimRight(@ScriptFullPath, 3) & "ini"

Global $Read_Default_Action = RegRead("HKCR\AutoIt3Script\Shell", "")
Global $AutExe_Command		= StringRegExpReplace(RegRead("HKCR\AutoIt3Script\Shell\Run\Command", ""), '\\[^\\]*$|"', '')
Global $Combo_Data			= GetAutoItPaths($Config_File, "AutoIt Paths")

Global $GUI 				= GuiCreate($AppName, 350, 220)

GUICtrlCreateGroup("AutoIt3 Directory:", 10, 10, 330, 55)

$AutoIt_Dir_Combo = GUICtrlCreateCombo("", 20, 30, 290, 20)
GUICtrlSetData(-1, $Combo_Data, $AutExe_Command)
$Sel_AutoIt_Dir_Button = GUICtrlCreateButton("...", 315, 30, 20, 20)
GUICtrlSetTip(-1, "Select AutoIt main path...")

GUICtrlCreateGroup("Select default action when executing *.au3 file:", 10, 90, 330, 70)

$Run_Script_Radio = GUICtrlCreateRadio("Run Script", 20, 110)
GUICtrlSetState(-1, $GUI_CHECKED)

$Edit_Script_Radio = GUICtrlCreateRadio("Edit Script (Recommended)", 20, 130)
If $Read_Default_Action = "Edit" Then GUICtrlSetState(-1, $GUI_CHECKED)

$OK_Button = GUICtrlCreateButton("OK", 10, 180, 70, 20)
$Exit_Button = GUICtrlCreateButton("Exit", 90, 180, 70, 20)

$Switch_Button = GUICtrlCreateButton("Switch", 270, 180, 70, 20)

;Tray Section
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "TrayMainEvents")
TraySetToolTip($AppName)
TraySetClick(16)

$ShowApp_TrayItem = TrayCreateItem("Show <" & $AppName & ">")
TrayItemSetState(-1, $TRAY_DEFAULT)
TrayItemSetOnEvent(-1, "TrayMainEvents")

$Sel_AutoIt_Dir_TrayItem = TrayCreateItem("Select AutoIt main path...")
TrayItemSetOnEvent(-1, "TrayMainEvents")

$ExitApp_TrayItem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "TrayMainEvents")

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $Exit_Button
			QuitApp()
		Case $GUI_EVENT_MINIMIZE
			TraySetState(1)
			GUISetState(@SW_HIDE)
		Case $Sel_AutoIt_Dir_Button
			SelectAutoItPath_Proc()
		Case $Switch_Button
			SwitchAutoItPath_Proc()
		Case $OK_Button
			SwitchAutoItPath_Proc(1)
			If @error Then ContinueLoop
			
			QuitApp()
	EndSwitch
WEnd

Func TrayMainEvents()
	Switch @TRAY_ID
		Case $TRAY_EVENT_PRIMARYDOWN, $ShowApp_TrayItem
			TraySetState(2)
			GUISetState(@SW_SHOW)
			GUISetState(@SW_RESTORE)
		Case $Sel_AutoIt_Dir_TrayItem
			SelectAutoItPath_Proc()
		Case $ExitApp_TrayItem
			QuitApp()
	EndSwitch
EndFunc

Func SelectAutoItPath_Proc()
	Local $iError = 0
	$Init_Au3_Dir = GUICtrlRead($AutoIt_Dir_Combo)
	
	If _WinIsVisible($GUI) Then
		GUISetState(@SW_DISABLE, $GUI)
	Else
		TraySetState(2)
	EndIf
	
	While 1
		$Sel_AutoIt_Dir = FileSelectFolder("Select AutoIt Dir", "", 0, $Init_Au3_Dir)
		If @error Then
			$iError = 1
			ExitLoop
		EndIf
		
		If Not _IsAutoItDir($Sel_AutoIt_Dir) Then
			_MsgBox(262144+48, "Attention!", "Can not find AutoIt3.exe, please select AutoIt dir.", $GUI)
			$Init_Au3_Dir = $Sel_AutoIt_Dir
			ContinueLoop
		EndIf
		
		GUICtrlSetData($AutoIt_Dir_Combo, $Sel_AutoIt_Dir, $Sel_AutoIt_Dir)
		ExitLoop
	WEnd
	
	If _WinIsVisible($GUI) Then
		GUISetState(@SW_ENABLE, $GUI)
	Else
		TraySetState(1)
		
		If Not $iError Then
			Local $Ask_Switch = MsgBox(262144+36, $AppName & " - Question", "Would you like to switch selected AutoIt path?")
			If $Ask_Switch = 6 Then SwitchAutoItPath_Proc()
		EndIf
	EndIf
EndFunc

Func SwitchAutoItPath_Proc($iFlag=0)
	Local $sAutoIt_Path = GUICtrlRead($AutoIt_Dir_Combo)
	
	If Not _IsAutoItDir($sAutoIt_Path) Then
		_MsgBox(48, $AppName & " - Error!", "Please set correct AutoIt3 directory.", $GUI)
		Return SetError(1, 0, 0)
	EndIf
	
	$Default_Action = "Edit"
	If GUICtrlRead($Run_Script_Radio) = $GUI_CHECKED Then $Default_Action = "Run"
	
	RegWrite("HKCR\.au3", "", "REG_SZ", "AutoIt3Script")
	
	RegWrite("HKCR\AutoIt3Script", "", "REG_SZ", "AutoIt v3 Script")
	RegWrite("HKCR\AutoIt3Script\DefaultIcon", "", "REG_SZ", $sAutoIt_Path & "\Icons\filetype1.ico")
	RegWrite("HKCR\AutoIt3Script\Shell", "", "REG_SZ", $Default_Action)
	
	RegWrite("HKCR\AutoIt3Script\Shell\Compile", "", "REG_SZ", "Compile Script")
	RegWrite("HKCR\AutoIt3Script\Shell\Compile\Command", "", "REG_SZ", '"' & $sAutoIt_Path & '\Aut2Exe\Aut2Exe.exe" /in "%l"')
	RegWrite("HKCR\AutoIt3Script\Shell\Edit", "", "REG_SZ", "Edit Script")
	RegWrite("HKCR\AutoIt3Script\Shell\Edit\Command", "", "REG_SZ", '"' & $sAutoIt_Path & '\SciTE\SciTE.exe" "%1"')
	
	RegWrite("HKCR\AutoIt3Script\Shell\Run", "", "REG_SZ", "Run Script")
	RegWrite("HKCR\AutoIt3Script\Shell\Run\Command", "", "REG_SZ", '"' & $sAutoIt_Path & '\AutoIt3.exe" "%1" %*')
	
	RegWrite("HKCR\AutoIt3Script\Shell\Open\Command", "", "REG_SZ", '"' & $sAutoIt_Path & '\SciTE\SciTE.exe" "%1"')
	RegWrite("HKCR\Applications\SciTE.exe\shell\open\command", "", "REG_SZ", '"' & $sAutoIt_Path & '\SciTE\SciTE.exe" "%1"')
	RegWrite("HKCR\Applications\AutoIt3.exe\shell\open\command", "", "REG_SZ", '"' & $sAutoIt_Path & '\AutoIt3.exe" "%1"')
	
	RegWrite("HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir", "REG_SZ", $sAutoIt_Path)
	
	If $iFlag = 0 Then
		GUICtrlSetData($AutoIt_Dir_Combo, $sAutoIt_Path, $sAutoIt_Path)
		_MsgBox(262144+64, $AppName & " - Done!", "Now this AutoIt Path is used:" & @LF & "[" & $sAutoIt_Path & "]", $GUI)
	EndIf
	
	Return $sAutoIt_Path
EndFunc

Func GetAutoItPaths($sConfig, $sSection)
	Local $aPaths = IniReadSection($sConfig, $sSection)
	Local $sRetPaths = ""
	
	For $i = 1 To UBound($aPaths)-1
		If $aPaths[$i][1] = 1 Then $sRetPaths &= $aPaths[$i][0] & "|"
	Next
	
	If $sRetPaths = "" Then Return GetAutoItMainPath()
	
	Return StringRegExpReplace($sRetPaths, "\A\|+|\|+$|(\|)+", "\1")
EndFunc

Func GetAutoItMainPath()
	$Au3_Ret_Path = RegRead("HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
	If Not _IsAutoItDir($Au3_Ret_Path) Then $Au3_Ret_Path = RegRead("HKLM\SOFTWARE\Wow6432Node\AutoIt v3\AutoIt", "InstallDir")
	If Not _IsAutoItDir($Au3_Ret_Path) Then $Au3_Ret_Path = @ProgramFilesDir & "\AutoIt3"
	If Not _IsAutoItDir($Au3_Ret_Path) Then Return @ScriptDir & "\AutoIt3"
	Return $Au3_Ret_Path
EndFunc

Func GetComboArray($hComboBox, $sDelimiter = "|")
	Local $sDelim = $sDelimiter, $sResult, $nItem, $Struct
	For $i = 0 To GUICtrlSendMsg($hComboBox, $CB_GETCOUNT, 0, 0) - 1
		$Struct = DllStructCreate("char[" & GUICtrlSendMsg($hComboBox, $CB_GETLBTEXTLEN, $i, 0) + 1 & "]")
		DllCall("user32.dll", "int", "SendMessageA", "hwnd", GUICtrlGetHandle($hComboBox), _
			"int", $CB_GETLBTEXT, "int", $i, "ptr", DllStructGetPtr($Struct))
		
		$nItem = DllStructGetData($Struct, 1)
		If $nItem <> "" Then $sResult &= $nItem & $sDelimiter
	Next
	
	$sResult = StringRegExpReplace($sResult, "\A\" & $sDelim & "+|\" & $sDelim & "+$|(\" & $sDelim & ")+", "\1")
	
	Return StringSplit($sResult, "|")
EndFunc

Func _MsgBox($MsgBoxType, $MsgBoxTitle, $MsgBoxText, $hWnd=0)
	Local $iRet = DllCall ("user32.dll", "int", "MessageBox", _
			"hwnd", $hWnd, _
			"str", $MsgBoxText , _
			"str", $MsgBoxTitle, _
			"int", $MsgBoxType)
	Return $iRet[0]
EndFunc

Func _WinIsVisible($sTitle)
	Return BitAND(WinGetState($sTitle), 2)
EndFunc

Func _IsAutoItDir($sPath)
	Return FileExists($sPath & "\AutoIt3.exe")
EndFunc

Func QuitApp()
	$aAutoIt_Paths = GetComboArray($AutoIt_Dir_Combo)

	For $i = 1 To UBound($aAutoIt_Paths)-1
		IniWrite($Config_File, "AutoIt Paths", $aAutoIt_Paths[$i], "1")
	Next
	Exit
EndFunc
