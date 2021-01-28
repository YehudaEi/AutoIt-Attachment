$AT_log_file = "c:\AGT\Already System - 2009U1.txt"

Run("notepad.exe")
WinWaitActive("Untitled - Notepad","",5)
WinActivate("Untitled - Notepad")
WinMenuSelectItem("Untitled - Notepad", "", "&File", "&Save")
Send($AT_log_file)
Send("{Enter}")
sleep(4000)
If WinExists("Save As") Then
	Send("{TAB 1}")
	Send("{Enter}")
EndIf
Send("STEP 1 : This is first Line{Enter}")
Send("^s")
sleep(4000)
$title = WinGetTitle("Already - ", "")
sleep(4000)
WinActive("Already  - Notepad")
WinClose("Already System - 2009U1.txt - Notepad")
$file = FileOpen("c:\AGT\Already System - 2009U1.txt", 1)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
FileWrite($file, $title)
FileClose($file)
sleep(2000)
Run("notepad.exe")
Sleep(2000)
WinMenuSelectItem("Untitled - Notepad", "", "&File", "&Open")
Send($AT_log_file)
sleep(1000)
send("{Enter}")
sleep(4000)
send("STEP2 - This is second Line{Enter}")
send("^s")
