;CLIENT!!!!!!!! Start SERVER First... dummy!!

writeDebug("Starting the Apps")

$socket = -1

#NoTrayIcon
#include <G:\Programs\autoit-v3_beta\include\GUIConstants.au3>
#include <G:\Programs\autoit-v3_beta\include\GuiEdit.au3>
#include "RTF_writer.au3"

writeDebug("Included needed files")

$hPlug = PluginOpen ("rtfplugin.dll")

writeDebug("PluginOpen rtfplugin.dll")

Opt("WinTitleMatchMode", 2)

TCPStartup()

writeDebug("TCPStartup()")

Global Const $FS_NORMAL		= 0
Global Const $FS_BOLD		= 1
Global Const $FS_ITALIC		= 2
Global Const $FS_UNDERLINE	= 4
Global Const $FS_STRIKEOUT	= 8

$g_PORT = "3333"
$g_IP = TCPNameToIP("nsa-gingrasg")

Global $ID_CLIENT

$g_Name = InputBox("vPop","What is your name?")
If $g_Name = "" Then Exit

; Connect to a Listening "SOCKET"
;==============================================
writeDebug("Openning socket")
$socket = TCPConnect($g_IP, $g_PORT)
writeDebug("Socket openned")
If @ERROR Or $socket < 0 Then
   MsgBox(0,"Error:","Unable to connect to server [" & $g_IP & "]")
   Exit
EndIf

writeDebug("Creating GUI")
; Create a GUI for chatting
;==============================================
$GOOEY = GUICreate("vPop - " & $g_Name & "'s Chat Session",500,405)

;Menu
$mnuFile = GUICtrlCreateMenu("&File")
$mnuFileExit = GUICtrlCreateMenuitem("E&xit", $mnuFile)
$mnuOption = GUICtrlCreateMenu("&Option")
$mnuOptionClear = GUICtrlCreateMenuitem("&Clear window", $mnuOption)

$edit = GUICtrlCreateRTFEdit($GOOEY, 5, 5, 490, 350, BitOR($WS_VSCROLL,$ES_READONLY,$ES_AUTOVSCROLL), BitOR($WS_EX_TOOLWINDOW, $WS_EX_STATICEDGE))
GUICtrlSetFont(-1,10,600,-1,"Arial")
$input = GUICtrlCreateInput("",5,360,410,20)
$butt = GUICtrlCreateButton("Send",415,360,80,20,$BS_DEFPUSHBUTTON)
GUISetState()
GUICtrlSetState($input,$GUI_FOCUS)

writeDebug("GUI created")

; GUI Message Loop
;==============================================
writeDebug("Soon in the main loop")
While 1
   $msg = GUIGetMsg()

; Menu MSGs
	If $msg = $mnuFileExit Then 
		writeDebug("mnuFileExit")
		ExitLoop
	EndIf
	If $msg = $mnuOptionClear Then clearScreen()

; GUI Closed
;--------------------
	If $msg = $GUI_EVENT_CLOSE Then 
		writeDebug("GUI_EVENT_CLOSE")
		ExitLoop
	EndIf

; User Pressed SEND
;--------------------
   If $msg = $butt Then
	writeDebug("User Pressed SEND")
	Select
	Case GUICtrlRead($input) = "/random"
		writeDebug("Typed: #SLASHCMD_RANDOM")
		$ret = TCPSend($socket, "#SLASHCMD_RANDOM")
	Case Else
		writeDebug("Typed: #CHATSAY")
		$ret = TCPSend($socket, "#CHATSAY" & chr(2) & GUICtrlRead($input))
	EndSelect
    If @ERROR Or $ret < 0 Then
		MsgBox(16, "Error", "@ERROR: " & @ERROR & @CRLF & "$ret: " & $ret) 
		ExitLoop
	EndIf
    GUICtrlSetData($input,"")
    GUICtrlSetState($input,$GUI_FOCUS)
   EndIf
   
   $ret = TCPRecv($socket, 1024)
	If @ERROR Or $ret < 0 Then 
		writeDebug("Connection error, unable to contact server.")
		MsgBox(16,"Connection error","Unable to contact the server." & @CRLF & @CRLF & "Closing vPOP")
		ExitLoop
	EndIf
   ;If $ret <> "" Then MsgBox(0, "DEBUG: $ret", $ret)
   Process($ret)
WEnd

Func OnAutoItExit()
	writeDebug("Closing it all; OnAutoItExit()")
	PluginClose($hPlug)
	If $socket >= 0 Then TCPCloseSocket($socket)
	TCPShutDown()
	writeDebug("Everything is closed.")
EndFunc

Func writeToScreen($text, $hex_color, $font_size, $font_style, $font_name)
	writeDebug("writeToScreen()")
	writeDebug("Local $out = _RTFCreateDocument($font_name)")
	Local $out = _RTFCreateDocument($font_name)
	writeDebug("$out = _RTFAppendString($out, $text & @CRLF, $hex_color, $font_size, $font_style, $font_name)")
    $out = _RTFAppendString($out, $text & @CRLF, $hex_color, $font_size, $font_style, $font_name)
	writeDebug("_GUICtrlEditSetSel ($edit, StringLen(GUICtrlRTFGet($edit)), StringLen(GUICtrlRTFGet($edit)))")
	_GUICtrlEditSetSel ($edit, StringLen(GUICtrlRTFGet($edit)), StringLen(GUICtrlRTFGet($edit)))
	writeDebug("GUICtrlRTFSet ($edit, $out, 1)")
    GUICtrlRTFSet ($edit, $out, 1)
    Sleep(100)
EndFunc

Func clearScreen()
	writeDebug("clearScreen()")
	Local $out = _RTFCreateDocument("MS Sans Serif")
	GUICtrlRTFSet ($edit, $out, 0)
	;Sleep(100)
EndFunc

Func PlayWarning()
	writeDebug("PlayWarning()")
	If NOT WinActive("vPop") Then
		If FileExists(@WindowsDir & "\Media\Windows XP Balloon.wav") Then
			SoundPlay(@WindowsDir & "\Media\Windows XP Balloon.wav")
		EndIf
	EndIf
EndFunc

Func Process($data)
	$dataArray = StringSplit($data, chr(2), 1)
	$dataHeader = $dataArray[1]
	;If $dataHeader <> "" Then MsgBox(0, "DEBUG: $dataHeader", $dataHeader)
	Select
	Case $dataHeader = "#CHATSAY"
		writeDebug("Received #CHATSAY")
		writeToScreen($dataArray[2] & "> " & $dataArray[3], 0x000000, 13, $FS_NORMAL, "Garamond")
		PlayWarning()
	Case $dataHeader = "#BROADCAST"
		writeDebug("Received #BROADCAST")
		writeToScreen("## Server: " & $dataArray[2] & " ##", 0x000000, 13, $FS_BOLD, "Garamond")
	Case $dataHeader = "#ACKCONNECTION"
		writeDebug("Received #ACKCONNECTION")
		$ID_CLIENT = $dataArray[2]
		TCPSend($socket, "#ACKCONNECTION" & chr(2) & $g_Name)
	Case $dataHeader = "#RANDOM"
		writeDebug("Received #RANDOM")
		writeToScreen($dataArray[2] & " rolled a " & $dataArray[3] & ".", 0x000000, 13, $FS_NORMAL, "Garamond")
	EndSelect
EndFunc

Func writeDebug($textToWrite)
	$file = FileOpen( @ScriptDir & "\debug.txt",1)
	$timestamp = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & "h " & @MIN & ":" & @SEC
	FileWriteLine($file, $timestamp & " " & $textToWrite)
	FileClose($file)
EndFunc