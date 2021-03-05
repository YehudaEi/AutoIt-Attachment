
Global $Y1 = 288, $Y2 = $Y1+5, $Y3 = $Y2+1, $Y4 = $Y3+5, $Y5 = $Y4+1, $Y6 = $Y5+5
Global $XT1 = 44, $XT2 = 81, $XT3 = 118, $XT4 = 155, $XT5 = 190
Global $Terning1, $Terning2, $Terning3, $Terning4, $Terning5
Global $Shader = 1, $Color = 0x000100

HotKeySet("{NUMPAD1}", "Start")
HotKeySet("{NUMPAD2}", "Stop")
HotKeySet("{NUMPAD3}", "Pause")

Pause()
Func Pause()
While 1
	Sleep (10)
WEnd
EndFunc

Func Start()
	Terning1()
Endfunc

Func Stop()
	Exit 0
EndFunc

Func Terning1()
	Local $XT = $XT1
	Local $Terning, $Dice = 1
	Global $Terning1

	;Table - Just for overview
Local $PS1 = PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ; Buttom 1/3, Left side
Local $PS2 = PixelSearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ; Mid 1/3, Mid
Local $PS3 = PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Mid 1/3, Right side
Local $PS4 = PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Buttom 1/3, Right side

	;Script
Pixelsearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Mid 1/3, Mid
if True Then ; 1, 3, 5
	PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Buttom 1/3, Left side
	If True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Buttom 1/3, Right side
		If True Then
			$Terning = 5
		ElseIf Not True Then
			$Terning = 3
		EndIf

	ElseIf Not True Then
		$Terning = 1
	EndIf
ElseIf Not True Then ; 2, 4, 6
	PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Mid 1/3, Right side
	If True Then
		$Terning = 6
	ElseIf Not True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader);Buttom 1/3, Right side
		If True Then
			$Terning = 4
		ElseIf Not True Then
			PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader);Buttom 1/3, Left side
			If True Then
				$Terning = 2
			ElseIf Not True Then
				msgbox(1, "Error", "Error don't recognize dice - dice number: " & $Dice)
			EndIf
		EndIf
	EndIf
EndIf
$Terning1 = $Terning
Terning2()
Endfunc

Func Terning2()
	Local $XT = $XT2
	Local $Terning, $Dice = 2
	Global $Terning2

	;Tabel - Skal ikke bruges
Local $PS1 = PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
Local $PS2 = PixelSearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
Local $PS3 = PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
Local $PS4 = PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side

	;Script
Pixelsearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
if True Then ; 1, 3, 5
	PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
	If True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side
		If True Then
			$Terning = 5
		ElseIf Not True Then
			$Terning = 3
		EndIf

	ElseIf Not True Then
		$Terning = 1
	EndIf
ElseIf Not True Then ; 2, 4, 6
	PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
	If True Then
		$Terning = 6
	ElseIf Not True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader)
		If True Then
			$Terning = 4
		ElseIf Not True Then
			PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader)
			If True Then
				$Terning = 2
			ElseIf Not True Then
				msgbox(1, "Error", "Error don't recognize dice - dice number: " & $Dice)
			EndIf
		EndIf
	EndIf
EndIf
$Terning2 = $Terning
Terning3()
Endfunc

Func Terning3()
	Local $XT = $XT3
	Local $Terning, $Dice = 3
	Global $Terning3

	;Tabel - Skal ikke bruges
Local $PS1 = PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
Local $PS2 = PixelSearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
Local $PS3 = PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
Local $PS4 = PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side

	;Script
Pixelsearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
if True Then ; 1, 3, 5
	PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
	If True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side
		If True Then
			$Terning = 5
		ElseIf Not True Then
			$Terning = 3
		EndIf

	ElseIf Not True Then
		$Terning = 1
	EndIf
ElseIf Not True Then ; 2, 4, 6
	PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
	If True Then
		$Terning = 6
	ElseIf Not True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader)
		If True Then
			$Terning = 4
		ElseIf Not True Then
			PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader)
			If True Then
				$Terning = 2
			ElseIf Not True Then
				msgbox(1, "Error", "Error don't recognize dice - dice number: " & $Dice)
			EndIf
		EndIf
	EndIf
EndIf
$Terning3 = $Terning
Terning4()
Endfunc

Func Terning4()
	Local $XT = $XT4
	Local $Terning, $Dice = 4
	Global $Terning4

	;Tabel - Skal ikke bruges
Local $PS1 = PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
Local $PS2 = PixelSearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
Local $PS3 = PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
Local $PS4 = PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side

	;Script
Pixelsearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
if True Then ; 1, 3, 5
	PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
	If True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side
		If True Then
			$Terning = 5
		ElseIf Not True Then
			$Terning = 3
		EndIf

	ElseIf Not True Then
		$Terning = 1
	EndIf
ElseIf Not True Then ; 2, 4, 6
	PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
	If True Then
		$Terning = 6
	ElseIf Not True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader)
		If True Then
			$Terning = 4
		ElseIf Not True Then
			PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader)
			If True Then
				$Terning = 2
			ElseIf Not True Then
				msgbox(1, "Error", "Error don't recognize dice - dice number: " & $Dice)
			EndIf
		EndIf
	EndIf
EndIf
$Terning4 = $Terning
Terning5()
Endfunc

Func Terning5()
	Local $XT = $XT5
	Local $Terning, $Dice = 5
	Global $Terning5

	;Tabel - Skal ikke bruges
Local $PS1 = PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
Local $PS2 = PixelSearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
Local $PS3 = PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
Local $PS4 = PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side

	;Script
Pixelsearch($XT+1+5, $Y3, $XT+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Midt
if True Then ; 1, 3, 5
	PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader) ;Nederst 1/3, Venstre side
	If True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader) ;Nederste 1/3, Højre side
		If True Then
			$Terning = 5
		ElseIf Not True Then
			$Terning = 3
		EndIf

	ElseIf Not True Then
		$Terning = 1
	EndIf
ElseIf Not True Then ; 2, 4, 6
	PixelSearch($XT+1+5+1+5, $Y3, $XT+1+5+1+5+5, $Y4, $Color, $Shader) ;Midterste 1/3, Højre side
	If True Then
		$Terning = 6
	ElseIf Not True Then
		PixelSearch($XT+1+5+1+5, $Y5, $XT+1+5+1+5+5, $Y6, $Color, $Shader)
		If True Then
			$Terning = 4
		ElseIf Not True Then
			PixelSearch($XT, $Y5, $XT+5, $Y6, $Color, $Shader)
			If True Then
				$Terning = 2
			ElseIf Not True Then
				msgbox(1, "Error", "Error don't recognize dice - dice number: " & $Dice)
			EndIf
		EndIf
	EndIf
EndIf
$Terning5 = $Terning
msgbox(1, "Terning 1", "Terning 1: " & $Terning1)
msgbox(1, "Terning 2", "Terning 2: " & $Terning2)
msgbox(1, "Terning 3", "Terning 3: " & $Terning3)
msgbox(1, "Terning 4", "Terning 4: " & $Terning4)
msgbox(1, "Terning 5", "Terning 5: " & $Terning5)
Endfunc

