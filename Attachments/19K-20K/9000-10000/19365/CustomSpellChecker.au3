#include <Word.au3>
#include <GuiEdit.au3>
#include <GuiListBox.au3>
#include <GuiComboBox.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

_WordErrorHandlerRegister()

Global $oWordApp = _WordCreate("", 0, 0, 0)
Global $oDoc = $oWordApp.ActiveDocument
Global $oRange = $oDoc.Range
Global $oSpellCollection, $oAlternateWords
Global $aLangs = IniReadSection(@ScriptDir & "\LangID.ini", "WdLanguageID")
If @error Then
	Global $aLangs[2][2] = [[1, ""],["English", 1033]]
EndIf

$GUI = GUICreate("Custom Spell Checker", 420, 400)
GUISetBkColor(0x004080, $GUI)
$Edit = GUICtrlCreateEdit("Thsi is some mispelled tetx for testign purposis.", 10, 10, 400, 240, _
		BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $ES_NOHIDESEL, $ES_WANTRETURN))
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label1 = GUICtrlCreateLabel("Spelling Mistakes", 10, 260, 150, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 700)
GUICtrlSetColor(-1, 0xFF0000)
$Label2 = GUICtrlCreateLabel("Spelling Suggestions", 170, 260, 150, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 700)
GUICtrlSetColor(-1, 0x00FF000)
$ListBox1 = GUICtrlCreateList("", 10, 280, 150, 120, $LBS_NOTIFY + $WS_VSCROLL)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$ListBox2 = GUICtrlCreateList("", 170, 280, 150, 120, $LBS_NOTIFY + $WS_VSCROLL)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Button1 = GUICtrlCreateButton("Spell Check", 330, 280, 80, 20)
$Button2 = GUICtrlCreateButton("Replace Word", 330, 310, 80, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button3 = GUICtrlCreateButton("Close", 330, 340, 80, 20)
$Combo = GUICtrlCreateCombo("", 330, 370, 80, 20)
For $i = 1 To $aLangs[0][0]
	_GUICtrlComboBox_AddString($Combo, $aLangs[$i][0])
Next
GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE, $Button3
			_Exit()
		Case $Button1
			_SpellCheck()
		Case $Button2
			_ReplaceWord()
		Case $ListBox1
			_SpellingSuggestions()
			_HighlightWord()
		Case $ListBox2
			GUICtrlSetState($Button2, $GUI_ENABLE)
		Case $Combo
			_SetLanguage()
			_SpellCheck()
	EndSwitch
	Sleep(10)
WEnd

Func _SpellCheck()
	Local $sText, $sWord
	;
	_GUICtrlListBox_ResetContent($ListBox1)
	_GUICtrlListBox_ResetContent($ListBox2)
	GUICtrlSetState($Button2, $GUI_DISABLE)

	$sText = GUICtrlRead($Edit)
	$oRange = $oWordApp.ActiveDocument.Range
	$oRange.Delete
	$oRange.InsertAfter($sText)
	_SetLanguage()

	$oSpellCollection = $oRange.SpellingErrors
	If $oSpellCollection.Count > 0 Then
		For $i = 1 To $oSpellCollection.Count
			$sWord = $oSpellCollection.Item($i).Text
			_GUICtrlListBox_AddString($ListBox1, $sWord)
		Next
	Else
		_GUICtrlListBox_AddString($ListBox1, "No spelling errors found.")
	EndIf
	GUICtrlSetData($Edit, $oRange.Text)
EndFunc   ;==>_SpellCheck

Func _SpellingSuggestions()
	Local $iWord, $sWord
	;
	_GUICtrlListBox_ResetContent($ListBox2)
	GUICtrlSetState($Button2, $GUI_DISABLE)

	$iWord = _GUICtrlListBox_GetCurSel($ListBox1) + 1
	$sWord = $oSpellCollection.Item($iWord).Text

	$oAlternateWords = $oWordApp.GetSpellingSuggestions($sWord)
	If $oAlternateWords.Count > 0 Then
		For $i = 1 To $oAlternateWords.Count
			_GUICtrlListBox_AddString($ListBox2, $oAlternateWords.Item($i).Name)
		Next
	Else
		_GUICtrlListBox_AddString($ListBox2, "No suggestions.")
	EndIf
EndFunc   ;==>_SpellingSuggestions

Func _HighlightWord()
	Local $sText, $iWord, $sWord, $iEnd, $iStart
	;
	$iWord = _GUICtrlListBox_GetCurSel($ListBox1) + 1
	$sWord = $oSpellCollection.Item($iWord).Text
	$sText = $oRange.Text

	$iStart = ($oSpellCollection.Item($iWord).Start)
	$iEnd = ($oSpellCollection.Item($iWord).End)
	_GUICtrlEdit_SetSel($Edit, $iStart, $iEnd)
EndFunc   ;==>_HighlightWord

Func _ReplaceWord()
	Local $iWord, $iNewWord, $sWord, $sNewWord, $sText, $sNewText
	;
	$iWord = _GUICtrlListBox_GetCurSel($ListBox1) + 1
	$iNewWord = _GUICtrlListBox_GetCurSel($ListBox2) + 1
	If $iWord == $LB_ERR Or $iNewWord == $LB_ERR Then
		MsgBox(48, "Error", "You must first select a word to replace, then a replacement word.")
		Return
	EndIf
	$oSpellCollection.Item($iWord).Text = $oAlternateWords.Item($iNewWord).Name

	GUICtrlSetData($Edit, $oRange.Text)

	_SpellCheck()

	GUICtrlSetState($Button2, $GUI_DISABLE)
EndFunc   ;==>_ReplaceWord

Func _SetLanguage()
	$sLang = GUICtrlRead($Combo)
	If $sLang <> "" Then
		$oWordApp.CheckLanguage = False
		For $i = 1 To $aLangs[0][0]
			If $sLang = $aLangs[$i][0] Then
				$WdLangID = Number($aLangs[$i][1])
			EndIf
		Next

		If $WdLangID Then
			With $oRange
				.LanguageID = $WdLangID
				.NoProofing = False
			EndWith
		EndIf
	Else
		$oWordApp.CheckLanguage = True
	EndIf
EndFunc   ;==>_SetLanguage

Func _Exit()
	_WordQuit($oWordApp, 0)
	Exit
EndFunc   ;==>_Exit
