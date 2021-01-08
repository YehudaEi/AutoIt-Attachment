; Pre-initialization : Set Name of Table
Global $tablename = "enter table name here"

; Initialize Buttons
$Foldbutton = "AfxWnd4217"
$Checkbutton = "Button1"
$Callbutton = "Button1"
$Betbutton = "AfxWnd4219"
$Raisebutton = "AfxWnd4219"

; Wait 6 seconds for the window of table to become active
WinWaitActive($tablename)

; Main Loop
While WinExists($tablename) 
Sleep(Random(1500, 2500))

;Fold
if $action = 1 Then
ControlClick($tablename, "", $Foldbutton);
EndIf

;Check
;Sleep(Random(0, 2000));
ElseIf $action = 2 Then
ControlClick($tablename, "" $Checkbutton);
EndIf

;Call
;Sleep(Random(0, 2000));
ElseIf $action = 3 Then
ControlClick($tablename, "" $Callbutton);
EndIf

;Bet
;Sleep(Random(0, 2000));
ElseIf $action = 4 Then
ControlClick($tablename, "" $Betbutton);
EndIf

;Raise
;Sleep(Random(0, 2000));
ElseIf $action = 5 Then
ControlClick($tablename, "" $Raisebutton);
EndIf
WEnd

;Poker Pro Actions
Func get $action(1 - 5)
WinActivate ("Poker Pro 2006" & $tablename); 

;fold
$control = ControlGetText ("Poker Pro 2006 """ & $tablename, "Fold", static9);
if $control = "Fold" Then
WinActivate($tablename);
Return 1
EndIf

;check
$control = ControlGetText ("Poker Pro 2006 """ & $tablename, "Check", static9);
if $control = "Check" Then
WinActivate($tablename);
Return 2
EndIf

;call
$control = ControlGetText ("Poker Pro 2006 """ & $tablename, "Call", static9);
if $control = "Call" Then
WinActivate($tablename);
Return 3
EndIf

;bet
$control = ControlGetText ("Poker Pro 2006 """ & $tablename, "Bet", static9);
if $control = "Bet" Then
WinActivate($tablename);
Return 4
EndIf

;raise
$control = ControlGetText ("Poker Pro 2006 """ & $tablename, "Raise", static9);
if $control = "Raise" Then
WinActivate($tablename);
Return 5
EndFunc
