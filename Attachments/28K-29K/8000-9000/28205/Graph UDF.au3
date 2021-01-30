#include-once
#include <GUIConstantsEx.au3>

; #FUNCTION# ============================================================================
; Name...........: _Graph_Create
; Description ...: Creates graph area, and prepares array of specified data
; Syntax.........: _Graph_Create($iLeft,$iTop,$iWidth,$iHeight)
; Parameters ....: $iLeft - left most position in GUI
;                  $iTop - top most position in GUI
;                   $iWidth - width of graph in pixels
;                   $iHeight - height of graph in pixels
; Return values .: Returns array containing variables for subsequent functions...
;                    Returned Graph array is:
;                    [1] graphic control handle
;                    [2] left
;                    [3] top
;                    [4] width
;                    [5] height
;                    [6] x low
;                    [7] x high
;                    [8] y low
;                    [9] y high
;                    [10] x ticks handles
;                    [11] x labels handles
;                    [12] y ticks handles
;                    [13] y labels handles
;					 [14] Border Colour
;					 [15] Fill Colour
; =======================================================================================
Func _Graph_Create($iLeft,$iTop,$iWidth,$iHeight,$hColourBorder = 0x000000,$hColorFill = 0xFFFFFF)
    $hWnd = GUICtrlCreateGraphic($iLeft,$iTop,$iWidth+1,$iHeight+1)
	GUICtrlSetColor(-1,$hColourBorder)
    GUICtrlSetBkColor(-1,$hColorFill)
    Local $ahTicksLabelsX[1]
    Local $ahTicksLabelsY[1]
    Local $ahTicksX[1]
    Local $ahTicksY[1]
    Dim $aGraphArray[16] = ["",$hWnd,$iLeft,$iTop,$iWidth,$iHeight,0,1,0,1, _
	$ahTicksX,$ahTicksLabelsX,$ahTicksY,$ahTicksLabelsY,$hColourBorder,$hColorFill]
    Return $aGraphArray
EndFunc



; #FUNCTION# ============================================================================
; Name...........: _Graph_Delete
; Description ...: Deletes previously created graph and related ticks/labels
; Syntax.........: _Graph_Delete(ByRef $aGraphArray)
; Parameters ....: $aGraphArray - the array returned from _Graph_Create
; =======================================================================================
Func _Graph_Delete(ByRef $aGraphArray)
;----- delete x ticks/labels -----
    $ahTicksX = $aGraphArray[10]
    $ahTicksLabelsX = $aGraphArray[11]
    For $i = 1 to (UBound($ahTicksX) - 1)
        GUICtrlDelete($ahTicksX[$i])
    Next
    For $i = 1 to (UBound($ahTicksLabelsX) - 1)
        GUICtrlDelete($ahTicksLabelsX[$i])
    Next
;----- delete y ticks/labels -----
    $ahTicksY = $aGraphArray[12]
    $ahTicksLabelsY = $aGraphArray[13]
    For $i = 1 to (UBound($ahTicksY) - 1)
        GUICtrlDelete($ahTicksY[$i])
    Next
    For $i = 1 to (UBound($ahTicksLabelsY) - 1)
        GUICtrlDelete($ahTicksLabelsY[$i])
    Next
    Dim $ahTicksLabelsY[1]
;----- delete graphic control -----
    GUICtrlDelete($aGraphArray[1])
;----- close array -----
    $aGraphArray = 0
EndFunc



; #FUNCTION# ============================================================================
; Name...........: _Graph_Clear
; Description ...: Clears graph content
; Syntax.........: _Graph_Clear(ByRef $aGraphArray)
; Parameters ....: $aGraphArray - the array returned from _Graph_Create
; =======================================================================================
Func _Graph_Clear(ByRef $aGraphArray)
    GUICtrlDelete($aGraphArray[1])
    $aGraphArray[1] = GUICtrlCreateGraphic($aGraphArray[2],$aGraphArray[3], _
	$aGraphArray[4]+1,$aGraphArray[5]+1)
    GUICtrlSetBkColor(-1,0xFFFFFF)
    GUICtrlSetColor(-1,0x000000)
EndFunc



