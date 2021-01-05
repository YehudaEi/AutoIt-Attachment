#include <GUIConstants.au3>
$textheight = 20
$offs = 4
$hotkey = "#x"

AutoItSetOption("TrayIconDebug",1)

Func winpickermain()
	HotKeySet($hotkey)
	Opt("WinTitleMatchMode", 4)
	Opt("WinWaitDelay",0)
	Dim $wins[100];window names
	Dim $winh[100];window handles
	Dim $cidl[100];control id for labels
	Dim $on[100];sw_show listing
	Dim $onlast[100];previous sw_show listing - setting a full opaque window to opaque flashes.
	Dim $ctrlhighlight[100];keep track of highlighting
	Dim $winsize[4]
	$winlist = WinList()
	$num = 0
	For $i = 1 To $winlist[0][0]
		$winsize = WinGetPos($winlist[$i][1])
		If 1 Then
			If ($winlist[$i][0] <> "" And IsVisible($winlist[$i][1]) And $winlist[$i][0] <> "Program Manager") Then
				$num = $num + 1
				$wins[$num] = $winlist[$i][0]
				$winh[$num] = $winlist[$i][1];get the handles in case of identical names
				$on[$num] = 0
				$onlast[$num] = 0
				$file = FileOpen("c:\list.txt", 1)
				FileWriteLine($file, $winlist[$i][0] & @CRLF)
				FileClose($file)
			EndIf
		EndIf		
	Next
	
	
	$mainwin = GUICreate("WinPicker 0.11", 400, 30 + $num * $textheight, -1, -1, -1, $WS_EX_TOPMOST);panel for displaying windows
	GUISetBkColor (0xFFFFFF)
	GUISetState(@SW_SHOW, $mainwin);
	
	For $i = 1 To $num
		If $wins[$i] <> "" And IsVisible($wins[$i]) Then
			$cidl[$i] = GUICtrlCreateLabel($wins[$i], 5, $i * $textheight) ; next line
			$ctrlhighlight[$i] = 0
			WinSetState($winh[$i], "", @SW_HIDE)
		EndIf
	Next
	
	$leaveit = 0
	$Index = 0;
	dim $chosen
	dim $msg[5]
	$msg[0] = 0
	$msg[0] = 1
	$msg[0] = 2
	$msg[0] = 3
	$msg[0] = 4
	$msg = GUIGetMsg($mainwin)
	while Not $msg;flush gui msg buffer
		$msg = GUIGetMsg($mainwin)
	WEnd
	$Index = 0
	While 1 ; MAIN picker loops
		If not WinActive($mainwin) Then
			WinActivate($mainwin)
		EndIf
		$msg = GUIGetMsg($mainwin)
		$mxy = GUIGetCursorInfo($mainwin)
		$Index = 0
		if (($mxy[0] > 0) AND ($mxy[0] < 400)) Then
			If $Index < 0 Then $Index = 0
			If $Index > $num Then $Index = 0
			$Index = Round((($mxy[1]-$offs)/$textheight),0) ; the mouse over this label
		EndIf
		
		Sleep(6)
		For $i = 1 To $num ; loop to iterate over windows for highlight and showing
			if $i=$index Then
				if $ctrlhighlight[$i] = 0 Then
					GUICtrlSetColor($cidl[$i],"0x8f0000")
					GUICtrlSetBkColor($cidl[$i],"0xFFFF9F")
					$ctrlhighlight[$i] = 1;
					WinSetState($winh[$i], "", @SW_SHOW)
				EndIf
			Else
				If $ctrlhighlight[$i] = 1 Then
					GUICtrlSetColor($cidl[$i],"0x000000")
					GUICtrlSetBkColor($cidl[$i],"0xFFFFFF")
					$ctrlhighlight[$i] = 0;
					WinSetState($winh[$i], "", @SW_HIDE)
				EndIf
			EndIf
		Next
		
		
		For $i = 1 To $num ; loop to iterate over windows
			If (($msg = $cidl[$i]) And ($msg <> 0)) Then ; if clicked 
				WinWait($winh[$i], "")
				$temp = WinGetState($winh[$i])
				If BitAnd($temp, 16) Then
					WinSetState($temp, "", @SW_RESTORE)
				EndIf
				If Not WinActive($winh[$i], "") Then WinActivate($winh[$i], "")
				$chosen = $i
				;WinWaitActive($winh[$i], "") seems to freeze up at times, handle changes on some windows??
				$leaveit = 1
			EndIf ;end of if clicked
		Next ;end of window iterate loop
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $leaveit Then ExitLoop
	WEnd

	GUIDelete()
	GUISetState(@SW_HIDE);
	HotKeySet($hotkey,"winpickermain")

	;; UNDO sw_hide
	For $i = 1 To $num ; loop to iterate over windows
		WinSetState($winh[$i], "", @SW_SHOW)
	Next
	If Not WinActive($winh[$chosen], "") Then WinActivate($winh[$chosen], "");double check that it's activated.
EndFunc   ;==>winpickermain

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN 
$stay = 1
HotKeySet($hotkey,"winpickermain")
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