;------------------------------------------------------------------------------
;   Name:       my_map.au3
;   Desc:       Run mappings.
;   Created:    18/06/2008  AJP
;------------------------------------------------------------------------------
#AutoIt3Wrapper_Add_Constants=y
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>

HotKeySet("{ESC}", "_MyExit")  ; Hotkey exit.
Opt("GUIOnEventMode", 1)
Opt("ExpandEnvStrings", 1)
Opt("MustDeclareVars", 1)
Opt("TrayAutoPause", 0) ; No pause.
Opt("TrayIconHide",0) ; Show icon.
; Opt("TrayMenuMode",1) ; No tray menu.

global $title = "Mapping"

global $logging = "N"
global $logfile = @DesktopDir & "\mapping.log"
global $param1, $param2, $param3, $param4, $param5
global $frm, $grp, $t_trm, $x_trm
global $fld1, $fld2, $fld3, $fld4, $fld5, $fld6, $fld7, $fld8
global $trm1, $trm2, $trm3, $trm4, $trm5, $trm6, $trm7, $trm8
global $map_this
global $map_errors = 0
global $pctalk

$pctalk = ObjCreate("SAPI.SpVoice")
if @error = 1 then $pctalk = ""

_LogThis("Mappings...")
_DrawScreen()
_Main()
_MyExit()

;------------------------------------------------------------------------------

func _DrawScreen()
  $frm = GUICreate($title, 500, 242, -1, -1, BitOR($WS_POPUP,$WS_BORDER), $WS_EX_TOOLWINDOW)
  ;GUISetBkColor(0xDDE3FF)
  GUISetBkColor(0xFFFF99)
  $grp = GUICtrlCreateGroup("DL Mappings", 8, 5, 485, 230)
  GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
  GUICtrlSetColor(-1, 0xCC0000)
  $x_trm = GUICtrlCreateLabel("ESC to Quit.", 435, 220, 55, 10)
  GUICtrlSetFont(-1, 7, 100, 0, "Sans Serif")
  $t_trm = GUICtrlCreateLabel("Processing...", 25, 25, 80, 22)
  $trm1 = GUICtrlCreateLabel("...", 25, 50, 300, 22)
  $trm2 = GUICtrlCreateLabel("...", 25, 70, 300, 22)
  $trm3 = GUICtrlCreateLabel("...", 25, 90, 250, 22)
  $trm4 = GUICtrlCreateLabel("...", 25, 110, 250, 22)
  $trm5 = GUICtrlCreateLabel("...", 25, 130, 250, 22)
  $trm6 = GUICtrlCreateLabel("...", 25, 150, 250, 22)
  $trm7 = GUICtrlCreateLabel("...", 25, 170, 250, 22)
  $trm8 = GUICtrlCreateLabel("...", 25, 190, 250, 22)
  $fld1 = GUICtrlCreateLabel("...", 350, 50, 100, 22)
  $fld2 = GUICtrlCreateLabel("...", 350, 70, 100, 22)
  $fld3 = GUICtrlCreateLabel("...", 350, 90, 100, 22)
  $fld4 = GUICtrlCreateLabel("...", 350, 110, 100, 22)
  $fld5 = GUICtrlCreateLabel("...", 350, 130, 100, 22)
  $fld6 = GUICtrlCreateLabel("...", 350, 150, 100, 22)
  $fld7 = GUICtrlCreateLabel("...", 350, 170, 100, 22)
  $fld8 = GUICtrlCreateLabel("...", 350, 190, 100, 22)

endfunc   ;==> _DrawScreen

;------------------------------------------------------------------------------

func _Main()
  local $rc
  local $i
  local $map_array[10]

  ;_GetParams()
  GUISetState(@SW_SHOW)
  TraySetToolTip ( "Mappings..." )

  ; Hard code mappings into array... Will read from a file - one day.
  $i = 0
  if @UserName = "andrew" then
    $map_array[$i] = "g:|\\192.168.1.1\public|my_user|my_passwd|Public"
    $i += 1
  endif
  $map_array[$i] = "h:|\\192.168.0.1\play|my_user|my_passwd|PlayArea"
  $i += 1
  $map_array[$i] = "j:|\\192.168.0.2\share1|my_user|my_passwd|Share 1"
  $i += 1
  $map_array[$i] = "k:|\\192.168.0.2\share2|my_user|my_passwd|Share 2"
  $i += 1
  $map_array[$i] = "l:|\\192.168.0.2\share3|my_user|my_passwd|Share 3"

  for $i = 0 to UBound($map_array)-1
    ; Pull array line apart.
    if $map_array[$i] <> "" then
      if $i = 0 then GUICtrlSetData($trm1, $map_array[$i])
      if $i = 1 then GUICtrlSetData($trm2, $map_array[$i])
      if $i = 2 then GUICtrlSetData($trm3, $map_array[$i])
      if $i = 3 then GUICtrlSetData($trm4, $map_array[$i])
      if $i = 4 then GUICtrlSetData($trm5, $map_array[$i])
      if $i = 5 then GUICtrlSetData($trm6, $map_array[$i])
      if $i = 6 then GUICtrlSetData($trm7, $map_array[$i])
      if $i = 7 then GUICtrlSetData($trm8, $map_array[$i])
    else
      if $i = 0 then
        GUICtrlSetData($trm1,"")
        GUICtrlSetData($fld1,"")
      endif
      if $i = 1 then
        GUICtrlSetData($trm2,"")
        GUICtrlSetData($fld2,"")
      endif
      if $i = 2 then
        GUICtrlSetData($trm3,"")
        GUICtrlSetData($fld3,"")
      endif
      if $i = 3 then
        GUICtrlSetData($trm4,"")
        GUICtrlSetData($fld4,"")
      endif
      if $i = 4 then
        GUICtrlSetData($trm5,"")
        GUICtrlSetData($fld5,"")
      endif
      if $i = 5 then
        GUICtrlSetData($trm6,"")
        GUICtrlSetData($fld6,"")
      endif
      if $i = 6 then
        GUICtrlSetData($trm7,"")
        GUICtrlSetData($fld7,"")
      endif
      if $i = 7 then
        GUICtrlSetData($trm8,"")
        GUICtrlSetData($fld8,"")
      endif
    endif
  next
  Sleep(500)

  ; Process mappings.
  for $i = 0 to UBound($map_array)-1
    if $map_array[$i] <> "" then
      _MapDrive($map_array[$i],$i)
    endif
  next

  GUICtrlSetData($t_trm, "Finished...")
  if $map_errors > 1 then
    _SayThis("Mapping Errors Detected.")
  else
    _SayThis("Mapping Completed.")
  endif
  Sleep(3000)
  _MyExit()
endfunc   ;==> _Main

;------------------------------------------------------------------------------

func _MapDrive($map_this,$item)
  local $drive_letter
  local $service
  local $map_user
  local $map_passwd
  local $map_label
  local $txt
  local $reg_txt

  ; Pull apart mapping data.
  $txt = StringSplit($map_this, '|')

  if $txt[0] <> 0 then
    $drive_letter = $txt[1]
    $service      = $txt[2]
    $map_user     = $txt[3]
    $map_passwd   = $txt[4]
    $map_label    = $txt[5]

    SplashTextOn("", "Mapping - " & $drive_letter & " -- " & $service, 400, 80, -1, -1, 1+2+32, "Arial", 8.5, 100)

    DriveMapDel($drive_letter)
    Sleep(100)
    DriveMapAdd($drive_letter, $service, 0, $map_user, $map_passwd)

    if @error then
      if $item = 0 then GUICtrlSetData($fld1,"Error - not mapped.")
      if $item = 1 then GUICtrlSetData($fld2,"Error - not mapped.")
      if $item = 2 then GUICtrlSetData($fld3,"Error - not mapped.")
      if $item = 3 then GUICtrlSetData($fld4,"Error - not mapped.")
      if $item = 4 then GUICtrlSetData($fld5,"Error - not mapped.")
      if $item = 5 then GUICtrlSetData($fld6,"Error - not mapped.")
      if $item = 6 then GUICtrlSetData($fld7,"Error - not mapped.")
      if $item = 7 then GUICtrlSetData($fld8,"Error - not mapped.")
      $map_errors += 1
      return
    else
      if $item = 0 then GUICtrlSetData($fld1,"Mapped.")
      if $item = 1 then GUICtrlSetData($fld2,"Mapped.")
      if $item = 2 then GUICtrlSetData($fld3,"Mapped.")
      if $item = 3 then GUICtrlSetData($fld4,"Mapped.")
      if $item = 4 then GUICtrlSetData($fld5,"Mapped.")
      if $item = 5 then GUICtrlSetData($fld6,"Mapped.")
      if $item = 6 then GUICtrlSetData($fld7,"Mapped.")
      if $item = 7 then GUICtrlSetData($fld8,"Mapped.")
    endif

    if $map_label <> "" then
      $txt = StringSplit($service, '\')
      $reg_txt = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##" & $txt[3] & "#" & $txt[4]
      RegWrite($reg_txt, "_LabelFromReg", "REG_SZ", $map_label)
    endif

    SplashOff()
 endif

endfunc

;------------------------------------------------------------------------------

func _GetParams()
  local $i
  local $x

  $param1 = ""
  $param2 = ""
  $param3 = ""
  $param4 = ""
  $param5 = ""

  for $i = 1 to $CmdLine[0]
    select
      case $i = 1
        $param1 = $CmdLine[1]
      case $i = 2
        $param2 = $CmdLine[2]
      case $i = 3
        $param3 = $CmdLine[3]
      case $i = 4
        $param4 = $CmdLine[4]
      case $i = 5
        $param5 = $CmdLine[5]
      case else
        $x = ""
    endselect
  next
  _LogThis("- Param 1: " & $param1)
  _LogThis("- Param 2: " & $param2)
  _LogThis("- Param 3: " & $param3)
  _LogThis("- Param 4: " & $param4)
  _LogThis("- Param 5: " & $param5)

endfunc   ;==> _GetParams

;------------------------------------------------------------------------------

func _LogThis($txt)
  local $sDateNow
  local $sTimeNow
  local $fh

  ; If Logging then...
  if $logging == "Y" then
    if $txt = "" then
      return
    endif

    $sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
    $sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
    $txt = $sDateNow & " " & $sTimeNow & " : " & $txt

    $fh = FileOpen($logfile, 1)

    if $fh = -1 then
      SetError(1)
      return
    endif

    FileWriteLine($fh, $txt)
    FileClose($fh)
  endif
  return
endfunc   ;==> _LogThis

;------------------------------------------------------------------------------

func _SayThis($txt)
  if $pctalk <> "" then
    $pctalk.Volume = 100
    $pctalk.Speak ($txt)
  endif
endfunc   ;==>_SayThis

;------------------------------------------------------------------------------

func _MyExit()
  ; Bye
  _LogThis("Mappings - Finished...")
  $pctalk = ""
  SplashOff()
  exit
endfunc   ;==> _MyExit

;------------------------------------------------------------------------------
