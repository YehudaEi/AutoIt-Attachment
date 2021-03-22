;==============================================
; Local Proxy Filter v0.9b
; Final Release: December 13, 2013 by ripdad
; Description: Allows only URL's in whitelist
;==============================================
;
#include 'ZLIB.au3'; download here --> http://www.autoitscript.com/forum/topic/128962-zlib-deflateinflategzip-udf/
;
;<-[setup and check]
TraySetIcon('shell32.dll', 19)
Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)
;
Local Const $sTitle = 'Local Proxy Filter v0.9b'
;
If Not TCPStartup() Then
    Exit MsgBox(8208, $sTitle, 'Error: TCPStartup' & @TAB, 5)
EndIf
;
Local Const $strIP = @IPAddress1; <-- Local IP Address
Local Const $nPort = 8080;        <-- Local Port Number (8080 is the standard setting)
;
Local Const $Connection = TCPListen($strIP, $nPort)
If @error Or $Connection = -1 Then
    TCPShutdown()
    Exit MsgBox(8208, $sTitle, 'Cannot Listen On IP/Port' & @TAB, 5)
EndIf
;
Local $AutoProxy = 0; <-- 1=Yes, 0=No (default)
;
If $AutoProxy Then; FF and IE
    _REG_ProxySettings(1)
EndIf
;
;<-[declarations]
Local Const $GUI_CHECKED = 1, $GUI_UNCHECKED = 4, $GUI_FOCUS = 256
Local Const $GUI_EVENT_CLOSE = -3, $sEOF = @CRLF & @CRLF
;
Local $nBrowserSocket, $sBrowserHeader, $WhiteList = 1
Local $sHost, $Cookies = 0, $Referer = 0, $Scripts = 0
Local $nRetry = 0, $rtn = 0, $nMsecs = 250
;
Local $sPattern_BlackList = _SRE_GetBlackList()
Local $sPattern_WhiteList = _SRE_GetWhiteList()
;
;<-[gui]
Local $ID_GUI = GUICreate($sTitle & '  -  IP: ' & $strIP & '  -  Port: ' & $nPort, 528, 250)
GUISetIcon(@WindowsDir & '\system32\shell32.dll', 19, $ID_GUI)
GUISetFont(8.5, -1, -1, 'microsoft sans serif')
Local $ID_MEN = GUICtrlCreateMenu('Lists', -1)
Local $ID_BLT = GUICtrlCreateMenuItem('Blacklist', $ID_MEN)
Local $ID_WLT = GUICtrlCreateMenuItem('Whitelist', $ID_MEN)
Local $ID_EDT = GUICtrlCreateEdit('', 10, 5, 400, 210)
GUICtrlCreateGroup('Enable/Disable', 420, 0, 100, 180)
Local $ID_APX = GUICtrlCreateCheckbox('AutoProxy', 435, 25, 75, 22)
Local $ID_LST = GUICtrlCreateCheckbox('WhiteList', 435, 55, 75, 22)
Local $ID_SCR = GUICtrlCreateCheckbox('Scripts', 435, 85, 75, 22)
Local $ID_CKS = GUICtrlCreateCheckbox('Cookies', 435, 115, 75, 22)
Local $ID_RFR = GUICtrlCreateCheckbox('Referer', 435, 145, 75, 22)
Local $ID_CLR = GUICtrlCreateButton('Clear Window', 425, 190, 88, 25)
;gui config
If $AutoProxy Then
    GUICtrlSetState($ID_APX, $GUI_CHECKED)
Else
    GUICtrlSetState($ID_APX, $GUI_UNCHECKED)
