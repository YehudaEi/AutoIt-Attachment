#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <ExpListView.au3>
#include <GuiListView.au3>
#Region ### START Koda GUI section ### Form=
$Form2 = GUICreate("Tabbed Notebook Dialog", 1023, 731, 39, 43)
$PageControl1 = GUICtrlCreateTab(11, 14, 1004, 680)
$TabSheet1 = GUICtrlCreateTabItem("TabSheet1")
$TabSheet2 = GUICtrlCreateTabItem("TabSheet2")
$TabSheet3 = GUICtrlCreateTabItem("TabSheet3")
GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("&OK", 758, 696, 75, 25)
$Button2 = GUICtrlCreateButton("&Cancel", 838, 696, 75, 25)
$Button3 = GUICtrlCreateButton("&Help", 920, 696, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
OnAutoItExitRegister('_Exit')
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <ExpListView.au3>

OnAutoItExitRegister('_Exit')
Local $sRestore = @ScriptDir & '\Restore1.ini'

Local $hList1 = _ExpListView_Create($TabSheet1, 'c:\', 13, False, 29, 60, 385, 253)
Local $hList2 = _ExpListView_Create($TabSheet1, 'My Computer', 28, False, 437, 60, 385, 253)

;This restores the columns to whatever they were the last time you exited the script.
;see exit function for saving views.
If FileExists($sRestore) Then
    _ExpListView_ColumnViewsRestore($hList1, IniRead($sRestore, 'ListViews', 'List1', ''))
    _ExpListView_ColumnViewsRestore($hList2, IniRead($sRestore, 'ListViews', 'List2', ''))
EndIf

Local $sCurrentDirectory1 = GUICtrlCreateLabel("", 69, 59, 344, 26)
Local $sCurrentDirectory2 = GUICtrlCreateLabel("", 484, 55, 344, 26)
$setColunms1 = GUICtrlCreateButton("Set Columns", 141, 437, 67, 25, $WS_GROUP)
$Checkbox1 = GUICtrlCreateCheckbox("Size", 141, 467, 79, 19)
$Checkbox2 = GUICtrlCreateCheckbox("Modified", 237, 437, 79, 19)
$Checkbox3 = GUICtrlCreateCheckbox("Attributes", 333, 437, 79, 19)
$Checkbox4 = GUICtrlCreateCheckbox("Creation", 237, 467, 79, 19)
$Checkbox5 = GUICtrlCreateCheckbox("Accessed", 333, 466, 79, 19)
$Back1 = GUICtrlCreateButton("Back", 48, 424, 61, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Current:", 21, 62, 38, 21)
$Label3 = GUICtrlCreateLabel("Current:", 433, 60, 38, 17)
$Group1 = GUICtrlCreateGroup("Colunms", 132, 418, 289, 91)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ShowHidden1 = GUICtrlCreateButton("Hidden", 48, 454, 61, 25, $WS_GROUP)
$input1 = GUICtrlCreateButton("Input", 48, 484, 61, 25, $WS_GROUP)
$Group2 = GUICtrlCreateGroup("Colunms", 540, 418, 289, 91)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$setColunms2 = GUICtrlCreateButton("Set Columns", 546, 431, 67, 25, $WS_GROUP)
$Checkbox6 = GUICtrlCreateCheckbox("Size", 546, 461, 79, 19)
$Checkbox7 = GUICtrlCreateCheckbox("Modified", 642, 431, 79, 19)
$Checkbox8 = GUICtrlCreateCheckbox("Attributes", 738, 431, 79, 19)
$Checkbox9 = GUICtrlCreateCheckbox("Creation", 642, 461, 79, 19)
$Checkbox10 = GUICtrlCreateCheckbox("Accessed", 738, 461, 79, 19)
$Back2 = GUICtrlCreateButton("Back", 456, 424, 61, 25, $WS_GROUP)
$ShowHidden2 = GUICtrlCreateButton("Hidden", 456, 454, 61, 25, $WS_GROUP)
$input2 = GUICtrlCreateButton("Input", 456, 484, 61, 25, $WS_GROUP)
GUICtrlSetData($sCurrentDirectory1, _ExpListView_DirGetCurrent($hList1))
GUICtrlSetData($sCurrentDirectory2, _ExpListView_DirGetCurrent($hList2))


;Here I set a function to update the Current Directory everytime the user changes directory by double clicking.
;This function is ONLY called on a double click event. Each Listview could have its own function if needed.
_ExpListView_SetFunction($hList1, '_Call_Function')
_ExpListView_SetFunction($hList2, '_Call_Function')

GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Back1
            _ExpListView_Back($hList1)
            GUICtrlSetData($sCurrentDirectory1, _ExpListView_DirGetCurrent($hList1))
        Case $Back2
            _ExpListView_Back($hList2)
            GUICtrlSetData($sCurrentDirectory2, _ExpListView_DirGetCurrent($hList2))
        Case $setColunms1
            Local $iColumn_Value = 0
            If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then $iColumn_Value += 1
            If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then $iColumn_Value += 2
            If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then $iColumn_Value += 4
            If GUICtrlRead($Checkbox4) = $GUI_CHECKED Then $iColumn_Value += 8
            If GUICtrlRead($Checkbox5) = $GUI_CHECKED Then $iColumn_Value += 16
            _ExpListView_SetColumns($hList1, $iColumn_Value)
        Case $setColunms2
            Local $iColumn_Value = 0
            If GUICtrlRead($Checkbox6) = $GUI_CHECKED Then $iColumn_Value += 1
            If GUICtrlRead($Checkbox7) = $GUI_CHECKED Then $iColumn_Value += 2
            If GUICtrlRead($Checkbox8) = $GUI_CHECKED Then $iColumn_Value += 4
            If GUICtrlRead($Checkbox9) = $GUI_CHECKED Then $iColumn_Value += 8
            If GUICtrlRead($Checkbox10) = $GUI_CHECKED Then $iColumn_Value += 16
            _ExpListView_SetColumns($hList2, $iColumn_Value)
        Case $ShowHidden1
            Local $flag = _ToggleHidden($hList1)
            _ExpListView_ShowHiddenFiles($hList1, $flag)
            _ExpListView_Refresh($hList1)
        Case $ShowHidden2
            Local $flag = _ToggleHidden($hList2)
            _ExpListView_ShowHiddenFiles($hList2, $flag)
            _ExpListView_Refresh($hList2)
        Case $input1
            Local $inputbox = InputBox('Directory Change', 'Enter the Directory to Navigate to:', '', ' M', Default, 130)
            _ExpListView_DirSetCurrent($hList1, $inputbox)
            GUICtrlSetData($sCurrentDirectory1, _ExpListView_DirGetCurrent($hList1))
        Case $input2
            Local $inputbox = InputBox('Directory Change', 'Enter the Directory to Navigate to:', '', ' M', Default, 130)
            _ExpListView_DirSetCurrent($hList2, $inputbox)
            GUICtrlSetData($sCurrentDirectory2, _ExpListView_DirGetCurrent($hList2))
    EndSwitch
WEnd

;hWnd is the only parameter needed for the call function you create.
Func _Call_Function($hWnd)
    Switch $hWnd
        Case $hList1
            GUICtrlSetData($sCurrentDirectory1, _ExpListView_DirGetCurrent($hWnd))
        Case $hList2
            GUICtrlSetData($sCurrentDirectory2, _ExpListView_DirGetCurrent($hWnd))
    EndSwitch
EndFunc   ;==>_Call_Function

Func _ToggleHidden($List)
    Static $bFlag1 = -1, $bFlag2 = -1

    Switch $List
        Case $hList1
            $bFlag1 *= -1
            If $bFlag1 = -1 Then Return False
        Case $hList2
            $bFlag2 *= -1
            If $bFlag2 = -1 Then Return False
    EndSwitch

    Return True

EndFunc   ;==>_ToggleHidden

;Here we have a simple exit function that saves the column info so we can reload it at startup.
Func _Exit()
    If Not FileExists($sRestore) Then _FileCreate($sRestore)
    IniWrite($sRestore, 'ListViews', 'List1', _ExpListView_ColumnViewsSave($hList1))
    IniWrite($sRestore, 'ListViews', 'List2', _ExpListView_ColumnViewsSave($hList2))
EndFunc   ;==>_Exit