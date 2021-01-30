;-----------------------------------------------------------------------------
; AutoIt Version: 3.2.12.1
; Language:       English
; Platform:       WinNT
; Author:         Leontin Suteu, leosuteu at gmail.com
;
; Script Function: compares rows in 2 scripts
; Last modified:   22.10.2009
; Version:         1.1
;-----------------------------------------------------------------------------
AutoItSetOption("MustDeclareVars", 1)
;declarations
Global $Form1, $butFile1, $butFile2, $butStart
Global $inpFile1Name, $inpFile1Date, $inpFile1NrRaw, $inpFile1Size
Global $inpFile2Name, $inpFile2Date, $inpFile2NrRaw, $inpFile2Size
Global $Label1, $Label2, $Label3, $Label4, $Label5, $inpConclusion, $ListView1, $Progress1, $inpMessage
Global $nMsg, $sFile1Name, $sFile2Name

;includes
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <GuiListView.au3>

#Region ### START Koda GUI section ### Form=E:\autoit\scriptdiff\form1.kxf
$Form1 = GUICreate("ScriptDiff", 669, 551, 10, 10, -1, $WS_EX_ACCEPTFILES)
$butFile1 = GUICtrlCreateButton("...", 8, 32, 33, 25)
GUICtrlSetTip(-1, "Press to choose a file or drag & drop it over inputbox")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$inpFile1Name = GUICtrlCreateInput("", 48, 32, 362, 21, $ES_AUTOHSCROLL);,$ES_READONLY))
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$inpFile2Name = GUICtrlCreateInput("", 48, 64, 362, 21, $ES_AUTOHSCROLL);,$ES_READONLY))
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$butFile2 = GUICtrlCreateButton("...", 8, 64, 33, 25)
GUICtrlSetTip(-1, "Press to choose a file or drag & drop it over input control")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("File1", 417, 32, 26, 17)
$inpFile1Size = GUICtrlCreateInput("", 444, 32, 50, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$inpFile1Date = GUICtrlCreateInput("", 546, 32, 117, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$inpFile1NrRaw = GUICtrlCreateInput("", 500, 32, 40, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Label2 = GUICtrlCreateLabel("File2", 417, 64, 26, 17)
$inpFile2Size = GUICtrlCreateInput("", 444, 64, 50, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$inpFile2Date = GUICtrlCreateInput("", 546, 64, 117, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$inpFile2NrRaw = GUICtrlCreateInput("", 500, 64, 40, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$butStart = GUICtrlCreateButton("Analyze", 8, 99, 97, 41)
$ListView1 = GUICtrlCreateListView("Row File1|Status|Row File2", 409, 91, 254, 456, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES))
GUICtrlSetTip($ListView1, "= rows are identical" & @CRLF & "x row has no equivalence")
$Label3 = GUICtrlCreateLabel("Size", 444, 8, 24, 17)
$Label4 = GUICtrlCreateLabel("Rows", 500, 8, 31, 17)
$Label5 = GUICtrlCreateLabel("Date mod.", 547, 8, 53, 17)
$Progress1 = GUICtrlCreateProgress(8, 145, 394, 25, BitOR($PBS_SMOOTH, $WS_BORDER))
$inpMessage = GUICtrlCreateInput("", 8, 175, 394, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$inpConclusion = GUICtrlCreateInput("", 8, 220, 394, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlListView_SetColumnWidth($ListView1, 0, 80)
_GUICtrlListView_SetColumnWidth($ListView1, 1, 60)
_GUICtrlListView_SetColumnWidth($ListView1, 2, 80)
main()
;-----------------------------------------------------------------------------
Func main() ;GUI loop
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $butFile1
				file1Info()
			Case $butFile2
				file2Info()
			Case $butStart
				compareFiles()
		EndSwitch
	WEnd
EndFunc   ;==>main
;-----------------------------------------------------------------------------
Func fileDate($nFile) ;Returns file modified date
	Local $fileDate, $year, $month, $day, $hour, $min, $sec

	$fileDate = FileGetTime($nFile, 0, 0)
	$year = $fileDate[0]
	$month = $fileDate[1]
	$day = $fileDate[2]
	$hour = $fileDate[3]
	$min = $fileDate[4]
	$sec = $fileDate[5]
	Return $year & "/" & $month & "/" & $day & " " & $hour & ":" & $min & ":" & $sec
EndFunc   ;==>fileDate
;-----------------------------------------------------------------------------
Func file1Info() ;Gets file1
	GUICtrlSetData($inpFile1Name, "")
	$sFile1Name = FileOpenDialog("Choose a file", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "AutoIt files (*.au3)", 1)
	If @error Then
		MsgBox(16, "Error", "Can not open file1")
		Return
	EndIf
	GUICtrlSetData($inpFile1Name, $sFile1Name)
EndFunc   ;==>file1Info
;-----------------------------------------------------------------------------
Func file2Info() ;Gets file2
	GUICtrlSetData($inpFile2Name, "")
	$sFile2Name = FileOpenDialog("Choose a file", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "AutoIt files (*.au3)", 1)
	If @error Then
		MsgBox(16, "Error", "Can not open file2")
		Return
	EndIf
	GUICtrlSetData($inpFile2Name, $sFile2Name)
EndFunc   ;==>file2Info
;-----------------------------------------------------------------------------
Func compareFiles() ;Compares rows from both files
	Local $erCode, $aRawFile1[1], $aRawFile2[1], $nRow1, $nRow2, $aRawFile1, $aRawFile2, $aFindFile2, $bFind, $sListW, $nIdRows = 0
	Local $file1Size, $file2Size
	
	;initialization of some GUI controls
	GUICtrlSetData($inpConclusion, "")
	GUICtrlSetData($inpMessage, "")
	;delete the previous listview that may contain rows from previous use
	GUICtrlDelete($ListView1)
	;generates a new one
	$ListView1 = GUICtrlCreateListView("Row File1|Status|Row File2", 409, 91, 254, 456, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES))
	_GUICtrlListView_SetColumnWidth($ListView1, 0, 80)
	_GUICtrlListView_SetColumnWidth($ListView1, 1, 60)
	_GUICtrlListView_SetColumnWidth($ListView1, 2, 80)
	GUICtrlSetTip($ListView1, "= rows are identical" & @CRLF & "x row has no equivalence")
	
	;get file names from input boxes
	$sFile1Name = GUICtrlRead($inpFile1Name)
	$sFile2Name = GUICtrlRead($inpFile2Name)
	If $sFile1Name = "" Or $sFile2Name = "" Then
		MsgBox(16, "Error", "Invalid file name")
		Return
	EndIf
	
	;shows some info about files
	$file1Size = FileGetSize($sFile1Name)
	If @error Then
		MsgBox(16, "Error", "Can not open file1")
		Return
	EndIf
	$file2Size = FileGetSize($sFile2Name)
	If @error Then
		MsgBox(16, "Error", "Can not open file2")
		Return
	EndIf
	GUICtrlSetData($inpFile1Size, $file1Size)
	GUICtrlSetData($inpFile2Size, $file2Size)
	GUICtrlSetData($inpFile1Date, fileDate($sFile1Name))
	GUICtrlSetData($inpFile2Date, fileDate($sFile2Name))
	GUICtrlSetData($inpFile1NrRaw, _FileCountLines($sFile1Name))
	GUICtrlSetData($inpFile2NrRaw, _FileCountLines($sFile2Name))
	
	;reads rows to arrays
	$erCode = _FileReadToArray($sFile1Name, $aRawFile1)
	If $erCode <> 1 Then
		MsgBox(16, "Error", "Can not open file1")
		Return
	EndIf
	$erCode = _FileReadToArray($sFile2Name, $aRawFile2)
	If $erCode <> 1 Then
		MsgBox(16, "Error", "Can not open file2")
		Return
	EndIf
	;marks array of rows from file2 as not found
	Local $aFindFile2[$aRawFile2[0] + 1]
	For $nRow2 = 1 To $aRawFile2[0]
		$aFindFile2[$nRow2] = False
	Next

	GUICtrlSetData($inpFile1NrRaw, $aRawFile1[0])
	GUICtrlSetData($inpFile2NrRaw, $aRawFile2[0])
	GUICtrlSetData($inpMessage, "File1 against file2")
	;Compares each row in file1 with each row in file2
	For $nRow1 = 1 To $aRawFile1[0]
		GUICtrlSetData($Progress1, $nRow1 / $aRawFile1[0] * 100)
		$bFind = False
		For $nRow2 = 1 To $aRawFile2[0]
			;The number of identical rows is shown in listview
			;Rows in file2 that are already found are omitted
			If (($aRawFile1[$nRow1] = $aRawFile2[$nRow2]) And Not ($aFindFile2[$nRow2])) Then
				$sListW = GUICtrlCreateListViewItem($nRow1 & "|=|" & $nRow2, $ListView1)
				$bFind = True
				$aFindFile2[$nRow2] = True ;marks element as found
				$nIdRows += 1
				ExitLoop
			EndIf
		Next
		;Rows that are different are marked accordingly
		If Not ($bFind) Then $sListW = GUICtrlCreateListViewItem($nRow1 & "|X|" & "", $ListView1)
	Next
	;Shows rows in file2 that are not identical to any row in file1
	GUICtrlSetData($inpMessage, "File2 against file1")
	For $nRow2 = 1 To $aRawFile2[0]
		GUICtrlSetData($Progress1, $nRow2 / $aRawFile2[0] * 100)
		If Not ($aFindFile2[$nRow2]) Then $sListW = GUICtrlCreateListViewItem("" & "|X|" & $nRow2, $ListView1)
	Next
	;shows the number of identical rows and ready message
	Sleep(1000)
	If ($nIdRows = _FileCountLines($sFile1Name)) And ($nIdRows = _FileCountLines($sFile2Name)) Then
		GUICtrlSetData($inpConclusion, "Files are identical")
	Else
		GUICtrlSetData($inpConclusion, "Found " & $nIdRows & " identical rows")
	EndIf
	GUICtrlSetData($inpMessage, "Ready")
EndFunc   ;==>compareFiles
;-----------------------------------------------------------------------------
;EOF