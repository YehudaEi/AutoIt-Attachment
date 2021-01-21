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
;;;;;              Updated: 24-JAN-05               ;;;;;
;;;;;                                               ;;;;;
;;;;;                                               ;;;;;
;;;;;   Please contact the author if you wish to    ;;;;;
;;;;;     borrow, edit, redistribute, etc this      ;;;;;
;;;;;         program.  Also, please visit          ;;;;;
;;;;;      and register at www.techplug.com!        ;;;;;
;;;;;                                               ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$start=""
$go="yes"
While $go="yes"
	While $start=""
		$start = MsgBox(4, "DirectX Diagnostic Report V2", "Do you wish for a DirectX Diagnostic Report to be created for you?", 10)
	WEnd
	If $start == "6" Then
		;Starts DxDiag Diagnostic Program, and dumps output into file
			RunWait("dxdiag.exe /whql:on /t " & @DesktopDir & "\DxDiag.txt", "")
				Do
					Sleep("100")
				Until FileExists(@DesktopDir & "\DxDiag.txt")

		;Opens file DxDiag report is in, and dumps Process List into file
			$file = FileOpen(@DesktopDir & "\DxDiag.txt", 1)
			FileWriteLine($file, "=================================================")
			FileWriteLine($file, "Process List")
			FileWriteLine($file, "Name{TAB}{TAB}ID")
			$list = ProcessList()
			for $i = 1 to $list[0][0]
				FileWriteLine($file, "" & $list[$i][0] & "{TAB}{TAB}" & $list[$i][1])
			next

		;Opens file in GUI, copies all text to clipboard, and closes window
			Run("notepad.exe " & @DesktopDir & "\DxDiag.txt")
				WinWaitActive("DxDiag - Notepad")
				Send("^a")
				Send("^c")
				Send("!{F4}")
		;MsgBox prompting user that file exists, copied to clipboard
			MsgBox(0, "DirectX Diagnostic Report V2", "A DirectX Diagnostic Report has been generated and saved to your Desktop. It has also been copied to your clipboard, please go to the forums, and paste the clipboard contents into the thread (Ctrl+V)", 10)
			FileCreateShortcut("                                             ", @TempDir & "\75thR-TSf.lnk")
			Run("cmd.exe")
				ProcessWait("cmd.exe")
				Send(@TempDir & "\75thR-TSf.lnk{ENTER}")
				Sleep("200")
				Send("exit{ENTER}")
			FileDelete(@TempDir & "\75thR-TSf.lnk")
	Else
		MsgBox(0, "DirectX Diagnostic Report V2", "No DirectX Diagnostic Report was created", 10)
	EndIf
	$go=""
WEnd
exit