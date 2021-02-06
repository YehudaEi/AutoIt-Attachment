; use this to debug in console window <--- LOOK
;#AutoIt3Wrapper_run_debug_mode=Y

Opt("PixelCoordMode", 1)        ;1=absolute, 0=relative, 2=client

; Press Esc to terminate script, Pause/Break to "pause"
Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

$debug = 1

;want to merrily move across the screen inverting each pixel color
For $y = 1 to @DesktopHeight		;Height of the desktop screen in pixels.  (vertical resolution)
	For $x = 1 to @DesktopWidth		;Width of the desktop screen in pixels.  (horizontal resolution)
		$pc = PixelGetColor($x,$y)	;recall under Win7 format is 0xAARRGGBB
		;leave Alpha alone - invert the rest
		$npc = BitAND(0x00FFFFFF, BitNOT($pc))
		_PixelSetColor($x, $y, $npc)	;set color at x,y
		If $debug = 1 Then ConsoleWrite("At " & $x & "," & $y & " = 0x" & Hex($pc) & " Invert = 0x" & Hex($npc) & @CRLF )	;debug
	Next
Next

Exit



;================= functions ==================

Func _PixelSetColor($x, $y, $npc)	;set color at x,y

	;Malkey Posted 19 August 2008 - 04:18 PM --> deals with stored image bitmaps.
	;how the heck do you set a screen pixel color??


EndFunc


Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc


Func Terminate()
    Exit 0
EndFunc

