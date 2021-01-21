$inipath = @WindowsDir

if not fileexists(@DesktopDir & "\StoogeLog!.lnk") Then
	filecreateshortcut(@autoitexe, @DesktopDir & "\StoogeLog!.lnk")
EndIf

if not fileexists(@DesktopDir & "\StoogeLog Setup.lnk") Then
	filecreateshortcut(@autoitexe, @DesktopDir & "\StoogLog Setup!.lnk", "", "!Baaalls!")
EndIf

$user = iniread($inipath & "\stoogelog.ini", "Login", "User", "Not Found")

if ($cmdline[0] > 0) or $user = "Not Found" Then
	if not Setup() Then Exit
EndIf

$user = iniread($inipath & "\stoogelog.ini", "Login", "User", "Not Found")
$pass = iniread($inipath & "\stoogelog.ini", "Login", "User", "Not Found")

run(@programfilesdir & "\World Of Warcraft\Wow.exe")

AutoItSetOption("WinTitleMatchMode", 4)
WinWait("World of Warcraft")
dim $xy[4]
WinActivate("World of Warcraft")
blockinput(1)

;msgbox (0, $xy[0] & " by " & $xy[1],"")

;while $xy[0] < 300
$xy = WinGetPos("World of Warcraft")
;WEnd

;mousemove($xy[0]-1, $xy[1]-1,0)

;while pixelchecksum($xy[0]+100,$xy[1]+75,$xy[0]+104,$xy[1]+79) <> 2291477401
;	sleep(200)
;WEnd



sleep(2000)
MouseClick("left", $xy[0]+$xy[2]/2, $xy[1]+$xy[3]*.55833333333333,1,0)
sleep(100)


send("{HOME}+{END}{DEL}")

send($user & "{TAB}")
;sleep(500)
;gWinActivate("World of Warcraft")

;MouseClick("left", $xy[0]/2, $xy[1]*.65277777777778,1,0)

;MouseClick("left", 480, 470,1,0)

send($pass & "{ENTER}")
blockinput(0)
;msgbox (0, "", pixelchecksum(100,75,104,79))


Exit

func Setup()
	
$user = inputbox ("Account name", "Enter Account Name", "", "", "", 90)

if $user = "" then
	return 0
Else
	iniwrite($inipath & "\stoogelog.ini", "Login", "User", $user)
EndIf

$pass = inputbox("Password", "Enter Password:","","*","",90)

if $pass = "" then 
	msgbox (0, "Error", "Must have password")
	return -1
Else
	iniwrite($inipath & "\stoogelog.ini", "Login", "Password", $pass)
EndIf

return -1


EndFunc