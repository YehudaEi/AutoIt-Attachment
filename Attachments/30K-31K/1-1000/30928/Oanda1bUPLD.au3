#include <Misc.au3>
;PRECONDITION GLOBAL: OANDA IS LOGGED IN,test before executing this trade.

Global $main_window = "xxxxxxx"  ; Your user name comes in here, it displays in the title of the oanda java app.
Global $small_oanda_window = "OANDA FXGame"
Global $trade_rejected_window = "Error"
Global $Current_rates_window  =  "Current rates"   ; says current rates

Global $firefox_oanda_login_page = "Login - oanda fxtrade"
Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

Global $OandaLots = 0
Global $warning_win = "Warning"
$OandaLots = 10
Local $buyOrSell = True ; Buy is True, short is False
Local $market_order = "Market Order"
Local $ticker = 'eurusd'
Local $ticker = 'usdjpy'

;GLOBAL PRECONDITION: Your Oanda box should have in the following order: Eurusd, usdjpy, usdgbp, eurjpy

;On bootup the Oanda java window isn't in single click trade mode. Function windowstate places it in single trade mode.
; first window must be eurousd, then japyen, gold and then swissfrank for only four windows. 
;See_if_Oanda_is_LoggedIn() ; Oanda logs out the app. automatically, close the java app and relogin from the firefox browser. 
;Other error is invalid units if there are no units entered when doing a market order.


;*************  test for trade *******
; TestFor_trade_rejected();  
; Function called after every trade to see if trade is rejected. Basically scan for any increase in visible open windows. 
; This window must be closed forceably by some method and trad re-entered. 
;************************************************
;windowstate($main_window) ; gets oanda in single click market order mode without confirmation.  ;1

;Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'usdjpy')
;Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'eurusd')


;Count_Oanda_Windows()

;Number_of_visible_windows()
; Get all the window handles open at startup of java up. Any new window pops up it is probably a "trade rejected" error.

;Close_all_trades($main_window)  ;3
;Exit


;EnterLots_for_Ticker($main_window, $OandaLots, $buyOrSell, $ticker)  ;2  
;EnterLots_for_Ticker($main_window, $OandaLots, $buyOrSell, $ticker)  ;2  

;Close_all_trades($main_window)  ;3

Func Check_if_server_didnt_reject_trade()
	IF WinActive($trade_rejected_window) Then ;;wait 2 secs for oanda main window to appear.
		ConsoleWrite("Trade was rejected")
		MsgBox(0, "TRADE REJECTED DO MANUAL TRADE", "" & 100)
		Exit
	EndIf
	
	IF WinActive($Current_rates_window) Then ;if trade rejected could also show a current rates window
		ConsoleWrite("Trade was rejected")
		MsgBox(0, "TRADE REJECTED DO MANUAL TRADE", "" & 100)
		Exit
	EndIf
EndFunc



Func Count_Oanda_Windows()
	; There should only be three Oanda windows open 1)firfox with oanda, 2)Oanda main java app, 3)Small oanda java window.
	; Better idea is to count all the default open visible windows, any more pops up then flag as trade rejected.
	$var = WinList()
	$FirefoxHandle = ""
	$OandaWinCounter = 0
	For $i = 1 to $var[0][0]
	;Only display visible windows that have a title		
	If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
;		MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
		$location1 = StringInStr($var[$i][0], $small_oanda_window) ; Find the 1st occurance of "Mozilla Firefox"
		$location2 = StringInStr($var[$i][0], $main_window) ; Find the 1st occurance of "Mozilla Firefox"
		$location3 = StringInStr($var[$i][0], $firefox_oanda_login_page) ; Find the 1st occurance of "Mozilla Firefox"
		if $location > 0 Then
			$OandaWinCounter = $OandaWinCounter + 1
		Else
			;ConsoleWrite("Error with" & $location & @CRLF)
			;Exit
		EndIf
	EndIf
	Next
	ConsoleWrite("Number of oanda windows is = " & $OandaWinCounter) 
EndFunc


Func Number_of_visible_windows()
	;get the Warning window handle to close all trades
	$var = WinList()
	$visible_win_count = 0
	For $i = 1 to $var[0][0]
	;Only display visible windows that have a title
	If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		$visible_win_count = $visible_win_count + 1
	EndIf
	Next
	ConsoleWrite("Number of visibile windows is =   " & $visible_win_count)
EndFunc	



Func warningwinHandle()
	$handle =  get_Warning_handle()
	if $handle == "" then 
		ConsoleWrite("Error with getting handle on Warning windows" & $handle & @CRLF)
		Exit
	Else
		ConsoleWrite("war handle is:  " & $handle & @CRLF)
		WinMove($handle,"", 0,0)
	EndIf
	return($handle)
