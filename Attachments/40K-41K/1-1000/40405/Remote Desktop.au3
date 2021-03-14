;	WTSSendMessage Function
;	Displays a message box on the client desktop of a specified Remote Desktop Services session.
;	See MSDN information on WTSSendMessage:
;	http://msdn.microsoft.com/en-us/library/windows/desktop/aa383842(v=vs.85).aspx

Global Const $WTS_CURRENT_SERVER_HANDLE = 0			; "#define WTS_CURRENT_SERVER_HANDLE  ((HANDLE)NULL)"

; ====================== $Style Values (for message) ======================
Global Const $MB_OK = 0x00000000					; Has button: OK
Global Const $MB_OKCANCEL = 0x00000001				; Has buttons: OK and Cancel
Global Const $MB_RETRYCANCEL = 0x00000005			; Has buttons: Retry and Cancel
Global Const $MB_YESNO = 0x00000004					; Has buttons: Yes and No
Global Const $MB_YESNOCANCEL = 0x00000003			; Has buttons: Yes, No, and Cancel
Global Const $MB_ABORTRETRYIGNORE = 0x00000002		; Has buttons: Abort, Retry, and Ignore
Global Const $MB_CANCELTRYCONTINUE = 0x00000006		; Has buttons: Cancel, Try Again, Continue
Global Const $MB_HELP = 0x00004000					; Adds a Help button to the message box (sends WM_HELP to owner)
Global Const $MB_ICONEXCLAMATION = 0x00000030		; Icon: Exclamation point
Global Const $MB_ICONWARNING = 0x00000030			; Icon: Exclamation point
Global Const $MB_ICONINFORMATION = 0x00000040		; Icon: Blue circled i
Global Const $MB_ICONASTERISK = 0x00000040			; Icon: Blue circled i
Global Const $MB_ICONQUESTION = 0x00000020			; Icon: Question-mark (no longer recommended for use)
Global Const $MB_ICONSTOP = 0x00000010				; Icon: Stop sign
Global Const $MB_ICONERROR = 0x00000010				; Icon: Stop sign
Global Const $MB_ICONHAND = 0x00000010				; Icon: Stop sign
Global Const $MB_DEFBUTTON1 = 0x00000000			; (default) 1st button is Default
Global Const $MB_DEFBUTTON2 = 0x00000100			; 2nd button is Default
Global Const $MB_DEFBUTTON3 = 0x00000200			; 3rd button is Default
Global Const $MB_DEFBUTTON4 = 0x00000300			; 4th button is Default
Global Const $MB_APPLMODAL = 0x00000000				; (default) application-modal
Global Const $MB_SYSTEMMODAL = 0x00001000			; Sets WS_EX_TOPMOST (blocks all application GUI's until responded to)
Global Const $MB_TASKMODAL = 0x00002000				; Like $MB_APPLMODAL, but used when hwnd is NULL (irrelevant for WTSSendMessage?)
Global Const $MB_DEFAULT_DESKTOP_ONLY = 0x00020000	; "If the current input desktop is not the default desktop, MessageBox does not return until the user switches to the default desktop."
Global Const $MB_RIGHT = 0x00080000					; Right-justify message
Global Const $MB_RTLREADING = 0x00100000			; Used to set right-to-left reading order (Hebrew & Arabic systems)
Global Const $MB_SETFOREGROUND = 0x00010000			; Sets the message box as the foreground window
Global Const $MB_TOPMOST = 0x00040000				; Creates the message box with WS_EX_TOPMOST style
Global Const $MB_SERVICE_NOTIFICATION = 0x00200000	; Indicates that _WinAPI_WTSSendMessage is being called from a system service (hwnd must be NULL)
; ====================== // $Style Values ======================


; ====================== $pResponse Values (User clicked...) ======================
Global Const $IDABORT = 3			; Abort button
Global Const $IDCANCEL = 2			; Cancel button
Global Const $IDCONTINUE = 11		; Continue button
Global Const $IDIGNORE = 5			; Ignore button
Global Const $IDNO = 7				; No button
Global Const $IDOK = 1				; OK button
Global Const $IDRETRY = 4			; Retry button
Global Const $IDTRYAGAIN = 10		; Try Again button
Global Const $IDYES = 6				; Yes button
Global Const $IDASYNC = 0x7D01		; Nothing - $bWait was False so the function returned right away
Global Const $IDTIMEOUT = 0x7D00	; Nothing - $bWait was True and the user did nothing
; ====================== // $pResponse Values ======================


; Displays a message box on the client desktop of a specified Remote Desktop Services session.
Func _WinAPI_WTSSendMessage( $hServer, $SessionId, $pTitle, $pMessage, $Style, $Timeout, ByRef $pResponse, $bWait = True )
	Local $aResult = DllCall("Wtsapi32.dll", "BOOL", "WTSSendMessage", _
	"handle", $hServer, _				; Handle to RD Session Host server (from WTSOpenServer) or $WTS_CURRENT_SERVER_HANDLE ("RD Session Host server on which your application is running")
	"DWORD", $SessionId, _				; Remote Desktop Services session identifier. Can be WTS_CURRENT_SESSION.
	"str*", $pTitle, _					; Title for message box
	"DWORD", StringLen($pTitle), _		; Title length
	"str*", $pMessage, _				; Message for message box
	"DWORD", StringLen($pMessage), _	; Message length
	"DWORD", $Style, _					; Style for the message box, similar to AutoIt's MsgBox styles (see above)
	"DWORD", $Timeout, _				; Time in seconds until timeout occurs.  0 = wait for user.
	"DWORD*", $pResponse, _				; This variable will contain the user's response (see above)
	"BOOL", $bWait)						; True = Wait for user (blocking function)
										; False = Asynchronous use? ($pResponse = IDASYNC)
    Return $aResult		; 0 = Failure, Non-zero = Success
EndFunc

; Opens a handle to a Remote Desktop Server
Func _WinAPI_WTSOpenServer( $pServerName )
	Local $aResult = DllCall("Wtsapi32.dll", "handle", "WTSOpenServer", _
	"str*", $pServerName)				; The NetBIOS name of the RD server
	Return $aResult
			; Seriously, Microsoft??
			; "If the function fails, it returns a handle that is not valid.
			; You can test the validity of the handle by using it in another function call."
EndFunc

; Closes a handle to a Remote Desktop Server
Func _WinAPI_WTSCloseServer( $hServer )
	DllCall("Wtsapi32.dll", "none", "WTSCloseServer", _
	"handle", $hServer)				; The handle returned by _WinAPI_WTSOpenServer
	; This function has no return value
EndFunc

; List the Session ID's
Func _WinAPI_WTSEnumerateSessions( $hServer, $ppSessionInfo, ByRef $pCount)
	DllCall("Wtsapi32.dll", "BOOL", "WTSEnumerateSessions", _
		"handle", $hServer, _		; Handle to RD hose as returned by _WinAPI_WTSOpenServer
		"DWORD", 0, _				; Reserved.  Always 0.
		"DWORD", 1, _				; Enumeration version.  Always 1.
		"ptr*", $ppSessionInfo, _	; A point to a pointer to an array.  Good job, MS.  Contains WTS_SESSION_INFO structures.
		"DWORD*", $pCount)			; The number of $ppSessionInfo structures returned
	Return 0 ; *** hehe!
EndFunc

; ============== TEST ==============

Func _WinAPI_GetComputerName()
	Local $lpBuffer, $lpnSize = 32
	$aResult = DllCall("Kernel32.dll", "BOOL", "GetComputerName", _
		"str*", $lpBuffer, _	; This will contain the computer's NetBIOS name
		"DWORD*", $lpnSize)		; On input, MAX_COMPUTERNAME_LENGTH + 1.  On output, StringLen() of $lpBuffer
    ; $aResult ==>  0 = Failure, Non-zero = Success
	Return $lpBuffer
EndFunc


;ConsoleWrite("Contacting RD Server..." & @LF)
;Dim $hRD = _WinAPI_WTSOpenServer("AwesomePC")
;ConsoleWrite('>>' & $hRD & '<<' & @LF)
;_WinAPI_WTSCloseServer($hRD)
;ConsoleWrite("Finished test." & @LF)

ConsoleWrite(_WinAPI_GetComputerName() & @LF)
