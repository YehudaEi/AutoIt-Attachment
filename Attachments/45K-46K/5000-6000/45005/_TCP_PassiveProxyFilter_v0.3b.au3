;==============================================
; TCP_PassiveProxyFilter.au3
; Initial Release: January 01, 2014 by ripdad
; Description: Allows only URL's in whitelist
;
; Requires: AutoIt v3.3.8.1+
; Updated : August 31, 2014
; Version : 0.3b
;==============================================
;
#NoTrayIcon
Opt('MustDeclareVars', 1)
Opt('WinWaitDelay', 0)
Opt('TrayMenuMode', 1)
;
Local $show = TrayCreateItem('Show')
Local $hide = TrayCreateItem('Hide')
TrayCreateItem('')
Local $exit = TrayCreateItem('Exit')
TrayItemSetOnEvent($show, '_Tray')
TrayItemSetOnEvent($hide, '_Tray')
TrayItemSetOnEvent($exit, '_Tray')
Local $sPathIcon = @WindowsDir & '\system32\shell32.dll'
TraySetIcon($sPathIcon, 19)
TraySetToolTip('PassiveProxyFilter')
TraySetState()
;
Local Const $sTitle = 'TCP_PassiveProxyFilter v0.3b'
;
If TCPStartup() <> 1 Then
    Exit MsgBox(8208, $sTitle, 'Error: TCPStartup' & @TAB, 5)
EndIf
;
Local Const $hWS2_32 = DllOpen(@WindowsDir & '\system32\ws2_32.dll')
If $hWS2_32 = -1 Then
    Exit MsgBox(8208, $sTitle, 'Error: ws2_32.dll' & @TAB, 5)
EndIf
;
Local Const $strIP = @IPAddress1; <-- Local IP Address
Local Const $nPort = 8080;        <-- Local Port Number (8080 is the standard setting)
;
Local Const $nConnection = TCPListen($strIP, $nPort, 100)
If @error Or $nConnection = -1 Then
    TCPShutdown()
    Exit MsgBox(8208, $sTitle, 'Cannot Listen On IP/Port' & @TAB, 5)
EndIf
;
Local $AutoProxyEnabled = 0; <================ 1=on, 0=off (default)
Local $FileCacheEnabled = 0; <================ 1=on, 0=off (default)
;
If $AutoProxyEnabled Then; FF and IE
    Local $RegDefaults[2]
    _REG_ProxySettings(1)
EndIf
;
If $FileCacheEnabled Then
    Local Const $sPathCache = @HomeDrive & '\ProxyCache\'
    Local Const $nPathCache = StringLen($sPathCache)
    If FileExists($sPathCache) <> 1 And DirCreate($sPathCache) <> 1 Then
        MsgBox(8208, $sTitle, 'Cannot Create File Cache Folder' & @TAB, 5)
        $FileCacheEnabled = 0
    EndIf
EndIf
;
Local Const $GUI_CHECKED = 1, $GUI_UNCHECKED = 4, $GUI_FOCUS = 256, $sEOF = @CRLF & @CRLF
Local $nAbort, $nLocalSocket, $nMsec = 250, $nTotalBytes = 0, $WhiteListActive = 1
Local $ShowDebug = 0, $ShowHeaders = 0, $Cookies = 1, $Referer = 1, $Scripts = 1
Local $sPattern_BlackList = _SRE_GetBlackList()
Local $sPattern_WhiteList = _SRE_GetWhiteList()
Local $aSocksCache[25][3]
;
DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 1)
;
;<-[gui]
Local $ID_GUI = GUICreate($sTitle, 528, 345, -1, -1, Default, 8)
GUISetFont(8.5, -1, -1, 'microsoft sans serif')
GUISetIcon($sPathIcon, 19, $ID_GUI)
Local $ID_MNU = GUICtrlCreateMenu('Menu', -1)
Local $ID_LT1 = GUICtrlCreateMenuItem('Blacklist', $ID_MNU)
Local $ID_LT2 = GUICtrlCreateMenuItem('Whitelist', $ID_MNU)
GUICtrlCreateMenuItem('', $ID_MNU)
Local $ID_DBG = GUICtrlCreateMenuItem('Show Debug', $ID_MNU)
Local $ID_HDR = GUICtrlCreateMenuItem('Show Headers', $ID_MNU)
GUICtrlCreateMenuItem('', $ID_MNU)
Local $ID_FCA = GUICtrlCreateMenuItem('File Cache Enable', $ID_MNU)
Local $ID_FCD = GUICtrlCreateMenuItem('File Cache Delete', $ID_MNU)
Local $ID_FCS = GUICtrlCreateMenuItem('File Cache Status', $ID_MNU)
Local $ID_EDT = GUICtrlCreateEdit('', 10, 5, 400, 260)
GUICtrlCreateGroup('Enable - Disable', 420, 0, 100, 152)
Local $ID_APX = GUICtrlCreateCheckbox('AutoProxy', 435, 22, 75, 22)
Local $ID_LST = GUICtrlCreateCheckbox('WhiteList', 435, 47, 75, 22)
Local $ID_SCR = GUICtrlCreateCheckbox('Scripts', 435, 72, 75, 22)
Local $ID_CKS = GUICtrlCreateCheckbox('Cookies', 435, 97, 75, 22)
Local $ID_RFR = GUICtrlCreateCheckbox('Referer', 435, 122, 75, 22)
GUICtrlCreateGroup('Indicators', 420, 156, 100, 55)
Local $ID_BTS = GUICtrlCreateLabel(0, 428, 174, 72, 18, 0x1201)
Local $ID_LBL = GUICtrlCreateLabel('', 503, 174, 10, 30, 0x1000)
GUICtrlSetBkColor($ID_LBL, 0x008000)
Local $ID_PBR = GUICtrlCreateProgress(428, 195, 72, 9, 0x01)
GUICtrlSetColor($ID_PBR, 0xBB0000)
Local $ID_ABT = GUICtrlCreateButton('Abort', 424, 217, 45, 22)
Local $ID_RST = GUICtrlCreateButton('Reset', 471, 217, 45, 22)
Local $ID_CLR = GUICtrlCreateButton('Clear Window', 424, 243, 92, 22)
GUICtrlCreateGroup('', 10, 270, 510, 45)
GUICtrlCreateLabel(@OSVersion & '_' & @OSArch, 17, 285, 120, 20, 0x1201)
GUICtrlCreateLabel('AutoIt v' & @AutoItVersion, 142, 285, 120, 20, 0x1201)
GUICtrlCreateLabel('IP: ' & $strIP, 267, 285, 120, 20, 0x1201)
GUICtrlCreateLabel('Port: ' & $nPort, 392, 285, 120, 20, 0x1201)
;config
If $AutoProxyEnabled Then
    GUICtrlSetState($ID_APX, $GUI_CHECKED)
