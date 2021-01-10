#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Window Vars
Dim $height, $height1, $height2
Dim $width, $width1, $width2
Dim $main, $ball, $paddle1, $paddle2, $mousehider

; Pause Vars
Dim $paused, $opause, $other

; Ball Parse Vars
Dim $pad1[2], $pad2[2], $padh, $padw, $bsize, $pmove, $loffset
Dim $speed[2], $now[2], $next[2], $nextt1[2], $nextt2[2]
Dim $signx, $signy, $maxa

; Scores / Timers
Dim $hits, $misses, $overallid, $overallt1, $overallt2
Dim $rallyid, $rallyt1, $rallyt2
Dim $ptimeid, $ptime1, $ptime2
Dim $highscore, $highscore1, $highscore2, $rallyt, $overallt

; Board
Dim $Hitsid, $Missesid, $Timer1, $Timer2

$paused = False
$start = False

HotKeySet("{HOME}", "start")
HotKeySet("{END}", "stop")

MsgBox(0, "C Pong", "Press HOME to start")

While $start = False
	Sleep(100)
WEnd

HotKeySet("{PGUP}", "pause")
HotKeySet("{PGDN}", "restart")

$height = @DesktopHeight
$width = @DesktopWidth
$height1 = 138
$height2 = $height - 148
$width1 = @DesktopWidth / 7
$width2 = @DesktopWidth - @DesktopWidth / 7

$bsize = 10
$tsize1 = ($bsize / 3) * 2
$tsize2 = $bsize / 3
$padh = 100
$padw = 20
$loffset = -3

$main = GUICreate("C Pong", $width, $height1 - 20, $loffset, $height2, $WS_POPUP + $WS_MINIMIZEBOX, -1 + $WS_EX_TOPMOST)
DScore()
$ball = GUICreate("           C Pong Ball", $bsize, $bsize, 0, 0, $WS_POPUP, $WS_EX_TOPMOST, $main)
$paddle1 = GUICreate("              C Pong 1", $padw, $padh, 0, 0, $WS_POPUP, $WS_EX_TOPMOST, $main)
$paddle2 = GUICreate("              C Pong 2", $padw, $padh, 0, 0, $WS_POPUP, $WS_EX_TOPMOST, $main)
GUISetBkColor("0xFF0000", $ball)
GUISetBkColor("0xFF00FF", $paddle1)
GUISetBkColor("0xFF00FF", $paddle2)
GUISetBkColor("0x000000", $main)
GUISetState(@SW_SHOW, $ball)
GUISetState(@SW_SHOW, $paddle1)
GUISetState(@SW_SHOW, $paddle2)
GUISetState(@SW_SHOW, $main)

restart()

While 1
	wincheck()
	If $paused = False Then
		updater()
		$pmove = MouseGetPos(1)
		If $pmove > ($height2 - $padh + 3) Then
			$pmove = $height2 - $padh + 3
		EndIf
		WinMove("              C Pong 1", "", $width1, $pmove)
		WinMove("              C Pong 2", "", $width2, $pmove)
		WinMove("C Pong", "", $loffset, $height2)
		Sleep(10)
		ballmove()
		ballscore()
	EndIf
WEnd

Func init()
	$rallyid = TimerInit()
	$maxa = 7
	$speed[0] = Random(3, $maxa, 1)
	$speed[1] = 5
	$ptime1 = 0
	$rallyt1 = 0
	$rallyt2 = 0
	$rallyt = 0
	$signx = "+"
	If Random(0, 1, 1) = 1 Then
		$signy = "+"
	Else
		$signy = "-"
	EndIf
EndFunc

Func wincheck()
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
			stop()
	EndIf
EndFunc

