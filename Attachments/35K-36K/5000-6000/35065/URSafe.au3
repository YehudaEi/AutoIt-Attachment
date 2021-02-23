#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#CS

SOURCE CODE FOR URSafe INDEV 1.2.0.0.3

Todo List

1. Add Error Handling <- May not be needed
2. Improve Performance <- Check with guinness for optimizations
3. Add Options for almost everything <- Add at least 1 per release version
4. Enable changing of hotkeys <- Implement by 1.5.0.0
#CE

;Allow Only One Instance
If _Singleton("URSafe", 0) = 0 Then Exit

;What To Include When Compiling
#include <Constants.au3>
#include <Date.au3>
#include <GuiConstantsEx.au3>
#include <Inet.au3>
#include <Misc.au3>
#include <Process.au3>
#include <String.au3>

;Declare Variables

;Arrays
;Global $Blocking[2] = [0,0]
Global $Item_Block[3] = [0,0,0]

;Function Arrays
Global $WinXY

;Message Variables
Global $Msg, $TrayMsg

;Feedback System Variables
Global $FB_Pending, $Feedback, $Port

;GUI Menu Variables
Global $Menu_Block, $Menu_File, $Menu_Help, $Menu_Online, $Menu_Options, $Menu_Refresh
Global $Menu_Startup

;GUI Menu Item Variables
;Global $Item_Block_All, $Item_Block_Shutdown, $Item_Block_Taskmgr
Global $Item_Credits, $Item_Exit
Global $Item_Feedback, $Item_Hide, $Item_Math_Unlock, $Item_Reset_Five, $Item_Reset_Ten
Global $Item_Reset_Twenty, $Item_Start_Locked, $Item_Start_Update, $Item_Update

;Other GUI Control Variables
Global $Clock, $CreditsGUI, $CreditsOK, $GUI, $Input, $Instructions, $Toggle

;Math Unlock Variables
Global $MathUnlock, $RanA, $RanB

;Settings Variables
Global $Is_Blocked, $To_Block
Global $Block_All, $Block_Shutdown, $Block_Taskmgr
Global $Start_Update, $Start_Locked, $Pass_Saved, $Password

;Misc Variables
Global $Locked, $Refresh, $RefreshTimer, $Time, $Update_File, $Version_File

;Declare Constant Array
Const $Version[2] = ["1.2.0.0", "1.2.0.0.3"]

;Declare Constants
Const $InDev = True
Const $Log = @ScriptDir & "\URSafe.log"
Const $Settings = @ScriptDir & "\settings.ini"
Const $User32 = DllOpen("user32.dll")

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
$Block_All = False
$Block_Shutdown = False
$Block_Taskmgr = False
$FB_Pending = False
$MathUnlock = False
$Start_Locked = False
$Start_Update = False
$Refresh = 10000

;Set Password Status
$Pass_Saved = False

;Set URSafe Status
$Locked = False

;Log URSafe Execution
FileWriteLine($Log, _Now() & " : " & "URSafe Opened")

;Call The GUI
GUI()

;Display GUI
Func GUI()
;	Create GUI And Ctrls
	$GUI = GUICreate("URSafe - Version " & $Version[0], @DesktopWidth, @DesktopHeight, 0, 0, 0x10000288)
		$Menu_File = GUICtrlCreateMenu("File")
			$Item_Hide = GUICtrlCreateMenuItem("Minimize", $Menu_File, 1)
				GUICtrlCreateMenuItem("", $Menu_File, 2)
			$Item_Exit = GUICtrlCreateMenuItem("Exit", $Menu_File, 3)
		$Menu_Options = GUICtrlCreateMenu("Options")
			$Menu_Block = GUICtrlCreateMenu("Don't Allow", $Menu_Options, 1)
				$Item_Block[0] = GUICtrlCreateMenuItem("Any", $Menu_Block, 1)
					GUICtrlCreateMenuItem("", $Menu_Block, 2)
				$Item_Block[1] = GUICtrlCreateMenuItem("Shutdown", $Menu_Block, 3)
				$Item_Block[2] = GUICtrlCreateMenuItem("Taskmgr", $Menu_Block, 4)
			$Menu_Startup = GUICtrlCreateMenu("On Startup", $Menu_Options, 2)
				$Item_Start_Locked = GUICtrlCreateMenuItem("Lock URSafe", $Menu_Startup, 1)
				$Item_Start_Update = GUICtrlCreateMenuItem("Update URSafe", $Menu_Startup, 2)
			$Menu_Refresh = GUICtrlCreateMenu("Refresh Every", $Menu_Options, 3)
				$Item_Reset_Five = GUICtrlCreateMenuItem("5 seconds", $Menu_Refresh, 1, 1)
				$Item_Reset_Ten = GUICtrlCreateMenuItem("10 seconds", $Menu_Refresh, 2, 1)
				$Item_Reset_Twenty = GUICtrlCreateMenuItem("20 seconds", $Menu_Refresh, 3, 1)
		$Menu_Help = GUICtrlCreateMenu("Help")
			$Item_Credits = GUICtrlCreateMenuItem("Credits", $Menu_Help, 1)
				GUICtrlCreateMenuItem("", $Menu_Help, 2)
			$Item_Math_Unlock = GUICtrlCreateMenuItem("Math Unlock", $Menu_Help, 3)
				GUICtrlCreateMenuItem("", $Menu_Help, 4)
			$Menu_Online = GUICtrlCreateMenu("Online", $Menu_Help, 	5)
