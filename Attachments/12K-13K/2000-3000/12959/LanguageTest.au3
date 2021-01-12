#include <GUIConstants.au3>

Local $Lang = IniReadSectionNames(@ScriptDir & '\Language.ini')
Global $String[18]
Global $ControlID[16]

$String[0] = UBound($String) - 1
$ControlID[0] = UBound($ControlID) - 1

LanguagePacks('English')

$ControlID[1] = GUICreate($String[1],300,200)

Global $defaultstatus = $String[2]
Global $status

$ControlID[3] = GUICtrlCreateMenu ($String[3])
$ControlID[4] = GUICtrlCreateMenuitem ($String[4],$ControlID[3])
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$ControlID[5] = GUICtrlCreateMenu ($String[5])
$ControlID[6] = GUICtrlCreateMenuitem ($String[6],$ControlID[3])
GUICtrlSetState(-1,$GUI_DISABLE)
$ControlID[7] = GUICtrlCreateMenuitem ($String[7],$ControlID[5])
$ControlID[8] = GUICtrlCreateMenuitem ($String[8],$ControlID[3])
$ControlID[9] = GUICtrlCreateMenu ($String[9],$ControlID[3],1)

$separator1 = GUICtrlCreateMenuitem ("",$ControlID[3],2)	; create a separator line

$ControlID[10] = GUICtrlCreateMenu($String[10],-1,1)	; is created before "?" menu
$ControlID[11] = GUICtrlCreateMenuitem ($String[11],$ControlID[10])
GUICtrlSetState(-1,$GUI_CHECKED)
$ControlID[12] = GUICtrlCreateLabel($String[12], 8, 25, 493, 33)
$ControlID[13] = GUICtrlCreateLabel($String[13], 60, 60, 141, 17, $SS_CENTER)
$Combo1 = GUICtrlCreateCombo("", 60, 76, 145, 25)
$ControlID[14] = GUICtrlCreateButton ($String[14],50,130,70,20)
GUICtrlSetState(-1,$GUI_FOCUS)
$ControlID[15] = GUICtrlCreateButton ($String[15],180,130,70,20)

$ControlID[2] = GUICtrlCreateLabel ($defaultstatus,0,165,300,16,BitOr($SS_SIMPLE,$SS_SUNKEN))

For $x = 1 To $Lang[0]
	GUICtrlSetData($Combo1, $Lang[$x])
Next

GUISetState ()
While 1
	$msg = GUIGetMsg()
	
	If $msg = $ControlID[5] Then
		$file = FileOpenDialog($String[16],@TempDir,"All (*.*)")
		If @error <> 1 Then GUICtrlCreateMenuitem ($file,$ControlID[9])
	EndIf 
	If $msg = $ControlID[9] Then
		If BitAnd(GUICtrlRead($ControlID[9]),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($ControlID[9],$GUI_UNCHECKED)
			GUICtrlSetState($ControlID[2],$GUI_HIDE)
		Else
			GUICtrlSetState($ControlID[9],$GUI_CHECKED)
			GUICtrlSetState($ControlID[2],$GUI_SHOW)
		EndIf
	EndIf
	
	If $msg = $Combo1 Then LanguagePacks(GUICtrlRead($Combo1))
		
	If $msg = $GUI_EVENT_CLOSE Or $msg = $ControlID[15] Or $msg = $ControlID[8] Then ExitLoop
	If $msg = $ControlID[7] Then Msgbox(0,"Info",$String[17])
WEnd
GUIDelete()

Exit

Func LanguagePacks($sLang)
	$sLangList = IniReadSection(@ScriptDir & '\Language.ini', $sLang)
	For $x = 1 To $sLangList[0][0]
		$String[$x] = $sLangList[$x][1]
	Next
	For $x = 1 To $ControlID[0]
		GUICtrlSetData($ControlID[$x], $String[$x])
	Next
EndFunc