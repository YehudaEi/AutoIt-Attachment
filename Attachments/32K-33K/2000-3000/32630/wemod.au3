#cs autoit3 3.3.6.1
  kes 2010-12-13

  Script to modify and check certain features of Windows Explorer.
  For each feature there is a function with description below. See the
  source for more details.

  This script should be stored locally in its own folder. It can be
  used without further installation. Each run will create a new
  wemod_log.txt, the previous log file will be saved as backup.

  A subfolder regs is created to store exported registry keys. To
  reactivate certain features, these keys can be merged groupwise
  using this script or one by one via Windows Explorer, right click
  Merge.
  
  Tested on Windows XP/SP3. Use at your own risk. Using of System
  Restore is recommended to undo all changes at once.

#ce
#include <wemod_subs.au3>
global $wlogf
main()
; -------------------------------------------------------------------------
func main()

  local $i, $t, $m, $chm, $chi, $mods, $prefs

  ; Configurable preferences for Do_this with reference
  ; to mod functions defined below.
  $prefs= str2arr("" _
  & "remove|print|" _
  & "remove|printto|" _
  & "remove|edit|" _
  & "remove|wmp|" _
  & "remove|share|" _
  & "remove|runas|" _
  & "remove|shortto|" _
  )

  $t= ""
  for $i= 1 to imax($prefs) step 2
    $chi= $prefs[$i]
    $m= $prefs[$i+1]
    $t &= "|" & $chi & " " & m_title($m) & "|"
  next

  $chm= choice( $t _
    & "dothis|Do this|" _
    & "checkall|Check all|" _
    & "status|Check status|" _
    & "sysres|Run System Restore|" _
    & "restart|Restart Windows Explorer|" _
    & "info|Read info|" _
    & "close|Quit|" _
    )

  if $chm = "close" then exit
  if $chm = "sysres" then
    Run( @SystemDir & "\restore\rstrui.exe")
    exit
  endif
  if $chm = "restart" then
    we_restart()
    exit
  endif
  if $chm = "info" then
    ShellExecute( get_info())
    exit
  endif

  ; Configurable items for Check_all and Check_status with
  ; reference to mod functions defined below.
  $mods= str2arr("print|printto|edit|wmp|share|runas|shortto|")

  if $chm = "status" then
    $t= ""
    for $i= 1 to imax($mods)
      $m= $mods[$i]
      $t &= $m & ": " & @tab & m_status( $m) & @LF
    next
    $t &= @LF & "--> wemod_log.txt"
    alert( $t)
    exit
  endif

  if not confirm("The following operations may harm your system." _
    & @LF & "They were tested on Windows XP/SP3 only." _
    & @LF & "Be sure to have a recent system restore point." _
    & @LF & "Read info before usage." _
    & @LF _
    & @LF & "CONTINUE ON YOUR OWN RISK!") then exit

  if $chm = "dothis" then
    status("Do this")
    for $i= 1 to imax($prefs) step 2
      $chi= $prefs[$i]
      $m= $prefs[$i+1]
      Call( "mod_" & $m, $chi)
    next

  elseif $chm = "checkall" then
    for $i= 1 to imax($mods)
      $m= $mods[$i]
      $t= "|" & m_title( $m) & "|" _
      & "remove|Remove|" _
      & "add|Add|" _
      & "|Current status: " & m_status( $m) & "|" _
      & "skip|Skip this item|" _
      & "exit|Exit|"
      $chi= choice( $t)
      if $chi = "close" then exit
      if $chi = "exit" then exitloop
      if $chi = "skip" then continueloop
      Call( "mod_" & $m, $chi)
    next
  endif

  alert( "Done --> wemod_log.txt" _
  & @LF _
  & @LF & "To finalize modifications you may" _
  & @LF & "need to restart Windows Explorer.")

endfunc
; -------------------------------------------------------------------------
; mod functions, each must handle:
; $chi= "title", "status", "remove" and "add".

