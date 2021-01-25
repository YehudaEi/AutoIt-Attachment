#include-once

; ===================================================================================================
; variable structure to cut down on DLLStruct creation
; ===================================================================================================
Local $_st_INT_FileFindInfo, $_i_INT_FileFindHandleCount = 0

; ===================================================================================================
; Func _WinAPI_FileFindFirstFile($sSearchString,$DLL=-1)
;
; $sSearchString = pathname + filesearch parameters (ex: C:\windows\system32\*.dll)
;
; Returns:
;   Success: an array containing the 1st find and file handle. (see below for Array format)
;   Failure: -1 with @error set:
;      @error = 1 = invalid parameter
;      @error = 2 = path length to big
;      @error = 3 = DLL call fail
;
; Format of array passed (on success) [1st 4 will be programmer's concern, date/time is accessed an easier way]
;   $array[0] = File Name
;   $array[1] = File-Find Handle [Internal Use]
;
; Author: Ascend4nt
; ===================================================================================================
Func _WinAPI_FileFindFirstFile($sSearchString, $DLL = -1)
	If Not IsString($sSearchString) Then Return SetError(1, 0, -1)
	Local $aRet, $iSearchLen = StringLen($sSearchString)
	
	If $iSearchLen > 259 Then
		If $iSearchLen > (32766 - 4) Then Return SetError(2, 0, -1)
		$sSearchString = '\\?\' & $sSearchString
	EndIf
	
	Local $stPathStruct = DllStructCreate('wchar[' & ($iSearchLen + 1) & ']')
	DllStructSetData($stPathStruct, 1, $sSearchString)
	
	If Not $_i_INT_FileFindHandleCount Then _
			$_st_INT_FileFindInfo = DllStructCreate('dword;dword[2];dword[2];dword[2];dword;dword;dword;dword;wchar[260];wchar[14]')
	
	If $DLL == -1 Then $DLL = 'Kernel32.dll'
	
	$aRet = DllCall($DLL, 'ptr', 'FindFirstFileW', 'ptr', DllStructGetPtr($stPathStruct), 'ptr', DllStructGetPtr($_st_INT_FileFindInfo))
	If @error Or Not IsArray($aRet) Or $aRet[0] == -1 Then Return SetError(3, 0, -1)
	$_i_INT_FileFindHandleCount += 1
	
	Local $aReturnArray[2]
	ConsoleWrite($aRet[0] & '/' & DllStructGetData($_st_INT_FileFindInfo, 9) & @CRLF)
	$aReturnArray[1] = $aRet[0]
	$aReturnArray[0] = DllStructGetData($_st_INT_FileFindInfo, 9)
	Return $aReturnArray
EndFunc   ;==>_WinAPI_FileFindFirstFile


; ===================================================================================================
; Func _WinAPI_FileFindNextFile(ByRef $aFileFindArray,$DLL=-1)
;
; $aFileFindArray = array received from a call to _WinAPI_FileFindFirstFile(). It will pull out the handle itself.
; $DLL = DLL handle or -1
;
; Returns:
;   Success: True, with the $aFileFindArray updated with the next found file information
;   Failure: False with @error set:
;      @error = 0 = last file
;      @error = 1 = invalid parameter
;      @error = 2 = DLL call failure
;
; Format of array passed (and modified on success) [1st 4 will be programmer's concern, date/time is accessed an easier way]
;   $array[0] = File Name
;   $array[1] = File-Find Handle [Internal Use]
;
; Author: Ascend4nt
; ===================================================================================================
Func _WinAPI_FileFindNextFile(ByRef $aFileFindArray, $DLL = -1)
	If Not IsArray($aFileFindArray) Or Not $_i_INT_FileFindHandleCount Then Return SetError(1, 0, False)
	If $DLL == -1 Then $DLL = 'Kernel32.dll'
	
	Local $aRet = DllCall($DLL, 'dword', 'FindNextFileW', 'ptr', $aFileFindArray[1], 'ptr', DllStructGetPtr($_st_INT_FileFindInfo))
	
	If @error Or Not IsArray($aRet) Then Return SetError(2, 0, False)
	If Not $aRet[0] Then Return False
	$aFileFindArray[0] = DllStructGetData($_st_INT_FileFindInfo, 9)
	
	Return SetError(0, 0, True)
EndFunc   ;==>_WinAPI_FileFindNextFile

; ===================================================================================================
; Func _WinAPI_FileFindClose(ByRef $aFileFindArray,$DLL=-1)
;
; Closes file handle received from _WinAPI_FileFindFirstFile()
;
; $aFileFindArray = array received from a call to _WinAPI_FileFindFirstFile(). It will pull out the handle itself.
; $DLL = DLL handle or -1
;
; Returns: True if successful (with $aFileFindArray set to -1), or False if unsuccessful @error is set to:
;   @error = 1 = invalid file handle
;   @error = 2 = DLL call failure (or return of False)
;
; Author: Ascend4nt
; ===================================================================================================
Func _WinAPI_FileFindClose(ByRef $aFileFindArray, $DLL = -1)
	If Not IsArray($aFileFindArray) Or Not $_i_INT_FileFindHandleCount Then Return SetError(1, 0, False)
	
	If $DLL == -1 Then $DLL = 'Kernel32.dll'
	Local $aRet = DllCall($DLL, 'dword', 'FindClose', 'ptr', $aFileFindArray[1])
	
	If @error Or Not IsArray($aRet) Or Not $aRet[0] Then Return SetError(2, 0, False)
	
	$aFileFindArray = -1
	$_i_INT_FileFindHandleCount -= 1
	
	If Not $_i_INT_FileFindHandleCount Then $_st_INT_FileFindInfo = 0
	
	Return True
EndFunc   ;==>_WinAPI_FileFindClose


; ===============================================================================================================================
; File Constants
; ===============================================================================================================================
Global Const $__WINAPCONSTANT_CREATE_NEW = 1
Global Const $__WINAPCONSTANT_CREATE_ALWAYS = 2
Global Const $__WINAPCONSTANT_OPEN_EXISTING = 3
Global Const $__WINAPCONSTANT_OPEN_ALWAYS = 4
Global Const $__WINAPCONSTANT_TRUNCATE_EXISTING = 5

Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY = 0x00000001
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN = 0x00000002
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM = 0x00000004
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE = 0x00000020

Global Const $__WINAPCONSTANT_FILE_SHARE_READ = 0x00000001
Global Const $__WINAPCONSTANT_FILE_SHARE_WRITE = 0x00000002
Global Const $__WINAPCONSTANT_FILE_SHARE_DELETE = 0x00000004

Global Const $__WINAPCONSTANT_GENERIC_EXECUTE = 0x20000000
Global Const $__WINAPCONSTANT_GENERIC_WRITE = 0x40000000
Global Const $__WINAPCONSTANT_GENERIC_READ = 0x80000000


; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_CreateFile
; Description ...: Creates or opens a file or other device
; Syntax.........: _WinAPI_CreateFile($sFileName, $iCreation[, $iAccess = 4[, $iShare = 0[, $iAttributes = 0[, $pSecurity = 0]]]])
; Parameters ....: $sFileName   - Name of an object to create or open
;                  $iCreation   - Action to take on files that exist and do not exist:
;                  |0 - Creates a new file. The function fails if the file exists
;                  |1 - Creates a new file. If a file exists, it is overwritten
;                  |2 - Opens a file. The function fails if the file does not exist
;                  |3 - Opens a file. If the file does not exist, the function creates the file
;                  |4 - Opens a file and truncates it so that its size is 0 bytes.  The function fails if the file does not exist.
;                  $iAccess     - Access to the object:
;                  |1 - Execute
;                  |2 - Read
;                  |4 - Write
;                  $iShare      - Sharing mode of an object:
;                  |1 - Delete
;                  |2 - Read
;                  |4 - Write
;                  $iAttributes - The file attributes:
;                  |1 - File should be archived
;                  |2 - File is hidden
;                  |4 - File is read only
;                  |8 - File is part of or used exclusively by an operating system.
;                  $pSecurity   - Pointer to a $tagSECURITY_ATTRIBUTES structure that determines if the  returned  handle  can  be
;                  +inherited by child processes. If pSecurity is 0, the handle cannot be inherited.
; Return values .: Success      - The open handle to a specified file
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: $tagSECURITY_ATTRIBUTES
; Link ..........; @@MsdnLink@@ CreateFile
; Example .......;
; ===============================================================================================================================
Func _WinAPI_CreateFile($sFileName, $iCreation, $iAccess = 4, $iShare = 0, $iAttributes = 0, $pSecurity = 0)
	Local $iDA = 0, $iSM = 0, $iCD = 0, $iFA = 0, $aResult

	If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_EXECUTE)
	If BitAND($iAccess, 2) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_READ)
	If BitAND($iAccess, 4) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_WRITE)

	If BitAND($iShare, 1) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_DELETE)
	If BitAND($iShare, 2) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_READ)
	If BitAND($iShare, 4) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_WRITE)

	Switch $iCreation
		Case 0
			$iCD = $__WINAPCONSTANT_CREATE_NEW
		Case 1
			$iCD = $__WINAPCONSTANT_CREATE_ALWAYS
		Case 2
			$iCD = $__WINAPCONSTANT_OPEN_EXISTING
		Case 3
			$iCD = $__WINAPCONSTANT_OPEN_ALWAYS
		Case 4
			$iCD = $__WINAPCONSTANT_TRUNCATE_EXISTING
	EndSwitch

	If BitAND($iAttributes, 1) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($iAttributes, 2) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN)
	If BitAND($iAttributes, 4) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY)
	If BitAND($iAttributes, 8) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM)

	$aResult = DllCall("Kernel32.dll", "hwnd", "CreateFile", "str", $sFileName, "int", $iDA, "int", $iSM, "ptr", $pSecurity, "int", $iCD, "int", $iFA, "int", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFile


; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_WriteFile
; Description ...: Writes data to a file at the position specified by the file pointer
; Syntax.........: _WinAPI_WriteFile($hFile, $pBuffer, $iToWrite, ByRef $iWritten[, $pOverlapped = 0])
; Parameters ....: $hFile       - Handle to the file to be written
;                  $pBuffer     - Pointer to the buffer containing the data to be written
;                  $iToWrite    - Number of bytes to be written to the file
;                  $iWritten    - The number of bytes written
;                  $pOverlapped - Pointer to a $tagOVERLAPPED structure
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _WinAPI_ReadFile, $tagOVERLAPPED
; Link ..........; @@MsdnLink@@ WriteFile
; Example .......;
; ===============================================================================================================================
Func _WinAPI_WriteFile($hFile, $pBuffer, $iToWrite, ByRef $iWritten, $pOverlapped = 0)
	Local $pWritten, $tWritten, $aResult

	$tWritten = DllStructCreate("int Written")
	$pWritten = DllStructGetPtr($tWritten)
	$aResult = DllCall("Kernel32.dll", "int", "WriteFile", "hwnd", $hFile, "ptr", $pBuffer, "uint", $iToWrite, "ptr", $pWritten, "ptr", $pOverlapped)
	$iWritten = DllStructGetData($tWritten, "Written")
	Return SetError(_WinAPI_GetLastError(), 0, $aResult[0] <> 0)
EndFunc   ;==>_WinAPI_WriteFile


; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_CloseHandle
; Description ...: Closes an open object handle
; Syntax.........: _WinAPI_CloseHandle($hObject)
; Parameters ....: $hObject     - Handle of object to close
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ CloseHandle
; Example .......;
; ===============================================================================================================================
Func _WinAPI_CloseHandle($hObject)
	Local $aResult

	$aResult = DllCall("Kernel32.dll", "int", "CloseHandle", "int", $hObject)
;~ 	_WinAPI_Check("_WinAPI_CloseHandle", ($aResult[0] = 0), 0, True)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_CloseHandle


; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_GetLastError
; Description ...: Returns the calling thread's lasterror code value
; Syntax.........: _WinAPI_GetLastError()
; Parameters ....:
; Return values .: Success      - Last error code
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _WinAPI_GetLastErrorMessage
; Link ..........; @@MsdnLink@@ GetLastError
; Example .......;
; ===============================================================================================================================
Func _WinAPI_GetLastError()
	Local $aResult

	$aResult = DllCall("Kernel32.dll", "int", "GetLastError")
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetLastError