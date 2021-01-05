; A GUI Ping
; Stephan Nicholls - 07/02/2005

;*********************************************************************
; Options
;*********************************************************************
Opt("MustDeclareVars", 1)		; Require that variables are declared (Dim) before use
Opt("TrayMenuMode",1)			; No pause or exit item
TraySetClick(16)				; only right (secondary) click will show the tray menu

;*********************************************************************
; Constants
;*********************************************************************
#include <GuiConstants.au3>

Const $DEFAULT_IP			= "127.0.0.1"				; Default IP for pinging
Const $DEFAULT_URL			= "www.autoitscript.com"	; Default URL for pinging
Const $RECHECK_TIME			= 10						; Default time between pings (in seconds)
Const $TIMEOUT				= 10						; Default timeout on ping (in seconds)
Const $IP_ADDRESS			= 1
Const $URL					= 2
Const $PING_OK				= 1
Const $PING_ERROR			= 2
Const $PING_UNKNOWN			= 3

; Tray constants
Const $TRAY_EVENT_PRIMARYDOUBLE	=	-13

; Icons in shell32
Const $PING_OK_ICON			= 13				; Icon to show when ping was successful
Const $PING_NOREPLY_ICON	= 131				; Icon to show when no reply to ping
Const $PING_DONTKNOW_ICON	= 23				; Icon to show when ping in progress

; About this program - used in about box & registry preferences
Const $SOFTWARE_NAME			=	"StephSoft"
Const $PROGRAM_NAME				=	"Ping It"
Const $PROGRAM_VERSION			=	"2.2"
Const $MY_EMAIL_ADDRESS			=	"pingit@stephan.org.uk"
Const $MY_WEB_ADDRESS			=	"                         "
Const $AUTOIT_WEB_ADDRESS		=	"http://www.autoitscript.com"

; Registry details for storing preferences
Const $REG_TREE					=	"HKEY_CURRENT_USER\Software\" & $SOFTWARE_NAME & "\" & $PROGRAM_NAME
Const $PREF_REG_TREE			=	$REG_TREE & "\" & "Settings"
Const $PREF_TIMEOUT_TREE		=	"Timeout"
Const $PREF_INTERVAL_TREE		=	"Interval"
Const $PREF_URL_TREE			=	"URL"
Const $PREF_IP_TREE				=	"IP"
Const $PREF_ADDRESS_TYPE_TREE	=	"AddressType"
Const $PREF_NOTIFY_CHANGE_TREE	=	"Notify"
Const $PREF_START_MIN_TREE		=	"StartMin"

;*********************************************************************
; Variables
;*********************************************************************

; GUI variables: ed = edit box, lb = label, ud = updown, bt = button
Global $gui_Main

Global $ed_main_Response

; GUI items for changing time between pings and timeout
Global $lb_main_Interval, $ip_main_Interval, $ud_main_Interval, $lb_main_Timeout, $ip_main_Timeout
Global $ck_main_StartMin, $ud_main_Timeout, $ck_main_Notify

; GUI items for changing URL
Global $bt_main_SetAsDefault, $bt_main_RestoreDefault, $lb_main_URL, $ip_main_URL, $bt_main_UseURL

; GUI items for changing IP
Global $lb_main_IP, $ip_main_IP1, $ip_main_IP2, $ip_main_IP3, $ip_main_IP4, $bt_main_UseIP

; GUI items for status icon, progress bar (counts down to next ping), finished button
Global $ic_main_Status, $pr_main_Progress, $bt_main_Hide, $bt_main_Exit

; Tray items
Global $mn_tray_Exit, $mn_tray_show

Dim $using													; What am I currently using $IP_ADDRESS or $URL
Dim $msg, $reply, $cnt, $address, $message, $interval
Dim $error_return[5]										; To store error codes from ping
Dim $traymsg
Dim $lastStatus	= $PING_UNKNOWN								; Last status of ping

; Set up error codes
$error_return[0] = "unknown error"
$error_return[1] = "host offline"
$error_return[2] = "host unreachable"
$error_return[3] = "bad destination"
$error_return[4] = "other error"

