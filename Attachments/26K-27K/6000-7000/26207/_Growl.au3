#include-once
; ------------------------------------------------------------------------------
; Title .........: Growl for Windows UDF library for AutoIt v3
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    A collection of functions for notifications using Growl for Windows www.growlforwindows.com
;                 Markus Mohnen <markus.mohnen@googlemail.com>

;===============================================================================
; Includes
#include <ASock.au3>
#include <Array.au3>

#cs defs
#ce
;===============================================================================
; Global public variables
Global $GrowlWnd = -1
Global $GrowlWindowMessageBase = 1024

;===============================================================================
; Global internal variables
Global Const $_GrowlTCPPort = 23053
Global $_GrowlApplications[1] = [0]
Global $_GrowlASockets[1] = [0]
Global $_GrowlASocketsMessage[1] = [0]
Global $_GrowlASocketsCode[1] = [0]
Global $_GrowlASocketsApplication[1] = [0]
Global $_Growldebugging = False

;===============================================================================
; Examples
; Local $notifications[1][1] = [["Notifcation"]]
; Local $id=_GrowlRegister("AutoIt", $notifications, "http://www.autoitscript.com/autoit3/files/graphics/au3.ico")
; _GrowlNotify($id, $notifications[0][0], "Simple notification", "Text of the simple notification")
; _GrowlNotify($id, $notifications[0][0], "Notification with Click", "CLICK ME", "", "ID", "Context", "ContextType")
; Sleep(10000) ; Enough time for user to click
;
; Func AutoIt_CLICK($id, $context, $contextType)
;	MsgBox(0, "AutoIt_CLICK", "$id="&$id&@CRLF&"$context="&$context&@CRLF&"$contextType="&$contextType)
; EndFunc

;===============================================================================
; UDF functions

;===============================================================================
; Function Name:	_GrowlRegister
; Description:		Registers with a running instance of Growl for Windows.
; Parameter(s):		$application - The name of the application to register
;					$notifications - An two-dimensional array describing the notifications to register for this application.
;									 Each element in the array is itself an array of up to 4 elements:
;									 Syntax: name[, display name[, filename or URL of an icon[, enabled]]]
;					$icon - Optional file name or URL of an icon to be used by Growl for this application.
; Syntax:			 _GrowlRegister($application, $notifications[, $icon])
; Return Value(s):	On Success - ID of the application
;				 	On Failure - -1 and set
;						@Error to:
;							0 - No error
;							>0 - WSA error code from TCP communication with Growl
; Author(s):		Markus Mohnen <markus.mohnen@googlemail.com>
;===============================================================================
Func _GrowlRegister($application, $notifications, $icon = "")
	If Not (IsArray($notifications)) Or UBound($notifications, 0) < 2 Or UBound($notifications, 2) > 4 Then
		SetError(1)
		Return
	EndIf

	__GrowlDebugWrite("_GrowlRegister> " & $application)
	Local $message = "GNTP/1.0 REGISTER NONE" & @CRLF
	$message = $message & "Application-Name: " & $application & @CRLF
	If $icon Then $message = $message & "Application-Icon: " & $icon & @CRLF
	$message = $message & "Notifications-Count: " & UBound($notifications, 1) & @CRLF
	Local $i
	For $i = 0 To UBound($notifications, 1) - 1
		$message = $message & @CRLF
		$message = $message & "Notification-Name: " & $notifications[$i][0] & @CRLF
		If UBound($notifications, 2) > 1 And $notifications[$i][1] <> "" Then $message = $message & "Notification-Display-Name: " & $notifications[$i][1] & @CRLF
		If UBound($notifications, 2) > 2 And $notifications[$i][2] <> "" Then $message = $message & "Notification-Icon: " & $notifications[$i][2] & @CRLF
		If UBound($notifications, 2) > 3 And $notifications[$i][3] <> "" Then
			$message = $message & "Notification-Enabled: " & $notifications[$i][3] & @CRLF
		Else
			$message = $message & "Notification-Enabled: true" & @CRLF
		EndIf
	Next
	$message = $message & @CRLF & @CRLF
	__GrowlGNTP($application, $message)
	If @error Then
		SetError(@error, @extended)
		Return -1
	Else
		_ArrayAdd($_GrowlApplications, $application)
		Return UBound($_GrowlApplications) - 1
	EndIf
