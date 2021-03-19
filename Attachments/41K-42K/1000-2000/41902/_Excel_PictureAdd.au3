#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include <Excel Rewrite.au3>
#include <Constants.au3>

; Create application object and open an example workbook
Global $oAppl = _Excel_Open()
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example", "Error creating the Excel application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
; Create new Workbook
Global $oWorkbook = _Excel_BookNew($oAppl)
If @error <> 0 Then
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example", "Error creating workbook." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	_Excel_Close($oAppl)
	Exit
EndIf

Example1($oWorkbook)
Example2($oWorkbook)
Example3($oWorkbook)
Example4($oWorkbook)

Exit

; *****************************************************************************
; Example 1
; Insert and resize the picture into a range of cells. Aspect ratio retained
; *****************************************************************************
Func Example1($oWorkbook)
	_Excel_PictureAddEX($oWorkbook, Default, @ScriptDir & "\_Excel.jpg", "B2:D8")
	If @error <> 0 Then Return MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 1", "Error inserting picture." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 1", "Picture inserted/resized at 'B2:D8', aspect ratio retained.")
EndFunc   ;==>Example1

; *****************************************************************************
; Example 2
; Insert the picture without resizing.
; *****************************************************************************
Func Example2($oWorkbook)
	_Excel_PictureAddEX($oWorkbook, Default, @ScriptDir & "\_Excel.jpg", "F1")
	If @error <> 0 Then Return MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 2", "Error inserting picture." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 2", "Picture inserted at 'F1' without resizing.")
EndFunc   ;==>Example2

; *****************************************************************************
; Example 3
; Insert the picture with a defined size/height.
; *****************************************************************************
Func Example3($oWorkbook)
	_Excel_PictureAddEX($oWorkbook, Default, @ScriptDir & "\_Excel.jpg", "A8", Default, 300, 250)
	If @error <> 0 Then Return MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 3", "Error inserting picture." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 3", "Picture inserted at 'A8' with defined size/height, aspect ratio ignored")
EndFunc   ;==>Example3

; *****************************************************************************
; Example 4
; Insert the picture with a defined size/height.
; *****************************************************************************
Func Example4($oWorkbook)
	_Excel_PictureAddEX($oWorkbook, Default, @ScriptDir & "\_Excel.jpg", 250, 300, 300, 250)
	If @error <> 0 Then Return MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 4", "Error inserting picture." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_PictureAddEX Example 4", "Picture inserted at position 250/300' with defined size/height, aspect ratio ignored")
EndFunc   ;==>Example4

; #FUNCTION# ====================================================================================================================
; Name...........: _Excel_PictureAddEX
; Description ...: Add a picture on the specified workbook and worksheet.
; Syntax.........: _Excel_PictureAddEX($oWorkbook, $vWorksheet, $sFile, $vRangeOrLeft[, $iTop, [$iWidth = Default, [$iHeight = Default, [$bScale = True]]]])
; Parameters ....: $oWorkbook    - Excel workbook object
;                  $vWorksheet   - Name, index or worksheet object to be written to. If set to keyword Default the active sheet will be used
;                  $sFile        - Full path to picture file being added
;                  $vRangeOrLeft - Either an A1 range, a range object or an integer denoting the left position of the pictures upper left corner
;                                  If multi-cell range is specified $iWidth and $iHeight will be ignored and will use the range width/height.
;                                  See the Remarks section for details
;                  $iTop         - Optional: If $vRangeOrLeft is an integer then $iTop is the top position of the pictures upper left corner.
;                  $iWidth       - Optional: If specified, sets the width of the picture. If not specified, width will adjust automatically (default = Automatic)
;                                  See the Remarks section for details
;                  $iHeight      - Optional: If specified, sets the height of the picture. If not specified, height will adjust automatically (default = Automatic)
;                                  See the Remarks section for details
;                  $bScale       - Only used if $vRangeOrLeft is a multi-cell range.
;                  |True will maintain image aspect ratio while staying within the bounds of $vRangeOrLeft.
;                  |False will fill the $vRangeOrLeft regardless of original aspect ratio.
;                  |(default = True)
; Return values .: Success - Returns a Shape object that represents the new picture
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oWorkbook is not an object or not a workbook object
;                  |2 - $vWorksheet name or index are invalid or $vWorksheet is not a worksheet object. @extended is set to the COM error code
;                  |3 - $vRangeOrLeft is invalid. @extended is set to the COM error code
;                  |4 - Error occurred when adding picture. @extended is set to the COM error code
;                  |5 - $sFile does not exist
; Author ........: DanWilli
; Modified.......: water
; Remarks .......: If $vRangeOrLeft is a multi cell range $iWidth and $iHeight will be ignored (to specify width/height not based on range width/height, specify a single cell $vRangeOrLeft)
;                  |
;                  If only one of $iWidth and $iHeight is specified, the other (set to default) will be scaled to maintain the original aspect ratio of the picture.
;                  If both $iWidth and $iHeight are specified, the picture will use the specified values regardless of original aspect ratio of the picture.
;                  If neither $iWidth nor $iHeight are specified, the picture will be auto sized to the size of the original picture.
;                  |
;                  $bScale will be ignored unless a multi cell range is specified (see Parameters for details)
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Excel_PictureAddEX($oWorkbook, $vWorksheet, $sFile, $vRangeOrLeft, $iTop = Default, $iWidth = Default, $iHeight = Default, $bScale = True)
	Local $Return, $iPosLeft, $iPosTop
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not FileExists($sFile) Then Return SetError(5, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If IsNumber($vRangeOrLeft) Then
		$iPosLeft = $vRangeOrLeft
		$iPosTop = $iTop
	Else
		If Not IsObj($vRangeOrLeft) Then
			$vRangeOrLeft = $vWorksheet.Range($vRangeOrLeft)
			If @error Or Not IsObj($vRangeOrLeft) Then Return SetError(3, @error, 0)
		EndIf
		$iPosLeft = $vRangeOrLeft.Left
		$iPosTop = $vRangeOrLeft.Top
	EndIf
	If IsNumber($vRangeOrLeft) Or ($vRangeOrLeft.Columns.Count = 1 And $vRangeOrLeft.Rows.Count = 1) Then
		If $iWidth = Default And $iHeight = Default Then
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$Return.Scalewidth(1, -1, 0)
			$Return.Scaleheight(1, -1, 0)
		ElseIf $iWidth = Default Then
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$Return.Visible = 0
			$Return.Scalewidth(1, -1, 0)
			$Return.Scaleheight(1, -1, 0)
			$Return.Scalewidth($iHeight / $Return.Height, -1, 0)
			$Return.Scaleheight($iHeight / $Return.Height, -1, 0)
			$Return.Visible = 1
		ElseIf $iHeight = Default Then
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$Return.Visible = 0
			$Return.Scalewidth(1, -1, 0)
			$Return.Scaleheight(1, -1, 0)
			$Return.Scaleheight($iWidth / $Return.Width, -1, 0)
			$Return.Scalewidth($iWidth / $Return.Width, -1, 0)
			$Return.Visible = 1
		Else
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, $iWidth, $iHeight)
			If @error Then Return SetError(4, @error, 0)
		EndIf
	Else
		If $bScale = True Then
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$Return.Visible = 0
			$Return.Scalewidth(1, -1, 0)
			$Return.Scaleheight(1, -1, 0)
			Local $iRw = $vRangeOrLeft.Width / $Return.Width
			Local $iRh = $vRangeOrLeft.Height / $Return.Height
			If $iRw < $iRh Then
				$Return.Scaleheight($iRw, -1, 0)
				$Return.Scalewidth($iRw, -1, 0)
			Else
				$Return.Scaleheight($iRh, -1, 0)
				$Return.Scalewidth($iRh, -1, 0)
			EndIf
			$Return.Visible = 1
		Else
			$Return = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, $vRangeOrLeft.Width, $vRangeOrLeft.Height)
			If @error Then Return SetError(4, @error, 0)
		EndIf
	EndIf
	Return $Return
EndFunc   ;==>_Excel_PictureAddEX
