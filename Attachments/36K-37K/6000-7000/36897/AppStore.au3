#RequireAdmin
#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\Backup\Icons\Company.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Author: Jeffrey Carroll
#AutoIt3Wrapper_Res_Description=App Store to allow users the ability to install applications that we allow.
#AutoIt3Wrapper_Res_LegalCopyright=For use at Company only
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Run_Obfuscator=y
;#Obfuscator_Parameters=/cs 1 /cn 1 /cf 1 /cv 1 /sf 1 /sv 1
;Help for this app has been received by the following users in the AutoIT community, either directy or indirectly. Thank you for your help!
; Water, BrewManNH, Robjong, Melba23, Guinness, KaFu, Jos, Valuator, UP_North

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <Crypt.au3>
#include <Array.au3>
#include <AD.au3>
#include <String.au3>
#include <File.au3>
#cs
What to edit to make this work for your system.
I have called the App Store, Company App Store. If you do a search for the word, Company, you can then replace this with the name that you wish to call the App Store.
The _DecryptPW functions contain passwords that you will want to modify for your own network.
The _SendMail() functions will need to be modified to reflect the users own mail settings.
#ce

Global $sPW, $rcomboManufacturer

If Not FileExists("C:\Program Files\Company") Then
	DirCreate("C:\Program Files\Company\")
EndIf

;Start Interface
$formMain = GUICreate("Company App Store", 560, 192, 201, 124)
$listSoftware = GUICtrlCreateListView("", 8, 8, 440, 175)) ;Haven't been able to get the sort to work, as it messes up the Sub Items.
$hlistsoftware = GUICtrlGetHandle($listSoftware)
; Add columns
_GUICtrlListView_AddColumn($listSoftware, "Software List", 145)
_GUICtrlListView_AddColumn($listSoftware, "Installed Version", 100)
_GUICtrlListView_AddColumn($listSoftware, "Number of Installs", 110); Not yet setup, but will eventually add a log file. This will add the users who is installing the program to a csv file, telling us what application they installed and it will also read this file to see how many people have installed the application.
_GUICtrlListView_AddColumn($listSoftware, "Availability", 80)
; Add items
;Check Software.ini file to populate list
$iCount = IniReadSection("C:\Program Files\Company\Software.ini", "ApplicationName") ;Location of ini can be modified here, but you may find it best to "replace all" to get all the locations of this file changed.
If @error Then
	IniWriteSection("C:\Program Files\Company\Software.ini", "ApplicationName", "", "")
	IniWriteSection("C:\Program Files\Company\Software.ini", "Install", "", "")
	$iCount = IniReadSection("C:\Program Files\Company\Software.ini", "ApplicationName")
Else
	For $i = 1 To $iCount[0][0]
		_GUICtrlListView_AddItem($listSoftware, $iCount[$i][0] & " " & $iCount[$i][1])
		_GUICtrlListView_AddSubItem($listSoftware, $i, "Scanning...", 1)
		_GUICtrlListView_AddSubItem($listSoftware, $i, "Scanning...", 2)
		_GUICtrlListView_AddSubItem($listSoftware, $i, "Scanning...", 3)
	Next
EndIf
$btnRequest = GUICtrlCreateButton("&Request Software", 457, 16, 95, 25, $WS_GROUP); Will send an email by calling the _SendMail() function
$btnAdd = GUICtrlCreateButton("&Add Software", 457, 40, 95, 25, $WS_GROUP); Will add software to the list by modifying the ini file
$btnRemove = GUICtrlCreateButton("&Remove Software", 457, 64, 95, 25, $WS_GROUP); Will add software to the list by modifying the ini file
$btnInstallPrinters = GUICtrlCreateButton("Install &Printers", 457, 88, 95, 25, $WS_GROUP);Will open a new GUI presenting a list of printers available for installation
$btnInstall = GUICtrlCreateButton("&Install", 457, 112, 95, 25, $WS_GROUP); Executes the exe of the program that has been selected in the list. The location of the exe is stored in the ini file referencing to a local network share.
$btnUninstall = GUICtrlCreateButton("&Uninstall", 457, 136, 95, 25, $WS_GROUP); The uninstall feature is not yet setup. It will look to the registry though and pull the Uninstall string, which it will execute. Right now this is not something we are allowing our users to do.
$btnExit = GUICtrlCreateButton("E&xit", 457, 160, 95, 25, $WS_GROUP)
GUISetState(@SW_SHOW)

_UpdateList(); Checks to see if the program is on the network, or accessible, and looks at the registry for the version installed on the machine.

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnExit
			Exit
		Case $btnInstallPrinters
			_Printers() ; Open the GUI to install local printer drivers.
		Case $btnRequest
			$Form4 = GUICreate("Software Request", 495, 220, 192, 124)
			$LabelAppName = GUICtrlCreateLabel("Application Name", 8, 8, 87, 17)
			$InputAppName = GUICtrlCreateInput("", 8, 32, 481, 21)
			$LabelReason = GUICtrlCreateLabel("Reason for software", 8, 68, 99, 17)
			$InputReason = GUICtrlCreateInput("", 8, 92, 481, 21)
			$LabelURL = GUICtrlCreateLabel("Please enter a URL if available for the software", 8, 128, 250, 17)
			$InputURL = GUICtrlCreateInput("", 8, 152, 481, 21)
			$btnSend = GUICtrlCreateButton("&Send", 416, 185, 75, 25)
			$btnExitEmail = GUICtrlCreateButton("E&xit", 336, 185, 75, 25)
			GUISetState(@SW_SHOW)
			GUISwitch($Form4)
			WinActivate("Software Request", "")

			While 4
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						GUIDelete($Form4)
						GUISetState(@SW_SHOW, $formMain)
						WinActivate("Company App Store", "")
						ExitLoop
					Case $btnExitEmail
						GUIDelete($Form4)
						GUISetState(@SW_SHOW, $formMain)
						WinActivate("Company App Store", "")
						ExitLoop
					Case $btnSend
						_SendEmail(); 2 emails are sent. One to the administrator and one 2 the user as a receipt. A function can easily be removed if only 1 email is necessary.
						_SendEmail1()
						MsgBox(0, "Message Sent", "Your software request has been sent to the administrator.")
						GUIDelete($Form4)
						GUISetState(@SW_SHOW, $formMain)
						WinActivate("Company App Store", "")
						ExitLoop
				EndSwitch
			WEnd
		Case $btnAdd
			_AD_Open()
			If _AD_IsMemberOf("Domain Admins", @UserName, 1) Then
				_AddAPP()
			Else
				MsgBox(48, "Company App Store", "You do not have permissions to add an application to the Company App Store.")
			EndIf
			_AD_Close()
			_restart(); The application restarts quickly to refresh the list. I found this the easiest way of refreshing. Ideally the list would refresh without the application restarting.
		Case $btnInstall
			$iItems = _GUICtrlListView_GetItemCount($listSoftware)
			For $x = 0 To $iItems
				If _GUICtrlListView_GetItemSelected($listSoftware, $x) Then
					If _GUICtrlListView_GetItemText($listSoftware, $x, 3) = "Available" Then ; Will install the application only if the exe is available
						_GUICtrlListView_AddSubItem($listSoftware, $x, "Installing", 3)
						$iInstall = _GUICtrlListView_GetItemText($listSoftware, $x)
						$iInstall1 = IniReadSection("C:\Program Files\Company\Software.ini", "Install")
						For $y = 1 To $iInstall1[0][0]
							If StringInStr($iInstall, $iInstall1[$y][0]) Then
								_DecryptPW1()
								RunAsWait("username", "Company.com", $sPW, 0, $iInstall1[$y][1])
							EndIf
						Next
					Else
						MsgBox(48, "Unavailable", "The application you are trying to install is currently unavailable.")
					EndIf
				EndIf
			Next
		Case $btnRemove
			_AD_Open()
			If _AD_IsMemberOf("Domain Admins", @UserName, 1) Then ; Will remove the application from the App Store list, but only for Admins.
				$rItems = _GUICtrlListView_GetItemCount($listSoftware)
				For $v = 0 To $rItems
					If _GUICtrlListView_GetItemSelected($listSoftware, $v) Then
						$iRemove = IniReadSection("C:\Program Files\Company\Software.ini", "ApplicationName")
						$iRemove1 = _GUICtrlListView_GetItemText($listSoftware, $v)
						For $y = 1 To $iRemove[0][0]
							If $iRemove1 = $iRemove[$y][0] & " " & $iRemove[$y][1] Then
								IniDelete("C:\Program Files\Company\Software.ini", "ApplicationName", $iRemove[$y][0])
								IniDelete("C:\Program Files\Company\Software.ini", "Install", $iRemove[$y][0])
							EndIf
						Next
					EndIf
				Next
				_AD_Close()
				_restart(); The application restarts quickly to refresh the list.
			Else
				MsgBox(48, "Company App Store", "You do not have permissions to remove an application from the Company App Store.")
				_AD_Close()
			EndIf
		Case $btnUninstall
			MsgBox(16, "Uninstall Application", "This feature is currently disabled.")
	EndSwitch
