; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <Misc.au3>

;Opt("TrayIconDebug", 1)

;0 = relative coords to the active window
;1 = absolute screen coordinates (default)
;2 = relative coords to the client area of the active window
Opt("PixelCoordMode", 0)
Opt("MouseCoordMode", 0)

Opt("WinTitleMatchMode", 3)    ; Exact window title match
Opt("MustDeclareVars", 1)

;; Constants
const $quick_slot_1024x768_y = 745
const $empty_slot_color = 0x292C29
const $num_skills = 5
const $num_buffs = 3
const $quick_slot_keys = "1|2|3|4|5|6|7|8|9|0|x|none"
const $mbox_color = 0xFFC6C6
const $version = "1.0 beta1 (July 06, 2006)"
const $bot_name = "KalOnline Bot"
const $ini_file = $bot_name & ".ini"
const $pickit_delay = 750
const $pickit_key = "{SPACE}"
const $pickit_max_times = 6
const $num_check_points = 3
const $autoattack_skill_color = 0x523118
const $default_skill_delay = 500
const $no_prev_skill_index = 999
dim $mbox_coord[2]
$mbox_coord[0] = 436
$mbox_coord[1] = 45
dim $check_point[$num_check_points][3]
$check_point[0][0] = 910
$check_point[0][1] = 55
$check_point[0][2] = 0x292929
$check_point[1][0] = 210
$check_point[1][1] = 45
$check_point[1][2] = 0xB5B597
$check_point[2][0] = 960
$check_point[2][1] = 764
$check_point[2][2] = 0x181818

dim $quick_slot_1024x768_x[11]
$quick_slot_1024x768_x[1] = 421
$quick_slot_1024x768_x[2] = 457
$quick_slot_1024x768_x[3] = 493
$quick_slot_1024x768_x[4] = 529
$quick_slot_1024x768_x[5] = 565
$quick_slot_1024x768_x[6] = 601
$quick_slot_1024x768_x[7] = 637
$quick_slot_1024x768_x[8] = 673
$quick_slot_1024x768_x[9] = 709
$quick_slot_1024x768_x[0] = 745
$quick_slot_1024x768_x[10] = 361    ; mouse-scroller button

const $change_history = "v1.0" & @CRLF _
& "- Removed auto-potting since it's now supported by the game" & @CRLF _

const $known_bugs = @CRLF _
& "Bugs & problems:" & @CRLF _
& @CRLF _
& "- When clicking on npcs in town, tries to attack them if autoattack is on" & @CRLF _
& @CRLF
Sleep(3000)

;; Used to hold settings from the .ini file
dim $pot_delay            ; Delay before drinking another pot, in ms
dim $check_delay        ; Delay between life/mana level checks, in ms
dim $show_status        ; show bot status in a little tooltip (1 - yes, 0 - no)
dim $use_timed_skills        ; should the bot automatically cast buffs?
dim $t_skill_key[$num_buffs]    ; keys to press to cast buffs
dim $t_skill_delay[$num_buffs]    ; how often to recast 1st buff (in seconds)
dim $aa_skill_key[$num_skills]    ; skills used to auto-attack targetted monsters
dim $aa_skill_delay[$num_skills]  ; cast+cooldown time for the auto-attack skills
dim $auto_pickup        ; should items on the ground be automatically picked up?

;; Used to keep track of the current state of things
dim $client_status, $show_tooltip = $show_status, $debug = 0, $gui_up = 0, _
    $use_autohunt, $autohunt_active, $on_off[2], $got_skillz, $aa_cur_skill_index, _
    $pickit_timer, $pickit_count = 0, _
    $ignore_skill_until_next_target[$num_skills], $ts_timer[$num_buffs]

$on_off[0] = "off"
$on_off[1] = "on"

ReadIni()
ShowGUI()
SetHotkeys()
MainLoop()

Func SetHotkeys()
  HotKeySet("{F5}", "ToggleAutoHunt")
  HotKeySet("{F6}", "Rebuff")
  HotKeySet("{F7}", "TogglePickit")
  HotKeySet("+{F8}", "ToggleDebug")
  HotKeySet("{F10}", "ExitBot")
  HotKeySet("{F8}", "ShowGUI")
  HotKeySet("^v", "PasteClip")
endFunc

Func TogglePickit()
  $auto_pickup = 1 - $auto_pickup
endFunc

Func MainLoop()
  Local $client_resolution[2], $aa_timer, $attacked_at_least_once, $aa_cur_skill_key, _
    $wait_for_game_screen, $aa_key_color, $aa_prev_key_color, $quickslot_index, _
    $aa_cur_skill_delay

  $use_autohunt = 0
  $autohunt_active = 0
  $attacked_at_least_once = 0
  $aa_cur_skill_index = $no_prev_skill_index
  $aa_cur_skill_key = "none"
  For $i = 0 To $num_buffs - 1
    $ts_timer[$i] = 0
  Next

  While (1)
    Sleep($check_delay)

    If ($show_status) Then
      $show_tooltip = 1
    else
      If ($show_tooltip) Then
        Tooltip("", 0, 0)        ; Remove tooltip from screen
        $show_tooltip = 0
      endIf
    endIf

    ;; Make sure the client is up and running
    $client_status = WinWaitActive("KalOnline", "", 1)
    If ($client_status <> 1) Then
      If (1 = $show_tooltip) Then
        Tooltip("KalOnline not in focus..", 0, 0)
      endIf
      continueLoop
    endIf

    $client_resolution = WinGetClientSize("KalOnline")
    If (1 = @error) Then
      continueLoop
    endIf

    ; Ignore the little popup window that comes up after you click the 'Start' button
    ; in the launcher.
    If (400 = $client_resolution[0] AND 148 = $client_resolution[1]) Then
      continueLoop
    endIf

    ; Check KalOnline resolution
    If ($client_resolution[0] <> 1024 OR $client_resolution[1] <> 768) Then
      MsgBox(0, "Error: Unsupported resolution: " _
        & $client_resolution[0] & "x" & $client_resolution[1], _
        "Sorry, this bot only works with clients running at 1024x768 resolution.")
      ExitBot()
    endIf

    $wait_for_game_screen = 0
    For $i = 0 To $num_check_points - 1
      If (PixelGetColor($check_point[$i][0], $check_point[$i][1]) <> $check_point[$i][2]) Then
    $wait_for_game_screen = 1
    exitLoop
      endIf
    Next

    If (1 = $wait_for_game_screen) Then
      Tooltip("Esperando Pantalla de Juego..", 0, 0)
      continueLoop
    endIf

    ;; Check/recast buffs.
    If (1 = $use_timed_skills) Then
      For $i = 0 To $num_buffs - 1
        If ($t_skill_key[$i] <> "none") Then
          If (Int(TimerDiff($ts_timer[$i] * 1000) / 1000) > $t_skill_delay[$i] + 2) Then
        Send($t_skill_key[$i])
        $ts_timer[$i] = Int(TimerInit() / 1000)    ; Reset timer
      endIf
        endIf
      Next
    endIf

    ;; Check if a monster has been targetted.
    If (0 = $autohunt_active AND 1 = $use_autohunt) Then
      If ($mbox_color = PixelGetColor($mbox_coord[0], $mbox_coord[1])) Then
        $autohunt_active = 1
        $aa_cur_skill_index = $no_prev_skill_index
      endIf
    endIf

    ;; Auto-attack targetted monster.
    If (1 == $autohunt_active AND 1 = $got_skillz) Then

      ;; This loop will only execute once. Only put it in so I can use exitLoop
      For $i = 0 To 1

    ;; Check if autohunt has been turned off or monster is dead/no longer targetted.
    If (1 <> $use_autohunt OR $mbox_color <> PixelGetColor($mbox_coord[0], $mbox_coord[1])) Then
      $autohunt_active = 0

      $aa_cur_skill_index = $no_prev_skill_index
          For $i = 0 To $num_skills - 1
        $ignore_skill_until_next_target[$i] = 0
          Next

      ;; If we attacked a monster at least once, try to pick up loot.
      If (1 = $attacked_at_least_once) Then
        $pickit_count = $pickit_max_times
        $attacked_at_least_once = 0
      endIf
      exitLoop
    endIf

        ;; Make sure previous skill was actually used.
    If ($aa_cur_skill_index <> $no_prev_skill_index) Then
      $quickslot_index = GetQuickslotIndex($aa_cur_skill_index)
      $aa_key_color = PixelGetColor($quick_slot_1024x768_x[$quickslot_index], _
                    $quick_slot_1024x768_y)

      ;; If previous skill hasn't gone off yet...
      If ($aa_key_color = $aa_prev_key_color AND $aa_key_color <> $autoattack_skill_color) Then
        ;; Resend it
        Send($aa_skill_key[$aa_cur_skill_index])
        exitLoop
      endIf

          If (0 = $aa_skill_delay[$aa_cur_skill_index]) Then
        $aa_cur_skill_delay = $default_skill_delay
            $ignore_skill_until_next_target[$aa_cur_skill_index] = 1
      else
        $aa_cur_skill_delay = $aa_skill_delay[$aa_cur_skill_index]
      endIf

          ;; Check if there is already a skill in use.
          If (TimerDiff($aa_timer) < $aa_cur_skill_delay) Then
            exitLoop
          endIf
    endIf

    ;; Use next skill.
        AdvanceActiveSkillIndex()
    $quickslot_index = GetQuickslotIndex($aa_cur_skill_index)
    $aa_prev_key_color = PixelGetColor($quick_slot_1024x768_x[$quickslot_index], $quick_slot_1024x768_y)
    $aa_cur_skill_key = $aa_skill_key[$aa_cur_skill_index]
        Send($aa_cur_skill_key)
    $aa_timer = TimerInit()

    ;; Monster has been attacked at least once.
    $attacked_at_least_once = 1

      Next
    endIf

    ;; This shows in the lower left corner of the screen
    If ($show_tooltip AND $debug = 0) Then
      Local $tooltip_text = "Autohunt: " & IsOnStr($use_autohunt) & _
        _Iif(1 = $autohunt_active, " (active - " & $aa_cur_skill_key & ")", " (no target)") & @CRLF _
    & "Autopick: " & IsOnStr($auto_pickup) & " (" & $pickit_count & ")" & @CRLF _
    & "Rebuff in: " & RebuffIn(0) & ", " & RebuffIn(1) & ", " & RebuffIn(2) & @CRLF _
    & "F8 - Setup"
      Tooltip($tooltip_text, 2, 713)
    endIf

    ;; Auto-pickup loot
    If ($auto_pickup AND $pickit_count > 0 AND TimerDiff($pickit_timer) >= $pickit_delay) Then
      Send($pickit_key)
      If (2 = $pickit_count) Then
    Send("{UP}")
      endIf
      $pickit_timer = TimerInit()
      $pickit_count = $pickit_count - 1
    endIf

  WEnd
