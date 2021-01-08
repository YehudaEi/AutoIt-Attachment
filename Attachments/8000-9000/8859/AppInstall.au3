#include <GuiConstants.au3>

$Title = GuiCreate("Software Libary Selection", 682, 177,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
WinSetTrans($Title, "", 220) 
GUISetBkColor(0x0080FF)  
$OfficeXP_1 = GuiCtrlCreateButton("Office XP Professional", 20, 50, 220, 50)
GUICtrlSetState(-1,$GUI_FOCUS)    
$Officelabel_2 = GuiCtrlCreateButton("ProductKey", 270, 50, 70, 50)
GUICtrlSetState(-1,$GUI_FOCUS)    
$ShowKey_3 = GuiCtrlCreateInput("", 370, 60, 290, 30)
GUICtrlSetState(-1,$GUI_FOCUS)    
$Group_4 = GuiCtrlCreateGroup("Software Application", 10, 30, 240, 90)
GUICtrlSetBkColor($Group_4,0xFFFFFF)
$Group_5 = GuiCtrlCreateGroup("GetKey", 260, 30, 90, 90)
GUICtrlSetBkColor($Group_5,0xFFFFFF)
$Group_6 = GuiCtrlCreateGroup("Product Key", 360, 30, 310, 90)
GUICtrlSetBkColor($Group_6,0xFFFFFF)
$OfficeKey = '11111111111'
GUICtrlSetFont($ShowKey_3,20,700,0,"Courier New")
$Office_Setup = ("E:\done.exe")

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $OfficeXP_1
	  Run($Office_Setup)
	Case $msg = $Officelabel_2
      GuiCtrlSetData($ShowKey_3, $OfficeKey)
	EndSelect
WEnd
Exit