EndIf
If $FileCacheEnabled Then
    GUICtrlSetState($ID_FCA, $GUI_CHECKED)
    GUICtrlSetOnEvent($ID_FCA, '_FileCacheEnable')
    GUICtrlSetOnEvent($ID_FCD, '_FileCacheDelete')
    GUICtrlSetOnEvent($ID_FCS, '_FileCacheStatus')
Else
    GUICtrlSetState($ID_FCA, 128); $GUI_DISABLE
    GUICtrlSetState($ID_FCD, 128)
    GUICtrlSetState($ID_FCS, 128)
EndIf
GUICtrlSetState($ID_LST, $GUI_CHECKED)
GUICtrlSetState($ID_SCR, $GUI_CHECKED)
GUICtrlSetState($ID_CKS, $GUI_CHECKED)
GUICtrlSetState($ID_RFR, $GUI_CHECKED)
GUICtrlSetOnEvent($ID_LT1, '_EditList')
GUICtrlSetOnEvent($ID_LT2, '_EditList')
GUICtrlSetOnEvent($ID_HDR, '_Headers')
GUICtrlSetOnEvent($ID_ABT, '_Abort')
GUICtrlSetOnEvent($ID_CLR, '_Clear')
GUICtrlSetOnEvent($ID_DBG, '_Debug')
GUICtrlSetOnEvent($ID_RST, '_Reset')
GUICtrlSetOnEvent($ID_APX, '_State')
GUICtrlSetOnEvent($ID_LST, '_State')
GUICtrlSetOnEvent($ID_SCR, '_State')
GUICtrlSetOnEvent($ID_CKS, '_State')
GUICtrlSetOnEvent($ID_RFR, '_State')
GUISetOnEvent(-3, '_Minimize')
OnAutoItExitRegister('_Exit')
Opt('TrayOnEventMode', 1)
Opt('GUIOnEventMode', 1)
GUISetState(@SW_SHOW, $ID_GUI)
;
;main loop
While 1
    Do
        Sleep($nMsec)
        $nLocalSocket = TCPAccept($nConnection)
    Until $nLocalSocket > 0
    ;
    $nMsec = 10
    AdlibUnRegister('_SetIdle')
    _TCP_LocalRequest($nLocalSocket)
    AdlibRegister('_SetIdle', 1000)
WEnd
;
Func _TCP_LocalRequest($nLocalSocket)
    Local $nExtended, $Init = 0, $nLength = 0
    Local $nError, $sRecv, $sRequest = ''
    ;
    For $i = 1 To 100
        $sRecv = _WSA_TCPRecv($nLocalSocket, 16384, 0)
        $nError = @error
        $nExtended = @extended
        ;
        If $nError Then
            If $ShowDebug Then
                _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
            EndIf
            ExitLoop
        ElseIf $Init Then
            If $nExtended Then
                $sRequest &= $sRecv
            Else
                ExitLoop
            EndIf
        ElseIf $nExtended Then
            $sRequest = $sRecv
            $nLength = _SRER($sRequest, 'GetValue', 'Content-Length')
            If @extended Then
                $Init = 1
            Else
                ExitLoop
            EndIf
        ElseIf $i = 100 Then
            $nError = 1; timed out
            ExitLoop
        EndIf
        Sleep($nMsec)
    Next
    ;
    Local $sHost = _SRER($sRequest, 'GetValue', 'HOST')
    If @extended And $nError = 0 Then
        ;==============================================================================
        If StringRegExp($sHost, $sPattern_BlackList) Then
            _StringDisplay('Blacklisted - ' & $sHost)
            $nError = 3; access denied
        ElseIf StringRegExp($sHost, $sPattern_WhiteList) Or Not $WhiteListActive Then
            Local $sMethod = StringLeft($sRequest, StringInStr($sRequest, ' ') - 1)
            If StringMatch($sMethod, 'GET|HEAD|POST') Then
                $sRequest = _SRER($sRequest, 'RemoveDomain'); <- required
                $sRequest = _SRER($sRequest, 'ReplaceValue', 'User-Agent', 'http_requester/0.1'); <- comment this line to use your browser's user-agent instead. (no need to insert it)
                $sRequest = _SRER($sRequest, 'ReplaceValue', 'Accept-Encoding', 'identity'); identity, gzip, deflate
                If $Referer = 0 Then $sRequest = _SRER($sRequest, 'RemoveTag', 'Referer')
                If $Cookies = 0 Then $sRequest = _SRER($sRequest, 'RemoveTag', 'Cookie')
                $sRequest = StringReplace($sRequest, 'Proxy-Connection', 'Connection')
                $sRequest = _SRER($sRequest, 'RemoveTag', 'DNT')
                _TCP_RemoteRequest($sRequest, $sHost, $sMethod)
                If @error Then $nError = 4; connection error
            Else
                $nError = 5; https not supported yet
            EndIf
        Else
            _StringDisplay('Unlisted - ' & $sHost)
            $nError = 6; unknown host
        EndIf
        ;==============================================================================
    Else
        $nError = 7; invalid header
    EndIf
    ;
    If $nError Then; let browser know that an error occurred
        _TCPSend($nLocalSocket, _HTML_Message('Cannot Connect: ' & $sHost, '503 Service Unavailable'))
    EndIf
    ;
    TCPCloseSocket($nLocalSocket)
    GUICtrlSetBkColor($ID_LBL, 0x008000); idle (dark green)
