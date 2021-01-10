$x = 1400000
$z=0
$n=1
Do
	$file = FileOpen("C:\vote\" & $x & ".html", 0)

	; Check if file opened for reading OK
	#cs
		If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
		EndIf
	#ce
	If $file = -1 Then
		
	Else
		$id = FileReadLine($file, 85)
		$regdate = FileReadLine($file, 89)
		$lastvote = FileReadLine($file, 87)
		$name = FileReadLine($file, 106)
		$dob = FileReadLine($file, 107)
		$street = FileReadLine($file, 131)
		$city = FileReadLine($file, 133)
		$poll = FileReadLine($file, 148)
		$polladd = FileReadLine($file, 149)
		$sd = FileReadLine($file, 168)
		$citylim = FileReadLine($file, 170)
		$cityward = FileReadLine($file, 171)
		$status = FileReadLine($file, 111)
		$Precinct = FileReadLine($file, 134)
		$schoolzone = FileReadLine($file, 169)
		$cd = FileReadLine($file, 172)
		$jd = FileReadLine($file, 173)
		$dc = FileReadLine($file, 174)
		$sr = FileReadLine($file, 190)
		$srnum = FileReadLine($file, 189)
		$ss = FileReadLine($file, 192)
		$ssnum = FileReadLine($file, 191)
		$jp = FileReadLine($file, 194)
		$jpnum = FileReadLine($file, 193)
		$precsplit = FileReadLine($file, 208)
		$party = FileReadLine($file, 209)

		$id2 = StringTrimRight($id, 5)
		$id3 = StringTrimLeft($id2, 26)

		$lastvote2 = StringTrimRight($lastvote, 5)
		$lastvote3 = StringTrimLeft($lastvote2, 26)

		$name2 = StringTrimRight($name, 5)
		$name3 = StringTrimLeft($name2, 38)

		$dob2 = StringTrimRight($dob, 5)
		$dob3 = StringTrimLeft($dob2, 38)

		$street2 = StringTrimRight($street, 5)
		$street3 = StringTrimLeft($street2, 38)

		$city2 = StringTrimRight($city, 5)
		$city3 = StringTrimLeft($city2, 38)

		$poll2 = StringTrimRight($poll, 5)
		$poll3 = StringTrimLeft($poll2, 38)

		$polladd2 = StringTrimRight($polladd, 5)
		$polladd3 = StringTrimLeft($polladd2, 38)

		$sd2 = StringTrimRight($sd, 5)
		$sd3 = StringTrimLeft($sd2, 38)

		$citylim2 = StringTrimRight($citylim, 5)
		$citylim3 = StringTrimLeft($citylim2, 38)

		$cityward2 = StringTrimRight($cityward, 5)
		$cityward3 = StringTrimLeft($cityward2, 38)


		$Precinct2 = StringTrimRight($Precinct, 5)
		$Precinct3 = StringTrimLeft($Precinct2, 37)

		$schoolzone2 = StringTrimRight($schoolzone, 5)
		$schoolzone3 = StringTrimLeft($schoolzone2, 37)

		$cd2 = StringTrimRight($cd, 5)
		$cd3 = StringTrimLeft($cd2, 38)


		$jd2 = StringTrimRight($jd, 5)
		$jd3 = StringTrimLeft($jd2, 37)

		$dc2 = StringTrimRight($dc, 5)
		$dc3 = StringTrimLeft($dc2, 38)

		$ss2 = StringTrimRight($ss, 5)
		$ss3 = StringTrimLeft($ss2, 38)


		$ssnum2 = StringTrimRight($ssnum, 5)
		$ssnum3 = StringTrimLeft($ssnum2, 37)

		$jp2 = StringTrimRight($jp, 5)
		$jp3 = StringTrimLeft($jp2, 38)

		$jpnum2 = StringTrimRight($jpnum, 5)
		$jpnum3 = StringTrimLeft($jpnum2, 37)


		$precsplit2 = StringTrimRight($precsplit, 5)
		$precsplit3 = StringTrimLeft($precsplit2, 26)

		$party2 = StringTrimRight($party, 5)
		$party3 = StringTrimLeft($party2, 26)

		$sr2 = StringTrimRight($sr, 5)
		$sr3 = StringTrimLeft($sr2, 38)

		$srnum2 = StringTrimRight($srnum, 5)
		$srnum3 = StringTrimLeft($srnum2, 37)

		$regdate2 = StringTrimRight($regdate, 5)
		$regdate3 = StringTrimLeft($regdate2, 26)

		;MsgBox(0, "Line read:", $id3 & " "& $lastvote3 &" "& $name3 & " " & $regdate3 &" "& $dob3 & " "& $street3 & " "& $city3 & " "& $poll3 & " "& $polladd3 & " "& $sd3 & " "& $citylim3 & " "& $cityward3& " "& $status & " "& $Precinct3 & " "& $schoolzone3& " "& $cd3& " "& $jd3& " "& $dc3& " "& $ss3& " "& $ssnum3 & " "& $jp3& " "& $jpnum3& " "& $precsplit3& " "& $party3& " "& $sr3& " "& $srnum3 )
		$file2 = "c:\voter"& $n &".txt"
		FileOpen($file2, 1)
		FileWrite($file2, $id3 & "," & $lastvote3 & "," & $regdate3 & "," & $name3 & "," & $dob3 & "," & $street3 & ",  " & $city3 & "," & $poll3 & "," & $polladd3 & "," & $sd3 & "," & $citylim3 & "," & $cityward3 & "," & $status & "," & $Precinct3 & "," & $schoolzone3 & "," & $cd3 & "," & $jd3 & "," & $dc3 & "," & $ss3 & "," & $ssnum3 & "," & $jp3 & "," & $jpnum3 & "," & $precsplit3 & "," & $party3 & "," & $sr3 & "," & $srnum3 & @CRLF)
		FileClose($file)
		FileClose($file2)
		$z=$z+1
	EndIf
if $z = 500 then
$n=$n+1 
$z=0 
EndIf
	$x = $x + 1
Until $x = 1500000