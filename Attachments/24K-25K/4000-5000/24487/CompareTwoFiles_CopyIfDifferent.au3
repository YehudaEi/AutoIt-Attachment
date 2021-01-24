;===============================================================================
; Author(s):        Roger Osborne 
; Version:               1.0.0
; AutoItVer:          3.0.+
; Created               2009-2-8
;
; Description:      Function to compare two files. If they are different (in size or date & time), the 
;					file will be copied from the $SourceLocation to the $DestinationLocation, with optional
;					error reporting (if source file doesn't exist).
;
; Syntax:           _CompareTwoFiles_CopyIfDifferent($SourceLocation, $DestinationLocation, $filename, $reporterror)
;
; Parameter(s):         $SourceLocation = the source location of the file you want to compare
;						$DestinationLocation = the destination location of the file you want to compare
;                       $filename = the name of the file to compare
;						$reporterror = if you enter "yes" for this variable, a message will display if the 
;									   file does not exist; otherwise, no error will be displayed
;
; Requirement(s):   None
;
; Example:                _CompareTwoFiles_CopyIfDifferent(@HomeDrive & "\", "D:\Batch\", "Autoexec.bat", "yes")
;
;===============================================================================

;Func _CompareTwoFiles_CopyIfDifferent($SourceLocation, $DestinationLocation, $filename, $reporterror)

Func _CompareTwoFiles_CopyIfDifferent($SourceLocation, $DestinationLocation, $filename, $reporterror)
	
	;If $reporterror = "yes", then we will display message if the source file does not exist
	If $reporterror = "yes" Then
		If Not FileExists($SourceLocation & $filename) Then MsgBox(16,"File Not Found","Source file does not exist",3)
	EndIf
	
	;First, we'll check for differences in file size; if they are different, the file will be copied from the $SourceLocation to the $DestinationLocation
	$SourceSize = FileGetSize($SourceLocation & $filename)
	$DestinationSize = FileGetSize($DestinationLocation & $filename)

		If $SourceSize <> $DestinationSize Then
			;MsgBox(0,"File Info","File sizes are different")
			FileCopy($SourceLocation & $filename, $DestinationLocation, 9);If file size is different, copy (folder will be created if it doesn't exist).
		Else
			;This section will only process if the file sizes are identical
			;Next, we'll check for differences in times; if they are different, the file will be copied from the $SourceLocation to the $DestinationLocation
			$SourceDate = FileGetTime($SourceLocation & $filename,0,1)
			$DestinationDate = FileGetTime($DestinationLocation & $filename,0,1)
				If $SourceDate <> $DestinationDate Then
				;MsgBox(0,"File Info","Times are different")
				FileCopy($SourceLocation & $filename, $DestinationLocation, 9);If last modified date is different, copy (folder will be created if it doesn't exist).
				EndIf
		EndIf
EndFunc
