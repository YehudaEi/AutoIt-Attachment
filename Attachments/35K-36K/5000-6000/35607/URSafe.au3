#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#CS

SOURCE CODE FOR URSafe 1.3.0.0.3

Todo List

1. Add Improved Error Handling
2. Improve Performance
3. Add Options for almost everything <- Add at least 1 per release version
4. Enable changing of hotkeys <- Implement by 1.5.0.0

Logging Codes

==I== - Info
=EL0= - Error not caused by user
=EL1= - Error caused by missing data
=EL2= - Error caused by user
=EL3= - Critial Error

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
;Messages
Global $Msg, $TrayMsg

;To be Arrays
Global $Ran, $WinXY

;Arrays
Global $Block[3] = [False,False,False]
Global $GUI[2] = [0,0]
Global $Item_Block[4] = [0,0,0,0]
Global $Item_Start[2] = [0,0]
Global $Menu[7] = [0,0,0,0,0,0,0]
Global $Start[2] = [False,False]
Global $Status[3] = [False,False,False]

;Feedback System Variables
Global $Feedback, $Port

;GUI Menu Item Variables
Global $Item_Credits, $Item_Exit
Global $Item_Feedback, $Item_Hide, $Item_Math_Unlock, $Item_Reset_Five, $Item_Reset_Ten
Global $Item_Reset_Twenty, $Item_Update, $Item_Changelog

;Other GUI Control Variables
Global $Clock, $CreditsOK, $Input, $Instructions, $Toggle

;Settings Variables
Global $Start_Update, $Start_Locked, $Pass_Saved, $Password

;Misc Variables
Global $Refresh, $RefreshTimer, $Time, $Update_File, $Version_File

;Declare Constant Array
Const $Version[3] = ["1.3.0.0", "1.3.0.0.3", True]

;Declare Constants
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
$Refresh = 10000

;Set Password Status
$Pass_Saved = False

;Call The GUI
GUI()

; Log Execution
Logging(0)

;Display GUI
Func GUI()
;	Create GUI And Ctrls
	$GUI[0] = GUICreate("URSafe - Version " & $Version[0], @DesktopWidth, @DesktopHeight, 0, 0, 0x10000200, 0x00000008)
		$Menu[0] = GUICtrlCreateMenu("File")
			$Item_Hide = GUICtrlCreateMenuItem("Minimize", $Menu[0], 1)
				GUICtrlCreateMenuItem("", $Menu[0], 2)
			$Item_Exit = GUICtrlCreateMenuItem("Exit", $Menu[0], 3)
		$Menu[1] = GUICtrlCreateMenu("Options")
			$Menu[2] = GUICtrlCreateMenu("Don't Allow", $Menu[1], 1)
				$Item_Block[0] = GUICtrlCreateMenuItem("Any", $Menu[2], 1)
					GUICtrlCreateMenuItem("", $Menu[2], 2)
				$Item_Block[1] = GUICtrlCreateMenuItem("Command Prompt", $Menu[2], 3)
				$Item_Block[2] = GUICtrlCreateMenuItem("Shutdown", $Menu[2], 4)
				$Item_Block[3] = GUICtrlCreateMenuItem("Task Manager", $Menu[2], 5)
			$Menu[3] = GUICtrlCreateMenu("On Startup", $Menu[1], 2)
				$Item_Start[0] = GUICtrlCreateMenuItem("Lock URSafe", $Menu[3], 1)
				$Item_Start[1] = GUICtrlCreateMenuItem("Update URSafe", $Menu[3], 2)
			$Menu[4] = GUICtrlCreateMenu("Refresh Every", $Menu[1], 3)
				$Item_Reset_Five = GUICtrlCreateMenuItem("05 seconds", $Menu[4], 1, 1)
				$Item_Reset_Ten = GUICtrlCreateMenuItem("10 seconds", $Menu[4], 2, 1)
				$Item_Reset_Twenty = GUICtrlCreateMenuItem("20 seconds", $Menu[4], 3, 1)
		$Menu[5] = GUICtrlCreateMenu("Help")
			$Item_Credits = GUICtrlCreateMenuItem("Credits", $Menu[5], 1)
				GUICtrlCreateMenuItem("", $Menu[5], 2)
			$Item_Math_Unlock = GUICtrlCreateMenuItem("Math Unlock", $Menu[5], 3)
				GUICtrlCreateMenuItem("", $Menu[5], 4)
			$Menu[6] = GUICtrlCreateMenu("Online", $Menu[5], 5)
				$Item_Changelog = GUICtrlCreateMenuItem("Changelog", $Menu[6], 1)
				$Item_Feedback = GUICtrlCreateMenuItem("Feedback", $Menu[6], 2)
