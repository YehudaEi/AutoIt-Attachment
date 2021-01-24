#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.1
	Author:         A Greencan, martin
	
	Name: Scan_BW_Image.au3
	
	Script Function: Scan BW Image
	Creates perforated image code for a GUI Window.
	
	1. Select an image
	2. Choose Black or White te be removed
	3. Scan the image and make an array of lines
	4. no real use :)
	
	Use ONLY Black & White images with color depth of 1 bpp (only (almost) black and (almost) white are scanned for a good result)
	
#ce ----------------------------------------------------------------------------


#NoTrayIcon
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <StaticConstants.au3>
#include <Date.au3>



Global $Debugging = False
Global $REducedby = 0
Global $toofar = 40

Global Const $WS_EX_COMPOSITED = 0x2000000

$ImageName = FileOpenDialog("Select a Black & White image to be processed", @ScriptDir & "\", "Images (*.jpg;*.bmp)|All Files(*.*)", 1)
If @error Then
	MsgBox(0, "", "No File chosen", 3)
	Exit
EndIf

Local $ChangeText[2] = ['Black', 'White']
;$iMsg = MsgBox(4, "Color option ", 'Erase the Black color' & @CR & 'No = Erase White (Negative effect)',3)
;If $iMsg = 6 Then
;	$Erase_White = False
;Else
;	$Erase_White = True
;EndIf
$Erase_White = False
_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile($ImageName)

Opt("GUICloseOnESC", 1)

; get width and height of the image
Dim $iY, $iX
$iX = _GDIPlus_ImageGetWidth($hImage)
$iY = _GDIPlus_ImageGetHeight($hImage)

_GDIPlus_ImageDispose($hImage)
_GDIPlus_Shutdown()
Opt("PixelCoordMode", 2)
; Create GUI



$hGUI = GUICreate("Image", $iX, $iY + 40, (@DesktopWidth - $iX)/ 2, (@DesktopHeight - $iY)/ 2 , -1, $WS_EX_TOPMOST)
; and load the B/W image
GUICtrlCreatePic($ImageName, 0, 0, $iX, $iY)

$lab = GUICtrlCreateLabel("", 0, $iY + 2, $iX - 4, 36)

GUISetState()
; make sure that the window is on top of all others
WinSetOnTop("Image", "", 1)

; Loop through the image and make an array of the white pixels because these are the ones that need to re-appear
Dim $PictArray[2 * ($iX + $iY)][3]
$iPA = 0
GUICtrlSetData($lab, "Scanning for edge points")

Opt("PixelCoordMode", 2)
; now scan the image

For $aY = 1 To $iY ; for each row
	$previous_pixel = False
	For $aX = 0 To $iX - 1 ; for each column
		$Pixel_color = PixelGetColor($aX, $aY)
		If ($Erase_White = True And $Pixel_color > 16610000) Or ($Erase_White = False And $Pixel_color < 100000) Then;  almost white
;~   If $Pixel_color < 100000 Then ; almost black  use thi if you want to remove the oposite color
			If $previous_pixel = False Then
				$first_pixel = $aX
				$previous_pixel = True
			EndIf
		Else ;  All other colors are considered as white, this is suposed to be a black and white image!
			If $previous_pixel = True Then ; OK previous was a black area
				$previous_pixel = False ; reset flag
				; now fill the array
				; parameters
				; $nLeftRect    - Specifies the x-coordinate of the upper-left corner of the region in logical units.
				; $nTopRect     - Specifies the y-coordinate of the upper-left corner of the region in logical units.
				; $nRightRect   - Specifies the x-coordinate of the lower-right corner of the region in logical units.
				; $nBottomRect  - Specifies the y-coordinate of the lower-right corner of the region in logical units.
				;_ArrayAdd($PictArray, String($first_pixel) & "," & String($aY) & "," & String($aX - 1) & "," & String($aY))
				AddNewPoints($first_pixel, $aY, $aX - 1, $aY, $iPA, $PictArray)
				#cs
					$PictArray[$iPA][0] = $first_pixel
					$PictArray[$iPA][1] = $aY
					$PictArray[$iPA][2] = 0
					$iPA += 1
					If $iPA >= UBound($PictArray) - 20 Then ReDim $PictArray[$iPA + 40][3]
					$PictArray[$iPA][0] = $aX - 1
					$PictArray[$iPA][1] = $aY
					$PictArray[$iPA][2] = 0
					$iPA += 1
				#ce
			EndIf
		EndIf
	Next
	; this is needed for last pixel being white
	If $previous_pixel = True Then ; OK previous was a black area
		$previous_pixel = False ; reset flag
		AddNewPoints($first_pixel, $aY, $aX - 1, $aY, $iPA, $PictArray)
		#cs
			$PictArray[$iPA][0] = $first_pixel
			$PictArray[$iPA][1] = $aY
			$PictArray[$iPA][2] = 0
			$iPA += 1
			If $iPA >= UBound($PictArray) - 20 Then ReDim $PictArray[$iPA + 40][3]
			$PictArray[$iPA][0] = $aX - 1
			$PictArray[$iPA][1] = $aY
			$PictArray[$iPA][2] = 0
			$iPA += 1
		#ce
	EndIf
	;DebugConsoleWrite(@CR)
Next
GUICtrlSetData($lab, "Scanning pass 2 for Edges")
;scan vertically
;many points will be duplicates so use AddNewPoints function
For $aX = 1 To $iX - 1 ; for each column
	
	$previous_pixel = False

	For $aY = 1 To $iY - 1 ; for each row
		$Pixel_color = PixelGetColor($aX, $aY)
		If ($Erase_White = True And $Pixel_color > 16610000) Or ($Erase_White = False And $Pixel_color < 100000) Then;  almost white
			If $previous_pixel = False Then
				$first_pixel = $aY
				$previous_pixel = True
			EndIf
		Else ;  All other colors are considered as white, this is suposed to be a black and white image!
			If $previous_pixel = True Then ; OK previous was a black area
				$previous_pixel = False ; reset flag
				; now fill the array
				; parameters
				; $nLeftRect    - Specifies the x-coordinate of the upper-left corner of the region in logical units.
				; $nTopRect     - Specifies the y-coordinate of the upper-left corner of the region in logical units.
				; $nRightRect   - Specifies the x-coordinate of the lower-right corner of the region in logical units.
				; $nBottomRect  - Specifies the y-coordinate of the lower-right corner of the region in logical units.
				AddNewPoints($aX, $first_pixel, $aX, $aY - 1, $iPA, $PictArray)
			EndIf
		EndIf
	Next
	; this is needed for last pixel being white
	If $previous_pixel = True Then ; OK previous was a black area
		$previous_pixel = False ; reset flag
		AddNewPoints($aX, $first_pixel, $aX, $aY - 1, $iPA, $PictArray)
	EndIf
	;DebugConsoleWrite(@CR)
Next
;GUIDelete($hGUI)

;$gui = GUICreate("outline", 600, 600, 200, 200);, -1, $WS_EX_COMPOSITED)
;GuiSwitch($gui)
DebugConsoleWrite("time started = " & _NowCalc() & @CRLF)
;$ends = $PictArray
;_ArrayDisplay($PictArray)
GUICtrlSetData($lab, "Searching points for enclosed shapes")
;Create an array of points amrking the edges of individual shapes which will used to draw the shapes
$segments = makelines($PictArray)
;_ArrayDisplay($segments)

DebugConsoleWrite("reduced no of point by " & $REducedby & @CRLF)
DebugConsoleWrite("time sfinished = " & _NowCalc() & @CRLF)

;Now draw the lines
$newshape = True

$guiout = GUICreate("drawing outlines", $iX, $iY , (@DesktopWidth - $iX)/ 2 + 80, (@DesktopHeight - $iY)/ 2 + 80 , -1,$WS_EX_TOPMOST )
$gr1 = GUICtrlCreateGraphic(0, 0, $iX, $iY)
GUICtrlSetBkColor(-1, 0xffffff)

GUICtrlSetColor(-1, 0)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00dd00)
GUISetState(@SW_SHOW,$guiout)

;Temporaily set the extended style to $WS_EX_COMPOSITED to stop the flicker
$style = GUIGetStyle($guiout)
GUISetStyle($style[0], BitOR($style[1], $WS_EX_COMPOSITED, $WS_EX_LAYERED), $guiout)

$GuiPen = GUICreate("Pencil", 77, 70, 100, 100, $WS_POPUP, $WS_EX_LAYERED)
$pic = GUICtrlCreatePic("pencil.bmp", 0, 0, 77, 76)
GUISetState()
WinSetOnTop($GuiPen, "", 1)
$wp = WinGetPos($guiout)
WinMove($GuiPen, $wp[0] + 200, $wp[1] -40 + 100, 100)

