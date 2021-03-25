;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;					 ;;
;;  _XInput UDF for use with AutoIt Beta ;;
;;					 ;;
;;	Created by Oxin8		 ;;
;;      email: xoxinx@gmail.com		 ;;
;;	modified by caveat on 8/4/2013
;;		email: caveatsemporium@gmail.com
;;			thanks to posts at this url for finding the 'secret' function to get the xbox guide button state:
;;				http://forums.tigsource.com/index.php?topic=26792.0
;;					 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputInit()
;	Opens the dll
;	returns - a handle to open dll

Func _XInputInit()
   Local $thedll
   $thedll = DllOpen("xinput1_3.dll")
   Return $thedll
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputCheckState($thedll)
;	Returns true if a controller is connected
;	Else returns false

Func _XInputCheckState($thedll)
   $xinputgamepad = DllStructCreate("ULONG;word;byte;byte;short;short;short;short")
   $return = DllCall($thedll,"dword",100,"long",0,"ptr",DllStructGetPtr($xinputgamepad))
   If $return[0] == 0 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputGetInput($thedll)
;	Returns an array of the current controller input
;	$thedll - dll handle returned by _XInputInit()
;	returns - an array with info (see below)
;		1-Event Count
;		2-Buttons
;		3-Left Trigger - 0 to 255
;		4-Right Trigger - 0 to 255
;		5-Left X - -32768 to 32767
;		6-Left Y - -32768 to 32767
;		7-Right X - -32768 to 32767
;		8-Right Y - -32768 to 32767

Func _XInputGetInput($thedll)
   Local $temp[9]
   $xinputgamepad = DllStructCreate("ULONG;word;byte;byte;short;short;short;short")
   If DllCall($thedll,"long",100,"long",0,"ptr",DllStructGetPtr($xinputgamepad))=0 Then Return
   For $i = 1 to 8
	  $temp[$i] = DllStructGetData($xinputgamepad,$i)
   Next
   Return $temp
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputButtons($buttons)
;	Returns an array indicating the pressed buttons
;	$buttons - use the second element of the array returned by _XInputGetInput
;	returns - an array of pressed buttons. 1 indicating pressed
;
;	   Array Element
;               v
;Y     32768	15
;X     16384    14
;B      8192    13
;A      4096    12
;Guide  1024	11
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
   Local $pressed[16]
   For $i = 15 to 12 Step -1
	  If $buttons >= (2^$i) Then
		 $buttons = $buttons - (2^$i)
		 $pressed[($i)] = 1
	  EndIf
   Next
   For $i = 10 to 0 Step -1
	  If $buttons >= (2^$i) Then
		 $buttons = $buttons - (2^$i)
		 $pressed[($i + 1)] = 1
	  EndIf
   Next
   Return $pressed
EndFunc
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function _XInputOff($thedll)
;	Turns off the xbox controller
 
Func _XInputOff($thedll)
   DllCall($thedll,"int",103,"int",0)
EndFunc