;				$Item_Manual = GUICtrlCreateMenuItem("Manual", $Menu[6], 3)
				$Item_Update = GUICtrlCreateMenuItem("Update", $Menu[6], 4)

		GUICtrlCreatePic("./pic.jpg", 0, 0, @DesktopWidth, @DesktopHeight, 0x00001000)
		$Clock = GUICtrlCreateLabel(_NowTime(), @DesktopWidth-(@DesktopWidth/8), 0, (@DesktopWidth/8), 20, 0x00001001, 0x00000008)
		$Feedback = GUICtrlCreateInput("", 280, 30, 50, 20, 0x00000044, 0x00000008)
		$Instructions = GUICtrlCreateLabel("Enter Password to Lock", 50, 30, 230, 20, 0x00001001, 0x00000008)
		$Input = GUICtrlCreateInput("", 50, 50, 230, 20, 0x000000A0, 0x00000008)
		$Toggle = GUICtrlCreateButton("Lock", 280, 50, 50, 20, 0x00000300, 0x00000008)
		GUICtrlSetState($Feedback, $GUI_DISABLE)

;	Call ASU and Startup
	ASU()
	Startup()

;	Loop
	While 1
;		Get GUI Messages
;		If Not GUICGUICtrlSetData($Clock, _NowTime())
		$Msg = GUIGetMsg()

;		Get Tray Messages
		$TrayMsg = TrayGetMsg()

;		Run Action decided by Message
		Select

;			Close URSafe
			Case $Msg = $Item_Exit
				Logging(1)
				DllClose($User32)
				ExitLoop

			Case $Msg = $Toggle Or _IsPressed("91", $User32)
				Status()

			Case $Msg = $Item_Math_Unlock
				MathUnlock()

;			IMPORTANT! DO NOT CHANGE!
;			Activate Protection When Locked
			Case $Status[0]
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

;			Update Settings for All Blocks
			Case $Msg = $Item_Block[0]
				Settings(0)

;			Update Settings for Command Prompt Block
			Case $Msg = $Item_Block[1]
				Settings(1)

;			Update Settings for Shutdown Block
			Case $Msg = $Item_Block[2]
				Settings(2)

;			Update Settings for Task Manager Block
			Case $Msg = $Item_Block[3]
				Settings(3)

;			Update Settings for Starting Locked
			Case $Msg = $Item_Start[0]
				Settings(4)

;			Update Settings for Starting with update check
			Case $Msg = $Item_Start[1]
				Settings(5)

;			Update URSafe
			Case $Msg = $Item_Update
				Update()

;			Restore URSafe From Tray
			Case $TrayMsg = $Tray_Event_PrimaryDouble
				WinSetState($GUI[0], "", @SW_SHOW)
				WinMove($GUI[0], "", 0, 0)

;			Hide URSafe to Tray
			Case $Msg = $Item_Hide
				WinSetState($GUI[0], "", @SW_HIDE)

;			Open Changelog
			Case $Msg = $Item_Changelog
				ShellExecute("http://code.google.com/p/kidsafe/wiki/URSafeChangelog")

;			Display Credits
			Case $Msg = $Item_Credits
				Credits()

			Case $Msg = $CreditsOK And WinExists("Credits", "")
				GUIDelete($GUI[1])
				WinSetState($GUI[0], "", @SW_SHOW)

;			Anything Not Listed Above
			Case Else
				;;;

		EndSelect
	WEnd
	Exit(0)
EndFunc

; Automatic Settings Update (ASU)
Func ASU()
	If Not (StringTrimLeft(FileReadLine($Settings, 2) == $Version[1],1)) Then
		ProgressOn("Converting Old Settings", "Converting Settings for version " & $Version[0], "Starting")
		ProgressSet(010, "Changing Attributes")
		FileSetAttrib($Settings, "-RSH")
		ProgressSet(030, "Converting any changed settings")
		If Not (INIRead($Settings, "Blocking", "Taskmgr", "Fail") == "Fail") Then
			INIWrite($Settings, "Blocking", "Task Manager", INIRead($Settings, "Blocking", "Taskmgr", "False"))
			INIDelete($Settings, "Blocking", "Taskmgr")
		EndIf
		ProgressSet(050, "Purging any removed settings")
		If Not (INIRead($Settings, "Main", "Kill LogonUI", "Fail") == "Fail") Then INIDelete($Settings, "Main", "Kill LogonUI")
		If Not (INIRead($Settings, "#URSafe Settings#", "Version", "Fail") == "Fail") Then INIDelete($Settings, "#URSafe Settings#", "Version")
		ProgressSet(070, "Finishing Changes")
		INIWrite($Settings, "#URSafe Settings#", "", $Version[1])
		ProgressSet(090, "Changing Attributes")
		FileSetAttrib($Settings, "+RSH")
		ProgressSet(100, "Done")
		Sleep(1000)
		ProgressOff()
	EndIf
EndFunc


; Display Credits
Func Credits()
	WinSetState($GUI[0], "", @SW_HIDE)
	$GUI[1] = GUICreate("Credits", 220, 220, -1, -1, 0x10000200, 0x00000008)
		GUICtrlCreateLabel("Autoit Superviser:", 10, 10, 90, 20)
		GUICtrlCreateLabel("Guinness", 120, 10, 90, 20); Well actually he just helped with some code
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
	If Not $Status[2] Then
		TCPStartup()
		$Port = TCPConnect("74.141.211.110", 5309)
		If @error Then
			MsgBox(4112, "Error", "Failed at capturing port.")
		Else
			TCPSend($Port, _GetIP() & "$" & "Checking Connection" & "$")
			If @error Then
				MsgBox(4112, "Error", "Feedback Server Offline." & @CRLF & "Please try again later.")
			Else
				$Status[2] = True
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
		Not (StringLen(GUICtrlRead($Feedback)) < 4) And _
		Not (StringLen(GUICtrlRead($Feedback)) > 5000) And _
		Not StringInStr(GUICtrlRead($Feedback), "fuck", 0) And _
		Not StringInStr(GUICtrlRead($Feedback), "shit", 0) And _
		Not StringInStr(GUICtrlRead($Feedback), "crap", 0) Then
			TCPSend($Port, _GetIP() &  "$" & StringReplace(GUICtrlRead($Feedback), "$", "(Money sign)") & "$")
			If @error Then
				MsgBox(4112, "Error", "Failed at sending data." & @CRLF & "Please try again later.")
			Else
				MsgBox(0x0, "Thanks", "Thank you for your feedback!")
				Logging(6)
			EndIf
			$Status[2] = False
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


; Execute Logging
Func Logging($Event)
	Select

		Case $Event = 0
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Opened")

		Case $Event = 1
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Closed")

		Case $Event = 2
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Locked")

		Case $Event = 3
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Unlocked")

		Case $Event = 4
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Updater Executed")

		Case $Event = 5
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Updater Finished Executing")

		Case $Event = 6
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Feedback Sent")

		Case $Event = 7
			FileWriteLine($Log, "==I== " & _Now() & " : " & "Math Unlock Succeeded, Answer: " & Execute($Ran[0]^3-$Ran[1]))

		Case $Event = 8
			FileWriteLine($Log, "==I== " & _Now() & " : " & "URSafe Saved Pass Reset To None")

		Case $Event = 9
			FileWriteLine($Log, "=EL1= " & _Now() & " : " & "No Unlock Password Specified, Not unlocking.")

		Case $Event = 10
			FileWriteLine($Log, "=EL1= " & _Now() & " : " & "No Lock Password Specified, Not Locking.")

		Case $Event = 11
			FileWriteLine($Log, "=EL2= " & _Now() & " : " & "Math Unlock Failed." & _
				"Input: " & GUICtrlRead($Input) & " Answer: " & Execute($Ran[0]^3-$Ran[1]))

		Case $Event = 12
			FileWriteLine($Log, "=EL2= " & _Now() & " : " & "Incorrect Password")

		Case $Event = 13
			FileWriteLine($Log, "=EL3= " & _Now() & " : " & "ERROR 0x01 Occured")

		Case $Event = 14
			FileWriteLine($Log, "=EL3= " & _Now() & " : " & "ERROR 0x02 Occured")

		Case Else
			Logging(14)

	EndSelect
EndFunc

; Execute Math Unlock
Func MathUnlock()
	If Not $Status[1] Then
		$Status[1] = True
		Global $Ran[2] = [Random(20, 50, 1), Random(1000, 8000, 1)]
		GUICtrlSetData($Instructions, "What is " & $Ran[0] & " cubed minus " & $Ran[1] & "?")
	Else
		GUICtrlSetData($Instructions, "Enter Password to Unlock")
		$Status[1] = False
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
	$WinXY = WinGetPos($GUI[0])
	If $WinXY[0] <> 0 Or $WinXY[1] <> 0 Or Not BitAND(WinGetState($GUI[0]), 8) Then
		WinMove($GUI[0], "", 0, 0)
		WinSetOnTop($GUI[0], "", 1)
		WinActivate($GUI[0])
	EndIf
	If ProcessExists("cmd.exe") And $Block[0] Then ProcessClose("cmd.exe")
	If ProcessExists("command.com") And $Block[0] Then ProcessClose("command.com")
	If ProcessExists("shutdown.exe") And $Block[1] Then _RunDOS("shutdown /a")
	If ProcessExists("taskmgr.exe") And $Block[2] Then ProcessClose("taskmgr.exe")
EndFunc


;Change Settings
Func Settings($Caller)
	FileSetAttrib($Settings, "-RSH")
	Select

		Case $Caller = 0 
			ContinueCase

		Case $Caller = 1
			If Not $Block[0] Then
				GUICtrlSetState($Item_Block[1], $GUI_CHECKED)
				INIWrite($Settings, "Blocking", "Command Prompt", "True")
				$Block[0] = True
			ElseIf Not ($Caller = 0) Then
				GUICtrlSetState($Item_Block[1], $GUI_UNCHECKED)
				INIWrite($Settings, "Blocking", "Command Prompt", "False")
				$Block[0] = False
			EndIf
			If $Caller = 0 Then ContinueCase

		Case $Caller = 2
			If Not $Block[1] Then
				GUICtrlSetState($Item_Block[2], $GUI_CHECKED)
				INIWrite($Settings, "Blocking", "Shutdown", "True")
				$Block[1] = True
			ElseIf Not ($Caller = 0) Then
				GUICtrlSetState($Item_Block[2], $GUI_UNCHECKED)
				INIWrite($Settings, "Blocking", "Shutdown", "False")
				$Block[1] = False
			EndIf
			If $Caller = 0 Then ContinueCase

		Case $Caller = 3
			If Not $Block[2] Then
				GUICtrlSetState($Item_Block[3], $GUI_CHECKED)
				INIWrite($Settings, "Blocking", "Task Manager", "True")
				$Block[2] = True
			ElseIf Not ($Caller = 0) Then
				GUICtrlSetState($Item_Block[3], $GUI_UNCHECKED)
				INIWrite($Settings, "Blocking", "Task Manager", "False")
				$Block[2] = False
			EndIf

		Case $Caller = 4
			If Not $Start[0] Then
				GUICtrlSetState($Item_Start[0], $GUI_CHECKED)
				INIWrite($Settings, "Main", "Lock on Start", "True")
				$Start[0] = True
			Else
				GUICtrlSetState($Item_Start[0], $GUI_UNCHECKED)
				INIWrite($Settings, "Main", "Lock on Start", "False")
				$Start[0] = False
			EndIf

		Case $Caller = 5
			If Not $Start_Update Then
				GUICtrlSetState($Item_Start[1], $GUI_CHECKED)
				INIWrite($Settings, "Main", "Update on Start", "True")
				$Start[1] = True
			Else
				GUICtrlSetState($Item_Start[1], $GUI_UNCHECKED)
				INIWrite($Settings, "Main", "Update on Start", "False")
				$Start[1] = False
			EndIf

		Case Else
			Logging(13)

	EndSelect
	FileSetAttrib($Settings, "+RSH")
EndFunc