EndFunc
;
Func _TCP_RemoteRequest($sLocalHeader, $sHost, $sMethod)
    ;<-[file cache for supported extensions]
    If $FileCacheEnabled Then
        Local $IsFileCached = 0
        Local $sURL = _SRER($sLocalHeader, 'GetPath')
        If @extended And ($sMethod = 'GET') And StringRegExp($sURL, '(?i)\.(bmp|css|gif|ico|jpe|jpeg|jpg|png)') Then
            Local $sPath = StringLeft($sURL, StringInStr($sURL, '/', 0, -1))
            $sPath = $sPathCache & $sHost & _SRER($sPath, 'FriendlyPath')
            Local $sFile = _SRER($sURL, 'GetFileName')
            If @extended Then
                $sFile = _SRER($sFile, 'FriendlyFile')
                Local $sExt = _SRER($sFile, 'GetFileExt')
                If @extended And StringMatch($sExt, 'bmp|css|gif|ico|jpe|jpeg|jpg|png') Then
                    $sPath &= $sFile
                    If FileExists($sPath) Then
                        Local $hFile = FileOpen($sPath, 16)
                        If $hFile > 0 Then
                            _TCPSend($nLocalSocket, BinaryToString(FileRead($hFile)))
                            FileClose($hFile)
                            Return SetError(0)
                        EndIf
                    Else
                        $IsFileCached = 1
                        $sFile = ''
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
    ;
    ;<-[connect to remote]
    GUICtrlSetBkColor($ID_LBL, 0xFFFF00); (yellow)
    Local $nRemoteSocket = _SocksCache('GetRemoteSocket', -1, $sHost)
    If @error Then
        Return SetError(1)
    EndIf
    ;
    ;<-[send request to remote]
    _TCPSend($nRemoteSocket, $sLocalHeader)
    Local $nError = @error
    Local $nExtended = @extended
    ;
    If $nError Then
        If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
        Return SetError(2)
    EndIf
    GUICtrlSetBkColor($ID_LBL, 0x00FF00); active connection (bright green)
    ;
    ;<-[declarations]
    Local $sBody, $nBodyLen, $sRecv, $sRemoteHeader, $sValue
    Local $Init = 0, $IsHTML = 0, $RemoteClose = 0, $nTicks = 499
    Local $BytesSent = 0, $IsChunked = 0, $nCount = 0, $nLength = 0
    $nAbort = 0; global var
    ;
    ;<-[receive from remote and forward to browser]
    ;
    For $i = 1 To 500
        Sleep($nMsec)
        $sRecv = _WSA_TCPRecv($nRemoteSocket, 16384, 1)
        $nError = @error
        $nExtended = @extended
        ;
        If $nError Then
            If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
            ExitLoop
        ElseIf $Init And $i > $nTicks Then
            If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', Timeout, ' & $i)
            ExitLoop
        ElseIf $nExtended < 1 Then
            GUICtrlSetData($ID_PBR, ($i / $nTicks) * 100)
            ContinueLoop
        EndIf
        ;
        $sRecv = BinaryToString($sRecv)
        ;
        If $Init Then
            If $FileCacheEnabled And $IsFileCached Then
                $sFile &= $sRecv
            EndIf

            $BytesSent = _TCPSend($nLocalSocket, $sRecv)
            $nError = @error
            $nExtended = @extended
            ;
            If $nError Then
                If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
                ExitLoop
            EndIf
            ;
            $nBodyLen += $BytesSent
            $nTotalBytes += $BytesSent
        Else
            ; [separate header from body]
            $sRemoteHeader = StringLeft($sRecv, StringInStr($sRecv, $sEOF) + 3)
            $sBody = StringTrimLeft($sRecv, StringInStr($sRecv, $sEOF) + 3)
            ;
            ; [modify remote header]
            $sValue = _SRER($sRemoteHeader, 'GetValue', 'Connection')
            If @extended Then
                If StringMatch($sValue, 'close') Then
                    $RemoteClose = 1
                Else
                    $sRemoteHeader = _SRER($sRemoteHeader, 'ReplaceValue', 'Connection', 'close')
                    $sRemoteHeader = _SRER($sRemoteHeader, 'RemoveTag', 'Keep-Alive')
                EndIf
            EndIf
            ;
            If $Cookies = 0 Then
                $sRemoteHeader = _SRER($sRemoteHeader, 'RemoveTag', 'Set-Cookie')
            EndIf
            ;
            ; [determine if html source]
            $sValue = _SRER($sRemoteHeader, 'GetValue', 'Content-Type')
            If @extended And StringInStr($sValue, 'html') Then
                $IsHTML = 1
            EndIf
            ;
            ; [determine if chunked]
            $sValue = _SRER($sRemoteHeader, 'GetValue', 'Transfer-Encoding')
            If @extended And StringInStr($sValue, 'chunked') Then
                $sRemoteHeader = _SRER($sRemoteHeader, 'RemoveTag', 'Transfer-Encoding')
                $IsChunked = 1
            EndIf
            ;
            ; [get size of body from remote header - if available]
            $sValue = _SRER($sRemoteHeader, 'GetValue', 'Content-Length')
            If @extended Then $nLength = Number($sValue)
            ;
            ; [get remainder of remote source]
            If $IsChunked Or $IsHTML Then
                For $j = 1 To 200
                    Sleep($nMsec)
                    $sRecv = _WSA_TCPRecv($nRemoteSocket, 16384, 1)
                    $nError = @error
                    $nExtended = @extended
                    ;
                    If $nError Then
                        If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
                        If $nError <> -2 Then ExitLoop 2
                        ExitLoop
                    ElseIf $nExtended > 0 Then
                        $sRecv = BinaryToString($sRecv)
                        If $IsChunked Then
                            $sBody &= StringReplace($sRecv, @CRLF & '0' & $sEOF, '')
                            If @extended Then ExitLoop
                        Else
                            $sBody &= $sRecv
                            If StringLen($sBody) = $nLength Then ExitLoop
                        EndIf
                        $j = 0
                    EndIf
                Next
                ;
                If $IsChunked Then
                    Local $aChunked = StringSplit($sBody, @CRLF, 1)
                    $sBody = ''
                    ;
                    For $j = 1 To $aChunked[0]
                        If StringExists(StringLeft($aChunked[$j], 20)) Then
                            Dec(StringLeft($aChunked[$j], 20))
                            If @error Then
                                $sBody &= $aChunked[$j]
                            EndIf
                        Else
                            $sBody &= @CRLF
                        EndIf
                    Next
                EndIf
            EndIf
            ;
            If StringExists(StringLeft($sBody, 20)) Then
                If $IsHTML Then
                    $sBody = StringRegExpReplace($sBody, '(?is)(\v)', @CRLF)
                    $sBody = StringReplace($sBody, @TAB, ' ')
                    ;
                    If $Scripts = 0 Then
                        $sBody = _SRER($sBody, 'NoScripts')
                    EndIf
                    ;
                    Local $a = StringSplit($sBody, @CRLF, 1)
                    $sBody = ''
                    ;
                    For $i = 1 To $a[0]
                        If StringExists($a[$i]) Then
                            $sBody &= StringStripWS($a[$i], 7) & @CRLF
                        EndIf
                    Next
                    $sBody &= @CRLF
                EndIf
                ;
                $nBodyLen = StringLen($sBody)
                ;
                If $IsChunked Or $IsHTML Then
                    If $nLength > 0 Then
                        $sRemoteHeader = _SRER($sRemoteHeader, 'ReplaceValue', 'Content-Length', $nBodyLen)
                    Else
                        $sRemoteHeader = _SRER($sRemoteHeader, 'AddValue', 'Content-Type', 'Content-Length: ' & $nBodyLen & @CRLF)
                    EndIf
                    $nLength = $nBodyLen
                EndIf
            Else
                $sBody = ''
            EndIf
            ;
            ; [view headers]
            If $ShowHeaders Then
                _StringDisplay('----------' & @CRLF & $sLocalHeader & $sRemoteHeader)
            EndIf
            ;
            If $FileCacheEnabled And $IsFileCached Then
                $sFile = $sRemoteHeader & $sBody
            EndIf
            ;
            $BytesSent = _TCPSend($nLocalSocket, $sRemoteHeader & $sBody)
            $nError = @error
            $nExtended = @extended
            $nTotalBytes += $BytesSent
            ;
            If $nError Then
                If $ShowDebug Then _StringDisplay(@ScriptLineNumber & ', ' & $nError & ', ' & $nExtended)
                ExitLoop
            ElseIf $IsChunked Or $IsHTML Or ($nBodyLen == $nLength) Then
                ExitLoop
            Else
                $sValue = _SRER($sRemoteHeader, 'GetStatus')
                If ($sValue <> '200') And ($nLength = 0) Then
                    ExitLoop
                EndIf
            EndIf
            $Init = 1
        EndIf
        ;
        If $nAbort Or $nBodyLen = $nLength Then
            ExitLoop
        ElseIf $nCount > 50 Then
            GUICtrlSetData($ID_BTS, GetByteFormat($nTotalBytes))
            GUICtrlSetData($ID_PBR, 0)
            $nCount = 0
        Else
            $nCount += 1
        EndIf
        $i = 0
    Next
    ;
    GUICtrlSetData($ID_BTS, GetByteFormat($nTotalBytes))
    GUICtrlSetData($ID_PBR, 0)
    ;
    If $nAbort Or $nError Or $RemoteClose Then
        _SocksCache('CloseRemoteSocket', $nRemoteSocket)
    EndIf
    ;
    If $nError Then
        Return SetError(3)
    EndIf
    ;
    If $FileCacheEnabled And $IsFileCached And $nLength Then
        Local $hFile = FileOpen($sPath, 26); 2+8+16
        If $hFile > 0 Then
            FileWrite($hFile, $sFile)
            FileClose($hFile)
        EndIf
    EndIf
    Return SetError(0)
