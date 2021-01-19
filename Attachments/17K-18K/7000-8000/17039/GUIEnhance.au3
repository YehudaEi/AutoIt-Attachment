#include-once
#include <string.au3>
#include <array.au3>

Global Enum $GUI_EN_TITLE_SLIDE, $GUI_EN_TITLE_DROP, $GUI_EN_TITLE_BLINK

;thanks to raindancer for these
Global Const $GUI_EN_ANI_FADEIN = 0x80000
Global Const $GUI_EN_ANI_FADEOUT = 0x90000
Global Const $GUI_EN_ANI_FROM_LEFT = 0x40001
Global Const $GUI_EN_ANI_FROM_RIGHT = 0x40002
Global Const $GUI_EN_ANI_FROM_TOP = 0x40004
Global Const $GUI_EN_ANI_FROM_BOTTOM = 0x40008
Global Const $GUI_EN_ANI_FROM_TOPLEFT = 0x40005
Global Const $GUI_EN_ANI_FROM_TOPRIGHT = 0x40006
Global Const $GUI_EN_ANI_FROM_BOTTOMLEFT = 0x40009
Global Const $GUI_EN_ANI_FROM_BOTTOMRIGHT = 0x4000A
Global Const $GUI_EN_ANI_TO_LEFT = 0x50002
Global Const $GUI_EN_ANI_TO_RIGHT = 0x50001
Global Const $GUI_EN_ANI_TO_TOP = 0x50008
Global Const $GUI_EN_ANI_TO_BOTTOM = 0x50004
Global Const $GUI_EN_ANI_TO_TOPLEFT = 0x5000A
Global Const $GUI_EN_ANI_TO_TOPRIGHT = 0x50009
Global Const $GUI_EN_ANI_TO_BOTTOMLEFT = 0x50006
Global Const $GUI_EN_ANI_TO_BOTTOMRIGHT = 0x50005
Global Const $GUI_EN_ANI_EXPLODE = 0x40010
Global Const $GUI_EN_ANI_IMPLODE = 0x50010

;===============================================================================
;
; Function Name:   _GUIEnhanceAnimateWin
; Description::    Animates a window when showing/hiding
; Parameter(s):    $hWnd - Window Handle
;				   $iTimeMs - Length of animation in ms
;				   $iType - $GUI_EN_ANI_* constant
; Requirement(s):  None
; Return Value(s): 0, @error = 1 - AnimateWindow Error
;				   1 - Success
; Author(s):       RazerM
;
;===============================================================================
;
Func _GUIEnhanceAnimateWin($hWnd, $iTimeMs, $iType)
	Local $aRet = DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hWnd, "int", $iTimeMs, "long", $iType)
	If $aRet[0] = 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GUIEnhanceAnimateWin

