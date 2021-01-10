; NOTE From Yuri!!!!
; The functions in here that contain the '_' prefix(ie... everything written by Nomad)
; DO NOT work with reading memory in World of Warcraft. I only included it for the sake
; of showing the usefulness of Nomad's UDF.(and cause i wrote some funcs @ the bottom a
; while back and figured i'd leave them in here)

#include-once
#include <String.au3> ; for _StringReverse()
#region _Memory
;==================================================================================
; AutoIt Version:	3.1.127 (beta)
; Language:			English
; Platform:			All Windows
; Author:			Nomad
; Requirements:		These functions will only work with beta.
;==================================================================================
; Credits:	wOuter - These functions are based on his original _Mem() functions.
;			But they are easier to comprehend and more reliable.  These
;			functions are in no way a direct copy of his functions.  His
;			functions only provided a foundation from which these evolved.

;	**->	- Added @ EOF(scroll down) by Yuri: 
;				- Hexadecimal to Decimal functions(and vice versa) - ie 64bit int support
;				- and some functions to help with making trainers in AutoIt3 using this NomadMemory UDF
;==================================================================================
;
; Functions:
;
;==================================================================================
; Function:			_MemoryOpen($iv_Pid[, $iv_DesiredAccess[, $iv_InheritHandle]])
; Description:		Opens a process and enables all possible access rights to the
;					process.  The Process ID of the process is used to specify which
;					process to open.  You must call this function before calling
;					_MemoryClose(), _MemoryRead(), or _MemoryWrite().
; Parameter(s):		$iv_Pid - The Process ID of the program you want to open.
;					$iv_DesiredAccess - (optional) Set to 0x1F0FFF by default, which
;										enables all possible access rights to the
;										process specified by the Process ID.
;					$iv_InheritHandle - (optional) If this value is TRUE, all processes
;										created by this process will inherit the access
;										handle.  Set to 1 (TRUE) by default.  Set to 0
;										if you want it FALSE.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing the Dll handle and an
;								 open handle to the specified process.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $iv_Pid.
;							 2 = Failed to open Kernel32.dll.
;							 3 = Failed to open the specified process.
; Author(s):		Nomad
; Note(s):
;==================================================================================
Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $iv_InheritHandle = 1)
	
	If Not ProcessExists($iv_Pid) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $ah_Handle[2] = [DllOpen('kernel32.dll')]
	
	If @Error Then
        SetError(2)
        Return 0
    EndIf
	
	Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $iv_InheritHandle, 'int', $iv_Pid)
	
	If @Error Then
        DllClose($ah_Handle[0])
        SetError(3)
        Return 0
    EndIf
	
	$ah_Handle[1] = $av_OpenProcess[0]
	
	Return $ah_Handle
	
EndFunc

;==================================================================================
; Function:			_MemoryRead($iv_Address, $ah_Handle[, $sv_Type])
; Description:		Reads the value located in the memory address specified.
; Parameter(s):		$iv_Address - The memory address you want to read from. It must
;								  be in hex format (0x00000000).
;					$ah_Handle - An array containing the Dll handle and the handle
;								 of the open process as returned by _MemoryOpen().
;					$sv_Type - (optional) The "Type" of value you intend to read.
;								This is set to 'dword'(32bit(4byte) signed integer)
;								by default.  See the help file for DllStructCreate
;								for all types.  An example: If you want to read a
;								word that is 15 characters in length, you would use
;								'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):	On Success - Returns the value located at the specified address.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $ah_Handle.
;							 2 = $sv_Type was not a string.
;							 3 = $sv_Type is an unknown data type.
;							 4 = Failed to allocate the memory needed for the DllStructure.
;							 5 = Error allocating memory for $sv_Type.
;							 6 = Failed to read from the specified process.
; Author(s):		Nomad
; Note(s):			Values returned are in Decimal format, unless specified as a
;					'char' type, then they are returned in ASCII format.  Also note
;					that size ('char[size]') for all 'char' types should be 1
;					greater than the actual size.
;==================================================================================
Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $v_Buffer = DllStructCreate($sv_Type)
	
	If @Error Then
		SetError(@Error + 1)
		Return 0
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
	
	If Not @Error Then
		Local $v_Value = DllStructGetData($v_Buffer, 1)
		Return $v_Value
	Else
		SetError(6)
        Return 0
	EndIf
	
EndFunc

;==================================================================================
; Function:			_MemoryWrite($iv_Address, $ah_Handle, $v_Data[, $sv_Type])
; Description:		Writes data to the specified memory address.
; Parameter(s):		$iv_Address - The memory address which you want to write to.
;								  It must be in hex format (0x00000000).
;					$ah_Handle - An array containing the Dll handle and the handle
;								 of the open process as returned by _MemoryOpen().
;					$v_Data - The data to be written.
;					$sv_Type - (optional) The "Type" of value you intend to write.
;								This is set to 'dword'(32bit(4byte) signed integer)
;								by default.  See the help file for DllStructCreate
;								for all types.  An example: If you want to write a
;								word that is 15 characters in length, you would use
;								'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):	On Success - Returns 1
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $ah_Handle.
;							 2 = $sv_Type was not a string.
;							 3 = $sv_Type is an unknown data type.
;							 4 = Failed to allocate the memory needed for the DllStructure.
;							 5 = Error allocating memory for $sv_Type.
;							 6 = $v_Data is not in the proper format to be used with the
;								 "Type" selected for $sv_Type, or it is out of range.
;							 7 = Failed to write to the specified process.
; Author(s):		Nomad
; Note(s):			Values sent must be in Decimal format, unless specified as a
;					'char' type, then they must be in ASCII format.  Also note
;					that size ('char[size]') for all 'char' types should be 1
;					greater than the actual size.
;==================================================================================
Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $v_Buffer = DllStructCreate($sv_Type)
	
	If @Error Then
		SetError(@Error + 1)
		Return 0
	Else
		DllStructSetData($v_Buffer, 1, $v_Data)
		If @Error Then
			SetError(6)
			Return 0
		EndIf
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
	
	If Not @Error Then
		Return 1
	Else
		SetError(7)
        Return 0
	EndIf
	
EndFunc

;==================================================================================
; Function:			_MemoryClose($ah_Handle)
; Description:		Closes the process handle opened by using _MemoryOpen().
; Parameter(s):		$ah_Handle - An array containing the Dll handle and the handle
;								 of the open process as returned by _MemoryOpen().
; Return Value(s):	On Success - Returns 1
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $ah_Handle.
;							 2 = Unable to close the process handle.
; Author(s):		Nomad
; Note(s):
;==================================================================================
Func _MemoryClose($ah_Handle)
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
	If Not @Error Then
		DllClose($ah_Handle[0])
		Return 1
	Else
		DllClose($ah_Handle[0])
		SetError(2)
        Return 0
	EndIf
	
EndFunc

;==================================================================================
; Function:			SetPrivilege( $privilege, $bEnable )
; Description:		Enables (or disables) the $privilege on the current process
;                   (Probably) requires administrator privileges to run
;
; Author(s):		Larry (from autoitscript.com's Forum)
; Notes(s):
; http://www.autoitscript.com/forum/index.php?s=&showtopic=31248&view=findpost&p=223999
;==================================================================================

;Func SetPrivilege( $privilege, $bEnable )
;    Const $TOKEN_ADJUST_PRIVILEGES = 0x0020
;    Const $TOKEN_QUERY = 0x0008
;    Const $SE_PRIVILEGE_ENABLED = 0x0002
;    Local $hToken, $SP_auxret, $SP_ret, $hCurrProcess, $nTokens, $nTokenIndex, $priv
;    $nTokens = 1
;    $LUID = DLLStructCreate("dword;int")
;    If IsArray($privilege) Then    $nTokens = UBound($privilege)
;    $TOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
;    $NEWTOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
;    $hCurrProcess = DLLCall("kernel32.dll","hwnd","GetCurrentProcess")
;    $SP_auxret = DLLCall("advapi32.dll","int","OpenProcessToken","hwnd",$hCurrProcess[0],   _
;            "int",BitOR($TOKEN_ADJUST_PRIVILEGES,$TOKEN_QUERY),"int_ptr",0)
;    If $SP_auxret[0] Then
;        $hToken = $SP_auxret[3]
;        DLLStructSetData($TOKEN_PRIVILEGES,1,1)
;        $nTokenIndex = 1
;        While $nTokenIndex <= $nTokens
;            If IsArray($privilege) Then
;                $priv = $privilege[$nTokenIndex-1]
;            Else
;                $priv = $privilege
;            EndIf
;            $ret = DLLCall("advapi32.dll","int","LookupPrivilegeValue","str","","str",$priv,   _
;                    "ptr",DLLStructGetPtr($LUID))
;            If $ret[0] Then
;                If $bEnable Then
;                    DLLStructSetData($TOKEN_PRIVILEGES,2,$SE_PRIVILEGE_ENABLED,(3 * $nTokenIndex))
;                Else
;                    DLLStructSetData($TOKEN_PRIVILEGES,2,0,(3 * $nTokenIndex))
;                EndIf
;                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,1),(3 * ($nTokenIndex-1)) + 1)
;                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,2),(3 * ($nTokenIndex-1)) + 2)
;                DLLStructSetData($LUID,1,0)
;                DLLStructSetData($LUID,2,0)
;            EndIf
;            $nTokenIndex += 1
;        WEnd
;        $ret = DLLCall("advapi32.dll","int","AdjustTokenPrivileges","hwnd",$hToken,"int",0,   _
;                "ptr",DllStructGetPtr($TOKEN_PRIVILEGES),"int",DllStructGetSize($NEWTOKEN_PRIVILEGES),   _
;                "ptr",DllStructGetPtr($NEWTOKEN_PRIVILEGES),"int_ptr",0)
;        $f = DLLCall("kernel32.dll","int","GetLastError")
;    EndIf
;    $NEWTOKEN_PRIVILEGES=0
;    $TOKEN_PRIVILEGES=0
;    $LUID=0
;    If $SP_auxret[0] = 0 Then Return 0
;    $SP_auxret = DLLCall("kernel32.dll","int","CloseHandle","hwnd",$hToken)
;    If Not $ret[0] And Not $SP_auxret[0] Then Return 0
;    return $ret[0]
;EndFunc   ;==>SetPrivilege
#endregion

; Added 'short-hand' functions, by Yuri, below here. 
; _____Summary of items_____
; NM_HexToDecimal($hex): // DEPRICATED! use 'Dec'
;	- Converts $hex to decimal
;	- Returns: decimal(integer data-type) equivelant of $hex
; NM_DecimalToHex($dec): // DEPRICATED! use 'Hex'
;	- Converts $dec to Hexadecimal
;	- Returns: Hexadecimal(string data-type) equivelant of $dec
; NM_HexOp($hex1,$op,$hex2,$revert): 
;	- Performs mathematical operation($op: must be string, ie. "+"... etc.) of two addresses($hex and $hex2: must be in hex format)
;	- Returns: if $revert set to 1: will return hex, default(0/blank param) will return decimal
; NM_find_offset($hex1,$hex2,$revert):
;	- Returns: offset(in string data-type(Default), or if $revert=1: hexadecimal format) between two addresses($hex1 and $hex2)
; NM_read_pointer($process,$pointer,$op,$offset):
;	- Reads pointer($pointer), then applies offset($offset) based on supplied operator("+"||"-"), and..
;	- Returns: value @ found Hex Address
;		- This is used for DMA(Dynamic-Memory-Allocation) in games. This merely allows quick access to data in a...
;		- 'short-hand' fashion, so you don't have to type alot.
;		- If you don't understand DMA, then this function is of no use to you(read more). Otherwise, you should see its use immediately :)
;		- For those that dont, read this: (Quick DMA how-to)
;			- Ever come to this conclusion?: "what do i do if im making a trainer and every time i load the game the memory address
;			- of the value i want to peek and poke changes?" Well that's what pointers do in the game(aka DMA)...
;			- 1.) Find address of value you want to modify
;			- 2.) Find pointer address, which points to the address found in step1(Simply put: run a search for the hex address of part1)
;			- 3.) Now you need to filter your results until there is only one pointer that points to this address.(restart game and do step 1-2, and filter your results by these results)
;			- 4.) Now that you have your pointer, you need the offset. This is done using basic math, or the NM_find_offset() func i gave you.
;				- Offsets are found by recording pointer's value(a memory address::"$pointer_value") and doing step1($actual_address), then running NM_find_offset($pointer_value,$actual_address)
;				- Do it once, restart, do it again to make sure you got right offset.
;			- 5.) Boom you conquered DMA. You have the pointer location(static) and the offset to find the address in memory.
;			- Send these two to this function, and it will give you the value at the address to which you wanted to modify in step1.
;			- Note, to modify it, just run NM_write($process,NM_read_pointer($process,$pointer,"+",$offset),$value))
;			- If this doesn't make sense, just run through it a few times, you'll catch on. If all else fails, just take a ANSI-C course. Take some ASM too while ur at it.
; NM_write($process,$hex_address,$value)
;	- Write's $value to $hex_address in $process' memory location.
;	- Returns: 1 if NO-error, if an error occurs: 0 - use @ERROR to diagnose
; NM_read($process,$address,$type_of_data)
;   - Read value @ specified address with specified data size(important... see below)
;   - $type_of_data MUST BE CORRECT, or you will get '0' or cut-off-data as a result
;   - Allowed types:
;		byte 8bit(1byte) signed char 
;		ubyte 8bit(1byte) unsigned char 
;		char 8bit(1byte) ASCII char 
;		wchar 16bit(2byte) Wide char 
;		short 16bit(2bytes) signed integer 
;		ushort 16bit(2bytes) unsigned integer 
;		int 32bit(4bytes) signed integer 
;		long 32bit(4bytes) signed integer 
;		uint 32bit(4bytes) unsigned integer 
;		dword 32bit(4bytes) signed integer 
;		udword 32bit(4bytes) unsigned integer 
;		ptr 32bit(4bytes) integer 
;		hwnd 32bit(4bytes) integer 
;		float 32bit(4bytes) floating point 
;		double 64bit(8bytes) floating point 
;		int64 64bit(8bytes) signed integer 
;		uint64 64bit(8bytes) unsigned integer 
;
;

