#NoTrayIcon
#include <GUIConstants.au3>

;/// Settings Here ///
$NumberOfGradients = 100
$SizeOfLayer = 2
;/////////////////////

GUICreate("Gradients", $NumberOfGradients*$SizeOfLayer, 70, -1, -1)
Dim $Label[$NumberOfGradients]
For $i = 0 To $NumberOfGradients-1
	$Label[$i] = GUICtrlCreateLabel("", $i*$SizeOfLayer, 0, 10, 50)
Next
$Button = GUICtrlCreateButton("Random Gradient", 0, 50, $NumberOfGradients*$SizeOfLayer, 20)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button
			$Color = ColorGradient(RandomColor(), RandomColor(), $NumberOfGradients)
			For $i = 0 To $NumberOfGradients-1
				GUICtrlSetBkColor($Label[$i], $Color[$i])
			Next
	EndSwitch
WEnd

Func ColorGradient($hInitialColor, $hFinalColor, $iReturnSize)
	$hInitialColor = Hex($hInitialColor, 6)
	$hFinalColor = Hex($hFinalColor, 6)
	
	Local $iRed1 = Dec (StringLeft($hInitialColor, 2))
	Local $iGreen1 = Dec (StringMid($hInitialColor, 3, 2))
	Local $iBlue1 = Dec (StringMid($hInitialColor, 5, 2))
	
	Local $iRed2 = Dec (StringLeft($hFinalColor, 2))
	Local $iGreen2 = Dec (StringMid($hFinalColor, 3, 2))
	Local $iBlue2 = Dec (StringMid($hFinalColor, 5, 2))
	
	Local $iPlusRed = ($iRed2-$iRed1)/($iReturnSize-1)
	Local $iPlusBlue = ($iBlue2-$iBlue1)/($iReturnSize-1)
	Local $iPlusGreen = ($iGreen2-$iGreen1)/($iReturnSize-1)
	
	Dim $iColorArray[$iReturnSize]
	For $i = 0 To $iReturnSize-1
		$iNowRed = Floor($iRed1 + ($iPlusRed*$i))
		$iNowBlue = Floor($iBlue1 + ($iPlusBlue*$i))
		$iNowGreen = Floor($iGreen1 + ($iPlusGreen*$i))
		$iColorArray[$i] = Dec (Hex($iNowRed, 2) & Hex($iNowGreen, 2) & Hex($iNowBlue, 2))
	Next
	Return ($iColorArray)
EndFunc
Func RandomColor($hMinColor = 0x000000, $hMaxColor = 0xFFFFFF)
	$hMinColor = Hex($hMinColor, 6)
	$hMaxColor = Hex($hMaxColor, 6)
	
	Local $iRed1 = Dec (StringLeft($hMinColor, 2))
	Local $iGreen1 = Dec (StringMid($hMinColor, 3, 2))
	Local $iBlue1 = Dec (StringMid($hMinColor, 5, 2))
	
	Local $iRed2 = Dec (StringLeft($hMaxColor, 2))
	Local $iGreen2 = Dec (StringMid($hMaxColor, 3, 2))
	Local $iBlue2 = Dec (StringMid($hMaxColor, 5, 2))
	
	Local $iRndRed = Random($iRed1, $iRed2, 1)
	Local $iRndGreen = Random($iGreen1, $iGreen2, 1)
	Local $iRndBlue = Random($iBlue1, $iBlue2, 1)
	
	Return Dec (Hex($iRndRed, 2) & Hex($iRndGreen, 2) & Hex($iRndBlue, 2))
EndFunc	