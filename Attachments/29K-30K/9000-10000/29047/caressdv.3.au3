#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT/Vista/Win 7
; Author:         Peter Atkin (computer-facilities.com)
; Credits:        verious
; Date:           27/01/2010
;
; Script Function:
; Generic Shutodown of remote servers in desired order;

#include <Constants.au3>
#include <Process.au3>

Dim $server[3]
$server[0] = "server1
$server[1] = "Server2"
$server[2] = "Server3"

password_option("password")
Exit

Func password_option($password)
	$gui = GUICreate("Password input", 250, 100)
	$label = GUICtrlCreateLabel("Enter serial code here: ", 10, 10, 180, 25)
	$input = GUICtrlCreateInput("", 10, 30, 100, 25)
	$button = GUICtrlCreateButton("OK", 10, 65, 50, 25)
	$xp = 0
	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3; this is the same sa $GUI_EVENT_CLOSE
				Exit
			Case $button
				$readinput = GUICtrlRead($input)
				If $readinput <> "" Then
					If $readinput = $password Then
						shutdown_servers()
						Exit
					Else
						MsgBox(64, "bad memory", "You've not forgotten the password again!")
						$xp = $xp + 1
						If $xp = 3 Then Exit
					EndIf
				Else
					MsgBox(64, "lazy", "You haven't typed anything in!")
				EndIf
		EndSwitch
		Sleep(25)
	WEnd
EndFunc   ;==>password_option

Func shutdown_servers()
	For $x = 0 To 2 Step 1
		$hostname = $server[$x]
		MsgBox(64, "remote shutting down:", $hostname, 1)
		RunAs("administrator", "cfu", "password",0 , @ComSpec & " /c " & "shutdown.exe -f -s -m \\" & $hostname & " -t 5 -c ""closing down"" ", @SystemDir, @SW_HIDE)
	Next
EndFunc   ;==>shutdown_servers
