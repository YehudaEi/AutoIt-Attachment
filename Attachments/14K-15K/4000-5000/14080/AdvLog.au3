#cs
To set up your Advanced Logger X Replace TABS 1,2, and 3 with your log names in place of Date, Programming, and PyroTEchnics.
Then replace variables with your ariables in place of prog, pyro, and date. Then replace the location of your log files accordingly.
Finally replace the second TAB variables.
#ce


#include <GUIConstants.au3>
#include <Date.au3>

GUICreate("LOG GENERATOR X", 315, 251, 193, 115)
GUICtrlCreateTab(0, 0, 313, 249)
$TabSheet1 = GUICtrlCreateTabItem("Programming");TAB1
;TAB 1 variable below
$prog = GUICtrlCreateEdit("", 36, 40, 233, 161)
$Button1 = GUICtrlCreateButton("Generate", 104, 208, 89, 17, 0)
$TabSheet2 = GUICtrlCreateTabItem("PyroTechnics");TAB2
;TAB 2 variable below
$pyro = GUICtrlCreateEdit("", 36, 40, 233, 161)
$Button2 = GUICtrlCreateButton("Generate", 104, 208, 89, 17, 0)
$TabSheet3 = GUICtrlCreateTabItem("Date");TAB3
;TAB3 variable below
$date = GUICtrlCreateEdit("", 36, 40, 233, 161)
$Button4 = GUICtrlCreateButton("Generate", 104, 208, 89, 17, 0)
GUICtrlSetState(-1,$GUI_SHOW)
GUICtrlCreateTabItem("")
GUISetState()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		
		Case $Button1;TAB1 is here
			FileWrite( "C:\logs\programs.log", _DateTimeFormat(_NowCalc(), 1))
			FileWrite( "C:\logs\programs.log", GUICtrlRead($prog))
			;Tab 1 File above					;TAB1 variable above
		Case $Button2;TAB2 is here
			FileWrite( "C:\logs\pyro.log", _DateTimeFormat(_NowCalc(), 1))
			FileWrite( "C:\logs\pyro.log", GUICtrlRead($pyro))
			;TAB 2 File above					;TAB2 variable above
		Case $Button4 ;TAB3 is here
			FileWrite( "C:\logs\date.log", _DateTimeFormat(_NowCalc(), 1))
			FileWrite( "C:\logs\date.log", GUICtrlRead($date))
			;TAB 3 file above					;TAB3 variable above
	EndSwitch
WEnd