WEnd

Func _DecryptPW1()
	_Crypt_Startup()
	Global $sPasswordCT = '0x1111111111111111111111111111111111111111111' ;Enter your own encrypted password. I am using 2 passwords for different tasks, but you may only new one of these functions.
	Global $sPW = ''
	$sPW = _Decrypt("password", $sPasswordCT)
	_Crypt_Shutdown()
EndFunc   ;==>_DecryptPW1

Func _DecryptPW()
	_Crypt_Startup()
	Global $sPasswordCT = '0x1111111111111111111111111111111111111111111' ;Enter your own encrypted password
	Global $sPW = ''
	$sPW = _Decrypt("password", $sPasswordCT)
	_Crypt_Shutdown()
EndFunc   ;==>_DecryptPW

Func _Decrypt($sKey, $sData)
	Local $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)
	Local $sDecrypted = BinaryToString(_Crypt_DecryptData(Binary($sData), $hKey, $CALG_USERKEY))
	_Crypt_DestroyKey($hKey)
	Return $sDecrypted
EndFunc   ;==>_Decrypt

;Update listview columns
Func _UpdateList()
	Local $iUpdate = IniReadSection("C:\Program Files\Company\Software.ini", "ApplicationName")
	Local $uRegKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	$iInstall2 = IniReadSection("C:\Program Files\Company\Software.ini", "Install")
	If IsArray($iUpdate) Then
		For $z = 1 To $iUpdate[0][0]; Scans all applications in the list
			For $w = 1 To 500; checks the registry for the application
				$AppKey = RegEnumKey($uRegKey, $w)
				If StringInStr(RegRead($uRegKey & "\" & $AppKey, "DisplayName"), $iUpdate[$z][0]) Then
					$uVer = RegRead($uRegKey & "\" & $AppKey, "DisplayVersion"); determines installed application version from the registry
					_GUICtrlListView_AddSubItem($listSoftware, $z - 1, $uVer, 1); updates list with the version number
				EndIf
			Next
			$uVer = "" ; reset the version variable so if the software is not installed, nothing will be displayed.
			;Scan software availability
			For $v = 1 To $iInstall2[0][0]; checks the software in the list to determine if it can be accessed .
				If StringInStr($iUpdate[$z][0], $iInstall2[$v][0]) Then
					$iString = _StringBetween($iInstall2[$v][1], '"', '"')
					If @error Then ; Will find the string if "" are used
						If FileExists($iInstall2[$v][1]) Then
							;Reload the availability columns
							_GUICtrlListView_AddSubItem($listSoftware, $z - 1, "Available", 3)
						Else
							;Reload the availability columns
							_GUICtrlListView_AddSubItem($listSoftware, $z - 1, "Not Available", 3)
						EndIf
					Else
						If FileExists($iString[0]) Then ; Will find the string if "" are not used
							;Reload the availability columns
							_GUICtrlListView_AddSubItem($listSoftware, $z - 1, "Available", 3)
						Else
							;Reload the availability columns
							_GUICtrlListView_AddSubItem($listSoftware, $z - 1, "Not Available", 3)
						EndIf
					EndIf
				EndIf
			Next
		Next
	EndIf
EndFunc   ;==>_UpdateList

;Add Software to List GUI
Func _AddAPP()
	$Form3 = GUICreate("Add Application", 495, 303, 192, 124)
	$Input1 = GUICtrlCreateInput("", 8, 32, 481, 21)
	$Input2 = GUICtrlCreateInput("", 7, 95, 481, 21)
	$Input3 = GUICtrlCreateInput("", 7, 159, 481, 21)
	$Label1 = GUICtrlCreateLabel("Application Name", 8, 8, 87, 17)
	$Label3 = GUICtrlCreateLabel("Application Version", 8, 68, 99, 17)
	$Input4 = GUICtrlCreateInput("", 7, 223, 481, 21)
	$Label4 = GUICtrlCreateLabel("Parameters", 8, 200, 57, 17)
	$btnBrowse = GUICtrlCreateButton("Application Path", 8, 126, 99, 25, $BS_FLAT) ; Can allow you to browse for the file
	$btnAddApp = GUICtrlCreateButton("&Add", 416, 264, 75, 25)
	$btnExitAdd = GUICtrlCreateButton("E&xit", 336, 264, 75, 25)
	GUISetState(@SW_SHOW)
	GUISwitch($Form3)
	WinActivate("Add Application", "")

	While 3
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form3)
				GUISetState(@SW_SHOW, $formMain)
				WinActivate("Company App Store", "")
				ExitLoop
			Case $btnExitAdd
				GUIDelete($Form3)
				GUISetState(@SW_SHOW, $formMain)
				WinActivate("Company App Store", "")
				ExitLoop
			Case $btnBrowse
				$var = FileOpenDialog("Select a file", @WindowsDir & "", "Installers (*.exe;*.msi)|Scripts (*.vbs;*.bat)", 1) ; Can adjust what files can be seen here to add to the list
				GUICtrlSetData($Input3, $var)
			Case $btnAddApp
				$aAppName = GUICtrlRead($Input1)
				$aAppVer = GUICtrlRead($Input2)
				$aAppPath = GUICtrlRead($Input3)
				$aAppPara = GUICtrlRead($Input4)
				IniWrite("C:\Program Files\Company\Software.ini", "ApplicationName", $aAppName, $aAppVer)
				If $aAppPara = "" Then
					IniWrite("C:\Program Files\Company\Software.ini", "Install", $aAppName, $aAppPath)
				Else
					IniWrite("C:\Program Files\Company\Software.ini", "Install", $aAppName, $aAppPath & " " & $aAppPara)
				EndIf
				_UpdateList()
				GUIDelete($Form3)
				GUISetState(@SW_SHOW, $formMain)
				WinActivate("Company App Store", "")
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_AddAPP


; Printer Installs

Func _Printers()
	Local $comboPrinter, $btnInstallPrinter = 999

	$Form2 = GUICreate("Install Printer Drivers", 440, 60, -1, -1)
	$MenuItemFile = GUICtrlCreateMenu("&File")
	$MenuItemExit = GUICtrlCreateMenuItem("E&xit", $MenuItemFile)
	$MenuItemEdit = GUICtrlCreateMenu("&Edit")
	$MenuItemAdd = GUICtrlCreateMenuItem("&Add Printer", $MenuItemEdit) ; Allows you to add a new printer to the list (manufacturer and model number)
	$MenuItemRemove = GUICtrlCreateMenuItem("&Remove Printer", $MenuItemEdit); Have not yet got into how to remove a Printer from the list.
	$comboManufacturer = GUICtrlCreateCombo("", 9, 10, 130, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE, $CBS_SORT))
	;Check Software.ini file to populate list
	$iCount1 = IniReadSection("C:\Program Files\Company\Printers.ini", "PrinterManufacturer")
	If @error Then
		IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterManufacturer", "", "")
		IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterModel", "", "")
		IniWriteSection("C:\Program Files\Company\Printers.ini", "DriverLocation", "", "")
		$iCount1 = IniReadSection("C:\Program Files\Company\Printers.ini", "PrinterManufacturer")
	Else
		For $i = 1 To $iCount1[0][0]
			GUICtrlSetData(-1, $iCount1[$i][0])
		Next
	EndIf
	$btnSetManufacturer = GUICtrlCreateButton("Set", 150, 8, 35, 25); Have to click the Set button after selecting a manufacturer, so all the models of that manufacturer appear.
	GUISetState(@SW_SHOW)
	WinActivate("Install Printer Drivers", "")

	While 2
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form2)
				GUISetState(@SW_SHOW, $formMain)
				WinActivate("Company App Store", "")
				ExitLoop
			Case $MenuItemExit
				GUIDelete($Form2)
				GUISetState(@SW_SHOW, $formMain)
				WinActivate("Company App Store", "")
				ExitLoop
			Case $MenuItemRemove
				MsgBox(48, "Remove Printer", "The option to remove a printer is not yet available.")
			Case $MenuItemAdd
				_AD_Open()
				If _AD_IsMemberOf("Domain Admins", @UserName, 1) Then ; Only Admins can add printers to the App Store
					$Form5 = GUICreate("Add Printer", 495, 235, 192, 124)
					$Input1 = GUICtrlCreateInput("", 8, 32, 481, 21)
					$Input2 = GUICtrlCreateInput("", 7, 95, 481, 21)
					$Input3 = GUICtrlCreateInput("", 7, 159, 481, 21)
					$Label1 = GUICtrlCreateLabel("Printer Manufacturer", 8, 8, 120, 17)
					$Label3 = GUICtrlCreateLabel("Printer Model", 8, 68, 99, 17)
					$btnBrowse = GUICtrlCreateButton("Application Path", 8, 126, 99, 25, $BS_FLAT)
					$btnAddPrinter = GUICtrlCreateButton("&Add", 416, 200, 75, 25)
					$btnExitPrinter = GUICtrlCreateButton("E&xit", 336, 200, 75, 25)
					GUISetState(@SW_SHOW)
					GUISwitch($Form5)
					WinActivate("Add Printer", "")

					While 5
						$nMsg = GUIGetMsg()
						Switch $nMsg
							Case $GUI_EVENT_CLOSE
								GUIDelete($Form5)
								GUISetState(@SW_SHOW, $Form2)
								WinActivate("Install Printer Drivers", "")
								ExitLoop
							Case $btnExitPrinter
								GUIDelete($Form5)
								GUISetState(@SW_SHOW, $Form2)
								WinActivate("Install Printer Drivers", "")
								ExitLoop
							Case $btnBrowse
								$var = FileOpenDialog("Select a file", @WindowsDir & "", "Installers (*.exe;*.msi;*.zip)|Scripts (*.vbs;*.bat)", 1)
								GUICtrlSetData($Input3, $var)
							Case $btnAddPrinter
								$aPrintMan = GUICtrlRead($Input1)
								$aPrintMod = GUICtrlRead($Input2)
								$aPrintPath = GUICtrlRead($Input3)
								IniWrite("C:\Program Files\Company\Printers.ini", "PrinterManufacturer", $aPrintMan, "")
								IniWrite("C:\Program Files\Company\Printers.ini", "PrinterModel", $aPrintMan, $aPrintMod)
								IniWrite("C:\Program Files\Company\Printers.ini", "DriverLocation", $aPrintMan & " " & $aPrintMod, $aPrintPath); Writes to the ini the location where the driver will be stored.
								GUIDelete($Form5)
								GUISetState(@SW_SHOW, $Form2)
								WinActivate("Install Printer Drivers", "")
								_AD_Close()
								ExitLoop
						EndSwitch
					WEnd
				Else
					MsgBox(48, "Company App Store", "You do not have permissions to remove an application from the Company App Store.")
					_AD_Close()
				EndIf
			Case $btnInstallPrinter
				$rComboPrinter = GUICtrlRead($comboPrinter)
				$iCount3 = IniReadSection("C:\Program Files\Company\Printers.ini", "DriverLocation")
				If @error Then
					IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterManufacturer", "", "")
					IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterModel", "", "")
					IniWriteSection("C:\Program Files\Company\Printers.ini", "DriverLocation", "", "")
					$iCount3 = IniReadSection("C:\Program Files\Company\Printers.ini", "DriverLocation")
				Else
					For $i = 1 To $iCount3[0][0]
						If $rcomboManufacturer & " " & $rComboPrinter = $iCount3[$i][0] Then
							_DecryptPW1() ; The password has to be decrypted before using the RunAs
							RunAs("username", "Company.com", $sPW, 2, $iCount3[$i][1])
						EndIf
					Next
				EndIf
			Case $btnSetManufacturer
				$rcomboManufacturer = GUICtrlRead($comboManufacturer)
				GUICtrlDelete($comboPrinter)
				$comboPrinter = GUICtrlCreateCombo(" Select Printer Model", 200, 10, 145, 25, BitOR($CBS_DROPDOWN, $CBS_SORT, $CBS_AUTOHSCROLL, $CBS_DROPDOWNLIST, $WS_VSCROLL))
				$iCount2 = IniReadSection("C:\Program Files\Company\Printers.ini", "PrinterModel")
				If @error Then
					IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterManufacturer", "", "")
					IniWriteSection("C:\Program Files\Company\Printers.ini", "PrinterModel", "", "")
					IniWriteSection("C:\Program Files\Company\Printers.ini", "DriverLocation", "", "")
					$iCount2 = IniReadSection("C:\Program Files\Company\Printers.ini", "PrinterModel")
				Else
					For $i = 1 To $iCount2[0][0]
						If $rcomboManufacturer = $iCount2[$i][0] Then
							GUICtrlSetData(-1, $iCount2[$i][1])
						EndIf
					Next
					$btnInstallPrinter = GUICtrlCreateButton("Install", 360, 8, 70, 25)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_Printers

