#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <GuiComboBoxEx.au3>
#include <File.au3>

Opt("GUICloseOnESC", 1)
Opt("GUIOnEventMode", 1)

Global $fTypes = "au3|doc|docx|txt|zip|rar|lnk"

$Gui = GUICreate("Desktop Cleaner V1.03", 385, 185, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetOnEvent($GUI_EVENT_CLOSE, "Event", $Gui)

$LV = GUICtrlCreateListView("Desktop Files", 5, 10, 280, 140, -1, BitOR($LVS_EX_CHECKBOXES, $WS_EX_CLIENTEDGE))
FindDesktopFiles()

GUICtrlCreateGroup("File Types", 290, 5, 90, 45)
$Combo = GUICtrlCreateCombo("All Types", 300, 20, 70, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent(-1, "Event")
GUICtrlSetData(-1, $fTypes, "All Types")

$SelectAll = GUICtrlCreateButton("Select All", 290, 65, 90, 25)
GUICtrlSetOnEvent(-1, "Event")
$SelectNone = GUICtrlCreateButton("Select None", 290, 95, 90, 25)
GUICtrlSetOnEvent(-1, "Event")
$InvertSeleced = GUICtrlCreateButton("Invert Selected", 290, 125, 90, 25)
GUICtrlSetOnEvent(-1, "Event")

$SendToBin = GUICtrlCreateButton("Send Selected File(s) To Recycle Bin", 5, 155, 375, 25)
GUICtrlSetOnEvent(-1, "Event")
GUICtrlSetFont(-1, 10, 700)

GUISetState(@SW_SHOW, $Gui)

While 1
    Sleep(100)
WEnd

Func Event()
    Switch @GUI_CtrlId
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Combo
            FindDesktopFiles(GUICtrlRead($Combo))
        Case $SelectAll
            For $s = 0 To _GUICtrlListView_GetItemCount($LV) - 1
                _GUICtrlListView_SetItemChecked($LV, $s, True)
            Next
        Case $SelectNone
            For $s = 0 To _GUICtrlListView_GetItemCount($LV) - 1
                _GUICtrlListView_SetItemChecked($LV, $s, False)
            Next
        Case $InvertSeleced
            For $s = 0 To _GUICtrlListView_GetItemCount($LV) - 1
                If _GUICtrlListView_GetItemChecked($LV, $s) Then
                    _GUICtrlListView_SetItemChecked($LV, $s, False)
                Else
                    _GUICtrlListView_SetItemChecked($LV, $s, True)
                EndIf
            Next
        Case $SendToBin
            For $s = 0 To _GUICtrlListView_GetItemCount($LV) - 1
                If _GUICtrlListView_GetItemChecked($LV, $s) Then _
                        FileRecycle(@DesktopDir & "\" & _GUICtrlListView_GetItemText($LV, $s, 0))
            Next
            FindDesktopFiles(GUICtrlRead($Combo))
    EndSwitch
EndFunc

Func FindDesktopFiles($sType = "All Types")
    _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($LV))
    Local $ext = "*." & $sType, $FL2A
    If $sType = "All Types" Then $ext = "*.*"
    $FL2A = _FileListToArray(@DesktopDir, $ext, 1)
    If Not @error Then
        For $i = 1 To $FL2A[0]
            If $sType = "All Types" Then
                Local $SST = StringSplit($fTypes, "|")
                For $j = 1 To $SST[0]
                    If $SST[$j] = StringMid($FL2A[$i], StringInStr($FL2A[$i], ".", 0, -1) + 1) Then _
                            GUICtrlCreateListViewItem($FL2A[$i], $LV)
                Next
            ElseIf $sType <> "All Types" Then
                If $sType = StringMid($FL2A[$i], StringInStr($FL2A[$i], ".", 0, -1) + 1) Then _
                        GUICtrlCreateListViewItem($FL2A[$i], $LV)
            EndIf
        Next
        _GUICtrlListView_SetColumnWidth($LV, 0, $LVSCW_AUTOSIZE)
    EndIf
EndFunc