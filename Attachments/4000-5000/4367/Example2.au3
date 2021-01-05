; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1 Beta
; Author:         Christoph Krogmann <Ch.Krogmann@gmx.de>
;
; Script Function: Example for FfLoadWaitTime function.
;	
;
; ----------------------------------------------------------------------------
#include <FfLoad2.au3>

$path = "start your URL"
Run(@ComSpec & " /c " & $path, "", @SW_HIDE)
Opt("WinTitleMatchMode", 2)
WinWait("Mozilla Firefox")
WinSetState("Mozilla Firefox", "", @SW_MAXIMIZE)
$load = _FfLoadWaitTime(820, 732, 1) ;<<-- Put in your coordinates here
If $Load = 1 Then
	MsgBox(0, "Failed", "Load failed")
Else	
    MsgBox(0, "Finished", "Load is finished")
EndIf
Exit
