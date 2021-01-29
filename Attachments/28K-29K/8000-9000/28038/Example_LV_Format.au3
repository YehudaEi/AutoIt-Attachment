#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>
#include 'LV_Format_include.au3'


Local $col = ''
For $i = 1 To 6
	$col &= $i & '|'
Next

$GUI = GUICreate('')
$lv = GUICtrlCreateListView(StringTrimRight($col,1), 10, 10, 300, 150)
$hLV = GUICtrlGetHandle($lv)
For $i = 0 To 5
	_GUICtrlListView_SetColumnWidth($hLV, $i, 49)
Next

Global $B_DESCENDING[_GUICtrlListView_GetColumnCount($hLV)]

; initialize Global vars
_LVFormatting_Startup($hLV)

; add new Items
_GUICtrlListView_AddOrIns_Item($hLV, 'Test0|Test1|Test2|Test3|Test4|Test5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blub0|Blub1|Blub2|Blub3|Blub4|Blub5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Club0|Club1|Club2|Club3|Club4|Club5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blab0|Blab1|Blab2|Blab3|Blab4|Blab5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4|Bumm5')

; set format
_SetItemParam($hLV, 0, 2, 0xff0000, -1, -1, 600, 'Times New Roman')
_SetItemParam($hLV, 1, 4, 0xffff00, -1, -1, 600, 'Comic Sans MS')
_SetItemParam($hLV, 1, 3, 0xff0000, -1, -1, 600, 'Times New Roman')


GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState(@SW_SHOW, $GUI)

Sleep(1000)
_SetItemParam($hLV, 1, 4) ; set format to default for Item at index 1, column-index 4

Sleep(1000)
__GUICtrlListView_DeleteItem($hLV, 1) ; delete Item at index 1

Sleep(1000)
__GUICtrlListView_DeleteAllItems($hLV)

Sleep(1000)
_GUICtrlListView_BeginUpdate($hLV)
_GUICtrlListView_AddOrIns_Item($hLV, 'Test0|Test1|Test2|Test3|Test4|Test5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blub0|Blub1|Blub2|Blub3|Blub4|Blub5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Club0|Club1|Club2|Club3|Club4|Club5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blab0|Blab1|Blab2|Blab3|Blab4|Blab5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4|Bumm5')
_GUICtrlListView_EndUpdate($hLV)
_SetItemParam($hLV, 0, 1, 0xff0000, -1, -1, 600, 'Times New Roman')
_SetItemParam($hLV, 1, 2, 0xffff00, -1, -1, 600, 'Comic Sans MS')
_SetItemParam($hLV, 2, 3, 0xff0000, -1, -1, 600, 'Times New Roman')

WinSetTitle($GUI, '', 'Now click column header to sort')

Do
Until GUIGetMsg() = -3
; clear ressources
_LVFormatting_Shutdown()


Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hLV
            Switch $iCode
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					__GUICtrlListView_SimpleSort($hWndFrom, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
                Case $NM_CUSTOMDRAW
                    If Not _GUICtrlListView_GetViewDetails($hWndFrom) Then Return $GUI_RUNDEFMSG
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $iDrawStage, $iItem, $iSubitem, $hDC, $tRect
                    $iDrawStage = DllStructGetData($tCustDraw, 'dwDrawStage')
                    Switch $iDrawStage
                        Case $CDDS_ITEMPREPAINT
                            Return $CDRF_NOTIFYSUBITEMDRAW
                        Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
                            $iItem = DllStructGetData($tCustDraw, 'dwItemSpec')
                            $iSubitem = DllStructGetData($tCustDraw, 'iSubItem')
							Local $index = _getMarked($hWndFrom, $iItem, $iSubitem)
							If $index = -1 Then
								_DrawDefault($hDC, $tCustDraw)
							Else
								_DrawItemCol($hDC, $tCustDraw, $hWndFrom, $index, $iSubitem)
							EndIf
                            Return $CDRF_NEWFONT
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