;===============================================================================
;
; Function Name:   _GUIEnhanceAnimateTitle
; Description::    Animates the title of a window
; Parameter(s):    $hWnd - Window Handle
;				   $sTitle - new title of window
;				   $iType - $GUI_EN_TITLE_* constant this is animation type
;				   $vParam1 - See below
;				   $vParam2 - See below
; Requirement(s):  None
; Return Value(s): 0, @error = 1 - Window doesn't exist
;				   0, @error = 2 - $vParam1 or $vParam2 are invalid
;				   0, @error = 3 - Invalid $GUI_EN_TITLE_* constant
;				   1 - Successful
; Author(s):       RazerM
;
;===============================================================================
;
; $GUI_EN_TITLE_SLIDE
; | First character of title slides in from right of caption,
; | characters then build up to title.
; | $vParam1 - how far right first char is (default = 100)
; | $vParam2 - character used to position first char sliding in (default = " ")
;
; $GUI_EN_TITLE_DROP
; | Characters of title drop in, replacing a character at their position
; | set by $vParam1
; | $vParam1 - character that title chars "drop" on to (default = "_")
; | $vParam2 - Sleep  between each character drop (default = 50)
;
; $GUI_EN_TITLE_BLINK
; | Whole title blinks from title to blank a certain number of times
; | $vParam1 - Number of times to blink on and off (default = 5)
; | $vParam2 - Delay between each title change (default = 200)
;
;===============================================================================
;
Func _GUIEnhanceAnimateTitle($hWnd, $sTitle, $iType = 0, $vParam1 = Default, $vParam2 = Default)
	If Not WinExists($hWnd) Then Return SetError(1, 0, 0)
	Switch $iType
		Case $GUI_EN_TITLE_SLIDE
			Local $sStr, $iCounter, $iBuf = $vParam1, $asTitle, $sStartChr = $vParam2
			If $vParam1 = Default Then $iBuf = 100
			If $vParam2 = Default Then $sStartChr = " "
			;validate buffer length
			If Not IsInt($iBuf) Then Return SetError(2, 0, 0)
			;split the title into a useable array
			$asTitle = StringSplit($sTitle, "")
			;set the title to $iCounter spaces and first letter of title
			;$iCounter decreases by 1 each loop
			For $iCounter = $iBuf To 0 Step - 1
				WinSetTitle($hWnd, "", _StringRepeat($sStartChr, $iCounter) & $asTitle[1])
			Next
			Local $sStr
			;add a character from the title each loop
			For $iCounter = 1 To $asTitle[0]
				$sStr &= $asTitle[$iCounter]
				WinSetTitle($hWnd, "", $sStr)
				Sleep(5)
			Next
			Return 1
		Case $GUI_EN_TITLE_DROP
			Local $asTitle = StringSplit($sTitle, ""), $iCounter
			Local $aiPlaced[$asTitle[0] + 1], $iCompleteTest = 0
			Local $iRand, $sTemp, $sStartChr = $vParam1, $iSleep = $vParam2
			If $vParam1 = Default Then $sStartChr = "_"
			If $vParam2 = Default Then $iSleep = 50
			If StringLen($sStartChr) <> 1 Then Return SetError(2, 0, 0)
			;set title to correct number of characters
			WinSetTitle($hWnd, "", _StringRepeat($sStartChr, $asTitle[0]))
			Do
				;create a random number
				Do
					$iRand = Random(1, $asTitle[0], 1)
				Until $aiPlaced[$iRand] = 0
				;fill that space with the letter
				$sTemp = StringLeft(WinGetTitle($hWnd), $iRand - 1)
				$sTemp &= $asTitle[$iRand]
				$sTemp &= StringRight(WinGetTitle($hWnd), $asTitle[0] - $iRand)
				WinSetTitle($hWnd, "", $sTemp)
				$aiPlaced[$iRand] = 1
				$iCompleteTest = 0
				For $iCounter = 1 To $asTitle[0]
					$iCompleteTest += $aiPlaced[$iCounter]
				Next
				Sleep($iSleep)
			Until $iCompleteTest = $asTitle[0]
			Return 1
		Case $GUI_EN_TITLE_BLINK
			Local $asTitle = StringSplit($sTitle, ""), $iCounter
			Local $iBlink = $vParam1, $iDelay = $vParam2
			If $vParam1 = Default Then $iBlink = 5
			If $vParam2 = Default Then $iDelay = 200
			If Not IsNumber($iBlink) Then Return SetError(2, 0, 0)
			If Not IsNumber($iDelay) Then Return SetError(2, 0, 0)
			For $iCounter = 1 To $iBlink
				WinSetTitle($hWnd, "", "")
				Sleep($iDelay)
				WinSetTitle($hWnd, "", $sTitle)
				Sleep($iDelay)
			Next
			Return 1
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
EndFunc   ;==>_GUIEnhanceAnimateTitle

