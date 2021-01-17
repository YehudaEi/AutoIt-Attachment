#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <Inet.au3>
#include <String.au3>

$Main = GUICreate("English Dictionary", 600, 370)
$Edit = GUICtrlCreateEdit("", 15, 15, 570, 300, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL))
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Input = GUICtrlCreateInput("", 15, 330, 405, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Search = GUICtrlCreateButton("Search", 435, 330, 150, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $Search
			$Result = Look_Up(GUICtrlRead($Input))
			If $Result = -1 Then
				MsgBox(262192, "ERROR", "That word is not in the dictionary!")
				GUICtrlSetData($Edit, "")
			Else
				GUICtrlSetData($Edit, $Result)
			EndIf
		Case - 3
			Exit
	EndSwitch
WEnd

Func Look_Up($Word)
	If StringRegExp($Word, "[^a-zA-Z+]") = 1 Then Return -1
	$Website = "                                       " & $Word
	$Source = _INetGetSource($Website)
	
	$Test = _StringBetween($Source, '<div id="Heading" class="Heading">', '<i>')
	If Not @error And StringStripWS(StringLower($Test[0]), 3) = "no results found for" Then Return -1
	
	$Source = StringTrimLeft($Source, StringInStr($Source, '<span class="pg">') + 15)
	$Source = StringReplace($Source, '<div class="ety"> <b>Origin:', '<span class="sectionLabel">Synonyms:')

	$string = _StringBetween($Source, ">", "</span>")
	$Line1 = $string[0]
	If StringInStr($Line1, ",") Then $Line1 = StringLeft($Line1, StringInStr($Line1, ",") - 1)
	$Line1 = StringRegExpReplace($Line1, "[^a-zA-Z]", "") & @CRLF

	$Source = _StringBetween($Source, '<td width="35" class="dnindex">1.</td> <td>', '<span class="sectionLabel">Synonyms:')
	$Text = StringSplit($Source[0], '<td width="35" class="dnindex">', 1)
	$Text[1] = "1. " & $Text[1]

	For $n = 0 To $Text[0]
		$Text[$n] = StringRegExpReplace($Text[$n], "(<.*?>)", "")
	Next

	$Text = "1. " & StringReplace($Source[0], '<td width="35" class="dnindex">', @CRLF)

	$Text = StringRegExpReplace($Text, "(<.*?>)", "")
	$Text = "--" & $Line1 & @CRLF & $Text

	$Replace = StringReplace($Text, "–", "--")
	If $Replace Then $Text = $Replace
	$Array = StringSplit($Text, @CRLF)
	_ArrayDelete($Array, 0)
	$x = 0
	While 1
		If $x >= UBound($Array) - 1 Then ExitLoop
		If Not StringRegExp($Array[$x], '[^\w\p{P}\040]+') Then
			_ArrayDelete($Array, $x)
			$x -= 1
		EndIf
		$x += 1
	WEnd
	$Text = _ArrayToString($Array, @CRLF)
	$Text = StringReplace($Text, "--", @CRLF & @CRLF & "--")
	$Text = StringStripWS($Text, 3)
	Return $Text
EndFunc   ;==>Look_Up