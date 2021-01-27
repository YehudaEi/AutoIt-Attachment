#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GuiConstantsEx.au3>
#include <GuiTreeView.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)

$Debug_TV = False ; Check ClassName being passed to functions, set to True and use a handle to another control to see it work

Global $GUI, $hTreeView  ; [ema]
Global Const $WM_ENTERSIZEMOVE		= 0x0231 ; [ema]
Global Const $WM_EXITSIZEMOVE		= 0x0232 ; [ema]

Global Const $WS_EX_COMPOSITED		= 0x2000000 ; [ema]

Global $g_IsResizing = False ; [ema]
Global $g_treeview_x_diff ; [ema]
Global $g_treeview_y_diff ; [ema]

_Main()

Func _Main()

	Local $hItem ; [ema]
	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	$GUI = GUICreate("(UDF Created) TreeView Create", 400, 300, -1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX)) ; [ema]

	$hTreeView = _GUICtrlTreeView_Create($GUI, 2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	
	Local $size_client = WinGetClientSize($GUI) ; [ema]
	Local $size_treeview = ControlGetPos($GUI, "", $hTreeView) ; [ema]
	$g_treeview_x_diff = $size_client[0]-$size_treeview[0]-$size_treeview[2] ; [ema]
	$g_treeview_y_diff = $size_client[1]-$size_treeview[1]-$size_treeview[3] ; [ema]

	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_SIZE, "WM_SIZE") ; [ema] support resizing of treeview control
	GUIRegisterMsg($WM_ENTERSIZEMOVE, "WM_ENTERSIZEMOVE") ; [ema]
	GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_EXITSIZEMOVE") ; [ema]

	_GUICtrlTreeView_BeginUpdate($hTreeView)
	For $x = 1 To Random(2, 10, 1)
		$hItem = _GUICtrlTreeView_Add($hTreeView, 0, StringFormat("[%02d] New Item", $x))
		For $y = 1 To Random(2, 10, 1)
			_GUICtrlTreeView_AddChild($hTreeView, $hItem, StringFormat("[%02d] New Child", $y))
		Next
	Next
	_GUICtrlTreeView_EndUpdate($hTreeView)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndTreeview
	$hWndTreeview = $hTreeView
	If Not IsHWnd($hTreeView) Then $hWndTreeview = GUICtrlGetHandle($hTreeView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndTreeview
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control
					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RCLICK ; The user has clicked the right mouse button within the control
					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RDBLCLK ; The user has clicked the right mouse button within the control
					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_KILLFOCUS ; control has lost the input focus
					_DebugPrint("$NM_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; No return value
				Case $NM_RETURN ; control has the input focus and that the user has pressed the key
					_DebugPrint("$NM_RETURN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
;~ 				Case $NM_SETCURSOR ; control is setting the cursor in response to a WM_SETCURSOR message
;~ 					Local $tinfo = DllStructCreate($tagNMMOUSE, $ilParam)
;~ 					$hWndFrom = HWnd(DllStructGetData($tinfo, "hWndFrom"))
;~ 					$iIDFrom = DllStructGetData($tinfo, "IDFrom")
;~ 					$iCode = DllStructGetData($tinfo, "Code")
;~ 					_DebugPrint("$NM_SETCURSOR" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->ItemSpec:" & @TAB & DllStructGetData($tinfo, "ItemSpec") & @LF & _
;~ 							"-->ItemData:" & @TAB & DllStructGetData($tinfo, "ItemData") & @LF & _
;~ 							"-->X:" & @TAB & DllStructGetData($tinfo, "X") & @LF & _
;~ 							"-->Y:" & @TAB & DllStructGetData($tinfo, "Y") & @LF & _
;~ 							"-->HitInfo:" & @TAB & DllStructGetData($tinfo, "HitInfo"))
;~ 					Return 0 ; to enable the control to set the cursor
;~ 					Return 1 ; nonzero to prevent the control from setting the cursor
				Case $NM_SETFOCUS ; control has received the input focus
					_DebugPrint("$NM_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; No return value
				Case $TVN_BEGINDRAG, $TVN_BEGINDRAGW
					_DebugPrint("$TVN_BEGINDRAG")
				Case $TVN_BEGINLABELEDIT, $TVN_BEGINLABELEDITW
					_DebugPrint("$TVN_BEGINLABELEDIT")
				Case $TVN_BEGINRDRAG, $TVN_BEGINRDRAGW
					_DebugPrint("$TVN_BEGINRDRAG")
				Case $TVN_DELETEITEM, $TVN_DELETEITEMW
					_DebugPrint("$TVN_DELETEITEM")
				Case $TVN_ENDLABELEDIT, $TVN_ENDLABELEDITW
					_DebugPrint("$TVN_ENDLABELEDIT")
				Case $TVN_GETDISPINFO, $TVN_GETDISPINFOW
					_DebugPrint("$TVN_GETDISPINFO")
				Case $TVN_GETINFOTIP, $TVN_GETINFOTIPW
					_DebugPrint("$TVN_GETINFOTIP")
				Case $TVN_ITEMEXPANDED, $TVN_ITEMEXPANDEDW
					_DebugPrint("$TVN_ITEMEXPANDED")
				Case $TVN_ITEMEXPANDING, $TVN_ITEMEXPANDINGW
					_DebugPrint("$TVN_ITEMEXPANDING")
				Case $TVN_KEYDOWN
					_DebugPrint("$TVN_KEYDOWN")
				Case $TVN_SELCHANGED, $TVN_SELCHANGEDW
					_DebugPrint("$TVN_SELCHANGED")
				Case $TVN_SELCHANGING, $TVN_SELCHANGINGW
					_DebugPrint("$TVN_SELCHANGING")
				Case $TVN_SETDISPINFO, $TVN_SETDISPINFOW
					_DebugPrint("$TVN_SETDISPINFO")
				Case $TVN_SINGLEEXPAND
					_DebugPrint("$TVN_SINGLEEXPAND")
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_ENTERSIZEMOVE($hWnd, $Msg, $wParam, $lParam)
; add $WS_EX_COMPOSITED to the extended window style
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $GUIStyle
; called when resizing begins
	IF Not $g_IsResizing Then
		$GUIStyle = GUIGetStyle($GUI)
		GUISetStyle(-1, BitOR($GUIStyle[1], $WS_EX_COMPOSITED), $GUI)
		$g_IsResizing = True
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_ENTERSIZEMOVE

Func WM_EXITSIZEMOVE($hWnd, $Msg, $wParam, $lParam)
; reset the extended window style to previous values
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $GUIStyle
; called when resizing ends
	IF $g_IsResizing Then
		$GUIStyle = GUIGetStyle($GUI)
		GUISetStyle(-1, BitAND($GUIStyle[1], BitNOT($WS_EX_COMPOSITED)), $GUI)
		$g_IsResizing = False
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_EXITSIZEMOVE

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
; when resizing the window, resize the treeview control as well
	#forceref $hWnd, $Msg, $wParam, $lParam
 	Local $size_client = WinGetClientSize($GUI)
	Local $size_treeview = ControlGetPos($GUI, "", $hTreeView)
	Local $new_width_treeview = $size_client[0]-$g_treeview_x_diff-$size_treeview[0]
	Local $new_height_treeview = $size_client[1]-$g_treeview_y_diff-$size_treeview[1]
	_WinAPI_MoveWindow($hTreeView, $size_treeview[0], $size_treeview[1], $new_width_treeview, $new_height_treeview,  True)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint