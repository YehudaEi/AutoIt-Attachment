#include <GUIConstants.au3>

HotKeySet("+!d", "Quit")  ;Shift-Alt-d

;Variables

	

	Global $UpdateRate, $File, $Check, $CheckComplete, $IniCheck, $FileName, $QuickBarHP, $QuickBarMP, $ConfirmedINT, $CheckHP, $CheckMP, $ShowError
	Global $LoopCheck, $HealthCheck, $PixelCheck1, $Heal, $Program, $PixelCheck2, $Power, $VarSleep, $VarPower, $VarHealth, $CheckProgram, $NotRunning, $GlobalLoop
	Global $CheckPause, $Clicked, $Executed, $Paused, $Tray, $Minimized, $UpdateDir, $VarDir, $VerifyDir, $CheckProcess1, $CheckProcess2, $OpenFile, $Convert, $ShowStatus
	Global $AlreadyShownStatus1, $AlreadyShownStatus2, $AlreadyShownStatus3, $AlreadyShownStatus4

	$Executed = 0
	$Clicked = 0
	$CheckPause = 0
	$Check = 0
	$CheckComplete = 0
	$FileName = "\saved.ini"
	$Minimized = 0
	$ShowStatus = ""
	$Program = 0
	$ShowError = ""
	
	$AlreadyShown = 0
	$AlreadyShownStatus1 = 0
	$AlreadyShownStatus2 = 0
	$AlreadyShownStatus3 = 0
	$AlreadyShownStatus4 = 0
	
	


CheckIfIniExist()

;Variables End

	Opt("TrayAutoPause", 0)	;Used for minimize to tray
	Opt("TrayMenuMode", 1)	;Used for minimize to tray
	
	Global Const $TRAY_DEFAULT = 512 ;Used for minimize to tray
	#NoTrayIcon;Used for minimize to tray, dont show icon at beginning
	
;Start of GUI

$Form1 = GUICreate("Health Check v1.0", 455, 335, 287, 278) 

;Start of Update Rate group box

$Group1 = GUICtrlCreateGroup("Update Rate", 232, 8, 217, 105)
GUICtrlCreateLabel("Enter how often to check for a difference in health/power. Default is 1500.", 240, 24, 203, 33)
$Input1 = GUICtrlCreateInput($UpdateRate, 280, 64, 49, 21, -1, $WS_EX_CLIENTEDGE)
$Button1 = GUICtrlCreateButton("Accept", 336, 64, 75, 25)

GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Update Rate group box

;Start of Quickbar group box

$Group2 = GUICtrlCreateGroup("Quickbar", 8, 120, 217, 105)
GUICtrlCreateLabel("Enter quickbar location for health and power pots here.", 16, 136, 199, 25)
GUICtrlCreateLabel("Health Pot", 64, 168, 54, 17)
GUICtrlCreateLabel("Power Pot", 64, 192, 53, 17)
$Button2 = GUICtrlCreateButton("Accept", 128, 176, 75, 25)

$Combo1 = GUICtrlCreateCombo("", 16, 168, 41, 21)

	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarHP) ;This adds a list to choose from 0-9, default is saved.ini | Health
	
$Combo2 = GUICtrlCreateCombo("", 16, 192, 41, 21)

	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarMP) ;This adds a list to choose from 0-9, default is saved.ini | Power
	
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Quickbar group box

;Start of Options group box

$Group3 = GUICtrlCreateGroup("Options", 8, 232, 217, 97)
$Button3 = GUICtrlCreateButton("Exit", 128, 296, 75, 25)
		
