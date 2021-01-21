#include "ExcelUDF.au3"

MsgBox(64, "_XLApp()", "Open Excel")
_XLApp($XL_OPEN)
$Result = @error
Switch $Result
	Case 1
		MsgBox(16,"Error", "Cannot Open Excel Application")
		Exit
	Case 2
		MsgBox(16,"Error", "Application is not Open")
		Exit
EndSwitch
		

MsgBox(64, "_XLWBook()", "Create a New Workbook")

$NewWB = _XLWBook($XL_NEW)
if @error Then
	MsgBox(16,"Error", "cannot crate a new Workbook")
EndIf

$NewWB.ActiveSheet.Range("A1").Value = "Hola"

MsgBox(64, "_XLWBook()", "Save the New Workbook")

_XLWBook($XL_SAVE)
if @error Then
	MsgBox(16,"Error", "cannot save the new Workbook")
EndIf

MsgBox(64, "_XLWBook()", "Get the Workbook Name")

$wbName = _XLWBook($XL_GETNAME)

if @error Then
	MsgBox(16,"Error", "cannot get the Workbook Name")
Else
MsgBox(64, "Info", "Workbook Name = " & $wbName)
	
EndIf
#cs
MsgBox(64, "_XLWBook()", "Open an existing Workbook " & @MyDocumentsDir & "\Mis Nuevas Hojas\Datos.xls")

$NewWB = _XLWBook($XL_OPEN, "", @MyDocumentsDir & "\Mis Nuevas Hojas\Datos.xls")
$Result = @error
if $Result Then
	MsgBox(16,"Error", "cannot open an existing Workbook, Error = " & $Result)
EndIf


MsgBox(64, "_XLWBook()", "Get the Workbook Name")

$wbName1 = _XLWBook($XL_GETNAME)

if @error Then
	MsgBox(16,"Error", "cannot get the Workbook Name")
Else
	MsgBox(64, "Info", "Workbook Name = " & $wbName1)
	
EndIf

MsgBox(64, "_XLWBook()", "Activate the workbool " & $wbName)

_XLWBook($XL_ACTIVATE, $wbName)

if @error Then
	MsgBox(16,"Error", "cannot Activate Workbook " & $wbName)
Else
	$wbName1 = _XLWBook($XL_GETNAME)
	MsgBox(64, "Info", "Workbook Name = " & $wbName1)
	
EndIf

#ce

MsgBox(64, "_XLWSheet()", "Create a new worksheet after Active Workshhet")

_XLWSheet($XL_NEW,"","","", True)

if @error Then
	MsgBox(16,"Error", "cannot Create a New Worksheet ")
Else
	$wsName = _XLWSheet($XL_GETNAME)
	MsgBox(64, "Info", "New Worksheet Name = " & $wsName)
EndIf

MsgBox(64, "_XLWSheet()", "Rename the Active Workshhet")

_XLWSheet($XL_SETNAME,"","","NewName")

if @error Then
	MsgBox(16,"Error", "cannot Rename the New Worksheet ")
Else
	$wsName1 = _XLWSheet($XL_GETNAME)
	MsgBox(64, "Info", "New Worksheet Name = " & $wsName1)
EndIf



MsgBox(64, "_XLApp()", "Close Excel")
_XLApp($XL_CLOSE, False)

if @error = 2 Then
	MsgBox(16,"Error", "Application is not Open")
	Exit
EndIf

Exit
