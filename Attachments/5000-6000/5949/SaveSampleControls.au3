; AutoIt 3.0.103 example
; 17 Jan 2005 - CyberSlug
; This script shows manual positioning of all controls;
;   there are much better methods of positioning...
#include <GuiConstants.au3>
#include <_XMLDomWrapper.au3>
#include <Array.au3>
;#include <_debug.au3>
; GUI
$gui = GUICreate("Sample GUI", 400, 400)
GUISetIcon(@SystemDir & "\mspaint.exe", 0)


; MENU
GUICtrlCreateMenu("Menu&One")
GUICtrlCreateMenu("Menu&Two")
GUICtrlCreateMenu("MenuTh&ree")
GUICtrlCreateMenu("Menu&Four")

; CONTEXT MENU
$contextMenu = GUICtrlCreateContextMenu()
GUICtrlCreateMenuItem("Context Menu", $contextMenu)
GUICtrlCreateMenuItem("", $contextMenu) ;separator
GUICtrlCreateMenuItem("&Properties", $contextMenu)

; PIC
GUICtrlCreatePic("logo4.gif", 0, 0, 163, 68)
GUICtrlCreateLabel("Sample pic", 75, 1, 53, 15)

; AVI
GUICtrlCreateAvi("sampleAVI.avi", 0, 180, 10, 32, 32, $ACS_AUTOPLAY)
GUICtrlCreateLabel("Sample avi", 170, 50)


; TAB
$h_tabcontrol = GUICtrlCreateTab(240, 0, 150, 70)
GUICtrlCreateTabItem("One")
GUICtrlCreateLabel("Sample Tab with tabItems", 250, 40)
GUICtrlCreateTabItem("Two")
GUICtrlCreateTabItem("Three")
GUICtrlCreateTabItem("")

; COMBO
GUICtrlCreateCombo("Sample Combo", 250, 80, 120, 100)

; PROGRESS
GUICtrlCreateProgress(60, 80, 150, 20)
GUICtrlSetData(-1, 60)
GUICtrlCreateLabel("Progress:", 5, 82)

; EDIT
$h_Edit = GUICtrlCreateEdit(@CRLF & "  Sample Edit Control", 10, 110, 150, 70)

; LIST
$h_List = GUICtrlCreateList("", 5, 190, 100, 90)
GUICtrlSetData(-1, "a.Sample|b.List|c.Control|d.Here", "b.List")

; ICON
GUICtrlCreateIcon("shell32.dll", 1, 175, 120)
GUICtrlCreateLabel("Icon", 180, 160, 50, 20)

; LIST VIEW
$listView = GUICtrlCreateListView("Sample|ListView|", 110, 190, 110, 80)
GUICtrlCreateListViewItem("A|One", $listView)
GUICtrlCreateListViewItem("B|Two", $listView)
GUICtrlCreateListViewItem("C|Three", $listView)

; GROUP WITH RADIO BUTTONS
GUICtrlCreateGroup("Sample Group", 230, 120)
$h_Radio1 = GUICtrlCreateRadio("Radio One", 250, 140, 80)
GUICtrlSetState(-1, $GUI_CHECKED)
$h_Radio2 = GUICtrlCreateRadio("Radio Two", 250, 165, 80)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

; UPDOWN
GUICtrlCreateLabel("UpDown", 350, 115)
$h_UpDown = GUICtrlCreateInput("42", 350, 130, 40, 20)
GUICtrlCreateUpdown(-1)

; LABEL
GUICtrlCreateLabel("Green" & @CRLF & "Label", 350, 165, 40, 40)
GUICtrlSetBkColor(-1, 0x00FF00)

; SLIDER
GUICtrlCreateLabel("Slider:", 235, 215)
$h_Slider = GUICtrlCreateSlider(270, 210, 120, 30)
GUICtrlSetData(-1, 30)

