Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced

$debug = 0
$handle = WinGetHandle("Test OCR")
$white = 16777215
$light = 12632256
$dark = 8421504
$hwhite = "0xFFFFFF"
$hlight = "0xC0C0C0"
$hdark = "0x808080"
$MAXPIX	 = 50 ;Maximum perimeter of a "piece" to be considered not a letter.(tolerance)
$pix = 0 ;counting for maxpix
$tx = 0 ;temp x
$ty = 0 ;temp y
$dir = 1 ;direction of last pixel move
$place = 0 ;running placeholder so multiple pixels aren't checked.

Run(@ComSpec & " /c Start C:\TestOCR.exe")
WinWaitActive("Test OCR")
;WinMove("Test OCR","",0,0)

For $j = 172 To 266
	For $i = 125 To 424
		;MsgBox(0,"Info",$i&","&$j&" "&PixelGetColor($i,$j))
		If PixelGetColor($i,$j) == $light Then
			If PixelGetColor($i+1,$j) == $light Then
				;MsgBox(0,"Info",$i&","&$j&" "&PixelGetColor($i,$j))
				SetPixel($handle, $i, $j, $hdark)
				SetPixel($handle, $i+1, $j, $hdark)
				SetPixel($handle, $i, $j+1, $hdark)
				SetPixel($handle, $i+1, $j+1, $hdark)
			Elseif PixelGetColor($i+1,$j) == $white Then
				SetPixel($handle, $i, $j, $hwhite)
			ElseIf PixelGetColor($i+1,$j) == $dark Then
				SetPixel($handle, $i, $j, $hdark)
			EndIf
		EndIf
	Next
Next

For $j = 172 To 266
	For $i = 125 To 424
		If PixelGetColor($i,$j) == $white AND PixelGetColor($i+1,$j) == $dark And PixelGetColor($i-1,$j) == $dark And PixelGetColor($i,$j+1) == $dark And PixelGetColor($i,$j-1) == $dark Then
			SetPixel($handle, $i, $j, $hdark)
		EndIf
	Next
Next

For $j = 172 To 266
	For $i = 125 To 424
		If $i = 125 Then
			$place = 125
		EndIf
		If PixelGetColor($i,$j) == $dark Then
			If $i > $place Then
				TrimPiece($i,$j)
			EndIf
		EndIf
	Next
Next


Func TrimPiece ($x, $y)
	$tx = $x
	$ty = $y
	$pix = 1
	$dir = 0
	trace("first pixel",$x,$y)
	If TrimStrip($x, $y) == 0 Then
		While PixelGetColor($tx,$ty) == $dark
			$tx += 1
		WEnd
		$place = $tx
	EndIf
EndFunc

Func TrimStrip($x, $y)
	trace("direction",$dir,$pix)
	Select
	Case $dir = 0
			If PixelGetColor($x-1,$y) == $dark Then
				If $x-1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 3
					If $pix <= $MAXPIX Then
						If TrimStrip($x-1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y-1) == $dark Then
				If $x <> $tx OR $y-1 <> $ty Then
					$pix += 1
					$dir = 0
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y-1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x+1,$y) == $dark Then
				If $x+1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 1
					If $pix <= $MAXPIX Then
						If TrimStrip($x+1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y+1) == $dark Then
				;trace($x&","&$y&","&"Entered next pixel down")
				If $x <> $tx OR $y+1 <> $ty Then
					$pix += 1
					$dir = 2
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y+1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			Else
				If $pix == 1 Then
					SetPixel($handle, $x, $y, $hwhite)
				EndIf
				Return 0
			EndIf
			
		Case $dir = 1
			If PixelGetColor($x,$y-1) == $dark Then
				If $x <> $tx OR $y-1 <> $ty Then
					$pix += 1
					$dir = 0
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y-1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x+1,$y) == $dark Then
				If $x+1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 1
					If $pix <= $MAXPIX Then
						If TrimStrip($x+1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y+1) == $dark Then
				If $x <> $tx OR $y+1 <> $ty Then
					$pix += 1
					$dir = 2
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y+1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x-1,$y) == $dark Then
				If $x-1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 3
					If $pix <= $MAXPIX Then
						If TrimStrip($x-1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			Else
				If $pix == 1 Then
					SetPixel($handle, $x, $y, $hwhite)
				EndIf
				Return 0
			EndIf
			
		Case $dir = 2
			If PixelGetColor($x+1,$y) == $dark Then
				If $x+1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 1
					If $pix <= $MAXPIX Then
						If TrimStrip($x+1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y+1) == $dark Then
				If $x <> $tx OR $y+1 <> $ty Then
					$pix += 1
					$dir = 2
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y+1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x-1,$y) == $dark Then
				If $x-1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 3
					If $pix <= $MAXPIX Then
						If TrimStrip($x-1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y-1) == $dark Then
				If $x <> $tx OR $y-1 <> $ty Then
					$pix += 1
					$dir = 0
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y-1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			Else
				If $pix == 1 Then
					SetPixel($handle, $x, $y, $hwhite)
				EndIf
				Return 0
			EndIf
			
		Case $dir = 3
			If PixelGetColor($x,$y+1) == $dark Then
				If $x <> $tx OR $y+1 <> $ty Then
					$pix += 1
					$dir = 2
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y+1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x-1,$y) == $dark Then
				If $x-1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 3
					If $pix <= $MAXPIX Then
						If TrimStrip($x-1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x,$y-1) == $dark Then
				If $x <> $tx OR $y-1 <> $ty Then
					$pix += 1
					$dir = 0
					If $pix <= $MAXPIX Then
						If TrimStrip($x,$y-1) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			ElseIf PixelGetColor($x+1,$y) == $dark Then
				If $x+1 <> $tx OR $y <> $ty Then
					$pix += 1
					$dir = 1
					If $pix <= $MAXPIX Then
						If TrimStrip($x+1,$y) == 1 Then
							SetPixel($handle, $x, $y, $hwhite)
							Return 1
						Else
							Return 0
						EndIf
					Else
						Return 0
					EndIf
				Else
					If $pix <= $MAXPIX Then
						SetPixel($handle, $x, $y, $hwhite)
						Return 1
					EndIf
				EndIf
			Else
				If $pix == 1 Then
					SetPixel($handle, $x, $y, $hwhite)
				EndIf
				Return 0
			EndIf
		EndSelect
EndFunc
	
		
Func SetPixel ($handle, $x, $y, $color)
    $dc= DllCall ("user32.dll", "int", "GetDC", "hwnd", $handle)
    $setpixel= DllCall ("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $x, "long", $y, "long", $color)
    $realesedc= DllCall ("user32.dll", "int", "ReleaseDC", "hwnd", 0,  "int", $dc[0])
EndFunc

Func trace($string, $str2 = "", $str3 = "", $str4 = "", $str5 = "")
	If $debug == 1 Then
		$tstr = $string
		If $str2 <> "" OR $str2 == 0 Then
			$tstr = $string&","&$str2
		EndIf
		If $str3 <> "" OR $str3 == 0 Then
			$tstr = $string&","&$str2&","&$str3
		EndIf
		If $str4 <> "" Then
			$tstr = $string&","&$str2&","&$str3&","&$str4
		EndIf
		If $str5 <> "" Then
			$tstr = $string&","&$str2&","&$str3&","&$str4&","&$str5
		EndIf
		MsgBox(0,"Info",$tstr)
		Return $tstr
	EndIf
EndFunc

