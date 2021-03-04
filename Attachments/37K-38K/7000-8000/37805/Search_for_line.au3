#include <Array.au3>
#include <File.au3>
#include <Inet.au3>


$OldLine = "Ke is here"
$NewLine = "Wena is here now"
$TestLine = ("c:\a\testline.txt")
$i = 0
$LineFind = FileReadLine($TestLine)
$CountLines = _FileCountLines("c:\a\testline.txt")
MsgBox(1, "lines", $CountLines)

While $LineFind <> $OldLine

	Do
		$LineFind = FileReadLine($TestLine, $i)
		MsgBox(1, "ke", $LineFind & $i)
		$i = $i + 1
	Until $LineFind = $OldLine
	_FileWriteToLine($TestLine, $OldLine, $NewLine, 1)
	ExitLoop
WEnd






;FileClose($TestLine)

;;NOT WORKING YET

