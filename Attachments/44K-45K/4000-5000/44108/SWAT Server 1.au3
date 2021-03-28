#region INCLUDES
#include <ButtonConstants.au3 >
#include <ComboConstants.au3  >
#include <GUIConstantsEx.au3  >
#include <GuiStatusBar.au3    >
#include <Misc.au3            >
#include <GUIListViewEx.au3   >
#include <StaticConstants.au3 >
#include <TabConstants.au3    >
#include <WindowsConstants.au3>
#endregion INCLUDES
#region GLOBALS
Global $reportsfile     = "SWAT_Report"
Global $Settingsinifile = "SWAT_Settings.ini"
Global $commandsfile    = "SWAT_Commands.ini"
Global $Jobsfile        = "SWAT_Jobs.ini"
Global $RegLoc          = "HKEY_LOCAL_MACHINE\SOFTWARE\SWAT\"
Global $bgcolor         = 0xEEEEEE
Global $dll             = DllOpen("user32.dll")
Global $ToolMacro1      = "Empty Macro"
#endregion GLOBALS
#region Defaults
GUICtrlSetDefBkColor($GUI_BKCOLOR_TRANSPARENT)
#endregion Defaults
#region GUI
$MainGui             = GUICreate("Form2", 1108, 722, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $DS_SETFOREGROUND))
$Menu_File           = GUICtrlCreateMenu("File")
$Menu_File_Exit      = GUICtrlCreateMenuItem("Exit", $Menu_File)
$Menu_Action         = GUICtrlCreateMenu("Action")
$Menu_Action_Start   = GUICtrlCreateMenuItem("Start", $Menu_Action)
$Menu_Help           = GUICtrlCreateMenu("Help")
$Menu_Help_About     = GUICtrlCreateMenuItem("About", $Menu_Help)
$Menu_Help_ChangeLog = GUICtrlCreateMenuItem("Change Log", $Menu_Help)
$Tabs                = GUICtrlCreateTab(0, 0, 793, 425, 0272)
#region "Run Job"
$T_RunJob                 = GUICtrlCreateTabItem("Run Job")
;$RunJob_Jobs             = GUICtrlCreateListView("col1  |col2|col3  ", 8, 49, 777, 161)
Global $RunJob_Jobs       = _GUICtrlListView_Create($MainGui, " Job Name | Commands | Computers | OnDemand ", 8, 49, 777, 161, BitOR($LVS_DEFAULT, $WS_BORDER, $LVS_EDITLABELS))
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
_GUICtrlListView_SetExtendedListViewStyle($RunJob_Jobs, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_BORDERSELECT, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
_GUICtrlListView_SetColumnWidth($RunJob_Jobs, 0, 140)
_GUICtrlListView_SetColumnWidth($RunJob_Jobs, 1, 300)
_GUICtrlListView_SetColumnWidth($RunJob_Jobs, 2, 180)
_GUICtrlListView_SetColumnWidth($RunJob_Jobs, 3, 75)
Global $init2             = _GUIListViewEx_Init($RunJob_Jobs, "", 0, 0x00FF00)
$RunJob_B_StartJob        = GUICtrlCreateButton("Start Selected Job", 8, 217, 123, 25)
$RunJob_B_AddComps        = GUICtrlCreateButton("Add Selected Computers", 640, 217, 147, 25)
$RunJob_B_RefreshCompList = GUICtrlCreateButton("Refresh Computer List", 640, 249, 147, 25)
GUICtrlCreateLabel("JOBS STATUS", 8, 257, 278, 49)
GUICtrlSetFont(-1, 30, 400, 0, "Arial")
GUICtrlCreateLabel("Jobs", 8, 33, 26, 17)
$RunJob_Status            = GUICtrlCreateLabel("Running", 288, 257, 147, 49)
GUICtrlSetFont(-1, 30, 400, 0, "Arial")
$RunJob_Currently         = GUICtrlCreateLabel("Currently", 8, 305, 161, 49)
GUICtrlSetFont(-1, 30, 400, 0, "Arial")
$RunJob_PercentComplete   = GUICtrlCreateLabel("100%", 176, 305, 106, 49)
GUICtrlSetFont(-1, 30, 400, 0, "Arial")
$RunJob_Complete          = GUICtrlCreateLabel("complete", 288, 305, 165, 49)
GUICtrlSetFont(-1, 30, 400, 0, "Arial")
#region "Job Builder"
$T_JobBuilder                 = GUICtrlCreateTabItem("Job Builder")
$JobBuilder_Commands          = GUICtrlCreateListView("Command Name | Command String              ", 8, 73, 393, 345)
GUICtrlSetData(-1, "")
$JobBuilder_JobList           = GUICtrlCreateTreeView(552, 73, 233, 345)
GUICtrlCreateLabel("Commands", 8, 57, 56, 17)
GUICtrlCreateLabel("Job List", 552, 57, 40, 17)
$JobBuilder_B_RefreshCommands = GUICtrlCreateButton("Refresh", 296, 41, 75, 25)
$JobBuilder_B_RefreshJobList  = GUICtrlCreateButton("Refresh", 704, 41, 75, 25)
$JobBuilder_B_AddCommand      = GUICtrlCreateButton("Add Command >>", 416, 361, 123, 25)
$JobBuilder_B_RemoveCommand   = GUICtrlCreateButton("<< Remove Command", 416, 393, 123, 25)
$JobBuilder_B_CreateJob       = GUICtrlCreateButton("Create new Job", 416, 113, 123, 25)
$JobBuilder_B_RemoveJob       = GUICtrlCreateButton("Remove Job", 416, 145, 123, 25)
#region "Command List"
$T_CommandList                = GUICtrlCreateTabItem("Command List")
$CommandList_CommandString    = GUICtrlCreateInput("", 144, 393, 633, 22)
$CommandList_CommFriendlyName = GUICtrlCreateInput("", 8, 393, 121, 22)
$CommandList_CommandList      = GUICtrlCreateListView("Command Name | Command String              ", 8, 33, 769, 281)
GUICtrlCreateLabel("Command Friendly Name", 8, 377, 121, 17)
GUICtrlCreateLabel("Command String", 144, 377, 81, 17)
$CommandList_B_Add            = GUICtrlCreateButton("Add", 8, 321, 75, 25)
$CommandList_B_Edit           = GUICtrlCreateButton("Edit", 96, 321, 75, 25)
$CommandList_B_Delete         = GUICtrlCreateButton("Delete", 184, 321, 75, 25)
#region "Results"
$T_Results       = GUICtrlCreateTabItem("Results")
$Results_Results = GUICtrlCreateEdit("Edit4", 8, 33, 777, 337)
$Results_B_TBD1  = GUICtrlCreateButton("TBD", 8, 377, 75, 25)
$Results_B_TBD2  = GUICtrlCreateButton("Button23", 88, 377, 75, 25)
$Results_B_TBD3  = GUICtrlCreateButton("Button24", 168, 377, 75, 25)
#region "Compare Reports"
$T_CompareReports                  = GUICtrlCreateTabItem("Compare Reports")
GUICtrlCreateGroup("", 16, 241, 761, 177)
$CompResults_CompareResults        = GUICtrlCreateEdit("CompResults_B3", 20, 256, 670, 153)
$CompResults_B_CompareResults_Save = GUICtrlCreateButton("Save as", 696, 385, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$CompResults_LeftEdit              = GUICtrlCreateEdit("CompResults_B1", 16, 41, 300, 201)
$CompResults_RightEdit             = GUICtrlCreateEdit("CompResults_B2", 472, 41, 305, 201)
$CompResults_B_LoadLeft            = GUICtrlCreateButton("<< Load Results", 328, 41, 131, 25)
$CompResults_B_LoadRight           = GUICtrlCreateButton("Load Results >>", 328, 73, 131, 25)
$CompResults_B_GenerateCompare     = GUICtrlCreateButton("Generate Comparison", 328, 209, 131, 25)
#region "Preferences"
$T_Preferences                  = GUICtrlCreateTabItem("Preferences")
GUICtrlCreateGroup("Domain Account with Admin Rights", 16, 33, 281, 153)
GUICtrlSetBkColor(-1, $bgcolor)
$Preferences_DomainUsername     = GUICtrlCreateInput("", 24, 65, 150, 22)
$Preferences_DomainPass         = GUICtrlCreateInput("", 24, 145, 150, 22)
GUICtrlCreateLabel("Username", 24, 49, 52, 17)
GUICtrlCreateLabel("Domain", 24, 89, 40, 17)
$Preferences_DomainDomain       = GUICtrlCreateInput("", 24, 105, 150, 22)
GUICtrlCreateLabel("Password", 24, 129, 50, 17)
$Preferences_B_DomainValidate   = GUICtrlCreateButton("Validate", 208, 153, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Local Account with Admin Rights", 16, 193, 281, 105)
GUICtrlSetBkColor(-1, $bgcolor)
$Preferences_LocalPass          = GUICtrlCreateInput("", 24, 265, 150, 22)
GUICtrlCreateLabel("Password", 24, 249, 40, 17)
$Preferences_LocalUsername      = GUICtrlCreateInput("", 24, 225, 150, 22)
GUICtrlCreateLabel("Username", 24, 209, 52, 17)
$Preferences_B_LocalValidate    = GUICtrlCreateButton("Validate", 208, 265, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("File Locations", 304, 33, 473, 177)
GUICtrlSetBkColor(-1, $bgcolor)
GUICtrlCreateLabel("Commands and Job file storage", 312, 145, 151, 17)
$Preferences_ComJobFileLocal    = GUICtrlCreateInput("", 312, 161, 449, 22)
$Preferences_ReportsFileLocal   = GUICtrlCreateInput("", 312, 81, 449, 22)
GUICtrlCreateLabel("Reports", 312, 65, 41, 17)
$Preferences_SettingsINIFileLoc = GUICtrlCreateInput("", 312, 121, 449, 22)
GUICtrlCreateLabel("Settings INI File", 312, 105, 78, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("IMPORT SETTINGS", 16, 305, 281, 113)
GUICtrlSetBkColor(-1, $bgcolor)
$Preferences_ImportFromComp     = GUICtrlCreateInput("", 184, 337, 100, 22)
GUICtrlCreateLabel("Import from computer", 184, 321, 103, 17)
$Preferences_B_Import           = GUICtrlCreateButton("IMPORT", 208, 377, 75, 25)
$Preferences_ImportADMPass      = GUICtrlCreateInput("", 24, 377, 150, 22)
GUICtrlCreateLabel("ADM Password", 24, 361, 77, 17)
$Preferences_ImportADMUsername  = GUICtrlCreateInput("", 24, 337, 150, 22)
GUICtrlCreateLabel("ADM Username", 24, 321, 79, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Group5", 304, 217, 473, 161)
GUICtrlSetBkColor(-1, $bgcolor)
$Preferences_TBD2               = GUICtrlCreateCheckbox("Future Use 1", 320, 249, 97, 17)
$Preferences_TBD1               = GUICtrlCreateCheckbox("Future Use 2", 320, 265, 97, 17)
$Preferences_TBD3               = GUICtrlCreateCheckbox("Future Use 3", 320, 281, 97, 17)
$Preferences_TBD4               = GUICtrlCreateCheckbox("Future Use 4", 320, 297, 97, 17)
$Preferences_TBD5               = GUICtrlCreateCheckbox("Future Use 5", 320, 313, 97, 17)
$Preferences_TBD6               = GUICtrlCreateCheckbox("Future Use 6", 320, 329, 97, 17)
$Preferences_B_SaveAll          = GUICtrlCreateButton("Save All", 704, 393, 75, 25)
$Preferences_B_Reset            = GUICtrlCreateButton("Reset", 624, 393, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
#region "Diagnostics"
$T_Diags              = GUICtrlCreateTabItem("Diagnostics")
$T_Diags_B_StartDiags = GUICtrlCreateButton("Start Diags", 640, 265, 115, 25)
$Diags_Step1          = GUICtrlCreateLabel("Has Valid IP", 32, 105, 62, 17)
$Diags_Step2          = GUICtrlCreateLabel("Can reach domain", 32, 129, 90, 17)
$Diags_Step3          = GUICtrlCreateLabel("Can see computers ready for testing", 32, 153, 173, 17)
$Diags_Step4          = GUICtrlCreateLabel("Reports Path exists and is writeable", 32, 177, 171, 17)
$Diags_Step5          = GUICtrlCreateLabel("Settings Path exists and is writeable", 32, 201, 172, 17)
$Diags_Step6          = GUICtrlCreateLabel("Commands and Job file storage exists and is writeable", 32, 225, 256, 17)
$Diags_Step7          = GUICtrlCreateLabel("Local User Account with Admin Rights account is in good standing", 32, 249, 318, 17)
$Diags_Step8          = GUICtrlCreateLabel("Domain User Account with Admin Rights account is in good standing", 32, 273, 328, 17)
;$Label26             = GUICtrlCreateLabel("", 32, 257, 4, 4)
$Edit5                = GUICtrlCreateEdit("Edit5", 33, 297, 727, 113)
#region ### Bottom Area ###
GUICtrlCreateTabItem("")
GUICtrlCreateGroup("", 0, 432, 793, 137)
$CustCommand        = GUICtrlCreateInput("", 8, 536, 657, 21)
$Execute            = GUICtrlCreateButton("Execute", 672, 536, 99, 25)
GUICtrlCreateLabel("Custom Command", 8, 520, 89, 17)
$Macro1             = GUICtrlCreateButton("Macro1", 8, 448, 75, 25)
$Macro2             = GUICtrlCreateButton("Macro2", 88, 448, 75, 25)
$Macro3             = GUICtrlCreateButton("Macro3", 168, 448, 75, 25)
$Macro4             = GUICtrlCreateButton("Macro4", 248, 448, 75, 25)
$Macro5             = GUICtrlCreateButton("Macro5", 328, 448, 75, 25)
$Macro6             = GUICtrlCreateButton("Macro6", 8, 480, 75, 25)
$Macro7             = GUICtrlCreateButton("Macro7", 88, 480, 75, 25)
$Macro8             = GUICtrlCreateButton("Macro8", 168, 480, 75, 25)
$Macro9             = GUICtrlCreateButton("Macro9", 248, 480, 75, 25)
$Macro10            = GUICtrlCreateButton("Macro10", 328, 480, 75, 25)
GUICtrlSetTip($Macro1 , $ToolMacro1, "Macro 1", 1, 1)
GUICtrlSetTip($Macro2 , $ToolMacro1, "Macro 2", 1, 1)
GUICtrlSetTip($Macro3 , $ToolMacro1, "Macro 3", 1, 1)
GUICtrlSetTip($Macro4 , $ToolMacro1, "Macro 4", 1, 1)
GUICtrlSetTip($Macro5 , $ToolMacro1, "Macro 5", 1, 1)
GUICtrlSetTip($Macro6 , $ToolMacro1, "Macro 6", 1, 1)
GUICtrlSetTip($Macro7 , $ToolMacro1, "Macro 7", 1, 1)
GUICtrlSetTip($Macro8 , $ToolMacro1, "Macro 8", 1, 1)
GUICtrlSetTip($Macro9 , $ToolMacro1, "Macro 9", 1, 1)
GUICtrlSetTip($Macro10, $ToolMacro1, "Macro 010", 1, 1)
LoadToolTips()
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("Custom Command", 420, 448, 357, 81)
$MachList           = GUICtrlCreateEdit("", 800, 24, 305, 545)
GUICtrlSetData(-1, "")
$Console            = GUICtrlCreateEdit("", 0, 600, 1105, 97)
GUICtrlSetData(-1, "console")
$_B_SaveConsole     = GUICtrlCreateButton("Save", 0, 576, 75, 17)
$_B_ClearConsole    = GUICtrlCreateButton("Clear", 80, 576, 75, 17)
;$ButtonForLaterUse = GUICtrlCreateButton("Save", 160, 576, 75, 17)
GUICtrlSetState($T_RunJob, $GUI_SHOW)
GUISetState(@SW_SHOW)
#endregion GUI
Global $Currenttab = GUICtrlRead($Tabs)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Macro1
			If _IsPressed("11", $dll) Then
				SetMacro(1)
			Else
				Macro(1)
			EndIf
		Case $Macro2
			If _IsPressed("11", $dll) Then
				SetMacro(2)
			Else
				Macro(2)
			EndIf
		Case $Macro3
			If _IsPressed("11", $dll) Then
				SetMacro(3)
			Else
				Macro(3)
			EndIf
		Case $Macro4
			If _IsPressed("11", $dll) Then
				SetMacro(4)
			Else
				Macro(4)
			EndIf
		Case $Macro5
			If _IsPressed("11", $dll) Then
				SetMacro(5)
			Else
				Macro(5)
			EndIf
		Case $Macro6
			If _IsPressed("11", $dll) Then
				SetMacro(6)
			Else
				Macro(6)
			EndIf
		Case $Macro7
			If _IsPressed("11", $dll) Then
				SetMacro(7)
			Else
				Macro(7)
			EndIf
		Case $Macro8
			If _IsPressed("11", $dll) Then
				SetMacro(8)
			Else
				Macro(8)
			EndIf
		Case $Macro9
			If _IsPressed("11", $dll) Then
				SetMacro(9)
			Else
				Macro(9)
			EndIf
		Case $Macro10
			If _IsPressed("11", $dll) Then
				SetMacro(10)
			Else
				Macro(10)
			EndIf
			; TAB Switch Stuff
		Case $Currenttab <> GUICtrlRead($Tabs)
			$Currenttab = GUICtrlRead($Tabs)
			If GUICtrlRead($Tabs) <> 0 Then ; If tab is not Run Job then
				;
				WinSetState($RunJob_Jobs, "", @SW_HIDE)
			Else
				;
				WinSetState($RunJob_Jobs, "", @SW_SHOW)
			EndIf
			If GUICtrlRead($Tabs) <> 1 Then ; If tab is not Job Builder then
				;
			Else
				;
			EndIf
			If GUICtrlRead($Tabs) <> 2 Then ; If tab is not Command List then
				;
			Else
				;
			EndIf
			If GUICtrlRead($Tabs) <> 3 Then ; If tab is not Results then
				;
			Else
				;
			EndIf
			If GUICtrlRead($Tabs) <> 4 Then ; If tab is not Compare Reports then
				;
			Else
				;
			EndIf
			If GUICtrlRead($Tabs) <> 5 Then ; If tab is not Preferences then
				;
			Else
				;
			EndIf
			If GUICtrlRead($Tabs) <> 6 Then ; If tab is not Diagnostics then
				;
			Else
				;
			EndIf
	EndSwitch
WEnd
Func SetMacro($whichone)
	#cs
		$minigui = GUICreate("Edit Macro " & $whichone, 434, 229, 192, 114)
		GUISetBkColor(0xF0F0F0)
		$macnameset = GUICtrlCreateInput("", 16, 30, 153, 21)
		GUICtrlSetLimit($macnameset, 12, 0)
		GUICtrlCreateLabel("Macro Name", 16, 12, 65, 17)
		$canc = GUICtrlCreateButton("Close", 252, 192, 75, 25)
		$apply = GUICtrlCreateButton("Apply", 340, 192, 75, 25)
		$clearm = GUICtrlCreateButton("Clear Macro", 8, 192, 75, 25)
		$MacLocBu = GUICtrlCreateCombo("", 59, 77, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "4|7|11|15|17|19|52")
		$MacLocFl = GUICtrlCreateCombo("", 201, 77, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "1|2|3")
		$MacLocSi = GUICtrlCreateCombo("", 335, 77, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "Left|Right")
		$MacLocAr = GUICtrlCreateCombo("", 59, 119, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10")
		$MacLocUn = GUICtrlCreateCombo("", 201, 119, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10")
		$MacLocSh = GUICtrlCreateCombo("", 335, 119, 85, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
		GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10")
		GUICtrlCreateLabel("Building:", 13, 77, 45, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Floor:", 159, 77, 37, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Side:", 293, 77, 37, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Area:", 21, 119, 37, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Unit:", 159, 119, 37, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Shelf:", 301, 119, 29, 20, $SS_RIGHT)
		$Label1 = GUICtrlCreateLabel("EDIT MACRO " & $whichone, 224, 10, 170, 36)
		GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x000000)
	#ce
	#region ### START Koda GUI section ### Form=
	$minigui = GUICreate("Edit Macro", 549, 210, 245, 200)
	GUISetBkColor(0xF0F0F0)
	$macnameset = GUICtrlCreateInput("", 16, 62, 153, 21)
	GUICtrlCreateLabel("Command Name", 16, 44, 145, 17)
	$canc = GUICtrlCreateButton("Close", 372, 160, 75, 25)
	$apply = GUICtrlCreateButton("Apply", 460, 160, 75, 25)
	$clearm = GUICtrlCreateButton("Clear Macro", 200, 160, 75, 25)
	$MacLocAr = GUICtrlCreateCombo("", 19, 167, 149, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	$Label1 = GUICtrlCreateLabel("EDIT MACRO", 328, 10, 170, 36)
	GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	$Input1 = GUICtrlCreateInput("", 184, 62, 353, 21)
	GUICtrlCreateLabel("Command String", 184, 44, 145, 17)
	GUICtrlCreateLabel("Pre-defined Command", 16, 148, 145, 17)
	$Label2 = GUICtrlCreateLabel("OR", 48, 98, 58, 36)
	GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	$isitthere = RegRead($RegLoc & "Mac" & $whichone, "name")
	If $isitthere <> "" Then
		If RegRead($RegLoc & "Mac" & $whichone, "Name")     Then GUICtrlSetData($macnameset, RegRead($RegLoc & "Mac" & $whichone, "Name"))
		If RegRead($RegLoc & "Mac" & $whichone, "Building") Then GUICtrlSetData($MacLocBu, RegRead($RegLoc & "Mac" & $whichone, "Building"))
		If RegRead($RegLoc & "Mac" & $whichone, "Floor")    Then GUICtrlSetData($MacLocFl, RegRead($RegLoc & "Mac" & $whichone, "Floor"))
		If RegRead($RegLoc & "Mac" & $whichone, "Side")     Then GUICtrlSetData($MacLocSi, RegRead($RegLoc & "Mac" & $whichone, "Side"))
		If RegRead($RegLoc & "Mac" & $whichone, "Area")     Then GUICtrlSetData($MacLocAr, RegRead($RegLoc & "Mac" & $whichone, "Area"))
		If RegRead($RegLoc & "Mac" & $whichone, "Unit")     Then GUICtrlSetData($MacLocUn, RegRead($RegLoc & "Mac" & $whichone, "Unit"))
		If RegRead($RegLoc & "Mac" & $whichone, "Shelf")    Then GUICtrlSetData($MacLocSh, RegRead($RegLoc & "Mac" & $whichone, "Shelf"))
	EndIf
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($minigui)
				ExitLoop
				Return
			Case $canc
				GUIDelete($minigui)
				ExitLoop
				Return
			Case $apply
				If GUICtrlRead($macnameset) = "" Then
					MsgBox(0, "Forget Something?", "You have to give your macro a name. This is the name that will appear on the button of the macro.", 5)
				Else
					RegWrite($RegLoc & "Mac" & $whichone, "Name", "REG_SZ", GUICtrlRead($macnameset))
					If GUICtrlRead($MacLocBu) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Building", "REG_SZ", GUICtrlRead($MacLocBu))
					If GUICtrlRead($MacLocFl) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Floor", "REG_SZ", GUICtrlRead($MacLocFl))
					If GUICtrlRead($MacLocSi) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Side", "REG_SZ", GUICtrlRead($MacLocSi))
					If GUICtrlRead($MacLocAr) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Area", "REG_SZ", GUICtrlRead($MacLocAr))
					If GUICtrlRead($MacLocUn) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Unit", "REG_SZ", GUICtrlRead($MacLocUn))
					If GUICtrlRead($MacLocSh) <> "" Then RegWrite($RegLoc & "Mac" & $whichone, "Shelf", "REG_SZ", GUICtrlRead($MacLocSh))
					UpdateMacros()
					GUIDelete($minigui)
					ExitLoop
				EndIf
			Case $clearm
				Dim $iMsgBoxAnswerMac
				$iMsgBoxAnswerMac = MsgBox(262419, "Are you SURE?", "Are you SURE you wish to clear this macro?", 15)
				Select
					Case $iMsgBoxAnswerMac = 6 ;Yes
						RegDelete($RegLoc & "Mac" & $whichone)
						UpdateMacros()
						MsgBox(0, "", "Macro Cleared")
						UpdateMacros()
					Case $iMsgBoxAnswerMac = 7 ;No
						MsgBox(0, "", "OK, nothing has been deleted", 5)
						UpdateMacros()
					Case $iMsgBoxAnswerMac = 2 ;Cancel
						;UpdateMacros()
					Case $iMsgBoxAnswerMac = -1 ;Timeout
						MsgBox(0, "", "OK, nothing has been deleted", 5)
						UpdateMacros()
				EndSelect
		EndSwitch
	WEnd
EndFunc   ;==>SetMacro
Func Macro($num)
EndFunc   ;==>Macro
Func UpdateMacros()
	If RegRead($RegLoc & "Mac1", "Name") Then
		GUICtrlSetData($Macro1, RegRead($RegLoc & "Mac1", "Name"))
		GUICtrlSetStyle($Macro1, $GUI_SS_DEFAULT_BUTTON)
	Else
		GUICtrlSetData($Macro1, "Macro 1")
		GUICtrlSetStyle($Macro1, $BS_FLAT)
	EndIf
	LoadToolTips()
EndFunc   ;==>UpdateMacros
Func LoadToolTips()
	$isitthere1 = RegRead($RegLoc & "Mac1", "name")
	If $isitthere1 <> "" Then
		$isitthere1data = ""
		If RegRead($RegLoc & "Mac1", "Building") Then $isitthere1data &= "Building: " & RegRead($RegLoc & "Mac1", "Building") & @CRLF
		If RegRead($RegLoc & "Mac1", "Floor") Then $isitthere1data &= "Floor: " & RegRead($RegLoc & "Mac1", "Floor") & @CRLF
		GUICtrlSetTip($Macro1, $isitthere1data, "Macro 1", 1, 1)
	Else
		GUICtrlSetTip($Macro1, "This macro is not defined yet." & @CRLF & "Hold CTRL and click on it" & @CRLF & "to bind a command to it.", "Macro 1", 1, 1)
	EndIf
EndFunc   ;==>LoadToolTips
Func Hide($Rachel)
	If GUICtrlGetState($Rachel) = 80 Then GUICtrlSetState($Rachel, 96)
EndFunc   ;==>Hide
Func Show($Rachel)
	If GUICtrlGetState($Rachel) = 96 Then GUICtrlSetState($Rachel, 80)
EndFunc   ;==>Show
