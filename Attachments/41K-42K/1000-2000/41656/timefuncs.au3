global $TIMEFUNCS_LIB_INCLUDE="2.4"

#include <GuiConstantsEx.au3>
#include <Date.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include "atoi64.au3"
global $sp,$ep,$n

func eltime($timein)
	return numtoiso8601intervalformat($timein)
endfunc


func getcurdatestr()
	;local $tCur, $_a
	;$tCur = _Date_Time_GetLocalTime()
	;$_a=_Date_Time_SystemTimeToArray($tCur)
    return StringFormat("%04d-%02d-%02d", @YEAR, @MON, @MDAY)
endfunc
func getcurdatearr()
	local $tCur, $_a, $a
	;$tCur = _Date_Time_GetLocalTime()
	;$_a=_Date_Time_SystemTimeToArray($tCur)
    $a[0]=7
    $a[1]=@YEAR
    $a[2]=@MON
    $a[3]=@MDAY
    $a[4]=0
    $a[5]=0
    $a[6]=0
    $a[7]=0
    return $a
endfunc

func getcurtimestr()
    ;return Stringformat("%04d-%02d-%02d %02d:%02d:%02d.%03d",$a[2],$a[0],$a[1],$a[3],$a[4],$a[5],$a[6])
    return StringFormat("%02d:%02d:%02d.%03d", @HOUR, @MIN, @SEC, @MSEC)
endfunc
func getcurdatetimestr()
    return Stringformat("%04d-%02d-%02d %02d:%02d:%02d.%03d",@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC)
endfunc
func getcurtimearr()
    $a[0]=7
    $a[1]=@YEAR
    $a[2]=@MON
    $a[3]=@MDAY
    $a[4]=@HOUR
    $a[5]=@MIN
    $a[6]=@SEC
    $a[7]=@MSEC
    return $a
endfunc
;msgbox(0,"",getcurtimestr())
;msgbox(0,"",getcurdatetimestr())



func numstoextendedintervalformat($days,$hours,$minutes,$seconds,$milliseconds,$microseconds,$nanoseconds,$picoseconds,$femtoseconds,$attoseconds,$zeptoseconds,$yoctoseconds)
    ;not used here
    return StringFormat("I%dDT%02dH%02dM%02dS%03dm%03di%03dn%03dp%03df%03da%03dz%03dy",$days,$hours,$minutes,$seconds,$milliseconds,$microseconds,$nanoseconds,$picoseconds,$femtoseconds,$attoseconds,$zeptoseconds,$yoctoseconds)
endfunc

func numstoiso8601intervalformat($days,$hours,$minutes,$seconds,$ms)
    return StringFormat("P0000-00-%02dT%02d:%02d:%02d.%03d",$days,$hours,$minutes,$seconds,$ms)
endfunc


func numstoiso8601datetimeformat($year,$month,$day,$hour,$minute,$second,$ms)
    return StringFormat("%04d-%02d-%02dT%02d:%02d:%02d.%03d",$year,$month,$day,$hour,$minute,$second,$ms)
endfunc
func DTimetoiso8601datetimeformat($dtime)
    local $a[8]
    JulianDTimeToGregorian($dtime,$a)
    return StringFormat("%04d-%02d-%02dT%02d:%02d:%02d.%03d",$a[1],$a[2],$a[3],$a[4],$a[5],$a[6],$a[7])
endfunc

func numtoiso8601intervalformat($elapsed)
    $days=   Int($elapsed/24/60/60/1000)
    $hours=  Mod(Int($elapsed/60/60/1000),24)
    $minutes=Mod(Int($elapsed/60/1000),   60)
    $seconds=Mod(Int($elapsed/1000),      60)
    $ms=     Mod($elapsed,              1000)
    return StringFormat("P0000-00-%02dT%02d:%02d:%02d.%03d",$days,$hours,$minutes,$seconds, $ms)
endfunc

;getcurtimeiniso8601format(

func txtfileintervalformattonum($str)
    local $pos1,$pos2, $days,$hours,$minutes,$seconds
    local $a[2]
    if (0<>StringInStr($str,"T",1,1,1)) then
        ;-----new ISO8601-2004(E) format
        ;read the interval(duration) portion, which is from the P to the end.
        ;days
        $pos1=StringInStr($str,"-",1,4,1) ;4th occurrence of - is just before number of days
        $pos2=StringInStr($str,"T",1,2,1) ;2nd occurrence of T is just after number of days
        if (0==$pos1 or 0==$pos2) then
            ;guictrlsetdata($txto3,"problem 1:"&$str);DEBUG
            return 0
        endif
        $days=Int(StringMid($Str,$pos1+1,$pos2-($pos1+1)))

        ;hours
        $pos1=$pos2
        $pos2=StringInStr($str,":",1,3,1)
        if (0==$pos2) then
            ;guictrlsetdata($txto3,"problem 2:"&$str);DEBUG
            return 0
        endif
        $hours=Int(StringMid($Str,$pos1+1,$pos2-($pos1+1)))

        ;minutes
        $pos1=$pos2
        $pos2=StringInStr($str,":",1,4,1)
        if (0==$pos2) then
            ;guictrlsetdata($txto3,"problem 3:"&$str);DEBUG
            return 0
        endif
        $minutes=Int(StringMid($Str,$pos1+1,$pos2-($pos1+1)))

        ;seconds
        $pos1=$pos2
        $pos2=StringInStr($str,".",1,1,1)
        if (0==$pos2) then
            ;they left the milliseconds off
            $seconds=Int(StringMid($str,$pos1+1))
            $ms=0
        else
            $seconds=Int(StringMid($str,$pos1+1,$pos2-($pos1+1)))
            ;ms
            $pos1=$pos2
            $ms=Int(StringMid($str,$pos1+1,$pos2+1))
        endif
    else
        ;-----old format
        $pos1=StringInStr($str,":",1,1,1)
        $pos2=StringInStr($str,":",1,2,1)
        if (0==$pos1 or 0==$pos2) then
            ;guictrlsetdata($txto3,"problem 4:"&$str);DEBUG
            return 0
        endif
        $days=0
        $hours  =Int(StringMid($str,1,$pos1-1))
        $minutes=Int(StringMid($str,$pos1+1,$pos2-($pos1+1)))
        $seconds=Int(StringMid($str,$pos2+1,2))
        $ms=0
    endif
    return $ms+(1000*$seconds)+($minutes*1000*60)+($hours*1000*3600)+($days*1000*3600*24)
endfunc

func txtfileintervalstartdt($str)
    local $pos1,$pos2, $days,$hours,$minutes,$seconds
    local $_a[2]
    $pos1=StringInStr($str,"T",1,1,1)
    $pos2=StringInStr($str,"/",1,1,1) ;both formats contain this, but only the new ISO 8601 contains the T
    if (0<>$pos1 and 0<>$pos2) then ;new format
        return StringMid($str,1,$pos2-1)
    else
        $pos1=StringInStr($str,"/",1,1,1)
        $pos2=StringInStr($str,"/",1,2,1)
        if (0==$pos1 or 0==$pos2) then
            ;guictrlsetdata($txto3,"problem 5:"&$str);DEBUG
            return ""
        endif
        $year=StringMid($str,$pos2+1)
        $month=$StringMid($str,1,$pos1-1)
        $day=StringMid($str,$pos1+1,$pos2-($pos1+1))
        return $year&"-"&$month&"-"&$day
    endif
endfunc

func numstoeasyintervalformat($days,$hours,$minutes,$seconds,$ms)
    ;not used here
    return StringFormat("%ddays%02d:%02d:%02d.%03d",$days,$hours,$minutes,$seconds,$ms)
endfunc

func numtoeasyintervalformat($days,$hours,$minutes,$seconds,$ms)
    ;not used here
    $days=   Int($elapsed/24/3600/1000)
    $hours=  Mod(Int($elapsed/3600/1000),24)
    $minutes=Mod(Int($elapsed/60/1000),  60)
    $seconds=Mod(Int($elapsed/1000),          60)
    $ms=     Mod($elapsed,               1000)
    return StringFormat("%ddays%02d:%02d:%02d.%03d",$days,$hours,$minutes,$seconds,$ms)
endfunc


;-------------------------------------------------------------------------------




func curtimeToJDN()
    return GregorianToJulian(@YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC, @MSEC)
endfunc

func curtimeToDTIME()
    local $dtime
    GregorianToJulianDTime(@YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC, @MSEC, $dtime)
    return $dtime
endfunc



func fmod($_a,$_b)
	;return Mod($_a, $_b)
    return $_a-(floor($_a/$_b)*$_b) ;IMPORTANT to julian functions that you use FLOOR
endfunc
func fdiv($_a,$_b)
	return floor($_a/$_b) ;IMPORTANT to julian functions that you use FLOOR
endfunc
$epoch=GregorianToJDN(0,0,0,0,0,0,0)
; epoch is julian(-4713,11,24,12,0,0); hours are 0..23, months are 1..12, days are 1..31, years start with -4713.
func GregorianToJDN($Y,$Mo,$D,$H,$Mi,$S,$ms)
	local $_a=Floor((14-$Mo)/12);
	local $_y=$Y+4800-$_a;
	local $_m=$Mo+(12*$_a)-3;
    local $JDN=$D+Floor((153*$_m+2)/5)+365*$_y+Floor($_y/4)-Floor($_y/100)+Floor($_y/400)-32045
    local $JD=$JDN+(($H-12)/24)+($Mi/(24*60))+($S/(24*60*60))+($ms/(24*60*60*1000))
	;return $D + Floor((153*$_m+2)/5) + (365*$_y) + Floor($_y/4) - Floor($_y/100) + Floor($_y/400) - 32045 + (($H-12)/24) + ($Mi/1440) + ($S/86400) + ($ms/86400000);
    return $JDN
endfunc
;msgbox(0,"G2JD",GregorianToJDN(2012,10,4,2,13,15,1))

func GregorianToJulianDTime($Y,$Mo,$D,$H,$Mi,$S,$ms, byref $dtime)
	local $_a=Floor((14-$Mo)/12);
	local $_y=$Y+0-$_a; ;-----changed 4800 to 0
	local $_m=$Mo+(12*$_a)-3;
    local $JDN=$D-1+Floor((153*$_m+2)/5)+365*$_y+Floor($_y/4)-Floor($_y/100)+Floor($_y/400)+60 ;----- changed -32045 to +59
    $dtime = ($JDN*1000*60*60*24) + ($H*60*60*1000) + ($Mi*60*1000) + ($S*1000) + $ms
	;return $D + Floor((153*$_m+2)/5) + (365*$_y) + Floor($_y/4) - Floor($_y/100) + Floor($_y/400) - 32045 + (($H-12)/24) + ($Mi/1440) + ($S/86400) + ($ms/86400000);
    local $a[8]
    $a[0]=7
    $a[1]=$Y
    $a[2]=$Mo
    $a[3]=$D
    $a[4]=$H
    $a[5]=$Mi
    $a[6]=$S
    $a[7]=$ms
    return $a
endfunc
func JulianDTimeToGregorian($dtime, byref $datearr)
    ;-----well, it's my version of julian, where the base is 1/1/0000
    local $time = mod($dtime,1000*60*60*24)
    local $JDN = int($dtime / (1000*60*60*24))
	local $J1 = $JDN ;+0.5;
	local $j2 = $J1 - 60 ;+ 32044; changed +32045 to -58
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 0 + fdiv(($_m + 2), 12);-----changed 4800 to 0
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;

	local $H  = mod(int($time/(60*60*1000)),24)
	local $Mi = mod(int($time/(60*1000)),60)
	local $S  = mod(int($time/1000),60)
	local $ms = mod($time,1000)

    $datearr[0]=7
    $datearr[1]=$Y
    $datearr[2]=$Mo
    $datearr[3]=$D
    $datearr[4]=$H
    $datearr[5]=$Mi
    $datearr[6]=$S
    $datearr[7]=$ms
	return $datearr
endfunc
;func JulianDTimeToGregorianString($dtime, $type) ;$type="mm/dd/yyyy","yyyy-mm-dd","mm.dd.yyyy"
;    local $a[8]
;    JulianDTimeToGregorian($dtime,$a)
;    switch ($type)
;    case "mm/dd/yyyy"
;        return StringFormat("%02d/%02d/%04d %02d:%02d:%02d.%03d", $a[2],$a[3],$a[1], $a[4],$a[5],$a[6], $a[7])
;    case "mm.dd.yyyy"
;        return StringFormat("%02d.%02d.%04d %02d:%02d:%02d.%03d", $a[2],$a[3],$a[1], $a[4],$a[5],$a[6], $a[7])
;    case "yyyy-mm-dd"
;        return StringFormat("%04d-%02d-%02d %02d:%02d:%02d.%03d", $a[1],$a[2],$a[3], $a[4],$a[5],$a[6], $a[7])
;    case else
;        return ""
;    endswitch
;endfunc
;local $ar[8]
;local $jdn
;GregorianToJulianDTime(0,1,1,0,0,0,0, $jdn)
;msgbox(0,"GregorianToJulianDTime:JDN=",$jdn)
;JulianDTimeToGregorian($jdn,$ar)
;_ArrayDisplay($ar)
;JulianDTimeToGregorian($jdn+DaysToDTime(100),$ar)
;_ArrayDisplay($ar)

func DaysToDTime($days)
    return $days * 1000 * 60 * 60 * 24
endfunc

func HourToDTime($H)
    return $H * 1000 * 60 * 60
endfunc


func MinuteToDTime($Mi)
    return $Mi * 1000 * 60
endfunc


func SecondToDTime($S)
    return $S * 1000
endfunc


func MillisecondToDTime($ms)
    return $ms
endfunc


;http://www.sizes.com/time/cal_gregorian.htm
;local $dtime
;GregorianToDtime(1,2,3,4,5,6,7, $dtime)
;msgbox(0,"GregorianToDTime(1,2,3,4,5,6,7)",$dtime&"dtimedays"&($dtime/(1000*60*60*24)))
;!!!!!fails miserably this conversion and back!!!!! algorithm looks perfect,but works broken.

;-----http://en.wikipedia.org/wiki/Gregorian_calendar
func GregorianDOW($Y,$Mo,$D);0=sat,1=sun
    local $K=mod($Y,100)
    local $J=floor($Y/100)
    return mod($D+floor(13*($Mo+1)/5)+$K+floor($K/4)+floor($J/4)-(2*$J),7)
endfunc
func JulianDOW($Y,$Mo,$D);0=sat,1=sun
    local $K=mod($Y,100)
    local $J=floor($Y/100)
    return mod($D+floor(13*($Mo+1)/5)+$K+floor($K/4)+5-$J,7)
endfunc
func ISODOW($Y,$Mo,$D) ;1=mon,7=sun
    local $K=mod($Y,100)
    local $J=floor($Y/100)
    return mod($D+floor(13*($Mo+1)/5)+$K+floor($K/4)+5-$J,7)
endfunc

func LeapIndex($Y)
	if (0<>mod($Y, 4)) then
		return 0;
	elseif (0<>mod($Y, 100)) then
		return 1;
	elseif (0<>mod($Y, 400)) then
		return 0;
	else
		return 1;
	endif
endfunc


func NumDaysInMonth($Y,$Mo)
    switch $mo
        case 1,8,12
            return 31
        case 2
            return LeapIndex($Y) + 28
        case 3,5,7,10
            return 31
        case 4,6,9,11
            return 30
    endswitch
endfunc

func SumOfDaysUpTo1stDayOfMonthWithoutYear($Y,$Mo)
    ;this is the sum of days up to 1st day of $Mo
    local $sum=0,$i
    for $i = 1 to $Mo-1
        $sum += NumDaysInMonth($Y,$Mo)
    next
    return $sum+1
endfunc


func GregorianToDtime($Y,$Mo,$D,$H,$Mi,$S,$ms, byref $dtime)
    ;                                                      
    local $a, $b, $c, $e, $f, $jd
    if ($Mo >= 1 && $Mo <= 2) then
        $Mo+=12
        $Y-=1
    endif
    $a=Floor($Y/100)
    $b=Floor($a/4)
    $c=2-$a+$b
    $e=Floor(365.25*($Y+4716))
    $f=Floor(30.6001*($Mo+1))
    ;$jd=$c+$d+$e+$f-1524.5 ;real julian day
    $jd=$c+$D+$e+$f-1524
    $dtime = ($jd*1000*60*60*24) + $ms+($S*1000)+($Mi*1000*60)+($H*1000*60*60)
endfunc

func DtimeToGregorian($dtime,byref $Y,byref $Mo,byref $D,byref $H,byref $Mi,byref $S,byref $ms)
    ;                                                      
    ;fails if Y<400
    local $Z = Floor($dtime/(1000*60*60*24))$JD+0.5
    local $W = ($Z - 1867216.25)/36524.25
    local $X = $W/4
    local $A = $Z+1+$W-$X
    local $B = $A+1524
    local $C = ($B-122.1)/365.25
    local $DD = 365.25*$C
    local $E = ($B-$DD)/30.6001
    local $F = 30.6001*$E
    $D = $B-$DD-$F
    ;$Mo = $E-1 or $E-13 (must get number less than or equal to 12)
    if ($E-1<=12) then
        $Mo=$E-1
    else
        $Mo=$E-13
    endif
    if ($Mo <= 2) then
        $Y = $C-4715; (if Month is January or February)
    else
        $Y = $C-4716; (otherwise)
    endif
    ;$Y = C-4715 (if Month is January or February) or C-4716 (otherwise)
    $ms=Mod($dtime,1000)
    $S=Mod(Int64($dtime/1000),60)
    $Mi=Mod(Int64($dtime/(1000*60)),60)
    $H=Mod(Int64($dtime/(1000*60*60)),24)
endfunc





func GregorianToJD($Y,$Mo,$D,$H,$Mi,$S,$ms)
	local $_a=Floor((14-$Mo)/12);
	local $_y=$Y+4800-$_a;
	local $_m=$Mo+(12*$_a)-3;
    local $JDN=$D+Floor((153*$_m+2)/5)+365*$_y+Floor($_y/4)-Floor($_y/100)+Floor($_y/400)-32045
    local $JD=$JDN+($H-12)/24+$Mi/1440+$S/86400+$ms/86400000
	;return $D + Floor((153*$_m+2)/5) + (365*$_y) + Floor($_y/4) - Floor($_y/100) + Floor($_y/400) - 32045 + (($H-12)/24) + ($Mi/1440) + ($S/86400) + ($ms/86400000);
    return $JD
endfunc

func JulianFromDate(byref $date) ;date is in format 7 Y Mo D H Mi S MS
	$_a=Floor((14-($date[2]))/12);
	$_y=$date[1]+4800-$_a;
	$_m=($date[2])+(12*$_a)-3;
	return $date[3] + Floor((153*$_m+2)/5) + (365*$_y) + Floor($_y/4) - Floor($_y/100) + Floor($_y/400) - 32045 + (($date[4]-12)/24) + ($date[5]/1440) + ($date[6]/86400) + ($date[7]/86400000);
endfunc
func DateToJulian($date) ;date is in format 7 Y Mo D H Mi S MS
	$_a=Floor((14-($date[2]))/12);
	$_y=$date[1]+4800-$_a;
	$_m=($date[2])+(12*$_a)-3;
	return $date[3] + Floor((153*$_m+2)/5) + (365*$_y) + Floor($_y/4) - Floor($_y/100) + Floor($_y/400) - 32045 + (($date[4]-12)/24) + ($date[5]/1440) + ($date[6]/86400) + ($date[7]/86400000);
endfunc
;func to2DigitString($n)
;	$s=n.toString();
;	if (StringLen(s)=1) then
;		s="0"&s;
;	endif
;	return s;
;endfunc


func JulianToDate($JDN,byref $date)  ;converts real julian day number to gregorian date array down to ms
	 $J1 = $JDN+0.5; ;shifts epoch 1/2 day
	 $j2 = $J1 + 32044; ;shifts epoch back to astronomical year -4800
	 $g1 = fdiv($j2 , 146097);
	 $dg = fmod($j2 , 146097);
	 $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	 $dc = $dg - ($c1 * 36524);
	 $_b = fdiv($dc , 1461);
	 $db = fmod($dc , 1461);
	 $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	 $da = $db - ($_a * 365);
	 $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a; ;integer number of full years elapsed since March 1, 4801 BC at 00:00 UTC
	 $_m = fdiv(($da * 5 + 308) , 153) - 2; ;integer number of full months elapsed since the last March 1 at 00:00 UTC
	 $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122; ;number of days elapsed since day 1 of the month at 00:00 UTC, including fractions of one day
	 $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	 $Mo = fmod(($_m + 2) , 12) + 1;
	 $D = $_d + 1;
     $_t=$J1-Floor($J1);
     $HH=mod(floor(24*$_t), 24);
     $MM=mod(floor(24*60*$_t), 60);
     $SS=mod(floor(24*60*60*$_t), 60);
     $MS=mod(floor(24*60*60*1000*$_t), 1000);
    $date[0]=7
    $date[1]=$Y
    $date[2]=$Mo
    $date[3]=$D
    $date[4]=$HH
    $date[5]=$MM
    $date[6]=$SS
    $date[7]=$MS

;	return $date;
endfunc
func DateFromJulian($JDN, byref $date)
	 $J1 = $JDN+0.5;
	 $j2 = $J1 + 32044;
	 $g1 = fdiv($j2 , 146097);
	 $dg = fmod($j2 , 146097);
	 $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	 $dc = $dg - ($c1 * 36524);
	 $_b = fdiv($dc , 1461);
	 $db = fmod($dc , 1461);
	 $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	 $da = $db - ($_a * 365);
	 $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	 $_m = fdiv(($da * 5 + 308) , 153) - 2;
	 $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	 $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	 $Mo = fmod(($_m + 2) , 12) + 1;
	 $D = $_d + 1;
     $_t=$J1-Floor($J1);
     $HH=fmod(24*$_t+12, 24);
    $_t=fdiv(24*$_t+12, 24);
     $MM=fmod(60*$_t, 60);
    $_t=fdiv(60*$_t, 60);
     $SS=fmod(60*$_t, 60);
    $_t=fdiv(60*$_t, 60);
     $MS=fmod(1000*$_t, 1000);
    $_t=fdiv(1000*$_t, 1000);

    $date[0]=7
    $date[1]=$Y
    $date[2]=$Mo
    $date[3]=$D
    $date[4]=$HH
    $date[5]=$MM
    $date[6]=$SS
    $date[7]=$MS

;	return $date;
endfunc

func GregorianStringFromJulian($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
    local $_t=$J1-Floor($J1);
    local $HH=fmod(24*$_t+12, 24);
    $_t=fdiv(24*$_t+12, 24);
    local $MM=fmod(60*$_t, 60);
    $_t=fdiv(60*$_t, 60);
    local $SS=fmod(60*$_t, 60);
    $_t=fdiv(60*$_t, 60);
    local $MS=fmod(1000*$_t, 1000);
    $_t=fdiv(1000*$_t, 1000);
	return StringFormat("%d/%d/%d %02d:%02d:%02d.%03d",$Mo-1, $D, $Y, $HH, $MM, $SS, $MS)
endfunc

func JulianToGregorian($JDN, byref $date)
	 $J1 = $JDN+0.5;
	 $j2 = $J1 + 32044;
	 $g1 = fdiv($j2 , 146097);
	 $dg = fmod($j2 , 146097);
	 $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	 $dc = $dg - ($c1 * 36524);
	 $_b = fdiv($dc , 1461);
	 $db = fmod($dc , 1461);
	 $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	 $da = $db - ($_a * 365);
	 $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	 $_m = fdiv(($da * 5 + 308) , 153) - 2;
	 $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	 $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	 $Mo = fmod(($_m + 2) , 12) + 1;
	 $D = $_d + 1;
	 $H =  ($_d - Floor($_d))*24;
	 $Mi=  ($H - Floor($H))*60;
	 $S=   ($Mi - Floor($Mi))*60;
	 $Ms = ($S - Floor($S))*1000;

    $date[0]=7
    $date[1]=$Y
    $date[2]=$Mo
    $date[3]=$D
    $date[4]=$H
    $date[5]=$Mi
    $date[6]=$S
    $date[7]=$MS
	;return $Y;
endfunc



func JulianToGregorianY($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return $Y;
endfunc

func JulianToGregorianMo($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return $Mo;
endfunc

func JulianToGregorianD($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return Floor($D);
endfunc

func JulianToGregorianH($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return Floor($H);
endfunc

func JulianToGregorianMi($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return Floor($Mi);
endfunc

func JulianToGregorianS($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return Floor($S);
endfunc

func JulianToGregorianMs($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $Ms = ($S - Floor($S))*1000;
	return Floor($Ms);
endfunc

func JulianToGregorianFracSec($JDN)
	local $J1 = $JDN+0.5;
	local $j2 = $J1 + 32044;
	local $g1 = fdiv($j2 , 146097);
	local $dg = fmod($j2 , 146097);
	local $c1 = fdiv((fdiv($dg , 36524) + 1) * 3 , 4);
	local $dc = $dg - ($c1 * 36524);
	local $_b = fdiv($dc , 1461);
	local $db = fmod($dc , 1461);
	local $_a = fdiv((fdiv($db , 365) + 1) * 3 , 4);
	local $da = $db - ($_a * 365);
	local $_y = ($g1 * 400) + ($c1 * 100) + ($_b * 4) + $_a;
	local $_m = fdiv(($da * 5 + 308) , 153) - 2;
	local $_d = $da - fdiv(($_m + 4) * 153 , 5) + 122;
	local $Y = $_y - 4800 + fdiv(($_m + 2), 12);
	local $Mo = fmod(($_m + 2) , 12) + 1;
	local $D = $_d + 1;
	local $H = ($_d - Floor($_d))*24;
	local $Mi= ($H - Floor($H))*60;
	local $S= ($Mi - Floor($Mi))*60;
	local $fracSec = $S - Floor($S);
	return $fracSec;
endfunc

func DaysDTime($days,$H,$Mi,$S,$MS)
    return NumsToDaysDTime($days,$H,$Mi,$S,$MS)
endfunc

func NumsToDaysDTime($days, $H, $M, $S, $MS)
	return $MS + ($S*1000) + ($M*1000*60) + ($H*1000*60*60) + ($days*1000*60*60*24)
endfunc
func numstoDTIMEstring($days, $H, $M, $S, $MS)
	return StringFormat("%d days %02d:%02d:%02d.%03d", $days, $H, $M, $S, $MS)
endfunc
func DTimeToString($dtime)
    ;msgbox(0,"DTImeToString:$dtime=",$dtime)
	local $ms  =DTIMEtoMS($dtime)
	local $s   =DTIMEtoS($dtime)
	local $_m  =DTIMEtoM($dtime)
	local $h   =DTIMEtoH($dtime)
	local $days=DTIMEtodays($dtime)
	if ($dtime < 0 or $days < 0 or $h < 0 or $_m < 0 or $s < 0 or $ms < 0) then
	    return StringFormat("-%d days %02d:%02d:%02d.%03d", abs($days), abs($h), abs($_m), abs($s), abs($ms))
    else
    	return StringFormat("%d days %02d:%02d:%02d.%03d", abs($days), abs($h), abs($_m), abs($s), abs($ms))
    endif
endfunc

;msgbox(0,"StringToDtime(1-2-3)",StringToDTime("1-2-3")/(1000*24*60*60))
;msgbox(0,"StringToDtime(2012-7-13)",StringToDTime("1-2-3")/(1000*24*60*60))


func StringToDTime($dtimestr)
    $dtimestr=stringstripws($dtimestr,1+2+4)
	;msgbox(0,$PROGRAM_NAME,"dtimestr="+$dtimestr)
    local $Y, $M, $D,$_t,$dtime=0,$dtime2, $arrgjd[8], $tossdtime
    local $_days=0,$_days_err=0,$_minutes=0,$_minutes_err=0,$_seconds=0,$_seconds_err=0,$_hours=0,$_hours_err=0,$_ms=0,$_ms_err=0
    local $ms,$seconds,$hours,$minutes,$days
    local $sign=1
    ;if ("-"==stringmid($dtimestr,1,1)) then
    ;    ;remove minus sign
    ;    $sign=-1
    ;    $dtimestr=stringmid($dtimestr,2)
    ;elseif ("+"==stringmid($dtimestr,1,1)) then
    ;    ;remove plus sign
    ;    $sign=1
    ;    $dtimestr=stringmid($dtimestr,2)
    ;endif
    ;-----handle SQL-style date portion YYYY-M-D followed by whitespace
    local $dash1pos=stringinstr($dtimestr,"-",1,1)
    local $dash2pos=StringInStr($dtimestr,"-",1,2)
    ;msgbox(0,"dash1pos",$dash1pos)
    ;msgbox(0,"dash2pos",$dash2pos)
    ;-----handle USA-style date in the form M/D/YYYY followed by optional whitespace
    local $slash1pos=StringInStr($dtimestr,"/",1,1)
    local $slash2pos=StringInStr($dtimestr,"/",1,2)
    ;msgbox(0,"slash1pos",$slash1pos)
    ;msgbox(0,"slash2pos",$slash2pos)
    ;-----handle foreign-style dotted date in the form M.D.YYYY followed by optional whitespace
    local $dot1pos=StringInStr($dtimestr,".",1,1)
    local $dot2pos=StringInStr($dtimestr,".",1,2)
    local $dot3pos=StringInStr($dtimestr,".",1,3)
    ;msgbox(0,"dot1pos",$dot1pos)
    ;msgbox(0,"dot2pos",$dot2pos)
    ;msgbox(0,"dot3pos",$dot3pos)
    local $spacepos=StringInStr($dtimestr," ",1,2)
    local $tabpos=StringInStr($dtimestr,@tab,1,2)
	;msgbox(0,$PROGRAM_NAME,"string parse dashed date:"&dtimestr&"::"&stringmid($dtimestr,1,$dash1pos)&"+"&stringmid($dtimestr,$dash1pos+1,$dash2pos-1-($dash1pos+1))&"+"&stringmid($dtimestr,$dash2pos+1,$spacepos-1-($dash2pos+1)))
	local $agjd, $y,$mo,$d, $yi,$moi,$di
    if (0<>$dash1pos  and  0<>$dash2pos  and  0<>$spacepos) then
		$y=stringmid($dtimestr,1,$dash1pos-1)
		$mo=stringmid($dtimestr,$dash1pos+1,$dash2pos-($dash1pos+1))
		$d=stringmid($dtimestr,$dash2pos+1,$spacepos-($dash2pos+1))

		$yi=Int($y)
		$moi=Int($mo)
		$di=Int($d)
		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
		$dtime=$arrgjd[0]
            $dtimestr=stringstripws(stringmid($dtimestr,$spacepos+1),1+2+4)
            ;msgbox(0,$PROGRAM_NAME&"A","dtime"&DTimeToString($dtime))
    else
        if (0<>$dash1pos  and  0<>$dash2pos  and  0<>$tabpos) then
			$y=stringmid($dtimestr,1,$dash1pos)
			$mo=stringmid($dtimestr,$dash1pos+1,$dash2pos-1-($dash1pos+1))
			$d=stringmid($dtimestr,$dash2pos+1,$tabpos-1-($dash2pos+1))

			$yi=Int($y)
			$moi=Int($mo)
			$di=Int($d)
    		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                $dtimestr=stringstripws($dtimestr,$tabpos+1),1+2+4)
                ;msgbox(0,$PROGRAM_NAME&"B","dtime"+DTimeToString($dtime))
        else
            if (0<>$slash1pos  and  0<>$slash2pos  and  0<>$spacepos) then
				$y=stringmid($dtimestr,1,$slash1pos-1)
				$mo=stringmid($dtimestr,$slash1pos+1,$slash2pos)
				$d=stringmid($dtimestr,$slash2pos+1,$spacepos)

				$yi=Int($y)
				$moi=Int($mo)
				$di=Int($d)
        		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                    $dtimestr=stringstripws($dtimestr,$spacepos+1),1+2+4)
                ;msgbox(0,$PROGRAM_NAME&"C","dtime"&DTimeToString($dtime))
            else
                if (0<>$slash1pos  and  0<>$slash2pos  and  0<>$tabpos) then
					$y=stringmid($dtimestr,1,$slash1pos-1)
					$mo=stringmid($dtimestr,$slash1pos+1,$slash2pos-1-($slash1pos+1))
					$d=stringmid($dtimestr,$slash2pos+1,$tabpos-1-($slash2pos+1))

					$yi=Int($y)
					$moi=Int($mo)
					$di=Int($d)
            		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                        $dtimestr=stringstripws($dtimestr,$tabpos+1),1+2+4)
                ;msgbox(0,$PROGRAM_NAME&"D","dtime"&DTimeToString($dtime))
                else
                    if (0<>$dash1pos  and  0<>$dash2pos  and  0==$spacepos  and  0==$tabpos) then
						$y=stringmid($dtimestr,1,$dash1pos-1)
						$mo=stringmid($dtimestr,$dash1pos+1,$dash2pos - 1 - ($dash1pos+1))
						$d=stringmid($dtimestr,$dash2pos+1)

						$yi=Int($y)
						$moi=Int($mo)
						$di=Int($d)
                		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                ;msgbox(0,$PROGRAM_NAME&"E","dtime"&DTimeToString($dtime))
                            return $dtime
                    else
                        if (0<>$slash1pos  and  0<>$slash2pos  and  0==$spacepos  and  0==$tabpos) then
							$y=stringmid($dtimestr,1,$slash1pos-1)
							$mo=stringmid($dtimestr,$slash1pos+1,$slash2pos - 1-($slash1pos+1))
							$d=stringmid($dtimestr,$slash2pos+1)

							$yi=Int($y)
							$moi=Int($mo)
							$di=Int($d)
                    		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                ;msgbox(0,$PROGRAM_NAME&"F","dtime"&DTimeToString($dtime))
                                return $dtime
                        else
                            if (0<>$dot1pos  and  0<>$dot2pos  and  0<>$spacepos) then
								$y=stringmid($dtimestr,1,$dot1pos-1)
								$mo=stringmid($dtimestr,$dot1pos+1,$dot2pos-1-($dot1pos+1))
								$d=stringmid($dtimestr,$dot2pos+1,$spacepos-1-($dot2pos+1))

								$yi=Int($y)
								$moi=Int($mo)
								$di=Int($d)
                        		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                                    $dtimestr=stringstripws(stringmid($dtimestr,$spacepos+1),1+2+4)
                ;msgbox(0,$PROGRAM_NAME&"G","dtime"&DTimeToString($dtime))
                            else
                                if (0<>$dot1pos  and  0<>$dot2pos  and  0<>$tabpos) then
									$y=stringmid($dtimestr,1,$dot1pos-1)
									$mo=stringmid($dtimestr,$dot1pos+1,$dot2pos-1-($dot1pos+1))
									$d=stringmid($dtimestr,$dot2pos+1,$tabpos-1-($dot2pos+1))

									$yi=Int($y)
									$moi=Int($mo)
									$di=Int($d)
                            		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                                        $dtimestr=stringstripws(stringmid($dtimestr,$tabpos+1),1+2+4)
                ;msgbox(0,$PROGRAM_NAME&"H","dtime"&DTimeToString($dtime))
                                else
                                    if (0<>$dot1pos  and  0<>$dot2pos  and  0==$spacepos  and  0==$tabpos) then
										$y=stringmid($dtimestr,1,$dot1pos-1)
										$mo=stringmid($dtimestr,$dot1pos+1,$dot2pos -1- ($dot1pos+1))
										$d=stringmid($dtimestr,$dot2pos+1)

										$yi=Int($y)
										$moi=Int($mo)
										$di=Int($d)
                                		$arrgjd = GregorianToJulianDTime($yi, $moi, $di, 0,0,0,0, $dtime)
                                            return $dtime
                                    else
                ;msgbox(0,$PROGRAM_NAME&"I","dtime"&DTimeToString($dtime))
                                        ;-----no date here, let drop through
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
	local $sdays=" days "
	local $sldays=stringlen($sdays)
	local $idays=StringInStr($dtimestr, $sdays, 0,1)
	local $firstcolon=StringInStr($dtimestr,":",1,1)
	local $lastcolon =StringInStr($dtimestr,":",1,2)
	local $dot       =StringInStr($dtimestr,".",1,1)
    ;msgbox(0,"status", "$idays="&$idays&"$firstcolon="&$firstcolon&"$lastcolon="&$lastcolon&"$dot="&$dot&"$sldays="&$sldays) ;DEBUG
    if (0<>$idays  and  0<>$dot  and  0<>$lastcolon  and  0<>$firstcolon) then ;if all not errors

        $_days=Int(stringmid($dtimestr,1,$idays - 1))
        $_days_err=isint(stringmid($dtimestr,1,$idays - 1))
        if ($_days_err) then msgbox(0,$PROGRAM_NAME,"oops days a """&Int(stringmid($dtimestr,1,$idays-1))&"_"&stringmid($dtimestr,1,$idays-1)&"""") endif
        ;msgbox(0,"daysa",stringmid($dtimestr,1,$idays - 1)) ;DEBUG

        $_hours=Int(stringmid($dtimestr,$idays+$sldays, $firstcolon -($idays+$sldays)))
        $_hours_err=isint(stringmid($dtimestr,1,$firstcolon-1))
        if ($_hours_err) then msgbox(0,$PROGRAM_NAME,"oops hours a """&Int(stringmid($dtimestr,$idays+$sldays, $firstcolon-($idays+$sldays)))&"_"&stringmid($dtimestr,$idays+$sldays, $firstcolon-($idays+$sldays))&"""") endif         ;-----success of having all the dtime style parameters: days hours minutes seconds ms
        ;msgbox(0,"hoursa",stringmid($dtimestr,$idays+$sldays, $firstcolon -($idays+$sldays))) ;DBEUG

        $_minutes=Int(stringmid($dtimestr,$firstcolon+1, $lastcolon - ($firstcolon+1)))
        $_minutes_err=isint(stringmid($dtimestr,$firstcolon+1, $lastcolon -($firstcolon+1)))
        if ($_minutes_err) then msgbox(0,$PROGRAM_NAME,"oops mins a """&Int(stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1)))&"_"&stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1))&"""") endif
        ;msgbox(0,"minsa",stringmid($dtimestr, $firstcolon+1, $lastcolon -($firstcolon + 1))) ;DEBUG

        $_seconds=Int(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))
        $_seconds_err=isint(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))
        if ($_seconds_err) then msgbox(0,$PROGRAM_NAME,"oops secs a """&Int(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))&"_"&stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1))&"""") endif
        ;msgbox(0,"secsa",stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1))) ;DEBUG

        $_ms=Int(stringmid($dtimestr,$dot+1))
        $_ms_err=isint(stringmid($dtimestr,$dot+1))
        if ($_ms_err) then msgbox(0,$PROGRAM_NAME,"oops ms a """&Int($dtimestr,$dot+1))&"_"&stringmid($dtimestr,$dot+1)&"""") endif
        ;msgbox(0,"msa",stringmid($dtimestr,$dot+1)) ;DEBUG

        ;-----handle
        if (not($_ms_err  or  $_seconds_err  or  $_minutes_err  or  $_hours_err  or  $_days_err)) then ;if not any errors
            ;$dtime2=NumsToDaysDTime($_days, $_hours, $_minutes, $_seconds, $_ms)
            ;;msgbox(0,$PROGRAM_NAME,"dtime2"+$dtime2)
            ;$_t=$sign*($dtime+$dtime2)
            ;;msgbox(0,$PROGRAM_NAME,"dtime total",$_t)
            ;;msgbox(0,$PROGRAM_NAME,$_t+$sign+"sign"+$_days+"days"+$_hours+"hours"+$_minutes+"minutes"+$_seconds+"seconds"+$_ms+"ms")
			local $dt=NumsToDaysDTime($_days, $_hours, $_minutes, $_seconds, $_ms)
            return $sign*($dt+$dtime)
        else
                        msgbox(0,$PROGRAM_NAME,"err:1")
            return 0
        endif
    else
        if (0=$idays  and  0<>$dot  and  0<>$lastcolon  and  0<>$firstcolon) then

            $_hours=Int(stringmid($dtimestr,1,$firstcolon-1))
            $_hours_err=isint(stringmid($dtimestr,1,$firstcolon-1))
            if ($_hours_err) then msgbox(0,$PROGRAM_NAME,"oops hours b """&Int(stringmid($dtimestr,$idays+$sldays, $firstcolon-1))&"_"&stringmid($dtimestr,$idays+$sldays, $firstcolon-1)&"""") endif         ;-----success of having all the dtime style parameters: days hours minutes seconds ms
            ;msgbox(0,"hoursb",stringmid($dtimestr, 1, $firstcolon-1)) ;DBEUG

            $_minutes=Int(stringmid($dtimestr,$firstcolon+1, $lastcolon - ($firstcolon+1)))
            $_minutes_err=isint(stringmid($dtimestr,$firstcolon+1, $lastcolon - ($firstcolon+1)))
            if ($_minutes_err) then msgbox(0,$PROGRAM_NAME,"oops mins b """&Int(stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1)))&"_"&stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1))&"""") endif
            ;msgbox(0,"minsb",stringmid($dtimestr, $firstcolon+1, $lastcolon - ($firstcolon + 1))) ;DEBUG

            $_seconds=Int(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))
            $_seconds_err=isint(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))
            if ($_seconds_err) then msgbox(0,$PROGRAM_NAME,"oops secs b """&Int(stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1)))&"_"&stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1))&"""") endif
            ;msgbox(0,"secsb",stringmid($dtimestr,$lastcolon+1, $dot-($lastcolon+1))) ;DEBUG

            $_ms=Int(stringmid($dtimestr,$dot+1))
            $_ms_err=isint(stringmid($dtimestr,$dot+1))
            if ($_ms_err) then msgbox(0,$PROGRAM_NAME,"oops ms b """&Int($dtimestr,$dot+1))&"_"&stringmid($dtimestr,$dot+1)&"""") endif
            ;msgbox(0,"msb",stringmid($dtimestr,$dot+1)) ;DEBUG

            ;-----success of having all the dtime style parameters: days hours minutes seconds ms
            ;-----handle
            if (not($_ms_err  or  $_seconds_err  or  $_minutes_err  or  $_hours_err)) then
            ;$dtime2=NumsToDaysDTime(0, $_hours, $_minutes, $_seconds, $_ms)
            ;;msgbox(0,$PROGRAM_NAME,"dtime2"+$dtime2)
            ;$_t=$sign*($dtime+$dtime2)
            ;;msgbox(0,$PROGRAM_NAME,"dtime total"+$_t)
            ;;msgbox(0,$PROGRAM_NAME,$_t+$sign+"sign"+$_hours+"hours"+$_minutes+"minutes"+$_seconds+"seconds"+$_ms+"ms")
				local $dt=NumsToDaysDTime(0, $_hours, $_minutes, $_seconds, $_ms)
                return $sign*($dt+$dtime)
            else
                        msgbox(0,$PROGRAM_NAME,"err:2")
                return 0
            endif
        else
            if (0=$idays  and  0=$dot  and  0<>$lastcolon  and  0<>$firstcolon) then

                $_hours=Int(stringmid($dtimestr, 1, $firstcolon-1))
                $_hours_err=isint(stringmid($dtimestr,1,$firstcolon-1))
                if ($_hours_err) then msgbox(0,$PROGRAM_NAME,"oops hours c """&Int(stringmid($dtimestr,$idays+$sldays, $firstcolon-($idays+$sldays)))&"_"&stringmid($dtimestr,$idays+$sldays, $firstcolon-($idays+$sldays))&"""") endif         ;-----success of having all the dtime style parameters: days hours minutes seconds ms
                ;msgbox(0,"hoursc",stringmid($dtimestr, 1, $firstcolon-1)) ;DBEUG

                $_minutes=Int(stringmid($dtimestr, $firstcolon+1, $lastcolon - ($firstcolon + 1)))
                $_minutes_err=isint(stringmid($dtimestr,$firstcolon+1, $lastcolon - ($firstcolon + 1)))
                if ($_minutes_err) then msgbox(0,$PROGRAM_NAME,"oops mins c """&Int(stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1)))&"_"&stringmid($dtimestr,$firstcolon+1, $lastcolon-($firstcolon+1))&"""") endif
                ;msgbox(0,"minsc",stringmid($dtimestr, $firstcolon+1, $lastcolon - ($firstcolon + 1))) ;DEBUG

                $_seconds=Int(stringmid($dtimestr,$lastcolon+1))
                $_seconds_err=isint(stringmid($dtimestr,$lastcolon+1))
                if ($_seconds_err) then msgbox(0,$PROGRAM_NAME,"oops secs c """&Int(stringmid($dtimestr,$lastcolon+1))&"_"&stringmid($dtimestr,$lastcolon+1)&"""") endif
                ;msgbox(0,"secsc",stringmid($dtimestr,$lastcolon+1)) ;DEBUG

                ;-----handle
                if (not($_seconds_err  or $_minutes_err  or $_hours_err)) then
            ;dtime2=NumsToDaysDTime(0, _hours, _minutes, _seconds, 0)
            ;;msgbox(0,$PROGRAM_NAME,"dtime2"+dtime2)
            ;_t=sign*(dtime+dtime2)
            ;msgbox(0,$PROGRAM_NAME,"dtime total"+_t)
            ;msgbox(0,$PROGRAM_NAME,_t+sign+"sign"+_hours+"hours"+_minutes+"minutes"+_seconds+"seconds")
					local $dt=NumsToDaysDTime(0, $_hours, $_minutes, $_seconds, 0)
                    return $sign*($dt+$dtime)
                else
                    msgbox(0,$PROGRAM_NAME,"err:3")
                    return 0
                endif
            else
                if (0=$idays  and  0=$dot  and  0=$lastcolon  and  0<>$firstcolon) then

                    $_hours=Int(stringmid($dtimestr, 1, $firstcolon-1))
                    $_hours_err=isint(stringmid($dtimestr1, $firstcolon-1))
                    if ($_hours_err) then msgbox(0,$PROGRAM_NAME,"oops hours d """&Int(stringmid($dtimestr,$firstcolon-1))&"_"&stringmid($dtimestr,$firstcolon-1)&"""") endif         ;-----success of having all the dtime style parameters: days hours minutes seconds ms
                    ;msgbox(0,"hoursd",stringmid($dtimestr, 1, $firstcolon-1)) ;DBEUG

                    $_minutes=Int(stringmid($dtimestr,$firstcolon+1))
                    $_minutes_err=isint(stringmid($dtimestr,$firstcolon+1))
                    if ($_minutes_err) then msgbox(0,$PROGRAM_NAME,"oops mins d """&Int(stringmid($dtimestr,$firstcolon+1))&"_"&stringmid($dtimestr,$firstcolon+1)&"""") endif
                    ;msgbox(0,"minsd",stringmid($dtimestr, $firstcolon+1, $lastcolon - ($firstcolon + 1))) ;DEBUG

                    ;-----handle
                    if (not($_minutes_err  or $_hours_err)) then
            ;$dtime2=NumsToDaysDTime(0, $_hours, $_minutes, 0, 0)
            ;;msgbox(0,$PROGRAM_NAME,"dtime2"+$dtime2)
            ;$_t=sign*($dtime+$dtime2)
            ;;msgbox(0,$PROGRAM_NAME,"dtime total"+$_t)
            ;;msgbox(0,$PROGRAM_NAME,$_t+$sign+"sign"+$_hours+"hours"+$_minutes+"minutes")
						local $dt=NumsToDaysDTime(0, $_hours, $_minutes, 0, 0)

                        return $sign*($dt+$dtime)
                    else
                        msgbox(0,$PROGRAM_NAME,"err:4")
                        return 0
                    endif
                else
                    ;-----try free-form words format
					local $aa[3]
					NamedTimeStringToDTime($dtimestr, $aa) ;returns Array(dtime, status)
					$dtime2 = $aa[1]
                    if ($aa[2]) then
                        return $dtime+$dtime2
                    else
                        msgbox(0,$PROGRAM_NAME,"err in NamedTimeStringToDtime():false"&@crlf&" - please correct your input. see help.") ;DEBUG
                        return -1
                    endif
                endif
            endif
        endif
    endif
    msgbox(0,$PROGRAM_NAME,-9999)
    return -9999
endfunc


func NamedTimeStringToDTime($dtimestr, byref $arr)  ;returns Array(dtime, status);
    ;msgbox(0,"NamedTimeStringToDTime()","$dtimestr="&$dtimestr);DEBUG
    $dtimestr=stringstripws($dtimestr,1+2+4);
    ;msgbox(0,"NamedTimeStringToDTime():stringstripws()::1","$dtimestr="&$dtimestr);DEBUG
	;msgbox(0,$PROGRAM_NAME,dtimestr);
    local $arrint[4],$arrkw[4]
	local $sign=1, $integer=0, $keyword, $reststr, $failed=false,$garbage=false, $garbagestring="",$failurestring=""
	local $dtime=0
	;-----reorder keywords in order of longest to shortest,  and  things that have dots to things that don't second.
	local $syear=StringSplit("years,years.,year,year.,yrs,yrs.,yr,yr.,y.,y", ",")
	local $smonth=StringSplit("months,months.,month,month.,mo,mo.,mos,mos.", ",")
	local $sweek=StringSplit("weeks,weeks.,wks,wks.,wk,wk.,week,week.,w.,w", ",")
	local $sday=StringSplit("days,day,dys.,dys,dy.,dy,d.,d", ",")
	local $shr=StringSplit("hours,hour,hrs.,hrs,hr.,hr,h.,h", ",")
	local $smin=StringSplit("minutes,minute,mins.,mins,min.,min,m.,m", ",")
	local $ssec=StringSplit("seconds,second,secs.,secs,sec.,sec,s.,s", ",")
	local $sms=StringSplit("milliseconds,millisecond,millisecs.,millisecs,millisec.,millisec,ms.,ms", ",")
	$dtimestr=stripwhitespace($dtimestr)
    ;msgbox(0,"NamedTimeStringToDTime():stringstripws()::2","$dtimestr="&$dtimestr);DEBUG
	while ("" <> $dtimestr  and  (not $failed))
		extractinteger($dtimestr, $arrint)   ;return Array(restOfStringExcludingInteger, integer, status);
        ;_ArrayDisplay($arrint,"extractinteger()");DEBUG
		$reststr = stripwhitespace($arrint[1]) ;rest of string
        ;msgbox(0,"NamedTimeStringToDTime():stringstripws()","$dtimestr="&$dtimestr);DEBUG
		$integer = $arrint[2] ;integer from atoi64_()
		if (not $arrint[3]) then
			$failed=true;
		endif
		if (not $failed and $reststr<>"") then
			extractkeyword($reststr, $arrkw) ; returns Array(s,keyword,true)
            ;_ArrayDisplay($arrkw,"extractkeyword()");DEBUG
            local $failcount=0
			$keyword = StringLower($arrkw[2]);.toLocaleLowerCase();
			$dtimestr = $arrkw[1]
			if ($arrkw[3]) then
				;-----now we have an inteeger AND a keyword. go to work.
                ;http://en.wikipedia.org/wiki/Tropical_year
                ;http://en.wikipedia.org/wiki/Earth%27s_rotation
                ;mean solar day in ms:86164090.53083288
                ;mean solar year in days:(365.2421896698 - 6.15359*(10^(-6))*(0*36,525) - 7.29*(10^(-10))*((0*36,525)^2) + 2.64*(10^(-10))*((0*36,525)^3))=365.2421896698
                ;mean solar day in ms:(365.2421896698 - 6.15359*(10^(-6))*(0*36,525) - 7.29*(10^(-10))*((0*36,525)^2) + 2.64*(10^(-10))*((0*36,525)^3))*86164090.53083288=31470761096.388280921926183024
                ;mean solar month? in ms:31470761096.388280921926183024/12=2622563424.699023410160515252
				if (-1=arrIndexOf($syear,$keyword)) then
                    $failcount+=1
                else
					$dtime += (31470761096*$integer);(365*24*60*60*1000 + 6*60*60*1000)*$integer
				endif
                if (-1=arrIndexOf($smonth,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (2622563424*$integer);mean solar month? in ms:31470761096.388280921926183024/12=2622563424.699023410160515252
                endif
                if (-1=arrIndexOf($sweek,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (7*24*60*60*1000*$integer)
                endif
                if (-1=arrIndexOf($sday,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (24*60*60*1000*$integer)
                endif
                if (-1=arrIndexOf($shr,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (60*60*1000*$integer)
                endif
                if (-1=arrIndexOf($smin,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (60*1000*$integer)
                endif
                if (-1=arrIndexOf($ssec,$keyword)) then
                    $failcount+=1
                else
                    $dtime += (1000*$integer)
                endif
                if (-1=arrIndexOf($sms,$keyword)) then
                    $failcount+=1
                else
                    ;-----success
                    $dtime += $integer
                endif
                if (8 = $failcount) then
                    ;msgbox(0,"failcount=8","garbage") ;DEBUG
                    $failed=true
                    $garbage=true
                endif
			else
				$failed=true
			endif
		endif
	wend
	if ($garbage) then
		$garbagestring="Garbage was found in the input."&@crlf&"please see help to see what valid input looks like."&@crlf;
        ;msgbox("0","garbage","garbage");DEBUG
	endif
	if (0=$dtime) then
		$failurestring="Inputted Time Format resulted in a zero."&@crlf&"Please refer to help to see what valid input looks like."&@crlf;
        ;msgbox("0","failure","failure");DEBUG
	endif
	if (0=$dtime  or  $garbage  or  $failed) then
	;	msgbox(0, "ERROR IN TIME FORMAT", garbagestring+@crlf+failurestring)
		;return new Array($dtime,false);
        $arr[0]=2
        $arr[1]=$dtime
        $arr[2]=false
        return $arr
	endif
	;return new Array($dtime,true)
    $arr[0]=2
    $arr[1]=$dtime
    ;msgbox(0,"NamedStringToDTime success",DTimeToString($dtime)) ;DEBUG
    $arr[2]=true
    return $arr
endfunc

func extractinteger($s, byref $arr)  ;returns and byrefs the same Array(restOfStringExcludingInteger, integer, status);
    ;msgbox(0,"extractinteger()","arg="&$s);DEBUG
    $s=stringstripws($s,1+2+4)
	local $i,$len=stringlen($s),$ch,$result=0,$sign=1,$start=1,$invalidEnd=0,$end=$invalidEnd,$boundary=false, $started=false
    ;-----set $end inistally to an to a pre-invalid value. for instance, if strings are 0-based, set to -1.
    if (0 = $len) then
        $arr[0]=3
        $arr[1]=$s
        $arr[2]=0
        $arr[3]=false
        return $arr
        ;return new array(s,0,false)
    endif
    ;-----capture only 1 integer at the front.
    ;the way this really works is, the integer MUST be at the front or it will bail out.
	for $i=1 to $len
		$ch=stringmid($s,$i,1)
        ;if ("-"==$ch or "+"==$ch) then
        ;   $sign=-$sign
        ;endif
		;if (-1 <> atoi64_chars.indexOf(ch)) then
		if (0 <> stringinstr($atoi64_chars,$ch,1,1)) then
            ;-----found an atoi64 character
            if (1=$start and not $started) then
                ;-----and this is also the start of the string
		        ;$result=$result*10 + (asc($ch)-asc("0"))
                $start = $i
                $started=true
            endif
            $end = $i ;-----keep updated
        else
            ;-----not an atoi64 character,so this is a terminator character within the string.
            ;$end will point beyond
			$end = $i - 1 ;previous char
            $boundary=true
			exitloop
		endif
	next
	local $sIntSection="",$sExcludingIntSection="",$restOfStringExcludingInteger=""
    if ($started) then
        if ($boundary) then
            $sIntSection = stringmid($s,$start,($end+1)-$start)
            $restOfStringExcludingInteger = stringstripws(stringmid($s,$end+1),1+2+4)
            if ($start > 1) then
                $sExcludingIntSection = stringmid($s,1,$start-1)&stringmid($s,$end+1);string s should be everything but the integer and its boundary char
                ;msgbox(0,"int","boundary,start>1:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            else
                $sExcludingIntSection = stringmid($s,$end+1);string s should be everything but the integer and its boundary char
                ;msgbox(0,"int","boundary,start=1:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            endif
        else
            ;$boundary=false if $invalidEnd=$end
            ;this means the number goes all the way to the end of the string.
            if ($invalidEnd=$end) then
                ;-----we didn't hit a boundary and the end is invalid
                ;-----total failure, found garbage right off. pass it on to keyword parsing to see if that will work
                ;-----and there is no start, no end. end is $invalidEnd
                $sIntSection = ""
                $sExcludingIntSection = $s ;string s should be everything but the integer and its boundary char
                $restOfStringExcludingInteger = $s
                ;msgbox(0,"int","no boundary,end not ok, total failure:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            else
                ;-----we didn't hit a boundary and the end is valid
                ;the sIntSection is the entire string.
                ;-----and there might be a start, no end. end is $invalidEnd
                $sIntSection = $s
                $sExcludingIntSection = "" ;string s should be everything but the integer and its boundary char
                $restOfStringExcludingInteger = ""
                ;msgbox(0,"int","no boundary,end ok:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            endif
        endif
    else
        ;not $started. we hit the boundary right off.
        if ($boundary) then
            $sIntSection = ""
            $restOfStringExcludingInteger = stringstripws($s,1+2+4)
            $sExcludingIntSection = stringstripws($s,1+2+4);string s should be everything but the integer and its boundary char
        else
            ;should not get here because in this !started condition, boundary should be true.

            ;$boundary=false if $invalidEnd=$end
            ;this means the number goes all the way to the end of the string.
            if ($invalidEnd=$end) then
                ;-----we didn't hit a boundary and the end is invalid
                ;-----total failure, found garbage right off. pass it on to keyword parsing to see if that will work
                ;-----and there is no start, no end. end is $invalidEnd
                $sIntSection = ""
                $sExcludingIntSection = $s ;string s should be everything but the integer and its boundary char
                $restOfStringExcludingInteger = $s
                ;msgbox(0,"int","OOPS!not started.no boundary,end not ok, bad state!:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            else
                ;-----we didn't hit a boundary and the end is valid
                ;the sIntSection is the entire string.
                ;-----and there might be a start, no end. end is $invalidEnd
                $sIntSection = $s
                $sExcludingIntSection = "" ;string s should be everything but the integer and its boundary char
                $restOfStringExcludingInteger = ""
                ;msgbox(0,"int","OOPS!not started.no boundary,end ok,bad state!:$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger);DEBUG
            endif
        endif
    endif
    ;msgbox(0,"int status#1",":$sIntSection="&$sIntSection&"$sExcludingIntSection="&$sExcludingIntSection&"$restOfStringExcludingInteger="&$restOfStringExcludingInteger)
	;msgbox(0, "integerVALS", "result="&result&", i="&i&", ch="&ch&", l="&l)
	;if (1=i) {
	;	;-----failure
    ;   integer=0
	;	return false
	;}
	$s=stringmid($s, $i)
	$integer = $sign * $result
	;msgbox(0, "integer", $integer);DEBUG
	local $atoisuccess=true,$atoiresult=0
    ;msgbox(0,"atoi64 fed",""""&$sIntSection&"""");DEBUG
	$atoisuccess = atoi64_($sIntSection,true,true,",",$atoiresult,$sp,$ep)
    ;msgbox(0,"atoi64",$atoisuccess) ;DEBUG
    if ($atoisuccess) then
		;succeeded at atou64_()
		;return new Array(restOfStringExcludingInteger, qq[1], true);
		$arr[0]=3
		$arr[1]=$restOfStringExcludingInteger
		$arr[2]=$atoiresult
		$arr[3]=true
        return $arr
    else
		;failure
        ;return new Array(s, qq[1], false);
		$arr[0]=3
		$arr[1]=$s
		$arr[2]=$atoiresult
		$arr[3]=false
        return $arr
    endif
endfunc

func extractkeyword($s, byref $arr) ; returns Array(s,keyword,true)
    ;msgbox(0,"extractkeyword()",""""&$s&"""");DEBUG
	$s=stringstripws($s,1+2+4);
	local $i,$ch,$result="", $first=true
	for $i=1 to stringlen($s)
		$ch=stringmid($s,$i,1);
		if ($first  and  ("\"==$ch  or  "'"==$ch  or  """"==$ch  or  @lf==$ch  or  @cr==$ch  or  @tab==$ch)) then

		else
			$first = false
		endif
		if (not(issigneddigit($ch))) then
			$result&=$ch
		endif
		if (issigneddigit($ch)) then
			exitloop
		endif
	next
	if (1==$i) then
		;-----failure
		$arr[0]=3
		$arr[1]=$s
		$arr[2]=""
		$arr[3]=false
        return $arr
	else
		$s=stringmid($s,$i)
		$keyword=stringstripws($result,1+2+4)
		;msgbox(0,"keyword",keyword)
		$arr[0]=3
		$arr[1]=$s
		$arr[2]=$keyword
		$arr[3]=true
        return $arr
	endif