;===============================================================================
;
; Function Name:   _GUIEnhanceScaleWin
; Description::    Resizes a window in steps, to create a smooth transition
; Parameter(s):    $hWnd - Window Handle
;				   $iNewWidth - Pixels to add to size (-ve to size down, Default for no resize)
;				   $iNewHeight [optional] - Same as $iNewWidth (above)
;				   $fCenter [optional] - If True, gui centres relative to previous position
;				   $iStep [optional] - Number of steps to resize window in (default = 10)
;				   $iSleep [optional] - Ms to sleep before each "step"
; Requirement(s):  None
; Return Value(s): 0, @error = 1 - Window doesn't exist
;				   1 - Successful
; Author(s):	   RazerM
;
;===============================================================================
;
Func _GUIEnhanceScaleWin($hWnd, $iNewWidth, $iNewHeight = Default, $fCenter = True, $iStep = 10, $iSleep = 10)
	If Not WinExists($hWnd) Then Return SetError(1, 0, 0)
	Local $aiWinPos = WinGetPos($hWnd), $iHeightDiff, $iStepGain, $iLastStep
	If $iNewWidth = Default Then $iNewWidth = 0
	If $iNewHeight = Default Then $iNewHeight = 0
	$iNewWidth += $aiWinPos[2]
	$iNewHeight += $aiWinPos[3]
	If $iNewWidth = $aiWinPos[2] And $iNewHeight = $aiWinPos[3] Then Return 1
	Local $iWidthDiff = Abs($iNewWidth - $aiWinPos[2])
	Local $iHeightDiff = Abs($iNewHeight - $aiWinPos[3])
	Local $aiStepGain[2] = [Int($iWidthDiff / $iStep), Int($iHeightDiff / $iStep) ]
	Local $aiLastStep[2] = [$iWidthDiff - $aiStepGain[0] * ($iStep - 1), $iHeightDiff - $aiStepGain[1] * ($iStep - 1) ]
	If $iNewWidth < $aiWinPos[2] Then
		$aiStepGain[0] *= -1
		$aiLastStep[0] *= -1
	EndIf
	If $iNewHeight < $aiWinPos[3] Then
		$aiStepGain[1] *= -1
		$aiLastStep[1] *= -1
	EndIf
	For $i = 1 To $iStep - 1
		If $fCenter Then
			$aiWinPos[0] -= Int($aiStepGain[0] / 2)
			If $aiWinPos[0] < 0 Then $aiWinPos[0] = 0
			$aiWinPos[1] -= Int($aiStepGain[1] / 2)
			If $aiWinPos[1] < 0 Then $aiWinPos[1] = 0
		EndIf
		$aiWinPos[2] += $aiStepGain[0]
		$aiWinPos[3] += $aiStepGain[1]
		WinMove($hWnd, "", $aiWinPos[0], $aiWinPos[1], $aiWinPos[2], $aiWinPos[3])
		Sleep($iSleep)
	Next
	If $fCenter And $aiWinPos[0] >= Int($aiStepGain[0] / 2) And $aiWinPos[1] >= Int($aiStepGain[1] / 2) Then
		$aiWinPos[0] -= Int($aiLastStep[0] / 2)
		If $aiWinPos[0] < 0 Then $aiWinPos[0] = 0
		$aiWinPos[1] -= Int($aiLastStep[1] / 2)
		If $aiWinPos[1] < 0 Then $aiWinPos[1] = 0
	EndIf
	WinMove($hWnd, "", $aiWinPos[0], $aiWinPos[1], $aiWinPos[2] + $aiLastStep[0], $aiWinPos[3] + $aiLastStep[1])
	Return 1
EndFunc   ;==>_GUIEnhanceScaleWin

;===============================================================================
;
; Function Name:   _GUIEnhanceCtrlFade
; Description::    Fades a controls foreground and/or background colours
; Parameter(s):    $Ctrl - Control id
;				   $iTime - Ms of transition
;				   $fColor - If true, fade foreground colour
;				   $fBkColor - If true, fade background colour
;				   $iStartColor - Start colour
;				   $iEndColor - End colour
;				   $iStep [optional] - how many different colour changes between start and end colours
; Requirement(s):  None
; Return Value(s): 0, @error = 1 - Both boolean values are false
;				   1 - Success
; Author(s):	   RazerM
;
;===============================================================================
;
Func _GUIEnhanceCtrlFade($Ctrl, $iTime, $fColor, $fBkColor, $iStartColor, $iEndColor, $iStep = 25)
	If Not $fColor And Not $fBkColor Then Return SetError(1, 0, 0)
	If Not IsArray($Ctrl) Then
		Local $aCtrl[1] = [$Ctrl]
	Else
		Local $aCtrl = $Ctrl
	EndIf
	Local $aiGradient = __ColorGradient($iStartColor, $iEndColor, $iStep)
	For $iCounter = 1 To $iStep
		For $i = 0 To UBound($aCtrl) - 1
			If $fColor Then GUICtrlSetColor($aCtrl[$i], $aiGradient[$iCounter - 1])
			If $fBkColor Then GUICtrlSetBkColor($aCtrl[$i], $aiGradient[$iCounter - 1])
		Next
		Sleep($iTime / $iStep)
	Next
	Return 1
EndFunc   ;==>_GUIEnhanceCtrlFade

;===============================================================================
;
; Function Name:   _GUIEnhanceCtrlDrift
; Description::    Moves a control to ($iX, $iY) in a smooth manner
; Parameter(s):	   $hWnd - Window Handle
;				   $Ctrl - control id
;				   $iX - x pos to move to
;				   $iY - y pos to move to
;				   $iStep - number of pixels to move each step
; Requirement(s):  None
; Return Value(s): 0, @error = 1 - Window doesn't exist
;				   1 - Success
; Author(s):	   RazerM
; Note(s):		   Based on Bresenham's line drawing algorithm
;				   http://www.falloutsoftware.com/tutorials/dd/dd4.htm
;
;===============================================================================
;
Func _GUIEnhanceCtrlDrift($hWnd, $Ctrl, $iX, $iY, $iStep = 1)
	If Not WinExists($hWnd) Then Return SetError(1, 0, 0)
	Local $aOldPos = ControlGetPos($hWnd, "", $Ctrl)
	Local $iXOld = $aOldPos[0]
	Local $iYOld = $aOldPos[1]
	Local $fSteep = Abs($iY - $iYOld) > Abs($iX - $iXOld)
	Local $aPoints[1][2]
	Local $iOldX = $iX, $iOldY = $iY, $iYVal, $iYStep
	Local $iDeltaX, $iDeltaY, $iError, $iDeltaError
	If $fSteep Then
		__Swap($iXOld, $iYOld)
		__Swap($iX, $iY)
	EndIf
	If $iXOld > $iX Then
		__Swap($iXOld, $iX)
		__Swap($iYOld, $iY)
	EndIf
	$iDeltaX = $iX - $iXOld
	$iDeltaY = Abs($iY - $iYOld)
	$iError = 0
	$iDeltaError = $iDeltaY / $iDeltaX
	$iYVal = $iYOld
	If $iYOld < $iY Then
		$iYStep = 1
	Else
		$iYStep = -1
	EndIf
	For $iXVal = $iXOld To $iX
		If $fSteep Then
			ReDim $aPoints[UBound($aPoints) + 1][2]
			$aPoints[UBound($aPoints) - 1][0] = $iYVal
			$aPoints[UBound($aPoints) - 1][1] = $iXVal
		Else
			ReDim $aPoints[UBound($aPoints) + 1][2]
			$aPoints[UBound($aPoints) - 1][0] = $iXVal
			$aPoints[UBound($aPoints) - 1][1] = $iYVal
		EndIf
		$iError = $iError + $iDeltaError
		If $iError >= 0.5 Then
			$iYVal = $iYVal + $iYStep
			$iError = $iError - 1
		EndIf
	Next
	If $aPoints[1][0] = $iOldX And $aPoints[1][1] = $iOldY Then
		For $iPoint = UBound($aPoints) - 1 To 1 Step $iStep * - 1
			ControlMove($hWnd, "", $Ctrl, $aPoints[$iPoint][0], $aPoints[$iPoint][1])
			Sleep(1)
		Next
		ControlMove($hWnd, "", $Ctrl, $aPoints[1][0], $aPoints[1][1])
	Else
		For $iPoint = 1 To UBound($aPoints) - 1 Step $iStep
			ControlMove($hWnd, "", $Ctrl, $aPoints[$iPoint][0], $aPoints[$iPoint][1])
			Sleep(1)
		Next
		ControlMove($hWnd, "", $Ctrl, $aPoints[UBound($aPoints) - 1][0], $aPoints[UBound($aPoints) - 1][1])
	EndIf
	Return 1
EndFunc   ;==>_GUIEnhanceCtrlDrift

Func __Swap(ByRef $va, ByRef $vb)
	Local $vTemp
	$vTemp = $va
	$va = $vb
	$vb = $vTemp
EndFunc   ;==>__Swap

;CoePSX - Thanks!
Func __ColorGradient($hInitialColor, $hFinalColor, $iReturnSize)
	Local $iNowRed, $iNowBlue, $iNowGreen
	$hInitialColor = Hex($hInitialColor, 6)
	$hFinalColor = Hex($hFinalColor, 6)

	Local $iRed1 = Dec(StringLeft($hInitialColor, 2))
	Local $iGreen1 = Dec(StringMid($hInitialColor, 3, 2))
	Local $iBlue1 = Dec(StringMid($hInitialColor, 5, 2))

	Local $iRed2 = Dec(StringLeft($hFinalColor, 2))
	Local $iGreen2 = Dec(StringMid($hFinalColor, 3, 2))
	Local $iBlue2 = Dec(StringMid($hFinalColor, 5, 2))

	Local $iPlusRed = ($iRed2 - $iRed1) / ($iReturnSize - 1)
	Local $iPlusBlue = ($iBlue2 - $iBlue1) / ($iReturnSize - 1)
	Local $iPlusGreen = ($iGreen2 - $iGreen1) / ($iReturnSize - 1)

	Dim $iColorArray[$iReturnSize]
	For $i = 0 To $iReturnSize - 1
		$iNowRed = Floor($iRed1 + ($iPlusRed * $i))
		$iNowBlue = Floor($iBlue1 + ($iPlusBlue * $i))
		$iNowGreen = Floor($iGreen1 + ($iPlusGreen * $i))
		$iColorArray[$i] = Dec(Hex($iNowRed, 2) & Hex($iNowGreen, 2) & Hex($iNowBlue, 2))
	Next
	Return $iColorArray
EndFunc   ;==>__ColorGradient