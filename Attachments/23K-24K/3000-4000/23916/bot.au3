; http://msdn2.microsoft.com/en-us/library/a...office.11).aspx
;#include <GUIConstants.au3>


#CS TradeBot Ultra by Brian Oliver
   This program is not for resale without express permission from Brian Oliver
   Please send questions and requests to c08oliverbrian@hotmail.com
   
   ***In order for this program to run, you must have a folder on the desktop called mtgobot.
   
   ***With MTGO launched, run the script.  When you are ready to test, click run.  To terminate, click close.
   Do not close, minimize or switch MTGO program while the bot is running.
   
   Revision History (Date, Initials, Description)
   09/04/08	BCO	waitfortrade circular refs cleared, checksum changed to infinite loop
				resetfromwithdraw circular refs cleared
				aborttradecircular refs cleared
			
	Desired Revisions
		If mtgo becomes inactive, pause the bot
		Add smart buying capability
		Add sales reports
		Use specific checksums in place of other methods such as wait for changve checksums
		Add clean interface
		Add help File
		Add automatic, intellignet, dynamic price adjustment to maximize sales
		Create smarter advertising
		Add function to deal with a chat window opening in the middle of a trade
		Check for inactive trade after 1 minute of inactivity, abort after 2
#CE

#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>
#include <Misc.au3>

$dll = DllOpen("user32.dll")

Dim $CardName [99]
Dim $CardSet [99]
Dim $CardQty [99]
Dim $CardPrice [99]
Dim $Update
Dim $run
Dim $stop
Dim $fCursor
Dim $guimsg
Dim $QtyVal [10]
Dim $Price
Dim $Player
Dim $PlayerArray [9999]
Dim $checksum
Const $miLANG_ENGLISH = 9
Dim $i
Dim $j
Dim $miDoc, $Doc
Dim $str
Dim $oWord
Dim $sArray[99]
Dim $count
Dim $miLayout
Dim $sFile
Dim $simage
Dim $greetMessage
Dim $TixQty
Dim $PlayerLocation
Dim $count
Dim $ticketTaken
Dim $bg
Dim $goto
Dim $temp
Dim $Credit

$maxtime = 600000

$gui = GUICreate ( "TradeBot Ultra - by Brian Oliver", 200, 300, @DesktopWidth-200, @DesktopHeight-300)
GUISetBkColor (0x000000)
;$bg = GUICtrlCreatePic(@DesktopDir & "\mtgobot\bg.bmp",0,0)
$run = GUICtrlCreateButton ( "Run Bot", 10, 70)
$stop = GUICtrlCreateButton ( "Stop Bot", 10, 110)
$update = GUICtrlCreateButton ( "Update Prices", 10, 150)
GUISetState ()
GuiWait()
Func Close() ;close gui and terminate script
Exit
EndFunc

Func GuiWait() ;Wait for user to select to trade or update prices or...
While 1
	$guimsg = GUIGetMsg()
	Select
	Case $guimsg = $run
	;Ad()
		waitForTrade()
	Case $guimsg = $stop
		GuiWait()
	Case $guimsg = $update
		Update()
	Case $guimsg = -3
		Close()
	EndSelect
sleep(100)
  WEnd
EndFunc
Func Ad() ;Type an ad into the trading channel
		MouseClick("left", 100,728, 1, 10)
		sleep(100)
		MouseClick("left", 100,635, 1, 10)
		sleep(100)
		MouseClick("left", 275,683, 1, 10)
		sleep(100)
		MouseClick("left",867, 490, 5)
		$str = "/join trading"
	Send($str)
	Send("{ENTER}")
	sleep(100)
		MouseClick("left", 770,45, 1, 10)
		sleep(100)
		MouseClick("left",867, 490, 5)
		$str = "Selling Cards at the Best Prices! Don't trade for more, Trade4Less"
	Send($str)
	Send("{ENTER}")
EndFunc

  $maxtime = 600000 ;end trade after 10 minutes

