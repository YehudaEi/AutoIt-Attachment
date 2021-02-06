#include <file.au3>
#include <GUIListView.au3>

$aFileList= _FileListToArray("d:\recorded shows")
GUICreate("", 800, 600)
GUISetFont(20)
$listview = GUICtrlCreateListView("Recorded Shows", 10, 10, 300, 580, -1, $LVS_EX_SUBITEMIMAGES)
_GUICtrlListView_SetColumnWidth ($listview, 0, 300)


For $i = 1 to $aFileList[0]
    GUICtrlCreateListViewItem($aFileList[$i], $listview)
Next
GUISetState()

; Main loop
While 1
    If GUIGetMsg() = -3 Then ExitLoop
WEnd