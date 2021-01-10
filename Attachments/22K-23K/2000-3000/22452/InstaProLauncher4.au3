#include <GUIConstantsEx.au3>
#include <GUITab.au3>
#include <GuiListView.au3>
#include <ButtonConstants.au3>
#include <TabConstants.au3>
#include <TreeViewConstants.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>
#include <EditConstants.au3>

#cs
	Title: InstaPro Launcher
	Version: 1.0.1
	Author: James F Cooper & AutoIT3 Forum Members
	Date: September 20, 2008
	Copyright: Free & Open Source - Use and modify as needed but leave my information in tact and add yours.
	Website:                                 - The Biz Portal Guide!
	****** Description ******
	Introducing "InstaPro Launcher" (IPL)...
	Install Programs Launcher...includes free and open source programs that you will find useful.
	
	Writing useful scripts,
	****** Comments ******
	
	******Updates ******
	Features that will be added in future revisions.
	Date - Description
 	9/29/2008 - Added Edit Control, changed and fixed listview, treeview, combo controls. 
	****** Bugs ******
	Fixes to parts of the program that is not functioning/working properly.
	Date - Description
#ce

Opt('MustDeclareVars', 1)
Local $tab, $tabCount

Local $tab0, $contbutton, $tab0About, $treeview, $generalitem, $mainitem, $aboutitem, $contitem, $helpitem, $pcprotitem, _
		$pcsoftitem, $pclearnitem, $startlabel, $aboutlabel, $continfolabel
Local $tab1, $tab1Install, $combo1, $cb1_itemFL, $cb1_item1a, $cb1_item1b, $cb1_item2a, $cb1_item2b, $cb1_item3a, _
	  $cb1_item3b, $cb1_item4a, $cb1_item4b, $ED1a, $ED1a_txt
Local $tab2, $tab2Dtl, $tab2Dwld, $tab2Install, $tb2lb, $tb2lbtxt, $radio21, $radio22, $radio23, $radio24, $listview21, $item211, _
	  $item212, $item213, $item214, $listview22, $item221, $item222, $item223, $item224, $item225, $item226, $item227, $item228, _
	  $item229, $item2210, $item2211, $item2212, _
	  $listview23, $item231, $item232, $item233, $item234, _
	  $listview24, $item241, $item242, $item243, $item244

Local $tab3, $tab3Install, $radio31, $radio32, $radio33, $radio34, $radio35, $radio36, $radio37

Local $tab4, $tab4Install, $radio41, $radio42, $radio43, $radio44

Local $msg

Main()

Func Main()
	
	GUICreate("InstaPro Launcher", 320, 400) ; will create a dialog box that when displayed is centered

	GUISetBkColor(0xECE9D8)
	GUISetFont(9, 300)

	$tab = GUICtrlCreateTab(1, 0, 319, 400)
	
	;Tab 0 Controls
	$tab0 = GUICtrlCreateTabItem("Main")
	GUICtrlSetState(-1, $GUI_SHOW) ; will be display first
	GUICtrlCreateLabel("Main", 5, 30, 120, 20)
	$treeview = GUICtrlCreateTreeView(5, 50, 130, 150, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
	GUICtrlSetBkColor(-1, 0xFAF8F5)
	$generalitem = GUICtrlCreateTreeViewItem("General", $treeview)
	GUICtrlSetColor(-1, 0x0000C0)
	$mainitem = GUICtrlCreateTreeViewItem("Main", $treeview)
	GUICtrlSetColor(-1, 0x0000C0)
	$aboutitem = GUICtrlCreateTreeViewItem("About", $generalitem)
	$contitem = GUICtrlCreateTreeViewItem("Contact", $generalitem)
	$helpitem = GUICtrlCreateTreeViewItem("Help", $generalitem)
	$pcprotitem = GUICtrlCreateTreeViewItem("PC Protection", $mainitem)
	$pcsoftitem = GUICtrlCreateTreeViewItem("PC Software", $mainitem)
	$pclearnitem = GUICtrlCreateTreeViewItem("PC Learn", $mainitem)
	$startlabel = GUICtrlCreateLabel("Install Program Launcher:" & @LF & @LF & "that has" & _
			" free and open source programs that are useful and best of all FREE.", 160, 50, 150, 125, $SS_CENTER + $WS_THICKFRAME)
	GUICtrlSetBkColor(-1, 0xFAF8F5)
	$aboutlabel = GUICtrlCreateLabel("InstaPro Launcher v1.0" & @LF & @LF & "By: James F Cooper" & @LF & @LF & _
									"With help from AutoIT3 Help File and Forum Members.", 160, 50, 150, 125, _
									$SS_CENTER + $WS_DLGFRAME)
	GUICtrlSetBkColor(-1, 0xFAF8F5)
	GUICtrlSetState(-1, $GUI_HIDE) ; Hides the "aboutlabel"-text during initialization
	$continfolabel = GUICtrlCreateLabel("InstaPro Launcher v1.0" & @LF & @LF & "CoopersBarnYard.net", 160, 50, 150, 125, _
										$SS_CENTER + $WS_DLGFRAME)
	GUICtrlSetBkColor(-1, 0xFAF8F5)
	GUICtrlSetState(-1, $GUI_HIDE) ; Hides the "continfobutton"-text during initialization
	$contbutton = GUICtrlCreateButton("Contact", 260, 180, 50, 20)
	GUICtrlSetState(-1, $GUI_HIDE) ; Hides the "continfobutton"-text during initialization
	GUICtrlSetState($generalitem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON)) ; Expand the "General"-item and paint in bold
	GUICtrlSetState($mainitem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON)) ; Expand the "main"-item and paint in bold
	GUICtrlCreateTabItem("")
	
	;Tab 1 Controls
	$tab1 = GUICtrlCreateTabItem("Help")
	GUICtrlCreateLabel("Help", 5, 30, 100, 20)
	$tab1Install = GUICtrlCreateButton("Help", 265, 375, 50, 20)
	$cb1_itemFL = "Select Question?"
	$cb1_item1a = "Question 1"
	$cb1_item2a = "Question 2"
	$cb1_item3a = "Question 3"
	$cb1_item4a = "Question 4"
	$combo1 = GUICtrlCreateCombo($cb1_itemFL, 5, 50, 308, 15) ; create first item
	$cb1_item1b = GUICtrlSetData(-1, $cb1_item1a, $cb1_itemFL) ; add other item snd set a new default
	$cb1_item2b = GUICtrlSetData(-1, $cb1_item2a)
	$cb1_item3b = GUICtrlSetData(-1, $cb1_item3a)
	$cb1_item4b = GUICtrlSetData(-1, $cb1_item4a)
	$ED1a_txt = "Default Start Label" & @CRLF & @CRLF & "Paragraph 2" & @CRLF & @CRLF & "Paragraph 3"
	$ED1a = GUICtrlCreateEdit($ED1a_txt, 5, 80, 308, 290, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor(-1, 0xFAF8F5)
		
	GUICtrlCreateTabItem("")
	
	;Tab 2 Controls
	$tab2 = GUICtrlCreateTabItem("PC Programs")
	GUICtrlCreateLabel("PC Programs", 5, 30, 120, 20)
	$tb2lbtxt = "Select a category to the left then a programs list will appear at the bottom of the screen. " & _
			"Select the program and click the button option below the list."
	$tb2lb = GUICtrlCreateLabel($tb2lbtxt, 125, 30, 186, 95, $SS_SUNKEN + $SS_CENTER) ;BitAND($SS_SUNKEN, $SS_CENTER))
	;GUICtrlSetBkColor(-1, 0xFAF3F3)
	$tab2Dtl = GUICtrlCreateButton("More Details", 100, 375, 85, 20)
	$tab2Dwld = GUICtrlCreateButton("Download", 187, 375, 75, 20)
	$tab2Install = GUICtrlCreateButton("Install", 265, 375, 50, 20)
	$radio21 = GUICtrlCreateRadio("PC Protection", 5, 50, 120, 20)
	$radio22 = GUICtrlCreateRadio("PC Software", 5, 70, 120, 20)
	$radio23 = GUICtrlCreateRadio("PC Learn", 5, 90, 120, 20)
	$radio24 = GUICtrlCreateRadio("Extra", 5, 110, 120, 20)
	$listview21 = GUICtrlCreateListView("", "", "")
	GUICtrlSetState(-1, $GUI_HIDE)
	$listview22 = GUICtrlCreateListView("", "", "")
	GUICtrlSetState(-1, $GUI_HIDE)
	$listview23 = GUICtrlCreateListView("", "", "")
	GUICtrlSetState(-1, $GUI_HIDE)
	$listview24 = GUICtrlCreateListView("", "", "")
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateTabItem("")
	
	;Tab 3 Controls
	$tab3 = GUICtrlCreateTabItem("WIP")
	GUICtrlCreateLabel("Work In Progress", 5, 30, 120, 20)
	$tab3Install = GUICtrlCreateButton("Install", 265, 375, 50, 20)
	$radio31 = GUICtrlCreateRadio("WIP", 5, 50, 120, 20)
	$radio32 = GUICtrlCreateRadio("WIP", 5, 70, 120, 20)
	$radio33 = GUICtrlCreateRadio("WIP", 5, 90, 120, 20)
	$radio34 = GUICtrlCreateRadio("WIP", 5, 110, 120, 20)
	$radio35 = GUICtrlCreateRadio("WIP", 130, 50, 120, 20)
	$radio36 = GUICtrlCreateRadio("WIP", 130, 70, 120, 20)
	$radio37 = GUICtrlCreateRadio("WIP", 130, 90, 120, 20)
	GUICtrlCreateTabItem("")
	
	;Tab 4 Controls
	$tab4 = GUICtrlCreateTabItem("WIP")
	GUICtrlCreateLabel("Work In Progress", 5, 30, 120, 20)
	$tab4Install = GUICtrlCreateButton("WIP", 265, 375, 50, 20)
	$radio41 = GUICtrlCreateRadio("WIP", 5, 50, 120, 20)
	$radio42 = GUICtrlCreateRadio("WIP", 5, 70, 120, 20)
	$radio43 = GUICtrlCreateRadio("WIP", 5, 90, 120, 20)
	$radio44 = GUICtrlCreateRadio("WIP", 5, 110, 120, 20)
	GUICtrlCreateTabItem("") ; end tabitem definition
	
	GUISetState()
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
				;Tab 0-4 Control Click Identifier
			Case $msg = $tab
				;MsgBox(0, "Tab", "Current Tab: " & GUICtrlRead($tab)+1)
				$tabCount = GUICtrlRead($tab) + 1
				;$nMsg = GUIGetMsg()
				Switch $tabCount
					Case 1
						HideListview1()
						ShowTreeview1()
					Case 2
						HideListview1()
						HideTreeview1()
					Case 3
						HideTreeview1()
					Case 4
						HideListview1()
						HideTreeview1()
					Case 5
						HideListview1()
						HideTreeview1()
				EndSwitch
				;Tab Controls END
				
				;Tab 0 Controls
			Case $msg = $generalitem
				GUIChangeItems($aboutlabel, $continfolabel, $startlabel, $startlabel)
				GUIChangeItems($contbutton, $contbutton, "", "")
			Case $msg = $aboutitem
				GUICtrlSetState($continfolabel, $GUI_HIDE)
				GUIChangeItems($startlabel, $startlabel, $aboutlabel, $aboutlabel)
				GUIChangeItems($contbutton, $contbutton, "", "")
			Case $msg = $contitem
				GUICtrlSetState($contbutton, $GUI_SHOW)
				GUIChangeItems($startlabel, $aboutlabel, $continfolabel, $continfolabel)
			Case $msg = $helpitem
				GUICtrlSetState($tab1, $GUI_SHOW)
			Case $msg = $pcprotitem
				GUICtrlSetState($tab2, $GUI_SHOW)
			Case $msg = $pcsoftitem
				GUICtrlSetState($tab2, $GUI_SHOW)
			Case $msg = $pclearnitem
				GUICtrlSetState($tab2, $GUI_SHOW)
			Case $msg = $contbutton
				ShellExecute("                                                                                     ")
				;Tab 0 Controls END
				
				;Tab 1 Controls
			Case $msg = $combo1
				;MsgBox(0, "Combo State:", "Combo State: " & GUICtrlRead($combo1))
				If GUICtrlRead($combo1) = $cb1_itemFL Then
					MsgBox(0, "Item Default: ", "Combo State: " & GUICtrlRead($combo1))					
					GUICtrlSetData($ED1a, $ED1a_txt)
				ElseIf GUICtrlRead($combo1) = $cb1_item1a Then
					MsgBox(0, "Item 1", "Combo State: " & GUICtrlRead($combo1))
					GUICtrlSetData($ED1a, "Help Files Label" & @CRLF & @CRLF & _
							"Paragraph 4" & @CRLF & @CRLF & _
							"Paragraph 5")
				ElseIf GUICtrlRead($combo1) = $cb1_item2a Then
					MsgBox(0, "Item 2", "Combo State: " & GUICtrlRead($combo1))
					GUICtrlSetData($ED1a, "Paragraph 6" & @CRLF & @CRLF & _
							"Paragraph 7" & @CRLF & @CRLF & _
							"Paragraph 8")
				ElseIf GUICtrlRead($combo1) = $cb1_item3a Then
					MsgBox(0, "Item 3", "Combo State: " & GUICtrlRead($combo1))
					GUICtrlSetData($ED1a, "Paragraph 9" & @CRLF & @CRLF & _
							"Paragraph 10" & @CRLF & @CRLF & _
							"Paragraph 11")
				ElseIf GUICtrlRead($combo1) = $cb1_item4a Then
					MsgBox(0, "Item 4", "Combo State: " & GUICtrlRead($combo1))
					GUICtrlSetData($ED1a, "Paragraph 12" & @CRLF & @CRLF & _
							"Paragraph 13" & @CRLF & @CRLF & _
							"Paragraph 14")
				EndIf
			Case $msg = $tab1Install
				MsgBox(0, "Help", "Help Button Clicked")
				;Tab 1 Controls END
				
				
				;Tab 2 Controls
			Case $msg = $radio21 And BitAND(GUICtrlRead($radio21), $GUI_CHECKED) = $GUI_CHECKED
				GUICtrlSetState($listview22, $GUI_HIDE)
				GUICtrlSetState($listview23, $GUI_HIDE)
				GUICtrlSetState($listview24, $GUI_HIDE)
				$listview21 = GUICtrlCreateListView("NAME | DESCRIPTION ", 10, 130, 300, 235)
				GUICtrlSetState($listview21, $GUI_SHOW)
				;_GUICtrlListView_SetView($listview21, 4) ; Used for multiline list view.
				; Set colors
				GUICtrlSetBkColor(-1, 0xA9A9A9)
				GUICtrlSetBkColor($listview21, $GUI_BKCOLOR_LV_ALTERNATE)
				_GUICtrlListView_RegisterSortCallBack($listview21)
				_GUICtrlListView_SetColumnWidth($listview21, 0, 75)
				_GUICtrlListView_SetColumnWidth($listview21, 1, $LVSCW_AUTOSIZE_USEHEADER)
				$item211 = GUICtrlCreateListViewItem("ClamWin | Anti-Virus", $listview21)
				GUICtrlSetBkColor(-1, 0xE6E6E6)
				$item212 = GUICtrlCreateListViewItem("Winpooch | Spyware", $listview21)
				GUICtrlSetBkColor(-1, 0xE6E6E6)
				$item213 = GUICtrlCreateListViewItem("N/A | N/A", $listview21)
				GUICtrlSetBkColor(-1, 0xE6E6E6)
				$item214 = GUICtrlCreateListViewItem("N/A | N/A", $listview21)
				GUICtrlSetBkColor(-1, 0xE6E6E6)
				;_GUICtrlListView_SetIconSpacing($listview21, 16, 16) ; used to set spacing for multiline listview
			Case $msg = $radio22 And BitAND(GUICtrlRead($radio22), $GUI_CHECKED) = $GUI_CHECKED
				GUICtrlSetState($listview21, $GUI_HIDE)
				GUICtrlSetState($listview23, $GUI_HIDE)
				GUICtrlSetState($listview24, $GUI_HIDE)
				$listview22 = GUICtrlCreateListView("NAME | DESCRIPTION", 10, 130, 300, 235)
				GUICtrlSetState($listview22, $GUI_SHOW)
				; Set colors
				GUICtrlSetBkColor($listview22, $GUI_BKCOLOR_LV_ALTERNATE)
				GUICtrlSetBkColor(-1, 0xC6E1BD)
				_GUICtrlListView_RegisterSortCallBack($listview22)
				_GUICtrlListView_SetColumnWidth($listview22, 0, 75)
				_GUICtrlListView_SetColumnWidth($listview22, 1, $LVSCW_AUTOSIZE_USEHEADER)
				$item221 = GUICtrlCreateListViewItem("AutoIT3 | Programming", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item222 = GUICtrlCreateListViewItem("JustBasic | Programming", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item223 = GUICtrlCreateListViewItem("Reshack | Graphics", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item224 = GUICtrlCreateListViewItem("Hex Color Finder | Grapgics", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item225 = GUICtrlCreateListViewItem("Scriptable Install System | Programming", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item226 = GUICtrlCreateListViewItem("INNO Setup | Programming", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item227 = GUICtrlCreateListViewItem("Adobe Reader | Reader", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item228 = GUICtrlCreateListViewItem("Flash Player | Video", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item229 = GUICtrlCreateListViewItem("Gimp Image | Grapgics", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item2210 = GUICtrlCreateListViewItem("7zip | Zip", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item2211 = GUICtrlCreateListViewItem("Filezilla | FTP", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
				$item2212 = GUICtrlCreateListViewItem("OpenOffice | Doc Suite", $listview22)
				GUICtrlSetBkColor(-1, 0x6FB052)
			Case $msg = $radio23 And BitAND(GUICtrlRead($radio23), $GUI_CHECKED) = $GUI_CHECKED
				GUICtrlSetState($listview21, $GUI_HIDE)
				GUICtrlSetState($listview22, $GUI_HIDE)
				GUICtrlSetState($listview24, $GUI_HIDE)
				$listview23 = GUICtrlCreateListView("NAME | DESCRIPTION", 10, 130, 300, 235)
				GUICtrlSetState($listview23, $GUI_SHOW)
				GUICtrlSetStyle($listview23, (GUICtrlSetImage($listview23, "shell32.dll", 30)))
				GUICtrlSetBkColor(-1, 0xDFC37E)
				_GUICtrlListView_RegisterSortCallBack($listview23)
				_GUICtrlListView_SetColumnWidth($listview23, 0, 75)
				_GUICtrlListView_SetColumnWidth($listview23, 1, $LVSCW_AUTOSIZE_USEHEADER)
				; Set colors
				$item231 = GUICtrlCreateListViewItem("TypeFaster | Typing", $listview23)
				GUICtrlSetImage($listview23, "shell32.dll", 29)
				$item232 = GUICtrlCreateListViewItem("N/A | N/A", $listview23)
				GUICtrlSetImage($listview23, "shell32.dll", 30)
				$item233 = GUICtrlCreateListViewItem("N/A | N/A", $listview23)
				GUICtrlSetImage($listview23, "shell32.dll", 29)
				$item234 = GUICtrlCreateListViewItem("N/A | N/A", $listview23)
				GUICtrlSetImage($listview23, "shell32.dll", 30)
			Case $msg = $radio24 And BitAND(GUICtrlRead($radio24), $GUI_CHECKED) = $GUI_CHECKED
				GUICtrlSetState($listview21, $GUI_HIDE)
				GUICtrlSetState($listview22, $GUI_HIDE)
				GUICtrlSetState($listview23, $GUI_HIDE)
				$listview24 = GUICtrlCreateListView("NAME | DESCRIPTION", 10, 130, 300, 235)
				GUICtrlSetState($listview24, $GUI_SHOW)
				GUICtrlSetBkColor($listview24, 0xFFD6B3)
				_GUICtrlListView_RegisterSortCallBack($listview24)
				_GUICtrlListView_SetColumnWidth($listview24, 0, 75)
				_GUICtrlListView_SetColumnWidth($listview24, 1, $LVSCW_AUTOSIZE_USEHEADER)
				$item241 = GUICtrlCreateListViewItem("N/A | N/A", $listview24)
				GUICtrlSetBkColor(-1, 0xFFD6B3)
				$item242 = GUICtrlCreateListViewItem("N/A | N/A", $listview24)
				GUICtrlSetBkColor(-1, 0xFFD6B3)
				$item243 = GUICtrlCreateListViewItem("N/A | N/A", $listview24)
				GUICtrlSetBkColor(-1, 0xFFD6B3)
				$item244 = GUICtrlCreateListViewItem("N/A | N/A", $listview24)
				GUICtrlSetBkColor(-1, 0xFFD6B3)
			Case $msg = $listview21
				;MsgBox(0, "listview", "clicked=" & GUICtrlGetState($listview21), 2)
				_GUICtrlListView_SortItems($listview21, GUICtrlGetState($listview21))
			Case $msg = $listview22
				;MsgBox(0, "listview", "clicked=" & GUICtrlGetState($listview22), 2)
				_GUICtrlListView_SortItems($listview22, GUICtrlGetState($listview22))
			Case $msg = $listview23
				;MsgBox(0, "listview", "clicked=" & GUICtrlGetState($listview23), 2)
				_GUICtrlListView_SortItems($listview23, GUICtrlGetState($listview23))
			Case $msg = $listview24
				;MsgBox(0, "listview", "clicked=" & GUICtrlGetState($listview24), 2)
				_GUICtrlListView_SortItems($listview24, GUICtrlGetState($listview24))
			Case $msg = $tab2Install
				Select
					Case $radio21 And BitAND(GUICtrlRead($radio21), $GUI_CHECKED) = $GUI_CHECKED
						;MsgBox(64, 'Info:', 'You clicked on Radio 21 and it is Checked.')
						Select
							Case _GUICtrlListView_GetItemSelected($listview21, 0) ;for $item211
								;MsgBox(0, "Listview 21 Item:", GUICtrlRead(GUICtrlRead($listview21)))
								ShellExecute("http://www.clamwin.com/content/view/18/46/")
							Case _GUICtrlListView_GetItemSelected($listview21, 1) ;for $item212
								;MsgBox(0, "Listview 21 Item", GUICtrlRead(GUICtrlRead($listview21)))
								ShellExecute("                                                       ")
							Case _GUICtrlListView_GetItemSelected($listview21, 2) ;for $item213
								;MsgBox(0, "Listview 21 Item", GUICtrlRead(GUICtrlRead($listview21)))
								MsgBox(0, "", "No Program setup")
							Case _GUICtrlListView_GetItemSelected($listview21, 3) ;for $item214
								;MsgBox(0, "Listview 21 Item", GUICtrlRead(GUICtrlRead($listview21)))
								MsgBox(0, "", "No Program setup")
						EndSelect
					Case $radio22 And BitAND(GUICtrlRead($radio22), $GUI_CHECKED) = $GUI_CHECKED
						;MsgBox(64, 'Info:', 'You clicked on Radio 22 and it is Checked.')
						Select
							Case _GUICtrlListView_GetItemSelected($listview22, 0) ;for $item221
								;MsgBox(0, "Listview 22 Item:", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://www.autoitscript.com/autoit3/")
							Case _GUICtrlListView_GetItemSelected($listview22, 1) ;for $item222
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://justbasic.com/download.html")
							Case _GUICtrlListView_GetItemSelected($listview22, 2) ;for $item223
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("                                                          ")
							Case _GUICtrlListView_GetItemSelected($listview22, 3) ;$item224
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://www.tucows.com/preview/240092")
							Case _GUICtrlListView_GetItemSelected($listview22, 4) ;$item225
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://nsis.sourceforge.net/Download")
							Case _GUICtrlListView_GetItemSelected($listview22, 5) ;$item226
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://www.innosetup.com/isdl.php")
							Case _GUICtrlListView_GetItemSelected($listview22, 6) ;$item227
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("                                    ")
							Case _GUICtrlListView_GetItemSelected($listview22, 7) ;$item228
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash")
							Case _GUICtrlListView_GetItemSelected($listview22, 8) ;$item229
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://gimp-win.sourceforge.net/stable.html")
							Case _GUICtrlListView_GetItemSelected($listview22, 9) ;$item2210
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://www.7-zip.org/")
							Case _GUICtrlListView_GetItemSelected($listview22, 10) ;$item2211
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://filezilla-project.org/download.php?type=client")
							Case _GUICtrlListView_GetItemSelected($listview22, 11) ;$item2212
								;MsgBox(0, "Listview 22 Item", GUICtrlRead(GUICtrlRead($listview22)))
								ShellExecute("http://download.openoffice.org/index.htm")
						EndSelect
					Case $radio23 And BitAND(GUICtrlRead($radio23), $GUI_CHECKED) = $GUI_CHECKED
						;MsgBox(64, 'Info:', 'You clicked on Radio 23 and it is Checked.')
						Select
							Case _GUICtrlListView_GetItemSelected($listview23, 0) ;$item231
								;MsgBox(0, "Listview 23 Item:", GUICtrlRead(GUICtrlRead($listview23)))
								ShellExecute("http://www.typefastertypingtutor.com/")
							Case _GUICtrlListView_GetItemSelected($listview23, 1) ;$item232
								MsgBox(0, "Listview 23 Item", GUICtrlRead(GUICtrlRead($listview23)))
							Case _GUICtrlListView_GetItemSelected($listview23, 2) ;$item233
								MsgBox(0, "Listview 23 Item", GUICtrlRead(GUICtrlRead($listview23)))
							Case _GUICtrlListView_GetItemSelected($listview23, 3) ;$item234
								MsgBox(0, "Listview 23 Item", GUICtrlRead(GUICtrlRead($listview23)))
						EndSelect
					Case $radio24 And BitAND(GUICtrlRead($radio24), $GUI_CHECKED) = $GUI_CHECKED
						;MsgBox(64, 'Info:', 'You clicked on Radio 24 and it is Checked.')
						Select
							Case _GUICtrlListView_GetItemSelected($listview24, 0) ;$item241
								MsgBox(0, "Listview 24 Item:", GUICtrlRead(GUICtrlRead($listview24)))
							Case _GUICtrlListView_GetItemSelected($listview24, 1) ;$item242
								MsgBox(0, "Listview 24 Item", GUICtrlRead(GUICtrlRead($listview24)))
							Case _GUICtrlListView_GetItemSelected($listview24, 2) ;$item243
								MsgBox(0, "Listview 24 Item", GUICtrlRead(GUICtrlRead($listview24)))
							Case _GUICtrlListView_GetItemSelected($listview24, 3) ;$item244
								MsgBox(0, "Listview 24 Item", GUICtrlRead(GUICtrlRead($listview24)))
						EndSelect
				EndSelect
				;Tab 2 Controls END
				
				;Tab 3 Controls
			Case $msg = $tab3Install
				Select
					Case $radio31 And BitAND(GUICtrlRead($radio31), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 31 and it is Checked.')
					Case $radio32 And BitAND(GUICtrlRead($radio32), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 32 and it is Checked.')
					Case $radio33 And BitAND(GUICtrlRead($radio33), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 33 and it is Checked.')
					Case $radio34 And BitAND(GUICtrlRead($radio34), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 34 and it is Checked.')
				EndSelect
				;Tab 3 Controls END
				
				;Tab 4 Controls
			Case $msg = $tab4Install
				Select
					Case $radio41 And BitAND(GUICtrlRead($radio41), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 41 and it is Checked.')
					Case $radio42 And BitAND(GUICtrlRead($radio42), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 42 and it is Checked.')
					Case $radio43 And BitAND(GUICtrlRead($radio43), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 43 and it is Checked.')
					Case $radio44 And BitAND(GUICtrlRead($radio44), $GUI_CHECKED) = $GUI_CHECKED
						MsgBox(64, 'Info:', 'You clicked on Radio 44 and it is Checked.')
				EndSelect
				;Tab 4 Controls End
		EndSelect
	WEnd
	_GUICtrlListView_UnRegisterSortCallBack($listview21)
	_GUICtrlListView_UnRegisterSortCallBack($listview22)
	_GUICtrlListView_UnRegisterSortCallBack($listview23)
	_GUICtrlListView_UnRegisterSortCallBack($listview24)
EndFunc   ;==>Main

Func GUIChangeItems($hidestart, $hideend, $showstart, $showend)
	Local $idx

	For $idx = $hidestart To $hideend
		GUICtrlSetState($idx, $GUI_HIDE)
	Next
	For $idx = $showstart To $showend
		GUICtrlSetState($idx, $GUI_SHOW)
	Next
EndFunc   ;==>GUIChangeItems

Func HideListview1()
	GUICtrlSetState($listview21, $GUI_HIDE)
	GUICtrlSetState($listview22, $GUI_HIDE)
	GUICtrlSetState($listview23, $GUI_HIDE)
	GUICtrlSetState($listview24, $GUI_HIDE)
EndFunc   ;==>HideListview1

Func HideTreeview1()
	GUICtrlSetState($treeview, $GUI_HIDE)
	GUICtrlSetState($startlabel, $GUI_HIDE)
	GUICtrlSetState($aboutlabel, $GUI_HIDE)
	GUICtrlSetState($continfolabel, $GUI_HIDE)
	GUICtrlSetState($contbutton, $GUI_HIDE)
EndFunc   ;==>HideTreeview1

Func ShowTreeview1()
	GUICtrlSetState($treeview, $GUI_SHOW)
	GUICtrlSetState($startlabel, $GUI_SHOW)
	GUICtrlSetState($generalitem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON, $GUI_FOCUS))
EndFunc   ;==>ShowTreeview1