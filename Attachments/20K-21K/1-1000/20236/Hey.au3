#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.11.10 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ExcelCOM_UDF.au3>  ; Include the collection

Global $oExcel, $oLOG, $val1, $val2, $val3, $val4, $val5, $val6, $ctr, $determinant, $wrongcard, $checker
Global $val, $check1, $check2, $check3, $check4, $condition1, $condition2, $condition3, $add, $add1
Global $orig_rct, $orig_rct1, $orig_rsr, $orig_rsr1, $desc, $rnn, $rcs, $rct, $rat, $rsr, $new_rct, $new_rct1, $new_rsr, $new_rsr1
Global $condition1, $paramchanged, $saved, $oexport, $pre_import, $import_comp, $text, $ascii, $yes, $no, $param1, $save
Global $post_import, $post_import_addtl_card, $old_scan_rate1, $old_scan_rate2, $old_con_assign1, $old_con_assign2, $success, $result
Global $param2, $content1, $content2, $content3, $content4, $res, $error, $str, $substr, $card_slot, $par, $Zone1, $Zone2, $Z1, $Z2
Global $text_Z2, $ascii_Z2, $par_comp, $comp_Z1, $comp_Z2, $par_export

$text = "D:\DeltaV\DVData\BulkEdit\RIO1Card1.txt"
$ascii = "D:\DeltaV\DVData\BulkEdit\RIO1Card1_ASCII.txt"
$text_Z2 = "D:\DeltaV\DVData\BulkEdit\RIO2Card1.txt"
$ascii_Z2 = "D:\DeltaV\DVData\BulkEdit\RIO2Card1_ASCII.txt"
$yes = "!y"
$no = "n"
$Zone1 = "D:\DeltaV\DVData\BulkEdit\RIO1Card.fmt"
$Zone2 = "D:\DeltaV\DVData\BulkEdit\RIO2Card.fmt"
$Z1 = "D:\DeltaV\DVData\BulkEdit\RIO1Card1.txt"
$Z2 = "D:\DeltaV\DVData\BulkEdit\RIO2Card1.txt"
$comp_Z1 = "rioz1_card_type"
$comp_Z2 = "rioz2_card_type"
$export_ser = "C:\Documents and Settings\Administrator\Desktop\SERIAL.fhx"



Opt("WinWaitDelay",100)

;======================================================================================================================

;======================================================================================================================

;Test Case 23

;Test Case 23

_RunDVE()
_Search_Cont_Net()

;add new controller
Send("!o")
Send("n{RIGHT}{ENTER}{ENTER}{ENTER}{DOWN}{DOWN}{ENTER}{TAB}{TAB}")
Send("{SHIFTDOWN}{F10}{SHIFTUP}")
Send("n")
WinWaitActive("Add card")
Send("!l")
For $ctr = 1 to 6 Step +1
	
	Send("{DOWN}")

Next
Send("!o")
Send("{ENTER}{DOWN}{UP}")
Send("{SHIFTDOWN}{F10}{SHIFTUP}")
Send("n")
WinWaitActive(" Properties")
Send("{ENTER}")
Send("{SHIFTDOWN}{F10}{SHIFTUP}")
Send("n")
WinWaitActive("Create dataset")
Send("{ENTER}")
Send("{TAB}{TAB}{UP}{UP}{UP}{UP}{UP}{UP}")
Send("{SHIFTDOWN}{F10}{SHIFTUP}")
Send("e")
WinWaitActive("Export")
Send("SERIAL")
MouseClick("left", 281, 322)
Send("!s")
If WinActive("Export") Then Send("y")
WinWaitActive("Export complete")
Send("{ENTER}")
_open_export($export_ser)

$content = _ExcelReadCell($oexport, "A142")

_CloseExport()


If $content <> "" Then
	
	$success = True

Else
	
	$success = False
	
EndIf

_OpenLogSheet()

