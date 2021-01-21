;Research Assistant v1.0.0  11-12-04
; Scott's first (with much help) AutoIt v3 script.

; Run Notepad
Run("notepad.exe")
; Wait for Notepad become active.
WinWaitActive("Untitled - ")
Send("Here are your results:{Enter 2}")
; Some Notepad replacements add an asterisk to the title on edit, this will whack it.
WinSetTitle("", "", "Search Results")

; Start the loop
Do

; Ask for a search string.
$word = InputBox("Search Assistant", "Enter search string - Be very specific.", "" )
   If @Error = 1 Then 
	MsgBox(0, "Search Assistant", "OK... C-ya!")
	Exit
   EndIf

; Launch default browser (Have yet to find a better way!).
Send("#r")
Sleep(500)
Send("http://www.google.com{enter}")
Sleep(1000)
; In case the browser was already open, bring it in focus.
WinActivate("Google - ")
WinWaitActive("Google - ")
; Allow some time for the page to load.
Sleep(1000)
; Enter search string on Google.
Send($word)
Sleep(1000)
; Not sure how to go to the links I need so just run 'I'm Feeling Lucky'.
Send("{Tab 2}{Enter}")
; Wait for page to load (this could be a problem)
Sleep(6000)
; Select all and copy to clipboard.
Send("^a")
Sleep(1000)
Send("^c")
	 
; Parse the clipboard.
$lines=StringSplit(Clipget(),".")
$found=0
for $i=1 to $lines[0]
   If StringInStr($lines[$i],$word)>0 Then
   
; Send the answer to Notepad...
WinActivate("Search Results", "")

	Send($lines[$i]&".{Enter 2}")
       $found=1
   EndIf
Next

; Change window title to drop the asterisk so we can find it next time.
WinSetTitle("", "", "Search Results")

; ...unless we didn't find anything.   
   If $found=0 Then MsgBox(1,"Error","No Sentance with "&$word&" Found")

;Try again? If no then end Do-Until loop.
$answer = MsgBox(4, "Search Assistant", "Search again?")
Until $answer = 7   