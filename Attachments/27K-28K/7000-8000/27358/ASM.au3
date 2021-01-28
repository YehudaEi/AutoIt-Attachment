#include-once

Func CopyMemory($Destination, $Source, $Length)
	Local $Return
	$Return = DllCall("kernel32.dll", "none", "RtlMoveMemory", "ptr", $Destination, "ptr", $Source, "int", $Length)
	Return $Return[0]
EndFunc   ;==>CopyMemory
Func GetWindowThreadProcessId($hWnd, $lpdwProcessId)
	Local $Return
	$Return = DllCall("user32.dll", "int", "GetWindowThreadProcessId", "int", $hWnd, "int", $lpdwProcessId)
	Return $Return[0]
EndFunc   ;==>GetWindowThreadProcessId
Func CreateRemoteThread($hProcess, $lpThreadAttributes, $dwStackSize, $lpStartAddress, $lpParameter, $dwCreationFlags, $lpThreadId)
	Local $Return
	$Return = DllCall("kernel32.dll", "int", "CreateRemoteThread", "int", $hProcess, "ptr", $lpThreadAttributes, "int", $dwStackSize, "int", $lpStartAddress, "ptr", $lpParameter, "int", $dwCreationFlags, "int", $lpThreadId)
	Return $Return[0]
EndFunc   ;==>CreateRemoteThread

Func WriteProcessMemory($hProcess, $lpBaseAddress, $lpBuffer, $nSize, $lpNumberOfBytesWritten)
	Global $Return
	$Return = DllCall("kernel32.dll", "int", "WriteProcessMemory", "int", $hProcess, "ptr", $lpBaseAddress, "ptr", $lpBuffer, "int", $nSize, "int", $lpNumberOfBytesWritten)
	Return $Return[0]
EndFunc   ;==>WriteProcessMemory

Func CallWindowProc($lpPrevWndFunc, $hWnd, $Msg, $wParam, $lParam)
	Local $Return
	$Return = DllCall("user32.dll", "int", "CallWindowProcA", "int", $lpPrevWndFunc, "int", $hWnd, "int", $Msg, "int", $wParam, "int", $lParam)
	Return $Return[0]
EndFunc   ;==>CallWindowProc

Func VirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualAllocEx", "int", $hProcess, "ptr", $pAddress, "int", $iSize, "int", $iAllocation, "int", $iProtect)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>VirtualAllocEx

Func VirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualFreeEx", "hwnd", $hProcess, "ptr", $pAddress, "int", $iSize, "int", $iFreeType)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>VirtualFreeEx

Func WaitForSingleObject($hHandle, $dwMilliseconds)
	Local $Return
	$Return = DllCall("kernel32.dll", "int", "WaitForSingleObject", "int", $hHandle, "int", $dwMilliseconds)
	Return $Return[0]
EndFunc   ;==>WaitForSingleObject

Func OpenProcess($iAccess, $bInherit, $iProcessID)
	Local $aResult = DllCall("Kernel32.Dll", "int", "OpenProcess", "int", $iAccess, "int", $bInherit, "int", $iProcessID)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>OpenProcess

Func CloseHandle($hObject)
	Local $aResult = DllCall("Kernel32.dll", "int", "CloseHandle", "int", $hObject)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>CloseHandle

;===============================================================================
;~ Private Declare Function GetAddrOf Lib "KERNEL32" Alias "MulDiv" (nNumber As Any, Optional ByVal nNumerator As Long = 1, Optional ByVal nDenominator As Long = 1) As Long
;~    ' This is the dummy function used to get the addres of a VB variable.
Func VarPtr($v_Variable) ;VarPtr
;~     Declare Function VarPtrArray Lib "msvbvm60.dll" Alias "VarPtr" _
;~ (Var() as Any) As Long
	Local $pointer, $debug = True
	$pointer = DllCall("KERNEL32.dll", "long", "MulDiv", "ptr", $v_Variable[0])
	;$pointer =dllcall("msvbvm60.dll","long","VarPtr","long",$v_Variable[0])
	If @error Then
		If $debug Then MsgBox(0, "Error:", "Error:>" & @error & @CRLF)
		Return 0
	Else
		Return $pointer
	EndIf

EndFunc   ;==>VarPtr
;=====================================================================================
;===============================================================================
Const $PAGE_EXECUTE_READWRITE = 0x40
Const $MEM_COMMIT = 0x1000
Const $MEM_RELEASE = 0x8000
Const $MEM_DECOMMIT = 0x4000
Const $PROCESS_ALL_ACCESS = 0x1F0FFF
Const $INFINITE = 0xFFFF ;  Infinite timeout
Const $WAIT_TIMEOUT = 0x102
Dim $AsmCode[100]
Dim $OPcode
Dim $InjectProcess ;??????ID
Dim $tmp_Addr ;??????????
Dim $RThwnd ;?????????
;===============================================================================

