;
; UniKeys v1.0
; Written by Alex Peters, 3/8/2005
; _____________________________________________________________________________

; Constants

	global const $TRAY_DOUBLECLICK = 0x4
	global const $TRAY_RIGHTCLICK  = 0x8
	global const $TRAY_DISABLE     = 0x80
	global const $TRAY_BOLD        = 0x200

; Set AutoIt options

	opt("mustDeclareVars", 1)
	opt("trayAutoPause",   0)
	opt("trayMenuMode",    1)
	opt("trayOnEventMode", 1)

; Import definitions

	#include "defs.au3"

; Set up tray menu

	traySetToolTip("UniKeys")
	traySetClick($TRAY_DOUBLECLICK + $TRAY_RIGHTCLICK)

	trayItemSetState(trayCreateItem("UniKeys v1.0"), _
		$TRAY_BOLD + $TRAY_DISABLE)
	trayItemSetState(trayCreateItem("Written by Alex Peters, 3/8/2005"), _
		$TRAY_DISABLE)
	trayCreateItem("")

	hotkeys()

	trayCreateItem("")
	trayItemSetOnEvent(trayCreateItem("E&xit"), "_exit")

; Idle around

	while (1)
		sleep(0x7fffffff)
	wEnd
; _____________________________________________________________________________

func newHotkey($extKey, $text, $intKey = "", $func = "", $enabled = true)

	local $item
	if ($text) then
		$item = trayCreateItem($text & @TAB & $extKey)
		if ($func = "" or not($enabled)) then
			trayItemSetState($item, $TRAY_DISABLE)
		else
			trayItemSetOnEvent($item, $func)
		endIf
	endIf
	if ($intKey) then hotkeySet($intKey, $func)

endFunc

func _exit()
	exit
endFunc