EndFunc   ;==>_GrowlRegister

;===============================================================================
; Function Name:	_GrowlNotify
; Description:		Send a notification for a registered application with a running instance of Growl for Windows.
; Parameter(s):		$appID - ID of the application from to _GrowlRegister
;					$notification - Name of the notification to send, from the notifications used in _GrowlRegister.
;					$title - Title to display in the notification. Must not contain @CRLF.
;					$text - Optional text of the notification. Must not contain @CRLF.
;					$icon - Optional file name or URL of an icon to be used for the notification. Without this, the application icon is used.
;					$id - Optional id of the notification. If this is specified, there will be asynchronous call backs to functions:
;							1. <ApplicationName>_CLICK is called when the notification is clicked by the user
;							2. <ApplicationName>_TIMEDOUT is called when the notification times out 
;							These functions must have the paramters ($id, $context, $contextType)
;					$context - Optional context of the notification to be passed to <ApplicationName>_CLICK and <ApplicationName>_TIMEDOUT
;					$contextType - Optional context type of the notification to be passed to <ApplicationName>_CLICK and <ApplicationName>_TIMEDOUT
;					$sticky - Optional boolean value if the notification should go away after time (default) or stay on the screen
; Syntax:			 _GrowlNotify($appID, $notification, $title[, $text[, $icon[, $id[, $context[, $contextType[, $sticky ]]]]]])
; Return Value(s):	No return value but sets
;						@Error to:
;							0 - No error
;							1 - Unknown application ID
;							>1 - WSA error code from TCP communication with Growl
; Author(s):		Markus Mohnen <markus.mohnen@googlemail.com>
;===============================================================================
Func _GrowlNotify($appID, $notification, $title, $text = "", $icon = "", $id = "", $context = "no context", $contextType = "string", $sticky = False)
	__GrowlDebugWrite("_GrowlNotify> " & $appID & ", " & $notification & ", " & $title & ", " & $text & ", " & $icon & ", " & $id & ", " & $context & ", " & $contextType & ", " & $sticky)
	If Not (IsInt($appID) And $appID > 0 And $appID < UBound($_GrowlApplications)) Then
		SetError(1)
		Return
	EndIf

	Local $message = "GNTP/1.0 NOTIFY NONE" & @CRLF
	$message = $message & "Application-Name: " & $_GrowlApplications[$appID] & @CRLF
	$message = $message & "Notification-Name: " & $notification & @CRLF
	$message = $message & "Notification-Title: " & $title & @CRLF
	If $text Then $message = $message & "Notification-Text: " & $text & @CRLF
	If $icon Then $message = $message & "Notification-Icon: " & $icon & @CRLF
	If $id Then
		$message = $message & "Notification-ID: " & $id & @CRLF
		$message = $message & "Notification-Callback-Context: " & $context & @CRLF
		$message = $message & "Notification-Callback-Context-Type: " & $contextType & @CRLF
	EndIf
	If $sticky Then $message = $message & "Notification-Sticky: True" & @CRLF
	$message = $message & @CRLF & @CRLF
	__GrowlGNTP($_GrowlApplications[$appID], $message)
	If @error Then SetError(@error, @extended)
EndFunc   ;==>_GrowlNotify

;===============================================================================
; Internal functions

Func __GrowlGNTP($application, $message)
	__GrowlDebugWrite("__GrowlGNTP> " & $application & ", " & $message)
	TCPStartup()

	While $_GrowlASockets[UBound($_GrowlASockets) - 1] == ""
		__GrowlDebugWrite("GC " & UBound($_GrowlASockets) - 1)
		_ArrayPop($_GrowlASockets)
		_ArrayPop($_GrowlASocketsMessage)
		_ArrayPop($_GrowlASocketsCode)
		_ArrayPop($_GrowlASocketsApplication)
	WEnd

	Local $ConnectedSocket = _ASocket()
	If $GrowlWnd = -1 Then $GrowlWnd = GUICreate(@ScriptName & " Dummy Notify Window")
	_ArrayAdd($_GrowlASockets, $ConnectedSocket)
	_ArrayAdd($_GrowlASocketsMessage, $message)
	_ArrayAdd($_GrowlASocketsCode, "")
	_ArrayAdd($_GrowlASocketsApplication, $application)
	Local $n = UBound($_GrowlASocketsCode) - 1
	__GrowlDebugWrite("$n=" & $n)
	_ASockSelect($ConnectedSocket, $GrowlWnd, $GrowlWindowMessageBase + $n, BitOR($FD_READ, $FD_CONNECT, $FD_CLOSE))
	If @error Then
		Local $error = @error
		__GrowlDebugWrite("__GrowlGNTP> _ASockSelect failed with WSA error: " & @error)
		SetError($error, @extended)
		Return
	EndIf
	GUIRegisterMsg($GrowlWindowMessageBase + $n, "__GrowlOnSocketEvent")
	_ASockConnect($ConnectedSocket, "127.0.0.1", $_GrowlTCPPort)
	If @error Then
		Local $error = @error
		__GrowlDebugWrite("__GrowlGNTP> _ASockConnect failed with WSA error: " & @error)
		SetError($error, @extended)
		Return
	EndIf
	While $_GrowlASocketsMessage[$n] <> ""
		Sleep(10)
		__GrowlDebugWrite("Waiting for connect of " & $n)
	WEnd
	While $_GrowlASocketsCode[$n] == ""
		Sleep(10)
		__GrowlDebugWrite("Waiting for answer of " & $n)
	WEnd
	Local $error = $_GrowlASocketsCode[$n]
	SetError($error)
	Return
EndFunc   ;==>__GrowlGNTP

Func __GrowlParseGNTPResponse($answer)
	Local $a = StringSplit(StringStripWS($answer, 2), @CRLF, 1)
	Local $result[UBound($a) - 1][2]
	$result[0][0] = $a[0] - 1
	$result[0][1] = $a[1]
	__GrowlDebugWrite("cnt " & $result[0][0])
	__GrowlDebugWrite("cde " & $result[0][1])
	For $i = 2 To $a[0]
		Local $k = StringInStr($a[$i], ": ")
		$result[$i - 1][0] = StringLeft($a[$i], $k - 1)
		$result[$i - 1][1] = StringMid($a[$i], $k + 2)
		__GrowlDebugWrite($i - 1 & " key " & $result[$i - 1][0])
		__GrowlDebugWrite($i - 1 & " val " & $result[$i - 1][1])
	Next
	Return $result
EndFunc   ;==>__GrowlParseGNTPResponse

