#CS

SOURCE CODE FOR URSafe 1.1.0.0

Todo List

1. Add Error Handling <- May not be needed
2. Improve Performance <- Check with guinness for optimizations
3. Add Options for almost everything <- Add at least 1 per release version
4. Enable changing of hotkeys <- Implement by 1.5.0.0
5. Enable Password Change after saving it.
#CE

;Allow Only One Instance
If _Singleton("URSafe", 1) = 0 Then Exit

;What To Include When Compiling
#include <Constants.au3>
#include <Date.au3>
#include <GuiConstantsEx.au3>
#include <Misc.au3>
#include <Process.au3>
#include <String.au3>

;Declare Variables
;Message Variables
Local $Msg, $TrayMsg

;GUI Menu Variables
Local $Menu_Block, $Menu_File, $Menu_Help, $Menu_Options, $Menu_Refresh, $Menu_Startup

;GUI Menu Item Variables
Local $Item_Block_All, $Item_Block_Shutdown, $Item_Credits, $Item_Exit, $Item_Hide, $Item_Manual
Local $Item_Math_Unlock, $Item_Reset_Five, $Item_Reset_Ten, $Item_Reset_Twenty, $Item_Start_Locked
Local $Item_Start_Update, $Item_Update

;Other GUI Control Variables
Local $CreditsGUI, $CreditsOK, $GUI, $Input, $Instructions, $Toggle

;Math Unlock Variables
Local $MathUnlock, $RanA, $RanB

;Settings Variables
Local $Block_All, $Block_LogonUI, $Block_Shutdown
Local $Start_Update, $Start_Locked, $Pass_Saved, $Password

;Misc Variables
Local $WinXY, $Locked, $Version_File, $Update_File, $RefreshTimer, $Refresh

;Declare Constants
Const $DevBuild = "1.2.0.0.1"
Const $InDev = True
Const $Log = @ScriptDir & "\URSafe.log"
Const $Settings = @ScriptDir & "\settings.ini"
Const $User32 = DllOpen("user32.dll")
Const $Version = "1.2.0.0"

;Action on Tray Icon Click
TraySetClick(0)

;Set Tray Icon
TraySetIcon("Shell32.dll", -48)

;Don't Close On ESC
Opt('GUICloseOnESC', 0)

;Ensure All Variables Are Included
Opt('MustDeclareVars', 1)

;Don't Pause Script When In Tray
Opt('TrayAutoPause', 0)

;Set Settings Variables
;Set What To Block
$Block_All = False
$Block_Shutdown = False
$MathUnlock = False
$Start_Locked = False
$Start_Update = False
$Refresh = 10000

;Set Password Status
$Pass_Saved = False

;Set URSafe Status
$Locked = False

;Call The GUI
GUI()

;Display GUI
Func GUI()
;	Create GUI And Ctrls
	FileWriteLine($Log, _Now() & " : " & "URSafe Opened")
	$GUI = GUICreate("URSafe - Version " & $Version, @DesktopWidth, @DesktopHeight, 0, 0, 0x10000288)
		$Menu_File = GUICtrlCreateMenu("File")
			$Item_Hide = GUICtrlCreateMenuItem("Hide", $Menu_File, 1)
			GUICtrlCreateMenuItem("", $Menu_File, 2)
			$Item_Exit = GUICtrlCreateMenuItem("Exit", $Menu_File, 3)
		$Menu_Options = GUICtrlCreateMenu("Options")
			$Menu_Block = GUICtrlCreateMenu("Don't Allow ...", $Menu_Options, 1)
				$Item_Block_All = GUICtrlCreateMenuItem("All", $Menu_Block, 1)
				GUICtrlCreateMenuItem("", $Menu_Block, 2)
				$Item_Block_Shutdown = GUICtrlCreateMenuItem("Shutdown", $Menu_Block, 3)
			$Menu_Startup = GUICtrlCreateMenu("On Startup ...", $Menu_Options, 2)
				$Item_Start_Locked = GUICtrlCreateMenuItem("Lock URSafe", $Menu_Startup, 1)
				$Item_Start_Update = GUICtrlCreateMenuItem("Update URSafe", $Menu_Startup, 2)
			$Menu_Refresh = GUICtrlCreateMenu("Refresh at ...", $Menu_Options, 3)
				$Item_Reset_Five = GUICtrlCreateMenuItem("5 seconds", $Menu_Refresh, 1, 1)
				$Item_Reset_Ten = GUICtrlCreateMenuItem("10 seconds", $Menu_Refresh, 2, 1)
				$Item_Reset_Twenty = GUICtrlCreateMenuItem("20 seconds", $Menu_Refresh, 3, 1)
		$Menu_Help = GUICtrlCreateMenu("Help")
			$Item_Credits = GUICtrlCreateMenuItem("Credits", $Menu_Help, 1)
;			$Item_Manual = GUICtrlCreateMenuItem("Manual", $Menu_Help, 2)
			GUICtrlCreateMenuItem("", $Menu_Help, 3)
			$Item_Math_Unlock = GUICtrlCreateMenuItem("Math Unlock", $Menu_Help, 5)
			GUICtrlCreateMenuItem("", $Menu_Help, 5)
			$Item_Update = GUICtrlCreateMenuItem("Update", $Menu_Help, 6)
		GUICtrlCreatePic("./pic.jpg", 0, 0, @DesktopWidth, @DesktopHeight, 0x1000)
		$Instructions = GUICtrlCreateLabel("Enter Password to Lock", 50, 30, 230, 20, 0x1001)
		$Input = GUICtrlCreateInput("", 50, 50, 180, 20, 0x00A0)
		$Toggle = GUICtrlCreateButton("Lock", 230, 50, 50, 20)

;	Call Startup
	Startup()

;	Loop
	While 1
;		Get GUI Messages
		$Msg = GUIGetMsg()

;		Get Tray Messages
		$TrayMsg = TrayGetMsg()

;		Run Action decided by Message
		Select

;			Close URSafe
			Case $Msg = $Item_Exit
				FileWriteLine($Log, _Now() & " : " & "URSafe Closed")
				DllClose($User32)
				ExitLoop

			Case $Msg = $Toggle Or _IsPressed("91", $User32)
				Status()

			Case $Msg = $Item_Math_Unlock
				MathUnlock()

;			IMPORTANT! DO NOT CHANGE!
;			Activate Protection When Locked
			Case $Locked
				Protection()

;			MouseTrap Refresh Control
			Case $Msg = $Item_Reset_Five
				$Refresh = 5000

			Case $Msg = $Item_Reset_Ten
				$Refresh = 10000

			Case $Msg = $Item_Reset_Twenty
				$Refresh = 20000

;			Update Startup Update Status
			Case $Msg = $Item_Start_Update
				FileSetAttrib($Settings, "-RSH")
				If Not $Start_Update Then
					GUICtrlSetState($Item_Start_Update, $GUI_CHECKED)
					INIWrite($Settings, "Main", "Update on Start", "True")
					$Start_Update = True
				Else
					GUICtrlSetState($Item_Start_Update, $GUI_UNCHECKED)
					INIWrite($Settings, "Main", "Update on Start", "False")
					$Start_Update = False
				EndIf
				FileSetAttrib($Settings, "+RSH")

;			Update Startup Locked Status
			Case $Msg = $Item_Start_Locked
				FileSetAttrib($Settings, "-RSH")
				If Not $Start_Locked Then
					GUICtrlSetState($Item_Start_Locked, $GUI_CHECKED)
					INIWrite($Settings, "Main", "Lock on Start", "True")
					$Start_Locked = True
				Else
					GUICtrlSetState($Item_Start_Locked, $GUI_UNCHECKED)
					INIWrite($Settings, "Main", "Lock on Start", "False")
					$Start_Locked = False
				EndIf
				FileSetAttrib($Settings, "+RSH")

