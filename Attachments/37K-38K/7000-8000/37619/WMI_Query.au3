;===============================================================#
; WMI_Query.au3
; Description.: Displays WMI Class Info
; Released....: April 06, 2012 by ripdad
; Version.....: 1.04
;
; Modified....: April 08, 2012
;      * added: Cache, saved in @AppDataDir\WMI_Query_Cache
;      * added: _DeleteCache(), Press F9 to delete.
;      * added: WM_GETMINMAXINFO(), GUI minimal resize.
;
; Modified....: April 09, 2012
;      * fixed: HTML tags (left and right arrows) in some
;               WMI strings, causing some data not to display.

; Modified....: April 11, 2012
;      * fixed: Method Names that have a void CIMType.
;               Would cause method name not to display.
;
; Modified....: May 22, 2012
;      * fixed: Adjusted the height for the combo's.
;               x64 restriction has been removed.
;===============================================================#
;
#RequireAdmin
#include 'array.au3'
;
Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)
;
Local Const $s_Div = '<div style="width:98%;border:1px solid #000;background:#DDFFDD;padding:10px;font:normal 12px arial;color:#000;">'
Local Const $s_Span = '<span style="width:98%;background:#000090;padding:4px;font:bold 14px arial;color:#FFF;">'
;
Local Const $sWMI_Moniker = 'Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\' & @ComputerName & '\root\'
Local $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Local $tagMaxinfo, $sPattern = '(No Classes Found)|(Select a Class)'
Local $sType = 'Dynamic', $iFilter = 1, $Suppress_ErrorMsg = 1
Local $sPath_Cache = @AppDataDir & '\WMI_Query_Cache'
;
;TEST WMI ACCESS
Local $obj_WMI = ObjGet($sWMI_Moniker & 'CIMV2:Win32_LocalTime')
If @error Or Not IsObj($obj_WMI) Then
    MsgBox(8208, 'Error', 'WMI SERVICE: Unavailable - Exiting' & @TAB, 8)
    Exit
EndIf
$obj_WMI = 0
;
;TEST IE OBJECT
Local $ObjIE = ObjCreate('Shell.Explorer.2')
If @error Or Not IsObj($ObjIE) Then
    MsgBox(8208, 'Error', 'IE OBJECT: Unavailable - Exiting' & @TAB, 8)
    Exit
EndIf
;
Opt('GUIResizeMode', 1)
OnAutoItExitRegister('_Exit')
HotKeySet('{F9}', '_DeleteCache')
;
Local $ID_GUI = GUICreate('WMI Query', 700, 600, -1, -1, 0x00CF0000)
GUICtrlCreateGroup('Class Information', 10, 100, 680, 490)
Local $ID_Obj = GUICtrlCreateObj($ObjIE, 20, 120, 660, 456)
;
;TEST IE WRITE
_IE_Write_HTML($s_Span & 'WMI Query v1.04</span><p>Loading Name Spaces...</p>')
If @error Then
    MsgBox(8208, 'Error', 'IE OBJECT: Write Error - Exiting' & @TAB, 8)
    Exit
EndIf
$Suppress_ErrorMsg = 0
;
GUICtrlCreateGroup('Filter', 590, 4, 100, 91)
Local $ID_radio1 = GUICtrlCreateRadio('Abstract', 600, 25, 75, 18)
Local $ID_radio2 = GUICtrlCreateRadio('Dynamic', 600, 45, 75, 18)
Local $ID_radio3 = GUICtrlCreateRadio('Show All', 600, 65, 75, 18)
GUICtrlCreateGroup('Name Space', 10, 4, 570, 45)
Local $ID_NameSpaces = GUICtrlCreateCombo('', 20, 20, 550, 400)
GUICtrlCreateGroup('Class', 10, 50, 570, 45)
Local $ID_ClassNames = GUICtrlCreateCombo('', 20, 66, 550, 400)
GUICtrlSetState($ID_radio2, 1)
GUISetState(@SW_SHOW, $ID_GUI)
;
_WMI_Init()
;
GUIRegisterMsg(0x0024, 'WM_GETMINMAXINFO')
;
While 1
    Switch GUIGetMsg()
        Case -3
            ExitLoop
        Case $ID_radio1
            $sType = 'Abstract'
            $iFilter = 1
            _WMI_GUI_LoadClasses()
        Case $ID_radio2
            $sType = 'Dynamic'
            $iFilter = 1
            _WMI_GUI_LoadClasses()
        Case $ID_radio3
            $sType = 'Show All'
            $iFilter = 0
            _WMI_GUI_LoadClasses()
        Case $ID_NameSpaces
            _WMI_GUI_LoadClasses()
        Case $ID_ClassNames
            If Not StringRegExp(GUICtrlRead($ID_ClassNames), $sPattern) Then
                _GUI_Disable()
                _IE_Write_HTML('<p>Loading...</p>')
                _WMI_Class_Description(GUICtrlRead($ID_ClassNames), GUICtrlRead($ID_NameSpaces))
                _GUI_Enable()
                ControlFocus('WMI Query', '', '[CLASSNN:Internet Explorer_Server1]')
            EndIf
    EndSwitch
WEnd
Exit
;
Func _Exit()
    $ObjIE = 0
    GUIDelete($ID_GUI)
    Exit
EndFunc
;
Func WM_GETMINMAXINFO($hwnd, $Msg, $wParam, $lParam)
    $tagMaxinfo = DllStructCreate('int;int;int;int;int;int;int;int;int;int', $lParam)
    DllStructSetData($tagMaxinfo, 7, 700); minimum-width
    DllStructSetData($tagMaxinfo, 8, 600); minimum-height
    ;DllStructSetData($tagMaxinfo, 9, 1024); maximum-width
    ;DllStructSetData($tagMaxinfo, 10, 768); maximum-height
    Return 'GUI_RUNDEFMSG'
EndFunc
;
Func _GUI_Enable(); $GUI_ENABLE
    GUICtrlSetState($ID_ClassNames, 64)
    GUICtrlSetState($ID_NameSpaces, 64)
EndFunc
;
Func _GUI_Disable(); $GUI_DISABLE
    GUICtrlSetState($ID_ClassNames, 128)
    GUICtrlSetState($ID_NameSpaces, 128)
EndFunc
;
Func _IE_Write_HTML($strBody)
    Local $sHTML = '<html><head></head><body><font face="arial" size="2">' & @CRLF
    $sHTML &= $strBody & @CRLF
    $sHTML &= '</font></body></html>'
    ;================================
    $ObjIE.Navigate('about:blank')
    $ObjIE.Document.Write($sHTML)
    $ObjIE.Document.Close()
EndFunc
;
Func _DeleteCache()
    If FileExists($sPath_Cache) Then
        If DirRemove($sPath_Cache, 1) Then
            MsgBox(8256, 'WMI Query', 'Cache Deleted')
        EndIf
    EndIf
EndFunc
;
Func _WMI_Init()
    If Not FileExists($sPath_Cache) Then
        DirCreate($sPath_Cache)
    EndIf
    Local $hFile, $sClasses, $sNameSpaces
    Local $NameSpacesCache = $sPath_Cache & '\Name-Spaces.dat'
    If FileExists($NameSpacesCache) Then
        $sNameSpaces = StringReplace(FileRead($NameSpacesCache), @CRLF, '|')
    Else
        _GUI_Disable()
        $sNameSpaces = _WMI_LoadNameSpaces()
        $hFile = FileOpen($NameSpacesCache, 2)
        If $hFile <> -1 Then
            FileWrite($hFile, StringReplace($sNameSpaces, '|', @CRLF))
            FileClose($hFile)
        Else
            MsgBox(8240, 'WMI Query', 'Cannot Write to Cache')
        EndIf
        _GUI_Enable()
    EndIf
    GUICtrlSetData($ID_NameSpaces, $sNameSpaces, 'CIMV2')
    _WMI_GUI_LoadClasses()
