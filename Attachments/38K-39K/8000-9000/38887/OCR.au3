Global $debugCode=2
Global $grabWidth=0, $grabHeight=0
Global $checkForMatch[2]
Global $blankBlockCount=0, $blankColCnt=0, $avBlankWidth=0, $newBlank=0, $topRowInLine=0, $bottomRowInLine=0, $lineHeight=0, $lineWidth=0, $tempVal=0
Global $letter="", $data="", $dataAll=""
Global $charStartPos=0, $charEndPos=0, $leftMostCol=0, $rightMostCol=0
Global $a=0, $x=0, $y=0
Global $partLetterStart=0, $partLetterEnd=0, $partLetterMax=0, $partLetter=0, $matchVal=0
Global $shadeVariation=0, $shadeVariationCubed=0, $blue2=0, $green2=0, $red2=0, $blue2min=0, $blue2max=0, $green2min=0, $green2max=0, $red2min=0, $red2max=0
Global $cumulativeLineHeight=0, $cumulativeLineWidth=0, $numberOfLines=0
Global Const $spaceMult = 1.5
global $fontFile

Global $pixelCheckTime=0, $pixelArrTime=0


#CS
Optical Character Recognition system for screen text under Autoit
Original by civilcalc, 04 July 2011 [from http://www.autoitscript.com/forum/topic/130046-autoit-ocr-without-3rd-party-software/]
2012 Sept, 30th: Updated and errors corrected by David Mckenzie
                            also added _learnCharsWithWord to somewhat automate learning fonts
                            and _mouseOCR to allow simpler definition of OCR zone
2012 Oct, 29th: Rewritten to improve speed and features by David Mckenzie

Notes:-
 $ocrLearn allows a character to be automatically associated with the first recognised character in a block of text
 If you want to operate in batch mode (and ignore any unknown characters), set $ocrLearn = -1
 If $ocrLearn is not set, then an input box will be displayed requesting the value of any unknown characters
 Opt("PixelCoordMode",$param) determines what relative coordinates are referenced (used by PixelSearch)


The basic concept is as follows;
Pick a line of text to be scanned, the tighter the area, the better it performs.
 The bounding box is then shrunk to exclude any whitespace at the edges.
If the entire row of lowermost pixels is active, then it is assumed the line has an underline
 this row will therefore be ignored.
An array is then created with the same number of elements as the width of the selection, and
 filled with a binary representation of each column
Pixelsearch is used to check each pixel in the first vertical line.
If a pixel is not of the background colour (specIfied as $bkgndColour and variation by $bkgndShadeVariation)
 then it is assigned a value: the uppermost pixel is considered to be worth 1, the next pixel 2, then 4, 8, 16 etc.
Once each column is summed the next is checked.
After the summation process any whitespace above each individual character is removed, so it can still
 be recognised If it's together with characters taller or shorter than it.
so the character;
pre   &    post removal of blank rows above
01  ~~~~~
02  ~###~  01
04  ~#~#~  02
08  ~###~  04
16  ~#~#~  08
32  ~#~#~  16
64  ~~~~~  32
would produce an array of 31|5|31

the array is checked from the file $font, If it already exists, it returns the character A or it asks for a definition and saves the result.
the database format is one line for each character/block with the saved letter/s preceding the @
n@ 127|2|1|1|126 @

 Problems:
 It's quite slow -
 Average is about 10msec per 5x10pixel character
 However to compensate for this it's much more accurate than Tesseract or MODI based OCR for screen text.
 The script can only recognise one line of text at a time. You will have to iterate through the text you wish to recognise one line/row at a time.
 Characters must be divided from each other by a column of whitespace. If they are not, they will have to be learnt as pairs/triples, etc.
   Kerned fonts can thus be a bit of a nuisance (eg {f} and {t} will often have to be learnt as a block with another character
     The script includes code which scans unrecognised blocks to see If they're made up of previously learnt characters and assumes a split
      however this can mean some characters are recognised as components of others (eg the first half of w might be recognised as v)
   Italic fonts are also not feasible to learn with the script as it is
     A possible fix for this would be to find a tall straight letter such as |, I, l, D or B and use this to calculate the row offset (relative to base row) and compensate for this when using PixelSearch to build the array, or alternatively (but probably with more errors) just use a standard slant angle and calculate pixel corrections based on this.
 Single characters with a blank vertical line internally will be seen as two characters (eg quote {"})
 Spaces aren't always recognised correctly - depending on the size of the gap between characters.
 Underline isn't handled robustly, and some characters (eg _ or -) may be seen as If they are underlined If they are recognised alone, and are more than one pixel row thick
 Characters with the same shape, but dIfferent vertical positioning will be confused (eg {'} and {,} in some fonts
#CE

#include-once
#include <_PixelGetColor.au3>	; needed for screen capture to memory and pixel examination

#include <GUIConstantsEx.au3>	; used by learnFonts and mouseOCR for GUI windows

#include <Misc.au3>			; needed for mousepress trapping in mark_Rect called by mouseOCR
#include <WindowsConstants.au3>	; used by mark_Rect called by mouseOCR

#include <SciTE UDF.au3>	; needed for moving to correct line in SciTE when debugging


$blackPix = 0x000000
$whitePix = 0xFFFFFF

;mouseOCR()
;ConsoleWrite( _OCR(200,200,700,700) )
;ConsoleWrite( _OCR(210, 195, 400, 215))		; Title
;ConsoleWrite( _OCR(236, 202, 241, 209))
;_OCR(349, 366, 714, 455)		; Part Body
;_OCR(349, 366, 714, 949)		; Entire Body
;ConsoleWrite( _OCR(0, 0, @DesktopWidth, @DesktopHeight))		; Entire Desktop

;ConsoleWrite( _OCR(210, 195, 714, 949))		; Entire Body
;InputBox("","",mouseOCR())
;_OCR(20,161,1254,970)			; page of text in Word


learnFonts()

Func learnFonts()
	If $fontFile = "" Then $fontFile = @ScriptDir & "\OCRFontData.txt"
	If StringInStr($fontFile, "\") = 0 Then $fontFile = @ScriptDir & "\" & $fontFile

	Local $font, $msg
	Local $bkgndColour = 0xFFFFFF, $bkgndShadeVariation = 100

	Local $fontArr[5]
	$fontArr[0] = "Tahoma"
	$fontArr[1] = "Times New Roman"
	$fontArr[2] = "Arial"
	$fontArr[3] = "Calibri"
	$fontArr[4]= "Frutiger 45 Light"


	$fontGUIHWnd = GUICreate("FontGUI",50,50,0,0)
    $controlID = GUICtrlCreateLabel("1", 10, 20)
    GUISetState()	; show the window

    ; Run the GUI until the fonts have been iterated through is closed
	For $fontArrIter = 0 To UBound($fontArr) - 1
		For $fontSize = 10 To 12
			ConsoleWrite("Learning: " & $fontArr[$fontArrIter] & " " & $fontSize & "pt" & @CRLF)
			FileWriteLine($fontFile, "*******************************************")
			FileWriteLine($fontFile, "******* " & $fontArr[$fontArrIter] & " " & $fontSize & "pt *******")
			FileWriteLine($fontFile, "*******************************************")
			GUICtrlSetFont ( $controlID, $fontSize , 400 , 0 , $fontArr[$fontArrIter] )
			; Now iterate through all printable character (skipping chr(32)={space})
			For $iter = 33 To 126
				GUICtrlSetData ( $controlID, Chr($iter) )
				$msg = GUIGetMsg()
				If $msg = $GUI_EVENT_CLOSE Then Exit
				_OCR(5, 45, 30, 70, $bkgndColour, $bkgndShadeVariation, $fontFile, Chr($iter))
			Next
		Next
	Next
EndFunc   ;==>learnFont


Func mouseOCR()
	local $xStart=0, $yStart=0, $xEnd=0, $yEnd=0
	Mark_Rect($xStart, $yStart, $xEnd, $yEnd)

	consoleWrite(@CRLF & "Starting OCR of region:-" & @CRLF)
	consoleWrite("   _OCR(" & $xStart & "," & $yStart & "," & $xEnd & "," & $yEnd & ")" & @CRLF)
	$OCRString = _OCR($xStart, $yStart, $xEnd, $yEnd)
	ConsoleWrite($OCRString)
	Return $OCRString
EndFunc   ;==>mouseOCR

Func _OCR($left, $top, $right, $bottom, $bkgndColour = 0xFFFFFF, $bkgndShadeVariation = 100, $fontFile = "", $ocrLearn = "")
	AutoItSetOption("TrayIconDebug", 1)

;	local ocrOptMatchBlack = 1, ocrOptMatchNotWhite = 2, ocrOptMatchBox = 4, ocrOptMatchBox = 8, ocrOptLearnMode = 16
	resetGlobals()

	$startTime = TimerInit()
	If $fontFile = "" Then $fontFile = @ScriptDir & "\OCRFontData.txt"
	If StringInStr($fontFile, "\") = 0 Then $fontFile = @ScriptDir & "\" & $fontFile
	If Not FileExists($fontFile) Then
		FileWriteLine($fontFile, "**************************************" & @CRLF)
		FileWriteLine($fontFile, "****** AutoIt OCR Font Data **********" & @CRLF)
		FileWriteLine($fontFile, "**************************************" & @CRLF)
		FileWriteLine($fontFile, " " & @TAB & "space" & @CRLF)
	EndIf
	$database = FileRead($fontFile) ;read database


	;	ConsoleWrite ("Starting OCR..." & @CRLF)
	$grabWidth = $right - $left + 1
	$grabHeight = $bottom - $top + 1
	Global $screenGrabArray[$grabWidth + 1][$grabHeight + 1]
	Global $rowArray[$grabHeight + 1]
	Global $columnArray[$grabWidth + 1]
	Global $columnWeightArray[$grabWidth + 1]

	debugStep(@ScriptLineNumber)
	; load the area of screen into memory
	; using _PixelGetColor functions cf pixelSearch results in approx 5% increase in speed using colourMatch
	;  and approx 20% using colourMatchWhite or colourMatchBlack.
	; However importantly it dramatically speeds up grabbing the screen and therefore reduces errors if the screen changes
	$hDll = DllOpen("gdi32.dll")
	$vDC = _PixelGetColor_CreateDC($hDll)
	$mousePosX = MouseGetPos(0)
	$mousePosY = MouseGetPos(1)
	MouseMove(@DesktopWidth,@DesktopHeight/2,0)	; move the mouse out the way so it isn't included in the screen shot
	$vRegion = _PixelGetColor_CaptureRegion($vDC, $left, $top, $right, $bottom, $hDll)
	MouseMove($mousePosX, $mousePosY,0)
	; $bkgndColour should be in AutoIt default RGB format, but it's quicker to process as BGR in the loop, so convert to this
	colourMatchInit(colourRGBToBGR($bkgndColour), $bkgndShadeVariation)
	debugStep(@ScriptLineNumber, "grabTime", TimerDiff($startTime))
	For $y = 0 To $grabHeight
		$rowArrayVar = 0
		For $x = 0 To $grabWidth
			; load the main array with the screen area looking for pixels different to the background colour
			; If you wanted to add a mask (to compensate for varied backgrounds) here would be the place to do it
			; get pixel colour in decimal BGR (code pulled from _PixelGetColour to reduce overhead from function call)
;			$starttime1 = TimerInit()
			$pixelColour = DllCall($hDll,"int","GetPixel","int",$vDC,"int",$x,"int",$y)
;			$pixelCheckTime = $pixelCheckTime + TimerDiff($starttime1)
;			$pixelColour = colourMatchBlack($pixelColour[0])		; approx 20% faster than colourMatchWhite
			$pixelColour = Not colourMatchWhite($pixelColour[0])
;			$pixelColour = Not colourMatchBox($pixelColour[0])
;			$pixelColour = colourMatchSphere($pixelColour[0])	; may not work - not tested yet

;			$starttime1 = TimerInit()
			$screenGrabArray[$x][$y] = $pixelColour
;			$pixelArrTime = $pixelArrTime + TimerDiff($starttime1)
			; Accessing arrays in AutoIt seems to be very inefficient - a named variable seems to be 10-20 times faster
			$rowArrayVar = $rowArrayVar + $pixelColour ; count the active pixels in each row
		Next
		$rowArray[$y] = $rowArrayVar ; access the array just once every row
	Next
	_PixelGetColor_ReleaseRegion($vRegion)
	_PixelGetColor_ReleaseDC($vDC,$hDll)
	DllClose($hDll)
	$arrayGrabTime = TimerDiff($startTime)
;	ConsoleWrite($pixelCheckTime & ", " & $pixelArrTime & " of " & $arrayGrabTime)
	$startTime = TimerInit()
	debugStep(@ScriptLineNumber, "$arrayGrabTime", $arrayGrabTime)

	; Just for debugging purposes - output the array to the console
	if $debugCode < 2 Then outputArray(0,0,$grabWidth, $grabHeight, $screenGrabArray)

	For $y = 0 To $grabHeight

		Do		; loop repeatedly through this to ensure the tightest bounding boxes possible
			$yInit = $y
			$blankedSome = False

			; find the topmost non-blank line
			While $rowArray[$y] = 0
				$y = $y + 1
				If $y > $grabHeight Then ExitLoop 3 ; Finished iterating through all lines in the selected area, so return
			WEnd
			$topRowInLine = $y


			If $ocrLearn <> "" And $ocrLearn <> -1 Then
				; if we're only learning one character you have to search for a non-blank row from the bottom, else you will mis-recognise characters
				;  with horizonal white space within them (eg : a colon)
				$y = $grabHeight
				While $rowArray[$y] = 0
					$y = $y - 1
					If $y < 1 Then ExitLoop
				WEnd
				$bottomRowInLine = $y
			Else
				; Assume that if not training to learn the font database then there will be enough characters to have at least one
				; pixel in each row occupied by the line, so identify the lower border of the line of text by the next blank row of pixels
				While $rowArray[$y] > 0
					$y = $y + 1
					If $y > $grabHeight Then ExitLoop
				WEnd
				$bottomRowInLine = $y - 1
			EndIf
			$lineHeight = $bottomRowInLine - $topRowInLine ; NB obscurely the first row is counted as zero so a normal person would add one to the line height count
			$cumulativeLineHeight = $cumulativeLineHeight + $lineHeight + 1
			$numberOfLines = $numberOfLines + 1
																								debugStep(@ScriptLineNumber,"$lineHeight",$lineHeight)

			;		sumPixels($grabWidth, $topRowInLine, $bottomRowInLine, $screenGrabArray, $columnArray, $columnWeightArray, $lineHeight)
			;create an array which contains the sum of the pixels in each column for the scan area
			For $x = 0 To $grabWidth
				$val = 0 ;reset the value to zero for next vertical line
				$p = 1
				For $y = $topRowInLine To $bottomRowInLine
					;scan each vertical line in the scan area looking for pixels different to the background colour
					If $screenGrabArray[$x][$y] Then $val = $val + $p ;create a value of the vertical line based on the pixels present
					$p = $p * 2
				Next
				$columnArray[$x] = $val ;load the value into the array
				$columnWeightArray[$x] = bitMin($val, $lineHeight + 1) ; now fill $columnWeightArray with the weight of the minimum bit for each column (so characters can be bitshifted to eliminate whitespace above them
			Next

			; figure out where the 'true' begin and end of the line are (ie ignore 'whitespace')
			$leftMostCol = 0
			While $columnArray[$leftMostCol] = 0
				$leftMostCol = $leftMostCol + 1
			WEnd
			$rightMostCol = $grabWidth
			While $columnArray[$rightMostCol] = 0
				$rightMostCol = $rightMostCol - 1
			WEnd
			$lineWidth = $rightMostCol - $leftMostCol + 1
			$cumulativeLineWidth = $cumulativeLineWidth + $lineWidth
																					debugStep(@ScriptLineNumber,"$lineHeight",$lineHeight,"$lineWidth",$lineWidth)
			; Just for debugging purposes - output the array to the console
			if $debugCode < 2 Then outputArray($leftMostCol, $topRowInLine, $rightMostCol, $bottomRowInLine, $screenGrabArray)


			; If automatic training, then we don't have to bother with attempting to recognise the character
			;   so don't fiddle about with the rest, just write to the database file then return
			If $ocrLearn <> "" And $ocrLearn <> -1 Then
				$pattern = generateString($leftMostCol,$rightMostCol, $columnWeightArray, $columnArray)
;				If Not StringInStr($database,$pattern) Then
					FileWriteLine($fontFile,$ocrLearn & $pattern & @CRLF)
;				EndIf
				Return
			EndIf

			; blank any rows which are (mostly) solid horizontal lines (these are likely to be strikethough or underline)
			For $y = $topRowInLine To $bottomRowInLine
				If $rowArray[$y] >= $lineWidth * 0.95 Then
					For $x = 0 To $grabWidth
						$screenGrabArray[$x][$y] = False
					Next
					$rowArray[$y] = 0
					$blankedSome = True
				EndIf
			Next
			If $blankedSome Then $y = $yInit
		Until $blankedSome = False
																					debugStep(@ScriptLineNumber,"$lineWidth",$lineWidth,"$lineHeight",$lineHeight)
		; Just for debugging purposes - output the array to the console
		if $debugCode < 2 Then outputArray($leftMostCol, $topRowInLine, $rightMostCol, $bottomRowInLine, $screenGrabArray)

		;		avBlankColumn($leftMostCol, $rightMostCol, $columnArray, $avBlankWidth, $newBlank, $blankBlockCount, $blankColCnt)
		; figure out the average size of blank columns. This can be used to estimate spaces vs gaps between characters
		$blankBlockCount=0
		$blankColCnt=0
		$avBlankWidth=0
		$newBlank = False
		For $a = $leftMostCol To $rightMostCol
			If $columnArray[$a] > 0 Then
				$newBlank = True
			Else
				; create a running total of blanks - average size will be used for guessing the size of spaces in the text
				If $newBlank Then $blankBlockCount = $blankBlockCount + 1
				$blankColCnt = $blankColCnt + 1
				$newBlank = False
			EndIf
		Next
		$avBlankWidth = ($blankColCnt / $blankBlockCount) * $spaceMult
																				debugStep(@ScriptLineNumber,"$avBlankWidth",$avBlankWidth,"$blankColCnt",$blankColCnt,"$blankBlockCount",$blankBlockCount)
		For $a = $leftMostCol To $rightMostCol
			If $columnArray[$a] > 0 Then
				$blankColCnt = 0
			Else
				; create a running total of blanks - average size will be used for guessing the size of spaces in the text
				$blankColCnt = $blankColCnt + 1
				If $blankColCnt > $avBlankWidth Then
					; we assume it's a space
					$columnArray[$a-1] = -99
					$columnWeightArray[$a-1] = 0
					$blankColCnt = 0
				EndIf
			EndIf
		Next


;		searchForChars($leftMostCol, $rightMostCol, $columnArray, $data)
		;now begin searching for characters
		$charStartPos = $leftMostCol
		While $charStartPos <= $rightMostCol
																				debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos, "$letter", $letter, "$data", $data)
			$charEndPos = $charStartPos
			; Now move $charStartPos to the next non-blank column
			$charTempPos = $charStartPos						; Don't know why, but I'm getting an error here which means $charStartPos is reset to 0 on initiating the for loop
			For $charStartPos = $charTempPos To $rightMostCol
;																				$tempVal = $columnArray[$charStartPos]
;																				debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos, "$letter", $letter, "$data", $data)
				If $columnArray[$charStartPos] <> 0 Then ExitLoop
			Next
																				debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos, "$letter", $letter, "$data", $data)

			; find the first blank column following the current block
			For $charEndPos = $charStartPos + 1 To $rightMostCol
				If $columnArray[$charEndPos] = 0 Then ExitLoop
			Next
			; look for a complete match of a block, if not found, progressively shrink the end and attempt to dissect the block into adjoining characters
			$letter = ""
			$blockStart = $charStartPos
			$blockEnd = $charEndPos
			While $charEndPos > $charStartPos
				$charEndPos = $charEndPos -1
																			debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos, "$letter", $letter, "$data", $data)
				$matchLoc = checkForMatch($columnArray, $charStartPos, $charEndPos, $columnWeightArray, $database)
																			debugStep(@ScriptLineNumber, "$matchLoc",$matchLoc)
				If $matchLoc Then
					; we've found a letter/s matching the current portion, so remember this
					$letter = $letter & getLetter($matchLoc, $database)
					$charStartPos = $charEndPos + 1
					$charEndPos = $blockEnd
				EndIf
			WEnd

;			$debugCode = 0
			; If it couldn't completely split the block and not in batch mode then ask the user for help in interpreting the block
			If $charStartPos < $blockEnd And $ocrLearn <> -1 Then
				;no character recognised in database, so create an image (as a string) and ask for an input
				$image = ""
				For $y = $topRowInLine To $bottomRowInLine
					For $x = $blockStart To $blockEnd - 1
						If $screenGrabArray[$x][$y] = 1 Then
							$image = $image & "#"
						Else
							$image = $image & "~"		; use tilde as it's the same width as a # (unlike a space or a .) otherwise you get kerning of the lines of the image
						EndIf
					Next
					$image = $image & @CRLF
				Next

				; Now calculate the required size of the msgbox to display the pattern
				$boxWidth = ($blockEnd - $blockStart) * 8 + 40
				if $boxWidth < 200 then $boxWidth = 200
				if $boxWidth > @DesktopWidth then $boxWidth = @DesktopWidth
				$boxHeight = ($bottomRowInLine - $topRowInLine) * 13 + 120
				if $boxHeight < 500 then $boxHeight = 500
				if $boxHeight > @DesktopHeight then $boxHeight = @DesktopHeight
				; And display it
				$userResponse = InputBox("Unknown Character","Please identify this pattern" & @cr & "(or just OK to skip learning it):-" & @cr & $data & @cr & @cr & $image,$letter,"",$boxWidth,$boxHeight,@DesktopWidth-$boxWidth,@DesktopHeight-$boxHeight)
				If @error = 1 Then		;The Cancel button was pushed.
					$pattern = generateString($charStartPos,$blockEnd, $columnWeightArray, $columnArray)
					FileWriteLine($fontFile,"err" & @TAB & "!" & StringMid($pattern,2) & @CRLF)
					SetError (-2)
					Return
				Else
					If $letter = $userResponse Then
						; User didn't add anything to the guess
						$pattern = generateString($charStartPos,$blockEnd-1, $columnWeightArray, $columnArray)
						FileWriteLine($fontFile,"err" & @TAB & "!" & StringMid($pattern,2) & @CRLF)
					ElseIf $letter = StringLeft($userResponse,StringLen($letter)) Then
						;The guess split letters correctly, so just write the remainder to the database
						$letter = StringMid($userResponse,StringLen($letter)+1)
						$pattern = generateString($charStartPos,$blockEnd-1, $columnWeightArray, $columnArray)
						FileWriteLine($fontFile,$letter & $pattern & @CRLF)
					Else
						;The guess was incorrect
						$letter = $userResponse
						$pattern = generateString($blockStart,$blockEnd-1, $columnWeightArray, $columnArray)
						FileWriteLine($fontFile,$letter & $pattern & @CRLF)
					EndIf
					$database = $database & $letter & $pattern & @CRLF
				EndIf
				$charStartPos = $blockEnd
			EndIf
			$data = $data & $letter
			$letter = ""
;			$debugCode = 2

																				debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos, "$letter", $letter, "$data", $data)

		WEnd

		$dataAll = $dataAll & @CRLF & $data
		if $debugCode < 2 then ConsoleWrite($data & @CRLF)
		if $debugCode < 2 then ConsoleWrite("$y="&$y)
		$data = ""
;		$debugCode = 1
	Next
	$debugCode = 1
	if $debugCode < 2 then
		$dataAll2 = StringReplace($dataAll,@CRLF,"")
		$dataAll2 = StringReplace($dataAll2," ","")
		ConsoleWrite("******************************************************************************" & @CRLF)
		ConsoleWrite("Entire screen block grabbed into array in " & int($arrayGrabTime) & " msec" & @CRLF)
		ConsoleWrite("Recognised " & StringLen($dataAll2) & " characters in " & int(TimerDiff($startTime)) & " msec" & @CRLF)
		ConsoleWrite("Average  " & Round(TimerDiff($startTime) / StringLen($dataAll2),2) & " msec per " & int(($cumulativeLineWidth) / StringLen($dataAll2)) & " x " & int($cumulativeLineHeight/$numberOfLines) & " pixel character" & @CRLF)
		ConsoleWrite($dataAll & @CRLF)
	EndIf
	$debugCode = 2
	Return StringMid($dataAll, 3) ;There's an extra @CRLF at the beginning of the string to eliminate.
EndFunc   ;==>_OCR

;***************************************************************
;*           HELPER FUNCTIONS                                  *
;***************************************************************

Func checkForMatch(ByRef $columnArray, $charStartPos, $charEndPos, ByRef $columnWeightArray, ByRef $database)
	; look in the fontfile (stored as a string in memory) for a match to the current section of the column array
	Local $matchLoc=0
	; before searching for a match
;																				debugStep(@ScriptLineNumber,"$charStartPos",$charStartPos, "$charEndPos",$charEndPos)
	$matchString = generateString($charStartPos,$charEndPos, $columnWeightArray, $columnArray)
	$matchString = $matchString & @CR
	$matchLoc = StringInStr($database, $matchString)
	Return $matchLoc
EndFunc   ;==>checkForMatch

Func generateString($charStartPos,$charEndPos, ByRef $columnWeightArray, ByRef $columnArray)
	; delete any blank rows above each letter (thus shifting the block to the top of the line)
	;  then return a string containing value of each column
	; does this by dividing all the values in the block array by the smallest pixel of any column for that character

	; find the minimum bit weight of the columns in the block
	$chrMinWeight = 999999999
	For $i = $charStartPos To $charEndPos
		If $chrMinWeight > $columnWeightArray[$i] Then $chrMinWeight = $columnWeightArray[$i]
;																							debugStep(@ScriptLineNumber,"$chrMinWeight",$chrMinWeight, "$columnArray[$i]",$columnArray[$i], "$columnWeightArray[$i]", $columnWeightArray[$i])
	Next

	;now generate a string which can be checked against/written to the database for a match
	$matchString = @TAB
	; iterate through each column in the current block and bitShift it to eliminate whitespace above the block
	For $i = $charStartPos To $charEndPos
		If $chrMinWeight > 0 Then
			$matchString = $matchString & $columnArray[$i] / (2 ^ $chrMinWeight) & "|"
		Else
			$matchString = $matchString & $columnArray[$i] & "|"
		EndIf
	Next
	$matchString = StringLeft($matchString, StringLen($matchString)-1)	;drop the trailing "|"
	Return $matchString
EndFunc

Func getLetter($endLoc, ByRef $database)
	; get the letter/s which are represented by a particular string in the database
	$startLoc = StringInStr($database, @LF, 0, -1, $endLoc - 1) ; first get the position of the preceeding linfeed
	Return StringMid($database, $startLoc + 1, ($endLoc - $startLoc - 1)) ; then return the letter it brackets
EndFunc   ;==>getLetter

Func colourMatchWhite($colour)
	; expects a colour in BGR or RGB format
	; assumes shade variaton of 100/256
;																				ConsoleWrite(@ScriptLineNumber& "," &"$colour"& "," &$colour& "," &"$colour2"& "," &$colour2& "," &"$shadeVariation"& "," &$shadeVariation & @CRLF)
	If BitAND($colour, 0xFF) < 155 Then Return False
	If BitAND(BitShift($colour, 8), 0xFF) < 155 Then Return False
	If BitAND(BitShift($colour, 16), 0xFF) < 155 Then Return False
	Return True
EndFunc   ;==>colourMatch

Func colourMatchBlack($colour)
	; expects a colour in BGR or RGB format
	; assumes shade variaton of 100/256
;																				ConsoleWrite(@ScriptLineNumber& "," &"$colour"& "," &$colour& "," &"$colour2"& "," &$colour2& "," &"$shadeVariation"& "," &$shadeVariation & @CRLF)
	If BitAND($colour, 0xFF) > 150 Then Return False
	If BitAND(BitShift($colour, 8), 0xFF) > 150 Then Return False
	If BitAND(BitShift($colour, 16), 0xFF) > 150 Then Return False
	Return True
EndFunc   ;==>colourMatch

Func colourMatchInit($colour, $shadeVariation = 0)
	; Initiallisation routine for both colourMatchBox and colourMatchSphere
	; variable names imply RGB format, but as long as both colourMatchBoxInit colour and colourMatch colour are BGR it will still work correctly
	; required globals:-
;	Global $shadeVariation, $shadeVariationCubed, $blue2, $green2, $red2, $blue2min, $blue2max, $green2min, $green2max, $red2min, $red2max

	; This needed for both box and sphere
	if ($shadeVariation < 0) Then $shadeVariation = 0
	if ($shadeVariation > 255) Then $shadeVariation = 255

	; This needed for just box
	$blue2min = BitAND($colour, 0xFF) - $shadeVariation
	If $blue2min < 0 then $blue2min = 0
	$blue2max = BitAND($colour, 0xFF) + $shadeVariation
	If $blue2max >255 then $blue2max = 255
	;
	$green2min = BitAND(BitShift($colour, 8), 0xFF) - $shadeVariation
	If $green2min < 0 then $green2min = 0
	$green2max = BitAND(BitShift($colour, 8), 0xFF) + $shadeVariation
	If $green2max >255 then $green2max = 255
	;
	$red2min = BitAND(BitShift($colour, 16), 0xFF) - $shadeVariation
	If $red2min < 0 then $red2min = 0
	$red2max = BitAND(BitShift($colour, 16), 0xFF) + $shadeVariation
	If $red2max >255 then $red2max = 255

	; This needed for just sphere
	$shadeVariationCubed = $shadeVariation^3
	;
	$blue2 = BitAND($colour, 0xFF)
	$green2 = BitAND(BitShift($colour, 8), 0xFF)
	$red2 = BitAND(BitShift($colour, 16), 0xFF)
EndFunc

Func colourMatchBox($colour)
	; checks if $colour matches the colour used to set up in colourMatchInit
	; match true if within the box defined in colourMatchInit
	; You need to initialise with colourMatchBoxInit prior to use
	; variable names imply RGB format, but as long as both colourMatchBoxInit colour and colourMatch colour are BGR it will still work correctly
	$blue1 = BitAND($colour, 0xFF)
	If $blue1 < $blue2min Or $blue1 > $blue2max Then Return False

	$green1 = BitAND(BitShift($colour, 8), 0xFF)
	If $green1 < $green2min Or $green1 > $green2max Then Return False

	$red1 = BitAND(BitShift($colour, 16), 0xFF)
	If $red1 < $red2min Or $red1 > $red2max Then Return False

	Return True
EndFunc   ;==>colourMatch

Func colourMatchSphere($colour)
	; checks if $colour matches the colour used to set up in colourMatchInit
	; instead of a box along the various colour axes, this uses a sphere
	; You need to initialise with colourMatchInit prior to use
	; variable names imply RGB format, but as long as both colourMatchBoxInit colour and colourMatch colour are BGR it will still work correctly
	$blueDiff = BitAND($colour, 0xFF) - $blue2
	$greenDiff = BitAND(BitShift($colour, 8), 0xFF) - $green2
	$redDiff = BitAND(BitShift($colour, 16), 0xFF) - $red2
;	debugStep(@ScriptLineNumber, "$colour",$colour,"$blueDiff",$blueDiff,"$greenDiff",$greenDiff,"$redDiff",$redDiff,"$shadeVariationCubed",$shadeVariationCubed,"diff",Int($blueDiff * $greenDiff * $redDiff ) < $shadeVariationCubed)
	If Int($blueDiff * $greenDiff * $redDiff ) < $shadeVariationCubed Then Return True

	Return False
EndFunc   ;==>colourMatch

func colourRGBToBGR($colour)
	;converts RGB <-> BGR (ie both directions)
;	BGR value = (blue * 65536) + (green * 256) + red
;	RGB value = (red * 65536) + (green * 256) + blue

	$blue = BitShift(BitAND($colour, 0xFF),-16)
	$green = BitAND($colour, 0xFF00)
	$red = BitAND(BitShift($colour, 16), 0xFF)

	Return $blue + $green + $red
EndFunc


Func bitMin($numToCheck, $maxPower = -1)
	If $numToCheck <= 1 Then Return -1
	; returns the weight(=location) of the lowest bit set
	If $maxPower = -1 Then $maxPower = Ceiling(Log($numToCheck) / Log(2))
	For $bitCnt = 0 To $maxPower
		If BitAND($numToCheck, BitShift(1, -$bitCnt)) > 0 Then
			Return $bitCnt
		EndIf
	Next
	Return -1
EndFunc   ;==>bitMin

Func outputArray($left, $top, $right, $bottom, ByRef $screenGrabArray)
	; converts a 2 dimensional array of true/false values into a string for display as 2D pattern (eg in msgbox)
	Local $y, $x
	ConsoleWrite(@CRLF)
	For $y = $top To $bottom
		For $x = $left To $right
			If $screenGrabArray[$x][$y] = True Then
				$pixelChar = "#"
			Else
				$pixelChar = "."
			EndIf
			ConsoleWrite($pixelChar)
		Next
		ConsoleWrite(@CRLF)
	Next
	ConsoleWrite(@CRLF)
EndFunc   ;==>outputArray



;#include-once

;#include <Misc.au3> ; needed for key press and mouse button trapping
;#include <SciTE UDF.au3> ; needed to move to current point in SciTE when stepping through code
; if you want to enable this you will have to download it from the forum, and
; uncomment the _SciTEGoToLine($LineNo) within the function

; global $debugCode=0 ; 0= print to console then display tooltip while waiting for user input; 1=don't debug; 2=print to console only (no pause);


; #  debugStep DESCRIPTION  # =================================================================================================
; Title .........: debugStep
; AutoIt Version : 3.3.8.1+
; Language ......: English
; Description ...: Function to help script debugging.
; Author(s) .....: David
;EXAMPLES
; debugStep()       ; Displays tooltip of variable in clipboard and waits for user (depending on $debugCode option)
; debugStep( @ScriptLineNumber )       ; Prints out the linenumber, tooltip, and waits (depending on $debugCode option)
; debugStep( [@ScriptLineNumber] [,"$v1",$v2][,"$v3",$v4]...)       ; Prints out the linenumber, variables passed, tooltip, and waits (depending on $debugCode option)

; $lineMarker is optional (and can be any value, not just @ScriptLineNumber = the current line being evaluated)
; [$v1, $v2] etc must passed as a pair with a name and it's value. They don't have to be declared in the global scope

; Tooltips will be generated for a global variable whose name is copied to the clipboard (uses the eval function).
; Non-global variables from outside the function will not be reported correctly (if at all).
; You can optionally set a global variable to control debugging and switch it on and off throughout the code.
; $debugCode = 0 (default). Print to console then wait for user input while displaying tooltip of a variable name in clipboard.
;              By default the scroll-lock key is used to move on to the next step-point,
;              and the ESC key is used to exit the entire script
; $debugCode = 1 means print to console, but don't pause
; $debugCode = 2 Skip all debugging functions (return immediately function is called)
;              This saves you having to comment out the debugStep call in the code
;===============================================================================================================================


Func debugStep($lineMarker=0, $v1=0,$v2=0,$v3=0,$v4=0,$v5=0,$v6=0,$v7=0,$v8=0,$v9=0,$v10=0,$v11=0,$v12=0,$v13=0,$v14=0,$v15=0,$v16=0,$v17=0,$v18=0,$v19=0)

	if $debugCode = 2 Then Return
	Local $hDLL = DllOpen("user32.dll")
	Local $tooltipVar="", $oldClip="", $curVal=""
	Const $RArrowKey = "27", $shiftKey = "10", $scrollKey = "91", $ESCKey="1B", $mouseX1="05"

	; ideal would be to highlight the current line in SciTE independent of the cursor...
	 _SciTEGoToLine($lineMarker)
	 Send ("{home}{home}+{down}")

	If $lineMarker > 0 Then
		ConsoleWrite($lineMarker & ":")						;"Trace Line: " & $lineMarker & @CRLF)
		For $dePrintItr = 1 To @NumParams - 1 step 2
			ConsoleWrite("    " & Eval("v" & $dePrintItr) & "=" & Eval("v" & $dePrintItr+1) & ",")	;& @CRLF)
		Next
		ConsoleWrite(@CRLF)
	EndIf

	if $debugCode = 1 Then Return
	If _IsPressed($scrollKey, $hDLL) Then
		Sleep(50)
		DllClose($hDLL)
		Return
	EndIf

	while Not _IsPressed($scrollKey, $hDLL)
		; could also add some code here to assign or execute so variables could be modified on the fly within the code

		; would be nice if you could have the tooltip with the value of the currently selected variable in SciTE but ControlCommand returns blank string
		$tooltipVar = ClipGet()		; ControlCommand("[CLASS:SciTEWindow]", "", "Scintilla1", "GetCurrentSelection", "")
		$tooltipVar = StringReplace($tooltipVar,"$","")
		if IsDeclared ($tooltipVar) And $oldClip <> $tooltipVar AND False Then
			$oldClip = $tooltipVar
			$curVal = Eval($tooltipVar)
			ToolTip ( "$" & $tooltipVar & "=" & $curVal , MouseGetPos(0)+20, MouseGetPos(1)-30)
		EndIf
		Sleep(50)
		if _IsPressed($ESCKey, $hDLL) Then Exit
		if _IsPressed($mouseX1, $hDLL) Then
			MouseClick("left",MouseGetPos(0), MouseGetPos(1),2)
			send ("^c")
;			_SciTEGoToLine($lineMarker)
			While _IsPressed($mouseX1, $hDLL)
				Sleep (50)
			WEnd
		EndIf
	WEnd
	Sleep(500)

	DllClose($hDLL)
EndFunc

func resetGlobals()
	 $debugCode=2
	 $grabWidth=0
	 $grabHeight=0
	 $blankBlockCount=0
	 $blankColCnt=0
	 $avBlankWidth=0
	 $newBlank=0
	 $topRowInLine=0
	 $bottomRowInLine=0
	 $lineHeight=0
	 $lineWidth=0
	 $tempVal=0
	 $letter=""
	 $data=""
	 $dataAll=""
	 $charStartPos=0
	 $charEndPos=0
	 $leftMostCol=0
	 $rightMostCol=0
	 $a=0
	 $x=0
	 $y=0
	 $partLetterStart=0
	 $partLetterEnd=0
	 $partLetterMax=0
	 $partLetter=0
	 $matchVal=0
	 $shadeVariation=0
	 $shadeVariationCubed=0
	 $blue2=0
	 $green2=0
	 $red2=0
	 $blue2min=0
	 $blue2max=0
	 $green2min=0
	 $green2max=0
	 $red2min=0
	 $red2max=0
	 $cumulativeLineHeight=0
	 $cumulativeLineWidth=0
	 $numberOfLines=0
 EndFunc





Func Mark_Rect(ByRef $iX1, ByRef $iY1, ByRef $iX2, ByRef $iY2)
	; function from Melba23 (http://www.autoitscript.com/forum/topic/135728-how-to-i-draw-one-rectangle-on-screen/)

    Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
    Local $UserDLL = DllOpen("user32.dll")

    ; Create transparent GUI with Cross cursor
    $hCross_GUI = GUICreate("Test", @DesktopWidth, @DesktopHeight - 20, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
    WinSetTrans($hCross_GUI, "", 8)
    GUISetState(@SW_SHOW, $hCross_GUI)
    GUISetCursor(3, 1, $hCross_GUI)

    Global $hRectangle_GUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
    GUISetBkColor(0x000000)

    ; Wait until mouse button pressed
    While Not _IsPressed("01", $UserDLL)
        Sleep(10)
    WEnd

    ; Get first mouse position
    $aMouse_Pos = MouseGetPos()
    $iX1 = $aMouse_Pos[0]
    $iY1 = $aMouse_Pos[1]

    ; Draw rectangle while mouse button pressed
    While _IsPressed("01", $UserDLL)

        $aMouse_Pos = MouseGetPos()

        $hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
        $hMask = _WinAPI_CreateRectRgn($iX1,  $aMouse_Pos[1], $aMouse_Pos[0],  $aMouse_Pos[1] + 1) ; Bottom of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1,  $aMouse_Pos[1]) ; Right of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        ; Set overall region
        _WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

        If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
        Sleep(10)

    WEnd

    ; Get second mouse position
    $iX2 = $aMouse_Pos[0]
    $iY2 = $aMouse_Pos[1]

    ; Set in correct order if required
    If $iX2 < $iX1 Then
        $iTemp = $iX1
        $iX1 = $iX2
        $iX2 = $iTemp
    EndIf
    If $iY2 < $iY1 Then
        $iTemp = $iY1
        $iY1 = $iY2
        $iY2 = $iTemp
    EndIf

    GUIDelete($hRectangle_GUI)
    GUIDelete($hCross_GUI)
    DllClose($UserDLL)

EndFunc   ;==>Mark_Rect