EndIf
GUICtrlSetState($ID_LST, $GUI_CHECKED)
GUICtrlSetState($ID_SCR, $GUI_CHECKED)
GUICtrlSetState($ID_CKS, $GUI_CHECKED)
GUICtrlSetState($ID_RFR, $GUI_CHECKED)
;set events
GUISetOnEvent($GUI_EVENT_CLOSE, '_Minimize')
GUICtrlSetOnEvent($ID_CLR, '_Clear')
GUICtrlSetOnEvent($ID_APX, '_State')
GUICtrlSetOnEvent($ID_LST, '_State')
GUICtrlSetOnEvent($ID_SCR, '_State')
GUICtrlSetOnEvent($ID_CKS, '_State')
GUICtrlSetOnEvent($ID_RFR, '_State')
GUICtrlSetOnEvent($ID_BLT, '_EditList')
GUICtrlSetOnEvent($ID_WLT, '_EditList')
;init events
Local $oErrorHandler = ObjEvent('AutoIt.Error', 'ObjErrorHandler')
OnAutoItExitRegister('_Exit')
Opt('GUIOnEventMode', 1)
;show the gui
GUISetState(@SW_SHOW, $ID_GUI)
;
;<-[main loop]
While 1
    Do
        Sleep($nMsecs)
        $nBrowserSocket = TCPAccept($Connection); <- waiting on connection from browser
    Until ($nBrowserSocket > -1); <- drop out of loop when true
    ;
    For $i = 1 To 100; <- timeout/safeguard (scheme:1000 msec)
        $sBrowserHeader = TCPRecv($nBrowserSocket, 8192, 0); <- headers are usually less than 1024 bytes
        If StringInStr($sBrowserHeader, $sEOF) Then; <- usually catches on 1st or 2nd turn of the loop
            ExitLoop; <- exitloop once header is received - else timeout
        EndIf
        Sleep(10); <- part of timeout scheme
    Next
    ;
    If StringExists($sBrowserHeader) Then; <- else close socket
        If _IsAllowed($sBrowserHeader) Then; <- get request from header
            $rtn = _WinHttpRequest($sBrowserHeader)
        EndIf
        ;
        If ($rtn <> 1) Then
            If ($rtn == 0) Then
                $rtn = _HTML_Message('Unlisted: ' & $sHost)
            EndIf
            TCPSend($nBrowserSocket, $rtn)
        EndIf
    EndIf
    ;
    TCPCloseSocket($nBrowserSocket); <- end local connection
    AdlibRegister('_SetIdle', 10000)
    $sBrowserHeader = ''
    $nMsecs = 10
    $nRetry = 0
    $rtn = 0
WEnd
;
Func _IsAllowed($sBrowserHeader)
    $sHost = _GetHeaderValue($sBrowserHeader, 'HOST')
    If Not @extended Then Return 0
    If StringRegExp($sHost, $sPattern_BlackList) Then
        GUICtrlSetData($ID_EDT, GUICtrlRead($ID_EDT) & _DateTime() & 'Blacklisted - ' & $sHost & @CRLF)
        Return 0
    EndIf
    If Not $WhiteList Then Return 1
    If StringRegExp($sHost, $sPattern_WhiteList) Then Return 1
    GUICtrlSetData($ID_EDT, GUICtrlRead($ID_EDT) & _DateTime() & 'Unlisted - ' & $sHost & @CRLF)
    Return 0
