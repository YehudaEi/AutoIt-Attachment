;http://www.autoitscript.com/forum/index.php?showtopic=116101
#include <Oanda1b.au3>
;#include <Oanda1bREAL.au3>

Global $gloPAUSE = False
HotKeySet("`", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("^1", "EuroBuy_Oanda_One_micrlot")
HotKeySet("^2", "EurSell_oanda")
HotKeySet("^3", "Trigger3")

;@HotKeyPressed macro to check. 

While 1
    sleep(100)
WEnd

;EnterLots_for_Ticker($main_window, $OandaLots, $buyOrSell, $ticker)  ;2  

Func EuroBuy_Oanda_One_micrlot()
    ;MsgBox("ONE", "test", "well it got to 1")
	;PRE: oANDA in one click order execute mode
	$OandaLots = 1
	Local $buyOrSell = True ; Buy is True, short is False
	Local $ticker = 'eurusd'
;	Local $ticker = 'usdjpy'
	EnterLots_for_Ticker($main_window, $OandaLots, $buyOrSell, $ticker)  ;2  
	Sleep(10)
EndFunc

Func EurSell_oanda()
	;PRE: oANDA in one click order execute mode
	$OandaLots = 1
	Local $buyOrSell = False ; Buy is True, short is False
	Local $ticker = 'eurusd'
;	Local $ticker = 'usdjpy'
	EnterLots_for_Ticker($main_window, $OandaLots, $buyOrSell, $ticker)  ;2  
    sleep(10)
EndFunc

Func TogglePause()
    $gloPAUSE = NOT $gloPAUSE
    if $gloPAUSE Then
        ToolTip('Script Paused',0,0)
    Sleep(1000)
    ToolTip("")
    Else
    ToolTip('Script Enabled',0,0)
    sleep(1000)
    ToolTip("")
    EndIf
EndFunc

Func Terminate()
    Exit 0
EndFunc
 