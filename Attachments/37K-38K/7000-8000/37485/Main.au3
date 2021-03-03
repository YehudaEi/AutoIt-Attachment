#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "GUI.au3"

Global $file = "January.ini"
Global $path = @ScriptDir&"\ini\"& $file

Func R_Label_day()
   For $a = $label_day1 To $label_day42 Step 1
	  for $b = 1 to 42 step 1
	  Next
   GUICtrlSetData ($a, IniRead ($path, "label_day", "day" & $b, "Error"))
   Next
EndFunc

func W_input()
   For $a = 1 To 42 Step 1
   IniWrite ($path, "input_day", "input" & $a, GUICtrlRead ($Input & $a))
   Next
EndFunc


While 1
   
	$nMsg = GUIGetMsg()
	Switch $nMsg
	  Case $GUI_EVENT_CLOSE
	  exit
	  case $Button_open
	  R_Label_day()
	  case $Button_save
	  W_input()
	EndSwitch
WEnd