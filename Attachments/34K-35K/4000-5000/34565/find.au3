Func _find ( $x, $y)
	Local $i
	Local $icolor
	
	;send ("{pgdn}")
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0xf1f1f1 Then
			$i = 1
			
	    Else
			$y = $y - 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , $x , $y, 1 , 10)
$x = 0
$y = 0
EndFunc

Func _find1 ($x, $y)
	Local $i
	Local $icolor
	;send ("{pgdn}")
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0xf0f7e9 Then
			$i = 1
			
	    Else
			$y = $y - 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , ($x -50) , $y, 1 , 10)
$x = 0
$y = 0
EndFunc
Func _DRM ()
	Local $i
	Local $icolor
	;send ("{pgdn}")
	$x = 541
	$y = 630
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0x74a1c4 Then
			$i = 1
			
	    Else
			$y = $y - 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , $x , ($y -74), 1 , 10)
$x = 0
$y = 0
EndFunc
Func _price ()
	Local $i
	Local $icolor
	;send ("{pgdn}")
	$x = 620
	$y = 480
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0x0022aa Then
			$i = 1
			
	    Else
			$y = $y - 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , $x , ($y -47), 1 , 10)
$x = 0
$y = 0
EndFunc
Func _upload ()
	Local $i
	Local $icolor
	;send ("{pgdn}")
	$x = 620
	$y = 534
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0x99ccff Then
			$i = 1
			
	    Else
			$y = $y + 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , $x , ($y + 20), 1 , 10)
$x = 0
$y = 0
EndFunc
Func _upload2 ()
	Local $i
	Local $icolor
	;send ("{pgdn}")
	$x = 620
	$y = 534
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0x99ccff Then
			$i = 1
			
	    Else
			$y = $y + 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , ($x + 320) , ($y + 20), 1 , 10)
$x = 0
$y = 0
EndFunc
Func _text ()
	Local $i
	Local $icolor
	send ("{pgdn}")
	$x = 779
	$y = 650
	Do
		$iColor = PixelGetColor($x ,$y)
		If $iColor = 0x376891 Then
			$i = 1
			
	    Else
			$y = $y - 1
		Endif
	    Sleep(20)
	
Until $i = 1
MouseClick ("" , $x , $y, 1 , 10)
$x = 0
$y = 0
EndFunc