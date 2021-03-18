;===============================================================================
;
; Program Name:     kitchentimer
; Abstract:         kitchen timer and stopwatch
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Jim Michaels <jmichae3@yahoo.com>
;
; Copyright 2007 Jim Michaels
;
;This file is part of timer.
;
;    kitchentimer is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    kitchentimer is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with phone.  If not, see <http://www.gnu.org/licenses/>.
;
;
;
;===============================================================================
;
global $PROGRAM_VERSION="4.0" ;this version must match directory it is in
global $PROGRAM_NAME="kitchentimer"


$guiw=470
$guih=15*14+13*25+3*30

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#Include <Date.au3>
#include <Sound.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include "timefuncs.au3"
#include "chk.au3" ;ischecked($controlid)


$sndfile="shortbeep2.wav"
$guibackendbase="kitchentimergui" ;program base filename

$homedir=RegRead("HKEY_CURRENT_USER\Software\Jim Michaels\kitchentimer", "")
if (""==$homedir) then
    $homedir="D:\prj\"&$PROGRAM_NAME&"\"&$PROGRAM_NAME&"-"&$PROGRAM_VERSION  ;this should be the path of the binaries for this program.
endif

If @AutoItX64 Then
    $homedir &= "\64\"
	$guibackend = $homedir & $guibackendbase & ".exe"
else
    $homedir &= "\32\"
	$guibackend = $homedir & $guibackendbase & ".exe"
