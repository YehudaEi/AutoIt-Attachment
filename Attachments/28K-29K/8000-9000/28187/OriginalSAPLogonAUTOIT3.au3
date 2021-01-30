; Start SAP
Run("C:\Program Files\sap\FrontEnd\SAPgui\saplogon.exe")

; Wait until SAP is open
WinWaitActive ("SAP Logon 710")

; Choose '04'
Send ("04{ENTER}")


WinWait ("Copyright") 

; Enter OK
Send ("{ENTER}")

; Wait until SAP Easy Access window is open
WinWait ("SAP Easy Access")

#include <Excel.au3>
$oExcel = _ExcelBookOpen("U:\Database\2009 Stuff\YPRODCOSTii.xlsm")
$oExcel.Run("YPRODCOST_MACRO")
