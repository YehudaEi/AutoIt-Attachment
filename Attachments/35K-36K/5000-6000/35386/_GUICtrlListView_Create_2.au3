#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>

#include <Listviewconstants.au3>

#include <WindowsConstants.au3>

#include<misc.au3>
#include<_dllstructDisplay.au3>; ascend4ntscode -> http://sites.google.com/site/ascend4ntscode/dllstructdisplay

Opt('MustDeclareVars', 1)

$Debug_LV = True ; set True to show notifications on console
Global $DllStructDisplay = False ; set True to show values
Global $hListView

Global $GUI, $hImage
$GUI = GUICreate("(UDF Created) ListView Create", 400, 300)

; To have notify msg befor ListView build
GUISetState()
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

$hListView = _GUICtrlListView_Create($GUI, "", 2, 2, 394, 268)
_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES, $LVS_EX_INFOTIP))

; Load images
$hImage = _GUIImageList_Create()
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFF0000, 16, 16))
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x00FF00, 16, 16))
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x0000FF, 16, 16))
_GUICtrlListView_SetImageList($hListView, $hImage, 1)

; Add columns
_GUICtrlListView_InsertColumn($hListView, 0, "Column 1", 100)
_GUICtrlListView_InsertColumn($hListView, 1, "Column 2", 100)
_GUICtrlListView_InsertColumn($hListView, 2, "Column 3", 100)

; Add items
_GUICtrlListView_AddItem($hListView, "Row 1: Col 1", 0)
_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 2", 1)
_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 3", 2)
_GUICtrlListView_AddItem($hListView, "Row 2: Col 1", 1)
_GUICtrlListView_AddSubItem($hListView, 1, "Row 2: Col 2", 1)
_GUICtrlListView_AddItem($hListView, "Row 3: Col 1", 2)

; ; To have notify msg after ListView build
;GUISetState()
;GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

; Loop until user exits
Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE
GUIDelete()


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam

	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	Local $tBuffer
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode

				Case $LVN_BEGINDRAG ; A drag-and-drop operation involving the left mouse button is being initiated
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_BEGINDRAG" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value

				Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW
					;Case $LVN_BEGINLABELEDIT ; Start of label editing for an item
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					_DebugPrint("$LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
					Return False ; Allow the user to edit the label
;~ 					;Return True  ; Prevent the user from editing the label

				Case $LVN_BEGINRDRAG ; A drag-and-drop operation involving the right mouse button is being initiated
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_BEGINRDRAG" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value

				Case $LVN_BEGINSCROLL ; A scrolling operation starts, Minium OS WinXP
					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
					_DebugPrint("$LVN_BEGINSCROLL" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @CRLF & _
							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
					; No return value

				Case $LVN_COLUMNCLICK ; A column was clicked
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_COLUMNCLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
					; No return value

				Case $LVN_COLUMNDROPDOWN; ???
					_DebugPrint("$LVN_COLUMNDROPDOWN" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom)

				Case $LVN_COLUMNOVERFLOWCLICK; ???
					_DebugPrint("$LVN_COLUMNOVERFLOWCLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom)

				Case $LVN_DELETEALLITEMS ; All items in the control are about to be deleted
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_DELETEALLITEMS" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; To suppress subsequent $LVN_DELETEITEM messages
					Return False ; To receive subsequent $LVN_DELETEITEM messages

				Case $LVN_DELETEITEM ; An item is about to be deleted
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_DELETEITEM" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value

				Case $LVN_ENDLABELEDITA ; The end of label editing for an item
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$LVN_ENDLABELEDITA" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; If Text is not empty, return True to set the item's label to the edited text, return false to reject it
;~ 					; If Text is empty the return value is ignored
;~ 					Return True

				Case $LVN_ENDLABELEDITW ; The end of label editing for an item
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$LVN_ENDLABELEDITW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; If Text is not empty, return True to set the item's label to the edited text, return false to reject it
;~ 					; If Text is empty the return value is ignored
;~ 					Return True

				Case $LVN_ENDSCROLL ; A scrolling operation ends, Minium OS WinXP
					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
					_DebugPrint("$LVN_ENDSCROLL" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @CRLF & _
							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
;~ 					; No return value

				Case $LVN_GETDISPINFO, $LVN_GETDISPINFOA ; Provide information needed to display or sort a list-view item
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$LVN_GETDISPINFO,$LVN_GETDISPINFOA" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; No return value

				Case $LVN_GETDISPINFOW; [Unicode] Request for the parent to provide information
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					_DebugPrint("$LVN_GETDISPINFOW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->$Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tInfo, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; No return value

				Case $LVN_GETEMPTYMARKUP; ???
					_DebugPrint("$LVN_GETEMPTYMARKUP" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom)

				Case $LVN_GETINFOTIPA, $LVN_GETINFOTIPW ; Sent by a large icon view list-view control that has the $LVS_EX_INFOTIP extended style
					$tInfo = DllStructCreate($tagNMLVGETINFOTIP, $ilParam)
					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$LVN_GETINFOTIPA, $LVN_GETINFOTIPW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam"))

				Case $LVN_HOTTRACK ; Sent by a list-view control when the user moves the mouse over an item
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_HOTTRACK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
					Return 0 ; allow the list view to perform its normal track select processing.
;~ 					;Return 1 ; the item will not be selected.

				Case $LVN_INCREMENTALSEARCHA; ???
					_DebugPrint("$LVN_INCREMENTALSEARCHA" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom)

				Case $LVN_INCREMENTALSEARCHW; ???
					_DebugPrint("$LVN_INCREMENTALSEARCHW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom)

				Case $LVN_INSERTITEM ; A new item was inserted
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_INSERTITEM" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value

				Case $LVN_ITEMACTIVATE ; Sent by a list-view control when the user activates an item
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$LVN_ITEMACTIVATE" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @CRLF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					Return 0

				Case $LVN_ITEMCHANGED ; An item has changed
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_ITEMCHANGED" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value

				Case $LVN_ITEMCHANGING ; An item is changing
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_ITEMCHANGING" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; prevent the change
					Return False ; allow the change

				Case $LVN_KEYDOWN ; A key has been pressed
					$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
					_DebugPrint("$LVN_KEYDOWN" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->VKey:" & @TAB & DllStructGetData($tInfo, "VKey") & @CRLF & _
							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags"))
					; No return value

				Case $LVN_LINKCLICK ; Vista - a link has been clicked on; ???
					_DebugPrint("$LVN_LINKCLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $LVN_MARQUEEBEGIN ; A bounding box (marquee) selection has begun
					_DebugPrint("$LVN_MARQUEEBEGIN" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
					Return 0 ; accept the message
					;Return 1 ; quit the bounding box selection

				Case $LVN_ODCACHEHINT ; The contents of its display area for a virtual control have changed; ???
					_DebugPrint("$LVN_ODCACHEHINT" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $LVN_ODFINDITEMA ; Sent to the parent when it needs to find a callback item; ???
					_DebugPrint("$LVN_ODFINDITEMA" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
				Case $LVN_ODFINDITEMW ; [Unicode] Sent to the parent when it needs to find a callback item; ???
					_DebugPrint("$LVN_ODFINDITEMW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $LVN_ODFINDITEM, $LVN_ODFINDITEMA; ???
					_DebugPrint("$LVN_ODFINDITEM, $LVN_ODFINDITEMA" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $LVN_ODSTATECHANGED ; The state of an item or range of items in a virtual control has changed; ???
					_DebugPrint("$LVN_ODSTATECHANGED" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $LVN_SETDISPINFOA, $LVN_SETDISPINFOW ; Update the information it maintains for an item
					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$LVN_SETDISPINFOA, $LVN_SETDISPINFOW" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @CRLF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @CRLF & _
							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @CRLF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @CRLF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @CRLF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @CRLF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @CRLF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @CRLF & _
							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @CRLF & _
							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @CRLF & _
							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; No return value

				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_CLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @CRLF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value

				Case $NM_CUSTOMDRAW
					;ConsoleWrite("$NM_CUSTOMDRAW " & $iCode & @CRLF)
					If Not _GUICtrlListView_GetViewDetails($hWndFrom) Then Return $GUI_RUNDEFMSG ; Not in details mode
					Local $iDrawStage, $iItem, $iSubitem, $hDC, $tRect;, $iColor1, $iColor2, $iColor3
					$tInfo = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
					_DebugPrint("$NM_CUSTOMDRAW" & @CRLF & "-->hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->dwDrawStage:" & @TAB & DllStructGetData($tInfo, "dwDrawStage") & @CRLF & _
							"-->hdc:" & @TAB & @TAB & DllStructGetData($tInfo, "hdc") & @CRLF & _
							"-->Lef:" & @TAB & @TAB & DllStructGetData($tInfo, "Lef") & @CRLF & _
							"-->Top:" & @TAB & @TAB & DllStructGetData($tInfo, "Top") & @CRLF & _
							"-->Right:" & @TAB & DllStructGetData($tInfo, "Right") & @CRLF & _
							"-->Bottom:" & @TAB & DllStructGetData($tInfo, "Bottom") & @CRLF & _
							"-->dwItemSpec:" & @TAB & DllStructGetData($tInfo, "dwItemSpec") & @CRLF & _
							"-->uItemState:" & @TAB & DllStructGetData($tInfo, "uItemState") & @CRLF & _
							"-->lItemlParam:" & @TAB & DllStructGetData($tInfo, "lItemlParam") & @CRLF & _
							"-->clrText:" & @TAB & DllStructGetData($tInfo, "clrText") & @CRLF & _
							"-->clrTextBk:" & @TAB & DllStructGetData($tInfo, "clrTextBk") & @CRLF & _
							"-->iSubItem:" & @TAB & DllStructGetData($tInfo, "iSubItem") & @CRLF & _
							"-->dwItemType:" & @TAB & DllStructGetData($tInfo, "dwItemType") & @CRLF & _
							"-->clrFace:" & @TAB & DllStructGetData($tInfo, "clrFace") & @CRLF & _
							"-->iIconEffect:" & @TAB & DllStructGetData($tInfo, "iIconEffect") & @CRLF & _
							"-->iIconPhase:" & @TAB & DllStructGetData($tInfo, "iIconPhase") & @CRLF & _
							"-->iPartId:" & @TAB & DllStructGetData($tInfo, "iPartId") & @CRLF & _
							"-->iStateId:" & @TAB & DllStructGetData($tInfo, "iStateId") & @CRLF & _
							"-->TextLeft:" & @TAB & DllStructGetData($tInfo, "TextLeft") & @CRLF & _
							"-->TextTop:" & @TAB & DllStructGetData($tInfo, "TextTop") & @CRLF & _
							"-->TextRight:" & @TAB & DllStructGetData($tInfo, "TextRight") & @CRLF & _
							"-->TextBottom:" & @TAB & DllStructGetData($tInfo, "TextBottom") & @CRLF & _
							"-->uAlign:" & @TAB & DllStructGetData($tInfo, "uAlign"))

					;ConsoleWrite("$iDrawStage - " & $iDrawStage & @CRLF)
					Switch $iDrawStage
						Case $CDDS_PREPAINT
							ConsoleWrite("$CDDS_PREPAINT  " & $CDDS_PREPAINT & @CRLF)
							Return $CDRF_NOTIFYITEMDRAW

						Case $CDDS_ITEMPREPAINT
							ConsoleWrite("$CDDS_ITEMPREPAINT  " & $CDDS_ITEMPREPAINT & @CRLF)
							Return $CDRF_NOTIFYSUBITEMDRAW

						Case $CDDS_ITEMPOSTPAINT
							ConsoleWrite("$CDDS_ITEMPOSTPAINT  " & $CDDS_ITEMPOSTPAINT & @CRLF)
							; Not handled

						Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
							ConsoleWrite("$CDDS_ITEMPREPAINT, $CDDS_SUBITEM  " & $CDDS_ITEMPREPAINT & ", " & $CDDS_SUBITEM & @CRLF)
							$iItem = DllStructGetData($tInfo, 'dwItemSpec')
							$iSubitem = DllStructGetData($tInfo, 'iSubItem')

							If _GUICtrlListView_GetItemSelected($hWndFrom, $iItem) Then ; Item to draw is selected
								$hDC = _WinAPI_GetDC($hWndFrom)
								$tRect = DllStructCreate($tagRECT)

								; We draw the background when we draw the first item.
								If $iSubitem = 0 Then
									; We must send the message as we want to use the struct. _GUICtrlListView_GetSubItemRect returns an array.
									_SendMessage($hWndFrom, $LVM_GETSUBITEMRECT, $iItem, DllStructGetPtr($tRect))

									DllStructSetData($tRect, "Left", 2)
									_WinAPI_FillRect($hDC, DllStructGetPtr($tRect), _WinAPI_GetStockObject($GRAY_BRUSH)) ; Change the bush here. You can use GDI+ to make your own.
								EndIf

								DllStructSetData($tRect, "Left", 2)
								DllStructSetData($tRect, "Top", $iSubitem)
								_SendMessage($hWndFrom, $LVM_GETSUBITEMRECT, $iItem, DllStructGetPtr($tRect))

								Local $sText = _GUICtrlListView_GetItemText($hWndFrom, $iItem, $iSubitem)
								_WinAPI_SetBkMode($hDC, $TRANSPARENT) ; It uses the background drawn for the first item.

								; Select the font we want to use
								_WinAPI_SelectObject($hDC, _SendMessage($hWndFrom, $WM_GETFONT))

								If $iSubitem = 0 Then
									DllStructSetData($tRect, "Left", DllStructGetData($tRect, "Left") + 2)
								Else
									DllStructSetData($tRect, "Left", DllStructGetData($tRect, "Left") + 6)
								EndIf
								_WinAPI_DrawText($hDC, $sText, $tRect, BitOR($DT_VCENTER, $DT_END_ELLIPSIS, $DT_SINGLELINE))

								_WinAPI_ReleaseDC($hWndFrom, $hDC)

								Return $CDRF_SKIPDEFAULT ; Don't do default processing
							EndIf

							Return $CDRF_NEWFONT ; Let the system do the drawing for non-selected items

						Case BitOR($CDDS_ITEMPOSTPAINT, $CDDS_SUBITEM)
							; Not handled
					EndSwitch

				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_DBLCLK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @CRLF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value

				Case $NM_HOVER ; Sent by a list-view control when the mouse hovers over an item
					_DebugPrint("$NM_HOVER" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
					Return 0 ; process the hover normally
;~ 					;Return 1 ; prevent the hover from being processed

				Case $NM_KILLFOCUS ; The control has lost the input focus
					_DebugPrint("$NM_KILLFOCUS" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
					; No return value

				Case $NM_OUTOFMEMORY; ???
					_DebugPrint("$NM_OUTOFMEMORY" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)

				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_RCLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @CRLF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					;Return 1 ; not to allow the default processing
					Return 0 ; allow the default processing

				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_RDBLCLK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode & @CRLF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @CRLF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @CRLF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @CRLF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @CRLF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @CRLF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @CRLF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @CRLF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @CRLF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing

				Case $NM_RELEASEDCAPTURE ; The control is releasing mouse capture
					_DebugPrint("$NM_RELEASEDCAPTURE" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
					; No return value

				Case $NM_RETURN ; The control has the input focus and that the user has pressed the ENTER key
					_DebugPrint("$NM_RETURN" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing

				Case $NM_SETFOCUS ; The control has received the input focus
					_DebugPrint("$NM_SETFOCUS" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
							"-->Code:" & @TAB & $iCode)
					; No return value
				Case Else
					;If $iCode <> -121 Then
					_DebugPrint(@CRLF & "*****" & @CRLF & "WM_NOTIFY >-< " & $iCode & _
							@CRLF & "msg code: " & $iMsg & _
							@CRLF & "$iwParam: " & $iwParam & _
							@CRLF & "$iwParam: " & $ilParam & @CRLF _
							 & "*****" & @CRLF)
					;EndIf
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	If $Debug_LV Then
		ConsoleWrite( _
				"!===========================================================" & @CRLF & _
				"+======================================================" & @CRLF & _
				"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @CRLF & _
				"+======================================================" & @CRLF)
	EndIf
EndFunc   ;==>_DebugPrint

Func _Call_DllStructDisplay($sStructStr)
	;Author: Ascend4nt
	;
	;requires:
	;#include<_dllstructDisplay.au3>; ascend4ntscode -> http://sites.google.com/site/ascend4ntscode/dllstructdisplay
	;
	;A function to display the contents of a DLL Structure in a ListView format (using _ArrayDisplay)

	If $DllStructDisplay Then
		If _VersionCompare(@AutoItVersion, '3.3.7.0') > 0 Then
			$sStructStr &= "Struct asd;ptr;byte WithInStruct;EndStruct asd;byte"
		EndIf

		Local $stStruct = DllStructCreate($sStructStr)

		If @error Then Exit ConsoleWrite("DLLStructCreate @error=" & @error & @CRLF)
		If Not _DLLStructDisplay($stStruct, $sStructStr, "Randomness") Then
			ConsoleWrite("_DLLStructDisplay failed, @error=" & @error & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Call_DllStructDisplay
