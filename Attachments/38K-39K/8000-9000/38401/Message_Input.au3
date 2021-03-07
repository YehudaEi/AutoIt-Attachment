#include <GUIConstants.au3>
#include <Array.au3>



$gui = GUICreate("Message", 350, 100)
$in1 = GUICtrlCreateInput("", 40, 40, 180, 20)
$widthCell = 270
	GUICtrlCreateLabel("Input", 40, 20, $widthCell) ; first cell 70 width
;$btn = GUICtrlCreateButton("OK", 100, 60, 50, 25)

GUIRegisterMsg(0x0111, "On_WM_COMMAND")
GUISetState()
Local $widthCell
Local $str
While 1
     Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
             Exit
			 Case $in1
             $str = GUICtrlRead($in1)
			 $aSplit = StringSplit($str, ",")
			 _ArrayDelete($aSplit, 0)
			 _ArrayDisplay($aSplit)


EndSwitch

WEnd




Func On_WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    $nID = BitAnd($wParam, 0x0000FFFF)

   EndFunc
