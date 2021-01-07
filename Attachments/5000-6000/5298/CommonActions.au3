Func SQLite_ToGrid($s_DLL, $s_DBHandle, $s_GridControl, $s_SQL, byref $iRows, byref $iColumns, $s_SkipFirstRow = True,$s_StatusCtrl="")
	$iCharSize = 64
	
	$r = DllCall($s_DLL, "int", "sqlite3_get_table", "ptr", $s_DBHandle, "str", $s_SQL, "long_ptr", 0, "long_ptr", 0, "long_ptr", 0, "long_ptr", 0)  ; Error msg written here
	If @error =0 Then

		$pResult = $r[3]
		$iRows = $r[4]+1
		$iColumns = $r[5]
		$iResultSize = ($iRows) * ($iColumns)
			
		$struct1 = ""
		
		For $i = 1 To $iResultSize - 1
			$struct1 &= "ptr;"
		Next
		
		$struct1 &= "ptr"
		$struct2 = DllStructCreate($struct1, $pResult)
		
		if $irows > 0 and $icolumns > 0 then	
			Dim $aResult [$icolumns][$irows]
			
			$iCurRow = 0
			if $s_skipfirstrow = true Then
				$iCurCol = -1 * $icolumns
			Else
				$icurcol = 0
			EndIf
			
			$ExCol = ":" & ColumnIntConv($icolumns) & $irows
			$OfText = " of " & $irows
			
			guisetstate(@sw_unlock)
			guictrlsetdata($s_StatusCtrl,"Records to display " & $irows)
			
			ProgressOn("Putting Data in Excel Grid","This could be a while...","Sub Text",-1,-1,18)
			guisetstate(@sw_lock)
			For $i = 1 To $iResultSize
				if $iCurCol+1 > $icolumns Then
					$i_percent = ($icurrow/$irows)*100
					
					ProgressSet($i_percent,"Record: " & $icurrow & $OfText)
						
					$icurrow = $icurrow+1
					$iCurCol = 0
				EndIf
				
				if $icurcol >= 0 Then
					$aResult[$iCurCol][$icurrow] = DllStructGetData(DllStructCreate("char[256]", DllStructGetData($struct2, $i)), 1)
					;msgbox(0,"",$aResult[$iCurCol][$icurrow])
					;if $aResult[$iCurCol][0] = "" then 
					;	$aResult[$iCurCol][0] = " "
					if stringleft($aResult[$iCurCol][$icurrow],1) = "0" Then 
						$aResult[$iCurCol][$icurrow] = "'" & $aResult[$iCurCol][$icurrow]
					EndIf
				EndIf
					
				$iCurCol = $iCurCol+1
			Next
			
			$s_Gridcontrol.range("A1" & $ExCol).value = $aResult
			$s_Gridcontrol.range("A1" & $ExCol).numberformat = "general"
			Progressoff()
			
			for $HeaderCount = 1 to $icolumns
				$s_Gridcontrol.columns($HeaderCount).autofit
			Next
		EndIf
		If $r[0] = $SQLITE_OK Then
			$sErrorMsg = "Successful result"
		Else
			$sErrorMsg = DllStructGetData(DllStructCreate("char[" & $iCharSize & "]", $r[6]), 1)
			SetError(2) ; Sql Error
		EndIf
		DllCall($SQLiteWrapperGlobalVar_hDll, "none", "sqlite3_free_table", "ptr", $pResult) ; pointer to 'resultp' from sqlite3_get_table
		Return $r[0]

	EndIf
	
	
	
EndFunc


Func PutArrayToExcelObject($e_ExcelObject,$e_Array,$e_endrow,$e_StatusLabel)
	if $e_endrow > 0 Then
		;_displayarray($e_array)
		$e_EndCol = ubound($e_Array,1)-1
		
		dim $e_TempArray[$e_EndCol+1][$e_endrow]
		
		$e_String = " of " & $e_endrow
		
		for $y = 1 to $e_endrow
			guisetstate(@sw_unlock)
			guictrlsetdata($e_StatusLabel,"Row " & $y & $e_string)
			guisetstate(@sw_lock)
			for $x = 0 to $e_EndCol
			;	msgbox(0,$y,$y & ":" & $x)
				if $e_Array[$x][$y] ="" then $e_Array[$x][$y] = " "
				if stringleft($e_Array[$x][$y],1) = 0 then $e_Array[$x][$y] = "'" & $e_Array[$x][$y]
				$e_TempArray[$x][$y-1] = $e_Array[$x][$y]
			Next
		Next
		
		$e_Range = "A1:" & ColumnIntConv($e_EndCol+1) & $e_EndRow
		
		
		$e_ExcelObject.range($e_range).numberformat = "general"		
		$e_ExcelObject.range($e_range).value = $e_TempArray
		
		for $ColCOunt = 1 to $e_EndCol+1
			$e_ExcelObject.columns($colcount).autofit
		Next
	EndIf
EndFunc


Func GetFieldNames($f_DBHandle, $f_TableName)
	$f_SQL = "SELECT sql FROM sqlite_master WHERE tbl_name='" & $f_TableName &"'"
	;msgbox(0,"",$f_sql)
	dim $f_Rows
	dim $f_Cols
	dim $f_RawData[1][1]
	dim $f_ErrorMsg
	
	$f_Error = _SQLite_GetTable($f_dbhandle, $f_SQL, $f_rawdata, $f_Rows, $f_Cols, $f_ErrorMsg)
	

	if not isarray($f_RawData) Then
		return $f_Error & "|" & $f_ErrorMsg
	Else

		$f_Junk = stringinstr($f_rawdata[0][1],"(",1,1)
		$f_TempType = stringtrimleft($f_rawdata[0][1],$f_Junk)
		
		$f_TempArray = stringsplit($f_TempType,",")
		
		dim $f_Results[2][$f_TempArray[0]]
		
		;_displayarray($f_TempArray)
		
		for $f_Count = 1 to $f_TempArray[0]
			$f_Field = StringStripWS($f_temparray[$f_count],3)
			$f_Junk = stringinstr($f_Field," ",1,1)
			
			if $f_Junk = 0 Then
				$f_Results[0][$f_Count-1] = $f_field
			Else
				$f_Results[0][$f_Count-1] = StringLeft($f_field,$f_Junk)
				$f_Results[1][$f_Count-1]  = StringTrimLeft($f_field,$f_Junk)
			EndIf
			
			if $f_count = $f_temparray[0] Then
				if StringRight($f_Results[1][$f_Count-1], 1) = ")" Then 
					$f_Results[1][$f_Count-1] = StringTrimRight($f_Results[1][$f_Count-1], 1)
				EndIf
				if StringRight($f_Results[0][$f_Count-1], 1) = ")" Then 
					$f_Results[0][$f_Count-1] = StringTrimRight($f_Results[0][$f_Count-1], 1)
				EndIf				
			EndIf
			
		Next
		;_displayarray($f_Results)
		Return $f_Results

	EndIf
	
	
EndFunc


func GetTableNames($t_DBHandle)
	
	
	dim $t_Rows
	dim $t_Cols
	dim $t_ErrorMsg
	dim $t_RawData
	$t_SQL = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
	
	$t_Error = _SQLite_GetTable($t_DBHandle, $t_SQL, $t_RawData, $t_Rows, $t_Cols, $t_ErrorMsg, 256)
	
	if $t_Error <> 0 Then
		return $t_Error & "|" & $t_ErrorMsg
	Else
		;_displayarray($t_RawData)
		return $t_RawData		
	EndIf
	
EndFunc



Func ResetGrid($r_ExcelObject,byref $r_Cols,byref $r_Rows)
	if $r_rows > 0 then	 
		For $Headercount = 1 to $r_Cols
			$r_ExcelObject.activewindow.columnheadings($HeaderCount).caption = $headercount				
		Next
		
		if $r_rows = 0 Then $r_Rows = 1
		if $r_Cols =0 then $r_cols = 1
		
		$r_ExcelObject.ActiveSheet.Range("A1:" & ColumnIntConv($r_Cols) & $r_rows).Clear
		
	EndIf
EndFunc

func ColumnIntConv($String1)
    $String1 = number($String1)
	 
	If $String1 > 26 Then
		$FirstDigit = Chr(floor($String1 / 26) + 64) ;integer divide!!!
		$CharDivide = $String1 / 26
		If isint($CharDivide) and $chardivide < 10 Then
			$CharDivide = $CharDivide - 1
		Else
			$CharDivide = floor($String1 / 26)
		EndIf
		$SecondDigit = Chr($CharDivide * ($String1 / ($CharDivide) - 26) + 64)
		$ColumnIntConv = $FirstDigit & $SecondDigit
	ElseIf $String1 > 0 And $String1 < 27 Then
		
		$ColumnIntConv = chr($String1 + 64)
	Else
		$ColumnIntConv = $String1
	EndIf
	return $ColumnIntConv
EndFunc