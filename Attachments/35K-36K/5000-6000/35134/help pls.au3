;i would likte to write a script here to make my script always top on or could you help me to create a form and, when i click to checkbox the window will be always top , otherwise it will not be always top on ?
; Press Esc to terminate script, Pause/Break to "pause"

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage")  ;Shift-Alt-d
hotkeyset("$button2","TogglePause")
sleep(2000)
msgbox(0,"Thomas Tarafýndan Yazýlmýþtýr...","KnightOnline penceresindeyken Tamam'a basýnýz")
sleep(1000)
MsgBox(0,"Ayarlarý Aþaðýdaki gibi ayarladýktan sonra Tamam'a týklayýnýz", "1'e skill(70 mana harcayan)--- 5'e wolf(120 sn de bir basar)---7'e 480 lik mana potu ------8 'e 360 lýk hp potu koyunuz.")




#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 121, 145, 192, 124)
$Button1 = GUICtrlCreateButton("Button1", 8, 8, 105, 33)
$Button2 = GUICtrlCreateButton("Button2", 8, 48, 105, 33)
$Input1 = GUICtrlCreateInput("Input1", 8, 88, 105, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit



		case $Button1
			$x=0
			do

  $b=$Input1  ; i would like to make a input number on the form, when i enter a number  it will change the  loop number $b,and when i pressed to the button1 it will start with this option(loop number of $b) but i didnt :(
sleep(500)

	$time = Timerinit()
Do
Send("{5}")
sleep(150)

until TimerDiff($time) > 1800


for $a=1 to $b step 1


$time = Timerinit()
Do
Send("{z}")
sleep(30)
Send("{1}")
until TimerDiff($time) > 4000



$time = Timerinit()
Do
sleep(50)
Send("{7}")
sleep(50)
until TimerDiff($time) > 650




$time = Timerinit()
Do
Send("{z}")
sleep(30)
Send("{1}")
until TimerDiff($time) > 4000



$time = Timerinit()
Do
sleep(50)
Send("{8}")
sleep(50)
until TimerDiff($time) > 650



Next


sleep(500)



until $x=1

case $button2
; i would like to write a script here to pause the all script when i pressed to this button.
send("{Pause}")   ;, i thought that while my script working, when i pressed button2 it will send pause button and the script will pause, but the loop always continue, and when i change my window, it will not work so it requires always top on.


	EndSwitch
WEnd


; input yazan yere hiç birþey eklenmez ise yaklasýk 50 sn de bir 5 tuþuna basar,
;wolf için , eðer 2 dk sürüyorsa wolf, inputa 13 koymamýz lazým



While 1
    Sleep(100)
WEnd
;;;;;;;;
func $Button2

	 Send("{Esc}")
WEnd
Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc

Func Terminate()
    Exit 0
EndFunc

Func ShowMessage()
    MsgBox(4096,"","This is a message.")
EndFunc
