;Script Name:  GetMyVars.au3
;Author:  Sue Ness 11/05/2007
;Purpose:  Load variables from an Excel spreadsheet, run routine and loop until EOF
;Only goes up to column Z.  This is what I do for fun.
;Title Row starts with an asterisk (optional)
;Requires the ExcelUDF.au3 and GUIConstants.au3 to be in your include folder.
;Capturing the date requires a ' in front of the date field value in the spreadsheet to avoid erroneous number capture.

#include <GUIConstants.au3>
#include "ExcelUDF.au3"

Dim $TitleRow1, $Titlerow2, $RowCounter, $ColCounter, $ColMax, $ColName, $CellName, $CellRange, $MsgTitle, $Stop, $ErrMsg, $Label
Dim $CellVal01, $CellVal02, $CellVal03, $CellVal04, $CellVal05
Dim $CellVal06, $CellVal07, $CellVal08, $CellVal09, $CellVal10
Dim $CellVal11, $CellVal12, $CellVal13, $CellVal14, $CellVal15
Dim $CellVal16, $CellVal17, $CellVal18, $CellVal19, $CellVal20
Dim $CellVal21, $CellVal22, $CellVal23, $CellVal24, $CellVal25, $CellVal26
Dim $TTLVal01, $TTLVal02, $TTLVal03, $TTLVal04, $TTLVal05
Dim $TTLVal06, $TTLVal07, $TTLVal08, $TTLVal09, $TTLVal10
Dim $TTLVal11, $TTLVal12, $TTLVal13, $TTLVal14, $TTLVal15
Dim $TTLVal16, $TTLVal17, $TTLVal18, $TTLVal19, $TTLVal20
Dim $TTLVal21, $TTLVal22, $TTLVal23, $TTLVal24, $TTLVal25, $TTLVal26
Dim $len

;Set $ErrMsg to "Y" to see each cell's data value displayed.
$ErrMsg = "Y"

;Set to your spreadsheet name, place it in your include folder.
$MyFile = "/ss1.xls"

$MsgTxt = ""
$RowCounter = 0
$TitleRow1 = "N"
$TitleRow2 = "N"
$Stop = 0
$RowCounter = 1
$ColCounter = 0
$Result = "A"
_XLApp($XL_OPEN, false)
_XLApp($XL_VISIBLE, True)
_XLWBook($XL_OPEN, @ScriptDir & $MyFile)
_XLWBook($XL_ACTIVATE,1)


While $Stop = 0
	Alpha()
	Analy1()
		If $Result = "" AND $ColCounter = 1 Then
			$Stop = 1
		Elseif $Result = "" AND $ColCounter <> 1 Then
			;This is where your function would go to take the $CellVal's 1 - 26 and employ them.
			NextRow()
		EndIf		
		If $Stop = 0 and $TitleRow1 = "Y" and $Result <> "" Then
			TTLValue()
		Elseif $Stop = 0 and $TitleRow1 = "N" and $Result <> "" then
			CellValue()	  
		EndIf
	
WEnd

	MsgBox(0, "EOF", "End Of File")	
_XLWBook($XL_CLOSE, @ScriptDir & $MyFile)
_XLApp($XL_CLOSE, false)

Func NextRow()
	$ColCounter = 0
	$RowCounter = $RowCounter + 1
	$TitleRow1 = "N"
EndFunc

Func Analy1()
	$CellName = $ColName & String($RowCounter)
		$CellRange = $CellName & ":" & $CellName
		$Result = _XLRange($XL_READVALUE, $CellRange)
		If $ColCounter = 1 AND Stringleft($Result,1) = "*" Then 
			$MsgTitle = "This is a title row" 
		EndIf
		If $ColCounter = 1 AND Stringleft($Result,1) = "*" Then 
			$TitleRow1 = "Y" 
		EndIf
		If $ColCounter = 1 AND Stringleft($Result,1) <> "*" Then 
			$MsgTitle = "This is a data row" 
		EndIf
		If $Result = "" then 
			$MsgTitle = "Blank Cell"
		EndIf
EndFunc
		
Func Alpha()
	$ColCounter = $ColCounter + 1
	Switch $ColCounter
		Case 1
			$ColName = "A"
		Case 2
			$ColName = "B"
		Case 3
			$ColName = "C"
		Case 4
			$ColName = "D"
		Case 5
			$ColName = "E"
		Case 6
			$ColName = "F"
		Case 7
			$ColName = "G"
		Case 8
			$ColName = "H"
		Case 9
			$ColName = "I"
		Case 10
			$ColName = "J"
		Case 11
			$ColName = "K"
		Case 12
			$ColName = "L"
		Case 13
			$ColName = "M"
		Case 14
			$ColName = "N"
		Case 15
			$ColName = "O"
		Case 16
			$ColName = "P"
		Case 17
			$ColName = "Q"
		Case 18
			$ColName = "R"
		Case 19
			$ColName = "S"
		Case 20
			$ColName = "T"
		Case 21
			$ColName = "U"
		Case 22
			$ColName = "V"
		Case 23
			$ColName = "W"
		Case 24
			$ColName = "X"
		Case 25
			$ColName = "Y"
		Case 26
			$ColName = "Z"
		Case 27
			If $ErrMsg = "Y" Then
				MsgBox(0,"Error", "You've outgrown your script!", 2000)
				EndIf
	EndSwitch
EndFunc

Func CellValue()
	Switch $ColCounter
		Case 1
			$CellVal01 = $Result
			$Label = $TTLVal01
		Case 2
			$CellVal02 = $Result
			$Label = $TTLVal02
		Case 3
			$CellVal03 = $Result
			$Label = $TTLVal03
		Case 4
			$CellVal04 = $Result
			$Label = $TTLVal04
		Case 5
			$CellVal05 = $Result
			$Label = $TTLVal05
		Case 6
			$CellVal06 = $Result
			$Label = $TTLVal06
		Case 7
			$CellVal07 = $Result
			$Label = $TTLVal07
		Case 8
			$CellVal08 = $Result
			$Label = $TTLVal08
		Case 9
			$CellVal09 = $Result
			$Label = $TTLVal09
		Case 10
			$CellVal10 = $Result
			$Label = $TTLVal10
		Case 11
			$CellVal11 = $Result
			$Label = $TTLVal11
		Case 12
			$CellVal12 = $Result
			$Label = $TTLVal12
		Case 13
			$CellVal13 = $Result
			$Label = $TTLVal13
		Case 14
			$CellVal14 = $Result
			$Label = $TTLVal14
		Case 15
			$CellVal15 = $Result
			$Label = $TTLVal15
		Case 16
			$CellVal16 = $Result
			$Label = $TTLVal16
		Case 17
			$CellVal17 = $Result
			$Label = $TTLVal17
		Case 18
			$CellVal18 = $Result
			$Label = $TTLVal18
		Case 19
			$CellVal19 = $Result
			$Label = $TTLVal19
		Case 20
			$CellVal20 = $Result
			$Label = $TTLVal20
		Case 21
			$CellVal21 = $Result
			$Label = $TTLVal21
		Case 22
			$CellVal22 = $Result
			$Label = $TTLVal22
		Case 23
			$CellVal23 = $Result
			$Label = $TTLVal23
		Case 24
			$CellVal24 = $Result
			$Label = $TTLVal24
		Case 25
			$CellVal25 = $Result
			$Label = $TTLVal25
		Case 26
			$CellVal26 = $Result
			$Label = $TTLVal26
		Case 27
			If $ErrMsg = "Y" Then
				MsgBox(0,"Error", "You've outgrown your script!", 2000)
				EndIf
		EndSwitch
		If $ErrMsg = "Y" and $Titlerow2 = "Y" Then
				MsgBox(0,$MsgTitle, $CellRange & "; " & $Label & ": " & $Result, 2000)
			ElseIf	$ErrMsg = "Y" Then
				MsgBox(0,$MsgTitle, $CellRange & "; "$Result)
			EndIf
EndFunc

Func TTLValue()
	Switch $ColCounter
		Case 1
			$len = StringLen($Result)
			$len = $len - 1
			$TTLVal01 = StringRight($Result, $len)
			$TitleRow2 = "Y"
		Case 2
			$TTLVal02 = $Result
		Case 3
			$TTLVal03 = $Result
		Case 4
			$TTLVal04 = $Result
		Case 5
			$TTLVal05 = $Result
		Case 6
			$TTLVal06 = $Result
		Case 7
			$TTLVal07 = $Result
		Case 8
			$TTLVal08 = $Result
		Case 9
			$TTLVal09 = $Result
		Case 10
			$TTLVal10 = $Result
		Case 11
			$TTLVal11 = $Result
		Case 12
			$TTLVal12 = $Result
		Case 13
			$TTLVal13 = $Result
		Case 14
			$TTLVal14 = $Result
		Case 15
			$TTLVal15 = $Result
		Case 16
			$TTLVal16 = $Result
		Case 17
			$TTLVal17 = $Result
		Case 18
			$TTLVal18 = $Result
		Case 19
			$TTLVal19 = $Result
		Case 20
			$TTLVal20 = $Result
		Case 21
			$TTLVal21 = $Result
		Case 22
			$TTLVal22 = $Result
		Case 23
			$TTLVal23 = $Result
		Case 24
			$TTLVal24 = $Result
		Case 25
			$TTLVal25 = $Result
		Case 26
			$TTLVal26 = $Result
		Case 27
			If $ErrMsg= "Y" Then
				MsgBox(0,"Error", "You've outgrown your script!", 2000)
				EndIf
	EndSwitch
EndFunc
