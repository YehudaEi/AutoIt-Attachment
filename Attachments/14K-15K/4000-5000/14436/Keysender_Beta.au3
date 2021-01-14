;---------------------------------------------
;Author: Eric1
;Date Started: May 1st, 2007
;---------------------------------------------
;Title: Pass-hacker
;Does: Sends keys in a specific order to an app of your choice
;---------------------------------------------
;-------BETA-TEST---WARNING---BETA-TEST-------

HotKeySet("{Esc}", escape()) ; sets the hotkey to escape

$messagebox1 = MsgBox(1, "Code", "You probably want to check out the code and form it to your needs. It might be a little Buggy. Ok to continue, Cancel to exit.")
If $messagebox1 = 2 Then
	Exit
ElseIf $messagebox1 = 1 Then
	MsgBox(1, "Cool", "Great, you chose to continue.")
EndIf

MsgBox(0, "Run an app?", "Would you like to run an application? If so, do it now. Press 'OK' when your application is open.")

;-------------------------------GUI BELOW-----------------------------------------

#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Eric1 - Keysender - Beta", 208, 77, 193, 115, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
GUISetIcon("C:\Program Files\Windows NT\Pinball\PINBALL.EXE")
GUISetBkColor(0x3D95FF)
$list = GUICtrlCreateCombo("# of digits", 0, 0, 73, 25)
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25")
$slp = GUICtrlCreateInput("Wait - in seconds", 72, 0, 97, 21)
GUICtrlSetCursor($slp, 5)
$go = GUICtrlCreateButton("Begin", 0, 24, 169, 25, 0)
GUICtrlSetCursor($go, 0)
$Label1 = GUICtrlCreateLabel("To leave at ant time, press escape", 0, 56, 167, 17)
GUICtrlSetBkColor(-1, 0x3D95FF)
$exit = GUICtrlCreateButton("Exit", 176, 0, 25, 73, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $nMsg = $go
			MsgBox(0, "Note:", "Press escape at any time to exit.", 3000)
			$slp = $slp * 1000
			MsgBox(0, "Ready?", "Are you ready? The keysender will wait the ammount of seconds you entered, then send keystrokes.")
			Sleep($slp)
			GUICtrlRead($list)
			If $list = 1 Then
				one()
			ElseIf $list = 2 Then
				one()
				two()
			ElseIf $list = 3 Then
				one()
				two()
				three()
			ElseIf $list = 4 Then
				one()
				two()
				three()
				four()
			ElseIf $list = 5 Then
				one()
				two()
				three()
				four()
				five()
			ElseIf $list = 6 Then
				one()
				two()
				three()
				four()
				five()
				six()
			ElseIf $list = 7 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
			ElseIf $list = 8 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
			ElseIf $list = 9 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
			ElseIf $list = 10 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
			ElseIf $list = 11 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
			ElseIf $list = 12 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
			ElseIf $list = 13 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
			ElseIf $list = 14 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
			ElseIf $list = 15 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
			ElseIf $list = 16 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
			ElseIf $list = 17 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
			ElseIf $list = 18 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
			ElseIf $list = 19 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
			ElseIf $list = 20 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
			ElseIf $list = 21 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
				twentyone()
			ElseIf $list = 22 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
				twentyone()
				twentytwo()
			ElseIf $list = 23 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
				twentyone()
				twentytwo()
				twentythree()
			ElseIf $list = 24 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
				twentyone()
				twentytwo()
				twentythree()
				twentyfour()
			ElseIf $list = 25 Then
				one()
				two()
				three()
				four()
				five()
				six()
				seven()
				eight()
				nine()
				ten()
				eleven()
				twelve()
				thirteen()
				fourteen()
				fifteen()
				sixteen()
				seventeen()
				eighteen()
				nineteen()
				twenty()
				twentyone()
				twentytwo()
				twentythree()
				twentyfour()
				twentyfive()
			EndIf

	EndSwitch
WEnd
;-------------------------------GUI ABOVE-----------------------------------------

;-------------------------------FUNCS BELOW---------------------------------------

Func one()
	var()
	For $a = 33 To 122 Step 1
		Send(Chr($a))
		Send("{enter}")
		Send("{enter}")
	Next
EndFunc   ;==>one

Func two()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			Send(Chr($a))
			Send(Chr($b))
			Send("{enter}")
			Send("{enter}")
		Next
	Next
EndFunc   ;==>two

Func three()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				Send(Chr($a))
				Send(Chr($b))
				Send(Chr($c))
				Send("{enter}")
				Send("{enter}")
			Next
		Next
	Next
EndFunc   ;==>three

Func four()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					Send(Chr($a))
					Send(Chr($b))
					Send(Chr($c))
					Send(Chr($d))
					Send("{enter}")
					Send("{enter}")
				Next
			Next
		Next
	Next
EndFunc   ;==>four

Func five()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						Send(Chr($a))
						Send(Chr($b))
						Send(Chr($c))
						Send(Chr($d))
						Send(Chr($e))
						Send("{enter}")
						Send("{enter}")
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>five

Func six()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							Send(Chr($a))
							Send(Chr($b))
							Send(Chr($c))
							Send(Chr($d))
							Send(Chr($e))
							Send(Chr($f))
							Send("{enter}")
							Send("{enter}")
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>six

Func seven()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								Send(Chr($a))
								Send(Chr($b))
								Send(Chr($c))
								Send(Chr($d))
								Send(Chr($e))
								Send(Chr($f))
								Send(Chr($g))
								Send("{enter}")
								Send("{enter}")
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>seven

Func eight()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									Send(Chr($a))
									Send(Chr($b))
									Send(Chr($c))
									Send(Chr($d))
									Send(Chr($e))
									Send(Chr($f))
									Send(Chr($g))
									Send(Chr($h))
									Send("{enter}")
									Send("{enter}")
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>eight

Func nine()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										Send(Chr($a))
										Send(Chr($b))
										Send(Chr($c))
										Send(Chr($d))
										Send(Chr($e))
										Send(Chr($f))
										Send(Chr($g))
										Send(Chr($h))
										Send(Chr($i))
										Send("{enter}")
										Send("{enter}")
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>nine

Func ten()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											Send(Chr($a))
											Send(Chr($b))
											Send(Chr($c))
											Send(Chr($d))
											Send(Chr($e))
											Send(Chr($f))
											Send(Chr($g))
											Send(Chr($h))
											Send(Chr($i))
											Send(Chr($j))
											Send("{enter}")
											Send("{enter}")
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>ten

Func eleven()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												Send(Chr($a))
												Send(Chr($b))
												Send(Chr($c))
												Send(Chr($d))
												Send(Chr($e))
												Send(Chr($f))
												Send(Chr($g))
												Send(Chr($h))
												Send(Chr($i))
												Send(Chr($j))
												Send(Chr($k))
												Send("{enter}")
												Send("{enter}")
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>eleven

Func twelve()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													Send(Chr($a))
													Send(Chr($b))
													Send(Chr($c))
													Send(Chr($d))
													Send(Chr($e))
													Send(Chr($f))
													Send(Chr($g))
													Send(Chr($h))
													Send(Chr($i))
													Send(Chr($j))
													Send(Chr($k))
													Send(Chr($l))
													Send("{enter}")
													Send("{enter}")
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twelve

Func thirteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														Send(Chr($a))
														Send(Chr($b))
														Send(Chr($c))
														Send(Chr($d))
														Send(Chr($e))
														Send(Chr($f))
														Send(Chr($g))
														Send(Chr($h))
														Send(Chr($i))
														Send(Chr($j))
														Send(Chr($k))
														Send(Chr($l))
														Send(Chr($m))
														Send("{enter}")
														Send("{enter}")
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>thirteen

Func fourteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															Send(Chr($a))
															Send(Chr($b))
															Send(Chr($c))
															Send(Chr($d))
															Send(Chr($e))
															Send(Chr($f))
															Send(Chr($g))
															Send(Chr($h))
															Send(Chr($i))
															Send(Chr($j))
															Send(Chr($k))
															Send(Chr($j))
															Send(Chr($m))
															Send(Chr($n))
															Send("{enter}")
															Send("{enter}")
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>fourteen

Func fifteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																Send(Chr($a))
																Send(Chr($b))
																Send(Chr($c))
																Send(Chr($d))
																Send(Chr($e))
																Send(Chr($f))
																Send(Chr($g))
																Send(Chr($h))
																Send(Chr($i))
																Send(Chr($j))
																Send(Chr($k))
																Send(Chr($j))
																Send(Chr($m))
																Send(Chr($n))
																Send(Chr($o))
																Send("{enter}")
																Send("{enter}")
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>fifteen

Func sixteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	Send(Chr($a))
																	Send(Chr($b))
																	Send(Chr($c))
																	Send(Chr($d))
																	Send(Chr($e))
																	Send(Chr($f))
																	Send(Chr($g))
																	Send(Chr($h))
																	Send(Chr($i))
																	Send(Chr($j))
																	Send(Chr($k))
																	Send(Chr($j))
																	Send(Chr($m))
																	Send(Chr($n))
																	Send(Chr($o))
																	Send(Chr($p))
																	Send("{enter}")
																	Send("{enter}")
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>sixteen

Func seventeen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		Send(Chr($a))
																		Send(Chr($b))
																		Send(Chr($c))
																		Send(Chr($d))
																		Send(Chr($e))
																		Send(Chr($f))
																		Send(Chr($g))
																		Send(Chr($h))
																		Send(Chr($i))
																		Send(Chr($j))
																		Send(Chr($k))
																		Send(Chr($j))
																		Send(Chr($m))
																		Send(Chr($n))
																		Send(Chr($o))
																		Send(Chr($p))
																		Send(Chr($q))
																		Send("{enter}")
																		Send("{enter}")
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>seventeen

Func eighteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			Send(Chr($a))
																			Send(Chr($b))
																			Send(Chr($c))
																			Send(Chr($d))
																			Send(Chr($e))
																			Send(Chr($f))
																			Send(Chr($g))
																			Send(Chr($h))
																			Send(Chr($i))
																			Send(Chr($j))
																			Send(Chr($k))
																			Send(Chr($j))
																			Send(Chr($m))
																			Send(Chr($n))
																			Send(Chr($o))
																			Send(Chr($p))
																			Send(Chr($q))
																			Send(Chr($r))
																			Send("{enter}")
																			Send("{enter}")
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>eighteen

Func nineteen()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				Send(Chr($a))
																				Send(Chr($b))
																				Send(Chr($c))
																				Send(Chr($d))
																				Send(Chr($e))
																				Send(Chr($f))
																				Send(Chr($g))
																				Send(Chr($h))
																				Send(Chr($i))
																				Send(Chr($j))
																				Send(Chr($k))
																				Send(Chr($j))
																				Send(Chr($m))
																				Send(Chr($n))
																				Send(Chr($o))
																				Send(Chr($p))
																				Send(Chr($q))
																				Send(Chr($r))
																				Send(Chr($s))
																				Send("{enter}")
																				Send("{enter}")
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>nineteen

Func twenty()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					Send(Chr($a))
																					Send(Chr($b))
																					Send(Chr($c))
																					Send(Chr($d))
																					Send(Chr($e))
																					Send(Chr($f))
																					Send(Chr($g))
																					Send(Chr($h))
																					Send(Chr($i))
																					Send(Chr($j))
																					Send(Chr($k))
																					Send(Chr($j))
																					Send(Chr($m))
																					Send(Chr($n))
																					Send(Chr($o))
																					Send(Chr($p))
																					Send(Chr($q))
																					Send(Chr($r))
																					Send(Chr($s))
																					Send(Chr($t))
																					Send("{enter}")
																					Send("{enter}")
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twenty

Func twentyone()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					For $u = 33 To 122 Step 1
																						Send(Chr($a))
																						Send(Chr($b))
																						Send(Chr($c))
																						Send(Chr($d))
																						Send(Chr($e))
																						Send(Chr($f))
																						Send(Chr($g))
																						Send(Chr($h))
																						Send(Chr($i))
																						Send(Chr($j))
																						Send(Chr($k))
																						Send(Chr($j))
																						Send(Chr($m))
																						Send(Chr($n))
																						Send(Chr($o))
																						Send(Chr($p))
																						Send(Chr($q))
																						Send(Chr($r))
																						Send(Chr($s))
																						Send(Chr($t))
																						Send(Chr($u))
																						Send("{enter}")
																						Send("{enter}")
																					Next
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twentyone

Func twentytwo()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					For $u = 33 To 122 Step 1
																						For $v = 33 To 122 Step 1
																							Send(Chr($a))
																							Send(Chr($b))
																							Send(Chr($c))
																							Send(Chr($d))
																							Send(Chr($e))
																							Send(Chr($f))
																							Send(Chr($g))
																							Send(Chr($h))
																							Send(Chr($i))
																							Send(Chr($j))
																							Send(Chr($k))
																							Send(Chr($j))
																							Send(Chr($m))
																							Send(Chr($n))
																							Send(Chr($o))
																							Send(Chr($p))
																							Send(Chr($q))
																							Send(Chr($r))
																							Send(Chr($s))
																							Send(Chr($t))
																							Send(Chr($u))
																							Send(Chr($v))
																							Send("{enter}")
																							Send("{enter}")
																						Next
																					Next
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twentytwo

Func twentythree()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					For $u = 33 To 122 Step 1
																						For $v = 33 To 122 Step 1
																							For $w = 33 To 122 Step 1
																								Send(Chr($a))
																								Send(Chr($b))
																								Send(Chr($c))
																								Send(Chr($d))
																								Send(Chr($e))
																								Send(Chr($f))
																								Send(Chr($g))
																								Send(Chr($h))
																								Send(Chr($i))
																								Send(Chr($j))
																								Send(Chr($k))
																								Send(Chr($j))
																								Send(Chr($m))
																								Send(Chr($n))
																								Send(Chr($o))
																								Send(Chr($p))
																								Send(Chr($q))
																								Send(Chr($r))
																								Send(Chr($s))
																								Send(Chr($t))
																								Send(Chr($u))
																								Send(Chr($v))
																								Send(Chr($w))
																								Send("{enter}")
																								Send("{enter}")
																							Next
																						Next
																					Next
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twentythree

Func twentyfour()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					For $u = 33 To 122 Step 1
																						For $v = 33 To 122 Step 1
																							For $w = 33 To 122 Step 1
																								For $x = 33 To 122 Step 1
																									Send(Chr($a))
																									Send(Chr($b))
																									Send(Chr($c))
																									Send(Chr($d))
																									Send(Chr($e))
																									Send(Chr($f))
																									Send(Chr($g))
																									Send(Chr($h))
																									Send(Chr($i))
																									Send(Chr($j))
																									Send(Chr($k))
																									Send(Chr($j))
																									Send(Chr($m))
																									Send(Chr($n))
																									Send(Chr($o))
																									Send(Chr($p))
																									Send(Chr($q))
																									Send(Chr($r))
																									Send(Chr($s))
																									Send(Chr($t))
																									Send(Chr($u))
																									Send(Chr($v))
																									Send(Chr($w))
																									Send(Chr($x))
																									Send("{enter}")
																									Send("{enter}")
																								Next
																							Next
																						Next
																					Next
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twentyfour

Func twentyfive()
	var()
	For $a = 33 To 122 Step 1
		For $b = 33 To 122 Step 1
			For $c = 33 To 122 Step 1
				For $d = 33 To 122 Step 1
					For $e = 33 To 122 Step 1
						For $f = 33 To 122 Step 1
							For $g = 33 To 122 Step 1
								For $h = 33 To 122 Step 1
									For $i = 33 To 122 Step 1
										For $j = 33 To 122 Step 1
											For $k = 33 To 122 Step 1
												For $l = 33 To 122 Step 1
													For $m = 33 To 122 Step 1
														For $n = 33 To 122 Step 1
															For $o = 33 To 122 Step 1
																For $p = 33 To 122 Step 1
																	For $q = 33 To 122 Step 1
																		For $r = 33 To 122 Step 1
																			For $s = 33 To 122 Step 1
																				For $t = 33 To 122 Step 1
																					For $u = 33 To 122 Step 1
																						For $v = 33 To 122 Step 1
																							For $w = 33 To 122 Step 1
																								For $x = 33 To 122 Step 1
																									For $y = 33 To 122 Step 1
																										Send(Chr($a))
																										Send(Chr($b))
																										Send(Chr($c))
																										Send(Chr($d))
																										Send(Chr($e))
																										Send(Chr($f))
																										Send(Chr($g))
																										Send(Chr($h))
																										Send(Chr($i))
																										Send(Chr($j))
																										Send(Chr($k))
																										Send(Chr($j))
																										Send(Chr($m))
																										Send(Chr($n))
																										Send(Chr($o))
																										Send(Chr($p))
																										Send(Chr($q))
																										Send(Chr($r))
																										Send(Chr($s))
																										Send(Chr($t))
																										Send(Chr($u))
																										Send(Chr($v))
																										Send(Chr($w))
																										Send(Chr($x))
																										Send(Chr($y))
																										Send("{enter}")
																										Send("{enter}")
																									Next
																								Next
																							Next
																						Next
																					Next
																				Next
																			Next
																		Next
																	Next
																Next
															Next
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc   ;==>twentyfive

Func var() ;sets all varaibles, a-y, to 33
	$q = 33
	$w = 33
	$e = 33
	$r = 33
	$t = 33
	$y = 33
	$u = 33
	$i = 33
	$o = 33
	$p = 33
	$a = 33
	$s = 33
	$d = 33
	$f = 33
	$g = 33
	$h = 33
	$j = 33
	$k = 33
	$l = 33
	$m = 33
	$x = 33
	$c = 33
	$v = 33
	$b = 33
	$n = 33
EndFunc   ;==>var

Func escape() ; the func for the hotkeyset
	Exit
EndFunc   ;==>escape
;-------------------------------------DONE------------------------------
