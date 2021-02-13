#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Database.ico
#AutoIt3Wrapper_outfile=..\redLabel sqlInstaller.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<ButtonConstants.au3>
#include<GUIConstants.au3>
#include<EditConstants.au3>
#include<StaticConstants.au3>
#include<WindowsConstants.au3>

If @OSArch = "X86" Then
	$dlPackage = "http://go.microsoft.com/?linkid=9729746"
	$HKLM = "HKLM"
Else
	$dlPackage = "http://go.microsoft.com/?linkid=9729747"
	$HKLM = "HKLM64"
EndIf

$guiTile = "redLabel® sqlInstaller"
$guiIcon = @ScriptDir & "\Needed Assemblies\database.ico"

;EVENTS

$msgboxInstallWarning = MsgBox(36, $guiTile, "This application will download, install, and configure SQL Express 2008 R2 without any user intervention.  Are you sure you wish to continue?")
If $msgboxInstallWarning = 7 Then
	Exit
Else
	_SQLRequirements()
	$sqlinstance = _SQLInstance()
	_SQLDownload()
	_SQLInstall()
	Exit
EndIf

;FUNCTIONS

Func _SQLRequirements()
	$guiSQLRequirements = GUICreate($guiTile, 325, 200)
	GUISetIcon($guiIcon)
	GUISetState()
	$iconRefresh = GUICtrlCreateIcon(@ScriptDir & "\Refresh.ico", 4, 272.5, 0)
	GUICtrlSetState($iconRefresh, $gui_hide)
	GUICtrlCreateLabel("Checking for Microsoft® Windows® Installer Version.", 25, 25)
	GUICtrlCreateLabel("Checking for Microsoft® Windows® PowerShell Version.", 25, 75)
	GUICtrlCreateLabel("Checking for Microsoft® Windows® .NET Version 3.5.", 25, 125)
	$buttonInstallerLinks = GUICtrlCreateButton("Installer links", 25, 165, 75)
	GUICtrlSetState(-1, $gui_disable)
	$buttonCancel = GUICtrlCreateButton("Cancel", 150, 165, 75)
	GUICtrlSetState(-1, $gui_disable)
	$buttonAccept = GUICtrlCreateButton("OK", 225, 165, 75)
	GUICtrlSetState(-1, $gui_disable)
	Sleep(1000)
	$msiVersion = FileGetVersion(@SystemDir & "\msi.dll")
	If $msiVersion >= 4.5 Then
		GUICtrlCreateLabel("Current version: " & $msiVersion, 25, 40)
		GUICtrlCreateLabel("PASSED!", 250, 40)
	Else
		GUICtrlCreateLabel("Current version: " & $msiVersion, 25, 40)
		GUICtrlCreateLabel("FAILED!", 250, 40)
	EndIf
	Sleep(1000)
	$powershellVersion = RegRead($HKLM & "\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine", "PowerShellVersion")
	If @error <> 0 Or $powershellVersion < 2.0 Then
		GUICtrlCreateLabel("Current version: " & $powershellVersion, 25, 90)
		GUICtrlCreateLabel("FAILED!", 250, 90)
	Else
		GUICtrlCreateLabel("Current version: " & $powershellVersion, 25, 90)
		GUICtrlCreateLabel("PASSED!", 250, 90)
	EndIf
	Sleep(1000)
	$netframeworkVersion = RegRead($HKLM & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5", "Version")
	If @error <> 0 Then
		GUICtrlCreateLabel("FAILED!", 250, 140)
	Else
		GUICtrlCreateLabel("Current version: " & $netframeworkVersion, 25, 140)
		GUICtrlCreateLabel("PASSED!", 250, 140)
	EndIf
	Sleep(1000)

	GUICtrlSetState($buttonCancel, $gui_enable)

	If $msiVersion >= 4.5 And $powershellVersion >= 2.0 And $netframeworkVersion >= 3.5 Then
		GUICtrlSetState($buttonAccept, $gui_enable)
		GUICtrlSetState($buttonAccept, $gui_defbutton)
	Else
		GUICtrlSetState($buttonInstallerLinks, $gui_enable)
		GUICtrlSetState($buttonInstallerLinks, $gui_defbutton)
		MsgBox(48, $guiTile, "Some SQL Requirement(s) checks failed, please use the 'Installer Links' button for links to The required components that must be installed first to continue with this installation.")
		GUISetState($iconRefresh, $gui_show)
	EndIf


	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $gui_event_close, $buttonCancel
				Exit
			Case $iconRefresh
				GUIDelete($guiSQLRequirements)
				_SQLRequirements()
			Case $buttonInstallerLinks
				$guiDownloads = GUICreate($guiTile, 325, 150)
				GUISetIcon($guiIcon)
				GUISetState()
				GUICtrlCreateLabel("Download Links:", 25, 25)
				$downloadInstaller = GUICtrlCreateLabel("Microsoft® Windows® Installer v4.5", 25, 50)
				GUICtrlSetColor(-1, 0x0000FF)
				GUICtrlSetFont(-1, 8.5, 400, 4)
				GUICtrlSetCursor(-1, 0)
				$downloadPowerShell = GUICtrlCreateLabel("Microsoft® Windows® PowerShell v2.0", 25, 65)
				GUICtrlSetColor(-1, 0x0000FF)
				GUICtrlSetFont(-1, 8.5, 400, 4)
				GUICtrlSetCursor(-1, 0)
				$downloadNetFramework = GUICtrlCreateLabel("Microsoft® Windows® .Net Framework v3.5", 25, 80)
				GUICtrlSetColor(-1, 0x0000FF)
				GUICtrlSetFont(-1, 8.5, 400, 4)
				GUICtrlSetCursor(-1, 0)
				$buttonDone = GUICtrlCreateButton("Done", 225, 100, 75)
				While 1
					$msg = GUIGetMsg()
					Switch $msg
						Case $gui_event_close, $buttonDone
							GUIDelete($guiDownloads)
							ExitLoop
						Case $downloadInstaller
							ShellExecute("http://www.microsoft.com/downloads/en/details.aspx?FamilyID=5a58b56f-60b6-4412-95b9-54d056d6f9f4&displaylang=en")
						Case $downloadPowerShell
							ShellExecute("http://support.microsoft.com/kb/968929")
						Case $downloadNetFramework
							ShellExecute("http://www.microsoft.com/downloads/en/details.aspx?FamilyId=333325fd-ae52-4e35-b531-508d977d32a6&displaylang=en")
					EndSwitch
				WEnd
			Case $buttonAccept
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func _SQLInstance()
	$guiSQLInstance = GUICreate($guiTile, 300, 150)
	GUISetIcon($guiIcon)
	GUISetState()
	GUICtrlCreateLabel("Instance Name: ", 25 ,25)
	$inputInstaceName = GUICtrlCreateInput("MSSQLSERVER", 25, 50, 250)
	$buttonAccept = GUICtrlCreateButton("OK", 200, 100, 75)
		GUICtrlSetState($buttonAccept, $gui_defbutton)
	$buttonCancel = GUICtrlCreateButton("Cancel", 125, 100, 75)

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $buttonAccept
				$instanceName = GUICtrlRead($inputInstaceName)
				$x = 0
				Do
					$x += 1
					$instances = RegEnumVal($HKLM & "\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL", $x)
				Until @error <> 0 Or $instances = $instanceName
				If $instanceName = $instances Then
					If @OSArch = "X86" Then
						$msgboxX86DL = MsgBox(52, "redLabel® SQL Installer", "SQL Server Setup cannot continue." & @CRLF & @CRLF & "An instance named '" & $instanceName & "' already exists on this system." & @CRLF & "Please install manually or use the pre-existing instance of SQL." & @CRLF & @CRLF & "Would you like to download the SQL Install Package?")
						If $msgboxX86DL = 6 Then
							ShellExecute("http://go.microsoft.com/?linkid=9729746")
						EndIf
					Else
						$msgboxX64DL = MsgBox(52, "redLabel® SQL Installer", "SQL Server Setup cannot continue." & @CRLF & @CRLF & "An instance named '" & $instanceName & "' already exists on this system." & @CRLF & "Please install manually or use the pre-existing instance of SQL." & @CRLF & @CRLF & "Would you like to download the SQL Install Package?")
						If $msgboxX64DL = 6 Then
							ShellExecute("http://go.microsoft.com/?linkid=9729747")
						EndIf
					EndIf
				Else
					GUIDelete()
					ExitLoop
				EndIf
			Case $buttonCancel
				$msgboxCancel = MsgBox(36, $guiTile, "Are you sure you want to exit '" & $guiTile & "'?")
				If $msgboxCancel = 6 Then
					Exit
				EndIf
		EndSwitch
	WEnd
	Return $instanceName
EndFunc

Func _SQLDownload()
	$download = InetGet($dlPackage, @TempDir & "\SQL2008Installer.exe", 16, 1)
	$guiDownload = GUICreate($guiTile, 300, 175)
	GUISetIcon($guiIcon)
	GUISetState()
	GUICtrlCreateLabel("Please wait, the SQL installer is being downloaded...", 25, 25)
	$progressDownload = GUICtrlCreateProgress(25, 75, 250)
	GUICtrlCreateLabel("Downloaded: ", 25, 100)
	GUICtrlCreateLabel("(This could take several minutes to complete.)", 25, 125)
	$totalSize = InetGetSize($dlPackage)
	Sleep(2500)
	WinSetTitle($guiDownload, '', '')
	Sleep(1000)
	Do
		$currentSize = InetGetInfo($download, 0)
		$sizetoset = StringLeft($currentSize / $totalSize, 4) * 100
		GUICtrlSetData($progressDownload, $sizetoset)
		WinSetTitle($guiDownload, '', $sizetoset & "% " & " Downloaded")
		GUICtrlCreateLabel($currentSize & " / " & $totalSize & " Bytes", 90, 100)
		Sleep(1000)
	Until InetGetInfo($download, 2)
	InetClose($download)
	GUIDelete($guiDownload)
	MsgBox(0, '', "the download is complete", 2.5)
EndFunc

Func _SQLInstall()
	ShellExecuteWait(@TempDir & '\SQL2008Installer.exe', ' /QS /ACTION=Install /FEATURES=SQLEngine,FullText,Tools /INSTANCENAME=' & '"' & $sqlinstance & '"' & ' /SQLSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" /ADDCURRENTUSERASSQLADMIN /IACCEPTSQLSERVERLICENSETERMS')
	MsgBox(0, "redLabel® SQL Installer", "SQL Express 2008 installed sucsessfully")
	$msgboxDeleteInstaller = MsgBox(36, "redLabel® SQL Installer", "Would you like to delete the SQL installation package?")
	If $msgboxDeleteInstaller = 6 Then
		FileDelete(@TempDir & "\SQL2008Installer.exe")
	Else
		Exit
	EndIf
EndFunc