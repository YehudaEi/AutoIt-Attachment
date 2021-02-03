#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include "NomadMemory.au3"
#include <WinAPI.au3>
#include <Memory.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $MemoryOpen, $NOP = 0x90

#Region ### START Koda GUI section ###
$GUI = GUICreate("CE Tutorial Trainer", 237, 173, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIClose")

$Step2 = GUICtrlCreateButton("Complete Step 2", 8, 8, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step2Click")

$Step3 = GUICtrlCreateButton("Complete Step 3", 120, 8, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step3Click")

$Step4 = GUICtrlCreateButton("Complete Step 4", 8, 40, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step4Click")

$Step5 = GUICtrlCreateButton("Complete Step 5", 120, 40, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step5Click")

$Step6 = GUICtrlCreateButton("Complete Step 6", 8, 72, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step6Click")

$Step7 = GUICtrlCreateButton("Complete Step 7", 120, 72, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step7Click")

$Step8 = GUICtrlCreateButton("Complete Step 8", 8, 104, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step8Click")

$Step9 = GUICtrlCreateButton("Complete Step 9", 120, 104, 107, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Step9Click")

$Quit = GUICtrlCreateButton("Quit", 152, 136, 75, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "QuitClick")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

;Find Tutorial.exe and open in memory
Func OpenMemory()
	$PID = ProcessExists("Tutorial.exe")
	$MemoryOpen = _MemoryOpen($PID)
	If $MemoryOpen = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error opening process: " & @CRLF & "Process ID is invalid")
			Case @error = 2
				MsgBox(0, "Error", "Error opening process: " & @CRLF & "Failed to open Kernel32.dll")
			Case @error = 3
				MsgBox(0, "Error", "Error opening the specified process")
		EndSelect
	EndIf
EndFunc

;Complete Step 2
Func Step2Click()
	OpenMemory()
	Local $Offset[2] = ["0", Dec("314")]

	;Get base address
	$BaseAddress = _MemoryGetBaseAddress($MemoryOpen, 1)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	EndIf

	;Calculate and write
	$StaticOffset = Dec("460C54") - $BaseAddress
	$FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
	$Write = _MemoryPointerWrite($FinalAddress, $MemoryOpen, $Offset, "1000")
	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 3
Func Step3Click()
	OpenMemory()
	Local $Offset[2] = ["0", Dec("318")]

	;Get base address
	$BaseAddress = _MemoryGetBaseAddress($MemoryOpen, 1)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	EndIf

	;Calculate and write
	$StaticOffset = Dec("460C4C") - $BaseAddress
	$FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
	$Write = _MemoryPointerWrite($FinalAddress, $MemoryOpen, $Offset, "5000")
	$Read = _MemoryPointerRead($FinalAddress, $MemoryOpen, $Offset)
	ConsoleWrite($Read[0])
	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 4
Func Step4Click()
	OpenMemory()
	Local $Offset[2] = ["0", Dec("328")] ;PART ONE

	;Get base address
	$BaseAddress = _MemoryGetBaseAddress($MemoryOpen, 1)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	EndIf

	;Calculate and write
	$StaticOffset = Dec("460C44") - $BaseAddress
	$FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
	$Write = _MemoryPointerWrite($FinalAddress, $MemoryOpen, $Offset, "5000", "float")

	Local $Offset[2] = ["0", Dec("330")] ;PART TWO

	;Get base address
	$BaseAddress = _MemoryGetBaseAddress($MemoryOpen, 1)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	EndIf

	;Calculate and write
	$StaticOffset = Dec("460C44") - $BaseAddress
	$FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
	$Write = _MemoryPointerWrite($FinalAddress, $MemoryOpen, $Offset, "5000.0", "double")
	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 5
Func Step5Click()
	OpenMemory()

	_MemoryWrite("0x0045AECB", $MemoryOpen, $NOP, "byte")
	_MemoryWrite("0x0045AECC", $MemoryOpen, $NOP, "byte")

	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 6
Func Step6Click()
	OpenMemory()
	Local $Offset[2] = ["0", "0"]

	;Get base address
	$BaseAddress = _MemoryGetBaseAddress($MemoryOpen, 1)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	EndIf

	;Calculate and write
	$StaticOffset = Dec("460C34") - $BaseAddress
	$FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)

	For $Times = 1 To 10
		$Write = _MemoryPointerWrite($FinalAddress, $MemoryOpen, $Offset, "5000")
		Sleep(250)
	Next
	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 7 NOT WORKING. NEED A BYTE TO INSTRUCTION CONVERTER..... THIS MIGHT CRASH THE TUTORIAL
Func Step7Click()
	OpenMemory()
	$Allocate = _MemVirtualAllocEx($MemoryOpen[1], "0x02430000", 2048, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	MsgBox(0, "Allocated", $Allocate)
	_MemoryWrite($Allocate, $MemoryOpen, 0x03108383)
	_MemoryWrite($Allocate+0x00000004, $MemoryOpen, 0x0000, "short")
	_MemoryWrite($Allocate+0x00000006, $MemoryOpen, 0x02, "byte")
	_MemoryWrite($Allocate+0x00000007, $MemoryOpen, 0x11A05DE9)
	_MemoryWrite($Allocate+0x0000000B, $MemoryOpen, 0xFE)

	_MemoryWrite("0x0045A063", $MemoryOpen, 0xEE5F98E9)
	_MemoryWrite("0x0045A067", $MemoryOpen, 0x9001, "short")

	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 8
Func Step8Click()
	OpenMemory()

	_MemoryClose($MemoryOpen)
EndFunc

;Complete Step 9
Func Step9Click()
	OpenMemory()

	_MemoryClose($MemoryOpen)
EndFunc

;Quit
Func QuitClick()
	_MemoryClose($MemoryOpen)
	Exit
EndFunc
Func GUIClose()
	_MemoryClose($MemoryOpen)
	Exit
EndFunc
