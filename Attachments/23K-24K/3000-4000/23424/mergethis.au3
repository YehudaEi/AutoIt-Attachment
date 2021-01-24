; -----------------------------------------------------------------------------
; Name:   mergethis.au3
; Desc:   Word mailmerge for dummies...
; Date:   09/12/2008 Andy
; -----------------------------------------------------------------------------
#NoTrayIcon
#include <Word.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>

Opt("MustDeclareVars", 1)
Opt("ExpandEnvStrings", 1)
Opt("GUIOnEventMode", 1)

global $title = "MergeThis"
global $vers = "1.0"
global $debug = "N"
global $logfile = @DesktopDir & "\au3.log"
global $hwnd, $frm, $grp1, $vers_trm
global $trm1, $trm2, $trm3
global $template_file, $data_file
global $browse_template_btn, $browse_data_btn, $merge_btn, $cancel_btn

_LogThis($title & " - Started...")
_Main()
_MyExit()

;------------------------------------------------------------------------------

func _Main()
  $frm = GUICreate($title, 500, 200, -1, -1, $WS_EX_TOOLWINDOW)
  GUISetOnEvent($GUI_EVENT_CLOSE, "_MyExit")
  $grp1 = GUICtrlCreateGroup("", 2, 0, 490, 172)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  $trm1 = GUICtrlCreateLabel("MergeThis - Mail Merge Helper", 12, 20, 300, 17)
  GUICtrlSetFont(-1, 11, 800, 0, "Verdana")
  $vers_trm = GUICtrlCreateLabel("Ver: " & $vers, 450, 14, 40, 12)
  GUICtrlSetFont(-1, 6, 400, 0, "Verdana")
  $trm2 = GUICtrlCreateLabel("Enter template filename:", 12, 62, 120, 17)
  $template_file = GUICtrlCreateInput("", 130, 60, 290, 19)
  GUICtrlSetBkColor(-1, 0xFFFBF0)
  $browse_template_btn = GUICtrlCreateButton("Browse", 430, 58, 46, 19, $BS_FLAT)
  GUICtrlSetOnEvent(-1, "_BrowseTemplate")
  GUICtrlSetFont(-1, 8, 300, 0, "Arial")
  $trm3 = GUICtrlCreateLabel("Enter data filename :", 12, 102, 120, 17)
  $data_file = GUICtrlCreateInput("", 130, 100, 290, 19)
  GUICtrlSetBkColor(-1, 0xFFFBF0)
  $browse_data_btn = GUICtrlCreateButton("Browse", 430, 99, 46, 19, $BS_FLAT)
  GUICtrlSetOnEvent(-1, "_BrowseData")
  GUICtrlSetFont(-1, 8, 300, 0, "Arial")
  $merge_btn = GUICtrlCreateButton("Run Merge", 300, 135, 80, 28, $BS_FLAT)
  GUICtrlSetOnEvent(-1, "_Merge")
  $cancel_btn = GUICtrlCreateButton("Cancel", 396, 135, 80, 28, $BS_FLAT)
  GUICtrlSetOnEvent(-1, "_MyExit")

  $hwnd = WinGetHandle($title)

  GUISetState(@SW_SHOW)

  while 1
    Sleep(100)
  wend

endfunc  ;==> _Main

;------------------------------------------------------------------------------

