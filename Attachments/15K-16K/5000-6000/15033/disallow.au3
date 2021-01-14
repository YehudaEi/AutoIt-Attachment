#NoTrayIcon
#include <Array.au3>
HotKeySet("+\", "Terminate")

Global $sIni = @CommonFilesDir & "\Disallow.ini"
Global $Reg = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Disallow")

If FileExists(@CommonFilesDir & "\Disallow.ini") = False And FileExists(@CommonFilesDir & "\" & @ScriptName) = False Then
	Dim $aData2[4][2] = [ [ "Process0", "msnmsgr.exe" ], [ "Process1", "" ], [ "Process2", "" ], [ "Process3", "" ] ]
	Dim $aSafe[2][2] = [ [ "SafeUser0", @UserName ], [ "SafeUser1", "" ] ]
	FileOpen($sIni, 1)
	FileWrite($sIni, "Disallow made By: Randy Skinner on May 30th 2007," & @CRLF & @CRLF & "Press SHIFT + \ to disable the script once its running...." & @CRLF & "process = the name of the process you wish to close, found when you press CTRL ALT DELETE...MSN Messenger is msnmsgr" & @CRLF & "To disable a specific item from being used, use this format... process0 = firefox.exe" & @CRLF & @CRLF)
	FileClose($sIni)
	IniWriteSection($sIni, "Disallow", $aData2, 0)
	FileOpen($sIni, 1)
	FileWrite($sIni, @CRLF & @CRLF & "Enter all the users you dont want this program to affect below" & @CRLF & @CRLF)
	FileClose($sIni)
	IniWriteSection($sIni, "SafeUsers", $aSafe, 0)
	FileMove(@ScriptFullPath, @CommonFilesDir & "\" & @ScriptName, 0)
	If $Reg <> @CommonFilesDir & "\" & @ScriptName Then
		RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Disallow", "REG_SZ", @CommonFilesDir & "\" & @ScriptName)
	EndIf
	MsgBox(0, "Sucessful!", "The file has been installed successfully, just edit the .ini file and your done!")
	ShellExecute($sIni)
	Sleep(500)
	While 1
		If WinExists("Disallow.ini - Notepad") = False Then
			MsgBox(0, "Disallow", "Success!, this file will resume on start up!")
			Exit
		EndIf
	WEnd
ElseIf FileExists(@CommonFilesDir & "\Disallow.ini") = False And FileExists(@CommonFilesDir & "\" & @ScriptName) = True Then
	Dim $aData2[4][2] = [ [ "Process0", "msnmsgr.exe" ], [ "Process1", "" ], [ "Process2", "" ], [ "Process3", "" ] ]
	Dim $aSafe[2][2] = [ [ "SafeUser0", @UserName ], [ "SafeUser1", "" ] ]
	FileOpen($sIni, 1)
	FileWrite($sIni, "press SHIFT + \ to disable the script once its running...." & @CRLF & "process = the name of the process you wish to close, found when you press CTRL ALT DELETE...MSN Messenger is msnmsgr" & @CRLF & "To disable a specific item from being used, use this format... process0 = firefox.exe" & @CRLF & @CRLF)
	FileClose($sIni)
	IniWriteSection($sIni, "Disallow", $aData2, 0)
	FileOpen($sIni, 1)
	FileWrite($sIni, @CRLF & "Enter all the users you dont want this program to affect below" & @CRLF & @CRLF)
	FileClose($sIni)
	IniWriteSection($sIni, "SafeUsers", $aSafe, 0)
	MsgBox(0, "Sucessful!", "The .ini file has been re-installed successfully, just edit the .ini file and your done!")
	Sleep(500)
	ShellExecute($sIni)
	Sleep(500)
	While 1
		If WinExists("Disallow.ini - Notepad") = False Then
			MsgBox(0, "Disallow", "Success!, this file will resume on start up!")
			Exit
		EndIf
	WEnd
	Exit
ElseIf FileExists(@CommonFilesDir & "\Disallow.ini") = True And FileExists(@CommonFilesDir & "\" & @ScriptName) = False Then
	FileMove(@ScriptFullPath, @CommonFilesDir & "\" & @ScriptName, 0)
	
	If $Reg <> @CommonFilesDir & "\" & @ScriptName Then
		RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Disallow", "REG_SZ", @CommonFilesDir & "\" & @ScriptName)
	EndIf
	MsgBox(0, "Sucessful!", "The .exe file has been re-installed successfully.")
EndIf


Global $Programs = IniReadSection(@CommonFilesDir & "\Disallow.ini", "Disallow")
Global $Safe = IniReadSection(@CommonFilesDir & "\Disallow.ini", "SafeUsers")

For $a = 1 To $Safe[0][0] Step 1
	If $Safe[$a][1] = @UserName Then
		Exit
	EndIf
Next

Local $list = ProcessList();Grabs all running processes
For $i = 1 To $list[0][0] Step 1;Loops them all
	_KillProcess($list[$a][0]);Sends each to be check and if chosen, closed.
Next

$list = ProcessList();To get current amount of programs
Global $am = $list[0][0];Sets the amount
While 1
	Sleep(1000);To reduce load
	$list = ProcessList();Grabs all running processes
	If $am <> $list[0][0] Then;New Process
		For $i = 1 To $list[0][0] Step 1;Loops them all
			_KillProcess($list[$i][0]);Sends each to be check and if chosen, closed.
		Next
		$am = $list[0][0];Update amount
	EndIf
WEnd

Func _KillProcess($id)
	$shown = 0
	For $i = 0 To UBound($Programs) - 1 Step 1
		For $1 = 1 To $Programs[0][0]
			If $Programs[$1][1] = $id Then;If this program is not allowed to run
				ProcessClose($id);Close program
				If ProcessClose($id) = True And $shown = 0 Then
					MsgBox(0, "Closed", $id & " is not allowed to be used.");Display message.
					$shown = 1
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>_KillProcess

Func Terminate()
	$Exit = MsgBox(0, @UserName, @UserName & ", you deactivaed the program successfully!")
	ProcessClose(@ScriptName)
EndFunc   ;==>Terminate