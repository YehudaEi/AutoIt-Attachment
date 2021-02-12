#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Global $gmap = "http://maps.google.com/maps?q=+" ;, $lat, $lon
;**************************** THIS ONE USES GOOGLE CHROME AS THE BROWSER **********************
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("GPS locator", 175, 210, 425, 275, 0, $WS_EX_TOPMOST)
;$Form1 = GUICreate("GPS locator", 175, 185, 425, 275, 0, $WS_EX_TOPMOST)
$Label1 = GUICtrlCreateLabel("Enter Kall Sign", 45, 5, 85, 17)
$ibDevice = GUICtrlCreateInput("", 10, 20, 100, 21)
$btSearch = GUICtrlCreateButton("Locate", 110, 19, 45, 23, $WS_GROUP)
$Label2 = GUICtrlCreateLabel("Time of last position", 35, 45, 97, 17)
$ibTime = GUICtrlCreateInput("", 10, 60, 145, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL,$ES_READONLY))
$Label3 = GUICtrlCreateLabel("Lattitude", 10, 85, 45, 17)
$ibLatt = GUICtrlCreateInput("", 10, 100, 70, 21, $ES_READONLY)
$Label4 = GUICtrlCreateLabel("Longitude", 85, 85, 51, 17)
$ibLong = GUICtrlCreateInput("", 85, 100, 70, 21, $ES_READONLY)
$btLocate = GUICtrlCreateButton("Map Unit", 10, 150, 55, 23, $WS_GROUP)

$Label5 = GUICtrlCreateLabel("Speed", 30, 130, 51, 17)
$iSpeed = GUICtrlCreateInput("", 70, 125, 35, 21, $ES_READONLY)
$Label6 = GUICtrlCreateLabel("MPH", 110, 130, 51, 17)

$btReturn = GUICtrlCreateButton("Clear", 65, 150, 55, 23, $WS_GROUP)
$btExit = GUICtrlCreateButton("Exit", 120, 150, 35, 23, $WS_GROUP)



GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetState($btLocate, $GUI_DISABLE)


Global Const $datafile = "C:\messages.txt"       ;; change as needed
Global Const $MaxLines = 1500                                ;; read up to last $MaxLines lines of above file
Global Const $LineSize = 113                                ;; estimated line size in bytes

Local $device, $devdata, $myURL, $res, $devcoord, $lat, $lon, $gmap, $btReturn, $Speed

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $btExit, $GUI_EVENT_CLOSE
            Exit
			Case $btReturn

GUICtrlSetData($ibLong,"") ;clear the box
GUICtrlSetData($ibLatt,"") ;clear the box
GUICtrlSetData($ibTime,"") ;clear the box
GUICtrlSetData($ibDevice,"") ;clear the box
GUICtrlSetData($iSpeed,"") ;clear the box


GUICtrlSetState($btLocate, $GUI_DISABLE)
GUICtrlSetState($btExit, $GUI_ENABLE)
GUICtrlSetState($ibDevice, $GUI_FOCUS) 
  ; GUISetState($ibDevice, $GUI_FOCUS)

    ;_WinAPI_SetFocus(GUICtrlGetState($ibDevice))
;switch
        Case $btSearch
           GUICtrlSetState($btLocate, $GUI_DISABLE)
			GUICtrlSetState($btExit, $GUI_DISABLE)
            GUICtrlSetData($ibTime, "")
            GUICtrlSetData($ibLatt, "")
            GUICtrlSetData($ibLong, "")
            $device = GUICtrlRead($ibDevice)
            $devdata = Lookup($device, $datafile)
		
			
            Switch @error
                Case 0
                    Local $devcoord = StringSplit($devdata, '|', 2)
                    GUICtrlSetData($device, $devcoord[1])
                    GUICtrlSetData($ibTime, $devcoord[0])
                    GUICtrlSetData($ibLong, $devcoord[2])
                    GUICtrlSetData($ibLatt, $devcoord[3])
				;	Local $Speed = StringSplit($devdata, '|', 7)
					GUICtrlSetData($iSpeed, $devcoord[4])
                   GUICtrlSetState($btLocate, $GUI_ENABLE)
