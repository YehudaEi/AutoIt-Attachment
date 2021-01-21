#cs
	Author: monter.FM
	Version: 1.30
	AutoItVer: 3.1.1.83
	AutoItForum: http://www.autoitscript.com/forum/index.php?showtopic=16588
	Description:
	Search for CD drive type and allows you to open/close drive tray.
#ce
#NoTrayIcon
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_DEFBUTTON = 512
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $SS_SUNKEN = 0x1000
Global Const $SS_CENTER = 1

$cds = DriveGetDrive("CDROM")
Dim $stan[1 + $cds[0]], $nazwa[1 + $cds[0]], $LBL_CD[1 + $cds[0]], $BT_CD[1 + $cds[0]], $ED_CD[1 + $cds[0]], $stat_Bt[1 + $cds[0]], $zmieNaz[1 + $cds[0]], $GR_CD[1 + $cds[0]], $CB_aOp[1 + $cds[0]], $CB_aCl[1 + $cds[0]], $aOpen[1 + $cds[0]], $aClose[1 + $cds[0]], $kon

If @Compiled Then
	;$cdtv = StringFormat("%.2f", FileGetVersion(@ScriptFullPath))
	$cdtv = StringFormat("%.2f", Number(StringReplace(FileGetVersion(@ScriptFullPath), ".", "")) / 1000)
Else
	$cdtv = "1.30"
