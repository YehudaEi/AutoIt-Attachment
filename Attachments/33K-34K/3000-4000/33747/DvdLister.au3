#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=DvdLister.exe
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
Global $Name = "DVDLister"
Global $NameVersion = $Name & " 0.10" ; Always placed here so I can easily chance the version number.
Global $DataFileName = "Titles.garth" ; Name of the file containing the informstion

Global $ArraySize = 0 ; The depth of the array
Global $Data
Global $DVDid = "" ; Window GUI handle. Null if not loaded or file does not exist.
Global $ListViewHandle = "" ; The ListView handle. Needed by many functions.
Global $printEditHandle, $printcancelhandle, $printprinthandle, $printEditHandle, $printhandle = "" ; print

Global $Apply, $Refresh, $test, $Print ; Button Handles

; Tray Traggers

;
;
; include section
;

#include <Array.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiListView.au3>
#include <Word.au3>


;
; Opts
;
Opt("TrayMenuMode", 3) ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayAutoPause", 0) ; No Pause on Menu

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

StartProgram()

;KeyTap(@ScriptLineNumber) ; a little feedback

;
; Main Forever Loop
;
While 1

	; Look for GUI events
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			EndWindow()

		Case $ListViewHandle
			RefreshListView()

		Case $Print
			KeyTap(@ScriptLineNumber)
			GUIDelete(Print())

		Case $Apply
			KeyTap(@ScriptLineNumber)
			WriteArrayToFile()

		Case $Refresh()
			KeyTap(@ScriptLineNumber)
			If MsgBox(256 + 48 + 1, "Warning", "Refreshing will erase any changes made since the last 'Apply'") = 1 Then
				Load_Array()
				msgbox(0,1,1)
				RefreshListView()
				MsgBox(0,2,2)
			EndIf

		Case $test
			KeyTap(@ScriptLineNumber)
			GUICtrlSetData($test, _GUICtrlListView_GetSelectedIndices($ListViewHandle)) ; testing

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

	EndWindow()
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


Func StartProgram()

	EndWindow()
	DVDWindow()

EndFunc   ;==>StartProgram

;
; GUI Routines
;	 Functions Below Here are in Alphabetical order
;

Func ButtonCenter($Width, $ListWidth, $ButtonWidth)

	Return (($Width + $ListWidth - $ButtonWidth) / 2)

EndFunc   ;==>ButtonCenter

Func ButtonPosition($row, $TopBottomSep, $ButtonHeight)

	Return ($TopBottomSep * $row) + ($ButtonHeight * ($row - 1))

EndFunc   ;==>ButtonPosition

Func DVDWindow()
	$Left = IniRead($Name & ".ini", "Starting Value", "Window Left", 2)
	If $Left = -32000 Then $Left = 2 ; if window was minimized at exit
	$Top = IniRead($Name & ".ini", "Starting Value", "Window Top", 2)
	If $Top = -32000 Then $Top = 2 ; if window was minimized at exit

	$Width = 560
	$Height = 300

	$SidesSep = 4
	$TopBottomSep = 4
	$ButtonWidth = 80
	$ButtonHeight = 50

	$DVDid = GUICreate("DVD List", $Width, $Height, $Left, $Top)
	GUISetState()

	$NumberOfRecords = Load_Array()
	$ListViewHandle = GUICtrlCreateListView("Title|Price|Test|Genre", $SidesSep, $TopBottomSep, 450, 268, BitOR($LVS_EDITLABELS, $LVS_SINGLESEL))

	_GUICtrlListView_SetColumn($ListViewHandle, 0, "Title", 200, 0)
	_GUICtrlListView_SetColumn($ListViewHandle, 1, "Price", 80, 1)
	_GUICtrlListView_SetColumn($ListViewHandle, 2, "Quantity", 80, 1)
	_GUICtrlListView_SetColumn($ListViewHandle, 3, "Genre", 80, 0)
	_GUICtrlListView_AddArray($ListViewHandle, $Data)

	$Apply = GUICtrlCreateButton("Apply", ButtonCenter($Width, 450, $ButtonWidth), ButtonPosition(1, $TopBottomSep, $ButtonHeight), $ButtonWidth, $ButtonHeight)
	GUICtrlSetTip($Apply, "Apply list to file.", "Explanation", 1)

	$Refresh = GUICtrlCreateButton("Refresh", ButtonCenter($Width, 450, $ButtonWidth), ButtonPosition(2, $TopBottomSep, $ButtonHeight), $ButtonWidth, $ButtonHeight)
	GUICtrlSetTip($Refresh, "Refresh list from file." & @CRLF & "All changes since last Apply will be lost", "Explanation", 1)

	$test = GUICtrlCreateButton("", ButtonCenter($Width, 450, $ButtonWidth), ButtonPosition(3, $TopBottomSep, $ButtonHeight), $ButtonWidth, $ButtonHeight)
	$Print = GUICtrlCreateButton("Print", ButtonCenter($Width, 450, $ButtonWidth), ButtonPosition(5, $TopBottomSep, $ButtonHeight), $ButtonWidth, $ButtonHeight)

