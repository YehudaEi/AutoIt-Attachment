#include <File.au3>

; Commands
Dim $XL_OPEN = 0			; Open an Excel Application or a Workbook
Dim $XL_CLOSE = 1			; Close Excel Application or a Workbook
Dim $XL_WAITREADY = 2		; Wait until Application is Ready
Dim $XL_NEW = 3				; Create a New Workbook or Worksheet
Dim $XL_SAVE = 4			; Save an existing Workbook
Dim $XL_SAVEAS = 5			; Save an existing Workbook with a new name. Can be saved as a Text $FileFormat = $xlTextWINDOWS or as a CSV $FileFormat = $xlCSVMSDOS
Dim $XL_GETNAME = 6			; Get the name of the Workbook, WorkSheet
Dim $XL_ACTIVATE = 7		; Activate a WorkBook or Worksheet
Dim $XL_SETNAME = 8			; Set the name of a Worksheet or Range
Dim $XL_READVALUE = 9		; Get a Range Value
Dim $XL_WRITEVALUE = 10		; Set a Range Value
Dim $XL_GETADDRESS = 11		; Get a Range Address
Dim $XL_COLUMNWIDTH = 12	; Set the Column Width
Dim $XL_ROWHEIGHT = 13		; Set the Row Height
Dim $XL_AUTOFILTER = 14		; Switch Autofilter On an Off in a Range
Dim $XL_SELECT = 15			; Select a Range
Dim $XL_COPYTO = 16			; Copy a Selected Range to this new Range
Dim $XL_MOVETO = 17			; Move a Selected Range to this new Range
Dim $XL_DELETE = 18			; Delete a Range in a Worksheet
Dim $XL_INSERT = 19			; Insert a Range in a Worksheet
Dim $XL_VISIBLE = 20		; Set Visibility of Application
Dim $XL_LASTROW = 21		; Return the last cell downward parallel to "LastCell" and Current cell
Dim $Xl_LASTCOL = 22		; Return the rightmost cell parallel to "LastCell" and Current cell
Dim $XL_LASTCELL = 23		; Return the bottom most and right most non Empty Cell (LastCell)
Dim $XL_GETALLNAMES = 24	; Return all worksheets names (in _XLWSheet),  all workbooks names (in _XLWBook)

;Propertie Commands
Dim $XLP_FONTNAME = 1
Dim $XLP_FONTSIZE = 2
Dim $XLP_FONTSTRIKETHROUGH = 3
Dim $XLP_FONTSUPERSCRIPT = 4
Dim $XLP_FONTSUBSCRIPT = 5
Dim $XLP_FONTBOLD = 6
Dim $XLP_FONTITALIC = 7
Dim $XLP_BORDER = 8
Dim $XLP_BACKGROUND = 9
; Excel Constants
Dim $xlDown = -4121
Dim $xlToLeft = -4159
Dim $xlToRight = -4161
Dim $xlUp = -4162
Dim $xlShiftToLeft = -4159
Dim $xlShiftUp = -4162
Dim $xlCSVMSDOS = 24
Dim $xlTextWINDOWS = 20
Dim $xlWorkbookNormal = -4143
Dim $xlA1 = 1
Dim $xlR1C1 = -4150
Dim $xlCellTypeLastCell = 11

#cs
	@error = -7 Selection is not a Range
	@error = -6 Invalid FilName
	@error = -5 File not Saved
	@error = -4 Command Aborted or Invalid Parameter
	@error = -3 File not Found
	@error = -2 Cannot create object
	@error = -1	Invalid Command
	@error = 1	Invalid Application
	@error = 2	Invalid Workbook
	@error = 3	Invalid Worksheet
	@error = 4	Invalid Range
	@error = 5  Inconsistent Parameters
	@error = 6  Bad Excel Address
	@error = 7	No Row/Column In address
#ce

; Variables
Dim $o_xlApplication
Dim $f_xlUseActiveObject = True
Dim $f_IsFirstWorkbook = True
Dim $f_xlShowCOMError = True
Dim $n_xlCOMError = 0
Dim $s_RangeObjName = ""
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")    ; Initialize a COM error handler