;			Update All Blocking Statuses
			Case $Msg = $Item_Block_All
				$Block_All = True
				ContinueCase

;			Update Shutdown Blocking Status
			Case $Msg = $Item_Block_Shutdown
				If Not $Block_Shutdown Then
					GUICtrlSetState($Item_Block_Shutdown, $GUI_CHECKED)
					FileSetAttrib($Settings, "-RSH")
					INIWrite($Settings, "Blocking", "Shutdown", "True")
					FileSetAttrib($Settings, "+RSH")
					$Block_Shutdown = True
				ElseIf $Block_All Then
					$Block_All = False
				Else
					GUICtrlSetState($Item_Block_Shutdown, $GUI_UNCHECKED)
					FileSetAttrib($Settings, "-RSH")
					INIWrite($Settings, "Blocking", "Shutdown", "False")
					FileSetAttrib($Settings, "+RSH")
					$Block_Shutdown = False
				EndIf

;			Update URSafe
			Case $Msg = $Item_Update
				Update()

;			Restore URSafe From Tray
			Case $TrayMsg = $Tray_Event_PrimaryDouble
				WinSetState($GUI, "", @SW_SHOW)
				WinMove($GUI, "", 0, 0)

;			Hide URSafe to Tray
			Case $Msg = $Item_Hide
				WinSetState($GUI, "", @SW_HIDE)

;			Display Credits
			Case $Msg = $Item_Credits
				Credits()

			Case $Msg = $CreditsOK And WinExists("Credits", "")
				GUIDelete($CreditsGUI)

;			Anything Not Listed Above
			Case Else
				;;;

		EndSelect
	WEnd
	Exit(0)
EndFunc


; Display Credits
Func Credits()
	$CreditsGUI = GUICreate("Credits", 220, 200, -1, -1, 0x10C00000)
	GUICtrlCreateLabel("Autoit Help:", 10, 10, 90, 20)
	GUICtrlCreateLabel("Guinness", 120, 10, 90, 20)
	GUICtrlCreateLabel("Original Idea:", 10, 30, 90, 20)
	GUICtrlCreateLabel("Computerfreaker", 120, 30, 90, 20)
	GUICtrlCreateLabel("URSafe Coding:", 10, 50, 90, 20)
	GUICtrlCreateLabel("Robert C. Maehl", 120, 50, 90, 20)
	GUICtrlCreateLabel("URSafe Testing:", 10, 70, 90, 20)
	GUICtrlCreateLabel("TheCyberShocker", 120, 70, 90, 20)
	GUICtrlCreateLabel("Web Hosting:", 10, 90, 90, 20)
	GUICtrlCreateLabel("E10Host", 120, 90, 90, 20)
	GUICtrlCreateLabel("Google Code", 120, 110, 90, 20)
	$CreditsOK = GUICtrlCreateButton("Ok", 180, 170, 30, 20)
EndFunc


; Execute Math Unlock
Func MathUnlock()
	If $MathUnlock = False Then
		$MathUnlock = True
		$RanA = Random(20, 50, 1)
		$RanB = Random(1000, 8000, 1)
		GUICtrlSetData($Instructions, "What is " & $RanA & " cubed minus " & $RanB	& "?")
	Else
		GUICtrlSetData($Instructions, "Enter Password to Unlock")
		$MathUnlock = False
	EndIf
EndFunc