EndIf
$proDate = "14.10.2005"
If Not @error Then
	If Not FileExists(@ScriptDir & "\CDTray.ini") Then;if .INI not found
		MakeIni()
		MakeLang()
	ElseIf Int(IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "v", "0") * 10) < Int($cdtv * 10) Then;delete .INI if older version
		For $nr = 1 To $cds[0]
			$nazwa[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr) ;preserving drive names and auto-exit delay for new .INI
			If StringLen($nazwa[$nr]) = 0 Then
				$nazwa[$nr] = "CD" & $nr
			EndIf
		Next
		$sek = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", "30")
		IniDelete(@ScriptDir & "\CDTray.ini", "Txt") ;just deleting old .INI left old section (how is it possible?)
		FileDelete(@ScriptDir & "\CDTray.ini")
		$lngDel = "english"
		For $i = 1 To 2
			If FileExists(@ScriptDir & "\CDTray." & $lngDel & ".lng") Then;deleting any default (EN, PL) lang files
				FileDelete(@ScriptDir & "\CDTray." & $lngDel & ".lng")
			EndIf
			$lngDel = "polski"
		Next
		
		MakeIni()
		MakeLang()
	EndIf
	For $nr = 1 To $cds[0];reading status and settings of each CD drive
		$stan[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "Unknown")
		$nazwa[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr)
		$aOpen[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoOpen", "0")
		$aClose[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoClose", "1")
		If StringLen($nazwa[$nr]) = 0 Then
			$nazwa[$nr] = "CD" & $nr
		EndIf
	Next
	$sek = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", "30")
	$aExit = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "AutoExit", "1")
	If Not FileExists(@ScriptDir & "\CDTray.english.lng") Or Not FileExists(@ScriptDir & "\CDTray.polski.lng") Then
		MakeLang()
	EndIf
	$lngFile = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "CurrLangFile", "CDTray.english.lng")
	If Not FileExists(@ScriptDir & "\" & $lngFile) Then $lngFile = @ScriptDir & "\CDTray.english.lng"
	$lngFile = @ScriptDir & "\" & $lngFile
	$lngRdSect = IniReadSectionNames($lngFile)
	$lng = $lngRdSect[1]
EndIf
$top = 42;space between CD drive rows


;ATTENTION!!!   *** Below you have to edit true path to file monter.FM.gif   ***
;---------
FileInstall("E:\batch\rob\monter.FM.gif", @TempDir & "\", 1)
;FileInstall("C:\windows\pulpit\monter\batch\rob\monter.FM.gif", @TempDir & "\", 1)
;FileInstall("D:\util\batch\rob\monter.FM.gif", @TempDir & "\", 1)
;FileInstall("F:\batch\rob\monter.FM.gif", @TempDir & "\", 1)
;---------

$CDTray = GUICreate("CDTray " & $cdtv, 245, 56+ ($cds[0] * $top)) ;building GUI and controls
GUISetBkColor(0xADC5C5)
$GR_aOC = GUICtrlCreateGroup("    Auto - ", 181, 7, 62, 21+ ($cds[0] * $top))
$czas = $sek
$kon = GUICtrlCreateLabel($czas, 94, 6, 16, 16, $SS_SUNKEN + $SS_CENTER)
GUICtrlSetBkColor(-1, 0xE3FFFE)
GUICtrlSetColor($kon, 0x003399)
$start = TimerInit()
$status = GUICtrlCreateLabel("", 2, 38+ ($cds[0] * $top), 84, 16, $SS_SUNKEN + $SS_CENTER)
$CB_lng = GUICtrlCreateCombo("", 99, 33+ ($cds[0] * $top), 44, 108)
$zmCzas = GUICtrlCreateInput($sek, 93, 5, 37, 17)
GUICtrlSetLimit(-1, 2)
GUICtrlSetState($zmCzas, $GUI_HIDE)
$updn = GUICtrlCreateUpdown($zmCzas)
GUICtrlSetLimit(-1, 90, 6)
GUICtrlSetState($updn, $GUI_HIDE)
$LB_edlng = GUICtrlCreateLabel("E", 147, 38+ ($cds[0] * $top), 7, 10)
GUICtrlSetBkColor(-1, 0xEEEEEE)
GUICtrlSetFont($LB_edlng, 8, 300, -1, "Lucida Console")
If FileExists(@TempDir & "\monter.FM.gif") Then;in case you forgot to edit FileInstall path :-)
	$monter = GUICtrlCreatePic(@TempDir & "\monter.FM.gif", 177, 40+ ($cds[0] * $top), 64, 14)
Else
	$monter = GUICtrlCreateLabel("monter.FM", 192, 40+ ($cds[0] * $top), 64, 14)
EndIf
ReadLang() ;we're going to read our language items
$CB_aX = GUICtrlCreateCheckbox($aX, 4, 4, 74)
GUICtrlSetTip($CB_aX, $tipaEx)
$LB_aX2 = GUICtrlCreateLabel($aX2, 79, 7, 13)
$LB_aX3 = GUICtrlCreateLabel($aX3, 114, 7, 24)
$LB_kon = GUICtrlSetTip($kon, $tipsec)
$TP_lng = GUICtrlSetTip($CB_lng, $tipLng)
$TP_edlng = GUICtrlSetTip($LB_edlng, $tipedLng)
$ustCzas = GUICtrlCreateButton($btSet, 132, 5, 40, 17)
$mtrTip = GUICtrlSetTip($monter, $tipAbt)
GUICtrlSetState($ustCzas, $GUI_HIDE)
AutoExitF() ;Auto-exit func

For $nr = 1 To $cds[0]
	If $stan[$nr] = "closed" Then;checking state of CD (opened or closed) and display proper label on the button
		$stat_Bt[$nr] = $btOpen
	Else
		$stat_Bt[$nr] = $btClose
	EndIf
	$LBL_CD[$nr] = GUICtrlCreateLabel("[" & $cds[$nr] & "]", 5, -4+ ($nr * $top))
	$ED_CD[$nr] = GUICtrlCreateInput($nazwa[$nr], 24, -6+ ($nr * $top), 97, 21)
	GUICtrlSetTip(-1, $tipdrv)
	GUICtrlSetBkColor($ED_CD[$nr], 0xE3FFFE)
	GUICtrlSetColor($ED_CD[$nr], 0x003399)
	$BT_CD[$nr] = GUICtrlCreateButton($stat_Bt[$nr], 126, -8+ ($nr * $top), 51, 25)
	$CB_aOp[$nr] = GUICtrlCreateCheckbox($aOp, 186, -14+ ($nr * $top), 54)
	GUICtrlSetTip(-1, $tipaOp)
	$CB_aCl[$nr] = GUICtrlCreateCheckbox($aCl, 186, 3+ ($nr * $top), 54)
	GUICtrlSetTip(-1, $tipaCl)
	$GR_CD[$nr] = GUICtrlCreateGroup("", 2, -22+ ($nr * $top), 241, 50)
	AutoOpenF() ;checking Auto-open func (opening CD tray during launching program)
	AutoCloseF() ;checking Auto-close tray func
Next
GUICtrlSetState($BT_CD[1], $GUI_FOCUS)

GUISetState(@SW_SHOW)
For $nr = 1 To $cds[0]
	If $aOpen[$nr] = 1 Then
		$staTxt = $stOpen & " [" & $cds[$nr] & "] ..."
		$opcl = "open"
		$stanIni = "opened"
		$stat_Bt[$nr] = $btClose
		GUICtrlSetData($status, $staTxt) ;displaying status (opening or closing)
		GUICtrlSetBkColor($status, 0xF9E8A5)
		CDTray($cds[$nr], $opcl) ; Yeah babe, here is the exactly what this script is for, I hope :-)
		$start = TimerInit() ;reset auto-exit delay - we have once more xx secs to act
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", $stanIni) ;to remember the last state of drive
		GUICtrlSetData($status, "")
		GUICtrlSetBkColor($status, 0xADC5C5)
		$stan[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "Unknown")
		GUICtrlSetData($BT_CD[$nr], $stat_Bt[$nr])
	EndIf
Next
If $aExit = 1 Then AdlibEnable("PozCzas")

While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then
		Koniec()
		Exit
	EndIf
	If $msg = $kon Then;going to set auto-exit delay
		OpcjaCzas()
	EndIf
	If $msg = $ustCzas Then;confirmation of setting auto-exit delay
		UstawCzas()
		GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
	EndIf
	If $msg = $CB_aX And GUICtrlGetState($ustCzas) <> $GUI_SHOW + $GUI_ENABLE Then
		If $aExit = 1 Then;switching Auto-Exit function (disable/enable)
			$aExit = 0
		Else
			$aExit = 1
		EndIf
		AutoExitF()
		GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
	EndIf
	For $nr = 1 To $cds[0]
		If $msg = $BT_CD[$nr] Then
			$start = TimerInit()
			ButClck() ;in case when we click Open/Close button
			GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
		ElseIf $msg = $CB_aOp[$nr] Then
			If $aOpen[$nr] = 1 Then
				$aOpen[$nr] = 0
			Else
				$aOpen[$nr] = 1
			EndIf
			AutoOpenF()
			GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
		ElseIf $msg = $CB_aCl[$nr] Then
			If $aClose[$nr] = 1 Then
				$aClose[$nr] = 0
			Else
				$aClose[$nr] = 1
			EndIf
			AutoCloseF()
			GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
		EndIf
	Next
	If $msg = $CB_lng Then;when we wanna change the language
		$start = TimerInit()
		$chsnLng = IniRead(@ScriptDir & "\CDTray.ini", "Lang", GUICtrlRead($CB_lng), "CDTray.english.lng")
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "CurrLangFile", $chsnLng)
		$lngFile = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "CurrLangFile", "CDTray.english.lng")
		$lngFile = @ScriptDir & "\" & $lngFile
		$lngRdSect = IniReadSectionNames($lngFile)
		$lng = $lngRdSect[1]
		ReadLang()
		RefreshGUI() ;we don't need to restart the program, result of switching language is immediate
	EndIf
	
	If $msg = $LB_edlng Then;you wanna localize program in your own language?_
		$start = TimerInit() ;_Don't forget to save it As... CDTray.YourLanguage.lng in @ScriptDir and name the section with short name (FR, DE, IT & so on...)
		Run("notepad.exe " & $lngFile)
		GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
	EndIf
	
	If $msg = $monter Then;you'll see About info
		$start = TimerInit()
		$about = GUICreate($tipAbt & ":", 200, 80, -1, -1, -1, -1, $CDTray)
		GUISetBkColor(0xADC5C5)
		$au_w3 = GUICtrlCreateLabel("CDTray forum article", 28, 36)
		GUICtrlSetFont(-1, 9, 400, 4, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x0000FF)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, "http://www.autoitscript.com/forum/index.php?showtopic=16588")
		$mtr_w3 = GUICtrlCreateLabel("monter.FM", 28, 58)
		GUICtrlSetFont(-1, 9, 400, 4, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x0000FF)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, "                ")
		$BT_abt = GUICtrlCreateButton("OK", 148, 49, 28, 22)
		;MsgBox(64, $tipAbt & " CDTray:","CDTray ver. " & $cdtv & "  (" & $proDate & ")" & @CRLF & "Build with AutoIt ver. 3.1.1.83" & @CRLF & $au_w3 & @CRLF & $mtr_w3, 5)
		GUICtrlCreateLabel("CDTray ver. " & $cdtv & "  (" & $proDate & ")" & @CRLF & "Build with AutoIt ver. 3.1.1.83", 28, 4, 172, 24)
		GUISetState()
		
		While 1
			$msg = GUIGetMsg()
			
			If $msg = $GUI_EVENT_CLOSE Or $msg = $BT_abt Or $czas <= 1 Then
				$start = TimerInit()
				GUIDelete($about)
				GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
				GUICtrlSetTip($monter, $tipAbt)
				ExitLoop
			EndIf
			
			If $msg = $au_w3 Then _Start("http://www.autoitscript.com/forum/index.php?showtopic=16588")
			If $msg = $mtr_w3 Then _Start("                ")
			
		WEnd
		
	EndIf
	