; Execute Startup
Func Startup()
	If Not FileExists($Settings) Then
		INIWrite($Settings, "#URSafe Settings#", "", $Version[1])
		INIWrite($Settings, "Main", "Lock on Start", "False")
		INIWrite($Settings, "Main", "Update on Start", "False")
		INIWrite($Settings, "Blocking", "Command Prompt", "False")
		INIWrite($Settings, "Blocking", "Shutdown", "False")
		INIWrite($Settings, "Blocking", "Task Manager", "False")
		INIWrite($Settings, "Encrypted", "Password", "4E554C")
		FileSetAttrib($Settings, "+R")
	Else
		FileSetAttrib($Settings, "-SH")
	EndIf
	If INIRead($Settings, "Main", "Lock on Start", "False") = "True" Then
		GUICtrlSetState($Item_Start[0], $GUI_CHECKED)
		$Start[0] = True
	EndIf
	If INIRead($Settings, "Main", "Update on Start", "False") = "True" Then
		GUICtrlSetState($Item_Start[1], $GUI_CHECKED)
		$Start[1] = True
		Update()
	EndIf
	If INIRead($Settings, "Blocking", "Command Prompt", "False") = "True" Then
		GUICtrlSetState($Item_Block[1], $GUI_CHECKED)
		$Block[0] = True
	EndIf
	If INIRead($Settings, "Blocking", "Shutdown", "False") = "True" Then
		GUICtrlSetState($Item_Block[2], $GUI_CHECKED)
		$Block[1] = True
	EndIf
	If INIRead($Settings, "Blocking", "Taskmgr", "False") = "True" Then
		GUICtrlSetState($Item_Block[3], $GUI_CHECKED)
		$Block[2] = True
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
	If $Status[2] Then
		Feedback()
	ElseIf $Status[0] Then
		If GUICtrlRead($Input) = "" Then
			Logging(9)
		ElseIf $Status[1] Then
			If GUICtrlRead($Input) = Execute($Ran[0]^3-$Ran[1]) Then
				Logging(7)
				$Status[1] = False
				GUICtrlSetData($Input, $Password)
				Status()
			Else
				Logging(11)
				GUICtrlSetData($Input, "")
			EndIf
		ElseIf GUICtrlRead($Input) == $Password Or GUICtrlRead($Input) == $Password & "-reset" Then
			Logging(3)
			_MouseTrap()
			$Status[0] = False
			GUISetState(0x10000288)
			If GUICtrlRead($Input) == $Password & "-reset" Then
				Logging(8)
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
			GUICtrlSetState($Menu[0], $GUI_ENABLE)
			GUICtrlSetState($Menu[1], $GUI_ENABLE)
			GUICtrlSetState($Item_Update, $GUI_ENABLE)
			GUICtrlSetState($Item_Credits, $GUI_ENABLE)
			GUICtrlSetState($Item_Math_Unlock, $GUI_DISABLE)
			GUICtrlSetState($Item_Feedback, $GUI_ENABLE)
		Else
			GUICtrlSetData($Input, "")
			Logging(12)
		EndIf
	ElseIf GUICtrlRead($Input) = "" Then
		Logging(10)
	Else
		Logging(2)
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
		GUICtrlSetState($Menu[0], $GUI_DISABLE)
		GUICtrlSetState($Menu[1], $GUI_DISABLE)
		GUICtrlSetState($Item_Update, $GUI_DISABLE)
		GUICtrlSetState($Item_Credits, $GUI_DISABLE)
		GUICtrlSetState($Item_Math_Unlock, $GUI_ENABLE)
		GUICtrlSetState($Item_Feedback, $GUI_DISABLE)
		$Password = GUICtrlRead($Input)
		GUICtrlSetData($Input, "")
		If $Pass_Saved Then GUICtrlSetState($Input, $GUI_ENABLE)
		$Status[0] = True
	EndIf
EndFunc


; Execute Updater
Func Update()
	Logging(4)
	ProgressOn("URSafe Updater", "Please Wait", "Getting Latest Version Number.")
	$Version_File = StringTrimRight(BinaryToString(InetRead("http://www.fcofix.org/mirror/ursupdate.txt")), 1)
	ProgressSet(33, "Comparing Latest Version to Local Version", "Checking")
	If $Version[2] Then
		If StringTrimLeft($Version_File, 5) > StringReplace($Version[1], ".", "") Then
			ProgressSet(66, "Opening Source to Version " & StringTrimLeft($Version_File, 5), "Opening")
			ShellExecute("http://code.google.com/p/kidsafe/source/browse/")
		Else
			ProgressSet(66, "No Developer Build Available.", "Up to date")
			Sleep(500)
		EndIf
	Else
		If StringTrimRight($Version_File, 6) > StringReplace($Version[0], ".", "") Then
			ProgressSet(66, "Downloading Update to Version " & StringTrimRight($Version_File, 6), "Downloading")
			$Update_File = InetGet("http://www.fcofix.org/mirror/ursafe.exe", @ScriptDir & "\URSafe_Setup.exe", 1, 0)
			InetClose($Update_File)
		Else
			ProgressSet(66, "No Update Needed.", "Up to date")
			Sleep(500)
		EndIf
	EndIf
	ProgressSet(100, "Done", "Closing")
	Sleep(1000)
	ProgressOff()
	Logging(5)
EndFunc