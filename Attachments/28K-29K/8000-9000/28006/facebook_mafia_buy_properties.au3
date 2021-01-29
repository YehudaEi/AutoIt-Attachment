; FACEBOOK MAFIA WARS 4.8
; by Marian
; www.marian001.com

#include <IE.au3>
#include <Date.au3>
#include <Array.au3>
#include <String.au3>
Opt("TrayIconDebug", 1) ;0=no info, 1=debug line info

HotKeySet("+!l", "_StopLoop") ;Shift-Alt-l will stop looping (if enabled)

; INITIALIZE

$begin = TimerInit()

;;;;;;;; Customize these values (if you wish) ;;;;;;;;;;;;;
$visible = 0 ; visibility of IE: 1-visible, 0-invisible
$email = "" ; Facebook login
$password = "" ; Facebook password
$minBuy = 10 ; lot (amount of NY properties in 1 purchase [1-10])
$PEmax = 7000 ; maximum price per earning ratio value
$maxRank = 3 ; for item to be bought, it must placed among e.g. top 3 properties (based on P/E ratio ranking) [1-12]
$minEnergy = 60 ; level of energy when to stop executing jobs (don't decrease below energy amount necessary to execute selected job)
$minHealth = 25 ; level of health when to stop fighting
$minStamina = 27 ; level of stamina at which healing is enabled
$jobNum = 8 ; job to execute (on screen displayed when you click 'Jobs') [1-n] (n is number of jobs available on selected screen)
$minExpDiff = 1500 ; minimum difference between current experience and exp. needed for next level at which you want to enable accepting energy pack
Global $loop = 0 ; loop the script execution: 0-off, 1-on
$loopDelay = 60 ; delay between runs (if looping is enabled) [minutes]


Do

	;;;;;;;;;; Don't change values below ;;;;;;;;;;;;;

	$mynum = "10979261223"; Mafia Wars application number - DO NOT CHANGE
	$properties = 12
	$done = 0
	$bought = 0
	$spent = 0
	$protect = 1
	$sMyString = "Protect"
	$CubaReturns = 0
	$CubaDeposited = 0
	$CubaJobs = 0
	$NYJobs = 0
	$CubaFights = 0
	$CubaFightsWins = 0
	$CubaFightsLosses = 0
	$NYFights = 0
	$NYFightsWins = 0
	$NYFightsLosses = 0
	$oIE = 0
	Dim $myFightArray[21][4]

	;;;;;;;;;;;; Initialize ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_Initialize() ; open IE, login to Facebook (if necessary), open Mafia Wars site

	;;;;;;;;;;;;;;; YOU CAN SET THE ACTION FLOW HERE ;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;; NEW YORK ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_BuyNYProperties() ; buy properties based on P/E ranking

	;;;;;;;;;;;;;;;;;;;;;;;;;; CUBA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_DoCubaBusiness() ; sell all crates from Cuban businesses

	;;;;;;;;;;;;;;;; (Optional) Fly ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;_Fly("Cuba")
	;_Fly("NY")

	;;;;;;;;;;;;;;;; FIGHT!  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_DoFights() ; fight

	;;;;;;;;;;;;;;;; DO JOBS!  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_DoJobs($jobNum)

	;;;;;;;;;;;;;;; FIGHT again if health available ;;;;;;;;;;;;;;;
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_health")
	$health = _IEPropertyGet($oDiv, "innertext")
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
	$stamina = _IEPropertyGet($oDiv, "innertext")
	If $health > $minHealth And $stamina > 0 Then
		_DoFights()
	EndIf

	;;;;;;;;;;;;;;; Accept Energy Pack ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_AcceptEnergyPack()

	;;;;;;;;;;;;;;; DO JOBS again if energy available ;;;;;;;;;;;;;
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_energy")
	$energy = _IEPropertyGet($oDiv, "innertext")
	If $energy > $minEnergy Then
		_DoJobs($jobNum)
	EndIf

	;;;;;;;;;;;;;;; FIGHT again if health available ;;;;;;;;;;;;;;;
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_health")
	$health = _IEPropertyGet($oDiv, "innertext")
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
	$stamina = _IEPropertyGet($oDiv, "innertext")
	If $health > $minHealth And $stamina > 0 Then
		_DoFights()
	EndIf

	;;;;;;;;;;;;;;;;;;;;;; Heal yourself ;;;;;;;;;;;;;;;;;;;;;;;;;;
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
	$stamina = _IEPropertyGet($oDiv, "innertext")
	If $stamina > $minStamina - 1 Then
		_Heal()
	EndIf

	;;;;;;;;;;;;;;; FIGHT again if health available ;;;;;;;;;;;;;;;
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_health")
	$health = _IEPropertyGet($oDiv, "innertext")
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
	$stamina = _IEPropertyGet($oDiv, "innertext")
	If $health > $minHealth And $stamina > 0 Then
		_DoFights()
	EndIf

	;;;;;;;;;;;;;;;;;;;;; Get gifts ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_GetGifts()

	;;;;;;;;;;;;;;;;;;;; Delete news ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;~ _IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=deletenews")
;~ _IELoadWait($oIE)

	;;;;;;;; FOLLOWING FUNCTIONS ARE NOT WORKING YET - WIP ;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;; Play Lotto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;_PlayLotto()

	;;;;;;;;;;;;;;;;;;;;  Claim Rewards ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;_ClaimRewards()

	;;;;;;;;;;;;;;;;;;;; Help Friends ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;_HelpFriend()

	;;;;;;;;;;;;;;;;;;;; FINALIZE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	_IEQuit($oIE)
	Sleep(500)

	If $loop = 1 Then
		ConsoleWrite("Looping will continue after " & $loopDelay & " minutes" & @CRLF)
		Sleep($loopDelay * 60 * 1000)
	Else
		ExitLoop
	EndIf

Until 1 = 2

ConsoleWrite("SCRIPT EXECUTION FINISHED..." & @CRLF)
$time = TimerDiff($begin)
ConsoleWrite("======================= RUN SUMMARY ========================" & @CRLF)
Sleep(200)
ConsoleWrite("[NY] Items bought: " & $bought & @CRLF)
Sleep(200)
ConsoleWrite("[NY] Money spent: $" & _StringAddThousandsSep($spent) & @CRLF)
Sleep(200)
ConsoleWrite("[NY] Jobs done: " & $NYJobs & @CRLF)
Sleep(200)
ConsoleWrite("[NY] Fights fought: " & $NYFights & " (W:" & $NYFightsWins & ", L:" & $NYFightsLosses & ")" & @CRLF)
Sleep(200)
ConsoleWrite("[CUBA] Money deposited: C$" & _StringAddThousandsSep($CubaDeposited) & @CRLF)
Sleep(200)
ConsoleWrite("[CUBA] Jobs done: " & $CubaJobs & @CRLF)
Sleep(200)
ConsoleWrite("[CUBA] Fights fought: " & $CubaFights & " (W:" & $CubaFightsWins & ", L:" & $CubaFightsLosses & ")" & @CRLF)
Sleep(200)
ConsoleWrite("Script runtime: " & Int($time / 1000) & " seconds" & @CRLF)
Sleep(1000)
ConsoleWrite("------------------------------------------------------------" & @CRLF)
ConsoleWrite("                                                            " & @CRLF)
Sleep(5000)
Exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;; F U N C T I O N S ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _Initialize()
	ConsoleWrite("Initializing... (" & _Now() & ")" & @CRLF)
	Global $oIE = _IECreate("about:blank", 0, $visible) ; 1 - visible
	Global $oIE = _IEAttach("about:blank", "url")
	_IELoadWait($oIE)
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/")
	_IELoadWait($oIE)
	If StringInStr(_IEPropertyGet($oIE, "title"), "Login") Then
		$oLForm = _IEFormGetCollection($oIE, 0)

		$oEmail = _IEFormElementGetObjByName($oLForm, "email")
		_IEFormElementSetValue($oEmail, $email)
		$oPass = _IEFormElementGetObjByName($oLForm, "pass")
		_IEFormElementSetValue($oPass, $password)

		_IEFormSubmit($oLForm)
		_IELoadWait($oIE)
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/")
		_IELoadWait($oIE)

	EndIf
EndFunc   ;==>_Initialize

Func _BuyNYProperties()
	; GET PROPERTY DATA

	Dim $myArray[$properties][9] ;element 0,0 to 999,1
	Dim $myArray1[$properties][9] ;element 0,0 to 999,1

	$myArray[0][0] = "Abandoned Lot" ;1
	$myArray[1][0] = "Commercial Block" ;2
	$myArray[2][0] = "Prime Downtown Lot" ;3
	$myArray[3][0] = "Beachfront Property" ;4
	$myArray[4][0] = "Rent House" ;5
	$myArray[5][0] = "Italian Restaurant" ;6
	$myArray[6][0] = "Apartment Complex" ;7
	$myArray[7][0] = "Valu-Mart" ;8
	$myArray[8][0] = "Marina Tourist Shops" ;9
	$myArray[9][0] = "Office Building" ;10
	$myArray[10][0] = "5-Star Hotel" ;11
	$myArray[11][0] = "Mega Casino" ;12

	$myArray[0][2] = 0 ;1
	$myArray[1][2] = 0 ;2
	$myArray[2][2] = 0 ;3
	$myArray[3][2] = 0 ;4
	$myArray[4][2] = 1 ;5
	$myArray[5][2] = 1 ;6
	$myArray[6][2] = 2 ;7
	$myArray[7][2] = 2 ;8
	$myArray[8][2] = 4 ;9
	$myArray[9][2] = 3 ;10
	$myArray[10][2] = 4 ;11
	$myArray[11][2] = 3 ;12

	$myArray[0][8] = "app" & $mynum & "_propBuy_1" ;"Abandoned Lot" ;1
	$myArray[1][8] = "app" & $mynum & "_propBuy_2" ;"Commercial Block" ;2
	$myArray[2][8] = "app" & $mynum & "_propBuy_3" ;"Prime Downtown Lot" ;3
	$myArray[3][8] = "app" & $mynum & "_propBuy_4" ;"Beachfront Property" ;4
	$myArray[4][8] = "app" & $mynum & "_propBuy_5" ;"Rent House" ;5
	$myArray[5][8] = "app" & $mynum & "_propBuy_6" ;"Italian Restaurant" ;6
	$myArray[6][8] = "app" & $mynum & "_propBuy_7" ;"Apartment Complex" ;7
	$myArray[7][8] = "app" & $mynum & "_propBuy_8" ;"Valu-Mart" ;8
	$myArray[8][8] = "app" & $mynum & "_propBuy_9" ;"Marina Tourist Shops" ;9
	$myArray[9][8] = "app" & $mynum & "_propBuy_10" ;"Office Building" ;10
	$myArray[10][8] = "app" & $mynum & "_propBuy_11" ;"5-Star Hotel" ;11
	$myArray[11][8] = "app" & $mynum & "_propBuy_12" ;"Mega Casino" ;12

	_Fly("NY")

	Do

		$myArray[0][0] = "Abandoned Lot" ;1
		$myArray[1][0] = "Commercial Block" ;2
		$myArray[2][0] = "Prime Downtown Lot" ;3
		$myArray[3][0] = "Beachfront Property" ;4
		$myArray[4][0] = "Rent House" ;5
		$myArray[5][0] = "Italian Restaurant" ;6
		$myArray[6][0] = "Apartment Complex" ;7
		$myArray[7][0] = "Valu-Mart" ;8
		$myArray[8][0] = "Marina Tourist Shops" ;9
		$myArray[9][0] = "Office Building" ;10
		$myArray[10][0] = "5-Star Hotel" ;11
		$myArray[11][0] = "Mega Casino" ;12

		$myArray[0][2] = 0 ;1
		$myArray[1][2] = 0 ;2
		$myArray[2][2] = 0 ;3
		$myArray[3][2] = 0 ;4
		$myArray[4][2] = 1 ;5
		$myArray[5][2] = 1 ;6
		$myArray[6][2] = 2 ;7
		$myArray[7][2] = 2 ;8
		$myArray[8][2] = 4 ;9
		$myArray[9][2] = 3 ;10
		$myArray[10][2] = 4 ;11
		$myArray[11][2] = 3 ;12

		$myArray[0][8] = "app" & $mynum & "_propBuy_1" ;"Abandoned Lot" ;1
		$myArray[1][8] = "app" & $mynum & "_propBuy_2" ;"Commercial Block" ;2
		$myArray[2][8] = "app" & $mynum & "_propBuy_3" ;"Prime Downtown Lot" ;3
		$myArray[3][8] = "app" & $mynum & "_propBuy_4" ;"Beachfront Property" ;4
		$myArray[4][8] = "app" & $mynum & "_propBuy_5" ;"Rent House" ;5
		$myArray[5][8] = "app" & $mynum & "_propBuy_6" ;"Italian Restaurant" ;6
		$myArray[6][8] = "app" & $mynum & "_propBuy_7" ;"Apartment Complex" ;7
		$myArray[7][8] = "app" & $mynum & "_propBuy_8" ;"Valu-Mart" ;8
		$myArray[8][8] = "app" & $mynum & "_propBuy_9" ;"Marina Tourist Shops" ;9
		$myArray[9][8] = "app" & $mynum & "_propBuy_10" ;"Office Building" ;10
		$myArray[10][8] = "app" & $mynum & "_propBuy_11" ;"5-Star Hotel" ;11
		$myArray[11][8] = "app" & $mynum & "_propBuy_12" ;"Mega Casino" ;12

		;$eee = _IELinkClickByText($oIE, "Properties")
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=property&xw_action=view&xw_city=1")
		;MsgBox(0,"tmp",$eee)
		_IELoadWait($oIE)
		Sleep(5000)

		$i = 0

		ConsoleWrite("Getting property data ")

		For $z = 0 To $properties - 1 Step 1
			$sText = ""
			$pos = 0
			$pos0 = 0
			$pos1 = 0
			$pos2 = 0
			$pos3 = 0
			$pos4 = 0
			$pos5 = 0

			$sText = _IEBodyReadText($oIE)
			$pos = StringInStr($sText, "Undeveloped Space", 1) ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos)
			$sText = StringTrimLeft($sText, $pos - 1)

			If $i < 4 Then
				;MsgBox(0, "tmp", $i)
				;MsgBox(0, "Body Text", $sText)
				$pos0 = StringInStr($sText, $myArray[$i][0]) ; [, casesense [, occurrence [, start [, count]]]] )
				$pos1 = StringInStr($sText, "$", 0, 1, $pos0) ; [, casesense [, occurrence [, start [, count]]]] )

				$pos2 = StringInStr($sText, "$", 0, 1, $pos1 + 1) ; [, casesense [, occurrence [, start [, count]]]] )

				;MsgBox(0, "tmp", $pos1 & " " & $pos2)
				$income = StringMid($sText, $pos1 + 1, $pos2 - $pos1 - 2)
				$income = StringReplace($income, ",", "")
				;MsgBox(0, "Body Text", StringLen($income))

				$pos3 = StringInStr($sText, " ", 0, 1, $pos2) ; [, casesense [, occurrence [, start [, count]]]] )
				;MsgBox(0, "tmp", $pos2 & " " & $pos3)
				$price = StringMid($sText, $pos2 + 1, $pos3 - $pos2 - 1)
				$price = StringReplace($price, ",", "")

				$pos4 = StringInStr($sText, "Owned:", 0, 1, $pos3) ; [, casesense [, occurrence [, start [, count]]]] )
				$pos5 = StringInStr($sText, " ", 0, 2, $pos4) ; [, casesense [, occurrence [, start [, count]]]] )
				$owned = StringMid($sText, $pos4 + 7, $pos5 - $pos4 - 7)
				;MsgBox(0, "tmp", ">" & $income & "<" & @CRLF & ">" & $price & "<"& @CRLF & ">" & $owned & "<")
				;MsgBox(0, "tmp", $i&" "&$myArray[$i][0])
				;MsgBox(0, $myArray[$i][0], $myArray[$i][0]&@CRLF&$pos3 & "-" & $pos2 & "=" & $pos3 - $pos2 & @CRLF & "  price:" & $price & "<" & @CRLF & "  income:" & $income & "<" & @CRLF & "  owned:" & $owned & "<")
			ElseIf $i > 3 Then
				$pos0 = StringInStr($sText, $myArray[$i][0]) ; [, casesense [, occurrence [, start [, count]]]] )
				$pos1 = StringInStr($sText, "$", 0, 1, $pos0) ; [, casesense [, occurrence [, start [, count]]]] )
				$pos2 = StringInStr($sText, "(x", 0, 1, $pos1 + 1) ; [, casesense [, occurrence [, start [, count]]]] )

				;MsgBox(0, "tmp", $pos1 & " " & $pos2)
				$income = StringMid($sText, $pos1 + 1, $pos2 - $pos1 - 2)
				$income = StringReplace($income, " ", "")
				$income = StringReplace($income, ",", "")
				;MsgBox(0, "Body Text", StringLen($income))
				;MsgBox(0, "Body Text", $sText)
				$pos3 = StringInStr($sText, "Owned)", 0, 1, $pos2) ; [, casesense [, occurrence [, start [, count]]]] )
				$owned = StringMid($sText, $pos2 + 2, $pos3 - $pos2 - 3)
				$owned = StringReplace($owned, " ", "")
				$owned = StringReplace($owned, ",", "")

				$pos4 = StringInStr($sText, "Cost: $", 0, 1, $pos3) ; [, casesense [, occurrence [, start [, count]]]] )
				$pos5 = StringInStr($sText, " ", 0, 2, $pos4 + 7) ; [, casesense [, occurrence [, start [, count]]]] )
				$price = StringMid($sText, $pos4 + 7, $pos5 - $pos4 - 7)
				$price = StringReplace($price, " ", "")
				$price = StringReplace($price, ",", "")

				;MsgBox(0, "tmp", "income>" & $income & "<" & @CRLF & "price>" & $price & "<" & @CRLF & "owned>" & $owned & "<")

			EndIf

			$myArray[$i][1] = $i + 1 ;order
			$myArray[$i][3] = Number($income) ;income(earning)
			$myArray[$i][4] = Number($price) ;price
			$myArray[$i][5] = Number($owned) ;owned
			$myArray[$i][6] = Number($myArray[$i][4] / $myArray[$i][3]) ;price/earnings(per hour)
			$i = $i + 1
			ConsoleWrite(".")
		Next

		For $i = 0 To $properties - 1 Step 1
			$req = Number($myArray[$i][2])
			If $req > 0 Then
				$myArray[$i][7] = $myArray[$req - 1][5] ;required properties currently available
			Else
				$myArray[$i][7] = "X"
			EndIf
		Next
		ConsoleWrite(" Done! " & @CRLF)
		;_ArrayDisplay($myArray, "Entries in the array")

		; GET BALANCE ON BANK ACCOUNT
		ConsoleWrite("Getting Bank Account Balance... ")
		;_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_time=1231969977&xw_exp_sig=255dcc29dc99d593dc45c630edb96271&xw_controller=bank&xw_action=view")
		;_IELoadWait($oIE)
		;$sText = _IEBodyReadText($oIE)
		;$pos0 = StringInStr($sText, "Account Balance") ; [, casesense [, occurrence [, start [, count]]]] )
		;$pos1 = StringInStr($sText, "$", 0, 1, $pos0) ; [, casesense [, occurrence [, start [, count]]]] )
		;$pos2 = StringInStr($sText, ")", 0, 1, $pos1 + 1) ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos1 & " " & $pos2)
		;$balance = StringMid($sText, $pos1 + 1, $pos2 - $pos1 - 1)
		;$balance = Number(StringReplace($balance, ",", ""))

		$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_cash_nyc")
		$balance = _IEPropertyGet($oDiv, "innertext")
		;ConsoleWrite("Money: " & $balance & @CRLF)

		;MsgBox(0, 'tmp', $balance)
		$balance = StringReplace($balance, "$", "")
		;MsgBox(0, 'tmp', $balance)
		$balance = Number(StringReplace($balance, ",", ""))
		;MsgBox(0, 'tmp', $balance)
		ConsoleWrite("- Current Balance: $" & _StringAddThousandsSep($balance) & "   " & @CRLF)
		;Sleep(1000)
		;ConsoleWrite("Done! " & @CRLF)

		; DECIDE WHAT TO BUY?
		ConsoleWrite("Selecting item to buy ")
		$myArray1 = $myArray
		;_ArrayDisplay($myArray1, "Entries in the array: $myArray1")

		_ArraySort($myArray, 0, 0, 0, 6)
		;_ArrayDisplay($myArray, "Entries in the array: $myArray")
		;MsgBox(0,'Max Index Numeric value', _ArrayMaxIndex($myArray, 1, 1))

		;$sSearch = InputBox("_ArraySearch() demo", "String to find?")
		;If @error Then Exit

		$i = 0
		$Pass = 0
		Do
			If $i < $maxRank And Number($myArray[$i][6]) <= $PEmax Then
				$req = Number($myArray[$i][2])
				If $req > 0 Then
					If Number($myArray1[$req - 1][5]) > $minBuy - 1 Then
						If Number($myArray[$i][4]) * $minBuy < $balance Then
							$Pass = 1
						Else
							$Pass = 0
						EndIf
					Else
						$Pass = 0
					EndIf
				Else
					If Number($myArray[$i][4]) * $minBuy < $balance Then
						$Pass = 1
					Else
						$Pass = 0
					EndIf
				EndIf


				;Local $aiResult = _ArrayFindAll($myArray, $i, 0, 0, 0, 0, 1)
				;_ArrayDisplay($aiResult, "Results of searching for 0 in $avArray")

			EndIf

			If $Pass = 1 Then
				Sleep(100)
			Else
				$i = $i + 1
			EndIf

			ConsoleWrite(".")
		Until $i = $properties Or $Pass = 1

		;ConsoleWrite(" Done! " & @CRLF)

		If $Pass = 1 Then
			ConsoleWrite(" - Selected property: " & $myArray[$i][0] & " (rank #" & $i + 1 & ")" & " -" & "> P/E = " & $myArray[$i][6] & " (" & $myArray[$i][4] & "/" & $myArray[$i][3] & ")" & " -" & "> Cost (" & $minBuy & " pcs) = $" & _StringAddThousandsSep(Number($myArray[$i][4]) * $minBuy) & @CRLF)
		Else
			ConsoleWrite(" - No property selected for purchase." & @CRLF)
		EndIf

		; BUY
		If $Pass = 1 Then
			ConsoleWrite("Buying")
			;MsgBox(0, 'Buying...', $myArray[$i][0] & " (" & $i + 1 & ")" & @CRLF & "P/E = " & $myArray[$i][6] & @CRLF & "Amount = " & $minBuy & @CRLF & "Total Cost = " & Number($myArray[$i][4]) * $minBuy)
			;_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_time=1231969977&xw_exp_sig=255dcc29dc99d593dc45c630edb96271&xw_controller=bank&xw_action=view")
			;_IELoadWait($oIE)
			;$oForm0 = _IEFormGetObjByName($oIE, "app"&$mynum&"_bank_deposit")
			;$oAmount0 = _IEFormElementGetObjByName($oForm0, "amount")
			;$balance0 = Number(_IEFormElementGetValue($oAmount0))

			;$oForm = _IEFormGetObjByName($oIE, "app"&$mynum&"_bank_withdraw")
			;$oAmount = _IEFormElementGetObjByName($oForm, "amount")
			;_IEFormElementSetValue($oAmount, Number($myArray[$i][4]) * $minBuy + 1 - $balance0)
			;_IEFormSubmit($oForm)
			;ConsoleWrite("Withdrawn: $" & _StringAddThousandsSep(Number($myArray[$i][4]) * $minBuy + 1 - $balance0) & @CRLF)

			;_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_time=1231969977&xw_exp_sig=255dcc29dc99d593dc45c630edb96271&xw_controller=property&xw_action=view")
			;_IELinkClickByText($oIE, "Properties")
			;_IELoadWait($oIE)
			$oForm = _IEFormGetObjByName($oIE, $myArray[$i][8])
			$oText = _IEFormElementGetObjByName($oForm, "amount")
			_IEFormElementSetValue($oText, $minBuy)
			$o_signin = _IEFormElementGetObjByName($oForm, "buy_props")
			_IEAction($o_signin, "click")
			;_IEFormSubmit($oForm)
			_IELoadWait($oIE)
			Sleep(2000)
			ConsoleWrite(" - Purchased " & $minBuy & " pcs of " & $myArray[$i][0] & @CRLF)
			$bought = $bought + $minBuy
			$spent = $spent + $minBuy * $myArray[$i][4]
			;MsgBox(0, 'Buying...', "text")
			; GET BALANCE ON BANK ACCOUNT
			ConsoleWrite("Getting Bank Account Balance")
			;_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_time=1231969977&xw_exp_sig=255dcc29dc99d593dc45c630edb96271&xw_controller=bank&xw_action=view")
			;_IELoadWait($oIE)
			;$sText = _IEBodyReadText($oIE)
			;$pos0 = StringInStr($sText, "Account Balance") ; [, casesense [, occurrence [, start [, count]]]] )
			;$pos1 = StringInStr($sText, "$", 0, 1, $pos0) ; [, casesense [, occurrence [, start [, count]]]] )
			;$pos2 = StringInStr($sText, ")", 0, 1, $pos1 + 1) ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos1 & " " & $pos2)
			;$balance = StringMid($sText, $pos1 + 1, $pos2 - $pos1 - 1)
			;$balance = Number(StringReplace($balance, ",", ""))

			$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_cash_nyc")
			$balance = _IEPropertyGet($oDiv, "innertext")
			;ConsoleWrite("Money: " & $balance & @CRLF)

			;MsgBox(0, 'tmp', $balance)
			$balance = StringReplace($balance, "$", "")
			;MsgBox(0, 'tmp', $balance)
			$balance = Number(StringReplace($balance, ",", ""))
			;MsgBox(0, 'tmp', $balance)
			ConsoleWrite(" - Remaining Balance: $" & _StringAddThousandsSep($balance) & "   " & @CRLF)
			;Sleep(1000)
			;ConsoleWrite("Done! " & @CRLF)
		Else
			ConsoleWrite("No buying..." & @CRLF)
			$done = 1
		EndIf
	Until $done = 1
	ConsoleWrite("Done buying properties in NY" & @CRLF)
