;Spreadsheet Functions By Pieeater
;===============================================
;              Function List:                  *
;       _GUICtrlCreateSpreadsheet()            *
;       _GUICtrlDeleteSpreadsheet()            *
;       _GUICtrlGetSpreadsheetData()           *
;       _GUICtrlPopulateSpreadsheet()          *
;                                              *
;                                              *
;===============================================

#cs #FUNCTION# ====================================================================================================================
 Name...........: _GUICtrlCreateSpreadsheet()
 Description ...: Creates a bunch of input boxes which immatate a spreadsheet
 Syntax.........: _GUICtrlCreateSpreadsheet($cols, $rows, $left = 0, $top = 0, $width = 73, $height = 21, $flag = 0
 Parameters ....:
				$cols = how many colums you want the spreadsheet to be
				$rows = how many rows you want the spreadsheet to be
				$left, $top = Cordinates in your gui
				$width, $height = width and height of gui controls
				$flag = 0
					1st dimension of array is colums
				$flag = 1
					1st dimension of array is rows
 Returns........: a 2 dimensional array containing, depending on the flag, the control id's of the inputs created,
					$array[0][0] = how many colums
					$array[0][1] = how many rows
 Author ........: pieeater
 Remarks .......:
				the array returned has no data in the values $array[0][2] - $array[0][n] where n is how many rows/colums depending
				on the flag, i did things this way so that the array starts at $array[1][1] and can be more like a graph when finding
				the data sorry for the inconvienence but i dont know how to fix that part.
 Example .......: _GUICtrlCreateSpreadsheet(3, 10, 32, 26, 100, 21)
#ce ===============================================================================================================================
Func _GUICtrlCreateSpreadsheet($cols, $rows, $left = 0, $top = 0, $width = 73, $height = 21, $flag = 0)
	If $flag = 0 Then
		$rows += 1
		$cols += 1
		Local $array[$cols][$rows], $oTOP = $top ;$oTOP is used to hold the value of $top
		For $j = 1 To $cols - 1
			$top = $oTOP
			For $i = 1 To $rows - 1
				If $i = 1 Then
					$top = $height + $top
				Else
					$top += $height
				EndIf
				$array[$j][$i] = GUICtrlCreateInput("", $left, $top, $width, $height)
			Next
		$left += $width
		Next
		$array[0][0] = UBound($array)
		$array[0][1] = UBound($array, 2)
		Return $array
	ElseIf $flag = 1 Then
		$rows += 1
		$cols += 1
		Local $array[$rows][$cols], $oTOP = $top, $uLessVar = $rows ;uLessVar is used to hold the value of rows
		$rows = $cols              ;swap the values of $cols and $rows so that you dont have to swap anything
		$cols = $uLessVar          ;in the function, uses $uLessVar as the value for $cols
		For $j = 1 To $rows - 1
			$top = $oTOP
			For $i = 1 To $cols - 1
				If $i = 1 Then
					$top = $height + $top
				Else
					$top += $height
				EndIf
				$array[$j][$i] = GUICtrlCreateInput("", $left, $top, $width, $height)
			Next
		$left += $width
		Next
		$array[0][0] = UBound($array)
		$array[0][1] = UBound($array, 2)
		Return $array
	Else
		MsgBox(0, "Error", "Invalad $flag value")
	EndIf
EndFunc
#cs #FUNCTION# ====================================================================================================================
 Name...........: _GUICtrlDeleteSpreadsheet()
 Description ...: deletes a spreadsheet already created
 Syntax.........: _GUICtrlDeleteSpreadsheet($array)
 Parameters ....: $array = the control id of the spreadsheet data, since it uses multiple id's this function cuts time when deleting
					spreadsheets
 Returns........: 0 = Success
				  1 = non array variable
 Author ........: pieeater
 Remarks .......:
 Example .......: _GUICtrlDeleteSpreadsheet($sSheet1)
#ce ===============================================================================================================================
Func _GUICtrlDeleteSpreadsheet($array)
	If Not IsArray($array) Then
		MsgBox(0, "Error", "Target is ether not an array")
		Return 1
	Else
		For $j = 1 To $array[0][0] - 1
			For $i = 1 To $array[0][1] - 1
				GUICtrlDelete($array[$j][$i])
			Next
		Next
		Return 0
	EndIf
EndFunc
#cs #FUNCTION# ====================================================================================================================
 Name...........: _GUICtrlDeleteSpreadsheet()
 Description ...: deletes a spreadsheet already created
 Syntax.........: _GUICtrlDeleteSpreadsheet($array)
 Parameters ....: $array = the control id of the spreadsheet data, since it uses multiple id's this function cuts time when geting
					data from all spreadsheet colums/rows
 Returns........: array containing the data in every colum/row of the spreadsheet
				  1 = non array variable
 Author ........: pieeater
 Remarks .......:
 Example .......: _GUICtrlGetSpreadsheetData($sSheet1)
#ce ===============================================================================================================================
Func _GUICtrlGetSpreadsheetData($nArray)
	If Not IsArray($nArray) Then
		MsgBox(0, "Error", "Target is ether not an array")
		Return 1
	Else
		Local $array[$nArray[0][0]][$nArray[0][1]]
		For $j = 1 To $nArray[0][0] - 1
			For $i = 1 To $nArray[0][1] - 1
				$array[$j][$i] = GUICtrlRead($nArray[$j][$i])
			Next
		Next
		$array[0][0] = $nArray[0][0]
		$array[0][1] = $nArray[0][1]
		Return $array
	EndIf
EndFunc
#cs #FUNCTION# ====================================================================================================================
 Name...........: _GUICtrlPopulateSpreadsheet()
 Description ...: populates a spreadsheet, i use this for testing personally
 Syntax.........: _GUICtrlPopulateSpreadsheet($array)
 Parameters ....: $array = the control id of the spreadsheet data, since it uses multiple id's this function cuts time when populating
					spreadsheets
 Returns........: 1 = non array variable
 Author ........: pieeater
 Remarks .......:
 Example .......: _GUICtrlPopulateSpreadsheet($sSheet1)
#ce ===============================================================================================================================
Func _GUICtrlPopulateSpreadsheet($array)
	If Not IsArray($array) Then
		MsgBox(0, "Error", "Target is ether not an array")
		Return 1
	Else
		For $j = 1 To $array[0][0] - 1
			For $i = 1 To $array[0][1] - 1
				GUICtrlSetData($array[$j][$i], Chr(Random(0, 255, 1)))
			Next
		Next
	EndIf
EndFunc