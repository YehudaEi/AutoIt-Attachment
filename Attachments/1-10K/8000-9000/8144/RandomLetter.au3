; ,.-.,               ,.-.,
; ,.-., By: Joshua Lee Turner ,.-.,
; ,.-., 4/22/2006 ,.-.,
; ,.-., Created for personal use try not to hack all your friends with it. :P you can hack some of them but not all of them. ,.-.,
; ,.-., I made it easy to read so you get how it was done.  ,.-.,

Func _RandomLetter($s,$e)
	;=-=-=-=-=-=-=-=-=-=-=-=-=- Defines the min letter to become a number 1-26
	If $s = "a" Then
		$s = 1
	EndIf
	
	If $s = "b" Then
		$s = 2
	EndIf
	
	If $s = "c" Then
		$s = 3
	EndIf
	
	If $s = "d" Then
		$s = 4
	EndIf
	
	If $s = "e" Then
		$s = 5
	EndIf
	
	If $s = "f" Then
		$s = 6
	EndIf
	
	If $s = "g" Then
		$s = 7
	EndIf
	
	If $s = "h" Then
		$s = 8
	EndIf
	
	If $s = "i" Then
		$s = 9
	EndIf
	
	If $s = "j" Then
		$s = 10
	EndIf
	
	If $s = "k" Then
		$s = 11
	EndIf
	
	If $s = "l" Then
		$s = 12
	EndIf
	
	If $s = "m" Then
		$s = 13
	EndIf
	
	If $s = "n" Then
		$s = 14
	EndIf
	
	If $s = "o" Then
		$s = 15
	EndIf
	
	If $s = "p" Then
		$s = 16
	EndIf
	
	If $s = "q" Then
		$s = 17
	EndIf
	
	If $s = "r" Then
		$s = 18
	EndIf
	
	If $s = "s" Then
		$s = 19
	EndIf
	
	If $s = "t" Then
		$s = 20
	EndIf
	
	If $s = "u" Then
		$s = 21
	EndIf
	
	If $s = "v" Then
		$s = 22
	EndIf
	
	If $s = "w" Then
		$s = 23
	EndIf
	
	If $s = "x" Then
		$s = 24
	EndIf
	
	If $s = "y" Then
		$s = 25
	EndIf
	
	If $s = "z" Then
		$s = 26
	EndIf
	;=-=-=-=-=-=-=-=-=-=-=-=-=- Defines the max letter to become a number 1-26
		If $e = "a" Then
		$e = 1
	EndIf
	
	If $e = "b" Then
		$e = 2
	EndIf
	
	If $e = "c" Then
		$e = 3
	EndIf
	
	If $e = "d" Then
		$e = 4
	EndIf
	
	If $e = "e" Then
		$e = 5
	EndIf
	
	If $e = "f" Then
		$e = 6
	EndIf
	
	If $e = "g" Then
		$e = 7
	EndIf
	
	If $e = "h" Then
		$e = 8
	EndIf
	
	If $e = "i" Then
		$e = 9
	EndIf
	
	If $e = "j" Then
		$e = 10
	EndIf
	
	If $e = "k" Then
		$e = 11
	EndIf
	
	If $e = "l" Then
		$e = 12
	EndIf
	
	If $e = "m" Then
		$e = 13
	EndIf
	
	If $e = "n" Then
		$e = 14
	EndIf
	
	If $e = "o" Then
		$e = 15
	EndIf
	
	If $e = "p" Then
		$e = 16
	EndIf
	
	If $e = "q" Then
		$e = 17
	EndIf
	
	If $e = "r" Then
		$e = 18
	EndIf
	
	If $e = "s" Then
		$e = 19
	EndIf
	
	If $e = "t" Then
		$e = 20
	EndIf
	
	If $e = "u" Then
		$e = 21
	EndIf
	
	If $e = "v" Then
		$e = 22
	EndIf
	
	If $e = "w" Then
		$e = 23
	EndIf
	
	If $e = "x" Then
		$e = 24
	EndIf
	
	If $e = "y" Then
		$e = 25
	EndIf
	
	If $e = "z" Then
		$e = 26
	EndIf
	;=-=-=-=-=-=-=-=-=-=-=-=-=- Selects the random letter
	$ran=Random($s,$e,1)
	;=-=-=-=-=-=-=-=-=-=-=-=-=- Finds the output letters
	If $ran = 1 Then
		$ran = "a"
	EndIf
	
	If $ran = 2 Then
		$ran = "b"
	EndIf
	
	If $ran = 3 Then
		$ran = "c"
	EndIf
	
	If $ran = 4 Then
		$ran = "d"
	EndIf
	
	If $ran = 5 Then
		$ran = "e"
	EndIf
	
	If $ran = 6 Then
		$ran = "f"
	EndIf
	
	If $ran = 7 Then
		$ran = "g"
	EndIf
	
	If $ran = 8 Then
		$ran = "h"
	EndIf
	
	If $ran = 9 Then
		$ran = "i"
	EndIf
	
	If $ran = 10 Then
		$ran = "j"
	EndIf
	
	If $ran = 11 Then
		$ran = "k"
	EndIf
	
	If $ran = 12 Then
		$ran = "l"
	EndIf
	
	If $ran = 13 Then
		$ran = "m"
	EndIf
	
	If $ran = 14 Then
		$ran = "n"
	EndIf
	
	If $ran = 15 Then
		$ran = "o"
	EndIf
	
	If $ran = 16 Then
		$ran = "p"
	EndIf
	
	If $ran = 17 Then
		$ran = "q"
	EndIf
	
	If $ran = 18 Then
		$ran = "r"
	EndIf
	
	If $ran = 19 Then
		$ran = "s"
	EndIf
	
	If $ran = 20 Then
		$ran = "t"
	EndIf
	
	If $ran = 21 Then
		$ran = "u"
	EndIf
	
	If $ran = 22 Then
		$ran = "v"
	EndIf
	
	If $ran = 23 Then
		$ran = "w"
	EndIf
	
	If $ran = 24 Then
		$ran = "x"
	EndIf
	
	If $ran = 25 Then
		$ran = "y"
	EndIf
	
	If $ran = 26 Then
		$ran = "z"
	EndIf
	;=-=-=-=-=-=-=-=-=-=-=-=-=- Sends out the letter
	Return $ran
EndFunc