
;===============================================================================
;
; Function Name:    _ScreenScrape
; Description:      Easily screen scrape any web page for the text you want
; Parameter(s):     $ss_URL  - The website to scrape
;                   $ss_1  - The string occurring before the text you want
;					$ss_2  - The string occuring after the text you want
;                   ...
;					$ss_19 - The string occurring before the text you want
;                   $v_20 - The string occuring after the text you want.
; Requirement(s):   _UnFormat, _RealFileClose, _RealFileRead, _RealFileOpen
; Return Value(s):  If only one result will return a string. If more than one
;                   result, will return an array
; Author(s):        Alterego                     
; Note(s):          Woot!
;
;===============================================================================

Func _ScreenScrape($ssURL, $ss_1, $ss_2, $ss_3 = 0, $ss_4 = 0, $ss_5 = 0, $ss_6 = 0, $ss_7 = 0, $ss_8 = 0, $ss_9 = 0, $ss_10 = 0, $ss_11 = 0, $ss_12 = 0, $ss_13 = 0, $ss_14 = 0, $ss_15 = 0, $ss_16 = 0, $ss_17 = 0, $ss_18 = 0, $ss_19 = 0, $ss_20 = 0)
	Local $ss_NumParam = @NumParams
	Local $ss_CountOdd = 1
	Local $ss_CountEven = 2
	Local $ss_Half = $ss_NumParam / 2
	Local $ss_Data[$ss_NumParam + 1]
	Local $ss_Return[$ss_Half]
	For $ss_Primer = 0 To $ss_NumParam - 1
		$ss_Data[$ss_Primer] = _UnFormat (Eval('ss_' & String($ss_Primer)))
	Next
	Global $file = @TempDir & "\" & Random(500000, 1000000, 1) & ".scrape"
	InetGet($ssURL, $file, 1, 0)
	Local $ss_Handle = _RealFileOpen ($file)
	Local $ss_ReadOnce = _RealFileRead ($ss_Handle, FileGetSize($file))
	Local $ss_PermanentStore = _UnFormat ($ss_ReadOnce[0])
	For $ss_Scrape = 0 to ($ss_NumParam - 2) / 2
		$ss_TemporaryStore = $ss_PermanentStore
		$ss_TemporaryStore = StringTrimLeft($ss_TemporaryStore, StringInStr($ss_TemporaryStore, $ss_Data[$ss_CountOdd], 1, 1) + StringLen($ss_Data[$ss_CountOdd]) - 1)
		$ss_TemporaryStore = StringTrimRight($ss_TemporaryStore, StringLen($ss_TemporaryStore) - StringInStr($ss_TemporaryStore, $ss_Data[$ss_CountEven]) + 1)
		$ss_CountOdd = $ss_CountOdd + 2
		$ss_CountEven = $ss_CountEven + 2
		$ss_Return[$ss_Scrape] = $ss_TemporaryStore
	Next
	_RealFileClose ($ss_Handle)
	FileDelete($file)	
	If UBound($ss_Return) = 1 Then 
		Return $ss_Return[0]
	Else
		Return $ss_Return
	EndIf
EndFunc   

Func _UnFormat( $ufVar )
	$ufVar = StringReplace($ufVar,@CRLF,'',0,0)
	$ufVar = StringReplace($ufVar,@LF,'',0,0)
	$ufVar = StringStripCR($ufVar)
	Return $ufVar
EndFunc

Func _RealFileClose($hFile)
	Local $RFC_r
	$RFC_r = DllCall( "kernel32.dll", "int", "CloseHandle", _
			"hwnd", $hFile)
	Return $RFC_r[0]
EndFunc   ;==>_RealFileClose
Func _RealFileSetReadPos($hFile, $nPos)
	Local $FILE_BEGIN = 0
	Local $RFSRP_r
	$RFSRP_r = DllCall( "kernel32.dll", "long", "SetFilePointer", _
			"hwnd", $hFile, _
			"long", $nPos, _
			"long_ptr", 0, _
			"long", $FILE_BEGIN)
	Return $RFSRP_r[0]
EndFunc   ;==>_RealFileSetReadPos
Func _RealFileRead($hFile, $nBytes)
	Local $RFR_ret[2]
	Local $RFR_r
	Local $RFR_n
	Local $RFR_str = ""
	Local $RFR_b
	$RFR_b = $nBytes + 1
	While $RFR_b >= 10000
		For $RFR_n = 1 To 100
			$RFR_str = $RFR_str & "                                                  " & _
					"                                                  "
		Next
		$RFR_b = $RFR_b - 10000
	WEnd
	While $RFR_b >= 100
		$RFR_str = $RFR_str & "                                                  " & _
				"                                                  "
		$RFR_b = $RFR_b - 100
	WEnd
	While $RFR_b >= 10
		$RFR_str = $RFR_str & "          "
		$RFR_b = $RFR_b - 10
	WEnd
	While $RFR_b >= 1
		$RFR_str = $RFR_str & " "
		$RFR_b = $RFR_b - 1
	WEnd
	$RFR_r = DllCall( "kernel32.dll", "int", "ReadFile", _
			"hwnd", $hFile, _
			"str", $RFR_str, _
			"long", $nBytes, _
			"long_ptr", 0, _
			"ptr", 0)
	$RFR_ret[0] = $RFR_r[2]
	$RFR_ret[1] = $RFR_r[4]
	Return $RFR_ret
EndFunc   ;==>_RealFileRead
Func _RealFileOpen($szFile)
	Local $GENERIC_READ = 0x80000000
	Local $OPEN_EXISTING = 3
	Local $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $RFO_h
	$RFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
			"str", $file, _
			"long", $GENERIC_READ, _
			"long", 0, _
			"ptr", 0, _
			"long", $OPEN_EXISTING, _
			"long", $FILE_ATTRIBUTE_NORMAL, _
			"long", 0)
	Return $RFO_h[0]
EndFunc   ;==>_RealFileOpen