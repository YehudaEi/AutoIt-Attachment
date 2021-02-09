
#include <ProgressConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <SendMessage.au3>
#include <GuiButton.au3>
#include <Process.au3>
#Include <File.au3>

Opt('MustDeclareVars', 1)

;START BUILD SECTION
	Global $shGUI, $msg, $sExit, $DS_SETFOREGROUND, $WS_EX_TOPMOST, $sLaunch, $sChildGUI, $sPic, $sDelLable, $sDelProgress

;Sets Constants
	Global Const $sPath = "c:\EngineConnect\"
	Global Const $sLogfile = $sPath & "Install.log"
	_FileWriteLog($sLogfile, "")
	_FileWriteLog($sLogfile, "START BUILD SECTION")
	_FileWriteLog($sLogfile, "******************************************************************************************")
	_FileWriteLog($sLogfile, "******************************************************************************************")

;Define Background Image and Launches
	$sPic = "c:\EngineConnect\TempBlank.bmp"
	SplashImageOn("TCD ECS Installation", $sPic, @DesktopWidth, @DesktopHeight, "", "", 3)

;Progress Marquee Starts
	$sChildGui = GUICreate("Installing Engine Connect System... ",420, 150, 300, 300, $DS_SETFOREGROUND, $WS_EX_TOPMOST)
	GUICtrlCreateProgress(10, 60, 400, 20, $PBS_MARQUEE)
	_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 20) ; final parameter is update time in ms
	GUICtrlCreateLabel("Please Wait while the program is installed... ",100,15)
	GUISetState()
Sleep(1000)
;Verifies if uses has admin rights
		If IsAdmin() Then
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, " Success - Admin Rights Authenticated")
		Else
			MsgBox(0, "ERROR", "No Admin Rights Detected... Program Exiting")
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, "Error - No Admin Rights Detected")
			Exit
		EndIf

;Sets Environment Variables
	_RunDOS ("set path=%path%;C:\EngineConnect")
		If @error Then
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, " Error - Environment Variable was NOT set...")
			MsgBox(0, "ERROR", "Environment Variable was NOT set, Program Exiting...")
			Exit
		Else
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, "Success - Environment Variable was set...")
		EndIf
Sleep(1000)
; Sets a shortcut on the desktop for the EC icon
	FileCreateShortcut("C:\EngineConnect\ECSystem.exe",@DesktopDir & "\Engine Connect System.lnk","","", "This is an EngineConnect link;-)", "C:\EngineConnect\Train.ico")
		If @error Then
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, " Error - Desktop Shortcut was not created...")
		Else
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, "Success - Desktop Shortcut was created...")
		EndIf

;Inserts the Persistant Route into the Registry
	RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes", "10.10.9.0,255.255.255.0,223.223.223.3,1", "REG_SZ","")
		If @error Then
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, "Error - Persisent Route to LDVR was NOT Set Correctly")
			MsgBox(0, "ERROR", "Persisent Route to LDVR was NOT Set Correctly, Program Exiting...")
			Exit
		Else
			_FileWriteLog($sLogfile, "")
			_FileWriteLog($sLogfile, "Success - Persisent Route to LDVR was Set Correctly")
		EndIf
Sleep(1000)

;Closes the Marquee
    GUIDelete($sChildGui)

;Closes the Splash Image
	SplashOff()

;Finishes Pr0gram
	_FileWriteLog($sLogfile, "")
	_FileWriteLog($sLogfile, "Install Script is now Finished")
MsgBox(36, "Congratulations", "System is Installed. Would you like to run the ECSystem now?")
If 1 Then
	RunWait("iexplore.exe")
	exit
Else
	exit
EndIf
Exit



















