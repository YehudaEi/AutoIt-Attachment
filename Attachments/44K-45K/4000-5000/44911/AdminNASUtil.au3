#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=AdminNASUtility2.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
AutoItSetOption("MustDeclareVars", 1)
Global $iIPAddress, $iIPO1 = 10, $iIPO2, $iIPO3, $iIPO4 = 230, $sFilePath
EmbedCreatePuttyDirectoryFile()
;CreatePuttyDir_CopyPutty()
EmbedRobocopyFile()

#include <File.au3>
#include <WinAPI.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=C:\Users\mender\Downloads\Scripts\AutoIT\GUI\AdminNAS\NAS2.kxf
Global $hCEDForm = GUICreate("Admin NAS Utility", 397, 394, 242, 160)
GUISetBkColor(0xA6CAF0)
Global $hLabelPCNum = GUICtrlCreateLabel("PC Number", 72, 11, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE))
Global $hPCNumInput = GUICtrlCreateInput("", 32, 11, 31, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 4)
Global $hInputIPAddressListFile = GUICtrlCreateInput("", 32, 48, 200, 21)
Global $hButtonGetIPAddressList = GUICtrlCreateButton("Set IP Address List", 240, 48, 130, 25)
Global $hCheckBoxUseIPAddressListFile = GUICtrlCreateCheckbox("Use IP Address List File", 240, 76, 131, 25)

Global $hLabelOldFirmware = GUICtrlCreateLabel("Old Firmware", 32, 106, 131, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE))
Global $hButtonOldCheckHardDrive = GUICtrlCreateButton("Check Hard Drive", 32, 140, 131, 25)
Global $hButtonOldSystem = GUICtrlCreateButton("System", 32, 175, 131, 25)
Global $hButtonOldEnableRootAccess = GUICtrlCreateButton("Enable Root Access", 32, 210, 131, 25)
Global $hButtonOldUpgradeFirmware = GUICtrlCreateButton("Upgrade Firmware", 32, 245, 131, 25)

Global $hLabelNewFirmware = GUICtrlCreateLabel("New Firmware", 182, 106, 131, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE))
Global $hButtonNewCheckHardDrive = GUICtrlCreateButton("Check Hard Drive", 184, 140, 131, 25)
Global $hButtonNewSystem = GUICtrlCreateButton("System", 184, 175, 131, 25)
Global $hButtonNewEnableRootAccess = GUICtrlCreateButton("Enable Root Access", 184, 210, 131, 25)
Global $hButtonNewUpgradeFirmware = GUICtrlCreateButton("Upgrade Firmware", 184, 245, 131, 25)

Global $hLabelOtherTools = GUICtrlCreateLabel("Other Tools", 112, 279, 131, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE))
Global $hButtonCopyConfigFilesToShare = GUICtrlCreateButton("Copy Config Files To Share", 32, 312, 155, 25)
Global $hButtonCopyConfigFilesFromShare = GUICtrlCreateButton("Copy Config Files From Share", 32, 352, 155, 25)
Global $hButtonPingAdminNAS = GUICtrlCreateButton("Ping Admin NAS", 208, 312, 131, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


GUICtrlSetData($hInputIPAddressListFile, StringRegExpReplace(IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", ""), "^.+(.\\)", ""))
While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hButtonOldCheckHardDrive
			OldCheckHardDrive()
		Case $hButtonOldSystem
			OldSystem()
		Case $hButtonOldUpgradeFirmware
			OldUpdateFirmware()
		Case $hButtonOldEnableRootAccess
			OldEnableRootAccess()
		Case $hButtonNewCheckHardDrive
			NewCheckHardDrive()
		Case $hButtonNewSystem
			NewSystem()
		Case $hButtonNewUpgradeFirmware
			NewUpdateFirmware()
		Case $hButtonNewEnableRootAccess
			NewEnableRootAccess()
		Case $hButtonCopyConfigFilesToShare
			CopyConfigFilesToShare()
		Case $hButtonCopyConfigFilesFromShare
			CopyConfigFilesFromShare()
		Case $hButtonPingAdminNAS
			PingAdminNAS()
		Case $hButtonGetIPAddressList
			GetFile()
			Local $sWriteIPAddressFilePath = IniWrite(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", $sFilePath)
			GUICtrlSetData($hInputIPAddressListFile, StringRegExpReplace(IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", ""), "^.+(.\\)", ""))
	EndSwitch

	Local $aCursorInfo = GUIGetCursorInfo($hCEDForm)
	If $aCursorInfo[2] Then
		If $aCursorInfo[4] = $hPCNumInput Then GUICtrlSetData($hPCNumInput, "")
	EndIf
WEnd

_WinAPI_SetFocus(ControlGetHandle("Admin NAS Utility", "", $hPCNumInput))


;Old Check Hard Drive
Func OldCheckHardDrive()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/drives.html?cat=storage")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/drives.html?cat=storage")
		EndIf
	EndIf
EndFunc   ;==>OldCheckHardDrive

;Old System
Func OldSystem()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage.html?cat=system")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage.html?cat=system")
		EndIf
	EndIf
EndFunc   ;==>OldSystem

;Old Enable Old Root Access
Func OldEnableRootAccess()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/diagnostics.html")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/diagnostics.html")
		EndIf
	EndIf

EndFunc   ;==>OldEnableRootAccess

;Old Update Firmware
Func OldUpdateFirmware()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/update.html?cat=all")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/update.html?cat=all")
		EndIf
	EndIf
EndFunc   ;==>OldUpdateFirmware



;New Check Hard Drive
Func NewCheckHardDrive()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/drives.html?cat=storage")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/drives.html?cat=storage")
		EndIf
	EndIf
EndFunc   ;==>NewCheckHardDrive

;New System
Func NewSystem()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/manage.html?cat=system")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/manage.html?cat=system")
		EndIf
	EndIf
EndFunc   ;==>NewSystem

;New Enable Root Access
Func NewEnableRootAccess()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/diagnostics.html")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/diagnostics.html")
		EndIf
	EndIf

EndFunc   ;==>NewEnableRootAccess

;New Update Firmware
Func NewUpdateFirmware()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/update.html?cat=all")
		Next
		;CopyNASConfigFilesFromList()
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			ShellExecute("http://admin:password@" & $iIPAddress & "/manage/update.html?cat=all")
		EndIf
	EndIf
EndFunc   ;==>NewUpdateFirmware


;Map Network Drive Landesk
Func MapNetworkDriveLandesk()
	Local $iIPO1 = 10
	Local $iIPO4 = 250
	IPAddress()
	DriveMapAdd("N:", "\\" & $iIPAddress & "\Landesk\packages\NAS_Iomega_Firmware", 0)
	If @error = 0 Then
		MsgBox(0, "Error Mapping Drive", "Error Mapping Drive")
	EndIf
EndFunc   ;==>MapNetworkDriveLandesk

;Map Network Drive NAS Share
Func MapNetworkDriveNASShare()
	Local $iIPO1 = 10
	Local $iIPO4 = 230
	IPAddress()
	DriveMapAdd("O:", "\\" & $iIPAddress & "\Share", 0)
	If @error = 0 Then
		MsgBox(0, "Error Mapping Drive", "Error Mapping Drive")
	EndIf
EndFunc   ;==>MapNetworkDriveNASShare


;Copy Share Config Files to NAS Share
Func CopyConfigFilesToShare()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			If FileExists("\\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\smb.conf") And FileExists("\\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\sohoShares.xml") = 1 Then
				Run("robocopy \\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware \\" & $iIPAddress & "\Share" & " /e /s /z /r:1 /w:5 /XF ix2-ng-3.3.2.29823.tgz /XF ix2-ng-4.0.8.23976.tgz /XF ix2firmware.bat /XD \\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\LDCacheInfo")
				Sleep(3000)
				Send("{TAB}")
				Send("{ENTER}")
				Sleep(5000)
				;CopyShareConfigFileList()
			Else
				MsgBox(0, "Files Do Not Exist", "The files do not exist in the Landesk packages NAS_Iomega_Firmware directory for IP " & $iIPAddress)
				;Return
			EndIf
		Next
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			If FileExists("\\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\smb.conf") And FileExists("\\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\sohoShares.xml") = 1 Then
				Run("robocopy \\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware \\" & $iIPAddress & "\Share" & " /e /s /z /r:1 /w:5 /XF ix2-ng-3.3.2.29823.tgz /XF ix2-ng-4.0.8.23976.tgz /XF ix2firmware.bat /XD \\10." & $iIPO2 & "." & $iIPO3 & ".250\Landesk\packages\NAS_Iomega_Firmware\LDCacheInfo")
				Sleep(3000)
				Send("{TAB}")
				Send("{ENTER}")
				Sleep(5000)
				;CopyShareConfigFileList()
			Else
				MsgBox(0, "Files Do Not Exist", "The files do not exist in the The files do not exist in the Landesk packages NAS_Iomega_Firmware directory")
				Return
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CopyConfigFilesToShare

;Copy Share Config Files
Func CopyConfigFilesFromShare()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			If FileExists("\\" & $iIPAddress & "\Share\smb.conf") And FileExists("\\" & $iIPAddress & "\Share\sohoShares.xml") = 1 Then
				Run("putty.exe -ssh root@" & $iIPAddress & " -pw sohopassword")
				Sleep(3000)
				Send("{TAB}")
				Send("{ENTER}")
				Sleep(5000)
				CopyShareConfigFileList()
			Else
				MsgBox(0, "Files Do Not Exist", "The files do not exist in the Admin NAS Share directory for IP " & $iIPAddress)
				;Return
			EndIf
		Next
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			IPAddress()
			If FileExists("\\" & $iIPAddress & "\Share\smb.conf") And FileExists("\\" & $iIPAddress & "\Share\sohoShares.xml") = 1 Then
				Run("putty.exe -ssh root@" & $iIPAddress & " -pw sohopassword")
				Sleep(3000)
				Send("{TAB}")
				Send("{ENTER}")
				Sleep(5000)
				CopyShareConfigFileList()
			Else
				MsgBox(0, "Files Do Not Exist", "The files do not exist in the Admin NAS Share directory")
				Return
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CopyConfigFilesFromShare

;Share Config Files to Copy
Func CopyShareConfigFileList()
	Send("cp /nfs/Share/smb.conf /mnt/system/config")
	Send("{ENTER}")
	Send("cp /nfs/Share/sohoShares.xml /mnt/system/config")
	Send("{ENTER}")
	;Send("cp /nfs/Share/sohoShares.xml~ /mnt/system/config")
	;Send("{ENTER}")
	Send("exit")
	Send("{ENTER}")
EndFunc   ;==>CopyShareConfigFileList


Func SetEmailNotificatins()
	Send("cd /mnt/etc")
	Send("{ENTER}")
	;Send("sed 's/<EMail Destination=""><\/EMail>/<EMail Destination="itnetworksupport@ced\.com" RelayServer="exchange\.postoffice\.net" SenderAddr="reportsender@ced\.com" User="reportsender@ced\.com" Password="aqkSE\+Tr9MeWVA==" Encryption="1"><\/EMail>/g' <sohoMirror.xml >sohoMirror.bak")
	Send("{ENTER}")
	Send("cp /mnt/etc/sohoMirror.bak /mnt/etc/sohoMirror.xml")
	Send("{ENTER}")
	Send("cp /mnt/etc/sohoMirror.bak /mnt/system/config/sohoMirror.xml")
	Send("{ENTER}")
	Send("rm /mnt/etc/sohoMirror.bak")
	Send("{ENTER}")
EndFunc   ;==>SetEmailNotificatins


;Extrapolate Second and Third Octet From PC Number
Func GetPCNumber()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	If $iPCNumber > "" Then
		$iIPO2 = StringRegExpReplace($iPCNumber, "\d{2}$", "")

		$iIPO3 = StringRegExpReplace($iPCNumber, "^\d{2}", "")

		If StringTrimRight($iIPO2, 1) = 0 Then
			$iIPO2 = StringTrimLeft($iIPO2, 1)
		EndIf

		If StringTrimRight($iIPO3, 1) = 0 Then
			$iIPO3 = StringTrimLeft($iIPO3, 1)
		EndIf
		If $iIPO3 = 0 Then
			$iIPO3 = 100
		EndIf
		;MsgBox(0, "", $iIPO2)
		;MsgBox(0, "", $iIPO3)

	ElseIf $iPCNumber = "" Then
		MsgBox(262160, "Invalid Entry", "Please Enter a Valid Four Digit PC Number")
		_WinAPI_SetFocus(ControlGetHandle("Admin NAS Utility", "", $hPCNumInput))
	EndIf
