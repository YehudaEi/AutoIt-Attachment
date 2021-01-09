$String = _TwoWayCrypt('The quick brown fox jumps over the lazy dog','123')
ConsoleWrite('Encrypted: ' & $String & @CRLF)
ConsoleWrite('wrong key: ' & _TwoWayCrypt($String,'321', 0) & @CRLF)
ConsoleWrite('wrong lvl: ' & _TwoWayCrypt($String,'123', 0, 2) & @CRLF)
ConsoleWrite('Decrypted: ' & _TwoWayCrypt($String,'123', 0) & @CRLF)

Func _TwoWayCrypt($nString, $nPass, $iMode = 1, $ExMode = 1, $Offset = 'XOR')
	If $nPass = ' ' Then $nPass = '!' ;can't remember why this is here
	
	If $iMode = 0 Then
		$nString = BinaryToString('0x' & $nString, 4)
	ElseIf $iMode = 1 Then
		;$nString = __StringInsert($nString, Chr(BitXOR(_BitXORWord($nPass), 32)), 3)
		;$nString = _InvASCII($nString, 3)
		;not needed ^
	Else
		Return -2
	EndIf
	
	If $Offset = 'XOR' Then
		$Offset = Abs(412 - _BitXORWord($nPass))
	ElseIf $Offset < 1 Or $Offset > 412 Then
		$Offset = 128
	EndIf
	
	Local $Static
	
	If $ExMode < 1 And $ExMode > 3 Then
		$ExMode = 2
		$Static = Mod(251, _BitXORWord($nPass))
	ElseIf $ExMode = 1 Then
		$Static = Mod(241, _BitXORWord($nPass))
	ElseIf $ExMode = 2 Then
		$Static = Mod(251, _BitXORWord($nPass))
	ElseIf $ExMode = 3 Then
		$Static = Mod(257, _BitXORWord($nPass))
	EndIf
	
	$rPass = _Randomise($nPass, StringLen($nString))
	$_nPass = $nPass
	$nPass = _FrogCHK($nPass) & _FrogCHK2($nPass, $Offset);Do something here to make each password unique, suggested method = MD5
	$nPass = $nPass & __StringReverse($nPass) & $nPass ;should be 120 bytes long
	$Misc = __StringReverse(_InvASCII($nPass & $nPass & Chr(BitXOR(_BitXORWord($nPass), 84)), 3))
	$Len = StringLen($Misc) ;should be 241
	$Gen = _GenPrimesUnder255(_BitXORWord($_nPass))
	;ConsoleWrite($_nPass & @LF & $nPass & @LF & $Misc & @LF & $Len & @LF)
	
	Local $nStringSplit = StringSplit($nString, ''), $nPassSplit = StringSplit($nPass, ''), $Bin, $Flux = $nPass, $m = StringLen($nPass), $n = 0, $b = 0, $c = 0, $mSplit = StringSplit($Misc, ''), $g, $FullLen = StringLen($nString)
	Local $23 = _23hash($_nPass), $23W, $rSplit = StringSplit($rPass, ''), $r = 0
	
	$23s = StringSplit($23, '')
	
	For $i = 1 To $nStringSplit[0]
		$n += 1
		If $n > $m Then $n = 1
		;
		$b += 1
		If $b > 254 Then $b = 1
		;
		$c += 1
		If $c > $Len Then $c = 1
		;
		$g += 1
		If $g > $Gen[0][0] Then $g = 1
		;
		$23W += 1
		If $23W > 23 Then $23W = 1
		;
		$r += 1
		If $r > 157 Then $r = 1
		;
		
		$Flux = _NewPass($Flux, $nPassSplit[$n], $n, $ExMode)
		$BitAND = BitAND(BitRotate(BitXOR(BitAND(0xFB, $b), Mod(0x10F, $b)), 2), 0xff)
		$Bin &= Chr(BitXOR(Asc($rSplit[$r]), BitXOR(Asc($nStringSplit[$i]), Asc($nPassSplit[$n]), $BitAND), 255 - Asc($Flux), Asc($23s[$23W]), BitXOR($Gen[$g][0], $b, BitXOR(Asc($nPassSplit[$n]), $Static)), Asc($mSplit[$c]), $Gen[$Gen[0][0] - $g][1]))
	Next
	If $iMode = 0 Then
		Return $Bin
	EndIf
	
	Return StringTrimLeft(StringToBinary($Bin, 4), 2)
EndFunc   ;==>_TwoWayCrypt

Func _NewPass($Pass, $a, $c, $Ex)
	;ConsoleWrite(_InvASCII(Chr(BitXOR(Asc(StringLeft($Pass, 1)), Asc($a))), $Ex))
	Return _InvASCII(Chr(BitXOR(Asc(StringLeft($Pass, 1)), Asc($a), Int(Asc($a) / $Ex))), $Ex)
EndFunc   ;==>_NewPass

;ConsoleWrite(_23hash('THIS IS SPARTa')&@LF)
;00A0E0FF7E6B18F80
;00A0E0FF7E6B18F80
Func _23hash($String) ;Returns a checksum value 23 bytes long
	Local $17_1, $17_2, $17_3 ;6, 5, 6
	Local $Split = StringSplit($String, ''), $Len = StringLen($String)
	Local $Array[17] = [271, 11000, 32784, 21373, 83271, 14875781, 1249875, 213742, 2184973, 83925713, 192348789], $L = 0
	
	For $i = 1 To $Split[0]
		$17_1 = BitShift(BitXOR(Asc($Split[$i]), $17_3, BitXOR(Asc($Split[$i]), $i), Mod(11987, $Len)), -3)
		$17_2 = BitRotate(BitXOR(BitRotate(Asc($Split[$i]), 2), $17_1, $i), 2, 'W')
		$17_3 = Int(BitShift($17_1 * $17_2, -2))
		$L += 1
		If $L > 16 Then $L = 0
	Next
	
	;halve the results
	
	$17_1 *= 1 / 2
	$17_2 *= 1 / 2
	$17_3 *= 1 / 2
	
	
	Return _EncodeSimple(Hex($17_1, 8) & Hex(BitNOT($17_2), 8) & Hex($17_3, 7))
EndFunc   ;==>_23hash

Func _Randomise($String, $sRandom)
	;$Timer = TimerInit()
	$Num = _BitXORWord($String) * 11735
	SRandom(BitXOR($Num, _BitORWord($String) * 10375, 3673 * $sRandom))
	
	Local $Return
	For $i = 1 To 157
		$Return &= Chr(Random(1, 255, 1))
	Next
	
	;ConsoleWrite(TimerDiff($Timer)&@LF)
	Return $Return
EndFunc   ;==>_Randomise

Func _GenPrimesUnder255($Scramble)
	;Error Checking
	If $Scramble = 17 Or $Scramble = 19 Then ;known problems
		$Scramble = 18
	EndIf
	
	Local $Primes[55][2], $b
	$Primes[0][0] = UBound($Primes) - 1
	For $i = 1 To 255
		If _IsPrime($i) Then
			$b += 1
			$1 = Mod($i, $Scramble)
			$2 = Mod(BitXOR($Scramble, $i), $i)
			If String($1) = '-1.#IND' Or $1 = 0 Then
				$1 = Mod($i, 17)
				;ConsoleWrite('+ ' & $1 & @LF)
			EndIf
			
			If String($2) = '-1.#IND' Or $2 = 0 Then
				$2 = Mod($i, 5)
				;ConsoleWrite('! ' & $2 & @LF)
			EndIf
			
			$Primes[$b][0] = $1;Mod($i, BitXOR($i, $Scramble))
			$Primes[$b][1] = $2;Mod(BitXOR($i, $Scramble), $i)
		EndIf
	Next
	
	Return $Primes
EndFunc   ;==>_GenPrimesUnder255

Func _EncodeSimple($eString)
	Local $Bin, $eSplit = StringSplit($eString, '')
	
	For $i = 1 To $eSplit[0]
		$Bin &= Chr(BitXOR(Asc($eSplit[$i]), 27))
	Next
	
	Return $Bin
EndFunc   ;==>_EncodeSimple

Func _BitXORWord($sWord)
	Local $Bin, $sSplit = StringSplit($sWord, '')
	$Bin = Asc($sSplit[1])
	
	For $i = 2 To $sSplit[0]
		$Bin = BitXOR($Bin, Asc($sSplit[$i]))
	Next
	
	Return $Bin
EndFunc   ;==>_BitXORWord








