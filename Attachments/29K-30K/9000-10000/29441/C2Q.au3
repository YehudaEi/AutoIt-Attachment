#cs
	Name: Colemak to QWERTY
	Author: Crend King
	Description: Based on JBr00ks's Original Keyboard Layout
	Thanks to: JBr00ks, Toady and RazerM!
#ce

#include <Misc.au3>
#include <vkConstants.au3>

If _Singleton("C2Q", 1) = 0 Then
	MsgBox(262144, "Error", "Colemak to QWERTY is already running!")
	Exit
EndIf

$DLL = DllOpen("user32.dll")
$key_count = 17	; number of key to remap
Dim $lower_src_keys[$key_count] = ["f", "p", "g", "j", "l", "u", "y", "r", "s", "t", "d", "n", "e", "i", "o", "k", ";"]
Dim $upper_src_keys[$key_count] = ["F", "P", "G", "J", "L", "U", "Y", "R", "S", "T", "D", "N", "E", "I", "O", "K", ":"]
Dim $lower_dest_keys[$key_count] = ["e", "r", "t", "y", "u", "i", "o", "s", "d", "f", "g", "j", "k", "l", ";", "n", "p"]
Dim $upper_dest_keys[$key_count] = ["E", "R", "T", "Y", "U", "I", "O", "S", "D", "F", "G", "J", "K", "L", ":", "N", "P"]
Dim $key_code[$key_count]	; key code for _IsPressed()

; get key codes
For $i = 0 To ($key_count - 2)
	$key_code[$i] = Hex(Execute("$VK_" & $upper_src_keys[$i]))
Next
$key_code[$key_count - 1] = "BA"	; special case for the semicolon key

For $i = 0 To ($key_count - 1)
	HotKeySet($lower_src_keys[$i], "Block")
	HotKeySet($upper_src_keys[$i], "Block")
Next

While 1
	Sleep(1)
	CheckKeys()
WEnd

Func Block()
EndFunc   ;==>Block

Func CheckKeys()
	For $i = 0 To ($key_count - 1)
		If _IsPressed($key_code[$i], $DLL) Then
			If _IsPressed(10, $DLL) = _GetCapsState() Then
				HotKeySet($lower_dest_keys[$i])
				Send($lower_dest_keys[$i], 1)
				HotKeySet($lower_dest_keys[$i],d "Block")
			Else
				HotKeySet($upper_dest_keys[$i])
				Send($upper_dest_keys[$i], 1)
				HotKeySet($upper_dest_keys[$i], "Block")
			EndIf
			
			; interruptable repeat when key is down and not up
			For $j = 0 To 24
				If _IsPressed($key_code[$i], $DLL) Then
					Sleep(1)
				Else
					ExitLoop
				EndIf
			Next
		EndIf
	Next
EndFunc   ;==>CheckKeys

Func _GetCapsState()
	$av_ret = DllCall($DLL, "int", "GetKeyState", "int", $VK_CAPITAL)
	Return $av_ret[0]
EndFunc   ;==>_GetCapsState
