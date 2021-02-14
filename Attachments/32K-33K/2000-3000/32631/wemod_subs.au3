#include <GUIConstants.au3>

; -------------------------------------------------------------------------
; String functions

func len( $s) ;                                                        ;{{{
#cs
  Returns number of characters in string.
#ce

  return stringlen( $s)
endfunc
; }}}

func substr( $s, $i, $j= "len") ;                                      ;{{{
#cs
  Returns substring by positions in string.
#ce
  if $i < 1 then $i = 1
  if @NUMPARAMS == 2 then
  $j = len( $s)
  elseif $j > len( $s) then
  $j = len( $s)
  endif

  if $j < $i then return ""
  return stringmid( $s, $i, $j - $i + 1)
endfunc
; }}}

func str_next( $s, $t, $i= 1) ;                                        ;{{{
#cs
  Returns position of substring in string or len($s)+1.
  Search from given position to the right.
#ce
  local $j, $m

  $m= len($s)+1
  if $i < 1 or @NUMPARAMS == 2 then
    $i = 1
  elseif $i > len( $s) then
    return $m
  endif

  if $t == "" then return $i
  $s= substr( $s, $i)
  $j = stringinstr( $s, $t)
  if $j == 0 then return $m
  return $i -1 +$j
endfunc
; }}}

func str_prev( $s, $t, $i= "len") ;                                    ;{{{
#cs
  Returns position of substring in string or 0.
  Search from given position to the left.
#ce
  local $j

  if @NUMPARAMS == 2 then
    $i= len( $s)
  elseif $i > len( $s) then
    $i= len( $s)
  elseif $i < 1 then
    return 0
  endif

  if $t == "" then return $i
  $s= substr( $s, 1, $i+len($t)-1)
  $j= stringinstr( $s, $t, 1, -1)
  if $j == 0 then return 0
  return $j
endfunc
; }}}

func str_replace( $s, $t, $u) ;                                        ;{{{
#cs
  Returns string with all substrings replaced.
#ce

  return StringReplace( $s, $t, $u, 0, 1)
endfunc
; }}}
; -------------------------------------------------------------------------
; Array functions

func str2arr( $s) ;                                                    ;{{{
#cs
  Returns array from substrings by trailing delimiters.
#ce
  local $d, $a

  $d= substr( $s, len($s))
  $s= substr( $s, 1, len($s)-1)
  $a= stringsplit( $s, $d, 1)
  $a[0]= $d

  return $a
endfunc ; }}}

func imax( $a) ;                                                       ;{{{
#cs
  Returns maximum index of array
#ce
  return ubound( $a) -1

endfunc ; }}}
; -------------------------------------------------------------------------
; File functions

func write_file( $file, $s, $mode= "") ;                               ;{{{
#cs
  Writes string to file.
#ce
  local $u

  if $mode == "append" then
    $u= fileopen( $file, 1) ; 1==append
  else
    $u= fileopen( $file, 2) ; 2==overwrite
  endif

  ; Make normal newlines.
  $s= StringReplace( $s, @CRLF, @LF)

  ; Append a trailing LF to a non-empty string if missed.
  $s= StringRegExpReplace( $s, "(.)\z", "$1" & @LF)

  ; Revert to DOS.
  $s= StringReplace( $s, @LF, @CRLF)

  filewrite( $u, $s)

  fileclose( $u)
Endfunc
; }}}

func read_file( $file) ;                                               ;{{{
#cs
  Returns content of file.
#ce
  local $u, $s

  $u= fileopen( $file, 0) ; 0==readonly

  $s= fileread( $u)
  $s= StringReplace( $s, @CRLF, @LF)

  $s= StringRegExpReplace( $s, "(.)\z", "$1" & @LF)

  fileclose( $u)
  return $s
Endfunc
; }}}