WEnd
Exit

Func PozCzas() ;final countdown...
	$koniec = TimerDiff($start)
	$czas = Abs(Int((- ($sek * 1000) - 1000 + $koniec) / 1000))
	GUICtrlSetData($kon, $czas)
	If $czas >= 4 Then
		GUICtrlSetBkColor($kon, 0xE3FFFE)
	Else
		GUICtrlSetBkColor($kon, 0xFFCBB7)
	EndIf
	If $koniec > $sek * 1000 Then
		Koniec()
		Exit
	EndIf
EndFunc   ;==>PozCzas

Func AutoExitF()
	If $aExit = 0 Then
		GUICtrlSetState($CB_aX, $GUI_UNCHECKED)
		GUICtrlSetState($LB_aX2, $GUI_HIDE)
		GUICtrlSetState($LB_aX3, $GUI_HIDE)
		GUICtrlSetState($kon, $GUI_HIDE)
		AdlibDisable()
	Else
		GUICtrlSetState($CB_aX, $GUI_CHECKED)
		GUICtrlSetState($LB_aX2, $GUI_SHOW)
		GUICtrlSetState($LB_aX3, $GUI_SHOW)
		GUICtrlSetState($kon, $GUI_SHOW)
		$start = TimerInit()
		AdlibEnable("PozCzas")
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "AutoExit", $aExit)
EndFunc   ;==>AutoExitF

