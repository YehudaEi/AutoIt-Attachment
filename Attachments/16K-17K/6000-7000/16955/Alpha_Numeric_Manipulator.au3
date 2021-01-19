#NoTrayIcon
#include <GUIConstants.au3>
#Include <String.au3>

$AForm1 = GUICreate("gseller's Alpha/Numeric Manipulator", 375, 175, 193, 125)
$Input1=GUICtrlCreateEdit("",10,7,357,105,BitOR($ES_MULTILINE,$ES_AUTOVSCROLL,$WS_VSCROLL))
$Crunch = GUICtrlCreateButton("#Crunch", 7, 115, 49, 25)
$Reset = GUICtrlCreateButton("Reset", 56, 115, 49, 25)
$Upper = GUICtrlCreateButton("Upper Case", 105, 115, 65, 25)
$Lower = GUICtrlCreateButton("Lower Case", 170, 115, 65, 25)
$Proper = GUICtrlCreateButton("Proper Case", 235, 115, 65, 25)
$Reverse = GUICtrlCreateButton("Reverse", 300, 115, 65, 25)
$Binary = GUICtrlCreateButton("Binary", 7, 140, 49, 25)

GUISetState(@SW_SHOW)

While 1
 $nMsg = GUIGetMsg()
 Switch $nMsg
  Case $GUI_EVENT_CLOSE
   Exit
  Case $Crunch
   SetCase("Crunch") 
  Case $Reset 
   SetCase("Reset")
  Case $Upper 
   SetCase("Upper")
  Case $Lower 
   SetCase("Lower")  
  Case $Proper 
   SetCase("Proper")  
  Case $Reverse 
   SetCase("Reverse")  
  Case $Binary 
   SetCase("Binary")   
 EndSwitch
WEnd

Func SetCase($sCaseType)
Local $r = GUICtrlRead($Input1)
Switch $sCaseType
  Case "Upper"
   GUICtrlSetData($Input1, StringUpper($r))
  Case "Lower"
   GUICtrlSetData($Input1, StringLower($r))
  Case "Crunch"
   GUICtrlSetData($Input1, StringRegExpReplace(($r), "[^0-9]", "")) 
  Case "Reset"
   GUICtrlSetData($Input1, StringRegExpReplace(($r), "[^ ]", "")) 
  Case "Proper"
   GUICtrlSetData($Input1, _StringProper($r))   
  Case "Reverse"
   GUICtrlSetData($Input1, _StringReverse($r))    
  Case "Binary"
   GUICtrlSetData($Input1, StringToBinary($r))   
EndSwitch
EndFunc