Func NM_HexToDecimal($hex)
	$hex=_StringReverse($hex) ; Dont have to reverse it, but easier to go from 1->x than x->1
	$_hex=StringSplit($hex,"") ; Split hex string sent in, into an array
	$s_len=$_hex[0] ; first val of array contains # of elements
	$dec=0 ; decimal return value initialized to zero
	$cur_num=0 ; current number initialized to zero
	$base=16 ; base(ie. exp) for calculation
	
	for $i=1 To $s_len Step +1 ; For every value in the _hex array
		if (_NM_isValid($_hex[$i])) Then ; If it contains A,B,C,D,E, or F
			$_hex[$i]=_NM_handleChar($_hex[$i]) ; Assign letter->number corresponding value
			if ($_hex[$i]==-1) Then
				$dec=$_hex[$i]
				ExitLoop
			EndIf
		EndIf
		$cur_num=Number($_hex[$i]) ; Current number = (int)_hex[i] // type cast
		$dec+=($cur_num*($base^($i-1))) ; total+=(Current Number) x (16^(n++)):: equation to calc hex addy
	Next 
		return $dec
EndFunc
Func NM_DecimalToHex($dec) ;could've written this recursively(as with HexToDecimal but this works fine, and is easier to read. so dont flame me, i know it's .01 milliseconds less efficient you nerdy nerds.
	$base=16 ; base
	$rem=0 ; remainder
	$count=1 ; logs position in the 8 character hex result(ie. '12345678')
	$num=$dec ; yea...
	$combine="" ; combined string to return init.
	do 
		$rem=Mod($num,$base) ; remainder
		$num=Int($num/$base) ; Integer division, cant have float output(in case u give a wierd base val)
		if ($rem>=10) Then ; if num needs to be converted to Hexidecimal char value
			$combine&=_NM_handleNum($rem) ; convert it
		Else 
			$combine&=$rem ; append value
		EndIf
		$count+=1 ; increase position
	Until ($num=0) ; go till no longer needed
	for $i=(8-($count-1)) To 1 Step -1 ; fill zeros where needed
		$combine&="0"
	Next
		$combine=_StringReverse($combine) ; reverse it
	return $combine
