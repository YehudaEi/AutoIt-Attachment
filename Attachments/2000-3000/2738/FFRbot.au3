; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Blueo
;
; Script Function:
;	Simulates FFR play on almost all songs.
;
; ----------------------------------------------------------------------------

#include <GUIconstants.au3>

Msgbox(0,"Setup","Connect to FFR and select your genre before continuing.")
$Song=Inputbox("Setup","Song number?")
WinActivate("FlashFlashRevolution.com :: Your Flash Flash Revolution Source - Mozilla Firefox")

Mouseclick("Left",590,490)
Sleep(2000)
Mouseclick("Left",650,380)
Sleep(500)
Mouseclick("Left",690,450)
Sleep(2000)
Mouseclick("Left",275,675)
Sleep(1000)
Mouseclick("Left",690,450)
Sleep(2000)
Mouseclick("Left",590,490)
Sleep(3000)

While $song>12
	Mouseclick("Left",430,690)
	Sleep(3000)
	$song=$song-12
WEND

Select
	Case $Song=1
		Mouseclick("Left",220,460)
	Case $song=2
		Mouseclick("Left",290,460)
	Case $song=3
		Mouseclick("Left",360,460)
	Case $song=4
		Mouseclick("Left",220,540)
	Case $song=5
		Mouseclick("Left",290,540)
	Case $song=6
		Mouseclick("Left",360,540)
	Case $song=7
		Mouseclick("Left",220,610)
	Case $song=8
		Mouseclick("Left",290,610)
	Case $song=9
		Mouseclick("Left",360,610)
	Case $song=10
		Mouseclick("Left",220,680)
	Case $song=11
		Mouseclick("Left",290,680)
	Case $song=12
		Mouseclick("Left",360,680)

EndSelect
Sleep(2000)
Mousedown("Left")
Sleep(3000)

$left=pixelgetcolor(350,425)
$down=pixelgetcolor(420,425)
$up=pixelgetcolor(485,425)
$right=pixelgetcolor(555,425)

While 1
	If(pixelgetcolor(350,425))<>$left then
		Send("{LEFT}")
	Endif
	If(pixelgetcolor(420,425))<>$down then
		Send("{DOWN}")
	Endif
	If(pixelgetcolor(485,425))<>$up then
		Send("{UP}")
	Endif
	If(pixelgetcolor(555,425))<>$right then
		Send("{RIGHT}")
	Endif
	Sleep(40)
WEND
	

		