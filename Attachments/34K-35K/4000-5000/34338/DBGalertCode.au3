#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *******************************************************
; DailyGammon.com move alert
; *******************************************************
;
#include <IE.au3>
#include <INet.au3>
#include <Constants.au3>

;Delete au3 code file from older versions
FileDelete(@ScriptDir & "\DBGalertCode.au3")

;Current version info
$CurrentVersion = "0.7"

;Make sure tray icon is visible, set to show die icon
Opt("TrayMenuMode",1)
TraySetIcon(@ScriptDir & "\dice.ico")

;Create tray menu
$Site = TrayCreateItem("Top Page")
TrayCreateItem("")
$LoopTray = TrayCreateItem("Set Check Interval")
TrayCreateItem("")
$SoundTray = TrayCreateItem("Toggle Sound")
TrayItemSetState($SoundTray,$TRAY_CHECKED)
$SoundSet = TrayCreateItem("Set Custom Sound")
TrayCreateItem("")
$UpdateCheck = TrayCreateItem("Check for Updates")
TrayCreateItem("")
$Help = TrayCreateItem("Help")
$About = TrayCreateItem("About")
TrayCreateItem("")
$Exit = TrayCreateItem("Exit")

;Read settings from txt or create new if not exist
$Settings = @ScriptDir & "\Settings.txt"
$TestTxt = FileExists($Settings)
If $TestTxt = 1 Then
	$Loopcount = FileReadLine(@ScriptDir & "\Settings.txt",1)
	$SoundOnOff = FileReadLine(@ScriptDir & "\Settings.txt",2)
	$UpdateAtStart = FileReadLine(@ScriptDir & "\Settings.txt",3)
	$Sound = FileReadLine(@ScriptDir & "\Settings.txt",4)
Else
	FileWriteLine(@ScriptDir & "\Settings.txt", "20")
	FileWriteLine(@ScriptDir & "\Settings.txt", "0")
	FileWriteLine(@ScriptDir & "\Settings.txt", "0")
	FileWriteLine(@scriptdir & "\Settings.txt", @ScriptDir & "\Ding.wav")
	$Loopcount = FileReadLine(@ScriptDir & "\Settings.txt",1)
	$SoundOnOff = FileReadLine(@ScriptDir & "\Settings.txt",2)
	$UpdateAtStart = FileReadLine(@ScriptDir & "\Settings.txt",3)
	$Sound = FileReadLine(@ScriptDir & "\Settings.txt",4)
EndIf

;check for updates at start
If $UpdateAtStart = 0 Then
	$SuppressCurrent = 0
	UpdateCheck()
EndIf

$PlayedSound = 0  ;check whether to ding when new turns found(different than sound on/off setting)
$TempLoop = $Loopcount

