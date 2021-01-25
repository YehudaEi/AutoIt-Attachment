#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIComboBox.au3>
#include <WindowsConstants.au3>
#include <GuiTab.au3>
#include <Array.au3>
#include <String.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>
Global $tab[1], $inp[2], $inp2[2], $info[2][60], $B1[2], $b2[2]
Global $input[2][60], $radio[2][13], $ntype[2][10], $hr_array[1][1]
$xx=10
$Pos2 = 600 + $xx
$pos3 = 720

$Form1 = GUICreate("Inventory", $Pos2, $pos3, -1, -1)
GUISetBkColor(0xFFFFFF)
GUICtrlCreateLabel("Inventory Tracking Cover sheet", 176 + $xx, 0, 252, 20)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
#Region ### START Koda GUI section ### Form=
$tab[0] = GUICtrlCreateTab(5, 20, $Pos2 - 5, $pos3 - 10)
GUICtrlCreateTabItem("Sheet 1")
$types = _ArrayCreate("", "Desktop", "Laptop", "Monitor 1", "Monitor 2", "Port Replicator", "Printer", "")
$labloc = _ArrayCreate("", "", "", "", "", "", "", "")
setupscreen(1) ; setup first Screen

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
_WinAPI_EnableWindow($Form1, True)
$Ntabs = _GUICtrlTab_GetItemCount($tab[0])
$x = _GUICtrlTab_GetCurSel($tab[0]) + 1
;consolewrite($x&@lf)
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit
Case $B1[$x]
For $xt = 1 To UBound($info, 1) - 1
		For $i = 1 To Ubound($info,2)-1
			$info[$xt][$i] = GUICtrlRead($input[$xt][$i])
		Next
	next
_arraydisplay($info)
Exit

Case $b2[$x]

createtab()

Case $input[$x][2], $input[$x][6]
$temp = StringStripWS(GUICtrlRead($nMsg), 8)
$temp = "Colunm2 WORKED"
GUICtrlSetData($nMsg, $temp)
ControlFocus("Inventory", "", $nMsg + 1)
$cursor = ControlGetFocus("Inventory")
Case $input[$x][3], $input[$x][7]
$temp = StringStripWS(GUICtrlRead($nMsg), 8)
$temp = "Colunm3 WORKED"
GUICtrlSetData($nMsg, $temp)
ControlFocus("Inventory", "", $nMsg + 1)

EndSwitch
WEnd


Func createtab()
$x = _GUICtrlTab_GetItemCount($tab[0])
_ArrayAdd($tab, GUICtrlCreateTabItem("Sheet " & $x + 1))
ReDim $input[$x + 1 + 1][60], $radio[$x + 1 + 1][13], $ntype[$x + 1 + 1][10], $info[$x + 1 + 1][60]
_ArrayAdd($B1, "")
_ArrayAdd($b2, "")
setupscreen($x + 1)
EndFunc ;==>createtab

func SetupScreen($t)
$B1[$t] = GUICtrlCreateButton("Submit", 150 + $xx, 665, 50, 24)
$b2[$t] = GUICtrlCreateButton("Next Sheet", 348 + $xx, 665, 100, 24)

$labcnt = 0
	$adj = 10
	For $Lloop = 212 To 424 Step 32
		$labcnt = $labcnt + 1
		$labloc[$labcnt] = $Lloop - $adj
		GUICtrlCreateLabel($types[$labcnt], 0 + $xx, $labloc[$labcnt], 50, 30)
		GUICtrlCreateLabel("Asset Tag #:", 125 + $xx, $labloc[$labcnt], 72, 21)
		GUICtrlCreateLabel("Serial#:", 300 + $xx, $labloc[$labcnt], 45, 21)
		GUICtrlCreateLabel("Model#:", 450 + $xx, $labloc[$labcnt], 40, 21)
		if $labcnt=2 then exitloop
	Next
	$labcnt=1
For $Lloop = 1 To 2
		
		
		$input[$t][$labcnt] = GUICtrlCreateInput("", 72 + $xx, $labloc[$Lloop], 41, 21);Colunm1
		
		$input[$t][$labcnt + 1] = GUICtrlCreateInput("", 190 + $xx, $labloc[$Lloop], 100, 21);Colunm2
		
		$input[$t][$labcnt + 2] = GUICtrlCreateInput("", 340 + $xx, $labloc[$Lloop], 100, 21);Colunm3
		
		$input[$t][$labcnt + 3] = GUICtrlCreateInput("", 496 + $xx, $labloc[$Lloop], 97, 21);Column 4
		$labcnt = $labcnt + 4
	Next

GUICtrlCreateTabItem("")
EndFunc ;==>setupscreen