Func _FrogCHK($sString, $Offset = 128)
	If $Offset < 0 Or $Offset > 412 Then $Offset = 0
	If StringLen($sString) = 0 Then Return -1
	Local $Split = StringSplit($sString, ''), $Bin, $Dump, $Trash = Dec(_FrogCHK2(_BitORWord($sString), 412 - $Offset)), $Final, $Watch = $Offset
	
	For $i = 1 To $Split[0]
		$Watch += 1
		If $Watch > 412 Then $Watch = 1
		$Bin = BitRotate(BitXOR(BitXOR(Asc($Split[$i]), BitNOT($Dump)), BitXOR($i, $Split[0], $Trash)), 255 / $i)
		$Dump = BitShift(BitXOR(BitShift(BitXOR(Asc($Split[$i]), $i), -8), $Bin), -3)
		;$Dump = BitXOR(BitShift(BitXOR(Asc($Split[$i]), $i), -8), $Bin)
		$Final = BitXOR($Final, Asc($Split[$i]), BitRotate($Dump, 2))
		$Trash = Dec(_FrogCHK2($Final, $Watch))
	Next
	
	;Final round
	$Bin = BitXOR($Dump, $Final, $Trash)
	$Dump = BitRotate(Dec(_FrogCHK2($Bin, $Watch)), 2)
	$Final = BitRotate($Trash, 2)
	$Trash = BitNOT(BitXOR($Final, $Trash, Dec(_FrogCHK2(BitXOR($Bin, $Trash, $Final), 18))))
	;ConsoleWrite(Hex(BitNOT(BitRotate($Dump, 2, 'D')), 8)&@TAB&$Dump&@LF)
	
	Return StringLower(Hex(BitNOT($Final), 8) & Hex(BitNOT($Dump), 8) & Hex($Bin, 8) & Hex(BitNOT($Trash), 8))
EndFunc   ;==>_FrogCHK

Func _BitORWord($sWord)
	Local $Split = StringSplit($sWord, ''), $Return
	
	For $i = 1 To $Split[0]
		$Return = BitOR($Return, Asc($Split[$i]))
	Next
	
	Return $Return
EndFunc   ;==>_BitORWord

