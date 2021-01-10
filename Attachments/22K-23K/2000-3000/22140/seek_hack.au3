#include <File.au3>
$sleep = False
_HackSeek()
Func _HackSeek()
	$array = _FileListToArray(@DesktopDir&'\start\')
	for $i = 1 to $array[0]
		if $sleep <> false then
			Tooltip($array[$i])
			sleep($sleep)
		EndIf
		$a1 = _FileListToArray(@DesktopDir&'\start\'&$array[$i]&'\')
		For $p = 1 to $a1[0]
			if $sleep <> false then
				Tooltip($array[$i]&'   ::   '&$a1[$p])
				sleep($sleep)
			EndIf
			$a2 = _FileListToArray(@DesktopDir&'\start\'&$array[$i]&'\'&$a1[$p]&'\')
			For $x = 1 to $a2[0]
				if $sleep <> false then
					Tooltip($array[$i]&'   ::   '&$a1[$p]&'   ::   '&$a2[$x])
					sleep($sleep)
				EndIf
				$a3 = _FileListToArray(@DesktopDir&'\start\'&$array[$i]&'\'&$a1[$p]&'\'&$a2[$x]&'\')
				For $k = 1 to $a3[0]
					if $sleep <> false then
						Tooltip($array[$i]&'   ::   '&$a1[$p]&'   ::   '&$a2[$x]&'   ::   '&$a3[$k])
						sleep($sleep)
					EndIf
					if $a3[$k] = 'FindMe.txt' then 
						ShellExecute (@DesktopDir&'\start\'&$array[$i]&'\'&$a1[$p]&'\'&$a2[$x]&'\'&$a3[$k])
					EndIf
				Next
			Next
		Next
	Next
EndFunc

