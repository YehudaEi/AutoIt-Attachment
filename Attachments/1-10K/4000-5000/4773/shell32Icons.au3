#include <GUIConstants.au3>

GUICreate("Icons in Shell32.dll",910,800)
$ExitBtn = GUICtrlCreateButton("",840,740,40,40, $BS_ICON)
GUICtrlSetImage(-1,"Shell32.dll",27)

$X = 20
$Y = 25
$Count = 0
For $i = 0 To 237
	$icon = GUICtrlCreateIcon("shell32.dll",$i, $X, $Y)
	$label = GUICtrlCreateLabel($i, $X+10, $Y+35,30,14)
	$X = $X + 40
	$Count = $Count + 1
	If $Count = 22 Then 
		$Count = 0
		$X = 25
		$Y = $Y + 67
	EndIf	
Next

GUISetState ()

While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE  Or $Msg = $ExitBtn Then ExitLoop
Wend





