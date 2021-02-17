#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=KeyBoardScreenCaptureCopyPastPrevent.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.6.1
	Author:         Sasanka Fernando
	Date:			2011.03.09
	Script Function: Testing To restrict screen capture
	Template AutoIt script.
#ce ----------------------------------------------------------------------------
#include <Misc.au3> ; to use the extra functionalities

$dll = DllOpen("user32.dll") ;take this dll to use the user level active windows

While 1 ; non end will that keep the endless loop
	Sleep ( 100 ) ; sleep 0.1 seconds to delay and stop the CPU cicle for a while
	If _IsPressed("02", $dll) Then 		; 	Track the Right mouse button to stop the past option
		DisablePrintScreen()			; 	Calling for Clip Board Clear function
	ElseIf _IsPressed("2C", $dll) Then 	;	Track the PRINT SCREEN key to stop the screen capture facility
		DisablePrintScreen()
	ElseIf _IsPressed("43", $dll) Then	;	Track the C key to stop the copy bye hotkeys
		DisablePrintScreen()
	ElseIf _IsPressed("56", $dll) Then	;	Track the V key to stop the past bye hotkey
		DisablePrintScreen()
	ElseIf _IsPressed("58", $dll) Then	;	Track the X key to stop the cut bye hotkey
		DisablePrintScreen()
	;Else
	EndIf
WEnd

DllClose($dll) ;dll close function but not use in this application due to non end procedure

Func DisablePrintScreen()
	;MsgBox(0, "AutoIt Example", "This is strickly prohibited")
	ClipPut(" ")

EndFunc

