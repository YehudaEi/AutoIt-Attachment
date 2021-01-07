;This only works with BETA verison of AutoIt
;
;
#include <GUIConstants.au3>

; == GUI generated with Koda ==

	Dim $UpdateRate, $File, $Check, $CheckComplete, $IniCheck, $FileName, $QuickBarHP, $QuickBarMP, $ConfirmedINT, $CheckHP, $CheckMP
	Dim $LoopCheck, $HealthCheck, $PixelCheck1, $Heal, $Program, $PixelCheck2, $Power, $VarSleep, $VarPower, $VarHealth, $CheckProgram, $NotRunning, $GlobalLoop
	Dim $CheckPause, $Clicked, $Executed, $Paused, $Tray, $Minimized, $UpdateDir, $VarDir, $VerifyDir, $CheckProcess1, $CheckProcess2, $OpenFile, $Convert
	
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

$Form1 = GUICreate("Health Check v1.0", 234, 546, 374, 206, -1)

	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents") ;SpecialEvents, like X in the window
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "MinMizeToTray");Tray Minimize
	
$Group1 = GUICtrlCreateGroup("Update Rate", 8, 120, 217, 89)
GUICtrlCreateLabel("Enter how often to check for a difference in health/power. Default is 1500.", 16, 136, 195, 33)

;$Input1 = GUICtrlCreateInput("1500", 56, 176, 49, 21, -1, $WS_EX_CLIENTEDGE)
	$Input1 = GUICtrlCreateInput($UpdateRate, 56, 176, 49, 21, -1, $WS_EX_CLIENTEDGE)
	

$Button1 = GUICtrlCreateButton("Accept", 112, 176, 75, 25)

	GUICtrlSetOnEvent(-1, "UpdateAccept")	;This is an event, in case this button is pressed

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Quickbar", 8, 216, 217, 105)
GUICtrlCreateLabel("Enter quickbar location for health and power pots here.", 16, 232, 199, 33)
GUICtrlCreateLabel("Health Pot", 64, 264, 54, 17)
GUICtrlCreateLabel("Power Pot", 64, 288, 53, 17)
$Button2 = GUICtrlCreateButton("Accept", 128, 272, 75, 25)

	GUICtrlSetOnEvent(-1, "QuickbarAccept")	;This is another event, in case this button is pressed
	
$Combo1 = GUICtrlCreateCombo("", 16, 264, 41, 21)
	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarHP) ;This adds a list to choose from 0-9, default is saved.ini | Health
$Combo2 = GUICtrlCreateCombo("", 16, 288, 41, 21)
	GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|0", $QuickBarMP) ;This adds a list to choose from 0-9, default is saved.ini | Power
GUICtrlCreateGroup("", -99, -99, 1, 1)

;This is where Information group starts

$Group4 = GUICtrlCreateGroup("Information", 8, 8, 217, 105)
GUICtrlCreateLabel("Made by Snike.", 136, 88, 78, 17)
GUICtrlCreateLabel("Please start this program when Silkroad Online is running. Fill out the various settings below.", 16, 24, 202, 57)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;This is where Information group stops

;This is where Options group start

$Group3 = GUICtrlCreateGroup("Options", 8, 440, 217, 97)
$Button3 = GUICtrlCreateButton("Exit", 128, 504, 75, 25)

	GUICtrlSetOnEvent(-1, "ExitButton")	;Exit button event
	
$Button4 = GUICtrlCreateButton("Pause", 16, 504, 75, 25)

	GUICtrlSetOnEvent(-1, "PauseButton") ;Pause Button event
	
