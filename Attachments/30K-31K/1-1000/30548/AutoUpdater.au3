#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=G:\util\AutoUpdater.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=http://monter.FM
#AutoIt3Wrapper_Res_Description=Example of auto-update function in AutoIt3 script.
#AutoIt3Wrapper_Res_Fileversion=0.3.0.0
#AutoIt3Wrapper_Res_LegalCopyright=monter.FM
#AutoIt3Wrapper_Res_Field=Release date|09.05.2010
#AutoIt3Wrapper_Res_Field=AutoIt3 ver.|%AutoItVer%
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <Timers.au3>
#include <File.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
$fnScript = 'Auto Updater (example script)' ;full script name
$pScript = StringSplit(@ScriptName, '.')
$pScript = $pScript[1]
$script = $pScript
If $script <> 'AutoUpdater' Then $script = 'AutoUpdater' ;proper script name (if user changed it)
Global $srvPthExe, $srvPthUpd, $version, $pos[3], $chkFrq, $msgShw, $rcntUpdChk, $rcntUsed
$ini = @ScriptDir & '\' & $script & '.ini'
FileChangeDir(@ScriptDir)
OnAutoItExitRegister('OnExit')
FileInfo()
$title = $fnScript & ' ' & $sVer
$dirMonter = @AppDataDir & '\monter.FM' ;directory for monter.FM's scripts
$filUpd = @TempDir & '\' & $script & '.upd' ;file checking update from the server
$filBat = @TempDir & '\' & $script & '.bat' ;temporary file for killing old exe and launching new version
$src = @TempDir & '\' & $script & '.au3' ;source file
If FileExists($filUpd) Then FileDelete($filUpd)
If FileExists($filBat) Then FileDelete($filBat)
$version = IniRead($ini, 'Main', 'version', $sVer)
$iniDel = 0
If $rcntUsed = '' Or ($CmdLine[0] > 0 And $CmdLine[1] = '-i') Then Install()
If ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then UpdateIcons()
If $sVer > $version Then UpdateIni()
IniCheck()
IniFRead()
Const $wi = 370
Const $he = 213
If $pos[1] > @DesktopWidth - $wi Then $pos[1] = @DesktopWidth - $wi - 50
If $pos[1] < 0 Then $pos[1] = 50
If $pos[2] > @DesktopHeight - $he Then $pos[2] = @DesktopHeight - $he - 100
If $pos[2] < 0 Then $pos[2] = 50
For $i = 1 To 2
	If $pos[$i] = 'default' Then $pos[$i] = -1
Next

#region ### START Koda GUI section ### Form=AutoUpdater.kxf
$frmMain = GUICreate($title, $wi, $he, $pos[1], $pos[2])
$mnuFil = GUICtrlCreateMenu('&File')
$mnuFilQuit = GUICtrlCreateMenuItem('&Quit' & @TAB & 'Ctrl+Q', $mnuFil)
GUICtrlCreateMenuItem('', $mnuFil)
$mnuFilUnins = GUICtrlCreateMenuItem('Uninstall', $mnuFil)
$mnuHlp = GUICtrlCreateMenu('&Help')
$mnuHlpAbt = GUICtrlCreateMenuItem('&About', $mnuHlp)
$lblExpl = GUICtrlCreateLabel('This is an example of auto-update function in AutoIt3 script.', 44, 4, 283, 17)
$grpChkFrq = GUICtrlCreateGroup('Update checking frequency', 4, 28, 261, 53)
$radChkFrq0 = GUICtrlCreateRadio('&every 24 hours (default)', 24, 44, 105, 33, BitOR($GUI_SS_DEFAULT_RADIO, $BS_MULTILINE))
GUICtrlSetTip(-1, 'that is 86400 seconds')
$radChkFrq1 = GUICtrlCreateRadio('e&very 60 seconds (testing purpose)', 144, 44, 105, 33, BitOR($GUI_SS_DEFAULT_RADIO, $BS_MULTILINE))
If $chkFrq > 86399 Then
	GUICtrlSetState($radChkFrq0, $GUI_CHECKED)
