#include-once

#cs
  ; Change Log
  ===================================================================================================
  2012-11-13 - Ron
  Version:  1.0.0
  Initital
  ===================================================================================================
#ce

#cs
	Available ciphers: Rot1 thru Rot25 and Rot47

	Definitions taken from: http://www.mobilefish.com/services/rot13/rot13.php

	ROT1-ROT4, ROT6-ROT17 and ROT19-ROT25 - Transforms only letters.
	Each letter is shifted N places:
	For example ROT1 (N=1):
		abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
	becomes:
		bcdefghijklmnopqrstuvwxyzaBCDEFGHIJKLMNOPQRSTUVWXYZA
	----

	ROT5 - Transforms only numbers.
	Each number is shifted 5 places:
		0123456789
	becomes:
		5678901234
	----

	ROT13 - Transforms only letters.
	Each letter is shifted 13 places:
		abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
	becomes:
		nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM
	----

	ROT18 - Transforms only letters and numbers. abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
	becomes:
		nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM5678901234
	----

	ROT47 - Transforms ASCII characters 33-126.
	Each character is shifted 47 places:
		!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
	becomes:
		PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO
	----
#ce

;===================================================================================================
;
; Function Name....:    _cipher_Rot($s_data, [$i_rottype])
; Description......:    cipher char rotation Rot:1-18, 25, 47
; Parameter(s).....:
;                       $s_data:  String to encode/decode
;                       $i_rottype:  [Default = 13]; integer 1-18, 25, or 47
; Return Value(s)..:
;                       Success...:  Encoded or Decoded string
;                       Failure...:  Empty string
;                       Error.....:
;                                    1. Empty String
;                                    2. StringToASCIIArray() failed
;                                    3. Passed wrong type of $i_rottype
; Requirement(s)...:    N/A
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:    Tested with AutoIt 3.3.6.1
; Example(s).......:    See example output in comment fields within the include file
;
;===================================================================================================

Func _cipher_Rot($s_data, $i_rottype = 13)

	If Not StringLen($s_data) Then Return SetError(1, 0, "")

	Local $a_str = StringToASCIIArray($s_data)
	If @error Then Return SetError(2, 0, "")

	$i_rottype = Int($i_rottype)
	Switch $i_rottype
		Case 1 To 4, 6 To 17, 19 To 25
			For $idat = 0 To UBound($a_str) - 1
				Switch $a_str[$idat]
					Case 65 To 90
						If $a_str[$idat] + $i_rottype < 91 Then
							$a_str[$idat] += $i_rottype
							ContinueLoop
						EndIf
						$a_str[$idat] -= $i_rottype
					Case 97 To 122
						If $a_str[$idat] + $i_rottype < 123 Then
							$a_str[$idat] += $i_rottype
							ContinueLoop
						EndIf
						$a_str[$idat] -= $i_rottype
				EndSwitch
			Next
		Case 5
			For $idat = 0 To UBound($a_str) - 1
				Switch $a_str[$idat]
					Case 48 To 52
						$a_str[$idat] += 5
					Case 53 To 57
						$a_str[$idat] -= 5
				EndSwitch
			Next
		Case 18
			$i_rottype = 13
			For $idat = 0 To UBound($a_str) - 1
				Switch $a_str[$idat]
					Case 48 To 52
						$a_str[$idat] += 5
					Case 53 To 57
						$a_str[$idat] -= 5
					Case 65 To 90
						If $a_str[$idat] + $i_rottype < 91 Then
							$a_str[$idat] += $i_rottype
							ContinueLoop
						EndIf
						$a_str[$idat] -= $i_rottype
					Case 97 To 122
						If $a_str[$idat] + $i_rottype < 123 Then
							$a_str[$idat] += $i_rottype
							ContinueLoop
						EndIf
						$a_str[$idat] -= $i_rottype
				EndSwitch
			Next
		Case 47
			For $idat = 0 To UBound($a_str) - 1
				Switch $a_str[$idat]
					Case 33 To 126
						If $a_str[$idat] + $i_rottype < 127 Then
							$a_str[$idat] += $i_rottype
						Else
							$a_str[$idat] -= $i_rottype
						EndIf
				EndSwitch
			Next
		Case Else
			Return SetError(3, 0, "")
	EndSwitch

	Return StringFromASCIIArray($a_str)
EndFunc   ;==>_cipher_Rot