Func _FrogCHK2Init()
	If IsDeclared('_FrogCHKArray') <> 0 Then Return -1
	Global Const $_FrogCHKArray[411] = [ 81727492, 21995288, 74081711, 30496938, 92256093, 18011212, 23802961, 7322268, 1125510, 44472736, 68386972, 68372806, 55819778, 11226254, 83780110, 16612056, 16056603, 99996361, 98230739, 69887596, 64415401, 8307104, _
						60244159, 70534034, 58839439, 17061689, 97067121, 76536713, 94051634, 27034931, 41210881, 37245118, 35040983, 93029998, 89523217, 34833156, 61779633, 22850343, 1690969, 70282390, 32377562, 66603286, _
						42269844, 72049236, 42301568, 87322944, 34025434, 76306888, 59680070, 27830797, 43539227, 99870191, 77491638, 58248033, 19877295, 14678775, 61875368, 19338513, 92079257, 57306117, 86878544, 95704971, _
						4806563, 14282045, 53762291, 89545373, 62305103, 47924848, 25739189, 80898729, 88288087, 43725729, 18361607, 38543767, 24693888, 20841639, 35213301, 2317440, 24549992, 31063170, 87667707, 35766966, _
						55938518, 45970892, 78284176, 88073787, 17930477, 6679383, 75390589, 3302885, 61614769, 52227364, 86612300, 90089958, 57583101, 22489195, 59037701, 3088503, 76525236, 87283172, 10000771, 60737050, _
						97394099, 42129018, 56779216, 42042172, 58454198, 66464897, 25383104, 4022966, 55130748, 36918980, 28210859, 47872078, 25532888, 99666107, 5126772, 72895413, 32400725, 46238853, 94558429, 98851887, _
						97000335, 43964894, 62491550, 65936247, 60080323, 48175244, 18597816, 30367910, 2822074, 34502758, 18978122, 4262860, 52889310, 19836347, 95796228, 40798721, 87958873, 86869601, 52293769, 72775425, _
						48106084, 89261666, 8069558, 83577468, 15032006, 81339847, 33863163, 27935850, 76388967, 36576161, 66736757, 9775804, 81726467, 85185575, 22634172, 3999588, 66438002, 50821690, 52084113, 54205985, _
						76621434, 2913742, 78234667, 47860563, 88488157, 16925514, 70871054, 88963244, 81165697, 61479214, 6618102, 39870962, 61249788, 6294389, 64556611, 45668997, 66799958, 2328085, 34343793, 78264150, _
						5666255, 23574792, 25921509, 87944479, 82594200, 44873814, 65474682, 55445417, 41438463, 59740096, 6673641, 59542060, 60541933, 53215370, 30551951, 12674151, 54181994, 52202600, 76682691, 25791267, _
						84768555, 83609020, 38699711, 22118768, 7274097, 46603365, 82220002, 78041493, 59351122, 10210869, 3060495, 26369907, 82525424, 56914064, 7661879, 7866151, 60919335, 46399263, 99054332, 33385520, _
						16400851, 66653149, 44081835, 60432151, 20086848, 76720205, 20958621, 69300565, 6078752, 17084683, 48184805, 65381351, 40584840, 39750804, 51523494, 52573546, 21527301, 1776496, 28487486, 67515325, _
						4123725, 3127367, 57486334, 78365453, 69378097, 64939445, 40400787, 58924769, 84558965, 65996393, 9465223, 39683281, 5971069, 39648119, 46284487, 83384399, 82356990, 90318095, 62356569, 18258204, _
						90798590, 23203381, 21618058, 70486826, 51878915, 47047946, 8834403, 91559398, 10134961, 81959163, 28241052, 33209513, 72234656, 37716307, 79813677, 99873005, 77271858, 75044790, 35860928, 12410554, _
						4543148, 34829782, 28139037, 14280963, 40761818, 3979240, 11652547, 20244907, 98801451, 40406161, 62683783, 69993316, 44875061, 71370915, 58856275, 92379704, 29891161, 1792506, 60817496, 2820668, _
						83305824, 86388608, 83333395, 27754962, 15915827, 55483955, 62195778, 45962824, 50780272, 10019105, 75070097, 20758231, 19768216, 46688343, 85963503, 33238945, 46689322, 13552835, 80409547, 53792709, _
						81312731, 96218967, 37871502, 2271529, 73224196, 95958383, 33903634, 95695464, 12302948, 22689545, 30428256, 13715973, 52679905, 18098829, 46338995, 33680227, 11681946, 17804541, 27503600, 26526870, _
						60347250, 8439330, 4828100, 96370609, 82953783, 76840119, 19262705, 83986871, 34164624, 15377075, 77868187, 14252830, 9058783, 70659145, 26042885, 37381531, 6077431, 83999720, 23537511, 31642689, _
						79175962, 17225001, 65017891, 6371657, 40721105, 84410110, 93881537, 23566066, 83963265, 35516823, 43787902, 73957280, 84159123, 70629693, 80799977, 22948314, 56422591, 13694095, 41380879, 52282584, _
						90735329, 13561174, 22470347, 12675752, 93701158, 70950193, 97397931, 10583474, 44159583, 63431700, 42781751, 28982409, 94659606, 59742683, 86618136, 20040740, 60207230, 7946810, 1380273, 1842437, _
						51741336, 75244695, 78131065, 69627665, 81920578, 68925692, 63760180, 92346715 ]
EndFunc  ;==>_FrogCHK2Init

Func _FrogCHK2($String, $Offset = 0)
	_FrogCHK2Init()
	If $Offset < 0 Or $Offset > UBound($_FrogCHKArray) - 1 Then $T = 0
	Local $Split = StringSplit($String, ''), $Hex, $T = $Offset, $L = UBound($_FrogCHKArray)
	
	For $i = 1 To $Split[0]
		$T += 1
		If $T > UBound($_FrogCHKArray) - 1 Then $T = 1
		$Hex = BitXOR(Asc($Split[$i]) * 2151930, $i, $_FrogCHKArray[$T], BitRotate($Hex, 2), $_FrogCHKArray[$L - $T])
	Next
	
	Return _8ByteScramble(Hex(BitNOT($Hex), 8))
EndFunc   ;==>_FrogCHK2

Func _8ByteScramble($8Bytes)
	If StringLen($8Bytes) <> 8 Then Return $8Bytes
	
	Local $Split = StringSplit($8Bytes, ''), $Return[9], $Hex
	$Return[1] = $Split[7]
	$Return[2] = $Split[2]
	$Return[3] = $Split[5]
	$Return[4] = $Split[3]
	$Return[5] = $Split[1]
	$Return[6] = $Split[8]
	$Return[7] = $Split[4]
	$Return[8] = $Split[6]
	For $i = 1 To 8
		$Hex &= $Return[$i]
	Next
	
	Return $Hex
