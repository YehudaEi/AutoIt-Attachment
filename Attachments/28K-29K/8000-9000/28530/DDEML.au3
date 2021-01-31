#include-once
#include <Constants.au3>
#include <Clipboard.au3>
#include <DDEMLConstants.au3>

; ------------------------------------------------------------------------------
;
; Version:        1.5.1
; AutoIt Version: 3.3.0.0
; Language:       English
; Author:         doudou
; Description:    Common functions for Microsoft DDEML
;                 (Dynamic Data Exchange Management Library).
; Requirements:   ClipboardConstants
;                 DDEMLConstants
;
; ------------------------------------------------------------------------------
#cs
    Dynamic data exchange (DDE) is a form of interprocess communication that uses
    shared memory to exchange data between applications. Applications can use DDE
    for one-time data transfers and for ongoing exchanges and updating of data.
#ce

If Not IsDeclared("_DDEML_idInst") Then Global $_DDEML_idInst = 0
If Not IsDeclared("_DDEML_hDdeCallback") Then Global $_DDEML_hDdeCallback = 0
If Not IsDeclared("_DDEML_prefCallback") Then Global $_DDEML_prefCallback = ""
; set this to 0 manually when talking to ASCII servers
If Not IsDeclared("_DDEML_UNICODE") Then
    Assign("_DDEML_UNICODE", Execute("@Unicode"), 2)
    If @error Then
        If IsDeclared("_DDEML_UNICODE") Then
            $_DDEML_UNICODE = Execute("@AutoItUnicode")
        Else
            Assign("_DDEML_UNICODE", Execute("@AutoItUnicode"), 2)
        EndIf
    EndIf
    If @error Or Not IsInt($_DDEML_UNICODE) Then
        ConsoleWrite("WARNING: _DDEML_UNICODE is automatically set to 1" & @CRLF)
        $_DDEML_UNICODE = 1
        SetError(0)
    EndIf
EndIf

;****** API entry point ******;
;===============================================================================
; Function Name:   _DdeCallback
; Description:     The DdeCallbackProc function is an application-defined
;                  callback function used with the Dynamic Data Exchange Management
;                  Library (DDEML) functions. It processes dynamic data exchange
;                  (DDE) transactions. Here this callback is executed internally
;                  by DllCallback and advanced by name to transaction functions
;                  accordingly.
;
; Parameter(s):    as defined in ddeml.h
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): The return value depends on the transaction class. For more
;                  information about the return values, see descriptions of the
;                  individual transaction types.
;
; Author(s):       doudou
;===============================================================================
Func _DdeCallback($uType, $uFmt, $hConv, $hsz1, $hsz2, $hData, $dwData1, $dwData2)
    ConsoleWrite("_DdeCallback" & @CRLF)
    Local $res = 0
    If 0 < StringLen($_DDEML_prefCallback) Then
        Local $wFmt = 0
    ;;; TODO: callback parameters check
        Switch $uType
            ;Client
            Case $XTYP_ADVDATA
                $res = Call($_DDEML_prefCallback & "AdvData", _DdeQueryString($hsz1), _DdeQueryString($hsz2), $uFmt, $hData, $hConv)
            Case $XTYP_XACT_COMPLETE
                $res = Call($_DDEML_prefCallback & "XActComplete", $dwData1, $dwData2, _DdeQueryString($hsz1), _DdeQueryString($hsz2), $uFmt, $hData, $hConv)

            ;Server
            Case $XTYP_ADVREQ
                $res = Call($_DDEML_prefCallback & "AdvReq", $dwData1, _DdeQueryString($hsz1), $hsz2, $uFmt, $hConv)
            Case $XTYP_ADVSTART
                $res = Call($_DDEML_prefCallback & "AdvStart", _DdeQueryString($hsz1), _DdeQueryString($hsz2), $uFmt, $hConv)
            Case $XTYP_ADVSTOP
                $res = Call($_DDEML_prefCallback & "AdvStop", _DdeQueryString($hsz1), _DdeQueryString($hsz2), $uFmt, $hConv)
            Case $XTYP_CONNECT
                $res = Call($_DDEML_prefCallback & "Connect", _DdeQueryString($hsz1), _DdeQueryString($hsz2))
            Case $XTYP_CONNECT_CONFIRM
                $res = Call($_DDEML_prefCallback & "ConnectConfirm", _DdeQueryString($hsz1), _DdeQueryString($hsz2), $hConv)
            Case $XTYP_EXECUTE
                If $_DDEML_UNICODE Then $wFmt = $CF_UNICODETEXT
                $res = Call($_DDEML_prefCallback & "Execute", _DdeQueryString($hsz1), _DdeGetDataAsString($hData, $wFmt), $hConv)
            Case $XTYP_POKE
                $res = Call($_DDEML_prefCallback & "Poke", _DdeQueryString($hsz1), _DdeQueryString($hsz2), $uFmt, $hData, $hConv)
            Case $XTYP_REQUEST
                $res = Call($_DDEML_prefCallback & "Request", _DdeQueryString($hsz1), $hsz2, $uFmt, $hConv)
            Case $XTYP_WILDCONNECT
                $res = Call($_DDEML_prefCallback & "WildConnect", _DdeQueryString($hsz1), _DdeQueryString($hsz2))

            ;Client/Server
            Case $XTYP_DISCONNECT
                $res = Call($_DDEML_prefCallback & "Disconnect", $hConv)
            Case $XTYP_ERROR
                $res = Call($_DDEML_prefCallback & "Error", $dwData1, $hConv)
            Case $XTYP_REGISTER
                $res = Call($_DDEML_prefCallback & "Register", _DdeQueryString($hsz1), _DdeQueryString($hsz2))
            Case $XTYP_UNREGISTER
                $res = Call($_DDEML_prefCallback & "Unregister", _DdeQueryString($hsz1), _DdeQueryString($hsz2))

        EndSwitch
    EndIf
    If 1 = @error Then
        ConsoleWrite("DDE callback function of type " & $uType & " not found, returning default" & @CRLF)
        Switch BitAnd($uType, $XCLASS_MASK)
            Case $XCLASS_BOOL
                $res = 0
            Case $XCLASS_DATA
                $res = 0
            Case $XCLASS_FLAGS
                $res = $DDE_FNOTPROCESSED
            Case $XCLASS_NOTIFICATION
                $res = 0
        EndSwitch
    EndIf
    ConsoleWrite("_DdeCallback()=" & $res & @CRLF)
    Return $res
