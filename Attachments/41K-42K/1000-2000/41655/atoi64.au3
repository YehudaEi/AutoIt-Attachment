#comments-start

atoi64.au3

Author: Jim Michaels <jmichae3@yahoo.com>
project Created: 2007
this file created Mar 12, 2009
Current Date: 6/4/2011
Abstract: convert ascii string to signed 64-bit or 63-bit integer.
          integer64 is unsigned and case insensitive.  it can be hexadecimal (start with 0x), decimal (plain number or start with 0d), octal (start with 0, 0q, 0o), binary (start with 0b), and can be appended with SI units (:B :D :DB :H :HB :K :KB :M :MB :G :GB :T :TB :P :PB :E :EB :Z :ZB :Y :YB) or computer units (:Ki :KiB :Mi :MiB :Gi :GiB :Ti :TiB :Pi :PiB :Ei :EiB :Zi :ZiB :Yi :YiB)  as a multiplier suffix. priority will be given to longer suffixes in a stream of printable characters.
          integer63 is signed and case insensitive.  it can start with a - sign and be negative and be in any of the following number formats: it can be hexadecimal (start with 0x), decimal (plain number or start with 0d), octal (start with 0, 0q, 0o), binary (start with 0b), and can be appended with SI units (:B :D :DB :H :HB :K :KB :M :MB :G :GB :T :TB :P :PB :E :EB :Z :ZB :Y :YB) or computer units (:Ki :KiB :Mi :MiB :Gi :GiB :Ti :TiB :Pi :PiB :Ei :EiB :Zi :ZiB :Yi :YiB)  as a multiplier suffix. priority will be given to longer suffixes in a stream of printable characters.
          Returns false for failure and true for success, and also passes back byref the result, a signed or unsigned 64-bit integer.
          The 64-bit limit is Exa.
          It ignores garbage before and behind and also ignores _ inside numbers (perl format for grouping).
                for the unsigned functions, that includes + and -.

          "integer64 is unsigned and case insensitive."&@crlf&"it ignores underscores(_)."&@crlf&" it can be hexadecimal (start with 0x),"&@crlf&"decimal (plain number or start with 0d),"&@crlf&"octal (start with 0, 0q, 0o),"&@crlf&"binary (start with 0b),"&@crlf&"and can be appended with SI units (:B :D :DB :H :HB :K :KB :M :MB :G :GB :T :TB :P :PB :E :EB :Z :ZB :Y :YB)"&@crlf&"or computer units (:Ki :KiB :Mi :MiB :Gi :GiB :Ti :TiB :Pi :PiB :Ei :EiB :Zi :ZiB :Yi :YiB)"&@crlf&" as a multiplier suffix."&@crlf&"priority will be given to longer suffixes in a stream of printable characters."&@crlf
          "integer63 is signed and case insensitive."&@crlf&"it ignores underscores(_)."&@crlf&" it can start with a - sign and be negative"&@crlf&"and be in any of the following number formats:"&@crlf&"it can be hexadecimal (start with 0x),"&@crlf&"decimal (plain number or start with 0d),"&@crlf&"octal (start with 0, 0q, 0o),"&@crlf&"binary (start with 0b),"&@crlf&"and can be appended with SI units (:B :D :DB :H :HB :K :KB :M :MB :G :GB :T :TB :P :PB :E :EB :Z :ZB :Y :YB)"&@crlf&"or computer units (:Ki :KiB :Mi :MiB :Gi :GiB :Ti :TiB :Pi :PiB :Ei :EiB :Zi :ZiB :Yi :YiB)"&@crlf&"as a multiplier suffix."&@crlf&"priority will be given to longer suffixes in a stream of printable characters."&@crlf

Copyright 2007 Jim Michaels
This file is part of atoi64.

    atoi64 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    atoi64 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with phonelist.  If not, see <http://www.gnu.org/licenses/>.

#comments-end

Global Const $ATOI64_LIB_VERSION="2.16"



Global Const $STRPOS_FAILED=0
Global Const $USTRPOS_FAILED=0

global const $atoi64_chars="0123456789ABCDEFabcdefQXqx_-+"


Global Const $iB=1
Global Const $iDB=10
Global Const $iHB=100
Global Const $iKB=1000
Global Const $iKiB=1024
Global Const $iMB=1000000
Global Const $iMiB=1048576
Global Const $iGB=1000000000
Global Const $iGiB=1073741824
Global Const $iTB=1000000000000
Global Const $iTiB=1099511627776
Global Const $iPB=1000000000000000
Global Const $iPiB=1125899906842624
Global Const $iEB=1000000000000000000
Global Const $iEiB=1152921504606846976
Global Const $iZB=1000000000000000000000
Global Const $iZiB=1180591620717411303424
Global Const $iYB=1000000000000000000000000
Global Const $iYiB=1208925819614629174706176


