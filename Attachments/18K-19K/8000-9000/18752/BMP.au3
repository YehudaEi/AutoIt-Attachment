#include-once
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.126 (beta)
; Author:         Evilertoaster <evilertoaster at yahoo dot com>
;
; Script Function:
;	Basic BMP file writing.
;Script Version:
;   1.8
; ----------------------------------------------------------------------------

Func _BMPGetWidth(ByRef $BMPHandle)
	If IsArray($BMPHandle)=0 Then Return -1
	If UBound($BMPHandle,0)<>2 Then Return -1
	Return UBound($BMPHandle,1)
EndFunc
Func _BMPGetHeight(ByRef $BMPHandle)
	If IsArray($BMPHandle)=0 Then Return -1
	If UBound($BMPHandle,0)<>2 Then Return -1	
	Return UBound($BMPHandle,2)
EndFunc
Func _BMPGetChecksum(ByRef $BMPHandle,$step=1)
	Local $q,$r,$col,$relrect,$adler,$s1,$s2,$nStep,$ptOrigin
	For $q=0 to _BMPGetWidth($BMPHandle)-1 Step $step
		For $r=0 to _BMPGetHeight($BMPHandle)-1 Step $step
			$col= _PixelRead($BMPHandle, $q, $r)
			$s1 = BitAND($adler, 0xffff)
			$s2 = BitAND(BitRotate($adler,16), 0xffff)
			$s1 = Mod(($s1 + Dec(StringLeft($col,2))), 65521)
			$s2 = Mod(($s2 + $s1),65521)
			$adler = BitShift($s2,16) + $s1
			$s1 = BitAND($adler, 0xffff)
			$s2 = BitAND(BitRotate($adler,16), 0xffff)
			$s1 = Mod(($s1 + Dec(StringMid($col,3,2))),65521)
			$s2 = Mod(($s2+$s1),65521)
			$adler = BitShift($s2,16) + $s1
			$s1 = BitAND($adler, 0xffff)
			$s2 = BitAND(BitRotate($adler,16), 0xffff)
			$s1 = Mod(($s1 + Dec(StringRight($col,2))), 65521)
			$s2 = Mod(($s2 + $s1),65521)
			$adler = BitShift($s2,16) + $s1
		Next
	Next
	Return $adler
EndFunc

Func _PixelFill(ByRef $BMPHandle,$x,$y,$color,$variation=0)
	Local $CheckChart[UBound($BMPHandle,1)][UBound($BMPHandle,2)]
	Local $count=0
	$Tset=1
	Local $tracer[$Tset]
	$tracer[$tset-1]=$x&","&$y
	Local $CheckColor=Dec(_PixelRead($BMPHandle,$x,$y))
	$CheckChart[$y][$x]=1
	While 1
		if Abs(Dec(_PixelRead($BMPHandle,$x-1,$y))-$CheckColor)<=$variation Then
			$CheckChart[$x-1][$y]=1
			$count+=1
			_PixelWrite($BMPHandle,$x-1,$y,$color)
			$Tset+=1
			ReDim $tracer[$Tset]
			$tracer[$Tset-1]=$x&","&$y
			$x=$x-1
			ContinueLoop
		EndIf
		if Abs(Dec(_PixelRead($BMPHandle,$x,$y-1))-$CheckColor)<=$variation Then
			$CheckChart[$x][$y-1]=1
			$count+=1
			_PixelWrite($BMPHandle,$x,$y-1,$color)
			$Tset+=1
			ReDim $tracer[$Tset]
			$tracer[$Tset-1]=$x&","&$y
			$y=$y-1
			ContinueLoop
		EndIf
		if Abs(Dec(_PixelRead($BMPHandle,$x+1,$y))-$CheckColor)<=$variation Then
			$CheckChart[$x+1][$y]=1
			$count+=1
			_PixelWrite($BMPHandle,$x+1,$y,$color)
			$Tset+=1
			ReDim $tracer[$Tset]
			$tracer[$Tset-1]=$x&","&$y
			$x=$x+1
			ContinueLoop
		EndIf
		if Abs(Dec(_PixelRead($BMPHandle,$x,$y+1))-$CheckColor)<=$variation Then
			$CheckChart[$x][$y+1]=1
			$count+=1
			_PixelWrite($BMPHandle,$x,$y+1,$color)
			$Tset+=1
			ReDim $tracer[$Tset]
			$tracer[$Tset-1]=$x&","&$y
			$y=$y+1
			ContinueLoop
		EndIf
		$Point=StringSplit($tracer[$Tset-1],",")
		$x=$Point[1]
		$y=$Point[2]
		$Tset-=1
		ReDim $tracer[$Tset]
		if $tset=1 then ExitLoop
	Wend
	Return $count
