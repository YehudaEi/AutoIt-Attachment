While 1
	WinActivate("Karos Online - ver.01.091209.nhn.eng.real")
	$SearchResult = PixelSearch(472, 202, 514, 202, 0x84898F, 10, 1)
	If Not @error Then
		Send("{6}")
	EndIf

Send("4")
Sleep(750)
Send("3")
Sleep(5000)

Wend