EndFunc

;===============================================================================
; Function Name:   _DdeGetLastError
; Description:     The _DdeGetLastError function returns the most recent error code
;                  set by the failure of a Dynamic Data Exchange Management Library
;                  (DDEML) function and resets the error code to DMLERR_NO_ERROR.
;
; Parameter(s):    none
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is the last error
;                  code. Following are the possible DDEML error codes:
;
; $DMLERR_ADVACKTIMEOUT         A request for a synchronous advise transaction
;                               has timed out.
; $DMLERR_BUSY                  The response to the transaction caused the
;                               DDE_FBUSY flag to be set.
; $DMLERR_DATAACKTIMEOUT        A request for a synchronous data transaction has
;                               timed out.
; $DMLERR_DLL_NOT_INITIALIZED   A DDEML function was called without first
;                               calling the DdeInitialize function, or an
;                               invalid instance identifier was passed
;                               to a DDEML function.
; $DMLERR_DLL_USAGE             An application initialized as APPCLASS_MONITOR
;                               has attempted to perform a dynamic data exchange
;                               (DDE) transaction, or an
;                               application initialized as APPCMD_CLIENTONLY has
;                               attempted to perform server transactions.
; $DMLERR_EXECACKTIMEOUT        A request for a synchronous execute transaction
;                               has timed out.
; $DMLERR_INVALIDPARAMETER      A parameter failed to be validated by the DDEML.
;                               Some of the possible causes follow:
;                                    The application used a data handle
;                                    initialized with a different item name
;                                    handle than was required by the
;                                    transaction.
;
;                                    The application used a data handle that was
;                                    initialized with a different clipboard data
;                                    format than was required by the transaction.
;
;                                    The application used a client-side
;                                    conversation handle with a server-side
;                                    function or vice versa.
;
;                                    The application used a freed data handle or
;                                    string handle.
;
;                                    More than one instance of the application
;                                    used the same object.
;
; $DMLERR_LOW_MEMORY            A DDEML application has created a prolonged race
;                               condition (in which the server application
;                               outruns the client), causing large amounts of
;                               memory to be consumed.
; $DMLERR_MEMORY_ERROR          A memory allocation has failed.
; $DMLERR_NO_CONV_ESTABLISHED   A client's attempt to establish a conversation
;                               has failed.
; $DMLERR_NOTPROCESSED          A transaction has failed.
; $DMLERR_POKEACKTIMEOUT        A request for a synchronous poke transaction has
;                               timed out.
; $DMLERR_POSTMSG_FAILED        An internal call to thePostMessage function has
;                               failed.
; $DMLERR_REENTRANCY            An application instance with a synchronous
;                               transaction already in progress attempted to
;                               initiate another synchronous transaction, or
;                               the DdeEnableCallback function was called from
;                               within a DDEML callback function.
; $DMLERR_SERVER_DIED           A server-side transaction was attempted on a
;                               conversation terminated by the client, or the
;                               server terminated before completing a transaction.
; $DMLERR_SYS_ERROR             An internal error has occurred in the DDEML.
; $DMLERR_UNADVACKTIMEOUT       A request to end an advise transaction has timed
;                               out.
; $DMLERR_UNFOUND_QUEUE_ID      An invalid transaction identifier was passed to
;                               a DDEML function. Once the application has
;                               returned from an XTYP_XACT_COMPLETE callback,
;                               the transaction identifier for that callback
;                               function is no longer valid.
;
; Author(s):       doudou
;===============================================================================
Func _DdeGetLastError()
    Local $res = DllCall("user32.dll", "uint", "DdeGetLastError", "dword", $_DDEML_idInst)
    Return $res[0]
