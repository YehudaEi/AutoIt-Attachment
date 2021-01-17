#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=P:\backup\PCSwap.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Chris Erickson (ericksoncl23@gmail.com)
;
; Script Function:
;  Backs up and restores from the backup drive
;  This program was designed to make life easy for people that swap out machines. So sit back and relax while this script does all the work.
#include <GuiConstants.au3>
#include <Date.au3>
#include <Process.au3>
#include <File.au3>
#Include <Clipboard.au3>
Local $strPrinters


;;;;;;;;;;;;;;;; GUI Stuff;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$parentWin = GUICreate("Chris Erickson's BackupScript v6.0.0", 450, 200)
GUISetFont(8, 400, 0, "Comic Sans MS")

;;;;;;;;;;;;;;;Set Colors and picture;;;;;;;;;;;;;;;;;;;;;
$textColor = 0x800517
$backgroundColor = 0x6736f6e
GUISetBkColor($backgroundColor)

;;;;;;;;;;;;;;;;;Log file locations;;;;;;;;;;;;;;;;;;;;;;;;;
$BackupFile = FileOpen("\\server\public\backup\BackupLogs.log", 1)
$RestoreFile = FileOpen("\\server\public\backup\RestoreLogs.log", 1)
$IPlocation1Text = "Madison"
$IPlocation1 = "\\server\public\backup\users"
$IPlocation1RegExp = '10\.2\.[0-9]{1,3}\.[0-9]{1,3}'
$Iplocation2Text  = "Here"
$Iplocation2 = "\\server\public\backup\users"
$IPLocation2RegExp = '10\.1\.[0-9]{1,3}\.[0-9]{1,3}'
;;;;;;;;;;;;;;;;;Text for Labels and buttons and Backup locations;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$copyOutlook = "Copying Outlook"
$copyFavs = "Copying Favorites"
$copyDesktop = "Copying Desktop"
$copyPrinters = "Copying Printers"
$copyDocs = "Copying My Documents"
$restoreOutlook = "Restoring Outlook"
$restoreFavs = "Restoring Favorites"
$restoreDesktop = "Restoring Desktop"
$restoreprinters = "Restoring Printers"
$restoreDocuments = "Restoring Documents"
$done = "Done!"
$backupOutlookDir = @AppDataDir & '\Microsoft\Outlook\'
$backupFavsDir = @UserProfileDir & '\Favorites\'
$backupDeskDir = @UserProfileDir & '\Desktop\'
$backupDeskAllUserDir = 'C:\Documents and Settings\All Users\Desktop\'
$eskerPicture = "\\pathtologo\logo.gif"
$shortcutLocation = "\\pathtoshortcut\pcswap.lnk"

;;;;;;;;;;;;;;;;Labels and buttons;;;;;;;;;;;;;;;;;;;;;;;;;
$label = GUICtrlCreateLabel("Backup/Restore for username: " & @UserName, 10, 10, 100, 40)
$progressbar = GUICtrlCreateProgress(10, 50, 230, 20)
$backupButton = GUICtrlCreateButton("Backup", 10, 100, 100, 40)
$restoreButton = GUICtrlCreateButton("Restore", 110, 100, 100, 40)
$remotepcButton = GUICtrlCreateButton("Backup Remote PC", 110, 145, 100, 40)
$specificsbackupButton = GUICtrlCreateButton("Back up Specifics", 10, 145, 100, 40)
$aboutButton = GUICtrlCreateButton("About", 420, 180)
$deployButton = GUICtrlCreateButton("Deploy Shortcut",1000,1000,100,20)
$deployOthersButton = GUICtrlCreateButton("Deploy Software",1120,1130,100,20)
$ServerPath = "None"
;if $CmdLine[0] = 1 Then
;;	if $CmdLine[1] = "/admin" Then
$deployButton = GUICtrlCreateButton("Deploy Shortcut",120,10,100,20)
GUICtrlSetColor($deployButton, $textColor)
$deployOthersButton = GUICtrlCreateButton("Deploy Software",120,30,100,20)
GUICtrlSetColor($deployOthersButton, $textColor)
;	EndIf
;EndIf

;;;;;;;;;;;ONLY CHANGE THIS TO CHANGE SAVE DIR;;;;;;;;;;;;
;;Madison
$ipTest = StringRegExp(@IPAddress1, $IPlocation1RegExp , 0)
If ($ipTest == 1) Then
	$ISPath = $IPlocation1
	$ServerPath = $IPlocation1Text
Else
;;Lyon
$ipTest = StringRegExp(@IPAddress1, $IPLocation2RegExp ,0)
If ($ipTest == 1) Then
	$ISPath = $Iplocation2
	$ServerPath = $Iplocation2Text
Else
	MsgBox(1,"Error","unknown IP. Please Contact Chris Erickson or the current writer of this script.")
	Exit
EndIf
EndIf

$ISPathlabel = GUICtrlCreateLabel("Location: " & $ServerPath, 10, 79)


;;;;;;;;;;;;;;;;Get all of the users printers;;;;;;;;;;;;;;;;
$arrPrinters = usr_GetPrinters("NETWORK")
For $i = 1 To $arrPrinters[0]
	$strPrinters &= $arrPrinters[$i] & @LF
Next
$ptrGui = GUICtrlCreateLabel(@UserName & "'s Printers", 260, 20)
$printerOutput = GUICtrlCreateLabel($strPrinters, 260, 50)

;;;;;;;;;;;;;;;;;Set button Colors and GUI state;;;;;;;;;;;;;;;;;;;;;;;;;;
GUICtrlCreatePic($eskerPicture, 360, 0,90,35)
GUICtrlSetColor($backupButton, $textColor)
GUICtrlSetColor($restoreButton, $textColor)
GUICtrlSetColor($remotepcButton, $textColor)
GUICtrlSetColor($specificsbackupButton, $textColor)
GUICtrlSetColor($label, $textColor)
GUICtrlSetColor($progressbar, $textColor)
GUICtrlSetColor($ptrGui, $textColor)
GUICtrlSetColor($printerOutput, $textColor)
GUICtrlSetColor($ISPathlabel, $textColor)
GUISetState()
;Global $username,$password

