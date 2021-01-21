#include <_XInput.au3>

$dll = DllOpen("user32.dll")
$inputhwnd = _XInputInit()
$fire1=0
$fire2=0
$forward = 0
$left = 0
$right = 0
$back = 0
$crouch = 0
$sensitivity = 4500 ;Higher Value equals less sensitive

While 1

$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])

_XInputVibrate($inputhwnd, round(($input[4] / 255) * 100),round(($input[3] / 255) * 100))

If $buttons[14] Then Send("e")
If $buttons[10] Then MouseWheel("up")
If $buttons[9] Then MouseWheel("down")
If $buttons[11] Then Send("{SPACE}")
If $buttons[12] Then Send("r")
If $buttons[7] Then 
	If $toggle = 1 Then
		If $crouch = 1 Then
			Send("{CTRLUP}")
			$crouch = 0
		Else
			Send("{CTRLDOWN}")
			$crouch = 1
		EndIf
		$toggle = 0
	EndIf
Else
	$toggle = 1
EndIf
If $buttons[2] Then Send("z")

If $input[4]<200 Then
	If $fire1=1 Then
	    MouseUp("left")
	    $fire1=0
	EndIf
Else
	If $fire1=0 then
	    MouseDown ( "left" )
	    $fire1=1
	EndIf
EndIf
If $input[3]<200 Then
	If $fire2=1 Then
	    MouseUp("right")
	    $fire2=0
	EndIf
Else
	If $fire2=0 then
	    MouseDown ( "right" )
	    $fire2=1
	EndIf
EndIf
If $input[6]<22000 Then
	If $forward = 1 then
	    Send("{w up}")
	    $forward=0
	EndIf
Else
	If $forward = 0 then
	    Send("{w down}")
	    $forward=1
	EndIf
EndIf
If $input[6]>-22000 Then
	If $back = 1 then
	    Send("{s up}")
	    $back=0
	EndIf
Else
	If $back = 0 then
	    Send("{s down}")
	    $back=1
	EndIf
EndIf
If $input[5]<22000 Then
	If $left = 1 then
	    Send("{d up}")
	    $left=0
	EndIf
Else
	If $left = 0 then
	    Send("{d down}")
	    $left=1
	EndIf
EndIf
If $input[5]>-22000 Then
	If $right = 1 then
	    Send("{a up}")
	    $right=0
	EndIf
Else
	If $right = 0 then
	    Send("{a down}")
	    $right=1
	EndIf
EndIf

If abs($input[7]) > 4000 Or abs($input[8])>4000 Then _MouseMovePlus((($buttons[8]*2)+1)*($input[7]/$sensitivity),-(($buttons[8]*2)+1)*($input[8]/$sensitivity),$dll)

_MySleep(5)
WEnd

Func _MySleep($t)
	DllCall("winmm.dll","long","timeBeginPeriod","long",1)
	DllCall("kernel32.dll", "none", "Sleep", "long", $t)
	DllCall("winmm.dll","long","timeEndPeriod","long",1)
EndFunc

Func _MouseMovePlus($X = "", $Y = "",$dll = 0)
    	Local $MOUSEEVENTF_MOVE = 0x1
	If $dll = 0 Then 
	DllCall("user32.dll", "none", "mouse_event", _
        	"long",  $MOUSEEVENTF_MOVE, _
	        "long",  $X, _
        	"long",  $Y, _
	        "long",  0, _
		"long",  0)
	Else
	DllCall($dll, "none", "mouse_event", _
        	"long",  $MOUSEEVENTF_MOVE, _
	        "long",  $X, _
        	"long",  $Y, _
	        "long",  0, _
		"long",  0)
	EndIf
EndFunc