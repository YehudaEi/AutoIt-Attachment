
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





;~ ;http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winhttp/http/iwinhttprequest_send.asp

Dim $obj = ObjCreate ("WinHttp.WinHttpRequest.5.1")
$obj.Open("PUT", $URL, false)
$obj.Send($PostData)
QuickOutput("Response.html",$obj.ResponseText, 2)












