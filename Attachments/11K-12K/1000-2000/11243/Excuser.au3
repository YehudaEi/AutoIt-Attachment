Func excuseme()
$1 = Random(1, 14)
$2 = Random(1, 37)
$3 = random(1, 23)
$ii = StringSplit("I have to /I must /I gotta /I should /Sorry but I gotta /I ought to /I was just about to /Can you help me /I still need to /First let me /I can't unless I /Oh! I forgot to /I'd rather /Would you mind if I were to /", "/")
$mid = StringSplit("water /do /beat /make /chase /run /choose /walk /type /move /grow /try /eat /test /hear /paint /jump over /propose to /invest in /talk to /trade cards with /smash /irritate /obfuscate /finish off /check on /highlight /bake /catch /throw /wax /fix /avoid /smack /slam /find /kiss /ignite /insult ", "/")
$end = StringSplit("my dog/my sister/my brother/myself/my uncle/my cake/my flowsers/my bed/my pie/my cat/my gum/my lizard/my keyboard/my house/a shark/a log/a nuclear missile/the front door/George W. Bush/your hair/your head/your cap/your shoe", "/")

MsgBox(0, "", $ii[$1] & $mid[$2] & $end[$3])
EndFunc

While 1
	excuseme()
	If MsgBox(4, "", "Want more?") <> 6 Then
		Exit
	Else
		ContinueLoop
	EndIf
WEnd