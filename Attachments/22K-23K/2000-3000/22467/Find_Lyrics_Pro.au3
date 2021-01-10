#include <INet.au3>
#include <String.au3>
;This script returns the lyrics.. if not found it returns -1
;What this does is search for the title and then look at the links artist. If the $sArtist matches the link artist it gets the lyrics...
;sometimes the youtube video is not available. Then the $return[0] is set to 1 and $return[2] doesn't exist...
;Enjoy!
$input = InputBox('Lycris Find', 'Please enter title and artist', 'title - artist', '', 100, 100, -1, -1)
if $input = '' then Exit
$p = StringSplit($input, ' - ', 1)
if $p[0] < 2 then exit
$l = _FindLyrics($p[1], $p[2])
if $l <> -1 then
	msgbox(32, 'Found it!', $l)
	ClipPut($l)
Else
	msgbox(0, 'did not find that song..', 'try a different title')
EndIf

Func _FindLyrics($sTitle, $sArtist)
	$sArtist = StringReplace($sArtist, ' ', '')
	$source = _INetGetSource('http://search.azlyrics.com/cgi-bin/azseek.cgi?q='&$sTitle)
	If StringInStr($source, 'Sorry, but search returned no results.<P>') then return -1
	$p1 = StringSplit($source, '<td><FONT Face=Verdana size=2><b>', 1)
	if $p1[0] < 2 then return -1
	For $i = 2 to $p1[0]
		$p2 = StringSplit($p1[$i], '<FONT Face=Verdana size=2><a href="', 1)
		if $p2[0] < 2 then return -1
		$p3 = StringSplit($p2[2], '"', 1)
		if $p3[0] < 1 then return -1
		$link = $p3[1]
		if $sArtist = '' then
			$new = _INetGetSource($link)
			$p5 = StringSplit($new, '<!-- END OF RINGTONE 1 -->'&@CRLF, 1)
			if $p5 < 2 then return -1
			$p6 = StringSplit($p5[2], '[ <a href="http://www.azlyrics.com">www.azlyrics.com</a> ]', 1)
			if $p6 < 1 then return -1
			$s1 = StringReplace($p6[1], '<BR>', '')
			$s2 = StringReplace($s1, '<U>', '')
			$s3 = StringReplace($s2, '<B>', '')
			$s4 = StringReplace($s3, '<I>', '')
			$s5 = StringReplace($s4, '<P>', '')
			$s6 = StringReplace($s5, '</U>', '')
			$s7 = StringReplace($s6, '</B>', '')
			$s8 = StringReplace($s7, '</I>', '')
			$s9 = StringReplace($s8, @TAB, '')
			$s10 = StringSplit($s9, '<font ', 1)
			if $s10[0] > 1 then
				$s11 = StringSplit($s10[2], '>', 1)
				$s12 = StringReplace($s9, '<font '&$s11[1]&'>', '')
				$s9 = $s12
			EndIf
			$s13 = StringReplace($s9, '</font>', '')
			return $s13
		EndIf
		$p4 = StringSplit($link, '/', 1)
		$tk = $p4[$p4[0]-1]
		if StringInStr($sArtist, $tk) or StringInStr($tk, $sArtist) then
			$new = _INetGetSource($link)
			$p5 = StringSplit($new, '<!-- END OF RINGTONE 1 -->'&@CRLF, 1)
			if $p5 < 2 then return -1
			$p6 = StringSplit($p5[2], '[ <a href="http://www.azlyrics.com">www.azlyrics.com</a> ]', 1)
			if $p6 < 1 then return -1
			$s1 = StringReplace($p6[1], '<BR>', '')
			$s2 = StringReplace($s1, '<U>', '')
			$s3 = StringReplace($s2, '<B>', '')
			$s4 = StringReplace($s3, '<I>', '')
			$s5 = StringReplace($s4, '<P>', '')
			$s6 = StringReplace($s5, '</U>', '')
			$s7 = StringReplace($s6, '</B>', '')
			$s8 = StringReplace($s7, '</I>', '')
			$s9 = StringReplace($s8, @TAB, '')
			$s10 = StringSplit($s9, '<font ', 1)
			if $s10[0] > 1 then
				$s11 = StringSplit($s10[2], '>', 1)
				$s12 = StringReplace($s9, '<font '&$s11[1]&'>', '')
				$s9 = $s12
			EndIf
			$s13 = StringReplace($s9, '</font>', '')
			return $s13
		EndIf
	Next
	return -1
	
EndFunc ;==> _FindLyrics