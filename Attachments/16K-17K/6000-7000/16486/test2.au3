#include <GUIConstants.au3>
#include "GUIEnhance.au3"

Opt("GUIOnEventMode", 1)
$iWinHeight = 460
$GUI = GUICreate("", 400, $iWinHeight)
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlCreateTab(5, 5, 390, 420)

GUICtrlCreateTabItem("Settings")
GUICtrlCreateLabel("Choose an option:", 15, 35)

$hOptionA = GUICtrlCreateRadio("Option A", 15, 50)
GUICtrlSetOnEvent(-1, "EventHandler")

$hOptionB = GUICtrlCreateRadio("Option B", 15, 70)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "EventHandler")

$hOptionC = GUICtrlCreateRadio("Option C", 15, 90)
GUICtrlSetOnEvent(-1, "EventHandler")

Global $hDefault = $hOptionB

GUICtrlCreateTabItem("")

$hWarnLabel = GUICtrlCreateLabel("You may want to add extra controls that aren't needed if box is unchecked", 5, 460)
GUICtrlSetState(-1, $GUI_HIDE)

$hClose = GUICtrlCreateButton("Close", 310, 430, 80, 25)
GUICtrlSetOnEvent(-1, "EventHandler")

$hApply = GUICtrlCreateButton("Apply", 310, 460, 80, 25)
GUICtrlSetOnEvent(-1, "EventHandler")

_GUIEnhanceAnimateWin ($GUI, 400, $GUI_EN_ANI_FADEIN)
GUISetState()

_GUIEnhanceAnimateTitle($GUI, "Configuration", $GUI_EN_TITLE_SLIDE)

Local $aiTemp[2] = [0, 0]
ClientToScreen($GUI, $aiTemp[0], $aiTemp[1])
Global $iBkColor = PixelGetColor($aiTemp[0], $aiTemp[1])

While 1
	Sleep(1000)
WEnd

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $hClose
			_GUIEnhanceAnimateWin ($GUI, 400, $GUI_EN_ANI_FADEOUT)
			Exit
		Case $hOptionA, $hOptionB, $hOptionC
			If @GUI_CtrlId <> $hDefault Then
				GUICtrlSetPos($hApply, Default, $iWinHeight)
				_GUIEnhanceCtrlDrift ($GUI, $hClose, 225, 430, 10)
				_GUIEnhanceCtrlDrift ($GUI, $hApply, 310, 430, 2)
			Else
				_GUIEnhanceCtrlDrift ($GUI, $hApply, 310, $iWinHeight, 2)
				_GUIEnhanceCtrlDrift ($GUI, $hClose, 310, 430, 10)
			EndIf
	EndSwitch
EndFunc   ;==>EventHandler

Func ClientToScreen($hwnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hwnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen