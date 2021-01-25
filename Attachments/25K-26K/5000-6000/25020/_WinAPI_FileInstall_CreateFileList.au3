#include <WinAPI_Ex.au3>

; #FUNCTION# ;=================================================================================================================================================
;
; Name...........: _WinAPI_FileInstall_CreateFileList
; Description ...: List Install file(s) from a folder into au3
; Syntax.........: _WinAPI_FileInstall_CreateFileList($sSource, $sDest, $nFlag = 0, $sMask = '*', $sName = 'include', $sOverWrite = False, $sCompiled = False)
; Parameters ....: $sSource	= Source folder to get file(s) from
;                  $sDest	= Destination to install file(s) to
;                  $nFlag	= According to the flag of FileInstall	[Optional]
;				   $sMask	= Extensions of file(s) to List			[Optional]
;				   $sName	= Out au3 script name					[Optional]
;                  $sCompiled - One of the following:				[Optional]
;                  False = Always install file(s)
;                  True = Only install file(s) when the script is compiled
; Return values .: Success - Returns 1
;                  Failure - Returns 0
; Author ........: FireFox
; Modified.......: 
; Remarks .......: WinAPI mode
; Related .......: _FileInstall_CreateFileList
; Link ..........;
; Example .......;
;
; ;============================================================================================================================================================
Func _WinAPI_FileInstall_CreateFileList($sSource, $sDest, $nFlag = 0, $sMask = '*', $sName = 'include', $sOverWrite = False, $sCompiled = False)
	Local $hSearch, $sRet_FI_Lines = ''
	Local $hFile, $s_String, $iWritten = 0, $pBuffer, $vDLL
	
	If (Not $sCompiled) Or ($sCompiled And @Compiled) Then
		$vDLL = DllOpen('Kernel32.dll')
		$hSearch = _WinAPI_FileFindFirstFile($sSource & '\' & $sMask, $vDLL)
		If $hSearch[0] <> '.' Then Return SetError(1, 0, 0)
		
		While 1
			$sNext_File = _WinAPI_FileFindNextFile($hSearch, $vDLL)
			If ($hSearch[0] <> '..') Then
				$sRet_FI_Lines &= @CRLF & _
						'FileInstall("' & $sSource & '\' & $sNext_File & '", "' & $sDest & '\' & $sNext_File & '", ' & $nFlag & ')'
			EndIf
		WEnd
		_WinAPI_FileFindClose($hSearch, $vDLL)
		DllClose($vDLL)
		
		If $sRet_FI_Lines = '' Then Return SetError(2, 0, 0)
		If $sOverWrite Then FileDelete(@ScriptDir & '\' & $sName & '.au3')
		$hFile = _WinAPI_CreateFile(@ScriptDir & '\' & $sName & '.au3', 1)
		$s_String = StringStripWS($sRet_FI_Lines, 3)
		
		$pBuffer = DllStructCreate('char[' & StringLen($s_String) + 1 & ']')
		DllStructSetData($pBuffer, 1, $s_String)
		_WinAPI_WriteFile($hFile, DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer) - 1, $iWritten)
		Return _WinAPI_CloseHandle($hFile)
	EndIf
	
	Return SetError(3, 0, 0)
EndFunc   ;==>_WinAPI_FileInstall_CreateFileList