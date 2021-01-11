#include-once
#region Header
#cs
	Title:   Winamp Automation Library for AutoIt3
	Filename:  Winamp.au3
	Description: A collection of functions for creating, attaching to, reading from and manipulating Winamp
	Author:   Bob Anthony
	Version:  T0.1-0
	Last Update: 9/13/06
	Requirements: AutoIt v3.2.0.1 or higher and ActiveWinamp, Developed/Tested on WindowsXP Pro with Winamp 5.0.0.9
	Notes: Errors associated with incorrect objects will be common user errors.
	
	Update History:
	===================================================
	T0.1-0 9/13/06
	
	Initial Release
	
	New Functions
	_WinampCreate() added
	_WinampQuit() added
	_WinampErrorHandlerRegister() added
	_WinampErrorHandlerDeRegister() added
	_WinampErrorNotify()
	_Winamp_VersionInfo() added
	===================================================
#ce
#endregion
#region Global Variables and Constants
Global Const $WinampAU3VersionInfo[6] = ["T", 0, 1, 5, "20060913", "T0.1-0"]
Global Const $Winamp_LSFW_LOCK = 1, $Winamp_LSFW_UNLOCK = 2
Global $__WinampAU3Debug = False
Global $_WinampErrorNotify = True
Global $oWinampErrorHandler, $sWinampUserErrorHandler
Global _; Com Error Handler Status Strings
		$WinampComErrorNumber, _
		$WinampComErrorNumberHex, _
		$WinampComErrorDescription, _
		$WinampComErrorScriptline, _
		$WinampComErrorWinDescription, _
		$WinampComErrorSource, _
		$WinampComErrorHelpFile, _
		$WinampComErrorHelpContext, _
		$WinampComErrorLastDllError, _
		$WinampComErrorComObj, _
		$WinampComErrorOutput
;
; Enums
;
Global Enum _; Error Status Types
		$_WinampStatus_Success = 0, _
		$_WinampStatus_GeneralError, _
		$_WinampStatus_ComError, _
		$_WinampStatus_InvalidDataType, _
		$_WinampStatus_InvalidObjectType, _
		$_WinampStatus_InvalidValue, _
		$_WinampStatus_ReadOnly, _
		$_WinampStatus_NoMatch
Global Enum Step * 2 _; NotificationLevel
		$_WinampNotifyLevel_None = 0, _
		$_WinampNotifyNotifyLevel_Warning = 1, _
		$_WinampNotifyNotifyLevel_Error, _
		$_WinampNotifyNotifyLevel_ComError
Global Enum Step * 2 _; NotificationMethod
		$_WinampNotifyMethod_Silent = 0, _
		$_WinampNotifyMethod_Console = 1, _
		$_WinampNotifyMethod_ToolTip, _
		$_WinampNotifyMethod_MsgBox
#endregion
#region Core Functions
;===============================================================================
;
; Function Name:    _WinampCreate()
; Description:      Create a Winamp Object
; Parameter(s):     $s_FilePath		- Optional: specifies the file on open upon creation
;					$b_takeFocus	- Optional: specifies whether to bring the attached window to focus
;										0 =  Do Not Bring window into focus
;										1 = (Default) bring window into focus
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success	- Returns an object variable pointing to a ActiveWinamp.Application object
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_WinampStatus_Success) = No Error
;								- 1 ($_WinampStatus_GeneralError) = General Error
;								- 3 ($_WinampStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_WinampStatus_InvalidObjectType) = Invalid Object Type
;					@Extended	- Set to true (1) or false (0) depending on if object already existed
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _WinampCreate($s_FilePath = "", $b_takeFocus = 1)
	Local $o_Result, $o_object, $i_ErrorStatusCode = $_WinampStatus_Success
	
	; Setup internal error handler to Trap COM errors, turn off error notification
	Local $status = __WinampInternalErrorHandlerRegister()
	If Not $status Then __WinampErrorNotify("Warning", "_WinampCreate", _
			"Cannot register internal error handler, cannot trap COM errors", _
			"Use _WinampErrorHandlerRegister() to register a user error handler")
	Local $f_NotifyStatus = _WinampErrorNotify() ; save current error notify status
	_WinampErrorNotify(False)
	
	$o_Result = ObjGet("", "ActiveWinamp.Application")
	If @error = $_WinampStatus_ComError Then
		$i_ErrorStatusCode = $_WinampStatus_NoMatch
	EndIf
	
	; restore error notify and error handler status
	_WinampErrorNotify($f_NotifyStatus) ; restore notification status
	__WinampInternalErrorHandlerDeRegister()
	
	If $i_ErrorStatusCode = $_WinampStatus_Success Then
		If $b_takeFocus Then
			$h_hwnd = HWnd($o_Result.Hwnd)
			If IsHWnd($h_hwnd) Then WinActivate($h_hwnd)
		EndIf
		SetError($_WinampStatus_Success)
		SetExtended(1)
		Return $o_Result
	Else
		$o_object = ObjCreate("ActiveWinamp.Application")
		If Not IsObj($o_object) Then
			__WinampErrorNotify("Error", "_WinampCreate", "", "Winamp Object Creation Failed")
			SetError($_WinampStatus_GeneralError)
			Return 0
		EndIf
	EndIf
	
	If $s_FilePath <> "" Then
		$o_object.LoadItem ($s_FilePath)
	EndIf
	SetError($_WinampStatus_Success)
	Return $o_object
EndFunc   ;==>_WinampCreate

;===============================================================================
;
; Function Name:    _WinampQuit()
; Description:      Close the window and remove the object reference to it
; Parameter(s):     $o_object			- Object variable of a ActiveWinamp.Application
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_WinampStatus_Success) = No Error
;								- 3 ($_WinampStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_WinampStatus_InvalidObjectType) = Invalid Object Type
;					@Extended	- Contains invalid parameter number
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _WinampQuit(ByRef $o_object)
	If Not IsObj($o_object) Then
		__WinampErrorNotify("Error", "_WinampQuit", "$_WinampStatus_InvalidDataType")
		SetError($_WinampStatus_InvalidDataType, 1)
		Return 0
	EndIf
	;
	If Not __WinampIsObjType($o_object, "application") Then
		__WinampErrorNotify("Error", "_WinampQuit", "$_WinampStatus_InvalidObjectType")
		SetError($_WinampStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
	$h_hwnd = HWnd($o_object.Hwnd)
	WinKill($h_hwnd)
	$o_object = 0
	SetError($_WinampStatus_Success)
	Return 1
EndFunc   ;==>_WinampQuit
#endregion
#region Error Handling
;===============================================================================
;
; Function Name:   _WinampErrorHandlerRegister()
; Description:		Register and enable a user COM error handler
; Parameter(s):		$s_functionName - String variable with the name of a user-defined COM error handler
;									  defaults to the internal COM error handler in this UDF
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_WinampStatus_Success) = No Error
;								- 1 ($_WinampStatus_GeneralError) = General Error
;					@Extended	- Contains invalid parameter number
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _WinampErrorHandlerRegister($s_functionName = "__WinampInternalErrorHandler")
	$sWinampUserErrorHandler = $s_functionName
	$oWinampErrorHandler = ""
	$oWinampErrorHandler = ObjEvent("AutoIt.Error", $s_functionName)
	If IsObj($oWinampErrorHandler) Then
		SetError($_WinampStatus_Success)
		Return 1
	Else
		__WinampErrorNotify("Error", "_WinampErrorHandlerRegister", "$_WinampStatus_GeneralError", _
				"Error Handler Not Registered - Check existance of error function")
		SetError($_WinampStatus_GeneralError, 1)
		Return 0
	EndIf
EndFunc   ;==>_WinampErrorHandlerRegister

;===============================================================================
;
; Function Name:   _WinampErrorHandlerDeRegister()
; Description:		Disable a registered user COM error handler
; Parameter(s):		None
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns 1
;                   On Failure	- None
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _WinampErrorHandlerDeRegister()
	$sWinampUserErrorHandler = ""
	$oWinampErrorHandler = ""
	SetError($_WinampStatus_Success)
	Return 1
