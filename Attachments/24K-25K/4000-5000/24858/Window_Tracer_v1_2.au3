;===============================================================================
;
; Script Name:     Window Tracer
; Description:     Identify source process for visible windows
; Return Value(s): Message box displaying basic process information and opens
;                    an Explorer window for the source folder of the process
; Author(s):       Monamo
; Build:           1.2 - Updated to AutoIt code base of v3.3.0.0
; AutoIt:          v3.3.0.0
;
;===============================================================================
;

#NoTrayIcon
#Region;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
AutoItSetOption("GUIOnEventMode", 1)

Global $aVisibleWindows[1] = ["0"]
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20

$GUITitle = "Window Tracer"
$GUIWidth = 400
$GUIHeight = 50

$GUI = GUICreate($GUITitle, $GUIWidth, $GUIHeight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2)
$comboWindows = GUICtrlCreateCombo("", 10, 10, $GUIWidth - 20, 20, $CBS_DROPDOWNLIST)

_GetWindows()
GUISetState()

#Region Events list
GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitIt")
GUICtrlSetOnEvent($comboWindows, "_ProcessTrace")
#EndRegion Events list

While 1
	Sleep(10)
WEnd

#Region Functions
Func _ExitIt()
	Exit
EndFunc

Func _ProcessTrace()
	$sWinTitle = GUICtrlRead($comboWindows)

	If $sWinTitle = "" Or $sWinTitle = "<No Data>" Then Return

	$aWindow = WinList($sWinTitle)
	$iPID = WinGetProcess($sWinTitle)
	Dim $sProcessName

	$aProcesses = ProcessList()

	For $i = 1 To $aProcesses[0][0]
		If $aProcesses[$i][1] = $iPID Then
			$sProcessName = $aProcesses[$i][0]
			ExitLoop
		EndIf
	Next
	If $sProcessName <> "" Then
		$sProcessPath = _ProcessPath($iPID)
		$sFolder = ""
		$sMsg = "Window title:" & @CRLF & "   " & $sWinTitle & @CRLF
		$sMsg &= @CRLF
		$sMsg &= "Process: " & $sProcessName & @CRLF
		$sMsg &= "Process ID: " & $iPID & @CRLF
		$sMsg &= "Process location: " & $sProcessPath & @CRLF
		If FileExists($sProcessPath) Then
			$sFolder = StringTrimRight($sProcessPath, StringLen($sProcessPath) - StringInStr($sProcessPath, "\", 0, -1))
			$sMsg &= "Process folder: " & $sFolder & @CRLF
			ShellExecute($sFolder, "", $sFolder)
		EndIf
		MsgBox(8192 + 64, $sProcessName, $sMsg)
	Else
		$sMsg = "No matches found. Unable to determine source process for window title: " & @CRLF & "   " & $sWinTitle
		$sMsg &= @CRLF & @CRLF &"Please verify that the target window is still running."
		MsgBox(8192 + 48, $sProcessName,  $sMsg)
	EndIf
EndFunc

Func _GetWindows()
	$AllWindows = WinList()
	$sTmp = ""
	For $i = 1 To $AllWindows[0][0]
		If IsVisible($AllWindows[$i][1]) Then
			If $AllWindows[$i][0] <> "" And $AllWindows[$i][0] <> "Program Manager" Then
				$iIndex = $aVisibleWindows[0] + 1
				ReDim $aVisibleWindows[$iIndex + 1]
				$aVisibleWindows[0] = $iIndex
				$aVisibleWindows[$iIndex] = $AllWindows[$i][0]
				If $sTmp = "" Then
					$sTmp &= $aVisibleWindows[$iIndex]
				Else
					$sTmp &= "|" & $aVisibleWindows[$iIndex]
				EndIf
			EndIf
		Else
		EndIf
	Next
	If $sTmp <> "" Then
		GUICtrlSetData($comboWindows, $sTmp)
	Else
		GUICtrlSetData($comboWindows, "<No Data>")
	EndIf
EndFunc

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 4) Then
		If BitAND(WinGetState($handle), 2) Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
EndFunc

Func _ProcessPath($iCheckPID)
	$strComputer = "."
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			$sProcessPID = $objItem.ProcessId
			If $sProcessPID = $iCheckPID Then
				$sProcessPath = $objItem.ExecutablePath
				ExitLoop
			EndIf
		Next
	EndIf
	If $sProcessPath <> "" Then Return $sProcessPath
EndFunc