;-----------------------------------------------------------------------------
; AutoIt Version: 3.1.1.100
; Author:Andrew Calcutt 	Last Edited:1/8/2006
; Script Function:	Runs Prepsys Actions based on INI file
;-----------------------------------------------------------------------------
AutoItSetOption("RunErrorsFatal", 0) ;Do not show errors if run error
#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <string.au3>
#include <File.au3>
#include <Array.au3>
#include <PrepSys\PrepSysFunc.au3> ;My Defined Functions for PrepSys
; ----------------------------------------------------------------------------
$no_gui_exe = @HomeDrive & "\_no_gui.exe"
;<---### Start Pick Settings File ###--->
Dim $settings
GUICreate("Choose your settings file", 500, 40)

$settings = GUICtrlCreateCombo("", 10, 10, 360, 21)
$settingslist = _FileListToArray (@ScriptDir & "\settings", "*.ini", 1)
If IsArray($settingslist) And @error <> 1 Then
	For $addfiles = 1 To $settingslist[0]
		If $addfiles = 1 Then GUICtrlSetData($settings, $settingslist[$addfiles], $settingslist[$addfiles])
		If $addfiles <> 1 Then GUICtrlSetData($settings, $settingslist[$addfiles])
	Next
EndIf
If FileExists(@HomeDrive & "\settings.ini") Then GUICtrlSetData($settings, @HomeDrive & "\settings.ini", @HomeDrive & "\settings.ini")

$ok = GUICtrlCreateButton("Ok", 440, 10, 50, 20)
$browse = GUICtrlCreateButton("Browse", 380, 10, 50, 20)


GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $browse
			$file = FileOpenDialog("Choose a settings file", @ScriptDir & "\settings", "Settings (*.ini)", 1 + 4)
			GUICtrlSetData($settings, $file, $file)
		Case $msg = $ok
			If GUICtrlRead($settings) = "" Then
				MsgBox(0, "Error", "Please choose a settings file")
			Else
				If StringInStr(GUICtrlRead($settings), "\\") = 0 And StringInStr(GUICtrlRead($settings), ":") = 0 Then
					$settings = @ScriptDir & "\settings\" & GUICtrlRead($settings)
				Else
					$settings = GUICtrlRead($settings)
				EndIf
				ExitLoop
			EndIf
	EndSelect
WEnd
FileCopy($settings, @HomeDrive & "\settings.ini", 1)
$settings = @HomeDrive & "\settings.ini"
FileSetAttrib($settings, "-R")
GUIDelete()
;<---### END PICK SETTINGS FILE ###--->

;<---### Set working DIR in ini ###--->
$workingdir = @ScriptDir
If StringLen($workingdir) <> 3 Then
	$workingdir = $workingdir & "\"
EndIf
IniWrite($settings, "Script_Settings", "Working_Dir", $workingdir)
;<---### End Set working DIR in ini ###--->

;-----------------------------------------------------------------------------
;declair variables
Dim $workingdir = IniRead($settings, "Script_Settings", "Working_Dir", "")
Dim $logonuser1 = IniRead($settings, "Script_Settings", "Admin_Username", "")
Dim $logonpass1 = _StringEncrypt(0, IniRead($settings, "Script_Settings", "Admin_Password", ""), "Prepsys", 2)
Dim $logonuser2 = IniRead($settings, "Script_Settings", "Sysprep_Username", "")
Dim $logonpass2 = _StringEncrypt(0, IniRead($settings, "Script_Settings", "Sysprep_Password", ""), "Prepsys", 2)
Dim $officesuitskey = _StringEncrypt(0, IniRead($settings, "OFFICE", "SUITES", ""), "Prepsys", 2)
Dim $officeappskey = _StringEncrypt(0, IniRead($settings, "OFFICE", "APPLICATIONS", ""), "Prepsys", 2)
Dim $progressref = 0, $requestnetwork = 0

Dim $defaultimgname = IniRead($settings, "Background", "Default_Image", "")
Dim $localimgname = IniRead($settings, "Background", "Local_Image", "")

