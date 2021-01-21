;WARNING: While these functions are intended to be helpful,
;          use at your own risk!
;         (Tested with autoit-v3.1.1.95-beta ONLY)

;Test of VarsToString and StringToVars

;Make some GLOBAL vars
dim $a[2] = [Chr(0), TRUE] ;Array with BinaryString and Bool inside
$b = 2.1 ;Float

x() ;Go to func to make LOCAL vars
exit

func x()
	;Make some LOCAL vars
	dim $c[1]
	$c[0] = $a ;Array in Array
	$d = 10 ;Int
	$e = default ;Keyword
	$f = 'yes!!!' ;String

	;Get the handle of a notepad window
	$pid = Run("c:\windows\notepad.exe")
	while TRUE
		$g = ''
		$list = WinList('Untitled - Notepad')
		for $i = 1 to $list[0][0]
			if Hex(WinGetProcess($list[$i][1])) == Hex($pid) then
				$g = $list[$i][1]
				exitloop
			endif
		next
		if $g <> '' then exitloop
	wend

	;Save both GLOBAL and LOCAL variables
	Execute(VarsToString('a,b,c,d,e,f,g', 's'))

	;Trash all saved variables
	dim $a = 0, $b = 0, $c = 0, $d = 0, $e = 0, $f = 0, $g = 0

	;Restore all saved variables
	Execute(StringToVars('s'))
	WinClose($g) ;don't need notepad window any more

	;Show all saved variables
	$c = $c[0] ;extract array that's in $c
	Msgbox(0, 'Restored Vars', _
	 '$a[0] = Chr(' & Asc($a[0]) & ')' & @CRLF _
	 & '$a[1] = ' & $a[1] & @CRLF _
	 & '$b = ' & $b & @CRLF _
	 & '$c[0] = Chr(' & Asc($c[0]) & ')' & @CRLF _
	 & '$c[1] = ' & $c[1] & @CRLF _
	 & '$d = ' & $d & @CRLF _
	 & '$e = ' & $e & @CRLF _
	 & '$f = ' & $f & @CRLF _
	 & '$g = ' & $g & @CRLF)
endfunc

func VarsToString($varNames, $stringName)
	if not (IsString($varNames) and IsString($stringName)) _
	 then VarsToString_ErrExit('BOTH PARAMETERS MUST BE STRINGS')
	if not VarsToString_GetName($stringName) _
	 then VarsToString_ErrExit('PARAMETER 2: BAD NAME = $' & $stringName)
	local $func = "Assign('" & $stringName & "','')"
	if 	StringStripWS($varNames, 8) <> '' then
		local $parm1 = $varNames
		$varNames = StringSplit($varNames, ',')
		for $i = 1 to $varNames[0]
			if not VarsToString_GetName($varNames[$i]) _
			 then VarsToString_ErrExit('PARAMETER 1 = ' & $parm1 _
			 & @CRLF & 'BAD VAR NAME = $' & $varNames[$i])
			$func &= "&VarsToString_PutVar('" & $varNames[$i] _
			 & "',Eval('" & $varNames[$i] _
			 & "'),IsDeclared('" & $varNames[$i] _
			 & "'),$" & $stringName & ")"
		next
	endif
	return $func
endfunc

func StringToVars($stringName)
	if not IsString($stringName) _
	 then StringToVars_ErrExit('', 'PARAMETER MUST BE STRING')
	if not VarsToString_GetName($stringName) _
	 then StringToVars_ErrExit('', 'BAD STRING NAME $' & $stringName _
	 & ' IN PARAMETER')
	return "Execute(Execute(StringToVars_2('" & $stringName _
	 & "',IsDeclared('" & $stringName _
	 & "'),Eval('" & $stringName & "'))))"
endfunc

func StringToVars_2($stringName, $isDeclared, $string)
	if $isDeclared == 0 then _
	 StringToVars_ErrExit('', 'STRING $' & $stringName & ' NOT FOUND')
	if StringLen($string) <> 0 then _
	 return "StringToVars_3('" & $stringName & "',$" & $stringName _
	  & "," & (1 + ($isDeclared == 1)) & ")"
