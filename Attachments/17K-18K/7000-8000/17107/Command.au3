#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=cmd.ico
#AutoIt3Wrapper_outfile=Command.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Allow_Decompile=n
#AutoIt3Wrapper_Res_Comment=Beta Version
#AutoIt3Wrapper_Res_Description=Command - A hacking simulation
#AutoIt3Wrapper_Res_Fileversion=0.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=3081
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <Array.au3>

AdlibEnable("Time")
HotKeySet("{Enter}", "_Send")

#region ;------------Level 1------------;
$Length = Random(1, 15, 1)
$CommandText = "Command [Version 0.0.0.1]" & @CRLF & @CRLF & "A password has been generated at random that is " & $Length & " characters in length." & _
		" To gain access to the next level you will have to find out what this password is. Get used to this command prompt as it will be useful" & _
		" in finding out what that password is. Once you have it enter it in and hit enter to see if it is correct."
RandomPass()
Func RandomPass()
	$Characters = StringSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")
	$Password = ""
	For $X = 1 To $Length
		$Password &= $Characters[Random(1, $Characters[0], 1) ]
	Next
	If FileExists(@TempDir & "\72779673.txt") Then
		FileDelete(@TempDir & "\72779673.txt")
	EndIf
	FileWrite(@TempDir & "\72779673.txt", $Password)
EndFunc   ;==>RandomPass

Func CheckPass()
	$Pass = FileRead(@TempDir & "\72779673.txt")
	If GUICtrlRead($Command) == $Pass Then
		MsgBox(0, "Command", "You have passed the first level, click OK to go to the next level.")
		FileDelete(@TempDir & "\72779673.txt")
		GUICtrlSetData($CommandLine, $CommandText2)
	Else
		MsgBox(0, "Command", "The password you entered does not match. Please try again!")
	EndIf
EndFunc   ;==>CheckPass

Func _Open()
	$Pass = FileRead(@TempDir & "\72779673.txt")
	GUICtrlSetData($CommandLine, $Pass)
EndFunc   ;==>_Open
#endregion
;------------Level 1------------;

;------------Level 2------------;
$CommandText2 = "Command [Version 0.0.0.2]" & @CRLF & @CRLF & "Congratulations. You have passed the first task. It was an easy one, but it" & _
		" is to help you learn that you should use the built-in commands and see what is available before getting technical." & _
		@CRLF & @CRLF & @ScriptDir & ">"
;------------Level 2------------;

$CommandGUI = GUICreate("Command ", 659, 328, 0, 0, BitOR($WS_CAPTION, $WS_SYSMENU))
GUISetIcon("cmd.ico")
GUICtrlSetBkColor(-1, 0x000000)
$CommandLine = GUICtrlCreateEdit($CommandText, 0, 0, 659, 303, BitOR($ES_WANTRETURN, $ES_READONLY))
GUICtrlSetFont(-1, 9, 400, "", "Raster Fonts")
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0xffffff)
$Command = GUICtrlCreateInput("", 2, 305, 655, 20, -1, 0)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0xffffff)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func Time() ; Update the time so it is current
	WinSetTitle("Command", "", "Command - " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc   ;==>Time

#region ;------------Commands------------;
Func _Send()
	$GetCommand = GUICtrlRead($Command)
	If $GetCommand = "Retrieve" Then
		_Retrieve()
		GUICtrlSetData($Command, "")
	ElseIf $GetCommand = "Help" Then
		_Help()
		GUICtrlSetData($Command, "")
	Else
		If $GetCommand = "IPAddress" Then
			_IP()
			GUICtrlSetData($Command, "")
		ElseIf $GetCommand = "Date" Then
			_Date()
			GUICtrlSetData($Command, "")
		Else
			If $GetCommand <= "" Then
				MsgBox(48, "Command", "You did not enter a command!")
			ElseIf $GetCommand = "Info" Then
				_Info()
				GUICtrlSetData($Command, "")
			Else
				If $GetCommand = "Files" Then
					_Files()
					GUICtrlSetData($Command, "")
				ElseIf $GetCommand = "Open 72779673.txt" Then
					_Open()
					GUICtrlSetData($Command, "")
				Else
					If $GetCommand = "Other" Then
						_Other()
						GUICtrlSetData($Command, "")
					ElseIf $GetCommand = "About" Then
						MsgBox(64, "Command", "Command by alien13")
						GUICtrlSetData($Command, "")
					Else
						CheckPass()
						GUICtrlSetData($Command, "")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_Send

Func _Retrieve()
	GUICtrlSetData($CommandLine, "Date -- Gets the current date and time." & @CRLF & "Info -- Shows your system information." & _
			@CRLF & "IPAddress -- Gets your local IP Address." & @CRLF & "Files -- List of files you can retrieve." & @CRLF & "About -- About Command")
EndFunc   ;==>_Retrieve

Func _Help()
	WinWaitActive("Command")
	GUICtrlSetData($CommandLine, "Commands:" & @CRLF & "Retrieve -- Shows the list of retrieving options." & @CRLF & _
			"Help -- Shows these commands." & @CRLF & "Other -- List of other commands.")
EndFunc   ;==>_Help

Func _IP()
	GUICtrlSetData($CommandLine, "Your local IP is: " & @IPAddress1)
EndFunc   ;==>_IP

Func _Date()
	GUICtrlSetData($CommandLine, @MDAY & "/" & @MON & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc   ;==>_Date

Func _Info()
	GUICtrlSetData($CommandLine, "Operating System..: " & @OSVersion & @CRLF & "Service Pack......: " & @OSServicePack & _
			@CRLF & "Computer Name.....: " & @ComputerName & @CRLF & "User Name.........: " & @UserName & @CRLF & "Screen Size.......: " & _
			@DesktopWidth & "x" & @DesktopHeight)
EndFunc   ;==>_Info

Func _Files()
	GUICtrlSetData($CommandLine, "Files recently created:" & @CRLF & "72779673.txt")
EndFunc   ;==>_Files

Func _Other()
	GUICtrlSetData($CommandLine, "Open -- Opens a file: Open [FileName]")
EndFunc   ;==>_Other
#endregion
;------------Commands------------;