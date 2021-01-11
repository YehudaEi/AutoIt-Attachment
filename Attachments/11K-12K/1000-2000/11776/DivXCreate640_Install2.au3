
$pid = Run("DivXInstaller.exe")

If RegRead("HKCU\Control Panel\International", "sLanguage") = "FRA" Then
	Do
		Select
			;Language
			Case WinExists("Sélection de la langue", "Veuillez sélectionner la langue")
				ControlClick("Sélection de la langue", "Veuillez sélectionner la langue", "Button1")

			;Bienvenue
			Case WinExists("Installation de DivX for Windows", "Bienvenue")
				ControlClick("Installation de DivX for Windows", "Bienvenue", "Button2")

			;Licence
			Case WinExists("Installation de DivX for Windows", "Licence utilisateur")
				ControlCommand("Installation de DivX for Windows", "Licence utilisateur", "Button4", "Check", "")
				ControlClick("Installation de DivX for Windows", "Licence utilisateur", "Button2")

			;Addenda
			Case WinExists("Installation de DivX for Windows", "Addenda")
				ControlCommand("Installation de DivX for Windows", "Addenda", "Button4", "Check", "")
				ControlClick("Installation de DivX for Windows", "Addenda", "Button2")

			;composants
			Case WinExists("Installation de DivX for Windows", "Choisissez les composants")
				ControlClick("Installation de DivX for Windows", "Choisissez les composants", "Button2")

			;destination
			Case WinExists("Installation de DivX for Windows", "Choissisez le dossier")
				;ControlSetText("Installation de DivX for Windows", "Choissisez le dossier", "Edit1", "C:\Program Files\DivX" )
				ControlClick("Installation de DivX for Windows", "Choissisez le dossier", "Button2")

			;Google
			Case WinExists("Installation de DivX for Windows", "Mozilla Firefox")
				ControlClick("Installation de DivX for Windows", "Mozilla Firefox", "Button5")
				ControlClick("Installation de DivX for Windows", "Mozilla Firefox", "Button2")

			;bulletins de DivX
			Case WinExists("Installation de DivX for Windows", "Abonnez vous")
				ControlClick("Installation de DivX for Windows", "Abonnez vous", "Button2")
				WinWaitClose("Installation de DivX for Windows", "Abonnez vous", 5)

			;FIN
			Case WinExists("Installation de DivX for Windows", "DivX for Windows")
				Sleep(500)
				;ControlCommand("Installation de DivX for Windows", "Installation terminée", "Button4", "UnCheck", "")
				ControlClick("Installation de DivX for Windows", "DivX for Windows", "Button4")
				Sleep(500)
				ControlClick("Installation de DivX for Windows", "DivX for Windows", "Button2")
				;Send("!f")

				;;WinWait("Installation de DivX for Windows", "Votre ordinateur doit être redémarré")
				;;ControlClick("Installation de DivX for Windows", "Votre ordinateur doit être redémarré", "Button2")
		EndSelect
		Sleep(500)
	Until Not ProcessExists($pid)
Else
	Do
		Select
			;Language
			Case WinExists("Language selection", "Please select the language")
				ControlClick("Language selection", "Please select the language", "Button1")

			;Welcome
			Case WinExists("DivX for Windows Setup", "Welcome")
				ControlClick("DivX for Windows Setup", "Welcome", "Button2")

			;License
			Case WinExists("DivX for Windows Setup", "License Agreement")
				ControlCommand("DivX for Windows Setup", "License Agreement", "Button4", "Check", "")
				ControlClick("DivX for Windows Setup", "License Agreement", "Button2")

			;Addenda
			Case WinExists("DivX for Windows Setup", "License Agreement Addenda")
				ControlCommand("DivX for Windows Setup", "License Agreement Addenda", "Button4", "Check", "")
				ControlClick("DivX for Windows Setup", "License Agreement Addenda", "Button2")

			;components
			Case WinExists("DivX for Windows Setup", "Choose Components")
				ControlClick("DivX for Windows Setup", "Choose Components", "Button2")

			;Destination
			Case WinExists("DivX for Windows Setup", "Choose Install Location")
				;ControlSetText("DivX for Windows Setup", "Choose Install Location", "Edit1", "C:\Program Files\DivX" )
				ControlClick("DivX for Windows Setup", "Choose Install Location", "Button2")

			;Google
			Case WinExists("DivX for Windows Setup", "Free! Mozilla Firefox")
				ControlClick("DivX for Windows Setup", "Free! Mozilla Firefox", "Button5")
				ControlClick("DivX for Windows Setup", "Free! Mozilla Firefox", "Button2")

			;Sign up for the DivX newsletter!
			Case WinExists("DivX for Windows Setup", "Sign up")
				ControlClick("DivX for Windows Setup", "Sign up", "Button2")
				WinWaitClose("DivX for Windows Setup", "Sign up", 5)

			;END
			Case WinExists("DivX for Windows Setup", "Installation Complete")
				Sleep(500)
				;ControlCommand("DivX for Windows Setup", "Installation Complete", "Button4", "UnCheck", "")
				ControlClick("DivX for Windows Setup", "Installation Complete", "Button4")
				Sleep(500)
				ControlClick("DivX for Windows Setup", "Installation Complete", "Button2")
		EndSelect
		Sleep(500)
	Until Not ProcessExists($pid)
EndIf

Exit
