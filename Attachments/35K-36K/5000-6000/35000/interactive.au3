#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

run("notepad.exe")
winwaitactive ("Untitled - Notepad")
$text = wingettext ("[active]")
If stringinstr($text, "type stuff") then
	send("{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}")
	send("like what?")
	sleep(1000)
	("{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}")
If stringinstr($text, "my callsign") then
	send("{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}")
	send("KD8LVT")
	sleep(1000)
	send("{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}")
$quit=1;quit = 1 so the script will exit the loop and end
	EndIf
	