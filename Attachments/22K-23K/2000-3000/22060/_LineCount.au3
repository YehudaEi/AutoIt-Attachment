#include <File.au3>

MsgBox(0, "Number of lines - null", "LineCount - " & LineCount("null") & @LF & "_FileCountLines - " & _FileCountLines("null") & @LF & "_FileCountLinesMrCreatoR - " & _FileCountLinesMrCreatoR("null") & @LF & "_FileCountLinesX - " & _FileCountLinesX("null"));
MsgBox(0, "Number of lines - zero.txt", "LineCount - " & LineCount("zero.txt") & @LF & "_FileCountLines - " & _FileCountLines("zero.txt") & @LF & "_FileCountLinesMrCreatoR - " & _FileCountLinesMrCreatoR("zero.txt") & @LF & "_FileCountLinesX - " & _FileCountLinesX("zero.txt"));
MsgBox(0, "Number of lines - test.txt", "LineCount - " & LineCount("test.txt") & @LF & "_FileCountLines - " & _FileCountLines("test.txt") & @LF & "_FileCountLinesMrCreatoR - " & _FileCountLinesMrCreatoR("test.txt") & @LF & "_FileCountLinesX - " & _FileCountLinesX("test.txt"));
MsgBox(0, "Number of lines - trailing.txt", "LineCount - " & LineCount("trailing.txt") & @LF & "_FileCountLines - " & _FileCountLines("trailing.txt") & @LF & "_FileCountLinesMrCreatoR - " & _FileCountLinesMrCreatoR("trailing.txt") & @LF & "_FileCountLinesX - " & _FileCountLinesX("trailing.txt"));

; #FUNCTION# ====================================================================================================================
; Name...........: _FileCountLines
; Description ...: Returns the number of lines in the specified file.
; Syntax.........: _FileCountLines($sFilePath)
; Parameters ....: $sFilePath - Path and filename of the file to be read
; Return values .: Success - Returns number of lines in the file.
;                  Failure - Returns a 0
;                  @Error  - 0 = No error.
;                  |1 = File cannot be opened or found.
;                  |2 = Unable to Split the file
; Author ........: Tylo <tylo at start dot no>
; Modified.......: Xenobiologist
; Remarks .......: It does not count a final @LF as a line.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _FileCountLinesX($sFilePath)
	Local $hFile, $sFileContent, $aTmp
	$hFile = FileOpen($sFilePath, 0)
	If $hFile = -1 Then Return SetError(1, 0, 0)
	$sFileContent = StringStripWS(FileRead($hFile, FileGetSize($sFilePath)), 2)
	FileClose($hFile)
	If StringInStr($sFileContent, @LF) Then
		$aTmp = StringSplit(StringStripCR($sFileContent), @LF)
	ElseIf StringInStr($sFileContent, @CR) Then
		$aTmp = StringSplit($sFileContent, @CR)
	Else
		Return SetError(2, 0, 0)
	EndIf
	Return $aTmp[0]
EndFunc   ;==>__FileCountLines

Func _FileCountLinesMrCreatoR($sFilePath)

		; Copyright MrCreatoR
		; This function has been created by MrCreatoR
		; http://www.autoitscript.com/forum/index.php?showtopic=79656&view=findpost&p=574317
		
    Local $sFRead = FileRead($sFilePath)
    Local $iCountLines = 0
   
    $sFRead = StringReplace($sFRead, @CRLF, "")
    $iCountLines += @extended
   
    $sFRead = StringReplace($sFRead, @CR, "")
    $iCountLines += @extended
   
    StringReplace($sFRead, @LF, "")
    $iCountLines += @extended
   
    Return $iCountLines + 1
EndFunc

Func LineCount($sFilePath)

	Local $N = FileGetSize($sFilePath)

	If @error Or 0 == $N Then Return 0

	Return CharCountPlus1(FileRead($sFilePath, $N), @LF);
EndFunc   ; //LineCount

#cs
	Find all occurences of LF.
	If last two bytes are not CR/LF, return the above count incremented by 1
#ce

Func CharCountPlus1($inputString, $matchString)

	Local $count = 1

	While 0 <> StringInStr($inputString, $matchString, 2, $count)

		$count += 1;
	WEnd
	
	If 0 == StringInStr(StringRight($inputString, 3), $matchString, 2) Then
	
		$count += 1;
	EndIf
	
	return $count;

EndFunc