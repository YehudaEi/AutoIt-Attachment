#include <GUIConstants.au3>
#include <GUIListView.au3>

$width = 150
$height = 150

$GUI = GUICreate(@AutoItVersion, $width, $height)

$ListView = GUICtrlCreateListView("#|Text", 5, 5, $width - 10, $height - 10)
_GUICtrlListViewInsertItem($ListView, -1, "1|Hello")
_GUICtrlListViewInsertItem($ListView, -1, "2|World")
_GUICtrlListViewInsertItem($ListView, -1, "3|風")
GUICtrlCreateListViewItem("4|風", $ListView)

GUISetState()

While 1
    If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
WEnd
