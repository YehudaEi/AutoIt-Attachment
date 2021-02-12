#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\surinder pal singh\desktop\autoit-projects\amd spec search\cpu_spec_search.kxf
$Form1_1 = GUICreate("Form1", 547, 582, 188, 118)
$Label1 = GUICtrlCreateLabel("SPEC SERACH", 192, 16, 137, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x008000)
$Label2 = GUICtrlCreateLabel("MODEL:", 112, 64, 54, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input1_Model = GUICtrlCreateInput("", 192, 64, 153, 21)
$Button1 = GUICtrlCreateButton("SEARCH", 360, 62, 81, 25)
$Button2 = GUICtrlCreateButton("EXIT", 464, 529, 73, 33)
$Pic1 = GUICtrlCreatePic("C:\Users\Surinder Pal Singh\Desktop\guipic1.jpg", 80, 96, 380, 476)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
