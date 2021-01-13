sleep(15000)

Opt("ColorMode",1)
$aPixelSearch = PixelSearch(1046,157,1106,342,0xFFFF00,4)
if not @error Then
		MouseClick("left")
	EndIf
