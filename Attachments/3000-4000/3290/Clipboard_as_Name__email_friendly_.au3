#NoTrayIcon
; Clipboard as Name (email-friendly).au3

; Compile this and copy it to the SendTo folder. When run with one 
; or more filenames as command-line arguments, it will put them on the
; clipboard in email-friendly form, with chevrons around each name
; so that they appear in email text as clickable links.

; Ben Shepherd (bjs54@dl.ac.uk), 18 July 2005

$clipstring = ""

; only one arg supplied? then don't add carriage return
If $CmdLine[0] = 1 Then 
	$cr = "" 
Else 
	$cr = @CRLF
EndIf

For $i = 1 To $CmdLine[0]
	$clipstring = $clipstring & "<" & $CmdLine[$i] & ">" & $cr
Next

ClipPut ($clipstring)