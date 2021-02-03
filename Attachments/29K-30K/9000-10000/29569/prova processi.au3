#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>
#include <WinAPI.au3>
#include <Memory.au3>
#RequireAdmin

Func _ReadMine($pid)
	Global $MineOffset[4]
	$MineOffset[0] = 0
	$MineOffset[1] = Dec("000C")
	$MineOffset[2] = Dec("0024")
	$MineOffset[3] = Dec("0004")
	$StaticOffset = Dec("000868B4")
	$openmem = _MemoryOpen($pid)
	$baseADDR = _MemoryGetBaseAddress($openmem, 1)
	$finalADDR = "0x" & Hex($baseADDR + $StaticOffset)
	$MemPointer = _MemoryPointerRead($finalADDR, $openmem, $MineOffset)
	_MemoryClose($openmem)
	$Fiori = GUICtrlSetData($Fiori,$MemPointer[1])
	Sleep(1000)
EndFunc

Func _ReadTime($pid)
	Global $TimeOffset[4]
	$TimeOffset[0] = 0
	$TimeOffset[1] = Dec("000C")
	$TimeOffset[2] = Dec("0024")
	$TimeOffset[3] = Dec("001C")
	$StaticOffset = Dec("000868B4")
	$openmem = _MemoryOpen($pid)
	$baseADDR = _MemoryGetBaseAddress($openmem, 1)
	$finalADDR = "0x" & Hex($baseADDR + $StaticOffset)
	$MemPointer = _MemoryPointerRead($finalADDR, $openmem, $TimeOffset,'float')
	_MemoryClose($openmem)
	$Tempo = GUICtrlSetData($Tempo,$MemPointer[1])
	Sleep(1000)
EndFunc

Func _ReadMouse($pid)
	Global $MouseOffset[2]
	$MouseOffset[0] = 0
	$MouseOffset[1] = Dec("0094")
	$StaticOffset = Dec("00087454")
	$openmem = _MemoryOpen($pid)
	$baseADDR = _MemoryGetBaseAddress($openmem, 1)
	$finalADDR = "0x" & Hex($baseADDR + $StaticOffset)
	$MemPointer = _MemoryPointerRead($finalADDR, $openmem, $MouseOffset)
	_MemoryClose($openmem)
	$Mouse = GUICtrlSetData($Mouse,$MemPointer[1])
	Sleep(1000)
EndFunc

$list = ProcessList("MineSweeper.exe")
If $list[0][0] = 0 Then
	MsgBox(16,"Errore", "Programma non trovato")
Else
	$PRID = $list[1][1]
	$PRName = $list[1][0]
#Region ### START Koda GUI section ### Form=C:\Users\Nicola\Documents\prato fiorito.kxf
$Form1 = GUICreate("Prato Fiorito Hack by NL4", 673, 52, 244, 458)
$Mouse = GUICtrlCreateInput("", 112, 16, 49, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label1 = GUICtrlCreateLabel("Posizione Mouse:", 16, 16, 87, 17, $SS_RIGHT)
$Label2 = GUICtrlCreateLabel("Fiori:", 192, 16, 26, 17, $SS_RIGHT)
$Fiori = GUICtrlCreateInput("", 224, 16, 49, 21)
$Bloc1 = GUICtrlCreateCheckbox("Blocca", 281, 8, 55, 33)
$Label3 = GUICtrlCreateLabel("Tempo:", 368, 16, 40, 17)
$Tempo = GUICtrlCreateInput("", 408, 16, 49, 21)
$Bloc2 = GUICtrlCreateCheckbox("Blocca", 464, 8, 57, 33)
$Label4 = GUICtrlCreateLabel("Process ID:", 544, 16, 59, 17)
$PID = GUICtrlCreateInput("", 608, 16, 49, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
 	$PID = GUICtrlSetData($PID,$PRID)
	_ReadMine($PRID)
	_ReadTime($PRID)
	_ReadMouse($PRID)
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
			Exit
				EndSwitch
WEnd
EndIf