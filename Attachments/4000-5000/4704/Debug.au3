_Debug() ;// start debugging...

For $i = 0 To 100 Step 10
   _Debug('$i: ' & $i)
Next

_Debug() ;// end debugging...

Func _Debug($msg = '', $ShowWin = False, $Prefix = True)
   Local $DebugHwnd, $Start = False
   $DebugHwnd = GlobalVarsRead('DebugHwnd', @ScriptName)
   If $DebugHwnd <> "" Then
      $DebugHwnd = Hwnd($DebugHwnd)
   Else
      $Start = True
      $DebugHwnd = AutoItHandle()
      WinSetTitle($DebugHwnd, '', 'Debug ' & @ScriptName)
      WinMove($DebugHwnd, '', Default, Default, 400, 400)
      GlobalVarsWrite('DebugHwnd', $DebugHwnd, @ScriptName)
   EndIf
   If NOT IsHwnd($DebugHwnd) Then Return 1
   If $ShowWin Then WinSetState($DebugHwnd, '', @SW_SHOW)
   If $msg <> '' Then
      If $msg = '[CRLF]' Then
         $msg = ''
      ElseIf $Prefix Then
         $msg = '[' & _CurTime() & '] ' & $msg
      EndIf
      ControlAddLine($DebugHwnd, "", 'Edit1', $msg & @CRLF)
   ElseIf $msg = '' Then
      If $Start = False Then
         If NOT IsVisible($DebugHwnd) Then WinSetState($DebugHwnd, '', @SW_SHOW)
         If NOT WinActive($DebugHwnd) Then WinActivate($DebugHwnd)
         GlobalVarsDelete('', @ScriptName)
         WinWaitClose($DebugHwnd)
      EndIf
   EndIf
EndFunc

Func _CurTime()
   Return @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
EndFunc

Func AutoItHandle()
   Local $TS
   Local $OldTitle, $hwnd
   $OldTitle = AutoItWinGetTitle()
   $TS = 1000 * ((3600 * @Hour) + (60 * @Min) + @Sec)
   AutoItWinSetTitle($TS)
   $hwnd = WinGetHandle($TS)
   AutoItWinSetTitle($OldTitle)
   Return $hwnd
EndFunc   ;==>AutoItHandle

Func GlobalVarsRead($VarName, $Section = 'Other')
   If $Section = '' Then $Section = 'Other'
   Return INIRead(@TempDir & '\GlobalVars.ini', $Section, $VarName, '')
EndFunc

Func GlobalVarsDelete($VarName = '', $Section = 'Other')
   If $VarName = '' Then
      Return INIDelete(@TempDir & '\GlobalVars.ini', $Section)
   Else
      Return INIDelete(@TempDir & '\GlobalVars.ini', $Section, $VarName)
   EndIf
EndFunc

Func GlobalVarsWrite($VarName, $VarValue = '', $Section = '', $File = '')
   Local $IniFile
   If $File <> '' Then
      $IniFile = @TempDir & '\' & $File
   Else
      $IniFile = @TempDir & '\GlobalVars.ini'
   EndIf
   If $Section = '' Then $Section = 'Other'
   Return INIWrite($IniFile, $Section, $VarName, $VarValue)
EndFunc

Func ControlAddLine($window, $Text, $control, $Line)
   Return ControlSetText($window, $Text, $control, ControlGetText($window, $Text, $control) & $Line)
EndFunc   ;==>ControlAddLine

Func IsVisible($handle)
  If BitAnd(WinGetState($handle), 2) Then Return True
EndFunc