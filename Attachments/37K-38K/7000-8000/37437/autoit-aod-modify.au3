#include <Misc.au3>
WinWaitActive("FairyLand")
WinMove("FairyLand","",0,0)
AutoItSetOption ("SendKeyDelay",100)
AutoItSetOption ("SendKeyDownDelay",100)
HotKeySet("{F1}","dopause")
HotKeySet("{ESC}","doexit") 
WinSetOnTop("FairyLand","",1)
$mousetrap=WinGetPos("FairyLand")
_MouseTrap($mousetrap[0]+5,$mousetrap[1]+30,($mousetrap[0]+$mousetrap[2])-5,($mousetrap[1]+$mousetrap[3])-5)
Dim $posmonster[2][10]
Dim $monster[10]	
Global $defultnomonster=Int(PixelChecksum(245,44,250,44))
Global $paused
Global $usepotionhp=0
Global $sleep=100
Global $randomwalk=1
Global $attack=1
Global $useskill=1
Global $petcombat=0

memposmonster()

While 1
	WinSetOnTop("FairyLand","",1)
	Local $mousetrap=WinGetPos("FairyLand")
	_MouseTrap($mousetrap[0]+5,$mousetrap[1]+30,($mousetrap[0]+$mousetrap[2])-5,($mousetrap[1]+$mousetrap[3])-5)
	downcpu()
	main()
WEnd

Func memposmonster()
	Local $x=72
	Local $y=54
	Local $backx=426
	Local $backy=94
	For $loop=0 To 4 Step 1
		$posmonster[0][$loop]=$backx-$x
		$posmonster[1][$loop]=$backy+$y
		$backx=$backx-$x
		$backy=$backy+$y
	Next
	Local $fontx=60
	Local $fonty=478
	For $loop=5 To 9 Step 1
		$posmonster[0][$loop]=$fontx+$x
		$posmonster[1][$loop]=$fonty-$y
		$fontx=$fontx+$x
		$fonty=$fonty-$y
	Next
EndFunc

Func main()
	checkdie()
	Local $manymonster=0
	If $defultnomonster<>Int(PixelChecksum(245,44,250,44)) Then
		;Sleep(2000)
		If $defultnomonster<>Int(PixelChecksum(245,44,250,44)) Then
			downcpu()
			If $attack=0 Then
				dodge()
			Else
				findpositionmonster()
			EndIf
			For $loop=0 To 9 Step 1
				If $monster[$loop]=1 Then
					$manymonster=$manymonster+1
				Else
				EndIf
			Next
			If $manymonster=0 Then
			Else
				If $attack=1 Then
					;LM()
					checkmp()
					attack()
				Else
				EndIf
				$manymonster=0
			EndIf
			checkmp()
			;checkhp()
		Else
		EndIf
		If $randomwalk=1 Then
			checkmp()
			randomwalk()
		Else
		EndIf
	Else
		checkmp()
		;checkhp()
		If $randomwalk=1 Then
			randomwalk()
		Else
		EndIf
	EndIf
EndFunc

Func randomwalk()
	;Local $x=72
	;Local $y=54
	;Local $moveX=Int(Random(184,616))
	;While ($moveX<184 Or $moveX>328) And ($moveX<472 Or $moveX>616)
	;	If ($moveX<184 Or $moveX>328) And ($moveX<472 Or $moveX>616) Then
	;		$moveX=Int(Random(184,616))
	;	Else
	;		ExitLoop
	;	EndIf
	;WEnd
	;Local $moveY=Int(Random(84,516))
	;While ($moveY<138 Or $moveY>246) And ($moveY<354 Or $moveY>462)
	;	If ($moveY<138 Or $moveY>246) And ($moveY<354 Or $moveY>462) Then
	;		$moveY=Int(Random(138,462))
	;	Else
	;		ExitLoop
	;	EndIf
	;WEnd
	checkdie()
	DarkRitual()
	;While True
	;	If Int(PixelChecksum($moveX,$moveY,$moveX,$moveY))=Int(196609) Then
	;		$moveX=Int(Random(184,616))
	;		$moveY=Int(Random(84,516))
	;	Else
	;		MouseClick("LEFT",$moveX,$moveY,3,0)
	;		MouseMove(400,350,0)
	;		ExitLoop
	;	EndIf
	;WEnd
EndFunc

