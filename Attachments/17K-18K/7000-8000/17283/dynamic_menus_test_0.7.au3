#include <GuiConstants.au3>

#include "dynamic_menus 0.7beta.au3"

Opt("MustDeclareVars", 1)

; Gui Control Declarations
Dim $Menu_File[5]
Dim $Menu_Help[5]
Global $BTN_EXIT2, $BTN_EXIT, $msg
Global $Menu_File_Open
Global $Menu_Help_About
Global $Menu_Help_Help
Global $Menu_File_Exit
Global $Menu_File_Sep
Global $Menu_File_Save


Global Const $WM_MOUSEMOVE = 0x0200 

Global $Master_GUI, $Main_GUI2

; Create Main Blank GUI
$Main_GUI2 = GuiCreate("Test GUI!", 600, 400, -1, -1, $WS_POPUP); + $WS_CLIPCHILDREN)
; Graphic for window dragging
GUICtrlCreatePic("gui_top.gif", 0, 0, 600, 15, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
GUISetState(@SW_SHOW, $Main_GUI2)

; Create Dummy Background bar
CreateDynamicMenuBar(0, 25, 600, 15, 1, $Main_GUI2)

; Create all Dynamic Menus FIRST
$Menu_File = GuiCtrlCreateDynamicMenu("File", 0, 25, 40, 15, 100, 60)
$Menu_Help = GuiCtrlCreateDynamicMenu("Help", 40, 25, 40, 15, 75, 46)

; Create all Dynamic Menu ITEMS now
$Menu_File_Open = GuiCtrlCreateDynamicMenuItem("Open...", $Menu_File, 0)
$Menu_File_Save = GuiCtrlCreateDynamicMenuItem("Save", $Menu_File, 1)
$Menu_File_Sep = GuiCtrlCreateDynamicMenuItem("", $Menu_File, 2)
$Menu_File_Exit = GuiCtrlCreateDynamicMenuItem("Exit", $Menu_File, 3)

$Menu_Help_About = GuiCtrlCreateDynamicMenuItem("About", $Menu_Help, 0)
GuiCtrlCreateDynamicMenuItem("", $Menu_Help, 1)
$Menu_Help_Help = GuiCtrlCreateDynamicMenuItem("Help", $Menu_Help, 2)

; Create Master Child Window for your controls
$Master_GUI = GUICreate("", 600, 370, 0, 30, BitOR($WS_CHILD, $WS_TABSTOP), -1, $Main_GUI2)
GUISetBkColor(0xe1e1e1)
$BTN_EXIT = GUICtrlCreateButton("Exit", 20, 60, 60, 20)
$BTN_EXIT2 = GUICtrlCreateButton("Exit", 20, 200, 60, 20)
GUISetState(@SW_SHOW, $Master_GUI)

;EnableMenuHover(50)

While 1
	$msg = GuiGetMsg()
	MenuHoverOn()
	Select
		Case $msg = $Menu_File_Exit Or $msg = $BTN_EXIT Or $msg = $BTN_EXIT2
			Exit
		Case $msg = $Menu_File[0]
			ToggleMenu($Menu_File)
		Case $msg = $Menu_Help[0]
			ToggleMenu($Menu_Help)
		Case $msg = $Menu_File_Open
			ToggleMenu($Menu_File)
			MsgBox(4096, "Opening...", "You would be opening a file or something here!")
		Case Else
			;;;
	EndSelect
	Sleep(10)
WEnd