Func __GrowlOnSocketEvent($hWnd, $iMsgID, $WParam, $LParam)
	__GrowlDebugWrite("__GrowlOnSocketEvent")
	Local $ConnectedSocket = $WParam
	Local $iError = _HiWord($LParam)
	Local $iEvent = _LoWord($LParam)

	Local $sDataBuff
	Local $iSent

	If $iMsgID >= $GrowlWindowMessageBase And $iMsgID < $GrowlWindowMessageBase + UBound($_GrowlASockets) Then
		Local $n = $iMsgID - $GrowlWindowMessageBase
		__GrowlDebugWrite("$n=" & $n)
		Switch $iEvent
			Case $FD_CONNECT
				__GrowlDebugWrite("$FD_CONNECT")
				If $iError <> 0 Then
					__GrowlSocketClose($n)
					$_GrowlASocketsMessage[$n] = ""
					$_GrowlASocketsCode[$n] = $iError
				Else
					__GrowlDebugWrite("Connected on socket")
					TCPSend($ConnectedSocket, $_GrowlASocketsMessage[$n])
					If @error Then
						$_GrowlASocketsCode[$n] = @error
						__GrowlSocketClose($n)
					EndIf
					$_GrowlASocketsMessage[$n] = ""
				EndIf
			Case $FD_READ
				__GrowlDebugWrite("$FD_READ")
				If $iError <> 0 Then
					$_GrowlASocketsCode[$n] = $iError
					__GrowlSocketClose($n)
				Else
					Local $answer = TCPRecv($ConnectedSocket, 1024)
					If @error Then
						$_GrowlASocketsCode[$n] = @error
						__GrowlSocketClose($n)
					ElseIf $answer <> "" Then
						__GrowlDebugWrite("__GrowlOnSocketEvent> GNTP answer " & @CRLF & $answer)
						Local $a = __GrowlParseGNTPResponse($answer)
						If StringInStr($a[0][1], "-ERROR") Then
							__GrowlDebugWrite("__GrowlOnSocketEvent> GNTP answer is Error" & @CRLF)
							Local $k = _ArraySearch($a, "Error-Code")
							If @error Then
								$_GrowlASocketsCode[$n] = 666
							Else
								$_GrowlASocketsCode[$n] = $a[$k][1]
							EndIf
						ElseIf StringInStr($a[0][1], "-CALLBACK") Then
							__GrowlDebugWrite("__GrowlOnSocketEvent> GNTP answer is Callback" & @CRLF)
							Local $k = _ArraySearch($a, "Notification-Callback-Result")
							If Not (@error) Then
								Local $fnName = StringStripWS($_GrowlASocketsApplication[$n], 8) & "_" & $a[$k][1]
								__GrowlDebugWrite("__GrowlOnSocketEvent> function to call is " & $fnName & @CRLF)
								Local $id = ""
								Local $context = ""
								Local $contextType = ""
								$k = _ArraySearch($a, "Notification-ID")
								If Not (@error) Then $id = $a[$k][1]
								$k = _ArraySearch($a, "Notification-Callback-Context")
								If Not (@error) Then $context = $a[$k][1]
								$k = _ArraySearch($a, "Notification-Callback-Context-Type")
								If Not (@error) Then $contextType = $a[$k][1]
								Call($fnName, $id, $context, $contextType)
							EndIf
							__GrowlSocketClose($n)
						Else
							__GrowlDebugWrite("__GrowlOnSocketEvent> GNTP answer is OK" & @CRLF)
							$_GrowlASocketsCode[$n] = 0
						EndIf
					Else
						$_GrowlASocketsCode[$n] = 666
						__GrowlSocketClose($n)
						__GrowlDebugWrite("Warning: schizophrenia! FD_READ, but no data on socket!")
					EndIf
				EndIf
			Case $FD_CLOSE
				__GrowlDebugWrite("$FD_CLOSE")
				__GrowlSocketClose($n)
		EndSwitch
	EndIf
EndFunc   ;==>__GrowlOnSocketEvent

Func __GrowlSocketClose($n)
	_ASockShutdown($_GrowlASockets[$n])
	Sleep(10)
	TCPCloseSocket($_GrowlASockets[$n])
	$_GrowlASockets[$n] = ""
EndFunc   ;==>__GrowlSocketClose

Func __GrowlSetDebug($debug_flag = True)
	$_Growldebugging = $debug_flag
	ConsoleWrite("Debug = " & $_Growldebugging & @LF)
EndFunc   ;==>__GrowlSetDebug

Func __GrowlDebugWrite($message, $flag = @LF)
	If $_Growldebugging Then
		ConsoleWrite(StringFormat($message) & $flag)
	EndIf
EndFunc   ;==>__GrowlDebugWrite
