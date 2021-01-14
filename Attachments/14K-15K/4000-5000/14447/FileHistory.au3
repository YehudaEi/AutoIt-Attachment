;~ $fTime = StringFormat( "%04d/%02d/%02d %02d:%02d:%02d", $fTimeArray[0], $fTimeArray[1], $fTimeArray[2], $fTimeArray[3], $fTimeArray[4], $fTimeArray[5])
#include-once
#include <Date.au3>
#Include <Array.au3>


; *** Example***
$sWorkFolder = "E:\Work\AutoIt3\Kobi\TestDir\"
$sFilter = "*.*"
$FileList = _FileDelOldHistory( $sWorkFolder, 3, $sFilter, False )

If @error Then
	MsgBox(0, "Error", "Error " & @error)
	Exit
EndIf

If $FileList[0] > 0 Then
	_ArrayDisplay($FileList,"Can't delete " & $FileList[0] & " file(s)")
Else
	MsgBox(0, "Congratulations!", "All files deleted succsessfully")
EndIf
; *************




;===============================================================================
;
; Description:      Delete oldest files in folder
; Syntax:           _FileDelOldHistory( WorkFolder[, HistoryOfFiles = 2[, Filter = "*"[, $bDelReadonly = True ]]] )
; Parameter(s):     $sPath           - WorkFolder
;                   $iHistoryOfFiles - How many newest files to keep (default 2)
;                   $sFilter         - File filter to process (default = *.*)
;                   $bDelReadonly    - Delete files with Readonly atribute (default True)
;
; Requirement(s):   Array.au3, Date.au3 to include
; Return Value(s):  On Success Array - Array[0] = 'n' Number of problematic files :-)
;                                      Array[1] to Array[n] = Problematic files list (Full path)
;                   On Failure       - 0  and Set @ERROR to:
;                                                1 - Directory does not exist
;                                                2 - Invalid Filter parameter
;                                                3 - No files matched the search pattern
;
;                   @error = 1       - directory does not exist

