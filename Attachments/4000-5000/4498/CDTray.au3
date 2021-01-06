#NoTrayIcon
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_DEFBUTTON = 512
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_FOCUS = 256

$cds = DriveGetDrive("CDROM")
Dim $stan[1 + $cds[0]], $nazwa[1 + $cds[0]], $LBL_CD[1 + $cds[0]], $BT_CD[1 + $cds[0]], $ED_CD[1 + $cds[0]], $stat_Bt[1 + $cds[0]], $zmieNaz[1 + $cds[0]], $kon;, $ustCzas, $zmCzas, $updn

If @Compiled Then
	$cdtv = StringFormat("%.2f", FileGetVersion(@ScriptName))
Else
	$cdtv = "1.10"
EndIf
If Not @error Then
	If Not FileExists(@ScriptDir & "\CDTray.ini") Then
		MakeIni()
	ElseIf Int(IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "v", "0") * 10) < Int($cdtv * 10) Then
		For $nr = 1 To $cds[0]
			$nazwa[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr)
			If StringLen($nazwa[$nr]) = 0 Then
				$nazwa[$nr] = "CD" & $nr
			EndIf
		Next
		IniDelete(@ScriptDir & "\CDTray.ini", "Txt", "TTip")
		FileDelete(@ScriptDir & "\CDTray.ini")
		MakeIni()
	EndIf
	For $nr = 1 To $cds[0]
		$stan[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "Unknown")
		$nazwa[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr)
		If StringLen($nazwa[$nr]) = 0 Then
			$nazwa[$nr] = "CD" & $nr
		EndIf
	Next
	$sek = IniRead(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", "30")
	$btOpen = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "ButtonOpen", "INI error")
	$btClose = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "ButtonClose", "INI error")
	$stOpen = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "StatOpen", "INI error")
	$stClose = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "StatClose", "INI error")
	$btSet = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "ButtonSet", "INI error")
	$tipdrv = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "DrvNameTip", "INI error: Please delete file CDTray.ini and restart program.")
	$tipsec = IniRead(@ScriptDir & "\CDTray.ini", "Txt", "SetSecTip", "INI error")
EndIf
$top = 32

$cdtray = GUICreate("CDTray " & $cdtv, 184, 36+ ($cds[0] * $top))
GUISetBkColor(0xC0CFD3)

For $nr = 1 To $cds[0]
	If $stan[$nr] = "closed" Then
		$stat_Bt[$nr] = $btOpen
	Else
		$stat_Bt[$nr] = $btClose
	EndIf
	$LBL_CD[$nr] = GUICtrlCreateLabel("[" & $cds[$nr] & "]", 4, -20+ ($nr * $top))
	$ED_CD[$nr] = GUICtrlCreateInput($nazwa[$nr], 24, -22+ ($nr * $top), 97, 21)
	GUICtrlSetTip(-1, $tipdrv)
	GUICtrlSetBkColor($ED_CD[$nr], 0xE0EFF3)
	$BT_CD[$nr] = GUICtrlCreateButton($stat_Bt[$nr], 128, -24+ ($nr * $top), 51, 25)
Next
GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
$mtrTxt = GUICtrlCreateLabel("monter.FM  2005", 98, 21+ ($cds[0] * $top), 80, 13)
$czas = $sek
$kongrp = GUICtrlCreateGroup("", 1, 13+ ($cds[0] * $top), 17, 23)
$kon = GUICtrlCreateLabel($czas, 3, 21+ ($cds[0] * $top), 12, 12, 0x01)
GUICtrlSetBkColor(-1, 0xE0EFF3)
$LB_kon = GUICtrlSetTip($kon, $tipsec)
$start = TimerInit()
$status = GUICtrlCreateLabel("", 36, 2+ ($cds[0] * $top), 80, 14)
$zmCzas = GUICtrlCreateInput($sek, 1, 19+ ($cds[0] * $top), 37, 17)
GUICtrlSetLimit(-1, 2)
GUICtrlSetState($zmCzas, $GUI_HIDE)
$updn = GUICtrlCreateUpdown($zmCzas)
GUICtrlSetLimit(-1, 90, 8)
GUICtrlSetState($updn, $GUI_HIDE)
$ustCzas = GUICtrlCreateButton($btSet, 40, 19+ ($cds[0] * $top), -1, 17)
GUICtrlSetState($ustCzas, $GUI_HIDE)

