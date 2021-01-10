#include <GuiConstants.au3>
#include <File.au3>

; Sample script for chained install with manual selection of options. would work better if installers were of .msi flavor
; then one would use msiexec switches to automate installation rather than control type functions
; Most post modifications like turning the updater off for Abobe Reader can be done via RegWrite and a little Internet research

;Of course there are many other ways to whip this puppy, probably cleaner ways, but I am just a beginner like you if you really need this kind of info

; You might want to add something to turn off tamper protection if provided by your choice of antivirus


$ScriptLaunch = MsgBox(1, "What do you want to do?", "Run Script?") ; Give you option to cancel out of script
				If $ScriptLaunch  == 1 Then
					EndIf
				If $ScriptLaunch  = 2 Then
					Exit
					EndIf
				
If Not FileExists(@ScriptDir & "\Install.log") Then ; Creates install log in the location of the script if it doesn't exist
    _FileCreate(@ScriptDir & "\Install.log")
EndIf

$InstallLog = @ScriptDir & "\Install.log" ; Variable used later to access install log

;you might want to make this a function so that you could check after each install. If present after an install either wait or terminate script, you call
If ProcessExists("msiexec.exe") Then 
	$PROC_MSIExec_1 = MsgBox(1, "running Process Check", "Do you wish to terminate the running instance MSIExec?") ; more code needed if you suspect more than one instance of msiexec might be running
						If $PROC_MSIExec_1  == 1 Then
							ProcessClose("msiexec.exe")
								$PROC_MSIExec_1a = ProcessExists("msiexec.exe") 
									If $PROC_MSIExec_1a  == 0 Then
										_FileWriteLog ($InstallLog, "Process check returned 0, The process msiexec.exe does not exist")
									ElseIf $PROC_MSIExec_1a <> 0  Then
										MsgBox(0, "Warning", "Msiexec.exe is still a running process on this system. Please troubleshoot. Now exiting",8)
										Exit
									EndIf
						ElseIf $PROC_MSIExec_1 = 2 Then
							Exit
						EndIf
EndIf						
;UPHCleanv1.6.30 you might download from Microsoft and install to ensure that no other user profiles still have locks on system resources, your call. Do some research. 
;or you might manually check by looking in the registry under HKEY_USERS to see if any are loaded beyond those expected to be there
$UPHClean_1 = FileGetVersion("C:\Program Files\UPHClean\uphclean.exe")
$UPHClean_2 = FileGetVersion("C:\Program Files\UPHClean\uphclean.exe","InternalName")
	Select
		Case $UPHClean_1 = "1.6.30.0"
			MsgBox(0, 'UPHCleanv1.6.30.0 Installed', 'UPHCleanv1.6.30 already installed, please troubleshoot possible corrupt installation; Continuing script.',4)
			_FileWriteLog ($InstallLog,"UPHClean 1.6.30.0 is already installed. Installation of 1.6.30.0 bypassed.")
		Case Else
			$UPHClean_1a = MsgBox(1, "UPHCleanv1.6.30.0", "Complete Install?")
				If $UPHClean_1a  == 1 Then
					RunWait('msiexec /I "UPHCleanv1.6.30\UPHClean-Setup.msi"')
						$UPHClean_1b = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FF77941A-2BFA-4A18-BE2E-69B9498E4D55}", "DisplayVersion")
							If $UPHClean_1b  == "1.6.30.0" Then
								_FileWriteLog ($InstallLog, @UserName & " - " & "Installed UPHCleanv1.6.30.0")
							ElseIf $UPHClean_1b =  0  Then
							EndIf
				ElseIf $UPHClean_1a  = 2 Then
					EndIf
	EndSelect
;AdobeFlashPlayer9.0.124.0
$AdobeFlash_1 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8E9DB7EF-5DD3-499E-BA2A-A1F3153A4DF8}", "DisplayVersion")
$AdobeFlash_1a = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{58BAA8D0-404E-4585-9FD3-ED1BB72AC2EE}", "DisplayVersion")
	Select
		Case $AdobeFlash_1 = "9.0.115.0"
			MsgBox(0, 'AdobeFlashPlayer 9.0.115.0 Installed', 'AdobeFlashPlayer 9.0.115.0 installed, please remove before installing 9.0.124.0; Skipping Install.',4)
			_FileWriteLog ($InstallLog, "AdobeFlashPlayer 9.0.115.0 is installed. Please remove and re-run script. Installation of 9.0.124.0 bypassed.")
		Case $AdobeFlash_1a = "9.0.124.0"
			MsgBox(0, 'AdobeFlashPlayer9.0.124.0 Installed', 'AdobeFlashPlayer 9.0.124.0 already installed, please troubleshoot possible corrupt installation; now exiting.',4)
			_FileWriteLog ($InstallLog, "AdobeFlashPlayer 9.0.124.0 is already installed. Installation of 9.0.124.0 bypassed.")
		Case Else
			$AdobeFlash_1b = MsgBox(1, "AdobeFlashPlayer9.0.124.0", "Complete Install?")
				If $AdobeFlash_1b  == 1 Then
					RunWait("msiexec /I AdobeFlashPlayer9.0.124.0\install_flash_player_active_x.msi") ; Modify to your install location
						$AdobeFlash_1c = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{58BAA8D0-404E-4585-9FD3-ED1BB72AC2EE}", "DisplayVersion")
							If $AdobeFlash_1c  == "9.0.124.0" Then
								_FileWriteLog ($InstallLog, @UserName & " - " & "Installed AdobeFlashPlayer9.0.124.0"  )
							ElseIf $AdobeFlash_1c =  0  Then
							EndIf
				ElseIf $AdobeFlash_1b  = 2 Then
					EndIf
	EndSelect
; AdobeAcrobatReader 9.0.0 fair reference http://blog.stealthpuppy.com/deployment/deploying-adobe-reader-9-for-windows last accessed September 13, 2008
$AdobeAcrobat_1a = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A80000000002}", "DisplayVersion")
$AdobeAcrobat_1b = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A81000000003}", "DisplayVersion")
$AdobeAcrobat_1c = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A81100000003}", "DisplayVersion")
$AdobeAcrobat_1d = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A81200000003}", "DisplayVersion")
$AdobeAcrobat_1e = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A90000000001}", "DisplayVersion")
	Select
		Case $AdobeAcrobat_1a = "8.0.0"
			MsgBox(0, 'AdobeAcrobatReader 8.0.0 Installed', 'AdobeAcrobatReader 8.0.0 installed, please remove before installing 9.0.0; now exiting.',4)
			_FileWriteLog ($InstallLog,"AdobeAcrobatReader 8.0.0 is installed. Please remove and re-run script. Installation of 9.0.0 bypassed.")
		Case $AdobeAcrobat_1b = "8.1.0"
			MsgBox(0, 'AdobeAcrobatReader 8.1.0 Installed', 'AdobeAcrobatReader 8.1.0 installed, please remove before installing 9.0.0; now exiting.',4)
			_FileWriteLog ($InstallLog,"AdobeAcrobatReader 8.1.0 is installed. Please remove and re-run script. Installation of 9.0.0 bypassed.")
		Case $AdobeAcrobat_1c = "8.1.1"
			MsgBox(0, 'AdobeAcrobatReader 8.1.1 Installed', 'AdobeAcrobatReader 8.1.1 installed, please remove before installing 9.0.0; now exiting.',4)
			_FileWriteLog ($InstallLog,"AdobeAcrobatReader 8.1.0 is installed. Please remove and re-run script. Installation of 9.0.0 bypassed.")
		Case $AdobeAcrobat_1d = "8.1.2"
			MsgBox(0, 'AdobeAcrobatReader 8.1.2 Installed', 'AdobeAcrobatReader 8.1.2 installed, please remove before installing 9.0.0; now exiting.',4)
			_FileWriteLog ($InstallLog,"AdobeAcrobatReader 8.1.2 is installed. Please remove and re-run script. Installation of 9.0.0 bypassed.")
		Case $AdobeAcrobat_1e = "9.0.0"
			MsgBox(0, 'AdobeAcrobatReader 9.0.0 Installed', 'AdobeAcrobatReader 9.0.0 already installed, please troubleshoot possible corrupt installation; now exiting.',4)
			_FileWriteLog ($InstallLog,"AdobeAcrobatReader 9.0.0 is already installed. Installation of 9.0.0 bypassed.")
		Case Else
			$AdobeAcrobat_1f = MsgBox(1, "AdobeAcrobatReader 9.0.0", "Complete Install?")
				If $AdobeAcrobat_1f  == 1 Then
					RunWait("msiexec /I AdobeAcrobatReader9.0\AcroRead.msi") ; Modify to your install location
						$AdobeAcrobat_1g = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1033-7B44-A90000000001}", "DisplayVersion")
							If $AdobeAcrobat_1g  == "9.0.0" Then
								_FileWriteLog ($InstallLog, @UserName & " - " & "Installed AdobeAcrobatReader9.0.0"  )
							ElseIf $AdobeAcrobat_1g =  0  Then
								EndIf
				ElseIf $AdobeAcrobat_1f  = 2 Then
					EndIf
	EndSelect					
