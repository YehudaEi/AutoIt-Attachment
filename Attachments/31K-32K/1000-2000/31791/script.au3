;----------------------------------------------------------------------
; AutoIt Version: 3.3.6.1
;
; Author: William Scheele
; Date Created: 9/2/2010
; Date Last Modified: 9/2/2010
; Version: 1.0
;
; Fucntion:
;		Open Excel file and duplicate lines so it can be mail merged in to 
;		MS Word and have labels printed
;
;----------------------------------------------------------------------
;                            SetUp Defaults
;----------------------------------------------------------------------

$App1 = "C:\Program Files\Microsoft Office\Office11\EXCEL.EXE"
$ExcelDoc = "\\oahu1\operations\Purch Labels\test-OPENPO.XLS"


;----------------------------------------------------------------------
;                             BEGIN SCRIPT
;----------------------------------------------------------------------

;Open Excel
Run ($App1)
WinWaitActive ("Microsoft Excel")
Sleep(1000)

;Open File
Send ("^o")
Send ($ExcelDoc)
Send ("{ENTER}")
Sleep(1000)
;Add and Run Macro
Send ("!{F8}")
Send ("LabelMacro")
Send ("{ENTER}")
Sleep(1500)
Send ("^a")
Send ("{DELETE}")
;----------------------------------------------------------------------
;                                 MACRO
;----------------------------------------------------------------------
Sleep(1000)
Send ("Sub RepeatRowsOnColumnA()")
Send ("{ENTER}")
Send ("ActiveSheet.Copy Before:=ActiveSheet")
Send ("{ENTER}")
Send ("Application.ScreenUpdating = False")
Send ("{ENTER}")
Send ("Dim vRows As Long, v As Long")
Send ("{ENTER}")
Send ("On Error Resume Next")
Send ("{ENTER}")
Send ("Dim ir As Long, mrows As Long, lastcell As Range")
Send ("{ENTER}")
Send ("Set lastcell = Cells.SpecialCells(xlLastCell)")
Send ("{ENTER}")
Send ("mrows = lastcell.Row")
Send ("{ENTER}")
Send ("For ir = mrows To 2 Step -1")
Send ("{ENTER}")
Send ("If Not IsNumeric(Cells(ir, 1)) Then")
Send ("{ENTER}")
Send ("Cells(ir, 1).EntireRow.Delete")
Send ("{ENTER}")
Send ("ElseIf Cells(ir, 1).Value > 1 Then")
Send ("{ENTER}")
Send ("v = Cells(ir, 1).Value - 1")
Send ("{ENTER}")
Send ("Rows(ir + 1).Resize(v).Insert Shift:=xlDown")
Send ("{ENTER}")
Send ("Rows(ir).EntireRow.AutoFill Rows(ir). _")
Send ("{ENTER}")
Send ("EntireRow.Resize(rowsize:=v + 1), xlFillCopy")
Send ("{ENTER}")
Send ("'Rows(ir).EntireRow.Interior.ColorIndex = 36")
Send ("{ENTER}")
Send ("ElseIf Cells(ir, 1).Value < 1 Then")
Send ("{ENTER}")
Send ("Cells(ir, 1).EntireRow.Delete")
Send ("{ENTER}")
Send ("End If")
Send ("{ENTER}")
Send ("Next ir")
Send ("{ENTER}")
Send ("Application.ScreenUpdating = True")
Send ("{ENTER}")
Send ("End Sub")