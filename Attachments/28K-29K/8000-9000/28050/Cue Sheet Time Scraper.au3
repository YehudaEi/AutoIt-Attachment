; =======================================================================================================================
;
;	AutoIt Version: 3.3.0.0
;	Author:         dm83737
;	Date:			09-25-2009
;
;	Script Function:
;		Pulls information from CUE sheet and places in an Excel file according to a specific layout
;
; =======================================================================================================================

; =======================================================================================================================
; --- INCLUDES, OPTIONS & VARIABLES -------------------------------------------------------------------------------------

#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include <ExcelCOM_UDF.au3>

Opt("WinTitleMatchMode", 2)

; =======================================================================================================================

; =======================================================================================================================
; --- READ CUE ----------------------------------------------------------------------------------------------------------

$sCuePath = FileOpenDialog("Please choose .cue file", "C:\" & "\", "Cue Sheet (*.cue)", 1 + 2)

If @error Then
	MsgBox(4096, "", "No File(s) chosen")
	Exit
EndIf

$tCue = FileRead($sCuePath)
$tCueText = StringReplace($tCue, '"', "")

$aCueArtists = _StringBetween($tCueText, 'PERFORMER ', @CR)

$aCueTracks = _StringBetween($tCueText, 'TITLE ', @CR)

$aCueTime1 = _StringBetween($tCueText, 'INDEX 01 ', @CR)
_ArrayDisplay($aCueTime1, "CueTime1")


Local $aCueTime2[80][3] ; <-- Set to '80' because there could be any number of tracks in the file

For $i = 0 To UBound($aCueTime1) - 1
	$aCueTemp = StringSplit($aCueTime1[$i], ":")
    For $j = 0 To 2
        $aCueTime2[$i][$j] = $aCueTemp[$j + 1]
    Next
Next

_ArrayDisplay($aCueTime2)



; --- REMOVE BLANK ROWS FROM ARRAY --------------------------------------------------------------------------------------



; --- PLACE RESULTS IN EXCEL --------------------------------------------------------------------------------------------
;~ $oCueXLS = _ExcelBookNew()
;~ _ExcelSheetActivate ($oCueXLS, 1)
;~ _ExcelSheetDelete($oCueXLS, 3)
;~ _ExcelSheetDelete($oCueXLS, 2)



; =======================================================================================================================

; =======================================================================================================================
; --- EXIT --------------------------------------------------------------------------------------------------------------


;~ _ExcelBookClose($oCueXLS, 1, 0)

;~ FileClose($oCue)

Exit
