#include <GUIConstants.au3>

$gui = GUICreate ("The fucken application", 550, 490)
; background picture
$background = GUICtrlCreatePic ("prog.cap", 0, 0, 550, 396)
GUISetState (@SW_SHOW)
$Pressed = 0

; transparent child window
;$pic=GUICreate("", 14, 80, 0, 0,$WS_POPUP,$WS_EX_LAYERED+$WS_EX_MDICHILD,$gui)

$Button_IV_m = 1
$Button_IV_n = 2
$Button_IV_o = 3
$Button_IV_p = 4
$Button_VII_q = 5
$Button_VII_r = 6
$Button_VII_s = 7
$Button_VII_t = 8

$Button_VIII_u = 9
$Button_VIII_v = 10
$Button_VIII_w = 11
$Button_VIII_x = 12

$Button_IX_a = 13
$Button_IX_b = 14
$Button_IX_c = 15
$Button_IX_d = 16


$Button_1 = GUICtrlCreateButton ("Run &Notepad", 10, 400, 100, 25)
$Button_2 = GUICtrlCreateButton ("Check &Mail", 10, 430, 100, 25)
$Button_3 = GUICtrlCreateButton ("Messenger&", 10, 460, 100, 25)

$Button_IV = GUICtrlCreateButton ("&C++", 115, 400, 100, 25)
$Button_5 = GUICtrlCreateButton ("Scite", 115, 430, 100, 25)
$Button_6 = GUICtrlCreateButton ("Autoplay", 115, 460, 100, 25)

$Button_VII = GUICtrlCreateButton ("Messenger", 220, 400, 100, 25)
$Button_VIII = GUICtrlCreateButton ("&Office", 220, 430, 100, 25)
$Button_IX = GUICtrlCreateButton ("Check Mail.", 220, 460, 100, 25)
$Label1 = GUICtrlCreateLabel ("Your Text Goes here", 30, 31, 201, 215)
;GUISetBkColor (0xE00dddd)
call ("Main")
GUICtrlSetData ($Label1, "My Name Is Earl")
; transparent pic
;$basti_stay = GUICtrlCreatePic ("G:\Photos\ÌÏíÏ\Icons.bmp", 0, 0, 635, 576)
GUISetState (@SW_SHOW)
Func Clear()
	if $Pressed = 9 Then
		GUICtrlDelete ($Button_IX_d)
		sleep (50)
		GUICtrlDelete ($Button_IX_c)
		sleep (50)
		GUICtrlDelete ($Button_IX_b)
		sleep (50)
		GUICtrlDelete ($Button_IX_a)
		sleep (250)
	EndIf
	if $Pressed = 7 Then
		GUICtrlDelete ($Button_VII_t)
		sleep (50)
		GUICtrlDelete ($Button_VII_s)
		sleep (50)
		GUICtrlDelete ($Button_VII_r)
		sleep (50)
		GUICtrlDelete ($Button_VII_q)
		sleep (250)
	EndIf
	if $Pressed = 8 Then
		GUICtrlDelete ($Button_VIII_x)
		sleep (50)
		GUICtrlDelete ($Button_VIII_w)
		sleep (50)
		GUICtrlDelete ($Button_VIII_v)
		sleep (50)
		GUICtrlDelete ($Button_VIII_u)
		sleep (250)
	EndIf
	if $Pressed = 4 Then
		GUICtrlDelete ($Button_IV_p)
		GUICtrlDelete ($Button_VII)
		$Button_VII = GUICtrlCreateButton ("Messenger", 385, 400, 100, 25)
		sleep (50)
		GUICtrlDelete ($Button_IV_o)
		GUICtrlDelete ($Button_VII)
		$Button_VII = GUICtrlCreateButton ("Messenger", 330, 400, 100, 25)
		sleep (50)
		GUICtrlDelete ($Button_IV_n)
		GUICtrlDelete ($Button_VII)
		$Button_VII = GUICtrlCreateButton ("Messenger", 275, 400, 100, 25)
		sleep (50)
		GUICtrlDelete ($Button_IV_m)
		GUICtrlDelete ($Button_VII)
		$Button_VII = GUICtrlCreateButton ("Messenger", 220, 400, 100, 25)
		sleep (250)

	EndIf
