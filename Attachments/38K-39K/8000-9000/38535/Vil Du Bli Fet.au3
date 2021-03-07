#include <misc.au3>
#include <Sound.au3>
HotKeySet("{ESC}", "Terminate")



SoundPlay(@ScriptDir & "\Intro.avi", 1)
$1=1
$Qcount=0
$count=1
$countdown=30
$1Used=False
$2Used=False
$3Used=False
$gui=GUICreate("Vil Du Bli Fet?", @DesktopWidth, @DesktopHeight, 0, 0)
$bg=GUICtrlCreatePic(@ScriptDir & "\bg.JPG", 0, 0, @DesktopWidth, @DesktopHeight)
$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100)
$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100)
$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100)
GUISetState(@SW_SHOW)

WHile 1
	$Sound=_SoundOpen(@ScriptDir & "\Mellomtid.wav")
	_SoundPlay($Sound)
	While $1=1
		If _IsPressed('0D') Then
			ExitLoop
		EndIf
	WEnd
	_SoundStop($Sound)
	$Sound=_SoundOpen(@ScriptDir & "\SPM.wav")
	_SoundPlay($Sound)

	If $count=7 Then
		$1Used=False
		$2Used=False
		$3Used=False
		$count=1
		$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100) ;;;;;;;;;;;Nothing Happends
		$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100) ;;;;;;;;;;;Nothing Happends
		$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100) ;;;;;;;;;;;Nothing Happends
	EndIf

	If $count=6 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Nytt Nivå", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\9.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	If $count=5 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Nytt Nivå", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\7.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	If $count=4 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Nytt Nivå", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\5.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	If $count=3 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Nytt Nivå", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\3.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	If $count=2 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Nytt Nivå", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\2.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	If $count=1 Then
		$random=Random(1,10,1)
		$random=1
		If $random=1 Then
			$answer=3
			$cut=1
			$cut2=4
			GUICtrlCreateLabel("Hva er ikke skrevet av Ibsen?", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			Sleep(500)
			While 1
				If _IsPressed('0D') Then
					ExitLoop
				EndIf
			WEnd

			GUICtrlCreateLabel("Vildanden", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Hamlet", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Peer Gynt", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Et Dukkehjem", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=2 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=3 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=4 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=5 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=6 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=7 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=8 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=9 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		If $random=10 Then
			$answer=1
			$cut=1
			$cut2=1
			GUICtrlCreateLabel("Nytt Spørsmål", 230, 500, 900, 70)
			GUICtrlSetFont(-1, 40)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 210, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 620, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)

			GUICtrlCreateLabel("Svar", 730, 695, 400, 30)
			GUICtrlSetFont(-1, 20)
			GUICtrlSetBkColor(-2, "1056323")
			GUICtrlSetColor(-3, 0xffffff)
		EndIf
		$Sound=_SoundOpen(@ScriptDir & "\2.wav")
		_SoundPlay($Sound)
		$count=$count+1
	EndIf

	While $1=1

		If _IsPressed(31) Then
			If $1Used=False Then
				$pic1=GUICtrlCreatePic(@ScriptDir & "\callX.JPG", 5, 5, 100, 100)
				GUISetState(@SW_HIDE, $gui)
				$countdowngui=GUICreate("Countdown", @DesktopWidth+5, @DesktopHeight+30, -5, -30)
				$bg=GUICtrlCreatePic(@ScriptDir & "\Klokke.JPG", 0, 0, @DesktopWidth, @DesktopHeight)
				GUISetState(@SW_SHow, $countdowngui)
					While 1
						If _IsPressed('0D') Then ExitLoop
					WEnd
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Countdown.wav")
					_SoundPlay($Sound)
				WHile 1
					GUICtrlCreateLabel(@CRLF & "          " & $countdown, 0, 0, @DesktopWidth, @DesktopHeight)
					GUICtrlSetFont(-1, 150)
					If $countdown<1 Then ExitLoop
					If $countdown<20 Then Sleep(850)
					If $countdown>19 Then Sleep(940)
					$countdown=$countdown-1
				WEnd
				GUISetState(@SW_Hide, $countdowngui)
				GUISetState(@SW_SHow, $gui)
				$countdown=30
				$1Used=True
				$Sound=_SoundOpen(@ScriptDir & "\2.wav")
				_SoundPlay($Sound)
			EndIf
		EndIf
		If _IsPressed(32) Then
			If $2Used=False Then
			$pic2=GUICtrlCreatePic(@ScriptDir & "\peopleX.JPG", 5, 110, 100, 100)
				GUISetState(@SW_HIDE, $gui)
				$countdowngui=GUICreate("Countdown", @DesktopWidth+5, @DesktopHeight+30, -5, -30)
				GUISetState(@SW_SHow, $countdowngui)
					While 1
						If _IsPressed('0D') Then ExitLoop
					WEnd
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Countdown.wav")
					_SoundPlay($Sound)
				WHile 1
					GUICtrlCreateLabel(@CRLF & "          " & $countdown, 0, 0, @DesktopWidth, @DesktopHeight)
					GUICtrlSetFont(-1, 150)
					If $countdown<1 Then ExitLoop
					If $countdown<20 Then Sleep(850)
					If $countdown>19 Then Sleep(940)
					$countdown=$countdown-1
				WEnd
				GUISetState(@SW_Hide, $countdowngui)
				GUISetState(@SW_SHow, $gui)
				$countdown=30
				$2Used=True
				$Sound=_SoundOpen(@ScriptDir & "\2.wav")
				_SoundPlay($Sound)
			EndIf
		EndIf
		If _IsPressed(33) Then
			$pic3=GUICtrlCreatePic(@ScriptDir & "\5050X.JPG", 5, 215, 100, 100)
			If $3Used=False Then
				If $cut = 1 Then
					GUICtrlCreateLabel("", 210, 620, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut = 2 Then
					GUICtrlCreateLabel("", 210, 695, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut = 3 Then
					GUICtrlCreateLabel("", 730, 620, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut = 4 Then
					GUICtrlCreateLabel("", 730, 695, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut2 = 1 Then
					GUICtrlCreateLabel("", 210, 620, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut2 = 2 Then
					GUICtrlCreateLabel("", 210, 695, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut2 = 3 Then
					GUICtrlCreateLabel("", 730, 620, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				If $cut2 = 4 Then
					GUICtrlCreateLabel("", 730, 695, 400, 30)
					GUICtrlSetFont(-1, 20)
					GUICtrlSetBkColor(-2, "1056323")
				EndIf
				$3Used=True
			EndIf
		EndIf
		If _IsPressed(61) Then
			_SoundStop($Sound)
			If $answer=1 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9R.wav")
					_SoundPlay($Sound)
					Sleep(20000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Win.wav")
					_SoundPlay($Sound)
					Sleep(500)
				EndIf
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				Sleep(8000)
				ExitLoop
			EndIf
			If $answer<>1 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9W.wav")
					_SoundPlay($Sound)
					Sleep(18000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Wrong.wav")
					_SoundPlay($Sound)
				EndIf
				$X=GUICtrlCreateLabel("  X", 0, 0, @DesktopWidth, @DesktopHeight)
				GUICtrlSetFont(-1, 500)
				GUICtrlSetBkColor(-2, 0xff0000)
				Sleep(10000)
				GUICtrlDelete($X)
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				$1Used=False
				$2Used=False
				$3Used=False
				$count=1
				$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100) ;;;;;;;;;;;Nothing Happends
				ExitLoop
			EndIf
		EndIf
		If _IsPressed(62) Then
			_SoundStop($Sound)
			If $answer=2 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9R.wav")
					_SoundPlay($Sound)
					Sleep(20000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Win.wav")
					_SoundPlay($Sound)
					Sleep(500)
				EndIf
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				Sleep(8000)
				ExitLoop
			EndIf
			If $answer<>2 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9W.wav")
					_SoundPlay($Sound)
					Sleep(18000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Wrong.wav")
					_SoundPlay($Sound)
				EndIf
				$X=GUICtrlCreateLabel("  X", 0, 0, @DesktopWidth, @DesktopHeight)
				GUICtrlSetFont(-1, 500)
				GUICtrlSetBkColor(-2, 0xff0000)
				Sleep(10000)
				GUICtrlDelete($X)
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				$1Used=False
				$2Used=False
				$3Used=False
				$count=1
				$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100) ;;;;;;;;;;;Nothing Happends
				ExitLoop
			EndIf
		EndIf
		If _IsPressed(63) Then
			_SoundStop($Sound)
			If $answer=3 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9R.wav")
					_SoundPlay($Sound)
					Sleep(20000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Win.wav")
					_SoundPlay($Sound)
					Sleep(500)
				EndIf
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				Sleep(8000)
				ExitLoop
			EndIf
			If $answer<>3 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9W.wav")
					_SoundPlay($Sound)
					Sleep(18000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Wrong.wav")
					_SoundPlay($Sound)
				EndIf
				$X=GUICtrlCreateLabel("  X", 0, 0, @DesktopWidth, @DesktopHeight)
				GUICtrlSetFont(-1, 500)
				GUICtrlSetBkColor(-2, 0xff0000)
				Sleep(10000)
				GUICtrlDelete($X)
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				$1Used=False
				$2Used=False
				$3Used=False
				$count=1
				$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100) ;;;;;;;;;;;Nothing Happends
				ExitLoop
			EndIf
		EndIf
		If _IsPressed(64) Then
			_SoundStop($Sound)
			If $answer=4 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9R.wav")
					_SoundPlay($Sound)
					Sleep(20000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Win.wav")
					_SoundPlay($Sound)
					Sleep(500)
				EndIf
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				Sleep(8000)
				ExitLoop
			EndIf
			If $answer<>4 Then
				If $count=7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\9W.wav")
					_SoundPlay($Sound)
					Sleep(18000)
				EndIf
				If $count<7 Then
					_SoundStop($Sound)
					$Sound=_SoundOpen(@ScriptDir & "\Wrong.wav")
					_SoundPlay($Sound)
				EndIf
				$X=GUICtrlCreateLabel("  X", 0, 0, @DesktopWidth, @DesktopHeight)
				GUICtrlSetFont(-1, 500)
				GUICtrlSetBkColor(-2, 0xff0000)
				Sleep(10000)
				GUICtrlDelete($X)
				GUICtrlCreateLabel("", 230, 500, 900, 70)
				GUICtrlSetFont(-1, 40)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 210, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 620, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				GUICtrlCreateLabel("", 730, 695, 400, 30)
				GUICtrlSetFont(-1, 20)
				GUICtrlSetBkColor(-2, "1056323")
				$1Used=False
				$2Used=False
				$3Used=False
				$count=1
				$pic1=GUICtrlCreatePic(@ScriptDir & "\call.JPG", 5, 5, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic2=GUICtrlCreatePic(@ScriptDir & "\people.JPG", 5, 110, 100, 100) ;;;;;;;;;;;Nothing Happends
				$pic3=GUICtrlCreatePic(@ScriptDir & "\5050.JPG", 5, 215, 100, 100) ;;;;;;;;;;;Nothing Happends
				ExitLoop
			EndIf
		EndIf
	WEnd
	_SoundStop($Sound)
WEnd

Func Terminate()
	GUISetState(@SW_HIDE)
	GUICreate("slutt", @DesktopWidth+5, @DesktopHeight+30, -5, -30)
	GUICtrlCreatePic(@ScriptDir & "\Sluttbilde.jpg", 0, 0, @DesktopWidth, @DesktopHeight)
	GUICtrlCreateLabel("Laget Av Elias", 0, 0, 400, 50)
	GUICtrlSetFont(-1, 30)
	GUICtrlSetBkColor(-2, 0xffffff)
	GUISetState(@SW_SHOW)
	_SoundStop($Sound)
	$Sound=_SoundOpen(@ScriptDir & "\Slutt.wav")
	_SoundPlay($Sound, 1)
	Exit
EndFunc