#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=rob\bpm-ico\KbMouse.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=                
#AutoIt3Wrapper_Res_Description=Mouse emulator on keyboard
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=monter.FM
#AutoIt3Wrapper_Res_Field=Release date|20.10.2010
#AutoIt3Wrapper_Res_Field=AutoIt3 ver.|%AutoItVer%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;ToolTip('Launching KbMouse...', Int(@DesktopWidth / 2), @DesktopHeight - 48, @ScriptName, 1, 2)
#include <Date.au3>
#include <File.au3>
#include <Misc.au3>
$fnScript = 'Keyboard Mouse' ;full script name
$script = StringLeft(@ScriptName, StringInStr(@ScriptName, '.', 0, -1) - 1)
FileChangeDir(@ScriptDir)
$dt = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
$icon = @TempDir & '\' & $script & '_' & $dt & '.ico'
FileInstall('.\rob\bpm-ico\KbMouse.ico', $icon, 1)
;$monter = @TempDir & '\' & $script & '_monter.FM_' & $dt & '.gif'
;FileInstall('.\rob\monter.FM.gif', $monter, 1)
OnAutoItExitRegister('OnExit')
FileInfo()
$title = $fnScript & ' ' & $sVer
TraySetIcon($icon)
TraySetToolTip($title)
Global $version, $countTimes, $rcntUsed, $rcntUpdChk, $anon, $updForce = 0, $onx = 0
$ini = @ScriptDir & '\' & $script & '.ini'
If FileExists($ini) And $CmdLine[0] = 0 Then
	If _Singleton(@ScriptName, 1) = 0 Then
		msg()
		msg($script & ' is running already.', 1500, -1, -1, -1, 2)
		$runAlr = 1
		;WinSetState($title, '', @SW_SHOW)
		;WinActivate($title)
		Exit
	EndIf
EndIf
$dirMonter = @AppDataDir & '\monter.FM' ;directory for monter.FM's scripts
$filUpd = @TempDir & '\' & $script & '.upd' ;file checking upgrade from monter's server
$filBat = @TempDir & '\' & $script & '.bat' ;temporary file for killing old exe and launching new version
If FileExists($filUpd) Then FileDelete($filUpd)
If FileExists($filBat) Then FileDelete($filBat)
$version = IniRead($ini, 'Main', 'version', $sVer)
$srvUrl = 'monter.homeip.net'
$iniDel = 0
Run('netsh firewall set allowedprogram "' & @ScriptFullPath & '" "' & $script & '" ENABLE', '', @SW_HIDE)
If IniRead($ini, 'Main', 'rcntUsed', '') = '' Or ($CmdLine[0] > 0 And $CmdLine[1] = '-i') Then
	Install()
	StatFtp('i') ;21.06.2010
EndIf
If ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then
	UpdateSet()
	StatFtp('u') ; 21.06.2010
EndIf
If $sVer > $version Then
	UpdateIni()
	msg() ; zlikwidowany UpdateMsg()
	;MsgBox(64, $title & ' - how to use', 'Toggle activate/deactivate:	Ctrl+NUM 0' & @CRLF & 'Move Up:						NUM 8' & @CRLF & 'Move Down:					NUM 2' & @CRLF & 'Move Left:					NUM 4' & @CRLF & 'Move Right:					NUM 6' & @CRLF & 'Move Up/Left:					NUM 7' & @CRLF & 'Move Up/Right:					NUM 9' & @CRLF & 'Move Down/Left:				NUM 1' & @CRLF & 'Move Down/Right:						NUM 3' & @CRLF & 'Click:								NUM 5' & @CRLF & 'Right click:							NUM -', 60)
EndIf
IniFRead()

Dim $mPos[3]
$mousOn = 0
$step = 6
Global $mov, $mgp
$adlFrq = 2000
AdlibRegister('UpdateCheck', $adlFrq)

HotKeySet('^{NUMPAD0}', 'Mouse_01')
Send('^{NUMPAD0}')
HotKeySet('+^{F4}', 'ExitF')