;				$Item_Changelog = GUICtrlCreateMenuItem("Changelog", $Menu_Online, 1)
				$Item_Feedback = GUICtrlCreateMenuItem("Feedback", $Menu_Online, 2)
;				$Item_Manual = GUICtrlCreateMenuItem("Manual", $Menu_Online, 3)
				$Item_Update = GUICtrlCreateMenuItem("Update", $Menu_Online, 4)

		GUICtrlCreatePic("./pic.jpg", 0, 0, @DesktopWidth, @DesktopHeight, 0x1000)
		$Clock = GUICtrlCreateLabel(_NowTime(), @DesktopWidth-(@DesktopWidth/8), 0, (@DesktopWidth/8), 20, 0x1001)
		$Feedback = GUICtrlCreateInput("", 280, 30, 50, 20, 0x44)
		$Instructions = GUICtrlCreateLabel("Enter Password to Lock", 50, 30, 230, 20, 0x1001)
		$Input = GUICtrlCreateInput("", 50, 50, 230, 20, 0x00A0)
		$Toggle = GUICtrlCreateButton("Lock", 280, 50, 50, 20)
		GUICtrlSetState($Feedback, $GUI_DISABLE)

;	Call Startup
	Startup()

;	Loop
	While 1
;		Get GUI Messages
		GUICtrlSetData($Clock, _NowTime())
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

;			Call Feedback Function
			Case $Msg = $Item_Feedback
				Feedback()

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

;			Can't get to work right
;			Case $Msg = $Item_Block[0]
;				$Blocking[0] = 3
;				Settings()

;			Case $Msg = $Item_Block[1]
;				$Blocking[0] = 2
;				Settings()

;			Case $Msg = $Item_Block[2]
;				$Blocking[0] = 1
;				Settings()

;			Comment out below code when Settings is fixed()

			Case $Msg = $Item_Block[0]
				$Block_All = True
				ContinueCase

			Case $Msg = $Item_Block[1]
				FileSetAttrib($Settings, "-RSH")
				If Not $Block_Shutdown Then 
					GUICtrlSetState($Item_Block[1], $GUI_CHECKED)
					INIWrite($Settings, "Blocking", "Shutdown", "True")
					$Block_Shutdown = True
				ElseIf Not $Block_All Then
					GUICtrlSetState($Item_Block[1], $GUI_UNCHECKED)
					INIWrite($Settings, "Blocking", "Shutdown", "False")
					$Block_Shutdown = False
				EndIf
				FileSetAttrib($Settings, "+RSH")
				If $Block_All Then ContinueCase

			Case $Msg  = $Item_Block[2]
				FileSetAttrib($Settings, "-RSH")
				If Not $Block_Taskmgr Then 
					GUICtrlSetState($Item_Block[2], $GUI_CHECKED)
					INIWrite($Settings, "Blocking", "Taskmgr", "True")
					$Block_Taskmgr = True
				ElseIf Not $Block_All Then
					GUICtrlSetState($Item_Block[2], $GUI_UNCHECKED)
					INIWrite($Settings, "Blocking", "Taskmgr", "False")
					$Block_Taskmgr = False
				EndIf
				FileSetAttrib($Settings, "+RSH")
				If $Block_All Then $Block_All = False