Global Const $uB=1
Global Const $uDB=10
Global Const $uHB=100
Global Const $uKB=1000
Global Const $uKiB=1024
Global Const $uMB=1000000
Global Const $uMiB=1048576
Global Const $uGB=1000000000
Global Const $uGiB=1073741824
Global Const $uTB=1000000000000
Global Const $uTiB=1099511627776
Global Const $uPB=1000000000000000
Global Const $uPiB=1125899906842624
Global Const $uEB=1000000000000000000
Global Const $uEiB=1152921504606846976
Global Const $uZB=1000000000000000000000
Global Const $uZiB=1180591620717411303424
Global Const $uYB=1000000000000000000000000
Global Const $uYiB=1208925819614629174706176


;Func isdigit($c)
; if $c >= '0' and $c <= '9' then return true
; return false
;EndFunc
;replaced with stringisdigit()





#comments-start
returns true for success or false for failure
skips leading and trailing garbage
if cOctalEnabled is true, numbers like 0277 anything starting with 0 and having decimal digits from 0-7 interpreted as octal.
#comments-end
Func atoi64_($str, $cOctalEnabled, $groupCharEnabled, $groupChar, byref $result, byref $startpos, byref $endpos) ;returns true on success, $result is integer
    $str=StringLower($str)
    local $_lc = $str, $ext3="", $ext2="", $ext1="", $s1=$_lc, $s2=$_lc, $s3=$_lc, $_s=$_lc, $ext="";

    local $multiplier=1;
    local $l=StringLen($_s);
    local $_hex="0123456789abcdef";
    local $i=0, $_sign=+1;
    local $c;
    local $_index;
    local $isHex=false;
    local $isOctal=false;
    local $isDecimal=true;
    local $isBinary=false; ;was true
    local $_sign_backup=$_sign;
 	local $foundgarbage=false;
	local $gotresult=false;
	local $found_sign=false;
	local $found=false;
