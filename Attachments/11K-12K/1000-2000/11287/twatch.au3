$wait = 5000
RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run', 'Twatch', 'REG_SZ', 'C:\program files\twatch\explorer2.exe')
;	$running = ProcessExists ( "explorer2.exe" )
;if $running = 0 then run (@scriptdir & "C:\Program Files\twatch\explorer2.exe")
$log = FileOpen("C:\windows\append.txt", 1)
;$noho = StringSplit("thong,sex,fuck,pussy,", ",") ; you can add as many words as you want
$noho = StringSplit("thong,fuck,pussy,nude,penis,dildo,vibrator,G string,hardcore porn,jacking off,masturbation tips,jerking off,blowjob,blow job,fisting,", ",") ; you can add as many words as you 
#NoTrayIcon 
While 1
    $cheese = ""
$var = WinList()
$results = 0
    For $i = 1 To $var[0][0]
		      
 If $var[$i][0] <> "" then
	if IsVisible($var[$i][1]) Then
	  ;msgbox (0, "", $var[$i][0])
For $x = 1 To $noho[0]
			  ;msgbox (0, $var[$i][0], $noho[$x])
			 ; msgbox (0, $i, $var[23][0])
				$results = StringInStr($var[$i][0], $noho[$x]) 
				;$results = StringInStr("Jac0king off", $noho[$x]) 
				;$results = StringInStr($noho[$x], $var[$i][0]) 
				
				
                If $results  > 0 and $noho[$x] <> "" Then
			        $cheese =  $var[$i][0] & @LF & @LF
                    MsgBox(16, "NO", "Close the porn: " & $cheese & "Your actions are being recorded, furthermore God is watching you. He knows what you are looking at!")
			        $cheese = @LF & $var[$i][0] & @LF
					SoundPlay(@ScriptDir & "\turnoff.wav")
					$closer = msgbox (32 & 4, "Close the porn!!!", "                                    ")
					if $closer = 6 then winclose( $var[$i][0])
					WinFlash ( $cheese,"", 4, 500) 
                    FileWriteLine("C:\windows\append.txt", @MON & "/" & @MDAY & "/" & @YEAR & "/" & $cheese)
                          Sleep($wait)
					exitloop
					exitloop
					EndIf
					  Next
 ;next
          
	  EndIf 
	  endif
	  $results = 0
      ;  Sleep($wait)
  
    ;sleep (100)
	Next
   ; Sleep($wait)
WEnd

FileClose($log)


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc