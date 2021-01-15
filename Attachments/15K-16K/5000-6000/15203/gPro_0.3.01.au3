#include <GUIConstants.au3>
#include <Misc.au3>
#include <String.au3>
#include <gMath.au3>
#include <Array.au3>
AutoItSetOption ("TrayIconDebug", 1)

HotKeySet("{F1}", "Help")
HotKeySet("{ESC}", "Terminate")

Global $var = _ArrayCreate("State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0", "State 0")

Call ("gProInterface")

Func gProInterface ()
Global $f11pressed = 0
Global $Form1 = GUICreate("gPro", @DesktopWidth, @DesktopHeight, 0, 0, $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX)
Global $gProGroup1 = GUICtrlCreateGroup("gPro Central", 210, 85, 492, 468, 0)
Global $Execute = GUICtrlCreateButton("Execute", 600, 524, 97, 25, 0,0 + 40)
Global $cLine = GUICtrlCreateInput("about", 216, 524, 369, 21)
Global $txt = GUICtrlCreateEdit("", 216, 104, 480, 420, $ES_READONLY + $WS_VSCROLL + 40)
Global $font = "courier new"
Global $textline = ("> Welcome to the gsglive command line!")
GUICtrlSetFont(-1, 9, 400, 4, $font)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0x7FFF00)
GUICtrlSetData($txt, $textline & @CRLF)

