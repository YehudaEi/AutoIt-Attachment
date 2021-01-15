#include <GUIConstants.au3>

$title = "LANShutdown v0.1"


$var = IniReadSection("lanshutdown.ini", "computer")
If @error Then
	MsgBox(4096, "", "Error occurred, probably no INI file.")
Else
	Global $pc[$var[0][0] + 1][12]
	Global $refresh = 1
	Global $start = 20
	For $i = 0 To $var[0][0]
		$pc[$i][0] = $var[$i][0]
		$pc[$i][1] = $var[$i][1]
		;MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF & "Value: " & $var[$i][1])
	Next
EndIf

_GUImainWin()



Func _GUImainWin()
	
	;	$Form1 = GUICreate("AForm1", 282, 152, 308, 226)
	;MsgBox(0,"",$pc[0][0])
	$Form1 = GUICreate("ShutdownLAN", 282, ($pc[0][0] * 32) + 100, 308, 226)
;~ 	$Label1 = GUICtrlCreateLabel("off", 8, 40, 21, 20)
;~ 	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;~ 	GUICtrlSetColor(-1, 0x008000)
;~ 	$Label2 = GUICtrlCreateLabel("on", 8, 72, 21, 20)
;~ 	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;~ 	GUICtrlSetColor(-1, 0xFF0000)
	
	For $i = 1 To $pc[0][0]
		
		$pc[$i][11] = GUICtrlCreateLabel($pc[$i][1], 8, $i * 32 + $start, 85, 20)
		If _isOnline($pc[$i][0]) > 0 Then
			GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
			GUICtrlSetColor(-1, 0x008000)
			$pc[$i][4] = $GUI_ENABLE
			$pc[$i][6] = $GUI_ENABLE
			$pc[$i][8] = $GUI_ENABLE
		Else
			GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
			GUICtrlSetColor(-1, 0xFF0000)
			$pc[$i][4] = $GUI_DISABLE
			$pc[$i][6] = $GUI_DISABLE
			$pc[$i][8] = $GUI_DISABLE
		EndIf
		
		$pc[$i][3] = GUICtrlCreateButton("Shutdown", 96, $i * 32 + $start, 51, 17, 0)
;~ 		$pc[$i][4] = $GUI_SHOW
		$pc[$i][5] = GUICtrlCreateButton("Restart", 152, $i * 32 + $start, 57, 17, 0)
;~ 		$pc[$i][6] = $GUI_SHOW
		$pc[$i][7] = GUICtrlCreateCheckbox("Force", 224, $i * 32 + $start, 49, 17)
;~ 		$pc[$i][8] = $GUI_SHOW
		$pc[$i][9] = GUICtrlCreateButton("Stop shutdown", 96, $i * 32 + $start, 150, 17, 0)
		$pc[$i][10] = $GUI_HIDE
	Next
	;GUICtrlSetState("",$GUI_DISABLE)
	;GUICtrlSetState("",$GUI_HIDE)
	
	;$Button2 = GUICtrlCreateButton("Spegni tutti", 88, ($pc[0][0] * 32) + 70, 105, 17, 0)
	
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		If $refresh = 1 Then
			For $i = 1 To $pc[0][0]
				GUICtrlSetState($pc[$i][3], $pc[$i][4])
				GUICtrlSetState($pc[$i][5], $pc[$i][6])
				GUICtrlSetState($pc[$i][7], $pc[$i][8])
				GUICtrlSetState($pc[$i][9], $pc[$i][10])
				$refresh = 0
			Next
		EndIf
		
		
		$nMsg = GUIGetMsg()
		
		For $i = 1 To $pc[0][0] 
			if $nMsg = $pc[$i][3] Then
;~ 				MsgBox(0,"",$pc[$i][1])
				_shutdown($pc[$i][0], GUICtrlRead($pc[$i][7]))
				$refresh=1
				$pc[$i][4] = $GUI_HIDE
				$pc[$i][6] = $GUI_HIDE
				$pc[$i][8] = $GUI_HIDE
				$pc[$i][10] = $GUI_SHOW
				
			ElseIf $nMsg = $pc[$i][5] Then
				_restart($pc[$i][0], GUICtrlRead($pc[$i][7]))
				$refresh=1
				$pc[$i][4] = $GUI_HIDE
				$pc[$i][6] = $GUI_HIDE
				$pc[$i][8] = $GUI_HIDE
				$pc[$i][10] = $GUI_SHOW
				
			ElseIf $nMsg = $pc[$i][9] Then
				_stopIT($pc[$i][0])
				
				$refresh=1
				$pc[$i][4] = $GUI_SHOW
				$pc[$i][6] = $GUI_SHOW
				$pc[$i][8] = $GUI_SHOW
				$pc[$i][10] = $GUI_HIDE
				
			EndIf
		Next
		
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
		
		
	WEnd
EndFunc   ;==>_GUImainWin




Func _shutdown($machine, $forced)
	If $forced <> 1 Then
		Run("shutdown -s -m " & "\\" & $machine, "",@SW_HIDE)
	Else
		Run("shutdown -s -f -m " & "\\" & $machine, "",@SW_HIDE)
	EndIf
EndFunc   ;==>_shutdown

Func _restart($machine, $forced)
	If $forced <> 1 Then
		Run("shutdown -r -m " & "\\" & $machine, "",@SW_HIDE)
	Else
		Run("shutdown -r -f -m " & "\\" & $machine, "",@SW_HIDE)
	EndIf
EndFunc   ;==>_restart

Func _stopIT($machine)
	Run("shutdown -a -m " & "\\" & $machine, "",@SW_HIDE)
EndFunc

Func _isOnline($machine)
;~ 	$timeToGo= TimerInit()
;~ 	Ping($machine, 50)
;~ 	$x = TimerDiff($timeToGo)
;~ 	if  $x > 50 Then
;~ 		MsgBox(0,$machine,$x)
;~ 	EndIf
	Return Ping($machine, 50)
EndFunc   ;==>_isOnline