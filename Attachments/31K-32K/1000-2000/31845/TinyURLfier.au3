#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.6.1
	Author:         Foxhound
	Script Function:
	Uses TinyURL to create Tiny links for your specified URL
#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
$MainGUI = GUICreate("TinyURLfier - By Foxhound", 420, 81)
$httpLabel = GUICtrlCreateLabel("http://www.", 19, 34, 62, 17)
$GenerateButton = GUICtrlCreateButton("Generate", 317, 28, 75, 25, $WS_GROUP)
$urlInput = GUICtrlCreateInput("yoururlhere.com/", 81, 30, 233, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
_pGUI()
Func _pGUI()
	While 1
		$nMsg = GUIGetMsg()
		If $nMsg == $GUI_EVENT_CLOSE Then Exit
		If $nMsg == $GenerateButton Then
			$link = _GetTinyLink(GUICtrlRead($urlInput))
			ClipPut($link)
			MsgBox(64, "TinyURLfier - By Foxhound", $link & @CRLF & "Copied to clipboard")
		EndIf
	WEnd
EndFunc   ;==>_pGUI
Func _GetTinyLink($link)
	If StringInStr($link, "http") <> 0 Then
		MsgBox(48, "TinyURLfier - By Foxhound", "Please make sure you do not include 'http://www.' in your link")
		Return ("Error")
	EndIf
	Local $url
	$url = "http://www." & $link ;For some reason tinyurl doesn't return a valid link unless "http://www." is added.
	$tURL = "http://tinyurl.com/api-create.php?url=" & $url
	$oHTTP.open("GET", $tURL)
	$oHTTP.send
	$url = $oHTTP.Responsetext
	Return ($url)
EndFunc   ;==>_GetTinyLink