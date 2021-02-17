#include-once
;AutoItSetOption("MustDeclareVars", 1)
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with Image Search
;                 Require that the ImageSearchDLL.dll be loadable
;
; ------------------------------------------------------------------------------

;===============================================================================
;
; Description:      Find the position of an image on the desktop
; Syntax:           _ImageSearchArea, _ImageSearch
; Parameter(s):
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;                   $transparency - TRANSBLACK, TRANSWHITE or hex value (e.g. 0xffffff) of
;                                  the color to be used as transparency; can be omitted if
;                                  not needed
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
; Note: Use _ImageSearch to search the entire desktop, _ImageSearchArea to specify
;       a desktop region to search
;
;===============================================================================
Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _ImageSearchArea($findImage, $resultPosition, 0, 0, @DesktopWidth, @DesktopHeight, $x, $y, $tolerance, $transparency)
EndFunc   ;==>_ImageSearch

Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)
	If not ($transparency = 0) Then $findImage = "*" & $transparency & " " & $findImage
	If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
	MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & 'Before Call' ) ;### Debug MSGBOX
	Local $result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
    Local $err = @error
	MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & 'After Call' ) ;### Debug MSGBOX
	if $err > 0 Then
	 MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & '$err' & @lf & @lf & 'Return:' & @lf & $err) ;### Debug MSGBOX
	 return 0
    EndIf
	; If error exit
	If $result[0] = "0" Then
		Return 0
	EndIf

	; Otherwise get the x,y location of the match and the size of the image to
	; compute the centre of search
	Local $array = StringSplit($result[0], "|")

	$x = Int(Number($array[2]))
	$y = Int(Number($array[3]))
	If $resultPosition = 1 Then
		$x = $x + Int(Number($array[4]) / 2)
		$y = $y + Int(Number($array[5]) / 2)
	EndIf
	Return 1
EndFunc   ;==>_ImageSearchArea

;===============================================================================
;
; Description:      Wait for a specified number of seconds for an image to appear
;
; Syntax:           _WaitForImageSearch, _WaitForImagesSearch
; Parameter(s):
;                   $waitSecs  - seconds to try and find the image
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;                   $transparency - TRANSBLACK, TRANSWHITE or hex value (e.g. 0xffffff) of
;                                  the color to be used as transparency can be omitted if
;                                  not needed
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImageSearch($findImage, $waitSecs, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	$waitSecs = $waitSecs * 1000
	Local $startTime = TimerInit()
	While TimerDiff($startTime) < $waitSecs
		Sleep(100)
		Local $result = _ImageSearch($findImage, $resultPosition, $x, $y, $tolerance, $transparency)
		If $result > 0 Then
			Return 1
		EndIf
	WEnd
	Return 0
EndFunc   ;==>_WaitForImageSearch

;===============================================================================
;
; Description:      Wait for a specified number of seconds for any of a set of
;                   images to appear
;
; Syntax:           _WaitForImagesSearch
; Parameter(s):
;                   $waitSecs  - seconds to try and find the image
;                   $findImage - the ARRAY of images to locate on the desktop
;                              - ARRAY[0] is set to the number of images to loop through
;                                ARRAY[1] is the first image
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;                   $transparent - TRANSBLACK, TRANSWHITE or hex value (e.g. 0xffffff) of
;                                  the color to be used as transparent; can be omitted if
;                                  not needed
;
; Return Value(s):  On Success - Returns the index of the successful find
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImagesSearch($findImage, $waitSecs, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	$waitSecs = $waitSecs * 1000
	Local $startTime = TimerInit()
	While TimerDiff($startTime) < $waitSecs
		For $i = 1 To $findImage[0]
			Sleep(100)
			Local $result = _ImageSearch($findImage[$i], $resultPosition, $x, $y, $tolerance, $transparency)
			If $result > 0 Then
				Return $i
			EndIf
		Next
	WEnd
	Return 0
EndFunc   ;==>_WaitForImagesSearch
; find recycle bin if it is in the top left corner of screen
; change 2nd argument to 0 to return the top left coord instead
Local $x1, $y1
	$result = _ImageSearchArea("recycle.bmp",1,0,0,200,200,$x1,$y1,0,0x000000) ;perfect black used as transparency
	if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a recycle bin with stuff in top left corner")
	EndIf