endfunc

func StringToVars_3($stringName, byref $string, $stringScope)
	local $vars[10]
	$vars[0] = $string
	$string = $stringName & ',' & $string
	local $i = StringLen($stringName) + 2
	local $j
	local $func = "''"
	local $saveAssign
	while TRUE
		$j += 1
		if $j == UBound($vars, 1) then redim $vars[$j + 10]
		local $varName = StringToVars_GetBytes($string, $i, 0)
		if not VarsToString_GetName($varName) _
		 then StringToVars_ErrExit($string)
		local $varScope = StringToVars_GetBytes($string, $i)
		if StringInStr('12', String($varScope)) == 0 _
		 then StringToVars_ErrExit($string)
		local $assign = "&Assign('" & $varName & "',$" & $stringName _
		 & "[" & $j & "]," & $varScope & ")"
		$vars[$j] = StringToVars_GetVar($string, $i)
		if ($varName == $stringName) and ($stringScope >= $varScope) then
		 	$saveAssign = $assign
			if $stringScope > $varScope _
			 then $func &= "&Assign('" & $varName & "',$" & $stringName _
			 & ",1)&Assign('" & $stringName & "',$" & $stringName _
			 & "[0],2)"
		else
			$func &= $assign
		endif
		if $i > StringLen($string) then exitloop
	wend
	if $saveAssign == '' then _
	 $func &= "&Assign('" & $stringName & "',$" & $stringName & "[0])"
	$func &= $saveAssign
	$string = $vars
	return $func
endfunc

func VarsToString_PutVar($name, $value, $isDeclared, byref $string)
	if $name <> '' then
		VarsToString_PutBytes($string, $name)
		VarsToString_PutBytes($string, 1 + ($isDeclared == 1))
	endif
    select
		case IsArray($value)       ;type = 1
			VarsToString_PutArray($value, $string)
		case IsBinaryString($value)
	    	VarsToString_PutBytes($string, 2)
	    	VarsToString_PutBytes($string, $value)
		case IsBool($value)
	    	VarsToString_PutBytes($string, 3)
			VarsToString_PutBytes($string, $value)
		case IsFloat($value)
    		VarsToString_PutBytes($string, 4)
			VarsToString_PutBytes($string, $value)
		case IsHWnd($value)
    		VarsToString_PutBytes($string, 5)
			VarsToString_PutBytes($string, $value, 4)
		case IsInt($value)
			VarsToString_PutBytes($string, 6)
			VarsToString_PutBytes($string, $value, 8)
		case IsKeyword($value)
			VarsToString_PutBytes($string, 7)
		case IsString($value)
	    	VarsToString_PutBytes($string, 9)
	    	VarsToString_PutBytes($string, $value)
	    case else
	    	VarsToString_ErrExit('PARAMETER 1: UNSUPPORTED VAR TYPE' _
	    	 & @CRLF & 'VAR NAME = $' & $name)
    endselect
endfunc

func StringToVars_GetVar($string, byref $i)
	local $type = StringToVars_GetBytes($string, $i)
	local $err = FALSE
    select
		case $type == 1; Array
			local $var = StringToVars_GetArray($string, $i)
		case $type == 2; BinaryString
	    	local $var = StringToVars_GetBytes($string, $i, 0)
	    	$err = StringInStr($var, Chr(0)) == 0
		case $type == 3; Bool
			local $var = StringToVars_GetBytes($string, $i)
			$err = StringInStr('01', String($var)) == 0
			$var = $var <> 0
		case $type == 4; Float
    		local $var = StringToVars_GetBytes($string, $i, 8, 'double')
		case $type == 5; HWnd
    		local $var = HWnd(StringToVars_GetBytes($string, $i, 4))
		case $type == 6; Int
			local $var = StringToVars_GetBytes($string, $i, 8)
		case $type == 7; Keyword (Default only)
			local $var = Default
		case $type == 9; String
	    	local $var = StringToVars_GetBytes($string, $i, 0)
	    	$err = StringInStr($var, Chr(0)) <> 0
	    case else
	    	$err = TRUE
    endselect
    if $err then StringToVars_ErrExit($string)
    return $var
