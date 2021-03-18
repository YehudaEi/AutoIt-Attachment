Local $sub='SMBus'
Local $tit1 ='ID - Notepad'

Local $va=WinGetText($tit1)
MsgBox(0, "ControlGetText Example", "The control text is: " & $va)