; INPUT
$h_Input = GUICtrlCreateInput("Sample Input Box", 235, 255, 130, 20)

; DATE
GUICtrlCreateDate("", 5, 280, 200, 20)
GUICtrlCreateLabel("(Date control expands into a calendar)", 10, 305, 200, 20)

; BUTTON
$button = GUICtrlCreateButton("Sample Button", 10, 330, 100, 30)

; CHECKBOX
$h_Check = GUICtrlCreateCheckbox("Checkbox", 130, 335, 80, 20)
GUICtrlSetState(-1, $GUI_CHECKED)

; TREEVIEW ONE
$treeOne = GUICtrlCreateTreeView(210, 290, 80, 80)
$treeItem = GUICtrlCreateTreeViewItem("TreeView", $treeOne)
GUICtrlCreateTreeViewItem("Item1", $treeItem)
GUICtrlCreateTreeViewItem("Item2", $treeItem)
GUICtrlCreateTreeViewItem("Foo", -1)
GUICtrlSetState($treeItem, $GUI_EXPAND)

; TREEVIEW TWO
Dim $tvtwo[5]
$treeTwo = GUICtrlCreateTreeView(295, 290, 103, 80, $TVS_CHECKBOXES)
$tvtwo[1] = GUICtrlCreateTreeViewItem("TreeView", $treeTwo)
$tvtwo[2] = GUICtrlCreateTreeViewItem("With", $treeTwo)
$tvtwo[3] = GUICtrlCreateTreeViewItem("tvs_checkboxes", $treeTwo)
GUICtrlSetState(-1, $GUI_CHECKED)
$tvtwo[4] = GUICtrlCreateTreeViewItem("Style", $treeTwo)




LoadSettings()
GUISetState()
; GUI MESSAGE LOOP

ConsoleWrite(0x1300 + 11)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $button
;			SaveSettings()
			;			WinMove("Sample GUI", "", 209, 0, 406, 425)
		Case $msg = $GUI_EVENT_CLOSE
			SaveSettings()
			ExitLoop
		Case Else
			;;
	EndSelect
	
WEnd

GUIDelete()
Exit
;===============================================================================
; Function Name:	_SaveSettings
; Description:		Save control settings to XML file
; Parameters:		
; Syntax:			_SaveSettings()
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			
; Requires _XMLDomWrapper.au3
;===============================================================================
Func SaveSettings()
	Local $sFile = @ScriptFullPath & ".xml"
	While @error = 0
		_XMLCreateFile ($sFile, "Settings", True)
		_XMLFileOpen ($sFile)
		$attribs = _ArrayCreate ("x", "y", "w", "h")
		$values = WinGetPos("Sample GUI")
		ConsoleWrite(UBound($attribs) & " " & UBound($values))
		_XMLCreateRootNodeWAttr ("Position", $attribs, $values)
		_XMLCreateRootChild ("State", WinGetState("Sample GUI"))
		_XMLCreateRootChild ("Tab", GUICtrlSendMsg($h_tabcontrol, 0x1300 + 11, 0, 0))
		$r_Edit = GUICtrlRead($h_Edit)
		_XMLCreateRootChild ("Edit", $r_Edit)
		$r_List = GUICtrlSendMsg($h_List, 0x188, 0, 0)
		_XMLCreateRootChild ("List", $r_List)
		$r_LView = Int(ControlListView("Sample GUI", "", $listView, "GetSelected", 0))
		_XMLCreateRootChild ("ListView", $r_LView)
		$r_Radio1 = GUICtrlRead($h_Radio1)
		_XMLCreateRootChild ("Radio1", $r_Radio1)
		$r_Radio2 = GUICtrlRead($h_Radio2)
		_XMLCreateRootChild ("Radio2", $r_Radio2)
		$r_UpDown = GUICtrlRead($h_UpDown)
		_XMLCreateRootChild ("UpDown", $r_UpDown)
		$r_Slider = GUICtrlRead($h_Slider)
		_XMLCreateRootChild ("Slider", $r_Slider)
		$r_Input = GUICtrlRead($h_Input)
		_XMLCreateRootChild ("Input", $r_Input)
		$r_Check = GUICtrlRead($h_Check)
		_XMLCreateRootChild ("Check", $r_Check)
		$r_TvOne = GUICtrlRead($treeOne)
		_XMLCreateRootChild ("Tv1", $r_TvOne)
		$r_TvTwo = GUICtrlRead($treeTwo)
		_XMLCreateRootChild ("Tv2",$r_TvTwo)
;		_XMLUpdateField ("Tv2", $r_TvTwo)

;???? save the checkbox states ?????????????????		
; create array for item names and state values
		$limit = Ubound($tvtwo)
		dim $aItems[$limit],$aStates[$limit]
		for $x =0 to $limit-1
			$aItems[$x]="Item_"&$x
			$aStates[$x] =GUICtrlGetState($tvtwo[$x])
			_DebugWrite($x&" , "&$aItems[$x]&" , "&$aStates[$x])
		Next
;add the arrays as an child attribute node under the parent
	_XMLCreateChildNodeWAttr("Tv2","Items",$aItems,$aStates)
;end save the checkbox states.
		Return
		ExitLoop
	WEnd
	
	MsgBox(4096, "Error", _XMLError ())
EndFunc   ;==>SaveSettings

;===============================================================================
; Function Name:	_LoadSettings
; Description:		Loads control settings from XML file
; Parameters:		
; Syntax:			_LoadSettings()
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			
; Requires _XMLDomWrapper.au3
;===============================================================================

Func LoadSettings()
	Local $sFile = @ScriptFullPath & ".xml"
	;	Local $pos[4]
	If FileExists($sFile) Then
		While @error = 0
			$ret = _XMLFileOpen ($sFile)
			WinMove("Sample GUI", "", _XMLGetAttrib ("Position", "x"), _
									_XMLGetAttrib ("Position", "y"), _
									_XMLGetAttrib ("Position", "w"), _
									_XMLGetAttrib ("Position", "h")) 
			WinSetState("Sample GUI", "", _XMLGetValue ("State"))
			GUICtrlSetData($h_Edit, _XMLGetValue ("Edit"))
			GUICtrlSendMsg($h_tabcontrol, 0x1300 + 12, Int(_XMLGetValue ("Tab")), 0)
			GUICtrlSendMsg($h_List, 0x0186, Int(_XMLGetValue ("List")), 0)
			ControlListView("Sample GUI", "", $listView, "Select", Int(_XMLGetValue ("ListView")), Int(_XMLGetValue ("ListView")))
			GUICtrlSetState($h_Radio1, _XMLGetValue ("Radio1"))
			GUICtrlSetState($h_Radio2, _XMLGetValue ("Radio2"))
			GUICtrlSetData($h_UpDown, _XMLGetValue ("UpDown"))
			GUICtrlSetData($h_Slider, _XMLGetValue ("Slider"))
			GUICtrlSetData($h_Input, _XMLGetValue ("Input"))
			GUICtrlSetState($h_Check, _XMLGetValue ("Check"))
			GUICtrlSetState( _XMLGetValue ("Tv1"), $GUI_FOCUS)
			GUICtrlSetState(_XMLGetValue ("Tv2"), $GUI_FOCUS)
; ????? restore the check boxes ????????
			dim $aNames[1], $aValues[1]
			_XMLGetAllAttrib("Tv2/Items",$aNames,$aValues)
			for $x = 0 to UBound($aNames)-1
				Guictrlsetstate($tvtwo[$x],int($aValues[$x]))
			Next
; end restore the checkbox states
			Return
		WEnd
		MsgBox(4096, "Error", _XMLError ())
	EndIf
EndFunc   ;==>LoadSettings
