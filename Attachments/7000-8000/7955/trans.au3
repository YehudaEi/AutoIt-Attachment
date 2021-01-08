#include <array.au3>

Func GetLangArray($lFile)
	local $i = 1
	local $aLang[1]
	local $tempvar
		
	while 1
		$tmpvar = IniRead(@ScriptDir & "\" & $lFile,"Data",$i, "e_r_r_0_r")
		
		$i += 1
		if $tmpvar <> "e_r_r_0_r" Then
			$tmpvar = StringSplit($tmpvar,"¨")
			_ArrayAdd($aLang,$tmpvar[2])
		Else
			ExitLoop
		EndIf
	WEnd
	
	Return $aLang
EndFunc

