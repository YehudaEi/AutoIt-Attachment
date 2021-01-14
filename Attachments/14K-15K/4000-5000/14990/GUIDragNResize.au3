;§+++++++++++++++++++++++++++++++++++§;
;§  Project Based on The Gorganizer  §;
;§  Draggable and Resizable Controls §;
;§  Author: Kurt a.k.a. _Kurt        §;
;§+++++++++++++++++++++++++++++++++++§;

;~REGULAR GUI SECTION
#include <GUIConstants.au3>
$GUI = GUICreate("..Drag Test..")
GUISetBkColor(0x0000ff)
$item1 = GUICtrlCreateButton("         Drag Me", 100, 100, 200, 50)
;~DRAG CONTROLS
Local $LastClick, $SquareResizers[7], $Hover = -1337
$DragOverlay = GUICtrlCreateLabel("", -99, -99, 1, 1, $SS_BLACKFRAME)
$SquareResizers[1] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 12)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
$SquareResizers[2] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 10)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
$SquareResizers[3] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 10)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
$SquareResizers[4] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 12)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
$SquareResizers[5] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 11)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
$SquareResizers[6] = GUICtrlCreateLabel("", 0, 0, 5, 5)
GUICtrlSetCursor(-1, 11)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetState(-1,$GUI_HIDE)
GUISetState()

While 1
	Sleep(15)
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $SquareResizers[1]
			_GUICtrlResizeNE()
		Case $msg = $SquareResizers[2]
			_GUICtrlResizeNW()
		Case $msg = $SquareResizers[3]
			_GUICtrlResizeSE()
		Case $msg = $SquareResizers[4]
			_GUICtrlResizeSW()
		Case $msg = $SquareResizers[5]
			_GUICtrlResizeN()
		Case $msg = $SquareResizers[6]
			_GUICtrlResizeS()
	EndSelect
	_GUICtrlDrag($Hover)
	_GUICtrlDragOverlay()
WEnd

Func _GUICtrlDragOverlay()
	$cursor = GUIGetCursorInfo()
	If IsArray($cursor) Then
		If $cursor[4] <> 0 Then
			If $cursor[4] <> $SquareResizers[1] AND $cursor[4] <> $SquareResizers[2] AND $cursor[4] <> $SquareResizers[3] AND $cursor[4] <> $SquareResizers[4] AND $cursor[4] <> $SquareResizers[5] AND $cursor[4] <> $SquareResizers[6] Then
				$pos = ControlGetPos($GUI, "", $cursor[4])
				$pos2 = ControlGetPos($GUI, "", $DragOverlay)
				If $pos[0] <> $pos2[0]+1 AND $pos[1] <> $pos2[1]+1 AND $pos[2] <> $pos2[2]-2 AND $pos[3] <> $pos2[3]-2 Then
					GUICtrlSetPos($DragOverlay, $pos[0]-1, $pos[1]-1, $pos[2]+2, $pos[3]+2)
					GUICtrlSetState($DragOverlay, $GUI_SHOW)
					GUICtrlSetState($cursor[4], $GUI_DISABLE)
					$Hover = $cursor[4]
				EndIf
			EndIf
		Else
			GUICtrlSetState($Hover, $GUI_ENABLE)
			$Hover = -1337
			GUICtrlSetPos($DragOverlay, -99, -99, 1, 1)
		EndIf
	EndIf
EndFunc

Func _GUICtrlResizeS()
	GUISetCursor(11)
	GUICtrlSetCursor($LastClick, 10)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1], $pos[2], ($cursor[1]-$pos[1]))
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0 
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeN()
	GUISetCursor(11)
	GUICtrlSetCursor($LastClick, 11)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1]-($pos[1]-$cursor[1]), $pos[2], $pos[3]+($pos[1]-$cursor[1]))
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
	Until $cursor[2] = 0 
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeSE()
	GUISetCursor(10)
	GUICtrlSetCursor($LastClick, 10)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0]-($pos[0]-$cursor[0]), $pos[1], ($pos[0]-$cursor[0])+$pos[2], ($cursor[1]-$pos[1]))
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0 
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeNW()
	GUISetCursor(10)
	GUICtrlSetCursor($LastClick, 10)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1]-($pos[1]-$cursor[1]), $cursor[0]-$pos[0], $pos[3]+($pos[1]-$cursor[1]))
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0 
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeNE()
	GUISetCursor(12)
	GUICtrlSetCursor($LastClick, 12)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	$XStayPos = $pos[0]+$pos[2]
	$YStayPos = $pos[1]+$pos[3]
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		If $cursor[0] > $XStayPos Then $cursor[0] = $XStayPos
		If $cursor[1] > $YStayPos Then $cursor[1] = $YStayPos
		GUICtrlSetPos($LastClick, $cursor[0], $cursor[1], $XStayPos-$cursor[0], $YStayPos-$cursor[1])
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeSW()
	GUISetCursor(12)
	GUICtrlSetCursor($LastClick, 12)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($GUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1], $cursor[0]-$pos[0], $cursor[1]-$pos[1])
		$pos = ControlGetPos($GUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlDrag($Control, $GridScale = 0)
	Select
		Case $msg = $DragOverlay
			For $i = 0 To UBound($SquareResizers)-1
				GUICtrlSetState($SquareResizers[$i], $GUI_HIDE)
			Next
			GUICtrlSetState($DragOverlay, $GUI_HIDE)
			GUICtrlSetCursor($Control, 9)
			$pos = ControlGetPos($GUI, "", $Control)
			$cursor = GUIGetCursorInfo()
			$XStayPos = $cursor[0]-$pos[0]
			$YStayPos = $cursor[1]-$pos[1]
			Do
				Sleep(5)
				$cursor = GUIGetCursorInfo()
				$sX = $cursor[0]-$XStayPos
				$sY = $cursor[1]-$YStayPos
				If $GridScale <> 0 Then
					$sX = Round($sX/$GridScale)*$GridScale
					$sY = Round($sY/$GridScale)*$GridScale
				EndIf
				GUICtrlSetPos($Control, $sX, $sY)
			Until $cursor[2] = 0
			GUICtrlSetCursor($Control, 2)
			GUICtrlSetPos($SquareResizers[1], $sX-3, $sY-5)
			GUICtrlSetPos($SquareResizers[2], ($sX+$pos[2])-2, $sY-5)
			GUICtrlSetPos($SquareResizers[3], $sX-3, $sY+$pos[3])
			GUICtrlSetPos($SquareResizers[4], ($sX+$pos[2])-2, $sY+$pos[3])
			GUICtrlSetPos($SquareResizers[5], (($sX+$pos[2])-($pos[2]/2)), $sY-5)
			GUICtrlSetPos($SquareResizers[6], (($sX+$pos[2])-($pos[2]/2)), $sY+$pos[3])
			For $i = 0 To UBound($SquareResizers)-1
				GUICtrlSetState($SquareResizers[$i], $GUI_SHOW)
			Next
			$pos = ControlGetPos($GUI, "", $cursor[4])
			GUICtrlSetPos($DragOverlay, $pos[0]-1, $pos[1]-1, $pos[2]+2, $pos[3]+2)
			GUICtrlSetState($DragOverlay, $GUI_SHOW)
			$LastClick = $Control
	EndSelect
EndFunc