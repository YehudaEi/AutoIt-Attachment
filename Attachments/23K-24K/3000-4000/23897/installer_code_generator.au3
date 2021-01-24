#include <GUIConstants.au3>

GUICreate("Install Code Generator", 320,120, @DesktopWidth/2-160, @DesktopHeight/2-45, -1, 0x00000018); WS_EX_ACCEPTFILES

$num1 = GUICtrlCreateInput ( "", 50, 35, 40, 20)
GUICtrlSetState ($num1, $GUI_FOCUS )
$num2 = GUICtrlCreateInput ("", 100,  35, 40, 20)
$num3 = GUICtrlCreateInput ("", 150,  35, 40, 20)
$num4 = GUICtrlCreateInput ("", 200,  35, 40, 20)
$num5 = GUICtrlCreateInput ("", 250,  35, 40, 20)

GUICtrlCreateLabel("Total is:",135, 70, 80, 20)
$output0 = GUICtrlCreateLabel("",180, 70, 130, 20, 0x1000)

GUICtrlCreateLabel("Code is:",135, 90, 80, 20)
$output = GUICtrlCreateLabel("",180, 90, 130, 20, 0x1000)
GUICtrlSetFont($output, 12, 800, "", "")
$btn = GUICtrlCreateButton ("Ok", 40,  75, 60, 20)
$btn1 =GUICtrlCreateButton ("Clear", 40,  95, 60, 20)


GUISetState () 

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
       $msg = GUIGetMsg()
       Select
           Case $msg = $btn
                
       $total = GUICtrlSetData($output0, GUICtrlRead($num1) + GUICtrlRead($num2) + GUICtrlRead($num3) + GUICtrlRead($num4) + GUICtrlRead($num5))
                GUICtrlSetData($output, GUICtrlRead($output0) / 1024)
			Case $msg = $btn1
				GUICtrlSetData($num1,"")
				GUICtrlSetData($num2,"")
				GUICtrlSetData($num3,"")
				GUICtrlSetData($num4,"")
				GUICtrlSetData($num5,"")
				GUICtrlSetData($output,"")
				GUICtrlSetData($output0, GUICtrlRead($num1)	+ GUICtrlRead($num2) + GUICtrlRead($num3) + GUICtrlRead($num4) + GUICtrlRead($num5))
				GUICtrlSetState ($num1, $GUI_FOCUS )
              ; exitloop
       EndSelect
Wend

