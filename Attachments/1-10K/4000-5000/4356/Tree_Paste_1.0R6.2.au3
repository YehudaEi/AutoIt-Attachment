;Tree Paste 1.0
;Written by Vollyman with bunches of help from ligenza
;=============================================================
;about TreePaste
; This program is a sub program for UNPLUS. UNPlus, to describe
; it simply is a program that reprograms the function keys
; on your keyboard (CTRL + F6 thru F11) to perform scripted task to
; save you time. The use of the CTRL key is done to perserve
; functionality of other programs.
; When using TreePaste, the user will
; 1. Click in a field of the application they wish to edit.
; 2. Press CTRL + F10. This will blank out any data in the field.
; 3. In the window that opens, the user will navigate the tree
; to the desired catagory
; 4. A list will appear in the right window, and the user will
; select the item desired
; 5. Click "paste"
;
; This will close TreePaste, and paste the selected data to the
; field from the clipboard.
;
; All the data that appears in the right window is populated by INI
; files. This allows for updates to be performed by users or admins
; without the need to recode the program. The only time the program
; will need recoding is when a catagory is needed to be added.
;--------------
; The following code is used to reprogram the F10 key for treepaste
; You will need to write a program to have this run in a loop to
; keep it active. I put the sleep statements in for I found it makes
; it more stable. I found sometimes it will work too fast, and nothing
; will be pasted to the edit field.
;
; HotKeySet ("^{F10}", "$funct1")
; Func $funct1()
; Send("^a")
; sleep(100)
; Send("^x")
; sleep(100)
; Runwait ("treepaste.exe", "")
; sleep(100)
; Send("^v")
; EndFunc
;========================================================================
;========================================================================
;Begin script.
opt("trayIconHide", 1); Hides the icon in the system tray
#include <GUIConstants.au3>;you will need to include this file
#Include <GuiList.au3>
GUICreate("Tree Paste", 655, 500, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_GROUP, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
;---------------
;Global variables
Global $desktoplist = GUICtrlCreateList("", 350, 10, 300, 450)
;---------------
;context menu
$contextmenu = GUICtrlCreateContextMenu($desktoplist)
$ctmCopy = GUICtrlCreateMenuItem("Copy", $contextmenu)
;main trunk of tree list
$maintree = GUICtrlCreateTreeView(10, 10, 300, 450)
$hardwareitem = GUICtrlCreateTreeViewItem("Hardware", $maintree)
$softwareitem = GUICtrlCreateTreeViewItem("Software", $maintree)
$aboutitem = GUICtrlCreateTreeViewItem("About", $maintree)
;hardware branch
$desktopitem = GUICtrlCreateTreeViewItem("Desktops", $hardwareitem)
$laptopitem = GUICtrlCreateTreeViewItem("Laptops", $hardwareitem)
;Software branch
$itmAtoM = GUICtrlCreateTreeViewItem("A - M", $softwareitem)
$itmNtoZ = GUICtrlCreateTreeViewItem("N - Z", $softwareitem)
;-----------
;buttons
$btnCopy = GUICtrlCreateButton("Copy", 365, 462, 70, 20)
$btnCancel = GUICtrlCreateButton("Cancel", 465, 462, 70, 20)
$btnHelp = GUICtrlCreateButton("Help", 565, 462, 70, 20)
;Ok now we're done adding all the controles to the GUI so we'll show it.
;Even though the default is @SW_SHOW I sometimes enjoy putting it in there just
;to make it perfectly clear what it's doing. This is an example of a useful comment by the way although a bit verbose. ;)
GUISetState(@SW_SHOW)
;
;-----------
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $ctmCopy ;contextmenu copy
			CopyToClip()
			;======================================================
			;
			; Controls
			;
			;======================================================
			;choices in tree that will have no items listed
		Case $msg = $hardwareitem; blanks list
			_GUICtrlListClear ($desktoplist)
		Case $msg = $softwareitem; blanks list
			_GUICtrlListClear ($desktoplist)
			;--------
			;button controls
		Case $msg = $btnCopy
			CopyToClip()
		Case $msg = $btnCancel
			Exit
		Case $msg = $btnHelp
			MsgBox(0, "How to use TreePaste", "1. Click your cursor in the field you wish to paste data to in your application." & @CRLF _
					 & "2. Use the tree menu in the left field to select the catagory." & @CRLF _
					 & "3. Select the item desired in the list on the right." & @CRLF _
					 & "4. Click the Copy button to copy the data to the clipboard" & @CRLF _
					 & "" & @CRLF & " If you do not wish to make a choice, click the cancel button.")
			;------------
			;list controls
		Case $msg = $aboutitem; About window
			MsgBox(0, "About TreePaste", "TreePaste 1.0 designed by Vollyman and ligenza.")
			;hardware controls
		Case $msg = $desktopitem; Desktop,
			_GUICtrlListClear ($desktoplist)
			GUICtrlSetData($desktoplist, "desktop1|desktop2|desktop3"); This is for example purposes. Remark this line
			ClipPut(GUICtrlRead($desktoplist))
		Case $msg = $laptopitem; Laptop
			_GUICtrlListClear ($desktoplist)
			GUICtrlSetData($desktoplist, "laptop1|laptop2|laptop3"); This is for example purposes. Remark this line
			ClipPut(GUICtrlRead($desktoplist))
		Case $msg = $itmAtoM; Software beginning with "A through M"
			_GUICtrlListClear ($desktoplist)
			GUICtrlSetData($desktoplist, "Autoit!|Excel|Frontpage"); This is for example purposes. Remark this line
			ClipPut(GUICtrlRead($desktoplist))
		Case $msg = $itmNtoZ; Software beginning with "N through Z"
			_GUICtrlListClear ($desktoplist)
			GUICtrlSetData($desktoplist, "Outlook|Windows XP|Word"); This is for example purposes. Remark this line
			ClipPut(GUICtrlRead($desktoplist))
	EndSelect
WEnd
;-- Functions
Func CopyToClip()
	;accessing controles is much slower than accessing a variable stored in memory
	$selected = GUICtrlRead($desktoplist)
	If Not ($selected == "") Then ;this prevents copying nothing
		ClipPut($selected)
		Exit
	EndIf
EndFunc
;v6.2 change notes
;Removed the useless GUICtrlSetData($desktoplist, $desktop) calls and removed the unused global var $desktop
