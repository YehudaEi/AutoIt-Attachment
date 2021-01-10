#include <GUIConstants.au3>
;#include "ModernMenu.au3"
#include "ModernMenuRaw.au3" ; Only unknown constants are declared here

#NoTrayIcon

Opt("GUIOnEventMode", 1) ; This is for both - GUI and Tray ownerdrawn menu items

GUISetOnEvent($GUI_EVENT_CLOSE, "MenuEvents")

$bUseAdvTrayMenu = False

FileInstall("Icons\Menu.ico", @TempDir & "\Menu.ico")
FileInstall("Icons\Office.ico", @TempDir & "\Office.ico")
FileInstall("Icons\Access2007.ico", @TempDir & "\Access2007.ico")
FileInstall("Icons\Excel2007.ico", @TempDir & "\Excel2007.ico")
FileInstall("Icons\OneNote2007.ico", @TempDir & "\OneNote2007.ico")
FileInstall("Icons\Outlook2007.ico", @TempDir & "\Outlook2007.ico")
FileInstall("Icons\PowerPoint2007.ico", @TempDir & "\PowerPoint2007.ico")
FileInstall("Icons\Word2007.ico", @TempDir & "\Word2007.ico")
FileInstall("Icons\Access2003.ico", @TempDir & "\Access2003.ico")
FileInstall("Icons\Excel2003.ico", @TempDir & "\Excel2003.ico")
FileInstall("Icons\Outlook2003.ico", @TempDir & "\Outlook2003.ico")
FileInstall("Icons\PowerPoint2003.ico", @TempDir & "\PowerPoint2003.ico")
FileInstall("Icons\Word2003.ico", @TempDir & "\Word2003.ico")
FileInstall("Icons\IE.ico", @TempDir & "\IE.ico")
FileInstall("Icons\IEdoc.ico", @TempDir & "\IEdoc.ico")
FileInstall("Icons\Explorer.ico", @TempDir & "\Explorer.ico")
FileInstall("Icons\Folder.ico", @TempDir & "\Folder.ico")

; You can also the same things on context menus
$GUIContextMenu	= GUICtrlCreateContextMenu(-1)
$ConAboutItem	= _GUICtrlCreateODMenuItem("About...", $GUIContextMenu, "explorer.exe", -8)
GUICtrlSetOnEvent(-1, "MenuEvents")
_GUICtrlCreateODMenuItem("", $GUIContextMenu) ; Separator
$ConExitItem	= _GUICtrlCreateODMenuItem("Exit", $GUIContextMenu, "shell32.dll", -28)
GUICtrlSetOnEvent(-1, "MenuEvents")

GUICtrlCreateButton("Test", 100, 200, 70, 20)
GUISetState()

;Create the tray icon
$nTrayIcon1		= _TrayIconCreate("EFG Tray Menu", @TempDir & "\Menu.ico", 0)
_TrayIconSetClick(-1, 16)
_TrayIconSetState() ; Show the tray icon

; *** Create the tray context menu ***
$nTrayMenu1		= _TrayCreateContextMenu() ; is the same like _TrayCreateContextMenu(-1) or _TrayCreateContextMenu($nTrayIcon1)
$nSideItem3		= _CreateSideMenu($nTrayMenu1)
_SetSideMenuText($nSideItem3, "EFG Tray Menu")
_SetSideMenuColor($nSideItem3, 0xFFFFFF) ; yellow; default color - white
_SetSideMenuBkColor($nSideItem3, 0x000033) ; bottom start color - dark blue
_SetSideMenuBkGradColor($nSideItem3, 0x4477AA) ; top end color - orange
;_SetSideMenuImage($nSideItem3, "shell32.dll", 309, TRUE)

; Check for MS files
$Office2k7 = @ProgramFilesDir & "\Microsoft Office\Office12"
$Office2k3 = @ProgramFilesDir & "\Microsoft Office\Office11"
Global $2k7Access, $2k7Excel, $2k7Onenote, $2k7Outlook, $2k7Powerpoint, $2k7Word, $2k7AccessMenu, $2k7ExcelMenu, $2k7OnenoteMenu, $2k7OutlookMenu, $2k7PowerpointMenu, $2k7WordMenu
Global $2k3Access, $2k3Excel, $2k3Onenote, $2k3Outlook, $2k3Powerpoint, $2k3Word, $2k3AccessMenu, $2k3ExcelMenu, $2k3OnenoteMenu, $2k3OutlookMenu, $2k3PowerpointMenu, $2k3WordMenu

; Check if Office 2007 files exist
If FileExists($Office2k7 & "\MSACCESS.EXE") Then
	$2k7Access = 1
EndIf
If FileExists($Office2k7 & "\EXCEL.EXE") Then
	$2k7Excel = 1
EndIf
If FileExists($Office2k7 & "\ONENOTE.EXE") Then
	$2k7Onenote = 1
EndIf
If FileExists($Office2k7 & "\OUTLOOK.EXE") Then
	$2k7Outlook = 1
EndIf
If FileExists($Office2k7 & "\POWERPNT.EXE") Then
	$2k7Powerpoint = 1
EndIf
If FileExists($Office2k7 & "\WINWORD.EXE") Then
	$2k7Word = 1
EndIf

; Check if Office 2003 files exist
If FileExists($Office2k3 & "\MSACCESS.EXE") Then
	$2k3Access = 1
EndIf
If FileExists($Office2k3 & "\EXCEL.EXE") Then
	$2k3Excel = 1
EndIf
If FileExists($Office2k3 & "\OUTLOOK.EXE") Then
	$2k3Outlook = 1
EndIf
If FileExists($Office2k3 & "\POWERPNT.EXE") Then
	$2k3Powerpoint = 1
EndIf
If FileExists($Office2k3 & "\WINWORD.EXE") Then
	$2k3Word = 1
EndIf

_TrayItemSetIcon(-1, "", 0)
_TrayItemSetIcon(-1, "", 0); Force changing to ownerdrawn sometimes needed, i.e. in mixed menu

$MenuIE = _TrayCreateMenu("Internet Explorer")
_TrayItemSetIcon($MenuIE, @TempDir & "\IE.ico", 0)
$IEnew = _TrayCreateItem("Home", $MenuIE)
_TrayItemSetIcon($IEnew, @TempDir & "\IEdoc.ico", 0)
$IEgoogle = _TrayCreateItem("Google", $MenuIE)
_TrayItemSetIcon($IEgoogle, @TempDir & "\IEdoc.ico", 0)
$IEsld = _TrayCreateItem("SLD", $MenuIE)
_TrayItemSetIcon($IEsld, @TempDir & "\IEdoc.ico", 0)
$MenuOffice		= _TrayCreateMenu("Microsoft Office")
_TrayItemSetIcon($MenuOffice, @TempDir & "\Office.ico", 0)
_TrayCreateItem("")
_TrayItemSetIcon(-1, "", 0)
$MenuExplorer = _TrayCreateMenu("Windows Explorer")
_TrayItemSetIcon($MenuExplorer, @TempDir & "\Explorer.ico", 0)
$ExplorerNew = _TrayCreateItem("Home", $MenuExplorer)
_TrayItemSetIcon($ExplorerNew, @TempDir & "\Folder.ico", 0)
$ExplorerProgFiles = _TrayCreateItem("Program Files", $MenuExplorer)
_TrayItemSetIcon($ExplorerProgFiles, @TempDir & "\Folder.ico", 0)
$TrayHelp		= _TrayCreateItem("Help")
$TrayRun		= _TrayCreateItem("Run...")
_TrayCreateItem("")
_TrayItemSetIcon(-1, "", 0)

; Create Office 2007 tray items
If $2k7Access = 1 Then
	$2k7AccessMenu = _TrayCreateItem("Access 2007", $MenuOffice)
	_TrayItemSetIcon($2k7AccessMenu, @TempDir & "\Access2007.ico", 0)
EndIf
If $2k7Excel = 1 Then
	$2k7ExcelMenu = _TrayCreateItem("Excel 2007", $MenuOffice)
	_TrayItemSetIcon($2k7ExcelMenu, @TempDir & "\Excel2007.ico", 0)
EndIf
If $2k7Onenote = 1 Then
	$2k7OnenoteMenu = _TrayCreateItem("OneNote 2007", $MenuOffice)
	_TrayItemSetIcon($2k7OnenoteMenu, @TempDir & "\OneNote2007.ico", 0)
EndIf
If $2k7Outlook = 1 Then
	$2k7OutlookMenu = _TrayCreateItem("Outlook 2007", $MenuOffice)
	_TrayItemSetIcon($2k7OutlookMenu, @TempDir & "\Outlook2007.ico", 0)
EndIf
If $2k7Powerpoint = 1 Then
	$2k7PowerpointMenu = _TrayCreateItem("Powerpoint 2007", $MenuOffice)
	_TrayItemSetIcon($2k7PowerpointMenu, @TempDir & "\PowerPoint2007.ico", 0)
EndIf
If $2k7Word = 1 Then
	$2k7WordMenu = _TrayCreateItem("Word 2007", $MenuOffice)
	_TrayItemSetIcon($2k7WordMenu, @TempDir & "\Word2007.ico", 0)
EndIf

; Create Office 2003 tray items
If $2k3Access = 1 Then
	$2k3AccessMenu = _TrayCreateItem("Access 2003", $MenuOffice)
	_TrayItemSetIcon($2k3AccessMenu, @TempDir & "\Access2003.ico", 0)
