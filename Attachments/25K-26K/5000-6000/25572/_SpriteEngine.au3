#include <array.au3>

Local $hGui
Local $iInitialized = 0
Local $aSprites[100]
Local $running = 1
#CS[0] - handle
	[1] - x
	[2] - y
	[3] - speed
	[4] - angle
	[5] - GuiIsSolid
	[6] - Follow mouse
#CE
$aSprites[0] = 0

Func _SpriteInit($hGuiHandle, $iNumberOfSprites = 100, $iFps = 60)
	$hGui = $hGuiHandle
	$aPosTest = WinGetPos($hGui)
	If IsArray($aPosTest) = 0 Then
		SetError(1)
		Return 0
	EndIf
	ReDim $aSprites[$iNumberOfSprites + 1][7]
	$aSprites[0][0] = $iNumberOfSprites
	$running = 1
	AdlibEnable("_SpriteUpdate", 1000 / $iFps)
	Return 1
EndFunc   ;==>_SpriteInit

Func _SpriteRunning($iRunning)
	$running = $iRunning
EndFunc   ;==>_SpriteRunning

Func _SpriteCreate($sPicFilePath, $iX, $iY, $iWidth = "", $iHeight = "", $vStyle = "", $vExStyle = "")
	Local $iIndex
	For $i = 0 To $aSprites[0][0]
		If $aSprites[$i][0] = "" Then
			$iIndex = $i
		EndIf
	Next
	If $iIndex = "" Then
		SetError(2)
		Return 0
	EndIf
	$aSprites[$iIndex][0] = GUICtrlCreatePic($sPicFilePath, $iX, $iY, $iWidth, $iHeight, $vStyle, $vExStyle)
	If $aSprites[$iIndex][0] = 0 Then
		$aSprites[$iIndex][0] = ""
		SetError(1)
		Return 0
	EndIf
	$aSprites[$iIndex][1] = $iX
	$aSprites[$iIndex][2] = $iY
	$aSprites[$iIndex][3] = 0
	$aSprites[$iIndex][4] = 0
	$aSprites[$iIndex][5] = 1
	Return $iIndex
EndFunc   ;==>_SpriteCreate
Func _SpriteDelete($hHandle)
	GUICtrlDelete($aSprites[$hHandle][0])
	$aSprites[$hHandle][0] = ""
	Return 1
EndFunc   ;==>_SpriteDelete
Func _SpriteSetMovement($hHandle, $iSpeed, $iAngle)
	If $aSprites[$hHandle][0] = "" Then
		SetError(1)
		Return 0
	EndIf
	$aSprites[$hHandle][3] = $iSpeed
	$aSprites[$hHandle][4] = $iAngle
	Return 1
EndFunc   ;==>_SpriteSetMovement
Func _SpriteUpdate()
	If $running <> 1 Then
		Return
	EndIf
	$aSize = WinGetPos($hGui)
	$iGUIWidth = $aSize[2]
	$iGUIHeight = $aSize[3]
	For $i = 1 To $aSprites[0][0]
		If $aSprites[$i][0] = "" Then
			ContinueLoop
		EndIf
		if $aSprites[$i][6] = 1 Then
;~ 			MsgBox(0,"","")
			$coords = GUIGetCursorInfo($hGui)
			$aSprites[$i][1] = $coords[0]
			GUICtrlSetPos($aSprites[$i][0], $aSprites[$i][1], $aSprites[$i][2])
			ContinueLoop
		EndIf
		$aSize = ControlGetPos($hGui, "", $aSprites[$i][0])
;~ 		_ArrayDisplay($size)
		If IsArray($aSize) Then
			$iSpriteWidth = $aSize[2]
			$iSpriteHeight = $aSize[3]
			$aSize = 0
			$coords = Angle($aSprites[$i][1], $aSprites[$i][2], $aSprites[$i][4], $aSprites[$i][3])
			GUICtrlSetPos($aSprites[$i][0], $coords[0], $coords[1])
			$aSprites[$i][1] = $coords[0]
			$aSprites[$i][2] = $coords[1]
			If $aSprites[$i][5] = 1 Then
				If ($aSprites[$i][1] > $iGUIWidth - $iSpriteWidth Or $aSprites[$i][1] < 0) Then
					$aSprites[$i][4] = 360 - $aSprites[$i][4]
				EndIf
				If ($aSprites[$i][2] >= $iGUIHeight + $iSpriteHeight Or $aSprites[$i][2] >= $iGUIHeight Or $aSprites[$i][2] <= 0) Then
					$aSprites[$i][4] = 180 - $aSprites[$i][4]
;~ 					$aSprites[$i][4] *=-1
;~ 					MsgBox(0,"","Change")
				EndIf
			EndIf
		EndIf
	Next
EndFunc   ;==>_SpriteUpdate
Func _SpriteSetCoords($hHandle, $iX, $iY)
	$aSprites[$hHandle][1] = $iX
	$aSprites[$hHandle][2] = $iY
EndFunc   ;==>_SpriteSetCoords
Func _SpriteCheckCollision($hHandle1, $hHandle2)
	If ($aSprites[$hHandle1][1] <= $aSprites[$hHandle2][1] Or $aSprites[$hHandle1][1] <= $aSprites[$hHandle2][1] + 10) And ($aSprites[$hHandle1][1] + 50 >= $aSprites[$hHandle2][1] Or $aSprites[$hHandle1][1] + 50 >= $aSprites[$hHandle2][1] + 10) Then
		ConsoleWrite("XCollision" & " " & TimerInit() & @CRLF)
		If ($aSprites[$hHandle1][2] <= $aSprites[$hHandle2][2] Or $aSprites[$hHandle1][2] <= $aSprites[$hHandle2][2] + 10) And ($aSprites[$hHandle1][2] + 10 >= $aSprites[$hHandle2][2] Or $aSprites[$hHandle1][2] + 10 >= $aSprites[$hHandle2][2] + 10) Then
			ConsoleWrite("YCollision" & " " & TimerInit() & @CRLF)
			Return 1
		EndIf
	EndIf
	Return 0
EndFunc   ;==>_SpriteCheckCollision
Func _SpriteGetCoords($hHandle)
	Local $Return[2]
	$Return[0] = $aSprites[$hHandle][1]
	$Return[1] = $aSprites[$hHandle][2]
	Return $Return
EndFunc   ;==>_SpriteGetCoords
Func _SpriteGetSize($hHandle)
	$pos = ControlGetPos($hGui, "", $aSprites[$hHandle][0])
	Local $Return[2]
	$Return[0] = $pos[2]
	$Return[1] = $pos[3]
	Return $Return
EndFunc   ;==>_SpriteGetSize
Func _SpriteFollowMouse($hHandle,$iFollowMouse)
	$aSprites[$hHandle][6] = $iFollowMouse
EndFunc
Func _SpriteGetMovement($hHandle)
	Local $Return[2]
	$Return[0] = $aSprites[$hHandle][3]
	$Return[1] = $aSprites[$hHandle][4]
	Return $Return
EndFunc   ;==>_SpriteGetMovement
Func Angle($x1, $y1, $angle, $length)
	Local $Return[2]
	$Return[0] = $x1 + ($length * Sin($angle * 3.14159 / 180))
	$Return[1] = $y1 - ($length * Cos($angle * 3.14159 / 180))
	Return $Return
EndFunc   ;==>Angle