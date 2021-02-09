#include-once
#include <IE.au3>
#include <ProgressConstants.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: _CheckProxyList
; Description ...: Checks an online list of proxies
; Syntax.........: _CheckProxyList($sUrl[, $iTimeout = 450[, $iOffset = 1[, $sDelimeter = @CRLF[, $hProgress = 0]]])
; Parameters ....: $sUrl         - URL of the online proxy list
;                  $iOffset      - Line of the list to start at
;                  $sDelimeter   - Character to separate the valid proxies with
;                  $hProgress    - The handle of the progress bar you want to update
; Return values .: Success       - Returns the string with a list of the working proxies
;                  Failure       - Returns 0
; Author ........: zeffy
; Thanks ........; IchBistTod for math and error checking :)
; ===============================================================================================================================

Func _CheckProxyList($sUrl, $iTimeout = 450, $iOffset = 1, $sDelimeter = @CRLF, $hProgress = 0)

	$oIE = _IECreate($sUrl, 0, 0)
	If Not @error Then
		$sText = _IEBodyReadText($oIE)
		$aSplit = StringSplit(StringReplace($sText, @CR, ""), @LF)
		If $hProgress Then
			GUICtrlSetLimit($hProgress, 0, $aSplit[0])
		EndIf
		Local $sList
		For $iOffset To $aSplit[0]
			$sProxy = StringSplit($aSplit[$iOffset], ":")
			Ping($sProxy[1], $iTimeout)
			If Not @error Then
				$sList &= $aSplit[$iOffset] & $sDelimeter
			EndIf
			If $hProgress Then
				GUICtrlSetData($hProgress, Round((($iOffset / $aSplit[0]) * 100)))
			EndIf
		Next
		GUICtrlSetData($hProgress, 100)
		Return $sList
	EndIf
EndFunc   ;==>_CheckProxyList