#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 311, 564, 357, 138, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$Progress1 = GUICtrlCreateProgress(8, 32, 289, 17)
$TreeView1 = GUICtrlCreateTreeView(16, 56, 169, 489)
;$TreeView1_0 = GUICtrlCreateTreeViewItem("", $TreeView1)
;$TreeView1_1 = GUICtrlCreateTreeViewItem("", $TreeView1)
;$TreeView1_2 = GUICtrlCreateTreeViewItem("", $TreeView1)
$TreeView2 = GUICtrlCreateTreeView(185, 56, 111, 489)
;$TreeView2_0 = GUICtrlCreateTreeViewItem("", $TreeView2)
;$TreeView2_1 = GUICtrlCreateTreeViewItem("", $TreeView2)
;$TreeView2_2 = GUICtrlCreateTreeViewItem("", $TreeView2)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Form1
		Case $Form1
		Case $Form1
		Case $Form1
		Case $TreeView1
		Case $TreeView2
	EndSwitch
WEnd
$ProgramArray = IniReadSection(@ScriptDir & "\Config.ini","Title")
If Not @error Then
    For $i = 1 To $ProgramArray[0][0]
		If $ProgramArray[$i][1] = "1" Then
        $treeitem = GUICtrlCreateTreeViewItem($ProgramArray[$i][0],$TreeView1)
		;GUICtrlSetState(-1, $GUI_HIDE)
        ;If $ProgramArray[$i][1] = "1" Then
            ;GUICtrlSetState($tree,$GUI_CHECKED)
        EndIf
    Next
EndIf