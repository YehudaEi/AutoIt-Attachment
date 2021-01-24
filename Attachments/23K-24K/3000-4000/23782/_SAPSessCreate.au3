#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Create a new session and attach to it
_SAPSessCreate()

; Another session is created with the window titled "SAP Easy Access"

; Put the value "/npa30" into the command field of this new session.
_SAPObjValueSet("tbar[0]/okcd", "/npa30")

; Press the "Enter" key.
_SAPVKeysSend("Enter")

; The transaction "pa30" runs, and the window "Maintain HR Master Data" should be displayed.
; The previous session with window titled "SAP Easy Access" should still be displayed.

; Create a new session and attach to it, and run transaction "pa20"
_SAPSessCreate("pa20")

; Three windows should now be displayed:
; 1. "SAP Easy Access"
; 2. "Maintain HR Master Data"
; 3. "Display HR Master Data"

