#include <GUIConstants.au3>
#include <GuiListView.au3>

Opt("GUIOnEventMode", 1)

Global $width = 513					; Width must be (a power of 2) + 1 (For example: 512+1 = 513)
Global $points[$width]				; Used to store a height for every widthpixel
Global $divisions = -1				; Displace this many times. Number of 'lines' will be at least (2^($divisions)) and max ($width-1)
Global $leftHeight = 200			; Sets the leftmost pixel's height
Global $rightHeight = 300			; Sets the rightmost pixel's height
Global $heightDisplacement = 200	; Maximum heightdifference from a midpoint
Global $roughness = 0.2				; Float from 0 to 1. Smaller means rougher terrain
Global $segments					; Used to keep track of how many segments to draw

; --- GUI ---
$gui = GUICreate("MidpointDisplacement", 1152, 610)
; --- Graphic ---
$graphicTerrain = GUICtrlCreateGraphic(10, 10, 512, 500)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
; --- Buttons ---
$buttonTerrain = GUICtrlCreateButton("MakeTerrain", 10, 520, 80, 20)
GUICtrlSetOnEvent(-1, "_MakeTerrain")
$buttonClearGraphic = GUICtrlCreateButton("ClearGraphic", 10, 550, 80, 20)
GUICtrlSetOnEvent(-1, "_DrawClear")
;~ $buttonDrawTest = GUICtrlCreateButton("DrawTest", 10, 580, 80, 20)
;~ GUICtrlSetOnEvent(-1, "_DrawTest")
; --- Inputs ---
$inputWidth = GUICtrlCreateInput($width, 100, 520, 80, 20)
GUICtrlSetTip(-1, "$width" & @CRLF & "Width must be (a power of 2) + 1. For example: 512+1 = 513"  & @CRLF & "Actual width of image is (this width)-1")
$inputHeightDisplacement = GUICtrlCreateInput($heightDisplacement, 100, 550, 80, 20)
GUICtrlSetTip(-1, "$heightDisplacement" & @CRLF & "Maximum heightdifference from a midpoint.")
$inputRoughness = GUICtrlCreateInput($roughness, 100, 580, 80, 20)
GUICtrlSetTip(-1, "$roughness" & @CRLF & "Float from 0 to 1. Smaller means rougher terrain.")
$inputLeftHeight = GUICtrlCreateInput($leftHeight, 200, 520, 80, 20)
GUICtrlSetTip(-1, "$leftHeight" & @CRLF & "Sets the leftmost pixel's height.")
$inputRightHeight = GUICtrlCreateInput($rightHeight, 200, 550, 80, 20)
GUICtrlSetTip(-1, "$rightHeight" & @CRLF & "Sets the rightmost pixel's height.")
$inputDivisions = GUICtrlCreateInput($divisions, 200, 580, 80, 20)
GUICtrlSetTip(-1, "$divisions" & @CRLF & "Displace this many times. Number of 'lines' will be at least (2^($divisions)) and max ($width-1)." & @CRLF & "Negative values gives max number of lines")
; --- Misc Debug ---
$editDebug = GUICtrlCreateEdit("", 532, 10, 300, 500)
$buttonClearDebugEdit = GUICtrlCreateButton("ClearDebugEdit", 532, 520, 150, 20)
GUICtrlSetOnEvent(-1, "_DebugEditClear")
$checkEditDebug = GUICtrlCreateCheckbox("Display debug (=slower)", 692, 520, 150, 20)

$listViewDebug = GUICtrlCreateListView("X|Y (int)|Y (float)", 842, 10, 300, 500, $LVS_SORTASCENDING)
_GUICtrlListViewSetColumnWidth($listViewDebug, 0, 50)
_GUICtrlListViewSetColumnWidth($listViewDebug, 1, 50)
_GUICtrlListViewSetColumnWidth($listViewDebug, 2, 150)
$buttonClearDebugListView = GUICtrlCreateButton("ClearDebugListView", 842, 520, 150, 20)
GUICtrlSetOnEvent(-1, "_DebugListViewClear")
$checkListViewDebug = GUICtrlCreateCheckbox("Display debug (=slower)", 1002, 520, 150, 20)
; --- Show GUI ---
GUISetState(@SW_SHOW, $gui)

GUISetOnEvent($GUI_EVENT_CLOSE,"_Exit")

While True
	Sleep(100)
WEnd

Func _MakeTerrain()
	_SetGlobals()
	_DebugEditClear()
	_DebugListViewClear()
	_DisplaceMidpoints()
	_DrawTerrain()
