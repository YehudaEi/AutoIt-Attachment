; requires
;#include <File.au3>
;#include <INet.au3>

If $CmdLine[0] >= 1 Then
	If $CmdLine[1] = "MultiThread" Then
		$filename = StringTrimLeft($CmdLine[3], StringInStr($CmdLine[3], "/", 0, -1))
		If StringRight($filename, 4) <> "html" And StringRight($filename, 4) <> ".htm" And StringRight($filename, 4) <> ".php" Then
			$filename &= ".html"
		EndIf
		InetGet($CmdLine[3], $filename, 1, 0)
		IniWrite(@ScriptDir & "\MultiThread.ini", "Section", "Thread" & $CmdLine[2], "0")
		Exit
	EndIf
EndIf

; function (array [containing urls], number [of threads to use])
; array element [0] is ignored
Func _InetGet_MultiThread(ByRef $inGMT_arr, $inGMT_threads)
	Global $Thread_Control[$inGMT_threads+1]
	Dim $inGMT_arr_UB = UBound($inGMT_arr)
	Dim $inGMT_Progress = 0
	If FileExists(@ScriptDir & "\MultiThread.ini") = 0 Then
		$InGMT_i = 1
		For $InGMT_i = 1 To $inGMT_threads
			IniWrite(@ScriptDir & "\MultiThread.ini", "Section", "Thread" & $InGMT_i, "0")
		Next
	EndIf
	While 1
		$InGMT_i = 1
		For $InGMT_i = 1 To $inGMT_threads
			$Thread_Control[$InGMT_i] = IniRead(@ScriptDir & "\MultiThread.ini", "Section", "Thread" & $InGMT_i, "")
		Next
		If $inGMT_Progress < $inGMT_arr_UB -1 Then
			$InGMT_i = 1
			For $InGMT_i = 1 To $inGMT_threads
				If $Thread_Control[$InGMT_i] = 0 Then
					$inGMT_Progress += 1
					ShellExecute(@ScriptName, "MultiThread" & " " & $InGMT_i & " " & $inGMT_arr[$inGMT_Progress], "", "Run")
					IniWrite(@ScriptDir & "\MultiThread.ini", "Section", "Thread" & $InGMT_i, "1")
				EndIf
				If $inGMT_Progress = $inGMT_arr_UB -1 Then
					ExitLoop
				EndIf
			Next
		Else
			$finished = 0
			$InGMT_i = 1
			For $InGMT_i = 1 To $inGMT_threads
				$finished += $Thread_Control[$InGMT_i]
			Next
			If $finished = 0 Then
				ExitLoop
			EndIf
		EndIf
	WEnd
	FileDelete(@ScriptDir & "\MultiThread.ini")
	MsgBox(0, "", "multi pass!", 1)
	Return 1
EndFunc