EndFunc
func _RectangleWrite(ByRef $BMPHandle,$x,$y,$Width,$Height,$color,$Thickness=1)
	if $Thickness<1 then Return -1
	if $Thickness>1 then 
		Return SubRectangleWrite($BMPHandle,$x,$y,$Width,$Height,$color,$Thickness)
	EndIf
	Local $TempW=Round($Width/2)
	Local $TempH=Round($Height/2)
	_LineWrite($BMPHandle,$x-$TempW,$y-$TempH,$x+$TempW,$y-$TempH,$color)
	_LineWrite($BMPHandle,$x+$TempW,$y-$TempH,$x+$TempW,$y+$TempH,$color)
	_LineWrite($BMPHandle,$x+$TempW,$y+$TempH,$x-$TempW,$y+$TempH,$color)
	_LineWrite($BMPHandle,$x-$tempw,$y+$TempH,$x-$TempW,$y-$TempH,$color)
	Return $Width*$Height
EndFunc
func SubRectangleWrite(ByRef $BMPHandle,$x,$y,$Width,$Height,$color,$Thickness)
	For $a=1 to $Thickness
		_RectangleWrite($BMPHandle,$x,$y,$Width-Round($a/2),$Height-Round($a/2),$color)
		_RectangleWrite($BMPHandle,$x,$y,$Width+Round($a/2),$Height+Round($a/2),$color)
	Next
	Return $Width*$Height
EndFunc
func _EllipseWrite(ByRef $BMPHandle,$X,$Y,$Width,$Height,$color,$Thickness=1)
	if $Thickness<1 then Return -1
	if $Thickness>1 then 
		Return SubEllipseWrite($BMPHandle,$x,$y,$Width,$Height,$color,$Thickness)
	EndIf
	Local $SumA=$Width/2
	Local $SumB=$Height/2
	Local $LastY=0
	Local $temp,$test,$h
	_PixelWrite($BMPHandle,Floor($x-$Width/2),$y,$color)
	_PixelWrite($BMPHandle,$x+$Width/2,$y,$color)
	For $a=-$Width/2 to $Width/2
		$temp=Sqrt(($SumB^2)*(1-(($a^2)/($SumA^2))))
		if $temp>$LastY then
			$test=$temp-$LastY
		Else
			$test=$LastY-$temp
		EndIf
		If $test<=1 then
			_PixelWrite($BMPHandle,$x+$a,$y+$temp,$color)
			_PixelWrite($BMPHandle,$x+$a,$y-$temp,$color)
		Else
			_LineWrite($BMPHandle,$x+$a-1,$y+$LastY,$x+$a,$y+$temp,$color)
			_LineWrite($BMPHandle,$x+$a-1,$y-$LastY,$x+$a,$y-$temp,$color)
		EndIf
		$LastY=$temp
	Next
	$h=(($sumA-$SumB)^2)/(($sumA+$SumB)^2)
	Return 3.14159*($SumA+$SumB)*(1+((3*$h)/(10+Sqrt(4-(3*$h)))))
EndFunc
Func SubEllipseWrite(ByRef $BMPHandle,$x,$y,$Width,$Height,$color,$Thickness)
	for $a=1 to $Thickness
		_EllipseWrite($BMPHandle,$x,$y,$Width+$a,$Height+$a,$color)
		Local $Return=_EllipseWrite($BMPHandle,$x,$y,$Width-$a,$Height-$a,$color)
	Next
	Return $Return
EndFunc
Func SubLineWrite(ByRef $BMPHandle,$x1,$y1,$x2,$y2,$color,$loops)
	if $loops<1 then Return -1
	for $a=1 to $loops-1
		Local $Return=_LineWrite($BMPHandle,$x1+$a,$y1,$x2+$a,$y2,$color)
		_LineWrite($BMPHandle,$x1-$a,$y1,$x2-$a,$y2,$color)
	Next
	Return $Return