; #FUNCTION# ============================================================================
; Name...........: _Graph_SetRange_X
; Description ...: Allows user to set the range of the X axis and set ticks and rounding levels
; Syntax.........: _Graph_SetRange_X(ByRef $aGraphArray,$iLow,$iHigh,$iXTicks = 1,$bLabels = 1,$iRound = 0)
; Parameters ....:    $aGraphArray - the array returned from _Graph_Create
;                    $iLow - the lowest value for the X axis (can be negative)
;                    $iHigh - the highest value for the X axis
;                    $iXTicks - [optional] number of ticks to show below axis, if = 0 then no ticks created
;                    $bLabels - [optional] 1=show labels, any other number=do not show labels
;                    $iRound - [optional] rounding level of label values
; =======================================================================================
Func _Graph_SetRange_X(ByRef $aGraphArray,$iLow,$iHigh,$iXTicks = 1,$bLabels = 1,$iRound = 0)
;----- load user vars to array -----
    $aGraphArray[6] = $iLow
    $aGraphArray[7] = $iHigh
;----- prepare nested array -----
    $ahTicksX = $aGraphArray[10]
    $ahTicksLabelsX = $aGraphArray[11]
;----- delete any existing ticks -----
    For $i = 1 to (UBound($ahTicksX) - 1)
        GUICtrlDelete($ahTicksX[$i])
    Next
    Dim $ahTicksX[1]
;----- create new ticks -----
    For $i = 1 To $iXTicks + 1
        ReDim $ahTicksX[$i + 1]
        $ahTicksX[$i] = GUICtrlCreateLabel("",(($i - 1) * ($aGraphArray[4] / $iXTicks)) + $aGraphArray[2], _
		$aGraphArray[3] + $aGraphArray[5],1,5)
        GUICtrlSetBkColor(-1,0x000000)
        GUICtrlSetState(-1,$GUI_DISABLE)
    Next
;----- delete any existing labels -----
    For $i = 1 to (UBound($ahTicksLabelsX) - 1)
        GUICtrlDelete($ahTicksLabelsX[$i])
    Next
    Dim $ahTicksLabelsX[1]
;----- create new labels -----
    For $i = 1 To $iXTicks + 1
        ReDim $ahTicksLabelsX[$i + 1]
        $ahTicksLabelsX[$i] = GUICtrlCreateLabel("", _
        ($aGraphArray[2] + (($aGraphArray[4] / $iXTicks) * ($i - 1))) - (($aGraphArray[4] / $iXTicks) / 2), _
        $aGraphArray[3] + $aGraphArray[5] + 10,$aGraphArray[4] / $iXTicks,13,1)
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Next
;----- if labels are required, then fill -----
    If $bLabels = 1 Then
        For $i = 1 To (UBound($ahTicksLabelsX) - 1)
            GUICtrlSetData($ahTicksLabelsX[$i], _
            StringFormat("%." & $iRound & "f",_Graph_Reference_Pixel("p",(($i - 1) * ($aGraphArray[4] / $iXTicks)), _
            $aGraphArray[6],$aGraphArray[7],$aGraphArray[4])))
        Next
    EndIf
;----- load created arrays back into array -----
    $aGraphArray[10] = $ahTicksX
    $aGraphArray[11] = $ahTicksLabelsX
EndFunc



; #FUNCTION# ============================================================================
; Name...........: _Graph_SetRange_Y
; Description ...: Allows user to set the range of the Y axis and set ticks and rounding levels
; Syntax.........: _Graph_SetRange_Y(ByRef $aGraphArray,$iLow,$iHigh,$iYTicks = 1,$bLabels = 1,$iRound = 0)
; Parameters ....:    $aGraphArray - the array returned from _Graph_Create
;                    $iLow - the lowest value for the Y axis (can be negative)
;                    $iHigh - the highest value for the Y axis
;                    $iYTicks - [optional] number of ticks to show next to axis, if = 0 then no ticks created
;                    $bLabels - [optional] 1=show labels, any other number=do not show labels
;                    $iRound - [optional] rounding level of label values
; =======================================================================================
Func _Graph_SetRange_Y(ByRef $aGraphArray,$iLow,$iHigh,$iYTicks = 1,$bLabels = 1,$iRound = 0)
;----- load user vars to array -----
    $aGraphArray[8] = $iLow
    $aGraphArray[9] = $iHigh
