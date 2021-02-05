#include <WinAPI.au3>
#include "putty.au3"

;example for concurrent read of an putty log file. This programm calls putty, makes it logging and at the same time
;reads the log and clears it from escape sequences and makes it readable in another file.

$ssh_server = "10.20.0.5"                                   ;your ssh server (name or Ip address)
$user =       "schoorja"								    ;your USER	
$passw =      ""		   									;his password
$temp_logfile="C:\x.txt"									;putty logfile includes all chracters includeig escape sequences
$clean =      "c:\clean.txt"								;readable putty log file freed from escape sequences
$timeout =    60

$passw= InputBox("Bitte Passwort eingeben", "Bitte Passwort eingeben", "", "*")


$tBuffer = DllStructCreate("char[2000]")									; seek prompt string 
local $nBytes
filedelete($temp_logfile)
callputty($ssh_server,$user,$passw,$temp_logfile,$timeout)
send("{ENTER}")
$hndl= _WinAPI_CreateFile($temp_logfile, 2, 2, 6)                           ; open for concurrent read,  only read(2), Share for read and write(6)
$size = _WinAPI_GetFileSizeEx($hndl)							    	    ; return filesize
_WinAPI_SetFilePointer($hndl, - 50,2)		                                ; set filepointer to the end of file							   
_WinAPI_ReadFile($hndl,DllStructGetPtr($tBuffer),50,$nBytes)
$prompt = stringleft(DllStructGetData($tBuffer, 1),50)                      ; prompt with preceeding lines rests

;end of line before is either =0x0a or ESC[\d{1,2};1H what we reduce to ...;1H...      
;msgbox(0,"prompt",$prompt)
for $n = 50 to 1 step -1
	if stringmid($prompt,$n,1)= chr(10) then
		$prompt = stringmid($prompt,$n+1)
        ExitLoop
    EndIf
	if stringleft(Stringmid($prompt,$n),3) = ";1H" then
		$prompt = stringmid($prompt,$n+3)
		ExitLoop
	EndIf
next	
winsettitle("[active]","",$prompt)                                           ; prompt like "router-1#"	or "linux-server>"
$size = 0
_WinAPI_SetFilePointer($hndl, 0)
$read = ""								   ;read buffer	containes a read portion
$keep = ""                                 ;the readbuffer will be read not entirely till the end for escape sequenzes can be long
                                           ;before reading next, the rest of the old buffer is kept here 
$fhndl= fileopen($clean,2)                 ;readable logfile 
$shut_status = 2                           ;2 putty window is still open
										   ;1 putty window is shut read the rest
										   ;0 leave, goodbye
										   
$linefeedposition =0                       ;after haveing written a buffer we can't look back if the last char was linefeed
                                           ;hence this varable. It keeps the last position of linefeed

while $shut_status
	$newsize = _WinAPI_GetFileSizeEx($hndl)							    			;return filesize
	$toread = $newsize - $size
	if $toread > ($shut_status-1) * 50 Then                                       	;we read at least the prompt length at once
																					;or, heading $shut_status, the last few. 
		if $toread >2000 then
			$toread = 2000
			if $shut_status = 1 then $shut_status = 2  								;still at least one reread neccessary
		endif		
		_WinAPI_ReadFile($hndl,DllStructGetPtr($tBuffer),$toread,$nBytes)  	
		$size = $size + $toread
		_WinAPI_SetFilePointer($hndl,$size)		                            		;set filepointer +			   
		$read = $keep & stringleft(DllStructGetData($tBuffer, 1),$toread)
        $x=1
		$toread= stringlen($read)
		while $x < $toread - ($shut_status-1)*10
						
			switch 	stringmid($read,$x,1)                                                            ;
			case chr(13)
					if stringmid($read,$x+1,1) = Chr(10) then                        ;a CR LF ?
						;nop                                          
					Else
						$read = stringleft($read,$x) & @LF & stringmid($read,$x+1)   ;insert a LF
						$toread = $toread +1
						$x = $x +2
					endif 
					$x = $x+2  
					$linefeedposition = $x -1	
			;				
			case chr(10)	
					if stringmid($read,$x-1,1) = Chr(13) then                        ;CR LF
						$x = $x +1                         																
					Else
						$read = stringleft($read,$x-1) & @CR & stringmid($read,$x)   ;@LF alone
						$toread = $toread +1
						$x = $x + 2  
					endif 
					$linefeedposition = $x -1
					
			;		
			case chr(27)															;Escape 
					$dealt_with = 0				
					while $dealt_with = 0  and stringRegExp(Stringmid($read,$x,8),("\e\[\d{1,2};1H\n"))      ;escape sequences followed by LF
					   	for $y = $x + 4 to $toread - ($shut_status-1)*10
							if stringmid($read,$y,1) = @LF Then
								$read = stringleft($read,$x -1) & @CR & stringmid($read,$y)	
								$toread = stringlen($read) 							;correct endpointer
								$x = $x + 2
								$linefeedposition = $x -1
								$dealt_with = 1
								exitloop
							endif
						next
						if not $dealt_with then                                      ;read anew, not enough chars left
							$toread = $x
							$dealt_with = 3
						endif
					wend
					;
					while $dealt_with = 0 and stringRegExp(stringmid($read,$x,7),("\e\[\d{1,2};1H")) ;escape sequences followed by at least one space
						;find the next esc sequence and see if it contains but spaces					
						for $y = $x + 3 to $x + 9
							if stringmid($read,$y,1) = "H" then ExitLoop  			;find sequence end
						next
						$linbeg = $y +1	                                  			;remember line-begin
						for $y = $linbeg to $toread - ($shut_status-1)*10
							switch stringmid($read,$y,1)
							case chr(0x1b)                        					;begin of the next sequence, we found but spaces
								$read = stringleft($read,$x -1) & stringmid($read,$y)	;forget the sequence and following spaces
								$toread = stringlen($read)       					 ;correct endpointer
								$dealt_with = 1
								exitloop	
							case " " 												;space ...continue reading
							    ;nop
							case else  ;theres something usefull within the line... if theres no @lf in the stream before	(you can't look back!!)							
								if $x-$linefeedposition > 1  then  				   ; insert one
									$read = stringleft($read,$x-1) & @CRLF & stringmid($read,$linbeg)	
									$x = $x + 2
									$linefeedposition = $x -1
								Else
									$read = stringleft($read,$x-1) & stringmid($read,$linbeg)	;just remove sequence
								endif
								$toread = stringlen($read) ;correct endpointer
								$dealt_with = 1
								exitloop
							EndSwitch	
						next
						if not $dealt_with then                                        ;read anew, not enough chars left
							$toread = $x
							$dealt_with = 4
						endif	
					wend						
					;					                                                              			;deal with \e\[\d{1,2};\d{1,2}H
					while $dealt_with = 0  and stringRegExp(Stringmid($read,$x,8),("\e\[\d{1,2};\d{1,2}H"))     ;escape sequences for umlaut marks
					    for $y = $x + 3 to $toread - ($shut_status-1)*10
							if stringmid($read,$y,1) = "H"  Then
								$read = stringleft($read,$x -1)  & stringmid($read,$y +1 )	
								$toread = stringlen($read) 								;correct endpointer
								$dealt_with = 1
								exitloop
							endif
						next
						if not $dealt_with then                                          ;read anew, not enough chars left
							$toread = $x
							$dealt_with = 3
						endif
					wend
					;
					while not $dealt_with  ;some escape sequence we didn't treat , read till the next appears
						for $y = $x + 1 to $toread - ($shut_status-1)*10
							if stringmid($read,$y,1) = chr(27) Then
								$read = stringleft($read,$x -1) & stringmid($read,$y)	
								$toread = stringlen($read) ;correct endpointer
								$dealt_with = 1
								exitloop
							endif
						next
						if not $dealt_with then                                          ;read anew, not enough chars left
							$toread = $x
							$dealt_with = 5
						endif	
					wend	
				case else	
					$x= $x+1 ; just overread an unspecular char
				EndSwitch
		wend		
		$keep = stringmid($read,$x)														;keep the rest and read anew   

;__________________________________________ this is a fine place to deal with a few hundert last bytes of the clean log _________________________________________________________________________
;                                        by taking the content from the variable $read and collect and  scan it to your needs     
filewrite($fhndl,stringleft($read,$x-1))
		$linefeedposition = -($x-1-$linefeedposition)	
	endif
	if not winexists($putties[$putties[0]]) then $shut_status = $shut_status - 1 		;message for reading the rest
WEnd
_WinAPI_CloseHandle($hndl)   ;shut concurrent read 
fileclose($fhndl)            ;shut true log file
;_________________________________________________________________________________________;thats it________________________________________