;===============================================================================
;
; Function Name:	_XLApp()
; Description::    Operation with Excel Application Object
; Parameter(s):    $Op	- The Operation Command:
;
; Requirement(s):  	AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 	in _XL_OPEN Command Return the Application Ob0ject
;					@Error = 1 if the application cannot be created and return an empty String
;					@Error = 2 Application is not Opened
;					@Error = -1 if Invalid Operation Command
; Author(s):       GioVit 
;
;===============================================================================
;

Func _XLApp ($i_Op, $Param1 = True)
	SetError(0)
	Switch $i_Op
		Case $XL_VISIBLE
			if IsObj($o_xlApplication) Then
				$o_xlApplication.Visible = $Param1
			Else
				SetError(1)
			EndIf
		Case $XL_OPEN
			$o_xlApplication = ObjCreate("Excel.Application")
			if IsObj($o_xlApplication) Then
				$o_xlApplication.Visible = $Param1
				Return $o_xlApplication
			Else
				SetError(1)
				Return ""
			EndIf
		Case $XL_CLOSE
			if Not IsObj($o_xlApplication) Then
				SetError(2)
			Else
				if Not $Param1 Then
					$o_xlApplication.DisplayAlerts = False
				EndIf
				$o_xlApplication.Quit()
				$o_xlApplication = 0
			EndIf
		Case $XL_WAITREADY
			if Not IsObj($o_xlApplication) Then
				SetError(2)
			Else
				While Not $o_xlApplication.Ready
				WEnd
			EndIf
		Case Else
			SetError(-1)
	EndSwitch
EndFunc

;===============================================================================
;
; Function Name:   _XLWBook($Op, $o_Workbook, $s_Filename)
; Description::    Operation with Excel Workbook
; Parameter(s):    $Op	- The Operation Command:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 
; Author(s):       
;
;===============================================================================
;

