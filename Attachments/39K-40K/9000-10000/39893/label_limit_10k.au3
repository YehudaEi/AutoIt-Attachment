; ==============================================================================================================================
;
; Program Name: OMNiViewer
;
; AutoIt Version:  3.3.8.1
; Language:        English
; Platform:        Win9x/NT
; Author:          JP Spampinato (jpspampinato@yahoo.com)
;
$version = "OMNiViewer 0.2a"
; ==============================================================================================================================

#region Includes, Variables
#include <Date.au3>
#include <GuiTab.au3>
#include <Timers.au3>
#include <Excel.au3>
#include <GuiScrollBars.au3>
#include <GUIScrollbars_Ex.au3>
#include <ScrollBarConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <StringSize.au3>

Opt('MustDeclareVars', 1)
Opt("GUICloseOnEsc", 0)
OnAutoItExitRegister("_FontCleanUp")

Global $ahFontEx[1] = [0]
Global $TabMainControl, $TabOperations, $TabTriggers, $TabReporting, $sTabNowDisplaying
Global $MenuFile, $MenuFileOpen, $MenuFileLoadLoginIDs, $MenuFileLoadSave, $MenuFileExit
Global $MenuView, $MenuViewDocking, $MenuViewDockingDocked, $MenuViewDockingSideSide, $MenuViewDockingTopBot, $MenuViewStatusbar
Global $MenuHelp, $MenuHelpAbout, $MenuHelpOMNi, $MenuHelpReleaseNotes
Global $EditLogWindow
Global $ButtonStampLog
Global $LabelStatusMain, $LabelStatusDest
Global $sStatusMessageMain = " Ready", $sStatusMessageDest = " Ready"
Global $stylesStatusbar = BitOR($SS_SIMPLE, $SS_SUNKEN), $stylesDestinationWindow = BitOR($WS_POPUP, $WS_CAPTION)
Global $Run = 0, $Dock = 1, $Dock_Location = 1, $msg, $x1, $x2, $y1, $y2 ; for the Docking() group of functions
Global $internalLabelID1, $internalLabelID2
Global $oExcel = 0, $sFile
Global $sSourceDirecory = "\\Desktop\OMNi\"

; why are we running out of resources? can't create the logging GUI if we add too many Skillsets ?
Global $dIntervalDateSetup = _NowCalcDate() & " 00:00:00"
Global $hMainWindow, $hDestinationWindow, $hFlexGrid, $hIntervalsColumn, $hSkillsetsRow
Global $intervalRowCount = 48, $intervalColumnCount = 1, $skillsetRowCount = 1, $skillsetColumnCount = 45
Global $countGridLabels = 0, $countIntervalLabels = 0, $countSkillsetLabels = 0, $countOtherLabels = 0, $totalLabels = 0, $countExtraLabel1 = 0
Global $cellWidth = 30, $cellHeight = 20, $penWeight = 1, $penColor
Global $cellLeftOffset = 8, $cellTopOffset = 8, $barThickness = 20
Global $heightMain = 720, $widthMain = 1280
Global $mainLeftOffset = 100, $mainTopOffset = 100
Global $heightDest = 720, $widthDest = 320
Global $heightFlexGrid = 560, $widthFlexGrid = 1000
Global $flexLeftOffset = $widthMain - $widthFlexGrid - $barThickness + 8, $flexTopOffset = $heightMain - $heightFlexGrid - ($barThickness * 2) - 8
Global $heightIntervals = $heightFlexGrid, $widthIntervals = ($cellWidth * 2) + 2
Global $intervalsLeftOffset = $flexLeftOffset - ($barThickness * 2) - 2, $intervalsTopOffset = $flexTopOffset
Global $heightSkillsets = $cellHeight * 5, $widthSkillsets = $widthFlexGrid
Global $skillsetsLeftOffset = $flexLeftOffset, $skillsetsTopOffset = $flexTopOffset - ($barThickness * 4) - 2
Global $heightFlexScrollbar = $intervalRowCount * ($cellHeight + 8), $widthFlexScrollbar = $skillsetColumnCount * ($cellWidth + 8)
Global $gridCellsContent[$intervalRowCount][$skillsetColumnCount], $tempGrid[1][1], $tempSkillsetContent[1][1]
Global $otherLabel1, $otherLabel2, $otherLabel3, $otherLabel4, $otherLabel5, $otherLabel6, $tempScroll1, $tempScroll2
Global $tempLabel1, $tempLabel2, $tempLabel3, $tempLabel4, $tempLabel5, $tempLabel6, $tempExtraLabel1
Global $tempMeasurements1, $tempMeasurements2, $tempMeasurements3, $tempMeasurements4
Global $tempMeasurements5, $tempMeasurements6, $tempMeasurements7, $tempMeasurements8
Global $tempMeasurements9, $tempMeasurements10, $tempMeasurements11, $tempMeasurements12
; why are we running out of resources? can't create the logging GUI if we add too many Skillsets ?
#endregion Includes, Variables

#region Setup GUI, Menus, Tabs, and Grid Definitions
$hMainWindow = GUICreate($version, $widthMain, $heightMain, $mainLeftOffset, $mainTopOffset)

#region Setup Menus
$MenuFile = GUICtrlCreateMenu("&File")
$MenuFileOpen = GUICtrlCreateMenuItem("Open...", $MenuFile)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
GUICtrlCreateMenuItem("", $MenuFile)
$MenuFileLoadLoginIDs = GUICtrlCreateMenuItem("Load LoginID data for all agents", $MenuFile)
GUICtrlCreateMenuItem("", $MenuFile)
$MenuFileLoadSave = GUICtrlCreateMenuItem("Save", $MenuFile)
GUICtrlSetState(-1, $GUI_DISABLE)
$MenuFileExit = GUICtrlCreateMenuItem("Exit", $MenuFile)

$MenuView = GUICtrlCreateMenu("&View")
$MenuViewDocking = GUICtrlCreateMenu("Docking", $MenuView)
$MenuViewDockingDocked = GUICtrlCreateMenuItem("Docked", $MenuViewDocking)
GUICtrlCreateMenuItem("", $MenuViewDocking)
$MenuViewDockingSideSide = GUICtrlCreateMenuItem("Side By Side", $MenuViewDocking)
$MenuViewDockingTopBot = GUICtrlCreateMenuItem("Top And Bottom", $MenuViewDocking)
GUICtrlSetState($MenuViewDockingDocked, $GUI_CHECKED)
GUICtrlSetState($MenuViewDockingSideSide, $GUI_CHECKED)
GUICtrlCreateMenuItem("", $MenuView)
$MenuViewStatusbar = GUICtrlCreateMenuItem("Statusbar", $MenuView)
GUICtrlSetState(-1, $GUI_CHECKED)

$MenuHelp = GUICtrlCreateMenu("&Help")
$MenuHelpOMNi = GUICtrlCreateMenuItem("Usage", $MenuHelp)
$MenuHelpReleaseNotes = GUICtrlCreateMenuItem("Release Notes", $MenuHelp)
GUICtrlCreateMenuItem("", $MenuHelp)
$MenuHelpAbout = GUICtrlCreateMenuItem("About " & $version, $MenuHelp)
$LabelStatusMain = GUICtrlCreateLabel($sStatusMessageMain, 0, $heightMain - 36, $widthMain, 16, $stylesStatusbar)
GUICtrlSetBkColor(-1, 0x80ff80)
GUICtrlSetState($LabelStatusMain, $GUI_SHOW)
#endregion Setup Menus

#region Setup Tabs
$TabMainControl = GUICtrlCreateTab(2, 2, $widthMain - 4, $heightMain - 20 - 20)

$TabOperations = GUICtrlCreateTabItem("Operational Grid")
_tempOperationsLabels()

$TabTriggers = GUICtrlCreateTabItem("Triggers")
_tempTriggersLabels()

$TabReporting = GUICtrlCreateTabItem("Reporting")
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW, $hMainWindow)
#endregion Setup Tabs

#region Setup Flex Grid
GUISwitch($hMainWindow, $TabOperations)
$hFlexGrid = GUICreate("", $widthFlexGrid, $heightFlexGrid, $flexLeftOffset, $flexTopOffset, $WS_POPUP, $WS_EX_MDICHILD, $hMainWindow)
_GUIScrollbars_Generate($hFlexGrid, $widthFlexScrollbar + $barThickness + $skillsetColumnCount, $heightFlexScrollbar + $barThickness + $intervalRowCount, True)
_InitializeIntervalGrid()
GUISetBkColor($COLOR_SILVER, $hFlexGrid)
GUISetState(@SW_SHOW, $hFlexGrid)

$hIntervalsColumn = GUICreate("", $widthIntervals, $heightIntervals, $intervalsLeftOffset, $intervalsTopOffset, $WS_POPUP, $WS_EX_MDICHILD, $hMainWindow)
_GUIScrollbars_Generate($hIntervalsColumn, 0, $heightFlexScrollbar + $barThickness + $intervalRowCount, True)
_CreateIntervalColumn()
GUISetBkColor($COLOR_SILVER, $hIntervalsColumn)
GUISetState(@SW_SHOW, $hIntervalsColumn)

$hSkillsetsRow = GUICreate("", $widthSkillsets, $heightSkillsets, $skillsetsLeftOffset, $skillsetsTopOffset, $WS_POPUP, $WS_EX_MDICHILD, $hMainWindow)
_GUIScrollbars_Generate($hSkillsetsRow, $widthFlexScrollbar + $barThickness + $skillsetColumnCount, 0, True)
_CreateSkillsetRow()
GUISetBkColor($COLOR_SILVER, $hSkillsetsRow)
GUISetState(@SW_SHOW, $hSkillsetsRow)
#endregion Setup Flex Grid

#region Setup Destination GUI
$hDestinationWindow = GUICreate("", $widthDest, $heightDest, $widthMain + $mainLeftOffset, $mainTopOffset, $stylesDestinationWindow)
$EditLogWindow = GUICtrlCreateEdit("", 2, 42, ($widthDest) - 6, $heightDest - 112, BitOR($WS_HSCROLL, $WS_VSCROLL))
$ButtonStampLog = GUICtrlCreateButton("Stamp Log", 70, $heightDest - 50, 100, 25)
$LabelStatusDest = GUICtrlCreateLabel($sStatusMessageDest, 0, $heightDest - 16, $widthDest, 16, $stylesStatusbar)
GUISetState(@SW_SHOW, $hDestinationWindow)
#endregion Setup Destination GUI
#endregion Setup GUI, Menus, Tabs, and Grid Definitions

#region Message Handlers
;~ GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND") ; Declare Command message handler
GUIRegisterMsg($WM_MOVE, "_WM_MOVE") ; Declare WindowIsMoving message handler
GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY") ; Declare Notify message handler
GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")
GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")
#endregion Message Handlers

#region Timers
_Timer_SetTimer($hMainWindow, 1000, "_UpdateStatusBarClock")
#endregion Timers

#region MAIN
; ==============================================================================================================================
;~ _LocateEveryTrackingWindow()
;~ _OpenDatabase()
;~ _LoadRulesets()
;~ _TestUpdateSpeed()
$Run = 1 ; Ready to run

While 1
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; How many labels are we going through? ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If $countGridLabels + $countSkillsetLabels + $countIntervalLabels + $countOtherLabels + $countExtraLabel1 <> $totalLabels Then
		GUICtrlSetData($tempLabel2, $countGridLabels)
		GUICtrlSetData($tempLabel3, $countSkillsetLabels)
		GUICtrlSetData($tempLabel4, $countIntervalLabels)
		GUICtrlSetData($tempLabel5, $countOtherLabels)
		$totalLabels = $countGridLabels + $countSkillsetLabels + $countIntervalLabels + $countOtherLabels + $countExtraLabel1
		GUICtrlSetData($tempLabel6, $totalLabels)
		GUICtrlSetData($tempExtraLabel1, $countExtraLabel1)
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; How many labels are we going through? ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	$msg = GUIGetMsg()
	Select