EndFunc
;
Func _SRER($str, $sCommand, $sTag = '', $sValue = '')
    Switch $sCommand
        Case 'AddValue'
            $str = StringRegExpReplace($str, '(?is)(' & $sTag & ':.*?\r\n)', '\1' & $sValue, 1)
        Case 'FriendlyFile'
            $str = StringRight($str, 90)
            $str = StringRegExpReplace($str, '[^\w\-\.]', '_')
        Case 'FriendlyPath'
            $str = StringLeft($str, 150 - $nPathCache) & '/'
            $str = StringReplace($str, '//', '/')
            $str = StringReplace($str, '/', '\')
            $str = StringRegExpReplace($str, '[^\w\-\.\\]', '_')
        Case 'GetFileExt'
            $str = StringRegExpReplace($str, '(.*\.)', '')
        Case 'GetFileName'
            $str = StringRegExpReplace($str, '(.*/)', '')
            $str = StringRegExpReplace($str, '([\&\?\=].*)', '')
            StringReplace(StringLeft(StringRight($str, 4), 1), '.', '')
        Case 'GetPath'
            $str = StringRegExpReplace($str, '(?is)(?:.*\s)(.*?)(?:\sHTTP/.*)', '\1', 1)
        Case 'GetStatus'
            $str = StringRegExpReplace($str, '(?s).*\s(\d{3})\s.*', '\1', 1)
        Case 'GetValue'
            $str = StringRegExpReplace($str, '(?is).*' & $sTag & ':\s(.*?)\r\n.*', '\1', 1)
        Case 'RemoveDomain'
            $str = StringRegExpReplace($str, '(?is)(.*?)(http://.*?)(/.*\r\n)', '\1\3')
        Case 'RemoveTag'
            $str = StringRegExpReplace($str, '(?is)(' & $sTag & ':.*?\r\n)', '')
        Case 'ReplaceValue'
            $str = StringRegExpReplace($str, '(?is)(' & $sTag & ':.*?\r\n)', $sTag & ': ' & $sValue & @CRLF)
        Case 'NoScripts'
            $str = StringRegExpReplace($str, '(?is)(<script.*?</script>)|(<noscript.*?</noscript>)|(<iframe.*?</iframe>)|(<meta.*?>)', '')
        Case Else
    EndSwitch
    Return SetError(@error, @extended, $str)
EndFunc
;
Func _SocksCache($sCommand, $nRemoteSocket = '', $sHost = '')
    Switch $sCommand
        Case 'GetRemoteSocket'
            For $i = 0 To UBound($aSocksCache) - 1
                If $aSocksCache[$i][0] <> $sHost Then
                    ContinueLoop
                ElseIf $aSocksCache[$i][2] == '' Then
                    For $j = 1 To 2
                        $aSocksCache[$i][2] = _TCPConnect($aSocksCache[$i][1], 80)
                        If Not @error Then ExitLoop
                        _StringDisplay('Retry Connection: ' & $sHost)
                        If ($j = 2) Then
                            _SocksCache('ResetCache')
                            ExitLoop 2
                        EndIf
                    Next
                EndIf
                Return $aSocksCache[$i][2]
            Next
            ;
            Local $sIP = TCPNameToIP($sHost)
            If @error Or Not StringExists($sIP) Then
                Return SetError(1)
            EndIf
            ;
            For $i = 0 To UBound($aSocksCache) - 1
                If $aSocksCache[$i][0] == '' Then
                    $aSocksCache[$i][0] = $sHost
                    $aSocksCache[$i][1] = $sIP
                    For $j = 1 To 2
                        $aSocksCache[$i][2] = _TCPConnect($aSocksCache[$i][1], 80)
                        If Not @error Then ExitLoop
                        _StringDisplay('Retry Connection: ' & $sHost)
                        If ($j = 2) Then
                            _SocksCache('ResetCache')
                            _StringDisplay('Cannot Connect: ' & $sHost)
                            Return SetError(2)
                        EndIf
                    Next
                    If $i = (UBound($aSocksCache) - 2) Then
                        ReDim $aSocksCache[UBound($aSocksCache) + 25][3]
                    EndIf
                    Return $aSocksCache[$i][2]
                EndIf
            Next
        Case 'CloseRemoteSocket'
            For $i = 0 To UBound($aSocksCache) - 1
                If ($aSocksCache[$i][2] == $nRemoteSocket) Then
                    TCPCloseSocket($nRemoteSocket)
                    $aSocksCache[$i][2] = ''
                    Return
                EndIf
            Next
        Case 'CloseAllSockets'
            For $i = 0 To UBound($aSocksCache) - 1
                If $aSocksCache[$i][2] > 0 Then
                    TCPCloseSocket($aSocksCache[$i][2])
                EndIf
                $aSocksCache[$i][2] = ''
            Next
        Case 'ResetCache'
            For $i = 0 To UBound($aSocksCache) - 1
                If $aSocksCache[$i][2] > 0 Then
                    TCPCloseSocket($aSocksCache[$i][2])
                EndIf
                $aSocksCache[$i][0] = ''
                $aSocksCache[$i][1] = ''
                $aSocksCache[$i][2] = ''
            Next
        Case Else
    EndSwitch
EndFunc
;
Func _HTML_Message($sMsg, $sStatus)
    $sMsg = '<html><body><div><h2>' & $sMsg & '</h2></div></body></html>' & @CRLF
    Local $sHeader = 'HTTP/1.1 ' & $sStatus & @CRLF
    $sHeader &= 'Connection: close' & @CRLF
    $sHeader &= 'Content-Type: text/html' & @CRLF
    $sHeader &= 'Content-Length: ' & StringLen($sMsg) & $sEOF
    $sHeader &= $sMsg
    Return $sHeader
EndFunc
;
Func _StringDisplay($string, $showdate = 0)
    If $showdate Then $string = _DateTime() & @CRLF & $string
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
    GUICtrlSetData($ID_EDT, GUICtrlRead($ID_EDT) & $string & @CRLF)
EndFunc
;
Func _DateTime()
    Return ('[' & @MON & '-' & @MDAY & '-' & @YEAR & '  ' & @HOUR & ':' & @MIN & ':' & @SEC & ']')
EndFunc
;
Func _Minimize()
    GUISetState(@SW_MINIMIZE, $ID_GUI)
EndFunc
;
Func _Clear()
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
    GUICtrlSetData($ID_EDT, '')
EndFunc
;
Func _Reset()
    GUICtrlSetState($ID_BTS, $GUI_FOCUS)
    GUICtrlSetData($ID_BTS, 0)
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
    $nTotalBytes = 0
EndFunc
;
Func _Abort()
    $nAbort = 1
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
EndFunc
;
Func _SetIdle()
    AdlibUnRegister('_SetIdle')
    _SocksCache('CloseAllSockets')
    $nMsec = 250
EndFunc
;
Func _State()
    Local $nCopy = $AutoProxyEnabled
    $AutoProxyEnabled = Number(GUICtrlRead($ID_APX) = $GUI_CHECKED)
    If ($AutoProxyEnabled <> $nCopy) Then
        _REG_ProxySettings($AutoProxyEnabled)
    EndIf
    $WhiteListActive = Number(GUICtrlRead($ID_LST) = $GUI_CHECKED)
    $Scripts = Number(GUICtrlRead($ID_SCR) = $GUI_CHECKED)
    $Cookies = Number(GUICtrlRead($ID_CKS) = $GUI_CHECKED)
    $Referer = Number(GUICtrlRead($ID_RFR) = $GUI_CHECKED)
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
EndFunc
;
Func _Debug()
    If $ShowDebug Then
        GUICtrlSetState($ID_DBG, $GUI_UNCHECKED)
        $ShowDebug = 0
    Else
        GUICtrlSetState($ID_DBG, $GUI_CHECKED)
        $ShowDebug = 1
    EndIf
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
EndFunc
;
Func _Headers()
    If $ShowHeaders Then
        GUICtrlSetState($ID_HDR, $GUI_UNCHECKED)
        $ShowHeaders = 0
    Else
        GUICtrlSetState($ID_HDR, $GUI_CHECKED)
        $ShowHeaders = 1
    EndIf
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
EndFunc
;
Func _FileCacheEnable()
    If $FileCacheEnabled Then
        GUICtrlSetState($ID_FCA, $GUI_UNCHECKED)
        $FileCacheEnabled = 0
    Else
        GUICtrlSetState($ID_FCA, $GUI_CHECKED)
        $FileCacheEnabled = 1
    EndIf
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
EndFunc
;
Func _FileCacheDelete()
    If $nMsec = 10 Then Return
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
    GUICtrlSetData($ID_EDT, 'Deleting Cache...' & @CRLF)
    DirRemove($sPathCache, 1)
    DirCreate($sPathCache)
    _FileCacheStatus()
EndFunc
;
Func _FileCacheStatus()
    If $nMsec = 10 Then Return
    Local $aCache = DirGetSize($sPathCache, 1)
    If Not IsArray($aCache) Then Return
    Local $str = '[File Cache Status]' & @CRLF
    $str &= 'Size: ' & GetByteFormat($aCache[0])
    $str &= ' - Folders: ' & $aCache[2]
    $str &= ' - Files: ' & $aCache[1] & @CRLF
    GUICtrlSetState($ID_EDT, $GUI_FOCUS)
    GUICtrlSetData($ID_EDT, $str)
EndFunc
;
Func StringExists($s, $n = 30); v0.1
    Return StringLen(StringStripWS(StringLeft($s, $n), 8))
EndFunc
;
Func StringMatch($s, $c, $d = '|'); v0.1
    $s = StringLower($s)
    $c = StringLower($c)
    Local $a = StringSplit($c, $d, 1)
    ;
    For $i = 1 To $a[0]
        If $s == $a[$i] Then Return $i
    Next
EndFunc
;
Func GetByteFormat($n_b); v0.4
    If Not StringIsDigit($n_b) Then
        Return '0 B'
    EndIf
    $n_b = Number($n_b)
    ;
    Local $a_ab = StringSplit('B|KB|MB|GB|TB', '|')
    ;
    For $i = 1 To $a_ab[0]; "bytes" in -> div -> abrv -> out
        If ($n_b < 1024) Then
            $n_b = String(Round($n_b, 2))
            If StringInStr($n_b, '.') = 0 Then
                $n_b &= '.00'
            ElseIf StringLeft(StringRight($n_b, 2), 1) = '.' Then
                $n_b &= '0'
            EndIf
            Return $n_b & ' ' & $a_ab[$i]
        EndIf
        $n_b /= 1024
    Next
EndFunc
;
Func _REG_ProxySettings($nEnable)
    Local $sKey = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    If $nEnable Then
        $RegDefaults[0] = RegRead($sKey, 'ProxyEnable')
        $RegDefaults[1] = RegRead($sKey, 'ProxyServer')
        RegWrite($sKey, 'ProxyServer', 'REG_SZ', $strIP & ':' & $nPort)
        If @error Then
            TCPShutdown()
            Exit MsgBox(8208, $sTitle, 'Cannot write to registry' & @TAB, 5)
        EndIf
        RegWrite($sKey, 'ProxyEnable', 'REG_DWORD', 1)
    Else
        If StringExists($RegDefaults[0]) Then
            RegWrite($sKey, 'ProxyEnable', 'REG_DWORD', $RegDefaults[0])
        Else
            RegWrite($sKey, 'ProxyEnable', 'REG_DWORD', 0); default: 0
        EndIf
        If StringExists($RegDefaults[1]) Then
            RegWrite($sKey, 'ProxyServer', 'REG_SZ', $RegDefaults[1])
        Else
            RegDelete($sKey, 'ProxyServer'); default: no valuename
        EndIf
    EndIf
EndFunc
;
Func _Tray()
    Switch @TRAY_ID
        Case $show
            TrayItemSetState($show, $GUI_UNCHECKED)
            GUISetState(@SW_SHOW, $ID_GUI)
            GUISetState(@SW_RESTORE, $ID_GUI)
        Case $hide
            TrayItemSetState($hide, $GUI_UNCHECKED)
            GUISetState(@SW_HIDE, $ID_GUI)
            GUISetState(@SW_MINIMIZE, $ID_GUI)
        Case $exit
            Exit
    EndSwitch
EndFunc
;
Func _Exit()
    TCPShutdown()
    DllClose($hWS2_32)
    GUIDelete($ID_GUI)
    If $AutoProxyEnabled Then; Reset Default Values
        _REG_ProxySettings(0)
    EndIf
    Exit
EndFunc
;
;<-[BlackList and WhiteList Functions]
;
Func _EditList()
    If $nMsec = 10 Then Return
    ;
    Local $sList, $str
    Switch @GUI_CtrlId
        Case $ID_LT1
            $sList = 'BlackList'
            $str = _GetBlackList()
        Case $ID_LT2
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
    Local $ID_SAV = GUICtrlCreateButton('Save List', 65, 225, 80, 22)
    Local $ID_CAN = GUICtrlCreateButton('Cancel', 155, 225, 80, 22)
    GUICtrlSetData($ID_EDT2, $str)
    GUISetState(@SW_SHOW, $ID_GUI2)
    GUICtrlSetState($ID_EDT2, $GUI_FOCUS)
    ;
    While 1
        Switch GUIGetMsg()
            Case -3, $ID_CAN
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
;<-[WSA TCP Functions]
;
Func _TCPSend($nSocket, $sData)
    Local $nTotalBytes = StringLen($sData)
    Local $nBytes, $nError, $nExtended

    For $i = 1 To 50; <-- serves as a timeout scheme.
        $nBytes = _WSA_TCPSend($nSocket, $sData)
        $nError = @error
        $nExtended = @extended

        If $nError Then
            Return SetError($nError, $nExtended, 0)
        ElseIf ($nBytes == $nTotalBytes) Then
            Return SetError(0, 0, $nBytes); success
        ElseIf ($nBytes > 0) Then
            Return SetError(2, 0, 0); failed to send total byte count. (partial send)
        EndIf

        Sleep(10); part cpu breather and part timeout scheme
    Next

    Return SetError(1, 0, 0); timed out
EndFunc
;
;======================================================================================
;#FUNCTION#....:
; Name.........: _WSA_TCPRecv()
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error.
;..............: -1 socket error.
;..............: -2 disconnected.
;..............: -3 dll error.
;..............:
; @extended....; If @error Then returns a WSA Error Code.
;............. : Else returns number of bytes received.
;..............:
; Return Value.: If Not @error And @extended > 0 Then returns data.
;..............: Else returns blank.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
Func _WSA_TCPRecv($nSocket, $nMaxLen = 4096, $nBinaryMode = 0)
    ;[set non-blocking mode]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 1)
    If @error Then
        Return SetError(-3, 0, ''); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), ''); socket error
    EndIf; WSAGetLastError will return socket errors with this statement (example: 10038-invalid socket).

    ;[get buffer type]
    If $nBinaryMode Then
        Local $tBuffer = DllStructCreate('byte[' & $nMaxLen & ']')
    Else
        Local $tBuffer = DllStructCreate('char buffer[' & $nMaxLen & ']')
    EndIf

    ;[receive data]
    $aResult = DllCall($hWS2_32, 'int', 'recv', 'int', $nSocket, 'struct*', $tBuffer, 'int', $nMaxLen, 'int', 0)
    If @error Then
        Return SetError(-3, _WSA_GetLastError(), ''); dll error
    EndIf

    ;[check WSA error]
    Local $nError = _WSA_GetLastError()
    If ($nError <> 0) And ($nError <> 10035) Then; <- WSAEWOULDBLOCK (non-blocking socket (non-fatal error))
        Return SetError(-1, $nError, ''); socket error
    EndIf

    Local $nBytes = $aResult[0]

    ;[set blocking mode]
    $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 0)
    If @error Then
        Return SetError(-3, 0, ''); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), ''); socket error
    EndIf

    Local $sData = ''
    $nError = 0

    ;[process results]
    If ($nBytes > 0) Then; data received
        $sData = DllStructGetData($tBuffer, 1)
        If $nBinaryMode Then; extract binary data
            $sData = StringLeft($sData, ($nBytes * 2) + 2)
        Else; extract raw data
            $sData = StringLeft($sData, $nBytes)
        EndIf
    ElseIf ($nBytes == 0) Then; disconnected
        $nError = -2
    Else
        $nBytes = 0; no data received
    EndIf

    Return SetError($nError, $nBytes, $sData)
