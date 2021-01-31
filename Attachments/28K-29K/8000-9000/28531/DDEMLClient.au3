#include-once
#include "DDEML.au3"
; ------------------------------------------------------------------------------
;
; Version:        1.5
; AutoIt Version: 3.3.0.0
; Language:       English
; Author:         doudou
; Description:    Functions for DDEML clients.
; Requirements:   DDEML
;
; ------------------------------------------------------------------------------

; conversation control functions ;

;===============================================================================
; Function Name:   _DdeConnect
; Description:     The _DdeConnect function establishes a conversation with a
;                  server application that supports the specified service name
;                  and topic name pair. If more than one such server exists, the
;                  system selects only one.
;
; Parameter(s):    $hszService - Handle to the string that specifies the service
;                                name of the server application with which a
;                                conversation is to be established. This handle
;                                must have been created by a previous call to
;                                the _DdeCreateStringHandle function. If this
;                                parameter is 0, a conversation is established
;                                with any available server.
;                  $hszTopic - Handle to the string that specifies the name of
;                              the topic on which a conversation is to be established.
;                              This handle must have been created by a previous
;                              call to _DdeCreateStringHandle. If this parameter
;                              is 0, a conversation on any topic supported by
;                              the selected server is established.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is the handle
;                  to the established conversation.
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeConnect($hszService = 0, $hszTopic = 0)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeConnect", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hszService, $_DDEML_HANDLETYPE, $hszTopic, "ptr", 0)
    ConsoleWrite("_DdeConnect(" & $hszService & ", " & $hszTopic & ")=" & $res[0] & @CRLF)
    If $res[0] Then Return $res[0]

    SetError(_DdeGetLastError())
    Return 0
EndFunc

;===============================================================================
; Function Name:   _DdeReconnect
; Description:     The DdeReconnect function allows a client Dynamic Data Exchange
;                  Management Library (DDEML) application to attempt to reestablish
;                  a conversation with a service that has terminated a conversation
;                  with the client. When the conversation is reestablished, the
;                  DDEML attempts to reestablish any preexisting advise loops.
;
; Parameter(s):    $hConv - Handle to the conversation to be reestablished.
;                           A client must have obtained the conversation handle
;                           by a previous call to the _DdeConnect function or
;                           from an $XTYP_DISCONNECT transaction.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is the handle to
;                  the reestablished conversation.
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeReconnect($hConv)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeReconnect", $_DDEML_HANDLETYPE, $hConv)
    If $res[0] Then Return $res[0]

    SetError(_DdeGetLastError())
    Return 0
EndFunc

