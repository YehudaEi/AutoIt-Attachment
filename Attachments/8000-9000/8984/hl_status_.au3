
$IPVALUE = "83.142.80.79"
$PORTVALUE = 27040


#include <GuiConstants.au3>

$GUI = GuiCreate("Test", 500, 340)

$Edit_2 = GuiCtrlCreateEdit("", 10, 30, 479, 260)
$Input_3 = GUICtrlCreateInput("", 10, 300, 390, 20)
$Button_4 = GuiCtrlCreateButton("Send", 410, 300, 80, 20, $BS_DEFPUSHBUTTON)
GuiSetState()


UDPStartUp()


While 1
	$msg = GuiGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then 
		ExitLoop
	If $msg = $Button_4 Then 
		$SendData = UDPSend($socket, GUICtrlRead($Input_3))
		
		If $SendData > 0 Then GUICtrlSetData($Edit_2, GUICtrlRead($Edit_2) & GUICtrlRead($Input_3) & @CRLF)
		GUICtrlSetData($Input_3,"") 
	EndIf

	$Recivedata = TCPRecv($socket, "")
	If $Recivedata <> "" Then 
		GUICtrlSetData($Edit_2, GUICtrlRead($Edit_2) & $Recivedata & @CRLF)
	EndIf
WEnd


Func OnAutoItExit()
    TCPCloseSocket($socket)
    TCPShutDown()
EndFunc
