;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;                                               ;;;;;
;;;;;  Automated DirectX Report Generation Program  ;;;;;
;;;;;                  Version 2                    ;;;;;
;;;;;                                               ;;;;;
;;;;;        Author:   Matthew Tucker               ;;;;;
;;;;;        Created:  23-DEC-2004                  ;;;;;
;;;;;        Email:    matthewt@cfl.rr.com          ;;;;;
;;;;;                                               ;;;;;
;;;;;       Added ProcessList functionality         ;;;;;
;;;;;              Updated: 08-FEB-05               ;;;;;
;;;;;                                               ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Dim $start = ""
Dim $file = @DesktopDir & "\DxDiag.txt"
While $start=""
	$start = MsgBox(4, "DirectX Diagnostic Report V2", "Do you wish for a DirectX Diagnostic Report to be created for you?", 10)
WEnd
If $start == "6" Then
	;Starts DxDiag Diagnostic Program, and dumps output into file
	RunWait("dxdiag.exe /whql:on /t " & $file, "")
		Do
			Sleep("100")
		Until FileExists($file)

	;Opens file DxDiag report is in, and dumps Process List into file
	$handle = FileOpen($file, 1)
	FileWriteLine($handle, "=================================================")
	FileWriteLine($handle, "Process List")
	FileWriteLine($handle, "=================================================")
	FileWriteLine($handle, "Name		ID")
	$list = ProcessList()
	For $i = 1 to $list[0][0]
		FileWriteLine($handle, $list[$i][0] & "		" & $list[$i][1])
	Next

	;Opens file in GUI, copies all text to clipboard, and closes window
	Run("notepad.exe " & $file)
		WinWaitActive("DxDiag")
		Send("^a")
		Send("^c")
		Send("!{F4}")

	;MsgBox prompting user that file exists, copied to clipboard
	MsgBox(0, "DirectX Diagnostic Report V2", "A DirectX Diagnostic Report has been generated and saved to your Desktop. It has also been copied to your clipboard, please go to the forums, and paste the clipboard contents into the thread (Ctrl+V)", 10)
Else
	MsgBox(0, "DirectX Diagnostic Report V2", "No DirectX Diagnostic Report was created", 10)
EndIf