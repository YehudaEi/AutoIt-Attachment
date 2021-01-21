If WinExists("D577DA59-6CBD-47f8-99D4-362111D8BAE0") Then Exit
AutoItWinSetTitle("D577DA59-6CBD-47f8-99D4-362111D8BAE0")

Global Const $GUI_EVENT_CLOSE			= -3
Global Const $GUI_EVENT_MINIMIZE		= -4
Global Const $GUI_EVENT_RESTORE			= -5
Global Const $GUI_EVENT_MAXIMIZE		= -6
Global Const $GUI_EVENT_PRIMARYDOWN		= -7
Global Const $GUI_EVENT_PRIMARYUP		= -8
Global Const $GUI_EVENT_SECONDARYDOWN	= -9
Global Const $GUI_EVENT_SECONDARYUP		= -10
Global Const $GUI_EVENT_MOUSEMOVE		= -11
Global Const $GUI_EVENT_RESIZED			= -12

Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE 			= 32
Global Const $GUI_FOCUS			= 256
Global Const $GUI_DEFBUTTON		= 512

Global Const $WS_TILED				= 0
Global Const $WS_OVERLAPPED 		= 0
Global Const $WS_MAXIMIZEBOX		= 0x00010000
Global Const $WS_MINIMIZEBOX		= 0x00020000
Global Const $WS_TABSTOP			= 0x00010000
Global Const $WS_GROUP				= 0x00020000
Global Const $WS_SIZEBOX			= 0x00040000
Global Const $WS_THICKFRAME			= 0x00040000
Global Const $WS_SYSMENU			= 0x00080000
Global Const $WS_HSCROLL			= 0x00100000
Global Const $WS_VSCROLL			= 0x00200000
Global Const $WS_DLGFRAME 			= 0x00400000
Global Const $WS_BORDER				= 0x00800000
Global Const $WS_CAPTION			= 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW	= 0x00CF0000
Global Const $WS_TILEDWINDOW		= 0x00CF0000
Global Const $WS_MAXIMIZE			= 0x01000000
Global Const $WS_CLIPCHILDREN		= 0x02000000
Global Const $WS_CLIPSIBLINGS		= 0x04000000
Global Const $WS_DISABLED 			= 0x08000000
Global Const $WS_VISIBLE			= 0x10000000
Global Const $WS_MINIMIZE			= 0x20000000
Global Const $WS_CHILD				= 0x40000000
Global Const $WS_POPUP				= 0x80000000
Global Const $WS_POPUPWINDOW		= 0x80880000

Global Const $DS_MODALFRAME 		= 0x80
Global Const $DS_SETFOREGROUND		= 0x00000200
Global Const $DS_CONTEXTHELP		= 0x00002000

Global Const $WS_EX_ACCEPTFILES			= 0x00000010
Global Const $WS_EX_MDICHILD			= 0x00000040
Global Const $WS_EX_APPWINDOW			= 0x00040000
Global Const $WS_EX_CLIENTEDGE			= 0x00000200
Global Const $WS_EX_CONTEXTHELP			= 0x00000400
Global Const $WS_EX_DLGMODALFRAME 		= 0x00000001
Global Const $WS_EX_LEFTSCROLLBAR 		= 0x00004000
Global Const $WS_EX_OVERLAPPEDWINDOW	= 0x00000300
Global Const $WS_EX_RIGHT				= 0x00001000
Global Const $WS_EX_STATICEDGE			= 0x00020000
Global Const $WS_EX_TOOLWINDOW			= 0x00000080
Global Const $WS_EX_TOPMOST				= 0x00000008
Global Const $WS_EX_TRANSPARENT			= 0x00000020
Global Const $WS_EX_WINDOWEDGE			= 0x00000100
Global Const $WS_EX_LAYERED				= 0x00080000
Global Const $GUI_WS_EX_PARENTDRAG =      0x00100000

