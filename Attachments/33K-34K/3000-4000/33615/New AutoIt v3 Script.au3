#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

	Start with all Internet Explorer windows CLOSED
	Program will open webpage http://www.mapquestapi.com/staticmap/wizard.html

	"PAUSE" key will pause program

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

ShellExecute("C:\Program Files\Belltech CaptureXT\screencap.exe")
#include <file.au3>
#include <trim.au3>
#include <Clipboard.au3>
#include <IE.au3>

Global $pause = False

HotKeySet("{PAUSE}","_pause")

$i = 0
$_Begin = TimerInit()

$_MergeFile = "S:\JimMusgrave\Address_Sample.txt"
$_File = FileOpen($_MergeFile, 0)

AutoItSetOption("WinTitleMatchMode",2)

$_oIE = _IECreate("http://www.mapquestapi.com/staticmap/wizard.html")
Winmove("Internet Explorer","",10,10,1100,1000)

MouseClick("LEFT",458,368,1)
MouseClick("LEFT",428,396,1)


While 1
	$_Record = $i + 1

	$line = FileReadLine($_File)
	If @error = -1 Then ExitLoop
	$_FromAddress = _AllTrim(StringLeft($line,45))
	$_FromZip = _AllTrim(StringMid($line,46,10))
	$_ToAddress = _AllTrim(StringMid($line,56,40))
	$_ToZip = _AllTrim(StringMid($line,96,15))

	WinActivate("Internet Explorer")

	MouseClick("LEFT",305,406,1,5)
	Send($_FromAddress & ', ' & $_FromZip)		;Enter From Address
	MouseClick("LEFT",531,406,1,5)
	Send($_ToAddress & ', ' & $_ToZip)		;Enter To Address
	MouseClick("LEFT",730,406,1,5)		;Click Go

	_IELoadWait($_oIE,2600,1000)		;Change 2nd variable for timeout between address enter and image capture

	#Region IMAGE CAPTURE

;~ 	Enter image capture script here

	WinActivate("Belltech")
	WinWaitActive("Belltech")

	Send("^r")
;~ 	MouseClick("LEFT",86,98,1)

	WinActivate("Internet Explorer")

	MouseMove(260,480,2)
	Sleep(1000)
	MouseClickDrag("LEFT",260,480,851,882,30)

	WinActivate("Belltech")
	WinWaitActive("Belltech")

;~ 	Sleep(800)
	Send("!f")
	Sleep(200)
	Send("a")

;~ 	Exit
	IF $i = 0 Then
		ToolTip("Leave file name field blank",938,578,"Create Directory, Click in name field",6)
		MsgBox(48,"Save Directory","Create JPG save directory")
	endif

	ToolTip("")

	Send("!n")
	Sleep(200)
	Send($_Record & ".jpg")
	Send("!s")
	Sleep(200)

	Send("!f")
	Sleep(200)
	Send("c")

;~ 	Exit
	#EndRegion IMAGE CAPTURE

	WinActivate("Internet Explorer")
	WinWaitActive("Internet Explorer")

	MouseClick("LEFT",900,520,1,5)		;Clear Results

;~ 	Exit

	$i += 1

	ToolTip("Completed record " & $i,500,200,"Status",1,4)

;~ 	If $_Record = 2 Then
;~ 		ExitLoop
;~ 	EndIf


WEnd

FileClose($_File)

$_ProcessTime = TimerDiff($_Begin)
$_ProcessTime = Round($_ProcessTime / 1000,0)

MsgBox(48,"Mapping Complete",$i & " addresses maped" & @CRLF & @CRLF & "Elapsed time: " & $_ProcessTime & " seconds")

Exit

Func _pause()
    $pause = Not $pause
    If $pause Then
        While 1
            Sleep(100)
        Wend
    EndIf
EndFunc