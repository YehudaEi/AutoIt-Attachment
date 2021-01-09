
#include <_PartitionLetters.au3>

_ShellExecute($Fldr_Programs_DriveLtr & "\AutoIt\TOOLS\Editor- SciTE\SciTE v1.74\APP- SciTE v1.74\SciTe.exe", _
		@ScriptDir & "\TIME say.au3", _ ; parameter
		"", _ ; workingdir
		"open", _ ; verb
		@SW_MAXIMIZE) ; state

_ShellExecute($Fldr_Programs_DriveLtr & "\TEXT\npad, Metapad v3.51\APP- Metapad v3.51\Metapad.exe", _
		@ScriptDir & "\TIME say.au3", _ ; parameter
		"", _ ; workingdir
		"open", _ ; verb
		@SW_MAXIMIZE) ; state

; or use

_Run($Fldr_Programs_DriveLtr & "\AutoIt\TOOLS\Editor- SciTE\SciTE v1.74\APP- SciTE v1.74\SciTe.exe", _
		@ScriptDir & "\TIME say.au3", _ ; parameter
		"", _ ; workingdir
		@SW_MAXIMIZE) ; state

_Run($Fldr_Programs_DriveLtr & "\TEXT\npad, Metapad v3.51\APP- Metapad v3.51\Metapad.exe", _
		@ScriptDir & "\TIME say.au3", _ ; parameter
		"", _ ; workingdir
		@SW_MAXIMIZE) ; state

Exit

Func _Run($filepath, $parameters = '', $workingdir = '', $showflag = @SW_SHOW)
	; check the filepath for quotes
	If StringLeft($filepath, 1) <> '"' And StringRight($filepath, 1) <> '"' Then
		If StringInStr($filepath, ' ') Then
			; add quotes as the path has whitespace
			$filepath = '"' & $filepath & '"'
		EndIf
	EndIf
	; add parameters to filepath if any
	If $parameters <> '' Then
		$filepath &= ' ' & $parameters
	EndIf
	; run with information given
	Run($filepath, $workingdir, $showflag)
	; check error condition
	If @error And @extended Then
		MsgBox(0x40030, Default, _
				_FormatMessage(@extended) & @CRLF & _
				'Function = _Run()' & @CRLF & _
				'$filepath = ' & $filepath & @CRLF & _
				'$workingdir = ' & $workingdir)
	EndIf
EndFunc

Func _ShellExecute($filepath, $parameters = '', $workingdir = '', $verb = 'open', $showflag = @SW_SHOW)
	; check the filepath for quotes
	If StringLeft($filepath, 1) <> '"' And StringRight($filepath, 1) <> '"' Then
		If StringInStr($filepath, ' ') Then
			; add quotes as the path has whitespace
			$filepath = '"' & $filepath & '"'
		EndIf
	EndIf
	; run with information given
	ShellExecute($filepath, $parameters, $workingdir, $verb, $showflag)
	; check error condition
	If @error And @extended Then
		MsgBox(0x40030, Default, _
				_FormatMessage(@extended) & @CRLF & _
				'Function = _ShellExecute()' & @CRLF & _
				'$filepath = ' & $filepath & @CRLF & _
				'$workingdir = ' & $workingdir)
	EndIf
EndFunc

Func _FormatMessage($iErrorcode)
	; finds the message definition in a message table resource
	Local $lpBuffer, $sMessage
	Local Const $FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000
	$lpBuffer = DllStructCreate('char[4096]')
	If @error Then Return SetError(1, 0, '')
	DllCall('kernel32.dll', 'int', 'FormatMessage', _
			'int', $FORMAT_MESSAGE_FROM_SYSTEM, _
			'ptr', 0, _
			'int', $iErrorcode, _
			'int', 0, _
			'ptr', DllStructGetPtr($lpBuffer), _
			'int', 4096, _
			'ptr', 0)
	If Not @error Then
		$sMessage = DllStructGetData($lpBuffer, 1)
		$lpBuffer = 0
		Return $sMessage
	Else
		$lpBuffer = 0
		Return SetError(2, 0, '')
	EndIf
EndFunc

Func OnAutoItStart()
	If WinExists(@ScriptName & '_Interpreter') Then Exit
	AutoItWinSetTitle(@ScriptName & '_Interpreter')
EndFunc
