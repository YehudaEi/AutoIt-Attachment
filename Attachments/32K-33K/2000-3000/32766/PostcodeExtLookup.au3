#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:         Julian

	Script Postcode to Team Function: AutoIt script.

	;Asks the user to enter a postcode.

	; $answer = Postcode
	; $trimleft = 2 digit letter

	;Asks the user to enter a 1 or 2 character response.  The M in the password
	;field indicates that blank string are not accepted and the 2 indicates that the
	;responce will be at most 2 characters long.
	$value = InputBox("Testing", "Enter the 1 or 2 character code.", "", " M2")

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>

;Setup the team postcodes into two variables
;$team =
;$postcode=

Local $avArray[120][2] = [ _
["AB", "TEAM 1, transfer to 2001"], _
["AL", "TEAM 3, transfer to 2003"], _
["B", "TEAM 2, transfer to 2002"], _
["BA", "TEAM 2, transfer to 2002"], _
["BB", "TEAM 1, transfer to 2001"], _
["BD", "TEAM 1, transfer to 2001"], _
["BH", "TEAM 3, transfer to 2003"], _
["BL", "TEAM 1, transfer to 2001"], _
["BN", "TEAM 3, transfer to 2003"], _
["BR", "TEAM 3, transfer to 2003"], _
["BS", "TEAM 2, transfer to 2002"], _
["BT", "TEAM 1, transfer to 2001"], _
["CA", "TEAM 1, transfer to 2001"], _
["CB", "TEAM 3, transfer to 2003"], _
["CF", "TEAM 2, transfer to 2002"], _
["CH", "TEAM 2, transfer to 2002"], _
["CM", "TEAM 3, transfer to 2003"], _
["CO", "TEAM 3, transfer to 2003"], _
["CR", "TEAM 3, transfer to 2003"], _
["CT", "TEAM 3, transfer to 2003"], _
["CV", "TEAM 2, transfer to 2002"], _
["CW", "TEAM 2, transfer to 2002"], _
["DA", "TEAM 3, transfer to 2003"], _
["DD", "TEAM 1, transfer to 2001"], _
["DE", "TEAM 2, transfer to 2002"], _
["DG", "TEAM 1, transfer to 2001"], _
["DH", "TEAM 1, transfer to 2001"], _
["DL", "TEAM 1, transfer to 2001"], _
["DN", "TEAM 2, transfer to 2002"], _
["DT", "TEAM 3, transfer to 2003"], _
["DY", "TEAM 2, transfer to 2002"], _
["E", "TEAM 3, transfer to 2003"], _
["EC", "TEAM 3, transfer to 2003"], _
["EH", "TEAM 1, transfer to 2001"], _
["EN", "TEAM 3, transfer to 2003"], _
["EX", "TEAM 2, transfer to 2002"], _
["FK", "TEAM 1, transfer to 2001"], _
["FY", "TEAM 1, transfer to 2001"], _
["G", "TEAM 1, transfer to 2001"], _
["GL", "TEAM 2, transfer to 2002"], _
["GU", "TEAM 3, transfer to 2003"], _
["HA", "TEAM 3, transfer to 2003"], _
["HD", "TEAM 1, transfer to 2001"], _
["HG", "TEAM 1, transfer to 2001"], _
["HP", "TEAM 3, transfer to 2003"], _
["HR", "TEAM 2, transfer to 2002"], _
["HS", "TEAM 1, transfer to 2001"], _
["HU", "TEAM 2, transfer to 2002"], _
["HX", "TEAM 1, transfer to 2001"], _
["IG", "TEAM 3, transfer to 2003"], _
["IM", "TEAM 1, transfer to 2001"], _
["IP", "TEAM 3, transfer to 2003"], _
["KA", "TEAM 1, transfer to 2001"], _
["KT", "TEAM 3, transfer to 2003"], _
["KW", "TEAM 1, transfer to 2001"], _
["KY", "TEAM 1, transfer to 2001"], _
["L", "TEAM 2, transfer to 2002"], _
["LA", "TEAM 1, transfer to 2001"], _
["LD", "TEAM 2, transfer to 2002"], _
["LE", "TEAM 2, transfer to 2002"], _
["LL", "TEAM 2, transfer to 2002"], _
["LN", "TEAM 2, transfer to 2002"], _
["LS", "TEAM 1, transfer to 2001"], _
["LU", "TEAM 2, transfer to 2002"], _
["M", "TEAM 2, transfer to 2002"], _
["ME", "TEAM 3, transfer to 2003"], _
["MK", "TEAM 2, transfer to 2002"], _
["ML", "TEAM 1, transfer to 2001"], _
["N", "TEAM 3, transfer to 2003"], _
["NE", "TEAM 1, transfer to 2001"], _
["NG", "TEAM 2, transfer to 2002"], _
["NN", "TEAM 2, transfer to 2002"], _
["NP", "TEAM 2, transfer to 2002"], _
["NR", "TEAM 3, transfer to 2003"], _
["NW", "TEAM 3, transfer to 2003"], _
["OL", "TEAM 1, transfer to 2001"], _
["OX", "TEAM 2, transfer to 2002"], _
["PA", "TEAM 1, transfer to 2001"], _
["PE", "TEAM 2, transfer to 2002"], _
["PH", "TEAM 1, transfer to 2001"], _
["PL", "TEAM 2, transfer to 2002"], _
["PO", "TEAM 3, transfer to 2003"], _
["PR", "TEAM 1, transfer to 2001"], _
["RG", "TEAM 3, transfer to 2003"], _
["RH", "TEAM 3, transfer to 2003"], _
["RM", "TEAM 3, transfer to 2003"], _
["S", "TEAM 1, transfer to 2001"], _
["SA", "TEAM 2, transfer to 2002"], _
["SE", "TEAM 3, transfer to 2003"], _
["SG", "TEAM 3, transfer to 2003"], _
["SK", "TEAM 2, transfer to 2002"], _
["SL", "TEAM 3, transfer to 2003"], _
["SM", "TEAM 3, transfer to 2003"], _
["SN", "TEAM 2, transfer to 2002"], _
["SO", "TEAM 3, transfer to 2003"], _
["SP", "TEAM 3, transfer to 2003"], _
["SR", "TEAM 1, transfer to 2001"], _
["SS", "TEAM 3, transfer to 2003"], _
["ST", "TEAM 2, transfer to 2002"], _
["SW", "TEAM 3, transfer to 2003"], _
["SY", "TEAM 2, transfer to 2002"], _
["TA", "TEAM 2, transfer to 2002"], _
["TD", "TEAM 1, transfer to 2001"], _
["TF", "TEAM 2, transfer to 2002"], _
["TN", "TEAM 3, transfer to 2003"], _
["TQ", "TEAM 2, transfer to 2002"], _
["TR", "TEAM 2, transfer to 2002"], _
["TS", "TEAM 1, transfer to 2001"], _
["TW", "TEAM 3, transfer to 2003"], _
["UB", "TEAM 3, transfer to 2003"], _
["W", "TEAM 3, transfer to 2003"], _
["WA", "TEAM 2, transfer to 2002"], _
["WC", "TEAM 3, transfer to 2003"], _
["WD", "TEAM 3, transfer to 2003"], _
["WF", "TEAM 1, transfer to 2001"], _
["WN", "TEAM 2, transfer to 2002"], _
["WR", "TEAM 2, transfer to 2002"], _
["WS", "TEAM 2, transfer to 2002"], _
["WV", "TEAM 2, transfer to 2002"], _
["YO", "TEAM 1, transfer to 2001"] _
]

