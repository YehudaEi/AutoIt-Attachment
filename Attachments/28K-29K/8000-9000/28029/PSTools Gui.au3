#include <GUIConstantsEx.au3>

;Opt('MustDeclareVars', 1)

Example()

Func Example()
	Local $Button_1, $Button_2, $Button_3, $Button_4, $Button_5, $Button_6, $Button_7, $Button_8, $msg
	GUICreate("PS Tooler", 515, 310, -1, -1)
	Dim $input

	
	Opt("GUICoordMode", 2)
	$Button_1 = GUICtrlCreateButton("PSloggedon", 10, 50, 125)
	$Button_2 = GUICtrlCreateButton("PSInfo", -1, 1)
	$Button_3 = GUICtrlCreateButton("Ping Host", -1, 1)
	$Button_4 = GUICtrlCreateButton("PSExec", -1, 1)
	$Button_5 = GUICtrlCreateButton("PSShutdown", -1, 1)
	$Button_6 = GUICtrlCreateButton("PSList", -1, 1)
	$Button_7 = GUICtrlCreateButton("PSKill", -1, 1)
	$Button_8 = GUICtrlCreateButton("Desktop H/W", -1, 1)

	$input = GuiCtrlCreateInput("your host name", -1, 10, 350, 20)
	;$input = GuiCtrlCreateInput("application to ps kill", -1, 1)


GUISetState()      


While 1
$msg = GUIGetMsg()
Select
Case $msg = $GUI_EVENT_CLOSE
ExitLoop


Case $msg = $Button_1
run ("cmd")
WinWaitActive("")
send ("cd c:\temp\ps {ENTER}")
Send('psloggedon \\' & $input)




Case $msg = $Button_2
; MS WINDOWS	
run ("cmd")
WinWaitActive("")
send ("cd c:\temp\ps {ENTER}")
Send('psinfo \\' & $input)









Case $msg = $Button_3

				




Case $msg = $Button_4

				
				
				
				



Case $msg = $Button_5







Case $msg = $Button_6










Case $msg = $Button_7

			








Case $msg = $Button_8

			
			



			
		EndSelect
	WEnd
EndFunc   