;----- prepare nested array -----
    $ahTicksY = $aGraphArray[12]
    $ahTicksLabelsY = $aGraphArray[13]
;----- delete any existing ticks -----
    For $i = 1 to (UBound($ahTicksY) - 1)
        GUICtrlDelete($ahTicksY[$i])
    Next
    Dim $ahTicksY[1]
;----- create new ticks -----
    For $i = 1 To $iYTicks + 1
        ReDim $ahTicksY[$i + 1]
        $ahTicksY[$i] = GUICtrlCreateLabel("",$aGraphArray[2] - 5, _
        ($aGraphArray[3] + $aGraphArray[5]) - (($aGraphArray[5] / $iYTicks) * ($i - 1)),5,1)
        GUICtrlSetBkColor(-1,0x000000)
        GUICtrlSetState(-1,$GUI_DISABLE)
    Next
;----- delete any existing labels -----
    For $i = 1 to (UBound($ahTicksLabelsY) - 1)
        GUICtrlDelete($ahTicksLabelsY[$i])
    Next
    Dim $ahTicksLabelsY[1]
;----- create new labels -----
    For $i = 1 To $iYTicks + 1
        ReDim $ahTicksLabelsY[$i + 1]
        $ahTicksLabelsY[$i] = GUICtrlCreateLabel("",$aGraphArray[2] - 40, _
        ($aGraphArray[3] + $aGraphArray[5]) - (($aGraphArray[5] / $iYTicks) * ($i - 1)) - 6,30,13,2)
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Next
;----- if labels are required, then fill -----
    If $bLabels = 1 Then
        For $i = 1 To (UBound($ahTicksLabelsY) - 1)
            GUICtrlSetData($ahTicksLabelsY[$i],StringFormat("%." & $iRound & "f",_Graph_Reference_Pixel("p", _
            (($i - 1) * ($aGraphArray[5] / $iYTicks)),$aGraphArray[8],$aGraphArray[9],$aGraphArray[5])))
        Next
    EndIf
