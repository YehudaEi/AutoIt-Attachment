#include <Date.au3>
#include <GUIEdit.au3>
#include <guicombo.au3>
#include <array.au3>
#Include <GuiListView.au3>
#include <GuiTreeView.au3>
#include <GUIConstants.au3>
#include <Constants.au3>
#include <String.au3>
#include <File.au3>
#include "Misc.au3"
#include "Inet.au3"
#include "FTP.au3"
#include "P2PTCP.au3"
#include "IE.au3"
#include "Math.au3"


ConsoleWrite( "Starting services:")
_P2P_Start_Node( Random( 0, 9999999999, 1), 43215, 400, 1, 18, 0)
_P2P_Register_Event($P2P_NEWCONNECTION, "new")
_P2P_Register_Event($P2P_RECEIVE, "recv")
_P2P_Register_Event($P2P_DISCONNECT, "lost")
_P2P_Register_Event($P2P_CONNECT, "conn")

HotKeySet( "d", "connect") ;connect to yourself!
HotKeySet( "e", "_send") ;Send some data!
While 1
	Sleep( 1000)
WEnd

Func new($Socket, $iError)
	ConsoleWrite(@CRLF & "New connectee! " & $Socket)
EndFunc

Func lost( $Socket, $error)
	ConsoleWrite(@CRLF & "Peer disconnected: " & $Socket)
EndFunc


Func recv($Socket, $data, $iError)
	ConsoleWrite(@CRLF & "FROM: " & $Socket)
	ConsoleWrite(@CRLF & "DATA: " & $data)
EndFunc

Func conn($Socket, $iError)
	if not $iError Then
	ConsoleWrite(@CRLF & "Connection Successful: " & $Socket)
Else
	ConsoleWrite(@CRLF & "Problem connection attempt: " & $Socket)
EndIf
EndFunc

Func connect()
	_P2P_Connect( @IPAddress1)
EndFunc

Func _send()
	_P2P_Broadcast("some data")
EndFunc