endFunc

Func IsOnStr($v)
  return $on_off[$v]
endFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func RebuffIn($index)
  Local $res

  If (0 = $use_timed_skills OR "none" = $t_skill_key[$index]) Then
    $res = -1
  else
    $res = $t_skill_delay[$index] - Int(TimerDiff($ts_timer[$index] * 1000) / 1000)
  endIf
  return $res
endFunc

Func ExitBot()
  Exit
endFunc

Func ReadIni()
  Local $confirm, $i

  If (1 = FileExists($ini_file)) Then
    $check_delay = IniRead($ini_file, "Settings", "CheckDelay", 250)
    $show_status = IniRead($ini_file, "Settings", "ShowStatus", 1)
    $use_timed_skills = IniRead($ini_file, "Settings", "UseTimedSkills", 0)
    For $i = 0 To $num_buffs - 1
      $t_skill_key[$i] = IniRead($ini_file, "Settings", "TimedSkill" & $i+1 & "Key", "none")
      $t_skill_delay[$i] = IniRead($ini_file, "Settings", "TimedSkill" & $i+1 & "Delay", 250)
    Next
    For $i = 0 To $num_skills - 1
      $aa_skill_key[$i] = IniRead($ini_file, "Settings", "AutoAttackSkill" & $i+1, "none")
      $aa_skill_delay[$i] = IniRead($ini_file, "Settings", "Skill" & $i+1 & "Delay", 500)
    Next
    $auto_pickup = IniRead($ini_file, "Settings", "AutoPickupItems", 0)
  else
    $confirm = MsgBox(4, $bot_name & ': error', @CRLF _
    & 'Could not load settings from the ' & @CRLF _
    & '"' & $ini_file & '" file. File does not exist!' & @CRLF _
    & @CRLF _
    & 'Press "Yes" to generate a new ' & @CRLF _
    & '"' & $ini_file & '" file with default' & @CRLF _
    & 'values, or "No" to abort.')

    If ($confirm = 7) Then
      ExitBot()
    endIf

    WriteIni()
  endIf

  ;; Check if there is at least 1 hunting skill configured
  $got_skillz = 0
  For $i = 0 To $num_skills - 1
    If ("none" <> $aa_skill_key[$i]) Then
      $got_skillz = 1
      exitLoop
    endIf
  Next

