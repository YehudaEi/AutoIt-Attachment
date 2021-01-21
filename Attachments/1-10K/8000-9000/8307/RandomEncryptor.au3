#include <Array.au3>
#include <Date.au3>
#include <String.au3>
#include <GUIConstants.au3>

GUICreate("Random Encryptor", 385, 417, 192, 125)
$Input1 = GUICtrlCreateEdit("Text to Encrypt", 8, 8, 369, 173, BitOr($ES_MULTILINE, $WS_VSCROLL, $ES_WANTRETURN), $WS_EX_CLIENTEDGE)
$Button1 = GUICtrlCreateButton("Encrypt", 88, 192, 81, 25)
$Button2 = GUICtrlCreateButton("Decrypt", 216, 192, 81, 25)
$Input2 = GUICtrlCreateEdit("Encryption to Decrypt", 8, 232, 369, 173, BitOr($ES_MULTILINE, $WS_VSCROLL), $WS_EX_CLIENTEDGE)
GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg == $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg == $Button1
		GUICtrlSetData($Input2, _Encrypt(GUICtrlRead($Input1)))
	Case $msg == $Button2
		GUICtrlSetData($input1, _Decrypt(GUICtrlRead($Input2)))
	Case Else
		Sleep(100)
	EndSelect
WEnd

Func _Encrypt($raw)
	$key = StringRight(_DateDiff("s", "1970/01/01 00:00:00", _NowCalc()), 8)
	$tickcount = DllCall ("kernel32.dll","long","GetTickCount")
	$key *= $tickcount[0]
	$key = Stringsplit($key, "")
	$sum = 0
	While $key[0] > 2
		$sum = 0
		For $i = 1 To $key[0]
			$sum += $key[$i]
		Next
		$key = StringSplit($sum, "")
	WEnd
	$key = StringFormat("%.2d", $sum)
	If StringLen($key) > 2 Then
		$key = StringRight($key, 2)
	EndIf
	$rand1 = Random(10000000, 99999999, 1)
	$rand2 = Random(1, 8, 1)
	$arrStr = StringSplit($raw, "")
	$encrypted = ""
	For $i = 1 To $arrStr[0]
		$t = Asc($arrStr[$i]) + $key
		$t = _StringReverse(StringFormat("%3s", $t))
		$encrypted &= $t
	Next
	$arrEnc = StringSplit($encrypted, "")
	_ArrayDelete($arrEnc, 0)
	$encrypted = StringLeft($key, 1) & $arrEnc[0] & StringRight($key, 1)
	For $i = 1 To UBound($arrEnc) - 1
		$encrypted &= $arrEnc[$i]
	Next
	$rand1 = StringSplit($rand1, "")
	$rand = $rand1[$rand2]
	$arrEnc = StringSplit($encrypted, "")
	_ArrayDelete($arrEnc, 0)
	$encrypted = $rand
	For $i = 0 To UBound($arrEnc) - 1
		$t = $arrEnc[$i] + $rand
		If $t > 9 Then
			$t -= 10
		EndIf
		$encrypted &= $t
	Next
	Return $encrypted
EndFunc

Func _Decrypt($enc)
	$r = StringLeft($enc, 1)
	$enc = StringTrimLeft($enc, 1)
	$arrEnc = StringSplit($enc, "")
	_ArrayDelete($arrEnc, 0)
	$enc = ""
	For $i = 0 To UBound($arrEnc) - 1
		$t = $arrEnc[$i] - $r
		If $t < 0 Then
			$t += 10
		EndIf
		$enc &= $t
	Next
	$arrEnc = StringSplit($enc, "")
	_ArrayDelete($arrEnc, 0)
	$enc = ""
	$key = ""
	$key &= $arrEnc[0] & $arrEnc[2]
	_ArrayDelete($arrEnc, 0)
	_ArrayDelete($arrEnc, 1)
	For $i = 0 To UBound($arrEnc) - 1
		$enc &= $arrEnc[$i]
	Next
	$raw = ""
	$block = ""
	$arrEnc = StringSplit($enc, "")
	$count = 0
	For $i = 1 To $arrEnc[0]
		$block &= $arrEnc[$i]
		If StringLen($block) == 3 Then
			$block = _StringReverse($block)
			$block -= $key
			$raw &= Chr($block)
			$block = ""
		EndIf
	Next
	Return $raw
EndFunc