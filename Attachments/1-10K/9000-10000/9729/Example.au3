#include <GUIConstants.au3>
#include <GuiListView.au3>

Global $ProcessLabel
Global $ListView
Global $ProcessGUI
Global $ProcessTree
Global Const $WM_NOTIFY = 0x004E
Global Const $NM_FIRST = 0
Global Const $NM_LAST = (-99)
Global Const $NM_OUTOFMEMORY = ($NM_FIRST - 1)
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)

Opt("GUIOnEventMode", 1)

Main_GUI ()

While 1
	Sleep(100)
WEnd

Func Main_GUI ()
	
	GUICreate("Nomad's Example", 400, 200, -1, -1)
	GUISetBkColor(0xC0C0C0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript")
	
	$ProcessLabel = GUICtrlCreateLabel("", 65, 10, 160, 15, $SS_RIGHT)
	
	GUICtrlCreateButton("", 5, 5, 24, 24, $BS_ICON)
	GUICtrlSetOnEvent(-1, "Process_Selector")
	GUICtrlSetImage(-1, "shell32.dll", 15, 0)
	
	$ListView = GUICtrlCreateListView("Data1   |Data2   |Data3   |Data4   ", 5, 30, 390, 165)
	GUICtrlSetOnEvent(-1, "Sort_ListView")
	GUICtrlSetBkColor(-1, 0xC0C0C0)
	GUICtrlCreateListViewItem("Alpha|0x00001000|nothing|6543210", $ListView)
	GUICtrlCreateListViewItem("Bravo|0x00000100|something|9876543210", $ListView)
	GUICtrlCreateListViewItem("Charlie|0x00000010|anything|876543210", $ListView)
	
	GUIRegisterMsg($WM_NOTIFY, "Set_ListView")
	
	GUISetState()
	
EndFunc

Func Process_Selector ()
	
	If WinExists("Select Process To Open") Then
		WinActivate("Select Process To Open")
		Return
	EndIf
	
	$ProcessGUI = GUICreate("Select Process To Open", 230, 190, -1, -1, $WS_CAPTION)
	$ProcessTree = GuiCtrlCreateList("", 0, 0, 230, 150)
	
	Local $i
	Local $Process_List = ProcessList()
	Local $String = $Process_List[1][0]
	
	For $i = 2 to $Process_List[0][0]
		$String &= '|' & $Process_List[$i][0]
	Next
	
	GuiCtrlSetData($ProcessTree, $String)
	
	GUICtrlCreateButton("Open Process", 10, 160, 100, 20)
	GUICtrlSetOnEvent(-1, "Open_Process")
	GUICtrlCreateButton("Cancel", 120, 160, 100, 20)
	GUICtrlSetOnEvent(-1, "Cancel_Open_Process")
	
	GUISetState()

EndFunc

Func Open_Process ()
	
	Local $Selected_Process = GUICtrlRead($ProcessTree, 1)
	
	GUICtrlSetData($ProcessLabel, $Selected_Process[0])
	
	GUIDelete($ProcessGUI)
	
EndFunc

Func Cancel_Open_Process ()
	
	GUIDelete($ProcessGUI)
	
EndFunc

Func Sort_ListView ()
	
	Local $DESCENDING[_GUICtrlListViewGetSubItemsCount($ListView)]
	
	_GUICtrlListViewSort($ListView, $DESCENDING, GUICtrlGetState($ListView))
	
EndFunc

Func Set_ListView ($CtrlHandle, $MsgID, $CtrlID, $LPNMHDR)
	
	If $CtrlID = $ListView Then
		
		Local $NMHDR, $Event
		
		$NMHDR = DllStructCreate("int;int;int", $LPNMHDR)
		If @Error Then Return
		
		$Event = DllStructGetData($NMHDR, 3)
		
		If $Event = $NM_DBLCLK Then
			
			Local $ItemString = _GUICtrlListViewGetItemText($ListView, _GUICtrlListViewGetSelectedIndices($ListView))
			
			If $ItemString <> -1 Then
				
				MsgBox(4096, "Double-Click", "Double-click on listview item detected.")
				
			EndIf
			
		EndIf
		
    EndIf
	
    $NMHDR = 0
    $Event = 0
    $LPNMHDR = 0
	
EndFunc

Func ExitScript ()
	
	Exit
	
EndFunc