Func _XLWBook($i_Op, $o_Workbook = "", $v_Param1 = "", $FileFormat = -4143)
	SetError(0)
	Switch $i_Op
		Case $XL_NEW
			$o_Workbook = $o_xlApplication.Workbooks.add()
			if IsObj($o_Workbook) Then
				if $f_IsFirstWorkbook Then
					$s_RangeObjName = ObjName($o_xlApplication.Selection)
					$IsFirstWorkbook = False
				EndIf
				Return $o_Workbook
			Else
				SetError(-2)
				Return ""
			EndIf

		Case $XL_OPEN
			if IsString($o_Workbook) Then
				if $o_Workbook <> "" Then
					if FileExists(GetFullPath($o_Workbook)) Then
						$o_Workbook = $o_xlApplication.Workbooks.Open($o_Workbook)
						if IsObj($o_Workbook) Then
							if $f_IsFirstWorkbook Then
								$s_RangeObjName = ObjName($o_xlApplication.Selection)
								$IsFirstWorkbook = False
							EndIf
						Else
							SetError(-2)
							$o_Workbook = ""
						EndIf
					EndIf
				EndIf
			Else
				SetError(3)
				$o_Workbook = ""
			EndIf
			Return $o_Workbook
		Case $XL_CLOSE
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				if IsString($v_Param1) Then
					$o_Workbook.Saved = True
					$o_Workbook.Close()
				ElseIf $v_Param1 = True Then
					$o_Workbook.Close($v_Param1)
				EndIf
			EndIf
		Case $XL_SAVE
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				if $o_Workbook.Path = "" Then
					;$o_Workbook.Path = @ScriptDir
					;SetExtended(2)
					if $o_Workbook.Path = "" Then
						if FileExists($o_xlApplication.DefaultFilePath & "\" & $o_Workbook.Name) Then
							MsgBox(16,"Error", "File " & $o_xlApplication.DefaultFilePath & "\" & $o_Workbook.Name & " already exists. Cannot save it")
							SetError(-5)
						Else
							$f_xlShowCOMError = False
							$o_xlApplication.DisplayAlerts = False
							$o_xlApplication.ScreenUpdating = False
							$o_Workbook.Save()
							$ErrCode = @error
							$o_xlApplication.DisplayAlerts = True
							$o_xlApplication.ScreenUpdating = True
							$f_xlShowCOMError = True
							if $ErrCode Then 
								SetError($n_xlCOMError)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Case $XL_SAVEAS
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				if FileExists($v_Param1) Then
					if $o_Workbook.FullName = $v_Param1 Then
						$o_Workbook.Save()
					Else
						if $FileFormat <> $xlCSVMSDOS or $FileFormat <> $xlWorkbookNormal or $FileFormat <> $xlTextWINDOWS Then
							SetError(-7)
						Else
							$o_xlApplication.DisplayAlerts = False
							$o_xlApplication.ScreenUpdating = False
							$f_xlShowCOMError = False
							$o_Workbook.SaveAs($v_Param1, $FileFormat)
							$ErrCode = @error
							$f_xlShowCOMError = True
							if $ErrCode Then 
								SetError($n_xlCOMError)
							EndIf
							$o_xlApplication.DisplayAlerts = True
							$o_xlApplication.ScreenUpdating = True
						EndIf
					EndIf
				EndIf
			EndIf
		Case $XL_GETNAME
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				Return $o_Workbook.Name
			EndIf
		Case $XL_ACTIVATE
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
				Return ""
			Else
				$o_Workbook.Activate()
				Return $o_Workbook
			EndIf
		Case $XL_GETALLNAMES
			if IsObj($o_xlApplication) Then
				if $o_xlApplication.Workbooks.Count > 0 Then
					Dim $Result[$o_xlApplication.Workbooks.Count]
					$i = 0
					For $workbook in $o_xlApplication.Workbooks
						$Result[$i] = $workbook.Name
						$i += 1
					Next
				Else
					$Result = ""
				EndIf
				Return $Result
			Else
				SetError(1)
			EndIf
		Case Else
			SetError(2)
	EndSwitch
EndFunc
			
Func GetValidWB(ByRef $o_Workbook)
Dim $workbook, $Curworkbook
	if IsObj($o_xlApplication) Then
		Select
			Case IsObj($o_Workbook)
			Case IsNumber($o_Workbook)
				if $o_xlApplication.Workbooks.Count < $o_Workbook or $o_Workbook <1 Then
					SetError(2)
				Else
					$o_Workbook = $o_xlApplication.Workbooks.Item($o_Workbook)
				EndIf
			Case IsString($o_Workbook)
				if $o_Workbook = "" Then
					$o_Workbook = $o_xlApplication.ActiveWorkbook
				Else
					$Curworkbook = 0
					For $workbook in $o_xlApplication.Workbooks
						if StringLower($workbook.Name) = StringLower($o_Workbook) Then
							$Curworkbook = $workbook
							ExitLoop
						EndIf
					Next
					if IsObj($Curworkbook) Then
						$o_Workbook = $Curworkbook
					Else
						SetError(2)
					EndIf
				EndIf
			Case Else
				SetError(2)
		EndSelect
	Else
		SetError(1)
	EndIf
	Return IsObj($o_Workbook)
EndFunc

;===============================================================================
;
; Function Name:   _XLWSheet($Op, $o_Worksheet = "", $o_Workbook = "", $s_SheetName = "", "f_After = True)
; Description::    Operation with Excel Workbook
; Parameter(s):    $Op	- The Operation Command:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 
; Author(s):       
;
;===============================================================================
;

Func _XLWSheet($i_Op, $o_Worksheet = "", $o_Workbook = "", $s_SheetName = "", $f_After = True)
Dim $oldName
	SetError(0)
	Switch $i_Op
		Case $XL_NEW
			if GetValidWB($o_Workbook) Then
				$o_xlActiveWorksheet = $o_xlApplication.ActiveSheet
				if $f_After Then
					For $i = 1 to $o_Workbook.Worksheets.Count
						if $o_Workbook.Worksheets.item($i).Name = $o_xlActiveWorksheet.Name Then
							$NextWorksheet = $o_Workbook.Worksheets.item($i+1)
							ExitLoop
						EndIf
					Next
					;$o_Worksheet = $o_Workbook.Worksheets.Add ("After := Activesheet") ;& $o_xlApplication.Activesheet
					$o_Worksheet = $o_Workbook.worksheets.add($o_xlActiveWorksheet)
					$o_Workbook.Worksheets.Item($i).Move($o_Workbook.Worksheets.Item($i + 2))
					$o_Worksheet = $o_Workbook.Worksheets.Item($i+1)
					;MsgBox(64,"Info", " ActiveSheet Name = " & $o_xlApplication.Activesheet.Name)
				Else
					$o_Worksheet = $o_Workbook.Worksheets.add($o_xlActiveWorksheet)
				EndIf
				if IsObj($o_Worksheet) Then
					Return $o_Worksheet
				Else
					SetError(1)
					Return ""
				EndIf
			Else
				SetError(4)
				Return ""
			EndIf

		Case $XL_GETNAME
			if GetValidWS($o_Worksheet, $o_Workbook) Then
				Return $o_Worksheet.Name
			EndIf
			Return ""
		Case $XL_ACTIVATE
			if GetValidWS($o_Worksheet, $o_Workbook) Then
				$o_Worksheet.Activate
				Return $o_Worksheet
			EndIf
		Case $XL_SETNAME
			if GetValidWS($o_Worksheet, $o_Workbook) Then
				$oldName = $o_Worksheet.Name
				$o_Worksheet.Name = $s_SheetName
				Return $oldName
			EndIf
			Return ""
		Case $XL_DELETE
			if GetValidWS($o_Worksheet, $o_Workbook) Then
				$o_Worksheet.Delete
			EndIf
		Case $XL_GETALLNAMES
			if GetValidWB($o_Workbook) Then
				if $o_Workbook.Sheets.Count > 0 Then
					Dim $Result[$o_Workbook.Sheets.Count]
					$i = 0
					For $worksheet in $o_Workbook.Sheets
						$Result[$i] = $worksheet.Name
						$i += 1
					Next
				Else
					$Result = ""
				EndIf
				Return $Result
			Else
				SetError(1)
			EndIf
		Case Else
			SetError(2)
			Return ""
	EndSwitch
EndFunc
			
Func GetValidWS(ByRef $o_Worksheet, ByRef $o_Workbook)
Dim $worksheet, $CurWorksheet, $OldWorkbook 
	$OldWorkbook = $o_Workbook
	SetError(0)
	if GetValidWB($o_Workbook) Then
		Select
			Case IsObj($o_Worksheet)
				if $o_Worksheet.Parent.Name <> $o_Workbook.Name Then
					if $OldWorkbook = "" Then
						$o_Workbook = $o_Worksheet.Parent
					Else
						SetError(5)
					EndIf
				EndIf
			Case IsNumber($o_Worksheet)
				;MsgBox(64,"Info", "Workbook Name = " & $o_Workbook.Name)
				if ($o_Workbook.Worksheets.Count < $o_Worksheet) or ($o_Worksheet < 1) Then
					SetError(3)
				Else
					$o_Worksheet = $o_Workbook.Worksheets.Item($o_Worksheet)
				EndIf
			Case IsString($o_Worksheet)
				if $o_Worksheet = "" Then 
					$o_Worksheet = $o_xlApplication.ActiveSheet
				Else
					$Curworksheet = 0
					For $worksheet in $o_Workbook.Worksheets
						if $worksheet.Name = $o_Worksheet.Name Then
							$CurWorksheet = $worksheet
							ExitLoop
						EndIf
					Next
					If IsObj($Curworksheet) Then
						$o_Worksheet = $Curworksheet
					Else
						SetError(3)
					EndIf
				EndIf
			Case Else
				SetError(3)
		EndSelect
		Return IsObj($o_Worksheet)
	Else
		SetError(2)
		Return False
	EndIf
EndFunc

;===============================================================================
;
; Function Name:   _XLRange($Op, $o_Range = "", $o_Worksheet = "", $o_Workbook = "", $o_NewRange = "", $s_RangeName )
; Description::    Operation with Excel Workbook
; Parameter(s):    $Op	- The Operation Command:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 
; Author(s):       
;
;===============================================================================
;

Func _XLRange($i_Op, $o_Range = "", $o_Worksheet = "", $o_Workbook = "", $v_Param1 = "" , $v_Param2 = "")
	SetError(0)
	Switch $i_Op
		Case $XL_READVALUE
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$Result = $o_Range.Value
				if IsArray($Result) Then
					$Result = TransposeArray($Result)
				EndIf
				Return $Result
			EndIf
		Case $XL_WRITEVALUE
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook, $v_Param1) Then
				if IsArray($v_Param1) Then
					$o_Range.Value = TransposeArray($v_Param1)
				Else
					$o_Range.Value = $v_Param1
				EndIf
				Return $o_Range
			Else
				MsgBox(64,"Info", "InvalidRange " & @error)
				
			EndIf
		Case $XL_GETADDRESS
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				Return $o_Range.Address(False, False)
			EndIf
		Case $XL_SELECT
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$o_Range.Select
				Return $o_Range
			EndIf
		Case $XL_COPYTO
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				if ObjName($o_xlApplication.Selection) = $s_RangeObjName Then
					$o_xlApplication.Selection.Copy
					$o_Range.Select
					$o_Worksheet.Paste
					$o_xlApplication.CutCopyMode = False
				EndIf
				Return $o_Range
			EndIf
		Case $XL_MOVETO
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				if ObjName($o_xlApplication.Selection) = $s_RangeObjName Then
					$o_xlApplication.Selection.Cut
					$o_Range.Select
					$o_Worksheet.Paste
					$o_xlApplication.CutCopyMode = False
				EndIf
				Return $o_Range
			EndIf
		Case $XL_SETNAME
			if $v_Param1 <> "" Then
				if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
					$o_Workbook.Names.Add($v_Param1, $o_Range.Address(True, True, $xlA1,False))
				EndIf
				Return $o_Range
			Else
				Return $v_Param1
			EndIf
		Case $XL_AUTOFILTER
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$o_Range.Select
				$o_xlApplication.Selection.Autofilter()
			EndIf
		Case Else
			SetError(-1)
	EndSwitch
EndFunc

			
Func GetValidRange(ByRef $o_Range, ByRef $o_Worksheet, ByRef $o_Workbook, $Value = "")
	if GetValidWS($o_Worksheet, $o_Workbook) Then
		Select
			Case IsObj($o_Range)
			Case IsNumber($o_Range)
				$o_Range = $o_Worksheet.Range(ValToAddr($o_Range))
			Case IsString($o_Range)
				;$o_Range = ValidateRange($o_Range, $o_Worksheet)
				$f_xlShowCOMError = False
				$o_Range = $o_Worksheet.Range($o_Range)
				if @error Then
					SetError(4)
				EndIf
				$f_xlShowCOMError = True
			case Else
				SetError(4)
		EndSelect
	EndIf
	if IsObj($o_Range) and IsArray($Value) Then
		if UBound($Value,0) = 1 Then
			$o_Range = $o_Range.Resize(1,UBound($Value,1))
		Else
			$o_Range = $o_Range.Resize(UBound($Value,1), UBound($Value,2))
		EndIf
	EndIf
	Return IsObj($o_Range)
EndFunc

;===============================================================================
;
; Function Name:   _XLColRow($Op, $o_Range = "", $o_Worksheet = "", $o_Workbook = "", $o_NewRange = "", $s_RangeName )
; Description::    Operation with Excel Workbook
; Parameter(s):    $Op	- The Operation Command:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): a Range object of Column(s) or Row(s)
; Author(s):       
;
;===============================================================================
;

Func _XLColRow($i_Op, $o_Range = "", $v_Param1 = "", $v_Param2 = "", $o_Worksheet = "", $o_Workbook = "")
	SetError(0)
	Switch $i_Op
		Case $XL_COLUMNWIDTH
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$sRange = GetRowColAddr($o_Range.Address, False)
				if Not @error Then
					$o_Range = $o_Worksheet.Range($sRange)
				Else
					SetError(6)
				EndIf
				if IsNumber($v_Param1) Then
					if $v_Param1 <= 0 Then
						$o_Range.Columns.Autofit
					Else
						$o_Range.Columns.ColumnWidth = $v_Param1
					EndIf
				Else
					$o_Range.Columns.Autofit
				EndIf
			EndIf
		Case $XL_ROWHEIGHT
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$sRange = GetRowColAddr($o_Range.Address)
				if Not @error Then
					$o_Range = $o_Worksheet.Range($sRange)
				Else
					SetError(6)
				EndIf
				if IsNumber($v_Param1) Then
					if $v_Param1 <= 0 Then
						$o_Range.Columns.Autofit
					Else
						$o_Range.Columns.ColumnWidth = $v_Param1
					EndIf
				Else
					$o_Range.Columns.Autofit
				EndIf
			EndIf
		Case $XL_INSERT
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$sRangeCol = GetRowColAddr($o_Range.Address, False)
				$sRangeRow = GetRowColAddr($o_Range.Address)
				if $sRangeCol <> "" Then
					$o_Worksheet.Columns($sRangeCol).Insert($xlToRight)
				EndIf
				if $sRangeRow <> "" Then
					$o_Worksheet.Rows($sRangeCol).Insert($xlDown)
				EndIf
			EndIf
		Case $XL_DELETE
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$sRangeCol = GetRowColAddr($o_Range.Address, False)
				$sRangeRow = GetRowColAddr($o_Range.Address)
				if $sRangeCol <> "" Then
					$o_Worksheet.Columns($sRangeCol).Delete($xlShiftToLeft)
				EndIf
				if $sRangeRow <> "" Then
					$o_Worksheet.Rows($sRangeCol).Insert($xlShiftUp)
				EndIf
			EndIf
		Case $XL_SELECT
			if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
				$sRangeCol = GetRowColAddr($o_Range.Address, False)
				$sRangeRow = GetRowColAddr($o_Range.Address)
				if $sRangeCol <> "" Then
					$o_Worksheet.Columns($sRangeCol).Select
				EndIf
				if $sRangeRow <> "" Then
					$o_Worksheet.Rows($sRangeCol).Select
				EndIf
			EndIf
				
		Case Else
			SetError(-1)
	EndSwitch
	
EndFunc	

Func ValToAddr($iAddr)
	$iCol = mod($iAddr, 256)
	$iRow = int($iAddr/256)
	Return Addr($iCol, $iRow)
EndFunc

Func GetFullPath($FileName)
Dim $Drive, $Dir, $FName, $Ext
	_PathSplit($FileName, $Drive, $Dir, $FName, $Ext)
	if $Dir = "" Then
		Return $o_xlApplication.DefaultFilePath & "\" & $FName & $Ext
	Else
		Return $FileName
	EndIf
EndFunc

Func TransposeArray(ByRef $aArray, $Fromi= 0, $Fromj = 0)
Local $i, $j
Dim $ab[1][1]
	if UBound($aArray,0) > 1 Then
		ReDim $ab[UBound($aArray,2)-$Fromj][UBound($aArray,1)-$Fromi]
		For $i = $Fromi to UBound($aArray,1) - 1
			For $j = $Fromj to UBound($aArray,2) - 1
				$ab[$j-$Fromj][$i-$Fromi] = $aArray[$i][$j]
			Next
		Next
	Else
		ReDim $ab[1][UBound($aArray,2)-$Fromj]
		For $i = $Fromi To UBound($aArray,1) - 1
			$ab[0][$i-$Fromi] = $aArray[$i]
		Next
	EndIf
	Return $ab
EndFunc

;===============================================================================
;
; Function Name:   _XLCell($Op, $o_Range = "", $o_Worksheet = "", $o_Workbook = "", $o_NewRange = "", $s_RangeName )
; Description::    Operation with Excel Workbook
; Parameter(s):    $Op	- The Operation Command:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): a Range object of Column(s) or Row(s)
; Author(s):       
;
;===============================================================================
;
Func _XLCell($i_Op, $o_Range = "", $o_Worksheet = "", $o_Workbook = "", $v_Param1 = "" , $v_Param2 = "")
	SetError(0)
	if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
		$o_Range.Resize(1,1)
		Switch $i_Op
			Case $XL_READVALUE, $XL_WRITEVALUE, $XL_GETADDRESS, $XL_SELECT, $XL_COPYTO, $XL_MOVETO
				_XLRange($i_Op, $o_Range, $o_Worksheet, $o_Workbook, $v_Param1, $v_Param2)
			Case $Xl_LASTCOL
				$R1 = $o_xlApplication.Selection.SpecialCells($xlCellTypeLastCell)
				$Addr1 = GetRowColAddr($R1.Address(False,False,$xlA1) , False, False)
				$Addr2 = GetRowColAddr($o_Range.Address(False,False,$xlA1),True, False)
				$o_Range = $Addr1 & $Addr2
				if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
					$o_Range.Select
					Return $o_Range
				Else
					SetError(4)
				EndIf
			Case $XL_LASTROW
				$R1 = $o_xlApplication.Selection.SpecialCells($xlCellTypeLastCell)
				$Addr1 = GetRowColAddr($o_Range.Address(False,False,$xlA1),False, False)
				$Addr2 = GetRowColAddr($R1.Address(False,False,$xlA1) , True, False)
				$o_Range = $Addr1 & $Addr2
				if GetValidRange($o_Range, $o_Worksheet, $o_Workbook) Then
					$o_Range.Select
					Return $o_Range
				Else
					SetError(4)
				EndIf
			Case $XL_LASTCELL
				$o_Range = $o_xlApplication.Selection.SpecialCells($xlCellTypeLastCell).Select
				Return $o_Range
			Case Else
				SetError(-1)
		EndSwitch
	EndIf
