#cs
	Script Author: Peter Worden (Autoit Forum User: Sn3akyP3t3)
	Date: 2/24/2010
	Please make a small donation if you find this script useful.  If not then please send feedback, I'll appreciate either or both! :)
	Disclaimer: The Author of this script is not liable for anything! :)
	Please give credit to the author for parts of this script if used elsewhere!
	Note that any disabled GUI element is intentional since they are not yet functional.  I know there is a lot of documentation that should be here, but
	is not.  Feel free to make changes and post your changes so that others can benefit.  Now stop reading and get to work! :)
#ce
;#######################################################################################################
#RequireAdmin
#include <String.au3>
#include <Date.au3>
#include <IE.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiComboBox.au3>

;#################################################################
;############################ VARIABLES ##########################
;#################################################################
$sPuttyLogFileLocation = ""
$sTempPuttyFileLocation = @TempDir ;Temporary workaround since cannot open putty.log while putty is open.  Submitted error to forum on 2/22/2010.  http://www.autoitscript.com/forum/index.php?showtopic=110538
$sPuttyLogExists = "" ;bool for existance of log file or not
Global $arrNicIpAddresses[4] = [@IPAddress1, @IPAddress2, @IPAddress3, @IPAddress4]
$sHostNameFromSwitch = ""
$sLoginUsername = "" ;to login to switch
$sLoginUsernamePassword = "" ;to login to switch
$sLoginEnabledPassword = "" ;to login to switch enabled features
$sUpdateUsername = "" ;to update existing or non existing login username
$sUpdateUsernamePassword = "" ;to update the username password of switch if opted
$sUpdateEnabledPassword = "" ;to update enabled password of switch if opted
$intRebootMethod = ""
$sIpAddress = "" ;IP address of the current switch
$sRebootTime = "" ;time to schedule the reboot of the switch for changes to take place
$ipListFile = "" ;file handle for autoIt for file $sFileListOfIpAddresses
$bListEmpty = False ;flag to indicate the $ipListFile is empty to trigger exit of the main while loop
$intLineCountListIpAddresses = 0 ;first line in file is 1 so assign zero and it will be iterated with each call of function "readFromListOfIpAddresses()"
$sConfigFolderDirectory = "" ;directory to send config backups to
$bUpdateUsername = False ;flag to indicate intentions to update username and/or username password
$bUpdateEnabledPassword = False ;flag to indicate the intentions to update the enabled password
Global $arrIpAddresses = "" ;array of ip addresses of switches to manage in the session
Global $arrIncorrectPassword[4] = ["", "", "", ""] ;array of flags to indicate password is incorrect for $ConfigSwitches, indicated by red, [0] = PW, [1] = Alt. PW, [2] = En PW, [3] = Alt. En PW
Global $arrIncorrectPassword2[3] = ["", "", ""] ;array of flags to indicate username or password incorrect for $ConfigSwitchesPassword, indicated by red, [0] = Username, [1] = Username PW, [2] = Enable PW
$bIncorrectPassword = False
$intPuttyMode = "" ;0=SSH, 1=Telnet
#Region ### START Koda GUI section ### Form=y:\scripting\koda_1.7.2.0\forms\configswitches.kxf
$ConfigSwitches = GUICreate("ConfigSwitches", 840, 663, 200, 36)
$LabelUsername = GUICtrlCreateLabel("Username", 16, 8, 52, 17)
$LabelAlternateUsername = GUICtrlCreateLabel("Alt Username", 16, 56, 67, 17)
$InputUsername = GUICtrlCreateInput("", 8, 24, 121, 21)
$LabelPassword = GUICtrlCreateLabel("Password", 152, 8, 50, 17)
$LabelAltPassword = GUICtrlCreateLabel("Alt Password", 152, 56, 65, 17)
$InputPassword = GUICtrlCreateInput("", 144, 24, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
$InputRepeatPassword = GUICtrlCreateInput("", 288, 24, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
$InputAltUsername = GUICtrlCreateInput("", 8, 72, 121, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputAltPassword = GUICtrlCreateInput("", 144, 72, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputRepeatAltPassword = GUICtrlCreateInput("", 288, 72, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputEnablePassword = GUICtrlCreateInput("", 144, 128, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
$InputRepeatEnablePassword = GUICtrlCreateInput("", 288, 128, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
$InputAltEnablePassword = GUICtrlCreateInput("", 144, 176, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputRepeatAltEnablePassword = GUICtrlCreateInput("", 288, 176, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$EditIpAddresses = GUICtrlCreateEdit("", 8, 224, 321, 145)
GUICtrlSetData(-1, "")
$LabelConfigEdit = GUICtrlCreateLabel("Config Edit(s)", 112, 376, 83, 17)
$EditConfigEdit = GUICtrlCreateEdit("", 8, 400, 313, 217)
GUICtrlSetData(-1, StringFormat("conf t\r\nend"))
$LabelHistoryLog = GUICtrlCreateLabel("History Log", 536, 208, 57, 17)
$EditHistoryLog = GUICtrlCreateEdit("", 352, 224, 473, 393, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetData(-1, "")
GUICtrlSetBkColor(-1, 0xffffff)
$CheckboxBackupConfig = GUICtrlCreateCheckbox("Backup config before changes", 440, 24, 169, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$CheckboxReload = GUICtrlCreateCheckbox("Immediate or Scheduled Reload", 440, 56, 177, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$ComboReloadHour = GUICtrlCreateCombo("", 616, 56, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
$ComboReloadMinute = GUICtrlCreateCombo("", 712, 56, 57, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "")
$RadioReloadImmediate = GUICtrlCreateRadio("Immediately", 496, 80, 113, 17)
$RadioReloadScheduled = GUICtrlCreateRadio("Scheduled", 616, 80, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$LabelIpAddresses = GUICtrlCreateLabel("IP Addresses of Switches (one per line)", 80, 208, 204, 17)
$CheckboxNtpServer = GUICtrlCreateCheckbox("Set NTP server", 440, 104, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$InputNtpServer = GUICtrlCreateInput("10.10.10.10", 536, 104, 89, 21)
$CheckboxUseAlts = GUICtrlCreateCheckbox("Attempt use of alt username or password", 440, 136, 217, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$CheckboxChangeUsernameOrPassword = GUICtrlCreateCheckbox("Change username, username pwd, and/or enable pwd", 440, 168, 281, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$ButtonGo = GUICtrlCreateButton("Make it so!", 728, 632, 75, 25, $WS_GROUP)
$RadioTelnet = GUICtrlCreateRadio("Try Telnet First", 16, 112, 97, 17)
$RadioSsh = GUICtrlCreateRadio("Try SSH first", 16, 152, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$LabelEnablePassword = GUICtrlCreateLabel("Enable Password", 152, 104, 86, 17)
$LabelEnableAltPassword = GUICtrlCreateLabel("Alt Enable Password", 152, 152, 101, 17)
$LabelTftpServer = GUICtrlCreateLabel("TFTP server", 632, 0, 63, 17)
$LabelReloadHour = GUICtrlCreateLabel("Hour", 640, 40, 41, 17)
$LabelReloadMinute = GUICtrlCreateLabel(": Minute", 712, 40, 42, 17)
$LabelPasswordRepeat = GUICtrlCreateLabel("Repeat Password", 296, 8, 88, 17)
$LabelRepeatAltPassword = GUICtrlCreateLabel("Repeat Alt Password", 296, 56, 103, 17)
$LabelRepeatEnablePassword = GUICtrlCreateLabel("Repeat Enable Pwd.", 296, 104, 102, 17)
$LabelRepeatAltEnablePassword = GUICtrlCreateLabel("Repeat Alt Enable Pwd.", 296, 152, 117, 17)
$ComboTftpServer = GUICtrlCreateCombo("", 616, 16, 145, 25)
$LabelDonate = GUICtrlCreateLabel("Feed the author if found useful.",16, 632, 180, 25)
GUICtrlSetColor($LabelDonate, 0x0000ff)
GUISetState(@SW_SHOW, $ConfigSwitches)
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=y:\scripting\koda_1.7.2.0\forms\configswitchespassword.kxf
$ConfigSwitchesPassword = GUICreate("Change Username &&|| Password", 434, 208, 302, 218)
$InputConfigPwdUsername = GUICtrlCreateInput("", 16, 24, 177, 21)
$InputConfigPwdRepeatUsername = GUICtrlCreateInput("", 216, 24, 177, 21)
$LabelConfigPwdUsernamePassword = GUICtrlCreateLabel("New Username Password", 24, 48, 126, 17)
$LabelConfigPwdRepeatUsernamePassword = GUICtrlCreateLabel("Repeat New Username Password", 224, 48, 164, 17)
$InputConfigPwdUsernamePassword = GUICtrlCreateInput("", 16, 64, 177, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
$InputConfigPwdRepeatUsernamePassword = GUICtrlCreateInput("", 216, 64, 177, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
$LabelConfigPwdUsername = GUICtrlCreateLabel("New Username", 24, 8, 77, 17)
$Label2 = GUICtrlCreateLabel("Repeat New Username", 224, 8, 115, 17)
$InputConfigPwdEnablePassword = GUICtrlCreateInput("", 16, 104, 177, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
$LabelConfigPwdEnablePassword = GUICtrlCreateLabel("New Enable Password", 24, 88, 111, 17)
$LabelConfigPwdRepeatEnablePassword = GUICtrlCreateLabel("Repeat New Enable Password", 224, 88, 149, 17)
$InputConfigPwdRepeatEnablePassword = GUICtrlCreateInput("", 216, 104, 177, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
$CheckboxConfigPwdUsernamePassword = GUICtrlCreateCheckbox("Change Username Password", 16, 152, 161, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$CheckboxConfigPwdEnablePassword = GUICtrlCreateCheckbox("Change Enable Password", 184, 152, 145, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$CheckboxConfigPwdUsername = GUICtrlCreateCheckbox("Change Username", 16, 128, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$ButtonConfigPwdChange = GUICtrlCreateButton("Change Password", 296, 176, 99, 25, $WS_GROUP)
$ButtonConfigPwdCancel = GUICtrlCreateButton("Cancel", 16, 176, 75, 25, $WS_GROUP)
#EndRegion ### END Koda GUI section ###
;#################################################################
;############################  MAIN  #############################
;#################################################################
verifyPrerequisits()
;populate hour, minute, and tftp addresses of $comboboxes
populateComboBoxes()
;loop will exit when function "readFromListOfIpAddresses()" finds eof
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $ButtonGo
			postNotification("", 1, 0, 0)
			If BitAND(GUICtrlRead($CheckboxUseAlts), $GUI_CHECKED) = $GUI_CHECKED Then
				For $element In $arrIncorrectPassword
					If $element Then
						postNotification("Password mismatch.  Correct text in red.", 1, 0, 0)
						GUICtrlSetColor($EditHistoryLog, 0xff0000)
						$bIncorrectPassword = True
						ExitLoop
					Else
						$bIncorrectPassword = False
					EndIf
				Next
			Else
				If $arrIncorrectPassword[0] Or $arrIncorrectPassword[2] Then
					postNotification("Password mismatch.  Correct text in red.", 1, 0, 0)
					GUICtrlSetColor($EditHistoryLog, 0xff0000)
					$bIncorrectPassword = True
				EndIf
			EndIf
			If Not performIdiotChecks() And Not $bIncorrectPassword Then
				GUICtrlSetColor($EditHistoryLog, 0x000000)
				GUICtrlSetState($ButtonGo, $GUI_DISABLE)
				gatherInformationAndPrepare()
				main()
				postNotification("Completed all requested switch configurations.", 1, 0, 1)
				GUICtrlSetState($ButtonGo, $GUI_ENABLE)
			EndIf
		Case $CheckboxBackupConfig
			If BitAND(GUICtrlRead($CheckboxBackupConfig), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($ComboTftpServer, $GUI_ENABLE)
			Else
				GUICtrlSetState($ComboTftpServer, $GUI_DISABLE)
			EndIf
		Case $CheckboxNtpServer
			If BitAND(GUICtrlRead($CheckboxNtpServer), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($InputNtpServer, $GUI_ENABLE)
			Else
				GUICtrlSetState($InputNtpServer, $GUI_DISABLE)
			EndIf
		Case $CheckboxUseAlts
			If BitAND(GUICtrlRead($CheckboxUseAlts), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($InputAltEnablePassword, $GUI_ENABLE)
				GUICtrlSetState($InputAltPassword, $GUI_ENABLE)
				GUICtrlSetState($InputAltUsername, $GUI_ENABLE)
				GUICtrlSetState($InputAltEnablePassword, $GUI_ENABLE)
				GUICtrlSetState($InputRepeatAltPassword, $GUI_ENABLE)
				GUICtrlSetState($InputRepeatAltEnablePassword, $GUI_ENABLE)
			Else
				GUICtrlSetState($InputAltEnablePassword, $GUI_DISABLE)
				GUICtrlSetState($InputAltPassword, $GUI_DISABLE)
				GUICtrlSetState($InputAltUsername, $GUI_DISABLE)
				GUICtrlSetState($InputAltEnablePassword, $GUI_DISABLE)
				GUICtrlSetState($InputRepeatAltPassword, $GUI_DISABLE)
				GUICtrlSetState($InputRepeatAltEnablePassword, $GUI_DISABLE)
			EndIf
		Case $CheckboxReload
			If BitAND(GUICtrlRead($CheckboxReload), $GUI_CHECKED) = $GUI_CHECKED And BitAND(GUICtrlRead($RadioReloadScheduled), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($ComboReloadHour, $GUI_ENABLE)
				GUICtrlSetState($ComboReloadMinute, $GUI_ENABLE)
				GUICtrlSetState($RadioReloadImmediate, $GUI_ENABLE)
				GUICtrlSetState($RadioReloadScheduled, $GUI_ENABLE)
			ElseIf BitAND(GUICtrlRead($CheckboxReload), $GUI_CHECKED) = $GUI_CHECKED And Not BitAND(GUICtrlRead($RadioReloadScheduled), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($RadioReloadImmediate, $GUI_ENABLE)
				GUICtrlSetState($RadioReloadScheduled, $GUI_ENABLE)
			Else
				GUICtrlSetState($ComboReloadHour, $GUI_DISABLE)
				GUICtrlSetState($ComboReloadMinute, $GUI_DISABLE)
				GUICtrlSetState($RadioReloadImmediate, $GUI_DISABLE)
				GUICtrlSetState($RadioReloadScheduled, $GUI_DISABLE)
			EndIf
		Case $RadioReloadImmediate
			GUICtrlSetState($ComboReloadHour, $GUI_DISABLE)
			GUICtrlSetState($ComboReloadMinute, $GUI_DISABLE)
		Case $RadioReloadScheduled
			GUICtrlSetState($ComboReloadHour, $GUI_ENABLE)
			GUICtrlSetState($ComboReloadMinute, $GUI_ENABLE)
		Case $InputPassword
			If StringCompare(GUICtrlRead($InputPassword), GUICtrlRead($InputRepeatPassword)) <> 0 Then
				GUICtrlSetColor($InputPassword, 0xff0000)
				GUICtrlSetColor($InputRepeatPassword, 0xff0000)
				$arrIncorrectPassword[0] = True
			Else
				GUICtrlSetColor($InputPassword, 0x000000)
				GUICtrlSetColor($InputRepeatPassword, 0x000000)
				$arrIncorrectPassword[0] = False
			EndIf
		Case $InputRepeatPassword
			If StringCompare(GUICtrlRead($InputPassword), GUICtrlRead($InputRepeatPassword)) <> 0 Then
				GUICtrlSetColor($InputPassword, 0xff0000)
				GUICtrlSetColor($InputRepeatPassword, 0xff0000)
				$arrIncorrectPassword[0] = True
			Else
				GUICtrlSetColor($InputPassword, 0x000000)
				GUICtrlSetColor($InputRepeatPassword, 0x000000)
				$arrIncorrectPassword[0] = False
			EndIf
		Case $InputAltPassword
			If StringCompare(GUICtrlRead($InputAltPassword), GUICtrlRead($InputRepeatAltPassword)) <> 0 Then
				GUICtrlSetColor($InputAltPassword, 0xff0000)
				GUICtrlSetColor($InputRepeatAltPassword, 0xff0000)
				$arrIncorrectPassword[1] = True
			Else
				GUICtrlSetColor($InputAltPassword, 0x000000)
				GUICtrlSetColor($InputRepeatAltPassword, 0x000000)
				$arrIncorrectPassword[1] = False
			EndIf
		Case $InputRepeatAltPassword
			If StringCompare(GUICtrlRead($InputAltPassword), GUICtrlRead($InputRepeatAltPassword)) <> 0 Then
				GUICtrlSetColor($InputAltPassword, 0xff0000)
				GUICtrlSetColor($InputRepeatAltPassword, 0xff0000)
				$arrIncorrectPassword[1] = True
			Else
				GUICtrlSetColor($InputAltPassword, 0x000000)
				GUICtrlSetColor($InputRepeatAltPassword, 0x000000)
				$arrIncorrectPassword[1] = False
			EndIf
		Case $InputEnablePassword
			If StringCompare(GUICtrlRead($InputEnablePassword), GUICtrlRead($InputRepeatEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputEnablePassword, 0xff0000)
				GUICtrlSetColor($InputRepeatEnablePassword, 0xff0000)
				$arrIncorrectPassword[2] = True
			Else
				GUICtrlSetColor($InputEnablePassword, 0x000000)
				GUICtrlSetColor($InputRepeatEnablePassword, 0x000000)
				$arrIncorrectPassword[2] = False
			EndIf
		Case $InputRepeatEnablePassword
			If StringCompare(GUICtrlRead($InputEnablePassword), GUICtrlRead($InputRepeatEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputEnablePassword, 0xff0000)
				GUICtrlSetColor($InputRepeatEnablePassword, 0xff0000)
				$arrIncorrectPassword[2] = True
			Else
				GUICtrlSetColor($InputEnablePassword, 0x000000)
				GUICtrlSetColor($InputRepeatEnablePassword, 0x000000)
				$arrIncorrectPassword[2] = False
			EndIf
		Case $InputAltEnablePassword
			If StringCompare(GUICtrlRead($InputAltEnablePassword), GUICtrlRead($InputRepeatAltEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputAltEnablePassword, 0xff0000)
				GUICtrlSetColor($InputRepeatAltEnablePassword, 0xff0000)
				$arrIncorrectPassword[3] = True
			Else
				GUICtrlSetColor($InputAltEnablePassword, 0x000000)
				GUICtrlSetColor($InputRepeatAltEnablePassword, 0x000000)
				$arrIncorrectPassword[3] = False
			EndIf
		Case $InputRepeatAltEnablePassword
			If StringCompare(GUICtrlRead($InputAltEnablePassword), GUICtrlRead($InputRepeatAltEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputAltEnablePassword, 0xff0000)
				GUICtrlSetColor($InputRepeatAltEnablePassword, 0xff0000)
				$arrIncorrectPassword[3] = True
			Else
				GUICtrlSetColor($InputAltEnablePassword, 0x000000)
				GUICtrlSetColor($InputRepeatAltEnablePassword, 0x000000)
				$arrIncorrectPassword[3] = False
			EndIf
		Case $CheckboxChangeUsernameOrPassword
			If BitAND(GUICtrlRead($CheckboxChangeUsernameOrPassword), $GUI_CHECKED) = $GUI_CHECKED Then
				Sleep(500)
				GUISetState(@SW_HIDE, $ConfigSwitches)
				GUISetState(@SW_SHOW, $ConfigSwitchesPassword)
			Else
				GUISetState(@SW_HIDE, $ConfigSwitchesPassword)
				GUISetState(@SW_SHOW, $ConfigSwitches)
			EndIf
		Case $EditConfigEdit
			;ensure that the edit box starts with "conf t" and ends with "end"
			;removed from script for the time being to allow for non-config commands to be run
		Case $LabelDonate
			ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=J79FJJEHD7ZNC&lc=US&item_name=Sn3akyP3t3%20Productions&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted")

		Case $GUI_EVENT_CLOSE
			Exit
			;change username password
		Case $InputConfigPwdUsername
			If StringCompare(GUICtrlRead($InputConfigPwdUsername), GUICtrlRead($InputConfigPwdRepeatUsername)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdUsername, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatUsername, 0xff0000)
				$arrIncorrectPassword2[0] = True
			Else
				GUICtrlSetColor($InputConfigPwdUsername, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatUsername, 0x000000)
				$arrIncorrectPassword2[0] = False
			EndIf
		Case $InputConfigPwdRepeatUsername
			If StringCompare(GUICtrlRead($InputConfigPwdUsername), GUICtrlRead($InputConfigPwdRepeatUsername)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdUsername, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatUsername, 0xff0000)
				$arrIncorrectPassword2[0] = True
			Else
				GUICtrlSetColor($InputConfigPwdUsername, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatUsername, 0x000000)
				$arrIncorrectPassword2[0] = False
			EndIf
		Case $InputConfigPwdUsernamePassword
			If StringCompare(GUICtrlRead($InputConfigPwdUsernamePassword), GUICtrlRead($InputConfigPwdRepeatUsernamePassword)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdUsernamePassword, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatUsernamePassword, 0xff0000)
				$arrIncorrectPassword2[1] = True
			Else
				GUICtrlSetColor($InputConfigPwdUsernamePassword, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatUsernamePassword, 0x000000)
				$arrIncorrectPassword2[1] = False
			EndIf
		Case $InputConfigPwdRepeatUsernamePassword
			If StringCompare(GUICtrlRead($InputConfigPwdUsernamePassword), GUICtrlRead($InputConfigPwdRepeatUsernamePassword)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdUsernamePassword, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatUsernamePassword, 0xff0000)
				$arrIncorrectPassword2[1] = True
			Else
				GUICtrlSetColor($InputConfigPwdUsernamePassword, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatUsernamePassword, 0x000000)
				$arrIncorrectPassword2[1] = False
			EndIf
		Case $InputConfigPwdEnablePassword
			If StringCompare(GUICtrlRead($InputConfigPwdEnablePassword), GUICtrlRead($InputConfigPwdRepeatEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdEnablePassword, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatEnablePassword, 0xff0000)
				$arrIncorrectPassword2[2] = True
			Else
				GUICtrlSetColor($InputConfigPwdEnablePassword, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatEnablePassword, 0x000000)
				$arrIncorrectPassword2[2] = False
			EndIf
		Case $InputConfigPwdRepeatEnablePassword
			If StringCompare(GUICtrlRead($InputConfigPwdEnablePassword), GUICtrlRead($InputConfigPwdRepeatEnablePassword)) <> 0 Then
				GUICtrlSetColor($InputConfigPwdEnablePassword, 0xff0000)
				GUICtrlSetColor($InputConfigPwdRepeatEnablePassword, 0xff0000)
				$arrIncorrectPassword2[2] = True
			Else
				GUICtrlSetColor($InputConfigPwdEnablePassword, 0x000000)
				GUICtrlSetColor($InputConfigPwdRepeatEnablePassword, 0x000000)
				$arrIncorrectPassword2[2] = False
			EndIf
		Case $CheckboxConfigPwdUsername
			If BitAND(GUICtrlRead($CheckboxConfigPwdUsername), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($InputConfigPwdUsername, $GUI_ENABLE)
				GUICtrlSetState($InputConfigPwdRepeatUsername, $GUI_ENABLE)
			Else
				GUICtrlSetState($InputConfigPwdUsername, $GUI_DISABLE)
				GUICtrlSetState($InputConfigPwdRepeatUsername, $GUI_DISABLE)
			EndIf
		Case $CheckboxConfigPwdUsernamePassword
			If BitAND(GUICtrlRead($CheckboxConfigPwdUsernamePassword), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($InputConfigPwdUsernamePassword, $GUI_ENABLE)
				GUICtrlSetState($InputConfigPwdRepeatUsernamePassword, $GUI_ENABLE)
			Else
				GUICtrlSetState($InputConfigPwdUsernamePassword, $GUI_DISABLE)
				GUICtrlSetState($InputConfigPwdRepeatUsernamePassword, $GUI_DISABLE)
			EndIf
		Case $CheckboxConfigPwdEnablePassword
			If BitAND(GUICtrlRead($CheckboxConfigPwdEnablePassword), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($InputConfigPwdEnablePassword, $GUI_ENABLE)
				GUICtrlSetState($InputConfigPwdRepeatEnablePassword, $GUI_ENABLE)
			Else
				GUICtrlSetState($InputConfigPwdEnablePassword, $GUI_DISABLE)
				GUICtrlSetState($InputConfigPwdRepeatEnablePassword, $GUI_DISABLE)
			EndIf
		Case $ButtonConfigPwdCancel
			GUICtrlSetState($CheckboxChangeUsernameOrPassword, $GUI_UNCHECKED)
			GUISetState(@SW_HIDE, $ConfigSwitchesPassword)
			GUISetState(@SW_SHOW, $ConfigSwitches)
		Case $ButtonConfigPwdChange
			;verify passwords correct
			If BitAND(GUICtrlRead($CheckboxConfigPwdUsername), $GUI_CHECKED) = $GUI_CHECKED Then
				If $arrIncorrectPassword2[0] Then
					MsgBox(48, "", "Password mismatch.  Correct text in red.")
					$bIncorrectPassword = True
				Else
					$bIncorrectPassword = False
				EndIf
			ElseIf BitAND(GUICtrlRead($CheckboxConfigPwdUsernamePassword), $GUI_CHECKED) = $GUI_CHECKED Then
				If $arrIncorrectPassword2[1] Then
					MsgBox(48, "", "Password mismatch.  Correct text in red.")
					$bIncorrectPassword = True
				Else
					$bIncorrectPassword = False
				EndIf
			ElseIf BitAND(GUICtrlRead($CheckboxConfigPwdEnablePassword), $GUI_CHECKED) = $GUI_CHECKED Then
				If $arrIncorrectPassword2[2] Then
					MsgBox(48, "", "Password mismatch.  Correct text in red.")
					$bIncorrectPassword = True
				Else
					$bIncorrectPassword = False
				EndIf
			EndIf
			If Not $bIncorrectPassword Then
				GUISetState(@SW_HIDE, $ConfigSwitchesPassword)
				GUISetState(@SW_SHOW, $ConfigSwitches)
			EndIf
	EndSwitch
WEnd
;############################################################################
;###########################  FUNCTIONS  ####################################
;############################################################################
Func main()
	Local $bLoginSuccessful
	generateListOfIpAddressesToManageAndOpenFile()
	For $z = 1 To $arrIpAddresses[0]
		$bLoginSuccessful = False
		$sIpAddress = $arrIpAddresses[$z]
		postNotification("Start Time: " & _Now() & @CRLF & "IP: " & $sIpAddress, 1, 0, 1)
		$intCounter = 1
		While Not ipAddressAlive()
			$intCounter += 1
			;attempt 10 times to check switch alive then move on to next switch
			If $intCounter == 10 Then
				postNotification("Switch at ip address " & $sIpAddress & " was skipped because it would not respond to " & $intCounter & " attemps.", 1, 1, 1)
				ExitLoop
			EndIf
		WEnd
		If BitAND(GUICtrlRead($RadioSsh), $GUI_CHECKED) = $GUI_CHECKED Then
			startPuttySsh()
			postNotification("Putty mode: SSH", 1, 0, 1)
			$intPuttyMode = 0
		Else
			startPuttyTelnet()
			postNotification("Putty mode: Telnet", 1, 0, 1)
			$intPuttyMode = 1
		EndIf
		$bLoginSuccessful = loginSwitch($intPuttyMode)
		If Not $bLoginSuccessful Then
			If BitAND(GUICtrlRead($RadioSsh), $GUI_CHECKED) = $GUI_CHECKED Then
				startPuttyTelnet()
				postNotification("Putty mode: Telnet, 2nd attempt", 1, 0, 1)
				$intPuttyMode = 1
			Else
				startPuttySsh()
				postNotification("Putty mode: SSH, 2nd attempt", 1, 0, 1)
				$intPuttyMode = 0
			EndIf
			$bLoginSuccessful = loginSwitch($intPuttyMode)
			If Not $bLoginSuccessful Then
				postNotification("Unable to login to switch", 1, 0, 1)
			EndIf
		EndIf
		If $bLoginSuccessful Then
			If BitAND(GUICtrlRead($CheckboxBackupConfig), $GUI_CHECKED) = $GUI_CHECKED Then BackupConfig()
			If BitAND(GUICtrlRead($CheckboxNtpServer), $GUI_CHECKED) = $GUI_CHECKED Then timeSyncronization()
			If BitAND(GUICtrlRead($CheckboxReload), $GUI_CHECKED) = $GUI_CHECKED And BitAND(GUICtrlRead($RadioReloadScheduled), $GUI_CHECKED) = $GUI_CHECKED Then scheduleReloadTime()
			editConfig()
			copyRunStart()
			If BitAND(GUICtrlRead($CheckboxReload), $GUI_CHECKED) = $GUI_CHECKED And BitAND(GUICtrlRead($RadioReloadImmediate), $GUI_CHECKED) = $GUI_CHECKED Then immediateReload()
			closePutty()
		EndIf
		postNotification("End Time: " & _Now(), 1, 0, 1)
	Next
EndFunc   ;==>main

Func verifyPrerequisits()
	;tfpt32 checks
	If Not FileExists(@ProgramFilesDir & "\Tftpd32\tftpd32.exe") Then
		postNotification("This script requires use of Tftpd32.exe.  A browser will now open to the appropriate download location.  Please install and try again.", 1, 1, 1)
		$oIE = _IECreate()
		_IENavigate($oIE, "http://tftpd32.jounin.net/tftpd32_download.html")
		Exit
	EndIf
	;putty checks
	If Not FileExists(@ProgramFilesDir & "\PuTTY\putty.exe") Then
		$oIE = _IECreate()
		postNotification("This script requires use of Putty.exe.  A browser will now open to the appropriate download location.  Please install and try again.", 1, 1, 1)
		_IENavigate($oIE, "http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html")
		Exit
	EndIf
EndFunc   ;==>verifyPrerequisits

Func gatherInformationAndPrepare()
	;set config folder directory
	$sConfigFolderDirectory = @ScriptDir & "\ConfigBackups" & @MON & "-" & @MDAY & "-" & @YEAR
	$sPuttyLogFileLocation = $sConfigFolderDirectory & "\ConfigLogs"
	$sPuttyLogExists = FileExists($sPuttyLogFileLocation)
	;create directory on desktop to save config backups and logs to
	If Not FileExists($sConfigFolderDirectory) Then DirCreate($sConfigFolderDirectory)
	If Not FileExists($sConfigFolderDirectory & "\ConfigLogs") Then DirCreate($sConfigFolderDirectory & "\ConfigLogs")
	If BitAND(GUICtrlRead($CheckboxBackupConfig), $GUI_CHECKED) = $GUI_CHECKED Then
		If StringCompare(GUICtrlRead($CheckboxBackupConfig), "") == 0 Then
			postNotification("TFTP blank not allowed!", 1, 0, 0)
			Return False
		EndIf
	EndIf
	manageTftpServer()
EndFunc   ;==>gatherInformationAndPrepare

;allows user to specify file to open containing list of IP addresses to change configs to.  If file does not exist then will create one and warn user to
;populate the list before opening it.
Func generateListOfIpAddressesToManageAndOpenFile()
	Local $arrTextFileSearch, $sTempIpAddressList
	If StringCompare(GUICtrlRead($EditIpAddresses), "") == 0 Then
		;if edit empty then file must be specified to open
		While 1
			;The flag to create file "SwitchIpAddressList.txt" if it does not exist does not seem to function properly.  Therefore, a method has been added
			;after the call of FileOpenDialog() to create the file, open it, and request addresses to be appended.
			$sFileListOfIpAddresses = FileOpenDialog("IP Address List.  If none exists then create one and populate it.", @DesktopDir, _
					"text(*.txt)|data(*.dat)|log(*.log)", 8, "SwitchIpAddressList.txt")
			If @error = 1 Then
				MsgBox(0, "Error", "Cancel button is not allowed!")
			Else
				ExitLoop
			EndIf
		WEnd
		$arrTextFileSearch = StringSplit($sFileListOfIpAddresses, "\")
		For $element In $arrTextFileSearch
			If StringInStr($element, ".txt") Then
				$sFileListOfIpAddressesText = $element
			EndIf
		Next
		While 1;exit conditions are: txt file exists and txt file not empty
			If Not FileExists($sFileListOfIpAddresses) Then
				$ipListFile = FileOpen($sFileListOfIpAddresses, 2)
				FileClose($ipListFile)
				Run("notepad.exe """ & $sFileListOfIpAddresses & """")
				WinWait($sFileListOfIpAddressesText & " - Notepad")
			Else
				Sleep(500)
				While WinExists($sFileListOfIpAddressesText & " - Notepad")
					TrayTip("Notepad Open", """" & $sFileListOfIpAddressesText & " - Notepad"" file is open.  Please populate it with IP addresses, one per line.", 60)
					Sleep(500)
				WEnd
				TrayTip("", "", 0)
			EndIf
			If FileGetSize($sFileListOfIpAddresses) == 0 And Not WinExists($sFileListOfIpAddressesText & " - Notepad") Then
				TrayTip($sFileListOfIpAddressesText & " empty", "Please provide one or more ip addresses!", 20)
				Run("notepad.exe """ & $sFileListOfIpAddresses & """")
				Sleep(5000)
			Else
				If FileGetSize($sFileListOfIpAddresses) <> 0 And Not WinExists($sFileListOfIpAddressesText & " - Notepad") Then ExitLoop
			EndIf
		WEnd
		;read contents of text file
		$sTempIpAddressList = FileRead($sFileListOfIpAddresses)
	Else
		$sTempIpAddressList = GUICtrlRead($EditIpAddresses)
	EndIf
	$arrIpAddresses = StringSplit($sTempIpAddressList, Chr(10))
	For $i = 1 To $arrIpAddresses[0]
		$arrIpAddresses[$i] = StringStripWS(StringStripCR($arrIpAddresses[$i]), 8)
	Next
EndFunc   ;==>generateListOfIpAddressesToManageAndOpenFile

Func startPuttyTelnet()
	Run("C:\Program Files\PuTTY\putty.exe")
	WinWait("PuTTY Configuration")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	Send($sIpAddress) ;port 23 automatically selected
	Send("!t") ;select Telnet
	Send("+{TAB 3}")
	Sleep(250)
	Send("{DOWN}") ;enter logging options window
	ControlSend("PuTTY Configuration", "Log &file name:", "Edit1", "{DEL 10}")
	;ControlSetText("PuTTY Configuration", "Log &file name:", "Edit1", $sPuttyLogFileLocation & "\Putty.log") ;disabled for workaround
	ControlSetText("PuTTY Configuration", "Log &file name:", "Edit1", $sTempPuttyFileLocation & "\Putty.log")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	;select printable output
	Send("!p")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	;select always overwrite existing log
	Send("!e{UP 3}")
	;delete existing logfile to prevent handling leftover logfile from previous sessions masking problems
	If FileExists($sPuttyLogFileLocation & "\Putty.log") Then
		FileDelete($sPuttyLogFileLocation & "\Putty.log")
		FileDelete($sTempPuttyFileLocation & "\Putty.log") ;temporary workaround
	EndIf
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	ControlClick("PuTTY Configuration", "&Open", "Button1")
EndFunc   ;==>startPuttyTelnet

Func startPuttySsh()
	Run("C:\Program Files\PuTTY\putty.exe")
	WinWait("PuTTY Configuration")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	Send($sIpAddress) ;port 22 automatically selected
	Send("!s") ;select SSh
	Send("+{TAB 3}")
	Sleep(250)
	Send("{DOWN}") ;enter logging options window
	ControlSend("PuTTY Configuration", "Log &file name:", "Edit1", "{DEL 10}")
	;ControlSetText("PuTTY Configuration", "Log &file name:", "Edit1", $sPuttyLogFileLocation & "\Putty.log") ;disabled for workaround
	ControlSetText("PuTTY Configuration", "Log &file name:", "Edit1", $sTempPuttyFileLocation & "\Putty.log")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	;select printable output
	Send("!p")
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	;select always overwrite existing log
	Send("!e{UP 3}")
	;delete existing logfile to prevent handling leftover logfile from previous sessions masking problems
	If FileExists($sPuttyLogFileLocation & "\Putty.log") Then
		FileDelete($sPuttyLogFileLocation & "\Putty.log")
		FileDelete($sTempPuttyFileLocation & "\Putty.log") ;temporary workaround
	EndIf
	If Not WinActive("PuTTY Configuration") Then WinActivate("PuTTY Configuration")
	WinWaitActive("PuTTY Configuration")
	ControlClick("PuTTY Configuration", "&Open", "Button1")
	If WinWait("PuTTY Security Alert", "The server's host key is not cached", 5) Then
		If Not WinActive("PuTTY Security Alert") Then WinActivate("PuTTY Security Alert")
		WinWaitActive("PuTTY Security Alert")
		ControlClick("PuTTY Security Alert", "&Yes", "Button1")
	EndIf
EndFunc   ;==>startPuttySsh

Func loginSwitch($puttyMode)
	Local $sTempMode = ""
	If $puttyMode Then
		$sTempMode = "Telnet"
	Else
		$sTempMode = "SSH"
	EndIf
	If Not WinWait($sIpAddress & " - PuTTY", "", 5) Then
		If Not ProcessExists("putty.exe") Then
			postNotification("Putty was unexpectidly terminated!  Perhaps " & $sTempMode & " is not enabled.", 1, 0, 1)
			Return False
		EndIf
	EndIf
	$intCounter = 0
	While Not FileExists($sTempPuttyFileLocation & "\Putty.log")
		TrayTip("", "Waiting for network connection timeout", 2)
		If WinWait("PuTTY Fatal Error", "Network error: Connection refused", 1) Then
			If Not WinActive("PuTTY Fatal Error") Then WinActivate("PuTTY Fatal Error")
			WinWaitActive("PuTTY Fatal Error")
			ControlClick("PuTTY Fatal Error", "OK", "Button1")
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY", "", 1)
			WinClose($sIpAddress & " - PuTTY")
			If Not WinActive("PuTTY (inactive)") Then WinActivate("PuTTY (inactive)")
			WinWaitActive("PuTTY (inactive)", "", 1)
			WinClose("PuTTY (inactive)")
			Return False
		EndIf
		$intCounter += 1
		If $intCounter == 15 Then
			postNotification("Putty.log was not created.  Assumed error connecting with terminal.", 1, 0, 1)
			Return False
		EndIf
	WEnd
	If $puttyMode Then
		$intCounter = 1
		$intDownCounter = 6
		$bUsernameRequired = True
		;only press enter key maximum of two times, otherwise if username is not required the telnet prompt will be forced closed
		While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Username")
			TrayTip("Login", "Waiting for username prompt.  If not prompted in " & $intDownCounter & " seconds it will be assumed that username is not required.", 1)
			Sleep(1000)
			If $intCounter == 3 Then
				If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
				WinWaitActive($sIpAddress & " - PuTTY")
				Send("{ENTER}")
			EndIf
			$intCounter += 1
			$intDownCounter -= 1
			If $intCounter == 7 Then
				;skip username requirement
				$bUsernameRequired = False
				ExitLoop
			EndIf
		WEnd
	Else
		$bUsernameRequired = True ;always the case for SSH
		While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "login as:")
			;verify mode ssh or telnet accepted
			If WinExists("PuTTY Fatal Error", "Network error: Connection refused") Then
				If Not WinActive("PuTTY Fatal Error") Then WinActivate("PuTTY Fatal Error")
				WinWaitActive("PuTTY Fatal Error")
				ControlClick("PuTTY Fatal Error", "OK", "Button1")
				If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
				WinWaitActive($sIpAddress & " - PuTTY", "", 1)
				WinClose($sIpAddress & " - PuTTY")
				If Not WinActive("PuTTY (inactive)") Then WinActivate("PuTTY (inactive)")
				WinWaitActive("PuTTY (inactive)", "", 1)
				WinClose("PuTTY (inactive)")
				Return False
			EndIf
		WEnd
	EndIf
	TrayTip("", "", 0)
	If $bUsernameRequired == True Then
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send(GUICtrlRead($InputUsername), 1)
		Sleep(300)
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("{Enter}")
		Sleep(300)
	EndIf
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "password:")
		Sleep(250)
	WEnd
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send(GUICtrlRead($InputPassword), 1)
	Sleep(300)
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("{Enter}")
	Sleep(300)
	If $puttyMode Then ;SSH has enable by default
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("en{Enter}")
		Sleep(300)
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send(GUICtrlRead($InputEnablePassword), 1)
		Sleep(300)
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("{Enter}")
		Sleep(300)
	EndIf
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "#")
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Access denied") Then
			closePutty()
			postNotification("Username or password incorrect for " & $sTempMode & ".", 1, 0, 1)
			Return False
		EndIf
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Login invalid") Then
			closePutty()
			postNotification("Username or password incorrect for " & $sTempMode & ".", 1, 0, 1)
			Return False
		EndIf
		Sleep(250)
	WEnd
	Return True
EndFunc   ;==>loginSwitch

Func closePutty()
	If WinClose($sIpAddress & " - PuTTY") Then
		If WinWait("PuTTY Exit Confirmation", "OK", 4) Then
			If Not WinActive("PuTTY Exit Confirmation") Then WinActivate("PuTTY Exit Confirmation")
			WinWaitActive("PuTTY Exit Confirmation")
			ControlClick("PuTTY Exit Confirmation", "OK", 1)
			$intCounter = 1
			While ProcessExists("putty.exe")
				Sleep(500)
				$intCounter += 1
				If $intCounter == 40 Then
					postNotification("Putty.exe is taking an excessive amount of time to close.", 1, 1, 1)
					$intCounter = 1
				EndIf
			WEnd
		EndIf
		;allows Putty.log to have all data from terminal transferred in
		Sleep(1000)
		;update master log file before delete or overwrite
		manageFullMasterLogFile()
	EndIf
EndFunc   ;==>closePutty

Func copyRunStart()
	;save changes and reload switch
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("wr mem{ENTER}")
	;examine log file for end of save == [OK] to continue
	$bEndFlag = False
	$intCounter = 1
	While Not $bEndFlag
		TrayTip("Parsing log file", "Looking for [OK] value in log file to continue", 15)
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "[OK]") Then
			$bEndFlag = True
			TrayTip("", "", 0)
		EndIf
		Sleep(500)
		$intCounter += 1
		If $intCounter == 50 Then
			;corrective action to take if the switch is not responding to the terminal.
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("{ENTER}")
		EndIf
	WEnd
EndFunc   ;==>copyRunStart

Func ipAddressAlive()
	$bIpAddressAlive = False
	TrayTip("Ping test switch for response", "Pinging " & $sIpAddress, 10)
	RunWait(@ComSpec & " /c " & @SystemDir & "\ping.exe " & $sIpAddress & '>"%userprofile%\Desktop\pingResults.log"', @SystemDir, @SW_HIDE)
	Sleep(500)
	;parse pingResults.log for not 100% loss
	If FileExists(@DesktopDir & "\pingResults.log") Then
		$ipPingFile = FileOpen(@DesktopDir & "\pingResults.log", 0)

		If $ipPingFile == -1 Then
			;message to master log file with error
			postNotification("pingResults.log file was not available to parse.", 1, 1, 1)
		Else
			While 1
				$line = FileReadLine($ipPingFile)
				If @error == -1 Then ExitLoop
				If StringInStr($line, "Request timed out") Or StringInStr($line, "Destination host unreachable") Then
					$bIpAddressAlive = False
					ExitLoop
				Else
					If StringInStr($line, "Reply from " & $sIpAddress) Then $bIpAddressAlive = True
				EndIf
			WEnd
		EndIf
		FileClose($ipPingFile)
		Sleep(500)
		If FileExists(@DesktopDir & "\pingResults.log") Then FileDelete(@DesktopDir & "\pingResults.log")
	EndIf
	Return $bIpAddressAlive
EndFunc   ;==>ipAddressAlive

Func BackupConfig()
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("sh run | include hostname", 1)
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("{ENTER}")
	While getHostName() == ""
		Sleep(500)
	WEnd
	postNotification("Hostname: " & $sHostNameFromSwitch, 1, 0, 1)
	;backup performed only if file already not backed up
	If Not FileExists($sConfigFolderDirectory & "\config" & $sHostNameFromSwitch & "_" & $sIpAddress & ".text") Then
		;save copy of config to local flash directory on switch
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("copy flash:config.text flash:config.text.old.bak{ENTER}")
		;confirmation
		While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Destination filename [config.text.old.bak]")
			Sleep(500)
		WEnd
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("{ENTER}")
		$intCounter = 0
		While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "%Warning:There is a file already existing")
			Sleep(500)
			$intCounter += 1
			If $intCounter >= 8 Then ExitLoop
		WEnd
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "%Warning:There is a file already existing") Then
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("{ENTER}")
		EndIf
		;wait for end of save
		While parseLogFileDoubleKeyword("Destination filename", $sHostNameFromSwitch & "#")
			Sleep(500)
		WEnd
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("#copy run tftp://" & GUICtrlRead($ComboTftpServer) & "{ENTER}")
		Sleep(500)
		;Adress or name of remote host question already filled.
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("{ENTER}")
		;destination filename?
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("config" & $sHostNameFromSwitch & "_" & $sIpAddress & ".text{ENTER}")
		$intCounter = 0
		While parseLogFileDoubleKeyword("config" & $sHostNameFromSwitch & "_" & $sIpAddress & ".text", "bytes copied")
			;hold progress until file copied
			Sleep(200)
			$intCounter += 1
			If $intCounter >= 30 Then ExitLoop
		WEnd
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Error opening tftp:") Or Not FileExists($sConfigFolderDirectory & "\config" & $sHostNameFromSwitch & "_" & $sIpAddress & ".text") Then
			postNotification("Error opening tftp connection.  Backup not performed!", 1, 0, 1)
		Else
			postNotification("Backup completed to file: config" & $sHostNameFromSwitch & "_" & $sIpAddress & ".text", 1, 0, 1)
		EndIf
	Else
		postNotification("This config was already backed up.  Delete the backup manually if desired then retry.", 1, 0, 1)
	EndIf
EndFunc   ;==>BackupConfig

Func parseLogFileSingleKeyword($sFileToSearch, $sKeyword)
	Local $bReturnFlag = False
	FileCopy($sTempPuttyFileLocation & "\Putty.log", $sPuttyLogFileLocation & "\Putty.log", 1) ;workaround
	;analyze logfile created to parse for single keyword
	$logfile = FileOpen(String($sFileToSearch), 0)
	; Check if file opened for reading OK
	If $logfile = -1 Then
		postNotification("Unable to open " & $sFileToSearch & " for single keyword parse.", 1, 1, 1)
		MsgBox(48, "Error", "Unable to open " & $sFileToSearch & " for single keyword parse.")
		Exit
	EndIf
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($logfile)
		If @error = -1 Then ExitLoop
		If StringInStr($line, $sKeyword) Then
			;switch is responding
			$bReturnFlag = True
		EndIf
	WEnd;end reading file
	FileClose($logfile)
	Sleep(2000) ;release resources
	Return $bReturnFlag
EndFunc   ;==>parseLogFileSingleKeyword

; The purpose of this function is to analyze for keyword one and set the flag to true if found
; the remainder of the file will be parsed in search for keyword two which will set the flag
; back to false if found.  This will be more accurate in some situations for example: where an
; error was found and corrective action is already in progress.
Func parseLogFileDoubleKeyword($sKeyword1, $sKeyword2)
	$bReturnFlag = False
	Sleep(800) ;ensure resources released and give time for logfile to contain data searching for
	;analyze logfile created to parse for double keyword
	FileCopy($sTempPuttyFileLocation & "\Putty.log", $sPuttyLogFileLocation & "\Putty.log", 1)
	$file = FileOpen($sPuttyLogFileLocation & "\Putty.log", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(48, "Error", "Unable to open Putty.log for double word parse.")
		Exit
	EndIf
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If StringInStr($line, $sKeyword1) Then
			; keyword1 found
			$bReturnFlag = True
		EndIf
		If StringInStr($line, $sKeyword2) Then
			; keyword2 found and keyword1 flag raised now lowered
			$bReturnFlag = False
		EndIf
	WEnd;end reading file
	FileClose($file)
	Sleep(200) ;release resources
	Return $bReturnFlag
EndFunc   ;==>parseLogFileDoubleKeyword

Func getHostName()
	$sHostNameFromSwitch = ""
	;analyze logfile created to to get Version info and SW version info
	FileCopy($sTempPuttyFileLocation & "\Putty.log", $sPuttyLogFileLocation & "\Putty.log", 1)
	$file = FileOpen($sPuttyLogFileLocation & "\Putty.log", 0)
	; Check if file opened for reading OK
	If $file = -1 Then Exit
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		$sKeyword = "hostname"
		$line = StringStripWS($line, 8)
		If StringInStr($line, $sKeyword) And Not StringInStr($line, "shrun") Then
			$sHostNameFromSwitch = StringReplace($line, $sKeyword, "")
		EndIf
	WEnd
	FileClose($file)
	Sleep(200) ;release resources
	Return $sHostNameFromSwitch
EndFunc   ;==>getHostName

Func manageFullMasterLogFile()
	;if the master log file doesn't exist then create it
	$sMasterLogFile = FileOpen($sPuttyLogFileLocation & "\MasterFullConfigLog.log", 1) ;in append mode, will create file if not exists
	;take the contents of each logfile created by putty and append it to the master log file for review if necessary
	FileCopy($sTempPuttyFileLocation & "\Putty.log", $sPuttyLogFileLocation & "\Putty.log", 1)
	$file = FileOpen($sPuttyLogFileLocation & "\Putty.log", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		postNotification("Unable to open Putty.log for operations with file in the manageMasterLogFile() function.", 1, 1, 1)
		Exit
	EndIf
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		FileWriteLine($sMasterLogFile, $line)
	WEnd
	FileClose($file)
	FileClose($sMasterLogFile)
EndFunc   ;==>manageFullMasterLogFile

;The purpose of this function is to track operations performed on switches in a quick summary rather than actual logs from the terminal.
;Items to log: time config manipulated, switch hostname, switch ip address,
Func manageSummaryMasterLogFile($sLine)
	;if the log file doesn't exist then it will be created.
	$sMasterLogFile = FileOpen($sPuttyLogFileLocation & "\MasterSummarizedConfigLog.log", 1) ;in append mode
	If $sMasterLogFile == -1 Then
		MsgBox(48, "Error", "Unable to open master log file to write error message.")
		Exit
	EndIf
	FileWriteLine($sMasterLogFile, $sLine)
	FileClose($sMasterLogFile)
EndFunc   ;==>manageSummaryMasterLogFile

Func writeErrorMessageToLog($sErrorMessage)
	;if the master log file doesn't exist then create it
	$sMasterLogFile = FileOpen($sPuttyLogFileLocation & "\MasterFullConfigLog.log", 1) ;in append mode, will create file if not exists
	; Check if file opened for reading OK
	If $sMasterLogFile == -1 Then
		MsgBox(48, "Error", "Unable to open master log file to write error message.")
		Exit
	EndIf
	FileWriteLine($sMasterLogFile, "Time of error: " & _Now() & @CRLF & " " & $sErrorMessage)
	FileClose($sMasterLogFile)
EndFunc   ;==>writeErrorMessageToLog

Func scheduleReloadTime()
	$sRebootTime = StringFormat("%02s", _GUICtrlComboBox_GetCurSel($ComboReloadHour)) & ":" & StringFormat("%02s", _GUICtrlComboBox_GetCurSel($ComboReloadMinute))
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("reload at " & $sRebootTime & "{ENTER}")
	$intCounter = 0
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "System configuration has been modified") Or parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Proceed with reload")
		Sleep(500)
		$intCounter += 1
		If $intCounter >= 10 Then ExitLoop
		;parse for "The date and time must be set first"
		If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "The date and time must be set first") Then
			$intMonth = Int(@MON)
			$sMonth = ""
			Switch $intMonth
				Case 1
					$sMonth = "January"
				Case 2
					$sMonth = "Febuary"
				Case 3
					$sMonth = "March"
				Case 4
					$sMonth = "April"
				Case 5
					$sMonth = "May"
				Case 6
					$sMonth = "June"
				Case 7
					$sMonth = "July"
				Case 8
					$sMonth = "August"
				Case 9
					$sMonth = "September"
				Case 10
					$sMonth = "October"
				Case 11
					$sMonth = "November"
				Case 12
					$sMonth = "December"
			EndSwitch
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("clock set " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MDAY & " " & $sMonth & " " & @YEAR & "{ENTER}")
			Sleep(500)
			;call the reload command again after clock set
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("reload at " & $sRebootTime & "{ENTER}")
		EndIf
	WEnd
	If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "System configuration has been modified") Then
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("y{ENTER}")
	EndIf
	$intCounter = 0
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Proceed with reload")
		Sleep(500)
		$intCounter += 1
		If $intCounter >= 8 Then ExitLoop
	WEnd
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("{ENTER}")
	postNotification("Reboot Method: Scheduled" & "Reboot Time: " & $sRebootTime, 1, 0, 1)
EndFunc   ;==>scheduleReloadTime

Func immediateReload()
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("reload{ENTER}")
	If parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "System configuration has been modified") Then
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("y{ENTER}")
	EndIf
	$intCounter = 0
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "Proceed with reload")
		Sleep(500)
		$intCounter += 1
		If $intCounter >= 8 Then ExitLoop
	WEnd
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("{ENTER}")
	postNotification("Reboot Method: Immediate", 1, 0, 1)
EndFunc   ;==>immediateReload

;checks for instances of incorrect time ntp server and removes them.  Also points to correct time server @ 199.17.208.79
Func timeSyncronization()
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("sh run | include ntp{ENTER}")
	;wait for log file to contain data needed. Exit loop if no ntp servers are pointed to
	$intCounter = 0
	While Not parseLogFileSingleKeyword($sPuttyLogFileLocation & "\Putty.log", "ntp server")
		Sleep(500)
		$intCounter += 1
		If $intCounter == 20 Then
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("{ENTER}")
		EndIf
		If $intCounter == 30 Then ExitLoop
	WEnd
	;search for lines containing incorrect ntp server and remove them
	FileCopy($sTempPuttyFileLocation & "\Putty.log", $sPuttyLogFileLocation & "\Putty.log", 1)
	$file = FileOpen($sPuttyLogFileLocation & "\Putty.log", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		postNotification("Unable to open Putty.log for timeSyncronization().", 1, 1, 1)
		MsgBox(48, "Error", "Unable to open Putty.log for timeSyncronization().")
		Exit
	EndIf
	$sKeyword = "ntp server "
	$bFoundKeyword = False
	;enter config only once
	If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
	WinWaitActive($sIpAddress & " - PuTTY")
	Send("conf t{ENTER}")
	Sleep(500)
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		;identify the line(s) containing faulty ip addresses
		If StringInStr($line, $sKeyword) And Not StringInStr($line, GUICtrlRead($InputNtpServer)) And Not StringInStr($line, "no ntp server") Then
			$line = StringReplace($line, $sKeyword, "")
			If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
			WinWaitActive($sIpAddress & " - PuTTY")
			Send("no ntp server " & $line & "{ENTER}")
			Sleep(500)
			postNotification("Incorrect ntp server deleted: " & $line, 1, 0, 1)
		EndIf
		If StringInStr($line, GUICtrlRead($InputNtpServer)) Then $bFoundKeyword = True
	WEnd;end reading file
	If $bFoundKeyword == True Then
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("end{ENTER}")
		Sleep(500)
	Else
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("ntp server " & GUICtrlRead($InputNtpServer) & "{ENTER}")
		Sleep(500)
		Send("end{ENTER}")
		Sleep(500)
		postNotification("Added ntp server: " & GUICtrlRead($InputNtpServer), 1, 0, 1)
	EndIf
	FileClose($file)
	Sleep(500) ;release resources
EndFunc   ;==>timeSyncronization

Func manageTftpServer()
	Local $sCurrentSelection = ""
	If Not ProcessExists("tftpdp32.exe") Then
		;startup tftp server application
		;note that the tfpt server file location and server are required to be set by the user before running the application
		Run(@ProgramFilesDir & "\Tftpd32\tftpd32.exe")
		WinWait("Tftpd32 by Ph. Jounin")
	EndIf
	While 1
		$intOccurance = ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox1", "FindString", GUICtrlRead($ComboTftpServer))
		ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox1", "SetCurrentSelection", $intOccurance)
		$sCurrentSelection = ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox1", "GetCurrentSelection", "")
		If StringCompare(ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox1", "GetCurrentSelection", GUICtrlRead($ComboTftpServer)), GUICtrlRead($ComboTftpServer)) == 0 Then
			ExitLoop
		Else
			TrayTip('', 'Tftpd32 "Server Interface" is currently set for ' & $sCurrentSelection & '. Please point to point to ' & GUICtrlRead($ComboTftpServer), 2)
			Sleep(1000)
		EndIf
	WEnd
	While 1
		If Not WinActive("Tftpd32 by Ph. Jounin") Then WinActivate("Tftpd32 by Ph. Jounin")
		WinWaitActive("Tftpd32 by Ph. Jounin")
		$intOccurance = ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox2", "FindString", $sConfigFolderDirectory)
		ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox2", "SetCurrentSelection", $intOccurance)
		If StringCompare(ControlCommand("Tftpd32 by Ph. Jounin", "", "ComboBox2", "GetCurrentSelection", $sConfigFolderDirectory), $sConfigFolderDirectory) == 0 Then
			ExitLoop
		Else
			TrayTip('', 'The TFTP "Current Directory" is incorrect.  Browse to correct directory "' & $sConfigFolderDirectory & '" to continue.', 2)
			Sleep(1000)
		EndIf
	WEnd
	postNotification("Backups and logs will be saved to " & $sConfigFolderDirectory, 1, 0, 0)
	TrayTip("", "", 0)
	WinSetState("Tftpd32 by Ph. Jounin", "", @SW_MINIMIZE)
EndFunc   ;==>manageTftpServer

Func editConfig()
	Local $arrConfigEdit
	$arrConfigEdit = StringSplit(GUICtrlRead($EditConfigEdit), Chr(10))
	For $i = 1 To $arrConfigEdit[0]
		$arrConfigEdit[$i] = StringStripCR($arrConfigEdit[$i])
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send($arrConfigEdit[$i], 1)
		If Not WinActive($sIpAddress & " - PuTTY") Then WinActivate($sIpAddress & " - PuTTY")
		WinWaitActive($sIpAddress & " - PuTTY")
		Send("{ENTER}")
		Sleep(250)
	Next
	Sleep(1000)
EndFunc   ;==>editConfig

Func logEditConfig()
	Local $arrConfigEdit
	$arrConfigEdit = StringSplit(GUICtrlRead($EditConfigEdit), Chr(10))
	postNotification("List of config changes requested: ", 1, 0, 1)
	For $i = 1 To $arrConfigEdit[0]
		$arrConfigEdit[$i] = StringStripCR($arrConfigEdit[$i])
		postNotification($arrConfigEdit[$i], 1, 0, 1)
	Next
EndFunc   ;==>logEditConfig

Func populateComboBoxes()
	Local $12Hour, $ampm
	;hour and minute
	For $i = 0 To 23
		If $i == 0 Then
			$12Hour = 12
			$ampm = "AM"
			GUICtrlSetData($ComboReloadHour, StringFormat("%02s", $i) & "  (" & $12Hour & " " & $ampm & ")", StringFormat("%02s", $i) & "  (" & $12Hour & " " & $ampm & ")")
		ElseIf $i > 12 Then
			$12Hour = $i - 12
			$ampm = "PM"
		ElseIf $i == 12 Then
			$12Hour = $i
			$ampm = "PM"
		Else
			$12Hour = $i
			$ampm = "AM"
		EndIf
		GUICtrlSetData($ComboReloadHour, StringFormat("%02s", $i) & "  (" & $12Hour & " " & $ampm & ")")
	Next
	For $i = 0 To 59
		If $i == 0 Then
			GUICtrlSetData($ComboReloadMinute, StringFormat("%02s", $i), StringFormat("%02s", $i))
		EndIf
		GUICtrlSetData($ComboReloadMinute, StringFormat("%02s", $i))
	Next
	;tftp
	For $element In $arrNicIpAddresses
		Local $sTemp, $arrAddressTemp
		$sTemp = $element
		$arrAddressTemp = StringSplit($element, ".")
		If StringCompare($element, "0.0.0.0") <> 0 And StringCompare($element, "127.0.0.1") <> 0 And StringCompare($arrAddressTemp[1], "5") <> 0 Then
			GUICtrlSetData($ComboTftpServer, $element, $element)
		EndIf
	Next
EndFunc   ;==>populateComboBoxes

Func postNotification($sPostString, $bHistoryLog, $bErrorLog, $bSummaryLog)
	If $bHistoryLog Then
		Local $intMaxCharacters, $arrString, $intTotalCharacters, $intTempCharacterCounter, $intCharacterStart ;max characters per a line
		$intMaxCharacters = 74
		$intTotalCharacters = StringLen($sPostString)
		$arrString = StringSplit($sPostString, ' ')
		If $arrString[0] == 1 And @error == 1 Then
			;no spaces found, insert @crlf every $intMaxCharacters
			For $i = 0 To Int($intTotalCharacters / $intMaxCharacters)
				GUICtrlSetData($EditHistoryLog, StringMid($sPostString, ($intMaxCharacters * $i) + 1, $intMaxCharacters) & @CRLF, "append")
			Next
			If $intTotalCharacters == 0 Then
				GUICtrlSetData($EditHistoryLog, "")
			EndIf
		Else
			$intTempCharacterCounter = 0
			For $j = 1 To $arrString[0]
				If $j > 1 Then GUICtrlSetData($EditHistoryLog, ' ', "append")
				$intCharacterStart = 0
				If StringLen($arrString[$j]) > $intMaxCharacters Then
					For $x = 0 To Int(StringLen($arrString[$j]) / $intMaxCharacters)
						If $x = 0 Then
							GUICtrlSetData($EditHistoryLog, StringMid($arrString[$j], $intCharacterStart + 1, $intMaxCharacters - $intTempCharacterCounter) & @CRLF, "append")
						ElseIf $x > 0 And $x < Int(StringLen($arrString[$j]) / $intMaxCharacters) - 1 Then
							GUICtrlSetData($EditHistoryLog, StringMid($arrString[$j], $intCharacterStart + 1, $intMaxCharacters) & @CRLF, "append")
						Else
							GUICtrlSetData($EditHistoryLog, StringMid($arrString[$j], $intCharacterStart + 1, $intMaxCharacters), "append")
							$intTempCharacterCounter = StringLen(StringMid($arrString[$j], $intCharacterStart + 1, $intMaxCharacters))
						EndIf
						$intCharacterStart += $intMaxCharacters - $intTempCharacterCounter
					Next
				ElseIf $intTempCharacterCounter + StringLen($arrString[$j]) <= $intMaxCharacters Then
					$intTempCharacterCounter += StringLen($arrString[$j])
					GUICtrlSetData($EditHistoryLog, $arrString[$j], "append")
				Else
					$intTempCharacterCounter = StringLen($arrString[$j])
					$intTempCharacterCounter = StringLen($arrString[$j])
					GUICtrlSetData($EditHistoryLog, @CRLF & $arrString[$j], "append")
				EndIf
			Next
		EndIf
		GUICtrlSetData($EditHistoryLog, @CRLF, "append")
	EndIf
	If $bErrorLog Then writeErrorMessageToLog("Time of error: " & _Now() & @CRLF & " " & $sPostString)
	If $bSummaryLog Then manageSummaryMasterLogFile($sPostString)
EndFunc   ;==>postNotification

Func performIdiotChecks()
	Local $bIdiot = False
	If StringLen(GUICtrlRead($InputUsername)) == 0 Then
		postNotification("Intentional blank username not allowed.", 1, 0, 0)
		GUICtrlSetColor($EditHistoryLog, 0xff0000)
		$bIdiot = True
	EndIf
	If StringLen(GUICtrlRead($InputPassword)) == 0 Then
		postNotification("Blank password field not allowed.", 1, 0, 0)
		GUICtrlSetColor($EditHistoryLog, 0xff0000)
		$bIdiot = True
	EndIf
	If StringLen(GUICtrlRead($InputEnablePassword)) == 0 Then
		postNotification("Blank enable password field not allowed.  Regardless if in SSH mode or not.", 1, 0, 0)
		GUICtrlSetColor($EditHistoryLog, 0xff0000)
		$bIdiot = True
	EndIf
	Return $bIdiot
EndFunc   ;==>performIdiotChecks
