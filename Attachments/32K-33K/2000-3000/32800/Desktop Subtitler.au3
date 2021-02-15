#include <File.au3>
#include <WindowsConstants.au3>

HotKeySet("{END}", "Nazad")
HotKeySet("{PGDN}", "Napred")
HotKeySet("{ESC}", "Izlaz")

Global $File, $Input, $Label1, $Label2
Local $Vreme, $GlobalnoVreme
$Sec = @SEC

$File = FileOpenDialog('Izaberi subtitl:', "", "srt (*.srt)", "")
If @error Then Exit

Local $Spisak[5000]
_FileReadToArray($File, $Spisak)
Dim $Niz[15000][3]
For $i = 1 To $Spisak[0]
	If StringInStr($Spisak[$i], '-->') Then
		$Niz[$i][0] = StringLeft($Spisak[$i], 8)
		$Niz[$i][1] = $Spisak[$i + 1]
		$Niz[$i][2] = $Spisak[$i + 2]
	EndIf
Next

$Form1 = GUICreate("Desktop Subtitler", @DesktopWidth, 110, 0, @DesktopHeight - 120, $WS_POPUP)
GUISetBkColor(0x000000)
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
$Label1 = GUICtrlCreateLabel('', 100, 0, 800, 42, 1)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFF00)
$Label2 = GUICtrlCreateLabel('', 100, 46, 800, 42, 1)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFF00)
GUISetState(@SW_SHOW)

While 1
	If $Sec <> @SEC Then
		For $i = 1 To $Spisak[0]
			If $Niz[$i][0] = $GlobalnoVreme Then
				GUICtrlSetData($Label1, $Niz[$i][1])
				GUICtrlSetData($Label2, $Niz[$i][2])
				AdlibEnable('Ocisti', 3500)
			EndIf
		Next
		_Vreme()
		$Sec = @SEC
	EndIf
WEnd

Func Ocisti()
	GUICtrlSetData($Label1, '')
	GUICtrlSetData($Label2, '')
	AdlibDisable()
EndFunc   ;==>Ocisti

Func Nazad()
	$Vreme = $Vreme - 10
	_Vreme()
EndFunc   ;==>Nazad

Func Napred()
	$Vreme = $Vreme + 10
	_Vreme()
EndFunc   ;==>Napred

Func _Vreme()
	$Vreme += 1
	$GlobalnoVreme = StringFormat("%.02d" & ":" & "%.02d" & ":" & "%.02d", _
	Mod($Vreme / 3600, 24), Mod(($Vreme / 60), 60), Mod($Vreme, 60))
	WinSetOnTop($Form1, "", 1)
EndFunc   ;==>_Vreme

Func Izlaz()
	Exit
EndFunc   ;==>Napred

Func __StringBetween($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>__StringBetween

Func WM_NCHITTEST($hwnd, $Msg, $wParam, $lParam)
	Local $iProc
	$iProc = DllCall("user32.dll", "int", "DefWindowProc", "hwnd", $hwnd, "int", $Msg, "wparam", $wParam, "lparam", $lParam)
	$iProc = $iProc[0]
	If $iProc = $HTCLIENT Then Return $HTCAPTION
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NCHITTEST
