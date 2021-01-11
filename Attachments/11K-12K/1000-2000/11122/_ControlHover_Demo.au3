#include <GUIConstants.au3>
#include <_ControlHover.au3>

$mygui = GUICreate("My GUI - Button Release & colors") 
$Button_1 = GUICtrlCreateButton ("Button 1",  50, 30, 100, 20)
$Button_2 = GUICtrlCreateButton ( "Button 2",  200, 30, 100, 20)
$Label_1 = GUICtrlCreateLabel ( "Label 1",  50, 90, 70, 20)
GUICtrlSetFont( -1, 10, 600)
$Label_2 = GUICtrlCreateLabel ( "Label 2",  150, 90, 70, 20)
GUICtrlSetFont( -1, 10, 600)
$edit = GUICtrlCreateEdit("This is good for changing Pictures on Buttons", 30, 150, 300, 200)
GUISetState ()      

_ControlHover(2, "", $Button_1) ; add controls here
_ControlHover(2, "", $Button_2)
_ControlHover(2, "", $Label_1)
_ControlHover(2, "", $Label_2)

ToolTip("Example Use #1  ", 10, 10, "_ControlHover()", 1)
While 1
	$msg1 = GUIGetMsg()
	If $msg1 = $GUI_EVENT_CLOSE Then 
		MsgBox(0, 'Testing', 'Leaving Example #1  ',2) 
		ExitLoop
	EndIf
	_CheckHoverAndPressed()	
WEnd

ToolTip("Example Use #2 ", 10, 10, "_ControlHover()", 1)
GUICtrlSetData($edit, "You are not over a control")
WinSetTitle($mygui, "", "My GUI - Setting Data & Colors ") 
While 1
   $msg1 = GUIGetMsg()
   If $msg1 = $GUI_EVENT_CLOSE Then 
		MsgBox(0, 'Testing', 'Leaving Example #2  ',2) 
		ExitLoop
	EndIf
   
   $Over = _ControlHover(0, $mygui) ; or _ControlHover() - or _ControlHover(0)
	If $Over = 1 Then
		$tempID = @extended
		If $tempID = $Button_1 Then GUICtrlSetData( $edit, "You are over Button 1"& @CRLF)
		If $tempID = $Button_2 Then GUICtrlSetData( $edit, "You are over Button 2"& @CRLF)
		If $tempID = $Label_1 Then GUICtrlSetData( $edit, "You are over Label 1"& @CRLF)
		If $tempID = $Label_2 Then GUICtrlSetData( $edit, "You are over Label 2"& @CRLF)
		GUICtrlSetBkColor( $tempID, 0xF13F3F) ; color does not work on buttons - an Autoit Limit
	Else
		$tempID = @extended	
		If $tempID = $Button_1 Then GUICtrlSetData( $edit, "You are not over Button 1"& @CRLF)
		If $tempID = $Button_2 Then GUICtrlSetData( $edit, "You are not over Button 2"& @CRLF)
		If $tempID = $Label_1 Then GUICtrlSetData( $edit, "You are not over Label 1"& @CRLF)
		If $tempID = $Label_2 Then GUICtrlSetData( $edit, "You are not over Label 2"& @CRLF)
		GUICtrlSetBkColor( $tempID, $GUI_BKCOLOR_TRANSPARENT )
	EndIf
   
   
   $Click = _ControlHover(1, $mygui) ; or _ControlHover(1)
	If $Click = 1 And @extended = $Button_1 Then MsgBox(0, 'Testing', 'Button 1 was pressed', 2) 
	If $Click = 1 And @extended = $Button_2 Then MsgBox(0, 'Testing', 'Button 2 was pressed', 2) 
Wend
	
