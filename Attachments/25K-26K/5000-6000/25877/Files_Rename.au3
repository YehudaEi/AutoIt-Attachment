#include <Array.au3>
Global $locations = "C:\Documents and Settings\Administrator\My Documents\My Pictures\"
Local $i, $get = False
Dim $Found_Files[1]


$Total_files = DirGetSize($locations, 3)
$Fh = FileFindFirstFile($locations & "*.*")
$i = 0
While 1
	$found = FileFindNextFile($Fh)
	If @error Then ExitLoop
;~ 	ConsoleWrite($found&@CRLF)
	$34  = StringReplace($locations&$found, $found, "PICTURE"&$i&".JPG",0)
	ConsoleWrite($34&@CRLF)
		If $Found_Files[0] = "" Then
			_ArrayPush($Found_Files, $34, 1)
		Else
			_ArrayAdd($Found_Files, $34)
		EndIf
		$i += 1
WEnd


_ArrayDisplay($Found_Files, "Search Result")
