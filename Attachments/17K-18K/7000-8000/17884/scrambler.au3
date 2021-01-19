#include <GuiConstants.au3>
#include <Array.au3>

Opt("GuiOnEventMode", 1)
$GuiChild = 0
$timer = 0
$timeout = 0
$chilis2 = 0
$GuiParent = GUICreate("MyGUI", 384, 314, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUISetState()

$scramble = GUICtrlCreateButton("scramble", 300, 210, 70, 50)
GUICtrlSetOnEvent(-1, "scramblepressed")

$thetext = GUICtrlCreateEdit("Paste text to be scrambled here", 40, 140, 250, 130)
$input = GUICtrlCreateInput("2", 10, 10, 50, 20)
$updown = GUICtrlCreateUpdown($input)
$chilis = GUICtrlCreateLabel("pick difficulty number", 30, 60, 100, 20)
$prefix = GUICtrlCreateCheckbox("don't change first letter", 30, 75)
$word = GUICtrlCreateCheckbox("don't scramble the word", 30, 95)
$phrase = GUICtrlCreateCheckbox("don't scramble the phrase", 200, 75)
; Attempt to resize input control
GUICtrlSetPos($input, 10, 10, 100, 40)

While 1
	Sleep(30)
WEnd

Func scramblepressed()
	$text = GUICtrlRead($thetext)
	_scrambler($text)
EndFunc   ;==>scramblepressed



Func _scrambler($a)
	_child()
	$a = StringReplace($a, "-", " ")
	$a = StringReplace($a, ",", ".")
	$a = StringReplace($a, "?", ".")
	$splitstringx = StringSplit($a, " ")
	Dim $finish[UBound($splitstringx) ]
	$x = 0
	$y = 0
	$d = 0
	If GUICtrlRead($word) <> 1 Then
		While $x < UBound($splitstringx) - 1
			
			$x = $x + 1
			
			_wordsplit($splitstringx, $x, $d)
			
			$y = 0
			$finish[$x] = $d
			
		WEnd
	Else
		$finish = $splitstringx
	EndIf
	_phraser($finish)
	$z = _ArrayToString($finish, " ", 1)
	
	$stuff = StringSplit($z, ".")
	
	$count = 0
	While $count < UBound($stuff) - 1
		$count = $count + 1
		$timeout = StringLen($stuff[$count]) * 100 / GUICtrlRead($input)
		GUICtrlSetData($chilis2, $stuff[$count])
		$timer = 0
		If WinExists("Scrambled") Then
		Else
			ExitLoop
		EndIf

		HotKeySet("{esc}", "_Warn")
		While $timer < $timeout
			$timer = $timer + 1
			Sleep(10)
		WEnd
		HotKeySet("{esc}")
		
	WEnd
	HotKeySet("{space}")
	WinClose("Scrambled")
EndFunc   ;==>_scrambler

Func _wordsplit($a, $b, ByRef $d)
	$Messydown = $a[$b]
	$stringsplity = StringSplit($Messydown, "", 1)
	$y = 0
	$x = 0
	
	$ischecked = 0
	If GUICtrlRead($prefix) = 1 Then $ischecked = 1
	
	While $x < 5
		$min = 1 + $ischecked
		$max = UBound($stringsplity) - 1
		If $min < $max Then
			$one = Random($min, $max, 1)
			$two = Random($min, $max, 1)
			If $stringsplity[$one] = "@cr"  Then $stringsplity[$one] = ""
			If $stringsplity[$two] = "@cr"  Then $stringsplity[$one] = ""
			While $stringsplity[$one] = ""
				$one = Random($min, $max, 1)
			WEnd
			While $stringsplity[$two] = "." 
				$two = Random($min, $max, 1)
			WEnd
			While $one = 0
				$one = Random($min, $max, 1)
			WEnd
			While $two = 0
				$two = Random($min, $max, 1)
			WEnd
		Else
			$one = 1
			$two = 1
		EndIf
		_ArraySwap($stringsplity[$one], $stringsplity[$two])
		$d = _ArrayToString($stringsplity, "", 1)
		
		$x = $x + 1
	WEnd
EndFunc   ;==>_wordsplit

Func DeleteGui()
	GUIDelete()
EndFunc   ;==>DeleteGui

Func _Quit()
	Exit
EndFunc   ;==>_Quit

Func _Warn()
	GUIDelete($GuiChild)
	$timer = $timeout
EndFunc   ;==>_Warn

Func _timeoutnow()
	If $timeout > 0 Then $timer = $timeout
	
EndFunc   ;==>_timeoutnow

Func _child()
	$GuiChild = GUICreate("Scrambled", 600, 600, 100, 100, -1, -1, $GuiParent)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_warn")
	GUISetState()
	
	$chilis2 = GUICtrlCreateLabel("gar", 10, 10, 530, 500)
	$chilis3 = GUICtrlCreateLabel("press space to advance", 200, 550)
	$cancel = GUICtrlCreateLabel("press esc to cancel out", 200, 570)
	
	HotKeySet("{space}", "_timeoutnow")
EndFunc   ;==>_child

Func _phraser(ByRef $finish)
	If GUICtrlRead($phrase) <> 1 Then
		$min = 1
		$max = UBound($finish) - 1
		$x = 0
		While $x < 5
			$one = 0
			$two = 0
			While $one = $two
				$one = Random($min, $max, 1)
				$two = Random($min, $max, 1)
			WEnd
			_ArraySwap($finish[$one], $finish[$two])
			$x = $x + 1
		WEnd
	EndIf
EndFunc   ;==>_phraser