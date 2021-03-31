;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf
#include-once
#include <Color.au3>
#include <WinAPIGdi.au3>
#include <Array.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <object_dump.au3>

OnAutoItExitRegister("_EXIT_BEFORE")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGui[9] = [0, "efeito", 310, 50, -1, -1, Default, $WS_EX_COMPOSITED, 0]

Global $aMouse, $hGui, $OVER
Global $SD = "Scripting.Dictionary"
Global $oo = ObjCreate($SD)
Global $hex

$aGui[0] = GUICreate($aGui[1], $aGui[2], $aGui[3], $aGui[4], $aGui[5], $aGui[6], $aGui[7], $aGui[8])
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
;~ GUISetBkColor(0x64C896, $aGui[0])

Local $h1 = GUICtrlCreateLabel("texto.1", 10, 10, 90, 30)
Local $h2 = GUICtrlCreateLabel("texto.2", 110, 10, 90, 30)
Local $h3 = GUICtrlCreateLabel("texto.3", 210, 10, 90, 30)

GUISetState(@SW_SHOW, $hGui)

Global $iColorOver = 0x00FF00
Global $iColorOverBackground = GUIGetBkColor($aGui[0])

Global $aColorOver = __TriColor(Hex($iColorOver, 6))
Global $aColorDefault = __TriColor(Hex($iColorOverBackground, 6))

Global $iIncrement = 5
Global $aSplit
Global $iTime =  20
Global $aRGB[3]

AdlibRegister("efeito", $iTime)



Func efeito()
	If $OVER And Not $oo.Exists($OVER) Then $oo.Add($OVER, Hex($aColorDefault[3]))
	For $each In $oo
		If $each == $OVER Then
			If Not ("0x" & $oo.Item($each) == $aColorOver[3]) Then
				$aSplit = __TriColor($oo.Item($each))
				For $ii = 0 To 2
					$aRGB[$ii] = comparar($aColorOver[$ii], $aSplit[$ii], $aRGB[$ii])
				Next
				$hex = Hex($aRGB[0], 2) & Hex($aRGB[1], 2) & Hex($aRGB[2], 2)
				$oo.Item($each) = $hex
				GUICtrlSetBkColor($each, "0x" & $hex)
			EndIf
		Else
			If Not ("0x" & $oo.Item($each) == $aColorDefault[3]) Then
				$aSplit = __TriColor($oo.Item($each))
				For $ii = 0 To 2
					$aRGB[$ii] = comparar($aColorDefault[$ii], $aSplit[$ii], $aRGB[$ii])
				Next
				$hex = Hex($aRGB[0], 2) & Hex($aRGB[1], 2) & Hex($aRGB[2], 2)
				$oo.Item($each) = $hex
				GUICtrlSetBkColor($each, "0x" & $hex)
			EndIf
		EndIf
	Next
EndFunc   ;==>efeito

Func comparar($FROM, $TO, $aRGB)
	ConsoleWrite("comparar( $FROM=" & $FROM & " , $TO=" & $TO & ", $aRGB=" & $aRGB & " )" & @LF)
	If Not ($FROM == $TO) Then
		If $FROM > $TO Then
			$aRGB = $TO + $iIncrement
			If $aRGB > $FROM Then $aRGB = $FROM
		Else
			$aRGB = $TO - $iIncrement
			If $aRGB < $FROM Then $aRGB = $FROM
		EndIf
	Else
		$aRGB = $FROM
	EndIf
	Return $aRGB
EndFunc   ;==>comparar

Func __TriColor($input)
;~ 	ConsoleWrite("__TriColor[ " & $input & " ] $Red[ " & $Red & " ] $Green[ " & $Green & " ] $Blue[ " & $Blue & " ]" & @LF)
	Local $arr[4] = [BitAND(BitShift("0x" & $input, 16), 0xFF), BitAND(BitShift("0x" & $input, 8), 0xFF), BitAND("0x" & $input, 0xFF), "0x" & $input]
	ConsoleWrite("__Tricolor( " & _ArrayToString($arr, ",") & " )" & @LF)
	Return $arr
EndFunc   ;==>__TriColor

; #FUNCTION# ====================================================================================================================
; Name ..........: GUIGetBkColor
; Description ...: Retrieves the RGB value of the GUI background.
; Syntax ........: GUIGetBkColor($hWnd)
; Parameters ....: $hWnd                - A handle of the GUI.
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func GUIGetBkColor($hWnd)
	Local $iColor = 0
	If IsHWnd($hWnd) Then
		Local $hDC = _WinAPI_GetDC($hWnd)
		$iColor = _WinAPI_GetBkColor($hDC)
		_WinAPI_ReleaseDC($hWnd, $hDC)
	EndIf
	Return $iColor
EndFunc   ;==>GUIGetBkColor

While Sleep(10)
	$aMouse = GUIGetCursorInfo($aGui[0])
	If @error Or Not $aMouse[4] Then
		$OVER = 0
	Else
		$OVER = $aMouse[4]
	EndIf
WEnd

Func _EXIT()
	Exit
EndFunc   ;==>_EXIT

Func _EXIT_BEFORE($sInput = 0)
	AdlibUnRegister("efeito")
	If IsDeclared("sInput") Then ConsoleWrite("_exit[ " & $sInput & " ]" & @LF)
	GUIDelete($aGui[0])
EndFunc   ;==>_EXIT_BEFORE
