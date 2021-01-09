#NoTrayIcon
FileWrite(@TempDir&"\state.txt","PLAY")

HotKeySet("{F9}","_Pause") ; Press F9 for pause AimBot
HotKeySet("{F10}","_Play") ; Press F10 for Play AimBot
HotKeySet("{F11}","_Exit") ; Press F11 for Exit AimBot

While 1
$State=FileRead(@TempDir&"\state.txt") ; Read State of AimBot

If $State="PLAY" Then ; If AimBot is Working Then
$pixel=PixelSearch(0,0,1280,1024,0xFF0000); OxFFOOOO = redcolor 255 so edit it for have the good red color for target

If IsArray($pixel) = 1 Then ; If Pixel has been found
MouseClick('left', $pixel[0], $pixel[1], 1, 0) ; Click on the pixel
EndIf
EndIf

WEnd


Func _Pause()
FileDelete(@TempDir&"\state.txt")
FileWrite(@TempDir&"\state.txt","PAUSE")
EndFunc

Func _Play()
FileDelete(@TempDir&"\state.txt")
FileWrite(@TempDir&"\state.txt","PLAY")
EndFunc

Func _Exit()
FileDelete(@TempDir&"\state.txt")
Exit
EndFunc