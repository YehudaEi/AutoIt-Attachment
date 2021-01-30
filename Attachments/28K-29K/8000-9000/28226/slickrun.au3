#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
;Dim $sString = "Hello|world|AutoIt|rules|and|more|some|data"
Global $dll = DllOpen("user32.dll")

$hGUI = GUICreate("AutoComplete Combo Demo", 300, 200)
$filelist=IniReadSection("files.ini","files")
Global $sString=""
For $i = 1 To $filelist[0][0]
       $sString= $sString&"|"&$filelist[$i][0]
Next
$hCombo = GUICtrlCreateCombo("", 70, 75, 170, 20)
GUICtrlSetData(-1, $sString, "")

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

GUISetState()

Do
	If _IsPressed("0D", $dll) Then
		$var = IniRead("files.ini","files", guictrlread($hCombo), "-1")
		ShellExecute($var)
	EndIf
Until GUIGetMsg() = $GUI_EVENT_CLOSE

Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    Local $iIDFrom = BitAND($wParam, 0x0000FFFF)
    Local $iCode = BitShift($wParam, 16)

    Switch $iIDFrom
        Case $hCombo
            Switch $iCode
                Case $CBN_EDITCHANGE
                    _GUICtrlComboBox_AutoComplete($hCombo)
            EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc  ;==>WM_COMMAND