GUICtrlCreateLabel("You can quit the program by pressing SHIFT-ALT-D.", 16, 248, 203, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Options group box

;Start of Information group box

$Group4 = GUICtrlCreateGroup("Information", 8, 8, 217, 105)
GUICtrlCreateLabel("Made by Snike.", 136, 88, 78, 17)
GUICtrlCreateLabel("Please start this program when Silkroad Online is running. Fill out the various settings below.", 16, 24, 202, 57)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Information group box

;Start of Game Location group box

$Group5 = GUICtrlCreateGroup("Game Location", 232, 120, 217, 105)
$Button5 = GUICtrlCreateButton("Open", 240, 160, 75, 25)
	
GUICtrlCreateLabel("", 248, 144, 4, 4)
GUICtrlCreateLabel("Use open and locate your silkroad.exe", 240, 136, 185, 17)
$Button6 = GUICtrlCreateButton("Run", 360, 160, 75, 25)

;$Input2 = GUICtrlCreateInput("AInput2", 240, 192, 193, 21, -1, $WS_EX_CLIENTEDGE);$UpdateDir
$mylist=GUICtrlCreateList ($UpdateDir, 240, 192, 193, 21, $LBS_NOSEL)

GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Game Location group box

;Start of Status group box

$Group6 = GUICtrlCreateGroup("Status", 232, 232, 217, 97)
GUICtrlCreateLabel("Here you can see what is going on.", 240, 248, 171, 17)

GUICtrlCreateLabel("version 1.0", 400, 312, 42, 14)
GUICtrlSetFont(-1, 4, 400, 0, "MS Serif")

$ShowStatus = "Nothing to show."

	$List1 = GUICtrlCreateList($ShowStatus, 240, 264, 200, 32, $LBS_NOSEL) ;$LBS_NOSEL, $WS_EX_CLIENTEDGE .. 32
	
	;GUICtrlSetLimit(-1,1)
	
$ShowError = "No Errors."
	
	$List2 = GUICtrlCreateList($ShowError, 240, 285, 200, 32, $LBS_NOSEL) ;$LBS_NOSEL, $WS_EX_CLIENTEDGE .. 240, 264, --169--, 32
													; ^--- change this
	;GUICtrlSetLimit(-1,1)
	
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Status group box

GUISetState(@SW_SHOW)

	$foo = TrayCreateItem("Restore Window")	;Used by minimize to tray
	TrayItemSetState(-1, $TRAY_DEFAULT)	;Used by minimize to tray
	TraySetClick ( 0 );don't show menu item when clicked

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
	Select
		Case $msg = $Button1 ;Update Rate - Accept Button
		
			UpdateAccept()
		
		Case $msg = $Button2 ;Quickbar - Accept Button
		
			QuickbarAccept()
			
		Case $msg = $Button3 ;Exit Button
			
			ExitButton()
			
		Case $msg = $Button5 ;File Open Dialog button
			
			SaveFileInfo()
		   
		Case $msg = $Button6 ;Run Game button
			
			RunGame()
	EndSelect
	
	If $AlreadyShown == 0 Then
		SetVariables()
	Else
	EndIf
	IsGameRunning()

Wend

;Functions

Func CheckIfIniExist()
		;Check if saved.ini exists, if not make one
	$File = FileOpen(@ScriptDir & $FileName, 1)
	If FileExists(@ScriptDir & $FileName) Then
		$Check = 1
	Else
		$Check = 0
	EndIf
	
	If $Check = 0 Then
		FileWrite(@ScriptDir & $File, "[PROGRAM]" & @CRLF)
		FileWrite(@ScriptDir & $File, "Installed=0")
		FileClose(@ScriptDir & $File)
	Else
	EndIf
	
	
	;Check if saved.ini already been created
	
	While $CheckComplete = 0
	
		$IniCheck = IniRead(@ScriptDir & $FileName,"PROGRAM","Installed","NotFound")
			If $IniCheck == 0 Then
				;First time saved.ini is being run, adding defaults.
				FileDelete($FileName)
				Sleep(100)
				IniWrite(@ScriptDir & $FileName, "PROGRAM", "Installed", "1")
				IniWrite(@ScriptDir & $FileName, "UPDATE", "Refresh", "1500")
				IniWrite(@ScriptDir & $FileName, "HEALTH", "Quickbar", "9")
				IniWrite(@ScriptDir & $FileName, "POWER", "Quickbar", "0")
				IniWrite(@ScriptDir & $FileName, "GAME", "Dir", "C:\Silkroad\silkroad.exe")
				$CheckComplete = 1
				
			ElseIf $IniCheck == 1 Then
				;Saved.ini was found and has already been installed
				$CheckComplete = 1
			
			Else
				;Saved.ini was found, but has no valid information
				;Deleting Saved.ini and creating a new one.
				FileDelete(@ScriptDir & $FileName)
				Sleep(100)
				IniWrite(@ScriptDir & $FileName, "PROGRAM", "Installed", "1")
				IniWrite(@ScriptDir & $FileName, "UPDATE", "Refresh", "1500")
				IniWrite(@ScriptDir & $FileName, "HEALTH", "Quickbar", "9")
				IniWrite(@ScriptDir & $FileName, "POWER", "Quickbar", "0")
				IniWrite(@ScriptDir & $FileName, "GAME", "Dir", "C:\Silkroad\silkroad.exe")
				$CheckComplete = 1
			EndIf
		WEnd

	;Read the Saved.ini for values.
	$UpdateRate = IniRead(@ScriptDir & $FileName, "UPDATE", "Refresh", "")
	$QuickBarHP = IniRead(@ScriptDir & $FileName, "HEALTH", "Quickbar", "")
	$QuickBarMP = IniRead(@ScriptDir & $FileName, "POWER", "Quickbar", "")
	$UpdateDir = IniRead(@ScriptDir & $FileName, "GAME", "Dir", "")
EndFunc
			
Func RunGame()
		If WinExists("SRO_client") == 1 Then
			;MsgBox(16, "ERROR!", "Silkroad is already running.")
			$ShowError = "Silkroad is already running."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			
			$CheckProcess = 1
		Else
			$CheckProcess1 = 0
		EndIf
		If WinExists("Silkroad Online Launcher") == 1 Then
			;MsgBox(16, "ERROR!", "Silkroad is already running.")
			$ShowError = "Silkroad is already running."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			$CheckProcess = 1
		Else
			$CheckProcess2 = 0
		EndIf
			
		If $CheckProcess1 == 0 Then
			If $CheckProcess2 == 0 Then
				
				$VerifyDir = IniRead(@ScriptDir & $FileName, "GAME", "Dir", "")
				
				If StringInStr($VerifyDir, "silkroad.exe") <> 0 Then
					If FileExists($VerifyDir) == 1 Then
						$RunGame = $VerifyDir
						Run($RunGame)
					Else
						;MsgBox(16, "ERROR!", "Path to silkroad.exe is invalid!")
						$ShowError = "Path to silkroad.exe is invalid!"
			
						GUICtrlSetData($List2, "")
						GUICtrlSetData($List2, $ShowError)
					EndIf
				Else
					;MsgBox(16, "ERROR!", "Path to silkroad.exe is invalid, please verify location!")
					$ShowError = "Path is invalid, please verify location!"
			
					GUICtrlSetData($List2, "")
					GUICtrlSetData($List2, $ShowError)
				EndIf
			Else
			EndIf
		Else
		EndIf
EndFunc

Func SaveFileInfo() ;This part is causing the crash

		$OpenFile = FileOpenDialog("*_*", @ScriptDir, "Test (*.*)", 1) ;", 1 + 2 )
		$Convert = $OpenFile
		
	
	If StringInStr($Convert, "silkroad.exe") <> 0 Then
			IniWrite(@ScriptDir & $FileName, "GAME", "Dir", $Convert)
			
			
			GUICtrlSetData($mylist, "")
			GUICtrlSetData($mylist, $Convert)
			
			;MsgBox(64, "Success", "Path has been saved: " & @CRLF & $Convert)
			
			$ShowError = "Path has been saved."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			
		Else
			;MsgBox(16, "ERROR!", "You must select silkroad.exe!")
			
			
			$ShowError = "You must select silkroad.exe!"
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			
	EndIf
		; Script crash right here when function is about to exit, it does NOT get back to loop
EndFunc

Func ExitButton()
	Exit
EndFunc

Func MinMizeToTray()
		GuiSetState(@SW_HIDE);hide GUI
		Opt("TrayIconHide", 0);show tray icon
		TrayTip("Health Check", "Minimized!",5,1)
		AdlibEnable("RESTOREWINDOW", 1)
EndFunc
	
Func RESTOREWINDOW()
		$trayMsg = TrayGetMsg()
			If $trayMsg = $foo Then
			GuiSetState(@SW_SHOW);show GUI
			Opt("TrayIconHide", 1);hide tray icon
		AdlibDisable()
		EndIf
EndFunc
	
Func QuickbarAccept()
		$CheckHP = GUICtrlRead($Combo1) 
		$CheckMP = GUICtrlRead($Combo2)
		
		If $CheckHP == $CheckMP Then
			$Check = 1
			;MsgBox(16, "ERROR!", "You can't use same quickbar slot twice.")
			$ShowError = "You can't use same quickbar slot twice."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
		Else
			$Check = 0
		EndIf
		
		If $Check == 0 Then
			IniWrite(@ScriptDir & $FileName, "HEALTH", "Quickbar", $CheckHP)
			IniWrite(@ScriptDir & $FileName, "POWER", "Quickbar", $CheckMP)
			;MsgBox(64, "Success", "Health Pot set to quickbar: " & $CheckHP & @CRLF & "Power Pot set to quickbar: " & $CheckMP)
			
			$ShowError = "Quickbar location has been saved."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
		Else
		EndIf
EndFunc

Func UpdateAccept()
		$Check = GUICtrlRead($Input1)		
		$Convert = Number($Check)		
		$Confirm = StringIsInt($Convert)
		
		If $Confirm == 0 Then
			;MsgBox(16, "ERROR!", "You can only use numbers.")
			$ShowError = "You can only use numbers."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			
		ElseIf $Confirm == 1 Then
			If $Convert == 0 Then
			;MsgBox(16, "ERROR!", "Use only numbers, please.")
				
			$ShowError = "You can only use numbers."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
			
			Else
				$ConfirmedINT = $Convert
				IniWrite(@ScriptDir & $FileName, "UPDATE", "Refresh", $ConfirmedINT)
				
				$ShowError = " was saved."
			;	MsgBox(64, "Success", $ConfirmedINT & " was saved.")
			
				GUICtrlSetData($List2, "")
				GUICtrlSetData($List2, $ConfirmedINT & $ShowError )
			EndIf
		Else
			MsgBox(16, "ERROR!", "WTF something is fucked up. ErrorCode: 47")
		EndIf
EndFunc
	
Func Quit()
	ProcessClose("SecProgram.exe")

	$PID = ProcessExists("SecProgram.exe") ; Will return the PID or 0 if the process isn't found.
	If $PID Then ProcessClose($PID)
	Exit
EndFunc


Func IsGameRunning()
		;---------------- PROBLEM IS BELOW ---------------
			;While $Program == 0
			
			If $Program == 0 Then
				
				If WinExists("Silkroad Online Launcher") Then
					$LauncherRunning = 1
					
					If $AlreadyShownStatus1 == 1 Then
						$AlreadyShownStatus1 = 0
					Else
						$ShowStatus = "Silkroad Online Launcher is running."
						GUICtrlSetData($List1, "")
						GUICtrlSetData($List1, $ShowStatus)
						;Sleep(10)
						$AlreadyShownStatus1 = 1
					EndIf
					
				Else
					
					$LauncherRunning = 0
					
					If $AlreadyShownStatus2 == 1 Then
						$AlreadyShownStatus2 = 0
					Else
						$ShowStatus = "Silkroad is not running."
						GUICtrlSetData($List1, "")
						GUICtrlSetData($List1, $ShowStatus)
						;Sleep(10)
						$AlreadyShownStatus2 = 1
					EndIf
					
				EndIf
				
				If WinExists("SRO_Client") Then ;Checks if Silkroad is currently running
					
					$Program = 1
					
					If $AlreadyShownStatus3 == 1 Then
						
						$ShowStatus = "Silkroad Online is running."
					
						GUICtrlSetData($List1, "")
						GUICtrlSetData($List1, $ShowStatus)
						;Sleep(10)
						;$Program = 1
						$AlreadyShownStatus3 = 1
					Else
						$AlreadyShownStatus3 = 0
					EndIf
					
				Else
					If $LauncherRunning = 0 Then
						
						If $AlreadyShownStatus4 == 1 Then
						Else
							$ShowStatus = "Silkroad is not running."
						
							GUICtrlSetData($List1, "")
							GUICtrlSetData($List1, $ShowStatus)
							;Sleep(10)
							$AlreadyShownStatus4 = 1
						EndIf
						
					Else
						$AlreadyShownStatus4 = 0
					EndIf

					$Program = 0
				EndIf
			Else
			EndIf
			
			;WEnd
			
			; -------------- PROBLEM IS ABOVE -------------
			
			If $Program == 1 Then
				Run(@ScriptDir & "SecProgram.exe")
			Else
			EndIf
			Sleep(10)

EndFunc

Func SetVariables()
	$AlreadyShown = 1
	$AlreadyShownStatus1 = 0
	$AlreadyShownStatus2 = 0
	$AlreadyShownStatus3 = 0
	$AlreadyShownStatus4 = 0
EndFunc


