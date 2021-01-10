#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=au3.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=ShellNew <d3montools>
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights reserved
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cs1 /cn1 /cf1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

FileInstall("au3.ico", @TempDir & "\au3.ico", 1)
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
Opt("GuiOnEventMode", 1)
Dim $SHFile, $SHEXT


#Region AU3 CREATE WINDOW -------------------------------------------------------------------------------------------------------
$au3win = GUICreate("Au3 ShellNew Create <d3montools>", 200, 495, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "_HIDEAU3")

$include = GUICtrlCreateLabel("#include ---------------------------", 2, 2, 200, 17)
GUICtrlSetFont($include, 12, 400, 2)
GUICtrlSetColor($include, 0xFF00FF)
$WindowsConstants = GUICtrlCreateCheckbox("<WindowsConstants.au3>", 5, 25)
$GUIConstantsEx = GUICtrlCreateCheckbox("<GUIConstantsEx.au3>", 5, 45)
$EditConstants = GUICtrlCreateCheckbox("<EditConstants.au3>", 5, 65)

$Opt = GUICtrlCreateLabel("Opt ----------------------------------", 2, 95, 200, 17)
GUICtrlSetFont($Opt, 12, 400, 2)
GUICtrlSetColor($Opt, 0x000066)
$GuiOnEventMode = GUICtrlCreateCheckbox("GuiOnEventMode", 5, 115)
$TrayOnEventMode = GUICtrlCreateCheckbox("TrayOnEventMode", 5, 135)
$TrayMenuMode = GUICtrlCreateCheckbox("TrayMenuMode", 5, 155)

$Gui = GUICtrlCreateLabel("Gui ----------------------------------", 2, 185, 200, 17)
GUICtrlSetFont($Gui, 12, 400, 2)
GUICtrlSetColor($Gui, 0x000066)
$GuiBasic = GUICtrlCreateCheckbox("BASIC WINDOW", 5, 205)
$GuiApp = GUICtrlCreateCheckbox("APPWINDOW+TOOLWINDOW", 5, 225)
$GuiPopup = GUICtrlCreateCheckbox("POPUP+BORDER", 5, 245)

$Func = GUICtrlCreateLabel("Func --------------------------------", 2, 275, 200, 17)
GUICtrlSetFont($Func, 12, 400, 2)
GUICtrlSetColor($Func, 0x0000FF)
$Exit = GUICtrlCreateCheckbox("_Exit", 5, 295)
$Func1 = GUICtrlCreateCheckbox(" ", 5, 315)
$FuncE1 = GUICtrlCreateEdit("MyFunc1", 29, 316, 150, 17, $ES_AUTOVSCROLL)
$Func2 = GUICtrlCreateCheckbox(" ", 5, 335)
$FuncE2 = GUICtrlCreateEdit("MyFunc2", 29, 336, 150, 17, $ES_AUTOVSCROLL)

$While = GUICtrlCreateLabel("While -------------------------------", 2, 365, 200, 17)
$While1 = GUICtrlCreateCheckbox("While 1", 5, 385)
GUICtrlSetFont($While, 12, 400, 2)
GUICtrlSetColor($While, 0x0000FF)

$Build = GUICtrlCreateLabel("Build -------------------------------", 2, 410, 200, 17)
GUICtrlSetFont($Build, 12, 400, 2)
GUICtrlSetColor($Build, 0xFF0000)
$preview = GUICtrlCreateCheckbox("preview built au3", 5, 430)
$load=GUICtrlCreateProgress(5,480,190,10)
GUICtrlCreateButton("Build au3", 5, 455, 190, 20)
GUICtrlSetOnEvent(-1, "_Buildau3")
GUISetState(@SW_HIDE, $au3win)
#EndRegion AU3 CREATE WINDOW -------------------------------------------------------------------------------------------------------

#Region ABOUT WINDOW ------------------------------------------------------------------------------------------------------------
If Not FileExists(@TempDir & "\ShellNewlog.txt") Then
	FileWrite(@TempDir & "\ShellNewlog.txt", "KeepLog")
EndIf

