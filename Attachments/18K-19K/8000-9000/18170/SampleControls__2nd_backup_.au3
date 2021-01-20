; AutoIt 3.0.103 example
; 17 Jan 2005 - CyberSlug
; This script shows manual positioning of all controls;
;   there are much better methods of positioning...
#include <GuiConstants.au3>


GuiCreate("Swifts Battle.Net Bot Loader", 400, 400)


$filemenu = GuiCtrlCreateMenu ("File")
$fileitem = GuiCtrlCreateMenuitem ("Load Keys", $filemenu)
$about = GuiCtrlCreateMenuitem ("About", $filemenu)
$keysearch = GUICtrlCreateMenuItem ("Search For CD-Keys", $filemenu)


; MENU 
GuiCtrlCreateMenu("Load Bots 1-5")
GuiCtrlCreateMenu("Load Bots 6-10")
GuiCtrlCreateMenu("Load Bots 11-15")
GuiCtrlCreateMenu("Load All Bots")

; CONTEXT MENU
$contextMenu = GuiCtrlCreateContextMenu()
GuiCtrlCreateMenuItem("Context Menu", $contextMenu)
GuiCtrlCreateMenuItem("", $contextMenu) ;separator
GuiCtrlCreateMenuItem("&Properties", $contextMenu)

; PIC
GuiCtrlCreatePic("logo4.gif",0,0, 169,68)
GuiCtrlSetColor(-1,0xffffff)


; AVI
GUICtrlCreateAvi("sampleAVI.avi",0, 180, 10, 32, 32, $ACS_AUTOPLAY)
GuiCtrlCreateLabel("Battle.Net", 170, 50)


; TAB
GuiCtrlCreateTab(240, 0, 150, 70)
GuiCtrlCreateTabItem("One")
GuiCtrlCreateLabel("Sample Tab with tabItems", 250, 40)
GuiCtrlCreateTabItem("Two")
GuiCtrlCreateLabel("Sample Tab with tabItems", 250, 40)
GuiCtrlCreateTabItem("Three")
GuiCtrlCreateLabel("Sample Tab with tabItems", 250, 40)
GuiCtrlCreateTabItem("")

; PROGRESS
GuiCtrlCreateProgress(60, 80, 150, 20)
GuiCtrlSetData(-1, 70, 1)
GuiCtrlCreateLabel("Progress:", 5, 82)



; LIST
GuiCtrlCreateList("", 5, 190, 100, 90)
GuiCtrlSetData(-1, "Stealthbot|Ruthless Ops|Shieldbot", "b.List")

; ICON
GUICtrlCreateIcon("shell32.dll", 3, 175, 120)
GuiCtrlCreateLabel("Application", 180, 160, 50, 20)

; LIST VIEW
$listView = GuiCtrlCreateListView("Sample|ListView|", 110, 190, 110, 80)
GuiCtrlCreateListViewItem("A|One", $listView)
GuiCtrlCreateListViewItem("B|Two", $listView)
GuiCtrlCreateListViewItem("C|Three", $listView)

; GROUP WITH RADIO BUTTONS
GuiCtrlCreateGroup("Connect To", 230, 120)
GuiCtrlCreateRadio("USEast", 250, 140, 80)
GuiCtrlSetState(-1, $GUI_CHECKED)
GuiCtrlCreateRadio("USWest", 250, 165, 80)
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

; UPDOWN
GuiCtrlCreateLabel("Bots", 350, 115)
GuiCtrlCreateInput("1", 350, 130, 40, 20)
GuiCtrlCreateUpDown(-1)

; SLIDER
GuiCtrlCreateLabel("Flood Control", 235, 215)
GuiCtrlCreateSlider(300, 200, 100, 30)
GuiCtrlSetData(-1, 30)

; INPUT
GuiCtrlCreateCheckbox("", 350, 235, 70, 20)
GuiCtrlCreateLabel("Connect With A Proxy", 235, 240)
GuiCtrlCreateInput("168.581.3:2540", 235, 255, 130, 20)

; BUTTON
$cancelbutton = GuiCtrlCreateButton ("Disconnect All.", 10, 330, 100, 30)

GuiSetState()

While 1
	$msg = GUIGetMsg()
	

	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			ExitLoop
			ExitLoop
		Case $keysearch
			
			
		Case $msg = $fileitem
			$file = FileOpenDialog("Choose txt File Of CD-Keys",@DesktopCommonDir,"All (*.*)")

		Case $msg = $about
			Msgbox(0,"About","GUI Menu Test")
		Case $msg = $keysearch
			GUICreate("Config Editor", 500, 500)
	EndSelect
WEnd

GUIDelete()

Exit
