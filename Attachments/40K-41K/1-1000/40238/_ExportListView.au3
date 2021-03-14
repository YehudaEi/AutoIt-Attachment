; #FUNCTION# ====================================================================================================================
; Name...........: _ExportListView
; Description ...: Exports data from a ListView to a CSV-file
; Syntax.........: _ExportListView($_ListView, $File_FullPath[, $sDelimiter = ";"])
; Parameters ....: $_ListView   	- ListView to export
;                  $File_FullPath   - Full Path and filename of the export file
;                  $sDelimiter		- [optional] Fieldseparator for CSV (default ;)
; Return values .: Success - nothing
;                  Failure - sets @error to:
;                  |1 - could not open export file for writing
; Author ........: GreenCan
; Modified.......:
; Remarks .......: The export will be done using the exact column order of the Listview
;					If a column was moved, the export will reflect the exact column order of the Listview
;                  Hidden Columns will not be exported
;					If a column has been hidden by setting the column width to 0, then the export will skip the column
; Related .......:
; Link ..........:
; Example .......: _ExportListView($ListView, @MyDocumentsDir & "\export.csv")
;                  If @error = 1 Then MsgBox(48, "Error", "Unable to create export file" & @CR & "Please verify if your last Excel export is still open!")
; ===============================================================================================================================
Func _ExportListView($_ListView, $File_FullPath, $sDelimiter = ";")
	Local $File_path = StringLeft($File_FullPath, StringInStr($File_FullPath, "\", 0, -1) - 1)
	Local $File_name = StringRight($File_FullPath, StringLen($File_FullPath) - StringInStr($File_FullPath, "\", 0, -1))
	ConsoleWrite($File_FullPath & " " & $File_path & " " & $File_name & @CR)
	Local $FileHandle = FileOpen($File_path & "\" & $File_name, 2)
	If $FileHandle = -1 Then  ; Check If file opened for writing OK
		Return SetError(1, 0, 0)
	EndIf
	ProgressOn("Exporting to " & $File_name, "", "", Default, Default, 16)
	ProgressSet(0, "Exporting")
	Local $To_Clip, $aItem
	Local $ColumnOrder = _GUICtrlListView_GetColumnOrderArray($_ListView) ; exact column order, required If the user changed the layout in the listview

	Local $To_Clip = ""
	; Column headers first
	; Set the titles according to column order as displayed in the ListView
	For $i_C = 0 To $ColumnOrder[0]
		; only export the column If width > 0
		If _GUICtrlListView_GetColumnWidth($_ListView, $ColumnOrder[$i_C]) > 0 Then
			$aItem = _GUICtrlListView_GetColumn($_ListView, $ColumnOrder[$i_C])
			$To_Clip = $To_Clip & StringStripWS($aItem[5], 3) & $sDelimiter
		EndIf
	Next
	FileWrite($FileHandle, StringTrimRight($To_Clip, 1) & @CRLF)

	Local $IRows = _GUICtrlListView_GetItemCount($_ListView) - 1
	For $i_I = 0 To $IRows
		; exact column Order
		$To_Clip = ""
		For $i_C = 0 To $ColumnOrder[0]
			$aItem = StringStripWS(_GUICtrlListView_GetItemText($_ListView, $i_I, $ColumnOrder[$i_C]), 3)
			If StringInStr($aItem, @LF) > 0 Then $aItem = Chr(34) & StringReplace($aItem, Chr(34), "'") & Chr(34) ;Replace all " by ' before putting the string between double quotes to avoid Excel conflicts
			; only export the column If width > 0
			If _GUICtrlListView_GetColumnWidth($_ListView, $ColumnOrder[$i_C]) > 0 Then
				If StringInStr($aItem, $sDelimiter) > 0 Then
					$To_Clip &= '"' & $aItem & '"' & $sDelimiter
				Else
					$To_Clip &= $aItem & $sDelimiter
				EndIf
			EndIf
		Next
		FileWrite($FileHandle, StringTrimRight($To_Clip, 1) & @CRLF)
		If Round(Int($i_I / $IRows * 10), 1) = Round($i_I / $IRows * 10, 1) Then ProgressSet($i_I / $IRows * 100, "Exporting to " & $File_name)
	Next
	FileClose($FileHandle)
	ProgressOff()
	Return
EndFunc ;==>_ExportListView