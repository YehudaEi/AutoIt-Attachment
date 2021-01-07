;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;					 ;;
;;  _XInput UDF for use with AutoIt Beta ;;
;;					 ;;
;;	Created by Oxin8		 ;;
;;      email: xoxinx@gmail.com		 ;;
;;					 ;;
;;	Must have xwrap.dll registered   ;;
;;	to use.				 ;;
;;					 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputInit()
;	Creates the wrapper object to make the api calls
;	and initializes the controller.
;	returns - a handle to the wrapper object

Func _XInputInit()
	Local $xob
	$xob = ObjCreate("xwrap.wrapper")
	$xob.xVibrate(0,0,0)
	Return $xob
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputVibrate($xob, $lmotor, $rmotor)
;	Sets the controller's vibration for the left and right motors
;	$xob - wrapper object handle returned by _XInputInit()
;	$lmotor - desired left motor power level. 0 being none and 100 being full
;	$rmotor - desired left motor power level. 0 being none and 100 being full
;	returns - nothing

Func _XInputVibrate($xob,$lmotor,$rmotor)
	$xob.xVibrate(0,round(($lmotor / 100) * 32767),round(($rmotor / 100) * 32767))
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputGetInput($xob)
;	Returns an array of the current controller input
;	$xob - wrapper object handle returned by _XInputInit()
;	returns - an array with info (see below)
;		1-PacketNumber - indicates change
;		2-Buttons
;		3-Left Trigger - 0 to 255
;		4-Right Trigger - 0 to 255
;		5-Left X - -32768 to 32767
;		6-Left Y - -32768 to 32767
;		7-Right X - -32768 to 32767
;		8-Right Y - -32768 to 32767

Func _XInputGetInput($xob)
	Local $temp[8]
	$temp = $xob.getXState(0)
	Return StringSplit($temp,"!")
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputButtons($buttons)
;	Returns an array indicating the pressed buttons
;	$buttons - use the second element of the array returned by _XInputGetInput
;	returns - an array of pressed buttons. 1 indicating pressed
;
;	   Array Element
;               v
;Y    -32768	14
;X     16384    13
;B      8192    12
;A      4096    11
;RButton 512    10
;LButton 256     9
;RJoy    128     8
;LJoy     64     7
;Back     32     6
;Start    16     5
;Right     8     4
;Left      4     3
;Down      2     2
;Up        1     1

Func _XInputButtons($buttons)
	Local $pressed[15]
	If $buttons < 0 Then
		$buttons = $buttons + 32768
		$pressed[14] = 1
	EndIf
	For $i = 14 to 12 Step -1
		If $buttons >= (2^$i) Then
			$buttons = $buttons - (2^$i)
			$pressed[($i-1)] = 1
		EndIf
	Next
	For $i = 9 to 0 Step -1
		If $buttons >= (2^$i) Then
			$buttons = $buttons - (2^$i)
			$pressed[($i + 1)] = 1
		EndIf
	Next
	Return $pressed
EndFunc