EndFunc

; DLL registration functions ;

;===============================================================================
; Function Name:   _DdeInitialize
; Description:     The _DdeInitialize function registers an application with the
;                  Dynamic Data Exchange Management Library (DDEML). An
;                  application must call this function before calling any other
;                  DDEML function.
;
; Parameter(s):    $sCallbackPref - string prefix for transaction callbacks, f.i.
;                                   "OnDDE_"
;                  $dwCmd - Specifies a set of APPCMD_, CBF_, and MF_ flags. The
;                           APPCMD_ flags provide special instructions to
;                           DdeInitialize. The CBF_ flags specify filters that
;                           prevent specific types of transactions from reaching
;                           the callback function. The MF_ flags specify the
;                           types of DDE activity that a DDE monitoring
;                           application monitors. Using these flags enhances the
;                           performance of a DDE application by eliminating
;                           unnecessary calls to the callback function.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is DMLERR_NO_ERROR.
;
;                  If the function fails, the return value is one of the
;                  following values:
;
;                  $DMLERR_DLL_USAGE
;                  $DMLERR_INVALIDPARAMETER
;                  $DMLERR_SYS_ERROR
;
;
; Author(s):       doudou
;===============================================================================
Func _DdeInitialize($sCallbackPref, $dwCmd)
    If $_DDEML_idInst Then
        ConsoleWrite("DDEML already initialized" & @CRLF)
        Return $DMLERR_NO_ERROR
    EndIf
    If $_DDEML_hDdeCallback Then DllCallbackFree($_DDEML_hDdeCallback)
    $_DDEML_hDdeCallback = DllCallbackRegister("_DdeCallback", "ptr", $_DDEML_typdef_DdeCallback)
    If 0 = $_DDEML_hDdeCallback Then
        ConsoleWrite("Failed to register DDE callback" & @CRLF)
        Return $DMLERR_SYS_ERROR
    EndIf
    $_DDEML_prefCallback = $sCallbackPref

    Local $pid = DllStructCreate("dword idInst")
    DllStructSetData($pid, "idInst", 0)
    Local $sFunc = "DdeInitializeA"
    If $_DDEML_UNICODE Then $sFunc = "DdeInitializeW"
    Local $res = DllCall("user32.dll", "uint", $sFunc, "ptr", DllStructGetPtr($pid, 1), "ptr", DllCallbackGetPtr($_DDEML_hDdeCallback), "uint", $dwCmd, "uint", 0)
    ConsoleWrite("_DdeInitialize()=" & $res[0] & ", pid=" & DllStructGetData($pid, 1) & @CRLF)
    If $DMLERR_NO_ERROR = $res[0] Then
        $_DDEML_idInst = DllStructGetData($pid, 1)
    ElseIf $_DDEML_hDdeCallback Then
        DllCallbackFree($_DDEML_hDdeCallback)
        $_DDEML_hDdeCallback = 0
    EndIf
    $pid = 0
    Return $res[0]
