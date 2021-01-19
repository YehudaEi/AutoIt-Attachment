#include <GUIConstants.au3>
$drives_combo=""
Opt("TrayIconHide",1)
$dr = DriveGetDrive( "CDROM" )
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("TimooEject", 131, 96)
$drive_letter = GUICtrlCreateCombo(StringUpper($dr[1]), 10, 15, 110, 25)
sd()
$open = GUICtrlCreateButton("Open", 10, 40, 50, 20, 0)
$close = GUICtrlCreateButton("Close", 70, 40, 50, 20, 0)
$auto = GUICtrlCreateButton("Open/Close in 10 sec", 10, 65, 110, 20, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $open
		CDTray(GUICtrlRead($drive_letter),"open")
		Case $close
		CDTray(GUICtrlRead($drive_letter),"close")
	Case $auto
		CDTray(GUICtrlRead($drive_letter),"open")
		Sleep(10000)
		CDTray(GUICtrlRead($drive_letter),"close")
	EndSwitch
WEnd
Func sd()
	If Not @error Then
	For $i=2 To $dr[0]
	;$label=
	$drives_combo&=StringUpper($dr[$i])&"|"
Next
$i=0
EndIf
GUICtrlSetData($drive_letter, $drives_combo)
EndFunc