;~ By, Hallman

;~ Win Transparancy thing thanks to marfdaman (Now it works alot better!)


#compiler_plugin_funcs = CaptureScreen

Opt("TrayMenuMode",1)

Global $Go_Button = -999
Dim $Atempts = 0
Dim $Lock = 0
Dim $PassInput = ""
Dim $Label
#include <guiconstants.au3>
#include <string.au3>

Dim $ScreenyWindow = ""

$MainWindow = GUICreate("Computer Lock",190,40)
GUISetState(@SW_SHOW)

$LockButton = GUICtrlCreateButton("Lock",10,10,50,20)

$SetPassButton = GUICtrlCreateButton("Set Password",70,10,100,20)

$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Andy\ScreenLock", "Password")

If $PassWord <> "" Then
    $PassWord = _StringEncrypt(0,$PassWord,"4471")
Else
	GUICtrlSetState($LockButton,$GUI_DISABLE)
EndIf

$Show_Controls_Timer = TimerInit()

$Controls_Shown = 0

While 1
    $msg = GuiGetMsg()
	Select			
	Case $msg = $GUI_EVENT_CLOSE And $Lock = 0
		Exit
	Case $msg = $LockButton 
		Lock()
	Case $msg = $SetPassButton
		If $PassWord <> "" Then
			$OldPass = InputBox("Old Password","Enter your old password","","*")
			
			If $OldPass == $PassWord Then
				$NewPass = InputBox("New Password","Enter your new password")
				If @error Then
					
				Else
					$PassWord = $NewPass
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Andy\ScreenLock", "Password","REG_SZ", _StringEncrypt(1,$PassWord,"4471"))
				EndIf
			
		    ElseIf @error Then
			
			Else
				MsgBox(16,"error","Invalid password.")
			EndIf
		Else
			$NewPass = InputBox("New Password","Enter your new password")
			If @error Then
					
			Else
				$PassWord = $NewPass
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Andy\ScreenLock", "Password","REG_SZ", _StringEncrypt(1,$PassWord,"4471"))
				GUISwitch($MainWindow)
				GUICtrlSetState($LockButton,$GUI_ENABLE)
			EndIf
			
		EndIf
		
	Case $msg = $Go_Button
		If GUICtrlRead($PassInput) == $PassWord Then 
			Lock()
			MsgBox(0,"Atempts","An incorrect password was entered " & $Atempts & " time(s).")
		    $Atempts = 0
		Else
			$Atempts += 1
			
			SplashMsg("Error","Invalid Password",220,100)
			
		EndIf
	Case $msg = $GUI_EVENT_PRIMARYUP And $Lock = 1
		GUISetState(@SW_SHOW,$PassWindow)
			
		$Controls_Shown = 1
		
		$Show_Controls_Timer = TimerInit()

	EndSelect
	
	If TimerDiff($Show_Controls_Timer) > 10000 And $Controls_Shown = 1 Then
		GUISetState(@SW_HIDE,$PassWindow)
			
		$Controls_Shown = 0
		
	EndIf
	
	If WinExists("Windows Task Manager") And $Lock = 1 Then
		WinClose("Windows Task Manager")
		WinKill("Windows Task Manager")
	EndIf
	
	If WinActive($ScreenyWindow) = 0 And WinActive($PassWindow) = 0 And $Lock = 1 Then
		WinActivate($ScreenyWindow)
	EndIf
	
	If Not BitAnd(WinGetState($ScreenyWindow, ""),2) = 1 And $Lock = 1 Then
		GUISetState (@SW_SHOW)
		
	EndIf
	
	
	If $Lock = 1 And WinExists($ScreenyWindow) = 0 Then
		GUISwitch($MainWindow)
		GUISetState(@SW_HIDE,$MainWindow)
;~ 		Sleep(250)
;~ 		$hPlugin = PluginOpen(@scriptdir & "\captplugin.dll")
;~         CaptureScreen("Screen.bmp")
;~         PluginClose($hPlugin)
		
;~ 		Sleep(500)
		
		$ScreenyWindow = GUICreate("",@DesktopWidth,@DesktopHeight,-2,-2,$WS_POPUPWINDOW,$WS_EX_TOOLWINDOW)
		GUISwitch($ScreenyWindow)
		WinSetTrans($ScreenyWindow,"",1)
;~ 		$MainPic = GUICtrlCreatePic("Screen.bmp",0,0,@DesktopWidth,@DesktopHeight)
;~ 		GUICtrlSetState(-1,$GUI_DISABLE)
		
		Global $PassWindow = GUICreate("",220,90,-1,-1,$WS_POPUPWINDOW,$WS_EX_TOOLWINDOW)
		GUISwitch($PassWindow)
		GUISetState(@SW_HIDE)
		
		Global $Label = GUICtrlCreateLabel("The screen has been locked.",10,10,-1,15)
		GUICtrlSetColor(-1,0xff0000)
		
		Global $PassInput = GUICtrlCreateInput("Password",10,30,200,20,$ES_PASSWORD)

		Global $Go_Button = GUICtrlCreateButton("Unlock",60,60,100,20)
		
		GUISetState(@SW_SHOW,$ScreenyWindow)
		WinSetOnTop($ScreenyWindow, "", 1)
		WinSetOnTop($PassWindow, "", 1)


	EndIf
	
WEnd


Func Lock()
	If $Lock = 0 Then
		GUISwitch($MainWindow)
		GUISetState(@SW_HIDE,$MainWindow)
;~ 		Sleep(250)
;~ 		$hPlugin = PluginOpen(@scriptdir & "\captplugin.dll")
;~         CaptureScreen("Screen.bmp")
;~         PluginClose($hPlugin)
		
;~ 		Sleep(500)
		
		$ScreenyWindow = GUICreate("",@DesktopWidth + 2,@DesktopHeight + 2,-2,-2,$WS_POPUPWINDOW,$WS_EX_TOOLWINDOW)
		GUISwitch($ScreenyWindow)
		WinSetTrans($ScreenyWindow,"",1)
;~ 		$MainPic = GUICtrlCreatePic("Screen.bmp",0,0,@DesktopWidth,@DesktopHeight)
;~ 		GUICtrlSetState(-1,$GUI_DISABLE)
		
		Global $PassWindow = GUICreate("",220,90,-1,-1,$WS_POPUPWINDOW,$WS_EX_TOOLWINDOW)
		GUISwitch($PassWindow)
		GUISetState(@SW_HIDE)
		
		Global $Label = GUICtrlCreateLabel("The screen has been locked.",10,10,-1,15)
		GUICtrlSetColor(-1,0xff0000)
		
		Global $PassInput = GUICtrlCreateInput("Password",10,30,200,20,$ES_PASSWORD)

		Global $Go_Button = GUICtrlCreateButton("Unlock",60,60,100,20)
		
		GUISetState(@SW_SHOW,$ScreenyWindow)
		WinSetOnTop($ScreenyWindow, "", 1)
		WinSetOnTop($PassWindow, "", 1)

		$Lock = 1
	Else
		
		GUIDelete($ScreenyWindow)
		GUIDelete($PassWindow)
		
		GUISwitch($MainWindow)
		
		GUISetState(@SW_SHOW,$MainWindow)
		
		$Lock = 0
	EndIf
	
	
EndFunc


Func SplashMsg($S_Title = "",$S_Text = "",$S_Size_X = 300,$S_Size_Y = 300)
	SplashTextOn($S_Title,$S_Text & @CRLF & "Press Enter to close this window.",$S_Size_X,$S_Size_Y)
	
	HotKeySet("{ENTER}","OffSplash")
EndFunc


Func OffSplash()
	SplashOff()
	HotKeySet("{ENTER}")
	
EndFunc
