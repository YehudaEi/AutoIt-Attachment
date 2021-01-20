#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

Opt("TrayIconDebug", 1)

$Main = GUICreate("English Dictionary", 600, 370)
$Edit = GUICtrlCreateEdit("", 15, 15, 570, 300, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL))
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Input = GUICtrlCreateInput("", 15, 330, 405, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Search = GUICtrlCreateButton("Search", 435, 330, 150, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $Search
			$Definitions = Find_Definition(GUICtrlRead($Input))
			GUICtrlSetData($Edit, $Definitions)
		Case - 3
			Exit
	EndSwitch
WEnd

Func Find_Definition($Word)
	Local $IE = ObjCreate("InternetExplorer.Application")
	If Not IsObj($IE) Then
		MsgBox(0, "ERROR", "Object is not a variable.")
		Exit
	EndIf
	$IE.navigate("                                       " & $Word)
	While 1
		If $IE.readyState = "complete" Or $IE.readyState = 4 Or $IE.busy = False Then ExitLoop
		Sleep(200)
	WEnd
	Local $text = $IE.document.body.innertext
	If StringInStr($text, "Origin:") Then
		$text = StringRegExpReplace($text, "(?i)(?s)(.*?Show IPA)(.*?)(Origin:.*?)\z", "\2")
	ElseIf StringInStr($text, "Related forms:") Then
		$text = StringRegExpReplace($text, "(?i)(?s)(.*?Show IPA)(.*?)(Related forms:.*?)\z", "\2")
	ElseIf StringInStr($text, "Synonyms:") Then
		$text = StringRegExpReplace($text, "(?i)(?s)(.*?Show IPA)(.*?)(Synonyms:.*?)\z", "\2")
	Else
		$text = StringRegExpReplace($text, "(?i)(?s)(.*?Show IPA)(.*?)(Dictionary\.com Unabridged.*?)\z", "\2")
	EndIf
	$Array = StringRegExp($text, "(?:\A|\v)((?:(?:–|-)+\w|\d+(?:\xB7|\.)|[a-zA-Z](?:\xB7|\.)).+?)\v", 3)

	Local $x = 0
	While 1
		If $x >= UBound($Array) Then ExitLoop
		If StringLeft($Array[$x], 2) = "b." Then
			; SubItem Definitions
			Local $place = StringInStr($Array[$x - 1], "a.")
			Local $NewString = StringRight($Array[$x - 1], StringLen($Array[$x - 1]) - $place + 1)
			$Array[$x - 1] = StringLeft($Array[$x - 1], $place - 1)
			_ArrayInsert($Array, $x, $NewString)
			$x += 2
		ElseIf StringRegExp($Array[$x], "(\s{1}[1-9]+\.{1}\w)") Then
			If $x <> 0 Then
				_ArrayInsert($Array, $x)
				$x += 1
			EndIf
			; Part of Speech
			Local $Numbers = StringRegExp($Array[$x], ".+\s([0-9]+)\.\w", 2)
			Local $place = StringInStr($Array[$x], " " & $Numbers[1] & ".")
			Local $NewString = StringRight($Array[$x], StringLen($Array[$x]) - $place + 1)
			$Array[$x] = StringLeft($Array[$x], $place - 1)
			_ArrayInsert($Array, $x + 1, $NewString)
			$x += 2
		Else
			$x += 1
		EndIf
	WEnd
	For $x = 0 To UBound($Array) - 1
		$Array[$x] = StringStripWS($Array[$x], 3)
	Next
	$IE.quit
	$IE = 0
	Return _ArrayToString($Array, @CRLF)
EndFunc   ;==>Find_Definition