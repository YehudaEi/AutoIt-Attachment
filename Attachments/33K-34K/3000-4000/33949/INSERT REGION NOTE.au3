#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\..\..\Icons\Letter i - 2.ico
#AutoIt3Wrapper_Outfile=Insert Region.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
$file = WinGetTitle("[CLASS:SciTEWindow]")
ClipPut("")
#Region ### START Koda GUI section ### Form=C:\Users\Henry\Documents\AUTOIT\AUTOIT FILES\P R O J E C T S\Utilities\INSERT REGION WITH TEXT & COMMENTS\Form1_1.kxf
$Form1_1 = GUICreate("INSERT REGION NOTE       ( Esc to Exit )", 285, 145 + 30, 521, 305, BitOR($DS_MODALFRAME, $DS_SETFOREGROUND), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE)) ; 521, 305  $GUI_SS_DEFAULT_GUI, $WS_POPUP,
GUISetBkColor(0xFFFFFF) ; GUISetBkColor(0xEF0C08)    ;GUISetBkColor(0xFFFFFF)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
$Input = GUICtrlCreateInput("", 70 - 5, 88, 153, 21)
$Label3 = GUICtrlCreateLabel("THEN CLICK <> HERE", 72 - 7, 120, 150 + 20, 17)
GUICtrlSetFont(-1, 11, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Label3Click")
$Label1 = GUICtrlCreateLabel("(If desired)   COPY ANY TEXT", 55 - 11, 8, 140 + 20 + 30, 17)
GUICtrlSetFont(-1, 7, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Place Cursor At The End Of The Line In The", 2, 28, 517, 17)
GUICtrlSetFont(-1, 7, 800, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Line Above Where The Region Is To Be Written.", 2, 48, 275 + 10, 17) ;  275, 17)  Line Above Where You Want To Write The Region.
GUICtrlSetFont(-1, 7, 800, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel("ENTER ANY COMMENTS", 55 + 18 - 5, 72, 151, 17) ; 131, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func Form1_1Close()
	Exit
EndFunc   ;==>Form1_1Close
Func Label3Click()
	$comment = GUICtrlRead($Input)
	$msg = ClipGet()
	$Dick = "#Region #### " & $msg & " " & $comment
	ClipPut($Dick)
	WinActivate($file)
	Send("{ENTER}")
	Sleep(50)
	Send("^v")
	Exit
EndFunc   ;==>Label3Click
Func Label4Click()

EndFunc   ;==>Label4Click
Func Label5Click()

EndFunc   ;==>Label5Click