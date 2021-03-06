#include <GuiListView.au3>
Opt("TrayAutoPause", 0)
Opt('GUIOnEventMode', 1)
Opt('GUICloseOnEsc' , 1)



Global $i
Local $sSft
Global $sGui = GUICreate('Currently Installed Software', 810, 650, -1, -1)
Global $sLvw = GUICtrlCreateListView('#|Installed Software|Display Version|Publisher|Uninstall String', 5, 5, 800, 600)
_ComputerGetSoftware($sSft)



For $i = 1 To ubound($sSft) - 1
    GUICtrlCreateListViewItem($i & '|' & $sSft[$i][0] & '|' & $sSft[$i][1] & '|' & $sSft[$i][2] & '|' & $sSft[$i][3], $sLvw)
Next
GUICtrlSendMsg($sLvw, 0x101E, 1, 175)
GUICtrlSendMsg($sLvw, 0x101E, 2, 65)
GUICtrlSendMsg($sLvw, 0x101E, 3, 150)
GUICtrlSendMsg($sLvw, 0x101E, 4, 350)
Local $mMen = GUICtrlCreateContextMenu($sLvw)
Local $CopI = GUICtrlCreateMenuItem('Uninstall Current Selection', $mMen)
GUICtrlSetOnEvent($CopI, '_Uninstall')
Local $exp = GUICtrlCreateButton('  Expand  ', 720, 615)
GUICtrlSetOnEvent($exp, '_Expand')
GUISetOnEvent(-3, '_AllExit')
GUISetState(@SW_SHOW, $sGui)

While 1
    Sleep(10)
WEnd
;
Func _AllExit()
    GUIDelete($sGui)
    Exit
EndFunc
;
Func _Uninstall()
    Local $proc = StringSplit(GUICtrlRead(GUICtrlRead($sLvw)), '|', 1)
    If $proc[1] == 0 Then Return -1
    If $proc[5] Then ShellExecuteWait ($proc[5])
        exit
EndFunc
;
Func _Copy2Clip()
    Local $proc = StringSplit(GUICtrlRead(GUICtrlRead($sLvw)), '|', 1)
    If $proc[1] == 0 Then Return -1
    If $proc[5] Then ClipPut($proc[5])
EndFunc
;
; Author JSThePatriot - Modified June 20, 2010 by ripdad
Func _ComputerGetSoftware(ByRef $aSoftwareInfo)
    Local Const $UnInstKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Local $i = 1
    Dim $aSoftwareInfo[1][4]
    $input = inputbox ("Which Software" , "Which Software would you like to view?", 'ALL')
    If @Error = 1 Then Exit
    If $input = 'ALL' Then
    For $j = 1 To 500
        $AppKey = RegEnumKey($UnInstKey, $j)
        If @error <> 0 Then Exitloop
        If RegRead($UnInstKey & "\" & $AppKey, "DisplayName") = '' Then ContinueLoop
        ReDim $aSoftwareInfo[UBound($aSoftwareInfo) + 1][4]
        $aSoftwareInfo[$i][0] = StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
        $aSoftwareInfo[$i][1] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
        $aSoftwareInfo[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
        $aSoftwareInfo[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
        $i = $i + 1

    Next
    $aSoftwareInfo[0][0] = UBound($aSoftwareInfo, 1) - 1
    If $aSoftwareInfo[0][0] < 1 Then SetError(1, 1, 0)
    Return _ArraySort($aSoftwareInfo)

Else

    For $j = 1 To 500
        $AppKey = RegEnumKey($UnInstKey, $j)
        If @error <> 0 Then Exitloop
        $Reg = RegRead($UnInstKey & "\" & $AppKey, "DisplayName")
        $string = stringinstr($Reg, $input)
        If $string = 0 Then Continueloop
        ReDim $aSoftwareInfo[UBound($aSoftwareInfo) + 1][4]
        $aSoftwareInfo[$i][0] = StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
        $aSoftwareInfo[$i][1] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
        $aSoftwareInfo[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
        $aSoftwareInfo[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
        $i = $i + 1

    Next
    $aSoftwareInfo[0][0] = UBound($aSoftwareInfo, 1) - 1
    If $aSoftwareInfo[0][0] < 1 Then SetError(1, 1, 0)
    Return _ArraySort($aSoftwareInfo)

    Endif
EndFunc
;
Func _Expand()
    _GUICtrlListView_SetColumnWidth($sLvw, 1, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 2, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 3, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 4, $LVSCW_AUTOSIZE)
EndFunc
