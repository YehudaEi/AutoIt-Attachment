; Line drawer and intersection calculator.
;
; Origin (0, 0) is in the middle of the graphic control
; Points based off the center being (0, 0) instead of the upper-left corner being (0, 0)
; Complete with axes and grid marks every 10 pixels from the center outward
; Can move the lines around with w,a,d,s for line 1 (red), and i,j,k,l for line 2 (blue)
; Refresh lines button: create two new random lines
; Find intersection button: gives more info (x and y coordinates for both lines, Ua, Ub, and intersection point)
; Note: for above, second dialog will either be an error that the two segments don't intersect, or a repeat of the label
; Note: the intersection point in the first dialog box will be calculated regardless, and tells the intersection point as if the segments were full lines
; Note: points for lines: (x1, y1), (x2, y2) and (x3, y3), (x4, y4)
;
; Created by greenmachine on 10/20/05
;
;
; Thanks to: 
; Paul Bourke for the intersection formula => http://astronomy.swin.edu.au/~pbourke/geometry/lineline2d/
; Anyone at the AutoIt forums who made a graphic script and therefore helped me figure this one out


Opt ("GUIOnEventMode", 1)

HotKeySet ("w", "Line1Up")
HotKeySet ("a", "Line1Left")
HotKeySet ("d", "Line1Right")
HotKeySet ("s", "Line1Down")

HotKeySet ("i", "Line2Up")
HotKeySet ("j", "Line2Left")
HotKeySet ("l", "Line2Right")
HotKeySet ("k", "Line2Down")

Global Const $GUI_EVENT_CLOSE	= -3
Global Const $GUI_GR_LINE		= 2
Global Const $GUI_GR_MOVE		= 6
Global Const $GUI_GR_COLOR		= 8
Global Const $GUI_GR_REFRESH	= 22

Global $XCoordLine1Pt1, $XCoordLine1Pt2, $XCoordLine2Pt1, $XCoordLine2Pt2
Global $YCoordLine1Pt1, $YCoordLine1Pt2, $YCoordLine2Pt1, $YCoordLine2Pt2

$DrawGUI = GUICreate ("Draw", 500, 500, 100, 100)
GUISetOnEvent ($GUI_EVENT_CLOSE, "windowclose")
$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
$xaxis = 225 ; width of the graphic control / 2
$yaxis = 225 ; height of the control / 2


$IntersectButton = GUICtrlCreateButton ("Find Intersection", 400, 465)
GUICtrlSetOnEvent ($IntersectButton, "Intersection")

$RefreshButton = GUICtrlCreateButton ("Refresh Lines", 300, 465)
GUICtrlSetOnEvent ($RefreshButton, "RefreshLines")

DrawAxes()
DrawRandomLine1()
DrawRandomLine2()
$IntersectionPointLabel = GUICtrlCreateLabel ("Intersection Point: ", 10, 470, 300, 20)
IntersectionDialog()

GUISetState (@SW_SHOW)

Func DrawRandomLine1()
	$XCoordLine1Pt1 = Random (-$xaxis, $xaxis, 1)
	$XCoordLine1Pt2 = Random (-$xaxis, $xaxis, 1)
	$YCoordLine1Pt1 = Random (-$xaxis, $xaxis, 1)
	$YCoordLine1Pt2 = Random (-$xaxis, $xaxis, 1)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func DrawRandomLine2()
	$XCoordLine2Pt1 = Random (-$xaxis, $xaxis, 1)
	$XCoordLine2Pt2 = Random (-$xaxis, $xaxis, 1)
	$YCoordLine2Pt1 = Random (-$xaxis, $xaxis, 1)
	$YCoordLine2Pt2 = Random (-$xaxis, $xaxis, 1)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func RefreshLines()
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	DrawRandomLine1()
	DrawRandomLine2()
EndFunc

Func Intersection()
	Local $Ua, $Ub, $Xintersect, $Yintersect, $x1, $x2, $x3, $x4, $y1, $y2, $y3, $y4, $x5, $x6, $x7, $x8, $y5, $y6, $y7, $y8
		$x1 = ($XCoordLine1Pt1)
		$x2 = ($XCoordLine1Pt2)
		$x3 = ($XCoordLine2Pt1)
		$x4 = ($XCoordLine2Pt2)
		$y1 = ($YCoordLine1Pt1)
		$y2 = ($YCoordLine1Pt2)
		$y3 = ($YCoordLine2Pt1)
		$y4 = ($YCoordLine2Pt2)
	If (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)) = 0 Then
		MsgBox (0, "Error", "The lines are parallel")
	Else
		$Ua = ((($x4 - $x3)*($y1 - $y3) - ($y4 - $y3)*($x1 - $x3)) / (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)))
		$Ub = ((($x2 - $x1)*($y1 - $y3) - ($y2 - $y1)*($x1 - $x3)) / (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)))
		$Xintersect = $x1 + $Ua*($x2 - $x1)
		$Yintersect = $y1 + $Ua*($y2 - $y1)
		MsgBox (0, "lots of stuff", "x1: " & $x1 & @CRLF & "x2: " & $x2 & @CRLF & "x3: " & $x3 & @CRLF & "x4: " & $x4 & @CRLF & _ 
		"x intersect: " & $Xintersect & _
		@CRLF & "y1: " & $y1 & @CRLF & "y2: " & $y2 & @CRLF & "y3: " & $y3 & @CRLF & "y4: " & $y4 & @CRLF & _ 
		"y intersect: " & $Yintersect & _
		@CRLF & "Ua: " & $Ua & @CRLF & "Ub: " & $Ub)
		If $Ua < 0 Or $Ua > 1 Or $Ub < 0 Or $Ub > 1 Then
			MsgBox (0, "Error", "The line segments do not intersect")
		Else
			MsgBox (0, "intersect point", $Xintersect & @CRLF & $Yintersect)
		EndIf
	EndIf
	
	;$Ua = [((x4 - x3)(y1 - y3) - (y4 - y3)(x1 - x3)) / ((y4 - y3)(x2 - x1) - (x4 - x3)(y2 - y1))]
	;$Ub = [((x2 - x1)(y1 - y3) - (y2 - y1)(x1 - x3)) / ((y4 - y3)(x2 - x1) - (x4 - x3)(y2 - y1))]
