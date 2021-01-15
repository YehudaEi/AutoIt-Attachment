#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=PointingUser.ICO
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=                                   
#AutoIt3Wrapper_Res_Description=LaunchAsAdminInstaller
#AutoIt3Wrapper_Res_Fileversion=0.1.4.1
#AutoIt3Wrapper_Res_LegalCopyright=©2007 Michael Michta
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
If $CmdLine[0] < 1 Then
	$SendTo = RegRead('HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Sendto')
	Switch FileExists($SendTo & "\LaunchAsAdmin.exe")
		Case False
			$MB = MsgBox(4, "LaunchAsAdmin", "Would you like to install LaunchAsAdmin in your SendTo context menu?")
			If $MB = 6 Then
				FileInstall("LaunchAsAdmin.exe", $SendTo & "\LaunchAsAdmin.exe")
				MsgBox(0, "LaunchAsAdmin", "LaunchAsAdmin has been installed into your SendTo context menu.")
				Exit
			EndIf
		Case True
			$MB = MsgBox(4, "LaunchAsAdmin", "Would you like to delete LaunchAsAdmin from your SendTo context menu?")
			If $MB = 6 Then
				FileDelete($SendTo & "\LaunchAsAdmin.exe")
				MsgBox(0, "LaunchAsAdmin", "LaunchAsAdmin has been removed.")
			EndIf
	EndSwitch
	Exit
EndIf