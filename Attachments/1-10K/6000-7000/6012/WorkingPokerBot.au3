;
;
;
;
; Play Party Poker

; Pre-initialization : Set Name of Table
Global $tablename = "Play money 4015100"
Global $inspector = "Connected to """ & $tablename

; Initialize Buttons
; These are the button names you might have to change these for different poker clients
$FoldButton = "AfxWnd42s14";
$CheckButton = "AfxWnd42s15";
$CallButton = "AfxWnd42s15";
$BetButton = "AfxWnd42s16";
$RaiseButton = "AfxWnd42s16";

; Set Coordinate mode to relative to window client area
AutoItSetOption ( "PixelCoordMode", 2 )	

; Wait for the window of table to become active
WinWaitActive($tablename)

; Main Loop
While WinExists($tablename)
	Sleep(300);
	
	$FoldVisible = ControlCommand($tablename, "", $FoldButton, "IsVisible", "");
	$RaiseVisible = ControlCommand($tablename, "", $RaiseButton, "IsVisible", "");
	
	if $FoldVisible = 1 then
		Sleep(Random(1500, 2500))
		$action = GetAction();
		if $action = 1 then
			; Fold/Check			
			; if we can check for free, then do that instead of folding
            if StringInStr(ControlGetText($tablename, "", $CheckButton), "Check") = 1 then
                ControlClick($tablename, "", $CheckButton);
			else
                ControlClick($tablename, "", $FoldButton);
			endif
		elseif $action = 2 then
			; Check/Call
            ControlClick($tablename, "", $CallButton);            
		elseif $action = 3 then
			; Call/Bet			
			; if we can call then call otherwise bet
            if StringInStr(ControlGetText($tablename, "", $CallButton), "Call") = 1 then
                ControlClick($tablename, "", $CallButton);
            else
                ControlClick($tablename, "", $BetButton);
            endif			
		elseif $action = 4 then
			; Bet/Raise or Call
			if $RaiseVisible = 1 then ; Cannot raise if its capped already -- so just call in that case
	            ControlClick($tablename, "", $RaiseButton);
	        else
				ControlClick($tablename, "", $CallButton);	        	
			endif
		endif
	endif

WEnd

; Poker Inspector Actions
Func GetAction()	
	WinActivate ($inspector);

	; Make sure we at least have hold cards - if not then do nothing for now
	if GotHoleCards() = 0 then
		return 0;
	endif 

	;yellow
	$color = PixelGetColor (335, 45);
	if $color = 16776960 then 
		WinActivate($tablename);
		return 2;
	endif
	
	; blue
	$color = PixelGetColor (335, 56);
	if $color = 65535 then 
		; sometimes bet or just call 50% of the time
		WinActivate($tablename);
		return 3;
	endif

	; green
	$color = PixelGetColor (335, 66);
	if $color = 65280 then
		; If we've got the nuts or close to then sometimes just check 20% of the time
		; otherwise raise or reraise
		WinActivate($tablename);
		return 4;
	endif

	; red - fold
	WinActivate($tablename);
	return 1;
EndFunc

; Returns yes=1, no=0
Func GotHoleCards() 
	$hole1 = PixelGetColor(9,35)
	$hole2 = PixelGetColor(50,35)
	if ($hole1 = 16777215) and ($hole2 = 16777215) then
		return 1
	endif		
	return 0
EndFunc


