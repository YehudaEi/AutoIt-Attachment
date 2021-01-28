#include <File.au3>
$log = ''
$exepath = @WindowsDir&'\System32\wgatray.exe'
$dllpath = @WindowsDir&'\System32\wgalogon.dll'
$dll2path = @WindowsDir&'\System32\spmgs.dll' 
$poisondllpath = @WindowsDir&'\System32\wgalogon.dll.poisoned'
$poisondll2path = @WindowsDir&'\System32\spmgs.poisoned'
$poisonexepath = @WindowsDir&'\System32\wgatray.exe.poisoned'
$datapath = @AppDataCommonDir&'\Windows Genuine Advantage\data\data.dat'
$setuppath = @WindowsDir&'\SoftwareDistribution\Download\6c4788c9549d437e76e1773a7639582a'
$regkey = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Winlogon\Notify\WgaLogon'
$again = 1
$succes = 0
$failed = 0
_DestroyIt()
_KillIt()
$advice = _MakeAdvice()
Msgbox(0, 'Log:', $log&@CRLF&@CRLF&'Sucessful actions: '&$succes&@CRLF&'Failed actions: '&$failed&@CRLF&@CRLF&$advice)

Func _KillIt()
	If ProcessExists('wgatray.exe') then ProcessClose('wgatray.exe')
	if FileDelete($exepath) = 1 Then
		_LogWrite('Sucessfully deleted file: '&$exepath)
		$succes += 1
	Else
		_LogWrite('Failed to delete file: '&$exepath)
		$failed += 1
		_1()
	EndIf
	If FileDelete($dllpath) = 1 Then
		_LogWrite('Sucessfully deleted file: '&$dllpath)
		$succes += 1
	Else
		_LogWrite('Failed to delete file: '&$dllpath)
		$failed += 1
		_2()
	EndIf
	If FileDelete($dll2path) = 1 Then
		_LogWrite('Sucessfully deleted file: '&$dll2path)
		$succes += 1
	Else
		_LogWrite('Failed to delete file: '&$dll2path)
		$failed += 1
		_3()
	EndIf
EndFunc

Func _1()
	If ProcessExists('wgatray.exe') then ProcessClose('wgatray.exe')
	if FileMove($dllpath, $poisondllpath, 1) = 1 Then
		_LogWrite('Sucessfully poisoned file: '&$dllpath)
		$succes += 1
	Else
		_LogWrite('Failed to poison file: '&$dllpath)
		$failed += 1
	EndIf
	_FileCreate($dllpath)
	FileSetAttrib($dllpath, '+R')
EndFunc

Func _2()
	If ProcessExists('wgatray.exe') then ProcessClose('wgatray.exe')
	If FileMove($exepath, $poisonexepath, 1) = 1 Then
		_LogWrite('Sucessfully poisoned file: '&$exepath)
		$succes += 1
	Else
		_LogWrite('Failed to poison file: '&$exepath)
		$failed += 1
	EndIf
	_FileCreate($exepath)
	FileSetAttrib($exepath, '+R')
EndFunc

Func _3()
	If ProcessExists('wgatray.exe') then ProcessClose('wgatray.exe')
	If FileMove($dll2path, $poisondll2path, 1) = 1 Then
		_LogWrite('Sucessfully poisoned file: '&$dll2path)
		$succes += 1
	Else
		_LogWrite('Failed to poison file: '&$dll2path)
		$failed += 1
	EndIf
	_FileCreate($dll2path)
	FileSetAttrib($dll2path, '+R')
EndFunc

Func _MakeAdvice()
	if $failed > 3 then return 'Try running this program in safe mode next time..'
	if $failed = 0 then return 'Completely removed windows genuine!'
	return 'Almost completely removed windows genuine!'&@CRLF&'If you have any problems, try running this program in safe mode..'
EndFunc

Func _DestroyIt()
	$f = FileOpen($datapath, 2)
	if FileWrite($f, 'POISONED') = 1 then
		_LogWrite('Sucessfully poisoned file: '&$datapath)
		$succes += 1
	Else
		_LogWrite('Failed to poison file: '&$datapath)
		$failed += 1
	EndIf
	FileClose($f)
	if FileSetAttrib($f, '+R') = 1 Then
		_LogWrite('Sucessfully locked file: '&$datapath)
		$succes += 1
	Else
		_LogWrite('Failed to lock file: '&$datapath)
		$failed += 1
	EndIf
	if FileExists($setuppath) then 
		if DirRemove($setuppath, 1) = 1 Then
			_LogWrite('Sucessfully removed folder: '&$setuppath)
			$succes += 1
		Else
			_LogWrite('Failed to remove folder: '&$setuppath)
			$failed += 1
		EndIf
	EndIf
	$opz = RegDelete($regkey)
	if $opz <> 0 Then
		if $opz = 1 Then
			_LogWrite('Sucessfully deleted registry key: '&$regkey)
			$succes += 1
		Else
			_LogWrite('Failed to delete registry key: '&$regkey)
			$failed += 1
		EndIf
	EndIf
EndFunc

Func _LogWrite($data)
	if $log = '' then
		$log = $data
		ConsoleWrite('->'&$data&@CRLF)
	Else
		$log &= @CRLF&$data
		ConsoleWrite('->'&$data&@CRLF)
	EndIf
EndFunc

	