#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=shout.ico
#AutoIt3Wrapper_Outfile=iteration.exe
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;
;
;  DVDLister
;
;  a more advanced program. A list that can be sorted different ways and printed
;
;

;
; Global variables section
;

Global $NameVersion = "DVDLister 0.00"  ; Always placed here so I can easily chance the version number.
Global $DataFileName= "Titles.garth"    ; Name of the file containing the informstion
Global $DVDid       =""  				; Window GUI handle. Null if not loaded or file not exist.

; Tray Traggers

;
;
; include section
;

#Include <Array.au3>
#Include <File.au3>
#include <GUIConstantsEx.au3>

;
; Opts
;
Opt("TrayMenuMode", 3)   ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayAutoPause", 0)  ; No Pause on Menu

;
; Tray Triggers
;

; GUI Triggers
;
Local $Print, $Sort, $Apply, $Exit

;
; Create Tray Menu
;
$beginitem = TrayCreateItem("Run")
TrayCreateItem("") ; seperation line
$aboutItem = TrayCreateItem("About")
TrayCreateItem("") ; seperation line
$exitItem = TrayCreateItem("Close")
TraySetState()

;
; Main Forever Loop
;
While 1

    ; Look for GUI events
    Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			GUIDelete($DVDid)
		Case $Print

		Case $Apply

		Case $Sort

		Case $Exit
    EndSwitch

    ; Look for tray events
    Switch TrayGetMsg()
        Case $exitItem
            MyExit()
        Case $beginitem
            StartProgram()
        Case $aboutItem
            aboutMsg()
    EndSwitch

WEnd

;
; Tray Routines
;

Func MyExit()
	If $DVDid <> "" Then GUIDelete($DVDid)
	Exit

EndFunc   ;==>MyExit

Func aboutMsg()

    Local $message
    $message = $NameVersion & @CRLF & @CRLF
    $message = $message & "by Garth Bigelow"
    $message = $message & @CRLF & "With the infinite patience of the AutoIt Help Forums" & @CRLF
    $message = $message & @CRLF & "no rights reserved"
    MsgBox(64, "About:", $message)

EndFunc   ;==>aboutMsg

;
; GUI Routines
;

Func StartProgram()

	DVDWindow()
	Load_Array()

EndFunc ;==>StartProgram

Func DVDWindow()

	$DVDid = GUICreate("DVD List")

EndFunc

Func Load_Array()

	Local $FileLines, $TempRow
	$FileLines = _FileCountLines($DataFileName)
	Global $Data[$FileLines][4]
	_FileReadToArray($DataFileName, $Data)

	For $a = 1 To $FileLines
		$TempRow = StringSplit($Data[$a],"*")
;		msgbox(0, $FileLines, $TempRow[1] & " . " & $TempRow[2] & " . " & $TempRow[3] & " . " & $TempRow[4])
		$Data[$a][1] = $TempRow[1]
		$Data[$a][2] = $TempRow[2]
		$Data[$a][3] = $TempRow[3]
		$Data[$a][4] = $TempRow[4]
	Next
	_ArrayDisplay($Data)

EndFunc

