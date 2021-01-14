;==================================
; Author: Toady
; Example Histogram using two UDF's
;==================================

#include <Misc.au3>
#include <GUIConstants.au3>
#include <Array.au3>
Global $a[255]
$gui = GUICreate("Histogram & Average Color",295,280,@DesktopWidth/2,@DesktopHeight/2)
GUICtrlCreateLabel("Pixels to skip:",130,15)
$stepIn = GUICtrlCreateInput("0",200,10,40)
$label = GUICtrlCreateLabel("",20,70,180,50)
$getHistButton=GuiCtrlCreateButton("Select screen region", 10,10)
$pen=GuiCtrlCreateGraphic(18, 120, 260,130)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1,0xffffff)
GUISetState()

While 1
	Local $msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then 
		Exit
	Elseif $msg = $getHistButton Then
		PerformAction()
		GUICtrlSetData($label,$histos)
		ToolTip("Please Wait",0,0,"Rendering Histogram...")
		RenderHistogram()
		ToolTip("View Results",0,0,"Histogram Complete")
	EndIf
WEnd

Func RenderHistogram()
	Local $max = _ArrayMax($histo,Default,1)
	GuiCtrlDelete($pen)
	$pen=GuiCtrlCreateGraphic(18, 120, 256,130)
	GUICtrlSetBkColor(-1,0xffffff)
	GUICtrlSetState(-1, $GUI_DISABLE)
	For $i = 0 To UBound($a) - 1
		GUICtrlSetGraphic($pen,$GUI_GR_MOVE, $i,128)
		GUICtrlSetGraphic($pen,$GUI_GR_COLOR,"0x" & Hex($i,2) & Hex($i,2) & Hex($i,2) )
		GUICtrlSetGraphic($pen,$GUI_GR_LINE, $i,128-Round(100*($histo[$i+1]/$max),0))
		GUICtrlSetColor(-1,0x000000)
	Next
	GUICtrlSetGraphic($pen,$GUI_GR_MOVE,0,128)
	Local $mod_num = 4
	For $i = 0 To UBound($a) - 9
		If Mod($i,$mod_num) = 0 Then
			GUICtrlSetGraphic($pen,$GUI_GR_COLOR,0xff0000 )
			GUICtrlSetGraphic($pen,$GUI_GR_LINE, $i+$mod_num,128-Round(100*(_ArrayAverage($histo,$i+1,$i+$mod_num+1)/$max),0))
			GUICtrlSetColor(-1,0x000000)
		EndIf
	Next
EndFunc

Func _ArrayAverage($array,$start,$end)
	Local $sum = 0
	For $i = $start To $end
		$sum += $array[$i]
	Next
	Return $sum/($end-$start+1)
EndFunc

Func _DrawGrayScale($x,$y)
	$grayscale=GuiCtrlCreateGraphic($x, $y, 260,10)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1,0xffffff)
	For $i = 0 To 255
		GUICtrlSetGraphic(-1,$GUI_GR_COLOR, "0x" & Hex($i,2) & Hex($i,2) & Hex($i,2))
		GUICtrlSetGraphic(-1,$GUI_GR_RECT, $i,0, $i,10)
	Next
EndFunc

Func PerformAction()
	Local $mouse_start, $mouse_end
	ToolTip("Click starting location...",0,0,"Top left of box")
	While 1
		If _IsPressed("01") Then
			$mouse_start = MouseGetPos()
			While _IsPressed("01")
				Sleep(1)
			WEnd
			ExitLoop
		EndIf
		sleep(1)
	WEnd
	ToolTip("Click ending location...",0,0,"Bottom right of box")
	While 1
		If _IsPressed("01") Then
			$mouse_end = MouseGetPos()
			While _IsPressed("01")
				Sleep(1)
			WEnd
			ExitLoop
		EndIf
		sleep(1)
	WEnd
	ToolTip("Start:" & $mouse_start[0] & "," & $mouse_start[1] & @CRLF & "End:" & $mouse_end[0] & "," & $mouse_end[1] & @CRLF & "Calculating... please wait.",0,0,"Getting results")
	Global $avg_color = _GetAverageColor($mouse_start[0],$mouse_start[1],$mouse_end[0],$mouse_end[1],4)
	Global $histo = _Get2DHistogram($mouse_start[0],$mouse_start[1],$mouse_end[0],$mouse_end[1],GUICtrlRead($stepIn))
	Global $histos = "Average color = " & "0x" & $avg_color & @CRLF & @CRLF & "Total Pixels: " & $histo[0] & @CRLF
