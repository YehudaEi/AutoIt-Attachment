#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>

Global $iLeft, $iTop, $iRight, $iBottom

; Create the GUI
GUICreate("WorkArea", 210, 200)
GUICtrlCreateLabel("Pixel Amount:", 10, 10, 90, 20, $SS_RIGHT)
$Input = GUICtrlCreateInput("40", 110, 8, 90, 20)
$Reduce = GUICtrlCreateButton("Reduce", 10, 40, 90, 30)
$Increase = GUICtrlCreateButton("Increase", 110, 40, 90, 30)
$Reset = GUICtrlCreateButton("Reset", 10, 80, 190, 30)
$ListView = GUICtrlCreateListView("Left|Top|Right|Bottom", 10, 120, 190, 50)
$WorkArea = GUICtrlCreateListViewItem("", $ListView)
_GUICtrlListView_SetColumnWidth($ListView, 0, 33)
_GUICtrlListView_SetColumnWidth($ListView, 1, 33)
_GUICtrlListView_SetColumnWidth($ListView, 2, 60)
_GUICtrlListView_SetColumnWidth($ListView, 3, 60)
GUISetState(@SW_SHOW)
_GetDesktopWorkArea($iLeft, $iTop, $iRight, $iBottom)

; Loop until message received
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE ; Reset the work area to Desktop Width then close
			_SetDesktopWorkArea($iLeft, $iTop, @DesktopWidth, $iBottom)
			ExitLoop
		Case $msg = $Reduce ; Reduce the work area width by the amount in input box
			$Pixels = GUICtrlRead($Input)
			_SetDesktopWorkArea($iLeft, $iTop, $iRight-$Pixels, $iBottom)
			_GetDesktopWorkArea($iLeft, $iTop, $iRight, $iBottom)
		Case $msg = $Increase ; Increase the work area width by the amount in input box
			$Pixels = GUICtrlRead($Input)
			_SetDesktopWorkArea($iLeft, $iTop, $iRight+$Pixels, $iBottom)
			_GetDesktopWorkArea($iLeft, $iTop, $iRight, $iBottom)
		Case $msg = $Reset ; Reset the work area to Desktop Width
			_SetDesktopWorkArea($iLeft, $iTop, @DesktopWidth, $iBottom)
			_GetDesktopWorkArea($iLeft, $iTop, $iRight, $iBottom)
	EndSelect
WEnd

Func _GetDesktopWorkArea(ByRef $iLeft, ByRef $iTop, ByRef $iRight, ByRef $iBottom)
    Local Const $SPI_GETWORKAREA = 48
    Local $tStruct = DllStructCreate($tagRECT)
    If _WinAPI_SystemParametersInfo($SPI_GETWORKAREA, 0, DllStructGetPtr($tStruct)) Then
        $iLeft = DllStructGetData($tStruct, "Left")
        $iRight = DllStructGetData($tStruct, "Right")
        $iTop = DllStructGetData($tStruct, "Top")
        $iBottom = DllStructGetData($tStruct, "Bottom")
		GUICtrlSetData($WorkArea, $iLeft&"|"&$iTop&"|"&$iRight&"|"&$iBottom)
        Return True
    EndIf
    Return False
EndFunc   ;==>_GetDesktopWorkArea

Func _SetDesktopWorkArea($iLeft, $iTop, $iRight, $iBottom)
    Local Const $SPI_SETWORKAREA = 47
	Local Const $SPIF_SENDWININICHANGE  = 0x2
    Local $tStruct = DllStructCreate($tagRECT)
    DllStructSetData($tStruct, "Left", $iLeft)
    DllStructSetData($tStruct, "Right", $iRight)
    DllStructSetData($tStruct, "Top", $iTop)
    DllStructSetData($tStruct, "Bottom", $iBottom)
    If _WinAPI_SystemParametersInfo($SPI_SETWORKAREA, 0, DllStructGetPtr($tStruct), $SPIF_SENDWININICHANGE) Then
        Return True
    EndIf
    Return False
EndFunc   ;==>_SetDesktopWorkArea