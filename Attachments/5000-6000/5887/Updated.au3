;This only works with BETA verison of AutoIt
;
;
#include <GUIConstants.au3>

; == GUI generated with Koda ==

	Dim $UpdateRate, $File, $Check, $CheckComplete, $IniCheck, $FileName, $QuickBarHP, $QuickBarMP, $ConfirmedINT, $CheckHP, $CheckMP, $ShowError
	Dim $LoopCheck, $HealthCheck, $PixelCheck1, $Heal, $Program, $PixelCheck2, $Power, $VarSleep, $VarPower, $VarHealth, $CheckProgram, $NotRunning, $GlobalLoop
	Dim $CheckPause, $Clicked, $Executed, $Paused, $Tray, $Minimized, $UpdateDir, $VarDir, $VerifyDir, $CheckProcess1, $CheckProcess2, $OpenFile, $Convert, $ShowStatus
	
	Global $Paused	;To make sure the script can be paused
	
	Global Const $TRAY_DEFAULT = 512 ;Used for minimize to tray
	#NoTrayIcon;Used for minimize to tray, dont show icon at beginning
	
	
	;TraySetState(1) ;Make sure the tray doesnt show any options
	
	;Hopefully this can break the program, no matter if it already is in another loop
	;Opt("GUICoordMode",2)	;This part messed up the entire script
	Opt("GUIOnEventMode",1)
	
	Opt("TrayAutoPause", 0)	;Used for minimize to tray
	Opt("TrayMenuMode", 1)	;Used for minimize to tray
	
	HotKeySet("+!d", "Quit")  ;Shift-Alt-d
	HotKeySet("{PAUSE}", "PauseButton")
	
	AdlibEnable("adRoutine") ;Very important part to check so PauseButton works like it should
	
	$Paused = 0
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
	
;Start of GUI interface creation

;Create the form, application look and size

$Form1 = GUICreate("Health Check v1.0", 455, 335, 287, 278) 

	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents") ;SpecialEvents, like X in the window
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "MinMizeToTray");Tray Minimize

;Start of Update Rate group box

$Group1 = GUICtrlCreateGroup("Update Rate", 232, 8, 217, 105)
GUICtrlCreateLabel("Enter how often to check for a difference in health/power. Default is 1500.", 240, 24, 203, 33)
$Input1 = GUICtrlCreateInput($UpdateRate, 280, 64, 49, 21, -1, $WS_EX_CLIENTEDGE)
$Button1 = GUICtrlCreateButton("Accept", 336, 64, 75, 25)

	GUICtrlSetOnEvent(-1, "UpdateAccept")	;This is an event, in case this button is pressed
	
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Update Rate group box

;Start of Quickbar group box

$Group2 = GUICtrlCreateGroup("Quickbar", 8, 120, 217, 105)
GUICtrlCreateLabel("Enter quickbar location for health and power pots here.", 16, 136, 199, 25)
GUICtrlCreateLabel("Health Pot", 64, 168, 54, 17)
GUICtrlCreateLabel("Power Pot", 64, 192, 53, 17)
$Button2 = GUICtrlCreateButton("Accept", 128, 176, 75, 25)

	GUICtrlSetOnEvent(-1, "QuickbarAccept")	;This is another event, in case this button is pressed

$Combo1 = GUICtrlCreateCombo("", 16, 168, 41, 21)

	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarHP) ;This adds a list to choose from 0-9, default is saved.ini | Health
	
$Combo2 = GUICtrlCreateCombo("", 16, 192, 41, 21)

	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarMP) ;This adds a list to choose from 0-9, default is saved.ini | Power
	
GUICtrlCreateGroup("", -99, -99, 1, 1)

;End of Quickbar group box

;Start of Options group box

$Group3 = GUICtrlCreateGroup("Options", 8, 232, 217, 97)
$Button3 = GUICtrlCreateButton("Exit", 128, 296, 75, 25)

	GUICtrlSetOnEvent(-1, "ExitButton")	;Exit button event
	
$Button4 = GUICtrlCreateButton("Pause", 16, 296, 75, 25)
	
	GUICtrlSetOnEvent(-1, "PauseButton") ;Pause Button event
	
GUICtrlCreateLabel("You can quit the program by pressing SHIFT-ALT-D. You can also pause the program by pressing Pause/Break.", 16, 248, 203, 41)
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

	GUICtrlSetOnEvent(-1, "SaveFileInfo")	;Open File Dialog with this button, --- Why is this part causing crashes?
	
GUICtrlCreateLabel("", 248, 144, 4, 4)
GUICtrlCreateLabel("Use open and locate your silkroad.exe", 240, 136, 185, 17)
$Button6 = GUICtrlCreateButton("Run", 360, 160, 75, 25)

	GUICtrlSetOnEvent(-1, "RunGame")	;This button starts the selected executable
	
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

	$List1 = GUICtrlCreateList($ShowStatus, 240, 264, 169, 32, $LBS_NOSEL) ;$LBS_NOSEL, $WS_EX_CLIENTEDGE .. 32
	
$ShowError = "No Errors."
	
	$List2 = GUICtrlCreateList($ShowError, 240, 285, 169, 32, $LBS_NOSEL) ;$LBS_NOSEL, $WS_EX_CLIENTEDGE .. 240, 264, 169, 32
	
GUICtrlCreateGroup("", -99, -99, 1, 1)