;;;;;;;;;;;;;;;Main program Loop;;;;;;;;;;;;;;;;;;;;;;;;
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; Deploy stuff to PCs ;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
		Case $msg = $deployButton
			$PCname = InputBox("Input PC Name", "Please Input PC name:")
			$var = Ping($PCname, 50) 
			If $var Then
				$test = FileCopy($shortcutLocation, "\\" & $PCname & '\C$\WINDOWS\system32\', 1)
				if $test = 0 Then
					MsgBox(0,"Error","Could not copy shortcut to Client!")
				Else
					GUICtrlSetData($label, $done)
					GUICtrlSetData($progressbar, 100)
				EndIf
			Else
				MsgBox(0,"Error","Could not ping Clients Machine!")
			EndIf
		case $msg = $deployOthersButton
				$ChildWin = GUICreate("Pick what you want", 160, 190)
				GUISetFont(8, 400, 0, "Comic Sans MS")
				GUISetBkColor($backgroundColor)
				GUISwitch($ChildWin)
				$Checkbox_Office2007 = GUICtrlCreateCheckbox("Office 2007", 1,45)
				$Checkbox_AdobeR9 = GUICtrlCreateCheckbox("Adobe Reader 9", 1, 65)
				$Checkbox_Video1 = GUICtrlCreateCheckbox("NVS - 285,290", 1, 85)
				$Checkbox_Video2 = GUICtrlCreateCheckbox("NVS - 280", 1, 105)
				$Checkbox_Mbam = GUICtrlCreateCheckbox("Mbam - Anti-spyware", 1, 125)
				$Checkbox_wifi = GUICtrlCreateCheckbox("Install Wifi", 1, 145)
				$Button_ok = GUICtrlCreateButton("OK", 10, 165, 40)
				$Button_cancel = GUICtrlCreateButton("Cancel", 60, 165, 40)
				GUISetState(@SW_SHOW)
				While 1
					$msg = GUIGetMsg()
					Select
						Case $msg = $Button_cancel
							GUIDelete($ChildWin)
							ExitLoop
						Case $msg = $GUI_EVENT_CLOSE
							GUIDelete($ChildWin)
							ExitLoop
						Case $msg = $Button_ok
							$Office2007 = GUICtrlRead($Checkbox_Office2007)
							$Reader9 = GUICtrlRead($Checkbox_AdobeR9)
							$Video1 = GUICtrlRead($Checkbox_Video1)
							$Video2 = GUICtrlRead($Checkbox_Video2)
							$Mbam = GUICtrlRead($Checkbox_Mbam)
							$Wifi = GUICtrlRead($Checkbox_wifi)
							GUIDelete($ChildWin)
							GUISwitch($parentWin)
							GUISetState(@SW_SHOW, $parentWin)
							If $Office2007 = 1 Then 
								RunWait("R:\Microsoft\Office_2007\setup.exe")
							EndIf
							If $Reader9 = 1 Then
								RunWait("R:\Adobe\Acrobat Reader 9\AdbeRdr90_en_US.exe /sPB")
							EndIf
							If $Video1 = 1 Then
								RunWait("R:\Video Drivers\NVS-285.exe")
							EndIf
							If $Video2 = 1 Then
								RunWait("R:\Video Drivers\NVS-280.exe")
							EndIf
							if $Mbam = 1 Then
								runwait("R:\Anti-Spyware\mbam-setup.exe /verysilent")
							EndIf
							if $Wifi = 1 Then
								RunWait("R:\WiFi\WifiAutoConfig.exe")
							EndIf
						ExitLoop
				EndSelect
			WEnd
			GUISwitch($parentWin)
			GUISetState(@SW_SHOW, $parentWin)
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; Straight Full Backup;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $msg = $backupButton
			If FileExists($ISPath & "\" & @UserName &"\") Then
				$test = MsgBox(4,"Are you sure?", "There is already a backup file for " & @UserName & ". Are you sure you want to backup again?")
			Else
				$test = 6
			EndIf
		If ($test = 6) Then
			copy_Outlook()
			copy_Favs()
			copy_Docs()
			copy_Desktop()
			usr_SavePrinterScript()
			GUICtrlSetData($progressbar, 100)
			GUICtrlSetData($label, $done)
			$oldComputer = FileOpen($ISPath & '\' & @UserName & '\oldComputer.log', 2)
			FileWriteLine($oldComputer, @ComputerName)
			FileClose($oldComputer)
			FileWriteLine($BackupFile, "*" & @MON & "/" & @MDAY & " - " & @HOUR & ":" & @MIN & "-> Backup of: " & @ComputerName & " was Successful for User: " & @UserName & " @ " & $ISPath & "*" & @CRLF)
		Else
			MsgBox(0, "Backup", "Information was not backed up.")
		EndIf
			GUISetState()
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; END Straight Full Backup;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; Straight Full Restore;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $msg = $restoreButton
			;$username = InputBox("Please Login","If you want to restore a users AD groups please use your -a account or click cancel:","","",200,150)
			;$password = InputBox("Please Login","Password:","","*",200,150)
			GUICtrlSetData($label, $restoreOutlook)
			GUICtrlSetData($progressbar, 0)
			If FileExists("C:\Program Files\Microsoft Office\Office12\OUTLOOK.EXE") Then
				If FileExists($ISPath & "\" & @UserName & '\Outlook\NK2') Then
					FileCopy($ISPath & '\' & @UserName & '\Outlook\NK2\*',$backupOutlookDir & '\', 9)
					GUICtrlSetData($progressbar, 25)
					GUICtrlSetData($label, $restoreFavs)
				Else
					MsgBox(1, "Error", "Could not restore Outlook!" & @LF & "There is nothing to restore!")
				EndIf
			Else
				MsgBox(1, "Error", "Outlook is not installed!")
			EndIf
			If FileExists($ISPath & "\" & @UserName & '\favs') Then
				DirCopy($ISPath & "\" & @UserName & '\favs\', $backupFavsDir, 1)
				GUICtrlSetData($progressbar, 25)
				GUICtrlSetData($label, $restoreDesktop)
			Else
				MsgBox(1, "Error", "Could not restore Favorites!" & @LF & "There is nothing to restore!")
			EndIf
			If FileExists($ISPath & "\" & @UserName & '\desktop') Then
				DirCopy($ISPath & "\" & @UserName & '\desktop\', $backupDeskDir, 1)
				DirCopy($ISPath & "\" & @UserName & '\alluserDesktop\', $backupDeskAllUserDir, 1)
				GUICtrlSetData($progressbar, 50)
				GUICtrlSetData($label, $restoreDocuments)
			Else
				MsgBox(1, "Error", "Could not restore Desktop!" & @LF & "There is nothing to restore!")
			EndIf
			if FileExists($ISPath & "\" & @UserName & "\documents") Then
				DirCopy($ISPath & "\" & @UserName & '\documents\', @MyDocumentsDir,1)
				GUICtrlSetData($progressbar, 70)
				GUICtrlSetData($label, $restoreprinters)
			Else
				MsgBox(1, "Error", "Could not restore Documents!" & @LF & "There is nothing to restore!")
			EndIf	
			If FileExists($ISPath & "\" & @UserName & "\PrinterMap.bat") Then
				Run($ISPath & "\" & @UserName & "\PrinterMap.bat")
				Sleep(2000)
			Else
				MsgBox(1, "Error", "Could not restore Printers!" & @LF & "There is nothing to restore!")
			EndIf
			GUICtrlSetData($label, $done)
			GUICtrlSetData($progressbar, 100)
			$oldComputer = FileOpen($ISPath & '\' & @UserName & '\oldComputer.log', 0)
			FileWriteLine($RestoreFile, "*" & @MON & "/" & @MDAY & " - " & @HOUR & ":" & @MIN & "-> Restore of: " & FileReadLine($oldComputer) & " --> " & @ComputerName & " was Successful for User: " & @UserName & " @ " & $ISPath & "*" & @CRLF)
			;If FileExists($ISPath & "\" & @UserName) Then
			;	$deleteFiles = MsgBox(4, "Delete Files?", "Do you want to delete the backup files?")
			;EndIf
			;If $deleteFiles = 6 Then
			;	DirRemove($ISPath & "\" & @UserName, 1)
			;EndIf
			
			GUISetState()
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; END Straight Full Restore;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;; Remote Backup;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $msg = $remotepcButton
			$PCname = InputBox("Input PC Name", "Please Input PC name:" & @LF & @LF & "NOTE: This does not backup printers...yet.")
			$User = InputBox("Input User", "Please Input User name: ")
			$var = Ping($PCname, 50) 
			If $var Then
				GUICtrlSetData($progressbar, 0)
				GUICtrlSetData($label, $copyOutlook)
				DirCopy("\\" & $PCname & '\C$\Documents and Settings\' & $User & '\Application Data\Microsoft\Outlook\', $ISPath & '\' & $User & '\Outlook\NK2\', 1)
				GUICtrlSetData($progressbar, 10)
				GUICtrlSetData($label, $copyFavs)
				DirCopy("\\" & $PCname & '\C$\Documents and Settings\' & $User & '\Favorites\', $ISPath & "\" & $User & '\favs\', 1)
				GUICtrlSetData($progressbar, 25)
				guictrlsetdata($label, $copyDocs)
				DirCopy("\\" & $PCname & '\C$\Documents and Settings\' & $User & '\My Documents', $ISPath & "\" & $User & '\documents\', 1)
				GUICtrlSetData($label, $copyDesktop)
				GUICtrlSetData($progressbar, 50)
				DirCopy("\\" & $PCname & '\C$\Documents and Settings\' & $User & '\Desktop\', $ISPath & "\" & $User & '\desktop\', 1)
				GUICtrlSetData($progressbar, 75)
				DirCopy("\\" & $PCname & '\C$\Documents and Settings\All Users\Desktop', $ISPath & "\" & $User & '\alluserDesktop\', 1)
				GUICtrlSetData($progressbar, 100)
				GUICtrlSetData($label, $done)
				GUISetState()
				ShellExecute( $ServerPath & "\" & $User & "\")
				$oldComputer = FileOpen($ISPath & '\' & $User & '\oldComputer.log', 2)
			FileWriteLine($oldComputer, $PCname)
			FileClose($oldComputer) 
			FileWriteLine($BackupFile, "*" & @MON & "/" & @MDAY & " - " & @HOUR & ":" & @MIN & "-> Backup of: " & $PCname & " was Successful for User: " & $User & " @ " & $ISPath & "*" & @CRLF)
			Else
				MsgBox(0, "Error", "Could not ping remote machine")
			EndIf
			
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;END Remote Backup;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;; Choose what to Backup;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $msg = $specificsbackupButton
			$ChildWin = GUICreate("Pick what you want", 130, 130)
			GUISetFont(8, 400, 0, "Comic Sans MS")
			GUISetBkColor($backgroundColor)
			GUISwitch($ChildWin)
			$Checkbox_IEFav = GUICtrlCreateCheckbox("Backup IE Favs", 1,0)
			$Checkbox_Desktop = GUICtrlCreateCheckbox("Backup Desktop", 1, 20)
			$Checkbox_printers = GUICtrlCreateCheckbox("Backup Printers", 1, 40)
			$Checkbox_Outlook = GUICtrlCreateCheckbox("Backup Outlook", 1, 60)
			$Checkbox_Documents = GUICtrlCreateCheckbox("Backup My Documents", 1, 80)
			$Button_ok = GUICtrlCreateButton("OK", 10, 100, 40)
			$Button_cancel = GUICtrlCreateButton("Cancel", 60, 100, 40)
			GUISetState(@SW_SHOW)
			While 1
				$msg = GUIGetMsg()
				Select
					Case $msg = $Button_cancel
						GUIDelete($ChildWin)
						ExitLoop
					Case $msg = $GUI_EVENT_CLOSE
						GUIDelete($ChildWin)
						ExitLoop
					Case $msg = $Button_ok
						$Outlook = GUICtrlRead($Checkbox_Outlook)
						$IEFavs = GUICtrlRead($Checkbox_IEFav)
						$Desktop = GUICtrlRead($Checkbox_Desktop)
						$Printers = GUICtrlRead($Checkbox_printers)
						$Documents = GUICtrlRead($Checkbox_Documents)
						GUIDelete($ChildWin)
						GUISwitch($parentWin)
						GUISetState(@SW_SHOW, $parentWin)
						If $Outlook = 1 Then
							copy_Outlook()
						EndIf
						If $IEFavs = 1 Then
							copy_Favs()
						EndIf
						If $Documents = 1 Then
							copy_Docs()
						EndIf
						If $Desktop = 1 Then
							copy_Desktop()
						EndIf
						If $Printers = 1 Then
							usr_SavePrinterScript()
						EndIf
						;PortADToFile()
						GUICtrlSetData($progressbar, 100)
						GUICtrlSetData($label, $done)
						GUISetState()
						$oldComputer = FileOpen($ISPath & '\' & @UserName & '\oldComputer.log', 2)
						FileWriteLine($oldComputer, @ComputerName)
						FileClose($oldComputer)
						FileWriteLine($BackupFile, "*" & @MON & "/" & @MDAY & " - " & @HOUR & ":" & @MIN & "-> Backup of: " & @ComputerName & " was Successful for User: " & @UserName & " @ " & $ISPath & "*" & @CRLF)
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						;;; END Choose what to Backup;;;;;;;;
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						ExitLoop
				EndSelect
			WEnd
			GUISwitch($parentWin)
			GUISetState(@SW_SHOW, $parentWin)
		Case $msg = $aboutButton
			MsgBox(0, "About", "This program is made for Backup/Restore purposes." & @LF & @LF & "The Backup button will save Outlook, Internet Favorites, Desktop Icons and Printers. Also Put the My Documents on the H drive." & @LF & "The Restore button will load Outlook, Internet Favorites, Desktop Icons and Printers." & @LF & "NOTE: This ONLY works when that particular user is logged into the PC!" & @LF & @LF & @LF & "The Backup Remote PC with the right input will ONLY backup Outlook, Desktop Icons and Internet Favorites for now." & @LF & @LF & @LF & "-Chris Erickson-"& @LF & "Associate Systems Admin - Esker Software 2009")
	EndSelect
WEnd

;Func PortADToFile()
;	$dsquery = 'dsquery computer "OU=Madison,DC=esker,DC=corp" -name '& @ComputerName&' > "'&$ISPath & '\' & @UserName & '\ComputerDN.txt"'
;	_RunDOS($dsquery)
;	$computerOU = FileReadLine($ISPath & '\' & @UserName & '\ComputerDN.txt')
;	_RunDOS('dsget computer '&$computerOU&' -memberof > "'&$ISPath & '\' & @UserName & '\ComputerGroups.txt')
;	FileClose($computerOU)
;	$computerOU = FileOpen($ISPath & '\' & @UserName & '\ComputerGroups.txt',0)
;	$computerDN = FileReadLine($ISPath & '\' & @UserName & '\ComputerDN.txt')
;	$batchfile = FileOpen($ISPath & '\' & @UserName & '\DSMOD.bat',2)
;	While 1
 ;   $line = FileReadLine($computerOU)
;	If @error = -1 Then ExitLoop
;	$dsmod = 'dsmod group '&$line&' -addmbr '& $computerDN 
;	FileWriteLine($batchfile,$dsmod)
;	Wend
;	FileClose($computerDN)
;	FileClose($computerOU)
;EndFunc ;==>PortADToFile

;Func PortADFromFile()
;	RunAs($username,"corp",$password,0,$ISPath & '\' & @UserName & '\DSMOD.bat',"",@SW_HIDE)
;EndFunc ;==>PortADFromFile

Func copy_Outlook()
	GUICtrlSetData($progressbar, 0)
	GUICtrlSetData($label, $copyOutlook)
	FileCopy($backupOutlookDir & '\*',$ISPath & '\' & @UserName & '\Outlook\NK2\', 9)
EndFunc   ;==>copy_Outlook

Func copy_Favs()
	GUICtrlSetData($progressbar, 25)
	GUICtrlSetData($label, $copyFavs)
	DirCopy($backupFavsDir, $ISPath & "\" & @UserName & '\favs\', 1)
EndFunc   ;==>copy_Favs

Func copy_Docs()
	GUICtrlSetData($progressbar, 40)
	GUICtrlSetData($label, $copyDocs)
	$test = DirCopy(@MyDocumentsDir, $ISPath & "\" & @UserName & '\documents\', 1)
	if $test = 0 Then
		MsgBox(1,"Error","There was an error in copying the My Docs over!")
	EndIf
EndFunc   ;==>copy_Docs

Func copy_Desktop()
	GUICtrlSetData($progressbar, 50)
	GUICtrlSetData($label, $copyDesktop)
	DirCopy($backupDeskDir, $ISPath & "\" & @UserName & '\desktop\', 1)
	DirCopy($backupDeskAllUserDir, $ISPath & "\" & @UserName & '\alluserDesktop\', 1)
EndFunc   ;==>copy_Desktop

Func usr_SavePrinterScript()
	GUICtrlSetData($progressbar, 90)
	GUICtrlSetData($label, $copyPrinters)
	Local $strSaveLocation
	Local $ptrFile, $ptrGui
	Local $strDefaultPrinter = usr_GetDefaultPrinter()
	Local $arrPrinters = usr_GetPrinters("NETWORK")
	Local $arrCheckBox[$arrPrinters[0] + 1]
	Local $intGUIHeight = 100 + ($arrPrinters[0] * 20)
	Local $intGUIWidth = 300
	Local $intRow = 10
	Local $intGUIGroupHeight = 25 + ($arrPrinters[0] * 20)
	Local $buttonSave
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $strSaveLocation = $ISPath & '\' & @UserName & '\PrinterMap.bat'
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Save File
	
	If Not @error Then;save the file
		$ptrFile = FileOpen($strSaveLocation, 10)
		
		;Write headers
		FileWriteLine($ptrFile, "REM on " & @MON & "/" & @MDAY & "/" & _
				@YEAR & " at " & @HOUR & ":" & @MIN & ":" & @SEC)
		FileWriteLine($ptrFile, "")
		FileWriteLine($ptrFile, "@echo off")
		FileWriteLine($ptrFile, "cls")
		FileWriteLine($ptrFile, "Title Auto Printer")
		FileWriteLine($ptrFile, "")
		FileWriteLine($ptrFile, "echo Auto Printer Mapper")
		FileWriteLine($ptrFile, "echo Generated for " & @UserName)
		FileWriteLine($ptrFile, "echo on " & @ComputerName)
		FileWriteLine($ptrFile, "echo at " & @MON & "/" & @MDAY & "/" & _
				@YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC)
		FileWriteLine($ptrFile, "echo -----------------------------------------")
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		FileWriteLine($ptrFile, "echo !         Esker Printer Backup          !")
		FileWriteLine($ptrFile, "echo !                                       !")
		FileWriteLine($ptrFile, "echo !                Script                 !")
		FileWriteLine($ptrFile, "echo !                                       !")
		FileWriteLine($ptrFile, "echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "echo This script will map the following Printers:")
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "")

		For $i = 1 To $arrPrinters[0]
			FileWriteLine($ptrFile, "echo " & $arrPrinters[$i])
		Next
		
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "echo Default Printer will be: " & $strDefaultPrinter)
		
		FileWriteLine($ptrFile, "")
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "")
		
		FileWriteLine($ptrFile, "echo.")
		
		For $i = 1 To $arrPrinters[0]
			FileWriteLine($ptrFile, "echo Mapping Printer: " & $arrPrinters[$i])
			FileWriteLine($ptrFile, 'rundll32 printui.dll,PrintUIEntry /in /q /n' & $arrPrinters[$i])
		Next
		
		FileWriteLine($ptrFile, "echo.")
		FileWriteLine($ptrFile, "echo Mapping Default Printer: " & $strDefaultPrinter)
		FileWriteLine($ptrFile, 'rundll32 printui.dll,PrintUIEntry /y /n' & $strDefaultPrinter)
		
		
		FileWriteLine($ptrFile, "echo Finished!")
		
		FileClose($ptrFile)
	EndIf
	
	
EndFunc   ;==>usr_SavePrinterScript

Func usr_GetPrinters($strType)
	Local $intPrinterLimit = 20
	Local $intPrinterCount = 0
	Local $arrPrinters[$intPrinterLimit + 1]
	Local $strReg
	Local $strRegKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices"
	
	If @OSTYPE = "WIN32_NT"  Then
		Switch $strType
			Case "NETWORK"
				;Get Network Printers
				For $i = 1 To $intPrinterLimit
					$strReg = RegEnumVal($strRegKey, $i)
					If @error = -1 Then ExitLoop
					If StringInStr($strReg, "\\") <> 0 Then
						$arrPrinters[$intPrinterCount + 1] = $strReg
						$intPrinterCount += 1
					EndIf
				Next
			Case "LOCAL"
				;Get Local Printers
				For $i = 1 To $intPrinterLimit
					$strReg = RegEnumVal($strRegKey, $i)
					If @error = -1 Then ExitLoop
					If StringInStr($strReg, "\\") = 0 Then
						$arrPrinters[$intPrinterCount + 1] = $strReg
						$intPrinterCount += 1
					EndIf
				Next
			Case "ALL"
				;Get All Printers
				For $i = 1 To $intPrinterLimit
					$strReg = RegEnumVal($strRegKey, $i)
					If @error = -1 Then ExitLoop
					$arrPrinters[$intPrinterCount + 1] = $strReg
					$intPrinterCount += 1
				Next
		EndSwitch
	EndIf
	
	$arrPrinters[0] = $intPrinterCount
	
	Return $arrPrinters
EndFunc   ;==>usr_GetPrinters


Func usr_GetDefaultPrinter()
	Local $strDefaultPrinter
	Local $strKey
	
	If @OSTYPE = "WIN32_WINDOWS"  Then
		$strDefaultPrinter = RegRead("HKEY_CURRENT_CONFIG\System\CurrentControlSet\Control\Print\Printers", "Default")
	Else;WIN_NT type
		$strKey = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device")
		$strDefaultPrinter = StringLeft($strKey, StringInStr($strKey, ",") - 1)
	EndIf
	Return $strDefaultPrinter
EndFunc   ;==>usr_GetDefaultPrinter