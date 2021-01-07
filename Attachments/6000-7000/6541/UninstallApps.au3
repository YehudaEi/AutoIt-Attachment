#include <File.au3>
;#include <RegCount.au3>
#include <Constants.au3>
#include <GuiStatusBar.au3>
#include <GUIConstants.au3>
#include <GuiListView.au3>
$PC = InputBox("PC Name", "Please Enter PC Name or IP")
Local $g_szVersion = "Uninstall Apps"
If WinExists($g_szVersion) Then
	MsgBox(0, "Already Running", "Uninstall Apps has already been launched.")
	Exit; It's already running
EndIf
AutoItWinSetTitle($g_szVersion)

Global $SelectAll = 0
Global $Key = "\\" & $PC & "\" & "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall"


Dim $Title = "Display Uninstall"
Dim $EnableList = 1
Dim $Error = 0
$SelectedCount = 0
HotKeySet("{Esc}", "Stop")
HotKeySet('^a', 'SelectAll')

$mainWindows = GUICreate($Title, 695, 400, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU, $WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
$ulist = GUICtrlCreateListView("Icon|Display Name|Key Name", 5, 40, 685, 320, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES))
GUICtrlSetResizing($ulist, $GUI_DOCKBORDERS)
_GUICtrlListViewSetColumnWidth ($ulist, 0, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListViewSetColumnWidth ($ulist, 1, 310)
_GUICtrlListViewSetColumnWidth ($ulist, 2, 310)
$but1 = GUICtrlCreateButton("Refresh List", 10, 10)
GUICtrlSetResizing($but1, $GUI_DOCKALL)
$but2 = GUICtrlCreateButton("Uninstall Programs", 90, 10)
GUICtrlSetResizing($but2, $GUI_DOCKALL)
GUICtrlSetState($but2, $GUI_DISABLE)
$chkbox = GUICtrlCreateCheckbox("Enable\Disable Silent Uninstall", 200, 12)
GUICtrlSetResizing($chkbox, $GUI_DOCKALL)
$StatusBar1 = _GuiCtrlStatusBarCreate ($mainWindows, 400, "", $SBT_TOOLTIPS)
_GuiCtrlStatusBarSetMinHeight ($StatusBar1, 35)
;GUICtrlCreateProgress ( left, top [, width [, height [, style [, exStyle]]]] )
$Progress1 = GUICtrlCreateProgress(405, 372, 285, 20)
GUICtrlSetResizing($Progress1, $GUI_DOCKSTATEBAR)
GUICtrlSetState(-1, $GUI_HIDE)
GUISetState(@SW_SHOW)
ReadKeys()

While 1; Start the gui
	$MSG = GUIGetMsg()
	Select
		Case $MSG = $but1
			_GUICtrlListViewDeleteAllItems ($ulist)
			ReadKeys()
		Case $MSG = $but2
			$ListIndices = _GUICtrlListViewGetSelectedIndices ($ulist, 1)
			If $ListIndices == $LV_ERR Then ContinueLoop
			If $ListIndices[0] > 1 Then GUICtrlSetState($Progress1, $GUI_SHOW)
			Opt('RunErrorsFatal', 0)
			$Count = 0
			ControlListView('', '', $ulist, "SelectClear")
			For $x = $ListIndices[0] To 1 Step - 1
				$Count += 1
				GUICtrlSetData($Progress1, Int(($Count / $ListIndices[0]) * 100))
				$SelectKey = ''
				$Error = 0
				$ret = _GUICtrlListViewGetItemText ($ulist, $ListIndices[$x])
				$readkey = StringSplit($ret, "|")
				If BitAND(GUICtrlRead($chkbox), $GUI_CHECKED) Then
					$SelectKey = RegRead($Key & "\" & $readkey[2], 'QuietUninstallString')
					If Not @error Then _GuiCtrlStatusBarSetText ($StatusBar1, 'Uninstalling Program ' & $Count & ' Of ' & $ListIndices[0] & '  ' & $readkey[1])
				EndIf
				If BitAND(GUICtrlRead($chkbox), $GUI_UNCHECKED) Or $SelectKey == '' Or $SelectKey == -1 Then
					$SelectKey = RegRead($Key & "\" & $readkey[2], 'UninstallString')
					Msgbox(0,"reg",$Key)
					If Not @error Then	_GuiCtrlStatusBarSetText ($StatusBar1, 'Uninstalling Program ' & $Count & ' Of ' & $ListIndices[0] & '  ' & $readkey[1])
				EndIf
				If @error Or $SelectKey == '' Or $SelectKey == -1 Then
					MsgBox(4144, "Uninstall not available", '"' & $readkey[1] & " | " & $readkey[2] & '"' & " does not support uninstall.")
					$Error = 1
				EndIf
				If $Error == 0 Then $Pid = RunWait($SelectKey, @WorkingDir, @SW_SHOW)
				Msgbox(0,"$SelectKey",$SelectKey)
				If $Error == 1 Or @error Then
					_FileWriteLog(@ScriptDir & '\UninstallFail.Log', $readkey[1] & ' | ' & $readkey[2])
				EndIf
				If $Error == 0 Then ProcessWaitClose($Pid)
				SetError(0)
				RegRead($Key & "\" & $readkey[2], 'UninstallString')
				If @error == 1 Then _GUICtrlListViewDeleteItem ($ulist, $ListIndices[$x])
			Next
			;$Pos = WinGetPos($Title)
			;_GUICtrlListViewScroll($ulist, 0, Number('-' & $Pos[3] * 20))
			Opt('RunErrorsFatal', 1)
			GUICtrlSetData($Progress1, 0)
			If $ListIndices[0] > 1 Then GUICtrlSetState($Progress1, $GUI_HIDE)
			_GuiCtrlStatusBarSetText ($StatusBar1, _GUICtrlListViewGetItemCount ($ulist) & ' Objects')
			GUICtrlSetState($but2, $GUI_DISABLE)
		Case $MSG = $GUI_EVENT_CLOSE
			Exit
			; resize columns based on window size
		Case $MSG = $GUI_EVENT_MINIMIZE
			$width = ControlGetPos($mainWindows, "", $ulist)
			$Resize = $width[2] - _GUICtrlListViewGetColumnWidth ($ulist, 0)
			_GUICtrlListViewSetColumnWidth ($ulist, 1, $Resize / 2.1)
			_GUICtrlListViewSetColumnWidth ($ulist, 2, $Resize / 2.1)
			_GuiCtrlStatusBarResize ($StatusBar1)
		Case $MSG = $GUI_EVENT_MAXIMIZE
			$width = ControlGetPos($mainWindows, "", $ulist)
			$Resize = $width[2] - _GUICtrlListViewGetColumnWidth ($ulist, 0)
			_GUICtrlListViewSetColumnWidth ($ulist, 1, $Resize / 2.1)
			_GUICtrlListViewSetColumnWidth ($ulist, 2, $Resize / 2.1)
			_GuiCtrlStatusBarResize ($StatusBar1)
		Case $MSG = $GUI_EVENT_RESIZED
			$width = ControlGetPos($mainWindows, "", $ulist)
			$Resize = $width[2] - _GUICtrlListViewGetColumnWidth ($ulist, 0)
			_GUICtrlListViewSetColumnWidth ($ulist, 1, $Resize / 2.1)
			_GUICtrlListViewSetColumnWidth ($ulist, 2, $Resize / 2.1)
			_GuiCtrlStatusBarResize ($StatusBar1)
		Case $MSG = $GUI_EVENT_RESTORE
			$width = ControlGetPos($mainWindows, "", $ulist)
			$Resize = $width[2] - _GUICtrlListViewGetColumnWidth ($ulist, 0)
			_GUICtrlListViewSetColumnWidth ($ulist, 1, $Resize / 2.1)
			_GUICtrlListViewSetColumnWidth ($ulist, 2, $Resize / 2.1)
			_GuiCtrlStatusBarResize ($StatusBar1)
		Case Else
			If $EnableList And $SelectedCount == 1 Then
				$EnableList = 0
				GUICtrlSetState($but2, $GUI_ENABLE);enable uninstall button
			EndIf
			If Not $EnableList And $SelectedCount == 0 Then
				$EnableList = 1
				GUICtrlSetState($but2, $GUI_DISABLE);disable uninstall button
			EndIf
			If $SelectedCount <> _GUICtrlListViewGetSelectedCount ($ulist) Then
				$SelectedCount = _GUICtrlListViewGetSelectedCount ($ulist)
				_GuiCtrlStatusBarSetText ($StatusBar1, _GUICtrlListViewGetItemCount ($ulist) & ' Objects, ' & _GUICtrlListViewGetSelectedCount ($ulist) & ' Objects Selected')
			EndIf
	EndSelect
WEnd

Func ReadKeys();read the keys from uninstall section
    _GuiCtrlStatusBarSetText ($StatusBar1, ' Reading Registry Keys, Please Wait....')
    Dim $List[1]
    Dim $Icon[1]
    GUISetCursor(15, 1);set cursor to wait
    $i = 1
    While 1
        $var = RegEnumKey($Key, $i)
        If @error <> 0 Then ExitLoop
        $List[$i - 1] = RegRead($Key & "\" & $var, "DisplayName")
        If $List[$i - 1] = "" Then $List[$i - 1] = RegRead($Key & "\" & $var, "#DisplayName")
        If $List[$i - 1] = "" Then $List[$i - 1] = "No Display Name"
        $Icon[$i - 1] = RegRead($Key & "\" & $var, "DisplayIcon")
        $Icon[$i - 1] = StringReplace(StringMid($Icon[$i - 1], 1, StringInStr($Icon[$i - 1], ',') - 1), '"', '')
        If $Icon[$i - 1] = "" Then $Icon[$i - 1] = "SHELL32.DLL"
        $List[$i - 1] = $List[$i - 1] & '|' & $var & '|' & $Icon[$i - 1]
        ReDim $List[UBound($List) + 1]
        ReDim $Icon[UBound($Icon) + 1]
        $i += 1
    WEnd
    ReDim $List[UBound($List) - 2]
    ReDim $Icon[UBound($Icon) - 2]
    _ArraySort($List)
    GUICtrlSetState($Progress1, $GUI_SHOW)
    For $i = 1 To UBound($List)
        GUICtrlSetData($Progress1, Int(($i / UBound($List)) * 100))
        $Item = StringSplit($List[$i - 1], '|')
        GUICtrlCreateListViewItem("" & "|" & $Item[1] & "|" & $Item[2], $ulist)
        GUICtrlSetImage(-1, $Item[3])
        Sleep(15)
    Next
    Sleep(1000)
    _GuiCtrlStatusBarSetText ($StatusBar1, _GUICtrlListViewGetItemCount ($ulist) & ' Objects')
    GUICtrlSetState($Progress1, $GUI_HIDE)
    GUISetCursor(2, 1);set cursor to arrow
EndFunc;==>ReadKeys

Func SelectAll()
	If $SelectAll Then
		$SelectAll = 0
		GUICtrlSetState($but2, $GUI_DISABLE)
	Else
		$SelectAll = 1
		GUICtrlSetState($but2, $GUI_ENABLE)
	EndIf
	_GUICtrlListViewSetItemSelState ($ulist, -1, $SelectAll)
EndFunc   ;==>SelectAll

Func Stop();exit the gui
	Exit
EndFunc   ;==>Stop