Func _SendEmail()
	_DecryptPW()
	$rApp = GUICtrlRead($InputAppName)
	$rReason = GUICtrlRead($InputReason)
	$rURL = GUICtrlRead($InputURL)
	$SmtpServer = "servername.Company.com" ; address for the smtp-server to use - REQUIRED
	$FromName = "" ; name from who the email was sent
	$FromAddress = "username@Company.com" ; address from where the mail should come
	$ToAddress = @UserName & "@Company.com" ; destination address of the email - REQUIRED
	$Subject = "Software Request - Company App Store" ; subject from the email - can be anything you want it to be
	$Body = "Software: " & $rApp & @CRLF & "Reason: " & $rReason & @CRLF & "URL: " & $rURL & @CRLF & "Username: " & @UserName & @CRLF & "IP Address: " & @IPAddress1 & @CRLF & "Computer Name: " & @ComputerName; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = "" ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
	$CcAddress = "" ; address for cc - leave blank if not needed
	$BccAddress = "" ; address for bcc - leave blank if not needed
	$Importance = "Normal" ; Send message priority: "High", "Normal", "Low"
	$username = "username@Company.com" ; username for the account used from where the mail gets sent - REQUIRED
	$Password = $sPW ; password for the account used from where the mail gets sent - REQUIRED
	$IPPort = 25 ; port used for sending the mail
	$ssl = 0 ; enables/disables secure socket layer sending - put to 1 if using httpS
	;$IPPort=465                          ; GMAIL port used for sending the mail
	;$ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

	If $rApp = "" Or $rReason = "" Then
		MsgBox(48, "Missing information", "Information is missing. Please make sure you have filled out the Application Name and provide a reason.")
	Else
		Global $oMyRet[2]
		Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
		$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $username, $Password, $IPPort, $ssl)
		If @error Then
			MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
		EndIf
	EndIf
