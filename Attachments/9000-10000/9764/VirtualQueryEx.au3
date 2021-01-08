;=================================================================================================
; Function:			_VirtualQueryEx($iv_Address, $ah_Handle)
; Description:		Opens a process then reads and returns information for the memory page which
;					contains the memory address specified.
; Parameter(s):		$iv_Address - The memory address you want to read from. It must be in hex
;								  format (0x00000000).
;					$ah_Handle - An array containing the Dll handle and the handle of the open
;								 process as returned by _MemoryOpen().
; Requirement(s):	A valid process ID.
; Return Value(s): 	On Success - Returns an array containing the following:
;								 $Array[0] = Base Address.
;								 $Array[1] = Allocation Base.
;								 $Array[2] = Allocation Protect.
;								 $Array[3] = Region Size.
;								 $Array[4] = State.
;								 $Array[5] = Protect.
;								 $Array[6] = Type.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $ah_Handle.
;							 2 = $sv_Type was not a string.
;							 3 = $sv_Type is an unknown data type.
;							 4 = Failed to allocate the memory needed for the DllStructure.
;							 5 = Error allocating memory for $sv_Type.
;							 6 = Failed to read from the specified process.
; Author(s):		Nomad
; Note(s):
;=================================================================================================
Func _VirtualQueryEx($iv_Address, $ah_Handle)
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $av_Data[7], $i
	Local $v_Buffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	
	If @Error Then
		SetError(@Error + 1)
		Return 0
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'VirtualQueryEx', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer))
	
	If Not @Error Then
		
		For $i = 0 to 6
			
			$av_Data[$i] = Hex(DllStructGetData($v_Buffer, ($i + 1)))
			
		Next
		
		Return $av_Data
		
	Else
		SetError(6)
        Return 0
	EndIf
	
EndFunc