EndFunc
Func _LineWrite(ByRef $BMPHandle,$x1,$y1,$x2,$y2,$color,$Thickness=1)
	If $Thickness<>1 then 
		Local $Return=SubLineWrite($BMPHandle,$x1,$y1,$x2,$y2,$color,$Thickness)
		Return $Return
	EndIf
	If $x1=$x2 or $y1=$y2 Then
		if $x1=$x2 and $y1=$y2 then
			_PixelWrite($BMPHandle,$x1,$y1,$color)
			Return 1
		EndIf
		if $x1=$x2 then
			if $y1>$y2 Then
				Local $hold=$y1
				$y1=$y2
				$y2=$hold
			EndIf
			For $a=$y1 to $y2
				_PixelWrite($BMPHandle,$x1,$a,$color)
			Next
			Return $y2-$y1
		EndIf
		if $y1=$y2 Then
			If $x1>$x2 Then
				Local $hold=$x2
				$x2=$x1
				$x1=$hold
			EndIf
			for $a=$x1 to $x2
				_PixelWrite($BMPHandle,$a,$y1,$color)
			Next
			Return $x2-$x1
		EndIf
	EndIf
	If $x1>$x2 Then
		Local $hold=$x2
		$x2=$x1
		$x1=$hold
		$hold=$y1
		$y1=$y2
		$y2=$hold
	EndIf
	Local $slope=($y2-$y1)/($x2-$x1)
	if $y2>$y1 Then
		Local $highy=$y2
		Local $lowy=$y1
	Else
		Local $highy=$y1
		Local $lowy=$y2
	EndIf
	If $x2-$x1>$highy-$lowy Then
		Local $stepx=1
		Local $stepy=$slope
	Else
		Local $stepx=1/abs($slope)
		if $y1>$y2 then
			Local $stepy=-1
		Else
			Local $stepy=1
		EndIf
	EndIf
	Local $count=0
	for $a=$x1 to $x2 step $stepx
		_PixelWrite($BMPHandle,$a,$y1+($stepy*$count),$color)
		$count+=1
	Next
	Return Sqrt(($highy-$lowy)*($highy-$lowy)+($x2-$x1)*($x2-$x1))
EndFunc

Func _BMPCreate ($Width,$Height)
	Local $BMParray[$Width][$Height]
	Return $BMParray
EndFunc
Func _BMPOpen($Path,$Progress=1)
	Local $Bpath=FileOpen($Path,4)
	If $Bpath=-1 then Return(-1)
	Local $TestBM=FileRead($Bpath,2)
	If $TestBM<>"BM" then Return(-2)
	Local $AllOf=FileRead($Bpath,FileGetSize($Path))
	Local $Fixed="424D"&StringTrimLeft(String($AllOf),2)
	$x=Dec(FixFormat(StringMid($Fixed,37,8)))
	$y=Dec(FixFormat(StringMid($Fixed,45,8)))
	Dim $BMP[$x][$y]
	If $Progress=1 then ProgressOn("Loading BMP File...","","",-1,-1,18)
	for $c=$x to 0 step -4
		If $c=3 then 
			$TmpAdd="000000"
			ExitLoop
		EndIf
		If $c=2 then 
			$TmpAdd="0000"
			ExitLoop
		EndIf
		If $c=1 then 
			$TmpAdd="00"
			ExitLoop
		EndIf
		If $c=0 then 
			$TmpAdd=""
			ExitLoop
		EndIf
		If $Progress=1 Then ProgressSet((($x+1)/($c+1))*100,"","Finding Add Amount ("&$c&" of "&$x&")")
	Next
	;y=2
	;offset-1
	;y=3
	;offset-2
	;y=4
	;offeset-3
	;y=5
	;offset-4
	;y=6
	;offest=5
	;Local $addOffset=0
	Local $addOffset=($y-1)*($c*2)
;	MsgBox(0,$addOffset,$c&"   "&$y)
	;if $TmpAdd="" then $addOffset=$addOffset-(($y-1)*2)
	;MsgBox(0,$addOffset,$c)
	For $a=0 to $Y-1
		For $b=0 to $x-1
			$te=109+((($x*($y-1-$a))+$b)*6)+$addOffset
			$BMP[$b][$a]=StringMid($Fixed,$te,6)
			;MsgBox(0,"",StringMid($Fixed,$te,6))
		Next
		$addOffset=$addOffset-($c*2)
		If $Progress=1 Then ProgressSet(($a/$y)*100,"","Line " & $a & " of " & $y)
	Next
	ProgressOff()
	Return $BMP
