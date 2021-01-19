#include<GUIConstants.au3>
#include<Misc.au3>
#include<File.au3>
$opt = 0
Global $LCC = 0
Global $cNum = 1
Dim $menuitems[20][4]
$M_height=@DesktopHeight+4
$M_width=@DesktopWidth+4
$gui = GUICreate("OS", $M_width, $M_height, -1, -1)
$bk=GUICtrlCreatePic(@WindowsDir&"\Web\Wallpaper\Stonehenge.jpg" , -2 , -2 , $M_width,$M_height)
GUICtrlSetState($bk , $GUI_DISABLE)
$start = GUICtrlCreateButton("Start", 0, $M_height - 25, 60, 25, $BS_FLAT)
$sbar = GUICtrlCreateLabel("", 60, $M_height - 25, $M_width - 120, 30)

$time = GUICtrlCreateLabel("", $M_width - 60, $M_height - 25, 60, 25, $BS_CENTER)
GUICtrlSetBkColor($time, 0xc3c3c3)
GUICtrlSetBkColor($sbar, 0xc3c3c3)
GUISetState()
AdlibEnable("time", 1000)
$xpos = 0
$ypos = 0
$plus = 20
Dim $db[100][100]
Dim $db1[100][100]

Dim $over[100][2]
$arr = _FileListToArray(@DesktopDir)
$iPath = @DesktopDir
$Sch = _FileListToArray($iPath, "*", 1)
$menu=GUICtrlCreateContextMenu(-1)
$cbk=GUICtrlCreateMenuItem("Change Background" ,$menu)
$ccl=GUICtrlCreateMenuItem("Change Icon text" , $menu)
$yplus=20

For $i = 1 To $Sch[0]
	$db[$xpos][$ypos] = GUICtrlCreateButton($Sch[$i], $plus + $xpos * 70, $yplus+$ypos * 80, 35, 35, $BS_ICON + $BS_FLAT)
	If StringInStr(FileGetAttrib($iPath & "\" & $Sch[$i]), "D") Then
		GUICtrlSetImage($db[$xpos][$ypos], "shell32.dll", -4)
	ElseIf StringRight($Sch[$i], 4) = ".exe" Then
		If GUICtrlSetImage($db[$xpos][$ypos], $iPath & "\" & $Sch[$i], 0) = 0 Then
			GUICtrlSetImage($db[$xpos][$ypos], "shell32.dll", -3)
		Else
			GUICtrlSetImage($db[$xpos][$ypos], $iPath & "\" & $Sch[$i], 0)
		EndIf
	Else
		Local $szIconFile = $iPath & "\" & $Sch[$i], $nIcon = 0
		FileGetIcon($szIconFile, $nIcon, $Sch[$i])
		If $nIcon <> 0 Then $nIcon = -$nIcon
		GUICtrlSetImage($db[$xpos][$ypos], $szIconFile, $nIcon)
	EndIf

	$over[$i][0] = $db[$xpos][$ypos]
	$xpos += 1
	If $xpos = 9 Then
		$ypos += 1
		$xpos = 0
	EndIf
Next
$xpos = 0
$ypos = 0
$plus = 20
For $i = 1 To $Sch[0]
	$db1[$xpos][$ypos] = GUICtrlCreateLabel(StringTrimRight($Sch[$i], 4), $plus + $xpos * 70 - 10, $yplus+$ypos * 80 + 40, 60, 30, $BS_MULTILINE + $SS_CENTER, $WS_EX_TRANSPARENT)
	$over[$i][1] = $db1[$xpos][$ypos]
	GUICtrlSetBkColor($db1[$xpos][$ypos], $GUI_BKCOLOR_TRANSPARENT)
	$xpos += 1
	If $xpos = 9 Then
		$ypos += 1
		$xpos = 0
	EndIf
Next
While 1
	Sleep(1)
	$msg = GUIGetMsg()
	If WinActive($gui) Then
		Select
			Case $msg = $GUI_EVENT_CLOSE
				If (MsgBox(4, "Os", "Are you sure you want to exit?") = 6) Then Exit
			Case $msg >= $over[1][0] And $msg <= $over[$Sch[0]][0] + 1
				click($msg, $msg - $over[1][0] + 1)
			Case $msg = $start
				$cNum = 1
				If WinExists($opt) Then
					WinActivate($opt)
				Else
					$posz = WinGetPos($gui)
					$opt = GUICreate("", 150, 300, $posz[0] + 5, $posz[1] + $posz[3] - 325, $WS_POPUP + $WS_BORDER, $WS_EX_TOOLWINDOW)
					;create the menu
					menuadditem('Exit', @WindowsDir & "\system32\shell32.dll", 1, 28)
					menuadditem('Paint', @WindowsDir & "\system32\mspaint.exe", 'mspaint', 0)
					menuadditem('Notepad', @WindowsDir & "\notepad.exe", 'notepad')
					GUISetState()
				EndIf
			Case $msg = $cbk
				$file=FileOpenDialog("Choose Background Image" , @MyDocumentsDir,"Images (*.jpg;*.bmp;*.gif)",3)
				If FileExists($file) Then GUICtrlSetImage($bk , $file)
			Case $msg= $ccl
				$color=_ChooseColor(2)
				For $i=$over[0][1] To $over[$Sch[0]][1]
					GUICtrlSetColor($over[$i][1],$color)
				Next
		EndSelect
		$mpos1 = GUIGetCursorInfo($gui)
		$mpos = $mpos1
		If $mpos1[4] >= $over[1][0] And $mpos1[4] <= $over[$Sch[0]][0] + 1 Then
			While $mpos[2] = 1
				$mpos = GUIGetCursorInfo($gui)
				If $mpos[0] <> $mpos1[0] Or $mpos[1] <> $mpos1[1] Then
					$mpos1[0] = $mpos[0]
					$mpos1[1] = $mpos[1]
					GUICtrlSetPos($mpos1[4], $mpos[0] - 20, $mpos[1] - 25)
					GUICtrlSetPos($over[$Sch[0] - ($db1[0][0] - $mpos1[4]) + 1][1], $mpos[0] - 30, $mpos[1] + 15)
				EndIf
			WEnd
		EndIf
	ElseIf WinActive($opt) Then
		If $msg >= $menuitems[1][0] And $msg <= $menuitems[$cNum - 1][0] Then
			$index = $msg - $menuitems[1][0]
			If $menuitems[$index + 1][2] = 1 Then
				If (MsgBox(4, "Os", "Are you sure you want to exit?") = 6) Then Exit
			Else
				ShellExecute($menuitems[$index][2])
			EndIf
		EndIf
	EndIf
WEnd

Func time()
	GUICtrlSetData($time, @HOUR & ":" & @MIN & ":" & @SEC)
	If WinExists($opt) Then
		$mpos = MouseGetPos()
		$wpos = WinGetPos($opt)
		If $mpos[0] < $wpos[0] Then GUIDelete($opt)
		If $mpos[1] < $wpos[1] Then GUIDelete($opt)
		If $mpos[0] > $wpos[0] + $wpos[2] Then GUIDelete($opt)
		If $mpos[1] > $wpos[1] + $wpos[3] + 30 Then GUIDelete($opt)
	EndIf
EndFunc   ;==>time


Func FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile)
	Dim $szRegDefault = "", $szDefIcon = ""
	$szExt = StringMid($szFile, StringInStr($szFile, '.', 0, -1))
	If $szExt = '.lnk' Then
		$details = FileGetShortcut($szIconFile)
		$szIconFile = $details[0]
		$szExt = StringMid($details[0], StringInStr($details[0], '.', 0, -1))
	EndIf
	$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt, "ProgID")
	If $szRegDefault = "" Then $szRegDefault = RegRead("HKCR\" & $szExt, "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szDefIcon = "" Then $szRegDefault = RegRead("HKCR\" & $szRegDefault & "\CurVer", "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szRegDefault = "" Then $szRegDefault = RegEnumVal("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt & "\OpenWithProgids", 1)
	If $szDefIcon = "" Then
		$szIconFile = "shell32.dll"
	ElseIf $szDefIcon <> "%1" Then
		$arSplit = StringSplit($szDefIcon, ",")
		If IsArray($arSplit) Then
			$szIconFile = $arSplit[1]
			If $arSplit[0] > 1 Then $nIcon = $arSplit[2]
		Else
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc   ;==>FileGetIcon

Func click($control, $count)
	If $LCC <> $control Then
		Global $timer = TimerInit()
		$LCC = $control
	Else
		$LCC = 0
		If TimerDiff($timer) < 1000 Then
			ShellExecute(@DesktopDir & "\" & GUICtrlRead($over[$count][0]))
			$timer = TimerInit()
		EndIf
	EndIf
EndFunc   ;==>click
Func menuadditem($text, $icon, $shell = 1, $iconn = 0)
	$menuitems[$cNum][0] = GUICtrlCreateButton($text, 25, 300 - $cNum * 25, 125, 23, $BS_FLAT)
	If FileExists($icon) Then
		$menuitems[$cNum][1] = GUICtrlCreateIcon($icon, $iconn, 0, 300 - $cNum * 25, 23, 23)
		GUICtrlSetState($menuitems[$cNum][1], $GUI_DISABLE)
	EndIf
	
	$menuitems[$cNum][2] = $shell
	$cNum += 1
EndFunc   ;==>menuadditem

