#cs
    
    Virus Cleaning Tool - DPV v2.0
    Released: June 08, 2010 by ripdad
    Tested on Windows XP only - Use at your own risk!
    
    Cleans the Data Protection Virus Family
    
    Data Protection
    Your Protection
    Malware Defense
    Protection Center
    Paladin Antivirus
    
#ce
;
If Not (@OSVersion = 'WIN_XP') Then Exit; Remove this line at your own risk!
;
Global $dpv = ''
;
If FileExists(@ProgramFilesDir & '\Data Protection\dathook.dll') Then $dpv = 'Data Protection' & @CRLF; variant 1
If FileExists(@ProgramFilesDir & '\Data Protection\dighook.dll') Then $dpv = 'Data Protection' & @CRLF; variant 2
If FileExists(@ProgramFilesDir & '\Your Protection\urphook.dll') Then $dpv &= 'Your Protection' & @CRLF
If FileExists(@ProgramFilesDir & '\Protection Center\cnthook.dll') Then $dpv &= 'Protection Center' & @CRLF
If FileExists(@ProgramFilesDir & '\Paladin Antivirus\phook.dll') Then $dpv &= 'Paladin Antivirus' & @CRLF
If FileExists(@ProgramFilesDir & '\Malware Defense\mdext.dll') Then $dpv &= 'Malware Defense' & @CRLF
;
If $dpv = '' Then
    MsgBox(8256, 'Virus Cleaning Tool - DPV', 'Nothing Found')
    Exit
Else
    $answer = MsgBox(8228, 'Virus Cleaning Tool - DPV', 'Virus Found:  ' & $dpv & @CRLF & @CRLF & 'Clean Virus ?')
    If $answer = 7 Then Exit
EndIf
;
ToolTip('Desktop will return in a moment', 0, 0, 'Virus Cleaning Tool - DPV', 1)
Sleep(3000)
ToolTip('')
;
ProcessClose('explorer.exe')
Sleep(5000)
;
If ProcessExists('explorer.exe') Then
Else
    Run(@WindowsDir & '\explorer.exe')
EndIf
;
ToolTip('Please wait for Explorer to reload', 0, 0, 'Virus Cleaning Tool - DPV', 1)
Sleep(5000)
;
ToolTip('Closing Processes - Please Wait', 0, 0, 'Virus Cleaning Tool - DPV', 1)
_KPXPLite()
;
ToolTip('Cleaning Folders', 0, 0, 'Virus Cleaning Tool - DPV', 1)
Sleep(1000)
_CleanHidingPlaces()
_CleanVirusMedia()
;
ToolTip('Cleaning Registry', 0, 0, 'Virus Cleaning Tool - DPV', 1)
Sleep(1000)
_RegExistsDel('Data Protection')
_RegExistsDel('Your Protection')
_RegExistsDel('Malware Defense')
_RegExistsDel('Protection Center')
_RegExistsDel('Paladin Antivirus')
_CleanReg()
ToolTip('')
;
MsgBox(8256, 'Virus Cleaning Tool - DPV', 'Cleaning Finished')
Exit
;
Func _CleanReg()
    RegDelete('HKCR\secfile')
    RegDelete('HKCR\CLSID\{5E2121EE-0300-11D4-8D3B-444553540000}')
    RegDelete('HKCU\Software', '24d1ca9a-a864-4f7b-86fe-495eb56529d8')
    RegDelete('HKCU\Software', '7bde84a2-f58f-46ec-9eac-f1f90fead080')
    RegDelete('HKCR\Folder\shellex\ContextMenuHandlers\SimpleShlExt')
    RegDelete('HKCR\*\shellex\ContextMenuHandlers\SimpleShlExt')
    RegDelete('HKCU\Software\Microsoft\Internet Explorer\Main', 'Use FormSuggest')
    RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'wsdkrlxp.exe')
    RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'mplay32xe.exe')
    RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'DisableTaskMgr')
    RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyOverride')
    RegDelete('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved', '{5E2121EE-0300-11D4-8D3B-444553540000}')
    RegWrite('HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', 'REG_DWORD', '0')
    RegWrite('HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3', '1601', 'REG_DWORD', '1')
EndFunc
;
Func _RegExistsDel($sData)
    Local $rek
    For $i = 1 To 300
        $rek = RegEnumKey('HKLM\Software', $i)
        If @error <> 0 Then ExitLoop
        If $rek = $sData Then
            RegDelete('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' & $sData)
            RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', $sData)
            RegDelete('HKLM\Software\' & $sData)
            RegDelete('HKCU\Software\' & $sData)
            ExitLoop
        EndIf
    Next
EndFunc
;
Func _CleanHidingPlaces()
    ;Clean the Temp folders
    FileSetAttrib(@TempDir & '\*.*', '-RASHNOT')
    FileDelete(@TempDir & '\*.*')
    FileSetAttrib(@WindowsDir & '\Temp\*.*', '-RASHNOT')
    FileDelete(@WindowsDir & '\Temp\*.*')
    ;
    ; A dll or exe should not exist in the following root folders.
    ; Viruses like to hide in them - We will make sure they are clean.
    ;
    If FileExists(@AppDataCommonDir & '\*.dll') Then
        FileSetAttrib(@AppDataCommonDir & '\*.dll', '-RASHNOT')
        FileDelete(@AppDataCommonDir & '\*.dll')
    EndIf
    If FileExists(@AppDataCommonDir & '\*.exe') Then
        FileSetAttrib(@AppDataCommonDir & '\*.exe', '-RASHNOT')
        FileDelete(@AppDataCommonDir & '\*.exe')
    EndIf
    If FileExists(@AppDataDir & '\*.dll') Then
        FileSetAttrib(@AppDataDir & '\*.dll', '-RASHNOT')
        FileDelete(@AppDataDir & '\*.dll')
    EndIf
    If FileExists(@AppDataDir & '\*.exe') Then
        FileSetAttrib(@AppDataDir & '\*.exe', '-RASHNOT')
        FileDelete(@AppDataDir & '\*.exe')
    EndIf
    If FileExists(@UserProfileDir & '\Local Settings\Templates\*.dll') Then
        FileSetAttrib(@UserProfileDir & '\Local Settings\Templates\*.dll', '-RASHNOT')
        FileDelete(@UserProfileDir & '\Local Settings\Templates\*.dll')
    EndIf
    If FileExists(@UserProfileDir & '\Local Settings\Templates\*.exe') Then
        FileSetAttrib(@UserProfileDir & '\Local Settings\Templates\*.exe', '-RASHNOT')
        FileDelete(@UserProfileDir & '\Local Settings\Templates\*.exe')
    EndIf
    If FileExists(@UserProfileDir & '\Local Settings\Application Data\*.dll') Then
        FileSetAttrib(@UserProfileDir & '\Local Settings\Application Data\*.dll', '-RASHNOT')
        FileDelete(@UserProfileDir & '\Local Settings\Application Data\*.dll')
    EndIf
    If FileExists(@UserProfileDir & '\Local Settings\Application Data\*.exe') Then
        FileSetAttrib(@UserProfileDir & '\Local Settings\Application Data\*.exe', '-RASHNOT')
        FileDelete(@UserProfileDir & '\Local Settings\Application Data\*.exe')
    EndIf
EndFunc
;
Func _CleanVirusMedia()
    If FileExists(@ProgramFilesDir & '\Data Protection') Then
        FileSetAttrib(@ProgramFilesDir & '\Data Protection\*.*', '-RASHNOT')
        FileDelete(@ProgramFilesDir & '\Data Protection\*.*')
        DirRemove(@ProgramFilesDir & '\Data Protection', 1)
    EndIf
    If FileExists(@ProgramFilesDir & '\Your Protection') Then
        FileSetAttrib(@ProgramFilesDir & '\Your Protection\*.*', '-RASHNOT')
        FileDelete(@ProgramFilesDir & '\Your Protection\*.*')
        DirRemove(@ProgramFilesDir & '\Your Protection', 1)
    EndIf
    If FileExists(@ProgramFilesDir & '\Protection Center') Then
        FileSetAttrib(@ProgramFilesDir & '\Protection Center\*.*', '-RASHNOT')
        FileDelete(@ProgramFilesDir & '\Protection Center\*.*')
        DirRemove(@ProgramFilesDir & '\Protection Center', 1)
    EndIf
    If FileExists(@ProgramFilesDir & '\Paladin Antivirus') Then
        FileSetAttrib(@ProgramFilesDir & '\Paladin Antivirus\*.*', '-RASHNOT')
        FileDelete(@ProgramFilesDir & '\Paladin Antivirus\*.*')
        DirRemove(@ProgramFilesDir & '\Paladin Antivirus', 1)
    EndIf
    If FileExists(@ProgramFilesDir & '\Malware Defense') Then
        FileSetAttrib(@ProgramFilesDir & '\Malware Defense\*.*', '-RASHNOT')
        FileDelete(@ProgramFilesDir & '\Malware Defense\*.*')
        DirRemove(@ProgramFilesDir & '\Malware Defense', 1)
    EndIf
    If FileExists(@DesktopDir & '\troj000.exe') Then FileDelete(@DesktopDir & '\troj000.exe')
    If FileExists(@DesktopDir & '\spam001.exe') Then FileDelete(@DesktopDir & '\spam001.exe')
    If FileExists(@DesktopDir & '\spam002.exe') Then FileDelete(@DesktopDir & '\spam002.exe')
    If FileExists(@DesktopDir & '\spam003.exe') Then FileDelete(@DesktopDir & '\spam003.exe')
    If FileExists(@DesktopDir & '\*.com.lnk') Then FileDelete(@DesktopDir & '\*.com.lnk')
    If FileExists(@ProgramsCommonDir & '\Data Protection') Then DirRemove(@ProgramsCommonDir & '\Data Protection', 1)
    If FileExists(@ProgramsDir & '\Data Protection') Then DirRemove(@ProgramsDir & '\Data Protection', 1)
    If FileExists(@ProgramsCommonDir & '\Your Protection') Then DirRemove(@ProgramsCommonDir & '\Your Protection', 1)
    If FileExists(@ProgramsDir & '\Your Protection') Then DirRemove(@ProgramsDir & '\Your Protection', 1)
    If FileExists(@ProgramsCommonDir & '\Protection Center') Then DirRemove(@ProgramsCommonDir & '\Protection Center', 1)
    If FileExists(@ProgramsDir & '\Protection Center') Then DirRemove(@ProgramsDir & '\Protection Center', 1)
    If FileExists(@ProgramsCommonDir & '\Paladin Antivirus') Then DirRemove(@ProgramsCommonDir & '\Paladin Antivirus', 1)
    If FileExists(@ProgramsDir & '\Paladin Antivirus') Then DirRemove(@ProgramsDir & '\Paladin Antivirus', 1)
    If FileExists(@ProgramsCommonDir & '\Malware Defense') Then DirRemove(@ProgramsCommonDir & '\Malware Defense', 1)
    If FileExists(@ProgramsDir & '\Malware Defense') Then DirRemove(@ProgramsDir & '\Malware Defense', 1)
    If FileExists(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Data Protection.lnk') Then FileDelete(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Data Protection.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Data Protection Support.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Data Protection Support.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Data Protection.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Data Protection.lnk')
    If FileExists(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Your Protection.lnk') Then FileDelete(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Your Protection.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Your Protection Support.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Your Protection Support.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Your Protection.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Your Protection.lnk')
    If FileExists(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Protection Center.lnk') Then FileDelete(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Protection Center.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Protection Center Support.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Protection Center Support.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Protection Center.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Protection Center.lnk')
    If FileExists(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Paladin Antivirus.lnk') Then FileDelete(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Paladin Antivirus.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Paladin Antivirus Support.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Paladin Antivirus Support.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Paladin Antivirus.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Paladin Antivirus.lnk')
    If FileExists(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Malware Defense.lnk') Then FileDelete(@UserProfileDir & '\Application Data\Microsoft\Internet Explorer\Quick Launch\Malware Defense.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Malware Defense Support.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Malware Defense Support.lnk')
    If FileExists(@UserProfileDir & '\Desktop\Malware Defense.lnk') Then FileDelete(@UserProfileDir & '\Desktop\Malware Defense.lnk')
EndFunc
;
Func _KPXPLite(); Process Killer - Windows XP
    Local $s01 = '[System Process]'
    Local $s02 = 'System'
    Local $s03 = 'alg.exe'
    Local $s04 = 'csrss.exe'
    Local $s05 = 'explorer.exe'
    Local $s06 = 'lsass.exe'
    Local $s07 = 'services.exe'
    Local $s08 = 'smss.exe'
    Local $s09 = 'svchost.exe'
    Local $s10 = 'winlogon.exe'
    Local $s11 = 'taskmgr.exe'
    Local $s12 = 'userinit.exe'
    Local $s13 = 'wmiprvse.exe'
    Local $i01 = 'AutoIt3.exe'
    Local $i02 = @ScriptName
    Local $pr = ProcessList()
    For $i = 1 To $pr[0][0]
        Switch $pr[$i][0]
            Case $i01, $i02, $s01, $s02, $s03, $s04, $s05, $s06
            Case $s07, $s08, $s09, $s10, $s11, $s12, $s13
            Case Else
                ProcessClose($pr[$i][0])
        EndSwitch
        Sleep(500)
    Next
EndFunc
;
