; By Jeff Davis
; xwinterx (at) roadrunner (dot) com


#include <Array.au3>
#Include <File.au3>

Opt("TrayMenuMode", 9)   ; Default tray menu items (Script Paused/Exit) will not be shown.

;Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


Global Const $TITLE = "WinKill"
Global Const $VERSION = "0.1.4"



Global Const $TRAY_UNCHECKED 		= 4 
Global Const $TRAY_CHECKED 			= 1 

Global Const $TBS_TOP 				= 0x0004
Global Const $TCS_FLATBUTTONS 		= 0x0008
Global Const $TCS_BUTTONS 			= 0x0100
Global Const $GUI_CHECKED 			= 1
Global Const $GUI_UNCHECKED 		= 4
Global Const $GUI_ENABLE 			= 64
Global Const $GUI_DISABLE 			= 128
Global Const $ES_PASSWORD 			= 32
Global Const $ES_MULTILINE 			= 0x0004
Global Const $ES_READONLY 			= 0x0800
Global Const $GUI_EVENT_CLOSE 		= -3
Global Const $GUI_HIDE 				= 32
Global Const $GUI_SHOW 				= 16
Global Const $SS_CENTER				= 1
Global Const $SS_RIGHT 				= 2
Global Const $SS_SUNKEN 			= 0x1000
Global Const $WS_EX_TOPMOST 		= 8
Global Const $WS_EX_TOOLWINDOW 		= 128
Global Const $WS_DLGFRAME 			= 0x00400000 
Global Const $WS_CAPTION 			= 0x00C00000
Global Const $WS_BORDER 			= 0x00800000
Global Const $WS_EX_APPWINDOW 		= 0x00040000
Global Const $WS_POPUP 				= 0x80000000
Global Const $WS_EX_STATICEDGE		= 0x00020000
Global Const $SS_NOTIFY 			= 0x0100
Global Const $GUI_WS_EX_PARENTDRAG 	= 0x00100000
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $BS_ICON 				= 0x0040 
Global Const $BS_FLAT 				= 0x8000
Global Const $BS_DEFPUSHBUTTON 		= 1
Global Const $WS_CHILD = 0x40000000 
Global Const $WS_TABSTOP = 0x00010000
Global Const $SS_ETCHEDFRAME = 0x12
Global Const $WS_OVERLAPPEDWINDOW = 0x00CF0000
Global Const $WS_CLIPSIBLINGS = 0x04000000


Global $WIN_LEN = 10 ; length of window title to trim to from left side
Global $WIN_LEN_OPTION	; turn option on or off

Global $PAUSE = 0
Global $CHECK_PAUSE = 0
Global $PAUSE_FLIPFLOP = 0

Global $MODE_LEARNING = "ON"

Global $DIR_DEFINITIONS = @ScriptDir &"\definitions\"
Global $FILE_EXCEPTIONS = @ScriptDir & "\definitions\exceptions.kif"
Global $APP_EXCEPTIONS = @ScriptDir & "\definitions\applications.kif"
Global $FILE_INI = $DIR_DEFINITIONS & "settings.ini"
Global $FILE_LOG = @ScriptDir & "\log.txt"

Dim $ARRAY_WINS[10]
Dim $ARRAY_CHECK[10]
Dim $ARRAY_APPS[10]

Global Const $DEBUG = "OFF"

Load_Settings()

$WIN_LEN_OPTION = $GUI_CHECKED

; Loading Screen
$Win_Splash = GuiCreate("Splash", 300, 150, -1, -1, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
GUICtrlCreatePic(@ScriptDir & "\splash.gif", 0, 0, 300, 150)
GUICtrlSetState(-1, $GUI_DISABLE)
WinSetTrans("Splash", "", 0)
GUISetState()

For $i = 5 To 255 Step 5
	WinSetTrans("Splash", "", $i)
	Sleep(10)
Next
Sleep(5000)
GUIDelete($Win_Splash)




$TRAY_SETTINGS = TrayCreateItem("Settings", -1, -1, 1)
$TRAY_MODE = TrayCreateItem("Learning Mode", -1, -1, 1)
If $MODE_LEARNING = "ON" Then
	TrayItemSetState($TRAY_MODE, $TRAY_CHECKED)
EndIf
$TRAY_PAUSE = TrayCreateItem("Pause WinKill", -1, -1, 1)
TrayCreateItem("")
$TRAY_ABOUT = TrayCreateItem("About", -1, -1)
TrayCreateItem("")
$TRAY_EXIT = TrayCreateItem("Exit")


$WIN_SETTINGS = GUICreate("WK Settings", 300, 150, -1, -1)
$MENU_FILE = GUICtrlCreateMenu("File")
$MENU_FILE_RELOAD = GUICtrlCreateMenuItem("Reload Default", $MENU_FILE)
GUICtrlCreateMenuItem("", $MENU_FILE)
$MENU_FILE_PURGE = GUICtrlCreateMenuItem("Reset Log", $MENU_FILE)



If Not FileExists($DIR_DEFINITIONS) Then
	DirCreate($DIR_DEFINITIONS)
EndIf

If Not FileExists($FILE_EXCEPTIONS) Then
	Create_Exceptions()
EndIf

If Not FileExists($APP_EXCEPTIONS) Then
	Create_App_Exceptions()
EndIf

writelog("WK initialized!")

Load_App_Exceptions()
Init_Windows()

While 1
	$msg1 = TrayGetMsg()
	$msg2 = GUIGetMsg()
	Select
		Case $msg1 = $TRAY_EXIT
			$yesno = MsgBox(4, "Alert!", "A request to shut down WinKill has been received!" & @CRLF & @CRLF _
				& "Do you want to close WinKill?")
			If $yesno = 6 Then
				writelog("WinKill shutting down!")
				Exit
			EndIf
		Case $msg1 = $TRAY_PAUSE
			Pause_WK()
		Case $msg1 = $TRAY_SETTINGS
			If $PAUSE = 0 Then
				Pause_WK()
				$CHECK_PAUSE = 1
			EndIf
			GUISetState(@SW_SHOW, $WIN_SETTINGS)
		Case $msg2 = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE, $WIN_SETTINGS)
			If $CHECK_PAUSE = 1 Then
				Pause_WK()
				$CHECK_PAUSE = 0
			EndIf
		Case $msg1 = $TRAY_MODE
			If $MODE_LEARNING = "ON" Then
				$MODE_LEARNING = "OFF"
				TrayItemSetState($TRAY_MODE, $TRAY_UNCHECKED)
			Else
				$MODE_LEARNING = "ON"
				TrayItemSetState($TRAY_MODE, $TRAY_CHECKED)
			EndIf
			writelog("Learning Mode toggled: " & $MODE_LEARNING)
			Sleep(3000)
			ToolTip("")
		Case $msg2 = $MENU_FILE_RELOAD
			Create_Exceptions()
			Create_App_Exceptions()
		Case $msg2 = $MENU_FILE_PURGE
			Reset_Log()
		Case Else
			;;;
	EndSelect
	Sleep(10)
	If $PAUSE = 0 Then
		Init_Check()
		Check_New()
	EndIf
WEnd

Func Pause_WK()
	If $PAUSE = 0 Then
		$PAUSE = 1
		writelog("WinKill Paused!")
		TrayItemSetState($TRAY_PAUSE, $TRAY_CHECKED)
		AdlibEnable("FlipFlop", 750)
	Else
		$PAUSE = 0
		AdlibDisable()
		writelog("WinKill Unpaused!")
		TraySetIcon(@ScriptDir & "\icon_default.ico")
		TrayItemSetState($TRAY_PAUSE, $TRAY_UNCHECKED)
	EndIf
EndFunc

; loads settings file
Func Load_Settings()
	If not FileExists($FILE_INI) Then
		IniWrite($FILE_INI, "About", "Title", "KillIt")
		IniWrite($FILE_INI, "Settings", "WinLenOpt", $GUI_UNCHECKED)
	EndIf
	
	$WIN_LEN_OPTION = IniRead($FILE_INI, "Settings", "WinLenOpt", $GUI_UNCHECKED)
EndFunc

; just flashes the icon when program is paused
Func FlipFlop()
	If $PAUSE_FLIPFLOP = 0 Then
		$PAUSE_FLIPFLOP = 1
		TraySetIcon(@SystemDir & "\shell32.dll", -132)
	Else
		$PAUSE_FLIPFLOP = 0
		TraySetIcon(@ScriptDir & "\icon_default.ico")
	EndIf
EndFunc

; writes to log file
Func writelog($msglog)
	FileWriteLine($FILE_LOG, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & $msglog)
EndFunc

; Checks for new windows!
Func Check_New()
	For $i = 1 To (UBound($ARRAY_CHECK) - 1)
		;If Check_App_Exceptions($ARRAY_CHECK[$i]) = -1 Then
			If _ArrayFindAll($ARRAY_WINS, $ARRAY_CHECK[$i]) = -1 Then
				If $MODE_LEARNING = "ON" Then
					writelog("New window found, Learning Mode ON: " & $ARRAY_CHECK[$i])
					$yesno = MsgBox(4, "Learning Mode ON", "The following window has opened. Do you want" & @CRLF _
						& "to add it to your safelist?" & @CRLF & @CRLF & $ARRAY_CHECK[$i])
					If $yesno = 6 Then
						writelog("Adding new exception to safelist.")
						FileWriteLine($FILE_EXCEPTIONS, $ARRAY_CHECK[$i])
						_ArrayAdd($ARRAY_WINS, $ARRAY_CHECK[$i])
					Else
						writelog("Pop-up closed: " & $ARRAY_CHECK[$i])
						WinKill($ARRAY_CHECK[$i])
					EndIf
				Else
					writelog("Learning Mode OFF, Pop-up closed: " & $ARRAY_CHECK[$i])
					WinKill($ARRAY_CHECK[$i])
				EndIf
			EndIf
		;EndIf
	Next
EndFunc

; Initializes list for current windows and adds exceptions to array, not to exception file
Func Init_Windows()
	writelog("Initializing currently active windows.")
	Local $var = WinList()
	
	For $i = 1 to $var[0][0]
	  If $var[$i][0] <> "" AND IsVisible($var[$i][0]) Then
		_ArrayAdd($ARRAY_WINS, $var[$i][0])
		writelog("Detected: " & $var[$i][0])
	  EndIf
  Next
  Load_Exceptions()
EndFunc

; loads exception file to safe array
Func Load_Exceptions()
	writelog("Loading exceptions file.")
	
	Local $ARRAY_TEMP
	Local $count = 1
	
	_FileReadToArray($FILE_EXCEPTIONS, $ARRAY_TEMP)
	
	For $i = 1 To (UBound($ARRAY_TEMP) - 1)
		_ArrayAdd($ARRAY_WINS, $ARRAY_TEMP[$i])
		writelog("Loading Exception: " & $ARRAY_TEMP[$i])
		Sleep(500)
		$count += 1
	Next
EndFunc

; initializes new window list to use for new window search
Func Init_Check()
	If IsArray($ARRAY_CHECK) Then
		$ARRAY_CHECK = 0
		Dim $ARRAY_CHECK[10]
	EndIf
	Local $var = WinList()
	
	For $i = 1 to $var[0][0]
	  If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		_ArrayAdd($ARRAY_CHECK, $var[$i][0])
	  EndIf
  Next
  
  
EndFunc

; checks if the windows are visible
Func IsVisible($s_handle)
  If BitAnd( WinGetState($s_handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc


Func Edit_Exceptions()
	
EndFunc

; creates a default exceptions list
Func Create_Exceptions()
	writelog("Creating default exceptions list.")
	SplashTextOn("WinKill", "Creating default exception list", 200, 200, -1, -1)
	If FileExists($FILE_EXCEPTIONS) Then
		FileDelete($FILE_EXCEPTIONS)
	EndIf
	FileWriteLine($FILE_EXCEPTIONS, "My Computer")
	FileWriteLine($FILE_EXCEPTIONS, "Start Menu")
	FileWriteLine($FILE_EXCEPTIONS, "WK Settings")
	Sleep(2000)
	SplashOff()
EndFunc

; creates a default application exception list to be used later.
Func Create_App_Exceptions()
	writelog("Creating default application exceptions list.")
	SplashTextOn("WinKill", "Creating default exception list", 200, 200, -1, -1)
	If FileExists($APP_EXCEPTIONS) Then
		FileDelete($APP_EXCEPTIONS)
	EndIf
	FileWriteLine($APP_EXCEPTIONS, "SciTE_app.exe")
	Sleep(2000)
	SplashOff()
EndFunc

Func Load_App_Exceptions()
	writelog("Loading exceptions file.")
	
	Local $ARRAY_TEMP
	Local $count = 1
	
	_FileReadToArray($APP_EXCEPTIONS, $ARRAY_TEMP)
	
	For $i = 1 To (UBound($ARRAY_TEMP) - 1)
		_ArrayAdd($ARRAY_APPS, $ARRAY_TEMP[$i])
		writelog("Loading App Exception: " & $ARRAY_TEMP[$i])
		Sleep(500)
		$count += 1
	Next
EndFunc

Func Check_App_Exceptions($aCheck)
	Dim $List[2][2]
	For $i = 1 to (UBound($ARRAY_APPS) - 1)
		If ProcessExists($ARRAY_APPS[$i]) Then
			$List = ProcessList($ARRAY_APPS[$i])
			If $List[1][1] = WinGetProcess($aCheck) Then
				;If IsVisible($aCheck) Then
				;	writelog("Found App Exception Window: " & $aCheck)
				;EndIf
				return 0
			EndIf
		EndIf
		$List = 0
		Dim $List[2][2]
	Next
	Return -1 ; not a valid application exception window
EndFunc


Func Reset_Log()
	If FileExists($FILE_LOG) Then
		FileDelete($FILE_LOG)
	EndIf
	writelog("Log file purged!")
	writelog("WK Initialized!")
EndFunc

