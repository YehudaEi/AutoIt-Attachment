;======================================================================================
;
; Function Name:    _PixelGetColorMouse()
; Description:      Returns Color in dec or hex from mouse position.
; Parameter(s):     $iHex  - Optional. If set to 1 hex will be returned.                  
; Requirement(s):   Include PGCMouse.au3
; Return Value(s):  Colour of the pixel at mouse position in dec or hex. 
; Author(s):        Christoph Krogmann <ch.krogmann@gmx.de>
;
;======================================================================================
;
Func _PixelGetColorMouse($iHex = 0)
	Local $iPos
    Local $iColor
    $iPos = MouseGetPos()
    $iColor = PixelGetColor($iPos[0] ,$iPos[1])
    If $iHex = 0 Then
		Return $iColor
	ElseIf $iHex = 1 Then
		Return "0x" & Hex($iColor, 6)
	EndIf	
EndFunc	;==>_PixelGetColorMouse
