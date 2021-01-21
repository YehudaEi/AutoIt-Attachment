#cs										#
	AutoIt bit operations visualiser v1
	by Siao
#ce										#

#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

Opt("GUIOnEventMode", 1)
;~ Opt("MustDeclareVars", 1)

Global $hGui, $cInput, $cResult, $cCalc, $cArrowDown, $cArrowUp, $cBtnDo, $cLbl
Global $aArrowDown[16] = [1,15,16,30,31,15,25,15,25,1,8,1,8,15,1,15]
Global $aArrowUp[16] = [1,15,16,0,31,15,25,15,25,30,8,30,8,15,1,15]

$hGui = GUICreate("AutoIt BitOps Visualizer", 400, 250, -1, -1, -1, -1)
GUISetOnEvent(-3, "SysEvents")
$cInput = GUICtrlCreateInput("", 20, 40, 186, 32)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetData(-1, 'BitAnd(3, 2)')
$cResult = GUICtrlCreateInput("", 280, 40, 100, 32)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$cCalc = GUICtrlCreateEdit("", 10, 108, 380, 120, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
GUICtrlSetFont(-1, 10, 800, 0, "Courier New")
$cArrowDown = GUICtrlCreateGraphic(60, 74, 32, 32)
_GraphicDrawLines($cArrowDown, $aArrowDown, 2, 0xbbaabb)
$cArrowUp = GUICtrlCreateGraphic(308, 75, 32, 32)
_GraphicDrawLines($cArrowUp, $aArrowUp, 2, 0xbbaabb)
$cBtnDo = GUICtrlCreateButton("=", 220, 40, 50, 30)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "_BitWisor")
$cLbl = GUICtrlCreateLabel('Enter expression and press "=" to calculate.', 20, 10, 250, 20)

GUISetState()
While 1
	Sleep(1000)
WEnd

Func SysEvents()
	Switch @GUI_CtrlId
		Case -3
			Exit
	EndSwitch
EndFunc
Func _BitWisor()
	Local $sRez = "", $sError = "", $sInput = GUICtrlRead($cInput), $aInput, $sOp, $sCalc, $i=0, $aTmp, $sTmp
	$aInput = StringRegExp($sInput, '\A[[:blank:]]*([[:alpha:]]+)[[:blank:]]*\((.+)\)', 1)
	If @error Then
		$sError = 'Invalid expression, foo!'
	Else
		$sInput = $aInput[0] & '(' & $aInput[1] & ')'
		GUICtrlSetData($cInput, $sInput)
		$sOp = StringUpper(StringTrimLeft($aInput[0], 3))
		$sRez = Execute($sInput)
		If @error Then
			$sError = 'Invalid expression, foo!'
		Else
			Switch $aInput[0]
				Case "bitand", "bitor", "bitxor"
					$aTmp = _SplitParams($aInput[1])
					For $i = 1 To $aTmp[0]
						$sTmp &= _HexToBinBase(Execute($aTmp[$i])) & '   0x' & Hex(Execute($aTmp[$i])) & @CRLF & Chr(1) & @CRLF
						$sCalc = StringReplace(StringTrimRight($sTmp, 3), Chr(1), $sOp) & _
								"=" & @CRLF & _
								_HexToBinBase($sRez) & '   0x' & Hex($sRez) & @CRLF							
					Next		
				Case "bitnot"
					$sCalc = 	_HexToBinBase(Execute($aInput[1])) & '   0x' & Hex(Execute($aInput[1])) & @CRLF & _
								$sOp & @CRLF & _
								"=" & @CRLF & _
								_HexToBinBase($sRez) & '   0x' & Hex($sRez) & @CRLF	
				Case "bitshift"
					$aTmp = _SplitParams($aInput[1])
					If Execute($aTmp[2]) > 0 Then
						$sTmp = $sOp & " right by " & Execute($aTmp[2])
					ElseIf Execute($aTmp[2]) < 0 Then
						$sTmp = $sOp & " left by " & Abs(Execute($aTmp[2]))
					Else
						$sTmp = $sOp & " by 0"
					EndIf
					$sCalc = 	_HexToBinBase(Execute($aTmp[1])) & '   0x' & Hex(Execute($aTmp[1])) & @CRLF & _
								$sTmp & @CRLF & _
								"=" & @CRLF & _
								_HexToBinBase($sRez) & '   0x' & Hex($sRez) & @CRLF					
				Case "bitrotate"
					$sError = "BitRotate currently unsupported."
				Case Else
					$sError = "Not a bitwise operation."
			EndSwitch
		EndIf
	EndIf
	GUICtrlSetData($cResult, $sRez)
	If $sError <> "" Then
		GUICtrlSetData($cCalc, $sError)
	Else
		GUICtrlSetData($cCalc, $sCalc)
	EndIf
EndFunc
#cs _HexToBinBase()
	Converts a number to binary base string
#ce
Func _HexToBinBase($hex)
	Local $b = ""
	For $i = 1 To 32
		$b = BitAND($hex, 1) & $b
		$hex = BitShift($hex, 1)
	Next
	Return $b
EndFunc
#cs _SplitParams()
	Crappy AutoIt param string parser
	Should choke on quoted commas
	Returns StringSplit-like array
#ce
Func _SplitParams($sParams)
	Local $aParams, $i, $br1, $br2, $aRet[1]
	$aParams = StringSplit($sParams, ",")
	For $i = $aParams[0] To 1 Step -1
		StringReplace($aParams[$i], ")", "")
		$br1 = @extended
		StringReplace($aParams[$i], "(", "")
		$br2 = @extended
		If $br1 <> $br2 Then
			$aParams[$i-1] &= "," & $aParams[$i]
			$aParams[$i] = ""
		EndIf
	Next
	For $i = 1 To $aParams[0]
		If $aParams[$i] <> "" Then 
			Redim $aRet[UBound($aRet)+1]
			$aRet[UBound($aRet)-1] = $aParams[$i]
		EndIf
	Next
	$aRet[0] = UBound($aRet)-1
	Return $aRet
EndFunc
#cs _GraphicDrawLines()
	Draws lines, duh
	Params: $cID - control ID from GuiCtrlCreateGraphic
			$aCoords - 1D array containing coordinate pairs ( $a[0]=x0, $a[1]=y0, $a[2]=x1, $a[3]=y1, etc.)
			$iPenSize, $iColor, $iColorBk - line options
#ce
Func _GraphicDrawLines($cID, $aCoords, $iPenSize = 2, $iColor = 0, $iColorBk = -1)
	GUICtrlSetGraphic($cID, $GUI_GR_PENSIZE, $iPenSize)
	GUICtrlSetGraphic($cID, $GUI_GR_COLOR, $iColor, $iColorBk)
	GUICtrlSetGraphic($cID, $GUI_GR_MOVE, $aCoords[0], $aCoords[1])
	For $i = 2 To UBound($aCoords)-1 Step 2
		GUICtrlSetGraphic($cID, $GUI_GR_LINE, $aCoords[$i], $aCoords[$i+1])
	Next
EndFunc
