#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Chris Lambert

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once

Global $vKeyQueue = ""
Global $aHotkeys[1][2]

Func _HotKeySet($vKey,$vFunction="")
	Local $iSearch,$iSearch
	$iSearch = _HotKeySearch($aHotkeys,$vKey)
	If $iSearch  = -1 then 
		;create a new entry
		$iSize = Ubound($aHotkeys)
		Redim $aHotkeys[$iSize +1][2]
		$aHotkeys[$iSize][0] = $vKey
		$aHotkeys[$iSize][1] = $vFunction
		HotKeySet($vKey,"_HotKeyRun")
	Else
		;Update existing entry
		$aHotkeys[$iSearch][1] = $vFunction
	EndIf

EndFunc

Func _HotKeyRun()
	
	Local $iSearch,$i
	$iSearch =_HotKeySearch($aHotkeys,@HotKeyPressed)
	If $iSearch <> -1 then 
		;send all of the hotkeys to the queue
		For $i = 1 to UBound($aHotkeys) -1
			HotkeySet($aHotkeys[$i][0],"_HotKeyQueue")
		Next
		
		Call($aHotkeys[$iSearch][1]);call the assigned hotkey function
		
		;set all of the hotkeys back to the _HotKeyRun function
		For $i = 1 to UBound($aHotkeys) -1
			HotkeySet($aHotkeys[$i][0],"_HotKeyRun")
		Next
		_ProcessHotKeyQueue()
	EndIf

EndFunc

Func _HotKeySearch(ByRef $aVArray,$vSearch)
	Local $i
	For $i = 1 to UBound($aVArray) -1
		If $aVArray[$i][0] == $vSearch then return $i
	Next
	Return -1
EndFunc

Func _HotKeyQueue()
    $vKeyQueue &= @HotKeyPressed & "|"
EndFunc

Func _ProcessHotKeyQueue()
    
    If $vKeyQueue = "" then Return;no buffered hotkeys
	Local $iKeyLen,$sKey
	ConsoleWrite("KeyQueue Buffer " & $vKeyQueue & @crlf);Debug to Scite
    $iKeyLen = StringInStr($vKeyQueue,"|")
    $sKey = StringLeft($vKeyQueue,$ikeyLen -1)
    $vKeyQueue = StringTrimLeft($vKeyQueue,$iKeyLen)
	ConsoleWrite("Sending Hotkey " & $sKey & @crlf);Debug to Scite
    Send($sKey)
    
Endfunc

