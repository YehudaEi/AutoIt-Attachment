;; Overview
;; This scrip instals the application into c:\EngineConncet
;; It performs the following steps:
;;		Creates the EngineConnect Directory
;;		Creates the Install.log file
;;		Verifies User has Admin Rights
;;		Maps a Network Drive 
;;		Copies Program Files from Network Drive
;;		Removes network drive
;;		Sets system variable
;;		Creates a ShortCut on User's Desktop
;;		Exits The Script

#Include <File.au3>

Global $sLocation, $sSource, $sPath, $sAdmin, $sLog

;Creates the Engine Connect Directory
DirCreate("C:\EngineConnect")
	If @error Then
		MsgBox(0, "Error", "Error - Unable to Create Directory")
		Exit
	EndIf

;Creates Install Logfile
	If FileExists("C:\EngineConnect\Install.log") Then
		_FileWriteLog("C:\EngineConnect\Install.log", "")
		_FileWriteLog("C:\EngineConnect\Install.log", "Install.log File Already Exists")
	Else
		_FileCreate("c:\engineconnect\Install.log")
		_FileWriteLog("C:\EngineConnect\Install.log", "Success - Install.log File Created")
	EndIf

;Verifies if uses has admin rights
	If IsAdmin() Then
		SplashTextOn("Verifying", "Admin Rights detected...", 250, 50, -1, -1, 0, "Arial", 12, 400)
		Sleep(2000)
		_FileCreate("c:\engineconnect\Install.log")
		_FileWriteLog("c:\engineconnect\install.log", " Success - Admin Rights Authenticated")
	Else
		SplashTextOn("Verifying", "No Admin Rights detected, Stopping...", 250, 50, -1, -1, 0, "Arial", 12, 400)
		Sleep(2000)
		_FileCreate("c:\engineconnect\Install.log")
		_FileWriteLog("c:\engineconnect\install.log", "Error - No Admin Rights Detected")
		Exit
	EndIf
	SplashOff()	

;Maps Network drive
	SplashTextOn("Installing", "Creating Drive Mapping to Server...", 250, 50, -1, -1, 0, "Arial", 12, 400)
	Sleep(2000)
DriveMapAdd("l:", "\\10.11.113.90\EngineConnect")
	If @error Then
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Error - Unable to Create Drive Mapping to Server")
		Exit
	Else
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Success - Created Drive Mapping to Server")
	EndIf
	SplashOff()

;Copies Files
	SplashTextOn("Copying", "Copying Files From Server...", 250, 50, -1, -1, 0, "Arial", 12, 400)
	Sleep(2000)
FileCopy("l:\*", "c:\EngineConnect\")
	If @error Then
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Error - Unable to Copy Files from Server")
		Exit
	Else
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Success - Copied Files from Server")

	EndIf
	SplashOff()

;Removes Mapped drive
	SplashTextOn("Removing", "Removing Mapped Drive from Server...", 250, 50, -1, -1, 0, "Arial", 12, 400)
	Sleep(2000)	
DriveMapDel("l:")
	If @error Then
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Error - Unable to Delete Mapped Network Drive")
		Exit
	Else
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Success - Deleted Mapped Network Drive")

	EndIf
	SplashOff()

;Sets Environment Variables
EnvSet("%path%", "c:\engineconnect")

;DriveMapDel("l:")
	If @error Then
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Error - Unable to Delete Mapped Network Drive")
		Exit
	Else
		_FileWriteLog("c:\engineconnect\install.log", "")
		_FileWriteLog("c:\engineconnect\install.log", "Success - Deleted Mapped Network Drive")

	EndIf
	SplashOff()

; Sets a shortcut with ctrl+alt+t hotkey
FileCreateShortcut("C:\EngineConnect\EC.exe",@DesktopDir & "\Engine Connect.lnk","","", "This is an EngineConnect link;-)", "C:\EngineConnect\Train.ico")

Func Close()
	_FileWriteLog("c:\engineconnect\install.log", "")
	_FileWriteLog("c:\EngineConnect\Install.log", "Now Exiting the Script"
	Exit
EndFunc