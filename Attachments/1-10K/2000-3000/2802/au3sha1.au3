Func _Sha1($string)
	$result = DllCall("c:\au3sha1.dll", "str", "HashString", "str", $string) 
	return $result[0]
EndFunc

Func _Sha1File($file)
	$result = DllCall("c:\au3sha1.dll", "str", "HashFile", "str", $file) 
	return $result[0]
EndFunc