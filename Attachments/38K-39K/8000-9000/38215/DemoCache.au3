Run("C:\Cacheset.exe")
While 1
 Sleep(100)
 If WinExists ("Cacheset ") Then
  ConsoleWrite("WinExists returns '1'." & @CR)
  WinActive ("Cacheset ")
  Beep(1500,5)
  Sleep(3000)
 ControlClick ("Cacheset ", "", "[ID:2]" )	;Change this according to your needs
  ExitLoop
  EndIf
Wend