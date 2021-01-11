#include <array.au3>
#include <GUIConstants.au3>
#include <GuiTreeView.au3>


Global $aWindows[1], $aChildWindows[1]

;WinControlList("callback")
WinControlListGUI("AutoIt Help",1,1)


Func WinControlList($hWndParent)
	$RARY=WinControlListGUI($hWndParent, 0,0)
	$s=""
	For $a in $RARY
		For $b in $a
			$s &= $b & @TAB
		Next
		$s &= @CRLF
	Next
	ConsoleWrite($s)
EndFunc

Func WinControlListGUI($hWndParent, $stackem=1, $ShowGUI=1)
	$hDll = DllOpen("au3CallBack.dll")
	; Get Function Pointer
	$hProc = DllCall($hDll,"int","MyCallBackPtr")
	; Create Reciever Window
	$hWndMain = GUICreate("Windows Enumerator",622, 448, 192, 125,$WS_SIZEBOX+$WS_SYSMENU)
	$TreeView = GUICtrlCreateTreeView(0, 0, 620, 428)
	GUICtrlSetResizing (-1,$GUI_DOCKAUTO)
	GUICtrlSetFont(-1,9,Default,Default,"Courier New")
	; Register 'Callback' Functions
	GUIRegisterMsg(0x400+1,"EnumWindowsProc") ; WM_USER+1
	GUIRegisterMsg(0x400+2,"EnumChildProc") ; WM_USER+2
	; Tell Dll where to send messages
	DllCall($hDll,"hwnd","SetHwnd","hwnd",$hWndMain)
	
	$TreeViewParent = GUICtrlCreateTreeViewItem($hWndParent & ' -> "' & WinGetTitle($hWndParent) & '" ' & GetClassName($hWndParent) & ".", $TreeView)
	
	$RARY=0 ; turns into an array
	WinControlListRecursiveTL($hDll, $hProc, $TreeView, WinGetHandle($hWndParent), $TreeViewParent, $RARY, $stackem) ; Enumerate Child Windows	
	
	; Display
	If $ShowGUI=1 then
		GUISetState()
		While GuiGetMsg() <> $GUI_EVENT_CLOSE
			Sleep(10)
		WEnd
	EndIf	
	Return $RARY
EndFunc


Func WinControlListRecursiveTL($hDll, $hProc, $TreeView, $hWndParent, $TreeViewParent, ByRef $RARY, $stackem=1)
	DllCall($hDll,"int","SetWindowsMessage","int",0x400+2) ; WM_USER + 2
	ReDim $aChildWindows[1]
	DllCall("user32.dll","int","EnumChildWindows","hwnd",WinGetHandle($hWndParent),"int",$hProc[0],"int",1)
	For $hWndChild In $aChildWindows
		If Not IsHWnd($hWndChild) Then ContinueLoop
		If $stackem=1 then 
			If ControlGetParent($hWndChild) <> $hWndParent Then ContinueLoop
		EndIf
			
		$ID=ControlGetID($hWndChild)
		$POS=ControlGetPos($hWndParent,"",$hWndChild)
		If IsArray($POS)=0 then $POS = _ArrayCreate(0,0,0,0)
		$ClassNameNN=ControlGetClassNameNN($hWndChild, $hWndParent)
		$NP=_GUICtrlTreeViewInsertItem($TreeView,$hWndChild & ' -> "' & WinGetTitle($hWndChild) & '" ' & _
			$ClassNameNN & " ID:" & $ID & " @:" & _ArrayToString($POS,","), $TreeViewParent)
			
		$ACtl=_ArrayCreate($hWndChild, $hWndParent, ControlGetParent($hWndChild), $ID, _ArrayToString($POS,","), $ClassNameNN, GetClassName($hWndChild)) 
		If $RARY=0 Then
			$RARY=_ArrayCreate($ACtl)
		Else
			_ArrayAdd($RARY,$ACtl)
		EndIf
		
		If $stackem=1 then WinControlListRecursiveTL($hDll, $hProc, $TreeView, $hWndChild, $RARY, $NP)
	Next
	Return $RARY
EndFunc

#region "Callback Functions"
;~ BOOL CALLBACK EnumWindowsProc(
;~ 	HWND hwnd,	// handle to parent window
;~ 	LPARAM lParam 	// application-defined value
;~ );
Func EnumWindowsProc($hWnd, $iMsg, $WParam, $LParam)
	Local $MyMessage, $hWndFound
	$MyMessage = DllStructCreate ("int;" _ ; HWND hwnd,	// handle to parent window
								& "int" _ ; LPARAM lParam 	// application-defined value
								, $LParam)
	$hWndFound = HWnd(DllStructGetData($MyMessage,1))
	_ArrayAdd($aWindows, $hWndFound)
	Return True ; To get next window
EndFunc

;~ BOOL CALLBACK EnumChildProc(
;~ 	HWND hwnd,	// handle to child window
;~ 	LPARAM lParam 	// application-defined value
;~ );
Func EnumChildProc($hWnd, $iMsg, $WParam, $LParam)
	Local $MyMessage, $hWndChildFound;Found
	$MyMessage = DllStructCreate ("int;" _ ; HWND hwnd,	// handle to child window
								& "int" _ ; LPARAM lParam 	// application-defined value
								, $LParam)
	$hWndChildFound = HWnd(DllStructGetData($MyMessage,1))
	_ArrayAdd($aChildWindows, $hWndChildFound)
	Return True ; To get next window
