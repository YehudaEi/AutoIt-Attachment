#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Ian Patterson

 Script Function: Makes a list of files to be processed, extracts information from specific cells and puts the results on a new row in another workbook.
 ***IMPORTANT*** Make sure that excel and notpad are not running.
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start
#include "C:\Documents and Settings\ian patterson.PAR4\Desktop\AutoIT scripts\ExcelCOM_UDF.au3"
#include <File.au3>
#include <Array.au3>

;Declare variables
$oExcel = 0 ;the excel object
$delay = 500

Dim $ServiceSheetArray[500][28] ;To collect all data
Dim $Cells2Grab[28] = ["A2", "A3", "A4", "A5", "A6", "A7", "A8", "H1", "H2", "H3", "H4", "I4", "F5", "G5", "H5", "I5", "F6", _
"G6", "H6", "I6", "F7", "G7", "H7", "I7", "F8", "G8", "H8", "I8"] ;This is a list of cells to grab.  The number of records must = Func PutToArray() 'For' counter -1

;Generate file list
;SplashTextOn('Locating files', 'Locating all .XLS files' &@lf& 'Please wait for command window to close...')
RunWait(@comspec & ' /c dir "C:\Documents and Settings\ian patterson.PAR4\Desktop\GOLF\*.xls" /b/oN/s > "c:\all-XLS files.txt"')
splashoff()

;read text file line by line
$file = FileOpen("C:\all-XLS files.txt", 0)

;wait for list to be generated (must be a better way to do this)
SLEEP(4000)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf



; Read in lines of text
For $Sheetcount = 0 to 220 Step 1 ;the number of sheets to process
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
		;call function to open file in excel "openXLS"
		loadXLS()
		SelectFirstWorksheet()
		PutToArray()
Next

Array2TextFile()
FileClose($file)

Func loadXLS()
$oExcel = _ExcelBookOpen($line, 1)
EndFunc

Func SelectFirstWorksheet()
	_ExcelSheetActivate($oExcel, 1)
EndFunc

Func PutToArray()
	For $CellCount = 0 to 27 Step 1
		;get cells
		$temp = _ExcelReadCell($oExcel, $Cells2Grab[$CellCount])
		$temp = StringStripWS ( $temp, 3 );strip leading and trailing characters
		$ServiceSheetArray[$Sheetcount][$CellCount] = $temp
		Next
		;Close current workbook
		_ExcelBookClose($oExcel)
EndFunc
	
Func Array2TextFile()
	$sFile = "c:\Golf-contacts.txt"
CSV2DCreator($sFile, $ServiceSheetArray,0)
FileClose($sFile)
EndFunc

Func CSV2DCreator($hFile, $avArray, $bEraseCreate = True) ;new output function
$output = ""
If $bEraseCreate Then FileClose(FileOpen($hFile, 2))
For $x = 0 to UBound($avArray,1) - 1
	$output = $output & @CRLF
	For $i = 0 to UBound($avArray,2) - 1
		$output = $output & $avArray[$x][$i] & "^"
	Next
Next
;MsgBox(4096,"Array Contents", $output)
Return FileWrite($hFile, $output)
EndFunc

#cs
To stop virus scanning type the following into Start/Run:-
regsvr32 /u "C:\Program Files\Grisoft\AVG Free\avgoff2k.dll"

To start virus scanning type the following into Start/Run:-
regsvr32 "C:\Program Files\Grisoft\AVG Free\avgoff2k.dll"

The above path to the avgoff2k.dll is mine; yours may be different. 
#ce




