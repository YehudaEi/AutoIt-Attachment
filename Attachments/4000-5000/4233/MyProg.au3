; please place the location of the ini file here
#include "GUIConstants.au3"
#Include <GuiCombo.au3>

Dim $Location = "my.ini"
Dim $Sec_data

If Not FileExists($Location) Then
	MsgBox(0,"Sorry"," the ini file was not found ")
	Exit
EndIf


$PT_win = GuiCreate(" My Ladder, by QTasc", 240,120)
$button_1 = GUICtrlCreateButton("A&ccept", 20, 80, 60, 23)
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$button_2 = GUICtrlCreateButton("C&ancel", 160, 80, 60, 23)

;Create 1 combo box, give focus and populate with contents
$combo_1 = GUICtrlCreateCombo( "", 53, 43, 123, 20)
GUICtrlSetState(-1,$GUI_FOCUS) 
GUICtrlSetData(-1,$Sec_data)
;GUICtrlSetFont( -1, 9, 550)

$label_1 = GUICtrlCreateLabel( "Please Choose a File", 20, 15, 250, 20)
GUICtrlSetFont( -1, 10, 600)
GuiSetState (@SW_SHOW)

Call("Read_Sections")

While 1 
	$LSmsg = GuiGetMsg()
Select
	case $LSmsg = $button_2 Or $LSmsg = $GUI_EVENT_CLOSE
		Exit

	case $LSmsg = $button_1
		$LSID = GuictrlRead($combo_1)
		If $LSID = "" Then MsgBox(64, "Error", "No File Chosen")
		If $LSID > "" Then Call("Read_ini")
		
EndSelect
WEnd

;---------------------- functions ---------------------------

Func Read_Sections()
	;Local $t = 1
	$Sections = IniReadSectionNames($Location)
	For $t = 1 to $Sections[0]
		If @error then ExitLoop
		_GUICtrlComboAddString($combo_1,$Sections[$t])
		$Sec_data = $Sec_data & $Sections[$t] & "|"
	Next
EndFunc

Func Read_ini()
	$var = IniReadSection($Location, $LSID)
	If @error Then 
		MsgBox(4096, "", "Error occured, probably no INI file.")
	Else
		For $i = 1 To $var[0][0]
			MsgBox(4096, "", $var[$i][0] & @CRLF & $var[$i][1])
		Next
	EndIf
EndFunc 

