#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $settings = @ScriptDir & "\settings2.ini"

global $S_Stock1_Max,$S_Stock1_Min,$S_Stock1_Notes,$S_Stock1_Qty
global $S_Stock2_Max,$S_Stock2_Min,$S_Stock2_Notes,$S_Stock2_Qty
global $S_Stock3_Max,$S_Stock3_Min,$S_Stock3_Notes,$S_Stock3_Qty
global $S_Stock4_Max,$S_Stock4_Min,$S_Stock4_Notes,$S_Stock4_Qty

#Region ### START Koda GUI section ### Form=
GUICreate("Form1", 551, 115, 192, 124)
$combo = GUICtrlCreateCombo("", 8, 16, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1,"Stock1|Stock2|Stock3|Stock4|")
$Qty = GUICtrlCreateInput("", 80, 16, 121, 21)
GUICtrlSetState(-1,$GUI_DISABLE)
$Min = GUICtrlCreateInput("", 208, 16, 121, 21)
GUICtrlSetState(-1,$GUI_DISABLE)
$Max = GUICtrlCreateInput("", 336, 16, 121, 21)
GUICtrlSetState(-1,$GUI_DISABLE)
$Notes = GUICtrlCreateEdit("", 80, 40, 377, 57)
GUICtrlSetState(-1,$GUI_DISABLE)
$Update = GUICtrlCreateButton("Update", 464, 16, 75, 25)
GUICtrlSetState(-1,$GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_loadsettings()

While 1
	_Active_only_if_selected()
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $combo
			If BitAND(GUICtrlGetState($Qty), $GUI_DISABLE) = $GUI_DISABLE Then
				GUICtrlSetState($Qty, $gui_enable)
			ElseIf GUICtrlRead($Qty)="" And BitAND(GUICtrlGetState($Qty), $GUI_Enable) = $gui_enable Then
				GUICtrlSetState($Qty, $GUI_DISABLE)
			EndIf
			$i=StringRight(GUICtrlRead($combo),1)
			GUICtrlSetData($Qty,Eval("s_Stock" & $i & "_Qty"))
			GUICtrlSetData($Min,eval("s_Stock" & $i & "_Min"))
			GUICtrlSetData($Max,eval("s_Stock" & $i & "_Max"))
			GUICtrlSetData($Notes,eval("s_Stock" & $i & "_Notes"))
		case $Update
			_savesettings(GUICtrlRead($combo))
			_loadsettings()
	EndSwitch
WEnd

func _Active_only_if_selected()
	;if GUICtrlRead($combo) <> "" And BitAND( GUICtrlGetState($Qty),$GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Qty,$gui_enable)
	if GUICtrlRead($Qty) <> "" And BitAND( GUICtrlGetState($Min),$GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Min,$gui_enable)
	if GUICtrlRead($Min) <> "" And BitAND( GUICtrlGetState($Max),$GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Max,$gui_enable)
	if GUICtrlRead($Max) <> "" And BitAND( GUICtrlGetState($Notes),$GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Notes,$gui_enable)
	if GUICtrlRead($Notes) <> "" And BitAND( GUICtrlGetState($Update),$GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Update,$gui_enable)

EndFunc

Func _loadsettings()
	$S_Stock1_Qty	= IniRead(@ScriptDir & "\Settings2.ini", "Stock1", "Quantity","")
	$S_Stock2_Qty	= IniRead(@ScriptDir & "\Settings2.ini", "Stock2", "Quantity","")
	$S_Stock3_Qty	= IniRead(@ScriptDir & "\Settings2.ini", "Stock3", "Quantity","")
	$S_Stock4_Qty	= IniRead(@ScriptDir & "\Settings2.ini", "Stock4", "Quantity","")
	$S_Stock1_Min	= IniRead(@ScriptDir & "\Settings2.ini", "Stock1", "Min","")
	$S_Stock2_Min	= IniRead(@ScriptDir & "\Settings2.ini", "Stock2", "Min","")
	$S_Stock3_Min	= IniRead(@ScriptDir & "\Settings2.ini", "Stock3", "Min","")
	$S_Stock4_Min	= IniRead(@ScriptDir & "\Settings2.ini", "Stock4", "Min","")
	$S_Stock1_Max	= IniRead(@ScriptDir & "\Settings2.ini", "Stock1", "Max","")
	$S_Stock2_Max	= IniRead(@ScriptDir & "\Settings2.ini", "Stock2", "Max","")
	$S_Stock3_Max	= IniRead(@ScriptDir & "\Settings2.ini", "Stock3", "Max","")
	$S_Stock4_Max	= IniRead(@ScriptDir & "\Settings2.ini", "Stock4", "Max","")
	$S_Stock1_Notes	= IniRead(@ScriptDir & "\Settings2.ini", "Stock1", "Notes","")
	$S_Stock2_Notes	= IniRead(@ScriptDir & "\Settings2.ini", "Stock2", "Notes","")
	$S_Stock3_Notes	= IniRead(@ScriptDir & "\Settings2.ini", "Stock3", "Notes","")
	$S_Stock4_Notes	= IniRead(@ScriptDir & "\Settings2.ini", "Stock4", "Notes","")


EndFunc
Func _savesettings($i)
	$i = StringTrimLeft($i,5)
	IniWrite(@ScriptDir & "\Settings2.ini", "Stock" & $i,"Quantity", GUICtrlRead($Qty))
	IniWrite(@ScriptDir & "\Settings2.ini", "Stock" & $i,"Min", GUICtrlRead($Min))
	IniWrite(@ScriptDir & "\Settings2.ini", "Stock" & $i,"Max", GUICtrlRead($Max))
	IniWrite(@ScriptDir & "\Settings2.ini", "Stock" & $i,"Notes", GUICtrlRead($Notes))
EndFunc
