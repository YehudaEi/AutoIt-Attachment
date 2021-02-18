

;Every function you want to explicity write your own dynamic interpreter for: you enter the UPPERCASE name in here,
;Then you create a function called Return_<functionname>, which passes (through return) the function that will be used
;as the dynamic builtin caller..

;For example, for the Exp builtin function, you would insert a string element into the $function_overrides array that was: "EXP",
;Then create a function with the name Func Return_EXP(), and then return whatever you want to appear for that command in the
;generated file. EG: 'Return "Func Exp( $expression)" & @CRLF & "return Exp( $expression) & @CRLF & "EndFunc"
global $function_Overrides[2] = ["GUICTRLCREATELABEL", "MOUSECLICKDRAG"]


;These two functions are coded as the parser fails for them. The parser fails because of a badly written Helpfile.


Func Return_GUICTRLCREATELABEL()
return "Func _DynEXEC_GUICTRLCREATELABEL( $text, $left, $top, $width=Default, $height=Default, $style=Default, $exStyle=Default)" & _
@CRLF & "	local $ret = GUICTRLCREATELABEL($text,$left,$top,$width,$height,$style,$exStyle)" & @CRLF & _
"	SetError(@error,@extended)" & @crlf & _
"	Return $ret" & @crlf & _
"Endfunc"
EndFunc

FUnc Return_MOUSECLICKDRAG()
return "Func _DynEXEC_MOUSECLICKDRAG( $button, $x1, $y1, $x2, $y2, $speed=Default)" & @CRLF & _
"	local $ret = MOUSECLICKDRAG($button,$x1, $y1, $x2, $y2,$speed)" & @CRLF & _
"	SetError(@error,@extended)" & @CRLF & _
"	Return $ret" & @CRLF & _
"Endfunc"
EndFunc