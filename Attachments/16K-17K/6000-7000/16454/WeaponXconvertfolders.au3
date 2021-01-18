#include "doc2pdf.au3"
#include <Array.au3>
#include <File.au3>
#include <GUIConstants.au3>

;Global Constants
Const $ROOTIN = "\\P533FP2\MATCTRL_REPORTS\208-280TH (METNAV)\"
Const $ROOTOUT = "\\P533FP2\45SW_ERM\45SCS_SCBMM\"

While 1
	;Create GUI
	$statusGUI = GUICreate("Batch Convert DOC2PDF", 500, 100)  ; will create a dialog box that when displayed is centered
	GUISetState (@SW_SHOW)       ; will display an empty dialog box

	GUICtrlCreateLabel ("Current folder:",  10, 10, 70,20)
	$LBLCurrentFolder = GUICtrlCreateLabel ("",  90, 10, 390,20)

	GUICtrlCreateLabel ("Current file:",  10, 50, 70,20)
	$LBLCurrentFile = GUICtrlCreateLabel ("",  90, 50, 390,20)

	;Priority Report D23
	Dim $PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-B - D23\01 January"], _
						["FEBRUARY 07","15 - Priority Monitor Report\15-B - D23\02 February"], _
						["MARCH 07", "15 - Priority Monitor Report\15-B - D23\03 March"], _
						["APRIL 07","15 - Priority Monitor Report\15-B - D23\04 April"], _
						["MAY 07", "15 - Priority Monitor Report\15-B - D23\05 May"], _					
						["JUNE 07","15 - Priority Monitor Report\15-B - D23\06 June"], _
						["july 07", "15 - Priority Monitor Report\15-B - D23\07 July"], _
						["august 07","15 - Priority Monitor Report\15-B - D23\08 August"], _
						["september 07", "15 - Priority Monitor Report\15-B - D23\09 September"], _
						["october 07","15 - Priority Monitor Report\15-B - D23\10 October"], _
						["november 07", "15 - Priority Monitor Report\15-B - D23\11 November"], _
						["december 07","15 - Priority Monitor Report\15-B - D23\12 December"]]

	convertmultiplefolders($PathArray, "11-04. D23 Daily Report*.doc")

	;Priority report Q13
	Dim $PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-D - S04\01 January"], _
						["FEBRUARY 07","15 - Priority Monitor Report\15-D - S04\02 February"], _
						["MARCH 07", "15 - Priority Monitor Report\15-D - S04\03 March"], _
						["APRIL 07","15 - Priority Monitor Report\15-D - S04\04 April"], _
						["MAY 07", "15 - Priority Monitor Report\15-D - S04\05 May"], _					
						["JUNE 07","15 - Priority Monitor Report\15-D - S04\06 June"], _
						["july 07", "15 - Priority Monitor Report\15-D - S04\07 July"], _
						["august 07","15 - Priority Monitor Report\15-D - S04\08 August"], _
						["september 07", "15 - Priority Monitor Report\15-D - S04\09 September"], _
						["october 07","15 - Priority Monitor Report\15-D - S04\10 October"], _
						["november 07", "15 - Priority Monitor Report\15-D - S04\11 November"], _
						["december 07","15 - Priority Monitor Report\15-D - S04\12 December"]]

	convertmultiplefolders($PathArray, "SP03.txt")

	;Priority report D18
	Dim $PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-A - D18\01 January"], _
						["FEBRUARY 07","15 - Priority Monitor Report\15-A - D18\02 February"], _
						["MARCH 07", "15 - Priority Monitor Report\15-A - D18\03 March"], _
						["APRIL 07","15 - Priority Monitor Report\15-A - D18\04 April"], _
						["MAY 07", "15 - Priority Monitor Report\15-A - D18\05 May"], _					
						["JUNE 07","15 - Priority Monitor Report\15-A - D18\06 June"], _
						["july 07", "15 - Priority Monitor Report\15-A - D18\07 July"], _
						["august 07","15 - Priority Monitor Report\15-A - D18\08 August"], _
						["september 07", "15 - Priority Monitor Report\15-A - D18\09 September"], _
						["october 07","15 - Priority Monitor Report\15-A - D18\10 October"], _
						["november 07", "15 - Priority Monitor Report\15-A - D18\11 November"], _
						["december 07","15 - Priority Monitor Report\15-A - D18\12 December"]]

	convertmultiplefolders($PathArray, "11-03. D18 Daily Report*.doc")

	;Priority Report M30
	Dim $PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-F - M30\01 January"], _
						["FEBRUARY 07","15 - Priority Monitor Report\15-F - M30\02 February"], _
						["MARCH 07", "15 - Priority Monitor Report\15-F - M30\03 March"], _
						["APRIL 07","15 - Priority Monitor Report\15-F - M30\04 April"], _
						["MAY 07", "15 - Priority Monitor Report\15-F - M30\05 May"], _					
						["JUNE 07","15 - Priority Monitor Report\15-F - M30\06 June"], _
						["july 07", "15 - Priority Monitor Report\15-F - M30\07 July"], _
						["august 07","15 - Priority Monitor Report\15-F - M30\08 August"], _
						["september 07", "15 - Priority Monitor Report\15-F - M30\09 September"], _
						["october 07","15 - Priority Monitor Report\15-F - M30\10 October"], _
						["november 07", "15 - Priority Monitor Report\15-F - M30\11 November"], _
						["december 07","15 - Priority Monitor Report\15-F - M30\12 December"]]

	convertmultiplefolders($PathArray, "11-08. M30 Report*.doc")

	;Daily Document Register (D04)
	Dim $PathArray[12][2] = [["JANUARY 07","21 - Daily Document Registers\21-A - D04\01 January"], _
						["FEBRUARY 07","21 - Daily Document Registers\21-A - D04\02 February"], _
						["MARCH 07", "21 - Daily Document Registers\21-A - D04\03 March"], _
						["APRIL 07","21 - Daily Document Registers\21-A - D04\04 April"], _
						["MAY 07", "21 - Daily Document Registers\21-A - D04\05 May"], _					
						["JUNE 07","21 - Daily Document Registers\21-A - D04\06 June"], _
						["july 07", "21 - Daily Document Registers\21-A - D04\07 July"], _
						["august 07","21 - Daily Document Registers\21-A - D04\08 August"], _
						["september 07", "21 - Daily Document Registers\21-A - D04\09 September"], _
						["october 07","21 - Daily Document Registers\21-A - D04\10 October"], _
						["november 07", "21 - Daily Document Registers\21-A - D04\11 November"], _
						["december 07","21 - Daily Document Registers\21-A - D04\12 December"]]

	convertmultiplefolders($PathArray, "11-01. D04, Daily Report*.doc")
	GUIDelete ($statusGUI)

	$TimeStamp = TimerInit ()

	;Check every minute if time difference is greater than or equal to 4 hours
	Do
		;Pause for 1 minute
		Sleep(1000 * 60)
	Until TimerDiff ( $TimeStamp) >= 1000 * 60 * 60 * 4

WEnd

;----------------------------------------------
; FUNCTIONS
;----------------------------------------------

;Convert all folders in an array
Func convertmultiplefolders(ByRef $PathArray, $filter)
	For $X = 0 to Ubound($PathArray) - 1
		DirCreate($ROOTOUT & $PathArray[$X][1])
		convertfolder($ROOTIN & $PathArray[$X][0], $ROOTOUT & $PathArray[$X][1], $filter)
	Next
EndFunc

;Convert all files in a single folder
Func convertfolder($DocPath, $PdfPath, $filter)
	GUICtrlSetData ( $LBLCurrentFolder, $DocPath)
	
	;Retrieve array of doc files
	$DocArray = _FileListToArray ( $DocPath, $filter,1)
	
	If NOT isArray($DocArray) OR $DocArray[0] = 0 Then Return
	
	Switch @error
		Case 1
			MsgBox(0,"","Path not found or invalid" & @CRLF & $DocPath)
		Case 2
			MsgBox(0,"","Invalid $sFilter" & @CRLF & $DocPath)
		Case 3
			MsgBox(0,"","Invalid $iFlag" & @CRLF & $DocPath)
		Case 4
			MsgBox(0,"","No File(s) Found" & @CRLF & $DocPath)
	EndSwitch

	;_ArrayDisplay($DocArray)

	For $X = 1 to $DocArray[0]
		GUICtrlSetData ( $LBLCurrentFile, $DocArray[$X])
		
		$inFile = $DocPath & "\" & $DocArray[$X]
		$outFile = $PdfPath & "\" & StringTrimRight ($DocArray[$X], 3 ) & "pdf"
		
		If FileExists($outFile) Then ContinueLoop
		
		;MsgBox(0,"","IN: " & $inFile & @CRLF & "OUT: " & $outFile)
		;Comment this out to simulate
		DOC2PDF($inFile, $outFile)
	Next
EndFunc