Func findpositionmonster()
	checkdie()
	downcpu()
	For $loop=0 To 9 Step 1
		MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
		Sleep(60)
		If Int(PixelChecksum(26,609,142,609))=Int(4179088655) Then
			$monster[$loop]=0
		Else
			If Int(PixelChecksum(26,609,142,609))=Int(3440759431) Then
				$monster[$loop]=1
			Else
				$monster[$loop]=1
			EndIf
		EndIf
	Next
EndFunc

Func attack()
	If $useskill=1 Then
		For $loop=0 To 9 Step 1
			checkdie()
			If $monster[$loop]=1 Then
				MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
				downcpu()
				While Int(PixelChecksum(26,609,142,609))<>Int(4179088655)
					If Int(PixelChecksum(34,71,104,71))=Int(0) Then ;CHECK MP
						MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
						downcpu()
						If Int(PixelChecksum(34,71,104,71))=Int(0) Then ;CHECK MP
							MouseClick("LEFT",$posmonster[0][$loop],$posmonster[1][$loop],2,0)
						Else
							While True
								checkdie()
								downcpu()
								If Int(PixelChecksum(26,609,142,609))=Int(4179088655) Then ;NO MONSTER
									ExitLoop
								ElseIf Int(PixelChecksum(782,94,782,94))=Int(80806516) Then ;DODGE PIC SHOW
									Send("{F6}",0)
									MouseClick("LEFT",$posmonster[0][$loop],$posmonster[1][$loop],2,0)
									downcpu()
									If $petcombat=1 Then
										petcombatattack($posmonster[0][$loop],$posmonster[1][$loop])
									Else
									EndIf
								Else
									ExitLoop
								EndIf
							WEnd
						EndIf
					Else
						Send("{F7}",0)
						;findpositionmonster()
						If Int(PixelChecksum(54,59,104,59))=Int(2267578394) Then
							;duringfightingcheckhp()
						Else
							MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
							downcpu()
							If Int(PixelChecksum(34,70,104,70))=Int(0) Then ;CHECK MP
								MouseClick("LEFT",$posmonster[0][$loop],$posmonster[1][$loop],2,0)
							Else
								While True
									downcpu()
									If Int(PixelChecksum(26,609,142,609))=Int(4179088655) Then ;NO MONSTER
										ExitLoop
									ElseIf Int(PixelChecksum(782,94,782,94))=Int(80806516) Then ;DODGE PIC SHOW
										Send("{F6}",0)
										MouseClick("LEFT",$posmonster[0][$loop],$posmonster[1][$loop],2,0)
										downcpu()
										If $petcombat=1 Then
										petcombatattack($posmonster[0][$loop],$posmonster[1][$loop])
										Else
										EndIf
									Else
										ExitLoop
									EndIf
								WEnd
							EndIf
						EndIf
					EndIf
				WEnd
				$monster[$loop]=0
			Else
				$monster[$loop]=0
			EndIf
		Next
		For $loop=0 To 9 Step 1
			$monster[$loop]=0
		Next
		Sleep(100)
		;While Int(PixelChecksum(400,400,400,400))=Int(96207565)
		;	MouseMove(502,442,0)
		;	MouseClick("LEFT")
		;WEnd
	Else
		For $loop=0 To 9 Step 1
			checkdie()
			;duringfightingcheckhp()
			If $monster[$loop]=1 Then
				MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
				downcpu()
				While Int(PixelChecksum(26,609,142,609))<>Int(4179088655)
					MouseMove($posmonster[0][$loop],$posmonster[1][$loop],0)
					While True
						downcpu()
						If Int(PixelChecksum(26,609,142,609))=Int(4179088655) Then ;NO MONSTER
							ExitLoop
						ElseIf Int(PixelChecksum(782,94,782,94))=Int(80806516) Then ;DODGE PIC SHOW
							MouseClick("LEFT",$posmonster[0][$loop],$posmonster[1][$loop],3,0)
							downcpu()
							If $petcombat=1 Then
								petcombatattack($posmonster[0][$loop],$posmonster[1][$loop])
							Else
							EndIf
						Else
							ExitLoop
						EndIf
					WEnd
				WEnd
				$monster[$loop]=0
			Else
				$monster[$loop]=0
			EndIf
		Next
		For $loop=0 To 9 Step 1
			$monster[$loop]=0
		Next
		Sleep(100)
		While Int(PixelChecksum(400,400,400,400))=Int(96207565)
			MouseMove(502,442,0)
			MouseClick("LEFT")
		WEnd
	EndIf
