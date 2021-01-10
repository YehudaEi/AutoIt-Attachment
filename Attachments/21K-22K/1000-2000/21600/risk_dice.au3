#include <Array.au3>
#include <GUIConstants.au3>
;dice
Dim $rd[3], $wd[2]
$w = 0
$r = 0

$main = GUICreate("Risk Dice Calculator", "300", "400", -1, -1, _
		$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$trials = GUICtrlCreateInput("Trials", 10, 20, 100)
$start = GUICtrlCreateButton("Start", 10, 50, 50, 30)
$stop = GUICtrlCreateButton("Stop", 60, 50, 50, 30)
$clear = GUICtrlCreateButton("Clear ->", 30, 300, 50, 30)

;~ --------------------

$live =GUICtrlCreateCheckbox("Live results?", 10, 100, 100, 30, $BS_RIGHTBUTTON)
;~ --------------------

$result = GUICtrlCreateEdit("Result" & @CRLF & @CRLF, 130, 20, 150, 360,$ES_READONLY+$ES_AUTOVSCROLL+$WS_VSCROLL)
$stats = GUICtrlCreateEdit("Stats", 10, 150, 100, 120,$ES_READONLY)
;~ ---------------------

;~ created by bla bla bla
GUICtrlCreateLabel("Created by", 10, 350)
GUICtrlCreateLabel("Johan Gustafsson", 10, 365)



GUISetState($main)
$t=0
While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then Exit
	
	If $msg = $start Then
		$t = GUICtrlRead($trials)
		$t_ = $t
		
		If GUICtrlRead($live) = 1 Then 
			$result_txt = @CRLF & "~~~~~~~~~~~~~~~" & @CRLF
			GUICtrlSetData ($result, $result_txt,1)
		EndIf
		
		$r = 0
		$w = 0
	EndIf
	
	If $msg = $clear Then GUICtrlSetData ($result, "","")
	
	While $t > 0
		$msg = GUIGetMsg()
		$rd[0] = Random(1, 6, 1)
		$rd[1] = Random(1, 6, 1)
		$rd[2] = Random(1, 6, 1)
		
		$wd[0] = Random(1, 6, 1)
		$wd[1] = Random(1, 6, 1)

		
		_ArraySort($rd, 1)
		_ArraySort($wd, 1)

		If $rd[0] > $wd[0] Then
			$r += 1
		Else
			$w += 1
		EndIf

		If $rd[1] > $wd[1] Then
			$r += 1
		Else
			$w += 1
		EndIf

		$t -= 1
		
		If $t = 0 Or $msg = $stop Then
			$stats_txt = "STATS" & @CRLF & "RED: " & $r & @CRLF & "WHITE: " & $w & @CRLF & @CRLF & "RED %: " & Round(100*$r/(($t_-$t)*2),1) & @CRLF & "WHITE %:" & Round(100*$w/(($t_-$t)*2),1) & @CRLF & "Trials: " & $t_-$t & @CRLF
			GUICtrlSetData ($stats, $stats_txt, "")
		EndIf
		
		If GUICtrlRead($live) = 1 Then
				
			$result_txt = "red: " & $rd[0] & "," & $rd[1] & "," & $rd[2] & "  --white: " & $wd[0] & "," & $wd[1] & @CRLF
			GUICtrlSetData ($result, $result_txt,1)
			
			$stats_txt = "STATS" & @CRLF & @CRLF & "RED: " & $r & @CRLF & "WHITE: " & $w & @CRLF & @CRLF & "RED %: " & Round(100*$r/(($t_-$t)*2),1) & @CRLF & "WHITE %:" & Round(100*$w/(($t_-$t)*2),1) & @CRLF & "Trials: " & $t_-$t
			
			GUICtrlSetData ($stats, $stats_txt, "")
		EndIf
		

		If $msg = $stop Then $t=0
		If $msg = $GUI_EVENT_CLOSE Then Exit
		
	WEnd


Wend