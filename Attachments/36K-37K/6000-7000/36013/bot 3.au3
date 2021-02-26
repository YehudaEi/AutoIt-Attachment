#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

GuiCreate("Embedded",887,650,287,16)
$button1=GuiCtrlCreateButton("Go to URL.",368,38,253,26)
$button2=GuiCtrlCreateButton("Stop!",700,38,100,26)
$input1=GuiCtrlCreateInput(" ",36,39,291,20)
$label1=GuiCtrlCreateLabel("Put URL here.",38,23,95,15)
$oIE=_IECreateEmbedded()
$Object=GUICtrlCreateObj($oIE,20,150,300,250)
GuiSetState(@SW_SHOW)

While 1
$msg=GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $button2
		_IEAction($oIE,"Stop")
		
	Case $msg=$button1 
		$read1=GUICtrlRead($input1)
	_IENavigate($oIE,$read1)
	
EndSelect
WEnd