;AdobeShockwavePlayer 11.0.0.465
			$AdobeShockwave_1a = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Adobe Shockwave Player", "DisplayVersion")
			$AdobeShockwavel_1b = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{233C1507-6A77-46A4-9443-F871F945D258}", "Version")
				Select
					Case $AdobeShockwave_1a = "10.2.0.23"
						MsgBox(0, 'AdobeShockwavePlayer 10.2.0.23 Installed', 'AdobeShockwavePlayer 10.2.0.23 installed, please remove before installing 11.0.0.465; now exiting.',4)
						_FileWriteLog ($InstallLog,"AdobeShockwavePlayer 10.2.0.23 is installed. Please remove and re-run script. Installation of 11.0.0.465 bypassed.")
					Case $AdobeShockwavel_1b = "11,0,0,429"
						MsgBox(0, 'AdobeShockwavePlayer 11.0.0.429 Installed', 'AdobeShockwavePlayer 11.0.0.429 installed, please remove before installing 11.0.0.465; now exiting.',4)
						_FileWriteLog ($InstallLog,"AdobeShockwavePlayer 11.0.0.429 is installed. Please remove and re-run script. Installation of 11.0.0.465 bypassed.")
					Case $AdobeShockwavel_1b = "11,0,0,465"
						MsgBox(0, 'AdobeShockwavePlayer 11.0.0.465 Installed', 'AdobeShockwavePlayer 11.0.0.465 already installed, please troubleshoot possible corrupt installation; now exiting.',4)
						_FileWriteLog ($InstallLog,"AdobeShockwavePlayer 11.0.0.465 is already installed. Installation of 11.0.0.465 bypassed.")
					Case Else
						$AdobeShockwavel_1c = MsgBox(1, "AdobeShockwavePlayer 11.0.0.465", "Complete Install?")
						If $AdobeShockwavel_1c  == 1 Then
							RunWait("msiexec /I AdobeShockwavePlayer11.0.0.465\sw_lic_full_installer.msi") ; Modify to your install location
								$AdobeShockwavel_1d = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{233C1507-6A77-46A4-9443-F871F945D258}", "DisplayVersion")
									If $AdobeShockwavel_1d  == "9.0.0" Then
										_FileWriteLog ($InstallLog, @UserName & " - " & "Installed AdobeShockwavePlayer 11.0.0.465"  )
									ElseIf $AdobeShockwavel_1d =  0  Then
									EndIf
						ElseIf $AdobeShockwavel_1c  = 2 Then
						EndIf
					EndSelect					
