#include-once
#region Global Variables and Constants
Global $_MSNErrorNotify = True

Global Enum _; Error Status Types
		$_MSNStatus_Success = 0, _
		$_MSNStatus_GeneralError, _
		$_MSNStatus_COM_Error, _
		$_MSNStatus_InvalidValue, _
		$_MSNStatus_InvalidDataType, _
		$_MSNStatus_SigninError, _
		$_MSNStatus_InvalidMSNObject, _
		$_MSNStatus_SetStatusError, _
		$_MSNStatus_NotInList

;MSN Status codes
Global Const $MSN_STATUS_OFFLINE = 0x0001
Global Const $MSN_STATUS_ONLINE = 0x0002
Global Const $MSN_STATUS_INVISIBLE = 0x0006
Global Const $MSN_STATUS_BUSY = 0x000A
Global Const $MSN_STATUS_BE_RIGHT_BACK = 0x000E
Global Const $MSN_STATUS_IDLE = 0x0012
Global Const $MSN_STATUS_AWAY = 0x0022
Global Const $MSN_STATUS_ON_THE_PHONE = 0x0032
Global Const $MSN_STATUS_OUT_TO_LUNCH = 0x0042
Global Const $MSN_STATUS_LOCAL_FINDING_SERVER = 0x0100
Global Const $MSN_STATUS_LOCAL_CONNECTING_TO_SERVER = 0x0200
Global Const $MSN_STATUS_LOCAL_SYNCHRONIZING_WITH_SERVER = 0x0300
Global Const $MSN_STATUS_LOCAL_DISCONNECTING_FROM_SERVER = 0x0400

#endregion

#region Core Functions
;===============================================================================
;
; Function Name:    _MSNCreate()
; Description:      Create an MSN Messenger object and a Messenger Window object
; Parameter(s):     $f_visible 		- Optional: specifies whether the browser window will be visible
;										0 = Messenger Window is hidden
;										1 = (Default) Messenger Window is visible
;					$f_takeFocus	- Optional: specifies whether to bring the attached window to focus
;										0 =  Do Not Bring window into focus
;										1 = (Default) bring window into focus
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns an object variable pointing to an MSN Messenger object
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNCreate($f_visible = 1, $f_takeFocus = 1)
	Local $o_MSN = ObjCreate("Messenger.UIAutomation.1")
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNCreate", "", "Messenger object creation failed")
		SetError($_MSNStatus_GeneralError)
		Return 0
	EndIf
	If $f_visible = 0 Then $f_takeFocus = 0
	If $f_visible = 1 Then
		Local $o_Window = $o_MSN.Window
		If Not IsObj($o_Window) Then
			__MSNErrorNotify("Error", "_MSNCreate", "", "Messenger window object creation failed")
			SetError($_MSNStatus_GeneralError)
			Return 0
		EndIf
		$o_Window.show
	EndIf
	If $f_takeFocus = 1 Then WinActivate(HWnd($o_Window.HWND))
	Return $o_MSN
EndFunc   ;==>_MSNCreate

;===============================================================================
;
; Function Name:    _MSNSignIn()
; Description:      Signs a user in to MSN
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$sUser 		- User name of the account to be signed in (include @)
;					$sPass		- Password associated with the user name
;
;					**NOTE** --> If no user name or password are provided, an auto-login will
;								be attempted
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 6 ($_MSNStatus_SigninError) = Signin Error
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNSignIn(ByRef $o_MSN, $sUser = "", $sPass = "")
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNSignIn", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	If $sUser <> "" And $sPass <> "" Then
		Local $return = $o_MSN.Signin(0, $sUser, $sPass);behavior of this method varies depending on MSN version, OS, service
	ElseIf $sUser = "" And $sPass = "" Then
		Local $return = $o_MSN.AutoSignin()
	Else
		__MSNErrorNotify("Error", "_MSNSignin", "", "Invalid username or password")
		SetError($_MSNStatus_InvalidValue)
		Return 0
	EndIf
	Switch $return
		Case "S_OK"
			SetError($_MSNStatus_Success)
			Return -1
		Case "S_FALSE"
			__MSNErrorNotify("Error", "_MSNSignin", "", "Signin Error")
			SetError($_MSNStatus_SigninError)
			Return 0
		Case Else
			__MSNErrorNotify("Error", "_MSNSignin", "", "General signin error")
			SetError($_MSNStatus_GeneralError)
			Return 0
	EndSwitch
