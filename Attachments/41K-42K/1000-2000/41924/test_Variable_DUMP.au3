
#AutoIt3Wrapper_Run_Before=Variable_list.exe %in%
;~ http://www.autoitscript.com/forum/topic/22625-output-global-variables-on-exit/

#include "WinAPIEx.au3"
#include <array.au3>

OnAutoItExitRegister('_GetVariablesValue')
AddHookApi("user32.dll", "MessageBoxW", "Intercept_MessageBoxW", "int", "hwnd;wstr;wstr;uint")

Global $string = 'This is a string with a @TAB' & @TAB & 'and it ends with @CRLF' & @CRLF
Global $array[11]
Global $binary = StringToBinary($string)
Global $bool = True
Global $false = False
Global $float = 12.01
Global $hex = Hex(13)
Global $hwnd = WinGetHandle("[CLASS:Shell_TrayWnd]")
Global $int = 14
Global $keyword = Default
Global $number = Number(15.01)
Global $ptr = Ptr(16)
Global $struct = DllStructCreate('char[' & 65536 & ']')
Global $true = True
Global $aFuncNames[20]

For $i = 1 To 3
	$int = $i
	MsgBox(0, 'Test $int changing:', _GetVariablesValue())
Next

_test_Main()

MsgBox(0, 'CRASH', $aFuncNames[40])
Exit

Func _GetVariablesValue()
	Local $__content, $__string, $__variable, $__format = '%-10s%-15s%s'
	$__content = StringReplace($_sGlobalVariableList, '$', '')
	$__content = StringSplit($__content, '|')
	If IsArray($__content) Then
		$__content = _ArrayUnique($__content)
		_ArraySort($__content)
		$__string = '_ListOfGlobalVariables' & @CRLF
		$__string &= StringFormat($__format, 'TYPE', 'VARIABLE', 'VALUE') & @CRLF
		$__string &= StringFormat($__format, '====', '========', '=====') & @CRLF
		For $__variable In $__content
			If IsDeclared($__variable) = 1 Then
				$__string &= StringFormat($__format, VarGetType(Eval($__variable)), '$' & $__variable, Eval($__variable)) & @CRLF
			EndIf
		Next
		ConsoleWrite($__string & @CRLF)
	Else
		ConsoleWriteError('No variables found' & @CRLF)
	EndIf
	$__string &= '============================' & @CRLF & 'Functions' & @CRLF & _ArrayToString($aFuncNames, @CRLF)
	Return $__string
EndFunc   ;==>_GetVariablesValue

Func _test_Main()
	Local $sMain_local_1 = 'aa'
	Local $sMain_local_2 = 1
	Local $sMain_local_3 = 1
	Local $sMain_local_4 = 1
	Local $sMain_local_5 = 1
	Local $sMain_local_6 = 1
	Local $sMain_local_7 = 1
	MsgBox(0, '_test_Main : 1', _GetVariablesValue())

	_test_Func_1()
	MsgBox(0, '_test_Func_1', _GetVariablesValue())
	_test_Func_2(True)
	MsgBox(0, '_test_Func_2:True', _GetVariablesValue())
	_test_Func_2(False)
	MsgBox(0, '_test_Func_2:False', _GetVariablesValue())
	_test_Func_3()
	MsgBox(0, '_test_Func_3', _GetVariablesValue())
	_test_Func_4()
	MsgBox(0, '_test_Func_4', _GetVariablesValue())
EndFunc   ;==>_test_Main


Func _test_Func_1()
	Local $sTest_local_1_1 = 'aa'
	Local $sTest_local_1_2 = 1
EndFunc   ;==>_test_Func_1

Func _test_Func_2($fTest)
	Local $sTest_local_2_1 = 'aa'
	Local $sTest_local_2_2 = 1
	If $fTest = True Then
		Return
	Else
;~
	EndIf
	Return 'abc'
EndFunc   ;==>_test_Func_2

Func _test_Func_3()
	Local $sTest_local_1_1 = 'aa'
	Local $sTest_local_1_2 = 1
