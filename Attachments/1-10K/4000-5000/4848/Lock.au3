; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Platform:       WinXP
; Loginor:         Cybie, ArchRival, MSLx Fanboy, Random667
; Script Function:
; Fake the "computer locked" dialog so that AutoIt may run in the background.
; ----------------------------------------------------------------------------
#include <GuiConstants.au3>
#NoTrayIcon

AutoItSetOption("RunErrorsFatal", 0)
AutoItSetOption("GUICloseOnESC", 0)

Dim $user, $password, $WinImage, $username, $okbutton, $bgImage, $GUI_ON
$ScreenSaverDetected = 0
Dim $SCR_PATH = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "SCRNSAVE.EXE")

_GUI()

While 1
	_ScreenSaverCheck()
	$msg = GUIGetMsg()
	Select
		Case $msg = $okbutton
			_Login()
			
		Case $ScreenSaverDetected = 0 And $GUI_ON = 1
			WinSetOnTop("Unlock Computer", "", 1)
			ProcessClose("Explorer.exe")
			ProcessClose("Taskmgr.exe")
			
		Case $ScreenSaverDetected = 1 And $GUI_ON = 1
			WinSetOnTop("Unlock Computer", "", 0)
			
		Case $ScreenSaverDetected = 1 And $GUI_ON = 0
			_GUI()
			WinSetOnTop("Unlock Computer", "", 0)
	EndSelect
	
WEnd

Func _GUI()
	$GUI_ON = 1
	
	HotKeySet("{ESC}", "_Nothing")
	HotKeySet("!{TAB}", "_Nothing")
	HotKeySet("!{F4}", "_Nothing")
	HotKeySet("^!{INS}", "_Nothing")
	HotKeySet("{Enter}", "_Login")
	HotKeySet("^", "_Nothing")
	HotKeySet("!", "_Nothing")
	HotKeySet("{F10}")
	
	$username = @UserName
	$WinImage = @TempDir & "\" & "XP_High.bmp"
	FileInstall("XP_High.bmp", $WinImage, 1)
	GUICreate("BG", @DesktopWidth, @DesktopHeight, "", "", 0x80000000 + $WS_EX_TOPMOST)
	$bgImage = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "ConvertedWallpaper")
	GUICtrlCreatePic($bgImage, 0, 0, @DesktopWidth, @DesktopHeight)
	GUISetState()
	GUICreate("Unlock Computer", 413, 274, -1, (@DesktopHeight / 2) - (@DesktopHeight / 4.25), 0x00000000 + $WS_EX_TOPMOST)
	GUICtrlCreatePic($WinImage, 0, 0, 0, 0)
	GUICtrlCreateIcon("msgina.dll", 6, 10, 82)
	GUICtrlCreateLabel("This computer is in use and has been locked.", 52, 85, 325, 20)
	GUICtrlCreateLabel("Only " & $username & " or an administrator can unlock this computer.", 52, 105, 345, 40)
	GUICtrlCreateLabel("User name:", 52, 153)
	GUICtrlCreateLabel("Password:", 52, 181)
	$user = GUICtrlCreateInput(@UserName, 119, 150, 185)
	$password = GUICtrlCreateInput("", 119, 178, 185, -1, $ES_PASSWORD)
	$okbutton = GUICtrlCreateButton("OK", 227, 209, 75, 23)
	$cancelbutton = GUICtrlCreateButton("Cancel", 308, 209, 75, 23)
	GUICtrlSetState($cancelbutton, $GUI_DISABLE)
	GUICtrlSetState($password, $GUI_FOCUS)
	GUISetState()
	$msg = 0
EndFunc   ;==>_GUI

Func _Login()
	RunAsSet(GUICtrlRead($user), @LogonDomain, GUICtrlRead($password), 0)
	Run(@ComSpec & " /c dir C:\", @WindowsDir, @SW_HIDE)
	If @error Then
		WinSetOnTop("Unlock Computer", "", 0)
		MsgBox(16, "Computer Locked.", "The password is incorrect. Please retype your password. Letters in passwords must be typed using the correct case.", 1)
		HotKeySet("{Enter}")
		GUICtrlSetData($password, "")
		GUICtrlSetState($password, $GUI_FOCUS)
		WinSetOnTop("Computer Locked.", "", 1)
		HotKeySet("{Enter}", "_Login")
	Else
		RunAsSet()
		FileDelete($WinImage)
		Run("Explorer.exe")
		$GUI_ON = 0
		GUIDelete("Unlock Computer")
		GUIDelete("BG")
		HotKeySet("{ESC}")
		HotKeySet("!{TAB}")
		HotKeySet("!{F4}")
		HotKeySet("^!{INS}")
		HotKeySet("{Enter}")
		HotKeySet("^")
		HotKeySet("!")
		HotKeySet("{F10}","_QuickLock")
	EndIf
EndFunc   ;==>_Login

Func _Nothing()
	Sleep(0)
EndFunc   ;==>_Nothing

Func _ScreenSaverCheck()
	$list = ProcessList()
	$x = 0
	$y = 0
	
	For $i = 1 To $list[0][0]
		$Detected = StringInStr($list[$i][0], ".scr")
		$x = $x + $Detected
		If $x > 0 Then
			$y = $y + 1
			EndIf
	Next
	If $y = 1 And $x > 0 And Not WinExists("Display Properties") Then
		$ScreenSaverDetected = 1
	Else
		$ScreenSaverDetected = 0
	EndIf
	
EndFunc   ;==>_ScreenSaverCheck

Func _QuickLock()
_GUI()
WinSetOnTop("Unlock Computer", "", 1)
EndFunc
