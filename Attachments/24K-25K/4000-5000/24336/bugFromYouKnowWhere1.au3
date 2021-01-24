#Include "..\resources\1Date.au3"
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
WinWait("Untitled - Notepad","",3)
If Not WinActive("Untitled - Notepad","") Then WinActivate("Untitled - Notepad","")
WinWaitActive("Untitled - Notepad","")
MouseMove(190,86)
MouseDown("left")
MouseUp("left")
Send("{SHIFTDOWN}t{SHIFTUP}esting{SPACE}1,2,4")
func _logError()
local $textToSend = "failure"
local $msgHandle = ControlGetHandle("Receiver","","[CLASS:Static; INSTANCE:1]")
ControlSetText("Receiver","",$msgHandle,$textToSend)
dim $errorLog = FileOpen ( "ScriptRunner Error Log.txt",1)
dim $errorMessage = "Error during scriptrunner useage."&@crlf&"Window not found in "&@ScriptName&" script"
dim $sysTime =_Date_Time_GetSystemTime()
dim $timeStamp =_Date_Time_SystemTimeToDateTimeStr($sysTime)
FileWrite("ScriptRunner Error Log.txt",$timeStamp)
FileWrite("ScriptRunner Error Log.txt",$errorMessage)
FileClose($errorLog)
Exit
EndFunc
