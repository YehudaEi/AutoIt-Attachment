#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <Base64.au3>

Global $PacketEND = "[PACKET_END]" ; Defines the end of a packet
Global $PacketMSG = "[PACKET_TYPE_0001]" ; Plain text message
Global $PacketPNG = "[PACKET_TYPE_0002]" ; Base64 of PNG binary.
Global $PacketPCI = "[PACKET_TYPE_0003]" ; UserName@PC name

$ip = @IPAddress1
$port = 1337

TCPStartup()
$socket = TCPConnect($ip, $port)
If @error Then
	MsgBox(16, "Error", "Could not connect. Exiting.")
	Exit
EndIf

Tests()

Func Tests()
	; Sends a plain message.
	MsgBox(0, "Test 1", "Sending a plain text message, the packet being send is: " & @CRLF & @CRLF & $PacketMSG & "This is a test message." & $PacketEND)
	TCPSend($socket, $PacketMSG & "This is a test message." & $PacketEND)

	; Sends the current user's name and the computers name.
	MsgBox(0, "Test 2", "Sending Username and Computername, the packet being sent is: " & @CRLF & @CRLF & $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)
	TCPSend($socket, $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)

	; Sends Base64 converted Globe.png
	MsgBox(0, "Test 3", "Sending Globe.png, the packet being sent is too large to show, but would be: " & @CRLF & @CRLF & $PacketPNG & "Base64_converted_binary" & $PacketEND)
	$File = @ScriptDir & "\" & "Globe.png"
	$FileOpen = FileOpen($File, 0)
	$FileRead = FileRead($FileOpen)
	$FileRead = BinaryMid($FileRead, 1, BinaryLen($FileRead))
	$Encoded = _Base64Encode($FileRead)
	FileClose($FileOpen)
	$Base64PNG = $PacketPNG & $Encoded & $PacketEND
	$Length = StringLen($Base64PNG)
	For $i = 1 To $Length Step 1000
		Sleep(10)
		TCPSend($socket, StringMid($Base64PNG, $i, 1000))
	Next
EndFunc