EndFunc

Func Addr($Col, $Row)
Dim $sCol = "" 
;	$Col-= 1
	While $Col > 26
		$Col-= 1
		$sCol = Chr(Mod($Col,26)+65) & $sCol
		$Col = Int($Col/26)
	WEnd
	$Col -= 1
	$sCol = Chr($Col+65) & $sCol
	Return $sCol & String($Row)
EndFunc

Func GetRowColAddr($sRange, $fRows = True, $DupSingle = True)
Dim $Row1, $Row2, $Col1, $Col2
Dim $Result = ""
	$aRange = StringSplit(StringUpper(StringStripWS($sRange,8)),"")
	;_ArrayDisplay($aRange, "$aRange")
	$ndx = 1
	if $fRows Then
		if GetRow($aRange,$Row1,$ndx) Then
			if $ndx < $aRange[0] Then
				if $aRange[$ndx] = ":" Then
					if Not GetRow($aRange, $Row2, $ndx) Then
						SetError(6)
					else
						$Result = $Row1 & ":" &$Row2
					EndIf
				Else
					SetError(6)
				EndIf
			Else
				if $DupSingle Then
					$Result = $Row1 & ":" & $Row1
				Else 
					$Result = $Row1
				EndIf
			EndIf
		Else
			SetError(7)
		EndIf
	else
		if GetCol($aRange,$Col1,$ndx) Then
			if $ndx < $aRange[0] Then
				While $ndx <= $aRange[0] And $aRange[$ndx] <> ":"
					$ndx += 1
				WEnd
				if $ndx <= $aRange[0] And $aRange[$ndx] = ":" Then
					if Not GetCol($aRange, $Col2, $ndx) Then
						SetError(6)
					else
						$Result = $Col1 & ":" &$Col2
					EndIf
				Else
					if $DupSingle Then
						$Result = $Col1 & ":" & $Col1
					Else
						$Result = $Col1
					EndIf
				EndIf
			Else
				if $DupSingle Then
					$Result = $Col1 & ":" & $Col1
				Else
					$Result = $Col1
				EndIf
			EndIf
		Else
			SetError(7)
		EndIf
	EndIf
;	if $Result <> "" Then
;		if $fRows Then
;			$sType = "Rows"
;		Else
;			$sType = "Columns"
;		EndIf
;		MsgBox(64,"Result", $Result & " are the " & $sType & " in Range " & $sRange )
;	EndIf
	Return $Result
EndFunc

Func GetRow(ByRef $a, ByRef $Row, ByRef $i)
	$Row = ""
	while ($i <= $a[0]) and ($a[$i] < "0" or $a[$i] > "9")		
		$i += 1
	WEnd
	if $i <= $a[0] Then
		while ($i <= $a[0]) and ($a[$i] >= "0" And $a[$i] <= "9")
			$Row &= $a[$i]
			$i += 1
		WEnd
		Return True
	Else
		Return False
	EndIf
EndFunc

Func GetCol(ByRef $a, ByRef $Col, ByRef $i)
	$Col = ""
	while ($i <= $a[0]) and ($a[$i] < "A" or $a[$i] > "Z")		
		$i += 1
	WEnd
	if $i <= $a[0] Then
		while ($i <= $a[0]) and ($a[$i] >= "A" And $a[$i] <= "Z")
			$Col &= $a[$i]
			$i += 1
		WEnd
		Return True
	Else
		Return False
	EndIf
EndFunc
;===============================================================================
;
; Function Name:   _XLProperty($PrType, $v_Param1)
; Description::    Operation to the selected Range Properties
; Parameter(s):    $PrType	- The Type of Property:
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): allways return the old value of the property
; Author(s):       
;
;===============================================================================
;

