Func _DistanceBeetwen2Points($anPoint1,$anPoint2)
	Local $nDistance
	If Not IsArray($anPoint1) Or Not IsArray($anPoint2) Then
		SetError(1)
		Return 0
	ElseIf UBound($anPoint1) <> 2  Or UBound($anPoint2) <> 2 Then
		SetError(2)
		Return 0 		
	EndIf
	$nDistance = Sqrt((($anPoint2[0]-$anPoint1[0])^2)+(($anPoint2[1]-$anPoint1[1])^2))
	Return $nDistance
EndFunc   ;==>_DistanceBeetwen2Points

Func _StraightLineEquationDetBy2Points($anPoint1,$anPoint2)
	Local $nXValue, $nYValue, $nFreeValue
	Local $sXValue, $sYValue, $sFreeValue
	Local $avEquation[4]
	If Not IsArray($anPoint1) Or Not IsArray($anPoint2) Then
		SetError(1)
		Return 0
	ElseIf UBound($anPoint1) <> 2  Or UBound($anPoint2) <> 2 Then
		SetError(2)
		Return 0		
	EndIf
	$nXValue = ($anPoint2[1]-$anPoint1[1])
	$nYValue = ($anPoint2[0]-$anPoint1[0])*(-1)
	$nFreeValue = ((-1)*(($anPoint2[1]-$anPoint1[1])*$anPoint1[0]))+(($anPoint2[0]-$anPoint1[0])*$anPoint1[1])
	$sXValue = String($nXValue)
	$sYValue = String($nYValue)
	$sFreeValue = String($nFreeValue)
	If StringLeft($sYValue,1) <> "-" Then $sYValue = "+" & $sYValue
	If StringLeft($sFreeValue,1) <> "-" Then $sFreeValue = "+" & $sFreeValue
	$avEquation[0] = $sXValue & "x" & $sYValue & "y" & $sFreeValue & "=0"
	$avEquation[1] = $nXValue
	$avEquation[2] = $nYValue
	$avEquation[3] = $nFreeValue
	Return $avEquation
EndFunc   ;==>_StraightLineEquationDetBy2Points

Func _DistanceFromPointToStraightLine($anPoint,$avEquation)
	Local $nDistance
	If Not IsArray($anPoint) Or Not IsArray($avEquation) Then
		SetError(1)
		Return -1
	ElseIf UBound($anPoint) <> 2 Or UBound($avEquation) <> 4 Then
		SetError(2)
		Return -1
	EndIf
	$nDistance = Abs(($avEquation[1]*$anPoint[0])+($avEquation[2]*$anPoint[1])+$avEquation[3])/Sqrt(($avEquation[1]^2)+($avEquation[2]^2))
	Return $nDistance
EndFunc   ;==>_DistanceFromPointToStraightLine

Func _AreaOfTriangleDetBy3Points($anPoint1,$anPoint2,$anPoint3)
	Local $nPositive, $nNegative, $nDelta
	Local $nArea
	If Not IsArray($anPoint1) Or Not IsArray($anPoint2) Or Not IsArray($anPoint3) Then
		SetError(1)
		Return 0
	ElseIf UBound($anPoint1) <> 2  Or UBound($anPoint2) <> 2 Or UBound($anPoint3) <> 2 Then
		SetError(2)
		Return 0		
	EndIf
	$nPositive = ($anPoint1[0]*$anPoint2[1])+($anPoint1[1]*$anPoint3[0])+($anPoint2[0]*$anPoint3[1])
	$nNegative = -(($anPoint2[1]*$anPoint3[0])+($anPoint1[1]*$anPoint2[0])+($anPoint1[0]*$anPoint3[1]))
	$nDelta = $nPositive + $nNegative
	MsgBox(0,"",$nDelta)
	$nArea = (1/2)*Abs($nDelta)
	Return $nArea
EndFunc   ;==>_AreaOfTriangleDetBy3Points