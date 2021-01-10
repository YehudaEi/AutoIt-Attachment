#include <File.au3>

MsgBox(0, "Number of lines", "LineCount - " & LineCount("test.txt") & @LF & "_FileCountLines - " & _FileCountLines("test.txt"));

Func LineCount($sFilePath)

	Local $N = FileGetSize($sFilePath)

	If @error Or 0 == $N Then Return 0

	Return CharCountPlus1(FileRead($sFilePath, $N), @LF);
EndFunc   ; //LineCount

#cs
	Find all occurences of LF.
	If last two bytes are not CR/LF, return the above count incremented by 1
#ce

Func CharCountPlus1($inputString, $matchString)

	Local $count = 1

	While 0 <> StringInStr($inputString, $matchString, 2, $count)

		$count += 1;
	WEnd
	
	If 0 == StringInStr(StringRight($inputString, 3), $matchString, 2) Then
	
		$count += 1;
	EndIf
	
	return $count;

EndFunc