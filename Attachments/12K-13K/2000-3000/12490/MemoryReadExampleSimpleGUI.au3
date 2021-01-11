#include <Memory.au3>
#include <GUIConstants.au3>

; Globals
Global $ProcessID = WinGetProcess("Minesweeper")
Global $MemoryAddress = 0x0100579C
Global $MemoryType = 'short'

; Create GUI
GUICreate("MemoryReadExample", 200, 100, 0, 0)

; Create Label
$Label1 = GUICtrlCreateLabel("NothingRead", 10, 10, 100, 20)

; GUI MESSAGE LOOP
GuiSetState()

; Loop GUI until closed
Do
	
	$msg = GUIGetMsg()
	
	;open the process
	$ProcessInformation = _MemoryOpen($ProcessID)
	
	;read the memory
	$ReadValue = _MemoryRead($MemoryAddress, $ProcessInformation, $MemoryType)
	
	;close the process
	_MemoryClose($ProcessInformation)
	
	;display the value
	GUICtrlSetData($Label1, "Time: " & $ReadValue)
	
	Sleep(100)
	
Until $msg = $GUI_EVENT_CLOSE

; Exit
Exit