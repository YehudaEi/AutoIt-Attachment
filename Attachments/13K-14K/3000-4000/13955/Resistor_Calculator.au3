#include <GUIConstants.au3>
AutoItSetOption("GUIOnEventMode", 1)

GUICreate("Resistance Calculator v1.1",500,200)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close_Parent")

GUICtrlCreateLabel("First color :",10,5,100,20,BitOr($GUI_SS_DEFAULT_LABEL,$SS_CENTER))
$1 = GUICtrlCreateCombo ("Black",10,20,100,20,$CBS_DROPDOWN + $CBS_AUTOHSCROLL + $WS_VSCROLL + $CBS_DISABLENOSCROLL + $CBS_SIMPLE)
GUICtrlSetData($1,"Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
GUICtrlSetOnEvent($1, "Calculate")

GUICtrlCreateLabel("Second color :",120,5,100,20,BitOr($GUI_SS_DEFAULT_LABEL,$SS_CENTER))
$2 = GUICtrlCreateCombo ("Black",120,20,100,20,$CBS_DROPDOWN + $CBS_AUTOHSCROLL + $WS_VSCROLL + $CBS_DISABLENOSCROLL + $CBS_SIMPLE)
GUICtrlSetData($2,"Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
GUICtrlSetOnEvent($2, "Calculate")

GUICtrlCreateLabel("Third color :",230,5,100,20,BitOr($GUI_SS_DEFAULT_LABEL,$SS_CENTER))
$3 = GUICtrlCreateCombo ("Black",230,20,100,20,$CBS_DROPDOWN + $CBS_AUTOHSCROLL + $WS_VSCROLL + $CBS_DISABLENOSCROLL + $CBS_SIMPLE)
GUICtrlSetData($3,"Silver|Gold|Black|Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
GUICtrlSetOnEvent($3, "Calculate")

GUICtrlCreateLabel("Fourth color :",340,5,100,20,BitOr($GUI_SS_DEFAULT_LABEL,$SS_CENTER))
$4 = GUICtrlCreateCombo ("Silver",340,20,100,20,$CBS_DROPDOWN + $CBS_AUTOHSCROLL + $WS_VSCROLL + $CBS_DISABLENOSCROLL + $CBS_SIMPLE)
GUICtrlSetData($4,"Gold|Brown|Red")
GUICtrlSetOnEvent($4, "Calculate")

$result_ohm = GUICtrlCreateLabel ("",10,60,300)
$result_kohm = GUICtrlCreateLabel ("",10,80,300)
$result_mohm = GUICtrlCreateLabel ("",10,100,300)
GUISetState (@SW_SHOW)
Calculate()

While 1
	Sleep (100)
WEnd

Func Close_Parent()
	Exit
EndFunc

Func Calculate()
	Switch GUICtrlRead ($1)
		Case "Black"
			$color1 = 0
		Case "Brown"
			$color1 = 1
		Case "Red"
			$color1 = 2
		Case "Orange"
			$color1 = 3
		Case "Yellow"
			$color1 = 4
		Case "Green"
			$color1 = 5
		Case "Blue"
			$color1 = 6
		Case "Violet"
			$color1 = 7
		Case "Gray"
			$color1 = 8
		Case "White"
			$color1 = 9
	EndSwitch
	Switch GUICtrlRead ($2)
		Case "Black"
			$color2 = 0
		Case "Brown"
			$color2 = 1
		Case "Red"
			$color2 = 2
		Case "Orange"
			$color2 = 3
		Case "Yellow"
			$color2 = 4
		Case "Green"
			$color2 = 5
		Case "Blue"
			$color2 = 6
		Case "Violet"
			$color2 = 7
		Case "Gray"
			$color2 = 8
		Case "White"
			$color2 = 9
	EndSwitch
	Switch GUICtrlRead ($3)
		Case "Black"
			$color3 = 1
		Case "Brown"
			$color3 = 10
		Case "Red"
			$color3 = 100
		Case "Orange"
			$color3 = 1000
		Case "Yellow"
			$color3 = 10000
		Case "Green"
			$color3 = 100000
		Case "Blue"
			$color3 = 1000000
		Case "Violet"
			$color3 = 10000000
		Case "Gray"
			$color3 = 100000000
		Case "White"
			$color3 = 1000000000
		Case "Silver"
			$color3 = 0.01
		Case "Gold"
			$color3 = 0.1
	EndSwitch
	Switch GUICtrlRead ($4)
		Case "Silver"
			$tol = "+- 10%"
		Case "Gold"
			$tol = "+- 5%"
		Case "Brown"
			$tol = "+- 1%"
		Case "Red"
			$tol = "+- 2%"			
	EndSwitch
		$ohm = ($color1 *10 + $color2) * $color3
		$kohm = $ohm / 1000
		$mohm = $kohm / 1000
		GUICtrlSetData($result_ohm,$ohm & " Ohm " & $tol)
		If $ohm > 1000 Then
			GUICtrlSetData($result_kohm,$kohm & " KOhm " & $tol)
		Else
			GUICtrlSetData($result_kohm,"")
		EndIf
		If $kohm > 1000 Then
			GUICtrlSetData($result_mohm,$mohm & " MOhm " & $tol)
		Else
			GUICtrlSetData($result_mohm,"")
		EndIf
EndFunc