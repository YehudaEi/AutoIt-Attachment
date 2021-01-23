#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <array.au3>
Sleep(10000)

Global $anfang = PixelChecksum(960, 117, 970, 127) ; area that I want to check


Global $anfangClone = 0 ; area clone to copare with $anfang



Global $minix1 = 836  	; minimap top x
Global $miniy1 = 23		; minimap top y
Global $minix2 = 1017	; minimap bottom x
Global $miniy2 = 204	; minimap bottom y
	
Global $mini2x1 = 0		; new coordinates from $anfang (top x)
Global $mini2y1 = 0		; new coordinates from $anfang (top y)
Global $mini2x2 = 0		; new coordinates from $anfang (bottom x)
Global $mini2y2 = 0		; new coordinates from $anfang (bottom y)

sleep(10000)
$h = 0	
	
while $h <= 10	
	while $minix1 <= 1017 And $anfang <> $anfangClone ; searching new coordinadinates from my area till found it or untill whole minimap searched
		
		while $miniy1 <= 204 And $anfang <> $anfangClone
		
		$anfangClone = PixelChecksum($minix1, $miniy1, $minix1 + 10, $miniy1 + 10) ; searching new coordinadinates from my area till found it or untill whole minimap searched
													   ;970-960 = 10  127-117 = 10 ($anfang)
		if $anfang = $anfangClone Then
			
			$mini2x1 = $minix1
			$mini2y1 = $miniy1
			$mini2x2 = $minix1 + 10
			$mini2y2 = $miniy1 + 10
		EndIf
		
		$miniy1 = $miniy1 +1
		 
		 
		WEnd
	$miniy1 = 23
	$minix1 = $minix1 +1	
	
	WEnd
sleep(200)
$h = $h +1
WEnd

sleep(1000)

; show the values in the end
MsgBox(0,"The decmial color is", $mini2x1 )
MsgBox(0,"The decmial color is", $mini2y1 )
MsgBox(0,"The decmial color is", $mini2x2 )
MsgBox(0,"The decmial color is", $mini2y2 )
MsgBox(0,"The decmial color is", $minix1 )
MsgBox(0,"The decmial color is", $miniy1 )
MsgBox(0,"The decmial color is", $anfang)
MsgBox(0,"The decmial color is", $anfangClone)

	