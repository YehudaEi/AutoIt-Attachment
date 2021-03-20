#include <Array.au3>
Global $i, $dick, $avArray[10]
$fileActivate = WinGetTitle("[CLASS:SciTEWindow]")
$f1 = StringSplit($fileActivate, "\")
$n = UBound($f1) - 1
$f2 = StringSplit($f1[$n], "-")
ConsoleWrite($fileActivate & @CRLF)
$n = UBound($f2) - 1
$file = FileOpen(@WorkingDir & "\" & $f2[$n - 1])
$read = FileRead($file)
$array = StringSplit($read, @CR)
GUICreate("Test", 700, 100)
$aInput = GUICtrlCreateInput("", 5, 5, 690, 20) ;
$alable = GUICtrlCreateLabel("", 5, 30, 690, 20) ;
GUICtrlCreateLabel("Note: First iteration both input and lable show data but label does not show data fully there after.", 5, 55, 690, 20)
GUISetState(@SW_SHOW)
While $i <> 6
	$i = $i + 1
	GUICtrlSetData($aInput, "")
	GUICtrlSetData($alable, "")
	Sleep(1000)
	GUICtrlSetData($aInput, $array[$i])
	GUICtrlSetData($alable, $array[$i])
	Sleep(2000)
WEnd
FileClose($file)
