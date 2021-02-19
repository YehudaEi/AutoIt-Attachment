

while 1
If $Active = 1 Then 
$checkforpixelA = Pixelsearch( 50, 488, 292, 645, 0x015089)
$checkforpixelB = Pixelsearch( 273, 765, 914, 954, 0xEBF3FB)
	if isarray($checkforpixelA Then
		mousemove($checkforpixelB [0], $checkforpixelB[1], 1)
		sleep(1000)
	EndIf
EndIf
WEnd

