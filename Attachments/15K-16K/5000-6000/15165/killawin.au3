#include <GUIConstants.au3>

$title = "KillaWithWin 0.1"

Opt("WinTitleMatchMode", 3) 
Global $select= ""
Global $selectEnd= ""
Global $autodestroy = 0
HotKeySet("{ESC}","_esci")

_GUIMainWin()




Func _GUIMainWin()
	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("KillaWithWin v0.1", 362, 201, 368, 305)

	$Group1 = GUICtrlCreateGroup("Trigger method", 8, 16, 161, 129)
	$Radio1 = GUICtrlCreateRadio("Wait close window", 16, 40, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Radio2 = GUICtrlCreateRadio("Checksum zone", 16, 64, 113, 17)
	$Radio3 = GUICtrlCreateRadio("Wait process close", 16, 88, 113, 17)
	$Radio7 = GUICtrlCreateRadio("Timer", 16, 112, 113, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group2 = GUICtrlCreateGroup("Trigger action", 184, 16, 169, 105)
	$Radio4 = GUICtrlCreateRadio("Shutdown PC (forced)", 192, 40, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Radio5 = GUICtrlCreateRadio("Close process", 192, 64, 113, 17)
	$Radio6 = GUICtrlCreateRadio("Close window", 192, 88, 113, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Action = GUICtrlCreateButton("Action!", 144, 175, 75, 25, 0)
	
	$Checkbox1 = GUICtrlCreateCheckbox("Autodestroy file after action", 120, 152, 153, 17)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Action
	;~ 			if GUICtrlRead($Radio1) OR $Radio2 OR $Radio3
;~ 				MsgBox(0,"",)
				
				if GUICtrlRead($Radio1) = 1 Then
					$trigger = "win"
				ElseIf GUICtrlRead($Radio2) = 1 Then
					$trigger = "check"
				ElseIf GUICtrlRead($Radio3) = 1 Then
					$trigger = "process"
				ElseIf GUICtrlRead($Radio7) = 1 Then
					$trigger = "timer"
				EndIf

				if GUICtrlRead($Radio4) = 1 Then
					$triggerAction = "shutdown"
				ElseIf GUICtrlRead($Radio5) = 1 Then
					$triggerAction = "process"
				ElseIf GUICtrlRead($Radio6) = 1 Then
					$triggerAction = "window"
				EndIf
				
				if GUICtrlRead($Checkbox1) = 1 Then
					$autodestroy = 1
				EndIf
				
	;~ 		Case $Radio4 OR $Radio5 OR $Radio6	
	;~ 			MsgBox(0,"","2")
			GUIDelete($Form1)
			_GUIselectWin($trigger, $triggerAction)
			ExitLoop
		EndSwitch
	WEnd
EndFunc


Func _GUIselectWin($trigger, $triggerAction)
	;MsgBox(0,"",$trigger & @CRLF & $triggerAction)
	
	if $trigger = "win" Then
		TrayTip($title, "Take focus of the trigger window and press CTRL+SHIFT+F key",5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f","_select")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
;~ 		MsgBox(0,$title,"Window selected:" & @CRLF & $select)
		
		_selectActionMethod($triggerAction)
		
		MsgBox(0,$title,"Press OK for start Trigger")
		For $i=5 to 0 Step -1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort",5)
			Sleep(1000)
		Next
		
		TrayTip("", "",5)
		
		do
			Sleep(1000)
		Until WinExists($select,"") = 0
		
	ElseIf $trigger = "check" Then ;**************************************************************** CHEACKSUM
		TrayTip($title, "Press CTRL+SHIFT+F for select up-left of the checksum zone",5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f","_selectCord")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
		$ur = $select
		
		$select= ""
		TrayTip($title, "Press CTRL+SHIFT+F for select down-right of the checksum zone",5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f","_selectCord")

		Do
			Sleep(1000)
		Until $select <> ""
		
		HotKeySet("^+f")
		
		$dl= $select
		
		_test($ur, $dl)
		
		_selectActionMethod($triggerAction)
		
		
		MsgBox(0,$title,"Press OK for start Trigger")
		
		For $i=5 to 0 Step -1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort",5)
			Sleep(1000)
		Next
		
		TrayTip("", "",5)
		
		$checksum = PixelChecksum($ur[0],$ur[1], $dl[0], $dl[1])

		; Wait for the region to change, the region is checked every 100ms to reduce CPU load
		While $checksum = PixelChecksum($ur[0],$ur[1], $dl[0], $dl[1])
		  Sleep(100)
		WEnd
		
		
	ElseIf $trigger = "process" Then
		
		$proclist = ProcessList()
		
		$proclistTXT = ""
		for $i=1 to $proclist[0][0]
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
					$select = StringMid(GUICtrlRead($List1), StringInStr(GUICtrlRead($List1), "("), StringLen(GUICtrlRead($List1))-1)
					GUIDelete($Form2)
					ExitLoop
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd

		_selectActionMethod($triggerAction)
		MsgBox(0,$title,"Press OK for start Trigger")
		For $i=5 to 0 Step -1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort",5)
			Sleep(1000)
		Next
		
		TrayTip("", "",5)
		
		
		do
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
		MsgBox(0,$title,"Press OK for start Trigger")
		
		For $i=5 to 0 Step -1
			TrayTip($title, "Trigger active in " & $i & " seconds" & @CRLF & "Press ESC for abort",5)
			Sleep(1000)
		Next
		
		TrayTip("", "",5)
		$timer= TimerInit()		
		do
			Sleep(1000)
		Until TimerDiff($timer) >= ($select * 60000)
	EndIf
	
;~ 	MsgBox(0,"","")
;~ 	MsgBox(0,"","")
	_action($triggerAction)
EndFunc

Func _selectActionMethod($triggerAction)
	TrayTip("", "",1)
	Sleep(1000)
	HotKeySet("^+f")
	
	if $triggerAction = "process" Then
		$proclist = ProcessList()
		
		$proclistTXT = ""
		for $i=1 to $proclist[0][0]
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
					$selectEnd= StringMid(GUICtrlRead($List1), StringInStr(GUICtrlRead($List1), "(")+1, StringLen(GUICtrlRead($List1))-StringInStr(GUICtrlRead($List1), "(")-1)
					;MsgBox(0,"",$selectEnd)
					GUIDelete($Form2)
					ExitLoop
					
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd


	
	ElseIf $triggerAction = "window" Then
		
		TrayTip($title, "Take focus of the close window and press CTRL+SHIFT+F key",5)
;~ 		HotKeySet("{LCTRL}","_select")
;~ 		HotKeySet("x","_select")
		HotKeySet("^+f","_selectEnd")

		Do
			Sleep(1000)
		Until $selectEnd <> ""
		
		HotKeySet("^+f")
		
;~ 		MsgBox(0,$title,"Window selected:" & @CRLF & $select)
		
		
	ElseIf $triggerAction = "shutdown" Then
		$triggerAction= "shutdown"
	EndIf
EndFunc

Func _action($triggerAction)
	if $triggerAction = "shutdown" Then
;~ 		MsgBox(0,"","Shutdown")
		Shutdown(13)
	ElseIf $triggerAction = "process" Then
;~ 		MsgBox(0,"","Close process")
		ProcessClose($selectEnd)
	ElseIf $triggerAction = "window" Then
;~ 		MsgBox(0,"","Close window")
		WinClose($selectEnd)
	EndIf
	if $autodestroy = 1 AND @Compiled = 1 Then
		_SelfDelete()
	EndIf
	Exit
EndFunc

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
	$select= _activeWin()
EndFunc

Func _selectEnd()
	$selectEnd= _activeWin()
EndFunc

Func _selectCord()
	$select= MouseGetPos()
EndFunc

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
$dir=""
	For $i = 1 to $var[0][0]
	  ; Only display visble windows that have a title
	  ;If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		;if StringInStr($var[$i][0],":") > 0 AND WinActive($var[$i][0]) Then
		if WinActive($var[$i][0]) AND IsVisible($var[$i][1]) AND $var[$i][0] <> "" Then
			;MsgBox(0,$var[$i][1],$var[$i][0])
			Return WinGetHandle($var[$i][0])
			;MsgBox(0,"",$dir)
			ExitLoop
		EndIf
		;MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
	  ;EndIf
	Next
EndFunc


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc

Func _test($SelTopLeftXY, $SelTopRightXY)
	$mousePos = MouseGetPos()
;~ 	$SelTopLeftXY = StringSplit(GUICtrlRead($SelTopLeft),"x")
;~ 	$SelTopRightXY = StringSplit(GUICtrlRead($SelTopRight),"x")
				
	For $i = $SelTopLeftXY[0] to $SelTopRightXY[0] Step 15
		MouseMove($i,$SelTopLeftXY[1],0)				
	Next
	
	For $i = $SelTopLeftXY[1] to $SelTopRightXY[1] Step 15
		MouseMove($SelTopRightXY[0],$i,0)				
	Next
	
	For $i = $SelTopRightXY[0] to $SelTopLeftXY[0] Step -15
		MouseMove($i,$SelTopRightXY[1],0)				
	Next
	
	For $i = $SelTopRightXY[1] to $SelTopLeftXY[1] Step -15
		MouseMove($SelTopLeftXY[0],$i,0)				
	Next
	
	MouseMove($mousePos[0],$mousePos[1],0)
EndFunc

Func _esci()
	Exit
EndFunc

	
Func _SelfDelete()
	if @Compiled = 1 Then
		Local $cmdfile
		FileDelete(@TempDir & "scratch.cmd")
		$cmdfile = ':loop' & @CRLF _
				& 'del "' & @ScriptFullPath & '"' & @CRLF _
				& 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
				& 'del ' & @TempDir & 'scratch.cmd'
		FileWrite(@TempDir & "scratch.cmd", $cmdfile)
		Run(@TempDir & "scratch.cmd", @TempDir, @SW_HIDE)
	EndIf
EndFunc
 