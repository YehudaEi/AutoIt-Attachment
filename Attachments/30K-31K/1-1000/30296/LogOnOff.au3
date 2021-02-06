#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=rob\bpm-ico\LogOnOff.ico
#AutoIt3Wrapper_Outfile=G:\util\LogOnOff.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=http://monter.FM/
#AutoIt3Wrapper_Res_Description=Keeps alive user session, prevents from suspension. After longer inactivity, script performs auto-logoff.
#AutoIt3Wrapper_Res_Fileversion=1.2.3.0
#AutoIt3Wrapper_Res_LegalCopyright=monter.FM
#AutoIt3Wrapper_Res_Language=1045
#AutoIt3Wrapper_Res_Field=Release date|12.04.2010
#AutoIt3Wrapper_Res_Field=AutoIt3 ver.|%AutoItVer%
#AutoIt3Wrapper_Res_Icon_Add=rob\bpm-ico\LogOnOff1.ico
#AutoIt3Wrapper_Res_Icon_Add=rob\bpm-ico\LogOnOff2.ico
#AutoIt3Wrapper_Res_File_Add=LogOnOff.english.lng
#AutoIt3Wrapper_Res_File_Add=LogOnOff.polski.lng
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <File.au3>
#include <Timers.au3>
#include <Misc.au3>
#include <Process.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <UpdownConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include 'AU3\GUIOnChangeRegister.au3' ;Mat's UDF
$fnScript = 'LogOnOff' ;full script name
$pScript = StringSplit(@ScriptName, '.')
$pScript = $pScript[1]
$script = $pScript
If $script <> 'LogOnOff' Then $script = 'LogOnOff' ;proper script name (if user changed it)
FileInstall('.\rob\bpm-ico\LogOnOff.ico', @TempDir & '\', 1)
FileInstall('.\rob\bpm-ico\LogOnOff1.ico', @TempDir & '\', 1)
FileInstall('.\rob\bpm-ico\LogOnOff2.ico', @TempDir & '\', 1)
$icon = @TempDir & '\' & $script & '.ico'
$icon1 = @TempDir & '\' & $script & '1.ico'
$icon2 = @TempDir & '\' & $script & '2.ico'
TraySetIcon($icon)
FileInfo()
$title = $fnScript & ' ' & $sVer
TraySetToolTip($title & @CRLF & @UserName)
OnAutoItExitRegister('OnExit')
Global $serverUrl, $counTimes, $update, $updState, $updCheck, $lng, $currFileLang, $langFiList, $lngList, $rcntUsed, $cboLang, $intval, $loops, $timremnS, $lOffDly, $monOff, $logoff, $paused, $loop, $lOffTime
Global $l_grpSetts, $l_tipIntval, $l_tipLoops, $l_tipLogofDly, $l_cbxMonOff, $l_tipMonOff, $l_cboLogoff, $l_tipLogoff, $l_lblIntval, $l_lblLoops, $l_lblLogofDly, $l_btnSave, $l_btnSaved, $l_btnDefRestore, $l_btnDefaults, $l_btnPausWork0, $l_btnPausWork1, $l_btnSuspend, $l_lblAutOff, $l_lblAutOffSus, $l_btnLogoff, $l_btnUninst, $l_tipLang, $l_tipLangEdit, $l_tipAbout, $l_trSetts, $l_trLogoff, $l_trSuspend, $l_trPause0, $l_trPause1, $l_trPaused ;, $l_cbxNoLogoff, $l_tipNoLogoff, $l_cbxLogoffForce, $l_tipLogoffForce
Global $l_trAbout, $l_trExit, $l_pausQry, $l_pausMsg0, $l_pausMsg1, $l_msgLogoff1, $l_msgLogoffNo, $l_msgLogoff2, $l_msgLogoffBrk, $l_msgLogoffEsc, $l_msgUpdateCheck, $l_msgUpdateError, $l_msgUpdateDownload, $l_msgUpdateFailed, $l_msgUpdateOk, $l_msgAdmLock, $l_msgDisclaimer, $l_msgFileMoving, $l_msgExitQuery, $l_msgUninstall, $l_msgUninstallProcess, $l_msgUninstallDelOthLangs, $l_msgWarning, $l_msgError, $l_lblAboutTitle, $l_lblAboutTxt, $l_lblBuilt, $l_lblWww, $l_lblWwwApp, $l_lblWwwForum
$ini = @ScriptDir & '\' & $script & '.ini'
$serverUrl = 'monter.homeip.net'
If FileExists($ini) And $CmdLine[0] = 0 Then
	If _Singleton(@ScriptName, 1) = 0 Then
		$runAlr = 1
		WinSetState($script, '', @SW_SHOW)
		WinActivate($script)
		Exit
	EndIf
EndIf
$dirMonter = @AppDataDir & '\monter.FM' ;directory for monter.FM's apps
$fileAutoUpd = @TempDir & '\' & $script & '.upd' ;file checking upgrade from monter's server
$fileBat = @TempDir & '\' & $script & '.bat' ;temporary file for deleting old exe and launching new version script
$esc = 0
$brk = 0
$sex = 0
$syn = 0
$synTm = 0
$letSuspend = 0
If FileExists($fileAutoUpd) Then FileDelete($fileAutoUpd)
If FileExists($fileBat) Then FileDelete($fileBat)
$version = IniRead($ini, 'Main', 'version', $sVer)
$currFileLang = @ScriptDir & '\' & IniRead($ini, 'Main', 'currentLangFile', $script & '.english.lng')
If Not FileExists($currFileLang) Then $currFileLang = ''
LangCheck()
LangRead()
LangRefresh()
If $rcntUsed = '' Or ($CmdLine[0] > 0 And $CmdLine[1] = '-i') Then Install()
If ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then Update() ; 09.04.2010. - dodaæ ten warunek do innych skryptów
If $sVer > $version Then UpdateIni() ;09.04.2010 moved to Func
IniCheck()
IniReadF()
$kaCzki = '' ;useful for polish translation only
$kaCzke = ''
If (StringInStr('0415', @OSLang) And Not FileExists(@ScriptDir & '\' & $script & '.polski.lng')) Or $lng = 'PL' Then
	$kaCzki = 'ka'
	$kaCzke = 'ka'
	If $sex = 1 Then
		$kaCzki = 'czki'
		$kaCzke = 'czkê'
	EndIf
EndIf
UpdateCheck()
FileInstall('.\rob\monter.FM.gif', @TempDir & '\', 1)
$monterGif = @TempDir & '\monter.FM.gif'
Const $wi = 323
Const $he = 240
$loffCurr = StringSplit($l_cboLogoff, '|')
For $i = 2 To 0 Step -1
	If $logoff = $i Then $logoffCurr = $loffCurr[Abs($i - 3)]
Next

#Region ### START Koda GUI section ### Form=LogOnOff-mainSetts.kxf
$frmMain = GUICreate($title, $wi, $he, -1, -1)
GUISetIcon($icon)
$grpSetts = GUICtrlCreateGroup($l_grpSetts, 3, 0, 244, 189)
$inpIntval = GUICtrlCreateInput($intval, 202, 17, 41, 21, BitOR($ES_RIGHT, $ES_NUMBER))
GUICtrlSetTip(-1, $l_tipIntval)
GUICtrlSetLimit(-1, 3)
$udIntval = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 999, 4)
GUICtrlSetTip(-1, $l_tipIntval)
$inpLoops = GUICtrlCreateInput($loops, 208, 53, 35, 21, BitOR($ES_RIGHT, $ES_NUMBER))
GUICtrlSetTip(-1, $l_tipLoops)
GUICtrlSetLimit(-1, 2)
$udLoops = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 99, 1)
GUICtrlSetTip(-1, $l_tipLoops)
$inpLogofDly = GUICtrlCreateInput($lOffDly, 208, 92, 35, 21, BitOR($ES_RIGHT, $ES_NUMBER))
GUICtrlSetTip(-1, $l_tipLogofDly)
GUICtrlSetLimit(-1, 2)
$udLogofDly = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 99, 2)
GUICtrlSetTip(-1, $l_tipLogofDly)
For $c = $inpIntval To $inpLogofDly Step 2
	GUICtrlOnChangeRegister($c, 'LogoffTimeRefresh', $c) ;refreshing remaining time to automatic logoff
Next
$cbxMonOff = GUICtrlCreateCheckbox($l_cbxMonOff & '    ', 7, 125, 220, 17, BitOR($BS_CHECKBOX, $BS_RIGHTBUTTON, $BS_RIGHT, $WS_TABSTOP))
$tipMonOff = GUICtrlSetTip(-1, $l_tipMonOff)
If $monOff = 1 Then
	GUICtrlSetState($cbxMonOff, $GUI_CHECKED)
Else
	GUICtrlSetState($cbxMonOff, $GUI_UNCHECKED)
EndIf
$cboLogoff = GUICtrlCreateCombo('', 84, 152, 159, 21)
GUICtrlSetData(-1, $l_cboLogoff, $logoffCurr)
GUICtrlSetTip(-1, StringFormat($l_tipLogoff))
$lblIntval = GUICtrlCreateLabel($l_lblIntval, 4, 20, 195, 17, $SS_RIGHT)
GUICtrlSetTip(-1, $l_tipIntval)
$lblLoops = GUICtrlCreateLabel($l_lblLoops, 4, 56, 195, 17, $SS_RIGHT)
GUICtrlSetTip(-1, $l_tipLoops)
$lblLogofDly = GUICtrlCreateLabel(StringFormat($l_lblLogofDly), 4, 88, 195, 35, $SS_RIGHT)
GUICtrlSetTip(-1, $l_tipLogofDly)
If $logoff = 0 Then
	GUICtrlSetState($lblLogofDly, $GUI_DISABLE)
	GUICtrlSetState($inpLogofDly, $GUI_DISABLE)
	GUICtrlSetState($udLogofDly, $GUI_DISABLE)
EndIf
AdlibRegister('LogoffTimeShow')
GUICtrlCreateGroup('', -99, -99, 1, 1)
$btnSave = GUICtrlCreateButton($l_btnSave, 252, 5, 67, 27, BitOR($BS_DEFPUSHBUTTON, $BS_MULTILINE, $WS_GROUP))
SaveIniCompare()
$btnDefRestore = GUICtrlCreateButton($l_btnDefRestore, 252, 36, 67, 35, BitOR($BS_MULTILINE, $WS_GROUP))
DefaultsCompare()
$btnPausWork = GUICtrlCreateButton($l_btnPausWork0, 252, 75, 67, 35, BitOR($BS_MULTILINE, $WS_GROUP))
$btnSuspend = GUICtrlCreateButton($l_btnSuspend, 252, 114, 67, 35, BitOR($BS_MULTILINE, $WS_GROUP))
$lblAutOff = GUICtrlCreateLabel('', 4, 192, 180, 43, BitOR($SS_CENTER, $SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xFFFFE0)
GUICtrlSetColor(-1, 0x000000)
$btnLogoff = GUICtrlCreateButton($l_btnLogoff, 188, 192, 59, 43, BitOR($BS_MULTILINE, $WS_GROUP))
$btnUninst = GUICtrlCreateButton($l_btnUninst, 252, 165, 67, 25)
$cboLang = GUICtrlCreateCombo('', 252, 194, 45, 25, BitOR($CBS_DROPDOWN, $CBS_SORT, $CBS_UPPERCASE))
GUICtrlSetData(-1, $lngList, $lng)
GUICtrlSetTip(-1, $l_tipLang)
$lblLangEdit = GUICtrlCreateLabel(' E ', 301, 196, 16, 17, BitOR($SS_CENTER, $WS_BORDER))
GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, $l_tipLangEdit)
GUICtrlSetCursor(-1, 0)
If FileExists($monterGif) Then
	$picMonter = GUICtrlCreatePic($monterGif, 253, 221, 64, 14, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
Else
	$picMonter = GUICtrlCreateLabel('monter.FM', 258, 221, 0, 0, BitOR($SS_NOTIFY, $WS_GROUP))
EndIf
GUICtrlSetTip($picMonter, $l_tipAbout)
GUICtrlSetCursor($picMonter, 0)
If $CmdLine[0] = 0 Then GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Opt('TrayMenuMode', 3)
TrayCreateItem(@UserName)
;TrayCreateItem('')
$trSetts = TrayCreateItem($l_trSetts)
;GUICtrlSetFont($trSetts, 9, 900, 1, 'MS Sans Serif', 5)
TrayCreateItem('')
$trPause = TrayCreateItem($l_trPause0)
$trSuspend = TrayCreateItem($l_trSuspend)
$trLogoff = TrayCreateItem($l_trLogoff)
$trAbout = TrayCreateItem($l_trAbout)
TrayCreateItem('')
$trExit = TrayCreateItem($l_trExit)
TraySetState()
msg()
If $paused = 2 Then $paused = 0
If $paused = 1 Then
	AdlibUnRegister('IdleCheck')
	AdlibUnRegister('LogoffTimeShow')
	GUICtrlSetData($btnPausWork, $l_btnPausWork1)
	GUISetIcon($icon1)
	TraySetIcon($icon1)
	TraySetToolTip($title & ' - ' & $l_trPaused & @CRLF & @UserName)
	TrayItemSetText($trPause, $l_trPause1)
	GUICtrlSetBkColor($lblAutOff, 0xEEEEEE)
	GUICtrlSetState($lblAutOff, $GUI_DISABLE)
	GUICtrlSetState($lblIntval, $GUI_DISABLE)
	GUICtrlSetState($inpIntval, $GUI_DISABLE)
	GUICtrlSetState($udIntval, $GUI_DISABLE)
	GUICtrlSetState($lblLoops, $GUI_DISABLE)
	GUICtrlSetState($inpLoops, $GUI_DISABLE)
	GUICtrlSetState($udLoops, $GUI_DISABLE)
	GUICtrlSetState($lblLogofDly, $GUI_DISABLE)
	GUICtrlSetState($inpLogofDly, $GUI_DISABLE)
	GUICtrlSetState($udLogofDly, $GUI_DISABLE)
	GUICtrlSetState($cbxMonOff, $GUI_DISABLE)
	GUICtrlSetState($cboLogoff, $GUI_DISABLE)
	$pausQry = MsgBox(36, $title, StringFormat($l_pausQry), 30)
	If $pausQry = 6 Then
		msg($l_pausMsg0, -1000)
		$paused = 0
		IniWrite($ini, 'Main', 'paused', $paused)
		AdlibRegister('IdleCheck')
		AdlibRegister('LogoffTimeShow')
		GUICtrlSetData($btnPausWork, $l_btnPausWork0)
		GUISetIcon($icon)
		TraySetIcon($icon)
		TraySetToolTip($title & @CRLF & @UserName)
		TrayItemSetText($trPause, $l_trPause0)
		GUICtrlSetBkColor($lblAutOff, 0xFFFFE0)
		GUICtrlSetState($lblAutOff, $GUI_ENABLE)
		GUICtrlSetState($lblIntval, $GUI_ENABLE)
		GUICtrlSetState($inpIntval, $GUI_ENABLE)
		GUICtrlSetState($udIntval, $GUI_ENABLE)
		GUICtrlSetState($lblLoops, $GUI_ENABLE)
		GUICtrlSetState($inpLoops, $GUI_ENABLE)
		GUICtrlSetState($udLoops, $GUI_ENABLE)
		GUICtrlSetState($lblLogofDly, $GUI_ENABLE)
		GUICtrlSetState($inpLogofDly, $GUI_ENABLE)
		GUICtrlSetState($udLogofDly, $GUI_ENABLE)
		GUICtrlSetState($cbxMonOff, $GUI_ENABLE)
		GUICtrlSetState($cboLogoff, $GUI_ENABLE)
	ElseIf $pausQry = 7 Or @error Then
		msg($l_pausMsg1, -3000)
	EndIf
EndIf
$loop = 1
If StringMid(@UserName, StringInStr(@UserName, '.'), 1) = 'a' Then $sex = 1 ;used in polish translation only
MousMov()
$loop = 1
If $paused = 0 Then
	AdlibRegister('IdleCheck') ;measuring idle time
	AdlibRegister('LogoffTimeShow') ;showing remaining time to logoff
EndIf
AdlibRegister('SyncWin', 6000) ;useful if mobsync.exe activated

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Sleep(333)
			GUISetState(@SW_HIDE)
		Case $GUI_EVENT_MINIMIZE
			Sleep(333)
			GUISetState(@SW_HIDE)
		Case $btnSave
			IniWrite($ini, 'Main', 'interval', $intval)
			IniWrite($ini, 'Main', 'loops', $loops)
			IniWrite($ini, 'Main', 'logOffDelay', $lOffDly)
			IniWrite($ini, 'Main', 'monitorOff', $monOff)
			IniWrite($ini, 'Main', 'logoff', $logoff)
			GUICtrlSetData($btnSave, $l_btnSaved)
			GUICtrlSetState($btnSave, $GUI_DISABLE)
			SaveIniCompare()
			DefaultsCompare()
		Case $btnDefRestore
			For $c = $inpIntval To $inpLogofDly Step 2
				GUICtrlOnChangeUnregister($c)
			Next
			$intval = 590
			$loops = 3
			$lOffDly = 60
			$monOff = 1
			$logoff = 2
			GUICtrlSetData($inpIntval, $intval)
			GUICtrlSetData($inpLoops, $loops)
			GUICtrlSetData($inpLogofDly, $lOffDly)
			GUICtrlSetState($cbxMonOff, $GUI_CHECKED)
			$loffCurr = StringSplit($l_cboLogoff, '|')
			GUICtrlSetData($cboLogoff, '')
			GUICtrlSetData($cboLogoff, $l_cboLogoff, $loffCurr[1])
			If $paused = 0 Then
				GUICtrlSetState($lblLogofDly, $GUI_ENABLE)
				GUICtrlSetState($inpLogofDly, $GUI_ENABLE)
				GUICtrlSetState($udLogofDly, $GUI_ENABLE)
			EndIf
			SaveIniCompare()
			DefaultsCompare()
			For $c = $inpIntval To $inpLogofDly Step 2
				GUICtrlOnChangeRegister($c, 'LogoffTimeRefresh', $c)
			Next
		Case $btnPausWork
			SwitchPause()
		Case $btnSuspend
			Shutdown(32)
		Case $btnLogoff
			LogoffNow()
		Case $cbxMonOff
			SwitchMonOff()
			SaveIniCompare()
			DefaultsCompare()
		Case $cboLogoff
			LogoffChange()
			SaveIniCompare()
			DefaultsCompare()
		Case $cboLang
			LangRefresh()
			LangChange()
		Case $lblLangEdit
			LangEdit()
		Case $picMonter
			About()
		Case $btnUninst
			Uninstall()
	EndSwitch
	$nMsg = TrayGetMsg()
	Switch $nMsg
		Case $trExit
			ExitQuery()
		Case $trLogoff
			LogoffNow()
		Case $trPause
			SwitchPause()
		Case $trSuspend
			Shutdown(32)
		Case $trSetts
			GUISetState(@SW_SHOWNORMAL)
		Case $trAbout
			About()
	EndSwitch
WEnd

Func SaveIniCompare()
	If $intval = IniRead($ini, 'Main', 'interval', 590) And $loops = IniRead($ini, 'Main', 'loops', 3) And $lOffDly = IniRead($ini, 'Main', 'logOffDelay', 60) And $monOff = IniRead($ini, 'Main', 'monitorOff', 1) And $logoff = IniRead($ini, 'Main', 'logoff', 2) Then
		GUICtrlSetData($btnSave, $l_btnSaved)
		GUICtrlSetState($btnSave, $GUI_DISABLE)
	Else
		GUICtrlSetData($btnSave, $l_btnSave)
		GUICtrlSetState($btnSave, $GUI_ENABLE)
	EndIf
EndFunc   ;==>SaveIniCompare

Func DefaultsCompare()
	If $intval = 590 And $loops = 3 And $lOffDly = 60 And $monOff = 1 And $logoff = 2 Then
		GUICtrlSetData($btnDefRestore, $l_btnDefaults)
		GUICtrlSetState($btnDefRestore, $GUI_DISABLE)
		If $paused = 0 Then
			GUICtrlSetState($lblLogofDly, $GUI_ENABLE)
			GUICtrlSetState($inpLogofDly, $GUI_ENABLE)
			GUICtrlSetState($udLogofDly, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetData($btnDefRestore, $l_btnDefRestore)
		GUICtrlSetState($btnDefRestore, $GUI_ENABLE)
	EndIf
EndFunc   ;==>DefaultsCompare

Func IdleCheck()
	If _Timer_GetIdleTime() > ($intval * 1000) And $loop >= $loops Then
		If $logoff <> 0 Then
			MousMov()
			Logoff()
		Else
			Suspend()
		EndIf
	ElseIf _Timer_GetIdleTime() > ($intval * 1000) Then
		MousMov()
		If $monOff = 1 And $loop > 1 Then MonitorOff()
	EndIf
	If _Timer_GetIdleTime() < 500 Then $loop = 1
EndFunc   ;==>IdleCheck

Func MousMov()
	$mousPos = MouseGetPos()
	MouseMove($mousPos[0] - 2, $mousPos[1] - 2)
	MouseMove($mousPos[0], $mousPos[1], 0)
	$loop = $loop + 1
	Sleep(500)
EndFunc   ;==>MousMov

Func SyncWin() ;hiding the synchronizing window (mobsync.exe)
	If $synTm >= 30 Or $syn = 1 Then
		AdlibUnRegister('SyncWin')
	ElseIf $syn = 0 Then
		WinWait('Synchroni', '', 1)
		WinActivate('Synchroni')
		If WinActive('Synchroni') Then
			$mousPos = MouseGetPos()
			$winSynXY = WinGetPos('Synchroni')
			BlockInput(1)
			MouseMove($winSynXY[0] + 16, $winSynXY[1] + 16, 0)
			MouseClick('left')
			Send('{DOWN 4}{ENTER}')
			MouseMove($mousPos[0], $mousPos[1], 0)
			BlockInput(0)
			$syn = 1
		EndIf
		$synTm = $synTm + 1
	EndIf
EndFunc   ;==>SyncWin

Func Logoff()
	If WinExists('Synchronizacja uko', 'Wyst¹pi³ b³¹d') Then WinClose('Synchronizacja uko', 'Wyst¹pi³ b³¹d')
	GUISetIcon($icon2)
	TraySetIcon($icon2)
	SoundPlay(@WindowsDir & '\media\chord.wav', 1)
	SoundPlay(@WindowsDir & '\media\chord.wav')
	$esc = 1
	$brk = 0
	msg(StringFormat($l_msgLogoff1, $kaCzki, @UserName) & @CRLF & $l_msgLogoffNo, ($lOffDly * 1000), -1, -1, -1)
	If _Timer_GetIdleTime() < ($lOffDly * 1000) Then $brk = 1
	If $loop >= $loops And $brk = 0 And $paused = 0 Then
		GUISetIcon($icon2)
		TraySetIcon($icon2)
		SoundPlay(@WindowsDir & '\media\ding.wav', 1)
		SoundPlay(@WindowsDir & '\media\ding.wav')
		$brk = 0
		If $brk = 0 Then msg(StringFormat($l_msgLogoff2, $kaCzke, @UserName) & @CRLF & $l_msgLogoffNo, 10000, -1, -1, -1, 2)
		If _Timer_GetIdleTime() < 10000 Then $brk = 1
		If $logoff = 2 Then
			$sdn = 4
		ElseIf $logoff = 1 Then
			$sdn = 16
		EndIf
		If $brk = 0 And $paused = 0 Then
			If @Compiled Then
				$counTimes = $counTimes + 1
				IniWrite($ini, 'Main', 'countTimes', $counTimes)
				Shutdown($sdn)
			Else
				AdlibUnRegister('IdleCheck')
				AdlibUnRegister('LogoffTimeShow')
				msg('@Compiled script would do Shutdown(' & $sdn & ') now.')
				GUIDelete($frmMain)
				Exit
			EndIf
			If WinExists('Synchroni') Then WinKill('Synchroni'); I wish it worked
		EndIf
	EndIf
	$esc = 0
	ToolTip('')
EndFunc   ;==>Logoff

Func LogoffBrk()
	ToolTip('')
	TrayTip('', '', 1)
	If $paused = 0 Then
		GUISetIcon($icon)
		TraySetIcon($icon)
	Else
		GUISetIcon($icon1)
		TraySetIcon($icon1)
	EndIf
	ToolTip($l_msgLogoffBrk, Int(@DesktopWidth / 2), Int(@DesktopHeight / 2), $title, 1)
	Sleep(1500)
	ToolTip('')
	$loop = 1
EndFunc   ;==>LogoffBrk

Func LogoffTimeRefresh($cid)
	$intval = GUICtrlRead($inpIntval)
	$loops = GUICtrlRead($inpLoops)
	$lOffDly = GUICtrlRead($inpLogofDly)
	If $intval < 4 Then $intval = 4
	If $loops < 1 Then $loops = 1
	If $lOffDly < 2 Then $lOffDly = 2
	GUICtrlSetData($inpIntval, $intval)
	GUICtrlSetData($inpLoops, $loops)
	GUICtrlSetData($inpLogofDly, $lOffDly)
	SaveIniCompare()
	DefaultsCompare()
EndFunc   ;==>LogoffTimeRefresh

Func LogoffTimeShow()
	$timremnS = ($intval * ($loops - $loop + 1)) + $lOffDly - Round((_Timer_GetIdleTime() / 1000))
	If $logoff = 0 Then $timremnS = ($intval * ($loops - $loop + 1)) - Round((_Timer_GetIdleTime() / 1000))
	If $timremnS > 3599 Then
		$h = Int($timremnS / 3600)
		$m = Int((($timremnS / 3600) - $h) * 60)
		$s = Round((((($timremnS / 3600) - $h) * 60) - $m) * 60)
		$lOffTime = $h & 'h ' & StringFormat('%.2d', $m) & 'm ' & StringFormat('%.2d', $s) & 's'
	ElseIf $timremnS > 59 Then
		$m = Int($timremnS / 60)
		$s = Round((($timremnS / 60) - $m) * 60)
		$lOffTime = $m & 'm ' & StringFormat('%.2d', $s) & 's'
	Else
		$lOffTime = $timremnS & 's'
	EndIf
	If $logoff > 0 Then
		GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOff & ' ' & $lOffTime, $kaCzki, @UserName))
	Else
		GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOffSus & ' ' & $lOffTime))
	EndIf
EndFunc   ;==>LogoffTimeShow

Func LogoffNow()
	HotKeySet('{ESC}', 'LogoffEsc')
	GUISetIcon($icon2)
	TraySetIcon($icon2)
	If WinExists('Synchronizacja uko', 'Wyst¹pi³ b³¹d') Then WinClose('Synchronizacja uko', 'Wyst¹pi³ b³¹d')
	SoundPlay(@WindowsDir & '\media\ding.wav')
	$brk = 0
	msg(StringFormat($l_msgLogoff2, $kaCzke, @UserName) & @CRLF & $l_msgLogoffEsc, 5000, -1, -1)
	If $logoff = 2 Then
		$sdn = 4
	Else
		$sdn = 16
	EndIf
	If $brk = 0 Then
		If @Compiled Then
			$counTimes = $counTimes + 1
			IniWrite($ini, 'Main', 'countTimes', $counTimes)
			Shutdown($sdn)
		Else
			AdlibUnRegister('IdleCheck')
			AdlibUnRegister('LogoffTimeShow')
			msg('@Compiled script would do Shutdown(' & $sdn & ') now.')
			GUIDelete($frmMain)
			Exit
		EndIf
		If WinExists('Synchroni') Then WinKill('Synchroni'); I wish it worked
	EndIf
	HotKeySet('{ESC}')
	$brk = 0
	ToolTip('')
EndFunc   ;==>LogoffNow

Func LogoffEsc()
	$brk = 1
	If $paused = 0 Then
		GUISetIcon($icon)
		TraySetIcon($icon)
	Else
		GUISetIcon($icon1)
		TraySetIcon($icon1)
	EndIf
	ToolTip($l_msgLogoffBrk, Int(@DesktopWidth / 2), Int(@DesktopHeight / 2), $title, 1)
	Sleep(2000)
	ToolTip('')
	$loop = 1
EndFunc   ;==>LogoffEsc

Func SwitchPause()
	If $paused = 0 Then
		GUICtrlSetData($btnPausWork, $l_btnPausWork1)
		GUISetIcon($icon1)
		TraySetIcon($icon1)
		TraySetToolTip($title & ' - ' & $l_trPaused & @CRLF & @UserName)
		TrayItemSetText($trPause, $l_trPause1)
		GUICtrlSetBkColor($lblAutOff, 0xEEEEEE)
		GUICtrlSetState($lblAutOff, $GUI_DISABLE)
		GUICtrlSetState($lblIntval, $GUI_DISABLE)
		GUICtrlSetState($inpIntval, $GUI_DISABLE)
		GUICtrlSetState($udIntval, $GUI_DISABLE)
		GUICtrlSetState($lblLoops, $GUI_DISABLE)
		GUICtrlSetState($inpLoops, $GUI_DISABLE)
		GUICtrlSetState($udLoops, $GUI_DISABLE)
		GUICtrlSetState($lblLogofDly, $GUI_DISABLE)
		GUICtrlSetState($inpLogofDly, $GUI_DISABLE)
		GUICtrlSetState($udLogofDly, $GUI_DISABLE)
		GUICtrlSetState($cbxMonOff, $GUI_DISABLE)
		GUICtrlSetState($cboLogoff, $GUI_DISABLE)
		$paused = 1
		If $letSuspend <> 1 Then
			AdlibUnRegister('IdleCheck')
			AdlibUnRegister('LogoffTimeShow')
		EndIf
		If $letSuspend = 1 Then $paused = 2
	Else
		GUICtrlSetData($btnPausWork, $l_btnPausWork0)
		GUISetIcon($icon)
		TraySetIcon($icon)
		TraySetToolTip($title & @CRLF & @UserName)
		TrayItemSetText($trPause, $l_trPause0)
		GUICtrlSetBkColor($lblAutOff, 0xFFFFE0)
		GUICtrlSetState($lblAutOff, $GUI_ENABLE)
		GUICtrlSetState($lblIntval, $GUI_ENABLE)
		GUICtrlSetState($inpIntval, $GUI_ENABLE)
		GUICtrlSetState($udIntval, $GUI_ENABLE)
		GUICtrlSetState($lblLoops, $GUI_ENABLE)
		GUICtrlSetState($inpLoops, $GUI_ENABLE)
		GUICtrlSetState($udLoops, $GUI_ENABLE)
		If $logoff <> 0 Then
			GUICtrlSetState($lblLogofDly, $GUI_ENABLE)
			GUICtrlSetState($inpLogofDly, $GUI_ENABLE)
			GUICtrlSetState($udLogofDly, $GUI_ENABLE)
		EndIf
		GUICtrlSetState($cbxMonOff, $GUI_ENABLE)
		GUICtrlSetState($cboLogoff, $GUI_ENABLE)
		$paused = 0
		AdlibRegister('IdleCheck')
		AdlibRegister('LogoffTimeShow')
	EndIf
	IniWrite($ini, 'Main', 'paused', $paused)
EndFunc   ;==>SwitchPause

Func SwitchMonOff()
	If $monOff = 1 Then
		GUICtrlSetState($cbxMonOff, $GUI_UNCHECKED)
		$monOff = 0
	Else
		GUICtrlSetState($cbxMonOff, $GUI_CHECKED)
		$monOff = 1
	EndIf
EndFunc   ;==>SwitchMonOff

Func MonitorOff()
	Opt('WinTitleMatchMode', 4)
	Monitor('off')
	Opt('WinTitleMatchMode', 1)
EndFunc   ;==>MonitorOff

Func Monitor($io_control = 'on') ;Kerberuz's script
	Local $WM_SYSCommand = 274
	Local $SC_MonitorPower = 61808
	Local $HWND = WinGetHandle('classname=Progman')
	Switch StringUpper($io_control)
		Case 'OFF'
			DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $HWND, 'int', $WM_SYSCommand, 'int', $SC_MonitorPower, 'int', 2)
		Case 'ON'
			DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $HWND, 'int', $WM_SYSCommand, 'int', $SC_MonitorPower, 'int', -1)
		Case Else
			MsgBox(32, $title, 'Command usage: on/off', 5)
	EndSwitch