EndFunc   ;==>_MSNSignIn

;===============================================================================
;
; Function Name:    _MSNSignout()
; Description:      Signs a user in to MSN
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNSignout(ByRef $o_MSN)
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNSignout", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $return = $o_MSN.Signout
	Switch $return
		Case "S_OK"
			SetError($_MSNStatus_Success)
			Return -1
		Case Else
			__MSNErrorNotify("Error", "_MSNSignout", "", "General Signout error")
			SetError($_MSNStatus_GeneralError)
			Return 0
	EndSwitch
EndFunc   ;==>_MSNSignout

;===============================================================================
;
; Function Name:    _MSNClose()
; Description:      Signs a user in to MSN
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNClose(ByRef $o_MSN)
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNClose", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $o_Window = $o_MSN.Window
	If Not IsObj($o_Window) Then
		__MSNErrorNotify("Error", "_MSNCreate", "", "Messenger window object creation failed")
		SetError($_MSNStatus_GeneralError)
		Return 0
	EndIf
	Local $return = $o_Window.Close
	SetError($_MSNStatus_Success)
	Return -1
EndFunc   ;==>_MSNClose

;===============================================================================
;
; Function Name:    _MSNContactAdd()
; Description:      Add a user to your contacts group
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$sUserAdd	- User name of the account to be added (include @)
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNContactAdd($o_MSN, $sUserAdd = "")
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNSignIn", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $return = $o_MSN.AddContact(0, $sUserAdd)
	Switch $return
		Case "S_OK"
			SetError($_MSNStatus_Success)
			Return -1
		Case Else
			__MSNErrorNotify("Error", "_MSNContactAdd", "", "Contact add error")
			SetError($_MSNStatus_GeneralError)
			Return 0
	EndSwitch
EndFunc   ;==>_MSNContactAdd

;===============================================================================
;
; Function Name:    _MSNSetStatus()
; Description:      Sets the current users status
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$sStatus	- status to be changed to
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 4 ($_MSNStatus_InvalidValue) = Invalid Value
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
;								- 8 ($_MSNStatus_SetStatusError) = Set Status Error
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNSetStatus($o_MSN, $sStatus)
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNSetStatus", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	$sStatus = String($sStatus)
	Switch $sStatus
		Case "appear offline"
			$status_Set = $MSN_STATUS_INVISIBLE
		Case "offline"
			$status_Set = $MSN_STATUS_INVISIBLE
		Case "invisible"
			$status_Set = $MSN_STATUS_INVISIBLE
		Case "online"
			$status_Set = $MSN_STATUS_ONLINE
		Case "busy"
			$status_Set = $MSN_STATUS_BUSY
		Case "be right back"
			$status_Set = $MSN_STATUS_BE_RIGHT_BACK
		Case "brb"
			$status_Set = $MSN_STATUS_BE_RIGHT_BACK
		Case "idle"
			$status_Set = $MSN_STATUS_IDLE
		Case "away"
			$status_Set = $MSN_STATUS_AWAY
		Case "on the phone"
			$status_Set = $MSN_STATUS_ON_THE_PHONE
		Case "phone"
			$status_Set = $MSN_STATUS_ON_THE_PHONE
		Case "out to lunch"
			$status_Set = $MSN_STATUS_OUT_TO_LUNCH
		Case "lunch"
			$status_Set = $MSN_STATUS_OUT_TO_LUNCH
		Case Else
			__MSNErrorNotify("Error", "_MSNSetStatus", "$_MSNStatus_InvalidValue")
			SetError($_MSNStatus_InvalidValue)
			Return 0
	EndSwitch
	$o_MSN.MyStatus = $status_Set
	Local $status_Current = $o_MSN.MyStatus
	If $status_Current <> $status_Set Then
		__MSNErrorNotify("Error", "_MSNSetStatus", "$_MSNStatus_SetStatusError")
		SetError($_MSNStatus_SetStatusError)
		Return 0
	Else
		SetError($_MSNStatus_Success)
		Return -1
	EndIf
EndFunc   ;==>_MSNSetStatus

