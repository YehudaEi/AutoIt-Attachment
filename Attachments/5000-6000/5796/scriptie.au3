#include <GUIConstants.au3>
Break(0)
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
$mainwindow = GUICreate("MU Afk Complex", 615, 220)
GUISetBkColor (0x51606C)
$menu = GUICtrlCreateMenu ( "Menu")
$about = GUICtrlCreateMenuitem ("About", $menu)
GUICtrlSetOnEvent ( $about, "About" )
$quit = GUICtrlCreateMenuitem ("Exit", $menu)
GUICtrlSetOnEvent ( $quit, "CLOSEClicked" )
GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
;@@@@@@@@@@@@@ Resolution Box @@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("", 4, 1, 100, 107)
GUICtrlCreateLabel("Game resolution", 10, 9)
GUICtrlSetColor(-1, 0xFFFFFF)
$res1 = GUICtrlCreateRadio ("640x480", 10, 24, 90)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $res1, "GUI_CHECKED" )
$res2 = GUICtrlCreateRadio ("800x600", 10, 44, 90)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $res2, "GUI_CHECKED" )
$res3 = GUICtrlCreateRadio ("1024x768", 10, 64, 90)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $res3, "GUI_CHECKED" )
$res4 = GUICtrlCreateRadio ("1280x1024", 10, 84, 90)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $res4, "GUI_CHECKED" )
$resauto = IniRead ("config.ini", "Config", "Res", "$res2")
GUICtrlSetState($resauto, $GUI_CHECKED)
GUICtrlCreateGroup ("",-99,-99,1,1)
;@@@@@@@@@@@@@@@@@Afk box @@@@@@@@@@@@@@
GUICtrlCreateGroup ("", 4, 110, 240, 87)
GUICtrlCreateLabel ("Choose your AFK mode.",  10, 118)
GUICtrlSetColor(-1, 0xFFFFFF)
$afk1 = GUICtrlCreateRadio ("Autobuff with SmartHealing (800x600 only)", 10, 133, 230)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $afk1, "Opt_Check" )
$afk2 = GUICtrlCreateRadio ("Autobuff", 10, 153, 80)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $afk2, "Opt_Check" )
GUICtrlCreateGroup ("",-99,-99,1,1)