CreateGui()
ReadPrefs()
If GUICtrlRead($ck_main_StartMin) = $GUI_UNCHECKED Then
	GuiSetState(@SW_SHOW, $gui_main)
Endif
Do
		GUICtrlSetImage($ic_main_Status, "shell32.dll", $PING_DONTKNOW_ICON)	; In the process of 'pinging' icon
		TraySetIcon("shell32.dll", $PING_DONTKNOW_ICON)
		GUISetCursor(15, 1, $gui_main)	; Wait
		GUICtrlSetData($ed_main_Response, @HOUR & ":" & @MIN & ":" & @SEC & ": Pinging " & $address, 1)	; Timestamp and say we're pinging
		$reply = Ping($address, GUICtrlRead($ip_main_Timeout) * 1000)			; Ping with current timeout as set in GUI
		GUISetCursor()
		If $reply = 0 Then
			; An error of some sort
			$message = "No reply: " & $error_return[@error]
			GUICtrlSetImage($ic_main_Status, "shell32.dll", $PING_NOREPLY_ICON)
			TraySetIcon("shell32.dll", $PING_NOREPLY_ICON)
			if $lastStatus <> $PING_ERROR  And GUICtrlRead($ck_main_Notify) = $GUI_CHECKED Then
				TrayTip($PROGRAM_NAME, "Pinged " & $address & " unsuccessfully", 10, 3)
			EndIf
			$lastStatus = $PING_ERROR
		Else
			; Ping successful
			$message = "Reply received in " & $reply & " milliseconds"
			GUICtrlSetImage($ic_main_Status, "shell32.dll", $PING_OK_ICON)
			TraySetIcon("shell32.dll", $PING_OK_ICON)
			if $lastStatus <> $PING_OK And GUICtrlRead($ck_main_Notify) = $GUI_CHECKED Then
				TrayTip($PROGRAM_NAME, "Pinged " & $address & " successfully", 10, 1)
			EndIf
			$lastStatus = $PING_OK			
		EndIf
		GUICtrlSetData($ed_main_Response, " - " & $message & @CRLF, 1)
		; Now wait
		$interval = GUICtrlRead($ip_main_Interval)
		For $cnt = 1 To $interval * 20
			Sleep(50)
			$msg = GUIGetMsg()
			$traymsg = TrayGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE Or $msg = $bt_main_Exit Or $traymsg = $mn_tray_Exit
					ExitLoop
				Case $msg = $bt_main_RestoreDefault
					ReadPrefs()
					ExitLoop
				Case $msg = $bt_main_Hide
					GUISetState(@SW_HIDE, $gui_main)
				Case $msg = $bt_main_UseURL
					$address = GUICtrlRead($ip_main_URL)
					$using = $URL
					UpdateToolTip($address)
					ExitLoop	; Do it now!
				Case $msg = $bt_main_UseIP
					$address = GUICtrlRead($ip_main_IP1) & "." & GUICtrlRead($ip_main_IP2) & "." & GUICtrlRead($ip_main_IP3) & "." &GUICtrlRead($ip_main_IP4)
					$using = $IP_ADDRESS
					UpdateToolTip($address)
					ExitLoop	; Do it now!
				Case $msg = $bt_main_SetAsDefault
					SavePrefs()
				Case $traymsg = $TRAY_EVENT_PRIMARYDOUBLE or $traymsg = $mn_tray_Show
					GUISetState(@SW_SHOW, $gui_main)
			EndSelect
			GUICtrlSetData($pr_main_Progress, $cnt * (100 / (20 * $interval)))
		Next
		; Fill progress bar just for neatness
		GUICtrlSetData($pr_main_Progress, 100)
Until $msg = $GUI_EVENT_CLOSE Or $msg=$bt_main_Exit Or $traymsg = $mn_tray_Exit
Exit

