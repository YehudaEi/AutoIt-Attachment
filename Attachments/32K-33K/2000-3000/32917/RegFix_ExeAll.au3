#RequireAdmin

; RegFix_ExeAll v1.00
; Released: January 18, 2011

; Description: Repairs corrupted registry values associated with exe's due to viruses.

If MsgBox(8228, 'RegFix_ExeAll', 'Proceed to fix registry?') = 7 Then Exit

;# Order of Function Calls
;========================================================================================
RegFix_Redirects(); Check All Profiles for exe redirects. (example: the av.exe virus)
RegFix_Debugger(); Delete debuggers. (Programs will not run if debuggers are present)
Check_ExeKeys(); Check if keys are corrupted. Overwrite with known good data if they are.
;========================================================================================

Func RegFix_Redirects()
    Local $s, $e, $k = 'HKEY_USERS'
    For $i = 1 To 1000
        $s = RegEnumKey($k, $i)
        If @error <> 0 Then ExitLoop
        For $j = 1 To 1000
            $e = RegEnumKey($k & '\' & $s, $j)
            If @error <> 0 Then ExitLoop
            If ($e = '.exe') Or ($e = 'secfile') Then RegDelete($k & '\' & $s & '\' & $e)
        Next
    Next
EndFunc
;
Func RegFix_Debugger()
    Local $k = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
    Local $n, $v = 'Debugger', $p = 'Your Image File Name Here without a path'
    If RegRead($k, $v) Then RegDelete($k, $v)
    For $i = 1 To 10000
        $n = RegEnumKey($k, $i)
        If @error <> 0 Then ExitLoop
        If $n = $p Then ContinueLoop
        If RegRead($k & '\' & $n, $v) Then
            RegDelete($k & '\' & $n, $v)
            $i -= 1
        EndIf
        If Not RegEnumVal($k & '\' & $n, 1) Then RegDelete($k & '\' & $n)
    Next
EndFunc
;
Func Check_ExeKeys()
    Local $count = 0
    If RegRead('HKEY_CLASSES_ROOT\.exe', '') <> 'exefile' Then $count += 1
    If RegRead('HKEY_CLASSES_ROOT\.exe', 'Content Type') <> 'application/x-msdownload' Then $count += 1
    If RegRead('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '') <> '{098f2470-bae0-11cd-b579-08002b30bfeb}' Then $count += 1
    If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', '') <> '"%1" %*' Then $count += 1
    If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '') <> '"%1" %*' Then $count += 1
    If (@OSVersion = 'WIN_VISTA') Or (@OSVersion = 'WIN_7') Then
        If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand') <> '"%1" %*' Then $count += 1
        If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand') <> '"%1" %*' Then $count += 1
    EndIf
    If RegRead('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '') <> '{86C86720-42A0-1069-A2E8-08002B30309D}' Then $count += 1
    If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList', 1) Then $count += 1
    If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 1) <> 'exefile' Then $count += 1
    If RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile') <> '' Then $count += 1
    If $count > 0 Then RegFix_ExeKeys()
EndFunc
;
Func RegFix_ExeKeys()
    If @OSVersion = 'WIN_XP' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'InfoTip', 'REG_SZ', 'prop:FileDescription;Company;FileVersion;Create;Size')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'TileInfo', 'REG_SZ', 'prop:FileDescription;Company;FileVersion')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\PifProps', '', 'REG_SZ', '{86F19A00-42A0-1069-A2E9-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\{B41DB860-8EE4-11D2-9906-E49FADC173CA}', '', 'REG_SZ', '')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_VISTA' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_7' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas', 'HasLUAShield', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', '', 'REG_SZ', '@shell32.dll,-50944')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'Extended', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'SuppressionPolicyEx', 'REG_SZ', '{F211AA05-D4DF-4370-A2A0-9F19C09756A7}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser\command', 'DelegateExecute', 'REG_SZ', '{ea72d00e-4960-42fa-ba92-7792a7944c1d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers', '', 'REG_SZ', 'Compatibility')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers\Compatibility', '', 'REG_SZ', '{1d27f844-3a1f-4410-85ac-14651078412d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    EndIf
EndFunc
;
