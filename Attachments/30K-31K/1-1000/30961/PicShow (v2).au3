#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

HotKeySet("{ESC}", "On_Exit")

$sPicPath = "c:\asd.jpg"

$sDimensions = ""
$oShellApp = ObjCreate("shell.application")
If IsObj($oShellApp) Then
    Local $oDir = $oShellApp.NameSpace("C:\")
    If IsObj($oDir) Then
    Local $oFile = $oDir.Parsename("asd.jpg")
    If IsObj($oFile) Then
    If @OSBuild > 6000 Then
    $sDimensions = $oDir.GetDetailsOf($oFile, 31)
    ElseIf @OSVersion = "WIN_XP" Then
    $sDimensions = $oDir.GetDetailsOf($oFile, 26)
    EndIf
    EndIf
    EndIf
EndIf
If $sDimensions = "" Then Exit MsgBox(0, "Error", "Object creation failed")

$aDimensions = StringRegExp($sDimensions, "(?i)[\d]*x*[\d]", 3)
If Not IsArray($aDimensions) Then Exit MsgBox(0, "Error", "Cannot get image resolution!")

$hGUI = GUICreate("Test", $aDimensions[0], $aDimensions[1], Default, Default, $WS_POPUP)
GUICtrlCreatePic($sPicPath, 0, 0, $aDimensions[0], $aDimensions[1])

Dim $Gui_Effects_in[10] = [0x00090000, 0x00040001, 0x00040002, 0x00040005, 0x00040004, 0x00040006, 0x00040008, 0x00040009, 0x0004000a, 0x00040010]
Dim $Gui_Effects_out[9] =    [0x00050001, 0x00050002, 0x00050004, 0x00050006, 0x00050005, 0x00050008, 0x00050009, 0x0005000a, 0x00050010]

$effect = Random(0, 1, 1)

If $effect = 1 Then
    WinSetTrans($hGUI, "", 0)
Else
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hGUI, "int", 500, "short", $Gui_Effects_in[Random(1, 9, 1)])
EndIf
GUISetState()

If $effect = 1 Then
    For $i = 1 To 255 Step 2
        WinSetTrans($hGUI, "", $i)
        Sleep(10)
    Next
EndIf

Sleep(3500)

On_Exit()

Func On_Exit()
    $effect = Random(0, 1, 1)
    Switch $effect
        Case 0
            For $i = 255 To 0 Step -2
                WinSetTrans($hGUI, "", $i)
                Sleep(5)
            Next
        Case 1
            $hGUI = GUICreate("Test", $aDimensions[0], $aDimensions[1], Default, Default, $WS_POPUP)
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hGUI, "int", 500, "short", $Gui_Effects_out[Random(0, 8, 1)])
            Sleep(50)
    EndSwitch
    Exit
EndFunc
