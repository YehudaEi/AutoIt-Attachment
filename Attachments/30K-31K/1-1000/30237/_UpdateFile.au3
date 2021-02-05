#include <File.au3>
#include <Constants.au3>

; #FUNCTION# ;===============================================================================
;
; Name...........: _FileUpdate
; Description ...: Updates a local file with a newer one found on the internet
; Parameters ....: $sOld_File_Path - Local path of the old file "C:\Program Files\Company\OldFile.exe"
;                  $sNew_File_Web_Path - Internet address for the new file "http://www.somesite.com/files/NewFile.exe"
; Return values .: Success - 1
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - Invalid $sOld_File_Path
;                  |2 - Invalid $sNew_File_Web_Path
;				   |3 - Could not create .BAT file
;				   |4 - Could not write to .BAT file
;				   |5 - Could not run .BAT file
; Author ........: John Fedorchak
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _FileUpdate($sOld_File_Path, $sNew_File_Web_Path)
	Local $iIsValidPath, $hDownloadFile, $hBAT, $iFileWrite
	Local $sDrive, $sDirectory, $sName, $sExtention

	;Check if local file exists
	$iIsValidPath = FileExists($sOld_File_Path)
	If $iIsValidPath = 0 Then Return SetError(1)

	;Check if web file exists
	$iIsValidPath = InetGetSize($sNew_File_Web_Path, 1)
	If $iIsValidPath = 0 Then Return SetError(2)

	;Download File
	_PathSplit($sNew_File_Web_Path, $sDrive, $sDirectory, $sName, $sExtention)
	$hDownloadFile = InetGet($sNew_File_Web_Path, @TempDir & "\Temporary Update File" & $sExtention, 1)

	;Create .BAT file
	$hBAT = FileOpen(@TempDir & "\Update.bat", 1)
	If $hBAT = -1 Then Return SetError(3)

	;Write to .BAT file
	$iFileWrite = FileWrite($hBAT, 'DEL "' & $sOld_File_Path & '"' & @CRLF & _ ;DEL OldFile
								   'COPY "' & @TempDir & '\Temporary Update File' & $sExtention & '" "' & $sOld_File_Path & '"') ;COPY NewFile OldFilePath
	If $iFileWrite = 0 Then Return SetError(4)

	;Close .BAT writing
	FileClose($hBAT)

	;Run .BAT file
	$hExecute = Run(@TempDir & "\Update.bat", @TempDir, @SW_HIDE, $STDOUT_CHILD)
	If $hExecute = 0 Then Return SetError(5)

	;Finished
	Return SetError(0)
EndFunc
