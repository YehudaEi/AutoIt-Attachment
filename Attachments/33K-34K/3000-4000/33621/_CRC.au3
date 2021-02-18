; ------------------------------------------------------------------
; CRC Checksum UDF
; Purpose: Provide Fast CRC32/CRC16 Algorithm In AutoIt
; Author:  Ward
; ------------------------------------------------------------------

#Include <Memory.au3>

Func _CRC32($Data, $Initial = -1, $Polynomial = 0xEDB88320)
	If @AutoItX64 Then
		Local $Opcode = '0x554889E54881EC2004000048894D10488955184489452044894D28C745F800000000EB468B45F88945ECC745FC08000000EB1E8B45EC83E00184C0740D8B45ECD1E83345288945ECEB03D16DEC836DFC01837DFC007FDC8B45F848988B55EC899485E0FBFFFF8345F801817DF8FF0000007EB1488B4510488945F0C745F800000000EB318B452089C2C1EA088B45F84898480345F00FB6000FB6C033452025FF00000089C08B8485E0FBFFFF31D08945208345F8018B45F84898483B451872C48B4520F7D0C9C3'
	Else
		Local $Opcode = '0xC8000400538B5514B9000100008D41FF516A0859D1E8730231D0E2F85989848DFCFBFFFFE2E78B5D088B4D0C8B451085DB7416E3148A1330C20FB6D2C1E80833849500FCFFFF43E2ECF7D05BC9C21000'
	EndIf
	
	Local $CodeBufferMemory = _MemVirtualAlloc(0, BinaryLen($Opcode), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $CodeBufferMemory)
	DllStructSetData($CodeBuffer, 1, $Opcode)

	Local $Input = DllStructCreate("byte[" & BinaryLen($Data) & "]")
	DllStructSetData($Input, 1, $Data)

	Local $Ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"ptr", DllStructGetPtr($Input), _
													"int", BinaryLen($Data), _
													"uint", $Initial, _
													"int", $Polynomial)

	$Input = 0
	$CodeBuffer = 0
	_MemVirtualFree($CodeBufferMemory, 0, $MEM_RELEASE)

	Return $Ret[0]
EndFunc

Func _CRC16($Data, $Initial = 0, $Polynomial = 0xA001)
	If @AutoItX64 Then
		Local $Opcode = '0x554889E54881EC2002000048894D10488955184489C24489C86689552066894528C745F800000000EB4F8B45F8668945EEC745FC08000000EB240FB745EE83E00184C074110FB745EE66D1E866334528668945EEEB0466D16DEE836DFC01837DFC007FD68B45F848980FB755EE66899445E0FDFFFF8345F801817DF8FF0000007EA8488B4510488945F0C745F800000000EB380FB7452089C166C1E9080FB755208B45F84898480345F00FB6000FB6C031D025FF00000048980FB78445E0FDFFFF31C8668945208345F8018B45F84898483B451872BD0FB74520C9C3'
	Else
		Local $Opcode = '0xC800020053668B5514B9000100006689C86648516A085966D1E873036631D0E2F6596689844DFEFDFFFFE2E28B5D088B4D0C668B451085DB7418E3168A1330C20FB6D266C1E8086633845500FEFFFF43E2EA5BC9C21000'
	EndIf

	Local $CodeBufferMemory = _MemVirtualAlloc(0, BinaryLen($Opcode), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $CodeBufferMemory)
	DllStructSetData($CodeBuffer, 1, $Opcode)

	Local $Input = DllStructCreate("byte[" & BinaryLen($Data) & "]")
	DllStructSetData($Input, 1, $Data)

	Local $Ret = DllCall("user32.dll", "word", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"ptr", DllStructGetPtr($Input), _
													"int", BinaryLen($Data), _
													"word", $Initial, _
													"word", $Polynomial)

	$Input = 0
	$CodeBuffer = 0
	_MemVirtualFree($CodeBufferMemory, 0, $MEM_RELEASE)

	Return $Ret[0]
EndFunc
