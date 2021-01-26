#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Prefs_icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=Preferences editor for ALIBI Run
#AutoIt3Wrapper_Res_Fileversion=4.1.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #include <ButtonConstants.au3>
;~ #include <ComboConstants.au3>
;~ #include <EditConstants.au3>
#include <GUIConstantsEx.au3>
;~ #include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <File.au3>

;################ CHANGE #AutoIt3Wrapper_Res_Fileversion= TO!!! ################
$VER = "4.1.0"
;################ CHANGE #AutoIt3Wrapper_Res_Fileversion= TO!!! ################

AutoItSetOption("TrayAutoPause", 0)
Opt("TrayIconHide", 1)

#CS CHANGELOG
	4.1 Commented out includes that are not used
	4.1 Added setting to have last entered text default in main input
	4.1 Changed visibility to opacity
	4.1 Changed version numbering to keep up with main app
	1.3 Added functionallity to get filename when dropped shortcut
	1.3 Made shourtcut idiot-proof, you can now drop EXE as well
	1.2 Added logo + created labels giving an overview to the inputs
	1.1 Changed a bug where the app did not save preferences if no conflict with old values was detected + made listentry 1 deafult
	
	
	
	
#CE


$INI = @AppDataDir & "\ALIBIRunPreferences.ini"
_Create_INI($INI)
If FileExists($INI) = 0 Then
	$INI = @MyDocumentsDir & "\ALIBIRunPreferences.ini"
	_Create_INI($INI)
EndIf
Global $INI_CUST_CURR[15]
Global $INI_CUST_CURR_DIR[15]
Global $INI_CUST_CURR_PATH[15]
$temp = EnvGet("TEMP")
$Title = "ALIBI Run Preferences editor ver " & $VER
$Run_Path = @ScriptDir & "\run.exe"
FileInstall("ALIBI_Run_ico.ico", $temp & '\ALIBI_Run_ico.ico', 0)
FileInstall("Close_Icon.ico", $temp & '\Close_Icon.ico', 0)
FileInstall("Run_Logo_win.bmp", $temp & '\Run_Logo_win.bmp', 0)
$BFT = 67
$offset_label = 60
$offset_label_Y = 3
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($Title, 767, 305, 346, 182, BitOR($WS_BORDER, $WS_POPUP), BitOR($WS_EX_WINDOWEDGE, $WS_EX_ACCEPTFILES, $WS_EX_LAYERED))
$Exit_Icon = GUICtrlCreateIcon($temp & '\Close_Icon.ico', "", 345, 5)
$ALIBI_Run_Icon = GUICtrlCreateIcon($temp & '\ALIBI_Run_ico.ico', "", 330, 40, 48, 48)
;~ $Move_Icon = GUICtrlCreateIcon(@WindowsDir&"\cursors\3dwmove.cur","",5,50,-1,-1,0,$GUI_WS_EX_PARENTDRAG)
;~ $Title = GUICtrlCreateLabel("ALIBI Run preferences", 50, 0, 235, 26, -1, $GUI_WS_EX_PARENTDRAG)
$Title = GUICtrlCreatePic($temp & '\Run_Logo_win.bmp', 5, 5, 0, 0, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 14, 800, 0, "Courier New")
$Group2 = GUICtrlCreateGroup("Custom List", 384, 0, 377, 297)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
GUICtrlCreateLabel("Item #", 392, 16 + $offset_label_Y, $offset_label, 25)
$Value = GUICtrlCreateCombo("", 392 + $offset_label, 16, 361 - $offset_label, 25)
GUICtrlCreateLabel("Command", 392, 80 + $offset_label_Y, $offset_label, 25)
$Name = GUICtrlCreateInput("", 392 + $offset_label, 80, 361 - $offset_label, 26)
GUICtrlCreateLabel("App Path", 392, 112 + $offset_label_Y, $offset_label, 25)
$EXE = GUICtrlCreateInput("", 392 + $offset_label, 112, 361 - $offset_label, 26, -1)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlCreateLabel("Working Dir", 392, 144 + $offset_label_Y, $offset_label, 25)
$WorkingDir = GUICtrlCreateInput("", 392 + $offset_label, 144, 361 - $offset_label, 26, -1)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)

