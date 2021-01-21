; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.99 beta
; Author:         Chris Lambert
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GuiConstants.au3>

opt("RunErrorsFatal", 0)
opt("WinTitleMatchMode", 4)
opt("TrayMenuMode", 1)

$Port = Int(IniRead("WinServer.ini", "General", "portNo", "8000"))
Global $MaxConc = 100
$card = Int(IniRead("WinServer.ini", "General", "UseNetCardNo", "1"))

Switch $card
	Case 1
		$IPAddress = @IPAddress1
	Case 2
		$IPAddress = @IPAddress2
	Case 3
		$IPAddress = @IPAddress3
	Case 4
		$IPAddress = @IPAddress4
	Case Else
		$IPAddress = @IPAddress1
EndSwitch

Global $MainSocket = TCPStartServer($Port, $MaxConc)
If @error <> 0 Then Exit MsgBox(16, "Error", "Server unable to initialize." & @crlf & _
		"Check the correct network card is set and port is not already in use" & @crlf & _
		"Selected network card address is :" & $IPAddress & " Port number is :" & $Port)
Global Const $MaxLength = 512
Global $ConnectedSocket[$MaxConc]
Global $CurrentSocket = 0
Local $Track = 0
Global Const $MaxConnection = ($MaxConc - 1)

$RadPath = IniRead("winServer.ini", "General", "RadminPath", "c:\Program Files\Radmin\")
If StringRight($RadPath, 1) <> '\' Then $RadPath = $RadPath & '\'
$RadRes = Int(IniRead("winServer.ini", "General", "HiColour", "0"))
$TimeOut = Int(IniRead("winServer.ini", "General", "MsgTimeOut", "120"))

$Colour = " /locolor "
If $RadRes = 1 Then $Colour = " /hicolor "

For $Track = 0 To $MaxConnection Step 1
	$ConnectedSocket[$Track] = -1
Next

$Exititem = TrayCreateItem("Exit")

While 1
	
	$tray = TrayGetMsg()
	Select
		Case $tray = 0
			
			$ConnectedSocket[$CurrentSocket] = TCPAccept($MainSocket)
			If $ConnectedSocket[$CurrentSocket] <> - 1 Then
				$CurrentSocket = SocketSearch()
			EndIf
			$Track = 0
			For $Track = 0 To $MaxConnection Step 1
				If $ConnectedSocket[$Track] <> - 1 Then
					$Data = TCPRecv($ConnectedSocket[$Track], $MaxLength)
					If StringRight($Data, 4) = "~bye" Then
						TCPCloseSocket($ConnectedSocket[$Track])
						$ConnectedSocket[$Track] = -1
						$CurrentSocket = SocketSearch()
					ElseIf $Data <> "" Then
						SendData($Data)
					EndIf
				EndIf
			Next
		Case $tray = $Exititem
			ExitLoop
	EndSelect
WEnd
Func SendData($Cmd)
	;$Cmd = '"' & $Cmd & '"'
	;MsgBox (0,"",'"' & $Cmd & '"')
	;$msgHan = Run (@scriptdir & "\ErrWin.exe " & $Cmd)
	
	$Error = StringSplit($Cmd, Chr(01))
	If $Error[0] = 3 Then
		If FileExists($RadPath & "Radmin.exe") Then
			$Result = MsgBox(262180, $Error[2], "The message " & @crlf & @crlf & $Error[3] & @crlf & _
					"Has occured on the computer " & $Error[1] & @crlf & "Would you like to connect to " & $Error[1] & " now?", $TimeOut)
			If $Result = 6 Then
				;MsgBox (0,"",$Error[1])
				$RadHandle = Run($RadPath & "\radmin.exe /connect:" & $Error[1] & $Colour & "/updates:5 /fullscreen", $RadPath)
				
				Sleep(1500)
				$Switch = GUICreate("Switch", 72, 20, (@DesktopWidth / 2 - (72 / 2)) , (1), $WS_Popup)
				;WinWait ($Error[1],"", 20)
				WinSetOnTop($Switch, "", 1)
				$Button_1 = GUICtrlCreateLabel("Close View", 1, 1, 70, 18, $SS_CENTER, $WS_EX_WINDOWEDGE)
				GUICtrlSetFont($Button_1, 10)
				GUISetBkColor(0x000000, $Switch)
				GUICtrlSetBkColor($Button_1, "0xFF0000")
				GUISetState()
				If WinExists("SOS") Then WinSetOnTop("SOS", "??", 0)
				
				While 1
					$msg = GUIGetMsg()
					Select
						Case $msg = $GUI_EVENT_CLOSE
							ExitLoop
						Case $msg = $Button_1
							
							ProcessClose($RadHandle)
							ExitLoop
						Case Else
							WinSetOnTop($Switch, "", 1)
							;;;
					EndSelect
				WEnd
				GUIDelete($Switch)
				If WinExists("SOS") Then WinSetOnTop("SOS", "??", 1)
				
			EndIf   ;End if result = yes
			
		Else
			MsgBox(262144, $Error[2], "The message " & @crlf & @crlf & $Error[3] & @crlf & _
					"Has occured on the computer " & $Error[1] & @crlf & "You do not have the Radmin component to remotely access the computer", $TimeOut)
		EndIf
	EndIf   ;End check Error array qty
	
EndFunc   ;==>SendData
Func SocketSearch()
	Local $Track = 0
	For $Track = 0 To $MaxConnection Step 1
		If $ConnectedSocket[$Track] = -1 Then
			Return $Track
		Else
			; Socket In Use
		EndIf
	Next
EndFunc   ;==>SocketSearch

Func TCPStartServer($Port, $MaxConnect = 1)
	Local $Socket
	$Socket = TCPStartup()
	Select
		Case $Socket = 0
			SetError(@error)
			Return -1
	EndSelect
	$Socket = TCPListen($IPAddress, $Port, $MaxConnect)
	Select
		Case $Socket = -1
			SetError(@error)
			Return 0
	EndSelect
	SetError(0)
	Return $Socket
EndFunc   ;==>TCPStartServer

