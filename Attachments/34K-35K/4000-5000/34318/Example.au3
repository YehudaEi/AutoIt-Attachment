Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
Run('DVDFab8098Qt.exe')
$Mydir=@ProgramFilesDir&'\MediaProcessing\DVDFAB_8'
$StarMen='MediaProcessing\DVDFAB_8'
$DVDFabkey='Censored'
$Setup='Setup - DVDFab 8 Qt'
$read='Please read the foll'
$read2='When you are ready'
$Selan='Select Setup Language'
$Slang='Select the language '
$WelDVD='Welcome to the DVDFa'
$Destin='Select Destination L'
$Selsta='Select Start Menu Fo'
$Seladd='Select Additional Ta'
$ComDVD='Completing the DVDFa'
_WinWaitActive("Select Setup Language","Select the language ")
Send("{ENTER}")
_WinWaitActivate("Setup - DVDFab 8 Qt","Welcome to the DVDFa")
Send("{ENTER}")
_WinWaitActivate("Setup - DVDFab 8 Qt","Please read the foll")
Send("{UP}{ENTER}")

###########################################################################################################################################



While 1
	If WinExists("Open File - Security Warning","") Then ExitLoop
	If WinExists($Selan,$Slang) Then ExitLoop
WEnd
If WinExists("Open File - Security Warning","") Then
Send("!r")
EndIf




If WinExists($Selan,$Slang) Then
#WinWaitActive($Selan,$Slang)
#ControlSend($Selan,$Slang,"TNewButton1","{ENTER}")
Send("{ENTER}")
EndIf

WinWaitActive($Setup,$WelDVD)
ControlClick($Setup,$WelDVD,"TNewButton2")


WinWaitActive($Setup,$read)
ControlClick($Setup,$read,"TNewRadioButton1")
ControlClick($Setup,$read,"TNewButton2")
WinWaitActive($Setup,$Destin)
ControlSetText($Setup,$Destin,"TEdit1",$Mydir)
ControlClick($Setup,$Destin,"TNewButton3")
WinWaitActive($Setup,$Selsta)
ControlSetText($Setup,$Selsta,"TNewEdit1",$StarMen)
ControlClick($Setup,$Selsta,"TNewButton4")
WinWaitActive($Setup,$Seladd)
ControlClick($Setup,$Seladd,"TNewButton4")
WinWaitActive($Setup,$read2)
ControlClick($Setup,$read2,"TNewButton4")
WinWaitActive($Setup,$ComDVD)
ControlClick($Setup,$ComDVD,"TNewRadioButton2")
ControlSend($Setup,$ComDVD,"TNewButton4","{ENTER}")
sleep(5000)
FileCopy("Key.DVDFabPlatinum", $Mydir)
While 1
If ProcessExists("DVDFab.exe") Then ExitLoop
WEnd
If ProcessExists("DVDFab.exe") then ProcessClose("DVDFab.exe")
If WinExists ("Welcome to DVDFab","") Then ProcessClose("DVDFab.exe")
$message = @LF&"DVDFAB Platinum setup just finished"
SplashTextOn("Cor's customized automated setup routines", $message, -1, 90, -1, -1, 0, "Comic Sans MS", 12, 500)
Sleep(2000)
SplashOff()






