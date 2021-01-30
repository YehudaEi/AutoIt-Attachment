Opt("WinTitleMatchMode", 2)
Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
Opt("PixelCoordMode", 1) ;1=absolute, 0=relative, 2=client

#include <GUIConstants.au3>
#include <File.au3>
#include <IE.au3>
;#include <imagesearch.au3> works but not reliable enough
#include <Array.au3>
#include <String.au3>

Global $sLogPath = "C:\test\Notfound.txt"
Global $sLogMsg
Global $Paused
Global $sLogMsg
Dim $sloc
Dim $body
Dim $Find
Dim $Findx
Dim $csvArray
Dim $serial
Dim $Errx = "C:\test\test1.txt"
Dim $x
Dim $oIE

HotKeySet("{PAUSE}", "Pause")
HotKeySet("{ESC}", "End Programme")
HotKeySet("+!d", "Message")

$oIE = _IECreate("http://www.domain.com")
WinSetState("Internet Explorer", "", @SW_MAXIMIZE)

MouseClick("left", 43, 289, 1)

	_FileReadToArray("C:\test\B.csv", $csvArray)

For $x = 1 To $csvArray[0]
	if FileExists($Errx) then
	FileOpen("C:\test\test1.txt", 2); used to clear contents of body read
	FileClose("$Errx")
	EndIf
	SplashTextOn("First interiors", "First interiors" & @CRLF & "Image Aquistion Programme", 250, 150, 30, 30, 1, "", 24)
	_IELoadWait($oIE)
	SplashTextOn("First interiors", "Esc= Terminate" & @CRLF & "Pause/break to Pause", 250, 150, 30, 30, 1, "", 24)
	Sleep(1000)
	MouseClick("left", 43, 289, 1)
	Sleep(1000)
	Send($csvArray[$x])
	Sleep(1000)
	Send("{TAB}")
	Sleep(1000)
	Send("{ENTER}")
	_IELoadWait($oIE)

	$Findx = "And Microsoft OLE DB Provider for ODBC Drivers error";
	$Find = "Sorry. No Matches Found for -";
	$Before = ""     ; my info shows before this line... or set as ""
	Sleep(100)
	$body = _IEBodyReadHTML($oIE)
	$sloc = @ScriptDir & "\test1.txt"
	Sleep(1000)
	FileWrite($sloc, $body)
	$sfile = FileOpen($sloc, 0)
	$num = 0
	While 1
    $num = $num + 1
    $sline = FileReadLine($sfile, $num)
	If @error Then
        MsgBox(262208, "IMAGE FOUND!", "Please wait while the" & @CRLF & "Acquire Image Functions are Called", 1)
		Sleep(1000)
		call ("AcquireImage")
		ExitLoop
	EndIf
	If StringInStr($sline, $Find) Then
		MsgBox(64, "No Image", "No Image for " & $csvArray[$x] & " was found " & @CRLF & " on Domain ", 1)
		Sleep(100)
		Call ("Err")
        ExitLoop
    EndIf
WEnd

	Next

Func Err()
	Sleep(100)
	if FileExists("C:\test\test1.txt") then ; this does not work as the file is being used
	FileDelete("C:\test\test1.txt")
	EndIf
	Sleep(100)
	$csvArray[$x] = $sLogMsg
	SplashTextOn("Error Log", "Writing to Error Log." & @CRLF & $csvArray[$x], 250, 150, 30, 30, 1, "", 24)
	Sleep(1000)
	_FileWriteLog($sLogPath, $sLogMsg, -1)
	_FileWriteToLine("C:\test\Notfound.txt", 3, "Not Found" & $csvArray[$x] & 0)
	;_FileWriteLog($sLogPath, $sLogMsg,-1)
	Return
	SplashOff()
EndFunc

Func AcquireImage()
			Sleep(100)
			if FileExists("C:\test\test1.txt") then
			FileDelete("C:\test\test1.txt")
			EndIf
			Sleep(100)
			SplashTextOn("", "Aquiring Image." & @CRLF & $csvArray[$x], 250, 150, 30, 30, 1, "", 24)
			Sleep(1000)
			MouseClick("right", 406, 510, 1)
			SplashTextOn("", "Sending Image Aquisition Commands", 250, 150, 30, 30, 1, "", 24)
			Sleep(100)
			Send("{UP}")
			Sleep(100)
			Send("{UP 9}")
			Sleep(100)
			Send("{UP}")
			Sleep(100)
			Send("{ENTER}")
			Sleep(1000)
				Send("{CTRLDOWN}{SHIFTDOWN}S") ; uses CTRL + SHIFT + S for save as (use your own here)
				Send("{CTRLUP}{SHIFTUP}")
				Send("Domain_" & $csvArray[$x] & "P1_tn.jpeg")
				Sleep(1000) ; wait for the save to complete
				Send("{ENTER}")
			SplashTextOn("", "Image Has Been Acquired" & @CRLF & $csvArray[$x], 250, 150, 30, 30, 1, "", 24)
			Sleep(1000)
			Return
			SplashOff()
EndFunc

Func TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	Exit 0
EndFunc   ;==>Terminate

Func ShowMessage()
	MsgBox(4096, "", "Programming.")
EndFunc   ;==>ShowMessage
