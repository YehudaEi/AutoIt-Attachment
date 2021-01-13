#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         Maxtreeme

 Script Function:
	Calculating resistance after color codes.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>

GUICreate("Resistance Calculator v1.0",500,200)
$1 = GUICtrlCreateCombo ("First color", 10,10,100,20)
GUICtrlSetData($1,"Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$2 = GUICtrlCreateCombo ("Second color", 120,10,100,20)
GUICtrlSetData($2,"Black|Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$3 = GUICtrlCreateCombo ("Third color", 230,10,100,20)
GUICtrlSetData($3,"Silver|Gold|Black|Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$4 = GUICtrlCreateCombo ("Fourth color", 340,10,100,20)
GUICtrlSetData($4,"Silver|Gold|Brown|Red")
$calc = GUICtrlCreateButton ("Calculate",400,140,70,30)
GUICtrlCreateLabel ("More scripts on: www.scripthut.z1.ro",10,180)

GUISetState (@SW_SHOW)

While 1
    $msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		ExitLoop
	EndIf
	
	If $msg = $calc Then
		$read1 = GUICtrlRead ($1)
		$read2 = GUICtrlRead ($2)
		$read3 = GUICtrlRead ($3)
		$read4 = GUICtrlRead ($4)
		If $read1 = "First color" Or $read2 = "Second color" Or $read3 = "Third color" Or $read4 = "Fourth color" Then
			MsgBox (48,"Resistance Calculator v1.0","You didn't select all the colors!")
		EndIf
		If $read1 = "Brown" Then
			$color1 = 1
		ElseIf $read1 = "Red" Then
			$color1 = 2
		ElseIf $read1 = "Orange" Then
			$color1 = 3
		ElseIf $read1 = "Yellow" Then
			$color1 = 4
		ElseIf $read1 = "Green" Then
			$color1 = 5
		ElseIf $read1 = "Blue" Then
			$color1 = 6
		ElseIf $read1 = "Violet" Then
			$color1 = 7
		ElseIf $read1 = "Gray" Then
			$color1 = 8
		ElseIf $read1 = "White" Then
			$color1 = 9
		EndIf
		
		If $read2 = "Black" Then
			$color2 = 0
		ElseIf $read2 = "Brown" Then
			$color2 = 1
		ElseIf $read2 = "Red" Then
			$color2 = 2
		ElseIf $read2 = "Orange" Then
			$color2 = 3
		ElseIf $read2 = "Yellow" Then
			$color2 = 4
		ElseIf $read2 = "Green" Then
			$color2 = 5
		ElseIf $read2 = "Blue" Then
			$color2 = 6
		ElseIf $read2 = "Violet" Then
			$color2 = 7
		ElseIf $read2 = "Gray" Then
			$color2 = 8
		ElseIf $read2 = "White" Then
			$color2 = 9
		EndIf
		
		If $read3 = "Black" Then
			$color3 = 1
		ElseIf $read3 = "Brown" Then
			$color3 = 10
		ElseIf $read3 = "Red" Then
			$color3 = 100
		ElseIf $read3 = "Orange" Then
			$color3 = 1000
		ElseIf $read3 = "Yellow" Then
			$color3 = 10000
		ElseIf $read3 = "Green" Then
			$color3 = 100000
		ElseIf $read3 = "Blue" Then
			$color3 = 1000000
		ElseIf $read3 = "Violet" Then
			$color3 = 10000000
		ElseIf $read3 = "Gray" Then
			$color3 = 100000000
		ElseIf $read3 = "White" Then
			$color3 = 1000000000
		ElseIf $read3 = "Silver" Then
			$color3 = 0.01
		ElseIf $read3 = "Gold" Then
			$color3 = 0.1
		EndIf
		
		If $read4 = "Silver" Then
			$tol = "+- 10%"
		ElseIf $read4 = "Gold" Then
			$tol = "+- 5%"
		ElseIf $read4 = "Brown" Then
			$tol = "+- 1%"
		ElseIf $read4 = "Red" Then
			$tol = "+- 2%"
		EndIf
		
		If $read1 <> "First color" And $read2 <> "Second color"  And $read3 <> "Third color" And $read4 <> "Fourth color" Then
			$ohm = $color1 & $color2 * $color3
			$kohm = $ohm / 1000
			$mohm = $kohm / 1000
			GUICtrlCreateLabel ($ohm & "  " & $tol & "   Ohm",10,60)
			If $ohm > 1000 Then
				GUICtrlCreateLabel ($kohm & "  " & $tol & "   KOhm",10,80)
			EndIf
			If $kohm > 1000 Then
				GUICtrlCreateLabel ($mohm & "  " & $tol & "   MOhm",10,100)
			EndIf
		EndIf
		
	EndIf		
	Sleep (10)
WEnd

