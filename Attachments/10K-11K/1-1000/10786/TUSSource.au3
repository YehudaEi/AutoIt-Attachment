#NoTrayIcon
Global $number
Global $text
Global $actual

HotKeySet ("^x", "spam")
HotKeySet ("^d", "pause")
HotKeySet ("{ESC}", "quit")
HotKeySet ("^g", "respam")

MsgBox (4096, "The Ultimate Spammer - By IcyFerno™", "Ths is a spammer created by me, feel free to spam anyone with it." & @CRLF & "This is copyrighted by IcyFerno™." & @CRLF & "" & @CRLF & "Version 1.1")

$text = InputBox ("The Ultimate Spammer - Ver1.1", "Please type in the words that you would like to spam")
If @error = 1 Then
	Exit
EndIf

retype()
Func retype()
	$number = InputBox ("The Ultimate Spammer - Ver1.1", "Please Type the Number of times you would like to spam e.g. 100 . If you put in a decimal, the number will be automatically rounded.")
If @error = 1 Then
	Exit
EndIf

	$actual = Round(Number($number))
	
If $actual = 0 Then
	MsgBox(4096, "FATAL ERROR!!!", "You entered an invalid handle!!! (You either entered a letter or a zero)")
	Return retype()
EndIf

If $number <0 Then
	MsgBox(4096, "FATAL ERROR!!!", "You entered a negative figure! Please only enter POSITIVE NUMBERS!")
	Return retype()
EndIf

$answer = MsgBox (4, "The Ultimate Spammer - Ver1.1", "You have decided to spam : " & $text & @CRLF & "You want to spam " & $actual & " time(s)" & @CRLF & "" & @CRLF & "Ctrl + X to start, Ctrl + D to stop, Escape to Exit" & @CRLF & "If you want to change your spamming settings then click No.")
If $answer = 7 Then
	Return respam()
EndIf
ToolTip ("The Spammer is still on, press Esc to Quit", 0, 0)
	While 1
		Sleep (100)
	WEnd
EndFunc

Func spam()
	For $spam = 1 to $actual
		Send ($text)
		Send ("{ENTER}")
	Next
	MsgBox (4096, "The Ultimate Spammer - Ver1.1", "Please Press Ctrl + G to select a new sentence to spam or Ctrl + X to continue the same functions")
EndFunc

Func pause()
	While 1
		Sleep (50)
	WEnd
EndFunc

Func quit()
	MsgBox (4096, "The Ultimate Spammer - Ver1.1", "Thnaks for using! If you have any comments please feel free to email me at: reborndk@gmail.com")
	Exit 
EndFunc

Func respam()
	$text = InputBox ("The Ultimate Spammer - Ver1.1", "Please type in the words that you would like to spam")
If @error = 1 Then
	Exit
EndIf
Return retype()
EndFunc