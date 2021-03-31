#RequireAdmin

Dim $sResult
$strComputer = "."

$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
$colItems = $objWMIService.ExecQuery("Select * from Win32_DiskDrive")

For $objItem In $colItems

	$sResult &= "" & $objItem.Caption & @LF & " (" & Int($objItem.Size / 1024 ^ 3) & "GB) |"


Next

#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


$Form1 = GUICreate("Form1", 615, 438, -1, -1)

$Combo1 = GUICtrlCreateCombo("Kies schijf...", 128, 200, 250, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetData($Combo1, "===============================")
	GUICtrlSetData($Combo1, $sResult)

$START = GUICtrlCreateButton("START", 60, 300)


GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $START
			START()
	EndSwitch
WEnd

Func START()
	$VAR = GUICtrlRead($Combo1)

MsgBox(4096, "Read", "Uitgelezen model: " & $VAR)

EndFunc