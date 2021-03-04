; Includes first! Must must must!
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <Misc.au3>
#include <SendMessage.au3>

; Switch on the 'onEvent' notifications

Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 2)

; Generate the GUI! Ahoy there.
Global $gw = 16
Global $gh = 16
Global $Startx, $Starty, $Endx, $Endy, $aM_Mask, $aMask, $nc
Global $MainForm, $list_source, $list_target, $drag_gui, $hSplash

$MainForm = GUICreate(" TEST! ", 517, 178)

; Source list box
$list_source = _GUICtrlListView_Create($MainForm, "Title|Details", 13, 16, 240, 136, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS, $LVS_SORTASCENDING))
; Target list box
$list_target = _GUICtrlListView_Create($MainForm, "Title|Details", 261, 16, 240, 136, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS, $LVS_SORTASCENDING))
; Populate box with some test stuff

_GUICtrlListView_AddItem($list_source, _makeJunkName())
_GUICtrlListView_AddItem($list_source, _makeJunkName())
_GUICtrlListView_AddItem($list_source, _makeJunkName())
_GUICtrlListView_AddItem($list_source, _makeJunkName())
_GUICtrlListView_AddItem($list_source, _makeJunkName())
_GUICtrlListView_AddSubItem($list_source, 0, _makeJunkName(), 1)
_GUICtrlListView_AddSubItem($list_source, 1, _makeJunkName(), 1)
_GUICtrlListView_AddSubItem($list_source, 2, _makeJunkName(), 1)
_GUICtrlListView_AddSubItem($list_source, 3, _makeJunkName(), 1)
_GUICtrlListView_AddSubItem($list_source, 4, _makeJunkName(), 1)
_GUICtrlListView_AddSubItem($list_source, 5, _makeJunkName(), 1)

; Handle GUI events
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetOnEvent($GUI_EVENT_CLOSE, "_formEvents")

$drag_gui = GUICreate("Drag", $gw, $gh, 0, 0, $WS_POPUP);, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $MainForm)
$cursor_icon = GUICtrlCreateIcon("Shell32.dll", -147, 0, 0, 16, 16)

GUISetState(@SW_SHOW, $MainForm)
; Main program loop
While 1
	; Don't really do much in here at all...
	Sleep(10)
WEnd

; Function to handle other form events
Func chase()
$mp = MouseGetPos()
_WinAPI_UpdateWindow($MainForm)
WinMove($drag_gui, "", $mp[0] + 1, $mp[1] + 0)
;ToolTip($moving_txt, $mp[0] + 18, $mp[1])
WinMove($hSplash, "", $mp[0] + 18, $mp[1])
EndFunc   ;==>chase

Func _formEvents()
   Exit
EndFunc   ;==>_formEvents

; Create a junk name for testing
Func _makeJunkName()
	Local $labelout = ''
	For $i = 1 To 10
		$labelout &= Chr(Random(65, 90, 1))
	Next
	Return $labelout
EndFunc   ;==>_makeJunkName

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo, $item_txt

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	$hWndListView = $hWndFrom
	If Not IsHWnd($hWndFrom) Then $hWndListView = GUICtrlGetHandle($hWndFrom)
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_BEGINDRAG ; A drag-and-drop operation involving the left mouse button is being initiated
                $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
				If $hWndFrom = $list_source Then
					$direction = 1
				ElseIf $hWndFrom = $list_target Then
					; Or are we moving from destination to source
					$direction = 2
				Else
					MsgBox(0, "", "bad")
				EndIf
				$aidx = _GUICtrlListView_GetSelectedIndices($hWndFrom, True)
				$iselecteditems = $aidx[0]
				;retrieve all item text, not just first item
				For $i = 1 To $aidx[0]
					$item_txt &= _GUICtrlListView_GetItemText($hWndFrom, $aidx[$i]) & @CRLF
				Next
				_WinAPI_ShowCursor(False)
				GUISetState(@SW_SHOW, $drag_gui)
				;$atemp = _GUICtrlListBox_GetItemRect($cinfo[4], Int($idx))

				$atemp = _GUICtrlListView_ApproximateViewRect($hWndFrom, $iselecteditems)
				$hSplash = SplashTextOn("title", $item_txt, $atemp[0], $atemp[1] - 20, -1, -1, 1)
				;MsgBox(0, "", $item_txt)
				While _IsPressed(1)
					chase()
				WEnd
				GUISetState(@SW_HIDE, $drag_gui)
				_WinAPI_ShowCursor(True)
				SplashOff()
				; Get new position
				Local $newcinfo = GUIGetCursorInfo(WinGetHandle($MainForm))
				; If we were moving from source to destination and we ARE in the destination box
				If $direction = 1 And $newcinfo[4] = GUICtrlGetHandle($list_target) Then
					ConsoleWrite("Moved " & $iselecteditems & " items from source to destination" & @CRLF)
					_GUICtrlListView_CopyItems($list_source, $list_target, 1)
				EndIf
				; If we are moving from destination to source and we ARE in source box
				If $direction = 2 And $newcinfo[4] = GUICtrlGetHandle($list_source) Then
					ConsoleWrite("Moved " & $iselecteditems & " items from destination to source" & @CRLF)
					_GUICtrlListView_CopyItems($list_target, $list_source, 1)
				EndIf


                 _DebugPrint("$LVN_BEGINDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
                         "-->IDFrom:" & @TAB & $iIDFrom & @LF & _
                         "-->Code:" & @TAB & $iCode & @LF & _
                         "-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
                         "-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
                         "-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
                         "-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
                         "-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
                         "-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
                         "-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
                         "-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
						;_dragHandler($hWndFrom)
                 ; No return value
             Case $LVN_BEGINRDRAG ; A drag-and-drop operation involving the right mouse button is being initiated
                 $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
                 _DebugPrint("$LVN_BEGINRDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
                         "-->IDFrom:" & @TAB & $iIDFrom & @LF & _
                         "-->Code:" & @TAB & $iCode & @LF & _
                         "-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
                         "-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
                         "-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
                         "-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
                         "-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
                         "-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
                         "-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
                         "-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
                 ; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint

