#include <Array.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiIPAddress.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>

; ### Replication of Adapter Dialog in Windows - with presets - TCP/IPv4 Only ###

; **Create dynamic presets and populate list in menu > 'load' | 'Tray' | 'ApplyTo'
; 'New' - creates a new blank preset > see NewPreset()
; 'Load' - load a saved preset and its data.
; 'Save' - save current preset under preset name (if preset name is changed it edits presets previous entry)
; 'Save As..' - Creates a new entry using the current values saved under the 'new' preset name - leaving the preset the values were loaded from unchanged ~ basically like any programs 'Save As..'
; 'Delete' - delete a selected preset (if deleted preset 'is open' then load [deleted presets entry - 1])

; **Populate 'SaveAs() | AdapterOptions() | NewPreset() | ApplyTo()' installed list**
	; *Where a list of available adapters needs to be generated - include disable adapters if possible*

; **Find a working solution for AdapterOptions() ~ Enable/Disable/Reset Adapter**
	
; **Populate combobox's with the relevant data**
	
; **'Apply' - applies current loaded presets ip fields to chosen adapter - Note: $DNS_AUTO cannot be used when $IP_USE is checked BUT $DNS_USE can be used if $IP_AUTO is checked.
		;~Option to apply to multiple adapters
		
; **Sort FileGet out ~ implements Config() if Exists or prompt to create new blank resource file**
		
Opt('MustDeclareVars', 1)
Opt('TrayMenuMode', 3)
Opt('TrayAutoPause', 0)

Global $gView, $gWidth	;Advanced View

Global $gui, $ADV_gui, $msg
Global $pRead, $pTitle, $pName	;Preset name/Adapter name loaded from preset (if needed)
Global $aRead, $aTitle, $aName
Global $pLoad, $tPreset	;Preset Lists

Global $IP_AUTO, $IP_USE, $IP_ADDRESS, $SUBNET_MASK, $DEFAULT_GATEWAY	;Config()
Global $DNS_AUTO, $DNS_USE, $PREFERRED_DNS, $ALTERNATE_DNS				;IP Settings & Fields
Global $NaInstalled, $NaCustom	;NewPreset()

Global $aInstalled	;AdapterOptions()

Global $sFile

$sFile = @Scriptdir & "\LazyIP.inc"

$gView = "Basic"
$gWidth = 325

$pName = ""
$aName = ""

Config()

;FileGet()

;Func FileGet()
	;Local $SourceReadError

	;While 1
		;If FileExists(@ScriptDir & "\LazyIP.inc") Then
			;Config()
		;Else
			;$SourceReadError = MsgBox(4, "Config File Read Error", "The data resource '" & "LazyIP.inc" & "' for this config was not found." & @CRLF & "Click 'Yes' to create a new blank resource.")
			;If $SourceReadError = 6 Then
				;FileOpen(@Scriptdir & "\LazyIP.inc", 8)
			;Else
				;Return
			;EndIf
		;EndIf
	;WEnd
;EndFunc