;===============================================================================
;
; Function Name:    _MSNGetStatus()
; Description:      Gets a given users status
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$sUser		- Signin name of the user requested
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 4 ($_MSNStatus_InvalidValue) = Invalid Value
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
;								- 9 ($_MSNStatus_NotInList) = Not In Contacts List
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNGetStatus($o_MSN, $sUser)
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNGetStatus", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $in_list = _MSNContactInList($o_MSN, $sUser)
	If $in_list Then
		Local $o_contact = _MSNContactGetByName($o_MSN, $sUser)
		$sStatus = $o_contact.Status
		Switch $sStatus
			Case $MSN_STATUS_INVISIBLE
				$status_Get = "Offline"
			Case $MSN_STATUS_OFFLINE
				$status_Get = "Offline"
			Case $MSN_STATUS_ONLINE
				$status_Get = "Online"
			Case $MSN_STATUS_BUSY
				$status_Get = "Busy"
			Case $MSN_STATUS_BE_RIGHT_BACK
				$status_Get = "Be Right Back"
			Case $MSN_STATUS_IDLE
				$status_Get = "Idle"
			Case $MSN_STATUS_AWAY
				$status_Get = "Away"
			Case $MSN_STATUS_ON_THE_PHONE
				$status_Get = "On The Phone"
			Case $MSN_STATUS_OUT_TO_LUNCH
				$status_Get = "Out To Lunch"
			Case Else
				__MSNErrorNotify("Error", "_MSNGetStatus", "$_MSNStatus_InvalidValue")
				SetError($_MSNStatus_InvalidValue)
				Return 0
		EndSwitch
	Else
		__MSNErrorNotify("Error", "_MSNGetStatus", "$_MSNStatus_NotInList")
		SetError($_MSNStatus_NotInList)
		Return 0
	EndIf
	Return $status_Get
EndFunc   ;==>_MSNGetStatus

;===============================================================================
;
; Function Name:    _MSNContactGetCollection()
; Description:      Gets a collection of the contacts in the users list
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$i_index	- Optional: specifies whether to return a collection or indexed instance
;										0 or positive integer returns an indexed instance
;										-1 = (Default) returns a collection
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns a collection object representing the contact list
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 4 ($_MSNStatus_InvalidValue) = Invalid Value
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
;					@EXTENDED	- contains the number of contacts in the users list
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNContactGetCollection($o_MSN, $i_index = -1)
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNContactGetCollection", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	$i_index = Number($i_index)
	Select
		Case $i_index = -1
			SetError($_MSNStatus_Success)
			SetExtended($o_MSN.MyContacts.Count)
			Return $o_MSN.MyContacts
		Case $i_index > -1 And $i_index < $o_MSN.MyContacts.Count
			SetError($_MSNStatus_Success)
			SetExtended($o_MSN.MyContacts.Count)
			Return $o_MSN.MyContacts.Item($i_index)
		Case $i_index < -1
			__MSNErrorNotify("Error", "_MSNContactGetCollection", "$_MSNStatus_InvalidValue", "$i_index < -1")
			SetError($_MSNStatus_InvalidValue)
			Return 0
		Case Else
			__MSNErrorNotify("Error", "_MSNContactGetCollection", "$_MSNStatus_GeneralError")
			SetError($_MSNStatus_InvalidValue)
			Return 0
	EndSelect
EndFunc   ;==>_MSNContactGetCollection

;===============================================================================
;
; Function Name:    _MSNContactGetByName()
; Description:      Gets a contact by name
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$s_mode		- Optional: specifies search mode
;									signin = (Default) match the signin name of the user
;									friendly = match the friendly name of the user
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns a contact object representing the user
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 4 ($_MSNStatus_InvalidValue) = Invalid Value
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
;					@EXTENDED	- contains the number of contacts in the users list
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNContactGetByName($o_MSN, $sUser, $s_mode = "signin")
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNContactGetCollection", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $in_list = _MSNContactInList($o_MSN, $sUser, $s_mode)
	If $in_list Then
		Switch $s_mode
			Case "signin"
				SetError($_MSNStatus_Success)
				Return $o_MSN.GetContact($sUser, "")
			Case "friendly"
				Local $o_Contacts = _MSNContactGetCollection($o_MSN)
				Local $i = 0
				For $o_Contact In $o_Contacts
					Local $friendly_Name = $o_Contact.FriendlyName
					If $friendly_Name = $sUser Then
						$signin_Name = $o_Contact.SigninName
						ExitLoop
					EndIf
				Next
				SetError($_MSNStatus_Success)
				Return $o_MSN.GetContact($signin_Name, "")
			Case Else
				__MSNErrorNotify("Error", "_MSNContactGetByName", "$_MSNStatus_InvalidValue")
		SetError($_MSNStatus_InvalidValue)
		Return 0
		EndSwitch
		Else
		__MSNErrorNotify("Error", "_MSNContactGetByName", "$_MSNStatus_NotInList")
		SetError($_MSNStatus_NotInList)
		Return 0
	EndIf
