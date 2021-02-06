; Down&Up Script
;  Columbia, Initial Version
;  by Tony Boyles for the Comparative Law Project
;  This script is protected under the GNU GPL
; http://nortalktoowise.com

#include <FF.au3>

$URLfile = FileOpen("ColumbiaURLS2.txt", 0)
$datefile = FileOpen("Columbiadates.txt", 0)
$docketfile = FileOpen("Columbiadockets.txt", 0)
$titlefile = FileOpen("Columbiatitles.txt", 0)
$URL = ""
$date = ""
$docket = ""
$filename = ""
$title = ""

AutoItSetOption ("WinTitleMatchMode", 2)
_FFStart("http://128.252.251.102/complawAdmin/complaw/index.php")
Sleep (300)
MouseClick("left", 1070, 250, 1, 1)
Send("{TAB}")
Sleep(500)
Send("USERNAME{TAB}")
Sleep(500)
Send("PASSWORD{TAB}{SPACE}")
_FFLoadWait()
If NOT _FFOpenURL ("http://128.252.251.102/complawAdmin/complaw/index.php?rt=cases/setCountry/48", True) Then
	MsgBox ( 64, "" , "Cannot Open Comparative Law Project, Columbia Page")
	Exit()
EndIf
Sleep (500)
Send("{CTRLDOWN}t{CTRLUP}")
Sleep (500)

For $k = 1 to 1208 Step 1
	Sleep (300)
	MsgBox(0,"",$docket)
	$URL=FileReadLine($URLfile, $k)
	$date=FileReadLine($datefile, $k)
	$docket=FileReadLine($docketfile, 2*$k-1)
	MsgBox(0,"",$docket)
	$title=FileReadLine($titlefile, $k)
	If $title == " "&Chr(13) Then
		$title="Sentencia " & $docket
		MsgBox(0,"",$docket)
	EndIf
	$filename=$docket & ".pdf"
	MsgBox(0,"",$docket)
	If Not FileExists("C:\Documents and Settings\Abhorsen\My Documents\" & $filename) Then
		If NOT _FFOpenURL($URL) Then
			MsgBox(64, "", "Failure to load page: " & $URL)
			Exit
		EndIf
		WinWaitActive("WordPad")
		Sleep(600)
		Send("{CTRLDOWN}p{CTRLUP}")
		WinWaitActive("Print")
		Sleep(600)
		Send("{ENTER}")
		WinWaitActive("Save As")
		Sleep(300)
		Send($filename & "{ENTER}")
		Sleep(300)
		Send("{ENTER}")
		Sleep(300)
		Send("{ALTDOWN}{F4}{ALTUP}")
		Sleep(300)
		Send("{RIGHT}{ENTER}")
		Sleep(300)
		WinWaitActive("Mozilla Firefox")
		_FFLoadWait()
		Sleep(300)
	EndIf

	;BEGIN COMPLAW INTERACTION
	
	Send("{CTRLDOWN}{TAB}{CTRLUP}")
	Sleep(300)
	Send("{HOME}")
	Sleep(300)
	MouseClick("left", 780, 270, 1, 1)
	_FFLoadWait()
	Sleep(750)
	Send("{HOME}")
	MouseClick("left", 370, 340, 1, 1)		
	_FFLoadWait()
	Sleep(750)	
	Send($title & "{TAB}")
	Sleep(300)
	Send($date & "{TAB}")
	Sleep(500)
	MsgBox(0,"",$docket)
	Send($docket & "{TAB}{TAB}{TAB}{ENTER}")
	Sleep(300)
	MsgBox(0,"",$docket)
	_FFLoadWait()
	Sleep(300)
	_FFAction("reload")
	_FFLoadWait()
	Sleep(300)
	MouseClick("left", 590, 490, 1, 1)
	_FFLoadWait()
	Sleep(500)
	Send("{HOME}")
	Sleep(500)
	MouseClick("left", 280, 530, 1, 1)
	_FFLoadWait()
	Sleep(900)
	ClipPut($URL) ;in case page loaded incorrectly
	Send($URL & "{TAB}{SPACE}{TAB}{TAB}{ENTER}")
	WinWaitActive("File Upload")
	Sleep(500)
	Send($filename & "{ENTER}")
	WinWaitActive("The Comparative Law Project - Mozilla Firefox")
	Sleep(1000)
	Send("{TAB}{TAB}{ENTER}")
	WinWaitActive("The Comparative Law Project - Mozilla Firefox")
	Sleep(300)
	_FFAction("reload")
	Send("{CTRLDOWN}{TAB}{CTRLUP}")
Next

WinClose("Mozilla Firefox")
MsgBox(0, "Down&Up", "All Finished!")