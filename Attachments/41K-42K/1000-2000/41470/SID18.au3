#include <ButtonConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $ComputerName, $SIDUserName, $Check, $SID, $ComputerName_read, $SIDUserName_read, $command

#region ### START Koda GUI section ### Form=c:\users\pankajmi\desktop\is\autoit - pankaj\koda files\sidchecker.kxf
$Form1_1 = GUICreate("SID Checker V1.0 Agneepath", 613, 145, 192, 124)
$Label1 = GUICtrlCreateLabel("Computer Name", 16, 8, 80, 17)
$ComputerName = GUICtrlCreateInput("", 16, 32, 233, 21)
$SID = GUICtrlCreateLabel("SID/User Name", 16, 64, 80, 17)
$SIDUserName = GUICtrlCreateInput("", 16, 88, 569, 21)
$Check = GUICtrlCreateButton("Check", 268, 112, 97, 25)
GUICtrlSetState(-1, $GUI_FOCUS)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$msg = GUIGetMsg()
	Select

		Case $msg = $Check

			$ComputerName_read = GUICtrlRead($ComputerName)
			$SIDUserName_read = GUICtrlRead($SIDUserName)

			_getDOSOutput($command)

		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop

	EndSelect


WEnd

ConsoleWrite(_getDOSOutput('psgetsid') & @CRLF)

Func _getDOSOutput($command)



	Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
	While 1
		$text &= StdoutRead($Pid, False, False)
		If @error Then ExitLoop
		Sleep(10)
	WEnd

	MsgBox(0, "SID for User Name", $text)

	Return StringStripWS($text, 7)

EndFunc   ;==>_getDOSOutput

