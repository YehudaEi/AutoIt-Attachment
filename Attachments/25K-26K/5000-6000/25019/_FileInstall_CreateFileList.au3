; #FUNCTION# ;============================================================================================================================================
;
; Name...........: _FileInstall_CreateFileList
; Description ...: List Install file(s) from a folder into au3
; Syntax.........: _FileInstall_CreateFileList($sSource, $sDest, $nFlag = 0, $sMask = '*', $sName = 'include', $sOverWrite = False, $sCompiled = False)
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
; Author ........: MrCreator, FireFox
; Modified.......: FireFox
; Remarks .......: 
; Related .......: _WinAPI_FileInstall_CreateFileList
; Link ..........;
; Example .......;
;
; ;=======================================================================================================================================================
Func _FileInstall_CreateFileList($sSource, $sDest, $nFlag = 0, $sMask = '*', $sName = 'include', $sOverWrite = False, $sCompiled = False)
	Local $hSearch, $sNext_File, $sRet_FI_Lines = ''
	
	If (Not $sCompiled) Or ($sCompiled And @Compiled) Then
		$hSearch = FileFindFirstFile($sSource & '\' & $sMask)
		If $hSearch = -1 Then Return SetError(1, 0, 'FileFindFirstFile')
		
		While 1
			$sNext_File = FileFindNextFile($hSearch)
			If @error Then ExitLoop ;No more files
			$sRet_FI_Lines &= @CRLF & _
					'FileInstall("' & $sSource & '\' & $sNext_File & '", "' & $sDest & '\' & $sNext_File & '", ' & $nFlag & ')'
		WEnd
		FileClose($hSearch)
		If $sRet_FI_Lines = '' Then Return SetError(2, 0, '')
		If $sOverWrite Then FileDelete(@ScriptDir & '\' & $sName & '.au3')
		Return FileWrite(@ScriptDir & '\' & $sName & '.au3', StringStripWS($sRet_FI_Lines, 3))
	EndIf
	
	Return 0
EndFunc   ;==>_FileInstall_CreateFileList