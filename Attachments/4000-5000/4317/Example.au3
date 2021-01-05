; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1 Beta
; Author:         Christoph Krogmann <Ch.Krogmann@gmx.de>
;
; Script Function: Example for FfLoadWait function.
;	
;
; ----------------------------------------------------------------------------
#include <FfLoad.au3>

$path = "start your URL"
Run(@ComSpec & " /c " & $path, "", @SW_HIDE)
Opt("WinTitleMatchMode", 2)
WinWait("Mozilla Firefox")
WinSetState("Mozilla Firefox", "", @SW_MAXIMIZE)
_FfLoadWait(820, 732, 1) ;<<-- Put in your coordinates here
MsgBox(0, "Finished", "Load is finished")
Exit