Global Const $LVS_ICON	 			= 0x0000
Global Const $LVS_REPORT 			= 0x0001
Global Const $LVS_SMALLICON			= 0x0002
Global Const $LVS_LIST				= 0x0003
Global Const $LVS_EDITLABELS		= 0x0200
Global Const $LVS_NOCOLUMNHEADER	= 0x4000
Global Const $LVS_NOSORTHEADER		= 0x8000
Global Const $LVS_SINGLESEL			= 0x0004
Global Const $LVS_SHOWSELALWAYS		= 0x0008

Global Const $SS_RIGHT			= 2

Global Const $GUI_SS_DEFAULT_LISTVIEW	= BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS)
Global Const $GUI_SS_DEFAULT_GUI		= $WS_OVERLAPPEDWINDOW

Global Const $TRAY_CHECKED				= 1
Global Const $TRAY_UNCHECKED			= 4
Global Const $TRAY_ENABLE				= 64
Global Const $TRAY_DISABLE				= 128
Global Const $TRAY_FOCUS				= 256
Global Const $TRAY_DEFAULT				= 512

Global Const $LVCF_FMT = 0x1
Global Const $LVCF_WIDTH = 0x2
Global Const $LVCF_TEXT = 0x4
Global Const $LVCFMT_CENTER = 0x2
Global Const $LVCFMT_LEFT = 0x0
Global Const $LVCFMT_RIGHT = 0x1
Global Const $LVM_FIRST = 0x1000
Global Const $LVM_INSERTCOLUMNA = ($LVM_FIRST + 27)

Opt("GUICoordMode", 0)
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayIconDebug", 1)
TraySetClick(16)

_GUI()
_ReadPrefs()

If $CmdLine[0] > 0 And $CmdLine[1] = "min" Then	_Minimize()

While 1
	
	$WinState = WinGetState("Process Manager")

	While BitAND($WinState, 2) And Not BitAND($WinState, 16)
		
		$WinState = WinGetState("Process Manager")
		If Not BitAND($WinState, 1) Then ExitLoop
		If Not BitAND($WinState, 2) Then ExitLoop
		If BitAND($WinState, 16) Then ExitLoop
		
		Global $Selection
		If GUICtrlRead($ListView) <> 0 Then
			$Split = StringSplit(GUICtrlRead(GUICtrlRead($ListView)), "|")
			$Selection = $Split[2]
			$Split = 0
		EndIf
		
		Global $ProcessList = ProcessList()
		Global $SortFlag
		If $ListViewItems[0] <> $ProcessList[0][0] Then
			For $i = 1 To $ProcessList[0][0]
				If $ProcessList[$i][0] = "[System Process]" Then
					$ProcessList[$i][0] = "System Idle Process"
					ExitLoop
				EndIf
			Next
			_ArraySort($ProcessList, $SortFlag, 1, 0, 2)
			_ListUpdate($ProcessList)
		EndIf

		$aMemStats = MemGetStats()
		GUICtrlSetData($MemStats, $aMemStats[0] & "% Mem Load")
		
		Sleep(500)
			
	WEnd
	
	Sleep(500)
		
WEnd

Func _GUI()
	
	Global $Window = GUICreate("Process Manager", 250, 480, -1, -1, $GUI_SS_DEFAULT_GUI)
	GUISetState(@SW_SHOW, $Window)
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Minimize")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")
	
	Dim $x = 0, $y = 0
	GUICtrlCreateGroup("", $x + 5, $y + 5, 242, 455)
	GUICtrlSetResizing(-1, (2 + 4 + 32 + 64))
