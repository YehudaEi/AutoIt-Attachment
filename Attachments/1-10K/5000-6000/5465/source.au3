Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
    WEnd
EndFunc

Func Terminate()
    Exit 0
EndFunc

$slot = InputBox("Karakter választás", "Melyik karakterrel akarsz indítani", "1")
$pos_loginnamex = 512
$pos_loginnamey = 300
$pos_loginpassx = 512
$pos_loginpassy = 320
$pos_loginbuttonx = 512
$pos_loginbuttony = 350
$pos_okx = 240
$pos_oky = 500
$pos_rightx = 177
$pos_righty = 450
$pos_leftx = 127
$pos_lefty = 450
$pos_upx = 152
$pos_upy = 420
$pos_downx = 152
$pos_downy = 470
$pos_shopx = 47
$pos_shopy = 330
$pos_buylistx = 92
$pos_buylisty = 260
$pos_buybuttonx = 222
$pos_buybuttony = 325
$pos_leaveshopx = 282
$pos_leaveshopy = 390
$pos_menekulx = 147
$pos_menekuly = 345
$pos_amounthomex = 167
$pos_amounthomey = 250
$pos_gethomex = 252
$pos_gethomey = 200
$pos_leavehomex = 362
$pos_leavehomey = 320
$status = "rabol"
$pajszer = 0
$menekul = 1
$penz = 1
$levelup = 1
$data = ""


Func Loading()
	WinWait("Larkinor" , "Done")
	Send("^a^c")
	$data = ClipGet()
	If StringInStr($data, "Loginnév:") > 0 AND StringInStr($data, "Ezzel a karakterrel") = 0 Then
		Login()
	Endif
EndFunc

Func OK()
	MouseClick("left", $pos_okx, $pos_oky)
	Loading()
Endfunc

Func MoveRight()
	MouseClick("left", $pos_rightx, $pos_righty)
Endfunc

Func MoveLeft()
	MouseClick("left", $pos_leftx, $pos_lefty)
Endfunc

Func MoveUp()
	MouseClick("left", $pos_upx, $pos_upy)
Endfunc

Func MoveDown()
	MouseClick("left", $pos_downx, $pos_downy)
Endfunc

Func Kaszino()
	$send = IniRead("config.ini", $slot, "lopas", "")
	MoveDown()
	Loading()
	MouseClick("left" , $pos_shopx , $pos_shopy)
	Loading()
	MouseClick("left" , 500 , 300 )	
	Send($send)
	MouseClick("left" , 505 , 340 )
	Loading()
	MouseClick("left" , 275 , 395 )
	Loading()
	Fejleszt()
EndFunc

Func Fejleszt()
	MoveUp()
	Loading()
	MouseClick("left" , $pos_shopx , $pos_shopy )
	Loading()
	MouseClick("left" , 285 , 375 )
	Loading()
	MouseClick("left" , 165 , 285 )
	Loading()
	MouseClick("left" , 295 , 378 )
	Loading()
	MouseClick("left" , 210 , 372 )	
	$lopi = IniRead("config.ini", $slot, "lopas", "")
	$lopi = $lopi + 20
	IniWrite ("config.ini", $slot, "lopas", "$lopi" ) 
	Loading()
EndFunc

Func Avoid()
	MouseClick("left" , $pos_shopx , $pos_shopy )
	Loading()
	MouseClick("left" , 210 , 372 )	
	Loading()
EndFunc

Func Money()
	$pos_money = StringInStr($data,"Pénz:")
	$pos_money = $pos_money + 6
	$pos_health = StringInStr($data,"Életpont:")
	$money = StringMid($data, $pos_money, $pos_health-$pos_money)
	$split = StringSplit($money, " ")
	$money = $split[1] & $split[2] & $split[3] & $split[4]
	Return $money
EndFunc

Func Leave()
	MouseClick("left", $pos_menekulx, $pos_menekuly)
	Loading()
	MouseClick("left", 300, 190)
	MouseClick("left", 300, 210)
	MouseClick("left", 300, 230)
	MouseClick("left", 300, 250)
	MouseClick("left", 300, 270)
	MouseClick("left", 300, 290)
	MouseClick("left", 300, 310)
	MouseClick("left", 300, 330)
	MouseClick("left", 300, 350)
	MouseClick("left", 300, 370)
	MouseClick("left", 300, 390)
	MouseClick("left", 300, 410)
	MouseClick("left", 300, 430)
	MouseClick("left", 300, 450)
	MouseClick("left", 300, 470)
	MouseClick("left", 300, 490)
	Loading()
Endfunc

Func Login()

	$loginname = IniRead("config.ini", $slot, "username", "")
	$loginpass = IniRead("config.ini", $slot, "password", "")
	MouseClick("left", 250 , 250)
	Sleep(1000)
	MouseClick("left", $pos_loginnamex, $pos_loginnamey, 2)
	Sleep(500)
	Send($loginname)
	Sleep(500)
	MouseClick("left", $pos_loginpassx, $pos_loginpassy, 2)
	Sleep(500)
	Send($loginpass)
	Sleep(500)
	MouseClick("left", $pos_loginbuttonx, $pos_loginbuttony)
	Loading()
EndFunc


$answer = MsgBox(4, "Larkinor bot", "Ez egy larkinor bot! A                        oldal legyen megnyitva a bejelentkezésnél. Ugye mehetünk tovább?")
If $answer = 7 Then
    MsgBox(4096, "AutoIt", "OK.  Bye!")
    Exit
EndIf

WinMinimizeAll()
WinActivate("Larkinor", "")
WinSetState("Larkinor", "", @SW_MAXIMIZE)
Sleep(100)
Login()
While 1
Select
	Case StringInStr($data, "A házadban térsz magadhoz") > 0
		Shutdown(1)
	Case StringInStr($data, "mehetsz a kaszinóba") > 0
		Kaszino()
	Case StringInStr($data, "feléd indul!") > 0
		Avoid()
	Case StringInStr($data, "jobb kezedben") > 0
		Leave()
	Case StringInStr($data,"ezzel a karakterrel már") > 0 and StringInStr($data, "Loginnév:") > 0
		Shutdown(1)
	Case Else
		OK()	
Endselect
Wend