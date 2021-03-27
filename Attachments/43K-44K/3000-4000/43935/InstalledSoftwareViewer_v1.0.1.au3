#RequireAdmin

#include 'array.au3'

Opt('TrayAutoPause', 0)
Opt('MustDeclareVars', 1)

Local $ID_GUI = GUICreate(' Installed Software Viewer v1.0.1', 810, 615, Default, Default, 0x00CF0000)
Local $ID_LVW = GUICtrlCreateListView('#|Installed Software|Display Version|Publisher|Uninstall String|Install Date|IsMSI|NoRemove', 5, 5, 800, 600)

Local $a = _ComputerGetSoftware()

For $i = 1 To $a[0][0]
    GUICtrlCreateListViewItem($i & '|' & $a[$i][0] & '|' & $a[$i][1] & '|' & $a[$i][2] & '|' & $a[$i][3] & '|' & $a[$i][4] & '|' & $a[$i][5] & '|' & $a[$i][6], $ID_LVW)
Next

Local Const $LVM_SETCOLUMNWIDTH = 0x101E
GUICtrlSendMsg($ID_LVW, $LVM_SETCOLUMNWIDTH, 1, 200)
GUICtrlSendMsg($ID_LVW, $LVM_SETCOLUMNWIDTH, 2, 100)
GUICtrlSendMsg($ID_LVW, $LVM_SETCOLUMNWIDTH, 3, 150)
GUICtrlSendMsg($ID_LVW, $LVM_SETCOLUMNWIDTH, 4, 150)
GUICtrlSendMsg($ID_LVW, $LVM_SETCOLUMNWIDTH, 5, 70)

Local $ID_MEN = GUICtrlCreateContextMenu($ID_LVW)
Local $ID_CPY = GUICtrlCreateMenuItem('Copy Uninstall String to Clipboard', $ID_MEN)

GUICtrlSetOnEvent($ID_CPY, '_Copy2Clip')
GUISetOnEvent(-3, '_AllExit')
Opt('GUIOnEventMode', 1)

GUISetState(@SW_SHOW, $ID_GUI)

While 1
    Sleep(60000)
WEnd

Func _AllExit()
    GUIDelete($ID_GUI)
    Exit
EndFunc

Func _Copy2Clip()
    ClipPut('')
    Local $array = StringSplit(GUICtrlRead(GUICtrlRead($ID_LVW)), '|', 1)
    If StringLen(StringStripWS($array[5], 8)) Then ClipPut($array[5])
EndFunc
;
;
;===============================================
; #FUNCTION _ComputerGetSoftware()
; Author: JSThePatriot
; http://www.autoitscript.com/forum/topic/29404-computer-info-udfs/?hl=%20_computergetsoftware
;
; Modified by ripdad: April 17, 2014
;
; Remarks:
; Last two columns are bits (0 or 1).
; Blank Fields = no value found
;===============================================
Func _ComputerGetSoftware()

    Switch @OSArch
        Case 'X64'
            Local $sHKCU = 'HKEY_CURRENT_USER64', $sHKLM = 'HKEY_LOCAL_MACHINE64'
            Local $sSubKey1 = '\Software\Microsoft\Windows\CurrentVersion\Uninstall'
            Local $sSubKey2 = '\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
            Local $aKeys[4] = [3, $sHKCU & $sSubKey1, $sHKLM & $sSubKey1, $sHKLM & $sSubKey2]
        Case 'X86'
            Local $sHKCU = 'HKEY_CURRENT_USER', $sHKLM = 'HKEY_LOCAL_MACHINE'
            Local $sSubKey = '\Software\Microsoft\Windows\CurrentVersion\Uninstall'
            Local $aKeys[3] = [2, $sHKCU & $sSubKey, $sHKLM & $sSubKey]
        Case Else
            Return SetError(1)
    EndSwitch

    Local $array[5001][7] = [[5000, 'DisplayVersion', 'Publisher', 'UninstallString', 'InstallDate', 'MSI', 'NoRemove']]
    Local $sAppKey, $sDisplayName, $sKey, $UnInstKey, $index = 0

    For $i = 1 To $aKeys[0]
        $sKey = $aKeys[$i]
        For $j = 1 To $array[0][0]
            $sAppKey = RegEnumKey($sKey, $j)
            If @error Then ExitLoop
            $UnInstKey = $sKey & '\' & $sAppKey
            $sDisplayName = RegRead($UnInstKey, 'DisplayName')
            Select
                Case @error
                Case Not StringLen(StringStripWS($sDisplayName, 8))
                Case StringRegExp($sDisplayName, '(?i)(KB\d+)')
                Case RegRead($UnInstKey, 'SystemComponent')
                Case RegRead($UnInstKey, 'ParentKeyName')
                Case Else
                    $index += 1
                    $array[$index][0] = StringStripWS(StringReplace($sDisplayName, ' (remove only)', ''), 3)
                    $array[$index][1] = StringStripWS(RegRead($UnInstKey, 'DisplayVersion'), 3)
                    $array[$index][2] = StringStripWS(RegRead($UnInstKey, 'Publisher'), 3)
                    $array[$index][3] = StringStripWS(RegRead($UnInstKey, 'UninstallString'), 3)
                    $array[$index][4] = StringStripWS(RegRead($UnInstKey, 'InstallDate'), 3)
                    $array[$index][5] = StringStripWS(RegRead($UnInstKey, 'WindowsInstaller'), 3) = 1
                    $array[$index][6] = StringStripWS(RegRead($UnInstKey, 'NoRemove'), 3) = 1
            EndSelect
        Next
    Next

    ReDim $array[$index + 1][7]
    $array[0][0] = $index
    _ArraySort($array, 0, 1)
    Return $array
EndFunc
;