EndFunc
;
Func _WMI_GUI_LoadClasses()
    If Not FileExists($sPath_Cache) Then
        DirCreate($sPath_Cache)
    EndIf
    GUICtrlSetData($ID_ClassNames, '')
    Local $hFile, $sClasses, $sNameSpace = GUICtrlRead($ID_NameSpaces)
    Local $ClassCache = $sPath_Cache & '\' & StringReplace($sNameSpace & '-' & $sType & '.dat', '\', '-')
    If FileExists($ClassCache) Then
        $sClasses = StringReplace(FileRead($ClassCache), @CRLF, '|')
        If $sClasses <> 'No Classes Found' Then
            GUICtrlSetData($ID_ClassNames, 'Select a Class|' & $sClasses, 'Select a Class')
        Else
            GUICtrlSetData($ID_ClassNames, $sClasses, $sClasses)
        EndIf
    Else
        _GUI_Disable()
        _IE_Write_HTML($s_Span & 'WMI Query v1.04</span><p>Loading Classes: ' & $sType & '</p>')
        $sClasses = _WMI_LoadClasses($sNameSpace, $iFilter, $sType)
        If @error Then
            $sClasses = 'No Classes Found'
            GUICtrlSetData($ID_ClassNames, $sClasses, $sClasses)
        Else
            GUICtrlSetData($ID_ClassNames, 'Select a Class|' & $sClasses, 'Select a Class')
        EndIf
        $hFile = FileOpen($ClassCache, 2)
        If $hFile <> -1 Then
            FileWrite($hFile, StringReplace($sClasses, '|', @CRLF))
            FileClose($hFile)
        Else
            MsgBox(8240, 'WMI Query', 'Cannot Write to Cache')
        EndIf
        _GUI_Enable()
    EndIf
    _IE_Write_HTML($s_Span & 'WMI Query v1.04</span><p>Ready</p>')
EndFunc
;
Func _WMI_Class_Description($sClass, $sName_Space = 'CIMV2')
    Local $objWMI = ObjGet($sWMI_Moniker & $sName_Space)
    If @error Or Not IsObj($objWMI) Then Return SetError(-1)
    Local $objClass = $objWMI.Get($sClass, 0x20000); wbemFlagUseAmendedQualifiers
    If @error Or Not IsObj($objClass) Then Return SetError(-2)
    ;
    Local $Name, $Value, $Description = 0, $String = ''
    Local $s = $s_Span & $sClass & '</span><br><br>^'; Class Name
    ;
    For $objQualifer In $objClass.Qualifiers_(); Class Qualifiers
        $Name = $objQualifer.Name
        $Value = $objQualifer.Value
        $Value = _WMI_ProcessItem($Value)
        If $Name = 'Description' Then; Class Description
            $s &= '<b>Description:</b> ' & $Value & '<br><br>^'
            $Description = 1
        Else
            $String &= '<b>' & $Name & ':</b> ' & $Value & '<br>^'
        EndIf
    Next
    If Not $Description Then
        $s &= '<b>Description:</b> (not found)<br><br>^'
    EndIf
    $s &= $String & '<br>^'
    ;
    $s &= '<li><b>Class System Properties</b></li><br>^'
    ;
    For $objProperty In $objClass.SystemProperties_(); Class System Properties
        $s &= $objProperty.Name & ': '
        $Value = $objProperty.Value
        $s &= _WMI_ProcessItem($Value) & '<br>^'
    Next
    ;
    $String = _WMI_Class_GetMethods($sClass, $sName_Space); Class Methods
    If $String Then
        $s &= '<br>^' & $s_Span & 'Class Methods</span><br><br>^'
        $s &= $String
    EndIf
    ;
    Local $str = ''
    For $objProperty In $objClass.Properties_(); Class Properties
        $str &= $s_Div & '[p] <b>' & $objProperty.Name & '</b></div><br>^'
        $Description = 0
        $String = ''
        For $objQualifer In $objProperty.Qualifiers_()
            $Name = $objQualifer.Name
            $Value = $objQualifer.Value
            $Value = _WMI_ProcessItem($Value)
            If $Name = 'Description' Then; Property Description
                $str &= '<b>Description:</b> ' & $Value & '<br><br>^'
                $Description = 1
            Else
                $String &= '<b>' & $Name & ':</b> ' & $Value & '<br>^'
            EndIf
        Next
        If Not $Description Then
            $str &= '<b>Description:</b> (not found)<br><br>^'
        EndIf
        $str &= '<b>Origin:</b> ' & $objProperty.Origin & '<br>^'
        $str &= '<b>IsArray:</b> ' & $objProperty.IsArray & '<br>^'
        $str &= '<b>IsLocal:</b> ' & $objProperty.IsLocal & '<br>^'
        $str &= $String & '<br>^'
    Next
    If $str Then
        $s &= '<br>^' & $s_Span & 'Class Properties</span><br><br>^'
        $s &= $str
    EndIf
    $s = StringReplace($s, @TAB, ' - ')
    $s = StringReplace($s, @LF, '<br>^')
    $s = StringReplace($s, '^', @CRLF)
    _IE_Write_HTML($s)
    $objClass = 0
    $objWMI = 0
    $str = 0
    $s = 0
EndFunc
;
Func _WMI_ProcessItem($Item)
    If Not IsArray($Item) Then
        If Not StringExists($Item) Then
            Return '(not found)'
        EndIf
        If StringRegExp($Item, '[<>]') Then
            If StringInStr($Item, '<b>') And Not StringInStr($Item, '</b>') Then; fix for bold with no closing tag
                $Item = StringReplace($Item, '<b>', '<br>^<b>') & '</b></b>'; 2 closing tags
            Else; fix for HTML tags in string (left and right arrows)
                $Item = StringReplace(StringReplace($Item, '<', '('), '>', ')')
            EndIf
        EndIf
        Return $Item
    EndIf
    ;
    If Not UBound($Item) Then; check for arrays with no elements
        Return '(not found)'; <-- unusable array
    EndIf
    ;
    Local $String = ''
    For $i = 0 To UBound($Item) - 1
        If StringExists($Item[$i]) Then
            $String &= $Item[$i] & ', '
        EndIf
    Next
    If Not StringExists($String) Then
        Return '(not found)'
    EndIf
    Return StringTrimRight($String, 2)
EndFunc
;
;====================================================================#
;#Function StringExists
; Date.....: March 30, 2012 - Final
;..........:
; Syntax...: $s_String = input string to test
;..........: $i_Chars = number of characters to grab (including WS)
;..........:
; Returns..: No String --> return=0, @extended=0
;..........: Is String --> return=1, @extended=0
;..........: Is a Zero --> return=1, @extended=1
;..........: (or number of zeros)
;..........:
; Remarks..: Refer to helpfile what StringStripWS strips from string.
;====================================================================#
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
; The entire reason for this function, is that nothing is in order for Methods.
; So, we have to piece it together, bit by bit, using the Syntax ID Number.
Func _WMI_Class_GetMethods($sClass, $sName_Space = 'CIMV2')
    Local $objWMI = ObjGet($sWMI_Moniker & $sName_Space)
    If @error Or Not IsObj($objWMI) Then Return SetError(-1)
    Local $objClass = $objWMI.Get($sClass, 0x20000); wbemFlagUseAmendedQualifiers
    If @error Or Not IsObj($objClass) Then Return SetError(-2)
    ;
    Local $n, $x, $Description, $Descriptions, $MethodName, $Name, $String, $Value
    Local $objParameters, $objInParameters, $objOutParameters
    Local $Mappings = '', $Methods = '', $sMethods = ''
    Local $array[1][12]
    ;
    For $objMethod In $objClass.Methods_()
        $MethodName = $objMethod.Name
        $Description = 0
        $sMethods = ''
        $String = ''
        For $objQualifier In $objMethod.Qualifiers_()
            $Name = $objQualifier.Name
            $Value = $objQualifier.Value
            $Value = _WMI_ProcessItem($Value)
            If $Name = 'Description' Then
                $sMethods &= '<b>Description:</b> ' & $Value & '<br><br>^'
                $Description = 1
            Else
                $String &= '<b>' & $Name & ':</b> ' & $Value & '<br>^'
            EndIf
        Next
        If Not $Description Then
            $sMethods &= '<b>Description:</b> (not found)<br><br>^'
        EndIf
        $sMethods &= '<b>Origin:</b> ' & $objMethod.Origin & '<br>^'
        If $String Then
            $sMethods &= $String & '<br>^'
        EndIf
        ;
        $String = ''
        $n = 0
        ;
        $objOutParameters = $objMethod.OutParameters
        If IsObj($objOutParameters) Then
            $n += $objOutParameters.Properties_.Count
        EndIf
        ;
        $objInParameters = $objMethod.InParameters
        If IsObj($objInParameters) Then
            $n += $objInParameters.Properties_.Count
        EndIf
        ;
        If $n Then; array template needs to be cleared, otherwise previous data might get reused.
            ReDim $array[1][12]; delete all elements, except row 0.
            ReDim $array[$n + 1][12]; make new template.
            $array[0][0] = $n; insert number of rows.
        Else
            ContinueLoop
        EndIf
        ;
        $n = 0
        ;
        For $i = 1 To 2
            $objParameters = 0
            If $i = 1 Then
                $objParameters = $objOutParameters
                $objOutParameters = 0
            Else
                $objParameters = $objInParameters
                $objInParameters = 0
            EndIf
            If Not IsObj($objParameters) Then ContinueLoop
            ;
            For $objProperty In $objParameters.Properties_()
                $x = 6
                $n += 1
                $array[$n][2] = $objProperty.Name
                ;
                For $objQualifier In $objProperty.Qualifiers_()
                    $Name = $objQualifier.Name
                    $Value = $objQualifier.Value
                    $Value = _WMI_ProcessItem($Value)
                    ;
                    Switch $Name
                        Case 'ID'
                            If $Value < 10 Then
                                $array[$n][0] = 0 & $Value
                            Else
                                $array[$n][0] = $Value
                            EndIf
                        Case 'In', 'Out'
                            $array[$n][1] = StringLower($Name)
                        Case 'CIMType'
                            $array[$n][3] = $Value
                        Case 'Optional'
                            $array[$n][4] = StringLower($Name)
                        Case 'Description'
                            $array[$n][5] = $Value
                        Case Else
                            If $array[$n][$x] Then
                                $x += 2
                            EndIf
                            $array[$n][$x] = $Name
                            $array[$n][$x + 1] = $Value
                    EndSwitch
                Next
            Next
        Next
        _ArraySort($array, 0, 1); Sort ID's -- (we have the necessary info; we can now assemble it)
        ;
        If StringIsDigit($array[1][0]) Then; fix for Method Names that have a void CIMType
            $String &= $s_Div & 'void <b>' & $MethodName & '</b>(<br>^'
        EndIf
        For $i = 1 To $array[0][0]
            If StringIsDigit($array[$i][0]) Then
                If $array[$i][1] Then; Syntax IO
                    $String &= '<b>id' & $array[$i][0] & ' -</b> [' & $array[$i][1] & ']'
                EndIf
                If $array[$i][2] Then; Syntax Parameter Name
                    $String &= ' <b>' & $array[$i][2] & '</b>'
                EndIf
                If $array[$i][3] Then; Syntax CIMType
                    $String &= ' ' & $array[$i][3]
                EndIf
                If $array[$i][4] Then; Syntax Optional
                    $String &= ' ' & $array[$i][4]
                EndIf
                If $array[$i][5] Then; Syntax Descriptions
                    If Not $Descriptions Then $Descriptions = '<li>Syntax Descriptions</li><br>^'
                    $Descriptions &= '<b>id' & $array[$i][0] & ' -</b> ' & $array[$i][5] & '<br><br>^'
                EndIf
                For $j = 6 To 10 Step 2
                    If $array[$i][$j] Then; Syntax Mappings
                        $String &= ' <font color="blue">[' & $array[$i][$j] & ']</font>'
                        If Not $Mappings Then $Mappings = '<li>Mappings - Units - Values</li><br>^'
                        $Mappings &= '<b>id' & $array[$i][0] & ' -</b> <font color="blue">[' & $array[$i][$j] & ']</font> - ' & $array[$i][$j + 1] & '<br>^'
                    EndIf
                Next
                $String &= ',<br>^'
            Else
                If $array[$i][1] Then; Syntax Start - CIMType, MethodName
                    $String &= $s_Div & $array[$i][3] & ' <b>' & $MethodName & '</b>(<br>^'
                EndIf
            EndIf
        Next
        If StringRight($String, 6) = ',<br>^' Then
            $String = StringTrimRight($String, 6); multi line
        Else
            $String = StringTrimRight($String, 5); single line
        EndIf
        $String &= ')</div><br>^'; Syntax Close
        $Methods &= $String & $sMethods
        ;
        If $Descriptions Then; add
            $Methods &= $Descriptions
            $Descriptions = ''
        EndIf
        ;
        If $Mappings Then; add
            $Methods &= $Mappings
            $Mappings = ''
        EndIf
        $Methods &= '<br>^'
    Next
    $objClass = 0
    $objWMI = 0
    $String = 0
    $array = 0
    If $Methods Then
        Return $Methods
    EndIf
    Return 0
