#include <File.au3>
#include <Array.au3>
#include <Date.au3>
Dim $id_array_text
Dim $idfilearray
Dim $bioarray
Dim $teamnick[32]
Dim $teamleague[32]

Global $year = InputBox("MLB.com Statistics", "Enter Year", @YEAR)
If @error = 1 Then
	Exit
EndIf
If $year = "" Or $year < 1976 Or $year > @YEAR Then
	MsgBox(0, "Error", "Please Enter A Valid Year (>1975)")
	Exit
EndIf
$folder = FileSelectFolder("Choose Destination Directory", StringLeft(@SystemDir, 3), 7) & "\"
If $folder = "" Or @error = 1 Then
	Exit
EndIf

If $year > 1997 Then
	$numteams = 30
	Dim $teamabb[$numteams + 1]
	Dim $teamlg[$numteams + 1]
	Dim $teamname[$numteams + 1]
	$teamabb[1] = "ARI"
	$teamabb[2] = "BS1"
	$teamabb[3] = "MLA"
	$teamabb[4] = "BOS"
	$teamabb[5] = "CH2"
	$teamabb[6] = "CN2"
	$teamabb[7] = "CLE"
	$teamabb[8] = "COL"
	$teamabb[9] = "CHA"
	$teamabb[10] = "DET"
	$teamabb[11] = "FLO"
	$teamabb[12] = "HOU"
	$teamabb[13] = "KCA"
	$teamabb[14] = "LAA"
	$teamabb[15] = "BR3"
	$teamabb[16] = "SE1"
	$teamabb[17] = "WS1"
	$teamabb[18] = "NYN"
	$teamabb[19] = "BLA"
	$teamabb[20] = "PHA"
	$teamabb[21] = "WOR"
	$teamabb[22] = "PT1"
	$teamabb[23] = "SDN"
	$teamabb[24] = "SEA"
	$teamabb[25] = "TRN"
	$teamabb[26] = "SL4"
	$teamabb[27] = "TBA"
	$teamabb[28] = "WS2"
	$teamabb[29] = "TOR"
	$teamabb[30] = "MON"
	$teamname[1] = "Arizona Diamondbacks"
	$teamname[2] = "Atlanta Braves"
	$teamname[3] = "Baltimore Orioles"
	$teamname[4] = "Boston Red Sox"
	$teamname[5] = "Chicago Cubs"
	$teamname[6] = "Cincinnati Reds"
	$teamname[7] = "Cleveland Indians"
	$teamname[8] = "Colorado Rockies"
	$teamname[9] = "Chicago White Sox"
	$teamname[10] = "Detroit Tigers"
	$teamname[11] = "Florida Marlins"
	$teamname[12] = "Houston Astros"
	$teamname[13] = "Kansas City Royals"
	If Number($year) < "2005" Then
		$teamname[14] = "Anaheim Angels"
	Else
		$teamname[14] = "Los Angeles Angels Of Anaheim"
	EndIf
	$teamname[15] = "Los Angeles Dodgers"
	$teamname[16] = "Milwaukee Brewers"
	$teamname[17] = "Minnesota Twins"
	$teamname[18] = "New York Mets"
	$teamname[19] = "New York Yankees"
	$teamname[20] = "Oakland A's"
	$teamname[21] = "Philadelphia Phillies"
	$teamname[22] = "Pittsburgh Pirates"
	$teamname[23] = "San Diego Padres"
	$teamname[24] = "Seattle Mariners"
	$teamname[25] = "San Francisco Giants"
	$teamname[26] = "St. Louis Cardinals"
	$teamname[27] = "Tampa Bay Devil Rays"
	$teamname[28] = "Texas Rangers"
	$teamname[29] = "Toronto Blue Jays"
	If Number($year) < "2005" Then
		$teamname[30] = "Montreal Expos"
	Else
		$teamname[30] = "Washington Nationals"
	EndIf
EndIf

