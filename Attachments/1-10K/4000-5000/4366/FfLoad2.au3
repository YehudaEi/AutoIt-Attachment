;======================================================================================
;
; Function Name:    _FfLoadWaitTime()
; Description:      Pauses the script until Firefox finished loading. Max. 30 sec.
; Parameter(s):     $x  - The X coordinate of the Blue loading bar.
;                   $y  - The Y coordinate of the Blue loading bar.
;                   $c  - PixelCoordMode
;                         0 = relative coords to the active window
;                         1 = absolute screen coordinates (default)
;                         2 = relative coords to the client area of the active window
; Requirement(s):   Include FfLoad.au3
; Return Value(s):  If loading is not finished in 30 sec the Return is 1 else Return is 0. 
; Author(s):        Christoph Krogmann <ch.krogmann@gmx.de>
; Note(s):          During search for the coordinate, choose a point at the left
;                   side of the loading bar!
;
;======================================================================================
;
Func _FfLoadWaitTime ($x, $y, $c)
	Opt("PixelCoordMode", $c)
	Local $i
	Local $iColor
	Local $isec = @SEC
	Local $istop
	If $isec < 30 Then $istop = $isec + 30
	If $isec = 30 Then $istop = $isec - 29
	If $isec > 30 Then $istop = $isec - 30	
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 664682 Then
			$i = 1
	    Else
		Endif
	    Sleep(20)
    Until $i = 1
	Do
		$isec = @SEC
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 664682 Then
			If $isec = $istop Then
				$i = 2
				Return 1
			EndIf	
		Else
            $i = 2
			Return 0
        Endif
	    Sleep(20)
	Until $i = 2	
EndFunc	;==>_FfLoadWaitTime