func _BrowseTemplate()
  local $var
  $var = FileOpenDialog("Locate file...", "c:\", "All Files (*.*)", 1 )

  if @error <> 1 then
    $var = StringReplace($var, "|", @CRLF)
    GUICtrlSetData($template_file, $var)
  endif
endfunc

;------------------------------------------------------------------------------

func _BrowseData()
  local $var
  $var = FileOpenDialog("Locate file...", "c:\", "All Files (*.*)", 1 )

  if @error <> 1 then
    $var = StringReplace($var, "|", @CRLF)
    GUICtrlSetData($data_file, $var)
  endif
endfunc

;------------------------------------------------------------------------------

func _Merge()
  local $template = ""
  local $data = ""
  local $wd
  local $dc
  local $mm
  local $ver

  $template = GUICtrlRead($template_file)
  $data     = GUICtrlRead($data_file)

  if ($template = "") then
    _LogThis("No template file provided...")
    MsgBox(0, "Error", "Please select a template file before continuing.")
    return
  endif

  if ($data = "") then
    _LogThis("No data file provided...")
    MsgBox(0, "Error", "Please select a data file before continuing.")
    return
  endif
  _LogThis(" - template file: " & $template)
  _LogThis(" - data file: " & $data)

  if not FileExists($template) then
    _LogThis("Invalid template file provided...")
    MsgBox(64, "Error", "File does not exist..." & $template)
    SetError(1)
		return
  endif

  if not FileExists($data) then
    _LogThis("Invalid data file provided...")
    MsgBox(64, "Error", "File does not exist..." & $data)
    SetError(1)
		return
  endif

  _LogThis(" - opening template file: " & $template)

  $wd = _WordCreate($template,0,0)  ; Start invisible.
  if @error then
    _LogThis(" - unable to open ms word...")
    MsgBox(0,"Error","Unable to start word...")
    SetError(1)
    _MyExit()
  endif

  $ver = $wd.version
  _LogThis(" - word version: " & $ver)

  ; $dc = _WordDocOpen ($wd, $template)
  $dc = _WordDocGetCollection ($wd, 0)
  $wd.DisplayAlerts = 0
  $wd.ActiveWindow.ActivePane.View.Zoom.Percentage = 100
  _WordPropertySet ($wd, "visible", True)
  $wd.DisplayAlerts = -1

  ; Mailmerge bits.
  _LogThis(" - processing merge...")
  $mm = $dc.MailMerge
  $mm.OpenDataSource ('"' & $data & '"', 0, true, true, true, false, "", "", false)
  $mm.Destination = 0 ; New document.
  $mm.execute

  _WordDocClose($dc,0)
  Sleep(100)
  _MyExit()
endfunc   ;==> _Merge

;------------------------------------------------------------------------------

func _LogThis($txt)
  local $sDateNow
  local $sTimeNow
  local $fh

  ; If Logging then...
  if $debug == "Y" then
    if $txt = "" then
      return
    endif

    $sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
    $sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
    $txt = $sDateNow & " " & $sTimeNow & " : " & $txt

    $fh = FileOpen($logfile, 1)

    if $fh = -1 then
      SetError(1)
      return 0
    endif

    FileWriteLine($fh, $txt)
    FileClose($fh)
  endif
  return
endfunc   ;==> _LogThis

;------------------------------------------------------------------------------

func _CleanupHiddenApps()
  local $i
  local $pid
  local $rs
  local $wd
  local $arr
  local $rcount

  ; Get a list of all windows running.
  $arr = WinList()

  $rcount = 0
  for $i = 1 to $arr[0][0]
    $title = $arr[$i][0]
    $pid = $arr[$i][1]

    ; Process hidden MS Word windows.
    if StringInStr($title, " - Microsoft Word") then
      if _IsHidden($title) = true then
        $wd = _WordAttach ($title, "Title")
        if Not @error then
          $rcount += 1
          if $rcount = 1 then
            MsgBox(64, "Hidden Window?", _
                       "One or more hidden windows have been detected. " & @LF & _
                       "This program will attempt to restore these windows. " & @LF & _
                       "Hidden windows may occured when a previous command has failed to complete successfully.")
          endif
          _WordErrorNotify (0) ; Turn on notifications
          _WordPropertySet($wd, "visible", True)
          _WordPropertySet($wd, "ScreenUpdating", True)
          $wd.Activate
          WinActive($title)
        else
          $pid = WinGetProcess($title)
          ProcessClose($pid)
        endif
      endif
    endif

    ; Process hidden MS Excel windows.
    if StringInStr($title, "Microsoft Excel") then
      if _IsHidden($title) = true then
        $pid = WinGetProcess($title)
        ProcessClose($pid)
      endif
    endif
  next
  return
endfunc   ;==> _CleanupHiddenApps

;------------------------------------------------------------------------------

func _IsHidden($title)
  local $state = WinGetState($title)

  ; MsgBox(0,"State", "Title - " & $title & " Status = " & $state)
  if $state = 5 then ; Hidden
    return true
  else
    return false
  endif
endfunc   ;==> _IsHidden

;------------------------------------------------------------------------------

func _MyExit()
  ; Bye
  _CleanupHiddenApps()
  _LogThis($title & " - Finished...")
  exit
endfunc   ;==> _MyExit

;------------------------------------------------------------------------------
