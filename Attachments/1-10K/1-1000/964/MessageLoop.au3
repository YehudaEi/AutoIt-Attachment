#include <GUIConstants.au3>

GuiCreate("MessageLoop", 200, 200,(@DesktopWidth-200)/2, (@DesktopHeight-200)/2 , 0x04CF0000)

$Generate_bch = GuiCtrlCreateButton("Generate Event", 5, 5, 190, 95)
$Terminate_bch = GuiCtrlCreateButton("Terminate Event", 5, 100, 190, 95)

GUICtrlSetState($Terminate_bch, $GUI_DISABLE)
GUISetState()

$msg = GUIGetmSG()
While $msg <> -3
	$msg = GUIGetMsg()
	Select
		Case $msg = $Generate_bch
			GUICtrlSetState($Terminate_bch, $GUI_ENABLE)
			GLOBAL $PID = Run("calc")
			Do
				GuiGetMsg()
				Sleep(250)
			Until ProcessExists ( $PID ) = 0
		Case $msg = $Terminate_bch
			If IsDeclared("PID") <> 0 Then
				MsgBox(0, "", "Terminate: " & $PID)
				ProcessClose($PID)
			Else
				MsgBox(0, "", "Generate Event first")
			EndIf
	EndSelect
WEnd

Exit