Func Config()
	Local $Presets, $PresetsDummy, $PresetsContext, $pNew, $pSave, $pSaveAs, $pDelete
	Local $bAdapterOptions
	Local $bApply, $bApplyTo, $bNetworkConnections
	Local $IP_AUTO_STATUS, $IP_USE_STATUS, $IP_GET, $SUB_GET, $DEF_GET
	Local $DNS_AUTO_STATUS, $DNS_USE_STATUS, $PREF_DNS_GET, $ALT_DNS_GET
	Local $LoadPrompt, $ExitPrompt
	Local $tMsg, $tOptions, $tAbout, $tExit
	Local $bAdvancedOptions
	
	$gui = GUICreate("LazyIP Config", $gWidth, 410, -1, -1)
	
	$Presets = GUICtrlCreateButton("Presets", 15, 12, 55, 22)
	$PresetsDummy = GUICtrlCreateDummy()
	$PresetsContext = GUICtrlCreateContextMenu($PresetsDummy)
	$pNew = GUICtrlCreateMenuItem("New", $PresetsContext)
	$pLoad = GUICtrlCreateMenu("Load", $PresetsContext)
	$pSave = GUICtrlCreateMenuItem("Save", $PresetsContext)
	$pSaveAs = GUICtrlCreateMenuItem("Save As..", $PresetsContext)
	$pDelete = GUICtrlCreateMenuItem("Delete", $PresetsContext)
	
	$bAdapterOptions = GUICtrlCreateButton("Adapter Options", 85, 12, 100, 22)
	
	$bAdvancedOptions = GUICtrlCreateButton("Advanced Options", 200, 12, 110, 22)
	
	GUICtrlCreateGroup("", 13, 140, 300, 110)
	GUICtrlCreateGroup("", 13, 285, 300, 80)
	
	GUICtrlCreateGroup("", 13, 45, 300, 65)
	GUICtrlCreateLabel("Preset:", 25, 60)
	$pTitle = GUICtrlCreateLabel($pName, 100, 60)
	GUICtrlCreateLabel("Adapter:", 25, 85)
	$aTitle = GUICtrlCreateLabel($aName, 100, 85)
	
	GUIStartGroup()
	$IP_AUTO = GUICtrlCreateRadio("Obtain an IP address automatically", 25, 115)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$IP_USE = GUICtrlCreateRadio("Use the following IP address:", 25, 135)
	
	GUICtrlCreateLabel("IP Address:", 25, 165)
	$IP_ADDRESS = _GUICtrlIPAddress_Create($gui, 150, 160, 150, 20)
	
	GUICtrlCreateLabel("Subnet Mask:", 25, 195)
	$SUBNET_MASK = _GUICtrlIPAddress_Create($gui, 150, 190, 150, 20)
	
	GUICtrlCreateLabel("Default Gateway:", 25, 225)
	$DEFAULT_GATEWAY = _GUICtrlIPAddress_Create($gui, 150, 220, 150, 20)
	
	GUIStartGroup()
	$DNS_AUTO = GUICtrlCreateRadio("Obtain DNS server address automatically", 25, 260)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$DNS_USE = GUICtrlCreateRadio("Use the following DNS server addresses:", 25, 280)
	
	GUICtrlCreateLabel("Preferred DNS Server:", 25, 310)
	$PREFERRED_DNS = _GUICtrlIPAddress_Create($gui, 150, 305, 150, 20)
	
	GUICtrlCreateLabel("Alternate DNS Server:", 25, 340)
	$ALTERNATE_DNS = _GUICtrlIPAddress_Create($gui, 150, 335, 150, 20)
	
	$bNetworkConnections = GUICtrlCreateButton("Network Connections", 160, 375, 150, 25)
	$bApply = GUICtrlCreateButton("Apply", 15, 375, 55, 25)
	$bApplyTo = GUICtrlCreateButton("+", 75, 375, 25, 25)
	GUISetState()
	
	$tPreset = TrayCreateMenu("Presets")
	TrayCreateItem("Apply", $tPreset)
	TrayCreateItem("", $tPreset)
	$tOptions = TrayCreateItem("Adapter")
	$tAbout = TrayCreateItem("About")
	TrayCreateItem("")
	$tExit = TrayCreateItem("Exit")
	
	TraySetClick(24)
	TraySetState(2)
	
	$pRead = IniReadSectionNames($sFile)
	If IsArray($pRead) Then
		For $i = 1 To UBound($pRead) - 1
			GUICtrlCreateMenuItem($pRead[$i], $pLoad)
			TrayCreateItem($pRead[$i], $tPreset)
		Next
	EndIf
	
	While 1
	$msg = GUIGetMsg()
	
	$IP_AUTO_STATUS = GUICtrlRead($IP_AUTO)
	$IP_USE_STATUS = GUICtrlRead($IP_USE)
	$DNS_AUTO_STATUS = GUICtrlRead($DNS_AUTO)
	$DNS_USE_STATUS = GUICtrlRead($DNS_USE)
	
	$IP_GET = _GUICtrlIPAddress_Get($IP_ADDRESS)
	$SUB_GET = _GUICtrlIPAddress_Get($SUBNET_MASK)
	$DEF_GET = _GUICtrlIPAddress_Get($DEFAULT_GATEWAY)
	$PREF_DNS_GET = _GUICtrlIPAddress_Get($PREFERRED_DNS)
	$ALT_DNS_GET = _GUICtrlIPAddress_Get($ALTERNATE_DNS)
	
		If $IP_AUTO_STATUS = $GUI_CHECKED Then
			ControlDisable("", "", $IP_ADDRESS)
			ControlDisable("", "", $SUBNET_MASK)
			ControlDisable("", "", $DEFAULT_GATEWAY)
			ControlEnable("", "", $DNS_AUTO)
		EndIf
		If $IP_USE_STATUS = $GUI_CHECKED Then
			ControlEnable("", "", $IP_ADDRESS)
			ControlEnable("", "", $SUBNET_MASK)
			ControlEnable("", "", $DEFAULT_GATEWAY)
			ControlDisable("", "", $DNS_AUTO)
			GUICtrlSetState($DNS_USE, $GUI_CHECKED)
			ControlEnable("", "", $PREFERRED_DNS)
			ControlEnable("", "", $ALTERNATE_DNS)
		EndIf
		If $DNS_AUTO_STATUS = $GUI_CHECKED Then
			ControlDisable("", "", $PREFERRED_DNS)
			ControlDisable("", "", $ALTERNATE_DNS)
		EndIf
		If $DNS_USE_STATUS = $GUI_CHECKED Then
			ControlEnable("", "", $PREFERRED_DNS)
			ControlEnable("", "", $ALTERNATE_DNS)
		EndIf
		
		Switch $msg
			Case $Presets
				ShowMenu($gui, $msg, $PresetsContext)
			Case $pNew
				NewPreset()
				;Prompt with combo of available adapter names - first item blank (include disabled adapters if possible)
				;Create a new blank preset (default name: preset '#' & with selected adapter name), the rest blank
			Case $pLoad
				;If 'changes have been made and not saved' Then
					;$LoadPrompt = MsgBox(4, "Exit..", "Changes have been made since the last save" & @CRLF & "Load new preset?")
					;If $LoadPrompt = 6 Then
						;Exit
					;EndIf
				;Else
					;Load 'Preset' ~ Set all fields
				;EndIf
			Case $pSave
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "Adapter", $aName)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "IPAddress", $IP_GET)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "SubnetMask", $SUB_GET)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "DefaultGateway", $DEF_GET)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "PreferredDNS", $PREF_DNS_GET)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "AlternateDNS", $ALT_DNS_GET)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "IP_AUTO_STATUS", $IP_AUTO_STATUS)
				IniWrite(@ScriptDir & "\LazyIP.inc", $pName, "IP_USE_STATUS", $IP_USE_STATUS)
				;Saves the current loaded preset properties
			Case $pSaveAs
				SaveAs()
			Case $pDelete
				DeletePreset()
			Case $bAdapterOptions
				AdapterOptions()
			Case $bAdvancedOptions
				;AdvancedOptions()
			Case $bApply
				;Apply()
				;~Check if ip fields in the preset are valid
				;If @error Then
					;$IP_FIELD_ERROR = MsgBox(0, "IP Apply Error", "'field' Error." & @CRLF & "The set ip fields range is not valid." & #CRLF & "Recheck all settings before trying again.")
				;Else *the rest below*
				;EndIf
				;~Check if current presets adapter exists
				If @error Then
					MsgBox(0, "Adapter Read Error", "The specified adapter '" & GUICtrlRead($aTitle) & "' could not be found." & @CRLF & "Please recheck all settings before retrying.")
				Else
					If $IP_AUTO_STATUS = $GUI_CHECKED Then
						Run('netsh interface ip set address name="' & $aName & '" source=dhcp', @SystemDir, @SW_HIDE)
						If $DNS_AUTO_STATUS = $GUI_CHECKED Then
							Run('Netsh interface ip set dns name="' & $aName & '" source=dhcp', @SystemDir, @SW_HIDE)
						Else
							If $PREF_GET = "0.0.0.0" Then
								Run('netsh interface ip set dns name="' & $aName & '" source=dhcp', @SystemDir, @SW_HIDE)
							Else
								Run('netsh interface ipv4 add dns "' & $aName & '" ' & $PREF_GET)
								Run('netsh interface ipv4 add dns "' & $aName & '" ' & $ALT_GET)
							EndIf
						EndIf
					Else
						If $IP_GET = "0.0.0.0" Then
							Run('netsh interface ip set address name="' & $aName & '" source=dhcp', @SystemDir, @SW_HIDE)
						Else
							Run('netsh interface ip set address name="' & Local Area Connection & '" source=static addr=' & $IP_GET & ' mask=' & $SUB_GET & ' gateway=' & $DEF_GET & ' gwmetric=1', @SystemDir, @SW_HIDE)
						EndIf
						If $PREF_GET = "0.0.0.0" Then
							Run('netsh interface ip set dns name="' & Local Area Connection & '" source=dhcp', @SystemDir, @SW_HIDE)
						Else
							Run('netsh interface ipv4 add dns "' & Local Area Connection '" ' & $PREF_GET)
							Run('netsh interface ipv4 add dns "' & Local Area Connection '" ' & $ALT_GET)
						EndIf
					EndIf
				EndIf
			Case $bApplyTo
				ApplyTo()
			Case $bNetworkConnections
				Run("RunDll32.exe shell32.dll,Control_RunDLL ncpa.cpl")
			Case $GUI_EVENT_MINIMIZE
				GUISetState(@SW_HIDE)
				TraySetState()
			Case $GUI_EVENT_CLOSE
				;If 'changes have been made to preset and not saved' Then
					;$ExitPrompt = MsgBox(4, "Exit..", "Changes have been made since the last save" & @CRLF & "Exit without saving?")
					;If $ExitPrompt = 6 Then
						;Exit
					;EndIf
				;Else
					Exit
				;EndIf
		EndSwitch
		$tMsg = TrayGetMsg()
		Switch $tMsg
			;Case (..One of the presets in $tPresets ~Menu)
				;check If adapter in preset exists
				;If @error Then
					;Error box
				;Else
					;Apply presets properties to adapter specified in preset
				;EndIf
			Case $tOptions
				AdapterOptions()
			Case $tAbout
				About()
			Case $TRAY_EVENT_PRIMARYUP
				GUISetState(@SW_SHOWNORMAL)
				WinActivate($gui)
				TraySetState(2)
			Case $tExit
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>Config

Func NewPreset()
	Local $NrInstalled, $NuInstalled, $NewInstalledStatus, $NewInstalledName, $UseInstalledStatus
	Local $NrCustom, $NaCustom, $NewCustomStatus, $NewCustomName, $NewCustomError, $NewCustomBlank
	Local $PresetName, $NewPresetName, $bCreate, $bCancel
	
	GUICreate("New Preset", 300, 185, -1, -1, $WS_CAPTION)
	
	GUICtrlCreateLabel("Preset:", 52, 15)
	$PresetName = GUICtrlCreateInput("", 90, 10, 150, 20)
	
	GUICtrlCreateGroup("Use adapter:", 15, 40, 270, 105)
	$NrInstalled = GUICtrlCreateRadio("Installed:", 25, 60)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$NaInstalled = GUICtrlCreateCombo("", 120, 60, 150, 20)
	GUICtrlSetData(-1, "1|2|3")		;< Testing purposes
	$NuInstalled = GUICtrlCreateCheckBox("Use adapter's current properties.", 50, 85)
	
	$NrCustom = GUICtrlCreateRadio("Custom:", 25, 115)
	$NaCustom = GUICtrlCreateInput("", 90, 115, 180, 20)

	$bCreate = GUICtrlCreateButton("Create", 165, 150, 55, 25)
	$bCancel = GUICtrlCreateButton("Cancel", 230, 150, 55, 25)
	
	GUISetState()
	
	While 1
	$msg = GUIGetMsg()
	
	$NewInstalledStatus = GUICtrlRead($NrInstalled)
	$UseInstalledStatus = GUICtrlRead($NuInstalled)
	$NewCustomStatus = GUICtrlRead($NrCustom)
	
	$NewInstalledName = GUICtrlRead($NaInstalled)
	$NewCustomName = GUICtrlRead($NaCustom)
	$NewPresetName = GUICtrlRead($PresetName)
			
		If $NewInstalledStatus = $GUI_CHECKED Then
			ControlEnable("", "", $NaInstalled)
			ControlEnable("", "", $NuInstalled)
			ControlDisable("", "", $NaCustom)
		EndIf
		If $NewCustomStatus = $GUI_CHECKED Then
			ControlEnable("", "", $NaCustom)
			ControlDisable("", "", $NaInstalled)
			ControlDisable("", "", $NuInstalled)
		EndIf
		
		Switch $msg
			Case $bCreate
				;>Section
				If $NewPresetName = "" Then
					IniWriteSection(@ScriptDir & "\LazyIP.inc", "Preset#") ;~
				Else
					IniWriteSection(@ScriptDir & "\LazyIP.inc", $NewPresetName)
				EndIf
				If $NewInstalledStatus = $GUI_CHECKED Then
					IniWrite(@ScriptDir & "\LazyIP.inc", "Adapter=", $NewInstalledName)
					;If $UseInstalledStatus = $GUI_CHECKED Then
						;>Get Adapter Info
						;Read $NewInstalledName adapters ip/dns fields
						;If the values are 0.0.0.0/DHCP Then > make a new If for IP/DNS - Then for each field if necessary
							;[GUISetState $IP_AUTO/$IP_USE/$DNS_AUTO/$DNS_USE]
						;Else
							;Create preset using $NewInstalledName with existing ip/dns fields from the selected adapter
						;EndIf
					;Else
						;Create preset using $NewInstalledName with blank fields
					;EndIf
				Else
					If $NewCustomName = "" Then
						$NewCustomBlank = MsgBox(4, "Custom Adapter Read Error", "No custom adapter was specified." & @CRLF & "Create the new preset anyway?")
						If $NewCustomBlank = 6 Then
							IniWriteSection(@ScriptDir & "\LazyIP.inc", "123");~Preset#
						EndIf
					Else
						;Check if $NewCustomName Exists
						If @error Then
							$NewCustomError = MsgBox(4, "Custom Adapter Read Error", "The specified custom adapter was not found." & @CRLF & "Create the new preset anyway?")
							If $NewCustomError = 6 Then
								IniWriteSection(@ScriptDir & "\LazyIP.inc", "123");~Preset#
							EndIf
						Else
							;Create preset using $NewCustomName with blank fields
						EndIf
					EndIf
				EndIf
			Case $bCancel
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func SaveAs() ; add checkbox
	Local $SaveName, $SaveAdapter, $bSave, $bCancel, $NewSaveName, $NewSaveAdapter, $NewAdapter
	Local $IP_AUTO_STATUS, $IP_USE_STATUS, $IP_GET, $SUB_GET, $DEF_GET
	Local $DNS_AUTO_STATUS, $DNS_USE_STATUS, $PREF_DNS_GET, $ALT_DNS_GET
	
	GUICreate("Save As..", 200, 150, -1, -1, $WS_CAPTION)
	
	GUICtrlCreateLabel("Preset Name:", 20, 15)
	$SaveName = GUICtrlCreateInput("", 20, 35, 160, 20)

	$NewAdapter = GUICtrlCreateCheckBox("Change Adapter:", 20, 65)
	$SaveAdapter = GUICtrlCreateCombo("~Leave blank for default~", 20, 90, 160, 20)
	
	$bSave = GUICtrlCreateButton("Save", 65, 115, 50, 25)
	$bCancel = GUICtrlCreateButton("Cancel", 125, 115, 55, 25)
	
	GUISetState()
	
	While 1
	$msg = GUIGetMsg()
	
	$NewSaveName = GUICtrlRead($SaveName)
	$NewSaveAdapter_STATUS = GUICtrlRead($NewAdapter)
	$NewSaveAdapter = GUICtrlRead($SaveAdapter)
	
	$IP_AUTO_STATUS = GUICtrlRead($IP_AUTO)
	$IP_USE_STATUS = GUICtrlRead($IP_USE)
	$DNS_AUTO_STATUS = GUICtrlRead($DNS_AUTO)
	$DNS_USE_STATUS = GUICtrlRead($DNS_USE)
	
	$IP_GET = _GUICtrlIPAddress_Get($IP_ADDRESS)
	$SUB_GET = _GUICtrlIPAddress_Get($SUBNET_MASK)
	$DEF_GET = _GUICtrlIPAddress_Get($DEFAULT_GATEWAY)
	$PREF_DNS_GET = _GUICtrlIPAddress_Get($PREFERRED_DNS)
	$ALT_DNS_GET = _GUICtrlIPAddress_Get($ALTERNATE_DNS)
	
	If $NewAdapter = $GUI_CHECKED Then
		ControlEnable($SaveAdapter)
		If $NewSaveAdapter = "" Then
			$NewSaveAdapter = $aName
		EndIf
	Else
		ControlDisable($SaveAdapter)
	EndIf
	
		Switch $msg
			Case $bSave
				IniReadSection(@Scriptdir & "\LazyIP.inc", $NewSaveName)
				If @error Then
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "Adapter", $NewSaveAdapter)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IPAddress", $IP_GET)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "SubnetMask", $SUB_GET)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "DefaultGateway", $DEF_GET)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "PreferredDNS", $PREF_DNS_GET)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "AlternateDNS", $ALT_DNS_GET)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IP_AUTO_STATUS", $IP_AUTO_STATUS)
					IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IP_USE_STATUS", $IP_USE_STATUS)
				Else
					$OverWrite = MsgBox(4, "Save prompt", "The preset name chosen already exists!" & @CRLF & "Would you like to overwrite the preset?")
					If $OverWrite = 6 Then
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "Adapter", $NewSaveAdapter)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IPAddress", $IP_GET)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "SubnetMask", $SUB_GET)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "DefaultGateway", $DEF_GET)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "PreferredDNS", $PREF_DNS_GET)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "AlternateDNS", $ALT_DNS_GET)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IP_AUTO_STATUS", $IP_AUTO_STATUS)
						IniWrite(@ScriptDir & "\LazyIP.inc", $NewSaveName, "IP_USE_STATUS", $IP_USE_STATUS)
					EndIf
				EndIf
			Case $bCancel
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func DeletePreset()
	Local $Prompt, $DeleteName, $DeletePreset
	Local $bDelete, $bCancel
	
	GUICreate("Delete Preset", 200, 105, -1, -1, $WS_CAPTION)
	
	GUICtrlCreateLabel("Select preset:", 20, 15)
	$DeleteName = GUICtrlCreateCombo("", 20, 35, 160, 20)
	
	$bDelete = GUICtrlCreateButton("Delete", 60, 65, 55, 25)
	$bCancel = GUICtrlCreateButton("Cancel", 125, 65, 55, 25)
	
	GUISetState()
	
	While 1
	$msg = GUIGetMsg()
	$DeletePreset = GUICtrlRead($DeleteName)
		Switch $msg
			Case $bDelete
				$Prompt = MsgBox(4, "Delete Preset", "Delete the following preset:" & @CRLF & $DeletePreset)
				If $Prompt = 6 Then
					IniDelete(@ScriptDir & "\LazyIP.inc", $DeletePreset)
				EndIf
			Case $bCancel
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func AdapterOptions()
	Local $rInstalled
	Local $rCustom, $aCustom
	Local $aEnable, $aDisable, $aReset
	Local $InstalledStatus, $InstalledName
	Local $CustomStatus, $CustomName
	Local $bCancel
	
	GUICreate("Adapter Options", 300, 135, -1, -1, $WS_CAPTION)

	GUICtrlCreateGroup("Use adapter:", 15, 10, 270, 85)
	$rInstalled = GUICtrlCreateRadio("Installed:", 25, 30)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$aInstalled = GUICtrlCreateCombo("", 120, 30, 150, 20)
	GUICtrlSetData(-1, "1|2|3")		;< Testing purposes
	$rCustom = GUICtrlCreateRadio("Custom:", 25, 60)
	$aCustom = GUICtrlCreateInput("", 90, 60, 180, 20)

	$aEnable = GUICtrlCreateButton("Enable", 20, 100, 50, 25)
	$aDisable = GUICtrlCreateButton("Disable", 80, 100, 55, 25)
	$aReset = GUICtrlCreateButton("Reset", 145, 100, 50, 25)
	$bCancel = GUICtrlCreateButton("Cancel", 230, 100, 55, 25)
	
	GUISetState()

	While 1
	$msg = GUIGetMsg()
	
	$InstalledStatus = GUICtrlRead($rInstalled)
	$CustomStatus = GUICtrlRead($rCustom)
		
	$InstalledName = GUICtrlRead($aInstalled)
	$CustomName = GUICtrlRead($aCustom)
		
		If $InstalledStatus = $GUI_CHECKED Then
			ControlEnable("", "", $aInstalled)
			ControlDisable("", "", $aCustom)
		EndIf
		If $CustomStatus = $GUI_CHECKED Then
			ControlEnable ("", "", $aCustom)
			ControlDisable("", "", $aInstalled)
		EndIf
		
		Switch $msg
			Case $aEnable
				If $InstalledStatus = $GUI_CHECKED Then
					RunWait(@ComSpec & ' /c netsh interface set interface "' & $InstalledName & '" Enabled', @SystemDir, @SW_HIDE)
					ProcessWaitClose("cmd.exe")
				Else
					;~Check if $CustomName Adapter exists
					If @error Then
						MsgBox(0, "Custom Adapter Read Error", "The adapter you specified was not found!" & @CRLF & "If the adapter does exist then you either don't have sufficient privileges or it is wrong.")
					Else
						RunWait(@ComSpec & ' /c netsh interface set interface "' & $CustomName & '" Enabled', @SystemDir, @SW_HIDE)
						ProcessWaitClose("cmd.exe")
					EndIf
				EndIf
			Case $aDisable
				If $InstalledStatus = $GUI_CHECKED Then
					RunWait(@ComSpec & ' /c netsh interface set interface "' & $InstalledName & '" Disabled', @SystemDir, @SW_HIDE)
					ProcessWaitClose("cmd.exe")
				Else
					;Check if $CustomName Adapter exists
					If @error Then
						MsgBox(0, "Custom Adapter Read Error", "The adapter you specified was not found!" & @CRLF & "If the adapter does exist then you either don't have sufficient privileges or it is wrong.")
					Else
						RunWait(@ComSpec & ' /c netsh interface set interface "' & $CustomName & '" Disabled', @SystemDir, @SW_HIDE)
						ProcessWaitClose("cmd.exe")
					EndIf
				EndIf
			Case $aReset
				If $InstalledStatus = $GUI_CHECKED Then
					RunWait(@ComSpec & ' /c ipconfig /renew "' & $InstalledName & '"', @SystemDir, @SW_HIDE)
					ProcessWaitClose("cmd.exe")
				Else
					;~Check if $CustomName Adapter exists
					If @error Then
						MsgBox(0, "Custom Adapter Read Error", "The adapter you specified was not found!" & @CRLF & "If the adapter does exist then you either don't have sufficient privileges or it is wrong.")
					Else
						RunWait(@ComSpec & ' /c ipconfig /renew "' & $CustomName & '"', @SystemDir, @SW_HIDE)
						ProcessWaitClose("cmd.exe")
					EndIf
				EndIf
			Case $bCancel
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>AdapterOptions

