#include <GUIConstants.au3>
#NoTrayIcon

GUICreate("Login",250,200)
GuiSetIcon("shell32.dll",47)

SoundPlay("D:\auto-it_scripts\sound\loop1.wav")

$romdrive = @ScriptDir

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
$ejectitem = GuiCtrlCreateMenuitem ("Eject",$helpmenu)

GUICtrlCreateLabel("Login :", 25, 21, 55, 20)
GUICtrlCreateInput("User name", 90, 20, 100, 20)
GUICtrlSetTip(-1, "Type your user name.")

;InputBox ( "", "Prompt", "Password", "*", 90, 20, 100, 20)

GUICtrlCreateLabel("Password :", 25, 71, 55, 20)
GUICtrlCreateInput("Password", 90, 70, 100, 20)
GUICtrlSetTip(-1, "Type your password.")

$okbutton = GuiCtrlCreateButton ("OK",40,130,70,20,$BS_DEFPUSHBUTTON)
$cancelbutton = GuiCtrlCreateButton ("Cancel",150,130,70,20)

GuiSetState()

While 1

	$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			ExitLoop
		
		Case $msg = $exititem
			ExitLoop

		Case $msg = $ejectitem
			CDTray ( $romdrive , "open" )
			ExitLoop


		Case $msg = $aboutitem
			Msgbox(0,"Login","Compiled with AutoIt3")

		Case $msg = $okbutton
			
			$val1 = GUICtrlRead ( 9 )
			$val2 = GUICtrlRead ( 11 )

			Select
			Case $val1<> ""& @UserName OR $val2<>"pass"
				Msgbox(64,"Login","Wrong info")
			
			Case $val1=""& @UserName AND $val2="pass"
				Run("Notepad.exe")
				ExitLoop

			EndSelect		
		
	EndSelect
WEnd

GUIDelete()

Exit
