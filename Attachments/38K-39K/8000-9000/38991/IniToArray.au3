#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Detefon
 Thansks to Antony-ag for hint
 Date: 17/11/2012

 Script Function:
	This script write a single array[i] or bi-dimensional array[i][j] into a ini file's section.
	Each column is separated by '|' and if string contain a '|', it was changed to string '<%Separator%>'.

	If a single array[i], is a traditional way... not changing...
	_arrayToIni($IniNameFile, $IniSectionName, $ArrayName)
	$config[3] = ["optionA", "optionB", "optionC"]
	_arrayToIni("config.ini", "config", $config)
	In the ini:
	[config]
	0=optionA
	1=optionB
	2=optionC

	If a bi-dimensional array[i][j] has some diferences...
	$colors[3][2] = [["green","verde"],["red","vermelho"],["blue","azul"]]
	_arrayToIni("config.ini", "colors", $colors)
	In the Ini:
	[colors#2#|#<%Separator%>]
	0=green|verde
	1=red|vermelho
	2=blue|azul

	A columns number, the character separator (|) and long string to separator has include in the section name's ini.

	To read a ini file to array, you must have declare a array will be receved a data's array.
	You must be passed a name like string, not variable.

	Global (or Local) $colors
	_iniToArray("config.ini", "colors");correct
	_iniToArray("config.ini", $colors);wrong

	The script read all sections from ini file.
	And if exist the section in parameters funcion, all data's from section ini file will be loaded in the variable array.

	You can pass multiples arrays:
	Global $config
	Global $users
	Global $banned
	_iniToArray("config.ini", "colors,users,banned")
	If exist all sections in ini file, all must be load in respective array.

	If not exist a section ini file requested, the variable array is not changed.
	If someone add more columns in a existent line, this data will not be read.
	If someone delete any columns from existent line, the rest of datas will be null or "".
#ce ----------------------------------------------------------------------------
#include <String.au3>
#include <Array.au3>
#include <Misc.au3>
Global $defaultSeparator = Opt("GUIDataSeparatorChar", "|")
Global $defaultSeparatorString = "<%Separator%>"

Func _arrayToIni($hFile, $sSection, $aName)
	Local $iLines = UBound($aName)
	Switch UBound($aName, 2)
		Case 0
			Local $sTemp = ""
			For $ii = 0 To $iLines - 1
				$aName[$ii] = StringReplace($aName[$ii], @LF, "At^LF")
				$sTemp &= $ii & "=" & $aName[$ii] & @LF
			Next
			IniWriteSection($hFile, $sSection, $sTemp, 0)
		Case Else
			Local $aTemp[1], $sString = "", $iColumns = UBound($aName, 2)
			For $ii = 0 To $iLines - 1
				For $jj = 0 To $iColumns - 1
					$aName[$ii][$jj] = StringReplace($aName[$ii][$jj], $defaultSeparator, $defaultSeparatorString)
					$sString &= $aName[$ii][$jj] & $defaultSeparator
				Next
				_ArrayAdd($aTemp, StringTrimRight($sString, 1))
				$sString = ""
			Next
			_ArrayDelete($aTemp, 0)
			_arrayToIni($hFile, $sSection & "#" & $iColumns & "#" & $defaultSeparator & "#" & $defaultSeparatorString, $aTemp)
	EndSwitch
EndFunc   ;==>_arrayToIni

Func _iniToArray($hFile, $sArrays = 0)
	If $sArrays == 0 Then Return
	$sArrays = StringSplit($sArrays, ",", 2)
	Local $aSection = IniReadSectionNames($hFile)
	_ArrayDelete($aSection, 0)
	If @error Then
		Return 0
	Else
		Local $aProperties[UBound($aSection)][4]
		For $ii = 0 To UBound($aSection) - 1
			Local $aData = StringSplit($aSection[$ii], "#")
			If @error Then
				If Not (_ArraySearch($sArrays, $aSection[$ii]) == -1) Then
					Local $sTemp = IniReadSection($hFile, $aSection[$ii]), $aTemp[1]
					For $jj = 1 To $sTemp[0][0]
						_ArrayAdd($aTemp, $sTemp[$jj][1])
					Next
					_ArrayDelete($aTemp, 0)
					If IsDeclared($aSection[$ii]) Then Assign($aSection[$ii], $aTemp)
				EndIf
			Else
				Local $iCounter = 0
				For $sEach In $aData
					If Not ($iCounter == 0) Then $aProperties[$ii][$iCounter - 1] = $sEach
					$iCounter += 1
				Next
				If Not (_ArraySearch($sArrays, $aProperties[$ii][0]) == -1) Then
					Local $sTemp = IniReadSection($hFile, $aSection[$ii]), $aTemp[1]
					For $jj = 1 To $sTemp[0][0]
						_ArrayAdd($aTemp, $sTemp[$jj][1])
					Next
					_ArrayDelete($aTemp, 0)
					Local $aTemp2[UBound($aTemp)][$aProperties[$ii][1]], $sTemp
					For $xx = 0 To UBound($aTemp) - 1
						$sTemp = StringSplit($aTemp[$xx], $aProperties[$ii][2], 2)
						For $yy = 0 To _Iif(UBound($sTemp) > $aProperties[$ii][1], $aProperties[$ii][1], UBound($sTemp)) - 1
							;$aTemp2[$xx][$yy] = StringReplace($aName[$ii], @LF, "At^LF")
							$aTemp2[$xx][$yy] = StringReplace($sTemp[$yy], $aProperties[$ii][3], $aProperties[$ii][2])
						Next
					Next
					If IsDeclared($aProperties[$ii][0]) Then Assign($aProperties[$ii][0], $aTemp2)
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>_iniToArray