EndFunc
;
;==================================================================================
; WinHttpRequest object:
; http://msdn.microsoft.com/en-us/library/windows/desktop/aa384106(v=vs.85).aspx
;==================================================================================
Func _WinHttpRequest($sBrowserHeader)
    Local $sMethod = StringLeft($sBrowserHeader, StringInStr($sBrowserHeader, ' ') - 1)
    If Not StringMatch($sMethod, 'GET|HEAD|POST') Then
        Return _HTTP_Status('501', 'Not Implemented')
    EndIf
    ;
    Local $sURL = StringRegExpReplace($sBrowserHeader, '(?is).*\s(.*?)\sHTTP\/1.*', '\1')
    If Not @extended Then
        Return _HTTP_Status('404', 'Not Found')
    EndIf
    ;
    If StringInStr($sURL, 'https:') Or StringInStr($sURL, ':443') Then
        GUICtrlSetData($ID_EDT, GUICtrlRead($ID_EDT) & _DateTime() & 'Not Supported: HTTPS - ' & $sURL & @CRLF)
        Return _HTTP_Status('404', 'Not Found')
    EndIf
    ;
    Local $sFile = StringRegExpReplace($sURL, '(.*\/)', '')
    If StringInStr($sFile, '?') Then
        $sFile = StringRegExpReplace($sFile, '(\?.*)', '')
    EndIf
    ;
    ;===========================================================================================
    ; extension filter examples
    If StringExists($sFile) Then
        If ($Scripts = 0) And (StringRight($sFile, 3) = '.js') Then
            Return _HTTP_Status('404', 'Not Found')
        ElseIf (StringRight($sFile, 4) = '.exe') Then
            If MsgBox(8228, 'Security Prompt', 'Download this file?' & @CRLF & $sURL & @TAB) <> 6 Then
                Return _HTML_Message('Download Canceled')
            EndIf
        EndIf
    EndIf
    ;===========================================================================================
    ;
    Local $objWinHttp = ObjCreate('WinHttp.WinHttpRequest.5.1')
    If @error Or Not IsObj($objWinHttp) Then
        Return 0
    EndIf
    ;
    $objWinHttp.Open($sMethod, $sURL)
    If @error Then
        $objWinHttp = ''; <-- destroy object
        Return 0
    EndIf
    ;
    $objWinHttp.SetTimeouts('5000', '5000', '10000', '10000'); ResolveTimeout, ConnectTimeout, SendTimeout, ReceiveTimeout
    ;
    ;===========================================================================================
    ; http://social.technet.microsoft.com/Forums/scriptcenter/en-US/e4060bcf-1041-4c7f-b0d4-b40f8b5402d6/retrieve-http-status-code?forum=ITCG
    $objWinHttp.Option(0) = 'http_requester/0.1'; UserAgentString (default:registry setting)
    $objWinHttp.Option(4) = '13056'; SslErrorIgnoreFlags (13056:ignore all) (default:0)
    $objWinHttp.Option(6) = 'True'; EnableRedirects (default:True)
    $objWinHttp.Option(12) = 'True'; EnableHttpsToHttpRedirects (default:False)
    ;===========================================================================================
    ;
    Local $sValue, $sPostData = ''
    Local $a = StringSplit('Accept|Accept-Charset|Accept-Encoding|Accept-Language|Cache-Control|Content-Length|Content-Type|Cookie|If-None-Match|If-Modified-Since|Referer', '|')
    ;
    For $i = 1 To $a[0]
        $sValue = _GetHeaderValue($sBrowserHeader, $a[$i])
        If @extended Then
            Switch $a[$i]
                Case 'Cookie'
                    If ($Cookies = 0) Then ContinueLoop
                Case 'Referer'
                    If ($Referer = 0) Then ContinueLoop
                Case 'Content-Length'
                    If $sValue And StringMatch($sMethod, 'POST') Then;<-- form types (not for upload)
                        $sPostData = StringTrimLeft($sBrowserHeader, StringInStr($sBrowserHeader, $sEOF) + 3)
                    EndIf
                Case Else
            EndSwitch
            $objWinHttp.SetRequestHeader($a[$i], $sValue)
        EndIf
    Next
    ;
    ;===========================================================================================
    $objWinHttp.Send($sPostData); send header/data to remote address
    If @error Then; usually "time-out" or "unable to connect"
        $objWinHttp = ''
        If $nRetry = 0 Then; try one more time
            $nRetry = 1
            Return _WinHttpRequest($sBrowserHeader)
        Else
            Return 0
        EndIf
    EndIf
    ;
    Local $sRemoteHeader = $objWinHttp.GetAllResponseHeaders
    If Not StringExists($sRemoteHeader) Then
        $objWinHttp = ''
        Return 0
    EndIf
    ;
    Local $nStatus = $objWinHttp.Status
    Local $sStatus = $objWinHttp.StatusText
    Local $nLength = _GetHeaderValue($sRemoteHeader, 'Content-Length')
    ;
    ; since the socket is closed at the main loop, we'll change this from keep-alive to close
    $sRemoteHeader = StringReplace($sRemoteHeader, 'Connection: keep-alive', 'Connection: close')
    $sRemoteHeader = _RemoveHeaderItem($sRemoteHeader, 'Keep-Alive');<-- remove second tag, if exist
    ;
    ; process cookies option
    If ($Cookies = 0) Then $sRemoteHeader = _RemoveHeaderItem($sRemoteHeader, 'Set-Cookie')
    ;
    ; we have to remove this entry, else the browser will croak. (the data has already been transferred)
    $sRemoteHeader = _RemoveHeaderItem($sRemoteHeader, 'Transfer-Encoding'); ex: Transfer-Encoding: chunked
    ;===========================================================================================
    ;
    ; send remote header to browser. (object quirk -- we have to Re-Add the first line to the header)
    TCPSend($nBrowserSocket, 'HTTP/1.1 ' & $nStatus & ' ' & $sStatus & @CRLF & $sRemoteHeader)
    If @error Or Not $nLength Then
        $objWinHttp = ''
        Return 1; close socket at main loop
    EndIf
    ;
    Local $sResponseBody = $objWinHttp.ResponseBody
    $objWinHttp = '';<-- end of the line for this object
    If Not StringExists($sResponseBody) Then Return 0; no content
    ;
    ;===========================================================================================
    If StringInStr(_GetHeaderValue($sRemoteHeader, 'Content-Type'), 'text') Then
        $sValue = _GetHeaderValue($sRemoteHeader, 'Content-Encoding')
        If StringInStr($sValue, 'gzip') Then
            $sResponseBody = _ZLIB_GZCompress(_ModifyOptions(_ZLIB_GZUncompress($sResponseBody)))
        ElseIf IsBinary($sResponseBody) Then
            $sResponseBody = _ModifyOptions($sResponseBody)
        EndIf
    EndIf
    ;===========================================================================================
    ;
    TCPSend($nBrowserSocket, $sResponseBody);<-- send contents to browser
    $sResponseBody = ''
    Return 1; close socket at main loop