EndFunc   ;==>_WinampErrorHandlerDeRegister
;===============================================================================
;
; Function Name:   _WinampErrorNotify()
; Description:		Specifies whether Winamp.au3 automatically notifies of Warnings and Errors (to the console)
; Parameter(s):		$f_notify	- Optional: specifies whether notification should be on or off
;								- -1 = (Default) return current setting
;								- True = Turn On
;								- False = Turn Off
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- If $f_notify = -1, returns the current notification setting, else returns 1
;                   On Failure	- Returns 0
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _WinampErrorNotify($f_notify = -1)
	Switch Number($f_notify)
		Case (-1)
			Return $_WinampErrorNotify
		Case 0
			$_WinampErrorNotify = False
			Return 1
		Case 1
			$_WinampErrorNotify = True
			Return 1
		Case Else
			__WinampErrorNotify("Error", "_WinampErrorNotify", "$_WinampStatus_InvalidValue")
			Return 0
	EndSwitch
EndFunc   ;==>_WinampErrorNotify
#endregion
#region General Functions
;===============================================================================
;
; Function Name:    _Winamp_VersionInfo()
; Description:		Returns an array of information about the Winamp.au3 version
; Parameter(s):     None
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns an array ($WinampAU3VersionInfo)
;								- $WinampAU3VersionInfo[0] = Release Type (T=Test or V=Production)
;								- $WinampAU3VersionInfo[1] = Major Version
;								- $WinampAU3VersionInfo[2] = Minor Version
;								- $WinampAU3VersionInfo[3] = Sub Version
;								- $WinampAU3VersionInfo[4] = Release Date (YYYYMMDD)
;								- $WinampAU3VersionInfo[5] = Display Version (e.g. T0.1-0)
;                   On Failure	- None
; Author(s):        Bob Anthony (Code based off IE.au3)
;
;===============================================================================
;
Func _Winamp_VersionInfo()
	__WinampErrorNotify("Information", "_Winamp_VersionInfo", "version " & _
			$WinampAU3VersionInfo[0] & _
			$WinampAU3VersionInfo[1] & "." & _
			$WinampAU3VersionInfo[2] & "-" & _
			$WinampAU3VersionInfo[3], "Release date: " & $WinampAU3VersionInfo[4])
	SetError($_WinampStatus_Success)
	Return $WinampAU3VersionInfo
EndFunc   ;==>_Winamp_VersionInfo
#endregion
#region Internal Functions
Func __WinampErrorNotify($s_severity, $s_func, $s_status = "", $s_message = "")
	If $_WinampErrorNotify Or $__WinampAU3Debug Then
		Local $sStr = "--> Winamp.au3 " & $s_severity & " from function " & $s_func
		If Not $s_status = "" Then $sStr &= ", " & $s_status
		If Not $s_message = "" Then $sStr &= " (" & $s_message & ")"
		ConsoleWrite($sStr & @CR)
	EndIf
	Return 1
EndFunc   ;==>__WinampErrorNotify

Func __WinampInternalErrorHandlerRegister()
	Local $sCurrentErrorHandler = ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler <> "" And Not IsObj($oWinampErrorHandler) Then
		; We've got trouble... User COM Error handler assigned without using _WinampUserErrorHandlerRegister
		SetError($_WinampStatus_GeneralError)
		Return 0
	EndIf
	$oWinampErrorHandler = ""
	$oWinampErrorHandler = ObjEvent("AutoIt.Error", "__WinampInternalErrorHandler")
	If IsObj($oWinampErrorHandler) Then
		SetError($_WinampStatus_Success)
		Return 1
	Else
		SetError($_WinampStatus_GeneralError)
		Return 0
	EndIf
EndFunc   ;==>__WinampInternalErrorHandlerRegister