$col = 1
$lastkx = 0
$lastky = 0
For $k = 0 To UBound($segments) - 1
	If $segments[$k][0] = -99 Then ; end of line shape so start new one
		$newshape = True
		DebugConsoleWrite("starting new shape" & @CRLF)
	Else
		If $newshape Then
			WinSetOnTop($GuiPen, "", 1)
			$wp = WinGetPos($guiout)
			$movex = $lastkx - $segments[$k][0]
			$movey =  $lastky - $segments[$k][1]
			$maxmove = Abs($movex)
			if Abs($movey) > $maxmove then $maxmove = Abs($movey)
			for $xx = 1 to $maxmove 
			      WinMove($GuiPen, "", $wp[0] - 5 + $lastkx - $movex * $xx/$maxmove, $wp[1] -40 +$lastky - $movey * $xx/$maxmove)
			sleep(10)
			next
			GUICtrlSetGraphic($gr1, $GUI_GR_MOVE, $segments[$k][0], $segments[$k][1])
			$newshape = False
		Else
			WinSetOnTop($GuiPen, "", 1)
			$wp = WinGetPos($guiout)
			WinMove($GuiPen, "", $wp[0] - 5 + $segments[$k][0], $wp[1] - 40 + $segments[$k][1])
			GUICtrlSetGraphic($gr1, $GUI_GR_LINE, $segments[$k][0], $segments[$k][1])
			$lastkx = $segments[$k][0]
			$lastky = $segments[$k][1]
		EndIf
	EndIf

	Sleep(20)

	GUICtrlSetGraphic($gr1, $GUI_GR_REFRESH);lines added will not be shown untill the graphic is redrawn

Next
GUIDelete($GuiPen)
;trun off the $WS_EX_EXTEDED style because it stops the window caption buttons being displayed correctly
GUISetStyle($style[0], $style[1], $guiout)

While GUIGetMsg() <> -3
	Sleep(10)
WEnd

;add points $x1,$y1 and $x2,$y2 if not already used
Func AddNewPoints($x1, $y1, $x2, $y2, ByRef $i, ByRef $arr)
	;Grow the array if getting full
	If $i >= UBound($arr) - 20 Then ReDim $arr[$i + 40][3]
	
	;check if the pooint already exists, if not then add it
	If nopoint($x1, $y1, $i, $arr) Then
		$arr[$i][0] = $x1
		$arr[$i][1] = $y1
		$arr[$i][2] = 0
		$i += 1
	EndIf
	
	If nopoint($x2, $y2, $i, $arr) Then
		$arr[$i][0] = $x2
		$arr[$i][1] = $y2
		$arr[$i][2] = 0
		$i += 1
	EndIf
	
	
EndFunc   ;==>AddNewPoints