EndFunc   ;==>_BuyNYProperties

Func _DoCubaBusiness()
;~ 	ConsoleWrite("Flying to Cuba" & @CRLF)
;~ 	_IELoadWait($oIE)

	_Fly("Cuba")


	ConsoleWrite("Checking businesses..." & @CRLF)
	_IELinkClickByText($oIE, "Businesses")
	_IELoadWait($oIE)
	Sleep(3000)
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_cash_cuba")
	$balanceCuba_old = _IEPropertyGet($oDiv, "innertext")
	$balanceCuba_old = StringReplace($balanceCuba_old, "C$", "")
	$balanceCuba_old = Number(StringReplace($balanceCuba_old, ",", ""))

	$sMyString = "crates for C$"
	$sMyString2 = "Politico"
	$oLinks = _IELinkGetCollection($oIE)
	For $oLink In $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Or StringInStr($sLinkText, $sMyString2) Then
			_IEAction($oLink, "click")
			_IELoadWait($oIE)
			Sleep(500)
			$CubaReturns = $CubaReturns + 1
		EndIf
	Next

	If $CubaReturns > 0 Then
		$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_cash_cuba")
		$balanceCuba = _IEPropertyGet($oDiv, "innertext")
		$balanceCuba = StringReplace($balanceCuba, "C$", "")
		$balanceCuba = Number(StringReplace($balanceCuba, ",", ""))
		$CubaCollected = $balanceCuba - $balanceCuba_old
		ConsoleWrite("Collected C$" & _StringAddThousandsSep($CubaCollected) & " from " & $CubaReturns & " businesses" & @CRLF)
		_IELinkClickByText($oIE, "Bank")
		_IELoadWait($oIE)
		Sleep(2000)

		$oForm = _IEFormGetObjByName($oIE, "app" & $mynum & "_bank_deposit")
		_IEFormSubmit($oForm)
		_IELoadWait($oIE)
		Sleep(2000)
		_IELinkClickByText($oIE, "Deposit")
		_IELoadWait($oIE)
		Sleep(2000)
		$CubaDeposited = Int($balanceCuba * 0.9)
		ConsoleWrite("Deposited: C$" & _StringAddThousandsSep($CubaDeposited) & @CRLF)
	EndIf