endfunc

func VarsToString_PutArray($array, byref $string)
	VarsToString_PutBytes($string, 1)
	VarsToString_PutBytes($string, UBound($array, 0))
	local $elem = '$array'
	for $i = 0 to UBound($array, 0) - 1
		VarsToString_PutBytes($string, UBound($array, $i + 1), 3)
		$elem &= '[$ix[' & $i & ']]'
	next
    local $ix[UBound($array, 0)]
    while TRUE
		VarsToString_PutVar('', Execute($elem), '', $string)
		for $i = UBound($array, 0) - 1 to 0 step -1
	    	$ix[$i] += 1
	    	if $ix[$i] < UBound($array, $i + 1) then exitloop
	    	if $i = 0 then return
	    	$ix[$i] = 0
		next
    wend
endfunc

func StringToVars_GetArray($string, byref $i)
	local $dims = StringToVars_GetBytes($string, $i)
	if ($dims < 1) or ($dims > 64) then StringToVars_ErrExit($string)
	local $uBound[$dims + 1]
	$uBound[0] = $dims
	local $array
	local $elem = '$array'
	local $ix[$dims]
	local $numElems = 1
	for $j = 0 to $dims - 1
		$uBound[$j + 1] = StringToVars_GetBytes($string, $i, 3)
		if $uBound[$j + 1] < 1 then StringToVars_ErrExit($string)
		$numElems *= $uBound[$j + 1]
		if $numElems > 16000000 then StringToVars_ErrExit($string)
		$elem &= '[$ix[' & $j & ']]'
	next
	StringToVars_MakeArray($array, $uBound)
	if not IsArray($array) then
		$string = StringSplit($string, ',')
		StringToVars_ErrExit('', 'STRING $' & $string[1] _
		 & ' CONTAINS ARRAY WITH TOO MANY (' & $uBound[0] _
		 & ') DIMENSIONS (see Note below)')
	endif
    while TRUE
		Execute('StringToVars_AssignVar(' & $elem _
		 & ',StringToVars_GetVar($string, $i))')
		for $j = $dims - 1 to 0 step -1
	    	$ix[$j] += 1
	    	if $ix[$j] < $uBound[$j + 1] then exitloop
	    	if $j = 0 then return $array
	    	$ix[$j] = 0
		next
    wend
endfunc

func VarsToString_PutBytes(byref $string, $value, $count = 1)
	if IsString($value) or IsBinaryString($value) then
		VarsToString_PutBytes($string, StringLen($value), 4)
		$string &= $value
		return
	endif
	local $struct1 = DllStructCreate(Execute( _
	 StringMid("'uint64''double'", 9 * IsFloat($value), 9)))
	DllStructSetData($struct1, 1, Execute('$value'))
	local $struct2 = DllStructCreate(Execute("'byte[8]'") _
	 , DllStructGetPtr($struct1))
	for $i = 1 to $count + 7 * IsFloat($value)
		$string &= Chr(DllStructGetData($struct2, 1, $i))
	next
	$struct1 = 0
endfunc

func StringToVars_GetBytes($string, byref $i, $count = 1, $ty = 'uint64')
	if $i - 1 + $count > StringLen($string) then _
	 StringToVars_ErrExit($string)
	if $count = 0 then
		local $len = StringToVars_GetBytes($string, $i, 4)
		if ($len < 0) or ($i - 1 + $len > StringLen($string)) then _
		 StringToVars_ErrExit($string)
		$i += $len
		return StringMid($string, $i - $len, $len)
	endif
	local $struct1 = DllStructCreate(Execute( _
	 StringMid("'uint64''double'", 9 * ($ty <> 'uint64'), 9)))
	DllStructSetData($struct1, 1, 0)
	local $struct2 = DllStructCreate(Execute("'byte[8]'") _
	 , DllStructGetPtr($struct1))
	for $j = 1 to $count
		DllStructSetData( _
		 $struct2, 1, Asc(StringMid($string, $i + $j - 1, 1)), $j)
	next
	local $func = DllStructGetData($struct1, 1)
	$struct1 = 0
	$i += $count
	return $func
endfunc

func VarsToString_ErrExit($text)
	local $title = "Execute(VarsToString('$a,b','s'))"
	$text &= @CRLF & @CRLF
 	$text &=  "**Parameter 1 = string with names of Vars" & @CRLF _
 	 & "(Supported Var types are Array, BinaryString, Bool," _
 	 & " Float, HWnd, Int,Keyword, String)" & @CRLF & @CRLF _
 	 & "**Parameter 2 = name of String"
 	MsgBox(16, Execute("$title"), Execute("$text"))
	exit
endfunc

func StringToVars_ErrExit($string, $text = '')
	local $title = "Execute(StringToVars('s'))"
	if $text == '' then
		$string = StringSplit($string, ',')
		$text = 'BAD FORMAT IN STRING $' & $string[1]
	endif
	$text &= @CRLF & @CRLF
 	$text &= "**Parameter = name of String made by VarsToString" _
 	 & @CRLF _
 	 & @CRLF & "Note: To have more dimensions in an Array," _
 	 & @CRLF & "            replace func StringToVars_MakeArray" _
 	 & @CRLF & "            using func StringToVars_MakeMakeArray"
 	MsgBox(16, Execute("$title"), Execute("$text"))
	exit
endfunc

func VarsToString_GetName(byref $name)
	if IsString($name) then
		$name = StringStripWS($name, 8)
		$name = StringMid($name, 1 + (Asc($name) == Asc('$')))
		if StringIsAlNum(StringReplace($name, '_', '0')) then _
		 return TRUE
	endif
	return FALSE
endfunc

func StringToVars_AssignVar(byref $var, $val)
	$var = $val
endfunc

func StringToVars_MakeArray(byref $var, $uBound)
	select
		case $uBound[0] == 1
			dim $var[$uBound[1]]
		case $uBound[0] == 2
			dim $var[$uBound[1]][$uBound[2]]
		case $uBound[0] == 3
			dim $var[$uBound[1]][$uBound[2]][$uBound[3]]
	endselect
endfunc

func StringToVars_MakeMakeArray($maxDim)
	if (not IsInt($maxDim)) or ($maxDim < 1) or ($maxDim > 64) then exit
	local $s = 'func StringToVars_MakeArray(byref $var, $uBound)' & @LF _
	 & '    select' & @LF
	for $i = 1 to $maxDim
		$s &= '        case $uBound[0] == ' & $i & @LF _
		 & '            dim $var'
		for $j = 1 to $i
			$s &= '[$uBound[' & $j & ']]'
		next
		$s &= @LF
	next
	$s &= '    endselect' & @LF & 'endfunc'
	local $PID = Run("c:\windows\notepad.exe", "", @SW_MAXIMIZE)
	while TRUE
		local $list = WinList('Untitled - Notepad')
		for $i = 1 to $list[0][0]
			if Hex(WinGetProcess($list[$i][1])) == Hex($PID) then
				ControlSend($list[$i][1], "", 15, $s)
				exit
			endif
		next
	wend
endfunc

#cs

STRING MAP

(The following table shows how each variable type is stored in the string)

FIELD TYPE              FIELD SIZE (BYTES)   COMMENT

Var Name Length         4                    Only if NOT Array element
Var Name                (== Var Name Length) Only if NOT Array element
Var Scope               1                    Only if NOT Array element
                                              (local == 1, global == 2)
Var Type                1                    (see Type codes below)
String Length           4                    Only if String
Number of Dimensions    1                    Only if Array
Upper Bound of Dim 1    3                    Only if Array
Upper Bound of Dim 2    3                    Only if Array
Upper Bound of Dim 3    3                    Only if Array
(etc.)
Var Value               (varies)             Array        (Var Type == 1)
                        (== String Length)   BinaryString (Var Type == 2)
                        1                    Bool         (Var Type == 3)
                        8                    Float        (Var Type == 4)
                        4                    HWnd         (Var Type == 5)
                        8                    Int          (Var Type == 6)
                        0                    Keyword      (Var Type == 7)
                        (== String Length)   String       (Var Type == 9)
#ce