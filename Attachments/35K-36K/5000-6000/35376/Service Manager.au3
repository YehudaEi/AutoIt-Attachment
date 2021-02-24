#include <Services.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=i:\autoit\scripts\service manager\service manager.kxf

$Service_Manager = GUICreate("Windows Service Manager - Created by Alex Pilkington © 2011", 627, 508,-1,-1)


$Tab_Root = GUICtrlCreateTab(16, 16, 593, 473)


$Tab_Create = GUICtrlCreateTabItem("Create")

	$Label_Create_ServiceName = GUICtrlCreateLabel("Service Name:", 24, 48, 74, 17)
	$Label_Create_DisplayName = GUICtrlCreateLabel("Display Name:", 24, 80, 72, 17)
	$Label_Create_ServiceType = GUICtrlCreateLabel("Service Type:", 24, 112, 70, 17)
	$Label_Create_StartType = GUICtrlCreateLabel("Start Type:", 24, 144, 56, 17)
	$Label_Create_ErrorControl = GUICtrlCreateLabel("Error Control:", 24, 176, 65, 17)
	$Label_Create_BinaryPath = GUICtrlCreateLabel("Binary Path:", 24, 208, 61, 17)
	$Label_Create_LoadOrderGroup = GUICtrlCreateLabel("Load Order Group:", 24, 240, 92, 17)
	$Label_Create_TagID = GUICtrlCreateLabel("Tag ID:", 24, 272, 40, 17)
	$Label_Create_Dependencies = GUICtrlCreateLabel("Dependencies:", 24, 304, 76, 17)
	$Label_Create_ServiceUser = GUICtrlCreateLabel("Service User:", 24, 336, 68, 17)
	$Label_Create_Password = GUICtrlCreateLabel("Password:", 24, 368, 53, 17)
	$Label_Create_ComputerName = GUICtrlCreateLabel("Computer Name:", 24, 400, 83, 17)

	$Input_Create_Service_Name = GUICtrlCreateInput("", 120, 48, 481, 21)
	$Input_Create_Display_Name = GUICtrlCreateInput("", 120, 80, 481, 21)
	GUICtrlSetLimit(-1, 256)
	$Combo_Create_Service_Type = GUICtrlCreateCombo("$SERVICE_KERNEL_DRIVER", 120, 112, 481, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "$SERVICE_FILE_SYSTEM_DRIVER|$SERVICE_WIN32_OWN_PROCESS|$SERVICE_WIN32_SHARE_PROCESS|BITOR($SERVICE_WIN32_OWN_PROCESS,$SERVICE_INTERACTIVE_PROCESS)|BITOR($SERVICE_WIN32_SHARE_PROCESS,$SERVICE_INTERACTIVE_PROCESS)")
	$Combo_Create_Start_Type = GUICtrlCreateCombo("$SERVICE_BOOT_START", 120, 144, 481, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "$SERVICE_SYSTEM_START|$SERVICE_AUTO_START|$SERVICE_DEMAND_START|$SERVICE_DISABLED")
	$Combo_Create_Error_Control = GUICtrlCreateCombo("$SERVICE_ERROR_IGNORE", 120, 176, 481, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "$SERVICE_ERROR_NORMAL|$SERVICE_ERROR_SEVERE|$SERVICE_ERROR_CRITICAL")
	$Input_Create_Binary_Path = GUICtrlCreateInput("", 120, 208, 481, 21)
	$Input_Create_Load_Order_Group = GUICtrlCreateInput("", 120, 240, 481, 21)
	$Input_Create_TagID = GUICtrlCreateInput("", 120, 272, 481, 21)
	$Input_Create_Dependencies = GUICtrlCreateInput("", 120, 304, 481, 21)
	$Input_Create_Service_User = GUICtrlCreateInput("", 120, 336, 481, 21)
	$Input_Create_Password = GUICtrlCreateInput("", 120, 368, 481, 21)
	$Input_Create_Computer_Name = GUICtrlCreateInput("", 120, 400, 481, 21)

	$Button_Create_Go = GUICtrlCreateButton("Go !", 480, 448, 121, 25)
	$Button_Create_Help = GUICtrlCreateButton("Help", 120, 448, 121, 25)