;~ 	
;~ 	Global $Sort = GUICtrlCreateButton("&Sort", $x + 8, $y + 20, 224, 20)
;~ 	GUICtrlSetOnEvent($Sort, "_Sort")
;~ 	GUICtrlSetResizing($Sort, (38 + 512))
;~ 	$y = 20
	
	Global $ListView = GUICtrlCreateListView("Process Name|ID", $x + 8, $y + 20, 224, 395, $GUI_SS_DEFAULT_LISTVIEW)
	GUICtrlSetOnEvent($ListView, "_Sort")
	GUICtrlSetState($ListView, $GUI_FOCUS)
	GUICtrlSetResizing($ListView, (2 + 4 + 32 + 64))
	$y = 395
	
	Global $ProcessCount = GUICtrlCreateLabel("", $x - 8, $y + 45, 65, 20)
	GUICtrlSetResizing($ProcessCount, (2 + 64 + 768))
	$y = 20
	
	Global $EndProcess = GUICtrlCreateButton("&End Process", $x + 168, $y - 55, 65, 20)
	GUICtrlSetOnEvent($EndProcess, "_EndProcess")
	GUICtrlSetResizing($EndProcess, (4 + 64 + 768))
	GUICtrlSetState($EndProcess, $GUI_DEFBUTTON)
	$y = 20
	
	Global $MemStats = GUICtrlCreateLabel("", $x - 15, $y + 15, 87, 20, $SS_RIGHT)
	GUICtrlSetResizing($MemStats, (4 + 64 + 768))
	
	Global $ListViewItems[1]
	$ListViewItems[0] = 0
	
	Global $ListViewContext = GUICtrlCreateContextMenu($ListView)
	Global $ListViewContextEndProcess = GUICtrlCreateMenuItem("&End Process", $ListViewContext)
	GUICtrlSetOnEvent($ListViewContextEndProcess, "_EndProcess")
	
	Global $WinState = WinGetState("Process Manager")
	Global $TrayMinimize
	Global $TrayRestore
	Select
		Case Not BitAND($WinState, 16)
			$TrayMinimize = TrayCreateItem("&Minimize")
			TrayItemSetOnEvent($TrayMinimize, "_Minimize")
			TrayItemSetState($TrayMinimize, $TRAY_DEFAULT)
		Case BitAND($WinState, 16) 
			$TrayRestore = TrayCreateItem("&Restore")
			TrayItemSetOnEvent($TrayRestore, "_Restore")
			TrayItemSetState($TrayRestore, $TRAY_DEFAULT)
	EndSelect
		
	Global $TrayClose = TrayCreateItem("&Close")
	TrayItemSetOnEvent($TrayClose, "_Close")
	
	Global $TraySeparator = TrayCreateItem("")
	
	Global $TrayAlwaysOnTop = TrayCreateItem("&Always on Top")
	TrayItemSetOnEvent($TrayAlwaysOnTop, "_AlwaysOnTop")
	
	Global $WinPID = @AutoItPID

EndFunc

Func _ReadPrefs()
		
	Global $RegOptions
	Global $Key = "HKEY_CURRENT_USER\SOFTWARE\AutoIt Process Manager"
	Global $Ini = @ScriptDir & "\ProcessManager.ini"
	
	$KeyExists = RegRead($Key, "xPos")
	If @error Then 
		$KeyExists = 0
	Else 
		$KeyExists = 1
	EndIf
	$IniExists = FileExists($Ini)
	
	If $KeyExists = 0 And $IniExists = 0 Then
		$RegOptions = MsgBox((262144 + 4), "Store Settings in Registry?", "Yes: Store settings in registry." & @CR & "No: Store settings in a .ini file.")
		Select
			Case $RegOptions = 6
				RegWrite($Key, "xPos", "REG_SZ", ((@DesktopWidth / 2) - 125))
				RegWrite($Key, "yPos", "REG_SZ", ((@DesktopHeight / 2 ) - 250))
				RegWrite($Key, "Width", "REG_SZ", "250")
				RegWrite($Key, "Height", "REG_SZ", "500")
				RegWrite($Key, "OnTopFlag", "REG_SZ", "0")
				$KeyExists = 1
			Case $RegOptions = 7
				IniWrite($Ini, "Window", "xPos", ((@DesktopWidth / 2) - 125))
				IniWrite($Ini, "Window", "yPos", ((@DesktopHeight / 2 ) - 250))
				IniWrite($Ini, "Window", "Width", "250")
				IniWrite($Ini, "Window", "Height", "500")
				IniWrite($Ini, "Window", "OnTopFlag", "0")
				$IniExists = 1
		EndSelect
	EndIf
		
	Select
		Case $KeyExists = 1
			$RegOptions = 1
			$xPos = RegRead($Key, "xPos")
			$yPos = RegRead($Key, "yPos")
			$Width = RegRead($Key, "Width")
			$Height = RegRead($Key, "Height")
			Global $OnTopFlag = RegRead($Key, "OnTopFlag")
		Case $IniExists = 1
			$RegOptions = 0
			$WinSettings = IniReadSection($Ini, "Window")
			For $i = 1 To $WinSettings[0][0]
				Assign($WinSettings[$i][0], $WinSettings[$i][1])
			Next
			Global $OnTopFlag = $OnTopFlag
	EndSelect
		
	WinMove("Process Manager", "", $xPos, $yPos, $Width, $Height)
	
	_AlwaysOnTop()

EndFunc

Func _ListUpdate(ByRef $avArray)
	If $ListViewItems[0] > 0 Then
		For $i = 1 To $ListViewItems[0]
			GUICtrlDelete($ListViewItems[$i])
		Next
		$ListViewItems = 0
		Dim $ListViewItems[1]
	EndIf
	$ListViewItems[0] = $avArray[0][0]
	ReDim $ListViewItems[($ListViewItems[0] + 1)]
	For $i = 1 To $ListViewItems[0]
		$String = $avArray[$i][0] & "|" & $avArray[$i][1]
		$ListViewItems[$i] = GUICtrlCreateListViewItem($avArray[$i][0] & "|" & $avArray[$i][1], $ListView)
	Next
	GUICtrlSetData($ProcessCount, $ListViewItems[0] & " Processes")
	If IsDeclared("Selection") And $Selection Then
		$SelectionIndex = ControlListView("Process Manager", "Processes", $ListView, "FindItem", $Selection, 1)
		GUICtrlSetState($ListView, $GUI_FOCUS)
		ControlListView("Process Manager", "Processes", $ListView, "Select", $SelectionIndex)
	EndIf
	_ReduceMemory($WinPID)
EndFunc

Func _Sort()
	GUICtrlSetState($ListView, $GUI_FOCUS)
	Select
		Case $SortFlag = 0
			$SortFlag = 1
		Case $SortFlag = 1
			$SortFlag = 0
	EndSelect
	$List = _CurrentList()
	_ArraySort($List, $SortFlag, 1, 0, UBound($List, 2), GUICtrlGetState($ListView))
;~ 	_ArrayReverse($List, 1, 0, 2)
	_ListUpdate($List)
EndFunc

Func _EndProcess()
	GUICtrlSetState($ListView, $GUI_FOCUS)
	If $Selection Then ProcessClose($Selection)
	_RefreshSystemTray()
EndFunc

Func _Minimize()
	GUISetState(@SW_MINIMIZE, $Window)
	GUISetState(@SW_HIDE, $Window)
	Global $TrayRestore = TrayCreateItem("&Restore", -1, 0)
	TrayItemSetOnEvent($TrayRestore, "_Restore")
	TrayItemSetState($TrayRestore, $TRAY_DEFAULT)
	TrayItemDelete($TrayMinimize)
EndFunc

Func _Close()
	If BitAND($WinState, 16) Then
		GUISetState(@SW_SHOW, $Window)
		GUISetState(@SW_RESTORE, $Window)
	EndIf
	$WinPos = WinGetPos("Process Manager")
		Select
		Case $RegOptions = 0
			IniWrite($Ini, "Window", "xPos", $WinPos[0])
			IniWrite($Ini, "Window", "yPos", $WinPos[1])
			IniWrite($Ini, "Window", "Width", $WinPos[2])
			IniWrite($Ini, "Window", "Height", $WinPos[3])
			IniWrite($Ini, "Window", "OnTopFlag", Abs($OnTopFlag - 1))
		Case $RegOptions = 1
			RegWrite($Key, "xPos", "REG_SZ", $WinPos[0])
			RegWrite($Key, "yPos", "REG_SZ", $WinPos[1])
			RegWrite($Key, "Width", "REG_SZ", $WinPos[2])
			RegWrite($Key, "Height", "REG_SZ", $WinPos[3])
			RegWrite($Key, "OnTopFlag", "REG_SZ", Abs($OnTopFlag - 1))
	EndSelect
	GUIDelete($Window)
	Exit