endfunc

func iswhitespacechar($ch)
    return " " == $ch  or  @cr == $ch  or  @lf == $ch  or  @tab == $ch
endfunc
;func isdigit($ch)
;    return "0" == $ch  or  "1" == $ch  or  "2" == $ch  or  "3" == $ch  or  "4" == $ch  or  "5" == $ch  or  "6" == $ch  or  "7" == $ch  or  "8" == $ch  or  "9" == $ch
;endfunc

func issigneddigit($ch)
    return "+" == $ch  or "-" == $ch  or  "0" == $ch  or  "1" == $ch  or  "2" == $ch  or  "3" == $ch  or  "4" == $ch  or  "5" == $ch  or  "6" == $ch  or  "7" == $ch  or  "8" == $ch  or  "9" == $ch
endfunc


func arrIndexOf(byref $arr, $val) ;returns index of val or -1 on failure
    return _ArraySearch($arr,$val,1,$arr[0])
endfunc

#comments-start
func stripwhitespace($s)
	local $i,$len=stringlen($s), $result="", $ch, $first=true
	for $i=1 to $len
		$ch=stringmid($s,$i,1)
		if (iswhitespacechar($ch)) then
            if ($first) then
    			$result &= " "; //convert glob of whitespace to space
                $first=false;
            endif
        else
			$result += $ch;
            $first=true
		endif
	next
	;trim is not in IE8, and windows XP systems are still around. like mine. but I use firefox.
    ;if leftmost char is a space,remove 1st char
    if (stringlen($result) >= 1  and  iswhitespacechar(stringmid($result,1,1))) then
        $result=stringmid($result,2)
    endif
    ;if last char is a space,truncate
    if (stringlen($result) >= 1  and  iswhitespacechar(stringmid($result,stringlen($result),1))) then
        $result=stringmid($result,1,stringlen($result)-1)
    endif
	return $result;
