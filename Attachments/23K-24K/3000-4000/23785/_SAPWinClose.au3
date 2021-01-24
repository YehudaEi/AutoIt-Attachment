#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Create a new session and attach to it, and run transaction "pa30"
_SAPSessCreate("pa30")

; Close the "Maintain HR Master Data" window.
_SAPWinClose("Maintain HR Master Data")

; The "Maintain HR Master Data" window should no longer be displayed.
