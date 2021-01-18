#include "doc2pdf.au3"
#include <Array.au3>

;Global Constants
Const $ROOTIN = "\\P533FP2\MATCTRL_REPORTS\208-280TH (METNAV)\"
Const $ROOTOUT = "\\P533FP2\45SW_ERM\45SCS_SCBMM\"


;Priority Report D23
$PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-B - D23\01 January"], _
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
					["december 07","15 - Priority Monitor Report\15-B - D23\12 December"], _
					]

convertmultiplefolders($PathArray, "11-04. D23 Daily Report*.doc")

;Priority report Q13
$PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-D - S04\01 January"], _
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
					["december 07","15 - Priority Monitor Report\15-D - S04\12 December"], _
					]

convertmultiplefolders($PathArray, "SP03.txt")

;Priority report D18
$PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-A - D18\01 January"], _
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
					["december 07","15 - Priority Monitor Report\15-A - D18\12 December"], _
					]

convertmultiplefolders($PathArray, "11-03. D18 Daily Report*.doc")

;Priority Report M30
$PathArray[12][2] = [["JANUARY 07","15 - Priority Monitor Report\15-F - M30\01 January"], _
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
					["december 07","15 - Priority Monitor Report\15-F - M30\12 December"], _
					]

convertmultiplefolders($PathArray, "11-08. M30 Report*.doc")

;Daily Document Register (D04)
$PathArray[12][2] = [["JANUARY 07","21 - Daily Document Registers\21-A - D04\01 January"], _
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
					["december 07","21 - Daily Document Registers\21-A - D04\12 December"], _
					]

convertmultiplefolders($PathArray, "11-01. D04, Daily Report*.doc")

;----------------------------------------------
; FUNCTIONS
;----------------------------------------------

;Convert all folders in an array
Func convertmultiplefolders(ByRef $PathArray, $filter)
	For $X = 0 to Ubound($PathArray) - 1
		convertfolder($ROOTIN & $PathArray[$X][0], $ROOTOUT & $PathArray[$X][1], $filter)
	Next
EndFunc

;Convert all files in a single folder
Func convertfolder($DocPath, $PdfPath, $filter)

	;Retrieve array of doc files
	$DocArray = _FileListToArray ( $DocPath, $filter,1)

	;_ArrayDisplay($DocArray)

	For $X = 1 to $DocArray[0]
		$inFile = $DocPath & "\" & $DocArray[$X]
		$outFile = $PdfPath & "\" & StringTrimRight ($DocArray[$X], 3 ) & "pdf"
		;MsgBox(0,"","IN: " & $inFile & @CRLF & "OUT: " & $outFile)
		;Comment this out to simulate
		DOC2PDF($inFile, $outFile)
	Next
EndFunc