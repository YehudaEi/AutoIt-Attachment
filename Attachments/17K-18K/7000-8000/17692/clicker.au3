#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:         Zepx

 Script Function:
	Automatically Inserts account and password.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <file.au3>

; Variables
$filepath = "accounts.txt" ; File Path to accounts.txt
$programpath = "bux.exe" ; The Autoclicker File Path
$programtitle = "Bux.to Autoclicker" ; Program's Title when runned.
$account = "" ; Declared variable account
$password = "" ; Declared variable password
$time1 = 0 ; Start Timer
$time2 = 0.1 ; End Time
$duration = 450000 ; 7.5 Minutes

; Start up stuffs
$file = FileOpen($filepath, 0) ; File Path to Open
$countlines = _FileCountLines($filepath)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error!", "Unable to open file. File does not exists")
    Exit
EndIf

If $countlines = 0 Then
	MsgBox(0, "Error!", "File is empty! Please input account and password!")
	Exit
EndIf

For $i = 0 To $countlines
	$readline = FileReadLine($file, $i)
	$columns = StringSplit($readline, "|")
	$account[$i] = $columns[1]
	$password[$i] = $columns[2]
Next

; Begin to Run Bux.Execute

Run($programpath)
WinWaitActive($programtitle)

; Begin InputBox

For $a = 0 To $countlines
	ControlSend($programtitle, "", "[CLASSNN:Edit1]", $account[$a])
	ControlSend($programtitle, "", "[CLASSNN:Edit2]", $password[$a])
	ControlSend($programtitle, "", "[CLASSNN:Edit3]", $time1)
	ControlSend($programtitle, "", "[CLASSNN:Edit4]", $time2)
	ControlClick($programtitle, "", "[CLASSNN:Button3]")
	Sleep($duration)
	ControlClick($programtitle, "", "[CLASSNN:Button2]")
Next

MsgBox (0, "Completed!", "Program has complete! Click Ok to Exit!")
Exit