;===============================================================================
; Function Name:   _DdeClientTransaction
; Description:     The _DdeClientTransaction function begins a data transaction
;                  between a client and a server. Only a dynamic data exchange
;                  (DDE) client application can call this function, and the
;                  application can use it only after establishing a conversation
;                  with the server.
;
; Parameter(s):    $wType - Specifies the transaction type. This parameter can
;                           be one of the following types:
;
;                           $XTYP_ADVSTART  Begins an advise loop. Any number
;                                           of distinct advise loops can exist
;                                           within a conversation. An
;                                           application can alter the advise
;                                           loop type by combining the $XTYP_ADVSTART
;                                           transaction type with one or more
;                                           of the following flags:
;
;                           $XTYPF_NODATA   Instructs the server to notify the
;                                           client of any data changes without
;                                           actually sending the data. This
;                                           flag gives the client the option
;                                           of ignoring the notification or
;                                           requesting the changed data from
;                                           the server.
;                           $XTYPF_ACKREQ   Instructs the server to wait until
;                                           the client acknowledges that it
;                                           received the previous data item
;                                           before sending the next data item.
;                                           This flag prevents a fast server
;                                           from sending data faster than the
;                                           client can process it.
;
;                           $XTYP_ADVSTOP   Ends an advise loop.
;                           $XTYP_EXECUTE   Begins an execute transaction.
;                           $XTYP_POKE      Begins a poke transaction.
;                           $XTYP_REQUEST   Begins a request transaction.
;                  $hConv - Handle to the conversation in which the transaction
;                           is to take place.
;                  $data - Data the client must pass to the server.
;                  $dwTimeout - Specifies the maximum length of time, in milliseconds,
;                               that the client will wait for a response from the
;                               server application in a synchronous transaction.
;                               This parameter should be $TIMEOUT_ASYNC for
;                               asynchronous transactions.
;                  $hszItem - Handle to the data item for which data is being
;                             exchanged during the transaction. This handle must
;                             have been created by a previous call to the
;                             _DdeCreateStringHandle function. This parameter is
;                             ignored (and should be set to 0) if the $wType
;                             parameter is $XTYP_EXECUTE.
;                  $wFmt - Specifies the standard clipboard format in which the
;                          data item is being submitted or requested.
;                          If the transaction specified by the wType parameter
;                          does not pass data or is $XTYP_EXECUTE, this parameter
;                          should be zero.
;                          If the transaction specified by the $wType parameter
;                          references non-execute DDE data ($XTYP_POKE,
;                          $XTYP_ADVSTART, $XTYP_ADVSTOP, $XTYP_REQUEST), the $wFmt
;                          value must be either a valid predefined (CF_) DDE
;                          format or a valid registered clipboard format.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is a data handle
;                  that identifies the data for successful synchronous transactions
;                  in which the client expects data from the server. The return
;                  value is nonzero for successful asynchronous transactions and
;                  for synchronous transactions in which the client does not
;                  expect data. The return value is zero for all unsuccessful
;                  transactions.
;
; Author(s):       doudou
;===============================================================================
Func _DdeClientTransaction($wType, $hConv, $data = 0, $dwTimeout = 10000, $hszItem = 0, $wFmt = $CF_TEXT)
    Local $stResult = DllStructCreate("dword dwResult")
    Local $struct, $pData, $cb
    $pData = 0
    $cb = 0

    If $XTYP_EXECUTE = $wType Or $XTYP_POKE = $wType Then
        If Execute($_DDEML_HANDLETYPE_CHECK & '($data)') Then
            If 0 = $data And $XTYP_EXECUTE = $wType Then
                ConsoleWrite("_DdeClientTransaction: null data on XTYP_EXECUTE" & @CRLF)
                SetError($DMLERR_INVALIDPARAMETER)
                Return 0
            EndIf
            $pData = $data
            $cb = 0xFFFFFFFF
        Else
            $cb = _DDEML_CreateDataStruct($data, $struct, $wFmt)
            $pData = DllStructGetPtr($struct, 1)

        EndIf
    EndIf
    ;If $XTYP_EXECUTE = $wType Or 0 = $pData Then $wFmt = 0
    If $XTYP_EXECUTE = $wType Then
	$wFmt = $CF_TEXT
	ENDIF
    If $XTYP_EXECUTE = $wType Then $hszItem = 0

    DllStructSetData($stResult, 1, 0)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeClientTransaction", "ptr", $pData, "dword", $cb, $_DDEML_HANDLETYPE, $hConv, $_DDEML_HANDLETYPE, $hszItem, "uint", $wFmt, "uint", $wType, "dword", $dwTimeout, "ptr", DllStructGetPtr($stResult))
	ConsoleWrite("_DdeClientTransaction(" & $data & ")=" & $res[0] & @CRLF)
    SetExtended(DllStructGetData($stResult, 1))
    $stResult = 0
    Return $res[0]
EndFunc

;===============================================================================
; Function Name:   _DdeAbandonTransaction
; Description:     The _DdeAbandonTransaction function abandons the specified
;                  asynchronous transaction and releases all resources associated
;                  with the transaction.
;
; Parameter(s):    $hConv - Handle to the conversation in which the transaction
;                           was initiated. If this parameter is 0, all transactions
;                           are abandoned (that is, the $idTransaction parameter
;                           is ignored).
;                  $idTransaction - Specifies the identifier of the transaction
;                                   to abandon. If this parameter is 0, all active
;                                   transactions in the specified conversation
;                                   are abandoned.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeAbandonTransaction($hConv, $idTransaction = 0)
    Local $res = DllCall("user32.dll", "int", "DdeAbandonTransaction", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hConv, "dword", $idTransaction)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

; conversation enumeration functions ;

Func _DdeConnectList($hszService = 0, $hszTopic = 0, $hConvList = 0)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeConnectList", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hszService, $_DDEML_HANDLETYPE, $hszTopic, $_DDEML_HANDLETYPE, $hConvList, "ptr", 0)
    If $res[0] Then Return $res[0]

    SetError(_DdeGetLastError())
    Return 0
EndFunc

Func _DdeDisconnectList($hConvList)
    Local $res = DllCall("user32.dll", "int", "DdeDisconnectList", $_DDEML_HANDLETYPE, $hConvList)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

Func _DdeQueryNextServer($hConvList, $hConvPrev = 0)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeQueryNextServer", $_DDEML_HANDLETYPE, $hConvList, $_DDEML_HANDLETYPE, $hConvPrev)
    Return $res[0]
EndFunc

; stateless client transactions

Func _DDEMLClient_Execute($szService, $szTopic, $szCommand, $wFmt = $CF_TEXT)
    Local $res = 0
    Local $dwRes = _DdeInitialize("", BitOR($APPCMD_CLIENTONLY, $CBF_SKIP_ALLNOTIFICATIONS))
    If $DMLERR_NO_ERROR <> $dwRes Then
        SetError($dwRes)
        Return $res
    EndIf

    Local $hszService = 0
    If 0 < StringLen($szService) Then $hszService = _DdeCreateStringHandle($szService)
    Local $hszTopic = 0
    If 0 < StringLen($szTopic) Then $hszTopic = _DdeCreateStringHandle($szTopic)

    Local $hConv = _DdeConnect($hszService, $hszTopic)
    If 0 <> $hConv Then
        Local $stData

        If _DDEML_CreateDataStruct($szCommand, $stData) Then
			;MsgBox(0, "createdatastructure",$szCommand)
            Local $hData = _DdeCreateDataHandle($stData)
			MsgBox(0, "$hData",$hData)
			    If @error Then ConsoleWriteError("data alloc error (0x" & StringFormat("%x", @error) & ")" & @CRLF)
				return $hData

            $res = _DdeClientTransaction($XTYP_EXECUTE, $hConv, $hData, 10000, 0, $wFmt = $CF_TEXT)

            $stData = 0
        EndIf
        _DdeDisconnect($hConv)
    EndIf
    If 0 <> $hszService Then _DdeFreeStringHandle($hszService)
    If 0 <> $hszTopic Then _DdeFreeStringHandle($hszTopic)
    _DdeUninitialize()

    Return $res
EndFunc

Func _DDEMLClient_Poke($szService, $szTopic, $szItem, $data, $wFmt = $CF_TEXT)
    Local $res = 0
    Local $dwRes = _DdeInitialize("", BitOR($APPCMD_CLIENTONLY, $CBF_SKIP_ALLNOTIFICATIONS))
    If $DMLERR_NO_ERROR <> $dwRes Then
        SetError($dwRes)
        Return $res
    EndIf

    Local $hszService = 0
    If 0 < StringLen($szService) Then $hszService = _DdeCreateStringHandle($szService)
    Local $hszTopic = 0
    If 0 < StringLen($szTopic) Then $hszTopic = _DdeCreateStringHandle($szTopic)

    Local $hConv = _DdeConnect($hszService, $hszTopic)
    If 0 <> $hConv Then
        Local $stData
        Local $hszItem = _DdeCreateStringHandle($szItem)
        If _DDEML_CreateDataStruct($data, $stData) Then
            Local $hData = _DdeCreateDataHandle($stData)
            $res = _DdeClientTransaction($XTYP_POKE, $hConv, $hData, 10000, $hszItem, $wFmt)
            $stData = 0
        EndIf
        If 0 <> $hszItem Then _DdeFreeStringHandle($hszItem)
        _DdeDisconnect($hConv)
    EndIf

    If 0 <> $hszService Then _DdeFreeStringHandle($hszService)
    If 0 <> $hszTopic Then _DdeFreeStringHandle($hszTopic)
    _DdeUninitialize()

    Return $res
EndFunc

Func _DDEMLClient_RequestString($szService, $szTopic, $szItem, $wFmt = 0)
    Local $res = ""
    Local $dwRes = _DdeInitialize("", BitOR($APPCMD_CLIENTONLY, $CBF_SKIP_ALLNOTIFICATIONS))
    If $DMLERR_NO_ERROR <> $dwRes Then
        SetError($dwRes)
        Return $res
    EndIf

    Local $hszService = 0
    If 0 < StringLen($szService) Then $hszService = _DdeCreateStringHandle($szService)
    Local $hszTopic = 0
    If 0 < StringLen($szTopic) Then $hszTopic = _DdeCreateStringHandle($szTopic)

    Local $hConv = _DdeConnect($hszService, $hszTopic)
    If 0 <> $hConv Then
        Local $hszItem = _DdeCreateStringHandle($szItem)
        Local $hData = _DdeClientTransaction($XTYP_REQUEST, $hConv, 0, 10000, $hszItem, $wFmt)
        $res = _DdeGetDataAsString($hData)
        If 0 <> $hszItem Then _DdeFreeStringHandle($hszItem)
        _DdeDisconnect($hConv)
    EndIf

    If 0 <> $hszService Then _DdeFreeStringHandle($hszService)
    If 0 <> $hszTopic Then _DdeFreeStringHandle($hszTopic)
    _DdeUninitialize()

    Return $res
EndFunc
