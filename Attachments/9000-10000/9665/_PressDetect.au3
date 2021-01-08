#include-once
#include <Array.au3>

Local $szTemp_ControlID, $PressDetectArray[1], $szTemp_PressInfo, $szTemp_Found = 0, $PressActive = 0, $szGlobal_I = -100, $sz_Temp[2]



Func _PressDetectAddCtrl($szTemp_ControlID)
	_ArrayAdd($PressDetectArray, $szTemp_ControlID)
EndFunc

Func _PressDetect()
	$szTemp_PressInfo = GUIGetCursorInfo()
	If Not IsArray($szTemp_PressInfo) Then Return 0
	For $i = 1 To UBound($PressDetectArray)-1
		If $szTemp_PressInfo[4] = $PressDetectArray[$i] And $szTemp_PressInfo[2] = 1 Then
			$szTemp_Found = $i
		EndIf
	Next
	Select
		Case $szTemp_Found = 0 And $PressActive = 1
			$PressActive = 0
			$sz_Temp[0] = "ButtonUnPressed"
			$sz_Temp[1] = $PressDetectArray[$szGlobal_I]
			$szTemp_Found = 0
			Return $sz_Temp
		Case $szTemp_Found > 0 And $PressActive = 0
			$szGlobal_I = $szTemp_Found
			$PressActive = 1
			$szTemp_Found = 0
			$sz_Temp[0] = "ButtonDePressed"
			$sz_Temp[1] = $PressDetectArray[$szGlobal_I]
			Return $sz_Temp
	EndSelect
	$szTemp_Found = 0
EndFunc