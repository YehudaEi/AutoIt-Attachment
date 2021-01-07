; Pre-initialization : Set Name of Table
Global $tablename = "Play money 4015470 - NL  Hold'em - 2000.  Good Luck danman338 !      [Connection is very good ]"
; Initialize Buttons
; These are the button names you might have to change these for different poker clients
$FoldButton = "AfxWnd42s14"
$CheckButton = "AfxWnd42s15"
$CallButton = "AfxWnd42s15"
$BetButton = "AfxWnd42s16"
$RaiseButton = "AfxWnd42s16"
; Set Coordinate mode to relative to window
AutoItSetOption ( "PixelCoordMode", 0 )
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
;Sleep(Random(0, 2000));
ControlClick($tablename, "", $CallButton);
elseif $action = 3 then
; Call/Bet
; if we can call then call otherwise bet
if StringInStr(ControlGetText($tablename, "", $CallButton), "Call") = 1 then ControlClick($tablename, "", $CallButton);
else
ControlClick($tablename, "", $BetButton);
endif
elseif $action = 4 then
; Bet/Raise
;Sleep(Random(0, 2000));
ControlClick($tablename, "", $RaiseButton);
endif
WEnd
; Poker Inspector Actions
Func GetAction()
WinActivate ("Connected to """ & $tablename);
; red - fold
$color = PixelGetColor (338, 55);
if $color = 255 then
WinActivate($tablename);
return 1;
endif
;yellow
$color = PixelGetColor (338, 67);
if $color = 65535 then
WinActivate($tablename);
return 2;
endif
; blue
$color = PixelGetColor (338, 79);
if $color = 16776960 then
; sometimes bet or just call 50% of the time
WinActivate($tablename);
return 3;
endif
; green
$color = PixelGetColor (338, 88);
if $color = 65280 then
; If we've got the nuts or close to then sometimes just check 20% of the time
; otherwise raise or reraise
WinActivate($tablename);
return 4;
endif
WinActivate($tablename);
return 1;
EndFunc
; Checks how many empty seats there are
Func OccupiedSeats()
Local $Count = 0
Local $SeatOpenColor = 3246765
;Seat 1
If (PixelGetColor(517, 96) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
;Seat 2
If (PixelGetColor(665, 133) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
;Seat 3
If (PixelGetColor(735, 251) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 4
If (PixelGetColor(660, 378) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 5
If (PixelGetColor(493, 413) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 6
If (PixelGetColor(262, 413) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 7
If (PixelGetColor(108, 378) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 8
If (PixelGetColor(53, 247) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 9
If (PixelGetColor(126, 133) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
; Seat 10
If (PixelGetColor(264, 96) == $SeatOpenColor) Then
$Count = $Count + 1;
EndIf
return $Count;
EndFunc