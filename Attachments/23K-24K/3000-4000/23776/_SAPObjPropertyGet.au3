#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Put the value "/npa30" into the command field.
_SAPObjValueSet("tbar[0]/okcd", "/npa30")

; Collapse the command field.
_SAPObjPropertySet("tbar[0]/okcd", "opened", False)

; Get the command field's opened state.
ConsoleWrite("Command field opened state = " & _SAPObjPropertyGet("tbar[0]/okcd", "opened") & @CRLF)

; Wait for 3 seconds
Sleep(3000)

; Expand the command field.
_SAPObjPropertySet("tbar[0]/okcd", "opened", True)

; Get the command field's opened state.
ConsoleWrite("Command field opened state = " & _SAPObjPropertyGet("tbar[0]/okcd", "opened") & @CRLF)
