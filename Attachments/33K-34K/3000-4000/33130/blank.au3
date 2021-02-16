#include <WindowsConstants.au3>
#include <EditConstants.au3>

Opt("GUIOnEventMode", 1)

$Form1_1 = GUICreate("Sample Data Input GUI", 418, 97, 471, 200, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE)) ; height = 107  width = 413
GUISetBkColor(0xFFFFFF)
$input = GUICtrlCreateInput("", 134, 28, 153, 21, $GUI_SS_DEFAULT_INPUT) ;;; 48  left = 132
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetOnEvent(-1, "ReadInfo")

$font = "Franklin Gothic Demi Cond" ;Kalinga Bold"     ;Lucida Console"     ;MS Sans Serif"     ;Arial Rounded MT Bold"
GUISetFont(12, Default, Default, $font) ;Arial_Rounded_MT_Bold")     ;Segoe UI")

$Label1 = GUICtrlCreateLabel("MAKE SURE THE FIRST RECORD YOU WANT COPIED IS HIGHLIGHTED!", 2, 8, Default, 17, 0) ;;;; 8  left = 20  width = 370
GUICtrlSetColor(-1, 0x0F296E)
$font = "MS Sans Serif" ;Lucida Console"     ;MS Sans Serif"     ;Arial Rounded MT Bold"
GUISetFont(8, Default, Default, $font)
$Label2 = GUICtrlCreateLabel("ENTER THE NUMBER OF CONSECTUVE RECORDS YOU WANT COPIED.", 22, 54, 373, 17, 0) ;;;; 28 left = 20 top = 53
$Label3 = GUICtrlCreateLabel("THEN PRESS ENTER", 152, 71, 113, 17, 0) ;;; 80  left = 150 top = 70
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func ReadInfo()
	Sleep(100)
	$end = GUICtrlRead($input)
	GUISetState(@SW_MINIMIZE, $Form1_1)
	MsgBox(0,"",$end)  ; Demo
	; The rest of your program here
	Exit
EndFunc   ;==>ReadInfo