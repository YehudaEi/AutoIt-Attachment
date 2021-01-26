;=== FXCM microlot automaton script ===
;This is a draft script, http://www.autoitscript.com (95% complete) that logs in an executes a market order on 
; the micro-lot trading platform of http://www.forexmicrolot.com from FXCM ,either demo or real.
;                                               
;http://www.autoitscript.com/forum/index.php?showtopic=97485 ''forum topic on issue''

$main_window = "FXCM Micro Trading Station"
$password= "*********" ; real password comes here.
$demo_password= "******" ; demo password comes here.
$marketOrder = "Create a Market Order"

FxcmlogIn_DEMO()
;FxcmlogIn_REAL()
;sleep(30000) ; wait to login
;datetime()
market_order(1,7,1)  ; buy usdjpy, with stake of 7 micro lots., 0(buy) , 1(sell)

;selectTicker(0) ; 0 eurusd, 1 usdjpy




Func FxcmlogIn_DEMO()
	;Keep caps lock off, if logged in already won't make a difference if this function run again.
	Opt("SendCapslockMode",0) ; http://www.autoitscript.com/forum/index.php?showtopic=47012&pid=351979&mode=threaded&start=#entry351979
	Send("{CAPSLOCK off}")
	If Not WinActive($main_window) Then
		WinActivate("FXCM Micro Trading Station")
		$temp = WinWaitActive("FXCM Micro Trading Station","",2)
		if ($temp == 0) then ; 0 if failure, 1 if active window returned.
			Run("C:\Program Files\Candleworks\FXTS2\FXTSpp.exe")
		EndIf
		$temp = WinWaitActive("FXCM Micro Trading Station","",10)		if ($temp == 0) then ; 0 if failure 1 if active window returned.
			;send email or anything else that FXCM is not responding.
			MsgBox(0, "FXCM window not available, LAUNCH APPLICATION", "" & $temp)
			Exit ; Exit script due to error. 
		EndIf
		$win_pos = WinGetPos("FXCM Micro Trading Station")
		Send("^l") ; CTRL+L for login.
		$temp = WinWaitActive("Login","", 2)
		if ($temp = 1) Then
			;ControlSend("Login","","[CLASS:Edit; INSTANCE:2]",$password) ;real trading
			ControlSend("Login","","[CLASS:ComboBox; INSTANCE:1]","d") ;demo select trading
			ControlSend("Login","","[CLASS:Edit; INSTANCE:2]",$demo_password) ;demo trade password
			ControlClick("Login","", "[CLASS:Button; INSTANCE:1]") ;demo login
		EndIf
	EndIf
EndFunc	

Func FxcmlogIn_REAL()
	Opt("SendCapslockMode",0) ; http://www.autoitscript.com/forum/index.php?showtopic=47012&pid=351979&mode=threaded&start=#entry351979
	Send("{CAPSLOCK off}")
	If Not WinActive($main_window) Then
;		Run("C:\WINDOWS\system32\javaws.exe "&Chr(34)&"C:\Documents and Settings\USERNAME\Application Data\Sun\Java\Deployment\cache\6.0\16\c798210-5433f404"&Chr(34))
		WinActivate("FXCM Micro Trading Station")
		$temp = WinWaitActive("FXCM Micro Trading Station","",2)
		if ($temp == 0) then ; 0 if failure, 1 if active window returned.
			Run("C:\Program Files\Candleworks\FXTS2\FXTSpp.exe")
		EndIf
		$temp = WinWaitActive("FXCM Micro Trading Station","",10)
		if ($temp == 0) then ; 0 if failure 1 if active window returned.
			;send email or anything else that FXCM is not responding.
			MsgBox(0, "FXCM window not available, LAUNCH APPLICATION", "" & $temp)
			Exit ; Exit script due to error. 
		EndIf
		Send("^l") ; CTRL+L for login.
;		Send("{RCTRL}+l ") ; CTRL+L for login.
		$temp = WinWaitActive("Login","", 2)
		if ($temp = 1) Then
			;ControlSend("Login","","[CLASS:Edit; INSTANCE:2]",$password) ;real trading
			ControlSend("Login","","[CLASS:ComboBox; INSTANCE:1]","r") ; real trading
			ControlSend("Login","","[CLASS:Edit; INSTANCE:2]",$password) ;real password
			ControlClick("Login","", "[CLASS:Button; INSTANCE:1]") ;demo login
		EndIf
	EndIf
EndFunc	


Func selectTicker($ticker)
	Global Const $CB_SETCURSEL = 0x14E
	$h_combobox = ControlGetHandle($marketOrder, "", 4408) ;ID of combo box is 4408
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_combobox, "int", $CB_SETCURSEL, "int", $ticker, "int", 0)
EndFunc

Func market_order($ticker, $stake, $buySell)
	$marketRange = 2
	;precond: fxcm application is running.
	WinActivate("FXCM Micro Trading Station")
	;Run("C:\WINDOWS\system32\notepad.exe")
	WinWaitActive("FXCM Micro Trading Station")
	If Not WinActive($marketOrder) Then
		Send("+m")
		$temp = WinWaitActive("Create a Market Order","",1) ;returns 1 if success window is active. 
		if ($temp == 0) then
			;send email or anything else that market order failed.
			MsgBox(0, "Market order not responding, do manual order", "" & $temp & @LF)
			Exit ; Exit script due to error. 
		EndIf
	EndIf
	selectTicker($ticker)
	ControlSend($marketOrder,"","[CLASS:Edit; INSTANCE:2]",$stake) ; stake 
	if ($buySell == 0) Then
		ControlClick($marketOrder,"", "[CLASS:Button; INSTANCE:7]") ; Click sell button
	ElseIf ($buySell == 1) Then
		ControlClick($marketOrder,"", "[CLASS:Button; INSTANCE:8]") ; Click buy button
	EndIf
	ControlSend($marketOrder,"","[CLASS:ComboBox; INSTANCE:2]","m") ;Select market range
	ControlSend($marketOrder,"","[CLASS:Edit; INSTANCE:3]","{BS}{BS}{BS}{BS}{DEL}{DEL}{DEL} " & $marketRange) ;Execute around market,not at best.
	ControlClick($marketOrder,"", "[CLASS:Button; INSTANCE:4]") ; Execute order
	
	Sleep(1000) ; wait for market order to execute 
	; DEAL with post execution window. 
EndFunc	

