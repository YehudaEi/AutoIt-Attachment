#include "Nomadmemory.au3"
;===============================================================================
; Function Name:    _Freeze_Value()
; Description:          Freezes a Value just like Cheat Engine
; Syntax:
; Parameter(s):     $Address - Address you want to freesze

;					$ID
;			        An array containing the Dll handle and the handle
;					of the open process as returned by _MemoryOpen()

;                   $Value - Value you want to freeze it at

;					$sv_Type - (optional) The "Type" of value you intend to read.
;					This is set to 'dword'(32bit(4byte) signed integer)
;					by default.  See the help file for DllStructCreate
;					for all types.  An example: If you want to read a
;					word that is 15 characters in length, you would use
;					'char[16]' since a 'char' is 8 bits (1 byte) in size.

;					Your main While 1 loop in the Script duplicated, put into a function 
; Requirement(s):   Need #Nomadmemory, Need 2 Main while 1 one reg while one, the other func() EX.
;
;
;while 1 ---------> Main while in script
;		$nMsg = GUIGetMsg()
;	Switch $nMsg
;	Case $GUI_EVENT_CLOSE
;		SoundPlay (@HomeDrive& "\Windows\System\t1alarm.wav")	
;			Exit
;Endswitch
;WEnd
;
;Func While -------->While 1 loop duplicated, into a function (this is the one that  = $mainloop, without the ()),  (you must have Both)
;		$nMsg = GUIGetMsg()
;	Switch $nMsg
;	Case $GUI_EVENT_CLOSE
;			Exit
;EndSwitch
;EndFunc

; Return Value(s):  Success = Freezes Value
; Author(s):   Liiten \ tri407tiny
; Modification(s):
;===============================================================================
Func _Freeze_Value($ID, $Address, $value, $mainloop)
	SetPrivilege("SeDebugPrivilege", 1)
	$M1 = _Memoryread($Address)
	if $M1 <> $Value then 
		while 1
		_memorywrite($ID, $address, $Value)
		$mainloop ()
		WEnd
	EndIf
EndFunc





;ExZample
;#Include "Freeze.au3"
;Func FreezeRunSpeed()
;$Loop = Loop()
;$ID = _MemoryOpen(ProcessExists("Game.exe"))
;$Runspeed  = 0x000000
;_Freeze_Value( $ID, $Runspeed, 2000, $Loop)
;EndIf


;While 1
;$nMsg = GUIGetMsg()
;Switch $nMsg
;Case $GUI_EVENT_CLOSE
;Exit
;EndSwitch
;WEnd

;func Loop()
;$nMsg = GUIGetMsg()
;Switch $nMsg
;Case $GUI_EVENT_CLOSE
;Exit
;EndSwitch
;EndFunc

