#include-once
#include <Array.au3>

Dim $Entity[65536]
$Entity[34] = "quot"
$Entity[38] = "amp"
$Entity[39] = "apos"
$Entity[60] = "lt"
$Entity[62] = "gt"
$Entity[160] = "nbsp"
$Entity[161] = "iexcl"
$Entity[162] = "cent"
$Entity[163] = "pound"
$Entity[164] = "curren"
$Entity[165] = "yen"
$Entity[166] = "brvbar"
$Entity[167] = "sect"
$Entity[168] = "uml"
$Entity[169] = "copy"
$Entity[170] = "ordf"
$Entity[171] = "laquo"
$Entity[172] = "not"
$Entity[173] = "shy"
$Entity[174] = "reg"
$Entity[175] = "macr"
$Entity[176] = "deg"
$Entity[177] = "plusmn"
$Entity[178] = "sup2"
$Entity[179] = "sup3"
$Entity[180] = "acute"
$Entity[181] = "micro"
$Entity[182] = "para"
$Entity[183] = "middot"
$Entity[184] = "cedil"
$Entity[185] = "sup1"
$Entity[186] = "ordm"
$Entity[187] = "raquo"
$Entity[188] = "frac14"
$Entity[189] = "frac12"
$Entity[190] = "frac34"
$Entity[191] = "iquest"
$Entity[192] = "Agrave"
$Entity[193] = "Aacute"
$Entity[194] = "Acirc"
$Entity[195] = "Atilde"
$Entity[196] = "Auml"
$Entity[197] = "Aring"
$Entity[198] = "AElig"
$Entity[199] = "Ccedil"
$Entity[200] = "Egrave"
$Entity[201] = "Eacute"
$Entity[202] = "Ecirc"
$Entity[203] = "Euml"
$Entity[204] = "Igrave"
$Entity[205] = "Iacute"
$Entity[206] = "Icirc"
$Entity[207] = "Iuml"
$Entity[208] = "ETH"
$Entity[209] = "Ntilde"
$Entity[210] = "Ograve"
$Entity[211] = "Oacute"
$Entity[212] = "Ocirc"
$Entity[213] = "Otilde"
$Entity[214] = "Ouml"
$Entity[215] = "times"
$Entity[216] = "Oslash"
$Entity[217] = "Ugrave"
$Entity[218] = "Uacute"
$Entity[219] = "Ucirc"
$Entity[220] = "Uuml"
$Entity[221] = "Yacute"
$Entity[222] = "THORN"
$Entity[223] = "szlig"
$Entity[224] = "agrave"
$Entity[225] = "aacute"
$Entity[226] = "acirc"
$Entity[227] = "atilde"
$Entity[228] = "auml"
$Entity[229] = "aring"
$Entity[230] = "aelig"
$Entity[231] = "ccedil"
$Entity[232] = "egrave"
$Entity[233] = "eacute"
$Entity[234] = "ecirc"
$Entity[235] = "euml"
$Entity[236] = "igrave"
$Entity[237] = "iacute"
$Entity[238] = "icirc"
$Entity[239] = "iuml"
$Entity[240] = "eth"
$Entity[241] = "ntilde"
$Entity[242] = "ograve"
$Entity[243] = "oacute"
$Entity[244] = "ocirc"
$Entity[245] = "otilde"
$Entity[246] = "ouml"
$Entity[247] = "divide"
$Entity[248] = "oslash"
$Entity[249] = "ugrave"
$Entity[250] = "uacute"
$Entity[251] = "ucirc"
$Entity[252] = "uuml"
$Entity[253] = "yacute"
$Entity[254] = "thorn"
$Entity[255] = "yuml"
$Entity[338] = "OElig"
$Entity[339] = "oelig"
$Entity[352] = "Scaron"
$Entity[353] = "scaron"
$Entity[376] = "Yuml"
$Entity[402] = "fnof"
$Entity[710] = "circ"
$Entity[732] = "tilde"
$Entity[913] = "Alpha"
$Entity[914] = "Beta"
$Entity[915] = "Gamma"
$Entity[916] = "Delta"
$Entity[917] = "Epsilon"
$Entity[918] = "Zeta"
$Entity[919] = "Eta"
$Entity[920] = "Theta"
$Entity[921] = "Iota"
$Entity[922] = "Kappa"
$Entity[923] = "Lambda"
$Entity[924] = "Mu"
$Entity[925] = "Nu"
$Entity[926] = "Xi"
$Entity[927] = "Omicron"
$Entity[928] = "Pi"
$Entity[929] = "Rho"
$Entity[931] = "Sigma"
$Entity[932] = "Tau"
$Entity[933] = "Upsilon"
$Entity[934] = "Phi"
$Entity[935] = "Chi"
$Entity[936] = "Psi"
$Entity[937] = "Omega"
$Entity[945] = "alpha"
$Entity[946] = "beta"
$Entity[947] = "gamma"
$Entity[948] = "delta"
$Entity[949] = "epsilon"
$Entity[950] = "zeta"
$Entity[951] = "eta"
$Entity[952] = "theta"
$Entity[953] = "iota"
$Entity[954] = "kappa"
$Entity[955] = "lambda"
$Entity[956] = "mu"
$Entity[957] = "nu"
$Entity[958] = "xi"
$Entity[959] = "omicron"
$Entity[960] = "pi"
$Entity[961] = "rho"
$Entity[962] = "sigmaf"
$Entity[963] = "sigma"
$Entity[964] = "tau"
$Entity[965] = "upsilon"
$Entity[966] = "phi"
$Entity[967] = "chi"
$Entity[968] = "psi"
$Entity[969] = "omega"
$Entity[977] = "thetasym"
$Entity[978] = "upsih"
$Entity[982] = "piv"
$Entity[8194] = "ensp"
$Entity[8195] = "emsp"
$Entity[8201] = "thinsp"
$Entity[8204] = "zwnj"
$Entity[8205] = "zwj"
$Entity[8206] = "lrm"
$Entity[8207] = "rlm"
$Entity[8211] = "ndash"
$Entity[8212] = "mdash"
$Entity[8216] = "lsquo"
$Entity[8217] = "rsquo"
$Entity[8218] = "sbquo"
$Entity[8220] = "ldquo"
$Entity[8221] = "rdquo"
$Entity[8222] = "bdquo"
$Entity[8224] = "dagger"
$Entity[8225] = "Dagger"
$Entity[8226] = "bull"
$Entity[8230] = "hellip"
$Entity[8240] = "permil"
$Entity[8242] = "prime"
$Entity[8243] = "Prime"
$Entity[8249] = "lsaquo"
$Entity[8250] = "rsaquo"
$Entity[8254] = "oline"
$Entity[8260] = "frasl"
$Entity[8364] = "euro"
$Entity[8465] = "image"
$Entity[8472] = "weierp"
$Entity[8476] = "real"
$Entity[8482] = "trade"
$Entity[8501] = "alefsym"
$Entity[8592] = "larr"
$Entity[8593] = "uarr"
$Entity[8594] = "rarr"
$Entity[8595] = "darr"
$Entity[8596] = "harr"
$Entity[8629] = "crarr"
$Entity[8656] = "lArr"
$Entity[8657] = "uArr"
$Entity[8658] = "rArr"
$Entity[8659] = "dArr"
$Entity[8660] = "hArr"
$Entity[8704] = "forall"
$Entity[8706] = "part"
$Entity[8707] = "exist"
$Entity[8709] = "empty"
$Entity[8711] = "nabla"
$Entity[8712] = "isin"
$Entity[8713] = "notin"
$Entity[8715] = "ni"
$Entity[8719] = "prod"
$Entity[8721] = "sum"
$Entity[8722] = "minus"
$Entity[8727] = "lowast"
$Entity[8730] = "radic"
$Entity[8733] = "prop"
$Entity[8734] = "infin"
$Entity[8736] = "ang"
$Entity[8743] = "and"
$Entity[8744] = "or"
$Entity[8745] = "cap"
$Entity[8746] = "cup"
$Entity[8747] = "int"
$Entity[8756] = "there4"
$Entity[8764] = "sim"
$Entity[8773] = "cong"
$Entity[8776] = "asymp"
$Entity[8800] = "ne"
$Entity[8801] = "equiv"
$Entity[8804] = "le"
$Entity[8805] = "ge"
$Entity[8834] = "sub"
$Entity[8835] = "sup"
$Entity[8836] = "nsub"
$Entity[8838] = "sube"
$Entity[8839] = "supe"
$Entity[8853] = "oplus"
$Entity[8855] = "otimes"
$Entity[8869] = "perp"
$Entity[8901] = "sdot"
$Entity[8968] = "lceil"
$Entity[8969] = "rceil"
$Entity[8970] = "lfloor"
$Entity[8971] = "rfloor"
$Entity[9001] = "lang"
$Entity[9002] = "rang"
$Entity[9674] = "loz"
$Entity[9824] = "spades"
$Entity[9827] = "clubs"
$Entity[9829] = "hearts"
$Entity[9830] = "diams"

