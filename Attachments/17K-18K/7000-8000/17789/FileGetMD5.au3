#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.8.1
	Author:         Acid Corps
	
	Script Function:
	FileGetMD5
	$s_File = File to get MD5 From
	$s_Base64 = 1 = Base64 encoded output, instead of default hex format
	0 [Default] = default hex format
	
	$MD5 = FileGetMD5('MyFile.exe', 1)
#ce ----------------------------------------------------------------------------
#include <Constants.au3>

Func FileGetMD5($s_File, $s_Base64 = 0)
	;Extract MD5Sums to temp dir (incase of usage from unwriteable media)
	FileInstall('md5sums.exe', @TempDir & '\md5sums.exe')
	
	;Build command to run
	$s_Command = 'MD5Sums.exe \' 
	If $s_Base64 = 1 Then $s_Command &= ' -B' 
	$s_Command &= ' ' & $s_File
	
	;Run Command
	$s_MD5Run = Run($s_Command, "", @SW_HIDE, $STDOUT_CHILD)
	
	;Read Output
	$s_Line = ""
	While 1
		$s_Line &= StdoutRead($s_MD5Run)
		If @error Then ExitLoop
	WEnd
	
	;Remove everything except for the MD5
	$s_MD5 = StringReplace(StringReplace(StringTrimRight(StringTrimLeft($s_Line, StringInStr($s_Line, $s_File, 0, -1) - 1), 20), $s_File, ''), ' ', '')
	
	;Delete temporary MD5Sums
	FileDelete(@TempDir & '\md5sums.exe')
	
	;Return the output
	Return $s_MD5
EndFunc   ;==>FileGetMD5

