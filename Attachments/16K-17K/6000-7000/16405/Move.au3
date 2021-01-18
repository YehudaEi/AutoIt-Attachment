#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.7.1
 Author:         Tiger

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Example
Move("C:\Test", "D:\Test")

Func Move($s_target, $e_target, $flag = 0)
	
	If Not StringInStr(StringRight($s_target, 1), "\") Then $s_target = $s_target & "\"
	If Not StringInStr(StringRight($e_target, 1), "\") Then $e_target = $e_target & "\"
	
	$ffff = FileFindFirstFile($s_target & "*")
	
	While 1
		$ffnf = FileFindNextFile($ffff)
		If @error Then ExitLoop
		
		; Dir
		If StringInStr(FileGetAttrib($s_target & $ffnf), "D") Then
			DirMove($s_target & $ffnf, $e_target & $ffnf, $flag)
		; File
		Else
			FileMove($s_target & $ffnf, $e_target & $ffnf, $flag)
		EndIf
	WEnd
	
	; Close Search
	FileClose($ffff)
	
EndFunc   ;==>Move