Else
	GUICtrlSetState($radChkFrq1, $GUI_CHECKED)
EndIf
GUICtrlCreateGroup('', -99, -99, 1, 1)
$cbxMsgShw = GUICtrlCreateCheckbox('show &ALL messages (including hidden)', 284, 30, 73, 53, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_MULTILINE))
If $msgShw = 1 Then
	GUICtrlSetState($cbxMsgShw, $GUI_CHECKED)
Else
	GUICtrlSetState($cbxMsgShw, $GUI_UNCHECKED)
EndIf
$grpSrvSet = GUICtrlCreateGroup('Server settings (usually hidden in .INI file)', 4, 88, 361, 73)
$lblPthExe = GUICtrlCreateLabel('Path to script file:', 16, 112, 85, 17)
$srvPthExe = InpPth($srvPthExe)
$inpPthExe = GUICtrlCreateInput('', 112, 108, 153, 21)
GUICtrlSetData($inpPthExe, $srvPthExe)
$lblFilExe = GUICtrlCreateLabel('/' & $script & '.exe', 268, 112, 89, 17)
$lblPthUpd = GUICtrlCreateLabel('Path to update file:', 16, 136, 93, 17)
$srvPthUpd = InpPth($srvPthUpd)
$inpPthUpd = GUICtrlCreateInput('', 112, 132, 153, 21)
GUICtrlSetData($inpPthUpd, $srvPthUpd)
$lblFilUpd = GUICtrlCreateLabel('/' & $script & '.upd', 268, 136, 90, 17)
GUICtrlCreateGroup('', -99, -99, 1, 1)
$btnIni = GUICtrlCreateButton('View ' & $script & '.&ini', 4, 164, 115, 25)
$btnFilUpd = GUICtrlCreateButton('View ' & $script & '.&upd', 126, 164, 119, 25)
If FileExists($filUpd) Then
	GUICtrlSetState($btnFilUpd, $GUI_ENABLE)
Else
	GUICtrlSetState($btnFilUpd, $GUI_DISABLE)
EndIf
$btnSrc = GUICtrlCreateButton('&Show source code', 252, 164, 111, 25)
Dim $frmMain_AccelTable[1][2] = [['^q', $mnuFilQuit]]
GUISetAccelerators($frmMain_AccelTable)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

UpdateCheck()
AdlibRegister('UpdateCheck', 60000)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $mnuFilQuit
			Exit
		Case $mnuFilUnins
			Uninstall()
		Case $mnuHlpAbt
			About()
		Case $radChkFrq0
			GUICtrlSetState($radChkFrq0, $GUI_CHECKED)
			$chkFrq = 86400
		Case $radChkFrq1
			GUICtrlSetState($radChkFrq1, $GUI_CHECKED)
			$chkFrq = 60
		Case $cbxMsgShw
			MsgShw()
		Case $inpPthExe
			$srvPthExe = GUICtrlRead($inpPthExe)
			$srvPthExe = InpPth($srvPthExe)
			GUICtrlSetData($inpPthExe, $srvPthExe)
			$wPos = WinGetPos($title)
			ToolTip('Saved path to .exe file.', $wPos[0] + 115, $wPos[1] + 180)
			Sleep(1500)
			ToolTip('')
		Case $inpPthUpd
			$srvPthUpd = GUICtrlRead($inpPthUpd)
			$srvPthUpd = InpPth($srvPthUpd)
			GUICtrlSetData($inpPthUpd, $srvPthUpd)
			$wPos = WinGetPos($title)
			ToolTip('Saved path to .upd file.', $wPos[0] + 115, $wPos[1] + 204)
			Sleep(1500)
			ToolTip('')
		Case $btnIni
			Run('notepad.exe ' & $ini)
		Case $btnFilUpd
			Run('notepad.exe ' & $filUpd)
		Case $btnSrc
			SrcShow()
	EndSwitch
