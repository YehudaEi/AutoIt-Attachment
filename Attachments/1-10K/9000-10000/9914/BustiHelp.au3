$string = "555555;4D4D4D;7D7D7;292929;808080;292929;424242;292929;292929;161616;66DFE;333333;4;666666;333333;4" &  _
		'D4D4D;292929;333333;292929;161616;771FE;333333;4;292929;292929;424242;161616;333333;292929;161616;8' &  _
		'72FE;292929;666666;424242;555555;4D4D4D;292929;292929;292929;161616;872FE;872FE;666666;161616;868686' &  _
		';292929;424242;161616;333333;161616;161616;872FE;872FE;333333;333333;555555;292929;333333;161616;292' &  _
		'929;161616;872FE;872FE;872FE;292929;666666;161616;292929;161616;161616;292929;771FE;872FE;872FE;872F' &  _
		'E;333333;161616;161616;161616;161616;56BF8;56CFB;771FE;872FE;872FE;872FE;35EE9;361EA;261F0;465F1;466' &  _
		'F5;56BF8;56CFB;66DFE;572FF;872FE;872FE;35EE9;15EED;15EF1;161F4;262F6;368F8;56CFB;66DFE;572FF;572FF;5' &  _
		'72FF;35EE9;15BEE;15EF1;261F0;262F6;368F8;46AFB;36CFE;66DFE;572FF;572FF'
$Converted = _ConvertStrings($string)
$ConvertedBack = _ConvertStrings($Converted, ';', 0)
MsgBox(64, 'Info:', $Converted & @CR & @CR & @CR & $ConvertedBack)
Func _ConvertStrings($sText, $vDelim = ';', $iConvert = 1); $iConvert = 0 will do the reversal
	Local $aSplit = StringSplit($sText, $vDelim)
	Local $sNewString
	If $iConvert Then
		$sText = $vDelim & $sText & $vDelim
		For $iCount = 1 To UBound($aSplit) - 1
			If StringInStr($sText, $vDelim & $aSplit[$iCount] & $vDelim) Then
				$sText = StringReplace($sText,$aSplit[$iCount] & $vDelim, '')
				$iExtended = @extended
				If $iExtended > 1 Then
					$sNewString &= $aSplit[$iCount] & '*' & $iExtended & $vDelim
				Else
					$sNewString &= $aSplit[$iCount] & $vDelim
				EndIf
			EndIf
		Next
	Else
		For $iCount = 1 To UBound($aSplit) - 1
			If StringInStr($aSplit[$iCount], '*') Then
				Local $aSplit2 = StringSplit($aSplit[$iCount], '*', 1)
				For $xCount = 1 To Number($aSplit2[2])
					$sNewString &= $aSplit2[1] & $vDelim
				Next
			Else
				$sNewString &= $aSplit[$iCount] & $vDelim
			EndIf
		Next
	EndIf
	Return StringTrimRight($sNewString, 1)
EndFunc   ;==>_ConvertStrings