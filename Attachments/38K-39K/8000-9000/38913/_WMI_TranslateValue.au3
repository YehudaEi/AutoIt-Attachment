Local $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Local $ObjError_Msg, $Object_Error
;
Local $rtn = GetDomainRole(); example
MsgBox(0, 'GetDomainRole()', 'ReturnValue: ' & @error & @CRLF & 'ReturnString: ' & $rtn & @TAB)
;
Func GetDomainRole();<-- example function
    _WMI_ObjErrorReset()
    Local $objWMI = ObjGet('winmgmts:root\cimv2')
    If $Object_Error Then Return SetError(-1, 0, $ObjError_Msg)
    Local $objClass = $objWMI.Get('Win32_ComputerSystem')
    If $Object_Error Then Return SetError(-2, 0, $ObjError_Msg)

    Local $nRtn = $objClass.DomainRole
    If $Object_Error Then Return SetError(-3, 0, $ObjError_Msg)

    Local $String = _WMI_TranslateValue('Win32_ComputerSystem', 'DomainRole', $nRtn); <-- example function call
    If Not @error Then Return SetError($nRtn, 0, $String); <-- @error holds the original ReturnValue
    Return SetError(-4, 0, $ObjError_Msg)
EndFunc
;
;
;========================================================================================================
; #Function....: _WMI_TranslateValue($sClassName, $sPropertyName, $nValue, $nPropertyType, $sNameSpace)
;..............:
; Description..: Returns a translated string for properties that have a "Values" Qualifier.
; Example......: Yes
;..............:
; Syntax.......:    $sClassName = WMI Class Name
;..............: $sPropertyName = Property or Method Name
;..............:        $nValue = The "ReturnValue" to translate
;..............: $nPropertyType = Properties=1 or Methods=2 (Default=1)
;..............:    $sNameSpace = WMI Name Space (Default=CIMV2)
;========================================================================================================
Func _WMI_TranslateValue($sClassName, $sPropertyName, $nValue, $nPropertyType = 1, $sNameSpace = 'CIMV2')
    _WMI_ObjErrorReset()
    Local $objWMI = ObjGet('winmgmts:root\' & $sNameSpace)
    If $Object_Error Then Return SetError(-1)
    Local $objClass = $objWMI.Get($sClassName, 0x20000)
    If $Object_Error Then Return SetError(-2)
    Local $aValues

    Switch $nPropertyType
        Case 1
            $aValues = $objClass.Properties_($sPropertyName).Qualifiers_('Values').Value
        Case 2
            $aValues = $objClass.Methods_($sPropertyName).Qualifiers_('Values').Value
        Case Else
            Return SetError(-3)
    EndSwitch
    If $Object_Error Then Return SetError(-4)

    If IsArray($aValues) Then
        Return StringStripWS($aValues[$nValue], 7)
    EndIf
    Return SetError(-5)
EndFunc
;
Func _WMI_ObjErrorReset()
    $ObjError_Msg = 'Unknown Object Error'
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
        $oErrorHandler.Clear
        Return; first error remains until reset
    EndIf
    ;
    $Object_Error = 1
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
EndFunc
;