;----- load created arrays back into array -----
    $aGraphArray[12] = $ahTicksY
    $aGraphArray[13] = $ahTicksLabelsY
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Start
; Description ...: Move starting point of plot
; Syntax.........: _Graph_Plot_Start(ByRef $aGraphArray,$iX,$iY)
; Parameters ....:     $aGraphArray - the array returned from _Graph_Create
;                    $iX - x value to start at
;                    $iY - y value to start at
; ========================================================================================
Func _Graph_Plot_Start(ByRef $aGraphArray,$iX,$iY)
;----- MOVE pen to start point -----
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_MOVE, _
	_Graph_Reference_Pixel("x",$iX,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _
	_Graph_Reference_Pixel("y",$iY,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]))
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Line
; Description ...: draws straight line to x,y from previous point / starting point
; Syntax.........: _Graph_Plot_Line(ByRef $aGraphArray,$iX,$iY)
; Parameters ....:     $aGraphArray - the array returned from _Graph_Create
;                    $iX - x value to draw to
;                    $iY - y value to draw to
; ========================================================================================
Func _Graph_Plot_Line(ByRef $aGraphArray,$iX,$iY)
;----- Draw line from previous point to new point -----
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_LINE, _
	_Graph_Reference_Pixel("x",$iX,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _
	_Graph_Reference_Pixel("y",$iY,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]))
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Point
; Description ...: draws point at coords
; Syntax.........: _Graph_Plot_Point(ByRef $aGraphArray,$iX,$iY)
; Parameters ....:     $aGraphArray - the array returned from _Graph_Create
;                    $iX - x value to draw at
;                    $iY - y value to draw at
; ========================================================================================
Func _Graph_Plot_Point(ByRef $aGraphArray,$iX,$iY)
;----- Draw point from previous point to new point -----
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_DOT, _
	_Graph_Reference_Pixel("x",$iX,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _
	_Graph_Reference_Pixel("y",$iY,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]))
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Dot
; Description ...: draws single pixel dot at coords
; Syntax.........: _Graph_Plot_Dot(ByRef $aGraphArray,$iX,$iY)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
;                    $iX - x value to draw at
;                    $iY - y value to draw at
; ========================================================================================
Func _Graph_Plot_Dot(ByRef $aGraphArray,$iX,$iY)
;----- Draw point from previous point to new point -----
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_PIXEL, _
	_Graph_Reference_Pixel("x",$iX,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _
	_Graph_Reference_Pixel("y",$iY,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]))
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Set_Color
; Description ...: sets the color for the next drawing
; Syntax.........: _Graph_Set_Color(ByRef $aGraphArray,$hColor,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
;                    $hColor - the color of the next item
;					 $hBkGrdColor - the background color of the next item
; ========================================================================================
Func _Graph_Set_Color(ByRef $aGraphArray,$hColor,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_COLOR,$hColor,$hBkGrdColor)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Set_PenSize
; Description ...: sets the pen for the next drawing
; Syntax.........: _Graph_Set_PenSize(ByRef $aGraphArray,$iSize = 1)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
;                    $iSize - size of pen line
; ========================================================================================
Func _Graph_Set_PenSize(ByRef $aGraphArray,$iSize = 1)
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_PENSIZE,$iSize)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Bar_X
; Description ...: Draws bar chart bar from the x axis
; Syntax.........: _Graph_Plot_Bar_X(ByRef $aGraphArray,$iStart,$iWidth,$nYValue,$hColor = 0x000000,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
;                    $iStart - the x axis value for start of bar (in x axis units)
;					 $iWidth - width of the bar (in x axis units)
;                    $nYValue - 'height' of the bar (in y axis units)
;					 $hColor - Bar border colour
;					 $hBkGrdColor - Bar fill colour
; ========================================================================================
Func _Graph_Plot_Bar_X(ByRef $aGraphArray,$iStart,$iWidth,$nYValue,$hColor = 0x000000,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
;----- Draw Bar for BarChart Application -----
	_Graph_Set_Color($aGraphArray,$hColor,$hBkGrdColor)
	GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT, _
		_Graph_Reference_Pixel("x",$iStart,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _ ;x
		$aGraphArray[5]+1, _
		Round(_Graph_Reference_Pixel("x",$iStart + $iWidth,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]) - _ ;width
		_Graph_Reference_Pixel("x",$iStart,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]) + 1), _
		- $aGraphArray[5] + _Graph_Reference_Pixel("y",$nYValue,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]) - 1) ;height
	;- redraw axis in case coloured -
	_Graph_Set_Color($aGraphArray,$aGraphArray[14],$GUI_GR_NOBKCOLOR)
	GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT,0,0,$aGraphArray[4]+1,$aGraphArray[5]+1)
	;- set colour back to default -
	_Graph_Set_Color($aGraphArray,0x000000,$GUI_GR_NOBKCOLOR)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Plot_Bar_Y
; Description ...: Draws bar chart bar from the y axis
; Syntax.........: _Graph_Plot_Bar_Y(ByRef $aGraphArray,$iStart,$iWidth,$nYValue,$hColor = 0x000000,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
;                    $iStart - the y axis value for start of bar (in y axis units)
;					 $iWidth - width of the bar (in y axis units)
;                    $nXValue - 'length' of the bar (in x axis units)
;					 $hColor - Bar border colour
;					 $hBkGrdColor - Bar fill colour
; ========================================================================================
Func _Graph_Plot_Bar_Y(ByRef $aGraphArray,$iStart,$iWidth,$nYValue,$hColor = 0x000000,$hBkGrdColor = $GUI_GR_NOBKCOLOR)
;----- Draw Bar for BarChart Application -----
	_Graph_Set_Color($aGraphArray,$hColor,$hBkGrdColor)
	GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT, _
		0, _ ;x
		_Graph_Reference_Pixel("y",$iStart + $iWidth,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]), _ ;y
		_Graph_Reference_Pixel("x",$nYValue,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]) + 1, _ ;width
		_Graph_Reference_Pixel("y",$iStart,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]) - _ ;height
		_Graph_Reference_Pixel("y",$iStart + $iWidth,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]) + 1)
	;- redraw axis in case coloured -
	_Graph_Set_Color($aGraphArray,$aGraphArray[14],$GUI_GR_NOBKCOLOR)
	GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT,0,0,$aGraphArray[4]+1,$aGraphArray[5]+1)
	;- set colour back to default -
	_Graph_Set_Color($aGraphArray,0x000000,$GUI_GR_NOBKCOLOR)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_SetGrid_X
