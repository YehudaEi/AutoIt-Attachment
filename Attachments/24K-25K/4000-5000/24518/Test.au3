$applicationName = "Testing of input"

$sInputBoxAnswer1=0
 
 
 $sInputBoxAnswer1 = InputBox("TEST INPUT "&$applicationName,"" & @CRLF & @CRLF & "     " & @CRLF & "     " & @CRLF & @CRLF & "    " & @CRLF & @CRLF & @CRLF & @CRLF,"","","350","-1","465","-1")
 
 
Select
	Case @Error = 0 ;OK
	Case @Error = 1 ;Cansel
				
		MsgBox(64," Cansel button was pressed "&$applicationName,"    " & @CRLF & " Cansel button is pressed                " & @CRLF & @CRLF &  "    " & @CRLF & "" & @CRLF & @CRLF &"                           " & @CRLF)
		Exit
	
EndSelect


MsgBox(64," OK button was pressed "&$applicationName,"    " & @CRLF & "   OK button is pressed" & @CRLF & @CRLF &  "         " & @CRLF & "" & @CRLF & @CRLF &"                         " & @CRLF)
		Exit
		
		