ToolTip("Example Use #3 ", 10, 10, "_ControlHover()", 1)
GUICtrlSetState( $Button_1, $GUI_DISABLE)
GUICtrlSetState( $Button_2, $GUI_DISABLE)
GUICtrlSetState( $Label_1, $GUI_DISABLE)
GUICtrlSetState( $Label_2, $GUI_DISABLE)
GUICtrlSetData($edit, "In this Click Mode, You can click the GUI itself")
WinSetTitle($mygui, "", "My GUI - Hover & Controls ")
While 1
   $msg1 = GUIGetMsg()
   If $msg1 = $GUI_EVENT_CLOSE Then 
		MsgBox(0, 'Testing', 'Now Leaving Examples.....  ',2) 
		ExitLoop
	EndIf
   
   $Over = _ControlHover(0, $mygui) ; or _ControlHover() - or _ControlHover(0)
	If $Over = 1 Then
		$tempID = @extended
		If $tempID = $Button_1 Then GUICtrlsetPos ($tempID, 45, 25, 110, 30)
		If $tempID = $Button_2 Then GUICtrlsetPos ($tempID, 195, 25, 110, 30)
		GUICtrlSetState( $tempID, $GUI_ENABLE)
	Else
		$tempID = @extended	
		If $tempID = $Button_1 Then GUICtrlsetPos ($tempID, 50, 30, 100, 20)
		If $tempID = $Button_2 Then GUICtrlsetPos ($tempID, 200, 30, 100, 20)
		GUICtrlSetState( $tempID, $GUI_DISABLE)
	EndIf
   
   
   $Click = _ControlHover(1, $mygui) ; or _ControlHover(1)
	If $Click = 1 Then MsgBox(0, 'Testing', "ControlID " & @extended &  " was pressed   ", 2) 
	
Wend
	

Func  _CheckHoverAndPressed()
	
	$CtrlId = _ControlHover(0)
	$tempID = @extended
	If $CtrlId = 1 Then
		_HoverFound($tempID)
	ElseIf $CtrlId = 0 Then
		_HoverLost($tempID)
	EndIf
	
	$CtrlId2 =  _ControlHover(1)
	$tempID2 = @extended
	If $CtrlId2 = 1 Then
		_ButtonPressed($tempID2)
	ElseIf $CtrlId2 = 0 Then
		_ButtonReleased($tempID2)
	EndIf

EndFunc   ;==>_CheckHoverAndPressed

Func _HoverFound($ControlID)
	Switch $ControlID
		Case $Button_1
			MsgBox(0, 'Testing', 'Hover over Button 1   ',2) 
		Case $Button_2
			MsgBox(0, 'Testing', 'Hover over Button 2   ',2) 
		Case $Label_1
			MsgBox(0, 'Testing', 'Hover over Label 1   ',2) 
		Case $Label_2
			MsgBox(0, 'Testing', 'Hover over Label 2   ',2) 
	EndSwitch
EndFunc

Func _HoverLost($ControlID)
	Switch $ControlID
		Case $Button_1
			MsgBox(0, 'Testing', 'Hover *lost* Button 1   ',2) 
		Case $Button_2
			MsgBox(0, 'Testing', 'Hover *lost* Button 2   ',2) 
		Case $Label_1
			MsgBox(0, 'Testing', 'Hover *lost* Label 1   ',2) 
		Case $Label_2
			MsgBox(0, 'Testing', 'Hover *lost* Label 2   ',2) 
	EndSwitch
EndFunc

Func _ButtonPressed($ControlID)
	Switch $ControlID
		Case $Button_1
			GUICtrlSetBkColor ($Label_1, 0xF13F3F)
			MsgBox(0, 'Testing', 'Pressed Button 1   ', 2) 
		Case $Button_2
			GUICtrlSetBkColor ($Label_2, 0xF13F3F)
			MsgBox(0, 'Testing', 'Pressed Button 2   ',2) 
		Case $Label_1
			MsgBox(0, 'Testing', 'Pressed Label 1   ',2) 
		Case $Label_2
			MsgBox(0, 'Testing', 'Pressed Label 2   ',2) 
	EndSwitch
EndFunc

Func _ButtonReleased($ControlID)
	Switch $ControlID
		Case $Button_1
			GUICtrlSetBkColor ($Label_1, $GUI_BKCOLOR_TRANSPARENT)
			MsgBox(0, 'Testing', 'Released Button 1   ', 2) 
		Case $Button_2
			GUICtrlSetBkColor ($Label_2, $GUI_BKCOLOR_TRANSPARENT)
			MsgBox(0, 'Testing', 'Released Button 2   ',2) 
		Case $Label_1
			MsgBox(0, 'Testing', 'Released Label 1   ',2) 
		Case $Label_2
			MsgBox(0, 'Testing', 'Released Label 2   ',2) 
	EndSwitch
EndFunc