WEnd

Func MsgShw()
	If $msgShw = 1 Then
		GUICtrlSetState($cbxMsgShw, $GUI_UNCHECKED)
		$msgShw = 0
	Else
		GUICtrlSetState($cbxMsgShw, $GUI_CHECKED)
		$msgShw = 1
	EndIf
EndFunc   ;==>MsgShw

Func Install()
	If @Compiled Then
		If Not FileExists($dirMonter) Then DirCreate($dirMonter)
		FileChangeDir($dirMonter)
		If @ScriptDir <> $dirMonter Then
			$del = 1
			$instCpyMovTxt = 'Moving'
			If StringLeft(@ScriptDir, 3) <> StringLeft(@AppDataDir, 3) Then
				$del = 0
				$instCpyMovTxt = 'Copying'
			EndIf
			msg('Launching script for the first time.' & @CRLF & $instCpyMovTxt & ' file into the proper localization, wait a moment...')
			$list = ProcessList($script & '.exe')
			For $i = 1 To $list[0][0]
				$pid = WinGetProcess($script)
				ProcessClose($pid)
			Next
			Sleep(1000)
			FileCopy(@ScriptFullPath, $dirMonter & '\' & $script & '.exe', 9)
			If Not FileExists(@ProgramsDir & '\monter.FM\') Then DirCreate(@ProgramsDir & '\monter.FM\')
			FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & @ScriptName, '', 4)
			msg()
			$mb = MsgBox(36, $title, 'Do you want the shortcut on the desktop?', 12)
			If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & @ScriptName, '', 4)
			If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
			$baTemp = FileOpen($filBat, 1)
			If $del = 1 Then FileWriteLine($baTemp, 'ping -n 4 autoitscript.com' & @CRLF & 'if exist "' & @ScriptFullPath & '" del "' & @ScriptFullPath & '"')
			FileWriteLine($baTemp, 'ping -n 2 autoitscript.com' & @CRLF & 'if exist "' & $dirMonter & '\' & $script & '.exe' & '" "' & $dirMonter & '\' & $script & '.exe' & '" -h' & @CRLF & 'exit' & @CRLF & 'cls')
			FileClose($baTemp)
			If FileExists($ini) Then FileDelete($ini)
			Sleep(2000)
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

Func UpdateIcons()
	MsgBox(64, $title, 'You have just launched the new version of ' & $fnScript & ' ' & $sVer, 10)
	FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 4)
	If FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then
		FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 4)
	Else
		$mb = MsgBox(36, $title, 'Do you want the shortcut on the desktop?', 12)
		If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 4)
		If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
	EndIf
EndFunc   ;==>UpdateIcons

