#cs ---------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Daedalian

 Script Function:
	In case you are a movie and series fan you have a lot of movie files (avi's) in a folder and a bunch of subtitles.
	your favorite player is probably stupid enough not to recognize similar filenames so you have to rename exactly
	each subtitle manually! boring!!
	Use this script to do the above automatically!
	Just a first beta version, improve as you like, meanwhile I will do the same..

#ce ----------------------------------------------------------------------------
#include <File.au3>
#include <Array.au3>
#include <Math.au3>
Dim Const $maxOffset = 20 ; Change according to how far you want to search; a bigger value means a slower comparison
;The Levenshtein distance is defined as the minimal number of characters you have to replace,
;insert or delete to transform str1 into str2. The complexity of the algorithm is O(m*n),
;where n and m are the length of str1 and str2 (rather good when compared to similar_text(),
;which is O(max(n,m)**3), but still expensive).

$videos = _FileListToArray(@ScriptDir,"*.avi",1)
_ArrayDelete($videos,0)
$subs = _FileListToArray(@ScriptDir,"*.srt",1)
_ArrayDelete($subs,0)

$jbow='[[:alpha:]]+'	;just a bunch of words
$jbon='[[:digit:]]+'	;just a bunch of numbers
;na xorisoume ta ascii codes apo ta grammata kai tous arithmous
Dim $videoParts[Ubound($videos)]
For $j=0 to UBound($videos)-1
	$temp=StringRegExp($videos[$j],$jbow,3,1)
	_ArrayDelete($temp,UBound($temp)-1) ;to teleutaio einai panta h kataliksi
	$temp2=StringRegExp($videos[$j],$jbon,3,1)
	_ArrayConcatenate($temp,$temp2)
	$videoParts[$j]=$temp
	;_ArrayDisplay($videoParts[$j])
Next

Dim $subParts[Ubound($subs)]
For $j=0 to UBound($subs)-1
	$temp=StringRegExp($subs[$j],$jbow,3,1)
	_ArrayDelete($temp,UBound($temp)-1) ;to teleutaio einai panta h kataliksi
	$temp2=StringRegExp($subs[$j],$jbon,3,1)
	_ArrayConcatenate($temp,$temp2)
	$subParts[$j]=$temp
	;_ArrayDisplay($subParts[$j])
Next

Dim $sims[1]
Dim $simil[1]

For $s=0 To UBound($videoParts)-1
	$source=$videoParts[$s]
	_ArrayDisplay($source)
	ReDim $simil[UBound($subParts)]
	For $t=0 To UBound($subParts)-1
		$target=$subParts[$t]

		ReDim $sims[UBound($target)]
		$simil[$t]=0
		;_ArrayDisplay($target)
		For $k=0 To UBound($source)-1
			;MsgBox(0,"",$source[$k])
			For $j=0 To UBound($target)-1
				$sims[$j] = _Similarity($source[$k],$target[$j],0)
			Next
			;_ArrayDisplay($sims)
			$simil[$t]=$simil[$t]+_ArrayMax($sims)
		Next
		;MsgBox(0,"",$simil[$t])
	Next
	_ArrayDisplay($simil)
	$bestMatch = _ArrayMaxIndex($simil)
	MsgBox(0,"best match index",$bestMatch)
	_ArrayDisplay($subs)
	FileMove($subs[$bestMatch],StringTrimRight($videos[$s],4) & ".srt")

	_ArrayDelete($subs,$bestMatch)
	_ArrayDelete($subParts,$bestMatch)
	_ArrayDisplay($subs)
Next


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Compute similarity between two strings
Func _Similarity($s1, $s2, $alg = 0)
    Local $dis
    If ($alg = 0) Then
        $dis = _Levenshtein($s1, $s2)
    Else
        $dis = _Distance($s1, $s2)
    EndIf
    Local $maxLen = _Max(StringLen($s1), StringLen($s2))
    If ($maxLen = 0) Then Return 100
    Return (1 - $dis / $maxLen) * 100
EndFunc

; Compute Levenshtein Distance
Func _Levenshtein($s, $t)
    Local $m, $n, $i, $j, $s_i, $t_j, $cost

    $n = StringLen($s)
    $m = StringLen($t)

    If $n * $m = 0 Then Return $m + $n

    Local $d[$n + 1][$m + 1]

    For $i = 0 To $n
        $d[$i][0] = $i
    Next

    For $j = 0 To $m
        $d[0][$j] = $j
    Next

    For $i = 1 To $n
        $s_i = StringMid($s, $i, 1)

        For $j = 1 To $m
            $t_j = StringMid($t, $j, 1)

            If $s_i = $t_j Then
                $cost = 0
            Else
                $cost = 1
            EndIf

            $d[$i][$j] = _Minimum3($d[$i - 1][$j] + 1, $d[$i][$j - 1] + 1, $d[$i - 1][$j - 1] + $cost)
        Next
    Next

    Return $d[$n][$m]

EndFunc

; Get minimum of three values
Func _Minimum3($a, $b, $c)
    Local $mi

    $mi = $a
    If $b < $mi Then $mi = $b
    If $c < $mi Then $mi = $c

    Return $mi
EndFunc

; Efficient calculation of similarity
Func _Distance($s1, $s2)
    Local $ls1 = StringLen($s1), $ls2 = StringLen($s2)
    If $ls1 * $ls2 = 0 Then Return $ls1 + $ls2

    Local $c = 0, $offset1 = 0, $offset2 = 0, $dist = 0, $i

    While (($c + $offset1 < $ls1) And ($c + $offset2 < $ls2))
        If (StringMid($s1, $c + $offset1 + 1, 1) <> StringMid($s2, $c + $offset2 + 1, 1)) Then
            $offset1 = 0
            $offset2 = 0
            For $i = 0 to $maxOffset - 1
                If (($c + $i < $ls1) And (StringMid($s1, $c + $i + 1, 1) = StringMid($s2, $c + 1, 1))) Then
                    If ($i > 0) Then
                        $dist += 1
                        $offset1 = $i
                    EndIf
                    $dist -= 1
                    ExitLoop
                EndIf
                If (($c + $i < $ls2) And (StringMid($s1, $c + 1, 1) = StringMid($s2, $c + $i + 1, 1))) Then
                    If ($i > 0) Then
                        $dist += 1
                        $offset2 = $i
                    EndIf
                    $dist -= 1
                    ExitLoop
                EndIf
            Next
            $dist += 1
        EndIf
        $c += 1
    Wend

    Return $dist + ($ls1 - $offset1 + $ls2 - $offset2) / 2 - $c
EndFunc