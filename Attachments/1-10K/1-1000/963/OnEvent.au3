#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
GuiCreate("OnEvent", 200, 200,(@DesktopWidth-200)/2, (@DesktopHeight-200)/2 , 0x04CF0000)

$Generate_bch = GuiCtrlCreateButton("Generate Event", 5, 5, 190, 95)
$Terminate_bch = GuiCtrlCreateButton("Terminate Event", 5, 100, 190, 95)

GUICtrlSetState($Terminate_bch, $GUI_DISABLE)
GUICtrlSetOnEvent($Generate_bch, "Generate")
GUICtrlSetOnEvent($Terminate_bch, "Terminate")
GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript")

GUISetState()

While 1
	;;;
WEnd

Exit

Func Generate()
	GUICtrlSetState($Terminate_bch, $GUI_ENABLE)
	GLOBAL $PID = Run("calc")
	Do
		GuiGetMsg()
		Sleep(250)
	Until ProcessExists ( $PID ) = 0
EndFunc

Func Terminate()
	If IsDeclared("PID") <> 0 Then
		MsgBox(0, "", "Terminate: " & $PID)
		ProcessClose($PID)
	Else
		MsgBox(0, "", "Generate Event first")
	EndIf
EndFunc

Func ExitScript()
	Exit
EndFunc