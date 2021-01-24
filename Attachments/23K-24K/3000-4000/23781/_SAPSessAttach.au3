#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Put the value "/npa30" into the command field.
_SAPObjValueSet("tbar[0]/okcd", "/npa30")

; Press the "Enter" key.
_SAPVKeysSend("Enter")

; The transaction "pa30" runs, and the window "Maintain HR Master Data" should be displayed.

; Wait for 3 seconds
sleep(3000)

; Press the "F3" key.
_SAPVKeysSend("F3")

; Attach to the session with the window titled "SAP Easy Access", and run transaction "pa30"
_SAPSessAttach("SAP Easy Access", "pa30")
