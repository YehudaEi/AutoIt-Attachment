#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Bin\rss.exe
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
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
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <timers.au3>

Dim $server[2]
$server[0] = "10.0.0.4"
$server[1] = "10.0.0.1"

$s = UBound($server) - 1; get zize of array just take some leg work out of the for next loops, i'm quit lazy
$cmd = UBound($CmdLine) - 1; get zize of array just take some leg work out of the for next loops, i'm quit lazy

$password = "password"; not really for securiy just to stop mistakes.

$addomain = "cfu"
$adminuser = "administrator"
$adpassword = "password"

;Function keys to pause or terminate the script
Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{END}", "Terminate")

If $CmdLine[0] = 0 Then
Else
	ReadCmdLineParams()
EndIf

#Region ### START Koda GUI section ### Form=d:\documents and settings\peter\desktop\current\autoit\projects\remote server shutdown\remoteshutdown.kxf
$RemoteShutdown = GUICreate("Remote " & $s + 1 & " Server Shutdown", 312, 127, 222, 165)
GUISetBkColor(0xFFFFFF)
$cfu_small = GUICtrlCreatePic("D:\Documents and Settings\peter\Desktop\Current\cfu-logo-full.png", 200, 8, 100, 110, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
GUICtrlSetTip(-1, "Developed by www.computer-facilities.com")
$shutdown_all = GUICtrlCreateRadio("Shutdown All", 16, 8, 113, 17)
GUICtrlSetTip(-1, "Remote Shutdown all servers in list")
$reset_all = GUICtrlCreateRadio("Reset All", 16, 24, 113, 17)
GUICtrlSetTip(-1, "Remote reset all servers in list")
$manual_test = GUICtrlCreateRadio("Manual", 16, 48, 113, 17)
GUICtrlSetTip(-1, "shutdown or reset an single server")
$ping_server = GUICtrlCreateRadio("Test Server Presents", 16, 64, 121, 17)
$enter_password = GUICtrlCreateInput("Enter Password", 32, 96, 121, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ##

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $shutdown_all
			$readinput = GUICtrlRead($enter_password)
			If $readinput = $password Then
				shutdown_servers()
			Else
				MsgBox(32, "bad memory", "You've not forgotten the password again! you entered " & $readinput)
			EndIf
		Case $reset_all
			$readinput = GUICtrlRead($enter_password)
			If $readinput = $password Then
				reset_servers()
			Else
				MsgBox(32, "bad memory", "You've not forgotten the password again! " & $readinput)
			EndIf
		Case $manual_test
		Case $ping_server
			For $x = 0 To $s Step 1
				$host = $server[$x]
				PingIt($host)
			Next
	EndSwitch
WEnd

Func shutdown_servers()
	For $x = 0 To $s Step 1
		$hostname = $server[$x]
		MsgBox(64, "Shutting Down:", "remote system :" & $hostname, 1)
		$var = Ping($hostname, 250); is the server there? of course it may be blocking with a firewall so you need to check.
		If $var Then; also possible:  If @error = 0 Then ...
			RunAs($adminuser, $addomain, $adpassword, 0, @ComSpec & " /c " & "shutdown.exe -f -s -m \\" & $hostname & " -t 50 -c ""closing down"" ", @SystemDir, @SW_HIDE)
		Else
			MsgBox(16, "Server Status", "An error occured with :" & $hostname & @CRLF & @CRLF & "make sure the server is on or that the firewall allow pings" & @CRLF & "failing that give peter a call 0772 700781", 5)
		EndIf
	Next
EndFunc   ;==>shutdown_servers

Func reset_servers()
	For $x = 0 To $s Step 1
		$hostname = $server[$x]
		MsgBox(64, "Resetting:", "remote system :" & $hostname, 1)
		$var = Ping($hostname, 250); is the server there? of course it may be blocking with a firewall so you need to check.
		If $var Then; also possible:  If @error = 0 Then ...
			RunAs($adminuser, $addomain, $adpassword, 0, @ComSpec & " /c " & "shutdown.exe -f -r -m \\" & $hostname & " -t 50 -c ""resetting"" ", @SystemDir, @SW_HIDE)
		Else
			MsgBox(16, "Server Status", "An error occured with :" & $hostname & @CRLF & @CRLF & "make sure the server is on or that the firewall allow pings" & @CRLF & "failing that give peter a call 0772 700781", 5)
		EndIf
	Next
EndFunc   ;==>reset_servers

Func PingIt($host)
	; thanks to msrtin for this little snippet, still needs a load of work but its a start..
	; http://www.autoitscript.com/forum/index.php?showtopic=87145&st=0&p=625229&hl=ping%20output&fromsearch=1&#entry625229

	$ping_form = GUICreate("Ping Output", 413, 298, 303, 219)

	Local $foo = Run("ping.exe " & $host, @SystemDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)

	; Calling with no 2nd arg closes stream
	StdinWrite($foo)

	; Read from child's STDOUT and show
	Local $data
	While True
		$data &= StdoutRead($foo)
		If @error Then ExitLoop
		Sleep(25)
	WEnd
	_Timer_KillAllTimers($ping_form)
	MsgBox(64, "Debug Results", $data)
EndFunc   ;==>PingIt

Func ReadCmdLineParams()
	For $i = 1 To $cmd
		Select
			Case $CmdLine[$i] = "-reset"
				silent_reset()
				Exit
			Case $CmdLine[$i] = "-shutdown"
				silent_shutdown()
				Exit
			Case Else
				cmdLineHelpMsg()
		EndSelect
	Next
EndFunc   ;==>ReadCmdLineParams

Func cmdLineHelpMsg()
	MsgBox(16, "Help", "Reset Remote Servers tool developed by Computer Facilities" & @CRLF & @CRLF & "www.computer-facilities.com" & @CRLF & @CRLF & "END (key) = terminate program while in GUI mode" & @CRLF & "-h = help window this one" & @CRLF & "-shudown = silent remote shutdown" & @CRLF & "-reset = silent remote reset", 0)
	Exit
EndFunc   ;==>cmdLineHelpMsg

Func silent_reset()
	For $x = 0 To $s Step 1
		$hostname = $server[$x]
		RunAs($adminuser, $addomain, $adpassword, 0, @ComSpec & " /c " & "shutdown.exe -f -r -m \\" & $hostname & " -t 50 -c ""resetting"" ", @SystemDir, @SW_HIDE)
	Next
EndFunc   ;==>silent_reset

Func silent_shutdown()
	For $x = 0 To $s Step 1
		$hostname = $server[$x]
		RunAs($adminuser, $addomain, $adpassword, 0, @ComSpec & " /c " & "shutdown.exe -f -s -m \\" & $hostname & " -t 50 -c ""shutdown"" ", @SystemDir, @SW_HIDE)
	Next
EndFunc   ;==>silent_shutdown

Func TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', (1), (8), (1), (8))
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	Exit
EndFunc   ;==>Terminate