EndFunc

Func IntersectionDialog()
	Local $Ua, $Ub, $Xintersect, $Yintersect, $x1, $x2, $x3, $x4, $y1, $y2, $y3, $y4, $x5, $x6, $x7, $x8, $y5, $y6, $y7, $y8
		$x1 = ($XCoordLine1Pt1)
		$x2 = ($XCoordLine1Pt2)
		$x3 = ($XCoordLine2Pt1)
		$x4 = ($XCoordLine2Pt2)
		$y1 = ($YCoordLine1Pt1)
		$y2 = ($YCoordLine1Pt2)
		$y3 = ($YCoordLine2Pt1)
		$y4 = ($YCoordLine2Pt2)
	If (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)) = 0 Then
		GUICtrlSetData ($IntersectionPointLabel, "Intersection Point: the line segments are parallel")
	Else
		$Ua = ((($x4 - $x3)*($y1 - $y3) - ($y4 - $y3)*($x1 - $x3)) / (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)))
		$Ub = ((($x2 - $x1)*($y1 - $y3) - ($y2 - $y1)*($x1 - $x3)) / (($y4 - $y3)*($x2 - $x1) - ($x4 - $x3)*($y2 - $y1)))
		$Xintersect = $x1 + $Ua*($x2 - $x1)
		$Yintersect = $y1 + $Ua*($y2 - $y1)
		If $Ua < 0 Or $Ua > 1 Or $Ub < 0 Or $Ub > 1 Then
			GUICtrlSetData ($IntersectionPointLabel, "Intersection Point: the line segments do not intersect")
		Else
			GUICtrlSetData ($IntersectionPointLabel, "Intersection Point: " & $Xintersect & ", " & $Yintersect)
		EndIf
	EndIf
EndFunc

Func DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis, 0)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis, $yaxis*2)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, 0, $yaxis)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis*2, $yaxis)
	; draw grid marks
	For $i = 5 To 445 Step 10
		GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $i, $yaxis - 10) ; y grids
		GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $i, $yaxis + 10)
	Next
	For $i = 5 To 445 Step 10
		GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis - 10, $i) ; x grids
		GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + 10, $i)
	Next
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
EndFunc

Func Line1Up()
	$YCoordLine1Pt1 += 5
	$YCoordLine1Pt2 += 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line1Left()
	$XCoordLine1Pt1 -= 5
	$XCoordLine1Pt2 -= 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line1Right()
	$XCoordLine1Pt1 += 5
	$XCoordLine1Pt2 += 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line1Down()
	$YCoordLine1Pt1 -= 5
	$YCoordLine1Pt2 -= 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line2Up()
	$YCoordLine2Pt1 += 5
	$YCoordLine2Pt2 += 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line2Left()
	$XCoordLine2Pt1 -= 5
	$XCoordLine2Pt2 -= 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line2Right()
	$XCoordLine2Pt1 += 5
	$XCoordLine2Pt2 += 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func Line2Down()
	$YCoordLine2Pt1 -= 5
	$YCoordLine2Pt2 -= 5
	GUICtrlDelete ($GraphicControl)
	$GraphicControl = GUICtrlCreateGraphic (5, 5, 450, 450)
	DrawAxes()
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x0000FF)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine2Pt1), $yaxis - ($YCoordLine2Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine2Pt2), $yaxis - ($YCoordLine2Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0xFF0000)
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_MOVE, $xaxis + ($XCoordLine1Pt1), $yaxis - ($YCoordLine1Pt1))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_LINE, $xaxis + ($XCoordLine1Pt2), $yaxis - ($YCoordLine1Pt2))
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_REFRESH) ; refresh to make changes visible
	GUICtrlSetGraphic ($GraphicControl, $GUI_GR_COLOR, 0x000000)
EndFunc

Func windowclose()
	Exit
EndFunc


While 1
	Sleep (100)
	IntersectionDialog() ; constant check of intersecting lines, updated as a label at the bottom
WEnd