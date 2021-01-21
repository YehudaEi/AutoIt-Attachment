#include "array.au3"

global $AZDLLName = "analizer.dll"


Sleep(2000)

AZPrintWindow()

$var = _findImageOnScreen(".02-.04.bmp", "0,0,0,0", 0)

If $var <> 0 Then
	For $r = 1 to UBound($var)-1
		MouseMove($var[$r][1] , $var[$r][2], 20 )
		Sleep(200)
	Next
EndIf



exit

;Find image on screen and return cords
;findFile: File you want to find on the screen
;rect: x,y,width,height
Func _findImageOnScreen2($findFile, $rect)
	Dim $mouseCords[1][3]
	
	$rects = ""
	$first = 1
	$trans = 0
	$color = ""

	$result = DllCall($AZDLLName, "int", "image_in_clipscreen_rects", "str", $findFile, "int", $first, "int", $trans, "str", $color, "str", $rect, "str", $rects)

	AZDllError("AZTextRects")
	$rects = $result[6]
	MsgBox(0,"",$rects)
	if $rects <> "" then
		$rects = stringright($rects, stringlen($rects) - 1)
		$rects = stringsplit($rects, ";")
	else
		$rects = _arraycreate(0)
	endif

	if $rects[0] < 1 then
		return 0
	endif
	
	exit
	if ($rects[0] <> 0) then
		$items = stringsplit($rects[1], ",")
		if $items[0] <> 4 then
			AZTraceError("AZGetRect function error: [In] rect variable is not correct.")
			AZExit()
		endif
	else
		$items = _arraycreate(0)
	endif
	
	$mouseCords[1] = $items[1] + $items[3] / 2
	$mouseCords[2] = $items[2] + $items[4] / 2
	
	return $mouseCords
EndFunc



;Find image on screen and return cords
;findFile: File you want to find on the screen
;rect: x,y,width,height
;first: 1 = find first 0 = find all
Func _findImageOnScreen($findFile, $rect, $first)
	Dim $mouseCords[1][3]
	
	$rects = ""
	$trans = 0
	$color = ""

	$result = DllCall($AZDLLName, "int", "image_in_clipscreen_rects", "str", $findFile, "int", $first, "int", $trans, "str", $color, "str", $rect, "str", $rects)

	AZDllError("AZTextRects")
	$rects = $result[6]
	;MsgBox(0,"",$rects)

	if $rects <> "" then
		$rects = stringright($rects, stringlen($rects) - 1)
		$rects = stringsplit($rects, ";")
		$mouseIndex = $rects[0]
		ReDim $mouseCords[$mouseIndex+1][3]
	else
		$rects = _arraycreate(0)
	endif

	if $rects[0] < 1 then
		return 0
	endif
	
	
	if ($rects[0] <> 0) then
		For $n = 1 to $mouseIndex
		;MsgBox(0,$n,$rects[$n])
			$items = stringsplit($rects[$n], ",")
			if $items[0] = 4 then
				$mouseCords[$n][1] = $items[1] + $items[3] / 2
				$mouseCords[$n][2] = $items[2] + $items[4] / 2
			
				$pWidth  = $items[3]
				$pHeight = $items[4]
			ElseIf $items[0] = 3 then
				$mouseCords[$n][1] = $items[1] + $pWidth / 2
				$mouseCords[$n][2] = $items[2] + $pHeight / 2
			Else
				AZTraceError("Index of the needed text rect out of bounds.")
				AZExit()
			Endif
			
			;MsgBox(0,$mouseCords[$n][1],$mouseCords[$n][2])
			

		Next
	else
		$items = _arraycreate(0)
	endif

	return $mouseCords
EndFunc


; Print window to clipboard (don't ALT PRINTSCREEN)
func AZPrintWindow()
	$result = DllCall($AZDLLName, "none", "active_window_to_clip")
	AZDllError("AZPrintWindow")
endfunc

;Error
func AZDllError($func)
	if @error <> 0 then AZTraceError("'" & $func & "' function run error")
endfunc

; Tracing error
func AZTraceError($error)
	MsgBox(16, "Analizer error.", $error)
endfunc