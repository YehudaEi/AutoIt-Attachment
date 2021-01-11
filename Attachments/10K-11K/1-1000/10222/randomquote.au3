$1 = Random(1, 10)
$2 = Random(1, 28)
$3 = random(1, 10)
$ii = StringSplit("I have to /I Must /I Gotta /I Should /Sorry but i gotta /I ought to /i was about to /can you help me /i still need to /first let me", "/")
$mid = StringSplit("water /do /beat /make /chase /run /choose /walk /type/ move /grow /try /eat /test /hear /paint /jump over /check on /catch /throw /wax /fix /avoid /smack /slam /find /kiss /ignite /insult ", "/")
$end = StringSplit("My dog/My cake/My flowsers/My bed/my pie/my cat/my gum/my lizard/My keyboard/My house", "/")

MsgBox(0, "", $ii[$1] & $mid[$2] & $end[$3])
