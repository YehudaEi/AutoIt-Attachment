#include <Google Maps.au3>

Dim $msg, $ge
Global $main_gui

MsgBox(48, "Google Earth Example", "Note - you must have inserted a Google Maps API key into this script before continuing")

; Setup Main GUI
$main_gui = GUICreate("Google Earth Example", 800, 600, -1, -1, BitOR($WS_SIZEBOX, $WS_MAXIMIZEBOX))
$ge_ctrl = _GUICtrlGoogleEarth_Create($ge, "put your Google Maps API key here", 0, 10, 800, 450, "Palm Beach, Queensland, Australia", 10000, 0.1)
GUICtrlSetResizing($ge_ctrl, $GUI_DOCKTOP)
$close_button = GUICtrlCreateButton("Close (Esc)", 650, 515, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)

dim $main_gui_accel[1][2]=[["{ESC}", $close_button]]

; Show Main GUI
GUISetState(@SW_SHOW)
GUISetAccelerators($main_gui_accel)

; Main Loop
while 1
	
	If $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()