;End of Status group box

GUISetState(@SW_SHOW)

;End of GUI interface creation


	$foo = TrayCreateItem("Restore Window")	;Used by minimize to tray
	TrayItemSetState(-1, $TRAY_DEFAULT)	;Used by minimize to tray
	TraySetClick ( 0 );don't show menu item when clicked


	Func HealthCheck()
		$PixelCheck1 = PixelGetColor(143,35)
	
		If $PixelCheck1 == 1053712 Then
			$Heal = 1
		ElseIf $PixelCheck1 == 11075600 Then
			$Heal = 0
		Else
		EndIf
	EndFunc
	
	Func PowerCheck()
		$PixelCheck2 = PixelGetColor(146,50)
	
		If $PixelCheck2 == 1578008 Then
			$Power = 1
		ElseIf $PixelCheck2 == 1584244 Then
			$Power = 0
		Else
		EndIf
	EndFunc
	
	Func Quit()
		Exit
	EndFunc
	
	Func Update()
		Sleep($VarSleep)
	EndFunc
	
	Func UpdateToolTip()

	If $Heal == 1 Then
		If $Power == 1 Then
			ToolTip("HP- MP-",0,0)
		Else
			ToolTip("HP- MP+",0,0)
		EndIf
	Else
		If $Power == 0 Then
			ToolTip("HP+ MP+",0,0)
		Else
			ToolTip("HP+ MP-",0,0)
		EndIf
	EndIf

	EndFunc
	
	Func VarUpdate()
		$VarSleep = IniRead(@ScriptDir & $FileName, "UPDATE", "Refresh", "Not Found")
		$VarPower = IniRead(@ScriptDir & $FileName, "POWER", "Quickbar", "Not Found")
		$VarHealth = IniRead(@ScriptDir & $FileName, "HEALTH", "Quickbar", "Not Found")
		$VarDir = IniRead(@ScriptDir & $FileName, "GAME", "Dir", "Not Found")
	EndFunc
	
	Func adRoutine()	;This makes sure the pause button works like it should, and stops the pause loop when pause button is hit a second time
		While $Paused
			;ToolTip("Program is paused.",0,0)
			$ShowMessage = "Program is paused."
			
			GUICtrlSetData($List1, "")
			GUICtrlSetData($List1, $ShowMessage)
			Sleep(500)
		WEnd
	EndFunc  

	Func PauseButton()
		$Paused = NOT $Paused
	EndFunc
	
While 1

			;---------------- PROBLEM IS BELOW ---------------
			While $Program == 0
			
			If $Program == 0 Then
				
				If WinExists("Silkroad Online Launcher") Then
					$LauncherRunning = 1
					$ShowStatus = "Silkroad Online Launcher is running."
					
					GUICtrlSetData($List1, "")
					GUICtrlSetData($List1, $ShowStatus)
					Sleep(100)
					
				Else
					$LauncherRunning = 0
					$ShowStatus = "Silkroad is not running."
					GUICtrlSetData($List1, "")
					GUICtrlSetData($List1, $ShowStatus)
					Sleep(100)
					
				EndIf
				
				If WinExists("SRO_Client") Then ;Checks if Silkroad is currently running
					$ShowStatus = "Silkroad Online is running."
					
					GUICtrlSetData($List1, "")
					GUICtrlSetData($List1, $ShowStatus)
					Sleep(100)
					$Program = 1
					
					ExitLoop
				Else
					If $LauncherRunning = 0 Then
						$ShowStatus = "Silkroad is not running."
						
						GUICtrlSetData($List1, "")
						GUICtrlSetData($List1, $ShowStatus)
						Sleep(100)
						
					Else
					EndIf

					$Program = 0
					Sleep(1000)
				EndIf
			Else
			EndIf
			
			WEnd
			
			; -------------- PROBLEM IS ABOVE -------------
			
			If $Program == 1 Then
				VarUpdate()		;Checks if any values have changed in saved.ini
				UpdateToolTip()	;Updates the ToolTip to show any changes in health or power
			Else
			EndIf
		
			If $Program == 1 Then
				HealthCheck()	;Checks players health, if lower then 50% then drink a pot
				If $Heal == 1 Then
					Send($VarHealth)
				Else
				EndIf
	
				PowerCheck()	;Checks players power, if lower then 50% then drink a pot
				If $Power == 1 Then
					Send($VarPower)
				Else
				EndIf
			EndIf
		
			If $Program == 1 Then
				UpdateToolTip()	;Updates the ToolTip to show any changes in health or power
			Else
			EndIf
			
			If $Program == 1 Then
				Update()
			Else
			EndIf
	

WEnd
	
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
			
			$ShowError = "Health/Power Pot quickbar location has been saved."
			
			GUICtrlSetData($List2, "")
			GUICtrlSetData($List2, $ShowError)
		Else
		EndIf
	EndFunc
	
	Func ExitButton()
		Exit
	EndFunc
		
	Func SpecialEvents()
		Select
			Case @GUI_CTRLID = $GUI_EVENT_CLOSE
			Exit
		EndSelect
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
	
	Func SaveFileInfo() ;This part is causing the crash

		$OpenFile = FileOpenDialog("Locate your silkroad.exe!", @ScriptDir, "Executables (*.exe)", 1) ;", 1 + 2 )
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
			
			
			
		
	
