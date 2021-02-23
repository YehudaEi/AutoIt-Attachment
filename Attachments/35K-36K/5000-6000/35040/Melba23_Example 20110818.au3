#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

#include "GUIListViewEx_Mod.au3"

#include <Array.au3>

HotKeySet("{F5}","_NewData")

Global $iCount_Left = 20, $iCount_Right = 20, $vData, $sMsg, $aLV_List_Left, $aLV_List_Right

; Create GUI
$hGUI = GUICreate("LVEx Example 1", 640, 430)

; Create Left ListView
GUICtrlCreateLabel("Native ListView - Multiple selection - no count element - sortable", 10, 15, 300, 20)
$hListView_Left = GUICtrlCreateListView("Tom|Dick|Harry", 10, 40, 300, 300, $LVS_SHOWSELALWAYS)
_GUICtrlListView_SetExtendedListViewStyle($hListView_Left, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
_GUICtrlListView_SetColumnWidth($hListView_Left, 0, 93)
_GUICtrlListView_SetColumnWidth($hListView_Left, 1, 93)
_GUICtrlListView_SetColumnWidth($hListView_Left, 2, 93)

; Create array and fill Left listview
Global $aLV_List_Left[$iCount_Left]
For $i = 0 To UBound($aLV_List_Left) - 1
    $aLV_List_Left[$i] = "Tom " & $i & "|Dick " & $i & "|Harry " & $i
    GUICtrlCreateListViewItem($aLV_List_Left[$i], $hListView_Left)
Next

; Initiate LVEx - no count parameter - default insert mark colour (black)
$iLV_Left_Index = _GUIListViewEx_Init($hListView_Left, $aLV_List_Left, 0, 0, True, True)

; Create Right ListView
GUICtrlCreateLabel("UDF ListView - Single selection - count element - sortable", 330, 15, 300, 20)
$hListView_Right = _GUICtrlListView_Create($hGUI, "Peter", 330, 40, 300, 300, BitOR($LVS_DEFAULT, $WS_BORDER))
_GUICtrlListView_SetExtendedListViewStyle($hListView_Right, $LVS_EX_FULLROWSELECT)
_GUICtrlListView_AddColumn($hListView_Right, "Paul")
_GUICtrlListView_AddColumn($hListView_Right, "Mary")
_GUICtrlListView_SetColumnWidth($hListView_Right, 0, 93)
_GUICtrlListView_SetColumnWidth($hListView_Right, 1, 93)
_GUICtrlListView_SetColumnWidth($hListView_Right, 2, 93)

; Create Array to fill listview
Global $aLV_List_Right[$iCount_Right + 1][3] = [[$iCount_Right]]
For $i = 1 To UBound($aLV_List_Right) - 1
    $aLV_List_Right[$i][0] = "Peter " & $i -1
    $aLV_List_Right[$i][1] = "Paul " & $i -1
    $aLV_List_Right[$i][2] = "Mary " & $i -1
Next

; Fill listview
For $i = 1 To UBound($aLV_List_Right) - 1
    _GUICtrlListView_AddItem($hListView_Right, $aLV_List_Right[$i][0])
    _GUICtrlListView_AddSubItem($hListView_Right, $i - 1, $aLV_List_Right[$i][1], 1)
    _GUICtrlListView_AddSubItem($hListView_Right, $i - 1, $aLV_List_Right[$i][2], 2)
Next

; Initiate LVEx - count parameter set - red insert mark
$iLV_Right_Index = _GUIListViewEx_Init($hListView_Right, $aLV_List_Right, 1, 0xFF0000, True, True)

; Create buttons
$hInsert_Button = GUICtrlCreateButton("Insert", 10, 350, 200, 30)
$hDelete_Button = GUICtrlCreateButton("Delete", 10, 390, 200, 30)
$hUp_Button = GUICtrlCreateButton("Move Up", 220, 350, 200, 30)
$hDown_Button = GUICtrlCreateButton("Move Down", 220, 390, 200, 30)
$hDisplay_Left_Button = GUICtrlCreateButton("Show Left", 430, 350, 100, 30)
$hDisplay_Right_Button = GUICtrlCreateButton("Show Right", 530, 350, 100, 30)
$hExit_Button = GUICtrlCreateButton("Exit", 430, 390, 200, 30)

GUISetState()

; Register for dragging
_GUIListViewEx_DragRegister()

; Set the left ListView as active
_GUIListViewEx_SetActive(1)

Switch _GUIListViewEx_GetActive()
    Case 0
        $sMsg = "No ListView is active"
    Case 1
        $sMsg = "The LEFT ListView is active" & @CRLF & "<--------------------------"
    Case 2
        $sMsg = "The RIGHT ListView is active" & @CRLF & "---------------------------->"
EndSwitch
MsgBox(0, "Active ListView", $sMsg)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE, $hExit_Button
            Exit
        Case $hInsert_Button
            ; Prepare data  for insertion
            Switch $aGLVEx_Data[0][1]
                Case 1
                    ; String format with multi-column native ListView
                    $vData = "Tom " & $iCount_Left & "|Dick " & $iCount_Left & "|Harry " & $iCount_Left
                    $iCount_Left += 1
                    _GUIListViewEx_Insert($vData)
                Case 2
                    ; Array format with multi-column UDF ListView
                    Global $vData[3] = ["Peter " & $iCount_Right, "Paul " & $iCount_Right, "Mary " & $iCount_Right]
                    $iCount_Right += 1
                    _GUIListViewEx_Insert($vData)
            EndSwitch

        Case $hDelete_Button
            _GUIListViewEx_Delete()

        Case $hUp_Button
            _GUIListViewEx_Up()

        Case $hDown_Button
            _GUIListViewEx_Down()

        Case $hDisplay_Left_Button
            $aLV_List_Left = _GUIListViewEx_Return_Array($iLV_Left_Index)
            If Not @error Then
                _ArrayDisplay($aLV_List_Left, "Returned Left")
            Else
                MsgBox(0, "Left", "Empty Array")
            EndIf
            $aLV_List_Left = _GUIListViewEx_Return_Array($iLV_Left_Index, 1)
            If Not @error Then
                _ArrayDisplay($aLV_List_Left, "Returned Left Checkboxes")
            Else
                MsgBox(0, "Left", "Empty Check Array")
            EndIf

        Case $hDisplay_Right_Button
            $aLV_List_Right = _GUIListViewEx_Return_Array($iLV_Right_Index)
            If Not @error Then
                _ArrayDisplay($aLV_List_Right, "Returned Right")
            Else
                MsgBox(0, "Right", "Empty Array")
            EndIf
    EndSwitch

WEnd

Func _NewData()
	_GUICtrlListView_DeleteAllItems($hListView_Left)
; Create array and fill Left listview
Global $aLV_List_Left[$iCount_Left]
For $i = 0 To UBound($aLV_List_Left) - 1
    $aLV_List_Left[$i] = "Jerry " & $i & "|Dick1 " & $i & "|Harry1 " & $i
    GUICtrlCreateListViewItem($aLV_List_Left[$i], $hListView_Left)
Next

; Initiate LVEx - no count parameter - default insert mark colour (black)
$iLV_Left_Index = _GUIListViewEx_Init($hListView_Left, $aLV_List_Left, 0, 0, True, True)
			msgbox(0,"$aGLVEx_Data","every time we do a refresh $aGLVEx_Data is appended")
			sleep(20);sometimes it crash
			_ArrayDisplay( $aGLVEx_Data,"$aGLVEx_Data")

EndFunc