#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <crypt.au3>
Global $ks[11], $key, $Actual_Key, $prekey, $preseed, $enteredkey, $keypart
$enteredkey = Decode(StringReplace(InputBox('Enter Key', 'Enter your serial key:' & @CRLF & @CRLF & 'For example:' & @CRLF & @CRLF & 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX', '', '', 275), '-', ''), 1)
$seed = StringMid($enteredkey, 1, 6)
$keypart = StringTrimRight($enteredkey, 4)

If StringMid(_Crypt_HashData($keypart & 'Test program v1.000', $CALG_SHA1), 3, 4) <> StringMid($enteredkey, 27, 4) Or StringLen($enteredkey) <> 30 Then
	MsgBox(0, 'Error', 'The key''s format is not valid or was typed incorrectly.')
	Exit
EndIf

$ks[1] = '2f9u24h9gg7j'
;~ $ks[2] = 'rgh76i433t'
$ks[3] = 'NUB%F$Wt6j9'
$ks[4] = 'asjU*&6e3s'
$ks[5] = 'll[064e23FFj'
;~ $ks[6] = 'JKo74532E£""7'
$ks[7] = 'Jh897%$bfeyu7)('
$ks[8] = ')8yrgT4R$%[HI'
$ks[9] = 'G57^sd&90=kl%'
;~ $ks[10] = '{--08ygb2a=-l<j4'

For $a = 1 To 10
	$b = $a
	If $b > 6 Then $b -= 6

	Switch $a
		Case 1
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
;~ 		Case 2
;~ 			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 3
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 4
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 5
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
;~ 		Case 6
;~ 			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 7
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 8
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
		Case 9
			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
;~ 		Case 10
;~ 			$ks[$a] = StringMid(_Crypt_HashData($ks[$a] & StringMid($seed, $b, 1), $CALG_SHA1), 3, 2)
	EndSwitch

Next
$section = StringTrimLeft($keypart, 6)

$count = 0
For $a = 1 To 20 Step 2
	$count += 1
	ConsoleWrite($ks[$count] & ' ' & StringMid($section, $a, 2) & @CRLF)
	If $ks[$count] <> '' And $ks[$count] <> StringMid($section, $a, 2) Then
		MsgBox(0, 'Fabricated Key!', 'This key is an invalid fake')
		Exit
	EndIf
Next

If StringMid(_Crypt_HashData($keypart & 'Test program v1.000', $CALG_SHA1), 3, 4) = StringMid($enteredkey, 27, 4) Then

	MsgBox(0, 'Success!', 'This key is a valid and authentic key!')

EndIf

Func RawEncode($input = '', $mode = 0)
	Local $list[27], $num, $result
	For $a = 0 To 25
		$list[$a] = Chr(65 + $a)
	Next
	$num = Asc($input)
	If $mode Then $num = Number('0x' & $input)
	$r = Floor(($num / 26))
	If $num < 26 Then
		$result = 'A' & $list[$num]
	Else
		$result = $list[$r]
		$num -= (26 * $r)
		$result &= $list[$num]
	EndIf
	Return $result
EndFunc   ;==>RawEncode

Func RawDecode($input = '', $mode = 0)
	Local $list[27], $num[3], $num, $result
	For $a = 0 To 25
		$list[$a] = Chr(65 + $a)
	Next
	$num[1] = StringMid($input, 1, 1)
	$num[2] = StringMid($input, 2, 1)
	For $a = 1 To 2
		For $b = 0 To 25
			$location = StringInStr($list[$b], $num[$a])
			If $location Then
				If $a = 1 Then
					$result += 26 * $b
				Else
					$result += $b
					If $mode = 0 Then
						$result = Chr($result)
					Else
						$result = Hex(String($result), 2)
					EndIf
					Return $result
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>RawDecode

Func Encode($input = '', $mode = 0)

	For $a = 1 To StringLen($input)
		Local $result
		If $mode = 0 Then
			$result &= RawEncode(StringMid($input, $a, 1), 0)
		ElseIf $mode = 1 Then
			$result &= RawEncode(StringMid($input, $a, 2), 1)
			$a += 1
		EndIf
	Next
	Return $result
EndFunc   ;==>Encode

Func Decode($input = '', $mode = 0)
	Local $result
	For $a = 1 To StringLen($input) Step +2
		$result &= RawDecode(StringMid($input, $a, 2), $mode)
	Next
	Return $result

EndFunc   ;==>Decode