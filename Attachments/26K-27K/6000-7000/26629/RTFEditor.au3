#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include "r2h.au3"
#include <Misc.au3>
#include <ComboConstants.au3>

Opt('MustDeclareVars', 1)
Global $oMyError, $send, $command, $bold = 0, $italic = 0, $underline = 0, $bullet = 0, $oRP, $form, $isItalic = 0, $isUnderline = 0, $isStike = 0, $isBold = 0
Global $bolds, $italics, $underlines, $bullets, $alignLeft, $alignCenter, $alignRight, $sizeList, $color, $SelectFont, $cf, $selFont, $selType
Local $oRP, $GUIActiveX, $msg

$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$oRP = ObjCreate("RICHTEXT.RichtextCtrl.1")
$form = GUICreate("Very Basic RTF Editor", 320, 300, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
$send = GUICtrlCreateButton('Submit', 0, 177, 60, 20)
$bolds = GUICtrlCreateLabel("B", 63, 177, 10, 20, $SS_NOtify)
$italics = GUICtrlCreateLabel("I", 73, 177, 10, 20, $SS_NOtify)
$underlines = GUICtrlCreateLabel("U", 83, 177, 10, 20, $SS_NOtify)
$bullets = GUICtrlCreateLabel("*", 93, 177, 20, 10, $SS_NOtify)
$alignLeft = GUICtrlCreateButton("[<--]", 113, 177, 30, 20)
$alignCenter = GUICtrlCreateButton("[<-->]", 143, 177, 30, 20)
$alignRight = GUICtrlCreateButton("[-->]", 173, 177, 30, 20)
$sizeList = GUICtrlCreateCombo("Size", 203, 177, 55, 149)
GUICtrlSetData(-1, "8|10|12|14|16|18|20|22|24|26|28|30")
$color = GUICtrlCreateButton("Back", 258, 177, 30, 20)
$SelectFont = GUICtrlCreateLabel("Font", 289, 177, 55, 149, $SS_NOtify)
$GUIActiveX = GUICtrlCreateObj($oRP, 10, 10, 400, 260)
GUICtrlSetPos($GUIActiveX, 10, 10, 300, 160)

With $oRP; Object tag pool
	.OLEDrag()
	.Font = 'Arial'
	.SelColor = 0xFFFFFF
	.BackColor = 0x444444
EndWith

GUISetState();Show GUI

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $send
			FileDelete(@TempDir & "\r2h.rtf")
			FileDelete(@TempDir & "\r2h.html")
			FileWrite(@TempDir & "\r2h.rtf", $oRP.TextRTF)
			$code = r2h(@TempDir & "\r2h.rtf", @TempDir & "\r2h.html")
		Case $SelectFont
			SelectRTFColor($oRP)
		Case $color
			$cf = _ChooseColor(0, 255, 0, $form)
			If $cf = -1 Then
			Else
				$oRP.BackColor = $cf
			EndIf
		Case $alignLeft
			$oRP.selalignment = 0 ; Left
		Case $alignRight
			$oRP.selalignment = 1 ; Right
		Case $alignCenter
			$oRP.selalignment = 2 ; Center
		Case $bolds
			If $bold = 0 Then
				$oRP.SelBold = True
				$bold = 1
				GUICtrlSetFont($bolds, 8.5, 700)
			ElseIf $bold = 1 Then
				$oRP.SelBold = False
				$bold = 0
				GUICtrlSetFont($bolds, 8.5, 400)
			EndIf
		Case $italics
			If $italic = 0 Then
				$oRP.SelItalic = True
				$italic = 1
				GUICtrlSetFont($italics, 8.5, 700)
			ElseIf $italic = 1 Then
				$oRP.SelItalic = False
				$italic = 0
				GUICtrlSetFont($italics, 8.5, 400)
			EndIf
		Case $underlines
			If $underline = 0 Then
				$oRP.SelUnderline = True
				$underline = 1
				GUICtrlSetFont($underlines, 8.5, 700)
			ElseIf $underline = 1 Then
				$oRP.SelUnderline = False
				$underline = 0
				GUICtrlSetFont($underlines, 8.5, 400)
			EndIf
		Case $bullets
			If $bullet = 0 Then
				$oRP.SelBullet = True
				$bullet = 1
				GUICtrlSetFont($bullets, 8.5, 700)
			ElseIf $bullet = 1 Then
				$oRP.SelBullet = False
				$bullet = 0
				GUICtrlSetFont($bullets, 8.5, 400)
			EndIf
		Case $sizeList
			If GUICtrlRead($sizeList) = "Size" Then
			Else
				$oRP.selfontsize = GUICtrlRead($sizeList)
			EndIf



	EndSwitch
WEnd
GUIDelete()

Func MyErrFunc()

	MsgBox(0, "AutoItCOM Test", "We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext)

	Local $err = $oMyError.number
	If $err = 0 Then $err = -1

	SetError($err) ; to check for after this function returns
EndFunc   ;==>MyErrFunc

Func SelectRTFColor($oRP)
	$isBold = 400
	If $oRP.SelBold = 0 Then $isBold = 400
	If $oRP.SelBold = -1 Then $isBold = 700
	If $oRP.SelItalic = 0 Then $isItalic = False
	If $oRP.SelItalic = -1 Then $isItalic = True
	If $oRP.SelUnderline = 0 Then $isUnderline = False
	If $oRP.SelUnderline = -1 Then $isUnderline = True
	If $oRP.SelStrikeThru = 0 Then $isStike = False
	If $oRP.SelStrikeThru = -1 Then $isStike = True

	$selFont = _ChooseFont($oRP.SelFontName, $oRP.SelFontSize, $oRP.SelColor, $isBold, $isItalic, $isUnderline, $isStike, $form)
	If $selFont = -1 Then Return -1
	$selType = $selFont[1] ; attributes = BitOr of italic:2, undeline:4, strikeout:8
	If $selType = 0 And $selFont[4] = 400 Then
		$oRP.SelItalic = False
		$oRP.SelBold = False
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = False
	ElseIf $selType = 0 And $selFont[4] = 700 Then
		$oRP.SelItalic = False
		$oRP.SelBold = True
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = False
	ElseIf $selType = 2 And $selFont[4] = 400 Then
		$oRP.SelItalic = True
		$oRP.SelBold = False
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = False
	ElseIf $selType = 2 And $selFont[4] = 700 Then
		$oRP.SelItalic = True
		$oRP.SelBold = True
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = False
	ElseIf $selType = 4 And $selFont[4] = 400 Then
		$oRP.SelItalic = False
		$oRP.SelBold = False
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = True
	ElseIf $selType = 4 And $selFont[4] = 700 Then
		$oRP.SelItalic = False
		$oRP.SelBold = True
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = True
	ElseIf $selType = 6 And $selFont[4] = 400 Then
		$oRP.SelItalic = True
		$oRP.SelBold = False
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = True
	ElseIf $selType = 6 And $selFont[4] = 700 Then
		$oRP.SelItalic = True
		$oRP.SelBold = True
		$oRP.SelStrikethru = False
		$oRP.SelUnderline = True
	ElseIf $selType = 8 And $selFont[4] = 400 Then
		$oRP.SelItalic = False
		$oRP.SelBold = False
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = False
	ElseIf $selType = 8 And $selFont[4] = 700 Then
		$oRP.SelItalic = False
		$oRP.SelBold = True
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = False
	ElseIf $selType = 10 And $selFont[4] = 400 Then
		$oRP.SelItalic = True
		$oRP.SelBold = False
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = False
	ElseIf $selType = 10 And $selFont[4] = 700 Then
		$oRP.SelItalic = True
		$oRP.SelBold = True
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = False
	ElseIf $selType = 12 And $selFont[4] = 400 Then
		$oRP.SelItalic = False
		$oRP.SelBold = False
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = True
	ElseIf $selType = 12 And $selFont[4] = 700 Then
		$oRP.SelItalic = False
		$oRP.SelBold = True
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = True
	ElseIf $selType = 14 And $selFont[4] = 400 Then
		$oRP.SelItalic = True
		$oRP.SelBold = False
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = True
	ElseIf $selType = 14 And $selFont[4] = 700 Then
		$oRP.SelItalic = True
		$oRP.SelBold = True
		$oRP.SelStrikethru = True
		$oRP.SelUnderline = True
	EndIf
	$oRP.SelFontName = $selFont[2] ; fontname
	$oRP.SelFontSize = $selFont[3] ; font size = point size
	If $selFont[4] = 700 Then
		$oRP.SelBold = True
	ElseIf $selFont[4] = 400 Then
		$oRP.SelBold = False
	EndIf
	$oRP.SelColor = $selFont[5] ; COLORREF rgbColors

EndFunc   ;==>SelectRTFColor