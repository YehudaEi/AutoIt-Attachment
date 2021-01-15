; includes / options
#include <GUIConstants.au3>
#include <Constants.au3>
Opt("GUIOnEventMode", 1)
HotKeySet("!c", "_nextStep")
HotKeySet("!r", "_random")

Do 
    $request = InputBox("Gauß algorithm", "Number of equations and variables")
Until $request > 0
	
Global Const $dimension = $request
Global $continue = true

Global $matrix[$dimension][$dimension+1]
Global $aMatrix[$dimension][$dimension+1]
Global $solution[$dimension]

For $i = 0 To $dimension-1
	$solution[$i] = 0
Next

$GUI = GUICreate("Gauß algorithm", 90 + $dimension * 80, 105 + $dimension * 25)


For $i = 0 To $dimension - 1
	GUICtrlCreateLabel("x_" & ($i+1), 35 + 80*$i, 5, 75, 20)
Next
For $i = 0 To $dimension - 1
	For $j = 0 To $dimension
		$matrix[$i][$j] = GUICtrlCreateInput("", 5 + 80*$j, 25 + 25 * $i, 75, 20)
	Next
Next

$calculate = GUICtrlCreateButton("Solve", $dimension * 40 - 5, 30 + $dimension * 25, 100, 20)
$label = GUICtrlCreateLabel("Press ALT + C for the next step!", $dimension * 40 - 30, 55 + $dimension * 25, 190 + $dimension * 80, 150)
GUICtrlSetState(-1, $GUI_HIDE)
$random = GUICtrlCreateButton("Random matrix", $dimension * 40 - 5, 80 + $dimension * 25, 100, 20)

GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUICtrlSetOnEvent($calculate, "_calc")
GUICtrlSetOnEvent($random, "_random")

GUISetState()

While True
	sleep(100)
WEnd

Func _nextStep()
	$continue = true
EndFunc

Func _refreshGUI()
	For $i = 0 To $dimension - 1
		For $j = 0 To $dimension
			GUICtrlSetData($matrix[$i][$j], StringLeft($aMatrix[$i][$j], 10))
		Next
	Next
EndFunc

Func _random()
	For $i = 0 To $dimension - 1
		For $j = 0 To $dimension
			GUICtrlSetData($matrix[$i][$j], Random(0, 10, 1))
		Next
	Next
EndFunc

Func _calc()
	GUICtrlSetState($calculate, $GUI_DISABLE)
	GUICtrlSetState($label, $GUI_SHOW)
	For $i = 0 To $dimension-1
	$solution[$i] = 0
    Next
	For $i = 0 To $dimension - 1
	    For $j = 0 To $dimension
		    $aMatrix[$i][$j] = GUICtrlRead($matrix[$i][$j])
			If $aMatrix[$i][$j] = "" Then $aMatrix[$i][$j] = 0
	    Next
    Next
	_gaus(0)
	_refreshGUI()
	$continue = true
	GUICtrlSetState($calculate, $GUI_ENABLE)
	GUICtrlSetState($label, $GUI_HIDE)
EndFunc

Func _exit()
	Exit
EndFunc

Func _substitute()
	$i = $dimension - 2
	While $i > -0.1
		For $j = $i + 1 To $dimension - 1
			$solution[$i] -= $aMatrix[$i][$j]*$solution[$j]
        Next
		$solution[$i] += $aMatrix[$i][$dimension]
        $solution[$i] /= $aMatrix[$i][$i]		
		$i -= 1
	WEnd
EndFunc

Func _gaus($offset)
	If $dimension - $offset = 1 Then
        _refreshGUI()
        While NOT $continue
			sleep(100)
		WEnd
		$contine = false		
		$solution[$dimension-1] = $aMatrix[$offset][$dimension] / $aMatrix[$offset][$dimension-1]
		_substitute()
		For $i = 0 To $dimension - 1
			For $j = 0 To $dimension
				If $i = $j Then 
					$aMatrix[$i][$j] = 1
				ElseIf $j = $dimension Then 
					$aMatrix[$i][$j] = $solution[$i]
                Else 
					$aMatrix[$i][$j] = 0
                EndIf					
		    Next
	    Next
	Else 
		Local $nextOffset = _getNextOffset($offset)
		If $offset + $nextOffset > $dimension - 1 Then
			_refreshGUI()
			While NOT $continue
				sleep(100)
			WEnd
			$contine = false
			$aMatrix = _mkZero($dimension-2)
			_gaus($dimension-1)
		Else
			_refreshGUI()
			While NOT $continue
				sleep(100)
			WEnd
			$continue = false
		    $aMatrix = _mkZero($offset + $nextOffset)
		    _gaus($offset+1+$nextOffset)
		EndIf
    EndIf		
EndFunc

Func _getNextOffset($offset)
	Local $ret = 0
	For $i = $offset + 1 To $dimension - 1
		For $j = $offset + 1 To $dimension -1
			If $aMatrix[$i][$j] <> 0 Then Return $ret
			Next
		$ret += 1
	Next
	Return $ret
EndFunc
	

Func _mkZero($offset)
	Local $factor
	Local $firstNonZero = $offset
	While $firstNonZero < ($dimension-1) AND $aMatrix[$firstNonZero][$offset] = 0
		$firstNonZero += 1
	WEnd
	If $firstNonZero <> $offset Then $aMatrix = _Swap($offset, $firstNonZero)
	For $i = $offset + 1 To $dimension - 1
		$factor = $aMatrix[$i][$offset] / $aMatrix[$offset][$offset]
		For $j = $offset To $dimension
			If $j = $offset Then 
				$aMatrix[$i][$offset] = 0
			Else
			    $aMatrix[$i][$j] = $aMatrix[$i][$j] - $factor*$aMatrix[$offset][$j]
			EndIf
		Next
	Next
	Return $aMatrix
EndFunc

Func _Swap($line1, $line2)
	Local $temp
	For $i = 0 To $dimension
		$temp = $aMatrix[$line1][$i]
		$aMatrix[$line1][$i] = $aMatrix[$line2][$i]
		$aMatrix[$line2][$i] = $temp
	Next
	Return $aMatrix
EndFunc
		