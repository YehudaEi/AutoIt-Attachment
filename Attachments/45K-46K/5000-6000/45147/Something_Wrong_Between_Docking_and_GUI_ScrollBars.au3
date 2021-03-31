;; Something_Wrong_Between_Docking_and_GUI_ScrollBars.au3
;; Notes:
;;   1.  This script is based upon the example in the AutoIt help
;;         file for UDF function _GUIScrollBars_Init.  Similar effects
;;         can be observed using that example, although the child GUIs
;;         seem to behave correctly.
;;
;;   2.  Melba23's UDF, "Scrollbars Made Easy" also exhibits issue #1, but not #2.
;;         http://www.autoitscript.com/forum/topic/113723-scrollbars-made-easy-new-version-9-aug-14/

#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	Local $hGUIMsg, $hGUI

	Local $iMaxHScroll = 425
	Local $iMaxVScroll = 325

	Local $iGUIHeight = 300

	$hGUI = GUICreate("2 ScrollBar Issues", 400, $iGUIHeight, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	GUISetBkColor(0x88AABB)

	$b0 = GUICtrlCreateButton("0,0 x 100,40", 0, 0, 100, 40)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	$b1 = GUICtrlCreateButton("Show Issue 1", 120, 0, 100, 40)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	$b2 = GUICtrlCreateButton("Show Issue 2", 230, 0, 100, 40)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	Local $sIssue1 = _
			" 1.  Start the script." & @LF & _
			" 2.  Note the location of the leftmost button is 0,0." & @LF & _
			" 3.  Drag the horizontal scroll bar a little to the right." & @LF & _
			"      The left button scrolls off the left side as it should." & @LF & _
			"      So far, all is well." & @LF & _
			" 4.  Drag the bottom of the GUI up or down, noting that the button" & @LF & _
			"      moves completely into view (it should NOT do that!)." & @LF & _
			"      This note moves too, just like the button." & @LF & _
			" 5.  Drag the horizontal scroll bar all the way to the left." & @LF & _
			" 6.  Note the location of the leftmost button and this note. " & @LF & _
			"      They're NOT where they should be.  The leftmost button" & @LF & _
			"      should be at 0,0.  Click that button to get its position." & @LF & _
			" 7.  Drag the bottom of the GUI up or down, " & @LF & _
			"      and the button repositions correctly." & @LF & _
			" 8.  The same thing happens with the vertical scroll bar," & @LF & _
			"      and/or combinations of dragging the GUI borders." & @LF & _
			" 9.  This is NOT an issue if the window cannot be resized." & @LF & _
			"10.  This same issue occurs in Melba23's 'Scrollbars Made Easy' UDF."

	Local $sIssue2 = _
			" 1.  The height of the vertical scroll bar thumb, and its maximum " & @LF & _
			"      range are incorrect.  Since the height of the GUI is " & $iGUIHeight & ", and" & @LF & _
			"      function _GUIScrollBars_Init specifies the maximum vertical " & @LF & _
			"      value as " & $iMaxVScroll & ", the height of the thumb should be greater" & @LF & _
			"      then it is, and the movement should be very little, much like" & @LF & _
			"      the horizontal scroll bar."


	;; Start with Issue 1 displayed in the label
	$l1 = GUICtrlCreateLabel($sIssue1, 60, 45, 400, 240)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetBkColor(-1, 0xffffff)

	GUIRegisterMsg($WM_SIZE, "WM_SIZE")
	GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")
	GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")

	GUISetState(@SW_SHOW)

	;; _GUIScrollBars_Init($hGUI)
	_GUIScrollBars_Init($hGUI, $iMaxHScroll, $iMaxVScroll)

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $b0
				Local $a1 = ControlGetPos("2 ScrollBar Issues", "", $b0)
				MsgBox(4096, "Button Position", "The position of this button is " & $a1[0] & "," & $a1[1])

			Case $b1
				;; Display issue 1
				GUICtrlSetData($l1, $sIssue1)

			Case $b2
				;; Display issue 2
				GUICtrlSetData($l1, $sIssue2)

		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example


Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam
	Local $iIndex = -1, $iCharY, $iCharX, $iClientMaxX, $iClientX, $iClientY, $iMax
	For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
		If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$iClientMaxX = $__g_aSB_WindowInfo[$iIndex][1]
			$iCharX = $__g_aSB_WindowInfo[$iIndex][2]
			$iCharY = $__g_aSB_WindowInfo[$iIndex][3]
			$iMax = $__g_aSB_WindowInfo[$iIndex][7]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)

	; Retrieve the dimensions of the client area.
	$iClientX = BitAND($lParam, 0x0000FFFF)
	$iClientY = BitShift($lParam, 16)
	$__g_aSB_WindowInfo[$iIndex][4] = $iClientX
	$__g_aSB_WindowInfo[$iIndex][5] = $iClientY

	; Set the vertical scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", $iMax)
	DllStructSetData($tSCROLLINFO, "nPage", $iClientY / $iCharY)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)

	; Set the horizontal scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", 2 + $iClientMaxX / $iCharX)
	DllStructSetData($tSCROLLINFO, "nPage", $iClientX / $iCharX)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func WM_HSCROLL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $lParam
	Local $iScrollCode = BitAND($wParam, 0x0000FFFF)

	Local $iIndex = -1, $iCharX, $iPosX
	Local $iMin, $iMax, $iPage, $iPos, $iTrackPos

	For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
		If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$iCharX = $__g_aSB_WindowInfo[$iIndex][2]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	; ; Get all the horizontal scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_HORZ)
	$iMin = DllStructGetData($tSCROLLINFO, "nMin")
	$iMax = DllStructGetData($tSCROLLINFO, "nMax")
	$iPage = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$iPosX = DllStructGetData($tSCROLLINFO, "nPos")
	$iPos = $iPosX
	$iTrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")
	#forceref $iMin, $iMax
	Switch $iScrollCode

		Case $SB_LINELEFT ; user clicked left arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - 1)

		Case $SB_LINERIGHT ; user clicked right arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + 1)

		Case $SB_PAGELEFT ; user clicked the scroll bar shaft left of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - $iPage)

		Case $SB_PAGERIGHT ; user clicked the scroll bar shaft right of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + $iPage)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iTrackPos)
	EndSwitch

	; // Set the position and then retrieve it.  Due to adjustments
	; //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$iPos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($iPos <> $iPosX) Then _GUIScrollBars_ScrollWindow($hWnd, $iCharX * ($iPosX - $iPos), 0)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_HSCROLL

