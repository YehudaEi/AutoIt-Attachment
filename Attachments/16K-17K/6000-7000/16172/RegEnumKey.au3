#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.9
 Author:         Tiger

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func _RegEnumKey($s_path)
	
	Local $i = 1
	Local $key[1]
	
	While 1
		$var = RegEnumKey($s_path, $i)
		If @error <> 0 Then
			ExitLoop
		Else
			ReDim $key[UBound($key) + 1]
			$key[0] = $key[0] + 1
			$key[UBound($key) - 1] = $var
			$i = $i + 1
		EndIf
	WEnd
	
	Return $key
	
EndFunc   ;==>_RegEnumKey