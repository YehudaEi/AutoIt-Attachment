#include <Constants.au3>
#include <A3LMenu.au3>
#include <A3LToolbar.au3>
#include "ScB_Coords.au3"

Const $sScriptName = StringTrimRight(@ScriptName, 4)
Const $sVersionNum = "0.0.0.4" ; Release.Patch
Const $sScriptNameVersion = $sScriptName & " (" & $sVersionNum & ")"

Const $Icon_Default = 3 ; Number of icons AutoIt adds to .exe
if @Compiled Then ; Icons are added to .EXE file
	Enum $nIconClosed = $Icon_Default, $nIconN, $nIconNE, $nIconE, $nIconSE, $nIconS, $nIconSW, $nIconW, $nIconNW, $nIconCrossed
Else
	Const $nIconClosed = StringTrimRight(@ScriptFullPath, 4) & " - EyesClosed.ico"
	Const $nIconN = StringTrimRight(@ScriptFullPath, 4) & " - EyesN.ico"
	Const $nIconNE = StringTrimRight(@ScriptFullPath, 4) & " - EyesNE.ico"
	Const $nIconE = StringTrimRight(@ScriptFullPath, 4) & " - EyesE.ico"
	Const $nIconSE = StringTrimRight(@ScriptFullPath, 4) & " - EyesSE.ico"
	Const $nIconS = StringTrimRight(@ScriptFullPath, 4) & " - EyesS.ico"
	Const $nIconSW = StringTrimRight(@ScriptFullPath, 4) & " - EyesSW.ico"
	Const $nIconW = StringTrimRight(@ScriptFullPath, 4) & " - EyesW.ico"
	Const $nIconNW = StringTrimRight(@ScriptFullPath, 4) & " - EyesNW.ico"
	Const $nIconCrossed = StringTrimRight(@ScriptFullPath, 4) & " - EyesCrossed.ico"
EndIf
dim $vIconDirections[10] = [$nIconClosed, $nIconN, $nIconNE, $nIconE, $nIconSE, $nIconS, $nIconSW, $nIconW, $nIconNW, $nIconCrossed]
dim $nIconCurrent = -1, $nIconNext
dim $nIconPoint[2], $nMousePoint[2]
Const $nCheckIconPos = 30 ; check icon position (which can changeover time) - but only check it every 'n' time round the loop
Dim $nCheckIconCount = 0 ; keep track of when last checked the icon position

$fLogFile = -1
$bLogging = False
$sLastTitle = ""
$sTag = ""
$nIconPoint  = GetIconCentre()

$hActive = TrayCreateItem("Active")
TrayCreateItem("")
$hExit = TrayCreateItem("Exit")
AutoItSetOption("TrayMenuMode", 1)	
TraySetState(1)
AutoItWinSetTitle($sScriptNameVersion)
TraySetToolTip($sScriptNameVersion)
MoveEyes(False)

$sLogMsg = "Do you want to log the results to " & StringTrimRight(@ScriptName, 3) & "txt?"
$nResponse = MsgBox(3 + 32 + 256, "Log results", $sLogMsg, 10)
Switch $nResponse
	case 2 ; Cancel
		Exit
	case 6 ; Yes (log results)
		if FileExists( StringTrimRight(@ScriptFullPath, 3) & "txt") Then
			$sLogMsg = StringTrimRight(@ScriptName, 3) & "txt already exists - overwrite [Yes] or Append [No]?"
			$nResponse = MsgBox(3 + 32 + 256, "Overwrite file", $sLogMsg, 10)
			Switch $nResponse
				case 2 ; Cancel
					Exit
				case 6 ; Yes (overwrite)
					FileDelete(StringTrimRight(@ScriptFullPath, 3) & "txt")
			EndSwitch
		EndIf
		$fLogFile = FileOpen(StringTrimRight(@ScriptFullPath, 3) & "txt", 1)
EndSwitch

while 1
	$nMsg = TrayGetMsg()
	Select
		case $nMsg = $hActive
			$bLogging = not $bLogging
			if $bLogging Then
				TrayItemSetState($hActive, $TRAY_CHECKED)
				if $fLogFile <> -1 Then $sTag = InputBox("Tag records", "Enter description for this logging session", "", "", Default, Default, Default, Default, 20)
				if $sTag <> "" Then
					AutoItWinSetTitle($sScriptName & " - " & $sTag)
					TraySetToolTip($sScriptName & " - " & $sTag)
				EndIf
				MoveEyes()
			Else
				TrayItemSetState($hActive, $TRAY_UNCHECKED)
				AutoItWinSetTitle($sScriptNameVersion)
				TraySetToolTip($sScriptNameVersion)
				MoveEyes(False)
			EndIf
			$sLastTitle = ""
		case $nMsg = $hExit
			WriteEvent($sTag)
			ExitLoop
		case Else
			WriteEvent($sTag)
			MoveEyes()
	EndSelect
WEnd

if $fLogFile <> -1 Then FileClose($fLogFile)
	
Exit

; ===============================================================================================================================
; Description ...: If logging, and window title has changed, write records to file/console etc.
; Parameters ....: $sMsg - additional, descriptive text to write in addition to date/time and window info
; Return values .: 
; Author ........: Steve Bateman (MisterBates)
; Remarks .......: 
; Related .......: 
; ===============================================================================================================================
Func WriteEvent($sMsg="")
	$sWindowTitle = WinGetTitle("")
	if $bLogging and $sLastTitle <> $sWindowTitle Then
		$sEventInfo = @YEAR & @MON & @MDAY & @TAB & @HOUR & @MIN & @SEC
		if $sMsg <> "" then $sEventInfo &= @TAB & $sMsg
		$sEventInfo &= @TAB & $sWindowTitle & @crlf
		ConsoleWrite($sEventInfo)
		if $fLogFile <> -1 Then FileWrite($fLogFile, $sEventInfo)
	EndIf
	$sLastTitle = $sWindowTitle
EndFunc

; ===============================================================================================================================
; Description ...: Calculate where mouse is, which icon should be showing, and change if needed
; Parameters ....: $bEyesActive - If false, turns moving eyes off. If true, eyes are updated if currently tracking windows
; Return values .: 
; Author ........: Steve Bateman (MisterBates)
; Remarks .......: 
; Related .......: 
; ===============================================================================================================================
Func MoveEyes($bEyesActive = True)
	if Not $bEyesActive Then ; Eyes should not be active - switch to centred eyes
		$nIconNext = 0 ; Centred
	Elseif $bLogging Then ; Eyes should be active, move them if we are logging ...
		; Find mouse position
		$nNewMousePoint = MouseGetPos()
		$nDelta = _Coord_PointsToPolar($nMousePoint, $nNewMousePoint)
		if $nDelta[0] > 5 Then ; Only update the icon if the mouse moved enough to matter
			$nMousePoint = $nNewMousePoint
			; Find icon position - once every few times round the loop
			if mod($nCheckIconCount, $nCheckIconPos) = 0 Then $nIconPoint  = GetIconCentre()
			$nCheckIconCount += 1
			; Calculate which way the eyes should be looking and switch to the appropriate icon
			$aDistanceBearing = _Coord_PointsToPolar($nIconPoint, $nMousePoint)
			if $aDistanceBearing[0] <= 7 Then ; Mouse is over the icon
				$nIconNext = 9
			Else
				Switch $aDistanceBearing[1] ; Work on arc with compass point at centre
					Case 0 to 22.5
						$nIconNext = 3 ; E
					case 22.5 to 67.5
						$nIconNext = 2 ; NE
					Case 67.5 to 112.5
						$nIconNext = 1 ; N
					Case 112.5 to 157.5
						$nIconNext = 8 ; NW
					Case 157.5 to 202.5
						$nIconNext = 7 ; W
					Case 202.5 to 247.5
						$nIconNext = 6 ; SW
					Case 247.5 to 295.5
						$nIconNext = 5 ; S
					Case 295.5 to 337.5
						$nIconNext = 4 ; SE
					Case 337.5 to 360
						$nIconNext = 3 ; E
					case Else
						$nIconNext = 0 ; huh! should not happen
				EndSwitch
			EndIf
		EndIf
	EndIf
	if $nIconNext <> $nIconCurrent Then
		if IsNumber($vIconDirections[$nIconNext]) then
			TraySetIcon(@ScriptFullPath, $vIconDirections[$nIconNext])
		Else
			TraySetIcon($vIconDirections[$nIconNext])
		EndIf
		$nIconCurrent = $nIconNext
	EndIf
EndFunc
; ===============================================================================================================================
; Description ...: Find the centre of the "WatchWindows" taskbar icon
; Parameters ....: 
; Return values .: Point representing icon centre [x, y]
; Author ........: Steve Bateman (MisterBates)
; Remarks .......: If icon position cannot be determined, returns centre of taskbar icon area
; Related .......: 
; ===============================================================================================================================
Func GetIconCentre()
	; Find the taskbar icon area
	$hWnd   = ControlGetHandle("[CLASS:Shell_TrayWnd]", "", "Notification Area")
	$nWndPos = ControlGetPos("[CLASS:Shell_TrayWnd]", "", "Notification Area")
	$nCount = _Toolbar_ButtonCount($hWnd)
	local $nIconPos = 0
	; Find the icon within the taskbar icon area
	For $nIconNo = 0 to $nCount - 1
		$nCommand = _Toolbar_IndexToCommand($hWnd, $nIconNo)
		$sText    = _Toolbar_GetButtonText ($hWnd, $nCommand)
		If StringInStr($sText, $sScriptName) Then
			$nIconPos = _Toolbar_GetItemRect($hWnd, $nIconNo)
			ExitLoop
		Endif
	Next
  ; Icon position is relative to taskbar icon area - adjust
	if IsArray($nIconPos) Then
		For $iI = 0 to 1
			$nIconPos[$iI] += $nWndPos[$iI]
		Next
	Else ; Didn't find taskbar icon, return taskbar icon area
		$nIconPos = $nWndPos
	EndIf
	$aIconCentre = _Coord_RectCentre($nIconPos)
	Return $aIconCentre
EndFunc