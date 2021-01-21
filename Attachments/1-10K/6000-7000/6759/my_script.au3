Opt ("SendKeyDelay", 1       )
Opt ("WinTitleMatchMode", 4  )
Opt ("SendKeyDownDelay", 50 )
Opt ("MouseClickDownDelay", 1)
Opt ("MouseClickDragDelay",1)
Opt("MouseClickDelay",1)


HotKeySet ("{F8}",  "Bot")
HotkeySet ("{F7}", "Stop")



;********** Left Click **********

Func Left_Click ()
While (1)

MouseClick ("Left")
WinActivate ("Classname=Shell_TrayWnd")
MouseUp ("Left")
Send (" ", 1)

WEnd
EndFunc


;********Klic******************

Func Bot ()
While (1)

	Call ("DL_DRAG1_L1")
	Call ("DL_DRAG1_D1")


	Call ("DL_DRAG3_L3")
	Call ("DL_DRAG3_D3")




	Call ("DL_DRAG5_L5")
	Call ("DL_DRAG5_D5")




	Call ("DL_DRAG7_L7")
	Call ("DL_DRAG7_D7")




	Call ("DL_DRAG9_L9")
	Call ("DL_DRAG9_D9")




	Call ("DL_DRAG11_L11")
	Call ("DL_DRAG11_D11")



	Call ("DL_DRAG13_L13")
	Call ("DL_DRAG13_D13")



	Call ("DL_DRAG15_L15")
	Call ("DL_DRAG15_D15")




	Call ("DL_DRAG17_L17")
	Call ("DL_DRAG17_D17")



	Call ("DL_DRAG19_L19")
	Call ("DL_DRAG19_D19")




	Call ("DL_DRAG21_L21")
	Call ("DL_DRAG21_D21")




	Call ("DL_DRAG23_L23")
	Call ("DL_DRAG23_D23")

WEnd
EndFunc

;********** Stop **********

Func Stop ()

While 1 = 1
Sleep (1)
Wend

EndFunc


;************************

While (1)
Sleep (1000)
WEnd

;***********************

;***************************************

Func nad ()

WinActivate ("Classname=Shell_TrayWnd")
Send (" ", 1)

EndFunc

;*****************************************


;*****************implementacija_funkcij************

Func DL_DRAG1_L1 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 160, 0, 0)
EndFunc

Func DL_DRAG1_D1 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 160, 0, 0)
EndFunc

Func DL_DRAG3_L3 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 218, 0, 0)
EndFunc

Func DL_DRAG3_D3 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 218, 0, 0)
EndFunc

Func DL_DRAG5_L5 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 264, 0, 0)
EndFunc

Func DL_DRAG5_D5 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 264, 0, 0)
EndFunc

Func DL_DRAG7_L7 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 312, 0, 0)
EndFunc

Func DL_DRAG7_D7 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 312, 0, 0)
EndFunc

Func DL_DRAG9_L9 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 360, 0, 0)
EndFunc

Func DL_DRAG9_D9 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 360, 0, 0)
EndFunc

Func DL_DRAG11_L11 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 390, 0, 0)
EndFunc

Func DL_DRAG11_D11 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 390, 0, 0)
EndFunc

Func DL_DRAG13_L13 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 430, 0, 0)
EndFunc

Func DL_DRAG13_D13 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 430, 0, 0)
EndFunc

Func DL_DRAG15_L15 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 470, 0, 0)
EndFunc

Func DL_DRAG15_D15 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 470, 0, 0)
EndFunc

Func DL_DRAG17_L17 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 510, 0, 0)
EndFunc

Func DL_DRAG17_D17 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 510, 0, 0)
EndFunc

Func DL_DRAG19_L19 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 550, 0, 0)
EndFunc

Func DL_DRAG19_D19 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 550, 0, 0)
EndFunc

Func DL_DRAG21_L21 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 590, 0, 0)
EndFunc

Func DL_DRAG21_D21 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 590, 0, 0)
EndFunc

Func DL_DRAG23_L23 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 166, 630, 0, 0)
EndFunc

Func DL_DRAG23_D23 ()
Call ("nad")
Send ("5 ")
MouseClickDrag("right", 828, 630, 0, 0)
EndFunc

