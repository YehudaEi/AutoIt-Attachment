#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GuiConstantsEx.au3>
#include <GUIListBox.au3>
#include <GuiEdit.au3>
#Include <Constants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
;
Opt("TrayMenuMode", 1)
Opt("WinTitleMatchMode", 3)
;
#Region ### Tray ###
TraySetClick(16)
TraySetToolTip("Torrent Search")
$SearchMini	 	= TrayCreateItem("Search")
			TrayCreateItem("")
$Exit			= TrayCreateItem("Exit")
#EndRegion ### Tray ###
;
Global $INIFile = "mininova.ini"
$GetCategory1    = IniRead($INIFile, "Settings", "category", "All Torrents")
$GetSortType1    = IniRead($INIFile, "Settings", "sorttype", "Added")
$GetCategory2    = IniRead($INIFile, "Settings", "category2", "All")
$GetSortType2    = IniRead($INIFile, "Settings", "sorttype2", "Uploaded")
$GetSite		 = IniRead($INIFile, "Settings", "site", "mininova.org")
$GetSaved	     = IniRead($INIFile, "Settings", "saved", "")
$InputColor		 = IniRead($INIFile, "Settings", "input_color", "0x313131")
$InputTextColor	 = IniRead($INIFile, "Settings", "input_text_color", "0xFFFFFF")
$W 				 = IniRead($INIFile, "Settings", "width_px", "320")
If $W < 320 Then $W = 320
If $W > 540 Then $W = 540
;
Global $TrackerFile	= "Tracker.txt"
Global $Title = "Torrent Search"
Global $Tip[8][2] = [[0, ""], _
					 [1, "Press 'Set default' to save the settings."], _
					 [2, "The tracker button will set a list of tracker to your clipboard."], _
					 [3, "Press Shift+Enter to save your search when offline."], _
					 [4, "Type {open} to go to mininova's webpage."], _
					 [5, "You can drag the window by holding the mouse down."], _
					 [6, "Type {ini} edit the options in the ini file."], _
					 [7, "For best results, search with seeds."]]
					 
$t = 1 ; start with tip 1
;
If Not FileExists($TrackerFile) Then InetGet("                                            ", $TrackerFile)
If Not FileExists($INIFile) 	Then InetGet("                                             ", $INIFile)
;
#Region ### START Koda GUI section ### Form=
Global $H = 44
Global $H2	= 145

