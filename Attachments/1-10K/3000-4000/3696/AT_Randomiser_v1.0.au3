; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
$ProgramName = StringLeft(@ScriptName, StringLen(@ScriptName) - 4)
$Filename = "Autotravel Mover*.exe"

;Find if $Filename file exists (FindFirstMatchingFile will return the first matching filename
;in the variable $Filename
$Result = FindFirstMatchingFile($Filename)
If $Result = 0 Then ; File does not exist
	MsgBox(48, $ProgramName, "The compiled Autotravel Move file was not found. Make sure that the Autotravel Move script is compiled.")
	Exit
Else ; File exists
	;Create new filename
	$ExeTempFile = CreateTempFile(@ScriptDir, "exe")
	;Copy the file to the new name
	FileCopy($Filename, $ExeTempFile)
	;Run the program
	Run($ExeTempFile)
EndIf

Func CreateTempFile($sDestinationFolder, $sExtension = "tmp", $sPrefix = "", $sSuffix = "")
	Local $sTempFile = ""
	Do
		; Define the temp file length
		$iFileLength = Random(6, 12, 1)
		; Create filename
		For $iIndex = 1 To $iFileLength
			; Get a random char A-Z
			$iRndAsciiChar = Random(65, 90, 1)
			; Add char to end of the string
			$sTempFile = $sTempFile & Chr($iRndAsciiChar)
		Next
		; Create the full file name
		$sTempFile = $sPrefix & $sTempFile & $sSuffix & "." & $sExtension
	Until (Not FileExists($sDestinationFolder & "\" & $sTempFile)) ; Repeat until a unique filename is created
	; Return the filename
	Return $sTempFile
EndFunc   ;==>CreateTempFile

Func FindFirstMatchingFile(ByRef $value)
	; This function finds the first matching filename and returns
	; it in the $value argument.
	
	; Find all filenames in the current folder starting with 'Gaim'.
	$search = FileFindFirstFile($value)
	
	; Check if the search was successful
	If $search = -1 Then
		Return 0
	EndIf
	
	;Go through found files
	While 1
		$file = FileFindNextFile($search)
		If @error Then
			Return 0
		Else
			$value = $file
			Return 1
		EndIf
	WEnd
	
	; Close the search handle
	FileClose($search)
EndFunc   ;==>FindFirstMatchingFile
