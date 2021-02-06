#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>

Global $gmap = "http://maps.google.com/maps?q=+", $lat, $lon
Global $sfile = "e:\messages.txt"

;dim $sfile, $gmap

Opt("MustDeclareVars", 1)

Global $iMemo

_Main()

Func _Main()
	Local $btn2, $msg, $label_1
	
	GUICreate("Finder", 150, 40) ; will create a dialog box that when displayed is centered
	
	;I want to make this an input box but I don't know how to use the input to search
	;the messages.txt file for that specific bit of data.
	
	$label_1 = GuiCtrlCreateLabel ("Needs input box here", 2, 10)
	GuiCtrlSetColor (-1, 0xcc00cc)
	
;Create button on the form
$btn2 = GUICtrlCreateButton("Find", 115, 5, 30, 25)

	GUISetState()  

;when button is pressed do this:
While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg =$btn2
			;when you push the button go to this command please:
			    UnitLookup()
				ExitLoop
		EndSelect
	WEnd

	Exit
EndFunc   ;==>_Main

func UnitLookup()
	Local $file, $eof, $aString, $lat, $lon, $lat1, $lat2, $lon1, $lon2, $myURL, $gmap
Global $gmap = "http://maps.google.com/maps?q=+", $lat, $lon
;Global $sfile = "e:\messages.txt"
$file = FileOpen($sfile, 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to find that unit.")
    Exit
else
;Looks at the last line in the text ONLY
$eof = FileReadLine($sfile, -1)

FileClose($file)

; parses last line ($eof) into an array
$aString = StringRegExp($eof, "\w+[^\|]", 3)

$lat = $aString[10]
$lon = $aString[9]

; splits $lat string into two parts to allow insert of "." then rejoins
$lat1 = StringLeft($lat, 2)
$lat2 = StringRight($lat, 6)
$lat = $lat1 & "." & $lat2

; splits $lon string into two parts to allow insert of "." then rejoins
$lon1 = StringLeft($lon, 3)
$lon2 = StringRight($lon, 6)
$lon = $lon1 & "." & $lon2

; put it all together in a URL that any browser and Google with like
$myURL = $gmap & $lat & ",-" & $lon

;couldn't get $gmap to combine with $myURL so I manually typed in the URL here with a + $myURL
;which containes the two latitude and longitude combined:
ShellExecute( "http://maps.google.com/maps?q=+"& $myURL)
EndIf
EndFunc