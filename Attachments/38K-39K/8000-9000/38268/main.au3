#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GuiToolbar.au3>
#include <GuiTab.au3>
#include <GuiRichEdit.au3>
#include <IsPressed_UDF.au3>
Global $pos = 0

Dim $menus[6], $menu_file[5], $menu_edit[7], $menu_opt[2], $menu_help[2],$toolbar[9]
$Form1 = GUICreate("Form", 900, 565)
GUISetState(@SW_SHOW)
$menus[0] = GUICtrlCreateMenu("File")
$menu_file[0] = GUICtrlCreateMenuItem("New		CTRL+N",$menus[0])
$menu_file[1] = GUICtrlCreateMenuItem("Open		CTRL+O",$menus[0])
$menu_file[2] = GUICtrlCreateMenuItem("Save		CTRL+S",$menus[0])
$menu_file[3] = GUICtrlCreateMenuItem("Save As",$menus[0])
$menu_file[4] = GUICtrlCreateMenuItem("Exit		ALT+F4",$menus[0])
$menus[1] = GUICtrlCreateMenu("Edit")
$menu_edit[0] = GUICtrlCreateMenuItem("Cut		CTRL+X",$menus[1])
$menu_edit[1] = GUICtrlCreateMenuItem("Copy		CTRL+C",$menus[1])
$menu_edit[2] = GUICtrlCreateMenuItem("Paste	CTRL+V",$menus[1])
$menu_edit[3] = GUICtrlCreateMenuItem("Delete	DEL",$menus[1])
GUICtrlCreateMenuItem("",$menus[1])
$menu_edit[4] = GUICtrlCreateMenuItem("Find		F3",$menus[1])
$menu_edit[5] = GUICtrlCreateMenuItem("Find next	F4",$menus[1])
$menu_edit[6] = GUICtrlCreateMenuItem("Replace		CTRL+R",$menus[1])
$menus[2] = GUICtrlCreateMenu("Option")
$menu_opt[0] = GUICtrlCreateMenuItem("Options	CTRL+ALT+O",$menus[2])
$menu_opt[1] = GUICtrlCreateMenuItem("Always on top",$menus[2],Default,1)
$menus[3] = GUICtrlCreateMenu("Help")
$menu_help[0] = GUICtrlCreateMenuItem("Help		F1",$menus[3])
$menu_help[1] = GUICtrlCreateMenuItem("About",$menus[3])

$toolbar[0] = _GUICtrlToolbar_Create($Form1)
$toolbar[1] = _GUICtrlToolbar_AddBitmap($toolbar[0], 1, -1, $IDB_STD_SMALL_COLOR)
$toolbar[2] = _GUICtrlToolbar_AddButton($toolbar[0], 1000, $STD_FILENEW)
$toolbar[3] = _GUICtrlToolbar_AddButton($toolbar[0], 2000, $STD_FILEOPEN)
$toolbar[4] = _GUICtrlToolbar_AddButton($toolbar[0], 3000, $STD_FILESAVE)
$toolbar[5] = _GUICtrlToolbar_AddButton($toolbar[0], 1000, 5)
	_GUICtrlToolbar_AddButtonSep($toolbar[0])
$toolbar[6] = _GUICtrlToolbar_AddButton($toolbar[0], 1000, $STD_FIND )
$toolbar[7] = _GUICtrlToolbar_Customize($toolbar[0])

$hRichEdit = _GUICtrlRichEdit_Create($Form1, "", 3,30, 894, 510, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
;~ $last = 0

While 1
	If _KeyPressCheck(1, 221, -1, 'user32.dll') Then _Reset_Colors(_GUICtrlRichEdit_GetText($hRichEdit))
	Switch GUIGetMsg()
		Case -3, $menu_file[4]
			 _GUICtrlRichEdit_Destroy($hRichEdit)
			Exit

	EndSwitch
WEnd

Func _GetNumber_of_chars($text)
	$text = StringSplit($text,"")
	Return $text[0]
EndFunc

Func _Reset_Colors($text)
	$text = StringSplit($text," ")
	Local $data = IniReadSectionNames("data.ini"), $strlen = 0, $dates, $pos1 = 0
	For $i = 1 To $text[0]
		$strlen = StringLen($text[$i])
;~ 		$text_temp = _GUICtrlRichEdit_GetTextInRange($hRichEdit,$pos1,$pos1 + $strlen)
		For $j = 1 to $data[0]
;~ 			MsgBox(0,0,$text[$i])
			If $text[$i] = $data[$j] Then
				_GUICtrlRichEdit_SetSel($hRichEdit,$pos1,$pos1 + $strlen)
				_GUICtrlRichEdit_SetCharColor($hRichEdit,IniRead("data.ini",$data[$j],"color",0x000000))
				_GUICtrlRichEdit_Deselect($hRichEdit)
			EndIf
		Next
		$pos1 += $strlen
	Next
EndFunc

; #FUNCTION# ===================================================================
; Name : 			__KeyPressCheck
; Description:      Check if specified keys are pressed
; Parameter(s):     sHexKey	- Key to check for
; Requirement(s):	None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
; Author(s):        Valuater
; Note(s):			Thanks Valuater... 8)
;===============================================================================
Func _KeyPressCheck($iStart, $iFinish, $iHexKey = -1, $vDLL = 'user32.dll')
	Local $ikey, $ia_R
	For $ikey = $iStart To $iFinish
		If $iHexKey == -1 Then $ia_R = DllCall($vDLL, 'int', 'GetAsyncKeyState', 'int', '0x' & Hex($ikey, 2))
		If $iHexKey <> -1 Then $ia_R = DllCall($vDLL, 'int', 'GetAsyncKeyState', 'int', '0x' & $iHexKey)
		If Not @error And BitAND($ia_R[0], 0x8000) = 0x8000 Then Return 1
	Next
	Return 0
EndFunc