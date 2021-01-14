#include <GuiConstants.au3>

#NoTrayIcon

$font = "Courier New"

$gui = GUICreate("My Programming Command Line", 482, 250, -1,-1)
GUISetIcon("shell32.dll", 42)
$txt = GUICtrlCreateEdit("", 0, 0, 481, 217, $ES_READONLY + $WS_VSCROLL)
GUICtrlSetFont (-1, 9, 400, 4, $font)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetData($txt, "> Welcome to mycommand line, you are logged in as: " & @UserName & @CRLF)
$cLine = GUICtrlCreateInput("", 5, 224, 380, 21)
GuiCtrlSetData($cLine, ">", "")
$Execute = GUICtrlCreateButton("Execute", 390, 221, 89, 25, $BS_DEFPUSHBUTTON)
GUISetState(@SW_SHOW)

While 1
   $msg = GuiGetMsg()
   Select
   Case $msg = $GUI_EVENT_CLOSE
       ExitLoop
   Case $msg = $Execute
       $string = StringSplit(GuiCtrlRead($cLine), Chr(44))
		Switch $string[1]
			Case ">clear"
				_ConsoleWrite("> Clearing...")
				Sleep(1000)
				GUICtrlSetData($txt, "", "")
				GuiCtrlSetData($cLine,">", "")
			Case ">echo"
				$string[2] = _TrimSpaces($string[2])
				_ConsoleWrite($string[2])
				GuiCtrlSetData($cLine, ">", "")
			Case ">beep"
				$string[2] = _TrimSpaces($string[2])
				Beep($string[2], $string[3])
				_ConsoleWrite("> Beep successfull")
				GUICtrlSetData($cLine, ">", "")
			Case ">exit"
				_ConsoleWrite("> Goodbye.")
				Sleep(1000)
				Exit
			Case ">computer"
				_ConsoleWrite("> Your username is: " & @Username)
				_ConsoleWrite("> Your computer name is: " & @ComputerName)
				_ConsoleWrite("> Your Operating System is: " & @OSVersion)
				_ConsoleWrite("> Service Pack is: " & @OSServicePack)
				_ConsoleWrite("> OS Build: " & @OSBuild)
				_ConsoleWrite("> Language: " & @OSLang)
				GuiCtrlSetData($cLine, ">", "")
			Case ">about"
				_ConsoleWrite("> My Programming Language")
				_ConsoleWrite("> Created with i542's Programming Language System")
				_ConsoleWrite("> This language is licensed to: Secure_ICT")
				GuiCtrlSetData($cLine, ">", "")
			Case ">gui"
				$checkline = GUICtrlRead($cLine)
				If $checkline = ">gui" Then
					_ConsoleWrite("> You have not specified width and height to create a GUI.")
				Else
				_ConsoleWrite("> Creating GUI")
				Sleep(1000)
				_NewGUI()
				EndIf
				GUICtrlSetData($cLine, ">", "")
			Case ">popup"
				MsgBox(0, $string[2], $string[3])
				GUICtrlSetData($txt,"<Popup Executed Successfully>" & @CRLF, GuiCtrlRead($txt))
				GuiCtrlSetData($cLine, ">", "")
			Case ">title"
				WinSetTitle($gui, "", $string[2])
				GuiCtrlSetData($cLine, ">", "")
			Case ">color green"
				GUICtrlSetBkColor($txt, 0xaaffbb)
				GUICtrlSetColor($txt, 0x000000)
				GuiCtrlSetData($cLine, ">", "")
			Case ">color white"
				GUICtrlSetBkColor($txt, 0xffffff)
				GUICtrlSetColor($txt, 0x000000)
				GuiCtrlSetData($cLine, ">", "")
			Case ">color blue"
				GUICtrlSetBkColor($txt, 0x00ffff)
				GUICtrlSetColor($txt, 0x000000)
				GuiCtrlSetData($cLine, ">", "")
			Case ">color rose"
				GUICtrlSetBkColor($txt, 0xddacaa)
				GUICtrlSetColor($txt, 0x000000)
				GuiCtrlSetData($cLine, ">", "")
			Case ">color pink"
				GUICtrlSetBkColor($txt, 0xddacee)
				GUICtrlSetColor($txt, 0x000000)
				GuiCtrlSetData($cLine, ">", "")
			Case ">color black"
				GUICtrlSetBkColor($txt, 0x000000)
				GUICtrlSetColor($txt, 0xffffff)
				GuiCtrlSetData($cLine, ">", "")
			Case ">cd open"
				$drive = DriveGetDrive("CDROM")
				CDTray($drive, "open")
				_ConsoleWrite("CD Tray Opened")
				GuiCtrlSetData($cLine, ">", "")
			Case ">cd close"
				CDTray("H:\", "closed")
				_ConsoleWrite("CD Tray Closed")
				GuiCtrlSetData($cLine, ">", "")
			Case ">computer"
				_ConsoleWrite("> Syntax: computer")
				_ConsoleWrite("> Shows the computer information")
				_ConsoleWrite("> Remarks: none")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /echo"
				_ConsoleWrite("> Syntax: echo, <text>")
				_ConsoleWrite("> Places text in this control")
				_ConsoleWrite("> Remarks: none")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /popup"
				_ConsoleWrite("> Syntax: popup, <title>, <text>")
				_ConsoleWrite("> Makes a popup appear")
				_ConsoleWrite("> Remarks: none")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /clear"
				_ConsoleWrite("> Syntax: clear")
				_ConsoleWrite("> Clears all of the text in the control")
				_ConsoleWrite("> Remarks: none")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /exit"
				_ConsoleWrite("> Syntax: exit")
				_ConsoleWrite("> Closes the command window")
				_ConsoleWrite("> Remarks: none")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /beep"
				_ConsoleWrite("> Syntax: beep {Frequency, Duration}")
				_ConsoleWrite("> Plays back a beep to the user")
				_ConsoleWrite("> Remarks: Requires numbers e.g. beep, 500, 1000")
				GUICtrlSetData($cLine, ">", "")
			Case ">help /color"
				_ConsoleWrite("> Syntax: color {rose, black, white, green, blue}")
				_ConsoleWrite("> Changes the background colour")
				_ConsoleWrite("> Remarks: Select one color e.g. color green")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /cd"
				_ConsoleWrite("> Syntax: cd {open,close}")
			Case ">help /?"
				_ConsoleWrite("> Syntax: help {command in which you need help}")
				_ConsoleWrite("> Shows the help information and example. Commands are, help {color, exit, clear, popup, echo, beep}")
				_ConsoleWrite("> Remarks: Shows help info e.g help /exit")
				GuiCtrlSetData($cLine, ">", "")
			Case ">help /title"
				_ConsoleWrite("> Syntax: title {new title}")
				_ConsoleWrite("> Changes the window title")
				_ConsoleWrite("> Remarks: Example; title, James Brooks Programming Command Line")
				GuiCtrlSetData($cLine, ">", "")		
			Case ">help /gui"
				_ConsoleWrite("> Syntax: gui {width, height}")
				_ConsoleWrite("> Creates a GUI")
				_ConsoleWrite("> Remarks: A random GUI.")
				GuiCtrlSetData($cLine, ">", "")
			Case ">"
				_ConsoleWrite("> You forgot to add a command")
				GuiCtrlSetData($cLine, ">", "")
			Case ">gui"
				_ConsoleWrite("> You haven't added any values to the width and height.")
				_ConsoleWrite("> Example: >gui, 400, 500")
				GuiCtrlSetData($cLine, ">", "")
			Case Else
				_ConsoleWrite("Error with syntax: " & $string[1])
				_ConsoleWrite("Use help /? to find help!")
				GuiCtrlSetData($cLine, ">", "")
		EndSwitch
   EndSelect
WEnd

Func _ConsoleWrite($text)
   GUICtrlSetData($txt, $text & @crlf, GUICtrlRead($txt))
EndFunc

Func _TrimSpaces(ByRef $parameter)
   Local $string
   $string = StringSplit($parameter, "")
   If $string[1] = Chr(44) then
       $string = StringtrimLeft($parameter,1)
       Return $string
   Else
       Return $parameter
   EndIf
EndFunc

Func _NewGUI()
$nGUI = GuiCreate("New GUI", $string[2], $string[3], -1, -1)
GuiSetState(@SW_SHOW)

While WinActive($nGUI)
	$gMsg = GuiGetMsg()
	Switch $gMsg
	Case $GUI_EVENT_CLOSE
		GUIDelete($nGUI)
	EndSwitch
WEnd
EndFunc