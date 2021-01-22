#include <GUIConstants.au3>  
Opt("TrayIconDebug",1)
#Region ### START Koda GUI section ### Form=c:\Menu1.kxf
$Form1_1 = GUICreate("Form1", 565, 286, 187, 120)
$Label1 = GUICtrlCreateLabel("Set computer for EOC or Town Hall", 24, 16, 515, 39)
GUICtrlSetFont(-1, 22, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFF0000)
$Label2 = GUICtrlCreateLabel("Enter IP address for EOC operation,", 128, 56, 303, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Or leave blank, to setup for the Town Hall", 112, 88, 335, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("10.10.40.", 160, 136, 144, 41)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$IP = GUICtrlCreateInput("", 304, 128, 97, 45)
GUICtrlSetFont(-1, 24, 400, 0, "MS Sans Serif")
$Button1 = GUICtrlCreateButton("OK", 136, 200, 89, 41, 0)
$Button2 = GUICtrlCreateButton("Cancel", 328, 200, 89, 41, 0)
$Label5 = GUICtrlCreateLabel("03/18/2008", 240, 256, 62, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button2
			MsgBox(4096, "EOC OR TOWN HALL", "CANCELLED", 15)
			Exit
		Case $Button1	
			$aIP = GUICtrlRead($IP)
			MsgBox(4096, "EOC OR TOWN HALL", "10.10.40."& $aIP)
			;I think I should be able to insert a function here and go execute the funcion.
	EndSwitch
WEnd