EndFunc   ;==>_MSNContactGetByName

;===============================================================================
;
; Function Name:    _MSNContactInList()
; Description:      Checks to see if a contact is in the contact list
; Parameter(s):     $o_MSN		- Object variable of an MSN Messenger application
;					$sUser		- Signin name of the user to be match the attribute specified in $s_mode
;					$s_mode		- Optional: specifies search mode
;									signin = (Default) match the signin name of the user
;									friendly = match the friendly name of the user
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success	- Returns True
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_MSNStatus_Success) = No Error
;								- 1 ($_MSNStatus_GeneralError) = General Error
;								- 4 ($_MSNStatus_InvalidValue) = Invalid Value
;								- 7 ($_MSNStatus_InvalidMSNObject) = Invalid MSN Object
;								- 9 ($_MSNStatus_NotInList) = Not In Contacts List
;					@EXTENDED	- contains the number of contacts in the users list
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNContactInList($o_MSN, $sUser, $s_mode = "signin")
	If Not IsObj($o_MSN) Then
		__MSNErrorNotify("Error", "_MSNContactInList", "$_MSNStatus_InvalidMSNObject")
		SetError($_MSNStatus_InvalidMSNObject)
		Return 0
	EndIf
	Local $bool = False
	Local $o_Contacts = _MSNContactGetCollection($o_MSN)
	If Not IsObj($o_Contacts) Then
		__MSNErrorNotify("Error", "_MSNContactInList", "$_MSNStatus_GeneralError")
		SetError($_MSNStatus_GeneralError)
		Return 0
	EndIf
	For $o_Contact In $o_Contacts
		Switch $s_mode
			Case "signin"
				If $o_Contact.SigninName = $sUser Then
					$bool = True
					ExitLoop
				EndIf
			Case "friendly"
				If $o_Contact.FriendlyName = $sUser Then
					$bool = True
					ExitLoop
				EndIf
			Case Else
				__MSNErrorNotify("Error", "_MSNContactInList", "$_MSNStatus_InvalidValue")
				SetError($_MSNStatus_InvalidValue)
				Return 0
		EndSwitch
	Next
	If $bool Then
		SetError($_MSNStatus_Success)
		SetExtended($o_Contacts.count)
		Return $bool
	Else
		__MSNErrorNotify("Error", "_MSNContactInList", "$_MSNStatus_NotInList")
		SetError($_MSNStatus_NotInList)
		Return 0
	EndIf
EndFunc   ;==>_MSNContactInList

;===============================================================================
;
; Function Name:   _MSNErrorNotifyToggle()
; Description:		Specifies whether MSN.au3 automatically notifies the console of warnings and errors
; Parameter(s):		$f_notify	- Optional: specifies whether notification should be on or off
;								- -1 = (Default) return current setting
;								- True = Turn On
;								- False = Turn Off
; Requirement(s):   AutoIt3 V3.2 or higher
; Return Value(s):  On Success 	- If $f_notify = -1, returns the current notification setting, else returns 1
;                   On Failure	- Returns 0
; Author(s):        Radagast
;
;===============================================================================
;
Func _MSNErrorNotifyToggle($f_notify = -1)
	Switch Number($f_notify)
		Case (-1)
			Return $_MSNErrorNotify
		Case 0
			$_MSNErrorNotify = False
			Return 1
		Case 1
			$_MSNErrorNotify = True
			Return 1
		Case Else
			__MSNErrorNotify("Error", "_MSNErrorNotify", "$_MSNStatus_InvalidValue")
			Return 0
	EndSwitch
EndFunc   ;==>_MSNErrorNotifyToggle












#endregion

#region Internal Functions


Func __MSNErrorNotify($s_severity, $s_func, $s_status = "", $s_message = "")
	Local $sStr = "--> MSN.au3 " & $s_severity & " from function " & $s_func
	If Not String($s_status) = "" Then $sStr &= ", " & $s_status
	If Not String($s_message) = "" Then $sStr &= " (" & $s_message & ")"
	If $_MSNErrorNotify Then ConsoleWrite($sStr & @CR)
	Return 1
EndFunc   ;==>__MSNErrorNotify
#endregion