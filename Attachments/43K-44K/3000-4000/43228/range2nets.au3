
#include <array.au3>

;done by Jakob Schoormann   , 28 January 2014
;         teaware by schoormann@gmail.com

$again = true   ;enter again
while $again
	$bla =  "returns all IP networks (classless) " & @crlf & _
			"contained within an IP range"& @crlf & _
			"Enter range like : 144.16.2.7-144.16.5.10"
	$start=inputbox("please enter the range",$bla)
	$arr = stringsplit($start,"-")
	if not isarray($arr) then $again = True
	$start = stringstripws($arr[1],3)
	$stop =  stringstripws($arr[2],3)
	$a = ip2num($start) ;calculate once
	$b = ip2num($stop)
	if isint($a) and isint($b) and $b >= $a then $again = false
wend

$tstarr = ran2netarr($start,$stop)
_arraydisplay($tstarr,"Networks")
;-------------------------------------------------------------- return array with networks representing a range ---------------------------------
func ran2netarr($start,$stop)     ;entered as strings in ip form

local $retarr
dim $retarr[2][2]
$retarr[0][0] = 0

local $nettable		 ;static table defining network segments
local $modwert = 0   ;modulo value within array $nettable
local $mask = 1		 ;and corresponding netmask
dim $nettable[33][2] = [ _
						[32,""], _
						[0x7fffffff,"128.0.0.0"], _
						[0x3fffffff,"192.0.0.0"], _
						[0x1fffffff,"224.0.0.0"], _
						[0xfffffff,"240.0.0.0"], _
						[0x7ffffff,"248.0.0.0"], _
						[0x3ffffff,"252.0.0.0"], _
						[0x1ffffff,"254.0.0.0"], _
						[0xffffff,"255.0.0.0"], _
						[0x7fffff,"255.128.0.0"], _
						[0x3fffff,"255.192.0.0"], _
						[0x1fffff,"255.224.0.0"], _
						[0xfffff,"255.240.0.0"], _
						[0x7ffff,"255.248.0.0"], _
						[0x3ffff,"255.252.0.0"], _
						[0x1ffff,"255.254.0.0"], _
						[0xffff,"255.255.0.0"], _
						[0x7fff,"255.255.128.0"], _
						[0x3fff,"255.255.192.0"], _
						[0x1fff,"255.255.224.0"], _
						[0xfff,"255.255.240.0"], _
						[0x7ff,"255.255.248.0"], _
						[0x3ff,"255.255.252.0"], _
						[0x1ff,"255.255.254.0"], _
						[0xff,"255.255.255.0"], _
						[0x7f,"255.255.255.128"], _
						[0x3f,"255.255.255.192"], _
						[0x1f,"255.255.255.224"], _
						[0xf,"255.255.255.240"], _
						[0x7,"255.255.255.248"], _
						[0x3,"255.255.255.252"], _
						[0x1,"255.255.255.254"], _
						[0,"255.255.255.255"] _
					   ]
local $beg = ip2num($start)				;convert ip to large integer
local $end = ip2num($stop)

local $current
while 1
	;try if you are at a beginning of a network segment and try the biggest segment if it fits within the distance
	;if not yet try the next smaller net .. at least the smalles segment -> a hostmask <--- will fit
	;if     .. convert this 'discovered beginning number' to IP aquivalent and move forward the whole length of the discovered net
	;do so until you got to the end
	for $current = 1 to $nettable[0][0]
		if mod($beg,$nettable[$current][$modwert]+1) = 0 and _
		   $end >= ($beg + ($nettable[$current][$modwert])) Then		;a net is beginning here and rest is big enough
			$retarr[0][0] +=1											;blow array up
			redim $retarr[$retarr[0][0]+1 ][2]
			$retarr[$retarr[0][0]][0] = int2ip($beg)					;store findings
			$retarr[$retarr[0][0]][1] = $nettable[$current][$mask]
			$beg = $beg + $nettable[$current][$modwert] +1				;calculat the beginning of the new network
			exitloop													;and start anew with the 'longest'
		endif
	next
	;_arraydisplay($retarr,$beg & ":" & $end)  							;watch it growing
	if $beg >= $end then return $retarr
wend
endfunc
;---------------------------------------------------------------------------- sub functions ----------------------------------------------------------------------------
func int2ip($large)

	local $s1,$s2,$s3,$rest
	$s1 = int($large/16777216)            ;how often is 2^24 within -> first octett
	$rest = $large -($s1 * 16777216)

	$s2 = int($rest/65536)				 ;how often is 2^24 in the rest -> second octett
	$rest = $rest -($s2 * 65536)

	$s3 = int($rest/256)				 ;and 2^8 -> third octett ,
										 ;rest goes to the 4 octett

	return String($s1) & "." & String($s2) & "." & String($s3) & "." & String($rest -($s3 * 256))


Endfunc
;------------------------------------------------
func IP2Num($IP)                                                                                 ;returns a number aquivalent for a dotted Ip or leaves it as is
	local $ara[5], $n,$val
	local const $byte = 256
	$ara = Stringsplit($IP,".",2)
	$val= 0
	if ubound($ara) < 4 then
	    return($IP)
	endif
	for $n = 0 to 3
		$val= $val *$byte + $ara[$n]
	Next
	return($val)
EndFunc

;-----------------------------------------------------------------------------  Eala frya fresena ------------------------------------------------------------------