Func Get_Result()
	Dim $i
	ReDim $AsmCode[StringLen($OPcode) / 2 - 1]
	For $i = 0 To UBound($AsmCode)
		$AsmCode[$i] = Int("0x" & StringMid($OPcode, $i * 2 + 1, 2))
	Next
	$Get_Result = CallWindowProc(VarPtr($AsmCode[0]), 0, 0, 0, 0)
EndFunc   ;==>Get_Result

Func Get_Code()
	$Get_Code = $OPcode
EndFunc   ;==>Get_Code
;================================
Func Run_ASM2($hWnd)
	Dim $i, $tmp_Addr, $RThwnd, $h, $pid
	ReDim $AsmCode[StringLen($OPcode) / 2 - 1]
	For $i = 0 To UBound($AsmCode)
		$AsmCode[$i] = Int("0x" & StringMid($OPcode, $i * 2 + 1, 2))
	Next
	GetWindowThreadProcessId($hWnd, $pid)
	$h = OpenProcess($PROCESS_ALL_ACCESS, False, $pid)
	$tmp_Addr = VirtualAllocEx($h, 0, UBound($AsmCode) + 1, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	WriteProcessMemory($h, $tmp_Addr, VarPtr($AsmCode[0]), UBound($AsmCode) + 1, 0)
	$RThwnd = CreateRemoteThread($h, 0, 0, $tmp_Addr, 0, 0, 0)
	VirtualFreeEx($h, $tmp_Addr, UBound($AsmCode) + 1, $MEM_RELEASE)
	CloseHandle($RThwnd)
	CloseHandle($h)
	$OPcode = ""
EndFunc   ;==>Run_ASM2
;=================================
Func InjectCode($hWnd)
	Dim $i, $h, $pid
	ReDim $AsmCode[StringLen($OPcode) / 2 - 1]
	For $i = 0 To UBound($AsmCode)
		$AsmCode[$i] = Int("0x" & StringMid($OPcode, $i * 2 + 1, 2))
	Next
	GetWindowThreadProcessId($hWnd, $pid) ;????ID
	$InjectProcess = OpenProcess($PROCESS_ALL_ACCESS, False, $pid) ;???????????
	$tmp_Addr = VirtualAllocEx($InjectProcess, 0, UBound($AsmCode) + 1, _
			$MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ;?????????
	WriteProcessMemory($InjectProcess, $tmp_Addr, VarPtr($AsmCode[0]), _
			UBound($AsmCode) + 1, 0) ;?????????
EndFunc   ;==>InjectCode

Func Run_ASM() ;?????????
	Dim $Ret
	$RThwnd = CreateRemoteThread($InjectProcess, 0, 0, $tmp_Addr, 0, 0, 0)
	Do
		$Ret = WaitForSingleObject($RThwnd, 50) ;??50??
		;DoEvents
	Until $Ret <> $WAIT_TIMEOUT
	CloseHandle($RThwnd)
EndFunc   ;==>Run_ASM

Func FreeMem()
	VirtualFreeEx($InjectProcess, $tmp_Addr, UBound($AsmCode) + 1, $MEM_RELEASE)
	CloseHandle($InjectProcess)
	$OPcode = ""
	$AsmCode = 0
EndFunc   ;==>FreeMem
;========================================================
Func Int2Hex($Value, $n) ;?????
	Dim $tmp1, $tmp2, $i
	$tmp1 = StringRight("0000000" + Hex($Value), $n)
	For $i = 0 To StringLen($tmp1) / 2 - 1
		$tmp2 = $tmp2 + StringMid($tmp1, StringLen($tmp1) - 1 - 2 * $i, 2)
	Next
	$Int2Hex = $tmp2
EndFunc   ;==>Int2Hex

Func Leave()
	$OPcode = $OPcode + "C9"
EndFunc   ;==>Leave

Func Pushad()
	$OPcode = $OPcode + "60"
EndFunc   ;==>Pushad

Func Popad()
	$OPcode = $OPcode + "61"
EndFunc   ;==>Popad

Func Nop()
	$OPcode = $OPcode + "90"
EndFunc   ;==>Nop

Func Ret()
	$OPcode = $OPcode + "C3"
EndFunc   ;==>Ret

Func RetA($i)
	$OPcode = $OPcode + Int2Hex($i, 4)
EndFunc   ;==>RetA

Func IN_AL_DX()
	$OPcode = $OPcode + "EC"
EndFunc   ;==>IN_AL_DX

Func TEST_EAX_EAX()
	$OPcode = $OPcode + "85C0"
EndFunc   ;==>TEST_EAX_EAX

;Add
;+++++++++++++++++++++++++++++++++++
Func Add_EAX_EDX()
	$OPcode = $OPcode + "03C2"
EndFunc   ;==>Add_EAX_EDX

Func Add_EBX_EAX()
	$OPcode = $OPcode + "03D8"
EndFunc   ;==>Add_EBX_EAX

Func Add_EAX_DWORD_Ptr($i)
	$OPcode = $OPcode + "0305" + Int2Hex($i, 8)
EndFunc   ;==>Add_EAX_DWORD_Ptr

Func Add_EBX_DWORD_Ptr($i)
	$OPcode = $OPcode + "031D" + Int2Hex($i, 8)
EndFunc   ;==>Add_EBX_DWORD_Ptr

Func Add_EBP_DWORD_Ptr($i)
	$OPcode = $OPcode + "032D" + Int2Hex($i, 8)
EndFunc   ;==>Add_EBP_DWORD_Ptr

Func Add_EAX($i)
	$OPcode = $OPcode + "05" + Int2Hex($i, 8)
EndFunc   ;==>Add_EAX

Func Add_EBX($i)
	$OPcode = $OPcode + "83C3" + Int2Hex($i, 8)
EndFunc   ;==>Add_EBX

Func Add_ECX($i)
	$OPcode = $OPcode + "83C1" + Int2Hex($i, 8)
EndFunc   ;==>Add_ECX

Func Add_EDX($i)
	$OPcode = $OPcode + "83C2" + Int2Hex($i, 8)
EndFunc   ;==>Add_EDX

Func Add_ESI($i)
	$OPcode = $OPcode + "83C6" + Int2Hex($i, 8)
EndFunc   ;==>Add_ESI

Func Add_ESP($i)
	$OPcode = $OPcode + "83C4" + Int2Hex($i, 8)
EndFunc   ;==>Add_ESP

;Call
;+++++++++++++++++++++++++++++++++++
Func Call_EAX()
	$OPcode = $OPcode + "FFD0"
EndFunc   ;==>Call_EAX

Func Call_EBX()
	$OPcode = $OPcode + "FFD3"
EndFunc   ;==>Call_EBX

Func Call_ECX()
	$OPcode = $OPcode + "FFD1"
EndFunc   ;==>Call_ECX

Func Call_EDX()
	$OPcode = $OPcode + "FFD2"
EndFunc   ;==>Call_EDX

Func Call_ESI()
	$OPcode = $OPcode + "FFD2"
EndFunc   ;==>Call_ESI

Func Call_ESP()
	$OPcode = $OPcode + "FFD4"
EndFunc   ;==>Call_ESP

Func Call_EBP()
	$OPcode = $OPcode + "FFD5"
EndFunc   ;==>Call_EBP

Func Call_EDI()
	$OPcode = $OPcode + "FFD7"
EndFunc   ;==>Call_EDI

Func Call_DWORD_Ptr($i)
	$OPcode = $OPcode + "FF15" + Int2Hex($i, 8)
EndFunc   ;==>Call_DWORD_Ptr

Func Call_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "FF10"
EndFunc   ;==>Call_DWORD_Ptr_EAX

Func Call_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "FF13"
EndFunc   ;==>Call_DWORD_Ptr_EBX

;Cmp
;+++++++++++++++++++++++++++++++++++
Func Cmp_EAX($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "83F8" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "3D" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Cmp_EAX

Func Cmp_EAX_EDX()
	$OPcode = $OPcode + "3BC2"
EndFunc   ;==>Cmp_EAX_EDX

Func Cmp_EAX_DWORD_Ptr($i)
	$OPcode = $OPcode + "3B05" + Int2Hex($i, 8)
EndFunc   ;==>Cmp_EAX_DWORD_Ptr

Func Cmp_DWORD_Ptr_EAX($i)
	$OPcode = $OPcode + "3905" + Int2Hex($i, 8)
EndFunc   ;==>Cmp_DWORD_Ptr_EAX

;DEC
;+++++++++++++++++++++++++++++++++++
Func Dec_EAX()
	$OPcode = $OPcode + "48"
EndFunc   ;==>Dec_EAX

Func Dec_EBX()
	$OPcode = $OPcode + "4B"
EndFunc   ;==>Dec_EBX

Func Dec_ECX()
	$OPcode = $OPcode + "49"
EndFunc   ;==>Dec_ECX

Func Dec_EDX()
	$OPcode = $OPcode + "4A"
EndFunc   ;==>Dec_EDX

;Idiv
;+++++++++++++++++++++++++++++++++++
Func Idiv_EAX()
	$OPcode = $OPcode + "F7F8"
EndFunc   ;==>Idiv_EAX

Func Idiv_EBX()
	$OPcode = $OPcode + "F7FB"
EndFunc   ;==>Idiv_EBX

Func Idiv_ECX()
	$OPcode = $OPcode + "F7F9"
EndFunc   ;==>Idiv_ECX

Func Idiv_EDX()
	$OPcode = $OPcode + "F7FA"
EndFunc   ;==>Idiv_EDX

;Imul
;+++++++++++++++++++++++++++++++++++
Func Imul_EAX_EDX()
	$OPcode = $OPcode + "0FAFC2"
EndFunc   ;==>Imul_EAX_EDX

Func Imul_EAX($i)
	$OPcode = $OPcode + "6BC0" + Int2Hex($i, 2)
EndFunc   ;==>Imul_EAX

Func ImulB_EAX($i)
	$OPcode = $OPcode + "69C0" + Int2Hex($i, 8)
EndFunc   ;==>ImulB_EAX

;INC
;+++++++++++++++++++++++++++++++++++
Func Inc_EAX()
	$OPcode = $OPcode + "40"
EndFunc   ;==>Inc_EAX

Func Inc_EBX()
	$OPcode = $OPcode + "43"
EndFunc   ;==>Inc_EBX

Func Inc_ECX()
	$OPcode = $OPcode + "41"
EndFunc   ;==>Inc_ECX

Func Inc_EDX()
	$OPcode = $OPcode + "42"
EndFunc   ;==>Inc_EDX

Func Inc_EDI()
	$OPcode = $OPcode + "47"
EndFunc   ;==>Inc_EDI

Func Inc_ESI()
	$OPcode = $OPcode + "46"
EndFunc   ;==>Inc_ESI

Func Inc_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "FF00"
EndFunc   ;==>Inc_DWORD_Ptr_EAX

Func Inc_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "FF03"
EndFunc   ;==>Inc_DWORD_Ptr_EBX

Func Inc_DWORD_Ptr_ECX()
	$OPcode = $OPcode + "FF01"
EndFunc   ;==>Inc_DWORD_Ptr_ECX

Func Inc_DWORD_Ptr_EDX()
	$OPcode = $OPcode + "FF02"
EndFunc   ;==>Inc_DWORD_Ptr_EDX

;JMP/JE/JNE
;+++++++++++++++++++++++++++++++++++
Func JMP_EAX()
	$OPcode = $OPcode + "FFE0"
EndFunc   ;==>JMP_EAX

;Mov
Func Mov_DWORD_Ptr_EAX($i)
	$OPcode = $OPcode + "A3" + Int2Hex($i, 8)
EndFunc   ;==>Mov_DWORD_Ptr_EAX

Func Mov_EAX($i)
	$OPcode = $OPcode + "B8" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EAX

Func Mov_EBX($i)
	$OPcode = $OPcode + "BB" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EBX

Func Mov_ECX($i)
	$OPcode = $OPcode + "B9" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ECX

Func Mov_EDX($i)
	$OPcode = $OPcode + "BA" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EDX

Func Mov_ESI($i)
	$OPcode = $OPcode + "BE" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ESI

Func Mov_ESP($i)
	$OPcode = $OPcode + "BC" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ESP

Func Mov_EBP($i)
	$OPcode = $OPcode + "BD" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EBP


Func Mov_EDI($i)
	$OPcode = $OPcode + "BF" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EDI

Func Mov_EBX_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B1D" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EBX_DWORD_Ptr

Func Mov_ECX_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B0D" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ECX_DWORD_Ptr

Func Mov_EAX_DWORD_Ptr($i)
	$OPcode = $OPcode + "A1" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EAX_DWORD_Ptr

Func Mov_EDX_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B15" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EDX_DWORD_Ptr

Func Mov_ESI_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B35" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ESI_DWORD_Ptr

Func Mov_ESP_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B25" + Int2Hex($i, 8)
EndFunc   ;==>Mov_ESP_DWORD_Ptr

Func Mov_EBP_DWORD_Ptr($i)
	$OPcode = $OPcode + "8B2D" + Int2Hex($i, 8)
EndFunc   ;==>Mov_EBP_DWORD_Ptr

Func Mov_EAX_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "8B00"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EAX

Func Mov_EAX_DWORD_Ptr_EBP()
	$OPcode = $OPcode + "8B4500"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EBP

Func Mov_EAX_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "8B03"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EBX

Func Mov_EAX_DWORD_Ptr_ECX()
	$OPcode = $OPcode + "8B01"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ECX

Func Mov_EAX_DWORD_Ptr_EDX()
	$OPcode = $OPcode + "8B02"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EDX

Func Mov_EAX_DWORD_Ptr_EDI()
	$OPcode = $OPcode + "8B07"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EDI

Func Mov_EAX_DWORD_Ptr_ESP()
	$OPcode = $OPcode + "8B0424"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ESP

Func Mov_EAX_DWORD_Ptr_ESI()
	$OPcode = $OPcode + "8B06"
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ESI

Func Mov_EAX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B40" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B80" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EAX_Add

Func Mov_EAX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4424" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8424" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ESP_Add

Func Mov_EAX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B43" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B83" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EBX_Add

Func Mov_EAX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B41" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B81" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ECX_Add

Func Mov_EAX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B42" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B82" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EDX_Add

Func Mov_EAX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B47" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B87" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EDI_Add

Func Mov_EAX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B45" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B85" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_EBP_Add

Func Mov_EAX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B46" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B86" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EAX_DWORD_Ptr_ESI_Add

Func Mov_EBX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B58" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B98" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EAX_Add

Func Mov_EBX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5C24" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9C24" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ESP_Add

Func Mov_EBX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5B" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9B" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EBX_Add

Func Mov_EBX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B59" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B99" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ECX_Add

Func Mov_EBX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5A" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9A" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EDX_Add

Func Mov_EBX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5F" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9F" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EDI_Add

Func Mov_EBX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5D" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9D" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EBP_Add

Func Mov_EBX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5E" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9E" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ESI_Add

Func Mov_ECX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B48" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B88" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EAX_Add

Func Mov_ECX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4C24" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8C24" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ESP_Add

Func Mov_ECX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4B" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8B" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EBX_Add

Func Mov_ECX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B49" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B89" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ECX_Add

Func Mov_ECX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4A" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8A" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EDX_Add

Func Mov_ECX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4F" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8F" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EDI_Add

Func Mov_ECX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4D" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8D" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EBP_Add

Func Mov_ECX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B4E" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B8E" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ESI_Add

Func Mov_EDX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B50" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B90" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EAX_Add

Func Mov_EDX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B5424" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B9424" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ESP_Add

Func Mov_EDX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B53" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B93" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EBX_Add

Func Mov_EDX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B51" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B91" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ECX_Add

Func Mov_EDX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B52" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B92" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EDX_Add

Func Mov_EDX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B57" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B97" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EDI_Add

Func Mov_EDX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B55" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B95" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EBP_Add

Func Mov_EDX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8B56" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8B96" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ESI_Add

Func Mov_EBX_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "8B18"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EAX

Func Mov_EBX_DWORD_Ptr_EBP()
	$OPcode = $OPcode + "8B5D00"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EBP

Func Mov_EBX_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "8B1B"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EBX

Func Mov_EBX_DWORD_Ptr_ECX()
	$OPcode = $OPcode + "8B19"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ECX

Func Mov_EBX_DWORD_Ptr_EDX()
	$OPcode = $OPcode + "8B1A"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EDX

Func Mov_EBX_DWORD_Ptr_EDI()
	$OPcode = $OPcode + "8B1F"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_EDI

Func Mov_EBX_DWORD_Ptr_ESP()
	$OPcode = $OPcode + "8B1C24"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ESP

Func Mov_EBX_DWORD_Ptr_ESI()
	$OPcode = $OPcode + "8B1E"
EndFunc   ;==>Mov_EBX_DWORD_Ptr_ESI
Func Mov_ECX_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "8B08"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EAX

Func Mov_ECX_DWORD_Ptr_EBP()
	$OPcode = $OPcode + "8B4D00"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EBP

Func Mov_ECX_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "8B0B"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EBX

Func Mov_ECX_DWORD_Ptr_ECX()
	$OPcode = $OPcode + "8B09"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ECX

Func Mov_ECX_DWORD_Ptr_EDX()
	$OPcode = $OPcode + "8B0A"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EDX

Func Mov_ECX_DWORD_Ptr_EDI()
	$OPcode = $OPcode + "8B0F"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_EDI

Func Mov_ECX_DWORD_Ptr_ESP()
	$OPcode = $OPcode + "8B0C24"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ESP

Func Mov_ECX_DWORD_Ptr_ESI()
	$OPcode = $OPcode + "8B0E"
EndFunc   ;==>Mov_ECX_DWORD_Ptr_ESI

Func Mov_EDX_DWORD_Ptr_EAX()
	$OPcode = $OPcode + "8B10"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EAX

Func Mov_EDX_DWORD_Ptr_EBP()
	$OPcode = $OPcode + "8B5500"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EBP

Func Mov_EDX_DWORD_Ptr_EBX()
	$OPcode = $OPcode + "8B13"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EBX

Func Mov_EDX_DWORD_Ptr_ECX()
	$OPcode = $OPcode + "8B11"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ECX

Func Mov_EDX_DWORD_Ptr_EDX()
	$OPcode = $OPcode + "8B12"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EDX

Func Mov_EDX_DWORD_Ptr_EDI()
	$OPcode = $OPcode + "8B17"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_EDI

Func Mov_EDX_DWORD_Ptr_ESI()
	$OPcode = $OPcode + "8B16"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ESI

Func Mov_EDX_DWORD_Ptr_ESP()
	$OPcode = $OPcode + "8B1424"
EndFunc   ;==>Mov_EDX_DWORD_Ptr_ESP

Func Mov_EAX_EBP()
	$OPcode = $OPcode + "8BC5"
EndFunc   ;==>Mov_EAX_EBP

Func Mov_EAX_EBX()
	$OPcode = $OPcode + "8BC3"
EndFunc   ;==>Mov_EAX_EBX

Func Mov_EAX_ECX()
	$OPcode = $OPcode + "8BC1"
EndFunc   ;==>Mov_EAX_ECX

Func Mov_EAX_EDI()
	$OPcode = $OPcode + "8BC7"
EndFunc   ;==>Mov_EAX_EDI

Func Mov_EAX_EDX()
	$OPcode = $OPcode + "8BC2"
EndFunc   ;==>Mov_EAX_EDX

Func Mov_EAX_ESI()
	$OPcode = $OPcode + "8BC6"
EndFunc   ;==>Mov_EAX_ESI

Func Mov_EAX_ESP()
	$OPcode = $OPcode + "8BC4"
EndFunc   ;==>Mov_EAX_ESP

Func Mov_EBX_EBP()
	$OPcode = $OPcode + "8BDD"
EndFunc   ;==>Mov_EBX_EBP

Func Mov_EBX_EAX()
	$OPcode = $OPcode + "8BD8"
EndFunc   ;==>Mov_EBX_EAX

Func Mov_EBX_ECX()
	$OPcode = $OPcode + "8BD9"
EndFunc   ;==>Mov_EBX_ECX

Func Mov_EBX_EDI()
	$OPcode = $OPcode + "8BDF"
EndFunc   ;==>Mov_EBX_EDI

Func Mov_EBX_EDX()
	$OPcode = $OPcode + "8BDA"
EndFunc   ;==>Mov_EBX_EDX

Func Mov_EBX_ESI()
	$OPcode = $OPcode + "8BDE"
EndFunc   ;==>Mov_EBX_ESI

Func Mov_EBX_ESP()
	$OPcode = $OPcode + "8BDC"
EndFunc   ;==>Mov_EBX_ESP

Func Mov_ECX_EBP()
	$OPcode = $OPcode + "8BCD"
EndFunc   ;==>Mov_ECX_EBP

Func Mov_ECX_EAX()
	$OPcode = $OPcode + "8BC8"
EndFunc   ;==>Mov_ECX_EAX

Func Mov_ECX_EBX()
	$OPcode = $OPcode + "8BCB"
EndFunc   ;==>Mov_ECX_EBX

Func Mov_ECX_EDI()
	$OPcode = $OPcode + "8BCF"
EndFunc   ;==>Mov_ECX_EDI

Func Mov_ECX_EDX()
	$OPcode = $OPcode + "8BCA"
EndFunc   ;==>Mov_ECX_EDX

Func Mov_ECX_ESI()
	$OPcode = $OPcode + "8BCE"
EndFunc   ;==>Mov_ECX_ESI

Func Mov_ECX_ESP()
	$OPcode = $OPcode + "8BCC"
EndFunc   ;==>Mov_ECX_ESP

Func Mov_EDX_EBP()
	$OPcode = $OPcode + "8BD5"
EndFunc   ;==>Mov_EDX_EBP

Func Mov_EDX_EBX()
	$OPcode = $OPcode + "8BD3"
EndFunc   ;==>Mov_EDX_EBX

Func Mov_EDX_ECX()
	$OPcode = $OPcode + "8BD1"
EndFunc   ;==>Mov_EDX_ECX

Func Mov_EDX_EDI()
	$OPcode = $OPcode + "8BD7"
EndFunc   ;==>Mov_EDX_EDI

Func Mov_EDX_EAX()
	$OPcode = $OPcode + "8BD0"
EndFunc   ;==>Mov_EDX_EAX

Func Mov_EDX_ESI()
	$OPcode = $OPcode + "8BD6"
EndFunc   ;==>Mov_EDX_ESI

Func Mov_EDX_ESP()
	$OPcode = $OPcode + "8BD4"
EndFunc   ;==>Mov_EDX_ESP

Func Mov_ESI_EBP()
	$OPcode = $OPcode + "8BF5"
EndFunc   ;==>Mov_ESI_EBP

Func Mov_ESI_EBX()
	$OPcode = $OPcode + "8BF3"
EndFunc   ;==>Mov_ESI_EBX

Func Mov_ESI_ECX()
	$OPcode = $OPcode + "8BF1"
EndFunc   ;==>Mov_ESI_ECX

Func Mov_ESI_EDI()
	$OPcode = $OPcode + "8BF7"
EndFunc   ;==>Mov_ESI_EDI

Func Mov_ESI_EAX()
	$OPcode = $OPcode + "8BF0"
EndFunc   ;==>Mov_ESI_EAX

Func Mov_ESI_EDX()
	$OPcode = $OPcode + "8BF2"
EndFunc   ;==>Mov_ESI_EDX

Func Mov_ESI_ESP()
	$OPcode = $OPcode + "8BF4"
EndFunc   ;==>Mov_ESI_ESP

Func Mov_ESP_EBP()
	$OPcode = $OPcode + "8BE5"
EndFunc   ;==>Mov_ESP_EBP

Func Mov_ESP_EBX()
	$OPcode = $OPcode + "8BE3"
EndFunc   ;==>Mov_ESP_EBX

Func Mov_ESP_ECX()
	$OPcode = $OPcode + "8BE1"
EndFunc   ;==>Mov_ESP_ECX

Func Mov_ESP_EDI()
	$OPcode = $OPcode + "8BE7"
EndFunc   ;==>Mov_ESP_EDI

Func Mov_ESP_EAX()
	$OPcode = $OPcode + "8BE0"
EndFunc   ;==>Mov_ESP_EAX

Func Mov_ESP_EDX()
	$OPcode = $OPcode + "8BE2"
EndFunc   ;==>Mov_ESP_EDX

Func Mov_ESP_ESI()
	$OPcode = $OPcode + "8BE6"
EndFunc   ;==>Mov_ESP_ESI

Func Mov_EDI_EBP()
	$OPcode = $OPcode + "8BFD"
EndFunc   ;==>Mov_EDI_EBP

Func Mov_EDI_EAX()
	$OPcode = $OPcode + "8BF8"
EndFunc   ;==>Mov_EDI_EAX

Func Mov_EDI_EBX()
	$OPcode = $OPcode + "8BFB"
EndFunc   ;==>Mov_EDI_EBX

Func Mov_EDI_ECX()
	$OPcode = $OPcode + "8BF9"
EndFunc   ;==>Mov_EDI_ECX

Func Mov_EDI_EDX()
	$OPcode = $OPcode + "8BFA"
EndFunc   ;==>Mov_EDI_EDX

Func Mov_EDI_ESI()
	$OPcode = $OPcode + "8BFE"
EndFunc   ;==>Mov_EDI_ESI

Func Mov_EDI_ESP()
	$OPcode = $OPcode + "8BFC"
EndFunc   ;==>Mov_EDI_ESP
Func Mov_EBP_EDI()
	$OPcode = $OPcode + "8BDF"
EndFunc   ;==>Mov_EBP_EDI

Func Mov_EBP_EAX()
	$OPcode = $OPcode + "8BE8"
EndFunc   ;==>Mov_EBP_EAX

Func Mov_EBP_EBX()
	$OPcode = $OPcode + "8BEB"
EndFunc   ;==>Mov_EBP_EBX

Func Mov_EBP_ECX()
	$OPcode = $OPcode + "8BE9"
EndFunc   ;==>Mov_EBP_ECX

Func Mov_EBP_EDX()
	$OPcode = $OPcode + "8BEA"
EndFunc   ;==>Mov_EBP_EDX

Func Mov_EBP_ESI()
	$OPcode = $OPcode + "8BEE"
EndFunc   ;==>Mov_EBP_ESI

Func Mov_EBP_ESP()
	$OPcode = $OPcode + "8BEC"
EndFunc   ;==>Mov_EBP_ESP
;Push
;+++++++++++++++++++++++++++++++++++
Func Push($i)
	;If $i <= 255 Then
	;$OPcode = $OPcode + "6A" + Int2Hex($i, 2)
	;Else
	$OPcode = $OPcode + "68" + Int2Hex($i, 8)
	;EndIf
EndFunc   ;==>Push

Func Push_DWORD_Ptr($i)
	$OPcode = $OPcode + "FF35" + Int2Hex($i, 8)
EndFunc   ;==>Push_DWORD_Ptr

Func Push_EAX()
	$OPcode = $OPcode + "50"
EndFunc   ;==>Push_EAX

Func Push_ECX()
	$OPcode = $OPcode + "51"
EndFunc   ;==>Push_ECX

Func Push_EDX()
	$OPcode = $OPcode + "52"
EndFunc   ;==>Push_EDX

Func Push_EBX()
	$OPcode = $OPcode + "53"
EndFunc   ;==>Push_EBX
Func Push_ESP()
	$OPcode = $OPcode + "54"
EndFunc   ;==>Push_ESP

Func Push_EBP()
	$OPcode = $OPcode + "55"
EndFunc   ;==>Push_EBP

Func Push_ESI()
	$OPcode = $OPcode + "56"
EndFunc   ;==>Push_ESI

Func Push_EDI()
	$OPcode = $OPcode + "57"
EndFunc   ;==>Push_EDI
;LEA
Func Lea_EAX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D40" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D80" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_EAX_Add

Func Lea_EAX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D43" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D83" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_EBX_Add

Func Lea_EAX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D41" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D81" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_ECX_Add

Func Lea_EAX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D42" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D82" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_EDX_Add

Func Lea_EAX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D46" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D86" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_ESI_Add

Func Lea_EAX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D40" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D80" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_ESP_Add

Func Lea_EAX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4424" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8424" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_EBP_Add

Func Lea_EAX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D47" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D87" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EAX_DWORD_Ptr_EDI_Add

Func Lea_EBX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D58" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D98" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_EAX_Add

Func Lea_EBX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5C24" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9C24" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_ESP_Add

Func Lea_EBX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5B" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9B" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_EBX_Add

Func Lea_EBX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D59" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D99" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_ECX_Add

Func Lea_EBX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5A" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9A" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_EDX_Add

Func Lea_EBX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5F" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9F" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_EDI_Add

Func Lea_EBX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5D" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9D" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_EBP_Add

Func Lea_EBX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5E" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9E" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EBX_DWORD_Ptr_ESI_Add

Func Lea_ECX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D48" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D88" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_EAX_Add

Func Lea_ECX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4C24" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8C24" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_ESP_Add

Func Lea_ECX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4B" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8B" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_EBX_Add

Func Lea_ECX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D49" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D89" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_ECX_Add

Func Lea_ECX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4A" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8A" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_EDX_Add

Func Lea_ECX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4F" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8F" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_EDI_Add

Func Lea_ECX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4D" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8D" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_EBP_Add

Func Lea_ECX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D4E" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D8E" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_ECX_DWORD_Ptr_ESI_Add

Func Lea_EDX_DWORD_Ptr_EAX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D50" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D90" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_EAX_Add

Func Lea_EDX_DWORD_Ptr_ESP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D5424" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D9424" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_ESP_Add

Func Lea_EDX_DWORD_Ptr_EBX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D53" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D93" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_EBX_Add

Func Lea_EDX_DWORD_Ptr_ECX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D51" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D91" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_ECX_Add

Func Lea_EDX_DWORD_Ptr_EDX_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D52" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D92" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_EDX_Add

Func Lea_EDX_DWORD_Ptr_EDI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D57" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D97" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_EDI_Add

Func Lea_EDX_DWORD_Ptr_EBP_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D55" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D95" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_EBP_Add

Func Lea_EDX_DWORD_Ptr_ESI_Add($i)
	If $i <= 255 Then
		$OPcode = $OPcode + "8D56" + Int2Hex($i, 2)
	Else
		$OPcode = $OPcode + "8D96" + Int2Hex($i, 8)
	EndIf
EndFunc   ;==>Lea_EDX_DWORD_Ptr_ESI_Add

;POP
Func Pop_EAX()
	$OPcode = $OPcode + "58"
EndFunc   ;==>Pop_EAX

Func Pop_EBX()
	$OPcode = $OPcode + "5B"
EndFunc   ;==>Pop_EBX

Func Pop_ECX()
	$OPcode = $OPcode + "59"
EndFunc   ;==>Pop_ECX

Func Pop_EDX()
	$OPcode = $OPcode + "5A"
EndFunc   ;==>Pop_EDX

Func Pop_ESI()
	$OPcode = $OPcode + "5E"
EndFunc   ;==>Pop_ESI

Func Pop_ESP()
	$OPcode = $OPcode + "5C"
EndFunc   ;==>Pop_ESP

Func Pop_EDI()
	$OPcode = $OPcode + "5F"
EndFunc   ;==>Pop_EDI

Func Pop_EBP()
	$OPcode = $OPcode + "5D"
EndFunc   ;==>Pop_EBP

Func _Ptr(ByRef $Add)
	$Ptr = VarPtr($Add)
EndFunc   ;==>_Ptr

Func Float4Int($Ans) ;?????
	Dim $AB, $a
	CopyMemory($AB, $Ans, 4)
	$Float4Int = $AB
EndFunc   ;==>Float4Int

;Func  Float8Int(ByRef Ans) ;?????
;    Dim AB As Long
;    CopyMemory AB, Ans, 8
;    Float8Int = AB
;EndFunc