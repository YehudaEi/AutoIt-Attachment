#include <A3LScreenCap.au3>
$Form1 = GUICreate("Simple Screenshot Taker 1.0", 284, 42, 193, 115)
$Label1 = GUICtrlCreateLabel("Where do you want the picture saved?", 0, 0, 188, 17)
$Input1 = GUICtrlCreateInput("" & @ScriptDir & "\Picture.bmp", 0, 16, 177, 21)
$Button1 = GUICtrlCreateButton("Go", 192, 0, 43, 17, 0)
$Button2 = GUICtrlCreateButton("Open", 240, 0, 43, 17, 0)
$Button3 = GUICtrlCreateButton("Help", 192, 24, 43, 17, 0)
$Button4 = GUICtrlCreateButton("About", 240, 24, 43, 17, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			GUISetState(@SW_HIDE, $Form1)
			_ScreenCap_Capture (GUICtrlRead($Input1))
			GUISetState(@SW_SHOW, $Form1)
			MsgBox(48, "Simple Screenshot Taker 1.0", "Done!")
		Case $Button2
			Opt("GuiResizeMode", 1)
			$Form12 = GUICreate("Simple Screenshot Taker 1.0 Picture Viewer", 629, 450, "", "", 0x00CF0000, 0x00010000)
			$Pic12 = GUICtrlCreatePic("" & GUICtrlRead($Input1) & "", 0, 0, 628, 420)
			$Button12 = GUICtrlCreateButton("Open Another Picture", 0, 424, 627, 25, 0)
			GUISetState(@SW_SHOW)
			While 2
				$msg2 = GUIGetMsg()
				Select
					Case $msg2 = $GUI_EVENT_CLOSE
						ExitLoop
					Case $msg2 = $Button12
						$OpenPic = FileOpenDialog("Simple Screenshot Taker 1.0 : Select a picture to open", "", "Pictures(*.jpg; *.bmp;)")
						GUICtrlDelete($Pic12)
						GUICtrlCreatePic($OpenPic, 0, 0, 628, 420)
				EndSelect
			WEnd
			GUIDelete($Form12)
			GUISetState(@SW_SHOW, $Form1)
		Case $Button3
			MsgBox(32, "Simple Screenshot Taker 1.0 Help", "This little program takes a picture of your screen and saves it in to an image. To use, type the path of where you want the picture, then press Go. If you press Open, you can view the iamge you just took.")
		Case $Button4
			MsgBox(64, "Simple Screenshot Taker 1.0", "Simple ScreenShot Taker 1.0 Copyright Justin Reno 2007.")
	EndSwitch
WEnd