EndFunc
;
Func _WMI_LoadClasses($sName_Space, $iFilter, $Qualifier)
    Local $objWMI = ObjGet($sWMI_Moniker & $sName_Space)
    If @error Or Not IsObj($objWMI) Then Return SetError(-1, 0, 0)
    Local $n = $objWMI.SubClassesOf.Count
    If Not $n Then Return SetError(-2, 0, 0)
    Local $a[$n + 1]
    $n = 0
    ;
    If $iFilter Then
        For $objClass In $objWMI.SubClassesOf()
            For $objQualifier In $objClass.Qualifiers_()
                If $objQualifier.Name = $Qualifier Then
                    $n += 1
                    $a[$n] = $objClass.Path_.Class
                EndIf
            Next
        Next
    Else
        For $objClass In $objWMI.SubClassesOf()
            $n += 1
            $a[$n] = $objClass.Path_.Class
        Next
    EndIf
    ;
    If Not $n Then Return SetError(-3, 0, 0)
    ReDim $a[$n + 1]
    $a[0] = $n
    _ArraySort($a, 0, 1)
    ;
    Local $sClasses = $a[1]
    For $i = 2 To $a[0]
        $sClasses &= '|' & $a[$i]
    Next
    Return $sClasses
EndFunc
;
Func _WMI_LoadNameSpaces()
    Local $sNameSpaces = ''
    _WMI_EnumNameSpaces('root', $sNameSpaces)
    $sNameSpaces = StringTrimLeft(StringReplace($sNameSpaces, '|root\', '|'), 1)
    Local $a = StringSplit($sNameSpaces, '|')
    _ArraySort($a, 0, 1)
    $sNameSpaces = $a[1]
    For $i = 2 To $a[0]
        $sNameSpaces &= '|' & $a[$i]
    Next
    Return $sNameSpaces
EndFunc
;
Func _WMI_EnumNameSpaces($sName_Space, ByRef $sNameSpaces); <-- Recursive Function
    Local $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug,Restore,Security)}!\\.\' & $sName_Space)
    If @error Then Return
    Local $ObjNameSpaces = $objWMI.InstancesOf('__NAMESPACE')
    For $ObjNameSpace In $ObjNameSpaces
        $sNameSpaces &= '|' & $sName_Space & '\' & $ObjNameSpace.Name
        _WMI_EnumNameSpaces($sName_Space & '\' & $ObjNameSpace.Name, $sNameSpaces)
    Next
EndFunc
;
Func _ObjErrorHandler()
    If Not IsObj($oErrorHandler) Then
        MsgBox(8240, ' Object Error', '$oErrorHandler is not an object!')
        Exit
    EndIf
    ;
    If $Suppress_ErrorMsg Then
        $oErrorHandler.Clear
        Return SetError(-1)
    EndIf
    ;
    Local $AOE1 = $oErrorHandler.Description
    Local $AOE2 = $oErrorHandler.WinDescription
    Local $AOE3 = $oErrorHandler.Number
    Local $AOE4 = $oErrorHandler.Source
    Local $AOE5 = $oErrorHandler.ScriptLine
    ;
    $oErrorHandler.Clear
    ;
    Local $eMsg = ''
    ;
    If $AOE1 Then $eMsg &= 'Description: ' & $AOE1 & @TAB & @CRLF
    If $AOE2 Then $eMsg &= 'WinDesciption: ' & $AOE2 & @TAB & @CRLF
    If $AOE3 Then $eMsg &= 'Error Number: ' & Hex($AOE3, 8) & @TAB & @CRLF
    If $AOE4 Then $eMsg &= 'Source Name: ' & $AOE4 & @TAB & @CRLF
    If $AOE5 Then $eMsg &= 'Script Line: ' & $AOE5 & @TAB & @CRLF
    ;
    If $eMsg Then
        MsgBox(8240, ' Object Error', $eMsg)
    Else
        MsgBox(8240, ' Object Error', 'Unknown Error')
    EndIf
    Return SetError(-1)
EndFunc
;