;===============================================================================
;
; Function Name:    _HTMLEncode()
; Description:      Encode the normal string into HTML Entity Number
; Parameter(s):     $String     - The string you want to encode.
;
; Requirement(s):   AutoIt v3.2.4.9 or higher (Unicode)
; Return Value(s):  On Success  - Returns HTML Entity Number
;                   On Failure  - Nothing
;
; Author(s):        Dhilip89
;
;===============================================================================


Func _HTMLEncode($Str)
	$StrLen = StringLen($Str)
	Local $Encoded
	If $StrLen = 0 Then Return ''
	For $i = 1 To $StrLen
		$StrChar = StringMid($Str, $i, 1)
		$Encoded &= '&#' & AscW($StrChar) & ';'
	Next
	Return $Encoded
EndFunc   ;==>_HTMLEncode


;===============================================================================
;
; Function Name:    _HTMLDecode()
; Description:      Decode the HTML Entity Number into normal string
; Parameter(s):     $HTMLEntityNum  - The HTML Entity Number you want to decode.
;
; Requirement(s):   AutoIt v3.2.4.9 or higher (Unicode)
; Return Value(s):  On Success  - Returns decoded strings
;                   On Failure  - Nothing
;
; Author(s):        Dhilip89
;
;===============================================================================

Func _HTMLDecode($Str)
	Local $Decoded
	If $Str = '' Then Return ''
	$X1 = StringRegExp($Str, '&#x(.*?);', 3)
	$X2 = StringRegExp($Str, '&#(.*?);', 3)
	$X3 = StringRegExp($Str, '&(.*?);', 3)
	For $i = 0 To UBound($X1) - 1 Step 1
		$Str = StringReplace($Str, '&#x' & $X1[$i] & ';', ChrW(Dec($X1[$i])))
	Next
	For $i = 0 To UBound($X2) - 1 Step 1
		$Str = StringReplace($Str, '&#' & $X2[$i] & ';', ChrW($X2[$i]))
	Next
	For $i = 0 To UBound($X3) - 1 Step 1
		$Str = StringReplace($Str, '&' & $X3[$i] & ';', ChrW(_ArraySearch($Entity, $X3[$i], 0, 0, 1)))
	Next
	$Decoded = $Str
	Return $Decoded
EndFunc   ;==>_HTMLDecode
