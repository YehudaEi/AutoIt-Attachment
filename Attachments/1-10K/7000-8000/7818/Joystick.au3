#include-once

;**************************************************************
; Joystick Support by Norberto Gabriel Alvarez Raynald
; Made with AUTOIT V3.1.111 (I love it!)
; Contact: elgabionline-inbox@yahoo.com.ar

;**************************************************************


Func JoyMaxNumber ()  ;Maximum number of joysticks supported by system
	
	$Str_Dll_Winmm=DllStructCreate ("int")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetNumDevs","int",0)
	
	Select
	Case @error
		$Str_Dll_Winmm=0
		Return 0
	Case Else
		DllStructSetData ($Str_Dll_Winmm,1,$Joystick[0])
		$MaxNumber=DllStructGetData ($Str_Dll_Winmm,1)
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return $MaxNumber
	EndSelect
	
EndFunc


; **********************************************************
; JoyGetID ($Joy_number)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;~ Return -2 if Joystick not found or -3 if input param is wrong

; **********************************************************

Func JoyGetID ($Joy_number) ;Get ID from Joystick driver (values between -1 and 15)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	$Str_Dll_Winmm=DllStructCreate ("int")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$ID=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1)

	Select
	Case @error
		$Str_Dll_Winmm=0
		DllClose ($Dll_Winmm)
		Return -2
	Case Else
		DllStructSetData ($Str_Dll_Winmm,1,$ID[0])
		$NumID=DllStructGetData ($Str_Dll_Winmm,1)
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return $NumID
	EndSelect
	
EndFunc
	

; ***********************************************************
;JoyMoveLeft ($Joy_number,$Joy_sensivity)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_sensivity: Corner sensivity input is a percent value...useful for Analogic Joysticks (100 max.)
;Case is positive Return 1. Case else Return 0

;***********************************************************

Func JoyMoveLeft ($Joy_number=1,$Joy_sensivity=90)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	If not IsNumber ($Joy_sensivity) Then $Joy_sensivity = 90
	If $Joy_sensivity="" Then $Joy_sensivity=90
	If $Joy_sensivity>100 Then $Joy_sensivity=100
	
	$Str_Dll_Winmm=DllStructCreate ("int;int;char;ptr")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1,"ptr",DllStructGetPtr($Str_Dll_Winmm))
	
	If @error<>0 Then
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndIf
	
	$Joy_Corner=32768-(32768*$Joy_sensivity)/100
	$Joy_Coord=DllStructGetData ($Str_Dll_Winmm,1)
	
	Select
	Case $Joy_Coord<=$Joy_Corner
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 1
	Case Else
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndSelect
	
	
EndFunc


; ***********************************************************
;JoyMoveRight ($Joy_number,$Joy_sensivity)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_sensivity: Corner sensivity input is a percent value...usefull for Analogic Joysticks (100 max.)
;Case is positive Return 1. Case else Return 0

;***********************************************************

Func JoyMoveRight ($Joy_number=1,$Joy_sensivity=90)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	If not IsNumber ($Joy_sensivity) Then $Joy_sensivity = 90
	If $Joy_sensivity="" Then $Joy_sensivity=90
	If $Joy_sensivity>100 Then $Joy_sensivity=100
	
	$Str_Dll_Winmm=DllStructCreate ("int;int;char;ptr")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1,"ptr",DllStructGetPtr($Str_Dll_Winmm))
	
	If @error<>0 Then
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndIf
	
	$Joy_Corner=32768+(32768*$Joy_sensivity)/100
	$Joy_Coord=DllStructGetData ($Str_Dll_Winmm,1)
	
	Select
	Case $Joy_Coord>=$Joy_Corner
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 1
	Case Else
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndSelect
	
EndFunc



; ***********************************************************
;JoyMoveUp ($Joy_number,$Joy_sensivity)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_sensivity: Corner sensivity input is a percent value...usefull for Analogic Joysticks (100 max.)
;Case is positive Return 1. Case else Return 0

;***********************************************************

Func JoyMoveUp ($Joy_number=1,$Joy_sensivity=90)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	If not IsNumber ($Joy_sensivity) Then $Joy_sensivity = 90
	If $Joy_sensivity="" Then $Joy_sensivity=90
	If $Joy_sensivity>100 Then $Joy_sensivity=100
	
	$Str_Dll_Winmm=DllStructCreate ("int;int;char;ptr")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1,"ptr",DllStructGetPtr($Str_Dll_Winmm))
	
	If @error<>0 Then
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndIf
	
	$Joy_Corner=32768-(32768*$Joy_sensivity)/100
	$Joy_Coord=DllStructGetData ($Str_Dll_Winmm,2)
	
	Select
	Case $Joy_Coord<=$Joy_Corner
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 1
	Case Else
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndSelect
	
EndFunc


; ***********************************************************
;JoyMoveDown ($Joy_number,$Joy_sensivity)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_sensivity: Corner sensivity input is a percent value...usefull for Analogic Joysticks (100 max.)
;Case is positive Return 1. Case else Return 0

;***********************************************************

Func JoyMoveDown ($Joy_number=1,$Joy_sensivity=90)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	If not IsNumber ($Joy_sensivity) Then $Joy_sensivity = 90
	If $Joy_sensivity="" Then $Joy_sensivity=90
	If $Joy_sensivity>100 Then $Joy_sensivity=100
	
	$Str_Dll_Winmm=DllStructCreate ("int;int;char;ptr")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1,"ptr",DllStructGetPtr($Str_Dll_Winmm))
	
	If @error<>0 Then
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndIf
	
	$Joy_Corner=32768+(32768*$Joy_sensivity)/100
	$Joy_Coord=DllStructGetData ($Str_Dll_Winmm,2)
	
	Select
	Case $Joy_Coord>=$Joy_Corner
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 1
	Case Else
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndSelect
	
EndFunc


; ***********************************************************
;JoyButtonPressed ($Joy_number,$Joy_button)
; $Joy_number: how You want get ID. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_button: Numeric value of button. (n) is > 0
;Case is positive Return 1. Case else Return 0

;***********************************************************


Func JoyButtonPressed ($Joy_number=1,$Joy_button=1)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	If not IsNumber ($Joy_button) Or $Joy_button<=0 Then Return 0
	if $Joy_button>2 Then $Joy_button=2^($Joy_button-1)
		
	$Str_Dll_Winmm=DllStructCreate ("int;int;char;ptr")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joyGetPos","int",$Joy_number-1,"ptr",DllStructGetPtr($Str_Dll_Winmm))
	
	If @error<>0 Then
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		Return 0
	EndIf
	
	$Joy_buttons_pressed=DllStructGetData ($Str_Dll_Winmm,4)
	$Joy_buttons_pressed=Number ($Joy_buttons_pressed)
	$B_C=($Joy_buttons_pressed/16777216)
	$B_C=BitAND ($Joy_button,$B_C)
	
	DllClose ($Dll_Winmm)
	$Str_Dll_Winmm=0
	
	Select
	Case $B_C=0
		Return 0
	Case Else
		Return 1
	EndSelect
	
EndFunc


; ***********************************************************
;JoySendToWindow ($Joy_to_window,$Joy_number,$Joy_frec)
;$Joy_to_window: Title window or Hwnd to send joystick messages.
;$Joy_number: Numeric value for Joystick. Put a number, 1 or 2... to JoyMaxNumber ()
;$Joy_frec: Poll frecuency to send states changes of joystick.
;$Joy_release: Try release Joystick if other instances captured it.
;Case is positive Return 1
; Case else Return -2 if window not exist or -3 if joystick input error or -4 if not vaild frecuency.

;***********************************************************


Func JoySendToWindow ($Joy_to_window,$Joy_number=1,$Joy_frec=50,$Joy_Release=0)
	
	$Max= JoyMaxNumber ()
	If $Max<$Joy_number Or Not StringIsDigit ($Joy_number) Then Return -3
	If $Joy_number<1 Then Return -3
	$Joy_to_window=WinGetHandle ($Joy_to_window)
	If Not IsHwnd ($Joy_to_window) then Return -2
	If not IsNumber ($Joy_frec) Then Return -4
	If $Joy_frec<1 Then Return -4
	If $Joy_release<>0 And $Joy_release<>1 Then $Joy_release=0
	
	$Str_Dll_Winmm=DllStructCreate ("int")
	$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
	$Joystick=DllCall ($Dll_Winmm,"int","joySetCapture","hwnd",$Joy_to_window,"int",$Joy_number-1,"int",$Joy_frec)
	
	Select
	Case @error
		$Str_Dll_Winmm=0
		DllClose ($Dll_Winmm)
		Return
	Case Else
		DllStructSetData ($Str_Dll_Winmm,1,$Joystick[0])
		$Data_send=DllStructGetData ($Str_Dll_Winmm,1)
		DllClose ($Dll_Winmm)
		$Str_Dll_Winmm=0
		If $Data_send=0 Then Return 1
	EndSelect
	
	Select
	Case $Joy_release=1
		$Str_Dll_Winmm=DllStructCreate ("int")
		$Dll_Winmm=DllOpen (@SystemDir&"\winmm.dll")
		$Release=DllCall ($Dll_Winmm,"int","joyReleaseCapture","int",$Joy_number-1)
		If $Release=0 Then
			$Joystick=DllCall ($Dll_Winmm,"int","joySetCapture","hwnd",$Joy_to_window,"int",$Joy_number-1,"int",$Joy_frec)
			DllStructSetData ($Str_Dll_Winmm,1,$Joystick[0])
			$Data_send=DllStructGetData ($Str_Dll_Winmm,1)
			DllClose ($Dll_Winmm)
			$Str_Dll_Winmm=0
		EndIf
		If $Data_send=0 Then Return 1
	Case Else
		Return
	EndSelect
		
EndFunc




; ¡¡Y aguante Colon de Santa Fe!! (Argentina Fútbol Team)