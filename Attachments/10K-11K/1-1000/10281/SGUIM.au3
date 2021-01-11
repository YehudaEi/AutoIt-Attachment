;***********************
; Sample GUI Menu
; Coded by: Dan
; August 2, 2006
; Special Thanks to: gafrost, SmOke_N, Skruge, Paulie, CWorks, and codemyster!
;***********************

#include <GUIConstants.au3>
#include <Misc.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <Process.au3>
FileWrite("c:/blank.txt", "")
Global $oRP

$name = InputBox("Log In", "Please enter your name:")

; GUI
GUICreate("Sample GUI Menu", 400, 400)
GUISetIcon("C:\Program Files\AutoIt3\beta\Icons\au3.ico", 0)
$TagsPageC = GUICtrlCreateLabel('Visit AutoIt WebSite', 1, 293, 200, 20, $SS_CENTER)
GUICtrlSetFont($TagsPageC, 9, 400, 4)
GUICtrlSetColor($TagsPageC, 0x0000ff)

; BANNER
$s_TempFile = _TempFile()
InetGet("                                                          ", $s_TempFile)
GUICtrlCreatePic($s_TempFile, 0, 0, 400, 67)

; SLIDER
GUICtrlCreateLabel("Slider:", 235, 325)
GUICtrlCreateSlider(270, 325, 120, 30)
GUICtrlSetData(-1, 30)

; TEXT
GUICtrlCreateLabel("Sample GUI Menu (SGUIM). AutoItV3. Sample Label ", 10, 275, 389,20)
$label = GUICtrlCreateLabel("Logged in as: " & $name, 150, 75, 400, 14)
;GUICtrlSetStyle (-1, $SS_RIGHT )

; MENU
$filemenu = GUICtrlCreateMenu("File")
$fileitem = GUICtrlCreateMenuitem("Open...", $filemenu)
$recentfilesmenu = GUICtrlCreateMenu("Recent Files", $filemenu)
$separator1 = GUICtrlCreateMenuitem("", $filemenu)
$exititem = GUICtrlCreateMenuitem("Exit", $filemenu)
$filemenu = GUICtrlCreateMenu("AutoIt")
$prog4 = GUICtrlCreateMenuitem("Run AutoIt",$filemenu)
$prog5 = GUICtrlCreateMenuitem("Extras",$filemenu)
$prog1 = GUICtrlCreateMenuitem("Scripts",$filemenu)
$prog2 = GUICtrlCreateMenuitem("Icons",$filemenu)
$sguim1 = GUICtrlCreateMenuitem("Sample GUI Menu V1",$filemenu)
$prog3 = GUICtrlCreateMenuitem("SciTe",$filemenu)
$helpmenu = GUICtrlCreateMenu("About")
$aboutitem = GUICtrlCreateMenuitem("About", $helpmenu)
GUISetState(@SW_Show)

; TAB
GUICtrlCreateTab(1, 70, 400, 190)
$tab1 = GUICtrlCreateTabItem("Intro")
GUICtrlCreateLabel("Welcome to Sample GUI Menu V2." & @CRLF & " " & @CRLF & "Sample Gui Program Is In Launch. This is a sample gui with features such as login, tabs, clickable links, and NotePad Feature! ", 20, 120, 385, 100)
GuiCtrlCreateProgress(15, 220, 150, 20)
GuiCtrlSetData(-1, 74,12)
$var1 = GUICtrlCreateCombo ("Combo Box",169, 205,90, 150)
GuiCtrlSetData($var1, "Item2|Item3","Combo Box")
GuiCtrlCreateLabel("Progress:", 15, 200)
GuiCtrlCreateEdit(@CRLF & "  Sample Edit Control", 265, 185,125,70)
GUICtrlCreateTabItem("Info")
$Edit_1 = GuiCtrlCreateEdit("", 15, 100, 373, 120)
$Button_2 = GuiCtrlCreateButton("New", 20, 220, 100, 30)
$Button_7 = GuiCtrlCreateButton("Open", 120, 220, 100, 30)
$Button_3 = GuiCtrlCreateButton("Save", 220, 220, 100, 30)

