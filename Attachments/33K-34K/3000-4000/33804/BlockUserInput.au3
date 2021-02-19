BlockInput(1)

HotKeySet("{ESC}", "Terminate")


If $CmdLine[0] = 3 Then
	$exit_signal_x = $CmdLine[1]
	$exit_signal_y = $CmdLine[2]
	MsgBox(0, "BlockUserInput", "Using the following input coordinates as exit signal:  X = " & $CmdLine[1] & ", Y = " & $CmdLine[2], 3)

	Switch $CmdLine[3]
		Case ("window")
			AutoItSetOption("MouseCoordMode", 0) ;0 = relative coords to the active window
			MsgBox(0, "BlockUserInput", "Setting MouseCoordMode to 'relative coords to active window' because received: " & $CmdLine[3], 3)
		Case ("screen")
			AutoItSetOption("MouseCoordMode", 1) ;1 = absolute screen coordinates (default)
			MsgBox(0, "BlockUserInput", "Setting MouseCoordMode to 'absolute screen coordinates (default)' because received: " & $CmdLine[3], 3)
		Case ("client")
			AutoItSetOption("MouseCoordMode", 2) ;2 = relative coords to the client area of the active window
			MsgBox(0, "BlockUserInput", "Setting MouseCoordMode to 'relative coords to the client area of the active window' because received: " & $CmdLine[3], 3)
		Case Else
			MsgBox(0, "BlockUserInput", "Expecting sensible mouse coordinate mode (window, 0, screen, 1, client, 2).  Instead received: " & $CmdLine[3], 3)
			Exit 0
	EndSwitch

Else
	MsgBox(0, "BlockUserInput", "Command line expecting 3 arguments.  Instead received: " & $CmdLine[0], 3)
	Exit 0
EndIf



While 1
	Sleep(100)
	$current_mouse_position = MouseGetPos()

	if ($current_mouse_position[0] = $exit_signal_x And $current_mouse_position[1] = $exit_signal_y) Then
		Exit 0
	EndIf
WEnd


Func Terminate()

	Exit 0
EndFunc   ;==>Terminate