EndFunc   ;==>GetPCNumber

;Combine IP Address Octets
Func IPAddress()
	$iIPAddress = ($iIPO1 & "." & $iIPO2 & "." & $iIPO3 & "." & $iIPO4)
EndFunc   ;==>IPAddress

;Set IP Address List File
Func GetFile()
	; Create a constant variable in Local scope of the message to display in FileOpenDialog.
	Local Const $sMessage = "Select a single file."

	; Display an open dialog to select a file.
	Local $sFileOpenDialog = FileOpenDialog($sMessage, @WorkingDir & "\", "CSV (*.csv) |Text (*.txt)", $FD_FILEMUSTEXIST)
	If @error Then
		; Display the error message.
		$sFilePath = ""
		MsgBox(0, "", "No file was selected.")

		; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
		FileChangeDir(@ScriptDir)
	Else
		; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
		FileChangeDir(@WorkingDir)

		; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
		$sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

		; Display the selected file.
		;MsgBox(0, "", "You chose the following file:" & @CRLF & $sFileOpenDialog)
		$sFilePath = $sFileOpenDialog
	EndIf

EndFunc   ;==>GetFile

;Putty Login
Func PuttyLogin()
	Run("putty.exe " & $iIPAddress)
EndFunc   ;==>PuttyLogin


;Ping Admin NAS
Func PingAdminNAS()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	Local $CheckboxUseIPAddressListFileStatus = ControlCommand($hCEDForm, "", $hCheckBoxUseIPAddressListFile, "IsChecked")
	If $CheckboxUseIPAddressListFileStatus = 1 Then
		Local $sIPAddressListFile = IniRead(@ScriptDir & "\Settings.ini", "FilePath", "IPAddressFile", "")
		For $i = 1 To _FileCountLines($sIPAddressListFile)
			Local $iIPAddress = FileReadLine($sIPAddressListFile, $i)
			Sleep(5000)
			Run(@ComSpec & " /k" & "ping.exe -t " & $iIPAddress)
		Next
	EndIf
	If $CheckboxUseIPAddressListFileStatus = 0 Then
		GetPCNumber()
		GUICtrlRead($hPCNumInput)
		If $iPCNumber = "" Then
			Return
		Else
			$iIPO1 = 10
			$iIPO4 = 230
			IPAddress()
			If $iIPO2 = 0 Then
				Return
			EndIf
			PingCmd()
		EndIf
	EndIf
EndFunc   ;==>PingAdminNAS


;Install Putty

;Create Putty Directory and Copy Putty.exe
Func CreatePuttyDir_CopyPutty()
	Local $PuttyFile = "c:\Program files\PuTTY\putty.exe"
	If FileExists($PuttyFile) = 1 Then
		FileDelete(@WorkingDir & "\CreatePuttyDirectory.exe")
		Return
	ElseIf FileExists($PuttyFile) = 0 Then
		ShellExecute("CreatePuttyDirectory.exe", @WorkingDir, @SW_HIDE)
	EndIf
EndFunc   ;==>CreatePuttyDir_CopyPutty

;Embed Putty.exe When Compiled
Func EmbedCreatePuttyDirectoryFile()
	Local $PuttyFile = "c:\Program files\PuTTY\putty.exe"
	If FileExists($PuttyFile) Then
		Return
	Else
		FileInstall("C:\PuTTy\putty.exe", @WorkingDir & "\")
		FileInstall("C:\PuTTy\CreatePuttyDirectory.exe", @WorkingDir & "\")
	EndIf
EndFunc   ;==>EmbedCreatePuttyDirectoryFile

;Embed Robocopy When Compiled
Func EmbedRobocopyFile()
	FileInstall("C:\Users\mender\Downloads\Scripts\AutoIT\GUI\AdminNAS\Robocopy.exe", @WorkingDir & "\")
EndFunc   ;==>EmbedRobocopyFile

;Ping Command
Func PingCmd()
	Run(@ComSpec & " /k" & "ping.exe -t " & $iIPAddress)
EndFunc   ;==>PingCmd


;Unused Functions


