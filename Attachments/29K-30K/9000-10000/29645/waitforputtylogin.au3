	#include <file.au3>
	#include <array.au3>
	#include <Constants.au3>


    #cs   made for PuTTY.exe.. you might adapt it to other clients such as telnet(3270)

		  waiting for the ssh client to show its login prompt
	      send login
		  wait for the password promt
		  send password

		  independent of 'how long the server needs to come up with prompts' (though there is a timeout option)
		  it's done by forcing PuTTY to log and read the log file. You can't directly access the log with 'OPEN', so it's
		  copied with DOS means to the console and...
    #ce

	$user = ""
	$passw = ""

	$putty = "C:\programme\putty\putty.exe"                           ; change it PuTTY's somewhere else on your computer
	$ssh_server = "my ssh-server"                                     ; same here .. -> your ssh server
	$temp="C:\putty.log"
	dim $wexpr[2] = ["login as:","password:"]
	$timeout = 60 ;secs
	$found=0
    $known = ""
	$Message = ""

    if ping($ssh_server) then
		$user = InputBox("Who are you", "Enter your user name", "")
		$passw = InputBox("Security Check", "Enter your password.", "", "*")
		filedelete($temp)
		sleep(2000)
				Run($putty, "")
				winwaitactive ("PuTTY Configuration")
				send($ssh_server)										  ; send ip or dns name
				send("+{TAB}")                                            ;shift TAB , down, for Logging
				send("{DOWN}")
				send("{TAB}")
				send("l")
				send("{TAB}")
				send($temp,1)                                             ; force PuTTy log to $temp
				send("{ENTER}")

		$timeout = secs() + $timeout									 ; give the login prompt and subsequent password a definite time to appear

		while $found < 2 and secs() < $timeout
			$DOSCMD = Run(@ComSpec & " /c type " & $temp, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
																								   ; to my knowledge we can't access PuTTY window
																								   ; via StdoutRead ... hence we copy the putty log file
																								   ; to DOS console
			While 1
				Sleep(100)
				$read = StdoutRead($DOSCMD)
				if @error then exitloop
				if $read <> $known Then                      ;don't make Message too large, just keep changes
					$Message &= $read
					$known = $read
				endif
				if stringinstr($Message,$wexpr[$found]) then ;wait for the first expression in the array and select the next array entry
					;$Message = $wexpr[$found]				 ;this line is not neccessary but if you want to see something in the tooltip
					$found = $found + 1 					 ;wait for the next expression stored in the array to appear
					switch $found
						case 1
							send($user & "{ENTER}")
						case 2
							send($passw,1)
							send("{ENTER}")
						case Else
							 ;nop
						endswitch
				endif
				;tooltip($Message)                          ; if you like .. have a look
			WEnd
		wend
		if not($found) then
			msgbox(0, "","PuTTY timed out")
		Else
			MsgBox(0,"", "got logged in")
		endif
	Else
		MsgBox(0,"", $ssh_server & "....unreachable")
	EndIf



;------------------------------------------------------------------------------------------
Func secs()
	return(@HOUR * 3600 + @MIN *60 + @SEC)
endfunc
