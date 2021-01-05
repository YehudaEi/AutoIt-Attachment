#include <GUIConstants.au3>

GUICreate("Login",250,200)
;GUISetBkColor ( 0xBAD3FC )
GuiSetIcon("shell32.dll",47)

GUICtrlCreatePic(@Systemdir & "\oobe\images\wpakey.jpg",0,0, 250,200)
GuiCtrlSetState(-1, $GUI_DISABLE)

;GUISetBkColor ( 0xBAD3FC )

AutoItSetOption("GUICloseOnESC", 0)

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)


GUICtrlCreateLabel("Login :", 30, 21, 55, 20)
;~ GUICtrlSetColor(-1,0xff0000)    ; Red
$login = GUICtrlCreateInput("User name", 90, 20, 100, 20)
GUICtrlSetTip(-1, "Type your user name.")

GUICtrlCreateLabel("Password :", 30, 71, 55, 20)
$password = GUICtrlCreateInput("Password", 90, 70, 100, 20, $ES_PASSWORD)
GUICtrlSetTip(-1, "Type your password.")

$okbutton = GuiCtrlCreateButton ("OK",40,130,70,20, $BS_DEFPUSHBUTTON)
$cancelbutton = GuiCtrlCreateButton ("Cancel",150,130,70,20)

GuiSetState()

While 1
	$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			ExitLoop
		
		Case $msg = $exititem
			ExitLoop

		Case $msg = $aboutitem
			Msgbox(0,"Login","Compiled with AutoIt3")

		Case $msg = $okbutton
			
			$val1 = GUICtrlRead ( 9 )
			$val2 = GUICtrlRead ( 11 )

			Select
			Case $val1<>"user" Or $val2<>"pass"
				Msgbox(64,"Login","Wrong info")
					
			
			Case $val1="user" And $val2="pass"
				Run("Notepad.exe")
				ExitLoop

			EndSelect		
		
	EndSelect
WEnd

GUIDelete()

Exit
