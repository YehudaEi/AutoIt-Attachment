;There is code prior to this point that defines every variable that is used in the program.  They are irrelevant in the example.  It leads into this by calling the start of this script with label "TradeReady()"

Func TradeReady()
;Look for a trade request
$checksum = PixelChecksum($talx, $taly, $tarx, $tary)
  While $checksum = PixelChecksum($talx, $taly, $tarx, $tary)
    Sleep(100)
Wend

;SPECIAL NOTE: From here until the next special note is when the second check has to occur

;Accept Trade and enter
MouseClick("left", $tax, $tay, 2, 1)
Sleep(5000)

~code
~code
~code

;Perform trade
Mouseclick("left", $ptx, $pty, 2, 1)
Sleep(8000)
EndFunc ;==>TradeReady()

;SPECIAL NOTE: Once code reaches this point, the program then goes back to the start
TradeReady()



########Code that needs to be running while most of TradeReady is...########
$var = PixelGetColor($wpcx, $wpcy)
  If $var = $wpcc Then
    MouseClick("left", $wtx, $wty, 2, 1)
    TradeReady()
  EndIf



############################################################
#This code needs to run the whole program...               #
############################################################
#$pm = PixelChecksum($pmclx, $pmcly, $pmcrx, $pmcry)       #
#  While $pm =PixelChecksum($pmclx, $pmcly, $pmcrx, $pmcry)#
#    Sleep(100)						   #
#  WEnd							   #
#MouseClick("left", $pmtx, $pmty, 2, 1)			   #
#Send($pmmessage)					   #
#Send("{ENTER}")					   #
#MouseClick("left", $pmcx, $pmcy, 2, 1)			   #
#TradeReady()						   #
############################################################