;			Comment out above code when Settings is fixed()

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
	$CreditsGUI = GUICreate("Credits", 220, 220, -1, -1, 0x10000288)
		GUICtrlCreateLabel("Autoit Superviser:", 10, 10, 90, 20)
		GUICtrlCreateLabel("Guinness", 120, 10, 90, 20)
		GUICtrlCreateLabel("Original Idea:", 10, 30, 90, 20)
		GUICtrlCreateLabel("Computerfreaker", 120, 30, 90, 20)
		GUICtrlCreateLabel("Original Program:", 10, 50, 90, 20)
		GUICtrlCreateLabel("KidSafe", 120, 50, 90, 20)
		GUICtrlCreateLabel("URSafe Coding:", 10, 70, 90, 20)
		GUICtrlCreateLabel("Robert C. Maehl", 120, 70, 90, 20)
		GUICtrlCreateLabel("URSafe Testing:", 10, 90, 90, 20)
		GUICtrlCreateLabel("TheCyberShocker", 120, 90, 90, 20)
		GUICtrlCreateLabel("Web Hosting:", 10, 110, 90, 20)
		GUICtrlCreateLabel("E10Host", 120, 110, 90, 20)
		GUICtrlCreateLabel("Google Code", 120, 130, 90, 20)
		$CreditsOK = GUICtrlCreateButton("OK", 180, 170, 30, 20)
EndFunc


; Execute Feedback
Func Feedback()
	If Not $FB_Pending Then
		TCPStartup()
		$Port = TCPConnect("74.141.211.110", 5309)
		If @error Then
			MsgBox(4112, "Error", "Failed at capturing port.")
		Else
			TCPSend($Port, _GetIP() & "$" & "Checking Connection" & "$")
			If @error Then
				MsgBox(4112, "Error", "Feedback Server Offline." & @CRLF & "Please try again later.")
			Else
				$FB_Pending = True
				GUICtrlSetData($Instructions, "Enter Your Feedback Below")
				GUICtrlSetData($Toggle, "Submit")
				GUICtrlSetPos($Feedback, 50, 50, 230, 100)
				GUICtrlSetPos($Input, 280, 30, 50, 20)
				GUICtrlSetState($Feedback, $GUI_ENABLE+$GUI_FOCUS)
				If Not $Pass_Saved Then GUICtrlSetState($Input, $GUI_DISABLE)
			EndIf
		EndIf
	Else
		If StringIsASCII(GUICtrlRead($Feedback)) And _
		Not StringLen(GUICtrlRead($Feedback)) < 4 And _
		Not StringInStr(GUICtrlRead($Feedback), "fuck", 0) And _
		Not StringInStr(GUICtrlRead($Feedback), "shit", 0) And _
		Not StringInStr(GUICtrlRead($Feedback), "crap", 0) Then
			TCPSend($Port, _GetIP() &  "$" & StringReplace(GUICtrlRead($Feedback), "$", "(Money sign)") & "$")
			If @error Then
				MsgBox(4112, "Error", "Failed at sending data." & @CRLF & "Please try again later.")
			Else
				MsgBox(0x0, "Thanks", "Thank you for your feedback!")
			EndIf
			$FB_Pending = False
			GUICtrlSetData($Instructions, "Enter Password to Lock")
			GUICtrlSetData($Feedback, "")
			GUICtrlSetData($Toggle, "Lock")
			GUICtrlSetPos($Input, 50, 50, 230, 20)
			GUICtrlSetPos($Feedback, 280, 30, 50, 20)
			GUICtrlSetState($Feedback, $GUI_DISABLE)
			If Not $Pass_Saved Then GUICtrlSetState($Input, $GUI_ENABLE+$GUI_FOCUS)
			TCPShutdown()
		Else
			MsgBox(4112, "Error", "Please revise your feedback.") 
		EndIf
	EndIf
EndFunc


; Execute Math Unlock
Func MathUnlock()
	If $MathUnlock = False Then
		$MathUnlock = True
		Global $Ran[2] = [Random(20, 50, 1), Random(1000, 8000, 1)]
		GUICtrlSetData($Instructions, "What is " & $Ran[0] & " cubed minus " & $Ran[1] & "?")
	Else
		GUICtrlSetData($Instructions, "Enter Password to Unlock")
		$MathUnlock = False
	EndIf
EndFunc


; Execute Protections
Func Protection()
	If TimerDIff($RefreshTimer) >= $Refresh Or _IsPressed("5B", $User32) Or _IsPressed("5C", $User32) Then
		$RefreshTimer = TimerInit()
		_MouseTrap()
		Sleep(100)
		_MouseTrap(0, 0, @DesktopWidth, 180)
	EndIf
	$WinXY = WinGetPos($GUI)
	If $WinXY[0] <> 0 Or $WinXY[1] <> 0 Or Not BitAND(WinGetState($GUI), 8) Then
		WinMove($GUI, "", 0, 0)
		WinSetOnTop($GUI, "", 1)
		WinActivate($GUI)
	EndIf
	If ProcessExists("shutdown.exe") And $Block_Shutdown Then _RunDOS("shutdown /a")
	If ProcessExists("taskmgr.exe") And $Block_Taskmgr Then ProcessClose("taskmgr.exe")
EndFunc


;Change Settings
;Func Settings() ; <== It doesn't work!
;	ConsoleWrite($Blocking[0])
;	FileSetAttrib($Settings, "-RSH")
;	If $Blocking[0] = 3 Or $Blocking[0] = 2 Then
;		If Not $Blocking[1] = 3 Or $Blocking[1] = 2 Then
;			GUICtrlSetState($Item_Block[1], $GUI_CHECKED)
;			INIWrite($Settings, "Blocking", "Shutdown", "True")
;			$Blocking[1] += 2
;		Else
;			GUICtrlSetState($Item_Block[1], $GUI_UNCHECKED)
;			INIWrite($Settings, "Blocking", "Shutdown", "False")
;			$Blocking[1] -= 2
;		EndIf
;	EndIf
;	If $Blocking[0] = 3 Or $Blocking[0] = 1 Then
;		If Not $Blocking[1] = 3 or $Blocking[1] = 1 Then
;			GUICtrlSetState($Item_Block[2], $GUI_CHECKED)
;			INIWrite($Settings, "Blocking", "Taskmgr", "True")
;			$Blocking[1] += 1
;		Else
;			GUICtrlSetState($Item_Block[2], $GUI_UNCHECKED)
;			INIWrite($Settings, "Blocking", "Taskmgr", "False")
;			$Blocking[1] -= 1
;		EndIf
;	EndIf
;	FileSetAttrib($Settings, "+RSH")
;	$Blocking[0] = 0
;EndFunc


; Execute Startup
Func Startup()
	If Not FileExists($Settings) Then
		INIWrite($Settings, "#URSafe Settings#", "", "")
		INIWrite($Settings, "Main", "Lock on Start", "False")
		INIWrite($Settings, "Main", "Update on Start", "False")
		INIWrite($Settings, "Blocking", "Shutdown", "False")
		INIWrite($Settings, "Blocking", "Taskmgr", "False")
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
		GUICtrlSetState($Item_Block[1], $GUI_CHECKED)
		$Block_Shutdown = True
;		$Blocking[1] += 1
	EndIf
	If INIRead($Settings, "Blocking", "Taskmgr", "False") = "True" Then
		GUICtrlSetState($Item_Block[2], $GUI_CHECKED)
		$Block_Taskmgr = True
;		$Blocking[1] += 2
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
	If $FB_Pending Then
		Feedback()
	ElseIf $Locked = True Then
		If GUICtrlRead($Input) = "" Then
			FileWriteLine($Log, _Now() & " : " & "No Unlock Password Specified, Not unlocking.")
		ElseIf $MathUnlock = True Then
			If GUICtrlRead($Input) = Execute($Ran[0]^3-$Ran[1]) Then
				FileWriteLine($Log, _Now() & " : " & "Math Unlock Succeeded, Answer: " & Execute($Ran[0]^3-$Ran[1]))
				$MathUnlock = False
				GUICtrlSetData($Input, $Password)
				Status()
			Else
				FileWriteLine($Log, _Now() & " : " & "Math Unlock Failed." & _
				"Input: " & GUICtrlRead($Input) & " Answer: " & Execute($Ran[0]^3-$Ran[1]))
				GUICtrlSetData($Input, "")
			EndIf
		ElseIf GUICtrlRead($Input) == $Password Or GUICtrlRead($Input) == $Password & "-reset" Then
			FileWriteLine($Log, _Now() & " : " & "URSafe Unlocked")
			_MouseTrap()
			$Locked = False
			GUISetState(0x10000288)
			If GUICtrlRead($Input) == $Password & "-reset" Then
				FileWriteLine($Log, _Now() & " : " & "URSafe Saved Pass Reset To None")
				FileSetAttrib($Settings, "-RSH")
				INIWrite($Settings, "Encrypted", "Password", "4E554C")
				FileSetAttrib($Settings, "+RSH")
				$Pass_Saved = False
			EndIf
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
			GUICtrlSetState($Item_Feedback, $GUI_ENABLE)
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
		GUICtrlSetState($Item_Feedback, $GUI_DISABLE)
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
		If FileReadLine(@ScriptDir & "\update.txt", 2) > StringReplace($Version[1], ".", "") Then
			ProgressSet(66, "Downloading Update to InDev Version " & FileReadLine(@ScriptDir & "\update.txt", 2), "Downloading")
			ShellExecute("http://code.google.com/p/kidsafe/source/browse/")
		Else
			ProgressSet(66, "No Developer Build Available.", "Up to date")
			Sleep(500)
		EndIf
	Else
		If FileReadLine(@ScriptDir & "\update.txt", 1) > StringReplace($Version[0], ".", "") Then
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