Func __WinampInternalErrorHandlerDeRegister()
	$oWinampErrorHandler = ""
	If $sWinampUserErrorHandler <> "" Then
		$oWinampErrorHandler = ObjEvent("AutoIt.Error", $sWinampUserErrorHandler)
	EndIf
	SetError($_WinampStatus_Success)
	Return 1
EndFunc   ;==>__WinampInternalErrorHandlerDeRegister

Func __WinampInternalErrorHandler()
	$WinampComErrorScriptline = $oWinampErrorHandler.scriptline
	$WinampComErrorNumber = $oWinampErrorHandler.number
	$WinampComErrorNumberHex = Hex($oWinampErrorHandler.number, 8)
	$WinampComErrorDescription = StringStripWS($oWinampErrorHandler.description, 2)
	$WinampComErrorWinDescription = StringStripWS($oWinampErrorHandler.WinDescription, 2)
	$WinampComErrorSource = $oWinampErrorHandler.Source
	$WinampComErrorHelpFile = $oWinampErrorHandler.HelpFile
	$WinampComErrorHelpContext = $oWinampErrorHandler.HelpContext
	$WinampComErrorLastDllError = $oWinampErrorHandler.LastDllError
	$WinampComErrorOutput = ""
	$WinampComErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorScriptline = " & $WinampComErrorScriptline & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorNumberHex = " & $WinampComErrorNumberHex & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorNumber = " & $WinampComErrorNumber & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorWinDescription = " & $WinampComErrorWinDescription & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorDescription = " & $WinampComErrorDescription & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorSource = " & $WinampComErrorSource & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorHelpFile = " & $WinampComErrorHelpFile & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorHelpContext = " & $WinampComErrorHelpContext & @CR
	$WinampComErrorOutput &= "----> $WinampComErrorLastDllError = " & $WinampComErrorLastDllError & @CR
	If $_WinampErrorNotify Or $__WinampAU3Debug Then ConsoleWrite($WinampComErrorOutput & @CR)
	SetError($_WinampStatus_ComError)
	Return
EndFunc   ;==>__WinampInternalErrorHandler

;===============================================================================
; Function Name:	__WinampIsObjType()
; Description:		Check to see if an object variable is of a specific type
; Author(s):		Bob Anthony
;===============================================================================
Func __WinampIsObjType(ByRef $o_object, $s_type)
	If Not IsObj($o_object) Then
		SetError($_WinampStatus_InvalidDataType, 1)
		Return 0
	EndIf
	
	; Setup internal error handler to Trap COM errors, turn off error notification
	Local $status = __WinampInternalErrorHandlerRegister()
	If Not $status Then __WinampErrorNotify("Warning", "internal function __WinampIsObjType", _
			"Cannot register internal error handler, cannot trap COM errors", _
			"Use _WinampErrorHandlerRegister() to register a user error handler")
	Local $f_NotifyStatus = _WinampErrorNotify() ; save current error notify status
	_WinampErrorNotify(False)
	;
	Local $s_Name = ObjName($o_object), $objectOK = False, $oTemp
	
	Switch $s_type
		Case "Winampobj"
			If __WinampIsObjType($o_object, "application") Then
				$objectOK = True
			ElseIf __WinampIsObjType($o_object, "playlist") Then
				$objectOK = True
			ElseIf __WinampIsObjType($o_object, "mediaitem") Then
				$objectOK = True
			EndIf
		Case "application"
			If $s_Name = "IApplication" Then $objectOK = True
		Case "playlist"
			If $s_Name = "Playlist" Then $objectOK = True
		Case "mediaitem"
			If $s_Name = "MediaItem" Then $objectOK = True
		Case Else
			; Unsupported ObjType specified
			SetError($_WinampStatus_InvalidValue, 2)
			Return 0
	EndSwitch
	
	; restore error notify and error handler status
	_WinampErrorNotify($f_NotifyStatus) ; restore notification status
	__WinampInternalErrorHandlerDeRegister()
	
	If $objectOK Then
		SetError($_WinampStatus_Success)
		Return 1
	Else
		SetError($_WinampStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
EndFunc   ;==>__WinampIsObjType
#endregion