EndIf
If $2k3Excel = 1 Then
	$2k3ExcelMenu = _TrayCreateItem("Excel 2003", $MenuOffice)
	_TrayItemSetIcon($2k3ExcelMenu, @TempDir & "\Excel2003.ico", 0)
EndIf
If $2k3Outlook = 1 Then
	$2k3OutlookMenu = _TrayCreateItem("Outlook 2003", $MenuOffice)
	_TrayItemSetIcon($2k3OutlookMenu, @TempDir & "\Outlook2003.ico", 0)
EndIf
If $2k3Powerpoint = 1 Then
	$2k3PowerpointMenu = _TrayCreateItem("Powerpoint 2003", $MenuOffice)
	_TrayItemSetIcon($2k3PowerpointMenu, @TempDir & "\PowerPoint2003.ico", 0)
EndIf
If $2k3Word = 1 Then
	$2k3WordMenu = _TrayCreateItem("Word 2003", $MenuOffice)
	_TrayItemSetIcon($2k3WordMenu, @TempDir & "\Word2003.ico", 0)
EndIf

$TrayExit		= _TrayCreateItem("Exit")
_TrayItemSetIcon($TrayHelp, "shell32.dll", -24)
_TrayItemSetIcon($TrayRun, "shell32.dll", -25)
_TrayItemSetIcon($TrayExit, "shell32.dll", -28)

; OnEvents - needed for tray menu to function on clicks
GUICtrlSetOnEvent($TrayHelp, "MenuEvents")
GUICtrlSetOnEvent($TrayExit, "MenuEvents")
GUICtrlSetOnEvent($2k7AccessMenu, "MenuEvents")
GUICtrlSetOnEvent($2k7ExcelMenu, "MenuEvents")
GUICtrlSetOnEvent($2k7OnenoteMenu, "MenuEvents")
GUICtrlSetOnEvent($2k7OutlookMenu, "MenuEvents")
GUICtrlSetOnEvent($2k7PowerpointMenu, "MenuEvents")
GUICtrlSetOnEvent($2k7WordMenu, "MenuEvents")
GUICtrlSetOnEvent($2k3AccessMenu, "MenuEvents")
GUICtrlSetOnEvent($2k3ExcelMenu, "MenuEvents")
GUICtrlSetOnEvent($2k3OutlookMenu, "MenuEvents")
GUICtrlSetOnEvent($2k3PowerpointMenu, "MenuEvents")
GUICtrlSetOnEvent($2k3WordMenu, "MenuEvents")
GUICtrlSetOnEvent($IEgoogle, "MenuEvents")
GUICtrlSetOnEvent($IEnew, "MenuEvents")
GUICtrlSetOnEvent($IEsld, "MenuEvents")
GUICtrlSetOnEvent($ExplorerNew, "MenuEvents")
GUICtrlSetOnEvent($ExplorerProgFiles, "MenuEvents")

; Main GUI Loop
While 1
	Sleep(10)	
WEnd

Func MenuEvents()
	Local $Msg = @GUI_CtrlID
	
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $TrayExit
			_TrayIconDelete($nTrayIcon1)
			Exit
		Case $2k7AccessMenu
			Run($Office2k7 & "\MSACCESS.EXE")
		Case $2k7ExcelMenu
			Run($Office2k7 & "\EXCEL.EXE")
		Case $2k7OnenoteMenu
			Run($Office2k7 & "\ONENOTE.EXE")
		Case $2k7OutlookMenu
			Run($Office2k7 & "\OUTLOOK.EXE")
		Case $2k7PowerpointMenu
			Run($Office2k7 & "\POWERPNT.EXE")
		Case $2k7WordMenu
			Run($Office2k7 & "\WINWORD.EXE")
		Case $2k3AccessMenu
			Run($Office2k3 & "\MSACCESS.EXE")
		Case $2k3ExcelMenu
			Run($Office2k3 & "\EXCEL.EXE")
		Case $2k3OnenoteMenu
			Run($Office2k3 & "\ONENOTE.EXE")
		Case $2k3OutlookMenu
			Run($Office2k3 & "\OUTLOOK.EXE")
		Case $2k3PowerpointMenu
			Run($Office2k3 & "\POWERPNT.EXE")
		Case $2k3WordMenu
			Run($Office2k3 & "\WINWORD.EXE")
		Case $IEnew
			Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe")
		Case $IEgoogle
			Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe http://www.google.com")
		Case $IEsld
			Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe                               ")
		Case $ExplorerNew
			Run(@WindowsDir & "\explorer.exe")
		Case $ExplorerProgFiles
			Local $ProgFilesDir = @ProgramFilesDir
			Local $ExplorerPath = @WindowsDir & "\explorer.exe" & " /e," & $ProgFilesDir
			Run($ExplorerPath)
		Case $TrayHelp
			msgbox(0, "", "help")
	EndSwitch
EndFunc