;~ 		Case $msg = $MenuFileLoadLoginIDs
;~ 			_LoadLoginIDs()
		Case $msg = $ButtonStampLog
			_WriteToLogWindow("(" & @HOUR & ":" & @MIN & ":" & @SEC & ") " & "Sample: Process Update123 completed")
		Case $msg = $TabMainControl
			$sTabNowDisplaying = _TabIsNowDisplaying()
			If ($sTabNowDisplaying = "Triggers" Or $sTabNowDisplaying = "Reporting") Then
				GUISetState(@SW_HIDE, $hFlexGrid)
				GUISetState(@SW_HIDE, $hIntervalsColumn)
				GUISetState(@SW_HIDE, $hSkillsetsRow)
			Else
				GUISetState(@SW_SHOW, $hFlexGrid)
				GUISetState(@SW_SHOW, $hIntervalsColumn)
				GUISetState(@SW_SHOW, $hSkillsetsRow)
			EndIf
		Case $msg = $MenuViewStatusbar
			_ToggleStatus()
		Case $msg = $MenuViewDockingDocked
			_SetDocking()
		Case $msg = $MenuViewDockingSideSide
			_SetDockSideBySide()
		Case $msg = $MenuViewDockingTopBot
			_SetDockTopAndBottom()
			;		Case $msg = $MenuHelpAbout
			;			_HelpAboutOMNiMonitor()
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $MenuFileExit
			ExitLoop
	EndSelect
	_WinAPI_SetWindowPos($hFlexGrid, $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
WEnd

GUIDelete()
_SaveAndExit()
#endregion MAIN

; ==============================================================================================================================
Func _InitializeIntervalGrid()
	For $c = 1 To $skillsetColumnCount
		For $r = 1 To $intervalRowCount
			$penWeight = Random(1, 2, 1)
			If Random() < 0.5 Then ; Format cells placeholders randomly distributed
				$penColor = $COLOR_RED
				If $penWeight = 1 Then
					If Random() < 0.5 Then
						$penColor = $COLOR_WHITE
					EndIf
				EndIf
			Else
				$penColor = $COLOR_GREEN
				If $penWeight = 1 Then
					If Random() < 0.5 Then
						$penColor = $COLOR_WHITE
					EndIf
				EndIf
			EndIf
;~ 			; Uncomment one of these to fill up the cells with placeholders
;~ 			$gridCellsContent[$r - 1][$c - 1] = Random(-9, 9, 1) & " " & Random(-9, 9, 1) ; actuals and deltas placeholder
;~ 			$gridCellsContent[$r - 1][$c - 1] = $c & " " & Random(-9, 9, 1) ; enumerate columns
;~ 			$gridCellsContent[$r - 1][$c - 1] = Random(-9, 9, 1) & " " & $r ; enumerate rows
			$gridCellsContent[$r - 1][$c - 1] = $r & " " & $c ; enumerate rows + columns
			_CreateBorderLabel($gridCellsContent[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset - 2, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset - 2, _
					$cellWidth + 4, $cellHeight + 4, $COLOR_MEDGRAY, 1, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countGridLabels += 2
			_CreateBorderLabel($gridCellsContent[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset, _
					$cellWidth, $cellHeight, $penColor, $penWeight, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countGridLabels += 2
		Next
	Next
EndFunc   ;==>_InitializeIntervalGrid

; ==============================================================================================================================
Func _CreateIntervalColumn()
	Local $tempRC = $intervalRowCount
	Local $tempCC = $intervalColumnCount
	ReDim $tempGrid[$tempRC][$tempCC]

	$penColor = $COLOR_BLACK
	$penWeight = 2

	For $c = 1 To $intervalColumnCount
		For $r = 1 To $intervalRowCount
			$tempGrid[$r - 1][$c - 1] = _DateTimeFormat($dIntervalDateSetup, 4) ; Interval placeholder
			$dIntervalDateSetup = _DateAdd('n', 30, $dIntervalDateSetup)
			_CreateBorderLabel($tempGrid[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset - 2, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset - 2, _
					$cellWidth + 4, ($cellHeight - 1) + 4, $COLOR_MEDGRAY, 1, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countIntervalLabels += 2
			_CreateBorderLabel($tempGrid[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset, _
					$cellWidth, ($cellHeight - 1), $penColor, $penWeight, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countIntervalLabels += 2
		Next
	Next
EndFunc   ;==>_CreateIntervalColumn

; ==============================================================================================================================
Func _CreateSkillsetRow()
	Local $tempRC = $skillsetRowCount
	Local $tempCC = $skillsetColumnCount
	ReDim $tempGrid[$tempRC][$tempCC]
	ReDim $tempSkillsetContent[$tempRC][$tempCC]
	$penColor = $COLOR_BLACK
	$penWeight = 2
	Local $tempSizeSkillset1 = "Skillset1", $aSizeSkillset
	$aSizeSkillset = _StringSize($tempSizeSkillset1, Default, Default, Default, Default, 200)

	______DebugPrint______("W: " & $cellWidth & " H: " & (($cellHeight - 3) * 4) & " L: " & $cellLeftOffset & " T: " & $cellTopOffset & " --- " & _
			"array0:" & $aSizeSkillset[0] & " array1:" & $aSizeSkillset[1] & " array2:" & $aSizeSkillset[2] & " array3:" & $aSizeSkillset[3])
	For $c = 1 To $skillsetColumnCount
		For $r = 1 To $skillsetRowCount
			$tempGrid[$r - 1][$c - 1] = "S" & $c
			_CreateBorderLabel($tempGrid[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset - 2, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset - 2, _
					$cellWidth + 4, (($cellHeight - 3) * 4) + 4, $COLOR_MEDGRAY, 1, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countSkillsetLabels += 2
			$tempSkillsetContent[$r - 1][$c - 1] = _CreateBorderLabel($tempGrid[$r - 1][$c - 1], _
					(($c - 1) * ($cellWidth + $cellLeftOffset)) + $cellLeftOffset, _
					(($r - 1) * ($cellHeight + $cellTopOffset)) + $cellTopOffset, _
					$cellWidth, (($cellHeight - 3) * 4), $penColor, $penWeight, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$countSkillsetLabels += 2
			GUICtrlSetData($tempSkillsetContent[$r - 1][$c - 1], "AB1234")
			_GuiCtrlSetFont($tempSkillsetContent[$r - 1][$c - 1], 15, 400, 0, ($c * 2))
		Next
	Next
EndFunc   ;==>_CreateSkillsetRow

; ==============================================================================================================================
Func _tempTriggersLabels()
	$otherLabel1 = _CreateBorderLabel("LABEL1", 30, 400, 100, 200, $COLOR_RED, 2)
	$countOtherLabels += 2
	$otherLabel2 = _CreateBorderLabel("LABEL2", 30, 550, 80, 20, $COLOR_BLUE, 2, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	$countOtherLabels += 2
	GUICtrlSetData($otherLabel1, "Label11")
	_GuiCtrlSetFont($otherLabel1, 15, 400, 0, 90)
	$otherLabel3 = GUICtrlCreateLabel("LABEL3", 30, 150, 80, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
	$countOtherLabels += 2
	;;;        									Left - Top - Width - Height
	$otherLabel4 = GUICtrlCreateLabel("1234567890", 30, 250, 140, 140, BitOR($WS_BORDER, $SS_RIGHT, $SS_CENTERIMAGE))
	GUICtrlSetData($otherLabel4, "abcdefghij")
	_GuiCtrlSetFont($otherLabel4, 15, 400, 0, 90)
	$otherLabel5 = GUICtrlCreateLabel("1234567890", 230, 250, 100, 100, BitOR($WS_BORDER, $SS_RIGHT, $SS_CENTERIMAGE))
	GUICtrlSetData($otherLabel5, "abcdefghij")
	_GuiCtrlSetFont($otherLabel5, 15, 400, 0, 90)
	$otherLabel6 = GUICtrlCreateLabel("12345", 430, 250, 100, 100, BitOR($WS_BORDER, $SS_RIGHT, $SS_CENTERIMAGE))
	GUICtrlSetData($otherLabel6, "abcde")
	_GuiCtrlSetFont($otherLabel6, 15, 400, 0, 90)
	$countOtherLabels += 2
EndFunc   ;==>_tempTriggersLabels

; ==============================================================================================================================
Func _tempOperationsLabels()
	GUICtrlCreateLabel("Grid GUI", 30, 80, 100, 20)
	GUICtrlCreateLabel("Width", 30, 100, 100, 20)
	$tempMeasurements1 = GUICtrlCreateLabel("", 120, 100, 100, 20)
	GUICtrlSetData($tempMeasurements1, $widthFlexGrid)
	GUICtrlCreateLabel("Height", 30, 115, 100, 20)
	$tempMeasurements2 = GUICtrlCreateLabel("", 120, 115, 100, 20)
	GUICtrlSetData($tempMeasurements2, $heightFlexGrid)
	GUICtrlCreateLabel("Top offset", 30, 130, 100, 20)
	$tempMeasurements3 = GUICtrlCreateLabel("", 120, 130, 100, 20)
	GUICtrlSetData($tempMeasurements3, $flexTopOffset)
	GUICtrlCreateLabel("Left offset", 30, 145, 100, 20)
	$tempMeasurements4 = GUICtrlCreateLabel("", 120, 145, 100, 20)
	GUICtrlSetData($tempMeasurements4, $flexLeftOffset)

	GUICtrlCreateLabel("Interval GUI", 30, 180, 100, 20)
	GUICtrlCreateLabel("Width", 30, 200, 100, 20)
	$tempMeasurements5 = GUICtrlCreateLabel("", 120, 200, 100, 20)
	GUICtrlSetData($tempMeasurements5, $widthIntervals)
	GUICtrlCreateLabel("Height", 30, 215, 100, 20)
	$tempMeasurements6 = GUICtrlCreateLabel("", 120, 215, 100, 20)
	GUICtrlSetData($tempMeasurements6, $heightIntervals)
	GUICtrlCreateLabel("Top offset", 30, 230, 100, 20)
	$tempMeasurements7 = GUICtrlCreateLabel("", 120, 230, 100, 20)
	GUICtrlSetData($tempMeasurements7, $intervalsTopOffset)
	GUICtrlCreateLabel("Left offset", 30, 245, 100, 20)
	$tempMeasurements8 = GUICtrlCreateLabel("", 120, 245, 100, 20)
	GUICtrlSetData($tempMeasurements8, $intervalsLeftOffset)

	GUICtrlCreateLabel("Skillset GUI", 30, 280, 100, 20)
	GUICtrlCreateLabel("Width", 30, 300, 100, 20)
	$tempMeasurements9 = GUICtrlCreateLabel("", 120, 300, 100, 20)
	GUICtrlSetData($tempMeasurements9, $widthSkillsets)
	GUICtrlCreateLabel("Height", 30, 315, 100, 20)
	$tempMeasurements10 = GUICtrlCreateLabel("", 120, 315, 100, 20)
	GUICtrlSetData($tempMeasurements10, $heightSkillsets)
	GUICtrlCreateLabel("Top offset", 30, 330, 100, 20)
	$tempMeasurements11 = GUICtrlCreateLabel("", 120, 330, 100, 20)
	GUICtrlSetData($tempMeasurements11, $skillsetsTopOffset)
	GUICtrlCreateLabel("Left offset", 30, 345, 100, 20)
	$tempMeasurements12 = GUICtrlCreateLabel("", 120, 345, 100, 20)
	GUICtrlSetData($tempMeasurements12, $skillsetsLeftOffset)

	GUICtrlCreateLabel("H-Scroll position", 30, 460, 100, 20)
	$tempScroll1 = GUICtrlCreateLabel("", 120, 460, 100, 20)
	GUICtrlCreateLabel("V-Scroll position", 30, 480, 100, 20)
	$tempScroll2 = GUICtrlCreateLabel("", 120, 480, 100, 20)
	GUICtrlCreateLabel("gridLabels", 30, 520, 100, 20)
	$tempLabel2 = GUICtrlCreateLabel("", 120, 520, 50, 20)
	GUICtrlCreateLabel("skillsetLabels", 30, 540, 100, 20)
	$tempLabel3 = GUICtrlCreateLabel("", 120, 540, 50, 20)
	GUICtrlCreateLabel("intervalLabels", 30, 560, 100, 20)
	$tempLabel4 = GUICtrlCreateLabel("", 120, 560, 50, 20)
	GUICtrlCreateLabel("otherLabels", 30, 580, 100, 20)
	$tempLabel5 = GUICtrlCreateLabel("", 120, 580, 50, 20)
	GUICtrlCreateLabel("totalLabels", 30, 600, 100, 20)
	$tempLabel6 = GUICtrlCreateLabel("", 120, 600, 50, 20)
	$countOtherLabels += 41

;~ 	;;; Uncomment this and increase the number of $skillsetColumnCount to 50 to exhaust resources
;~ 	$skillsetColumnCount = 50
;~ 	$widthFlexScrollbar = $skillsetColumnCount * ($cellWidth + 8)
;~ 	ReDim $gridCellsContent[$intervalRowCount][$skillsetColumnCount]
;~ 	GUICtrlCreateLabel("Extra Label", 30, 640, 100, 20)
;~ 	$tempExtraLabel1 = GUICtrlCreateLabel("", 120, 640, 100, 20)
;~ 	$countExtraLabel1 += 2
;~ 	GUICtrlSetData($tempExtraLabel1, $countExtraLabel1)
;~ 	;;; Uncomment this to increase the number of columns to 50 to exhaust resources

EndFunc   ;==>_tempOperationsLabels

; ==============================================================================================================================
Func _GuiCtrlSetFont($controlID, $size, $weight = 400, $attribute = 0, $rotation = 0, $fontname = "", $quality = 2)
	Local $fdwItalic = BitAND($attribute, 1)
	Local $fdwUnderline = BitAND($attribute, 2)
	Local $fdwStrikeOut = BitAND($attribute, 4)
	ReDim $ahFontEx[UBound($ahFontEx) + 1]

	$ahFontEx[0] += 1
	$ahFontEx[$ahFontEx[0]] = _WinAPI_CreateFont($size, 0, $rotation * 10, $rotation, $weight, _
			$fdwItalic, $fdwUnderline, $fdwStrikeOut, -1, 0, 0, $quality, 0, $fontname)
	GUICtrlSendMsg($controlID, 48, $ahFontEx[$ahFontEx[0]], 1)
EndFunc   ;==>_GuiCtrlSetFont

; ==============================================================================================================================
Func _FontCleanUp()
	For $i = 1 To $ahFontEx[0]
		_WinAPI_DeleteObject($ahFontEx[$i])
	Next
EndFunc   ;==>_FontCleanUp

; ==============================================================================================================================
Func _CreateBorderLabel($sText, $iX, $iY, $iW, $iH, $iColor, $iPenSize = 1, $iStyle = -1, $iStyleEx = 0)
	$internalLabelID1 = GUICtrlCreateLabel("", $iX - $iPenSize, $iY - $iPenSize, $iW + 2 * $iPenSize, $iH + 2 * $iPenSize, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, $iColor)
	GUICtrlSetState(-1, $GUI_SHOW)
	$internalLabelID2 = GUICtrlCreateLabel($sText, $iX, $iY, $iW, $iH, BitOR($SS_CENTER, $SS_CENTERIMAGE), $iStyleEx)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetState(-1, $GUI_SHOW)
	Return $internalLabelID2
EndFunc   ;==>_CreateBorderLabel

; ==============================================================================================================================
Func _TabIsNowDisplaying()
	Local $sTabSelected
	$sTabSelected = _GUICtrlTab_GetItemText($TabMainControl, _GUICtrlTab_GetCurSel($TabMainControl))
	;______DebugPrint______("Tab is now = " & $sTabSelected)
	Return $sTabSelected
EndFunc   ;==>_TabIsNowDisplaying

; ==============================================================================================================================
Func _TabSelectionIsChanging($sTabSelected)
	Sleep(0)
	;______DebugPrint______("Tab was = " & $sTabSelected)
EndFunc   ;==>_TabSelectionIsChanging

; ==============================================================================================================================
Func _WriteToLogWindow($sMessage)
	GUICtrlSetData($EditLogWindow, $sMessage & @CRLF, 1)
EndFunc   ;==>_WriteToLogWindow

; ==============================================================================================================================
Func ______DebugPrint______($s_text, $line = @ScriptLineNumber)
	; Usage:
	;______DebugPrint______("$variable= " & $variable)
	ConsoleWrite( _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>______DebugPrint______

; ==============================================================================================================================
Func _OpenFile()
	$sFile = FileOpenDialog("Choose file...", $sSourceDirecory, "All (*.*)")
	$oExcel = _ExcelBookOpen($sFile, 1)
	If @error = 1 Then
		MsgBox(0, "Error!", "Unable to Create the Excel Object")
		Exit
	ElseIf @error = 2 Then
		MsgBox(0, "Error!", "Unable to open the RollCall tracker!" & @CRLF & @CRLF & _
				"1. Close RollCall" & @CRLF & _
				"2. Save any open spreadsheets" & @CRLF & _
				"3. Restart RollCall")
		Exit
	EndIf
	GUICtrlSetState($MenuFileLoadSave, $GUI_DISABLE)
EndFunc   ;==>_OpenFile

; ==============================================================================================================================
Func _Save()
	_SetMainStatusBusyMessage("Saving...")
	_ExcelBookSave($oExcel) ; This method will Save without any prompts
	GUICtrlSetState($MenuFileLoadSave, $GUI_DISABLE)
	_SetMainStatusReadyMessage("Saved")
EndFunc   ;==>_Save

; ==============================================================================================================================
Func _SaveAndExit()
	_ExcelBookClose($oExcel, 1, 0) ; This method will Save and Exit without any prompts
EndFunc   ;==>_SaveAndExit

; ==============================================================================================================================
Func _SetDocking()
	If BitAND(GUICtrlRead($MenuViewDockingDocked), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($MenuViewDockingDocked, $GUI_UNCHECKED)
		$Dock = 0
	Else
		GUICtrlSetState($MenuViewDockingDocked, $GUI_CHECKED)
		$Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDocking

; ==============================================================================================================================
Func _SetDockSideBySide()
	If BitAND(GUICtrlRead($MenuViewDockingSideSide), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($MenuViewDockingSideSide, $GUI_UNCHECKED)
		GUICtrlSetState($MenuViewDockingTopBot, $GUI_CHECKED)
		$Dock_Location = 2
	Else
		GUICtrlSetState($MenuViewDockingSideSide, $GUI_CHECKED)
		GUICtrlSetState($MenuViewDockingTopBot, $GUI_UNCHECKED)
		$Dock_Location = 1
		If $Dock Then $Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockSideBySide

; ==============================================================================================================================
Func _SetDockTopAndBottom()
	If BitAND(GUICtrlRead($MenuViewDockingTopBot), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($MenuViewDockingTopBot, $GUI_UNCHECKED)
		GUICtrlSetState($MenuViewDockingSideSide, $GUI_CHECKED)
		$Dock_Location = 1
	Else
		GUICtrlSetState($MenuViewDockingTopBot, $GUI_CHECKED)
		GUICtrlSetState($MenuViewDockingSideSide, $GUI_UNCHECKED)
		$Dock_Location = 2
		If $Dock Then $Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockTopAndBottom

; ==============================================================================================================================
Func _KeepWindowsDocked()
	Local $p_win1 = WinGetPos($hMainWindow)
	Local $p_win2 = WinGetPos($hDestinationWindow)
	If $Dock_Location == 1 Then
		If (($p_win1[0] <> $x1 Or $p_win1[1] <> $y1) And BitAND(WinGetState($hMainWindow), 8) Or $Dock = 2) Then
			$x1 = $p_win1[0]
			$y1 = $p_win1[1]
			$x2 = $p_win1[2] + $x1
			$y2 = $y1
			WinMove($hDestinationWindow, "", $x2, $y2)
			$Dock = 1
		ElseIf (($p_win2[0] <> $x2 Or $p_win2[1] <> $y2) And BitAND(WinGetState($hDestinationWindow), 8)) Then
			$x2 = $p_win2[0]
			$y2 = $p_win2[1]
			$x1 = $p_win2[0] - $p_win1[2]
			$y1 = $y2
			WinMove($hMainWindow, "", $x1, $y1)
		EndIf
	Else
		If (($p_win1[0] <> $x1 Or $p_win1[1] <> $y1) And BitAND(WinGetState($hMainWindow), 8) Or $Dock = 2) Then
			$x1 = $p_win1[0]
			$y1 = $p_win1[1]
			$x2 = $x1
			$y2 = $p_win1[3] + $y1
			WinMove($hDestinationWindow, "", $x2, $y2)
			$Dock = 1
		ElseIf (($p_win2[0] <> $x2 Or $p_win2[1] <> $y2) And BitAND(WinGetState($hDestinationWindow), 8)) Then
			$x2 = $p_win2[0]
			$y2 = $p_win2[1]
			$x1 = $x2
			$y1 = $p_win2[1] - $p_win1[3]
			WinMove($hMainWindow, "", $x1, $y1)
		EndIf
	EndIf
EndFunc   ;==>_KeepWindowsDocked

; ==============================================================================================================================
Func _ToggleStatus()
	If BitAND(GUICtrlRead($MenuViewStatusbar), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($MenuViewStatusbar, $GUI_UNCHECKED)
		GUICtrlSetState($LabelStatusMain, $GUI_HIDE)
	Else
		GUICtrlSetState($MenuViewStatusbar, $GUI_CHECKED)
		GUICtrlSetState($LabelStatusMain, $GUI_SHOW)
	EndIf
EndFunc   ;==>_ToggleStatus

; ==============================================================================================================================
Func _SetMainStatusBusyMessage($tStatusMessageMain)
	GUICtrlSetData($LabelStatusMain, $tStatusMessageMain)
	GUICtrlSetBkColor($LabelStatusMain, 0xff0000)
	Return $sStatusMessageMain
EndFunc   ;==>_SetMainStatusBusyMessage

; ==============================================================================================================================
Func _SetDestStatusBusyMessage($tStatusMessageDest)
	GUICtrlSetData($LabelStatusDest, $tStatusMessageDest)
	GUICtrlSetBkColor($LabelStatusMain, 0xff0000)
	Return $sStatusMessageDest
EndFunc   ;==>_SetDestStatusBusyMessage

; ==============================================================================================================================
Func _SetMainStatusReadyMessage($tStatusMessageMain)
	GUICtrlSetData($LabelStatusMain, $tStatusMessageMain)
	GUICtrlSetBkColor($LabelStatusMain, 0x80ff80)
	Return $sStatusMessageMain
EndFunc   ;==>_SetMainStatusReadyMessage

; ==============================================================================================================================
Func _SetDestStatusReadyMessage($tStatusMessageDest)
	GUICtrlSetData($LabelStatusDest, $tStatusMessageDest)
	GUICtrlSetBkColor($LabelStatusDest, 0x80ff80)
	Return $sStatusMessageDest
EndFunc   ;==>_SetDestStatusReadyMessage

; ==============================================================================================================================
Func _WM_MOVE($hWnd, $iMsg, $iwParam, $ilParam)
	If ($hWnd = $hMainWindow Or $hWnd = $hDestinationWindow) Then
		If $Run = 1 And $Dock Then _KeepWindowsDocked()
	EndIf
EndFunc   ;==>_WM_MOVE

; ==============================================================================================================================
Func _WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $nNotifyCode, $nID
	$nNotifyCode = BitShift($iwParam, 16)
	$nID = BitAND($iwParam, 0xFFFF)
	Switch $nID
		Case 1 = 1
;~ 		Case $InputLogin, $InputName, $ComboStatus, $InputShift, $EditNotes
;~ 			;Turns on the button if any of the fields change
;~ 			;If $nNotifyCode = $EN_CHANGE Then GUICtrlSetData($nID, StringReplace(GUICtrlRead($nID), ".", ","))
;~ 			If $nNotifyCode = $EN_CHANGE Then GUICtrlSetState($ButtonEnterAgent, $GUI_ENABLE)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND

; ==============================================================================================================================
Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndTabControl, $tInfo
	$hWndTabControl = $TabMainControl
	If Not IsHWnd($TabMainControl) Then $hWndTabControl = GUICtrlGetHandle($TabMainControl)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndTabControl
			Switch $iCode
				Case $NM_CLICK
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					;______DebugPrint______("$NM_CLICK" & @TAB & _
					;		"IDFrom: " & $iIDFrom & @TAB & "Index: " & DllStructGetData($tInfo, "Index") & @TAB & _
					;		"SubItem: " & DllStructGetData($tInfo, "SubItem"))
				Case $TCN_SELCHANGING
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_TabSelectionIsChanging(_GUICtrlTab_GetItemText($hWndTabControl, _GUICtrlTab_GetCurSel($hWndTabControl)))
					;______DebugPrint______("$TCN_SELCHANGING" & @TAB & _
					;		"IDFrom: " & $iIDFrom & @TAB & "Index: " & DllStructGetData($tInfo, "Index") & @TAB & _
					;		"SubItem: " & DllStructGetData($tInfo, "SubItem"))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

; ==============================================================================================================================
Func WM_VSCROLL($hWnd, $msg, $wParam, $lParam)
	#forceref $Msg, $wParam, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $index = -1, $yChar, $yPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$yChar = $aSB_WindowInfo[$index][3]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0

	; Get all the vertial scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$yPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $yPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $nScrollCode
		Case $SB_TOP ; user clicked the HOME keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Min)

		Case $SB_BOTTOM ; user clicked the END keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Max)

		Case $SB_LINEUP ; user clicked the top arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)

		Case $SB_LINEDOWN ; user clicked the bottom arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)

		Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)

		Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

;~    // Set the position and then retrieve it.  Due to adjustments
;~    //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$Pos = DllStructGetData($tSCROLLINFO, "nPos")

	If ($Pos <> $yPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
		$yPos = $Pos
		GUICtrlSetData($tempScroll2, $Pos)
		_GUIScrollBars_SetScrollInfoPos($hIntervalsColumn, $SB_VERT, $Pos)
		;______DebugPrint______("V-scroll pos: " & $Pos)
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_VSCROLL

; ==============================================================================================================================
Func WM_HSCROLL($hWnd, $msg, $wParam, $lParam)
	#forceref $Msg, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)

	Local $index = -1, $xChar, $xPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$xChar = $aSB_WindowInfo[$index][2]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0

;~  ; Get all the horizontal scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_HORZ)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$xPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $xPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")
	#forceref $Min, $Max
	Switch $nScrollCode

		Case $SB_LINELEFT ; user clicked left arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)

		Case $SB_LINERIGHT ; user clicked right arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)

		Case $SB_PAGELEFT ; user clicked the scroll bar shaft left of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)

		Case $SB_PAGERIGHT ; user clicked the scroll bar shaft right of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

;~    // Set the position and then retrieve it.  Due to adjustments
;~    //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$Pos = DllStructGetData($tSCROLLINFO, "nPos")

	If ($Pos <> $xPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, $xChar * ($xPos - $Pos), 0)
		GUICtrlSetData($tempScroll1, $Pos)
		_GUIScrollBars_SetScrollInfoPos($hSkillsetsRow, $SB_HORZ, $Pos)
		;______DebugPrint______("H-scroll pos: " & $Pos)
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_HSCROLL

