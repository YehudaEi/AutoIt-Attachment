;===============================================================================
;
; Description:      Functions to create/update gradient-filled, colored progress
;					bar.
;
; Syntax:           _GProgressOn($sTitle, $hxStartColor, $hxEndColor,
;						$sMainText = "Progress Bar", $sSubText = "",
;						$iXpos = "", $iYpos = "", $iOntop = 0)
;
;					_GProgressSet($iProgress, $sMainText = "", $sSubText = "")
;
;					_GProgressOff()
;
;					_GUICtrlCreateGProgress($hxStartColor, $hxEndColor, $iXpos,
;						$iYpos, $iWidth, $iHeight)
;
;					_GuiCtrlSetGProgress($gBar, $sWindowTitle, $iProgress)
;
;
; Usage(s):			The first group of functions act like ProgressOn(),
;					ProgressSet() and ProgressOff(), albeit with different
;					parameters for colors.  The second group of functions act
;					like the GuiCtrlCreateProgress() and GuiCtrlSetData()
;					functions, again with different parameters.  See examples.
;
;					IMPORTANT NOTE: one bar at a time, please.
;
; Parameter(s):     Parameters are self-explanatory.  Read function's arguments.
;					Parameter notes: Colors must be passed like 0x000000 without
;					quotes.  Also, $iProgress only accepts numbers between 0-100.
;
; Requirement(s):   AutoIt
;
; Author(s):        matthew <syberschmo on forums>
;
;===============================================================================

;INCLUDES
#include <GUIConstants.au3>
#include <color.au3>
#include <array.au3>

;VARIABLE DECLARATIONS
Global $lbl_grad_cover
Global $lbl_grad_main
Global $lbl_grad_sub
Global $gprog_form

Func _GProgressOn($sTitle, $hxStartColor, $hxEndColor, $sMainText = "Progress Bar", $sSubText = "", $iXpos = "", $iYpos = "", $iOntop = 0)
	Local $form, $i, $sColor
	
	;Color and Step Variables used to draw the gradient.
	Local $color1R = _ColorGetRed($hxStartColor)
	Local $color1G = _ColorGetGreen($hxStartColor)
	Local $color1B = _ColorGetBlue($hxStartColor)
	Local $nStepR = (_ColorGetRed($hxEndColor) - $color1R) / 200
	Local $nStepG = (_ColorGetGreen($hxEndColor) - $color1G) / 200
	Local $nStepB = (_ColorGetBlue($hxEndColor) - $color1B) / 200
	
	;Set default positions at the center
	If $iXpos = "" Then $iXpos = (@DesktopWidth / 2 - 225 / 2)
	If $iYpos = "" Then $iYpos = (@DesktopHeight / 2 - 75 / 2)
	
	;Draw the main GUI
	If $iOntop <> 0 Then
		$gprog_form = GUICreate($sTitle, 225, 75, $iXpos, $iYpos, BitOR($WS_CAPTION, $WS_VISIBLE, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE, $WS_EX_TOPMOST))
	Else
		$gprog_form = GUICreate($sTitle, 225, 75, $iXpos, $iYpos, BitOR($WS_CAPTION, $WS_VISIBLE, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))
	EndIf
	
	;Main Text goes here. GUICtrlSetFont to change style of main text.
	$lbl_grad_main = GUICtrlCreateLabel($sMainText, 10, 5, 200, 21)
	GUICtrlSetFont($lbl_grad_main, 10, 600)
	
	;Sub Text goes here.
	$lbl_grad_sub = GUICtrlCreateLabel($sSubText, 10, 53, 200, 21)
	
	;Blank cover label used to create the illusion of increments
	$lbl_grad_cover = GUICtrlCreateLabel("", 10, 30, 201, 21)
	
	;Create the gradient bar
	GUICtrlCreateGraphic(10, 30, 201, 20, $SS_SUNKEN)
	For $i = 0 To 199
		$sColor = "0x" & StringFormat("%02X%02X%02X", $color1R + $nStepR * $i, $color1G + $nStepG * $i, $color1B + $nStepB * $i);Format the color used for this line of the gradient
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $sColor, 0xffffff);set color for a single line in the gradient
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $i, 0);move drawing cursor to top of graphic box, to the right of the last line drawn
		GUICtrlSetGraphic(-1, $GUI_GR_LINE, $i, 17);draw a straight line from the top of the graphic to the bottom
	Next
	
	GUISetState(@SW_SHOW)
	
EndFunc   ;==>_GProgressOn