EndFunc

Func dodge()
	While True
		If Int(PixelChecksum(782,94,782,94))=Int(80806516) Then
			While Int(PixelChecksum(782,94,782,94))=Int(80806516)
				MouseMove(782,94,0)
				MouseClick("LEFT")
			WEnd
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func checkmp()
	Local $fullmp=Int(3864285405)
	If Int(PixelChecksum(44,50,104,50))=Int(1631561726) Then
		While Int(PixelChecksum(44,50,104,50))<>$fullmp
			Send("{F12}",0)
			Sleep(1000)
		WEnd
	Else
	EndIf
EndFunc

Func checkhp()
	If Int(PixelChecksum(34,38,104,38))=Int(299150486) Then
		While Int(PixelChecksum(34,38,104,38))<>Int(3496232514)
			downcpu()
			If $usepotionhp=1 Then
				Send("{F11}",0)
			Else
				MouseMove(400,350,0)
				Send("{F9}",0)
				MouseClick("LEFT")
			EndIf
		WEnd
	Else
	EndIf
EndFunc

Func checkdie()
	downcpu()
	If Int(PixelChecksum(752,136,752,136))=Int(96731845) And Int(PixelChecksum(40,132,40,132))=Int(67174945) Then ;Rainbow hospital
		dopause()
	Else
	EndIf
EndFunc

Func duringfightingcheckhp()
	If Int(PixelChecksum(54,59,104,59))=Int(2267578394) Then
		While Int(PixelChecksum(54,59,104,59))<>Int(362702592)
			While True
				If Int(PixelChecksum(26,609,142,609))=Int(4179088655) Then ;NO MONSTER
					ExitLoop
				ElseIf Int(PixelChecksum(782,94,782,94))=Int(80806516) Then ;DODGE PIC SHOW
					Regeneration()
					If $petcombat=1 Then
						petcombatdodge()
					Else
					EndIf
				Else
					ExitLoop
				EndIf
			WEnd
		WEnd
	Else
	EndIf
EndFunc
	
Func downcpu()
	Sleep($sleep)
EndFunc

Func petcombatdodge()
	While Int(PixelChecksum(782,94,782,94))=Int(80806516)
		If Int(PixelChecksum(782,94,782,94))=Int(80806516) Then
			MouseMove(782,94,0)
			MouseClick("LEFT")
			downcpu()
			MouseMove(594,474,0)
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func petcombatattack($posx,$posy)
	While Int(PixelChecksum(782,94,782,94))=Int(80806516)
		If Int(PixelChecksum(782,94,782,94))=Int(80806516) Then
			MouseClick("LEFT",$posx,$posy,2,0)
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func dopause()
	Local $mousetrap=WinGetPos("FairyLand")
    $paused=Not $paused
    While $paused
		WinSetOnTop("FairyLand","",0)
		_MouseTrap()
		downcpu()
    WEnd
	WinSetOnTop("FairyLand","",1)
	_MouseTrap($mousetrap[0]+5,$mousetrap[1]+30,($mousetrap[0]+$mousetrap[2])-5,($mousetrap[1]+$mousetrap[3])-5)
EndFunc

Func doexit()
	WinSetOnTop("FairyLand","",0)
	_MouseTrap()
	Exit
EndFunc

;SKILL
Func Regeneration()
	MouseMove(594,474,0)
	Send("{F5}",0)
	MouseClick("LEFT")
EndFunc

Func DarkRitual()
	checkmp()
	Send("{F7}",0)
	Sleep(100)
EndFunc

Func LM()
	While True
		If Int(PixelChecksum(54,59,104,59))=Int(2267578394) Then
			duringfightingcheckhp()
		Else
			If Int(PixelChecksum(44,71,44,71))=Int(92078786) Then
				attack()
				Send("{F11}",0)
				checkmp()
				ExitLoop
			Else
				If Int(PixelChecksum(782,94,782,94))=Int(80806516) Then
					MouseMove(594,474,0)
					Send("{F5}",0)
					MouseClick("LEFT")
				Else
				EndIf
			EndIf
		EndIf
	WEnd
EndFunc


