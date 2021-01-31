#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <Constants.au3>
#include <WinAPI.au3>

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Ping", 587, 461, 192, 124)
$Button1 = GUICtrlCreateButton("Ping!", 72, 384, 121, 33, $WS_GROUP)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
$Input1 = GUICtrlCreateInput("", 120, 80, 345, 28)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton("Reset", 232, 384, 121, 33, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Exit", 391, 386, 121, 33, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Enter an IP Address or Hostname:", 120, 40, 279, 24)
$Button4 = ""
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$edit1 = GUICtrlCreateEdit("", 80, 120, 425, 257)
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
_WinAPI_SetFocus(ControlGetHandle("Ping", "", $Input1))
#EndRegion ### END Koda GUI section ###




While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			_CMDreturn('ping ' & GUICtrlRead($Input1))
		Case $Button2
			GUICtrlSetData($Input1, "")
		Case $Button3
			Exit
		CASE $Button4
	EndSwitch
WEnd

Func _CMDreturn($sCommand) ; This function returns the output of a DOS command as a string
	If $sCommand = "" Then
		MsgBox(1, "Error", "Enter a Hostname or IP Address")
	Else
		$cmdreturn = ""
		$stream = Run(@ComSpec & " /c " & $sCommand, @SystemDir, @SW_HIDE, $STDERR_MERGED + $STDIN_CHILD)
		While 1 ; loop through the return from the command until there is no more
			$line = StdoutRead($stream)
			If @error Then ExitLoop
			_GUICtrlEdit_AppendText($edit1, $line)
		WEnd
	EndIf
EndFunc   ;==>_CMDreturn

