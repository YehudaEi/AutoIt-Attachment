#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
Local $val_pid = 0
Global $Form1 = 0, $Input1 = 0, $PID = 0, $PID_Len = 0, $Input2 = 0
$PID = @AutoItPID
$PID_Len = StringLen($PID)

$Form1 = GUICreate("Form1IPC1234567890", 251, 120, 379, 198, 0, 0)
$Input1 = GUICtrlCreateInput("", 0, 8, 249, 21, $ES_READONLY) ; PID of clients
;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
$Input2 = GUICtrlCreateInput("", 0, 40, 249, 21, $ES_READONLY) ; message
;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
$Input3 = GUICtrlCreateInput($PID, 0, 72, 249, 21, $ES_READONLY) ; Server PID
;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
GUISetState(@SW_SHOW) ; replace @SW_SHOW with @SW_HIDE
$server = 1

While 1
	$ctrlread = StringReplace(ControlGetText("Form1IPC1234567890", '', 4), ',', '') ;decrypt
	$val_pid = StringLeft($ctrlread, $PID_Len)
	$ctrlread = StringTrimLeft($ctrlread, $PID_Len)
	If $val_pid == $PID Then ; for server
		$ctrlread = StringSplit($ctrlread, '-', 1)
		If IsArray($ctrlread) == 1 Then
			Select
				Case StringLower($ctrlread[2]) == 'end'
					ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & 'end') ;encrypt the string
				Case Else
					ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & 'server received ' & $ctrlread[2] & ' from ' & $ctrlread[1]) ;encrypt the string
			EndSelect
		EndIf
	EndIf
	If ControlGetText("Form1IPC1234567890", '', 3) == '' And ControlGetText("Form1IPC1234567890", '', 4) <> '' Then Exit
	Sleep(100)
WEnd
