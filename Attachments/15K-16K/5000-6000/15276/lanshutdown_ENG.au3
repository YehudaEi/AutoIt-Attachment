#include <GUIConstants.au3>

$title = "LANShutdown v0.2"

if IsAdmin() = 0 Then
	$pass= InputBox($title, "Insert Administrator password","","*")
	RunAsSet("Administrator",@ComputerName, $pass)
EndIf

$var = IniReadSection("lanshutdown.ini", "computer")
If @error Then
	MsgBox(4096, "", "Error occurred, probably no INI file.")
Else
	Global $pc[$var[0][0] + 1][19]
	Global $refresh = 1
	Global $start = 20
	For $i = 0 To $var[0][0]
		$pc[$i][0] = $var[$i][0]
		$pc[$i][1] = $var[$i][1]
		;MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF & "Value: " & $var[$i][1])
	Next
EndIf

_GUImainWin()


Func _GUIinsertComment()
	#Region ### START Koda GUI section ### Form=
	$comment = GUICreate("Insert comment", 347, 207, 321, 398)
	$Edit1 = GUICtrlCreateEdit("", 8, 8, 329, 145)
;~ 	GUICtrlSetData(-1, "AEdit1")
	$Ok = GUICtrlCreateButton("Ok", 120, 168, 105, 25, $BS_DEFPUSHBUTTON)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	GUICtrlSetState($Edit1, $GUI_FOCUS)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Ok
				$ret = GUICtrlRead($Edit1)
				GUIDelete($comment)
				Return $ret
			Case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd

EndFunc

Func _setOnLine($i)
	GUICtrlSetFont($pc[$i][11], 10, 800, 0, "MS Sans Serif")
	GUICtrlSetColor($pc[$i][11], 0x008000)
	$pc[$i][4] = $GUI_ENABLE
	$pc[$i][6] = $GUI_ENABLE
	$pc[$i][8] = $GUI_ENABLE
	$pc[$i][14] = $GUI_ENABLE
	$pc[$i][17] = $GUI_ENABLE
EndFunc


Func _setOffLine($i)
	GUICtrlSetFont($pc[$i][11], 10, 800, 0, "MS Sans Serif")
	GUICtrlSetColor($pc[$i][11], 0xFF0000)
	$pc[$i][4] = $GUI_DISABLE
	$pc[$i][6] = $GUI_DISABLE
	$pc[$i][8] = $GUI_DISABLE
	$pc[$i][14] = $GUI_DISABLE
	$pc[$i][17] = $GUI_DISABLE
EndFunc

Func _forceRefresh($i)
	GUICtrlSetState($pc[$i][3], $pc[$i][4])
	GUICtrlSetState($pc[$i][5], $pc[$i][6])
	GUICtrlSetState($pc[$i][7], $pc[$i][8])
	GUICtrlSetState($pc[$i][9], $pc[$i][10])
	GUICtrlSetState($pc[$i][12], $pc[$i][14])
	GUICtrlSetState($pc[$i][15], $pc[$i][17])
EndFunc


Func _GUImainWin()
	
	;	$Form1 = GUICreate("AForm1", 282, 152, 308, 226)
	;MsgBox(0,"",$pc[0][0])
	
	$Form1 = GUICreate("ShutdownLAN", 450, ($pc[0][0] * 32) + 100, 308, 226)
	
;~ 	$Label1 = GUICtrlCreateLabel("off", 8, 40, 21, 20)
;~ 	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;~ 	GUICtrlSetColor(-1, 0x008000)
;~ 	$Label2 = GUICtrlCreateLabel("on", 8, 72, 21, 20)
;~ 	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;~ 	GUICtrlSetColor(-1, 0xFF0000)
	
	For $i = 1 To $pc[0][0]
		
		$pc[$i][11] = GUICtrlCreateLabel($pc[$i][1], 8, $i * 32 + $start, 85, 20)
		
		$pc[$i][18] = _isOnline($pc[$i][0])
		
		If $pc[$i][18] > 0 Then
			_setOnLine($i)
		Else
			_setOffLine($i)
		EndIf
		
		$pc[$i][3] = GUICtrlCreateButton("Shutdown", 96, $i * 32 + $start, 51, 17, 0)
