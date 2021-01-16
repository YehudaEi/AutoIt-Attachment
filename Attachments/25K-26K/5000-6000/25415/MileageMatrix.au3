; Title .........: Mileage Matrix
; AutoIt Version.: 3.3.++
; Language.......: English
; Description ...: GUI Array lookup for mileages (distance)
; Author ........: G. Lewis
; ===============================================================
; Default Data file example...:Mileage.csv
;   ,Test Building 1,Test Building 2,Test Building 3
;   Test Building 1,0,2.3,4.6
;   Test Building 2,2.3,0,3.6
;   Test Building 3,4.6,3.6,0
; ===============================================================
#include <Array.au3>
#include <file.au3>
#include <GUIConstantsEx.au3>
#include <GUIComboBox.au3>

;Following Command: Default *.cvs file is embedded when compiled so only the *.exe
;is needed and not a seperate *.cvs file.
FileInstall("Mileage.csv", @TempDir & "\Mileage.csv")


If $CmdLine[0] = 0 Then ;Check for Command Line parameters, if none go here.
	$MileageCSVfile = @TempDir & "\Mileage.csv"
	$MileageCSVfileHandle = FileOpen($MileageCSVfile, 0) ; Default Filename Variable
	If FileOpen($MileageCSVfile, 0) = -1 Then
		MsgBox(0, "Failure", "Cannot find the default data file....Mileage.csv")
		Exit
	EndIf
ElseIf $CmdLine[0] > 0 Then ;Check for Command Line parameters, if some go here.
	$MileageCSVfile = $CmdLine[1] ;CommandLine Filename Variable
	FileOpen($CmdLine[1], 0)
	If FileOpen($MileageCSVfile, 0) = -1 Then
		MsgBox(0, "Failure", "Cannot find the command line specified data file...." & $CmdLine[1])
		Exit
	EndIf
EndIf

$CountLines = _FileCountLines($MileageCSVfile) ;Number of Lines (Rows)in File from above
$Line = FileReadLine($MileageCSVfile) ;The whole string in the first line to find number of Columns
$Row = StringSplit($Line, ",") ;Array of words (Schools) in $Line. $Row[0] is word count in $Line

Dim $MileArray[$CountLines + 1][$Row[0] + 1]
Dim $ComboPullDownList
Dim $StartIndex
Dim $FinishIndex
Dim $Label0Plus1
Dim $Label1Plus2
Dim $Label2Plus3
Dim $Label3Plus4
Dim $ComboMultiStart
Dim $ComboNext1
Dim $ComboNext2
Dim $ComboNext3
Dim $ComboNext4
Dim $TotalMultiMilesLabel
Global $FormMulti

For $X = 0 To $CountLines - 1 ;Loop till all the Lines (Rows[]) are read.
	$Line = FileReadLine($MileageCSVfile, $X + 1) ;Read the line.
	$Row = StringSplit($Line, ",") ;Make an array ($Row[]) with the data from $Line
	For $X2 = 0 To $Row[0] ;Loop till all the Columns (Rows[]) are read.
		$MileArray[$X][$X2] = ($Row[$X2]) ;Populate the $MileArray one cell at a time, one row at a time
	Next
Next

If $CmdLine[0] = 0 Then
	FileClose(2);Close the data file.
	FileClose(1);Close the data file.
	$a = FileDelete($MileageCSVfile) ;Delete the file in the @TempDir
EndIf

HotKeySet("!a", "ShowArray") ;Press Alt-a to display Array at anytime.

;Get list from the $MileArray first line to populate ComboBoxes
For $X = 2 To $Row[0] ;Grab the info (School Names) in Row0 starting at Column 2
	$ComboPullDownList = $ComboPullDownList & $MileArray[0][$X] & "|" ;Make a variable formated for ComboBoxs
Next

