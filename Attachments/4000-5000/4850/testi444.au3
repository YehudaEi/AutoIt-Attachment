;functiontest
#include <encryption.au3>

$text = "this is my really fat and big and huge testing text, so huge, wow"
$atty = atbash ($text, 0)
FileWrite ("tester25.txt", $text & "-" & $atty & @CRLF)
$reatty = atbash ($atty, 0)
FileWrite ("tester25.txt", $atty & "-" & $reatty & @CRLF)
$atty = atbash ($text, 1)
FileWrite ("tester25.txt", $text & "-" & $atty & @CRLF)
$reatty = atbash ($atty, 1)
FileWrite ("tester25.txt", $atty & "-" & $reatty & @CRLF)
$viggy = vigniere ($text, 0)
FileWrite ("tester25.txt", $text & "-" & $viggy & @CRLF)
$reviggy = vigniere ($viggy, 1)
FileWrite ("tester25.txt", $viggy & "-" & $reviggy & @CRLF)
$viggy = vigniere ($text, 0, "hallo")
FileWrite ("tester25.txt", $text & "-" & $viggy & @CRLF)
$reviggy = vigniere ($viggy, 1, "hallo")
FileWrite ("tester25.txt", $viggy & "-" & $reviggy & @CRLF)
$viggy = vigniere ($text, 0, "hallo", 1)
FileWrite ("tester25.txt", $text & "-" & $viggy & @CRLF)
$reviggy = vigniere ($viggy, 1, "hallo", 1)
FileWrite ("tester25.txt", $viggy & "-" & $reviggy & @CRLF)
$rot13 = rot($text, 0)
FileWrite ("tester25.txt", $text & "-" & $rot13 & @CRLF)
$rerot13 = rot ($rot13, 0)
FileWrite ("tester25.txt", $rot13 & "-" & $rerot13 & @CRLF)
$rot128 = rot($text, 1)
FileWrite ("tester25.txt", $text & "-" & $rot128 & @CRLF)
$rerot128 = rot ($rot128, 1)
FileWrite ("tester25.txt", $rot128 & "-" & $rerot128 & @CRLF)
$caesa = caesar($text, 0)
FileWrite ("tester25.txt", $text & "-" & $caesa & @CRLF)
$recaesa = caesar($caesa, 1)
FileWrite ("tester25.txt", $caesa & "-" & $recaesa & @CRLF)