EndFunc

Func _Restore()
	GUISetState(@SW_SHOW, $Window)
	GUISetState(@SW_RESTORE, $Window)
	Global $TrayMinimize = TrayCreateItem("&Minimize", -1, 0)
	TrayItemSetOnEvent($TrayMinimize, "_Minimize")
	TrayItemSetState($TrayMinimize, $TRAY_DEFAULT)
	TrayItemDelete($TrayRestore)
	$List = _CurrentList()
	_ListUpdate($List)
EndFunc

Func _AlwaysOnTop()
	WinSetOnTop("Process Manager", "", $OnTopFlag)
	Select
		Case $OnTopFlag = 0
			$OnTopFlag = 1
			TrayItemSetState($TrayAlwaysOnTop, $TRAY_UNCHECKED)
		Case $OnTopFlag = 1
			$OnTopFlag = 0
			TrayItemSetState($TrayAlwaysOnTop, $TRAY_CHECKED)
	EndSelect
EndFunc		

Func _CurrentList()
	Local $CurrentList[($ListViewItems[0] + 1)][2]
	$CurrentList[0][0] = $ListViewItems[0]
	For $i = 1 To $CurrentList[0][0]
		$Split = StringSplit(GUICtrlRead($ListViewItems[$i]), "|")
		For $x = 1 To $Split[0]
			$CurrentList[$i][($x - 1)] = $Split[$x]
		Next
		$Split = 0
	Next
	Return $CurrentList
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _ArraySort(ByRef $a_Array, $i_Decending = 0, $i_Base = 0, $i_UBound = 0, $i_Dim = 1, $i_SortIndex = 0)
  ; Set to ubound when not specified
    If Not IsArray($a_Array) Then
       SetError(1)
       Return 0
    EndIf
    Local $last = UBound($a_Array) - 1
    If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
    
    If $i_Dim = 1 Then
		__ArrayQSort1($a_Array, $i_Base, $i_UBound)
		If $i_Decending Then _ArrayReverse($a_Array, $i_Base, $i_UBound)
		Else
			__ArrayQSort2($a_Array, $i_Base, $i_UBound, $i_Dim, $i_SortIndex, $i_Decending)
	EndIf
	Return 1	
EndFunc;==>_ArraySort

; Private
Func __ArrayQSort1(ByRef $array, ByRef $left, ByRef $right)
    If $right - $left < 10 Then
      ; InsertSort - fastest on small segments (= 25% total speedup)
        Local $i, $j, $t
        For $i = $left + 1 To $right
            $t = $array[$i]
            $j = $i
			While $j > $left _  
				And (    (IsNumber($array[$j - 1]) = IsNumber($t) And $array[$j - 1] > $t) _
				      Or (IsNumber($array[$j - 1]) <> IsNumber($t) And String($array[$j - 1]) > String($t)))
                $array[$j] = $array[$j - 1]
                $j = $j - 1
            Wend
            $array[$j] = $t
        Next
        Return
    EndIf

  ; QuickSort - fastest on large segments
    Local $pivot = $array[Int(($left + $right)/2)], $t
    Local $L = $left
    Local $R = $right
    Do
		While ((IsNumber($array[$L]) = IsNumber($pivot) And $array[$L] < $pivot) _
				Or (IsNumber($array[$L]) <> IsNumber($pivot) And String($array[$L]) < String($pivot)))
			;While $array[$L] < $pivot
            $L = $L + 1
        Wend
		While ((IsNumber($array[$R]) = IsNumber($pivot) And $array[$R] > $pivot) _
				Or (IsNumber($array[$R]) <> IsNumber($pivot) And String($array[$R]) > String($pivot)))
			;	While $array[$R] > $pivot
            $R = $R - 1
        Wend
      ; Swap
        If $L <= $R Then
            $t = $array[$L]
            $array[$L] = $array[$R]
            $array[$R] = $t
            $L = $L + 1
            $R = $R - 1
        EndIf
    Until $L > $R
        
    __ArrayQSort1($array, $left, $R)
    __ArrayQSort1($array, $L, $right)