;Func AdvancedOptions()

	;$ADV_gui = GUICreate("Advanced Options", 100, 100, 400, 400)
	;GUISetState()
	
	;While 1
	;$msg = GUIGetMsg()
	
	;Switch $msg
	;	Case $GUI_EVENT_CLOSE
	;		GUIDelete($ADV_gui)
	;		GUISetState(@SW_HIDE, $ADV_gui)
	;		WinActivate($gui)
	;EndSwitch
	;WEnd
	
;EndFunc   ;==>AdvancedOptions

Func ApplyTo()
	Local $ToPreset, $ToAdapter, $ToRemove, $ToAdd
	Local $bApply, $bCancel
	
	GUICreate("Apply to...", 250, 225, -1, -1, $WS_CAPTION)
	
	GUICtrlCreateLabel("Preset:", 65, 15)
	$ToPreset = GUICtrlCreateCombo("", 110, 10, 120, 20)
	
	GUICtrlCreateGroup("", 10, 40, 230, 65)
	GUICtrlCreateLabel("Select Adapters:", 20, 40)
	$ToAdapter = GUICtrlCreateCombo("", 20, 65, 210, 20)
	GUICtrlCreateList("", 10, 120, 230, 80)
	GUICtrlSetData(-1, "1|2|3|4|5|6")
	$ToRemove = GUICtrlCreateButton("Remove", 120, 90, 55, 25)
	$ToAdd = GUICtrlCreateButton("Add", 185, 90, 40, 25)
	
	$bApply = GUICtrlCreateButton("Apply", 110, 195, 55, 25)
	$bCancel = GUICtrlCreateButton("Cancel", 175, 195, 55, 25)
	
	GUISetState()
	
	While 1
	$msg = GUIGetMsg()
		Switch $msg
			Case $bApply
				;Get selected preset values
				;Get available adapters (add/remove in list)
				;Apply values to selected adapters
			Case $bCancel
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func About()
	Local $gLink, $bOK, $cStartUp, $cStatus

	GUICreate("About", 210, 120, -1, -1, $WS_CAPTION)

	$gLink = GUICtrlCreateLabel("CC BY-NC-SA" & @CRLF & "katoNkatoNK.deviantart.com", 20, 27, 170, 35, $SS_CENTER)
	GUICtrlSetCursor(-1, 0)
	GUICtrlCreateGroup("", 17, 10, 176, 55)
	$cStartUp = GUICtrlCreateCheckbox("Add/Remove", 35, 84)
	GUICtrlCreateGroup("Run at Startup", 17, 70, 110, 40)
	$bOK = GUICtrlCreateButton("OK", 142, 80, 50, 26)

	GUISetState()

	While 1
	$msg = GUIGetMsg()
	$cStatus = GUICtrlRead($cStartUp)
		Switch $msg
			Case $gLink
				ShellExecute("                                 ")
			Case $bOK
				If $cStatus = $GUI_CHECKED Then
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "LazyIP", "REG_SZ", @ScriptDir & '\LazyIP.exe /minimized')
				EndIf
				If $cStatus = $GUI_UNCHECKED Then
					RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "LazyIP")
					If Not @error Then
						RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "LazyIP")
					EndIf
				EndIf
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>About

Func GetNetworkAdapterConfiguration()
EndFunc   ;==>GetNetworkAdapterConfiguration

Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $arPos, $x, $y
	Local $hMenu = GUICtrlGetHandle($nContextID)

	$arPos = ControlGetPos($hWnd, "", $CtrlID)

	$x = $arPos[0]
	$y = $arPos[1] + $arPos[3]

	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu

Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	$stPoint = 0
EndFunc   ;==>ClientToScreen

Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu