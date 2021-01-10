#include <GUIConstants.au3>
#include <GuiStatusBar.au3>
#include <Array.au3>
#include <GuiTreeview.au3>

Opt("GuiOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
TraySetClick(16)

Global $Array_Treeview[1][1][1], $Edit_Data, $Temp_Data, $ActiveID, $DatabaseFile = @MyDocumentsDir & "\My Notes.txt"
Global $Button_Prog_Exit, $Button_Copy, $Button_Paste, $Button_Cut, $Temp_SaveTime = "<Not Saved Yet>", $Button_Undo, $Button_Redo
Global $Button_Settings, $Button_Tools, $Button_Open, $Data_Restore, $Button_Note_Delete, $Button_Note_New, $Key
Global $SearchCriteria[2], $Search_Num
$Array_Treeview[0][0][0] = "<"

If FileGetSize($DatabaseFile) = 0 Then
	$FileHandle = FileOpen($DatabaseFile, 1)
	FileWriteLine($FileHandle, "///PNC Database File///")
	FileWriteLine($FileHandle, "")
	FileWriteLine($FileHandle, "[0]")
	FileWriteLine($FileHandle, "My Notes=")
	FileWriteLine($FileHandle, "")
	FileWriteLine($FileHandle, "[//DaTa\\]")
	FileWriteLine($FileHandle, "My Notes=Personal Note Centre, Welcome...")
	FileClose($FileHandle)
EndIf

;~ If Not FileExists(@TempDir & "\PNTbkgrnd.jpg") Then
;~ 	_FileInstall()
;~ EndIf


$FileHandle = FileOpen($DatabaseFile, 1)

#region MainWindow
$MainWindow = GUICreate("Personal Note Centre", 920, 620, -1, -1)
GUICtrlCreatePic(@ScriptDir & "\PNTbkgrnd.jpg", 0, 0, 0, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("Treeview containing your notes...", 18, 85, 250)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 10, 800)
$TreeView = GUICtrlCreateTreeView(10, 110, 245, 460, -1, BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlSetImage(-1, "shell32.dll", 114)
GUICtrlSetCursor(-1, 0)
GUICtrlCreateLabel("Contents of the selected note...", 500, 85, 215, 20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 10, 800)
$Edit_Notes = GUICtrlCreateEdit("", 295, 110, 620, 460, BitOR($WS_VSCROLL, $WS_HSCROLL, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlSetOnEvent(-1, "_EventHandler")

GUICtrlCreateGroup("Notes", 5, 0, 252, 75)
GUICtrlCreateLabel(" Notes", 10, 0, 36, 16)
GUICtrlSetBkColor(-1, 0x2B519C)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlCreateGroup("Edit", 260, 0, 410, 75)
GUICtrlCreateLabel(" Edit", 265, 0, 25, 16)
GUICtrlSetBkColor(-1, 0x385C9A)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlCreateGroup("Miscellaneous", 674, 0, 242, 75)
GUICtrlCreateLabel(" Miscellaneous", 680, 0, 73, 16)
GUICtrlSetBkColor(-1, 0x3156A6)
GUICtrlSetColor(-1, 0xff0000)
_CreateButton("Button_Note_New", 1, "text_file.bmp", "New note")
_CreateButton("Button_Note_Delete", 2, "erase.bmp", "Delete selected note")
_CreateButton("Button_Open", 3, "open_file.bmp", "Import data from another file")
_CreateButton("Button_Copy", 4, "copy.bmp", "Copy selected text")
_CreateButton("Button_Cut", 5, "cut.bmp", "Cut selected text")
_CreateButton("Button_Paste", 6, "Paste.bmp", "Paste previously copied or cut text")
_CreateButton("Button_Prog_Exit", 11, "exit.bmp", "Exit Personal Note Centre")
_CreateButton("Button_Settings", 10, "gear.bmp", "View and adjust program settings")
_CreateButton("Button_Undo", 7, "undo.bmp", "Undo last change")
_CreateButton("Button_Redo", 8, "redo.bmp", "Redo last change")
_CreateButton("Button_Tools", 9, "tools.bmp", "Use the included tools to help you stay organized")

#region Menu
$menu_file = GUICtrlCreateMenu("File")
$Menu_File_New = GUICtrlCreateMenu("New Note", $menu_file)
$Menu_File_New_Sib = GUICtrlCreateMenuitem("Sibling Note", $Menu_File_New)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_File_New_Child = GUICtrlCreateMenuitem("Child Note", $Menu_File_New)
GUICtrlSetOnEvent(-1, "_EventHandler")
$menu_file_openfile = GUICtrlCreateMenuitem("Open File", $menu_file)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_File_Exit = GUICtrlCreateMenuitem("Exit Personal Note Centre", $menu_file)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Tools = GUICtrlCreateMenu("Tools")
$Menu_Tools_Search = GUICtrlCreateMenuitem("Search Notes", $Menu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Tools_Replace = GUICtrlCreateMenuitem("Replace", $Menu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Tools_Convert_Upper = GUICtrlCreateMenuitem("Convert Selected Text To Uppercase", $Menu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Tools_Convert_Lower = GUICtrlCreateMenuitem("Convert Selected Text To Lowercase", $Menu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Tools_Convert_Invert = GUICtrlCreateMenuitem("Invert Case Of Selected Text", $Menu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_Help = GUICtrlCreateMenu("Help")
$Menu_Help_About = GUICtrlCreateMenuitem("About", $Menu_Help)
GUICtrlSetOnEvent(-1, "_EventHandler")
#endregion Menu

#region Context Menu
$CTMenu = GUICtrlCreateContextMenu($Button_Note_New)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_New = GUICtrlCreateMenu("New Note", $CTMenu)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_New_Sib = GUICtrlCreateMenuitem("Sibling Note", $CTMenu_New)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_New_Child = GUICtrlCreateMenuitem("Child Note", $CTMenu_New)
GUICtrlSetOnEvent(-1, "_EventHandler")
#endregion Context Menu

#region ContextTools
$CTMenu_Tools = GUICtrlCreateContextMenu($Button_Tools)
$CTMenu_Tools_Search = GUICtrlCreateMenuitem("Search", $CTMenu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_Tools_Replace = GUICtrlCreateMenuitem("Replace", $CTMenu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_Tools_Invert = GUICtrlCreateMenuitem("Invert Case of Selection", $CTMenu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_Tools_Upper = GUICtrlCreateMenuitem("Convert Selection to Upper Case", $CTMenu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_Tools_Lower = GUICtrlCreateMenuitem("Convert Selection to Lower Case", $CTMenu_Tools)
GUICtrlSetOnEvent(-1, "_EventHandler")
#endregion ContextTools


Local $StatusBar_Width[3] = [210, 740, -1], $StatusBar_Text[3] = ["Current Note: ", "Database Details: ", "Personal Note Centre by marfdaman"]
$StatusBar = _GuiCtrlStatusBarCreate($MainWindow, $StatusBar_Width, $StatusBar_Text)

GUISetOnEvent(-4, "_EventHandler")
GUISetOnEvent(-3, "_EventHandler")
#endregion MainWindow

#region ToolWindow
$ToolWindow_Replace = GUICreate("Replace", 316, 114, -1, -1, -1, -1, $MainWindow)
WinSetOnTop($ToolWindow_Replace, "", 1)
$Input_Tool_1 = GUICtrlCreateInput("", 64, 16, 241, 21, -1, $WS_EX_CLIENTEDGE)
$Input_Tool_2 = GUICtrlCreateInput("", 64, 48, 241, 21, -1, $WS_EX_CLIENTEDGE)
$Button_Go = GUICtrlCreateButton("Go!", 144, 80, 73, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlCreateLabel("Replace:", 0, 18, 55, 17, $SS_RIGHT)
GUICtrlCreateLabel("By:", 8, 52, 45, 17, $SS_RIGHT)
$Button_Cancel = GUICtrlCreateButton("Cancel", 232, 80, 75, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Checkbox_Tool_1 = GUICtrlCreateCheckbox("Case Sensitive", 24, 80, 89, 25)

GUISetOnEvent(-3, "_EventHandler")

;=================================================================================

$ToolWindow_Search = GUICreate("Search", 298, 201, 47, 400, -1, -1, $MainWindow)
WinSetOnTop($ToolWindow_Search, "", 1)
$Input_Tool_3 = GUICtrlCreateInput("", 24, 32, 249, 21, -1, BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$Button_Go_2 = GUICtrlCreateButton("Go!", 32, 168, 89, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Button_Cancel_2 = GUICtrlCreateButton("Cancel", 168, 168, 89, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlCreateLabel("Search:", 125, 8, 41, 17, $SS_RIGHT)
$Checkbox_Tool_2 = GUICtrlCreateCheckbox("Perform Case Sensitive Search", 112, 128, 177, 17)
GUIStartGroup($ToolWindow_Search)
$Radio_Tool_Current = GUICtrlCreateRadio("Current", 16, 85, 63, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Radio_Tool_DataBase = GUICtrlCreateRadio("Database", 16, 120, 75, 17)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUIStartGroup($ToolWindow_Search)
$Radio_Tool_Titles = GUICtrlCreateRadio("Note Titles", 112, 80, 73, 17)
GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Radio_Tool_Data = GUICtrlCreateRadio("Data", 205, 80, 49, 17)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("Database Section:", 104, 64, 185, 41)
GUICtrlCreateGroup("Search Mode:", 8, 64, 89, 89)

GUISetOnEvent(-3, "_EventHandler")
#endregion ToolWindow

#region TrayMenu
$Menu_Tray_Exit = TrayCreateItem("Exit Personal Note Centre")
TrayItemSetOnEvent(-1, "_TrayEventHandler")
TraySetOnEvent(-7, "_TrayEventHandler")
#endregion TrayMenu


GUISwitch($MainWindow)

HotKeySet("{ENTER}", "_Enter")
HotKeySet("{DEL}", "_HotKey_Delete")
HotKeySet("^a", "_SelectAll")

_PopulateTreeview($DatabaseFile)

GUISetState()

While 1
	Sleep(10000)
	If GUICtrlRead($Edit_Notes) <> $Edit_Data Then
		_SaveData()
		$Edit_Data = GUICtrlRead($Edit_Notes)
	EndIf
WEnd


Func _Enter()
	If ControlGetFocus($MainWindow) = "Edit1" And BitAND(WinGetState($MainWindow), 8) Then
		Send(Chr(10))
	Else
		HotKeySet("{ENTER}")
		Send("{ENTER}")
		HotKeySet("{ENTER}", "_Enter")
	EndIf
EndFunc   ;==>_Enter

Func _EventHandler()
	ConsoleWrite(@GUI_CtrlId & @CRLF)
	Switch @GUI_CtrlId
		Case - 3, $Menu_File_Exit, $Button_Prog_Exit
			Switch @GUI_WinHandle
				Case $MainWindow
					_SaveData()
					FileClose($FileHandle)
					Exit
				Case $ToolWindow_Replace, $ToolWindow_Search
					GUISetState(@SW_HIDE, $ToolWindow_Replace)
					GUISetState(@SW_HIDE, $ToolWindow_Search)
			EndSwitch
		Case $Menu_File_New_Child
			_NewNote("Child")
		Case $Menu_File_New_Sib
			_NewNote("Sibling")
		Case $CTMenu_New_Child
			_NewNote("Child")
		Case $CTMenu_New_Sib
			_NewNote("Sibling")
		Case $menu_file_openfile
			_DatabaseOpenFile()
		Case $Menu_Help_About
			MsgBox(64, "About Personal Note Centre", "PNC created by marfdaman.")
		Case $Button_Open
			_DatabaseOpenFile()
		Case $Button_Note_New
			ControlClick($MainWindow, "", $Button_Note_New, "right")
		Case $Button_Note_Delete
			_DeleteNote()
		Case $Button_Copy
;~ 			ControlFocus($MainWindow, "", $Edit_Notes)
;~ 			Send("^c")
			ClipPut(ControlCommand($MainWindow, "", $Edit_Notes, "GetSelected", ""))
			ControlFocus($MainWindow, "", $Edit_Notes)
		Case $Button_Cut
			ClipPut(ControlCommand($MainWindow, "", $Edit_Notes, "GetSelected", ""))
			ControlFocus($MainWindow, "", $Edit_Notes)
			Send("{DEL}")
		Case $Button_Paste
			ControlFocus($MainWindow, "", $Edit_Notes)
			ControlCommand($MainWindow, "", $Edit_Notes, "EditPaste", ClipGet())
		Case $CTMenu_Tools_Invert
			_Invert()
		Case $CTMenu_Tools_Lower
			_Convert("Lower")
		Case $CTMenu_Tools_Upper
			_Convert("Upper")
		Case $CTMenu_Tools_Replace
			GUISetState(@SW_SHOW, $ToolWindow_Replace)
		Case $CTMenu_Tools_Search
			GUISetState(@SW_SHOW, $ToolWindow_Search)
		Case $Menu_Tools_Convert_Upper
			_Convert("Upper")
		Case $Menu_Tools_Convert_Lower
			_Convert("Lower")
		Case $Menu_Tools_Convert_Invert
			_Invert()
		Case $Button_Undo
			$Data_Restore = GUICtrlRead($Edit_Notes)
			ControlFocus($MainWindow, "", $Edit_Notes)
			GUICtrlSendMsg($Edit_Notes, 0x00C7, -1, 0)
		Case $Button_Redo
			GUICtrlSetData($Edit_Notes, $Data_Restore)
		Case $Button_Tools
			MouseClick("right")
		Case $Menu_Tools_Replace
			GUISetState(@SW_SHOW, $ToolWindow_Replace)
		Case $Menu_Tools_Search
			GUISetState(@SW_SHOW, $ToolWindow_Search)
		Case $Button_Cancel
			GUISetState(@SW_HIDE, $ToolWindow_Replace)
		Case $Button_Go
			GUISetState(@SW_HIDE, $ToolWindow_Replace)
			If BitAND(GUICtrlRead($Checkbox_Tool_1), $GUI_CHECKED) Then
				GUICtrlSetData($Edit_Notes, StringReplace(GUICtrlRead($Edit_Notes), GUICtrlRead($Input_Tool_1), GUICtrlRead($Input_Tool_2), 0, 1))
			Else
				GUICtrlSetData($Edit_Notes, StringReplace(GUICtrlRead($Edit_Notes), GUICtrlRead($Input_Tool_1), GUICtrlRead($Input_Tool_2)))
			EndIf
		Case $Button_Go_2
			$SearchCriteria[0] = GUICtrlRead($Input_Tool_3)
			If BitAND(GUICtrlRead($Checkbox_Tool_2), $GUI_CHECKED) Then
				_SearchEdit(1)
			Else
				_SearchEdit(0)
			EndIf
		Case $Button_Cancel_2
			GUISetState(@SW_HIDE, $ToolWindow_Search)
		Case $Radio_Tool_Current
			GUICtrlSetState($Radio_Tool_Titles, $GUI_DISABLE)
			GUICtrlSetState($Radio_Tool_Data, $GUI_DISABLE)
			$Search_Num = 1
		Case $Radio_Tool_DataBase
			GUICtrlSetState($Radio_Tool_Titles, $GUI_ENABLE)
			GUICtrlSetState($Radio_Tool_Data, $GUI_ENABLE)
			$Search_Num = 1
		Case $Radio_Tool_Data, $Radio_Tool_Titles
			$Search_Num = 1
		Case $Button_Tools
			ControlClick($MainWindow, "", $Button_Tools, "right")
		Case - 4
			GUISetState(@SW_HIDE, $MainWindow)
		Case Else
			If GUICtrlRead($TreeView) <> $ActiveID Then
				_SaveData()
				$Pos = __ArraySearch($Array_Treeview, GUICtrlRead($TreeView))
				If Not @error Then
					GUICtrlSetData($Edit_Notes, StringReplace($Array_Treeview[$Pos[0]][$Pos[1]][2], "/C/r\L\f\", @CRLF, 0, 1))
					$ActiveID = GUICtrlRead($TreeView)
					_StatusBarUpdate()
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>_EventHandler

Func _PopulateTreeview($File)
	_DatabaseFileCheck($File)
	Switch @error
		Case 1
			MsgBox(16, "Error", "Error:" & @CRLF & "The selected file is not a PNC database file." & @CRLF & "Aborting import.")
			Return SetError(1, 0, -1)
	EndSwitch
	$DatabaseFile = $File
	ReDim $Array_Treeview[1][1][1]
	$Array_Treeview[0][0][0] = "<"
	_GUICtrlTreeViewDeleteAllItems($TreeView)
	Local $count_sections = IniReadSectionNames($DatabaseFile)
	$count_sections[0] -= 1
	For $i = 0 To $count_sections[0] - 1
		Local $count_keys = IniReadSection($DatabaseFile, $i)
		Global $Temp_Data = IniReadSection($DatabaseFile, "//DaTa\\")
		If $Array_Treeview[0][0][0] = "<" Then ReDim $Array_Treeview[$count_sections[0]][$count_keys[0][0]][4]
		If Not IsArray($count_keys) Then Return
		If $count_keys[0][0] > UBound($Array_Treeview, 2) Then ReDim $Array_Treeview[$count_sections[0]][$count_keys[0][0]][4]
;~ 		MsgBox(0, UBound($Array_Treeview, 1), UBound($Array_Treeview, 2) & " | " & UBound($Array_Treeview, 3))
		If $i = 0 Then
			For $j = 1 To $count_keys[0][0]
				$Temp_CtrlID = GUICtrlCreateTreeViewItem($count_keys[$j][0], $TreeView)
				GUICtrlSetOnEvent(-1, "_EventHandler")
				$Array_Treeview[$i][$j - 1][0] = $count_keys[$j][0]
				$Array_Treeview[$i][$j - 1][1] = $Temp_CtrlID
				$Array_Treeview[$i][$j - 1][2] = $Temp_Data[_DataSearch($count_keys[$j][0]) ][1]
;~ 				MsgBox(0, _DataSearch($count_keys[$j][0]), $count_keys[$j][0])
			Next
		Else
			For $j = 1 To $count_keys[0][0]
				$Pos = __ArraySearchLevel($Array_Treeview, $count_keys[$j][1], $i - 1)
				GUICtrlSetState($Array_Treeview[$i - 1][$Pos][1], $GUI_DEFBUTTON)
				$Temp_CtrlID = GUICtrlCreateTreeViewItem($count_keys[$j][0], $Array_Treeview[$i - 1][$Pos][1])
				GUICtrlSetOnEvent(-1, "_EventHandler")
				$Array_Treeview[$i][$j - 1][0] = $count_keys[$j][0]
				$Array_Treeview[$i][$j - 1][1] = $Temp_CtrlID
				$Array_Treeview[$i][$j - 1][2] = $Temp_Data[_DataSearch($count_keys[$j][0]) ][1]
				$Array_Treeview[$i][$j - 1][3] = $count_keys[$j][1]
;~ 				MsgBox(0, $Temp_CtrlID, $count_keys[$j][1])
			Next
		EndIf
	Next
	_GUICtrlTreeViewSetState($TreeView, $Array_Treeview[0][0][1], 2)
	ControlFocus($MainWindow, "", $TreeView)
	ControlSend($MainWindow, "", $TreeView, "{RIGHT}")
	$Pos = __ArraySearch($Array_Treeview, GUICtrlRead($TreeView))
	GUICtrlSetData($Edit_Notes, StringReplace($Array_Treeview[$Pos[0]][$Pos[1]][2], "/C/r\L\f\", @CRLF, 0, 1))
	$ActiveID = GUICtrlRead($TreeView)
	GUICtrlSetImage($Array_Treeview[0][0][1], "shell32.dll", 84)
	GUICtrlSetColor($Array_Treeview[0][0][1], 0x0000CD)
	_StatusBarUpdate()
EndFunc   ;==>_PopulateTreeview

Func __ArraySearchLevel($Temp_Array, $Temp_Criteria, $Temp_Level, $Temp_Mode = 0)
;~ 	MsgBox(0, $Temp_Criteria, $Temp_Criteria)
	For $Temp_I = 0 To UBound($Temp_Array, 2) - 1
;~ 		MsgBox(0, $Temp_Array[$Temp_Level][$Temp_I][$Temp_Mode], $Temp_Criteria)
		If $Temp_Array[$Temp_Level][$Temp_I][$Temp_Mode] == $Temp_Criteria Then
;~ 			MsgBox(0, "Found: " & $Temp_Array[$Temp_Level][$Temp_I][$Temp_Mode], "ControlID: " & $Temp_Array[$Temp_Level][$Temp_I][1])
			Return $Temp_I
		EndIf
	Next
	Return SetError(1, 0, -1)
EndFunc   ;==>__ArraySearchLevel

Func _NewNote($Mode)
	$Id_Sel = GUICtrlRead($TreeView)
	$Id_Parent = _GUICtrlTreeViewGetParentID($TreeView)
	$Temp_Name = InputBox("New Note", "Specify Note Name:", "", "", 250, 120)
	If $Mode = "Sibling" Then
		$Temp_Level = __ArraySearch($Array_Treeview, $Id_Parent)
		If Not @error Then
			$Temp_CtrlID = GUICtrlCreateTreeViewItem($Temp_Name, $Id_Parent)
			GUICtrlSetOnEvent(-1, "_EventHandler")
			IniWrite($DatabaseFile, $Temp_Level[0] + 1, $Temp_Name, _GUICtrlTreeViewGetText($TreeView, $Id_Parent))
			$Temp = IniReadSection($DatabaseFile, $Temp_Level[0] + 1)
			If $Temp[0][0] > UBound($Array_Treeview, 2) Then
				ReDim $Array_Treeview[UBound($Array_Treeview, 1) ][$Temp[0][0]][4]
;~ 				MsgBox(0, "", "full")
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][0] = $Temp_Name
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][1] = $Temp_CtrlID
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][2] = $Temp_Name
			Else
;~ 				MsgBox(0, "", "not full")
;~ 				MsgBox(64, UBound($Array_Treeview, 2), (UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0])))
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][0] = $Temp_Name
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][1] = $Temp_CtrlID
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][2] = $Temp_Name
			EndIf
		Else
			$Temp_CtrlID = GUICtrlCreateTreeViewItem($Temp_Name, $TreeView)
			GUICtrlSetOnEvent(-1, "_EventHandler")
			IniWrite($DatabaseFile, "0", $Temp_Name, "")
			$Temp = IniReadSection($DatabaseFile, "0")
			If $Temp[0][0] > UBound($Array_Treeview, 2) Then
				ReDim $Array_Treeview[UBound($Array_Treeview, 1) ][$Temp[0][0]][4]
;~ 				MsgBox(0, "", "full")
				$Array_Treeview[0][$Temp[0][0] - 1][0] = $Temp_Name
				$Array_Treeview[0][$Temp[0][0] - 1][1] = $Temp_CtrlID
				$Array_Treeview[0][$Temp[0][0] - 1][2] = $Temp_Name
			Else
;~ 				MsgBox(0, "", "not full")
;~ 				MsgBox(64, UBound($Array_Treeview, 2), (UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0])))
;~ 				$Array_Treeview[$Temp_Level[0]+1][(UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0]))-1][0] = $Temp_Name
;~ 				$Array_Treeview[$Temp_Level[0]+1][(UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0]))-1][1] = $Temp_CtrlID
;~ 				$Array_Treeview[$Temp_Level[0]+1][(UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0]))-1][2] = $Temp_Name
				$Array_Treeview[0][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][0] = $Temp_Name
				$Array_Treeview[0][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][1] = $Temp_CtrlID
				$Array_Treeview[0][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][2] = $Temp_Name
			EndIf
		EndIf
	Else
		$Temp_Level = __ArraySearch($Array_Treeview, $Id_Sel)
		If Not @error Then
			GUICtrlSetState($Id_Sel, $GUI_DEFBUTTON)
			IniReadSection($DatabaseFile, $Temp_Level + 1)
			If @error Then ReDim $Array_Treeview[UBound($Array_Treeview) + 1][UBound($Array_Treeview, 2) ][4]
			$Temp_CtrlID = GUICtrlCreateTreeViewItem($Temp_Name, $Id_Sel)
			GUICtrlSetOnEvent(-1, "_EventHandler")
			IniWrite($DatabaseFile, $Temp_Level[0] + 1, $Temp_Name, _GUICtrlTreeViewGetText($TreeView, $Id_Sel))
			$Temp = IniReadSection($DatabaseFile, $Temp_Level[0] + 1)
			If $Temp[0][0] > UBound($Array_Treeview, 2) Then
				ReDim $Array_Treeview[UBound($Array_Treeview, 1) ][$Temp[0][0]][4]
;~ 				MsgBox(0, "", "full")
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][0] = $Temp_Name
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][1] = $Temp_CtrlID
				$Array_Treeview[$Temp_Level[0] + 1][$Temp[0][0] - 1][2] = $Temp_Name
			Else
;~ 				MsgBox(0, "", "not full")
;~ 				MsgBox(64, UBound($Array_Treeview, 2), (UBound($Array_Treeview, 2)-(UBound($Array_Treeview, 2)-$Temp[0][0])))
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][0] = $Temp_Name
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][1] = $Temp_CtrlID
				$Array_Treeview[$Temp_Level[0] + 1][ (UBound($Array_Treeview, 2) - (UBound($Array_Treeview, 2) - $Temp[0][0])) - 1][2] = $Temp_Name
			EndIf
		EndIf
	EndIf
	IniWrite($DatabaseFile, "//DaTa\\", $Temp_Name, $Temp_Name)
	ControlFocus($MainWindow, "", $TreeView)
	Send("{RIGHT}")
EndFunc   ;==>_NewNote

Func __ArraySearch($Temp_Array, $Temp_Criteria)
	For $Temp_X = 0 To UBound($Temp_Array, 1) - 1
		For $Temp_Y = 0 To UBound($Temp_Array, 2) - 1
			For $Temp_Z = 0 To UBound($Temp_Array, 3) - 2
				If $Temp_Array[$Temp_X][$Temp_Y][$Temp_Z] == $Temp_Criteria Then
					Dim $Array_Return[3] = [$Temp_X, $Temp_Y, $Temp_Z]
;~ 					MsgBox(0, $Array_Return[0], $Array_Return[1] & " | " & $Array_Return[2])
;~ 					MsgBox(0, $Temp_Criteria, $Temp_Array[$Temp_X][$Temp_Y][$Temp_Z])
					Return $Array_Return
				EndIf
			Next
		Next
	Next
	Return SetError(1, 0, -1)
EndFunc   ;==>__ArraySearch

Func _DataSearch($Name)
	For $i = 0 To UBound($Temp_Data) - 1
		If $Temp_Data[$i][0] == $Name Then Return $i
	Next
	SetError(1)
	Return -1
EndFunc   ;==>_DataSearch

Func _SaveData()
	$Pos = __ArraySearch($Array_Treeview, $ActiveID)
	If @error Then Return SetError(1, 1, -1)
	$Array_Treeview[$Pos[0]][$Pos[1]][2] = GUICtrlRead($Edit_Notes)
	IniDelete($DatabaseFile, "//DaTa\\", $Array_Treeview[$Pos[0]][$Pos[1]][0])
	IniWrite($DatabaseFile, "//DaTa\\", $Array_Treeview[$Pos[0]][$Pos[1]][0], StringReplace(GUICtrlRead($Edit_Notes), @CRLF, "/C/r\L\f\"))
	$Temp_SaveTime = @MDAY & "-" & @MON & "-" & @YEAR & " at " & @HOUR & ":" & @MIN & ":" & @SEC
	_StatusBarUpdate()
EndFunc   ;==>_SaveData

Func _CreateButton($buttonname, $number, $iconname, $tooltip)
	Select
		Case $number < 4
			$x = ($number - 1) * 78 + 15
		Case $number > 3 And $number < 9
			$x = ($number - 1) * 78 + 35
		Case $number > 8
			$x = ($number - 1) * 78 + 55
	EndSelect
	Assign($buttonname, GUICtrlCreateButton("", $x, 15, 78, 50, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_BITMAP)), 2)
	GUICtrlSetOnEvent(-1, "_EventHandler")
	GUICtrlSetTip(-1, $tooltip)
	GUICtrlSetImage(-1, @ScriptDir & "\" & $iconname)
	GUICtrlSetCursor(-1, 0)
EndFunc   ;==>_CreateButton

Func _StatusBarUpdate()
	$Temp_Sel = GUICtrlRead($TreeView, 1)
	_GuiCtrlStatusBarSetText($StatusBar, "Current Note: " & $Temp_Sel)
	_GuiCtrlStatusBarSetText($StatusBar, "Database Details: Name = My Notes.txt, Size = " & Round(FileGetSize($DatabaseFile) / 1024, 3) & " KB" _
			 & ", Last Saved On " & $Temp_SaveTime, 1)
EndFunc   ;==>_StatusBarUpdate

Func _FileInstall()
	FileInstall("C:\copy.bmp", @TempDir & "\copy.bmp", 1)
	FileInstall("C:\cut.bmp", @TempDir & "\cut.bmp", 1)
	FileInstall("C:\erase.bmp", @TempDir & "\erase.bmp", 1)
	FileInstall("C:\exit.bmp", @TempDir & "\exit.bmp", 1)
	FileInstall("C:\gear.bmp", @TempDir & "\gear.bmp", 1)
	FileInstall("C:\open_file.bmp", @TempDir & "\open_file.bmp", 1)
	FileInstall("C:\paste.bmp", @TempDir & "\paste.bmp", 1)
	FileInstall("C:\redo.bmp", @TempDir & "\redo.bmp", 1)
	FileInstall("C:\text_file.bmp", @TempDir & "\text_file.bmp", 1)
	FileInstall("C:\tools.bmp", @TempDir & "\tools.bmp", 1)
	FileInstall("C:\undo.bmp", @TempDir & "\undo.bmp", 1)
	FileInstall("C:\PNTbkgrnd.jpg", @TempDir & "\PNTbkgrnd.jpg", 1)
	Run(@ComSpec & " /C start " & FileGetShortName(@AutoItExe), "", @SW_HIDE)
	Exit
EndFunc   ;==>_FileInstall

Func _DeleteNote()
	Local $HasChild = 0, $Choice
	$Sel = GUICtrlRead($TreeView)
	If Not $Sel Then
		MsgBox(48, "Error", "Please select the note to delete...")
		Return SetError(1, 0, -1)
	EndIf
	$Pos = __ArraySearch($Array_Treeview, $Sel)
	If @error Then Return SetError(1, 0, -1)
	$HasChild = _ChildCheck($Pos)
	If $HasChild Then
		$Choice = MsgBox(292, "Warning", "Warning:" & @CRLF & "This note has subnotes attached to it. Are you sure you want to delete it?")
		ConsoleWrite($Choice)
	Else
;~ 		MsgBox(0, "", "no child")
		_Delete($Pos)
		IniDelete($DatabaseFile, "//DaTa\\", $Key)
	EndIf
EndFunc   ;==>_DeleteNote

Func _Delete($Pos)
	IniDelete($DatabaseFile, $Pos[0], $Array_Treeview[$Pos[0]][$Pos[1]][0])
;~ 	IniDelete($DataBaseFile, "//DaTa\\", $Array_Treeview[$Pos[0]][$Pos[1]][0])
	$Key = $Array_Treeview[$Pos[0]][$Pos[1]][0]
	GUICtrlDelete($Array_Treeview[$Pos[0]][$Pos[1]][1])
	Dim $Parent = $Array_Treeview[$Pos[0]][$Pos[1]][3]
	For $i = 0 To 3
		$Array_Treeview[$Pos[0]][$Pos[1]][$i] = ""
	Next
	If __ArraySearchLevel($Array_Treeview, $Parent, $Pos[0], 3) = -1 Then
		GUICtrlSetState($Array_Treeview[$Pos[0] - 1][__ArraySearchLevel($Array_Treeview, $Parent, $Pos[0] - 1, 0) ][1], 0)
	EndIf
EndFunc   ;==>_Delete

Func _HotKey_Delete()
	If ControlGetFocus($MainWindow) = "SysTreeView321" And BitAND(WinGetState($MainWindow), 8) Then
		_DeleteNote()
	Else
		HotKeySet("{DEL}")
		Send("{DEL}")
		HotKeySet("{DEL}", "_HotKey_Delete")
	EndIf
EndFunc   ;==>_HotKey_Delete

Func _LockWin()
	GUISetState(@SW_DISABLE, $MainWindow)
EndFunc   ;==>_LockWin

Func _UnLockWin()
	GUISetState(@SW_ENABLE, $MainWindow)
	WinActivate($MainWindow)
EndFunc   ;==>_UnLockWin

Func _SelectAll()
	If ControlGetFocus($MainWindow) = "Edit1" And BitAND(WinGetState($MainWindow), 8) Then
		ControlSend($MainWindow, "", $Edit_Notes, "{CTRLDOWN}")
		ControlSend($MainWindow, "", $Edit_Notes, "{HOME}")
		ControlSend($MainWindow, "", $Edit_Notes, "{CTRLUP}")
		ControlSend($MainWindow, "", $Edit_Notes, "{SHIFTDOWN}")
		ControlSend($MainWindow, "", $Edit_Notes, "{CTRLDOWN}")
		ControlSend($MainWindow, "", $Edit_Notes, "{END}")
		ControlSend($MainWindow, "", $Edit_Notes, "{CTRLUP}")
		ControlSend($MainWindow, "", $Edit_Notes, "{SHIFTUP}")
	Else
		HotKeySet("^a")
		Send("^a")
		HotKeySet("^a", "_SelectAll")
	EndIf
EndFunc   ;==>_SelectAll

Func _DatabaseOpenFile()
	$File = FileOpenDialog("Select Database File", @MyDocumentsDir, "Text Files (*.txt)|All Files (*.*)", 3, "My Notes.txt")
	If @error Then Return SetError(1, 0, -1)
	_PopulateTreeview($File)
EndFunc   ;==>_DatabaseOpenFile

Func _DatabaseFileCheck($CheckFile)
	If FileReadLine($CheckFile, 1) <> "///PNC Database File///" Then	Return SetError(1, 0, -1)
	$Temp_Count = IniReadSectionNames($CheckFile)
	If Not IsArray($Temp_Count) Then Return SetError(2, 0, -1)
	For $Temp_I = 0 To $Temp_Count[0] - 1
		$Temp_Keys = IniReadSection($CheckFile, $Temp_I)
		If @error Then IniDelete($CheckFile, $Temp_I)
	Next
	Return 1
EndFunc   ;==>_DatabaseFileCheck

Func _ChildCheck($Pos)
	If $Pos[0] < UBound($Array_Treeview, 1) - 1 Then
		If __ArraySearchLevel($Array_Treeview, $Array_Treeview[$Pos[0]][$Pos[1]][0], $Pos[0] + 1, 3) <> - 1 Then Return 1
	EndIf
	Return 0
EndFunc   ;==>_ChildCheck

Func _Convert($Mode)
	$Temp_Text = ControlCommand($MainWindow, "", $Edit_Notes, "GetSelected", "")
	$Temp_Data = GUICtrlRead($Edit_Notes)
	Switch $Mode
		Case "Upper"
			If Not @error Then GUICtrlSetData($Edit_Notes, StringReplace($Temp_Data, $Temp_Text, StringUpper($Temp_Text), 1, 1))
		Case "Lower"
			If Not @error Then GUICtrlSetData($Edit_Notes, StringReplace($Temp_Data, $Temp_Text, StringLower($Temp_Text), 1, 1))
	EndSwitch
EndFunc   ;==>_Convert

Func _Invert()
	$Temp_Text = ControlCommand($MainWindow, "", $Edit_Notes, "GetSelected", "")
	If Not @error Then
		$Temp_Data = GUICtrlRead($Edit_Notes)
		Local $Temp_Copy = $Temp_Text, $Temp_New
		While StringLen($Temp_New) < StringLen($Temp_Copy)
			If StringIsUpper(StringLeft($Temp_Text, 1)) Then
				$Temp_New &= StringLower(StringLeft($Temp_Text, 1))
			Else
				$Temp_New &= StringUpper(StringLeft($Temp_Text, 1))
			EndIf
			$Temp_Text = StringTrimLeft($Temp_Text, 1)
		WEnd
		GUICtrlSetData($Edit_Notes, StringReplace($Temp_Data, $Temp_Copy, $Temp_New, 1, 1))
	EndIf
EndFunc   ;==>_Invert

Func _TrayEventHandler()
	ConsoleWrite("TrayEvent: " & @TRAY_ID & @CRLF)
	Switch @TRAY_ID
		Case $Menu_Tray_Exit
			_SaveData()
			FileClose($FileHandle)
			Exit
		Case - 7
			GUISetState(@SW_SHOW, $MainWindow)
	EndSwitch
EndFunc   ;==>_TrayEventHandler

Func _SearchEdit($CaseSense)
	If BitAND(GUICtrlRead($Radio_Tool_Current), $GUI_CHECKED) Then
		If $SearchCriteria[0] <> $SearchCriteria[1] Or ControlCommand($MainWindow, "", $Edit_Notes, "GetSelected", "") = "" Then $Search_Num = 1
		$Pos = StringInStr(GUICtrlRead($Edit_Notes), $SearchCriteria[0], $CaseSense, $Search_Num)
		If Not $Pos Then Return SetError(1, 0, -1)
;~ 	MsgBox(0, $Pos-1, $Pos+StringLen($SearchCriteria[0])-1)
		ControlFocus($MainWindow, "", $Edit_Notes)
;~ 	GUICtrlSetState($Edit_Notes, $GUI_FOCUS)
		GUICtrlSendMsg($Edit_Notes, 0x00B1, $Pos - 1, $Pos + StringLen($SearchCriteria[0]) - 1)
		GUICtrlSendMsg($Edit_Notes, 0x00B7, 0, 0)
		$Search_Num += 1
	Else
		If $SearchCriteria[0] <> $SearchCriteria[1] Then $Search_Num = 1
		If BitAND(GUICtrlRead($Radio_Tool_Titles), $GUI_CHECKED) Then
			$Temp_CtrlID = __ArraySearch2($Array_Treeview, GUICtrlRead($Input_Tool_3), $CaseSense, 0)
		Else
			$Temp_CtrlID = __ArraySearch2($Array_Treeview, GUICtrlRead($Input_Tool_3), $CaseSense, 2)
		EndIf
		If Not IsArray($Temp_CtrlID) Then
			MsgBox(32, "Warning:", "No more results can be found. Search will be continued from top.")
			If $Search_Num > 1 Then
				$Search_Num = 1
				_SearchEdit($CaseSense)
			EndIf
		Else
			$Search_Num += 1
			If $Temp_CtrlID[0] = UBound($Array_Treeview, 1) - 1 Then
				GUICtrlSetState($Array_Treeview[$Temp_CtrlID[0]][$Temp_CtrlID[1]][1], $GUI_FOCUS)
			ElseIf __ArraySearchLevel($Array_Treeview, $Array_Treeview[$Temp_CtrlID[0]][$Temp_CtrlID[1]][0], $Temp_CtrlID[0] + 1, 3) <> - 1 Then
				GUICtrlSetState($Array_Treeview[$Temp_CtrlID[0]][$Temp_CtrlID[1]][1], $GUI_FOCUS + $GUI_DEFBUTTON)
			Else
				GUICtrlSetState($Array_Treeview[$Temp_CtrlID[0]][$Temp_CtrlID[1]][1], $GUI_FOCUS)
			EndIf
		EndIf
		$Pos = __ArraySearch($Array_Treeview, GUICtrlRead($TreeView))
		If Not @error Then
			GUICtrlSetData($Edit_Notes, StringReplace($Array_Treeview[$Pos[0]][$Pos[1]][2], "/C/r\L\f\", @CRLF, 0, 1))
			$ActiveID = GUICtrlRead($TreeView)
			_StatusBarUpdate()
		EndIf
		If BitAND(GUICtrlRead($Radio_Tool_Data), $GUI_CHECKED) Then
			$Pos = StringInStr(GUICtrlRead($Edit_Notes), $SearchCriteria[0], $CaseSense, 1)
			If Not $Pos Then Return SetError(1, 0, -1)
			ControlFocus($MainWindow, "", $Edit_Notes)
			GUICtrlSendMsg($Edit_Notes, 0x00B1, $Pos - 1, $Pos + StringLen($SearchCriteria[0]) - 1)
			GUICtrlSendMsg($Edit_Notes, 0x00B7, 0, 0)
		EndIf
	EndIf
	$SearchCriteria[1] = $SearchCriteria[0]
	GUISetState(@SW_SHOW, $MainWindow)
EndFunc   ;==>_SearchEdit

Func __ArraySearch2($Temp_Array, $Temp_Criteria, $CaseSense = 0, $Temp_Mode = 0)
	Local $Temp_Count = 1
	For $Temp_I = 0 To UBound($Temp_Array, 1) - 1
		For $Temp_J = 0 To UBound($Temp_Array, 2) - 1
			If StringInStr($Temp_Array[$Temp_I][$Temp_J][$Temp_Mode], $Temp_Criteria, $CaseSense) Then
;~ 				ConsoleWrite($Temp_Count & " | " & $Search_Num & @CRLF)
				If $Temp_Count = $Search_Num Then
					Local $Array_Return[2] = [$Temp_I, $Temp_J]
					Return $Array_Return
				EndIf
				$Temp_Count += 1
			EndIf
		Next
	Next
	Return SetError(1, 0, -1)
EndFunc   ;==>__ArraySearch2