;turn the array of points into an ordered array of points so that a line can be drawn moving from one point to the next
Func makelines($points)

	Dim $result[UBound($points) + 20][2]
	
	$index = -1;element in the array $result we are building
	$shapenum = 1;we are going to find the first line to draw (might end up being an enclosed shape)
	$lastpoint = -1
	Do
		DebugConsoleWrite("making shape number " & $shapenum & @CRLF)
		If $shapenum = 1 Then
			GUICtrlSetData($lab, "Searching for an enclosed shape")
		Else
			GUICtrlSetData($lab, "Found " & $shapenum - 1 & " shape(s). Searching for another")
		EndIf
		
		If $lastpoint <> -1 Then
			$next = $lastpoint
		Else
			$next = -1
			findstart($next, $points);find the first unused point in $points and set $next to equal that element
		EndIf
		If $next > -1 Then;if a point was found
			DebugConsoleWrite("$next = " & $next & "$index to use = " & $index & @CRLF)
			$nowx = $points[$next][0]
			$nowy = $points[$next][1]
			$points[$next][2] = 1
			$index += 1
			$result[$index][0] = $nowx
			$result[$index][1] = $nowy
			$firstx = $nowx
			$firsty = $nowy
			$lastpoint = -1
			$startElement = $index
			
			DebugConsoleWrite("first x,y = " & $firstx & ', ' & $firsty & '. start element = ' & $startElement & @CRLF)
			Do
				$closest = 999999;assume we will find something closer than this
				$lastpoint = -1
				;now find the closest unused point
				For $p = 1 To UBound($points) - 1
					If $points[$p][2] = 0 Then
						$dist = (($nowx - $points[$p][0]) ^ 2) + (($nowy - $points[$p][1]) ^ 2)
						If $dist < $closest Then;$dist < $toofar And
							$posnear = $p
							$closest = $dist
							$lastpoint = $posnear
							;If $dist < $toofar then $lastpoint = $posnear
							DebugConsoleWrite("didt = " & $dist & @CRLF)
						EndIf
						DebugConsoleWrite("didt = " & $dist & @CRLF)
					EndIf
					
				Next
				DebugConsoleWrite("closest = " & $closest & @CRLF)
				;if the closest point found is within outr range $toofar then add it to our line
				If $closest < $toofar Then
					$index += 1
					$result[$index][0] = $points[$posnear][0];x coord
					$result[$index][1] = $points[$posnear][1];y coord
					$points[$posnear][2] = 1;set it as used
					$nowx = $result[$index][0]
					$nowy = $result[$index][1]
					;Maybe the previous point was not needed
					If $index - $startElement > 1 Then removeOnLinePoints($result, $index)
				EndIf
				DebugConsoleWrite("closest = " & $closest & @CRLF)
			Until $closest >= $toofar
			DebugConsoleWrite("last x,y = " & $result[$index][0] & ', ' & $result[$index][1] & @CRLF)
			;If $lastpoint <> -1 Then
			;calc distance to the start of the line
			$tostart = ($firstx - $result[$index][0]) ^ 2 + ($firsty - $result[$index][1]) ^ 2
			DebugConsoleWrite("to start from last = " & $tostart & @CRLF)
			If $tostart < $toofar Then;we'll assume that this was an enclosed shape so we'll draw back to the start
				$index += 1
				ReDim $result[UBound($result) + 1][2]
				$result[$index][0] = $firstx
				$result[$index][1] = $firsty
				
			EndIf
			
			
			;indicate that this is the end of a line or shape
			$index += 1
			ReDim $result[UBound($result) + 1][2]
			$result[$index][0] = -99;mark end of line
			DebugConsoleWrite("element = " & $index & @CRLF)
			DebugConsoleWrite("ended section with -99" & @CRLF)
		Else
			ExitLoop
		EndIf
		$shapenum += 1
	Until $firstx = -1;until we can't find any more points to draw
	DebugConsoleWrite("index = " & $index & @CRLF)
	ReDim $result[$index + 1][2]
	ConsoleWrite("total no of points is " & $index & @CRLF)
	GUICtrlSetData($lab, "finishing searching for shapes")
	Return $result
EndFunc   ;==>makelines

Func nopoint($x, $y, $i, $ar);boolean, true if $x,$y is not included in the array $ar. $i-1 is the last element used
	Local $g
	For $g = 0 To $i - 1
		If ($x = $ar[$g][0] And $y = $ar[$g][1]) Then Return False;the point alreday exists
	Next
	Return True;no such point exists yet
	
EndFunc   ;==>nopoint

;try to reduce the number of points
Func removeOnLinePoints(ByRef $array, ByRef $i);, ByRef $lp)
	Return;not wanted for pencil draqawing effect
	$reduce = False
	If ($array[$i - 1][1] = $array[$i - 2][1] And $array[$i - 1][1] = $array[$i][1]) Or _
			($array[$i - 1][0] = $array[$i - 2][0] And $array[$i - 1][0] = $array[$i][0]) Then
		$reduce = True;because we are on a straight line
		
	Else;
		If ($array[$i][1] - $array[$i - 2][1]) / ($array[$i][0] - $array[$i - 2][0]) = _
				($array[$i][1] - $array[$i - 1][1]) / ($array[$i][0] - $array[$i - 1][0]) Then
			
			$reduce = True;because on a straight line again
			DebugConsoleWrite("slope reducer :" & $array[$i][1] & ', ' & $array[$i - 1][1] & ', ' & $array[$i - 2][1] & @CRLF)
			DebugConsoleWrite("slope reducer :" & $array[$i][0] & ', ' & $array[$i - 1][0] & ', ' & $array[$i - 2][0] & @CRLF)
		EndIf
		
		;#ce
	EndIf

	If $reduce Then
		$REducedby += 1
		$array[$i - 1][0] = $array[$i][0]
		$array[$i - 1][1] = $array[$i][1]
		$i -= 1
		
	EndIf
EndFunc   ;==>removeOnLinePoints

;find the first unused point
;we should have some way of finding out if there is an open end and if so start from there
;so that the line is drawn ion one rather than two sections or more.
Func findstart(ByRef $freepoint, $arrayxy)
	For $j = 0 To UBound($arrayxy) - 1
		If $arrayxy[$j][2] = 0 Then;this point not used yet
			$freepoint = $j
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>findstart

Func DebugConsoleWrite($SDebug)
	If $Debugging Then ConsoleWrite($SDebug)
	
EndFunc   ;==>DebugConsoleWrite
