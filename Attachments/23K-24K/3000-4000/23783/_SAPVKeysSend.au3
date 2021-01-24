#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Press "F1"
_SAPVKeysSend("F1")

; The SAP "Information" window is displayed

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")

; Press "Shift+F3"
_SAPVKeysSend("Shift+F3")

; Attach to the session with the window titled "Log Off"
_SAPSessAttach("Log Off")

; Wait for 3 seconds
Sleep(3000)

; Click "No"
_SAPObjSelect("usr/btnSPOP-OPTION2")

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Press "Shift+F7"
_SAPVKeysSend("Shift+F7")

; The SAP "Set start transaction" window is displayed

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")

; Press "Shift+F9"
_SAPVKeysSend("Shift+F9")

; The SAP "Settings" window is displayed

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")
