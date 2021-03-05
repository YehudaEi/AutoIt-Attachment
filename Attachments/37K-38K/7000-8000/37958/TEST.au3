HotKeySet("{ESC}", "_exit")
HotKeySet("{F1}", "_start")

Func _start()
While 1
    Sleep(100)
    $search = PixelSearch(1920, 1080, 0, 0, 0xf0e660)
	Sleep(1000)
    If IsArray($search) Then
        MouseMove($search[0], $search[1], 1)
		Sleep(10000)
    EndIf
WEnd
EndFunc


Func _exit()
    Exit
EndFunc

While 1
Sleep("200")
WEnd 