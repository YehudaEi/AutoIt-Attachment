; Help getting rid of spam in egain go much faster!
; by Allen Brubaker




#Include <Misc.au3>


; MAIN() 

Welcome()
$MoveButton = GetCoords("'Move'", 20) ;01 = left-click
;$Window = GetCoords("'Dropdown'", 01)
;$GenPool2 = GetCoords("GenPool2", 20) ;20 = spacebar  
;$Spam = GetCoords("Spam", 20)
ToolTip("")

DoRoutines($MoveButton);, $Window, $GenPool2, $Spam)

;   
 
 
 
 
Func Esc()
	
	if _ispressed("1B") then
		$Begin = TimerInit()
		Do 
			$Cursor = MouseGetPos()
			ToolTip(" Program Terminated ", $Cursor[0]+20, $Cursor[1]+20)
			$Dif = TimerDiff($Begin)
		until ($Dif > 1000)
		exit
	EndIf
EndFunc
 
 
Func Welcome ()

	$Begin = TimerInit()
	
	$s_hexKey = 20 ;spacebar
	Do
		$Cursor = MouseGetPos()
		ToolTip(" Welcome to Spam Zapper :] ", $Cursor[0]+20, $Cursor[1]+20)
		$Status = _IsPressed($s_hexKey)
		$Dif = TimerDiff($Begin)
		Esc()
	until ($Dif > 3000 or $Status == 1) 
	
	
	if ($Status <> 1 and $Dif > 3000) Then	  
		Do
			$Cursor = MouseGetPos()
			ToolTip("Make 'egain' the active window"& @CRLF &"Press <spacebar>", $Cursor[0]+20, $Cursor[1]+20)
			$Status = _IsPressed($s_hexKey)
			Esc()	
		until ($Status == 1)
	EndIf	
		
endfunc	
   
 
Func GetCoords (const $String, $Key)
	 
	$Begin = TimerInit()	
	$s_hexKey = $Key      
	Do  
		$Cursor = MouseGetPos()
	;	if $s_hexKey == 01 Then
	;		ToolTip("Click " &$String& @CRLF &"(" & $Cursor[0] & "," & $Cursor[1] & ")", $Cursor[0]+20, $Cursor[1]+20)  
	;	EndIf
	;	if $s_hexKey == 20 Then
			ToolTip("Hover over " &$String& @CRLF &"<space>"& @CRLF &"(" & $Cursor[0] & "," & $Cursor[1] & ")", $Cursor[0]+20, $Cursor[1]+20)
	;	EndIf
		 
		Esc()
			
		$Dif = TimerDiff($Begin)
		if ($Dif > 300) Then
			$Status = _IsPressed($s_hexKey)
		else
			$Status = 0
		endif	
			
	Until ($Status == 1) 
		
	return($Cursor)
	
endfunc	

Func DoRoutines(const $MoveButton);, const $Window, const $GenPool2, const $Spam)
	
	;$PoolCount = 0
	;$SpamCount = 0
	$Begin = TimerInit()
	
	while (1==1)
		
		;$Cursor = MouseGetPos()
		;ToolTip("[1] -> to GenPool2"& @CRLF &"[2] -> to Spam"& @CRLF &"  "& $SpamCount &" Spam / "& $SpamCount+$PoolCount &" Total ", $Cursor[0]+20, $Cursor[1]+20)
	  
	  $Dif=TimerDiff($Begin)
      if ($Dif > 25) Then

		$Begin = TimerInit()
		
		Esc()
		
		$Num1 = 0
		if (_isPressed(61)) Then
			$Num1 = 1
		EndIf	
		
		$Num2 = 0 
		if (_isPressed(62)) Then
			$Num2 = 1
		endif	
			
		if ($Num1) Then
			MouseClick("left", $MoveButton[0], $MoveButton[1], 3, 0)
		;	MouseClick("left", $Window[0], $Window[1], 1, 3)
		;	MouseClick("left", $GenPool2[0], $GenPool2[1], 1, 1)
			Sleep(400)
			Send("{TAB 2}")
			Send("{DOWN 1}")
			Send("{ENTER}")
			;$PoolCount = $PoolCount + 1
		endif
		
		if ($Num2) Then
			MouseClick("left", $MoveButton[0], $MoveButton[1], 3, 0)
			;	MouseClick("left", $Window[0], $Window[1], 1, 3)
			;	MouseClick("left", $Spam[0], $Spam[1], 1, 1)
			Sleep(400)
			Send("{TAB 2}")
			Send("{DOWN 2}")
			Send("{ENTER}")
			;$SpamCount = $SpamCount + 1
		endif
	
	  endif
	WEnd
	
EndFunc


	
	