Func updater()
	If $paused = False Then
		$other = NOT $other
		If $other = False Then
			; Rally Time
			$rallyt1 = TimerDiff($rallyid)
			$rallyt1 = $rallyt1 - $ptime1
			$rallyt1 = $rallyt1 / 1000
			$rallyt2 = $rallyt1 / 60
			;MsgBox(0, "C Pong1", $rallyt1 & ":" & $rallyt2)
			$rallyt1 = StringSplit($rallyt1, ".")
			$rallyt2 = StringSplit($rallyt2, ".")
			$rallyt1 = $rallyt1[1]
			$rallyt2 = $rallyt2[1]
			;MsgBox(0, "C Pong2", $rallyt1 & ":" & $rallyt2)
			$rallyt = $rallyt1
			$rallyt2 = StringSplit($rallyt2 * 60, ".")
			$rallyt2 = $rallyt2[1]
			$rallyt1 = $rallyt1 - $rallyt2
			$rallyt2 = $rallyt2 / 60
			;MsgBox(0, "C Pong3", $rallyt1 & ":" & $rallyt2)
			
			; Total Time
			$overallt1 = TimerDiff($overallid)
			$overallt1 = $overallt1 - $ptime2
			$overallt1 = $overallt1 / 1000
			$overallt2 = $overallt1 / 60
			;MsgBox(0, "C Pong1", $overallt1 & ":" & $overallt2)
			$overallt1 = StringSplit($overallt1, ".")
			$overallt2 = StringSplit($overallt2, ".")
			$overallt1 = $overallt1[1]
			$overallt2 = $overallt2[1]
			;MsgBox(0, "C Pong2", $overallt1 & ":" & $overallt2)
			$overallt = $overallt1
			$overallt2 = StringSplit($overallt2 * 60, ".")
			$overallt2 = $overallt2[1]
			$overallt1 = $overallt1 - $overallt2
			$overallt2 = $overallt2 / 60
			;MsgBox(0, "C Pong3", $overallt1 & ":" & $overallt2)
			
			GUICtrlSetData($Timer1, $rallyt2 & ":" & $rallyt1)
			GUICtrlSetData($Timer2, $overallt2 & ":" & $overallt1)
			GUICtrlSetData($Hitsid, $hits)
			GUICtrlSetData($Missesid, $misses)
			
			; High Scores
			;MsgBox(0, "C Pong", $rallyt)
			If $highscore < $rallyt Then
				$highscore = $rallyt
			EndIf
		EndIf
	EndIf
EndFunc
		
Func ballmove()
	If $paused = False Then
		$now = WinGetPos("           C Pong Ball")
		$next[0] = $now[0] + $speed[0]
		$next[1] = $now[1] + $speed[1]
		;MsgBox(0, "Ball 1", $now[0] & " - " & $now[1])
		$next[0] = Execute($now[0] & $signx & $speed[0])
		$next[1] = Execute($now[1] & $signy & $speed[1])
		;MsgBox(0, "Ball 2", $next[0] & " - " & $next[1])
		ballcheck()
		WinMove("           C Pong Ball", "", $next[0], $next[1])
	EndIf
EndFunc

Func ballcheck()
	If $paused = False Then
		$pad1 = WinGetPos("              C Pong 1")
		$pad2 = WinGetPos("              C Pong 2")
		; Check Y
		If $next[1] < 0 Then
			Sign("y")
		ElseIf $next[1] > $height2 - 10 Then
			Sign("y")
		EndIf
		; Check X
		Switch $signx
			Case "-"
				If $next[0] > $width1 AND $next[0] < $width1 + $padw Then
					If $next[1] > ($pad1[1] - $bsize * 2) AND $next[1] < ($pad1[1] + $padh) Then
						Sign("x")
						$maxa = $maxa + Random(0, 1, 1)
						$speed[0] = $speed[0] + Random(0, 1, 1)
						$speed[1] = Random(1, $maxa, 1)
						$hits = $hits + 1
					EndIf
				EndIf
			Case "+"
				If $next[0] > $width2 - $bsize AND $next[0] < $width2 + $padw Then
					If $next[1] > ($pad2[1] - $bsize * 2) AND $next[1] < ($pad2[1] + $padh) Then
						Sign("x")
						$maxa = $maxa + Random(0, 1, 1)
						$speed[0] = $speed[0] + Random(0, 1, 1)
						$speed[1] = Random(1, $maxa, 1)
						$hits = $hits + 1
					EndIf
				EndIf
		EndSwitch
	EndIf
EndFunc

Func ballscore()
	If $paused = False Then
		Switch $signx
			Case "-"
				If $next[0] < 0 Then
					$misses = $misses + 1
					pause()
					;MsgBox(0, "C Pong", "Current Highscore: " & $highscore)
					MsgBox(0, "C Pong", "Rally Time: " & $rallyt2 & ":" & $rallyt1)
					pause()
					init()
					ballreset()
				EndIf
			Case "+"
				If $next[0] > $width Then
					;$misses = $misses + 1
					pause()
					;MsgBox(0, "C Pong", "Current Highscore: " & $highscore)
					MsgBox(0, "C Pong", "Rally Time: " & $rallyt2 & ":" & $rallyt1)
					pause()
					init()
					ballreset()
				EndIf
		EndSwitch
	EndIf
EndFunc

Func ballreset()
	If $paused = False Then
		WinMove("           C Pong Ball", "", $width / 2 - 10, $height / 2 - 10)
	EndIf
EndFunc

Func Sign($xory)
	If $xory = "x" Then
		If $signx = "+" Then
			$signx = "-"
		Else
			$signx = "+"
		EndIf
	ElseIf $xory = "y" Then
		If $signy = "+" Then
			$signy = "-"
		Else
			$signy = "+"
		EndIf
	Else
		MsgBox(0, "Error", "Error: Sign is not set!")
		stop()
	EndIf
EndFunc

Func start()
	$start = True
EndFunc

Func pause()
	$paused = NOT $paused
	If $paused = True Then
		$ptimeid = TimerInit()
	EndIf
	If $paused = False Then
		$ptime1 = $ptime1 + TimerDiff($ptimeid)
		$ptime2 = $ptime2 + TimerDiff($ptimeid)
	EndIf
EndFunc

Func restart()
	$hits = 0
	$misses = 0
	$ptime2 = 0
	$overallt = 0
	$overallt1 = 0
	$overallt2 = 0
	MsgBox(0, "C Pong", "Hotkeys:" & @CRLF & "Pause: PAGE UP" & @CRLF & "Restart: PAGE Down" & @CRLF & "Exit: END")
	$overallid = TimerInit()
	init()
	ballreset()
EndFunc

Func stop()
	$paused = True
	$highscore1 = $highscore
	$highscore2 = $highscore1 / 60
	;MsgBox(0, "C Pong", $highscore1)
	;MsgBox(0, "C Pong", $highscore2)
	$highscore2 = StringSplit($highscore2, ".")
	$highscore2 = $highscore2[1]
	$highscore2 = StringSplit($highscore2 * 60, ".")
	$highscore2 = $highscore2[1]
	;MsgBox(0, "C Pong", $highscore2)
	$highscore1 = $highscore1 - $highscore2
	$highscore2 = $highscore2 / 60
	$highscore = $highscore2 & ":" & $highscore1
	MsgBox(0, "C Pong", "Your highest rally time was: " & $highscore & @CRLF & "It has been copied to your clipboard.")
	ClipPut("========================" & @CRLF & "-------- C Pong --------" & @CRLF & "========================" & @CRLF & "Longest Rally: " & $highscore & @CRLF & "Hits: " & $hits & @CRLF & "Misses: " & $misses & @CRLF & "Total Time: " & $overallt2 & ":" & $overallt1 & @CRLF & "========================")
	Exit
EndFunc

; Score Board
Func DScore()
	GUISetCursor (3, 1, $main)
	GUISetBkColor(0x000000)
	;Main Title
	$Label5 = GUICtrlCreateLabel("C Pong", $width / 2 - 128, 0, 256, 104)
		GUICtrlSetFont(-1, 60, 800, 0, "Trebuchet MS")
		GUICtrlSetColor(-1, 0xFFFFFF)
	; Numbers
	$Timer1 = GUICtrlCreateLabel("0:00", $width - 297, 22, 120, 88)
		GUICtrlSetFont(-1, 48, 800, 0, "Sylfaen")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Timer2 = GUICtrlCreateLabel("0:00", $width - 144, 22, 120, 88)
		GUICtrlSetFont(-1, 48, 800, 0, "Sylfaen")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Missesid = GUICtrlCreateLabel("000", 147, 22, 103, 88)
		GUICtrlSetFont(-1, 48, 800, 0, "Sylfaen")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Hitsid = GUICtrlCreateLabel("000", 8, 22, 103, 88)
		GUICtrlSetFont(-1, 48, 800, 0, "Sylfaen")
		GUICtrlSetColor(-1, 0xFFFFFF)
	; Titles
	$Label1 = GUICtrlCreateLabel("Rally Time:", $width - 297, 14, 72, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Label3 = GUICtrlCreateLabel("Total Time:", $width - 144, 14, 72, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Label2 = GUICtrlCreateLabel("Hits:", 11, 14, 30, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
	$Label4 = GUICtrlCreateLabel("Misses:", 148, 14, 50, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
EndFunc