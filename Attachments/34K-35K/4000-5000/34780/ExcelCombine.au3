#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; 04 Mar 2011 - Author: Hassan Kadhim
; GUI class of the User Creation Automation Application

#include <File.au3>
#include <Array.au3>
#include <Excel.au3>
#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>

$numParams = $Cmdline[0]
$renameString = "";
For $i=1 to $numParams Step 1
;MsgBox(0, "TESTING",$i & ". " & $Cmdline[$i])
Next

; GUI
$biGUI = GuiCreate("Excel Combine", 295, 200)
GUICtrlSetDefColor(0x05064A)

; LABELS
GUICtrlCreateLabel("Source file(s) ", 10, 6)
GUICtrlCreateLabel("Columns to extract: ", 10, 60)
GUICtrlCreateLabel("Destination file(s) ", 10, 82)

;INPUT BOXES
$txtFiles2Extract = GUICtrlCreateInput ( "Excel files (*.xlsx)", 10, 25 , 175 , 25, $ES_READONLY)
$txtColumns2Extract = GUICtrlCreateInput ( "", 110, 54 , 75 , 20)
$txtFile2Create = GUICtrlCreateInput ( "Excel files (*.xlsx)", 10, 100 , 175 , 25, $ES_READONLY)

;GROUP WITH RADIO BUTTONS
GuiCtrlCreateGroup("Action", 10, 130, 105, 60)

$rdoAppend = GuiCtrlCreateRadio("Append", 15, 145, 70)
;GUICtrlSetOnEvent(-1, 'deptEventListener')
GuiCtrlSetState(-1, $GUI_CHECKED)

$rdoReplace = GuiCtrlCreateRadio("Replace", 15, 165, 70)

; BUTTONS
$cmdBrowseExtract = GUICtrlCreateButton ( "Browse", 225, 25 )
$cmdBrowseCreate = GUICtrlCreateButton ( "Browse", 225, 100 )
$cmdProcess = GUICtrlCreateButton ( "Process", 170, 150, 100 )

; GUI MESSAGE LOOP
GuiSetState()

While 1
	$msg = GUIGetMsg(1)
	Select
		Case $msg[0] = $cmdBrowseExtract
			;MsgBox(0, "MSGBOX 1", "Rename file clicked")
			BrowseFileForExtracts()				
			;ExitLoop
		Case $msg[0] = $cmdBrowseCreate
			;MsgBox(0, "MSGBOX 1", "Rename file clicked")
			BrowseFileForCreate()				
			;ExitLoop
		Case $msg[0] = $cmdProcess
			;MsgBox(0, "MSGBOX 1", "Rename file clicked")
			Process()				
			ExitLoop
		Case $msg[0] = $rdoAppend
			$prefix = True
			$suffix = False
		Case $msg[0] = $rdoReplace
			$prefix = False
			$suffix = True
		Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $biGUI
			ExitLoop			
	EndSelect
WEnd


;Function to rename files or folders
Func BrowseFileForExtracts()
	GUICtrlSetData($txtFiles2Extract, FileOpenDialog ( "Browse for files from which we want to extract information", @ScriptDir, "Excel files (*.xls;*.xlsx)", 7))
EndFunc

;Function to rename files or folders
Func BrowseFileForCreate()
	GUICtrlSetData($txtFile2Create, FileOpenDialog ( "Browse for files which you want to add/append information ", @ScriptDir, "Excel files (*.xls;*.xlsx)", 1))
EndFunc

