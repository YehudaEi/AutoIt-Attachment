#include-once
; Credits:	Evanxxx, for the help with translating the autohotkey form of this
;           Valik with the  _MakeLong function
;           and the original author "forgot name" who wrote it in autohotkey
;           and a whole lot of other people on autoit forms and across the web, thx :p
;==================================================================================
; Function:			CtrlMouse($WindowName, $WindowText , $ControlID, $X_Coord, $Y_Coord)

; Description:		Sends ctrl+left mouse click  to the defined control.

; Parameter(s):		$WindowName - the name of the window that your control is located in.
;                   $WindowText - you can leave this as "" but its the text of the window
;                                 to access, read more about it in ControlGetHandle function 
;                                  help
;					$ControlID - the id of the control your wanting to send ctrl+leftmouse
;                   $X_Coord - the X coord you want to send the ctrl + leftmouse in the defined control
;                   $Y_Coord - the Y coord you want to send the ctrl + leftmouse in the defined control

; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing the Dll handle and an
;								 open handle to the specified process.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = No window Found.
; Author(s):		UPSman2
;==================================================================================

Func CtrlMouse($WindowName, $WindowText , $ControlID, $X_Coord, $Y_Coord)
	If WinExists($WindowName) Then
		;mouse down
		DllCall("user32.dll", "int", "SendMessage", "hwnd",  ControlGetHandle ( $WindowName, $WindowText, $ControlID ), "int",   0x0201, "int",   BitOR (0x0001, 0x0008), "long",  _MakeLong($X_Coord, $Y_Coord))
		;mouse up
		DllCall("user32.dll", "int", "SendMessage", "hwnd",  ControlGetHandle ( $WindowName, $WindowText, $ControlID ), "int",   0x0202, "int", 0x0001, "long",  _MakeLong($X_Coord, $Y_Coord))
	Else
		SetError(1)
	EndIf
EndFunc	

Func _MakeLong($LoWord,$HiWord)
  Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc