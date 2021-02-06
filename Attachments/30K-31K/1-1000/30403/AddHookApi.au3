#include <WinAPI.au3>

Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hSHELL32 = DllOpen("shell32.dll")

; Intercept ShellExecuteExW
_AddHookApi("shell32.dll", "ShellExecuteExW", "_Intercept_ShellExecuteExW", "bool", "ptr")
; Few more for fun
Global $pOldSleep = _AddHookApi("kernel32.dll", "Sleep", "_Intercept_Sleep", "none", "dword")
Global $pOldBeep = _AddHookApi("kernel32.dll", "Beep", "_Intercept_Beep", "bool", "dword;dword")


ShellExecute(@ScriptFullPath, "", "", "properties")
ShellExecute("notepad.exe", "", "", "open")

_DllCallPointer("none", $pOldSleep, "dword", 3500) ; original sleep
;Sleep(3500) ; this will be intercepted

; _DllCallPointer("bool", $pOldBeep, "dword", 200, "dword", 200) ; original beep
Beep(500, 500) ; this will be intercepted



; INTERCEPTING FUNCTIONS:

Func _Intercept_ShellExecuteExW($pBuffer)
	ConsoleWrite("! AutoIt calling ShellExecuteExW with parameter pBuffer = " & $pBuffer & @CRLF)
	; $pBuffer points to SHELLEXECUTEINFO structure:
	Local $tSHELLEXECUTEINFO = DllStructCreate("dword Size;" & _
			"dword Mask;" & _
			"hwnd Parent;" & _
			"ptr Verb;" & _
			"ptr File;" & _
			"ptr Parameters;" & _
			"ptr Directory;" & _
			"int Show;" & _
			"handle InstApp;" & _
			"ptr IDList;" & _
			"ptr Class;" & _
			"ptr KeyClass;" & _
			"dword HotKey;" & _
			"handle Icon;" & _
			"handle Process", _
			$pBuffer)
	; Print interesting data:
	Local $sVerb = DllStructGetData(DllStructCreate("wchar[256]", DllStructGetData($tSHELLEXECUTEINFO, "Verb")), 1)
	ConsoleWrite("     - Verb = " & $sVerb & @CRLF)
	ConsoleWrite("     - File = " & DllStructGetData(DllStructCreate("wchar[256]", DllStructGetData($tSHELLEXECUTEINFO, "File")), 1) & @CRLF)
	; Read mask:
	ConsoleWrite("     - Mask = " & DllStructGetData($tSHELLEXECUTEINFO, "Mask") & @CRLF) ; will print SEE_MASK_NOCLOSEPROCESS
	; Make correction in case of "properties":
	If $sVerb = "properties" Then DllStructSetData($tSHELLEXECUTEINFO, "Mask", 12) ; SEE_MASK_INVOKEIDLIST must be included
	; Call:
	Local $aCall = DllCall($hSHELL32, "bool", "ShellExecuteExW",  "ptr", $pBuffer)
	If @error Or Not $aCall[0] Then Return 0
	Return $aCall[0]
EndFunc   ;==>_Intercept_ShellExecuteExW


Func _Intercept_Sleep($iDuration)
	ConsoleWrite("! AutoIt calling Sleep with parameter $iDuration = " & $iDuration & @CRLF)
	DllCall($hKERNEL32, "none", "Sleep", "dword", $iDuration)
EndFunc   ;==>_Intercept_Sleep


Func _Intercept_Beep($iFrequency, $iDuration)
	ConsoleWrite("! AutoIt calling Beep with parameter $iFrequency = " & $iFrequency & " and $iDuration = " & $iDuration & @CRLF)
	Local $aCall = DllCall($hKERNEL32, "bool", "Beep", "dword", $iFrequency, "dword", $iDuration)
	If @error Or Not $aCall[0] Then Return 0
	Return $aCall[0]
EndFunc   ;==>_Intercept_Sleep




; TWO MAIN FUNCTIONS:

