#include <GUIConstants.au3>
Global $Graph[1][9]

Func _GraphCreate($sLeft,$sRight,$sWidth,$sHeight)
	Local $n = UBound($Graph)
	ReDim $Graph[$n+1][9]
	; $Graph[n][0] = ControlID
	$Graph[$n][0] = GUICtrlCreateGraphic($sLeft,$sRight,$sWidth,$sHeight)
	GUICtrlSetBkColor($Graph[$n][0],0xFFFFFF)
	;$Graph[$n][1 to 4] are boundaries. Standard boundaries will be set now.
	$Graph[$n][1] = -10
	$Graph[$n][2] = 10
	$Graph[$n][3] = -10
	$Graph[$n][4] = 10
	;$Graph[$n][5,6] are Control width and heights
	$Graph[$n][4] = $sLeft
	$Graph[$n][5] = $sRight
	$Graph[$n][7] = $sWidth
	$Graph[$n][8] = $sHeight
	Return $n
EndFunc

Func _GraphCreateFormula($n,$Formula)
	$Formula = StringReplace($Formula,"x", "$x")
	$z = UBound($Graph,2)
	ReDim $Graph[UBound($Graph)][$z+1]
	$Graph[$n][$z] = $Formula
	Return $z
EndFunc

Func _GraphDrawFormula($n,$z,$delay = 0)
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_MOVE,(($Graph[$n][1]*$Graph[$n][7]/$Graph[$n][2])+$Graph[$n][7])/2 , (($Graph[$n][8]/2)-(Execute(StringReplace($Graph[$n][$z],"$x","$Graph[$n][1]"))*($Graph[$n][7]/($Graph[$n][2] - $Graph[$n][1])))))
	For $x = $Graph[$n][1] To $Graph[$n][2] Step 0.05
		GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_LINE, (($x*$Graph[$n][7]/$Graph[$n][2])+$Graph[$n][7])/2 , (($Graph[$n][8]/2)-(Execute($Graph[$n][$z])*($Graph[$n][7]/($Graph[$n][2] - $Graph[$n][1])))))
		If $delay > 0 Then
			GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_REFRESH)
			Sleep($delay)
		EndIf
	Next
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_REFRESH)
EndFunc

Func _GraphDrawBackground($n)
	Local $y, $x
	
	$y = $Graph[$n][8]/2
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_MOVE,0,$y)
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_LINE,$Graph[$n][7],$y)
	
	For $x = 0 to $Graph[$n][7] Step $Graph[$n][7]/($Graph[$n][2] - $Graph[$n][1])
		GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_PIXEL,$x,$y-1)
		GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_PIXEL,$x,$y-2)
	Next
	
	$x = $Graph[$n][7]/2
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_MOVE,$x,0)
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_LINE,$x,$Graph[$n][8])
	
	For $y = 0 to $Graph[$n][8] Step $Graph[$n][8]/($Graph[$n][4] - $Graph[$n][3])
		GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_PIXEL,$x+1,$y)
		GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_PIXEL,$x+2,$y)
	Next
	
	GUICtrlSetGraphic($Graph[$n][0],$GUI_GR_REFRESH)
EndFunc

Func _GraphSetBound($n, $xMin, $xMax, $yMin, $yMax)
	$Graph[$n][1] = $xMin
	$Graph[$n][2] = $xMax
	$Graph[$n][3] = $yMin
	$Graph[$n][4] = $yMax
EndFunc

Func _GraphClear($n)
	GUICtrlDelete($Graph[$n][0])
	$Graph[$n][0] = GUICtrlCreateGraphic($Graph[$n][4],$Graph[$n][5],$Graph[$n][6],$Graph[$n][7])
	GUICtrlSetBkColor($Graph[$n][0],0xFFFFFF)
	_GraphDrawBackground($n)
EndFunc