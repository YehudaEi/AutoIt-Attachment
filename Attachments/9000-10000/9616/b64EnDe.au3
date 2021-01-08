Global Const $b64ch[64] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', _ 
				  'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', _
				  'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', _
				  'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', _
				  'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', _
				  'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', _
				  '8', '9', '+', '/']

Global Const $b64Rch[123] = [ 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,	 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, _
						 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, _ 
						 0,  0,  62, 0,  0,  0, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,  0,  0,  0, _
						 0,  0,  0,  0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, _
						16, 17, 18, 19, 20, 21, 22, 23, 24, 25,  0,  0,  0,  0,  0,  0, 26, 27, 28, 29, _
						30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, _
						50, 51]
Func en64b($t)
	$res = ''
	$arrt = StringSplit($t,'')
	For $a1 = 1 To $arrt[0]
		Select
			Case Mod($a1, 3) = 1
				$aa = $b64ch[BitShift(Asc($arrt[$a1]), 2)]
				$at = BitAND(BitShift(Asc($arrt[$a1]), -4),48)
				If $a1 = $arrt[0] Then 
					$res = $res & $aa & $b64ch[$at] & '=='
					Return $res
				EndIf	
			Case Mod($a1, 3) = 2
				$aa = $b64ch[$at+BitShift(Asc($arrt[$a1]), 4)]
				$at = BitAND(BitShift(Asc($arrt[$a1]), -2),60)
				If $a1 = $arrt[0] Then 
					$res = $res & $aa & $b64ch[$at] & '='
					Return $res
				EndIf	
			Case Mod($a1, 3) = 0 
				$aa = $b64ch[$at+BitShift(Asc($arrt[$a1]), 6)] & $b64ch[BitAND(Asc($arrt[$a1]), 63)]
				If $a1 = $arrt[0] Then 
					$res &= $aa
					Return $res
				EndIf	
		EndSelect
		$res &= $aa
	Next
	Return $res
EndFunc	

Func de64b($t)
	$res = ''
	$arrt = StringSplit(StringReplace($t,'=',''),'')
	For $a1 = 1 To $arrt[0]
		If Mod($a1, 4) = 1 Then ContinueLoop
		Select
			Case Mod($a1, 4) = 2
				$at = BitShift($b64Rch[Asc($arrt[$a1-1])], -2) + BitShift($b64Rch[Asc($arrt[$a1])], 4)
				$aa = BitShift($b64Rch[Asc($arrt[$a1])], -4)
				If $a1 = $arrt[0] Then 
					$res &= chr($at)
					Return $res
				EndIf	
			Case Mod($a1, 4) = 3 
				$at = $aa + BitShift($b64Rch[Asc($arrt[$a1])], 2)
				$aa = BitShift($b64Rch[Asc($arrt[$a1])], -6) 
				If $a1 = $arrt[0] Then 
					$res &= chr($at)
					Return $res
				EndIf	
			Case Mod($a1, 4) = 0 
				$at = $aa + $b64Rch[Asc($arrt[$a1])]
				If $a1 = $arrt[0] Then 
					$res &= chr($at)
					Return $res
				EndIf	
		EndSelect
		$res &= chr($at)
	Next
	Return $res
EndFunc	
