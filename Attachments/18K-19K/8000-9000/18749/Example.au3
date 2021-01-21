#include <GUIConstants.au3>
#include <Array.au3>
#include <UDF.au3>

Local $sName = GenName (10)
$Form1 = GUICreate($sName, 509, 355, 193, 115)
_ScriptComAttachRecv($Form1, "_MRecv")
$Group1 = GUICtrlCreateGroup("Send Message", 0, 0, 505, 113)
$Label1 = GUICtrlCreateLabel("Window Title: ", 8, 24, 72, 17)
$Input1 = GUICtrlCreateInput("", 80, 24, 417, 21)
$Input2 = GUICtrlCreateInput("", 8, 56, 489, 21)
$Button1 = GUICtrlCreateButton("Send Message", 160, 80, 171, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Edit1 = GUICtrlCreateEdit($sName, 0, 120, 505, 233)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section 

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			_ScriptComSend(GUICtrlRead($Input1), GUICtrlRead($Input2), $Form1)
	EndSwitch
WEnd

Func _MRecv($hwnd, $msg)
	GUICtrlSetData($Edit1, "[" & WinGetTitle($hwnd) & "]: " & $msg & @CRLF, 1)
EndFunc

Func GenName($sLen)
	Local $sRet
	Local $sGen = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"
	For $i = 1 To $sLen Step 1
		$sRet &= StringMid($sGen, Random(0, StringLen($sGen)), 1)		
	Next
	Return $sRet
EndFunc