EndFunc
#endregion
#region "Control Info"
Func ControlGetParent($hWndChild)
	$GP=DllCall('user32.dll', 'int', 'GetParent', 'int', $hWndChild)
	Return $GP[0]
EndFunc

Func ControlGetID($hCtrlWnd)
	$hCtrlWnd=ControlGetHandle("","",$hCtrlWnd)
	$x = DllCall('User32.dll', 'int', 'GetDlgCtrlID', 'hwnd', $hCtrlWnd)
	If @error or $x[0]=0 then Return SetError(-1,0,"-1")
	Return $x[0]
EndFunc

; Get the classname of the stated control or window
Func GetClassName($hWndControl)
	$name=DllCall('user32.dll', 'int', 'GetClassName', 'hwnd', $hWndControl, 'str', "", 'int', 256)
	Return $name[2]
EndFunc

Func ControlGetClassNameNN($hCtrlWnd, $hWinWnd="")
	$hCtrlWnd=ControlGetHandle($hWinWnd,"",$hCtrlWnd)
	$name = GetClassName($hCtrlWnd)
	$lst=StringSplit(WinGetClassList($hWinWnd,""), @crlf)
	For $C in StringSplit(WinGetClassList($hWinWnd,""), @crlf)
		If $C = $name then
			For $x = 1 to UBound($lst)
				$ctl = $C & $x
				If ControlGetHandle($hWinWnd,"",$ctl) = $hCtrlWnd then Return $ctl
			Next
		EndIf
	Next
	Return "?"
EndFunc
#endregion

Func AllList()
	;Dim $aWindows[1],$aChildWindows[1]

	; Load Dll
	$hDll = DllOpen("au3CallBack.dll")
	; Get Function Pointer
	$hProc = DllCall($hDll,"int","MyCallBackPtr")
	; Create Reciver Window
	$hWndMain = GUICreate("Windows Enumerator",622, 448, 192, 125,$WS_SIZEBOX+$WS_SYSMENU)
	$TreeView = GUICtrlCreateTreeView(0, 0, 620, 428)
	GUICtrlSetResizing (-1,$GUI_DOCKAUTO)
	GUICtrlSetFont(-1,9,Default,Default,"Courier New")
	GUISetState()
	; Register 'Callback' Functions
	GUIRegisterMsg(0x400+1,"EnumWindowsProc") ; WM_USER+1
	GUIRegisterMsg(0x400+2,"EnumChildProc") ; WM_USER+2
	; Tell Dll where to send messages
	DllCall($hDll,"hwnd","SetHwnd","hwnd",$hWndMain)
	; Enumerate Windows
	DllCall($hDll,"int","SetWindowsMessage","int",0x400 + 1) ; WM_USER + 1
	DllCall("user32.dll","int","EnumWindows","int",$hProc[0],"int",1)

	$iWindows = UBound($aWindows)
	$iWinCount = 0
	$aProc = ProcessList()
	for $i = 1 to $aProc[0][0]
		$iPid = $aProc[$i][1]
		$sModule = $aProc[$i][0]
		$TreeViewPid = GUICtrlCreateTreeViewItem($iPid & ' -> "' & $sModule & '"',$TreeView)
		For $hWndParent In $aWindows
			If Not IsHWnd($hWndParent) Or WinGetProcess($hWndParent) <> $iPid Then ContinueLoop
			$iWinCount += 1
			$TreeViewParent = GUICtrlCreateTreeViewItem($hWndParent & ' -> "' & WinGetTitle($hWndParent) & '" ' & GetClassName($hWndParent), $TreeViewPid)
			WinSetTitle($hWndMain,"","Windows Enumerator - " & Round($iWinCount/$iWindows*100) & "%")
			; Enumerate ChildWindows
			DllCall($hDll,"int","SetWindowsMessage","int",0x400 + 2) ; WM_USER + 2
			ReDim $aChildWindows[1]
			DllCall("user32.dll","int","EnumChildWindows","hwnd",$hWndParent,"int",$hProc[0],"int",1)
			For $hWndChild In $aChildWindows
				If Not IsHWnd($hWndChild) Then ContinueLoop
				$name=DllCall('user32.dll', 'int', 'GetClassName', 'hwnd', $hWndChild, 'str', "", 'int', 256)
				$name = $name[2]
				_GUICtrlTreeViewInsertItem($TreeView,$hWndChild & ' -> "' & WinGetTitle($hWndChild) & '" ' & $name, $TreeViewParent)
			Next
			If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
		Next
	Next
	WinSetTitle($hWndMain,"","Windows Enumerator - Done")
	While GuiGetMsg() <> $GUI_EVENT_CLOSE
		Sleep(10)
	WEnd
	Exit
EndFunc

Func GetDesktopWindow()
	$x=DllCall('user32.dll','int','GetDesktopWindow')
	Return $x[0]
EndFunc

Func NULL()
	Return ControlGetParent(GetDesktopWindow())
EndFunc