If $year < 1998 And $year > 1993 Then
	$numteams = 28
	Dim $teamabb[$numteams + 1]
	Dim $teamlg[$numteams + 1]
	Dim $teamname[$numteams + 1]
	$teamabb[1] = "LAA"
	$teamabb[2] = "BS1"
	$teamabb[3] = "MLA"
	$teamabb[4] = "BOS"
	$teamabb[5] = "CH2"
	$teamabb[6] = "CN2"
	$teamabb[7] = "CLE"
	$teamabb[8] = "COL"
	$teamabb[9] = "CHA"
	$teamabb[10] = "DET"
	$teamabb[11] = "FLO"
	$teamabb[12] = "HOU"
	$teamabb[13] = "KCA"
	$teamabb[14] = "BR3"
	$teamabb[15] = "SE1"
	$teamabb[16] = "WS1"
	$teamabb[17] = "MON"
	$teamabb[18] = "NYN"
	$teamabb[19] = "BLA"
	$teamabb[20] = "PHA"
	$teamabb[21] = "WOR"
	$teamabb[22] = "PT1"
	$teamabb[23] = "SDN"
	$teamabb[24] = "SEA"
	$teamabb[25] = "TRN"
	$teamabb[26] = "SL4"
	$teamabb[27] = "WS2"
	$teamabb[28] = "TOR"
	If $year = 1997 Then
		$teamname[1] = "Anaheim Angels"
	Else
		$teamname[1] = "California Angels"
	EndIf
	$teamname[2] = "Atlanta Braves"
	$teamname[3] = "Baltimore Orioles"
	$teamname[4] = "Boston Red Sox"
	$teamname[5] = "Chicago Cubs"
	$teamname[6] = "Cincinnati Reds"
	$teamname[7] = "Cleveland Indians"
	$teamname[8] = "Colorado Rockies"
	$teamname[9] = "Chicago White Sox"
	$teamname[10] = "Detroit Tigers"
	$teamname[11] = "Florida Marlins"
	$teamname[12] = "Houston Astros"
	$teamname[13] = "Kansas City Royals"
	$teamname[14] = "Los Angeles Dodgers"
	$teamname[15] = "Milwaukee Brewers"
	$teamname[16] = "Minnesota Twins"
	$teamname[17] = "Montreal Expos"
	$teamname[18] = "New York Mets"
	$teamname[19] = "New York Yankees"
	$teamname[20] = "Oakland A's"
	$teamname[21] = "Philadelphia Phillies"
	$teamname[22] = "Pittsburgh Pirates"
	$teamname[23] = "San Diego Padres"
	$teamname[24] = "Seattle Mariners"
	$teamname[25] = "San Francisco Giants"
	$teamname[26] = "St. Louis Cardinals"
	$teamname[27] = "Texas Rangers"
	$teamname[28] = "Toronto Blue Jays"
EndIf

If $year = 1993 Then
	$numteams = 28
	Dim $teamabb[$numteams + 1]
	Dim $teamlg[$numteams + 1]
	Dim $teamdiv[$numteams + 1]
	Dim $teamname[$numteams + 1]
	$teamabb[1] = "BS1"
	$teamabb[2] = "MLA"
	$teamabb[3] = "BOS"
	$teamabb[4] = "LAA"
	$teamabb[5] = "CH2"
	$teamabb[6] = "CN2"
	$teamabb[7] = "CLE"
	$teamabb[8] = "COL"
	$teamabb[9] = "CHA"
	$teamabb[10] = "DET"
	$teamabb[11] = "FLO"
	$teamabb[12] = "HOU"
	$teamabb[13] = "KCA"
	$teamabb[14] = "BR3"
	$teamabb[15] = "SE1"
	$teamabb[16] = "WS1"
	$teamabb[17] = "MON"
	$teamabb[18] = "NYN"
	$teamabb[19] = "BLA"
	$teamabb[20] = "PHA"
	$teamabb[21] = "WOR"
	$teamabb[22] = "PT1"
	$teamabb[23] = "SDN"
	$teamabb[24] = "SEA"
	$teamabb[25] = "TRN"
	$teamabb[26] = "SL4"
	$teamabb[27] = "WS2"
	$teamabb[28] = "TOR"
	$teamname[1] = "Atlanta Braves"
	$teamname[2] = "Baltimore Orioles"
	$teamname[3] = "Boston Red Sox"
	$teamname[4] = "California Angels"
	$teamname[5] = "Chicago Cubs"
	$teamname[6] = "Cincinnati Reds"
	$teamname[7] = "Cleveland Indians"
	$teamname[8] = "Colorado Rockies"
	$teamname[9] = "Chicago White Sox"
	$teamname[10] = "Detroit Tigers"
	$teamname[11] = "Florida Marlins"
	$teamname[12] = "Houston Astros"
	$teamname[13] = "Kansas City Royals"
	$teamname[14] = "Los Angeles Dodgers"
	$teamname[15] = "Milwaukee Brewers"
	$teamname[16] = "Minnesota Twins"
	$teamname[17] = "Montreal Expos"
	$teamname[18] = "New York Mets"
	$teamname[19] = "New York Yankees"
	$teamname[20] = "Oakland A's"
	$teamname[21] = "Philadelphia Phillies"
	$teamname[22] = "Pittsburgh Pirates"
	$teamname[23] = "San Diego Padres"
	$teamname[24] = "Seattle Mariners"
	$teamname[25] = "San Francisco Giants"
	$teamname[26] = "St. Louis Cardinals"
	$teamname[27] = "Texas Rangers"
	$teamname[28] = "Toronto Blue Jays"
EndIf

If $year < 1993 And $year > 1976 Then
	$numteams = 26
	Dim $teamabb[$numteams + 1]
	Dim $teamlg[$numteams + 1]
	Dim $teamdiv[$numteams + 1]
	Dim $teamname[$numteams + 1]
	$teamabb[1] = "BS1"
	$teamabb[2] = "MLA"
	$teamabb[3] = "BOS"
	$teamabb[4] = "LAA"
	$teamabb[5] = "CH2"
	$teamabb[6] = "CN2"
	$teamabb[7] = "CLE"
	$teamabb[8] = "CHA"
	$teamabb[9] = "DET"
	$teamabb[10] = "HOU"
	$teamabb[11] = "KCA"
	$teamabb[12] = "BR3"
	$teamabb[13] = "SE1"
	$teamabb[14] = "WS1"
	$teamabb[15] = "MON"
	$teamabb[16] = "NYN"
	$teamabb[17] = "BLA"
	$teamabb[18] = "PHA"
	$teamabb[19] = "WOR"
	$teamabb[20] = "PT1"
	$teamabb[21] = "SDN"
	$teamabb[22] = "SEA"
	$teamabb[23] = "TRN"
	$teamabb[24] = "SL4"
	$teamabb[25] = "WS2"
	$teamabb[26] = "TOR"
	$teamname[1] = "Atlanta Braves"
	$teamname[2] = "Baltimore Orioles"
	$teamname[3] = "Boston Red Sox"
	$teamname[4] = "California Angels"
	$teamname[5] = "Chicago Cubs"
	$teamname[6] = "Cincinnati Reds"
	$teamname[7] = "Cleveland Indians"
	$teamname[8] = "Chicago White Sox"
	$teamname[9] = "Detroit Tigers"
	$teamname[10] = "Houston Astros"
	$teamname[11] = "Kansas City Royals"
	$teamname[12] = "Los Angeles Dodgers"
	$teamname[13] = "Milwaukee Brewers"
	$teamname[14] = "Minnesota Twins"
	$teamname[15] = "Montreal Expos"
	$teamname[16] = "New York Mets"
	$teamname[17] = "New York Yankees"
	$teamname[18] = "Oakland A's"
	$teamname[19] = "Philadelphia Phillies"
	$teamname[20] = "Pittsburgh Pirates"
	$teamname[21] = "San Diego Padres"
	$teamname[22] = "Seattle Mariners"
	$teamname[23] = "San Francisco Giants"
	$teamname[24] = "St. Louis Cardinals"
	$teamname[25] = "Texas Rangers"
	$teamname[26] = "Toronto Blue Jays"
EndIf