$FormSingleDest = GUICreate("Mileage Matrix Single Destination", 438, 198, 195, 117)
$ComboStart = GUICtrlCreateCombo("", 80, 20, 120, 125)
GUICtrlSetData($ComboStart, $ComboPullDownList, $MileArray[0][2]); Fill the ComboList with schools.
$ComboEnd = GUICtrlCreateCombo("", 260, 20, 120, 125)
GUICtrlSetData($ComboEnd, $ComboPullDownList, $MileArray[0][2]); Fill the ComboList with schools.
$MilesLabel = GUICtrlCreateLabel("0.0 Miles", 200, 60, 136, 17)
$LabelStart = GUICtrlCreateLabel("Starting Building", 80, 3, 76, 17)
$LabelEnd = GUICtrlCreateLabel("Ending Building", 260, 3, 73, 17)
$ButtonExit = GUICtrlCreateButton("Exit", 190, 170, 61, 21, 0)
$ButtonCopy = GUICtrlCreateButton("Copy to Clipboard", 230, 90, 95, 25)
GUICtrlSetTip($ButtonCopy, "Click to copy mileage to clipboard.","Copy to Clipboard",1,1) ;ToolTip
$ButtonRndTrip = GUICtrlCreateButton("Make Rnd Trip", 120, 90, 81, 25)
GUICtrlSetTip($ButtonRndTrip, "Click to double mileage...Make total round trip.","Round Trip",1,1) ;ToolTip
$ButtonMultiDest = GUICtrlCreateButton("Multi Destination", 170, 130, 95, 25, 0)
GUICtrlSetTip($ButtonMultiDest, "Click for multiple destinations.","Multi Destination",1,1) ;ToolTip

GUISetState(@SW_SHOW)

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($ButtonExit, "ExitButton")
GUICtrlSetOnEvent($ComboStart, "ComboStartChange")
GUICtrlSetOnEvent($ComboEnd, "ComboEndChange")
GUICtrlSetOnEvent($ButtonRndTrip, "RndTripButton")
GUICtrlSetOnEvent($ButtonCopy, "CopyButtonSingle")
GUICtrlSetOnEvent($ButtonMultiDest, "MultiDestButton")
;********************* End of Form Creation ************************************************

While 1
	Sleep(1000) ; Idle around
WEnd

;********************* Start of Functions ************************************************
Func ExitButton()
	Exit
EndFunc   ;==>ExitButton

Func CLOSEClicked()
	Exit
EndFunc   ;==>CLOSEClicked

Func ComboStartChange()
	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboStart) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboEnd) + 2
	GUICtrlSetData($MilesLabel, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles")
EndFunc   ;==>ComboStartChange

Func ComboEndChange()
	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboStart) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboEnd) + 2
	GUICtrlSetData($MilesLabel, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles")
EndFunc   ;==>ComboEndChange

Func RndTripButton()
	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboStart) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboEnd) + 2
	$RndTrp = ($MileArray[$StartIndex][$FinishIndex] * 2) ;Double the number
	$RndTrpFormat = StringFormat("%.1f", $RndTrp) ; Format with a ".0" if needed.
	GUICtrlSetData($MilesLabel, $RndTrpFormat & " Miles (Round Trip)")
EndFunc   ;==>RndTripButton

Func CopyButtonSingle()
	;Copy to the ClipBoard what's in the $MilesLabel label strip everthing but the number and copy to the clipboard.$MilesLabel
	$ClipMiles = StringFormat("%.1f", StringRegExpReplace(GUICtrlRead($MilesLabel), "([\d\.]+)|(\D)", "\1"))
	ClipPut($ClipMiles)
EndFunc   ;==>CopyButtonSingle

Func CopyButtonMulti()
	;Copy to the ClipBoard what's in the $TotalMultiMilesLabel label strip everthing but the number and copy to the clipboard.$MilesLabel
	$ClipMiles = StringFormat("%.1f", StringRegExpReplace(GUICtrlRead($TotalMultiMilesLabel), "([\d\.]+)|(\D)", "\1"))
	ClipPut($ClipMiles)
EndFunc   ;==>CopyButtonMulti

Func ShowArray()
	_ArrayDisplay($MileArray)
EndFunc   ;==>ShowArray