EndFunc   ;==>Clear
GUISetState ()
Func Main()
	While 1
		$msg = GUIGetMsg ()
		if $msg = $GUI_EVENT_CLOSE then Exit
		if $msg = $Button_1 then
			call ("Clear")
			Run ('Notepad.exe')    ; Will Run/Open Notepad
			$Pressed = 1
		EndIf
		if $msg = $Button_2 then
			call ("Clear")
			GUICtrlSetData ($Label1, "You've Pressed Check My Mail")
			$Pressed = 2
		EndIf
		if $msg = $Button_VIII then
			call ("Clear")
			$Button_VIII_u = GUICtrlCreateButton ("Word", 325, 430, 50, 25)
			sleep (50)
			$Button_VIII_v = GUICtrlCreateButton ("Excel", 380, 430, 50, 25)
			sleep (50)
			$Button_VIII_w = GUICtrlCreateButton ("Access", 435, 430, 50, 25)
			sleep (50)
			$Button_VIII_x = GUICtrlCreateButton ("P.Point", 490, 430, 50, 25)
			$Pressed = 8
			GUICtrlSetData ($Label1, "You've Pressed Ms Office")
			call ("Main")
		endif
		if $msg = $Button_VIII_u then MsgBox (0, 'Testing', '8a')
		if $msg = $Button_VIII_v then MsgBox (0, 'Testing', '8b')    ; Will demonstrate Button 2 being pressed
		if $msg = $Button_VIII_w then MsgBox (0, 'Testing', '8c')
		if $msg = $Button_VIII_x then MsgBox (0, 'Testing', '8d')
		;________________________________________________________________________________________________________   4

		if $msg = $Button_IV then Call ("Four")

		;________________________________________________________________________________________________________________VII

		if $msg = $Button_VII then
			
			Dim $msg = $Button_VII
			call ("Clear")
			$Button_VII_q = GUICtrlCreateButton ("Yahoo", 325, 400, 50, 25)
			sleep (50)
			$Button_VII_r = GUICtrlCreateButton ("MSN", 380, 400, 50, 25)
			sleep (50)
			$Button_VII_s = GUICtrlCreateButton ("Gmail", 435, 400, 50, 25)
			sleep (50)
			$Button_VII_t = GUICtrlCreateButton ("Web", 490, 400, 50, 25)
			$msg = GUIGetMsg ()
			$Pressed = 7
			Dim $msg = $Button_VII
			call ("Main")
			
		EndIf
		if $msg = $Button_VII_q then MsgBox (0, 'Testing', 'yahoob')
		if $msg = $Button_VII_r then MsgBox (0, 'Testing', 'Bmsn msned')    ; Will demonstrate Button 2 being pressed
		if $msg = $Button_VII_s then MsgBox (0, "", '7c')
		if $msg = $Button_VII_t then MsgBox (0, "", '7c')
		;_____________________________________________________________________________________________________________________________IX

		if $msg = $Button_IX then
			call ("Clear")
			$Button_IX_a = GUICtrlCreateButton ("Yahoo", 325, 460, 50, 25)
			sleep (50)
			$Button_IX_b = GUICtrlCreateButton ("Hotmail", 380, 460, 50, 25)
			sleep (50)
			$Button_IX_c = GUICtrlCreateButton ("Gmail", 435, 460, 50, 25)
			sleep (50)
			$Button_IX_d = GUICtrlCreateButton ("Maktoob", 490, 460, 50, 25)
			$Pressed = 9
			call ("Main")
			
		EndIf
		if $msg = $Button_IX_a then MsgBox (0, 'Testing', 'mail9a')
		if $msg = $Button_IX_b then MsgBox (0, 'Testing', 'mail9b')    ; Will demonstrate Button 2 being pressed
		if $msg = $Button_IX_c then MsgBox (0, 'Testing', 'mail9c')
		if $msg = $Button_IX_d then MsgBox (0, 'Testing', 'mail9d')
		
	Wend

EndFunc   ;==>Main

Func Four()
	call ("Clear")
	$msg = ""
	GUICtrlDelete ($Button_VII)
	$Button_IV_m = GUICtrlCreateButton ("Browse", 220, 400, 50, 25)
	$Button_VII = GUICtrlCreateButton ("Messenger", 275, 400, 100, 25)
	sleep (50)
	GUICtrlDelete ($Button_VII)
	$Button_IV_n = GUICtrlCreateButton ("Compile", 275, 400, 50, 25)
	$Button_VII = GUICtrlCreateButton ("Messenger", 330, 400, 100, 25)
	sleep (50)
	GUICtrlDelete ($Button_VII)
	$Button_IV_o = GUICtrlCreateButton ("Edit", 330, 400, 50, 25)
	$Button_VII = GUICtrlCreateButton ("Messenger", 385, 400, 100, 25)
	sleep (50)
	GUICtrlDelete ($Button_VII)
	$Button_IV_p = GUICtrlCreateButton ("Tidy", 385, 400, 50, 25)
	$Button_VII = GUICtrlCreateButton ("Messenger", 440, 400, 100, 25)
	$Pressed = 4
	GUICtrlSetData ($Label1, "You've Pressed C")
	

	while 1
		$msg = GUIGetMsg ()
		Select
			Case $msg = $Button_IV_m
				MsgBox (0, 'Testing', 'cccccccc4a')
			Case $msg = $Button_IV_n
				MsgBox (0, 'Testing', 'cccccccc4b')
			Case $msg = $Button_IV_o
				MsgBox (0, 'Testing', 'ccccccccc4c')
			Case $msg = $Button_IV_p
				MsgBox (0, 'Testing', 'cccccccccccc4d')
			Case Else
				call ("Main")
				$msg = ""
		EndSelect
	WEnd
EndFunc   ;==>Four