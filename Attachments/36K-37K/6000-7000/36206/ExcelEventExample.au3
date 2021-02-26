

#region - #INCLUDES & CONSTANTS#===================================================================================

#include "ExcelEvent.au3"
#include <WindowsConstants.au3>

Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

#endregion - #INCLUDES & CONSTANTS#===================================================================================



#region - #MAIN CODE#===============================================================================================

$oExcel = _ExcelBookNew()

; GUI for ending the script
Local $hDataOk = GUICreate("End script", 100, 50, -1, -1, -1, $WS_EX_TOOLWINDOW)
Local $hDataOkButton = GUICtrlCreateButton("End script", -1, -1)
WinSetOnTop($hDataOk, "", 1)
GUISetState()


_ExcelEvent($oExcel, "SheetActivate", "myFunction")
_ExcelEvent($oExcel, "Open", "myFunction")
_ExcelEvent($oExcel, "NewSheet", "myFunction")
_ExcelEvent($oExcel, "SheetChange", "myFunction")
_ExcelEvent($oExcel, "SheetActivate", "myFunction") ; already registered
If @error Then ConsoleWrite("-> Error at line: "&@ScriptLineNumber & ". Error code: " & @error & @LF)
_ExcelEvent($oExcel, "SheetBeforeDoubleClick", "myFunction")
_ExcelEvent($oExcel, "SheetBeforeRightClick", "myFunction")
_ExcelEvent($oExcel, "SheetActivate", "secondFunction")
_ExcelEvent($oExcel, "SheetDeactivate", "myFunction")
_ExcelEvent($oExcel, "Activate", "myFunction")
_ExcelEvent($oExcel, "BeforeClose", "myFunction")
_ExcelEvent($oExcel, "BeforePrint", "myFunction")
_ExcelEvent($oExcel, "BeforeClose", "myFunction")

_ExcelUnEvent("SheetActivate", "secondFunction")
If @error Then ConsoleWrite("-> Error at line: "&@ScriptLineNumber & ". Error code: " & @error & @LF)



While 1
	$msg = GUIGetMsg()
	If $msg = $hDataOkButton Then ExitLoop
WEnd

GUIDelete($hDataOk)
Exit


#endregion - #MAIN CODE#===============================================================================================



#region - #FUNCTIONS#=====================================================================================================


Func myFunction($data = "")
	ConsoleWrite("myFunction got data: " & $data & @LF)
EndFunc   ;==>myFunction

Func secondFunction($data = "")
	ConsoleWrite("secondFunction got data: " & $data & @LF)
EndFunc   ;==>secondFunction


Func MyErrFunc()

	ConsoleWrite("We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext)

	Local $err = $oMyError.number
	If $err = 0 Then $err = -1

EndFunc   ;==>MyErrFunc



#endregion - #FUNCTIONS#=====================================================================================================




