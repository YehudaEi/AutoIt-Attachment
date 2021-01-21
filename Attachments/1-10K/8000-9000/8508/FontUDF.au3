#include <array.au3>

;===============================================================================
;
; Function Name: _FontGetList()
; Description: Returns an array with a list of all fonts currently installed on the system.
; Parameter(s): $i_opt - An Integer, 0 or 1.  0 will create a 1D array with font names only.
;								              1 will create a 2d array with font names in the first column, font file names in the second
; Requirement(s): None
; Return Value(s): 1D-2D Array = [0] or [0][0] Contains total number of fonts.
; Author(s): Simucal <simucal@gmail.com>
; Revision: 20060501A
;
;===============================================================================

Func _FontGetList($i_opt = 0)
	Dim $a_FontNames[1], $a_FontNamesFiles[1][1], $i = 1
	If @OSTYPE = "WIN32_NT" Then $regkey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
	If @OSTYPE = "WIN32_WINDOWS" Then $regkey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Fonts"
	While 1
		$s_temp = RegEnumVal($regkey, $i)
		If @error <> 0 Then ExitLoop
		$s_temp2 = RegRead($regkey, $s_temp)
		$s_temp = StringRegExpReplace($s_temp,"\s\(.*?\)(\s*)?","")
		If $i_opt = 0 Then
			ReDim $a_FontNames[ ($i + 1) ]
			$a_FontNames[$i] = $s_temp
		ElseIf $i_opt = 1 Then
			ReDim $a_FontNames[ ($i + 1) ]
			$a_FontNames[$i] = $s_temp & "|" & $s_temp2
		EndIf
		$i = $i + 1
	WEnd
	If $i_opt = 0 Then
		_ArraySort($a_FontNames)
		$a_FontNames[0]= (UBound($a_FontNames) - 1)
		Return ($a_FontNames)
	ElseIf $i_opt = 1 Then
		_ArraySort($a_FontNames) ; Sort with font names and files as a single array
		For $i = 1 to (UBound($a_FontNames) - 1) ; then split it up into 2D, so they will be alphabatized together.
			$s_fontsplit = StringSplit($a_FontNames[$i], "|")
			If IsArray($s_fontsplit) = 1 Then
				ReDim $a_FontNamesFiles[ ($i + 1) ][2]
				$a_FontNamesFiles[$i][0] = $s_fontsplit[1]
				$a_FontNamesFiles[$i][1] = $s_fontsplit[2]
			EndIf
		Next
		$a_FontNamesFiles[0][0] = (UBound($a_FontNamesFiles) - 1)
		Return ($a_FontNamesFiles)
	EndIf
EndFunc   ;==>_FontGetList

;===============================================================================
;
; Function Name: _FontSearchList()
; Description: Returns an array with search results of font names/file names from a specified search string. (i.e. "Wingding" or "ding")
; Parameter(s): $s_SearchString - A string, the name of the font you are searching for.
; $i_opt - An Integer, 0 or 1.  0 will create a 1D array with font names that match $s_SearchString.
;								1 will create a 2d array with font names that match $s_SearchString the first column, and their corresponding font file names in the second
; Requirement(s): $s_SearchString, must be a string.
; Return Value(s): 1D-2D Array = Fonts Found, [0] or [0][0] Contains total number of fonts matched.
;                  0 = no font matched the $s_SearchString
; Author(s): Simucal <simucal@gmail.com>
; Revision: 20060501A
;
;===============================================================================
Func _FontSearchList($s_SearchString, $i_opt = 0)
	If $i_opt = 0 Then Dim $a_FinalResults[1]
	If $i_opt = 1 Then Dim $a_FinalResults[1][1]
	$a_FontsNamesFiles = _FontGetList(1)
	For $i = 1 To (UBound($a_FontsNamesFiles) - 1)
		$a_SearchResults = StringRegExp($a_FontsNamesFiles[$i][0], '(?i)(.*?)?' & $s_SearchString & '(.*?)?', 0)
		If $a_SearchResults = 1 Then
			If $i_opt = 1 Then
				$x = UBound($a_FinalResults)
				ReDim $a_FinalResults[ ($x + 1) ][2]
				$a_FinalResults[$x][0] = $a_FontsNamesFiles[$i][0]
				$a_FinalResults[$x][1] = $a_FontsNamesFiles[$i][1]
			ElseIf $i_opt = 0 Then
				$x = UBound($a_FinalResults)
				ReDim $a_FinalResults[$x + 1]
				$a_FinalResults[$x] = $a_FontsNamesFiles[$i][0]
			EndIf
		EndIf
	Next
	If IsArray($a_FinalResults) = 1 Then
		If $i_opt = 0 Then $a_FinalResults[0] = (UBound($a_FinalResults) - 1)
		If $i_opt = 1 Then $a_FinalResults[0][0] = (UBound($a_FinalResults) - 1)
		Return $a_FinalResults
	Else
		Return 0
	EndIf
EndFunc   ;==>_FontSearchList

;===============================================================================
;
; Function Name: _FontSetDialog()
; Description: Returns an array with search results of font names/file names from a specified search string. (i.e. "Wingding" or "ding")
; Parameter(s): $s_SearchString - A string, the name of the font you are searching for.
; $i_opt - An Integer, 0 or 1.  0 will create a 1D array with font names that match $s_SearchString.
;								1 will create a 2d array with font names that match $s_SearchString the first column, and their corresponding font file names in the second
; Requirement(s): $s_SearchString, must be a string.
; Return Value(s): 1D-2D Array = Fonts Found, [0] or [0][0] Contains total number of fonts matched.
;                  0 = no font matched the $s_SearchString
; Author(s): Simucal <simucal@gmail.com>
; Revision: 20060501A
;
;===============================================================================
Func _FontSetDialog($Hwnd_CtrlID)
	