; Description ...: Adds X gridlines.
; Syntax.........: _Graph_SetGrid(ByRef $aGraphArray, $Ticks=1, $hColor=0xf0f0f0)
; Parameters ....: 	$aGraphArray - the array returned from _Graph_Create
;					$Ticks - sets line at every nth unit assigned to axis
;     				$hColor - [optional] RGB value, defining color of grid. Default is a light gray
; =======================================================================================
Func _Graph_SetGrid_X(ByRef $aGraphArray, $Ticks=1, $hColor=0xf0f0f0)
	_Graph_Set_Color($aGraphArray,$hColor,$GUI_GR_NOBKCOLOR)
	Select
		Case $Ticks > 0
			For $i = $aGraphArray[6] To $aGraphArray[7] Step $Ticks
				If $i = Number($aGraphArray[6]) Or $i = Number($aGraphArray[7]) Then ContinueLoop
					GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT, _ ;rectangle
					_Graph_Reference_Pixel("x",$i,$aGraphArray[6],$aGraphArray[7],$aGraphArray[4]), _ ;x
					1, _ ;y
					1, _ ;width
					$aGraphArray[5] - 1) ;height
			Next
	EndSelect
	_Graph_Set_Color($aGraphArray,0x000000)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_SetGrid_Y
; Description ...: Adds Y gridlines.
; Syntax.........: _Graph_SetGrid(ByRef $aGraphArray, $Ticks=1, $hColor=0xf0f0f0)
; Parameters ....: 	$aGraphArray - the array returned from _Graph_Create
;					$Ticks - sets line at every nth unit assigned to axis
;     				$hColor - [optional] RGB value, defining color of grid. Default is a light gray
; =======================================================================================
Func _Graph_SetGrid_Y(ByRef $aGraphArray, $Ticks=1, $hColor=0xf0f0f0)
	_Graph_Set_Color($aGraphArray,$hColor,$GUI_GR_NOBKCOLOR)
	Select
		Case $Ticks > 0
			For $i = $aGraphArray[8] To $aGraphArray[9] Step $Ticks
				If $i = Number($aGraphArray[8]) Or $i = Number($aGraphArray[9]) Then ContinueLoop
					GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_RECT, _ ;rectangle
					1, _ ;x
					_Graph_Reference_Pixel("y",$i,$aGraphArray[8],$aGraphArray[9],$aGraphArray[5]), _ ;y
					$aGraphArray[4] - 1, _ ;width
					1) ;height
			Next
	EndSelect
	_Graph_Set_Color($aGraphArray,0x000000)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Refresh
; Description ...: refreshes the graphic
; Syntax.........: _Graph_Refresh(ByRef $aGraphArray)
; Parameters ....:   $aGraphArray - the array returned from _Graph_Create
; ========================================================================================
Func _Graph_Refresh(ByRef $aGraphArray)
    GUICtrlSetGraphic($aGraphArray[1],$GUI_GR_REFRESH)
EndFunc



; #FUNCTION# =============================================================================
; Name...........: _Graph_Reference_Pixel
; Description ...: INTERNAL FUNCTION - performs pixel reference calculations
; Syntax.........: _Graph_Reference_Pixel($iType,$iValue,$iLow,$iHigh,$iTotalPixels)
; Parameters ....:     $iType - "x"=x axis pix, "y" = y axis pix, "p"=value from pixels
;                    $iValue - pixels reference or value
;                    $iLow - lower limit of axis
;                    $iHigh - upper limit of axis
;                    $iTotalPixels - total number of pixels in range (either width or height)
; =========================================================================================
Func _Graph_Reference_Pixel($iType,$iValue,$iLow,$iHigh,$iTotalPixels)
;----- perform pixel reference calculations -----
    Switch $iType
        Case "x"
            Return (($iTotalPixels/($iHigh-$iLow))*(($iHigh-$iLow)*(($iValue-$iLow)/($iHigh-$iLow))))
        Case "y"
            Return ($iTotalPixels - (($iTotalPixels/($iHigh-$iLow))*(($iHigh-$iLow)*(($iValue-$iLow)/($iHigh-$iLow)))))
        Case "p"
            Return ($iValue / ($iTotalPixels/ ($iHigh - $iLow))) + $iLow
    EndSwitch
EndFunc
