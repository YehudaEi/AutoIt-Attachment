#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Misc.au3>

Opt("TrayIconDebug", 1)

; We use ESC to exit the temporary Combo
Opt("GUICloseOnESC", 0)

; Set flag to indicate double click in ListView
Global $fDblClk = False
; Declare global variables
Global $aLV_Click_Info, $hTmp_Combo = 0

; Open DLL for _IsPressed
$dll = DllOpen("user32.dll")

; Create GUI
$hGUI = GUICreate("Test", 400, 250)

$hListView = _GUICtrlListView_Create($hGUI, "Col 0|Col 1|Col 2", 10, 10, 242, 200)
_GUICtrlListView_AddItem($hListView, "Item 00",0)
_GUICtrlListView_AddSubItem($hListView, 0, "Item 01", 1)
_GUICtrlListView_AddSubItem($hListView, 0, "Item 02", 2)
_GUICtrlListView_AddItem($hListView, "Item 10",1)
_GUICtrlListView_AddItem($hListView, "Item 20",2)
_GUICtrlListView_AddItem($hListView, "Item 30",3)

GUISetState()

; Look for double clicks
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1

    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            DllClose($dll)
            Exit
    EndSwitch

    ; If a temporary combo exists
;~     If $hTmp_Combo <> 0 Then
;~         ; If ENTER pressed
;~         If _IsPressed("0D", $dll) Then
;~             ; Set label to edit content
;~             $sText = GUICtrlRead($hTmp_Combo)
;~             _GUICtrlListView_SetItemText($hListView, $aLV_Click_Info[0], $sText, $aLV_Click_Info[1])
;~             ; Delete temporary combo
;~             GUICtrlDelete($hTmp_combo)
;~             $hTmp_Combo = 0
;~             GUICtrlSetState($hListView, $GUI_ENABLE)
;~         EndIf
;~         ; If ESC pressed
;~         If _IsPressed("1B", $dll) Then
;~             ; Delete temporary combo
;~             GUICtrlDelete($hTmp_Combo)
;~             $hTmp_Combo = 0
;~             GUICtrlSetState($hListView, $GUI_ENABLE)
;~         EndIf
;~     EndIf

    ; If an item was double clicked
    If $fDblClk Then
        $fDblClk = False
        ; Delete an existing temporary combo
        GUICtrlDelete($hTmp_Combo)
        ; Get label position
        Switch $aLV_Click_Info[1]
            Case 0 ; On Item
                $aLV_Rect_Info = _GUICtrlListView_GetItemRect($hListView, $aLV_Click_Info[0], 2)
            Case Else ; On SubItem
                $aLV_Rect_Info = _GUICtrlListView_GetSubItemRect($hListView, $aLV_Click_Info[0], $aLV_Click_Info[1])
        EndSwitch
        ; Create temporary combo
        $hTmp_Combo = GUICtrlCreateCombo("", $aLV_Rect_Info[0] + 10, $aLV_Rect_Info[1] + 10, 100, $aLV_Rect_Info[3] - $aLV_Rect_Info[1])
        GUICtrlSetData($hTmp_Combo, "Tom|Dick|Harry")
        GUICtrlSetState($hListView, $GUI_DISABLE)
        GUICtrlSetState($hTmp_Combo, BitOR($GUI_FOCUS, $GUI_ONTOP))

    EndIf

WEnd

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    ; If a combo exists, return immediately
    If $hTmp_Combo <> 0 Then Return $GUI_RUNDEFMSG

    Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    If HWnd(DllStructGetData($tNMHDR, "hWndFrom")) = $hListView And DllStructGetData($tNMHDR, "Code") = $NM_DBLCLK Then
        $aLV_Click_Info = _GUICtrlListView_SubItemHitTest($hListView)
        ; As long as the click was on an item or subitem
        If $aLV_Click_Info[0] <> -1 Then $fDblClk = True
    EndIf
    Return $GUI_RUNDEFMSG

EndFunc
 