func mod_print( $chi) ;                                                ;{{{
#cs
  Print in context menu of Windows Explorer.
  Remove: Registry keys will exported to regs\ and deleted from registry.
  Add: Registry keys from regs\ are imported to registry.
#ce
  if $chi = "title" then return "Print in context menu"
  wlog( $chi & " print")

  local $n= 0

  $n += mreg( $chi, "print_app", "HKCR\Applications", "shell\print")
  $n += mreg( $chi, "print_nul", "HKCR",  "shell\print")
  $n += mreg( $chi, "print_sys", "HKCR\SystemFileAssociations",  "shell\print")

  return mret( $chi, $n)
endfunc
; }}}

func mod_printto( $chi) ;                                              ;{{{
#cs
  printto in Windows Explorer.
  This is needed for drag&drop of files on a printer.
  Remove: Registry keys will exported to regs\ and deleted from registry.
  Add: Registry keys from regs\ are imported to registry.
#ce
  if $chi = "title" then return "printto"
  wlog( $chi & " printto")

  local $n= 0

  $n += mreg( $chi, "printto_app", "HKCR\Applications", "shell\printto")
  $n += mreg( $chi, "printto_nul", "HKCR", "shell\printto")
  $n += mreg( $chi, "printto_sys", "HKCR\SystemFileAssociations", "shell\printto")

  return mret( $chi, $n)
endfunc
; }}}

func mod_edit( $chi) ;                                                 ;{{{
#cs
  Edit in context menu of Windows Explorer.
  Remove: Registry keys will exported to regs\ and deleted from registry.
  Add: Registry keys from regs\ are imported to registry.
#ce
  if $chi = "title" then return "Edit in context menu"
  wlog( $chi & " edit")

  local $n= 0

  $n += mreg( $chi, "edit_app", "HKCR\Applications", "shell\edit")
  $n += mreg( $chi, "edit_nul", "HKCR", "shell\edit")
  $n += mreg( $chi, "edit_sys", "HKCR\SystemFileAssociations", "shell\edit")

  return mret( $chi, $n)
endfunc
; }}}

func mod_wmp( $chi) ;                                                  ;{{{
#cs
  WMP (Windows Media Player) options in context menu of Windows Explorer.
  Options are Add_to_play_list, Add_to_burn_list and similar.
  Play in context menu remains untouched.
  Remove: Registry keys will exported to regs\ and deleted from registry.
  Add: Registry keys from regs\ are imported to registry.
  See also
    http://www.msfn.org/board/topic/38500-ever-growing-context-menu/
#ce
  if $chi = "title" then return "WMP options in context menu"
  wlog( $chi & " wmp")

  local $n= 0

  $n += mreg( $chi, "wmpa_nul", "HKCR", _
    "shellex\ContextMenuHandlers\WMPAddToPlaylist")
  $n += mreg( $chi, "wmpa_sys", "HKCR\SystemFileAssociations", _
    "shellex\ContextMenuHandlers\WMPAddToPlaylist")

  $n += mreg( $chi, "wmpb_nul", "HKCR", _
    "shellex\ContextMenuHandlers\WMPBurnAudioCD")
  $n += mreg( $chi, "wmpb_sys", "HKCR\SystemFileAssociations", _
    "shellex\ContextMenuHandlers\WMPBurnAudioCD")

  $n += mreg( $chi, "wmpp_nul", "HKCR", _
    "shellex\ContextMenuHandlers\WMPPlayAsPlaylist")

  return mret( $chi, $n)
endfunc
; }}}

func mod_share( $chi) ;                                                ;{{{
#cs
  Sharing_and_Security in context menu of Windows Explorer.
  The same item in Properties tab remains untouched.
  Remove: Two keys will be deleted from registry.
  Add: Two keys will be written to registry.
  No restart required.
  See also:
    http://www.msfn.org/board/topic/
      47286-looking-for-right-click-context-menu-reg-files/
    http://www.microsoft.com/windowsxp/using/networking/maintain/share.mspx
#ce
  if $chi = "title" then return "Sharing in context menu"
  wlog( $chi & " share")

  local $k1, $k2, $v1, $v2, $val, $r

  $k1= "HKCR\Directory\shellex\ContextMenuHandlers"
  $k2= "HKCR\Drive\shellex\ContextMenuHandlers"

  if not reg_keyp( $k1) then abort( "Registry key missed" & @LF & $k1)
  if not reg_keyp( $k2) then abort( "Registry key missed" & @LF & $k2)

  $k1 &= "\Sharing"
  $k2 &= "\Sharing"
  $val= "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

  $v1= reg_val( $k1, "")
  $v2= reg_val( $k2, "")
  if reg_val( $k1, "") == $val and reg_val( $k2, "") == $val then
    $r= "added"
  elseif not reg_keyp( $k1) and not reg_keyp( $k2) then
    $r= "removed"
  else
    $r= "unknown"
  endif

  if $chi = "remove" then
    RegDelete( $k1)
    RegDelete( $k2)

  elseif $chi = "add" then
    RegWrite( $k1, "", "REG_SZ", $data)
    RegWrite( $k2, "", "REG_SZ", $data)
  endif

  return mret( $chi, $r)
endfunc
; }}}

func mod_runas( $chi) ;                                                ;{{{
#cs
  Run_as in context menu of Windows Explorer.
  Remove: Two keys will be written to registry.
  Add: Two keys will be deleted from registry.
  Restart of Windows Explorer required.
  See also:
    http://www.pctools.com/guides/registry/detail/1308/
    http://support.microsoft.com/kb/830568
#ce
  if $chi = "title" then return "Run_as in context menu"
  wlog( $chi & " runas")

  local $k1, $k2, $var, $r

  $k1= "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer"
  $k2= "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer"

  if not reg_keyp( $k1) then abort( "Registry key missed" & @LF & $k1)
  if not reg_keyp( $k2) then abort( "Registry key missed" & @LF & $k2)

  $var= "HideRunAsVerb"

  if reg_val( $k1, $var) = 1 and reg_val( $k2, $var) = 1 then
    $r= "removed"
  elseif not reg_varp( $k1, $var) and not reg_varp( $k2, $var) then
    $r= "added"
  else
    $r= "unknown"
  endif

  if $chi = "remove" then
    RegWrite( $k1, $var, "REG_DWORD", 1)
    RegWrite( $k2, $var, "REG_DWORD", 1)
  elseif $chi = "add" then
    RegDelete( $k1, $var)
    RegDelete( $k2, $var)
  endif

  return mret( $chi, $r)
endfunc
; }}}

func mod_shortto( $chi) ;                                              ;{{{
#cs
  Shortcut_to text added to new shortcuts in Windows Explorer.
  Remove: A key will be written to registry.
  Add: A key will deleted from registry.
  Restart of Windows Explorer required.
  See also:
    http://support.microsoft.com/kb/253212
#ce
  if $chi = "title" then return "Shortcut_to text"
  wlog( $chi & " shortto")

  local $key, $var

  $key= "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"

  if not reg_keyp( $key) then abort( "Registry key missed" & @LF & $key)

  $var= "link"

  if not reg_varp( $key, $var) then 
    $r= "added"
  elseif reg_val( $key, $var) == "0x00000000" then 
    $r= "removed"
  else
    $r= "unknown (" & reg_val( $key, $var) & ")"
  endif

  if $chi = "remove" then
    RegWrite( $key, $var, "REG_BINARY", "0x00000000")
  elseif $chi = "add" then
    RegDelete( $key, $var)
  endif

  return mret( $chi, $r)
endfunc
; }}}

; -------------------------------------------------------------------------
; functions used with the mod_* functions
 
func mreg( $chi, $nam, $c1, $c2) ;                                     ;{{{

  local $a, $c, $i, $k, $n, $s, $dir, $r

  status( "Read " & $nam)
  ; prepare a[1:n] = all keys matching c1\*\c2
  $s= ""
  $i= 0
  while 1
    $i += 1
    $c = reg_subkey( $c1, $i)
    if not $c then exitloop
    if reg_keyp( $c1 & "\" & $c & "\" & $c2) then $s &= $c & @LF
  wend
  $a= str2arr( $s)
  $n= imax( $a)

  wlog( "  " & $nam & ", items in registry: " & $n )
  
  $dir= @ScriptDir & "\regs\"
  if not dirp( $dir) then DirCreate( $dir)
    
  if $chi = "status" then
    for $i= 1 to $n
      $key= $c1 & "\" & $a[$i] & "\" & $c2
      $fil= $dir & $nam & "_" & $a[$i] & ".reg"
      $s1= read_file( $fil)
      $s2= reg_export( $key)
      if $s1 == $s2 then
        $t= "noch"
      else
        $t= "chan"
      endif
      wlog( "    " & $t & " " & $a[$i])
    next

  elseif $chi = "remove" then
    status( "Save/Remove " & $nam)
    for $i= 1 to $n
      $key= $c1 & "\" & $a[$i] & "\" & $c2
      $fil= $dir & $nam & "_" & $a[$i] & ".reg"
      $s1= read_file( $fil)
      $s2= reg_export( $key)
      if $s1 == $s2 then
        $t= "noch"
      else
        if $s1 then backup_file( $fil, ".bck")
        write_file( $fil, $s2)
        $t= "save"
      endif
      RegDelete( $key)
      wlog( "    " & $t & "/delete " & $a[$i])
    next

  elseif $chi = "add" then
    status( "Add " & $nam)
    $a= files_by_dir( $dir & $nam & "_*.reg")
    $n= imax($a)
    wlog( "    number of reg files: " & $n)
    for $i= 1 to $n
      reg_import( $dir & $a[$i])
      wlog( "    import " & $a[$i])
    next
  endif

  return $n
endfunc
; }}}

func mret( $chi, $r) ;                                                 ;{{{

  if $chi == "status" then  
    if IsInt( $r) then
      if $r > 0 then
        $r= "added (" & $r & ")"
      else
        $r= "removed"
      endif
    endif    
    wlog( "  " & $r)
  else
    $r= ""
  endif
  
  wlog( "---")
  return $r
endfunc
; }}}

func m_title( $m) ;                                                    ;{{{
  return Call( "mod_" & $m, "title")
endfunc
; }}}

func m_status( $m) ;                                                    ;{{{
  return Call( "mod_" & $m, "status")
endfunc
; }}}

; -------------------------------------------------------------------------

func wlog( $t) ;  needs global wlogf                                   ;{{{

  local $db, $be

  if not $wlogf then
    $db= split_filespec( @ScriptFullPath, "db")
    $wlogf= $db & "_log.txt"
    if filep( $wlogf) then backup_file( $wlogf, ".txt")
    $be= split_filespec( @ScriptFullPath, "be")
    write_file( $wlogf, "Logfile created by " & $be & @LF & @LF)
  endif

  write_file( $wlogf, $t, "append")
endfunc
; }}}

func get_info() ;                                                      ;{{{

  local $a, $h, $c, $i, $s, $r, $ins, $fil

  $fil= split_filespec( @ScriptFullPath, "db") & ".au3"

  $s= read_file( $fil)
  $a= str2arr( $s)

  $h= split_filespec( $fil, "b")
  $ins= 0
  $s= ""
  for $i= 1 to imax($a)
    $r= $a[$i]
    $c= substr($r,1,3)
    if $c = "#cs" then
      $ins= 1
      if $h then $s &= @LF & $h & @LF
    elseif $c = "#ce" then
      $ins= 0
    elseif $ins and $h then
      $s &= $r & @LF
    elseif substr( $r, 1, 5) = "func " then
      $h= substr( $r, 6)
      $h= StringRegExpReplace( $h, "\(.*$", "")
      if substr( $h, 1, 4) <> "mod_" then $h= ""
      $h= substr( $h, 5)
    endif
  next

  $fil= split_filespec( $fil, "db") & "_info.txt"
  write_file( $fil, $s)

  return $fil
endfunc
; }}}

; -------------------------------------------------------------------------