If $success = True Then 
	
	_ExcelWriteCell($oLOG, "P", "U29") ;all cards passed
	_ExcelWriteCell($oLOG, "Serail datasets configured", "R29")

Else
	
	_ExcelWriteCell($oLOG, "F", "U29") ; not all cards passed
	_ExcelWriteCell($oLOG, "Serial Dataset not configured", "R29")

EndIf

_Save_and_Close_Log()




Func _RunDVE()
	
	Run("C:\DeltaV\bin\exp.exe  ")
	WinWait("Exploring DeltaV")
	If Not WinActive("Exploring DeltaV") Then WinActivate("Exploring DeltaV")
	WinWaitActive("Exploring DeltaV")
	WinMove("Exploring DeltaV", "", -4, -4, 1032, 748) ;make the window size/position fixed
	
EndFunc

Func _Search_Cont_Net()
	
	MouseClick("left", 10, 109) ;DeltaV Explorer
	Send("S") ;System Configuration
	Send("{RIGHT}") ;Expand 
	Send("P") ;Physical Network
	Send("{RIGHT}") ;Expand
	Send("C") ;Control Network
	
EndFunc

Func _Clear_RIO()
	
	Send("d")
	_Search_Remote_IO()
	Send("{TAB}")
	Send("{SHIFTDOWN}")
	
	For $clearctr = 1 to 60 Step +1
		Send("{DOWN}")
	Next
	
	Send("{SHIFTUP}")
	
	Send("{DELETE}")
	
	WinWaitActive("Exploring DeltaV")
	
	Send("y")
	
EndFunc


Func _Search_Remote_IO()
	
	MouseClick("left", 10, 109) ;DeltaV Explorer
	Send("S") ;System Configuration
	Send("{RIGHT}") ;Expand 
	Send("P") ;Physical Network
	Send("{RIGHT}") ;Expand
	Send("C") ;Control Network
	Send("{RIGHT}") ;Expand
	Send("R") ;Remote I/O Network
	
EndFunc
	
Func _UD_Export_Z1($UDE_Param1, $UDE_Param2)
	
	MouseClick("left", 10, 28)
	MouseClick("left", 41, 188)
	MouseClick("left", 260, 231)
	WinWait("User Defined Export", "&Children of selected component")
	If Not WinActive("User Defined Export", "&Children of selected component") Then WinActivate("User Defined Export", "&Children of selected component")
	WinWaitActive("User Defined Export", "&Children of selected component")
	Send("!n")
	WinWait("User Defined Export", "&Expand All")
	If Not WinActive("User Defined Export", "&Expand All") Then WinActivate("User Defined Export", "&Expand All")
	WinWaitActive("User Defined Export", "&Expand All")
	MouseClick("left", 340, 276)
	Send("!n")
	WinWait("Format source","&Create...")
	If Not WinActive("Format source","&Create...") Then WinActivate("Format source","&Create...")
	WinWaitActive("Format source","&Create...")
	Send($UDE_Param1)
	Send("!n")
	WinWait("Export target")
	If Not WinActive("Export target") Then WinActivate("Export target")
	WinWaitActive("Export target")
	MouseClick("left", 352, 285)
	Send($UDE_Param2)
	Send("!n")
	Send("!y")
	WinWait("Export results", "Export")
	If Not WinActive("Export results", "Export") Then WinActivate("Export results", "Export")
	WinWaitActive("Export results", "Export")
	MouseMove(529,514)
	MouseClick("left")
	WinWait("Export results", "Finish")
	If Not WinActive("Export results", "Finish") Then WinActivate("Export results", "Finish")
	WinWaitActive("Export results", "Finish")
	MouseMove(529,514)
	MouseClick("left")

EndFunc

Func _OpenExcel($param1)

	$oExcel = _ExcelBookOpen($param1, 1, False)
	
	If $param1 = "D:\DeltaV\DVData\BulkEdit\RIO1Card1.txt" Then
		
		WinMove("Microsoft Excel - RIO1Card1", "", -4, -4, 1024, 738) 
	
	Else
	
		WinMove("Microsoft Excel - RIO1Card1_ASCII", "", -4, -4, 1032, 746) 
		
	EndIf

EndFunc

Func _CloseExcel($save)
	
	_ExcelBookClose($oExcel)
	WinWaitActive("Microsoft Office Excel")
	Send($save)
	
EndFunc

Func _ReadFields()
	
	$val1 = _ExcelReadCell($oExcel, "A1")
	$val2 = _ExcelReadCell($oExcel, "B1")
	$val3 = _ExcelReadCell($oExcel, "C1")
	$val4 = _ExcelReadCell($oExcel, "D1")
	$val5 = _ExcelReadCell($oExcel, "E1")
	$val6 = _ExcelReadCell($oExcel, "F1")
	$cardtype = _ExcelReadCell($oExcel, "D2")
	
EndFunc

Func _Compare($par_comp)
	
	$checker = 0 ;set checker to false

	If $val1 = "description" Then $checker = $checker + 1
	If $val2 = "rio_node_name" Then $checker = $checker + 1
	If $val3 = "rio_card_slot" Then $checker = $checker + 1
	If $val4 = $par_comp Then $checker = $checker + 1
	If $val5 = "rio_assigned_to" Then $checker = $checker + 1
	If $val6 = "rio_scan_rate" Then $checker = $checker + 1
	
EndFunc

Func _New_Card()
	
	Send("!o") ;Object
	Send("n") ;New
	Send("{RIGHT}")
	For $ctr = 1 to 3 Step +1
	
		Send("{ENTER}")
	
	Next
	Send("{RIGHT}") ;Highlight I/O
	Send("{SHIFTDOWN}{F10}{SHIFTUP}") ;equivalent to right click
	Send("n") ;New Card -- Analog I/O
	WinWaitActive("Add card")
	
EndFunc

Func _Highlight_c01()
	
	Send("!o") ;OK
	Send("{TAB}{TAB}{RIGHT}{DOWN}") ;highlight c01
	
EndFunc

Func _OpenLogSheet()
	
	$oLOG = _ExcelBookOpen("C:\Documents and Settings\Administrator\Desktop\BulkEdit.xls", 1, False)
	WinMove("Microsoft Excel - BulkEdit  [Compatibility Mode]", "", -4, -4, 1032, 746)
	MouseClick("left", 626, 707)

EndFunc

Func _Save_and_Close_Log()
	
	_ExcelBookSave($oLOG, 0)
	_ExcelBookClose($oLOG)
	
EndFunc

Func _Run_Exce1_Z1($param2)
	
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run")
	If Not WinActive("Run") Then WinActivate("Run")
	WinWaitActive("Run")
	Send("excel")
	MouseClick("left", 135, 703)
	WinWait("Microsoft Excel - Book1") 
	If Not WinActive("Microsoft Excel - Book1") Then WinActivate("Microsoft Excel - Book1")
	WinWaitActive("Microsoft Excel - Book1")
	WinMove("Microsoft Excel - Book1", "", -4, -4, 1032, 746)
	MouseMove(531,36)
	MouseClick("left")
	MouseMove(159,63)
	MouseClick("left")
	WinWait("Open Data File")
	If Not WinActive("Open Data File") Then WinActivate("Open Data File")
	WinWaitActive("Open Data File")
	WinMove("Open Data File", "", -4, -4, 1032, 746)
	Send($param2)
	Send("!o")
	
	If $param2 = $text Then 
		
		WinWaitActive("Unicode Detected")
		
		MouseClick("left",512,488)
		
	EndIf
	
	If $param2 = $text Then 
	
		WinWaitActive("Microsoft Excel - RIO1Card1")
		
	Else
		
		WinWaitActive("Microsoft Excel - RIO1Card1_ASCII")
		
	EndIf
		
	
	
EndFunc

Func _Save_and_Close_Excel_Z1()
	
	MouseClick("left", 184, 65)
	WinWait("Save Data File")
	If Not WinActive("Save Data File") Then WinActivate("Save Data File")
	WinWaitActive("Save Data File")
	Send("RIO1Card1_ASCII.TXT")
	Send("!s")
	WinWaitActive("Microsoft Office Excel")
	Send("!y")
	MouseMove(21,23)
	MouseClick("left")
	MouseClick("left", 75, 428)
	MouseClick("left", 1014, 7)
	
EndFunc

Func _export()
	
	Send("{SHIFTDOWN}{F10}{SHIFTUP}") ;equivalent to right click
	Send("e") ;export
	WinWaitActive("Export")
	MouseClick("left", 279, 323) ;desktop
	Send("RIO")
	Send("!s")
	WinWaitActive("Export")
	If WinActive("Export") Then Send("y")
	WinWaitActive("Export complete")
	If Not WinActive("Export complete") Then WinActivate("Export complete")
	WinWaitActive("Export complete")
	Send("{ENTER}")

EndFunc

Func _Open_Excel_Export()
	
	$oexport = _ExcelBookOpen("C:\Documents and Settings\Administrator\Desktop\RIO.fhx", 1, False)
	WinWait("Microsoft Excel - RIO") 
	If Not WinActive("Microsoft Excel - RIO") Then WinActivate("Microsoft Excel - RIO")
	WinWaitActive("Microsoft Excel - RIO")
	WinMove("Microsoft Excel - RIO", "", -4, -4, 1032, 746)
	
EndFunc

Func _CloseExport()
	
	_ExcelBookClose($oexport)
	WinWaitActive("Microsoft Office Excel")
	Send("n")
	
EndFunc

Func _import_Z1()
	
	MouseClick("left", 14, 26)
	MouseClick("left", 37, 173)
	MouseClick("left", 232, 190)
	WinWait("Format source")
	If Not WinActive("Format source") Then WinActivate("Format source")
	WinWaitActive("Format source")
	Send("D:\DeltaV\DVData\BulkEdit\RIO1Card.fmt")
	Send("!n")
	WinWait("Import data source")
	If Not WinActive("Import data source") Then WinActivate("Import data source")
	WinWaitActive("Import data source")
	MouseClick("left", 364, 281)
	Send("D:\DeltaV\DVData\BulkEdit\RIO1Card1_ASCII.TXT")
	Send("!n")
	WinWait("Import results")
	If Not WinActive("Import results") Then WinActivate("Import results")
	WinWaitActive("Import results")
	Send("!i")
	
EndFunc

Func _Does_Sub_Exist($str, $substr, $card_slot, $par)
	
	$res = StringInStr($str, $substr)
	
	If $res = 0 Then ;substing not found ==> not modified
		
		$error = $error & "Not modified: " & $card_slot & " " & $par & @LF
		
	EndIf
	
	Return $res
	
EndFunc

Func _Check_Sub()
	
	If $result = 0 Then ;substring not found
	
		$success = False
	
	EndIf

EndFunc

Func _New_Card_Z2()
	
	Send("!o") ;Object
	Send("n") ;New
	Send("{RIGHT}{DOWN}{ENTER}{ENTER}{ENTER}{RIGHT}")
	Send("{SHIFTDOWN}{F10}{SHIFTUP}") ;equivalent to right click
	Send("n") ;New Card 
	WinWaitActive("Add card")
	
EndFunc

Func _open_export($par_export)
	
	$oexport = _ExcelBookOpen($par_export, 1, False)
	
	Select
		
		Case $par_export = $export_ser
			
			WinWaitActive("Microsoft Excel - SERIAL")
			WinMove("Microsoft Excel - SERIAL", "", -4, -4, 1032, 746)
			
	EndSelect
	
EndFunc
	