#include-once


; NOTE: this UDF contains many modifications to the 'mainstream' Marquee.au3 UDF (created by Melba23 and others)
; *******************************************************************************************************************************
;    								SOME OF THESE MODIFICATIONS MAY BREAK EXISTING CODE!
; *******************************************************************************************************************************
; Most notably:
; 	@extended has been changed to correctly return the index of parameter with error (bug in 'mainstream' UDF)
; 	font size - this UDF uses W3C Recommendation for font properties - see notes below for details
; *******************************************************************************************************************************
;
;  Additional recommendations from w3.org built into Marquee_W3C.au3 UDF
;
;  1. Border thickness (width) refered as "thin", "medium" and "thick" or <length> (any number - to infinity)
;     (http://www.w3.org/TR/CSS2/box.html#border-properties)
;     (                                                         )
;     the UDF allows any number as an entry, as well as the more 'friendly' named terms
;
;  2. 'Border Style' is included in this UDF (as per http://www.w3.org/TR/CSS2/box.html#border-properties
;	  ('dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset') plus 'none'
;
;  3. use of PIXELS and EM for formatting text instead of POINTS
;     http://www.w3.org/TR/CSS2/fonts.html#font-size-props use <length> paramaters
;     http://www.w3.org/TR/CSS2/syndata.html#value-def-length with named length units (em, ex, cm, in, px, etc.)
;
;	  POINTS are used in typsetting, while PIXELS, and EM are more correct methods of sizing
;     fonts on modern monitors (one good article on this topic can be found at
;                                                                   )
;
;		To choose your own font style, size, etc.
;		(as per W3C), set the 'point' size to -1 and place all font controls in the 'font' location
; *******************************************************************************************************************************

; #INDEX# =======================================================================================================================
; Title .........: Marquee
; Description ...: This module contains functions to create and manage marquee controls
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_GUICtrlMarquee_Init       : Initialises a Marquee control
;_GUICtrlMarquee_SetScroll  : Sets movement parameters for Marquee
;_GUICtrlMarquee_SetDisplay : Sets display parameters for Marquee
;_GUICtrlMarquee_Create     : Creates Marquee
;_GUICtrlMarquee_Delete     : Deletes a marquee control
;_GUICtrlMarquee_Reset      : Resets a marquee control to current parameters
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;================================================================================================================================

; #INCLUDES# ====================================================================================================================

; #GLOBAL VARIABLES# ============================================================================================================
; Array to hold Marquee parameters
Global $aMarquee_Params[1][16] = [[0, 0, 0, "scroll", "left", 6, 85, 0, 0, 0, 12, "Tahoma", "", "none",0,"center"]]
; [0][0]  = Count                [n][0]  = ControlID
; [0][1]                        [n][1]  = Obj Ref
; [0][2]  = Def loop state        [n][2]  = Loop state
; [0][3]  = Def move state        [n][3]  = Move state
; [0][4]  = Def move dirn        [n][4]  = Move dirn
; [0][5]  = Def scroll speed    [n][5]  = Scroll speed
; [0][6]  = Def delay time        [n][6]  = Delay time
; [0][7]  = Def border state    [n][7]  = Border state
; [0][8]  = Def text colour        [n][8]  = Text colour
; [0][9]  = Def back colour        [n][9]  = Back colour
; [0][10] = Def font family        [n][10] = Font size
; [0][11] = Def font size        [n][11] = Font family
; [0][12]                        [n][12] = Text
; [0][13] = Def border style	 [n][13] = Border style
; [0][14] = Def border color     [n][14] = Border color
; [0][15] = Def text alignment   [n][15] = Text Align

; Get system text and background colours
Global $aMarquee_Colours_Ret = DllCall("User32.dll", "int", "GetSysColor", "int", 8)
$aMarquee_Params[0][8] = BitAND(BitShift(String(Binary($aMarquee_Colours_Ret[0])), 8), 0xFFFFFF)
$aMarquee_Colours_Ret = DllCall("User32.dll", "int", "GetSysColor", "int", 5)
$aMarquee_Params[0][9] = BitAND(BitShift(String(Binary($aMarquee_Colours_Ret[0])), 8), 0xFFFFFF)
$aMarquee_Colours_Ret = DllCall("User32.dll", "int", "GetSysColor", "int", 6)
$aMarquee_Params[0][14] = BitAND(BitShift(String(Binary($aMarquee_Colours_Ret[0])), 8), 0xFFFFFF)

; Set additional Global variables
Global $sTipText,$iVSpace,$iTopMargin

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_Init
; Description ...: Initialises UDF prior to creating a Marquee control
; Syntax.........: _GUICtrlMarquee_Init()
; Parameters ....: None
; Return values .: Index of marquee to be passed to other _GUICtrlMarquee functions
; Author ........: Melba23
; Related .......: Other _GUICtrlMarquee functions
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_Init()

	; Add a new line to the array
	$aMarquee_Params[0][0] += 1
	ReDim $aMarquee_Params[$aMarquee_Params[0][0] + 1][16]
	; Copy over the default values
	For $i = 2 To 12
		$aMarquee_Params[$aMarquee_Params[0][0]][$i] = $aMarquee_Params[0][$i]
	Next
	; Return index of marquee in array
	Return $aMarquee_Params[0][0]

EndFunc   ;==>_GUICtrlMarquee_Init

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_SetScroll
; Description ...: Sets movement parameters for a Marquee
; Syntax.........: _GUICtrlMarquee_SetScroll($iIndex, [$iLoop, [$sMove, [$sDirection, [$iScroll, [$iDelay]]]]])
; Parameters ....: $iIndex       - Index of marquee returned by _GUICtrlMarquee_Init
;                  $iLoop        - [optional] Number of loops to repeat. (Default = infinite, -1 = leave unchanged)
;                                      Use "slide" movement to keep text visible after stopping
;                  $sMove        - [optional] Movement of text.  From  "scroll" (Default), "slide" and "alternate". (-1 = leave unchanged)
;                  $sDirection   - [optional] Direction of scrolling.  From "left" (Default), "right", "up" and "down". (-1 = leave unchanged)
;									Use $sDirection = 'up' or 'down' and $sTextAlign to create different effects
;									Use $sDirection = 'center' and $sTextAlign to make a 'Banner' (no scrolling action, only text on screen)
;                  $iScroll      - [optional] Distance of each advance - controls speed of scrolling (Default = 6, -1 = leave unchanged)
;                                      Higher numbers increase speed, lower numbers give smoother animation.
;                  $iDelay       - [optional] Time in milliseconds between each advance (Default = 85, -1 = leave unchanged)
;                                      Higher numbers lower speed, lower numbers give smoother animation.
;				   $sTextAlign	 - [optional] Location of text within marquee.  Options 'center', 'left', 'right', 'top', 'middle', 'bottom'.
;									Use in conjunction with $sDirection = 'up'/'down' to scroll text at 'left', 'center' or 'right'
;									Use in conjunction with $sDirection = 'left'/'right'/'center' to place text vertically at 'top', 'middle' or 'bottom'
;									(Default = center/middle {depending on function}, -1 = leave unchanged)
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1 - @extended set to index of parameter with error
; Author ........: Melba23
; Modified.......: TechCoder (added $sTextAlign, 'center' direction option)
; Related .......: Other _GUICtrlMarquee functions
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_SetScroll($iIndex, $iLoop = Default, $sMove = Default, $sDirection = Default, $iScroll = Default, $iDelay = Default, $sTextAlign = Default)

	; Errorcheck and set parameters
	Switch $iIndex
		Case 1 To $aMarquee_Params[0][0]
			$iIndex = Int($iIndex)
		Case Else
			Return SetError(1, 1, 0)
	EndSwitch

	Switch $iLoop
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][2] = $aMarquee_Params[0][2]
		Case Else
			If IsNumber($iLoop) Then
				$aMarquee_Params[$iIndex][2] = Int(Abs($iLoop))
			Else
				Return SetError(1, 2, 0)
			EndIf
	EndSwitch

	Switch $sMove
		Case -1
			; No change
		Case 'scroll', 'alternate', 'slide'
			$aMarquee_Params[$iIndex][3] = $sMove
		Case Default
			$aMarquee_Params[$iIndex][3] = $aMarquee_Params[0][3]
		Case Else
			Return SetError(1, 3, 0)
	EndSwitch

	Switch $sDirection
		Case -1
			; No change
		Case 'left', 'right', 'up', 'down', 'center'
			$aMarquee_Params[$iIndex][4] = $sDirection
		Case Default
			$aMarquee_Params[$iIndex][4] = $aMarquee_Params[0][4]
		Case Else
			Return SetError(1, 4, 0)
	EndSwitch

	Switch $iScroll
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][5] = $aMarquee_Params[0][5]
		Case Else
			If IsNumber($iScroll) Then
				$aMarquee_Params[$iIndex][5] = Int(Abs($iScroll))
			Else
				Return SetError(1, 5, 0)
			EndIf
	EndSwitch

	Switch $iDelay
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][6] = $aMarquee_Params[0][6]
		Case Else
			If IsNumber($iDelay) Then
				$aMarquee_Params[$iIndex][6] = Int(Abs($iDelay))
			Else
				Return SetError(1, 6, 0)
			EndIf
	EndSwitch

	Switch $sTextAlign
		Case -1
			; No change
		Case 'top', 'middle', 'bottom', 'left', 'center','right'
			$aMarquee_Params[$iIndex][15] = $sTextAlign
		Case Default
			$aMarquee_Params[$iIndex][15] = $aMarquee_Params[0][15]
		Case Else
			Return SetError(1, 15, 0)
	EndSwitch

	Return 1

EndFunc   ;==>_GUICtrlMarquee_SetScroll

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_SetDisplay
; Description ...: Sets display parameters for subsequent _GUICtrlCreateMarquee calls
; Syntax.........: _GUICtrlMarquee_SetDisplay($iIndex, [$iBorder, [$vTxtCol, [$vBkCol, [$iPixels, [$sFont, [$sBdrStyle]]]]]])
; Parameters ....: $iIndex  - Index of marquee returned by _GUICtrlMarquee_Init
;                  $iBorder - [optional] 0 = None (Default), 1 = 1 pixel, 2 = 2 pixel, 3 = 3 pixel (-1 = no change)
;                  $vTxtCol - [optional] Colour for text (Default = system colour, -1 = no change)
;                  $vBkCol  - [optional] Colour for Marquee (Default = system colour, -1 = no change)
;                             Colour can be passed as RGB value or as one of the following strings:
;                                'black', 'gray', 'white', 'silver', 'maroon', 'red', 'purple', 'fuchsia',
;                                'green', 'lime', 'olive', 'yellow', 'navy', 'blue', 'teal', 'aqua'
;                  $iPixels  - [optional] Font size (Default = 12, -1 = unchanged) Default font size is in 'points'
;								To fully control your font properties, set this to -1 and use $sFont property
;                  $sFont   - [optional] Font to use (Default = Tahoma, -1 = unchanged)
;				   				'font-style', 'font-variant', 'font-weight', 'font-size', 'line-height' and 'font-family'
;								can all be set in this property when $iPixels = -1 (see 15.8 of W3C Recommendations
;								http://www.w3.org/TR/CSS2/fonts.html#font-size-props
;				   $sBdrStyle - [optional] Border style as per http://www.w3.org/TR/CSS2/box.html#border-properties
;			                  (Default = 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset')
;				   $vBdrCol - [optional] Border color (Default and colors are the same as $vBkCol and $vTxtCol)
; Return values .: Success - Returns 0
;                  Failure - Returns 0 and sets @error to 1 - @extended set to index of parameter with error
; Author ........: Melba23
; Modified.......: TechCoder (added $sBdrStyle and $vBdrCol, changed $iPoint to $iPixels to use pixels)
; Remars.........: Font properties allowed according to 15.8 of W3C Recommendation
; Related .......: Other _GUICtrlMarquee functions, http://www.w3.org
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_SetDisplay($iIndex, $iBorder = Default, $vTxtCol = Default, $vBkCol = Default, $iPixels = Default, $sFont = Default, $sBdrStyle = Default, $vBdrCol = Default)

	; Errorcheck and set parameters
	Switch $iIndex
		Case 1 To $aMarquee_Params[0][0]
			$iIndex = Int($iIndex)
		Case Else
			Return SetError(1, 1, 0)
	EndSwitch

	Switch $iBorder
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][7] = $aMarquee_Params[0][7]
		Case 'thin', 'medium', 'thick'
			$aMarquee_Params[$iIndex][7] = $iBorder
		Case Else
			If StringIsInt($iBorder) Then
				$aMarquee_Params[$iIndex][7] = Int($iBorder)
			Else
				Return SetError(1, 7, 0)
			EndIf
	EndSwitch

	Switch $vTxtCol
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][8] = $aMarquee_Params[0][8]
		Case Else
			If IsNumber($vTxtCol) And ($vTxtCol >= 0 And $vTxtCol <= 0xFFFFFF) Then
				$aMarquee_Params[$iIndex][8] = Int($vTxtCol)
			Else
				$aMarquee_Params[$iIndex][8] = $vTxtCol
			EndIf
	EndSwitch

	Switch $vBkCol
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][9] = $aMarquee_Params[0][9]
		Case Else
			If IsNumber($vBkCol) And ($vBkCol >= 0 And $vBkCol <= 0xFFFFFF) Then
				$aMarquee_Params[$iIndex][9] = Int($vBkCol)
			Else
				$aMarquee_Params[$iIndex][9] = $vBkCol
			EndIf
	EndSwitch

	Switch $iPixels
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][10] = $aMarquee_Params[0][10] & "pt"
		Case Else
			If IsNumber($iPixels) Then
				$aMarquee_Params[$iIndex][10] = Int(Abs($iPixels)) & "pt"
			Else
				Return SetError(1, 10, 0)
			EndIf
	EndSwitch

	Switch $sFont
		Case ""
			; No change
		Case Default
			$aMarquee_Params[$iIndex][11] = $aMarquee_Params[0][11]
		Case Else
			If $iPixels = -1 then $iPixels = ''
			If IsString($sFont) Then
				$aMarquee_Params[$iIndex][11] = $sFont
			Else
				Return SetError(1, 11, 0)
			EndIf
	EndSwitch

	; Set Border Style
	Switch $sBdrStyle
		Case ""
			; do nothing
		Case Default
			$aMarquee_Params[$iIndex][13] = $aMarquee_Params[0][13]
		Case Else
			$aMarquee_Params[$iIndex][13] = $sBdrStyle
	EndSwitch

	Switch $vBdrCol
		Case -1
			; No change
		Case Default
			$aMarquee_Params[$iIndex][14] = $aMarquee_Params[0][14]
		Case Else
			If IsNumber($vBdrCol) And ($vBdrCol >= 0 And $vBdrCol <= 0xFFFFFF) Then
				$aMarquee_Params[$iIndex][14] = Int($vBdrCol)
			Else
				$aMarquee_Params[$iIndex][14] = $vBdrCol
			EndIf
	EndSwitch

	Return 1

EndFunc   ;==>_GUICtrlMarquee_SetDisplay

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_Create
; Description ...: Creates a marquee control
; Syntax.........: _GUICtrlMarquee_Create($iIndex, $sText, $iLeft, $iTop, $iWidth, $iHeight, [$sTipText])
; Parameters ....: $iIndex  - Index of marquee returned by _GUICtrlMarquee_Init
;                  $sText   - The text (or HTML markup) the marquee should display.
;                  $iLeft   - The left side of the control.
;                  $iTop    - The top of the control.
;                  $iWidth  - The width of the control.
;                  $iHeight - The height of the control.
;                  $sTipTxt - [optional] Tip text displayed when mouse hovers over the control.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error as follows
;                                    1 = Invalid index
;                                    2 = Index already used
;                                    3 = Failed to create object
;                                    4 = Failed to embed object
; Author ........: james3mg, trancexx and jscript "FROM BRAZIL"
; Modified.......: Melba23, TechCoder (border style and color, text align, font)
; Remarks .......: This function attempts to embed an 'ActiveX Control' or a 'Document Object' inside the GUI.
;                  The GUI functions GUICtrlRead and GUICtrlSet have no effect on this control. The object can only be
;                  controlled using other _GUICtrlMarquee functions
; Related .......: Other _GUICtrlMarquee functions
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_Create($iIndex, $sText, $iLeft, $iTop, $iWidth, $iHeight, $sTipText = "")

	; Errorcheck index
	Switch $iIndex
		Case 1 To $aMarquee_Params[0][0]
			$iIndex = Int($iIndex)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	; Check not previously created
	If $aMarquee_Params[$iIndex][1] <> "" Then
		Return SetError(2, 0, 0)
	EndIf

	; Store text
	$aMarquee_Params[$iIndex][12] = StringReplace($sText," ","&nbsp;")

	; Calculate the top margin (force marquee down for 'middle' and 'bottom' alignment)
	Local $iTopMargin,$iVSpace
	Switch $aMarquee_Params[$iIndex][15]
		Case 'top'
			$iTopMargin = 0
		Case 'middle',Default
			$iTopMargin = $iHeight/2 - $aMarquee_Params[$iIndex][10] + ($aMarquee_Params[$iIndex][10]/3)
		Case 'bottom'
			$iTopMargin = $iHeight - ($aMarquee_Params[$iIndex][10] + ($aMarquee_Params[$iIndex][10]/3))
		case Else
			$iTopMargin = 0
	EndSwitch

	; handle 'Center' Direction button (no up/down/left/right scrolling)
	If $aMarquee_Params[$iIndex][4] = 'center' then
		; create a 'no scroll' (banner) display
		$aMarquee_Params[$iIndex][2] = 1
		$aMarquee_Params[$iIndex][3] = 'slide'
		$aMarquee_Params[$iIndex][4] = 'up'
		$aMarquee_Params[$iIndex][5] = 1000000
		$aMarquee_Params[$iIndex][6] = 0
		$aMarquee_Params[$iIndex][15] = 'center'
		$iVSpace = $iTopMargin
		$iTopMargin=0
	Else

	EndIf

	; Create marquee
	$oShell = ObjCreate("Shell.Explorer.2")
	If Not IsObj($oShell) Then
		Return SetError(3, 0, 0)
	Else
		$aMarquee_Params[$iIndex][1] = $oShell
	EndIf
	$aMarquee_Params[$iIndex][0] = GUICtrlCreateObj($oShell, $iLeft, $iTop, $iWidth, $iHeight)
	If $aMarquee_Params[$iIndex][0] = 0 Then
		Return SetError(4, 0, 0)
	EndIf

	; Wait for marquee to be created
	$oShell.navigate("about:blank")
	While $oShell.busy
		Sleep(100)
	WEnd

	; Add marquee content
	With $oShell.document
		.write('<style>marquee{cursor: default;text-align:' & $aMarquee_Params[$iIndex][15] & ';}></style>')
		.write('<body onselectstart="return false" oncontextmenu="return false" onclick="return false" ondragstart="return false" ondragover="return false">')
		.writeln('<marquee width=100% height=100% truespeed onfinish="return true"')
		.writeln("loop=" & $aMarquee_Params[$iIndex][2])
		.writeln("behavior=" & $aMarquee_Params[$iIndex][3])
		.writeln("direction=" & $aMarquee_Params[$iIndex][4])
		.writeln("scrollamount=" & $aMarquee_Params[$iIndex][5])
		.writeln("scrolldelay=" & $aMarquee_Params[$iIndex][6])
		.writeln("vspace = " & $iVSpace)
		.write(">")
		.write($aMarquee_Params[$iIndex][12])
		.body.title = $sTipText
		.body.topmargin = $iTopMargin
		.body.leftmargin = 0
		.body.scroll = "no"
		.body.style.color = $aMarquee_Params[$iIndex][8]
		.body.bgcolor = $aMarquee_Params[$iIndex][9]
		.body.style.font= $aMarquee_Params[$iIndex][10] & " " & $aMarquee_Params[$iIndex][11]
		.body.style.border = $aMarquee_Params[$iIndex][7] & " " & $aMarquee_Params[$iIndex][13] & " " & $aMarquee_Params[$iIndex][14]
	EndWith



