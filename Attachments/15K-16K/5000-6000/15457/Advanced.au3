;========================================================================================
; Description:      PUP Version 1
; Author(s):        Ivan Nicholson 
; Comments:			Smart deletion program: delets files beond recovery including
;					free space, selected files, recomendations and shedueld tasks
;========================================================================================
#include <GuiConstants.au3>
#include <Constants.au3>
#include <GuiListView.au3>
#include <File.au3>

Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1]

Local $ra1, $ra2, $ra3, $m, $i, $r, $s, $fop, $contain
Local $check, $acheck, $rbox1, $rbox2, $rbox3, $rbox4, $rbox5, $rbox6, $rbox7, $rbox8, $rbox9
Local $rbox10, $rbox11, $rbox12, $rbox13, $rbox14, $rbox15, $rbox16, $rbox17, $rbox18, $rbox19
Local $rbox20, $rbox21, $rbox22, $rbox23, $rbox24, $rbox25, $rbox26, $rbox27, $rbox28, $rbox29
Local $rbox30, $rbox31, $rbox32, $rbox33, $rbox34, $rbox35, $rbox36, $rbox37, $rbox38, $rbox39
Local $rbox40, $rbox41, $rbox42, $rbox43, $rbox44, $rbox45, $rbox46, $rbox47, $rbox48, $rbox49
Local $rbox50, $rbox51, $rbox52, $rbox53, $rbox54, $rbox55, $rbox56, $rbox57, $rbox58, $rbox59
Local $rbox60, $rbox61, $rbox62, $rbox63, $rbox64, $rbox65, $rbox66, $rbox67, $rbox68, $rbox69
Local $rbox70, $rbox71, $rbox72, $rbox73, $rbox74, $arr, $mao, $slim3, $total, $drvsel, $larr

If FileExists(@ScriptDir & "\tmp.txt") Then FileDelete(@ScriptDir & "\tmp.txt")

Opt("GUICloseOnESC", 0)
Global $sHotkeyClose = "!x"
HotKeySet($sHotkeyClose, "exitr")

$regr0 = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Cache")
$regr1 = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Cookies")
$regr2 = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "History")
$regr3 = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Recent")
$regr4 = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Local AppData")


;TrayIcon----------------------------------------------------------------------------------------------------------------------------------------------
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)   
Opt("TrayIconHide", 0)

TraySetOnEvent($TRAY_EVENT_PRIMARYUP,"SpecialEvent")
TraySetState()

Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
$exititem		= TrayCreateItem("Exit")
TraySetIcon(@SystemDir & "\cleanmgr.exe", 0)
;TrayIcon----------------------------------------------------------------------------------------------------------------------------------------------

;checks to see if this vertion of the program is all ready running if it is then it will not load------------------------------------------------------
$version = "PUP- Advanced User Options"
If WinExists($version) Then Exit
AutoItWinSetTitle($version)
;checks to see if this vertion of the program is all ready running if it is then it will not load------------------------------------------------------

;creat gui---------------------------------------------------------------------------------------------------------------------------------------------
GUICreate("PUP- Advanced User Options", 620, 540,200,200,-1,$WS_EX_ACCEPTFILES)
;GUISetBkColor (0x4AB5FF)
GuiSetIcon(@SystemDir & "\cleanmgr.exe", 0)
;creat gui---------------------------------------------------------------------------------------------------------------------------------------------

