#Tidy_Parameters=/reel
;~ #AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include-once
#include <array.au3>
#include "WinAPIEx.au3"

Global $__fDump_AlwaysToFile_OnOff = False
Global $__fDump_Accident_OnOff = False
Global $__fDump_AccidentToFile_OnOff = False
Global $__fDump_RegisteredExit_OnOff = False
Global $__fDump_RegisteredExitToFile_OnOff = False
Global $__fDump_RegisteredExitDisplay_all_data = False
Global $__hDump_LogFile = @ScriptFullPath & '__Dump.log'
Global $__aDump_FuncNames[20]
Global $__pOriginalFunc = ''

FileDelete($__hDump_LogFile) ; Delete on start

If IsDeclared('_sGlobalVariableList') <> 1 Then
	Assign('_sGlobalVariableList', '', 2) ; Force creation in global scope
;~ 	Global $_sGlobalVariableList = ''
EndIf

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_ChangeLogFile
; Description ...:
; Syntax ........: _Dump_ChangeLogFile($hFileFullPath[, $fDelete = Default])
; Parameters ....: $hFileFullPath       - A file full path to Log File
;                  $fDelete             - [optional] A boolean value. Default is Default.
; Return values .: None
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_ChangeLogFile($hFileFullPath, $fDelete = Default)
	$__hDump_LogFile = $hFileFullPath
	If $fDelete = Default Then FileDelete($__hDump_LogFile)
EndFunc   ;==>_Dump_ChangeLogFile

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_AlwaysToFile_OnOff
; Description ...: Sets for all functions is doing a dump, whether the function should immediately write the result to a file dump.
; Syntax ........: _Dump_AlwaysToFile_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
;										- True - set the status to True (enable/ON), and returns the status of the function.
;										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......: no yet finished, in testing
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_AlwaysToFile_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_AlwaysToFile_OnOff(Default): $__fDump_AlwaysToFile_OnOff = ' & $__fDump_AlwaysToFile_OnOff & @CRLF)
		Return $__fDump_AlwaysToFile_OnOff
	Else
		If $fSwitch Then
			$__fDump_AlwaysToFile_OnOff = True
			ConsoleWrite('! _Dump_AlwaysToFile_OnOff() = ON' & @CRLF)
		Else
			$__fDump_AlwaysToFile_OnOff = False
			ConsoleWrite('! _Dump_AlwaysToFile_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_AlwaysToFile_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_Accident_OnOff
; Description ...: Enable / Disable / Report the status of dumping variables in case of an accident.
; Syntax ........: _Dump_Accident_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
; 										- True - set the status to True (enable/ON), and returns the status of the function.
; 										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_Accident_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_Accident_OnOff(Default): $__fDump_Accident_OnOff = ' & $__fDump_Accident_OnOff & @CRLF)
		Return $__fDump_Accident_OnOff
	Else
		If $fSwitch Then
			$__pOriginalFunc = AddHookApi("user32.dll", "MessageBoxW", "Intercept_MessageBoxW", "int", "hwnd;wstr;wstr;uint")
			$__fDump_Accident_OnOff = True
			ConsoleWrite('! _Dump_Accident_OnOff() = ON' & @CRLF)
		Else
			If $__pOriginalFunc <> '' Then AddHookApi("user32.dll", "MessageBoxW", $__pOriginalFunc)
			$__pOriginalFunc = ''
			$__fDump_Accident_OnOff = False
			ConsoleWrite('! _Dump_Accident_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_Accident_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_AccidentToFile_OnOff
; Description ...: Enable / Disable / Report the status of dumping variables to file in case of an accident.
; Syntax ........: _Dump_AccidentToFile_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
; 										- True - set the status to True (enable/ON), and returns the status of the function.
; 										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_AccidentToFile_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_AccidentToFile_OnOff(Default): $__fDump_AccidentToFile_OnOff = ' & $__fDump_AccidentToFile_OnOff & @CRLF)
		Return $__fDump_AccidentToFile_OnOff
	Else
		If $__fDump_Accident_OnOff Then
			If $fSwitch Then
				$__fDump_AccidentToFile_OnOff = True
				ConsoleWrite('! _Dump_AccidentToFile_OnOff() = ON' & @CRLF)
			Else
				$__fDump_AccidentToFile_OnOff = False
				ConsoleWrite('! _Dump_AccidentToFile_OnOff() = OFF' & @CRLF)
			EndIf
		Else
			ConsoleWrite('! _Dump_AccidentToFile_OnOff():   WARNING: _Dump_Accident_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_AccidentToFile_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_OnExit_OnOff
; Description ...: Enable / Disable / Report the status of dumping variables in case of an program exit.
; Syntax ........: _Dump_OnExit_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
; 										- True - set the status to True (enable/ON), and returns the status of the function.
; 										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_OnExit_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_OnExit_OnOff(Default): $__fDump_RegisteredExit_OnOff = ' & $__fDump_RegisteredExit_OnOff & @CRLF)
		Return $__fDump_RegisteredExit_OnOff
	Else
		If $fSwitch Then
			OnAutoItExitRegister('_Dump_OnExit')
			$__fDump_RegisteredExit_OnOff = True
			ConsoleWrite('! _Dump_OnExit_OnOff() = ON' & @CRLF)
		Else
			OnAutoItExitUnRegister('_Dump_OnExit')
			$__fDump_RegisteredExit_OnOff = False
			ConsoleWrite('! _Dump_OnExit_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_OnExit_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_OnExitToFile_OnOff
; Description ...: Enable / Disable / Report the status of dumping variables to file in case of an program exit.
; Syntax ........: _Dump_OnExitToFile_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
; 										- True - set the status to True (enable/ON), and returns the status of the function.
; 										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_OnExitToFile_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_OnExitToFile_OnOff(Default): $__fDump_RegisteredExitToFile_OnOff = ' & $__fDump_RegisteredExitToFile_OnOff & @CRLF)
		Return $__fDump_RegisteredExitToFile_OnOff
	Else
		If $__fDump_RegisteredExit_OnOff Then
			If $fSwitch Then
				$__fDump_RegisteredExitToFile_OnOff = True
				ConsoleWrite('! _Dump_OnExitToFile_OnOff() = ON' & @CRLF)
			Else
				$__fDump_RegisteredExitToFile_OnOff = False
				ConsoleWrite('! _Dump_OnExitToFile_OnOff() = OFF' & @CRLF)
			EndIf
		Else
			ConsoleWrite('! _Dump_OnExitToFile_OnOff():  WARNING: _Dump_OnExit_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_OnExitToFile_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_OnExitDisplayAllData_OnOff
; Description ...: no yet finished, in testing
; Syntax ........: _Dump_OnExitDisplayAllData_OnOff([$fSwitch = Default])
; Parameters ....: $fSwitch             - [optional] A boolean value. Default is Default and it returns the status of the function.
; 										- True - set the status to True (enable/ON), and returns the status of the function.
; 										- False - set the status to False (disable/OFF), and returns the status of the function.
; Return values .: status of the function (True or False)
; Author ........: mlipok
; Modified ......:
; Remarks .......: no yet finished, in testing
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_OnExitDisplayAllData_OnOff($fSwitch = Default)
	If $fSwitch = Default Then
		ConsoleWrite('! _Dump_OnExitDisplayAllData_OnOff(Default): $__fDump_RegisteredExitDisplay_all_data = ' & $__fDump_RegisteredExitDisplay_all_data & @CRLF)
		Return $__fDump_RegisteredExitDisplay_all_data
	Else
		If $__fDump_RegisteredExit_OnOff Then
			If $fSwitch Then
				$__fDump_RegisteredExitDisplay_all_data = True
				ConsoleWrite('! _Dump_OnExitDisplayAllData_OnOff() = ON' & @CRLF)
			Else
				$__fDump_RegisteredExitDisplay_all_data = False
				ConsoleWrite('! _Dump_OnExitDisplayAllData_OnOff() = OFF' & @CRLF)
			EndIf
		Else
			ConsoleWrite('! _Dump_OnExitDisplayAllData_OnOff():  WARNING: _Dump_OnExit_OnOff() = OFF' & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Dump_OnExitDisplayAllData_OnOff

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_OnExit
; Description ...: this function is used in _Dump_OnExit_OnOff as a parameter for OnAutoItExitRegister
; Syntax ........: _Dump_OnExit()
; Parameters ....:
; Return values .: None
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......: _Dump_OnExit_OnOff()
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_OnExit()
	Local $sDump_Data = _Dump_GetVariablesValue()
	Local $sDump_DataToFile = ''
	MsgBox(4096, '_Dump_OnExit', $sDump_Data)
	If $__fDump_RegisteredExitToFile_OnOff Or $__fDump_AlwaysToFile_OnOff Then
		$sDump_DataToFile &= @CRLF & @CRLF
		$sDump_DataToFile &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====_Dump_OnExit()=====' & @CRLF
		$sDump_DataToFile &= $sDump_Data & @CRLF
		$sDump_DataToFile &= '=====_Dump_OnExit()=====END=====' & @CRLF
		FileWriteLine($__hDump_LogFile, $sDump_DataToFile)
	EndIf
;~ 	If $__fDump_RegisteredExitDisplay_all_data Then
;~ 		_ArrayDisplay($array, '$array')
;~ 	EndIf
EndFunc   ;==>_Dump_OnExit

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_ToMsgBox
; Description ...: Dump actual data from _Dump_GetVariablesValue()  to MsgBox.
; Syntax ........: _Dump_ToMsgBox([$sTitle = ''])
; Parameters ....: $sTitle              - [optional] A string value. Default is ''. Additional description of, useful for analysis.
; Return values .: None
; Author ........: mlipok
; Modified ......:
; Remarks .......: You can use this whenever you want without having any unplanned event.
; Related .......: _Dump_GetVariablesValue(),
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_ToMsgBox($sTitle = '')
	Local $sDump_Data = _Dump_GetVariablesValue()
	If $__fDump_AlwaysToFile_OnOff Then FileWriteLine($__hDump_LogFile, $sDump_Data)
	MsgBox(4096, '_Dump_ToMsgBox(): ' & $sTitle, $sDump_Data)
EndFunc   ;==>_Dump_ToMsgBox

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_ToConsole
; Description ...: Dump actual data from _Dump_GetVariablesValue()  to SciTe Console.
; Syntax ........: _Dump_ToConsole([$sTitle = ''])
; Parameters ....: $sTitle              - [optional] A string value. Default is ''. Additional description of, useful for analysis.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: You can use this whenever you want without having any unplanned event.
; Related .......: _Dump_GetVariablesValue(),
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_ToConsole($sTitle = '')
	Local $sDump_Data = _Dump_GetVariablesValue()
	Local $sDump_DataToConsole = ''
	$sDump_DataToConsole &= @CRLF & @CRLF
	If $sTitle = '' Then
		$sDump_DataToConsole &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====_Dump_ToConsole()=====' & @CRLF
		$sDump_DataToConsole &= $sDump_Data & @CRLF
		$sDump_DataToConsole &= '=====_Dump_ToConsole()=====End=====' & @CRLF
	Else
		$sDump_DataToConsole &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====_Dump_ToConsole()=====' & $sTitle & '=====' & @CRLF
		$sDump_DataToConsole &= $sDump_Data & @CRLF
		$sDump_DataToConsole &= '=====_Dump_ToConsole()=====End=====' & $sTitle & '=====' & @CRLF
	EndIf
	If $__fDump_AlwaysToFile_OnOff Then FileWriteLine($__hDump_LogFile, $sDump_DataToConsole)
	ConsoleWrite($sDump_DataToConsole)
EndFunc   ;==>_Dump_ToConsole

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_ToFile
; Description ...: Dump actual data from _Dump_GetVariablesValue()  to file.
; Syntax ........: _Dump_ToFile($sTitle)
; Parameters ....: $sTitle              - [optional] A string value. Default is ''. Additional description of, useful for analysis.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: You can use this whenever you want without having any unplanned event.
; Related .......: _Dump_GetVariablesValue(), _Dump_ChangeLogFile()
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Dump_ToFile($sTitle = '')
	Local $sDump_Data = _Dump_GetVariablesValue()
	Local $sDump_DataToFile = ''
	$sDump_DataToFile &= @CRLF & @CRLF
	If $sTitle = '' Then
		$sDump_DataToFile &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====_Dump_ToFile()=====' & @CRLF
		$sDump_DataToFile &= $sDump_Data & @CRLF
		$sDump_DataToFile &= '=====_Dump_ToFile()=====End=====' & @CRLF
	Else
		$sDump_DataToFile &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====_Dump_ToFile()=====' & $sTitle & '=====' & @CRLF
		$sDump_DataToFile &= $sDump_Data & @CRLF
		$sDump_DataToFile &= '=====_Dump_ToFile()=====End=====' & $sTitle & '=====' & @CRLF
	EndIf
	FileWriteLine($__hDump_LogFile, $sDump_DataToFile)
EndFunc   ;==>_Dump_ToFile

; #FUNCTION# ====================================================================================================================
; Name ..........: _Dump_GetVariablesValue
; Description ...: parse $_sGlobalVariableList and get values Type and Values for variables listed in this String.
; Syntax ........: _Dump_GetVariablesValue()
; Parameters ....:
; Return values .: String containing the Type Name and Value of global variables, and list of last used function.
; Author ........: Mhz
; Modified ......: mlipok
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/22625-output-global-variables-on-exit/
; Example .......: No
; ===============================================================================================================================
Func _Dump_GetVariablesValue()
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
	If IsArray($__aDump_FuncNames) Then
		$__string &= '============================' & @CRLF & 'Functions:' & @CRLF & _ArrayToString($__aDump_FuncNames, @CRLF)
	Else
		$__string &= '============================' & @CRLF & 'Functions:' & @CRLF & '........' & @CRLF
	EndIf

	Return $__string
EndFunc   ;==>_Dump_GetVariablesValue

; #FUNCTION# ====================================================================================================================
; Name ..........: Intercept_MessageBoxW
; Description ...:
; Syntax ........: Intercept_MessageBoxW($hwnd, $sText, $sTitle, $iType)
; Parameters ....: $hwnd                - A handle value.
;                  $sText               - A string value.
;                  $sTitle              - A string value.
;                  $iType               - An integer value.
; Return values .:
; Author ........: trancexx
; Modified ......: mlipok
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
; Example .......: No
; ===============================================================================================================================
Func Intercept_MessageBoxW($hwnd, $sText, $sTitle, $iType)
	Local $sDump_Data = _Dump_GetVariablesValue()
	Local $sDump_DataToFile = ''
	If _
			StringInStr($sText, @ScriptFullPath) <> 0 And _
			StringInStr($sText, 'Error:') <> 0 And _
			StringInStr($sTitle, 'AutoIt Error') <> 0 _
			Then

		If $__fDump_AccidentToFile_OnOff Or $__fDump_AlwaysToFile_OnOff Then
			$sDump_DataToFile &= @CRLF & @CRLF
			$sDump_DataToFile &= '=====' & @YEAR & '-' & @MON & '-' & @MDAY & '__' & @HOUR & '-' & @MIN & '=====Accident INTERCEPTED=====' & @CRLF
			$sDump_DataToFile &= $sDump_Data & @CRLF
			$sDump_DataToFile &= '=====Accident INTERCEPTED=====END=====' & @CRLF
			FileWriteLine($__hDump_LogFile, $sDump_DataToFile)
		EndIf
		$sText &= @CRLF & @CRLF & $sDump_Data
	EndIf
	Local $aCall = DllCall("user32.dll", "int", "MessageBoxW", _
			"hwnd", $hwnd, _
			"wstr", $sText, _
			"wstr", $sTitle, _
			"uint", $iType)
	If @error Or Not $aCall[0] Then Return 0
	Return $aCall[0]
EndFunc   ;==>Intercept_MessageBoxW

; #FUNCTION# ====================================================================================================================
; Name ..........: AddHookApi
; Description ...:
; Syntax ........: AddHookApi($sModuleName, $vFunctionName, $vNewFunction[, $sRet = ""[, $sParams = ""]])
; Parameters ....: $sModuleName         - A string value.
;                  $vFunctionName       - A variant value.
;                  $vNewFunction        - A variant value.
;                  $sRet                - [optional] A string value. Default is "".
;                  $sParams             - [optional] A string value. Default is "".
; Return values .:
; Author ........: trancexx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
; Example .......: No
; ===============================================================================================================================
Func AddHookApi($sModuleName, $vFunctionName, $vNewFunction, $sRet = "", $sParams = "")
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

; #FUNCTION# ====================================================================================================================
; Name ..........: VirtualProtect
; Description ...:
; Syntax ........: VirtualProtect($pAddress, $iSize, $iProtection)
; Parameters ....: $pAddress            - A pointer value.
;                  $iSize               - An integer value.
;                  $iProtection         - An integer value.
; Return values .:
; Author ........: trancexx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
; Example .......: No
; ===============================================================================================================================
Func VirtualProtect($pAddress, $iSize, $iProtection)
	Local $aCall = DllCall("kernel32.dll", "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>VirtualProtect

; #FUNCTION# ====================================================================================================================
; Name ..........: ImageDirectoryEntryToData
; Description ...:
; Syntax ........: ImageDirectoryEntryToData($hInstance, $iDirectoryEntry)
; Parameters ....: $hInstance           - A handle value.
;                  $iDirectoryEntry     - An integer value.
; Return values .:
; Author ........: trancexx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/154081-avoid-autoit-error-message-box-in-unknown-errors/
; Example .......: No
; ===============================================================================================================================
Func ImageDirectoryEntryToData($hInstance, $iDirectoryEntry)
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
;~ 	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
;~ 			"word NumberOfSections;" & _
;~ 			"dword TimeDateStamp;" & _
;~ 			"dword PointerToSymbolTable;" & _
;~ 			"dword NumberOfSymbols;" & _
;~ 			"word SizeOfOptionalHeader;" & _
;~ 			"word Characteristics", _
;~ 			$pPointer)
	; Get number of sections
;~ 	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	; Determine the type
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
;~ 	Local $tIMAGE_OPTIONAL_HEADER
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

; #FUNCTION# ====================================================================================================================
; Name ..........: _Func_Start
; Description ...:
; Syntax ........: _Func_Start($sFuncName)
; Parameters ....: $sFuncName           - A string value.
; Return values .: None
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Func_Start($sFuncName)
	_ArrayPush($__aDump_FuncNames, '_Func_Start: ' & $sFuncName)
EndFunc   ;==>_Func_Start

; #FUNCTION# ====================================================================================================================
; Name ..........: _Func_End
; Description ...:
; Syntax ........: _Func_End($sFuncName)
; Parameters ....: $sFuncName           - A string value.
; Return values .: None
; Author ........: mlipok
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Func_End($sFuncName)
	_ArrayPush($__aDump_FuncNames, '_Func_End: ' & $sFuncName)
EndFunc   ;==>_Func_End
