#include <Array.au3>
#include <GuiTreeView.au3>

Opt("TrayMenuMode", 1)
Opt("MustDeclareVars", 1)

Global $title = "Time Administrator"
Global $version = "0.7"

; text encoding/decoding seed
Global Const $txtencodebase = 75

Global Const $WM_NOTIFY = 0x004E
Global Const $GUI_EVENT_CLOSE 		= -3
Global Const $GUI_CHECKED 			= 1
Global Const $GUI_UNCHECKED 		= 4
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)
Global Const $NM_RCLICK = ($NM_FIRST - 5)

Global $pass; = "a4885a"
Global $Settings = "settings.ini"
Global $Users = "users.ini"
Global $time_allowed = 60
Global $current_time
Global $warning_status = False
Global $admin = False
Global $enabled = False
Global $configured = True

Global $Sun_Allowed = 180
Global $Mon_Allowed = 60
Global $Tues_Allowed = 60
Global $Wed_Allowed = 60
Global $Thurs_Allowed = 60
Global $Fri_Allowed = 60
Global $Sat_Allowed = 180

Global $msg_tray, $msg_gui
Global $TRAY_ABOUT, $TRAY_EXIT, $TRAY_TIME_INFO, $TRAY_SETTINGS

Global $GUI_SETTINGS, $TV_USERS


If Not FileExists($Settings) Then
	$configured = False
	MsgBox(4096 + 48, "Error!", $title & " has not been configured yet! Time restrictions" & @CRLF _
		& "are not in effect!")
	InitPassword()
EndIf

If Not FileExists($Users) Then
	CreateAllUsers()
EndIf



;If GetAdminStatus(@UserName) = True Then
;	$admin = True
;EndIf

;If CheckEnabled(@UserName) = True Then
;	$enabled = True
;EndIf


$TRAY_ABOUT = TrayCreateItem("About")
TrayCreateItem("")
$TRAY_TIME_INFO = TrayCreateItem("Time Info")
TrayCreateItem("")
$TRAY_SETTINGS = TrayCreateItem("Settings")
TrayCreateItem("")
$TRAY_EXIT = TrayCreateItem("Exit")

TraySetState()

$GUI_SETTINGS = GUICreate($title & " - v" & $version, 600, 400, -1, -1)

Global $MENU_TOOLS = GUICtrlCreateMenu("Tools")
Global $MENU_TOOLS_PASSWORD = GUICtrlCreateMenuItem("Change Password...", $MENU_TOOLS)

$TV_USERS = GUICtrlCreateTreeView(10, 20, 250, 300)
Global $TV_ARRAY = IniReadSectionNames($Users)
For $i = 1 to $TV_ARRAY[0]
	GUICtrlCreateTreeViewItem(decode_text($TV_ARRAY[$i]), $TV_USERS)
Next

Global $BTN_SAVE = GUICtrlCreateButton("Save", 530, 340, 60, 20)

Global $CB_ADMIN = GUICtrlCreateCheckbox("Admin", 280, 20, 70, 20)
Global $CB_ENABLED = GUICtrlCreateCheckbox("Enabled", 360, 20, 80, 20)

GUICtrlCreateLabel("Day", 280, 60, 40, 20)
GUICtrlCreateLabel("Time (mins)", 330, 60, 100, 20)

GUICtrlCreateLabel("Sun:", 280, 80, 40, 20)
Global $INP_SUN = GUICtrlCreateInput("", 330, 80, 50, 20)

GUICtrlCreateLabel("Mon:", 280, 110, 40, 20)
Global $INP_MON = GUICtrlCreateInput("", 330, 110, 50, 20)

GUICtrlCreateLabel("Tues:", 280, 140, 40, 20)
Global $INP_TUES = GUICtrlCreateInput("", 330, 140, 50, 20)

GUICtrlCreateLabel("Wed:", 280, 170, 40, 20)
Global $INP_WED = GUICtrlCreateInput("", 330, 170, 50, 20)

GUICtrlCreateLabel("Thur:", 280, 200, 40, 20)
Global $INP_THUR = GUICtrlCreateInput("", 330, 200, 50, 20)

GUICtrlCreateLabel("Fri:", 280, 230, 40, 20)
Global $INP_FRI = GUICtrlCreateInput("", 330, 230, 50, 20)

GUICtrlCreateLabel("Sat:", 280, 260, 40, 20)
Global $INP_SAT = GUICtrlCreateInput("", 330, 260, 50, 20)

;GUISetState()

GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")

ServiceStart()

While 1
	$msg_tray = TrayGetMsg()
	$msg_gui = GUIGetMsg()
	Select
		Case $msg_gui = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE, $GUI_SETTINGS)
		Case $msg_tray = $TRAY_EXIT
			Quit()
		Case $msg_tray = $TRAY_ABOUT
			; display about box
		Case $msg_tray = $TRAY_TIME_INFO
			ShowTimeInfo()
		Case $msg_tray = $TRAY_SETTINGS
			Configure()
		Case $msg_gui = $MENU_TOOLS_PASSWORD
			ChangePassword()
		Case $msg_gui = $BTN_SAVE
			SaveGUI()
	EndSelect
	Sleep(10)
WEnd

Func GetTVLabel()
	;Return StringTrimRight(GUICtrlRead(GUICtrlRead($TV_USERS)), 1)
	Return GUICtrlRead($TV_USERS, 1)
EndFunc

Func PopulateGUI()
	Local $tuser = GetTVLabel()

	If GetAdminStatus($tuser) = True Then
		GUICtrlSetState($CB_ADMIN, $GUI_CHECKED)
	Else
		GUICtrlSetState($CB_ADMIN, $GUI_UNCHECKED)
	EndIf

	If CheckEnabled($tuser) = True Then
		GUICtrlSetState($CB_ENABLED, $GUI_CHECKED)
	Else
		GUICtrlSetState($CB_ENABLED, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($INP_SUN, decode_text(IniRead($Users, encode_text($tuser), encode_text("SundayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_MON, decode_text(IniRead($Users, encode_text($tuser), encode_text("MondayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_TUES, decode_text(IniRead($Users, encode_text($tuser), encode_text("TuesdayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_WED, decode_text(IniRead($Users, encode_text($tuser), encode_text("WednesdayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_THUR, decode_text(IniRead($Users, encode_text($tuser), encode_text("ThursdayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_FRI, decode_text(IniRead($Users, encode_text($tuser), encode_text("FridayAllowed"),encode_text("0"))))
	GUICtrlSetData($INP_SAT, decode_text(IniRead($Users, encode_text($tuser), encode_text("SaturdayAllowed"),encode_text("0"))))

EndFunc

Func SaveGUI()
	Local $tuser = GetTVLabel()
	If $tuser = "" Then
		Return
	EndIf

	If GUICtrlRead($CB_ADMIN) = $GUI_CHECKED Then
		$admin = True
		IniWrite($Users, encode_text($tuser), encode_text("adminprivs"),encode_text("True"))
	Else
		$admin = False
		IniWrite($Users, encode_text($tuser), encode_text("adminprivs"),encode_text("False"))
	EndIf

	If GUICtrlRead($CB_ENABLED) = $GUI_CHECKED Then
		$enabled = True
		IniWrite($Users, encode_text($tuser), encode_text("enabled"),encode_text("True"))
	Else
		$enabled = False
		IniWrite($Users, encode_text($tuser), encode_text("enabled"),encode_text("False"))
	EndIf

	IniWrite($Users, encode_text($tuser), encode_text("SundayAllowed"),encode_text(GUICtrlRead($INP_SUN)))
	IniWrite($Users, encode_text($tuser), encode_text("MondayAllowed"),encode_text(GUICtrlRead($INP_MON)))
	IniWrite($Users, encode_text($tuser), encode_text("TuesdayAllowed"),encode_text(GUICtrlRead($INP_TUES)))
	IniWrite($Users, encode_text($tuser), encode_text("WednesdayAllowed"),encode_text(GUICtrlRead($INP_WED)))
	IniWrite($Users, encode_text($tuser), encode_text("ThursdayAllowed"),encode_text(GUICtrlRead($INP_THUR)))
	IniWrite($Users, encode_text($tuser), encode_text("FridayAllowed"),encode_text(GUICtrlRead($INP_FRI)))
	IniWrite($Users, encode_text($tuser), encode_text("SaturdayAllowed"),encode_text(GUICtrlRead($INP_SAT)))

EndFunc

; starts the service (enables adlib for 60 seconds)
Func ServiceStart()
	;If $admin = False And $configured = True And $enabled = True Then
		AdlibEnable("Run_Times", 60000)
		CheckDate()
		CheckWarning()
	;EndIf
EndFunc

; stops the service (disables adlib)
Func ServiceStop()
	AdlibDisable()
EndFunc

; displays time left to the user
Func ShowTimeInfo()
	; gets time left from user profile
	Local $TL = decode_text(IniRead($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text(0)))

	Local $temp = @UserName

	If $admin = True Then
		$temp &= " (admin)"
		$TL = "UNLIMITED"
	EndIf

	If $enabled = False Then
		$TL &= " (disabled)"
	EndIf

	Local $GUI_TIME = GUICreate("User Information", 250, 200)
	GUICtrlCreateLabel("User: " & $temp, 10, 10, 200, 20)
	GUICtrlCreateLabel("Time: " & $TL, 10, 35, 200, 20)

	GUISetState(@SW_SHOW, $GUI_TIME)

	Local $msg_time
	While 1
		$msg_time = GUIGetMsg()

		If $msg_time = $GUI_EVENT_CLOSE Then
			GUIDelete($GUI_TIME)
			ExitLoop
		EndIf
	WEnd
EndFunc

; shows configuration GUI pre-built at time of run
Func Configure()
	; checks to see if correct password was entered
	If CheckPassword() = 1 Then
		GUISetState(@SW_SHOW, $GUI_SETTINGS)
	EndIf
EndFunc

; confirms they want to quit then quits
Func Quit()
	If CheckPassword() = 1 Then
		Local $yesno = MsgBox(4096 + 32 + 4, "Confirm?", "Are you sure you want to terminate program?")

		If $yesno = 6 Then
			Exit
		EndIf
	EndIf
EndFunc

; checks date for last login, if different, it resets the time for the current day
Func CheckDate()
	; Get date of last login
	Local $local_date = decode_text(IniRead($Users, encode_text(@UserName), encode_text("last_login"), encode_text(-1)))
	; Get time allowed for the day
	Local $local_allowed = decode_text(IniRead($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Allowed"), encode_text(-1)))

	If $local_date = -1 Or $local_date <> @YEAR & @MON & @MDAY Then
		; Writes new login date for today if it is different
		IniWrite($Users, encode_text(@UserName), encode_text("last_login"), encode_text(@YEAR & @MON & @MDAY))
		; Resets time used with time allowed for that day
		IniWrite($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text($local_allowed))
	EndIf
EndFunc

; adlib functions
Func Run_Times()
	$admin = GetAdminStatus(@UserName)
	$enabled = CheckEnabled(@UserName)
	CheckDate()
	CheckWarning()
	DecrementTime()
	CheckTime()
EndFunc

; checks to see if users time has expired
Func CheckTime()
	; gets time left from user profile
	Local $local_time = decode_text(IniRead($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text(0)))
	; if time is less than 1 (zero or negative) then force a shutdown.
	If $local_time < 1 Then
		MsgBox(4096, "Alert!", "Your time is up! Click OK to log out.")
		;Shutdown(4)	; <---- forces a log out
		;Exit
	EndIf
EndFunc

; Warns user when they have 10 minutes or less on their time
Func CheckWarning()
	; gets time left from user profile
	Local $local_time = decode_text(IniRead($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text(0)))
	; if they have NOT been warned, then warn them!
	If $warning_status = False Then
		; if time left is 10 minutes or left
		If $local_time < 11 Then
			MsgBox(4096, "Alert!", "You have " & $local_time & " minute(s) left! Save any files you are working on!")
			; sets the warning status to TRUE so we dont warn them every minute for 10 mins or less
			$warning_status = True
		EndIf
	EndIf
EndFunc

; Decrements time in user profile
Func DecrementTime()
	If $admin = False Then
		If $enabled = True Then
			; gets time left from user profile
			Local $local_time = decode_text(IniRead($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text(0)))
			; decrement it by 1
			$local_time -= 1
			; write time to user profile
			IniWrite($Users, encode_text(@UserName), encode_text(ConvertWDAYtoString(@WDAY) & "Left"), encode_text($local_time))
		EndIf
	EndIf
EndFunc


Func CheckPassword()
	Local $checkpass = InputBox("Security", "Enter admin password.", "", "*")
	$pass = decode_text(IniRead($Settings, encode_text("settings"), encode_text("password"), encode_text("")))
	If $checkpass = $pass Then
		Return 1
	Else
		MsgBox(4096 + 48, "Error", "Incorrect password")
		Return -1
	EndIf
EndFunc

; Takes the value of @WDAY and returns the day in string format
Func ConvertWDAYtoString($vWDAY)
	Switch $vWDAY
		Case 1
			Return "Sunday"
		Case 2
			Return "Monday"
		Case 3
			Return "Tuesday"
		Case 4
			Return "Wednesday"
		Case 5
			Return "Thursday"
		Case 6
			Return "Friday"
		Case 7
			Return "Saturday"
		Case Else
			Return "Unknown"
	EndSwitch
EndFunc

; Creates new user profile in the main $User file
Func InitNewUser($vUser)
	; @WDAY => 1 for sunday, 7 for saturday

	; writes todays date as last login date
	IniWrite($Users, encode_text($vUser), encode_text("last_login"), encode_text(@YEAR & @MON & @MDAY))

	; writes whether user is an admin (FALSE by default)
	IniWrite($Users, encode_text($vUser), encode_text("adminprivs"), encode_text("False"))

	; writes whether user is enabled (due to "extra" profiles beyond user defined)
	IniWrite($Users, encode_text($vUser), encode_text("enabled"), encode_text("False"))

	For $i = 1 to 7
		IniWrite($Users, encode_text($vUser), encode_text(ConvertWDAYtoString($i) & "Allowed"), encode_text(GetDefaultTime($i)))
		IniWrite($Users, encode_text($vUser), encode_text(ConvertWDAYtoString($i) & "Left"), encode_text(GetDefaultTime($i)))
	Next
EndFunc

; gets admin status of user
Func GetAdminStatus($vUserName)
	Local $adminstatus = decode_text(IniRead($Users, encode_text($vUserName), encode_text("adminprivs"), encode_text("False")))

	If $adminstatus = "True" Then
		Return True
	Else
		Return False
	EndIf

EndFunc

; gets admin status of user
Func CheckEnabled($vUserName)
	Local $enabledstatus = decode_text(IniRead($Users, encode_text($vUserName), encode_text("enabled"), encode_text("False")))

	If $enabledstatus = "True" Then
		Return True
	Else
		Return False
	EndIf

EndFunc
; Returns the default time allowed for the day of the week
Func GetDefaultTime($vWDAY)
	Switch $vWDAY
		Case 1 ; Sunday
			Return $Sun_Allowed
		Case 2 ; Monday
			Return $Mon_Allowed
		Case 3 ; Tuesday
			Return $Tues_Allowed
		Case 4 ; Wednesday
			Return $Wed_Allowed
		Case 5 ; Thursday
			Return $Thurs_Allowed
		Case 6 ; Friday
			Return $Fri_Allowed
		Case 7 ; Saturday
			Return $Sat_Allowed
		Case Else ; Error
			Return 0
	EndSwitch
EndFunc

; creates user profile for all users
; Credits for original function to smashly of www.autoitscript.com
Func CreateAllUsers()
	Local $profilesset = decode_text(IniRead($Settings, encode_text("settings"), encode_text("profilescreated"), encode_text("")))

	If $profilesset <> "True" Then
		#cs
		Local $wbemFlagReturnImmediately = 0x10
		Local $wbemFlagForwardOnly = 0x20
		Local $colItems = ""
		Local $strComputer = "localhost"
		Local $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
		$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_UserAccount", "WQL", _
				$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		If IsObj($colItems) Then
			For $objItem In $colItems
				InitNewUser($objItem.Name)
			Next
			IniWrite($Settings, encode_text("settings"), encode_text("profilescreated"), encode_text("True"))
		Else
			MsgBox(4096, "Error", "Unable to create initial user accounts!")
		EndIf
		#ce
		Local $colUsers, $Array[1] = ["user"]
		$colUsers = ObjGet("WinNT://" & @ComputerName)
		If Not IsObj($colUsers) Then ;Return SetError(1, 0, 0)
			MsgBox(4096, "Error", "Unable to create initial user accounts!")
		Else
			$colUsers.Filter = $Array
			For $objUser In $colUsers
				;$sTmp &= $objUser.Name & "|"
				If $objUser.Description = "" Then
					InitNewUser($objUser.Name)
				EndIf
			Next
			IniWrite($Settings, encode_text("settings"), encode_text("profilescreated"), encode_text("True"))

			;Return SetError(0, 0, StringSplit(StringTrimRight($sTmp, 1), "|"))
		EndIf
	EndIf
EndFunc   ;==>Users

; initial check for set password
Func InitPassword()
	Local $pw1 = ""
	Local $pw2 = ""

	If decode_text(IniRead($Settings, encode_text("settings"), encode_text("password"), encode_text(""))) = "" Then
		while 1

			While $pw1 = ""
				$pw1 = InputBox("Configure Password", "Set your administrative password:", "", "*")
			WEnd


			While $pw2 = ""
				$pw2 = InputBox("Confirm Password", "Confirm your administrative password:", "", "*")
			WEnd

			If $pw1 <> $pw2 Then
				MsgBox(4096 + 16, "Error", "Passwords do not match!")
			Else
				MsgBox(4096 + 48, "Success", "Your password has been created!")
				IniWrite($Settings, encode_text("settings"), encode_text("password"), encode_text($pw1))
				;$pass = $pw1
				ExitLoop
			EndIf
		WEnd
	EndIf
EndFunc

; Changes password
Func ChangePassword()
	Local $pw1 = ""
	Local $pw2 = ""

		while 1

			While $pw1 = ""
				$pw1 = InputBox("Configure Password", "Set your administrative password:", "", "*")
				If $pw1 = "" Then
					MsgBox(4096 + 16, "Error", "Password has NOT been changed!")
					Return
				EndIf
			WEnd


			While $pw2 = ""
				$pw2 = InputBox("Confirm Password", "Confirm your administrative password:", "", "*")
				If $pw2 = "" Then
					MsgBox(4096 + 16, "Error", "Password has NOT been changed!")
					Return
				EndIf
			WEnd

			If $pw1 <> $pw2 Then
				MsgBox(4096 + 16, "Error", "Passwords do not match!")
			Else
				MsgBox(4096 + 48, "Success", "Your password has been changed!")
				IniWrite($Settings, encode_text("settings"), encode_text("password"), encode_text($pw1))
				;$pass = $pw1
				ExitLoop
			EndIf
		WEnd
EndFunc

; WM_NOTIFY event handler
Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
    #forceref $hWndGUI, $MsgID, $wParam
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam) ;NMHDR (hwndFrom, idFrom, code)
    If @error Then Return
    $event = DllStructGetData($tagNMHDR, 3)
    Select
        Case $wParam = $TV_USERS
            Select
                ;Case $event = $NM_CLICK
                    ; Single Click (not used right now)
				Case $event = $NM_DBLCLK
                    PopulateGUI()
            EndSelect
    EndSelect
    $tagNMHDR = 0
    $event = 0
    $lParam = 0
EndFunc   ;==>WM_Notify_Events

; decodes encrypted text
Func decode_text($s_string)
	Local $s_return = ""
	Local $s_len
	Local $i

	$s_len = StringLen($s_string)

	For $i = 1 to $s_len Step 2
		$s_return = $s_return & Chr(Dec(StringMid($s_string, $i, 2))-$txtencodebase)
	Next

	Return $s_return
EndFunc

; encodes encrypted text
Func encode_text($s_string)
	Local $s_return = ""
	Local $s_len
	Local $i

	$s_len = StringLen($s_string)

	For $i = 1 to $s_len
		$s_return = $s_return & Hex(Asc(StringMid($s_string, $i, 1))+$txtencodebase,2)
	Next

	Return $s_return

EndFunc
