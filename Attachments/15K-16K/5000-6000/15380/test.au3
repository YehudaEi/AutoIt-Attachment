#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <A3LTreeView.au3>
#include <GuiTreeView.au3>
#include <file.au3>
#include <Array.au3>
#Include <date.au3>
Opt("GUIOnEventMode", 1)
Opt("OnExitFunc","MyExit")

Dim $ArrayOfParentNames[1];
; == GUI generated with Koda ==
$Form1 = GUICreate("TREEVIEW TEST", 381, 441, 1089, 269)
AutoItWinSetTitle("TREEVIEW TEST")
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
$test = GUICtrlCreateInput("", 24, 32, 265, 21, -1, $WS_EX_CLIENTEDGE)
$Add = GUICtrlCreateButton("Add", 24, 64, 75, 25)
GUICtrlSetOnEvent($Add, "ADDParent")
$TreeView1 = GUICtrlCreateTreeView(24, 104, 329, 289)
$All = GUICtrlCreateButton("Display Each", 24, 400, 75, 25)
GUICtrlSetOnEvent($All,"StartMSGBOX")
$Label1 = GUICtrlCreateLabel("Display All Parent Nodes And All Children in a message box one at a time", 106, 400, 242, 41)
GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

Func SpecialEvents()
    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            Exit
        Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
        Case @GUI_CTRLID = $GUI_EVENT_RESTORE
    EndSelect
EndFunc

func MyExit()
	opt("OnExitFunc","OnAutoItExit");
	Exit;
EndFunc

Func ADDParent()
	local $addthis = GUICtrlRead($test)
	local $i =0
		Local $found = 0;
		For $i = 1 to $ArrayOfParentNames[0] Step 1
			IF($addthis = $ArrayOfParentNames[$i]) Then
				$found = 1
			EndIf
		Next
	if $found <> 1 Then
		_ArrayAdd($ArrayOfParentNames,$addthis);
		$ArrayOfParentNames[0] = $ArrayOfParentNames[0]+1
		local $parent = GUICtrlCreateTreeViewitem($addthis, $TreeView1)
		local $Child1 = GUICtrlCreateTreeViewitem("CHILD 1"&@HOUR&":"&@MIN&":"&@SEC, $parent)
		local $Child2 = GUICtrlCreateTreeViewitem("CHILD 2"&@HOUR&":"&@MIN&":"&@SEC, $parent)
		local $Child3 = GUICtrlCreateTreeViewitem("CHILD 3"&@HOUR&":"&@MIN&":"&@SEC, $parent)
		local $Child4 = GUICtrlCreateTreeViewitem("CHILD 4"&@HOUR&":"&@MIN&":"&@SEC, $parent)
		local $Child5 = GUICtrlCreateTreeViewitem("CHILD 5"&@HOUR&":"&@MIN&":"&@SEC, $parent)
	EndIf
EndFunc

Func StartMSGBOX()
	local $index = 1
	local $amtchild = 0
	While($index <= $ArrayOfParentNames[0])
		Local $Child1
		Local $Child2
		Local $Child3
		Local $Child4
		Local $Child5
		local $hWnd = ControlGetHandle("TREEVIEW TEST","","SysTreeView32")
		local $hNode = _TreeView_FindNode($hWnd,$ArrayOfParentNames[$index])
		MsgBox(0,"Win Handle",$ArrayOfParentNames[$index] & ": "&$hNode)
		local $ChNode = _TreeView_GetFirstChild($hWnd, $hNode)
		if $ChNode <> 0 then
			do
				Select
				Case $amtchild = 0
					$Child1 = _TreeView_GetText($hWnd,$ChNode)
				Case $amtchild = 1
					$Child2 = _TreeView_GetText($hWnd,$ChNode)
				Case $amtchild = 2
					$Child3 = _TreeView_GetText($hWnd,$ChNode)
				Case $amtchild = 3
					$ProjectDir = _TreeView_GetText($hWnd,$ChNode)
				Case $amtchild = 4
					$Child4 = _TreeView_GetText($hWnd,$ChNode)
				Case $amtchild = 5
					$Child5 = _TreeView_GetText($hWnd,$ChNode)
				EndSelect
				$amtchild = $amtchild + 1
				$ChNode   = _TreeView_GetNextChild($hWnd, $ChNode)
			until $ChNode = 0
		endif
		MsgBox(0,"RESULTS "&$ArrayOfParentNames[$index],$Child1 & @CRLF & $Child2 & @CRLF & $Child3 &@CRLF &$Child4 & @CRLF & $Child5 & @CRLF)
		$index = $index + 1
	WEnd
EndFunc