$Form1 			= GUICreate($Title, $W, 44, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
			GUISetFont(8, 400, 0, "Tohoma")
			GUISetBkColor(0xf4f4f4)
			
			;Rectangle
$REC			= GUICtrlCreateGraphic(4, 4, $W - 9, 28) 
			GUICtrlSetBkColor(-1, $InputColor)
			GUICtrlSetColor(-1, 0x646464)
			GUICtrlSetState(-1, $GUI_DISABLE)    
			GUICtrlSetResizing(-1, $GUI_DOCKALL)

			;Search Input
$Input1 		= GUICtrlCreateEdit("search "&StringTrimRight($GetSite,4), 6, 9, $W - 68, 22, 0, 0)
			GUICtrlSetFont(-1, 12, 400, 0, "Lucida Grande")
			GUICtrlSetBkColor(-1, $InputColor)
			GUICtrlSetColor(-1, 0x808080)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			If $GetSaved <> "" Then
				GUICtrlSetColor(-1, $InputTextColor)
				GUICtrlSetData(-1, $GetSaved)
			EndIf
			
			;System Buttons
$ButtonQ		= GUICtrlCreateButton("?", $W - 62, 4, 15, 28, $BS_FLAT)
			GUICtrlSetFont(-1, 9, 400, 0, "System")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Tips")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$ButtonM		= GUICtrlCreateButton("_", $W - 48, 4, 15, 28, $BS_FLAT)
			GUICtrlSetFont(-1, 9, 400, 0, "System")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Hide To Tray")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$ButtonX		= GUICtrlCreateButton("[]", $W - 34, 4, 15, 28, $BS_FLAT)
			GUICtrlSetFont(-1, 9, 400, 0, "System")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Show Options")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Button1		= GUICtrlCreateButton("x", $W - 20, 4, 15, 28, $BS_FLAT)
			GUICtrlSetFont(-1, 9, 400, 0, "System")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Close")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
			;Other Buttons
$Button3		= GUICtrlCreateButton("Set default", 210,60, 60, 20, $BS_FLAT)
			GUICtrlSetFont(-1, 8, 400, 0, "Arial")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Set what is shown on the left as defaults")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Checkbox1		= GUICtrlCreateCheckbox("Window Always on Top", 8, 92)
			GUICtrlSetFont(-1, 8, 400, 0, "Arial")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUIGetOnTop()
			
$Button2 		= GUICtrlCreateButton("Trackers", 210, 116, 60, 19, $BS_FLAT)
			GUICtrlSetFont(-1, 8, 400, 0, "Arial")
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetTip(-1, "Copy a set of trackers to your clipboard")
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Combo1 		= GUICtrlCreateCombo("", 62, 44, 145, 25, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, "All Torrents|Featured|Anime|Books|Games|Movies|Music|Pictures|Software|TV Shows|Other", $GetCategory1)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			If $GetSite = "piratebay.org" Then GUICtrlSetState(-1, $GUI_HIDE)
			
$Combo2 		= GUICtrlCreateCombo("", 62, 68, 145, 25, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, "Added|Category|Name|Comments|Size|Seeds|Leechers", $GetSortType1)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			If $GetSite = "piratebay.org" Then GUICtrlSetState(-1, $GUI_HIDE)
			
$Combo4 		= GUICtrlCreateCombo("", 62, 44, 145, 25, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, "All|Audio|Video|Games|Applications|Other", $GetCategory2)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			If $GetSite = "mininova.org" Then GUICtrlSetState(-1, $GUI_HIDE)
			
$Combo5 		= GUICtrlCreateCombo("", 62, 68, 145, 25, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, "Type|Name|Uploaded|Size|Seeds|Leechers", $GetSortType2)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			If $GetSite = "mininova.org" Then GUICtrlSetState(-1, $GUI_HIDE)
			
$Label1 		= GUICtrlCreateLabel("Category:", 8, 48, 50, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Label2 		= GUICtrlCreateLabel("Sort By:", 8, 72, 50, 17, $SS_RIGHT)
			GUICtrlSetState(-1, $GUI_FOCUS)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Label4 		= GUICtrlCreateLabel("Online", 2, 31, $W - 4, 12)
			GUICtrlSetTip(-1, "You can now search on mininova", "Online", 1)
			GUICtrlSetFont(-1, 8, 400, 2, "Tohoma")
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
			If @IPAddress1 = "127.0.0.1" Then
				GUICtrlSetData($Label4, "Offine")
				GUICtrlSetTip(-1, "Will not conduct search if you're offline.", "Offline", 3)
			EndIf
			
$Label2 		= GUICtrlCreateLabel("Site:", 8, 118, 50, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			
$Combo3 		= GUICtrlCreateCombo("", 62, 115, 145, 25, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, "mininova.org|piratebay.org", $GetSite)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
#EndRegion ### END Koda GUI section ###
;
While 1
	$TMsg = TrayGetMsg()
	Switch $TMsg
		Case $TRAY_EVENT_PRIMARYDOWN, $SearchMini	
			If GUICtrlRead($ButtonX) = "[]" Then
			Else			
				WinMove($Title, "", Default, Default, $W + 1, $H + 1, 1)
				GUICtrlSetData($ButtonX, "[]")
				GUICtrlSetTip($ButtonX, "Extend")
			EndIf
			
			GUISetState(@SW_SHOW)
			GUICtrlSetState($Input1, $GUI_FOCUS)
			WinActivate($Title)
		Case $Exit
			DllCall('user32.dll', 'int', 'AnimateWindow', 'hwnd', $Form1, 'int', 300, 'long', 0x00050010)
			_Exit()
	EndSwitch
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $Button1
			DllCall('user32.dll', 'int', 'AnimateWindow', 'hwnd', $Form1, 'int', 300, 'long', 0x00050010)
			_Exit() 
		Case $GUI_EVENT_PRIMARYDOWN
			GUISetCursor(9, 1, $Form1)
			DllCall('user32.dll', 'int', _
					'SendMessage', 'hWnd', $Form1, _
					'int', 0x00A1, 'int', 2, 'int', 0)
			GUISetCursor(-1, 1, $Form1)
		Case $Button2
			$Tracker = FileRead($TrackerFile)
			ClipPut($Tracker)
		Case $Button3
			IniWrite($INIFile, "Settings", "category", GUICtrlRead($Combo1))
			IniWrite($INIFile, "Settings", "sorttype", GUICtrlRead($Combo2))
			IniWrite($INIFile, "Settings", "category2", GUICtrlRead($Combo4))
			IniWrite($INIFile, "Settings", "sorttype2", GUICtrlRead($Combo5))
		Case $ButtonM
			GUISetState(@SW_HIDE)
		Case $ButtonQ
			If $t = UBound($Tip) Then $t = 1
			$hTip = $Tip[$t][1]
			$t += 1
			GUICtrlSetState($Label4, $GUI_FOCUS)
			GUICtrlSetData($Label4, $hTip)
		Case $ButtonX
			If GUICtrlRead($ButtonX) = "[]" Then
				$pos = WinGetPos($Title, "")
				
				If $pos[1] > @DesktopHeight - $H2 - 10 Then
					WinMove($Title, "", Default, ($pos[1]-($H2/2))-25, $W + 1, $H2)
				Else
					WinMove($Title, "", Default, Default, $W + 1, $H2)
				EndIf
								
				GUICtrlSetData($ButtonX, "^")
				GUICtrlSetTip($ButtonX, "Hide Options")
				GUICtrlSetState($Label4, $GUI_FOCUS)
			Else			
				WinMove($Title, "", Default, Default, $W + 1, $H + 2)
				GUICtrlSetData($ButtonX, "[]")
				GUICtrlSetTip($ButtonX, "Show Options")
				GUICtrlSetState($Label4, $GUI_FOCUS)
			EndIf
		Case $Checkbox1
			If BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($Checkbox1, $GUI_CHECKED)
				WinSetOnTop($Title, "", 1)
				IniWrite($INIFile, "Settings", "ontop", "1")
            Else
                GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
				WinSetOnTop($Title, "", 0)
				IniWrite($INIFile, "Settings", "ontop", "0")
            EndIf
	EndSwitch
	
	If WinActive($Title) Then
		HotKeySet("{ENTER}", "_Search")
		HotKeySet("+{ENTER}", "_ShiftEnter")
	Else
		HotKeySet("{ENTER}")
		HotKeySet("+{ENTER}")
	EndIf
WEnd
;
Func GetCategory($hCat, $hSite="mininova.org")
	Switch $hSite
		Case "mininova.org"
			Switch $hCat
				Case "All Torrents"
					Return "0"
				Case "Anime"
					Return "1"
				Case "Books"
					Return "2"
				Case "Games"
					Return "3"
				Case "Movies"
					Return "4"
				Case "Music"
					Return "5"
				Case "Pictures"
					Return "6"
				Case "Software"
					Return "7"
				Case "TV Shows"
					Return "8"
				Case "Other"
					Return "9"
				Case "Featured"
					Return "10"
			EndSwitch
		Case "piratebay.org"
			Switch $hCat
				Case "All"
					Return "99"
				Case "Audio"
					Return "100"
				Case "Video"
					Return "200"
				Case "Games"
					Return "300"
				Case "Applications"
					Return "400"
				Case "Other"
					Return "600"
			EndSwitch
	EndSwitch
	
EndFunc
;
Func GetSortType($hSort, $hSite="mininova.org")
	Switch $hSite
		Case "mininova.org"
			Switch $hSort
				Case "Added"
					Return "added"
				Case "Category"
					Return "cat"
				Case "Name"
					Return "name"
				Case "Comments"
					Return "comments"
				Case "Size"
					Return "size"
				Case "Seeds"
					Return "seeds"
				Case "Leechers"
					Return "leech"
			EndSwitch
		Case "piratebay.org"
			Switch $hSort
				Case "Type"
					Return "13"
				Case "Name"
					Return "1"
				Case "Uploaded"
					Return "3"
				Case "Size"
					Return "5"
				Case "Seeds"
					Return "7"
				Case "Leechers"
					Return "9"
			EndSwitch
	EndSwitch
EndFunc
;			
Func _Search()
	Local $GetSite = IniRead($INIFile, "Settings", "site", "mininova.org")
	
	$KeyWord	= GUICtrlRead($Input1)
	If $KeyWord = "search mininova" Or $KeyWord = "search piratebay" or $KeyWord = "" Then Return
	If StringInStr($KeyWord, "{") Then Return
	Switch $GetSite
		Case "mininova.org"
			$Category	= GetCategory(GUICtrlRead($Combo1), $GetSite) 
			$Sort		= GetSortType(GUICtrlRead($Combo2), $GetSite)
			$KeyWord	= StringReplace($KeyWord, "&", "%2526")
			$KeyWord	= StringReplace($KeyWord, " ", "%2B") 
			
			$Address	= "                               " & $KeyWord & "/" & $Category & "/" & $Sort
		Case "piratebay.org"
			$Category	= GetCategory(GUICtrlRead($Combo4), $GetSite) 
			$Sort		= GetSortType(GUICtrlRead($Combo5), $GetSite)
			$KeyWord	= StringReplace($KeyWord, " ", "%20") 
			
			$Address 	= "                               " & $KeyWord & "/0/" & $Sort & "/" & $Category
	EndSwitch
	If @IPAddress1 = "127.0.0.1" Then
		GUICtrlSetColor($Label4, 0x0000DE)
		GUICtrlSetData($Label4, "Offine")
		GUICtrlSetTip(-1, "Will not conduct search if you're offline.", "Offline", 3)
		Sleep(1000)
		GUICtrlSetColor($Label4, 0)
	Else
		GUICtrlSetData($Label4, "Online")
		GUICtrlSetTip(-1, "You can now search on mininova", "Online", 1)
		GUICtrlSetData($Label4, "")
		GUICtrlSetData($Input1, "")
		
		GUICtrlSetColor($REC, 0xFFFF09)
		ShellExecute($Address)
		Sleep(500)
		GUICtrlSetColor($REC, 0)
	EndIf
EndFunc
;
Func _ShiftEnter()
	Local $GetSite = IniRead($INIFile, "Settings", "site", "mininova.org")
	Switch GUICtrlRead($Input1)
		Case "search mininova", "search piratebay", "" 
			GUICtrlSetData($Label4, "Type first then press Shift+Enter. To erase existing, type {DLT}")
			
		Case "{open}" 
			ShellExecute("http://" & $GetSite)
			
		Case "{DLT}" 
			GUICtrlSetData($Label4, "Erased")
			Sleep(600)
			IniWrite($INIFile, "Settings", "saved", "")
			GUICtrlSetData($Label4, "")
			GUICtrlSetTip($Label4, "")
			GUICtrlSetData($Input1, "")
			GUICtrlSetState($Label4, $GUI_FOCUS)
					
		Case "{ini}" 
			ShellExecute($INIFile)
			
		Case Else
			GUICtrlSetData($Label4, "Saved")
			Sleep(600)
			IniWrite($INIFile, "Settings", "saved", GUICtrlRead($Input1))
			GUICtrlSetData($Label4, "")
	EndSwitch
EndFunc
;
Func _Exit()
	Exit
EndFunc
;
Func GUIGetOnTop()
	If IniRead($INIFile, "Settings", "ontop", "0") = 1 Then
		GUICtrlSetState($Checkbox1, $GUI_CHECKED)
		WinSetOnTop($Title, "", 1)
	Else
		GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
		WinSetOnTop($Title, "", 0)
	EndIf
EndFunc
;
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $GetSite = IniRead($INIFile, "Settings", "site", "mininova.org")
    Local $hWndFrom, $iIDFrom, $iCode
    $hWndEdit1 = GUICtrlGetHandle($Input1)
    $hWndCombo = GUICtrlGetHandle($Combo3)
    $hWndFrom = $ilParam
    $iIDFrom = _WinAPI_LoWord($iwParam)
    $iCode = _WinAPI_HiWord($iwParam)
    Switch $hWndFrom
        Case $hWndEdit1
            Switch $iCode
                Case $EN_KILLFOCUS
					GUICtrlSetColor($REC, 0x646464)
                    
					If _GUICtrlEdit_GetTextLen($Input1) = 0 Then
                        GUICtrlSetData($Input1, "search " & StringTrimRight($GetSite, 4))
                        GUICtrlSetColor($Input1, 0x808080)
                    EndIf
				Case $EN_SETFOCUS    
					GUICtrlSetColor($REC, 0)
					
                    If GUICtrlRead($Input1) = "search mininova" Then
                        GUICtrlSetData($Input1, "")
                        GUICtrlSetColor($Input1, $InputTextColor)
                    EndIf
                    If GUICtrlRead($Input1) = "search piratebay" Then
                        GUICtrlSetData($Input1, "")
                        GUICtrlSetColor($Input1, $InputTextColor)
                    EndIf
				Case $EN_CHANGE
					Switch GUICtrlRead($Input1) 
						Case "{DLT}"
							GUICtrlSetData($Label4, "Now press Shift+Enter to erase saved search.")
						Case "{ALL}"
							GUICtrlSetData($Label4, "Now press Shift+Enter to show a list of all in that category.")
						Case "{OPEN}" 
							GUICtrlSetData($Label4, "Now press Shift+Enter to go to mininova.org.")
						Case "{INI}" 
							GUICtrlSetData($Label4, "Now press Shift+Enter to edit the ini file.")
						Case Else
							GUICtrlSetData($Label4, "")
							GUICtrlSetTip($Label4, "")
					EndSwitch
					If GUICtrlRead($ButtonX) <> "[]" Then		
						WinMove($Title, "", Default, Default, $W + 1, $H + 2,1)
						GUICtrlSetData($ButtonX, "[]")
						GUICtrlSetTip($ButtonX, "Extend")
					EndIf
            EndSwitch
		Case $hWndCombo
			Switch $iCode
				Case $CBN_SELCHANGE
					IniWrite($INIFile, "Settings", "site", GUICtrlRead($Combo3))
					GUICtrlSetData($Input1, "search " & StringTrimRight(GUICtrlRead($Combo3), 4))
					If GUICtrlRead($Combo3) = "mininova.org" Then
						GUICtrlSetState($Combo1, $GUI_SHOW)
						GUICtrlSetState($Combo2, $GUI_SHOW)
						GUICtrlSetState($Combo4, $GUI_HIDE)
						GUICtrlSetState($Combo5, $GUI_HIDE)
					Else
						GUICtrlSetState($Combo1, $GUI_HIDE)
						GUICtrlSetState($Combo2, $GUI_HIDE)
						GUICtrlSetState($Combo4, $GUI_SHOW)
						GUICtrlSetState($Combo5, $GUI_SHOW)
					EndIf
					
			EndSwitch
   EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc