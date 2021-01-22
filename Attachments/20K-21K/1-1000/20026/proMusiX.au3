#cs
							 _____               .______  ___
	_____________  ____     /     \  __ __  _____|__\   \/  /
	\____ \_  __ \/  _ \   /  \ /  \|  |  \/  ___/  |\     / 
	|  |_> >  | \(  <_> ) /    Y    \  |  /\___ \|  |/     \ 
	|   __/|__|   \____/  \____|__  /____//____  >__/___/\  \
	|__|                          \/           \/         \_/
	
	by AutoProgramming aka Agraf!x
	Version 1.0
#ce

#include<Array.au3>

#cs
Main Programm
#ce
; Parse Songs.ini
$song = IniRead("songs.ini", "songs", "song", "c;d;e")
$leng = IniRead("songs.ini", "songs", "leng", "1;2;3")

; Explode
$aParts = StringSplit($song, ";")
$aLeng = StringSplit($leng, ";")

For $i = 1 To UBound($aParts)
	_PlayTune($aParts[$i], $aLeng[$i]*1000)
Next

#cs
Functions
#ce
; Installation
Func _Install()
	FileInstall("frequ.ini", "frequ.ini")
	FileInstall("songs.ini", "songs.ini")
EndFunc

; Play a Note
Func _PlayTune($tune, $length=1000) 
	$freq = IniRead("frequ.ini", "basic", $tune, 440)
	Sleep(200)
	Beep($freq, $length)
EndFunc