EndFunc   ;==>_DoCubaBusiness

Func _DoJobs($job)
	ConsoleWrite("Ready to do some jobs in ")
	;_IENavigate($oIE, "http://apps.facebook.com/inthemafia/")
	_IELoadWait($oIE)

	;_IELinkClickByText($oIE, "Jobs")
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=job&xw_action=view")
	_IELoadWait($oIE)
	Sleep(2000)
	$jobPlace = _CheckPlace()
	If $jobPlace = "Cuba" Then
		ConsoleWrite($jobPlace & @CRLF)
		$placeDiff = 1
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=job&xw_action=view&xw_city=2")
	ElseIf $jobPlace = "NY" Then
		ConsoleWrite($jobPlace & @CRLF)
		$placeDiff = 0
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=job&xw_action=view&xw_city=1")
	Else
		ConsoleWrite($jobPlace & @CRLF)
		$placeDiff = 1
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=job&xw_action=view&xw_city=2")
	EndIf
	While 1

		$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_energy")
		$energy = _IEPropertyGet($oDiv, "innertext")
		ConsoleWrite("Energy: " & $energy & @CRLF)
		If $energy > $minEnergy Then
			$sMyString = "Do Job"
			$oLinks = _IELinkGetCollection($oIE)
			$linkcounter = 0
			For $oLink In $oLinks
				$sLinkText = _IEPropertyGet($oLink, "innerText")
				If StringInStr($sLinkText, $sMyString) Then
					$linkcounter = $linkcounter + 1
					If $linkcounter > $job - $placeDiff Then
						_IEAction($oLink, "click")
						_IELoadWait($oIE)
						ConsoleWrite("Job done..." & @CRLF)
						Sleep(2000)
						If $jobPlace = "Cuba" Then
							$CubaJobs = $CubaJobs + 1
						ElseIf $jobPlace = "NY" Then
							$NYJobs = $NYJobs + 1
						EndIf
						ExitLoop
					EndIf
				EndIf
			Next
		Else
			ConsoleWrite("Done working..." & @CRLF)
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_DoJobs


