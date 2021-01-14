;~ Name: SimplePlayer 1.0
;~ Author: ToKico Brothers
;~ 		   tokico.pt@gmail.com
;~ Description: This script is a very simple music player.

#include <GUIConstants.au3>

#Region ### START Koda GUI section ###
$Form2 = GUICreate("  SimplePlayer 1.0", 226, 61, 303, 219)
$Button1 = GUICtrlCreateButton("Play", 8, 8, 65, 25, 0)
$Button2 = GUICtrlCreateButton("Stop", 152, 8, 65, 25, 0)
$Button3 = GUICtrlCreateButton("Open", 80, 24, 65, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button3
			$opendialog = FileOpenDialog ( "Open Music...", @ScriptDir, "Music (*.*)")
		Case $Button1
			SoundPlay ( $opendialog )
		Case $Button2
			SoundPlay ( "" )
	EndSwitch
WEnd