Func AutoOpenF()
	If $aOpen[$nr] = 0 Then
		GUICtrlSetState($CB_aOp[$nr], $GUI_UNCHECKED)
	Else
		GUICtrlSetState($CB_aOp[$nr], $GUI_CHECKED)
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoOpen", $aOpen[$nr])
	$start = TimerInit()
EndFunc   ;==>AutoOpenF

Func AutoCloseF()
	If $aClose[$nr] = 0 Then
		GUICtrlSetState($CB_aCl[$nr], $GUI_UNCHECKED)
	Else
		GUICtrlSetState($CB_aCl[$nr], $GUI_CHECKED)
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoClose", $aClose[$nr])
	$start = TimerInit()
EndFunc   ;==>AutoCloseF

Func ButClck()
	If GUICtrlGetState($ustCzas) = $GUI_ENABLE + $GUI_SHOW Then
		GUICtrlSetState($ustCzas, $GUI_HIDE)
		GUICtrlSetState($zmCzas, $GUI_HIDE)
		GUICtrlSetState($updn, $GUI_HIDE)
		GUICtrlSetState($kon, $GUI_SHOW)
		GUICtrlSetState($LB_aX3, $GUI_SHOW)
		AdlibEnable("PozCzas")
	EndIf
	Select
		Case $stan[$nr] = "closed"
			$staTxt = $stOpen & " [" & $cds[$nr] & "] ..."
			$opcl = "open"
			$stanIni = "opened"
			$stat_Bt[$nr] = $btClose
		Case Else
			$staTxt = $stClose & " [" & $cds[$nr] & "] ..."
			$opcl = "close"
			$stanIni = "closed"
			$stat_Bt[$nr] = $btOpen
	EndSelect
	GUICtrlSetData($status, $staTxt)
	GUICtrlSetBkColor($status, 0xF9E8A5)
	CDTray($cds[$nr], $opcl)
	$start = TimerInit()
	IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", $stanIni)
	GUICtrlSetData($status, "")
	GUICtrlSetBkColor($status, 0xADC5C5)
	$stan[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "Unknown")
	GUICtrlSetData($BT_CD[$nr], $stat_Bt[$nr])
	GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
EndFunc   ;==>ButClck

Func OpcjaCzas()
	AdlibDisable()
	GUICtrlSetState($CB_lng, $GUI_DISABLE)
	GUICtrlSetState($LB_edlng, $GUI_DISABLE)
	GUICtrlSetState($kon, $GUI_HIDE)
	GUICtrlSetState($LB_aX3, $GUI_HIDE)
	GUICtrlSetState($zmCzas, $GUI_SHOW)
	GUICtrlSetState($updn, $GUI_SHOW)
	GUICtrlSetState($ustCzas, $GUI_SHOW + $GUI_DEFBUTTON)
	
EndFunc   ;==>OpcjaCzas

Func UstawCzas()
	$sek = GUICtrlRead($zmCzas)
	Select
		Case $sek < 6
			$sek = 6
		Case $sek > 90
			$sek = 90
	EndSelect
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", $sek)
	GUICtrlSetState($zmCzas, $GUI_HIDE)
	GUICtrlSetState($updn, $GUI_HIDE)
	GUICtrlSetState($ustCzas, $GUI_HIDE)
	GUICtrlSetState($kon, $GUI_SHOW)
	GUICtrlSetState($LB_aX3, $GUI_SHOW)
	GUICtrlSetState($CB_lng, $GUI_ENABLE)
	GUICtrlSetState($LB_edlng, $GUI_ENABLE)
	AutoExitF()
	GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
EndFunc   ;==>UstawCzas

