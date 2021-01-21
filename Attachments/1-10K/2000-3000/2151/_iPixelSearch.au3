Func _iPixelSearch($left, $top, $right, $bottom, $color, $shade = 0, $step = 1)
	Local $av_ret[3]
	Local $ai_coords = PixelSearch($left, $top, $right, $bottom, $color, $shade, $step)
	If @error Then
		SetError(@error)
		Return 0
	EndIf
	
	$av_ret[0] = PixelGetColor($ai_coords[0], $ai_coords[1])
	$av_ret[1] = $ai_coords[0]
	$av_ret[2] = $ai_coords[1]
	Return $av_ret
EndFunc   ;==>_iPixelSearch