EndFunc   ;==>Monitor

Func LogoffChange()
	$logoffCurr = GUICtrlRead($cboLogoff)
	$loffCurr = StringSplit($l_cboLogoff, '|')
	For $i = 2 To 0 Step -1
		If $logoffCurr = $loffCurr[Abs($i - 3)]Then $logoff = $i
	Next
	If $logoff = 0 Then
		GUICtrlSetState($lblLogofDly, $GUI_DISABLE)
		GUICtrlSetState($inpLogofDly, $GUI_DISABLE)
		GUICtrlSetState($udLogofDly, $GUI_DISABLE)
		GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOff & ' ' & $lOffTime, $kaCzki, @UserName))
	Else
		GUICtrlSetState($lblLogofDly, $GUI_ENABLE)
		GUICtrlSetState($inpLogofDly, $GUI_ENABLE)
		GUICtrlSetState($udLogofDly, $GUI_ENABLE)
		GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOffSus & ' ' & $lOffTime))
	EndIf
EndFunc   ;==>LogoffChange

Func Suspend()
	$letSuspend = 1
	SwitchPause()
	Global $WM_POWERBROADCAST = 536 ;Jos's func
	Global $PBT_APMRESUMESUSPEND = 0x0007
	Global $PBT_APMRESUMESTANDBY = 0x0008
	GUIRegisterMsg($WM_POWERBROADCAST, 'Standby')
	While 1
		Sleep(10)
		If _Timer_GetIdleTime() < 500 Then
			$loop = 1
			$letSuspend = 0
			SwitchPause()
			ExitLoop
		ElseIf $letSuspend = 1 And $paused = 0 Then
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>Suspend

