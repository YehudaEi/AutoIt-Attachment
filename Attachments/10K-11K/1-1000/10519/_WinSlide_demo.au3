#include <GUIConstants.au3>
#include "_WinSlide.au3"

$gui = GUICreate("WinSlide demo - DaLiMan",300,100,@DesktopWidth,@DesktopHeight)

$But_Start = GUICtrlCreateButton("Start Random Slide",20,20,100,20)
$But_Stop = GUICtrlCreateButton("Exit",20,60,100,20)

GUISetState()
	_WinSlide($gui, 150, 150, 50, 250)
	_WinSlide($gui, -100, -100, 50, 250)
	_WinSlide($gui, 50, 50, 50, 750)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $But_Stop
		ExitLoop
	Case $msg = $But_Start
		_WinSlide($gui, Random(50,600), Random(50,600), 50, 1000)
	Case Else
		;;;
	EndSelect
WEnd
Exit


