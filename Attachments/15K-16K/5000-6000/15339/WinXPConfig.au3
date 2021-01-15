
If IsAdmin() Then
	
	;Disable Windows Firewall
	Run("netsh firewall set opmode disable")
	Sleep(3000)
	
	;Disable Firewall Notifications
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallDisableNotify","REG_DWORD",1)

	;Set Power Settings to "Always On" and "Apply" them.
	RunWait("powercfg.exe /SETACTIVE ""always on""")

	;Disable Windows XP Tour for All Users
	RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Applets\Tour","RunCount","REG_DWORD",0)

	;Disable Offline File Synchronization
	RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","Enabled","REG_DWORD",0)
	RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoConfigCache","REG_DWORD",1)
	RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoMakeAvailableOffline","REG_DWORD",1)
	RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoCacheViewer","REG_DWORD",1)

	;Disable Automatic Updates
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update","AUOptions","REG_DWORD",1)

	;Disable Automatic Updates Notifications
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","UpdatesDisableNotify","REG_DWORD",1)

	;Disable Compress Old Files on Disk Cleanup
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files")

	;Disable Desktop Cleanup Wizard for All Users
	RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\OemStartMenuData","OemDesktopCleanupDisable","REG_DWORD",1)
	
Else
	
	;Set Power Settings to "Always On" and "Apply" them.
	RunWait("powercfg.exe /SETACTIVE ""always on""")
	
	RunAsSet("administrator","domain","password")
	
		;Disable Windows Firewall
		Run("netsh firewall set opmode disable")
		Sleep(3000)
		
		;Disable Firewall Notifications
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallDisableNotify","REG_DWORD",1)
		
		;Disable Windows XP Tour for All Users
		RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Applets\Tour","RunCount","REG_DWORD",0)

		;Disable Offline File Synchronization
		RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","Enabled","REG_DWORD",0)
		RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoConfigCache","REG_DWORD",1)
		RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoMakeAvailableOffline","REG_DWORD",1)
		RegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetCache","NoCacheViewer","REG_DWORD",1)

		;Disable Automatic Updates
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update","AUOptions","REG_DWORD",1)

		;Disable Automatic Updates Notifications
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","UpdatesDisableNotify","REG_DWORD",1)

		;Disable Compress Old Files on Disk Cleanup
		RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files")

		;Disable Desktop Cleanup Wizard for All Users
		RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\OemStartMenuData","OemDesktopCleanupDisable","REG_DWORD",1)
	
	RunAsSet()
	
EndIf