EndFunc
Func NM_HexOp($hex1,$op,$hex2,$revert=0)
	$res_val=-1
	Select
		Case $op="-"
			$res_val=(NM_HexToDecimal($hex1))-(NM_HexToDecimal($hex2))
		Case $op="+"
			$res_val=(NM_HexToDecimal($hex1))+(NM_HexToDecimal($hex2))
		Case $op="*"
			$res_val=(NM_HexToDecimal($hex1))*(NM_HexToDecimal($hex2))
		Case $op="/"
			$res_val=(NM_HexToDecimal($hex1))/(NM_HexToDecimal($hex2))
		Case $op="^"
			$res_val=(NM_HexToDecimal($hex1))^(NM_HexToDecimal($hex2)) ; not sure why anyone would want this, but w/e
	EndSelect
	if ($revert==1) Then
		return NM_DecimalToHex($res_val)
	EndIf
	return $res_val
EndFunc
Func NM_read_pointer($r_PID,$pointer,$op,$offset,$size="char[16]")
	$r_PID=_NM_Open($r_PID)
	$addy=NM_DecimalToHex(_MemoryRead("0x"&$pointer,$r_PID))
	$res_hex=NM_HexOp("0x"&$addy,$op,"0x"&$offset,1)
	$res_val=_MemoryRead("0x"&$res_hex,$r_PID,$size)
	_NM_Close($r_PID)
	return $res_val
EndFunc
Func NM_write($r_PID,$hex,$val,$size="char[16]")
	$r_PID=_NM_Open($r_PID)
	$res_val=_MemoryWrite("0x"&$hex,$r_PID,$val,$size)
	_NM_Close($r_PID)
	return $res_val
EndFunc

Func NM_read_address($r_PID,$addy)
	$r_PID=_NM_Open($r_PID)
	$res_val=NM_DecimalToHex(_MemoryRead("0x"&$addy,$r_PID))
	_NM_Close($r_PID)
	return $res_val
EndFunc
Func NM_read($r_PID,$addy,$size="dword")
	$r_PID=_NM_Open($r_PID)
	$res_val=_MemoryRead("0x"&$addy,$r_PID,$size)
	if ($res_val==0 AND NOT(@ERROR==0)) Then
		MsgBox(0,"Error","Error Reading Target Address("&$addy&")"&@CRLF&"Error Report: "&@ERROR)
	EndIf
	_NM_Close($r_PID)
	return $res_val
EndFunc
Func NM_find_offset($hex1,$hex2,$revert=1)
	$offset=abs(NM_HexOp("0x"&$hex1,"-","0x"&$hex2,0))
	$ret_val=$offset
	if ($revert==1) Then
		$ret_val=NM_DecimalToHex($ret_val)
	EndIf
	return $ret_val
EndFunc

; Functions for functionality of above functions
Func _NM_handleChar($iv_char) ; Hex->Decimal Letter->Number conversion
	$v_int=-1 ; default return-val in case of error
	Select
		Case $iv_char="A"
			$v_int=10
		Case $iv_char="B"
			$v_int=11
		Case $iv_char="C"
			$v_int=12
		Case $iv_char="D"
			$v_int=13
		Case $iv_char="E"
			$v_int=14
		Case $iv_char="F"
			$v_int=15
	EndSelect
	return $v_int
EndFunc
Func _NM_handleNum($iv_int) ; Decimal->Hex Number->Letter conversion
	$v_char="No"; default return-val in case of error
	Select
		Case $iv_int=10
			$v_char="A"
		Case $iv_int=11
			$v_char="B"
		Case $iv_int=12
			$v_char="C"
		Case $iv_int=13
			$v_char="D"
		Case $iv_int=14
			$v_char="E"
		Case $iv_int=15
			$v_char="F"
	EndSelect
	return $v_char
EndFunc
Func _NM_isValid($_c)
	if ($_c=="A" OR $_c=="B" OR $_c=="C" OR $_c=="D" OR $_c=="E" OR $_c=="F") Then
		return true
	Else
		return false
	EndIf
EndFunc
Func _NM_Open($_p)
	$res=_MemoryOpen(ProcessExists($_p))
	if $res==0 Then
		MsgBox(0,"Error","Error Opening Target Process("&$_p&")"&@CRLF&"Error Report: "&@ERROR)
	EndIf
	return $res
EndFunc
Func _NM_Close($_PID)
	_MemoryClose($_PID)
EndFunc

