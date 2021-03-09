#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

TCPStartup()

Global Const $number_of_connections			= 1000					; Total number of connections to perform
Global Const $ip			 				= @IPAddress1			; IP address
Global Const $port 							= 1337					; Port
Global $connection_array[$number_of_connections + 1]
Global $errors = 0
Global $test

_Test()

Func _Test()
	Local $count
	Local $timer = TimerInit()
	For $i = 1 To $number_of_connections
		$connection_array[$i] = TCPConnect($ip, $port)
		If @error Then
			$errors += 1
		EndIf
	Next
	MsgBox(0, "", $number_of_connections & " connections in " & TimerDiff($timer) / 1000 & " seconds, with " & $errors & " error(s).")
	For $i = 1 To $number_of_connections
		TCPCloseSocket($connection_array[$i])
		If @error Then
			$errors += 1
		EndIf
	Next
EndFunc

TCPShutdown()