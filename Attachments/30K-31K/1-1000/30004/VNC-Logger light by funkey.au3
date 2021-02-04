#include <WindowsConstants.au3>
#include <Constants.au3>
#Include <Array.au3>
#Include <Misc.au3>
#Include <File.au3>

Opt('TrayMenuMode', 1)
Opt('GUIEventOptions', 1)

Global $title = 'VNC-Logger', $x = 80, $y = 25, $Label, $LabelHeight = 13, $aSave
_Singleton($title)

GUICreate($title, $x, $LabelHeight, @DesktopWidth - $x, $y, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0xFFFFDD)
$Label = GUICtrlCreateLabel('', 0, 0, $x, $LabelHeight, 0x1)
GUICtrlSetTip(-1, $title & @CRLF & 'This computers are online now!')
WinMove($title, '', Default, Default, 0, 0)

If Not FileExists(@ScriptDir & '\VNC-Logs') Then DirCreate(@ScriptDir & '\VNC-Logs')

_check()
AdlibRegister('_check', 3000)
HotKeySet('^!{F10}', '_Exit')
GUISetState()

While 1
    Sleep(10000)
WEnd

Func _check()
    Local $sPC, $aPC = _GetConnectionFromPort()
    If UBound($aSave) <> UBound($aPC) Then
        $aSave = $aPC
        For $i = 0 To UBound($aPC) -1
            $sPC &= $aPC[$i] & @CRLF
            _FileWriteLog(@ScriptDir & '\VNC-Logs\VNC-Connections.log', 'Active connection to: ' & $aPC[$i])
        Next
        WinMove($title, '', Default, Default, $x, $LabelHeight*UBound($aPC), 100)
        If Not IsArray($aPC) Then  _FileWriteLog(@ScriptDir & '\VNC-Logs\VNC-Connections.log', 'No more connection active!')
        GUICtrlSetData($Label, $sPC)
    EndIf
EndFunc

Func _Exit()
    Exit
EndFunc

Func _GetConnectionFromPort($sPort = '5900')
    ; funkey 17.06.2009
    ; gibt IP oder Namen eines verbundenen PC's abhängig vom Port zurück
    ; Standard-Port ist 5900 für VNC, 3389 wäre für Remotedesktop ('mstsc.exe')
    Local $sErgebnis, $aPort
    Local $pid = Run(@ComSpec & " /c " & 'netstat -np TCP |findstr ":'&$sPort&'"', "", @SW_HIDE, $STDOUT_CHILD)
    Do
        $sErgebnis &= StdoutRead($pid)
    Until @error
    $aPort = StringSplit($sErgebnis, @CRLF, 3)
    For $i = UBound($aPort) - 1 To 0 Step -1
        If StringInStr($aPort[$i], 'HERGESTELLT') Then
            $aPort[$i] = StringRegExpReplace($aPort[$i], '(\s+)(\S+)(\s+)(\S+)(\s+)(\S+):(\S+)(\s+)(\S+)', '$6')
        Else
            _ArrayDelete($aPort, $i)
        EndIf
    Next
    If Not IsArray($aPort) Then Return SetError(1, 0, "")
    Return $aPort
EndFunc
