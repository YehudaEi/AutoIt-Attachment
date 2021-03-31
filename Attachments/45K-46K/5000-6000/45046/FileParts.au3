const $DriveLetter = 0
const $FullPath = 1
const $FullFileName = 2
const $FileTitle = 3
const $FileExt = 4

Func StrPos($source, $src, $GotoEnd = False)
	;This is my custom function to find the position of a string within a string.
	;More than likey there is an easyer way to do this but this seems to work
	Local $i
	Local $Len
	Local $idx

	$idx = 0
	$Len = StringLen($src)

	For $i = 1 To StringLen($source)
		If StringCompare(StringMid($source, $i, $Len),$src) = 0 Then
			$idx = $i
			If Not $GotoEnd Then
				ExitLoop
			EndIf
		EndIf
	Next
	Return $idx
EndFunc
;==>StrPos

Func GetFilePart($s, $index)
	Local $pos, $epos
	Local $Parts[5]

	;Check for drive
	$pos = StrPos($s, ":\")

	If ($pos > 0) Then
		;Return drive Letter
		$Parts[0] = StringUpper(StringLeft($s, $pos-1))
	EndIf

	;Check for slash backslash
	$pos = StrPos($s, "\", True)

	If ($pos > 0) Then
		;Return full path
		$Parts[1] = StringLeft($s, $pos)
	EndIf

	;Get filename
	If ($pos > 0) Then
		$Parts[2] = StringMid($s, $pos + 1)
	EndIf

	;Get file title only with out ext
	$epos = StrPos($s, ".", True)

	If ($pos > 0) And ($epos > 0) Then
		$Parts[3] = StringMid($s, $pos + 1, $epos - $pos - 1)
	EndIf

	;Get file exit
	If ($epos > 0) Then
		$Parts[4] = StringMid($s, $epos + 1)
	EndIf

	;Return item in array
	Return $Parts[$index]

EndFunc   ;==>GetFilePart
