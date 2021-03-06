#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=File Explorer (BETA).exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_LegalCopyright=Tyler Hoffman
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <RecFileListToArray.au3>
#include <Array.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $img
Global $list
Global $aArray
Global $return
Global $fileslist
Global $aFiles

Local $max = 0

$gui = GUICreate("File Explorer", 300, 300, Default, Default, BitOr($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX ))
GUICtrlCreateLabel("Scan your folders for missing images, music, or excutable files!", 0, 0)
$combo = GUICtrlCreateCombo("View Images", 0, 20, 100)
GUICtrlSetData(-1, "View Music|View Excutables")
$viewfile = GUICtrlCreateButton("Scan", 120, 20, 40)

GUICtrlSetOnEvent($viewfile, "file")
GUISetOnEvent($GUI_EVENT_CLOSE, "close")
GuiSetOnEvent($GUI_EVENT_MAXIMIZE, "max")
GUISetState(@SW_SHOW)

while 1

	sleep(1000)
WEnd

func file()
$x = GuiCtrlRead($combo)
if $x = "View Images" Then
	$filearray = "*.png;*.jpg;*.gif"
ElseIf $x = "View Excutables" Then
	$filearray = "*.exe"
ElseIf $x = "View Music" Then
	$filearray = "*.mp3;*m4a;*aac"
Elseif $x = "" Then
MsgBox(0, "Error", "You Must Chose A File Type")
Return
EndIf
$aArray = ""
$fileslist = ""
$aFiles = ""
GUICtrlSetData($return, "")

$aArray = _RecFileListToArray(@UserProfileDir & "\", $filearray, 0, 1, 1, 0, "", _
            "AppData;Application Data;Cookies;Local Settings;NetHood;PrintHood;Searches;Templates")
ConsoleWrite("Error: " & @error & " - " & " Extended: " & @extended & @CRLF)


; Create a new array to hold the images
Global $aFiles[UBound($aArray)] = [0]
For $i = 1 To $aArray[0]
    ; If the element is a file
    If StringRight($aArray[$i], 1) <> "\" Then
        ; Add to the image array
        $aFiles[0] += 1
        $aFiles[$aFiles[0]] =" " & $aArray[$i] & @CRLF
    EndIf
Next
; Resize the image array correctly
ReDim $aFiles[$aFiles[0] + 1]

$fileslist = _ArrayToString($aFiles , "", 1)
$return = GUICtrlCreateLabel($fileslist, 0, 50)


EndFunc

Func close()
	Exit
EndFunc

Func max()
	if $max = 0 Then
		GUISetState(@SW_SHOWMAXIMIZED)
		$max = 1
		Return
	ElseIf $max = 1 Then
		GUISetState(@SW_SHOWDEFAULT)
		$max = 0
		Return
	EndIf
EndFunc