EndFunc

Func get_Warning_handle()
	;get the Warning window handle to close all trades
	$var = WinList()
	$WarningHandle = ""
	For $i = 1 to $var[0][0]
	;Only display visible windows that have a title
	If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		if $var[$i][0] == "Warning" then 
			ConsoleWrite("found warning window")
			$WarningHandle = $var[$i][1]
		;	MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
		EndIf
	EndIf
	Next
	Return($WarningHandle)
EndFunc


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc


; Close app normally
Func Close_all_trades($main_window)
	;PRE: There must be active trades.
	;POST: All trades closed at market.
	WinActivate($main_window)
	IF WinWaitActive($main_window,"",2) Then ;;wait 2 secs for oanda main window to appear.
		WinMove($main_window, "", 200, 200, 800, 600)  ; x,y
		$win_pos = WinGetPos($main_window)
;		MouseMove($win_pos[0]+127, $win_pos[1]+455,30) ; x, y 
		MouseClick("left", $win_pos[0]+127, $win_pos[1]+ 70,1) ; x, y  EURO POSITION.
		Sleep(800)
		MouseClick("left", $win_pos[0]+127, $win_pos[1]+ 110,1) ; x, y  EURO POSITION.
		Sleep(1000)
		MouseClick("left", $win_pos[0]+270, $win_pos[1]+ 110,1) ; x, y  EURO POSITION.
		Sleep(1000)
		$Warning_win_handle =  warningwinHandle()
		IF WinActive($Warning_win_handle,"") Then ;;wait 60secs to login
			ConsoleWrite("Found warning window" & @CRLF)
			$win_pos = WinGetPos($Warning_win_handle)
	;		MouseMove($win_pos[0]+127, $win_pos[1]+455,30) ; x, y 
			MouseClick("left", $win_pos[0]+248, $win_pos[1]+ 140,1) ; x, y  EURO POSITION.
			Sleep(500)
			;MouseMove($win_pos[0]+278, $win_pos[1]+100,30) ; x, y 
			MouseClick("left", $win_pos[0]+290, $win_pos[1]+ 138,1) ; x, y  EURO POSITION.
			Sleep(1000)
		Else
			ConsoleWrite("Found no warning window" & @CRLF)
			MsgBox(0, "OANDA warning window, to close all trades not working", "" & 100)
			SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
			SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
			SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
			SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
			Exit
		EndIf
	Else
		ConsoleWrite("Oanda not logging in" & @CRLF)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
		Exit
	EndIf
;	ConsoleWrite("Lots is " &  @CRLF)
EndFunc


Func testIFMarket_Order_not_displaying($market_order) ; ******* ERROR detection function *********
	; does not work autoit can't detect market orders window.
	IF WinWaitActive($main_window,"",2) Then ;;wait 2 secs for oanda main window to appear.
		WinMove($main_window, "", 200, 200, 800, 600)  ; x,y
		$win_pos = WinGetPos($main_window)
;		MouseMove($win_pos[0]+127, $win_pos[1]+455,30) ; x, y 
		MouseClick("left", $win_pos[0]+127, $win_pos[1]+455,1) ; x, y 
	Else
		ConsoleWrite("Oanda not logging in" & @CRLF)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
		Exit
	EndIf
	Sleep(4000)
	WinActivate($market_order)
	IF WinActive($market_order,"") Then ;;wait 60secs to login
		ConsoleWrite("Oanda market ERROR" & @CRLF)
		Exit
	Else
		ConsoleWrite("correct" & @CRLF)
;		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
;		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
	EndIf
EndFunc


Func Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, $ticker)
	; Do this after a trade has executed. 
	; PRE: Oanda in single trade one click execute  mode. IF not a market order window will popup. scan for ths window every nseconds.
	; NOTES: IF trade is clicked on euro or yen with no lots an "Error" window pops up with no units message. 
	WinActivate($main_window)
	IF WinWaitActive($main_window,"",2) Then ;;wait 2 secs for oanda main window to appear.
		WinMove($main_window, "", 200, 200, 800, 600)  ; x,y
		$win_pos = WinGetPos($main_window)