While 1
	Sleep(25)
WEnd

Func Mouse_01()
	If $mousOn = 0 Then
		TrayTip('', 'KbMouse mode ACTIVE', 30)
		$mPos = MouseGetPos()
		Global $mov = 6
		HotKeySet('{NUMPAD8}', 'Up')
		HotKeySet('{NUMPAD2}', 'Dn')
		HotKeySet('{NUMPAD4}', 'Lt')
		HotKeySet('{NUMPAD6}', 'Rt')
		HotKeySet('{NUMPAD7}', 'UpLt')
		HotKeySet('{NUMPAD9}', 'UpRt')
		HotKeySet('{NUMPAD1}', 'DnLt')
		HotKeySet('{NUMPAD3}', 'DnRt')
		HotKeySet('{NUMPAD5}', 'Clk')
		HotKeySet('{NUMPADSUB}', 'RClk')
		$mousOn = 1
	Else
		TrayTip('', 'KbMouse mode DEACTIVATED', 30)
		HotKeySet('{NUMPAD8}')
		HotKeySet('{NUMPAD2}')
		HotKeySet('{NUMPAD4}')
		HotKeySet('{NUMPAD6}')
		HotKeySet('{NUMPAD7}')
		HotKeySet('{NUMPAD9}')
		HotKeySet('{NUMPAD1}')
		HotKeySet('{NUMPAD3}')
		HotKeySet('{NUMPAD5}')
		HotKeySet('{NUMPADSUB}')
		$mousOn = 0
	EndIf
EndFunc   ;==>Mouse_01

Func Up()
	$mgp = MouseGetPos()
	MouseMove($mgp[0], $mgp[1] - $mov, 0)
EndFunc   ;==>Up

Func Dn()
	$mgp = MouseGetPos()
	MouseMove($mgp[0], $mgp[1] + $mov, 0)
EndFunc   ;==>Dn

Func Lt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] - $mov, $mgp[1], 0)
EndFunc   ;==>Lt

Func Rt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] + $mov, $mgp[1], 0)
EndFunc   ;==>Rt

Func UpLt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] - $mov, $mgp[1] - $mov, 0)
EndFunc   ;==>UpLt

Func UpRt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] + $mov, $mgp[1] - $mov, 0)
EndFunc   ;==>UpRt

Func DnLt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] - $mov, $mgp[1] + $mov, 0)
EndFunc   ;==>DnLt

Func DnRt()
	$mgp = MouseGetPos()
	MouseMove($mgp[0] + $mov, $mgp[1] + $mov, 0)
EndFunc   ;==>DnRt

Func Clk()
	MouseClick('')
EndFunc   ;==>Clk

Func RClk()
	MouseClick('right')
EndFunc   ;==>RClk

Func ExitF()
	TrayTip('', 'Closing ' & $script & '...', 2)
	Sleep(750)
	Exit
EndFunc   ;==>ExitF