endfunc
#comments-end

func stripwhitespace($s)
	local $i,$len=stringlen($s), $result="", $ch, $first=true
	for $i=1 to $len
		$ch=stringmid($s,$i,1)
		if (not iswhitespacechar($ch)) then
    		$result &= $ch
		endif
	next
	return $result;
endfunc


func DTIMEtoMS($dtime)
	return Mod($dtime,1000)
endfunc
func DTIMEtoS($dtime)
	return Mod(Int($dtime/1000),60)
endfunc
func DTIMEtoM($dtime)
	return Mod(Int($dtime/(1000*60)),60)
endfunc
func DTIMEtoH($dtime)
	return Mod(Int($dtime/(1000*60*60)),24)
endfunc
func DTIMEtodays($dtime)
	return Int($dtime/(1000*60*60*24))
endfunc

;as in 2011-02-27
func arrtosqldateformat(byref $arr)
    return zeropad($arr[1],4)&"-"&zeropad($arr[2],2)&"-"&zeropad($arr[3],2)
endfunc

;as in 2011-02-27 23:59:59
func arrtosqldatetimeformat(byref $arr)
    return zeropad($arr[1],4)&"-"&zeropad($arr[2],2)&"-"&zeropad($arr[3],2)&" "&zeropad($arr[4],2)&":"&zeropad($arr[5],2)&":"&zeropad($arr[6],2)