;QuickTime7.50.61.0
			$QuickTime_1a = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{929408E6-D265-4174-805F-81D1D914E2A4}", "DisplayVersion") ;7.0.4
			$QuickTime_1b = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C21D5524-A970-42FA-AC8A-59B8C7CDCA31}", "DisplayVersion") ;7.1
			$QuickTime_1c = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F07B861C-72B9-40A4-8B1A-AAED4C06A7E8}", "DisplayVersion") ;7.1.3.100
			$QuickTime_1d = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5E863175-E85D-44A6-8968-82507D34AE7F}", "DisplayVersion") ;7.1.5.120
			$QuickTime_1e = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{08094E03-AFE4-4853-9D31-6D0743DF5328}", "DisplayVersion") ;7.1.6.200
			$QuickTime_1f = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{95A890AA-B3B1-44B6-9C18-A8F7AB3EE7FC}", "DisplayVersion") ;7.2.0.240
			$QuickTime_1g = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5B09BD67-4C99-46A1-8161-B7208CE18121}", "DisplayVersion") ;7.3.0.70
			$QuickTime_1h = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E0D51394-1D45-460A-B62D-383BC4F8B335}", "DisplayVersion") ;7.3.1.70
			$QuickTime_1i = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6EC874C2-F950-4B7E-A5B7-B1066D6B74AA}", "DisplayVersion") ;7.4.0.91
			$QuickTime_1j = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BFD96B89-B769-4CD6-B11E-E79FFD46F067}", "DisplayVersion") ;7.4.1.14
			$QuickTime_1k = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1838C5A2-AB32-4145-85C1-BB9B8DFA24CD}", "DisplayVersion") ;7.4.5.67
			$QuickTime_1l = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{08CA9554-B5FE-4313-938F-D4A417B81175}", "DisplayVersion") ;7.50.61.0
				Select
					Case $QuickTime_1a = "7.0.4"
						MsgBox(0, 'Quicktime 7.0.4', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.0.4 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1b = "7.1"
						MsgBox(0, 'Quicktime 7.1', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.1 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1c = "7.1.3.100"
						MsgBox(0, 'Quicktime 7.1.3.100', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.1.3.100 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1d = "7.1.5.120"
						MsgBox(0, 'Quicktime 7.1.5.120', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.1.5.120 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1e = "7.1.6.200"
						MsgBox(0, 'Quicktime 7.1.6.200', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.1.6.200 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1f = "7.2.0.240"
						MsgBox(0, 'Quicktime 7.2.0.240', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.2.0.240 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1g = "7.3.0.70"
						MsgBox(0, 'Quicktime 7.3.0.70', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.3.0.70 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1h = "7.3.1.70"
						MsgBox(0, 'Quicktime 7.3.1.70', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.3.1.70 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1i = "7.4.0.91"
						MsgBox(0, 'Quicktime 7.4.0.91', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.4.0.91 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1j = "7.4.1.14"
						MsgBox(0, 'Quicktime 7.4.1.14', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.4.1.14 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1k = "7.4.5.67"
						MsgBox(0, 'Quicktime 7.4.5.67', 'Please remove this version first. It is a non compliant version; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.4.5.67 is installed. Please remove and re-run script. Installation of 7.50.61.0 bypassed.")
					Case $QuickTime_1l = "7.50.61.0"
						MsgBox(0, 'QuickTime7.50.61.0 Installed', 'QuickTime7.50.61.0 already installed. Please troubleshoot a possible corrupt installation; now exiting.',4)
						_FileWriteLog ($InstallLog,"Quicktime 7.50.61.0 (Most current version) is alread installed. Installation of 7.50.61.0 bypassed.")
					Case Else
						$QuickTime_1m = MsgBox(1, "QuickTime7.50.61.0", "Complete Install?")
						If $QuickTime_1m  == 1 Then
							RunWait('msiexec /I "QuickTime7.50.61.0\QuickTime.msi"') ; Modify to your install location
								$QuickTime_1n = RegRead("", "DisplayVersion")
									If $QuickTime_1n  == "7.50.61.0" Then
										_FileWriteLog ($InstallLog, @UserName & " - " & "Installed QuickTime7.50.61.0"  )
									ElseIf $QuickTime_1n =  0  Then
									EndIf
						ElseIf $QuickTime_1m  = 2 Then
						EndIf
					EndSelect
;JRE 6.0 Update 7
		
			$Install_15a = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160000}", "DisplayVersion")
			$Install_15b = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160010}", "DisplayVersion")
			$Install_15c = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160020}", "DisplayVersion")
			$Install_15d = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160030}", "DisplayVersion")
			$Install_15e = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160040}", "DisplayVersion")
			$Install_15f = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160050}", "DisplayVersion")
			$Install_15g = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160060}", "DisplayVersion")
			$Install_15h = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160070}", "DisplayVersion")
				Select
					Case $Install_15a = "1.6.0.0"
						MsgBox(0, 'JRE 6.0  Installed', 'JRE 6.0 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15b = "1.6.0.10"
						MsgBox(0, 'JRE 6.0 Update 1 Installed', 'JRE 6.0 Update 1 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 1 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15c = "1.6.0.20"
						MsgBox(0, 'JRE 6.0 Update 2 Installed', 'JRE 6.0 Update 2 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 2 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15d = "1.6.0.30"
						MsgBox(0, 'JRE 6.0 Update 3 Installed', 'JRE 6.0 Update 3 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 3 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15e = "1.6.0.40"
						MsgBox(0, 'JRE 6.0 Update 4 Installed', 'JRE 6.0 Update 4 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 4 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15f = "1.6.0.50"
						MsgBox(0, 'JRE 6.0 Update 5 Installed', 'JRE 6.0 Update 5 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 5 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")
					Case $Install_15g = "1.6.0.60"
						MsgBox(0, 'JRE 6.0 Update 6 Installed', 'JRE 6.0 Update 6 installed, please remove before installing Update7; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 6 is installed. Please remove and re-run script. Installation of JRE 6.0 Update 7 bypassed.")						
					Case $Install_15h = "1.6.0.70"
						MsgBox(0, 'JRE 6.0 Update 7 Installed', 'JRE 6.0 Update 7 already installed, please troubleshoot possible corrupt installation; now exiting.',4)
						_FileWriteLog ($InstallLog,"JRE 6.0 Update 7 is already installed. Installation of JRE 6.0 Update 7 bypassed.")
					Case Else
						$Install_15i = MsgBox(1, "JRE 6.0 Update7", "Complete Install?")
						If $Install_15i  == 1 Then
							RunWait("JRE\JRE6.0Update7\jre-6u7.exe") ; Modify to your install location
								$Install_15j = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3248F0A8-6813-11D6-A77B-00B0D0160070}", "DisplayVersion")
									If $Install_15j  == "1.6.0.70" Then
										_FileWriteLog ($InstallLog, @UserName & " - " & "Installed JRE 6.0 Update 7"  )
									ElseIf $Install_15j =  0  Then
									EndIf
						ElseIf $Install_15i  = 2 Then
						EndIf
					EndSelect
$ViewLog = MsgBox(1, "What do you want to do?", "View Install.log?")
				If $ViewLog  == 1 Then
					Run("notepad.exe Install.log")
					EndIf
				If $ViewLog  = 2 Then
					Exit
					EndIf
