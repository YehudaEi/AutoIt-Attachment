Global $p1[2]=[0,0]
Global $p2[2]=[0,0]
Global $beg[2]=[0,0]
$var = PixelGetColor( 100 , 100 )
Global $pause=False
Global $step=1
HotKeySet("^,", "click")
HotKeySet("^.}","print")
HotKeySet("^/","begin")
HotKeySet("^'","pause")

Func pause()
	$pause = NOT $pause
	While $pause
		Sleep(1000)
		WEnd
	EndFunc
Func begin()
	$beg=MouseGetPos()
EndFunc
Func click()
	If $p1[0]=0	Then
	Global $p1=MouseGetPos ()
         ElseIf $p2[0]=0	Then
		   Global $p2=MouseGetPos()
	EndIf
EndFunc
While $p2[0]=0
	Sleep(100) ;waiting for click() 2x
WEnd
Global $width=$p2[0]-$p1[0]
Global $height=$p2[1]-$p1[1]
Global $Image, $Palette, $colnum
$colnum=2
Dim $Image[$width][$height][$colnum]
Dim $Palette[$colnum]
$Palette[0]=0
Sleep(1000)
For $x=$p1[0] to Int(($p2[0]-1)/$step)
For $y=$p1[1] to Int(($p2[1]-1)/$step)
$Image[$x-$p1[0]][$y-$p1[1]][0]=PixelGetColor( $x*$step , $y*$step ) ;throw pixel data into an array
Next
Next

For $x=0 to $width-1
	For $y=0 to $height-1
		$added=False
		For $c=1 to $colnum-1
		If $Palette[$c]=$Image[$x][$y][0] Then
$Image[$x][$y][$c]=1
$added=True
$c=$colnum-1
EndIf
Next
If NOT $added Then
	$colnum+=1
	ReDim $Palette[$colnum]
	$Palette[$colnum-1]=$Image[$x][$y][0]
	ReDim $Image[$width][$height][$colnum]
	$Image[$x][$y][$colnum-1]=1
EndIf
Next
Next
	MsgBox(4096, "Test",$colnum, 360)

Global $askPrint=False
While $askPrint=False
	Sleep(100)
WEnd

Func print()
	While $beg[0]=0 
		Sleep(100)
		WEnd
	$askPrint=True
	$curcol=0
	$pi=3.14159
	Dim $curcolh, $thiscolor
	For $c=1 to $colnum-1 ;cycle through colors
		$thiscolor = $Palette[$c]
		if colordif($thiscolor,Dec("ffffff"))<50 Then 
			$c+=1
			$thiscolor = $Palette[$c]
			EndIf
		MouseClick("left",397,549) ; this needs to be adjusted for your screen resolution and browser.
			$curColh=Hex($thiscolor)
			Sleep(100)
			Send("{END}")
			Send("{END}{BS}{BS}{BS}{BS}{BS}{BS}{BS}")
			Send(StringMid($curColh,3,8))
			Sleep(500)
			Send("{ENTER}")
			Sleep(50)
For $x=0 to $width-1
	For $y=0 to $height-1
		If $Image[$x][$y][$c]=1 Then
			    MouseMove($x*$step+$beg[0],$y*$step+$beg[1],1)
				MouseDown("left")
				$Image[$x][$y][$c]=0 ;new
			$xP=$x ;temporary x and y values
			$yP=$y ;for finding a line to draw
			$go=True
			While $go
				$go=False
			$temp=Random(1,8)
			For $p=$temp to $temp+7
				$tx=Round(Cos($pi*$p/4),0)
				$ty=Round(Sin($pi*$p/4),0)
				If $xP+$tx<$width-1 AND $xP+$tx>0 AND $yP+$ty<$height-1 AND $yP+$ty>0 AND $go=False Then
					;making sure indices are in range
					If $Image[$xP+$tx][$yP+$ty][$c]=1 AND $go=False Then
							$xP+=$tx
							$yP+=$ty
							$p=8
							MouseMove($xP*$step+$beg[0],$yP*$step+$beg[1],1)
							$Image[$xP][$yP][$c]=0
							$go=True
						EndIf
					EndIf
				Next ;end checking around
			WEnd
			MouseUp("left")
		EndIf
	Next
Next
Next
	EndFunc
Func colordif($color1,$color2)
	$hstring=Hex($color1)
	$hstring2=Hex($color2)
	$R1=Dec(StringMid($hstring,1,2))
	$G1=Dec(StringMid($hstring,3,2))
	$B1=Dec(StringMid($hstring,5,2))
    
	$R2=Dec(StringMid($hstring2,1,2))
	$G2=Dec(StringMid($hstring2,3,2))
	$B2=Dec(StringMid($hstring2,5,2))
    Return Abs($R1-$R2)+Abs($G1-$G2)+Abs($B1-$B2)
EndFunc

