;script build by Gorgan Adrian
AutoItSetOption("TrayIconDebug")
#include <GuiConstants.au3>
GuiCreate("Mikidutza's LogonChager", 392, 250,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Label_1 = GuiCtrlCreateLabel("This program is special bild to change the windows logon! In the input space you can insert special comments to personalize your windows.", 180, 10, 200, 130)
$input_7 = GuiCtrlCreateInput("",105,170,245,15)
$Pic_2 = GuiCtrlCreatePic(RegRead("HKEY_USERS\.DEFAULT\Control Panel\Desktop","Wallpaper"), 10, 10, 160, 140,"",$WS_EX_STATICEDGE)
$Button_4 = GuiCtrlCreateButton("Get image", 10, 170, 90, 19)
$Button_5 = GuiCtrlCreateButton("*", 10, 220, 15, 15)
$Button_6 = GuiCtrlCreateButton("Build", 140, 222, 210, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Button_5
		MsgBox(0,"CopyRight","           LogonChanger"& @CRLF&"          version 1.4.9.1 "& @CRLF&"             created by "& @CRLF&"Gorgan Adrian <-> Mikidutza")
	Case $msg = $Button_4
		$dial = FileOpenDialog("Mikidutza's LogoChager",@MyDocumentsDir,"Bitmap image(*.bmp)")
		$str = StringMid($dial,2,2)
		If $str = ":\" Then
		GUICtrlSetData($input_7, $dial)
		GUICtrlSetImage($Pic_2,$dial)
		EndIf
		Case $msg = $Button_6
				RegWrite("HKEY_USERS\.DEFAULT\Control Panel\Desktop","Wallpaper","REG_SZ",$dial)
				$m = MsgBox(4,"LogonChanger","For the changes to activate you must restart the computer!"&@LF&"Do you want to restart your computer now?")
				If $m = 7 then 
					ExitLoop
				EndIf
				Shutdown(2)
				Exit
			EndSelect
		WEnd
	Exit


