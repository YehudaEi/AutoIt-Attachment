If not @OSVersion = "WIN_XP" Then
   MsgBox(4096, "", "StartText only works on Windows XP." & @CRLF & "Sorry for the inconvenience.")
   Exit
EndIf
#include <GUIConstants.au3>
Opt ("WinTitleMatchMode", 4)
Opt ("WinTextMatchMode", 2)
dim $off
$origsize = ControlGetPos("classname=Shell_TrayWnd", "", "Button1")
$otasksize = ControlGetPos("classname=Shell_TrayWnd", "", "ReBarWindow321")
$currenttext = ControlGetText("classname=Shell_TrayWnd", "", "Button1")
GUICreate("Set Start Text", 185, 75)
GUICtrlCreateLabel("Start text: ", 10, 10, 45, 23)
$input1 = GUICtrlCreateInput($currenttext, 57, 7, 115, 20)
GUICtrlSetLimit($input1, 10)
$setbtn = GUICtrlCreateButton("Set Text", 10, 40, 70, 25)
$unsetbtn = GUICtrlCreateButton("Unset Text", 105, 40, 70, 25)
GUISetState(@SW_SHOW)
While 1
   $msg = GUIGetMsg()
   $text = GUIRead($input1)
   $textratio = StringLen(String($text))
   $textsize = $textratio ^ 1.9
   Select
   Case $msg = $GUI_EVENT_CLOSE
      unsettext()
      ExitLoop
   Case $msg = $setbtn
      settext()
   Case $msg = $unsetbtn
      unsettext()
   EndSelect
WEnd
Func settext()
   ControlMove("classname=Shell_TrayWnd", "", "ReBarWindow321", $otasksize[0] + $textsize, $otasksize[1], $otasksize[2] - $textsize, $otasksize[3])
   ControlMove("classname=Shell_TrayWnd", "", "Button1", $origsize[0], $origsize[1], $origsize[2] + $textsize, $origsize[3])
   ControlSetText("classname=Shell_TrayWnd", "", "Button1", $text)
EndFunc
Func unsettext()
   ControlMove("classname=Shell_TrayWnd", "", "ReBarWindow321", $otasksize[0], $otasksize[1], $otasksize[2], $otasksize[3])
   ControlMove("classname=Shell_TrayWnd", "", "Button1", $origsize[0], $origsize[1], $origsize[2], $origsize[3])
   ControlSetText("classname=Shell_TrayWnd", "", "Button1", "start")
EndFunc