; =======================================================================
; DIRMS GUI <version>
;
; Forum Thread:
;  <link>
;
; To Do:
;  <empty>
; =======================================================================

#include <GUIConstants.au3>

GuiCreate("DIRMS GUI", 200, 200,(@DesktopWidth-200)/2, (@DesktopHeight-200)/2 , 0x04CF0000)

; ==========================
; Main GUI
; ==========================
$gui_generate = GuiCtrlCreateButton("Generate Event", 5, 5, 190, 95)
$gui_terminate = GuiCtrlCreateButton("Terminate Event", 5, 100, 190, 95)
$gui_getmsg = GuiGetMsg()

GUICtrlSetState($gui_terminate, $GUI_DISABLE)

GUISetState()

; ==========================
; Main GUI - Loop
; ==========================
While $gui_getmsg<> -3
	
	$gui_getmsg = GUIGetMsg()
	
	Select
		
		Case $gui_getmsg = $gui_generate
			Generate()
			
	EndSelect
WEnd

Exit

; ==========================
; Running Process
; ==========================
Func Generate()
	
	GUICtrlSetState($gui_terminate, $GUI_ENABLE)
	GLOBAL $v_pid = Run("calc")
	
	Do
		GLOBAL $gui_getmsg = GuiGetMsg()
		
		Select
			
			Case $gui_getmsg = $gui_terminate
				ProcessClose($v_pid)
				GUICtrlSetState($gui_terminate, $GUI_DISABLE)	
				Return
		
			Case $gui_getmsg = $GUI_EVENT_CLOSE
				GUIDelete()
				Exit

		EndSelect

		Sleep(250)
		
	Until ProcessExists($v_pid) = 0
	
EndFunc