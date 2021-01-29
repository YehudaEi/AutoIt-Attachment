#include <GUIConstantsEx.au3>

;Opt('MustDeclareVars', 1)

Example()

Func Example()
	Local $Button_1, $msg
	GUICreate("Ping", 515, 310, -1, -1)
	;Dim $input

	
	Opt("GUICoordMode", 2)
	$Button_1 = GUICtrlCreateButton("Ping Test", 10, 50, 125)


	$input = GuiCtrlCreateInput("your host name", -1, 10, 350, 20)



GUISetState()      


While 1
$msg = GUIGetMsg()
Select
Case $msg = $GUI_EVENT_CLOSE
ExitLoop


Case $msg = $Button_1
run ("cmd")
WinWaitActive("")
Send('ping' & $input' {ENTER}')



			
			



			
		EndSelect
	WEnd
EndFunc   