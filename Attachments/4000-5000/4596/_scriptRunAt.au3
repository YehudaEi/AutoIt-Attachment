
;---------------------------------------------------------------------------
;
;By JC aka JoeCool
;email  n4538w7337@yahoo.com
;
;---------------------------------------------------------------------------
;There 2 ways to start it, it can be called either with parameters
;or an ini file with parameters (much fun if you drag and
;drop an ini file onto .au3 ) ;-)
;
;
;scriptRunAt timestart script [scriptparam [repeat repeatincr]]
;scriptRunAt param.ini
;
;
;timestart  yyyy/mm/dd hh:mm:ss
;script  full path to the script to start
;scriptparam   optionnal string pass to the script
;repeat  0 = continuously,  1 = one time  20 = 20 times ...
;repeatincr  yyyy/mm/dd hh:mm:ss
; 0000/00/00 00:01:00 script will run each minute ...
;
;---------------------------------------------------------------------------






#include <Date.au3>

;datetime
;---------------------------------------------------------------------------
;yyyy/mm/dd hh:mm:ss

func dtAdd( $x, $y )
   local $d, $t

   _DateTimeSplit( $y, $d, $t )
   $x = _DateAdd ( "Y", $d[1], $x )
   $x = _DateAdd ( "M", $d[2], $x )
   $x = _DateAdd ( "D", $d[3], $x )
   $x = _DateAdd ( "h", $t[1], $x )
   $x = _DateAdd ( "n", $t[2], $x )
   $x = _DateAdd ( "s", $t[3], $x )
   return( $x )
endfunc


func dtDateTimeDiff( $x, $y )
   local $z, $yd, $yt, $zd, $zt

   $z = $x
   _DateTimeSplit( $y, $yd, $yt )

   $z = _DateAdd ( "s", 0 - $yt[3], $z )
   $z = _DateAdd ( "n", 0 - $yt[2], $z )
   $z = _DateAdd ( "h", 0 - $yt[1], $z )

   _DateTimeSplit( $z, $zd, $zt )
   $hms = stringFormat( "%02d:%02d:%02d", $zt[1], $zt[2], $zt[3] )
   $zz = stringFormat( "%04d/%02d/%02d %s", $yd[1], $yd[2], $yd[3], $hms )

   $nm = _DateDiff ( "m", $y, $x )
   $ny = int( $nm / 12 )
   $nm -= $ny * 12

   $zz = _DateAdd ( "y", $ny, $zz )
   $zz = _DateAdd ( "m", $nm, $zz )

   $nd = 0
   while $zz < $z
      $nd += 1
      $zz = _DateAdd ( "d", 1, $zz )
   wend
   $z = stringFormat( "%04d/%02d/%02d %s", $ny, $nm, $nd, $hms )
   return( $z )
endfunc


func dtNow()
   return( _nowCalc() )
endfunc


func dtTimeDiff( $x, $y )
   local $z, $d, $xt, $yt, $zt, $zd

   _DateTimeSplit( $x, $d, $xt )
   _DateTimeSplit( $y, $d, $yt )

   $z = _nowCalc()
   _DateTimeSplit( $z, $zd, $zt )

   $z = stringFormat( "%04d/%02d/%02d", $zd[1], $zd[2], $zd[3] )
   $z = stringFormat( "%s %02d:%02d:%02d", $z, $xt[1], $xt[2], $xt[3] )

   $z = _DateAdd ( "s", 0 - $yt[3], $z )
   $z = _DateAdd ( "n", 0 - $yt[2], $z )
   $z = _DateAdd ( "h", 0 - $yt[1], $z )

   _DateTimeSplit( $z, $zd, $zt )
   $z = stringFormat( "0000/00/00 %02d:%02d:%02d", $zt[1], $zt[2], $zt[3] )
   return( $z )
endfunc


func dtToMSec( $dt )
   local $d, $t, $ticks

   _DateTimeSplit( $dt, $d, $t )
   $ticks = _timeToTicks ( $t[1], $t[2], $t[3] )
   return( $ticks )
endfunc

;---------------------------------------------------------------------------

func xAutoItExe()
   local $s
   $s = RegRead( "HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir" )
   $s &= "\AutoIt3.exe"
   return( $s )