EndFunc

;===============================================================================
; Function Name:   _DdeUninitialize
; Description:     The _DdeUninitialize function frees all Dynamic Data Exchange
;                  Management Library (DDEML) resources associated with the
;                  calling application.
;
; Parameter(s):    none
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeUninitialize()
    Local $res = DllCall("user32.dll", "int", "DdeUninitialize", "dword", $_DDEML_idInst)
    $_DDEML_idInst = 0
    If $_DDEML_hDdeCallback Then DllCallbackFree($_DDEML_hDdeCallback)
    $_DDEML_hDdeCallback = 0

    ConsoleWrite("_DdeUninitialize()=" & $res[0] & @CRLF)
    If $res[0] Then Return True
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeIsInitialized
; Description:     The _DdeIsInitialized function returns the status of DDEML.
;
; Parameter(s):    none
;
; Return Value(s): True if _DdeInitialize() was previously executed successfully,
;                  otherwise the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeIsInitialized()
    Return (0 <> $_DDEML_idInst) And (0 <> $_DDEML_hDdeCallback)
EndFunc

; conversation control functions ;

;===============================================================================
; Function Name:   _DdeDisconnect
; Description:     The _DdeDisconnect function terminates a conversation started
;                  by either the DdeConnect or DdeConnectList function and
;                  invalidates the specified conversation handle.
;
; Parameter(s):    $hConv - Handle to the active conversation to be terminated.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeDisconnect($hConv)
    Local $res = DllCall("user32.dll", "int", "DdeDisconnect", $_DDEML_HANDLETYPE, $hConv)
    ConsoleWrite("_DdeDisconnect(" & $hConv & ")=" & $res[0] & @CRLF)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeQueryConvInfo
; Description:     The _DdeQueryConvInfo function obtains information about a
;                  dynamic data exchange (DDE) transaction and about the
;                  conversation in which the transaction takes place.
;
; Parameter(s):    $hConv - Handle to the conversation.
;                  $dwTransAct - Specifies the transaction. For asynchronous
;                                transactions, this parameter should be a transaction
;                                identifier returned by the _DdeClientTransaction
;                                function. For synchronous transactions, this
;                                parameter should be $QID_SYNC.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is CONVINFO DLL structure.
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeQueryConvInfo($hConv, $dwTransAct)
    Local $pConv = DllStructCreate($_DDEML_typdef_CONVINFO)
    Local $res = DllCall("user32.dll", "uint", "DdeQueryConvInfo", $_DDEML_HANDLETYPE, $hConv, "dword", $dwTransAct, "ptr", DllStructGetPtr($pConv))
    If $res[0] Then Return $pConv

    SetError(_DdeGetLastError())
    Return 0
EndFunc

; data transfer functions ;

;===============================================================================
; Function Name:   _DdeCreateStringHandle
; Description:     The _DdeCreateStringHandle function creates a handle that
;                  identifies the string pointed to by the psz parameter.
;                  A dynamic data exchange (DDE) client or server application can
;                  pass the string handle as a parameter to other Dynamic Data
;                  Exchange Management Library (DDEML) functions.
;
; Parameter(s):    $sz - String for which a handle is to be created. This string
;                        may be up to 255 characters. The reason for this limit
;                        is that DDEML string management functions are implemented
;                        using global atoms.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is a string handle.
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeCreateStringHandle($sz)
    Local $cp = $CP_WINANSI
    Local $sFunc = "DdeCreateStringHandleA"
    Local $strType = "str"
    If $_DDEML_UNICODE Then
        $sFunc = "DdeCreateStringHandleW"
        $cp = $CP_WINUNICODE
        $strType = "wstr"
    EndIf
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, $sFunc, "dword", $_DDEML_idInst, $strType, $sz, "int", $cp)
    If 0 = $res[0] Then SetError(_DdeGetLastError())
    Return $res[0]
EndFunc

