#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Rewl

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <IE.au3>
HotKeySet("{LEFT}" , "left")
HotKeySet("{RIGHT}" , "right")
HotKeySet("{DOWN}" , "down")
HotKeySet("{UP}" , "up")
HotKeySet("{ESC}" , "close")


While 1 = 1
	Sleep(1000)
WEnd

Func down()
	$pos = MouseGetPos()
	MouseClick("left" ,$pos[0] , $pos[1] + 1 , 1)
EndFunc

Func right()
	$pos = MouseGetPos()
	MouseClick("left" , $pos[0] + 1 , $pos[1] , 1)
EndFunc
Func left()
	$pos = MouseGetPos()
	MouseClick("left" , $pos[0] - 1 , $pos[1] , 1)
EndFunc

Func up()
	$pos = MouseGetPos()
	MouseClick("left" , $pos[0] , $pos[1] - 1 , 1)
EndFunc

Func close()
	$iE = _IECreate()
	$msg = MsgBox(4 , "Rewl Draw Tool v1.1" , "Thank you for using Rewl's Draw Tool. Visit Auto-It Thread?")
	If $msg = 6 Then
	_IENavigate( $iE , "http://www.autoitscript.com/forum/topic/122139-drawing-tool/#entry847803" )
	Exit
	EndIf
If $msg = 7 Then
Exit
EndIf
EndFunc


