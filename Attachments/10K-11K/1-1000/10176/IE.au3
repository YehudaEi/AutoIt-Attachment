#include <IE.au3>

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






;~ ;Using IE.au3   :   http://www.autoitscript.com/forum/index.php?showtopic=25629
$o_IE = _IECreate ("about:blank",0,1)
$o_IE.navigate($URL, 0, 0, $PostData ,$Header)





