#include <Array.au3>
Dim $KbArr[1], $sp = "NOT INSTALLED"

$i = 1
While 1
    $var = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", $i)
    If @error <> 0 then ExitLoop
	If StringLeft(String($var), 2) = "KB" Then _ArrayAdd($KbArr,$var)
	$i = $i + 1
WEnd

$file = FileOpen(@ScriptDir & "\" & @ComputerName & "_MSPatch_" & @YEAR & @MON & @MDAY & ".txt", 2)
FileWriteLine($file, "MSPatches on " & @ComputerName & " - Generated on " & @MDAY & "/" & @MON & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC & @CRLF & @CRLF) 
If @OSServicePack <> "" Then $sp = @OSServicePack
FileWriteLine($file, "Service Pack Level: " & $sp & @CRLF & @CRLF) 

FileWriteLine($file, "********** PATCHES INSTALLED **********" & @CRLF & @CRLF)
For $j = 1 To UBound($KbArr) - 1
	$out = IniReadSection(@ScriptDir & "\KBLib.ini", String($KbArr[$j]))
	If Not @error Then FileWriteLine($file, $out[1][0] & " - " & String($KbArr[$j]) & " - " & $out[1][1])
Next
FileWriteLine($file, "---------------------------------------")
FileWriteLine($file, @CRLF)
FileWriteLine($file, "********** NOT FOUND IN LIBRARY **********" & @CRLF & @CRLF)
For $j = 1 To UBound($KbArr) - 1
	$out = IniReadSection(@ScriptDir & "\KBLib.ini", String($KbArr[$j]))
	If @error Then FileWriteLine($file, String($KbArr[$j]))
Next
FileWriteLine($file, "---------------------------------------")
FileWriteLine($file, @CRLF)
FileWriteLine($file, "********** NOT INSTALLED **********" & @CRLF & @CRLF)
$var = IniReadSectionNames(@ScriptDir & "\KBLib.ini")
For $i = 1 To $var[0]
	_ArraySearch($KbArr, String($var[$i]), 1)
	If @error Then
		$out = IniReadSection(@ScriptDir & "\KBLib.ini", String($var[$i]))
		FileWriteLine($file, "*** " & $out[1][0] & " - " & String($var[$i]) & " - " & $out[1][1])
	EndIf
Next
FileWriteLine($file, "---------------------------------------")
FileClose($file)