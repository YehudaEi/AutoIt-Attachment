#include <GUIConstants.au3>
#include <GuiStatusbar.au3>

;===============================================================================
; FileName:			splitterdemo.au3
; Description:      Splitter Bar demo
;
; Requirement:      Beta
; Author(s):        eltorro (Steve Podhajecki <gehossafats@netmdc.com>)
; Note(s):			This is just a proof of concept at the moment.
;					This could be tweaked into a udf with a little more work
;					The basic principle is to create a pic box and drag it
;					then resize the controls.
;					I bowwored some filler for the tree and list from the help files.
;===============================================================================
$WM_SIZE =0x0005
$Form1 = GUICreate("Splitter Demo", 622, 448, 192, 125, BitOr($WS_SIZEBOX, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU,$WS_CLIPCHILDREN))

$TreeView1 = GUICtrlCreateTreeView(0, 8, 145, 313, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, 42)
	$generalitem = GUICtrlCreateTreeViewItem("General", $TreeView1)
	GUICtrlSetColor(-1, 0x0000C0)
	$displayitem = GUICtrlCreateTreeViewItem("Display", $TreeView1)
	GUICtrlSetColor(-1, 0x0000C0)
	$aboutitem = GUICtrlCreateTreeViewItem("About", $generalitem)
	$compitem = GUICtrlCreateTreeViewItem("Computer", $generalitem)
	$useritem = GUICtrlCreateTreeViewItem("User", $generalitem)
	$resitem = GUICtrlCreateTreeViewItem("Resolution", $displayitem)
	$otheritem = GUICtrlCreateTreeViewItem("Other", $displayitem)


$ListView1 = GUICtrlCreateListView("col1  |col2|col3  ", 152, 8, 465, 313, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, 44)
	$item1 = GUICtrlCreateListViewItem("item2|col22|col23", $ListView1)
	$item2 = GUICtrlCreateListViewItem("item1|col12|col13", $ListView1)
	$item3 = GUICtrlCreateListViewItem("item3|col32|col33", $ListView1)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)   ; to allow drag and dropping
	GUISetState()
	GUICtrlSetData($item2, "ITEM1")
	GUICtrlSetData($item3, "||COL33")

;vertical divider
$Pic1 = GUICtrlCreatePic("", 144, 8, 5, 313, $SS_NOTIFY)
GUICtrlSetResizing($Pic1, 128 +2+256)
GUICtrlSetCursor($Pic1, 13)
;horizontal divider.
$Pic2 = GUICtrlCreatePic("", 0, 320, 617, 20, BitOR($SS_NOTIFY, $SS_ETCHEDFRAME), $WS_EX_CLIENTEDGE)
GUICtrlSetResizing($Pic2, 8 + 64 +  512)
GUICtrlSetCursor($Pic2, 11)

Local $a[3] = [150,150, -1]
Local $b[3] = ["Ready.", "",""], $InitiateDrag = "False", $DragCtrl
$Status1 = _GuiCtrlStatusBarCreate ($Form1, $a, $b)

$Edit1 = GUICtrlCreateEdit("", 0, 328, 617, 113, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, 128)
GUICtrlSetData($Edit1, "Drag the bars between the controls and they will resize." & @CRLF & _
		"Resize the screen and see what happens."& @CRLF & _
		"The Status bar show True the left mouse button is down and over a splitter.")

opt("MouseCoordMode", 2)
GUICtrlSetState($generalitem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))    ; Expand the "General"-item and paint in bold
GUICtrlSetState($displayitem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))    ; Expand the "Display"-item and paint in bold

GUISetState(@SW_SHOW)
ResizeControls()
GUIRegisterMsg($WM_SIZE,"RESIZECONTROLS")
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_PRIMARYDOWN
			_GuiCtrlStatusBarSetText ($Status1, "Primary Down", 0)
		Case $msg = $Pic1
			_GuiCtrlStatusBarSetText ($Status1, "Pic1 Primary Down",0)
			$InitiateDrag = "True"
			$DragCtrl = $Pic1
		Case $msg = $Pic2
			_GuiCtrlStatusBarSetText ($Status1, "Pic2 Primary Down", 0)
			$InitiateDrag = "True"
			$DragCtrl = $Pic2
		Case $msg = $GUI_EVENT_PRIMARYUP
			_GuiCtrlStatusBarSetText ($Status1, "Primary Up", 0)
			$InitiateDrag = "False"
			Select
				Case $DragCtrl = $Pic1
					SplitterVert($TreeView1, $ListView1, $Pic1, $Pic2)
					$DragCtrl = ""
				Case $DragCtrl = $Pic2
					SplitterHort($TreeView1, $ListView1, $Edit1, $Pic2)
					$DragCtrl = ""
			EndSelect
			
		Case $msg = $GUI_EVENT_SECONDARYDOWN
			_GuiCtrlStatusBarSetText ($Status1, "Secondary Down", 0)
		Case $msg = $GUI_EVENT_SECONDARYUP
			_GuiCtrlStatusBarSetText ($Status1, "Secondary Up", 0)
		Case $msg = $GUI_EVENT_MOUSEMOVE
			_GuiCtrlStatusBarSetText ($Status1, "Mouse Move", 0)
			If $InitiateDrag = "True" Then
				_GuiCtrlStatusBarSetText ($Status1, "Dragging", 1)
				
				Local $picpos = ControlGetPos("", "", $DragCtrl)
				Local $mousepos = MouseGetPos()
				Local $winpos = WinGetClientSize("")
				If $DragCtrl = $Pic1 Then
					If $mousepos[0] > 25 And $mousepos[0]< ($winpos[0] - 25) Then GUICtrlSetPos($Pic1, $mousepos[0], $picpos[1])
				EndIf
				If $DragCtrl = $Pic2 Then
					If $mousepos[1] > 25 And $mousepos[1]< ($winpos[1] - 25) Then GUICtrlSetPos($Pic2, $picpos[0], $mousepos[1])
				EndIf
				
			EndIf
		Case $msg = $GUI_EVENT_RESIZED or $msg = $GUI_EVENT_MAXIMIZE
			ResizeControls()
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			If _GuiCtrlStatusBarGetText ($Status1, 0) <> "Ready." Then _GuiCtrlStatusBarSetText ($Status1, "Ready.", 0)
			If _GuiCtrlStatusBarGetText ($Status1, 1) <> $InitiateDrag Then _GuiCtrlStatusBarSetText ($Status1, $InitiateDrag, 1)
			;;;;;;;
	EndSelect
WEnd
Exit
Func RESIZE_CONTROLS($hWnd, $Msg, $wParam, $lParam)
	ResizeControls()
	Return $GUI_RUNDEFMSG
EndFunc

Func ResizeControls()
;	GUISetState(@SW_LOCK)
	;_ResizeHandler() ;needed to handle child????
	_GuiCtrlStatusBarResize ($Status1)
	Local $winpos = WinGetPos("")
	Local $picpos1 = ControlGetPos("", "", $Pic1)
	Local $picpos2 = ControlGetPos("", "", $Pic2)
	Local $pos = $picpos2
	
	GUICtrlSetPos($Pic2, 0, $picpos2[1], $winpos[2], $picpos2[3])
	GUICtrlSetPos($Pic1, $picpos1[0], $picpos1[1], $picpos1[2], $picpos2[1])
	SplitterHort($TreeView1, $ListView1, $Edit1, $Pic2)
	SplitterVert($TreeView1, $ListView1, $Pic1, $Pic2)
;	GUISetState(@SW_UNLOCK)
EndFunc   ;==>ResizeControls

Func SplitterVert($ctrl1, $ctrl2, $split1, $split2)
	Local $splitpos1 = ControlGetPos("", "", $split1)
	Local $splitpos2 = ControlGetPos("", "", $split2)
	Local $ctrl1pos = ControlGetPos("", "", $ctrl1)
	Local $ctrl2pos = ControlGetPos("", "", $ctrl2)
	Local $winpos = WinGetClientSize("")
	GUICtrlSetPos($ctrl1, $ctrl1pos[0], _
			$ctrl1pos[1], _
			(($splitpos1[0] - 1) - $ctrl1pos[0]), _
			$splitpos2[1]-10) 
	Local $nw = $winpos[0] - $splitpos1[0] - 5
	GUICtrlSetPos($ctrl2, $splitpos1[0] + 5, _
			$ctrl2pos[1], _
			$nw, _
			$splitpos2[1] - 10)
	
EndFunc   ;==>SplitterVert

Func SplitterHort($ctrl1, $ctrl2, $ctrl3, $split)
	Local $splitpos = ControlGetPos("", "", $split)
	Local $ctrl1pos = ControlGetPos("", "", $ctrl1)
	Local $ctrl2pos = ControlGetPos("", "", $ctrl2)
	Local $ctrl3pos = ControlGetPos("", "", $ctrl3)
	Local $winpos = WinGetClientSize("")
	Local $nh
	Select
		Case $splitpos[1] > $ctrl1pos[3]
			$nh = ($ctrl1pos[3]+ ($splitpos[1] - $ctrl1pos[3])) - 10
		Case $splitpos[1] < $ctrl1pos[3]
			$nh = ($ctrl1pos[3]- ($ctrl1pos[3] - $splitpos[1])) - 10
	EndSelect
	
	GUICtrlSetPos($ctrl1, $ctrl1pos[0], _
			$ctrl1pos[1], _
			$ctrl1pos[2], _
			$nh)
	
	GUICtrlSetPos($ctrl2, $ctrl2pos[0], _
			$ctrl2pos[1], _
			$ctrl2pos[2], _
			$nh)
	Local $nh
	$nh = $winpos[1] - $splitpos[1] + $splitpos[3] - 60; move this up above the status bar
;	ConsoleWrite($nh & "=" & $winpos[1] & "-" & $splitpos[1] & "+" & $splitpos[3] & "-40" & @CR)
	GUICtrlSetPos($ctrl3,	$ctrl3pos[0], _
						  	$splitpos[1] + $splitpos[3] + 1, _
							$winpos[0], _
							$nh)
EndFunc   ;==>SplitterHort
