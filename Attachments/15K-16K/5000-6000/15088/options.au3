#include <GuiConstants.au3>
#Include <Constants.au3>
#NoTrayIcon


; GUI
GuiCreate("PUP- Options", 400, 400)
GuiSetIcon(@SystemDir & "\cleanmgr.exe", 0)

;TrayIcon----------------------------------------------------------------------------------------------
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
$exititem		= TrayCreateItem("Exit")
TraySetIcon(@SystemDir & "\cleanmgr.exe", 0)
;TrayIcon----------------------------------------------------------------------------------------------

; PIC + Colour----------------------------------------------------------------------------------------------
GUISetBkColor (0x4AB5FF)
GuiCtrlCreatePic("C:\Documents and Settings\Ivan\Desktop\PUPBanner.jpg",0, 0, 400,81) ; left, up, width, hight
GuiCtrlCreatePic("C:\Documents and Settings\Ivan\Desktop\HDD.jpg",200, 100, 113,127) ; left, up, width, hight

; PIC + Colour----------------------------------------------------------------------------------------------

;Menu-------------------------------------------------------------------------------------------------------
; SUB MENU
$SUBMenu = GuiCtrlCreateContextMenu()
GuiCtrlCreateMenuItem("&Prefrences", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuaboutitem1 = GuiCtrlCreateMenuItem("About", $SUBMenu)
$SUBMenuHELPitem = GuiCtrlCreateMenuItem("Help", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuexititem = GuiCtrlCreateMenuItem("&Exit", $SUBMenu)
;Menu-------------------------------------------------------------------------------------------------------




; Body------------------------------------------------------------------------------------------------------
GuiCtrlCreateLabel("Select Disk(s) to sanatise", 50, 100, 150, 20)

; TREEVIEW DrivOP
$DriveOP = GuiCtrlCreateTreeView(70, 130, 41, 80, $TVS_CHECKBOXES)										; is it posiable to get my program to sense how many drives my computer has then disply the aproprout number of check boxes
GuiCtrlCreateTreeViewItem("C:\", $DriveOP)
GuiCtrlSetState(-1, $GUI_CHECKED)
GuiCtrlCreateTreeViewItem("D:\", $DriveOP)
GuiCtrlCreateTreeViewItem("F:\", $DriveOP)
GuiCtrlCreateTreeViewItem("G:\", $DriveOP)
GUICtrlSetColor ($DriveOP,0xD00000)
GUICtrlSetBkColor ($DriveOP,0x4AB5FF)

$VOL = DriveGetLabel("C:\")
$Input_VolumeLabel = GuiCtrlCreateLabel("" & $VOL, 110, 132, 80, 20)

$VOL = DriveGetLabel("D:\")
$Input_VolumeLabel = GuiCtrlCreateLabel("" & $VOL, 110, 148, 80, 20)

$VOL = DriveGetLabel("F:\")
$Input_VolumeLabel = GuiCtrlCreateLabel("" & $VOL, 110, 164, 80, 20)

$VOL = DriveGetLabel("G:\")
$Input_VolumeLabel = GuiCtrlCreateLabel("" & $VOL, 110, 179, 80, 20)

GuiCtrlCreateLabel("Select securaty settings:", 70, 270, 200, 20)
$SecurOP = GuiCtrlCreateCombo("", 70, 285, 250, 21)
GuiCtrlSetData($SecurOP, "Quick|Standered|Classified- DoD 5220-22.M|Top Secret- Guttman Algorithm")			; how do i make the passes item un usable until options (Classified- DoD 5220-22.M or Top Secret- Guttman Algorithm are selected)	
$Nextbutton1 = GuiCtrlCreateButton("Next >", 200, 330, 120, 20)
$Backbutton1 = GuiCtrlCreateButton("< Back", 70, 330, 120, 20)

GuiCtrlCreateLabel("Passes", 340, 270) 												;How do i stop the passes item going lowere than 1 and higher than 35
GuiCtrlCreateInput("2", 340, 285, 40, 20)
GuiCtrlCreateUpDown(-1)

$Hellpbutton1  = GUICtrlCreateButton ("4", 358,358,40,40,$BS_ICON)
GUICtrlSetBkColor ($Hellpbutton1,0x4AB5FF)										;How do i set the Button colour with out losing the pic?
GUICtrlSetImage (-1, "shell32.dll",23)
GuiCtrlCreateLabel("Help", 328, 370)
; Body------------------------------------------------------------------------------------------------------


GuiSetState()



While 1
	$msg = GUIGetMsg()
	

	Select		
		Case $msg = $GUI_EVENT_CLOSE 
			ExitLoop
		Case $msg = $SUBMenuexititem
			ExitLoop


		Case $msg = $Hellpbutton1 
			Msgbox(0,"PUP- Forrmating Help","GUI Menu Test")
			
		Case $msg =	$SUBMenuHELPitem
			Run ( $SUBMenuaboutitem1)										;How do i make Case $msg = $Hellpbutton1 run Case $msg = $SUBMenuHELPitem?
			
		Case $msg = $SUBMenuaboutitem1
			MsgBox(64,"About","WipIT - Data deletion program" & @CRLF & "_________________________________________" & @CRLF & "" & @CRLF & "Copyright 2007, Ivan Nicholson" & @CRLF & "" & @CRLF & "Web: 	                    " & @CRLF & "Email: 	support@WipIT.co.ok")
		

	EndSelect
WEnd


