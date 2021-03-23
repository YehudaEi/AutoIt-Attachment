#include <APIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <file.au3>
#include <StaticConstants.au3>
#include <GUIListViewEx.au3>

global $a = 1, $b = 1, $i = 1


HotKeySet("{ESC}", "Terminate")

Func Terminate()
ProcessClose ( "autoit3.exe" )
    Exit 0
EndFunc   ;==>Terminate


#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 827, 585, -1, -1)
$sourcebox = _GUICtrlListView_Create($Form1, "User name", 8, 32, 321, 545, BitOR($LVS_DEFAULT, $WS_BORDER, $LVS_EDITLABELS))
_GUICtrlListView_SetColumnWidth($sourcebox, 0, 200)
$importlistdata = _GUIListViewEx_Init($sourcebox, "", 0, 0x00FF00)
;GUICtrlSetLimit(-1, 9900000)
$sucbo = GUICtrlCreateEdit("", 560, 272, 249, 201)
$failbox = GUICtrlCreateEdit("", 560, 32, 249, 201)
;$Combo1 = GUICtrlCreateCombo("Combo1", 352, 80, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;$L_option1 = GUICtrlCreateLabel("Option 1", 352, 56, 44, 17)
;$Combo2 = GUICtrlCreateCombo("Combo1", 352, 136, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;$L_option2 = GUICtrlCreateLabel("Option 1", 352, 112, 44, 17)
;$Combo3 = GUICtrlCreateCombo("Combo1", 352, 192, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;$L_option3 = GUICtrlCreateLabel("Option 1", 352, 168, 44, 17)
;$Combo4 = GUICtrlCreateCombo("Combo1", 352, 248, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;$L_option4 = GUICtrlCreateLabel("Option 1", 352, 224, 44, 17)
$oldhome = GUICtrlCreateInput("", 352, 312, 121, 21)
$L_option5 = GUICtrlCreateLabel("Old Home", 352, 288, 100, 17)
$newhome = GUICtrlCreateInput("Input1", 352, 368, 121, 21)
$L_option7 = GUICtrlCreateLabel("New Home", 352, 344, 100, 17)
$B_Verify = GUICtrlCreateButton("Verify", 640, 520, 75, 57)
$B_start = GUICtrlCreateButton("S T A R T", 728, 520, 75, 57)
$Label_lable = GUICtrlCreateLabel("Paste list here", 8, 8, 70, 17)
$Label_Success = GUICtrlCreateLabel("Success", 560, 248, 45, 17)
$Label_Failed = GUICtrlCreateLabel("Failed", 560, 8, 32, 17)
$Group1 = GUICtrlCreateGroup("Options", 344, 32, 185, 377)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Status", 344, 424, 185, 145)
$stat1 = GUICtrlCreateLabel("READY", 352, 440, 166, 56, $SS_CENTER)
GUICtrlSetFont(-1, 32, 400, 0, "Arial Narrow")
$stat2 = GUICtrlCreateLabel($a & "/" & $b, 352, 504, 166, 56, $SS_CENTER)
GUICtrlSetFont(-1, 32, 400, 0, "Arial Narrow")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$import = GUICtrlCreateButton("import", 552, 520, 75, 57)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
global $MuhVal
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $import
			import()

	EndSwitch
WEnd


Func import()
local $zInput
	Local $var = FileOpenDialog("Select only one file.", @ScriptDir & "\", "Files (*.txt)", 1)
	If @error Then
		Return
	Else
		_FileReadToArray($var, $zInput)
		For $i = 1 To UBound($zInput) - 1
			_GUIListViewEx_Insert($zInput[$i])
			GUICtrlSetData($stat2, 1 & "/" & $i)
		Next
	EndIf
EndFunc   ;==>import


