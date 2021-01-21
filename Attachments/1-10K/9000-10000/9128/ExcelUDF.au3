#include <File.au3>

; Commands
Dim $XL_OPEN = 0
Dim $XL_CLOSE = 1
Dim $XL_WAITREADY = 2
Dim $XL_NEW = 3
Dim $XL_SAVE = 4
Dim $XL_GETNAME = 5
Dim $XL_ACTIVATE = 6
Dim $XL_SETNAME = 7

#cs
	@error = -4 Command Aborted
	@error = -3 File not Found
	@error = -2 Cannot create object
	@error = -1	Invalid Command
	@error = 1	Invalid Applicaion
	@error = 2	Invalid Workbook
	@error = 3	Invalid Worksheet
	@error = 4	Invalid Range
#ce

; Variables
Dim $o_xlApplication
Dim $f_xlUseActiveObject = True

$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")    ; Initialize a COM error handler


;===============================================================================
;
; Function Name:	_XLApp()
; Description::    Operation with Excel Application Object
; Parameter(s):    $Op	- The Operation Command:
;						- $XL_OPEN Open the Application. Use $Param1 = True (default value) to set the Application Visible or = False to Hide
;						- $XL_CLOSE Close the Application. Use $Param1 = True (deault value) to display AlertDialog box about unsaved WorkBooks or = False to ingnore Changes
;						- $XL_WAITREADY Wait until Application is Ready
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
;						- $XL_NEW Creates a New WorkBook
;						- $XL_OPEN Open a Workbook where $Param1 is the Workbook Path if $Param1 is Empty (Default Value) a Dialog File open is shown
;						- $XL_CLOSE Close a Workbook where Param1 is the Name or Object of the Workbook if is empty the ActiveWorkbook will be Closed
;							$o_Workbook is the Wrkbook object if Empty then the ActiveWorkbook will be saved
;							$s_Filename the name of the Worksheet if empty then a Dialog box will be shown to get te Filename
;						- $XL_SAVE 
;						- $XL_SAVEAS Save the Workbook 
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 
; Author(s):       
;
;===============================================================================
;

Func _XLWBook($i_Op, $o_Workbook = "", $s_Filename = "")
	SetError(0)
	Switch $i_Op
		Case $XL_NEW
			$o_Workbook = $o_xlApplication.Workbooks.add()
			if IsObj($o_Workbook) Then
				Return $o_Workbook
			Else
				SetError(-2)
				Return ""
			EndIf

		Case $XL_OPEN
			if IsString($o_Workbook) Then
				if $o_Workbook <> "" Then
					if FileExists(GetFullPath($o_Workbook)) Then
						$o_Workbook = $o_xlApplication.Workbooks.Open($s_Filename)
						if IsObj($o_Workbook) Then
							Return $o_Workbook 
						Else
							SetError(-2)
							Return ""
						EndIf
					Else
						$o_Workbook = $o_xlApplication.Workbooks.Open()
						if IsObj($o_Workbook) Then
							Return $o_Workbook
						Else
							SetError(-2)
						EndIf
					EndIf
				EndIf
			Else
				SetError(3)
				Return "" 
			EndIf
		Case $XL_CLOSE
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				if $s_Filename <> "" Then
					$o_Workbook.SaveAs($s_Filename)
				EndIf
				$o_Workbook.Close()
			EndIf
		Case $XL_SAVE
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				if $s_Filename <> "" Then
					$o_Workbook.SaveAs($s_Filename)
				Else
					$o_Workbook.Saved = True
					$o_Workbook.Save()
				EndIf
			EndIf
		Case $XL_GETNAME
			if Not GetValidWB($o_Workbook) Then
				SetError(1)
			Else
				Return $o_Workbook.Name
			EndIf
		Case $XL_ACTIVATE
			Select
				Case IsObj($o_Workbook)
					$o_Workbook.Activate()
				Case IsNumber($o_Workbook)
					$o_xlApplication.Workbooks.item($o_Workbook).Activate()
				Case IsString($o_Workbook)
					if $o_Workbook <> "" Then
						$o_xlApplication.Workbooks.item($o_Workbook).Activate()
					Else
						SetError(1)
					EndIf
				Case Else
					SetError(1)
			EndSelect
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
					$o_Workbook = $o_xlApplication.Worksheets.Item($o_Workbook)
				EndIf
			Case IsString($o_Workbook)
				if $o_Workbook = "" Then
					if $f_xlUseActiveObject Then
						$o_Workbook = $o_xlApplication.ActiveWorkbook
					Else
						SetError(2)
					EndIf
				Else
					$Curworkbook = 0
					For $worbook in $o_xlApplication.Workbooks
						if $workbook.Name = $o_Workbook Then
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
;						- $XL_NEW Creates a New WorkBook
;						- $XL_OPEN Open a Workbook where $Param1 is the Workbook Path if $Param1 is Empty (Default Value) a Dialog File open is shown
;						- $XL_CLOSE Close a Workbook where Param1 is the Name or Object of the Workbook if is empty the ActiveWorkbook will be Closed
;							$o_Workbook is the Wrkbook object if Empty then the ActiveWorkbook will be saved
;							$s_Filename the name of the Worksheet if empty then a Dialog box will be shown to get te Filename
;						- $XL_SAVE 
;						- $XL_SAVEAS Save the Workbook 
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
					;MsgBox(64,"Info", "Count = " & $o_Workbook.Worksheets.Count & " Pos = " & $i)
					;MsgBox(64,"Info", " Nombre del Objeto = " & ObjName($o_Workbook.Worksheets.Item($i)) & "Nombre de la Hoja = " & $o_Workbook.Worksheets.Item($i).Name  )
					;$o_Worksheet = $o_Workbook.Worksheets.Add(Default, $o_xlApplication.Activesheet)
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
		Case Else
			SetError(2)
			Return ""
	EndSwitch
