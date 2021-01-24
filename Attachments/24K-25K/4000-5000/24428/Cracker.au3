#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=orbz-air.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Change2CUI=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Debug_Mode=Y
#NoTrayIcon
#include <WinHTTP.au3>
#include <WinHTTPConstants.au3>
#include <INet.au3>
#include <String.au3>
#include <Array.au3>
#include <File.au3>
WinSetTitle(@HomeDrive,"","Cracker")
If IsDeclared($CmdLine) Then
	If IsArray($CmdLine) Then
		If $CmdLine[0] = 1 Then
			If IsInt($CmdLine[1]) Then
				$Threads = $CmdLine[1]
			EndIf
		EndIf
	EndIf
Else
	$file = FileRead(@ScriptDir & "/_Cracker.bat")
	$int = StringReplace($file, "Cracker.exe ", "")
	If StringIsInt($int) Then
		$Threads = $int
	Else
		Print("Call this Program From A .Bat File ! ! ! So Goodbye" & @CRLF)
		Sleep(2000)
		Exit
	EndIf
EndIf

Print("" & @CRLF)
Print("" & @CRLF)
Print("****************************************************************************" & @CRLF & "*    _               _      _    ____   _                                  *" & @CRLF & "*   / /             /_/    / /  / _  \ / /               _                 *" & @CRLF & "*  / /   _   _  ___ _  __ / /  / /_) // /_   __ _ _ __  / /____  _ __ ___  *" & @CRLF & "* / /   | | | |/ __| |/ _` |  /  ___/| '_ \ / _` | '_ \| __/ _ \| '_ ` _ \ *" & @CRLF & "*/ /____| |_| | (__| | (_| | /  /    | | | | (_| | | | | || (_) | | | | | |*" & @CRLF & "*\_____/ \__,_|\___|_|\__,_| \_/     |_| |_|\__,_|_| |_|_| \___/|_| |_| |_|*" & @CRLF & "****************************************************************************" & @CRLF)
Print("" & @CRLF)
Print("Cracker" & @CRLF)
Print("" & @CRLF)
Print("" & @CRLF)
Print("The amount of threads you entered to use is: " & $Threads & @CRLF)
Print("Preparing " & $Threads & " threads for cracking." & @CRLF)
Local $usernames, $passwords
If Not _FileReadToArray("usernames.txt", $usernames) Or Not _FileReadToArray("passwords.txt", $passwords) Then
	Print("Error Reading files, please make sure they all contain data" & @CRLF)
EndIf
_ArrayDelete($usernames, 0)
_ArrayDelete($passwords, 0)
If $Threads > UBound($usernames) Then
	Print("The amount of threads is larger than the amount of usernames, use a reasonable amount of threads." & @CRLF)
	sleep(5000)
	Exit
EndIf


$tUser = UBound($usernames) / $Threads
$CrackAmount = 0
$Totaltries = UBound($usernames) * UBound($passwords)
$speed = 0
$end = 1
$a = 0
DirRemove(@ScriptDir & "/tempdir/", 1)
DirCreate(@ScriptDir & "/tempdir/")
Do
	$border = Int(($end * $tUser))
	FileWriteLine(@ScriptDir & "/tempdir/usernames" & $end & ".txt", $usernames[$a])
	$a += 1
	If $a = $border Then
		$end += 1
	EndIf
Until $a = UBound($usernames)

Dim $PID[$Threads]
For $a = 0 To $Threads - 1
	$PID[$a] = Run(@ComSpec & " /c " & 'CrackThread.exe ' & $a + 1, "", @SW_HIDE, 2)
	Print("Called thread " & $a + 1 & @CRLF)
Next
$time = TimerInit()
while 1
	For $a = 0 to $Threads - 1
		$data = StdoutRead($PID[$a])
		If $data <> "" Then
			If StringInStr($data, "Invalid") Or StringInStr($data, "Crack") Then
				$CrackAmount += 1
				$speed = Int($CrackAmount/(Int(TimerDiff($time))/1000000))/1000
				$Triesleft = $Totaltries - $CrackAmount
				$timeleft = $Triesleft / $speed
				$h = Int($timeleft/3600)
				$timeleft -= $h*3600
				$m = Int($timeleft/60)
				$timeleft -= $m*60
				$s = Int($timeleft)				
				If $h = 0 Then
					If $m = 0 Then
						If $s = 0 Then
							$timeleft = "Finished"
						Else
							$timeleft = $s & "s"
						EndIf
					Else
						If $s = 0 Then
							$timeleft = $m & "m"
						Else
							$timeleft = $m & "m" & $s & "s"
						EndIf
					EndIf
				Else
					If $m = 0 Then
						If $s = 0 Then
							$timeleft = $h & "h"
						Else
							$timeleft = $h & "h" & $s & "s"
						EndIf
					Else
						If $s = 0 Then
							$timeleft = $h & "h" & $m & "m"
						Else
							$timeleft = $h & "h" & $m & "m" & $s & "s"
						EndIf
					EndIf
				EndIf
				WinSetTitle("Appie Cracker",'',"Appie Cracker - Tries: " & $CrackAmount & "|Tries/s: " & $speed & "|Tries left: " & $Triesleft & "|Time left: " & $timeleft)
			EndIf
			If StringInStr($data, "#") Then
				Print($CrackAmount & $data)
			Else
				Print($data)
			EndIf
		EndIf
	Next
WEnd
Func Print($oData)
	ConsoleWrite($oData)
EndFunc   ;==>Print