;		$lon = $devcoord[2] 
;		$lat = $devcoord[3] 
;		$myURL = $gmap & $lat & ", " & $lon
;		ShellExecute($myURL)	
                Case 1
                    GUICtrlSetData($ibTime, "-- Cannot locate that unit --")
                    GUICtrlSetData($ibLatt, "")
                    GUICtrlSetData($ibLong, "")
                Case 2
                    MsgBox(16, "Fatal error!", $datafile & " can't be found")
            EndSwitch
        Case $btLocate
		
		$lon = $devcoord[2] 
		$lat = $devcoord[3] 
		$myURL = $gmap & $lat & ", " & $lon
		
				ShellExecute("http://maps.google.com/maps?q=+" & $lat & ", " & $lon) ; This one is used when I'm using the default web browser
		
		; this command is used when I'm using portable google chrome: ShellExecute(@ScriptDir & "\chrome.exe", $gmap & $lat & "," & $lon)
		
		
;
;EndSwitch
; invoke Google Map or go play blackjack
    EndSwitch
WEnd

; Since we don't know exactly where to start reading the tail of the file, let's
; assume the format is essentially fixed (or at least well bounded). We can compute
; a good approximation of the file position we need to read from, in order to read
; about $MaxLines of useful data.
;
; A line of the example file is 111 characters, plus 2 (CRLF) = 113 characters.
; assuming UTF-8 or ANSI encoding, that is 113 bytes. If we position the reading point
; few bytes before $MaxLines * 113, and throw away the next line read (probably incomplete)
; we should be able to read about $MaxLines full records.
;
; The above strategy may have to be adapted if any assumption made doesn't hold for some
; reason.
;
; It's better to open the file at every lookup so that we minimize chance of missing
; newly added data by the logging process.
Func Lookup($unit, $filename)
    Local $hdl = FileOpen($filename, 0)
    If $hdl = -1 Then Return(SetError(2, 0, ''))    ; no such file
    Local $pos = FileGetSize($hdl) - $MaxLines * $LineSize - 20
    If $pos > 0 Then
        FileSetPos($hdl, $pos, 0)                   ; set position, starting from begin of file
    EndIf
    FileReadLine($hdl)                              ; throw away until line break
    Local $data = FileRead($hdl)                    ; read to EOF
    FileClose($hdl)
    $data = StringSplit($data, @CRLF, 3)            ; make it an array of lines
    Local $res
    $devcoord = ''
    ; search from bottom up
    For $i = UBound($data) - 1 To 0 Step -1
        $res = StringRegExpReplace($data[$i], "(?i)\[([^\]]+)\]\s*\|" & _	 ; [Mon Apr 12 17:46:18 2010] |	 captured as $1
"[^|]*\|" & _	 ; AVL1|	 skipped
"(" & $unit & ")\|" & _	 ; C119|	 captured as $2
"(-?\d{3})(\d+)\|" & _	 ; -112127750|	 captured as $3 and $4
"(-?\d{2})(\d+)\|" & _	 ; 33762840|	 captured as $5 and 6
"[^|]*\|" & _	 ; 3500|	 skipped
"[^|]*\|" & _	 ; 3500|	 skipped
"(\d{3})" & _	 ; 068	 captured as $7
".*", _
"$1\|$2\|$3\.$4\|$5\.$6\|$7")	 ; this builds the result string, separating fields with |
; with this example, the $res string would be: [Mon Apr 12 17:46:18 2010]|C119|-112.127750|33762840|068

;~ ; if you want the block where the is 082 in the modified example, use this instead
;~ $res = StringRegExpReplace($data[$i], "(?i)\[([^\]]+)\]\s*\|" & _	 ; [Mon Apr 12 17:46:18 2010] |	 captured as $1
;~ "[^|]*\|" & _	 ; AVL1|	 skipped
;~ "(" & $unit & ")\|" & _	 ; C119|	 captured as $2
;~ "(-?\d{3})(\d+)\|" & _	 ; -112127750|	 captured as $3 and $4
;~ "(-?\d{2})(\d+)\|" & _	 ; 33762840|	 captured as $5 and 6
;~ "[^|]*\|" & _	 ; 3500|	 skipped
;~ "[^|]*\|" & _	 ; 3500|	 skipped
;~ "[^|]*\|" & _	 ; 068000|	 skipped
;~ "(\d{3})" & _	 ; 082	 captured as $7
;~ ".*", _
;~ "$1\|$2\|$3\.$4\|$5\.$6\|$7")	 ; this builds the result string, separating fields with |
;~ ; with this example, the $res string would be: [Mon Apr 12 17:46:18 2010]|C119|-112.127750|33762840|082
        If @extended <> 7 Then ContinueLoop
        $devcoord = $res
        Return(SetError(0, 0, $res))                ; return device data found
    Next
    Return(SetError(1, 0, ''))                      ; device not found
EndFunc
 