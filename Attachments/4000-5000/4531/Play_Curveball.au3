		;;;;;Curveball Player;;;;;
;;;Created by Mr.Llama <Kev10191@msn.com> (LlamaUniverse.tk);;;

HotKeySet("{ESC}","Stop")
Msgbox(0,"Ready","Press OK when you're ready.")
Sleep(1000)

While 1
$ballcoord = PixelSearch(260, 345, 595, 570, 0xA8FF93, 50, 10)
If Not @error Then
MouseClick("left", $ballcoord[0], $ballcoord[1], 1, 0)
EndIf
WEnd

Func Stop()
Exit 0
EndFunc()