#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Lessons\Auto INstall ITG\Script\ICON.ico
#AutoIt3Wrapper_Res_Fileversion=0.0.0.13
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=izi ITG
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <NetShare.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <GuiButton.au3>

Opt('MustDeclareVars', 1)

ITG()



Func ITG()
	Local $Button_1, $Button_2, $Button_3, $Button_4, $Button_5, $Button_6, $Button_7, $Button_8, $Button_9, $Button_10, $Button_11
	Local $Button_12, $Button_13, $Button_14, $Button_15, $Button_16, $Button_17, $Button_18, $Button_19, $Button_20, $Button_21, $Button_22, $Button_23, $Button_24
	Local $Button_25, $Button_26, $Button_27, $Button_28, $Button_29, $Button_30, $Button_31, $Button_32, $Button_33, $Button_34, $msg, $go, $dll
	Local $FileMenu, $ExitItem, $Tool, $Regedit, $Kdrive, $SUS, $variable, $Wait, $Wait1, $Wait2
	Local $Communications, $Comyns, $Design, $Dmec, $F4a, $F4b, $Fad, $Finance, $Gmd, $Hrd, $Ie, $Imd, $Itg, $Planning, $Proc, $Qa, $Rd, $rsm, $Sbn, $Td, $Vc, $Vmd, $Whs
	Local $Button_35, $Button_36, $Button_37, $Button_38, $Button_39, $Button_40, $Button_41, $Button_42, $Button_43, $Button_44, $Button_45, $Button_46


	GUICreate("ITG - Internal Use Only ^^V        - Create By IZI ITG - 27.9.2011   -<| Tested by Mus & Vincent ITG |>-", 850, 450) ; will create a dialog box that when displayed is centered
	$Wait = 3000
	$Wait1 = 300
	$Wait2 = 10000



	Opt("GUICoordMode", 1)

	If FileExists("k:\") Then

		$Kdrive = ("K-Drive Found !")

	Else
		$Kdrive = ("K-Drive not Found !")
	EndIf


	$FileMenu = GUICtrlCreateMenu("&File")
	SetMenuColor($FileMenu, 0xEEBB99) ; BGR color value
	$Tool = GUICtrlCreateMenu("&Tool")
	SetMenuColor($Tool, 0xEEBB99) ; BGR color value
	GUICtrlCreateMenuItem("", $FileMenu)
	$ExitItem = GUICtrlCreateMenuItem("&Exit", $FileMenu)
	$Regedit = GUICtrlCreateMenu("&Regedit", $Tool)
	$SUS = GUICtrlCreateMenu("&Window XP SUS Update", $Tool)
	$Communications = GUICtrlCreateMenuItem("COMMUNICATION", $SUS)
	$Comyns = GUICtrlCreateMenuItem("COMYNS", $SUS)
	$Design = GUICtrlCreateMenuItem("Design", $SUS)
	$Dmec = GUICtrlCreateMenuItem("DMEC", $SUS)
	$F4a = GUICtrlCreateMenuItem("F4A", $SUS)
	$F4b = GUICtrlCreateMenuItem("F4B", $SUS)
	$Fad = GUICtrlCreateMenuItem("FAD", $SUS)
	$Finance = GUICtrlCreateMenuItem("Finance", $SUS)
	$Gmd = GUICtrlCreateMenuItem("GMD", $SUS)
	$Hrd = GUICtrlCreateMenuItem("HRD", $SUS)
	$Ie = GUICtrlCreateMenuItem("IE", $SUS)
	$Imd = GUICtrlCreateMenuItem("IMD", $SUS)
	$Itg = GUICtrlCreateMenuItem("ITG", $SUS)
	$Planning = GUICtrlCreateMenuItem("PLANNING", $SUS)
	$Proc = GUICtrlCreateMenuItem("PROC", $SUS)
	$Qa = GUICtrlCreateMenuItem("QA", $SUS)
	$Rd = GUICtrlCreateMenuItem("RD", $SUS)
	$rsm = GUICtrlCreateMenuItem("RSM", $SUS)
	$Sbn = GUICtrlCreateMenuItem("SBN", $SUS)
	$Td = GUICtrlCreateMenuItem("TD", $SUS)
	$Vc = GUICtrlCreateMenuItem("VC", $SUS)
	$Vmd = GUICtrlCreateMenuItem("VMD", $SUS)
	$Whs = GUICtrlCreateMenuItem("WHS", $SUS)



	GUICtrlCreateLabel("Run", 25, 403)
	$go = GUICtrlCreateInput("", 60, 400, 300, 20)
	GUICtrlSetState("", $GUI_DROPACCEPTED)

	GUICtrlCreateLabel($Kdrive, 25, 40) ; next line
	GUICtrlSetColor(-1, 0xff0000)
	;ip
	GUICtrlCreateGroup("Your IP", 455, 15, 135, 40)
	GUICtrlCreateLabel(@IPAddress1, 470, 30) ; next line
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	;CPU
	GUICtrlCreateGroup("CPU", 455, 55, 135, 40)
	GUICtrlCreateLabel(@CPUArch, 470, 73) ; next line
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	;OS type
	GUICtrlCreateGroup("OS", 455, 95, 135, 40)
	GUICtrlCreateLabel(@OSVersion, 470, 112) ; next line
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	;Logon as
	GUICtrlCreateGroup("Logon as", 455, 135, 135, 40)
	GUICtrlCreateLabel(@UserName, 470, 151) ; next line
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group


	GUICtrlCreateIcon(@WindowsDir & "\cursors\horse.ani", -1, 40, 5, 32, 32)

	$Button_1 = GUICtrlCreateButton("Connect K-Drive", 10, 60, 100)
	$Button_2 = GUICtrlCreateButton("Disconnect K-Drive", 10, 90, 100)

	;GUICtrlCreateLabel("Auto Install", 15, 225) ; next line
	$Button_3 = GUICtrlCreateButton("Auto Install All Win7", 720, 20, 100)
	GUICtrlCreateLabel("+ Adobe Reader", 720, 50)
	GUICtrlCreateLabel("+ WinRAR", 720, 70)
	GUICtrlCreateLabel("+ OpenOffice", 720, 90)
	GUICtrlCreateLabel("+ PDF Creator", 720, 110)
	GUICtrlCreateLabel("+ MoZilla 4.0", 720, 130)
	GUICtrlCreateLabel("+ Office 97", 720, 150)
	GUICtrlCreateLabel("+ Lotus 8.0", 720, 170)
	GUICtrlCreateLabel("+ VNC Win7", 720, 190)




	GUICtrlCreateGroup("Auto Install Single Application", 5, 257, 660, 135)
	$Button_4 = GUICtrlCreateButton("Adobe reader 1002", 230, 270, 100)
	$Button_5 = GUICtrlCreateButton("MS Office 97 XP_7", 340, 300, 100)
	$Button_6 = GUICtrlCreateButton("Mozilla Firefox 4.0", 230, 330, 100)
	$Button_7 = GUICtrlCreateButton("Open Office XP_7", 340, 270, 100)
	$Button_8 = GUICtrlCreateButton("Pdf Creator", 230, 360, 100)
	$Button_9 = GUICtrlCreateButton("Lotus Note 8.0", 230, 300, 100)
	$Button_10 = GUICtrlCreateButton("Ultra VNC XP", 10, 300, 100)
	$Button_11 = GUICtrlCreateButton("Kaizen", 10, 330, 100)
	$Button_12 = GUICtrlCreateButton("Kaspersky Internal", 450, 270, 100)
	$Button_13 = GUICtrlCreateButton("Ultra VNC Win7", 10, 270, 100)
	$Button_14 = GUICtrlCreateButton("WinRAR38", 120, 270, 100)

	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	GUICtrlCreateGroup("Window Tools", 115, 15, 330, 103)
	$Button_15 = GUICtrlCreateButton("UAC", 120, 30, 100)
	$Button_16 = GUICtrlCreateButton("IP Config", 120, 60, 100)
	$Button_17 = GUICtrlCreateButton("DxDiag", 230, 30, 100)
	$Button_18 = GUICtrlCreateButton("CMD", 230, 60, 100)
	$Button_19 = GUICtrlCreateButton("TaskMan", 340, 30, 100)
	$Button_20 = GUICtrlCreateButton("MsConfig", 340, 60, 100)
	$Button_21 = GUICtrlCreateButton("Ping", 120, 90, 100)
	$Button_22 = GUICtrlCreateButton("PC Name by IP", 230, 90, 100)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	GUICtrlCreateGroup("Desktop Shortcut", 115, 120, 330, 80)
	$Button_23 = GUICtrlCreateButton("Tinmail", 120, 140, 100)
	$Button_24 = GUICtrlCreateButton("RsPortal", 230, 140, 100)
	$Button_25 = GUICtrlCreateButton("RsMeta", 340, 140, 100)
	$Button_44 = GUICtrlCreateButton("Royal Selangor", 120, 170, 100)
	$Button_45 = GUICtrlCreateButton("Comyns-Silver", 230, 170, 100)
	$Button_46 = GUICtrlCreateButton("Selberan", 340, 170, 100)


	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	$Button_26 = GUICtrlCreateButton("Izi Notes", 10, 120, 100)
	$Button_27 = GUICtrlCreateButton("Adobe Flash", 120, 300, 100)
	$Button_28 = GUICtrlCreateButton("Print Screen", 340, 90, 100)
	$Button_29 = GUICtrlCreateButton("&Go !", 370, 398, 100)
	$Button_31 = GUICtrlCreateButton("Auto Install All XP", 600, 20, 100)
	GUICtrlCreateLabel("+ Adobe Reader", 600, 50)
	GUICtrlCreateLabel("+ WinRAR", 600, 70)
	GUICtrlCreateLabel("+ OpenOffice", 600, 90)
	GUICtrlCreateLabel("+ PDF Creator", 600, 110)
	GUICtrlCreateLabel("+ MoZilla 4.0", 600, 130)
	GUICtrlCreateLabel("+ Office 97", 600, 150)
	GUICtrlCreateLabel("+ Lotus 8.0", 600, 170)

	$Button_32 = GUICtrlCreateButton("IE 8.0 XP", 450, 330, 100)
	$Button_33 = GUICtrlCreateButton("Configure Baan", 120, 360, 100)
	$Button_34 = GUICtrlCreateButton("Baan", 120, 330, 100)
	$Button_35 = GUICtrlCreateButton("XP TweakZ", 340, 360, 100)
	$Button_36 = GUICtrlCreateButton("Configure Kaizen", 10, 360, 100)
	$Button_37 = GUICtrlCreateButton("ITG DOS MODE", 10, 150, 100)
	$Button_38 = GUICtrlCreateButton("Kaspersky External", 450, 300, 100)
	$Button_39 = GUICtrlCreateButton("MS Office 97 Patch ", 340, 330, 100)
	$Button_40 = GUICtrlCreateButton("Notepad", 10, 180, 100)
	$Button_41 = GUICtrlCreateButton("Paint", 10, 210, 100)
	$Button_42 = GUICtrlCreateButton("IE Set Proxy", 450, 360, 100)
	$Button_43 = GUICtrlCreateButton("Firefox Set Proxy", 560, 270, 100)
	GUISetState() ; will display an  dialog box with 2 button

	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $ExitItem
				ExitLoop

			Case $msg = $Communications
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\COMMUNICATIONS\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\COMMUNICATIONS\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Comyns
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\COMYNS\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\COMYNS\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Design
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\DESIGN\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\DESIGN\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Dmec
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\DMEC\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\DMEC\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $F4a
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\F4A\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\F4A\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $F4b
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\F4B\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\F4B\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Fad
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\FAD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\FAD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Finance
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\FINANCE\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\FINANCE\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Gmd
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\GMD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\GMD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Hrd
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\HRD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\HRD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Ie
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\IE\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\IE\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Imd
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\IMD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\IMD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Itg
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\ITG\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\ITG\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Planning
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\PLANNING\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\PLANNING\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Proc
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\PROC\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\PROC\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Qa
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\QA\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\QA\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Rd
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\RD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\RD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $rsm
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\RSM\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\RSM\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Sbn
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\SBN\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\SBN\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Td
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\TD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\TD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Vc
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\VC\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\VC\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Vmd
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\VMD\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\VMD\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Whs
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\WHS\*.bat", "C:\", 9)
				FileCopy("K:\ITG\Apps\Microsoft\SUS\Step 4 - Deploy to Client\WHS\*.reg", "C:\", 9)
				Run("C:\\Deploy Setting To Client.bat")
			Case $msg = $Button_1
				If FileExists("K:\") Then
					MsgBox(4096, "K-Drive", "Already Connected !")
				Else
					; Map X drive to \\myserver2\stuff2 using the user "jon" from "domainx" with password "tickle"
					DriveMapAdd("K:", "\\168.1.8.25\common", 0, "mimb", "mimb2011")
					If FileExists("K:\") Then
						MsgBox(4096, "K-Drive", "Has Been Connected !")
						If FileExists("k:\") Then

							$Kdrive = ("K-Drive Found !")

						Else
							$Kdrive = ("K-Drive not Found !")
						EndIf
					Else
						MsgBox(4096, "K-Drive", "Failed !!")
						If FileExists("k:\") Then

							$Kdrive = ("K-Drive Found !")

						Else
							$Kdrive = ("K-Drive not Found !")
						EndIf
					EndIf
				EndIf

			Case $msg = $Button_2
				If FileExists("K:\") Then
					DriveMapDel("K:")
					MsgBox(4096, "K-Drive", "K-Drive Has Been Dis-Connected !")
					If FileExists("k:\") Then

						$Kdrive = ("K-Drive Found !")

					Else
						$Kdrive = ("K-Drive not Found !")
					EndIf
				Else
					MsgBox(4096, "K-Drive", "Already Dis-Connected !")
					If FileExists("k:\") Then

						$Kdrive = ("K-Drive Found !")

					Else
						$Kdrive = ("K-Drive not Found !")
					EndIf
				EndIf

			Case $msg = $Button_3
				;Run('Notepad.exe')    ; Will Run/Open Notepad
				;Run("K:\ITG\Apps\LotusNotes\Lotus.Notes.8.0\Notes\Lotus Notes 8 Basic_c13naen.exe")
				Run("K:\ITG\Users\Izi\ITG\AllInstall.exe")

			Case $msg = $Button_4
				;MsgBox(0, 'Testing', 'Button 2 was pressed')    ; Will demonstrate Button 2 being pressed
				Run("K:\ITG\Users\Izi\ITG\AdbeRdr1001_en_US.exe")

			Case $msg = $Button_5
				Run("K:\ITG\Users\Izi\ITG\MicrosoftOffice 97 XP_7.exe")
			Case $msg = $Button_6
				Run("K:\ITG\Users\Izi\ITG\MozillaFirefox4.0SetupNEWPC.exe")
			Case $msg = $Button_7
				Run("K:\ITG\Users\Izi\ITG\Open Office XP_7.exe")
			Case $msg = $Button_8
				Run("K:\ITG\Users\Izi\ITG\PDFCreatorSetup_WIN7NEWPC.exe")
			Case $msg = $Button_9
				Run("K:\ITG\Users\Izi\ITG\Lotus8.0NEWPC.exe")
			Case $msg = $Button_10
				Run("K:\ITG\Apps\Util\VNC\UltraVNC-102-Setup.exe")
			Case $msg = $Button_11
				Run("K:\ITG\Users\Izi\ITG\Kaizen.exe")
			Case $msg = $Button_12
				Run("K:\ITG\Apps\Security.And.Virus\setup.exe")
			Case $msg = $Button_13
				Run("K:\ITG\Users\Izi\ITG\VNC_SetupOnly_WIN7.exe")
			Case $msg = $Button_14
				Run("K:\ITG\Users\Izi\ITG\WinRAR XP_7.exe")
			Case $msg = $Button_15
				Run("C:\Windows\System32\UserAccountControlSettings.exe")
			Case $msg = $Button_16
				Run("K:\ITG\Users\Izi\ITG\IP_CONFIG.bat")
			Case $msg = $Button_17
				Run("dxdiag")
			Case $msg = $Button_18
				Run("cmd")
			Case $msg = $Button_19
				Run("taskmgr")
			Case $msg = $Button_20
				Run("msconfig")
			Case $msg = $Button_21
				Run("K:\ITG\Users\Izi\ITG\PingIP.bat")
			Case $msg = $Button_22
				Run("K:\ITG\Users\Izi\ITG\PCNAME.bat")
			Case $msg = $Button_23
				Run("K:\ITG\Users\Izi\ITG\TINMAIL.bat")
				MsgBox(0, 'Shortcut', 'Shortcut Tinmail has been create on Desktop')
			Case $msg = $Button_24
				Run("K:\ITG\Users\Izi\ITG\RSPortal.bat")
				MsgBox(0, 'Shortcut', 'Shortcut RSPortal has been create on Desktop')
			Case $msg = $Button_25
				Run("K:\ITG\Users\Izi\ITG\RSMeta.bat")
				MsgBox(0, 'Shortcut', 'Shortcut RSMeta has been create on Desktop')
			Case $msg = $Button_26
				;run("K:\ITG\Users\Izi\ITG\izifarhan.txt")
				ShellExecute("K:\ITG\Users\Izi\ITG\izifarhan.txt", "", @ScriptDir, "edit")
			Case $msg = $Button_27
				Run("K:\ITG\Users\Izi\ITG\AdobeFlash.exe")
			Case $msg = $Button_28
				_ScreenCapture_SetJPGQuality(100)
				_ScreenCapture_Capture(@MyDocumentsDir & "\ITG_Image1.jpg")
			Case $msg = $Button_29

				Run("C:\WINDOWS\system32\" & GUICtrlRead($go, 1) & ".exe", "")
				;$go = GUICtrlCreateInput("", 60, 400, 300, 20)


			Case $msg = $Button_31
				Run("K:\ITG\Users\Izi\ITG\AllInstallXP.exe")
			Case $msg = $Button_32
				Run("K:\ITG\Users\Izi\ITG\IE8.exe")
			Case $msg = $Button_33
				FileCopy("K:\ITG\Users\Izi\ITG\Baan IV.ink", "C:\Documents and Settings\All Users\Desktop", 9)
				Sleep($Wait1)
				Run("C:\Windows\Baan\Bin\becs.exe")
				Sleep($Wait1)
				Sleep($Wait1)
				Send("{DOWN}")
				Sleep($Wait1)
				Send("{ENTER}")
				Sleep($Wait1)
				Send("!C")
				Sleep($Wait1)
				$variable = '168.1.8.43'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!B")
				Sleep($Wait1)
				$variable = 'e:\baan'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!V")
				Sleep($Wait1)
				Send("!N")
				Sleep($Wait1)
				$variable = '168.1.8.43.bwc'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!S")
				Sleep($Wait1)
				Send("!H")
				Sleep($Wait1)
				$variable = '168.1.8.21'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!B")
				Sleep($Wait1)
				$variable = 'd:\baan'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!V")
				Sleep($Wait1)
				Send("!N")
				Sleep($Wait1)
				$variable = '168.1.8.21.bwc'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!S")
				Sleep($Wait1)
				Send("{TAB 10}")
				Sleep($Wait1)
				Send("{space}")
				Send("!V")
				Send("r")
				MsgBox(0, 'Baan', 'Setup Complate')

			Case $msg = $Button_34
				Run("K:\ITG\Users\Izi\ITG\Baan.exe")
			Case $msg = $Button_35
				FileCopy("K:\ITG\Apps\Microsoft\Windows-Tweaks\Tweak Ui\win9x\*.*", "C:\Windows\System32", 9)
				ShellExecute("C:\Windows\System32\tweakui.cpl")
				WinWaitActive("Tweak", "Fast")
				Send("{TAB 14}")
				Send("{left 49}")
				Send("{TAB 14}")
				Send("{right}")
				Send("{tab}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{down}")
				Send("{space}")
				Send("{down}")

				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("{down}")
				Send("{space}")
				Send("!A")
				Send("{enter}")
				MsgBox(0, 'TweakXP', 'Configuration Complate !')

			Case $msg = $Button_36
				ShellExecute("odbcad32.exe")
				Sleep($Wait1)
				Send("{TAB 7}")
				Send("{right}")
				Send("!D")
				Sleep($Wait1)
				Send("{down 22}")
				Send("{enter}")
				Sleep($Wait1)
				Send("!M")
				$variable = 'SQLKZODBC'
				Sleep($Wait1)
				Send($variable, 1)
				Send("!S")
				Sleep($Wait1)
				$variable = 'SQLSERVER'
				Sleep($Wait1)
				Send($variable, 1)
				Sleep($Wait1)
				Send("!N")
				Send("{down}")
				Send("!T")
				Send("{TAB 2}")
				Sleep($Wait1)
				$variable = '168.1.8.9'
				Sleep($Wait1)
				Send($variable, 1)
				Send("!D")
				Send("{enter}")
				Send("!L")
				$variable = 'hr_sa3'
				Sleep($Wait1)
				Send($variable, 1)
				Send("!P")
				$variable = '123asd'
				Sleep($Wait1)
				Send($variable, 1)
				Send("!N")
				Send("!D")
				Send("{TAB}")
				$variable = 'lvdb'
				Sleep($Wait1)
				Send($variable, 1)
				Send("!N")
				Send("{enter}")
				Send("!T")
				Send("{enter}")
				Send("{right}")
				Send("{enter}")
				Send("{TAB}")
				Send("{enter}")
				MsgBox(0, 'ODBC', 'Configuration ODBC Complate !')
				Sleep($Wait)
				ShellExecute("C:\Kaizen\3.7.0.0\bin\kzdbcfgadminp.exe")
				MsgBox(0, 'Kaizen Admin', 'Need to do manual configuration !')
				;send("!Y")
				;send("!E")
				;send("N")
				;Send("{TAB 3}")
				;ControlClick("Choose", "", 5900678)
				;Send("{TAB}")
				;$variable = 'KZLIVE'
				;Sleep($Wait1)
				;Send($variable , 1)

			Case $msg = $Button_37
				Run("K:\ITG\Users\Izi\ITG\ITG_DOS.exe")
			Case $msg = $Button_38
				;kaspersky external installation for showroom


			Case $msg = $Button_39
				;ms office 97 update / patch


			Case $msg = $Button_40
				ShellExecute("C:\WINDOWS\NOTEPAD.EXE")
			Case $msg = $Button_41
				ShellExecute("C:\WINDOWS\system32\mspaint.exe")
			Case $msg = $Button_42
				ShellExecute("C:\Program Files\Internet Explorer\IEXPLORE.EXE")
				Sleep($Wait1)
				Send("{esc}")
				Sleep($Wait1)
				Send("!T")
				Send("O")
				Sleep($Wait1)
				Send("{tab 15}")
				Sleep($Wait1)
				Send("{right 4}")
				Sleep($Wait1)
				Send("!L")
				Sleep($Wait1)
				Send("!X")
				Sleep($Wait1)
				Send("!E")
				Sleep($Wait1)
				Send("168.1.8.97")
				Send("!T")
				Sleep($Wait1)
				Send("8080")
				Sleep($Wait1)
				Send("{enter}")
				Sleep($Wait1)
				Send("{enter}")
			Case $msg = $Button_44
				Run("K:\ITG\Users\Izi\ITG\RS.bat")
				MsgBox(0, 'Shortcut', 'Shortcut Royal Selangor has been create on Desktop')
			Case $msg = $Button_45
				Run("K:\ITG\Users\Izi\ITG\Comyns.bat")
				MsgBox(0, 'Shortcut', 'Shortcut Comyns-Silver has been create on Desktop')
			Case $msg = $Button_46
				Run("K:\ITG\Users\Izi\ITG\Selberan.bat")
				MsgBox(0, 'Shortcut', 'Shortcut Selberan has been create on Desktop')

		EndSelect
	WEnd
EndFunc   ;==>ITG



Func SetMenuColor($nMenuID, $nColor)
	Local $hMenu, $hBrush, $stMenuInfo
	Local Const $MIM_APPLYTOSUBMENUS = 0x80000000
	Local Const $MIM_BACKGROUND = 0x00000002

	$hMenu = GUICtrlGetHandle($nMenuID)

	$hBrush = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $nColor)
	$hBrush = $hBrush[0]

	$stMenuInfo = DllStructCreate("dword;dword;dword;uint;dword;dword;ptr")
	DllStructSetData($stMenuInfo, 1, DllStructGetSize($stMenuInfo))
	DllStructSetData($stMenuInfo, 2, BitOR($MIM_APPLYTOSUBMENUS, $MIM_BACKGROUND))
	DllStructSetData($stMenuInfo, 5, $hBrush)

	DllCall("user32.dll", "int", "SetMenuInfo", "hwnd", $hMenu, "ptr", DllStructGetPtr($stMenuInfo))

	; release Struct not really needed as it is a local
	$stMenuInfo = 0
EndFunc   ;==>SetMenuColor
