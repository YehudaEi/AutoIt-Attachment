#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

_Example()

Func _Example()
	Local $hForm, $iSearch1, $iSearch2

	$Form1 = GUICreate("Win7 search control simulation", 480, 340, -1, -1)

	$iSearch1 = _GUICtrlSearch_Create("", 77, 10, 290, 23, "Type your search...")
	$iSearch2 = _GUICtrlSearch_Create("", 10, 308, 290, 23, "Type your search...")

	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $iSearch1
				MsgBox(4096, "Read!", _GUICtrlSearch_Read($iSearch1))
				;_GUICtrlSearch_Delete($iSearch1)
			Case $iSearch2
				MsgBox(4096, "Read!", _GUICtrlSearch_Read($iSearch2))
				;_GUICtrlSearch_Delete($iSearch2)
		EndSwitch
	WEnd
EndFunc   ;==>_Example

Func _GUICtrlSearch_Create($sText, $iLeft, $iTop, $iWidth = -1, $iHeight = -1, $sTip = "", $sIconName = "")
	Local $iCtrlID, $iIco = -1, $iInput

	If $iWidth = -1 Then $iWidth = 100
	If $iHeight = -1 Then $iHeight = 23
	If $sIconName = "" Then
		$iIco = -23
		$sIconName = @SystemDir & "\shell32.dll"
	EndIf

	GUICtrlCreateLabel("", $iLeft, $iTop, $iWidth, $iHeight, $SS_GRAYFRAME + $WS_DISABLED)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	$iInput = GUICtrlCreateInput($sText, $iLeft + 3, $iTop + 4, $iWidth - 27, $iHeight - 8, -1, 0)
	If $sTip Then GUICtrlSendMsg($iInput, 0x1501, True, $sTip) ; $EM_SETCUEBANNER
	$iCtrlID = GUICtrlCreateIcon($sIconName, $iIco, $iLeft + $iWidth - 21, $iTop + 4, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	; To [Enter] key effect!
	Local $aAccelKeys[1][2] = [["{ENTER}", $iCtrlID]]
	GUISetAccelerators($aAccelKeys)
	;---
	Return $iCtrlID
EndFunc   ;==>_GUICtrlSearch_Create

Func _GUICtrlSearch_Delete($iCtrlID)
	GUICtrlDelete($iCtrlID - 2)
	GUICtrlDelete($iCtrlID - 1)
	Return GUICtrlDelete($iCtrlID)
EndFunc   ;==>_GUICtrlSearch_Delete

Func _GUICtrlSearch_Read($iCtrlID)
	Return GUICtrlRead($iCtrlID - 1)
EndFunc   ;==>_GUICtrlSearch_Read