EndFunc   ;==>_test_Func_3

Func _test_Func_4()
	Local $sTest_local_1_1 = 'aa'
	Local $sTest_local_1_2 = 1
EndFunc   ;==>_test_Func_4

Func _Func_Start($sFuncName)
	_ArrayPush($aFuncNames, '_Func_Start: ' & $sFuncName)
EndFunc   ;==>_Func_Start

Func _Func_End($sFuncName)
	_ArrayPush($aFuncNames, '_Func_End: ' & $sFuncName)
EndFunc   ;==>_Func_End


Func Intercept_MessageBoxW($hwnd, $sText, $sTitle, $iType)
;~ 	http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
	Local $sText_old = $sText, $sTitle_old = $sTitle, $iType_old = $iType
	If _
			StringInStr($sText, @ScriptFullPath) <> 0 And _
			StringInStr($sText, 'Error:') <> 0 And _
			StringInStr($sTitle, 'AutoIt Error') <> 0 _
			Then

		$sText &= @CRLF & @CRLF & _GetVariablesValue()
	EndIf
	Local $aCall = DllCall("user32.dll", "int", "MessageBoxW", _
			"hwnd", $hwnd, _
			"wstr", $sText, _
			"wstr", $sTitle, _
			"uint", $iType)
	If @error Or Not $aCall[0] Then Return 0
	Return $aCall[0]
EndFunc   ;==>Intercept_MessageBoxW

Func AddHookApi($sModuleName, $vFunctionName, $vNewFunction, $sRet = "", $sParams = "")
;~ 	http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
	; The magic is down below
	Local Static $pImportDirectory, $hInstance
	Local Const $IMAGE_DIRECTORY_ENTRY_IMPORT = 1
	If Not $pImportDirectory Then
		$hInstance = _WinAPI_GetModuleHandle(0)
		$pImportDirectory = ImageDirectoryEntryToData($hInstance, $IMAGE_DIRECTORY_ENTRY_IMPORT)
		If @error Then Return SetError(1, 0, 0)
	EndIf
	Local $iIsInt = IsInt($vFunctionName)
	Local $iRestore = Not IsString($vNewFunction)
	Local $tIMAGE_IMPORT_MODULE_DIRECTORY
	Local $pDirectoryOffset = $pImportDirectory
	Local $tModuleName
	Local $iInitialOffset, $iInitialOffset2
	Local $iOffset2
	Local $tBufferOffset2, $iBufferOffset2
	Local $tBuffer, $tFunctionOffset, $pOld, $fMatch, $pModuleName, $pFuncName
	Local Const $PAGE_READWRITE = 0x04
	While 1
		$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _
				"dword TimeDateStamp;" & _
				"dword ForwarderChain;" & _
				"dword RVAModuleName;" & _
				"dword RVAFirstThunk", _
				$pDirectoryOffset)
		If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop
		$pModuleName = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName")
		$tModuleName = DllStructCreate("char Name[" & _WinAPI_StringLenA($pModuleName) & "]", $pModuleName)
		If DllStructGetData($tModuleName, "Name") = $sModuleName Then ; function from this module
			$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
			$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
			If $iInitialOffset2 = $hInstance Then $iInitialOffset2 = $iInitialOffset
			$iOffset2 = 0
			While 1
				$tBufferOffset2 = DllStructCreate("dword_ptr", $iInitialOffset2 + $iOffset2)
				$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1)
				If Not $iBufferOffset2 Then ExitLoop
				If $iIsInt Then
					If BitAND($iBufferOffset2, 0xFFFFFF) = $vFunctionName Then $fMatch = True; wanted function
				Else
					$pFuncName = $hInstance + $iBufferOffset2 + 2 ; 2 is size od "word", see line below...
					$tBuffer = DllStructCreate("word Ordinal; char Name[" & _WinAPI_StringLenA($pFuncName) & "]", $hInstance + $iBufferOffset2)
					If DllStructGetData($tBuffer, "Name") == $vFunctionName Then $fMatch = True; wanted function
				EndIf
				If $fMatch Then
					$tFunctionOffset = DllStructCreate("ptr", $iInitialOffset + $iOffset2)
					VirtualProtect(DllStructGetPtr($tFunctionOffset), DllStructGetSize($tFunctionOffset), $PAGE_READWRITE)
					If @error Then Return SetError(3, 0, 0)
					$pOld = DllStructGetData($tFunctionOffset, 1)
					If $iRestore Then
						DllStructSetData($tFunctionOffset, 1, $vNewFunction)
					Else
						DllStructSetData($tFunctionOffset, 1, DllCallbackGetPtr(DllCallbackRegister($vNewFunction, $sRet, $sParams)))
					EndIf
					Return $pOld
				EndIf
				$iOffset2 += DllStructGetSize($tBufferOffset2)
			WEnd
			ExitLoop
		EndIf
		$pDirectoryOffset += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY
	WEnd
	Return SetError(4, 0, 0)
