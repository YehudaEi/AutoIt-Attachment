;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Oo                       .oOOOo.                         o     ;
;  o  O                      o     o                        O      ;
; O    o           O         O.                             o      ;
;oOooOoOo         oOo         `OOoo.                        o      ;
;o      O O   o    o   .oOo.       `O .oOo. .oOo. .oOo. .oOoO      ;
;O      o o   O    O   O   o        o O   o OooO' OooO' o   O      ;
;o      O O   o    o   o   O O.    .O o   O O     O     O   o      ;
;O      O `OoO'o   `oO `OoO'  `oooO'  oOoO' `OoO' `OoO' `OoO'o     ;
;                                     O                            ;
;                                     o'                           ;
;                                                                  ;
;		    _      __                                      ;
;	  	   |_)    (_ ._   ._ _ ._ _  _ |  _                ;
;		   |_)\/  __)|_)\/| (_)| (_)(_ |<_>                ;
;		      /      |  /                                  ;
;*******************************************************************
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If you would like AutoSpeed to show you data ;
	;about what is going on, set $showdata to 1.  ;
	;Otherwise, set it to 0.                      ;
			$showdata = 0                 ;
	;If you would like to allow the Escape key to ;
	;be able to quit autospeed, set $esc_quit to  ;
	;1. otherwise, set it to 0.                   ;
			$esc_quit = 1                 ;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;********************************************************************
;                                                                   ;
;********************************************************************
#Include <Constants.au3>
Opt("WinTitleMatchMode", 4)

if $esc_quit then hotkeyset("{esc}", "OnAutoItExit")

if not ProcessSetPriority ( @AutoItPID, 5) then ProcessSetPriority ( @AutoItPID, 4)

$old = ""
$curr = ""

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.


$crashitem      = TrayCreateItem("Crash Protection")
TrayItemSetState ( -1, $TRAY_CHECKED )
TrayCreateItem("")
$exititem       = TrayCreateItem("Exit")

TraySetState()

TrayTip ( "AutoSpeed", "AutoSpeed Active", 10 )

while 1
$curr_pro = WinGetProcess ("active")
$curr_win = WinGetTitle ("active")

if $old <> $curr_pro and StringIsDigit ($curr_pro) then
	$curr_pro = WinGetProcess ("active")
	$old = WinGetProcess ("active")
	reset()
		if not ProcessSetPriority ( $curr_pro, 5) then ProcessSetPriority ( $curr_pro, 4)
		if $showdata then ToolTip("Current Window Title: " & $curr_win & @crlf & "Current Window PID: " & $curr_pro, 0, 0)
endif
if TrayItemGetState ($crashitem) = $TRAY_CHECKED then crashcheck()
$msg = TrayGetMsg()
	if $msg = $exititem then OnAutoItExit ( )
sleep(100)
wend

func reset()
$pros = ProcessList()

	for $i = 1 to $pros[0][0]
	if TrayItemGetState ($crashitem) = $TRAY_CHECKED then
	if not $pros[$i][0] = "explorer.exe" then ProcessSetPriority ( $pros[$i][1], 2)
	else
	ProcessSetPriority ( $pros[$i][1], 2)
	endif
	next
endfunc

Func OnAutoItExit ( )
TrayTip ( "AutoSpeed", "Sutting Down AutoSpeed...", 10 )
sleep(1000)
ToolTip("", 0, 0)
reset()
exit
EndFunc

func crashcheck()
$mem = MemGetStats ( )
if $mem[0] > 85 then
$pros = ProcessList()
	for $i = 1 to $pros[0][0]
	if not $pros[$i][0] = "explorer.exe" then ProcessSetPriority ( $pros[$i][1], 2)
	next
$exp = WinGetProcess ("classname=Progman")
if not ProcessSetPriority ( $exp, 5) then ProcessSetPriority ( $exp, 4)
if not ProcessSetPriority ( @autoitpid, 5) then ProcessSetPriority ( @autoitpid, 4)
TrayTip ( "AutoSpeed - Warning", "One or more of your applacations are using too much of your CPU." & @crlf & "Please locate the problim applacation and close it." , 10 )
sleep(100)
ProcessSetPriority ( @autoitpid, 2)
endif
endfunc