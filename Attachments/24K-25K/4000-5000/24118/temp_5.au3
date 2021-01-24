#include <GUIConstantsEX.au3>
#include <Misc.au3>
#include <Process.au3>
Opt('GUIOnEventMode', True)
; vars
HotKeySet("^x", "_Bye")
$my_version = "0.90.8"

; Applications we will use
$treepad = "C:\Documents and Settings\My Documents\- Tools\Treepad"
$ccconsole = @ScriptDir & "\Console.exe"
$vncviewer = @ScriptDir & "\UltraVNC\vncviewer.exe"
$keepass = @ScriptDir & "\KeePass.exe"
$stopwatch = @ScriptDir & "\stopwtch.exe"
$puttycm = @ScriptDir & "\puttycm.exe"
$putty = @ScriptDir & "\putty.exe"

If WinExists("My Tools") Then
	MsgBox(4096, "Info", "Only one copy of this application script can be run at once!!!" & @CRLF & @CRLF & " Program will now exit.", 6)
	Exit
EndIf

$MainForm = GUICreate("My Tools", 499, 447, 270, 98)
GUISetOnEvent($GUI_EVENT_CLOSE, '_Exit', $MainForm)
$Context_Menu = GUICtrlCreateContextMenu()
$Item_1 = GUICtrlCreateMenuItem("About", $Context_Menu)
GUICtrlSetOnEvent($Item_1, "_About")
$Item_2 = GUICtrlCreateMenuItem("Exit", $Context_Menu)
GUICtrlSetOnEvent($Item_2, "_Exit")
GUICtrlCreateLabel("<== My Notes ==>", 35, 18)
$cCommand = GUICtrlCreateEdit("", 32, 40, 337, 377)
$Button0 = GUICtrlCreateButton("Copy My Notes", 392, 46, 89, 23, 0)
GUICtrlSetOnEvent($Button0, "MyClip")
$Button1 = GUICtrlCreateButton("RAS", 392, 77, 89, 23, 0)
GUICtrlSetOnEvent($Button1, "RasDial")
$Button2 = GUICtrlCreateButton("Putty", 392, 108, 89, 23, 0)
GUICtrlSetOnEvent($Button2, "Putty")
$Button3 = GUICtrlCreateButton("Telnet", 392, 139, 89, 23, 0)
GUICtrlSetOnEvent($Button3, "Telnet")
$Button4 = GUICtrlCreateButton("VNC", 392, 170, 89, 23, 0)
GUICtrlSetOnEvent($Button4, "vnc")
$Button5 = GUICtrlCreateButton("Console 2", 392, 201, 89, 23, 0)
GUICtrlSetOnEvent($Button5, "Console2")
$Button6 = GUICtrlCreateButton("KeePass", 392, 232, 89, 23, 0)
GUICtrlSetOnEvent($Button6, "KeePass")
$Button7 = GUICtrlCreateButton("Timer", 392, 263, 89, 23, 0)
GUICtrlSetOnEvent($Button7, "Timer")
$Button8 = GUICtrlCreateButton("CMD Prompt", 392, 294, 89, 23, 0)
GUICtrlSetOnEvent($Button8, "Cmdprompt")
$Button9 = GUICtrlCreateButton("Ping", 392, 325, 89, 23, 0)
GUICtrlSetOnEvent($Button9, "Pinger")
$Button10 = GUICtrlCreateButton("Treepad", 392, 356, 89, 23, 0)
GUICtrlSetOnEvent($Button10, "Treepad")
$Button11 = GUICtrlCreateButton("Spare", 392, 387, 89, 23, 0)
GUICtrlSetOnEvent($Button11, "Spare")
$Button12 = GUICtrlCreateButton("More", 392, 418, 89, 23, 0)
GUICtrlSetOnEvent($Button12, "SecondGUI")

$SecondForm = GUICreate("My Tools", 499, 447, 270, 98)
GUISetOnEvent($GUI_EVENT_CLOSE, '_Exit', $SecondForm)
GUICtrlCreateLabel("<== Second page ==>", 35, 18)
$cCommand2 = GUICtrlCreateEdit("", 32, 40, 337, 377)
$Button20 = GUICtrlCreateButton("Copy My Notes", 392, 46, 89, 23, 0)
GUICtrlSetOnEvent($Button20, "Spare")
$Button21 = GUICtrlCreateButton("Button 21", 392, 77, 89, 23, 0)
GUICtrlSetOnEvent($Button21, "Spare")
$Button22 = GUICtrlCreateButton("Button 22", 392, 108, 89, 23, 0)
GUICtrlSetOnEvent($Button22, "Spare")
$Button23 = GUICtrlCreateButton("Button 23", 392, 139, 89, 23, 0)
GUICtrlSetOnEvent($Button23, "Spare")
$Button24 = GUICtrlCreateButton("Button 24", 392, 170, 89, 23, 0)
GUICtrlSetOnEvent($Button24, "Spare")
$Button25 = GUICtrlCreateButton("Button 25", 392, 201, 89, 23, 0)
GUICtrlSetOnEvent($Button25, "Spare")
$Button26 = GUICtrlCreateButton("Button 26", 392, 232, 89, 23, 0)
GUICtrlSetOnEvent($Button26, "Spare")
$Button27 = GUICtrlCreateButton("Button 27", 392, 263, 89, 23, 0)
GUICtrlSetOnEvent($Button27, "Spare")
$Button28 = GUICtrlCreateButton("Button 28", 392, 294, 89, 23, 0)
GUICtrlSetOnEvent($Button28, "Spare")
$Button29 = GUICtrlCreateButton("Button 29", 392, 325, 89, 23, 0)
GUICtrlSetOnEvent($Button29, "Spare")
$Button30 = GUICtrlCreateButton("Button 30", 392, 356, 89, 23, 0)
GUICtrlSetOnEvent($Button30, "Spare")
$Button31 = GUICtrlCreateButton("Button 31", 392, 387, 89, 23, 0)
GUICtrlSetOnEvent($Button31, "Spare")
$Button32 = GUICtrlCreateButton("Return to Main", 392, 418, 89, 23, 0)
GUICtrlSetOnEvent($Button32, "ReturnMainGUI")