EndFunc   ;==>_SendEmail

Func _SendEmail1()
	_DecryptPW()
	$rApp = GUICtrlRead($InputAppName)
	$rReason = GUICtrlRead($InputReason)
	$rURL = GUICtrlRead($InputURL)
	$SmtpServer = "servername.Company.com" ; address for the smtp-server to use - REQUIRED
	$FromName = "" ; name from who the email was sent
	$FromAddress = "username@Company.com" ; address from where the mail should come
	$ToAddress = @UserName & "@Company.com" ; destination address of the email - REQUIRED
	$Subject = "Software Request - Company App Store" ; subject from the email - can be anything you want it to be
	$Body = "This email is to acknowledge the receipt of your software request for the Company App Store. The application will be reviewed by Technology." & @CRLF & @CR & "Software: " & $rApp & @CRLF & "Reason: " & $rReason & @CRLF & "URL: " & $rURL & @CRLF & "Username: " & @UserName & @CRLF & "IP Address: " & @IPAddress1 & @CRLF & "Computer Name: " & @ComputerName; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = "" ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
	$CcAddress = "" ; address for cc - leave blank if not needed
	$BccAddress = "" ; address for bcc - leave blank if not needed
	$Importance = "Normal" ; Send message priority: "High", "Normal", "Low"
	$username = "username@Company.com" ; username for the account used from where the mail gets sent - REQUIRED
	$Password = $sPW ; password for the account used from where the mail gets sent - REQUIRED
	$IPPort = 25 ; port used for sending the mail
	$ssl = 0 ; enables/disables secure socket layer sending - put to 1 if using httpS
	;$IPPort=465                          ; GMAIL port used for sending the mail
	;$ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

	If $rApp = "" Or $rReason = "" Then
		MsgBox(48, "Missing information", "Information is missing. Please make sure you have filled out the Application Name and provide a reason.")
	Else
		Global $oMyRet[2]
		Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
		$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $username, $Password, $IPPort, $ssl)
		If @error Then
			MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
		EndIf
	EndIf
EndFunc   ;==>_SendEmail1

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance = "Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	Local $objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$objEmail.To = $s_ToAddress
	Local $i_Error = 0
	Local $i_Error_desciption = ""
	If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
	$objEmail.Subject = $s_Subject
	If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
		$objEmail.HTMLBody = $as_Body
	Else
		$objEmail.Textbody = $as_Body & @CRLF
	EndIf
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
			If FileExists($S_Files2Attach[$x]) Then
				ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
				$objEmail.AddAttachment($S_Files2Attach[$x])
			Else
				ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
				SetError(1)
				Return 0
			EndIf
		Next
	EndIf
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	If Number($IPPort) = 0 Then $IPPort = 25
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
	;Authenticated SMTP
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	If $ssl Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf
	;Update settings
	$objEmail.Configuration.Fields.Update
	; Set Email Importance
	Switch $s_Importance
		Case "High"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
		Case "Normal"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
		Case "Low"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
	EndSwitch
	$objEmail.Fields.Update
	; Sent the Message
	$objEmail.Send
	If @error Then
		SetError(2)
		Return $oMyRet[1]
	EndIf
	$objEmail = ""
EndFunc   ;==>_INetSmtpMailCom

; Com Error Handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description, 3)
	ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
	SetError(1); something to check for when this function returns
	Return
EndFunc   ;==>MyErrFunc

Func _restart()
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>_restart

