
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

HotKeySet( "{ESC}", "end" )

Func end()
    Exit 0
EndFunc

Global $Button1,$Combo1,$Combo2,$Combo3,$Combo4
first()

func first()
GUICreate("Form1", 485, 285, 282, 117)
 $Combo1 = GUICtrlCreateCombo("min", 24, 32, 145, 25)
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59")
 $Combo2 = GUICtrlCreateCombo("hour", 24, 88, 145, 25)
GUICtrlSetData(-1, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24")
 $Combo3 = GUICtrlCreateCombo("min", 304, 32, 145, 25)
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59")
$Combo4 = GUICtrlCreateCombo("hour", 304, 88, 145, 25)
GUICtrlSetData(-1, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24")
$Button1 = GUICtrlCreateButton("1", 200, 144, 75, 25, $WS_GROUP)
GUISetState(@SW_SHOW)

EndFunc


While 1

Sleep(20)

    $GuiMsg = GuiGetMsg()
    Select
    Case $GuiMsg = $Gui_Event_Close
        Exit
	Case $GuiMsg = $Combo1
	 	IniWrite("C:\basz.ini", "section", "1",GUICtrlRead($Combo1) )
	Case $GuiMsg = $Combo2
		IniWrite("C:\basz.ini", "section", "2",GUICtrlRead($Combo2) )
	Case $GuiMsg = $Combo3
		IniWrite("C:\basz.ini", "section", "3",GUICtrlRead($Combo3) )
    Case $GuiMsg = $Combo4
		IniWrite("C:\basz.ini", "section", "4",GUICtrlRead($Combo4) )
             Sleep(50)
	Case $GuiMsg = $Button1
		         FUNU()
				 Sleep(20)
                 des()

		EndSelect

WEnd


Func clos()
   $list = ProcessList("uTorrent.exe")
   ProcessClose($list[1][1])
   Sleep(10)
EndFunc


Func FUNU()
While 1


$min = IniRead("C:\basz.ini", "section", "1","")
$hour = IniRead("C:\basz.ini", "section", "2","")
Sleep(50)
  if  @MIN = $min And @HOUR = $hour  Then
  Run (@ProgramFilesDir&"\uTorrent\uTorrent.exe")


	 Return
  EndIf
WEnd
EndFunc


func des()
While 2
$mins =  IniRead("C:\basz.ini", "section", "3","")
$hours = IniRead("C:\basz.ini", "section", "4","")
Sleep(50)
    if @MIN = $mins And @HOUR = $hours  Then
	clos()
Return
	EndIf
WEnd
EndFunc