GUICtrlCreateTabItem("AutoIt")
$treeview       = GUICtrlCreateTreeView(15, 100, 100, 150, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
$generalitem    = GUICtrlCreateTreeViewitem("General", $treeview)
GUICtrlSetColor(-1, 0x0000C0)
$displayitem    = GUICtrlCreateTreeViewitem("Users", $treeview)
GUICtrlSetColor(-1, 0x0000C0)
$compitem       = GUICtrlCreateTreeViewitem("Computer", $generalitem)
$useritem       = GUICtrlCreateTreeViewitem("User", $generalitem)
$resitem        = GUICtrlCreateTreeViewitem("Resolution", $displayitem)
$otheritem      = GUICtrlCreateTreeViewitem("Other", $displayitem)

GuiCtrlCreateLabel("Latest Version of AutoIt: " &@AutoItVersion &"", 120,230)

Dim $listview, $button, $msg, $i, $ret, $s_item
$listview = GUICtrlCreateListView("Col1|Col2|Col3 ", 120, 100, 210, 100, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
$button = GUICtrlCreateButton ("Value?",120,205,70,20)
$item1=GUICtrlCreateListViewItem("Apple|Pear|Fruit",$listview)
$item2=GUICtrlCreateListViewItem("ABC|123|321",$listview)
$item3=GUICtrlCreateListViewItem("Item1|Item2|Item3",$listview)
$input1=GUICtrlCreateInput("Input Testing!",199,205,100,20)
GUICtrlSetState(-1,$GUI_DROPACCEPTED)  ; to allow drag and dropping
GUISetState()
GUICtrlSetData($item2,"ITEM1")
GUICtrlSetData($item3,"||COL33")
GUICtrlDelete($item1)

_GUICtrlListViewSetItemCount($listview, 20)

$radio1 = GUICtrlCreateRadio ("Radio 1", 332, 205, 60, 20)
$radio2 = GUICtrlCreateRadio ("Radio 2", 332, 235, 60, 20)

$cbox1 = GUICtrlCreateCheckbox ("ChkBox1", 332, 140, 60, 20)
$cbox2 = GUICtrlCreateCheckbox ("ChkBox2", 332, 170, 60, 20)
GUICtrlSetState ($radio2, $GUI_CHECKED)
; GUI MESSAGE        LOOP

GUICtrlCreateTabItem("")  ; end tabitem definition
GUICtrlSetState($tab1, $GUI_SHOW)  ; will be display first

GUISetState()

$installdir=RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt","betaInstallDir")
While 1
	$msg = GUIGetMsg()
	
	Select
		Case $msg = $fileitem
			$file = FileOpenDialog("Choose file...", @TempDir, "All (*.*)")
			If @error <> 1 Then GUICtrlCreateMenuitem($file, $recentfilesmenu)
		Case $msg = $exititem
			ExitLoop
		Case $msg = $GUI_EVENT_CLOSE
;~    $oRP.SaveFile (@ScriptDir & "RichText.rtf", 0)
			Exit
		Case $msg = $TagsPageC
			Run(@ComSpec & ' /c start http://www.autoitscript.com/autoit3', '', @SW_HIDE)
			
		Case $msg = $aboutitem
			MsgBox(0, "About Sample GUI Menu", "Sample GUI Menu V2" & @CRLF & @CRLF & "Created by: JavaScript_Freek" & @CRLF & "" & @CRLF & "©AutoIt")
		Case $msg = $prog1
			Run("explorer.exe " & $installdir & "\Examples")
		Case $msg = $prog2
			Run("explorer.exe " & $installdir & "\Icons")
		Case $msg = $prog3
			
			Run("explorer.exe " & $installdir & "\SciTe")
		Case $msg = $prog4
			Run($installdir & "\AU3Info.exe")
		Case $msg = $prog5
			Run("explorer.exe " & $installdir & "\Extras")
		Case $msg = $GUI_EVENT_CLOSE
			$msg = GuiGetMsg()
		Case $msg = $Button_7
			GUICtrlSetData($Edit_1,Fileread(FileOpenDialog("Select a file to open",@ScriptDir, "All Files (*.*)")))
		Case $msg = $button
			MsgBox(0,"listview item",GUICtrlRead(GUICtrlRead($listview)),2)
		Case $msg = $listview
			MsgBox(0,"listview", "clicked="& GUICtrlGetState($listview),2)
		Case $msg = $radio1 And BitAND(GUICtrlRead($radio1), $GUI_CHECKED) = $GUI_CHECKED
			MsgBox(64, 'Info:', 'You clicked the Radio 1 and it is Checked.')
		Case $msg = $radio2 And BitAND(GUICtrlRead($radio2), $GUI_CHECKED) = $GUI_CHECKED
			MsgBox(64, 'Info:', 'You clicked on Radio 2 and it is Checked.')
		Case $msg = $Cbox1 And BitAND(GUICtrlRead($Cbox1), $GUI_CHECKED) = $GUI_CHECKED
			MsgBox(64, 'Info:', 'You clicked the ChkBox1 and it is Checked.')
		Case $msg = $Cbox2 And BitAND(GUICtrlRead($Cbox2), $GUI_CHECKED) = $GUI_CHECKED
			MsgBox(64, 'Info:', 'You clicked on ChkBox2 and it is Checked.')
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd