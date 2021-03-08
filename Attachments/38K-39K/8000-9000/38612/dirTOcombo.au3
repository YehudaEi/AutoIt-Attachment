#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <GuiComboBox.au3>
#include <File.au3>

; =============================================================================
; just for this example create some directories inside TEMP dir

$ScannedDir = @TempDir & "\test\"
$constatnString = "Country"

DirCreate ($ScannedDir & "City1_" & $constatnString & "_some_other_strings")
DirCreate ($ScannedDir & "City2_" & $constatnString & "_some_other_strings")
DirCreate ($ScannedDir & "City3_" & $constatnString & "_some_other_strings")
DirCreate ($ScannedDir & "City4_City5_" & $constatnString & "_some_other_strings")
DirCreate ($ScannedDir & "City6_City7_City8_City9_" & $constatnString & "_some_other_strings")

; =============================================================================
; create GUI with Combobox

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Demo", 600, 107, 197, 133)
$Combo1 = GUICtrlCreateCombo("", 24, 16, 241, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$Label1 = GUICtrlCreateLabel("Path:", 24, 64, 34, 20)
$Label2 = GUICtrlCreateLabel("", 64, 64, 521, 20)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_DirScan($ScannedDir)
DirRemove ($ScannedDir, 1)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Combo1
			_ShowPath(GUICtrlRead ($Combo1))
	EndSwitch
WEnd


; =============================================================================
; create array with directory list

Func _DirScan($DirSelected)
	Local $FileList, $sString

	; read directories into 1D array (for temporary use)
	$DirListTMP = _FileListToArray($DirSelected & "\", "*", 2)
	If @error Then
		MsgBox(0, "Error", "No Directories Found.")
    Else

		; convert 1D array into 2D (add short name into Col 0 and put original dir name into Col 1)
		Global $DirList2D[$DirListTMP[0]][2]

		For $A = 1 To $DirListTMP[0]
			$DirList2D[$A-1][0] = StringLeft ($DirListTMP[$A], StringInStr($DirListTMP[$A], "_")-1)
			$DirList2D[$A-1][1] = $DirListTMP[$A]
		Next

		; extract short name from 2D array (Col 0) and convert it for combo box use
		For $B = 1 To UBound($DirList2D)
			$sFile = $DirList2D[$B-1][0]
			If @error = 0 Then
				$sString &= $sFile & "|"
			EndIf
		Next

		GUICtrlSetData($Combo1, "|" & $sString)

		_GUICtrlComboBox_SetEditText($Combo1, "Please select:")
	EndIf

	;_ArrayDisplay($DirList2D, "List")

EndFunc

; =============================================================================
; return path baseon combobox selection

Func _ShowPath($ComboSelection)

	For $B = 1 To UBound($DirList2D)
		If $DirList2D[$B-1][0] = $ComboSelection Then
			GUICtrlSetData($Label2, @TempDir & "\" & $DirList2D[$B-1][1] & "\")
			ExitLoop
		EndIf
	Next

EndFunc