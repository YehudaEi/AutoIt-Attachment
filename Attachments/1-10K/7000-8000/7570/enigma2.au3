#Include <String.au3>
#include<guiconstants.au3>
#include <encryption.au3>




$main = GUICreate ("E N I G M A - C L O N by Marten Zimmermann", 310, 420)
$main_rolle1 = GUICtrlCreateInput ("A", 10, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle2 = GUICtrlCreateInput ("A", 40, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle3 = GUICtrlCreateInput ("A", 70, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle4 = GUICtrlCreateInput ("A", 100, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle5 = GUICtrlCreateInput ("A", 130, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle6 = GUICtrlCreateInput ("A", 160, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle7 = GUICtrlCreateInput ("A", 190, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle8 = GUICtrlCreateInput ("A", 220, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle9 = GUICtrlCreateInput ("A", 250, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_rolle10 = GUICtrlCreateInput ("A", 280, 10, 20)
GUICtrlSetLimit (-1, 1)
$main_ini = GUICtrlCreateInput ("eni.ini", 10, 40, 150)
GUICtrlCreateLabel ("Ini-File Source", 170, 40)
$main_clip_in = GUICtrlCreateCheckbox ("Get the text from the clipboard?", 10, 70, 140)
$main_clip_out = GUICtrlCreateCheckbox ("Put text to clipboard?", 160, 70, 140)
GUICtrlCreateLabel ("Input:", 10, 100, 150)
$main_input = GUICtrlCreateEdit ("", 10, 130, 290, 100)
GUICtrlCreateLabel ("Output:", 10, 240, 150)
$main_output = GUICtrlCreateEdit ("", 10, 270, 290, 100)
$main_rollen = GUICtrlCreateInput ("", 10, 380, 80, 20)
GUICtrlSetData ($main_rollen, "1")
GUICtrlSetLimit ($main_rollen, 10, 1)
GUICtrlCreateUpdown ($main_rollen)
$main_encrypt = GUICtrlCreateButton ("Encrypt", 100, 380, 80)
$main_decrypt = GUICtrlCreateButton ("Decrypt", 190, 380, 80)
GUISetState()

while 1
	$msg = GUIGetMsg ()
	if $msg = $GUI_EVENT_CLOSE then Exit
	if $msg = $main_encrypt Then
		if GUICtrlRead ($main_clip_in) = 1 Then
			$satz = ClipGet()
			GUICtrlSetData ($main_input, $satz)
		Else
			$satz = GUICtrlRead ($main_input)
		EndIf
		Select
		case GUICtrlRead ($main_rollen) < 2
			$output = enigma($satz, 1, 0)
		case GUICtrlRead ($main_rollen) > 9
			$output = enigma($satz, 10, 0)
		case GUICtrlRead ($main_rollen) > 1 and GUICtrlRead ($main_rollen) < 10
			$output = enigma($satz, GUICtrlRead ($main_rollen), 0)
		EndSelect
		if GUICtrlRead ($main_clip_out) = 1 Then
			ClipPut ($output)
			GUICtrlSetData ($main_output, $output)
		Else
			GUICtrlSetData ($main_output, $output)
		EndIf
	EndIf
	if $msg = $main_decrypt Then
		if GUICtrlRead ($main_clip_in) = 1 Then
			$satz = ClipGet()
			GUICtrlSetData ($main_input, $satz)
		Else
			$satz = GUICtrlRead ($main_input)
		EndIf
		Select
		case GUICtrlRead ($main_rollen) < 2
			$output = enigma($satz, 1, 1)
		case GUICtrlRead ($main_rollen) > 9
			$output = enigma($satz, 10, 1)
		case GUICtrlRead ($main_rollen) > 1 and GUICtrlRead ($main_rollen) < 10
			$output = enigma($satz, GUICtrlRead ($main_rollen), 1)
		EndSelect
		if GUICtrlRead ($main_clip_out) = 1 Then
			ClipPut ($output)
			GUICtrlSetData ($main_output, $output)
		Else
			GUICtrlSetData ($main_output, $output)
		EndIf
	EndIf
	sleep (100)
WEnd


func enigma($eni_input, $eni_rolle = 1, $eni_crypt = 0)
	$eni_a = stringsplit ($eni_input, "")
	$eni_strg = ""
	$eni_ini = GUICtrlRead ($main_ini)
	if $eni_crypt = 0 Then
		Select
		case $eni_rolle = 1
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$eni_strg = rot ("1"&GUICtrlRead($main_rolle1), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "ref", IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 then $r1 = $r1 - 255
			Next
		case $eni_rolle = 2
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$eni_strg = rot ("2"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead ($eni_ini, "ref", IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then $r2 = $r2 - 255
				EndIf
			Next
		case $eni_rolle = 3
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$eni_strg = rot ("3"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead ($eni_ini, "ref", IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then $r3 = $r3 - 255
					EndIf
				EndIf
			Next
		case $eni_rolle = 4
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$eni_strg = rot ("4"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead ($eni_ini, "ref", IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 5
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$eni_strg = rot ("5"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead ($eni_ini, "ref", IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 6
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$eni_strg = rot ("6"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5)&GUICtrlRead($main_rolle6), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "5-"&$r6, IniRead ($eni_ini, "ref", IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 7
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$eni_strg = rot ("7"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5)&GUICtrlRead($main_rolle6)&GUICtrlRead($main_rolle7), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "6-"&$r7, IniRead ($eni_ini, "ref", IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 8
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			$eni_strg = rot ("8"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5)&GUICtrlRead($main_rolle6)&GUICtrlRead($main_rolle7)&GUICtrlRead($main_rolle8), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "7-"&$r8, IniRead ($eni_ini, "ref", IniRead($eni_ini, "7-"&$r8, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 9
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			$r9 = asc (GUICtrlRead ($main_rolle9))
			$eni_strg = rot ("9"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5)&GUICtrlRead($main_rolle6)&GUICtrlRead($main_rolle7)&GUICtrlRead($main_rolle8)&GUICtrlRead($main_rolle9), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "7-"&$r8, IniRead($eni_ini, "8-"&$r9, IniRead ($eni_ini, "ref", IniRead($eni_ini, "8-"&$r9, IniRead($eni_ini, "7-"&$r8, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
												$r9 = $r9 + 1
												if $r9 > 255 Then
													$r9 = $r9 - 255
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		case $eni_rolle = 10
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			$r9 = asc (GUICtrlRead ($main_rolle9))
			$r10 = asc (GUICtrlRead ($main_rolle10))
			$eni_strg = rot ("0"&GUICtrlRead($main_rolle1)&GUICtrlRead($main_rolle2)&GUICtrlRead($main_rolle3)&GUICtrlRead($main_rolle4)&GUICtrlRead($main_rolle5)&GUICtrlRead($main_rolle6)&GUICtrlRead($main_rolle7)&GUICtrlRead($main_rolle8)&GUICtrlRead($main_rolle9)&GUICtrlRead($main_rolle10), 1)
			for $eni_i = 1 to $eni_a[0] step 1
				$eni_strg = $eni_strg & chr (IniRead($eni_ini, "0-"&$r1, IniRead ($eni_ini, "1-"&$r2, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "7-"&$r8, IniRead($eni_ini, "8-"&$r9, IniRead($eni_ini, "9-"&$r10, IniRead ($eni_ini, "ref", IniRead($eni_ini, "9-"&$r10, IniRead($eni_ini, "8-"&$r9, IniRead($eni_ini, "7-"&$r8, IniRead($eni_ini, "6-"&$r7, IniRead($eni_ini, "5-"&$r6, IniRead($eni_ini, "4-"&$r5, IniRead($eni_ini, "3-"&$r4, IniRead($eni_ini, "2-"&$r3, IniRead($eni_ini, "1-"&$r2, IniRead ($eni_ini, "0-"&$r1, asc($eni_a[$eni_i]), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""), ""))
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 then 
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then 
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 Then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
												$r9 = $r9 + 1
												if $r9 > 255 Then
													$r9 = $r9 - 255
													$r10 = $r10 + 1
													if $r10 > 255 then $r10 = $r10 - 255
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndSelect
		return $eni_strg
	elseif $eni_crypt = 1 Then
		$eni_strg = ""
		$eni_ref = IniReadSection($eni_ini, "ref")
		Select
		case $eni_rolle = 1
			$r1 = asc (GUICtrlRead ($main_rolle1))
			for $eni_i = 3 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 2
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			for $eni_i = 4 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 3
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			for $eni_i = 5 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 4
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			for $eni_i = 6 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 5
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			for $eni_i = 7 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 6
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			for $eni_i = 8 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				$eni_6 = IniReadSection ($eni_ini, "5-"&$r6)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 7
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			for $eni_i = 9 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				$eni_6 = IniReadSection ($eni_ini, "5-"&$r6)
				$eni_7 = IniReadSection ($eni_ini, "6-"&$r7)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 8
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			for $eni_i = 10 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				$eni_6 = IniReadSection ($eni_ini, "5-"&$r6)
				$eni_7 = IniReadSection ($eni_ini, "6-"&$r7)
				$eni_8 = IniReadSection ($eni_ini, "7-"&$r8)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 9
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			$r9 = asc (GUICtrlRead ($main_rolle9))
			for $eni_i = 11 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				$eni_6 = IniReadSection ($eni_ini, "5-"&$r6)
				$eni_7 = IniReadSection ($eni_ini, "6-"&$r7)
				$eni_8 = IniReadSection ($eni_ini, "7-"&$r8)
				$eni_9 = IniReadSection ($eni_ini, "8-"&$r9)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_9[$eni_j][1] then
						$chr = $eni_9[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_9[$eni_j][1] then
						$chr = $eni_9[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 + 1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
												$r9 = $r9 + 1
												if $r9 > 255 Then
													$r9 = $r9 - 255
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		case $eni_rolle = 10
			$r1 = asc (GUICtrlRead ($main_rolle1))
			$r2 = asc (GUICtrlRead ($main_rolle2))
			$r3 = asc (GUICtrlRead ($main_rolle3))
			$r4 = asc (GUICtrlRead ($main_rolle4))
			$r5 = asc (GUICtrlRead ($main_rolle5))
			$r6 = asc (GUICtrlRead ($main_rolle6))
			$r7 = asc (GUICtrlRead ($main_rolle7))
			$r8 = asc (GUICtrlRead ($main_rolle8))
			$r9 = asc (GUICtrlRead ($main_rolle9))
			$r10 = asc (GUICtrlRead ($main_rolle10))
			for $eni_i = 12 to $eni_a[0] step 1
				$eni_1 = IniReadSection ($eni_ini, "0-"&$r1)
				$eni_2 = IniReadSection ($eni_ini, "1-"&$r2)
				$eni_3 = IniReadSection ($eni_ini, "2-"&$r3)
				$eni_4 = IniReadSection ($eni_ini, "3-"&$r4)
				$eni_5 = IniReadSection ($eni_ini, "4-"&$r5)
				$eni_6 = IniReadSection ($eni_ini, "5-"&$r6)
				$eni_7 = IniReadSection ($eni_ini, "6-"&$r7)
				$eni_8 = IniReadSection ($eni_ini, "7-"&$r8)
				$eni_9 = IniReadSection ($eni_ini, "8-"&$r9)
				$eni_0 = IniReadSection ($eni_ini, "9-"&$r10)
				for $eni_j = 1 to 255 step 1
					$chr = asc($eni_a[$eni_i])
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_9[$eni_j][1] then
						$chr = $eni_9[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_0[$eni_j][1] then
						$chr = $eni_0[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_ref[$eni_j][1] Then
						$chr = $eni_ref[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_0[$eni_j][1] then
						$chr = $eni_0[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_9[$eni_j][1] then
						$chr = $eni_9[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_8[$eni_j][1] then
						$chr = $eni_8[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_7[$eni_j][1] then
						$chr = $eni_7[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_6[$eni_j][1] then
						$chr = $eni_6[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_5[$eni_j][1] then
						$chr = $eni_5[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_4[$eni_j][1] then
						$chr = $eni_4[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_3[$eni_j][1] then
						$chr = $eni_3[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_2[$eni_j][1] then
						$chr = $eni_2[$eni_j][0]
						ExitLoop
					EndIf
				Next
				for $eni_j = 1 to 255 step 1
					if $chr = $eni_1[$eni_j][1] then
						$chr = $eni_1[$eni_j][0]
						ExitLoop
					EndIf
				Next
				$eni_strg = $eni_strg & chr($chr)
				$r1 = $r1 + 1
				if $r1 > 255 Then
					$r1 = $r1 - 255
					$r2 = $r2 + 1
					if $r2 > 255 Then
						$r2 = $r2 - 255
						$r3 = $r3 + 1
						if $r3 > 255 Then
							$r3 = $r3 - 255
							$r4 = $r4 + 1
							if $r4 > 255 then
								$r4 = $r4 - 255
								$r5 = $r5 +	1
								if $r5 > 255 Then
									$r5 = $r5 - 255
									$r6 = $r6 + 1
									if $r6 > 255 Then
										$r6 = $r6 - 255
										$r7 = $r7 + 1
										if $r7 > 255 Then
											$r7 = $r7 - 255
											$r8 = $r8 + 1
											if $r8 > 255 Then
												$r8 = $r8 - 255
												$r9 = $r9 + 1
												if $r9 > 255 Then
													$r9 = $r9 - 255
													$r10 = $r10 + 1
													if $r10 > 255 then
														$r10 = $r10 - 255
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			return $eni_strg
		EndSelect
	EndIf
EndFunc
