#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include<MsgBoxUDF.au3>
Local $dicegui, $rpsgui, $rolled2d, $roll2d,$roll4d, $roll6d, $roll8d, $roll10d, $bal, $bankbal, $mb, $rolled4d, $rolled6d, $rolled8d, $rolled10d
Local $12d, $22d, $14d, $24d, $34d, $44d, $16d, $26d, $36d, $46d, $56d, $66d, $18d, $28d, $38d, $48d, $58d, $68d, $78d, $88d, $110d, $210d, $310d, $410d, $510d, $610d, $710d, $810d, $910d, $1010d
Local $reset, $choices, $bet, $tr, $dr, $board, $prop2, $prop3, $prop4, $prop3rank, $prop4rank
;Local $2nd, $3rd, $4th, $6th, $8th, $10th
Local $rankup, $rank, $rankdisplay, $doublereward, $menu, $costdr, $gamereset, $triplereward
Local $yourolled10,$yourolled8,$yourolled6,$yourolled4, $property
Local $npcs, $goodluck, $rockrad, $paperrad, $srad, $yourchoice, $yourchoicepaper, $yourchoicescissor, $npcchose, $chose, $lose, $win, $choser, $goodluck2, $goodluck3, $rockrad2, $paperrad2, $srad2, $yourchoice2, $npcchose2, $npcchose3, $rockrad3, $yourchoice3, $npcpick2, $yourpick2, $npcpick3, $yourpick3, $paperrad3, $srad3
$hub = GUICreate("Main",300,100)

$dice = GUICtrlCreateButton("Dice Game",15,40,125,30)
$rps = GUICtrlCreateButton("Rock, Paper, Scissors",160,40,125,30)
$label = GUICtrlCreateLabel("What Game Would You Like To Play?",35,0,1000)
GUICtrlSetFont($label,10,700,2,"Minion Pro")
GUISetState()

