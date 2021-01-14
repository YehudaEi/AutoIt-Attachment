#include <GUIConstants.au3>
#include <GuiCombo.au3>

Opt ("GUIOnEventMode", 1)
Opt ("RunErrorsFatal", 0)

If @OSTYPE <> "WIN32_NT" Then
    MsgBox(0, "Invalid Operating System", "This program requires WIndows 2000 or later to run.")
    Exit
EndIf

Dim $ipArray[20]
Dim $nicArray[20]
For $ia = 0 to 19 Step 1
    $ipArray[$ia] = ""
    $nicArray[$ia] = ""
Next
;================================================= Nic Gui =================================================
;shows only active network cards with valid ip address (0.0.0.0 and apipa will not be shown)

$Form1 = GUICreate("Active Network Cards", 276, 79, -1, -1, -1, $WS_EX_TOOLWINDOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "_NicClose", $Form1)
GUICtrlCreateLabel("Select IP Address", 58, 8, 157, 17, $SS_CENTER)
$Combo1 = GUICtrlCreateCombo("", 8, 24, 261, 21)
$Button1 = GUICtrlCreateButton("&OK", 123, 56, 30, 20, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent($Button1, "_NicOK")
;===========================================================================================================
Func _NicOK()
    GUISwitch($Form1)
    $selNic = StringSplit(GUICtrlRead($Combo1), "[")
    $selIp = StringStripWS($selNic[1], 8)
    GUISetState(@SW_HIDE)
    MsgBox(0, "", $selIp) ; ==> Return $selIp - This may return IP Address
EndFunc

Func _NicClose()
    GUISwitch($Form1)
    $selNic = StringSplit(GUICtrlRead($Combo1), "[")
    $selIp = StringStripWS($selNic[1], 8)
    If $selIp <> '' Then
        GUISetState(@SW_HIDE)
        MsgBox(0, "", $selIp) ; ==> Return $selIp - This may return IP Address
    Else 
        MsgBox(16, "Warning", "Please select IP Address")
    EndIf
EndFunc

;possible start function
RunWait(@ComSpec & " /c " & 'ipconfig >> ' & @TempDir & '\ip.txt', "", @SW_HIDE)
$ipconffile = FileRead(@TempDir & "\ip.txt", FileGetSize(@TempDir & "\ip.txt"))
GUICtrlSetData($Combo1, "")
If $ipconffile = -1 Then
    ;Error!
  Else 
    For $i = 0 to 19 Step 1
        $find = StringInStr( $ipconffile, "IP Address", 1, $i) ; for localized versions you need to change the text between ""
        $nicname = StringInStr( $ipconffile, "Ethernet adapter", 1, $i); for localized versions you need to change the text between ""
        If $find <> 0 And $nicname <> 0 Then 
            $ipAddr = StringLeft(StringTrimLeft($ipconffile, $find+35), 15); for localized versions you need to change the value to add to $find
            $nname = StringSplit(StringTrimRight(StringTrimLeft($ipconffile, $nicname+16), 1), ":")); for localized versions you need to change the value to add to $nicname
            $nicArray[$i] = $nname[1]
            $ipArray[$i] = StringStripWS($ipAddr, 8)
            If StringLeft($ipArray[$i], 1) = "0" Or StringLeft($ipArray[$i], 3) = "169" Then
            Else                
                GUICtrlSetData($Combo1, $ipArray[$i] & " [" & $nicArray[$i] & "]"& "|")
            EndIf
        EndIf
    Next
    FileDelete(@TempDir & "\ip.txt")
EndIf
; end function


GUISwitch($Form1)
GUISetState(@SW_SHOW)

While 1
    $msg = GUIGetMsg(0)
WEnd
	