;		MouseMove($win_pos[0]+127, $win_pos[1]+455,30) ; x, y 
		if $ticker == "eurusd" Then MouseClick("left", $win_pos[0]+127, $win_pos[1]+455,1) ; x, y  EURO POSITION.
		if $ticker == "usdjpy" then MouseClick("left", $win_pos[0]+250, $win_pos[1]+455,1) ; x, y  yen window
	Else
		ConsoleWrite("Oanda not logging in" & @CRLF)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
		Exit
	EndIf
	Send("{BS},{BS},{BS},{BS},{BS},{BS},{BS},{BS},{BS},{BS}") ; clear window
	Send("{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL}") ; clear window
EndFunc


Func EnterLots_for_Ticker($main_window, $lots, $buyOrSell, $ticker)
	;PRECOND: 
	;1) Oanda app is in single click order execution mode.  Assumes window order is euro, japyen, swiss, gold etc.
	; this should be tested with some screen grab app that "sees" automatically whether everything is write. 
	; If not in single click mode the Oanda market_order window will pop-up.
	;2) Lots entry box should be clear from order Clear_tickerLots_box_of_all_entries.
	;POST: Order executed at market.
	WinActivate($main_window)
	IF WinWaitActive($main_window,"",2) Then ;;wait 2 secs for oanda main window to appear.
		WinMove($main_window, "", 200, 200, 800, 600)  ; x,y
		$win_pos = WinGetPos($main_window)
;		MouseMove($win_pos[0]+127, $win_pos[1]+455,30) ; x, y 
		if $ticker == "eurusd" Then MouseClick("left", $win_pos[0]+127, $win_pos[1]+455,1) ; x, y  EURO POSITION.
		if $ticker == "usdjpy" then MouseClick("left", $win_pos[0]+250, $win_pos[1]+455,1) ; x, y  yen window
	Else
		ConsoleWrite("Oanda not logging in" & @CRLF)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
		Exit
	EndIf
	Send("{BS},{BS},{BS},{BS},{BS},{BS},{BS}") ; clear window
	Send("{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL}") ; clear window
	Sleep(50)
	ConsoleWrite("Lots executed is " & $lots & @CRLF)
	Send($lots)
	Sleep(300)
;	MouseMove($win_pos[0]+100, $win_pos[1]+412,30) ; x, y 
	if ($buyOrSell == False) then 
		; Short euro
		if $ticker == 'eurusd' Then 
			MouseClick("left", $win_pos[0]+100, $win_pos[1]+412,1,20) ; x, y EURO position
			Check_if_server_didnt_reject_trade()
			Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'eurusd')
		EndIf
		if $ticker == 'usdjpy' then 
			MouseClick("left", $win_pos[0]+230, $win_pos[1]+412,1,20) ; x, y EURO position
			Check_if_server_didnt_reject_trade()
			Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'usdjpy')
		EndIf
		MouseMove(100,100,1) ; move mouse away or tooltip pops up which doesn't go away.
	Else
		; Long euro
		if $ticker == 'eurusd'  Then 
			MouseClick("left", $win_pos[0]+161, $win_pos[1]+412,1,20) ; x, y EURO position
			Check_if_server_didnt_reject_trade()
			Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'eurusd')
		EndIf
		if $ticker == 'usdjpy'  Then 
			MouseClick("left", $win_pos[0]+280, $win_pos[1]+412,1,20) ; x, y EURO position
			Check_if_server_didnt_reject_trade()
			Clear_tickerLots_box_of_all_entries_for_specific_ticker($main_window, 'usdjpy')
		EndIf
		MouseMove(100,100,1) ; move mouse away or tooltip pops up which doesn't go away.
	EndIf
EndFunc


Func windowstate($main_window)
	;;sizes the window and selects one-click order entry.
	WinActivate($main_window)
	IF WinWaitActive($main_window,"",2) Then ;;wait 60secs to login
		WinMove($main_window, "", 200, 200, 800, 600)  ; x,y
;		WinMove($main_window, "", 0, 0, @DesktopWidth, @DesktopHeight)
;		WinMove("[CLASS:Notepad]", "", 0, 0, 200, 200)
;		WinMove($window, "", 50, 50)
;		Sleep(3000)
		$win_pos = WinGetPos($main_window)
		MouseClick("left", $win_pos[0]+277, $win_pos[1]+350,1,50) ; x, y 
;		MouseMove($win_pos[0]+277, $win_pos[1]+350,30) ; x, y 
;		Sleep(1000)
	Else
		ConsoleWrite("Oanda not logging in" & @CRLF)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		SoundPlay(@MyDocumentsDir & "\timeout.wav" ,1)
		MsgBox(0, "OANDA NOT LOGGIN IN ERROR, main window not displaying", "" & 100)
		Exit
	EndIf
	testIFMarket_Order_not_displaying($market_order)
EndFunc



