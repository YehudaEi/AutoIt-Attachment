#include <GUIConstants.au3>
#Include <GuiList.au3>

Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode",4)
Opt("WinSearchChildren",1)
Opt("WinDetectHiddenText", 1)
#Region ### START Koda GUI section ### Form=scitefunc.kxf
$Form1 = GUICreate("Functions", 202, 386, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS), BitOR($WS_EX_APPWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Group3 = GUICtrlCreateGroup("Matches", 0, 0, 201, 385)
$List1 = GUICtrlCreateList("", 8, 48, 185, 331)
$Button1 = GUICtrlCreateButton("refresh", 8, 16, 187, 25, 0)
GUICtrlSetOnEvent(-1, "AButton1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $pattern = "Func\s+\w+\([^\)]*\)"

GUISetOnEvent($GUI_EVENT_CLOSE, "Bye")

Func Bye()
	Exit
EndFunc

Func AButton1Click()
	$subject = WinGetText("classname=SciTEWindow","Source")
	$handle = WinGetHandle("classname=SciTEWindow")
	$matches = StringRegExp($subject,$pattern,3)
	
	GUICtrlSetData($List1,"")
    for $i = 0 to UBound($matches) - 1
		_GUICtrlListAddItem($List1,$matches[$i])
    Next
EndFunc

While 1
	Sleep(100)
WEnd

