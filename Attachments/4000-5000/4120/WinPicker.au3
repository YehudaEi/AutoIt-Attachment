#include <GUIConstants.au3>
$textheight = 20
$offs = 4

Func winpickermain()
	HotKeySet("#x")
	Opt("WinTitleMatchMode", 4)
	Opt("WinWaitDelay",0)
	Dim $wins[100];window names
	Dim $winh[100];window handles
	Dim $cidl[100];control id for labels
	Dim $trans[100];transparency listing
	$winlist = WinList()
	$num = 0
	For $i = 1 To $winlist[0][0]
		If ($winlist[$i][0] <> "" And IsVisible($winlist[$i][1]) And $winlist[$i][0] <> "Program Manager") Then
			$num = $num + 1
			$wins[$num] = $winlist[$i][0]
			$winh[$num] = $winlist[$i][1];get the handles in case of identical names
			$trans[$num] = 254
		EndIf
	Next
	
	
	$mainwin = GUICreate("WinPicker 0.1", 400, 30 + $num * $textheight, -1, -1, -1, $WS_EX_TOPMOST);panel for displaying windows
	GUISetState(@SW_SHOW, $mainwin);
	
	For $i = 1 To $num
		If $wins[$i] <> "" And IsVisible($wins[$i]) Then
			$cidl[$i] = GUICtrlCreateLabel($wins[$i], 5, $i * $textheight) ; next line
		EndIf
	Next
	
	$leaveit = 0
	$Index = 0;
	
	For $i = 1 To $num ; loop to iterate over windows
	;	WinSetTrans($winh[$i],"",254)
	Next	
	
	$Index = 0
	While 1 ; MAIN picker loops
		$msg = GUIGetMsg()
		$mxy = GUIGetCursorInfo($mainwin)
		$Index = 0
		if (($mxy[0] > 0) AND ($mxy[0] < 400)) Then
			If $Index < 0 Then $Index = 0
			If $Index > $num Then $Index = 0
			$Index = Round((($mxy[1]-$offs)/$textheight),0) ; the mouse over this label
		EndIf
		
		Sleep(6)
		For $i = 1 To $num ; loop to iterate over windows for transparency
			$trans[$i] = $trans[$i] - 40
			If $i = $Index Then $trans[$i] = $trans[$i] + 80
			If $trans[$i] < 32 Then $trans[$i] = 32
			If $trans[$i] > 254 Then $trans[$i] = 254
			WinSetTrans($winh[$i],"",$trans[$i])	
		Next
		
		
		For $i = 1 To $num ; loop to iterate over windows
			If ($msg = $cidl[$i]) Then ; if clicked 
				WinWait($winh[$i], "")
				$temp = WinGetState($winh[$i])
				If BitAnd($temp, 16) Then
					WinSetState($temp, "", @SW_RESTORE)
				EndIf
				If Not WinActive($winh[$i], "") Then WinActivate($winh[$i], "")
				WinWaitActive($winh[$i], "")
				$leaveit = 1
			EndIf ;end of if clicked
		Next ;end of window iterate loop
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $leaveit Then ExitLoop
	WEnd

	;; UNDO TRANSPARENCY
	For $k = 1 To 5 ; loop fade from 64 to 256 = 192
		For $i = 1 To $num ; loop to iterate over windows
			$trans[$i] = $trans[$i] + 50
			If $i = $Index Then $trans[$i] = 254
			If $trans[$i] > 254 Then $trans[$i] = 254
			WinSetTrans($winh[$i],"",$trans[$i])
		Next
		sleep(5)
	Next
	
	GUIDelete()
	GUISetState(@SW_HIDE);
	HotKeySet("#x","winpickermain")
EndFunc   ;==>winpickermain

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN 
$stay = 1
HotKeySet("#x","winpickermain")
while $stay
	sleep(66)
WEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func leave()
	$stay=0
EndFunc
Func IsVisible($handle)
	If BitAND( WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible