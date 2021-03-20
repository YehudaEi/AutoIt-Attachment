#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>
#include <file.au3>
#include <GuiRichEdit.au3>

_Main()

Func _Main()

	Local $maintree, $about, $about_show, $msg, $company
	Local $page1, $page1_show, $page1_open, $page1_read
	Local $page2, $page2_show, $page2_open, $page2_read
	Local $page3, $page3_show, $page3_open, $page3_read
	Local $hRichEdit


; FILES TO DISPLAY

;Company
	;PAGE1 file
	Local $page1_open = FileOpen("c:\it\page1.txt", 0)
	$page1_read = FileRead($page1_open)
	;PAGE2 file
	Local $page2_open = FileOpen ("page2.rtf", 0)
	$page2_read = FileRead ($page2_open)
	;PAGE3 file
	Local $page3_open = FileOpen("c:\it\page3.txt", 0)
	$page3_read = FileRead($page3_open)


;<------------------------------------------------------------------------------------------------------------------------------------------------------


; MAIN GUI
	$hGui = GUICreate("Company Helpdesk Guide", 1100, 685, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_SYSMENU, $WS_MAXIMIZEBOX))


; TreeView main categories
	$maintree = GUICtrlCreateTreeView(10, 10, 150, 640)
	$about = GUICtrlCreateTreeViewItem("About",	$maintree)
	$company = GUICtrlCreateTreeViewItem("Company", $maintree)

; SubCategories (COMPANY)
	$page1 = GUICtrlCreateTreeViewItem("Text file", $company)
	$page2 = GUICtrlCreateTreeViewItem("RTF file", $company)
	$webmail = GUICtrlCreateTreeViewItem("Another Page", $company)


; FrontPage
	$about_show = GUICtrlCreateLabel("Company Helpdesk Guide - v.1.0." & @CRLF & "Copyright" & Chr(169) & "2013 - Company du Nord", 500, 280, 500, 200)

; Make and hide pages

	;Company
		;PAGE 1
	$page1_show = GUICtrlCreateEdit($page1_read, 185, 10, 900, 640, BitOR(0, $ES_READONLY, $WS_VSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)
		;PAGE 2
	$page2_show = _GUICtrlRichEdit_Create($hGui,$page2_read, 185, 10, 900, 640, BitOR($WS_CHILD, $ES_READONLY, $ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	GUICtrlSetState(-1,$GUI_HIDE)
		;PAGE 3
	$page3_show = GUICtrlCreateEdit("Another Page" & @CRLF & $page3_read, 185, 10, 900, 640, BitOR(0, $ES_READONLY, $WS_VSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)


		GUISetState()



; Cases to show and hide pages
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = -3 Or $msg = -1
				_GUICtrlRichEdit_Destroy($hRichEdit)
				ExitLoop

			Case $msg = $about ;(LABEL)
				GUICtrlSetState($page1_show, $GUI_HIDE)
				GUICtrlSetState($page2_show, $GUI_HIDE)
				GUICtrlSetState($about_show, $GUI_SHOW)
				FileClose($page1_open)


			Case $msg = $page1 ;(TEXT FILE)
				GUICtrlSetState($about_show, $GUI_HIDE)
				GUICtrlSetState($page2_show, $GUI_HIDE)
				GUICtrlSetState($page1_show, $GUI_SHOW)
				GUICtrlSetBkColor($page1_show, 0xFFFFFF)
				FileClose($page2_open)

			Case $msg = $page2 ;(RTF FILE)
				GUICtrlSetState($page1_show, $GUI_HIDE)
				GUICtrlSetState($about_show, $GUI_HIDE)
				GUICtrlSetState($page2_show, $GUI_SHOW)
				FileClose($page1_open)

		EndSelect
	WEnd

	GUIDelete()
	Exit
EndFunc   ;==>_Main
