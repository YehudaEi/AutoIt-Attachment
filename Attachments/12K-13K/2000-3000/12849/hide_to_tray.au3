#include <GUIConstants.au3>
Opt("WinTitleMatchMode", 4)
Opt("TrayMenuMode", 1)

Global $itemnum, $enum, $msg, $num, $proc, $gett, $gettif, $itemnum2, $recountt, $recount2, $bit, $state, $title, $exitc, $proclist, $upcount, $procupcount, $itemnum
Dim $trayitem1[100]
Dim $procitem[100]
Dim $trayrec[100]
Dim $proclist[100][2]

$execpath = @AutoItExe

$string1 = StringInStr($execpath, "\", 0, -1)
$string2 = StringTrimLeft($execpath, $string1)

$proclist = ProcessList($string2)
Do
	$upcount = $upcount + 1
	If $proclist[$upcount][0] = $string2 Then
		$procupcount = $procupcount + 1
	EndIf
Until $upcount = $proclist[0][0]

If $procupcount > 1 Then Exit

HotKeySet("{F11}", "hide")

$trayitem2 = TrayCreateItem("Exit")
TrayCreateItem("")

TraySetState()

TrayTip("Hide To Tray Hot Key", "Press F11 to hide active window.", 5)

Func hide()   ; <-- To hide active window
	$title = ""
	$proc = WinGetHandle("active", "")
	If $itemnum > 0 Then
		Do
			$state = WinGetState("active", "")
			If Not BitAND($state, 2) Then
				recount()
				Return
			EndIf
			$num = $num + 1
			If $procitem[$num] = $proc Then
				$gettif = TrayItemGetText($trayitem1[$num])
				;WinSetTitle($gettif & $procitem[$num], "", $gettif)
				TrayItemDelete($trayitem1[$num])
				$procitem[$num] = 0
			EndIf
		Until $num = $itemnum
	EndIf
	recount()
	$num = 0
	$title = WinGetTitle("active", "")
	If @error Or $title = 1 Or $title = "" Then
		Return
	EndIf
	$itemnum = $itemnum + 1
	;WinSetTitle("active", "", $title & $proc)
	WinSetState($proc, "", @SW_HIDE)
	$trayitem1[$itemnum] = TrayCreateItem($title)
	$procitem[$itemnum] = $proc
	$bit = $bit + 1
EndFunc  ; <-- Complete

Func restore() ; <-- Unhides window
	If $itemnum < 1 Then Return
	$itemnum2 = $itemnum
	Do
		Select
			Case $msg = $trayitem1[$itemnum2]
				$enum = $itemnum2
		EndSelect
		$itemnum2 = $itemnum2 - 1
	Until $itemnum2 = 0
	$gett = TrayItemGetText($trayitem1[$enum])
	WinSetState($procitem[$enum], "", @SW_SHOW)
	;WinSetTitle($gett & $procitem[$enum], "", $gett)
	TrayItemDelete($trayitem1[$enum])
	$procitem[$enum] = 0
	recount()
	Return
EndFunc

Func recount() ; <-- Removes and recalculates variable and tray menu text
	If $itemnum = 0 Then Return
	$recountt = 0
	$recount2 = 0
	$bit = 0
	Do
		$recountt = $recountt + 1
		$trayrec[$recountt] = TrayItemGetText($trayitem1[$recountt])
	Until $recountt = $itemnum
	$recountt = 0
	Do
		$recountt = $recountt + 1
		If $procitem[$recountt] <> 0 Then
			$bit = $bit + 1
		EndIf
	Until $recountt = $itemnum
	If $bit = 0 Then
		$itemnum = $bit
		Return
	EndIf
	$recountt = 0
	Do
		$recountt = $recountt + 1
		$recount2 = $recount2 + 1
		If $procitem[$recountt] = 0 Then
			$recount2 = $recount2 + 1
		EndIf
		If $recount2 < $itemnum Or $recount2 = $itemnum Then
			$procitem[$recountt] = $procitem[$recount2]
		EndIf
	Until $recount2 = $itemnum Or $recount2 > $itemnum
	$recountt = 0
	Do
		$recountt = $recountt + 1
		TrayItemDelete($trayitem1[$recountt])
	Until $recountt = $itemnum + 5
	$recountt = 0
	$recount2 = 0
	Do
		$recount2 = $recount2 + 1
		$recountt = $recountt + 1
		If $trayrec[$recountt] = "" Then
			$recount2 = $recount2 + 1
		EndIf
		If $recount2 < $itemnum Or $recount2 = $itemnum Then
			$trayitem1[$recountt] = TrayCreateItem($trayrec[$recount2])
		EndIf
	Until $recount2 = $itemnum Or $recount2 > $itemnum
	$itemnum = $bit
	Return
EndFunc

While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = $trayitem2
			Exit
	EndSelect
	If $msg > 0 Then Call("restore")
WEnd

Func OnAutoItExit() ; <-- Unhides all windows that have been hidden with this app on exit
	If $itemnum > 0 Then
		Do
			$exitc = $exitc + 1
			$gett = TrayItemGetText($trayitem1[$exitc])
			WinSetState($procitem[$exitc], "", @SW_SHOW)
			;WinSetTitle($procitem[$exitc], "", $gett)
		Until $exitc = $itemnum
	EndIf
EndFunc