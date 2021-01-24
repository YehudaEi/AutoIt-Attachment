;Install the installer.
FileInstall ( ".\ccsetup214.exe", @HomeDrive & "\Computer Cleanup\CCleaner\ccsetup214.exe")
;Install CCleaner
Run("ccsetup214.exe")
WinWaitActive("Installer Language", "", "")
ControlClick ( "Installer Language", "", "Button1")
WinWaitActive("CCleaner v2.14 Setup", "Welcome to the CCleaner v2.14 Setup Wizard")
ControlClick("CCleaner v2.14 Setup", "Welcome to the CCleaner v2.14 Setup Wizard", "Button2")
WinWaitActive("CCleaner v2.14 Setup", "License Agreement")
ControlClick("CCleaner v2.14 Setup", "License Agreement", "Button2")
WinWaitActive("CCleaner v2.14 Setup", "Choose Install Location")
ControlClick("CCleaner v2.14 Setup", "Choose Install Location", "Button2")
WinWaitActive("CCleaner v2.14 Setup", "Install Options")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button4")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button7")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button5")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button8")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button9")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button6")
ControlClick("CCleaner v2.14 Setup", "Install Options", "Button2")
WinWaitActive("CCleaner v2.14 Setup", "Completing the CCleaner v2.14 Setup Wizard")
ControlClick("CCleaner v2.14 Setup", "Completing the CCleaner v2.14 Setup Wizard", "Button2")
;Run CCleaner
Run(@ProgramFilesDir & "\CCleaner\ccleaner.exe")
WinWaitActive("Piriform CCleaner", "Analyze")
;Goto the registrey button.
ControlClick("Piriform CCleaner", "Analyze", "Button4")
Sleep(500)
Do	
	;Scan for issues.
	ControlClick("Piriform CCleaner", "Scan for Issues", "Button2")
	WinWaitActive("Piriform CCleaner", "Scan for Issues")
	ControlCommand("Piriform CCleaner", "", "Button3", "IsEnabled")
	$error = @error
	;Fix them.
	ControlClick("Piriform CCleaner", "Fix selected issues", "Button3")
	WinWaitActive("CCleaner", "Do you want to backup changes to the registry?")
	;Say we don't want to back them up.
	ControlClick("CCleaner", "Do you want to backup changes to the registry?", "Button2")
	WinWaitActive("", "Fix All Selected Issues")
	;Hit the "fix all issues button".
	ControlClick("", "Fix All Selected Issues", "Button5")
	WinWaitActive("CCleaner", "Are you sure you want to Fix all selected Issues?")
	;Say we are sure.
	ControlClick("CCleaner", "Are you sure you want to Fix all selected Issues?", "Button1")
	;Hit "OK".
	ControlClick("", "Fix All Selected Issues", "Button3")
	Until $error = 1
;Go to options
ControlClick("Piriform CCleaner", "", "Button9")
WinWaitActive("Piriform CCleaner", "Advanced")
;Hit advanced
ControlClick("Piriform CCleaner", "Advanced", "Button5")
WinWaitActive("Piriform CCleaner", "Close program after cleaning")
;Check the close after startup option
ControlClick("Piriform CCleaner", "Close program after cleaning", "Button10")
;Go back to the cleaning tab
ControlClick("Piriform CCleaner", "", "Button21")
WinWaitActive("Piriform CCleaner", "Analyze")
;Hit run cleaner
ControlClick("Piriform CCleaner", "", "Button2")
WinWaitActive("", "OK")
;Say yes to "delete these fles" popup.
Send("{ENTER}")
WinWaitClose("Piriform CCleaner", "")
;Run the un-installer
Run(@ProgramFilesDir & "\CCleaner\uninst.exe")
WinWaitActive("CCleaner v2.14 Uninstall", "Welcome to the CCleaner v2.14 Uninstall Wizard")
ControlClick("CCleaner v2.14 Uninstall", "Welcome to the CCleaner v2.14 Uninstall Wizard", "Button2")
WinWaitActive("CCleaner v2.14 Uninstall", "Remove CCleaner v2.14 from your computer.")
ControlClick("CCleaner v2.14 Uninstall", "Remove CCleaner v2.14 from your computer.", "Button2")
WinWaitActive("CCleaner v2.14 Uninstall", "CCleaner v2.14 has been uninstalled from your computer.")
Send("{ENTER}")