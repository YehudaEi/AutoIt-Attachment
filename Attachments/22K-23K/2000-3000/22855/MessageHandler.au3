
#include-once

Global Const $MHVersionInformation = "V1.04"

Global $MHSendDataToFunc = " _DefaultMsgFunc"
Global $MHhwmd_Receiver
Global $MHAdditionalIdentifier = "_CAL987qwerty2468";just to make the window titles a little bit more unique

; Windows Definitions;
Global Const $StructDef_COPYDATA = "dword none;dword count;ptr pointer"
Global Const $WM_COPYDATA_MH = 0x4A

;Message Queue Setup
Global $MHCallBackTimer = 200 
Global $pTimerProc, $uiTimer
Global $aMessageQueue[1]=[0]

Opt("OnExitFunc", "CallBack_Exit")

; #FUNCTION# ====================================================================================================================
; Name...........: _MHVersion
; Description ...: Gets Message Handler Version information
; Syntax.........: _MHVersion() 
; Parameters ....: None
; Return values .: Message Handler Version Number
; Author ........: ChrisL
; ===============================================================================================================================
Func _MHVersion()
	
	Return $MHVersionInformation

EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _SetCallBackTimerInterval
; Description ...: Sets the script up to accept messages
; Syntax.........: _SetCallBackTimerInterval(nnn)
; Parameters ....: $iTime     - Callback timer in milliseconds to process each message in the queue
; Return values .: Success    - The new callback timer
;                  Failure    - @error is set and the previous callback timer setting is used. Default is 200ms
; Information ...: The timer must be changed before _SetAsReceiver() is called
; Author ........: ChrisL
; ===============================================================================================================================
Func _SetCallBackTimerInterval($iTime = 200)
	If Not IsInt($iTime) then Return SetError(1,0,$MHCallBackTimer) ;not an integer so set error and return current setting
	If $MHhwmd_Receiver <> "" then Return SetError(1,0,$MHCallBackTimer) ;the receiver function is already set so the timer can not be changed
	If $iTime = 0 then Return $MHCallBackTimer ;Return existing value
	If $iTime < 50 then $iTime = 50
	$MHCallBackTimer = $iTime
	Return SetError(0,0,$iTime)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _CALLBACKQUEUE
; Description ...: Process any messages that are queued and adjust the message queue
; Syntax.........: None
; Parameters ....: None
; Return values .: None 
; Author ........: ChrisL
; ===============================================================================================================================
Func _CALLBACKQUEUE()
	
	Local $vMessage
	Local $queueLen = $aMessageQueue[0]
	
	If $queueLen > 0 then 
		$vMessage = $aMessageQueue[1]
		$aMessageQueue[1] = ""
		For $i = 1 to $queueLen -1
			$aMessageQueue[$i] = $aMessageQueue[$i +1]
		Next
		
		Redim $aMessageQueue[$queueLen]
		
		$aMessageQueue[0] = $queueLen - 1
		Call($MHSendDataToFunc,$vMessage)
	EndIf

EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _QueueMessage
; Description ...: Queues messages to prevent script slowdown
; Syntax.........: _QueueMessage($vText)
; Parameters ....: $vText    - The text to queue from the remote script
; Return values .: None 
; Author ........: ChrisL
; ===============================================================================================================================
Func _QueueMessage($vText)
	Redim $aMessageQueue[$aMessageQueue[0] +2]
	$aMessageQueue[$aMessageQueue[0] +1] = $vText
	$aMessageQueue[0]+=1
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _SetAsReceiver
; Description ...: Sets the script up to accept messages
; Syntax.........: _SetAsReceiver($vTitle)
; Parameters ....: $vTitle    - The Local_ReceiverID_Name
; Return values .: Success    - Handle to the receiver window
;                  Failure    - @error is set and the relevant message is displayed
; Author ........: ChrisL
; ===============================================================================================================================
Func _SetAsReceiver($vTitle)
	
	
	If StringLen($vTitle) = 0 then 
		Msgbox(16 + 262144,"Message Handler Error","A Local_ReceiverID_Name must be specified." & @crlf & _ 
			"Messages will not be received unless a unique Local_ReceiverID_Name is used!")
		Return SetError(1,1,-1);Make sure the user has specified a title
	EndIf
	
	$vTitle &= $MHAdditionalIdentifier;add on our additionalIdentifier which is unlikely to be used exept by scripts using this UDF
	
	If WInExists($vtitle) and WinGetHandle($vTitle) <> $MHhwmd_Receiver then ;already a window exists with this title and it's not ours highly unlikely unless 2 copies of the script are running
		Msgbox(16 + 262144,"Message Handler Error","The Local_ReceiverID_Name " & StringTrimRight($vTitle,StringLen($MHAdditionalIdentifier)) & " already exists." & @crlf & _ 
			"A unique Local_ReceiverID_Name must be specified." & @crlf & _ 
			"Messages will not be received unless a unique Local_ReceiverID_Name is used!")
		Return SetError(1,2,-1) 
	EndIf

	$MHhwmd_Receiver = GUICreate($vTitle)
	GUIRegisterMsg($WM_COPYDATA_MH, "_GUIRegisterMsgProc")
	$pTimerProc = DllCallbackRegister("_CALLBACKQUEUE", "none", "")
	$uiTimer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", 0, "uint", 0, "int", $MHCallBackTimer, "ptr", DllCallbackGetPtr($pTimerProc))
	$uiTimer = $uiTimer[0]
	Return $MHhwmd_Receiver
	
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _SetReceiverFunction
; Description ...: Sets the function to call on receiving data
; Syntax.........: _SetReceiverFunction($vString)
; Parameters ....: $vString   - The string of data to send
; Return values .: Success    - The users function name to call
;                  Failure    - @error is set and "" is returned
; Author ........: ChrisL
; ===============================================================================================================================
Func _SetReceiverFunction($vString)
	If $vString = "" then return SetError(1,1,$vString)
	$MHSendDataToFunc = $vString
	Return SetError(0,0,$MHSendDataToFunc)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _SendData