EndFunc   ;==>AddHookApi

Func VirtualProtect($pAddress, $iSize, $iProtection)
;~ 	http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
	Local $aCall = DllCall("kernel32.dll", "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>VirtualProtect

Func ImageDirectoryEntryToData($hInstance, $iDirectoryEntry)
;~ 	http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
	; Get pointer to data
	Local $pPointer = $hInstance
	; Start processing passed binary data. 'Reading' PE format follows.
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"word BytesOnLastPage;" & _
			"word Pages;" & _
			"word Relocations;" & _
			"word SizeofHeader;" & _
			"word MinimumExtra;" & _
			"word MaximumExtra;" & _
			"word SS;" & _
			"word SP;" & _
			"word Checksum;" & _
			"word IP;" & _
			"word CS;" & _
			"word Relocation;" & _
			"word Overlay;" & _
			"char Reserved[8];" & _
			"word OEMIdentifier;" & _
			"word OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)
	Local $sMagic = DllStructGetData($tIMAGE_DOS_HEADER, "Magic")
	; Check if it's valid format
	If Not ($sMagic == "MZ") Then Return SetError(1, 0, 0) ; MS-DOS header missing. Btw 'MZ' are the initials of Mark Zbikowski in case you didn't know.
	; Move pointer
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header
	; In place of IMAGE_NT_SIGNATURE structure
	Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)
	; Check signature
	If DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") <> 17744 Then ; IMAGE_NT_SIGNATURE
		Return SetError(2, 0, 0) ; wrong signature. For PE image should be "PE\0\0" or 17744 dword.
	EndIf
	; Move pointer
	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure
	; In place of IMAGE_FILE_HEADER structure
	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
			"word NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"word SizeOfOptionalHeader;" & _
			"word Characteristics", _
			$pPointer)
	; Get number of sections
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	; Determine the type
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
	Local $tIMAGE_OPTIONAL_HEADER
	If $iMagic = 267 Then ; x86 version
		; Move pointer
		$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER
	ElseIf $iMagic = 523 Then ; x64 version
		; Move pointer
		$pPointer += 112 ; size of $tIMAGE_OPTIONAL_HEADER
	Else
		Return SetError(3, 0, 0) ; unsupported module type
	EndIf
	; Validate input by checking available number of structures that are in the module
	Local Const $IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16 ; predefined value that PE modules always use (AutoIt certainly)
	If $iDirectoryEntry > $IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1 Then Return SetError(4, 0, 0) ; invalid input
	; Calculate the offset to wanted entry (every entry is 8 bytes)
	$pPointer += 8 * $iDirectoryEntry
	; At place of correst directory entry
	Local $tIMAGE_DIRECTORY_ENTRY = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddress = DllStructGetData($tIMAGE_DIRECTORY_ENTRY, "VirtualAddress")
	If $pAddress = 0 Then Return SetError(5, 0, 0) ; invalid input
	; $pAddress is RVA, add it to base address
	Return $hInstance + $pAddress
EndFunc   ;==>ImageDirectoryEntryToData
