#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Press "Shift+F3"
_SAPVKeysSend("Shift+F3")

; Attach to the session with the window titled "Log Off"
_SAPSessAttach("Log Off")

; Wait for 3 seconds
Sleep(3000)

; Click "No"
_SAPObjSelect("usr/btnSPOP-OPTION2")

; The "Log Off" window is no longer displayed.
