#RequireAdmin

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiStatusBar.au3>
#include "testGuiTwo.au3"

Global $1 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
Global $cpu = @OSArch
Global $drvletter = @ScriptDir
Global $ip = @IPAddress1
Global $os = @OSVersion
Global $morronicLogo = $drvletter & "\Project Files\Images\morronic1.bmp"

Switch $cpu
	Case "X64"
		$cpu = " 64 bit"
	Case "X86"
		$cpu = " 32 bit"
	Case Else
		$cpu = "Unknown Processor!"
EndSwitch

Switch $os ; A Switch statement. We are going to make the value returned by @OSVERSION more readable.
	Case "WIN_8"
		$os = "Windows 8"
	Case "WIN_2008"
		$os = "Windows Server 2008"
	Case "WIN_7"
		$os = "Windows 7"
	Case "WIN_VISTA"
		$os = "Windows Vista"
	Case "WIN_2003"
		$os = "Windows Server 2003"
	Case "WIN_XP"
		$os = "Windows XP"
	Case "WIN_2000"
		$os = "Windows 2000"
	Case "WIN_NT4"
		$os = "Windows NT 4.0"
	Case "WIN_ME"
		$os = "Windows ME"
	Case "WIN_98"
		$os = "Windows 98"
	Case "WIN_95"
		$os = "Windows 95"
	Case Else
		$os = "Unknown!"
EndSwitch

	Global $mainGui = GUICreate("Main Window", 550, 600, -1, -1, BitXOR($WS_SYSMENU, $WS_MINIMIZEBOX))
	GUICtrlCreatePic($morronicLogo, 200, 13, 312, 150)

	Global $butSecondGui = GUICtrlCreateButton("Click Me", 240, 260, 100, 30)
	GUISetState(@SW_SHOW)

	;StatusBar setup at the bottom
	$StatusBar = _GUICtrlStatusBar_Create($mainGui)
	Dim $StatusBar_PartsWidth[3] = [150, 450, -1]
	_GUICtrlStatusBar_SetParts($StatusBar, $StatusBar_PartsWidth)
	_GUICtrlStatusBar_SetText($StatusBar, @ComputerName, 0)
	_GUICtrlStatusBar_SetText($StatusBar, @TAB & $1 & $cpu, 1)
	_GUICtrlStatusBar_SetText($StatusBar, @TAB & $ip, 2)
	_GUICtrlStatusBar_SetMinHeight($StatusBar, 25)

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Gui_Event_Close
				Exit
			Case $butSecondGui
				guiLaunch()
		EndSwitch
	WEnd