Func GetQty($j);returns the quantity of an item being sold where j is the line number
$QtyVal[1] =  2123377744
$QtyVal[2] =  3139319573
$QtyVal[3] =  3416667955
$QtyVal[4] =  1109538188
$QtyVal[0] = PixelChecksum(20, 595+$j, 35, 610+$j)

Select
Case $QtyVal[0] = $QtyVal [1]
	return 1
Case $QtyVal[0] = $QtyVal [2]
	return 2
Case $QtyVal[0] = $QtyVal [3]
	return 3
Case $QtyVal[0] = $QtyVal [4]
	return 4
EndSelect
EndFunc
Func GetPrice($CardName);Pass card name to pull prioce from list
	Dim $Arrayline[999]
	Dim $row
	Dim $i

	$count = 1
	_FileReadToArray(@DesktopDir & "\mtgobot\Price.txt", $Arrayline)
		;_ArrayDisplay($Arrayline)
			$row = _ArraySearch($Arrayline, StringTrimLeft(StringTrimRight($CardName,2),2), 0, 0, 0, 1)+1
			While $row = 0
				$str = StringTrimLeft(StringTrimRight($sArray[1],$count),$count)
				$row = _ArraySearch($Arrayline, $str, 0, 0, 0, 1)+1
				If $str = "" Then
					return "Unrecognized Card"
					EndIf
				$count += 1
			WEnd
	return $Arrayline[$row]
EndFunc
Func CheckTix() ;OCR result for available tix
$left = 16
$right = 104
$top = 108
$bottom = 122
	$sTargetImage = @DesktopDir & "\mtgobot\OCR_tgt.jpg"
	_ScreenCapture_Capture($sTargetImage, $left, $top, $right, $bottom, $fCursor = False)
	$miDoc = ObjCreate("MODI.Document")
$miDocView = ObjCreate("MiDocViewer.MiDocView")

$Viewer = GUICreate ( "Embedded MODI Viewer", 640, 580,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2)
GUICtrlCreatePic ( $sTargetImage, 320, 290, 0, 0)
GUICtrlSetResizing ($Viewer, $GUI_DOCKAUTO)
GUISetBkColor(0x000000)
GUISetState ()
$MiDocView.Document = $miDoc
$MiDocView.SetScale (1, 1)
;_ScreenCapture_Capture($sTargetImage, 350, 250, 750, 600, $fCursor = False)
_ScreenCapture_Capture($sTargetImage, 450, 350, 650, 500, $fCursor = False)
GUISetState (@SW_HIDE)
$miDoc.Create($sTargetImage)
;$miDoc.Ocr($miLANG_ENGLISH, True, False)
$miDoc.Ocr

$i = 0
$str = ""
For $oWord in $miDoc.Images(0).Layout.Words

    $str = $str & " " & $oWord.text
    $sArray [$i] = $oWord.text
    $i += 1
Next

ConsoleWrite("FROM GETNAME: " & $str & @CrLf)
$miDoc.Close

_WinAPI_DeleteObject($miDoc)
_WinAPI_DeleteObject($miDocView)


return $str
EndFunc
Func GetName($j) ;OCR result for the player's name
$left = 52
$right = 209
$top = 595+$j
$bottom = 610+$j
	$sTargetImage = @DesktopDir & "\mtgobot\OCR_tgt"&$j&".jpg"
	_ScreenCapture_Capture($sTargetImage, $left, $top, $right, $bottom, $fCursor = False)
	$miDoc = ObjCreate("MODI.Document")
$miDocView = ObjCreate("MiDocViewer.MiDocView")

$Viewer = GUICreate ( "Embedded MODI Viewer", 640, 580,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2)
GUICtrlCreatePic ( $sTargetImage, 320, 290, 0, 0)
GUICtrlSetResizing ($Viewer, $GUI_DOCKAUTO)
GUISetBkColor(0x000000)
GUISetState ()
$MiDocView.Document = $miDoc
$MiDocView.SetScale (1, 1)
;_ScreenCapture_Capture($sTargetImage, 350, 250, 750, 600, $fCursor = False)
_ScreenCapture_Capture($sTargetImage, 450, 350, 650, 500, $fCursor = False)
GUISetState (@SW_HIDE)
$miDoc.Create($sTargetImage)
;$miDoc.Ocr($miLANG_ENGLISH, True, False)
$miDoc.Ocr

