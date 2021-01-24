#include <SAP.au3>

; Before running this script, ensure the "SAP Easy Access" window is open.

; Attach to the session with the window titled "SAP Easy Access"
_SAPSessAttach("SAP Easy Access")

; Create a new session and attach to it, and run transaction "pa30"
_SAPSessCreate("pa30")

; Check if the "Maintain HR Master Data" window is displayed.
if _SAPWinExists("Maintain HR Master Data") Then
	
	ConsoleWrite("The ""Maintain HR Master Data"" window is displayed." & @CRLF)
Else
	
	ConsoleWrite("The ""Maintain HR Master Data"" window is not displayed." & @CRLF)
EndIf