;
    $result=0;
	$startpos=0
	$endpos=0
	do 
		;-----skip and parse leading garbage
		while ($i<=$l)
			;a garbage processor. don't consume digits or sign chars here. consume everything else (garbage). and ignore underscrores (_)
			while ($i <= $l and ('_'==StringMid($_s,$i,1) or (not stringisdigit(StringMid($_s,$i,1)) and '-'<>StringMid($_s, $i, 1) and '+'<>StringMid($_s, $i, 1))))
				$i+=1;
			wend
			;msgbox(0,"yay!","made it past 1st while")
			;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
			;don't consume digits here.
			$_sign_backup = $_sign
			$found_sign=false;
			while ($i <= $l and ('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)  or '_'==StringMid($_s, $i, 1) or  (not stringisdigit(StringMid($_s, $i, 1)))))
				if     ('-'==StringMid($_s, $i, 1)) then
					if (0=$startpos) then
						$startpos=$i
					endif
					$_sign*=-1;
					$i+=1;
					$found_sign=true;
				elseif ('+'==StringMid($_s, $i, 1)) then
					if (0=$startpos) then
						$startpos=$i
					endif
					$_sign*=+1;
					$i+=1;
					$found_sign=true;
				elseif ('_'==StringMid($_s, $i, 1)) then
					;ignore the underscore, skip past it
					$i+=1;
				else
					$startpos=0
					$found_sign=false;
					$_sign = $_sign_backup
					;garbage
					;$i+=1;
					exitloop;
				endif
			wend
			;msgbox(0,"yay!","made it past 2nd while")
			;at this point, either $i>$l or we hit a digit...
			if (stringisdigit(StringMid($_s, $i, 1))) then
					if (0=$startpos) then
						$startpos=$i
					endif
				;let the rest of the program process it
				if ($found_sign) then
					;-----previous char was a sign, and this char is a digit
					exitloop;
				else
					;-----previous char was garbage and this char is a digit.
					exitloop;
				endif
			elseif (('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)) and $i=$l) then
				;any - or + now and we hit the end of the string, any comparison with end of string is probably unnecessary.
				;ugh. it was a whole line of -------- or ++++++++
				;must be last character. fail.
				$startpos=0
				$endpos=0
				return false;
			else
				;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
				;$_sign = $_sign_backup
				;if ($i = $l) then
				;    ;-----if at end of string, bail out now, it was all garbage.
				;    return false;
				;else
				;    continueloop;
				;endif
			endif
		wend
		if ($i > $l) then
			return false;problem
		endif
		;interpret modes. the intention is to point i at the first digit character, if possible.
		if        ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'x'==StringMid($_s, $i+1, 1))       )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isHex=true;
			$isDecimal=false;
			$isOctal=false;
			$isBinary=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'b'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isBinary=true;
			$isDecimal=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'd'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isBinary=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'o'==StringMid($_s, $i+1, 1)) or ('0'==StringMid($_s, $i, 1) and 'q'==StringMid($_s, $i+1, 1))   )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isBinary=false;
			$isDecimal=false;
			$isHex=false;
			$i+=2;
		elseif  ($l>=1 and ('0'==StringMid($_s, $i, 1)) and $cOctalEnabled) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isHex=false;
			$isDecimal=false;
			$isBinary=false;
			$i+=1;
			if (1==$l) then ;//interpret plain 0 as a 0.
				$result=0
				return true;success
			endif
		elseif (stringisdigit(StringMid($_s, $i, 1))) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isHex=false;
			$isOctal=false;
			$isBinary=false;
		else
			;//we don't know what this is.  silently return an error.
			return false;
		endif
		;can have leading signs between 0x and 5 such as 0x_-+-_+--___--5
		while ($i<$l and ('+'==StringMid($_s, $i, 1) or '-' == StringMid($_s, $i, 1) or '_' == StringMid($_s, $i, 1))) 
			if ('_'==StringMid($_s, $i, 1)) then
				;ignore character
				$i+=1;
			elseif ('+'==StringMid($_s, $i, 1)) then
				;ignore sign
				$i+=1;
			elseif ('-'==StringMid($_s, $i, 1)) then
				;change sign
				$_sign = -$_sign;
				$i+=1;
			endif
		wend
		;process digits
		while ($i <= $l)
			$c=StringMid($_s, $i, 1);
			if ('_'==$c or ($groupCharEnabled and $c==$groupChar)) then
				;-----ignore the character
				$i+=1;
			elseif ($isBinary) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 2+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*2+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isOctal) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 8+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*8+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isDecimal) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 10+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*10+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isHex) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*16+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			else
				;-----stop at $i
				$foundgarbage=true;
				ExitLoop
			endif
		wend


		;process suffix
		local $found=false;
		if (not $found and StringLen($_lc)-$i+1 >= 1+3) then
			$ext3 = StringMid($s3, $i, 3+1) ;//next 3+1 characters
			$s3=StringMid($s3, 1, $i-1);//str without next 3+1 characters
			if (not $found and ":kib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iKiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":mib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iMiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":gib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iGiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":tib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iTiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":pib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iPiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":eib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iEiB;
				$found=true;
				$endpos=$i+1+2;
				$endpos=$i+1+3;
			elseif (not $found and ":zib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iZiB;
				$found=true;
				$endpos=$i+1+2;
				$endpos=$i+1+3;
			elseif (not $found and ":yib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iYiB;
				$found=true;
				$endpos=$i+1+3;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+2) then
			$ext2 = StringMid($s2, $i, 2+1) ;//next 2+1 characters
			$s2=StringMid($s2, 1, $i-1);//str without next 2+1 characters
			if (not $found and ":db"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iDB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":hb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iHB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":kb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iKB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":mb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iMB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":gb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iGB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":tb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iTB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":pb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iPB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":eb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iEB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":zb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iZB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":yb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iYB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ki"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iKiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":mi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iMiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":gi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iGiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ti"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iTiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":pi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iPiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ei"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iEiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":zi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iZiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":yi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iYiB;
				$found=true;
				$endpos=$i+1+2;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+1) then
			local $ext1 = StringMid($s1, $i, 1+1) ;//next 1+1 character
			$s1=StringMid($s1, 1, $i-1);//str without next 1+1 character

			if (not $found and ":b"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":d"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iDB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":h"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iHB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":k"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iKB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":m"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iMB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":g"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iGB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":t"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iTB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":p"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iPB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":e"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iEB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":z"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iZB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":y"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iYB;
				$found=true;
				$endpos=$i+1+1;
			endif
		endif
		
		
		if ((not $found) and $foundgarbage) then
			;then it truly was garbage found on the input.
			$multiplier=0;
			$found=false;
			$result=0;
			$_sign=1;
			$foundgarbage=false;
		elseif ($found) then
			$i = $endpos;
			exitloop;
		endif
		
	until (not((not $gotresult) and $i<$l));

    $result *= $multiplier;
    $result *= $_sign;
    return true;success
endfunc







#comments-start
returns true for success or false for failure
skips leading and trailing garbage
if cOctalEnabled is true, numbers like 0277 anything starting with 0 and having decimal digits from 0-7 interpreted as octal.
#comments-end
Func atou64_($str, $cOctalEnabled, $groupCharEnabled, $groupChar, byref $result, byref $startpos, byref $endpos) ;returns true on success, $result is unsigned integer
    $str=StringLower($str)
    local $_lc = $str, $ext3="", $ext2="", $ext1="", $s1=$_lc, $s2=$_lc, $s3=$_lc, $_s=$_lc, $ext="";

    local $multiplier=1;
    local $l=StringLen($_s);
    local $_hex="0123456789abcdef";
    local $i=1;
    local $c=chr(0);
    local $_index=0;
    local $isHex=false;
    local $isOctal=false;
    local $isDecimal=true;
    local $isBinary=false; ;was true
    ;local $_sign_backup=$_sign;
 	local $foundgarbage=false;
	local $gotresult=false;
	local $found_sign=false;
	local $found=false;
	
    $result=0
	$startpos=0
	$endpos=0
	do
		;-----skip and parse leading garbage
		while ($i<=$l)
			;a garbage processor. don't consume digits or sign chars here. consume everything else (garbage). and ignore underscrores (_)
			while ($i <= $l and ('_'==StringMid($_s,$i,1) or (not stringisdigit(StringMid($_s,$i,1)))))
				$i+=1;
			wend
			;msgbox(0,"yay!","made it past 1st while")
			;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
			;don't consume digits here.
			;$_sign_backup = $_sign
			;$found_sign=false;
			;while ($i <= $l and '_'==StringMid($_s, $i, 1) and (not stringisdigit(StringMid($_s, $i, 1))))
			;	if ('_'==StringMid($_s, $i, 1)) then
			;		;ignore the underscore, skip past it
			;		$i+=1;
			;	else
			;		;garbage
			;		exitloop;
			;	endif
			;wend
			;msgbox(0,"yay!","made it past 2nd while")
			;at this point, either $i>$l or we hit a digit...
			if ($i<=$l and stringisdigit(StringMid($_s, $i, 1))) then
				;let the rest of the program process it
				exitloop;
			else
				;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
			endif
		wend
		if ($i > $l) then
			$startpos=0
			$endpos=0
			return false;problem
		endif
		;handle negative sign
		;if ('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)) then
		;	$startpos=0
		;	$endpos=0
		;    return false; error
		;endif
		;interpret modes. the intention is to point i at the first digit character, if possible.
		if        ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'x'==StringMid($_s, $i+1, 1))       )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isHex=true;
			$isDecimal=false;
			$isOctal=false;
			$isBinary=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'b'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isBinary=true;
			$isDecimal=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'd'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isBinary=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'o'==StringMid($_s, $i+1, 1))    or('0'==StringMid($_s, $i, 1) and 'q'==StringMid($_s, $i+1, 1))        )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isBinary=false;
			$isDecimal=false;
			$isHex=false;
			$i+=2;
		elseif ($l>=1 and  ('0'==StringMid($_s, $i, 1)) and $cOctalEnabled) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isHex=false;
			$isDecimal=false;
			$isBinary=false;
			$i+=1;
			if (1==$l) then ;;//interpret plain 0 as a 0.
				$result=0
				return true;success
			endif
		elseif (stringisdigit(StringMid($_s, $i, 1))) then
			if (0=$startpos) then 
				$startpos = $i
			endif
			$isDecimal=true;
			$isHex=false;
			$isOctal=false;
			$isBinary=false;
		else
			;;//we don't know what this is.  silently return an error.
			return false;failure
		endif
		;process digits
		while ($i <= $l)
			$c=StringMid($_s, $i, 1)
			if ('_'==$c or ($groupCharEnabled and $c==$groupChar)) then
				;-----ignore the character
				$i+=1;
			elseif ($isBinary) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 2+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*2+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isOctal) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 8+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*8+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isDecimal) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 10+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*10+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isHex) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*16+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			else
				;-----stop at $i
				$foundgarbage=true;
				ExitLoop
			endif
		wend


		;process suffix
		local $found=false;
		if (not $found and StringLen($_lc)-$i+1 >= 1+3) then
			$ext3 = StringMid($s3, $i, 3+1) ;//next 3+1 characters
			$s3=StringMid($s3, 1, $i-1);//str without next 3+1 characters
			if (not $found and ":kib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uKiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":mib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uMiB;
				$found=true;
					$endpos=$i+1+3;
		   elseif (not $found and ":gib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uGiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":tib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uTiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":pib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uPiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":eib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uEiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":zib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uZiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":yib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uYiB;
				$found=true;
					$endpos=$i+1+3;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+2) then
			$ext2 = StringMid($s2, $i, 2+1) ;//next 2+1 characters
			$s2=StringMid($s2, 1, $i-1);//str without next 2+1 characters
			if (not $found and ":db"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uDB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":hb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uHB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":kb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uKB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":mb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uMB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":gb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uGB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":tb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uTB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":pb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uPB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":eb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uEB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":zb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uZB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":yb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uYB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ki"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uKiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":mi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uMiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":gi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uGiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ti"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uTiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":pi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uPiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ei"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uEiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":zi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uZiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":yi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uYiB;
				$found=true;
					$endpos=$i+1+2;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+1) then
			local $ext1 = StringMid($s1, $i, 1+1) ;//next 1+1 character
			$s1=StringMid($s1, 1, $i-1);//str without next 1+1 character

			if (not $found and ":b"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":d"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uDB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":h"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uHB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":k"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uKB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":m"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uMB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":g"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uGB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":t"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uTB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":p"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uPB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":e"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uEB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":z"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uZB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":y"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uYB;
				$found=true;
					$endpos=$i+1+1;
			endif
		endif
		
		if ((not $found) and $foundgarbage) then
			;then it truly was garbage found on the input.
			$multiplier=0;
			$found=false;
			$result=0;
			$foundgarbage=false;
		elseif ($found) then
			$i = $endpos;
			exitloop;
		endif
	until (not((not $gotresult) and $i<$l));



    $result *= $multiplier;
    return true;success
endfunc


;---------------------------------------------------------------------------

#comments-start
returns true for success or false for failure
optionally skips leading garbage, and always skips trailing garbage
if cOctalEnabled is true, numbers like 0277 anything starting with 0 and having decimal digits from 0-7 interpreted as octal.
#comments-end
Func atoi64pg($str, $cOctalEnabled, $groupCharEnabled, $groupChar, byref $result, byref $startpos, byref $endpos, $enablePreGarbageStripping) ;returns true on success, $result is integer
    $str=StringLower($str)
    local $_lc = $str, $ext3="", $ext2="", $ext1="", $s1=$_lc, $s2=$_lc, $s3=$_lc, $_s=$_lc, $ext="";

    local $multiplier=1;
    local $l=StringLen($_s);
    local $_hex="0123456789abcdef";
    local $i=0, $_sign=+1;
    local $c;
    local $_index;
    local $isHex=false;
    local $isOctal=false;
    local $isDecimal=true;
    local $isBinary=false; ;was true
    local $_sign_backup=$_sign;
 	local $foundgarbage=false;
	local $gotresult=false;
	local $found_sign=false;
	local $found=false;
;
    $result=0;
	$startpos=0
	$endpos=0
	do 
		;-----skip and parse leading garbage]
		if ($enablePreGarbageStripping) then
			while ($i<=$l)
				;a garbage processor. don't consume digits or sign chars here. consume everything else (garbage). and ignore underscrores (_)
				while ($i <= $l and ('_'==StringMid($_s,$i,1) or (not stringisdigit(StringMid($_s,$i,1)) and '-'<>StringMid($_s, $i, 1) and '+'<>StringMid($_s, $i, 1))))
					$i+=1;
				wend
				;msgbox(0,"yay!","made it past 1st while")
				;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
				;don't consume digits here.
				$_sign_backup = $_sign
				$found_sign=false;
				while ($i <= $l and ('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)  or '_'==StringMid($_s, $i, 1) or  (not stringisdigit(StringMid($_s, $i, 1)))))
					if     ('-'==StringMid($_s, $i, 1)) then
						if (0=$startpos) then
							$startpos=$i
						endif
						$_sign*=-1;
						$i+=1;
						$found_sign=true;
					elseif ('+'==StringMid($_s, $i, 1)) then
						if (0=$startpos) then
							$startpos=$i
						endif
						$_sign*=+1;
						$i+=1;
						$found_sign=true;
					elseif ('_'==StringMid($_s, $i, 1)) then
						;ignore the underscore, skip past it
						$i+=1;
					else
						$startpos=0
						$found_sign=false;
						$_sign = $_sign_backup
						;garbage
						;$i+=1;
						exitloop;
					endif
				wend
				;msgbox(0,"yay!","made it past 2nd while")
				;at this point, either $i>$l or we hit a digit...
				if (stringisdigit(StringMid($_s, $i, 1))) then
						if (0=$startpos) then
							$startpos=$i
						endif
					;let the rest of the program process it
					if ($found_sign) then
						;-----previous char was a sign, and this char is a digit
						exitloop;
					else
						;-----previous char was garbage and this char is a digit.
						exitloop;
					endif
				elseif (('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)) and $i=$l) then
					;any - or + now and we hit the end of the string, any comparison with end of string is probably unnecessary.
					;ugh. it was a whole line of -------- or ++++++++
					;must be last character. fail.
					$startpos=0
					$endpos=0
					return false;
				else
					;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
					;$_sign = $_sign_backup
					;if ($i = $l) then
					;    ;-----if at end of string, bail out now, it was all garbage.
					;    return false;
					;else
					;    continueloop;
					;endif
				endif
			wend
		else
			;process signs and garbage.
			;msgbox("yay! made it past 1st while")
			;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
			;don't consume digits here.
			$_sign_backup = $_sign;
			$found_sign=false;
			;loop if not past end of string and is a + or - or _ and not a digit. sign and garbage.
			while ($i < $l and ('-'==stringmid($_s,$i,1) or '+'==stringmid($_s,$i,1)  or '_'==stringmid($_s,$i,1) or (not (stringisdigit(stringmid($_s,$i,1))))))
				if        ('-'==stringmid($_s,$i,1)) then
					if (0=$startpos) then
						$startpos = $i;
					endif
					$_sign*=-1;
					$i=$i+1;
					$found_sign=true;
				elseif ('+'==stringmid($_s,$i,1)) then
					if (0=$startpos) then
						$startpos = $i;
					endif
					$_sign*=+1;
					$i=$i+1;
					$found_sign=true;
				elseif ('_'==stringmid($_s,$i,1)) then
					;ignore the underscore, skip past it
					$i=$i+1;
				else
					$startpos=0;
					$found_sign=false;
					$_sign = $_sign_backup; //got garbage. cause current value of sign to revert to backup before this particular loop started.
					;garbage
					;$i=$i+1;
					exitloop
				endif
			wend ;while ($i < $l and ('-'==stringmid($_s,$i,1) or '+'==stringmid($_s,$i,1)  or '_'==stringmid($_s,$i,1) or (not(stringisdigit(stringmid($_s,$i,1))))))
			;process digits and signs and garbage
			;alert("yay! made it past 2nd while")
			;at this point, either i>l or we hit a digit...
			if (stringisdigit(stringmid($_s,$i,1))) then
				if (0=$startpos) then 
					$startpos = $i;
				endif
				;let the rest of the program process it
				if ($found_sign) then
					;break;-----previous char was a sign, and this char is a digit
				else 
					;break;-----previous char was garbage and this char is a digit.
				endif
			elseif (('-'==stringmid($_s,$i,1) or '+'==stringmid($_s,$i,1)) and $i == $l) then
				;any - or + now and we hit the end of the string, any comparison with end of string is probably unnecessary.
				;huh. it was a whole line of -------- or ++++++++
				;must be last character. fail.
				;return new Array(0,false,-1,-1);
				$result=0
				$startpos=0
				$endpos=0
				return false
			else
				;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
				;$_sign = $_sign_backup
				;if ($i = $l) then
				;    //-----if at end of string, bail out now, it was all garbage.
				;    return false
				;else
				;    continueloop
				;endif
			endif
		endif
		if ($i > $l) then
			return false;problem
		endif
		;interpret modes. the intention is to point i at the first digit character, if possible.
		if        ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'x'==StringMid($_s, $i+1, 1))       )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isHex=true;
			$isDecimal=false;
			$isOctal=false;
			$isBinary=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'b'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isBinary=true;
			$isDecimal=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'd'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isBinary=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'o'==StringMid($_s, $i+1, 1)) or ('0'==StringMid($_s, $i, 1) and 'q'==StringMid($_s, $i+1, 1))   )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isBinary=false;
			$isDecimal=false;
			$isHex=false;
			$i+=2;
		elseif  ($l>=1 and ('0'==StringMid($_s, $i, 1)) and $cOctalEnabled) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isHex=false;
			$isDecimal=false;
			$isBinary=false;
			$i+=1;
			if (1==$l) then ;//interpret plain 0 as a 0.
				$result=0
				return true;success
			endif
		elseif (stringisdigit(StringMid($_s, $i, 1))) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isHex=false;
			$isOctal=false;
			$isBinary=false;
		else
			;//we don't know what this is.  silently return an error.
			return false;
		endif
		;can have leading signs between 0x and 5 such as 0x_-+-_+--___--5
		while ($i<$l and ('+'==StringMid($_s, $i, 1) or '-' == StringMid($_s, $i, 1) or '_' == StringMid($_s, $i, 1))) 
			if ('_'==StringMid($_s, $i, 1)) then
				;ignore character
				$i+=1;
			elseif ('+'==StringMid($_s, $i, 1)) then
				;ignore sign
				$i+=1;
			elseif ('-'==StringMid($_s, $i, 1)) then
				;change sign
				$_sign = -$_sign;
				$i+=1;
			endif
		wend
		;process digits
		while ($i <= $l)
			$c=StringMid($_s, $i, 1);
			if ('_'==$c or ($groupCharEnabled and $c==$groupChar)) then
				;-----ignore the character
				$i+=1;
			elseif ($isBinary) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 2+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*2+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isOctal) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 8+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*8+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isDecimal) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index or $_index >= 10+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*10+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isHex) then
				$_index=StringInStr($_hex, $c, 0,1);
				if ($STRPOS_FAILED==$_index) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*16+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			else
				;-----stop at $i
				$foundgarbage=true;
				ExitLoop
			endif
		wend


		;process suffix
		local $found=false;
		if (not $found and StringLen($_lc)-$i+1 >= 1+3) then
			$ext3 = StringMid($s3, $i, 3+1) ;//next 3+1 characters
			$s3=StringMid($s3, 1, $i-1);//str without next 3+1 characters
			if (not $found and ":kib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iKiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":mib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iMiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":gib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iGiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":tib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iTiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":pib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iPiB;
				$found=true;
				$endpos=$i+1+3;
			elseif (not $found and ":eib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iEiB;
				$found=true;
				$endpos=$i+1+2;
				$endpos=$i+1+3;
			elseif (not $found and ":zib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iZiB;
				$found=true;
				$endpos=$i+1+2;
				$endpos=$i+1+3;
			elseif (not $found and ":yib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$iYiB;
				$found=true;
				$endpos=$i+1+3;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+2) then
			$ext2 = StringMid($s2, $i, 2+1) ;//next 2+1 characters
			$s2=StringMid($s2, 1, $i-1);//str without next 2+1 characters
			if (not $found and ":db"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iDB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":hb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iHB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":kb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iKB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":mb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iMB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":gb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iGB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":tb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iTB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":pb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iPB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":eb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iEB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":zb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iZB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":yb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iYB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ki"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iKiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":mi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iMiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":gi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iGiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ti"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iTiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":pi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iPiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":ei"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iEiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":zi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iZiB;
				$found=true;
				$endpos=$i+1+2;
			elseif (not $found and ":yi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$iYiB;
				$found=true;
				$endpos=$i+1+2;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+1) then
			local $ext1 = StringMid($s1, $i, 1+1) ;//next 1+1 character
			$s1=StringMid($s1, 1, $i-1);//str without next 1+1 character

			if (not $found and ":b"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":d"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iDB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":h"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iHB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":k"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iKB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":m"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iMB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":g"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iGB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":t"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iTB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":p"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iPB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":e"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iEB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":z"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iZB;
				$found=true;
				$endpos=$i+1+1;
			elseif (not $found and ":y"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$iYB;
				$found=true;
				$endpos=$i+1+1;
			endif
		endif
		
		
		if ((not $found) and $foundgarbage) then
			;then it truly was garbage found on the input.
			$multiplier=0;
			$found=false;
			$result=0;
			$_sign=1;
			$foundgarbage=false;
		elseif ($found) then
			$i = $endpos;
			exitloop;
		endif
		
	until (not((not $gotresult) and $i<$l));

    $result *= $multiplier;
    $result *= $_sign;
    return true;success
endfunc







#comments-start
returns true for success or false for failure
optionally skips leading garbage, and always trailing garbage
if cOctalEnabled is true, numbers like 0277 anything starting with 0 and having decimal digits from 0-7 interpreted as octal.
#comments-end
Func atou64pg($str, $cOctalEnabled, $groupCharEnabled, $groupChar, byref $result, byref $startpos, byref $endpos, $enablePreGarbageStripping) ;returns true on success, $result is unsigned integer
    $str=StringLower($str)
    local $_lc = $str, $ext3="", $ext2="", $ext1="", $s1=$_lc, $s2=$_lc, $s3=$_lc, $_s=$_lc, $ext="";

    local $multiplier=1;
    local $l=StringLen($_s);
    local $_hex="0123456789abcdef";
    local $i=1;
    local $c=chr(0);
    local $_index=0;
    local $isHex=false;
    local $isOctal=false;
    local $isDecimal=true;
    local $isBinary=false; ;was true
    ;local $_sign_backup=$_sign;
 	local $foundgarbage=false;
	local $gotresult=false;
	local $found_sign=false;
	local $found=false;
	
    $result=0
	$startpos=0
	$endpos=0
	do
		;-----skip and parse leading garbage
		if ($enablePreGarbageStripping) then
			while ($i<=$l)
				;a garbage processor. don't consume digits or sign chars here. consume everything else (garbage). and ignore underscrores (_)
				while ($i <= $l and ('_'==StringMid($_s,$i,1) or (not stringisdigit(StringMid($_s,$i,1)))))
					$i+=1;
				wend
				;msgbox(0,"yay!","made it past 1st while")
				;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
				;don't consume digits here.
				;$_sign_backup = $_sign
				;$found_sign=false;
				;while ($i <= $l and '_'==StringMid($_s, $i, 1) and (not stringisdigit(StringMid($_s, $i, 1))))
				;	if ('_'==StringMid($_s, $i, 1)) then
				;		;ignore the underscore, skip past it
				;		$i+=1;
				;	else
				;		;garbage
				;		exitloop;
				;	endif
				;wend
				;msgbox(0,"yay!","made it past 2nd while")
				;at this point, either $i>$l or we hit a digit...
				if ($i<=$l and stringisdigit(StringMid($_s, $i, 1))) then
					;let the rest of the program process it
					exitloop;
				else
					;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
				endif
			wend
		else
			;process garbage and _ up to a digit.
			;don't consume digits or sign chars here. consume everything else (garbage). and ignore underscrores (_)
			;now at digit.
			#comments-start
			;process garbage and _
			;alert("yay! made it past 1st while")
			;handle sign. a sign can be followed by any number of sign but must be followed by a digit to be valid, otherwise it's garbage and must be tossed, but preferably by the garbage processor above.
			;don't consume digits here.
			;$_sign_backup = $_sign
			;$found_sign=false;
			while ($i <= $l and '_'==StringMid($_s, $i, 1) and (not (stringisdigit(StringMid($_s, $i, 1))))) 
				if ('_'==StringMid($_s, $i, 1)) then
					;ignore the underscore, skip past it
					$i=$i+1
				else
					;garbage
					exitloop
				endif
			wend
			;alert("yay! made it past 2nd while")
			#comments-end
			;at this point, either $i>$l or we hit a digit...
			if ($i < $l and stringisdigit(StringMid($_s, $i, 1))) then
				;let the rest of the program process it
				;break;
			else
				;-----it's garbage. just go through the main loop again. and while we are at it,restore the sign, because what we did was useless.
			endif			
		endif
		if ($i > $l) then
			$startpos=0
			$endpos=0
			return false;problem
		endif
		;handle negative sign
		;if ('-'==StringMid($_s, $i, 1) or '+'==StringMid($_s, $i, 1)) then
		;	$startpos=0
		;	$endpos=0
		;    return false; error
		;endif
		;interpret modes. the intention is to point i at the first digit character, if possible.
		if        ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'x'==StringMid($_s, $i+1, 1))       )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isHex=true;
			$isDecimal=false;
			$isOctal=false;
			$isBinary=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'b'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isBinary=true;
			$isDecimal=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'd'==StringMid($_s, $i+1, 1))          )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isDecimal=true;
			$isBinary=false;
			$isHex=false;
			$isOctal=false;
			$i+=2;
		elseif ($l>=2 and (('0'==StringMid($_s, $i, 1) and 'o'==StringMid($_s, $i+1, 1))    or('0'==StringMid($_s, $i, 1) and 'q'==StringMid($_s, $i+1, 1))        )) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isBinary=false;
			$isDecimal=false;
			$isHex=false;
			$i+=2;
		elseif ($l>=1 and  ('0'==StringMid($_s, $i, 1)) and $cOctalEnabled) then
			if (0=$startpos) then
				$startpos=$i
			endif
			$isOctal=true;
			$isHex=false;
			$isDecimal=false;
			$isBinary=false;
			$i+=1;
			if (1==$l) then ;;//interpret plain 0 as a 0.
				$result=0
				return true;success
			endif
		elseif (stringisdigit(StringMid($_s, $i, 1))) then
			if (0=$startpos) then 
				$startpos = $i
			endif
			$isDecimal=true;
			$isHex=false;
			$isOctal=false;
			$isBinary=false;
		else
			;;//we don't know what this is.  silently return an error.
			return false;failure
		endif
		;process digits
		while ($i <= $l)
			$c=StringMid($_s, $i, 1)
			if ('_'==$c or ($groupCharEnabled and $c==$groupChar)) then
				;-----ignore the character
				$i+=1;
			elseif ($isBinary) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 2+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*2+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isOctal) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 8+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*8+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isDecimal) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index or $_index >= 10+1) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*10+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			elseif ($isHex) then
				$_index=StringInStr($_hex,$c,0,1);
				if ($USTRPOS_FAILED==$_index) then
					;return 0; ;//if garbage, assume 0
					ExitLoop
				endif
				$result=$result*16+$_index-1;
				$i+=1;
				$endpos=$i;
				$gotresult=true;
			else
				;-----stop at $i
				$foundgarbage=true;
				ExitLoop
			endif
		wend


		;process suffix
		local $found=false;
		if (not $found and StringLen($_lc)-$i+1 >= 1+3) then
			$ext3 = StringMid($s3, $i, 3+1) ;//next 3+1 characters
			$s3=StringMid($s3, 1, $i-1);//str without next 3+1 characters
			if (not $found and ":kib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uKiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":mib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uMiB;
				$found=true;
					$endpos=$i+1+3;
		   elseif (not $found and ":gib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uGiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":tib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uTiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":pib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uPiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":eib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uEiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":zib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uZiB;
				$found=true;
					$endpos=$i+1+3;
			elseif (not $found and ":yib"==$ext3) then
				$ext=$ext3;
				$_s=$s3;
				$multiplier=$uYiB;
				$found=true;
					$endpos=$i+1+3;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+2) then
			$ext2 = StringMid($s2, $i, 2+1) ;//next 2+1 characters
			$s2=StringMid($s2, 1, $i-1);//str without next 2+1 characters
			if (not $found and ":db"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uDB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":hb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uHB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":kb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uKB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":mb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uMB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":gb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uGB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":tb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uTB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":pb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uPB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":eb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uEB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":zb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uZB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":yb"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uYB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ki"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uKiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":mi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uMiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":gi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uGiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ti"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uTiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":pi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uPiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":ei"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uEiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":zi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uZiB;
				$found=true;
					$endpos=$i+1+2;
			elseif (not $found and ":yi"==$ext2) then
				$ext=$ext2;
				$_s=$s2;
				$multiplier=$uYiB;
				$found=true;
					$endpos=$i+1+2;
			endif
		endif

		if (not $found and StringLen($_lc)-$i+1 >= 1+1) then
			local $ext1 = StringMid($s1, $i, 1+1) ;//next 1+1 character
			$s1=StringMid($s1, 1, $i-1);//str without next 1+1 character

			if (not $found and ":b"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":d"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uDB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":h"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uHB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":k"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uKB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":m"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uMB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":g"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uGB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":t"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uTB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":p"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uPB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":e"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uEB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":z"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uZB;
				$found=true;
					$endpos=$i+1+1;
			elseif (not $found and ":y"==$ext1) then
				$ext=$ext1;
				$_s=$s1;
				$multiplier=$uYB;
				$found=true;
					$endpos=$i+1+1;
			endif
		endif
		
		if ((not $found) and $foundgarbage) then
			;then it truly was garbage found on the input.
			$multiplier=0;
			$found=false;
			$result=0;
			$foundgarbage=false;
		elseif ($found) then
			$i = $endpos;
			exitloop;
		endif
	until (not((not $gotresult) and $i<$l));



    $result *= $multiplier;
    return true;success
endfunc