If FileExists($folder & "Teams") = 0 Then
	DirCreate($folder & "Teams")
EndIf
If FileExists($folder & "Players") = 0 Then
	DirCreate($folder & "Players")
EndIf

For $i = 1 To $numteams
	If FileExists($folder & "Teams\" & $year & "-" & $teamname[$i] & "-batting-1.htm") = 0 Then
		ConsoleWrite("Downloading Batting Stats for " & $year & " " & $teamname[$i] & @LF)
		InetGet("http://mlb.mlb.com/NASApp/mlb/stats/historical/player_stats.jsp?c_id=mlb&section1=1&statSet1=1&sortByStat=AB&statType=1&timeFrame=1&timeSubFrame=" & $year & "&baseballScope=mlb&prevPage1=1&readBoxes=true&sitSplit=&venueID=&subScope=teamCode&teamPosCode=" & $teamabb[$i] & "&HS=true&print=true", $folder & "Teams\" & $year & "-" & $teamname[$i] & "-batting-1.htm", 1)
	EndIf
	If FileExists($folder & "Teams\" & $year & "-" & $teamname[$i] & "-pitching-1.htm") = 0 Then
		ConsoleWrite("Downloading Pitching Stats for " & $year & " " & $teamname[$i] & @LF)
		InetGet("http://mlb.mlb.com/NASApp/mlb/stats/historical/player_stats.jsp?c_id=mlb&section2=1&statSet2=1&sortByStat=IP&statType=2&timeFrame=1&timeSubFrame=" & $year & "&baseballScope=mlb&prevPage2=1&readBoxes=true&sitSplit=&venueID=&subScope=teamCode&teamPosCode=" & $teamabb[$i] & "&HS=true&print=true", $folder & "Teams\" & $year & "-" & $teamname[$i] & "-pitching-1.htm", 1)
	EndIf
	
	If FileExists($folder & "Teams\" & $year & "-" & $teamname[$i] & "-fielding-1.htm") = 0 Then
		ConsoleWrite("Downloading Fielding Stats for " & $year & " " & $teamname[$i] & @LF)
		InetGet("http://mlb.mlb.com/NASApp/mlb/stats/historical/player_stats.jsp?c_id=mlb&section3=1&statSet3=1&sortByStat=G&statType=3&timeFrame=1&timeSubFrame=" & $year & "&baseballScope=mlb&prevPage3=2&readBoxes=true&sitSplit=&venueID=&subScope=teamCode&teamPosCode=" & $teamabb[$i] & "&HS=true&print=true", $folder & "Teams\" & $year & "-" & $teamname[$i] & "-fielding-1.htm", 1)
	EndIf
Next

ConsoleWrite("Deleting Existing CSV files" & @LF)
FileDelete($folder & $year & "-batting.csv")
FileDelete($folder & $year & "-pitching.csv")
FileDelete($folder & $year & "-fielding.csv")

ConsoleWrite("Creating ID array" & @LF)
$id_array = _FindIDs($folder, $year)
_ArrayDelete($id_array, UBound($id_array))

ConsoleWrite("Creating Headers for CSV files" & @LF)
$hitlineheader = "PlayerID,Year,First,Last,Age,B,T,Team,LG,G,AB,R,H,2B,3B,HR,RBI,TB,BB,SO,SB,CS,OBP,SLG,AVG,SF,SH,HBP,IBB,GDP,TPA,NP,XBH,SB%,GO,AO,GO/AO,OPS" & @LF
$pitlineheader = "PlayerID,Year,First,Last,Age,B,T,Team,LG,W,L,ERA,G,GS,CG,SHO,SV,SVO,IP,H,R,ER,HR,HBP,BB,SO,WPCT,TB,BK,WP,IBB,SB,CS,PK,GO,AO,GO/AO,WHIP,SLG,OBA,AVG,PA,NP,P/IP,HLD,GF,K/BB,BB/9,K/9,H/9" & @LF
$fldlineheader = "PlayerID,Year,First,Last,Age,B,T,Team,LG,POS,G,GS,INN,TC,PO,A,E,DP,PB,SB,CS,RF,FPCT" & @LF
FileWriteLine($folder & $year & "-" & "batting.csv", $hitlineheader)
FileWriteLine($folder & $year & "-" & "pitching.csv", $pitlineheader)
FileWriteLine($folder & $year & "-" & "fielding.csv", $fldlineheader)

For $j = 1 To UBound($id_array)
	$player_id = _ArrayPop($id_array)
	$player_filea = $folder & "Players\" & $player_id & "-1.htm"
	$player_fileb = $folder & "Players\" & $player_id & "-2.htm"
	$player_filec = $folder & "Players\" & $player_id & "-3.htm"
	$player_filebio = $folder & "Players\" & $player_id & "-bio.htm"
	If FileExists($player_filea) <> 1 Then
		ConsoleWrite("Downloading Stat 1 for " & $player_id & @LF)
		InetGet('http://mlb.mlb.com/NASApp/mlb/stats/historical/individual_stats_player.jsp?c_id=mlb&playerID=' & $player_id & '&section1=1&section2=1&statSet2=1&section3=1&statSet3=1&statSet1=1&print=true', $player_filea, 1)
	EndIf
	If FileExists($player_fileb) <> 1 Then
		ConsoleWrite("Downloading Stat 2 for " & $player_id & @LF)
		InetGet('http://mlb.mlb.com/NASApp/mlb/stats/historical/individual_stats_player.jsp?c_id=mlb&playerID=' & $player_id & '&section1=1&section2=1&statSet2=2&section3=1&statSet3=1&statSet1=2&print=true', $player_fileb, 1)
	EndIf
	If FileExists($player_filec) <> 1 Then
		ConsoleWrite("Downloading Stat 3 for " & $player_id & @LF)
		InetGet('http://mlb.mlb.com/NASApp/mlb/stats/historical/individual_stats_player.jsp?c_id=mlb&playerID=' & $player_id & '&section1=1&statSet1=2&section2=1&section3=1&statSet3=1&statSet2=3&print=true', $player_filec, 1)
	EndIf
	If FileExists($player_filebio) <> 1 Then
		ConsoleWrite("Downloading Bio for " & $player_id & @LF)
		InetGet('http://mlb.mlb.com/NASApp/mlb/team/player_news.jsp?player_id=' & $player_id & '&m=12&y=', $player_filebio, 1)
	EndIf
	
	$player_text = FileRead($player_filea)
	$player_text = StringTrimLeft($player_text, StringInStr($player_text, 'class="textLg white"><b>') + 24)
	$player_text = StringMid($player_text, 1, StringInStr($player_text, "</b>", 0, 1) - 1)
	$player_text = StringTrimRight($player_text, StringLen($player_text) - StringInStr($player_text, " ", 0, -1) + 1)
	$player_text = StringReplace($player_text, " ", ",", 1)
	$player_text = StringStripWS($player_text, 7)
	
	_FileReadToArray($player_filebio, $bioarray)
	For $b = 1 To $bioarray[0]
		$dobloc = StringInStr($bioarray[$b], 'Born: <b>')
		If $dobloc > 0 Then
			$dob = StringMid($bioarray[$b], $dobloc + 9, 10)
			$dobyear = StringRight($dob, 4)
			$dobmonth = StringLeft($dob, 2)
			$dobday = StringMid($dob, 4, 2)
			$age = _DateDiff('Y', $dobyear & '/' & $dobmonth & '/' & $dobday, $year & '/07/01')
		EndIf
		$thrloc = StringInStr($bioarray[$b], 'Throws: <b>')
		If $thrloc > 0 Then
			$throws = StringMid($bioarray[$b], $thrloc + 11, 1)
		EndIf
		$batloc = StringInStr($bioarray[$b], 'Bats: <b>')
		If $batloc > 0 Then
			$bats = StringMid($bioarray[$b], $batloc + 9, 1)
		EndIf
	Next
	
	_StripInd($folder, $year, $player_id, $player_text, $age, $throws, $bats)
Next
Exit

Func _FindIDs($sfolder, $syear)
	$filesearch = FileFindFirstFile($sfolder & "Teams\" & $syear & "*.htm")
	If $filesearch = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf
	
	While 1
		$file = $folder & "Teams\" & FileFindNextFile($filesearch)
		If @error Then
			FileClose($filesearch)
			ExitLoop
		EndIf
		_FileReadToArray($file, $idfilearray)
		For $a = 1 To $idfilearray[0]
			$idloc = StringInStr($idfilearray[$a], "playerID=")
			If $idloc > 0 Then
				$player_id = StringMid($idfilearray[$a], $idloc + 9, 6)
				If StringInStr($id_array_text, $player_id) = 0 Then
					$id_array_text = $id_array_text & $player_id & ","
				EndIf
			EndIf
		Next
	WEnd
	FileClose($filesearch)
	$id_array = StringSplit(StringTrimRight($id_array_text, 1), ',')
	_ArrayReverse($id_array)
	Return $id_array
EndFunc

Func _StripInd($sfolder, $syear, $splayer_id, $splayer_text, $sage, $sthrows, $sbats)
	$filea = $sfolder & "Players\" & $splayer_id & "-1.htm"
	$fileb = $sfolder & "Players\" & $splayer_id & "-2.htm"
	$filec = $sfolder & "Players\" & $splayer_id & "-3.htm"
	
	$texta = FileRead($filea)
	$textb = FileRead($fileb)
	$textc = FileRead($filec)
	
	ConsoleWrite("Generating Fielding CSV from " & StringReplace($player_text, ",", " ") & @LF)
	$textfa = _StripStats($texta, "Fielding")
	For $i = 2 To UBound($textfa) - 1
		$line = $textfa[$i]
		$line = StringTrimLeft($line, StringInStr($line, ",", 0, 2))
		If StringLeft($line, 4) = $syear Then
			$line = _League($line, $syear)
			$line = StringTrimLeft($line, 5)
			$line = $player_id & "," & $syear & "," & $player_text & "," & $sage & "," & $sbats & "," & $sthrows & "," & $line
			FileWriteLine($sfolder & $syear & "-fielding.csv", $line)
		EndIf
	Next
	
	ConsoleWrite("Generating Hitting CSV from " & StringReplace($player_text, ",", " ") & @LF)
	$textha = _StripStats($texta, "Hitting")
	$texthb = _StripStats($textb, "Hitting")
	For $i = 2 To UBound($textha) - 1
		$line = $textha[$i] & StringTrimLeft($texthb[$i], StringInStr($texthb[$i], ",", 0, 4))
		$line = StringTrimLeft($line, StringInStr($line, ",", 0, 2))
		If StringLeft($line, 4) = $syear Then
			$line = _League($line, $syear)
			$line = StringTrimLeft($line, 5)
			$line = $player_id & "," & $syear & "," & $player_text & "," & $sage & "," & $sbats & "," & $sthrows & "," & $line
			FileWriteLine($sfolder & $syear & "-batting.csv", $line)
		EndIf
	Next
	
	ConsoleWrite("Generating Pitching CSV from " & StringReplace($player_text, ",", " ") & @LF)
	$textpa = _StripStats($texta, "Pitching")
	$textpb = _StripStats($textb, "Pitching")
	$textpc = _StripStats($textc, "Pitching")
	For $i = 2 To UBound($textpa) - 1
		$line = $textpa[$i] & StringTrimLeft($textpb[$i], StringInStr($textpb[$i], ",", 0, 4)) & StringTrimLeft($textpc[$i], StringInStr($textpc[$i], ",", 0, 4))
		$line = StringTrimLeft($line, StringInStr($line, ",", 0, 2))
		If StringLeft($line, 4) = $syear Then
			$line = _League($line, $syear)
			$line = StringTrimLeft($line, 5)
			$line = $player_id & "," & $syear & "," & $player_text & "," & $sage & "," & $sbats & "," & $sthrows & "," & $line
			FileWriteLine($sfolder & $syear & "-pitching.csv", $line)
		EndIf
	Next
EndFunc

Func _StripStats($stext, $sstat_type)
	$sstext = StringStripWS($stext, 7)
	$sstext = StringReplace($sstext, @LF, '')
	$sstext = StringReplace($sstext, @TAB, '')
	If StringInStr($sstext, $sstat_type & ' Stats:') > 0 Then
		$sstext = StringTrimLeft($sstext, StringInStr($sstext, $sstat_type & ' Stats:', 0, 1))
		$sstext = StringTrimRight($sstext, (StringLen($sstext) - StringInStr($sstext, 'Career Totals', 0, 1)))
		$sstext = StringReplace($sstext, '</tr></table>', ',')
		$sstext = StringReplace($sstext, '*</a>', '')
		$sstext = StringReplace($sstext, '</a>', '')
		$sstext = StringReplace($sstext, '</tr>', @LF)
		$sstext = StringReplace($sstext, '</b>', '')
		$sstext = StringReplace($sstext, '<b>', '')
		$sstext = StringReplace($sstext, '<tr>', '')
		$sstext = StringReplace($sstext, '</td>', ',')
		$sstext = StringReplace($sstext, '<td>', ',')
		$sstext = StringReplace($sstext, '</table>', ',')
		$sstext = StringReplace($sstext, ',,', '')
		$sstext = StringReplace($sstext, ',<br></form> <', '')
		$sstext = StringReplace($sstext, 'td>', '')
		$sstext = StringReplace($sstext, 'td align="center" class="textSm" nowrap="nowrap" >', '')
		$sstext = StringReplace($sstext, '<', '')
		$sstext = StringReplace($sstext, 'td align="left" class="textSm" nowrap="nowrap" >&nbsp;&nbsp;&nbsp; a href="/NASApp/mlb/stats/historical/player_stats.jsp?c_id=mlb&baseballScope=mlb&subScope=teamCode&teamPosCode=', '')
		$sstext = StringReplace($sstext, '&statType=1&sitSplit=&timeFrame=1&timeSubFrame=', ',')
		$sstext = StringReplace($sstext, '&print=true" class="textSm"> ', ',')
		$sstext = StringReplace($sstext, 'itting Stats:,td colspan="17" align="right" class="textSm grey">a mlb href=/NASApp/mlb/stats/historical/individual_stats_player.jsp?c_id=mlb&playerID=', '')
		$sstext = StringReplace($sstext, 'ielding Stats:,td colspan="17" align="right" class="textSm grey">,', '')
		$sstext = StringReplace($sstext, 'tr bgcolor="#FFFFFF">td colspan="18">img src="/images/trans.gif" width="1" height="1" border="0" alt="" />,td colspan="17" align="right" class="textSm grey"> ,', '')
		$sstext = StringReplace($sstext, 'tr bgcolor="#CCCCCC">td colspan="35">img src="/images/trans.gif" width="1" height="1" border="0" alt="" />,', '')
		$sstext = StringReplace($sstext, 'tr bgcolor="#FFFFFF">td colspan="4" class="text primary">img src="/images/trans.gif" width="5" height="1" border="0" alt="" />C', '')
		$sstext = StringReplace($sstext, 'td bgcolor="#CCCCCC" colspan="29">img src="/images/trans.gif" width="1" height="1" border="0" alt="" />,', '')
		$sstext = StringReplace($sstext, 'td colspan="6" class="text primary">img src="/images/trans.gif" width="5" height="1" border="0" alt="" />C', '')
		$sstext = StringReplace($sstext, 'td bgcolor="#CCCCCC" colspan="35">img src="/images/trans.gif" width="1" height="1" border="0" alt="" />,', '')
		$sstext = StringReplace($sstext, 'td colspan="4" align="left" class="text primary">img src="/images/trans.gif" width="5" height="1" border="0" alt="" />C', '')
		$sstext = StringReplace($sstext, 'td colspan="18">img src="/images/trans.gif" width="1" height="1" border="0" alt="" />,td colspan="19" align="right" class="textSm grey"> ,', '')
		$sstext = StringReplace($sstext, '&statType=2&sitSplit=&timeFrame=1&timeSubFrame=', ',')
		$sstext = StringReplace($sstext, '&statType=3&sitSplit=&timeFrame=1&timeSubFrame=', ',')
		$sstext = StringReplace($sstext, '&section1=1&section2=1&statSet2=2&section3=1&statSet3=1&statSet1=1&print=true class="textSm"> Previous Stats ,', '')
		$sstext = StringReplace($sstext, '&section1=1&section2=1&statSet2=1&section3=1&statSet3=1&statSet1=2&print=true class="textSm">Next Stats >>,', '')
		$sstext = StringReplace($sstext, 'td align="left" class="textSm" nowrap="nowrap" >&nbsp;&nbsp;&nbsp; a href="/NASApp/mlb/stats/sortable_player_stats.jsp?c_id=mlb&baseballScope=mlb&subScope=teamCode&teamPosCode=', '')
		$sstext = StringStripWS($sstext, 7)
		$sstext = StringReplace($sstext, @CR, @LF)
		$sstext = StringReplace($sstext, @CRLF, @LF)
		$sstext = StringSplit($sstext, @LF)
	EndIf
	Return $sstext
EndFunc

Func _League($sstexta, $syear)
	$teamnick[1] = "Diamondbacks"
	$teamnick[2] = "Braves"
	$teamnick[3] = "Orioles"
	$teamnick[4] = "Red Sox"
	$teamnick[5] = "Cubs"
	$teamnick[6] = "White Sox"
	$teamnick[7] = "Reds"
	$teamnick[8] = "Indians"
	$teamnick[9] = "Rockies"
	$teamnick[10] = "Tigers"
	$teamnick[11] = "Marlins"
	$teamnick[12] = "Astros"
	$teamnick[13] = "Royals"
	$teamnick[14] = "Angels"
	$teamnick[15] = "Dodgers"
	$teamnick[16] = "Brewers"
	$teamnick[17] = "Twins"
	$teamnick[18] = "Mets"
	$teamnick[19] = "Yankees"
	$teamnick[20] = "Athletics"
	$teamnick[21] = "Phillies"
	$teamnick[22] = "Pirates"
	$teamnick[23] = "Padres"
	$teamnick[24] = "Giants"
	$teamnick[25] = "Mariners"
	$teamnick[26] = "Cardinals"
	$teamnick[27] = "Devil Rays"
	$teamnick[28] = "Rangers"
	$teamnick[29] = "Blue Jays"
	$teamnick[30] = "Nationals"
	$teamnick[31] = "Expos"
	$teamleague[1] = "NL"
	$teamleague[2] = "NL"
	$teamleague[3] = "AL"
	$teamleague[4] = "AL"
	$teamleague[5] = "NL"
	$teamleague[6] = "AL"
	$teamleague[7] = "NL"
	$teamleague[8] = "AL"
	$teamleague[9] = "NL"
	$teamleague[10] = "AL"
	$teamleague[11] = "NL"
	$teamleague[12] = "NL"
	$teamleague[13] = "AL"
	$teamleague[14] = "AL"
	$teamleague[15] = "NL"
	If $syear < 1998 Then
		$teamleague[16] = "AL"
	Else
		$teamleague[16] = "NL"
	EndIf
	$teamleague[17] = "AL"
	$teamleague[18] = "NL"
	$teamleague[19] = "AL"
	$teamleague[20] = "AL"
	$teamleague[21] = "NL"
	$teamleague[22] = "NL"
	$teamleague[23] = "NL"
	$teamleague[24] = "NL"
	$teamleague[25] = "AL"
	$teamleague[26] = "NL"
	$teamleague[27] = "AL"
	$teamleague[28] = "AL"
	$teamleague[29] = "AL"
	$teamleague[30] = "NL"
	$teamleague[31] = "NL"
	
	For $n = 1 To 31
		If StringInStr($sstexta, $teamnick[$n]) Then
			$sstexta = StringReplace($sstexta, $teamnick[$n], $teamnick[$n] & "," & $teamleague[$n])
		EndIf
	Next
	Return $sstexta
EndFunc