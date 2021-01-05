; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Alex Cheng
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

;RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\Allow", "securityresponse.symantec.com", "REG_BINARY", "")
$ObjIE = ObjCreate ("InternetExplorer.Application")
With $ObjIE
   .Visible = True
   .Navigate ("                                                                        ")
   While .Busy
      Sleep(50)
   WEnd
EndWith
$doc = $objIE.document
   $links = $doc.links
   For $link in $links
      $linkText = $link.outerText
      If StringInStr($linkText, "-i32.exe") Then
            $ObjIE.quit()
			InetGet("http://definitions.symantec.com/defs/"&$linkText,@tempdir&"\"&$linkText, 0)
			runwait (@tempdir&"\"&$linkText&" /q")
			ExitLoop
      EndIf
   Next
;  RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\Allow", "securityresponse.symantec.com")
Exit