EndFunc
;
Func _GetHeaderValue($str, $tag)
    $str = StringRegExpReplace($str, '(?is)(.*)' & $tag & ':\s(.*?)\r\n(.*)', '\2', 1)
    Return SetError(0, @extended, $str)
EndFunc
;
Func _RemoveHeaderItem($str, $tag)
    Return StringRegExpReplace($str, '(?is)(' & $tag & ':.*?\r\n)', '')
EndFunc
;
Func _ModifyOptions($str)
    $str = BinaryToString($str)
    If StringRegExp(StringLeft($str, 50), '(?is)(<\!doctype html)|(<html)') Then
        ;
        If ($Scripts = 0) Then; No Scripts or IFrames (example)
            $str = StringRegExpReplace($str, '(?is)(<script.*?</script>)|(<noscript.*?</noscript>)|(<iframe.*?</iframe>)', '')
        EndIf
        ;
    EndIf
    Return StringToBinary($str)
EndFunc
;
Func _HTTP_Status($nStatus, $sStatus)
    Local $sHeader = ''
    $sHeader &= 'HTTP/1.1 ' & $nStatus & ' ' & $sStatus & @CRLF
    $sHeader &= 'Server: LocalProxyFilter' & @CRLF
    $sHeader &= 'Connection: close' & @CRLF
    $sHeader &= 'Content-Length: 0' & $sEOF
    Return $sHeader
EndFunc
;
Func _HTML_Message($str)
    Local $sMsg = '<html><body><h2>' & $str & '</h2></body></html>' & @CRLF
    Local $sHeader = ''
    $sHeader &= 'HTTP/1.1 404 Not Found' & @CRLF
    $sHeader &= 'Server: LocalProxyFilter' & @CRLF
    $sHeader &= 'Connection: close' & @CRLF
    $sHeader &= 'Content-Type: text/html' & @CRLF
    $sHeader &= 'Content-Length: ' & StringLen($sMsg) & $sEOF
    $sHeader &= $sMsg
    Return $sHeader
EndFunc
;
Func _State()
    Local $nCopy = $AutoProxy
    $AutoProxy = Number(GUICtrlRead($ID_APX) = $GUI_CHECKED)
    $WhiteList = Number(GUICtrlRead($ID_LST) = $GUI_CHECKED)
    $Cookies = Number(GUICtrlRead($ID_CKS) = $GUI_CHECKED)
    $Referer = Number(GUICtrlRead($ID_RFR) = $GUI_CHECKED)
    $Scripts = Number(GUICtrlRead($ID_SCR) = $GUI_CHECKED)
    If ($AutoProxy <> $nCopy) Then
        _REG_ProxySettings($AutoProxy)
    EndIf