EndFunc   ;==>_8ByteScramble


Func _InvASCII($sString, $Mode = 1)
	Local $Dump, $Split = StringSplit($sString, '')
	
	If $Mode = 1 Then
		For $i = 1 To $Split[0]
			If Asc($Split[$i]) > 128 Then
				$Dump &= Chr(Asc($Split[$i]) - 128)
			ElseIf Asc($Split[$i]) < 128 Then
				$Dump &= Chr(Asc($Split[$i]) + 128)
			Else
				$Dump &= $Split[$i]
			EndIf
		Next
	ElseIf $Mode = 2 Then
		For $i = 1 To $Split[0]
			If Asc($Split[$i]) > 64 And Asc($Split[$i]) < 128 Then
				$Dump &= Chr(Asc($Split[$i]) - 64)
			ElseIf Asc($Split[$i]) < 64 Then
				$Dump &= Chr(Asc($Split[$i]) + 64)
			ElseIf Asc($Split[$i]) > 192 And Asc($Split[$i]) < 255 Then
				$Dump &= Chr(Asc($Split[$i]) - 64)
			ElseIf Asc($Split[$i]) < 192 And Asc($Split[$i]) > 128 Then
				$Dump &= Chr(Asc($Split[$i]) + 64)
			Else
				$Dump &= $Split[$i]
			EndIf
		Next
	ElseIf $Mode = 3 Then
		For $i = 1 To $Split[0]
			If Asc($Split[$i]) > 32 And Asc($Split[$i]) < 64 Then
				$Dump &= Chr(Asc($Split[$i]) - 32)
			ElseIf Asc($Split[$i]) < 32 Then
				$Dump &= Chr(Asc($Split[$i]) + 32)
			ElseIf Asc($Split[$i]) > 96 And Asc($Split[$i]) < 128 Then
				$Dump &= Chr(Asc($Split[$i]) - 32)
			ElseIf Asc($Split[$i]) < 96 And Asc($Split[$i]) > 64 Then
				$Dump &= Chr(Asc($Split[$i]) + 32)
			ElseIf Asc($Split[$i]) > 160 And Asc($Split[$i]) < 192 Then
				$Dump &= Chr(Asc($Split[$i]) - 32)
			ElseIf Asc($Split[$i]) < 160 And Asc($Split[$i]) > 128 Then
				$Dump &= Chr(Asc($Split[$i]) + 32)
			ElseIf Asc($Split[$i]) > 224 And Asc($Split[$i]) < 255 Then
				$Dump &= Chr(Asc($Split[$i]) - 32)
			ElseIf Asc($Split[$i]) < 224 And Asc($Split[$i]) > 192 Then
				$Dump &= Chr(Asc($Split[$i]) + 32)
			Else
				$Dump &= $Split[$i]
			EndIf
		Next
	Else
		Return -1
	EndIf
	
	Return $Dump
EndFunc   ;==>_InvASCII

Func _IsPrime($i_num)
	If StringIsDigit($i_num) = 0 Then Return -1
	If $i_num > 3 Then
		If Mod($i_num, 2) = 0 Then Return 0
		If Mod($i_num, 3) = 0 Then Return 0
	EndIf
	If $i_num = 1 Then Return 0
	Dim $divisor, $increment, $maxdivisor
	$divisor = 5
	$increment = 2
	$maxdivisor = Sqrt($i_num) + 1

	Do
		If Mod($i_num, $divisor) = 0 And $i_num <> $divisor Then Return 0
		$divisor = $divisor + $increment
		$increment = 6 - $increment
	Until $divisor > $maxdivisor
	Return 1
EndFunc   ;==>_IsPrime


Func __StringReverse($String, $fProg = False) ;Optimised by Siao
	Local $Split, $ReturnString, $Progress, $Percent

	$Split = StringSplit($String, "")
	If $fProg Then
		$Progress = ProgressOn("__StringReverse", "Reversing String...", "", Default, Default, 16)
		$Percent = 0
		For $i = $Split[0] To 1 Step -1
			$Percent += 1
			$ReturnString &= $Split[$i]
			ProgressSet(Abs(($Percent / $Split[0]) * 100), "")
		Next
		ProgressOff()
	Else
		For $i = $Split[0] To 1 Step -1
			$ReturnString &= $Split[$i]
		Next
	EndIf

	Return $ReturnString
EndFunc   ;==>__StringReverse