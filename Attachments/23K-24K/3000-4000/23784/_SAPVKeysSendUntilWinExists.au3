#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Press "F1" until the "Information" window is displayed
_SAPVKeysSendUntilWinExists("F1", "Information")

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")

; Press "Shift+F3" until the "Information" window is displayed
_SAPVKeysSendUntilWinExists("Shift+F3", "Log Off")

; Attach to the session with the window titled "Log Off"
_SAPSessAttach("Log Off")

; Wait for 3 seconds
Sleep(3000)

; Click "No"
_SAPObjSelect("usr/btnSPOP-OPTION2")

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Press "Shift+F7" until the "Set start transaction" window is displayed
_SAPVKeysSendUntilWinExists("Shift+F7", "Set start transaction")

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")

; Press "Shift+F9" until the "Settings" window is displayed
_SAPVKeysSendUntilWinExists("Shift+F9", "Settings")

; Wait for 3 seconds
Sleep(3000)

; Press "F12" (same as the "Esc" key)
_SAPVKeysSend("F12")
