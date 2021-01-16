;~ scan all drives for autorun.inf

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=C:\Users\alexander\Documents\AutoIt\projects\AntiVir\Forms\autorun_editor.kxf
$Form1 = GUICreate("Autorun.inf Scanner // by AutoProgramming", 635, 444, 193, 125)
$Edit1 = GUICtrlCreateEdit("", 8, 40, 617, 393)
$CButton = GUICtrlCreateButton("Close", 8, 8, 75, 25, 0)
$IButton = GUICtrlCreateButton("Search for autorun.inf", 96, 8, 131, 25, 0)
GUICtrlSetState(-1,$GUI_FOCUS)
$RCheckbox = GUICtrlCreateCheckbox("Search Removable Drives?", 240, 16, 169, 17)
GUICtrlSetState(-1,$GUI_CHECKED)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $IButton
			GUICtrlSetData($Edit1, "")

			If GUICtrlRead($RCheckbox) = 1 Then
				GetAll("removable")
			EndIf

			GetAll("fixed")
			GetAll("cdrom")

		Case $CButton
			Exit

	EndSwitch
WEnd


GetAll("fixed")
GetAll("cdrom")

Func GetAll($type)
	$var = DriveGetDrive($type)
	If Not @error Then
		For $i = 1 To $var[0]
			GUICtrlAddData($Edit1, "--------------------------------------------------" & @CRLF)
			GUICtrlAddData($Edit1, " Analysing " & $var[$i] & "  ......" & @CRLF)
			
			$path = $var[$i] & "\autorun.inf"
			
			If FileExists($path) Then
				GUICtrlAddData($Edit1, "--------------------------------------------------" & @CRLF)
				GUICtrlAddData($Edit1, " Autorun.inf @ " & $path & @CRLF)
				GUICtrlAddData($Edit1, "--------------------------------------------------" & @CRLF)
				$autorun = FileRead($path)
				GUICtrlAddData($Edit1, $autorun)
				GUICtrlAddData($Edit1, @CRLF & @CRLF)
			Else
				GUICtrlAddData($Edit1, " Autorun Not Found  " & @CRLF)
				GUICtrlAddData($EDit1, _GetDriveStatus($var[$i]))
				GUICtrlAddData($Edit1, " --------------------------------------------------" & @CRLF)
			EndIf
			
			
				
		Next
	EndIf
EndFunc   ;==>GetAll

Func GUICtrlAddData($GUIElement, $Data)
	GUICtrlSetData($GUIElement, GUICtrlRead($GUIElement) & $Data)
EndFunc   ;==>GUICtrlAddData

Func _GetDriveStatus($Drive)
	Switch DriveStatus($Drive)
		Case "UNKNOWN"
			Return " Drive may be unformatted (RAW)." & @CRLF
		Case "READY"
			Return " "
		Case "NOTREADY"
			Return " Drive is not Ready / Media not inserted"& @CRLF
		Case "INVALID"
			Return " Drive letter does not exist or a mapped network drive is inaccessible"& @CRLF
	EndSwitch
EndFunc   ;==>_GetDriveStatus