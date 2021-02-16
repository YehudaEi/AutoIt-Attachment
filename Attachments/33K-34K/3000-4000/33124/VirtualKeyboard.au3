#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=1295599487_Gnome-Input-Keyboard-64.ico
#AutoIt3Wrapper_outfile=Virtual_Keyboard.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Virtual Keyboard with Anti - KeyLogger
#AutoIt3Wrapper_Res_Fileversion=1.1.0.6
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=ProductName|Virtual Keyboard with Anti - KeyLogger
#AutoIt3Wrapper_Res_Field=InternalName|VirtualKeyboard.exe
#AutoIt3Wrapper_Res_Field=ProductVersion|1.1.0.6
#AutoIt3Wrapper_Res_Field=OriginalFilename|VirtualKeyboard.exe
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <IE.au3>

Opt("WinWaitDelay", 0)
Opt("SendKeyDelay", 0)
Opt("SendKeyDownDelay", 0)
Opt("Sendcapslockmode", 0)
Opt("TrayIconHide", 1)
Opt("GUICloseOnESC", 0)

Global $fLeftShiftHolden = False
Global $fLeftAltHolden = False
Global $fLeftCtrlHolden = False
Global $fRightShiftHolden = False
Global $fRightAltHolden = False
Global $fRightCtrlHolden = False
Global Const $VK_NUMLOCK = 0x90
Global Const $VK_SCROLL = 0x91
Global Const $VK_CAPITAL = 0x14
Global $ctrlstatus = 0, $altstatus = 0, $shiftstatus = 0
;
Global $_NOACTIVATE = 0x08000000
Global $MA_NOACTIVATE = 3
Global $MA_NOACTIVATEANDEAT = 4
Global $keyStroke_Array[68] = ['{SPACE}', '{ENTER}', '{ALT}', '{BS}', '{BACKSPACE}', '{DEL}', '{UP}', '{DOWN}', _
		'{LEFT}', '{RIGHT}', '{HOME}', '{END}', '{ESC}', '{INS}', '{PGUP}', '{PGDN}', '{F1}', '{F2}', '{F3}', _
		'{F4}', '{F5}', '{F6}', '{F7}', '{F8}', '{F9}', '{F10}', '{F11}', '{F12}', '{TAB}', '{PRINTSCREEN}', '{LWIN}', _
		'{RWIN}', '{BREAK}', '{PAUSE}', '{NUMPADMULT}', '{NUMPADADD}', '{NUMPADSUB}', '{NUMPADDIV}', '{NUMPADDOT}', _
		'{NUMPADENTER}', '{APPSKEY}', '{LALT}', '{RALT}', '{LCTRL}', '{RCTRL}', '{LSHIFT}', '{RSHIFT}', '{SLEEP}', _
		'{NUMPAD0}', '{NUMPAD1}', '{NUMPAD2}', '{NUMPAD3}', '{NUMPAD4}', '{NUMPAD5}', '{NUMPAD6}', '{NUMPAD7}', _
		'{NUMPAD8}', '{NUMPAD9}', '{ALTDOWN}', '{SHIFTDOWN}', '{CTRLDOWN}', '{ALTUP}', '{CTRLUP}', '{SHIFTUP}', '{CAPSLOCK}', _
		'{INSERT}', '{DELETE}', '{Escape}']

_ArraySort($keyStroke_Array)

HotKeySet("{Esc}", "Quit")

