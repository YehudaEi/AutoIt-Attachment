#include <GUIConstants.au3>
#include <Constants.au3>
#include <GUIListView.au3>
#include <File.au3>
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayIconHide", 1)
Opt("TrayMenuMode", 1)

$WM_DROPFILES = 0x233
Global $gaDropFiles[1]
Global $gKeyExistWarning=0
Global $gSort = False
Global $gPageantPath = ".\PuTTY\pageant.exe"
Global $gPuttyPath = ".\PuTTY\putty.exe"
Global $gPageantPID = 0
Global $ppmp_version = "Quick & Dirty"

$Form1 = GUICreate("Pageant & PuTTY Made Portable version: "&$ppmp_version, 395, 312, 234, 145, -1, BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
$Button1 = GUICtrlCreateButton("Launch Pageant && PuTTY", 8, 224, 377, 33, BitOR($BS_CENTER,$BS_FLAT))
GUICtrlSetOnEvent(-1, "AButton1Click")
$Label1 = GUICtrlCreateLabel("Keep me running or the PuTTY settings will not be saved", 60, 292, 272, 17, $SS_CENTER)
$Group1 = GUICtrlCreateGroup(" Keys List ", 8, 8, 377, 209, $BS_FLAT)
$Button2 = GUICtrlCreateButton("Add", 304, 24, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton2Click")
$Button3 = GUICtrlCreateButton("Remove", 304, 56, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton3Click")
$ListView1 = GUICtrlCreateListView("Filename", 16, 24, 281, 185, BitOR($LVS_REPORT,$LVS_SINGLESEL,$LVS_SHOWSELALWAYS,$WS_HSCROLL,$WS_VSCROLL), BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT,$LVS_EX_FLATSB))
$Button4 = GUICtrlCreateButton("Remove all", 304, 88, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton4Click")
$Button5 = GUICtrlCreateButton("Sort", 304, 120, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton5Click")
$Button6 = GUICtrlCreateButton("Load list", 304, 152, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton6Click")
$Button7 = GUICtrlCreateButton("Save list", 304, 184, 73, 25, $BS_FLAT)
GUICtrlSetOnEvent(-1, "AButton7Click")
$CheckBox1 = GUICtrlCreateCheckbox("Launch Pageant && PuTTY", 20, 265, -1, -1, $BS_FLAT)
GUICtrlSetOnEvent(-1, "ACheckBox1Click")
GUICtrlSetState($CheckBox1, $GUI_CHECKED)
$CheckBox2 = GUICtrlCreateCheckbox("Close Pageant && all PuTTY sessions", 185, 265, -1, -1, $BS_FLAT)
GUICtrlSetOnEvent(-1, "ACheckBox2Click")
GUICtrlSetState($CheckBox2, $GUI_UNCHECKED)
GUICtrlSetState($CheckBox2, $GUI_DISABLE)

GUIRegisterMsg($WM_DROPFILES, 'WM_DROPFILES_FUNC')
GUISetOnEvent($GUI_EVENT_MINIMIZE, "MinimizeToTray")
GUISetOnEvent($GUI_EVENT_DROPPED, "FileWasDropped")
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "PopFromTray")
GUICtrlSetState($ListView1, $GUI_DROPACCEPTED)
GUICtrlSetState($Form1, $GUI_NODROPACCEPTED)

GUISetState(@SW_SHOW)

_GUICtrlListViewSetColumnWidth($ListView1, 0, $LVSCW_AUTOSIZE_USEHEADER)
CheckPaths()
LoadKeyList()

While 1
	Sleep(300)
WEnd

Func ImportPuttySettings()
	RunWait("regedit /s putty_save.reg")
EndFunc

Func ExportPuttySettings()
	RunWait("regedit /e putty_tmp.reg HKEY_CURRENT_USER\Software\SimonTatham")
	FileCopy("putty_tmp.reg", "putty_save.reg")
	FileDelete("putty_tmp.reg")
EndFunc

Func RemovePuttySettings()
	RegDelete("HKEY_CURRENT_USER\Software\SimonTatham")
EndFunc

Func Quit()
	DisableGUI()
	SaveKeyList(".\keylist.ppmp")
	If $gPageantPID <> 0 Then
		ClosePageant()
		If (GUICtrlRead($CheckBox1) == 1) Then
			ClosePutty()
		EndIf
	EndIf
	ExportPuttySettings()
	RemovePuttySettings()
	Sleep(200)
    Exit
EndFunc

; Main launcher code
;
Func AButton1Click()
	If $gPageantPID == 0 Then
		GUICtrlSetState($CheckBox1, $GUI_DISABLE)
		GUICtrlSetState($CheckBox2, $GUI_ENABLE)
		RemovePuttySettings()
		ImportPuttySettings()
		$nb_items = _GUICtrlListViewGetItemCount($ListView1)
		$cmd_line = ""
		If $nb_items > 0 Then
			$nb_items = $nb_items - 1
			For $i = 0 To $nb_items
				$cmd_line = $cmd_line & ' "' &_GUICtrlListViewGetItemText($ListView1, $i) & '"'
			Next
		EndIf
		$cmd_line = $gPageantPath & $cmd_line
		If (GUICtrlRead($CheckBox1) == 1) Then
			$cmd_line = $cmd_line & " -c " & $gPuttyPath
		EndIf
		$gPageantPID = Run($cmd_line)
		If (($gPageantPID == 0) And @error) Then
			MsgBox(16, "Error" , "Cannot launch pageant.exe, please look at the README file and check your config.")
		Else
			ACheckBox2Click()
		EndIf
	Else
		GUICtrlSetState($CheckBox1, $GUI_ENABLE)
		GUICtrlSetState($CheckBox2, $GUI_DISABLE)
		If Not ClosePageant() Then
			MsgBox(16, "Fatal Error" , "Cannot close pageant.exe. PuTTY settings will be saved but some processes may still be running.")
		EndIf
		If (GUICtrlRead($CheckBox1) == 1) Then
			ClosePutty()
		EndIf
		ExportPuttySettings()
		RemovePuttySettings()
		ACheckBox1Click()
	EndIf
EndFunc

Func ClosePageant()
	$pid = ProcessExists("pageant.exe")
	ProcessClose($gPageantPID)
	If ($pid <> $gPageantPID) Then
		ProcessClose($pid)
	EndIf
	Sleep(100)
	RefreshSystemTray()
	GUICtrlSetState($Form1, $GUI_FOCUS)
	$gPageantPID = ProcessExists("pageant.exe")		
	If $gPageantPID <> 0 Then
		Return False
		$gPageantPID = 0
	EndIf
	Return True
EndFunc

Func ClosePutty()
	$pid = ProcessExists("putty.exe")
	While $pid
		ProcessClose($pid)
		$pid = ProcessExists("putty.exe")
	WEnd
EndFunc

; Check if we can find Putty.exe and Pageant.exe somewhere
;
Func CheckPaths()
	If Not FileExists($gPageantPath) Then
		If Not FileExists("pageant.exe") Then
			MsgBox(16, "Error" , "pageant.exe not found, please look at the README file")
			GUICtrlSetState($Button1, $GUI_DISABLE)
		Else
			$gPageantPath = "pageant.exe"
		EndIf
	EndIf
	If Not FileExists($gPuttyPath) Then
		If Not FileExists("putty.exe") Then
			MsgBox(16, "Error" , "putty.exe not found, please look at the README file")
			GUICtrlSetState($Button1, $GUI_DISABLE)
		Else
			$gPuttyPath = "putty.exe"
		EndIf
	EndIf
EndFunc

; Checkbox event to launch PuTTY with Pageant
; or to not launch it
;
Func ACheckBox1Click()
	If ( GUICtrlRead($CheckBox1) == 1) Then
		GUICtrlSetData($Button1, "Launch Pageant && PuTTY")
	Else
		GUICtrlSetData($Button1, "Launch Pageant")
	EndIf
EndFunc

Func ACheckBox2Click()
	If ( GUICtrlRead($CheckBox2) == 1) Then
		GUICtrlSetData($Button1, "Close Pageant && All PuTTY sessions && Save PuTTY settings")
	Else
		GUICtrlSetData($Button1, "Close Pageant && Save PuTTY settings")
	EndIf
EndFunc

Func MinimizeToTray()
	GUISetState(@SW_HIDE)
	Opt("TrayIconHide",0)
	TraySetToolTip("PPMP")
EndFunc

Func PopFromTray()
	GUISetState(@SW_SHOW)
	GUISetState(@SW_RESTORE)
	Opt("TrayIconHide", 1)
EndFunc

; Add Keylist
;
Func AButton6Click()
	$merge = True
	If ( _GUICtrlListViewGetItemCount($ListView1) >= 1) Then
 		$res = MsgBox(547, "User choice required.", "If you want to merge files in the list click 'YES', or click 'NO' to replace the current list.")
		If $res == 2 Then Return
 		If $res == 7 Then
			$merge = False
		EndIf
	EndIf
	Local $txtKeyList[1]
	$keyfile = FileOpenDialog("Choose your keyfile list.", ".", "PPMP Keys List (*.ppmp)||All files (*.*)", 10, "keylist.ppmp")
	If Not @error Then
		LoadKeyList($keyfile, $merge)
	EndIf
EndFunc

; Save Keylist
;
Func AButton7Click()
	If ( _GUICtrlListViewGetItemCount($ListView1) >= 1) Then
		DisableGUI()
		$file_name = FileSaveDialog( "Choose a name.", ".", "PPMP Keylists (*.ppmp)|All files (*.*)", 2)
		If (Not(StringInStr($file_name, ".ppmp", 0, -1))) Then
			$file_name = $file_name&".ppmp"
		EndIf
		SaveKeyList($file_name)
		EnableGUI()
	Else
		MsgBox(64, "Warning", "There are no keys to save.")
	EndIf
EndFunc

Func SaveKeyList($pFileName)
	Local $txtKeyList[1]
	$nb_items = _GUICtrlListViewGetItemCount($ListView1)
	If $nb_items > 0 Then
		ReDim $txtKeyList[$nb_items]
		$nb_items = $nb_items - 1
		For $i = 0 To $nb_items
			$txtKeyList[$i] = _GUICtrlListViewGetItemText($ListView1, $i)
		Next
		_FileWriteFromArray($pFileName, $txtKeyList)
	EndIf
EndFunc

Func LoadKeyList($pFileName = ".\keylist.ppmp", $pMerge = True)
	Local $txtKeyList[1]
	If Not $pMerge Then
		_GUICtrlListViewDeleteAllItems($ListView1)
	EndIf
	_FileReadToArray($pFileName, $txtKeyList)
	$nb_items = UBound($txtKeyList) - 1
	$idx = $nb_items
	For $i = 1 to $nb_items
		If Not KeyIsInList($txtKeyList[$i]) Then
			$idx = _GUICtrlListViewInsertItem($ListView1, -1, $txtKeyList[$i])
		EndIf
	Next
	_GUICtrlListViewEnsureVisible($ListView1, $idx, True)
EndFunc

; Sort Listview
;
Func AButton5Click()
	_GUICtrlListViewSort($ListView1, $gSort, 0)
	If Not $gSort Then
		GUICtrlSetData($Button5, "Sort")
	Else
		GUICtrlSetData($Button5, "Reverse sort")
	EndIf
EndFunc

; Remove all keys in the list
;
Func AButton4Click()
	_GUICtrlListViewDeleteAllItems($ListView1)
EndFunc

Func KeyIsInList($pKeyfile)
	If (_GUICtrlListViewFindItem($ListView1, $pKeyfile, -1, $LVFI_STRING, $VK_DOWN) >=  0) Then
		$gKeyExistWarning = 1
		Return True
	EndIf
	Return False
EndFunc

Func KeyExistWarning()
	If $gKeyExistWarning Then
		MsgBox(64, "Warning Key Exist", "One or more keys are already in the list, they have not been added.")
	EndIf
	$gKeyExistWarning = 0
EndFunc

; Add Key(s)
;
Func AButton2Click()
	Local $tmpDrive
	Local $tmpDir
	Local $tmpName
	Local $tmpExt
	$keyfiles = FileOpenDialog("Choose your keyfile(s)", ".", "PuTTY Private Keyfiles (*.ppk)|Keyfiles (*.key)|All files (*.*)", 7)
	If (@error <> 1) Then
		$array_list = StringSplit($keyfiles, "|")
		If (@error == 1) Then
			ReDim $array_list[3]
			_PathSplit($keyfiles, $tmpDrive, $tmpDir, $tmpName, $tmpExt)
			$array_list[0] = 2
			$array_list[1] = StringTrimRight($tmpDrive&$tmpDir, 1)
			$array_list[2] = $tmpName&$tmpExt
		EndIf
		For $cpt = 2 To $array_list[0]
			If Not KeyIsInList($array_list[1]&"\"&$array_list[$cpt]) Then
				$idx = _GUICtrlListViewInsertItem($ListView1, -1, $array_list[1]&"\"&$array_list[$cpt])
				_GUICtrlListViewEnsureVisible($ListView1, $idx, False)
			EndIf
		Next
		_GUICtrlListViewSetColumnWidth($ListView1, 0, $LVSCW_AUTOSIZE)
	EndIf
	KeyExistWarning()
EndFunc

; Remove single key in the list
;
Func AButton3Click()
	$sel_item = _GUICtrlListViewGetCurSel($ListView1)
	If ($sel_item <> $LV_ERR) Then
		_GUICtrlListViewDeleteItemsSelected($ListView1)
		_GUICtrlListViewSetColumnWidth($ListView1, 0, $LVSCW_AUTOSIZE)
	EndIf
EndFunc

; Event to add drag&dropped files in the list
;
Func FileWasDropped()
	Local $idx = 0
	Local $keyExtWarning = 0
	For $i = 0 To UBound($gaDropFiles) - 1
		$attr = FileGetAttrib($gaDropFiles[$i])
		If (@error Or StringInStr($attr, "D") Or StringInStr($attr, "S") Or StringInStr($attr, "O")) Then
			ContinueLoop
		EndIf
		If Not KeyIsInList($gaDropFiles[$i]) Then
			If (Not(StringInStr($gaDropFiles[$i], ".ppk", 0, -1) Or StringInStr($gaDropFiles[$i], ".key", 0, -1))) Then
				$keyExtWarning = 1
			EndIf
			$idx = _GUICtrlListViewInsertItem($ListView1, -1, $gaDropFiles[$i])
		EndIf
	Next
	If $keyExtWarning Then
		MsgBox(48, "Key Warning", "Some of the dropped files may be not compatible with Pageant.", 5)
	EndIf
	If $idx Then
		_GUICtrlListViewEnsureVisible($ListView1, $idx, True)
	EndIf
	KeyExistWarning()
	_GUICtrlListViewSetColumnWidth($ListView1, 0, $LVSCW_AUTOSIZE_USEHEADER)
EndFunc

Func DisableGUI()
	GUICtrlSetState($ListView1, $GUI_NODROPACCEPTED)
	GUICtrlSetState($Button1, $GUI_DISABLE)
	GUICtrlSetState($Button2, $GUI_DISABLE)
	GUICtrlSetState($Button3, $GUI_DISABLE)
	GUICtrlSetState($Button4, $GUI_DISABLE)
	GUICtrlSetState($Button5, $GUI_DISABLE)
	GUICtrlSetState($Button6, $GUI_DISABLE)
	GUICtrlSetState($Button7, $GUI_DISABLE)
	GUICtrlSetState($ListView1, $GUI_DISABLE)
EndFunc

Func EnableGUI()
	GUICtrlSetState($Button1, $GUI_ENABLE)
	GUICtrlSetState($Button2, $GUI_ENABLE)
	GUICtrlSetState($Button3, $GUI_ENABLE)
	GUICtrlSetState($Button4, $GUI_ENABLE)
	GUICtrlSetState($Button5, $GUI_ENABLE)
	GUICtrlSetState($Button6, $GUI_ENABLE)
	GUICtrlSetState($Button7, $GUI_ENABLE)
	GUICtrlSetState($ListView1, $GUI_ENABLE)
	GUICtrlSetState($ListView1, $GUI_DROPACCEPTED)
EndFunc

; Get a files list from Drag&Drop
;
Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("char[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i + 1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc

; ===================================================================
; _RefreshSystemTray($nDealy = 1000)
;
; Removes any dead icons from the notification area.
; Parameters:
;    $nDelay - IN/OPTIONAL - The delay to wait for the notification area to expand with Windows XP's
;        "Hide Inactive Icons" feature (In milliseconds).
; Returns:
;    Sets @error on failure:
;        1 - Tray couldn't be found.
;        2 - DllCall error.
; ===================================================================
Func RefreshSystemTray($nDelay = 1000)
; Save Opt settings
    Local $oldMatchMode = Opt("WinTitleMatchMode", 4)
    Local $oldChildMode = Opt("WinSearchChildren", 1)
    Local $error = 0
    Do; Pseudo loop
        Local $hWnd = WinGetHandle("classname=TrayNotifyWnd")
        If @error Then
            $error = 1
            ExitLoop
        EndIf

        Local $hControl = ControlGetHandle($hWnd, "", "Button1")
        
    ; We're on XP and the Hide Inactive Icons button is there, so expand it
        If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible") Then
            ControlClick($hWnd, "", $hControl)
            Sleep($nDelay)
        EndIf
        
        Local $posStart = MouseGetPos()
        Local $posWin = WinGetPos($hWnd)    
        
        Local $y = $posWin[1]
        While $y < $posWin[3] + $posWin[1]
            Local $x = $posWin[0]
            While $x < $posWin[2] + $posWin[0]
                DllCall("user32.dll", "int", "SetCursorPos", "int", $x, "int", $y)
                If @error Then
                    $error = 2
                    ExitLoop 3; Jump out of While/While/Do
                EndIf
                $x = $x + 8
            WEnd
            $y = $y + 8
        WEnd
        DllCall("user32.dll", "int", "SetCursorPos", "int", $posStart[0], "int", $posStart[1])
    ; We're on XP so we need to hide the inactive icons again.
        If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible") Then
            ControlClick($hWnd, "", $hControl)
        EndIf
    Until 1
    
; Restore Opt settings
    Opt("WinTitleMatchMode", $oldMatchMode)
    Opt("WinSearchChildren", $oldChildMode)
    SetError($error)
EndFunc; _RefreshSystemTray()