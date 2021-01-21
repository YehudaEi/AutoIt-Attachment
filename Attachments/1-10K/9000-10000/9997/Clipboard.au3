;Clipboard.au3
;Steve Podhajecki [eltorro] steve@ocotillo.sytes.net
;Clipboard notification udf
;Allows you app to recieve clipboard change notifications.

#Include <GuiConstants.au3>
#Include <Constants.au3>
#include-once
Global Const $WM_CHANGECBCHAIN = 0x030D
Global Const $WM_COPYDATA = 0x4A
Global Const $WM_DRAWCLIPBOARD = 0x0308
Global $hWnd_NEXT_IN_CLIP_CHAIN
Global $bInChain  ;Flag to indicate app is in the notification chain.
Global $EVENT = 0 ; Then event to pass to msgloop
Local $DEBUG = True ;show debug messages. To console


;===============================================================================
; Function Name:	_InitAsClipViewer
; Description:		Places the application in the Clipboard notification chain.
; Parameter(s):		$hWndA	 The $handle to the application gui
; Requirement(s):	Beta
; Return Value(s):	Returns 1 on success or 0 on failure
; User CallTip:
; Author(s):		Stephen Podhajecki [eltorro] steve@ocotillo.sytes.net
; Note(s):			This must be called before the application can recieve
;					Clipboard notifications.
;===============================================================================
Func _InitAsClipViewer($hWndA)
	Local $LOCAL_ERR
	_StopAsClipViewer($hWndA)
	If ($hWndA <> 0) Then
		; Register Clipboard 'viewer' notification messages
		If Not (GUIRegisterMsg($WM_DRAWCLIPBOARD, "MyClipBoardProc")) Then $LOCAL_ERR = $LOCAL_ERR + 1
		If Not (GUIRegisterMsg($WM_CHANGECBCHAIN, "MyClipBoardProc")) Then $LOCAL_ERR = $LOCAL_ERR + 1
		
		;If Not (GUIRegisterMsg($WM_COPYDATA,"MyClipBoardProc")) Then $LOCAL_ERR = $LOCAL_ERR +1
		If $LOCAL_ERR Then Return 0
		; Add this app to clipboard viewer notification chain
		Local $v_ret = DllCall("user32", "int", "SetClipboardViewer", "hwnd", $hWndA)
		If @error Or Not (IsArray($v_ret)) Then
			Return 0
		Else
			$hWnd_NEXT_IN_CLIP_CHAIN = $v_ret[0]
			$bInChain = True
			Return 1
		EndIf
	EndIf
	If $DEBUG Then ConsoleWrite("$bInChain = " & $bInChain & @LF)
	Return 0
EndFunc   ;==>_InitAsClipViewer

;===============================================================================
; Function Name:	_StopAsClipViewer
; Description:		Removes this application from the Clipboard notification chain
; Parameter(s):		$hWndA	 The handle to the application
; Requirement(s):	Beta
; Return Value(s):	1 on success or 0 on error (error could be hook not initiated)
; User CallTip:
; Author(s):		Stephen Podhajecki [eltorro] steve@ocotillo.sytes.net
; Note(s):
;===============================================================================
Func _StopAsClipViewer($hWndA)
	Local $LOCAL_ERR
	If ($bInChain) Then
		If ($hWndA <> 0) Then
			;Release handle from chain
			$ret = DllCall("user32.dll", "int", "ChangeClipboardChain", "hwnd", $hWndA, "hwnd", $hWnd_NEXT_IN_CLIP_CHAIN)
			; UnRegister clipboard messages:
			If Not (GUIRegisterMsg($WM_CHANGECBCHAIN, "")) Then $LOCAL_ERR = $LOCAL_ERR + 1
			If Not (GUIRegisterMsg($WM_DRAWCLIPBOARD, "")) Then $LOCAL_ERR = $LOCAL_ERR + 1
			;Not nec
			;If Not(GUIRegisterMsg($WM_COPYDATA,"MyClipBoardProc")) Then  $LOCAL_ERR = $LOCAL_ERR +1
			
		EndIf
		$bInChain = False
		If Not ($LOCAL_ERR) Then Return 1
	EndIf
	Return 0
EndFunc   ;==>_StopAsClipViewer


;===============================================================================
; Function Name:	MyClipBoardProc
; Description:		Recieves messages from AutoIt3's message loop hook.
; Parameter(s):		$hWndGUI	The handle of the process that sent the message
;					$MsgID	 The message id from the process
;					$wParam	 The wParams sent by the process (hex)
;					$lParam	 The lParams sent by the process (hex)
; Requirement(s):	Beta
; Return Value(s):	Sets then global Variable $EVENT to the msg id and allows
;					the main msg loop to handle the event.
; User CallTip:
; Author(s):
; Note(s):	;Not sure if it is bad mojo for AutoIt to use same function
;			for more than one message but in this case it seems to work fine.
;===============================================================================
Func MyClipBoardProc($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam, $lParam
	If $DEBUG Then ConsoleWrite("MyClipBoardProc>MsgId>" & $MsgID & @LF)
	Switch $MsgID
		Case $WM_DRAWCLIPBOARD
			;pass message on to next in chain.
			DllCall("user32.dll", "int", "SendMessage", "hWnd", $hWnd_NEXT_IN_CLIP_CHAIN, "int", $WM_DRAWCLIPBOARD, "int", $wParam, "int", $lParam)
			;Raise the event and let main message loop handle the call.
			$EVENT = $WM_DRAWCLIPBOARD
			
		Case $WM_CHANGECBCHAIN
			If $wParam = $hWnd_NEXT_IN_CLIP_CHAIN Then
				$hWnd_NEXT_IN_CLIP_CHAIN = $lParam
			Else
				;The chain has changed, pass it along.
				DllCall("user32.dll", "int", "SendMessage", "hWnd", $hWnd_NEXT_IN_CLIP_CHAIN, "int", $WM_CHANGECBCHAIN, "hwnd", $wParam, "hwnd", $lParam)
			EndIf
			;Raise the event and let main message loop handle the call.
			$EVENT = $WM_CHANGECBCHAIN
		Case $WM_COPYDATA
			If $DEBUG Then ConsoleWrite("MyClipBoardProc>$WM_COPYDATA>MsgId>" & $MsgID & @LF)
		Case Else
			;No events.
			$EVENT = 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MyClipBoardProc
