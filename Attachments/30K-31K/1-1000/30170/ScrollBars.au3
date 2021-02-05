#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>

Opt("MustDeclareVars", 1)

Global $hGUI, $h_cGUI
Global $Child_Height=300
Global $Pos_Increment=30

_Main()

Func _Main()
	Local $GUIMsg
	Local $label, $button, $number=0, $Pos=0, $nPos, $yPos, $Page, $Max
	Local $tSCROLLINFO

	$hGUI = GUICreate("ScrollBar Example", 400, 400, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))

	$button = GUICtrlCreateButton("Add Label", 75, 10, 70, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$label = GUICtrlCreateLabel("Number...",75,40,100)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	
	$h_cGUI = GUICreate("Child GUI", 400, $Child_Height, 0, 100, $WS_CHILD, -1, $hGUI)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	GUISetState()

	GUISwitch($hGUI)
	
	GUISetState()

	_GUIScrollBars_Init($h_cGUI)
	_GUIScrollBars_SetScrollInfoMax($h_cGUI,$SB_HORZ,1)
	_GUIScrollBars_SetScrollInfoPage($h_cGUI,$SB_HORZ,2)
	_GUIScrollBars_SetScrollInfoMax($h_cGUI,$SB_VERT,9)
	_GUIScrollBars_SetScrollInfoPage($h_cGUI,$SB_VERT,10)

	GUIRegisterMsg($WM_SIZE, "WM_SIZE")
	GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")
	GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")

	While 1
		$GUIMsg = GUIGetMsg()

		Switch $GUIMsg
			Case $button
				GUISwitch($h_cGUI)
				$tSCROLLINFO=_GUIScrollBars_GetScrollInfoEx($h_cGUI,$SB_VERT)
				$yPos = DllStructGetData($tSCROLLINFO,"nPos")
				DllStructSetData($tSCROLLINFO,"nPos",0)
				DllStructSetData($tSCROLLINFO,"fMask",$SIF_POS)
				_GUIScrollBars_SetScrollInfo($h_cGUI,$SB_VERT,$tSCROLLINFO)
				_GUIScrollBars_GetScrollInfo($h_cGUI,$SB_VERT,$tSCROLLINFO)
				_GUIScrollBars_ScrollWindow($h_cGUI,0,$yPos-$nPos)
				GUICtrlCreateLabel("This is label #"&$number&", at YPos="&$Pos,10,$Pos)
				GUICtrlSetData($label,"Number = "&$number)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				$number+=1
				$Pos+=$Pos_Increment
				If $Pos >= $Child_Height Then
					$Max=Round($Pos/30)-1
					$Page=Round($Child_Height/$Pos_Increment)
				Else
					$Max=9
					$Page=10
				EndIf
				_GUIScrollBars_SetScrollInfoPage($h_cGUI,$SB_VERT,Int($Page))
				_GUIScrollBars_SetScrollInfoMax($h_cGUI,$SB_VERT,Int($Max))

				ShowInfo($h_cGUI,$Pos,$Page,$Max)
				GUISwitch($hGUI)
				
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>_Main

Func ShowInfo ($hGUI,$Pos,$Page,$Max)
	Local $msg="Next Control Position="&$Pos&@CR& _
				"Max="&$Max&@CR& _
				"Page="&$Page&@CR& _
				"    nPage=" & _GUIScrollBars_GetScrollInfoPage($hGUI, $SB_VERT)&@CR& _
				"     nPos=" & _GUIScrollBars_GetScrollInfoPos($hGUI, $SB_VERT)&@CR& _
				"     nMin=" & _GUIScrollBars_GetScrollInfoMin($hGUI, $SB_VERT)&@CR& _
				"     nMax=" & _GUIScrollBars_GetScrollInfoMax($hGUI, $SB_VERT)&@CR& _
				"nTrackPos=" & _GUIScrollBars_GetScrollInfoTrackPos($hGUI, $SB_VERT)&@CR
	ConsoleWrite($msg)
EndFunc

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $wParam
	Local $index = -1, $yChar, $xChar, $xClientMax, $xClient, $yClient, $ivMax
	; Retrieve the dimensions of the client area.
	$xClient = BitAND($lParam, 0x0000FFFF)
	$yClient = BitShift($lParam, 16)

	If ($hWnd <> $h_cGUI) Then
		WinMove($h_cGUI,"",0,100,$xClient,$yClient-100)
		$Child_Height=$yClient-100
	EndIf


	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$xClientMax = $aSB_WindowInfo[$index][1]
			$xChar = $aSB_WindowInfo[$index][2]
			$yChar = $aSB_WindowInfo[$index][3]
			$ivMax = $aSB_WindowInfo[$index][7]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0

	$aSB_WindowInfo[$index][4] = $xClient
	$aSB_WindowInfo[$index][5] = $yClient

	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	
	; Set the vertical scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", $ivMax)
	DllStructSetData($tSCROLLINFO, "nPage", $yClient / $yChar)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	
	; Set the horizontal scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", 2 + $xClientMax / $xChar)
	DllStructSetData($tSCROLLINFO, "nPage", $xClient / $xChar)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func WM_HSCROLL($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)

	Local $index = -1, $xChar, $xPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$xChar = $aSB_WindowInfo[$index][2]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0
	
;~ 	; Get all the horizontal scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_HORZ)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$xPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $xPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")
	#forceref $Min, $Max
	Switch $nScrollCode

		Case $SB_LINELEFT ; user clicked left arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)

		Case $SB_LINERIGHT ; user clicked right arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)

		Case $SB_PAGELEFT ; user clicked the scroll bar shaft left of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)

		Case $SB_PAGERIGHT ; user clicked the scroll bar shaft right of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

;~    // Set the position and then retrieve it.  Due to adjustments
;~    //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$Pos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($Pos <> $xPos) Then _GUIScrollBars_ScrollWindow($hWnd, $xChar * ($xPos - $Pos), 0)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_HSCROLL

Func WM_VSCROLL($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $wParam, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $index = -1, $yChar, $yPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$yChar = $aSB_WindowInfo[$index][3]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0


	; Get all the vertial scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$yPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $yPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $nScrollCode
		Case $SB_TOP ; user clicked the HOME keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Min)

		Case $SB_BOTTOM ; user clicked the END keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Max)

		Case $SB_LINEUP ; user clicked the top arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)

		Case $SB_LINEDOWN ; user clicked the bottom arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)

		Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)

		Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch
	
;~    // Set the position and then retrieve it.  Due to adjustments
;~    //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$Pos = DllStructGetData($tSCROLLINFO, "nPos")

	If ($Pos <> $yPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
		$yPos = $Pos
	EndIf

	Return $GUI_RUNDEFMSG

EndFunc   ;==>WM_VSCROLL
