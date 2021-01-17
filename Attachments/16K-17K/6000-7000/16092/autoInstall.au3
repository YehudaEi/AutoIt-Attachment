#NoTrayIcon

; Identify Installer modification for auto installation method of use

#region - Include files
#include <file.au3>
#endregion

#region - CMDLINE paramters
If Not $CMDLINE[0] Then
	MsgBox(0x40000, 'Usage Help', 'Pass a path to an installer by CLI or use drag and drap', 5)
	;InetGet("URL", "filename"); Hint: AutoIt function for downloading files :)
	Exit
EndIf
Global Const $FILE_FULLPATH = $CMDLINE[1]
Global Const $FILE_NAME = StringTrimLeft($FILE_FULLPATH, StringInStr($FILE_FULLPATH, '\', 0, -1))
Global Const $FILE_TEXT = StringMid($FILE_NAME, 1, StringInStr($FILE_NAME, '.', 0, -1) -1)
Global Const $FILE_EXT = StringMid($FILE_NAME, StringInStr($FILE_NAME, '.', 0, -1))
Global Const $FILE_WORKINGDIR = _File_WorkingDir($FILE_FULLPATH)
FileChangeDir($FILE_WORKINGDIR)
#endregion

#region - Script actions
_NoMultiFiles()
_FileType($FILE_FULLPATH, 'exe|msi')
;
; Use True as 2nd parameter to test only
; 2nd parameter is optional and is False if not specified
; 3rd parameter is optional and 5000 ms default for splash window timeout
_IdentifyInstaller(@ScriptDir & '\ErrorLog.log', True)
#endregion

Exit

Func _IdentifyInstaller($logpath, $test = False, $time = 5000)
	Opt('MustDeclareVars', True)
	Local $output, $parameters, $window_on_top_attrib, $exitcode, $splashtext
	Local Const $TITLE_PEID = 'PEiD'
	Opt('WinWaitDelay', 50)
	; Hide the PEiD window a bit better by getting rid of its on-top attribute
	$window_on_top_attrib = RegRead('HKCU\Software\PEiD', 'StayOnTop')
	RegWrite('HKCU\Software\PEiD', 'StayOnTop', 'REG_DWORD', 0)
	; Run PeID to scan file.
	If Not FileExists(@ScriptDir & '\Files\PEiD.exe') Then
		DirCreate('files')
		_FileWriteLog($logpath, '"' & @ScriptDir & '\Files\PEID.exe" was not found')
		Exit 1
	EndIf
	Run('"' & @ScriptDir & '\Files\PEiD.exe" -hard "' & $FILE_FULLPATH & '"')
	If WinWait($TITLE_PEID, '', 10) Then
		Sleep(1000)
		$output = ControlGetText($TITLE_PEID, '', 'Edit2')
		While $output = 'Scanning...' Or $output = ''
			Sleep(200)
			$output = ControlGetText($TITLE_PEID, '', 'Edit2')
		WEnd
		WinClose($TITLE_PEID)
	EndIf
	; Identify the Installer Type
	Local Const $INSTALLER = '"' & $FILE_FULLPATH & '"'
	If StringInStr($output, 'Inno Setup') _
		Or StringInStr($output, 'Inno SFX') _
		Or StringInStr($output, 'Borland Delphi') Then
		; Identified as Inno Setup
		$parameters = ' /SP- /SILENT'
	ElseIf StringInStr($output, 'Wise') Then
		; Identified as Wise
		$parameters = ' /S'
	ElseIf StringInStr($output, 'Nullsoft') Then
		; Identified as Nullsoft
		$parameters = ' /S'
	ElseIf StringInStr($output, 'InstallShield AFW') Then
		; Identified as InstallShield AFW
		$parameters = ' /S /A /S /SMS'
	ElseIf StringInStr($output, 'InstallShield 2003') Then
		; Identified as InstallShield 2003
		$parameters = ' /V"/QN"'
	ElseIf StringInStr($output, 'RAR SFX') Then
		; Identified as RAR SFX
		$parameters = ' /S'
	ElseIf StringInStr($output, 'ZIP SFX') Then
		; Identified as ZIP SFX
		$parameters = ' /AUTOINSTALL'
	ElseIf StringInStr($output, 'WinZip') Then
		; Identified as WinZip
		$parameters = ' /AUTOINSTALL'
	ElseIf StringRight($FILE_FULLPATH, 4) = '.msi' Then
		Opt('WinWaitDelay', 100)
		Run('msiexec /?')
		If WinWait('Windows Installer', 20) Then
			$content = ControlGetText('Windows Installer', '', 'RichEdit20W1')
			If $content = '' Then ; Using Vista
				$content = ControlGetText('Windows Installer', '', 'Edit1')
			EndIf
			WinClose('Windows Installer')
			Opt('WinWaitDelay', 250)
			If $content Then
				; Identified as Windows Installer
				$parameters = ' /QN'
			EndIf
		EndIf
	EndIf
	If $parameters Then
		If $test Then
			; Test Only
			$splashtext = 'Command selected for use:' & @CRLF & @CRLF & '"' & $FILE_FULLPATH & '" ' & $parameters
			SplashTextOn('Identify Installer', $splashtext, 800, 100, Default, 50, 32)
			Sleep($time)
			SplashOff()
			$exitcode = Random(0, 3, 1)
			If $exitcode Then
				_ScriptLog($exitcode, $FILE_FULLPATH, $parameters)
			EndIf
		Else
			; Execute the installation and log non 0 exitcodes
			$exitcode = RunWait('"' & $FILE_FULLPATH & '" ' & $parameters)
			If $exitcode Then
				_ScriptLog($exitcode, $FILE_FULLPATH, $parameters)
			EndIf
		EndIf
	ElseIf $test Then
		; Test Only
		$parameters = 'Failed to Identify'
		$splashtext = 'Command selected:' & @CRLF & @CRLF & '"' & $FILE_FULLPATH & '" ' & $parameters
		SplashTextOn('Identify Installer', $splashtext, 800, 100, Default, 50, 32)
		Sleep($time)
		SplashOff()
		_ScriptLog('-', $FILE_FULLPATH, $parameters)
	Else
		; Failed to Identify the installer so log the failure
		_ScriptLog('-', $FILE_FULLPATH, 'Failed to Identify')
	EndIf
	If $window_on_top_attrib Then
		RegWrite('HKCU\Software\PEiD', 'StayOnTop', 'REG_DWORD', $window_on_top_attrib)
	EndIf
EndFunc

Func _ScriptLog($exitcode, $fullpath, $parameters)
	_FileWriteLog(@ScriptDir & '\ErrorLog.log', 'Exitcode ' & $exitcode & ': "' & $FILE_FULLPATH & '"' & $parameters)
EndFunc

Func _FileType($file, $type)
	; Valids the file type selection used for incoming parameter
	Local $valid, $position
	_CheckIfFile($file)
	If $type = '' Then Return
	$array = StringSplit($type, '|')
	If Not @error Then
		For $i = 1 To $array[0]
			If StringRight($file, StringLen($array[$i])) = $array[$i] Then
				$valid = True
				ExitLoop
			EndIf
		Next
		If Not $valid Then
			$position = StringInStr($type, '|', Default, -1)
			$type = StringLeft($type, $position - 1) & ' or ' & StringRight($type, StringLen($type) - $position)
		EndIf
	ElseIf StringRight($file, StringLen($type)) = $type Then
		$valid = True
	EndIf
	If Not $valid Then
		_ScriptLog('-', $FILE_FULLPATH, ': Incorrect filetype selected : Supported types = ' & StringReplace($type, '|', ', ') & '  ')
;~ 		MsgBox(0x40030, Default, 'Incorrect filetype selected' & @CRLF & 'Supported types:  ' & StringReplace($type, '|', ', ') & '  ')
		Exit 999
	EndIf
EndFunc

Func _CheckIfFile($parameter)
	; Used to check that incoming parameter is a file
	If StringInStr(FileGetAttrib($parameter), 'D') Then
		MsgBox(0x40030, Default, 'This is a directory' & @CRLF & 'A file is required for processing')
		Exit 999
	EndIf
EndFunc

Func _NoMultiFiles()
	; Notify and exit if multiple incoming parameters are passed
	If $CMDLINE[0] > 1 Then
		MsgBox(0x40030, Default, 'Multiple file selection is not allowed for this item', 5)
		Exit 999
	EndIf
EndFunc

Func _File_WorkingDir($parameter)
	If StringInStr(FileGetAttrib($parameter), 'D') Then
		Return $parameter
	Else
		Return StringLeft($parameter, StringInStr($parameter, '\', 0, -1))
	EndIf
EndFunc ; Required for CMDLINE use