func filep( $fil) ;                                                    ;{{{
#cs
  Checks if file is present (0|1).
#ce
  local $c

  if not fileexists( $fil) then return 0

  $c= substr( $fil, len($fil))

  return ( $c <> "\" and $c <> ":") *1
Endfunc
; }}}

func dirp( $dir) ;                                                     ;{{{
#cs
  Checks if directory is present (0|1).
#ce

  if not fileexists( $dir) then return 0

  return (substr( $dir, len($dir)) == "\")*1
endfunc
; }}}

func files_by_dir( $dir, $par="") ;                                    ;{{{
#cs
  Returns filenames by directory.
#ce
  local $s

  ; Each output line has a trailing LF.
  $s= run_cmd( "dir " & $par & " """ & $dir & """ /b/l")

  $s= StringRegExpReplace( $s, "\n\n", @LF)

  return str2arr( $s)
endfunc
; }}}

func split_filespec( $file, $pat) ;                                    ;{{{
#cs
  Returns single element or array.
  Examples for pat
    "db"     => ret= directory +basename
    "be"     => ret= basename+extension
    "db,d,"  => ret[1]= directory +basename,  ret[2]= directory
    "d,b,e," => ret[1]= directory, ret[2]= basename, ret[3]= extension
#ce

  local $a, $c, $i, $s, $n
  local $dir, $rid, $bas, $ext

  $i= str_prev( $file, "\")
  if $i < 1 then $i = str_prev( $file, ":")

  $dir= substr( $file, 1, $i)
  $rid= substr( $file, $i +1)

  $i= str_prev( $rid, ".")
  if $i < 1 then $i= len($rid)+1

  $bas= substr( $rid, 1, $i-1)
  $ext= substr( $rid, $i)

  $s= ""
  $n= len($pat)
  for $i= 1 to $n
    $c= substr($pat,$i,$i)
    if $c == "d" then
      $s &= $dir
    elseif $c = "b" then
      $s &= $bas
    elseif $c = "e" then
      $s &= $ext
    else
      $s &= $c
    endif
  next

  if substr( $pat, $n) == "," then $s= str2arr( $s)

  return $s
endfunc
; }}}

func backup_file( $file, $ext) ;                                       ;{{{
#cs
  Make a backup-copy with extension of file.
#ce
  local $a, $f, $k, $s, $m
  local $i1, $k1, $db

  $a= split_filespec( $file, "db,b,")
  $db= $a[1]
  $i1= len($a[2]) +2

  ; Get $k1, index of latest backup file
  $a= files_by_dir( $db & "_*" & $ext, "")
  $k1= 0
  for $m= 1 to imax($a)
    $f= $a[$m]
    $s= substr( $f, $i1, len($f) -4)
    $k= $s*1
    if ($k & "") == $s then $k1= max( $k, $k1)
  next

  FileCopy( $file, $db & "_" & ($k1+1) & $ext)
endfunc
; }}}
; -------------------------------------------------------------------------
; Registry functions

func reg_keyp( $key) ;                                                 ;{{{
#cs
  Checks if key is present in registry.
#ce
  local $r

  $r= RegRead( $key, "")

  return (@error = 0 or @error = -1)
endfunc
; }}}

func reg_varp( $key, $var) ;                                           ;{{{
#cs
  Checks if $var under $key is present in registry.
#ce
  local $r

  $r= RegRead( $key, $var)

  return (@error = 0)
endfunc
; }}}

func reg_val( $key, $var) ;                                            ;{{{
#cs
  Returns value of $var under $key in registry or "".
#ce
  local $r

  $r= RegRead( $key, $var)
  if @error <> 0 then $r= ""

  return $r
endfunc
; }}}

func reg_subkey( $key, $i) ;                                           ;{{{
#cs
  Returns i-th subkey under $key in registry or ""
#ce
  local $r

  $r= RegEnumKey( $key, $i)
  if @error then $r= ""

  return $r
endfunc
; }}}

func reg_export( $key) ;                                               ;{{{
#cs
  Returns exported key.
#ce
  local $tmp, $cmd

  $tmp= @ScriptDir & "\regkey.tmp"

  FileDelete( $tmp)
  if filep( $tmp) then abort( "could not delete " & $tmp)

  $cmd= @SystemDir & "\reg.exe export " & $key & " " & $tmp
  RunWait( @ComSpec & " /c " & $cmd, @TempDir, @SW_HIDE)

  return read_file( $tmp)
endfunc
; }}}

func reg_import( $fil) ;                                               ;{{{
#cs
  Import from file to registry.
#ce
  local $cmd

  $cmd= @SystemDir & "\reg.exe import " & $fil
  RunWait( @ComSpec & " /c " & $cmd, @TempDir, @SW_HIDE)

endfunc
; }}}
; -------------------------------------------------------------------------
; Dialog functions

func alert( $t) ;                                                      ;{{{

  local $t_w= StringRegExpReplace( @ScriptName, "(?i).exe$", "")
  SplashOff()
  ; 0 = Ok
  msgbox( 0, $t_w, $t)

endfunc
; }}}

func confirm( $t) ;                                                    ;{{{

  local $t_w= StringRegExpReplace( @ScriptName, "(?i).exe$", "")
  SplashOff()
  ; 1 = Ok and Cancel
  return ( msgbox( 1, $t_w, $t) == 1)
endfunc
; }}}

func choice( $s) ;                                                     ;{{{

  local $a, $n, $m, $i, $k, $t, $y
  local $x_w, $x_t, $y_w, $y_d, $x_b, $msg

  ; window title, remove .exe case-insensitive
  local $t_w= StringRegExpReplace( @ScriptName, "(?i).exe$", "")

  ; convert to array
  $a= str2arr( $s)
  $n= imax( $a)

  local $c[1+$n]

  for $k= 0 to 1
    if $k then GUICreate( $t_w, $x_w, $y_w)
    $y= -6
    $x_w= 100 +len($t_w)*12
    $x_w= 100 +len($t_w)*12
    $y_p= 0

    for $i= 2 to $n step 2
      $t= $a[$i]
      $x_w = max( $x_w, 6 +len($t)*6)
      if $a[$i-1] then
        $y += $y_p +9
        if $y_p < 9 then $y+= 3
        if $k then $c[$i]= GUICtrlCreateButton( $t, 3, $y, $x_t)
        $y_p= 16
      else
        $y += $y_p +9
        if $y_p > 5 then $y+= 3
        if $k then GUICtrlCreateLabel( $t, 6, $y, $x_t)
        $c[$i]= -1
        $y_p= 4
      endif
    next
    $x_t= $x_w-6
    $y_w= $y +$y_p+11
  next

  SplashOff()
  GUISetState( @SW_SHOW)

  While 1
    $msg = GUIGetMsg()
    if $msg = $GUI_EVENT_CLOSE then return "close"
    for $i= 2 to $n step 2
      if $msg = $c[$i] then exitloop 2
    next
  WEnd

  GUIDelete()
  return $a[$i-1]
endfunc
; }}}

func status( $t= "") ;                                                 ;{{{

  local $a, $i, $m, $n
  local $fs, $t_w, $x_w, $y_w

  if $t then
    $t_w= StringRegExpReplace( @ScriptName, "(?i).exe$", "")
    ; append LF if last character is non-LF
    $t= StringRegExpReplace( $t, "(.)\z", "$1" & @LF)
    $a= str2arr($t)
    $n= imax($a)
    $m= 0
    for $i= 1 to $n
      $m= max( $m, len($a[$i]))
    next
    $fs= 10
    $x_w= max( 80 +len($t_w)*13, 12 +$m*1.4*$fs)
    $y_w= 23 +$n*1.67*$fs
    SplashTextOn( $t_w & " - Please wait", $t, $x_w, $y_w, _
      default, default, 16, default, $fs)
  else
    SplashOff()
  endif
endfunc
; }}}

func abort( $t= "") ;                                                  ;{{{

  local $t_w= StringRegExpReplace( @ScriptName, "(?i).exe$", "")
  SplashOff()
  if $t then msgbox( 0, $t_w & " - abort", $t)
  exit
endfunc
; }}}
; -------------------------------------------------------------------------
; Windows Explorer functions

func we_restart() ;                                                    ;{{{

  local $i= 0, $p= "explorer.exe"

  status( "Restart WE - shutdown")

  while ProcessExists( $p)
    $i += 1
    if $i > 10 then abort( "Failed to close " & $p)
    ProcessClose( $p)
    sleep(200)
  wend

  sleep(500)
  status( "Restart WE - start")

  ProcessWait( $p)

  status( "Restart WE - open folder")

  ShellExecute( @ScriptDir)
  ; Run( $p & " """ & @ScriptDir & """")

endfunc
; }}}
; -------------------------------------------------------------------------
; Misc functions

func max( $x1, $x2) ;                                                  ;{{{

  if $x2 > $x1 then return $x2
  return $x1
endfunc
; }}}

func run_cmd( $cmd) ;                                                  ;{{{

  Local $u, $s

  $u= Run( @ComSpec & " /c " & $cmd, @TempDir, @SW_HIDE, 0x2)
  $s= ""
  While not @error
    $s &= StdoutRead($u)
  WEnd

  return StringRegExpReplace( $s, "\r\n", @LF)
EndFunc
; }}}
; -------------------------------------------------------------------------
