#include <NomadMemory.au3>
;==================================================================================
; Function:   _PointerRead($hMemory,$StaticOffset[, $type])
; Description:    Reads the value located in the memory address specified.
; Parameter(s): $hMemory - An array containing the Dll handle and the handle
;                         of the open process as returned by _MemoryOpen().
;               $StatifOffset - Static offset of the pointer addresss
;               $sv_Type - (optional) The "Type" of value you intend to read.
;                        This is set to 'dword'(32bit(4byte) signed integer)
;                        by default.  See the help file for DllStructCreate
;                        for all types.  An example: If you want to read a
;                        word that is 15 characters in length, you would use
;                        'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):  On Success - Returns an array which $array[0] = the address, $array[1] = value
;               On Failure - Returns 0
;
; Author(s):       NoN_Stop
; Note(s):      $Offset must be an array with hex offsets (not dec())
;==================================================================================

Func _PointerRead($hMemory, $_StaticOffset, $Offset, $type = 'dword')
	Global $_offset[UBound($Offset, 1)]
	For $i = 0 To UBound($Offset, 1) - 1
		$_offset[$i] = Dec($Offset[$i])
	Next
	$StaticOffset = Dec($_StaticOffset)
	$baseADDR = _MemoryGetBaseAddress($hMemory, 1)
	$FinalADDR = "0x" & Hex($baseADDR + $StaticOffset)
	$read = _MemoryPointerRead($FinalADDR, $hMemory, $_offset, $type)
	If $read <> 0 Then
		Return $read
	Else
		Return 0
	EndIf
EndFunc   ;==>_PointerRead

;==================================================================================
; Function:   _PointerWrite($hMemory,$StaticOffset, $Data[, $type])
; Description:    Reads the value located in the memory address specified.
; Parameter(s): $hMemory - An array containing the Dll handle and the handle
;                         of the open process as returned by _MemoryOpen().
;               $StaticOffset - Static offset of the pointer addresss
;               $Data - The data to be written.
;               $sv_Type - (optional) The "Type" of value you intend to read.
;                        This is set to 'dword'(32bit(4byte) signed integer)
;                        by default.  See the help file for DllStructCreate
;                        for all types.  An example: If you want to read a
;                        word that is 15 characters in length, you would use
;                        'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):  On Success - Returns 1
;               On Failure - Returns 0
;
; Author(s):       NoN_Stop
; Note(s):      $Offset must be an array with hex offsets (not dec())
;               $StaticOffset must be in hex formate
;==================================================================================

Func _PointerWrite($hMemory, $_StaticOffset, $Offset, $Data, $type = 'dword')
	Global $_offset[UBound($Offset, 1)]
	For $i = 0 To UBound($Offset, 1) - 1
		$_offset[$i] = Dec($Offset[$i])
	Next
	$StaticOffset = Dec($_StaticOffset)
	$baseADDR = _MemoryGetBaseAddress($hMemory, 1)
	$FinalADDR = "0x" & Hex($baseADDR + $StaticOffset)
	$write = _MemoryPointerWrite($FinalADDR, $hMemory, $_offset, $Data, $type)
	If $write <> 0 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_PointerWrite