EndFunc
;
;======================================================================================
;#FUNCTION#....:
; Name.........: _WSA_TCPSend()
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error.
;..............: -1 socket error.
;..............: -2 disconnected.
;..............: -3 dll error.
;..............:
; @extended....; If @error Then @extended returns a WSA Error Code.
;............. : Else returns 0.
;..............:
; Return Value.: If Not @error Then returns number of bytes sent.
;..............: Else returns 0.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
Func _WSA_TCPSend($nSocket, $sData)
    ;[set non-blocking mode]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 1)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), 0); socket error
    EndIf; WSAGetLastError will return socket errors with this statement (ie: 10038-invalid socket).

    Local $nBytes = StringLen($sData)
    Local $tBuffer = DllStructCreate('char buffer[' & $nBytes & ']')
    DllStructSetData($tBuffer, 1, $sData)

    ;[send data]
    $aResult = DllCall($hWS2_32, 'int', 'send', 'int', $nSocket, 'struct*', $tBuffer, 'int', $nBytes, 'int', 0)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    EndIf

    ;[check WSA error]
    Local $nError = _WSA_GetLastError()
    If ($nError <> 0) And ($nError <> 10035) Then; <- WSAEWOULDBLOCK (non-blocking socket (non-fatal error))
        Return SetError(-1, $nError, 0); socket error
    EndIf

    $nBytes = $aResult[0]

    ;[set blocking mode]
    $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 0)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), 0); socket error
    EndIf

    $nError = 0

    ;[process results]
    If ($nBytes > 0) Then; bytes sent
        ; pass through
    ElseIf ($nBytes == 0) Then; disconnected
        $nError = -2
    Else
        $nBytes = 0; no bytes sent
    EndIf

    Return SetError($nError, 0, $nBytes)