Func _XLProperty($PrType, $v_Param1= "" )
Dim $OldVal
	if ObjName($o_xlApplication.Selection) = $s_RangeObjName Then
		Switch $PrType
			Case $XLP_FONTNAME
				$OldVal = $o_xlApplication.Selection.Font.Name
				if $v_Param1 <> "" Then
					$o_xlApplication.Selection.Font.Name = $v_Param1
				EndIf
				Return $OldVal
			Case Else
		EndSwitch
	EndIf
EndFunc			
				
		
; COM Error Handler example
; ------------------------- 


; This is my custom defined error handler
Func MyErrFunc()

	$HexNumber=hex($oMyError.number,8)    ; for displaying purposes
	if $f_xlShowCOMError Then
		Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
					 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
					 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
					 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF)
	 EndIf
	$n_xlCOMError = $HexNumber
	;SetExtended($HexNumber)
	SetError(1)  ; to check for after this function returns
  ;$oMyError = 0
Endfunc

Func ShowArray(ByRef $aArray, $aName)
Local $i, $j
	;#cs
	$VarVals = ""
	For $i = 0 to UBound($aArray,1)-1
		if UBound($aArray,0) = 2 Then
			For $j = 0 to UBound($aArray,2) -1
				$VarVals &= "[" & $i & "][" & $j & "]= " & $aArray[$i][$j]
			Next
		Else
			$VarVals &= "[" & $i & "]= " & $aArray[$i]
		EndIf
		$VarVals &= @CR
	Next
	MsgBox(64,$aName, $VarVals)
