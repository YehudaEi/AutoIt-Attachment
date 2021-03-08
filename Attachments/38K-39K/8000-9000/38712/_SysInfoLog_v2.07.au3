; ==================================================
; SysInfoLog2.au3
; Description: Generates a System Information Log
; Released: May 22, 2012 - Version: 2.00 by ripdad
; ==================================================
; Modified:
; May 24, 2012 - v2.01 - Fixed characters clashing with _WMI_InstancesOf() and added a QuickFix function.
; May 26, 2012 - v2.02 - Changed value translation logic in _WMI_InstancesOf(). Added a few more WMI calls, ie: Win32_Keyboard. Added [Loaded Misc]
; June 01, 2012 - v2.03 - Added _GetDisplayEDID(), optimized some functions and made a few improvements.
; June 07, 2012 - v2.04 - Added Win32_PnPEntity, MfgYear in _GetDisplayEDID() and a few adjustments to _WMI_InstancesOf() and _WMI_GetATAPISmartData().
; October 02, 2012 - v2.05 - Changed Error Handling for Objects and Various Improvements.
; October 03, 2012 - v2.06 - Fixed a few problems with object errors in _WMI_InstancesOf().
; 1) If a device is not found (like a sound card), it will return a blank string when the "object count" is zero.
; 2) If a "property name" returns an error of "not found" at the "qualifier loop", then the function will continue without it.
; October 04, 2012 - v2.07 - version change.
;
#include 'array.au3'
#RequireAdmin
;
Opt('TrayAutoPause', 0)
Opt('MustDeclareVars', 1)
;
Local $sTitle = 'SysInfoLog v2.07'
;
Local Const $OSA = @OSArch, $OSV = @OSVersion
Local $HKCR, $HKLM, $HKCU, $HKU, $OSA64 = 0, $Vista_7 = 0
;
SIL_TestOS()
;
If MsgBox(8228, $sTitle, 'Generate a System Information Log?' & @TAB) <> 6 Then Exit
;
Local Const $sWMI_Moniker = 'Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\.\root\cimv2'
Local $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Local $nWMI, $ObjError_Msg, $Object_Error = 0, $nAdv = 0
;
SIL_TestWMI()
;
Local $dt = @MON & '-' & @MDAY & '-' & @YEAR & '_' & @HOUR & ':' & @MIN & ':' & @SEC
Local $sLogFile = @ScriptDir & '\SysInfoLog_' & StringReplace($dt, ':', '') & '.log'
Local $hLogFile = FileOpen($sLogFile, 1)
If ($hLogFile = -1) Then ExitMsg('Cannot Open Log File')
;
Local $aENV = _GetEnvironmentArray()
;
Local $gui = GUICreate($sTitle, 300, 130, -1, -1, 0x00C00000)
GUICtrlCreateLabel('Collecting System Information, Please Wait...', 20, 20, 260, 20, 1)
Local $prb = GUICtrlCreateProgress(50, 50, 200, 20, 1)
Local $lbl = GUICtrlCreateLabel('', 50, 80, 200, 20, 1)
GUISetState(@SW_SHOW, $gui)
GUISetState(@SW_DISABLE, $gui)
_GenerateSIL()
GUIDelete($gui)
FileClose($hLogFile)
MsgBox(8256, $sTitle & ' - Finished', $sLogFile)
Exit
;
Func _GenerateSIL($s = '')
    $s &= ';=========================================================' & @CRLF
    $s &= '; ' & $sTitle & @CRLF
    $s &= '; Computer: ' & $OSV & '_' & $OSA & '\' & @ComputerName & '\' & @UserName & @CRLF
    $s &= '; Date/Time: ' & StringReplace($dt, '_', ' ') & @CRLF
    $s &= ';=========================================================' & @CRLF & @CRLF
    FileWrite($hLogFile, $s)
    GUICtrlSetData($prb, 10)
    GUICtrlSetData($lbl, 'Computer Information')
    GetSystemInfo()
    GUICtrlSetData($prb, 20)
    GUICtrlSetData($lbl, 'Common Startups')
    GetCommonStartups()
    GUICtrlSetData($prb, 30)
    GUICtrlSetData($lbl, 'Registry Settings')
    Reg_GetRegistrySettings()
    GUICtrlSetData($prb, 40)
    GUICtrlSetData($lbl, 'Hosts File')
    GetHostsFile()

    GUICtrlSetData($prb, 50)
    If Not $nWMI Then
        GUICtrlSetData($lbl, 'Process List')
        GetProcessList(); <--secondary if no WMI
        Return
    EndIf

    GUICtrlSetData($prb, 60)
    GUICtrlSetData($lbl, 'Hard Drive SMART Data')
    Local $sRtn = _WMI_GetATAPISmartData()
    FileWrite($hLogFile, @CRLF & '[HD_SMART_DATA]' & @CRLF & $sRtn & @CRLF)

    GUICtrlSetData($prb, 70)
    GUICtrlSetData($lbl, 'Running Processes')
    $sRtn = ProcessList_Extended()
    If @error Then
        $sRtn = @CRLF & '[Running Programs]' & @CRLF & $sRtn & @CRLF & '[Loaded Dlls]' & @CRLF & $sRtn & @CRLF & '[Loaded Misc]' & @CRLF & $sRtn & @CRLF
    EndIf
    FileWrite($hLogFile, $sRtn)

    GUICtrlSetData($prb, 80)
    GUICtrlSetData($lbl, 'Running Services')
    $sRtn = _WMI_Drivers_Services('Win32_Service')
    FileWrite($hLogFile, @CRLF & '[Running Services]' & @CRLF & $sRtn)

    GUICtrlSetData($prb, 90)
    GUICtrlSetData($lbl, 'Loaded Drivers')
    $sRtn = _WMI_Drivers_Services('Win32_SystemDriver')
    FileWrite($hLogFile, @CRLF & '[Loaded Drivers]' & @CRLF & $sRtn)

    $sRtn = NTLogs_GetEvents()
    If @error Then
        $sRtn = '[NTLog_Errors]' & @CRLF & $sRtn & @CRLF & '[NTLog_Warnings]' & @CRLF & $sRtn & @CRLF & '[NTLog_ChkDsk]' & @CRLF & $sRtn & @CRLF
    EndIf
    FileWrite($hLogFile, @CRLF & $sRtn)
EndFunc
;
Func _WMI_SystemInfo()
    Local $s = _WMI_InstancesOf('Win32_OperatingSystem')
    If @error Then Return SetError(-1)

    ; Specific Properties Example
    ;===========================================================
    ; Local $Pattern = 'Caption|CSDVersion|CSName|InstallDate|Name|Organization|RegisteredUser|SerialNumber|TotalVisibleMemorySize|Version'
    ; $s &= _WMI_InstancesOf('Win32_OperatingSystem', $Pattern)
    ;===========================================================

    $s &= _WMI_InstancesOf('Win32_ComputerSystem', '^OEMLogoBitmap')
    $s &= _WMI_InstancesOf('Win32_ComputerSystemProduct', '^Caption|Description')
    $s &= _WMI_InstancesOf('Win32_SystemEnclosure', '^Caption|Description')
    $s &= _WMI_InstancesOf('Win32_BaseBoard', '^Caption|Description')
    $s &= _WMI_InstancesOf('Win32_BIOS', '^Caption|Description')
    $s &= _WMI_InstancesOf('Win32_PhysicalMemory', '^Caption|Description', 1)
    $s &= _WMI_InstancesOf('Win32_Processor', 0, 1)
    $s &= _WMI_InstancesOf('Win32_VideoController', 0, 1)
    $s &= _WMI_InstancesOf('Win32_DesktopMonitor Where Status="OK"', '^Caption|Description', 1)

    ; UNCOMMENT IF NEEDED - CURRENTLY DISABLED FOR SPEED
    ;==================================================================================
    ;$s &= _WMI_InstancesOf('Win32_PnPEntity Where PNPDeviceID Like "DISPLAY%"', 0, 1)
    ;$s &= _GetDisplayEDID(1)
    ;==================================================================================

    $s &= _WMI_InstancesOf('Win32_DiskDrive', 0, 1)
    $s &= _WMI_InstancesOf('Win32_LogicalDisk', 0, 1)
    $s &= _WMI_InstancesOf('Win32_CDROMDrive Where Status="OK"', 0, 1)
    $s &= _WMI_InstancesOf('Win32_NetworkAdapter Where NetConnectionID>"0"', '^Description', 1)
    $s &= _WMI_InstancesOf('Win32_NetworkAdapterConfiguration Where IPEnabled="True"', 0, 1)
    $s &= _WMI_InstancesOf('Win32_SoundDevice Where Status="OK"', 0, 1)
    $s &= _WMI_InstancesOf('Win32_Keyboard Where Status="OK"', '^Caption|Description', 1)
    $s &= _WMI_InstancesOf('Win32_PointingDevice Where Status="OK"', 0, 1)
    $s &= _WMI_QuickFixEngineering()
    FileWrite($hLogFile, '[System Information]' & @CRLF & $s)
    $s = ''
EndFunc
;
;====================================================================
; #Function....: _GetDisplayEDID()
;..............: Extended Display Identification Data (EDID)
;..............:
; Released.....: (Experimental) June 01, 2012 by ripdad
; Modified.....: June 06, 2012 - Added Win32_PnPEntity
;..............: June 07, 2012 - Added MfgYear
;..............: September 29, 2012 - Changed Error Handling
;..............:
; Description..: Attempts to get this info on active monitors:
;..............: the Manufacturer, Model, Serial Number and Year
;..............: in a unordered comma delimited string.
;..............:
;Reference Link:
;  http://en.wikipedia.org/wiki/Extended_display_identification_data
;====================================================================
Func _GetDisplayEDID($n_os = 1);<-- offset
    _WMI_ObjErrorReset()
    Local $objWMI = ObjGet('winmgmts:root\cimv2')
    If $Object_Error Or Not IsObj($objWMI) Then
        Return ''
    EndIf

    ;Local $objClass = $objWMI.InstancesOf('Win32_DesktopMonitor Where Status="OK"')
    Local $objClass = $objWMI.InstancesOf('Win32_PnPEntity Where PNPDeviceID Like "DISPLAY%"')
    Local $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return ''
    EndIf

    Local $sKey = 'HKEY_LOCAL_MACHINE64\SYSTEM\CurrentControlSet\Enum\'
    Local $a, $PNPDeviceID, $s, $y, $str = ''
    If @OSArch = 'X32' Then
        $sKey = StringReplace($sKey, '64', '')
    EndIf
    ;
    For $objItem In $objClass
        $PNPDeviceID = $objItem.PNPDeviceID

        If $Object_Error Then
            Return ''
        EndIf

        $s = RegRead($sKey & $PNPDeviceID & '\Device Parameters', 'EDID')
        If @error Then ContinueLoop
        $y = ''
        ;
        ; Test if binary string has a proper header
        If (StringLeft($s, 8) = '0x00FFFF') Then; Else, continue without year
            $y = StringMid($s, 37, 2)
            $y = Dec($y)
            $y += 1990
            If ($y > 1996) And ($y <= @YEAR) Then; assume good
                $y = ', MfgYear:' & $y
            Else
                $y = ''
            EndIf
        EndIf
        ;
        $s = BinaryToString(StringLeft($s, 258))
        $s = StringRegExpReplace($s, '[^\w\-]', ',')
        $s = StringRegExpReplace($s, '\,{1,}', ',')
        $a = StringSplit($s, ',')
        $s = ''
        ;
        For $i = $n_os To $a[0]
            If StringLen($a[$i]) > 2 Then
                $s &= $a[$i] & ', '
            EndIf
        Next
        If $s Then
            $s = StringTrimRight($s, 2)
            $str &= $objItem.DeviceID & '|(' & $s & $y & ')' & @CRLF
        EndIf
    Next
    If $Object_Error Then
        Return ''
    EndIf
    If $str Then
        Return '<--Display_EDID_String' & @CRLF & $str & @CRLF
    EndIf
    Return ''
EndFunc
;
Func GetProcessList(); <--secondary if no WMI
    Local $s, $s1, $s2
    $s &= @CRLF & '[Running Programs]' & @CRLF
    Local $a = ProcessList()
    _ArraySort($a, 0, 1)
    For $i = 1 To $a[0][0]
        If ($a[$i][1] < 5) Then ContinueLoop
        $s1 = FileTool($a[$i][0], 3)
        If $s1 Then
            $s2 = _LogFileProperties($s1)
        Else
            $s1 = $a[$i][0]
            $s2 = ''
        EndIf
        If $s2 And StringInStr(FileGetAttrib($s1), 'H') Then
            $s &= $s1 & ' (HIDDEN)|' & $s2 & @CRLF
        Else
            $s &= $s1 & '|' & $s2 & @CRLF
        EndIf
    Next
    Local $msg = @CRLF & 'WMI Service Not Available' & @CRLF
    $s &= '[Running Services]' & $msg & '[Loaded Drivers]' & $msg & _
            '[Loaded Dlls]' & $msg & '[NTLog_Errors]' & $msg & _
            '[NTLog_Warnings]' & $msg & '[NTLog_ChkDsk]' & $msg & _
            '[HD_SMART_DATA]' & $msg & '[Loaded Misc]' & $msg
    FileWrite($hLogFile, $s)
    $s = ''
EndFunc
;
Func GetHostsFile()
    Local $s = @CRLF & '[Hosts File]' & @CRLF
    Local $hFile = FileOpen(@WindowsDir & '\system32\drivers\etc\hosts.')
    If $hFile = -1 Then
        $s &= '(Cannot Open Hosts File)' & @CRLF
    Else
        For $i = 1 To 100; max sample: 100 lines
            $s &= FileReadLine($hFile, $i) & @CRLF
            If @error Then ExitLoop
        Next
        FileClose($hFile)
    EndIf
    $s = StringReplace($s, @TAB, '    ')
    FileWrite($hLogFile, $s)
    $s = ''
EndFunc
;
Func _LogFileProperties($sPath)
    If Not $sPath Then Return 'File Not Found|---|---|---'
    Local $a, $s, $t, $b = '---|'
    $t = FileGetVersion($sPath, 'CompanyName')
    If StringRegExp($t, '(?i)[A-Z1-9]') Then
        $s = $t & '|'
    Else
        $s = $b
    EndIf
    $t = FileGetVersion($sPath)
    If StringRegExp($t, '[1-9]') Then
        $s &= $t & '|'
    Else
        $s &= $b
    EndIf
    $t = FileGetVersion($sPath, 'FileDescription')
    If StringRegExp($t, '(?i)[A-Z1-9]') Then
        $s &= $t & '|'
    Else
        $s &= $b
    EndIf
    $a = FileGetTime($sPath, 1)
    If Not IsArray($a) Then Return $s & '---'
    $s &= $a[1] & '/' & $a[2] & '/' & $a[0]
    Return $s
EndFunc
;
Func GetSystemInfo()
    If $nWMI Then
        _WMI_SystemInfo(); Primary Action
        If Not @error Then Return
    EndIf

    ; Secondary Action
    Local $eMsg = '[System Information]' & @CRLF & 'Error|Could Not Obtain SystemInfo' & @CRLF
    Local $exePath = @WindowsDir & '\System32\systeminfo.exe'
    Local $comPath = @WindowsDir & '\System32\systeminfo.com'
    Local $cp, $pid, $stdout = ''
    ;
    If Not FileExists($exePath) Then
        FileWrite($hLogFile, $eMsg)
        Return
    EndIf
    ;
    $pid = Run($exePath, '', @SW_HIDE, 6)
    If Not $pid Then
        $cp = FileCopy($exePath, $comPath)
        If $cp Then
            $pid = Run($comPath, '', @SW_HIDE, 6)
        EndIf
        If Not $pid Then
            If $cp Then FileDelete($comPath)
            FileWrite($hLogFile, $eMsg)
            Return
        EndIf
    EndIf
    ;
    Do
        Sleep(10)
        $stdout &= StdoutRead($pid, 0, 0)
    Until @error
    ;
    If $cp Then FileDelete($comPath)
    If Not StringExists($stdout) Then
        FileWrite($hLogFile, $eMsg)
        Return
    EndIf
    ;
    Local $sFormatted, $sLeft, $sRight, $string
    $stdout = StringReplace($stdout, '[', '(')
    $stdout = StringReplace($stdout, ']', ')')
    $stdout = StringStripCR($stdout)
    Local $a = StringSplit($stdout, @LF)
    ;
    For $i = 1 To $a[0]
        $string = StringStripWS($a[$i], 3)
        If StringExists($string) Then
            If StringInStr($string, ':') Then
                $sLeft = StringStripWS(StringLeft($string, StringInStr($string, ':', 0, 1)), 3) & '|'
                $sRight = StringStripWS(StringTrimLeft($string, StringInStr($string, ':', 0, 1)), 3)
                $sFormatted &= $sLeft & $sRight & @CRLF
            Else
                $sFormatted &= $string & ':' & @CRLF
            EndIf
        EndIf
    Next
    FileWrite($hLogFile, '[System Information]' & @CRLF & $sFormatted)
EndFunc
;
;=========================================================
; NTLogs_GetEvents v2.02 - September 29, 2012 - by ripdad
;=========================================================
Func NTLogs_GetEvents()
    Local $sMsg, $sRec, $p = 0, $nRecordsToGet = 30
    Local $nCount, $nType, $nSearchDepth, $objClass
    Local $s1 = '', $s2 = '', $s3 = '', $utc = ''
    If $Vista_7 Then $utc = ' UTC'
    Local $aLogs = StringSplit('Application|System|Security', '|')

    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet($sWMI_Moniker)
    If $Object_Error Or Not IsObj($objWMI) Then
        Return SetError(-1, 0, $ObjError_Msg)
    EndIf
    ;
    For $i = 1 To $aLogs[0]
        $nSearchDepth = 0
        $nCount = 0

        GUICtrlSetData($lbl, 'Event Log -> ' & $aLogs[$i])

        $objClass = $objWMI.InstancesOf('Win32_NTLogEvent Where Logfile="' & $aLogs[$i] & '"')
        If $Object_Error Then Return SetError(-2, 0, $ObjError_Msg)
        ;
        For $objItem In $objClass
            $nSearchDepth += 1
            If ($nSearchDepth > 500) Then ExitLoop

            $p += 0.1
            If ($p > 100) Then $p = 0
            GUICtrlSetData($prb, $p)

            $sMsg = $objItem.Message
            If $Object_Error Then
                Return SetError(-3, 0, $ObjError_Msg)
            EndIf

            If Not StringExists($sMsg, 250) Then ContinueLoop

            $nType = $objItem.EventType

            Switch $nType
                Case 1; error
                Case 2; warning
                Case 3; information (ChkDsk)
                    If ($i > 1) Then ContinueLoop
                    If Not ($objItem.EventIdentifier = '1073742825') Then ContinueLoop
                    If Not StringInStr($sMsg, 'Checking file system') Then ContinueLoop
                    $sMsg = StringRegExpReplace($sMsg, '(?is)(.*)Internal Info.*', '\1')
                Case Else
                    ContinueLoop
            EndSwitch

            $sRec = '<--[ ' & $aLogs[$i] & ' Log'
            $sRec &= ' ] [ Type: ' & $objItem.Type
            $sRec &= ' ] [ Record #' & $objItem.RecordNumber
            $sRec &= ' ] [ ' & WMI_DTConvert($objItem.TimeGenerated) & $utc
            $sRec &= ' ] [ Source: ' & $objItem.SourceName
            $sRec &= ' ] [ EventID: ' & $objItem.EventIdentifier
            $sRec &= ' ] [ EventCode: ' & $objItem.EventCode
            $sRec &= ' ] [ User: ' & $objItem.User & ' ]' & @CRLF & @CRLF

            $sMsg = StringStripWS($sMsg, 3)
            $sMsg = StringReplace($sMsg, @CRLF, '^')
            $sMsg = StringStripWS($sMsg, 7)
            $sMsg = StringRegExpReplace($sMsg, '(\^{1,9})', '\^')
            $sMsg = StringRegExpReplace($sMsg, '(\s\^)|(\^\s)', '\^')
            $sMsg = StringReplace($sMsg, '^', @CRLF)
            $sMsg = StringRegExpReplace($sMsg, '(.{125}[\\ \-])', '\1' & @CRLF)

            $sRec &= $sMsg & @CRLF & @CRLF

            Switch $nType
                Case 1; error
                    $s1 &= $sRec
                Case 2; warning
                    $s2 &= $sRec
                Case 3; information (ChkDsk)
                    $s3 &= $sRec
                Case Else
            EndSwitch

            $nCount += 1
            If ($nCount >= $nRecordsToGet) Then ExitLoop
        Next
        If $Object_Error Then
            Return SetError(-4, 0, $ObjError_Msg)
        EndIf
    Next
    ;
    Local $nrf = 'No Records Found' & @CRLF & @CRLF
    Local $str = '[NTLog_Errors]' & @CRLF
    If $s1 Then
        $str &= $s1
    Else
        $str &= $nrf
    EndIf
    $str &= '[NTLog_Warnings]' & @CRLF
    If $s2 Then
        $str &= $s2
    Else
        $str &= $nrf
    EndIf
    $str &= '[NTLog_ChkDsk]' & @CRLF
    If $s3 Then
        $str &= $s3
    Else
        $str &= $nrf
    EndIf
    ;
    $objClass = ''
    $objWMI = ''
    $s1 = ''
    $s2 = ''
    $s3 = ''
    Return $str
EndFunc
;
Func WMI_DTConvert($x)
    If Not StringIsDigit(StringLeft($x, 14)) Then Return 'Unknown Date'
    Local $a = StringRegExp($x, '(\d{2})', 3)
    Return ($a[2] & '/' & $a[3] & '/' & $a[0] & $a[1] & ' - ' & $a[4] & ':' & $a[5] & ':' & $a[6])
EndFunc
;
Func Reg_GetRegistrySettings()
    ;<============================================================================HKEY_LOCAL_MACHINE
    Local $k1 = $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
    Local $k2 = $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects'
    Local $s = $HKLM & '\Software\Classes\.exe|'
    $s &= $HKLM & '\Software\Classes\.exe\PersistentHandler|'
    $s &= $HKLM & '\Software\Classes\exefile|'
    $s &= $HKLM & '\Software\Classes\exefile\DefaultIcon|'
    $s &= $HKLM & '\Software\Classes\exefile\shell\open\command|'
    $s &= $HKLM & '\Software\Classes\exefile\shell\runas\command|'
    $s &= $HKLM & '\Software\Clients\StartMenuInternet\FIREFOX.EXE\shell\open\command|'
    $s &= $HKLM & '\Software\Clients\StartMenuInternet\FIREFOX.EXE\shell\safemode\command|'
    $s &= $HKLM & '\Software\Clients\StartMenuInternet\IEXPLORE.EXE\shell\open\command|'
    $s &= $HKLM & '\Software\Microsoft\Rpc|'
    $s &= $HKLM & '\Software\Microsoft\Rpc\ClientProtocols|'
    $s &= $HKLM & '\Software\Microsoft\Rpc\SecurityService|'
    $s &= $HKLM & '\Software\Microsoft\Security Center|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Internet Settings|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Policies\Associations|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer|'
    $s &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion\Policies\System|'
    $s &= $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore|'
    $s &= $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\Windows|'
    $s &= $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\Winlogon|'
    ;<============================================================================HKEY_CURRENT_USER
    $s &= $HKCU & '\Software\Clients\StartMenuInternet|'
    $s &= $HKCU & '\Software\Microsoft\Internet Explorer\Download|'
    $s &= $HKCU & '\Software\Microsoft\Internet Explorer\Main|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Internet Settings|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\Associations|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun|'
    $s &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion\Policies\System|'
    $s &= $HKCU & '\Software\Microsoft\Windows NT\CurrentVersion\Windows|'
    $s &= $HKCU & '\Software\Microsoft\Windows NT\CurrentVersion\Winlogon|'
    ;
    Local $a = StringSplit(StringTrimRight($s, 1), '|')
    $s = $k1 & '^110' & @CRLF & Reg_Debuggers($k1)
    $s &= $k2 & '^110' & @CRLF & Reg_BHOs($k2)
    For $i = 1 To $a[0]
        $s &= $a[$i] & '^110' & @CRLF & Reg_GetValues($a[$i])
    Next
    FileWrite($hLogFile, @CRLF & '[Registry Settings]' & @CRLF & $s)
EndFunc
;
Func Reg_GetValues($k); v0.2
    Local $a, $e, $s, $v, $x
    For $i = 1 To 1000
        $v = '|' & RegEnumVal($k, $i)
        If @error <> 0 Then ExitLoop
        $s &= $v
    Next
    $a = StringSplit(StringTrimLeft($s, 1), '|')
    _ArraySort($a, 0, 1)
    $s = ''
    $v = RegRead($k, '')
    $e = @error
    If $e = 0 Then
        $s &= '(Default) = ' & $v & '^210' & @CRLF
    ElseIf $e = -1 Then
        $s &= '(Default) = (value not set)^210' & @CRLF
    Else
        $s &= '(key does not exist)^000' & @CRLF
    EndIf
    For $i = 1 To $a[0]
        If StringExists($a[$i]) Then
            $v = RegRead($k, $a[$i])
            $e = @error
            $x = @extended
            $v = StringRegExpReplace($v, '[\n\|]', ', ')
            If $x = 0 Then
                $s &= $a[$i] & ' = ^230' & @CRLF
            ElseIf $e = 0 Then
                $s &= $a[$i] & ' = ' & $v & '^2' & $x & '0' & @CRLF
            ElseIf $e = -1 Then
                $s &= $a[$i] & ' = (value not set)^2' & $x & '0' & @CRLF
            Else
                $s &= '(key does not exist)^000' & @CRLF
            EndIf
        EndIf
    Next
    Return $s
EndFunc
;
Func Reg_Debuggers($k)
    Local $sub, $v, $x, $s = ''
    For $i = 1 To 100; if exist, just get a max sample of 100
        $sub = RegEnumKey($k, $i)
        If @error <> 0 Then ExitLoop
        If $sub = 'Your Image File Name Here without a path' Then ContinueLoop
        $v = RegRead($k & '\' & $sub, 'Debugger')
        $x = @extended
        If $v Then $s &= $sub & '-->Debugger = ' & $v & '^2' & $x & '1' & @CRLF
    Next
    If $s Then Return $s
    Return '(No Debuggers Found)^000' & @CRLF
EndFunc
;
Func Reg_BHOs($k)
    Local $sub, $v, $x, $s = ''
    For $i = 1 To 100
        $sub = RegEnumKey($k, $i)
        If @error <> 0 Then ExitLoop
        $v = RegRead($HKLM & '\Software\Classes\CLSID\' & $sub & '\InprocServer32', '')
        $x = @extended
        If $v Then $s &= $sub & ' = ' & $v & '^2' & $x & '0' & @CRLF
    Next
    If $s Then Return $s
    Return '(No BHOs Found)^000' & @CRLF
EndFunc
;
Func Env_GetFriendlyPath($string)
    For $i = 1 To $aENV[0][0]
        If StringInStr($string, $aENV[$i][0]) Then
            $string = StringStripWS(StringReplace($string, $aENV[$i][0], $aENV[$i][1]), 3)
        EndIf
    Next
    Return $string
EndFunc
;
; =====================================================================================
; Function: Reg_GetFriendlyPath()
; Released: July 04, 2011 by ripdad
; Modified: May 17, 2012
; Version:  1.0.6
;
; Description: Extracts a given string taken from the registry and transforms it to
;              something more friendly for various uses - such as FileGetVersion()
;
; Dependencies: FileTool(), Env_GetFriendlyPath()
;
; Example: Yes
; =====================================================================================
Func Reg_GetFriendlyPath($string, $mode = 0)
    If StringInStr($string, '%') Then
        $string = Env_GetFriendlyPath($string)
    EndIf
    If StringRegExp(StringLeft($string, 1), '\W') Then
        $string = StringRegExpReplace($string, '\W+(.*)', '\1')
    EndIf
    $string = StringReplace($string, '"', '')
    If $mode = 0 Then Return $string; includes switches, keywords, etc
    ;
    ; The sections below, attempts to make the path proper for (File Properties) and (Jump to...) functions.
    ; Works when $mode is not 0.
    ;
    ; [Setup]
    Local $sFile, $sPath, $sResult, $nExts, $GetNumberOfExtensions = 1, $GetPrimaryPath = 3
    ;
    StringReplace($string, ':\', '')
    If @extended > 1 Then
        $string = StringLeft($string, StringInStr($string, ':\', 0, 2) - 2)
    ElseIf StringInStr($string, ':\') > 3 Then
        $string = StringLeft($string, StringInStr($string, ':\', 0, 1) - 2)
    EndIf
    $string = StringStripWS($string, 3)
    ;
    If StringInStr($string, '\') Then; separate file from path
        $sFile = StringTrimLeft($string, StringInStr($string, '\', 0, -1))
        $sPath = StringLeft($string, StringInStr($string, '\', 0, -1) - 1) & '\'
    Else
        $sFile = $string
        $sPath = ''
    EndIf
    ;
    $sFile = StringRegExpReplace($sFile, '[\/\,]', '|'); tag switches and commas
    If StringInStr($sFile, '|') Then; extract from 1st occurrence of a pipe
        $sFile = StringStripWS(StringLeft($sFile, StringInStr($sFile, '|', 0, 1) - 1), 3)
    EndIf
    ;
    $nExts = FileTool($sFile, $GetNumberOfExtensions)
    $string = $sPath & $sFile; reassemble path and file
    ; [/Setup]
    ;
    If $sPath And Not $nExts Then
        If StringInStr(StringRight($string, 4), '.', 0, 1, 1, 1) Then Return $string
    EndIf
    ;
    ; Attempt to extract path from $string in order of risk
    ;
    ; [Attempt 1]
    If $nExts Then; this file has one "known" executable extension
        $sResult = FileTool($string, $GetPrimaryPath); extract path from string
        If $sResult Then Return $sResult
        Return SetError(-1, 0, ''); file not found
    EndIf
    ;
    ; We are working with a file that has no extension from here.
    ;
    ; [Attempt 2]
    $sFile = StringReplace($sFile, ' -', '|'); tag '-' switches in $sFile
    If StringInStr($sFile, '|') Then; extract string from 1st occurrence
        $sFile = StringStripWS(StringLeft($sFile, StringInStr($sFile, '|', 0, 1) - 1), 3)
    EndIf
    $string = $sPath & $sFile & '.exe'
    $sResult = FileTool($string, $GetPrimaryPath)
    If $sResult Then Return $sResult
    ;
    ; [Attempt 3]
    $string = '(?i)( auto| delay| hide| hidden| max| min| run| wait)'
    $sFile = StringRegExpReplace($sFile, $string, '|'); tag keywords
    If StringInStr($sFile, '|') Then; extract string from 1st occurrence
        $sFile = StringStripWS(StringLeft($sFile, StringInStr($sFile, '|', 0, 1) - 1), 3)
    EndIf
    $string = $sPath & $sFile & '.exe'
    $sResult = FileTool($string, $GetPrimaryPath)
    If $sResult Then Return $sResult
    ;
    Return SetError(-2, 0, ''); file not found
EndFunc
;
; =====================================================================================
; Function: FileTool()
; Released: July 04, 2011 by ripdad
; Modified: May 23, 2012 - changed $sSysPath string for x64
; Version:  1.0.2
;
; Description: Has several abilities working with files and extensions.
;
; $nMode values:
;     1 = (Returns a number) of all "Defined Extensions" found in a string (Default)
;     2 = (Returns an array) of all "Defined Extensions" found in a string
;     3 = (Returns a string) of the first path found in a string
;
; Dependencies: None
;
; Example: Yes
; =====================================================================================
Func FileTool($sInput, $nMode = 1)
    Local $sPath, $sFile
    If StringInStr($sInput, '\') Then
        $sFile = StringTrimLeft($sInput, StringInStr($sInput, '\', 0, -1))
        $sPath = StringLeft($sInput, StringInStr($sInput, '\', 0, -1) - 1) & '\'
    Else
        $sFile = $sInput
        $sPath = ''
    EndIf
    Local $aExt = StringRegExp($sFile, '(?i)(\.exe|\.bat|\.cmd|\.com|\.msi|\.scr)', 3)
    If Not IsArray($aExt) Then Return SetError(-1, 0, 0); no matched extension found
    Local $nExt = UBound($aExt)
    If $nMode = 1 Then Return SetError(0, 0, $nExt); number of extensions
    If $nMode = 2 Then Return SetError(0, 0, $aExt); array of extensions
    Local $sDrvPath, $sSysPath, $sWinPath, $sExt, $nOS
    If $nMode = 3 Then; extract the path and check if it exist
        $sExt = $aExt[$nExt - 1]; get the last extension in string
        StringReplace($sFile, $sExt, ''); count occurrences of last extension in string
        $nOS = @extended; number of occurrences
        $sFile = StringStripWS(StringLeft($sFile, StringInStr($sFile, $sExt, 0, $nOS) + 3), 3); extract filename
        If StringInStr($sPath, '\') Then; string has a path
            $sPath &= $sFile; reassemble path and file
            If FileExists($sPath) Then Return SetError(0, 0, $sPath); file found
            Return SetError(-2, 0, 0); file not found
        Else; <-- this string has no path, so try system paths below
            $sDrvPath = @HomeDrive & '\' & $sFile
            $sSysPath = @WindowsDir & '\System32\' & $sFile
            $sWinPath = @WindowsDir & '\' & $sFile
            If FileExists($sWinPath) Then
                If FileExists($sSysPath) Then Return SetError(-3, 0, 0); multi-path
                If FileExists($sDrvPath) Then Return SetError(-4, 0, 0); multi-path
                Return SetError(0, 0, $sWinPath)
            ElseIf FileExists($sSysPath) Then
                If FileExists($sDrvPath) Then Return SetError(-5, 0, 0); multi-path
                Return SetError(0, 0, $sSysPath)
            ElseIf FileExists($sDrvPath) Then
                Return SetError(0, 0, $sDrvPath)
            Else
                Return SetError(-6, 0, 0); file not found
            EndIf
        EndIf
    EndIf
    Return SetError(-7, 0, 0); invalid mode
EndFunc
;
;=======================================================
; ProcessList_Extended v2.02 - May 27, 2012 - by ripdad
Func ProcessList_Extended()
    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet($sWMI_Moniker)
    If $Object_Error Or Not IsObj($objWMI) Then
        Return SetError(-1, 0, $ObjError_Msg)
    EndIf

    Local $objClass = $objWMI.InstancesOf('CIM_ProcessExecutable')
    Local $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return SetError(-2, 0, $ObjError_Msg)
    EndIf

    Local $sPath, $sPipe, $n = 0, $s = ''
    ;
    For $objItem In $objClass
        $n += 0.1
        If ($n > 100) Then $n = 0
        GUICtrlSetData($prb, $n)

        $sPath = $objItem.Antecedent

        If $Object_Error Then
            Return SetError(-3, 0, $ObjError_Msg)
        EndIf

        $sPath = StringRegExpReplace($sPath, '.*"(.*?)"', '\1')
        $sPath = Reg_GetFriendlyPath($sPath)
        $sPath = StringReplace($sPath, '\\', '\')
        $s &= '*' & $sPath
    Next
    If $Object_Error Then
        Return SetError(-4, 0, $ObjError_Msg)
    EndIf
    ;
    $s = StringTrimLeft($s, 1)
    Local $a = StringSplit($s, '*')

    GUICtrlSetData($lbl, 'Removing Duplicate Entries...')
    _Array_RemoveDuplicates($a)

    Local $s1 = '[Running Programs]' & @CRLF
    Local $s2 = @CRLF & '[Loaded Dlls]' & @CRLF
    Local $s3 = @CRLF & '[Loaded Misc]' & @CRLF
    Local $extension
    $s = ''
    $n = 0

    GUICtrlSetData($lbl, 'Getting File Properties...')
    ;
    For $i = 1 To $a[0]
        $n += 0.2
        If ($n > 100) Then $n = 0
        GUICtrlSetData($prb, $n)

        $sPath = $a[$i]
        $sPipe = '|'
        If StringInStr(FileGetAttrib($sPath), 'H') Then
            $sPipe = ' (HIDDEN)|'
        EndIf
        $extension = StringRight($sPath, 4)

        $s = $sPath & $sPipe & _LogFileProperties($sPath) & @CRLF
        If StringRegExp($extension, '(?i)(\.cmd|\.com|\.exe)') Then; [Running Programs]
            $s1 &= $s
        ElseIf StringRegExp($extension, '(?i)(\.dll)') Then; [Loaded Dlls]
            $s2 &= $s
        Else
            $s3 &= $s; [Loaded Misc]
        EndIf
    Next
    ;
    $s = $s1 & $s2 & $s3
    $objClass = ''
    $objWMI = ''
    Return $s
EndFunc
;
;============================================================
; #Function....: _Array_RemoveDuplicates()
; Description..: Removes duplicate entries in a 1D array
; Date.........: May 15, 2012 - by ripdad
; Version......: 1.00
; Requirements.: Array must be Indexed - #include array.au3
;============================================================
Func _Array_RemoveDuplicates(ByRef $array); (modified for SIL)
    If Not IsArray($array) Then Return SetError(-1, 0, 0)
    If UBound($array, 2) Then Return SetError(-2, 0, 0)
    If Not (UBound($array) = $array[0] + 1) Then
        Return SetError(-3, 0, 0)
    EndIf
    Local $n_os = 1
    Local $n = 0;<--SIL
    ;
    _ArraySort($array, 0, 1)
    ;
    While 1
        $n += 0.2;<--SIL
        If ($n > 100) Then $n = 0;<--SIL
        GUICtrlSetData($prb, $n);<--SIL
        ;
        For $i = $n_os To $array[0]
            If ($array[$i] = $array[$i - 1]) Then
                _ArrayDelete($array, $i)
                $n_os = $i - 1
                $array[0] -= 1
                ExitLoop
            ElseIf ($i = $array[0]) Then
                ExitLoop 2
            EndIf
        Next
    WEnd
EndFunc
;
Func _WMI_Drivers_Services($sClass)
    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet($sWMI_Moniker)
    If $Object_Error Or Not IsObj($objWMI) Then
        Return $ObjError_Msg
    EndIf

    Local $objClass = $objWMI.InstancesOf($sClass)
    Local $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return $ObjError_Msg
    EndIf

    Local $sPath, $s = ''

    For $objItem In $objClass
        If ($objItem.State = 'Running') Then
            $sPath = $objItem.PathName
            $sPath = Reg_GetFriendlyPath($sPath)
            $s &= '*' & $sPath & '|' & $objItem.DisplayName & '|' & _LogFileProperties(Reg_GetFriendlyPath($sPath, 1))
        EndIf
        If $Object_Error Then
            Return $ObjError_Msg
        EndIf
    Next
    If $Object_Error Then
        Return $ObjError_Msg
    EndIf

    Local $a = StringSplit(StringTrimLeft($s, 1), '*')
    _ArraySort($a, 0, 1)
    $s = ''
    For $i = 1 To $a[0]
        $s &= $a[$i] & @CRLF
    Next
    $objClass = ''
    $objWMI = ''
    Return $s
EndFunc
;
Func Reg_GetRunKeys()
    Local $str = $HKU & '|'
    $str &= $HKCU & '\Software\Microsoft\Windows\CurrentVersion|'
    $str &= $HKLM & '\Software\Microsoft\Windows\CurrentVersion|'
    If $OSA64 Then
        $str &= $HKLM & '\Software\Wow6432Node\Microsoft\Windows\CurrentVersion|'
    EndIf
    Local $aKeys = StringSplit(StringTrimRight($str, 1), '|')
    Local $key, $sub, $n = 1
    $str = ''
    ;
    For $i = 1 To $aKeys[0]
        If $i = 1 Then
            $sub = RegEnumKey($aKeys[$i], $n)
            If @error <> 0 Then ContinueLoop
            $key = $aKeys[$i] & '\' & $sub & '\Software\Microsoft\Windows\CurrentVersion'
            $n += 1
            $i = 0
        Else
            $key = $aKeys[$i]
        EndIf
        ;
        For $j = 1 To 1000
            $sub = RegEnumKey($key, $j)
            If @error <> 0 Then ExitLoop
            If StringInStr($sub, 'Run') Then $str &= $key & '\' & $sub & '|'
        Next
    Next
    Return StringSplit(StringTrimRight($str, 1), '|')
EndFunc
;
; =================================================================================================
; Function: GetCommonStartups
; Release Date: April 12, 2011
; Last Modified: September 29, 2012
; Version:  2.6.3
; Description: Enumerates all Run Keys (including all SID Run Keys), UserInit and Startup Folders
; =================================================================================================
Func GetCommonStartups()
    Local $UPD = StringLeft(@UserProfileDir, StringInStr(@UserProfileDir, '\', 0, -1) - 1)
    Local $WSP = @WindowsDir & '\System32\config\systemprofile', $WTD = @WindowsDir & '\Temp'
    Local $HKWOW_WLN = $HKLM & '\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Local $HKWOW_AID = $HKLM & '\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows'
    Local $HKLM_AID = $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\Windows'
    Local $HKLM_WLN = $HKLM & '\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Local $HKCU_WLN = $HKCU & '\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Local $nIcon, $sProp, $sPath, $str, $val, $vn
    Local $aKeys = Reg_GetRunKeys()
    ;
    For $i = 1 To $aKeys[0]
        $str &= $aKeys[$i] & '^110' & @CRLF
        For $j = 1 To 1000
            $vn = RegEnumVal($aKeys[$i], $j)
            If @error <> 0 Then ExitLoop
            $val = RegRead($aKeys[$i], $vn)
            $nIcon = @extended
            $val = Reg_GetFriendlyPath($val)
            $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
            ;
            If StringInStr($val, $UPD) Or StringInStr($val, $WSP) Or StringInStr($val, $WTD) Then
                $str &= $vn & '-->' & $val & '<--[!]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
            Else
                $str &= $vn & '-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
            EndIf
            $val = ''
        Next
    Next
    ;
    ; Wow6432Node - 64 bit OS
    If $Vista_7 And $OSA64 Then
        $str &= $HKWOW_WLN & '^110' & @CRLF
        $val = RegRead($HKWOW_WLN, 'Userinit')
        $nIcon = @extended
        $val = Reg_GetFriendlyPath($val)
        $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
        If $val <> 'userinit.exe' Then
            $str &= 'Userinit-->' & $val & '<--[Default: userinit.exe]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        Else
            $str &= 'Userinit-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
        EndIf
        ;
        $val = RegRead($HKWOW_WLN, 'Shell')
        $nIcon = @extended
        $val = Reg_GetFriendlyPath($val)
        $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
        If $val <> 'explorer.exe' Then
            $str &= 'Shell-->' & $val & '<--[Default: explorer.exe]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        Else
            $str &= 'Shell-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
        EndIf
        ;
        $val = RegRead($HKWOW_WLN, 'UIHost')
        $nIcon = @extended
        $val = Reg_GetFriendlyPath($val)
        $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
        If $val Then
            $str &= 'UIHost-->' & $val & '<--[Default: ValueName does not exist]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        EndIf
        ;
        $str &= $HKWOW_AID & '^110' & @CRLF
        $val = RegRead($HKWOW_AID, 'AppInit_DLLs')
        $nIcon = @extended
        $val = Reg_GetFriendlyPath($val)
        $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
        If $val Then
            $str &= 'AppInit_DLLs-->' & $val & '<--[Default: Blank]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        EndIf
    EndIf
    ;
    ; All OS
    $str &= $HKCU_WLN & '^110' & @CRLF
    $val = RegRead($HKCU_WLN, 'Shell')
    $nIcon = @extended
    $val = Reg_GetFriendlyPath($val)
    $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
    If $val Then
        $str &= 'Shell-->' & $val & '<--[Default: ValueName does not exist]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
    EndIf
    ;
    $str &= $HKLM_AID & '^110' & @CRLF
    $val = RegRead($HKLM_AID, 'AppInit_DLLs')
    $nIcon = @extended
    $val = Reg_GetFriendlyPath($val)
    $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
    If $val Then
        $str &= 'AppInit_DLLs-->' & $val & '<--[Default: Blank]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
    EndIf
    ;
    $str &= $HKLM_WLN & '^110' & @CRLF
    $val = RegRead($HKLM_WLN, 'Userinit')
    $nIcon = @extended
    $val = Reg_GetFriendlyPath($val)
    $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
    Switch $val
        Case ('userinit.exe'), (@WindowsDir & '\System32\userinit.exe'), (@WindowsDir & '\System32\userinit.exe,')
            $str &= 'Userinit-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
        Case Else
            $str &= 'Userinit-->' & $val & '<--[Default: ' & @WindowsDir & '\System32\userinit.exe,]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
    EndSwitch
    ;
    $val = RegRead($HKLM_WLN, 'UIHost')
    $nIcon = @extended
    $val = Reg_GetFriendlyPath($val)
    $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
    If $val Then
        If $Vista_7 Then
            $str &= 'UIHost-->' & $val & '<--[Default: ValueName does not exist]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        ElseIf $val <> 'logonui.exe' Then
            $str &= 'UIHost-->' & $val & '<--[Default: logonui.exe]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
        Else
            $str &= 'UIHost-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
        EndIf
    EndIf
    ;
    $val = RegRead($HKLM_WLN, 'Shell')
    $nIcon = @extended
    $val = Reg_GetFriendlyPath($val)
    $sProp = _LogFileProperties(Reg_GetFriendlyPath($val, 1))
    If $val <> 'explorer.exe' Then
        $str &= 'Shell-->' & $val & '<--[Default: explorer.exe]|' & $sProp & '^2' & $nIcon & '1' & @CRLF
    Else
        $str &= 'Shell-->' & $val & '|' & $sProp & '^2' & $nIcon & '0' & @CRLF
    EndIf
    ;
    ; Startup Folders
    $sPath = $UPD & '\'
    Local $Startup = '\' & StringTrimLeft(@StartupCommonDir, StringInStr(@StartupCommonDir, '\', 0, -3))
    Local $aPath, $sFolder, $sFile, $sCode, $sPipe, $string, $tPath, $shortcut = 0
    Local $hF = FileFindFirstFile($sPath & '*')
    If $hF = -1 Then
        MsgBox(8240, $sTitle, 'An error was encountered.' & @CRLF & 'Startup folders will not be processed.')
        Return StringSplit(StringTrimRight($str, 1), '|')
    EndIf
    While 1
        $sFolder = FileFindNextFile($hF)
        If @error Then ExitLoop
        If Not @extended Then ContinueLoop
        $string &= $sPath & $sFolder & '|'
    WEnd
    FileClose($hF)
    ;
    If $Vista_7 Then $string &= StringLeft(@StartupCommonDir, StringInStr(@StartupCommonDir, '\', 0, -3) - 1) & '|'
    Local $aItems = StringSplit(StringTrimRight($string, 1), '|')
    ;
    For $i = 1 To $aItems[0]
        $sPath = $aItems[$i] & $Startup
        If Not FileExists($sPath) Then ContinueLoop
        $hF = FileFindFirstFile($sPath & '\*')
        If $hF = -1 Then ContinueLoop
        $str &= $sPath & '^330' & @CRLF
        $tPath = $sPath
        While 1
            $sFile = FileFindNextFile($hF)
            If @error Then ExitLoop
            If @extended Then ContinueLoop
            If StringRight($sFile, 4) = '.ini' Then ContinueLoop
            If StringRight($sFile, 4) = '.lnk' Then
                $aPath = FileGetShortcut($sPath & '\' & $sFile)
                $tPath = $aPath[0]
                $shortcut = 1
            EndIf
            $sPipe = '|'
            $sCode = '^440'
            If StringInStr($tPath, $UPD) Or StringInStr($tPath, $WSP) Or StringInStr($tPath, $WTD) Then
                $sPipe = '<--[!]|'
                $sCode = '^441'
            EndIf
            If $shortcut Then
                $str &= $sFile & '-->' & $tPath & $sPipe & _LogFileProperties($tPath) & $sCode & @CRLF
            Else
                $str &= $sFile & '-->' & $tPath & '\' & $sFile & $sPipe & _LogFileProperties($tPath & '\' & $sFile) & $sCode & @CRLF
            EndIf
            $tPath = $sPath
            $shortcut = 0
        WEnd
        FileClose($hF)
    Next
    ;
    ; Show exe's in the following folders...
    Local $sD, $sF
    Local $a[18] = [17]
    $a[1] = FileGetLongName(StringLeft(@UserProfileDir, StringInStr(@UserProfileDir, '\', 0, -1) - 1))
    $a[2] = FileGetLongName(@UserProfileDir)
    $a[3] = FileGetLongName(@UserProfileDir & '\Local Settings\Application Data')
    $a[4] = FileGetLongName(@UserProfileDir & '\Local Settings\AppData')
    $a[5] = FileGetLongName(@AppDataDir)
    $a[6] = FileGetLongName(@AppDataCommonDir)
    $a[7] = FileGetLongName(@TempDir)
    $a[8] = FileGetLongName(@UserProfileDir & '\Local Settings\Application Data\Macromedia')
    $a[9] = FileGetLongName(@UserProfileDir & '\Local Settings\Application Data\Sun')
    $a[10] = FileGetLongName(@UserProfileDir & '\Recent')
    $a[11] = FileGetLongName(@UserProfileDir & '\Templates')
    $a[12] = FileGetLongName(@AppDataDir & '\Macromedia')
    $a[13] = FileGetLongName(@AppDataDir & '\Sun')
    $a[14] = FileGetLongName(@WindowsDir & '\System32\Config\SystemProfile')
    $a[15] = FileGetLongName(@WindowsDir & '\System32\Config\SystemProfile\Local Settings\Temp')
    $a[16] = FileGetLongName(@WindowsDir & '\System32\Config\SystemProfile\Start Menu\Programs\Startup')
    $a[17] = FileGetLongName(@WindowsDir & '\Temp')
    ;
    For $i = 1 To $a[0]
        If FileExists($a[$i]) Then
            $sD = $a[$i]
            $str &= $sD & '^330' & @CRLF
            $hF = FileFindFirstFile($sD & '\*')
            If $hF = -1 Then ContinueLoop
            While 1
                $sF = FileFindNextFile($hF)
                If @error Then ExitLoop
                If @extended Then ContinueLoop
                If StringRegExp(StringRight($sF, 4), '(?i)(\.bat|\.cmd|\.com|\.exe|\.scr)') Then
                    $str &= $sF & '-->' & $sD & '\' & $sF & '|' & _LogFileProperties($sD & '\' & $sF) & '^440' & @CRLF
                EndIf
            WEnd
        EndIf
    Next
    FileWrite($hLogFile, @CRLF & '[Common Startups]' & @CRLF & $str)
EndFunc
;
; _WMI_InstancesOf() - modified ver.0.6.SIL.05 - October 03, 2012 - by ripdad
Func _WMI_InstancesOf($sClass, $sPattern = 0, $iItemize = 0, $sNameSpace = 'CIMV2')
    ; gui - progress bar ======
    If $nAdv > 90 Then $nAdv = 0
    $nAdv += 10
    GUICtrlSetData($prb, $nAdv)
    ; =========================

    Local $a = StringRegExp($sClass, '^(\w+)(\W)', 3); check for GET enumeration string
    If IsArray($a) Then
        If Not StringIsSpace($a[1]) Then
            MsgBox(8240, '_WMI_InstancesOf', 'Unsupported Class String' & @TAB)
            Return SetError(-1, 0, '')
        EndIf
    EndIf
    $a = StringRegExp($sClass, '[^\w\.:=<>%" '']', 3); check for invalid characters
    If IsArray($a) Then
        MsgBox(8240, '_WMI_InstancesOf', 'Invalid Character in Class String -->   ' & $a[0] & @TAB)
        Return SetError(-2, 0, '')
    EndIf

    _WMI_ObjErrorReset()

    Local $sWMI_Moniker = 'Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\.\root\'
    Local $objWMI = ObjGet($sWMI_Moniker & $sNameSpace)
    If $Object_Error Or Not IsObj($objWMI) Then
        Return SetError(-3, 0, '<--' & $sClass & @CRLF & $ObjError_Msg & @CRLF)
    EndIf

    Local $objInstances = $objWMI.InstancesOf($sClass)

    $sClass = StringRegExpReplace($sClass, '(?i)(.*?)\W.*', '\1')

    Local $count = $objInstances.Count
    If $Object_Error Then
        Return SetError(-4, 0, '<--' & $sClass & @CRLF & $ObjError_Msg & @CRLF)
    ElseIf Not $count Then
        Return SetError(-4, 0, '')
    EndIf

    Local $objClass = $objWMI.Get($sClass, 0x20000); wbemFlagUseAmendedQualifiers
    If $Object_Error Or Not IsObj($objClass) Then
        Return SetError(-5, 0, '<--' & $sClass & @CRLF & $ObjError_Msg & @CRLF)
    EndIf

    Local $sp_dt1 = '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', $sp_dt2 = '\2/\3/\1 - \4:\5:\6'
    Local $Name, $Value, $Q_Item, $Q_Name, $string = ''
    Local $n = 0, $aVM = 0, $nVM = 0

    Local $pStatementMode = 1;Normal Statement Mode
    If StringInStr($sPattern, '^', 0, 1, 1, 1) Then
        $sPattern = StringTrimLeft($sPattern, 1)
        $pStatementMode = 2;NOT Statement Mode
    EndIf
    ;
    For $objInstance In $objInstances
        If $iItemize Then; set itemize format - x/y
            $n += 1
            $string &= '(' & $n & ')'
            If ($iItemize = 1) Then
                $string &= '^'
            EndIf
        EndIf
        ;
        For $objProperty In $objInstance.Properties_()
            $Name = $objProperty.Name; copy object name to var

            If $Object_Error Then; checking for object error inside loop
                Return SetError(-6, 0, '<--' & $sClass & @CRLF & $ObjError_Msg & @CRLF)
            EndIf

            ; [Filter]
            Switch $Name
                Case 'CreationClassName', 'CSCreationClassName', 'SystemCreationClassName', 'SystemName'
                    ContinueLoop
                Case Else
                    If $sPattern Then
                        If StringMatch($Name, $sPattern, $pStatementMode) Then ContinueLoop
                    EndIf
                    $Value = $objProperty.Value; copy object value to var
                    $Value = _WMI_ProcessItem($Value); process string
                    If Not StringLen($Value) Then; make sure we have a string to work with
                        ContinueLoop
                    EndIf
            EndSwitch; [/Filter]

            ; [Process Data Types]
            For $objQualifier In $objClass.Properties_($Name).Qualifiers_()
                $Q_Name = $objQualifier.Name
                $Q_Item = $objQualifier.Value

                If $Object_Error Then; checking for object error inside loop
                    If StringInStr(String($ObjError_Msg), '80020009') Then; 'Not Found'
                        _WMI_ObjErrorReset()
                        ExitLoop
                    EndIf
                    Return SetError(-7, 0, '<--' & $sClass & @CRLF & StringStripWS($ObjError_Msg, 3) & ', ' & $Name & ', (I-Loop)' & @CRLF & @CRLF)
                EndIf

                Switch $Q_Name
                    Case 'CIMType'
                        If ($Q_Item = 'DateTime') Then
                            If StringRegExp($Value, '(\d{14}\.\d{6}\W\d{1,4})') Then
                                $Value = StringLeft($Value, 14)
                                $Value = StringRegExpReplace($Value, $sp_dt1, $sp_dt2)
                            EndIf
                        EndIf
                    Case 'Units'
                        Switch $Q_Item
                            Case 'Bytes', 'KiloBytes', 'MegaBytes'
                                $Value = GetByteFormat($Value, $Q_Item)
                            Case Else
                                $Value &= ' ' & $Q_Item
                        EndSwitch
                    Case 'ValueMap'
                        If IsArray($Q_Item) And UBound($Q_Item) Then
                            $aVM = $Q_Item
                            $nVM = 1
                        EndIf
                    Case 'Values'; [Value Translation] - translated values appear in this format:  3=(Enabled)
                        If IsArray($Q_Item) And UBound($Q_Item) Then
                            If $nVM And StringIsDigit($Value) Then; [VT1] <- value is a number with a valuemap
                                If UBound($Q_Item) = UBound($aVM) Then
                                    For $i = 0 To UBound($Q_Item) - 1
                                        If StringMatch($Value, $aVM[$i]) Then
                                            $Value &= '=(' & $Q_Item[$i] & ')'
                                            ExitLoop
                                        EndIf
                                    Next
                                EndIf
                            ElseIf StringIsDigit($Value) Then;      [VT2] <- value is a number with no valuemap
                                For $i = 0 To UBound($Q_Item) - 1
                                    If StringMatch($Value, $i) Then
                                        $Value &= '=(' & $Q_Item[$i] & ')'
                                        ExitLoop
                                    EndIf
                                Next
                            ElseIf StringInStr($Value, ', ') Then;  [VT3] <- value is a comma delimited string
                                $a = StringSplit($Value, ', ', 1)
                                If StringIsDigit($a[1]) Then
                                    For $i = 1 To $a[0]
                                        For $j = 0 To UBound($Q_Item) - 1
                                            If StringMatch($a[$i], $j) Then
                                                $Value &= '^¦' & $a[$i] & '=(' & $Q_Item[$j] & ')'
                                            EndIf
                                        Next
                                    Next
                                EndIf
                            EndIf
                        EndIf
                        $nVM = 0; [/Value Translation]
                    Case Else
                        ; (reserved)
                EndSwitch
            Next; [/Process Data Types]

            If $Object_Error Then; checking for object error outside loop
                If StringInStr(String($ObjError_Msg), '80020009') Then; 'Not Found'
                    _WMI_ObjErrorReset()
                    ContinueLoop
                EndIf
                Return SetError(-8, 0, '<--' & $sClass & @CRLF & StringStripWS($ObjError_Msg, 3) & ', ' & $Name & ', (O-Loop)' & @CRLF & @CRLF)
            EndIf

            ; Skip values that return "Unknown"
            If StringInStr($Value, '=(Unknown)') Or $Value == -1 Then
                ; do nothing, let it go
            Else
                $string &= $Name & '¦' & $Value & '^'
            EndIf
        Next
        $string &= '^'
    Next

    $objInstances = ''
    $objClass = ''
    $objWMI = ''

    If $Object_Error Then
        Return SetError(-9, 0, '<--' & $sClass & @CRLF & $ObjError_Msg & @CRLF)
    EndIf

    $string = StringStripWS($string, 7)
    If Not $string Then
        Return SetError(-10, 0, '')
    EndIf

    $string = '<--' & $sClass & '^' & $string
    $string = StringReplace($string, @TAB, ' - ')
    $string = StringReplace($string, '^', @CRLF)
    $string = StringReplace($string, '|', ', ')
    $string = StringReplace($string, '¦', '|')
    Return $string
EndFunc
;
Func _WMI_QuickFixEngineering()
    Local $s = '<--Win32_QuickFixEngineering' & @CRLF

    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet($sWMI_Moniker)
    If $Object_Error Or Not IsObj($objWMI) Then
        Return $s & $ObjError_Msg
    EndIf

    Local $objClass = $objWMI.InstancesOf('Win32_QuickFixEngineering')
    If $Object_Error Then
        Return $s & $ObjError_Msg
    EndIf

    Local $std, $str, $string = ''

    For $objItem In $objClass
        $str = $objItem.HotFixID
        If $Object_Error Then
            Return $s & $ObjError_Msg
        EndIf

        If StringExists($str) And Not StringInStr($str, 'File 1') Then; (nothing useful for "File 1")
            $std = $objItem.InstalledOn
            If StringInStr($std, '/') Then
                $str &= '|' & $std
            EndIf
            $string &= $str & '^'
        EndIf
    Next

    $objClass = ''
    $objWMI = ''

    If $Object_Error Then
        Return $s & $ObjError_Msg
    EndIf

    If Not StringExists($string) Then
        Return $s
    EndIf

    Local $a = StringSplit(StringTrimRight($string, 1), '^')
    _ArraySort($a, 0, 1)

    For $i = 1 To $a[0]
        $s &= '(' & $i & ')  ' & $a[$i] & @CRLF
    Next
    Return $s
EndFunc
;
Func _WMI_ProcessItem($Item); v0.3
    If Not IsArray($Item) Then
        If StringExists($Item) Then
            Return StringStripWS($Item, 3)
        EndIf
        Return ''
    EndIf
    ;
    If Not UBound($Item) Then
        Return ''
    EndIf
    ;
    Local $string = ''
    For $i = 0 To UBound($Item) - 1
        If StringExists($Item[$i]) Then
            $string &= $Item[$i] & ', '
        EndIf
    Next
    ;
    If StringExists($string) Then
        $string = StringTrimRight($string, 2)
        Return StringStripWS($string, 3)
    EndIf
    Return ''
EndFunc
;
Func StringExists($s_String, $i_Chars = 30)
    $s_String = StringStripWS(StringLeft($s_String, $i_Chars), 8)
    If Not StringLen($s_String) Then
        Return SetError(0, 0, 0)
    ElseIf $s_String <> 0 Then
        Return SetError(0, 0, 1)
    Else
        Return SetError(0, 1, 1)
    EndIf
EndFunc
;
;======================================================================================
; #Function ...: StringMatch()
; Description .: A very simple and down to earth string compare. (with Statement Mode)
; Released ....: July 11, 2012 by ripdad
; Version .....: v1.00
; .............:
; Syntax ......: $s = Input String.
; .............: $c = Compare String.
; .............: $m = Statement Mode. (Default 0 = off)
; .............: $d = Delimiter to use. (Default '|')
; .............:
; Remarks .....: 1) It does not matter if Input is a string or number.
; .............: 2) Using low-case, it only cares "If THIS Strictly Matches THAT".
; .............: 3) Compares with Multiple Strings.
; .............: 4) Returns the Position Number if matched in Normal Mode.
; .............: 5) Returns 0 if not matched in Normal Mode.
;======================================================================================
Func StringMatch($s, $c, $m = 0, $d = '|')
    $s = StringLower($s)
    $c = StringLower($c)
    Local $n = 0
    Local $a = StringSplit($c, $d, 1)
    For $i = 1 To $a[0]
        If ($s == $a[$i]) Then
            $n = $i
            ExitLoop
        EndIf
    Next
    Switch $m
        Case 0; (OFF) Normal Mode
            If $n Then Return $n
        Case 1; (ON) If True, Then Return 1
            If $n = 0 Then Return 1
        Case 2; (ON) If True, Then Return 1
            If $n > 0 Then Return 1
    EndSwitch
    Return 0
EndFunc
;
;v0.02
Func GetByteFormat($n_b, $ns_os = 1); $ns_os can be number or string, within scope of function.
    If Not StringIsDigit($ns_os) Then
        $ns_os = StringMatch($ns_os, 'Bytes|KiloBytes|MegaBytes')
    EndIf
    Local $a_ab = StringSplit('Bytes|KB|MB|GB|TB', '|')
    If ($ns_os < 1) Or ($ns_os > $a_ab[0]) Then Return $n_b
    For $i = $ns_os To $a_ab[0]; in @ offset -> div -> abrv -> out
        If ($n_b < 1024) Then Return Round($n_b, 2) & ' ' & $a_ab[$i]
        $n_b /= 1024
    Next
EndFunc
;
Func _WMI_GetATAPISmartData(); Modified ver.1.0.SIL.01
    Local $a[76][2] = [[75, 'Attribute Name'], _
            [1, 'ReadErrorRate'], _
            [2, 'ThroughputPerformance'], _
            [3, 'SpinUpTime'], _
            [4, 'StartStopCount'], _
            [5, 'ReallocatedSectorsCount/SSDRetiredBlockCount'], _
            [6, 'ReadChannelMargin'], _
            [7, 'SeekErrorRate'], _
            [8, 'SeekTimePerformance'], _
            [9, 'PowerOnHours(POH)'], _
            [10, 'SpinRetryCount'], _
            [11, 'CalibrationRetryCount'], _
            [12, 'PowerCycleCount'], _
            [13, 'SoftReadErrorRate'], _
            [170, 'SSDReservedBlockCount'], _
            [171, 'SSDProgramFailBlockCount'], _
            [172, 'SSDEraseFailBlockCount'], _
            [173, 'SSDWearLevelingCount'], _
            [174, 'SSDUnexpectedPowerLossCount'], _
            [175, 'SSDProgramFailCount(Chip)'], _
            [176, 'SSDEraseFailCount(Chip)'], _
            [177, 'SSDWearRangeDelta/SSDWearLevelingCount'], _
            [178, 'SSDUsedReservedBlockCount(Chip)'], _
            [179, 'SSDUsedReservedBlockCount'], _
            [180, 'BlockCountTotal/SSDUnusedReservedBlockCount'], _
            [181, 'SSDProgramFailCount'], _
            [182, 'SSDEraseFailCount'], _
            [183, 'SATADownshiftErrorCount/SSDRuntimeBadBlock'], _
            [184, 'EndtoEnderror'], _
            [185, 'HeadStability'], _
            [186, 'InducedOpVibrationDetection'], _
            [187, 'ReportedUncorrectableErrors/SSDUncorrectableErrorCount'], _
            [188, 'CommandTimeout'], _
            [189, 'HighFlyWrites'], _
            [190, 'AirflowTemperatureWDC/TemperatureDifferenceFrom100'], _
            [191, 'GSenseErrorRate'], _
            [192, 'PoweroffRetractCount'], _
            [193, 'LoadCycleCount'], _
            [194, 'Temperature'], _
            [195, 'HardwareECCRecovered/SSDECCOnTheFlyCount'], _
            [196, 'ReallocationEventCount'], _
            [197, 'CurrentPendingSectorCount'], _
            [198, 'UncorrectableSectorCount/SSDOffLineUncorrectableErrorCount'], _
            [199, 'UltraDMACRCErrorCount/SSDCRCErrorCount'], _
            [200, 'MultiZoneErrorRate/WriteErrorRate'], _
            [201, 'OffTrackSoftReadErrorRate/SSDUncorrectableSoftReadErrorRate'], _
            [202, 'DataAddressMarkErrors'], _
            [203, 'RunOutCancel'], _
            [204, 'SSDSoftECCCorrection'], _
            [205, 'ThermalAsperityRate(TAR)'], _
            [206, 'FlyingHeight'], _
            [207, 'SpinHighCurrent'], _
            [208, 'SpinBuzz'], _
            [209, 'OfflineSeekPerformance'], _
            [210, 'VibrationDuringWrite'], _
            [211, 'VibrationDuringWrite'], _
            [212, 'ShockDuringWrite'], _
            [220, 'DiskShift'], _
            [221, 'GSenseErrorRateAlt'], _
            [222, 'LoadedHours'], _
            [223, 'LoadUnloadRetryCount'], _
            [224, 'LoadFriction'], _
            [225, 'LoadUnloadCycleCount'], _
            [226, 'LoadInTime'], _
            [227, 'TorqueAmplificationCount'], _
            [228, 'PowerOffRetractCycle'], _
            [230, 'GMRHeadAmplitude/SSDLifeCurveStatus'], _
            [231, 'SSDLifeLeft/Temperature'], _
            [232, 'AvailableReservedSpace/EnduranceRemaining'], _
            [233, 'MediaWearoutIndicator/PowerOnHours'], _
            [234, 'SSDReservedVS'], _
            [240, 'HeadFlyingHours/TransferErrorRate'], _
            [241, 'SSDLifeTimeWritesFromHost/TotalLBAsWritten'], _
            [242, 'SSDLifeTimeReadsFromHost/TotalLBAsRead'], _
            [250, 'ReadErrorRetryRate'], _
            [254, 'FreeFallProtection']]

    ; VSD = VendorSpecificData
    ; Nom/Flag = Nominal Value or Flag
    ; Cycles = Number of Turnovers from "Raw/Value". One Cycle = 256
    ; SumCounts = Dual Meaning, A Play on Words -> SumCounts (The total amount of 2 columns) And SomeCounts (as opposed to AllCounts):
    ;             1) The total of ("Cycles" * 256) + "Raw/Value"
    ;             2) Only the Attribute Names "PowerOnHours(POH)" Or the word "Count" in the string are processed in this column -- Else, it is set to zero.
    Local $aSMART[1][15] = [['Attribute', 'Nom/Flag', 'Status', 'Value/%', 'Worst/%', 'Raw/Value', 'Cycles', 'VSD1', 'VSD2', 'VSD3', 'VSD4', 'VSD5', 'Threshold', 'SumCounts', 'AttributeName']]

    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\.\root\CIMV2')
    If $Object_Error Or Not IsObj($objWMI) Then
        Return $ObjError_Msg
    EndIf

    Local $aDriveList[20][4]
    Local $aVendorSpecific, $objClass2, $sPNPDeviceID, $sDriveTitle
    Local $sInstanceName, $string, $n = 0, $nDevice = -1, $offset = 2

    Local $objClass = $objWMI.InstancesOf('Win32_DiskDrive')
    Local $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return $ObjError_Msg
    EndIf

    For $objItem In $objClass
        $n += 1
        $aDriveList[$n][0] = $objItem.Model
        $aDriveList[$n][1] = $objItem.DeviceID
        $aDriveList[$n][2] = $objItem.Size
        $aDriveList[$n][3] = $objItem.PNPDeviceID
        If $Object_Error Then
            Return $ObjError_Msg
        EndIf
    Next
    If $Object_Error Then
        Return $ObjError_Msg
    EndIf

    $aDriveList[0][0] = $n
    ReDim $aDriveList[$n + 1][4]

    $n = 0

    $objClass = $objWMI.InstancesOf('Win32_LogicalDiskToPartition')
    $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return $ObjError_Msg
    EndIf

    For $objItem In $objClass; Match DeviceID to Drive Letter
        $string = $objItem.Antecedent

        If $Object_Error Then
            Return $ObjError_Msg
        EndIf

        $string = StringRegExpReplace($string, '.*#(\d),.*', '\1')
        If ($string <> $nDevice) Then; Else, drive already processed
            $nDevice = $string

            $n += 1
            If $n > $aDriveList[0][0] Then
                ExitLoop; just in case
            EndIf

            If StringRight($aDriveList[$n][1], 1) = $nDevice Then
                $string = $objItem.Dependent
                $aDriveList[$n][1] &= '=' & StringRight($string, 4)
            EndIf
        EndIf
    Next
    If $Object_Error Then
        Return $ObjError_Msg
    EndIf

    $string = ''

    $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\.\root\WMI')
    If $Object_Error Or Not IsObj($objWMI) Then
        Return $ObjError_Msg
    EndIf

    $objClass = $objWMI.InstancesOf('MSStorageDriver_ATAPISmartData')
    $count = $objClass.Count
    If $Object_Error Or Not $count Then
        Return $ObjError_Msg
    EndIf

    For $objItem In $objClass
        $sInstanceName = $objItem.InstanceName
        $aVendorSpecific = $objItem.VendorSpecific

        If $Object_Error Then
            Return $ObjError_Msg
        EndIf

        If Not IsArray($aVendorSpecific) Then
            ContinueLoop
        EndIf

        For $i = 1 To $aDriveList[0][0]
            If StringInStr($sInstanceName, $aDriveList[$i][3]) Then
                $sPNPDeviceID = $aDriveList[$i][3]
                $sDriveTitle = 'Model: ' & $aDriveList[$i][0] & '*DeviceID: ' & $aDriveList[$i][1] & '*Size: ' & GetByteFormat($aDriveList[$i][2]) & '*'
                ExitLoop
            EndIf
        Next

        ReDim $aSMART[1][15]
        ReDim $aSMART[76][15]

        $n = 0

        For $i = $offset To (UBound($aVendorSpecific) - 1) Step 12
            If ($aVendorSpecific[$i] = 0) Then
                ContinueLoop
            EndIf

            $n += 1

            For $j = 0 To 11
                $aSMART[$n][$j] = $aVendorSpecific[$i + $j]
                If ($j = 2) Then
                    If ($aSMART[$n][$j] = 0) Then
                        $aSMART[$n][$j] = 'OK'
                    EndIf
                ElseIf ($j = 5) And (($aSMART[$n][0] = 190) Or ($aSMART[$n][0] = 194)) Then
                    If $aSMART[$n][5] Then
                        $aSMART[$n][5] &= 'C/' & Round(($aSMART[$n][5] * 1.8) + 32) & 'F'
                    EndIf
                EndIf
            Next

            For $j = 1 To $a[0][0]
                If $a[$j][0] = $aVendorSpecific[$i] Then
                    $aSMART[$n][14] = $a[$j][1]
                    If StringInStr($aSMART[$n][14], 'Count') Or ($aSMART[$n][0] = 9) Then
                        $aSMART[$n][13] = ($aSMART[$n][6] * 256) + $aSMART[$n][5]
                    Else
                        $aSMART[$n][13] = 0
                    EndIf
                EndIf
            Next
            If Not StringExists($aSMART[$n][14]) Then
                $aSMART[$n][14] = '(UnknownAttribute)';<--VendorSpecific
                $aSMART[$n][13] = 0
            EndIf
        Next

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictThresholds')
        $count = $objClass2.Count
        If $Object_Error Or Not $count Then
            Return $ObjError_Msg
        EndIf

        For $objItem In $objClass2
            $sInstanceName = $objItem.InstanceName
            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                $aVendorSpecific = $objItem.VendorSpecific
                ExitLoop
            EndIf
            If $Object_Error Then
                Return $ObjError_Msg
            EndIf
        Next
        If $Object_Error Then
            Return $ObjError_Msg
        EndIf

        If IsArray($aVendorSpecific) Then
            $n = 0
            For $i = $offset To (UBound($aVendorSpecific) - 1) Step 12
                If $aVendorSpecific[$i] Then
                    $n += 1
                    $aSMART[$n][12] = $aVendorSpecific[$i + 1]
                EndIf
            Next
        EndIf

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictStatus')
        $count = $objClass2.Count
        If $Object_Error Or Not $count Then
            Return $ObjError_Msg
        EndIf

        For $objItem In $objClass2
            $sInstanceName = $objItem.InstanceName
            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                $sDriveTitle &= 'PredictFailure=' & $objItem.PredictFailure
                ExitLoop
            EndIf
            If $Object_Error Then
                Return $ObjError_Msg
            EndIf
        Next
        If $Object_Error Then
            Return $ObjError_Msg
        EndIf

        ReDim $aSMART[$n + 1][15]

        $string &= $sDriveTitle & @CRLF

        For $i = 0 To UBound($aSMART) - 1
            For $j = 0 To 14
                $string &= $aSMART[$i][$j] & '|'
            Next
            $string = StringTrimRight($string, 1)
            $string &= @CRLF
        Next
        $string &= @CRLF
    Next
    If $Object_Error Then
        Return $ObjError_Msg
    EndIf
    Return $string
EndFunc
;
Func _WMI_ObjErrorReset()
    $ObjError_Msg = 'Unknown Object Error' & @CRLF
    $Object_Error = 0
EndFunc
;
Func _ObjErrorHandler()
    If Not IsObj($oErrorHandler) Then
        MsgBox(8240, 'ObjErrorHandler', 'Critical Error - Exiting', 10)
        Exit
    EndIf
    ;
    If $Object_Error Then
        Return
    EndIf
    ;
    Local $AOE1 = $oErrorHandler.ScriptLine
    Local $AOE2 = $oErrorHandler.Number
    Local $AOE3 = $oErrorHandler.Description
    Local $AOE4 = $oErrorHandler.WinDescription
    ;
    $oErrorHandler.Clear
    $ObjError_Msg = 'Object Error - '
    ;
    If $AOE1 Then $ObjError_Msg &= 'Line:' & $AOE1
    If $AOE2 Then $ObjError_Msg &= ' (0x' & Hex($AOE2, 8) & ') '
    If $AOE3 Then $ObjError_Msg &= $AOE3
    If $AOE4 Then $ObjError_Msg &= $AOE4
    $ObjError_Msg &= @CRLF
    $Object_Error = 1
EndFunc
;
Func SIL_TestOS()
    Switch $OSA
        Case 'X86'
            $HKCR = 'HKEY_CLASSES_ROOT'
            $HKCU = 'HKEY_CURRENT_USER'
            $HKLM = 'HKEY_LOCAL_MACHINE'
            $HKU = 'HKEY_USERS'
        Case 'X64'
            If Not @AutoItX64 Then
                ExitMsg('64Bit OS Detected. Please use the 64Bit version of this program.')
            EndIf
            $HKCR = 'HKEY_CLASSES_ROOT64'
            $HKCU = 'HKEY_CURRENT_USER64'
            $HKLM = 'HKEY_LOCAL_MACHINE64'
            $HKU = 'HKEY_USERS64'
            $OSA64 = 1
        Case Else
            ExitMsg('Not tested on --> ' & $OSA)
    EndSwitch
    ;
    Switch $OSV
        Case 'Win_2003', 'Win_XP'
            If $OSA <> 'X86' Then
                ExitMsg('Not tested on ' & $OSV & ' --> ' & $OSA)
            EndIf
        Case 'Win_2008', 'Win_2008R2', 'Win_7', 'Win_Vista'
            $Vista_7 = 1
        Case Else
            ExitMsg('Not tested on --> ' & $OSV)
    EndSwitch
EndFunc
;
Func ExitMsg($str)
    MsgBox(8208, $sTitle, $str & @TAB)
    Exit
EndFunc
;
Func SIL_TestWMI()
    Local $error, $obj_WMI

    _WMI_ObjErrorReset()

    _StartService('winmgmt')
    $error = @error

    Switch $error
        Case 0, 1056; (0 = started service), (1056 = already running)
            $obj_WMI = ObjGet($sWMI_Moniker & ':Win32_LocalTime')
            If Not $Object_Error And IsObj($obj_WMI) Then
                $nWMI = 1; success
            Else
                $nWMI = 'WMI Object Error: ' & $ObjError_Msg
            EndIf
        Case 1060
            $nWMI = 'WMI Service does not exist. Error: ' & $error
        Case Else
            $nWMI = 'WMI Service Error: ' & $error
    EndSwitch

    $obj_WMI = 0

    If $nWMI <> 1 Then
        MsgBox(8240, $sTitle & ' - ' & $nWMI, 'WMI Service Not Available.' & @CRLF & 'Information will be limited.' & @TAB)
        $nWMI = 0
    EndIf
EndFunc
;
Func _GetEnvironmentArray()
    Local $a[11][2] = [[10, '']]
    $a[1][0] = '%ProgramFiles(x86)%'
    $a[1][1] = RegRead($HKLM & '\Software\Microsoft\Windows\CurrentVersion', 'ProgramFilesDir (x86)')
    $a[2][0] = '%ProgramFiles (x86)%'
    $a[2][1] = $a[1][1]
    $a[3][0] = '%ProgramFiles%'
    $a[3][1] = RegRead($HKLM & '\Software\Microsoft\Windows\CurrentVersion', 'ProgramFilesDir')
    $a[4][0] = '%ProgramFilesDir%'
    $a[4][1] = $a[3][1]
    $a[5][0] = '%HomeDrive%'
    $a[5][1] = @HomeDrive
    $a[6][0] = '%SystemDrive%'
    $a[6][1] = $a[5][1]
    $a[7][0] = '%SystemRoot%'
    $a[7][1] = @WindowsDir
    $a[8][0] = '%WinDir%'
    $a[8][1] = $a[7][1]
    $a[9][0] = '%SystemDir%'
    $a[9][1] = @SystemDir
    $a[10][0] = '%SystemDirectory%'
    $a[10][1] = $a[9][1]
    Return $a
EndFunc
;
;===============================================================================
; Description:      Starts a service
; Syntax:           _StartService($sServiceName)
; Parameter(s):     $sServiceName - Name of service to start
; Requirement(s):   None
; Return Value(s):  On Success - Sets   @error = 0
;                   On Failure - Sets:  @error = 1056: Already running
;                                       @error = 1060: Service does not exist
; Author(s):        SumTingWong
; Documented by:    noone
;===============================================================================
Func _StartService($sServiceName)
    Local $arRet, $hSC, $hService, $lError = -1
    $arRet = DllCall("advapi32.dll", "long", "OpenSCManager", "str", "", "str", "ServicesActive", "long", 0x0001)
    If $arRet[0] = 0 Then
        $arRet = DllCall("kernel32.dll", "long", "GetLastError")
        $lError = $arRet[0]
    Else
        $hSC = $arRet[0]
        $arRet = DllCall("advapi32.dll", "long", "OpenService", "long", $hSC, "str", $sServiceName, "long", 0x0010)
        If $arRet[0] = 0 Then
            $arRet = DllCall("kernel32.dll", "long", "GetLastError")
            $lError = $arRet[0]
        Else
            $hService = $arRet[0]
            $arRet = DllCall("advapi32.dll", "int", "StartService", "long", $hService, "long", 0, "str", "")
            If $arRet[0] = 0 Then
                $arRet = DllCall("kernel32.dll", "long", "GetLastError")
                $lError = $arRet[0]
            EndIf
            DllCall("advapi32.dll", "int", "CloseServiceHandle", "long", $hService)
        EndIf
        DllCall("advapi32.dll", "int", "CloseServiceHandle", "long", $hSC)
    EndIf
    If $lError <> -1 Then SetError($lError)
EndFunc
;
; [-NOTES-]
;================================
;
; KEY Legend: ^###

;------------------------
; 1st Number = Item Type
;------------------------
; 0 = Text Only
; 1 = Key
; 2 = Value Name
; 3 = Folder
; 4 = File

;-------------------
; 2nd Number = Icon
;-------------------
; various numbers

;-------------------
; 3rd Number = Flag
;-------------------
; 0 = Normal
; 1 = Warning
;
;