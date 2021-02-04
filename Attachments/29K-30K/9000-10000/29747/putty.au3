#include-once

#include <file.au3>
#include <Process.au3>
#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>
#include <ComboConstants.au3>
#include <Array.au3>
#Include <String.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;                                P U T T Y . A U 3                   Version 1.2a     2010 /02 /22
;_________________________________________________________________________________________________________________
; global declarations

global $putty = "c:\programme\putty\putty.exe"
global $brand = "putty.exe"
global $putties[150]   ; keeps handles to all putty sessions running ( last oppened is the last)

;_________________________________________________________________________________________________________________
;function callputty($dnsname_or_IP,$username,$password,$logfilename,$timeout_in_secs)
;opens putty and returns an open putty console window and/or
;return  0  ok, putty logged in with console window active
;		 1  unreachable, no ssh server, no login prompt, timeout
;        2  user password problem


;_________________________________________________________________________________________________________________
;function seekputty()
;       locates putty.exe on C: and changes $putty accordingly

;_________________________________________________________________________________________________________________
;function isputty($handle)
;       retrurns 1 if the process belonging to an open window is putty.exe , else 0

;_________________________________________________________________________________________________________________
;function secs() returns the secs right now counted from 0:00 last night as a plain number

;_________________________________________________________________________________________________________________
;function nowlog() returns a timestamp with appendix ".log"

;_________________________________________________________________________________________________________________
;function IsVisible($handle)
;       returns 1 if a window is visible , else 0

;-----------------------------------------------------------------------------------
func callputty($ssh_server,$user,$passw,$temp_logfile,$timeout)

	local $Message,$found,$known,$x,$y,$i,$var,$wexpr

	dim $wexpr[3] = ["login as:","assword:","ccess denied"]          ;cisco likes upper case, others lower
	
	;local $yes = "j"  ; windows yes (yes,oi,si,ja)  ... see code, just an alternative for accepting RSA keys
    
	if ping($ssh_server) then

		;get all window handles concerned with putty that might be open already
		;and destroy all putty sessions "fatal error" or "inactive" (timed out)
		$x=0
		$y=0
		$putties[0] = 0
		$var = WinList()
		For $i = 1 to $var[0][0]
			If isputty($var[$i][1]) AND IsVisible($var[$i][1]) then
				if stringinstr($var[$i][0],"atal") or stringinstr($var[$i][0],"inactive") Then
					send("{ENTER}")
					winkill($var[$i][1])
				Else
					$x=$x+1
					$putties[$x] = 	$var[$i][1]
				endif
			endif
		Next
		$putties[0] = $x  ; array putties has all handles to every window that has to do with putty.exe
		$remembered_putties = $x  ;keep an eye of the number of putty windows
		; delete temp file and give dos a bit time to destroy it
		filedelete($temp_logfile)
		sleep(2000)
				Run($putty, "")
				winwaitactive ("PuTTY Configuration")
				send($ssh_server)										  ; send ip or dns name
				send("+{TAB}")                                            ; shift TAB , down, for Logging
				send("{DOWN}")
				send("{TAB}")
				send("l")
				send("{TAB}")
				send($temp_logfile,1)                                             ; force PuTTy log to $temp_logfile
				send("{ENTER}")
				winwaitnotactive ("PuTTY Configuration")


		$timeout = secs() + $timeout									 ; give the login prompt and subsequent password a definite time to appear
		;by now putty has left it's configuration window and started a terminal session


		while $found < 3 and secs() < $timeout
			$DOSCMD = Run(@ComSpec & " /c type " & $temp_logfile, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
																								   ; to my knowledge we can't access PuTTY window
																								   ; via StdoutRead ... hence we copy the putty log file
																								   ; to DOS console

			While 1
				; there could be additional windows, putty might react not earlier as within this loop
				;               -> security alert, you have to accept an RSA key (succes)
				;               -> anything else, demanding named additional window and putty to be killed (no success)
				$var = WinList()
				for $i = 1 to $var[0][0]
					$drin = 0
					If isputty($var[$i][1]) AND IsVisible($var[$i][1]) then
							for $x = 1 to $putties[0]
								if $var[$i][1] = $putties[$x] Then $drin = 1
							Next
							if not($drin) then
								$putties[0] = $putties[0] +1
								$putties[$putties[0]] = $var[$i][1]
							endif
					endif
				next ; $i
				;there will be one or two new putty windows but you can't rely on the order. sometimes it's
				; order in array   $putties[$putties[0]-1] adresses the warning window we might get rid of
				;                  $putties[$putties[0]]  addreses the terminal window... this we want to keep
				;or they appear in just in opposite order  but : there will be one or two.. never more
				if $putties[0] - $remembered_putties > 1 Then
					if stringinstr(wingettitle($putties[$putties[0]-1])	& wingettitle($putties[$putties[0]]), "Security") then
						;we have to accept a RSA key or a fatal error appeared
						;it is not sufficient to address the PuTTY Security window by refering to its window title
						; the more elegant way ist to use the window handle
						if stringinstr(wingettitle($putties[$putties[0]-1]), "Security") then ; it's the second last window
							winactivate($putties[$putties[0]-1])
							winwaitactive($putties[$putties[0]-1])
							$putties[$putties[0]-1] = $putties[$putties[0]] ;shift within array
						Else
							winactivate($putties[$putties[0]])
							winwaitactive($putties[$putties[0]])
						endif
						controlclick("[active]","",6,"left")  ;this seems reliable enough click yes, we accept the rsa key
						;send $yes                            ;and this is an alternative but depends on our nationality
						$putties[0] = $putties[0] -1          ;and make the number of putty windows one less
						sleep(1000)  ;RSA Key accepted , give putty time to settle
					else
						;fatal things, kill the 2 new windows, you had "no success"
						winkill($putties[$putties[0]-1])
						winkill($putties[$putties[0]])
						$timeout = 0    ;end it
					endif
				endif
				; situation : we have (nobody knows when) one putty console window open and wait for the login prompt to appear
				; if there was an RSA key to accept,  we did and closed the security window
				; if there was any fatal error, we killed all putty windows we caused and it's time to end it
				;     we prepared for the latter by setting timeout to zero
					;-----
				;at the same time there could be but one normal putty window , lets see itf this is the case and wait for the login/pw prompt
				; and... while looping.... still be prepared for putty to come up with another window
				$read = StdoutRead($DOSCMD)
				if @error then exitloop
				if $read <> $known Then                      ;don't make Message too large, just keep changes
					$Message &= $read
					$known = $read
				endif
				if stringinstr($Message,$wexpr[2]) then      ;all the time have an eye on access dienied
					return(2)
				endif

				if stringinstr($Message,$wexpr[$found]) then ;wait for the first expression in the array and select the next array entry
					$found = $found + 1 					 ;then wait for the next expression stored in the array to appear
					switch $found
						case 1
							send($user,1)
							send("{ENTER}")
							;ControlSend(wingettext($putties[$putties[0]], ""),"",$putties[$putties[0]], $user,1)
							;ControlSend(wingettext($putties[$putties[0]], ""),"",$putties[$putties[0]], "{ENTER}")
						case 2
							send($passw,1)
							send("{ENTER}")
							;ControlSend(wingettext($putties[$putties[0]], ""),"",$putties[$putties[0]], $passw,1)
							;ControlSend(wingettext($putties[$putties[0]], ""),"",$putties[$putties[0]], "{ENTER}")
							$timeout = secs() +3             ;wait a bit  seconds for 'access denied'
						case Else
							 ;nop
						endswitch
				endif
				;tooltip($Message)                          ; if you like .. have a look
			WEnd
		wend
		if not($found) then
			return(1)                             ;timed out
		Else
			return(0)                             ;logged in, putty window open
		endif
Else
		return(1)                                 ;no access
	EndIf

endfunc ;callputty


;------------------------------------------------------------------------------------------

Func isputty($handle)
	If StringInStr(_ProcessGetName(WinGetProcess($handle)), "putty.exe") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

func seekputty()

	local $pf
	dim $pf[50]  ;don't expect there to be more putty.exe on your drive c:
	if not(fileexists($putty)) then
		tooltip(@LF& "           Suche nach putty.exe          " & @LF & _
					"           einen Moment bitte            " & @LF)
		Runwait(@ComSpec & " /c dir C:\" & $brand & " /s /b >C:\putty.txt","",@SW_HIDE )
		if filegetsize("C:\putty.txt") < 5 Then
			msgbox(0,"",$brand &" wird benötigt und wurde nicht gefunden")
			Exit
		endif
		_filereadtoarray("C:\putty.txt",$pf)            ;accept the first  $brand  we found
		$putty = $pf[1]
		tooltip("")
	endif
endfunc

Func secs()
	return(@HOUR * 3600 + @MIN *60 + @SEC)
endfunc


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then
    Return 1
  Else
    Return 0
  EndIf
EndFunc

func nowlog()
return (@Year & @Mon & @mday & "_" & @Hour &"Uhr"&  @min  & @Sec & ".log")
EndFunc