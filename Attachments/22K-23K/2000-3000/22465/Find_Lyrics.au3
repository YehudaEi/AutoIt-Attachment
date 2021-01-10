#include <INet.au3>
#include <String.au3>
;This script returns (if lyrics is found) an array: 
;$return[0] = a number (if 1 then only lyrics returned if 2 also youtube link returned
;$return[1] = lyrics
;$return[2] = Youtube Link
;What this does is search for the title and then look at the links artist. If the $sArtist matches the link artist it gets the lyrics...
;sometimes the youtube video is not available. Then the $return[0] is set to 1 and $return[2] doesn't exist...
;Enjoy!
$input = InputBox('Lycris Find', 'Please enter title and artist', 'title - artist', '', 100, 100, -1, -1)
if $input = '' then Exit
$p = StringSplit($input, ' - ', 1)
if $p[0] < 2 then exit
$l = _FindLyrics($p[1], $p[2])
if $l <> -1 then
	if $l[0] <> 1 Then ShellExecute($l[2])
	msgbox(32, 'Found it!', $l[1])
	ClipPut($l[1])
Else
	msgbox(0, 'did not find that song..', 'try a different title')
EndIf

Func _FindLyrics($sTitle, $sArtist)
	$source = _INetGetSource('                                                    '&$sTitle&'&x=35&y=13')
	$p1 = StringSplit($source, '<p>Search results for songs: <strong>'&$sTitle&'</strong> (', 1)
	if $p1[0] < 2 then return -1
	$p2 = StringSplit($p1[2], ' results)', 1)
	$results = $p2[1]
	if $results = 0 then return -1
	$p3 = StringSplit($source, ' results)', 1)
	$p4 = StringSplit($p3[2], '</table>', 1)
	$got = StringReplace($p4[1], @TAB, '')
	$tog = StringSplit($got, '</tr>', 1)
	$tog[0] -= 1
	For $i = 1 to $tog[0]
		$bet = _StringBetween($tog[$i], '">', '</a></td>')
		$tk = StringSplit($bet[$bet[0]], '>', 1)
		$artist = $tk[$tk[0]]
		$slk = StringSplit($tog[$i], @CRLF, 1)
		$fl = StringSplit($slk[$slk[0]-2], '<a href="', 1)
		$fk = StringSplit($fl[2], '">', 1)
		$link = $fk[1]
		if StringInStr($artist, $sArtist) then
			$nu = _INetGetSource($link)
			$kjg = StringSplit($nu, '	<!-- CURRENT LYRIC -->', 1)
			$kf = StringSplit($kjg[2], '</div>', 1)
			$ftr = StringSplit($kf[1], 'document.write("', 1)
			if $ftr[0] < 2 then 
				$3 = 'No lyrics'
			Else
				$ve = StringSplit($ftr[2], '")', 1)
				$1 = StringReplace($ve[1], '<br><lyrics>', '')
				$2 = StringReplace($1, '&#xD;<br />', @CRLF)
				$3 = StringReplace($2, '<br>', @CRLF)
			EndIf
			$yg = StringSplit($nu, '<!-- YOUTUBE -->', 1)
			$fv = StringSplit($yg[2], '<br />', 1)
			$kl = StringSplit($fv[1], '<object width="300" height="240"><param name="movie" value="', 1)
			$hf = StringSplit($kl[2], '">', 1)
			$youtubelink = $hf[1]
			if $youtubelink <> '&autoplay=1' then
				global $text[3]
				$text[0] = 2
				$text[1] = $3
				$text[2] = $youtubelink
			Else
				global $text[2]
				$text[0] = 1
				$text[1] = $3
			EndIf
			return $text
		EndIf
	Next
	return -1
EndFunc ;==> _FindLyrics