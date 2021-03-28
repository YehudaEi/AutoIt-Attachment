 #Include <FileConstants.au3>
 #include <MsgBoxConstants.au3>

HotkeySet("!^a", "UntitledSaveAndRun")
HotkeySet("!^q", "_Exit")
While 1
   Sleep(200)
WEnd
Func _Exit()
   Exit
EndFunc


Func UntitledSaveAndRun()
   $PathToFile = "C:\Program Files\AutoIt3\Examples\NFldr\"
   $FileName = "_Mind_Checking_In_"
   $iMin = 10
   $iMax = 19

   if WinActive("[Title:(Untitled) * SciTE-Lite]") Then
	  For $i = $iMin to $iMax Step 0
		 $i += 1
		 If $i > $iMax Then
			MsgBox(0, "Just for the info", "The maximum value has been exceeded."&@lf&"Try tyding up a bit or just increase $iMax"&@lf&"...if you wish so.")
			$i -= 1
			ExitLoop
		 EndIf

		 $CompleateFileName = $FileName & $i & ".au3"
		 ;Находит первый пустой после уже существующего и пишет в него
		 If Not FileExists($PathToFile & $CompleateFileName) Then
			$hSaveFile = FileOpen($PathToFile & $CompleateFileName, 2)
			$TempTemp = ClipGet()

			Send("^a^c")

			FileWrite($PathToFile & $CompleateFileName, ClipGet())
			ClipPut($TempTemp)
			FileClose($hSaveFile)

			Send("^w")
			WinWaitActive("[Class:#32770]")
			Send("{RIGHT}{Space}")

			ShellExecute($PathToFile & $CompleateFileName,"","","Edit")
			ExitLoop
		 EndIf
	  Next
   EndIf
   WinWaitActive($PathToFile & $CompleateFileName)

   Send("{f5}")

EndFunc