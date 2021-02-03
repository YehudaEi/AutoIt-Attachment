#include <GuiConstantsEx.au3>
#include <IE.au3>



MainGui()

Func MainGui()



	Local $Run, $Button_2, $msg
	GUICreate("Short Cuts") ; will create a dialog box that when displayed is centered

	Opt("GUICoordMode", 2)
	$Run = GUICtrlCreateButton("Run Somthing", 0, 0, 100)
	$Button_2 = GUICtrlCreateButton("Go to a website", 0, -1)

	GUISetState()      ; will display an  dialog box with 2 button

	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Run
				$program = InputBox ("What program?", "Type program name and extestion here")
					Run($program)
			
			Case $msg = $Button_2
				$program = InputBox ("Which website?", "Type website name here")
					
					Dim $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36,"Ready?","Do you have Internet Explorer running?")
		Select
				Case $iMsgBoxAnswer = 6 ;Yes
							
				Case $iMsgBoxAnswer = 7 ;No
	WEnd
EndSelect
					Run($program)
			
EndFunc