Func UpdateIni() ; here you can convert/modify/delete older ini entries to the current format
	IniWrite($ini, 'Main', 'version', $sVer)
	IniWrite($ini, 'Updater', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
EndFunc   ;==>UpdateIni

Func IniCheck()
	If IniRead($ini, 'Main', 'version', '') = '' Then IniWrite($ini, 'Main', 'version', $sVer)
	If IniRead($ini, 'Main', 'savedPos', '') = '' Then IniWrite($ini, 'Main', 'savedPos', 'default|default')
	If IniRead($ini, 'Main', 'chkFrq', '') = '' Then IniWrite($ini, 'Main', 'chkFrq', 86400)
	If IniRead($ini, 'Main', 'msgShw', '') = '' Then IniWrite($ini, 'Main', 'msgShw', 0)
	If IniRead($ini, 'Updater', 'srvPthExe', '') = '' Then IniWrite($ini, 'Updater', 'srvPthExe', 'monter.homeip.net/skrypty/bin/' & $script & '.exe')
	If IniRead($ini, 'Updater', 'srvPthUpd', '') = '' Then IniWrite($ini, 'Updater', 'srvPthUpd', 'monter.homeip.net/skrypty/bin/' & $script & '.upd')
	If IniRead($ini, 'Updater', 'rcntUpdChk', '') = '' Then IniWrite($ini, 'Updater', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	If IniRead($ini, 'Updater', 'rcntUsed', '') = '' Then IniWrite($ini, 'Updater', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
EndFunc   ;==>IniCheck

Func IniFRead()
	$pos = StringSplit(IniRead($ini, 'Main', 'savedPos', 'default|default'), '|')
	$chkFrq = IniRead($ini, 'Main', 'chkFrq', 86400)
	$msgShw = IniRead($ini, 'Main', 'msgShw', 0)
	$srvPthExe = IniRead($ini, 'Updater', 'srvPthExe', 'monter.homeip.net/skrypty/bin/' & $script & '.exe')
	$srvPthUpd = IniRead($ini, 'Updater', 'srvPthUpd', 'monter.homeip.net/skrypty/bin/' & $script & '.upd')
	$rcntUpdChk = IniRead($ini, 'Updater', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	$rcntUsed = IniRead($ini, 'Updater', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
EndFunc   ;==>IniFRead

Func InpPth($pth)
	$ext = StringRight(Eval('pth'), 3)
	$pth = StringReplace($pth, '\', '/')
	If StringInStr($pth, '://', 0, 1) <> 0 Then $pth = StringTrimLeft($pth, StringInStr($pth, '://', 0, 1) + 2)
	If StringInStr($pth, $script & '.' & $ext) <> 0 Then $pth = StringTrimRight($pth, StringLen($script & '.' & $ext))
	If StringRight($pth, 1) = '/' Then $pth = StringTrimRight($pth, 1)
	Return $pth
EndFunc   ;==>InpPth

Func UpdateCheck()
	If $msgShw = 1 Then msg('Checking for previous update checking time: ' & _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk & ' seconds ago.', -2500)
	If _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk >= $chkFrq Or $rcntUsed = $rcntUpdChk Then
		$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
		$srvPth = StringTrimRight($srvPthUpd, StringInStr($srvPthUpd, '/', 0, -1))
		$pcol = 'ftp://'
		For $i = 1 To 2 ;you may add proxy server (1 To 3)
			If $msgShw = 1 Then msg('Checking update on server, wait a moment... (' & $i & '/2)' & @CRLF & 'Downloading file ' & $pcol & $srvPthUpd & '/' & $script & '.upd')
			InetGet($pcol & $srvPthUpd & '/' & $script & '.upd', $filUpd, 1, 0)
			Sleep(1500)
			If FileExists($filUpd) And FileGetSize($filUpd) > 30 Then ExitLoop
			If $i = 1 Then $pcol = 'http://'
			;If $i = 2 Then HttpSetProxy(2, $serverUrl & ':8080')
		Next
		If FileExists($filUpd) Then
			GUICtrlSetState($btnFilUpd, $GUI_ENABLE)
		Else
			GUICtrlSetState($btnFilUpd, $GUI_DISABLE)
		EndIf
		ToolTip('')
		;HttpSetProxy(1)
		If Not FileExists($filUpd) Then Sleep(2500)
		If Not FileExists($filUpd) Or FileGetSize($filUpd) < 30 Then
			msg('Network error. Update failed.', -4000, -1, -1, -1, 3)
			$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk + Int($chkFrq / 20)
		Else
			$nVer = IniRead($filUpd, $script & '.exe', 'version', '0.0.0.0')
			$nVer = StringFormat('%.2f', Number(StringReplace($nVer, '.', '')) / 1000)
			$nSize = IniRead($filUpd, $script & '.exe', 'size', '999999999')
			If $nVer > $sVer Then
				$pcol = 'ftp://'
				$nFile = IniReadSectionNames($filUpd)
				$nFile = $nFile[1]
				For $i = 1 To 2 ; (+ proxy: 1 To 3)
					If $msgShw = 1 Then
						msg('Downloading the newest version, wait a moment... (' & $i & '/2)' & @CRLF & $pcol & $srvPthExe & '/' & $nFile & '(' & $nSize & ' b)')
					Else
						msg('Downloading the newest version, wait a moment... (' & $i & '/2)')
					EndIf
					InetGet($pcol & $srvPthExe & '/' & $nFile, @TempDir & '\' & $script & '.exe', 1, 0)
					If FileGetSize(@TempDir & '\' & $script & '.exe') = $nSize Then ExitLoop
					If $i = 1 Then $pcol = 'http://'
					;If $i = 2 Then HttpSetProxy(2, $serverUrl & ':8080')
				Next
				If FileGetSize(@TempDir & '\' & $script & '.exe') < IniRead($filUpd, $script & '.exe', 'size', 0) Then
					msg('Downloading the newest version failed. Check Internet settings.', -3000, -1, -1, -1, 3)
					$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk + Int($chkFrq / 20)
				Else
					If FileExists($filBat) Then FileDelete($filBat)
					Sleep(1000)
					$baTemp = FileOpen($filBat, 1)
					FileWriteLine($baTemp, '@echo off' & @CRLF & 'echo                             Updating in progress ' & $script & '...' & @CRLF & 'ping -n 6 autoitscript.com' & @CRLF & 'if exist "' & @TempDir & '\' & $script & '.exe" del "' & @ScriptDir & '\' & $script & '.exe"' & @CRLF & 'move "' & @TempDir & '\' & $script & '.exe" "' & @ScriptDir & '\"')
					FileWriteLine($baTemp, 'ping -n 3 autoitscript.com' & @CRLF & 'if exist "' & @ScriptDir & '\' & $script & '.exe" "' & @ScriptDir & '\' & $script & '.exe" -u' & @CRLF & 'exit' & @CRLF & 'cls')
					FileClose($baTemp)
				EndIf
				If FileExists(@TempDir & '\' & $script & '.exe') And FileGetSize(@TempDir & '\' & $script & '.exe') = $nSize Then
					msg('Update finished succesfully. Launching the new version ' & $fnScript & ' ' & $nVer & '...', -3000, -1, -1, -1)
				Else
					msg("The new script's filesize is not proper. Something went wrong.", -3000, -1, -1, -1, 2)
				EndIf
				$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
				IniWrite($ini, 'Updater', 'rcntUpdChk', $rcntUpdChk)
				If FileExists($filUpd) Then FileDelete($filUpd)
				$updFrq = 86400000
				Run(@ComSpec & ' /c "' & $filBat & '" -u', '', @SW_HIDE)
				If ProcessExists($script & '.exe') Then ProcessClose($script & '.exe')
				Exit
			EndIf
		EndIf
		IniWrite($ini, 'Updater', 'rcntUpdChk', $rcntUpdChk)
	EndIf
	$rcntUsed = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
EndFunc   ;==>UpdateCheck

Func SrcShow()
	$srvPthSrc = StringLeft($srvPthExe, StringInStr($srvPthExe, '/', 0, -1) - 1)
	If Not FileExists($src) Then
		If $msgShw = 1 Then
			msg('Downloading the source code, wait a moment...' & @CRLF & 'http://' & $srvPthSrc & '/src/' & $script & '.au3')
		Else
			msg('Downloading the source code, wait a moment...')
		EndIf
		InetGet('http://' & $srvPthSrc & '/src/' & $script & '.au3', $src, 1)
		Sleep(500)
	EndIf
	Run('notepad.exe ' & $src)
	msg()
EndFunc   ;==>SrcShow

Func Uninstall()
	If @Compiled Then
		$uninQry = MsgBox(308, $title, 'Are you sure you want to uninstall/delete ' & $fnScript & ' from disk?', 12)
		If $uninQry = 6 Then
			msg('Uninstalling ' & $title & ' in progress...')
			GUIDelete($frmMain)
			If FileExists($ini) Then FileDelete($ini)
			If FileExists(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk') Then FileDelete(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk')
			If FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
			If Not FileExists(@ProgramsDir & '\monter.FM\*.*') Then DirRemove(@ProgramsDir & '\monter.FM')
			If FileExists($filBat) Then FileDelete($filBat)
			Sleep(1000)
			$baTemp = FileOpen($filBat, 1)
			FileWriteLine($baTemp, 'echo                             Uninstall in progress: ' & $title & '...' & @CRLF & ':loop' & @CRLF & 'ping -n 3 autoitscript.com' & @CRLF & 'del "' & @ScriptDir & '\' & $script & '.exe"')
			FileWriteLine($baTemp, 'ping -n 2 autoitscript.com' & @CRLF & 'if exist "' & @ScriptDir & '\' & $script & '.exe" goto loop')
			FileWriteLine($baTemp, 'ping -n 4 autoitscript.com' & @CRLF & 'del "' & $filBat & '"' & @CRLF & 'exit' & @CRLF & 'cls')
			FileClose($baTemp)
			Sleep(1000)
			Run(@ComSpec & ' /c ' & $filBat, '', @SW_HIDE)
			If ProcessExists(@ScriptName) Then ProcessClose(@ScriptName)
			$iniDel = 1
			Exit
		Else
			msg('Uninstall aborted.', -2500)
		EndIf
	Else
		msg('Compiled ' & $title & ' would be uninstalled now.' & @CRLF & 'Quitting the script.', 2500)
		Exit
	EndIf
EndFunc   ;==>Uninstall

Func FileInfo()
	If @Compiled Then ;section identifying script's version and release date from #AutoIt3Wrapper fields :-)
		Global $sVer = StringFormat('%.2f', Number(StringReplace(FileGetVersion(@ScriptFullPath), '.', '')) / 1000) ;script's version in x.xx format
		Global $dateRlse = FileGetVersion(@ScriptFullPath, 'Release date')
	Else
		Opt('TrayIconHide', 0)
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

Func About()
	$frmAbout = GUICreate($title & ' - About', $wi + 20, 120, -1, -1, -1, BitOR($WS_EX_WINDOWEDGE, $WS_EX_APPWINDOW), $frmMain)
	GUICtrlCreateLabel(StringFormat('Example of auto-update function in AutoIt3 script.'), 25, 8, 292, 69)
	GUICtrlCreateLabel($title & ' built on AutoIt ' & @AutoItVersion, 25, 28, 284, 35)
	GUICtrlCreateLabel($dateRlse, 300, 48, 50, 15)
	GUICtrlSetFont(-1, 7, 400, 0, 'Tahoma')
	$btnOkAbt = GUICtrlCreateButton('OK', 174, 90, 51, 25)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		If $nMsg = $GUI_EVENT_CLOSE Or $nMsg = $btnOkAbt Then ExitLoop
	WEnd
	GUIDelete($frmAbout)
EndFunc   ;==>About

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
	If FileExists($filUpd) Then FileDelete($filUpd)
	If IsDeclared('src') Then FileDelete($src)
	If $iniDel = 0 Then
		IniWrite($ini, 'Main', 'chkFrq', $chkFrq)
		IniWrite($ini, 'Main', 'msgShw', $msgShw)
		IniWrite($ini, 'Updater', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
		IniWrite($ini, 'Updater', 'srvPthExe', $srvPthExe & '/' & $script & '.exe')
		IniWrite($ini, 'Updater', 'srvPthUpd', $srvPthUpd & '/' & $script & '.upd')
		If IsDeclared('pos') Then
			$wPos = WinGetPos($title)
			If $wPos[0] <> -32000 Then IniWrite($ini, 'Main', 'savedPos', $wPos[0] & '|' & $wPos[1])
		EndIf
	EndIf
EndFunc   ;==>OnExit
