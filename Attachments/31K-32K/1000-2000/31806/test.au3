#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


GUICreate("Slim Computers", 360, 315)
$button1 = GUICtrlCreateButton("Winamp", 21, 10, 70, 30)
$button2 = GUICtrlCreateButton("Nero 6", 21, 40, 70, 30)
$button3 = GUICtrlCreateButton("Adobe9.1bg", 21, 70, 70, 30)
$button4 = GUICtrlCreateButton("avast.free", 21, 101, 70, 30)
$button5 = GUICtrlCreateButton("BSPlayer2.56", 21, 132, 70, 30)
$button6 = GUICtrlCreateButton("6", 21, 163, 70, 30)
$button7 = GUICtrlCreateButton("7", 21, 194, 70, 30)
$button8 = GUICtrlCreateButton("8", 21, 225, 70, 30)
$button9 = GUICtrlCreateButton("9", 142, 10, 70, 30)
$button10 = GUICtrlCreateButton("10", 142, 40, 70, 30)
$button11 = GUICtrlCreateButton("11", 142, 70, 70, 30)
$button12 = GUICtrlCreateButton("12", 142, 101, 70, 30)
$button13 = GUICtrlCreateButton("13", 142, 132, 70, 30)
$button14 = GUICtrlCreateButton("14", 142, 163, 70, 30)
$button15 = GUICtrlCreateButton("15", 142, 194, 70, 30)
$button16 = GUICtrlCreateButton("16", 142, 225, 70, 30)
$button17 = GUICtrlCreateButton("17", 268, 10, 70, 30)
$button18 = GUICtrlCreateButton("18", 268, 40, 70, 30)
$button19 = GUICtrlCreateButton("19", 268, 70, 70, 30)
$button20 = GUICtrlCreateButton("20", 268, 101, 70, 30)
$button21 = GUICtrlCreateButton("21", 268, 132, 70, 30)
$button22 = GUICtrlCreateButton("22", 268, 163, 70, 30)
$button23 = GUICtrlCreateButton("23", 268, 194, 70, 30)
$button24 = GUICtrlCreateButton("24", 268, 225, 70, 30)
$button25 = GUICtrlCreateButton("25", 1, 270, 70, 30)
$button26 = GUICtrlCreateButton("26", 72, 270, 70, 30)
$button27 = GUICtrlCreateButton("27", 144, 270, 70, 30)
$button28 = GUICtrlCreateButton("28", 217, 270, 70, 30)
$button29 = GUICtrlCreateButton("29", 290, 270, 70, 30)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	If $msg = -3 Then Exit
	If $msg = $button1 Then button1()
	If $msg = $button2 Then button2()
	If $msg = $button3 Then button3()
	If $msg = $button4 Then button4()
	If $msg = $button5 Then button5()
	If $msg = $button6 Then button6()
	If $msg = $button7 Then button7()
	If $msg = $button8 Then button8()
	If $msg = $button9 Then button9()
	If $msg = $button10 Then button10()
	If $msg = $button11 Then button11()
	If $msg = $button12 Then button12()
	If $msg = $button13 Then button13()
	If $msg = $button14 Then button14()
	If $msg = $button15 Then button15()
	If $msg = $button16 Then button16()
	If $msg = $button17 Then button17()
	If $msg = $button18 Then button18()
	If $msg = $button19 Then button19()
	If $msg = $button20 Then button20()
	If $msg = $button21 Then button21()
	If $msg = $button22 Then button22()
	If $msg = $button23 Then button23()
	If $msg = $button24 Then button24()
	If $msg = $button25 Then button25()
	If $msg = $button26 Then button26()
	If $msg = $button27 Then button27()
	If $msg = $button28 Then button28()
	If $msg = $button29 Then button29()

WEnd




Func button1()
	If not FileExists("Winamp.exe") Then MsgBox(0, "", "No such file Winamp")
	if FileExists("C:\Program Files\Winamp\Winamp.exe") Then MsgBox(0, "", "Winamp is installed")
	if Not FileExists("C:\Program Files\Winamp\Winamp.exe") Then Run("Winamp.exe")
	If WinActive("Open File - Security Warning", "") Then Send("{LEFT}{SPACE}")
	WinWaitActive("[CLASS:#32770]", "Please review the license")
	Sleep(500)
	Send("{ENTER}")
	WinWaitActive("[CLASS:#32770]", "Choose Components")
	Send("{TAB}")
	Sleep(70)
	Send("{DOWN}")
	Sleep(70)
	Send("{SPACE}")
	Sleep(70)
	Send("{DOWN}")
	Sleep(70)
	Send("{SPACE}")
	Sleep(70)
	Send("{DOWN 4}")
	Sleep(70)
	Send("{SPACE}")
	Send("{ENTER}")
	WinWaitActive("[CLASS:#32770]", "Select icons to install and media")
	Send("{DOWN 3}")
	Sleep(70)
	Send("{SPACE}")
	Sleep(50)
	Send("{DOWN 2}")
	Sleep(70)
	Send("{SPACE}")
	Sleep(70)
	Send("{ENTER}")
	WinWaitActive("[CLASS:#32770]", "Choose the folder in which to install Winamp.")
	Send("{ENTER}{ENTER}{DOWN 2}{ENTER}{ENTER}")
	WinWaitClose("[CLASS:#32770]", "Please wait while Winamp is being installed.")
	GUICtrlCreateLabel("+", 10, 15, 10, 10)
	FileDelete("Winamp.exe")
	MsgBox(48, "---===---", "Winamp installed")