;~ 		$pc[$i][4] = $GUI_SHOW
		$pc[$i][5] = GUICtrlCreateButton("Restart", 152, $i * 32 + $start, 57, 17, 0)
;~ 		$pc[$i][6] = $GUI_SHOW
		$pc[$i][7] = GUICtrlCreateCheckbox("Force", 224, $i * 32 + $start, 49, 17)
;~ 		$pc[$i][8] = $GUI_SHOW
		$pc[$i][9] = GUICtrlCreateButton("Stop shutdown", 96, $i * 32 + $start, 150, 17, 0)
		$pc[$i][10] = $GUI_HIDE
		
		$pc[$i][12] = GUICtrlCreateCheckbox("Insert comment", 280, $i * 32 + $start, 90, 17)
		$pc[$i][13] = ""
		
		$pc[$i][15] = GUICtrlCreateCheckbox("Seconds", 380, $i * 32 + $start, 90, 17)
		$pc[$i][16] = 30
		
		
	Next
	;GUICtrlSetState("",$GUI_DISABLE)
	;GUICtrlSetState("",$GUI_HIDE)
	
	;$Button2 = GUICtrlCreateButton("Spegni tutti", 88, ($pc[0][0] * 32) + 70, 105, 17, 0)
	
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

$pingMachine = 1
$pingMachineTime = TimerInit()
$refreshMinTime = 3000

	While 1
		if TimerDiff($pingMachineTime) >= $refreshMinTime Then
			;MsgBox(0,$pc[$pingMachine][1], $pc[$pingMachine][18])
			if _isOnline($pc[$pingMachine][0]) > 0 AND $pc[$pingMachine][18] = 0 Then
				_setOnLine($pingMachine)
				_forceRefresh($pingMachine)
				;$refresh = 1
			ElseIf _isOnline($pc[$pingMachine][0]) = 0 AND $pc[$pingMachine][18] > 0 Then
				if $pc[$pingMachine][10] = $GUI_SHOW Then
					$pc[$pingMachine][4] = $GUI_SHOW
					$pc[$pingMachine][6] = $GUI_SHOW
					$pc[$pingMachine][8] = $GUI_SHOW
					$pc[$pingMachine][14] = $GUI_SHOW
					$pc[$pingMachine][17] = $GUI_SHOW
					$pc[$pingMachine][10] = $GUI_HIDE
					$pc[$pingMachine][7]= $GUI_UNCHECKED
					$pc[$pingMachine][12] = $GUI_UNCHECKED
					$pc[$pingMachine][15] = $GUI_UNCHECKED
			
					_forceRefresh($pingMachine)
				EndIf
				_setOffLine($pingMachine)
				
				$pc[$pingMachine][7]= $GUI_DISABLE
				$pc[$pingMachine][12] = $GUI_DISABLE
				$pc[$pingMachine][15] = $GUI_DISABLE
				_forceRefresh($pingMachine)
			EndIf
			
			
			if $pingMachine = $pc[0][0]-1 Then
				$pingMachine = 1
			Else
				$pingMachine += 1
			EndIf
			
			$pingMachineTime = TimerInit()
		EndIf

		If $refresh = 1 Then
			For $i = 1 To $pc[0][0]
				GUICtrlSetState($pc[$i][3], $pc[$i][4])
				GUICtrlSetState($pc[$i][5], $pc[$i][6])
				GUICtrlSetState($pc[$i][7], $pc[$i][8])
				GUICtrlSetState($pc[$i][9], $pc[$i][10])
				GUICtrlSetState($pc[$i][12], $pc[$i][14])
				GUICtrlSetState($pc[$i][15], $pc[$i][17])
				$refresh = 0
			Next
		EndIf

		
		$nMsg = GUIGetMsg()
		
		For $i = 1 To $pc[0][0] 
			if $nMsg = $pc[$i][3] Then
;~ 				MsgBox(0,"",$pc[$i][1])
				$comment = ""
				if GUICtrlRead($pc[$i][12]) = 1 Then $comment = $pc[$i][13]
				_shutdown($pc[$i][0], GUICtrlRead($pc[$i][7]), $comment, $pc[$i][16])
				$refresh=1
				$pc[$i][4] = $GUI_HIDE
				$pc[$i][6] = $GUI_HIDE
				$pc[$i][8] = $GUI_HIDE
				$pc[$i][14] = $GUI_HIDE
				$pc[$i][17] = $GUI_HIDE
				$pc[$i][10] = $GUI_SHOW
				
			ElseIf $nMsg = $pc[$i][5] Then
				$comment = ""
				if GUICtrlRead($pc[$i][12]) = 1 Then $comment = $pc[$i][13]
				_restart($pc[$i][0], GUICtrlRead($pc[$i][7]), $comment, $pc[$i][16])
				$refresh=1
				$pc[$i][4] = $GUI_HIDE
				$pc[$i][6] = $GUI_HIDE
				$pc[$i][8] = $GUI_HIDE
				$pc[$i][14] = $GUI_HIDE
				$pc[$i][17] = $GUI_HIDE
				$pc[$i][10] = $GUI_SHOW
				
			ElseIf $nMsg = $pc[$i][9] Then
				_stopIT($pc[$i][0])
				
				$refresh=1
				$pc[$i][4] = $GUI_SHOW
				$pc[$i][6] = $GUI_SHOW
				$pc[$i][8] = $GUI_SHOW
				$pc[$i][14] = $GUI_SHOW
				$pc[$i][17] = $GUI_SHOW
				$pc[$i][10] = $GUI_HIDE
			ElseIf $nMsg = $pc[$i][12] Then
				if GUICtrlRead($pc[$i][12]) = 1 Then
					$pc[$i][13] = _GUIinsertComment()
				;MsgBox(0,"",$pc[$i][13])
				;GUICtrlSetState($pc[$i][12], $GUI_CHECKED)
				Else
					$pc[$i][13] = ""
				EndIf
			ElseIf $nMsg = $pc[$i][15] Then
				if GUICtrlRead($pc[$i][15]) = 1 Then
					$pc[$i][16] = InputBox($title, "The timer sleep in seconds")
				;MsgBox(0,"",$pc[$i][13])
				;GUICtrlSetState($pc[$i][12], $GUI_CHECKED)
				Else
					$pc[$i][16] = 30
				EndIf
			EndIf
		Next
		
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
		
		
	WEnd
EndFunc   ;==>_GUImainWin




Func _shutdown($machine, $forced, $comment, $time)
	If $forced <> 1 Then
		if $comment <> "" Then
			if IsAdmin() = 0 Then
;~ 				RunAsSet("Administrator",@ComputerName, $pass)
			EndIf
			Run("shutdown -t " & $time & " -s -c """ & $comment & """ -m \\" & $machine, "",@SW_HIDE)
		Else
			Run("shutdown -t " & $time & " -s -m " & "\\" & $machine, "",@SW_HIDE)
		EndIf
	Else
		if $comment <> "" Then
			Run("shutdown -t " & $time & " -s -f -c """ & $comment & """ -m \\" & $machine, "",@SW_HIDE)
		Else
			Run("shutdown -t " & $time & " -s -f -m " & "\\" & $machine, "",@SW_HIDE)
		EndIf
	EndIf
EndFunc   ;==>_shutdown -t" & $time & "

Func _restart($machine, $forced, $comment, $time)
	If $forced <> 1 Then
		if $comment <> "" Then
			Run("shutdown -t " & $time & " -r -c """ & $comment & """ -m \\" & $machine, "",@SW_HIDE)
		Else
			Run("shutdown -t " & $time & " -r -m " & "\\" & $machine, "",@SW_HIDE)
		EndIf
	Else
		if $comment <> "" Then
			Run("shutdown -t " & $time & " -r -f -c """ & $comment & """ -m \\" & $machine, "",@SW_HIDE)
		Else
			Run("shutdown -t " & $time & " -r -f -m " & "\\" & $machine, "",@SW_HIDE)
		EndIf
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