$i = 0
$str = ""
For $oWord in $miDoc.Images(0).Layout.Words

    $str = $str & " " & $oWord.text
    $sArray [$i] = $oWord.text
    $i += 1
Next

ConsoleWrite("FROM GETNAME: " & $str & @CrLf)
$miDoc.Close

_WinAPI_DeleteObject($miDoc)
_WinAPI_DeleteObject($miDocView)


return $str
EndFunc
Func waitForTrade() ;Wait until do you want to trade dialog pops up and then commence trading
;Variables for checksum location for looking for beginning of trade
$top = 415
$left = 500
$bottom = 420
$right = 505
While 1
$startTime = TimerInit()
	while 1
		if TimerDiff($startTime) > 300000 then; run an ad if it's been idle more than 5 minutes
			Ad()
			$startTime = TimerInit(); reset the timer
			endif
		If _IsPressed("1B", $dll) Then
			return
		EndIf
			$guimsg = GUIGetMsg()
	Select
	Case $guimsg = $stop
		return
	Case $guimsg = -3
		Close()
	EndSelect
		Sleep(100)
	If PixelChecksum(482,344,566,353) = 939919727 Then ;Go if trade pops up
		$goto = enterTrade()
		If $goto = "GuiWait" Then
			Return
		ElseIf $goto = "waitForTrade" Then
			ExitLoop
		EndIf
	EndIf
WEnd
WEnd
	EndFunc
Func enterTrade() ;Final clicks to get into the trade
		
		$checksum = PixelGetColor(522,258) ;click to enter the trade until it goes
		While PixelGetColor(522,258) = $checksum
		$x = 455
		$y = 448
	MouseClick("left",$x,$y, 1, 0)
	Sleep(100)
	WEnd
		$x = 783
		$y = 45
		sleep(1000)
	$checksum = PixelChecksum(8,200,50,500) ;click to float the chat window in a flat box until it changes
	while $checksum = PixelChecksum(8,200,50,500)
	MouseClick("left",$x,$y, 1, 0)
		Sleep(100)
	Wend
	sleep(200)
	$temp = 1; the trade is proceeding from the beginning with no errors known
	
	$goto = SellCards()
	Select
		Case $goto = "waitForTrade"
			Return
		Case $goto = "GuiWait"
			Return "GuiWait"
	EndSelect
		
EndFunc
Func GetPlayer() ;Get the player's Name
Dim $miDoc, $Doc
Dim $str
Dim $oWord
Dim $sArray[500]
Dim $count
Dim $miLayout

;take screenshot
    $sTargetImage = @DesktopDir & "\mtgobot\Player_tgt.jpg"
	_ScreenCapture_Capture($sTargetImage, 37, 260, 291, 289, $fCursor = False);233

$miDoc = ObjCreate("MODI.Document")
$miDocView = ObjCreate("MiDocViewer.MiDocView")

$Viewer = GUICreate ( "Embedded MODI Viewer", 640, 580,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2)
GUICtrlCreatePic ( $sTargetImage, 320, 290, 0, 0)
GUICtrlSetResizing ($Viewer, $GUI_DOCKAUTO)
GUISetBkColor(0xFFFFFF)
GUISetState ()
$MiDocView.Document = $miDoc
$MiDocView.SetScale (1, 1)
_ScreenCapture_Capture($sTargetImage, 250, 250, 750, 600, $fCursor = False)
GUISetState (@SW_HIDE)
$miDoc.Create(@DesktopDir & "\mtgobot\Player_tgt.jpg")
$miDoc.Ocr($miLANG_ENGLISH, True, False)

$i = 0

