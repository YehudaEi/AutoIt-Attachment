; TCP_Connections
; October 15, 2012
; Example: Yes
;
#include 'array.au3'
;
Opt('TrayAutoPause', 0)
Opt('MustDeclareVars', 1)
TraySetIcon('shell32.dll', 19)
;
Local Const $hMSVCRT = DllOpen('msvcrt.dll')
Local Const $hWS2_32 = DllOpen('ws2_32.dll')
Local Const $hIPHLPAPI = DllOpen('iphlpapi.dll')
;
Local $aCompare, $sUnknown, $sPath = @ScriptDir & '\unknown.cache'
If FileExists($sPath) Then $sUnknown = FileRead($sPath)
;
Local $ID_GUI = GUICreate(' TCP_Connections', 800, 410, -1, -1, 0x00CF0000)
GUISetIcon('shell32.dll', 19, $ID_GUI)
GUISetFont(9, 400, 0, 'arial')
;
Local $ID_LV = GUICtrlCreateListView(' Source | PID | Local | Remote | Status | Address', 5, 5, 790, 400)
LV_SetColumnWidth($ID_LV, '100|50|125|125|125|270')
GUICtrlSendMsg($ID_LV, 0x1036, 0, 0x14230);<-- trancexx
;
Local $ID_Menu = GUICtrlCreateContextMenu($ID_LV)
Local $ID_Copy = GUICtrlCreateMenuItem('Copy To Clipboard', $ID_Menu)
GUICtrlSetOnEvent($ID_Copy, '_Copy2Clip')
;
GUISetOnEvent(-3, '_Exit')
Opt('GUIOnEventMode', 1)
TCPStartup()
;
GUISetState(@SW_SHOW, $ID_GUI)
;
While 1
    _TCP_Update()
    Sleep(5000)
WEnd
;
Func _TCP_Update()
    Local $a = _CV_GetExtendedTcpTable()
    If @error Or Not IsArray($a) Then Return
    ;
    Local $string, $nLvi, $n = 0
    _ArraySort($a, 0, 1, 0, 6)
    ;
    If IsArray($aCompare) And ($a[0][0] = $aCompare[0][0]) Then; compare arrays
        For $i = 1 To $a[0][0]
            If ($a[$i][4] <> $aCompare[$i][4]) Or ($a[$i][6] <> $aCompare[$i][6]) Then
                $n = 1
                ExitLoop
            EndIf
        Next
        If $n = 0 Then Return; nothing has changed - return to main loop
    EndIf
    ;
    $aCompare = $a
    ;
    GUISetState(@SW_LOCK, $ID_GUI)
    GUICtrlSendMsg($ID_LV, 0x1009, 0, 0)
    ;
    For $i = 1 To $a[0][0]
        If ($a[$i][4] <> $a[$i - 1][4]) Then
            $a[$i][7] = _TCPIpToName($a[$i][4])
        Else
            $a[$i][7] = $a[$i - 1][7]; save call to _TCPIpToName() by copying previous remote address
        EndIf
        ;
        $string = $a[$i][0] & '|' & $a[$i][1] & '|'
        $string &= $a[$i][2] & ':' & $a[$i][3] & '|'
        $string &= $a[$i][4] & ':' & $a[$i][5] & '|'
        $string &= $a[$i][6] & '|' & $a[$i][7]
        $nLvi = GUICtrlCreateListViewItem($string, $ID_LV)
        ;
        $string = $a[$i][6]
        If StringInStr($string, 'CLOS') Then
            GUICtrlSetBkColor($nLvi, 0xFF8080)
        ElseIf StringInStr($string, 'WAIT') Then
            GUICtrlSetBkColor($nLvi, 0xFFC0C0)
        ElseIf StringInStr($string, 'SENT') Then
            GUICtrlSetBkColor($nLvi, 0xFFFFC0)
        ElseIf StringInStr($string, 'ESTA') Then
            GUICtrlSetBkColor($nLvi, 0xC0FFC0)
        EndIf
    Next
    ;
    GUISetState(@SW_UNLOCK, $ID_GUI)

    ; _CheckHostsFile($a); <--- doesn't exist in this script

EndFunc
;
Func _Copy2Clip()
    Local $s = StringTrimRight(GUICtrlRead(GUICtrlRead($ID_LV)), 1)
    If StringRegExp($s, '[\w]') Then
        ClipPut($s)
    Else
        ClipPut('')
    EndIf
EndFunc
;
Func LV_SetColumnWidth(ByRef $IDLV, $sWidth)
    Local $a = StringSplit($sWidth, '|')
    For $i = 1 To $a[0]
        GUICtrlSendMsg($IDLV, 0x101E, $i - 1, Number($a[$i]))
    Next
EndFunc
;
Func _Exit()
    TCPShutdown()
    GUIDelete($ID_GUI)
    DllClose($hIPHLPAPI)
    DllClose($hMSVCRT)
    DllClose($hWS2_32)
    Exit
