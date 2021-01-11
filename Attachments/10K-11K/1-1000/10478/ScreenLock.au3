; ----------------------------------------------------------------------------
; Screen Lock
;
; AutoIt Version: 3.2.0.1
; Author: Hallman \ CWorks
;
; HotKeys
; F9 = Close program
; F10 = Change password
; F11 = Enable ScreenLock
;
; ----------------------------------------------------------------------------

#include <guiconstants.au3>
#include <string.au3>
Opt("TrayMenuMode", 1)
Dim $Atempts = 0
Dim $Lock = 0
Dim $PassInput = ""
Dim $Label
Dim $ScreenyWindow = ""
Dim $PassWindow = ""
Dim $PassWord = ""

$Show_Controls_Timer = TimerInit()
$Controls_Shown = 0

PassCheck()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE And $Lock = 0
			Exit
			
		Case $msg = $PassInput
			If GUICtrlRead($PassInput) == $PassWord Then
				Lock()
				MsgBox(0, "Atempts", "An incorrect password was entered " & $Atempts & " time(s).")
				$Atempts = 0
			Else
				$Atempts += 1
				SplashMsg("Error", "Invalid Password", 220, 100)
			EndIf
			
		Case $msg = $GUI_EVENT_PRIMARYUP And $Lock = 1
			GUISetState(@SW_SHOW, $PassWindow)
			$Controls_Shown = 1
			$Show_Controls_Timer = TimerInit()
	EndSelect
	
	If TimerDiff($Show_Controls_Timer) > 10000 And $Controls_Shown = 1 Then
		GUISetState(@SW_HIDE, $PassWindow)
		$Controls_Shown = 0
	EndIf
	
	If WinExists("Windows Task Manager") And $Lock = 1 Then
	    WinClose("Windows Task Manager")
	    WinKill("Windows Task Manager")
	EndIf
	
	If WinActive($ScreenyWindow) = 0 And WinActive($PassWindow) = 0 And $Lock = 1 Then
		WinActivate($ScreenyWindow)
	EndIf
	
	If Not BitAND(WinGetState($ScreenyWindow, ""), 2) = 1 And $Lock = 1 Then
		GUISetState(@SW_SHOW)
	EndIf
	
	If $Lock = 1 And WinExists($ScreenyWindow) = 0 Then
		$ScreenyWindow = GUICreate("", @DesktopWidth, @DesktopHeight, -2, -2, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
		GUISwitch($ScreenyWindow)
		WinSetTrans($ScreenyWindow, "", 1)
		GUISetState(@SW_SHOW, $ScreenyWindow)
		WinSetOnTop($ScreenyWindow, "", 1)
		WinSetOnTop($PassWindow, "", 1)
	EndIf
WEnd

Func Lock()
	If $Lock = 0 Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 00000001)
		HotKeySet("{F9}")
		HotKeySet("{F10}")
		HotKeySet("{F11}")
		;      HotKeySet("^!p")  ;Ctrl-Alt-p
		;      HotKeySet("^!l")  ;Ctrl-Alt-l
		
		TraySetIcon ("Shell32.dll", 47)
		
		$ScreenyWindow = GUICreate("", @DesktopWidth + 2, @DesktopHeight + 2, -2, -2, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
		GUISwitch($ScreenyWindow)
		WinSetTrans($ScreenyWindow, "", 1)
		
		Global $PassWindow = GUICreate("", 220, 80, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
		GUISwitch($PassWindow)
		GUISetState(@SW_HIDE)
		Global $Label = GUICtrlCreateLabel("The screen has been locked.", 10, 10, -1, 15)
		;      GUICtrlSetColor(-1,0xff0000)
		Global $PassInput = GUICtrlCreateInput("Password", 10, 30, 200, 20, $ES_PASSWORD)
		Global $Label2 = GUICtrlCreateLabel("Type Password and hit Enter", 10, 55, -1, 15)
		;      GUICtrlSetColor(-1,0xff0000)
		GUISetState(@SW_SHOW, $ScreenyWindow)
		WinSetOnTop($ScreenyWindow, "", 1)
		WinSetOnTop($PassWindow, "", 1)
		$Lock = 1
	Else
		GUIDelete($ScreenyWindow)
		GUIDelete($PassWindow)
		
		HotKeySet("{F9}", "close")
		HotKeySet("{F10}", "Pass")
		HotKeySet("{F11}", "Lock")
		;HotKeySet("^!p", "Pass")  ;Ctrl-Alt-p
		;HotKeySet("^!l", "Lock")  ;Ctrl-Alt-l
		
		TraySetIcon ("Shell32.dll", 44)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 00000000)
		$Lock = 0
	EndIf
	
EndFunc

Func Pass()
	$Main = GUICreate("ScreenLock", 310, 99, 481, 371)
	$PassInput = GUICtrlCreateInput("Password", 8, 32, 153, 21, -1, $WS_EX_CLIENTEDGE)
	$Button1 = GUICtrlCreateButton("OK", 48, 64, 89, 25)
	GUICtrlCreateLabel("Enter Password", 24, 8, 78, 17)
	$Button2 = GUICtrlCreateButton("Cancel", 176, 64, 89, 25)
	$Radio1 = GUICtrlCreateRadio("Write to ScreenLock.ini", 176, 8, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateRadio("Write to Registry", 176, 32, 97, 17)
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button2
				ExitLoop
				
			Case $msg = $PassInput
				$PassWord = GUICtrlRead($PassInput)
				If $PassWord = "" Then
					MsgBox(16, "error", "Invalid password.")
				EndIf
				
			Case $msg = $Button1 And $PassWord <> ""
				If GUICtrlRead($Radio1) = $GUI_CHECKED Then
					$PassWord = _StringEncrypt(1, $PassWord, "4471")
					IniWrite("ScreenLock.ini", "Password", "key", $PassWord)
					ExitLoop
				Else
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\ScreenLock", "Password", "REG_SZ", _StringEncrypt(1, $PassWord, "4471"))
					FileDelete("ScreenLock.ini")
					ExitLoop
				EndIf
		EndSelect
	WEnd
	GUIDelete($Main)
	PassCheck()
EndFunc 

Func PassCheck()
	$PassWord = IniRead("ScreenLock.ini", "Password", "key", "")
	If $PassWord = "" Then
		$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\ScreenLock", "Password")
	EndIf
	If $PassWord <> "" Then
		$PassWord = _StringEncrypt(0, $PassWord, "4471")
	Else
		Pass()
	EndIf
	Lock()
EndFunc

Func SplashMsg($S_Title = "", $S_Text = "", $S_Size_X = 300, $S_Size_Y = 300)
	SplashTextOn($S_Title, $S_Text & @CRLF & "Press Enter to close this window.", $S_Size_X, $S_Size_Y)
	HotKeySet("{ENTER}", "OffSplash")
EndFunc 

Func OffSplash()
	SplashOff()
	HotKeySet("{ENTER}")
EndFunc

Func close()
	Exit
EndFunc