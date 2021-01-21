#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>

Func _ArraySize( $aArray )
	SetError( 0 )
	
	$index = 0
	
	Do
		$pop = _ArrayPop( $aArray )
		$index = $index + 1
	Until @error = 1
	
	Return $index - 1
EndFunc

Func getLoc()
	ControlClick("WoWEmuHacker", "", "Button24")
	$m = ControlGetText("WoWEmuHacker", "", "Edit12")
	$x = ControlGetText("WoWEmuHacker", "", "Edit9")
	$y = ControlGetText("WoWEmuHacker", "", "Edit10")
	$z = ControlGetText("WoWEmuHacker", "", "Edit11")
	GUICtrlSetData($mInput, $m)
	GUICtrlSetData($xInput, $x)
	GUICtrlSetData($yInput, $y)
	GUICtrlSetData($zInput, $z)
EndFunc

Func createLocFile()
	If FileOpen ("locations.txt", 1) == -1 Then
		_FileCreate("locations.txt")
		createLocFile()
	EndIf
EndFunc

Func countBeginningDots($string)
	$var = $string
	$j = 0
	While StringLeft($var, 1) == "."
		$j = $j + 1
		$var = StringTrimLeft ($var, 1)
	WEnd
	return $j
EndFunc

Func deleteBeginningDots($string)
	$var = $string
	$j = 0
	While StringLeft($var, 1) == "."
		$j = $j + 1
		$var = StringTrimLeft ($var, 1)
	WEnd
	return $var
EndFunc

	Dim $treeItems[1000]
Func buildTree()

	Dim $dots[50]
	$treeItems[0] = "New root category"
	$i = 1	
	While 1
		$treeItems[$i] = FileReadLine("locations.txt", $i)
		If @error = -1 Then ExitLoop
		$i = $i + 1
	Wend
	$treeItems[0] = GUICtrlCreateTreeViewItem($treeItems[0], $treeview)
	
	$dots[0] = 0
	$j = 1
	While $treeItems[$j] <> ""
		$numOfDots = countBeginningDots($treeItems[$j])
		$lastSurCatIndexIndex = $numOfDots-1
		$lastSurCatIndex = $dots[$lastSurCatIndexIndex]
		$treeItems[$j] = GUICtrlCreateTreeViewItem(deleteBeginningDots($treeItems[$j]), $treeItems[$lastSurCatIndex])
		$dots[$numOfDots] = $j
		$j = $j + 1
	WEnd
	GUICtrlSetState($treeItems[0], $GUI_EXPAND)
	GUISetState()
EndFunc

GUICreate("Teleportlist", 265, 410)
$treeview = GUICtrlCreateTreeView(0, 5, 175, 300, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
$getLocButton = GUICtrlCreateButton ("Get Loc", 190, 5, 70, 20)
$mInput = GUICtrlCreateInput ("", 190, 30, 70, 20)
$xInput = GUICtrlCreateInput ("", 190, 55, 70, 20)
$yInput = GUICtrlCreateInput ("", 190, 80, 70, 20)
$zInput = GUICtrlCreateInput ("", 190, 105, 70, 20)
$nInput = GUICtrlCreateInput ("Enter Name", 190, 130, 70, 20)
$mLabel = GUICtrlCreateLabel ("M", 180, 34, 10, 20)
$xLabel = GUICtrlCreateLabel ("X", 180, 59, 10, 20)
$yLabel = GUICtrlCreateLabel ("Y", 180, 84, 10, 20)
$zLabel = GUICtrlCreateLabel ("Z", 180, 109, 10, 20)
$addLocButton = GUICtrlCreateButton ("Add Loc", 190, 155, 70, 20)
$catInput = GUICtrlCreateInput ("Catname", 190, 185, 70, 20)
$addCatButton = GUICtrlCreateButton ("Add Cat", 190, 210, 70, 20)

createLocFile()
buildTree()

GUISetState (@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Switch $msg
		case $GUI_EVENT_CLOSE 
			ExitLoop
		case $getLocButton
			getLoc()
		case $addLocButton
			addLoc()
		case $addCatButton
			addCat()
		EndSwitch
Wend