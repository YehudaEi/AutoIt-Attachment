; http://msdn2.microsoft.com/en-us/library/a...office.11).aspx
#include <GUIConstants.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <File.au3>
Dim $CardName
Dim $CardSet
Dim $CardQty
Dim $Update
Dim $run
Dim $stop
Dim $fCursor
Dim $guimsg

;StandingReserve's commonBot
;Version: 0.11
$tradeOn = 1
$maxtime = 600000
;add leftovers info
$greetMessage = "Hello, I'm an automated trader.  As you select cards, I will show you prices and update the total cost.  You have 10 minutes to complete your trade.  If you encounter any problems please PM betterwork."
$noTicket = "You have no tickets tradeable.  Please make a ticket tradeable or exit the trade"
$iniFileLines = 8
$os = "2000"
$resolutionX = 1024
$resolutionY = 768
$colordepth = 32

;Variables for screen locations
;Variables for checksum location for looking for beginning of trade
$top = 415
$left = 500
$bottom = 420
$right = 505

;Variables for checking for withdrawing from trade
;PixelGetColor(639,329) = 3356477 then
$withdrawX = 639
$withdrawY = 329
$withdrawColor = 3356477

;Variable to recognize 32 cards
;80,280,100,300
$CardTarget = 490423324
$cardTakenX1 = 80
$cardTakenY1 = 280
$cardTakenX2 = 100
$cardTakenY2 = 300

;Location of ticket already taken
;MouseClick("left",185,155,1,10)
$myTicketX = 185
$myTicketY = 155

;Variables for narrowing our search down to just tickets
;MouseClick("left",80,62,1,10)
;MouseClick("left",240,144,1,0)
;MouseClick("left",160,200,1,10)
$searchX = 80
$searchY = 62
$dropX = 240
$dropY = 144
$boosterX = 160
$boosterY = 200

;Ticket to take location
;if PixelGetColor(420,155) <> 9185056 then
$ticketX = 420
$ticketY = 155
$ticketColor = 9185056

;Tradebutton Location
;MouseClick("left",195,60,1,10)
$tradeButtonX = 195
$tradeButtonY = 60

;Make sure they don't cheat the bot
$cheatCheckX = 195
$cheatCheckY = 140
$myTicketsBackground = 2969133

;Variables for confirming the trade
$confirmDropX = 240
$confirmDropY = 330
$confirmClickX = 170
$confirmClickY = 345

;Variables to determine if they have confirmed
$theirConfirmX1 = 45
$theirConfirmY1 = 325
$theirConfirmX2 = 60
$theirConfirmY2 = 330
$theirConfirmChecksum = 518491551


;Final trade confirmation
$performThisTradeX = 715
$performThisTradeY = 600
$performThisTradeWaitX1 = 300
$performThisTradeWaitY1 = 460
$performThisTradeWaitX2 = 305
$performThisTradeWaitY2 = 465

;Checking for completed Trade
$tradeCompletedX = 500
$tradeCompletedY = 400
$tradeCompletedColor = 3290940
$tradeCompletedCheckX = 614
$tradeCompletedCheckY = 424
$completedDragStartX = 525
$completedDragStartY = 60
$completedDragFinishX = 800
$completedDragFinishY = 60
$completedDragClickX = 1000
$completedDragClickY = 55

;Canceling Trade Variables
$cancelTradeX = 775
$cancelTradeY = 600

;reset from withdrawel variables
$resetX = 606
$resetY = 418

;Chat location
$chatX = 285
$chatY = 710

;CardsRequest location
$RequestLeft = 19
$RequestRight = 412
$RequestTop = 209
$RequestBottom = 593

GUICreate ( "TradeBotOpto")
$run = GUICtrlCreateButton ( "Run Bot", 10, 30)
$stop = GUICtrlCreateButton ( "Stop Bot", 10, 70)
$update = GUICtrlCreateButton ( "Update Prices", 10, 100)
GUISetState ()

