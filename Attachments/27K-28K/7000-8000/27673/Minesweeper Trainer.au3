#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>

$GodModeAddress = 0x01005000
$NoMinesAddress = 0x010057A4
$OneMineAddress = 0x010056A4
$TimeAddress = 0x0100579C
$SmilyAddress = 0x01005160

If FileGetVersion(@SystemDir&"\winmine.exe") = '5.1.2600.0' = False Then
	MsgBox(16,"Error","Minesweeper version isn't supported")
	Exit
EndIf

If ProcessExists("winmine.exe") = 0 Then
	$WaitingForm = GUICreate("Did not detect Minesweeper!", 170, 38, -1, -1, $WS_CLIPSIBLINGS, $WS_EX_TOOLWINDOW)
	GUICtrlCreateLabel("Waiting for 'winmine.exe'",20,0)
	$WaitLabel = GUICtrlCreateLabel(".",137,0)
	GUISetState(@SW_SHOW,$WaitingForm)
	While $WaitingForm
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		GUICtrlSetData($WaitLabel,"..")
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		GUICtrlSetData($WaitLabel,"...")
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		If ProcessExists("winmine.exe") = Not 0 Then ExitLoop
		Sleep(125)
		GUICtrlSetData($WaitLabel,".")
	WEnd
	GUIDelete($WaitingForm)
EndIf
$MemOpen = _MemoryOpen(ProcessExists("winmine.exe"))
MsgBox(0,0,$MemOpen[0])
$MinesweeperForm = GUICreate("Minesweeper Trainer", 145, 117, -1, 300, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$CGodMode = GUICtrlCreateCheckbox("", 128, 4, 14, 14)
$CNoMines = GUICtrlCreateCheckbox("", 128, 28, 14, 14)
$COneMine = GUICtrlCreateCheckbox("", 128, 52, 14, 14)
$CTime = GUICtrlCreateCheckbox("", 128, 76, 14, 14)
$CSmily = GUICtrlCreateCheckbox("", 128, 100, 14, 14)
$IGodMode = GUICtrlCreateInput("God Mode", 0, 0, 121, 21, BitOR($ES_CENTER,$ES_READONLY))
$INoMines = GUICtrlCreateInput("No Mines", 0, 24, 121, 21, BitOR($ES_CENTER,$ES_READONLY))
$IOneMine = GUICtrlCreateInput("One Mine", 0, 48, 121, 21, BitOR($ES_CENTER,$ES_READONLY))
$ITime = GUICtrlCreateInput("", 0, 72, 121, 21,BitOR($ES_CENTER,$ES_NUMBER))
$ISmily = GUICtrlCreateInput("", 0, 96, 121, 21,BitOR($ES_CENTER,$ES_NUMBER))
GUICtrlSetTip($ITime,"Time")
GUICtrlSetTip($ISmily,"Smily")
;BlackMode
GUISetBkColor(0x000000,$MinesweeperForm)
GUICtrlSetBkColor($IGodMode,0x3F3F3F)
GUICtrlSetBkColor($INoMines,0x3F3F3F)
GUICtrlSetBkColor($IOneMine,0x3F3F3F)
GUICtrlSetBkColor($ITime,0x000000)
GUICtrlSetBkColor($ISmily,0x000000)
GUICtrlSetColor($IGodMode,0xFFFFFF)
GUICtrlSetColor($INoMines,0xFFFFFF)
GUICtrlSetColor($IOneMine,0xFFFFFF)
GUICtrlSetColor($ITime,0xFFFFFF)
GUICtrlSetColor($ISmily,0xFFFFFF)
;/BlackMode
GUISetState(@SW_SHOW,$MinesweeperForm)
While 1
	If ProcessExists("winmine.exe") = 0 Then _Close()
	If GUICtrlRead($CGodMode) = 1 Then
		If _MemoryRead($GodModeAddress,$MemOpen) = 1 = False Then _MemoryWrite($GodModeAddress,$MemOpen,1)
	EndIf
	If GUICtrlRead($CNoMines) = 1 Then
		If _MemoryRead($NoMinesAddress,$MemOpen) = 0 = False Then _MemoryWrite($NoMinesAddress,$MemOpen,0)
	EndIf
	If GUICtrlRead($COneMine) = 1 Then
		If _MemoryRead($OneMineAddress,$MemOpen) = 1 = False Then _MemoryWrite($OneMineAddress,$MemOpen,1)
	EndIf
	If GUICtrlRead($CTime) = 1 Then
		If _MemoryRead($TimeAddress,$MemOpen) = GUICtrlRead($ITime)-1 = False Then _MemoryWrite($TimeAddress,$MemOpen,GUICtrlRead($ITime)-1)
	EndIf
	If GUICtrlRead($CSmily) = 1 Then
		If _MemoryRead($SmilyAddress,$MemOpen) = GUICtrlRead($ISmily) = False Then _MemoryWrite($SmilyAddress,$MemOpen,GUICtrlRead($ISmily))
	EndIf
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			_Close()
	EndSwitch
WEnd

Func _Close()
	GUIDelete($MinesweeperForm)
	Exit
EndFunc