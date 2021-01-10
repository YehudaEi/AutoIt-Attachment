#include <GUIConstants.au3>
#Include <GuiComboBox.au3>
#Include <GuiListBox.au3>
#include <Array.au3>
#include <file.au3>
#Include <NetShare.au3>

;***********************************************************************************************************************************************************************
;Gui for main form, FORM1
;***********************************************************************************************************************************************************************
$Form1 = GUICreate("*****************", 706, 390, 193, 115)
GUISetFont(12, 400);, 0, "Comic Sans MS")
GUISetBkColor(0xFFFFFF,$Form1)

;***********************************************************************************************************************************************************************
;Sets the images and Title for the main GUI
;***********************************************************************************************************************************************************************
$backgroundPic = GUICtrlCreatePic($homedir & "\Images\leftBackground.JPG", 0, 0, 112, 113)
GUICtrlSetState($backgroundPic, $gui_disable)
$backgroundPic1 = GUICtrlCreatePic($homedir & "\Images\rightbackground.bmp", 545, 0, 161, 113)
GUICtrlSetState($backgroundPic1, $gui_disable)
$lblMain = GUICtrlCreateLabel("Forensic Examiner * SAN Toolbox", 115, 35, 430, 60, $SS_CENTER)
GUICtrlSetBkColor($lblMain, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont($lblMain, 22)

;***********************************************************************************************************************************************************************
;Sets up the GUI in Tabbed mode
;***********************************************************************************************************************************************************************
$tab = GUICtrlCreateTab(0, 120, 706, 270)

If $includeMyVolumes = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the first tab "My Volumes"
	;***********************************************************************************************************************************************************************
	$myVolumeGroup = GUICtrlCreateTabItem("My Volumes")
	$lblMyVolumes = GUICtrlCreateLabel("Volume location, Volume Name, Size", 30, 150, 400, 25)
	$lstMyVolumes = GUICtrlCreateList("", 30, 180, 400, 100)
EndIf

If $includeCreate = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Create tab
	;***********************************************************************************************************************************************************************
	$Group1 = GUICtrlCreateTabItem("Create")
	$lblCreateSize = GUICtrlCreateLabel("Size(GB):", 5, 160, 100, 24, $SS_CENTER)
	$inptCreateSize = GUICtrlCreateInput("", 110, 160, 117, 28)
	$lblCreateVolumeName = GUICtrlCreateLabel("SAN Volume Name:", 5, 202, 90, 34, $SS_CENTER)
	$inptCreateName = GUICtrlCreateInput("", 110, 202, 117, 28)
	$lblCreateServername = GUICtrlCreateLabel("Server name:", 256, 160, 94, 24)
	$cmbCreateServername = GUICtrlCreateCombo("", 350, 160, 141, 25, $CBS_Dropdownlist + $WS_VSCROLL)
	$lblCreateFolderName = GUICtrlCreateLabel("Destination:", 256, 202, 90, 24)
	$cmbCreateFolderName = GUICtrlCreateCombo("", 350, 202, 141, 24, $CBS_Dropdownlist + $WS_VSCROLL)
	$btnCreateVolume = GUICtrlCreateButton("Create\Attach Volume", 514, 175, 169, 25, 0)
EndIf

If $includeDelete = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Delte tab
	;***********************************************************************************************************************************************************************
	$Group2 = GUICtrlCreateTabItem("Delete")
	$lblDeleteVolume = GUICtrlCreateLabel("SAN Volume Name:", 5, 160, 90, 34, $SS_CENTER)
	$cmbDeleteVolume = GUICtrlCreateCombo("", 110, 160, 350, 28, $CBS_Dropdownlist + $WS_VSCROLL)
	$btnDeleteVolume = GUICtrlCreateButton("Unmap\Delete Volume", 504, 160, 169, 25, 0)
EndIf

If $includeExpand = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Expand tab
	;***********************************************************************************************************************************************************************
	$Group3 = GUICtrlCreateTabItem("Expand")
	$lblExpandVolume = GUICtrlCreateLabel("SAN Volume Name:", 5, 160, 90, 34, $SS_CENTER)
	$cmbExpandVolume = GUICtrlCreateCombo("", 110, 160, 350, 28, $CBS_Dropdownlist + $WS_VSCROLL)
	$lblExpandSize = GUICtrlCreateLabel("Amount (GB):", 5, 204, 90, 34, $SS_CENTER)
	$inptExpandSize = GUICtrlCreateInput("", 110, 202, 187, 28)
	$btnExpandVolume = GUICtrlCreateButton("Expand Volume", 504, 175, 169, 25, 0)
	$lblExpandLocalMachine = GUICtrlCreateLabel("NOTE: You must perform this procedure on the computer where the SAN volume for expansion is LUN mapped.", 10, 250, 686, 40, $SS_CENTER)
	GUICtrlSetFont($lblExpandLocalMachine, 14, 400)
EndIf

If $includeSnapshot = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Snapshot tab
	;***********************************************************************************************************************************************************************
	$Group4 = GUICtrlCreateTabItem("Snapshot")
	$radPostImaging = GUICtrlCreateRadio("Post Imaging", 8, 160, 120, 18)
	$radPostProcessing = GUICtrlCreateRadio("Post Processing", 8, 185, 150, 18)
	$radUserProvided = GUICtrlCreateRadio("User Provided Label ------------->", 8, 210, 250, 18)
	$lblSnapShotVolume = GUICtrlCreateLabel("Volume Name:", 180, 158, 105, 25)
	$inptUserProvided = GUICtrlCreateInput("", 290, 210, 189, 28)
	$cmbSnapshotVolume = GUICtrlCreateCombo("", 290, 158, 350, 25, $CBS_Dropdownlist + $WS_VSCROLL + $CBS_SORT)
	$chkMapReplayToServer = GUICtrlCreateCheckbox("Map snapshot to this server:", 20, 255, 212, 18)
	$cmbServerForSnapshot = GUICtrlCreateCombo("", 290, 250, 189, 25, $CBS_Dropdownlist + $WS_VSCROLL)
	$lblFolderForView = GUICtrlCreateLabel("Place snapshot ""view"" in this folder:", 20, 290, 250, 18)
	$cmbFolderForView = GUICtrlCreateCombo("", 290, 285, 189, 25, $CBS_Dropdownlist + $WS_VSCROLL)
	GUICtrlSetState($cmbFolderForView, $gui_disable)
	GUICtrlSetState($cmbServerForSnapshot, $gui_disable)
	$btnSnapshotCreate = GUICtrlCreateButton("Create SnapShot", 504, 220, 169, 35, 0)
EndIf

If $includeMove = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Move tab
	;***********************************************************************************************************************************************************************
	$Group5 = GUICtrlCreateTabItem("Move")
	$lblMoveVolumes = GUICtrlCreateLabel("Volume location, Volume Name, Size", 10, 155, 400, 25)
	$lstMoveVolumes = GUICtrlCreateList("", 10, 180, 350, 100)
	$radMoveFolder = GUICtrlCreateRadio("Move to folder:", 370, 185, 150, 12)
	$cmbMoveFolder = GUICtrlCreateCombo("", 395, 205, 200, 20, $CBS_Dropdownlist + $WS_VSCROLL)
	$radMoveMap = GUICtrlCreateRadio("Move LUN Mapping:", 370, 235, 185, 18)
	$cmbMoveMapping = GUICtrlCreateCombo("", 395, 260, 200, 20, $CBS_Dropdownlist + $WS_VSCROLL)
	$btnMoveFolder = GUICtrlCreateButton("Move", 608, 205, 80, 24)
	$btnMoveMapping = GUICtrlCreateButton("Move", 608, 255, 80, 24)
	GUICtrlSetState($btnMoveFolder, $gui_disable)
	GUICtrlSetState($btnMoveMapping, $gui_disable)
EndIf

If $includeMapUnmap = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Map\Unmap tab
	;***********************************************************************************************************************************************************************
	$Group6 = GUICtrlCreateTabItem("Map\Unmap")
	$lblMapVolumesList = GUICtrlCreateLabel("Volume location, Volume Name, Size", 10, 155, 400, 25)
	$lstMapVolumes = GUICtrlCreateList("", 10, 180, 350, 100)
	$radUnmapVolume = GUICtrlCreateRadio("Remove LUN Map:", 370, 185, 170, 18)
	$radMapVolumes = GUICtrlCreateRadio("Add LUN Map:", 370, 215, 120, 18)
	$cmbMapVolumes = GUICtrlCreateCombo("", 395, 235, 200, 20, $CBS_Dropdownlist + $WS_VSCROLL)
	$btnUnmapVolumes = GUICtrlCreateButton("Remove", 608, 185, 80, 24)
	$btnMapVolumes = GUICtrlCreateButton("Add", 608, 235, 80, 24)
	GUICtrlSetState($btnMapVolumes, $gui_disable)
	GUICtrlSetState($btnUnmapVolumes, $gui_disable)
EndIf

If $includeBackup = "1" Then
	;***********************************************************************************************************************************************************************
	;Sets up the Back this up II tab
	;***********************************************************************************************************************************************************************
	$Group7 = GUICtrlCreateTabItem("Back This UP III")
	$lblBackupServer = GUICtrlCreateLabel("Backup Server Name:", 8, 160, 155, 25)
	$inptBackupServer = GUICtrlCreateInput(IniRead($backupIni, "ProgramData", "Server", ""), 170, 160, 168, 25)
	$lblBackupName = GUICtrlCreateLabel("Backup Job Name:", 8, 190, 155, 24)
	$inptBackupName = GUICtrlCreateInput("", 170, 190, 168, 25)
	$lblUserName = GUICtrlCreateLabel(@UserName & " password:", 8, 220, 155, 25)
	$inptBackupPassword = GUICtrlCreateInput("", 170, 220, 168, 25, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
	$radDerivitive = GUICtrlCreateRadio("Derivitive", 360, 167, 110, 18)
	$radNearline = GUICtrlCreateRadio("Nearline", 360, 197, 110, 18)
	$chkBackup = GUICtrlCreateCheckbox("Export Tapes", 360, 227, 120, 18)
	$btnBackupBrowse = GUICtrlCreateButton("Browse For Target", 505, 168, 169, 25, 0)
	$btnBackupSchedule = GUICtrlCreateButton("Schedule Backup", 505, 213, 169, 25, 0)
	$lblBackupTarget = GUICtrlCreateLabel("Current backup selection: ", 20, 270, 680, 40)
	GUICtrlSetBkColor($lblBackupTarget, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($lblBackupTarget, 14, 400)
EndIf

;***********************************************************************************************************************************************************************
;Sets up the Help tab
;***********************************************************************************************************************************************************************
$Group8 = GUICtrlCreateTabItem("Help")
$lblWelcome = GUICtrlCreateLabel("For this toolbox to communicate with the *, JRE 1.50 or better is required.", 10, 190, 686, 18, $SS_CENTER)
$lblHelp = GUICtrlCreateLabel("*", 10, 150, 680, 36, $SS_CENTER)
$lblAbout = GUICtrlCreateLabel("*", 10, 215, 680, 36, $SS_CENTER)
$lblCompellent = GUICtrlCreateLabel("*", 50, 260, 310, 18)
$inptCompellent = GUICtrlCreateInput($host, 365, 260, 150, 24)
GUICtrlSetState($inptCompellent, $gui_disable)
$lblChangeCompellent = GUICtrlCreateLabel("*", 50, 288, 600, 18)
GUICtrlSetFont($lblChangeCompellent, 10, 400)

;***********************************************************************************************************************************************************************
;Ends the tabbed sections of the GUI
;***********************************************************************************************************************************************************************
GUICtrlCreateTabItem("")

;***********************************************************************************************************************************************************************
;Creates the buttons for the main GUI, which will remain through all the tabs
;***********************************************************************************************************************************************************************
$btnCloseToolbox = GUICtrlCreateButton("Close Toolbox", 102, 320, 180, 30)
$btnRefreshToolbox = GUICtrlCreateButton("Refresh Toolbox", 404, 320, 180, 30)
#EndRegion ### END Koda GUI section ###
;***********************************************************************************************************************************************************************



















For $i = 1 to UBound($arytmp)-1
	If $arytmp[$i] <> "" Then
		If $includeDelete = "1" Then
			_GUICtrlComboBox_AddString($cmbDeleteVolume, $arytmp[$i])
		EndIf
		If $includeExpand = "1" Then
			_GUICtrlComboBox_AddString($cmbExpandVolume, $arytmp[$i])
		EndIf
		If $includeSnapshot = "1" Then
			_GUICtrlComboBox_AddString($cmbSnapshotVolume, $arytmp[$i])
		EndIf
	EndIf
Next

For $i = 1 to UBound($myVolumes)-1
	If $includeMyVolumes = "1" Then
		_GUICtrlListBox_AddString($lstMyVolumes, $myVolumes[$i])
	EndIf
	If $includeMove = "1" Then
		_GUICtrlListBox_AddString($lstMoveVolumes, $myVolumes[$i])
	EndIf
	If $includeMapUnmap = "1" Then
		_GUICtrlListBox_AddString($lstMapVolumes, $myVolumes[$i])
	EndIf
Next