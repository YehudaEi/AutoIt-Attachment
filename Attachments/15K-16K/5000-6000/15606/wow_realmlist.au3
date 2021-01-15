#include <GUIConstants.au3>
#include <ComboConstants.au3>
GUICreate("Realmlist", 400,400,100,100)
$open=FileOpen ( "C:\Program Files\World of Warcraft\realmlist.wtf", 0 )
$realm = FileReadLine($open,1)
$mylist=GUICtrlCreateList ("", 75,200,250,97)
GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling
GUICtrlSetData(-1,$realm)
GUICtrlCreateLabel("current realms",85,180)
$realms=GUICtrlCreateCombo ("", 10,10,250) ; create first item
$button1 = GuiCtrlCreateButton("Set Realm", 30, 90, 130, 20)
$var = IniReadSection("realm.ini", "realms")
If @error Then 
    MsgBox(4096, "", "Error occurred, probably no INI file.")
Else
Select 
Case $var[0][0]=1
GUICtrlSetData($realms,$var[1][1])
Case $var[0][0]=2 
GUICtrlSetData($realms,$var[1][1])
GUICtrlSetData($realms,$var[2][1])
Case $var[0][0]=3 
GUICtrlSetData($realms,$var[1][1])
GUICtrlSetData($realms,$var[2][1])
GUICtrlSetData($realms,$var[3][1])
Case $var[0][0]=4 
GUICtrlSetData($realms,$var[1][1])
GUICtrlSetData($realms,$var[2][1])
GUICtrlSetData($realms,$var[3][1])
GUICtrlSetData($realms,$var[4][1])
Case $var[0][0]=5 
GUICtrlSetData($realms,$var[1][1])
GUICtrlSetData($realms,$var[2][1])
GUICtrlSetData($realms,$var[3][1])
GUICtrlSetData($realms,$var[4][1])
GUICtrlSetData($realms,$var[5][1])
Case $var[0][0]>5 
    MsgBox(4096, "", "teveel realms")
EndSelect
EndIf


GUISetState ()
$msg = 0
While $msg <> $GUI_EVENT_CLOSE
$msg = GUIGetMsg()
Select
Case $msg = $button1
$selected=GUICtrlRead($realms)
$file=FileOpen ( "C:\Program Files\World of Warcraft\realmlist.wtf", 2 )
FileWrite($file, $selected)
GUICtrlSetData($mylist,"")
GUICtrlSetData($mylist,$selected)	
EndSelect
WEnd
FileClose($open)


