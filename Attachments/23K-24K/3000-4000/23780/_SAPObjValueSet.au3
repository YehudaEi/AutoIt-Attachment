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

; Press the "Enter" key.
_SAPVKeysSend("Enter")

; Put the value "01.01.1980" into the "From" field.
_SAPObjValueSet("usr/tabsMENU_TABSTRIP/tabpTAB01/ssubSUBSCR_MENU:SAPMP50A:0400/subSUBSCR_TIME:SAPMP50A:0330/ctxtRP50G-BEGDA", "01.01.1980")

; Put the value "01.01.1981" into the "To" field.
_SAPObjValueSet("usr/tabsMENU_TABSTRIP/tabpTAB01/ssubSUBSCR_MENU:SAPMP50A:0400/subSUBSCR_TIME:SAPMP50A:0330/ctxtRP50G-ENDDA", "01.01.1981")

; Put the value "0000" into the "Infotype" field.
_SAPObjValueSet("usr/tabsMENU_TABSTRIP/tabpTAB01/ssubSUBSCR_MENU:SAPMP50A:0400/subSUBSCR_ITKEYS:SAPMP50A:0350/ctxtRP50G-CHOIC", "0000")

