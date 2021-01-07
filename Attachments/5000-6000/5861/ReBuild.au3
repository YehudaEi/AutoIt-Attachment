;This only works with BETA verison of AutoIt
;
;
#include <GUIConstants.au3>

; == GUI generated with Koda ==

	Dim $UpdateRate, $File, $Check, $CheckComplete, $IniCheck, $FileName, $QuickBarHP, $QuickBarMP, $ConfirmedINT, $CheckHP, $CheckMP
	Dim $LoopCheck, $HealthCheck, $PixelCheck1, $Heal, $Program, $PixelCheck2, $Power, $VarSleep, $VarPower, $VarHealth, $CheckProgram, $NotRunning, $GlobalLoop
	Dim $CheckPause, $Clicked, $Executed, $Paused, $Tray, $Minimized
	
	Global $Paused	;To make sure the script can be paused
	
	;TraySetState(1) ;Make sure the tray doesnt show any options
	
	;Hopefully this can break the program, no matter if it already is in another loop
	;Opt("GUICoordMode",2)	;This part messed up the entire script
	Opt("GUIOnEventMode",1)
	
	HotKeySet("+!d", "Quit")  ;Shift-Alt-d
	HotKeySet("{PAUSE}", "PauseButton")
	
	AdlibEnable("adRoutine") ;Very important part to check so PauseButton works like it should
	
	$Paused = 0
	$Executed = 0
	$Clicked = 0
	$CheckPause = 0
	$Check = 0
	$CheckComplete = 0
	$FileName = "saved.ini"
	$Minimized = 0
	
	;Check if saved.ini exists, if not make one
	$File = FileOpen($FileName, 1)
	If FileExists($FileName) Then
		$Check = 1
	Else
		$Check = 0
	EndIf
	
	If $Check = 0 Then
		FileWrite($File, "[PROGRAM]" & @CRLF)
		FileWrite($File, "Installed=0")
		FileClose($File)
	Else
	EndIf
	
	
	;Check if saved.ini already been created
	
	While $CheckComplete = 0
	
		$IniCheck = IniRead($FileName,"PROGRAM","Installed","NotFound")
			If $IniCheck == 0 Then
				;First time saved.ini is being run, adding defaults.
				FileDelete($FileName)
				Sleep(100)
				IniWrite($FileName, "PROGRAM", "Installed", "1")
				IniWrite($FileName, "UPDATE", "Refresh", "1500")
				IniWrite($FileName, "HEALTH", "Quickbar", "9")
				IniWrite($FileName, "POWER", "Quickbar", "0")
				$CheckComplete = 1
				
			ElseIf $IniCheck == 1 Then
				;Saved.ini was found and has already been installed
				$CheckComplete = 1
			
			Else
				;Saved.ini was found, but has no valid information
				;Deleting Saved.ini and creating a new one.
				FileDelete($FileName)
				Sleep(100)
				IniWrite($FileName, "PROGRAM", "Installed", "1")
				IniWrite($FileName, "UPDATE", "Refresh", "1500")
				IniWrite($FileName, "HEALTH", "Quickbar", "9")
				IniWrite($FileName, "POWER", "Quickbar", "0")
				$CheckComplete = 1
			EndIf
		WEnd

;Read the Saved.ini for values.
$UpdateRate = IniRead($FileName, "UPDATE", "Refresh", "")
$QuickBarHP = IniRead($FileName, "HEALTH", "Quickbar", "")
$QuickBarMP = IniRead($FileName, "POWER", "Quickbar", "")
	
;Start of GUI interface creation

$Form1 = GUICreate("Health Check v0.1", 234, 434, 349, 313)

	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents") ;SpecialEvents, like X in the window
	;GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents") ;Tray Minimize
	
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
$Group3 = GUICtrlCreateGroup("Options", 8, 328, 217, 97)
$Button3 = GUICtrlCreateButton("Exit", 128, 392, 75, 25)

	GUICtrlSetOnEvent(-1, "ExitButton")	;Exit button event
	
$Button4 = GUICtrlCreateButton("Pause", 16, 392, 75, 25)

	GUICtrlSetOnEvent(-1, "PauseButton") ;Pause Button event

GUICtrlCreateLabel("You can quit the program by pressing SHIFT-ALT-D. You can also pause the program by pressing Pause/Break.", 16, 344, 195, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Information", 8, 8, 217, 105)
GUICtrlCreateLabel("Made by Snike.", 136, 88, 78, 17)
GUICtrlCreateLabel("Please start this program when Silkroad Online is running. Fill out the various settings below.", 16, 24, 202, 57)
GUICtrlCreateGroup("", -99, -99, 1, 1)
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
		$VarSleep = IniRead($FileName, "UPDATE", "Refresh", "Not Found")
		$VarPower = IniRead($FileName, "POWER", "Quickbar", "Not Found")
		$VarHealth = IniRead($FileName, "HEALTH", "Quickbar", "Not Found")
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

	$VarSleep = 0
	$VarPower = 0
	$VarHealth = 0
	
	$VarSleep = IniRead($FileName, "UPDATE", "Refresh", "Not Found")
	$VarPower = IniRead($FileName, "POWER", "Quickbar", "Not Found")
	$VarHealth = IniRead($FileName, "HEALTH", "Quickbar", "Not Found")

While 1
	
	
			If $Program == 0 Then
				If WinExists("SRO_Client") Then ;Checks if Silkroad is currently running
					$Program = 1
				Else
				;	ToolTip("Silkroad Online is not running (SHIFT-ALT-D to QUIT).",0,0)
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
				IniWrite($FileName, "UPDATE", "Refresh", $ConfirmedINT)
				MsgBox(64, "Success", $ConfirmedINT & " was saved.")
			EndIf
		Else
			MsgBox(16, "ERROR!", "                                         ")
		EndIf
	EndFunc
	
	Func QuickbarAccept()		
		$CheckHP = GUICtrlRead($Combo1) 
		$CheckMP = GUICtrlRead($Combo2)
		
		IniWrite($FileName, "HEALTH", "Quickbar", $CheckHP)
		IniWrite($FileName, "POWER", "Quickbar", $CheckMP)
		MsgBox(64, "Success", "Health Pot set to quickbar: " & $CheckHP & @CRLF & "Power Pot set to quickbar: " & $CheckMP)
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