;===============================================================================
; Function Name:   _DdeFreeStringHandle
; Description:     The _DdeFreeStringHandle function frees a string handle in the
;                  calling application.
;
; Parameter(s):    $hsz - Handle to the string handle to be freed. This handle
;                         must have been created by a previous call to the
;                         _DdeCreateStringHandle function.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeFreeStringHandle($hsz)
    Local $res = DllCall("user32.dll", "int", "DdeFreeStringHandle", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hsz)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeKeepStringHandle
; Description:     The _DdeKeepStringHandle function increments the usage count
;                  associated with the specified handle. This function enables
;                  an application to save a string handle passed to the application's
;                  dynamic data exchange (DDE) callback function. Otherwise,
;                  a string handle passed to the callback function is deleted
;                  when the callback function returns. This function should also
;                  be used to keep a copy of a string handle referenced by the
;                  CONVINFO structure returned by the _DdeQueryConvInfo function.
;
; Parameter(s):    $hsz - Handle to the string handle to be saved.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeKeepStringHandle($hsz)
    Local $res = DllCall("user32.dll", "int", "DdeKeepStringHandle", "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hsz)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeQueryString
; Description:     The _DdeQueryString function copies text associated with
;                  a string handle into a buffer.
;
; Parameter(s):    $hsz - Handle to the string to copy. This handle must have
;                         been created by a previous call to the
;                         _DdeCreateStringHandle function.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is the queried string.
;                  If the function fails, the return value is "".
;
; Author(s):       doudou
;===============================================================================
Func _DdeQueryString($hsz)
    Local $cp = $CP_WINANSI
    Local $sFunc = "DdeQueryStringA"
    Local $strType = "str"
    If $_DDEML_UNICODE Then
        $sFunc = "DdeQueryStringW"
        $cp = $CP_WINUNICODE
        $strType = "wstr"
    EndIf
    Local $res = DllCall("user32.dll", "dword", $sFunc, "dword", $_DDEML_idInst, $_DDEML_HANDLETYPE, $hsz, $strType, "", "dword", 32768, "int", $cp)
    If $res[0] Then Return $res[3]

    SetError(_DdeGetLastError(), $res[0])
    Return ""
EndFunc

;===============================================================================
; Function Name:   _DdeCreateDataHandle
; Description:     The _DdeCreateDataHandle function creates a dynamic data
;                  exchange (DDE) object and fills the object with data from
;                  the specified buffer. A DDE application uses this function
;                  during transactions that involve passing data to the partner
;                  application.
;
; Parameter(s):    $data - Buffer that contains data to be copied to the DDE object.
;                  $afCmd (optiona) - Specifies the creation flags. This parameter
;                                      can be $HDATA_APPOWNED, which specifies that
;                                      the server application calling the
;                                      _DdeCreateDataHandle function owns the data
;                                      handle this function creates. This flag
;                                      enables the application to share the data
;                                      handle with other Dynamic Data Exchange
;                                      Management Library (DDEML) applications
;                                      rather than creating a separate handle to
;                                      pass to each application. If this flag is
;                                      specified, the application must eventually
;                                      free the shared memory object associated
;                                      with the handle by using the _DdeFreeDataHandle
;                                      function. If this flag is not specified,
;                                      the handle becomes invalid in the application
;                                      that created the handle after the data
;                                      handle is returned by the application's
;                                      DDE callback function or is used as a
;                                      parameter in another DDEML function.
;                  $hszItem (optional) - Handle to the string that specifies the
;                                        data item corresponding to the DDE object.
;                                        This handle must have been created by a
;                                        previous call to the _DdeCreateStringHandle
;                                        function. If the data handle is to be
;                                        used in an $XTYP_EXECUTE transaction,
;                                        this parameter must be 0.
;                  $wFmt (optional) - Specifies the standard clipboard format of the data.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is a data handle.
;                  If the function fails, the return value is 0.
;
; Author(s):       doudou
;===============================================================================
Func _DdeCreateDataHandle($data, $afCmd = 0, $hszItem = 0, $wFmt = $CF_TEXT)
    Local $pData, $cb
    If $CF_TEXT = $wFmt And $_DDEML_UNICODE Then $wFmt = $CF_TEXT
    $cb = _DDEML_CreateDataStruct($data, $pData, $wFmt)
    Local $res = DllCall("user32.dll", $_DDEML_HANDLETYPE, "DdeCreateDataHandle", "dword", $_DDEML_idInst, "ptr", DllStructGetPtr($pData, 1), "dword", $cb, "dword", 0, $_DDEML_HANDLETYPE, $hszItem, "uint", $wFmt, "uint", $afCmd)
    If 0 = $res[0] Then SetError(_DdeGetLastError())
    Return $res[0]
EndFunc

;===============================================================================
; Function Name:   _DdeFreeDataHandle
; Description:     The _DdeFreeDataHandle function frees a dynamic data exchange
;                  (DDE) object and deletes the data handle associated with the
;                  object.
;
; Parameter(s):    $hData - Handle to the DDE object to be freed. This handle
;                            must have been created by a previous call to the
;                            _DdeCreateDataHandle function or returned by the
;                            _DdeClientTransaction function.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is True.
;                  If the function fails, the return value is False.
;
; Author(s):       doudou
;===============================================================================
Func _DdeFreeDataHandle($hData)
    Local $res = DllCall("user32.dll", "int", "DdeFreeDataHandle", $_DDEML_HANDLETYPE, $hData)
    If $res[0] Then Return True

    SetError(_DdeGetLastError())
    Return False
EndFunc

;===============================================================================
; Function Name:   _DdeGetDataAsString
; Description:     The _DdeGetDataAsString copies string representation of data
;                  from the specified dynamic data exchange (DDE) object to the
;                  local buffer.
;
; Parameter(s):    $hData - Handle to the DDE object that contains the data to copy.
;
; Requirement(s):  External:   user32.dll (it's already in system32).
;
; Return Value(s): If the function succeeds, the return value is the data string.
;                  If the function fails, the return value is "".
;
; Author(s):       doudou
;===============================================================================
Func _DdeGetDataAsString($hData, $wFmt = 0)
    Local $strType = "str"
    If $CF_UNICODETEXT = $wFmt Then $strType = "wstr"
    Local $res = DllCall("user32.dll", "dword", "DdeGetData", $_DDEML_HANDLETYPE, $hData, $strType, "", "dword", 32768, "dword", 0)
    If $res[0] Then Return $res[2]
    SetError(_DdeGetLastError(), $res[0])
    Return ""
EndFunc

; helper functions ;

Func _DDEML_CreateDataStruct($data, ByRef $pStruct, $wFmt = $CF_TEXT)
    Local $res = 0
    Select
        Case IsInt($data) And $CF_TEXT <> $wFmt And $CF_OEMTEXT <> $wFmt And $CF_UNICODETEXT <> $wFmt
            $res = 32
            If @CPUArch = "IA64" Or @CPUArch = "X64" Then $res = 64
            If 32 < $res Then
                $pStruct = DllStructCreate("int64")

            Else
                $pStruct = DllStructCreate("int")
				MsgBox(0, "$hData",'Did I get here?')
            EndIf
            DllStructSetData($pStruct, 1, $data)

        Case IsFloat($data) And $CF_TEXT <> $wFmt And $CF_OEMTEXT <> $wFmt And $CF_UNICODETEXT <> $wFmt
            $res = 64
            $pStruct = DllStructCreate("double")
            DllStructSetData($pStruct, 1, $data)

        Case IsBinary($data)
            $res = BinaryLen($data)
            $pStruct = DllStructCreate("byte[" & $res & "]")
            DllStructSetData($pStruct, 1, $data)

        Case IsDllStruct($data)
            $res = DllStructGetSize($data)
            $pStruct = $data

        Case IsArray($data) Or IsObj($data)
            ; TODO
            SetError($DMLERR_INVALIDPARAMETER)
            ConsoleWrite("_DDEML_CreateDataStruct: data type not yet supported" & @CRLF)
            Return 0

        Case Else
            Local $s = String($data)
            $res = StringLen($s) + 1
            If $CF_UNICODETEXT = $wFmt Then
                $pStruct = DllStructCreate("wchar[" & $res & "]")
            Else
                $pStruct = DllStructCreate("char[" & $res & "]")
            EndIf
            $res = DllStructGetSize($pStruct)
            DllStructSetData($pStruct, 1, $s)
    EndSelect

    Return $res
EndFunc
