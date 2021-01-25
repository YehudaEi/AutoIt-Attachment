#include <Misc.au3>

; #FUNCTION# ===================================================================
; Name ..........: _HotKeysSet
; Description ...: Set combo of hotkeys
; AutoIt Version : V3.3.0.0
; Syntax ........: _HotKeysSet($sKeys, $sFunc [, $vArgs=""[, $iDelay=300]])
; Parameter(s): .: $sKeys       - Keys for combo
;                  $sFunc       - Function to call
;                  $vArgs       - Optional: (Default = "")  : Function parameter(s)
;                                 If array of parameters is used then $vArgs[0] 
;                                 must be "CallArgArray" (see help file for Call)
;                  $iDelay      - Optional: (Default = 300) : Delay
; Author(s) .....: Igor Zakrzewski
; ==============================================================================
Func _HotKeysSet($sKeys, $sFunc, $aArgs="", $vDelay=300)
Local $tHotKeys
Local $aKeyCodes[42][2] = 	[ _
							["30","0"], _
							["31","1"], _
							["32","2"], _
							["33","3"], _
							["34","4"], _
							["35","5"], _
							["36","6"], _
							["37","7"], _
							["38","8"], _
							["39","9"], _
							["41","A"], _
							["42","B"], _
							["43","C"], _
							["44","D"], _
							["45","E"], _
							["46","F"], _
							["47","G"], _
							["48","H"], _
							["49","I"], _
							["4A","J"], _
							["4B","K"], _
							["4C","L"], _
							["4D","M"], _
							["4E","N"], _
							["4F","O"], _
							["50","P"], _
							["51","Q"], _
							["52","R"], _
							["53","S"], _
							["54","T"], _
							["55","U"], _
							["56","V"], _
							["57","W"], _
							["58","X"], _
							["59","Y"], _
							["5A","Z"], _
							["01","("], _ ; LEFT MOUSE BUTTON
							["02",")"], _ ; RIGHT MOUSE BUTTON
							["04","*"], _ ; MIDDLE MOUSE BUTTON
							["10","+"], _ ; SHIFT KEY
							["11","^"], _ ; CONTROL KEY
							["12","!"] ]  ; ALT KEY


	$aKeys = StringSplit($sKeys,"",2)
	For $keys=0 To UBound($aKeys)-1
		For $codes=0 To UBound($aKeyCodes)-1
			If $aKeys[$keys]=$aKeyCodes[$codes][1] Then $aKeys[$keys]=$aKeyCodes[$codes][0]
		Next
	Next

	
	If _IsPressed($aKeys[0]) then
		$tHotKeys = TimerInit()
		$i = 1
		While TimerDiff($tHotKeys) < $vDelay
		If (($i < UBound($aKeys)-1) AND (_IsPressed($aKeys[$i]))) Then
			If $aKeys[$i] == $aKeys[$i-1] Then Sleep(100)
			$tHotKeys = TimerInit()
			$i += 1
		ElseIf (($i = UBound($aKeys)-1) AND (_IsPressed($aKeys[$i]))) Then
			If $aKeys[$i] == $aKeys[$i-1] Then Sleep(100)
			If $aArgs="" Then 
				Call($sFunc)
				Return 1
			Else
				Call($sFunc, $aArgs)
				Return 1
			EndIf
			$i=0
		EndIf
	WEnd
EndIf
EndFunc
