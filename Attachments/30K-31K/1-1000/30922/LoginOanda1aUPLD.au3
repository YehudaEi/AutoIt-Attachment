#include <Misc.au3>
;$main_window = "OANDA FXTrade - XXXXX - Primary (XXXXX)"
$username = "xxxxxxxx"
$password = "xxxxxxxxxx"
Global $OandaLots = 0
Global $warning_win = "Warning"
Opt("WinTitleMatchMode", 2) ; Partial title match mode anywhere inside the title of the window



Login_to_oanda()
Exit
;Test_if_at_correct_Box()

;Close_Oanda_windows()

Func Close_Oanda_windows()
	; If logged out , kill oanda window and login from firefox again.
	WinActivate($main_window, "")
	if WinWaitActive($main_window,"",5) Then
		;all fine
	Else
		Winkill("OANDA fxGame")
		Login_to_oanda() ; Login automatically into OANDA if server suspended connection.
	EndIf
	sleep(500)
EndFunc


Func Login_to_oanda()
	WinMinimizeAll()
	sleep(500)
	WinActivate($main_window)
	if WinWaitActive($main_window,"",3) Then
		ConsoleWrite("Oanda is logged in - all fine")
		;oanda is logged in 
	Else
		;First get handle as it kills firefox totally.
		;********* USE WinClose
		;WinClose("OANDA FXGame", "")
		;WinClose("Oanda fxgame", "")
		;WinClose("Oanda fxtrade", "")
		;WinClose("Oanda fxtrade", "")
		Winkill("OANDA fxGame") ; Kill all windows that are logged out.
		Winkill("OANDA FXGame") ; Kill all windows that are logged out.
;		Winkill("OANDA FXGame") ; Kill all windows that are logged out.
		Winkill("OANDA fxTrade")
		;Winkill("OANDA FXTrade")
;		Winkill("OANDA FXTrade")
		Oanda_login_subfunction()
	EndIf
EndFunc


Func Oanda_login_subfunction()
	;********* First close any OANDA windows *************
	Sleep(3000)
;	$handle = FirefoxWinHandle()
;	WinActivate($handle,"")
; ********* CHECK HERE WHETHER firefox is active *****
	WinActivate("Mozilla Firefox")
	if WinWaitActive("Mozilla Firefox","",5) Then	
		;pass 		
	Else
		ConsoleWrite("Executing FIREFOX with run command")
		Run("C:\Program Files\Mozilla Firefox\firefox.exe")
		WinWaitActive("Mozilla Firefox","",30)
		Sleep(10000)
	EndIf
;	if WinWaitActive($handle,"",5) Then	
	if WinWaitActive("Mozilla Firefox","",5) Then	
		;Send("(F10)")
		;Send("^T")
	;	$win_pos = WinGetPos($handle)
		$win_pos = WinGetPos("Mozilla Firefox")
		MouseClick("left", $win_pos[0]+500, $win_pos[1]+72,1,20) ; x, y 
		Send("^a")
		Send("{Del}")
		Sleep(2000)
;		Send("{BS},{BS},{BS},{BS}, {BS},{BS},{BS},{BS} , {BS},{BS},{BS},{BS}") ; clear window
;		Send("{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL},{DEL}") ; clear window
		Send("https://fxtrade.oanda.com/your_account/login")
		Sleep(2000)
		Send("{Enter}")
		Sleep(55000)  ;*********** MUST WAIT LONG TIME FOR FXTRADE TO LOAD***********
		Send("{TAB 23}")
		Sleep(300)
		Send($username)		
		Sleep(300)
		Send("{TAB}")
		Sleep(300)
		Send($password)		
		Sleep(300)
		Send("{TAB}")
		Sleep(300)
		Send("fxg")		  ; fxgame account 
		Sleep(300)
		Send("{TAB}")
		Sleep(300)
		Send("{TAB}")
		Sleep(300)
		Send("{Enter}")
		; Wait for fxgame or fxtrade to startup then minimize. 
	Else
		ConsoleWrite("error firefox window")
		Exit
	EndIf
EndFunc


