#include <GUIConstants.au3>
#include <Date.au3>

Global $OfficeCombo, $SiteCombo, $AppServerName, $CoreAppsList, $DesktopPath, $DesktopRadio, $LaptopRadio, $AssetInput, $MachinePrefix, $FullMachineName
Global $ResetButton, $CheckDataButton, $PostDataButton, $TicketInput, $MachineName, $Site, $MachineType, $BangAccount, $AssetTag, $PCType, $CoreAppsLabel
Global $WinInstallResults, $AppServer, $OtherSiteInput, $WinInstallInput, $DesktopPathInput, $bangAccountInput, $TicketNumber, $NewDesktopPathLabel, $GoldBuildLabel


$Domain = "BLUELNK"
;hard coded desktop path until J drive replication is in place
$DesktopPath = "\\blufs0217.bluelnk.net\csc$\desktop"
$PostBuildVer = "Ver4.0"
$Sanwspass = "sanwstal1"
;For testing only - Change before going to production
$PostPath = "\xpwork~1\Develo~1\XPPost"
$LogPath = "\maint\buildlog"
$AppServerName = ""

opt("GUIOnEventMode", 1)
;
$OG1_POST = GUICreate("OG1_Post",600, 328, 193, 115)
GUISetBkColor(0x008000)
GUISetFont(8, 800, 0, "MS Sans Serif")
;
; Left side of GUI Window
;
GUICtrlCreateLabel("Site Code",8,20,75)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$SiteCombo = GUICtrlCreateCombo("", 112, 20, 89, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;GUICtrlSetOnEvent($SiteCombo,"SetAppServer")
$NewSitelabel = GUICtrlCreateLabel("New Site",8,50,75)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetState (-1, $GUI_HIDE)
$OtherSiteInput = GUICtrlCreateInput("", 112, 50, 89, 20)
GUICtrlSetState (-1, $GUI_HIDE)
GUICtrlCreateLabel("App Server", 8, 80, 82, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$AppServer = GUICtrlCreateLabel("BLUFS0206", 112, 80, 100, 17)
;$AppServer = GUICtrlCreateLabel($AppServerName, 96, 80, 100, 17)
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("Application Suite",8,112,150)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$OfficeCombo = GUICtrlCreateCombo("", 130, 112, 121, 25)
GUICtrlSetOnEvent($OfficeCombo,"SetCoreAppsList")
;$NewCoreLabel = GUICtrlCreateLabel("Other Core",250,50,100)
;GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;GUICtrlSetState (-1, $GUI_HIDE)
GUICtrlCreateLabel("Gold Build", 8, 144, 150)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$GoldBuildCombo = GUICtrlCreateCombo("",130,144,89,25,$CBS_DROPDOWNLIST)
GUICtrlSetState (-1, $GUI_HIDE)
GUICtrlCreateLabel("WinInstall Core", 8, 176, 108, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$WinInstallInput = GUICtrlCreateInput("",130, 176, 110, 20)
GUICtrlSetState (-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("", 8, 80, 4, 4)
GUICtrlCreateLabel("Ticket #", 8, 216, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$TicketInput = GUICtrlCreateInput("", 112, 216, 103, 21)
;
; Right side of GUI Window
;
GUICtrlCreateLabel("Machine Type", 320, 20, 102, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$PCType = GUICtrlCreateList("",440, 20, 81, 40)
GUICtrlCreateLabel("!Bang Account", 320, 176, 103, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$BangAccountInput = GUICtrlCreateInput("", 440, 176, 130, 21)
;GUICtrlSetOnEvent($PCType,"SetMachineName")
GUICtrlCreateLabel("Asset Tag", 320, 80, 75, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$AssetInput = GUICtrlCreateInput("", 440, 80, 105, 21)
;GUICtrlSetState (-1, $GUI_HIDE)
GUICtrlCreateLabel("Domain", 320, 144, 57, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent($AssetInput,"SetMachineName")
$DomainResultLabel = GUICtrlCreateLabel($domain,440, 144, 100, 17)
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("Machine Name", 320, 112, 107, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;$MachineName = GUICtrlCreateLabel($FullMachineName, 440, 112, 130, 17)
$MachineName = GUICtrlCreateLabel("BLUDAA989898DU", 440, 114, 130, 17)
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$NewDesktopPathLabel = GUICtrlCreateLabel("Desktop Path", 320, 216, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;GUICtrlSetState (-1, $GUI_HIDE)
$DesktopPathInput = GUICtrlCreateInput("", 440, 208, 103, 21)
;GUICtrlSetState (-1, $GUI_HIDE)
;
; Bottom of GUI Window
;
$CheckDataButton = GUICtrlCreateButton("Check Data", 8, 290, 73, 25, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent($CheckDataButton, "CheckData")
$ResetButton = GUICtrlCreateButton("Reset Form", 240, 290, 73, 25, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent($ResetButton,"ResetAll")
$PostDataButton = GUICtrlCreateButton("Post Data", 500, 290, 81, 25, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetState (-1, $GUI_HIDE)
;GUICtrlSetOnEvent($PostDataButton,"StartPost")
;
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_ClOSE,"ExitMessage")
ComboBuild()

While 1
	Sleep(500)
WEnd 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::::::::::::::::::::::

Func ComboBuild ()
;;Creates combo lists for Site codes and Office versions
GUICtrlSetData($OfficeCombo,"Office XP Std|Office XP Pro|Office 2003 Std|Office 2003 Pro|Gold Build|Other","")
GUICtrlSetData($SiteCombo,"ATX|FTX|GNY|LEX|LPA|MCA|MER|MVA|NCA|NHQ|OCA|PTP|SCA|WNJ|YNY|Other","")
GUICtrlSetData($PCType,"Desktop|Laptop","")
GUICtrlSetData($GoldBuildCombo,"3.0","")
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func SetCoreAppsList()
;;Determine Winstall list file to use from Office version selected
	$CoreAppsList = ""
	GUICtrlSetState ($CoreAppsLabel, $GUI_HIDE)
	GUICtrlSetData ($WinInstallInput,"")
	GUICtrlSetState ($WinInstallInput, $GUI_HIDE)
	GUICtrlSetState ($GoldBuildLabel, $GUI_HIDE)
	GUICtrlSetState ($GoldBuildCombo, $GUI_HIDE)
	Switch GUICtrlRead($OfficeCombo)
	Case "Office XP Std"
		$CoreAppsList = "xpcorestdsoesp2.lst"
	Case "Office XP Pro"
		$CoreAppsList = "xpcoreprosoesp2.lst"
	Case "Office 2003 Std"
		$CoreAppsList = "xpcorestd2003soesp2.lst"
	Case "Office 2003 Pro"
		$CoreAppsList = "xpcorepro2003soesp2.lst"
	;Case "Gold Build 3.0"
		;$CoreAppsList = "GB3.0core.lst"
	Case "Gold Build"
		GUICtrlSetState ($GoldBuildLabel, $GUI_SHOW)
		GUICtrlSetState ($GoldBuildCombo, $GUI_SHOW)
		GUICtrlSetOnEvent($GoldBuildCombo,"SetGoldCore")
	Case "Other"
		GUICtrlSetState ($WinInstallInput, $GUI_SHOW)
		$CoreAppsList = GUICtrlRead ($WinInstallInput)
	EndSwitch
	msgbox(0,"Core Apps",$CoreAppsList)
	If $CoreAppsList <> "Other" then
		$CoreAppsLabel = GUICtrlCreateLabel($CoreAppsList,130, 176, 170, 20)
		GUICtrlSetState($CoreAppsLabel, $GUI_SHOW)
		GUICtrlSetColor(-1, 0xFFFF00)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	EndIf
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func SetGoldCore ()
;
		Switch GUICtrlRead($GoldBuildCombo)
		Case "3.0" 
			$CoreAppsList = "GB3.0core.lst" 
		;Case ""
			;$CoreAppsList = "GB3.0core.lst"
		EndSwitch
		;msgbox(0,"Core Apps",$CoreAppsList)
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func ExitMessage()
	MsgBox(0,"OG1_Post","Exiting Program",15)
	Exit
EndFunc