EndFunc
;
Func _EditList()
    Local $sList, $str
    Switch @GUI_CtrlId
        Case $ID_BLT
            $sList = 'BlackList'
            $str = _GetBlackList()
        Case $ID_WLT
            $sList = 'WhiteList'
            $str = _GetWhiteList()
        Case Else
            Return
    EndSwitch
    ;
    Opt('GUIOnEventMode', 0)
    GUISetState(@SW_HIDE, $ID_GUI)
    Local $ID_GUI2 = GUICreate('Edit ' & $sList, 300, 260)
    GUISetFont(8.5, -1, -1, 'microsoft sans serif', $ID_GUI2)
    Local $ID_EDT2 = GUICtrlCreateEdit('', 5, 5, 290, 210)
    Local $ID_SAV = GUICtrlCreateButton('Save List', 110, 225, 80, 22)
    GUICtrlSetData($ID_EDT2, $str)
    GUISetState(@SW_SHOW, $ID_GUI2)
    GUICtrlSetState($ID_EDT2, $GUI_FOCUS)
    ;
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $ID_SAV
                $str = GUICtrlRead($ID_EDT2)
                If Not StringExists($str) Then ContinueLoop
                If MsgBox(8228, $sTitle, 'Overwrite Existing ' & $sList & '?' & @TAB) = 6 Then
                    Local $hFile = FileOpen(@ScriptDir & '\' & $sList & '.txt', 2)
                    If ($hFile <> -1) And FileWrite($hFile, $str) And FileClose($hFile) Then
                        MsgBox(8256, $sTitle, $sList & ' Saved!' & @TAB)
                        $sPattern_BlackList = _SRE_GetBlackList()
                        $sPattern_WhiteList = _SRE_GetWhiteList()
                    Else
                        MsgBox(8240, $sTitle, 'Cannot Save ' & $sList & '!' & @TAB)
                    EndIf
                    ExitLoop
                EndIf
                GUICtrlSetState($ID_EDT2, $GUI_FOCUS)
            Case Else
        EndSwitch
    WEnd
    GUIDelete($ID_GUI2)
    GUISetState(@SW_SHOW, $ID_GUI)
    Opt('GUIOnEventMode', 1)
EndFunc
;
Func _GetBlackList()
    Local $str = ''
    Local $sFile = @ScriptDir & '\Blacklist.txt'
    If Not FileExists($sFile) Then
        $str &= 'ads1.com|'; example
        $str &= 'ads2.com|'; example
        FileWrite($sFile, StringReplace($str, '|', @CRLF))
        Sleep(250)
    EndIf
    $str = FileRead($sFile)
    Return $str
EndFunc
;
Func _GetWhiteList()
    Local $str = ''
    Local $sFile = @ScriptDir & '\Whitelist.txt'
    If Not FileExists($sFile) Then
        $str &= 'autoitscript.com|'
        $str &= 'autoit-cdn.com|'
        $str &= 'yahoo.com|'
        $str &= 'yimg.com|'
        $str &= 'google.ro|'
        $str &= 'gstatic.com|'
        $str &= 'ezlan.net|'
        $str &= 'faqs.org|'
        $str &= 'php.net|'
        FileWrite($sFile, StringReplace($str, '|', @CRLF))
        Sleep(250)
    EndIf
    $str = FileRead($sFile)
    Return $str
EndFunc
;
Func _SRE_GetBlackList()
    Local $str = _GetBlackList()
    $str = StringStripWS($str, 3)
    $str = StringReplace($str, @CR, ')|')
    $str = StringReplace($str, @LF, '(')
    $str = '(?i)(' & $str & ')'
    Return $str
EndFunc
;
Func _SRE_GetWhiteList()
    Local $str = _GetWhiteList()
    $str = StringStripWS($str, 3)
    $str = StringReplace($str, @CR, ')|')
    $str = StringReplace($str, @LF, '(')
    $str = '(?i)(' & $str & ')'
    Return $str
EndFunc
;
Func _DateTime()
    Return ('[' & @MON & '-' & @MDAY & '-' & @YEAR & '  ' & @HOUR & ':' & @MIN & ':' & @SEC & ']  ')
EndFunc
;
Func _Minimize()
    GUISetState(@SW_MINIMIZE, $ID_GUI)
EndFunc
;
Func _Clear()
    GUICtrlSetData($ID_EDT, '')
EndFunc
;
; simple version
Func StringExists($s, $n = 30)
    Return StringLen(StringStripWS(StringLeft($s, $n), 8))
EndFunc
;
; simple version
Func StringMatch($s, $c, $d = '|')
    $s = StringLower($s)
    $c = StringLower($c)
    Local $a = StringSplit($c, $d, 1)
    ;
    For $i = 1 To $a[0]
        If ($s == $a[$i]) Then Return $i
    Next
EndFunc
;
Func _SetIdle()
    AdlibUnRegister('_SetIdle')
    $nMsecs = 250
EndFunc
;
Func ObjErrorHandler()
    GUICtrlSetData($ID_EDT, GUICtrlRead($ID_EDT) & _DateTime() & StringStripWS($oErrorHandler.Description, 7) & @CRLF)
    $oErrorHandler.Clear
    Return SetError(-1)
EndFunc
;
Func _REG_ProxySettings($nEnable)
    Local $sKey = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    If $nEnable Then
        RegWrite($sKey, 'ProxyServer', 'REG_SZ', $strIP & ':' & $nPort)
        If @error Then
            TCPShutdown()
            Exit MsgBox(8208, $sTitle, 'Cannot write to registry' & @TAB, 5)
        EndIf
        RegWrite($sKey, 'ProxyEnable', 'REG_DWORD', 1)
    Else
        RegWrite($sKey, 'ProxyEnable', 'REG_DWORD', 0); default: 0
        RegDelete($sKey, 'ProxyServer'); default: no valuename
    EndIf
EndFunc
;
Func _Exit()
    TCPShutdown()
    GUIDelete($ID_GUI)
    ;
    If $AutoProxy Then; Reset Default Values
        _REG_ProxySettings(0)
    EndIf
    ;
    Exit
EndFunc
;

