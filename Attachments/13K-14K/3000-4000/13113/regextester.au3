#include <GUIConstants.au3>
#Include <GuiList.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=regextester.kxf
$Form1 = GUICreate("RegEx tester 20072501 by lokster", 682, 394, 297, 226)
$Group1 = GUICtrlCreateGroup("Parameters", 0, 0, 473, 225)
$Label1 = GUICtrlCreateLabel("Source:", 8, 16, 41, 17)
$Edit1 = GUICtrlCreateEdit("", 64, 16, 401, 89)
$Edit2 = GUICtrlCreateEdit("", 64, 104, 401, 89)
GUICtrlSetData(-1, "")
$Label2 = GUICtrlCreateLabel("Replace:", 8, 104, 47, 17)
$Label3 = GUICtrlCreateLabel("Pattern:", 8, 203, 41, 17)
$Input1 = GUICtrlCreateInput("", 64, 200, 401, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Output:", 0, 232, 473, 161)
$Edit3 = GUICtrlCreateEdit("", 8, 248, 457, 137)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Matches", 480, 0, 201, 393)
$List1 = GUICtrlCreateList("", 488, 16, 185, 370)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global Const $WM_COMMAND = 0x0111
Global Const $EN_CHANGE = 0x300
Global Const $CBN_EDITCHANGE = 5

GUISetOnEvent($GUI_EVENT_CLOSE, "Bye")
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

    Switch $nID
        Case $Input1,$Edit1,$Edit2
            Switch $nNotifyCode
			Case $EN_CHANGE
					ACombo1Change()
				EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND

Func Bye()
	Exit
EndFunc
	
Func ACombo1Change()
	$subject = GUICtrlRead($Edit1)
	$replace = GUICtrlRead($Edit2)
	$pattern = GUICtrlRead($Input1)
	
	$matches = StringRegExp($subject,$pattern,3)
	GUICtrlSetData($Edit3,StringRegExpReplace($subject,$pattern,$replace))

	GUICtrlSetData($List1,"")
    for $i = 0 to UBound($matches) - 1
		_GUICtrlListAddItem($List1,$matches[$i])
    Next	
	
EndFunc

While 1
	Sleep(100)
WEnd

