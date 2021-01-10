#AutoIt3Wrapper_UseAnsi=y

Opt("MustDeclareVars", 1)

#include <Misc.au3>
#include "GuiRichEdit.au3"

Global $h_RichEdit
_Main()

Func _Main()
	Local $msg, $hgui, $button
	Local $mnuOptions, $mnuBKColor, $mnuResetBKColor
	Local $bkcolor, $bkcolor_save = 16777215, $lResult

	$hgui = GUICreate("Rich Edit Example", 500, 550, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	$mnuOptions = GUICtrlCreateMenu("Options")
	$mnuBKColor = GUICtrlCreateMenuItem("Set Back Color of Control", $mnuOptions)
	$mnuResetBKColor = GUICtrlCreateMenuItem("Reset Back Color of Control", $mnuOptions)

	$h_RichEdit = _GUICtrlRichEditCreate ($hgui, 10, 10, 480, 420, BitOR($ES_WANTRETURN, $WS_HSCROLL, $ES_SUNKEN, $ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	GUICtrlSetResizing($h_RichEdit, $GUI_DOCKAUTO)
	$lResult = _SendMessage($h_RichEdit, $EM_SETEVENTMASK, 0, BitOR($ENM_REQUESTRESIZE, $ENM_LINK, $ENM_DROPFILES, $ENM_KEYEVENTS, $ENM_MOUSEEVENTS))
	_DebugPrint ("$h_RichEdit handle: " & $h_RichEdit)
	$lResult = _SendMessage($h_RichEdit, $EM_AUTOURLDETECT, True)
	_GUICtrlRichEditInsertText ($h_RichEdit, 'Testing' & @CRLF)
	$button = GUICtrlCreateButton("Exit", 100, 460, 100, 25)
	GUISetState(@SW_SHOW)
	Sleep(1000)
	_GUICtrlRichEditSetText ($h_RichEdit, "This is a test" & @CRLF)
	Sleep(1000)
	_GUICtrlRichEditAppendText ($h_RichEdit, 'http://www.autoitscript.com/forum' & @CRLF)
	Sleep(1000)
	_GUICtrlRichEditSetSel ($h_RichEdit, 0, 15)
	Sleep(1000)
	_GUICtrlRichEditInsertText ($h_RichEdit, "Welcome to AutoIt" & @CRLF)
	Sleep(1000)
	_GUICtrlRichEditAppendText ($h_RichEdit, 'mailto:yourmail@your.com' & @CRLF)
	_GUICtrlRichEditSetSel($h_RichEdit, 0, 17)
	Local $a_Result = _GUICtrlRichEditGetSel($h_RichEdit)
	_DebugPrint("Start of Sel: " & $a_Result[1] & @LF & "-->End of Sel: " & $a_Result[2] & @LF & "-->Text Selected: " & _GUICtrlRichEditGetText($h_RichEdit, $a_Result[1], $a_Result[2]))
	;Register WM_NOTIFY  events
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY_Events")
	While 1
		$msg = GUIGetMsg()

		Select

			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button ; controls commands don't work here if using wm_command
				;----------------------------------------------------------------------------------------------
				If $DebugIt Then _DebugPrint ("Exit From Main")
				;----------------------------------------------------------------------------------------------
				Exit
			Case $msg = $GUI_EVENT_RESIZED
				_SendMessage($h_RichEdit, $EM_REQUESTRESIZE)
			Case $msg = $mnuBKColor
				$bkcolor = _ChooseColor(0, 16777215)
				If Not @error Then
					$bkcolor_save = _SendMessage($h_RichEdit, $EM_SETBKGNDCOLOR, 0, $bkcolor)
				EndIf
			Case $msg = $mnuResetBKColor
				_SendMessage($h_RichEdit, $EM_SETBKGNDCOLOR, 1, $bkcolor_save)
		EndSelect
	WEnd
EndFunc   ;==>_Main

Func WM_NOTIFY_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID
	Local $identifier, $nmhdr, $hwndFrom, $idFrom, $code
	;----------------------------------------------------------------------------------------------
	$nmhdr = DllStructCreate($NMHDR_fmt, $lParam)
	$hwndFrom = DllStructGetData($nmhdr, 1)
	$idFrom = DllStructGetData($nmhdr, 2)
	$code = DllStructGetData($nmhdr, 3)
;~             ConsoleWrite("-->hwndFrom: " & $hwndFrom & @LF)
;~             ConsoleWrite("-->idFrom: " & $idFrom & @LF)
;~             ConsoleWrite("-->code: " & $code & @LF)
	Switch $hwndFrom
		Case $h_RichEdit
			Switch $code
				Case $EN_ALIGNLTR
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_ALIGNLTR")
					;----------------------------------------------------------------------------------------------
				Case $EN_ALIGNRTL
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_ALIGNRTL")
					;----------------------------------------------------------------------------------------------
				Case $EN_CORRECTTEXT
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_CORRECTTEXT")
					;----------------------------------------------------------------------------------------------
				Case $EN_DRAGDROPDONE
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_DRAGDROPDONE")
					;----------------------------------------------------------------------------------------------
				Case $EN_DROPFILES
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_DROPFILES")
					;----------------------------------------------------------------------------------------------
				Case $EN_IMECHANGE
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_IMECHANGE")
					;----------------------------------------------------------------------------------------------
				Case $EN_LINK
					Local $EN_LINK_struct = DllStructCreate($ENLINK_fmt, $lParam)
					$hwndFrom = DllStructGetData($EN_LINK_struct, 1)
					$idFrom = DllStructGetData($EN_LINK_struct, 2)
					$code = DllStructGetData($EN_LINK_struct, 3)
					Local $en_link_msg = DllStructGetData($EN_LINK_struct, 4)
					Local $en_link_wParam = DllStructGetData($EN_LINK_struct, 5)
					Local $en_link_lParam = DllStructGetData($EN_LINK_struct, 6)
					Local $cpMin = DllStructGetData($EN_LINK_struct, 7)
					Local $cpMax = DllStructGetData($EN_LINK_struct, 8)
					If BitAND($en_link_msg, $WM_LBUTTONDOWN) = $WM_LBUTTONDOWN Then
						Local $link_clicked = _GUICtrlRichEditGetText ($hwndFrom, $cpMin, $cpMax) ; doesn't seem to work on zoomed text
						;----------------------------------------------------------------------------------------------
						If $DebugIt Then
							_DebugPrint ("$EN_LINK" & @LF & _
									"hwndFrom       : " & $hwndFrom & @LF & _
									"idFrom         : " & $idFrom & @LF & _
									"code           : " & $code & @LF & _
									"$en_link_msg   : " & $en_link_msg & @LF & _
									"$en_link_wParam: " & $en_link_wParam & @LF & _
									"$en_link_lParam: " & $en_link_lParam & @LF & _
									"$cpMin         : " & $cpMin & @LF & _
									"$cpMax         : " & $cpMax & @LF & _
									"$link_clicked  : " & $link_clicked)
						EndIf
						If $link_clicked <> "" Then Run(@ComSpec & ' /c START "" "' & $link_clicked & '"', @SystemDir, @SW_HIDE)

					EndIf
					;----------------------------------------------------------------------------------------------
				Case $EN_MSGFILTER
					Local $EN_MSGFILTER_struct = DllStructCreate($msgfilter_fmt, $lParam)
					$hwndFrom = DllStructGetData($EN_MSGFILTER_struct, 1)
					$idFrom = DllStructGetData($EN_MSGFILTER_struct, 2)
					$code = DllStructGetData($EN_MSGFILTER_struct, 3)
					Local $en_msgfilter_msg = DllStructGetData($EN_MSGFILTER_struct, 4)
					Local $en_msgfilter_wParam = DllStructGetData($EN_MSGFILTER_struct, 5)
					Local $en_msgfilter_lParam = DllStructGetData($EN_MSGFILTER_struct, 6)
					;----------------------------------------------------------------------------------------------
;~ 					If $DebugIt Then
;~ 						_DebugPrint ("$EN_MSGFILTER" & @LF & _
;~ 								"hwndFrom            : " & $hwndFrom & @LF & _
;~ 								"idFrom              : " & $idFrom & @LF & _
;~ 								"code                : " & $code & @LF & _
;~ 								"$en_msgfilter_msg   : " & $en_msgfilter_msg & @LF & _
;~ 								"$en_msgfilter_wParam: " & $en_msgfilter_wParam & @LF & _
;~ 								"$en_msgfilter_lParam: " & $en_msgfilter_lParam)
;~ 					EndIf
					;----------------------------------------------------------------------------------------------
				Case $EN_OBJECTPOSITIONS
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_OBJECTPOSITIONS")
					;----------------------------------------------------------------------------------------------
				Case $EN_OLEOPFAILED
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_OLEOPFAILED")
					;----------------------------------------------------------------------------------------------
				Case $EN_PROTECTED
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_PROTECTED")
					;----------------------------------------------------------------------------------------------
				Case $EN_REQUESTRESIZE
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_REQUESTRESIZE")
					;----------------------------------------------------------------------------------------------
				Case $EN_SAVECLIPBOARD
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_SAVECLIPBOARD")
					;----------------------------------------------------------------------------------------------
				Case $EN_SELCHANGE
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_SELCHANGE")
					;----------------------------------------------------------------------------------------------
				Case $EN_STOPNOUNDO
					;----------------------------------------------------------------------------------------------
					If $DebugIt Then _DebugPrint ("$EN_STOPNOUNDO")
					;----------------------------------------------------------------------------------------------
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG

EndFunc   ;==>WM_NOTIFY_Events