GUISetState(@SW_SHOW)
AdlibEnable("PozCzas")

While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then
		Koniec()
		Exit
	EndIf
	If $msg = $kon Then
		UstawCzas()
	EndIf
	If $msg = $ustCzas Then
		$sek = GUICtrlRead($zmCzas)
		Select
			Case $sek < 8
				$sek = 8
			Case $sek > 90
				$sek = 90
		EndSelect
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", $sek)
		GUICtrlSetState($zmCzas, $GUI_HIDE)
		GUICtrlSetState($updn, $GUI_HIDE)
		GUICtrlSetState($ustCzas, $GUI_HIDE)
		$start = TimerInit()
		AdlibEnable("PozCzas", 500)
		GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
	EndIf
	
	For $nr = 1 To $cds[0]
		If $msg = $BT_CD[$nr] Then
			$start = TimerInit()
			ButClck()
		EndIf
	Next
WEnd
Exit

Func PozCzas()
	$koniec = TimerDiff($start)
	$czas = Abs(Int((- ($sek * 1000) - 1000 + $koniec) / 1000))
	GUICtrlSetData($kon, $czas)
	If $czas >= 4 Then
		GUICtrlSetBkColor($kon, 0xE0EFF3)
	Else
		GUICtrlSetBkColor($kon, 0xFFBCB0)
	EndIf
	If $koniec > $sek * 1000 Then
		Koniec()
		Exit
	EndIf
EndFunc   ;==>PozCzas

Func ButClck()
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
	CDTray($cds[$nr], $opcl)
	$start = TimerInit()
	IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", $stanIni)
	GUICtrlSetData($status, "")
	$stan[$nr] = IniRead(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "Unknown")
	GUICtrlSetData($BT_CD[$nr], $stat_Bt[$nr])
	GUICtrlSetState($BT_CD[1], $GUI_FOCUS)
EndFunc   ;==>ButClck

Func UstawCzas()
	AdlibDisable()
	GUICtrlSetState($zmCzas, $GUI_SHOW)
	GUICtrlSetState($updn, $GUI_SHOW)
	GUICtrlSetState($ustCzas, $GUI_SHOW + $GUI_DEFBUTTON)
EndFunc   ;==>UstawCzas

Func MakeIni()
	If StringInStr("0415", @OSLang) Then
		$btOpen = "Otwórz"
		$btClose = "Zamknij"
		$stOpen = "Otwieram"
		$stClose = "Zamykam"
		$tipdrv = "Tu mo¿esz zmieniæ nazwê napêdu."
		$tipsec = "Zmieñ czas autozamykania (8-90 s)"
		$btSet = "Ustaw"
	Else
		$btOpen = "Open"
		$btClose = "Close"
		$stOpen = "Opening"
		$stClose = "Closing"
		$tipdrv = "You can edit the drive name here."
		$tipsec = "Change auto-exit delay (8-90 sec.)"
		$btSet = "Set"
	EndIf
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "v", $cdtv)
	IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "SecsToExit", "30")
	For $nr = 1 To $cds[0]
		If IsDeclared("nazwa[$nr]") Or $nazwa[$nr] <> "CD" & $nr Then
			IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], $nazwa[$nr])
		Else
			IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], "CD" & $nr)
		EndIf
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", "closed")
	Next
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "ButtonOpen", $btOpen)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "ButtonClose", $btClose)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "StatOpen", $stOpen)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "StatClose", $stClose)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "ButtonSet", $btSet)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "DrvNameTip", $tipdrv)
	IniWrite(@ScriptDir & "\CDTray.ini", "Txt", "SetSecTip", $tipsec)
EndFunc   ;==>MakeIni

Func Koniec()
	For $nr = 1 To $cds[0]
		$zmieNaz[$nr] = GUICtrlRead($ED_CD[$nr])
		$staTxt = $stClose & " [" & $cds[$nr] & "] ..."
		$opcl = "close"
		$stanIni = "closed"
		GUICtrlSetData($status, $staTxt)
		CDTray($cds[$nr], $opcl)
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, "Status", $stanIni)
		IniWrite(@ScriptDir & "\CDTray.ini", "CD" & $nr, $cds[$nr], $zmieNaz[$nr])
		IniWrite(@ScriptDir & "\CDTray.ini", "CDTray", "v", $cdtv)
	Next
	
EndFunc   ;==>Koniec