Func _DoFights()
	ConsoleWrite("Ready to fight in ")
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=fight&xw_action=view")
	_IELoadWait($oIE)
	$fightPlace = _CheckPlace()
	If $fightPlace = "Cuba" Then
		ConsoleWrite("Cuba" & @CRLF)
	ElseIf $fightPlace = "NY" Then
		ConsoleWrite("NY" & @CRLF)
	EndIf
	$previoushealth = 9999
	_IELoadWait($oIE)
	_IELinkClickByText($oIE, "Fight")
	_IELoadWait($oIE)
	Sleep(3000)
	While 1

		$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_health")
		$health = _IEPropertyGet($oDiv, "innertext")
		ConsoleWrite("Health: " & $health)
		If $health = $previoushealth Then
			_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=fight&xw_action=view")
			_IELoadWait($oIE)
			;_IELinkClickByText($oIE, "Fight")
			;_IELoadWait($oIE)
			Sleep(1000)
		EndIf
		$previoushealth = $health
		$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
		$stamina = _IEPropertyGet($oDiv, "innertext")
		ConsoleWrite("       Stamina: " & $stamina & @CRLF)
		If $health > $minHealth And $stamina > 0 Then

			;;;;;;;;; find the weakest opponent ;;;;;;;;;;;;

			$sText = _IEBodyReadText($oIE)

;~ 			$binsText = StringToBinary($sText)
;~ 			For $i = 1 To BinaryLen($binsText)
;~ 				If BinaryMid($binsText, $i, 1) = Binary(StringToBinary(Chr(9))) Then
;~ 					$binsText = BinaryMid($binsText, 1, $i - 1) & Binary(StringToBinary("TAB")) & BinaryMid($binsText, $i + 1)
;~ 					$i -= 1
;~ 				EndIf
;~ 			Next
;~ 			$sText = BinaryToString($binsText)

			$pos = StringInStr($sText, "User Mafia", 1) ; [, casesense [, occurrence [, start [, count]]]] )
			;$pos = StringInStr($sText, "steal", 1) ; [, casesense [, occurrence [, start [, count]]]] )
			$sText = StringTrimLeft($sText, $pos - 1)

;~ 			$logfile = FileOpen(@ScriptDir & "\mw.log", 2)
;~ 			FileWriteLine($logfile, $sText)
;~ 			FileClose($logfile)

			;MsgBox(0, "Body Text", $sText)
			For $fi = 1 To 20 Step 1
				If $fi = 1 Then
					$rowstartpos = 25
				Else
					$rowstartpos = StringInStr($sText, "Attack", 1, $fi - 1, 1) + 7
				EndIf
				;MsgBox(0, "$rowstartpos", $rowstartpos)
				$opplevelpos1 = StringInStr($sText, ", Level ", 0, 1, $rowstartpos) + 8; [, casesense [, occurrence [, start [, count]]]] )
				$opplevelpos2 = StringInStr($sText, "  ", 0, 1, $opplevelpos1) ; [, casesense [, occurrence [, start [, count]]]] )

				;MsgBox(0, "tmp", $opplevelpos1 & " " & $opplevelpos2)
				$opplevel = StringMid($sText, $opplevelpos1, $opplevelpos2 - $opplevelpos1)

				;MsgBox(0, "Body Text", $fi & " - opplevel:" & $opplevel)
				$l = 4
				While 1
					$oppmafsizepos2 = StringInStr($sText, "Attack", 1, 1, $opplevelpos1) ; [, casesense [, occurrence [, start [, count]]]] )
					$oppmafsizepos1 = $oppmafsizepos2 - $l

					$oppmafsize = StringMid($sText, $oppmafsizepos1, $oppmafsizepos2 - $oppmafsizepos1)
					;MsgBox(0, "Body Text", $fi & " - mafiasize0:" & $oppmafsize)
					$oppmafsize = StringReplace($oppmafsize, " ", "")
					;MsgBox(0, "Body Text", $fi & " - mafiasize:" & $oppmafsize)
					If StringIsDigit($oppmafsize) Then
						ExitLoop
					Else
						$l = $l - 1
						If $l = 0 Then
							$oppmafsize = 0
							ExitLoop
						EndIf
					EndIf
				WEnd
				$myFightArray[$fi][0] = $fi ;order
				If $fi > 1 Then
					If $myFightArray[$fi - 1][1] = 0 Then
						$myFightArray[$fi][1] = 0 ;opponent level
						$myFightArray[$fi][2] = 0 ;opponent mafia size
					Else
						$myFightArray[$fi][1] = Number($opplevel) ;opponent level
						$myFightArray[$fi][2] = Number($oppmafsize) ;opponent mafia size
					EndIf
				Else
					$myFightArray[$fi][1] = Number($opplevel) ;opponent level
					$myFightArray[$fi][2] = Number($oppmafsize) ;opponent mafia size
				EndIf
				If $myFightArray[$fi][1] = 0 Or $myFightArray[$fi][2] = 0 Then
					$myFightArray[$fi][3] = 999 * 1000 + 999 ;composite order number
				Else
					$myFightArray[$fi][3] = $myFightArray[$fi][2] * 1000 + $myFightArray[$fi][1] ;composite order number
				EndIf

			Next