Dim $mcafee_exe = IniRead($settings, "Program_Use_Only", "mcafee_exe", $workingdir & "McAfee\AutoInstall_McAfee.exe")
Dim $mcafee_patch_exe = IniRead($settings, "Program_Use_Only", "mcafee_patch_exe", $workingdir & "McAfee\Patch\AutoInstall_McAfee_Patch.exe")
Dim $sophos_exe = IniRead($settings, "Program_Use_Only", "sophos_exe", $workingdir & "Sophos\AutoInstall_Sophos.exe")
Dim $vpn_exe = IniRead($settings, "Program_Use_Only", "vpn_exe", $workingdir & "VPN\AutoInstall_VPN.exe")
Dim $office_exe = IniRead($settings, "Program_Use_Only", "office_exe", $workingdir & "OFFICE\AutoInstall_Office.exe")
Dim $datatel_exe = IniRead($settings, "Program_Use_Only", "datatel_exe", $workingdir & "DATATEL\AutoInstall_Datatel.exe")
Dim $deepfreeze_exe = IniRead($settings, "Program_Use_Only", "deepfreeze_exe", $workingdir & "Deepfreeze\DFSeed.bat")
Dim $cleansms_exe = IniRead($settings, "Program_Use_Only", "cleansms_exe", $workingdir & "CleanSMS\AutoRun_cleansms.exe")
Dim $extra_exe = IniRead($settings, "Program_Use_Only", "extra_exe", $workingdir & "ExtraScripts\Extra.bat")

Dim $netuser = IniRead($settings, "Program_Use_Only", "NetAdmin", "")
Dim $netpass = _StringEncrypt(0, IniRead($settings, "Program_Use_Only", "NetPass", ""), "Prepsys", 2)
Dim $netdom = IniRead($settings, "Program_Use_Only", "NetDom", "")

Dim $shownetprompt = IniRead($settings, "Program_Use_Only", "ShowNetLoginPrompt", "1")
;-----------------------------------------------------------------------------
;Declair Buttons
Dim $remuser, $mcinstall, $spinstall, $vpninstall, $offinstall, $datatel, $deepfreeze, $extrainstall, $waitupdate, $startmenu, $vissettings, $folderoptions, $copyprofile, $cleansms, $mcguid, $defragment, $deleteini, $runsysprep
Dim $AWWMAM, $FOSMIV, $FOSTIV, $SSUM, $SSUMP, $STSR, $SWCWD, $SOCB, $STB, $SEOSF, $SSLB, $UABIFEFT, $UCTIF, $UDSFILOTD, $UVSOWAB, $mydocs, $mycomp, $mynetplaces, $iexplorer, $cleandesk, $offtool
Dim $Classic_Menu, $DisplayAdminTools, $DisplayFavories, $DisplayLogOff, $DisplayRun, $EnableDRAGandDROP, $ExpandControlPanel, $ExpandMyDocuments, $ExpandMyPictures, $ExpandNetworkConnections, $ExpandPrinters, $ScrollPrograms, $UsePersonalizedMenus
Dim $ShowControlPanel, $ShowMyComputer, $ShowMyDocs, $ShowMyMusic, $ShowMyPics, $ShowNetConn, $ShowAdminTools, $ShowSetProgramAccessAndDefaults, $StartMenuFavorites, $EnableDragDrop, $ScrollPrograms2, $ShowHelp, $ShowPrinters, $ShowRun, $ShowSearch
Dim $SearchNetPrinters, $DisplayFileSizeInFolderTips, $SimpleViewInFolderListView, $DisplaySystemFolderContents, $FullPathAddress, $FullPathTitle
Dim $CacheThumbnails, $ShowHiddenFiles, $ShowFileExtensions, $ShowHiddenSysFiles, $LaunchWindowsInSeperateProcess, $RememberFolderSettings, $RestoreWindowsAtLogon, $ControlPanelInMyComputer, $ShowCompressedFilesInColor, $ShowDesktopFolderInfoPopop, $UseSimpleFileSharing
Dim $scplabel, $smclabel, $smdlabel, $smmlabel, $smplabel, $snclabel, $satlabel, $mcafee_exe2, $mcafee_patch_exe2, $sophos_exe2, $vpn_exe2, $office_exe2, $datatel_exe2, $deepfreeze_exe2, $cleansms_exe2, $extra_exe2
Dim $browse1, $browse2, $browse3, $browse4, $browse5, $browse6, $browse7, $browse8, $browse9
Dim $LockTaskbar, $AutoHideTaskbar, $KeepTaskbarOnTop, $Group, $ShowQuickLaunch, $ShowClock, $HideInactiveIcons, $shownetlogonprompt
;-----------------------------------------------------------------------------
Dim $addautorun, $deleteautorun, $extralist
;-----------------------------------------------------------------------------

GUICreate("PrepSys", 400, 410)  ; Create PrepSys Window

