;
; Hotkey definitions
;
; File must consist of:
;
;   *  a hotkeys() function: used for defining hotkeys and tray menu entries
;   *  functions for the hotkeys/tray menu entries to call
; _____________________________________________________________________________

func hotkeys()

; Lines could take the form:
;
;   *  newHotkey($menuKey, $menuText[, $hotkey, $func[, $enabled]])
;
;      $menuKey: key combination to be shown on the menu
;      $menuText: text to be shown on the menu
;      $hotkey: hotkey in AutoIt format
;      $func: function to execute when menu item selected or hotkey hit
;      $enabled: set to false to disable item in menu
;
;      Leaving $menuKey and $menuText blank will result in no menu item being
;      made for the hotkey. Leaving $hotkey and $func empty will create a
;      greyed-out menu item.
;
;   *  trayCreateItem("")
;      Use to create a separator in the menu.

	newHotkey("Win+Up",       "Maximise",       "#{UP}",   "max",       false)
	newHotkey("Win+Left",     "Restore",        "#{LEFT}", "restore",   false)
	newHotkey("Win+Down",     "Minimise",       "#{DOWN}", "min",       false)

	trayCreateItem("")

	newHotkey("",             "",               "#c",      "winC"            )
	newHotkey("Win+C",        "Calculator",     "",        "calc"            )
	newHotkey("Win+CC",       "Command prompt", "",        "cmdPrompt"       )
	newHotkey("Win+H",        "Home drive",     "#h",      "homeDrive"       )
	newHotkey("Win+I",        "Firefox",        "#i",      "firefox"         )
	newHotkey("Win+N",        "Notepad",        "#n",      "notepad"         )
	newHotkey("Win+P",        "PuTTY",          "#p",      "putty"           )
	newHotkey("Win+V",        "VNC",            "#v",      "vnc"             )

	trayCreateItem("")

	newHotkey("Ctrl+Alt+End", "Force log off",  "^!{END}", "logOff"          )

endFunc
; _____________________________________________________________________________

; Preparation for functions below

	global const $DOUBLE_KEY_TIMEOUT = 250
	global $winCPress = 0

	opt("sendKeyDelay",      1)
	opt("winWaitDelay",      0)
	opt("winTitleMatchMode", 4)
; _____________________________________________________________________________

func max()
	winSetState("active", "", @SW_MAXIMIZE)
endFunc

func restore()
	winSetState("active", "", @SW_RESTORE)
endFunc

func min()
	winSetState("active", "", @SW_MINIMIZE)
endFunc
; _____________________________________________________________________________

func winC()
	global $winCPress
	adlibDisable()
	if ($winCPress = 1) then
		$winCPress = 0
		cmdPrompt()
	else
		adlibEnable("winCTimeout", $DOUBLE_KEY_TIMEOUT)
		$winCPress = 1
	endIf
endFunc

func winCTimeout()
	global $winCPress
	adlibDisable()
	$winCPress = 0
	calc()
endFunc

func calc()
	run("calc")
	winWait("classname=SciCalc")
	winActivate("")
	; I sure would love to send message WM_COMMAND, wParam 304 here instead of
	; a keys send()... anyone?
	send("!vs")
endFunc

func cmdPrompt()
	run("cmd")
endFunc

func homeDrive()
	run("explorer /e, /root, h:\", "", @SW_MAXIMIZE)
endFunc

func firefox()
	run("C:\Program Files\Mozilla Firefox\firefox.exe dls.rmit.edu.au", "", _
		@SW_MAXIMIZE)
endFunc

func notepad()
	run("notepad", "", @SW_MAXIMIZE)
endFunc

func putty()
	run("h:\numbat.exe")
endFunc

func vnc()
	local $VNC_WINDOW = "classname=VNCviewer"
	if (winExists($VNC_WINDOW) or winExists("VNC Authentication")) then
		if (bitAND(winGetState($VNC_WINDOW), 1)) then
			winClose($VNC_WINDOW)
		else
			winActivate($VNC_WINDOW)
			winActivate("VNC Authentication")
		endIf
	else
		run("C:\Program Files\ORL\VNC\vncviewer.exe numbat.cs.rmit.edu.au:25")
	endIf
endFunc
; _____________________________________________________________________________

func logOff()

	local const $LOG_OFF = 0
	local const $FORCE = 4

	trayTip("", "Logging off...", 30)
	shutDown($LOG_OFF + $FORCE)

endFunc
