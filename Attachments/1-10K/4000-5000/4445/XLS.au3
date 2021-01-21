;===============================================================================
;
; Function Name:    _XLSCreate()
; Description:      Create a Microsoft Excel Window
; Parameter(s):     $f_visible 		- 1 sets visible (default), 0 sets invisible
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to a new Excel.Application object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSCreate($f_visible = 1)
    $o_object = ObjCreate("Excel.Application")
    If IsObj($o_object) Then
        $o_object.visible = $f_visible
        SetError(0)
        Return $o_object
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSCreate

;===============================================================================
;
; Function Name:    _XLSNew()
; Description:      Create a new Workbook
; Parameter(s):     $o_object	- Excel.Application
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to a new Workbook object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSNew($o_object, $s_sheets = 3)
    If IsObj($o_object) Then
		$o_object.SheetsInNewWorkbook = $s_sheets
        $o_workbook = $o_object.workbooks.add
        SetError(0)
        Return $o_workbook
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSNew

;===============================================================================
;
; Function Name:    _XLSOpen()
; Description:		Opens an existing Workbook based on a path
; Parameter(s):		$o_object 		- Excel.Application
;					$s_path			- path to workbook to open (e.g. "C:\Program Files\Microsoft Office\OFFICE11\SAMPLES\SOLVSAMP.XLS")
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to the particular workbook object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _XLSOpen($o_object, $s_path)
    If IsObj($o_object) Then
        $o_workbook = $o_object.workbooks.open ($s_path, , 1)
        SetError(0)
        Return $o_workbook
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSOpen

;===============================================================================
;
; Function Name:    _XLSGetWorkbook()
; Description:		Opens an existing Workbook based on a path
; Parameter(s):		$o_object		- Excel.Application
;					$s_workbook		- workbook index
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to the particular workbook object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSGetWorkbook($o_object, $s_workbook = 1)
    If IsObj($o_object) Then
		$o_workbook = $o_object.Workbooks($s_workbook)
        SetError(0)
        Return $o_workbook
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSGetWorkbook

;===============================================================================
;
; Function Name:    _XLSGetSheet()
; Description:		Opens an existing Workbook based on a path
; Parameter(s):		$o_workbook		- Workbook object
;					$s_sheet		- sheet index
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to the particular worksheet object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSGetSheet($o_workbook, $s_sheet = 1)
    If IsObj($o_workbook) Then
		$o_sheet = $o_workbook.Sheets($s_sheet)
        SetError(0)
        Return $o_sheet
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSGetSheet

;===============================================================================
;
; Function Name:    _XLSNameSheet()
; Description:		Names a sheet of a WorkBook
; Parameter(s):		$o_sheet		- Worksheet object
;					$s_name			- Name of sheet
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns -1 (the Name attribute actually has no return value - all we know is that we tried)
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSNameSheet($o_sheet, $s_name)
    If IsObj($o_sheet) Then
		$o_sheet.Name = $s_name
        SetError(0)
        Return -1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSNameSheet

;===============================================================================
;
; Function Name:    _XLSSaveWorkbook()
; Description:		Opens an existing Workbook based on a path
; Parameter(s):		$o_workbook		- Workbook object
;					$s_path			- path and workbook name
;					$s_savetype		- save or save as (save is default)
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns -1 (the Save method actually has no return value - all we know is that we tried)
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSSaveWorkbook($o_workbook, $s_path = "./", $s_savetype = "save")
	$s_savetype = StringLower($s_savetype)
    If IsObj($o_workbook) Then
		If $s_savetype = "save" Then
			$o_workbook.Save ()
		Else
			$o_workbook.SaveAs ($s_path)
		EndIf
        SetError(0)
        Return -1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSSaveWorkbook

;===============================================================================
;
; Function Name:    _XLSCloseWorkbook()
; Description:		Opens an existing Workbook based on a path
; Parameter(s):		$o_workbook		- Workbook object
;					$s_savechanges	- true or false
;					$s_path			- path and workbook name
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns -1 (the Close method actually has no return value - all we know is that we tried)
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
; $s_path parameter is not working properly.  need to investigate further
;
;===============================================================================
;
Func _XLSCloseWorkbook($o_workbook, $s_savechanges = 1, $s_path = "./Workbook1.xls")
    If IsObj($o_workbook) Then
		$o_workbook.close ($s_savechanges, $s_path)
        SetError(0)
        Return -1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSCloseWorkbook

;===============================================================================
;
; Function Name:    _XLSGetLastCell()
; Description:		Names a sheet of a WorkBook
; Parameter(s):		$o_sheet		- Worksheet object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to the last cell object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSGetLastCell($o_sheet)
    If IsObj($o_sheet) Then
		$lastRow = $o_sheet.Range("A1").SpecialCells(11).Row
		$lastCol = $o_sheet.Range("A1").SpecialCells(11).Column
		$o_cell = $o_sheet.Cells($lastRow, $lastCol)
        SetError(0)
        Return $o_cell
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSGetLastCell

;===============================================================================
;
; Function Name:   _XLSQuit()
; Description:		Close Excel and remove the object refernce to it
; Parameter(s):		$o_object 	- Excel.Application object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        AutoIT Pimp
;
;===============================================================================
;
Func _XLSQuit($o_object)
    If IsObj($o_object) Then
        SetError(0)
        $o_object.quit ()
        $o_object = 0
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_XLSQuit