$About = GUICreate("About ShellNew <d3montools>", 350, 200, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUICtrlCreateLabel("---------------------------------------------------------------------", 3, 75, 350, 25)
GUICtrlSetFont(-1, 12)

GUICtrlCreateIcon(@TempDir & "\au3.ico", -1, 20, 20, 48, 48)
GUISetBkColor("0xFFFFFF", $About)
GUICtrlCreateLabel("ShellNew - d3mon Corporation", 100, 20, 300, 25)
GUICtrlSetFont(-1, 12, 400, 1, "Comic Sans MS")

$Keeplog = GUICtrlCreateCheckbox("Keep log after Exit", 100, 50, 300, 25)
GUICtrlSetFont(-1, 10, 400, 1, "Comic Sans MS")

GUICtrlCreateLabel("Contact : d3mon@live.fr", 20, 100, 300, 25)
GUICtrlSetFont(-1, 12)
GUICtrlCreateLabel("[ShellNew : Replace/Remove/Backup]", 20, 120, 330, 25)
GUICtrlSetFont(-1, 12)
GUICtrlCreateLabel("Thanks to Autoit Script", 20, 140, 300, 25)
GUICtrlSetFont(-1, 12)
GUICtrlCreateButton("OK", 100, 170, 150, 25)
GUICtrlSetOnEvent(-1, "_AboutEXIT")
WinSetTrans($About,"",180)
GUISetState(@SW_HIDE, $About)
#EndRegion ABOUT WINDOW ------------------------------------------------------------------------------------------------------------

#Region DEL WINDOW --------------------------------------------------------------------------------------------------------------
$winDEL = GUICreate("ShellNew delete <d3montools>", 170, 30, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "_DELCANCEL")
GUICtrlCreateButton("REGEDIT", 5, 5, 75, 20)
GUICtrlSetOnEvent(-1, "_DELREG")
GUICtrlCreateButton("WINDOWS", 90, 5, 75, 20)
GUICtrlSetOnEvent(-1, "_DELWIN")
GUISetState(@SW_HIDE, $winDEL)
#EndRegion DEL WINDOW --------------------------------------------------------------------------------------------------------------

#Region SHELLNEW WINDOW ---------------------------------------------------------------------------------------------------------
$win = GUICreate("ShellNew  <d3montools>", 425, 395, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
$SH = GUICtrlCreateLabel("ShellNew", 45, 3, 250, 25)
GUICtrlSetFont(-1, 20, 400, 2)
GUICtrlCreateIcon(@TempDir & "\au3.ico", -1, 10, 3, 30, 30)
GUICtrlSetOnEvent(-1, "_About")
GUICtrlSetTip(-2, "About ShellNew...")


GUICtrlCreateGroup("Create / Replace", 5, 35, 200, 145)
GUICtrlSetFont(-1, 10, 400)
GUICtrlCreateLabel("1. Browse your ShellNew.", 15, 55, 185)
GUICtrlSetFont(-1, 12, 400)
GUICtrlCreateButton("Browse ShellNew", 15, 77, 185, 25)
GUICtrlSetOnEvent(-1, "_Browse")
GUICtrlSetFont(-2, 12, 400)
GUICtrlSetTip(-3, "Select your ShellNew")

GUICtrlCreateLabel("2. Re/place ShellNew.", 15, 117, 185)
GUICtrlSetFont(-1, 12, 400)
$ShellNew = GUICtrlCreateButton("Re/place ShellNew", 15, 140, 185, 25)
GUICtrlSetOnEvent(-1, "_ShellNew")
GUICtrlSetState($ShellNew, $GUI_DISABLE)
GUICtrlSetFont($ShellNew, 12, 400)
GUICtrlSetTip($ShellNew, "Re/place ShellNew Selected before")


GUICtrlCreateGroup("Restore / remove", 220, 35, 200, 145)
GUICtrlSetFont(-1, 10, 400)
GUICtrlCreateLabel("Backup ShellNew.", 230, 55, 185)
GUICtrlSetFont(-1, 12, 400)
GUICtrlCreateButton("Backup ShellNew", 225, 77, 185, 25)
GUICtrlSetOnEvent(-1, "_Backup")
GUICtrlSetFont(-2, 12, 400)
GUICtrlSetTip(-3, "Backup ShellNew with windows")

GUICtrlCreateLabel("Remove ShellNew", 230, 117, 185)
GUICtrlSetFont(-1, 12, 400)
GUICtrlCreateButton("Remove ShellNew", 225, 140, 185, 25)
GUICtrlSetOnEvent(-1, "_DEL")
GUICtrlSetFont(-2, 12, 400)
GUICtrlSetTip(-3, "Remove ShellNew with regedit or windows")

$log = GUICtrlCreateEdit("---ShellNew log---", 5, 190, 415, 170, $ES_MULTILINE + $ES_WANTRETURN + $ES_READONLY + $WS_VSCROLL + $ES_AUTOVSCROLL + $WS_HSCROLL + $ES_AUTOHSCROLL)
GUICtrlSetFont(-1, 10)
GUICtrlCreateButton("MINIMIZE", 5, 365, 200)
GUICtrlSetOnEvent(-1, "_MINIMIZE")
GUICtrlSetFont(-2, 10)
GUICtrlCreateButton("CREATE SH AU3", 220, 365, 200)
GUICtrlSetOnEvent(-1, "_SHAU3")
GUICtrlSetFont(-2, 10)
GUISetState(@SW_SHOW, $win)
#EndRegion SHELLNEW WINDOW ---------------------------------------------------------------------------------------------------------

#Region DELWND ------------------------------------------------------------------------------------------------------------------
Func _DEL()
	GUISetState(@SW_SHOW, $winDEL)
EndFunc   ;==>_DEL

Func _DELCANCEL()
	_GUICtrlEdit_AppendText($log, @CRLF & "Remove Function Canceled !")
	GUISetState(@SW_HIDE, $winDEL)
EndFunc   ;==>_DELCANCEL
#EndRegion DELWND ------------------------------------------------------------------------------------------------------------------

#Region DELREG ------------------------------------------------------------------------------------------------------------------
Func _DELREG()
	_GUICtrlEdit_AppendText($log, @CRLF & @CRLF & "--DEL REG ShellNew File--")
	$REGEXT = InputBox("ShellNew REGEDIT <d3montools>", "Tape ShellNew Extension", "", "", 200, 100)

	$RREG = RegRead("HKEY_CLASSES_ROOT\" & $REGEXT & "\ShellNew", "FileName")
	If $RREG = "" Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Extension of ShellNew " & $REGEXT & " not found in regedit !")
		RegDelete("HKEY_CLASSES_ROOT\" & $REGEXT & "\ShellNew")
		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove ShellNew key !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew " & $REGEXT & " registry key Succesfully removed !")
		EndIf
	Else
		GUISetState(@SW_HIDE, $winDEL)
		RegDelete("HKEY_CLASSES_ROOT\" & $REGEXT & "\ShellNew", "FileName")
		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove FileName " & $REGEXT & " registry key !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "FileName " & $REGEXT & " ShellNew registry key Succesfully removed !")
		EndIf

		RegDelete("HKEY_CLASSES_ROOT\" & $REGEXT & "\ShellNew")
		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove ShellNew key !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew " & $REGEXT & " registry key Succesfully removed !")
		EndIf
	EndIf
EndFunc   ;==>_DELREG
#EndRegion DELREG ------------------------------------------------------------------------------------------------------------------

#Region DELWIN ------------------------------------------------------------------------------------------------------------------
Func _DELWIN()
	_GUICtrlEdit_AppendText($log, @CRLF & @CRLF & "--DEL WIN ShellNew File--")

	$DELSN = FileOpenDialog("Select ShellNew File to remove", @WindowsDir & "\ShellNew", "File ()", 1 + 2)

	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "No ShellNew File Selected !")
	Else
		GUISetState(@SW_HIDE, $winDEL)
		$DELSNS = StringSplit($DELSN, '\')
		$i = 1
		While 1
			If $DELSNS[$i] = $DELSNS[$DELSNS[0]] Then ExitLoop

			FileDelete(@TempDir & "\ShellNewDEL.txt")
			FileWrite(@TempDir & "\ShellNewDEL.txt", $DELSNS[$DELSNS[0]])
			$i = $i + 1
		WEnd

		$DELSNEXT = StringRight(FileRead(@TempDir & "\ShellNewDEL.txt"), 4)
		FileDelete($DELSN)

		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove ShellNew File !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew File Succesfully  removed !")
		EndIf

		RegDelete("HKEY_CLASSES_ROOT\" & $DELSNEXT & "\ShellNew", "FileName")
		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove FileName " & FileRead(@TempDir & "\ShellNewDEL.txt") & " registry key !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "FileName " & FileRead(@TempDir & "\ShellNewDEL.txt") & " ShellNew registry key Succesfully removed !")
		EndIf

		RegDelete("HKEY_CLASSES_ROOT\" & $DELSNEXT & "\ShellNew")
		If @error Then
			_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove ShellNew key !")
		Else
			_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew " & FileRead(@TempDir & "\ShellNewDEL.txt") & " registry key Succesfully removed !")
		EndIf
	EndIf
EndFunc   ;==>_DELWIN
#EndRegion DELWIN ------------------------------------------------------------------------------------------------------------------

#Region Browse ------------------------------------------------------------------------------------------------------------------
Func _Browse()
	_GUICtrlEdit_AppendText($log, @CRLF & @CRLF & "--Browsing for ShellNew File--")
	$SHFile = FileOpenDialog("Browse your ShellNew File", @ScriptDir, "ALL FILE (*.*)", 1 + 2)

	If @error Then
		MsgBox(3096, "Error", "No ShellNew File choosen !")
		_GUICtrlEdit_AppendText($log, @CRLF & "No ShellNew File chosen !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew File : " & $SHFile)
		GUICtrlSetState($ShellNew, $GUI_ENABLE)

		$SHSplit = StringSplit($SHFile, '\')
		$i = 1
		While 1
			If $SHSplit[$i] = $SHSplit[$SHSplit[0]] Then ExitLoop
			FileDelete(@TempDir & "\ShellNew.txt")
			FileWrite(@TempDir & "\ShellNew.txt", $SHSplit[$SHSplit[0]])
			$i = $i + 1
		WEnd
	EndIf
EndFunc   ;==>_Browse
#EndRegion Browse ------------------------------------------------------------------------------------------------------------------

#Region ShellNew ----------------------------------------------------------------------------------------------------------------
Func _ShellNew()
	_GUICtrlEdit_AppendText($log, @CRLF & @CRLF & "--Re/place ShellNew File--")

	FileCopy(@WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNew.txt"), @WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNew.txt") & ".bak")
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't rename old ShellNew File !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "Old ShellNew File Succesfully Renamed !")
	EndIf

	FileCopy($SHFile, @WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNew.txt"))
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't Copy ShellNew File !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew File Succesfully Copied !")
	EndIf

	$SHEXT = StringRight(FileRead(@TempDir & "\ShellNew.txt"), 4)
	RegDelete("HKEY_CLASSES_ROOT\" & $SHEXT & "\ShellNew", "FileName")
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove FileName for " & $SHEXT & " extension registry key !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "FileName " & $SHEXT & " ShellNew registry key Succesfully removed !")
	EndIf

	RegWrite("HKEY_CLASSES_ROOT\" & $SHEXT & "\ShellNew")
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't Create ShellNew key !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "ShellNew " & FileRead(@TempDir & "\ShellNew.txt") & " registry key Succesfully Created !")
	EndIf

	RegWrite("HKEY_CLASSES_ROOT\" & $SHEXT & "\ShellNew", "FileName", "REG_SZ", @WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNew.txt"))
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't write/replace ""FileName"" registry Key !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "FileName registry key Succesfully wrote !")
	EndIf
EndFunc   ;==>_ShellNew


#Region BACKUP ------------------------------------------------------------------------------------------------------------------
Func _Backup()
	_GUICtrlEdit_AppendText($log, @CRLF & @CRLF & "--Backup ShellNew File--")

	$BUSN = FileOpenDialog("Select ShellNew File to Backup", @WindowsDir & "\ShellNew", "Back File (*.bak)", 1 + 2)

	$BUSNS = StringSplit($BUSN, '\')
	$i = 1
	While 1
		If $BUSNS[$i] = $BUSNS[$BUSNS[0]] Then ExitLoop

		FileDelete(@TempDir & "\ShellNewBack.txt")
		FileWrite(@TempDir & "\ShellNewBack.txt", $BUSNS[$BUSNS[0]])
		$i = $i + 1
	WEnd

	$BUSNAME = StringTrimRight(FileRead(@TempDir & "\ShellNewBack.txt"), 4)
	$BUSNEXT = StringRight($BUSNAME, 4)

	FileCopy(@WindowsDir & "\ShellNew\" & $BUSNAME, @TempDir & "\ShellNew\" & $BUSNAME, 1)
	FileMove(@WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNewBack.txt"), @WindowsDir & "\ShellNew\" & $BUSNAME, 1)
	FileMove(@TempDir & "\ShellNew\" & $BUSNAME, @WindowsDir & "\ShellNew\" & FileRead(@TempDir & "\ShellNewBack.txt"), 1)

	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't place Back File !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "Back File Succesfully placed !")
	EndIf

	RegDelete("HKEY_CLASSES_ROOT\" & $BUSNEXT & "\ShellNew", "FileName")
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't remove ""FileName"" " & $BUSNAME & " registry key !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "FileName " & $BUSNAME & " ShellNew registry key Succesfully removed !")
	EndIf

	RegWrite("HKEY_CLASSES_ROOT\" & $BUSNEXT & "\ShellNew", "FileName", "REG_SZ", @WindowsDir & "\ShellNew\" & $BUSNAME)
	If @error Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Can't write/replace ""FileName"" registry Key !")
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "FileName registry key Succesfully wrote !")
	EndIf
EndFunc   ;==>_Backup
#EndRegion BACKUP ------------------------------------------------------------------------------------------------------------------

#Region BuildAu3 ----------------------------------------------------------------------------------------------------------------
Func _Buildau3()
	FileDelete(@ScriptDir & "\Nouveau AutoIt v3 Script.au3")
	GUICtrlSetData($load, 3)

	If (GUICtrlRead($WindowsConstants) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", "#include <WindowsConstants.au3>")
	EndIf

	GUICtrlSetData($load, 12)
	If (GUICtrlRead($GUIConstantsEx) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & "#include <GUIConstantsEx.au3>")
	EndIf

	GUICtrlSetData($load, 20)
	If (GUICtrlRead($EditConstants) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & "#include <EditConstants.au3>")
	EndIf

	GUICtrlSetData($load, 26)
	If (GUICtrlRead($GuiOnEventMode) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "Opt(""GuiOnEventMode"",1)")
	EndIf

	GUICtrlSetData($load, 34)
	If (GUICtrlRead($TrayOnEventMode) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & "Opt(""TrayOnEventMode"",1)")
	EndIf

	GUICtrlSetData($load, 40)
	If (GUICtrlRead($TrayMenuMode) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & "Opt(""TrayMenuMode"",1)")
	EndIf

	GUICtrlSetData($load, 48)
	If (GUICtrlRead($GuiBasic) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "GuiCreate("""", 200, 200, -1, -1, -1)" & @CRLF & "GuiSetState()")
	EndIf

	GUICtrlSetData($load, 55)
	If (GUICtrlRead($GuiApp) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "GuiCreate("""", 200, 200, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))" & @CRLF & "GuiSetState()")
	EndIf

	GUICtrlSetData($load, 62)
	If (GUICtrlRead($GuiPopup) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "GuiCreate("""", 200, 200, -1, -1, $WS_POPUP+$WS_BORDER)" & @CRLF & "GuiSetState()")
	EndIf

	GUICtrlSetData($load, 69)
	If (GUICtrlRead($Exit) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "Func _Exit()" & @CRLF & "Exit" & @CRLF & "EndFunc")
	EndIf

	GUICtrlSetData($load, 76)
	If (GUICtrlRead($Func1) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "Func " & GUICtrlRead($FuncE1) & "()" & @CRLF & ";---------" & @CRLF & "EndFunc")
	EndIf

	GUICtrlSetData($load, 83)
	If (GUICtrlRead($Func2) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "Func " & GUICtrlRead($FuncE2) & "()" & @CRLF & ";---------" & @CRLF & "EndFunc")
	EndIf

	GUICtrlSetData($load, 90)
	If (GUICtrlRead($While1) = $GUI_CHECKED) Then
		FileWrite(@ScriptDir & "\Nouveau AutoIt v3 Script.au3", @CRLF & @CRLF & "While 1" & @CRLF & "Sleep(100)" & @CRLF & "WEnd")
	EndIf

	GUICtrlSetData($load, 100)
	MsgBox(64,"ShellNew au3","ShellNew au3 created !",3)
	
	If (GUICtrlRead($preview) = $GUI_CHECKED) Then
		FileClose(@ScriptDir & "\Nouveau AutoIt v3 Script.au3")
		_GUICtrlEdit_AppendText($log, @CRLF & "--Running Notepad--")
		ShellExecute(@SystemDir & "\Notepad.exe", @ScriptDir & "\Nouveau AutoIt v3 Script.au3")
	EndIf
EndFunc   ;==>_Buildau3

Func _SHAU3()
	GUISetState(@SW_MINIMIZE, $win)
	_GUICtrlEdit_AppendText($log, @CRLF & "--ShellNew au3 Create--")
	GUISetState(@SW_SHOW, $au3win)
EndFunc   ;==>_SHAU3

Func _HIDEAU3()
	GUISetState(@SW_HIDE, $au3win)
	_GUICtrlEdit_AppendText($log, @CRLF & "--au3 ShellNew Create closed--")
EndFunc   ;==>_HIDEAU3
#EndRegion BuildAu3 ----------------------------------------------------------------------------------------------------------------

#Region Func --------------------------------------------------------------------------------------------------------------------
Func _About()
	If FileRead(@TempDir & "\ShellNewlog.txt") = "KeepLog" Then
		GUICtrlSetState($Keeplog, $GUI_CHECKED)
	Else
		GUICtrlSetState($Keeplog, $GUI_UNCHECKED)
	EndIf
	GUISetState(@SW_SHOW, $About)
EndFunc   ;==>_About

Func _AboutExit()
	If GUICtrlRead($Keeplog) = $GUI_CHECKED Then
		FileDelete(@TempDir & "\ShellNewlog.txt")
		FileWrite(@TempDir & "\ShellNewlog.txt", "KeepLog")
	Else
		FileDelete(@TempDir & "\ShellNewlog.txt")
		FileWrite(@TempDir & "\ShellNewlog.txt", "NoKeepLog")
	EndIf
	GUISetState(@SW_HIDE, $About)
EndFunc   ;==>_AboutExit

Func _MINIMIZE()
	_GUICtrlEdit_AppendText($log, @CRLF & "--ShellNew window Minimized--")
	GUISetState(@SW_MINIMIZE, $win)
EndFunc   ;==>_MINIMIZE

Func _Exit()
	FileDelete(@TempDir & "\ShellNew.txt")
	FileDelete(@TempDir & "\ShellNewDEL.txt")
	FileDelete(@TempDir & "\ShellNewBack.txt")

	If FileRead(@TempDir & "\ShellNewlog.txt") = "KeepLog" Then
		_GUICtrlEdit_AppendText($log, @CRLF & "Exiting ShellNew..." & @CRLF & "--End log--")
		FileWrite(@ScriptDir & "\log.txt", @CRLF & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF & GUICtrlRead($log) & @CRLF)
		Exit
	Else
		_GUICtrlEdit_AppendText($log, @CRLF & "Exiting ShellNew..." & @CRLF & "--End log--")
		Exit
	EndIf
EndFunc   ;==>_Exit
#EndRegion Func --------------------------------------------------------------------------------------------------------------------


While 1
	Sleep(150)
	For $MOVE = 45 To 425
		ControlMove($win, "", $SH, $MOVE, 3)
		Sleep(25)
	Next
WEnd