EndFunc

Func _SetGlobals()
	$width = GUICtrlRead($inputWidth)
	ReDim $points[$width]
	$leftHeight = GUICtrlRead($inputLeftHeight)
	$rightHeight = GUICtrlRead($inputRightHeight)
	$heightDisplacement = GUICtrlRead($inputHeightDisplacement)
	$roughness = GUICtrlRead($inputRoughness)
	$divisions = GUICtrlRead($inputDivisions)
EndFunc

Func _DisplaceMidpoints()
	$ratio = 2^(-$roughness)			; Gives a ratio from 0.5 to 1 which is used to decrase the heightDisplacement.
	$scale = 1							; Starting % of $heightDisplacement to use. 1 means first displacement will be equal to $heightDisplacement
	$lastPoint = $width - 1				; The index on the last element in the $points array
	$stepSize = $lastPoint				; Sets initial step size to half the width.
	$points[0] = $leftHeight			; Sets leftmost pixels height to $leftHeight
	$points[$lastPoint] = $rightHeight	; Sets rightmost pixels height to $rightHeight
	
	_PrintListView(_ZeroFill(0, 4) & "|" & Round($points[0]) & "|" & $points[0])
	_PrintListView(_ZeroFill($lastPoint, 4) & "|" & Round($points[$lastPoint]) & "|" & $points[$lastPoint])

	$divisionsLeft = $divisions
	While ($stepSize > 1) AND ($divisionsLeft <> 0)
		For $i = $stepSize/2 To ($lastPoint-1) Step $stepSize
			$endpointsAverage = ($points[$i-$stepSize/2] + $points[$i+$stepSize/2]) / 2 ;Average height of segments endpoints.
			$points[$i] = $endpointsAverage + Random(-1,1)*$heightDisplacement*$scale
			_PrintListView(_ZeroFill($i, 4) & "|" & Round($points[$i]) & "|" & $points[$i])
			$scale = $scale * $ratio
		Next
		$stepSize = $stepSize/2
		$divisionsLeft -= 1
	WEnd
	
	; Check if the above loop set values for every x-pixel (if it reached $stepSize == 2)
	If $divisionsLeft <> 0 Then
		$segments = $width-1
	Else
		$segments = 2^($divisions)
	EndIf
	_PrintDebug("Segments=" & $segments)
	
EndFunc

Func _DrawTerrain()
	GUICtrlSetColor($graphicTerrain, 0x000000)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_MOVE, 0, Round($points[0]))
	$debugString = ""
	For $i = 1 To $width-1
		If ($segments == $width-1) Or (Mod($i, ($width-1)/$segments) == 0) Then
			$debugString = $debugString & "Drawing line to (" & $i & "," & Round($points[$i]) & ")" & @CRLF
			GUICtrlSetGraphic($graphicTerrain, $GUI_GR_LINE, $i, $points[$i])
		EndIf
	Next
	_PrintDebug($debugString)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_REFRESH)
EndFunc

Func _DrawClear()
	GUICtrlDelete($graphicTerrain)
	$graphicTerrain = GUICtrlCreateGraphic(10, 10, 512, 500)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_REFRESH)
EndFunc

Func _DrawTest()
	GUICtrlSetColor($graphicTerrain, 0x000000)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_MOVE, 100, 100)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_LINE, 100, 200)
	GUICtrlSetGraphic($graphicTerrain, $GUI_GR_REFRESH)
EndFunc

Func _PrintDebug($text)
	If BitAnd(GUICtrlRead($checkEditDebug),$GUI_CHECKED) == $GUI_CHECKED Then
		GUICtrlSetData($editDebug, GUICtrlRead($editDebug) & $text & @CRLF)
	EndIf
EndFunc

Func _PrintListView($text)
	If BitAnd(GUICtrlRead($checkListViewDebug),$GUI_CHECKED) == $GUI_CHECKED Then
		GuiCtrlCreateListViewItem($text, $listViewDebug)
	EndIf
EndFunc

Func _DebugEditClear()
	GUICtrlSetData($editDebug, "")
EndFunc

Func _DebugListViewClear()
	_GUICtrlListViewDeleteAllItems($listViewDebug)
EndFunc

Func _ZeroFill($nr, $zeros)
	$string = string($nr)
	While StringLen($string) < $zeros
		$string = "0" & $string
	WEnd
	Return $string
EndFunc

Func _Exit()
	Exit
EndFunc