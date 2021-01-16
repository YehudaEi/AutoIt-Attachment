#NoTrayIcon
#include <string.au3>
#include <Date.au3>
#include <HTTP.au3>;download this here----> http://www.autoitscript.com/forum/index.php?showtopic=29631&st=15&p=319354&#entry319354

$UserName = @UserName
$ComputerName = @ComputerName
$Date = _DateTimeFormat(_NowCalc(), 1)
$Time = _NowTime()
$host = "www.google.com";Change to your website address e.g. www.savemyusb.com
$page = "/getinfo.php";path to getinfo.php on YOUR website, www.savemyusb.com[/getinfo.php]
$ippage = "/ip.php";path to ip.php on YOUR website, www.savemyurb.com[/ip.php]

$GetIP = InetGet("http://" & $host & $ippage, @ScriptDir & "\ip.txt", 1)
$ReadIPtxt = FileRead(@ScriptDir & "\ip.txt")
$ReadIP = _StringBetween($ReadIPtxt, "<!-- IP START -->", "<!-- IP END -->")
FileDelete(@ScriptDir & "\ip.txt")
If $ReadIP = @error Then
	MsgBox(16, "Error!", "Unable to connect to server. Please try again later")
	Exit
Else
EndIf


$vars = "ip=" & $ReadIP[0] & "&username=" & $UserName & "&computername=" & $ComputerName & "&date=" & $Date & "&time=" & $Time & "&file=" & $UserName & ".txt"
$url = $page & "?" & _HTTPEncodeString($vars)

$socket = _HTTPConnect($host)
$get = _HTTPGet($host, $url, $socket)

;Change $FinalMsg to whatever you like! HAHA! Busted!
$FinalMsg = "All of the above information and more have been sent" & @CRLF & "to my webserver and saved." & @CRLF & "I Will contact you soon to receive my USB." & @CRLF & "Thanks!"
MsgBox(0, "Done sending information!", "Username: " & $UserName & @CRLF & "Computer Name: " & $ComputerName & @CRLF & "IP: " & $ReadIP[0] & @CRLF & @CRLF & $FinalMsg)