EndFunc   ;==>button1

Func button2()
	Run("Nero 6.exe")
	If WinActive("Open File - Security Warning", "") Then Send("{LEFT}{SPACE}")
	WinWaitActive("[CLASS:#32770]", "Welcome to the Installation Wizard for Nero")
	Send("{ENTER}")
	WinWaitActive("[CLASS:#32770]", "Please read the following license")
	Send("{TAB}")
	Sleep(70)
	Send("{UP}{ENTER}")
	WinWaitActive("[CLASS:#32770]", "Customer information.")
	Send("1A23-0809-9130-2342-3399-9284")
	Send("{ENTER}")
	WinWaitActive("[CLASS:#32770]", "The Wizard has completed")
	Send("{TAB}")
	Sleep(70)
	Send("{DOWN 2}")
	Sleep(70)
	Send("{SPACE}{TAB}{SPACE}")
EndFunc   ;==>button2

Func button3()
	Run("AdbeRdr910_bg_BG")
	If WinActive("Open File - Security Warning", "") Then Send("{LEFT}{SPACE}")
	WinWaitActive("[CLASS:MsiDialogCloseClass]", "Кликнете Следващ, за да инсталирате в тази")
	Send("{ENTER}{ENTER}")
	WinWaitActive("[CLASS:MsiDialogCloseClass]", "Ако искате да прегледате или промените")
	Send("{ENTER}")
	WinWaitActive("[CLASS:MsiDialogCloseClass]", "Adobe Reader 9.1 е инсталиран успешно.")
	Send("{ENTER}")
EndFunc   ;==>button3

Func button4()
	Run("avast.free.exe")
	If WinActive("Open File - Security Warning", "") Then Send("{LEFT}{SPACE}")
	WinWaitActive("avast! Free Antivirus Setup", "Инсталация на avast!")
	Send("{ENTER}")
	WinWaitActive("avast! Free Antivirus Setup", "Благодарим ви, че избрахте avast!.")
	Send("{TAB 3}{SPACE}{ENTER}")
	WinWaitActive("[CLASS:32770]", "Инсталирайки Google Chrome")
	Send("{TAB 3}{DOWN}{SPACE}{DOWN}{ENTER}")
	WinWaitActive("[CLASS:32770]", "Инсталацията завърши")
	Send("{ENTER}")
EndFunc   ;==>button4

Func button5()
	Run("bsplayer256.exe")
	If WinActive("Open File - Security Warning", "") Then Send("{LEFT}{SPACE}")
	WinWaitActive("BS.Player FREE Setup", "before installing BS.Player")
	Sleep(70)
	Send("{ENTER}")
	WinWaitActive("BS.Player FREE Setup", "It is recommended that you close")
	Sleep(70)
	Send("{ENTER}")
	WinWaitActive("BS.Player FREE Setup", "Choose which features")
	Send("{Enter}")
	WinWaitActive("BS.Player FREE Setup", "Additional install options")
	Send("{DOWN}{TAB}{DOWN}{ENTER}")
	WinWaitActive("BS.Player FREE Setup", "Select default language")
	Send("{ENTER}")
	WinWaitActive("BS.Player FREE Setup", "BS.Player ControlBar")
	Send("{TAB 2}{SPACE}{DOWN}{SPACE}{DOWN}{SPACE}")
	Sleep(70)
	Send("{ENTER}")
	WinWaitActive("BS.Player FREE Setup ", "Setup has determined the optimal")
	Send("{ENTER}")
	WinActivate("BS.Player", "BS.Player has detected that some required")
	WinWaitActive("BS.Player", "BS.Player has detected that some required")
	Send("{ENTER}")
	WinWaitActive("BS.Player FREE Setup ", "Setup was completed successfully.")
	Send("{ENTER}")
	Sleep(100)
	Send("{ENTER}")
EndFunc   ;==>button5

Func button6()
EndFunc   ;==>button6

Func button7()
EndFunc   ;==>button7

Func button8()
EndFunc   ;==>button8

Func button9()
EndFunc   ;==>button9

Func button10()
EndFunc   ;==>button10

Func button11()
EndFunc   ;==>button11

Func button12()
EndFunc   ;==>button12

Func button13()
EndFunc   ;==>button13

Func button14()
EndFunc   ;==>button14

Func button15()
EndFunc   ;==>button15

Func button16()
EndFunc   ;==>button16

Func button17()
EndFunc   ;==>button17

Func button18()
EndFunc   ;==>button18

Func button19()
EndFunc   ;==>button19

Func button20()
EndFunc   ;==>button20

Func button21()
EndFunc   ;==>button21

Func button22()
EndFunc   ;==>button22

Func button23()
EndFunc   ;==>button23

Func button24()
EndFunc   ;==>button24

Func button25()
EndFunc   ;==>button25

Func button26()
EndFunc   ;==>button26

Func button27()
EndFunc   ;==>button27

Func button28()
EndFunc   ;==>button28

Func button29()
EndFunc   ;==>button29