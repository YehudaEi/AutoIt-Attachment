#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	Local $hGUI = GUICreate('Marquee Example', 250, 120)
	Local $iScroll = _ScrollingCredits('AutoIt v3 is a freeware BASIC-like scripting language designed for automating the Windows GUI and general scripting.', _
			10, 10, 230, 100, 'About ' & @ScriptName)
	GUISetState(@SW_SHOW, $hGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd

	GUICtrlDelete($iScroll) ; Delete the scrolling credits control.
	GUIDelete($hGUI) ; Delete the GUI.
EndFunc   ;==>Example

; #FUNCTION# ====================================================================================================================
; Name ..........: _ScrollingCredits
; Description ...: Create a scrolling credits control.
; Syntax ........: _ScrollingCredits($sText, $iLeft, $iTop, $iWidth, $iHeight[, $sTipText = ""[, $iDirection = 1[,
;                  $fCenter = 0[, $sFontFamily = "Ms Shell"[, $iFontSize = 14]]]]])
; Parameters ....: $sText - Text string of the credits.
;                  $iLeft - The left side position of the control.
;                  $iTop - The top position of the control.
;                  $iWidth - The width of the control.
;                  $iHeight - The height of the control.
;                  $sTipText - [optional] Text string to be shown when the user hovers over the control. Default is "".
;                  $iDirection - [optional] Direction of the scrolling credits. 1 = bottom to top & 2 = top to bottom. Default is 1.
;                  $fCenter - [optional] Center the text string. True =  center the text string or False = position to the left side. Default is False.
;                  $sFontFamily - [optional] Font family name. Default is "Ms Shell".
;                  $iFontSize - [optional] Size of the font. Default is 14.
; Return values .: ID returned by ObjCreate or returns -1 and sets @error to non-zero.
; Author ........: guinness
; Modified ......:
; Remarks .......: I used Melba's Marquee UDF for inspiration. [http://www.autoitscript.com/forum/topic/103904-info-bar-like-tickertape/page__p__735769#entry735769]
;                  WinAPI.au3 & WindowsConstants.au3 should be included at the top of the script.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ScrollingCredits($sText, $iLeft, $iTop, $iWidth, $iHeight, $sTipText = '', $iDirection = 1, $fCenter = False, $sFontFamily = 'Ms Shell', $iFontSize = 14)
	Local $sCenterEnd = '', $sCenterStart = '', $sDirection = 'up'

	If $fCenter = Default Then
		$fCenter = 0
	EndIf
	If $iDirection = Default Then
		$iDirection = 1
	EndIf
	If $iFontSize = Default Then
		$iFontSize = 14
	EndIf
	If $sFontFamily = Default Then
		$sFontFamily = 'Ms Shell'
	EndIf
	If $fCenter Then
		$sCenterStart = '<center>'
		$sCenterEnd = '</center>'
	EndIf
	If $iDirection > 1 Then
		$sDirection = 'down'
	EndIf

	$sText = StringRegExpReplace($sText, '\r\n|\r|\n', '<br>') ; Replace @CRLF, @CR & @LF with <br>.
	Local $oShellObject = ObjCreate('Shell.Explorer.2')
	If IsObj($oShellObject) = 0 Then
		Return SetError(1, 0, -1)
	EndIf

	Local $iControlObject = GUICtrlCreateObj($oShellObject, $iLeft, $iTop, $iWidth, $iHeight)
	$oShellObject.navigate('about:blank')
	While $oShellObject.busy
		Sleep(100)
	WEnd

	With $oShellObject.document
		.write('<style>marquee{cursor: default}></style>')
		.write('<body onselectstart="return false" oncontextmenu="return false" onclick="return false" ondragstart="return false" ondragover="return false">')
		.writeln('<marquee width=100% height=100%')
		.writeln('loop="0"')
		.writeln('behavior="scroll"')
		.writeln('direction="' & $sDirection & '"')
		.writeln('scrollamount="2"')
		.writeln('scrolldelay="8"')
		.write('>')
		.writeln($sCenterStart)
		.write($sText)
		.writeln($sCenterEnd)
		.writeln('</marquee>')
		.body.title = $sTipText
		.body.topmargin = 0
		.body.leftmargin = 0
		.body.scroll = 'no'
		.body.style.backgroundColor = Hex(_WinAPI_GetSysColor($COLOR_MENU), 6)
		.body.style.color = Hex(_WinAPI_GetSysColor($COLOR_WINDOWTEXT), 6)
		.body.style.borderWidth = 0
		.body.style.fontFamily = $sFontFamily
		.body.style.fontSize = $iFontSize
	EndWith
	Return $iControlObject
EndFunc   ;==>_ScrollingCredits