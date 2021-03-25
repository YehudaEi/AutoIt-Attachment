 #include <GUIConstantsEx.au3>
Global $dicegui, $rpsgui, $roll2d, $rolled, $rolled2d, $roll4d, $roll6d, $roll8d, $roll10d, $bal, $bankbal, $mb, $rolled4d, $rolled6d, $rolled8d, $rolled10d, $110d, $12d, $22d
Global $14d, $24d, $34d, $44d, $16d, $26d, $36d, $46d, $56d, $66d, $18d, $28d, $38d, $48d, $58d, $68d, $78d, $88d, $110d, $210d, $310d, $410d, $510d, $610d, $710d, $810d, $910d, $1010d
Global $reset, $choices, $bet
Global $1st,$2nd,$3rd,$4th,$5th,$6th,$7th,$8th,$9th,$10th,$12dpay,$22dpay,$14dpay,$24dpay,$34dpay,$44dpay,$16dpay,$26dpay,$36dpay,$46dpay,$56dpay,$66dpay,$18dpay,$28dpay,$38dpay,$48dpay,$58dpay,$68dpay,$78dpay,$88dpay
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
			Call("dicegame")
		Case $rps
			Call("rps")
		EndSwitch

		Case $dicegui
			Switch $msg[0]
		Case -3
			Exit
			#cs
	  Case $12d
		 GUICtrlSetState($12d,$GUI_DISABLE)
		 GUICtrlSetState($22d,$GUI_ENABLE)
		 $12dpay = "0"
		 #ce
	  Case $22d
		 GUICtrlSetState($22d,$GUI_DISABLE)
		 GUICtrlSetState($12d,$GUI_ENABLE)
		 $22dpay = "2"
	  Case $14d
		 GUICtrlSetState($14d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $14dpay = "3"
	  Case $24d
		 GUICtrlSetState($24d,$GUI_DISABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $24dpay = "4"
	  Case $34d
		 GUICtrlSetState($34d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 $34dpay = "5"
	  Case $44d
		 GUICtrlSetState($44d,$GUI_DISABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 $44dpay = "6"

		 Case $16d
		 GUICtrlSetState($16d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $16dpay = "7"
	  Case $26d
		 GUICtrlSetState($26d,$GUI_DISABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $26dpay = "8"
	  Case $36d
		 GUICtrlSetState($36d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $36dpay = "9"
	  Case $46d
		 GUICtrlSetState($46d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $46dpay = "10"
	  Case $56d
		 GUICtrlSetState($56d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 $56dpay = "11"
	  Case $66d
		 GUICtrlSetState($66d,$GUI_DISABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 $66dpay = "12"
		 Case $18d
		 GUICtrlSetState($18d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $18dpay = "13"
		 Case $28d
		 GUICtrlSetState($28d,$GUI_DISABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $28dpay = "14"
		 Case $38d
		 GUICtrlSetState($38d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $38dpay = "15"
		 Case $48d
		 GUICtrlSetState($48d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $48dpay = "16"
		 Case $58d
		 GUICtrlSetState($58d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $58dpay = "17"
		 Case $68d
		 GUICtrlSetState($68d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $68dpay = "18"
		 Case $78d
		 GUICtrlSetState($78d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($88d,$GUI_ENABLE)
		 $78dpay = "19"
		 Case $88d
		 GUICtrlSetState($88d,$GUI_DISABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 $88dpay = "20"
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
		 $1st = "hi"
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
		 $2nd = "hello"
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
		 $3rd = "23"
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
		 $4th = "24"
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
		 $5th = "25"
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
		 $6th = "26"
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
		 $7th = "27"
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
		 $8th = "28"
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
		 $9th = "29"
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
		 GUICtrlSetState($12d,$GUI_ENABLE)
		 GUICtrlSetState($22d,$GUI_ENABLE)
		 GUICtrlSetState($14d,$GUI_ENABLE)
		 GUICtrlSetState($24d,$GUI_ENABLE)
		 GUICtrlSetState($34d,$GUI_ENABLE)
		 GUICtrlSetState($44d,$GUI_ENABLE)
		 GUICtrlSetState($16d,$GUI_ENABLE)
		 GUICtrlSetState($26d,$GUI_ENABLE)
		 GUICtrlSetState($36d,$GUI_ENABLE)
		 GUICtrlSetState($46d,$GUI_ENABLE)
		 GUICtrlSetState($56d,$GUI_ENABLE)
		 GUICtrlSetState($66d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
		 GUICtrlSetState($28d,$GUI_ENABLE)
		 GUICtrlSetState($38d,$GUI_ENABLE)
		 GUICtrlSetState($48d,$GUI_ENABLE)
		 GUICtrlSetState($58d,$GUI_ENABLE)
		 GUICtrlSetState($68d,$GUI_ENABLE)
		 GUICtrlSetState($78d,$GUI_ENABLE)
		 GUICtrlSetState($18d,$GUI_ENABLE)
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
		 Case $roll2d
			If $bal >= "100" Then
			$result = Random(1,2,1)
			GUICtrlSetData($rolled2d,$result)
			$bal = $bal - $bet
			GUICtrlSetData($bankbal,"$"&$bal)
		 Else
			GUICtrlSetState($roll2d,$GUI_DISABLE)
			EndIf
			;MsgBox(4096,"","You rolled a: "&$result)
		 Case $roll4d
			If $bal >= "200" Then
			$result = Random(1,4,1)
			GUICtrlSetData($rolled4d,$result)
			$bal = $bal - ($bet *2)
			GUICtrlSetData($bankbal,"$"&$bal)
		 Else
			GUICtrlSetState($roll4d,$GUI_DISABLE)
			EndIf
		 Case $roll6d
			If $bal >= "300" Then
			$result = Random(1,6,1)
			GUICtrlSetData($rolled6d,$result)
			$bal = $bal - ($bet *3)
			GUICtrlSetData($bankbal,"$"&$bal)
		 Else
			GUICtrlSetState($roll6d,$GUI_DISABLE)
			EndIf
		 Case $roll8d
			If $bal >= "400" Then
			$result = Random(1,8,1)
			GUICtrlSetData($rolled8d,$result)
			$bal = $bal - ($bet *4)
			GUICtrlSetData($bankbal,"$"&$bal)
		 Else
			GUICtrlSetState($roll8d,$GUI_DISABLE)
			EndIf
		 Case $roll10d
			If $bal >= "500" Then
			$result = Random(1,10,1)
			GUICtrlSetData($rolled10d,$result)
			$bal = $bal - ($bet *5)
			GUICtrlSetData($bankbal,"$"&$bal)
		 EndIf
		 If $12dpay = "0" Then
			If $result = "1" Then
			   $bal = $bal + "300"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $22dpay = "2" Then
			If $result = 2 Then
			   $bal = $bal + "300"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $14dpay = "3" Then
			If $result = 1 Then
			   $bal = $bal + "600"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $24dpay = "4" Then
			If $result = 2 Then
			   $bal = $bal + "600"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $34dpay = "5" Then
			If $result = 3 Then
			   $bal = $bal + "600"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $44dpay = "6" Then
			If $result = 4 Then
			   $bal = $bal + "600"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $16dpay = "7" Then
			If $result = 1 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $26dpay = "8" Then
			If $result = 2 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $36dpay = "9" Then
			If $result = 3 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $46dpay = "10" Then
			If $result = 4 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $56dpay = "11" Then
			If $result = 5 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $66dpay = "12" Then
			If $result = 6 Then
			   $bal = $bal + "900"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $18dpay = "13" Then
			If $result = 1 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $28dpay = "14" Then
			If $result = 2 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $38dpay = "15" Then
			If $result = 3 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $48dpay = "16" Then
			If $result = 4 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $58dpay = "17" Then
			If $result = 5 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $68dpay = "18" Then
			If $result = 6 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $78dpay = "19" Then
			If $result = 7 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
		 EndIf
		 If $88dpay = "20" Then
			If $result = 8 Then
			   $bal = $bal + "1200"
			   GUICtrlSetData($bankbal,"$"&$bal)
			EndIf
			EndIf
		  If $1st = "hi" Then
	If $result = 1 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $2nd = "hello" Then
	If $result = 2 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $3rd = "23" Then
	If $result = 3 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $4th = "24" Then
	If $result = 4 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $5th = "25" Then
	If $result = 5 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $6th = "26" Then
	If $result = 6 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $7th = "27" Then
	If $result = 7 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $8th = "28" Then
	If $result = 8 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $9th = "29" Then
	If $result = 9 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
	EndIf
		 If $10th = "30" Then
	If $result = 10 Then
	   $bal = $bal + "1500"
	   GUICtrlSetData($bankbal,"$"&$bal)
	EndIf
 EndIf
		 EndSwitch

		Case $rpsgui
			Switch $msg[0]
		Case -3
			Exit

	EndSwitch
EndSwitch
WEnd

Func dicegame()
	$dicegui = GUICreate("Dice Game",300,300)
	$bet = "100"
	$bal = 50000
	$bank = GUICtrlCreateLabel("Bank: ",0,262 ,100)
	$bankbal = GUICtrlCreateLabel("$"&$bal,50,262,100)
	GUICtrlSetFont($bank,13,700,2,"Minion Pro")
	GUICtrlSetFont($bankbal,13,700,2,"Minion Pro")
	$rank = 100
	$ranklvl = GUICtrlCreateLabel("Your Rank Is: ",155,262,150)
	$rankdisplay = GUICtrlCreateLabel($rank,265,262,100)
	GUICtrlSetFont($rankdisplay,13,700,2,"Minion Pro")
	GUICtrlSetFont($ranklvl,13,700,2,"Minion Pro")
	$group2d = GUICtrlCreateGroup("Roll 2-D Rank 1-5",0,0,300,53)
   $roll2d = GUICtrlCreateButton("Roll 2D [$100]",5,17,75,30)
   $yourolled2 = GUICtrlCreateLabel("You rolled a: ",180,17,105,20)
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
   $gr2d = $group2d And $roll2d
   $gr4d = $group4d And $roll4d
   $gr6d = $group6d And $roll6d
   $gr8d = $group8d And $roll8d
   $gr10d = $group10d And $roll10d
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
$choices = GUICtrlCreateMenu("Reset Choices")
$reset = GUICtrlCreateMenuItem("Reset",$choices)
GUICtrlSetState($rankup,$GUI_DISABLE)
$rolled2d = GUICtrlCreateLabel("",265,17,20,20)
$rolled4d = GUICtrlCreateLabel("",265,70,20,20)
$rolled6d = GUICtrlCreateLabel("",265,123,20,20)
$rolled8d = GUICtrlCreateLabel("",265,175,20,20)
$rolled10d = GUICtrlCreateLabel("",265,227,20,20)
GUICtrlSetFont($yourolled2,10,700,2,"Minion Pro")
GUICtrlSetFont($yourolled4,10,700,2,"Minion Pro")
GUICtrlSetFont($yourolled6,10,700,2,"Minion Pro")
GUICtrlSetFont($yourolled8,10,700,2,"Minion Pro")
GUICtrlSetFont($yourolled10,10,700,2,"Minion Pro")
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

If $bal < "499" Then
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
   EndIf
	GUISetState()
EndFunc

Func rps()
	$rpsgui = GUICreate("Rock, Paper, Scissors",300,300)
	GUISetState()
 EndFunc