endfunc

;as in 2011-02-27 23:59:59
func arrtosqldatetimemsformat(byref $arr)
    return zeropad($arr[1],4)&"-"&zeropad($arr[2],2)&"-"&zeropad($arr[3],2)&" "&zeropad($arr[4],2)&":"&zeropad($arr[5],2)&":"&zeropad($arr[6],2)&"."&zeropad($arr[7],3)
endfunc

func zeropad($s,$numdigits)
    $zeros="0000000000000000000000000000000000000000000000"
    return $s & stringmid($zeros,1,$numdigits-stringlen($s))
endfunc

func DownloadSpeedToDTime($sizeInBytesStr,$bitsPerSecondStr, $daysPerWorkWeekComputerOnInternet, $hoursPerWeekDayComputerOnInternet, $hoursSaturdayOnInternet, $hoursSundayOnInternet)
    local $overheadratio=1.0+0.13
	local $sz, $bw, $dtime
	if (atou64_($sizeInBytesStr, true,true,",",$sz,$sp,$ep) and atou64_($bitsPerSecondStr, true,true,",",$bw,$sp,$ep)) then
        if ($bw <> 0) then
            local $weekdayuse=0, $satuse=0, $sunuse=0, $use=0
            if (0<>$daysPerWorkWeekComputerOnInternet and 0<>$hoursSaturdayOnInternet and 0<>$hoursSundayOnInternet) then
                $weekdayuse = (24 / $hoursPerWeekDayComputerOnInternet) * (7 / ($daysPerWorkWeekComputerOnInternet + 1 + 1))
                $satuse     = (24 / $hoursSaturdayOnInternet) * 1
                $sunuse     = (24 / $hoursSundayOnInternet) * 1
            endif
            if (0<>$daysPerWorkWeekComputerOnInternet and 0<>$hoursSaturdayOnInternet and 0=$hoursSundayOnInternet) then
                $weekdayuse = (24 / $hoursPerWeekDayComputerOnInternet) * (7 / ($daysPerWorkWeekComputerOnInternet + 1 + 1))
                $satuse     = (24 / $hoursSaturdayOnInternet) * 1
                $sunuse     = 0
            endif
            if (0<>$daysPerWorkWeekComputerOnInternet and 0=$hoursSaturdayOnInternet and 0<>$hoursSundayOnInternet) then
                $weekdayuse = (24 / $hoursPerWeekDayComputerOnInternet) * (7 / ($daysPerWorkWeekComputerOnInternet + 1 + 1))
                $satuse     = 0
                $sunuse     = (24 / $hoursSundayOnInternet) * 1
            endif
            if (0<>$daysPerWorkWeekComputerOnInternet and 0=$hoursSaturdayOnInternet and 0=$hoursSundayOnInternet) then
                $weekdayuse = (24 / $hoursPerWeekDayComputerOnInternet) * (7 / ($daysPerWorkWeekComputerOnInternet + 1 + 1))
                $satuse     = 0
                $sunuse     = 0
            endif
            if (0=$daysPerWorkWeekComputerOnInternet and 0<>$hoursSaturdayOnInternet and 0<>$hoursSundayOnInternet) then
                $weekdayuse = 0
                $satuse     = (24 / $hoursSaturdayOnInternet) * 1
                $sunuse     = (24 / $hoursSundayOnInternet) * 1
            endif
            if (0=$daysPerWorkWeekComputerOnInternet and 0<>$hoursSaturdayOnInternet and 0=$hoursSundayOnInternet) then
                $weekdayuse = 0
                $satuse     = (24 / $hoursSaturdayOnInternet) * 1
                $sunuse     = 0
            endif
            if (0=$daysPerWorkWeekComputerOnInternet and 0=$hoursSaturdayOnInternet and 0<>$hoursSundayOnInternet) then
                $weekdayuse = 0
                $satuse     = 0
                $sunuse     = (24 / $hoursSundayOnInternet) * 1
            endif
            if (0=$daysPerWorkWeekComputerOnInternet and 0=$hoursSaturdayOnInternet and 0=$hoursSundayOnInternet) then
                $weekdayuse = 0
                $satuse     = 0
                $sunuse     = 0
            endif
            $dtime=int(($sz/$bw)*8*$overheadratio*1000 * ($weekdayuse + $satuse + $sunuse) );
        else
            $dtime = 0
        endif
    else
        $dtime = 0
	endif
    return $dtime