;~ 							$oLinks = _IELinkGetCollection($oIE)
;~ 							$iNumLinks = @extended
;~ 							MsgBox(0, "Link Info", $iNumLinks & " links found")
;~ 							$logfile = FileOpen(@ScriptDir & "\mw.log", 2)
;~ 							For $oLink In $oLinks
;~ 								FileWriteLine($logfile, $oLink.href)
;~ 								;MsgBox(0, "Link Info", $oLink.href)
;~ 							Next
;~ 							FileClose($logfile)
;~ 							MsgBox(0, "", "pause")

;~ 			_ArrayDisplay($myFightArray, "Entries in the array")
			_ArraySort($myFightArray, 0, 0, 0, 3)
;~ 			_ArrayDisplay($myFightArray, "Entries in the array")


			;;;;;;;;;;; fight him ;;;;;;;;;;;;
			$attackretry = 0
			$sMyString = "Attack"
			$oLinks = _IELinkGetCollection($oIE)
			;MsgBox(0,"",$oLinks)
			$linkcounter = 0
			For $oLink In $oLinks
				$sLinkText = _IEPropertyGet($oLink, "innerText")
;~ 				ConsoleWrite($sLinkText & @CRLF)
				If $sLinkText = $sMyString Then
					$linkcounter = $linkcounter + 1
					If $linkcounter > $myFightArray[1][0] - 1 Then
