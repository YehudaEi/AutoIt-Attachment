#include <Array.au3>
#include <EventLog.au3>
#include <string.au3>



Global $vars_file = "\\dc-pri-cfu\NETLOGON\vars.ini"
Global $obj[99][2], $nobj
_add_network_printers()

Func _add_network_printers()
	For $j = 1 To read_array($vars_file, "Printers")
		;MsgBox(4096, "Number of Printers :" & $nobj, "Key: " & $obj[$j][0] & @CRLF & "Value: " & $obj[$j][1])
		$printer = $obj[$j][1]
		_PrinterAdd($printer, 0)
	Next
EndFunc   ;==>_add_network_printers

Func read_array($ini_file, $ini_section)
	MsgBox(4096, $obj, $ini_file & @CRLF & $ini_section)
	If FileExists($ini_file) Then
		$var = IniReadSection($ini_file, $ini_section)
		If @error Then
			MsgBox(4096, "Error", "Unable to read section.")
		Else
			For $i = 1 To $var[0][0]
				$obj[$i][0] = $var[$i][0]
				$obj[$i][1] = $var[$i][1]
				;MsgBox(4096, "Number of Printers :" & $var[0][0], "Key: " & $obj[$i][0] & @CRLF & "Value: " & $obj[$i][1])
			Next
			$nobj = $var[0][0]
			Return $nobj
		EndIf
	Else
		$error_code = 1
		_put_event(1, "The INI file " & $ini_file & " may not exist or the section " & $ini_section & " within may not exist", @error)
	EndIf
EndFunc   ;==>read_array


;===============================================================================
;
; Function Name:    _PrinterAdd()
; Description:      Connects to a Network Printer.
; Parameter(s):     $sPrinterName - Computer Network name and printer share name (\\Computer\SharedPrinter).
;                   $fDefault - Set to 1 if Printer should be set to default (optional).
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure, If Printer already exist @error = 1.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterAdd($sPrinterName, $fDefault = 0)
	If _PrinterExist($sPrinterName) Then
		SetError(1)
		Return 0
	Else
		RunWait("rundll32 printui.dll,PrintUIEntry /in /n" & $sPrinterName & " /q")
		If _PrinterExist($sPrinterName) = 0 Then
			$error_code = 1
			_put_event(1, "Could not install printer :" & $sPrinterName & " on local computer " & @ComputerName & "Does shared printer exist on host machine?", @error)
			Return 0
		EndIf
		If $fDefault = 1 Then
			_PrinterDefault($sPrinterName)
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_PrinterAdd

;===============================================================================
;
; Function Name:    _PrinterDefault()
; Description:      Set a printer to default.
; Parameter(s):     $sPrinterName - The name of the printer.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterDefault($sPrinterName)
	If _PrinterExist($sPrinterName) Then
		RunWait("rundll32 printui.dll,PrintUIEntry /y /n" & $sPrinterName)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_PrinterDefault

;===============================================================================
;
; Function Name:    _PrinterDelete()
; Description:      Delete a connection to a network printer.
; Parameter(s):     $sPrinterName - Computer Network name and printer share name.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterDelete($sPrinterName)
	If _PrinterExist($sPrinterName) Then
		RunWait("rundll32 printui.dll,PrintUIEntry /dn /n" & $sPrinterName)
		If _PrinterExist($sPrinterName) Then
			Return 0
		Else
			Return 1
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_PrinterDelete

;===============================================================================
;
; Function Name:    _PrinterExist()
; Description:      Check if a Printer Exist.
; Parameter(s):     $sPrinterName - The name of the printer.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterExist($sPrinterName)
	Local $hService, $sPrinter, $sPrinterList
	$hService = ObjGet("winmgmts:{impersonationLevel=impersonate}!" & "\\" & @ComputerName & "\root\cimv2")
	If Not @error = 0 Then
		Return 0
	EndIf
	$sPrinterList = $hService.ExecQuery("Select * From Win32_Printer")
	For $sPrinter In $sPrinterList
		If StringUpper($sPrinterName) = StringUpper($sPrinter.name) Then
			Return 1
		EndIf
	Next
EndFunc   ;==>_PrinterExist

Func _put_event($value, $text, $error_id_code)
	;SUCCESS = 0
	;ERROR =1
	;WARNING =2
	;INFORMATION =4
	;AUDIT_SUCCESS =8
	;AUDIT_FAILURE =16
	Local $hEventLog, $aData[4] = [3, 1, 2, 3]

	$hEventLog = _EventLog__Open("", "Logon Script")
	_EventLog__Report($hEventLog, $value, 0, $error_id_code, @UserName, @CRLF & @CRLF & $text & @CRLF & @CRLF & "Contact Computer Facilities for more information, contact details can be found at www.computer-facilities.com or e-mail support@computer-facilities.com", $aData)
	_EventLog__Close($hEventLog)
EndFunc   ;==>_put_event
