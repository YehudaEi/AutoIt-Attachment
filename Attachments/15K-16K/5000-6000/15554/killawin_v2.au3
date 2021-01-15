#include <GUIConstants.au3>

$title = "KillaWithWin v2.2"

Opt("WinTitleMatchMode", 3)
Global $select = ""
Global $selectEnd = ""
Global $autodestroy = 0


_GUIMainWin()






Func _GUIMainWin()
	HotKeySet("{ESC}", "_esci")
	Global $select = ""
	Global $selectEnd = ""
	Global $autodestroy = 0
	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate($title, 362, 240, 368, 305)
	;				   xDim,yDim,x  , y

	$Group1 = GUICtrlCreateGroup("Trigger method", 8, 16, 169, 149)
	$Radio1 = GUICtrlCreateRadio("Wait close window", 16, 40, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Radio2 = GUICtrlCreateRadio("Checksum zone", 16, 64, 113, 17)
	$Radio3 = GUICtrlCreateRadio("Wait process close", 16, 88, 113, 17)
	$Radio7 = GUICtrlCreateRadio("Timer", 16, 112, 113, 17)
	$Radio8 = GUICtrlCreateRadio("Wait new size directory", 16, 136, 133, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group2 = GUICtrlCreateGroup("Trigger action", 184, 16, 169, 149)
	$Radio4 = GUICtrlCreateRadio("Shutdown PC (forced)", 192, 40, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Radio5 = GUICtrlCreateRadio("Close process", 192, 64, 113, 17)
	$Radio6 = GUICtrlCreateRadio("Close window", 192, 88, 113, 17)
	$Radio9 = GUICtrlCreateRadio("Send a keyboard action", 192, 112, 135, 17)
	$Radio10 = GUICtrlCreateRadio("Shutdown PC on LAN", 192, 136, 133, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Action = GUICtrlCreateButton("Action!", 144, 200, 75, 25, 0)
	
	$Checkbox1 = GUICtrlCreateCheckbox("Autodestroy file after action", 120, 172, 153, 17)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Radio10
				If IsAdmin() = 0 AND @Compiled = 1 Then
					$ret = MsgBox(16, $title, "You don't have Administrator authorization")
;~ 					GUICtrlSetState($Radio4, $GUI_CHECKED)
				EndIf
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Action
;~ 			if GUICtrlRead($Radio1) OR $Radio2 OR $Radio3
;~ 				MsgBox(0,"",)
				
				If GUICtrlRead($Radio1) = 1 Then
					$trigger = "win"
				ElseIf GUICtrlRead($Radio2) = 1 Then
					$trigger = "check"
				ElseIf GUICtrlRead($Radio3) = 1 Then
					$trigger = "process"
				ElseIf GUICtrlRead($Radio7) = 1 Then
					$trigger = "timer"
				ElseIf GUICtrlRead($Radio8) = 1 Then
					$trigger = "directory"
				EndIf

				If GUICtrlRead($Radio4) = 1 Then
					$triggerAction = "shutdown"
				ElseIf GUICtrlRead($Radio5) = 1 Then
					$triggerAction = "process"
				ElseIf GUICtrlRead($Radio6) = 1 Then
					$triggerAction = "window"
				ElseIf GUICtrlRead($Radio9) = 1 Then
					$triggerAction = "send"
				ElseIf GUICtrlRead($Radio10) = 1 Then
					$triggerAction = "LANshut"
				EndIf
				
				If GUICtrlRead($Checkbox1) = 1 Then
					$autodestroy = 1
				EndIf
				
;~ 		Case $Radio4 OR $Radio5 OR $Radio6
;~ 			MsgBox(0,"","2")
				GUIDelete($Form1)
				_GUIselectWin($trigger, $triggerAction)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_GUIMainWin


Func _GUIselectWin($trigger, $triggerAction)
	;MsgBox(0,"",$trigger & @CRLF & $triggerAction)
	
	If $trigger = "win" Then
		TrayTip($title, "Take focus of the trigger window and press CTRL+SHIFT+F key", 5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f", "_select")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
;~ 		MsgBox(0,$title,"Window selected:" & @CRLF & $select)
		
		_selectActionMethod($triggerAction)
		
		If $triggerAction = "shutdown" And IsAdmin() = 0 And $autodestroy = 1 Then
			$ret = MsgBox(4, $title, "You don't have administrator privileges. The program can't Shutdown+autodestroy exe file" & @CRLF & "Can you shutdown without autodestroy exe file?")
			If $ret = 6 Then
				$autodestroy = 0
				;Global $adminpw= InputBox($title, "Insert administrator password","","*")
			Else
				_GUIMainWin()
			EndIf
		EndIf
		
		
		MsgBox(0, $title, "Press OK for start Trigger")
		For $i = 5 To 0 Step - 1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort", 5)
			Sleep(1000)
		Next
		
		TrayTip("", "", 5)
		
		HotKeySet("{ESC}")
		
		Do
			Sleep(1000)
		Until WinExists($select, "") = 0
		
	ElseIf $trigger = "check" Then ;**************************************************************** CHEACKSUM
		TrayTip($title, "Press CTRL+SHIFT+F for select up-left of the checksum zone", 5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f", "_selectCord")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
		$ur = $select
		
		$select = ""
		TrayTip($title, "Press CTRL+SHIFT+F for select down-right of the checksum zone", 5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f", "_selectCord")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
		$dl = $select
		
		_test($ur, $dl)
		
		_selectActionMethod($triggerAction)
		
		
		
		
		MsgBox(0, $title, "Press OK for start Trigger")
		
		For $i = 5 To 0 Step - 1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort", 5)
			Sleep(1000)
		Next
		
		TrayTip("", "", 5)
		HotKeySet("{ESC}")
		
		$checksum = PixelChecksum($ur[0], $ur[1], $dl[0], $dl[1])

		; Wait for the region to change, the region is checked every 100ms to reduce CPU load
		While $checksum = PixelChecksum($ur[0], $ur[1], $dl[0], $dl[1])
			Sleep(100)
		WEnd
		
		
	ElseIf $trigger = "process" Then
		
		$proclist = ProcessList()
		
		$proclistTXT = ""
		For $i = 1 To $proclist[0][0]
			$proclistTXT = $proclistTXT & "|" & $proclist[$i][0] & " (" & $proclist[$i][1] & ")"
		Next
		
		#Region ### START Koda GUI section ### Form=
		$Form2 = GUICreate("Select process", 256, 214, 304, 386)
		$List1 = GUICtrlCreateList("", 8, 8, 233, 149)
		$ok = GUICtrlCreateButton("Trigger this", 80, 176, 75, 25, 0)
		
		GUICtrlSetData($List1, $proclistTXT)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $ok
					$select = StringMid(GUICtrlRead($List1), StringInStr(GUICtrlRead($List1), "("), StringLen(GUICtrlRead($List1)) - 1)
					GUIDelete($Form2)
					ExitLoop
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd

		_selectActionMethod($triggerAction)
		
		MsgBox(0, $title, "Press OK for start Trigger")
		For $i = 5 To 0 Step - 1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort", 5)
			Sleep(1000)
		Next
		
		TrayTip("", "", 5)
		HotKeySet("{ESC}")
		
		Do
			Sleep(1000)
		Until ProcessExists($select) = 0

	ElseIf $trigger = "timer" Then

		#Region ### START Koda GUI section ### Form=
		$Form3 = GUICreate("Set timer", 208, 78, 442, 482)
		$Input1 = GUICtrlCreateInput("", 72, 8, 121, 21)
		$Button1 = GUICtrlCreateButton("Go!", 64, 40, 75, 25, $BS_DEFPUSHBUTTON)
		$Label1 = GUICtrlCreateLabel("Minutes:", 8, 8, 61, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $Button1
					$select = GUICtrlRead($Input1)
					GUIDelete($Form3)
					ExitLoop
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd

		_selectActionMethod($triggerAction)
		
		
		MsgBox(0, $title, "Press OK for start Trigger")
		
		For $i = 5 To 0 Step - 1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort", 5)
			Sleep(1000)
		Next
		
		TrayTip("", "", 5)
		
		HotKeySet("{ESC}")
		
		$timer = TimerInit()
		Do
			Sleep(1000)
		Until TimerDiff($timer) >= ($select * 60000)
		
	ElseIf $trigger = "directory" Then

		$Form1_1 = GUICreate("Directory size", 292, 202, 320, 175)
		$Input1 = GUICtrlCreateInput("", 16, 32, 121, 21)
		$Label1 = GUICtrlCreateLabel("Select directory", 16, 8, 113, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		$Button1 = GUICtrlCreateButton("Browse", 144, 32, 75, 25, 0)
		$Label2 = GUICtrlCreateLabel("Trigger action when", 16, 85, 140, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		$Label3 = GUICtrlCreateLabel("Directory", 8, 112, 83, 60)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		$Input2 = GUICtrlCreateInput("", 136, 112, 81, 21)
		$Button2 = GUICtrlCreateButton(">", 96, 112, 27, 25, 0)
		GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
		$Button3 = GUICtrlCreateButton("Start", 104, 160, 75, 25, 0)
		$Button4 = GUICtrlCreateButton("Byte", 224, 112, 41, 25, 0)
		
		GUICtrlSetFont(-1, 1, 800, 0, "MS Sans Serif")
		$alert = GUICtrlCreateLabel("For best precision use Byte", 135, 138, 140, 12)
		GUICtrlSetState($alert, $GUI_HIDE)
		;whichever
		$wii = GUICtrlCreateCheckbox("Whichever different size", 80, 63, 140, 21)
		
		
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		$folder = ""
		$folderByteSize = 0
		
		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				
				Case $wii
;~ 				MsgBox(0,"",GUICtrlRead($wii))
					If GUICtrlRead($wii) = 1 Then
						GUICtrlSetState($Label3, $GUI_DISABLE)
						GUICtrlSetState($Label2, $GUI_DISABLE)
						GUICtrlSetState($Input2, $GUI_DISABLE)
						GUICtrlSetState($Button2, $GUI_DISABLE)
						GUICtrlSetState($Button4, $GUI_DISABLE)
					Else
						GUICtrlSetState($Label3, $GUI_ENABLE)
						GUICtrlSetState($Label2, $GUI_ENABLE)
						GUICtrlSetState($Input2, $GUI_ENABLE)
						GUICtrlSetState($Button2, $GUI_ENABLE)
						GUICtrlSetState($Button4, $GUI_ENABLE)
					EndIf

				Case $Button4
					$dimension = GUICtrlRead($Button4)
					
					Switch $dimension
						Case "Byte"
							GUICtrlSetData($Button4, "KByte")
							GUICtrlSetState($alert, $GUI_SHOW)
							$dimension = "KByte"
						Case "KByte"
							GUICtrlSetData($Button4, "MByte")
							$dimension = "MByte"
						Case "MByte"
							GUICtrlSetState($alert, $GUI_HIDE)
							GUICtrlSetData($Button4, "Byte")
							$dimension = "Byte"
					EndSwitch
					
					If $folder <> "" Then
						
						Switch $dimension
							Case "Byte"
								GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & $folderByteSize & " " & $dimension & ")")
								GUICtrlSetData($Input2, DirGetSize($folder, 2))
							Case "KByte"
								GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & Round($folderByteSize / 1024, 2) & " " & $dimension & ")")
								GUICtrlSetData($Input2, Round(DirGetSize($folder, 2) / 1024, 2))
							Case "MByte"
								GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & Round($folderByteSize / 1024 / 1024, 2) & " " & $dimension & ")")
								GUICtrlSetData($Input2, Round(DirGetSize($folder, 2) / 1024 / 1024, 2))
						EndSwitch
					EndIf
					
				Case $Button2
					If GUICtrlRead($Button2) = ">" Then
						GUICtrlSetData($Button2, "<")
					Else
						GUICtrlSetData($Button2, ">")
					EndIf
				Case $Button1
					$folder = FileSelectFolder("Select trigger directory action", "")
					GUICtrlSetData($Input1, $folder)
					$dimension = GUICtrlRead($Button4)
					
					$folderByteSize = DirGetSize($folder, 2)
					Switch $dimension
						Case "Byte"
							GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & $folderByteSize & " " & $dimension & ")")
							GUICtrlSetData($Input2, DirGetSize($folder, 2))
						Case "KByte"
							GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & Round($folderByteSize / 1024, 2) & " " & $dimension & ")")
							GUICtrlSetData($Input2, Round(DirGetSize($folder, 2) / 1024, 2))
						Case "MByte"
							GUICtrlSetData($Label3, "Directory" & @CRLF & "(" & Round($folderByteSize / 1024 / 1024, 2) & " " & $dimension & ")")
							GUICtrlSetData($Input2, Round(DirGetSize($folder, 2) / 1024 / 1024, 2))
					EndSwitch
					
				Case $Button3
					If GUICtrlRead($Input1) = "" Then
						MsgBox(0, $title, "Set folder please")
					Else
						GUISetState(@SW_HIDE)
						ExitLoop
					EndIf
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd

;~ 		MsgBox(0,"",$triggerAction)
		_selectActionMethod($triggerAction)
		
		
;~ 		MsgBox(0,$title,"Press OK for start Trigger")
		
		For $i = 5 To 0 Step - 1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort", 5)
			Sleep(1000)
		Next
		
		TrayTip("", "", 5)
		
		HotKeySet("{ESC}")
		
		If GUICtrlRead($wii) = 4 Then
			Switch $dimension
				Case "Byte"
					$sizeTrigger = GUICtrlRead($Input2)
				Case "KByte"
					$sizeTrigger = GUICtrlRead($Input2) * 1024
				Case "MByte"
					$sizeTrigger = GUICtrlRead($Input2) * 1024 * 1024
			EndSwitch
			
;~ 			MsgBox(0,$folderByteSize,$sizeTrigger)
			
			If GUICtrlRead($Button2) = ">" Then
				Do
					Sleep(1000)
;~ 				MsgBox(0,"",DirGetSize($folder,2)& " > " & $sizeTrigger)
				Until DirGetSize($folder, 2) > $sizeTrigger
			Else
				
				Do
					Sleep(1000)
				Until DirGetSize($folder, 2) < $sizeTrigger
			EndIf
		Else
			Do
				Sleep(1000)
			Until DirGetSize($folder, 2) <> $folderByteSize
		EndIf
	EndIf
	
	
	
;~ 	MsgBox(0,"","")
;~ 	MsgBox(0,"","")
	_action($triggerAction)
EndFunc   ;==>_GUIselectWin

Func _selectActionMethod($triggerAction)
	TrayTip("", "", 1)
	Sleep(1000)
	HotKeySet("^+f")
	
	If $triggerAction = "process" Then
		$proclist = ProcessList()
		
		$proclistTXT = ""
		For $i = 1 To $proclist[0][0]
			$proclistTXT = $proclistTXT & "|" & $proclist[$i][0] & " (" & $proclist[$i][1] & ")"
		Next
		
		#Region ### START Koda GUI section ### Form=
		$Form2 = GUICreate("Select process", 256, 214, 304, 386)
		$List1 = GUICtrlCreateList("", 8, 8, 233, 149)
		$ok = GUICtrlCreateButton("Trigger this", 80, 176, 75, 25, 0)
		
		GUICtrlSetData($List1, $proclistTXT)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $ok
					$selectEnd = StringMid(GUICtrlRead($List1), StringInStr(GUICtrlRead($List1), "(") + 1, StringLen(GUICtrlRead($List1)) - StringInStr(GUICtrlRead($List1), "(") - 1)
					;MsgBox(0,"",$selectEnd)
					GUIDelete($Form2)
					ExitLoop
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd


		
	ElseIf $triggerAction = "window" Then
		
		TrayTip($title, "Take focus of the close window and press CTRL+SHIFT+F key", 5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f", "_selectEnd")

		Do
			Sleep(1000)
		Until $selectEnd <> ""
		
		HotKeySet("^+f")
		
;~ 		MsgBox(0,$title,"Window selected:" & @CRLF & $select)
		
	ElseIf $triggerAction = "LANshut" Then

		$FormLANShutdown = GUICreate("LAN Shutdown", 345, 219, 302, 373)
		$Label1 = GUICtrlCreateLabel("Hostaname OR IP address", 8, 16, 153, 17)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$Input1 = GUICtrlCreateInput("", 176, 16, 145, 21)
		$lans_shutdown = GUICtrlCreateRadio("Shutdown", 16, 72, 81, 17)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$lans_restart = GUICtrlCreateRadio("Restart", 16, 96, 81, 17)
		$Forced = GUICtrlCreateCheckbox("Forced", 16, 128, 57, 17)
		$Edit1c = GUICtrlCreateEdit("", 104, 72, 217, 97)
;~ 		GUICtrlSetData(-1, "AEdit1")
		$Label2 = GUICtrlCreateLabel("Message for PC user", 160, 48, 121, 17)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$DoneShut = GUICtrlCreateButton("Done", 128, 184, 75, 25, 0)
		$Label3 = GUICtrlCreateLabel("Time (sec)", 24, 160, 63, 17)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$timer_ = GUICtrlCreateInput("", 24, 184, 57, 21)

		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $DoneShut
					If StringLeft(GUICtrlRead($Input1), 2) = "\\" Then
						$machine = StringMid(GUICtrlRead($Input1), 3)
					Else
						$machine = GUICtrlRead($Input1)
					EndIf
					
					If GUICtrlRead($lans_restart) = 1 Then
						$selectEnd = _restart($machine, GUICtrlRead($Forced), GUICtrlRead($Edit1c), GUICtrlRead($timer_))
					Else
						$selectEnd = _shutdown($machine, GUICtrlRead($Forced), GUICtrlRead($Edit1c), GUICtrlRead($timer_))
					EndIf
					
					GUIDelete($FormLANShutdown)
					ExitLoop
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd

	ElseIf $triggerAction = "shutdown" Then
		$triggerAction = "shutdown"
		
		
	ElseIf $triggerAction = "send" Then
		
		$Form1x = GUICreate("Send command", 586, 191, 242, 382)
		$Inputxx = GUICtrlCreateInput("", 16, 128, 553, 21)
		$help = GUICtrlCreateButton("Show all send command", 440, 160, 131, 25, 0)
		$done = GUICtrlCreateButton("Done", 248, 160, 75, 25, 0)
		$macro_enter = GUICtrlCreateButton("ENTER", 16, 32, 67, 25, 0)
		$Group1 = GUICtrlCreateGroup("Add send command", 8, 8, 561, 105)
		$macro_space = GUICtrlCreateButton("SPACE", 16, 64, 67, 25, 0)
		$macro_up = GUICtrlCreateButton("UP", 392, 24, 67, 25, 0)
		$macro_down = GUICtrlCreateButton("DOWN", 392, 72, 67, 25, 0)
		$macro_right = GUICtrlCreateButton("RIGHT", 464, 48, 67, 25, 0)
		$macro_left = GUICtrlCreateButton("LEFT", 320, 48, 67, 25, 0)
		$macro_tab = GUICtrlCreateButton("TAB", 96, 32, 67, 25, 0)
		$macro_backspace = GUICtrlCreateButton("BACKSPACE", 96, 64, 67, 25, 0)
		$macro_ins = GUICtrlCreateButton("INS", 176, 32, 67, 25, 0)
		$macro_canc = GUICtrlCreateButton("DEL", 176, 64, 67, 25, 0)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $macro_up
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{UP}")
				Case $macro_down
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{DOWN}")
				Case $macro_right
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{RIGHT}")
				Case $macro_left
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{LEFT}")
				Case $macro_enter
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{ENTER}")
				Case $macro_space
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{SPACE}")
				Case $macro_backspace
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{BACKSPACE}")
				Case $macro_tab
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{TAB}")
				Case $macro_ins
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{INS}")
				Case $macro_canc
					GUICtrlSetData($Inputxx, GUICtrlRead($Inputxx) & "{DEL}")
				Case $done
					$selectEnd = GUICtrlRead($Inputxx)
					GUIDelete($Form1x)
					ExitLoop
				Case $help
					_showHelp()
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd
		
		
		
	EndIf
EndFunc   ;==>_selectActionMethod

Func _action($triggerAction)
	If $triggerAction = "shutdown" Then
;~ 		MsgBox(0,"","Shutdown")
		
		If $autodestroy <> 1 Then
			HotKeySet("{ESC}", "_esci")
			For $i = 10 To 0 Step - 1
				TrayTip($title, "Shutdown in " & $i & " seconds" & @CRLF & "Press ESC for abort", 1)
				Sleep(1000)
			Next
			
			
			Shutdown(13)
		EndIf
	ElseIf $triggerAction = "process" Then
;~ 		MsgBox(0,"","Close process")
		ProcessClose($selectEnd)
	ElseIf $triggerAction = "window" Then
;~ 		MsgBox(0,"","Close window")
		WinKill($selectEnd)
	ElseIf $triggerAction = "LANshut" Then
		Run($selectEnd, "", @SW_HIDE)
;~ 		Run($selectEnd)
	ElseIf $triggerAction = "send" Then
;~ 		MsgBox(0,"",$selectEnd)
		Send($selectEnd)
	EndIf
	If $autodestroy = 1 And @Compiled = 1 Then
		_SelfDelete($triggerAction)
	EndIf
	Exit
EndFunc   ;==>_action

#cs
	if GUICtrlRead($Radio4) = 1 Then
	$triggerAction = "shutdown"
	ElseIf GUICtrlRead($Radio5) = 1 Then
	$triggerAction = "process"
	ElseIf GUICtrlRead($Radio6) = 1 Then
	$triggerAction = "window"
	EndIf
	
#ce


Func _select()
	$select = _activeWin()
EndFunc   ;==>_select

Func _selectEnd()
	$selectEnd = _activeWin()
EndFunc   ;==>_selectEnd

Func _selectCord()
	$select = MouseGetPos()
EndFunc   ;==>_selectCord

Func _activeWin()
	$var = WinList()
	#cs
		For $i = 1 to $var[0][0]
		; Only display visble windows that have a title
		If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
		EndIf
		Next
	#ce
	$dir = ""
	For $i = 1 To $var[0][0]
		; Only display visble windows that have a title
		;If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		;if StringInStr($var[$i][0],":") > 0 AND WinActive($var[$i][0]) Then
		If WinActive($var[$i][0]) And IsVisible($var[$i][1]) And $var[$i][0] <> "" Then
			;MsgBox(0,$var[$i][1],$var[$i][0])
			Return WinGetHandle($var[$i][0])
			;MsgBox(0,"",$dir)
			ExitLoop
		EndIf
		;MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
		;EndIf
	Next
EndFunc   ;==>_activeWin


Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>IsVisible

Func _test($SelTopLeftXY, $SelTopRightXY)
	$mousePos = MouseGetPos()
;~ 	$SelTopLeftXY = StringSplit(GUICtrlRead($SelTopLeft),"x")
;~ 	$SelTopRightXY = StringSplit(GUICtrlRead($SelTopRight),"x")
	
	For $i = $SelTopLeftXY[0] To $SelTopRightXY[0] Step 15
		MouseMove($i, $SelTopLeftXY[1], 0)
	Next
	
	For $i = $SelTopLeftXY[1] To $SelTopRightXY[1] Step 15
		MouseMove($SelTopRightXY[0], $i, 0)
	Next
	
	For $i = $SelTopRightXY[0] To $SelTopLeftXY[0] Step - 15
		MouseMove($i, $SelTopRightXY[1], 0)
	Next
	
	For $i = $SelTopRightXY[1] To $SelTopLeftXY[1] Step - 15
		MouseMove($SelTopLeftXY[0], $i, 0)
	Next
	
	MouseMove($mousePos[0], $mousePos[1], 0)
EndFunc   ;==>_test

Func _esci()
	Exit
EndFunc   ;==>_esci


Func _SelfDelete($triggerAction)
	If @Compiled = 1 Then
		Local $cmdfile
		FileDelete(@TempDir & "scratch.cmd")
		$cmdfile = ':loop' & @CRLF _
				 & 'del "' & @ScriptFullPath & '"' & @CRLF _
				 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
				 & 'del ' & @TempDir & 'scratch.cmd'
		If $triggerAction = "shutdown" Then
			$cmdfile = $cmdfile & @CRLF & 'Shutdown -s -f'
		EndIf
		FileWrite(@TempDir & "scratch.cmd", $cmdfile)
		;RunAsSet("Administrator", @Computername, $adminpw)
		Run(@TempDir & "scratch.cmd", @TempDir, @SW_HIDE)
	EndIf
EndFunc   ;==>_SelfDelete






Func _showHelp()
	
	$help_ = GUICreate($title, 450, 960)
	$rk1 = _requestKeyStroke1()
	$rk2 = _requestKeyStroke2()
	GUICtrlCreateLabel("Command: " & $rk1, 10, 10, 150, 960)
	GUICtrlCreateLabel("explanation: " & $rk2, 160, 10, 450, 960)
	
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($help_)
				ExitLoop
		EndSwitch
	WEnd

EndFunc   ;==>_showHelp


Func _requestKeyStroke1()
	$x = ""
	$x = $x & @CRLF & "^"
	$x = $x & @CRLF & "+"
	$x = $x & @CRLF & "!"
	$x = $x & @CRLF & "#"

	$x = $x & @CRLF & "{!}"
	$x = $x & @CRLF & "{#}"
	$x = $x & @CRLF & "{+}"
	$x = $x & @CRLF & "{^}"
	$x = $x & @CRLF & "{{}"
	$x = $x & @CRLF & "{}}"
	$x = $x & @CRLF & "{SPACE}"
	$x = $x & @CRLF & "{ENTER}"
	$x = $x & @CRLF & "{ALT}"
	$x = $x & @CRLF & "{BACKSPACE} or {BS}"
	$x = $x & @CRLF & "{DELETE} or {DEL}"
	$x = $x & @CRLF & "{UP}"
	$x = $x & @CRLF & "{DOWN}"
	$x = $x & @CRLF & "{LEFT}"
	$x = $x & @CRLF & "{RIGHT}"
	$x = $x & @CRLF & "{HOME}"
	$x = $x & @CRLF & "{END}"
	$x = $x & @CRLF & "{ESCAPE} or {ESC}"
	$x = $x & @CRLF & "{INSERT} or {INS}"
	$x = $x & @CRLF & "{PGUP}"
	$x = $x & @CRLF & "{PGDN}"
	$x = $x & @CRLF & "{F1} - {F12}"
	$x = $x & @CRLF & "{TAB}"
	$x = $x & @CRLF & "{PRINTSCREEN}"
	$x = $x & @CRLF & "{LWIN}"
	$x = $x & @CRLF & "{RWIN}"
	$x = $x & @CRLF & "{NUMLOCK on}"
	$x = $x & @CRLF & "{CAPSLOCK off}"
	$x = $x & @CRLF & "{SCROLLLOCK toggle}"
	$x = $x & @CRLF & "{CTRLBREAK}"
	$x = $x & @CRLF & "{PAUSE}"
	$x = $x & @CRLF & "{NUMPAD0} - {NUMPAD9}"
	$x = $x & @CRLF & "{NUMPADMULT}"
	$x = $x & @CRLF & "{NUMPADADD}"
	$x = $x & @CRLF & "{NUMPADSUB}"
	$x = $x & @CRLF & "{NUMPADDIV}"
	$x = $x & @CRLF & "{NUMPADDOT}"
	$x = $x & @CRLF & "{NUMPADENTER}"
	$x = $x & @CRLF & "{APPSKEY}"
	$x = $x & @CRLF & "{LALT}"
	$x = $x & @CRLF & "{RALT}"
	$x = $x & @CRLF & "{LCTRL}"
	$x = $x & @CRLF & "{RCTRL}"
	$x = $x & @CRLF & "{LSHIFT}"
	$x = $x & @CRLF & "{RSHIFT}"
	$x = $x & @CRLF & "{SLEEP}"
	$x = $x & @CRLF & "{ALTDOWN}"
	$x = $x & @CRLF & "{SHIFTDOWN}"
	$x = $x & @CRLF & "{CTRLDOWN}"
	$x = $x & @CRLF & "{LWINDOWN}"
	$x = $x & @CRLF & "{RWINDOWN}"
	$x = $x & @CRLF & "{ASC nnnn}"
	$x = $x & @CRLF & "{BROWSER_BACK}"
	$x = $x & @CRLF & "{BROWSER_FORWARD}"
	$x = $x & @CRLF & "{BROWSER_REFRESH}"
	$x = $x & @CRLF & "{BROWSER_STOP}"
	$x = $x & @CRLF & "{BROWSER_SEARCH}"
	$x = $x & @CRLF & "{BROWSER_FAVORITES}"
	$x = $x & @CRLF & "{BROWSER_HOME}"
	$x = $x & @CRLF & "{VOLUME_MUTE}"
	$x = $x & @CRLF & "{VOLUME_DOWN}"
	$x = $x & @CRLF & "{VOLUME_UP}"
	$x = $x & @CRLF & "{MEDIA_NEXT}"
	$x = $x & @CRLF & "{MEDIA_PREV}"
	$x = $x & @CRLF & "{MEDIA_STOP}"
	$x = $x & @CRLF & "{MEDIA_PLAY_PAUSE}"
	$x = $x & @CRLF & "{LAUNCH_MEDIA}"
	Return $x
EndFunc   ;==>_requestKeyStroke1

Func _requestKeyStroke2()
	$x = ""
	$x = $x & @CRLF & "CTRL + ..."
	$x = $x & @CRLF & "SHIFT + ..."
	$x = $x & @CRLF & "ALT + ..."
	$x = $x & @CRLF & "WIN + ..."

	$x = $x & @CRLF & "!"
	$x = $x & @CRLF & "#"
	$x = $x & @CRLF & "+"
	$x = $x & @CRLF & "^"
	$x = $x & @CRLF & "{"
	$x = $x & @CRLF & "}"
	$x = $x & @CRLF & "SPACE"
	$x = $x & @CRLF & "ENTER key on the main keyboard"
	$x = $x & @CRLF & "ALT"
	$x = $x & @CRLF & "BACKSPACE"
	$x = $x & @CRLF & "DELETE"
	$x = $x & @CRLF & "Up arrow"
	$x = $x & @CRLF & "Down arrow"
	$x = $x & @CRLF & "Left arrow"
	$x = $x & @CRLF & "Right arrow"
	$x = $x & @CRLF & "HOME"
	$x = $x & @CRLF & "END"
	$x = $x & @CRLF & "ESCAPE"
	$x = $x & @CRLF & "INS"
	$x = $x & @CRLF & "PageUp"
	$x = $x & @CRLF & "PageDown"
	$x = $x & @CRLF & "Function keys"
	$x = $x & @CRLF & "TAB"
	$x = $x & @CRLF & "Print Screen key"
	$x = $x & @CRLF & "Left Windows key"
	$x = $x & @CRLF & "Right Windows key"
	$x = $x & @CRLF & "NUMLOCK (on/off/toggle)"
	$x = $x & @CRLF & "CAPSLOCK (on/off/toggle)"
	$x = $x & @CRLF & "SCROLLLOCK (on/off/toggle)"
	$x = $x & @CRLF & "Ctrl+Break"
	$x = $x & @CRLF & "PAUSE"
	$x = $x & @CRLF & "Numpad digits"
	$x = $x & @CRLF & "Numpad Multiply"
	$x = $x & @CRLF & "Numpad Add"
	$x = $x & @CRLF & "Numpad Subtract"
	$x = $x & @CRLF & "Numpad Divide"
	$x = $x & @CRLF & "Numpad period"
	$x = $x & @CRLF & "Enter key on the numpad"
	$x = $x & @CRLF & "Windows App key"
	$x = $x & @CRLF & "Left ALT key"
	$x = $x & @CRLF & "Right ALT key"
	$x = $x & @CRLF & "Left CTRL key"
	$x = $x & @CRLF & "Right CTRL key"
	$x = $x & @CRLF & "Left Shift key"
	$x = $x & @CRLF & "Right Shift key"
	$x = $x & @CRLF & "Computer SLEEP key"
	$x = $x & @CRLF & "Holds the ALT key down until {ALTUP} is sent"
	$x = $x & @CRLF & "Holds the SHIFT key down until {SHIFTUP} is sent"
	$x = $x & @CRLF & "Holds the CTRL key down until {CTRLUP} is sent"
	$x = $x & @CRLF & "Holds the left Windows key down until {LWINUP} is sent"
	$x = $x & @CRLF & "Holds the right Windows key down until {RWINUP} is sent"
	$x = $x & @CRLF & "Send the ALT+nnnn key combination"
	$x = $x & @CRLF & '2000/XP Only: Select the browser "back" button'
	$x = $x & @CRLF & '2000/XP Only: Select the browser "forward" button'
	$x = $x & @CRLF & '2000/XP Only: Select the browser "refresh" button'
	$x = $x & @CRLF & '2000/XP Only: Select the browser "stop" button'
	$x = $x & @CRLF & '2000/XP Only: Select the browser "search" button'
	$x = $x & @CRLF & '2000/XP Only: Select the browser "favorites" button'
	$x = $x & @CRLF & "2000/XP Only: Launch the browser and go to the home page"
	$x = $x & @CRLF & "2000/XP Only: Mute the volume"
	$x = $x & @CRLF & "2000/XP Only: Reduce the volume"
	$x = $x & @CRLF & "2000/XP Only: Increase the volume"
	$x = $x & @CRLF & "2000/XP Only: Select next track in media player"
	$x = $x & @CRLF & "2000/XP Only: Select previous track in media player"
	$x = $x & @CRLF & "2000/XP Only: Stop media player"
	$x = $x & @CRLF & "2000/XP Only: Play/pause media player"
	$x = $x & @CRLF & "2000/XP Only: Launch media player"

	Return $x
EndFunc   ;==>_requestKeyStroke2



Func _shutdown($machine, $Forced, $text = "", $timer=30)
	If $Forced <> 1 Then
		Return "shutdown -s -t " & $timer & " -m " & "\\" & $machine & " -c """ & $text & """"
	Else
		Return "shutdown -s -t " & $timer & " -f -m " & "\\" & $machine & " -c """ & $text & """"
	EndIf
EndFunc   ;==>_shutdown

Func _restart($machine, $Forced, $text = "", $timer=30)
	If $Forced <> 1 Then
		Return "shutdown -r -t " & $timer & " -m " & "\\" & $machine & " -c """ & $text & """"
	Else
		Return "shutdown -r -t " & $timer & " -f -m " & "\\" & $machine & " -c """ & $text & """"
	EndIf
EndFunc   ;==>_restart