;~ $Arguments = GUICtrlCreateInput("NOT YET SUPPORTED", 392, 176, 361, 26)
$Add = GUICtrlCreateButton("Add / Save", 392, 208, 177, 40)
$Del = GUICtrlCreateButton("Delete Post", 392, 249, 177, 40)
$Verify = GUICtrlCreateButton("Verify Paths", 576, 208, 177, 40)
$Open = GUICtrlCreateButton("Open Program", 576, 249, 177, 40)
GUICtrlCreateLabel("Drop Shortcut", 392, 48 + $offset_label_Y - 6, $offset_label, 25)
$DropLink = GUICtrlCreateInput('', 392 + $offset_label, 48, 275 - $offset_label, 26, -1)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Convert = GUICtrlCreateButton("Fill Fields", 670, 48, 83, 26)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Basic = GUICtrlCreateGroup("Basic Preferences", 8, 40 + $BFT, 370, 190)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
$PREFS_Import = GUICtrlCreateCheckbox("Use Custom list of items", 13, 54 + $BFT, 350, 20)
$PREFS_Animate_me = GUICtrlCreateCheckbox("Use window animations", 13, 74 + $BFT, 350, 20)
$PREFS_Show_Workgroup = GUICtrlCreateCheckbox('Show computers when chosen "--Workgroup () computers:"', 13, 94 + $BFT, 350, 20)
$PREFS_Show_IP = GUICtrlCreateCheckbox("Show remote IP-Address when selecting a workgroup computer", 13, 114 + $BFT, 350, 20)
$PREFS_Show_Topmost = GUICtrlCreateCheckbox("Always on top", 13, 134 + $BFT, 350, 20)
$PREFS_Make_Default = GUICtrlCreateCheckbox("Make last executed item default", 13, 154 + $BFT, 350, 20)
$PREFS_TransLabel = GUICtrlCreateLabel("Opacity", 13, 160 + 20 + $BFT, 345, 20)
$PREFS_Trans = GUICtrlCreateSlider(13, 180 + 20 + $BFT, 360, 20)

GUICtrlSetLimit($PREFS_Trans, 254, 20)



GUICtrlSetTip($DropLink, "Drop Shortcut here to automatically fill in the other fields!")
GUICtrlSetTip($Name, "This is the string that will execute the program when it is entered in ALIBI Run")
GUICtrlSetTip($EXE, "This is the path to the programs main executable file")
GUICtrlSetTip($WorkingDir, "the programs working directory")
GUICtrlSetTip($Title, "Drag me!")
;~ GUICtrlSetTip($DropLink,"")



GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_UPDATE_BASIC()

_POPULATE_LIST()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Exit_Icon
			Exit
		Case $ALIBI_Run_Icon
			_Open_ALIBI_Run()
		Case $Value
			_ADD_FIELDS()
		Case $Convert
			_SHORTCUT_CONV()
		Case $Add
			_ADD_SAVE("ADD")
		Case $Del
			_ADD_SAVE("DEL")
		Case $Open
			_ADD_SAVE("RUN")
		Case $Verify
			_ADD_SAVE("VER")
		Case $PREFS_Import
			_SAVEPREFS()
		Case $PREFS_Animate_me
			_SAVEPREFS()
		Case $PREFS_Show_Workgroup
			_SAVEPREFS()
		Case $PREFS_Show_IP
			_SAVEPREFS()
		Case $PREFS_Show_Topmost
			_SAVEPREFS()
		Case $PREFS_Trans
			_SAVEPREFS()
		Case $PREFS_Make_Default
			_SAVEPREFS()
	EndSwitch
	WinSetTrans($Form1, "", GUICtrlRead($PREFS_Trans))

WEnd