EndFunc   ;==>DVDWindow


; We don't want pushing tray item 'run' creating multiple windows
Func EndWindow()

	If $DVDid <> "" Then
		$WPos = WinGetPos($DVDid)
		$x = $WPos[0]
		$y = $WPos[1]
		If $x <> -32000 Then IniWrite($Name & ".ini", "Starting Value", "Window Left", $x) ; save the x,y locations of the window
		If $y <> -32000 Then IniWrite($Name & ".ini", "Starting Value", "Window Top", $y) ; so next time it will be in the same place

		GUIDelete($DVDid)
		$DVDid = ""
	EndIf

EndFunc   ;==>EndWindow


Func KeyTap($ScriptLineNumber)

	If FileExists("tongue-clap.wav") Then
		SoundPlay("tongue-clap.wav")
	Else
		Beep(100, 18)
		Beep(160, 4)
	EndIf
	;MsgBox(0, "wtf?", $ScriptLineNumber)

EndFunc   ;==>KeyTap


Func Load_Array()

	Local $FileLines, $TempRow, $Lines
	_FileReadToArray($DataFileName, $Lines)

	Global $Data[$Lines[0] + 1][4]

	For $a = 1 To $Lines[0]
		$TempRow = StringSplit($Lines[$a], "*")
		$Data[$a][0] = $TempRow[1]
		$Data[$a][1] = Number($TempRow[2])
		$Data[$a][2] = Number($TempRow[3])
		$Data[$a][3] = $TempRow[4]
	Next
	$ArraySize = $Lines[0]

EndFunc   ;==>Load_Array


Func Print()
	Dim $TabStop[5] = [0, 200, 240, 280, 320]
	$printhandle = GUICreate("Tweak printing", 706, 638, 20, 20)
	$printprinthandle = GUICtrlCreateButton("Print", 3, 3, 75, 24)
	$printcancelhandle = GUICtrlCreateButton("Cancel", 80, 3, 75, 24)
	$printEditHandle = GUICtrlCreateEdit("", 3, 32, 700, 600)

	_GUICtrlEdit_SetTabStops($printEditHandle, $TabStop)
	_GUICtrlEdit_SetText($printEditHandle, "Reel Imports" & @CRLF & @CRLF)
	_GUICtrlEdit_AppendText($printEditHandle, "Title" & @TAB & "Price" & @TAB & "Quanity" & @TAB & "Genre" & @CRLF)

	For $a = 0 To $ArraySize
		_GUICtrlEdit_AppendText($printEditHandle, $Data[$a][0] & @TAB & $Data[$a][1] & @TAB & $Data[$a][2] & @TAB & $Data[$a][3] & @CRLF)
	Next
	GUISetState()

	Do
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($printhandle)
				$printhandle = ""
				ExitLoop
			Case $printcancelhandle
				KeyTap(@ScriptLineNumber)
				GUIDelete($printhandle)
				$printhandle = ""
				ExitLoop
			Case $printprinthandle
				KeyTap(@ScriptLineNumber)
				;;_WordDocPrint ( ByRef $o_object [, $b_Background = 0 [, $i_Copies = 1 [, $i_Orientation = -1 [, $b_Collate = 1 [, $s_Printer = "" [, $i_Range = 0 [, $i_From = "" [, $i_To = "" [, $s_Pages = "" [, $i_PageType = 0 [, $i_Item = 0]]]]]]]]]]] )
				_WordDocPrint($printEditHandle, 0, 1, -1, 1, "", 0, "", "", "", 0, 0)
		EndSwitch
	Until $GUI_EVENT_CLOSE
EndFunc   ;==>Print

Func RefreshListView()

	_ArraySort($Data, 0, 0, 0, GUICtrlGetState($ListViewHandle)) ; Sort the array
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListViewHandle)) ; Delete the current content
	_GUICtrlListView_AddArray($ListViewHandle, $Data) ; Add the sorted content

EndFunc   ;==>RefreshListView


Func WriteArrayToFile()
	Dim $TempArray[$ArraySize + 1]

	For $a = 0 To $ArraySize
		$TempArray[$a] = $Data[$a][0] & "*" & $Data[$a][1] & "*" & $Data[$a][2] & "*" & $Data[$a][3]
	Next
	_FileWriteFromArray($DataFileName, $TempArray, 1, 0)

EndFunc   ;==>WriteArrayToFile