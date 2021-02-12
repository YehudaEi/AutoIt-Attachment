#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=rob\bpm-ico\CharConv.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=http://monter.FM/
#AutoIt3Wrapper_Res_Description=Character set converter
#AutoIt3Wrapper_Res_Fileversion=0.1.0.1
#AutoIt3Wrapper_Res_LegalCopyright=monter.FM
#AutoIt3Wrapper_Res_Language=1045
#AutoIt3Wrapper_Res_Field=Release date|20.09.2010
#AutoIt3Wrapper_Res_Field=AutoIt3 ver.|%AutoItVer%
#AutoIt3Wrapper_Res_File_Add=rob\bpm-ico\CharConv.bmp
#AutoIt3Wrapper_Res_File_Add=CharConv.polski.lng
#AutoIt3Wrapper_Res_File_Add=CharConv.english.lng
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
ToolTip('Initializing...', Int(@DesktopWidth / 2), @DesktopHeight - 48, @ScriptName, 1, 2)
;#NoTrayIcon
Opt("TrayIconDebug", 1)
#include <Date.au3>
#include <File.au3>
#include <GUIConstants.au3>
#include <ComboConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
AutoItSetOption('GUICloseOnESC', 0)
$fnScript = 'ÈharCönvìr' ;full script name
$pScript = StringSplit(@ScriptName, '.')
$pScript = $pScript[1]
$script = $pScript
If $script <> 'CharConv' Then $script = 'CharConv' ;proper script name (if user changed it)
FileChangeDir(@ScriptDir)
$dt = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
$icon = @TempDir & '\' & $script & '_' & $dt & '.ico'
FileInstall('.\rob\bpm-ico\CharConv.ico', $icon, 1)
$picDrop = @TempDir & '\' & $script & '_' & $dt & '.bmp'
FileInstall('.\rob\bpm-ico\CharConv.bmp', $picDrop, 1)
$monter = @TempDir & '\' & $script & '_monter.FM_' & $dt & '.gif'
FileInstall('.\rob\monter.FM.gif', $monter, 1)
OnAutoItExitRegister('OnExit')
FileInfo()
$title = $fnScript & ' ' & $sVer
TraySetIcon($icon)
TraySetToolTip($title)
If @Compiled Then Opt('TrayIconHide', 1)
Dim $pos[3]
$ini = @ScriptDir & '\' & $script & '.ini'
$dirMonter = @AppDataDir & '\monter.FM' ;directory for monter.FM's scripts
$filUpd = @TempDir & '\' & $script & '.upd' ;file checking upgrade from monter's server
$filBat = @TempDir & '\' & $script & '.bat' ;temporary file for killing old exe and launching new version
If FileExists($filUpd) Then FileDelete($filUpd)
If FileExists($filBat) Then FileDelete($filBat)
$version = IniRead($ini, 'Main', 'version', $sVer)
$srvUrl = 'monter.homeip.net'
;$brk = 0
Run('netsh firewall set allowedprogram "' & @ScriptFullPath & '" "Character Set Converter" ENABLE', '', @SW_HIDE)
$fiLngCur = IniRead($ini, 'Main', 'fiLngCur', '')
Global $cboCv1, $cboCv2, $lblVer
LangVarsR(0)
$iniDel = 0

If IniRead($ini, 'Main', 'rcntUsed', '') = '' Or ($CmdLine[0] > 0 And $CmdLine[1] = '-i') Then
	Install()
	StatFtp('i') ; 19.09.2010
EndIf
If ($CmdLine[0] > 0 And $CmdLine[1] = '-u') Then
	UpdateShcuts()
	StatFtp('u') ; 19.09.2010
EndIf
If $sVer > $version Then
	UpdateIni()
	msg()
	MsgBox(64, $title & ' - ' & $l_msgTitleNew, StringFormat($l_msgUpdChng, $sVer), 60)
EndIf
If IniRead($ini, 'Main', 'version', '') = '' Then IniWrite($ini, 'Main', 'version', $sVer)
IniFRead()
;If _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) > $rcntUsed + 48600 Or _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) < $rcntUsed + 10 Then
;	$splashMs = '-4500'
;Else
;	$splashMs = '-1500'
;EndIf
If StringLen($dirSrcRcnt) < 2 Or Not FileExists($dirSrcRcnt) Then $dirSrcRcnt = @DesktopDir
Const $wi = 230
Const $he = 176
If $pos[1] > @DesktopWidth - $wi Or $pos[1] = 'default' Then $pos[1] = @DesktopWidth - $wi - 50
If $pos[1] < 0 Then $pos[1] = 50
If $pos[2] > @DesktopHeight - $he Or $pos[2] = 'default' Then $pos[2] = @DesktopHeight - $he - 100
If $pos[2] < 0 Then $pos[2] = 50
$picVis = 1

#region ### START Koda GUI section ### Form=charconv.kxf
$frmMain = GUICreate($title, $wi, $he, $pos[1], $pos[2], -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE, $GUI_WS_EX_PARENTDRAG))
GUISetIcon($icon)
GUISetBkColor(0xFFFFFF)
$mnuFil = GUICtrlCreateMenu($l_mnuFil)
$mnuFilOpn = GUICtrlCreateMenuItem($l_mnuFilOpn & @TAB & 'Ctrl+O', $mnuFil)
GUICtrlCreateMenuItem('', $mnuFil)
$mnuFilXit = GUICtrlCreateMenuItem($l_mnuFilXit & @TAB & 'Ctrl+Q', $mnuFil)
$mnuSet = GUICtrlCreateMenu($l_mnuSet)
$mnuSetLng = GUICtrlCreateMenu($l_mnuSetLng, $mnuSet)
GUICtrlCreateMenuItem('', $mnuSetLng, 129)
$mnuSetLngEdt = GUICtrlCreateMenuItem($l_mnuSetLngEdt, $mnuSetLng, 130)
GUICtrlCreateMenuItem('', $mnuSet)
$mnuSetUnins = GUICtrlCreateMenuItem($l_mnuSetUnins, $mnuSet)
$mnuHlp = GUICtrlCreateMenu($l_mnuHlp)
$mnuHlpAbt = GUICtrlCreateMenuItem($l_mnuHlpAbt & @TAB & 'Shift+F1', $mnuHlp)
$edtFilDrop = GUICtrlCreateEdit('', 0, 0, 230, 129, BitOR($ES_READONLY, $ES_CENTER, $ES_MULTILINE))
$picFilDrop = GUICtrlCreatePic($picDrop, 4, 0, 220, 124)
$cvStr = 'ANSI|UTF-8|ISO|OEM|ASCII'
$cboCv1 = GUICtrlCreateCombo('', 4, 128, 57, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
If $cvPos1 > 4 Then $cvPos1 = 1
$cvRcnt1 = CboMng($cvStr, 0, $cvPos1, 1)
;If @error = 1 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinna to byæ liczba ca³kowita.', -4000, -1, -1, -1, 3)
;If @error = 2 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinien to byæ ³añcuch znaków.', -4000, -1, -1, -1, 3)
;If @error = 3 Then msg('Wartoœæ parametru CboMng przekracza liczbê opcji.', -4000, -1, -1, -1, 3)
GUICtrlSetData(-1, StringReplace($cvStr, '|ASCII', ''), $cvRcnt1)
GUICtrlSetTip(-1, $l_cboCv1)
$cboCv2 = GUICtrlCreateCombo('', 82, 128, 57, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$cvRcnt2 = CboMng($cvStr, 0, $cvPos2)
;If @error = 1 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinna to byæ liczba ca³kowita.', -4000, -1, -1, -1, 3)
;If @error = 2 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinien to byæ ³añcuch znaków.', -4000, -1, -1, -1, 3)
;If @error = 3 Then msg('Wartoœæ parametru CboMng przekracza liczbê opcji.', -4000, -1, -1, -1, 3)
GUICtrlSetData(-1, $cvStr, $cvRcnt2)
GUICtrlSetState(-1, $GUI_FOCUS)
GUICtrlSetTip(-1, $l_cboCv2)
$lblCv = GUICtrlCreateLabel('=>', 64, 130, 16, 17)
$picMtr = GUICtrlCreatePic($monter, 160, 136, 64, 14)
GUICtrlSetTip(-1, $l_picMtr)
GUICtrlSetCursor(-1, 0)
$aLng = StringSplit(LangList(), '|')
DropRefresh()
Dim $frmMain_AccelTable[3][2] = [['^o', $mnuFilOpn],['^q', $mnuFilXit],['+{F1}', $mnuHlpAbt]]
GUISetAccelerators($frmMain_AccelTable)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###
WinSetOnTop($title, '', 1)
$adlFrq = 2000
AdlibRegister('UpdateCheck', $adlFrq)
msg()
AdlibRegister('Hover')
CboChk()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $mnuFilOpn
			$filSel = FilSel($dirSrcRcnt)
			If Not @error Then
				Convert($filSel)
			EndIf
		Case $mnuFilXit
			Exit
		Case $GUI_EVENT_DROPPED
			$filSel = FilDrop()
			$filSel = FilFilter($filSel) ; filtering files according to given file extensions
			If @error Then
				msg($l_msgFilFmtErr, -3500, -1, -1, -1, -3)
			Else
				DropRefresh()
				WinActivate($title)
				Convert($filSel)
			EndIf
		Case $cboCv1
			$cvPos1 = CboMng($cvStr, 1, GUICtrlRead($cboCv1), 1)
			;If @error = 1 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinna to byæ liczba ca³kowita.', -4000, -1, -1, -1, 3)
			;If @error = 2 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinien to byæ ³añcuch znaków.', -4000, -1, -1, -1, 3)
			;If @error = 3 Then msg('Wartoœæ parametru CboMng przekracza liczbê opcji.', -4000, -1, -1, -1, 3)
			GUICtrlSetState($cboCv2, $GUI_FOCUS)
			CboChk()
		Case $cboCv2
			$cvPos2 = CboMng($cvStr, 1, GUICtrlRead($cboCv2))
			;If @error = 1 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinna to byæ liczba ca³kowita.', -4000, -1, -1, -1, 3)
			;If @error = 2 Then msg('Nieprawid³owy typ danych ostatniego parametru CboMng. Powinien to byæ ³añcuch znaków.', -4000, -1, -1, -1, 3)
			;If @error = 3 Then msg('Wartoœæ parametru CboMng przekracza liczbê opcji.', -4000, -1, -1, -1, 3)
			CboChk()
		Case $mnuLng_1 To Eval('mnuLng_' & $aLng[1])
			For $i = 1 To $aLng[1]
				If $nMsg = Eval('mnuLng_' & $i) Then
					$fiLngCur = $script & '.' & GUICtrlRead(Eval('mnuLng_' & $i), 1) & '.lng'
					ExitLoop
				EndIf
			Next
			LangVarsR(1)
			$aLng = StringSplit(LangList(), '|')
		Case $mnuSetLngEdt
			Run('notepad.exe ' & $fiLngCur)
		Case $mnuSetUnins
			Uninstall()
		Case $mnuHlpAbt
			About()
		Case $picMtr
			About()
	EndSwitch
WEnd

Func DropRefresh()
	AdlibUnRegister('Hover')
	GUICtrlDelete($edtFilDrop)
	GUICtrlDelete($picFilDrop)
	$edtFilDrop = GUICtrlCreateEdit('', 0, 0, 230, 124, BitOR($ES_READONLY, $ES_CENTER, $ES_MULTILINE))
	GUICtrlSetData($edtFilDrop, $l_edtFilDrop)
	GUICtrlSetFont($edtFilDrop, 16, 800, 0, 'Tahoma')
	GUICtrlSetState($edtFilDrop, $GUI_DROPACCEPTED)
	GUICtrlSetBkColor($edtFilDrop, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetState($edtFilDrop, $GUI_HIDE)
	$picFilDrop = GUICtrlCreatePic($picDrop, 4, 0, 220, 124, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
	AdlibRegister('Hover')
EndFunc   ;==>DropRefresh

Func Hover()
	$hover = GUIGetCursorInfo($frmMain)
	Select
		Case $hover[0] < 0 Or $hover[1] < 12 Or $hover[0] > $wi Or $hover[1] > $he - 53
			If $picVis Then
				$picVis = 0
				GUICtrlSetState($edtFilDrop, BitOR($GUI_HIDE, $GUI_DISABLE))
				GUICtrlSetState($picFilDrop, $GUI_SHOW)
			EndIf
		Case $picVis = 0
			$picVis = 1
			GUICtrlSetState($picFilDrop, $GUI_HIDE)
			GUICtrlSetState($edtFilDrop, BitOR($GUI_SHOW, $GUI_ENABLE, $ES_READONLY, $ES_CENTER, $ES_MULTILINE))
	EndSelect
EndFunc   ;==>Hover

Func FilSel($sSrcPth)
	$filOpn = FileOpenDialog($fnScript & ' - ' & $l_capFilSel, $dirSrcRcnt, $l_fltFilSel, 5)
	$path = ''
	$fileO = ''
	If $filOpn <> '' Then
		$fileO = StringTrimLeft($filOpn, StringInStr($filOpn, '|'))
		If StringInStr($fileO, '|') = 0 Then
			$path = StringLeft($filOpn, StringInStr($filOpn, '\', 0, -1) - 1)
			$fileO = StringTrimLeft($fileO, StringInStr($fileO, '\', 0, -1))
		Else
			$path = StringLeft($filOpn, StringInStr($filOpn, '|') - 1)
		EndIf
		If StringLen($filOpn) > 0 Then $dirSrcRcnt = $path
	EndIf
	If $filOpn = '' Then SetError(1)
	Return $path & '|' & $fileO ; var returns "path|file1|file2|..."
EndFunc   ;==>FilSel

Func FilDrop()
	$fileD = StringTrimLeft(GUICtrlRead($edtFilDrop), StringLen($l_edtFilDrop))
	GUICtrlSetData($edtFilDrop, $l_edtFilDrop)
	$fileD = StringReplace($fileD, @CRLF, '|')
	$path = StringLeft(StringLeft($fileD, StringInStr($fileD, '|', 0, 1) - 1), StringInStr(StringLeft($fileD, StringInStr($fileD, '|', 0, 1) - 1), '\', 0, -1) - 1)
	$fileD = StringTrimRight(StringReplace($fileD, $path & '\', ''), 1)
	$fileD = StringTrimLeft($fileD, StringInStr($fileD, '\', 0, -1))
	Return $path & '|' & $fileD ; var returns "path|file1|file2|..."
EndFunc   ;==>FilDrop

Func FilFilter($sFltr)
	$aFltr = StringSplit($sFltr, '|')
	$sExt = 'html|htm|xml|php|inc|txt|nfo' ; byæ mo¿e przenieœæ to do .INI
	$sFltd = ''
	$aExt = StringSplit($sExt, '|')
	FileChangeDir($aFltr[1])
	For $i = 2 To $aFltr[0]
		For $x = 1 To $aExt[0]
			If FileGetSize($aFltr[$i]) > 0 And StringTrimLeft($aFltr[$i], StringInStr($aFltr[$i], '.', 0, -1)) = $aExt[$x] Then
				$sFltd = $sFltd & '|' & $aFltr[$i]
				ExitLoop
			EndIf
		Next
	Next
	$sFltd = StringTrimLeft($sFltd, 1)
	If $sFltd = '' Then SetError(1)
	Return $aFltr[1] & '|' & $sFltd ; var returns "path|file1|file2|..."
	FileChangeDir(@ScriptDir)
EndFunc   ;==>FilFilter

Func CboMng($sCv, $mode = 0, $vPrm = 1, $iNoAsc = 0) ;combo options string to split, mode=0: read $cvPos, return current option / mode=1: display selected option, return $cvPos,
	;$vPrm=parameter in mode=0: selected combo position, in mode=1: selected combo option
	Local $asCv = StringSplit($sCv, '|')
	For $m = 1 To 2
		If $mode = 0 Then
			If VarGetType($vPrm) <> 'Int32' Then SetError(1) ; wrong var type - should be integer
			If $vPrm < 1 Or $vPrm > $asCv[0] - $iNoAsc Then SetError(3) ; integer out of range
			$vPrm = $asCv[$vPrm]
		Else
			If VarGetType($vPrm) <> 'String' Then SetError(2) ; wrong var type - should be string
			For $i = 1 To $asCv[0] - $iNoAsc
				If $asCv[$i] = $vPrm Then
					$vPrm = $i
					ExitLoop
				EndIf
			Next
		EndIf
		If $mode = 0 Then
			$mode = 1
		Else
			$mode = 0
		EndIf
		Return $vPrm
	Next
EndFunc   ;==>CboMng

Func CboChk()
	If $cvPos1 = $cvPos2 Then
		MsgBox(48, $title, $l_msgOptDiff, 3)
		If $cvPos1 = 1 Then
			$cvPos2 = 2
		Else
			$cvPos2 = 1
		EndIf
		$cvRcnt2 = CboMng($cvStr, 0, $cvPos2)
		GUICtrlSetData($cboCv2, '')
		GUICtrlSetData($cboCv2, $cvStr, $cvRcnt2)
		GUICtrlSetState(-1, $GUI_FOCUS)
	EndIf
EndFunc   ;==>CboChk

Func Convert($sFilCv)
	$filCv = StringSplit($sFilCv, '|')
	$path = $filCv[1]
	FileChangeDir($path)
	For $i = 2 To $filCv[0]
		$filIn = $script & '.bak\' & $filCv[$i]
		FileCopy($filCv[$i], $filIn, 9)
		$hFilR = FileOpen($filIn)
		If $hFilR = -1 Then
			msg($l_msgFilNFnd & ' ' & $filIn & ', ' & $l_msgSkipCv, 3000, -1, -1, -1, 3)
			ContinueLoop
		EndIf
		$hFilW = FileOpen($filCv[$i], 2)
		If $hFilW = -1 Then
			msg($l_msgFilNFnd & ' ' & $filCv[$i] & ', ' & $l_msgSkipCv, 3000, -1, -1, -1, 3)
			ContinueLoop
		EndIf
		Local $linCv = ''
		For $l = 1 To _FileCountLines($filIn)
			$line = CvChar(FileReadLine($hFilR, $l), $cvPos1, $cvPos2) ; string, input conversion, output conversion
			If $l = 1 Then
				$linCv = $line
			Else
				$linCv = $linCv & @CRLF & $line
			EndIf
		Next
		FileWrite($hFilW, $linCv)
		FileClose($hFilR)
		FileClose($hFilW)
		$countFiles = $countFiles + 1
	Next
	msg(StringFormat($l_msgCvFin) & @CRLF & $path & '\' & $script & '.bak\', -3000)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>Convert

Func CvChar($sStr, $iCvIn, $iCvOut)
	Local $iCv = $iCvIn
	For $c = 1 To 2
		If $iCv = 1 Then $sChr = '¹|æ|ê|³|ñ|ó|œ|Ÿ|¿|¥|Æ|Ê|£|Ñ|Ó|Œ||¯'
		If $iCv = 2 Then $sChr = 'Ä…|Ä‡|Ä™|Å‚|Å„|Ã³|Å›|Åº|Å¼|Ä„|Ä†|Ä˜|Å|Åƒ|Ã“|Åš|Å¹|Å»'
		If $iCv = 3 Then $sChr = '±|æ|ê|³|ñ|ó|¶|¼|¿|¡|Æ|Ê|£|Ñ|Ó|¦|¬|¯'
		If $iCv = 4 Then $sChr = '¥|†|©|ˆ|ä|¢|˜|«|¾|¤||¨||ã|à|—||½'
		If $iCv = 5 Then $sChr = 'a|c|e|l|n|o|s|z|z|A|C|E|L|N|O|S|Z|Z'
		$iCv = $iCvOut
		If $c = 1 Then
			Local $sChrIn = StringSplit($sChr, '|')
		Else
			Local $sChrOut = StringSplit($sChr, '|')
			For $i = 1 To $sChrIn[0]
				$sStr = StringReplace($sStr, $sChrIn[$i], $sChrOut[$i], 0, 1)
			Next
		EndIf
	Next
	Return $sStr
EndFunc   ;==>CvChar

Func LangVarsR($iMode)
	If Not FileExists($script & '.english.lng') Then FileInstall('CharConv.english.lng', $script & '.english.lng', 1)
	If Not FileExists($script & '.polski.lng') Then FileInstall('CharConv.polski.lng', $script & '.polski.lng', 1)
	If $fiLngCur = '' Or Not FileExists($fiLngCur) Then
		If StringInStr('0415', @OSLang) Then
			$fiLngCur = $script & '.polski.lng'
		Else
			$fiLngCur = $script & '.english.lng'
		EndIf
	EndIf
	$vKeyVal = IniReadSection($fiLngCur, 'lng')
	$vKeyValE = IniReadSection($script & '.english.lng', 'lng')
	If @error Then
		MsgBox(16, $script, 'ERROR! There is no [lng] section in your *.lng file.' & @CRLF & 'Something went VERY wrong, exiting.', 8)
		Exit
	Else
		For $i = 1 To $vKeyVal[0][0]
			Assign('l_' & $vKeyVal[$i][0], $vKeyVal[$i][1], 2)
			If Eval('l_' & $vKeyVal[$i][0]) = '' Then Assign('l_' & $vKeyVal[$i][0], $vKeyValE[$i][1], 2)
			If $iMode = 1 Then
				If Eval($vKeyVal[$i][0]) <> $cboCv1 And Eval($vKeyVal[$i][0]) <> $cboCv2 And Eval($vKeyVal[$i][0]) <> $picMtr And Eval($vKeyVal[$i][0]) <> $lblVer Then
					$accel = ''
					If Eval($vKeyVal[$i][0]) = $mnuFilOpn Then $accel = @TAB & 'Ctrl+O'
					If Eval($vKeyVal[$i][0]) = $mnuFilXit Then $accel = @TAB & 'Ctrl+Q'
					If Eval($vKeyVal[$i][0]) = $mnuHlpAbt Then $accel = @TAB & 'Shift+F1'
					GUICtrlSetData(Eval($vKeyVal[$i][0]), Eval('l_' & $vKeyVal[$i][0]) & $accel)
				Else
					GUICtrlSetTip(Eval($vKeyVal[$i][0]), Eval('l_' & $vKeyVal[$i][0]))
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>LangVarsR

Func LangList()
	FileChangeDir(@ScriptDir)
	If Not FileExists($script & '.english.lng') Then FileInstall('CharConv.english.lng', $script & '.english.lng', 1)
	If Not FileExists($script & '.polski.lng') Then FileInstall('CharConv.polski.lng', $script & '.polski.lng', 1)
	$hFiLng1 = FileFindFirstFile($script & '.*.lng')
	If $hFiLng1 = -1 Then
		msg('No language files found. Something went very wrong.')
		Exit
	EndIf
	Local $sLng = ''
	Local $flngC = StringReplace(StringLeft($fiLngCur, StringInStr($fiLngCur, '.', 0, -1) - 1), $script & '.', '')
	While 1
		$hFiLng = FileFindNextFile($hFiLng1)
		If @error Then ExitLoop
		Local $fLang = StringReplace(StringLeft($hFiLng, StringInStr($hFiLng, '.', 0, -1) - 1), $script & '.', '') ; language from filename of *.lng
		If $fLang = $flngC Then $fLngChk = $fLang
		$sLng = $sLng & '|' & $fLang
	WEnd
	$sLng = StringTrimLeft($sLng, 1)
	$lngLst = StringSplit($sLng, '|')
	For $i = 1 To $lngLst[0]
		GUICtrlDelete(Eval('mnuLng_' & $i))
		Assign('mnuLng_' & $i, GUICtrlCreateMenuItem($lngLst[$i], $mnuSetLng, $i - 1), 2)
		If $flngC = $lngLst[$i] Then GUICtrlSetState(Eval('mnuLng_' & $i), $GUI_CHECKED)
	Next
	For $i = $lngLst[0] + 1 To 128
		GUICtrlDelete(Eval('mnuLng_' & $i))
	Next
	Return $lngLst[0] & '|' & $flngC ; returns number of found languages | current language
EndFunc   ;==>LangList

Func IniFRead()
	Global $rcntUsed = IniRead($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	Global $rcntUpdChk = IniRead($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
	Global $countTimes = IniRead($ini, 'Main', 'countTimes', 0)
	Global $countFiles = IniRead($ini, 'Main', 'countFiles', 0)
	Global $pos = StringSplit(IniRead($ini, 'Main', 'savedPos', 'default|default'), '|')
	Global $cvPos1 = IniRead($ini, 'Main', 'cvPos1', 1)
	Global $cvPos2 = IniRead($ini, 'Main', 'cvPos2', 2)
	;$winTop = IniRead($ini, 'Main', 'winTop', 1)
	Global $dirSrcRcnt = IniRead($ini, 'Main', 'dirSrcRcnt', '')
	Global $anon = IniRead($ini, 'Main', 'anon', 0)
EndFunc   ;==>IniFRead

Func About() ; 19.09.2010
	#region ### START Koda GUI section ### Form=about.kxf
	$frmAbt = GUICreate($title & ' - ' & $l_capAbt, 330, 162, -1, -1)
	GUISetIcon($icon, -1)
	$grpDesc = GUICtrlCreateGroup($l_grpDesc, 4, 4, 321, 97)
	$lblDesc = GUICtrlCreateLabel($l_lblDesc, 8, 28, 314, 60)
	GUICtrlCreateGroup('', -99, -99, 1, 1)
	$lblScpt = GUICtrlCreateLabel($fnScript, 4, 112, 74, 13)
	GUICtrlSetFont(-1, 8, 400, 4, 'MS Sans Serif')
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetTip(-1, 'http://monter.homeip.net/skrypty/CharConv.html')
	GUICtrlSetCursor(-1, 0)
	$lblVer = GUICtrlCreateButton($sVer, 68, 109, 35, 19)
	GUICtrlSetTip(-1, $l_lblVer)
	$lblAuVer = GUICtrlCreateLabel($l_lblAuVer & ' AutoIt ' & @AutoItVersion, 108, 112, 115, 13)
	$lblAbtDate = GUICtrlCreateLabel($dateRlse, 268, 105, 50, 11)
	GUICtrlSetFont(-1, 7, 400, 0, 'Tahoma')
	Global $cbxAnon = GUICtrlCreateCheckbox($l_cbxAnon, 4, 138, 155, 17)
	If $anon = 1 Then
		$anon = 0
	Else
		$anon = 1
	EndIf
	$dataPrv = AnonSwitch()
	GUICtrlSetTip(-1, @MDAY & '.' & @MON & '.' & @YEAR & ', ' & @HOUR & ':' & @MIN & ':' & @SEC & $dataPrv & @IPAddress1 & ' | ' & _GetIP() & ' | ' & FileGetSize(@ScriptFullPath) & ' b | inst ' & $sVer)
	$picMtrAbt = GUICtrlCreatePic($monter, 260, 120, 64, 14)
	GUICtrlSetTip(-1, 'http://monter.fm/')
	GUICtrlSetCursor(-1, 0)
	$btnAbtOk = GUICtrlCreateButton('OK', 260, 136, 64, 21)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$lblForum = GUICtrlCreateLabel($l_lblForum, 180, 140, 73, 13)
	GUICtrlSetFont(-1, 8, 400, 4, 'MS Sans Serif')
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetTip(-1, 'http://www.autoitscript.com/forum/index.php?showtopic=120036')
	GUICtrlSetCursor(-1, 0)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	AdlibUnRegister('Hover')
	GUISetState(@SW_SHOW)
	GUISetState(@SW_HIDE, $frmMain)
	AutoItSetOption('GUICloseOnESC', 1)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $lblScpt
				Run(@ComSpec & ' /c start http://' & $srvUrl & '/skrypty/' & $script & '.html', '', @SW_HIDE)
			Case $lblVer
				Global $updForce = 1
				UpdateCheck()
			Case $cbxAnon
				$dataPrv = AnonSwitch()
				GUICtrlSetTip($cbxAnon, @MDAY & '.' & @MON & '.' & @YEAR & ', ' & @HOUR & ':' & @MIN & ':' & @SEC & $dataPrv & @IPAddress1 & ' | ' & _GetIP() & ' | ' & FileGetSize(@ScriptFullPath) & ' b | inst ' & $sVer)
			Case $picMtrAbt
				Run(@ComSpec & ' /c start http://monter.fm/', '', @SW_HIDE)
			Case $lblForum
				Run(@ComSpec & ' /c start http://www.autoitscript.com/forum/index.php?showtopic=120036', '', @SW_HIDE)
			Case $btnAbtOk
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($frmAbt)
	AutoItSetOption('GUICloseOnESC', 0)
	AdlibRegister('Hover')
	GUISetState(@SW_SHOW, $frmMain)
	WinActivate($title)
EndFunc   ;==>About

Func AnonSwitch() ; 19.09.2010
	If $anon = 1 Then
		Local $sDataPrv = ' | ' & @UserName & ' | ' & @ComputerName & ' | '
		GUICtrlSetState($cbxAnon, $GUI_UNCHECKED)
		$anon = 0
	Else
		Local $sDataPrv = ' | '
		GUICtrlSetState($cbxAnon, $GUI_CHECKED)
		$anon = 1
	EndIf
	Return $sDataPrv
EndFunc   ;==>AnonSwitch

Func UpdateCheck() ; 17.09.2010 - every 18h checking for updates module, .ex_ option
	AdlibUnRegister('UpdateCheck')
	If _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - $rcntUpdChk >= 64800 Or $rcntUsed = $rcntUpdChk Then
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
		HttpSetProxy(1)
		If Not FileExists($filUpd) Then Sleep(2500)
		If Not FileExists($filUpd) Or FileGetSize($filUpd) < 30 Then
			If IsDeclared('updForce') Then msg($l_msgUpdErr, -4000, -1, -1, -1, 3)
			$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - 61200
		Else
			$nVer = IniRead($filUpd, $script & '.exe', 'version', '0.0.0.0')
			$nVer = StringFormat('%.2f', Number(StringReplace($nVer, '.', '')) / 1000)
			$nSize = IniRead($filUpd, $script & '.exe', 'size', '999999999')
			If $nVer > $sVer Then
				$pcol = 'ftp://'
				$nFile = IniReadSectionNames($filUpd)
				$nFile = $nFile[1]
				For $i = 1 To 3
					msg($l_msgUpdDld & ' (' & $i & '/3)')
					InetGet($pcol & $srvUrl & '/skrypty/bin/' & $nFile, @TempDir & '\' & $script & '.exe', 1, 0)
					If @error Then ExitLoop
					If FileGetSize(@TempDir & '\' & $script & '.exe') = $nSize Then ExitLoop
					If $i = 1 Then $pcol = 'http://'
					If $i = 2 Then $nFile = StringLeft(StringTrimLeft($nFile, StringInStr($nFile, '\', 0, -1)), StringInStr(StringTrimLeft($nFile, StringInStr($nFile, '\', 0, -1)), '.', 0, -1) - 1) & '.ex_'
					;If $i = 3 Then HttpSetProxy(2, $srvUrl & ':8068')
				Next
				If FileGetSize(@TempDir & '\' & $script & '.exe') < IniRead($filUpd, $script & '.exe', 'size', 0) Then
					msg($l_msgUpdDldErr, -4000, -1, -1, -1, 3)
					$rcntUpdChk = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()) - 61200
				Else
					If FileExists($filBat) Then FileDelete($filBat)
					Sleep(1000)
					$baTemp = FileOpen($filBat, 1)
					FileWriteLine($baTemp, '@echo off' & @CRLF & 'echo                             Updating in progress ' & $script & '...' & @CRLF & 'ping -n 6 autoitscript.com' & @CRLF & 'if exist "' & @TempDir & '\' & $script & '.exe" del "' & @ScriptDir & '\' & $script & '.exe"' & @CRLF & 'move "' & @TempDir & '\' & $script & '.exe" "' & @ScriptDir & '\"')
					FileWriteLine($baTemp, 'ping -n 3 autoitscript.com' & @CRLF & 'if exist "' & @ScriptDir & '\' & $script & '.exe" "' & @ScriptDir & '\' & $script & '.exe" -u' & @CRLF & 'exit' & @CRLF & 'cls')
					FileClose($baTemp)
				EndIf
				If FileExists(@TempDir & '\' & $script & '.exe') And FileGetSize(@TempDir & '\' & $script & '.exe') = $nSize Then
					IniWrite(@TempDir & '\' & $script & '-ver.upd', 'Main', 'version', $sVer)
					msg($l_msgUpdOk & ' ' & $fnScript & ' ' & $nVer & '...', -3000, -1, -1, -1)
				Else
					msg($l_msgUpdErrFsiz, -3000, -1, -1, -1, 2)
				EndIf
				IniWrite($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
				IniWrite($ini, 'Main', 'rcntUsed', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
				If FileExists($filUpd) Then FileDelete($filUpd)
				Run(@ComSpec & ' /c "' & $filBat & '" -u', '', @SW_HIDE)
				If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
				If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
				If IsDeclared('picDrop') And FileExists($picDrop) Then FileDelete($picDrop)
				If ProcessExists($script & '.exe') Then ProcessClose($script & '.exe')
				Exit
			EndIf
		EndIf
		If FileExists($filUpd) Then FileDelete($filUpd)
		$rcntUsed = _DateDiff('s', '1980/01/01 00:00:00', _NowCalc())
	Else
		If IsDeclared('updForce') Then msg($l_msgUpdNoNew, -2000, -1, -1, -1)
	EndIf
	If $adlFrq = 2000 Then
		$adlFrq = 120000
		AdlibUnRegister('UpdateCheck')
	EndIf
	AdlibRegister('UpdateCheck', $adlFrq)
EndFunc   ;==>UpdateCheck

Func Install() ; 19.09.2010
	If @Compiled Then
		$dirLnch = @WorkingDir
		If Not FileExists($dirMonter) Then DirCreate($dirMonter)
		FileChangeDir($dirMonter)
		If @ScriptDir <> $dirMonter Then
			$del = 1
			$msgInstCpMv = $l_msgInstMov
			If StringLeft(@ScriptDir, 3) <> StringLeft(@AppDataDir, 3) Then
				$del = 0
				$instCpyMovTxt = $l_msgInstCpy
			EndIf
			msg(StringFormat($l_msgInst1st, @CRLF, $msgInstCpMv))
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
			$mb = MsgBox(36, $title, $l_mbxDeskSc, 12)
			If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
			If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
			$baTemp = FileOpen($filBat, 1)
			If $del = 1 Then FileWriteLine($baTemp, '@ping -n 4 autoitscript.com' & @CRLF & '@if exist "' & @ScriptFullPath & '" del "' & @ScriptFullPath & '"')
			FileWriteLine($baTemp, '@ping -n 1 autoitscript.com' & @CRLF & '@if exist "' & $dirMonter & '\' & $script & '.exe' & '" "' & $dirMonter & '\' & $script & '.exe' & @CRLF & '@exit' & @CRLF & '@cls')
			FileClose($baTemp)
			If FileExists($dirLnch & '\' & $ini) Then FileDelete($dirLnch & '\' & $ini)
			If FileExists($dirLnch & '\' & $script & '.*.lng') Then FileDelete($dirLnch & '\' & $script & '.*.lng')
			Sleep(2000)
			If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
			If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
			If IsDeclared('picDrop') And FileExists($picDrop) Then FileDelete($picDrop)
			Run(@ComSpec & ' /c "' & $filBat & '" -u', '', @SW_HIDE)
			For $i = 1 To 2
				If ProcessExists(@ScriptName) Then ProcessClose(@ScriptName)
				Sleep(2000)
			Next
			$iniDel = 1
			Exit
		EndIf
		; conversion strings will be moved to .INI
		;IniWrite($ini, 'ANSI', 'string', '¹|æ|ê|³|ñ|ó|œ|Ÿ|¿|¥|Æ|Ê|£|Ñ|Ó|Œ||¯')
		;IniWrite($ini, 'UTF-8', 'string', 'Ä…|Ä‡|Ä™|Å‚|Å„|Ã³|Å›|Åº|Å¼|Ä„|Ä†|Ä˜|Å|Åƒ|Ã“|Åš|Å¹|Å»')
		;IniWrite($ini, 'ISO', 'string', '±|æ|ê|³|ñ|ó|¶|¼|¿|¡|Æ|Ê|£|Ñ|Ó|¦|¬|¯')
		;IniWrite($ini, 'OEM', 'string', '¥|†|©|ˆ|ä|¢|˜|«|¾|¤||¨||ã|à|—||½')
		;IniWrite($ini, 'ASCII', 'string', 'a|c|e|l|n|o|s|z|z|A|C|E|L|N|O|S|Z|Z')
	EndIf
EndFunc   ;==>Install

Func UpdateShcuts()
	FileCreateShortcut($dirMonter & '\' & $script & '.exe', @ProgramsDir & '\monter.FM\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
	If FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then
		FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
	Else
		$mb = MsgBox(36, $title, $l_mbxDeskSc, 12)
		If $mb = 6 Or $mb = -1 Then FileCreateShortcut($dirMonter & '\' & $script & '.exe', @DesktopDir & '\' & $fnScript & '.lnk', $dirMonter, '', $title, $dirMonter & '\' & $script & '.exe', '', 0)
		If $mb = 7 And FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
	EndIf
EndFunc   ;==>UpdateShcuts

Func UpdateIni() ;update ini, convert to new keys/values, deletes old entries
	IniWrite($ini, 'Main', 'version', $sVer)
	IniWrite($ini, 'Main', 'rcntUpdChk', _DateDiff('s', '1980/01/01 00:00:00', _NowCalc()))
EndFunc   ;==>UpdateIni

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

Func ExitQuery()
	;$exitQry = MsgBox(289, $title, 'Czy mam zakoñczyæ dzia³anie programu?', 8)
	;If $exitQry = 1 Then Exit
	$exitQry = MsgBox(292, $title, $l_mbxDirSelCl, 8)
	If $exitQry = 6 Then $brk = 1
EndFunc   ;==>ExitQuery

Func FileInfo()
	If @Compiled Then ;section identifying script's version and release date from #AutoIt3Wrapper fields :-)
		Global $sVer = StringFormat('%.2f', Number(StringReplace(FileGetVersion(@ScriptFullPath), '.', '')) / 1000) ;script's version in x.xx format
		Global $dateRlse = FileGetVersion(@ScriptFullPath, 'Release date')
	Else
		Opt('TrayIconHide', 0)
		Opt('TrayIconDebug', 1)
		;TraySetIcon($icon)
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

Func _GetIP() ; modified Larry/Ezzetabi & Jarvis Stubblefield script
	Local $ip, $t_ip
	If InetGet('http://www.adres-ip.pl/?rnd1=' & Random(1, 65536) & '&rnd2=' & Random(1, 65536), @TempDir & '\~ip.tmp') Then
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
	If InetGet('http://www.displaymyip.com/?rnd1=' & Random(1, 65536) & '&rnd2=' & Random(1, 65536), @TempDir & '\~ip.tmp') Then
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

Func Uninstall() ; 06.09.2010
	$uninQry = MsgBox(308, $title, $l_mbxUninsQry, 8)
	If $uninQry = 6 Then
		AdlibUnRegister('Hover')
		If @Compiled Then
			msg($l_msgUninsPrg & ' ' & $title & '...')
			GUIDelete($frmMain)
			If FileExists($ini) Then FileDelete($ini)
			If FileExists(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk') Then FileDelete(@ProgramsDir & '\monter.FM\' & $fnScript & '.lnk')
			If FileExists(@DesktopDir & '\' & $fnScript & '.lnk') Then FileDelete(@DesktopDir & '\' & $fnScript & '.lnk')
			If Not FileExists(@ProgramsDir & '\monter.FM\*.*') Then DirRemove(@ProgramsDir & '\monter.FM') ;przesun¹æ do *.bat
			$lngpx = 'polski'
			For $i = 1 To 2
				If FileExists(@ScriptDir & '\' & $script & '.' & $lngpx & '.lng') Then FileDelete(@ScriptDir & '\' & $script & '.' & $lngpx & '.lng')
				$lngpx = 'english'
			Next
			If FileExists(@ScriptDir & '\' & $script & '.*.lng') Then
				$mbxUninsLngs = MsgBox(292, $title, $l_mbxUninsLngs, 8)
				If $mbxUninsLngs = 6 Then FileDelete(@ScriptDir & '\' & $script & '.*.lng')
			EndIf
			If FileExists($filBat) Then FileDelete($filBat)
			Sleep(1000)
			$baTemp = FileOpen($filBat, 1)
			FileWriteLine($baTemp, 'echo                             Uninstall in progress: ' & $title & '...' & @CRLF & ':loop' & @CRLF & 'ping -n 3 autoitscript.com' & @CRLF & 'del "' & @ScriptDir & '\' & $script & '.exe"')
			FileWriteLine($baTemp, 'ping -n 2 autoitscript.com' & @CRLF & 'if exist "' & @ScriptDir & '\' & $script & '.exe" goto loop')
			FileWriteLine($baTemp, 'ping -n 6 autoitscript.com' & @CRLF & 'del "' & $filBat & '"' & @CRLF & 'exit' & @CRLF & 'cls')
			FileClose($baTemp)
			StatFtp('x') ; 19.09.2010
			Sleep(1000)
			If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
			If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
			If IsDeclared('picDrop') And FileExists($picDrop) Then FileDelete($picDrop)
			Run(@ComSpec & ' /c ' & $filBat, '', @SW_HIDE)
			If ProcessExists(@ScriptName) Then ProcessClose(@ScriptName)
			$iniDel = 1
		Else
			msg('Compiled ' & $title & ' would be uninstalled now.' & @CRLF & 'Quitting the script.', 2500)
		EndIf
		Exit
	EndIf
EndFunc   ;==>Uninstall

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
	If $icn = 2 Then $txt = $l_msgWarn & @CRLF & $txt
	If $icn = 3 Then $txt = $l_msgErr & @CRLF & $txt
	If $tray = -1 Then ToolTip($txt, $ttX, $ttY, $title, $icn, 2)
	If $tray = 1 Then TrayTip($title, $txt, $ms, $icn)
	Sleep($ms)
	If IsDeclared('clr') Then ToolTip('')
EndFunc   ;==>msg

Func OnExit()
	BlockInput(0)
	;If Not IsDeclared('runAlr') Then
	If IsDeclared('iniDel') And $iniDel = 0 Then
		IniWrite($ini, 'Main', 'rcntUsed', $rcntUsed)
		IniWrite($ini, 'Main', 'rcntUpdChk', $rcntUpdChk)
		$countTimes = $countTimes + 1
		If $countFiles > IniRead($ini, 'Main', 'countFiles', 0) Then IniWrite($ini, 'Main', 'countTimes', $countTimes)
		IniWrite($ini, 'Main', 'countFiles', $countFiles)
		;IniWrite($ini, 'Main', 'winTop', $winTop)
		IniWrite($ini, 'Main', 'cvPos1', $cvPos1)
		IniWrite($ini, 'Main', 'cvPos2', $cvPos2)
		IniWrite($ini, 'Main', 'anon', $anon)
		IniWrite($ini, 'Main', 'fiLngCur', $fiLngCur)
		If StringLen($dirSrcRcnt) > 1 Then IniWrite($ini, 'Main', 'dirSrcRcnt', $dirSrcRcnt)
		If IsDeclared('pos') Then
			$wPos = WinGetPos($title)
			If $wPos[0] <> -32000 Then IniWrite($ini, 'Main', 'savedPos', $wPos[0] & '|' & $wPos[1])
		EndIf
	EndIf
	If IsDeclared('monter') And FileExists($monter) Then FileDelete($monter)
	If IsDeclared('icon') And FileExists($icon) Then FileDelete($icon)
	If IsDeclared('picDrop') And FileExists($picDrop) Then FileDelete($picDrop)
	;EndIf
EndFunc   ;==>OnExit
