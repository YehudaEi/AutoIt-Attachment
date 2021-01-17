#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;#NoTrayIcon
Opt('MustDeclareVars', 1)
#include <File.au3>
#include <Date.au3>
#include "_RefreshTrayIcons.au3"


;Usage
;_RefreshTrayIcons()

;Demo
;//create 10 orphaned tray area buttons from closed processes

_CleanTrayTest()

;Two examples
;//clear icon if monitored process closed or crashed
;//could be used with dual scripts that restart a program if process is closed (if tray icon used)

;_ProcessMonitor("processname.exe")

;//tray icon monitor with error logging
;monitors tray for orphaned icons, reports to console and log file (for debug testing)

;_TrayMonitor(1000)


;//create 10 orphaned tray area buttons from closed processes
Func _CleanTrayTest()
	Local $iButtonCnt, $iErr, $iExt, $iTimer
	If MsgBox(1 + 262144, "Notification Area icon refresh demo", _
			"About to create and process close 10 temporary GUI's" & _
			@CRLF & "and orphan 10 icons in tray" & _
			@CRLF & "OK to proceed or Cancel") = 2 Then Exit
	_RunTestGUI(10)
	$iTimer = TimerInit()
	$iButtonCnt = _RefreshTrayIcons()
	$iErr = @error
	$iExt = @extended
	ConsoleWrite("- Runtime  " & Round(TimerDiff($iTimer)) & " Milliseconds" & @CRLF)
	ConsoleWrite("+ Deleted  " & $iButtonCnt & " orphaned tray notification area icon(s)" & _
			@CRLF & "! Error:    " & $iErr & " : Extended: " & $iExt & @CRLF & @CRLF)
	Exit
EndFunc   ;==>_CleanTrayTest

;//tray monitor with error logging
Func _TrayMonitor($iChkRate = 5000)
	Local $iButtonCnt, $iErr, $iExt, $iErrBuffer, $iExtBuffer
	While 1
		Sleep($iChkRate)
		$iButtonCnt = _RefreshTrayIcons()
		$iErr = @error
		$iExt = @extended
		Select
			Case $iButtonCnt = 0 And $iErr = 0 And $iExt = 0
				ContinueLoop
			Case $iButtonCnt < 1 And $iErr = 183 And $iExt = 183 ;instance already running
				$iErrBuffer = $iErr
				$iExtBuffer = $iExt
				_FileWriteLog(@ScriptDir & "\RefreshTrayIcons.log", "Deleted  " & _
						$iButtonCnt & " orphaned tray notification area icon(s)" & _
						@CRLF & "! Error:    " & $iErrBuffer & " : Extended: " & $iExtBuffer, -1)
				ConsoleWrite("+ " & _Now() & @CRLF & "+ Deleted  " & $iButtonCnt & _
						" orphaned tray notification area icon(s)" & _
						@CRLF & "! Error:    " & $iErrBuffer & " : Extended: " & $iExtBuffer & @CRLF & @CRLF)
			Case $iButtonCnt < 1 And $iErrBuffer = $iErr And $iExtBuffer = $iExt
				ContinueLoop
			Case Else
				$iErrBuffer = $iErr
				$iExtBuffer = $iExt
				_FileWriteLog(@ScriptDir & "\RefreshTrayIcons.log", "Deleted  " & $iButtonCnt & _
						" orphaned tray notification area icon(s)" & _
						@CRLF & "! Error:    " & $iErrBuffer & " : Extended: " & $iExtBuffer, -1)
				ConsoleWrite("+ " & _Now() & @CRLF & "+ Deleted  " & $iButtonCnt & _
						" orphaned tray notification area icon(s)" & _
						@CRLF & "! Error:    " & $iErrBuffer & " : Extended: " & $iExtBuffer & @CRLF & @CRLF)
				;ExitLoop
		EndSelect

	WEnd
	Exit
EndFunc   ;==>_TrayMonitor

;//monitor a process
Func _ProcessMonitor($sProcessname)
	While ProcessExists($sProcessname)
		Sleep(2000)
	WEnd
	Local $iButtonCnt = _RefreshTrayIcons()
	Local $iErr = @error, $iExt = @extended
	ConsoleWrite("+ Deleted  " & $iButtonCnt & _
			" orphaned tray notification area icon(s) for process: " & _
			$sProcessname & @CRLF & "! Error:    " & $iErr & _
			" : Extended: " & $iExt & @CRLF & @CRLF)
	Exit
EndFunc   ;==>_ProcessMonitor


Func _RunTestGUI($iGui = 10)
	Local $aPID[$iGui], $line, $sTemp = EnvGet("TEMP"), $iCnt
	Local $file = FileOpen($sTemp & "\RunTestGUI.au3", 2)
	If $file = -1 Then Return
	$line = 'GuiCreate("Test GUI", 400, 100, -1, -1, -1, 8)' & @CR & 'GuiSetState()' & _
			@CR & 'TraySetIcon(@AutoItExe,-3)' & @CR & 'While 1' & @CR & _
			'If GuiGetMsg() = -3 Then Exit' & @CR & 'WEnd'
	FileWrite($file, $line)
	FileClose($file)
	
	ConsoleWrite(@CRLF & "> Creating test GUI processes" & @CRLF)
	For $i = 0 To $iGui - 1
		$aPID[$i] = Run(@AutoItExe & " /AutoIt3ExecuteScript " & $sTemp & "\RunTestGUI.au3")
		WinWait("Test GUI", "", 2)
		If ProcessExists($aPID[$i]) Then $iCnt += 1
	Next
	
	ConsoleWrite("- Closing  " & $iCnt & " test GUI processes" & @CRLF)
	Sleep(2000)
	WinSetOnTop("Test GUI", "", 1)
	WinSetTitle("Test GUI", "", "ORPHANING TRAY ICONS")
	Sleep(2000)
	$iCnt = 0
	
	For $i = 0 To $iGui - 1
		ProcessClose($aPID[$i])
		ProcessWaitClose($aPID[$i], 2)
		If Not ProcessExists($aPID[$i]) Then $iCnt += 1
	Next
	ConsoleWrite("! Closed   " & $iCnt & " processes - tray icons orphaned" & @CRLF)
	
	For $i = 0 To 10
		Sleep(20)
		FileDelete($sTemp & "\RunTestGUI.au3")
		If Not FileExists($sTemp & "\RunTestGUI.au3") Then ExitLoop
	Next
	Sleep(3000)
EndFunc   ;==>_RunTestGUI