Func _GProgressSet($iProgress, $sMainText = "", $sSubText = "")
	Local $cmtxt, $cstxt

	If $iProgress >= 0 And $iProgress <= 100 Then
		$iProgress = $iProgress / 100
	Else
		SetError(1)
		Return
	EndIf
	
	;To reduce label flickering, only update the main text and the sub text if they change
	$cmtxt = GUICtrlRead($lbl_grad_main)
	$cstxt = GUICtrlRead($lbl_grad_sub)
	
	If ($sMainText <> "") And ($sMainText <> $cmtxt) Then GUICtrlSetData($lbl_grad_main, $sMainText)
	If ($sSubText <> "") And ($sSubText <> $cstxt) Then GUICtrlSetData($lbl_grad_sub, $sSubText)
	
	ControlMove($gprog_form, "", $lbl_grad_cover, 10 + ($iProgress * 201), 30, 201 - ($iProgress * 201), 21)
	
EndFunc   ;==>_GProgressSet

Func _GProgressOff()
	GUICtrlDelete($lbl_grad_cover)
	GUICtrlDelete($lbl_grad_main)
	GUICtrlDelete($lbl_grad_sub)
	GUICtrlDelete($gprog_form)
	GUIDelete($gprog_form)
EndFunc   ;==>_GProgressOff

Func _GUICtrlCreateGProgress($hxStartColor, $hxEndColor, $iXpos, $iYpos, $iWidth, $iHeight)
	Local $i, $sColor
	
	;Everything works better if the width is odd
	If Mod($iWidth, 2) = 0 Then $iWidth += 1
	
	;Color and Step Variables used to draw the gradient.
	Local $color1R = _ColorGetRed($hxStartColor)
	Local $color1G = _ColorGetGreen($hxStartColor)
	Local $color1B = _ColorGetBlue($hxStartColor)
	Local $nStepR = (_ColorGetRed($hxEndColor) - $color1R) / $iWidth
	Local $nStepG = (_ColorGetGreen($hxEndColor) - $color1G) / $iWidth
	Local $nStepB = (_ColorGetBlue($hxEndColor) - $color1B) / $iWidth
	
	;Blank cover label used to create the illusion of increments
	$lbl_grad_GUI_cover = GUICtrlCreateLabel("", $iXpos, $iYpos, $iWidth, ($iHeight + 1))
	
	;Create the gradient bar
	GUICtrlCreateGraphic($iXpos, $iYpos, $iWidth, $iHeight, $SS_SUNKEN)
	For $i = 0 To $iWidth - 1
		$sColor = "0x" & StringFormat("%02X%02X%02X", $color1R + $nStepR * $i, $color1G + $nStepG * $i, $color1B + $nStepB * $i);Format the color used for this line of the gradient
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $sColor, 0xffffff);set color for a single line in the gradient
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $i, 0);move drawing cursor to top of graphic box, to the right of the last line drawn
		GUICtrlSetGraphic(-1, $GUI_GR_LINE, $i, ($iHeight - 3));draw a straight line from the top of the graphic to the bottom
	Next
	Return $lbl_grad_GUI_cover & @CR & $iXpos & @CR & $iYpos & @CR & $iWidth & @CR & $iHeight
	
EndFunc   ;==>_GUICtrlCreateGProgress

Func _GuiCtrlSetGProgress($gbar, $sWindowTitle, $iProgress)
	Local $tmp_arr
	
	If $iProgress >= 0 And $iProgress <= 100 Then
		$iProgress = $iProgress / 100
	Else
		SetError(1)
		Return
	EndIf
	
	$tmp_arr = StringSplit($gbar, @CR)
	If $tmp_arr[0] <> 5 Then
		SetError(1)
		Return
	EndIf

	;$o = ControlMove($sWindowTitle, "", Number($lbl_grad_GUI_cover), $iXpos+ ($iProgress * $iWidth), $iYpos, $iWidth- ($iProgress * $iWidth), $iHeight)
	$o = ControlMove($sWindowTitle, "", Number(StringStripWS($tmp_arr[1], 8)), StringStripWS($tmp_arr[2], 8) + ($iProgress * StringStripWS($tmp_arr[4], 8)), StringStripWS($tmp_arr[3], 8), StringStripWS($tmp_arr[4], 8) - ($iProgress * StringStripWS($tmp_arr[4], 8)), StringStripWS($tmp_arr[5], 8))
	
EndFunc   ;==>_GuiCtrlSetGProgress