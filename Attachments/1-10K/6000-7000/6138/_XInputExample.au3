#include <_XInput.au3>
$inputhwnd = _XInputInit()
$message = 0
SplashTextOn("Xbox Controller Text", $message, -1, -1, -1, -1, 4, "")
While 1
$btext = ""
$timer = 50
$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])
_XInputVibrate($inputhwnd,round(($input[3] / 255) * 100),round(($input[4] / 255) * 100))
If $buttons[1] Then $btext = $btext & "Up" & @CRLF
If $buttons[2] Then $btext = $btext & "Down" & @CRLF
If $buttons[3] Then $btext = $btext & "Left" & @CRLF
If $buttons[4] Then $btext = $btext & "Right" & @CRLF
If $buttons[5] Then $btext = $btext & "Start" & @CRLF
If $buttons[6] Then $btext = $btext & "Back" & @CRLF
If $buttons[7] Then $btext = $btext & "LJoy" & @CRLF
If $buttons[8] Then $btext = $btext & "RJoy" & @CRLF
If $buttons[9] Then $btext = $btext & "LButton" & @CRLF
If $buttons[10] Then $btext = $btext & "RButton" & @CRLF
If $buttons[11] Then $btext = $btext & "A" & @CRLF
If $buttons[12] Then $btext = $btext & "B" & @CRLF
If $buttons[13] Then $btext = $btext & "X" & @CRLF
If $buttons[14] Then $btext = $btext & "Y" & @CRLF
$message = "-=Input=-" & @CRLF & "Packet Number: " & $input[1] & @CRLF & _ 
	"Buttons: " & $input[2] & @CRLF & "Left Trigger: " & $input[3] & @CRLF & _ 
	"Right Trigger: " & $input[4] & @CRLF & "Left Joy X: " & $input[5] & @CRLF & _
	"Left Joy Y: " & $input[6] & @CRLF & "Right Joy X: " & $input[7] & @CRLF & _
	"Right Joy Y: " & $input[8] & @CRLF & @CRLF & "-=Buttons=-" & @CRLF & $btext
ControlSetText("Xbox Controller Text", "", "Static1", $message)
Sleep($timer)
WEnd