EndFunc
			
Func GetValidWS(ByRef $o_Worksheet, ByRef $o_Workbook)
Dim $worksheet, $CurWorksheet 
	SetError(0)
	if GetValidWB($o_Workbook) Then
		;MsgBox(64,"Info", "Valid Workbook")
		Select
			Case IsObj($o_Worksheet)
				if $o_Worksheet.Parent.Name <> $o_Workbook.Name Then
					SetError(0)
				EndIf
			Case IsNumber($o_Worksheet)
				if $o_Workbook.Worksheets.count < $o_Worksheet or $o_Worksheet < 1 Then
					SetError(3)
				Else
					$o_Worksheet = $o_Workbook.Worksheets.Item($o_Worksheet)
				EndIf
			Case IsString($o_Worksheet)
				if $o_Worksheet = "" Then 
					if $f_xlUseActiveObject Then
						$o_Worksheet = $o_xlApplication.ActiveSheet
					Else
						SetError(3)
					EndIf
				Else
					$Curworksheet = 0
					For $worksheet in $o_Workbook.Worksheets
						;MsgBox(64,"Info", " Nombre del Objeto = " & ObjName($worksheet) & "Nombre de la Hoja = " & $worksheet.Name  )
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
;						- $XL_NEW Creates a New WorkBook
;						- $XL_OPEN Open a Workbook where $Param1 is the Workbook Path if $Param1 is Empty (Default Value) a Dialog File open is shown
;						- $XL_CLOSE Close a Workbook where Param1 is the Name or Object of the Workbook if is empty the ActiveWorkbook will be Closed
;							$o_Workbook is the Wrkbook object if Empty then the ActiveWorkbook will be saved
;							$s_Filename the name of the Worksheet if empty then a Dialog box will be shown to get te Filename
;						- $XL_SAVE 
;						- $XL_SAVEAS Save the Workbook 
; Requirement(s):  AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s): 
; Author(s):       
;
;===============================================================================
;

Func UseActiveObject($f_Active = True)
	$f_xlUseActiveObject = $f_Active
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
		
; COM Error Handler example
; ------------------------- 


;If @error then
;  Msgbox (0,"AutoItCOM test","Test passed: We got an error number: " & @error)
;Else
;  Msgbox (0,"AutoItCOM test","Test failed!")
;Endif

;Exit

; This is my custom defined error handler
Func MyErrFunc()

  $HexNumber=hex($oMyError.number,8)    ; for displaying purposes
  Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF)
  SetError(1)  ; to check for after this function returns
  ;$oMyError = 0
Endfunc