While 1
	$guimsg = GUIGetMsg()
	Select
	Case $guimsg = $run
		RunBot()
	Case $guimsg = $stop
		StopBot()
	Case $guimsg = $update
		Update()
	Case $guimsg = -3
		StopBot()
		      ExitLoop
  EndSelect
  Sleep(100)  ; Idle around
  WEnd

Func RunBot()
	$top = 620
	$left = 30
	$bottom = 709
	$right = 189
	OCR($left,$top,$right,$bottom)
EndFunc
Func StopBot()
	Exit
EndFunc
Func Update()
	;to update price lists, set update to 1, to only update several, change the statements in the program
$Update = 1
If $Update = 1 Then;update pricelists
	ListUpdate("SHM");shadowmoor
	ListUpdate("MOR");morningtide
	ListUpdate("LRW");lorwyn
	ListUpdate("FUT");futuresight
	ListUpdate("PLC");planar chaos
	ListUpdate("TSP");time spiral
	ListUpdate("CSP");coldsnap
	ListUpdate("10TH");tenth edition
Else
	msgbox(0, "Error", "You have disabled this feature")
EndIf
EndFunc
Func ListUpdate($CardSet);Pass abbreviated card set
Dim $Arrayline[999]
Dim $PriceList[999][10]
Dim $col
Dim $row
Dim $oHTTP
Dim $HTMLSource
Dim $i

	    $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
    $oHTTP.Open("GET","                                                      "&$CardSet&"&excel=true") 
    $oHTTP.Send()
    $HTMLSource = $oHTTP.Responsetext
	$HTMLSource = StringTrimLeft($HTMLSource, StringInStr($HTMLSource, "Card")-1)
	$HTMLSource = StringReplace($HTMLSource,@LF,"|");couldn't get it without this intermediate step, unsure why
	$Arrayline = StringSplit($HTMLSource, "|")
$col = 1
$row = 0
$i = 1
				for $col = 1 to 8
					$PriceList[$row][$col] = $Arrayline[$i]
					$i = $i + 1
				Next
				$row = 1
	  While $i <= $Arrayline[0]-8
				for $col = 1 to 8
					$PriceList[$row][$col] = $Arrayline[$i]
					$i = $i + 1
				Next
				$row = $row + 1
			WEnd
			_FileWriteFromArray("C:\Users\Brian\Desktop\mtgobot\Price_"&$CardSet&".txt",$Arrayline, 1)
			Run("Notepad.exe " & "C:\Users\Brian\Desktop\mtgobot\Price_"&$CardSet&".txt")

	EndFunc
Func OCR($left, $top, $right, $bottom);pass bounds to capture
	;to work best, change background file to black (bknd_001_512pixw_512pixh_brown_marble_cracked)
Dim $miDoc, $Doc
Dim $str
Dim $oWord
Dim $sArray[500]
Dim $count
Const $miLANG_ENGLISH = 9

;take screenshot
    $sTargetImage = "C:\Users\Brian\Desktop\mtgobot\OCR_tgt.jpg"
	_ScreenCapture_Capture($sTargetImage, $left, $top, $right, $bottom, $fCursor = False)

$miDoc = ObjCreate("MODI.Document")
$miDocView = ObjCreate("MiDocViewer.MiDocView")
$miDoc.Create("C:\Users\Brian\Desktop\mtgobot\OCR_tgt.jpg")
$miDoc.Ocr($miLANG_ENGLISH, True, False)

$i = 0

For $oWord in $miDoc.Images(0).Layout.Words

    $str = $str & $oWord.text & @CrLf
        ConsoleWrite($oWord.text & @CRLF)
    $sArray [$i] = $oWord.text
    $i += 1
Next
_FileWriteFromArray("C:\Users\Brian\Desktop\mtgobot\OCR_tgt.txt", $sArray, 0)
EndFunc