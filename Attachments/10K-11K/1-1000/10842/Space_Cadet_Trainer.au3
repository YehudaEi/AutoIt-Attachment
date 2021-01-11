; Space Cadet Trainer.au3
; AutoIt Version 3.2.1.1 Beta

#NoTrayIcon
#include <GUIConstants.au3>

$ScriptName = "Space Cadet Trainer"
$Process = WinGetProcess("3D Pinball for Windows - Space Cadet")
$CurrentPlayer = 0;
$CurrentPlayer2 = 0;
$CurrentPlayerScore = 0;
$CurrentPlayerScore2 = 0;
$Player1Score = 0;
$Player1Score2 = 0;
$Player2Score = 0;
$Player2Score2 = 0;
$Player3Score = 0;
$Player3Score2 = 0;
$Player4Score = 0;
$Player4Score2 = 0;

If $Process = -1 Then
	MsgBox(0, $ScriptName, "Please start Space Cadet before running this trainer.")
	Exit
EndIf

; Create a window.
GuiCreate($ScriptName, 300, 140)

; Turn on event driven mode.
Opt("GUIOnEventMode", 1)

; Set the window's close event to call our Quit() function.
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

$Horizontal_X = 10
$Vertical_Y = 10
GUICtrlCreateLabel("Current Player:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$CurrentPlayerControlID = GUICtrlCreateInput($CurrentPlayer, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))

$Horizontal_X = 10
$Vertical_Y = $Vertical_Y + 20
GUICtrlCreateLabel("Current Player's Score:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$CurrentPlayerScoreControlID = GUICtrlCreateInput($CurrentPlayerScore, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))
$Horizontal_X = $Horizontal_X + 50
GUICtrlCreateButton("Set", $Horizontal_X, $Vertical_Y, 25, 20)
GUICtrlSetOnEvent(-1, "SetCurrentPlayerScore")

$Horizontal_X = 10
$Vertical_Y = $Vertical_Y + 20
GUICtrlCreateLabel("Player 1's Score:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$Player1ScoreControlID = GUICtrlCreateInput($Player1Score, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))
$Horizontal_X = $Horizontal_X + 50
GUICtrlCreateButton("Set", $Horizontal_X, $Vertical_Y, 25, 20)
GUICtrlSetOnEvent(-1, "SetPlayer1Score")

$Horizontal_X = 10
$Vertical_Y = $Vertical_Y + 20
GUICtrlCreateLabel("Player 2's Score:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$Player2ScoreControlID = GUICtrlCreateInput($Player2Score, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))
$Horizontal_X = $Horizontal_X + 50
GUICtrlCreateButton("Set", $Horizontal_X, $Vertical_Y, 25, 20)
GUICtrlSetOnEvent(-1, "SetPlayer2Score")

$Horizontal_X = 10
$Vertical_Y = $Vertical_Y + 20
GUICtrlCreateLabel("Player 3's Score:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$Player3ScoreControlID = GUICtrlCreateInput($Player3Score, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))
$Horizontal_X = $Horizontal_X + 50
GUICtrlCreateButton("Set", $Horizontal_X, $Vertical_Y, 25, 20)
GUICtrlSetOnEvent(-1, "SetPlayer3Score")

$Horizontal_X = 10
$Vertical_Y = $Vertical_Y + 20
GUICtrlCreateLabel("Player 4's Score:", $Horizontal_X, $Vertical_Y, 120, 20)
$Horizontal_X = $Horizontal_X + 120
$Player4ScoreControlID = GUICtrlCreateInput($Player4Score, $Horizontal_X, $Vertical_Y, 50, 20, BitOR($ES_RIGHT, $ES_NUMBER))
$Horizontal_X = $Horizontal_X + 50
GUICtrlCreateButton("Set", $Horizontal_X, $Vertical_Y, 25, 20)
GUICtrlSetOnEvent(-1, "SetPlayer4Score")

; Show the window.
GUISetState(@SW_SHOW)

; Loop to keep the script running while we are doing things.
While 1
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	$CurrentPlayer = MemoryRead($Handle, "0x007AFC04")
    If @error Then Exit
    If $CurrentPlayer <> $CurrentPlayer2 Then
		GUICtrlSetData($CurrentPlayerControlID, $CurrentPlayer)
		$CurrentPlayer2 = $CurrentPlayer
	EndIf

	$CurrentPlayerScore = MemoryRead($Handle, "0x007AB302")
	If @error Then Exit
    If $CurrentPlayerScore <> $CurrentPlayerScore2 Then
		GUICtrlSetData($CurrentPlayerScoreControlID, $CurrentPlayerScore)
		$CurrentPlayerScore2 = $CurrentPlayerScore
	EndIf

	$Player1Score = MemoryRead($Handle, "0x007AB31A")
	If @error Then Exit
    If $Player1Score <> $Player1Score2 Then
		GUICtrlSetData($Player1ScoreControlID, $Player1Score)
		$Player1Score2 = $Player1Score
	EndIf

	$Player2Score = MemoryRead($Handle, "0x007AB336")
	If @error Then Exit
    If $Player2Score <> $Player2Score2 Then
		GUICtrlSetData($Player2ScoreControlID, $Player2Score)
		$Player2Score2 = $Player2Score
	EndIf

	$Player3Score = MemoryRead($Handle, "0x007AB352")
	If @error Then Exit
    If $Player3Score <> $Player3Score2 Then
		GUICtrlSetData($Player3ScoreControlID, $Player3Score)
		$Player3Score2 = $Player3Score
	EndIf

	$Player4Score = MemoryRead($Handle, "0x007AB36E")
	If @error Then Exit
    If $Player4Score <> $Player4Score2 Then
		GUICtrlSetData($Player4ScoreControlID, $Player4Score)
		$Player4Score2 = $Player4Score
	EndIf

	MemoryClose($Handle)
	If @error Then Exit

	Sleep(1000)
WEnd



Func Quit()
	Exit
EndFunc



Func SetCurrentPlayerScore()
	$CurrentPlayerScore = GUICtrlRead($CurrentPlayerScoreControlID)
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	MemoryWrite($Handle, "0x007AB302", $CurrentPlayerScore)
	If @error Then Exit

	MemoryClose($Handle)
	If @error Then Exit
EndFunc



Func SetPlayer1Score()
	$Player1Score = GUICtrlRead($Player1ScoreControlID)
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	MemoryWrite($Handle, "0x007AB31A", $Player1Score)
	If @error Then Exit

	MemoryClose($Handle)
	If @error Then Exit
EndFunc



Func SetPlayer2Score()
	$Player2Score = GUICtrlRead($Player2ScoreControlID)
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	MemoryWrite($Handle, "0x007AB336", $Player2Score)
	If @error Then Exit

	MemoryClose($Handle)
	If @error Then Exit
EndFunc



Func SetPlayer3Score()
	$Player3Score = GUICtrlRead($Player3ScoreControlID)
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	MemoryWrite($Handle, "0x007AB352", $Player3Score)
	If @error Then Exit

	MemoryClose($Handle)
	If @error Then Exit
EndFunc



Func SetPlayer4Score()
	$Player4Score = GUICtrlRead($Player4ScoreControlID)
	$Handle = MemoryOpen($Process)
	If @error Then Exit

	MemoryWrite($Handle, "0x007AB36E", $Player4Score)
	If @error Then Exit

	MemoryClose($Handle)
	If @error Then Exit
EndFunc



Func MemoryOpen($ProcessID, $DesiredAccess = 0x1F0FFF, $InheritHandle = 1)
	If Not ProcessExists($ProcessID) Then
		SetError(1)
		Return 0
	EndIf

	Local $Handle[2] = [DllOpen('kernel32.dll')]

	If @Error Then
		SetError(2)
		Return 0
	EndIf

	Local $OpenProcess = DllCall($Handle[0], 'int', 'OpenProcess', 'int', $DesiredAccess, 'int', $InheritHandle, 'int', $ProcessID)

	If @Error Then
		DllClose($Handle[0])
		SetError(3)
		Return 0
	EndIf

	$Handle[1] = $OpenProcess[0]

	Return $Handle
EndFunc



Func MemoryRead($Handle, $Address, $Type = 'dword')
	If Not IsArray($Handle) Then
		SetError(1)
		Return 0
	EndIf

	Local $Buffer = DllStructCreate($Type)

	If @Error Then
		SetError(@Error + 1)
		Return 0
	EndIf

	DllCall($Handle[0], 'int', 'ReadProcessMemory', 'int', $Handle[1], 'int', $Address, 'ptr', DllStructGetPtr($Buffer), 'int', DllStructGetSize($Buffer), 'int', '')

	If Not @Error Then
		Local $Value = DllStructGetData($Buffer, 1)
		Return $Value
	Else
		SetError(6)
		Return 0
	EndIf
EndFunc



Func MemoryWrite($Handle, $Address, $Data, $Type = 'dword')
	If Not IsArray($Handle) Then
		SetError(1)
		Return 0
	EndIf

	Local $Buffer = DllStructCreate($Type)

	If @Error Then
		SetError(@Error + 1)
		Return 0
	Else
		DllStructSetData($Buffer, 1, $Data)
		If @Error Then
			SetError(6)
			Return 0
		EndIf
	EndIf

	DllCall($Handle[0], 'int', 'WriteProcessMemory', 'int', $Handle[1], 'int', $Address, 'ptr', DllStructGetPtr($Buffer), 'int', DllStructGetSize($Buffer), 'int', '')

	If Not @Error Then
		Return 1
	Else
		SetError(7)
		Return 0
	EndIf
EndFunc



Func MemoryClose($Handle)
	If Not IsArray($Handle) Then
		SetError(1)
		Return 0
	EndIf

	DllCall($Handle[0], 'int', 'CloseHandle', 'int', $Handle[1])

	If Not @Error Then
		DllClose($Handle[0])
		Return 1
	Else
		DllClose($Handle[0])
		SetError(2)
		Return 0
	EndIf
EndFunc