GUISetState(@SW_SHOW, $MainForm)
While 1
	$msg = GUIGetMsg()
	If $msg = $Item_2 Or $msg = -3 Or $msg = -1 Then
		ExitLoop
	EndIf
	Sleep(10) ; Idle around
WEnd

Func MainGUI()
	GUISetState(@SW_SHOW, $MainForm)
EndFunc   ;==>MainGUI

Func SecondGUI()
	$Pos = WinGetPos($MainForm)
	WinMove($SecondForm, "", $Pos[0], $Pos[1])
	GUISetState(@SW_HIDE, $MainForm)
	GUISetState(@SW_SHOW, $SecondForm)
	; $msg2 = GUIGetMsg()
EndFunc   ;==>SecondGUI

Func ReturnMainGUI()
	GUISetState(@SW_HIDE, $SecondForm)
	GUISetState(@SW_SHOW, $MainForm)
EndFunc   ;==>ReturnMainGUI

Func CmdPrompt()
	Run("cmd")
EndFunc   ;==>CmdPrompt

Func Timer()
	Run($stopwatch)
	If @error Then
		SplashTextOn("Notice - Error", " Your stopwatch command failed." & @CRLF & "No stopwatch application was found." & @CRLF, 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>Timer

Func KeePass()
	Run($keepass)
	If @error Then
		SplashTextOn("Notice - Error", " Your KeePass application failed." & @CRLF & "No KeePass application was found." & @CRLF, 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>KeePass

Func RasDial()
	Run(@ScriptDir & "\RAS-Dial.exe")
	If @error Then
		SplashTextOn("Notice - Error", " Your RAS-Dial command failed." & @CRLF & "RAS-Dial.exe was not found." & @CRLF, 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>RasDial

Func Console2()
	Run($ccconsole)
	If @error Then
		SplashTextOn("Notice - Error", " Your console command failed." & @CRLF & "No console application was found." & @CRLF, 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>Console2

Func MyClip()
	ClipPut("") ; clear to prevent duplicate entries
	ClipPut(GUICtrlRead($cCommand) & @CRLF)
	If (@error == 1) Then
		MsgBox(0, "", "Unable to copy to the ClipBoard.")
	EndIf
	;EndSelect
	Sleep(2000)
EndFunc   ;==>MyClip

Func Telnet()
	$ip = InputBox("IP", "Enter IP to connect to", @IPAddress1)
	If (@error == 1) Then
		MsgBox(0, "", "canceled.")
		Return 0
	EndIf
	Run("telnet " & $ip)
	If @error Then
		SplashTextOn("Notice - Error", " Your telnet command failed." & @CRLF & "No telent command avaliable.", 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>Telnet

Func PuttyCM()
	Run($puttycm)
	If @error Then
		SplashTextOn("Notice - Error", " Your PuttyCM application failed." & @CRLF & "No PuttyCM application was found.", 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>PuttyCM

Func Putty()
	$ssh = InputBox("IP", "Enter IP to connect to", @IPAddress1)
	If (@error == 1) Then
		MsgBox(0, "", "Canceled.")
		Return 0
	EndIf
	Run("putty " & $ssh)
	If @error Then
		SplashTextOn("Notice - Error", " Your putty command failed." & @CRLF & "No putty command avaliable.", 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>Putty

Func vnc()
	$servername = InputBox("IP", "Enter IP to connect to", @IPAddress1)
	If (@error == 1) Then
		MsgBox(0, "", "Canceled.")
		Return 0
	EndIf
	Run($vncviewer & " " & $servername)
	If @error Then
		SplashTextOn("Notice - Error", " Your Ultravnc command failed." & @CRLF & "No UltraVNC command avaliable.", 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>vnc

Func Treepad()
	; run($treepad)
	ShellExecute($treepad)
	If @error Then
		SplashTextOn("Notice - Error", " Treepad failed." & @CRLF & "No Treepad application avaliable.", 380, 65)
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>Treepad

Func Pinger()
	$ip = InputBox("IP", "Enter IP address you wish to ping")
	If (@error == 1) Then
		MsgBox(4096, "", "Canceled.")
		Return 0
	EndIf
	Run("ping " & $ip)
EndFunc   ;==>Pinger

Func Spare()
	MsgBox(4096, "Info", "Not yet implemented", 3)
EndFunc   ;==>Spare

Func dbg($msg)
	DllCall("kernel32.dll", "none", "OutputDebugString", "str", $msg)
EndFunc   ;==>dbg

Func _About()
	MsgBox(0, "About", "My Tool Box " & $my_version, 4)
EndFunc   ;==>_About

Func _Bye()
	;SoundPlay(@WindowsDir & "\media\tada.wav",1)
	MsgBox(0, "Bye", "Exiting program", 4)
	Exit
EndFunc   ;==>_Bye

Func _Exit()
	;$info = ClipGet()
	;If clipboard is not empty do you want to save?
	;if (GuiCtrlRead($cCommand)) == "" Then
	; continue
	;Else
	; MsgBox(4096,"Info", "My Notes is not empty!!", 3)
	;EndIf
	Exit
EndFunc   ;==>_Exit