;~ 						ConsoleWrite($oLink & @CRLF)
						Do
							_IEAction($oLink, "click")
							_IELoadWait($oIE)
							Sleep(4000)
							$attackretry = $attackretry + 1
							If $attackretry > 5 Then
								_IEQuit($oIE)
								_Initialize()
								_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=fight&xw_action=view")
								_IELoadWait($oIE)
								Sleep(2000)
								ExitLoop 2
								$attackretry = 0
							EndIf
						Until StringInStr(_IEPropertyGet($oIE, "innertext"), "You lose!") Or StringInStr(_IEPropertyGet($oIE, "innertext"), "You win!")
						If StringInStr(_IEPropertyGet($oIE, "innertext"), "You lose!") Then
							ConsoleWrite("Fight lost :-(    vs. -> Opponent level: " & $myFightArray[1][1] & "  Opponent mafia size: " & $myFightArray[1][2] & @CRLF)
							If $fightPlace = "Cuba" Then
								$CubaFights = $CubaFights + 1
								$CubaFightsLosses = $CubaFightsLosses + 1
							ElseIf $fightPlace = "NY" Then
								$NYFights = $NYFights + 1
								$NYFightsLosses = $NYFightsLosses + 1
							EndIf
						ElseIf StringInStr(_IEPropertyGet($oIE, "innertext"), "You win!") Then
							ConsoleWrite("Fight won :-)    vs. -> Opponent level: " & $myFightArray[1][1] & "  Opponent mafia size: " & $myFightArray[1][2] & @CRLF)
							If $fightPlace = "Cuba" Then
								$CubaFights = $CubaFights + 1
								$CubaFightsWins = $CubaFightsWins + 1
							ElseIf $fightPlace = "NY" Then
								$NYFights = $NYFights + 1
								$NYFightsWins = $NYFightsWins + 1
							EndIf
							While 1
								$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_health")
								$health = _IEPropertyGet($oDiv, "innertext")
								ConsoleWrite("Health: " & $health)
								$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_stamina")
								$stamina = _IEPropertyGet($oDiv, "innertext")
								ConsoleWrite("       Stamina: " & $stamina & @CRLF)
								If $health > $minHealth And $stamina > 0 Then
									_IELoadWait($oIE)
									Sleep(1500)
									$fightagain = _IELinkClickByText($oIE, "Attack Again!")
									_IELoadWait($oIE)
									Sleep(2000)
									;MsgBox(0,"","pause")
									If $fightagain = -1 Then
										ConsoleWrite("Fighting the same opponent again..." & @CRLF)
										If StringInStr(_IEPropertyGet($oIE, "innertext"), "You lose!") Then
											ConsoleWrite("Fight lost :-(    vs. -> Opponent level: " & $myFightArray[1][1] & "  Opponent mafia size: " & $myFightArray[1][2] & @CRLF)
											If $fightPlace = "Cuba" Then
												$CubaFights = $CubaFights + 1
												$CubaFightsLosses = $CubaFightsLosses + 1
											ElseIf $fightPlace = "NY" Then
												$NYFights = $NYFights + 1
												$NYFightsLosses = $NYFightsLosses + 1
											EndIf
											ExitLoop
										ElseIf StringInStr(_IEPropertyGet($oIE, "innertext"), "You win!") Then
											ConsoleWrite("Fight won :-)    vs. -> Opponent level: " & $myFightArray[1][1] & "  Opponent mafia size: " & $myFightArray[1][2] & @CRLF)
											If $fightPlace = "Cuba" Then
												$CubaFights = $CubaFights + 1
												$CubaFightsWins = $CubaFightsWins + 1
											ElseIf $fightPlace = "NY" Then
												$NYFights = $NYFights + 1
												$NYFightsWins = $NYFightsWins + 1
											EndIf
										Else
											ConsoleWrite("Fight result unknown..." & @CRLF)
;~ 											If $fightPlace = "Cuba" Then
;~ 												$CubaFights = $CubaFights + 1
;~ 											ElseIf $fightPlace = "NY" Then
;~ 												$NYFights = $NYFights + 1
;~ 											EndIf
											_IEQuit($oIE)
											_Initialize()
											_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=fight&xw_action=view")
											_IELoadWait($oIE)
											Sleep(2000)
											ExitLoop
										EndIf
									Else

										ConsoleWrite("Going to look for another opponent..." & @CRLF)
										ExitLoop
									EndIf
								Else
;~ 									ConsoleWrite("Going to look for another opponent..." & @CRLF)
									ExitLoop
								EndIf
							WEnd
						Else
							ConsoleWrite("Fight result unknown..." & @CRLF)
;~ 							If $fightPlace = "Cuba" Then
;~ 								$CubaFights = $CubaFights + 1
;~ 							ElseIf $fightPlace = "NY" Then
;~ 								$NYFights = $NYFights + 1
;~ 							EndIf
							_IEQuit($oIE)
							_Initialize()
							_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=fight&xw_action=view")
							_IELoadWait($oIE)
							Sleep(2000)
							ExitLoop
						EndIf
						;MsgBox(0, "Body Text", $linkcounter & " - opponent:" & $myFightArray[1][0])
						ExitLoop
					EndIf
				EndIf
			Next
		Else
			ConsoleWrite("Done fighting..." & @CRLF)
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_DoFights

Func _AcceptEnergyPack()

;~ 	_IELinkClickByText($oIE, "Home", 1)
;~ 	_IELoadWait($oIE)
	_IELoadWait($oIE)
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/")
	_IELoadWait($oIE)
	Sleep(3000)
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_user_experience")
	$experience = Number(_IEPropertyGet($oDiv, "innertext"))
	$oDiv = _IEGetObjById($oIE, "app" & $mynum & "_exp_for_next_level")
	$nextlevelexp = Number(_IEPropertyGet($oDiv, "innertext"))
	;MsgBox(0, "sdf", $nextlevelexp - $experience)
	$energypack = 0

	$sMyString = "Use energy pack."
	$oLinks = _IELinkGetCollection($oIE)
	For $oLink In $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Then
			$energypack = $energypack + 1
		EndIf
	Next
	If $energypack > 0 Then
		If $minExpDiff < $nextlevelexp - $experience Then
			_IELinkClickByText($oIE, "Use energy pack.")
			_IELoadWait($oIE)
			Sleep(1000)
			ConsoleWrite("Energy pack accepted..." & @CRLF)
			$sendenergypack = _IELinkClickByText($oIE, "Send Energy Pack")
			_IELoadWait($oIE)
			If $sendenergypack = -1 Then
				ConsoleWrite("Energy pack sent..." & @CRLF)
			Else
				ConsoleWrite("Energy pack not sent..." & @CRLF)
			EndIf
			Sleep(2000)
		Else
			ConsoleWrite("Energy pack is not to be used at this moment..." & @CRLF)
		EndIf
	Else
		ConsoleWrite("Energy pack not available..." & @CRLF)
	EndIf

EndFunc   ;==>_AcceptEnergyPack

Func _Fly($destination)
	_IELoadWait($oIE)
	Sleep(1000)
	If $destination = _CheckPlace() Then
		ConsoleWrite("You are in " & $destination & @CRLF)
	Else
		ConsoleWrite("Flying to " & $destination & @CRLF)
;~ 		_IELinkClickByText($oIE, "Fly to " & $destination)
		If $destination = "NY" Then
			_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=travel&xw_action=travel&xw_city=2&destination=1&from=job")
		ElseIf $destination = "Cuba" Then
			_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=travel&xw_action=travel&xw_city=1&destination=2&from=job")
		Else
			ConsoleWrite("What the ... ?")
		EndIf
		_IELoadWait($oIE)
		Sleep(3000)
		If $destination = _CheckPlace() Then
			ConsoleWrite("Landed in " & $destination & @CRLF)
		Else
			ConsoleWrite("Ooops.." & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>_Fly

Func _CheckPlace()
	_IELoadWait($oIE)
	Sleep(2000)
	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Cuban Pesos   (Bank)", 1) Then
		Return ("Cuba")
	ElseIf StringInStr(_IEPropertyGet($oIE, "innertext"), "Cash   (Bank)", 1) Then
		Return ("NY")
	Else
		ConsoleWrite("Problem reading current position... " & @CRLF)
		Return ("NA")
	EndIf
EndFunc   ;==>_CheckPlace


Func _ClaimRewards()
	ConsoleWrite("Claiming any rewards..." & @CRLF)
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=view")
	_IELoadWait($oIE)
	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Click here to claim your reward.") Then
		ConsoleWrite("Found rewards to claim..." & @CRLF)
		$oLinks = _IELinkGetCollection($oIE)
		For $oLink In $oLinks
			$sLinkText = _IEPropertyGet($oLink, "innerText")
			If StringInStr($sLinkText, "Click here to claim your reward.") Then
				_IEAction($oLink, "click")
				_IELoadWait($oIE)
				Sleep(2500)
				ConsoleWrite("Claimed my reward..." & @CRLF)
			EndIf
		Next
	Else
		ConsoleWrite("No Rewards to claim... " & @CRLF)
	EndIf
EndFunc   ;==>_ClaimRewards

Func _GetGifts()
	ConsoleWrite("Collecting Gifts from other players..." & @CRLF)
;~ 	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=view")
;~ 	_IELoadWait($oIE)
;~ 	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Click here to see it!") Then
;~ 		ConsoleWrite("Found Gifts to Collect..." & @CRLF)
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=expendable&xw_action=view")
	_IELoadWait($oIE)
	Sleep(2000)
;~ 		$oLinks = _IELinkGetCollection($oIE)
;~ 		For $oLink In $oLinks
;~ 			$sLinkText = _IEPropertyGet($oLink, "innerText")
;~ 			If StringInStr($sLinkText, "Click here to see it!") Then
;~ 				_IEAction($oLink, "click")
;~ 				_IELoadWait($oIE)
;~ 				Sleep(2500)
;~ 				ConsoleWrite("Collected Gift..." & @CRLF)
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next
;~ 	Else
;~ 		ConsoleWrite("No gifts found to collect..." & @CRLF)
;~ 	EndIf
EndFunc   ;==>_GetGifts

Func _Heal()
	ConsoleWrite("Visiting Hospital...")
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=hospital&xw_action=view")
	_IELoadWait($oIE)

	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Heal your character for") Then
		$oLinks = _IELinkGetCollection($oIE)
		For $oLink In $oLinks
			$sLinkText = _IEPropertyGet($oLink, "innerText")
			If StringInStr($sLinkText, "Heal your character for") Then
				_IEAction($oLink, "click")
				_IELoadWait($oIE)
				Sleep(2500)
				ConsoleWrite(" - HEALED" & @CRLF)
			EndIf
		Next
	Else
		ConsoleWrite(" - Could not be healed" & @CRLF)
	EndIf
EndFunc   ;==>_Heal

Func _HelpFriend()
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=view")
	_IELoadWait($oIE)
	ConsoleWrite("Helping any Friends..." & @CRLF)

	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Click here to help out") Then
		ConsoleWrite("Found friends to help..." & @CRLF)
		$oLinks = _IELinkGetCollection($oIE)
		For $oLink In $oLinks
			$sLinkText = _IEPropertyGet($oLink, "innerText")
			If StringInStr($sLinkText, "Click here to help out") Then
				_IEAction($oLink, "click")
				_IELoadWait($oIE)

				ConsoleWrite("Helped a friend..." & @CRLF)
				_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=view")
				_IELoadWait($oIE)
				Sleep(2500)
			EndIf
		Next
	Else
		ConsoleWrite("No Friends to help... " & @CRLF)
	EndIf
EndFunc   ;==>_HelpFriend

Func _PlayLotto()
	_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=index&xw_action=view")
	_IELoadWait($oIE)
	ConsoleWrite("Lotto..." & @CRLF)

	If StringInStr(_IEPropertyGet($oIE, "innertext"), "Play Now and Win Big!") Then
		ConsoleWrite("Going to try to get lucky..." & @CRLF)
;~ 		_IELinkClickByText($oIE, "Play Now and Win Big!")
		_IENavigate($oIE, "http://apps.facebook.com/inthemafia/remote/html_server.php?xw_controller=lotto&xw_action=daily_ticket")
		_IELoadWait($oIE)
		Sleep(3500)

;~ 		$sMyString = "Auto-Select Numbers"
;~ 		$oLinks = _IELinkGetCollection($oIE)
;~ 		ConsoleWrite($oLinks & @CRLF)
;~ 		For $oLink In $oLinks
;~ 			$sLinkText = _IEPropertyGet($oLink, "innerText")
;~ 			If StringInStr($sLinkText, $sMyString) Then

;~ 				_IEAction($oLink, "click")
;~ 				_IELoadWait($oIE)
;~ 				Sleep(3000)
;~ 			EndIf
;~ 		Next

;~ 		If StringInStr(_IEPropertyGet($oIE, "innertext"), "Auto-Select Numbers") Then
;~ 			_IELinkClickByText($oIE, "Auto-Select Numbers")
;~ 			_IELoadWait($oIE)
;~ 			Sleep(2500)
;~ 		Else
;~ 			ConsoleWrite("ooops..." & @CRLF)
;~ 		EndIf

;~ _IELinkClickByText($oIE, "3")
;~ _IELinkClickByText($oIE, "29")
;~ _IELinkClickByText($oIE, "2")

		_IELinkClickByText($oIE, "Submit Ticket(s)")
		_IELoadWait($oIE)
		Sleep(2500)
	Else
		ConsoleWrite("Can not play now..." & @CRLF)
	EndIf
EndFunc   ;==>_PlayLotto

Func _StopLoop()
	ConsoleWrite("The loop will stop at the end of script..." & @CRLF)
	Global $loop = 0
EndFunc   ;==>_StopLoop