Func Process()
	$destRow = 1
	$curSrcCells = ""
	Dim $allSrcCells[1][1]
	$curDestCell = ""
	$destSheetName = ""
	$destFileName = ""
	
	If validateData() Then
		$array = StringSplit(GUICtrlRead ($txtFiles2Extract), "|")
		$destFileName = GUICtrlRead ($txtFile2Create)
		$destExcelFile = _ExcelBookOpen($destFileName, 1)	

		;_ArrayDisplay($array)
		$destSheetName = StringMid($array[2],1,30)
		_ExcelSheetDelete($destExcelFile, $destSheetName)
		_ExcelSheetAddNew($destExcelFile, $destSheetName)
		;MsgBox(0,"TEST1234124", "TESTING");GUICtrlRead ($txtColumns2Extract))
		$colsArray = StringSplit(GUICtrlRead ($txtColumns2Extract), ",")
		;_ArrayDisplay($colsArray)
		
		;;looping through array variable to open source file names one by one
		For $i=2 to $array[0] Step 1 
			$srcRow = 1
			;MsgBox(0, "TEST", $array[1] & "\" & $array[$i])
			$srcExcelFile = _ExcelBookOpen($array[1] & "\" & $array[$i], 0)
			;_ExcelSheetActivate($srcExcelFile, 1)
			$curSrcCells = _ExcelReadSheetToArray($srcExcelFile)
			;_ArrayDisplay($curSrcCells)
			_ExcelBookClose($srcExcelFile, 0)
			
			;;;;;looping through file to get information from specified cells;;;;
			For $j=1 to $curSrcCells[0][0] Step 1	
				;verifying whether the current row has data at the specified columns
				For $k = 1 to $colsArray[0] Step 1						
					;writing from the source document to the destination document	
					;MsgBox(0, "Variables", "$j=" & $j & " $curSrcCells[0][0]=" & $curSrcCells[0][0] & " $k=" & $k & " $colsArray[0]=" & $colsArray[0] & " $srcRow= " & $srcRow & " $destRow= " & $destRow)
					;MsgBox(0, "Variables", "$curSrcCells[$j][$colsArray[$k]]=" & $curSrcCells[$j][$colsArray[$k]])
					
					$destExcelFileAttached = _ExcelBookAttach($destFileName)
					;_ExcelSheetActivate($destExcelFileAttached, $destSheetName)
					MsgBox(0, "Writing", "Writing cell")
					_ExcelWriteCell($destExcelFileAttached, $curSrcCells[$j][$colsArray[$k]], $destRow, $colsArray[$k])     
				Next
				;incrementing row variables
				$srcRow = $srcRow + 1
				$destRow = $destRow + 1
			Next
			;;;;;end loop;;;;
		Next
		;_ArrayDisplay($array)
		_ExcelBookClose($destExcelFile, 1)	;saving the file before closing
		_ExcelBookOpen(GUICtrlRead ($txtFile2Create), 1)	;re-opening the saved file (and making it visible)
		;MsgBox (0, "YES!", "TEST YES!")
	EndIf
EndFunc

Func validateData()
	$txtTemp1 = GUICtrlRead ($txtFiles2Extract)
	$txtTemp2 = GUICtrlRead ($txtColumns2Extract)
	$txtTemp3 = GUICtrlRead ($txtFile2Create)
	$valid = False
	
	If ($txtTemp1 = "Excel files (*.xlsx)") Then
		MsgBox(0, "No file entered in 'Source files' text box", "Please enter source file(s) to extract the information you need from.")
	ElseIf (StringInStr($txtTemp1, "|") = 0) Then
		MsgBox(0, "At least 2 files are needed to combine", "You must input a minimum of 2 files to extract information from!")
	ElseIf ($txtTemp2 = "") Then
		MsgBox(0, "No Columns to extract in text box", "Please enter column(s) to extract from the source files.")
		;StringRegExp($txtTemp2, "\A\d+(, ?\d+)*\z")       ;StringRegExp($txtTemp2,"\d+(, *\d+)*$")
	ElseIf (IsInt ($txtTemp2) = False And StringRegExp($txtTemp2, "\A\d+( *, *\d+)*\z") =0) Then
		MsgBox(0, "Columns not in correct format", "Please enumerate column(s) in between commas! ex.(1,3,5)")
	ElseIf ($txtTemp3 = "Excel files (*.xlsx)") Then
		MsgBox(0, "No file entered in 'Destination files' text box", "Please enter destination file(s) to extract the information you need from.")
	Else 
		$valid = True
	EndIf
	return $valid
EndFunc