Func MultiDestButton()
	$StartIndex = 0
	$FinishIndex = 0
	GUISetState(@SW_HIDE, $FormSingleDest)
	#Region ### START Koda GUI section ### Form
	$FormMulti = GUICreate("Mileage Matrix Multi Destination", 427, 349, 185, 118)
	$ComboMultiStart = GUICtrlCreateCombo("", 30, 37, 120, 125)
	GUICtrlSetData($ComboMultiStart, $ComboPullDownList);,$MileArray[0][2]); Fill the ComboList with schools.
	$ComboNext1 = GUICtrlCreateCombo("", 30, 105, 120, 125)
	GUICtrlSetData($ComboNext1, $ComboPullDownList);,$MileArray[0][2]); Fill the ComboList with schools.
	$ComboNext2 = GUICtrlCreateCombo("", 30, 173, 120, 125)
	GUICtrlSetData($ComboNext2, $ComboPullDownList);,$MileArray[0][2]); Fill the ComboList with schools.
	$ComboNext3 = GUICtrlCreateCombo("", 30, 241, 120, 125)
	GUICtrlSetData($ComboNext3, $ComboPullDownList);,$MileArray[0][2]); Fill the ComboList with schools.
	$ComboNext4 = GUICtrlCreateCombo("", 30, 309, 120, 125)
	GUICtrlSetData($ComboNext4, $ComboPullDownList);,$MileArray[0][2]); Fill the ComboList with schools.

	$ButtonExit = GUICtrlCreateButton("Exit", 320, 301, 61, 21)
	$ButtonCopy = GUICtrlCreateButton("Copy to Clipboard", 300, 200, 95, 25, 0)
	GUICtrlSetTip($ButtonCopy, "Click to copy mileage to clipboard.","Copy to Clipboard",1,1) ;ToolTip

	$ButtonSingleDest = GUICtrlCreateButton("Single Destination", 300, 241, 95, 25)
	GUICtrlSetTip($ButtonSingleDest, "Click to return to Single Destination screen.","Single Destination",1,1) ;ToolTip

	$TotalMultiMilesLabel = GUICtrlCreateLabel("0.0 Total Combined Miles", 264, 163, 146, 17)
	$LabelStart = GUICtrlCreateLabel("Starting Building", 30, 20, 95, 17)
	$Label0Plus1 = GUICtrlCreateLabel("0.0 Miles to", 30, 71, 99, 17)
	$Label1Plus2 = GUICtrlCreateLabel("0.0 Miles to", 30, 141, 99, 17)
	$Label2Plus3 = GUICtrlCreateLabel("0.0 Miles to", 30, 208, 99, 17)
	$Label3Plus4 = GUICtrlCreateLabel("0.0 Miles to", 30, 276, 99, 17)
	#EndRegion ### END Koda GUI section ###
	GUISetState(@SW_SHOW, $FormMulti)

	Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUICtrlSetOnEvent($ButtonExit, "ExitButton")
	GUICtrlSetOnEvent($ComboMultiStart, "ComboMultiChange")
	GUICtrlSetOnEvent($ComboNext1, "ComboMultiChange")
	GUICtrlSetOnEvent($ComboNext2, "ComboMultiChange")
	GUICtrlSetOnEvent($ComboNext3, "ComboMultiChange")
	GUICtrlSetOnEvent($ComboNext4, "ComboMultiChange")
	GUICtrlSetOnEvent($ButtonCopy, "CopyButtonMulti")
	GUICtrlSetOnEvent($ButtonSingleDest, "SingleDestButton")
EndFunc   ;==>MultiDestButton

Func SingleDestButton()
	GUISetState(@SW_HIDE, $FormMulti)
	GUISetState(@SW_SHOW, $FormSingleDest)
EndFunc   ;==>SingleDestButton

Func ComboMultiChange() ; Refresh all the totals
	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboMultiStart) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboNext1) + 2
	GUICtrlSetData($Label0Plus1, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles to")

	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboNext1) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboNext2) + 2
	GUICtrlSetData($Label1Plus2, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles to")

	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboNext2) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboNext3) + 2
	GUICtrlSetData($Label2Plus3, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles to")

	$StartIndex = _GUICtrlComboBox_GetCurSel($ComboNext3) + 1
	$FinishIndex = _GUICtrlComboBox_GetCurSel($ComboNext4) + 2
	GUICtrlSetData($Label3Plus4, StringFormat("%.1f", $MileArray[$StartIndex][$FinishIndex]) & " Miles to")

	GUICtrlSetData($TotalMultiMilesLabel, TotalOfAllLables() & " Total Combined Miles")

EndFunc   ;==>ComboMultiChange

Func TotalOfAllLables() ; Caculate the total of all the different miles
	$FuncTotal = Number(GUICtrlRead($Label0Plus1)) + Number(GUICtrlRead($Label1Plus2)) + Number(GUICtrlRead($Label2Plus3)) + Number(GUICtrlRead($Label3Plus4))
	Return StringFormat("%.1f", $FuncTotal)
EndFunc   ;==>TotalOfAllLablels
