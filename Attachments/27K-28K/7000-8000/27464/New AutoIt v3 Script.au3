#include <Constants.au3>
#include <SendMessage.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Icons.au3>

Global $Held1 = False
Dim $Upper[9], $Lower[9], $Dice[6]

$GUI = GUICreate("Yahtzee!", 360, 480, -1, -1, $WS_POPUP)
GUICtrlCreatePic(@ScriptDir & "\Images\Background.jpg", 0, 0, 360, 480)
GUICtrlSetState(-1, $GUI_DISABLE)

$NameLabel = GUICtrlCreateLabel("Danny", 55, 8, 150, 30, $SS_CENTER)
SetFont(-1, 20, 800, 0, "Arial", 0xEBE4E8, $GUI_BKCOLOR_TRANSPARENT)

#Region Create Scores
$Top = 46
For $x = 1 To 8
	$Upper[$x] = GUICtrlCreateLabel("0", 195, $Top, 57, 20, $SS_CENTER)
	SetFont($Upper[$x], 16, 800, 0, "Arial", 0xE8DCD2, $GUI_BKCOLOR_TRANSPARENT)
	$Top += 24
Next
For $x = 1 To 8
	$Lower[$x] = GUICtrlCreateLabel("0", 195, $Top, 57, 20, $SS_CENTER)
	SetFont($Lower[$x], 16, 800, 0, "Arial", 0xE8DCD2, $GUI_BKCOLOR_TRANSPARENT)
	$Top += 24
Next
$GrandTotal = GUICtrlCreateLabel("0", 195, $Top, 57, 20, $SS_CENTER)
SetFont(-1, 16, 800, 0, "Arial", 0xE8DCD2, $GUI_BKCOLOR_TRANSPARENT)
#EndRegion Create Scores

$Top = 7
#Region Create Dice
For $x = 1 To 5
	$Dice[$x] = GUICtrlCreatePic("", 268, $Top, 83, 83)
	_SetImage($Dice[$x], @ScriptDir & "\Images\" & $x & "a.png")
;~ 	GUICtrlSetState($Dice[$x], $GUI_DISABLE)
	$Top += 78
Next
#EndRegion Create Dice

GUICtrlCreateLabel("3", 48, 440, 34, 33, BitOR($SS_CENTER, $SS_CENTERIMAGE))
SetFont(-1, 16, 800, 0, "Arial", 0xE8DCD2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreatePic("", 268, 403, 79, 67)
_SetImage(-1, @ScriptDir & "\Images\RollButton.png")

GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Dice[1]
			If $Held1 Then
				_SetImage(GUICtrlGetHandle($Dice[1]), @ScriptDir & "\Images\1a.png")
			Else
				_SetImage(GUICtrlGetHandle($Dice[1]), @ScriptDir & "\Images\1b.png")
			EndIf
			$Held1 = Not $Held1
		Case $Dice[2]
		Case $Dice[3]
		Case $Dice[4]
		Case $Dice[5]
	EndSwitch
WEnd

Func SetFont($Handle, $Size, $Weight = 400, $Attribute = 0, $FontName = Default, $Color = 0x000000, $BackgroundColor = Default)
	GUICtrlSetFont($Handle, $Size, $Weight, $Attribute, $FontName)
	GUICtrlSetColor($Handle, $Color)
	GUICtrlSetBkColor($Handle, $BackgroundColor)
EndFunc   ;==>SetFont
