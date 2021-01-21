#include-once
; ----------------------------------------------------------------------------
;
; AutoIt Version: v3.1.1.121 (beta) used to make
; Author:         Onoitsu2 <Onoitsu2@yahoo.com>
;
; Script Function: _CheckTimeBlock()
;	Checks if your system time is within a timeblock and returns
;	0 if it IS in the range, or 1 if it is NOT.
;
;	Nifty Feature=============>	A range can be from say, 10:00-08:59
;								you can have a range include the mid-night
;								THIS IS THE REASON FOR THE LARGE CODE...
;								Took 6 written pages (drafts) to get code correct
;								had to do on paper as was not at computer
;								when I had the idea.
;
;	Works with times in following formats (ALL Military):
;		USE:	TRANSLATES TO:
;		00:30 = 12:30AM
;		13:30 = 1:30PM
;		etc.  = etc.
;
;	Example Call: _CheckTimeBlock(00,30,01,30)
;
; ----------------------------------------------------------------------------

Func _CheckTimeBlock($tsh=0,$tsm=0,$teh=0,$tem=0)
	
If NOT ($tsh = 0 AND $tsm = 0 AND $teh = 0 AND $tem = 0) Then
	IF NOT ($tsh = $teh AND $tsm = $tem) Then
		$times_starth = $tsh
		$times_startm = $tsm
		$times_endh = $teh
		$times_endm = $tem
	Else
		SetError(1) ; Start and End Times are Equal!!
		Return 0 ; Since timeblock is a full 24hour period any time really is IN this timeblock
	EndIf
Else
	If ($times_starth = $times_endh AND $times_startm = $times_endm) Then
		SetError(1) ; Start and End Times are Equal!!
		Return 0 ; Since timeblock is a full 24hour period any time really is IN this timeblock
	EndIf
	If $times_endh < $times_starth Then
		If @HOUR = 0 Then
			If @HOUR < $times_endh Then
				Return 0
			ElseIf @HOUR = $times_endh Then
				If @MIN >= $times_endm Then
					Return 1
				Else
					Return 0
				EndIf
			EndIf
		ElseIf @HOUR <= 23 Then
			If @HOUR < $times_starth Then
				If @HOUR < $times_endh Then
					Return 0
				ElseIf @HOUR = $times_endh Then
					If @MIN >= $times_endm Then
						Return 1
					Else
						Return 0
					EndIf
				EndIf
				Return 1
			ElseIf @HOUR = $times_starth Then
				If @MIN >= $times_startm Then
					Return 0
				Else
					Return 1
				EndIf
			ElseIf @HOUR > $times_starth Then
				If @HOUR < $times_endh Then
					Return 0
				Else
					Return 1
				EndIf
			EndIf
		EndIf
	ElseIf $times_endh > $times_starth Then
		If @HOUR > $times_starth Then
			If @HOUR < $times_endh Then
				Return 0
			ElseIf @HOUR = $times_endh Then
				If @MIN >= $times_endm Then
					Return 1
				Else
					Return 0
				EndIf
			ElseIf @HOUR > $times_endh Then
				Return 1
			EndIf
		ElseIf @HOUR = $times_starth Then
			If @MIN >= $times_startm Then
				Return 0
			Else
				Return 1
			EndIf
		ElseIf @HOUR < $times_starth Then
			Return 1
		EndIf
	ElseIf $times_endh = $times_starth Then
		If @MIN >= $times_endm Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
EndIf
EndFunc

; ----------------------------------------------------------------------------
;
; AutoIt Version: v3.1.1.121 (beta) used to make
; Author:         Onoitsu2 <Onoitsu2@yahoo.com>
;
; Script Function: _FormatTimeBlock()
;	Formats a given timeblock for use with the _CheckTimeBlock() function.
;	This makes it so a parameter is not required by the _CheckTimeBlock()
;	function, so it makes using in an Adlib easier. To change the time of
;	the Adlib'd _CheckTimeBlock() make a call to this function with a
;	timeblock variable, or string in the format: "00:00-00:00"
;
;	Example Call: _FormatTimeBlock($timeblock)
;				  _FormatTimeBlock("00:30-13:30")
;
; ----------------------------------------------------------------------------

Func _FormatTimeBlock($times)
If StringInStr($times,"-") Then
	$dashpos = StringInStr($times,"-")
	$times_start = StringMid($times,1,$dashpos-1)
	Global $times_starth = StringLeft($times_start,2)
	Global $times_startm = StringRight($times_start,2)
	$times_end = StringMid($times,$dashpos+1,StringLen($times))
	Global $times_endh = StringLeft($times_end,2)
	Global $times_endm = StringRight($times_end,2)
Else
	Global $times_starth = StringLeft($times,2)
	Global $times_startm = StringRight($times,2)
	Global $times_endh = StringLeft($times,2) + 1
	Global $times_endm = StringRight($times,2) + 1
EndIf
EndFunc