Func _ADD_SAVE($action)
	$ADD_NAME = GUICtrlRead($Name)
	$ADD_EXE = GUICtrlRead($EXE)
	$ADD_WD = GUICtrlRead($WorkingDir)
	$Number = GUICtrlRead($Value)
	If StringInStr(StringLeft($Number, 2), ":") = 0 Then
		$index = StringLeft($Number, 2) - 1
	Else
		$index = StringLeft($Number, 1) - 1
	EndIf
	If $Number <> "" And $index <= 14 And $index >= 0 And IsNumber($index) = 1 Then

		Switch $action
			Case "ADD"
				If $INI_CUST_CURR[$index] <> "" Then
					$MsgBox_Answer = MsgBox(4 + 262144, "Confirm", "It seems that data is already stored at nr " & $index + 1 & @CRLF & "Overwrite this data:" & @CRLF & "Name: " & _
							$INI_CUST_CURR[$index] & @CRLF & "Path: " & $INI_CUST_CURR_PATH[$index] & @CRLF & "Working Dir: " & $INI_CUST_CURR_DIR[$index] & _
							@CRLF & @CRLF & "With this:" & @CRLF & "Name: " & _
							$ADD_NAME & @CRLF & "Path: " & $ADD_EXE & @CRLF & "Working Dir: " & $ADD_WD)
					If $MsgBox_Answer = 6 Then ;YES
						IniWrite($INI, "CustomList", $index + 1, $ADD_NAME)
						IniWrite($INI, "CustomList", $index + 1 & "Path", $ADD_EXE)
						IniWrite($INI, "CustomList", $index + 1 & "Dir", $ADD_WD)
						_POPULATE_LIST()
					Else
					EndIf
				Else
					IniWrite($INI, "CustomList", $index + 1, $ADD_NAME)
					IniWrite($INI, "CustomList", $index + 1 & "Path", $ADD_EXE)
					IniWrite($INI, "CustomList", $index + 1 & "Dir", $ADD_WD)
					_POPULATE_LIST()
				EndIf
			Case "DEL"
				If $INI_CUST_CURR[$index] <> "" Then
					$MsgBox_Answer = MsgBox(4 + 262144, "Confirm", "Are you sure you want to delete the data stored at " & $index + 1 & @CRLF & @CRLF & "Name: " & _
							$INI_CUST_CURR[$index] & @CRLF & "Path: " & $INI_CUST_CURR_PATH[$index] & @CRLF & "Working Dir: " & $INI_CUST_CURR_DIR[$index])
					If $MsgBox_Answer = 6 Then ;YES
						IniWrite($INI, "CustomList", $index + 1, "")
						IniWrite($INI, "CustomList", $index + 1 & "Path", "")
						IniWrite($INI, "CustomList", $index + 1 & "Dir", "")
						_POPULATE_LIST()
					Else
					EndIf
				EndIf
			Case "RUN"
				ShellExecute($ADD_EXE, "", $ADD_WD)
			Case "VER"
				If FileExists($ADD_EXE) = 1 Then
					MsgBox(262144, "File Found", "Verification completed successfully")
				Else
					MsgBox(262144, "File Not Found", "Verification Failed" & @CRLF & "Check paths and try again")
				EndIf
		EndSwitch

	EndIf

EndFunc   ;==>_ADD_SAVE

Func _Create_INI($INI)
	If FileExists($INI) = 0 Then
		IniWrite($INI, "Preferences", "UseAnimations", 1)
		IniWrite($INI, "Preferences", "Transparancy", 255)
		IniWrite($INI, "Preferences", "AlwaysOnTop", 1)
		IniWrite($INI, "Preferences", "ShowWorkGroupComputers", 0)
		IniWrite($INI, "Preferences", "ShowWorkGroupComputersIP", 0)
;~ 		IniWrite($INI, "Preferences", "AutoCompleteWhileWriting", 1)
		IniWrite($INI, "Preferences", "UseCustomList", 1)
		IniWrite($INI, "Preferences", "MakeLastUsedItemDefault", 1)

		IniWrite($INI, "CustomList", 1, 'Paint')
		IniWrite($INI, "CustomList", 1 & 'Path', 'MSPaint.exe')
		IniWrite($INI, "CustomList", 1 & 'Dir', '')


		For $x = 2 To 15
			IniWrite($INI, "CustomList", $x, '')
			IniWrite($INI, "CustomList", $x & 'Path', '')
			IniWrite($INI, "CustomList", $x & 'Dir', '')
		Next
	EndIf
EndFunc   ;==>_Create_INI

Func _POPULATE_LIST()
	GUICtrlSetData($Value, "")
	For $pop = 1 To 15 Step 1
		$INI_CUST_CURR[$pop - 1] = IniRead($INI, "CustomList", $pop, '')
		$INI_CUST_CURR_PATH[$pop - 1] = IniRead($INI, "CustomList", $pop & "path", "")
		$INI_CUST_CURR_DIR[$pop - 1] = IniRead($INI, "CustomList", $pop & "Dir", "")
		GUICtrlSetData($Value, $pop & ": " & $INI_CUST_CURR[$pop - 1], $pop & ": " & $INI_CUST_CURR[0])
	Next
EndFunc   ;==>_POPULATE_LIST

Func _ADD_FIELDS()
	$Number = GUICtrlRead($Value)
	If StringInStr(StringLeft($Number, 2), ":") = 0 Then
		$index = StringLeft($Number, 2) - 1
	Else
		$index = StringLeft($Number, 1) - 1
	EndIf
	If $Number <> "" And $index <= 14 And $index >= 0 And IsNumber($index) = 1 Then
		GUICtrlSetData($Name, $INI_CUST_CURR[$index])
		GUICtrlSetData($EXE, $INI_CUST_CURR_PATH[$index])
		GUICtrlSetData($WorkingDir, $INI_CUST_CURR_DIR[$index])
	EndIf
EndFunc   ;==>_ADD_FIELDS