;*********************************************************************
; Save preferences
;*********************************************************************
Func SavePrefs()
	; Timeout
	RegWrite($PREF_REG_TREE, $PREF_TIMEOUT_TREE, "REG_DWORD", GUICtrlRead($ip_main_Timeout))
	
	; Interval
	RegWrite($PREF_REG_TREE, $PREF_INTERVAL_TREE, "REG_DWORD", GUICtrlRead($ip_main_Interval))
	
	; Notify
	RegWrite($PREF_REG_TREE, $PREF_NOTIFY_CHANGE_TREE, "REG_DWORD", GUICtrlRead($ck_main_Notify))

	; Minimise on startup
	RegWrite($PREF_REG_TREE, $PREF_START_MIN_TREE, "REG_DWORD", GUICtrlRead($ck_main_StartMin))
	
	; Address
	RegWrite($PREF_REG_TREE, $PREF_IP_TREE, "REG_SZ", GUICtrlRead($ip_main_IP1) & "." & GUICtrlRead($ip_main_IP2) & "." & GUICtrlRead($ip_main_IP3) & "." &GUICtrlRead($ip_main_IP4))
	RegWrite($PREF_REG_TREE, $PREF_URL_TREE, "REG_SZ", GUICtrlRead($ip_main_URL))
	RegWrite($PREF_REG_TREE, $PREF_ADDRESS_TYPE_TREE, "REG_DWORD", $using)
EndFunc

;*********************************************************************
; Read preferences from registry
;*********************************************************************
Func ReadPrefs()
	Dim $temp, $bits[5], $temp_URL, $temp_IP
	; Timeout
	$temp = RegRead($PREF_REG_TREE, $PREF_TIMEOUT_TREE)
	if $temp = "" then
		RegWrite($PREF_REG_TREE, $PREF_TIMEOUT_TREE, "REG_DWORD", $TIMEOUT)
		GUICtrlSetData($ip_main_Timeout, $TIMEOUT)
	Else
		GUICtrlSetData($ip_main_Timeout, $temp)
	endIf
	
	; Interval
	$temp = RegRead($PREF_REG_TREE, $PREF_INTERVAL_TREE)
	if $temp = "" then
		RegWrite($PREF_REG_TREE, $PREF_INTERVAL_TREE, "REG_DWORD", $RECHECK_TIME)
		GUICtrlSetData($ip_main_Interval, $RECHECK_TIME)
	Else
		GUICtrlSetData($ip_main_Interval, $temp)
	endIf
	
	; Notify
	$temp = RegRead($PREF_REG_TREE, $PREF_NOTIFY_CHANGE_TREE)
	if $temp = "" Then
		RegWrite($PREF_REG_TREE, $PREF_NOTIFY_CHANGE_TREE, "REG_DWORD", $GUI_CHECKED)
	EndIf
	GUICtrlSetState($ck_main_Notify, RegRead($PREF_REG_TREE, $PREF_NOTIFY_CHANGE_TREE))
	
	; Start minimised
	$temp = RegRead($PREF_REG_TREE, $PREF_START_MIN_TREE)
	if $temp = "" Then
		RegWrite($PREF_REG_TREE, $PREF_START_MIN_TREE, "REG_DWORD", $GUI_UNCHECKED)
	EndIf
	GUICtrlSetState($ck_main_StartMin, RegRead($PREF_REG_TREE, $PREF_START_MIN_TREE))

	; Address
	$using = RegRead($PREF_REG_TREE, $PREF_ADDRESS_TYPE_TREE)
	If $using = "" Then
		RegWrite($PREF_REG_TREE, $PREF_ADDRESS_TYPE_TREE, "REG_DWORD", $IP_ADDRESS)		; Start is with default IP address
		RegWrite($PREF_REG_TREE, $PREF_URL_TREE, "REG_SZ", $DEFAULT_URL)
		RegWrite($PREF_REG_TREE, $PREF_IP_TREE, "REG_SZ", $DEFAULT_IP)
		$using = $IP_ADDRESS
	EndIf
	$temp_URL = RegRead($PREF_REG_TREE, $PREF_URL_TREE)
	$temp_IP = RegRead($PREF_REG_TREE, $PREF_IP_TREE)
	$bits=StringSplit($temp_IP,".")
	GUICtrlSetData($ip_main_IP1, $bits[1])
	GUICtrlSetData($ip_main_IP2, $bits[2])
	GUICtrlSetData($ip_main_IP3, $bits[3])
	GUICtrlSetData($ip_main_IP4, $bits[4])
	GUICtrlSetData($ip_main_URL, $temp_URL)
	if $using = $IP_ADDRESS Then
		$address = $temp_IP
	Else
		$address = $temp_URL
	EndIf
	UpdateToolTip($address)
EndFunc

;*********************************************************************
; Create the GUI
;*********************************************************************
Func CreateGui()
	$gui_Main				= GuiCreate("Ping It", 405, 280, -1, -1, $WS_EX_DLGMODALFRAME )
	$ed_main_Response		= GuiCtrlCreateEdit("", 10, 10, 380, 96, $ES_READONLY + $ES_AUTOVSCROLL)
	$lb_main_Interval		= GUICtrlCreateLabel("Secs between pings:", 10, 123)
	$ip_main_Interval		= GUICtrlCreateInput("", 115, 120, 50, 20, $ES_NUMBER)
	$ud_main_Interval		= GUICtrlCreateUpdown($ip_main_Interval)
	$lb_main_Timeout		= GUICtrlCreateLabel("Timeout:",180,123)
	$ip_main_Timeout		= GUICtrlCreateInput("", 225, 120, 50, 20, $ES_NUMBER)
	$ud_main_Timeout		= GUICtrlCreateUpdown($ip_main_Timeout)
	$ck_main_Notify			= GUICtrlCreateCheckbox("Notify on change", 285, 108)
	$ck_main_StartMin		= GUICtrlCreateCheckbox("Start minimised", 285, 125)
	$bt_main_RestoreDefault	= GUICtrlCreateButton("Restore Default", 280, 145, 110, 20)
	$bt_main_SetAsDefault	= GUICtrlCreateButton("Set As Default", 280, 170, 110, 20)
	$lb_main_URL			= GUICtrlCreateLabel("URL:", 10, 148)
	$ip_main_URL			= GUICtrlCreateInput("", 40, 145, 150, 20)
	$bt_main_UseURL			= GUICtrlCreateButton("Use URL", 200, 145, 75, 20)
	$lb_main_IP				= GUICtrlCreateLabel("IP:", 10, 173)
	$ip_main_IP1			= GUICtrlCreateInput("", 40, 170, 30, 20, $ES_NUMBER)
							  GUICtrlCreateLabel(".", 74, 178, )					; Just a dot in ip address
	$ip_main_IP2			= GUICtrlCreateInput("", 80, 170, 30, 20, $ES_NUMBER)
							  GUICtrlCreateLabel(".", 114, 178, )					; Just a dot in ip address
	$ip_main_IP3			= GUICtrlCreateInput("", 120, 170, 30, 20, $ES_NUMBER)
						      GUICtrlCreateLabel(".", 154, 178, )	 				; Just a dot in ip address
	$ip_main_IP4			= GUICtrlCreateInput("", 160, 170, 30, 20, $ES_NUMBER)
	$bt_main_UseIP			= GUICtrlCreateButton("Use IP", 200, 170, 75, 20)
	$ic_main_Status			= GuiCtrlCreateIcon("shell32.dll", $PING_DONTKNOW_ICON, 25, 203)
	$pr_main_Progress		= GUICtrlCreateProgress (80,195,195,45)
	$bt_main_Hide			= GUICtrlCreateButton("Hide", 280, 195, 110, 20)
	$bt_main_Exit			= GUICtrlCreateButton("Exit", 280, 220, 110, 20)
	
	; Tray bits
	$mn_tray_show			= TrayCreateItem("Show")
							  TrayCreateItem("")
	$mn_tray_Exit			= TrayCreateItem("Exit")
EndFunc

;*********************************************************************
; Update the tool tip
;*********************************************************************
Func UpdateToolTip($NewAddress)
	TraySetToolTip("Pinging: " & $NewAddress)
EndFunc