Global $Menu1 = GUICtrlCreateMenu("Help")
Global $Menu1Item1 = GUICtrlCreateMenuItem("Help File [F1]", $Menu1)
Global $Menu1Item2 = GUICtrlCreateMenuItem("About [Type <about>", $Menu1)
GUISetState(@SW_SHOW)
GUISetState($Execute, $GUI_DEFBUTTON)

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case _IsPressed("1B")
			Exit
		Case _IsPressed("7A")
			If $f11pressed = 0 Then
				GUICtrlSetStyle($Form1, $WS_MAXIMIZE)
				$f11pressed = 1
			ElseIf $f11pressed = 1 Then
				GUICtrlSetState($Form1, $WS_MINIMIZE)
				$f11pressed = 0
			EndIf
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $Execute
			$cLineRead = GuiCtrlRead($cLine)
			$stringmid = StringMid($cLineRead, 0)
			If $stringmid > 200 Then
				_ConsoleWrite("ERROR! Cannot parse command.")
				ExitLoop
			EndIf
			Global $string = StringSplit($cLineRead, Chr(44))
			If $string[0] > 0 Then
				$string[1] = _TrimSpaces($string[1])
				$string[1] = StringLower($string[1])
			EndIf
			If $string[0] > 1 Then
				$string[2] = _TrimSpaces($string[2])
				$string[2] = StringLower($string[2])
			EndIf
			If $string[0] > 2 Then
				$string[3] = _TrimSpaces($string[3])
				$string[3] = StringLower($string[3])
			EndIf
			If $string[0] > 3 Then
				$string[4] = _TrimSpaces($string[4])
				$string[4] = StringLower($string[4])
			EndIf
			Switch $string[1]
				Case "reset"
					GUICtrlSetFont($txt, 9, 400, 4, $font)
					GUICtrlSetBkColor($txt, 0x000000)
					GUICtrlSetColor($txt, 0x7FFF00)
					GUICtrlSetData($txt, "> Welcome to the gsglive command line!")
					GUICtrlSetData($cLine, "")
				Case "echo"
					_ConsoleWrite($string[2])
					GuiCtrlSetData($cLine,"","")
				Case "popup"
					MsgBox(0, $string[2], $string[3])
					_ConsoleWrite("--------------------------------")
					_ConsoleWrite("<Popup Executed>")
					_ConsoleWrite("--------------------------------")
					GuiCtrlSetData($cLine,"","")
				Case "exit"
					Exit
				Case 
				Case "Run"
					If $string[0] = 2 Then							
						Run ($string[2])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Run Complete>")
						_ConsoleWrite("--------------------------------")
					ElseIf $string[0] = 3 Then
						If $string[3] = 1 Then
							Run (@ScriptDir & "\" & $string[2])
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Run Complete>")
							_ConsoleWrite("--------------------------------")
						Else
							Run ($string[2])
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Run Complete>")
							_ConsoleWrite("--------------------------------")
						EndIf
					Else
						_ConsoleWrite("ERROR! Cannot parse command.")
					EndIf					
					GUICtrlSetData($cLine, "", "")
				Case "popup+"
					If $string[0] = 4 Then
						MsgBox($string[2], $string[3], $string[4])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Popup+ Executed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("ERROR! Cannot parse command.")
					EndIf
					GUICtrlSetData($cLine, "", "")
				Case "program"
					If $string[0] = 2 Then
						Switch $string[2]
							Case StringLower("Au3")
								Run (@ScriptDir & "\AutoIt3\SciTe\SciTe.exe")
							Case StringLower("gPro")
								_ConsoleWrite("--------------------------------")
								_ConsoleWrite("ERROR. Already Running gPro!")
								_ConsoleWrite("--------------------------------")
						EndSwitch
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
					GUICtrlSetData($cLine, "", "")
				Case "input popup"
					If $string[0] = 3 Then
						$input = InputBox($string[2], $string[3])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Input Popup Executed>")
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<User Wrote: " & $input & ">")
						_ConsoleWrite("--------------------------------")
					ElseIf $string[0] = 4 Then
						If $string[4] = 0 Then
							$input = InputBox($string[2], $string[3])
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Input Popup Executed>")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<User Wrote: " & $input & ">")
							_ConsoleWrite("--------------------------------")
						ElseIf $string[4] = 1 Then
							$input = InputBox($string[2], $string[3], "", "*")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Input Popup Executed>")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<User Wrote: " & $input & ">")
							_ConsoleWrite("--------------------------------")
						Else
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<ERROR. String Incomplete>")
							_ConsoleWrite("--------------------------------")
						EndIf
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
					GUICtrlSetData($cLine, "", "")
				Case "inputpopup"
					If $string[0] = 3 Then
						$input = InputBox($string[2], $string[3])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Input Popup Executed>")
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<User Wrote: " & $input & ">")
						_ConsoleWrite("--------------------------------")
					ElseIf $string[0] = 4 Then
						If $string[4] = 0 Then
							$input = InputBox($string[2], $string[3])
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Input Popup Executed>")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<User Wrote: " & $input & ">")
							_ConsoleWrite("--------------------------------")
						ElseIf $string[4] = 1 Then
							$input = InputBox($string[2], $string[3], "", "*")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<Input Popup Executed>")
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<User Wrote: " & $input & ">")
							_ConsoleWrite("--------------------------------")
						Else
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<ERROR. String Incomplete>")
							_ConsoleWrite("--------------------------------")
						EndIf
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
					GUICtrlSetData($cLine, "", "")
				Case "xcopy"
					If $string[0] = 3 Then
						FileCopy($string[2], $string[3]
						FileDelete($string[2])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Xcopy Completed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
				Case "filecopy"
					If $string[0] = 3 Then
						FileCopy($string[2], $string[3]
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Copy Completed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
				Case "filedelete"
					If $string[0] = 2 Then
						FileDelete($string[2])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Xcopy Completed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
				Case "file copy"
					If $string[0] = 3 Then
						FileCopy($string[2], $string[3]
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Copy Completed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
				Case "file delete"
					If $string[0] = 2 Then
						FileDelete($string[2])
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<Xcopy Completed>")
						_ConsoleWrite("--------------------------------")
					Else
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("<ERROR. String Incomplete>")
						_ConsoleWrite("--------------------------------")
					EndIf
				Case "computer"
				_ConsoleWrite("> Your username is: " & @Username)
				_ConsoleWrite("> Your computer name is: " & @ComputerName)
				_ConsoleWrite("> Your Operating System is: " & @OSVersion)
				_ConsoleWrite("> Service Pack is: " & @OSServicePack)
				_ConsoleWrite("> OS Build: " & @OSBuild)
				_ConsoleWrite("> Language: " & @OSLang)
				GuiCtrlSetData($cLine, "", "")
			Case "gui"
				$checkline = GUICtrlRead($cLine)
				If $checkline = ">gui" Then
					_ConsoleWrite("> You have not specified width and height to create a GUI.")
				Else
				_ConsoleWrite("> Creating GUI")
				Sleep(1000)
				_NewGUI()
				EndIf
				GuiCtrlSetData($cLine, "", "")
			Case "title"
				WinSetTitle($ngui, "", $string[2])
				GuiCtrlSetData($cLine, "", "")
			Case "color"
				If $string[0] = 2 Then
					Switch $string[2]
						Case "green"
							GUICtrlSetBkColor($txt, 0xaaffbb)
							GuiCtrlSetData($cLine, "", "")
						Case "white"
							GUICtrlSetBkColor($txt, 0xffffff)
							GuiCtrlSetData($cLine, "", "")
						Case "blue"
							GUICtrlSetBkColor($txt, 0x00ffff)
							GuiCtrlSetData($cLine, "", "")
						Case "rose"
							GUICtrlSetBkColor($txt, 0xddacaa)
							GuiCtrlSetData($cLine, "", "")
						Case "pink"
							GUICtrlSetBkColor($txt, 0xddacee)
							GuiCtrlSetData($cLine, "", "")
						Case "black"
							GUICtrlSetBkColor($txt, 0x000000)
							GuiCtrlSetData($cLine, "", "")
						Case Else
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<ERROR. String Incomplete>")
							_ConsoleWrite("--------------------------------")
					EndSwitch
				Else
					_ConsoleWrite("--------------------------------")
					_ConsoleWrite("<ERROR. String Incomplete>")
					_ConsoleWrite("--------------------------------")
				EndIf
				GuiCtrlSetData($cLine, "", "")
			Case "cd"
				If $string[0] = 2 Then
					Switch $string[2]
						Case "open"
							$drive = DriveGetDrive("CDROM")
							CDTray($drive, "open")
							_ConsoleWrite("CD Tray Opened")
							GuiCtrlSetData($cLine, "", "")
						Case "close"
							CDTray("H:\", "closed")
							_ConsoleWrite("CD Tray Closed")
							GuiCtrlSetData($cLine, "", "")
						Case Else
							_ConsoleWrite("--------------------------------")
							_ConsoleWrite("<ERROR. String Incomplete>")
							_ConsoleWrite("--------------------------------")
					EndSwitch
				Else
					_ConsoleWrite("--------------------------------")
					_ConsoleWrite("<ERROR. String Incomplete>")
					_ConsoleWrite("--------------------------------")
				EndIf
				GuiCtrlSetData($cLine, "", "")
			Case 
			Case StringLower("help")
				If $string[0] = 2 Then
				Switch $string[2]
					Case StringLower("popup")
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("> Syntax: popup, <title>, <text>")
						_ConsoleWrite("> Shows a little popup window")
						_ConsoleWrite("> Remarks: none")
						_ConsoleWrite("--------------------------------")
					Case StringLower("echo")
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("> Syntax: echo, <text>")
						_ConsoleWrite("> Places text in this control")
						_ConsoleWrite("> Remarks: none")
						_ConsoleWrite("--------------------------------")
					Case StringLower("reset")
						_ConsoleWrite("--------------------------------")
						_ConsoleWrite("> Resets all text")
						_ConsoleWrite("> Remarks: none")
						_ConsoleWrite("--------------------------------")
					Case "computer"
						_ConsoleWrite("> Syntax: computer")
						_ConsoleWrite("> Shows the computer information")
						_ConsoleWrite("> Remarks: none")
						GuiCtrlSetData($cLine, "", "")
					Case "exit"
						_ConsoleWrite("> Syntax: exit")
						_ConsoleWrite("> Closes the command window")
						_ConsoleWrite("> Remarks: none")
						GuiCtrlSetData($cLine, "", "")
					Case "beep"
						_ConsoleWrite("> Syntax: beep {Frequency, Duration}")
						_ConsoleWrite("> Plays back a beep to the user")
						_ConsoleWrite("> Remarks: Requires numbers e.g. beep, 500, 1000")
						GuiCtrlSetData($cLine, "", "")
					Case "color"
						_ConsoleWrite("> Syntax: color {rose, black, white, green, blue}")
						_ConsoleWrite("> Changes the background colour")
						_ConsoleWrite("> Remarks: Select one color e.g. color green")
						GuiCtrlSetData($cLine, "", "")
					Case "cd"
						_ConsoleWrite("> Syntax: cd {open,close}")
					Case "?"
						_ConsoleWrite("> Syntax: help {command in which you need help}")
						_ConsoleWrite("> Shows the help information and example. Commands are, help {color, exit, clear, popup, echo, beep}")
						_ConsoleWrite("> Remarks: Shows help info e.g exit")
						GuiCtrlSetData($cLine, "", "")
					Case "title"
						_ConsoleWrite("> Syntax: title {new title}")
						_ConsoleWrite("> Changes the window title")
						_ConsoleWrite("> Remarks: Example; title, James Brooks Programming Command Line")
						GuiCtrlSetData($cLine, "", "")		
					Case "gui"
						_ConsoleWrite("> Syntax: gui {width, height}")
						_ConsoleWrite("> Creates a GUI")
						_ConsoleWrite("> Remarks: A random GUI.")
						GuiCtrlSetData($cLine, "", "")
					Case ""
						_ConsoleWrite("You forgot to add a command")
						GuiCtrlSetData($cLine, "", "")
					Case "gui"
						_ConsoleWrite("You haven't added any values to the width and height.")
						_ConsoleWrite("Example: gui, 400, 500")
						GuiCtrlSetData($cLine, "", "")
				EndSwitch
				Else
				_ConsoleWrite("Error with syntax: Help")
				_ConsoleWrite("Type in: Help, <command>")
				EndIf
				GuiCtrlSetData($cLine, "", "")
				Case StringLower("about")
					_ConsoleWrite("--------------------------------")
					_ConsoleWrite("> gPro")
					_ConsoleWrite("> gPro Was Created With AutoIt3 and SciTe4AutoIt3")
					_ConsoleWrite("> This language is licensed to: " & @UserName)
					_ConsoleWrite("--------------------------------")
					GuiCtrlSetData($cLine, "", "")
				Case Else
					_ConsoleWrite("Error with syntax: " & $string[1])
					_ConsoleWrite("Use help, <command> to find help!")
					GuiCtrlSetData($cLine, "", "")
			EndSwitch
	EndSelect
Wend
EndFunc

Func _ConsoleWrite($text)
	Global $textline = ($textline & $text & @CRLF)
   GUICtrlSetData($txt, $textline, GUICtrlRead($txt))
EndFunc

Func _TrimSpaces(ByRef $parameter)
   Local $string
   $string = StringSplit($parameter, "")
   If $string[0] > 0 Then
	If $string[1] = Chr(32) Then
		$string = StringtrimLeft($parameter, 1)
		Return $string
	Else
		Return $parameter
	EndIf
   EndIf
EndFunc

Func _NewGUI()
	Global $nGUI = GuiCreate("New GUI", $string[2], $string[3], -1, -1)
	GUISetIcon("shell32.dll", 42)
	GuiSetState(@SW_SHOW)

	While WinActive($nGUI)
		$gMsg = GuiGetMsg()
		Switch $gMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($nGUI)
		EndSwitch
	WEnd
EndFunc

Func Terminate ()
	Exit
EndFunc

Func Save ()
	GUIDelete($Form1)
	$filesave = FileSaveDialog("Save File", @ScriptDir & "\Saved Files", "gPro Saved Files(*.gPro)", 16, "New gPro File")
	IniWrite($filesave, "Var", "1", $var[1])
	_ConsoleWrite("--------------------------------")
	_ConsoleWrite("<Save Sucsessful>")
	_ConsoleWrite("--------------------------------")
	Call ("gProInterface")
EndFunc

Func Open ()
	GUIDelete($Form1)
	$fileload = FileOpenDialog("Open File", @ScriptDir & "\Saved Files", "gPro Saved Files(*.gPro)", 16)
	$var[1] = IniRead($fileload, "Var", 1, "State 0")
	Global $var[1]
	_ConsoleWrite("--------------------------------")
	_ConsoleWrite("<Load Sucsessful>")
	_ConsoleWrite("--------------------------------")
	Call ("gProInterface")
EndFunc

Func Help ()
	GUIDelete($Form1)
	ShellExecute (@ScriptDir & "\gPro Help.pdf" , "", "" , "open" , @SW_MAXIMIZE )
	Call ("gProInterface")
EndFunc