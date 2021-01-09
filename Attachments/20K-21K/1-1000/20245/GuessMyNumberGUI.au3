#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Henry
 OS: 			WinXP

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
$Random=Random(1,100,1)
$Counter=0

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\hdixon\Desktop\AUTOIT PROGRAMMING\KODA\Guess My Number.kxf
$Form1 = GUICreate("Guess my Number", 401, 230, 193, 125)
GUISetBkColor(0xFFFFFF)
$Input1 = GUICtrlCreateInput("", 0, 56, 393, 21)
GUICtrlSetTip(-1, "Enter your guess here")
$Label1 = GUICtrlCreateLabel("Enter Your Guess Here:", 0, 0, 352, 48)
GUICtrlSetFont(-1, 26, 800, 0, "Adobe Garamond Pro")
$Button1 = GUICtrlCreateButton("Guess!", 0, 88, 195, 73, 0)
GUICtrlSetFont(-1, 22, 800, 0, "Waltography MV")
$Button3 = GUICtrlCreateButton("Help!", 300, 88, 100, 73, 0)
GUICtrlSetFont(-1, 22, 800, 0, "Waltography MV")
$Button2 = GUICtrlCreateButton("Credits", 200, 88, 100, 73, 0)
GUICtrlSetFont(-1, 18, 800, 0, "Walt Disney Script")
$Label2 = GUICtrlCreateLabel("Status:", 8, 168, 376, 48)
GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit
Case $Button2
	MsgBox(0, "Credits", "Scripting: Some Guy... (^^)")
Case $Button1
	Test()
Case $Button3
	MsgBox(32, "Help", "Write a number between 1 and 100 in the box. Press the GUESS! button to see if your number is higher or lower then the actual.")
EndSwitch
WEnd



Func Test()
$Guess=GUICtrlRead($input1)
If ($guess > $Random) then
	    $Label2 = GUICtrlCreateLabel("Status: Checking...", 8, 168, 376, 48)
		GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
		Sleep(Random(500, 1000))
        $Label2 = GUICtrlCreateLabel("Status: The Number is Lower!", 8, 168, 376, 48)
        GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
        $Counter=$Counter+1
    EndIf
If ($guess < $Random) then
	$Label2 = GUICtrlCreateLabel("Status: Checking...", 8, 168, 376, 48)
	GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
		Sleep(Random(500, 1000))
        $Label2 = GUICtrlCreateLabel("Status: The Number is Higher!", 8, 168, 376, 48)
        GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
        $Counter=$Counter+1
        EndIf
	If ($guess == $Random) then
		$Label2 = GUICtrlCreateLabel("Status: Checking...", 8, 168, 376, 48)
		GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
		Sleep(Random(500, 1000))
		If $Counter<5 Then
			$Phrase=" You are pro!"
		EndIf
		If $Counter<10 Then
			$Phrase=" You are OK..."
		EndIf
		If $Counter>10 Then
			$Phrase=" You are awful!"
		EndIf
		
        $Label2 = GUICtrlCreateLabel("Nice! You got it! It took you " &$Counter &" tries!" &$Phrase, 8, 168, 376, 48)
        GUICtrlSetFont(-1, 15, 800, 0, "Toxica")
        $Counter=$Counter+1
        Sleep(2000)
	EndIf
EndFunc
	
