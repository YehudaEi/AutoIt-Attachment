;////////////////////////////////////////////////////////////////////
;//   Watchdog  - kill not allowed programs
;////////////////////////////////////////////////////////////////////
#NoTrayIcon
HotKeySet("+!b", "Terminate")  ;Shift-Alt-d
;////////////////////////////////////////////////////////////////////
;//   ONLY ONE SESSION AT TIME
;////////////////////////////////////////////////////////////////////
$list = ProcessList(@ScriptName)
for $i = 1 to $list[0][0]
	if $i > 1 Then
		msgbox(0, "Alert!", "Only one instance is allowed : " & @ScriptName, 1)
		ProcessClose($list[$i][1])
	EndIf
next

;//////////////////////////////////////////////////////////////////////
;//      MAIN
;//////////////////////////////////////////////////////////////////////

if FileExists("allowed.ini") then 		;if .ini exists kill other process
	While 1
		XenoKiller()
		sleep(1000)
	WEnd
else
	StoreRunning()						;if .ini NOT exists create file/list 
EndIf




;//////////////////////////////////////////////////////////////////////
;//      FUNCTIONS
;//////////////////////////////////////////////////////////////////////
;//      FIRST RUN create allowed .exe list
;//////////////////////////////////////////////////////////////////////
Func StoreRunning($file = "allowed.ini")
	; List all processes in a File
	local $list = ProcessList()
	
	for $i = 1 to $list[0][0]
		FileWriteLine("allowed.ini", $list[$i][0] & @CRLF)
	next
	msgbox(0, "First Run", "OK, i've created allowed.ini that contains allowed .exe." & @CRLF & "Remember ! SHIFT+Alt+d to quit " & @ScriptName)
EndFunc

;/////////////////////////////////////////////////////////////
;//      KILL process not in list
;/////////////////////////////////////////////////////////////
Func XenoKiller()
	; List all processes
	local $list = ProcessList()

	;/////////////////////////////////////////////////////////////
	;//      FOR to find running .exe in my list
	;/////////////////////////////////////////////////////////////
	for $i = 1 to $list[0][0]
		Local $linenum = 0 						;This is for skip line in filereadline function
		$file = FileOpen("allowed.ini", 0)		;open allowed list
		If $file = -1 Then						; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
		;/////////////////////////////////////////////////////////////
		;//      PROCESS = line read  ?
		;/////////////////////////////////////////////////////////////
		While 1
			$linenum = $linenum + 1																		;add one to skip next line
			$line = FileReadLine($file, $linenum)														;each cicle read next line
			if $list[$i][0] = $line Then ExitLoop   													;if process name is in my list it's safe, exit to next one
			If @error = -1 Then 																		;if EOF , I can't find in my list
				$PID = ProcessExists($list[$i][0]) ; Will return the PID or 0 if the process isn't found.
				If $PID Then ProcessClose($PID)
				ExitLoop																				;and exit to next one
			EndIf
		Wend
		FileClose($file)
	next
EndFunc

Func Terminate()
	ToolTip("ok, quit " & @ScriptName, 0, 0)
	Sleep(2000)
	Beep(500,250)
	Beep(1000,250)
	Beep(500,250)
	Exit 0
EndFunc