while 1
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $hub
			Switch $msg[0]
		Case -3
			Exit
		 Case $dice
			$2nd = "0"
			$4th = "0"
			$6th = "0"
			$8th = "0"
			$10th = "0"
			Call("dicegame")
		Case $rps
			Call("rps")
			;MsgBox(0,"Under Work","Working on it at this very moment, should be out soon!")
		EndSwitch

		Case $dicegui
			Switch $msg[0]
		Case -3
			Exit
	  Case $12d
		 GUICtrlSetState($12d,$GUI_DISABLE)
		 GUICtrlSetState($22d,$GUI_ENABLE)
		 $2nd = "1"
	  Case $22d
		 GUICtrlSetState($22d,$GUI_DISABLE)
		 GUICtrlSetState($12d,$GUI_ENABLE)
		 $2nd = "2"

	  Case $14d
		 GUICtrlSetState($14d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $4th = "3"
	  Case $24d
		 GUICtrlSetState($24d,$GUI_DISABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $4th = "4"
	  Case $34d
		 GUICtrlSetState($34d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $4th = "5"
	  Case $44d
		 GUICtrlSetState($44d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 $4th = "6"

		 Case $16d
		 GUICtrlSetState($16d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "7"
	  Case $26d
		 GUICtrlSetState($26d,$GUI_DISABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "8"
	  Case $36d
		 GUICtrlSetState($36d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "9"
	  Case $46d
		 GUICtrlSetState($46d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "10"
	  Case $56d
		 GUICtrlSetState($56d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "11"
	  Case $66d
		 GUICtrlSetState($66d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 $6th = "12"
		 Case $18d
		 GUICtrlSetState($18d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "13"
		 Case $28d
		 GUICtrlSetState($28d,$GUI_DISABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "14"
		 Case $38d
		 GUICtrlSetState($38d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "15"
		 Case $48d
		 GUICtrlSetState($48d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "16"
		 Case $58d
		 GUICtrlSetState($58d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "17"
		 Case $68d
		 GUICtrlSetState($68d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "18"
		 Case $78d
		 GUICtrlSetState($78d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $8th = "19"
		 Case $88d
		 GUICtrlSetState($88d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 $8th = "20"
		 Case $110d
		 GUICtrlSetState($110d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "21"
		 Case $210d
		 GUICtrlSetState($210d,$GUI_DISABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "22"
		 Case $310d
		 GUICtrlSetState($310d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "23"
		 Case $410d
		 GUICtrlSetState($410d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "24"
		 Case $510d
		 GUICtrlSetState($510d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "25"
		 Case $610d
		 GUICtrlSetState($610d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "26"
		 Case $710d
		 GUICtrlSetState($710d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "27"
		 Case $810d
		 GUICtrlSetState($810d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "28"
		 Case $910d
		 GUICtrlSetState($910d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "29"
		 Case $1010d
		 GUICtrlSetState($1010d,$GUI_DISABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 $10th = "30"

			  Case $reset
				 If $rank > 0 Then
		 GUICtrlSetState($12d,$GUI_ENABLE)
		 GUICtrlSetState($22d,$GUI_ENABLE)
		 EndIf
		 If $rank > 4 Then
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $4th = "0"
	  EndIf
	  If $rank > 9 Then
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $6th = "0"
	  EndIf
	  If $rank > 14 Then
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 $8th = "0"
	  EndIf
	  If $rank > 19 Then
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 $10th = "0"
	  EndIf
	  Case $roll2d
		 If $bal >= "100" Then
			   If $dr = True Then
				  $bet2d = "200"
				  Else
			   $bet2d = "100"
			EndIf
			If $2nd = "1" Then
			   		 $result2d = Random(1,2,1)
				  GUICtrlSetData($rolled2d,$result2d)
			   If $result2d = 1 Then
				  $bal = $bal + $bet2d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "100"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $2nd = "2" Then
			   		 $result2d = Random(1,2,1)
		 GUICtrlSetData($rolled2d,$result2d)
			   If $result2d = 2 Then
				  $bal = $bal + $bet2d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "100"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
		 EndIf
		 Case $roll4d
			If $bal >= "200" Then
			   If $dr = True Then
				  $bet4d = "400"
				  Else
			   $bet4d = "200"
			   EndIf
			If $4th = "3" Then
			   		 $result4d = Random(1,4,1)
		 GUICtrlSetData($rolled4d,$result4d)
			   If $result4d = 1 Then
				  $bal = $bal + $bet4d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "200"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $4th = "4" Then
			   		 $result4d = Random(1,4,1)
		 GUICtrlSetData($rolled4d,$result4d)
			   If $result4d = 2 Then
				  $bal = $bal + $bet4d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "200"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $4th = "5" Then
			   		 $result4d = Random(1,4,1)
		 GUICtrlSetData($rolled4d,$result4d)
			   If $result4d = 3 Then
				  $bal = $bal + $bet4d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "200"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $4th = "6" Then
			   		 $result4d = Random(1,4,1)
		 GUICtrlSetData($rolled4d,$result4d)
			   If $result4d = 4 Then
				  $bal = $bal + $bet4d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "200"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			EndIf
		 Case $roll6d
			If $bal >= "300" Then
			   If $dr = True Then
				  $bet6d = "600"
				  Else
			   $bet6d = "300"
			   EndIf
			If $6th = "7" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 1 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $6th = "8" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 2 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $6th = "9" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 3 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $6th = "10" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 4 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $6th = "11" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 5 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $6th = "12" Then
			   		 $result6d = Random(1,6,1)
		 GUICtrlSetData($rolled6d,$result6d)
			   If $result6d = 6 Then
				  $bal = $bal + $bet6d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "300"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			EndIf
		 Case $roll8d
			If $bal >= "400" Then
			   If $dr = True Then
				  $bet8d = "800"
				  Else
			   $bet8d = "400"
			   EndIf
			If $8th = "13" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 1 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "14" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 2 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "15" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 3 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "16" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 4 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "17" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 5 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "18" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 6 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "19" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 7 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $8th = "20" Then
			   		 $result8d = Random(1,8,1)
		 GUICtrlSetData($rolled8d,$result8d)
			   If $result8d = 8 Then
				  $bal = $bal + $bet8d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "400"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			EndIf
		 Case $roll10d
			If $bal >= "500" Then
			   If $dr = True Then
				  $bet10d = "1000"
				  Else
			   $bet10d = "500"
			   EndIf
			If $10th = "21" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 1 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "22" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 2 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "23" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 3 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "24" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 4 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "25" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 5 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "26" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 6 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "27" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 7 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "28" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 8 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "29" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 9 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
			If $10th = "30" Then
			   		 $result10d = Random(1,10,1)
		 GUICtrlSetData($rolled10d,$result10d)
			   If $result10d = 10 Then
				  $bal = $bal + $bet10d
				  GUICtrlSetData($bankbal,"$"&$bal)
			   Else
				  $bal = $bal - "500"
				  GUICtrlSetData($bankbal,"$"&$bal)
			   EndIf
			EndIf
		 EndIf
	  Case $doublereward
		 If $bal > "1500" Then
			$dr = True
			$bal = $bal - "1500"
			GUICtrlSetData($bankbal,"$"&$bal)
			GUICtrlSetState($doublereward,$GUI_CHECKED)
			GUICtrlSetState($doublereward,$GUI_DISABLE)
		 Else
			MsgBox(0,"","You need $1,500 sorry")
		 EndIf
	  Case $gamereset
		 GUIDelete($dicegui)
		 $2nd = "0"
		 $4th = "0"
		 $6th = "0"
		 $8th = "0"
		 $10th = "0"
		 $dr = False
		 $tr = False
		 Call("dicegame")
		 Case $rankup
			If $bal > $rank * 250 Then
		 $rank = $rank + 1
		 $bal = $bal - ($rank * 250)
		 GUICtrlSetData($rankdisplay,$rank)
		 GUICtrlSetData($bankbal,"$"&$bal)
	  Else
		 MsgBox(0,"","You need more money to rank up! (Hint: Your rank * 250 is the cost)")
	  EndIf
	  If $rank > 0 Then
		 GUICtrlSetState($12d,$GUI_ENABLE)
		 GUICtrlSetState($22d,$GUI_ENABLE)
		 GUICtrlSetState($roll2d,$GUI_ENABLE)
		 EndIf
		 If $rank > 4 Then
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 GUICtrlSetState($roll4d,$GUI_ENABLE)
		 GUICtrlSetState($yourolled4,$GUI_SHOW)
	  EndIf
	  If $rank > 9 Then
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 GUICtrlSetState($roll6d,$GUI_ENABLE)
		 GUICtrlSetState($yourolled6,$GUI_SHOW)
	  EndIf
	  If $rank > 14 Then
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 GUICtrlSetState($roll8d,$GUI_ENABLE)
		 GUICtrlSetState($yourolled8,$GUI_SHOW)
	  EndIf
	  If $rank > 19 Then
		 GUICtrlSetState($110d,$GUI_ENABLE)
		 GUICtrlSetState($210d,$GUI_ENABLE)
		 GUICtrlSetState($310d,$GUI_ENABLE)
		 GUICtrlSetState($410d,$GUI_ENABLE)
		 GUICtrlSetState($510d,$GUI_ENABLE)
		 GUICtrlSetState($610d,$GUI_ENABLE)
		 GUICtrlSetState($710d,$GUI_ENABLE)
		 GUICtrlSetState($810d,$GUI_ENABLE)
		 GUICtrlSetState($910d,$GUI_ENABLE)
		 GUICtrlSetState($1010d,$GUI_ENABLE)
		 GUICtrlSetState($roll10d,$GUI_ENABLE)
		 GUICtrlSetState($yourolled10,$GUI_SHOW)
		 EndIf
		 EndSwitch

		Case $rpsgui
			Switch $msg[0]
		Case -3
			Exit
			Case $doublereward
		 If $bal > "2500" Then
			$dr = True
			$bal = $bal - "2500"
			GUICtrlSetData($bankbal,"$"&$bal)
			GUICtrlSetState($doublereward,$GUI_CHECKED)
			GUICtrlSetState($doublereward,$GUI_DISABLE)
		 Else
			MsgBox(0,"","You need $2,500 sorry")
		 EndIf
Case $rankup
			If $bal > $rank * 250 Then
		 $rank = $rank + 1
		 $bal = $bal - ($rank * 250)
		 GUICtrlSetData($rankdisplay,$rank)
		 GUICtrlSetData($bankbal,"$"&$bal)
	  Else
		 MsgBox(0,"","You need more money to rank up! (Hint: Your rank * 250 is the cost)")
	  EndIf
	If $rank > 4 Then
	   GUICtrlSetState($npcpick2,$GUI_SHOW)
	   GUICtrlSetState($yourpick2,$GUI_SHOW)
	   GUICtrlSetState($npcchose2, $GUI_SHOW)
	   GUICtrlSetState($yourchoice2, $GUI_SHOW)
	   GUICtrlSetState($goodluck2, $GUI_ENABLE)
	   GUICtrlSetState($rockrad2,$GUI_ENABLE)
	   GUICtrlSetState($paperrad2,$GUI_ENABLE)
	   GUICtrlSetState($srad2,$GUI_ENABLE)
	EndIf
	If $rank > 9 Then
	   GUICtrlSetState($npcpick3,$GUI_SHOW)
	   GUICtrlSetState($yourpick3,$GUI_SHOW)
	   GUICtrlSetState($npcchose3, $GUI_SHOW)
	   GUICtrlSetState($yourchoice3, $GUI_SHOW)
	   GUICtrlSetState($goodluck3, $GUI_ENABLE)
	   GUICtrlSetState($rockrad3,$GUI_ENABLE)
	   GUICtrlSetState($paperrad3,$GUI_ENABLE)
	   GUICtrlSetState($srad3,$GUI_ENABLE)
	   EndIf
	   If $rank = 10 Then
		  _MsgBox_SetButtonText(0, "Continue")
		  _MsgBox(0,"","Hey! Sorry for the interruption but you are now eligible to purchase property to help you with money!")
		  _MsgBox_SetButtonText(0,"Close")
		  _MsgBox(0,"","There will now be a Property option in the Upgrades menu. GoodLuck!")
		  $property = GUICtrlCreateMenuItem("Property",$menu)
	   EndIf
	   If $rank = 15 Then
MsgBox(0,"","Congratulations! You can now buy property 2!")
GUICtrlSetState($prop2rank,$GUI_HIDE)
GUICtrlSetState($prop2,$GUI_SHOW)
EndIf
If $rank = 25 Then
MsgBox(0,"","Congratulations! You can now buy property 3!")
GUICtrlSetState($prop3rank,$GUI_HIDE)
GUICtrlSetState($prop3,$GUI_SHOW)
EndIf
If $rank = 50 Then
MsgBox(0,"","Congratulations! You can now buy property 4!")
GUICtrlSetState($prop4rank,$GUI_HIDE)
GUICtrlSetState($prop4,$GUI_SHOW)
EndIf
		 Case $goodluck
		 If $bal > "0" Then
			$npcs = Random(1,3,1)
			If $npcs = 1 Then
			   $npcr = "Rock"
			GUICtrlSetData($npcchose,$npcr)
		 EndIf
		 If $npcs = 2 Then
			$npcp = "Paper"
			GUICtrlSetData($npcchose,$npcp)
		 EndIf
		 If $npcs = 3 Then
			$npcsc = "Scissor"
			GUICtrlSetData($npcchose,$npcsc)
		 EndIf
		 If GUICtrlRead($rockrad) = 1 Then
			$chose = "Rock"
			$choser = 1
			GUICtrlSetData($yourchoice,$chose)
		 EndIf
		 If GUICtrlRead($paperrad) = 1 Then
			$chose = "Paper"
			$choser = 2
			GUICtrlSetData($yourchoice,$chose)
		 EndIf
		 If GUICtrlRead($srad) = 1 Then
			$chose = "Scissor"
			$choser = 3
			GUICtrlSetData($yourchoice,$chose)
		 EndIf
		 If $npcs = 1 Then
		 If $choser = 1 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 2 Then
			   If $choser = 1 Then
				  $bal = $bal - "200"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 3 Then
					 If $choser = 1 Then
						If $dr = True Then
						   $bal = $bal + "400"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "200"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
				  EndIf
				  If $npcs = 2 Then
		 If $choser = 2 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 3 Then
			   If $choser = 2 Then
				  $bal = $bal - "200"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 1 Then
					 If $choser = 2 Then
						If $dr = True Then
						   $bal = $bal + "400"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "200"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
				  EndIf
				  If $npcs = 3 Then
		 If $choser = 3 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 1 Then
			   If $choser = 3 Then
				  $bal = $bal - "200"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 2 Then
					 If $choser = 3 Then
						If $dr = True Then
						   $bal = $bal + "400"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "200"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
			   EndIf
			   EndIf
		 Case $goodluck2
		 If $bal > "0" Then
			$npcs = Random(1,3,1)
			If $npcs = 1 Then
			   $npcr = "Rock"
			GUICtrlSetData($npcchose2,$npcr)
		 EndIf
		 If $npcs = 2 Then
			$npcp = "Paper"
			GUICtrlSetData($npcchose2,$npcp)
		 EndIf
		 If $npcs = 3 Then
			$npcsc = "Scissor"
			GUICtrlSetData($npcchose2,$npcsc)
		 EndIf
		 If GUICtrlRead($rockrad2) = 1 Then
			$chose2 = "Rock"
			$choser = 1
			GUICtrlSetData($yourchoice2,$chose2)
		 EndIf
		 If GUICtrlRead($paperrad2) = 1 Then
			$chose2 = "Paper"
			$choser = 2
			GUICtrlSetData($yourchoice2,$chose2)
		 EndIf
		 If GUICtrlRead($srad2) = 1 Then
			$chose2 = "Scissor"
			$choser = 3
			GUICtrlSetData($yourchoice2,$chose2)
		 EndIf
		 If $npcs = 1 Then
		 If $choser = 1 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 2 Then
			   If $choser = 1 Then
				  $bal = $bal - "400"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 3 Then
					 If $choser = 1 Then
						If $dr = True Then
						   $bal = $bal + "800"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "400"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
				  EndIf
				  If $npcs = 2 Then
		 If $choser = 2 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 3 Then
			   If $choser = 2 Then
				  $bal = $bal - "200"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 1 Then
					 If $choser = 2 Then
						If $dr = True Then
						   $bal = $bal + "800"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "400"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
			   EndIf
				  If $npcs = 3 Then
		 If $choser = 3 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 1 Then
			   If $choser = 3 Then
				  $bal = $bal - "200"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 2 Then
					 If $choser = 3 Then
						If $dr = True Then
						   $bal = $bal + "800"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "400"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
			   EndIf
			   EndIf
			   Case $goodluck3
		 If $bal > "0" Then
			$npcs = Random(1,3,1)
			If $npcs = 1 Then
			   $npcr = "Rock"
			GUICtrlSetData($npcchose3,$npcr)
		 EndIf
		 If $npcs = 2 Then
			$npcp = "Paper"
			GUICtrlSetData($npcchose3,$npcp)
		 EndIf
		 If $npcs = 3 Then
			$npcsc = "Scissor"
			GUICtrlSetData($npcchose3,$npcsc)
		 EndIf
		 If GUICtrlRead($rockrad3) = 1 Then
			$chose3 = "Rock"
			$choser = 1
			GUICtrlSetData($yourchoice3,$chose3)
		 EndIf
		 If GUICtrlRead($paperrad2) = 1 Then
			$chose3 = "Paper"
			$choser = 2
			GUICtrlSetData($yourchoice3,$chose3)
		 EndIf
		 If GUICtrlRead($srad2) = 1 Then
			$chose3 = "Scissor"
			$choser = 3
			GUICtrlSetData($yourchoice3,$chose3)
		 EndIf
		 If $npcs = 1 Then
		 If $choser = 1 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 2 Then
			   If $choser = 1 Then
				  $bal = $bal - "600"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 3 Then
					 If $choser = 1 Then
						If $dr = True Then
						   $bal = $bal + "1200"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "600"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
				  EndIf
				  If $npcs = 2 Then
		 If $choser = 2 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 3 Then
			   If $choser = 2 Then
				  $bal = $bal - "600"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 1 Then
					 If $choser = 2 Then
						If $dr = True Then
						   $bal = $bal + "1200"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "600"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
				  EndIf
				  If $npcs = 3 Then
		 If $choser = 3 Then
			MsgBox(0,"Tie","You Have Tied The NPC")
		 EndIf
		 EndIf
			If $npcs = 1 Then
			   If $choser = 3 Then
				  $bal = $bal - "600"
			GUICtrlSetData($bankbal,"$"&$bal)
				  MsgBox(0,"Lost","You Have Lost!")
			   EndIf
			   EndIf
				  If $npcs = 2 Then
					 If $choser = 3 Then
						If $dr = True Then
						   $bal = $bal + "1200"
						   GUICtrlSetData($bankbal, "$"&$bal)
						   MsgBox(0,"Winner","You Have Won!")
						   Else
						$bal = $bal + "600"
			GUICtrlSetData($bankbal,"$"&$bal)
						MsgBox(0,"Winner","You Have Won!")
					 EndIf
				  EndIf
			   EndIf
			EndIf
		 Case $gamereset
			GUIDelete($rpsgui)
			Call("rps")
			$npcs = " "
			GUICtrlSetData($npcchose,$npcs)
			$chose = " "
			GUICtrlSetData($yourchoice,$chose)
			$npcs2 = " "
			GUICtrlSetData($npcchose2,$npcs2)
			$chose2 = " "
			GUICtrlSetData($yourchoice2,$chose2)
			$npcs3 = " "
			GUICtrlSetData($npcchose3,$npcs3)
			$chose3 = " "
			GUICtrlSetData($yourchoice3,$chose3)
		 Case $property
			property()
			If $rank < 15 Then
			$prop2rank = GUICtrlCreateLabel("Available At Rank 15!",155,10,142,135,768,2)
GUICtrlSetFont($prop2rank,10,700,2)
GUICtrlSetState($prop2,$GUI_HIDE)
EndIf
		 EndSwitch
	  Case $board
		 Switch $msg[0]
		 Case -3
			Exit
			EndSwitch
EndSwitch
WEnd

Func dicegame()
	$dicegui = GUICreate("Dice Game",300,300)
	$bet = "100"
	$bal = 500
	$bank = GUICtrlCreateLabel("Bank: ",10,260 ,100)
	$bankbal = GUICtrlCreateLabel("$"&$bal,60,260,100)
	GUICtrlSetFont($bank,13,900,2,"Minion Pro")
	GUICtrlSetFont($bankbal,13,900,2,"Minion Pro")
	$rank = 1
	$ranklvl = GUICtrlCreateLabel("Your Rank Is: ",165,260,150)
	$rankdisplay = GUICtrlCreateLabel($rank,270,260,100)
	GUICtrlSetFont($rankdisplay,13,700,2,"Minion Pro")
	GUICtrlSetFont($ranklvl,13,700,2,"Minion Pro")
	$group2d = GUICtrlCreateGroup("Roll 2-D Rank 1-5",0,0,300,53)
   $roll2d = GUICtrlCreateButton("Roll 2D [$100]",5,17,75,30)
   $yourolled2 = GUICtrlCreateLabel("You rolled a: ",180,17,100,20)
   $group4d = GUICtrlCreateGroup("Roll 4-D Rank 5-10",0,53,300,53)
   $roll4d = GUICtrlCreateButton("Roll 4D [$200]",5,70,75,30)
   $yourolled4 = GUICtrlCreateLabel("You rolled a: ",180,70,100,20)
   $group6d = GUICtrlCreateGroup("Roll 6-D Rank 10-15",0,106,300,53)
   $roll6d = GUICtrlCreateButton("Roll 6D [$300]",5,123,75,30)
   $yourolled6 = GUICtrlCreateLabel("You rolled a: ",180,123,100,20)
   $group8d = GUICtrlCreateGroup("Roll 8-D Rank 15-20",0,158,300,53)
   $roll8d = GUICtrlCreateButton("Roll 8D [$400]",5,175,75,30)
   $yourolled8 = GUICtrlCreateLabel("You rolled a: ",180,175,100,20)
   $group10d = GUICtrlCreateGroup("Roll 10-D Rank 20+",0,210,300,53)
   $roll10d = GUICtrlCreateButton("Roll 10D [$500]",5,227,80,30)
   $yourolled10 = GUICtrlCreateLabel("You rolled a: ",180,227,100,20)
   If $rank <= 4 Then
   GUICtrlSetState($roll4d,$GUI_DISABLE)
EndIf
If $rank <= 9 Then
   GUICtrlSetState($roll6d,$GUI_DISABLE)
EndIf
If $rank <= 14 Then
   GUICtrlSetState($roll8d,$GUI_DISABLE)
EndIf
If $rank <= 19 Then
   GUICtrlSetState($roll10d,$GUI_DISABLE)
EndIf
$menu = GUICtrlCreateMenu("Upgrades")
$rankup = GUICtrlCreateMenuItem("Rankup",$menu)
$costdr = "[$1,500]"
$doublereward = GUICtrlCreateMenuItem("Double Payout "&$costdr,$menu)
;$triplereward = GUICtrlCreateMenuItem("Triple Payout [$5,000]",$menu)
$choices = GUICtrlCreateMenu("Reset Choices")
$reset = GUICtrlCreateMenuItem("Reset Dice Numbers",$choices)
$gamereset = GUICtrlCreateMenuItem("Reset Game",$choices)
;GUICtrlSetState($rankup,$GUI_DISABLE)
$rolled2d = GUICtrlCreateLabel("",280,17,20,20)
$rolled4d = GUICtrlCreateLabel("",280,70,20,20)
$rolled6d = GUICtrlCreateLabel("",280,123,20,20)
$rolled8d = GUICtrlCreateLabel("",280,175,20,20)
$rolled10d = GUICtrlCreateLabel("",280,227,20,20)
GUICtrlSetFont($yourolled2,13,700,2,"Minion Pro")
GUICtrlSetFont($yourolled4,13,700,2,"Minion Pro")
GUICtrlSetFont($yourolled6,13,700,2,"Minion Pro")
GUICtrlSetFont($yourolled8,13,700,2,"Minion Pro")
GUICtrlSetFont($yourolled10,13,700,2,"Minion Pro")
GUICtrlSetFont($rolled2d,13,700,2,"Minion Pro")
GUICtrlSetFont($rolled4d,13,700,2,"Minion Pro")
GUICtrlSetFont($rolled6d,13,700,2,"Minion Pro")
GUICtrlSetFont($rolled8d,13,700,2,"Minion Pro")
GUICtrlSetFont($rolled10d,13,700,2,"Minion Pro")
$12d = GUICtrlCreateButton("1",85,11,20,20)
$22d = GUICtrlCreateButton("2",104,11,20,20)

$14d = GUICtrlCreateButton("1",85,64,20,20)
$24d = GUICtrlCreateButton("2",104,64,20,20)
$34d = GUICtrlCreateButton("3",123,64,20,20)
$44d = GUICtrlCreateButton("4",142,64,20,20)

$16d = GUICtrlCreateButton("1",85,117,20,20)
$26d = GUICtrlCreateButton("2",104,117,20,20)
$36d = GUICtrlCreateButton("3",123,117,20,20)
$46d = GUICtrlCreateButton("4",142,117,20,20)
$56d = GUICtrlCreateButton("5",161,117,20,20)
$66d = GUICtrlCreateButton("6",85,137,20,20)

$18d = GUICtrlCreateButton("1",85,169,20,20)
$28d = GUICtrlCreateButton("2",104,169,20,20)
$38d = GUICtrlCreateButton("3",123,169,20,20)
$48d = GUICtrlCreateButton("4",142,169,20,20)
$58d = GUICtrlCreateButton("5",161,169,20,20)
$68d = GUICtrlCreateButton("6",85,189,20,20)
$78d = GUICtrlCreateButton("7",104,189,20,20)
$88d = GUICtrlCreateButton("8",123,189,20,20)

$110d = GUICtrlCreateButton("1",85,221,20,20)
$210d = GUICtrlCreateButton("2",104,221,20,20)
$310d = GUICtrlCreateButton("3",123,221,20,20)
$410d = GUICtrlCreateButton("4",142,221,20,20)
$510d = GUICtrlCreateButton("5",161,221,20,20)
$610d = GUICtrlCreateButton("6",85,241,20,20)
$710d = GUICtrlCreateButton("7",104,241,20,20)
$810d = GUICtrlCreateButton("8",123,241,20,20)
$910d = GUICtrlCreateButton("9",142,241,20,20)
$1010d = GUICtrlCreateButton("10",161,241,20,20)
If $rank <= 4 Then
   GUICtrlSetState($roll4d,$GUI_DISABLE)
   GUICtrlSetState($14d,$GUI_DISABLE)
   GUICtrlSetState($24d,$GUI_DISABLE)
   GUICtrlSetState($34d,$GUI_DISABLE)
   GUICtrlSetState($44d,$GUI_DISABLE)
   GUICtrlSetState($yourolled4,$GUI_HIDE)
   EndIf
If $rank <= 9 Then
   GUICtrlSetState($roll6d,$GUI_DISABLE)
   GUICtrlSetState($16d,$GUI_DISABLE)
   GUICtrlSetState($26d,$GUI_DISABLE)
   GUICtrlSetState($36d,$GUI_DISABLE)
   GUICtrlSetState($46d,$GUI_DISABLE)
   GUICtrlSetState($56d,$GUI_DISABLE)
   GUICtrlSetState($66d,$GUI_DISABLE)
   GUICtrlSetState($yourolled6,$GUI_HIDE)
   EndIf
If $rank <= 14 Then
   GUICtrlSetState($roll8d,$GUI_DISABLE)
   GUICtrlSetState($18d,$GUI_DISABLE)
   GUICtrlSetState($28d,$GUI_DISABLE)
   GUICtrlSetState($38d,$GUI_DISABLE)
   GUICtrlSetState($48d,$GUI_DISABLE)
   GUICtrlSetState($58d,$GUI_DISABLE)
   GUICtrlSetState($68d,$GUI_DISABLE)
   GUICtrlSetState($78d,$GUI_DISABLE)
   GUICtrlSetState($88d,$GUI_DISABLE)
   GUICtrlSetState($yourolled8,$GUI_HIDE)
   EndIf
If $rank <= 19 Then
   GUICtrlSetState($roll10d,$GUI_DISABLE)
   GUICtrlSetState($110d,$GUI_DISABLE)
   GUICtrlSetState($210d,$GUI_DISABLE)
   GUICtrlSetState($310d,$GUI_DISABLE)
   GUICtrlSetState($410d,$GUI_DISABLE)
   GUICtrlSetState($510d,$GUI_DISABLE)
   GUICtrlSetState($610d,$GUI_DISABLE)
   GUICtrlSetState($710d,$GUI_DISABLE)
   GUICtrlSetState($810d,$GUI_DISABLE)
   GUICtrlSetState($910d,$GUI_DISABLE)
   GUICtrlSetState($1010d,$GUI_DISABLE)
   GUICtrlSetState($yourolled10,$GUI_HIDE)
EndIf
If $bal < GUICtrlRead($rankdisplay) * 125 Then
   GUICtrlSetState($rankup,$GUI_DISABLE)
   EndIf
	GUISetState()
 EndFunc

Func rps()
	$rpsgui = GUICreate("Rock, Paper, Scissors",300,300)
	$menu = GUICtrlCreateMenu("Upgrades")
$rankup = GUICtrlCreateMenuItem("Rankup",$menu)
$choices = GUICtrlCreateMenu("Reset Choices")
;$reset = GUICtrlCreateMenuItem("Reset Dice Numbers",$choices)
$gamereset = GUICtrlCreateMenuItem("Reset Game",$choices)
$costdr = "[$2,500]"
$doublereward = GUICtrlCreateMenuItem("Double Payout "&$costdr,$menu)
	GUICtrlSetData($rockrad,$GUI_CHECKED)
	$bal = 6000800
	$bank = GUICtrlCreateLabel("Bank: ",5,260 ,100)
	$bankbal = GUICtrlCreateLabel("$"&$bal,55,260,100)
	GUICtrlSetFont($bank,13,900,2,"Minion Pro")
	GUICtrlSetFont($bankbal,13,900,2,"Minion Pro")
	$rank = 9
	$ranklvl = GUICtrlCreateLabel("Your Rank Is: ",160,260,150)
	$rankdisplay = GUICtrlCreateLabel($rank,267,260,100)
	GUICtrlSetFont($rankdisplay,13,700,2,"Minion Pro")
	GUICtrlSetFont($ranklvl,13,700,2,"Minion Pro")
	GUICtrlCreateGroup("$200 Reward; Ranks 1-5",5,0,290,80)
	GUICtrlCreateGroup("$400 Reward; Ranks 5-10",5,80,290,80)
	GUICtrlCreateGroup("$600 Reward; Ranks 10+",5,160,290,80)
	;GUICtrlCreateGroup("$800 Reward; Ranks 5-10",5,240,290,80)
	GUISetFont(10,700,2,"Minion Pro")
	$rockrad = GUICtrlCreateRadio("Rock",10,13)
	$paperrad = GUICtrlCreateRadio("Paper",10,32)
	$srad = GUICtrlCreateRadio("Scissor",10,51)

	$rockrad2 = GUICtrlCreateRadio("Rock",10,93)
	$paperrad2 = GUICtrlCreateRadio("Paper",10,112)
	$srad2 = GUICtrlCreateRadio("Scissor",10,131)

	$rockrad3 = GUICtrlCreateRadio("Rock",10,173)
	$paperrad3 = GUICtrlCreateRadio("Paper",10,192)
	$srad3 = GUICtrlCreateRadio("Scissor",10,211)
	GUICtrlSetState($rockrad,$GUI_CHECKED)
	$goodluck = GUICtrlCreateButton("Goodluck!",80,32,75,20)
	$goodluck2 = GUICtrlCreateButton("Goodluck!",80,112,75,20)
	$goodluck3 = GUICtrlCreateButton("Goodluck!",80,192,75,20)
	$npcpick = GUICtrlCreateLabel("Npc Chose: ",170,15)
	$yourpick = GUICtrlCreateLabel("You Chose: ",170,50)
	$npcchose = GUICtrlCreateLabel($npcs,245,15,"",20)
	$yourchoice = GUICtrlCreateLabel($chose,245,50,"",20)

	$npcpick2 = GUICtrlCreateLabel("Npc Chose: ",170,95)
	$yourpick2 = GUICtrlCreateLabel("You Chose: ",170,130)
	$npcchose2 = GUICtrlCreateLabel($npcs,245,95,"",20)
	$yourchoice2 = GUICtrlCreateLabel($chose,245,130,"",20)

	$npcpick3 = GUICtrlCreateLabel("Npc Chose: ",170,175)
	$yourpick3 = GUICtrlCreateLabel("You Chose: ",170,210)
	$npcchose3 = GUICtrlCreateLabel($npcs,245,175,"",20)
	$yourchoice3 = GUICtrlCreateLabel($chose,245,210,"",20)
   If $rank < 5 Then
	   GUICtrlSetState($npcpick2,$GUI_HIDE)
	   GUICtrlSetState($yourpick2,$GUI_HIDE)
	   GUICtrlSetState($npcchose2, $GUI_HIDE)
	   GUICtrlSetState($yourchoice2, $GUI_HIDE)
	   GUICtrlSetState($goodluck2, $GUI_DISABLE)
	   GUICtrlSetState($rockrad2,$GUI_DISABLE)
	   GUICtrlSetState($paperrad2,$GUI_DISABLE)
	   GUICtrlSetState($srad2,$GUI_DISABLE)
	EndIf
	If $rank < 10 Then
	   GUICtrlSetState($npcpick3,$GUI_HIDE)
	   GUICtrlSetState($yourpick3,$GUI_HIDE)
	   GUICtrlSetState($npcchose3, $GUI_HIDE)
	   GUICtrlSetState($yourchoice3, $GUI_HIDE)
	   GUICtrlSetState($goodluck3, $GUI_DISABLE)
	   GUICtrlSetState($rockrad3,$GUI_DISABLE)
	   GUICtrlSetState($paperrad3,$GUI_DISABLE)
	   GUICtrlSetState($srad3,$GUI_DISABLE)
	EndIf
	GUISetState()
 EndFunc

 Func property()
	$board = GUICreate("",300,300)

$prop1 = GUICtrlCreateButton("Property 1",25,15,75,75)
$prop1label = GUICtrlCreateLabel("Price: $500",35,90)
$prop1label2 = GUICtrlCreateLabel("Income: $100 Every 3 Wins",5,110)
$prop1sell = GUICtrlCreateLabel("Sell: $250",40,130)

$prop2 = GUICtrlCreateButton("Property 2",185,15,75,75)
$prop2label = GUICtrlCreateLabel("Price: $1000",195,90)
$prop2label2 = GUICtrlCreateLabel("Income: $250 Every 5 Wins",165,110)
$prop2sell = GUICtrlCreateLabel("Sell: $500",200,130)

$prop3 = GUICtrlCreateButton("Property 3",25,160,75,75)
$prop3label = GUICtrlCreateLabel("Price: $2500",35,235)
$prop3label2 = GUICtrlCreateLabel("Income: $500 Every 10 Wins",5,255)
$prop3sell = GUICtrlCreateLabel("Sell: $1250",40,275)

$prop4 = GUICtrlCreateButton("Property 4",185,160,75,75)
$prop4label = GUICtrlCreateLabel("Price: $5000",195,235)
$prop4label2 = GUICtrlCreateLabel("Income: $1000 Every 15 Wins",155,255)
$prop4sell = GUICtrlCreateLabel("Sell: $2500",200,275)

$prop1group = GUICtrlCreateGroup("",0,0,150,150)
$prop2group = GUICtrlCreateGroup("",150,0,150,150)
$prop3group = GUICtrlCreateGroup("",0,145,150,150)
$prop4group = GUICtrlCreateGroup("",150,145,150,150)


$prop3rank = GUICtrlCreateLabel("Available At Rank 25!",5,153,145,135,768,2)
GUICtrlSetFont($prop3rank,10,700,2)
GUICtrlSetState($prop3,$GUI_HIDE)

$prop4rank = GUICtrlCreateLabel("Available At Rank 50!",155,153,145,135,768,2)
GUICtrlSetFont($prop4rank,10,700,2)
GUICtrlSetState($prop4,$GUI_HIDE)

GUISetState()
EndFunc