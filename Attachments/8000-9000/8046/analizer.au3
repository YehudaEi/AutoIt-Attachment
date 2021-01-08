#include "array.au3"
#include-once

global $AZDLLName = "analizer.dll"

global $NullRect = "0,0,0,0"
; Font struct : "FontName;Size;RedColorValue;GreenColorValue;BlueColorValue;[bold],[italic],[underline],[strikeout]" 
const $AZTahomaFont = "Tahoma;8;0,0,0;"
const $AZDefSansFont = "MS Sans Serif;8;0,0,0;"
const $AZCaptionFont = "Trebuchet MS;10;255,255,255;bold;"
global $AZDefaultFont = $AZTahomaFont

; Tracing text
func AZTrace($text)
	MsgBox(64, "Analizer trace.", $text)
endfunc

; Tracing error
func AZTraceError($error)
	MsgBox(16, "Analizer error.", $error)
endfunc

func AZDllError($func)
	if @error <> 0 then AZTraceError("'" & $func & "' function run error")
endfunc

; Exit from script
func AZExit()
	exit(1)
endfunc

; STRUCT-COVERSION-FUNCTIONS------------------------------------------------------------------

; Setting the default font
func AZSetDefFont($font = "")
	if $font = "" then 
		$AZDefaultFont = $AZTahomaFont
	else
		$AZDefaultFont = $font
	endif
endfunc

; Getting the default font
func AZGetDefFont()
	return $AZDefaultFont
endfunc

; Extract font settings items
func AZGetFontItems($font)
	$items = stringsplit($font, ";")
	if $items[0] <> 3 then
		AZTraceError("GetFontItems function error: [In] font variable is not correct.")
		AZExit()
	endif
	return $items
endfunc

; Extract rect coords to array x, y, width, height
func AZGetRect($rect)
	$items = stringsplit($rect, ",")
	if $items[0] <> 4 then
		AZTraceError("AZGetRect function error: [In] rect variable is not correct.")
		AZExit()
	endif
	return $items	
endfunc

; Covert rect coords to string 
func AZSetRect($x, $y, $width, $height)
	return $x & "," & $y & "," & $width & "," & $height
endfunc

; Convert red, green and blue value of the color to string
func AZSetColor($r, $g, $b)
	return $r & "," & $g & "," & $b
endfunc

; Convert red, green and blue value of the color string to array
func AZGetColor($color)
	$items = stringsplit($color, ",")
	if $items[0] <> 3 then
		AZTraceError("AZGetColor function error: [In] color variable is not correct.")
		AZExit()
	endif
	return $items
endfunc

; OTHER-FUNCTIONS-----------------------------------------------------------------------------

; Print window to clipboard (don't ALT PRINTSCREEN)
func AZPrintWindow()
	$result = DllCall($AZDLLName, "none", "active_window_to_clip")
	AZDllError("AZPrintWindow")
endfunc

; TEXT-WORDKING-FUNCTIONS---------------------------------------------------------------------

; Find text in clipboard with setted font. if found return 1 else 0
func AZTextInClip($text, $font = "")
	if $font = "" then $font = $AZDefaultFont
	$result = DllCall($AZDLLName, "int", "text_in_clipscreen", "str", $text, "str", $font)
	AZDllError("AZTextInClip")
	return $result[0]
endfunc

; Find text in clipboard with setted font. if found return 1 else 0
func AZTextRects($text, $first, $font = "", $rect = "")
	if $rect = "" then $rect = $NullRect
	if $font = "" then $font = $AZDefaultFont
	$rects = ""
	$result = DllCall($AZDLLName, "int", "text_in_clipscreen_rects", "str", $text, "str", $font, "int", $first, "str", $rect, "str", $rects)
	AZDllError("AZTextRects")
	$rects = $result[5]
	if $rects <> "" then
		$rects = stringright($rects, stringlen($rects) - 1)
		return stringsplit($rects, ";")
	else
		return _arraycreate(0)
	endif
endfunc

; Get need coord of text
; Used by func AZTextClick AZTextDblClick and so on
func AZTextRect($text, $index = 1, $font = "", $rect = "")
	$rects = AZTextRects($text, 0, $font, $rect)
	if $rects[0] < $index then
		AZTraceError("Index of the needed text rect out of bounds.")
		AZExit()
	endif
	if ($rects[0] <> 0) then
		$items = AZGetRect($rects[$index])
	else
		$items = _arraycreate(0)
	endif
	return $items
endfunc

; Click on text with user font.
func AZTextClick($text, $index = 1, $font = "", $rect = "")
	$items = AZTextRect($text, $index, $font, $rect)
	if not $items[0] then return 0
	Opt("MouseCoordMode", 0)
	MouseClick("left", $items[1] + $items[3] / 2, $items[2] + $items[4] / 2, 1)
	return 1
endfunc

; Double click on text with user font.
func AZTextDblClick($text, $index = 1, $font = "", $rect = "")
	$items = AZTextRect($text, $index, $font, $rect)
	if not $items[0] then return 0
	Opt("MouseCoordMode", 0)
	MouseClick("left", $items[1] + $items[3] / 2, $items[2] + $items[4] / 2, 2)
	return 1
EndFunc

; IMAGE-WORKING-FUNCTIONS---------------------------------------------------------------------

; Find image in clipboard. if found return 1 else 0
func AZImageInClip($filename, $trans = 0, $color = "")
	$result = DllCall($AZDLLName, "int", "image_in_clipscreen", "str", $filename, "int", $trans, "str", $color)
	AZDllError("AZImageInClip")
	return $result[0]
endfunc

; Find image in clipboard. if found return 1 else 0
func AZImageRects($filename, $first = 1, $rect = "", $trans = 0, $color = "")
	if $rect = "" then $rect = $NullRect
	$rects = ""
	$result = DllCall($AZDLLName, "int", "image_in_clipscreen_rects", "str", $filename, "int", $first, "int", $trans, "str", $color, "str", $rect, "str", $rects)
	AZDllError("AZImageRects")
	$rects = $result[6]
	if $rects <> "" then
		$rects = stringright($rects, stringlen($rects) - 1)
		return stringsplit($rects, ";")
	else
		return _arraycreate(0)
	endif
endfunc

; Get need coord of image
; Used by func AZImageClick AZImageDblClick and so on
func AZImageRect($text, $index = 1, $rect = "", $trans = 0, $color = "")
	$rects = AZImageRects($text, 0, $trans, $color, $rect)
	if $rects[0] < $index then
		AZTraceError("Index of the needed image rect out of bounds.")
		AZExit()
	endif
	if ($rects[0] <> 0) then
		$items = AZGetRect($rects[$index])
	else
		$items = _ArrayCreate(0)
	endif
	return $items
endfunc

; Click on image.
func AZImageClick($text, $index = 1, $rect = "", $trans = 0, $color = "")
	$items = AZImageRect($text, $index, $trans, $color, $rect)
	if not $items[0] then return 0
	Opt("MouseCoordMode", 0)
	MouseClick("left", $items[1] + $items[3] / 2, $items[2] + $items[4] / 2, 1)
	return 1
endfunc

; Double click on image.
func AZImageDblClick($text, $index = 1, $rect = "", $trans = 0, $color = "")
	$items = AZImageRect($text, $index, $trans, $color, $rect)
	if not $items[0] then return 0
	Opt("MouseCoordMode", 0)
	MouseClick("left", $items[1] + $items[3] / 2, $items[2] + $items[4] / 2, 2)
	return 1
endfunc