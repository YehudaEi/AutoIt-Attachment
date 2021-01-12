#include"_CSVLib_V1.1.au3"
#include <File.au3>
#include <Array.au3>
#include <GUIConstants.au3>
#Include <GuiListView.au3>
Dim $CSV[15] = [14]
$CSV[1] = '1,Record with no delimiters and no enclose in fields,b1,c1,d1,e1,f1,g1,h1,i1'
$CSV[2] = '2,Record with no delimiters and no enclose in fields. Some empty fields,b2,,d2,e2,,,h2,i2'
$CSV[3] = '3,Record with no delimiters and with enclose chars,"""b3","c""3","d3""","""""e3","""f3""","g""3""","""h""3","i3"""""'
$CSV[4] = '4,Record with delimiters ,",b4","c,4","d4,",",,e4",",f4,","g,4,",",h,4","i4,,"'
$CSV[5] = '5,"Record with single delimiter, single enclose chars",",""b5",",c""5",",d5""",""",e5","""f,5","""g5,","h"",5","i,""5"'
$CSV[6] = '6,"Record with single delimiter, single enclose and some empty fields",",""b6",",c""6",,""",e6","""f,6",,"h"",6","i,""6"'
$CSV[7] = '7,Record with single delimiter and double enclose chars,"""b,7""",""",c7""","""d7,""",",""e""7","f,""7""","g7,""""",""""",h7","i,""""7"'
$CSV[8] = '8,Record with double delimiter and double enclose chars,",""b,8""",",,""""c8",",""d"",8",",""e8"",","""f,8"",","""g8"",,",""""",,h8",""","",i8"'
$CSV[9] = '9,Record with double delimiter and double enclose and some empty fields,"b,"",""9","c"",,""9",,,"f,"""",9",,""",,h9""","""i9,"","'
$CSV[10] = '10,Record with multiple odd delimiters and multiple odd enclose,"b"",,,""10""",""",c"","""",,""10,",""",""""d,1,0"""",,","""""e"""",,1,,0,""",""",,f,,1,,0,""""""""""",""""""""""",,g,,1,,0,",""""",h,1,0"",,,,",",,,"","",i10"""'
$CSV[11] = '11,Record with multiple odd delimiters and multiple even enclose,"b"",,,""11",",c"","""",,""11,",",""""d,1,1"""",,","""""e"""",,1,,1,",",,f,,1,,1,""""""""""",""""""""",,g,,1,,1,",""""",h,1,1,,,,",",,,,"",i11"""'
$CSV[12] = '12,Record with multiple even delimiters and multiple odd enclose,""",b12,""""",",""c"",""12",",""d12"",""","""e"",""12"",""",""",""f"",""12""",",g"",""1,2"",",""""",h,12""","""""i"",""12,"""'
$CSV[13] = '13,Record with multiple even delimiters and multiple even enclose,""""",""b13"",""""","""c"","""",""13""",""""","""","""",""d13"",","e"","""",,""13",",,f,""""13"""",,,",""","",g"",""13,",""","",""h13"","",""",",,""i"",,""13"",,"'
$CSV[14] = '14,Record with complex combinations of escaped and non escaped fields,b14,""""",""c14"",""""",d14,",""e"",""14",,""""""""""",,g,,1,,4,",,i14'
Global $CurrentFile = '', $FileName = 'CSVSampleFileTest_', $FileExt = '.csv'
Global $NextTest = 0
Dim $CSVOriginalValues[UBound($CSV) ], $TextOriginalValues[UBound($CSV) ]
Dim $CSVTestListView[1] = [0], $TxtTestListView[1] = [0]
Global $CSVTestListViewStr, $TxtTestListViewStr
Global $CSVOriginalRecords = '', $CSVOriginalFields = '', $TextOriginalFields = '', $TextOriginalRecords = ''
Global $ListCurrentTest, $CSVListCurrentTest