Func _UPDATE_BASIC()

	$INI_ANIM = IniRead($INI, "Preferences", "UseAnimations", 1)
	$INI_TRAN = IniRead($INI, "Preferences", "Transparancy", 255)
	$INI_AWOT = IniRead($INI, "Preferences", "AlwaysOnTop", 1)
	$INI_SWGC = IniRead($INI, "Preferences", "ShowWorkGroupComputers", 1)
	$INI_SWGCIP = IniRead($INI, "Preferences", "ShowWorkGroupComputersIP", 1)
	$INI_UYCL = IniRead($INI, "Preferences", "UseCustomList", 1)
	$INI_LEID = IniRead($INI, "Preferences", "MakeLastUsedItemDefault", 1)
	_SETSTATE($PREFS_Import, $INI_UYCL)
	_SETSTATE($PREFS_Animate_me, $INI_ANIM)
	_SETSTATE($PREFS_Show_Workgroup, $INI_SWGC)
	_SETSTATE($PREFS_Show_IP, $INI_SWGCIP)
	_SETSTATE($PREFS_Show_Topmost, $INI_AWOT)
	_SETSTATE($PREFS_Make_Default, $INI_LEID)
	GUICtrlSetData($PREFS_Trans, $INI_TRAN)
EndFunc   ;==>_UPDATE_BASIC


Func _SHORTCUT_CONV()
dim $szDrive,  $szDir,  $szFName,  $szExt
	$SC_PATH = GUICtrlRead($DropLink)
	If FileExists($SC_PATH) = 1 And $SC_PATH <> "" Then
		$Filesplit = _PathSplit($SC_PATH,  $szDrive,  $szDir,  $szFName,  $szExt)
		Switch StringRight($SC_PATH, 3)
			Case 'lnk'
				$SC_DATA = FileGetShortcut($SC_PATH)
				GUICtrlSetData($Name,$Filesplit[3])
				GUICtrlSetData($EXE, $SC_DATA[0]) ;path
				GUICtrlSetData($WorkingDir, $SC_DATA[1]) ;Working Dir
			Case '.exe'
				GUICtrlSetData($Name,$Filesplit[3])
				GUICtrlSetData($EXE, $SC_PATH) ;path
			Case Else
				GUICtrlSetData($Name,$Filesplit[3])
				GUICtrlSetData($EXE, $SC_PATH) ;path
		EndSwitch
		GUICtrlSetData($DropLink, "");Clear droplink text
	Else
		MsgBox(4096, "Please specify path", "You have to drop a shortcut on the input first")
	EndIf
;~ 		GUICtrlSetData($Arguments, $SC_DATA[2]) ;Arguments
EndFunc   ;==>_SHORTCUT_CONV

Func _SAVEPREFS()
	If FileExists($INI) Then
		IniWrite($INI, "Preferences", "UseAnimations", _GETSTATE($PREFS_Animate_me))
		IniWrite($INI, "Preferences", "Transparancy", GUICtrlRead($PREFS_Trans))
		IniWrite($INI, "Preferences", "AlwaysOnTop", _GETSTATE($PREFS_Show_Topmost))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputers", _GETSTATE($PREFS_Show_Workgroup))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputersIP", _GETSTATE($PREFS_Show_IP))
		IniWrite($INI, "Preferences", "UseCustomList", _GETSTATE($PREFS_Import))
	EndIf
EndFunc   ;==>_SAVEPREFS


Func _SETSTATE($ContHndl, $INI_Var)
	If $INI_Var = 1 Then
		GUICtrlSetState($ContHndl, $GUI_CHECKED)
	Else
		GUICtrlSetState($ContHndl, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>_SETSTATE

Func _GETSTATE($ContHndl)
	$State = GUICtrlRead($ContHndl)
	If $State = $GUI_UNCHECKED Then
		$ReturnValue = 0
	Else
		$ReturnValue = 1
	EndIf
;~ 	MsgBox(1,"",$ContHndl & "HAS" & $ReturnValue)
	Return $ReturnValue
EndFunc   ;==>_GETSTATE

Func _Open_ALIBI_Run()
	ShellExecute($Run_Path)
	_Fade_OUT($Form1, GUICtrlRead($PREFS_Trans), 1, 1, 0)
	Exit
EndFunc   ;==>_Open_ALIBI_Run

Func _Fade_OUT($FADE_GUI, $FADE_FROM, $FADE_TO, $FADE_SPEED, $FADE_SPEED2)
	For $FADE_AMOUNT = $FADE_FROM To $FADE_TO Step -$FADE_SPEED
		Sleep($FADE_SPEED2)
		WinSetTrans($FADE_GUI, "", $FADE_AMOUNT)
	Next
EndFunc   ;==>_Fade_OUT