; Execute Protections
Func Protection()
	If TimerDIff($RefreshTimer) >= $Refresh Then
		$RefreshTimer = TimerInit()
		_MouseTrap()
		_MouseTrap(0, 0, @DesktopWidth, 180)
	EndIf
	$WinXY = WinGetPos($GUI)
	If $WinXY[0] <> 0 Or $WinXY[1] <> 0 Or Not BitAND(WinGetState($GUI), 8) Then
		WinMove($GUI, "", 0, 0)
		WinSetOnTop($GUI, "", 1)
		WinActivate($GUI)
	EndIf
	If _IsPressed("5B", $User32) Or _IsPressed("5C", $User32) Then
		_MouseTrap()
		Sleep(100)
		_MouseTrap(0, 0, @DesktopWidth, 180)
	EndIf
	If ProcessExists("shutdown.exe") and $Block_Shutdown Then _RunDOS("shutdown /a")
EndFunc


; Execute Startup
Func Startup()
	If Not FileExists($Settings) Then
		INIWrite($Settings, "#URSafe Settings#", "", "")
		IniWrite($Settings, "Main", "Lock on Start", "False")
		INIWrite($Settings, "Main", "Update on Start", "False")
		INIWrite($Settings, "Blocking", "Shutdown", "False")
		INIWrite($Settings, "Encrypted", "Password", "4E554C")
		FileSetAttrib($Settings, "+R")
	Else
		FileSetAttrib($Settings, "-SH")
	EndIf
	If INIRead($Settings, "Main", "Lock on Start", "False") = "True" Then 
		GUICtrlSetState($Item_Start_Locked, $GUI_CHECKED)
		$Start_Locked = True
	EndIf
	If INIRead($Settings, "Main", "Update on Start", "False") = "True" Then 
		GUICtrlSetState($Item_Start_Update, $GUI_CHECKED)
		$Start_Update = True
		Update()
	EndIf
	If INIRead($Settings, "Blocking", "Shutdown", "False") = "True" Then
		GUICtrlSetState($Item_Block_Shutdown, $GUI_CHECKED)
		$Block_Shutdown = True
	EndIf
	GUICtrlSetData($Input, _HexToString(INIRead($Settings, "Encrypted", "Password", "4E554C")))
	If GUICtrlRead($Input) = "NUL" Then
		GUICtrlSetData($Input, "")
	Else
		$Pass_Saved = True
		GUICtrlSetState($Input, $GUI_DISABLE)
		If INIRead($Settings, "Main", "Lock on Start", "False") = "True" Then Status()
	EndIf
	FileSetAttrib($Settings, "+SH")
	GUICtrlSetState($Item_Reset_Ten, $GUI_CHECKED)
	GUICtrlSetState($Item_Math_Unlock, $GUI_DISABLE)
EndFunc


; Change URSafe Status
Func Status()
	WinSetState($GUI, "", @SW_SHOW)
	If $Locked = True Then
		If GUICtrlRead($Input) = "" Then
			FileWriteLine($Log, _Now() & " : " & "No Unlock Password Specified, Not unlocking.")
		ElseIf $MathUnlock = True Then
			If GUICtrlRead($Input) = $RanA^3-$RanB Then
				FileWriteLine($Log, _Now() & " : " & "Math Unlock Succeeded, Answer: " & $RanA^3-$RanB)
				$MathUnlock = False
				GUICtrlSetData($Input, $Password)
				Status()
			Else
				FileWriteLine($Log, _Now() & " : " & "Math Unlock Failed. Input: " & GUICtrlRead($Input) & " Answer: " & $RanA^3-$RanB)
				GUICtrlSetData($Input, "")
			EndIf
		ElseIf GUICtrlRead($Input) = $Password Then
			FileWriteLine($Log, _Now() & " : " & "URSafe Unlocked")
			_MouseTrap()
			$Locked = False
			GUICtrlSetData($Input, "")
			If $Pass_Saved Then
				GUICtrlSetState($Input, $GUI_DISABLE)
				GUICtrlSetData($Input, $Password)
			EndIf
			GUICtrlSetData($Instructions, "Enter Password to Lock")
			GUICtrlSetData($Toggle, "Lock")
			GUICtrlSetState($Menu_File, $GUI_ENABLE)
			GUICtrlSetState($Menu_Options, $GUI_ENABLE)
			GUICtrlSetState($Item_Update, $GUI_ENABLE)
			GUICtrlSetState($Item_Credits, $GUI_ENABLE)
			GUICtrlSetState($Item_Math_Unlock, $GUI_DISABLE)
		Else
			GUICtrlSetData($Input, "")
			FileWriteLine($Log, _Now() & " : " & "Incorrect Password")
		EndIf
	ElseIf GUICtrlRead($Input) = "" Then
		FileWriteLine($Log, _Now() & " : " & "No Lock Password Specified, Not Locking.")
	Else
		FileWriteLine($Log, _Now() & " : " & "URSafe Locked")
		$RefreshTimer = TimerInit()
		If _HexToString(INIRead($Settings, "Encrypted", "Password", "4E554C")) = "NUL" Then
			If MsgBox(0x40024, "Set as Default?", "Use this password from now on?") = "6" Then
				FileSetAttrib($Settings, "-RSH")
				INIWrite($Settings, "Encrypted", "Password", _StringToHex(GUICtrlRead($Input)))
				FileSetAttrib($Settings, "+RSH")
				$Pass_Saved = True
			EndIf
		EndIf
		_MouseTrap(0, 0, @DesktopWidth, 180)
		GUICtrlSetData($Instructions, "Enter Password to Unlock")
		GUICtrlSetData($Toggle, "Unlock")
		GUICtrlSetState($Menu_File, $GUI_DISABLE)
		GUICtrlSetState($Menu_Options, $GUI_DISABLE)
		GUICtrlSetState($Item_Update, $GUI_DISABLE)
		GUICtrlSetState($Item_Credits, $GUI_DISABLE)
		GUICtrlSetState($Item_Math_Unlock, $GUI_ENABLE)
		$Password = GUICtrlRead($Input)
		GUICtrlSetData($Input, "")
		If $Pass_Saved Then GUICtrlSetState($Input, $GUI_ENABLE)
		$Locked = True
	EndIf
EndFunc


; Execute Updater
Func Update()
	FileWriteLine($Log, _Now() & " : " & "URSafe Updater Executed")
	ProgressOn("URSafe Updater", "Please Wait", "Getting Latest Version Number.")
	$Version_File = InetGet("http://www.fcofix.org/mirror/ursupdate.txt", @ScriptDir & "\update.txt", 1, 0)
	InetClose($Version_File)
	ProgressSet(33, "Comparing Latest Version to Local Version", "Checking")
	If $InDev Then
		If FileReadLine(@ScriptDir & "\update.txt", 2) > StringReplace($DevBuild, ".", "") Then
			ProgressSet(66, "Downloading Update to InDev Version " & FileReadLine(@ScriptDir & "\update.txt", 2), "Downloading")
			ShellExecute("http://code.google.com/p/kidsafe/source/browse/")
		Else
			ProgressSet(66, "No Developer Build Available.", "Up to date")
			Sleep(500)
		EndIf
	Else
		If FileReadLine(@ScriptDir & "\update.txt", 1) > StringReplace($Version, ".", "") Then
			ProgressSet(66, "Downloading Update to Version " & FileReadLine(@ScriptDir & "\update.txt", 1), "Downloading")
			$Update_File = InetGet("http://www.fcofix.org/mirror/ursafe.exe", @ScriptDir & "\URSafe_Setup.exe", 1, 0)
			InetClose($Update_File)
		Else
			ProgressSet(66, "No Update Needed.", "Up to date")
			Sleep(500)
		EndIf
	EndIf
	ProgressSet(83, "Cleaning Up", "Done")
	FileDelete(@ScriptDir & "\update.txt")
	ProgressSet(100, "Done", "Closing")
	Sleep(1000)
	ProgressOff()
	FileWriteLine($Log, _Now() & " : " & "URSafe Updater Finished Executing")
EndFunc