; Description ...: Sends data to the registered window
; Syntax.........: _SendData($vData,$ReceiverTitle)
; Parameters ....: $vData           - The string of data to send
;                  $ReceiverTitle   - Remote_ReceiverID_Name specified in the script you wish to communicate to
; Return values .: Success      - The count of the string length sent
;                  Failure      - @error is set and 0 is returned
; Author ........: martin, piccaso and ChrisL
; ===============================================================================================================================
Func _SendData($vData,$ReceiverTitle)
	Local $strLen,$CDString,$vs_cds,$pCDString,$pStruct,$hwndRec
	
	If StringLen($ReceiverTitle) = 0 then Return SetError(1,1,0);Make sure the user has specified a title
	$ReceiverTitle&= $MHAdditionalIdentifier
	
	$strLen = StringLen($vData)
	$CDString = DllStructCreate("char var1[" & $strLen +1 & "]");the array to hold the string we are sending
	DllStructSetData($CDString,1,$vData)
	
	$pCDString = DllStructGetPtr($CDString);the pointer to the string
	
	$vs_cds = DllStructCreate($StructDef_COPYDATA);create the message struct
	DllStructSetData($vs_cds,"count",$strLen + 1);tell the receiver the length of the string +1
	DllStructSetData($vs_cds,"pointer",$pCDString);the pointer to the string

	$pStruct = DllStructGetPtr($vs_cds)
	
	$hwndRec = WinGetHandle($ReceiverTitle)
	If $hwndRec = "" then 
		$vs_cds = 0;free the struct
		$CDString = 0;free the struct
		Return SetError(1,2,0)
	EndIf
	

	DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hwndRec, "int", $WM_COPYDATA_MH, "wparam", 0, "lparam", $pStruct)
	If @error then 
		$vs_cds = 0;free the struct
		$CDString = 0;free the struct
		return SetError(1, 3, 0) ;return 0 no data sent
	EndIf
	
	
	$vs_cds = 0;free the struct
	$CDString = 0;free the struct
	Return $strLen 
EndFunc



; #FUNCTION# ====================================================================================================================
; Name...........: _GUIRegisterMsgProc
; Description ...: Called when a messae is sent to the registered window
; Syntax.........: _GUIRegisterMsgProc($hWnd, $MsgID, $wParam, $lParam)
; Parameters ....: $hWnd       - Window/control handle
;                  $iMsg       - Message ID received
;                  $wParam     - Could specify additional message-specific information
;                  $lParam     - Specifies a pointer to the message 
; Return values .: None        - Calls user specified function
; Author ........: piccaso
; Modified.......: ChrisL and martin
; ===============================================================================================================================
Func _GUIRegisterMsgProc($hWnd, $MsgID, $WParam, $LParam)
	Local $vs_cds,$vs_msg
	
    If $MsgID = $WM_COPYDATA_MH Then ; We Recived a WM_COPYDATA Message
       ; $LParam = Poiter to a COPYDATA Struct
        $vs_cds = DllStructCreate($StructDef_COPYDATA, $LParam)
       ; Member No. 3 of COPYDATA Struct (PVOID lpData;) = Pointer to Custom Struct
        $vs_msg = DllStructCreate("char[" & DllStructGetData($vs_cds, "count") & "]", DllStructGetData($vs_cds, "pointer"))
       ; Call the function to queue the received data
		_QueueMessage(DllStructGetData($vs_msg, 1))
		$vs_cds = 0
		$vs_msg = 0
    EndIf
	
EndFunc  ;==>_GUIRegisterMsgProc


; #FUNCTION# ====================================================================================================================
; Name...........: _DefaultMsgFunc
; Description ...: If no user function is specified this function i used to receive data
; Syntax.........: _DefaultMsgFunc($vText)
; Parameters ....: $vText     - The data sent be the other script
; Return values .: None
; Author ........: ChrisL
; ===============================================================================================================================
Func _DefaultMsgFunc($vText)
	Msgbox(0," _DefaultMsgFunc",$vText)
EndFunc  ;==>_DefaultMsgFunc


;Release the CallBack resources
Func CallBack_Exit()
	If $MHhwmd_Receiver <> "" then 
		DllCallbackFree($pTimerProc)
		DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "uint", $uiTimer)
	EndIf	
EndFunc