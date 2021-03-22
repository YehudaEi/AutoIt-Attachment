#RequireAdmin

_WMI_ClassImport_InstalledSoftware()

Exit

;====================================================================
; Reference..: http://msdn.microsoft.com/en-us/library/ms974554.aspx
;====================================================================
Func _WMI_ClassImport_InstalledSoftware()
    If MsgBox(8228, 'WMI Prompt', 'Import InstalledSoftware Class?' & @TAB) <> 6 Then Return
    ;
    Local $s = '#PRAGMA AUTORECOVER' & @CRLF & @CRLF
    $s &= '[Dynamic, Provider("RegProv"), ProviderClsid("{FE9AF5C0-D3B6-11CE-A5B6-00AA00680C3F}"),' & @CRLF
    $s &= 'ClassContext("local|HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"),' & @CRLF
    $s &= 'Description("Provides information for installed software.")]' & @CRLF & @CRLF
    $s &= 'Class InstalledSoftware' & @CRLF
    $s &= '{' & @CRLF
    $s &= '    [key, PropertyContext("KeyName"), Description("KeyName")] string KeyName;' & @CRLF
    $s &= '    [read, PropertyContext("DisplayName"), Description("DisplayName")] string DisplayName;' & @CRLF
    $s &= '    [read, PropertyContext("DisplayVersion"), Description("DisplayVersion")] string DisplayVersion;' & @CRLF
    $s &= '    [read, PropertyContext("EstimatedSize"), Description("EstimatedSize")] uint32 EstimatedSize;' & @CRLF
    $s &= '    [read, PropertyContext("HelpLink"), Description("HelpLink")] string HelpLink;' & @CRLF
    $s &= '    [read, PropertyContext("InstallDate"), Description("InstallDate")] string InstallDate;' & @CRLF
    $s &= '    [read, PropertyContext("InstallLocation"), Description("InstallLocation")] string InstallLocation;' & @CRLF
    $s &= '    [read, PropertyContext("InstallSource"), Description("InstallSource")] string InstallSource;' & @CRLF
    $s &= '    [read, PropertyContext("Publisher"), Description("Publisher")] string Publisher;' & @CRLF
    $s &= '    [read, PropertyContext("QuietUninstallString"), Description("QuietUninstallString")] string QuietUninstallString;' & @CRLF
    $s &= '    [read, PropertyContext("ReadMe"), Description("ReadMe")] string ReadMe;' & @CRLF
    $s &= '    [read, PropertyContext("UninstallString"), Description("UninstallString")] string UninstallString;' & @CRLF
    $s &= '    [read, PropertyContext("URLInfoAbout"), Description("URLInfoAbout")] string URLInfoAbout;' & @CRLF
    $s &= '    [read, PropertyContext("URLUpdateInfo"), Description("URLUpdateInfo")] string URLUpdateInfo;' & @CRLF
    $s &= '};' & @CRLF
    ;
    Local $sFile = @ScriptDir & '\InstalledSoftware.mof'
    Local $hFile = FileOpen($sFile, 2)
    If $hFile = -1 Then Return SetError(-1)
    FileWrite($hFile, $s)
    FileClose($hFile)
    Sleep(2000)
    RunWait(@ComSpec & ' /k mofcomp.exe "' & $sFile & '"')
    FileDelete($sFile)
EndFunc
;
;
;
#cs

;=======================================================================
;=== EXAMPLE SCRIPT FOR USE - Save as: Example_InstalledSoftware.au3 ===
;=======================================================================
;
#RequireAdmin
;
Local $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Local $ObjError_Msg, $Object_Error
;
Local $rtn = _WMI_ClassExample('InstalledSoftware Where KeyName Like "%FireFox%"')
MsgBox(8256, 'Return Error: ' & @error, $rtn & @TAB)
Exit
;
Func _WMI_ClassExample($sClassName, $sComputerName = '.')
    _WMI_ObjErrorReset()
    Local $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate}!\\' & $sComputerName & '\root\Default')
    If $Object_Error Then Return SetError(-1, 0, $ObjError_Msg)
    Local $objClass = $objWMI.InstancesOf($sClassName)
    Local $count = $objClass.Count
    If $Object_Error Then Return SetError(-2, 0, $ObjError_Msg)
    If Not $count Then Return SetError(-3, 0, 'Instance Not Found')
    Local $name, $value, $string = ''
    ;
    For $objItem In $objClass
        For $objProperty In $objItem.Properties_()
            $name = $objProperty.Name
            $value = $objProperty.Value
            If $Object_Error Then
                Return SetError(-4, 0, $ObjError_Msg)
            Else
                If StringLen($value) Then
                    $string &= $name & ': ' & $value & @CRLF
                EndIf
            EndIf
        Next
    Next
    If $Object_Error Then Return SetError(-5, 0, $ObjError_Msg)
    If StringLen($string) Then Return $string
EndFunc
;
;==============================================================
; #Function...: _WMI_ObjErrorReset()
; Description.: External part of _ObjErrorHandler().
; Version.....; 0.1
;==============================================================
Func _WMI_ObjErrorReset()
    $ObjError_Msg = 'Unknown Object Error'
    $Object_Error = 0
EndFunc
;
;==============================================================
; #Function...: _ObjErrorHandler()
; Description.: Object error control.
; Version.....; 0.7
;==============================================================
Func _ObjErrorHandler()
    If Not IsObj($oErrorHandler) Then
        MsgBox(8240, 'ObjErrorHandler', 'Critical Error - Exiting', 10)
        Exit
    EndIf
    ;
    If $Object_Error Then
        $oErrorHandler.Clear
        Return; first error remains until reset.
    Else
        $Object_Error = 1
    EndIf
    ;
    Local $AOE1 = $oErrorHandler.ScriptLine
    Local $AOE2 = $oErrorHandler.Number
    Local $AOE3 = $oErrorHandler.Description
    Local $AOE4 = $oErrorHandler.WinDescription
    ;
    $oErrorHandler.Clear
    ;
    Local $sMsg = ''
    If $AOE1 Then $sMsg &= 'Line:' & $AOE1
    If $AOE2 Then $sMsg &= ' (0x' & Hex($AOE2, 8) & ') '
    If $AOE3 Then $sMsg &= $AOE3
    If $AOE4 Then $sMsg &= $AOE4
    ;
    If $sMsg Then
        $ObjError_Msg = 'Object Error - ' & $sMsg
    EndIf
EndFunc
;

#ce

