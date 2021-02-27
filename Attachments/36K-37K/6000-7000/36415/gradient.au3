; =======================================================================================
; Title .........: An essai on gradients
; Description ...: Fill a graphics control whith gradients
; Requirement(s).: Autoit 3.3.8.0
; Author(s) .....: Giovanni Rossati (El Condor)
; Version........: 0.1.1
; Date...........: 22 jan 2012
; Syntax.........: gradient([$clrStart=0x808080[,$clrEnd=0xFFFFFF[,$dir=0],$eff=1]]]])
; Parameters ....: $clrStart start Color
;				   $clrEnd end Color
;                  $sdir direction: 0 = Left to Right, 90 Top to Bottom
;                  $eff effect value from 0 to 1 for invert direction after $eff
; Return values .: none for now
; Modified.......:
; =======================================================================================
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Array.au3>    ; For _ArrayDisplay()
$clrStart = 0xff	; blue
$clrEnd = 0x00ff00	; green
Global $w,$h
$w = 350;
$h = 250;
$child = GUICreate("An essai on gradients",$w,$h)
GUICtrlCreateGraphic(0, 0, $w, $h)
Gradient($clrStart,$clrEnd,0,0.5)
Func Gradient($clrStart=0x808080,$clrEnd=0xFFFFFF,$dir=0,$eff=1)
	local $colorIncr[3]
	$colorStart = decodeColor($clrStart)
	$colorEnd = decodeColor($clrEnd)
	$aColorS = $colorStart
	;	x, y move; x,y line, limit
	$aGeo = StringSplit("0,0,0," & $h & "," & $w,",",2)
	; increments for x, y
	$aIncr = StringSplit("1,0,1,0",",",2)
	If $dir = 90 Then
		$aGeo = StringSplit("0,0," & $w & ",0," & $h,",",2)
		$aIncr = StringSplit("0,1,0,1",",",2)
	EndIf
	$colorIncr = stepColor($colorStart,$colorEnd,$aGeo[4]*$eff)
	For $i= 0 To $aGeo[4]
		$color = 65536*Round($colorStart[0])+256*Round($colorStart[1])+Round($colorStart[2])
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, Dec(StringMid(Hex($color),3)))
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $aGeo[0], $aGeo[1])
		GUICtrlSetGraphic(-1, $GUI_GR_LINE,  $aGeo[2], $aGeo[3])
		For $j=0 To 3	; increments
			$aGeo[$j] += $aIncr[$j]
		Next
		If $i = Int($eff * $aGeo[4]) Then	; change direction?
			$colorIncr = stepColor($colorEnd,$aColorS,$aGeo[4]*(1-$eff))
		EndIf
		For $j=0 To 2	; color step
			$colorStart[$j] += $colorIncr[$j]
		Next
	Next
	GUISetState()
Do
	$msg = GUIGetMsg()
Until $msg = $GUI_EVENT_CLOSE
EndFunc
Func decodeColor($cl)
	local $aCl[3]
	$aCl[0] = Floor($cl/65536)
	$aCl[1] = Floor(($cl - $aCl[0]* 65536)/256)
	$aCl[2] = $cl - $aCl[0]* 65536 - $aCl[1]* 256
	Return $aCl
EndFunc
Func stepColor($aCStart,$aCEnd,$interval)
	Local $aCIncr[3]
	For $i=0 To 2	; color step
		$aCIncr[$i] = ($aCEnd[$i] - $aCStart[$i])/ $interval
	Next
	return $aCIncr
EndFunc