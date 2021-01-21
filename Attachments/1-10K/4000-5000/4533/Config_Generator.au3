; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         C McCormack chrismccormack@vodat-int.com
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
;AutoItSetOption("WinTitleMatchMode", 4)


; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------


; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "YOU ARE ABOUT TO THE CONFIG SPLIT PROGRAM", "PLEASE CLICK YES TO CONTIUNE")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(0, "Closing Down", "Click OK to exit.")
    Exit
EndIf

SplashTextOn("Folder Browse", "Please Select the folder you require as the " & @CRLF & @CRLF & "Output location." , -1, 200, -1, -1, 0, "", 24)
Sleep(5000)
SplashOff()

; $OUTLOC = inputbox("OUTPUT LOCATION", "Please enter the location to save the files."& @CRLF & @CRLF &"Example C:\test")
$OUTLOC = FileSelectFolder("Choose a file.", "")
$outloc2 = msgbox(4, "The location you have entered is", $OUTLOC)
If $outloc2 = 7 Then
    MsgBox(0, "Closing Down", "Click OK to exit.")
    Exit
EndIf

$fileext = inputbox("FILE EXTENSION REQUIRED", "Please enter the File EXTENSION you require."& @CRLF & @CRLF &"Extension of .TXT enter TXT"& @CRLF & @CRLF &"Extension of .NEW enter NEW")
$fileext2 = MsgBox(4, "The EXTENSION you have entered is ", $fileext)
If $fileext2 = 7 Then
    MsgBox(0, "Closing Down", "Click OK to exit.")
    Exit
EndIf

ProgressOn("Progress Meter", "Every File That is Written", "0 percent","", "", 16)
$x = 1

While 1
    $ans = FileReadLine(@ScriptDir & '\Config.txt', $x)
    If @error = -1 Then ExitLoop; If end of file, then exitloop
    If $ans = '####' Then; Create new filename
        $x = $x + 1
        $filename = FileReadLine('config.txt', $x)
				$x = $x + 1
        ContinueLoop
    EndIf
		DirCreate ( $outloc )
    $save = $outloc & "\" & $filename & $fileext
    FileWriteLine($save, $ans); Write file
	ProgressSet ( $save, $filename & $fileext)
    $x = $x + 1
    sleep(100)
	ProgressSet ( $x, $filename & $fileext)
 
WEnd

ProgressSet($ans , "Done", "Complete")
sleep(1500)
ProgressOff()

$complete = $outloc & ".  With The Extension Of ." & $fileext

msgbox(0, "Config Have now been created in the location", $complete)
