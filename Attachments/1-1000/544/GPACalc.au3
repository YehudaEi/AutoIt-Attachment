#cs
Name: GPACalc 1.0
Author: El-Trucha
Date: 12/5/04
Dev tool: AutoIt 3.0.102
#ce

#cs
Fix:
1. Decimal numbers
#ce

$classes = InputBox("How much classes?", "How much classes did you have all over high school? (include only the classes that you want calculated)")
If @error = 1 Then Exit
If NOT StringIsDigit($classes) Then NotANumber()

$x = 1

Dim $class[$classes+1] 
For $x = 1 To $classes
	$class[$x] = InputBox("What grade?", "What's your grade for class #" & $x & "??" & @CR & "(please make it a number 1 thru 4...)")
	If @error = 1 Then Exit
	If NOT StringIsDigit($classes) Then NotANumber()
	If $class[$x] > 4 Then InvalidNumber()
Next

$x = 1
Dim $grade

For $x = 1 To $classes
	$grade = $grade + $class[$x]
	;MsgBox(48, "Lo", $class[$x])
Next

$finalGrade = $grade / $classes

If $finalGrade < 1 Then $gradeLetter = "F"
If $finalGrade >= 1 Then $gradeLetter = "D"
If $finalGrade >= 2 Then $gradeLetter = "C"
If $finalGrade >= 3 Then $gradeLetter = "B"
If $finalGrade >= 4 Then $gradeLetter = "A"




$message = StringFormat("Your GPA is %d, that means you got a(n) %s!!", $finalGrade, $gradeLetter)


MsgBox(64, "Your GPA...", $message)

If $gradeLetter = "F" Then MsgBox(16, "YOU SUCK!!!", "You got an F dude!! do you think that's good?? NO IT ISN'T!! SO NOW GO STUDY!!!!!! MOVE IT!! MOVE IT!!!!!!!!!")
If $gradeLetter = "D" Then MsgBox(16, "YOU SUCK!!!", "You got a D!!! well, not that bad as an F, but it stinks anyways!!")
If $gradeLetter = "C" Then MsgBox(48, "So-so...", "Well...a C is not that bad, you can improve it!!;)")
If $gradeLetter = "B" Then MsgBox(64, "Good!!", "Pretty good!! a B rocks!! - keep up the good job!! ;)")
If $gradeLetter = "A" Then MsgBox(64, "YOU'RE THE BEST!!!!!", "You're a genious!! please keep it an A, and don't drop it down!! ;)")


Func NotANumber()
	$error = StringFormat("""%s"" is not a number, is it??", $classes)
	MsgBox(16, "Error!!", $error)
	Exit
EndFunc

Func InvalidNumber()
	$error = StringFormat("""%d"" is not a number 1 thru 4, is it??", $class[$x])
	MsgBox(16, "Error!!", $error)
	Exit
EndFunc