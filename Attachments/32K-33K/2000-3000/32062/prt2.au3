#Include <File.au3>
#include <GUIConstants.au3>
Global $objWMIService, $IPCurrentDefault, $currentPrinter, $printer, $PrinterName, $result
$result = GetPrinterList()
$IniPrinterB = IniRead("test1.txt","Printers","Black","")
$IniPrinterC = IniRead("test1.txt","Printers","Color","")

$IniPrinterPB = IniRead("test1.txt","PrintersProfile","Black","")
$IniPrinterPC = IniRead("test1.txt","PrintersProfile","Color","")

$Form1 = GUICreate("Printer Setup", 300, 280, 193, 115)

$blackp_group = GUICtrlCreateGroup("Set B&&W Printer", 10, 10, 280, 115)
GUIStartGroup("Set Black And White Printer")

$ComboB = GUICtrlCreateCombo($IniPrinterB, 20, 30, 260, 45)
GUICtrlSetData($ComboB, $result)

GUICtrlCreateGroup("Set Printer Profile", 20, 60, 260, 55)

$ComboPB = GUICtrlCreateCombo($IniPrinterPB, 30, 80, 240, 45)
GUICtrlSetData($ComboPB, "Profile 1|Profile 2")

GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

$colorp_group = GUICtrlCreateGroup("Set Color Printer", 10, 135, 280, 115)
GUIStartGroup("Set Color Printer")

$ComboC = GUICtrlCreateCombo($IniPrinterC, 30, 155, 240, 45)
GUICtrlSetData($ComboC, $result)

GUICtrlCreateGroup("Set Printer Profile", 20, 185, 260, 55)

$ComboPC = GUICtrlCreateCombo($IniPrinterPC, 30, 205, 240, 45)
GUICtrlSetData($ComboPC, "Profile 1|Profile 2")

GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

$Button1 = GUICtrlCreateButton("&Save", 40, 255, 100, 20, 0)
$Button2 = GUICtrlCreateButton("&Cancel", 160, 255, 100, 20, 0)

GUISetState(@SW_SHOW)




While 1
    $Msg = GUIGetMsg()
    If $Msg = $Button1 Then test()
    If $Msg = $GUI_EVENT_CLOSE Then Exit
WEnd

Func test()
    MsgBox(0, "The ComboBox Results", GUICtrlRead($ComboB) & " / " & GUICtrlRead($ComboPB) & @CRLF & GUICtrlRead($ComboC) & " / " & GUICtrlRead($ComboPC))
	IniWrite("test1.txt","Printers","Black",GUICtrlRead($ComboB))
	IniWrite("test1.txt","Printers","Color",GUICtrlRead($ComboC))
EndFunc



Func GetPrinterList()
    Local $result, $strComputer, $colEvents, $np,$result
    $strComputer = "."
    If $objWMIService = 0 Then $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
    $colEvents = $objWMIService.ExecQuery _
            (StringFormat('Select * From Win32_Printer')); Where DeviceID = "%s"', $PrinterName));TRUE
    $np = 0
    For $objPrinter in $colEvents
        $result &= $objPrinter.DeviceID & '|'
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
EndFunc;==>GetDefaultPrinter1

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
        GUICtrlSetData($IPCurrentDefault,$currentPrinter)
    EndIf
    Return $result
EndFunc