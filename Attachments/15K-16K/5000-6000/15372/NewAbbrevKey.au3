#include <file.au3>

Dim $Scite = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\SciTe\"
Dim $path = @HomeDrive & @HomePath & "\au3abbrev.properties"
Dim $pathKeyAbb = $Scite & "au3.keywords.abbreviations.properties"
Dim $ar, $aAbbr[1]=[0], $var

_FileReadToArray($path, $ar)
For $i = 8 to $ar[0]
	If StringInStr($ar[$i], '=') Then
		$var = StringSplit($ar[$i], '=')
		ReDim $aAbbr[UBound($aAbbr)+1]
		$aAbbr[UBound($aAbbr)-1] = $var[1]
		$aAbbr[0] += 1
	EndIf
Next

FileMove($pathKeyAbb, $pathKeyAbb & '.BAK')
Dim $fh = FileOpen($pathKeyAbb, 1), $first = 0, $line = '', $count = 1
FileWriteLine($fh, @LF & @LF)
For $i = 1 To $aAbbr[0]
	If $first = 0 Then
		$line &= 'au3.keywords.abbrev='
		$first = 1
	EndIf
	If $count < 15 Then 
		$line &= $aAbbr[$i] & ' '
	Else
		$line &= $aAbbr[$i] & ' \'
		FileWriteLine($fh, $line)
		$line = @TAB & ''
		$count = 0
	EndIf
	$count += 1
Next
FileClose($fh)