endFunc

Func WriteIni()
  Local $i

  IniWrite($ini_file, "Settings", "CheckDelay", $check_delay)
  IniWrite($ini_file, "Settings", "UseTimedSkills", $use_timed_skills)
  For $i = 0 To $num_buffs - 1
    IniWrite($ini_file, "Settings", "TimedSkill" & $i+1 & "Key", $t_skill_key[$i])
    IniWrite($ini_file, "Settings", "TimedSkill" & $i+1 & "Delay", $t_skill_delay[$i])
  Next
  For $i = 0 To $num_skills - 1
    IniWrite($ini_file, "Settings", "AutoAttackSkill" & $i+1, $aa_skill_key[$i])
    IniWrite($ini_file, "Settings", "Skill" & $i+1 & "Delay", $aa_skill_delay[$i])
  Next
  IniWrite($ini_file, "Settings", "ShowStatus", $show_status)
  IniWrite($ini_file, "Settings", "AutoPickupItems", $auto_pickup)
endFunc

Func ToggleTooltip()
  If ($gui_up) Then
    Return
  endIf
  $show_status = 1 - $show_status
endFunc

Func ToggleDebug()
  $debug = 1 - $debug
endFunc

Func PasteClip()
  Send(ClipGet())
endFunc

Func ShowGUI()

  ;; Make sure user can't bring up multiple dialog boxes
  If ($gui_up) Then
    return
  endIf

  $gui_up = 1

  Local $msg, $text, $row_y, $state
  Local $tmp_use_timed_skills = $use_timed_skills
  Local $tmp_ts_key[$num_buffs], $tmp_ts_delay[$num_buffs]
  Local $tmp_aa_key[$num_skills], $tmp_aa_delay[$num_skills], $i
  Local $tmp_show_status = $show_status
  Local $tmp_auto_pickup =  $auto_pickup
  Local $tmp_check_delay = $check_delay
  For $i = 0 To $num_buffs -1
    $tmp_ts_key[$i] = $t_skill_key[$i]
    $tmp_ts_delay[$i] = $t_skill_delay[$i]
  Next
  For $i = 0 To $num_skills - 1
    $tmp_aa_key[$i] = $aa_skill_key[$i]
    $tmp_aa_delay[$i] = $aa_skill_delay[$i]
  Next

  Local $gui_handle = GUICreate($bot_name & " Setup (bot is paused)", 350, 375)
  Local $sro_folder = ("C:\Archivos de Programa\KalOnlineEng\KalOnline.exe")
  GUISetIcon($sro_folder & "\Silkroad.ico", 0, $gui_handle)

  Local $cancel_button = GUICtrlCreateButton(" Discard Changes  ", 190, 335, -1, -1, $BS_DEFPUSHBUTTON + $BS_FLAT)
  Local $save_button = GUICtrlCreateButton("  Save Settings  ", 65, 335, -1, -1, $BS_DEFPUSHBUTTON + $BS_FLAT)

  Local $tab = GUICtrlCreateTab(10, 10, 325, 310)

  ;;;;;;;;;;;;;;;
  ;; Misc. Tab ;;
  ;;;;;;;;;;;;;;;
  Local $tab_misc = GUICtrlCreateTabItem("Misc.")
  $row_y = 45
  Local $show_status_cb = GUICtrlCreateCheckBox("Show bot status tooltip", 25, $row_y)

  $row_y = $row_y + 30
  Local $auto_pickup_cb = GUICtrlCreateCheckBox("Auto-pickup loot after killing a monster", 25, $row_y)

  $row_y = $row_y + 30
  Local $check_delay_slider = GUICtrlCreateSlider(165, $row_y - 5, 100, 20, $TBS_BOTH+$TBS_NOTICKS)
  GUICtrlSetLImit($check_delay_slider, 1000, 100)
  GUICtrlSetData($check_delay_slider, $tmp_check_delay)
  GUICtrlCreateLabel("  Check screen every:                                                         ms", 25, $row_y)
  Local $check_delay_label = GUICtrlCreateLabel($tmp_check_delay, 275, $row_y)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Auto-buff and hunt-pilot Tab ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Local $tab_buff = GUICtrlCreateTabItem("Skill Setup")

  $row_y = 45
  Local $ts_cb = GUICtrlCreateCheckBox("Automatically use timed skills (buffs)", 25, $row_y)
  $row_y = $row_y + 5

  Local $ts_input[$num_buffs], $ts_updown[$num_buffs], $ts_combo[$num_buffs], $ts_label[$num_buffs]
  For $i = 0 To $num_buffs - 1
    $row_y = $row_y + 30
    $ts_combo[$i] = GUICtrlCreateCombo("", 100, $row_y - 5, 50)
    GUICtrlSetData($ts_combo[$i], $quick_slot_keys, $tmp_ts_key[$i])
    $ts_input[$i] = GUICtrlCreateInput($tmp_ts_delay[$i], 230, $row_y - 5, 45, -1, $ES_RIGHT+$ES_NUMBER)
    $ts_updown[$i] = GUICtrlCreateUpDown($ts_input[$i])
    GUICtrlSetLimit($ts_updown[$i], 999, 100)
    $ts_label[$i] = GUICtrlCreateLabel( _
    "Timed Skill " & $i+1 & ":                        Recast every                    seconds", 25, $row_y)
  Next

  $row_y = 165
  GUICtrlCreateLabel("Auto-attack combo:               Cast/cooldown time (0=use once):", 25, $row_y)

  Local $aa_combo[$num_skills], $aa_input[$num_skills], $aa_updown[$num_skills]
  For $i = 0 To $num_skills - 1
    $row_y = $row_y + 25
    $aa_combo[$i] = GUICtrlCreateCombo("", 100, $row_y - 5, 55)
    $aa_input[$i] = GUICtrlCreateInput($tmp_aa_delay[$i], 200, $row_y - 5, 50, -1, $ES_RIGHT+$ES_NUMBER)
    $aa_updown[$i] = GUICtrlCreateUpDown($aa_input[$i])
    GUICtrlSetLimit($aa_updown[$i], 5000, 0)
    GUICtrlCreateLabel("Skill " & $i + 1 & " key:" _
     & "                                                           ms", 25, $row_y)
    GUICtrlSetData($aa_combo[$i], $quick_slot_keys, $tmp_aa_key[$i])
  Next

  ;;;;;;;;;;;;;;
  ;; Help Tab ;;
  ;;;;;;;;;;;;;;
  Local $tab1 = GUICtrlCreateTabItem("Help")
  $text = @CRLF _
    & "   I. Keyboard commands" & @CRLF _
    & @CRLF _
    & "   F5" & @TAB & " Toggle auto-attack targetted monsters" & @CRLF _
    & "   F6" & @TAB & " Recast buffs (timed skills)" & @CRLF _
    & @TAB  & " Comes in handy after you port to town." & @CRLF _
    & "   F7" & @TAB & " Toggle item auto-pick up" & @CRLF _
    & "   F8" & @TAB & " Configure bot" & @CRLF _
    & "   F10" & @TAB & " Quit" & @CRLF _
    & "   Ctrl-v" & @TAB & " Paste clipboard contents" & @CRLF _
    & @CRLF _
    & "   II. Using the GUI" & @CRLF _
    & @CRLF _
    & "   All automatic operations are suspended while GUI " & @CRLF _
    & "   is active." & @CRLF _
    & @CRLF _
    & "   III. Auto-pickup loot checkbox" & @CRLF _
    & @CRLF _
    & "   When on, will try to pick up to " & $pickit_max_times & " items after you" & @CRLF _
    & "   kill a monster using auto-attack. Only works on" & @CRLF _
    & "   items within immediate reach." & @CRLF _
    & @CRLF _
    & "  -- End of help"
  GUICtrlCreateEdit($text, 20, 45, 300, 260, $ES_READONLY + $WS_VSCROLL)

  Local $tab2 = GUICtrlCreateTabItem("About")
  $text = @CRLF _
    & "  *****************************************************************" & @CRLF _
    & @CRLF _
    & "  Kal Online Bot" & @CRLF _
    & @CRLF _
    & "  Brought to you by: HouseOfHam" & @CRLF _
    & @CRLF _
    & "  Version: " & $version & @CRLF _
    & @CRLF _
    & "  This bot only works at 1024x768 resolution!!!" & @CRLF _
    & @CRLF _
    & "  *****************************************************************" & @CRLF _
    & $change_history & @CRLF _
    & $known_bugs & @CRLF _
    & ""
  GUICtrlCreateEdit($text, 20, 45, 300, 260, $ES_READONLY + $WS_VSCROLL)

  ;; Initialize controls' status
  $state = _Iif(1 = $tmp_show_status, $GUI_CHECKED, $GUI_UNCHECKED)
  GUICtrlSetState($show_status_cb, $state)
  $state = _Iif(1 = $tmp_auto_pickup, $GUI_CHECKED, $GUI_UNCHECKED)
  GUICtrlSetState($auto_pickup_cb, $state)

  If (1 = $tmp_use_timed_skills) Then
    GUICtrlSetState($ts_cb, $GUI_CHECKED)
  else
    For $i = 0 To $num_buffs - 1
      GUICtrlSetState($ts_label[$i], $GUI_DISABLE)
      GUICtrlSetState($ts_combo[$i], $GUI_DISABLE)
      GUICtrlSetState($ts_input[$i], $GUI_DISABLE)
      GUICtrlSetState($ts_updown[$i], $GUI_DISABLE)
    Next
  endIf

  GUISetState (@SW_SHOW)

  ; Run the GUI until the dialog is closed
  While (1)
    $msg = GUIGetMsg()

    Select

      case $msg = $save_button
    $check_delay = GUICtrlRead($check_delay_slider)
    $use_timed_skills = $tmp_use_timed_skills
    For $i = 0 To $num_buffs - 1
      $t_skill_key[$i] = GUICtrlRead($ts_combo[$i])
      $t_skill_delay[$i] = GUICtrlRead($ts_input[$i])
    Next
    For $i = 0 To $num_skills - 1
      $aa_skill_key[$i] = GUICtrlRead($aa_combo[$i])
      $aa_skill_delay[$i] = GUICtrlRead($aa_input[$i])
        Next
    $show_status = ($GUI_CHECKED = GUICtrlRead($show_status_cb))
    $auto_pickup = ($GUI_CHECKED = GUICtrlRead($auto_pickup_cb))

    WriteIni()
        ;; Check if there is at least 1 hunting skill configured
    $got_skillz = 0
        For $i = 0 To $num_skills - 1
          If ("none" <> $aa_skill_key[$i]) Then
            $got_skillz = 1
            exitLoop
          endIf
        Next
    exitLoop

      case $msg = $cancel_button
    exitLoop

      case $msg  = $GUI_EVENT_CLOSE
    exitLoop

      case $msg = $check_delay_slider
    $tmp_check_delay = GUICtrlRead($check_delay_slider)
    GUICtrlSetData($check_delay_label, $tmp_check_delay)

      case $msg = $ts_cb
    $tmp_use_timed_skills = ($GUI_CHECKED = GUICtrlRead($ts_cb))
    $state = _Iif(1 = $tmp_use_timed_skills, $GUI_ENABLE, $GUI_DISABLE)
    For $i = 0 To $num_buffs - 1
      GUICtrlSetState($ts_label[$i], $state)
      GUICtrlSetState($ts_combo[$i], $state)
      GUICtrlSetState($ts_input[$i], $state)
      GUICtrlSetState($ts_updown[$i], $state)
    Next
    endSelect
  Wend
  GUIDelete()
  $gui_up = 0
endFunc

func Rebuff()
  ;; Cast buffs
  For $i = 0 to $num_buffs - 1
    If ($t_skill_key[$i] <> "none") Then
      Send($t_skill_key[$i])
      $ts_timer[$i] = Int(TimerInit() / 1000)
    endIf
  Next
endFunc

Func ToggleAutoHunt()
  $use_autohunt = 1 - $use_autohunt
endFunc

Func GetQuickslotIndex($aa_skill_index)
  If ("x" = $aa_skill_key[$aa_skill_index]) Then
    return 10
  else
    return $aa_skill_key[$aa_skill_index]
  endIf
endFunc

Func AdvanceActiveSkillIndex()
  If ($aa_cur_skill_index = $no_prev_skill_index) Then
    $aa_cur_skill_index = -1
  endIf

  Do
    $aa_cur_skill_index = $aa_cur_skill_index + 1
    If ($aa_cur_skill_index = $num_skills) Then
      $aa_cur_skill_index = 0
    endIf
  Until ("none" <> $aa_skill_key[$aa_cur_skill_index] _
     AND 0 = $ignore_skill_until_next_target[$aa_cur_skill_index])
endFunc