EndFunc
Func _PixelRead(ByRef $BMPHandle,$x,$y)
	Local $Width=UBound($BMPHandle,1)
	Local $Height=UBound($BMPHandle,2)
	If $x>$Width-1 Or $x<0 Or $y>$Height-1 Or $y<0 Then Return (-1)
	Local $type=Opt("ColorMode")
	If $type=1 Then
		$color=$BMPHandle[$x][$y]
	Else
		$temp=$BMPHandle[$x][$y]
		$color=StringMid($temp, 5, 2) & StringMid($temp, 3, 2) & StringMid($temp, 1, 2)
	EndIf
	If $color="" Then $Color="FFFFFF"
	Return $Color
EndFunc	
Func RawWrite($File,$Hex)
	If IsInt(StringLen($Hex)/2)=0 Then Return (-1)
	Local $a
	For $a=1 To StringLen($Hex) Step 2
		FileWrite($File,Chr(Dec(StringMid($Hex,$a,2))))
	Next
EndFunc 
Func _PixelWrite(ByRef $BMPHandle,$x,$y,$color)
	Local $Width=UBound($BMPHandle,1)
	Local $Height=UBound($BMPHandle,2)
	If $x>$Width-1 Or $x<0 Or $y>$Height-1 Or $y<0 Then Return (-1)
	Local $type=Opt("ColorMode")
	If $type=1 Then
		$BMPHandle[$x][$y]=$color
	Else
		$BMPHandle[$x][$y]=StringMid($color, 5, 2) & StringMid($color, 3, 2) & StringMid($color, 1, 2)
	EndIf
	Return (1)
EndFunc
Func _BMPWrite($BMPHandle,$Fpath,$Progress=1)
	Local $TmpAdd
	Local $Width=UBound($BMPHandle,1)
	If $Progress=1 Then ProgressOn("Examining BMP Handle...","","",-1,-1,18)
	For $a=$Width to 0 step -4
		If $a=4 then 
			$TmpAdd=""
			$a=0
			ExitLoop
		EndIf
		If $a=3 then 
			$TmpAdd="000000"
			ExitLoop
		EndIf
		If $a=2 then 
			$TmpAdd="0000"
			ExitLoop
		EndIf
		If $a=1 then 
			$TmpAdd="00"
			ExitLoop
		EndIf
		If $Progress=1 Then ProgressSet((($Width+1)/($a+1))*100,"","Finding Add Amount ("&$a&" of "&$Width&")")
	Next
	Local $Height=UBound($BMPHandle,2)
	Local $FileSize=FixFormat(Hex(($Height)*($Width)*3+54+($Height*$a),8))
	Local $HexWidth=FixFormat(Hex($Width,8))
	Local $HexHeight=FixFormat(Hex($Height,8))
	Local $ImageDataSize=FixFormat(Hex(($Height)*($Width)*3+($Height*$a),8))
	Local $Header="424D"&$FileSize&"000000003600000028000000"&$HexWidth & $HexHeight&"0100180000000000"&$ImageDataSize&"00000000000000000000000000000000"
	If FileExists($fPath)=1 then Return -2
	Local $File=FileOpen($Fpath,2)
	If $File=-1 Then Return -2
	RawWrite($File,$Header)
	If $Progress=1 Then ProgressOn("Writing BMP File","Line 1 of " & $Height,"",-1,-1,18)
	Local $a,$b
	For $y=$Height-1 To 0 Step -1
		For $x=0 To $Width-1
			If $BMPHandle[$x][$y]="" Then $BMPHandle[$x][$y]="FFFFFF"
			If RawWrite($file,$BMPHandle[$x][$y])= -1 Then Return -1
		Next
		If RawWrite($file,$TmpAdd)= -1 Then Return -1	
		If $Progress=1 Then ProgressSet(($Height-$y+1)/$Height*100,"","Line " & $Height-$y & " of " & $Height)
	Next
	ProgressOff()	
	FileClose($file)
	Return 1
EndFunc
Func FixFormat($HexData)
	Local $a,$ReturnValue=""
	For $a=7 To 1 Step -2
		$ReturnValue &= StringMid($HexData,$a,2)
	Next
	Return ($ReturnValue)
EndFunc