Func IniFRead() ; 29.09.2010 - kasowanie pustych kluczy
	$sct = IniReadSection($ini, 'Main')
	If @error Then ;($CmdLine[0] > 0 And $CmdLine[1] <> '-i')
		msg('No [Main] section or missing ini file.', -2500, -1, -1, -1, 2)
	Else
		For $i = 1 To $sct[0][0]
			If $sct[$i][1] = '' Then IniDelete($ini, 'Main', $sct[$i][0])
		Next
	EndIf
	$countTimes = IniRead($ini, 'Main', 'countTimes', 0)
	$rcntUsed = IniRead($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	$rcntUpdChk = IniRead($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	$anon = IniRead($ini, 'Main', 'anon', 0)
EndFunc   ;==>IniFRead

Func Install() ; 19.09.2010
	MsgBox(64, $title & ' - how to use', 'Toggle activate/deactivate:	Ctrl+NUM 0' & @CRLF & 'Move Up:			NUM 8' & @CRLF & 'Move Down:		NUM 2' & @CRLF & 'Move Left:		NUM 4' & @CRLF & 'Move Right:		NUM 6' & @CRLF & 'Move Up/Left:		NUM 7' & @CRLF & 'Move Up/Right:		NUM 9' & @CRLF & 'Move Down/Left:		NUM 1' & @CRLF & 'Move Down/Right:		NUM 3' & @CRLF & 'Click:			NUM 5' & @CRLF & 'Right click:		NUM -' & @CRLF & 'Exiting:			Shift+Ctrl+F4', 60)
	If @Compiled Then
		$dirLnch = @WorkingDir
		If Not FileExists($dirMonter) Then DirCreate($dirMonter)
		FileChangeDir($dirMonter)
		If @ScriptDir <> $dirMonter Then
			$del = 1
			$instCpyMovTxt = 'Moving'
			If StringLeft(@ScriptDir, 3) <> StringLeft(@AppDataDir, 3) Then
				$del = 0
				$instCpyMovTxt = 'Copying'
			EndIf
			msg('First launching.' & @CRLF & $instCpyMovTxt & ' file to the proper directory, wait a moment...')
			$list = ProcessList($script & '.exe')
			For $i = 1 To $list[0][0]
				$pid = WinGetProcess($script)
				ProcessClose($pid)
			Next
			Sleep(1000)
			FileCopy(@ScriptFullPath, $dirMonter & '\' & $script & '.exe', 9)
			If Not FileExists(@ProgramsDir & '\monter.FM\') Then DirCreate(@ProgramsDir & '\monter.FM\')
			FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
			msg()
			$mb = MsgBox(36, $title, 'Create the shortcut on desktop?', 12)
			If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
			If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
			$baTemp = FileOpen($filBat, 1)
			If $del = 1 Then FileWriteLine($baTemp, '@ping -n 4 autoitscript.com' & @CRLF & '@if exist "' & @ScriptFullPath & '" del "' & @ScriptFullPath & '"')
			FileWriteLine($baTemp, '@ping -n 1 autoitscript.com' & @CRLF & '@if exist "' & $dirMonter & '\' & $script & '.exe' & '" "' & $dirMonter & '\' & $script & '.exe' & @CRLF & '@exit' & @CRLF & '@cls')
			FileClose($baTemp)
			If FileExists($dirLnch & '\' & $ini) Then FileDelete($dirLnch & '\' & $ini)
			If FileExists($dirLnch & '\' & $script & '.*.lng') Then FileDelete($dirLnch & '\' & $script & '.*.lng')
			Sleep(2000)
			;If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
			If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
			Run(@ComSpec & ' /c "' & $filBat & '" -u', '', @SW_HIDE)
			For $i = 1 To 2
				If ProcessExists(@ScriptName) Then ProcessClose(@ScriptName)
				Sleep(2000)
			Next
			$iniDel = 1
			Exit
		EndIf
	EndIf
EndFunc   ;==>Install

Func UpdateSet()
	FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
	If FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then
		FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
	Else
		$mb = MsgBox(36, $title, 'Create the shortcut on desktop?', 12)
		If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
		If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
	EndIf
EndFunc   ;==>UpdateSet

Func UpdateIni() ;update ini, convert to new keys/values, deletes old entries
	IniWrite($ini, 'Main', 'version', $sVer)
	IniWrite($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
EndFunc   ;==>UpdateIni

Func UpdateCheck() ; 19.10.2010 - works for main (single) file in the project, every 20h checking for updates module, .ex_ optional
	AdlibUnRegister('UpdateCheck')
	If _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk >= 72000 Or $rcntUsed = $rcntUpdChk Or $updForce = 1 Then
		$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
		$pcol = 'ftp://'
		For $i = 1 To 3
			InetGet($pcol & $srvUrl & '/skrypty/bin/' & $script & '.upd', $filUpd, 1, 0)
			If @error Then ExitLoop
			Sleep(750)
			If FileExists($filUpd) And FileGetSize($filUpd) > 30 Then ExitLoop
			If $i = 1 Then $pcol = 'http://'
			If $i = 2 Then HttpSetProxy(2, $srvUrl & ':8068')
		Next
		ToolTip('')
		HttpSetProxy(1)
		If Not FileExists($filUpd) Then Sleep(2500)
		If Not FileExists($filUpd) Or FileGetSize($filUpd) < 30 Then
			If $updForce = 1 Then msg('Network error. Update failed.', -4000, -1, -1, -1, 3)
			$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - 61200
		Else
			$nFile = IniReadSectionNames($filUpd)
			$nFile = $nFile[1]
			$nVer = IniRead($filUpd, $nFile, 'version', '0.0.0.0')
			$nVer = StringFormat('%.2f', Number(StringReplace($nVer, '.', '')) / 1000)
			$nSize = IniRead($filUpd, $nFile, 'size', '999999999')
			If $nVer > $sVer Then
				$pcol = 'ftp://'
				For $i = 1 To 3
					msg('Downloading the newest version, wait a moment... (' & $i & '/3)')
					InetGet($pcol & $srvUrl & '/skrypty/bin/' & $nFile, @TempDir & '\' & $nFile, 1, 0)
					If @error Then ExitLoop
					If FileGetSize(@TempDir & '\' & $nFile) = $nSize Then ExitLoop
					If $i = 1 Then $pcol = 'http://'
					If $i = 2 Then $nFile = StringLeft($nFile, StringInStr($nFile, '.', 0, -1) - 1) & '.ex_'
					;If $i = 2 Then HttpSetProxy(2, $srvUrl & ':8068')
				Next
				$nFile = IniReadSectionNames($filUpd)
				$nFile = $nFile[1]
				If FileGetSize(@TempDir & '\' & $nFile) < IniRead($filUpd, $nFile, 'size', 0) Then
					msg('Download failed. Check your internet settings.', -4000, -1, -1, -1, 3)
					$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - 61200
				Else
					If FileExists($filBat) Then FileDelete($filBat)
					Sleep(1000)
					$baTemp = FileOpen($filBat, 1)
					FileWriteLine($baTemp, '@echo off' & @CRLF & 'echo                             Updating in progress ' & $script & '...' & @CRLF & 'ping -n 6 autoitscript.com' & @CRLF & 'if exist "' & @TempDir & '\' & $nFile & '" del "' & @ScriptDir & '\' & $script & '.exe"' & @CRLF & 'move "' & @TempDir & '\' & $nFile & '" "' & @ScriptDir & '\"')
					FileWriteLine($baTemp, 'ping -n 3 autoitscript.com' & @CRLF & 'if exist "' & @ScriptDir & '\' & $nFile & '" "' & @ScriptDir & '\' & $nFile & '" -u' & @CRLF & 'exit' & @CRLF & 'cls')
					FileClose($baTemp)
				EndIf
				If FileExists(@TempDir & '\' & $nFile) And FileGetSize(@TempDir & '\' & $nFile) = $nSize Then
					IniWrite(@TempDir & '\' & $nFile & '-ver.upd', 'Main', 'version', $sVer)
					msg('Update completed. Launching new version ' & StringLeft($nFile, StringInStr($nFile, '.', 0, -1) - 1) & ' ' & $nVer & '...', -3000, -1, -1, -1)
				Else
					msg('Filesize did not match. Something went wrong.', -3000, -1, -1, -1, 2)
				EndIf
				IniWrite($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
				IniWrite($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
				If FileExists($filUpd) Then FileDelete($filUpd)
				Run(@ComSpec & ' /c "' & $filBat & '" -u', '', @SW_HIDE)
				;If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
				If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
				;If IsDeclared('picDrop') And FileExists($picDrop) Then FileDelete($picDrop)
				If ProcessExists($script & '.exe') Then ProcessClose($script & '.exe')
				Exit
			Else
				If $updForce = 1 Then msg('There is no update at this time.', -2000, -1, -1, -1)
			EndIf
		EndIf
	EndIf
	If FileExists($filUpd) Then FileDelete($filUpd)
	$rcntUsed = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
	If $adlFrq = 2000 Then
		$adlFrq = 120000
		AdlibUnRegister('UpdateCheck')
	EndIf
	$updForce = 0
	AdlibRegister('UpdateCheck', $adlFrq)
EndFunc   ;==>UpdateCheck

Func StatFtp($op) ; 19.09.2010
	$fStat = @TempDir & '\' & $script & '.sta'
	$hStat = FileOpen($fStat, 1)
	If $op = 'i' Then
		$oper = 'inst'
	ElseIf $op = 'x' Then
		$oper = 'unin'
	Else
		If IniRead(@TempDir & '\' & $script & '-ver.upd', 'Main', 'version', '') <> '' Then
			$oper = IniRead(@TempDir & '\' & $script & '-ver.upd', 'Main', 'version', '') & ' =>'
		Else
			$oper = '?.?? =>'
		EndIf
	EndIf
	If Not IsDeclared('anon') Then Global $anon = 0
	If $anon = 1 Then
		$dataPrv = ' | '
	Else
		$dataPrv = ' | ' & @UserName & ' | ' & @ComputerName & ' | '
	EndIf
	FileWriteLine($hStat, @MDAY & '.' & @MON & '.' & @YEAR & ', ' & @HOUR & ':' & @MIN & ':' & @SEC & $dataPrv & @IPAddress1 & ' | ' & _GetIP() & ' | ' & FileGetSize(@ScriptFullPath) & ' b | ' & $oper & ' ' & $sVer)
	FileClose($hStat)
	$fTemp = @TempDir & '\' & $script & '.ftp'
	$hFtp = FileOpen($fTemp, 2)
	FileWriteLine($hFtp, 'open monter.homeip.net')
	FileWriteLine($hFtp, 'anonymous')
	FileWriteLine($hFtp, $script)
	FileWriteLine($hFtp, 'cd skrypty/stats')
	FileWriteLine($hFtp, 'append ' & $fStat)
	FileWriteLine($hFtp, 'quit')
	FileClose($hFtp)
	RunWait(@ComSpec & ' /c ftp -s:' & $fTemp, '', @SW_HIDE)
	Sleep(1000)
	If FileExists($fStat) Then FileDelete($fStat)
	If FileExists($fTemp) Then FileDelete($fTemp)
	If FileExists(@TempDir & '\' & $script & '-ver.upd') Then FileDelete(@TempDir & '\' & $script & '-ver.upd')
EndFunc   ;==>StatFtp

Func _GetIP() ; modified Larry/Ezzetabi & Jarvis Stubblefield script
	Local $ip, $t_ip
	If InetGet('                             ' & Random(1, 65536) & '&rnd2=' & Random(1, 65536), @TempDir & '\~ip.tmp') Then
		$ip = FileRead(@TempDir & '\~ip.tmp', FileGetSize(@TempDir & '\~ip.tmp'))
		FileDelete(@TempDir & '\~ip.tmp')
		$ip = StringTrimLeft($ip, StringInStr($ip, '<h2 class="ip">') + 14)
		$ip = StringTrimRight($ip, StringLen($ip) - StringInStr($ip, '/') + 2)
		$ip = StringStripWS($ip, 8)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	If InetGet('                                 ' & Random(1, 65536) & '&rnd2=' & Random(1, 65536), @TempDir & '\~ip.tmp') Then
		$ip = FileRead(@TempDir & '\~ip.tmp', FileGetSize(@TempDir & '\~ip.tmp'))
		FileDelete(@TempDir & '\~ip.tmp')
		$ip = StringTrimLeft($ip, StringInStr($ip, '<div class="ip">') + 15)
		$ip = StringTrimRight($ip, StringLen($ip) - StringInStr($ip, '/') + 2)
		$ip = StringStripWS($ip, 8)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	Return SetError(1, 0, -1)
EndFunc   ;==>_GetIP

Func FileInfo()
	If @Compiled Then ;section identifying script's version and release date from #AutoIt3Wrapper fields :-)
		Global $sVer = StringFormat('%.2f', Number(StringReplace(FileGetVersion(@ScriptFullPath), '.', '')) / 1000) ;script's version in x.xx format
		Global $dateRlse = FileGetVersion(@ScriptFullPath, 'Release date')
	Else
		Opt('TrayIconDebug', 1)
		$strRes = '#AutoIt3Wrapper_'
		For $ln = 1 To 50
			$srchRes = StringInStr(FileReadLine(@ScriptFullPath, $ln), $strRes)
			If $srchRes > 0 Then
				$lr = $ln
				ExitLoop
			EndIf
		Next
		$strRes = '#AutoIt3Wrapper_Res_Fileversion='
		Dim $lnRes[3]
		For $i = 1 To 2
			For $ln = $lr To $lr + 16
				$srchRes = StringInStr(FileReadLine(@ScriptFullPath, $ln), $strRes)
				If $srchRes > 0 Then
					$lnRes[$i] = $ln
					ExitLoop
				EndIf
			Next
			$strRes = '#AutoIt3Wrapper_Res_Field=Release date|'
		Next
		Global $sVer = StringFormat('%.2f', Number(StringReplace(StringTrimLeft(FileReadLine(@ScriptFullPath, $lnRes[1]), 32), '.', '')) / 1000)
		$rd = FileGetTime(@ScriptFullPath, 0, 0)
		_FileWriteToLine(@ScriptFullPath, $lnRes[2], '#AutoIt3Wrapper_Res_Field=Release date|' & $rd[2] & '.' & $rd[1] & '.' & $rd[0], 1)
		Global $dateRlse = $rd[2] & '.' & $rd[1] & '.' & $rd[0]
		FileSetTime(@ScriptFullPath, $rd[0] & $rd[1] & $rd[2] & $rd[3] & $rd[4] & $rd[5], 0)
	EndIf
EndFunc   ;==>FileInfo

Func msg($txt = '', $ms = 1500, $title = -1, $ttX = -1, $ttY = -2, $icn = 1, $tray = -1)
	If $ms >= 0 And $ms < 250 Then $ms = 250
	If $ms = -1 Then $ms = 1500
	If $ms < -1 Then
		$ms = Abs($ms)
		$clr = 1
	EndIf
	If $title = -1 Then
		$scN = StringSplit(@ScriptName, '.')
		$title = $scN[1]
		If IsDeclared('fnScript') And IsDeclared('sVer') Then $title = $fnScript & ' ' & $sVer
	EndIf
	If $ttX = -1 Then $ttX = Int(@DesktopWidth / 2)
	If $ttY = -1 Then $ttY = Int(@DesktopHeight / 2)
	If $ttY = -2 Then $ttY = @DesktopHeight - 64
	If $icn = 2 Then $txt = 'Warning!' & @CRLF & $txt
	If $icn = 3 Then $txt = 'ERROR!' & @CRLF & $txt
	If $tray = -1 Then ToolTip($txt, $ttX, $ttY, $title, $icn, 2)
	If $tray = 1 Then TrayTip($title, $txt, $ms, $icn)
	Sleep($ms)
	If IsDeclared('clr') Then ToolTip('')
EndFunc   ;==>msg

Func OnExit()
	BlockInput(0)
	If Not IsDeclared('runAlr') Then
		If $iniDel = 0 Then
			IniWrite($ini, 'Main', 'rcntUsed', $rcntUsed)
			IniWrite($ini, 'Main', 'rcntUpdChk', $rcntUpdChk)
			$countTimes = $countTimes + 1
			IniWrite($ini, 'Main', 'countTimes', $countTimes)
			IniWrite($ini, 'Main', 'anon', $anon)
		Else
			If FileExists($ini) Then FileDelete($ini)
		EndIf
		$onx = 1
		;If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
		If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
	EndIf
EndFunc   ;==>OnExit
