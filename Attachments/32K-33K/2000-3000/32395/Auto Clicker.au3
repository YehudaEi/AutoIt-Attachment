#include<IE.au3>
#include <Misc.au3>


HotKeySet("{ESC}" , "close")
HotKeySet("{SPACE}" , "startpause")

Dim $click = False
$dll = DllOpen("user32.dll")

CMsgBox(64, "Rewl's Auto Click v1.0" , "Thank-you for using Auto Clicker, Press ""ESC"" to close the program and ""spacebar"" to pause the clicker and SpaceBar to start it.")

Func close()
    $iE = _IECreate()
    $m = MsgBox(4 , "Rewl's Auto Click v1.0" , "Thank-you for trying the program, Press yes to visit Auto-IT Thread.")
    IF $m = 6 Then
        _IENavigate($iE , "http://www.autoitscript.com/forum/topic/122227-auto-click/")
    EndIf
    Exit
EndFunc

Func startpause()
   If $click = False Then
      $click = True
      ToolTip("Rewl Auto Click v1.0 Running." , 0 , 0)
   Else
      $click = False
      ToolTip("Rewl Auto Click v1.0 Paused." , 0 , 0)
   EndIf
EndFunc


While 1
    If _IsPressed ( "02" ) = 1 Then
        ConsoleWrite ( "Sleep ( 2000 )" & @Crlf )
        Sleep ( 2000 )
		$click = True
    EndIf

   If $click = True Then
    MouseClick("left")
	Sleep(50)
EndIf
sleep(20)
WEnd



