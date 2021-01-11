$sInstallPath = RegRead("HKCU\Software\Winamp", "")
If $sInstallPath = "" Then
	MsgBox(48, "Error", "You must have Winamp installed before running this script!" & _
			@CRLF & @CRLF & "The Winamp download page will now be opened for you.")
	Run(@ComSpec & " /c Start http://www.winamp.com/player/free.php", @WorkingDir, @SW_HIDE)
	Exit
EndIf

If Not FileExists($sInstallPath & "\Plugins\gen_activewa.dll") Then
	$iMsgBox = MsgBox(4, "ActiveWinamp", "Would you like to download and install ActiveWinamp now?")
	Switch $iMsgBox
		Case 6
			$sDownloadPath = "http://www.winamp.com/plugins/details.php?id=143299&download=yes" & _
					"&url=http%3A%2F%2Fdownload.nullsoft.com%2Fcustomize%2Fcomponent%2F2004%2F11%2F2%2FP%2FActiveWinamp.exe"
			$iDownloadSize = InetGetSize($sDownloadPath)
			InetGet($sDownloadPath, @TempDir & "\ActiveWinamp.exe", 0, 1)
			While @InetGetActive
				TrayTip("Download Progress", "Downloading " & Round(@InetGetBytesRead / 1024) & "KB of " & Round($iDownloadSize / 1024) & "KB", 0, 16)
				Sleep(100)
			WEnd
			TrayTip("", "", 0)
			If FileExists(@TempDir & "\ActiveWinamp.exe") Then
				RunWait(@TempDir & "\ActiveWinamp.exe", @WorkingDir)
				If FileExists($sInstallPath & "\Plugins\gen_activewa.dll") Then
					MsgBox(0, "Installation Successful", "You are now ready to use WinAmp.au3!")
					Exit
				Else
					MsgBox(48, "Installation Failed", "Something went wrong with the install, please try running this script again.")
					Exit
				EndIf
			Else
				MsgBox(48, "Error Downloading File", "Please download and install the file manually." & _
						@CRLF & @CRLF & "The download site will be opened for you at this time.")
				Run(@ComSpec & " /c Start http://www.winamp.com/plugins/details.php?id=143299", @WorkingDir, @SW_HIDE)
				Exit
			EndIf
		Case 7
			Exit
		Case Else
			Exit
	EndSwitch
Else
	MsgBox(0, "ActiveWinamp", "You already have ActiveWinamp installed!")
EndIf