endfunc

func JulianDTimeToGregorianString($dtime, $type)   ;type="mm/dd/yyyy","yyyy-mm-dd","mm.dd.yyyy"
    local $a[8]
    JulianDTimeToGregorian($dtime,$a) ;return Array(7,Y,Mo,D,H,Mi,S,ms);
	local $time24hsms=stringformat("%02d:%02d:%02d.%03d",$a[4],$a[5],$a[6],$a[7])
	local $time24hs  =stringformat("%02d:%02d:%02d",$a[4],$a[5],$a[6])
	local $time24h   =stringformat("%02d:%02d",$a[4],$a[5])
    local $worddays = stringformat("%d years %d months %d days %d hours",$a[1],($a[2]-1),($a[3]-1))
    ;trying togo with windows at.exe time format here if we can FIND it
    local $time12hsms,$time12hs,$time12h
    if ($a[4] >= 1 and $a[4] <= 11) then
        $time12hsms = stringformat("%d:%02d:%02d.%03d AM",$a[4],$a[5],$a[6],$a[7])
        $time12hs   = stringformat("%d:%02d:%02d AM",$a[4],$a[5],$a[6])
        $time12h    = stringformat("%d:%02d AM",$a[4],$a[5])
    elseif ($a[4] >= 13 and $a[4] <= 22) then
        $time12hsms = stringformat("%d:%02d:%02d.%03d PM",$a[4]-12,$a[5],$a[6],$a[7])
        $time12hs   = stringformat("%d:%02d:%02d PM",$a[4]-12,$a[5],$a[6])
        $time12h    = stringformat("%d:%02d PM",$a[4]-12,$a[5])
    elseif (0=$a[4]) then
        $time12hsms = stringformat("%d:%02d:%02d.%03d AM",$a[4]+12,$a[5],$a[6],$a[7])
        $time12hs   = stringformat("%d:%02d:%02d AM",$a[4]+12,$a[5],$a[6])
        $time12h    = stringformat("%d:%02d AM",$a[4]+12,$a[5])
    elseif (23=$a[4]) then
        $time12hsms = stringformat("%d:%02d:%02d.%03d PM",$a[4]-12,$a[5],$a[6],$a[7])
        $time12hs   = stringformat("%d:%02d:%02d PM",$a[4]-12,$a[5],$a[6])
        $time12h    = stringformat("%d:%02d PM",$a[4]-12,$a[5])
    endif
	local $timestampw=stringformat("%d hours %d minutes %d seconds %d milliseconds",$a[4],$a[5],$a[6],$a[7])
    switch ($type)
    case "slashes 24hsms" , "mm/dd/yyyy 24hsms"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time24hsms)
    case "slashes 24hs" , "mm/dd/yyyy 24hs"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time24hs)
    case "slashes 24h" , "mm/dd/yyyy 24h"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time24h)
    case "slashes 12hsms" , "mm/dd/yyyy 12hsms"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time12hsms)
    case "slashes 12hs" , "mm/dd/yyyy 12hs"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time12hs)
    case "slashes 12h" , "mm/dd/yyyy 12h"
        return stringformat("%02d/%02d/%04d %s",$a[2],$a[3],$a[1],$time12h)
    case "m/d/y 12hsms"
        return stringformat("%d/%d/%d %s",$a[2],$a[3],$a[1],$time12hsms)
    case "m/d/y 12hs"
        return stringformat("%d/%d/%d %s",$a[2],$a[3],$a[1],$time12hs)
    case "m/d/y 12h"
        return stringformat("%d/%d/%d %s",$a[2],$a[3],$a[1],$time12h)

    case "dots 24hsms" , "mm.dd.yyyy 24hsms"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time24hsms)
    case "dots 24hs" , "mm.dd.yyyy 24hs"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time24hs)
    case "dots 24h" , "mm.dd.yyyy 24h"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time24h)
    case "dots 12hsms" , "mm.dd.yyyy 12hsms"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time12hsms)
    case "dots 12hs" , "mm.dd.yyyy 12hs"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time12hs)
    case "dots 12h" , "mm.dd.yyyy 12h"
        return stringformat("%d.%d.%04d %s",$a[2],$a[3],$a[1],$time12h)

    case "dashes 24hsms" , "mysql 24hsms" , "yyyy-mm-dd 24hsms"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time24hsms)
    case "dashes 24hs" , "mysql 24hs" , "yyyy-mm-dd 24hs"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time24hs)
    case "dashes 24h" , "mysql 24h" , "yyyy-mm-dd 24h"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time24h)
    case "dashes 12hsms" , "mysql 12hsms" , "yyyy-mm-dd 12hsms"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time12hsms)
    case "dashes 12hs" , "mysql 12hs" , "yyyy-mm-dd 12hs"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time12hs)
    case "dashes 12h" , "mysql 12h" , "yyyy-mm-dd 12h"
        return stringformat("%04d-%02d-%02d %s",$a[1],$a[2],$a[3],$time12h)

    case "00:00:00.000" , "24hsms"
        return $time24hsms
    case "00:00:00" , "24hs"
        return $time24hs
    case "00:00" , "24h"
        return $time24h
    case "12hsms" , "12:00:00.000 AM" , "12:00:00.000AM"
        return $time12hsms
    case "12hs" , "12:00:00 AM" , "12:00:00AM"
        return $time12hs
    case "12h" , "12:00 AM" , "12:00AM"
        return $time12h

    case "slashes" , "mm/dd/yyyy"
        return stringformat("%02d/%02d/%04d",$a[2],$a[3],$a[1])
    case "dots" , "mm.dd.yyyy"
        return stringformat("%02d.%02d.%04d",$a[2],$a[3],$a[1])
    case "dashes" , "mysql" , "yyyy-mm-dd"
        return stringformat("%04d-%02d-%02d",$a[1],$a[2],$a[3])
    case "all words" , "all-words"
        return StringFormat("%d years %d months %d days %d hours %s",$a[1],($a[2]-1),($a[3]-1),$timestampw)

    case "wordy 24hsms" , "words 24hsms" , "y years m months d days 24hsms" , "Y Years M Months D Days 24hsms"
        return stringformat("%s %s",$worddays,$time24hsms)
    case "wordy 24hs" , "words 24hs" , "y years m months d days 24hs" , "Y Years M Months D Days 24hs"
        return stringformat("%s %s",$worddays,$time24hs)
    case "wordy 24h" , "words 24h" , "y years m months d days 24h" , "Y Years M Months D Days 24h"
        return stringformat("%s %s",$worddays,$time24h)
    case "wordy 12hsms" , "words 12hsms" , "y years m months d days 12hsms" , "Y Years M Months D Days 12hsms"
        return stringformat("%s %s",$worddays,$time12hsms)
    case "wordy 12hs" , "words 12hs" , "y years m months d days 12hs" , "Y Years M Months D Days 12hs"
        return stringformat("%s %s",$worddays,$time12hs)
    case "wordy 12h" , "words 12h" , "y years m months d days 12h" , "Y Years M Months D Days 12h"
        return stringformat("%s %s",$worddays,$time12h)

    case else
        return "OOPS - PROGRAMMER ERROR in JulianDTimeToGregorianString - unknown type";
    endswitch
endfunc

func DTimeAndJulianDTimeToGregorianString($dtime,$type)
	return DTimeToString($dtime) & " = " & JulianDTimeToGregorianString($dtime, $type);
endfunc




;;52 days 07:33:45.333
;local $d=DownloadSpeedToDTime("148:GB","2:Mb", 5, 4, 12, 8)
;;$d=int($d*24/4)
;msgbox(0,"148GB",DTimeToString($d))
;msgbox(0,"convert to years",JulianDTimeToGregorianString($d, "yyyy-mm-dd 24hsms"))

;;local $d=DaysDTime(52,7,33,45,333)
;;$d*=24/4
;$d=DownloadSpeedToDTime("1:TB","2:Mb", 5, 4, 12, 8)
;msgbox(0,"1TB",DTimeToString($d))
;msgbox(0,"convert to years",JulianDTimeToGregorianString($d, "yyyy-mm-dd 24hsms"))