;@@@@@@@@@@@@@@@@@Pickup and vpc box@@@@@@@@@@@@@
$autoloot = GUICtrlCreateCheckbox ("Auto PickUp", 255, 115)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent ( $autoloot, "GUI_CHECKED" )
GUICtrlCreateLabel ("Number of people in party:",  255, 150)
GUICtrlSetColor( -1, 0xFFFFFF)
$number = GUICtrlCreateCombo ("", 255,170)
GUICtrlSetData(-1,"2|3|4|5") 
GUICtrlSetColor($number, 0xFFFFFF)
;@@@@@@@@@@@@@@@@@@@Buff time box@@@@@@@@@@@@@@@@@@
GUICtrlCreateLabel ("Input the gap time between Buff cycles (in ms):",  130, 4)
GUICtrlSetColor(-1, 0xFFFFFF)
$sleep1 = GUICtrlCreateInput ("", 140, 25, 200, 20)
GUICtrlSetLimit(-1,5)
$sleepdef = IniRead("config.ini", "Config", "Sleep", "0")
GUICtrlSetData ( $sleep1, $sleepdef )
$button2 = GUICtrlCreateButton ("",  120, 50, 270, 50, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",146)
GUICtrlSetOnEvent ( $button2, "Button" )
;@@@@@@@@@@@@@@@@@@@@Buff types #1@@@@@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("Party Member #1", 400, 1, 100, 80)
$def1 = GUICtrlCreateCheckbox ("Defense Buff", 408, 15)
GUICtrlSetColor(-1, 0xFFFFFF)
$att1= GUICtrlCreateCheckbox ("Attack Buff", 408, 35)
GUICtrlSetColor(-1, 0xFFFFFF)
$heal1= GUICtrlCreateCheckbox ("Heal", 408, 55)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup ("",-99,-99,1,1)
;@@@@@@@@@@@@@@@@@@@@Buff types #2@@@@@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("Party Member #2", 400, 85, 100, 80)
$def2 = GUICtrlCreateCheckbox ("Defense Buff", 408, 99)
GUICtrlSetColor(-1, 0xFFFFFF)
$att2= GUICtrlCreateCheckbox ("Attack Buff", 408, 113)
GUICtrlSetColor(-1, 0xFFFFFF)
$heal2= GUICtrlCreateCheckbox ("Heal", 408, 127)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup ("",-99,-99,1,1)
;@@@@@@@@@@@@@@@@@@@@Buff types #3@@@@@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("Party Member #3", 400, 150, 100, 80)
$def3 = GUICtrlCreateCheckbox ("Defense Buff", 408, 164)
GUICtrlSetColor(-1, 0xFFFFFF)
$att3= GUICtrlCreateCheckbox ("Attack Buff", 408, 178)
GUICtrlSetColor(-1, 0xFFFFFF)
$heal3= GUICtrlCreateCheckbox ("Heal", 408, 192)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup ("",-99,-99,1,1)
;@@@@@@@@@@@@@@@@@@@@Buff types #4@@@@@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("Party Member #3", 505, 1, 100, 80)
$def4 = GUICtrlCreateCheckbox ("Defense Buff", 513, 15)
GUICtrlSetColor(-1, 0xFFFFFF)
$att4= GUICtrlCreateCheckbox ("Attack Buff", 513, 29)
GUICtrlSetColor(-1, 0xFFFFFF)
$heal4= GUICtrlCreateCheckbox ("Heal", 513, 43)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup ("",-99,-99,1,1)
;@@@@@@@@@@@@@@@@@@@@Buff types #5@@@@@@@@@@@@@@@@@@@@@
GUICtrlCreateGroup ("Party Member #3", 505, 85, 100, 80)
$def5 = GUICtrlCreateCheckbox ("Defense Buff", 513, 99)
GUICtrlSetColor(-1, 0xFFFFFF)
$att5= GUICtrlCreateCheckbox ("Attack Buff", 513, 113)
GUICtrlSetColor(-1, 0xFFFFFF)
$heal5= GUICtrlCreateCheckbox ("Heal", 513, 127)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup ("",-99,-99,1,1)
Func CLOSEClicked1()
	GUIDelete()
EndFunc

Func CLOSEClicked()
$file = IniWrite("config.ini", "Config", "Sleep", GUICtrlRead($sleep1))
	If GUICtrlRead($res1) = $GUI_CHECKED Then
		IniWrite("config.ini", "Config", "Res", "$res1")
	ElseIf GUICtrlRead($res2) = $GUI_CHECKED Then
		IniWrite("config.ini", "Config", "Res", "$res2")
	ElseIf GUICtrlRead($res3) = $GUI_CHECKED Then
		IniWrite("config.ini", "Config", "Res", "$res3")
	ElseIf GUICtrlRead($res4) = $GUI_CHECKED Then
		IniWrite("config.ini", "Config", "Res", "$res4")
	EndIf
If $file = -1 Then
    MsgBox(0, "Error", "Cannot open log file.")
EndIf
  Exit
EndFunc

Func GUI_CHECKED()
If GUICtrlRead ( $res2 ) = $GUI_CHECKED Then
	Global $buff1x = 775
	Global $buff1y = 42
	Global $buff2x = 775
	Global $buff2y = 72
	Global $buff3x = 775
	Global $buff3y = 92
	Global $buff4x = 775
	Global $buff4y = 115
	Global $buff5x = 775
	Global $buff5y = 140
	Global $buffx = 799
	Global $buffy = 599
	Global $afkx = 400
	Global $afky = 300
ElseIf GUICtrlRead ( $res1 ) = $GUI_CHECKED Then
	Global $buff1x = 620
	Global $buff1y = 32
	Global $buff2x = 620
	Global $buff2y = 62
	Global $buff3x = 620
	Global $buff3y = 82
	Global $buff4x = 620
	Global $buff4y = 105
	Global $buff5x = 620
	Global $buff5y = 130
	Global $buffx = 620
	Global $buffy = 450
	Global $afkx = 320
	Global $afky = 240
ElseIf GUICtrlRead ( $res3 ) = $GUI_CHECKED Then
	Global $buff1x = 999
	Global $buff1y = 52
	Global $buff2x = 999
	Global $buff2y = 83
	Global $buff3x = 999
	Global $buff3y = 102
	Global $buff4x = 999
	Global $buff4y = 125
	Global $buff5x = 999
	Global $buff5y = 150
	Global $buffx = 999
	Global $buffy = 578
	Global $afkx = 512
	Global $afky = 384
ElseIf GUICtrlRead ( $res4 ) = $GUI_CHECKED Then
	Global $buff1x = 1260
	Global $buff1y = 62
	Global $buff2x = 1260
	Global $buff2y = 93
	Global $buff3x = 1260
	Global $buff3y = 112
	Global $buff4x = 1260
	Global $buff4y = 135
	Global $buff5x = 1260
	Global $buff5y = 160
	Global $buffx = 1260
	Global $buffy = 1200
	Global $afkx = 640
	Global $afky = 512
EndIf
EndFunc

Func Opt_Check()
If GUICtrlRead ( $afk1 ) = $GUI_CHECKED Then
Global $afkmode = "Autobuff"
ElseIf GUICtrlRead ( $afk2 ) = $GUI_CHECKED Then
Global $afkmode = "Autobuff2"
EndIf
EndFunc

Func Pick()
Send("{SPACE}")
EndFunc

Func HK_STOP()
while 1 = 1
Sleep(1000)
wend
EndFunc

Func Button()
WinMinimizeAll()
HotKeySet("{F5}", "HK_STOP")
HotKeySet("{F6}", $afkmode)
TrayTip("", "To run script press F6. To stop it, press F5", 5, 1)
EndFunc

Func About()
GUICreate ("About", 300, 170)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked1")
GUICtrlCreateLabel ("MU AFK Complex is a script written in AutoIt language to help MATIRA guild people leave AFK. Current options:",  2, 2, 295, 40)
GUICtrlCreateLabel ("- Multi Resolution",  40, 50, 240, 250)
GUICtrlCreateLabel ("- Autobuff with SmartHealing",  40, 65, 240, 250)
GUICtrlCreateLabel ("- Auto PickUp",  40, 80, 240, 250)
GUICtrlCreateLabel ("Current version is: 0.59. If you encounter any problems e-mail me and I'll try to fix the problem: gokkkkuuuu@poczta.fm",  2, 118, 295, 250)
GUISetState()
EndFunc

While 1
  Sleep(1000)
WEnd

Func Autobuff()
While(1)
Call ("Auto")
Call ("SmartHeal")
MouseMove ( $buffx,$buffy ,1 )
Sleep($sleep1 / 2)
Send("1")
MouseMove ( 400,300 ,1 )
MouseClick("Right", 400,300)
Sleep($sleep1 / 2)
Wend
Endfunc

Func Autobuff2()
While (1)
Call ("Autobuff1")
Call ("HealF")
$x = mod(GUICtrlRead($sleep1), 2)
MouseMove ( $buffx,$buffy ,1 )
Sleep($x)
Send("1")
MouseMove ( 400,300 ,1 )
MouseClick("Right", 400,300)
Sleep($x)
Wend
EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@ Resources @@@@@@@@@@@@@@@@@
;Autobuff with checking frame
Func Auto()
Opt("MouseClickDownDelay", 1)
Opt("MouseCoordMode", 1)
Opt("SendKeyDownDelay", 70)

MsgBox ( 0, "loading", "loading", 1)
Opt("SendKeyDelay", 1)
Opt("SendKeyDownDelay", 1)

;@@@@@@@@@@@STARTS def buff @@@@@@@@@@@
Send("2")
Sleep(50)

If GUICtrlRead ( $def1 ) = 1 OR 0 Then
MouseMove ( $buff1x,$buff1y ,1 )
MouseClick("Right",$buff1x,$buff1y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
Send("2")
;@@@@@@@@@@@@DEF 2ND PLAYER@@@@@@@@@@@@ 
Send("2")

If GUICtrlRead ( $def2 ) = 1 OR 0 Then
MouseMove ( $buff2x,$buff2y ,1 )
MouseClick("Right",$buff2x,$buff2y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@DEF 3RD PLAYER@@@@@@@@@@@@
Send("2")

If GUICtrlRead ( $def3 ) = 1 OR 0 Then
MouseMove ( $buff3x,$buff3y ,1 )
MouseClick("Right",$buff3x,$buff3y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@DEF 4TH PLAYER@@@@@@@@@@@@
Send("2")

If GUICtrlRead ( $def4 ) = 1 OR 0 Then  
MouseClick("Right",$buff4x,$buff4y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@DEF 5TH PLAYER@@@@@@@@@@@@
Send("2")

If GUICtrlRead ( $def5 ) = 1 OR 0 Then
MouseMove ( $buff5x,$buff5y ,1 )
MouseClick("Right",$buff5x,$buff5y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@ATT 1ST PLAYER@@@@@@@@@@@@@
If GUICtrlRead ( $att1 ) = 1 OR 0 Then
Send("3")

MouseMove ( $buff1x,$buff1y ,1 )
MouseMove ( $buff1x,$buff1y ,1 )
MouseClick("Right",$buff1x,$buff1y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@ATT 2ND PLAYER@@@@@@@@@@@@
Send("3")

If GUICtrlRead ( $att2 ) = 1 OR 0 Then
Send("3")
MouseMove ( $buff2x,$buff2y ,1 )
MouseClick("Right",$buff2x,$buff2y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@ATT 3RD PLAYER@@@@@@@@@@@@
Send("3")

If GUICtrlRead ( $att3 ) = 1 OR 0 Then
Send("3")
MouseMove ( $buff3x,$buff3y ,1 )
MouseClick("Right",$buff3x,$buff3y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@ATT 4TH PLAYER@@@@@@@@@@@@
Send("3")

If GUICtrlRead ( $att4 ) = 1 OR 0 Then
Send("3")
MouseMove ( $buff4x,$buff4y ,1 )
MouseClick("Right",$buff4x,$buff4y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf

MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@ATT 5TH PLAYER@@@@@@@@@@@@ 
Send("3")

If GUICtrlRead ( $att5 ) = 1 OR 0 Then
MouseMove ( $buff5x,$buff5y ,1 )
MouseClick("Right",$buff5x,$buff5y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("3")
MouseMove ( $buffx,$buffy ,1 )
MouseMove ( $buffx,$buffy ,1 )
 

EndFunc

;SmartHealing

Func SmartHeal()
$kolor1 = PixelGetColor( 785,48 )
$kolor2 = PixelGetColor( 785,72 )
$kolor3 = PixelGetColor( 785,96 )
$kolor4 = PixelGetColor( 785,118 )
$kolor5 = PixelGetColor( 785,121 )


If $kolor1 < 10000000 Then
    Send("1")
    Sleep(300)
    MouseMove ( 770,48 ,1 )
    MouseClick("Right", 770,48)
    TrayTip("Healed", "Party member #1 - Healed", 5)
    TrayTip("Healed", "", 2)
    MsgBox ( 0, "loading", "loading", 1)
    MouseMove ( $buffx,$buffy ,1 )
     

ElseIf $kolor1 > 10000000 Then
    TrayTip("Healed", "Party member #1 - No need heal", 5)
    TrayTip("Healed", "", 2)
    Sleep(300)
     
EndIf

If $kolor2 < 10000000 Then
    Send("1")
    Sleep(300)
    MouseMove ( 770,72 ,1 )
    MouseClick("Right", 770,72)
    TrayTip("Healed", "Party member #2 - Healed", 2)
    TrayTip("Healed", "", 2)
    MsgBox ( 0, "loading", "loading", 1)
    MouseMove ( $buffx,$buffy ,1 )
     

ElseIf $kolor2 > 10000000 Then
    TrayTip("Healed", "Party member #2 - No need heal", 2)
    TrayTip("Healed", "", 2)
    Sleep(300)
     
EndIf

If $kolor3 < 10000000 AND $number = 3 OR 4 OR 5 Then
    Send("1")
    Sleep(300)
    MouseMove ( 770,98 ,1 )
    MouseClick("Right", 770,98)
    TrayTip("Healed", "Party member #3 - Healed", 2)
    TrayTip("Healed", "", 2)
    MsgBox ( 0, "loading", "loading", 1)
    MouseMove ( $buffx,$buffy ,1 )
     

ElseIf $kolor3 > 10000000 AND $number >= 3 Then
    TrayTip("Healed", "Party member #3 - No need heal", 2)
    TrayTip("Healed", "", 2)
    Sleep(300)
     
ElseIf $number = 2 Then
Sleep (1)
EndIf

If $kolor4 < 10000000 AND $number = 4 OR $number = 5 Then
    Send("1")
    Sleep(300)
    MouseMove ( 770,120 ,1 )
    MouseClick("Right", 770,120)
    TrayTip("Healed", "Party member #4 - Healed", 2)
    TrayTip("Healed", "", 2)
    MsgBox ( 0, "loading", "loading", 1)
    MouseMove ( $buffx,$buffy ,1 )
     

ElseIf $kolor4 > 10000000 AND $number = 4 Then
    TrayTip("Healed", "Party member #4 - No need heal", 2)
    TrayTip("Healed", "", 2)
    Sleep(300)
     
ElseIf $number < 4 Then
     
Else
     
EndIf

If $kolor5 < 10000000 AND $number = 5 Then
    Send("1")
    Sleep(300)
    MouseMove ( 770,144 ,1 )
    MouseClick("Right", 770,144)
    TrayTip("Healed", "Party member #5 - Healed", 2)
    MsgBox ( 0, "loading", "loading", 1)
    MouseMove ( $buffx,$buffy ,1 )

ElseIf $kolor5 > 10000000 AND $number = 5 Then
    TrayTip("clearing","",0)
    TrayTip("Healed", "Party member #5 - No need heal", 2)
    Sleep(300)
     

ElseIf $number < 5 Then
     
Else
     
EndIf
EndFunc

;Healing with check frame
Func HealF()
;@@@@@@@@@@@@@@@@@AUTO HEAL@@@@@@@@@@
MsgBox ( 0, "loading", "loading", 1)
;@@@@@@@@@@@HEAL 1ST PLAYER@@@@@@@@@@@@@
If GUICtrlRead ( $heal1 ) = 1 OR 0 Then
Send("1")
MouseMove ( $buff1x,$buff1y ,1 )
MouseClick("Right",$buff1x,$buff1y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("1")
MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@HEAL 2ND PLAYER@@@@@@@@@@@@
If GUICtrlRead ( $heal2 ) = 1 OR 0 Then
Send("1")
MouseMove ( $buff2x,$buff2y ,1 )
MouseClick("Right",$buff2x,$buff2y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("1")
MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@HEAL 3RD PLAYER@@@@@@@@@@@@
If GUICtrlRead ( $heal3 ) = 1 OR 0 Then
Send("1")
MouseMove ( $buff3x,$buff3y ,1 )
MouseClick("Right",$buff3x,$buff3y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("1")
MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@HEAL 4TH PLAYER@@@@@@@@@@@@
If GUICtrlRead ( $heal4 ) = 1 OR 0 Then
Send("1")
MouseMove ( $buff4x,$buff4y ,1 )
MouseClick("Right",$buff4x,$buff4y)
MsgBox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("1")
MouseMove ( $buffx,$buffy ,1 )
 
;@@@@@@@@@@@@HEAL 5TH PLAYER@@@@@@@@@@@@
If GUICtrlRead ( $heal5 ) = 1 OR 0 Then
Send("1")
MouseMove ( $buff5x,$buff5y ,1 )
MouseClick("Right",$buff5x,$buff5y)
Msgbox ( 0, "loading", "loading", 1)
 
Else
MouseMove ( $buffx,$buffy ,1 )
 
EndIf
Send("1")
MouseMove ( $buffx,$buffy ,1 )
 
EndFunc