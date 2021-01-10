#include-once
#include <Inet.au3>
#include <String.au3>
;===============================================================================
;
; Description:      Returns an array of Movie Titles and links from IMDb
; Parameter(s):     $searchstring - Input the movie name to search for
; Requirement(s):   Includes:
;						#include <Inet.au3>
;						#include <String.au3>
; Return Value(s):  On Success - Returns an array.
;									$array[X][0] = movie name.
;									$array[X][1] = movie link.
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - No links found
;                                   @ERROR to:  2 - Couldn't Connect to IMDb
;                                   @ERROR to:  3 - Input Search String is blank
; Author(s):        Danny Williams
; Note(s):	EMAMPLE:
;				#include <array.au3>
;				#include <IMDblookup.au3>
;				#include<IE.au3>
;				$array = _IMDblookup(InputBox("IMDb Lookup Function", "Movie Name:"))
;				If @error Then
;					If @error = 1 Then MsgBox(0, "Error", "Error - " & @error & " - No Links Found" )
;					If @error = 2 Then MsgBox(0, "Error", "Error - " & @error & " - Couldn't Connect To IMDb" )
;					If @error = 3 Then MsgBox(0, "Error", "Error - " & @error & " - Input Search String Was Blank" )
;				Else
;					_ArrayDisplay($array)
;					_IECreate($array[0][1], 0, 1, 0)
;				EndIf
;===============================================================================
Func _IMDblookup($searchstring)
	If $searchstring = "" Then
		SetError( 3 )
		Return 0
	EndIf
	$searchstring = textfilter($searchstring)
	$url1 = "                                 " 
	$url2 = $searchstring
	$url3 = "&x=0&y=0" 
	$source = _INetGetSource($url1 & $url2 & $url3)
	If @error Then
		MsgBox(0, "test", $source )
		SetError( 2 )
		Return 0
	EndIf
	$tstring = _StringBetween($source, "<title>", "</title>" )
	If @error = 1 Then
		SetError( 1 )
		Return 0
	EndIf
	If $tstring[0] <> "IMDb  Search" Then
;~ 		$estring = _StringBetween( $source, "/title/", "/trailers';" )
		$estring = _StringBetween( $source, "/title/",'/">')
		If @error Then
			MsgBox(0, "TEST $source", $source )
			ClipPut( $url1 & $url2 & $url3 )
			MsgBox(0, "ERROR", "Failed to find movie" & @CRLF & 'Line' & @ScriptLineNumber & ': _StringBetween( $source, "/title/", "/trailers' & "'" & ';" )' )
			SetError( 1 )
			Return 0
		EndIf
		Dim $errorarray[1][2]
		$errorarray[0][0] = $tstring[0]
		$errorarray[0][1] = '                          ' & $estring[0] & "/"
		Return $errorarray
	EndIf
	$array = _StringBetween($source, '<a href="/title/', '/"')
	If @error = 1 Then
		SetError( 1 )
		Return 0
	EndIf
	$links = CompactArray($array)
	Dim $title[UBound($links) ]
	For $var = 0 To UBound($links) - 1
		$tempsb = _StringBetween($source, $links[$var] & '/">', "</a>")
		If @error Then
			$title[$var] = ""
		Else
			$tts = $tempsb[0]
			$tts = StringReplace($tts, "&#38;", "&")
			$tts = StringReplace($tts, "&#34;", '"')
			$title[$var] = $tts
		EndIf
	Next
	Dim $newarray[UBound($title) ][2]
	For $evar = 0 To UBound($title) - 1
		$newarray[$evar][0] = $title[$evar]
		$newarray[$evar][1] = '                          ' & $links[$evar] & "/"
	Next
	Return $newarray
EndFunc   ;==>_IMDBlookup
Func CompactArray($compactme)
	Dim $testarray[1]
	$testarray[0] = ""
	$bound = 0
	For $avar = 0 To UBound($compactme) - 1
		If StringLen($compactme[$avar]) = 9 Then
			$tester = 0
			For $bvar = 0 To UBound($testarray) - 1
				If $compactme[$avar] = $testarray[$bvar] Then $tester += 1
			Next
			If $tester = 0 Then
				ReDim $testarray[$bound + 1]
				$testarray[$bound] = $compactme[$avar]
				$bound += 1
			EndIf
		EndIf
	Next
	Return $testarray
EndFunc   ;==>CompactArray
Func textfilter($searchstring)
	$searchstring = StringReplace($searchstring, "%", "%25")
	$searchstring = StringReplace($searchstring, "!", "%21")
	$searchstring = StringReplace($searchstring, '"', "%22")
	$searchstring = StringReplace($searchstring, '#', "%23")
	$searchstring = StringReplace($searchstring, '$', "%24")
	$searchstring = StringReplace($searchstring, '&', "%26")
	$searchstring = StringReplace($searchstring, "'", "%27")
	$searchstring = StringReplace($searchstring, "(", "%28")
	$searchstring = StringReplace($searchstring, ")", "%29")
	$searchstring = StringReplace($searchstring, "+", "%2B")
	$searchstring = StringReplace($searchstring, ",", "%2C")
	$searchstring = StringReplace($searchstring, "/", "%2F")
	$searchstring = StringReplace($searchstring, ":", "%3A")
	$searchstring = StringReplace($searchstring, ";", "%3B")
	$searchstring = StringReplace($searchstring, "<", "%3C")
	$searchstring = StringReplace($searchstring, "=", "%3D")
	$searchstring = StringReplace($searchstring, ">", "%3E")
	$searchstring = StringReplace($searchstring, "?", "%3F")
	$searchstring = StringReplace($searchstring, "@", "%40")
	$searchstring = StringReplace($searchstring, '[', "%5B")
	$searchstring = StringReplace($searchstring, '\', "%5C")
	$searchstring = StringReplace($searchstring, ']', "%5D")
	$searchstring = StringReplace($searchstring, '^', "%5E")
	$searchstring = StringReplace($searchstring, "`", "%60")
	$searchstring = StringReplace($searchstring, '{', "%7B")
	$searchstring = StringReplace($searchstring, '|', "%7C")
	$searchstring = StringReplace($searchstring, '}', "%7D")
	$searchstring = StringReplace($searchstring, "~", "%7E")
	$searchstring = StringReplace($searchstring, " ", "+")
	Return $searchstring
EndFunc   ;==>textfilter