endfunc


func fileRunAutoItScript( $script, $param )
   local $cmd

   if $script <> "" and stringRight( $script, 1 ) <> "\" then
      $cmd = $autoItExe
      $cmd &= " """ & $script & """ """ & $param & """ "
      ;msgbox(0, "cmd", $cmd )
   	return( runWait( $cmd ) )
   endif
endfunc


func readini()
   $ini = true
   $file = $CmdLine[1]
   $jobTimeStart = iniRead ( $file, "info", "timestart", "" )
   $jobScript = iniRead ( $file, "info", "script", "" )
   $jobParams = iniRead ( $file, "info", "params", "" )
   $jobRepeat = iniRead ( $file, "info", "repeat", "" )
   $jobRepeatIncr = iniRead ( $file, "info", "repeatincr", "" )
endfunc

func writeini()
   iniWrite( $file, "info", "timestart", $jobTimeStart )
   iniWrite( $file, "info", "script", $jobScript )
   iniWrite( $file, "info", "params", $jobParams )
   iniWrite( $file, "info", "repeat", $jobRepeat )
   iniWrite( $file, "info", "repeatincr", $jobRepeatIncr )
endfunc


func onAutoItExit()
   if $ini then
      writeini()
   endif
endfunc


;Application
;---------------------------------------------------------------------------
;
;  dmax 01:00:00                             dmin 0:05      dsync 0:02   exe
;  smax 00:59:55         (stime-dmin)        ssmall 0:01    ssync 0:00.5


global $delayMax = "0000/00/00 01:00:00"
global $delayMin = "0000/00/00 00:00:05"
global $delayStartSync = "0000/00/00 00:00:02"

global $sleepTimeMax = "0000/00/00 00:59:55"
global $sleepTimeSmall = "0000/00/00 00:00:01"
global $sleepTimeSync = 500


global $jobTimeStart = ""
global $jobScript = ""
global $jobParams = ""
global $jobRepeat = 1
global $jobRepeatIncr = "0000/00/00 00:00:00"

global $autoItExe = xAutoItExe()

global $now, $sleepTime
global $ini = false
global $file, $i, $strtip



if $CmdLine[0] = 1 then
   readini()
else
   $jobTimeStart = $CmdLine[1]
   $jobScript = $CmdLine[2]
   if $CmdLine[0] >= 3 then
      $jobParams = $CmdLine[3]
   endif
   if $CmdLine[0] >= 4 then
      $jobRepeat = $CmdLine[4]
   endif
   if $CmdLine[0] = 5 then
      $jobRepeatIncr = $CmdLine[5]
   endif
endif


if $jobRepeat <> 1 then
   $now = dtNow()
   while $jobTimeStart < $now
      $jobTimeStart = dtAdd( $jobTimeStart, $jobRepeatIncr )
      $now = dtNow()
   wend
   if $ini then
      writeini()
   endif
endif



while 1
   $i = stringInStr( $jobScript, "\", 0, -1 )
   if $i > 0 then
      $strtip = stringTrimLeft( $jobScript, $i ) & " @ " & $jobTimeStart
   else
      $strtip = ""
   endif
   traySetToolTip( $strtip )

   $now = dtNow()
   if $jobTimeStart <= $now  then
      traySetState( 4 )
      fileRunAutoItScript( $jobScript, $jobParams )
      if $jobRepeat = 1 then
         exitloop
      else
         if $jobRepeat > 1 then
            $jobRepeat -= 1
         endif
         $jobTimeStart = dtAdd( $jobTimeStart, $jobRepeatIncr )
      endif
      traySetState( 8 )
   else
      $sleepTime = dtDateTimeDiff( $jobTimeStart, $now )
      if $sleepTime <= $delayStartSync then
         sleep( $sleepTimeSync )
      else
         if $sleepTime <= $delayMin then
            sleep( dtToMSec( $sleepTimeSmall ) )
         else
            if $sleepTime <= $delayMax then
               sleep( dtToMSec( dtTimeDiff( $sleepTime, $delayMin ) ) )
            else
               sleep( dtToMSec( $sleepTimeMax ) )
            endif
         endif
      endif
   endif
wend


