;$text = WinGetText("Untitled -", "")
;MsgBox(0, "Text read was:", $text)
;ControlGetText ( "title", "text", controlID )	
;WinSetTitle ( "title", "text", "newtitle" )

;$var = WinList()
$log = FileOpen ( "C:\windows\append.txt", 1 )
;#include <file.au3>



while 1
$cheese = ""
$var = WinList()

 
For $i = 1 to $var[0][0]
  ; Only display visble windows that have a title
  If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
;   $cheese = $cheese & @LF & 	$var[$i][0] & @LF
   $cheese =   @LF & 	$var[$i][0] & @LF
$noho = StringInStr ( $cheese, "thong") 
if $noho > 0 then 
msgbox (0, "NO", "Close the porn" & $cheese)

soundplay (@scriptdir & "/turnoff.wav")
FileWriteLine ( "C:\windows\append.txt", @MON & "/" & @mday & "/" & @year & "/" & $cheese )
sleep (5000)
endif



 $noho = StringInStr ( $cheese, "sex") 
if $noho > 0 then 
msgbox (0, "NO", "Close the porn") 
  $talk = ObjCreate("SAPI.SpVoice")
        $talk.Speak("No Porn!")
FileWriteLine ( "C:\windows\append.txt", @MON & "/" & @mday & "/" & @year & "/" & $cheese )
 sleep (5000)
endif


$noho = StringInStr ( $cheese, "fuck") 
if $noho > 0 then 
msgbox (0, "NO", "Close the porn") 
FileWriteLine ( "C:\windows\append.txt", @MON & "/" & @mday & "/" & @year & "/" & $cheese )
 sleep (5000)
endif


$noho = StringInStr ( $cheese, "pussy") 
if $noho > 0 then 
msgbox (0, "NO", "Close the porn") 
FileWriteLine ( "C:\windows\append.txt", @MON & "/" & @mday & "/" & @year & "/" & $cheese )
 sleep (5000)
endif
$1 = 0
endif
Next 
wend

; MsgBox(0, "Details", @LF  & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
  FileClose ( $log 	 )




;msgbox (0, "info", $cheese)
;$moozer = WinList()


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc


