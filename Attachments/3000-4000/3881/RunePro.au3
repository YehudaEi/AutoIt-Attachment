;Title: RunePro
;Author: SupraNatural

;Include
#include <GuiConstants.au3>
#include <Rune Definitions.au3>
;Create Window
GuiCreate("RunePro", 755, 250)
GuiSetState()

;Credit
MsgBox(0,"Credit", "All Runeword pictures/text come from                                                       ")
MsgBox(0,"Notes", "BEFORE USING ANY RUNEWORDS READ THE NOTES.TXT FILE. PLEASE!")

;Create InputBox
$InputRuneWord = GUICtrlCreateInput ( "Enter runeword name/abbreviation.", 1,  179, 300, 20)
$btn = GUICtrlCreateButton ("OK", 330,  179, 60, 20)

;Gui Loop
Do
	$RuneWord = GUICtrlRead($InputRuneWord)
    $msg = GUIGetMsg()
	
If $msg = $btn Then
		
	If $RuneWord = $RuneWords[1][0] Then
		GuiCtrlCreatePic(@ScriptDir & "\" & "Pics" & "\" & $RuneWord,0,0, 754,168)
	ElseIf $RuneWord = $RuneWords[1][1] Then
		GuiCtrlCreatePic($RuneWord,0,0, 754,168)
	EndIf
	
EndIf

Until $msg = $GUI_EVENT_CLOSE