#include <GuiConstants.au3>
#include <Joystick.au3>
;~ #NoTrayIcon



;  ***************************************
;    Atention: The file "joystick.au3" should be in the 
;    include directory of Autoit. Else you can change the
;    path in #include call. Don't forget!!

; ***************************************


Opt ("Trayicondebug",1)
HotKeySet ("{ESC}","End")

MsgBox (0,"TEST (Directional)","Get your Joystick and make a movement, then close this dialog.")

Local $X_Coord,$Y_Coord,$Btn_Press=0

Select
Case JoyMoveLeft ()
	$X_Coord="Turn the Left Corner"
Case JoyMoveRight ()
	$X_Coord="Turn the Right Corner"
Case Else
	$X_Coord="Center"
EndSelect

Select
Case JoyMoveUp ()
	$Y_Coord="Turn the Up Corner"
Case JoyMoveDown ()
	$Y_Coord="Turn the Down Corner"
Case Else
	$Y_Coord="Center"
EndSelect

MsgBox (0,"Currently Joystick Position","The 'X' Axis is: "&$X_Coord&@CRLF&"The 'Y' Axis is: "&$Y_Coord)
Sleep (1000)
MsgBox (0,"TEST (Buttons)","Close this dialog and press 1st, 2nd, 3rd or 4th buttons (ESC key: Exit this test).")

While 1
	$Btn_Press=$Btn_Press+1
	If JoyButtonPressed (1,$Btn_Press) then ExitLoop
	If $Btn_Press=5 Then $Btn_Press=0
WEnd

MsgBox(0,"Test finished","The "&$Btn_Press&"º button was dettected.")

Func end ()
	

Exit
EndFunc
