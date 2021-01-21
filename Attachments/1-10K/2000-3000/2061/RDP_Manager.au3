#cs

RDP / VNC Manager
April 28, 2005
-John Taylor

Desktop applet to facilitate connecting to a varity of RDP & VNC hosts. Inspired by
SearchBar - http://www.autoitscript.com/forum/index.php?showtopic=9359&st=0&p=65838

#ce

Dim $Group[3] ; number of RDP Groups
$Group[0]= "dc|clstrA|clstrB|backupsrv|sqlsrv"
$Group[1]= "custservice|custdatabase|nas"
$Group[2]= "test|web1|web2|printsrv|scansrv"

$Default_Trans = 40  ; Transparency - 20 is barley visible, 200 is very visible, default is 3 (hidden), debug is 40
$High_Trans = 200
$Trans_Toggle = 0
$PrevWin = "" ; Window handle if previous window, will return focus to this window once mouse leaves "bounding box"
$TopWin_Y = 615  ; the y coordinate where the window will be placed - default is 615
$w = 72  ; the width of each combo box, make this the width of the longest server name, default is 72
$offset = 1  ; width between 2 combo boxes (distance between where one ends & the next one begins)

$TopWin_Width = (Ubound($Group) * $w) + (Ubound($Group) * $offset) ; for each $Group
$TopWin_Width = $TopWin_Width + ( $w + $offset ) ; for VNC
$TopWin_Width = $TopWin_Width + (20 + $offset) ; for close button

#include <GUICONSTANTS.au3>
#notrayicon
Opt ("GUIOnEventMode", 1)

$ProgramName = "RDP Manager"
If WinExists($ProgramName) Then
	WinActivate($ProgramName)
	WinSetTrans($ProgramName, "", $High_Trans)
	MsgBox(0, "Error", $ProgramName & " is already running.  Quit that instance first and then restart.")
	WinSetTrans($ProgramName, "", $Default_Trans)
	Exit
EndIf

$GUIStyle = $WS_POPUP
$GUIStyleEx = BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST)

$TopWin = GUICreate($ProgramName, $TopWin_Width, 20, $TopWin_Y, -2, $GUIStyle, $GUIStyleEx)
GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
$slots = WinGetPos($ProgramName)
$BoundingBox_A = $slots[0]
$BoundingBox_B = $slots[1]
$BoundingBox_X = $slots[2] + $BoundingBox_A
$BoundingBox_Y = $slots[3] + $BoundingBox_B


$x = 0
Dim $EventId[Ubound($Group)]
for $i = 0 to Ubound($Group) - 1
	$EventId[$i] = GUICtrlCreateCombo("", $x, 0, $w)
	GUICtrlSetOnEvent($EventId[$i], "Run_RDP")
	GUICtrlSetData(-1,$Group[$i])
	$x = $x + $w + $offset
Next

; Append VNC Combo Box, combining all groups
$all_groups = $Group[0]
for $j = 1 to Ubound($Group) - 1
	$all_groups = $all_groups & "|" & $Group[$j]
Next
$VncId = GUICtrlCreateCombo("", $x, 0, $w)
GUICtrlSetOnEvent($VncId, "Run_VNC")
GUICtrlSetData(-1,$all_groups)
$x = $x + $w + $offset

GUICtrlCreateButton("X", $x, 0, 20, 20, $BS_BITMAP)
GUICtrlSetOnEvent(-1, "OnExit")
GUICtrlSetFont(-1, 12, -1, "bold")
;GUICtrlSetImage ( -1, "C:\Windows\system32\x.bmp" )
WinSetTrans($TopWin, "", $Default_Trans)
GUISetState()

;MsgBox(0,"Bounding Box", $BoundingBox_A & " : " & $BoundingBox_B & " : " & $BoundingBox_X & " : " & $BoundingBox_Y)

AdlibEnable ( "OnAdLib", 500 )
while( 1 )
	sleep ( 1250 )
wend

Func Run_RDP()
	$host = GUICtrlRead( @GUI_CTRLID )
	$cmd = "C:\Windows\System32\mstsc.exe /v:" & $host & " /w:800 /h:600"
	;$cmd = "C:\Windows\System32\mstsc.exe c:\WINDOWS\system32\rdp.rdp /v:" & $host
	;MsgBox(0,"Debug", $cmd )
	Run( $cmd, "" )
EndFunc

Func Run_VNC()
	$host = GUICtrlRead( @GUI_CTRLID )
	$cmd = '"C:\Program Files\TightVNC-unstable\vncviewer.exe" ' & $host
	;MsgBox(0,"Debug", $cmd )
	Run( $cmd, "" )
EndFunc

Func OnExit()
	exit
EndFunc
	
Func OnAdLib()
	$pos = MouseGetPos()
	if $pos[0] > $BoundingBox_A AND $pos[0] < $BoundingBox_X AND $pos[1] > $BoundingBox_B AND $pos[1] < $BoundingBox_Y Then
		WinSetTrans($TopWin, "", $High_Trans)
		$slots = WinList()
		; Find the name and handle of the window that currenlty has focus, is there an easier way to do this?
		; place this info into $PrevWin, and then get window focus with WinActivate()
		For $i = 1 to $slots[0][0]
			if BitAnd( WinGetState($slots[$i][1]),8 ) Then
				if $ProgramName = $slots[$i][0] Then
					ExitLoop
				endif
				$PrevWin = $slots[$i][1]
				;MsgBox(0,"PrevWin", $slots[$i][0] & " : " & $PrevWin)
				ExitLoop
			endif
		Next
		WinActivate($ProgramName)
		$Trans_Toggle=1
	Else
		if 1 == $Trans_Toggle Then
			WinSetTrans($TopWin, "", $Default_Trans)

			; since we have left the "bounding box", return focus to the window that previously had it
			; here is the problems
			; 1) drop down boxes are outside of the "bounding box"
			; 2) moving the mouse over and then out again works fine, but if you select a host, but 
			;    do not click on it, it will still try to run rdp or vnc

			if "" <> $PrevWin Then
				;MsgBox(0,"PrevWin", $PrevWin)
				WinActivate($PrevWin)
			EndIf
			$Trans_Toggle = 0
		endif
	endif
Endfunc