EndFunc

;================================
; UDFs
;================================

#CS ----------------------------------
	UDF: _GetAverageColor()
	Author: Toady
	Use: Gets the average color of a given box range on the client screen.
	Returns: Hex string in RGB Format FF00FF 
	$left: Integer - left side of box
	$top: Integer - Top of box
	$right: Integer - Right side of box
	$bottom: Integer - Bottom of box
	$step - number of pixels to skip (higher = faster but less accurate)
	Error handle: Sets Error to 8 if sides of box
	are incorrect. Also returns a null string
#CE ----------------------------------
Func _GetAverageColor($left,$top,$right,$bottom,$step = 0)
	If $top > $bottom Or $left > $right Then
		SetError(8)
		Return ""
	EndIf
	Local $color_hex
	Local $blue = 0x0, $green = 0x0, $red = 0x0
	Local $pixCount = 0
	Local $color_hex = 0x0
	For $i = $top To $bottom
		For $j = $left To $right
			$color_hex = PixelGetColor($j,$i)
			$blue += BitAND($color_hex,255)
			$green += BitShift(BitAND($color_hex,65280),0x08)
			$red += BitShift(BitAND($color_hex,16711680),0x10)
			$j += $step
			$pixCount += 1
		Next
		$i += $step
	Next
	Local $Hex_Avg = StringRight(String(Hex($red/$pixCount)),2)
	$Hex_Avg &= StringRight(String(Hex($green/$pixCount)),2)
	$Hex_Avg &= StringRight(String(Hex($blue/$pixCount)),2)
	return $Hex_Avg
EndFunc

#CS ----------------------------------
	UDF: _Get2DHistogram()
	Author: Toady
	Use: Gets a histogram array (shades of gray)
	Returns: Array
	         Array[0] = number of pixels scanned
			 Array[1-256] = frequency of each color intensity
			 Array[1] = Pure Black
			 ... Array[2-255] = Shades of gray
			 Array[256] = Pure White
	$left: Integer - left side of box
	$top: Integer - Top of box
	$right: Integer - Right side of box
	$bottom: Integer - Bottom of box
	$step - number of pixels to skip (higher = faster but less accurate)
	Error handle: Sets Error to 8 if sides of box
	are incorrect. Also returns a null string
#CE ----------------------------------
Func _Get2DHistogram($left,$top,$right,$bottom,$step = 0)
	If $top > $bottom Or $left > $right Then
		SetError(8)
		Return ""
	EndIf
	Local $Hist[257]
	For $i = 0 To UBound($Hist) - 1
		$Hist[$i] = 0
	Next
	Local $blue = 0x0, $green = 0x0, $red = 0x0
	Local $pixCount = 0
	Local $color_hex = 0x0
	For $i = $top To $bottom
		For $j = $left To $right
			$color_hex = PixelGetColor($j,$i)
			$blue = BitAND($color_hex,255)
			$green = BitShift(BitAND($color_hex,65280),0x08)
			$red = BitShift(BitAND($color_hex,16711680),0x10)
			$Hist[Round(($blue+$red+$green)/3,0)+1] += 1
			$Hist[0] += 1
			$j += $step
		Next
		$i += $step
	Next
	Return $Hist
EndFunc