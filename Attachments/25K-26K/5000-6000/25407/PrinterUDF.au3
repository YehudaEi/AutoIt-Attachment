$objWMIService = 0


Func GetPrinterList()
    Local $result, $strComputer, $colEvents, $np,$result
    $strComputer = "."
    If $objWMIService = 0 Then $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
    $colEvents = $objWMIService.ExecQuery _
            (StringFormat('Select * From Win32_Printer')); Where DeviceID = "%s"', $PrinterName));TRUE
    $np = 0
    For $objPrinter in $colEvents
        $result &= $objPrinter.DeviceID & @CRLF
    Next
      
   $Result = StringLeft($result,StringLen($result) - 1)
    Return $result;return the list of printers

EndFunc

Func GetDefaultPrinter()
    Local $szDefPrinterName
    Local $Size
    $namesize = DllStructCreate("dword")
    DllCall("winspool.drv", "int", "GetDefaultPrinter", "str", '', "ptr", DllStructGetPtr($namesize))
    $pname = DllStructCreate("char[" & DllStructGetData($namesize, 1) & "]")
    DllCall("winspool.drv", "int", "GetDefaultPrinter", "ptr", DllStructGetPtr($pname), "ptr", DllStructGetPtr($namesize))
    Return DllStructGetData($pname, 1);msgbox(0,dllstructgetdata($namesize,1),DllStructGetData($pname,1))
EndFunc ;==>GetDefaultPrinter



Func PrinterSetAsDefault($PrinterName)
    Local $result, $strComputer, $colEvents, $np
  
    If GetDefaultPrinter() = $PrinterName Then Return 1
    $result = 0
    $strComputer = "."
    If $objWMIService = 0 Then $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
    $colEvents = $objWMIService.ExecQuery _
            (StringFormat('Select * From Win32_Printer')); Where DeviceID = "%s"', $PrinterName));TRUE
    $np = 0
    For $objPrinter in $colEvents
        If $objPrinter.DeviceID = $PrinterName Then
            $objPrinter.SetDefaultPrinter()
            $result = 1
        EndIf
      
    Next
    If $result Then
        ;GUICtrlSetData($IPCurrentDefault,$currentPrinter)
    EndIf
    Return $result

EndFunc