;stuff
While 1

    $msg = TrayGetMsg()
	TraySetToolTip("Check interval: " & $Loopcount)
    Select
		Case $msg = 0
            If $TempLoop >= $Loopcount Then
				$oIE = _IECreate('                             ',0,0,1,0)
				$sText = _IEBodyReadText ($oIE)
					If StringInStr($sText, "Hello! Welcome to the DailyGammon web site. Please log in.") Then
						MsgBox (262192,"Attention!", "You are not currently logged into DailyGammon in Internet Explorer. Please manually log in with Internet Explorer at                        (NO WWW!) then launch this program again.")
						_IEQuit($oIE)
						Exit
					EndIf

					If StringInStr($sText, "Matches where you can move:",1) Then
						If $PlayedSound = 0 Then
							If $SoundOnOff = 0 Then
								If FileExists($Sound) Then
									SoundPlay($Sound)
								Else
									$Sound = @ScriptDir & "\Ding.wav"
									FileDelete($Settings)
									FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
									FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
									FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
									FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
									SoundPlay($Sound)
								EndIf
							EndIf
							$PlayedSound = 1
						EndIf
						TraySetState(4)
					Else
						TraySetState(8)
						If $PlayedSound = 1 Then
							$PlayedSound = 0
						EndIf
					EndIf

				_IEQuit($oIE)
				$TempLoop = 0
			Else
				$TempLoop = $TempLoop + 1
				Sleep(1000)
			EndIf
        Case $msg = $Site
            ShellExecute("                             ")
			TrayItemSetState($Site,$TRAY_UNCHECKED)
        Case $msg = $SoundTray
			If $SoundOnOff = 0 Then
				$SoundOnOff = 1
			Else
				$SoundOnOff = 0
			EndIf
			FileDelete($Settings)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
			FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
			FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
		Case $msg = $SoundSet
			$TempSound = $Sound
			$Sound = FileOpenDialog("User Sound", EnvGet("userprofile") & "\desktop", "Wav files (*.wav)",1)
			If @error = 1 Then
				$Sound = $TempSound
			EndIf
			FileDelete($Settings)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
			FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
			FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
			TrayItemSetState($SoundSet,$TRAY_UNCHECKED)
		Case $msg = $LoopTray
			$TempInput = InputBox("Check Interval", "Enter interval check period in whole seconds 5 or greater", $Loopcount,"",150,150)
			If $TempInput > 4 Then
				$Loopcount = $TempInput
				FileDelete($Settings)
				FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
				FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
				FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
				FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
			EndIf
			TrayItemSetState($LoopTray,$TRAY_UNCHECKED)
		Case $msg = $UpdateCheck
			TrayItemSetState($UpdateCheck,$TRAY_UNCHECKED)
			UpdateCheck()
		Case $msg = $Help
			MsgBox(0, "Help", "Top Page" & @TAB & @TAB & "-> Launch default browser to Top Page of DailyGammon" & @CR & @CR & _
			"Set Check Interval" & @TAB & "-> Change how many seconds between checks for turns" & @CR & @CR & _
			"Toggle Sound" & @TAB & "-> Turn sound alert on or off (checkmark indicates on)" & @CR & @CR & _
			"Set Custom Sound" & @TAB & "-> Pick your own Wav file to use as turn alert" & @CR & @CR & _
			"Check for Updates" & @TAB & "-> Check online for newer version" & @CR & @CR & _
			"Help" & @TAB & @TAB & "-> You're here..." & @CR & @CR & _
			"About" & @TAB & @TAB & "-> Version info & URL for comments, bugs, etc")
			TrayItemSetState($Help,$TRAY_UNCHECKED)
		Case $msg = $About
			MsgBox(0,"DG Alert", "Version: " & $CurrentVersion & @CR & @CR & "Comments, bugs, etc:" & @CR & @CR & "http://goo.gl/m85O3", 30)
			TrayItemSetState($About,$TRAY_UNCHECKED)
		Case $msg = $Exit
			Exit
    EndSelect

WEnd

Func UpdateCheck()
	FileDelete(@ScriptDir & "\OnlineVersion.txt")
	InetGet("http://dl.dropbox.com/u/9468568/OnlineVersion.txt", @ScriptDir & "\OnlineVersion.txt",1,0)
	$OnlineVersion = FileReadLine(@ScriptDir & "\OnlineVersion.txt",1)
	If $OnlineVersion > $CurrentVersion Then
		$DownloadResponse = MsgBox(262147,"Download","There is a newer version available. Click Yes to download, No to skip and check at startup, or Cancel to skip and don't check at startup.")
		If $DownloadResponse = 6 Then
			MsgBox(0,"","Download will begin after clicking OK. To maintain current settings, unzip and replace exe files in current directory.")
			$DownLoc = FileOpenDialog("Download", EnvGet("userprofile") & "\desktop", "Zip files (*.zip)", 2, "DBGalert.zip")
			InetGet("http://db.tt/Krrixwu",$DownLoc,1,1)
		ElseIf $DownloadResponse = 2 Then
			$UpdateAtStart = 1
			FileDelete($Settings)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
			FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
			FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
		ElseIf $DownloadResponse = 7 Then
			$UpdateAtStart = 0
			FileDelete($Settings)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Loopcount)
			FileWriteLine(@ScriptDir & "\Settings.txt", $SoundOnOff)
			FileWriteLine(@ScriptDir & "\Settings.txt", $UpdateAtStart)
			FileWriteLine(@ScriptDir & "\Settings.txt", $Sound)
		EndIf
	Else
		If $SuppressCurrent <> 0 Then
			MsgBox(0,"", "You have the most recent version: " & $CurrentVersion,30)
		Else
			$SuppressCurrent = 1
		EndIf
	EndIf
EndFunc