$tab = GUICtrlCreateTab(0, 0, 400, 370)
$tab1 = GUICtrlCreateTabItem("General");--->General Settings Tab
GUICtrlSetState(-1, $GUI_SHOW) ;Display General Tab First
;Start - Run Group
GUICtrlCreateGroup("Run", 5, 30, 160, 335)
_IniReadCheckbox_Ran ($settings, $remuser, "Remove Initial User", "Script_Settings", "Delete_Start_User", "Program_Use_Only", "Deleted_Start_User", 10, 45, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $mcinstall, "Install McAffe", "Script_Settings", "Install_McAfee", "Program_Use_Only", "Installed_McAfee", 10, 60, 110, 15, 145)
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\VirusScan Enterprise\CurrentVersion", "szProductVer") <> "" Then GUICtrlCreatePic($workingdir & "PrepSys\installed.bmp", 130, 60, 15, 15)
_IniReadCheckbox_Ran ($settings, $spinstall, "Install Sophos", "Script_Settings", "Install_Sophos", "Program_Use_Only", "Installed_Sophos", 10, 75, 110, 15, 145)
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Sophos\SweepNT", "Version") <> "" Then GUICtrlCreatePic($workingdir & "PrepSys\installed.bmp", 130, 75, 15, 15)
_IniReadCheckbox_Ran ($settings, $vpninstall, "Install VPN", "Script_Settings", "Install_VPN", "Program_Use_Only", "Installed_VPN", 10, 90, 110, 15, 145)
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Cisco Systems\VPN Client", "InstallPath") <> "" Then GUICtrlCreatePic($workingdir & "PrepSys\installed.bmp", 130, 90, 15, 15)
_IniReadCheckbox_Ran ($settings, $offinstall, "Install Office", "Script_Settings", "Install_Office", "Program_Use_Only", "Installed_Office", 10, 105, 110, 15, 145)
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Common\InstallRoot", "Path") <> "" Then GUICtrlCreatePic($workingdir & "PrepSys\installed.bmp", 130, 105, 15, 15)
_IniReadCheckbox_Ran ($settings, $datatel, "Install Datatel", "Script_Settings", "Install_Datatel", "Program_Use_Only", "Installed_Datatel", 10, 120, 110, 15, 145)
If FileExists("C:\DATATEL\") Then GUICtrlCreatePic($workingdir & "PrepSys\installed.bmp", 130, 120, 15, 15)
_IniReadCheckbox_Ran ($settings, $deepfreeze, "Install DeepFreeze", "Script_Settings", "Install_DeepFreeze", "Program_Use_Only", "Installed_DeepFreeze", 10, 135, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $extrainstall, "Install Extra", "Script_Settings", "Run_Extra", "Program_Use_Only", "Ran_Extra", 10, 150, 125, 15, 145)
_IniReadCheckbox_Ran ($settings, $startmenu, "Set Start Menu Settings", "Script_Settings", "Set_Start_Menu", "Program_Use_Only", "Set_Start_Menu", 10, 165, 135, 15, 145)
_IniReadCheckbox_Ran ($settings, $vissettings, "Set Visual Settings", "Script_Settings", "Set_Visual_Settings", "Program_Use_Only", "Set_Visual_Settings", 10, 180, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $folderoptions, "Set Folder Settings", "Script_Settings", "Set_Folder_Options", "Program_Use_Only", "Set_Folder_Options", 10, 195, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $waitupdate, "Wait to Update", "Script_Settings", "Wait_Updates", "Program_Use_Only", "Waited_For_Updates", 10, 210, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $copyprofile, "Copy Profile", "Script_Settings", "Copy_Profile", "Program_Use_Only", "Copy_Profile_Step3", 10, 225, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $cleansms, "Clean SMS", "Script_Settings", "Clean_SMS", "Program_Use_Only", "Cleaned_SMS", 10, 240, 110, 15, 145)
_IniReadCheckbox_Ran ($settings, $mcguid, "Remove McAffe GUID", "Script_Settings", "Remove_McAfee_GUID", "Program_Use_Only", "Removed_McAfee_GUID", 10, 255, 125, 15, 145)
_IniReadCheckbox_Ran ($settings, $defragment, "Defragment", "Script_Settings", "Defrag", "Program_Use_Only", "Defraged", 10, 270, 110, 15, 145)
_IniReadCheckbox ($settings, $deleteini, "Delete settings.ini", "Script_Settings", "Delete_INI", 10, 285, 130, 15)
_IniReadCheckbox ($settings, $runsysprep, "Run Sysprep", "Script_Settings", "Run_Sysprep", 10, 300, 130, 15)
;Office Settings GUI
GUICtrlCreateGroup("Office Settings", 170, 30, 225, 110)
$offlabel1 = GUICtrlCreateLabel("Office Suites Key", 175, 45, 160, 15)
$offskey = GUICtrlCreateInput($officesuitskey, 175, 60, 215, 20)
$offlabel2 = GUICtrlCreateLabel("Office Applications Key", 175, 80, 160, 15)
$offakey = GUICtrlCreateInput($officeappskey, 175, 95, 215, 20)
_IniReadCheckbox ($settings, $offtool, "Add Office Toolbar in Taskbar", "OFFICE", "Add_Office_Toolbar", 175, 120, 160, 15)
;Start - Logon Information Group
GUICtrlCreateGroup("Logon Information", 170, 140, 225, 175)
GUICtrlCreateLabel("Default Admin User", 175, 155, 120, 15)
$username = GUICtrlCreateInput($logonuser1, 175, 170, 215, 20)
GUICtrlCreateLabel("Default Admin Pass", 175, 190, 120, 15)
$password = GUICtrlCreateInput($logonpass1, 175, 205, 215, 20, $ES_PASSWORD)
$cplabel1 = GUICtrlCreateLabel("Copy Profile User", 175, 235, 120, 15)
$username2 = GUICtrlCreateInput($logonuser2, 175, 250, 215, 20)
$cplabel2 = GUICtrlCreateLabel("Copy Profile Pass (Strong)", 175, 270, 150, 15)
$password2 = GUICtrlCreateInput($logonpass2, 175, 285, 215, 20, $ES_PASSWORD)

_IniReadCheckbox ($settings, $shownetlogonprompt, "Show network logon prompt (if needed)", "Program_Use_Only", "ShowNetLoginPrompt", 175, 330, 205, 15)

$tab2 = GUICtrlCreateTabItem("Start Menu") ;--->Start Menu Settings Tab



_IniReadCheckbox ($settings, $Classic_Menu, "Use Classic Menu", "StartMenu", "Classic_Menu", 10, 35, 160, 15)
GUICtrlCreateGroup("Start Menu Settings", 5, 60, 205, 305)
_LabeledCombo ($settings, $ShowControlPanel, $scplabel, "Control Panel", "StartMenu", "ShowControlPanel", "Disabled", "Link", "Menu", 90, 75, 115, 20, 10, 35, 80, 15)
_LabeledCombo ($settings, $ShowMyComputer, $smclabel, "My Computer", "StartMenu", "ShowMyComputer", "Disabled", "Link", "Menu", 90, 95, 115, 20, 10, 55, 80, 15)
_LabeledCombo ($settings, $ShowMyDocs, $smdlabel, "My Documents", "StartMenu", "ShowMyDocs", "Disabled", "Link", "Menu", 90, 115, 115, 20, 10, 75, 80, 15)
_LabeledCombo ($settings, $ShowMyMusic, $smmlabel, "My Music", "StartMenu", "ShowMyMusic", "Disabled", "Link", "Menu", 90, 135, 115, 20, 10, 95, 80, 15)
_LabeledCombo ($settings, $ShowMyPics, $smplabel, "My Pictures", "StartMenu", "ShowMyPics", "Disabled", "Link", "Menu", 90, 155, 115, 20, 10, 115, 80, 15)
_LabeledCombo ($settings, $ShowNetConn, $snclabel, "Network", "StartMenu", "ShowNetConn", "Disabled", "Net Connections", "Connect to", 90, 175, 115, 20, 10, 135, 80, 15)
_LabeledCombo ($settings, $ShowAdminTools, $satlabel, "Admin Tools", "StartMenu", "ShowAdminTools", "Disabled", "Programs", "Start menu + progs", 90, 195, 115, 20, 10, 135, 80, 15)
_IniReadCheckbox ($settings, $ShowSetProgramAccessAndDefaults, "Program Access And Defaults", "StartMenu", "ShowSetProgramAccessAndDefaults", 10, 225, 160, 15)
_IniReadCheckbox ($settings, $StartMenuFavorites, "Start Menu Favorites", "StartMenu", "StartMenuFavorites", 10, 240, 160, 15)
_IniReadCheckbox ($settings, $EnableDragDrop, "Enable Drag Drop", "StartMenu", "EnableDragDrop", 10, 255, 160, 15)
_IniReadCheckbox ($settings, $ScrollPrograms2, "Scroll Programs", "StartMenu", "ScrollPrograms", 10, 270, 160, 15)
_IniReadCheckbox ($settings, $ShowHelp, "Show Help", "StartMenu", "ShowHelp", 10, 285, 160, 15)
_IniReadCheckbox ($settings, $ShowPrinters, "Show Printers", "StartMenu", "ShowPrinters", 10, 300, 160, 15)
_IniReadCheckbox ($settings, $ShowRun, "Show Run", "StartMenu", "ShowRun", 10, 315, 160, 15)
_IniReadCheckbox ($settings, $ShowSearch, "Show Search", "StartMenu", "ShowSearch", 10, 330, 160, 15)

GUICtrlCreateGroup("Classic Menu Settings", 215, 30, 180, 200)
_IniReadCheckbox ($settings, $DisplayAdminTools, "Display Admin Tools", "Classic_Menu_Options", "DisplayAdminTools", 220, 45, 160, 15)
_IniReadCheckbox ($settings, $DisplayFavories, "Display Favories", "Classic_Menu_Options", "DisplayFavories", 220, 60, 160, 15)
_IniReadCheckbox ($settings, $DisplayLogOff, "Display LogOff", "Classic_Menu_Options", "DisplayLogOff", 220, 75, 160, 15)
_IniReadCheckbox ($settings, $DisplayRun, "Display Run", "Classic_Menu_Options", "DisplayRun", 220, 90, 160, 15)
_IniReadCheckbox ($settings, $EnableDRAGandDROP, "Enable DRAG and DROP", "Classic_Menu_Options", "EnableDRAGandDROP", 220, 105, 160, 15)
_IniReadCheckbox ($settings, $ExpandControlPanel, "Expand Control Panel", "Classic_Menu_Options", "ExpandControlPanel", 220, 120, 160, 15)
_IniReadCheckbox ($settings, $ExpandMyDocuments, "Expand My Documents", "Classic_Menu_Options", "ExpandMyDocuments", 220, 135, 160, 15)
_IniReadCheckbox ($settings, $ExpandMyPictures, "Expand My Pictures", "Classic_Menu_Options", "ExpandMyPictures", 220, 150, 160, 15)
_IniReadCheckbox ($settings, $ExpandNetworkConnections, "Expand Network Connections", "Classic_Menu_Options", "ExpandNetworkConnections", 220, 165, 160, 15)
_IniReadCheckbox ($settings, $ExpandPrinters, "Expand Printers", "Classic_Menu_Options", "ExpandPrinters", 220, 180, 160, 15)
_IniReadCheckbox ($settings, $ScrollPrograms, "Scroll Programs", "Classic_Menu_Options", "ScrollPrograms", 220, 195, 160, 15)
_IniReadCheckbox ($settings, $UsePersonalizedMenus, "Use Personalized Menus", "Classic_Menu_Options", "UsePersonalizedMenus", 220, 210, 160, 15)

GUICtrlCreateGroup("Taskbar Settings", 215, 230, 180, 135)
_IniReadCheckbox ($settings, $LockTaskbar, "Lock Taskbar", "Taskbar", "LockTaskbar", 220, 245, 160, 15)
_IniReadCheckbox ($settings, $AutoHideTaskbar, "Auto Hide Taskbar", "Taskbar", "AutoHideTaskbar", 220, 260, 160, 15)
_IniReadCheckbox ($settings, $KeepTaskbarOnTop, "Keep taskbar on top", "Taskbar", "KeepTaskbarOnTop", 220, 275, 160, 15)
_IniReadCheckbox ($settings, $Group, "Group", "Taskbar", "Group", 220, 290, 160, 15)
_IniReadCheckbox ($settings, $ShowQuickLaunch, "Show Quick Launch", "Taskbar", "ShowQuickLaunch", 220, 305, 160, 15)
_IniReadCheckbox ($settings, $ShowClock, "Show Clock", "Taskbar", "ShowClock", 220, 330, 160, 15)
_IniReadCheckbox ($settings, $HideInactiveIcons, "Hide Inactive Icons", "Taskbar", "HideInactiveIcons", 220, 345, 160, 15)


$tab3 = GUICtrlCreateTabItem("Visual");--->Visual Settings Tab

GUICtrlCreateGroup("Visual Settings", 5, 30, 245, 245)
_IniReadCheckbox ($settings, $AWWMAM, "Animate windows when min & maxing", "Visual_Effects", "AWWMAM", 10, 45, 220, 15)
_IniReadCheckbox ($settings, $FOSMIV, "Fade or slide menus into view", "Visual_Effects", "FOSMIV", 10, 60, 220, 15)
_IniReadCheckbox ($settings, $FOSTIV, "Fade or slide tooltips into view", "Visual_Effects", "FOSTIV", 10, 75, 220, 15)
_IniReadCheckbox ($settings, $SSUM, "Show shadows under menu", "Visual_Effects", "SSUM", 10, 90, 220, 15)
_IniReadCheckbox ($settings, $SSUMP, "Show shadows under mouse pointer", "Visual_Effects", "SSUMP", 10, 105, 220, 15)
_IniReadCheckbox ($settings, $STSR, "Show translucent selection rectangle", "Visual_Effects", "STSR", 10, 120, 220, 15)
_IniReadCheckbox ($settings, $SWCWD, "Show window contents while dragging", "Visual_Effects", "SWCWD", 10, 135, 220, 15)
_IniReadCheckbox ($settings, $SOCB, "Slide open combo boxes", "Visual_Effects", "SOCB", 10, 150, 220, 15)
_IniReadCheckbox ($settings, $STB, "Slide taskbar buttons", "Visual_Effects", "STB", 10, 165, 220, 15)
_IniReadCheckbox ($settings, $SEOSF, "Smooth edges of screen fonts", "Visual_Effects", "SEOSF", 10, 180, 220, 15)
_IniReadCheckbox ($settings, $SSLB, "Smoth-scroll list boxes", "Visual_Effects", "SSLB", 10, 195, 220, 15)
_IniReadCheckbox ($settings, $UABIFEFT, "Use a background image for each folder type", "Visual_Effects", "UABIFEFT", 10, 210, 235, 15)
_IniReadCheckbox ($settings, $UCTIF, "Use common task in folders", "Visual_Effects", "UCTIF", 10, 225, 220, 15)
_IniReadCheckbox ($settings, $UDSFILOTD, "Use drop shadows for icon lables on desktop", "Visual_Effects", "UDSFILOTD", 10, 240, 230, 15)
_IniReadCheckbox ($settings, $UVSOWAB, "Use visual styles on windows and buttons", "Visual_Effects", "UVSOWAB", 10, 255, 220, 15)
;Desktop Settings GUI
GUICtrlCreateGroup("Desktop Image", 5, 275, 390, 90)
$imglab1 = GUICtrlCreateLabel("Default desktop image location(used if local image does not exist)", 10, 290, 380, 15)
$defaultimgname = GUICtrlCreateInput($defaultimgname, 10, 305, 355, 20)
$imgbrowse1 = GUICtrlCreateButton("...", 370, 305, 20, 20)
$imglab2 = GUICtrlCreateLabel("Local desktop image location(if file exists it will be used instead of the default)", 10, 325, 380, 15)
$localimgname = GUICtrlCreateInput($localimgname, 10, 340, 355, 20)
$imgbrowse2 = GUICtrlCreateButton("...", 370, 340, 20, 20)
GUICtrlCreateGroup("Desktop Icons", 255, 30, 140, 95)
_IniReadCheckbox ($settings, $mydocs, "My Doucuments", "Desktop_Items", "My_Documents", 260, 45, 95, 15)
_IniReadCheckbox ($settings, $mycomp, "My Computer", "Desktop_Items", "My_Computer", 260, 60, 95, 15)
_IniReadCheckbox ($settings, $mynetplaces, "My Network Places", "Desktop_Items", "My_Network_Places", 260, 75, 110, 15)
_IniReadCheckbox ($settings, $iexplorer, "Internet Explorer", "Desktop_Items", "My_Network_Places", 260, 90, 110, 15)
_IniReadCheckbox ($settings, $cleandesk, "Cleanup desktop", "Desktop_Items", "Enable_Desktop_Cleanup", 260, 105, 110, 15)

$tab4 = GUICtrlCreateTabItem("Folder");--->Folder Settings Tab

;FOLDER OPTIONS GUI
GUICtrlCreateGroup("Folder Options", 5, 30, 190, 335)
_IniReadCheckbox ($settings, $SearchNetPrinters, "Auto Search Network Printers", "Folder_Options", "SearchNetPrinters", 10, 45, 170, 15)
_IniReadCheckbox ($settings, $DisplayFileSizeInFolderTips, "Display File Size In FolderTips", "Folder_Options", "DisplayFileSizeInFolderTips", 10, 60, 170, 15)
_IniReadCheckbox ($settings, $SimpleViewInFolderListView, "Simple View In Folder List View", "Folder_Options", "SimpleViewInFolderListView", 10, 75, 170, 15)
_IniReadCheckbox ($settings, $DisplaySystemFolderContents, "Display System Folder Contents", "Folder_Options", "DisplaySystemFolderContents", 10, 90, 180, 15)
_IniReadCheckbox ($settings, $FullPathAddress, "Full Path in Address Bar", "Folder_Options", "FullPathAddress", 10, 105, 160, 15)
_IniReadCheckbox ($settings, $FullPathTitle, "Full Path in Title", "Folder_Options", "FullPathTitle", 10, 120, 160, 15)
_IniReadCheckbox ($settings, $CacheThumbnails, "Cache Thumbnails", "Folder_Options", "CacheThumbnails", 10, 135, 160, 15)
_IniReadCheckbox ($settings, $ShowHiddenFiles, "Show Hidden Files", "Folder_Options", "ShowHiddenFiles", 10, 150, 160, 15)
_IniReadCheckbox ($settings, $ShowFileExtensions, "Show File Extensions", "Folder_Options", "ShowFileExtensions", 10, 165, 160, 15)
_IniReadCheckbox ($settings, $ShowHiddenSysFiles, "Show Hidden Sys Files", "Folder_Options", "ShowHiddenSysFiles", 10, 180, 160, 15)
_IniReadCheckbox ($settings, $LaunchWindowsInSeperateProcess, "Launch Windows In Seperate Process", "Folder_Options", "LaunchWindowsInSeperateProcess", 10, 195, 160, 15)
_IniReadCheckbox ($settings, $RememberFolderSettings, "Remember Folder Settings", "Folder_Options", "RememberFolderSettings", 10, 210, 160, 15)
_IniReadCheckbox ($settings, $RestoreWindowsAtLogon, "Restore Windows At Logon", "Folder_Options", "RestoreWindowsAtLogon", 10, 225, 160, 15)
_IniReadCheckbox ($settings, $ControlPanelInMyComputer, "Control Panel In My Computer", "Folder_Options", "ControlPanelInMyComputer", 10, 240, 160, 15)
_IniReadCheckbox ($settings, $ShowCompressedFilesInColor, "Show Compressed Files In Color", "Folder_Options", "ShowCompressedFilesInColor", 10, 255, 180, 15)
_IniReadCheckbox ($settings, $ShowDesktopFolderInfoPopop, "Show Desktop Folder Info Popop", "Folder_Options", "ShowDesktopFolderInfoPopop", 10, 270, 180, 15)
_IniReadCheckbox ($settings, $UseSimpleFileSharing, "Use Simple File Sharing", "Folder_Options", "UseSimpleFileSharing", 10, 285, 160, 15)

$tab4 = GUICtrlCreateTabItem("Program") ;--->Program Locations Tab


GUICtrlCreateLabel("McAffee Auto Install Location (.exe;.bat)", 10, 30, 325, 15)
_FileBrowse ($mcafee_exe, $mcafee_exe2, $browse1, 10, 45, 325, 20, 345, 30)
GUICtrlCreateLabel("McAffee Patch Auto Install Location (.exe;.bat)", 10, 65, 325, 15)
_FileBrowse ($mcafee_patch_exe, $mcafee_patch_exe2, $browse2, 10, 80, 325, 20, 345, 30)
GUICtrlCreateLabel("Sophos Auto Install Location (.exe;.bat)", 10, 100, 325, 15)
_FileBrowse ($sophos_exe, $sophos_exe2, $browse3, 10, 115, 325, 20, 345, 30)
GUICtrlCreateLabel("VPN Auto Install Location (.exe;.bat)", 10, 135, 325, 15)
_FileBrowse ($vpn_exe, $vpn_exe2, $browse4, 10, 150, 325, 20, 345, 30)
GUICtrlCreateLabel("Office Auto Install Location (.exe;.bat)", 10, 170, 325, 15)
_FileBrowse ($office_exe, $office_exe2, $browse5, 10, 185, 325, 20, 345, 30)
GUICtrlCreateLabel("Datatel Auto Install Location (.exe;.bat)", 10, 205, 325, 15)
_FileBrowse ($datatel_exe, $datatel_exe2, $browse6, 10, 220, 325, 20, 345, 30)
GUICtrlCreateLabel("DeepFreeze Auto Install Location (.exe;.bat)", 10, 240, 325, 15)
_FileBrowse ($deepfreeze_exe, $deepfreeze_exe2, $browse7, 10, 255, 325, 20, 345, 30)
GUICtrlCreateLabel("CleanSMS Auto Run Location (.exe;.bat)", 10, 275, 325, 15)
_FileBrowse ($cleansms_exe, $cleansms_exe2, $browse8, 10, 290, 325, 20, 345, 30)
GUICtrlCreateLabel("Extra Auto Install Location (.exe;.bat)", 10, 310, 325, 15)
_FileBrowse ($extra_exe, $extra_exe2, $browse9, 10, 325, 325, 20, 345, 30)

$tab5 = GUICtrlCreateTabItem("Extra Programs") ;--->Extra Program Locations Tab

$extralist = GUICtrlCreateListView("autorun files", 10, 30, 375, 250, $LVS_LIST)
$addautorun = GUICtrlCreateButton("Add Extra Autorun", 20, 280, 180, 20)
$deleteautorun = GUICtrlCreateButton("Delete Selected", 200, 280, 180, 20)

$ExtraAutoRuns = IniReadSection($settings, "ExtraAutoRuns")

GUICtrlCreateTabItem("")   ; end tabitem definition

;BOTTOM BUTTONS
$setinirun = GUICtrlCreateButton("Set INI " & Chr(43) & " &Run", 10, 375, 80, 20)
$setini = GUICtrlCreateButton("&Set INI", 110, 375, 80, 20)
$removeini = GUICtrlCreateButton("&Delete INI", 210, 375, 80, 20)
$canclebutton = GUICtrlCreateButton("E&xit", 310, 375, 80, 20)

$programby = GUICtrlCreateLabel("Program By: Andrew Calcutt", 135, 395, 135, 15)
GUICtrlSetState($programby, $GUI_DISABLE)
GUISetState()

    For $i = 1 To $ExtraAutoRuns[0][0]
		GUICtrlCreateListViewItem ($ExtraAutoRuns[$i][1], $extralist)
    Next

;Set States of controls
_StartMenuState ()
_StartMenuSwitch ()
_VisSettings_State ()
_Office_State ()
_Sophos_State ()
_McAfee_State ()
_Sysprep_User_State ()
_Folder_Options_State ()


GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $addautorun
			$extrafile = FileOpenDialog ( "Choost AutoRun File", $workingdir , "AutoRun (*.exe;*.bat)", 1 + 4)
			If Not @error Then GUICtrlCreateListViewItem ( $extrafile, $extralist )
		Case $msg = $deleteautorun
			_GUICtrlListViewDeleteItemsSelected ($extralist)
		Case $msg = $Classic_Menu
			_StartMenuSwitch ()
		Case $msg = $browse1 Or $msg = $browse2 Or $msg = $browse3 Or $msg = $browse4 Or $msg = $browse5 Or $msg = $browse6 Or $msg = $browse7 Or $msg = $browse8 Or $msg = $browse9 Or $msg = $imgbrowse1 Or $msg = $imgbrowse2
			If $msg = $browse1 Then _FileBrowseSet ($mcafee_exe2, "McAfee Exe")
			If $msg = $browse2 Then _FileBrowseSet ($mcafee_patch_exe2, "McAfee Patch Exe")
			If $msg = $browse3 Then _FileBrowseSet ($sophos_exe2, "Sophos Exe")
			If $msg = $browse4 Then _FileBrowseSet ($vpn_exe2, "VPN Exe")
			If $msg = $browse5 Then _FileBrowseSet ($office_exe2, "Office Exe")
			If $msg = $browse6 Then _FileBrowseSet ($datatel_exe2, "Datatel Exe")
			If $msg = $browse7 Then _FileBrowseSet ($deepfreeze_exe2, "DeepFreeze Exe")
			If $msg = $browse8 Then _FileBrowseSet ($cleansms_exe2, "CleanSMS Exe")
			If $msg = $browse9 Then _FileBrowseSet ($extra_exe2, "Extra Autorun")
			If $msg = $imgbrowse1 Then _FileBrowseSet ($defaultimgname, "Default Image Location", "Background Image(*.bmp)")
			If $msg = $imgbrowse2 Then _FileBrowseSet ($localimgname, "Default Image Location", "Background Image(*.bmp)")
		Case $msg = $spinstall
			_McAfee_State ()
		Case $msg = $mcinstall
			_Sophos_State ()
		Case $msg = $offinstall
			_Office_State ()
		Case $msg = $startmenu
			_StartMenuState ()
			If GUICtrlRead($startmenu) = 1 Then _StartMenuSwitch ()
		Case $msg = $vissettings
			_VisSettings_State ()
		Case $msg = $folderoptions
			_Folder_Options_State ()
		Case $msg = $copyprofile
			_Sysprep_User_State ()
		Case $msg = $removeini
			FileDelete($settings)
			ExitLoop
		Case $msg = $setini
			$saveinias = FileSaveDialog("Save settings file as ...", @ScriptDir & "\settings", "Settings (*.ini)")			
			If @error Then
				MsgBox(0, "Error", "No file was saved")
			Else
				If Not StringInStr($saveinias, ".ini") Then $saveinias = $saveinias & ".ini"
				_Set_INI_Settings ()
				IniWrite($settings, "Script_Settings", "Working_Dir", "")
				FileCopy($settings, $saveinias, 9) ;COPY SETTINGS FILE FROM C DRIVE TO SPECIFIED FILE
				ExitLoop
			EndIf
		Case $msg = $setinirun
			If GUICtrlRead($vissettings) = 1 Then
				If StringInStr(GUICtrlRead($defaultimgname), "\\") = 0 And StringInStr(GUICtrlRead($defaultimgname), ":") = 0 Then
					$defaultimg = $workingdir & GUICtrlRead($defaultimgname)
					FileCopy($defaultimg, @HomeDrive & "\defaultimg.bmp", 9)
				Else
					FileCopy(GUICtrlRead($defaultimgname), @HomeDrive & "\defaultimg.bmp")
				EndIf
			EndIf
			If FileExists($no_gui_exe) = 0 Then FileCopy(@ScriptDir & "\Prepsys\_no_gui.exe", $no_gui_exe, 9)
			_Set_INI_Settings ()
			Run($no_gui_exe)
			Exit
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $canclebutton
			ExitLoop
	EndSelect
WEnd
GUIDelete()