#Region ### START Koda GUI section ### Form=
$GuiCSVTest = GUICreate("GuiCSVTest", 800, 600, 190, 112)
$Tab = GUICtrlCreateTab(2, 2, 796, 565);, style [, exStyle]]]] )
$TextTab = GUICtrlCreateTabItem('Text')
$ListOriginal = GUICtrlCreateListView("RowNum|col 1|col 2|col 3|col 4|col 5|col 6|col 7|col 8|col 9|col 10|col 11", 8, 45, 784, 245)
$ListCurrentTest = GUICtrlCreateListView("RowNum|col 1|col 2|col 3|col 4|col 5|col 6|col 7|col 8|col 9|col 10|col 11", 8, 310, 784, 245)
$LabelOriginal = GUICtrlCreateLabel("Original Values", 8, 27, 74, 17)
$LabelCurrentTest = GUICtrlCreateLabel("Current Test:", 8, 295, 65, 17)
GUICtrlCreateTabItem("")
$TextTab = GUICtrlCreateTabItem('CSV')
$CSVListOriginal = GUICtrlCreateListView("RowNum|col 1|col 2|col 3|col 4|col 5|col 6|col 7|col 8|col 9|col 10|col 11", 8, 45, 784, 245)
$CSVListCurrentTest = GUICtrlCreateListView("RowNum|col 1|col 2|col 3|col 4|col 5|col 6|col 7|col 8|col 9|col 10|col 11", 8, 310, 784, 245)
$CSVLabelOriginal = GUICtrlCreateLabel("Original Values", 8, 27, 74, 17)
$CSVLabelCurrentTest = GUICtrlCreateLabel("Current Test:", 8, 295, 65, 17)
GUICtrlCreateTabItem("")
;test title
$LabelTestTitle = GUICtrlCreateLabel("Test Title", 8, 570, 650, 17)
GUICtrlSetFont($LabelTestTitle, 10, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor($LabelTestTitle, 0xFFFFFF)
;button
$NextTestBtn = GUICtrlCreateButton("Next Test", 670, 570, 121, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Populate the list views. (odd consecutive quotes look as if they're enclosed within single quotes)
Dim $OriginalFields, $TextFields
If Not _FileCreate(@ScriptDir & '\' & 'CSVOriginalSampleTest' & $FileExt) Then Quit('Original sample File Creation Error', 'Test failed')
For $i = 1 To $CSV[0] Step 1
	; create a csv file with original values
	_CSVFileAppendRecord (@ScriptDir & '\' & 'CSVOriginalSampleTest' & $FileExt, $CSV[$i])
	$OriginalFields = _CSVRecordToFields ($CSV[$i])
	; Populate the csv list view
	$CSVOriginalRecords = _CSVFieldsToRecord ($OriginalFields, 1, -1, Opt('GUIDataSeparatorChar'))
	$CSVOriginalValues[$i] = GUICtrlCreateListViewItem($CSVOriginalRecords, $CSVListOriginal)
	; Populate the text list view
	$TextFields = $OriginalFields
	For $j = 1 To $OriginalFields[0] Step 1
		$TextFields[$j] = _CSVFieldToString ($TextFields[$j])
	Next
	$TextOriginalRecords = _CSVFieldsToRecord ($TextFields, 1, -1, Opt('GUIDataSeparatorChar'))
	$TextOriginalValues[$i] = GUICtrlCreateListViewItem($TextOriginalRecords, $ListOriginal)
Next

If FileExists(@ScriptDir & '\' & 'CSVOriginalSampleTest' & $FileExt) Then
	MsgBox(0, 'Test can start', 'Original sample csv file created' & @CRLF & @CRLF & @ScriptDir & '\' & 'CSVOriginalSampleTest' & $FileExt)
EndIf

Global $SetDelimiter = ','
Global $SetEnclose = '"'

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Quit('Good bye', 'Exiting')
		Case $NextTestBtn
			$NextTest += 1
			NextTest()
	EndSwitch
WEnd

Func NextTest()
	Local $lTestName
	Local $lFileHandle
	Dim $lRecords[1], $lFields[1]
	Dim $lColArr[1]
	Local $lColumnSelection, $lColumnSelectInsertion, $lSourceCol, $lDestinationCol
	Local $lRecordSelection, $lSourceRec, $lDestinationRec
	Local $lField
	; reset the list view items
	If $NextTest <> 1 Then
		For $i = 1 To UBound($TxtTestListView) - 1 Step 1
			GUICtrlDelete($TxtTestListView[$i])
		Next
		For $i = 1 To UBound($CSVTestListView) - 1 Step 1
			GUICtrlDelete($CSVTestListView[$i])
		Next
		ReDim $CSVTestListView[1]
		ReDim $TxtTestListView[1]
	EndIf
	; set state for button and exit
	GUICtrlSetState($NextTestBtn, $GUI_DISABLE)
	If $NextTest = 11 Then Quit('End of test', "Test finished. Please provide positive or negative feedback in the forum. " _
			 & @CRLF & "It's my first significant UDF. Thanks.")
	If $NextTest = 10 Then GUICtrlSetData($NextTestBtn, 'End tests')
	$CurrentFile = @ScriptDir & '\' & $FileName & $NextTest & $FileExt
	Switch $NextTest
		Case 1 ; 'Current test: _CSVConvertDelimiter, _CSVConvertEnclose on array AND _CSVFileAppendRecord'
			MsgBox(0, 'Note', 'The basic function _CSVRecordToFields and its close relative _CSVFieldsToRecord will be used throughout the tests, so no individual test is created')
			$lTestName = '_CSVConvertDelimiter, _CSVConvertEnclose AND _CSVFileAppendRecord'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records will be converted using your delimiter and enclose selection, according to the basic rule set in _CSVRecordToFields.' _
					 & @CRLF & 'If you chose characters contained in the records, they will be replaced in the csv.' _
					 & @CRLF & 'Otherwise, the csv will contain fields strictly delimited by your chosen delimiter since there is no need for enclosure.')
			GUICtrlSetData($LabelTestTitle, 'Current test: ' & $lTestName)
			While 1
				If Not IsDeclared("sInputBoxAnswer") Then Dim $sInputBoxAnswer
				$sInputBoxAnswer = InputBox("Select delimiter", "Please enter any delimiter character for the tests, except GUIDataSeparatorChar", '?', " ", "-1", "-1", "-1", "-1")
				Select
					Case @error = 0 ;OK - The string returned is valid
						If StringLen($sInputBoxAnswer) = 1 And IsString($sInputBoxAnswer) Then
							If $sInputBoxAnswer = Opt('GUIDataSeparatorChar') Then
								MsgBox(0, 'Exception', 'Please use a different char than ' & Opt('GUIDataSeparatorChar') & '. This char will be used to separate list view items in the gui.')
							Else
								$SetDelimiter = $sInputBoxAnswer
								ExitLoop
							EndIf
						EndIf
					Case @error = 1 ;The Cancel button was pushed
						Quit('You cancelled the test ' & $lTestName, 'Good bye')
					Case @error = 3 ;The InputBox failed to open
						Quit('The InputBox failed to open Error', 'Test ' & $lTestName & ' failed')
				EndSelect
			WEnd
			While 1
				If Not IsDeclared("sInputBoxAnswer") Then Dim $sInputBoxAnswer
				$sInputBoxAnswer = InputBox("Select enclose", 'Please enter any enclose character for the tests, except GUIDataSeparatorChar"', '¿', " ", "-1", "-1", "-1", "-1")
				Select
					Case @error = 0 ;OK - The string returned is valid
						If StringLen($sInputBoxAnswer) = 1 And IsString($sInputBoxAnswer) Then
							If $sInputBoxAnswer = Opt('GUIDataSeparatorChar') Then
								MsgBox(0, 'Exception', 'Please use a different char than ' & Opt('GUIDataSeparatorChar') & '. This char will be used to separate list view items in the gui.')
							Else
								$SetEnclose = $sInputBoxAnswer
								ExitLoop
							EndIf
						EndIf
					Case @error = 1 ;The Cancel button was pushed
						Quit('You cancelled the test', 'Good bye')
					Case @error = 3 ;The InputBox failed to open
						Quit('The InputBox failed to open Error', 'Test ' & $NextTest & ' failed')
				EndSelect
			WEnd
			If $SetDelimiter = $SetEnclose Then
				MsgBox(0, 'Try again with different enclose and delimiters.', 'Please chose a delimiter char different to the enclose char.')
				$NextTest -= 1
				GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
				Return 0
			EndIf
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			; TEST FUNCTIONS: _CSVFileAppendRecord, _CSVRecordToString AND _CSVReadRecords
			ReDim $lRecords[$CSV[0]]
			$lRecords = _CSVConvertEnclose ($CSV, -1, -1, $SetEnclose)
			If @error Then Quit('_CSVConvertEnclose Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			$lRecords = _CSVConvertDelimiter ($lRecords, -1, $SetEnclose, $SetDelimiter)
			If @error Then Quit('_CSVConvertDelimiter Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			$lRecords[0] = UBound($lRecords) - 1
			For $i = 1 To $lRecords[0] Step 1
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			Next
			If Not FileExists($CurrentFile) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Delimiter and enclose conversion result in csv format:')
			MsgBox(0, 'Raw csv File created', 'File name: ' & $CurrentFile & @CRLF & @CRLF _
					 & 'The rest of the test will continue with your enclose and delimiter selection.' & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 2 ; 'Current test: _CSVReadRecords, _CSVRecordToFields AND _CSVFieldToString'
			$lTestName = '_CSVReadRecords, _CSVRecordToFields, _CSVFieldToString'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records from the last created file will be retreived and displayed in the gui.' & @CRLF _
					 & 'A new identical file should be created.')
			GUICtrlSetData($LabelTestTitle, 'Current test: _' & $lTestName)
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values with converted delimiter and enclose chars:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			; TEST FUNCTIONS: _CSVReadRecords, _CSVRecordToFields, _CSVFieldToString
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, _CSVFieldsToRecord ($lFields, 1, -1, $SetDelimiter, $SetEnclose, 0)) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			If Not FileExists($CurrentFile) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			MsgBox(0, 'Custom csv File created', 'If you chose delimiter and enclose values not equal to your excel values, ' _
					 & 'then the file will not display properly in excel.' _
					 & @CRLF & 'File name: ' & $CurrentFile & @CRLF & 'Custom Delimiter = ' & $SetDelimiter & @CRLF & 'Custom Enclose = ' & $SetEnclose & @CRLF _
					 & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 3 ; 'Current test: _CSVGetColumn, _CSVFileDeleteColumn
			$lTestName = '_CSVGetColumn, _CSVFileDeleteColumn'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'Your single column choice will be displayed in the gui.' & @CRLF _
					 & ' A file will be created and your column selection deleted from it.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			$lFields = _CSVRecordToFields ($lRecords[1], $SetDelimiter, $SetEnclose)
			$lColumnSelection = UsrNumChoice("Select column to view and delete", 'Please enter a column number in the range 1-', $lFields[0], 3)
			MsgBox(0, "Let's continue...", "Now we'll display a single column")
			; TEST FUNCTIONS: _CSVGetColumn
			$lColArr = _CSVGetColumn ($lRecords, $lColumnSelection, $SetDelimiter, $SetEnclose)
			If @error Then Quit('_CSVGetColumn Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$CSVTestListViewStr = ''
				$TxtTestListViewStr = ''
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				For $j = 1 To $lFields[0] Step 1
					If $j <> $lColumnSelection Then
						$CSVTestListViewStr &= Opt('GUIDataSeparatorChar')
						$TxtTestListViewStr &= Opt('GUIDataSeparatorChar')
					ElseIf $j = $lColumnSelection Then
						If $j < $lFields[0] Then
							$CSVTestListViewStr &= $lColArr[$i] & Opt('GUIDataSeparatorChar')
							$TxtTestListViewStr &= _CSVFieldToString ($lColArr[$i], $SetEnclose) & Opt('GUIDataSeparatorChar')
						ElseIf $j = $lFields[0] Then
							$CSVTestListViewStr &= $lColArr[$i]
							$TxtTestListViewStr &= _CSVFieldToString ($lColArr[$i], $SetEnclose)
						EndIf
					EndIf
				Next
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			Next
			If Not FileExists($CurrentFile) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			$lColArr = _CSVFileDeleteColumn ($CurrentFile, $lColumnSelection, $SetDelimiter, $SetEnclose)
			If @error Then Quit('_CSVFileDeleteColumn Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lColArr, 'Csv contents with column ' & $lColumnSelection & ' gone walkies...')
			MsgBox(0, 'Csv File created with deleted column', 'The file:' & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lFields[0] - 1 & ' columns.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 4 ; 'Current test: _CSVFileInsertColumn'
			$lTestName = '_CSVFileInsertColumn'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the deleted column will be displayed in the gui.' & @CRLF _
					 & 'A column of your choice will be inserted in a position of your choice.' & @CRLF _
					 & 'A new file with the column insertion will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll copy a column and insert it where you want")
			; TEST FUNCTIONS: _CSVFileInsertColumn
			$lColumnSelection = UsrNumChoice("Select column to copy", 'Please enter a column number in the range 1-', $lFields[0], 3)
			$lColumnSelectInsertion = UsrNumChoice("Select a position where to insert copied column", 'Please enter a column number in the range 1-', $lFields[0], 4)
			$lColArr = _CSVGetColumn ($lRecords, $lColumnSelection, $SetDelimiter, $SetEnclose)
			$lRecords = _CSVFileInsertColumn ($CurrentFile, $lColArr, $lColumnSelectInsertion, $SetDelimiter, $SetEnclose, 0)
			If @error Then Quit('_CSVFileInsertColumn Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Csv format values with column insertion:')
			MsgBox(0, 'Csv File created with column ' & $lColumnSelection & ' inserted at position ' & $lColumnSelectInsertion, 'The file:' _
					 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lFields[0] + 1 & ' columns.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 5 ; 'Current test: _CSVFileUpdateColumn'
			$lTestName = '_CSVFileUpdateColumn'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the inserted column will be displayed in the gui.' & @CRLF _
					 & 'The values of a column of your choice will be updated with values from another column of your choice.' & @CRLF _
					 & 'A new file with the column update will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll copy a column and paste it where you want")
			; TEST FUNCTIONS: _CSVFileUpdateColumn
			$lSourceCol = UsrNumChoice("Select column to copy", 'Please enter a column number in the range 1-', $lFields[0], 4)
			$lDestinationCol = UsrNumChoice("Select a position to paste copied column", 'Please enter a column number in the range 1-', $lFields[0], 5)
			$lColArr = _CSVGetColumn ($lRecords, $lSourceCol, $SetDelimiter, $SetEnclose)
			$lRecords = _CSVFileUpdateColumn ($CurrentFile, $lColArr, $lDestinationCol, $SetDelimiter, $SetEnclose, 0)
			If @error Then Quit('_CSVFileUpdateColumn Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Csv format values with column update:')
			MsgBox(0, 'Csv File created with column ' & $lSourceCol & ' copied to column ' & $lDestinationCol, 'The file:' _
					 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lFields[0] & ' columns.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 6 ; 'Current test: _CSVFileAppendColumn'
			$lTestName = '_CSVFileAppendColumn'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the updated column will be displayed in the gui.' & @CRLF _
					 & 'The values of fields in a column of your choice will be appended at the end of each record.' & @CRLF _
					 & 'A new file with the appended column will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll append the fields in a column of your choice to the end of each record")
			; TEST FUNCTIONS: _CSVFileAppendColumn
			$lSourceCol = UsrNumChoice("Select column to append", 'Please enter a column number in the range 1-', $lFields[0], 4)
			$lColArr = _CSVGetColumn ($lRecords, $lSourceCol, $SetDelimiter, $SetEnclose)
			$lRecords = _CSVFileAppendColumn ($CurrentFile, $lColArr, $SetDelimiter, $SetEnclose, 0)
			If @error Then Quit('_CSVFileAppendColumn Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Csv format values with column appended:')
			MsgBox(0, 'Csv File created with fields in column ' & $lSourceCol & ' appended at the end of each record.', 'The file:' _
					 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lFields[0] + 1 & ' columns.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 7 ; 'Current test: _CSVFileInsertRecord'
			$lTestName = '_CSVFileInsertRecord'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the appended column will be displayed in the gui.' & @CRLF _
					 & 'A record of your choice will be inserted in the line number of your choice.' & @CRLF _
					 & 'A new file with the inserted record will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll insert a record where you want")
			; TEST FUNCTIONS: _CSVFileInsertRecord
			$lSourceRec = UsrNumChoice("Select column to copy", 'Please enter a record number in the range 1-', $lRecords[0], 5)
			$lDestinationRec = UsrNumChoice("Select the position where to insert", 'Please enter a record number in the range 1-', $lRecords[0], 6)
			$lRecords = _CSVFileInsertRecord ($CurrentFile, $lRecords[$lSourceRec], $lDestinationRec, $SetDelimiter, $SetEnclose)
			If @error Then Quit('_CSVFileInsertRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Csv format values with inserted record:')
			MsgBox(0, 'Csv File created with record ' & $lSourceRec & ' inserted at ' & $lDestinationRec, 'The file:' _
					 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lRecords[0] & ' records.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 8 ; 'Current test: _CSVFileUpdateRecord'
			$lTestName = '_CSVFileUpdateRecord'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the last insertion will be displayed in the gui.' & @CRLF _
					 & 'The values from a record of your choice record will be copied to another record of your choice.' & @CRLF _
					 & 'A new file with the updated record will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll put the contents of a record in another record")
			; TEST FUNCTIONS: _CSVFileUpdateRecord
			$lSourceRec = UsrNumChoice("Select record source", 'Please enter a record number in the range 1-', $lRecords[0], 2)
			$lDestinationRec = UsrNumChoice("Select record destination", 'Please enter a record number in the range 1-', $lRecords[0], 3)
			$lRecords = _CSVFileUpdateRecord ($CurrentFile, $lRecords[$lSourceRec], $lDestinationRec, $SetDelimiter, $SetEnclose)
			If @error Then Quit('_CSVFileUpdateRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Csv format values with updated record:')
			MsgBox(0, 'Csv File created with record ' & $lSourceRec & ' copied to record ' & $lDestinationRec, 'The file:' _
					 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lRecords[0] & ' records.' _
					 & @CRLF & 'Press next test to view results.')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 9 ; 'Current test: _CSVFileDeleteRecord'
			$lTestName = '_CSVFileDeleteRecord'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the last update will be displayed in the gui.' & @CRLF _
					 & 'A record of your choice will be deleted.' & @CRLF _
					 & 'A new file with the deleted record will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			If Not _FileCreate($CurrentFile) Then Quit('File Creation Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If Not _CSVFileAppendRecord ($CurrentFile, $lRecords[$i]) Then Quit('_CSVFileAppendRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll delete a record where you want")
			; TEST FUNCTIONS: _CSVFileDeleteRecord
			$lRecordSelection = UsrNumChoice("Select record source", 'Please enter a record number in the range 1-', $lRecords[0], 7)
			If _CSVFileDeleteRecord ($CurrentFile, $lRecordSelection) Then
				If @error Then Quit('_CSVFileDeleteRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$lRecords = _CSVReadRecords ($CurrentFile)
				_ArrayDisplay($lRecords, 'Csv format values with deleted record:')
				MsgBox(0, 'Csv File created with record ' & $lRecordSelection & ' deleted', 'The file:' _
						 & @CRLF & $CurrentFile & @CRLF & 'contains ' & $lRecords[0] & ' records.' _
						 & @CRLF & 'Press next test to view results.')
			Else
				Quit('_CSVFileDeleteRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			EndIf
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
		Case 10 ; 'Current test: _CSVGetField, _CSVStringToField, _CSVFieldToString'
			$lTestName = '_CSVGetField, _CSVStringToField, _CSVFieldToString'
			MsgBox(0, 'test ' & $NextTest & ': ' & $lTestName, 'The records with the last deleted record will be displayed in the gui.' & @CRLF _
					 & 'A field of your choice will be shown in a MsgBox, both in text and csv format.' & @CRLF _
					 & 'No files will be created.')
			$lRecords = _CSVReadRecords (@ScriptDir & '\' & $FileName & $NextTest - 1 & $FileExt)
			If @error Then Quit('_CSVReadRecords Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
			_ArrayDisplay($lRecords, 'Retreived csv format values from last created file:')
			ReDim $CSVTestListView[$lRecords[0] + 1]
			ReDim $TxtTestListView[$lRecords[0] + 1]
			For $i = 1 To $lRecords[0] Step 1
				$lFields = _CSVRecordToFields ($lRecords[$i], $SetDelimiter, $SetEnclose)
				If @error Then Quit('_CSVRecordToFields Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$CSVTestListView[$i] = GUICtrlCreateListViewItem($CSVTestListViewStr, $CSVListCurrentTest)
				For $j = 1 To $lFields[0] Step 1
					$lFields[$j] = _CSVFieldToString ($lFields[$j], $SetEnclose)
					If @error Then Quit('_CSVFieldToString Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				Next
				$TxtTestListViewStr = _CSVFieldsToRecord ($lFields, 1, -1, Opt('GUIDataSeparatorChar'), $SetEnclose, 0)
				If @error Then Quit('_CSVFieldsToRecord Error', 'Test ' & $NextTest & ': ' & $lTestName & ' failed')
				$TxtTestListView[$i] = GUICtrlCreateListViewItem($TxtTestListViewStr, $ListCurrentTest)
			Next
			MsgBox(0, "Let's continue...", "Now we'll show a field of your choice in a message box in text and csv formats.")
			; TEST FUNCTIONS: _CSVFileDeleteRecord
			$lColumnSelection = UsrNumChoice("Select a column for your field", 'Please enter a record number in the range 1-', $lFields[0], 8)
			$lRecordSelection = UsrNumChoice("Select a record for your field", 'Please enter a record number in the range 1-', $lRecords[0], 12)
			$lField = _CSVGetField ($lRecords, $lColumnSelection, $lRecordSelection, $SetDelimiter, $SetEnclose)
			MsgBox(0, 'Your field in csv format', $lField)
			MsgBox(0, 'Your field in text format', _CSVFieldToString ($lField, $SetEnclose))
			MsgBox(0, 'Your field back to csv format', _CSVStringToField ($lField, $SetDelimiter, $SetEnclose))
			MsgBox(0, 'Test finished', 'Did you like it?')
			GUICtrlSetState($NextTestBtn, $GUI_ENABLE)
	EndSwitch
EndFunc   ;==>NextTest

Func UsrNumChoice($pTitle, $pMsg, $pMax, $pDefault)
	Local $lNumSelect
	While 1
		If Not IsDeclared("sInputBoxAnswer") Then Dim $sInputBoxAnswer
		$sInputBoxAnswer = InputBox($pTitle, $pMsg & $pMax, $pDefault, "", "-1", "-1", "-1", "-1")
		Select
			Case @error = 0 ;OK - The string returned is valid
				If $sInputBoxAnswer > 0 And $sInputBoxAnswer <= $pMax Then
					$sInputBoxAnswer = Int($sInputBoxAnswer)
					If @error = 1 Then ContinueLoop
					$lNumSelect = $sInputBoxAnswer
					ExitLoop
				Else
					MsgBox(0, 'Invalid number.', 'Try again.')
				EndIf
			Case @error = 1 ;The Cancel button was pushed
				Quit('You cancelled the test', 'Good bye')
			Case @error = 3 ;The InputBox failed to open
				Quit('The InputBox failed to open Error', 'Test ' & $NextTest & ' failed')
		EndSelect
	WEnd
	Return $lNumSelect
EndFunc   ;==>UsrNumChoice

Func Quit($pTitle, $pMsg)
	MsgBox(0, $pTitle, $pMsg)
	Exit
EndFunc   ;==>Quit