EndFunc

; Private
Func __ArrayQSort2(ByRef $array, ByRef $left, ByRef $right, ByRef $dim2, ByRef $sortIdx, ByRef $decend)
    If $left >= $right Then Return
    Local $t, $d2 = $dim2 - 1
    Local $pivot = $array[Int(($left + $right)/2)][$sortIdx]
    Local $L = $left
    Local $R = $right
    Do
        If $decend Then
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] > $pivot) _
				Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) > String($pivot)))
				;While $array[$L][$sortIdx] > $pivot
                $L = $L + 1
            Wend
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] < $pivot) _
				Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) < String($pivot)))
				;While $array[$R][$sortIdx] < $pivot
                $R = $R - 1
            Wend
        Else
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] < $pivot) _
				Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) < String($pivot)))
				;While $array[$L][$sortIdx] < $pivot
                $L = $L + 1
            Wend
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] > $pivot) _
				Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) > String($pivot)))
				;While $array[$R][$sortIdx] > $pivot
                $R = $R - 1
            Wend
        EndIf
        If $L <= $R Then
            For $x = 0 To $d2
                $t = $array[$L][$x]
                $array[$L][$x] = $array[$R][$x]
                $array[$R][$x] = $t
            Next        
            $L = $L + 1
            $R = $R - 1
        EndIf
    Until $L > $R
        
    __ArrayQSort2($array, $left, $R, $dim2, $sortIdx, $decend)
    __ArrayQSort2($array, $L, $right, $dim2, $sortIdx, $decend)
EndFunc

Func _ArrayReverse(ByRef $avArray, $i_Base = 0, $i_UBound = 0, $i_Dim = 0)
    If Not IsArray($avArray) Then
        SetError(1)
        Return 0
    EndIf
    Local $tmp, $j, $last = UBound($avArray) - 1
    If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
	
	If $i_Dim <> 0 Then
		For $i = $i_Base To $i_Base + Int(($i_UBound - $i_Base - 1) / 2)
			For $j = 0 To ($i_Dim - 1)
				$tmp = $avArray[$i][$j]
				$avArray[$i][$j] = $avArray[$i_UBound][$j]
				$avArray[$i_UBound][$j] = $tmp
			Next
			$i_UBound = $i_UBound - 1
		Next
	EndIf
	
	If $i_Dim = 0 Then
		For $i = $i_Base To $i_Base + Int(($i_UBound - $i_Base - 1) / 2)
			$tmp = $avArray[$i]
			$avArray[$i] = $avArray[$i_UBound]
			$avArray[$i_UBound] = $tmp
			$i_UBound = $i_UBound - 1
		Next
	EndIf
	
    Return 1
EndFunc  ;==>_ArrayReverse

Func _ReduceMemory($iPID)
	Local $aHandle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $iPID), $aReturn = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $aHandle[0])
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $aHandle[0])
	Return $aReturn[0]
EndFunc

Func _RefreshSystemTray($nDelay = 1)
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
        If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible","") Then
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
        If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible","") Then
            ControlClick($hWnd, "", $hControl)
        EndIf
    Until 1
    
; Restore Opt settings
    Opt("WinTitleMatchMode", $oldMatchMode)
    Opt("WinSearchChildren", $oldChildMode)
    SetError($error)
EndFunc; _RefreshSystemTray()