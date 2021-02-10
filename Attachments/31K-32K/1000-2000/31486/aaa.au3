call("main")
func main()
$text = inputbox("Chatting With Carrie", "Carrie:")
if @error = 1 Then
	Exit
Else
	
if StringInStr ($text, "?") then
		
$text1 = "I will tell you after you tell me. "
$text0 = $text1 & $text
sleep(3500)
MsgBox(4096, "Carrie:", ($text0))
call("main")
		

else

	
	$text1 = "I'll say "
$text2 = " also."
$text0 = $text1 & $text & $text2
sleep(3500)
MsgBox(4096, "Carrie:", ($text0))
call("main")
EndIf
endif
endfunc