Func ReadLang()
	$srchFLng = FileFindFirstFile(@ScriptDir & "\CDTray.*.lng")
	If $srchFLng = -1 Then
		MsgBox(48, "Error", "No language files found. Restart the program.")
		MakeLang()
		Exit
	EndIf
	
	While 1
		$srchLng = FileFindNextFile($srchFLng) ;we're searching new language files (to find your own one)
		If @error Then ExitLoop
		$sLng = IniReadSectionNames(@ScriptDir & "\" & $srchLng)
		IniWrite(@ScriptDir & "\CDTray.ini", "Lang", $sLng[1], $srchLng)
		GUICtrlSetData($CB_lng, $sLng[1], $lng)
	WEnd
	
	$dLng = IniReadSection(@ScriptDir & "\CDTray.ini", "Lang")
	If @error Then
		MsgBox(48, "Error", "Error occured, probably no INI file.")
	Else
		For $i = 1 To $dLng[0][0]
			If Not FileExists(@ScriptDir & "\" & $dLng[$i][1]) Then
				IniDelete(@ScriptDir & "\CDTray.ini", "Lang", $dLng[$i][0])
				$lng = "EN"
			EndIf
		Next
	EndIf
	
	Global $btOpen = IniRead($lngFile, $lng, "ButtonOpen", "Lang err.")
	Global $btClose = IniRead($lngFile, $lng, "ButtonClose", "Lang err.")
	Global $stOpen = IniRead($lngFile, $lng, "StatOpen", "Lang err.")
	Global $stClose = IniRead($lngFile, $lng, "StatClose", "Lang err.")
	Global $btSet = IniRead($lngFile, $lng, "ButtonSet", "Lang err.")
	Global $aX = IniRead($lngFile, $lng, "AutoExit", "Lang err.")
	Global $aX2 = IniRead($lngFile, $lng, "AutoExit2", "Lng")
	Global $aX3 = IniRead($lngFile, $lng, "AutoExit3", "err.")
	Global $aOp = IniRead($lngFile, $lng, "AutoOpen", "Lang err.")
	Global $aCl = IniRead($lngFile, $lng, "AutoClose", "Lang err.")
	Global $tipdrv = IniRead($lngFile, $lng, "DrvNameTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipsec = IniRead($lngFile, $lng, "SetSecTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipaEx = IniRead($lngFile, $lng, "AutoExitTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipaOp = IniRead($lngFile, $lng, "AutoOpenTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipaCl = IniRead($lngFile, $lng, "AutoCloseTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipLng = IniRead($lngFile, $lng, "ChooseLangTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipedLng = IniRead($lngFile, $lng, "EditLangTip", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	Global $tipAbt = IniRead($lngFile, $lng, "About", "Lang err.: Please delete file CDTray.[YourLanguage].lng and restart program.")
	
EndFunc   ;==>ReadLang

Func RefreshGUI()
	For $nr = 1 To $cds[0]
		If $stan[$nr] = "closed" Then
			$stat_Bt[$nr] = $btOpen
		Else
			$stat_Bt[$nr] = $btClose
		EndIf
		GUICtrlSetTip($ED_CD[$nr], $tipdrv)
		GUICtrlSetData($CB_aOp[$nr], $aOp)
		GUICtrlSetTip($CB_aOp[$nr], $tipaOp)
		GUICtrlSetData($CB_aCl[$nr], $aCl)
		GUICtrlSetTip($CB_aCl[$nr], $tipaCl)
		GUICtrlSetData($BT_CD[$nr], $stat_Bt[$nr])
	Next
	GUICtrlSetData($ustCzas, $btSet)
	GUICtrlSetData($CB_aX, $aX)
	GUICtrlSetData($LB_aX2, $aX2)
	GUICtrlSetData($LB_aX3, $aX3)
	GUICtrlSetData($CB_lng, $lng)
	GUICtrlSetTip($CB_aX, $tipaEx)
	GUICtrlSetTip($kon, $tipsec)
	GUICtrlSetTip($CB_lng, $tipLng)
	GUICtrlSetTip($LB_edlng, $tipedLng)
	GUICtrlSetTip($monter, $tipAbt)
	GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
EndFunc   ;==>RefreshGUI

Func MakeIni()
	If StringInStr("0415", @OSLang) Then
		$lang = "polski"
	Else
		$lang = "english"
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "v", $cdtv)
	If IsDeclared("sek") Then
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", $sek)
	Else
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", "30")
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "CurrLangFile", "CDTray." & $lang & ".lng")
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "AutoExit", "1")
	IniWrite(@ScriptDir & "\CDTray.ini", "Lang", "EN", "CDTray.english.lng")
	IniWrite(@ScriptDir & "\CDTray.ini", "Lang", "PL", "CDTray.polski.lng")
	For $nr = 1 To $cds[0]
		If IsDeclared("nazwa[$nr]") Or $nazwa[$nr] <> "CD" & $nr Then
			IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], $nazwa[$nr])
		Else
			IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr)
		EndIf
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "closed")
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoOpen", "0")
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "AutoClose", "1")
	Next
EndFunc   ;==>MakeIni

