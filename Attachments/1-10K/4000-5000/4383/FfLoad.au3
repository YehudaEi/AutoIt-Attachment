;======================================================================================
;
; Function Name:    _FfLoadWait()
; Description:      Pauses the script until Firefox finished loading.
; Parameter(s):     $x  - The X coordinate of the Blue loading bar.
;                   $y  - The Y coordinate of the Blue loading bar.
;                   $pcm  - PixelCoordMode
;                         0 = relative coords to the active window
;                         1 = absolute screen coordinates (default)
;                         2 = relative coords to the client area of the active window
;					$lbc  - Dec clour of the loading bar (optional) Default is standard 
;							bar colour.
; Requirement(s):   Include FfLoad.au3
; Return Value(s):  Nothing. 
; Author(s):        Christoph Krogmann <ch.krogmann@gmx.de>
; Note(s):          During search for the coordinate, choose a point at the left
;                   side of the loading bar!
;
;======================================================================================
;
Func _FfLoadWait ($x, $y, $pcm, $lbc = 664682)
	Opt("PixelCoordMode", $pcm)
	Local $i
	Local $iColor
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = $lbc Then
			$i = 1
	    Else
		Endif
	    Sleep(20)
    Until $i = 1
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = $lbc Then
		Else
            $i = 2
        Endif
	    Sleep(20)
	Until $i = 2	
EndFunc	;==>_FfLoadWait