; MENU------------------------------------------------------------------------------------------------------------------------------------------------- 
$filemenu = GuiCtrlCreateMenu ("File")
$Back = GuiCtrlCreateMenuitem ("Back",$filemenu)
$separator1 = GuiCtrlCreateMenuitem ("",$filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit PUP",$filemenu)

$Opmenu = GuiCtrlCreateMenu ("Options")
$Prefmenu = GuiCtrlCreateMenuitem ("Prefrences",$Opmenu)

$Infomenu = GuiCtrlCreateMenu ("Information")
$helpmenu = GuiCtrlCreateMenu ("Help Topics",$Infomenu)
	$Sugmenu = GuiCtrlCreateMenuitem ("Sugested Files Help",$helpmenu)
		$Junkmenu = GuiCtrlCreateMenuitem ("Junk Files Help",$helpmenu)
			$Custmenu = GuiCtrlCreateMenuitem ("Custom Files Help",$helpmenu)
				$Fullmenu = GuiCtrlCreateMenuitem ("Full Disk Sanitization Help",$helpmenu)
					$Empmenu = GuiCtrlCreateMenuitem ("Empty Space Help",$helpmenu)
						$Genmenu = GuiCtrlCreateMenuitem ("General Help",$helpmenu)
$separator2 = GuiCtrlCreateMenuitem ("",$Infomenu)
$Aboutmenu = GuiCtrlCreateMenuitem ("About PUP",$Infomenu)

; SUB MENU
$SUBMenu = GuiCtrlCreateContextMenu()
$SUBMenuprefitem =GuiCtrlCreateMenuItem("&Prefrences", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuaboutitem1 = GuiCtrlCreateMenuItem("About", $SUBMenu)
$SUBMenuHELPitem = GuiCtrlCreateMenuItem("Help", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuexititem = GuiCtrlCreateMenuItem("Exit PUP", $SUBMenu)
;Menu-------------------------------------------------------------------------------------------------------

; MENU------------------------------------------------------------------------------------------------------------------------------------------------- 

$progress = GUICtrlCreateProgress(5, 421, 608, 15)
$combo = GUICtrlCreateCombo("Standard Deletion Method", 5, 443, 200, 150)
GUICtrlSetData($combo, "Zeros|Random-Character|Random-Reverse|Random-Chunk")
$inp1 = GUICtrlCreateInput("1", 290, 444, 40, 20, $ES_READONLY)
GUICtrlCreateLabel("Number of Passes", 335, 448, 100, 20)
$updown = GUICtrlSetLimit(GUICtrlCreateUpdown($inp1), 35, 1); limets selection between 1- 35
$Checkpl = GUICtrlCreateCheckbox("Scramble File Attributes", 485, 445)

$Backbutton1  = IconButton1("Back", 10,478,60,30, 255 )
GUICtrlSetTip( -1, "Back to previus screen")
;GUICtrlSetBkColor ($Backbutton1,0x4AB5FF)

Func IconButton1($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + -5, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$Exitbutton1  = IconButton3("Exit", 70,478,60,30, 240 )
GUICtrlSetTip( -1, "Shut down aplication")
;GUICtrlSetBkColor ($Exitbutton1,0x4AB5FF)

Func IconButton3($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 52, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$Hellpbutton1  = IconButton5("Help", 540,478,60,30, 24 )
GUICtrlSetTip( -1, "Displays help file for the curent screen")
;GUICtrlSetBkColor ($Hellpbutton1,0x4AB5FF)

Func IconButton5($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 50, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

;setup tabs--------------------------------------------------------------------------------------------------------------------------------------------
$tab = GUICtrlCreateTab(5, 5, 610, 410)

;setup tabs--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab1--------------------------------------------------------------------------------------------------------------------------------------------
$tab1 = GUICtrlCreateTabItem("Sugested Files")

$Menugroup = GUICtrlCreateGroup ("Menu",10, 35,156,175)
$tree1 = GUICtrlCreateTreeView (15, 50,150,160); left, up, width, hight
$Filesitem =GUICtrlCreateTreeViewItem ("User Files",$tree1)
$Iternetitem =GUICtrlCreateTreeViewItem ("Iternet Files",$tree1)
$Deleteditem =GUICtrlCreateTreeViewItem ("Deleted & Tempory Files",$tree1)
$Systemitem =GUICtrlCreateTreeViewItem ("Sysetem Files",$tree1)
$Netitem =GUICtrlCreateTreeViewItem ("Network Files",$tree1)
$miscitem =GUICtrlCreateTreeViewItem ("Misc",$tree1)

;Files--------------------------------------------------------------------------------------------------------------------------

$User = GUICtrlCreateListView("File Sugested Options", 170, 35, 435, 175)
GUICtrlSetColor(-1, 0x0074E8)

_GUICtrlListViewSetColumnWidth($User, 0, 430)

$Files1 = GUICtrlCreateListViewItem("My Documents", $User)
$Files2 = GUICtrlCreateListViewItem("Recent Docs History", $User)
$Files3 = GUICtrlCreateListViewItem("Recent Documents", $User)
$Files4 = GUICtrlCreateListViewItem("Open With history", $User)


GUICtrlSendMsg($User, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($User, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
;Files--------------------------------------------------------------------------------------------------------------------------


;Internet--------------------------------------------------------------------------------------------------------------------------

$Iternettree = GUICtrlCreateListView("File Sugested Options", 170, 35, 435, 175)
GUICtrlSetColor(-1, 0x0074E8)
_GUICtrlListViewSetColumnWidth($Iternettree, 0, 410)
$Iternet1 = GUICtrlCreateListViewItem("Search Assistant Autocomplete", $Iternettree)
$Iternet2 =GUICtrlCreateListViewItem("IE Temporary Internet Files", $Iternettree)
$Iternet3 =GUICtrlCreateListViewItem("IE Cookies", $Iternettree)
$Iternet4 =GUICtrlCreateListViewItem("IE History", $Iternettree)
$Iternet5 =GUICtrlCreateListViewItem("IE Recently Typed URLs", $Iternettree)
$Iternet6 =GUICtrlCreateListViewItem("IE Index.dat", $Iternettree)
$Iternet7 =GUICtrlCreateListViewItem("IE Last Download Location", $Iternettree)
$Iternet8 =GUICtrlCreateListViewItem("IE AutoComplete History", $Iternettree)
$Iternet9 =GUICtrlCreateListViewItem("IE 7.0 Autocomplete Passwords", $Iternettree)
$Iternet10 =GUICtrlCreateListViewItem("IE Browser Helper Objects", $Iternettree)
$Iternet11 =GUICtrlCreateListViewItem("IE Toolbar Extensions", $Iternettree)
$Iternet12 =GUICtrlCreateListViewItem("IE Menu Extensions", $Iternettree)
$Iternet13 =GUICtrlCreateListViewItem("IE Publishing Wizard MRU", $Iternettree)
$Iternet14 =GUICtrlCreateListViewItem("FireFox Cache", $Iternettree)
$Iternet15 =GUICtrlCreateListViewItem("FireFox Signons", $Iternettree)
$Iternet16 =GUICtrlCreateListViewItem("FireFox History", $Iternettree)
$Iternet17 =GUICtrlCreateListViewItem("FireFox Cookies", $Iternettree)
$Iternet18 =GUICtrlCreateListViewItem("FireFox Bookmarks", $Iternettree)
$Iternet19 =GUICtrlCreateListViewItem("FireFox Form History", $Iternettree)
$Iternet20 =GUICtrlCreateListViewItem("FireFox Download History", $Iternettree)

GUICtrlSendMsg($Iternettree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($Iternettree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)

;Internet--------------------------------------------------------------------------------------------------------------------------


;Deleted--------------------------------------------------------------------------------------------------------------------------

$Deletedtree = GUICtrlCreateListView("File Sugested Options", 170, 35, 435, 175)
GUICtrlSetColor(-1, 0x0074E8)

_GUICtrlListViewSetColumnWidth($Deletedtree, 0, 430)

$Deleted1 =GUICtrlCreateListViewItem("Recycle Bin", $Deletedtree)
$Deleted2 =GUICtrlCreateListViewItem("Temporary Files", $Deletedtree)

GUICtrlSendMsg($Deletedtree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($Deletedtree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)

;Deleted--------------------------------------------------------------------------------------------------------------------------


;System--------------------------------------------------------------------------------------------------------------------------

$Systemtree = GUICtrlCreateListView("File Sugested Options", 170, 35, 435, 175)
GUICtrlSetColor(-1, 0x0074E8)
_GUICtrlListViewSetColumnWidth($Systemtree, 0, 410)

$System1 = GUICtrlCreateListViewItem("Run History", $Systemtree)
$System2 = GUICtrlCreateListViewItem("User Assist History", $Systemtree)
$System3 = GUICtrlCreateListViewItem("Searched Files MRU", $Systemtree)
$System4 = GUICtrlCreateListViewItem("Memory Dumps", $Systemtree)
$System5 = GUICtrlCreateListViewItem("Windows Log Files", $Systemtree)
$System6 = GUICtrlCreateListViewItem("ARP Cache Entries", $Systemtree)
$System7 = GUICtrlCreateListViewItem("MUI Cache Entries", $Systemtree)
$System8 = GUICtrlCreateListViewItem("Tray Notification Cache", $Systemtree)
$System9 =GUICtrlCreateListViewItem("Clipboard", $Systemtree)

GUICtrlSendMsg($Systemtree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($Systemtree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)

;System--------------------------------------------------------------------------------------------------------------------------

;System--------------------------------------------------------------------------------------------------------------------------

$nettree = GUICtrlCreateListView("File Sugested Options", 170, 35, 435, 175)
GUICtrlSetColor(-1, 0x0074E8)
_GUICtrlListViewSetColumnWidth($nettree, 0, 430)

$netitem1 = GUICtrlCreateListViewItem("Shared Workgroup Printers History", $nettree)
$netitem2 = GUICtrlCreateListViewItem("Workgroup Shares History", $nettree)
$netitem3 = GUICtrlCreateListViewItem("Computer Description History", $nettree)
$netitem4 = GUICtrlCreateListViewItem("Logon User name", $nettree)

GUICtrlSendMsg($nettree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($nettree, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)

;System--------------------------------------------------------------------------------------------------------------------------

For $i = 0 To 28
	_GUICtrlListViewSetCheckState($User, $i, 1)
Next
For $i = 36 To 54
	_GUICtrlListViewSetCheckState($User, $i, 1)
Next

$edit1 = GUICtrlCreateEdit("", 10, 215, 595, 162)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlSetColor(-1, 0x0074E8)
$button1 = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")
$SelectallInt = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")
$SelectallDel = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")
$SelectallSYS = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")
$SelectallNet = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$button2 = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")
$UnSelectallInt = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")
$UnSelectallDel = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")
$UnSelectallSYS = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")
$UnSelectallNet = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")

$button3 = GUICtrlCreateButton("Analyze", 210, 385, 100, 20)
GUICtrlSetTip( -1, "This button will analyze the types and size in (mb) of sugested files stored on your hard disk drive")

$button4 = GUICtrlCreateButton("Delete", 505, 385, 100, 20)
GUICtrlSetTip( -1, "This button delete all of the files you have selected")

$tab =GUICtrlCreateTabitem ("")
;setup tabs1--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab2--------------------------------------------------------------------------------------------------------------------------------------------
$tab2 = GUICtrlCreateTabItem("Junk Files")

$tab2Menugroup = GUICtrlCreateGroup ("Menu",10, 35,156,159)
$tab2tree2 = GUICtrlCreateTreeView (15, 50,150,140); left, up, width, hight
$tab2tempFilesitem1 = GUICtrlCreateTreeViewItem ("Temporary Files",$tab2tree2)
$tab2Backitem1 = GUICtrlCreateTreeViewItem ("Backup Files",$tab2tree2)
$tab2erroritem1 = GUICtrlCreateTreeViewItem ("Error File",$tab2tree2)
$tab2Dioitem1 = GUICtrlCreateTreeViewItem ("Diagnostic Files",$tab2tree2)
$tab2Logtitem1 = GUICtrlCreateTreeViewItem ("Log Files",$tab2tree2)
$tab2Miscitem1 = GUICtrlCreateTreeViewItem ("Misc",$tab2tree2)

$tab2tempFilesitem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2tempFilesitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2tempFilesitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2tempFilesitem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2tempFilesitem, 1, 179)
$filesitem1 = GUICtrlCreateListViewItem("*.??$" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem2 = GUICtrlCreateListViewItem("*.~*" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem3 = GUICtrlCreateListViewItem("~*.*" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem4 = GUICtrlCreateListViewItem("*.*~" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem5 = GUICtrlCreateListViewItem("*._detmp" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem6 = GUICtrlCreateListViewItem("*.syd" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem7 = GUICtrlCreateListViewItem("*.db$" & "|" & "Temporary Files (dBASE)", $tab2tempFilesitem)
$filesitem8 = GUICtrlCreateListViewItem("*.tmp" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem9 = GUICtrlCreateListViewItem("*.bak" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem10 = GUICtrlCreateListViewItem("*.ftg" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem11 = GUICtrlCreateListViewItem("*.fts" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem12 = GUICtrlCreateListViewItem("*.gid" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem13 = GUICtrlCreateListViewItem("*.old" & "|" & "Old Temporary Files", $tab2tempFilesitem)
$filesitem14 = GUICtrlCreateListViewItem("*.---" & "|" & "Temporary Install Files", $tab2tempFilesitem)
$filesitem15 = GUICtrlCreateListViewItem("*.$$$" & "|" & "Temporary Files of Error", $tab2tempFilesitem)
$filesitem16 = GUICtrlCreateListViewItem("*.@@@" & "|" & "Temporary Files of Error", $tab2tempFilesitem)
$filesitem17 = GUICtrlCreateListViewItem("*.wbk" & "|" & "Temporary Files of Word", $tab2tempFilesitem)
$filesitem18 = GUICtrlCreateListViewItem("*.xlk" & "|" & "Temporary Files of Excel", $tab2tempFilesitem)
$filesitem19 = GUICtrlCreateListViewItem("*.?~?" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem20 = GUICtrlCreateListViewItem("*.??~" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem21 = GUICtrlCreateListViewItem("*.?$?" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem22 = GUICtrlCreateListViewItem("*.$db" & "|" & "Temporary Files (dBASE IV)", $tab2tempFilesitem)
$filesitem23 = GUICtrlCreateListViewItem("*.00*" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem24 = GUICtrlCreateListViewItem("*.shd" & "|" & "Temporary Files", $tab2tempFilesitem)
$filesitem25 = GUICtrlCreateListViewItem("0*.nch" & "|" & "Temporary File Create by MS Outlook Express", $tab2tempFilesitem)
$filesitem26 = GUICtrlCreateListViewItem("mscreate.dir" & "|" & "Temporary Install Files", $tab2tempFilesitem)
$filesitem27 = GUICtrlCreateListViewItem("*.dmp" & "|" & "Temporary Memory Mirror Files", $tab2tempFilesitem)
$filesitem28 = GUICtrlCreateListViewItem("twain???.mtx" & "|" & "TWAIN Temporary file", $tab2tempFilesitem)
$filesitem29 = GUICtrlCreateListViewItem("*.pch" & "|" & "VisualBasic Temp File", $tab2tempFilesitem)
$filesitem30 = GUICtrlCreateListViewItem("*.ncb" & "|" & "VisualBasic Temp File", $tab2tempFilesitem)
$filesitem31 = GUICtrlCreateListViewItem("*.ilk" & "|" & "VisualBasic Temp File", $tab2tempFilesitem)
$filesitem32 = GUICtrlCreateListViewItem("*.exp" & "|" & "VisualBasic Temp File", $tab2tempFilesitem)
$filesitem33 = GUICtrlCreateListViewItem("*.ilc" & "|" & "C++ Temp File", $tab2tempFilesitem)
$filesitem34 = GUICtrlCreateListViewItem("*.ild" & "|" & "C++ Temp File", $tab2tempFilesitem)
$filesitem35 = GUICtrlCreateListViewItem("*.ils" & "|" & "C++ Temp File", $tab2tempFilesitem)
$filesitem36 = GUICtrlCreateListViewItem("*.ilf" & "|" & "C++ Temp File", $tab2tempFilesitem)
$filesitem37 = GUICtrlCreateListViewItem("*.tds" & "|" & "C++ Temp File", $tab2tempFilesitem)


$tab2tempFilesitemButton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2tempFilesitemButton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")




$tab2Backitem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2Backitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2Backitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2Backitem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2Backitem, 1, 179)
$Backitem1 = GUICtrlCreateListViewItem("*.prv" & "|" & "Backup Files", $tab2Backitem)
$Backitem2 = GUICtrlCreateListViewItem("*.nav" & "|" & "Backup Files", $tab2Backitem)
$Backitem3 = GUICtrlCreateListViewItem("*.cpy" & "|" & "Backup Files", $tab2Backitem)
$Backitem4 = GUICtrlCreateListViewItem("*.bac" & "|" & "Backup Files", $tab2Backitem)
$Backitem5 = GUICtrlCreateListViewItem("*.back*" & "|" & "Backup Files", $tab2Backitem)
$Backitem6 = GUICtrlCreateListViewItem("*.bup" & "|" & "Backup Files", $tab2Backitem)
$Backitem7 = GUICtrlCreateListViewItem("*.MS" & "|" & "Microsoft Product Backup Files", $tab2Backitem)


$tab2BackitemButton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2BackitemButton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")



$tab2erroritem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2erroritem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2erroritem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2erroritem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2erroritem, 1, 179)
$erroritem1 = GUICtrlCreateListViewItem("*.err" & "|" & "Error File", $tab2erroritem)


$tab2erroritembutton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2erroritembutton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")


$tab2Dioitem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2Dioitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2Dioitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2Dioitem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2Dioitem, 1, 179)
$Dioitem1 = GUICtrlCreateListViewItem("Thumbs.db" & "|" & "Windows Picture Cache", $tab2Dioitem)
$Dioitem2 = GUICtrlCreateListViewItem("system.1st" & "|" & "Windows diagnostic file", $tab2Dioitem)
$Dioitem3 = GUICtrlCreateListViewItem("suhdlog.dat" & "|" & "Windows diagnostic file", $tab2Dioitem)
$Dioitem4 = GUICtrlCreateListViewItem("modemdet.txt" & "|" & "Windows diagnostic file", $tab2Dioitem)


$tab2Dioitembutton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2Dioitembutton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")


$tab2Logtitem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2Logtitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2Logtitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2Logtitem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2Logtitem, 1, 179)
$Logtitem1 = GUICtrlCreateListViewItem("*log.txt" & "|" & "Log Files", $tab2Logtitem)

$tab2Logtitembutton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2Logtitembutton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")


$tab2Miscitem = GUICtrlCreateListView("Type | Info", 170, 35, 350, 160) 
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($tab2Miscitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($tab2Miscitem, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($tab2Miscitem, 0, 150)
_GUICtrlListViewSetColumnWidth($tab2Miscitem, 1, 179)
$Miscitem1 = GUICtrlCreateListViewItem("*.sik" & "|" & "Potential junk", $tab2Miscitem)
$Miscitem2 = GUICtrlCreateListViewItem("*.sdi" & "|" & "Archive Content File", $tab2Miscitem)
$Miscitem3 = GUICtrlCreateListViewItem("*.fnd" & "|" & "Find Result Files", $tab2Miscitem)
$Miscitem4 = GUICtrlCreateListViewItem("*.fic" & "|" & "Potential junk", $tab2Miscitem)
$Miscitem5 = GUICtrlCreateListViewItem("*._dd" & "|" & "Unkown", $tab2Miscitem)
$Miscitem6 = GUICtrlCreateListViewItem("*.bk?" & "|" & "Potential junk", $tab2Miscitem)
$Miscitem7 = GUICtrlCreateListViewItem("*__ofidx*.*" & "|" & "Microsoft Find Fast Indexer File", $tab2Miscitem)
$Miscitem8 = GUICtrlCreateListViewItem("0???????.nch" & "|" & "News Group Files", $tab2Miscitem)
$Miscitem9 = GUICtrlCreateListViewItem("iebak.dat" & "|" & "Internet Explorer Junk File", $tab2Miscitem)
$Miscitem10 = GUICtrlCreateListViewItem("file_id.diz" & "|" & "Description File of Software", $tab2Miscitem)
$Miscitem11 = GUICtrlCreateListViewItem("ffastun.*" & "|" & "Microsoft Find Fast Indexer File", $tab2Miscitem)
$Miscitem12 = GUICtrlCreateListViewItem("pspbrwse.jbf" & "|" & "Paint Shop Folder Image Information Cache File", $tab2Miscitem)
$Miscitem13 = GUICtrlCreateListViewItem("Foxmail.msg" & "|" & "Foxmail Message File", $tab2Miscitem)
$Miscitem14 = GUICtrlCreateListViewItem("data.bak" & "|" & "Microsoft Office Data file", $tab2Miscitem)
$Miscitem15 = GUICtrlCreateListViewItem("insider.bak" & "|" & "Microsoft Money Data File", $tab2Miscitem)
$Miscitem16 = GUICtrlCreateListViewItem("OPA11.BAK" & "|" & "Microsoft Office FrontPage 2003 Data File", $tab2Miscitem)

$tab2Miscitembutton1 = GUICtrlCreateButton("Select All", 10, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$tab2Miscitembutton2 = GUICtrlCreateButton("UnSelect All", 110, 200, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")

$button10 = GUICtrlCreateButton("Analyze", 210, 200, 100, 20)
GUICtrlSetTip( -1, "This button will analyze the types and size in (mb) of sugested files stored on your hard disk drive")

; Creats a list of drives on the computer ------------------------------------------------------------------------------------------------------------------------
$list4 = GUICtrlCreateListView("Drives", 525, 35, 80, 160, $LVS_SHOWSELALWAYS)
_GUICtrlListViewSetColumnWidth($list4, 0, 59)
GUICtrlSendMsg($list4, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($list4, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
$drives = DriveGetDrive("Fixed"); look for fixed hdd				
For $i = 1 To $drives[0]
	GUICtrlCreateListViewItem(StringUpper($drives[$i]), $list4)
Next
_GUICtrlListViewSetItemSelState($list4, 0)
$drives = DriveGetDrive("Removable"); look for removable hdd
If Not @error Then
	For $i = 1 To $drives[0]
		GUICtrlCreateListViewItem(StringUpper($drives[$i]), $list4)
	Next
EndIf
; Creats a list of drives on the computer ------------------------------------------------------------------------------------------------------------------------
$list5 = GUICtrlCreateListView("Size | File(s) Found", 10, 227, 595, 150)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlSetColor(-1, 0x0074E8)
GUICtrlSendMsg($list5, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlSendMsg($list5, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($list5, 0, 80)
_GUICtrlListViewSetColumnWidth($list5, 1, 495)

$button8 = GUICtrlCreateButton("Select All", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to select all of the visiable check box options")

$button9 = GUICtrlCreateButton("UnSelect All", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to Un-select all of the visiable check box options")

$button11 = GUICtrlCreateButton("Delete", 505, 385, 100, 20)
GUICtrlSetTip( -1, "This button delete all of the files you have selected")

;setup tab2--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab3--------------------------------------------------------------------------------------------------------------------------------------------
$tab3 = GUICtrlCreateTabItem("Custom Files")
$listview = GUICtrlCreateListView("File Name | Size | Risk", 10, 35, 595, 342)
GUICtrlSetState(-1,$GUI_DROPACCEPTED); to allow drag and dropping
$nItem = GUICtrlCreateListViewItem("Drag files into the window or use the Add Files button to make your selection",$listview)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListViewSetColumnWidth($listview, 0, 460)
_GUICtrlListViewSetColumnWidth($listview, 1, 80)
$button31 = GUICtrlCreateButton("Add Files", 10, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to add indevidual files you wish to delete to the list above")

$button32 = GUICtrlCreateButton("Remove Form List", 110, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to remove an indevidual file from the list above")

$button33 = GUICtrlCreateButton("Remove All", 210, 385, 100, 20)
GUICtrlSetTip( -1, "This button allows you to remove all the file from the list above")

$prioratize = GUICtrlCreateButton("Prioratise", 400, 385, 100, 20)
GUICtrlSetTip( -1, "This button prioraises the files you have sulected acording to risk" & @CRLF & " 1 to 5, this will then apply a deletion algoritham acordingly")

$button34 = GUICtrlCreateButton("Delete", 505, 385, 100, 20)
GUICtrlSetTip( -1, "This button delete all of the files you have selected")
GUISetState()
GUISetOnEvent($GUI_EVENT_DROPPED, 'DropFile');this is the way I do it

;setup tab3--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab6--------------------------------------------------------------------------------------------------------------------------------------------
 $tab6 = GUICtrlCreateTabItem("Schedule")
;GUICtrlCreateTabitem ("")
;~ $date = GUICtrlCreateLabel("", 10, 50, 500, 500)
;~    
;~ Update()

;setup tab6--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab5--------------------------------------------------------------------------------------------------------------------------------------------
$tab5 = GUICtrlCreateTabItem("Full Disk Sanitization")
GUICtrlCreateLabel("Formatting places magnetic markers on the drive surface to define the sectors in which data is stored. When you format a hard drive, you erase all its files and prepare it as if it were a new or blank hard dive. Formatting your hard drive will wipe clean your drive just like a new hard drive." & @CRLF & "" & @CRLF & "It's a wise precaution to remove sensitive data from computer disk(s) before the disk(s) are either transferred from one area to another or discarded. The process is referred to as disk sanitizing, cleaning, purging, or wiping. The method you choose to sanitize a disk should depend on the security requirements of you or your organization.", 10, 30, 590, 200)

$list130 = GUICtrlCreateListView("Drive Letters | Total Drive Space | Estimated Sanitization Time", 10, 160, 595, 210)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlSendMsg($list130, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($list130, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
_GUICtrlListViewSetColumnWidth($list130, 0, 190)
_GUICtrlListViewSetColumnWidth($list130, 1, 200)
_GUICtrlListViewSetColumnWidth($list130, 2, 200)

$drives = DriveGetDrive("Fixed")
For $i = 1 To $drives[0]
	$totals = Round(DriveSpaceTotal($drives[$i]) / 1024, 1)
	
	GUICtrlCreateListViewItem(StringUpper($drives[$i]) & "|" & $totals & " GB", $list130)
Next

$label = GUICtrlCreateLabel("", 368, 343, 150, 15)
$fulldisk = GUICtrlCreateButton("Full Disk Sanitization", 10, 375, 595, 30)
GUICtrlSetTip( -1, "This button will allow you to delete all the data" & @CRLF & "stored on the drive you have sulected")

;setup tab5--------------------------------------------------------------------------------------------------------------------------------------------

;setup tab4--------------------------------------------------------------------------------------------------------------------------------------------
$tab11 = GUICtrlCreateTabItem("Empty Space Eraser")
GUICtrlCreateLabel("When you delete a file, Windows does not actually remove the contents of the file from your hard drive. Windows only deletes", 10, 30, 590, 20)
GUICtrlCreateLabel("a reference to the file from a table that lists all files on your computer. The table is like a table of  contents that tells Windows", 10, 45, 590, 20)
GUICtrlCreateLabel("where files are.", 10, 60, 490, 20)
GUICtrlCreateLabel("Windows says that the file is deleted, but the content of the file still exists until Windows overwrites the same area on the", 10, 80, 590, 20)
GUICtrlCreateLabel("hard drive with new information.", 10, 95, 435, 20)
GUICtrlCreateLabel("The area of your hard drive where the deleted file was is considered free space, but the content of the deleted file is still", 10, 120, 590, 20)
GUICtrlCreateLabel("there. To completely remove any content from free space, you can wash the free space.", 10, 135, 490, 20)
$list13 = GUICtrlCreateListView("Drives | Used Space | Free Space", 10, 160, 595, 180)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlSendMsg($list13, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($list13, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)

_GUICtrlListViewSetColumnWidth($list13, 0, 180)
_GUICtrlListViewSetColumnWidth($list13, 1, 200)
_GUICtrlListViewSetColumnWidth($list13, 2, 200)
$drives = DriveGetDrive("Fixed")
For $i = 1 To $drives[0]
	$totals = Round(DriveSpaceTotal($drives[$i]) / 1024, 1)
	$spacef = Round(DriveSpaceFree($drives[$i]) / 1024, 1)
	$spaceu = $totals - $spacef
	GUICtrlCreateListViewItem(StringUpper($drives[$i]) & "|" & $spaceu & " GB" & "|" & $spacef & " GB", $list13)
Next
$label = GUICtrlCreateLabel("", 368, 343, 150, 15)
$checkbox1 = GUICtrlCreateCheckbox("Shutdown PC When Done Washing - Recomende!", 10, 350, 290, 20)
$button30 = GUICtrlCreateButton("Start Washing", 10, 375, 595, 30)
GUICtrlSetTip( -1, "This button will allow you to delete all the data" & @CRLF & "stored in the free space on the drive you have" & @CRLF & "sulected")


GUISetState()

While 1
	$msg = GUIGetMsg()
	
	Select
			Case $msg = $Filesitem
			GUIctrlSetState ($Iternettree,$GUI_HIDE)
			GUICtrlSetState ($Deletedtree,$GUI_HIDE)
			GUIctrlSetState ($Systemtree,$GUI_HIDE)
			GUICtrlSetState ($Nettree,$GUI_HIDE)
			GUICtrlSetState ($SelectallInt,$GUI_HIDE)
			GUICtrlSetState ($SelectallNet,$GUI_HIDE)
			GUICtrlSetState ($SelectallDel,$GUI_HIDE)
			GUICtrlSetState ($SelectallSys,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallDel,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallInt,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallSys,$GUI_HIDE)
			
			GUICtrlSetState($button1,$GUI_SHOW)
			GUICtrlSetState($button2,$GUI_SHOW)
			GUICtrlSetState($User,$GUI_SHOW)
									
		Case $msg = $Iternetitem
			GUIctrlSetState ($User,$GUI_HIDE)
			GUICtrlSetState ($Deletedtree,$GUI_HIDE)
			GUIctrlSetState ($Systemtree,$GUI_HIDE)
			GUICtrlSetState ($Nettree,$GUI_HIDE)
			GUICtrlSetState($button1,$GUI_HIDE)
			GUICtrlSetState($button2,$GUI_HIDE)
			GUICtrlSetState ($SelectallDel,$GUI_HIDE)
			GUICtrlSetState ($SelectallSys,$GUI_HIDE)
			GUICtrlSetState ($SelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallDel,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallSys,$GUI_HIDE)
			
			GUICtrlSetState ($SelectallInt,$GUI_SHOW)
			GUICtrlSetState ($UnSelectallInt,$GUI_SHOW)
			GUICtrlSetState ($Iternettree,$GUI_SHOW)
			
		Case $msg = $Deleteditem
			GUIctrlSetState ($User,$GUI_HIDE)
			GUIctrlSetState ($Iternettree,$GUI_HIDE)
			GUIctrlSetState ($Systemtree,$GUI_HIDE)
			GUICtrlSetState ($Nettree,$GUI_HIDE)
			GUICtrlSetState($button1,$GUI_HIDE)
			GUICtrlSetState($button2,$GUI_HIDE)
			GUICtrlSetState ($SelectallSys,$GUI_HIDE)
			GUICtrlSetState ($SelectallInt,$GUI_HIDE)
			GUICtrlSetState ($SelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallSys,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallInt,$GUI_HIDE)
			
			GUICtrlSetState ($SelectallDeL,$GUI_SHOW)
			GUICtrlSetState ($UnSelectallDeL,$GUI_SHOW)
			GUICtrlSetState ($Deletedtree,$GUI_SHOW)
			
		Case $msg = $Systemitem
			GUIctrlSetState ($User,$GUI_HIDE)
			GUIctrlSetState ($Iternettree,$GUI_HIDE)
			GUICtrlSetState ($Deletedtree,$GUI_HIDE)
			GUICtrlSetState ($Nettree,$GUI_HIDE)
			GUICtrlSetState($button1,$GUI_HIDE)
			GUICtrlSetState($button2,$GUI_HIDE)
			GUICtrlSetState ($SelectallInt,$GUI_HIDE)
			GUICtrlSetState ($SelectallDeL,$GUI_HIDE)
			GUICtrlSetState ($SelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallNet,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallDel,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallInt,$GUI_HIDE)
			
			GUICtrlSetState ($SelectallSys,$GUI_SHOW)
			GUICtrlSetState ($UnSelectallSys,$GUI_SHOW)
			GUICtrlSetState ($Systemtree,$GUI_SHOW)
			
		Case $msg = $Netitem
			GUIctrlSetState ($User,$GUI_HIDE)
			GUIctrlSetState ($Iternettree,$GUI_HIDE)
			GUICtrlSetState ($Deletedtree,$GUI_HIDE)
			GUICtrlSetState ($Systemtree,$GUI_HIDE)
			GUICtrlSetState($button1,$GUI_HIDE)
			GUICtrlSetState($button2,$GUI_HIDE)
			GUICtrlSetState ($SelectallInt,$GUI_HIDE)
			GUICtrlSetState ($SelectallDeL,$GUI_HIDE)
			GUICtrlSetState ($SelectallSys,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallSys,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallDel,$GUI_HIDE)
			GUICtrlSetState ($UnSelectallInt,$GUI_HIDE)
			
			GUICtrlSetState ($SelectallNet,$GUI_SHOW)
			GUICtrlSetState ($UnSelectallNet,$GUI_SHOW)
			GUICtrlSetState ($Nettree,$GUI_SHOW)
			
			
		Case $msg = $tab2tempFilesitem1
			GUICtrlSetState ($tab2tempFilesitem,$GUI_SHOW)
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_SHOW)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_SHOW)
			
			GUICtrlSetState ($tab2Backitem,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritem,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitem,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton2 ,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
			
		Case $msg = $tab2Backitem1	
			GUICtrlSetState ($tab2Backitem,$GUI_SHOW)
			GUICtrlSetState ($tab2BackitemButton1,$GUI_SHOW)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_SHOW)
			
			GUICtrlSetState ($tab2tempFilesitem,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritem,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitem,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton2 ,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
			
		Case $msg = $tab2erroritem1
			GUICtrlSetState ($tab2erroritem,$GUI_SHOW)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_SHOW)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_SHOW)
			
			GUICtrlSetState ($tab2tempFilesitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Backitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitem,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton2 ,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
			
		Case $msg = $tab2Dioitem1
			GUICtrlSetState ($tab2Dioitem,$GUI_SHOW)
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_SHOW)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_SHOW)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
			
			GUICtrlSetState ($tab2tempFilesitem,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritem,$GUI_HIDE)
			GUICtrlSetState ($tab2Backitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitem,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton2 ,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
			
		Case $msg = $tab2Logtitem1
			GUICtrlSetState ($tab2Logtitem,$GUI_SHOW)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_SHOW)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_SHOW)
			
			GUICtrlSetState ($tab2tempFilesitem,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritem,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Backitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitem,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton2 ,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_HIDE)
						
		Case $msg = $tab2Miscitem1
			GUICtrlSetState ($tab2Miscitem,$GUI_SHOW)
			GUICtrlSetState ($tab2Miscitembutton1,$GUI_SHOW)
			GUICtrlSetState ($tab2Miscitembutton2,$GUI_SHOW)
			
			GUICtrlSetState ($tab2tempFilesitem,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritem,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Backitem,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitem,$GUI_HIDE)
			GUICtrlSetState ($tab2tempFilesitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2BackitemButton2,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Dioitembutton2,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton2,$GUI_HIDE)	
			GUICtrlSetState ($tab2tempFilesitemButton1,$GUI_HIDE)	
			GUICtrlSetState ($tab2BackitemButton1,$GUI_HIDE)
			GUICtrlSetState ($tab2erroritembutton1,$GUI_HIDE)			
			GUICtrlSetState ($tab2Dioitembutton1,$GUI_HIDE)
			GUICtrlSetState ($tab2Logtitembutton1,$GUI_HIDE)
			
		Case $msg = $SUBMenuHELPitem or $msg = $Hellpbutton1 
			Msgbox(64,"PUP- Quick General Help","The PUP software system is a state of the art smart data deletion and privacy package combined with a user-"& @CRLF & "friendly GUI, designed for both the standard and the advanced computer user. This software has been"& @CRLF & "specially designed and created to offer varying degrees of protection for you and your data, including your;"& @CRLF & "work, communications, on and offline content and deleted files etc."& @CRLF & ""& @CRLF & "PUP has been designed to monitor the files a user is deleting and make its own recommendations as to the"& @CRLF & "sanitization methods required. PUP also offers smart suggestions on the files it thinks should be removed from"& @CRLF & "your system, allowing users to dispose of their information and/ or their computer storage devices in a safe,"& @CRLF & "secure and worry free manner."& @CRLF & ""& @CRLF & "PUP’s main features include:"& @CRLF &"	Smart data destruction (bases on the types of files and its possible content)"& @CRLF &"	Scheduled data monitoring and deletion (based on the users own criteria)"& @CRLF &"	Full disk sanitization"& @CRLF &"	Standard user options (offering step by step guidance and advice to the user)"& @CRLF &"	Advanced user options (allowing the more experienced users the freedom to manipulate the"& @CRLF &"	program as theyrequire)"& @CRLF &"	Varying degrease of data sanitization methods (to best suit the user’s needs and circumstances)"& @CRLF &""& @CRLF &"Each of the PUP screens has its own unique Help button that will guide you through the use of the program."& @CRLF &"For more detail on each section please use the designated help button or the user manual provided with the "& @CRLF &"software")
		
		EndSelect
			
	If $msg =	$Exitbutton1 or $msg = $exititem or $msg = $SUBMenuexititem Then
		ExitLoop
	EndIf
	
	If $msg = $Back or $msg = $Backbutton1 Then
		Run("PUP.exe")
		sleep (200)
		ExitLoop
	EndIf 
	
	If $msg = $Prefmenu or $msg = $SUBMenuprefitem Then
		Run("Preff.exe")
		sleep (200)

	EndIf 
	
	If $msg = $Aboutmenu or $msg = $SUBMenuaboutitem1 Then
		MsgBox(64,"About","PUP - Data deletion program" & @CRLF & "_________________________________________" & @CRLF & "" & @CRLF & "Copyright (C) 2007, Ivan Nicholson" & @CRLF & "" & @CRLF & "Web: 	                    " & @CRLF & "Email: 	support@PUP.co.ok")
	EndIf	
	
	If $msg = $prioratize Then
		EndIf
	If $msg = $button1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($User, $i, 1)
		Next
	EndIf
	
	
	
	If $msg = $tab2tempFilesitemButton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2tempFilesitem, $i, 1)
		Next
	EndIf
	
	If $msg = $tab2BackitemButton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2Backitem, $i, 1)
		Next
	EndIf
	
	If $msg = $tab2erroritembutton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2erroritem, $i, 1)
		Next
	EndIf
	
	If $msg = $tab2Dioitembutton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2Dioitem, $i, 1)
		Next
	EndIf
	
	If $msg = $tab2Logtitembutton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2Logtitem, $i, 1)
		Next
	EndIf
	
	If $msg = $tab2Miscitembutton1 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($tab2Miscitem, $i, 1)
		Next
	EndIf
	
	
	
	If $msg = $SelectallInt Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Iternettree, $i, 1)
		Next
	EndIf
	
	If $msg = $SelectallDEL Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Deletedtree, $i, 1)
		Next
	EndIf
	
	If $msg = $SelectallSys Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Systemtree, $i, 1)
		Next
	EndIf
	
	If $msg = $SelectallNet Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Nettree, $i, 1)
		Next
	EndIf
	
	If $msg = $button2 Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($User, $i, 0)
		Next
	EndIf
	
	If $msg = $UnSelectallInt Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Iternettree, $i, 0)
		Next
	EndIf
	
	If $msg = $UnSelectallDel Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Deletedtree, $i, 0)
		Next
	EndIf
	
	If $msg = $UnSelectallSys Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Systemtree, $i, 0)
		Next
	EndIf
	
	If $msg = $UnSelectallNet Then
		For $i = 0 To 54
			_GUICtrlListViewSetCheckState($Nettree, $i, 0)
		Next
	EndIf
	
;tab2 select none buttons-------------------------------------------------------------------------------------------------------------------------------------------	
			
	If $msg = $tab2tempFilesitemButton2 Then
		$count = _GUICtrlListViewGetItemCount($tab2tempFilesitem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2tempFilesitem, $i, 0)
		Next
	EndIf
	
	If $msg = $tab2BackitemButton2 Then
		$count = _GUICtrlListViewGetItemCount($tab2Backitem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2Backitem, $i, 0)
		Next
	EndIf
	
	If $msg = $tab2erroritembutton2  Then
		$count = _GUICtrlListViewGetItemCount($tab2erroritem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2erroritem, $i, 0)
		Next
	EndIf
	
	If $msg = $tab2Dioitembutton2 Then
		$count = _GUICtrlListViewGetItemCount($tab2Dioitem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2Dioitem, $i, 0)
		Next
	EndIf
	
	If $msg = $tab2Logtitembutton2  Then
		$count = _GUICtrlListViewGetItemCount($tab2Logtitem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2Logtitem, $i, 0)
		Next
	EndIf
	
	If $msg = $tab2Miscitembutton2 Then
		$count = _GUICtrlListViewGetItemCount($tab2Miscitem)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($tab2Miscitem, $i, 0)
		Next
	EndIf
	
	  
;tab2 select none buttons-------------------------------------------------------------------------------------------------------------------------------------------	
	
	
	If $msg = $button3 Then analyse1()
		
	If $msg = $button4 Then 
		 $ret = MsgBox(20,"PUP- WARNING","WARNING! This will clean all empty space on the Hard Drive and may take along time depending on the amount of free space avalable"& @CRLF & "Do You Want To Proced?") ;display waring msgbox
	If $ret = 6 Then systemcl(); if yes is pressed run function systemcl if no do nothiing
	EndIf

	If $msg = $button8 Then
		$count = ""
		$count = _GUICtrlListViewGetItemCount($list5)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($list5, $i, 1)
		Next
	EndIf
	
	If $msg = $button9 Then
		$count = _GUICtrlListViewGetItemCount($list5)
		For $i = 0 To $count
			_GUICtrlListViewSetCheckState($list5, $i, 0)
		Next
	EndIf
	If $msg = $button10 Then
		GUICtrlSetData($list5, "Size | File(s) Found")
		$larr = 1
		junkanalyse()
		$larr = 0
	EndIf
	If $msg = $fulldisk Then
		Msgbox(20,"PUP- WARNING","WARNING! This will remove all the data held on your Hard Drive and may take along time depending on the capacity of the selected HDD(s)"& @CRLF & "Do You Want To Proced?")
	EndIf
	If $msg = $button11 Then 
		 $ret = MsgBox(20,"PUP- WARNING","WARNING! This will Delete all the files you have sulected"& @CRLF & "Do You Want To Proced?") ;display waring msgbox
	If $ret = 6 Then junkclean(); if yes is pressed run function junkclean if no do nothiing
	EndIf
		
	If $msg = $button30 Then
    $ret = MsgBox(20,"PUP- WARNING","WARNING! This will clean all empty space on the Hard Drive and may take along time depending on the amount of free space avalable"& @CRLF & "Do You Want To Proced?") ;display waring msgbox
	If $ret = 6 Then washdrive (); if yes is pressed run function washdrive if no do nothiing
	EndIf

	If $msg = $button31 Then 
		
	$nIndex = _GUICtrlListViewFindItem($listview, $nItem, -1, $LVFI_PARAM)	; looks at test in the screen	
	If $nIndex <> -1 Then _GUICtrlListViewDeleteItem ($listview, $nIndex)	; removes the curent text in the screen	
				
		$dialog = FileOpenDialog("Choose The File(s) (Max 4000)", "", "(*.*)", 4)
			If $dialog = "" Then
				ContinueLoop
			Else
				If StringInStr($dialog, "|") > 0 Then
					$stringsplit = StringSplit($dialog, "|")
					For $ss = 2 To $stringsplit[0]
						If @OSTYPE = "WIN32_WINDOWS" Then
							GUICtrlCreateListViewItem($stringsplit[1] & $stringsplit[$ss] & "|" & Round(FileGetSize($stringsplit[1] & $stringsplit[$ss]) / 1024, 1) & " KB", $listview)
						Else
							GUICtrlCreateListViewItem($stringsplit[1] & "\" & $stringsplit[$ss] & "|" & Round(FileGetSize($stringsplit[1] & "\" & $stringsplit[$ss]) / 1024, 1) & " KB", $listview)
						EndIf
					Next
				Else
					GUICtrlCreateListViewItem($dialog & "|" & Round(FileGetSize($dialog) / 1024, 1) & "KB", $listview)
				EndIf
			EndIf
	EndIf
	If $msg = $button32 Then
		$listsel = _GUICtrlListViewGetCurSel($listview)
		_GUICtrlListViewDeleteItem($listview, $listsel)
	EndIf
	If $msg = $button33 Then _GUICtrlListViewDeleteAllItems($listview)
	If $msg = $button34 Then
		$ret = MsgBox(20,"PUP- WARNING","WARNING! This will Delete the filles you have sulected"& @CRLF & "Do You Want To Proced?") ;display waring msgbox
		If $ret = 7 Then Exit ; dose not stopp if press no???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
	If $ret = 6 Then 
	EndIf
;~ 		$fop = ""
;~ 		$fop = FileOpen(@ScriptDir & "\tmp.txt", 2)
;~ 		For $sr = 0 To _GUICtrlListViewGetItemCount($listview)-1
;~ 			$splitlist = StringSplit(_GUICtrlListViewGetItemText($listview, $sr), "|")
;~ 			FileWrite(@ScriptDir & "\tmp.txt", $splitlist[1] & @CRLF)
;~ 		Next
;~ 		FileClose($fop)
		WinSetTitle($version, "", "PUP- Cleaning Please Wait")
		GUICtrlSetData($button34, "Cancel")
		securedel()
		GUICtrlSetData($edit1, "")
		_GUICtrlListViewDeleteAllItems($listview)
		GUICtrlSetData($button34, "Delete")
		WinSetTitle("PUP", "", $version)
	EndIf
	If $msg = $GUI_EVENT_CLOSE Then 
		If FileExists(@ScriptDir & "\tmp.txt") Then FileDelete(@ScriptDir & "\tmp.txt")
		Exit
	EndIf

;Tray icon -------------------------------------------------------------------------------------------------------------------------------------------------
	If $msg = $GUI_EVENT_MINIMIZE Then	
	    GuiSetState(@SW_HIDE)
    Opt("TrayIconHide", 0) 
    Traytip ("PUP has been minimised", "Click here to restore", 1)
EndIf
;Tray icon -------------------------------------------------------------------------------------------------------------------------------------------------
WEnd
;setup tab4--------------------------------------------------------------------------------------------------------------------------------------------

;setup functions--------------------------------------------------------------------------------------------------------------------------------------------
Func analyse1()
	GUICtrlSetData($edit1, "")
	GUICtrlSetData($progress, 0)
	$dir1 = Round(DirGetSize($regr0) / 1024 / 1024, 2)
	$dir2 = Round(DirGetSize(@HomeDrive & "\RECYCLER") / 1024 / 1024, 2) + Round(DirGetSize(@HomeDrive & "\RECYCLED") / 1024 / 1024, 2)
	$dir3 = DirGetSize(@TempDir) + DirGetSize(@WindowsDir & "\temp")
	$dir4 = Round($dir3 / 1024 / 1024, 2)
	$dir5 = DirGetSize(@SystemDir & "\wbem\logs") + DirGetSize(@WindowsDir & "\debug") + DirGetSize(@WindowsDir & "\security\logs")
	$dir6 = Round($dir5 / 1024 / 1024, 2)
	$dir7 = Round(DirGetSize(@WindowsDir & "\MiniDump") / 1024 / 1024, 2)
	$dir8 = Round(DirGetSize($regr1) / 1024 / 1024, 2)
	$dir9 = Round(DirGetSize($regr2) / 1024 / 1024, 2)
	$dir10 = Round(DirGetSize($regr3) / 1024 / 1024, 2)
	GUICtrlSetData($progress, 25)
	$dir11 = Round(FileGetSize($regr4 & "\iconcache.db") / 1024 / 1024, 2)
	$dir12 = Round(DirGetSize(@WindowsDir & "\prefetch") / 1024 / 1024, 2)
	$dir13 = Round(DirGetSize(@WindowsDir & "\repair") / 1024 / 1024, 2) + Round(DirGetSize(@WindowsDir & "\sysbckup") / 1024 / 1024, 2)
	$dir14 = Round(DirGetSize(@WindowsDir & "\help") / 1024 / 1024, 2)
	$dir15 = Round(DirGetSize(@WindowsDir & "\media") / 1024 / 1024, 2)
	$dir16 = Round(FileGetSize(@WindowsDir & "\Driver Cache\i386\driver.cab") / 1024 / 1024, 2)
	GUICtrlSetData($progress, 50)
	$dirtot = $dir1 + $dir2 + $dir4 + $dir6 + $dir7 + $dir8 + $dir9 + $dir10 + $dir11 + $dir12 + $dir13 + $dir14 + $dir15 + $dir16
	GUICtrlSetData($edit1, "Temporary Internet Files " & Chr(09) & Chr(09) & $dir1 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Recycle Bin " & Chr(09) & Chr(09) & Chr(09) & $dir2 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Temp Files " & Chr(09) & Chr(09) & Chr(09) & $dir4 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Log Files " & Chr(09) & Chr(09) & Chr(09) & Chr(09) & $dir6 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Memory Dumps " & Chr(09) & Chr(09) & Chr(09) & $dir7 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Cookies " & Chr(09) & Chr(09) & Chr(09) & Chr(09) & $dir8 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "History " & Chr(09) & Chr(09) & Chr(09) & Chr(09) & $dir9 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($progress, 75)
	GUICtrlSetData($edit1, "Recent Files " & Chr(09) & Chr(09) & Chr(09) & $dir10 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Icon Cache " & Chr(09) & Chr(09) & Chr(09) & $dir11 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Prefetch Cache " & Chr(09) & Chr(09) & Chr(09) & $dir12 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Registry Backup " & Chr(09) & Chr(09) & Chr(09) & $dir13 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Help Files " & Chr(09) & Chr(09) & Chr(09) & $dir14 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Media Files " & Chr(09) & Chr(09) & Chr(09) & $dir15 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "Drivers Cache " & Chr(09) & Chr(09) & Chr(09) & $dir16 & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "===========================================" & @CRLF, 1)
	GUICtrlSetData($edit1, "Total Size " & Chr(09) & Chr(09) & Chr(09) & $dirtot & Chr(09) & " MB" & @CRLF, 1)
	GUICtrlSetData($edit1, "===========================================" & @CRLF, 1)
	GUICtrlSetData($edit1, "Note : the actual size might be different", 1)
	GUICtrlSetData($progress, 100)
EndFunc

Func systemcl()
	$lineread = ""
	$total = ""
	$fop = ""
	$fop = FileOpen(@ScriptDir & "\tmp.txt", 2)
	GUICtrlSetData($edit1, "Deleting - Please Wait")
	GUICtrlSetData($button4, "Cancel")
	Opt("GUIOnEventMode", 1)
	GUICtrlSetOnEvent($button4, "cance")
	For $y = 0 To 53
		$check = _GUICtrlListViewGetCheckedState($User, $y)
		;$check = _GUICtrlListViewGetCheckedState($Iternettree, $y)
		If $check = 1 Then
			$mad = _GUICtrlListViewGetItemText($User, $y) 
			;$mad = _GUICtrlListViewGetItemText($Iternettree, $y)
			If $mad == "Open With history" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts")
			If $mad == "Open/Save Memory" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU")
			EndIf
			If $mad == "Run History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU")
			If $mad == "User Assist History" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{5E6AB780-7743-11CF-A12B-00AA004AE837}\Count")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{75048700-EF1F-11D0-9888-006097DEACF9}\Count")
			EndIf
			If $mad == "Search Assistant Autocomplete" Then RegDelete("HKCU\Software\Microsoft\Search Assistant\ACMru")
			If $mad == "Searched Files MRU" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Doc Find Spec MRU")
			If $mad == "Find Computer History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FindComputerMRU")
			If $mad == "Recent Docs History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs")
			If $mad == "Recent Documents" Then FileDelete($regr3 & "\*.*")
			
			If $mad == "My Documents"Then FileDelete("C:\Documents and Settings\Ivan\Desktop\Space regain\My Documents"); delet my documents, never seems to say how much has actualy been removed -----------------------------
		
				
			If $mad == "Recycle Bin" Then
				$contain = ""
				If StringInStr(FileGetAttrib(@HomeDrive & "\recycler"), "D") Then
					$contain = "\recycler"
				ElseIf StringInStr(FileGetAttrib(@HomeDrive & "\recycled"), "D") Then
					$contain = "\recycled"
				EndIf
				$ash = _FileSearch(@HomeDrive & "\" & $contain & "\*.*", 1)
				If $ash[0] > 0 Then
					For $tim = 1 To $ash[0]
						FileWrite(@ScriptDir & "\tmp.txt", $ash[$tim] & @CRLF)
					Next
				EndIf
			EndIf
			If $mad == "Clipboard" Then ClipPut("")
			If $mad == "Memory Dumps" Then
				FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\memory.dmp" & @CRLF)
				$findfile1 = FileFindFirstFile(@WindowsDir & "\MiniDump\*.dmp")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\MiniDump\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "Chkdsk File Fragments" Then FileDelete(@HomeDrive & "\File*.chk")
			If $mad == "Windows Log Files" Then
				$findfile1 = FileFindFirstFile(@SystemDir & "\wbem\logs\*.log")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @SystemDir & "\wbem\logs\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@SystemDir & "\wbem\logs\*.lo_")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @SystemDir & "\wbem\logs\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\*.log")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\*.bak")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\*log.txt")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\debug\*.log")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\debug\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\debug\usermode\*.log")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\debug\usermode\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\debug\usermode\*.bak")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\debug\usermode\" & $findfile2 & @CRLF)
				WEnd
				FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\SchedLgU.txt" & @CRLF)
				$findfile1 = FileFindFirstFile(@WindowsDir & "\security\logs\*.log")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\security\logs\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\security\logs\*.old")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\security\logs\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@SystemDir & "\logfiles\*.*")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @SystemDir & "\logfiles\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "ARP Cache Entries" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\App Management", "ARPCache")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache")
			EndIf
			If $mad == "MUI Cache Entries" Then RegDelete("HKCU\Software\Microsoft\Windows\ShellNoRoam\MUICache")
			If $mad == "Bag MRU Entries" Then RegDelete("HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU")
			If $mad == "Logon User name" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer", "Logon User Name")
			If $mad == "Tray Notification Cache" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\TrayNotify\IconStreams")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\TrayNotify\PastIconsStream")
			EndIf
			If $mad == "Shared Workgroup Printers History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WorkgroupCrawler\Printers")
			If $mad == "Workgroup Shares History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WorkgroupCrawler\Shares")
			If $mad == "OCX Stream Cache" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OCXStreamMRU")
			If $mad == "Printer Ports History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\PrnPortsMRU")
			If $mad == "Network Drive History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU")
			If $mad == "Computer Description History" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComputerDescriptions")
			If $mad == "Wallpaper MRU" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpaper\MRU")
			If $mad == "UnreadMail MRU" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\UnreadMail")
			If $mad == "Other MRUs" Then
				RegDelete("HKCU\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ComputerNameMRU")
				RegDelete("HKCU\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ContainingTextMRU")
				RegDelete("HKCU\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\FilesNamedMRU")
			EndIf
			If $mad == "Temporary Files" Then
				$asi = _FileSearch(@TempDir & "\*.*", 1)
				If $asi[0] > 0 Then
					For $tim = 1 To $asi[0]
						FileWrite(@ScriptDir & "\tmp.txt", $asi[$tim] & @CRLF)
					Next
				EndIf
				If StringInStr(FileGetAttrib(@HomeDrive & "\temp"), "D") Then
					$asj = _FileSearch(@HomeDrive & "\temp\*.*", 1)
					If $asj[0] > 0 Then
						For $tim = 1 To $asj[0]
							FileWrite(@ScriptDir & "\tmp.txt", $asj[$tim] & @CRLF)
						Next
					EndIf
				EndIf
			EndIf
			If $mad == "Prefetch Data" Then
				$findfile3 = FileFindFirstFile(@WindowsDir & "\Prefetch\*.*")
				While 1
					$findfile4 = FileFindNextFile($findfile3)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\Prefetch\" & $findfile4 & @CRLF)
				WEnd
			EndIf
			If $mad == "Icon Cache" Then
				If FileExists($regr4 & "\iconcache.db") Then
					FileSetAttrib($regr4 & "\iconcache.db", "-RASH")
					FileWrite(@ScriptDir & "\tmp.txt", $regr4 & "\iconcache.db" & @CRLF)
				EndIf
				If FileExists(@WindowsDir & "\shelliconcache") Then
					FileSetAttrib(@WindowsDir & "\shelliconcache", "-RASH")
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\shelliconcache" & @CRLF)
				EndIf
			EndIf
			If $mad == "Windows Help Files" Then
				$findfile1 = FileFindFirstFile(@WindowsDir & "\help\*.*")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\help\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "Registry Backup" Then
				FileSetAttrib(@WindowsDir & "\repair\*.*", "-RASH")
				$findfile1 = FileFindFirstFile(@WindowsDir & "\repair\*.*")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\repair\" & $findfile2 & @CRLF)
				WEnd
				$findfile1 = FileFindFirstFile(@WindowsDir & "\sysbckup\*.cab")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\sysbckup\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "Window Size/Location Cache" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StreamMRU")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams")
			EndIf
			If $mad == "Drivers Cache" Then FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "Driver Cache\i386\driver.cab")
			If $mad == "Windows Media" Then
				$findfile1 = FileFindFirstFile(@WindowsDir & "\media\*.*")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", @WindowsDir & "\media\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "IE Temporary Internet Files" Then
				$asl = _FileSearch($regr0 & "\*.*", 1)
				If $asl[0] > 0 Then
					For $tim = 1 To $asl[0]
						FileWrite(@ScriptDir & "\tmp.txt", $asl[$tim] & @CRLF)
					Next
				EndIf
			EndIf
			If $mad == "IE Cookies" Then
				$findfile1 = FileFindFirstFile($regr1 & "\*.txt")
				While 1
					$findfile2 = FileFindNextFile($findfile1)
					If @error Then ExitLoop
					FileWrite(@ScriptDir & "\tmp.txt", $regr1 & "\" & $findfile2 & @CRLF)
				WEnd
			EndIf
			If $mad == "IE History" Then
				$asm = _FileSearch($regr2 & "\*.*", 1)
				If $asm[0] > 0 Then
					For $tim = 1 To $asm[0]
						FileWrite(@ScriptDir & "\tmp.txt", $asm[$tim] & @CRLF)
					Next
				EndIf
			EndIf
			If $mad == "IE Recently Typed URLs" Then RegDelete("HKCU\Software\Microsoft\Internet Explorer\TypedURLs")
			If $mad == "IE Index.dat" Then
				If Not FileExists("index.bat") Then
					RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce", "PUP", "REG_SZ", @ScriptDir & "\index.bat")
					FileWrite("index.bat", 'del "' & FileGetShortName($regr0 & "\Content.IE5\index.dat") & '"' & @CRLF)
					FileWrite("index.bat", 'del "' & FileGetShortName($regr1 & "\index.dat") & '"' & @CRLF)
					FileWrite("index.bat", 'del "' & FileGetShortName($regr2 & "\History.IE5\index.dat") & '"' & @CRLF)
					While 1
						Local $ind1
						$ind1 = $ind1 + 1
						$keygen = "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Extensible Cache"
						$regreadch6 = RegEnumKey($keygen, $ind1)
						If @error Then ExitLoop
						FileWrite("index.bat", 'del "' & FileGetShortName($regr2 & "\History.IE5\" & $regreadch6) & "\index.dat" & '"' & @CRLF)
					WEnd
					FileWrite("index.bat", 'del "' & FileGetShortName(@ScriptDir) & "\index.bat" & '"' & @CRLF)
				EndIf
			EndIf
			If $mad == "IE Last Download Location" Then RegDelete("HKCU\Software\Microsoft\Internet Explorer\Download Directory")
			If $mad == "IE AutoComplete History" Then
				RegDelete("HKCU\Software\Microsoft\Internet Explorer\AutoComplete")
				RegDelete("HKCU\Software\Microsoft\Internet Explorer\IntelliForms\SPW")
			EndIf
			If $mad == "IE 7.0 Autocomplete Passwords" Then RegDelete("HKCU\Software\Microsoft\Internet Explorer\IntelliForms", "Storage2")
			If $mad == "IE Browser Helper Objects" Then
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects")
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects")
			EndIf
			If $mad == "IE Toolbar Extensions" Then RegDelete("HKLM\SOFTWARE\Microsoft\Internet Explorer\Extensions")
			If $mad == "IE Menu Extensions" Then RegDelete("HKCU\Software\Microsoft\Internet Explorer\MenuExt")
			If $mad == "IE Publishing Wizard MRU" Then RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\PublishingWizard\AddNetPlace", "LocationMRU")
			If $mad == "FireFox Cache" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					$findfile1 = FileFindFirstFile(@AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\Cache\*.*")
					While 1
						$findfile2 = FileFindNextFile($findfile1)
						If @error Then ExitLoop
						FileWrite(@ScriptDir & "\tmp.txt", $regr1 & "\" & $findfile2 & @CRLF)
					WEnd
				EndIf
			EndIf
			If $mad == "FireFox Signons" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\signons.txt" & @CRLF)
				EndIf
			EndIf
			If $mad == "FireFox History" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\history.dat" & @CRLF)
				EndIf
			EndIf
			If $mad == "FireFox Cookies" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\cookies.txt" & @CRLF)
				EndIf
			EndIf
			If $mad == "FireFox Bookmarks" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\bookmarks.html" & @CRLF)
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\bookmarks.bak" & @CRLF)
				EndIf
			EndIf
			If $mad == "FireFox Form History" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\formhistory.dat" & @CRLF)
				EndIf
			EndIf
			If $mad == "FireFox Download History" Then
				If FileExists(@AppDataDir & "\Mozilla\Firefox\profiles.ini") Then
					$profile = IniRead(@AppDataDir & "\Mozilla\Firefox\profiles.ini", "Profile0", "Path", "")
					$sring = StringSplit($profile, "/")
					FileWrite(@ScriptDir & "\tmp.txt", @AppDataDir & "\Mozilla\Firefox\Profiles\" & $sring[2] & "\downloads.rdf" & @CRLF)
				EndIf
			EndIf
		EndIf
	Next
	FileClose($fop)
	$spacenow = DriveSpaceFree(@HomeDrive) * 1024 * 1024
	Opt("GUIOnEventMode", 0)
	securedel()
	GUICtrlSetData($button4, "Delete")
	$spaceafter = DriveSpaceFree(@HomeDrive) * 1024 * 1024
	If Round(($spaceafter - $spacenow) / 1024 / 1024, 2) < 0 Then
		GUICtrlSetData($edit1, "Space Deleted : " & "0MB")
		GUICtrlSetData($progress, 100)
	Else
		GUICtrlSetData($edit1, "Deleted Space : " & Round(($spaceafter - $spacenow) / 1024 / 1024, 2) & "MB")
		GUICtrlSetData($progress, 100)
	EndIf
EndFunc

Func securedel()
	$readcombo = GUICtrlRead($combo)
	If $readcombo = "Standard Deletion Method" Then
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$zet = GUIGetMsg()
			If $zet = $button4 Or $zet = $button11 Or $zet = $button34 Then
				GUICtrlSetData($button4, "Delete")
				GUICtrlSetData($button34, "Delete")
				GUICtrlSetData($label, "")
				FileClose($fop)
				ExitLoop
			EndIf
			GUICtrlSetData($progress, $i*100/_FileCountLines(@ScriptDir & "\tmp.txt"))
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			GUICtrlSetData($edit1, "Deleting File : " & $readline)
			FileSetAttrib($readline, "-RSH")
			FileDelete($readline)
		Next
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			DirRemove($readline, 1)
		Next
	EndIf
	If $readcombo = "Zeros" Then
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			GUICtrlSetData($progress, $i*100/_FileCountLines(@ScriptDir & "\tmp.txt"))
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			GUICtrlSetData($edit1, "Deleting File : " & $readline)
			$filesize = FileGetSize($readline)
			FileSetAttrib($readline, "-RSH")
			If Not StringInStr(FileGetAttrib($readline), "D") Then
				For $m = 1 To GUICtrlRead($inp1)
					$s = 0
					Local $chr = ""
					Local $arra = 1
					$fop = FileOpen($readline, 2)
					While $arra = 1
						$zet = GUIGetMsg()
						For $s = 0 To 200
							$chr = $chr & Chr(48)
							$stt = FileWrite($fop, $chr)
						Next
						Sleep(10)
						If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
						If $zet = $button4  Or $zet = $button11 Or $zet = $button34 Then
							GUICtrlSetData($button4, "Delete")
							GUICtrlSetData($button34, "Delete")
							GUICtrlSetData($label, "")
							FileClose($readline)
							FileClose($fop)
							Return $arra = 0
						EndIf
					WEnd
					FileClose($fop)
					If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
						For $t = 0 To 2
							mom()
							FileSetTime($readline, $ra1 & $ra2 & $ra3, $t)
						Next
					EndIf
				Next
			EndIf
			FileClose($readline)
			FileDelete($readline)
		Next
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			DirRemove($readline, 1)
		Next
	EndIf
	If $readcombo = "Random-Character" Then
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			GUICtrlSetData($progress, $i*100/_FileCountLines(@ScriptDir & "\tmp.txt"))
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			GUICtrlSetData($edit1, "Deleting File : " & $readline)
			$filesize = FileGetSize($readline)
			FileSetAttrib($readline, "-RSH")
			If Not StringInStr(FileGetAttrib($readline), "D") Then
				For $m = 1 To GUICtrlRead($inp1)
					$s = 0
					Local $chr = ""
					Local $arra = 1
					$ran = Chr(Random(0, 255, 1))
					$fop = FileOpen($readline, 2)
					While $arra = 1
						$zet = GUIGetMsg()
						For $s = 0 To 200
							$chr = $chr & $ran
							$stt = FileWrite($fop, $chr)
						Next
						Sleep(10)
						If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
						If $zet = $button4 Or $zet = $button11 Or $zet = $button34 Then
							GUICtrlSetData($button4, "Delete")
							GUICtrlSetData($button34, "Delete")
							GUICtrlSetData($label, "")
							FileClose($readline)
							FileClose($fop)
							Return $arra = 0
						EndIf
					WEnd
					FileClose($fop)
					If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
						For $t = 0 To 2
							mom()
							FileSetTime($readline, $ra1 & $ra2 & $ra3, $t)
						Next
					EndIf
				Next
			EndIf
			FileClose($readline)
			FileDelete($readline)
		Next
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			DirRemove($readline, 1)
		Next
	EndIf
	If $readcombo = "Random-Reverse" Then
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			GUICtrlSetData($progress, $i*100/_FileCountLines(@ScriptDir & "\tmp.txt"))
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			GUICtrlSetData($edit1, "Deleting File : " & $readline)
			$filesize = FileGetSize($readline)
			FileSetAttrib($readline, "-RSH")
			If Not StringInStr(FileGetAttrib($readline), "D") Then
				For $m = 1 To GUICtrlRead($inp1)
					$s = 0
					Local $chr = ""
					Local $arra = 1
					$ran = Random(0, 255, 1)
					$fop = FileOpen($readline, 2)
					While $arra = 1
						$zet = GUIGetMsg()
						For $s = 0 To 200
							$ran = Random(0, 255, 1)
							$chr = $chr & Chr($ran)
						Next
						Sleep(10)
						$stt = FileWrite($fop, $chr)
						If (StringLen($chr) ^ 2) / 500 >= $filesize Then $arra = 0
						If $zet = $button4 Or $zet = $button11 Or $zet = $button34 Then
							GUICtrlSetData($button4, "Delete")
							GUICtrlSetData($button34, "Delete")
							GUICtrlSetData($label, "")
							FileClose($readline)
							FileClose($fop)
							Return $arra = 0
						EndIf
					WEnd
					FileClose($fop)
					If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
						For $t = 0 To 2
							mom()
							FileSetTime($readline, $ra1 & $ra2 & $ra3, $t)
						Next
					EndIf
				Next
			EndIf
			FileClose($readline)
			FileDelete($readline)
		Next
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			DirRemove($readline, 1)
		Next
	EndIf
	If $readcombo = "Random-Chunk" Then
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			GUICtrlSetData($progress, $i*100/_FileCountLines(@ScriptDir & "\tmp.txt"))
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			GUICtrlSetData($edit1, "Deleting File : " & $readline)
			$filesize = FileGetSize($readline)
			FileSetAttrib($readline, "-RSH")
			If Not StringInStr(FileGetAttrib($readline), "D") Then
				For $m = 1 To GUICtrlRead($inp1)
					$s = 0
					Local $chr = ""
					Local $arra = 1
					$ran = Random(0, 255, 1)
					$fop = FileOpen($readline, 2)
					While $arra = 1
						$zet = GUIGetMsg()
						For $s = 0 To 200
							$ran = Random(0, 255, 1)
							$chr = $chr & Chr($ran)
							$stt = FileWrite($fop, $chr)
						Next
						Sleep(10)
						If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
						If $zet = $button4 Or $zet = $button11 Or $zet = $button34 Then
							GUICtrlSetData($button4, "Delete")
							GUICtrlSetData($button34, "Delete")
							GUICtrlSetData($label, "")
							FileClose($readline)
							FileClose($fop)
							Return $arra = 0
						EndIf
					WEnd
					FileClose($fop)
					If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
						For $t = 0 To 2
							mom()
							FileSetTime($readline, $ra1 & $ra2 & $ra3, $t)
						Next
					EndIf
				Next
			EndIf
			FileClose($readline)
			FileDelete($readline)
		Next
		For $i = 1 To _FileCountLines(@ScriptDir & "\tmp.txt")
			$readline = FileReadLine(@ScriptDir & "\tmp.txt", $i)
			DirRemove($readline, 1)
		Next
	EndIf
	$check = _GUICtrlListViewGetCheckedState($User, 9)
	If $check = 1 Then FileRecycleEmpty(@HomeDrive)
	killtemp()
EndFunc

Func mom()
	$ra1 = Random(1960, 2070, 1)
	$ra2 = Random(1, 12, 1)
	$ra3 = Random(1, 31, 1)
	If $ra2 < 10 Then $ra2 = "0" & $ra2
	If $ra3 < 10 Then $ra3 = "0" & $ra3
EndFunc


Func junkanalyse()
	GUICtrlSetData($button10, "Cancel")
	GUICtrlSetData($progress, 0)
	
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 0) = 1 Then $rbox1 = "|*.??$" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 1) = 1 Then $rbox2 = "|*.~*" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 2) = 1 Then $rbox3 = "|~*.*" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 3) = 1 Then $rbox4 = "|*.*~"
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 4) = 1 Then $rbox5 = "|*._detmp"
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 5) = 1 Then $rbox6 = "|*.syd" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 6) = 1 Then $rbox7 = "|*.db$" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 7) = 1 Then $rbox8 = "|*.tmp" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 8) = 1 Then $rbox9 = "|*.bak" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 9) = 1 Then $rbox10 = "|*.ftg" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 10) = 1 Then $rbox11 = "|*.fts" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 11) = 1 Then $rbox12 = "|*.gid" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 12) = 1 Then $rbox13 = "|*.old" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 13) = 1 Then $rbox14 = "|*.---" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 14) = 1 Then $rbox15 = "|*.$$$" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 15) = 1 Then $rbox16 = "|*.@@@" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 16) = 1 Then $rbox17 = "|*.wbk" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 17) = 1 Then $rbox18 = "|*.xlk" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 18) = 1 Then $rbox19 = "|*.?~?" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 19) = 1 Then $rbox20 = "|*.??~" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 20) = 1 Then $rbox21 = "|*.?$?"
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 21) = 1 Then $rbox22 = "|*.$db" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 22) = 1 Then $rbox23 = "|*.00*" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 23) = 1 Then $rbox24 = "|*.shd" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 24) = 1 Then $rbox25 = "|0*.nch" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 25) = 1 Then $rbox26 = "|mscreate.dir" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 26) = 1 Then $rbox27 = "|*.dmp" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 27) = 1 Then $rbox28 = "|twain???.mtx" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 28) = 1 Then $rbox29 = "|*.pch" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 29) = 1 Then $rbox30 = "|*.ncb" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 30) = 1 Then $rbox31 = "|*.ilk" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 31) = 1 Then $rbox32 = "|*.exp" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 32) = 1 Then $rbox33 = "|*.ilc" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 33) = 1 Then $rbox34 = "|*.ild" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 34) = 1 Then $rbox35 = "|*.ils" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 35) = 1 Then $rbox36 = "|*.ilf" 
	If _GUICtrlListViewGetCheckedState($tab2tempFilesitem, 36) = 1 Then $rbox37 = "|*.tds" 
		
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 37) = 1 Then $rbox38 = "|*.prv" 
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 38) = 1 Then $rbox39 = "|*.nav" 
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 39) = 1 Then $rbox40 = "|*.cpy" 
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 40) = 1 Then $rbox41 = "|*.bac"
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 41) = 1 Then $rbox42 = "|*.back*"
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 42) = 1 Then $rbox43 = "|*.bup" 
	If _GUICtrlListViewGetCheckedState( $tab2Backitem, 43) = 1 Then $rbox44 = "|*.MS" 

	If _GUICtrlListViewGetCheckedState( $tab2erroritem, 44) = 1 Then $rbox45 = "|*.err" 

	If _GUICtrlListViewGetCheckedState( $tab2Dioitem, 45) = 1 Then $rbox46 = "|Thumbs.db" 
	If _GUICtrlListViewGetCheckedState( $tab2Dioitem, 46) = 1 Then $rbox47 = "|system.1st" 
	If _GUICtrlListViewGetCheckedState( $tab2Dioitem, 47) = 1 Then $rbox48 = "|suhdlog.dat"
	If _GUICtrlListViewGetCheckedState( $tab2Dioitem, 48) = 1 Then $rbox49 = "|modemdet.txt"

	If _GUICtrlListViewGetCheckedState( $tab2Logtitem, 49) = 1 Then $rbox50 = "|*log.txt" 

	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 50) = 1 Then $rbox51 = "|*.sik" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 51) = 1 Then $rbox52 = "|*.sdi" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 52) = 1 Then $rbox53 = "|*.fnd" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 53) = 1 Then $rbox54 = "|*.fic" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 54) = 1 Then $rbox55 = "|*._dd" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 55) = 1 Then $rbox56 = "|*.bk?" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 56) = 1 Then $rbox57 = "|__ofidx*.*" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 57) = 1 Then $rbox58 = "|0???????.nch" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 58) = 1 Then $rbox59 = "|iebak.dat"
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 59) = 1 Then $rbox60 = "|file_id.diz" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 60) = 1 Then $rbox61 = "|ffastun.*" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 61) = 1 Then $rbox62 = "|pspbrwse.jbf" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 62) = 1 Then $rbox63 = "|Foxmail.msg" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 63) = 1 Then $rbox64 = "|data.bak" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 64) = 1 Then $rbox65 = "|insider.bak" 
	If _GUICtrlListViewGetCheckedState( $tab2Miscitem, 65) = 1 Then $rbox66 = "|OPA11.BAK" 
	
	$total = ""
	GUICtrlSendMsg($list5, $LVM_DELETEALLITEMS, 0, 0)
	WinSetTitle($version, "", "PUP - Analysing Please Wait")
	$asr = _FileSearch($rbox1 & $rbox2 & $rbox3 & $rbox4 & $rbox5 & $rbox6 & $rbox7 & $rbox8 & $rbox9 & $rbox10 & $rbox11 & $rbox12 & $rbox13 & $rbox14 & $rbox15 & $rbox16 & $rbox17 & $rbox18 & $rbox19 & $rbox20 & $rbox21 & $rbox22 & $rbox23 & $rbox24 & $rbox25 & $rbox26 & $rbox27 & $rbox28 & $rbox29 & $rbox30 & $rbox31 & $rbox32 & $rbox33 & $rbox34 & $rbox35 & $rbox36 & $rbox37 & $rbox38 & $rbox39 & $rbox40 & $rbox41 & $rbox42 & $rbox43 & $rbox44 & $rbox45 & $rbox46 & $rbox47 & $rbox48 & $rbox49 & $rbox50 & $rbox51 & $rbox52 & $rbox53 & $rbox54 & $rbox55 & $rbox56 & $rbox57 & $rbox58 & $rbox59 & $rbox60 & $rbox61 & $rbox62 & $rbox63 & $rbox64 & $rbox65 & $rbox66 & $rbox67 & $rbox68 & $rbox69 & $rbox70 & $rbox71 & $rbox72 & $rbox63 & $rbox74, 1)
	If IsArray($asr) Then
		If $asr[0] > 0 Then
			For $tim = 1 To $asr[0]
				$siz = Round(FileGetSize($asr[$tim]) / 1024, 1) & "KB"
				$total = $total + FileGetSize($asr[$tim])
				GUICtrlCreateListViewItem($siz & "|" & $asr[$tim], $list5)
			Next
			GUICtrlSetData($list5, "" & "|" & _GUICtrlListViewGetItemCount($list5) & " Files Found " & Round($total / 1024, 2) & " KB")
		EndIf
	EndIf
	support()
	GUICtrlSetData($button10, "Analyse")
	WinSetTitle("PUP", "", $version)
EndFunc

Func support()
	$rbox1 = ""
	$rbox2 = ""
	$rbox3 = ""
	$rbox4 = ""
	$rbox5 = ""
	$rbox6 = ""
	$rbox7 = ""
	$rbox8 = ""
	$rbox9 = ""
	$rbox10 = ""
	$rbox11 = ""
	$rbox12 = ""
	$rbox13 = ""
	$rbox14 = ""
	$rbox15 = ""
	$rbox16 = ""
	$rbox17 = ""
	$rbox18 = ""
	$rbox19 = ""
	$rbox20 = ""
	$rbox21 = ""
	$rbox22 = ""
	$rbox23 = ""
	$rbox24 = ""
	$rbox25 = ""
	$rbox26 = ""
	$rbox27 = ""
	$rbox28 = ""
	$rbox29 = ""
	$rbox30 = ""
	$rbox31 = ""
	$rbox32 = ""
	$rbox33 = ""
	$rbox34 = ""
	$rbox35 = ""
	$rbox36 = ""
	$rbox37 = ""
	$rbox38 = ""
	$rbox39 = ""
	$rbox40 = ""
	$rbox41 = ""
	$rbox42 = ""
	$rbox43 = ""
	$rbox44 = ""
	$rbox45 = ""
	$rbox46 = ""
	$rbox47 = ""
	$rbox48 = ""
	$rbox49 = ""
	$rbox50 = ""
	$rbox51 = ""
	$rbox52 = ""
	$rbox53 = ""
	$rbox54 = ""
	$rbox55 = ""
	$rbox56 = ""
	$rbox57 = ""
	$rbox58 = ""
	$rbox59 = ""
	$rbox60 = ""
	$rbox61 = ""
	$rbox62 = ""
	$rbox63 = ""
	$rbox64 = ""
	$rbox65 = ""
	$rbox66 = ""
	$rbox67 = ""
	
EndFunc

Func junkclean()
	If _GUICtrlListViewGetItemCount($list5) = 0 Then
		Sleep(10)
	Else
		GUICtrlSetData($button11, "Cancel")
		WinSetTitle($version, "", "PUP - Deleting Please Wait")
		$fop = FileOpen("tmp.txt", 2)
		$count = ""
		$count = _GUICtrlListViewGetItemCount($list5)
		For $u = 0 To $count - 1
			$check = _GUICtrlListViewGetCheckedState($list5, $u)
			If $check = 1 Then
				$mad = _GUICtrlListViewGetItemText($list5, $u)
				$split = StringSplit($mad, "|")
				If @error Then ContinueLoop
				FileWrite("tmp.txt", $split[2] & @CRLF)
				$split[2] = ""
				_GUICtrlListViewDeleteItem($list5, $u)
				$u = $u - 1
			EndIf
		Next
		FileClose($fop)
		securedel()
		WinSetTitle("PUP", "", $version)
		GUICtrlSetData($list5, "Size | File(s) Found")
		GUICtrlSetData($button11, "Delete")
	EndIf
EndFunc

Func washdrive()
	GUICtrlSetData($progress, 0)
	GUICtrlSetData($button30, "Stop Washing")
	GUICtrlSetTip( -1, "This button will allow you to stop the current procces")
	$slim3 = _GUICtrlListViewGetCurSel($list13)
	$mad = _GUICtrlListViewGetItemText($list13, $slim3)
	$mao = StringSplit($mad, "|")
	$spaceu = Round(DriveSpaceTotal($mao[1]), 1) - Round(DriveSpaceFree($mao[1]), 1)
	$calc = Round(DriveSpaceFree($mao[1]))
	Local $chr = ""
	While 1
		If Round(DriveSpaceFree($mao[1])) > 10 Then
			For $e = 1 To 200
				$rand = Random(0, 255, 1)
				$chr = $chr & Chr($rand)
				FileWrite($mao[1] & "\temp.txt", $chr)
			Next
			Sleep(10)
			$spaceu2 = (Round(DriveSpaceTotal($mao[1]), 1) - Round(DriveSpaceFree($mao[1]), 1)) - Round($spaceu)
			GUICtrlSetData($progress, $spaceu2 / $calc * 100)
			GUICtrlSetData($label, Round($spaceu2 / $calc * 100, 2) & "% Washing Free Space")
		Else
			GUICtrlSetData($progress, 100)
			GUICtrlSetData($label, "100%")
			ExitLoop
		EndIf
		$m = GUIGetMsg()
		If $m = $button30 Then 
			GUICtrlSetData($button30, "Start Washing")
			ExitLoop
		EndIf
	WEnd
	For $t = 0 To 2
	mom()
		FileSetTime($mao[1] & "\temp.txt", $ra1 & $ra2 & $ra3, $t)
	Next
	kill()
	GUICtrlSetData($progress, 0)
	If GUICtrlRead($checkbox1) = $GUI_CHECKED And GUICtrlRead($label) == "100%" Then
		Shutdown(9)
	Else
		GUICtrlSetData($label, "")
	EndIf