Func MakeLang()
	$lngFile = "CDTray.english.lng"
	$lngFile = @ScriptDir & "\" & $lngFile
	$lng = "EN"
	$btOpen = "Open"
	$btClose = "Close"
	$stOpen = "Opening"
	$stClose = "Closing"
	$btSet = "Set"
	$aX = "Auto-e&xit"
	$aX2 = "in"
	$aX3 = "sec."
	$aOp = "open"
	$aCl = "close"
	$tipdrv = "You can edit the name of this drive."
	$tipsec = "Change auto-exit delay (6-90 sec.)"
	$tipaEx = "Checked 'Auto-exit' exits the program automatically after defined delay."
	$tipaOp = "Checked 'Auto-open' opens the tray of this drive by launching program."
	$tipaCl = "Checked 'Auto-close' closes the tray of this drive during exiting program."
	$tipLng = "Choose language"
	$tipedLng = "Edit current language file"
	$tipAbt = "About"
	
	$lFl = FileOpen($lngFile, 2)
	FileWriteLine($lFl, "#cs" & @CRLF & "Author: monter.FM" & @CRLF & "CDTray ver." & $cdtv & @CRLF & "Description: Search for CD drive type and allows you to open/close drive tray." & @CRLF & "Language File: You can make localization language file by yourself, according to this file." & @CRLF & "AutoItVer: 3.1.1.83" & @CRLF & "AutoItForum: http://www.autoitscript.com/forum/index.php?showtopic=16588" & @CRLF & "#ce")
	FileClose($lFl)
	For $i = 1 To 2
		IniWrite($lngFile, $lng, "ButtonOpen", $btOpen)
		IniWrite($lngFile, $lng, "ButtonClose", $btClose)
		IniWrite($lngFile, $lng, "StatOpen", $stOpen)
		IniWrite($lngFile, $lng, "StatClose", $stClose)
		IniWrite($lngFile, $lng, "ButtonSet", $btSet)
		IniWrite($lngFile, $lng, "AutoExit", $aX)
		IniWrite($lngFile, $lng, "AutoExit2", $aX2)
		IniWrite($lngFile, $lng, "AutoExit3", $aX3)
		IniWrite($lngFile, $lng, "AutoOpen", $aOp)
		IniWrite($lngFile, $lng, "AutoClose", $aCl)
		IniWrite($lngFile, $lng, "DrvNameTip", $tipdrv)
		IniWrite($lngFile, $lng, "SetSecTip", $tipsec)
		IniWrite($lngFile, $lng, "AutoExitTip", $tipaEx)
		IniWrite($lngFile, $lng, "AutoOpenTip", $tipaOp)
		IniWrite($lngFile, $lng, "AutoCloseTip", $tipaCl)
		IniWrite($lngFile, $lng, "ChooseLangTip", $tipLng)
		IniWrite($lngFile, $lng, "EditLangTip", $tipedLng)
		IniWrite($lngFile, $lng, "About", $tipAbt)
		$lngFile = "CDTray.polski.lng"
		$lng = "PL"
		$btOpen = "Otwórz"
		$btClose = "Zamknij"
		$stOpen = "Otwieram"
		$stClose = "Zamykam"
		$btSet = "Ustaw"
		$aX = "Autoza&koñ."
		$aX2 = "za"
		$aX3 = "s"
		$aOp = "otwier."
		$aCl = "zamyk."
		$tipdrv = "Mo¿esz zmieniæ nazwê tego napêdu."
		$tipsec = "Zmieñ czas autozakoñczenia (6-90 s)"
		$tipaEx = "Zaptaszkowane 'Autozakoñczenie' koñczy pracê programu po podanym czasie."
		$tipaOp = "Zaptaszkowane 'Auto-otwieranie' powoduje wysuniêcie tacki tego napêdu po otwarciu programu."
		$tipaCl = "Zaptaszkowane 'Auto-zamykanie' zamyka tackê tego napêdu podczas koñczenia programu."
		$tipLng = "Wybierz jêzyk"
		$tipedLng = "Edytuj bie¿¹cy plik jêzykowy"
		$tipAbt = "O programie"
	Next
	
EndFunc   ;==>MakeLang

Func _Start($s_StartPath) ;stolen from Rob Saunders' script
	$start = TimerInit()
	If @OSTYPE = 'WIN32_NT' Then
		$s_StartStr = @ComSpec & ' /c start "" '
	Else
		$s_StartStr = @ComSpec & ' /c start '
	EndIf
	Run($s_StartStr & $s_StartPath, '', @SW_HIDE)
EndFunc   ;==>_Start

Func Koniec() ;in a moment CDTray will quit
	If GUICtrlGetState($ustCzas) = $GUI_ENABLE + $GUI_SHOW Then
		GUICtrlSetState($ustCzas, $GUI_HIDE)
		GUICtrlSetState($zmCzas, $GUI_HIDE)
		GUICtrlSetState($updn, $GUI_HIDE)
		AdlibEnable("PozCzas")
	EndIf
	For $nr = 1 To $cds[0]
		$zmieNaz[$nr] = GUICtrlRead($ED_CD[$nr])
		If $aClose[$nr] = 1 Then
			$staTxt = $stClose & " [" & $cds[$nr] & "] ..."
			$opcl = "close"
			$stanIni = "closed"
			GUICtrlSetData($status, $staTxt)
			GUICtrlSetBkColor($status, 0xF9E8A5)
			CDTray($cds[$nr], $opcl)
			IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", $stanIni)
		EndIf
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], $zmieNaz[$nr])
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "v", $cdtv)
	Next
	If FileExists(@TempDir & "\monter.FM.gif") Then;cleaning @TempDir (size does matter, even 468 bytes :-))
		FileDelete(@TempDir & "\monter.FM.gif")
	EndIf
EndFunc   ;==>Koniec
