
#include "ChooseFileFolder_NoFrame.au3"

Local $sRet, $aRet
Local $sProgFiles = @ProgramFilesDir
If @AutoItX64 Then $sProgFiles &= " (x86)"

; Pick a single *.au3 file from within the AutoIt installation folders
; Use the "Select" button - only files can be selected
$sRet = _CFF_Choose("Ex 1: Choose a file - Select button only", 300, 500, -1, -1, $sProgFiles & "\AutoIt3", "*.au3")
If $sRet Then
	MsgBox(64, "Ex 1", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 1", "No Selection")
EndIf

; Enable double click to select from TreeView
$sRet = _CFF_RegMsg()
If $sret Then
	MsgBox(64, "Success!", "Selections now available with double clicks")
Else
	MsgBox(64, "Failure!", "Selections only available with 'Select' Button")
EndIf

; Pick a single *.au3 or *.ico file from within the AutoIt installation folders
; Use either the "Select" button or a double click - only files can be selected
$sRet = _CFF_Choose("Ex 2: Choose a file", 300, 500, -1, -1, $sProgFiles & "\AutoIt3", "*.au3;*.ico")
If $sRet Then
	MsgBox(64, "Ex 2", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 2", "No Selection")
EndIf

; Create a pre-existing array of the AutoIt installation folders and load it as default to increase loading speed
$sRet = _CFF_IndexDefault($sProgFiles & "\AutoIt3")

; Pick a single folder within the default folder tree as set by _CFF_SetDefault
; Use either the "Select" button or a double click - no files are displayed
Global $sRet = _CFF_Choose("Ex 3: Select a folder", 300, 500, -1, -1, Default, "", 2)
If $sRet Then
	MsgBox(64, "Ex 3", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 3", "No Selection")
EndIf

; Pick a multiple *.au3 or *.ico files from within the default folder tree as set by _CFF_SetDefault
; Use either the "Add" button or a double click to add to the list - only files can be added
; Press "Return" button when selection ended to get "|" delimited string of selected files
$sRet = _CFF_Choose("Ex 4: Select multiple files", 300, 500, -1, -1, Default, "*.au3;*.ico", 0, False)
If $sRet Then
	$aRet = StringSplit($sRet, "|")
	$sRet = ""
	For $i = 1 To $aRet[0]
		$sRet &= $aRet[$i] & @CRLF
	Next
	MsgBox(64, "Ex 6", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 4", "No Selection")
EndIf

; Clear any default arrays
_CFF_ClearDefault()

; Pick any file on any drive
; WARNING - indexing large drives can take a considerable time - you have been warned!!!!
$sRet = _CFF_Choose("Ex 5: Select a file", 300, 500, -1, -1)
If $sRet Then
	MsgBox(64, "Ex 5", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 5", "No Selection")
EndIf

; Pick multiple files from any drive
; Use either the "Add" button or a double click to add to the list - only files can be added
; WARNING - indexing large drives can take a considerable time - you have been warned!!!!
; Press "Return" button when selection ended to get "|" delimited string of selected files
$sRet = _CFF_Choose("Ex 6: Select multiple files", 300, 500, -1, -1, "", Default, 0, False)
If $sRet Then
	$aRet = StringSplit($sRet, "|")
	$sRet = ""
	For $i = 1 To $aRet[0]
		$sRet &= $aRet[$i] & @CRLF
	Next
	MsgBox(64, "Ex 6", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 6", "No Selection")
EndIf

; Choose a single file from a specified folder - no subfolders displayed
$sRet = _CFF_Choose("Ex 7: Select a file", 300, 500, -1, -1, $sProgFiles & "\AutoIt3", "*.*", 1)
If $sRet Then
	MsgBox(64, "Ex 7", "Selected:" & @CRLF & @CRLF & $sRet)
Else
	MsgBox(64, "Ex 7", "No Selection")
EndIf