Func Standby($HWND, $Msg, $wParam, $lParam)
	If $wParam = ($PBT_APMRESUMESUSPEND Or $wParam = $PBT_APMRESUMESTANDBY) And IniRead($ini, 'Main', 'paused', 0) = 0 Then
		$loop = 1
		$letSuspend = 1
		SwitchPause()
	EndIf
EndFunc   ;==>Standby

Func IniCheck()
	If IniRead($ini, 'Main', 'version', '') = '' Then IniWrite($ini, 'Main', 'version', $sVer)
	If IniRead($ini, 'Main', 'countTimes', '') = '' Then IniWrite($ini, 'Main', 'countTimes', 0)
	If IniRead($ini, 'Main', 'update', '') = '' Then IniWrite($ini, 'Main', 'update', '3-' & _NowCalcDate())
	If IniRead($ini, 'Main', 'rcntUsed', '') = '' Then IniWrite($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	If IniRead($ini, 'Main', 'interval', '') = '' Then IniWrite($ini, 'Main', 'interval', 590)
	If IniRead($ini, 'Main', 'loops', '') = '' Then IniWrite($ini, 'Main', 'loops', 3)
	If IniRead($ini, 'Main', 'logOffDelay', '') = '' Then IniWrite($ini, 'Main', 'logOffDelay', 60)
	If IniRead($ini, 'Main', 'monitorOff', '') = '' Then IniWrite($ini, 'Main', 'monitorOff', 1)
	If IniRead($ini, 'Main', 'logoff', '') = '' Then IniWrite($ini, 'Main', 'logoff', 2)
	If IniRead($ini, 'Main', 'paused', '') = '' Then IniWrite($ini, 'Main', 'paused', 0)
	$version = IniRead($ini, 'Main', 'version', $sVer)
EndFunc   ;==>IniCheck

Func IniReadF()
	$counTimes = IniRead($ini, 'Main', 'countTimes', 0)
	$update = IniRead($ini, 'Main', 'update', '2-' & _NowCalcDate())
	$updState = StringLeft($update, 1)
	$updCheck = StringTrimLeft($update, 2)
	$rcntUsed = IniRead($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	$intval = IniRead($ini, 'Main', 'interval', 590)
	$loops = IniRead($ini, 'Main', 'loops', 3)
	$lOffDly = IniRead($ini, 'Main', 'logOffDelay', 60)
	$monOff = IniRead($ini, 'Main', 'monitorOff', 1)
	$logoff = IniRead($ini, 'Main', 'logoff', 2)
	$paused = IniRead($ini, 'Main', 'paused', 0)
EndFunc   ;==>IniReadF

Func LangCheck()
	If @Compiled And ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then
		$lang = 'english'
		For $i = 1 To 2
			If FileExists(@ScriptDir & '\' & $script & '.' & $lang & '.lng') Then FileDelete(@ScriptDir & '\' & $script & '.' & $lang & '.lng')
			$lang = 'polski'
		Next
	EndIf
	FileInstall('LogOnOff.english.lng', @ScriptDir & '\', 1)
	FileInstall('LogOnOff.polski.lng', @ScriptDir & '\', 1)
EndFunc   ;==>LangCheck

Func LangRead()
	If $currFileLang = '' Then
		$currFileLang = @ScriptDir & '\' & $script & '.english.lng'
		If StringInStr('0415', @OSLang) Then $currFileLang = @ScriptDir & '\' & $script & '.polski.lng'
	EndIf
	If Not FileExists($currFileLang) Then
		$currFileLang = @ScriptDir & '\' & $script & '.english.lng'
		LangCheck()
		LangRead()
	Else
		$lngRdSect = IniReadSectionNames($currFileLang)
		$lng = $lngRdSect[1]
		$l_grpSetts = IniRead($currFileLang, $lng, 'grpSetts', 'Settings')
		$l_tipIntval = IniRead($currFileLang, $lng, 'tipIntval', 'Enter seconds between 4 and 999')
		$l_tipLoops = IniRead($currFileLang, $lng, 'tipLoops', 'Enter number of cycles between 1 do 99')
		$l_tipLogofDly = IniRead($currFileLang, $lng, 'tipLogofDly', 'Enter seconds between 2 and 999')
		$l_cbxMonOff = IniRead($currFileLang, $lng, 'cbxMonOff', 'Activate screensaver')
		$l_tipMonOff = IniRead($currFileLang, $lng, 'tipMonOff', 'Turns monitor off after the first maintaining session cycle')
		$l_cboLogoff = IniRead($currFileLang, $lng, 'cboLogoff', 'Force logoff|Soft logoff|No logoff')
		$l_tipLogoff = IniRead($currFileLang, $lng, 'tipLogoff', "Force logoff - regardless of not saved or opened files etc.\n\rSoft logoff - if there are any unsaved files, computer waits for user's action\n\rNo logoff - after set time the application stops countdown and the computer can be suspended")
		$l_lblIntval = IniRead($currFileLang, $lng, 'lblIntval', "Computer's idle time (s)")
		$l_lblLoops = IniRead($currFileLang, $lng, 'lblLoops', 'Number of alive user session cycles')
		$l_lblLogofDly = IniRead($currFileLang, $lng, 'lblLogofDly', 'Displaying time warning message\n\rabout approaching logoff (s)')
		$l_btnSave = IniRead($currFileLang, $lng, 'btnSave', 'Save')
		$l_btnSaved = IniRead($currFileLang, $lng, 'btnSaved', 'Saved')
		$l_btnDefRestore = IniRead($currFileLang, $lng, 'btnDefRestore', 'Restore defaults')
		$l_btnDefaults = IniRead($currFileLang, $lng, 'btnDefaults', 'Defaults')
		$l_btnPausWork0 = IniRead($currFileLang, $lng, 'btnPausWork0', 'Pause work')
		$l_btnPausWork1 = IniRead($currFileLang, $lng, 'btnPausWork1', 'Resume work')
		$l_btnSuspend = IniRead($currFileLang, $lng, 'btnSuspend', 'Suspend now')
		$l_lblAutOff = IniRead($currFileLang, $lng, 'lblAutOff', 'User%s %s \n\rwill be logged off\n\rin')
		$l_lblAutOffSus = IniRead($currFileLang, $lng, 'lblAutOffSus', 'Application will\n\rfinish countdown\n\rin')
		$l_btnLogoff = IniRead($currFileLang, $lng, 'btnLogoff', 'Logoff now')
		$l_btnUninst = IniRead($currFileLang, $lng, 'btnUninst', 'Uninstall')
		$l_tipLang = IniRead($currFileLang, $lng, 'tipLang', 'Choose language')
		$l_tipLangEdit = IniRead($currFileLang, $lng, 'tipLangEdit', 'Edit current language file')
		$l_tipAbout = IniRead($currFileLang, $lng, 'tipAbout', 'About...')
		$l_trSetts = IniRead($currFileLang, $lng, 'trSetts', 'Show settings')
		$l_trLogoff = IniRead($currFileLang, $lng, 'trLogoff', 'Logoff now')
		$l_trSuspend = IniRead($currFileLang, $lng, 'trSuspend', 'Suspend now')
		$l_trPause0 = IniRead($currFileLang, $lng, 'trPause0', 'Pause')
		$l_trPause1 = IniRead($currFileLang, $lng, 'trPause1', 'Resume')
		$l_trPaused = IniRead($currFileLang, $lng, 'trPaused', 'paused')
		$l_trAbout = IniRead($currFileLang, $lng, 'trAbout', 'About...')
		$l_trExit = IniRead($currFileLang, $lng, 'trExit', 'Exit')
		$l_pausQry = IniRead($currFileLang, $lng, 'pausQry', 'The program was paused previously.\n\rDo you want to reactivate it?')
		$l_pausMsg0 = IniRead($currFileLang, $lng, 'pausMsg0', 'Now application will resume.')
		$l_pausMsg1 = IniRead($currFileLang, $lng, 'pausMsg1', 'Application will stay paused.')
		$l_msgLogoff1 = IniRead($currFileLang, $lng, 'msgLogoff1', 'User%s %s will logoff in a moment...')
		$l_msgLogoffNo = IniRead($currFileLang, $lng, 'msgLogoffNo', 'Press any key or move the mouse to cancel logoff.')
		$l_msgLogoff2 = IniRead($currFileLang, $lng, 'msgLogoff2', 'User%s %s logoff is now proceeding...')
		$l_msgLogoffBrk = IniRead($currFileLang, $lng, 'msgLogoffBrk', 'Logoff is cancelled.')
		$l_msgLogoffEsc = IniRead($currFileLang, $lng, 'msgLogoffEsc', 'Press "Esc" key to cancel logoff.')
		$l_msgUpdateCheck = IniRead($currFileLang, $lng, 'msgUpdateCheck', 'Checking update, wait a moment...')
		$l_msgUpdateError = IniRead($currFileLang, $lng, 'msgUpdateError', 'Network error. Update failed.')
		$l_msgUpdateDownload = IniRead($currFileLang, $lng, 'msgUpdateDownload', 'Downloading the newest version, wait a moment...')
		$l_msgUpdateFailed = IniRead($currFileLang, $lng, 'msgUpdateFailed', 'Download failed. Check network configuration.')
		$l_msgUpdateOk = IniRead($currFileLang, $lng, 'msgUpdateOk', 'Update completed. Launching new version')
		$l_msgAdmLock = IniRead($currFileLang, $lng, 'msgAdmLock', "Hello Admin.\n\rDue to security risk, this application won't work on current login.")
		$l_msgDisclaimer = IniRead($currFileLang, $lng, 'msgDisclaimer', "ATTENTION!\n\rThis application keeps alive user session during inactivity of the computer.\n\rActive session time may be adjusted in settings.\n\rThe longer idle time with logged in user, the bigger risk for user's files, documents and data.\n\r\n\rThe author of this software is not responsible for possible damage.\n\rIf you are aware%s of the risk and understood%s this warning - click ""Yes"".")
		$l_msgFileMoving = IniRead($currFileLang, $lng, 'msgFileMoving', 'Moving this app to the proper folder, wait a moment...')
		$l_msgExitQuery = IniRead($currFileLang, $lng, 'msgExitQuery', 'Do you want to exit application?')
		$l_msgUninstall = IniRead($currFileLang, $lng, 'msgUninstall', 'You are about to uninstall this application. Do you want to continue?')
		$l_msgUninstallProcess = IniRead($currFileLang, $lng, 'msgUninstallProcess', 'Uninstalling in progress')
		$l_msgUninstallDelOthLangs = IniRead($currFileLang, $lng, 'msgUninstallDelOthLangs', "Do you want to delete user's (other than default) language files?")
		$l_msgWarning = IniRead($currFileLang, $lng, 'msgWarning', 'Warning!')
		$l_msgError = IniRead($currFileLang, $lng, 'msgError', 'ERROR!')
		$l_lblAboutTitle = IniRead($currFileLang, $lng, 'lblAboutTitle', 'About')
		$l_lblAboutTxt = IniRead($currFileLang, $lng, 'lblAboutTxt', 'Program keeps alive user session and prevents from suspension. After longer inactivity application performs auto-logoff.')
		$l_lblBuilt = IniRead($currFileLang, $lng, 'lblBuilt', 'built on AutoIt')
		$l_lblWww = IniRead($currFileLang, $lng, 'lblWww', "Author's site")
		$l_lblWwwApp = IniRead($currFileLang, $lng, 'lblWwwApp', "Application's site (PL)")
		$l_lblWwwForum = IniRead($currFileLang, $lng, 'lblWwwForum', 'Autoit3 forum')
		$kaCzki = ''
		$kaCzke = ''
		If $lng = 'PL' Then
			$kaCzki = 'ka'
			$kaCzke = 'ka'
			If $sex = 1 Then
				$kaCzki = 'czki'
				$kaCzke = 'czkê'
			EndIf
		EndIf
	EndIf
EndFunc   ;==>LangRead

Func LangRefresh()
	$langFiList = ''
	$lngList = ''
	$srchFiLang = FileFindFirstFile(@ScriptDir & '\' & $script & '.*.lng')
	If $srchFiLang = -1 Then
		MsgBox(48, 'Error', 'No language files found. Restart the program.')
		LangCheck()
		Exit
	EndIf
	While 1
		$srchLang = FileFindNextFile($srchFiLang) ;searching for new language files (to find your own one)
		If @error Then ExitLoop
		$sectLang = IniReadSectionNames(@ScriptDir & '\' & $srchLang)
		$langFiList = $srchLang & '|' & $langFiList
		$lngList = $sectLang[1] & '|' & $lngList
	WEnd
	$langFiList = StringTrimRight($langFiList, 1)
	$lngList = StringTrimRight($lngList, 1)
	If $lng = '' Then
		If StringInStr('0415', @OSLang) Then
			$lang = 'polski'
		Else
			$lang = 'english'
		EndIf
		$currFileLang = @ScriptDir & '\' & $script & '.' & $lang & '.lng'
		$lngRdSect = IniReadSectionNames($currFileLang)
		$lng = $lngRdSect[1]
	EndIf
EndFunc   ;==>LangRefresh

Func LangChange()
	$lng = GUICtrlRead($cboLang)
	$lFLst = StringSplit($langFiList, '|')
	$lLst = StringSplit($lngList, '|')
	For $i = 1 To $lFLst[0]
		If $lng = $lLst[$i] Then
			$currFileLang = @ScriptDir & '\' & $lFLst[$i]
			ExitLoop
		EndIf
	Next
	LangRead()
	LangRefreshGui()
EndFunc   ;==>LangChange

Func LangEdit()
	Run('notepad.exe ' & $currFileLang)
EndFunc   ;==>LangEdit

Func LangRefreshGui() ;we don't need to restart the program, result of switching language is immediate
	GUICtrlSetData($grpSetts, $l_grpSetts)
	GUICtrlSetTip($inpIntval, $l_tipIntval)
	GUICtrlSetTip($udIntval, $l_tipIntval)
	GUICtrlSetTip($lblIntval, $l_tipIntval)
	GUICtrlSetTip($inpLoops, $l_tipLoops)
	GUICtrlSetTip($udLoops, $l_tipLoops)
	GUICtrlSetTip($lblLoops, $l_tipLoops)
	GUICtrlSetTip($inpLogofDly, $l_tipLogofDly)
	GUICtrlSetTip($udLogofDly, $l_tipLogofDly)
	GUICtrlSetTip($lblLogofDly, $l_tipLogofDly)
	GUICtrlSetData($lblIntval, $l_lblIntval)
	GUICtrlSetData($lblLoops, $l_lblLoops)
	GUICtrlSetData($lblLogofDly, StringFormat($l_lblLogofDly))
	GUICtrlSetData($cbxMonOff, $l_cbxMonOff & '    ')
	GUICtrlSetTip($cbxMonOff, $l_tipMonOff)
	GUICtrlSetData($cboLogoff, '')
	$loffCurr = StringSplit($l_cboLogoff, '|')
	For $i = 2 To 0 Step -1
		If $logoff = $i Then $logoffCurr = $loffCurr[Abs($i - 3)]
	Next
	GUICtrlSetData($cboLogoff, $l_cboLogoff, $logoffCurr)
	GUICtrlSetTip($cboLogoff, StringFormat($l_tipLogoff))
	SaveIniCompare()
	DefaultsCompare()
	GUICtrlSetData($btnPausWork, $l_btnPausWork0)
	If $paused >= 1 Then GUICtrlSetData($btnPausWork, $l_btnPausWork1)
	GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOff & ' ' & $lOffTime, $kaCzki, @UserName))
	If $logoff = 0 Then GUICtrlSetData($lblAutOff, StringFormat($l_lblAutOffSus & ' ' & $lOffTime))
	GUICtrlSetData($btnSuspend, $l_btnSuspend)
	GUICtrlSetData($btnLogoff, $l_btnLogoff)
	GUICtrlSetData($btnUninst, $l_btnUninst)
	GUICtrlSetData($cboLang, '')
	GUICtrlSetData($cboLang, $lngList, $lng)
	GUICtrlSetTip($cboLang, $l_tipLang)
	GUICtrlSetTip($lblLangEdit, $l_tipLangEdit)
	GUICtrlSetTip($picMonter, $l_tipAbout)
	TraySetToolTip($title & @CRLF & @UserName)
	TrayItemSetText($trSetts, $l_trSetts)
	TrayItemSetText($trSuspend, $l_trSuspend)
	TrayItemSetText($trLogoff, $l_trLogoff)
	TrayItemSetText($trPause, $l_trPause0)
	If $paused >= 1 Then
		TrayItemSetText($trPause, $l_trPause1)
		TraySetToolTip($title & ' - ' & $l_trPaused & @CRLF & @UserName)
	EndIf
	TrayItemSetText($trAbout, $l_trAbout)
	TrayItemSetText($trExit, $l_trExit)
EndFunc   ;==>LangRefreshGui

Func UpdateCheck() ;20.12.2009 - works for main (single) file in the project - localization vars
	$datDiff = _DateDiff('D', $updCheck, _NowCalcDate())
	If $datDiff >= $updState Then
		$pcol = 'ftp://'
		For $i = 1 To 3
			msg($l_msgUpdateCheck & ' (' & $i & '/3)')
			InetGet($pcol & $serverUrl & '/skrypty/bin/' & $script & '.upd', $fileAutoUpd, 1, 0)
			Sleep(1500)
			If FileExists($fileAutoUpd) And FileGetSize($fileAutoUpd) > 30 Then ExitLoop
			If $i = 1 Then $pcol = 'http://'
			If $i = 2 Then HttpSetProxy(2, $serverUrl & ':8068')
		Next
		ToolTip('')
		HttpSetProxy(1)
		If Not FileExists($fileAutoUpd) Then Sleep(2500)
		If Not FileExists($fileAutoUpd) Or FileGetSize($fileAutoUpd) < 30 Then
			msg($l_msgUpdateError, -4000, -1, -1, -1, 3)
			$updState = 1
		Else
			$nVer = IniRead($fileAutoUpd, $script & '.exe', 'version', '0.0.0.0')
			$nVer = StringFormat('%.2f', Number(StringReplace($nVer, '.', '')) / 1000)
			$nSize = IniRead($fileAutoUpd, $script & '.exe', 'size', '999999999')
			If $nVer > $sVer Then
				$pcol = 'ftp://'
				$nFile = IniReadSectionNames($fileAutoUpd)
				$nFile = $nFile[1]
				For $i = 1 To 3
					msg($l_msgUpdateDownload & ' (' & $i & '/3)')
					InetGet($pcol & $serverUrl & '/skrypty/bin/' & $nFile, @TempDir & '\' & $script & '.exe', 1, 0)
					If FileGetSize(@TempDir & '\' & $script & '.exe') = $nSize Then ExitLoop
					If $i = 1 Then $pcol = 'http://'
					If $i = 2 Then HttpSetProxy(2, $serverUrl & ':8068')
				Next
				If FileGetSize(@TempDir & '\' & $script & '.exe') < IniRead($fileAutoUpd, $script & '.exe', 'size', 0) Then
					msg($l_msgUpdateFailed, -3000, -1, -1, -1, 3)
					$updState = 1
				Else
					If FileExists($fileBat) Then FileDelete($fileBat)
					Sleep(1000)
					$baTemp = FileOpen($fileBat, 1)
					FileWriteLine($baTemp, '@echo off' & @CRLF & 'echo                             Update in process: ' & $script & '...' & @CRLF & 'ping -n 6 ' & $serverUrl & ' >nul' & @CRLF & 'if exist "' & @TempDir & '\' & $script & '.exe" del "' & @ScriptDir & '\' & $script & '.exe" >nul' & @CRLF & 'move "' & @TempDir & '\' & $script & '.exe" "' & @ScriptDir & '\" >nul')
					FileWriteLine($baTemp, 'ping -n 3 ' & $serverUrl & ' >nul' & @CRLF & 'if exist "' & @ScriptDir & '\' & $script & '.exe" "' & @ScriptDir & '\' & $script & '.exe" -u' & @CRLF & 'exit' & @CRLF & 'cls')
					FileClose($baTemp)
				EndIf
				msg($l_msgUpdateOk & ' ' & $fnScript & ' ' & $nVer & '...', -3000, -1, -1, -1)
				$updState = 3
				IniWrite($ini, 'Main', 'update', $updState & '-' & _NowCalcDate())
				If FileExists($fileAutoUpd) Then FileDelete($fileAutoUpd)
				Run(@ComSpec & ' /c "' & $fileBat & '" -u', '', @SW_HIDE)
				If ProcessExists($script & '.exe') Then ProcessClose($script & '.exe')
				Exit
			Else
				$updState = 7
				If ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then $updState = 3
			EndIf
		EndIf
		IniWrite($ini, 'Main', 'update', $updState & '-' & _NowCalcDate())
	EndIf
	If FileExists($fileAutoUpd) Then FileDelete($fileAutoUpd)
EndFunc   ;==>UpdateCheck

Func Install() ;08.11.2009 (@StartupDir '-h', no @DesktopDir), IniWrite $sVer
	If @Compiled Then
		If Not FileExists($dirMonter) Then DirCreate($dirMonter)
		FileChangeDir($dirMonter)
		If @ScriptDir <> $dirMonter Then
			If StringLeft(@UserName, 3) = 'adm' And IniRead($ini, 'Main', 'admUnlock', '') <> '1' Then ;undocumented ini option for admin testing :-)
				IniWrite($ini, 'Main', 'admUnlock', 0)
				MsgBox(16, $title, StringFormat($l_msgAdmLock))
				If IniRead($ini, 'Main', 'admUnlock', '') <> '1' Then Exit
			EndIf
			$yA = ''
			$eA = ''
			If StringInStr('0415', @OSLang) Then
				$yA = 'y'
				$eA = 'e'
				If $sex = 1 Then
					$yA = 'a'
					$eA = 'a'
				EndIf
			EndIf
			$disclmr = MsgBox(308, $title, StringFormat($l_msgDisclaimer, $yA, $eA))
			If $disclmr = 6 Then
				$del = 1
				If StringLeft(@ScriptDir, 3) <> StringLeft(@AppDataDir, 3) Then $del = 0
				msg($l_msgFileMoving)
				$list = ProcessList($script & '.exe')
				For $i = 1 To $list[0][0]
					$pid = WinGetProcess($script)
					ProcessClose($pid)
				Next
				Sleep(1000)
				FileCopy(@ScriptFullPath, $dirMonter & '\' & $script & '.exe', 9)
				If Not FileExists(@ProgramsDir & '\monter.FM\') Then DirCreate(@ProgramsDir & '\monter.FM\')
				FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
				FileCreateShortcut($dirMonter & '\' & $script & '.exe', @StartupDir & '\' & $fnScript & '.lnk', $dirMonter, '-h', $title, $dirMonter & '\' & $script & '.exe', '', 0)
				msg()
				$baTemp = FileOpen($fileBat, 1)
				If $del = 1 Then FileWriteLine($baTemp, '@ping -n 4 ' & $serverUrl & ' >nul' & @CRLF & '@if exist "' & @ScriptFullPath & '" del "' & @ScriptFullPath & '" >nul')
				FileWriteLine($baTemp, '@ping -n 1 ' & $serverUrl & ' >nul' & @CRLF & '@if exist "' & $dirMonter & '\' & $script & '.exe' & '" "' & $dirMonter & '\' & $script & '.exe' & '" -h' & @CRLF & '@exit' & @CRLF & '@cls')
				FileClose($baTemp)
				If FileExists($ini) Then FileDelete($ini)
				If FileExists(@ScriptDir & '\' & $script & '.*.lng') Then FileDelete(@ScriptDir & '\' & $script & '.*.lng')
				$lang = 'english'
				For $i = 1 To 2
					If FileExists($dirMonter & '\' & $script & '.' & $lang & '.lng') Then FileDelete($dirMonter & '\' & $script & '.' & $lang & '.lng')
					$lang = 'polski'
				Next
				Sleep(2000)
				Run(@ComSpec & ' /c "' & $fileBat & '" -u', '', @SW_HIDE)
				For $i = 1 To 2
					If ProcessExists(@ScriptName) Then ProcessClose(@ScriptName)
					Sleep(2000)
				Next
				Exit
			Else
				If FileExists(@ScriptDir & '\' & $script & '.*.lng') Then FileDelete(@ScriptDir & '\' & $script & '.*.lng')
				If FileExists(@ScriptDir & '\' & $script & '.ini') Then FileDelete(@ScriptDir & '\' & $script & '.ini')
				Exit
			EndIf
		EndIf
	EndIf
	IniWrite($ini, 'Main', 'version', $sVer)
EndFunc   ;==>Install

Func Update()
	FileCreateShortcut($dirMonter & '\' & @ScriptName, @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & @ScriptName, '', 0)
	FileCreateShortcut($dirMonter & '\' & @ScriptName, @StartupDir & '\' & $fnScript & '.lnk', $dirMonter, '-h', $title, $dirMonter & '\' & @ScriptName, '', 0)
EndFunc   ;==>Update
Func UpdateIni()
	IniWrite($ini, 'Main', 'version', $sVer)
	IniWrite($ini, 'Main', 'update', '3-' & _NowCalcDate())
	If IniRead($ini, 'Main', 'logoffForced', '') <> '' Then IniWrite($ini, 'Main', 'logoff', IniRead($ini, 'Main', 'logoffForced', 1) + 1)
	If IniRead($ini, 'Main', 'noLogoff', '') = 1 Then IniWrite($ini, 'Main', 'logoff', 0)
	IniDelete($ini, 'Main', 'logoffForced')
	IniDelete($ini, 'Main', 'noLogoff')
EndFunc   ;==>UpdateIni

Func ExitQuery()
	$exitQry = MsgBox(292, $title, $l_msgExitQuery, 8)
	If $exitQry = 6 Then
		Exit
	Else
		$loop = 0
		msg()
	EndIf
EndFunc   ;==>ExitQuery

Func Uninstall() ;29.11.2009 OK
	$uninQry = MsgBox(308, $title, $l_msgUninstall, 8)
	If $uninQry = 6 Then
		AdlibUnRegister('IdleCheck')
		AdlibUnRegister('LogoffTimeShow')
		AdlibUnRegister('SyncWin')
		GUIDelete($frmMain)
		msg($l_msgUninstallProcess & ' ' & $title & '...')
		If FileExists($ini) Then FileDelete($ini)
		If FileExists(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk') Then FileDelete(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk')
		If Not FileExists(@ProgramsDir & '\monter.FM\*.*') Then DirRemove(@ProgramsDir & '\monter.FM')
		If FileExists(@StartupDir & '\' & $fnScript & '.lnk') Then FileDelete(@StartupDir & '\' & $fnScript & '.lnk')
		$lngpx = 'polski'
		For $i = 1 To 2
			If FileExists(@ScriptDir & '\' & $script & '.' & $lngpx & '.lng') Then FileDelete(@ScriptDir & '\' & $script & '.' & $lngpx & '.lng')
			$lngpx = 'english'
		Next
		If FileExists(@ScriptDir & '\' & $script & '.*.lng') Then
			$delOthLangs = MsgBox(292, $title, $l_msgUninstallDelOthLangs, 8)
			If $delOthLangs = 6 Then FileDelete(@ScriptDir & '\' & $script & '.*.lng')
		EndIf
		If FileExists($fileBat) Then FileDelete($fileBat)
		Sleep(1000)
		$baTemp = FileOpen($fileBat, 1)
		FileWriteLine($baTemp, 'echo                             Uninstall in process: ' & $title & '...' & @CRLF & ':loop' & @CRLF & 'ping -n 3 ' & $serverUrl & @CRLF & 'del "' & $dirMonter & '\' & $script & '.exe"')
		FileWriteLine($baTemp, 'ping -n 2 ' & $serverUrl & @CRLF & 'if exist "' & $dirMonter & '\' & $script & '.exe" goto loop')
		FileWriteLine($baTemp, 'ping -n 6 ' & $serverUrl & @CRLF & 'del "' & $fileBat & '"' & @CRLF & 'exit' & @CRLF & 'cls')
		FileClose($baTemp)
		Sleep(1000)
		Run(@ComSpec & ' /c "' & $fileBat & '"', '', @SW_HIDE)
		Exit
	EndIf
EndFunc   ;==>Uninstall

Func About()
	$frmAbout = GUICreate($title & ' - ' & $l_lblAboutTitle, 280, 144, -1, -1, -1, $WS_EX_WINDOWEDGE, $frmMain)
	$lblAboutTxt = GUICtrlCreateLabel($l_lblAboutTxt, 25, 8, 261, 49)
	$lblBuilt = GUICtrlCreateLabel($title & ' ' & $l_lblBuilt & ' ' & @AutoItVersion & '.', 25, 60, 224, 15)
	$lblWww = GUICtrlCreateLabel($l_lblWww, 25, 78, 80, 17)
	GUICtrlSetFont(-1, 9, 400, 4, 'MS Sans Serif')
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, 'http://monter.fm/')
	If Not FileExists($monterGif) Then FileInstall('.\rob\monter.FM.gif', @TempDir & '\', 1)
	$picMonterAbout = GUICtrlCreatePic($monterGif, 107, 78, 64, 14, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, 'http://monter.fm/')
	GUICtrlCreateLabel($dateRlse, 185, 81, 50, 15)
	GUICtrlSetFont(-1, 7, 400, 0, 'Tahoma')
	$lblWwwApp = GUICtrlCreateLabel($l_lblWwwApp, 25, 96, 127, 17)
	GUICtrlSetFont(-1, 9, 400, 4, 'MS Sans Serif')
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, 'http://' & $serverUrl & '/skrypty/LogOnOff.html')
	$lblWwwForum = GUICtrlCreateLabel($l_lblWwwForum, 164, 96, 127, 17)
	GUICtrlSetFont(-1, 9, 400, 4, 'MS Sans Serif')
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, 'http://www.autoitscript.com/forum/index.php?showtopic=106100')
	$btnOkAbt = GUICtrlCreateButton('OK', 113, 114, 51, 25)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		If $nMsg = $GUI_EVENT_CLOSE Or $nMsg = $btnOkAbt Then ExitLoop
		If $nMsg = $picMonterAbout Or $nMsg = $lblWww Then Link('http://monter.fm/')
		If $nMsg = $lblWwwApp Then Link('http://' & $serverUrl & '/skrypty/LogOnOff.html')
		If $nMsg = $lblWwwForum Then Link('http://www.autoitscript.com/forum/index.php?showtopic=106100')
	WEnd
	GUIDelete($frmAbout)
EndFunc   ;==>About

Func Link($s_StartPath) ;from Rob Saunders' script
	$s_StartStr = @ComSpec & ' /c start "" '
	Run($s_StartStr & $s_StartPath, '', @SW_HIDE)
EndFunc   ;==>Link

Func FileInfo()
	If @Compiled Then
		Global $sVer = StringFormat('%.2f', Number(StringReplace(FileGetVersion(@ScriptFullPath), '.', '')) / 1000) ;script's version in x.xx format
		Global $dateRlse = FileGetVersion(@ScriptFullPath, 'Release date')
	Else
		Opt('TrayIconDebug', 1)
		$strRes = '#AutoIt3Wrapper_' ;section identifying script's version and release date from #AutoIt3Wrapper fields
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
	If $icn = 2 Then $txt = $l_msgWarning & @CRLF & $txt
	If $icn = 3 Then $txt = $l_msgError & @CRLF & $txt
	If $tray = -1 Then ToolTip($txt, $ttX, $ttY, $title, $icn, 2)
	If $tray = 1 Then TrayTip($title, $txt, $ms, $icn)
	Do
		$ms = $ms - 200
		Sleep(200)
		If _Timer_GetIdleTime() < 200 And $esc = 1 Then $brk = 1
		If $brk = 1 Then
			LogoffBrk()
			ExitLoop
		EndIf
	Until $ms <= 0
	If IsDeclared('clr') Then ToolTip('')
EndFunc   ;==>msg

Func OnExit()
	BlockInput(0)
	If Not IsDeclared('runAlr') Then
		If IsDeclared('monterGif') And FileExists($monterGif) Then FileDelete($monterGif)
		If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
		If IsDeclared('icon1') And FileExists($icon1) Then FileDelete($icon1)
		If IsDeclared('icon2') And FileExists($icon2) Then FileDelete($icon2)
		If FileExists($ini) Then IniWrite($ini, 'Main', 'currentLangFile', StringTrimLeft($currFileLang, StringInStr($currFileLang, '\', 0, -1)))
	EndIf
EndFunc   ;==>OnExit