EndFunc   ;==>_GUICtrlMarquee_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_Delete
; Description ...: Deletes a marquee control
; Syntax.........: _GUICtrlMarquee_Delete($iIndex)
; Parameters ....: $iIndex - Index of marquee returned by _GUICtrlMarquee_Init
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1
; Author ........: Melba23
; Modified.......:
; Remarks .......:
; Related .......: Other _GUICtrlMarquee functions
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_Delete($iIndex)

	; Errorcheck index
	Switch $iIndex
		Case 1 To $aMarquee_Params[0][0]
			$iIndex = Int($iIndex)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	; Remove that entry from the array
	GUICtrlDelete($aMarquee_Params[$iIndex][0])
	For $i = $iIndex To $aMarquee_Params[0][0] - 1
		For $j = 0 To UBound($aMarquee_Params, 2) - 1
			$aMarquee_Params[$i][$j] = $aMarquee_Params[$i + 1][$j]
		Next
	Next
	ReDim $aMarquee_Params[$aMarquee_Params[0][0]][16]
	$aMarquee_Params[0][0] -= 1

	; Redraw the other marquees
	For $i = 1 To $aMarquee_Params[0][0]
		_GUICtrlMarquee_Reset($i)
	Next

EndFunc   ;==>_GUICtrlMarquee_Delete

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMarquee_Reset
; Description ...: Resets a marquee control to current parameters
; Syntax.........: _GUICtrlMarquee_Reset($iIndex, $sText)
; Parameters ....: $iIndex - Index of marquee returned by _GUICtrlMarquee_Init
;                  $sText  - The text (or HTML markup) the marquee should display (Default leaves text unchanged)
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error as follows
;                                    1 = Invalid index
;                                    2 = Invalid object reference
; Author ........: rover
; Modified.......: Melba23, TechCoder
; Remarks .......:
; Related .......: Other _GUICtrlMarquee functions
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GUICtrlMarquee_Reset($iIndex, $sText = Default)

	; Errorcheck index
	Switch $iIndex
		Case 1 To $aMarquee_Params[0][0]
			$iIndex = Int($iIndex)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	; Retrieve object reference
	$oShell = $aMarquee_Params[$iIndex][1]
	If Not IsObj($oShell) Then
		Return SetError(2, 0, 0)
	EndIf

	If $sText <> Default Then
		$aMarquee_Params[$iIndex][12] = $sText
	EndIf

	$oShell.document.body.innerHTML = '<style>marquee{cursor: default;text-align:' & $aMarquee_Params[$iIndex][15] & ';}></style>' & _
			'<body onselectstart="return false" oncontextmenu="return false" onclick="return false" ' & _
			'ondragstart="return false" ondragover="return false"> ' & _
			'<marquee width=100% height=100% truespeed' & "loop=" & $aMarquee_Params[$iIndex][2] & _
			" behavior=" & $aMarquee_Params[$iIndex][3] & _
			" direction=" & $aMarquee_Params[$iIndex][4] & _
			" scrollamount=" & $aMarquee_Params[$iIndex][5] & _
			" scrolldelay=" & $aMarquee_Params[$iIndex][6] & _
			" vspace = " & $iVSpace & _
			">" & $aMarquee_Params[$iIndex][12]

	With $oShell.document
		.body.title = $sTipText
		.body.topmargin = $iTopMargin
		.body.leftmargin = 0
		.body.scroll = "no"
		.body.style.color = $aMarquee_Params[$iIndex][8]
		.body.bgcolor = $aMarquee_Params[$iIndex][9]
		.body.style.font= $aMarquee_Params[$iIndex][10] & " " & $aMarquee_Params[$iIndex][11]
		.body.style.border = $aMarquee_Params[$iIndex][7] & " " & $aMarquee_Params[$iIndex][13] & " " & $aMarquee_Params[$iIndex][14]
	EndWith

	Return 1

EndFunc   ;==>_GUICtrlMarquee_Reset