EndFunc
;=======================================================
; ExcelCOM udf functions
; By Randallc
;=======================================================

Func _Array2DTo1D(ByRef $ar_Array, $s_Title = "Array contents", $n_Index = 1, $Line = 0, $s_i_Column = 0)
	; Change Line "X" to 1 dimensional array; [Randallc - I have ***lifted it from Forum at some stage]
	Local $output = ""
	Local $r, $e, $Swap
	If $n_Index <> 0 Then $n_Index = 1; otherwise I can't cope!
	If $s_i_Column <> 0 Then $s_i_Column = 1; otherwise I can't cope!
	If $Line < 0 Then $Line = 0; otherwise I can't cope!
	;If $Line>UBound($ar_Array,1+($s_i_Column=0))+($n_Index=0)-2 then $Line=UBound($ar_Array,)+($n_Index=0)-2	; otherwise I can't cope!
	If $Line > UBound($ar_Array, 1+ ($s_i_Column = 0)) + ($n_Index = 0) - 2 Then $Line = UBound($ar_Array, 1+ ($s_i_Column = 0)) + ($n_Index = 0) - 2; otherwise I can't cope!
	Dim $Array[UBound($ar_Array, 1 + $s_i_Column) + ($n_Index = 0) ]
	$Array[0] = UBound($ar_Array, 1 + $s_i_Column) + ($n_Index = 0)
	If Not IsArray($ar_Array) Then Return -1
	For $r = $n_Index To UBound($ar_Array, 1 + $s_i_Column) - 1
		$e = $r
		$NewLine = $Line
		If $s_i_Column = 1 Then
			$NewLine = $r
			$e = $Line
		EndIf
		$Array[$r+ ($n_Index = 0) ] = $ar_Array[$e][$NewLine]
	Next
	;_ArrayDisplay($Array,$s_Title&"Line"&$Line)
	Return $Array
EndFunc   ;==>_Array2DTo1D

Func _Array2dDisplay(ByRef $ar_Array, $s_Title = "Array contents", $n_Index = 1)
	; Display 2 dimensional array; [***lifted from Forum]
	Local $output = ""
	Local $r, $c
	If Not IsArray($ar_Array) Then Return -1
	For $r = $n_Index To UBound($ar_Array, 1) - 1
		$output = $output & @LF
		For $c = 0 To UBound($ar_Array, 2) - 1
			$output = $output & $ar_Array[$r][$c] & " "
		Next
	Next
	MsgBox(4096, $s_Title, $output)
	Return
EndFunc   ;==>_Array2dDisplay

