#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Put the value "/npa30" into the command field.
_SAPObjValueSet("tbar[0]/okcd", "/npa30")

; Press the "Enter" key.
_SAPVKeysSend("Enter")

; The transaction "pa30" runs, and the window "Maintain HR Master Data" should be displayed.

; Put the value "18" into the "Person ID" field.
_SAPObjValueSet("usr/subSUBSCR_PERNR:SAPMP50A:0120/ctxtRP50G-PERSONID_EXT", "18")

; Get the value of the "Person ID" field.
ConsoleWrite("""Person ID"" = " & _SAPObjValueGet("usr/subSUBSCR_PERNR:SAPMP50A:0120/ctxtRP50G-PERSONID_EXT") & @CRLF)

; Get the value of the "Period" radio button.
ConsoleWrite("""Period"" = " & _SAPObjValueGet("usr/tabsMENU_TABSTRIP/tabpTAB01/ssubSUBSCR_MENU:SAPMP50A:0400/subSUBSCR_TIME:SAPMP50A:0330/btnTIMEBUTTON_TXT") & @CRLF)

; Get the value of the "Infotype" label.
ConsoleWrite("""Infotype label"" = " & _SAPObjValueGet("usr/tabsMENU_TABSTRIP/tabpTAB01/ssubSUBSCR_MENU:SAPMP50A:0400/subSUBSCR_ITKEYS:SAPMP50A:0350/lblRP50G-CHOIC") & @CRLF)

; Get the value of the command field.
ConsoleWrite("""Command field"" = " & _SAPObjValueGet("tbar[0]/okcd") & @CRLF)

; Get the value of the status bar.
ConsoleWrite("""Status bar"" = " & _SAPObjValueGet("sbar") & @CRLF)

; Get the value of the "Name" field.
ConsoleWrite("""Name"" = " & _SAPObjValueGet("usr/subSUBSCR_HEADER:/1PAPAXX/HDR_90060A:0100/txt$_DG01_900A60_DAT_P0001_ENAME") & @CRLF)

; Select the "System -> Own Jobs" menu item.
_SAPObjSelect("mbar/menu[6]/menu[9]")

; Attach to the newly opened session with the window titled "Job Overview".
_SAPSessAttach("Job Overview")

; Get the text array from the GuiUserArea and display it in a pop-up to the user.
$guiuserarea = _SAPObjValueGet("usr")
_ArrayDisplay($guiuserarea, "Result from ""_SAPObjValueGet(""usr"") on the session ""Job Overview""")