EndFunc

Func kill()
	$slim = _GUICtrlListViewGetCurSel($list13)
	$mad = _GUICtrlListViewGetItemText($list13, $slim3)
	$mao = StringSplit($mad, "|")
	If FileExists($mao[1] & "\temp.txt") Then FileDelete($mao[1] & "\temp.txt")
EndFunc

Func exitr()
	If WinActive($version) Then
		If FileExists("tmp.txt") Then FileDelete("tmp.txt")
		kill()
		Exit
	EndIf
EndFunc

Func _FileSearch($szMask, $nOption)
	Opt("GUIOnEventMode", 1)
	GUICtrlSetOnEvent($button10, "cance")
	$szRoot = ""
	$hFile = 0
	$szBuffer = ""
	$szReturn = ""
	$szPathList = "*"
	Dim $aNULL[1]
	GUICtrlSetData($progress, 0)
	Local $ttr
	If Not StringInStr($szMask, "\") Then
		$drvindx = _GUICtrlListViewGetCurSel($list4)
		$drvsel = _GUICtrlListViewGetItemText($list4, $drvindx)
		$szRoot = $drvsel & "\"
	Else
		While StringInStr($szMask, "\")
			$szRoot = $szRoot & StringLeft($szMask, StringInStr($szMask, "\"))
			$szMask = StringTrimLeft($szMask, StringInStr($szMask, "\"))
		WEnd
	EndIf
	If $nOption = 0 Then
		_FileSearchUtil($szRoot, $szMask, $szReturn)
		Opt("GUIOnEventMode", 0)
	Else
		While 1
			If $larr = 1 Then
				$ttr = $ttr + 325 / Round(DriveSpaceFree($drvsel))
				GUICtrlSetData($progress, $ttr)
			EndIf
			$hFile = FileFindFirstFile($szRoot & "*.*")
			If $hFile >= 0 Then
				$szBuffer = FileFindNextFile($hFile)
				While Not @error
					If $szBuffer <> "." And $szBuffer <> ".." And _
							StringInStr(FileGetAttrib($szRoot & $szBuffer), "D") Then _
							$szPathList = $szPathList & $szRoot & $szBuffer & "*"
					$szBuffer = FileFindNextFile($hFile)
				WEnd
				FileClose($hFile)
			EndIf
			$string = StringSplit($szMask, "|")
			For $m = 1 To $string[0]
				_FileSearchUtil($szRoot, $string[$m], $szReturn)
			Next
			If $szPathList == "*" Then ExitLoop
			$szPathList = StringTrimLeft($szPathList, 1)
			$szRoot = StringLeft($szPathList, StringInStr($szPathList, "*") - 1) & "\"
			$szPathList = StringTrimLeft($szPathList, StringInStr($szPathList, "*") - 1)
		WEnd
		Opt("GUIOnEventMode", 0)
		GUICtrlSetData($button10, "Analyze")
	EndIf
	GUICtrlSetData($progress, 100)
	If $szReturn = "" Then
		$aNULL[0] = 0
		Return $aNULL
	Else
		Return StringSplit(StringTrimRight($szReturn, 1), "*")
	EndIf
EndFunc

Func _FileSearchUtil(ByRef $ROOT, ByRef $MASK, ByRef $RETURN)
	$hFile = FileFindFirstFile($ROOT & $MASK)
	If $hFile >= 0 Then
		$szBuffer = FileFindNextFile($hFile)
		While Not @error
			If $szBuffer <> "." And $szBuffer <> ".." Then _
					$RETURN = $RETURN & $ROOT & $szBuffer & "*"
			$szBuffer = FileFindNextFile($hFile)
		WEnd
		FileClose($hFile)
	EndIf
EndFunc

Func killtemp()
	$readcombo = GUICtrlRead($combo)
	If $readcombo = "Standard Deletion Method" Then
		FileDelete("tmp.txt")
	ElseIf $readcombo = "Zeros" Then
		$filesize = FileGetSize("tmp.txt")
		For $m = 1 To GUICtrlRead($inp1)
			$s = 0
			Local $chr = ""
			Local $arra = 1
			$fop = FileOpen("tmp.txt", 2)
			While $arra = 1
				For $s = 0 To 200
					$chr = $chr & Chr(48)
					$stt = FileWrite($fop, $chr)
				Next
				Sleep(10)
				If Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100) > 100 Then
					GUICtrlSetData($progress, 100)
				Else
					GUICtrlSetData($progress, Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100))
				EndIf
				If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
			WEnd
			FileClose($fop)
			For $t = 0 To 2
				mom()
				FileSetTime("tmp.txt", $ra1 & $ra2 & $ra3, $t)
			Next
		Next
	ElseIf $readcombo = "Random-Character" Then
		$filesize = FileGetSize("tmp.txt")
		For $m = 1 To GUICtrlRead($inp1)
			$s = 0
			Local $chr = ""
			Local $arra = 1
			$ran = Chr(Random(0, 255, 1))
			$fop = FileOpen("tmp.txt", 2)
			While $arra = 1
				For $s = 0 To 200
					$chr = $chr & $ran
					$stt = FileWrite($fop, $chr)
				Next
				Sleep(10)
				If Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100) > 100 Then
					GUICtrlSetData($progress, 100)
				Else
					GUICtrlSetData($progress, Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100))
				EndIf
				If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
			WEnd
			FileClose($fop)
			If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
				For $t = 0 To 2
					mom()
					FileSetTime("tmp.txt", $ra1 & $ra2 & $ra3, $t)
				Next
			EndIf
		Next
	ElseIf $readcombo = "Random-Reverse" Then
		$filesize = FileGetSize("tmp.txt")
		For $m = 1 To GUICtrlRead($inp1)
			$s = 0
			Local $chr = ""
			Local $arra = 1
			$ran = Random(0, 255, 1)
			$fop = FileOpen("tmp.txt", 2)
			While $arra = 1
				For $s = 0 To 200
					$ran = Random(0, 255, 1)
					$chr = $chr & Chr($ran)
				Next
				Sleep(10)
				$stt = FileWrite($fop, $chr)
				If Round(((StringLen($chr) ^ 2) / 500) / $filesize * 100) > 100 Then
					GUICtrlSetData($progress, 100)
				Else
					GUICtrlSetData($progress, Round(((StringLen($chr) ^ 2) / 500) / $filesize * 100))
				EndIf
				If (StringLen($chr) ^ 2) / 500 >= $filesize Then $arra = 0
			WEnd
			FileClose($fop)
			If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
				For $t = 0 To 2
					mom()
					FileSetTime("tmp.txt", $ra1 & $ra2 & $ra3, $t)
				Next
			EndIf
		Next
	ElseIf $readcombo = "Random-Chunk" Then
		$filesize = FileGetSize("tmp.txt")
		For $m = 1 To GUICtrlRead($inp1)
			$s = 0
			Local $chr = ""
			Local $arra = 1
			$ran = Random(0, 255, 1)
			$fop = FileOpen("tmp.txt", 2)
			While $arra = 1
				For $s = 0 To 200
					$ran = Random(0, 255, 1)
					$chr = $chr & Chr($ran)
					$stt = FileWrite($fop, $chr)
				Next
				Sleep(10)
				If Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100) > 100 Then
					GUICtrlSetData($progress, 100)
				Else
					GUICtrlSetData($progress, Round(((StringLen($chr) ^ 2) / 2) / $filesize * 100))
				EndIf
				If (StringLen($chr) ^ 2) / 2 >= $filesize Then $arra = 0
			WEnd
			FileClose($fop)
			If GUICtrlRead($Checkpl) = $GUI_CHECKED Then
				For $t = 0 To 2
					mom()
					FileSetTime("tmp.txt", $ra1 & $ra2 & $ra3, $t)
				Next
			EndIf
		Next
	EndIf
	FileClose("tmp.txt")
	FileDelete("tmp.txt")
EndFunc


Func SpecialEvent()
    GuiSetState(@SW_Show)
    Opt("TrayIconHide", 1)
EndFunc

;~ Func Update()
;~     While 1
;~         $h = @HOUR
;~         $m = @MIN
;~        
;~         If $h > 12 Then
;~             $h = $h - 12
;~             $m = $m & " PM"
;~         Else
;~             If $h = 12 Then
;~                 $m = $m & " PM"
;~             Else
;~                 $m = $m & " AM"
;~             EndIf
;~         EndIf
;~        
;~         GUICtrlSetData($date, GetDayOfWeek() & ", " & GetMonth() & " " & @MDAY & ", " & @YEAR & "   " & $h & ":" & $m)
;~         Sleep(500)
;~         GUICtrlSetData($date, GetDayOfWeek() & ", " & GetMonth() & " " & @MDAY & ", " & @YEAR & "   " & $h & " " & $m)
;~         Sleep(500)
;~     WEnd
;~ EndFunc


;~ Func GetDayOfWeek()
;~     $a = @WDAY
;~     If $a = 1 Then Return "Sunday"
;~     If $a = 2 Then Return "Monday"
;~     If $a = 3 Then Return "Tuesday"
;~     If $a = 4 Then Return "Wednesday"
;~     If $a = 5 Then Return "Thursday"
;~     If $a = 6 Then Return "Friday"
;~     If $a = 7 Then Return "Saturday"
;~ EndFunc

;~ Func GetMonth()
;~     $a = @MON
;~     If $a = 1 Then Return "January"
;~     If $a = 2 Then Return "February"
;~     If $a = 3 Then Return "March"
;~     If $a = 4 Then Return "April"
;~     If $a = 5 Then Return "May"
;~     If $a = 6 Then Return "June"
;~     If $a = 7 Then Return "July"
;~     If $a = 8 Then Return "August"
;~     If $a = 9 Then Return "September"
;~     If $a = 10 Then Return "October"
;~     If $a = 11 Then Return "November"
;~     If $a = 12 Then Return "December"
;~ EndFunc

Func DropFile()
If @GUI_DropId <> $listview Then Return
$f = @GUI_DragFile
_GUICtrlListViewInsertItem($listview,-1,$f);may not be the way you want to do it but just to demonstrate

EndFunc

Func cance()
	Run(@AutoItExe & " " & FileGetShortName(@ScriptFullPath))
	Exit
EndFunc