$Tab_Delete = GUICtrlCreateTabItem("Delete")

	$Label_Delete_Service_Name = GUICtrlCreateLabel("Service Name:", 24, 48, 74, 17)
	$Label_Delete_Computer = GUICtrlCreateLabel("Computer:", 24, 80, 52, 17)

	$Input_Delete_Service_Name = GUICtrlCreateInput("", 120, 48, 481, 21)
	$Input_Delete_Computer = GUICtrlCreateInput("", 120, 80, 481, 21)

	$Button_Delete_Go = GUICtrlCreateButton("Go !", 480, 120, 121, 25)
	$Button_Delete_Help = GUICtrlCreateButton("Help", 120, 120, 121, 25)

$Tab_About = GUICtrlCreateTabItem("About")

GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###

dim $nMsg

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button_Create_Go

			$Create_Service_Name = Guictrlread($Input_Create_Service_Name,1)
			$Create_Display_Name = Guictrlread($Input_Create_Display_Name,1)
			$Create_Service_Type = Guictrlread($Combo_Create_Service_Type,1)
			$Create_Start_Type = Guictrlread($Combo_Create_Start_Type,1)
			$Create_Error_Control = Guictrlread($Combo_Create_Error_Control,1)
			$Create_Binary_Path = Guictrlread($Input_Create_Binary_Path,1)
			$Create_Load_Order_Group = Guictrlread($Input_Create_Load_Order_Group,1)
			$Create_TagID = Guictrlread($Input_Create_TagID,1)
			$Create_Dependencies = Guictrlread($Input_Create_Dependencies,1)
			$Create_Service_User = Guictrlread($Input_Create_Service_User,1)
			$Create_Password = Guictrlread($Input_Create_Password,1)
			$Create_Computer_Name = Guictrlread($Input_Create_Computer_Name,1)

						_Service_Create('"' & $Create_Service_Name & '"', _
							'"' & $Create_Display_Name & '"', _
							$Create_Service_Type, _
							$Create_Start_Type, _
							$Create_Error_Control, _
							'"' & $Create_Binary_Path & '"', _
							$Create_Load_Order_Group, _
							$Create_TagID, _
							$Create_Dependencies, _
							$Create_Service_User, _
							$Create_Password, _
							$Create_Computer_Name)

			if @error Then
				MsgBox(0,"Error", "Error Number : " & @error  & @CRLF & "Error Message: " & _WinAPI_GetLastErrorMessage())
			EndIf

		Case $Button_Create_Help

			$Create_Data_Help_File = @ScriptDir & "\create_help.txt"
			$_Run = "notepad.exe " & $Create_Data_Help_File
			ConsoleWrite ( "$_Run : " & $_Run & @Crlf )
			Run ( $_Run,"", @SW_MAXIMIZE )

		Case $Button_Delete_Go

			$Delete_Service_Name = Guictrlread($Input_Delete_Service_Name)
			$Delete_Computer_Name = Guictrlread($Input_Delete_Computer)

			_Service_Delete($Delete_Service_Name, $Delete_Computer_Name)

			if @error Then
				MsgBox(0,"Error", "Error Number : " & @error  & @CRLF & "Error Message: " & _WinAPI_GetLastErrorMessage())

			EndIf

		Case $Button_Delete_Help

			$Delete_Data_Help_File = @ScriptDir & "\delete_help.txt"
			$_Run = "notepad.exe " & $Delete_Data_Help_File
			ConsoleWrite ( "$_Run : " & $_Run & @Crlf )
			Run ( $_Run,"", @SW_MAXIMIZE )

	EndSwitch
WEnd