; Author(s):        Bravshtein Igal 3/05/2007
; Note(s):          None
;
;===============================================================================
Func _FileDelOldHistory($sPath, $iHistoryOfFiles = 2, $sFilter = "*", $bDelReadonly = True )

	Local $hSearch, $sFile, $sOldestFilePath, $Count = 0, $iMaxIndex, $sCurntFile
	Local $asFileList[1], $iFileAgeList[1], $asFileError[1]
	If Not FileExists($sPath) Then Return SetError(1, 1, "") ; Set error 1 if directory does not exist.
	If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
	If StringRight ( $sWorkFolder, 1 ) <> "\" Then $sWorkFolder = $sWorkFolder & "\"
	
	ReDim $asFileList[1]
	ReDim $iFileAgeList[1]
	$asFileList[0] = 0
	$iFileAgeList[0] = 0
	
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then Return SetError(3, 3, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop

		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1 ; Write Nunber of elements
		$asFileList[UBound($asFileList) - 1] = $sFile

		ReDim $iFileAgeList[$asFileList[0]+1]
		$iFileAgeList[0] = $asFileList[0] ; Write Nunber of elements
		$iFileAgeList[$asFileList[0]] = _FileAge ("s", $sPath & $sFile)
	WEnd
	FileClose($hSearch)
	
	While $iFileAgeList[0] > $iHistoryOfFiles ;+ 1
		
		$iMaxIndex = _ArrayMaxIndex ( $iFileAgeList , 1, 1)
		$iFileAgeList[$iMaxIndex] = -1 ; Reset age ( age < 0 )
		$iFileAgeList[0] -= 1 ; Write valid nunber of elements ( age >= 0 )
		$sOldestFilePath = $sPath & $asFileList[$iMaxIndex]
		ConsoleWrite( "Delete " & $asFileList[$iMaxIndex] & @LF	)
		If $bDelReadonly Then
			; Set file attributes ( Remove READONLY, Set ARCHIVE )
			If Not FileSetAttrib($sOldestFilePath, "-R+A") Then
				MsgBox(4096,"Robot Error", "Problem setting attributes to " & @LF & $sOldestFilePath, 2)
			EndIf
		EndIf
		; Delete File
		If Not FileDelete( $sOldestFilePath ) Then
;~ 				MsgBox(16, "Robot", "Can't Delete " & $sOldestFilePath )
			$Count += 1
			ReDim $asFileError[$Count + 1]
			$asFileError[$Count] = $sOldestFilePath
		EndIf
	WEnd
	$asFileError[0] = $Count
	Return $asFileError
EndFunc   ;==>_FileDelOldHistory()


Exit

;===============================================================================
;
; Description:      Returns age of file
; Syntax:           _FileAge ($sType, $sFileName[, $Flag])
; Parameter(s):     $sType - returns the difference in:
;                               d = days
;                               m = Months
;                               y = Years
;                               w = Weeks
;                               h = Hours
;                               n = Minutes
;                               s = Seconds
;                   $sFileName - Filename to check
;                   $Flag      - [optional] Flag to indicate which timestamp of file compare
;                                0 = Modified (default)
;                                1 = Created
;                                2 = Accessed
; Requirement(s):   None
; Return Value(s):  On Success - Age of file
;                   On Failure - File problem > Empty string and set @ERROR to 1
;                                Invalid sType > Empty string and set @ERROR to 2
; Author(s):        Bravshtein Igal (According to 'Date.au3' UDF, _DateDiff Function)
; Note(s):          Thanks to Jos van der Zande
;
;===============================================================================
Func _FileAge ($sType, $sFileName, $Flag = 0)
	
	Local $fTimeArray[6]
	Local $fYear, $fMonth, $fDay, $fHour, $fMin, $fSec
	Local $iYearDiff, $iMonthDiff, $iTimeDiff
	Local $iFileTimeInSecs, $iNowTimeInSecs
	Local $aDaysDiff
	
	$fTimeArray = FileGetTime($sFileName)
	If @error Then
		SetError(1)
		Return ""
	EndIf
	$fYear = $fTimeArray[0]	; year (four digits)
	$fMonth = $fTimeArray[1]; month (range 01 - 12)
	$fDay = $fTimeArray[2]	; day (range 01 - 31)
	$fHour = $fTimeArray[3]	; hour (range 00 - 23)
	$fMin = $fTimeArray[4]	; min (range 00 - 59)
	$fSec = $fTimeArray[5]	; sec (range 00 - 59)

	; Get the differens in days between the 2 dates
	$aDaysDiff = _DateToDayValue(@YEAR, @MON, @MDAY) - _DateToDayValue($fYear, $fMonth, $fDay)
	
	; Get the differens in Seconds between the 2 times
	$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
	$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
	$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
	If $iTimeDiff < 0 Then
		$aDaysDiff = $aDaysDiff - 1
		$iTimeDiff = $iTimeDiff + 24 * 60 * 60
	EndIf

	Select
		Case $sType = "d"
			Return ($aDaysDiff)
		Case $sType = "m"
			$iYearDiff = @YEAR - $fYear
			$iMonthDiff = @MON - $fMonth + $iYearDiff * 12
			If @MDAY < $fDay Then $iMonthDiff = $iMonthDiff - 1
			$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
			$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
			$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
			If @MDAY = $fDay And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return ($iMonthDiff)
		Case $sType = "y"
			$iYearDiff = @YEAR - $fYear
			If @MON < $fMonth Then $iYearDiff = $iYearDiff - 1
			If @MON = $fMonth And @MDAY < $fDay Then $iYearDiff = $iYearDiff - 1
			$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
			$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
			$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
			If @MON = $fMonth And @MDAY = $fDay And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return ($iYearDiff)
		Case $sType = "w"
			Return (Int($aDaysDiff / 7))
		Case $sType = "h"
			Return ($aDaysDiff * 24 + Int($iTimeDiff / 3600))
		Case $sType = "n"
			Return ($aDaysDiff * 24 * 60 + Int($iTimeDiff / 60))
		Case $sType = "s"
			Return ($aDaysDiff * 24 * 60 * 60 + $iTimeDiff)
		Case Else ; invalid parameter $sType
			SetError(2)
			Return ""
	EndSelect
EndFunc   ;==>_FileAge()