Func _AddHookApi($sModuleName, $sFunctionName, $sNewFunction, $sRet, $sParams)
	Local Static $pImportDirectory, $hInstance
	If Not $pImportDirectory Then
		$hInstance = _WinAPI_GetModuleHandle(0)
		If @error Then Return SetError(1, 0, 0)
		Local $aCall = DllCall("Dbghelp.dll", "ptr", "ImageDirectoryEntryToData", _
				"ptr", $hInstance, _
				"int", 1, _ ; as an image
				"ushort", 1, _ ; IMAGE_DIRECTORY_ENTRY_IMPORT
				"dword*", 0)
		If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
		$pImportDirectory = $aCall[0]
	EndIf
	Local $tIMAGE_IMPORT_MODULE_DIRECTORY
	Local $pDirectoryOffset = $pImportDirectory
	Local $tModuleName
	Local $iInitialOffset, $iInitialOffset2
	Local $iOffset2
	Local $tBufferOffset2, $iBufferOffset2
	Local $tBuffer, $tFunctionOffset, $pOld
	While 1
		$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _
				"dword TimeDateStamp;" & _
				"dword ForwarderChain;" & _
				"dword RVAModuleName;" & _
				"dword RVAFirstThunk", _
				$pDirectoryOffset)
		If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop
		$tModuleName = DllStructCreate("char Name[64]", $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
		If DllStructGetData($tModuleName, "Name") = $sModuleName Then ; function from this module
			$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
			$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
			If $iInitialOffset2 < $iInitialOffset Then $iInitialOffset2 = $iInitialOffset
			$iOffset2 = 0
			While 1
				$tBufferOffset2 = DllStructCreate("dword_ptr", $iInitialOffset2 + $iOffset2)
				$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1)
				If Not $iBufferOffset2 Then ExitLoop
				$tBuffer = DllStructCreate("ushort Ordinal; char Name[64]", $hInstance + $iBufferOffset2)
				If DllStructGetData($tBuffer, "Name") == $sFunctionName Then ; wanted function
					$tFunctionOffset = DllStructCreate("ptr", $iInitialOffset + $iOffset2)
					$aCall = DllCall($hKERNEL32, "bool", "VirtualProtect", _
							"ptr", DllStructGetPtr($tFunctionOffset), _
							"dword_ptr", DllStructGetSize($tFunctionOffset), _
							"dword", 4, _ ; PAGE_READWRITE
							"dword*", 0)
					If @error Or Not $aCall[0] Then Return SetError(3, 0, 0)
					$pOld = DllStructGetData($tFunctionOffset, 1)
					DllStructSetData($tFunctionOffset, 1, DllCallbackGetPtr(DllCallbackRegister($sNewFunction, $sRet, $sParams)))
					;ConsoleWrite("+" & $sFunctionName & " OK to go" & @CRLF)
					Return $pOld
				EndIf
				$iOffset2 += DllStructGetSize($tBufferOffset2)
			WEnd
			ExitLoop 2
		EndIf
		$pDirectoryOffset += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY
	WEnd
	Return SetError(4, 0, 0)
EndFunc   ;==>_AddHookApi


Func _DllCallPointer($sRetType, $pAddress, $sType1 = "", $vParam1 = 0, $sType2 = "", $vParam2 = 0, $sType3 = "", $vParam3 = 0, $sType4 = "", $vParam4 = 0, $sType5 = "", $vParam5 = 0, $sType6 = "", $vParam6 = 0, $sType7 = "", $vParam7 = 0, $sType8 = "", $vParam8 = 0, $sType9 = "", $vParam9 = 0, $sType10 = "", $vParam10 = 0, $sType11 = "", $vParam11 = 0, $sType12 = "", $vParam12 = 0, $sType13 = "", $vParam13 = 0, $sType14 = "", $vParam14 = 0, $sType15 = "", $vParam15 = 0, $sType16 = "", $vParam16 = 0, $sType17 = "", $vParam17 = 0, $sType18 = "", $vParam18 = 0, $sType19 = "", $vParam19 = 0, $sType20 = "", $vParam20 = 0)
	; Author: Ward, Prog@ndy, trancexx
	Local Static $pHook, $hPseudo, $tPtr, $sDll, $sFuncName
	If $pAddress Then
		If Not $pHook Then
			Local $iX64 = @AutoItX64
			$hPseudo = DllOpen($sDll)
			If $hPseudo = -1 Then
				$sDll = "kernel32.dll"
				$sFuncName = "GlobalFix"
				$hPseudo = DllOpen($sDll)
			EndIf
			Local $aCall = DllCall($hKERNEL32, "ptr", "GetModuleHandleW", "wstr", $sDll)
			If @error Or Not $aCall[0] Then Return SetError(7, @error, 0) ; Couldn't get dll handle
			Local $hModuleHandle = $aCall[0]
			$aCall = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hModuleHandle, "str", $sFuncName)
			If @error Then Return SetError(8, @error, 0) ; Wanted function not found
			$pHook = $aCall[0]
			$aCall = DllCall($hKERNEL32, "bool", "VirtualProtect", "ptr", $pHook, "dword_ptr", 7 + 5 * $iX64, "dword", 64, "dword*", 0)
			If @error Or Not $aCall[0] Then Return SetError(9, @error, 0) ; Unable to set MEM_EXECUTE_READWRITE
			If $iX64 Then
				DllStructSetData(DllStructCreate("word", $pHook), 1, 0xB848)
				DllStructSetData(DllStructCreate("word", $pHook + 10), 1, 0xE0FF)
			Else
				DllStructSetData(DllStructCreate("byte", $pHook), 1, 0xB8)
				DllStructSetData(DllStructCreate("word", $pHook + 5), 1, 0xE0FF)
			EndIf
			$tPtr = DllStructCreate("ptr", $pHook + 1 + $iX64)
		EndIf
		DllStructSetData($tPtr, 1, $pAddress)
		Local $aRet
		Switch @NumParams
			Case 2
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName)
			Case 4
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1)
			Case 6
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2)
			Case 8
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
			Case 10
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
			Case 12
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
			Case 14
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
			Case 16
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
			Case 18
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
			Case 20
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
			Case 22
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
			Case 24
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
			Case 26
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12)
			Case 28
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13)
			Case 30
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14)
			Case 32
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15)
			Case 34
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16)
			Case 36
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17)
			Case 38
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18)
			Case 40
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19)
			Case 42
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19, $sType20, $vParam20)
			Case Else
				If Mod(@NumParams, 2) Then Return SetError(4, 0, 0) ; Bad number of parameters
				Return SetError(5, 0, 0) ; Max number of parameters exceeded
		EndSwitch
		Return SetError(@error, @extended, $aRet) ; All went well. Error description and return values like with DllCall()
	EndIf
	Return SetError(6, 0, 0) ; Null address specified
EndFunc   ;==>_DllCallPointer