GUICtrlCreateLabel("You can quit the program by pressing SHIFT-ALT-D. You can also pause the program by pressing Pause/Break.", 16, 456, 203, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;This is where Options group stops

;This is where Game Location group starts

$Group5 = GUICtrlCreateGroup("Game Location", 8, 328, 217, 105)
$Button5 = GUICtrlCreateButton("Open", 16, 368, 75, 25)

	GUICtrlSetOnEvent(-1, "OpenFile")	;Open File Dialog with this button
	
GUICtrlCreateLabel("", 24, 352, 4, 4)
GUICtrlCreateLabel("Use open and locate your silkroad.exe", 16, 344, 201, 17)
$Button6 = GUICtrlCreateButton("Run", 136, 368, 75, 25)

	GUICtrlSetOnEvent(-1, "RunGame")	;This button starts the selected executable
	
;Adds a list-box
;$Input2 = GUICtrlCreateInput($UpdateDir, 16, 400, 193, 21, -1, $WS_EX_CLIENTEDGE)
$mylist=GUICtrlCreateList ($UpdateDir, 16,400,193,30,$LBS_NOSEL)
;GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling


GUICtrlCreateGroup("", -99, -99, 1, 1)



;This is where Game Location group stops

	$foo = TrayCreateItem("Restore Window")	;Used by minimize to tray
	TrayItemSetState(-1, $TRAY_DEFAULT)	;Used by minimize to tray
	TraySetClick ( 0 );don't show menu item when clicked


GUISetState(@SW_SHOW)

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
			ToolTip("Program is paused.",0,0)
			Sleep(500)
		WEnd
	EndFunc  

	Func PauseButton()
		$Paused = NOT $Paused
	EndFunc
	
	$LoopCheck = 0
	$HealthCheck = 0
	$PixelCheck1 = 0
	$PixelCheck2 = 0
	$Heal = 0
	$Program = 0
	$Power = 0
	$CheckProgram = 0
	$NotRunning = 0
	$GlobalLoop = 0
	$CheckPause = 0
	$VerifyDir = 0
	$CheckProcess1 = 0
	$CheckProcess2 = 0
	$OpenFile = 0
	$Convert = 0

	$VarSleep = 0
	$VarPower = 0
	$VarHealth = 0
	$VarDir = 0
	
	$VarSleep = IniRead(@ScriptDir & $FileName, "UPDATE", "Refresh", "Not Found")
	$VarPower = IniRead(@ScriptDir & $FileName, "POWER", "Quickbar", "Not Found")
	$VarHealth = IniRead(@ScriptDir & $FileName, "HEALTH", "Quickbar", "Not Found")
	$VarDir = IniRead(@ScriptDir & $FileName, "GAME", "Dir", "Not Found")

While 1
	
	
			If $Program == 0 Then
				If WinExists("SRO_Client") Then ;Checks if Silkroad is currently running
					$Program = 1
				Else
					ToolTip("Silkroad Online is not running (SHIFT-ALT-D to QUIT).",0,0)
					$Program = 0
					Sleep(1000)
				EndIf
			Else
			EndIf
	
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
		;Update()		;Pauses the script for a certain amount of time, check saved.ini for how long
		
		;Hopefully tries to Minimize to tray

	WEnd
	
	Func UpdateAccept()
		$Check = GUICtrlRead($Input1)		
		$Convert = Number($Check)		
		$Confirm = StringIsInt($Convert)
		
		If $Confirm == 0 Then
			MsgBox(16, "ERROR!", "You can only use numbers.")
		ElseIf $Confirm == 1 Then
			If $Convert == 0 Then
				MsgBox(16, "ERROR!", "Use only numbers, please.")
			Else
				$ConfirmedINT = $Convert
				IniWrite(@ScriptDir & $FileName, "UPDATE", "Refresh", $ConfirmedINT)
				MsgBox(64, "Success", $ConfirmedINT & " was saved.")
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
			MsgBox(16, "ERROR!", "You can't use same quickbar slot twice.")
		Else
			$Check = 0
		EndIf
		
		If $Check == 0 Then
			IniWrite(@ScriptDir & $FileName, "HEALTH", "Quickbar", $CheckHP)
			IniWrite(@ScriptDir & $FileName, "POWER", "Quickbar", $CheckMP)
			MsgBox(64, "Success", "Health Pot set to quickbar: " & $CheckHP & @CRLF & "Power Pot set to quickbar: " & $CheckMP)
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
	
	Func OpenFile()

		$message = "Locate your Silkroad.exe"
		$OpenFile = FileOpenDialog($message, @ScriptDir, "Executables (*.exe)", 1 + 2 )
		
		If @error Then
			MsgBox(16,"ERROR!","You must select silkroad.exe!")
		Else
			IniWrite(@ScriptDir & $FileName, "GAME", "Dir", $OpenFile)
			
			
			GUICtrlSetData($mylist, "")	; <---------------------------------------------------- Why does this cause a crash
			GUICtrlSetData($mylist, $OpenFile)	; <-------------------------------------------- Why does this cause a crash
			
			;The script works fine, despite the above GUICtrlSetData. HOWEVER, _IF_ the msgbox below is launched the script crash
			MsgBox(64, "Success", "Path has been saved: " & @CRLF & $OpenFile)
		EndIf
	EndFunc

	
	Func RunGame()
		If WinExists("SRO_client") == 1 Then
			MsgBox(16, "ERROR!", "Silkroad is already running.")
			$CheckProcess = 1
		Else
			$CheckProcess1 = 0
		EndIf
		If WinExists("Silkroad Online Launcher") == 1 Then
			MsgBox(16, "ERROR!", "Silkroad is already running.")
			$CheckProcess = 1
		Else
			$CheckProcess2 = 0
		EndIf
			
		If $CheckProcess1 == 0 Then
			If $CheckProcess2 == 0 Then
				
				$VerifyDir = IniRead(@ScriptDir & $FileName, "GAME", "Dir", "")
		
				If FileExists($VerifyDir) == 1 Then
					$RunGame = $VerifyDir
					Run($RunGame)
				Else
					MsgBox(16, "ERROR!", "Path to silkroad.exe is invalid!")
				EndIf
			Else
			EndIf
		Else
		EndIf
	EndFunc
			
			
			
		
	
