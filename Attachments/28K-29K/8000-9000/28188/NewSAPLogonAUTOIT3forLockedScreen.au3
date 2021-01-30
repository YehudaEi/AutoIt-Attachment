; Start SAP
Run("C:\Program Files\sap\FrontEnd\SAPgui\saplogon.exe")

; Wait until SAP is open
WinWait ("SAP Logon 710")

; Choose '04'
;ControlSend("SAP Logon 710", "P08 Finance (Secure)", "", "04{ENTER}")
ControlSend("SAP Logon 710", "", "", "04{ENTER}")
;ControlSend("Tile", "text", controlID, "string" [, flag] )


WinWait ("Copyright") 

; Enter OK
ControlSend("Copyright", "", "", "{ENTER}")

; Wait until SAP Easy Access window is open
WinWait ("SAP Easy Access")

#include <Excel.au3>
$oExcel = _ExcelBookOpen("U:\Database\2009 Stuff\YPRODCOSTii.xlsm")
$oExcel.Run("YPRODCOST_MACRO")



