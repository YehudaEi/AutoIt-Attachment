; runescape bot

HotKeySet("{f3}","click") ; set f3
; to Function "click"

;create a loot which will loop
;until something happends
; like f3 is pressed.
While 1
	sleep(30) ; to be nice to cpu
WEnd
; create the function click
Func click()
	; Start a loop
	While 1
	sleep(3000) ; delay between 
	;clicks
	; this will make a left click
	; at the current mouse pos
	MouseClick("left")
WEnd
EndFunc