Opt("GUIOnEventMode", 1)
#include <GUIConstants.au3>
#include "md5_UDF.au3"
Global $Form1, $Input1, $Input2
Global $in = "string"
$Form1 = GUICreate("md5 demo", 434, 53, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION, _
$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$Input1 = GUICtrlCreateInput("", 4, 4, 425, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL))
$Input2 = GUICtrlCreateInput("", 4, 28, 425, 21, BitOR($ES_CENTER,$ES_READONLY))
GUISetOnEvent($GUI_EVENT_CLOSE, "mainExit")
GUISetState(@SW_SHOW, $Form1)

Do
	If GUICtrlRead($Input1) <> $in Then
		$in = GUICtrlRead($Input1)
		GUICtrlSetData($Input2, _StringMD5($in))
	EndIf
	Sleep(250)
Until False
Exit

Func mainExit()
	Exit
	Return
EndFunc