#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.7.1
 Author:         Tiger

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Example
Remove("C:\Test")

Func Remove($s_target, $flag = 0)
	
	If Not StringInStr(StringRight($s_target, 1), "\") Then $s_target = $s_target & "\"
	
	$ffff = FileFindFirstFile($s_target & "*")
	
	While 1
		$ffnf = FileFindNextFile($ffff)
		If @error Then ExitLoop
		
		; Dir
		If StringInStr(FileGetAttrib($s_target & $ffnf), "D") Then
			DirRemove($s_target & $ffnf, $flag)
		; File
		Else
			FileDelete($s_target & $ffnf)
		EndIf
	WEnd
	
	; Close Search
	FileClose($ffff)
	
EndFunc   ;==>Remove