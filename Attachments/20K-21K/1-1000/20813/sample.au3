#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <WinAPI.au3>
Opt('MustDeclareVars', 1)

_Main()

Func _Main()
    Local $aWindows, $i, $text
    $aWindows = _WinAPI_EnumWindows()
    For $i = 1 To UBound($aWindows) - 1
		$text = WinGetTitle($aWindows[$i][0])
		if StringCompare($text, "Popup's Title") == 0 Then
			; FOUND!
			$text = "Window Handle: " & $aWindows[$i][0] & @LF
			$text &= "Window Class: " & $aWindows[$i][1] & @LF
			$text &= "Window Title: " & WinGetTitle($aWindows[$i][0]) & @LF
			$text &= "Window Text: " & WinGetText($aWindows[$i][0]) & @LF
			$text &= "Window Process: " & WinGetProcess($aWindows[$i][0])
			MsgBox(0, "Item " & $i & " of " & UBound($aWindows) - 1, $text)
		endif
    Next
EndFunc   ;==>_Main