Func WM_VSCROLL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam, $lParam
	Local $iScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $iIndex = -1, $iCharY, $iPosY
	Local $iMin, $iMax, $iPage, $iPos, $iTrackPos

	For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
		If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$iCharY = $__g_aSB_WindowInfo[$iIndex][3]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	; Get all the vertial scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$iMin = DllStructGetData($tSCROLLINFO, "nMin")
	$iMax = DllStructGetData($tSCROLLINFO, "nMax")
	$iPage = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$iPosY = DllStructGetData($tSCROLLINFO, "nPos")
	$iPos = $iPosY
	$iTrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $iScrollCode
		Case $SB_TOP ; user clicked the HOME keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $iMin)

		Case $SB_BOTTOM ; user clicked the END keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $iMax)

		Case $SB_LINEUP ; user clicked the top arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - 1)

		Case $SB_LINEDOWN ; user clicked the bottom arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + 1)

		Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - $iPage)

		Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + $iPage)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iTrackPos)
	EndSwitch

	; // Set the position and then retrieve it.  Due to adjustments
	; //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$iPos = DllStructGetData($tSCROLLINFO, "nPos")

	If ($iPos <> $iPosY) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $iCharY * ($iPosY - $iPos))
		$iPosY = $iPos
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_VSCROLL
