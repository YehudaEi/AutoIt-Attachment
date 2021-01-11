#include <HTTP.au3>

$Header = "Content-Type: application/x-www-form-urlencoded"
$Host = "brihar7.freehostia.com"
$File = "/register.php"
$URL = "http://" & $Host & $File
$PostData = "UserID=Username&Password=Password"


Func QuickOutput($Filename, $Output, $Mode)
	Local $File = FileOpen($Filename, $Mode)
	FileWriteLine($File, $Output)
	FileClose($File)
EndFunc



;Using HTTP.au3 : http://www.autoitscript.com/forum/index.ph...amp;hl=HTTP/1.1

$Socket = _HTTPConnect($Host)
_HTTPPost($Host, $File, $Socket, $PostData)
$recv = _HTTPRead($Socket,1)
QuickOutput("Response.html",$recv, 2)
_HTTPClose($Socket)