$sColumn = Int (0)

;_ArrayDisplay($avArray, "$avArray")

#cs

While 1
		$answer = "BS7 8ND"
		Select
			Case $answer = "BS7 8ND"
				posty()
				ExitLoop
			Case $answer <> "BS7 8ND"
				searchy()
			;Case $msg = $Button_2
			;	MsgBox(0, 'Testing', 'Button 2 was pressed')    ; Will demonstrate Button 2 being pressed
		EndSelect
	Sleep(10)
	WEnd
#ce

		;Func posty()
			;Places the input box in the top left corner displaying the characters as they
			;are typed.
			Send("{CapsLock on}") ;Turns the CapsLock key on

			$answer = InputBox("PostCode to Teams Calculator", "Enter the postcode?", "BS7 8ND for example", "", _
					 -1, -1, 0, 0)

			Send("{CapsLock off}") ;Turns the CapsLock key off

			;Places the postcode in variable $answer
			;Calculates the string length less 2 to trimright

			$trimright = (StringLen($answer))-2

			;Converts postcode into the first two digits and one digit and displays

			$twodigit = StringTrimRight($answer, $trimright)

			;checks if $twodigit are both alphabet if not one digit is a number so trim right one digit

			If StringIsAlpha($twodigit) = 0 then $twodigit = StringTrimRight($twodigit, 1)

		;EndFunc

		;Func searchy()

			;column 0 = 2 digit postcode
			;column 1 = team

			$sSearch = $twodigit

			$iIndex = _ArraySearch($avArray, $sSearch, 0, 0, 0, 1, 1, $sColumn)

				;_ArrayDisplay($avArray)

			For $x = 0 To UBound($avArray, 1) - 1
					; temp put in
					;MsgBox(0, $answer, $x & "contact ..." & $avArray[$x][1] & @CRLF)
					; temp put in
				If $avArray[$x][0] = $sSearch Then
					MsgBox(0, $answer, "Postcode " & $answer & "..." & $avArray[$x][1])
					Exit
				EndIf
			Next

			MsgBox(0, 'Sorry!', 'Nothing found! Incorrect Postcode, Please try again', 2)

	;EndFunc