For $oWord in $miDoc.Images(0).Layout.Words
    $str = $str & $oWord.text & @CrLf
        ConsoleWrite("FROM GETPLAYER: " & $oWord.text & @CrLf)
    $sArray [$i] = $oWord.text
    $i += 1
Next

return $sArray [0]
EndFunc
Func SellCards() ;Check for changes and manage sub commands to give player info
	If $temp = 1 Then ;initalize the trade and clear credit, tickets taken
	$Credit = 0
	$Player = GetPlayer()
	_FileReadToArray(@DesktopDir & "\mtgobot\Player_Credit.txt", $PlayerArray)
	$PlayerLocation = _ArraySearch($PlayerArray,$Player)
	If $PlayerLocation > 0 Then ;This loads the credit from the credit log if there is any for the player
		$Credit = $PlayerArray [$PlayerLocation+1]
		EndIf
		
	sendMessage("I will send card prices you select. " & $Player & " you have " & $Credit & " Credits -- TradeBot Ultra")
	$startTime = TimerInit()
	$ticketTaken = 0
	;This might be unnecessary $confirmed = 0
EndIf

	$checksum = PixelGetColor(810,65); here we click confirm trade to avoid the hassle of asking "are you done"
										;If they choose more cards, the button must be reclicked
	While PixelGetColor(810,65) = $checksum
	MouseClick("left",765,72, 1, 0)	
	sleep(100)
	$count += 1
	If $count > 20 Then GuiWait()
	WEnd

		$checksum = PixelChecksum(67, 557, 77, 564)
				if PixelChecksum(470,320,500, 330) = 3185144375 then ;the player has withdrawn from the trade
			ResetFromWithdraw()
			return "waitForTrade"
		endif
		While $checksum = PixelChecksum(67, 557, 77, 564)
			Sleep(100)
		If _IsPressed("1B", $dll) Then ;Check for the escape key being presseed
			return "GuiWait"
		EndIf
			$guimsg = GUIGetMsg()
		Select
			Case $guimsg = $stop
				return "GuiWait"
			Case $guimsg = -3
				Close()
		EndSelect
		
		If PixelGetColor(721,80) = 0x000000 Then
			performThisTrade()
		EndIf
		WEnd
		
			While 1; Making sure that the confirm trade button has been clicked
			PixelSearch(362,59,372,75,0xBAC8CD,5)
			If Not @error Then
				ExitLoop
			EndIf
			MouseClick("left",339,71, 1, 0)
			sleep(100)
			WEnd

		$j = 0
		$Price = 0
		Sleep(100)
		While 1
		PixelSearch(60,598+$j,100,612+$j,0xEBE2AF);slightly lower to not check final line
		If @error Then
			ExitLoop
		EndIf
		$CardName [$j] = GetName($j)
		$CardQty [$j] = GetQty($j)
		$CardPrice [$j] = GetPrice($CardName[$j])
		If $CardPrice [$j] = "Unrecognized Card" Then
			sendMessage($CardName[$j] & " is an" & $CardPrice[$j] & ".  This error has been added to my log.  If you wish to continue trading, return this card.")
			FileOpen(@DesktopDir & "\mtgobot\priceerror.txt", 1)
			$str = @MON & "/" & @WDAY & "/" & @YEAR & @TAB & $CardName[$j] & @TAB & $Player
			FileWrite(@DesktopDir & "\mtgobot\priceerror.txt", $str)
			FileClose(@DesktopDir & "\mtgobot\priceerror.txt")
			$temp = 0
			SellCards()
			EndIf
		sendMessage($CardName[$j] & " (" & $CardPrice[$j] & ")")
		$Price = $Price + $CardQty[$j]*$CardPrice[$j]
		$j = $j + 17
		WEnd
		sendMessage("total is " & $Price & " When you are finished click confirm.")
		
		$TixQty = Ceiling($Price)
		If $TixQty > $ticketTaken + $Credit Then
		If TakeTickets($TixQty-$ticketTaken) = "waitForTrade" Then
			return "waitForTrade"
		EndIf
		EndIf
		
		MouseClick("left",339,76, 1, 10)
		
		if TimerDiff($startTime) > $maxtime then
			abortTrade()
			return "waitForTrade"
		endif

