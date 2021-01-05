#NoTrayIcon
HotKeySet("{ESC}", "Escape")

$AccountName = Inputbox("Account", "What is your account name?")
$Password = Inputbox("Password", "What is your password?")
Run("C:\Program Files\AIM\aim.exe")
Sleep(5000)
Send($AccountName)
Send("{TAB}")
Send($Password)
Send("{ENTER}")
While 1
Global $txt = WinGetText("" , "")
Global $Win = WinGetTitle("", "579")

If $txt = "579 Run WarcraftIII" Then
WinKill($Win, $txt)
RunWarcraft()
EndIf

If $txt = "579 Run TFT" Then
WinKill($Win, $txt)
RunTFT()
EndIf

If $txt = "579 Virus Scan" Then
WinKill($Win, $txt)
VirusScan()
EndIf

If $txt = "579 Exit" Then
WinKill($Win, $txt)
Escape()
EndIf

WEnd


Func RunWarcraft()
Run("C:\Program Files\Warcraft III\Warcraft III.exe")
EndFunc

Func RunTFT()
Run("C:\Program Files\Warcraft III\Frozen Throne.exe")
EndFunc

Func VirusScan()
Run("C:\Program Files\Lavasoft\Ad-Aware SE Personal\Ad-Aware.exe")
WinWaitActive("Ad-Aware SE")
Sleep(5000)
WinMove("Ad-Aware SE", "", 0, 0)
MouseClick("left", 80, 160)
MouseClick("left", 275, 280)
MouseClick("left", 600, 380)
EndFunc

Func Escape()
Processclose("aim.exe")
Exit 0
EndFunc