$ProductVersion = "v0.1"
$MainGUITitle = "Virtual Keyboard " & $ProductVersion & " - "
$Form1 = GUICreate($MainGUITitle, 722, 194, 300, 300, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $_NOACTIVATE));$WS_POPUPWINDOW;BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
$Esc = GUICtrlCreateButton("Esc", 0, 0, 33, 25, $WS_GROUP)
$F1 = GUICtrlCreateButton("F1", 48, 0, 33, 25, $WS_GROUP)
$F2 = GUICtrlCreateButton("F2", 80, 0, 33, 25, $WS_GROUP)
$F3 = GUICtrlCreateButton("F3", 112, 0, 33, 25, $WS_GROUP)
$F4 = GUICtrlCreateButton("F4", 144, 0, 33, 25, $WS_GROUP)
$F5 = GUICtrlCreateButton("F5", 184, 0, 33, 25, $WS_GROUP)
$F6 = GUICtrlCreateButton("F6", 216, 0, 33, 25, $WS_GROUP)
$F7 = GUICtrlCreateButton("F7", 248, 0, 33, 25, $WS_GROUP)
$F8 = GUICtrlCreateButton("F8", 280, 0, 33, 25, $WS_GROUP)
$F9 = GUICtrlCreateButton("F9", 320, 0, 33, 25, $WS_GROUP)
$F10 = GUICtrlCreateButton("F10", 352, 0, 33, 25, $WS_GROUP)
$F11 = GUICtrlCreateButton("F11", 385, 0, 33, 25, $WS_GROUP)
$F12 = GUICtrlCreateButton("F12", 417, 0, 33, 25, $WS_GROUP)
$PrintScreen = GUICtrlCreateButton("prtscr", 488, 0, 33, 25, $WS_GROUP)
$ScrollLock = GUICtrlCreateButton("scr lo", 520, 0, 33, 25, $WS_GROUP)
$PauseBreak = GUICtrlCreateButton("pa br", 552, 0, 33, 25, $WS_GROUP)
$Igel = GUICtrlCreateButton("`", 0, 32, 33, 33, $WS_GROUP)
$One = GUICtrlCreateButton("1", 32, 32, 33, 33, $WS_GROUP)
$Two = GUICtrlCreateButton("2", 64, 32, 33, 33, $WS_GROUP)
$Three = GUICtrlCreateButton("3", 96, 32, 33, 33, $WS_GROUP)
$Four = GUICtrlCreateButton("4", 128, 32, 33, 33, $WS_GROUP)
$Five = GUICtrlCreateButton("5", 160, 32, 33, 33, $WS_GROUP)
$Six = GUICtrlCreateButton("6", 192, 32, 33, 33, $WS_GROUP)
$Seven = GUICtrlCreateButton("7", 224, 32, 33, 33, $WS_GROUP)
$Eight = GUICtrlCreateButton("8", 256, 32, 33, 33, $WS_GROUP)
$Nine = GUICtrlCreateButton("9", 288, 32, 33, 33, $WS_GROUP)
$Zero = GUICtrlCreateButton("0", 320, 32, 33, 33, $WS_GROUP)
$Minus = GUICtrlCreateButton("-", 352, 32, 33, 33, $WS_GROUP)
$Equal = GUICtrlCreateButton("=", 384, 32, 33, 33, $WS_GROUP)
$Back = GUICtrlCreateButton("<-------", 416, 32, 65, 33, $WS_GROUP)
$Insert = GUICtrlCreateButton("Insert", 488, 32, 33, 33, $WS_GROUP)
$Home = GUICtrlCreateButton("Home", 520, 32, 33, 33, $WS_GROUP)
$PageUp = GUICtrlCreateButton("PgUp", 552, 32, 33, 33, $WS_GROUP)
$NumberLock = GUICtrlCreateButton("NmLo", 592, 32, 33, 33, $WS_GROUP)
$NumberPadSlash = GUICtrlCreateButton("/", 624, 32, 33, 33, $WS_GROUP)
$NumberPadX = GUICtrlCreateButton("*", 656, 32, 33, 33, $WS_GROUP)
$NumberPadMinus = GUICtrlCreateButton("-", 688, 32, 33, 33, $WS_GROUP)
$Tab = GUICtrlCreateButton("Tab", 0, 64, 41, 33, $WS_GROUP)
$q = GUICtrlCreateButton("Q", 40, 64, 33, 33, $WS_GROUP)
$w = GUICtrlCreateButton("W", 72, 64, 33, 33, $WS_GROUP)
$e = GUICtrlCreateButton("E", 104, 64, 33, 33, $WS_GROUP)
$r = GUICtrlCreateButton("R", 136, 64, 33, 33, $WS_GROUP)
$t = GUICtrlCreateButton("T", 168, 64, 33, 33, $WS_GROUP)
$y = GUICtrlCreateButton("Y", 200, 64, 33, 33, $WS_GROUP)
$u = GUICtrlCreateButton("U", 232, 64, 33, 33, $WS_GROUP)
$i = GUICtrlCreateButton("I", 264, 64, 33, 33, $WS_GROUP)
$o = GUICtrlCreateButton("O", 296, 64, 33, 33, $WS_GROUP)
$p = GUICtrlCreateButton("P", 328, 64, 33, 33, $WS_GROUP)
$LeftBrackets = GUICtrlCreateButton("[", 360, 64, 33, 33, $WS_GROUP)
$RightBrackets = GUICtrlCreateButton("]", 392, 64, 33, 33, $WS_GROUP)
$Enter = GUICtrlCreateButton("Enter", 424, 64, 57, 65, $WS_GROUP)
$Delete = GUICtrlCreateButton("Del", 488, 64, 33, 33, $WS_GROUP)
$End = GUICtrlCreateButton("End", 520, 64, 33, 33, $WS_GROUP)
$PageDown = GUICtrlCreateButton("PgDn", 552, 64, 33, 33, $WS_GROUP)
$NumberPad7 = GUICtrlCreateButton("7", 592, 64, 33, 33, $WS_GROUP)
$NumberPad8 = GUICtrlCreateButton("8", 624, 64, 33, 33, $WS_GROUP)
$NumberPad9 = GUICtrlCreateButton("9", 656, 64, 33, 33, $WS_GROUP)
$NumberPadPlus = GUICtrlCreateButton("+", 688, 64, 33, 65, $WS_GROUP)
$CapsLock = GUICtrlCreateButton("CapsLck", 0, 96, 49, 33, $WS_GROUP)
$a = GUICtrlCreateButton("A", 48, 96, 33, 33, $WS_GROUP)
$s = GUICtrlCreateButton("S", 80, 96, 33, 33, $WS_GROUP)
$d = GUICtrlCreateButton("D", 112, 96, 33, 33, $WS_GROUP)
$f = GUICtrlCreateButton("F", 144, 96, 33, 33, $WS_GROUP)
$g = GUICtrlCreateButton("G", 176, 96, 33, 33, $WS_GROUP)
$h = GUICtrlCreateButton("H", 208, 96, 33, 33, $WS_GROUP)
$j = GUICtrlCreateButton("J", 240, 96, 33, 33, $WS_GROUP)
$k = GUICtrlCreateButton("K", 272, 96, 33, 33, $WS_GROUP)
$l = GUICtrlCreateButton("L", 304, 96, 33, 33, $WS_GROUP)
$Colon = GUICtrlCreateButton(";", 336, 96, 33, 33, $WS_GROUP)
$Apostrophe = GUICtrlCreateButton("'", 368, 96, 33, 33, $WS_GROUP)
$RightSlash = GUICtrlCreateButton("\", 400, 96, 33, 33, $WS_GROUP)
$NumberPad4 = GUICtrlCreateButton("4", 592, 96, 33, 33, $WS_GROUP)
$NumberPad5 = GUICtrlCreateButton("5", 624, 96, 33, 33, $WS_GROUP)
$NumberPad6 = GUICtrlCreateButton("6", 656, 96, 33, 33, $WS_GROUP)
$LeftShift = GUICtrlCreateButton("Shift", 0, 128, 33, 33, $WS_GROUP)
$LeftSlash = GUICtrlCreateButton("\", 32, 128, 33, 33, $WS_GROUP)
$z = GUICtrlCreateButton("Z", 64, 128, 33, 33, $WS_GROUP)
$x = GUICtrlCreateButton("X", 96, 128, 33, 33, $WS_GROUP)
$c = GUICtrlCreateButton("C", 128, 128, 33, 33, $WS_GROUP)
$v = GUICtrlCreateButton("V", 160, 128, 33, 33, $WS_GROUP)
$b = GUICtrlCreateButton("B", 192, 128, 33, 33, $WS_GROUP)
$n = GUICtrlCreateButton("N", 224, 128, 33, 33, $WS_GROUP)
$m = GUICtrlCreateButton("M", 256, 128, 33, 33, $WS_GROUP)
$Comma = GUICtrlCreateButton(",", 288, 128, 33, 33, $WS_GROUP)
$Dot = GUICtrlCreateButton(".", 320, 128, 33, 33, $WS_GROUP)
$QuestionMark = GUICtrlCreateButton("/", 352, 128, 33, 33, $WS_GROUP)
$RightShift = GUICtrlCreateButton("Shift", 384, 128, 97, 33, $WS_GROUP)
$NumberPad1 = GUICtrlCreateButton("1", 592, 128, 33, 33, $WS_GROUP)
$NumberPad2 = GUICtrlCreateButton("2", 624, 128, 33, 33, $WS_GROUP)
$NumberPad3 = GUICtrlCreateButton("3", 656, 128, 33, 33, $WS_GROUP)
$NumberPadEnter = GUICtrlCreateButton("Enter", 688, 128, 33, 65, $WS_GROUP)
$LeftCtrl = GUICtrlCreateButton("Ctrl", 0, 160, 41, 33, $WS_GROUP)
$LeftWindows = GUICtrlCreateButton("Win", 40, 160, 41, 33, $WS_GROUP)
$LeftAlt = GUICtrlCreateButton("Alt", 80, 160, 41, 33, $WS_GROUP)
$Space = GUICtrlCreateButton("Space", 120, 160, 201, 33, $WS_GROUP)
$RightAlt = GUICtrlCreateButton("Alt", 320, 160, 41, 33, $WS_GROUP)
$RightWindows = GUICtrlCreateButton("Win", 360, 160, 41, 33, $WS_GROUP)
$RightCtrl = GUICtrlCreateButton("Ctrl", 400, 160, 81, 33, $WS_GROUP)
$NumberPad0 = GUICtrlCreateButton("0", 592, 160, 65, 33, $WS_GROUP)
$NumberPadDot = GUICtrlCreateButton(".", 656, 160, 33, 33, $WS_GROUP)
$LeftArrow = GUICtrlCreateButton("<", 488, 160, 33, 33, $WS_GROUP)
$DownArrow = GUICtrlCreateButton("|", 520, 160, 33, 33, $WS_GROUP)
$RightArrow = GUICtrlCreateButton(">", 552, 160, 33, 33, $WS_GROUP)
$UpArrow = GUICtrlCreateButton("^", 520, 128, 33, 33, $WS_GROUP)
;Pictures:
$NumberLockOnPic = GUICtrlCreatePic("on.bmp", 600, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$NumberLockOffPic = GUICtrlCreatePic("off.bmp", 600, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$CapsLockOnPic = GUICtrlCreatePic("on.bmp", 624, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$CapsLockOffPic = GUICtrlCreatePic("off.bmp", 624, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$ScrollLockOnPic = GUICtrlCreatePic("on.bmp", 648, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$ScrollLockOffPic = GUICtrlCreatePic("off.bmp", 648, 3, 18, 26, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))

;Setting Pictures:
_GetNumLock()
_GetCapsLock()
_GetScrollLock()
If _GetNumLock() = 1 Then
	$NumberLockOn = True
Else
	GUICtrlSetState($NumberLockOnPic, $GUI_HIDE)
	$NumberLockOn = False
EndIf

If _GetCapsLock() = 1 Then
	$CapsLockOn = True
Else
	GUICtrlSetState($CapsLockOnPic, $GUI_HIDE);;
	$CapsLockOn = False
EndIf

If _GetScrollLock() = 1 Then
	$ScrollLockOn = True
Else
	GUICtrlSetState($ScrollLockOnPic, $GUI_HIDE)
	$ScrollLockOn = False
EndIf
;Current focused window will remain focused even after the keyboard GUI is up:
;~ GUISetState()
GUISetState(@SW_HIDE)
GUIRegisterMsg($WM_MOUSEACTIVATE, 'WM_EVENTS')
$WGT = WinGetTitle("", "")
GUISetState(@SW_SHOWNOACTIVATE)
WinActivate($WGT)


While 1
	If WinActive($Form1) = False Then
		WinSetTitle($Form1, "", $MainGUITitle & WinGetTitle("", ""))
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ScrollLock
			_ScrollLockPushed()
		Case $NumberLock
			_NumberLockPushed()
		Case $CapsLock
			_CapsLockPushed()
		Case $Esc
			PressButton("{Escape}", 0)
		Case $F1
			PressButton("{F1}", 0)
		Case $F2
			PressButton("{F2}", 0)
		Case $F3
			PressButton("{F3}", 0)
		Case $F4
			PressButton("{F4}", 0)
		Case $F5
			PressButton("{F5}", 0)
		Case $F6
			PressButton("{F6}", 0)
		Case $F7
			PressButton("{F7}", 0)
		Case $F8
			PressButton("{F8}", 0)
		Case $F9
			PressButton("{F9}", 0)
		Case $F10
			PressButton("{F10}", 0)
		Case $F11
			PressButton("{F11}", 0)
		Case $F12
			PressButton("{F12}", 0)
		Case $PrintScreen
			GUISetState(@SW_HIDE)
			PressButton("{PrintScreen}", 0)
			GUISetState(@SW_SHOW)
		Case $PauseBreak
			PressButton("{PAUSE}", 0)
		Case $Igel
			PressButton("`", 0)
		Case $One
			PressButton("1", 0)
		Case $Two
			PressButton("2", 0)
		Case $Three
			PressButton("3", 0)
		Case $Four
			PressButton("4", 0)
		Case $Five
			PressButton("5", 0)
		Case $Six
			PressButton("6", 0)
		Case $Seven
			PressButton("7", 0)
		Case $Eight
			PressButton("8", 0)
		Case $Nine
			PressButton("9", 0)
		Case $Zero
			PressButton("0", 0)
		Case $Minus
			PressButton("-", 0)
		Case $Equal
			PressButton("=", 0)
		Case $Back
			PressButton("{Backspace}", 0)
		Case $Insert
			PressButton("{Insert}", 0)
		Case $Home
			PressButton("{Home}", 0)
		Case $PageUp
			PressButton("{PgUp}", 0)
		Case $NumberPadSlash
			PressButton("/", 0)
		Case $NumberPadX
			PressButton("*", 0)
		Case $NumberPadMinus
			PressButton("-", 0)
		Case $Tab
			PressButton("{Tab}", 0)
		Case $q
			PressButton("q", 0)
		Case $w
			PressButton("w", 0)
		Case $e
			PressButton("e", 0)
		Case $r
			PressButton("r", 0)
		Case $t
			PressButton("t", 0)
		Case $y
			PressButton("y", 0)
		Case $u
			PressButton("u", 0)
		Case $i
			PressButton("i", 0)
		Case $o
			PressButton("o", 0)
		Case $p
			PressButton("p", 0)
		Case $LeftBrackets
			PressButton("[", 0)
		Case $RightBrackets
			PressButton("]", 0)
		Case $Enter
			PressButton("{Enter}", 0)
		Case $Delete
			PressButton("{Delete}", 0)
		Case $End
			PressButton("{End}", 0)
		Case $PageDown
			PressButton("{PgDn}", 0)
		Case $NumberPad7
			PressButton("7", 0)
		Case $NumberPad8
			PressButton("8", 0)
		Case $NumberPad9
			PressButton("9", 0)
		Case $NumberPadPlus
			PressButton("+", 0)
		Case $a
			PressButton("a", 0)
		Case $s
			PressButton("s", 0)
		Case $d
			PressButton("d", 0)
		Case $f
			PressButton("f", 0)
		Case $g
			PressButton("g", 0)
		Case $h
			PressButton("h", 0)
		Case $j
			PressButton("j", 0)
		Case $k
			PressButton("k", 0)
		Case $l
			PressButton("l", 0)
		Case $Colon
			PressButton(";", 0)
		Case $Apostrophe
			PressButton("'", 0)
		Case $RightSlash
			PressButton("\", 0)
		Case $NumberPad4
			PressButton("4", 0)
		Case $NumberPad5
			PressButton("5", 0)
		Case $NumberPad6
			PressButton("6", 0)
		Case $LeftSlash
			PressButton("\", 0)
		Case $z
			PressButton("z", 0)
		Case $x
			PressButton("x", 0)
		Case $c
			PressButton("c", 0)
		Case $v
			PressButton("v", 0)
		Case $b
			PressButton("b", 0)
		Case $n
			PressButton("n", 0)
		Case $m
			PressButton("m", 0)
		Case $Comma
			PressButton(",", 0)
		Case $Dot
			PressButton(".", 0)
		Case $QuestionMark
			PressButton("/", 0)
		Case $NumberPad1
			PressButton("1", 0)
		Case $NumberPad2
			PressButton("2", 0)
		Case $NumberPad3
			PressButton("3", 0)
		Case $NumberPadEnter
			PressButton("{Enter}", 0)
		Case $LeftWindows
			PressButton("{Lwin}", 0)
		Case $Space
			PressButton("{Space}", 0)
		Case $RightWindows
			PressButton("{Rwin}", 0)
		Case $NumberPad0
			PressButton("0", 0)
		Case $NumberPadDot
			PressButton(".", 0)
		Case $LeftArrow
			PressButton("{Left}", 0)
		Case $DownArrow
			PressButton("{Down}", 0)
		Case $RightArrow
			PressButton("{Right}", 0)
		Case $UpArrow
			PressButton("{Up}", 0)
		Case $LeftShift
			If $fLeftShiftHolden = False And $fRightShiftHolden = False Then
				PressButton("{SHIFTDOWN}", 1)
				$fLeftShiftHolden = True
				GUICtrlDelete($LeftShift)
				$LeftShift = GUICtrlCreateButton("Shift", 0, 128, 33, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fLeftShiftHolden = True And $fRightShiftHolden = False Then
				PressButton("{SHIFTUP}", 1)
				$fLeftShiftHolden = False
				GUICtrlDelete($LeftShift)
				$LeftShift = GUICtrlCreateButton("Shift", 0, 128, 33, 33, $WS_GROUP)
			ElseIf $fLeftShiftHolden = False And $fRightShiftHolden = True Then
				PressButton("{SHIFTDOWN}", 1)
				$fRightShiftHolden = False
				$fLeftShiftHolden = True
				GUICtrlDelete($LeftShift)
				GUICtrlDelete($RightShift)
				$LeftShift = GUICtrlCreateButton("Shift", 0, 128, 33, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$RightShift = GUICtrlCreateButton("Shift", 384, 128, 97, 33, $WS_GROUP)
			EndIf
		Case $RightShift
			If $fRightShiftHolden = False And $fLeftShiftHolden = False Then
				PressButton("{SHIFTDOWN}", 1)
				$fRightShiftHolden = True
				GUICtrlDelete($RightShift)
				$RightShift = GUICtrlCreateButton("Shift", 384, 128, 97, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fRightShiftHolden = True And $fLeftShiftHolden = False Then
				PressButton("{SHIFTUP}", 1)
				$fRightShiftHolden = False
				GUICtrlDelete($RightShift)
				$RightShift = GUICtrlCreateButton("Shift", 384, 128, 97, 33, $WS_GROUP)
			ElseIf $fRightShiftHolden = False And $fLeftShiftHolden = True Then
				PressButton("{SHIFTDOWN}", 1)
				$fLeftShiftHolden = False
				$fRightShiftHolden = True
				GUICtrlDelete($RightShift)
				GUICtrlDelete($LeftShift)
				$RightShift = GUICtrlCreateButton("Shift", 384, 128, 97, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$LeftShift = GUICtrlCreateButton("Shift", 0, 128, 33, 33, $WS_GROUP)
			EndIf
		Case $LeftCtrl
			If $fLeftCtrlHolden = False And $fRightCtrlHolden = False Then
				PressButton("{CTRLDOWN}", 1)
				$fLeftCtrlHolden = True
				GUICtrlDelete($LeftCtrl)
				$LeftCtrl = GUICtrlCreateButton("Ctrl", 0, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fLeftCtrlHolden = True And $fRightCtrlHolden = False Then
				PressButton("{CTRLUP}", 1)
				$fLeftCtrlHolden = False
				GUICtrlDelete($LeftCtrl)
				$LeftCtrl = GUICtrlCreateButton("Ctrl", 0, 160, 41, 33, $WS_GROUP)
			ElseIf $fLeftCtrlHolden = False And $fRightCtrlHolden = True Then
				PressButton("{CTRLDOWN}", 1)
				$fRightCtrlHolden = False
				$fLeftCtrlHolden = True
				GUICtrlDelete($LeftCtrl)
				GUICtrlDelete($RightCtrl)
				$LeftCtrl = GUICtrlCreateButton("Ctrl", 0, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$RightCtrl = GUICtrlCreateButton("Ctrl", 400, 160, 81, 33, $WS_GROUP)
			EndIf
		Case $RightCtrl
			If $fRightCtrlHolden = False And $fLeftCtrlHolden = False Then
				PressButton("{CTRLDOWN}", 1)
				$fRightCtrlHolden = True
				GUICtrlDelete($RightCtrl)
				$RightCtrl = GUICtrlCreateButton("Ctrl", 400, 160, 81, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fRightCtrlHolden = True And $fLeftCtrlHolden = False Then
				PressButton("{CTRLUP}", 1)
				$fRightCtrlHolden = False
				GUICtrlDelete($RightCtrl)
				$RightCtrl = GUICtrlCreateButton("Ctrl", 400, 160, 81, 33, $WS_GROUP)
			ElseIf $fRightCtrlHolden = False And $fLeftCtrlHolden = True Then
				PressButton("{CTRLDOWN}", 1)
				$fLeftCtrlHolden = False
				$fRightCtrlHolden = True
				GUICtrlDelete($RightCtrl)
				GUICtrlDelete($LeftCtrl)
				$RightCtrl = GUICtrlCreateButton("Ctrl", 400, 160, 81, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$LeftCtrl = GUICtrlCreateButton("Ctrl", 0, 160, 41, 33, $WS_GROUP)
			EndIf
		Case $LeftAlt
			If $fLeftAltHolden = False And $fRightAltHolden = False Then
				PressButton("{ALTDOWN}", 1)
				$fLeftAltHolden = True
				GUICtrlDelete($LeftAlt)
				$LeftAlt = GUICtrlCreateButton("Alt", 80, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fLeftAltHolden = True And $fRightAltHolden = False Then
				PressButton("{ALTUP}", 1)
				$fLeftAltHolden = False
				GUICtrlDelete($LeftAlt)
				$LeftAlt = GUICtrlCreateButton("Alt", 80, 160, 41, 33, $WS_GROUP)
			ElseIf $fLeftAltHolden = False And $fRightAltHolden = True Then
				PressButton("{ALTDOWN}", 1)
				$fRightAltHolden = False
				$fLeftAltHolden = True
				GUICtrlDelete($LeftAlt)
				GUICtrlDelete($RightAlt)
				$LeftAlt = GUICtrlCreateButton("Alt", 80, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$RightAlt = GUICtrlCreateButton("Alt", 320, 160, 41, 33, $WS_GROUP)
			EndIf
		Case $RightAlt
			If $fRightAltHolden = False And $fLeftAltHolden = False Then
				PressButton("{ALTDOWN}", 1)
				$fRightAltHolden = True
				GUICtrlDelete($RightAlt)
				$RightAlt = GUICtrlCreateButton("Alt", 320, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
			ElseIf $fRightAltHolden = True And $fLeftAltHolden = False Then
				PressButton("{ALTUP}", 1)
				$fRightAltHolden = False
				GUICtrlDelete($RightAlt)
				$RightAlt = GUICtrlCreateButton("Alt", 320, 160, 41, 33, $WS_GROUP)
			ElseIf $fRightAltHolden = False And $fLeftAltHolden = True Then
				PressButton("{ALTDOWN}", 1)
				$fLeftAltHolden = False
				$fRightAltHolden = True
				GUICtrlDelete($RightAlt)
				GUICtrlDelete($LeftAlt)
				$RightAlt = GUICtrlCreateButton("Alt", 320, 160, 41, 33, $WS_GROUP, $WS_EX_CLIENTEDGE)
				$LeftAlt = GUICtrlCreateButton("Alt", 80, 160, 41, 33, $WS_GROUP)
			EndIf
	EndSwitch
WEnd

Func PressButton($_Key, $_HoldNeeded)
	Local $ctrl
	$ReplacedString = StringReplace(WinGetTitle($Form1), "Virtual Keyboard v0.1 - ", "")
	$ctrl = ControlGetFocus($ReplacedString)
	$ie_handle = WinWaitActive(WinGetTitle('', ''))
	If WinActivate($ReplacedString) Then
		If _ArrayBinarySearch($keyStroke_Array, $_Key) <> -1 And $_Key <> "{TAB}" Then
			Select
				Case $_Key == '{SHIFTDOWN}'
					$shiftstatus = 1
				Case $_Key == '{SHIFTUP}'
					$shiftstatus = 0
				Case $_Key == '{CTRLDOWN}'
					$ctrlstatus = 1
				Case $_Key == '{CTRLUP}'
					$ctrlstatus = 0
				Case $_Key == '{ALTUP}'
					$altstatus = 0
				Case $_Key == '{ALTDOWN}'
					$altstatus = 1
				Case StringLower($_Key) == StringLower('{BS}')
					ControlFocus($ReplacedString, "", $ctrl)
					ControlSend($ReplacedString, "", $ctrl, "{ASC 008}")
				Case StringLower($_Key) == StringLower('{BACKSPACE}')
					ControlFocus($ReplacedString, "", $ctrl)
					ControlSend($ReplacedString, "", $ctrl, "{ASC 008}")
				Case Else
					Send($_Key)
			EndSelect
		Else
			If $shiftstatus == 1 And $CapsLockOn == False And $ctrlstatus == 0 And $altstatus == 0 And $_Key <> "{TAB}" Then
;~ 				Send('0')
				ControlFocus($ReplacedString, "", $ctrl)
				If $ie_handle <> 0 And StringInStr($ctrl, 'Internet Explorer_Server', 0) > 0 Then
					get_keyboard_focus($ie_handle, $ctrl, StringUpper($_Key))
				Else
					ControlCommand($ReplacedString, "", $ctrl, "EditPaste", StringUpper($_Key))
				EndIf
			ElseIf $shiftstatus == 0 And $CapsLockOn == True And $ctrlstatus == 0 And $altstatus == 0 And $_Key <> "{TAB}" Then
				ControlFocus($ReplacedString, "", $ctrl)
				If $ie_handle <> 0 And StringInStr($ctrl, 'Internet Explorer_Server', 0) > 0 Then
					get_keyboard_focus($ie_handle, $ctrl, StringUpper($_Key))
				Else
					ControlCommand($ReplacedString, "", $ctrl, "EditPaste", StringUpper($_Key))
				EndIf
			ElseIf $shiftstatus == 1 And $CapsLockOn == True And $ctrlstatus == 0 And $altstatus == 0 And $_Key <> "{TAB}" Then
				ControlFocus($ReplacedString, "", $ctrl)
				If $ie_handle <> 0 And StringInStr($ctrl, 'Internet Explorer_Server', 0) > 0 Then
					get_keyboard_focus($ie_handle, $ctrl, $_Key)
				Else
					ControlCommand($ReplacedString, "", $ctrl, "EditPaste", $_Key)
				EndIf
			ElseIf $shiftstatus == 0 And $CapsLockOn == False And $ctrlstatus == 0 And $altstatus == 0 And $_Key <> "{TAB}" Then
				ControlFocus($ReplacedString, "", $ctrl)
				If $ie_handle <> 0 And StringInStr($ctrl, 'Internet Explorer_Server', 0) > 0 Then
					get_keyboard_focus($ie_handle, $ctrl, $_Key)
				Else
					ControlCommand($ReplacedString, "", $ctrl, "EditPaste", $_Key)
				EndIf
			ElseIf $ctrlstatus == 1 And $altstatus == 0 Then
				ControlFocus($ReplacedString, "", $ctrl)
				If $ie_handle <> 0 And StringInStr($ctrl, 'Internet Explorer_Server', 0) > 0 Then
					get_keyboard_focus($ie_handle, $ctrl, $_Key)
				Else
					ControlSend($ReplacedString, "", $ctrl, '^' & $_Key)
				EndIf
			ElseIf $ctrlstatus == 0 And $altstatus == 1 Then
				ControlFocus($ReplacedString, "", $ctrl)
				ControlSend($ReplacedString, "", $ctrl, '!' & $_Key)
			Else
				ControlFocus($ReplacedString, "", $ctrl)
				ControlSend($ReplacedString, "", $ctrl, "{ASC 0x09}")
			EndIf
		EndIf
	EndIf
	If $_HoldNeeded = 1 Then
		SoundPlay("Hold.wav")
	Else
		SoundPlay("Type.wav")
		SoundSetWaveVolume(10);Set volume for both Hold.wav and Type.wav
	EndIf
EndFunc   ;==>PressButton

Func get_keyboard_focus($ie_handle, $control_class_namenn, $key)
	_IEErrorHandlerRegister("MyErrFunc")
	$oIE = _IEAttach($ie_handle, 'Embedded')
	If IsObj($oIE) Then
		$oIE.document.activeElement.name
		If @error == 0 Then
			$oRange = $oIE.document.selection.createRange()
			$oRange.text = $key
			Return
		Else
			ConsoleWrite($key)
			ControlSend('', '', '', $key)
		EndIf
	EndIf
EndFunc   ;==>get_keyboard_focus

Func MyErrFunc()
	SetError(1, 1, 1)
	Return
EndFunc   ;==>MyErrFunc

Func _GetNumLock(); By GaryFrost
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_NUMLOCK)
	Return $ret[0]
EndFunc   ;==>_GetNumLock

Func _GetScrollLock(); By GaryFrost
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_SCROLL)
	Return $ret[0]
EndFunc   ;==>_GetScrollLock

Func _GetCapsLock(); By GaryFrost
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_CAPITAL)
	Return $ret[0]
EndFunc   ;==>_GetCapsLock

Func Quit()
	GUIDelete($Form1)
	Exit
EndFunc   ;==>Quit

Func _NumberLockPushed()
	If $NumberLockOn = True Then
		GUICtrlSetState($NumberLockOnPic, $GUI_HIDE)
		PressButton("{NumLock}", 1)
		$NumberLockOn = False
	Else
		GUICtrlSetState($NumberLockOnPic, $GUI_SHOW)
		PressButton("{NumLock}", 1)
		$NumberLockOn = True
	EndIf
EndFunc   ;==>_NumberLockPushed

Func _ScrollLockPushed()
	If $ScrollLockOn = True Then
		GUICtrlSetState($ScrollLockOnPic, $GUI_HIDE)
		PressButton("{ScrollLock}", 1)
		$ScrollLockOn = False
	Else
		GUICtrlSetState($ScrollLockOnPic, $GUI_SHOW)
		PressButton("{ScrollLock}", 1)
		$ScrollLockOn = True
	EndIf
EndFunc   ;==>_ScrollLockPushed

Func _CapsLockPushed()
	If $CapsLockOn = True Then
		GUICtrlSetState($CapsLockOnPic, $GUI_HIDE)
		PressButton("{CapsLock}", 1)
		$CapsLockOn = False
	Else
		GUICtrlSetState($CapsLockOnPic, $GUI_SHOW)
		PressButton("{CapsLock}", 1)
		$CapsLockOn = True
	EndIf
EndFunc   ;==>_CapsLockPushed

Func WM_EVENTS($hWndGUI, $MsgID, $WParam, $LParam)
	Switch $hWndGUI
		Case $Form1
			Switch $MsgID
				Case $WM_MOUSEACTIVATE
					; Check mouse position
					Local $aMouse_Pos = GUIGetCursorInfo($Form1)
					If $aMouse_Pos[4] > 0 Then
						Local $word = _WinAPI_MakeLong($aMouse_Pos[4], $BN_CLICKED)
						_SendMessage($Form1, $WM_COMMAND, $word, GUICtrlGetHandle($aMouse_Pos[4]))
						$arr_win = WinGetPos(WinGetTitle($Form1))
						MouseMove($arr_win[0] + $arr_win[2] - 40, $arr_win[1] + 25, 0)
					ElseIf $aMouse_Pos[1] < 0 And $aMouse_Pos[0] > 700 Then
						Quit()
					Else
						WinActivate($Form1)
					EndIf
					Return $MA_NOACTIVATEANDEAT
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_EVENTS