EndFunc
;
;<-- From ConnView.au3, modified by ripdad
;
; Author: trancexx
Func _CV_GetExtendedTcpTable()
    Local $aCall = DllCall($hIPHLPAPI, 'dword', 'GetExtendedTcpTable', 'ptr*', 0, 'dword*', 0, 'int', 1, 'dword', 2, 'dword', 5, 'dword', 0)
    If @error Then Return SetError(1, 0, 0)
    If $aCall[0] <> 122 Then Return SetError(2, 0, 0)
    Local $iSize = $aCall[2]

    Local $tByteStructure = DllStructCreate('byte[' & $iSize & ']')
    $aCall = DllCall($hIPHLPAPI, 'dword', 'GetExtendedTcpTable', 'ptr', DllStructGetPtr($tByteStructure), 'dword*', $iSize, 'int', 1, 'dword', 2, 'dword', 5, 'dword', 0)
    If @error Or $aCall[0] Then Return SetError(3, 0, 0)

    Local $tMIB_TCPTABLE_OWNER_PID_DWORDS = DllStructCreate('dword[' & Ceiling($iSize / 4) & ']', DllStructGetPtr($tByteStructure))
    Local $iTCPentries = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1)

    Local $aTCPTable[$iTCPentries + 1][8] = [[$iTCPentries, 'PID', 'Local IP', _
            'Local Port', 'Remote IP', 'Remote port', 'Connection state']]

    Local $aState[12] = ['CLOSED', 'LISTENING', 'SYN_SENT', 'SYN_RCVD', 'ESTABLISHED', 'FIN_WAIT1', _
            'FIN_WAIT2', 'CLOSE_WAIT', 'CLOSING', 'LAST_ACK', 'TIME_WAIT', 'DELETE_TCB']

    Local $aProcesses = ProcessList()
    Local $iIP, $iOffset

    For $i = 1 To $iTCPentries
        $iOffset = ($i - 1) * 6 + 1
        $aTCPTable[$i][6] = $aState[DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 1) - 1]
        $iIP = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 2); LOCAL IP
        If $iIP = 16777343 Then
            $aTCPTable[$i][2] = '127.0.0.1'
        ElseIf $iIP = 0 Then
            $aTCPTable[$i][2] = '0.0.0.0'
        Else
            $aTCPTable[$i][2] = _
                    BitOR(BinaryMid($iIP, 1, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 2, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 3, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 4, 1), 0)
        EndIf

        $aTCPTable[$i][3] = Dec(Hex(BinaryMid(DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 3), 1, 2))); LOCAL PORT

        If DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 1) < 3 Then
            $aTCPTable[$i][4] = '*'
            $aTCPTable[$i][5] = '*'
        Else
            $iIP = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 4); REMOTE IP
            $aTCPTable[$i][4] = _
                    BitOR(BinaryMid($iIP, 1, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 2, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 3, 1), 0) & '.' & _
                    BitOR(BinaryMid($iIP, 4, 1), 0)
            $aTCPTable[$i][5] = Dec(Hex(BinaryMid(DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 5), 1, 2))); REMOTE PORT
        EndIf

        $aTCPTable[$i][1] = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 6); PID
        If Not $aTCPTable[$i][1] Then
            $aTCPTable[$i][0] = 'System'
            $aTCPTable[$i][1] = '4'
        Else
            For $j = 1 To $aProcesses[0][0]
                If $aTCPTable[$i][1] = $aProcesses[$j][1] Then
                    If Not $aProcesses[$j][0] Then
                        $aTCPTable[$i][0] = '(System)'
                    Else
                        $aTCPTable[$i][0] = $aProcesses[$j][0]
                    EndIf
                EndIf
            Next
        EndIf
    Next
    Return $aTCPTable
EndFunc
;
;<-- From INet.au3, modified by ripdad
;
; Author: Florian Fida
Func _TCPIpToName($sIp)
    If ($sIp = '*') Then Return 'local'
    If StringInStr($sUnknown, StringRegExpReplace($sIp, '(.*)\..*', '\1')) Then Return '(unknown)'

    Local $vaDllCall = DllCall($hWS2_32, 'ulong', 'inet_addr', 'str', $sIp)
    If @error Then Return SetError(1, 0, ''); inet_addr DllCall Failed
    If $vaDllCall[0] = 0xffffffff Then Return SetError(2, 0, ''); inet_addr Failed

    ;==================================================================================================================
    ; (Known Issue)
    ; Needs a timeout parameter - usually takes between 5 to 20 seconds if ip can't be resolved, and will appear hung.
    ; This effect has been minimized in _TCP_Update().
    $vaDllCall = DllCall($hWS2_32, 'ptr', 'gethostbyaddr', 'ptr*', $vaDllCall[0], 'int', 4, 'int', 2); AF_INET
    If @error Or Not $vaDllCall[0] Then
        $sUnknown &= $sIp & @CRLF
        FileWriteLine($sPath, $sIp & @CRLF)
        Return SetError(3, 0, '(unknown)'); gethostbyaddr DllCall Failed
    EndIf
    ;==================================================================================================================

    Local $vHostent = DllStructCreate('ptr;ptr;short;short;ptr', $vaDllCall[0])
    Local $sHostnames = __TCPIpToName_szStringRead(DllStructGetData($vHostent, 1))
    If @error Then Return SetError(6, 0, $sHostnames); strlen/sZStringRead Failed
    Return $sHostnames
EndFunc
;
; Author: Florian Fida
Func __TCPIpToName_szStringRead($iszPtr, $iLen = -1)
    Local $aStrLen, $vszString
    If $iszPtr < 1 Then Return ''; Null Pointer
    If $iLen < 0 Then
        $aStrLen = DllCall($hMSVCRT, 'ulong_ptr:cdecl', 'strlen', 'ptr', $iszPtr)
        If @error Then Return SetError(1, 0, ''); strlen Failed
        $iLen = $aStrLen[0] + 1
    EndIf
    $vszString = DllStructCreate('char[' & $iLen & ']', $iszPtr)
    If @error Then Return SetError(2, 0, '')
    Return SetExtended($iLen, DllStructGetData($vszString, 1))
EndFunc
;
