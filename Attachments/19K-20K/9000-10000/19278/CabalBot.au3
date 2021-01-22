While 1
	WinActivate("CABAL")
	$SearchResult = PixelSearch(116, 59, 148, 68, 0x1A1A1A, 10, 1)
	If Not @error Then
		Send("{-}")
	EndIf
$coord = PixelSearch( 100, 100, 1024, 718, 0X908D31, 10, 2)
If Not @error Then
  MouseClick("left",$coord[0],$coord[1])
  Sleep (200)
EndIf
Send("1")
Sleep(1500)
Send("2")
Sleep(1600)
Send("3")
Sleep(1600)
Send("{Space}")
Send("{Space}")
Wend