EndFunc
Func sendMessage($messageString) ;sends a message to the undocked, large chat
	MouseClick("left",67, 218, 5)
	Send($messageString)
	Send("{ENTER}")
EndFunc
Func resetFromWithdraw()
	$checksum = PixelGetColor(512,240)
	While $checksum = PixelGetColor(512,240)
	MouseClick("left",513,450)
	sleep(100)
	WEnd
	sleep(1000)
EndFunc
Func TakeTickets($TixQty) ;take tickets and store info in a log
	For $i = 1 to $TixQty
		
			MouseClickDrag("left",158, 36, 158, 180)
		IF Not CheckTix() = "Event Ticket" Then
			sendMessage("Make Tickets Tradeable")
			sleep(300)
			abortTrade()
			return "waitForTrade"
		EndIF
			MouseClickDrag("left",158, 180, 158, 36)
		$checksum = PixelChecksum(451, 555, 476, 564)
		While PixelChecksum(451, 555, 476, 564) = $checksum
				MouseClick("left",19 , 118,2,10)
				Sleep(500)
			WEnd
		
	Next
	$ticketTaken = $ticketTaken + $TixQty
EndFunc
Func performThisTrade() ;finalize trade
		
	$checksum = PixelChecksum(350,50,360,60)
	while $checksum = PixelChecksum(350,50,360,60)
		sleep(100)
		MouseClick("left",363,52)
	wend
	Sleep(1000)
		$checksum = PixelChecksum(350,350,450,450)
	while $checksum = PixelChecksum(350,350,450,450)
		sleep(100)
		$checksum = PixelChecksum(67, 557, 77, 564)
		if PixelChecksum(470,320,500, 330) = 3185144375 then
		ResetFromWithdraw()
		endif
		MouseClick("left",513,529)
	wend
			
	$sFile = FileOpen(@DesktopDir & "\mtgobot\Player_credit.txt",2)
	$Credit = $Credit + $ticketTaken - $Price
				FileOpen(@DesktopDir & "\mtgobot\tradelog.txt", 1)
			FileWrite(@DesktopDir & "\mtgobot\tradelog.txt", @MON & "/" & @WDAY & "/" & @YEAR & @TAB & $Player & @Tab & "Paid " & $Price & @Tab & "used " & $ticketTaken & " tickets, recieved " & $Credit & " credit")
			FileClose(@DesktopDir & "\mtgobot\tradelog.txt")
$row = _ArraySearch($PlayerArray,$Player)
If @error Then

_ArrayAdd($PlayerArray,$Player)
_ArrayAdd($PlayerArray,$Credit)
Else
$PlayerArray[$PlayerLocation+1] = $Credit
EndIf
_FileWriteFromArray(@DesktopDir & "\mtgobot\Player_credit.txt", $PlayerArray)
	$checksum = PixelGetColor(281,140)
		while $checksum = PixelGetColor(281,140)
		sleep(100)
		MouseClick("left",292,44)
	wend
		sleep(1000)
		MouseClick("left",514,527)
		sleep(1000)
	waitForTrade()
	FileClose($sFile)
EndFunc
Func abortTrade()
	MouseClick("left",437 ,76)
	sleep(200)
	MouseClick("left",454 ,452)
	sleep(2000)
	MouseClick("left",509 ,452)
	sleep(5000)	
EndFunc

Func Update() ;grab newest prices off the internet
$Update = 1
If $Update = 1 Then;update pricelists
	FileDelete(@DesktopDir & "\mtgobot\Price.txt")

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

Func ListUpdate($CardSet);get price results for specified set
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
			$sFile = FileOpen(@DesktopDir & "\mtgobot\Price.txt", 1)
			_FileWriteFromArray($sFile, $Arrayline, 1)
			FileClose($sFile)
			;Run("Notepad.exe " & @DesktopDir & "\mtgobot\Price.txt")
			FileClose($sFile)

EndFunc