EndFunc
;
;====================================================================================
;#FUNCTION#
; Name........: _TCPConnect()
;
; This is a rewrite of the original code - all credits go to ProgAndy and JScript.
; Purpose: format is easier to debug and maintain.
;
; Original Link:
; http://www.autoitscript.com/forum/topic/127415-tcpconnect-sipaddr-iport-itimeout/
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Description..: Attempts a socket connection with a timeout.
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error - socket is returned in blocking mode.
;..............: -1 could not create socket.
;..............: -2 ip incorrect.
;..............: -3 could not get port.
;..............: -4 could not set blocking or non-blocking mode.
;..............: -5 could not connect.
;..............: -6 timed out.
;..............: -7 dll error.
; .............:
; @extended....; If @error Then returns a WSA Error Code.
;..............: Else returns 0.
;..............:
; Return Value.: If @error Then returns -1.
;..............: Else returns socket.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;====================================================================================
Func _TCPConnect($sIPAddr, $iPort, $iTimeOut = 3000); <- default: 3 seconds
    ;[create socket]
    Local $hSock = DllCall($hWS2_32, 'uint', 'socket', 'int', 2, 'int', 1, 'int', 6); AF_INET, SOCK_STREAM, IPPROTO_TCP
    If @error Then
        Return SetError(-7, 0, -1); dll error
    ElseIf ($hSock[0] == -1) Or ($hSock[0] == 4294967295) Then; 4294967295 = 0xFFFFFFFF
        Return SetError(-1, _WSA_GetLastError(), -1); could not create socket
    EndIf
    $hSock = $hSock[0]

    ;[get ip handle]
    Local $aIP = DllCall($hWS2_32, 'ulong', 'inet_addr', 'str', $sIPAddr)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aIP[0] == -1) Or ($aIP[0] == 4294967295) Then
        TCPCloseSocket($hSock)
        Return SetError(-2, _WSA_GetLastError(), -1); ip incorrect
    EndIf

    ;[get port handle]
    Local $aPort = DllCall($hWS2_32, 'ushort', 'htons', 'ushort', $iPort)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aPort[0] < 1) Then
        TCPCloseSocket($hSock)
        Return SetError(-3, _WSA_GetLastError(), -1); could not get port
    EndIf

    ;[set socket to non-blocking mode for timeout]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'ulong*', 1); FIONBIO, NON-BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); socket error (could not set non-blocking mode)
    EndIf

    ;[set binding]
    Local $tSockAddr = DllStructCreate('short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];')
    DllStructSetData($tSockAddr, 1, 2)
    DllStructSetData($tSockAddr, 2, $aPort[0])
    DllStructSetData($tSockAddr, 3, $aIP[0])

    ;[attempt connect]
    $aResult = DllCall($hWS2_32, 'int', 'connect', 'int', $hSock, 'struct*', $tSockAddr, 'int', DllStructGetSize($tSockAddr))
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) And (_WSA_GetLastError() <> 10035) Then; <- WSAEWOULDBLOCK - non-blocking socket (no data queued on socket - non-fatal error)
        TCPCloseSocket($hSock)
        Return SetError(-5, _WSA_GetLastError(), -1); could not connect
    EndIf

    ;[set timeout]
    Local $t1 = DllStructCreate('uint;int')
    DllStructSetData($t1, 1, 1)
    DllStructSetData($t1, 2, $hSock)

    Local $t2 = DllStructCreate('long;long')
    DllStructSetData($t2, 1, Floor($iTimeOut / 1000))
    DllStructSetData($t2, 2, Mod($iTimeOut, 1000))

    ;[init timeout]
    $aResult = DllCall($hWS2_32, 'int', 'select', 'int', $hSock, 'struct*', $t1, 'struct*', $t1, 'ptr', 0, 'struct*', $t2)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] == 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-6, _WSA_GetLastError(), -1); timed out
    EndIf

    ;[set socket to blocking mode again]
    $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'ulong*', 0); FIONBIO, BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); socket error (could not set blocking mode)
    EndIf

    Return SetError(0, 0, $hSock)
EndFunc
;
Func _WSA_GetLastError()
    Local $aResult = DllCall($hWS2_32, 'int', 'WSAGetLastError')
    If @error Then
        Return SetError(-1, 0, -1); dll error
    ElseIf $aResult[0] > 5 Then
        Return SetError(0, 0, $aResult[0])
    Else
        Return SetError(0, 0, 0)
    EndIf
EndFunc
;