endif
if (0==FileExists($guibackend)) then
    MsgBox(16, $guibackendbase&" - OOPS!", """"&$guibackend&""" does not exist.  can't continue."&@crlf&"uninstall and reinstall "&$PROGRAM_NAME&" in your program files folder (different for 64-bit than 32-bit)).")
    Exit 1
endif
;msgbox(0,$PROGRAM_NAME&":$homedir",$homedir)





global $countby=0 ;-1:countdown, 1:countup, 0:don't count
global $starttime=0
global $countdowntimefrom=0
global $curtime=0
global $difftime=$curtime-$starttime
global $sndid = _SoundOpen($homedir&"\..\"&$sndfile)
global $snderror=@error
global $execDone = false
global $msgboxdone = false
global $shutdowndone = false
const $originalfixedtime="0 days 00:00:00.000"
const $originalfreetime ="0 days 0 hours 0 min 0 sec 0 ms"
global $countdownTimeInput = $originalfixedtime
global $elapsedtime_backup=""
global $curtime_backup="" ;stop time
global $starttime_backup=""
global $tempelapsedtime=0
if (0=$sndid and 1=$snderror) then
    msgbox(0,$PROGRAM_NAME, "MCI Error, cannot do any sound.")
    exit
elseif (0=$sndid and 2=$snderror) then
    msgbox(0,$PROGRAM_NAME, "Sound file open error, cannot do any sound.")
    exit
endif
;func timediff()
;	$curtime = gettime()
;	return $curtime - $starttime
;endfunc

;switch($snderror)
;case 1=$snderror
;    msgbox(0,$PROGRAM_NAME&" ERROR", "sound file open error:"&$homedir&"\"&$sndfile)
;case 2=$snderror
;    msgbox(0,$PROGRAM_NAME&" ERROR", "sound file doesn't exist.");:"&$homedir&"\"&$sndfile)
;endswitch


;---------------------------------------------------------------------------


;gregorian-julian calendar conversion routines.  do not use with
;gregorian dates under 1500AD.  cerain events occurred which interrupted
;the calendar.
;algorithm from http://en.wikipedia.org/wiki/Julian_day




;Author: Jim Michaels <jmichae3@yahoo.com>
;Abstract: func library for conversion and time extraction from Julian and
;	Gregorian Dates and Javascript Date() objects.
;Create Date:  , 2008
;Current Date: Oct 24, 2009
;Version 2.2


;If you want to do Gregorian date differences based on Julian date differences,
;	make sure you add 4713 to the year component. e.g.
;		$y=GregorianY($jdiff)+4713;
;	everything else is normal.



;Copyright 2008,2009 Jim Michaels
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.

;---------------------------------------------------------------------------



func gettime()
	return curtimeToDTIME()
endfunc
;
;func isbeep()
;	return ischecked($chkBeep)
;endfunc
;func isexec()
;	return ischecked($chkExec)
;endfunc
;func ismsgbox()
;	return ischecked($chkMsgbox)
;endfunc
;func isshutdown()
;	return ischecked($chkShutdown)
;endfunc

func stringtotimediff($s)
	dim $sdays=" days "
	dim $sldays=stringlen($sdays)
	dim $idays=StringInStr($s, $sdays ,0)
	dim $firstcolon=StringInStr($s,":",0,1)
	dim $lastcolon=StringInStr($s,":",0,2)
	dim $dot=StringInStr($s,".")
	if (0==$lastcolon or 0==$firstcolon or 0==$idays) then
	    return 0
	endif
	dim $days=		int(StringMid($s,1,$idays))
	dim $ms = 		int(StringMid($s,$dot+1))
	dim $seconds = 	int(StringMid($s,$lastcolon+1,1+$dot-($lastcolon+1)))
	dim $minutes = 	int(StringMid($s,$firstcolon+1,1+$lastcolon-($firstcolon+1)))
	dim $hours = 	int(StringMid($s,$idays+$sldays,1+$firstcolon-($idays+$sldays)))
	dim $t=numstoDTIMEstring($days, $hours, $minutes, $seconds, $ms)
	;msgbox(0,$t,$days&"days"&$hours&"hours"&$minutes&"minutes"&$seconds&"seconds"&$ms&"ms")
	return $t
endfunc

func elapsedtime()
	;msgbox(0,"",$starttime)
	$curtime = gettime()
	;msgbox(0,"gettime",$curtime)
    if (-1==$countby) then
    	$difftime=$curtime - ($starttime + $countdowntimefrom)
    	$difftime=$curtime - $starttime
    else
    	$difftime=$curtime - ($starttime + $countdowntimefrom)
    	$difftime=$curtime - $starttime; + $countdowntimefrom)
    endif
	dim $absdiff=($difftime)

	return DTIMEtostring($absdiff)
endfunc


func dispcurtime()
    local $t, $a
	$t = _Date_Time_GetSystemTime()
	$a=_Date_Time_SystemTimeToArray($t)
    msgbox(0,"dtgs",stringformat("%d-%d-%d %d:%d:%d.%d",$a[2],$a[0],$a[1], $a[3],$a[4],$a[5],$a[6]))
endfunc

func help()
    $s="kitchentimer is becoming more flexible as time goes on."&@crlf
    $s&=""&@crlf
    $s&="One input format is the fixed format:"&@crlf
    $s&="Example: 106751991166 days 23:59:59.999"&@crlf
    $s&="Example: 0 days 00:00:00.001 or 1 ms"&@crlf
    $s&=@crlf
    $s&="Another input format is the free style format where you give an integer, optional whitespace (tabs or spaces), followed by one of the keywords below:"&@crlf
	$s&="years, years., year, year., yrs, yrs., yr, yr., y., y"&@crlf
	$s&="months, months., month, month., mo, mo., mos, mos."&@crlf
	$s&="weeks, weeks., wks, wks., wk, wk., week, week., w., w"&@crlf
    $s&="days, day, dys., dys, dy., dy"&@crlf
    $s&="hours, hour, hrs., hrs, hr., hr"&@crlf
    $s&="minutes, minute, mins., mins, min., min"&@crlf
    $s&="seconds, second, secs., secs, sec., sec, s., s"&@crlf
    $s&="milliseconds, millisecond, millisecs, millisecs., millisec, millisec., ms, ms."&@crlf
    $s&="You can repeat this integer-keyword sequence as many times as you like.  it will be summed up to make the countdown time only.  Integers can be negative."&@crlf
    $s&="Note that you can expect strange things to happen if the sum turns out to be negative."&@crlf
    $s&="Example: 1 day 217mins.-2hrs  -100ms"&@crlf
    $s&="Example: 1day-2hr2min"&@crlf
    $s&="Example: 217 minutes"&@crlf
    $s&=@crlf
    ;(2^63-1)/1000/60/60/24-365.2524*2012=106,751,256,279.471,845,914,351,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,851,85
    $s&="All 0's will do nothing. This program handles 106,751,256,279 days (292,267,090 years) which is close to 2^36."&@crlf
    $s&="integer63 is signed and case insensitive."&@crlf&"it ignores underscores(_)."&@crlf&" it can start with a - sign and be negative"&@crlf&"and be in any of the following number formats:"&@crlf&"it can be hexadecimal (start with 0x),"&@crlf&"decimal (plain number or start with 0d),"&@crlf&"octal (start with 0, 0q, 0o),"&@crlf&"binary (start with 0b),"&@crlf&"and can be appended with SI units (:B :D :DB :H :HB :K :KB :M :MB :G :GB :T :TB :P :PB :E :EB :Z :ZB :Y :YB)"&@crlf&"or computer units (:Ki :KiB :Mi :MiB :Gi :GiB :Ti :TiB :Pi :PiB :Ei :EiB :Zi :ZiB :Yi :YiB)"&@crlf&"as a multiplier suffix."&@crlf&"priority will be given to longer suffixes in a stream of printable characters."&@crlf
    $s&="all integers are integer63"&@crlf
    $s&=@crlf
    $s&="Shutdown Message doesn't take general printf format specifications."&@crlf
    $s&="If a %d is found (base sensitive), it will be replaced by 'Shutdown Grace Time in minutes' field."&@crlf
    $s&=@crlf
    $s&="Command to execute: this executes from a cmd shell or command.com depending on what OS you have.  to shutdown your machine after a certain time,"&@crlf
    $s&="use shutdown -s or shutdown -s -t 0"&@crlf
    $s&="that command is built into windows.  you can use any command you wish, including something you have written to time box cars for box car races (although I would use more complex"&@crlf
    $s&="hardware for that - see the HTML5 high resolution time API). If checked, the command to execute will be executed once the countdown timer has reached 0. This will only happen once."&@crlf
    $s&=@crlf
    $s&="Turn on countdown alarm:"&@crlf
    $s&="If checked, once the countdown timer has reached 0, the alarm will sound repeating beeps  through the sound card.  It will stop making noise when you hit the stop button."&@crlf
    $s&=@crlf
    $s&="Countdown Logic: if beep alarm is enabled, it will sound and timer will keep going."&@crlf
    $s&="if messagebox is enabled, is will stop the timer."&@crlf
    $s&="if exec is enabled, process will execute once, but timer will keep going."&@crlf
    $s&=@crlf
    $s&="Copyright 2007 Jim Michaels. Under GPl3 License."&@crlf
    $s&="http://sf.net/projects/winkitchentimer"&@crlf
    msgbox(0,$PROGRAM_NAME&" Help",$s)
endfunc


;--------------------------------------process command line-----------------------------------
;dispcurtime()
;exit
;global $c0=Int($CmdLine[0],2)
global $c0=$CmdLine[0]
;msgbox(0,"",$c0)
if ($c0 >= 6 and ("-exec"==$CmdLine[1] or "--exec"==$CmdLine[1] or "/exec"==$CmdLine[1])) then
    $countdownTimeInput = $CmdLine[2] ;original countdown time input
    $starttime_backup = $CmdLine[3] ;start time
    $curtime_backup = $CmdLine[4] ;stop time
    $elapsedtime_backup = $CmdLine[5] ;elapsed time, only changes after reaching 0 for beep
    $s=""
    for $x=6 to $c0
        if ($x = $c0) then ;last element?
            $s &= $CmdLine[$x]
        else
            $s &= $CmdLine[$x] & " "
        endif
    next
    ;msgbox(0,"--exec",$s)
	_Rundos($s)
elseif (5=$c0 and ("-beep"==$CmdLine[1] or "--beep"==$CmdLine[1] or  "/beep"==$CmdLine[1])) then
    $countdownTimeInput = $CmdLine[2] ;original countdown time input
    $starttime_backup = $CmdLine[3] ;start time
    $curtime_backup = $CmdLine[4] ;stop time
    $elapsedtime_backup = $CmdLine[5] ;elapsed time, only changes after reaching 0 for beep
    ;mini gui
    $countby=-1;
    $countdowntimefrom=0;
    $gui1=GUICreate("kitchentimer v"&$PROGRAM_VERSION&" partial", $guiw, $guih)  ; will create a dialog box
    $btnStop = GUICtrlCreateButton("&Stop", 50,                      4*15+4*25+1*30, 50)
    $txtElapsedTime = GUICtrlCreateInput("",   0, 2*15+1*25+0*30, 280, 25, $ES_READONLY)
    GUICtrlSetTip(-1, "elapsed time or time counter")
    GUICtrlCreateLabel("Stop Time",   0, 3*15+3*25+0*30, 120)
    $txtStop = GUICtrlCreateInput("", 0, 4*15+3*25+0*30, 280, 25, $ES_READONLY)
    GUISetState()       ; will display an empty dialog box
        $execdone=false
        $msgboxdone=false
        $curtime=gettime()
        $countdowntimefrom=1
        ;msgbox(0,"sto",$countdowntimefrom)
		if (0==$countdowntimefrom) then
		    ;msgbox(0+64,"kitchentimer input error", "see help to discover the correct way to input countdown time")
			;GuiCtrlSetData($txtInCountdownTime, "0 days 00:00:00.000")
			;-----stringtoDTIME() function already generates its own error messages now.
		else
            ;-----fire off the timer
			$starttime=$curtime+$countdowntimefrom
		    $difftime =$curtime-($starttime+$countdowntimefrom)
                                    ;$difftime=$curtime-($starttime)
			$starttime=$curtime+$countdowntimefrom
		    $difftime =$curtime-$starttime
			$countby=-1
		endif

    While 1
        $MSG = GUIGetMsg()
        Select
        Case $MSG == $btnStop or $MSG == $GUI_EVENT_CLOSE
            $countby=0
            ;$difftime=$curtime-($starttime+$countdowntimefrom)
            guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
            $execdone=true
            $msgboxdone=true
            $shutdowndone=true
            guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
            ;if ($snderror <> 0) then
            ;    _SoundClose($sndid)
            ;endif
            GUIDelete($gui1);
            exitloop

        endselect
        if ($countby <> 0) then
            ;-----update the display and $curtime
            $elapsedtime_backup = elapsedtime()
            GUICtrlSetData($txtElapsedTime, $elapsedtime_backup)

                                    ;$difftime=$curtime-($starttime+$countdowntimefrom)
            ;-----now handle the alarm...
            if (-1==$countby and $curtime>=$starttime and $countdowntimefrom <> 0) then
                if (0==$snderror) then
                    ;---make repeated alarm noise at regular intervals.
                    if (mod(gettime(),2*400) >= 400 and mod(gettime(),8*2*400) >= 4*400) then
                        _SoundPlay($sndid, 1)
                        ;GuiCtrlSetState($btnStop, $GUI_FOCUS)
                        ;GuiCtrlSetState($btnStop, $GUI_ONTOP)
                    endif
                endif
            endif
        endif
    wend
elseif (6=$c0 and ("-msgbox"==$CmdLine[1] or "--msgbox"==$CmdLine[1] or  "/msgbox"==$CmdLine[1])) then
    $countdownTimeInput = $CmdLine[2] ;original countdown time input
    $starttime_backup = $CmdLine[3] ;start time
    $curtime_backup = $CmdLine[4] ;stop time
    $elapsedtime_backup = $CmdLine[5] ;elapsed time, only changes after reaching 0 for beep
    msgbox(0,"kitchentimer",$CmdLine[6])
elseif (7=$c0 and ("-shutdown"==$CmdLine[1] or "--shutdown"==$CmdLine[1] or "/shutdown"==$CmdLine[1])) then
    $countdownTimeInput = $CmdLine[2] ;original countdown time
    $starttime_backup = $CmdLine[3] ;start time
    $curtime_backup = $CmdLine[4] ;stop time
    $elapsedtime_backup = $CmdLine[5] ;elapsed time, only changes after reaching 0 for beep
    $ssmgt=$CmdLine[6] ;minutes grace time
    $s=StringReplace($CmdLine[7], "%d", $ssmgt, 0, 1) ;message. case sensitive global replace.
    $smgt=Int($ssmgt,2)*60
    _RunDOS(@SystemDir&"\shutdown.exe -s -t "&$smgt&" -c """&$s&"""")
else
    ;do gui
    ;_arraydisplay($CmdLine)
endif
;------------------------------------------end of process command line-----------------------------------------------------





$gui2=GUICreate("kitchentimer v"&$PROGRAM_VERSION, $guiw, $guih)  ; will create a dialog box

GUICtrlCreateLabel("countdown time (format: 0 days 00:00:00.000 OR free format: 2 days -5 hrs1ms)", 0, 0*15+0*25+0*30, 400)
$txtInCountdownTime = GUICtrlCreateInput($countdownTimeInput,        0,                1*15+0*25+0*30, 280, 25)
GUICtrlSetState ( -1, $GUI_FOCUS)
GUICtrlSetTip(-1, "format is '0 days 00:00:00.000'  maximum 15 days.") ;maximum 24 days 20:31:23.647 which is 24*24*60*60*1000+20*60*60*1000+31*60*1000+23*1000+647-(2^31-1)
$btnFixed = GUICtrlCreateButton("Set F&ixed Format", 280,              1*15+0*25+0*30, 100)
$btnFree = GUICtrlCreateButton("Set Fre&e Format", 280,              1*15+0*25+1*30, 100)
$btnEggTimerG = GUICtrlCreateButton("Set Egg Timer (&gas)", 280,              1*15+0*25+2*30, 130)
$btnEggTimerE = GUICtrlCreateButton("Set Egg Timer (e&lectric)", 280,              1*15+0*25+3*30, 130)

if (""<>$elapsedtime_backup) then
    $elapsedtime_backup = DTimetoiso8601datetimeformat($elapsedtime_backup)
endif
GUICtrlCreateLabel("Elapsed Time", 0, 1*15+1*25+0*30, 120)
$txtElapsedTime = GUICtrlCreateInput($elapsedtime_backup,   0, 2*15+1*25+0*30, 280, 25, $ES_READONLY)
GUICtrlSetTip(-1, "elapsed time or time counter")

if (""<>$starttime_backup) then
    $starttime_backup = DTimetoiso8601datetimeformat($starttime_backup)
endif
GUICtrlCreateLabel("Start Time",   0, 2*15+2*25+0*30, 120)
$txtStart = GUICtrlCreateInput($starttime_backup, 0, 3*15+2*25+0*30, 280, 25, $ES_READONLY)

if (""<>$curtime_backup) then
    $curtime_backup = DTimetoiso8601datetimeformat($curtime_backup)
endif
GUICtrlCreateLabel("Stop Time",   0, 3*15+3*25+0*30, 120)
$txtStop = GUICtrlCreateInput($curtime_backup, 0, 4*15+3*25+0*30, 280, 25, $ES_READONLY)



$btnStartCountUp = GUICtrlCreateButton("Start Count U&p", 0,     4*15+4*25+0*30, 150)
$btnGoDown = GUICtrlCreateButton("&Down", 0,                     4*15+4*25+1*30, 50)
$btnStop = GUICtrlCreateButton("&Stop", 50,                      4*15+4*25+1*30, 50)
$btnGoUp = GUICtrlCreateButton("&Up", 50*2,                      4*15+4*25+1*30, 50)
GUICtrlSetState($btnGoUp, $GUI_DISABLE)
GUICtrlSetState($btnGoDown, $GUI_DISABLE)
GUICtrlSetState($btnStop, $GUI_DISABLE)
$btnReset = GUICtrlCreateButton("&Reset", 50*2+100,              4*15+4*25+1*30, 80)
$btnHelp = GUICtrlCreateButton("&Help", 50*2+100+80,              4*15+4*25+1*30, 50)
$btnStartCountDown = GUICtrlCreateButton("Start Count Dow&n", 0, 4*15+4*25+2*30, 150)

$chkScheduleTasks = GUICtrlCreateCheckbox("Do Countdown Alarms as popup Windows Scheduled Tasks (closes app, minute resolution)", 0, 4*15+4*25+3*30, $guiw, 25)
GUICtrlSetTip(-1, "schedules tasks for the appropriate alarms which have been checked, then closes this program. program will be reactivated once per alarm. countdown time is lost.")
GUICtrlSetState($chkScheduleTasks, $GUI_UNCHECKED)

guictrlcreategroup("Beep", 5, 4*15+5*25+3*30, $guiw-10, 15*2+1*25)
$chkBeep = GUICtrlCreateCheckbox("Beep on countdown a&larm",            10, 5*15+5*25+3*30, 150, 25)
GUICtrlSetTip(-1, "turns on repeating beep alarm when checked.  alarm stops with the stop button.")
GUICtrlSetState($chkBeep, $GUI_CHECKED)

guictrlcreategroup("MessageBox", 5, 6*15+6*25+3*30, $guiw-10, 15*2+2*25)
    $chkMsgbox = GUICtrlCreateCheckbox("&MessageBox on countdown alarm",    10, 7*15+6*25+3*30, $guiw-20, 25)
    GUICtrlSetTip(-1, "turns on MessageBox dialog box which you click OK, makes 'Donk' sound.")
    GUICtrlCreateLabel("MessageBox text", 10, 7*15+7*25+3*30, 120)
    $txtMsg = GUICtrlCreateInput("Time's Up!", 10, 8*15+7*25+3*30, $guiw-20, 25)
    GUICtrlSetTip(-1, "text for messagebox if you use it")


guictrlcreategroup("Execute command", 5, 9*15+8*25+3*30, $guiw-10, 15*3+2*25)
    ;GUICtrlSetState($chkExec, $GUI_CHECKED)
    $chkExec = GUICtrlCreateCheckbox("E&xecute command on countdown alarm", 10, 10*15+8*25+3*30, 230, 25)
    GUICtrlSetTip(-1, "turns on repeating beep alarm when checked.  alarm stops with the stop button.")
    ;GUICtrlSetState($chkExec, $GUI_CHECKED)

    GUICtrlCreateLabel("Command to execute", 10, 10*15+9*25+3*30, $guiw-10)
    $txtCmd = GUICtrlCreateInput(@SystemDir&"\notepad.exe ""\Users\Public\Documents\gohome.txt""", 10, 11*15+9*25+3*30, $guiw-20, 25)
    GUICtrlSetTip(-1, "command should be a full path or be in the PATH")

guictrlcreategroup("Shutdown", 5, 12*15+10*25+3*30, $guiw-10, 15*3+2*25)
    ;GUICtrlSetState($chkExec, $GUI_CHECKED)
    $chkShutdown = GUICtrlCreateCheckbox("Sh&utdown on countdown alarm", 10, 13*15+10*25+3*30, 170, 25)
    GUICtrlSetTip(-1, "turns on repeating beep alarm when checked.  alarm stops with the stop button.")
    ;GUICtrlSetState($chkExec, $GUI_CHECKED)

    GUICtrlCreateLabel("Shutdown Grace Time in minutes", 180, 13*15+10*25+3*30, 160)
    $txtShutdownMinutesGraceTime = GUICtrlCreateInput("15", 180+160, 13*15+10*25+3*30, 50, 25)
    GUICtrlSetTip(-1, "command should be a full path or be in the PATH")

    GUICtrlCreateLabel("Shutdown Message", 10, 13*15+11*25+3*30, 120)
    $txtShutdownMsg = GUICtrlCreateInput("Shutdown in %d minutes!! [windows-logo-flag-key]-R shutdown -a[Enter] to cancel.", 10, 14*15+11*25+3*30, $guiw-20, 25)
    GUICtrlSetTip(-1, "command should be a full path or be in the PATH")

;$dbgout=GUICtrlCreateEdit("----", 0, 15*15+12*25+3*30, $guiw,25*3)


GUISetState()       ; will display an empty dialog box
$curtime=$starttime=gettime()
$difftime=$curtime-($starttime+$countdowntimefrom)
; Run the GUI until the dialog is closed
While 1
	$MSG = GUIGetMsg()
	Select
    Case $MSG == $GUI_EVENT_CLOSE; Or $MSG = $btnEXIT
		if ($snderror <> 0) then
			_SoundClose($sndid)
		endif
        GuiDelete($gui2)
		Exit



	Case $MSG == $btnStop
		$countby=0
		;$difftime=$curtime-($starttime+$countdowntimefrom)
        guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
        $execdone=true
        $msgboxdone=true
        guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))

	Case $MSG == $btnReset
		$countby=0 ;-----stops the counter
		$starttime=gettime()
		$difftime=0
		GUICtrlSetData($txtElapsedTime, "")
        guictrlsetdata($txtStart,"")
        guictrlsetdata($txtStop,"")
		GUICtrlSetState($btnStop, $GUI_DISABLE)
		GUICtrlSetState($btnGoUp, $GUI_DISABLE)
		GUICtrlSetState($btnGoDown, $GUI_DISABLE)



	Case $MSG == $btnGoUp
        $curtime=gettime()
        if (-1==$countby) then
	    	$countby=1
        elseif (0==$countby) then
    		$countby=1
        endif
		;$difftime=$curtime-($starttime+$countdowntimefrom)
		GUICtrlSetState($btnStop, $GUI_FOCUS)

	Case $MSG == $btnStartCountUp
        $execdone=true
        $msgboxdone=false
        $curtime=gettime()
		$starttime=$curtime
        $countdowntimefrom=0
		$difftime=$curtime-($starttime+$countdowntimefrom)
		$difftime=$curtime-$starttime;+$countdowntimefrom)
		$countby=1
		GUICtrlSetState($btnStop, $GUI_FOCUS)
        guictrlsetdata($txtStart, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
		GUICtrlSetState($btnStop, $GUI_ENABLE)
		GUICtrlSetState($btnGoUp, $GUI_ENABLE)
		GUICtrlSetState($btnGoDown, $GUI_DISABLE)
        guictrlsetdata($txtStop,"")

    Case $MSG == $btnFixed
        guictrlsetdata($txtInCountdownTime, $originalfixedtime)

    Case $MSG == $btnFree
        guictrlsetdata($txtInCountdownTime, $originalfreetime)

    Case $MSG == $btnEggTimerG
        guictrlsetdata($txtInCountdownTime, "3 minutes")

    Case $MSG == $btnEggTimerE
        guictrlsetdata($txtInCountdownTime, "30 minutes")

	Case $MSG == $btnGoDown
        $curtime=gettime()
        if (1==$countby) then
	    	$countby=-1
        elseif (0==$countby) then
    		$countby=-1
        endif
                                    ;$difftime=$curtime-($starttime+$countdowntimefrom)
		GUICtrlSetState($btnStop, $GUI_FOCUS)

	Case $MSG == $btnStartCountDown
        ;counting down, it's going to take more time forward to get to that target point.
        ;so you add the time the user puts in to $curtime for starttime.
        ;for diftime, it's always $curtime-$starttime

        $execdone=false
        $msgboxdone=false
        $starttime=$curtime+$countdowntimefrom
        $curtime=gettime()
        $countdowntimefrom=stringtoDTIME(GUICtrlRead($txtInCountdownTime))

        ;msgbox(0,"sto",$countdowntimefrom)
		if (0==$countdowntimefrom) then
		    ;msgbox(0+64,"kitchentimer input error", "see help to discover the correct way to input countdown time")
			;GuiCtrlSetData($txtInCountdownTime, "0 days 00:00:00.000")
			;-----stringtoDTIME() function already generates its own error messages now.
		else
            ;-----fire off the timer
			$starttime=$curtime+$countdowntimefrom
		    $difftime =$curtime-($starttime+$countdowntimefrom)
                                    ;$difftime=$curtime-($starttime)
			$starttime=$curtime+$countdowntimefrom
		    $difftime =$curtime-$starttime
			$countby=-1
            guictrlsetdata($txtStart, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
            GUICtrlSetState($btnStop, bitor($GUI_FOCUS,$GUI_ENABLE))
            GUICtrlSetState($btnGoUp, $GUI_DISABLE)
            GUICtrlSetState($btnGoDown, $GUI_ENABLE)
            guictrlsetdata($txtStop,"")
            guictrlsetdata($txtElapsedTime, elapsedtime())
            if (ischecked($chkScheduleTasks)) then
                if ($starttime > $curtime) then
                    local $ndt[8], $cdt[8], $targettime,$targetdate
                    JulianDTimeToGregorian($curtime, $cdt)
                    JulianDTimeToGregorian($starttime, $ndt)

                    $targettime = JulianDTimeToGregorianString($starttime, "24hsms")
                    $targetdate = JulianDTimeToGregorianString($starttime, "slashes")
                    ;guictrlsetdata($dbgout, DTimeAndJulianDTimeToGregorianString($starttime,"slashes 24hsms"))
                    ;msgbox(0,"vars","$targettime="&$targettime&"$targetdate="&$targetdate)
                    ;$numdays = floor($difftime/1000/60/60/24)
                    local $isdtsame=($cdt[1]=$ndt[1] and $cdt[2]=$ndt[2] and $cdt[3]=$ndt[3])
                    if (ischecked($chkBeep)) then
                        if ($isdtsame) then
                            ;we don't do a date, just a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive """&$guibackend&""" --beep """&guictrlread($txtInCountdownTime)&""" "&$starttime&"  "&$curtime&"  """&guictrlread($txtElapsedTime)&"""")
                        else
                            ;we do a date and a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive /next:"&$targetdate&" """&$guibackend&""" --beep """&guictrlread($txtInCountdownTime)&""" "&$starttime&"  "&$curtime&" """&guictrlread($txtElapsedTime)&"""")
                        endif
                    endif
                    if (ischecked($chkMsgBox)) then
                        if ($isdtsame) then
                            ;we don't do a date, just a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive """&$guibackend&""" --msgbox """&guictrlread($txtInCountdownTime)&""" "&$starttime&" "&$curtime&" """&guictrlread($txtElapsedTime)&""" """&guictrlread($txtMsg)&"""")
                        else
                            ;we do a date and a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive /next:"&$targetdate&" """&$guibackend&""" --msgbox """&guictrlread($txtInCountdownTime)&""" "&$starttime&" "&$curtime&" """&guictrlread($txtElapsedTime)&""" """&guictrlread($txtMsg)&"""")
                        endif
                    endif
                    if (ischecked($chkExec)) then
                        if ($isdtsame) then
                            ;we don't do a date, just a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive """&$guibackend&""" --exec """&guictrlread($txtInCountdownTime)&""" "&$starttime&"  "&$curtime&" """&guictrlread($txtElapsedTime)&""" "&guictrlread($txtCmd))
                        else
                            ;we do a date and a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive /next:"&$targetdate&" """&$guibackend&""" --exec """&guictrlread($txtInCountdownTime)&""" "&$starttime&" "&$curtime&" """&guictrlread($txtElapsedTime)&""" "&guictrlread($txtCmd))
                        endif
                    endif
                    if (ischecked($chkShutdown)) then
                        if ($isdtsame) then
                            ;we don't do a date, just a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive """&$guibackend&""" --shutdown """&guictrlread($txtInCountdownTime)&""" "&$starttime&" "&$curtime&" """&guictrlread($txtElapsedTime)&""" "&guictrlread($txtShutdownMinutesGraceTime)&" """&guictrlread($txtShutdownMsg)&"""")
                        else
                            ;we do a date and a time
                            _rundos(@SystemDir&"\at.exe "&$targettime&" /interactive /next:"&$targetdate&" """&$guibackend&""" --shutdown """&guictrlread($txtInCountdownTime)&""" "&$starttime&" "&$curtime&" """&guictrlread($txtElapsedTime)&""" "&guictrlread($txtShutdownMinutesGraceTime)&" """&guictrlread($txtShutdownMsg)&"""")
                        endif
                    endif

                    ;analyze if we need to exit. at this point, scheduled tasks is turned on.
                    if (ischecked($chkBeep) or ischecked($chkMsgBox) or ischecked($chkShutdown) or ischecked($chkExec)) then
                        ;msgbox(0,"target time",JulianDTimeToGregorianString($starttime, "mm/dd/yyyy 12h"))
                        ;msgbox(
                        if ($snderror <> 0) then
                            _SoundClose($sndid)
                        endif
                        GuiDelete($gui2)
                        Exit

                    endif
                else
                    ;starttime <= $curtime, so event will be in the past and won't fire and will simply clutter up system.
                    msgbox(0,$PROGRAM_NAME,"event would be in the past, please re-figure youir time calculations. it comes out to "&@crlf&DTimeAndJulianDTimeToGregorianString($starttime,"slashes 12h"))
                endif
            endif
		endif

	Case $MSG == $btnHelp
        help()
	EndSelect

	;the following code is executed in a "while forever" windows message loop.
	;as long as messages are being processed, this will execute.
	if ($countby <> 0) then
        ;-----update the display and $curtime
		GUICtrlSetData($txtElapsedTime, elapsedtime())
		                        ;$difftime=$curtime-($starttime+$countdowntimefrom)
		;-----now handle the alarm...
		if ((not ischecked($chkScheduleTasks)) and -1==$countby and $curtime>=$starttime and $countdowntimefrom <> 0) then
			if (ischecked($chkExec) and (not $execdone)) then
				Run(GUICtrlRead($txtCmd))
				$execdone=true
                guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
			endif
			if (ischecked($chkBeep) and 0==$snderror) then
				;---make repeated alarm noise at regular intervals.
				if (mod(gettime(),2*400) >=400 and mod(gettime(),8*2*400) >= 4*400) then
					_SoundPlay($sndid, 1)
					;GuiCtrlSetState($btnStop, $GUI_FOCUS)
					GuiCtrlSetState($btnStop, $GUI_ONTOP)
				endif
            endif
			if (ischecked($chkMsgbox) and (not $msgboxdone)) then
                ;-----display a msgbox rather than the alarm. alarm is disabled.
				;display a messagebox instead and don't do anything special. it already makes a noise.
                guictrlsetdata($txtStop, numstoiso8601datetimeformat(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC))
				$countby=0
                $msgboxdone=true
				msgbox(0,"kitchentimer",guictrlread($txtMsg))
			endif
            if (ischecked($chkShutdown) and (not $shutdowndone)) then
                $countby=0
                $shutdowndone=true
                $ssmgt=guictrlread($txtShutdownMinutesGraceTime)
                $s=guictrlread($txtShutdownMsg)
                $smgt=Int($ssmgt,2)*60
                $s=StringReplace($s, "%d", $ssmgt, 0, 1)
                run(@SystemDir&"\shutdown.exe -s -t "&$smgt&" -c """&$s&"""")
            endif
		endif
	endif
Wend

