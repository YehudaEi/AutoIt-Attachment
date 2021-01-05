
#include <GUIConstants.au3>
#include <math.au3>

; Core code is JdeB's _ArrayAdd function... Couldn't find a UDF for appending arrays,
; and I figured calling _ArrayAdd repeatedly would just be silly.
; maybe this is worthy of addition to Array.au3?
; This is at the top because my versions of the GUICtrlXYZ functions use it
; See the end of the code for other Array functions
Func _ArrayAppend(ByRef $avArray1, $avArray2)
	If IsArray($avArray1) And IsArray($avArray2) Then
		$iSizeofArray1 = UBound($avArray1)
		$iSizeofArray2 = UBound($avArray2)
		ReDim $avArray1[$iSizeofArray1 + $iSizeofArray2]
		For $iLoopIndex = 0 To $iSizeofArray2 - 1
		    $avArray1[$iSizeofArray1 + $iLoopIndex] = $avArray2[$iLoopIndex]
		Next
		SetError(0)
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_ArrayAppend

; GUICtrlXYZ Functions begin here

Func GUICtrlDeleteGroup ($controlGroup)
  $sizeofArray = UBound ($controlGroup)
  If @error then Return 0
  For $i = 0 to $sizeofArray - 1
    GUICtrlDelete($controlGroup[$i])
  Next
  Return 1
EndFunc

; Added this just so that _ArrayAppend never gets called from the example code
Func GUICtrlAddToGroup (ByRef $controlGroup, $newControlIDs)
  _ArrayAppend ($controlGroup, $newControlIDs)
EndFunc

Func GUICtrlCreateLine($x1, $y1, $x2, $y2, $size = 1, $color = "0x000000")
  $deltaX = $x2 - $x1
  $deltaY = $y2 - $y1
  $length = _Ceil (Sqrt ($deltaX*$deltaX + $deltaY*$deltaY))
  $incDeltaX = $deltaX/$length
  $incDeltaY = $deltaY/$length
  Dim $controlIDs[$length + 1]
  For $i = 0 to $length
	$controlIDs[$i] = GUICtrlCreateLabel("", $x1 + $incDeltaX*$i, $y1 + $incDeltaY*$i, $size, $size)
	If Not $controlIDs[$i] Then
	  GUICtrlDeleteGroup ($controlIDs)
	  SetError(1)
	  Dim $controlIDs[1]
	  $controlIDs[0] = 0
	  Return $controlIDs
	EndIf
    GUICtrlSetBkColor($controlIDs[$i], $color)
  Next
  Return $controlIDs
EndFunc

Func GUICtrlCreateRectangle($x1, $y1, $x2, $y2, $size = 1, $color = "0x000000")
  $controlIDs0 = GUICtrlCreateLine($x1, $y1, $x2, $y1, $size, $color)
  If @error Then Return $controlIDs0
  $controlIDs1 = GUICtrlCreateLine($x2, $y1, $x2, $y2, $size, $color)
  If @error Then
	GUICtrlDeleteGroup ($controlIDs0)
	SetError (1)
	Dim $controlIDs0[1]
	$controlIDs0[0] = 0
	Return $controlIDs0
  Else
	GUICtrlAddToGroup ($controlIDs0, $controlIDs1)
  EndIf
  $controlIDs1 = GUICtrlCreateLine($x2, $y2, $x1, $y2, $size, $color)
  If @error Then
	GUICtrlDeleteGroup ($controlIDs0)
	SetError (1)
	Dim $controlIDs0[1]
	$controlIDs0[0] = 0
	Return $controlIDs0
  Else
	GUICtrlAddToGroup ($controlIDs0, $controlIDs1)
  EndIf
  $controlIDs1 = GUICtrlCreateLine($x1, $y2, $x1, $y1, $size, $color)
  If @error Then
	GUICtrlDeleteGroup ($controlIDs0)
	SetError (1)
	Dim $controlIDs0[1]
	$controlIDs0[0] = 0
	Return $controlIDs0
  Else
	GUICtrlAddToGroup ($controlIDs0, $controlIDs1)
  EndIf
  Return $controlIDs0
EndFunc

Func GUICtrlCreateOval($x1, $y1, $x2, $y2, $size = 1, $color = "0x000000")
  $deltaX = $x2 - $x1
  $deltaY = $y2 - $y1
  If $deltaX < 1 Or $deltaY < 1 Then
	Dim $controlIDs[1]
	Return $controlIDs
  EndIf
  $centerX = $x2 - $deltaX/2
  $centerY = $y2 - $deltaY/2
  $radiusX = Abs ($centerX - $x1)
  $radiusY = Abs ($centerY - $y1)
  $px = $centerX + Cos(0)*$radiusX
  $py = $centerY + Sin(0)*$radiusY
  $deltaTheta = $piX2/$radiusX  ; This needs to be better thought through
  $first = 1
  For $theta = $deltaTheta To $piX2 + $deltaTheta Step $deltaTheta
	$nx = $centerX + Cos($theta)*$radiusX
	$ny = $centerY + Sin($theta)*$radiusY
    $controlIDsTemp = GUICtrlCreateLine($px, $py, $nx, $ny, $size, $color)
	If @error Then
	  If Not $first Then GUICtrlDeleteGroup ($controlIDs)
	  SetError (1)
	  Dim $controlIDs[1]
	  $controlIDs[0] = 0
	  Return $controlIDs
    EndIf
    If $first Then
	  $sizeofControlArray = UBound($controlIDsTemp)
	  Dim $controlIDs[$sizeofControlArray]
	  For $i = 0 To $sizeofControlArray - 1
		$controlIDs[$i] = $controlIDsTemp[$i]
	  Next
	  $controlIDs = $controlIDsTemp
	  $first = 0
    Else
	  GUICtrlAddToGroup ($controlIDs, $controlIDsTemp)
	EndIf
	$px = $nx
	$py = $ny
  Next
  Return $controlIDs
EndFunc

; GUICtrlXYZ Functions End and Example usage Begins

; Setup GUI
GUICreate("Doodle")
$fbutton = GUICtrlCreateButton("Freehand", 10, 10, 60, 20)
$lbutton = GUICtrlCreateButton("Line", 80, 10, 60, 20)
$rbutton = GUICtrlCreateButton("Rectangle", 150, 10, 60, 20)
$cbutton = GUICtrlCreateButton("Oval", 220, 10, 60, 20)
$ubutton = GUICtrlCreateButton("Undo", 290, 10, 60, 20)
$label = GUICtrlCreateLabel("", 10, 40, 360, 15)
GUISetState()

; Initialize stuff
$nextControlGroup = 0
$oldestControlGroup = 0
$lastControlGroup = 0
$maxControlGroups = 40 ; arbitrary... you run out of controls so fast anyway
$maxControlsPerGroup = 2000 ; arbitrary.. if too low: you may run out, if too high: serious lag
Dim $controlGroupIDs[$maxControlGroups][$maxControlsPerGroup]
$piX2 = 2*3.14159265358979
$mode = 0 ; default to Freehand mode
Dim $points[2][2]
$pointsSet = 0
Dim $tips[4]
$tips[0] = "Click, Hold and Move Mouse to Draw Freehand"
$tips[1] = "Click Each End Point to Draw a Line"
$tips[2] = "Click Opposing Corners to Draw a Rectangle"
$tips[3] = "Click Opposing Corners to Draw an Oval inside the Defined Rectangle"
$mouseDown = 0
$firstFreehand = 1
Dim $freehandControlGroup[1]

; Main Loop
Do
  GUICtrlSetData($label, $tips[$mode])
  $msg = GUIGetMsg(1)
  $handeled = 0
  Select
    Case $msg[0] = $fbutton
	  $mode = 0
	  $pointsSet = 0
	  $handeled = 1
	  $firstFreehand = 1
    Case $msg[0] = $lbutton
	  $mode = 1
	  $pointsSet = 0
	  $handeled = 1
	Case $msg[0] = $rbutton
	  $mode = 2
	  $pointsSet = 0
	  $handeled = 1
    Case $msg[0] = $cbutton
      $mode = 3
	  $pointsSet = 0
	  $handeled = 1
    Case $msg[0] = $ubutton
      GUICtrlSetData($label, "WAIT!")
	  If $nextControlGroup <> $oldestControlGroup Then ; Can't Undo what you haven't done
	    DeleteLastControlGroup ()
	    $nextControlGroup = $lastControlGroup
	    $lastControlGroup = Mod ($lastControlGroup - 1, $maxControlGroups)
	  EndIf
      $pointsSet = 0
	  $handeled = 1
    Case $msg[0] = $GUI_EVENT_PRIMARYDOWN
	  $mouseDown = 1
	  If $msg[4] < 60 Then
		$mouseDown = 0
      ElseIf $mode Then
		$points[$pointsSet][0] = $msg[3]
		$points[$pointsSet][1] = $msg[4]
		$pointsSet = $pointsSet + 1
        GUICtrlSetData($label, "WAIT!")
    	Select
		  Case $mode = 1 And $pointsSet = 2
			$controlGroupIDsTemp = GUICtrlCreateLine ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			While @error And $nextControlGroup <> $oldestControlGroup
			  DeleteOldestControlGroup ()
  			  $controlGroupIDsTemp = GUICtrlCreateLine ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			Wend
			If @error Then
			  MsgBox (0, "Error!", "Something is Majorly Wrong!")
			EndIf
		    If UBound($controlGroupIDsTemp) > 1 Then
		      AddNewControlGroup ($controlGroupIDsTemp)
		      $pointsSet = 0
			EndIf
		    $pointsSet = 0
		  Case $mode = 2 And $pointsSet = 2
			$controlGroupIDsTemp = GUICtrlCreateRectangle ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			While @error And $nextControlGroup <> $oldestControlGroup
			  DeleteOldestControlGroup ()
  			  $controlGroupIDsTemp = GUICtrlCreateRectangle ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			Wend
			If @error Then
			  MsgBox (0, "Error!", "Something is Majorly Wrong!")
			EndIf
		    If UBound($controlGroupIDsTemp) > 1 Then
		      AddNewControlGroup ($controlGroupIDsTemp)
		      $pointsSet = 0
			EndIf
		    $pointsSet = 0
		  Case $mode = 3 And $pointsSet = 2
  			$controlGroupIDsTemp = GUICtrlCreateOval ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			While @error And $nextControlGroup <> $oldestControlGroup
			  DeleteOldestControlGroup ()
  			  $controlGroupIDsTemp = GUICtrlCreateOval ($points[0][0], $points[0][1], $points[1][0], $points[1][1], 1, "0x000000")
			Wend
			If @error Then
			  MsgBox (0, "Error!", "Something is Majorly Wrong!")
		    EndIf
		    If UBound($controlGroupIDsTemp) > 1 Then
		      AddNewControlGroup ($controlGroupIDsTemp)
		      $pointsSet = 0
			EndIf
			$pointsSet = 0
		EndSelect
	  Else
		$points[0][0] = $msg[3]
		$points[0][1] = $msg[4]
	  EndIf
	  $handeled = 1
    Case $msg[0] = $GUI_EVENT_MOUSEMOVE And $mouseDown And $mode = 0
	  If $msg[4] < 60 Then
		$mouseDown = 0
	  Else
	    $controlGroupIDsTemp = GUICtrlCreateLine ($points[0][0], $points[0][1], $msg[3], $msg[4], 1, "0x000000")
		While @error And $nextControlGroup <> $oldestControlGroup
		  DeleteOldestControlGroup ()
		  $controlGroupIDsTemp = GUICtrlCreateLine ($points[0][0], $points[0][1], $msg[3], $msg[4], 1, "0x000000")
		Wend
		If @error Then
		  MsgBox (0, "Error!", "Something is Majorly Wrong!")
	    EndIf
	    If $firstFreehand Then
		  $freehandControlGroup = $controlGroupIDsTemp
		  $firstFreehand = 0
	    Else
		  GUICtrlAddToGroup ($freehandControlGroup, $controlGroupIDsTemp)
	    EndIf
	    If Ubound ($freehandControlGroup) > .9*$maxControlsPerGroup Then
		  AddNewControlGroup ($freehandControlGroup)
		  $firstFreehand = 1
		  Dim $freehandControlGroup[1]
		EndIf
		$points[0][0] = $msg[3]
		$points[0][1] = $msg[4]
	  EndIf
  Case $msg[0] = $GUI_EVENT_PRIMARYUP
	  If $mode = 0 And Ubound($freehandControlGroup) > 1 Then
		AddNewControlGroup ($freehandControlGroup)
		$firstFreehand = 1
		Dim $freehandControlGroup[1]
	  EndIf
	  $mouseDown = 0
	  $handeled = 1
  EndSelect		
Until $msg[0] = $GUI_EVENT_CLOSE

; Example specific functions.  i.e. the ones still using global variables.. easy to fix

Func DeleteOldestControlGroup ()
  $controlIDsToDelete = ArrayCopySubDimension ($controlGroupIDs, $oldestControlGroup)
  $newSize = ArrayFindFirst ($controlIDsToDelete, 0)
  If $newSize > 0 Then  ; Don't think this test will ever fail, but why take the chance?
	ReDim $controlIDsToDelete[$newSize]
    GUICtrlDeleteGroup ($controlIDsToDelete)
  EndIf
  $oldestControlGroup = Mod ($oldestControlGroup + 1, $maxControlGroups)
EndFunc

Func DeleteLastControlGroup ()
  $controlIDsToDelete = ArrayCopySubDimension ($controlGroupIDs, $lastControlGroup)
  $newSize = ArrayFindFirst ($controlIDsToDelete, 0)
  If $newSize > 0 Then  ; Don't think this test will ever fail, but why take the chance?
	ReDim $controlIDsToDelete[$newSize]
    GUICtrlDeleteGroup ($controlIDsToDelete)
  EndIf
EndFunc

Func AddNewControlGroup ($newGroupIDs)
  If Ubound ($newGroupIDs) = 1 Then MsgBox (0, "Diagnostic", "Creating New Group with Size 1")
  ArrayClearSubDimension ($controlGroupIDs, $nextControlGroup)
  ArrayReplaceSubDimension ($controlGroupIDs, $nextControlGroup, $newGroupIDs)
  $lastControlGroup = $nextControlGroup
  $nextControlGroup = Mod ($nextControlGroup + 1, $maxControlGroups)
EndFunc

; These are gonna be usefull (at least to me) in the future
; They're not generic enough, and no error checking.  Definitely NOT UDF candidates yet
; No Globals here

Func ArrayCopySubDimension ($avArray, $iIndex)
  $iSizeofNewArray = UBound ($avArray, 2)
  Dim $avNewArray[$iSizeofNewArray]
  For $iLoopIndex = 0 To $iSizeofNewArray - 1
	$avNewArray[$iLoopIndex] = $avArray[$iIndex][$iLoopIndex]
  Next
  Return $avNewArray
EndFunc

Func ArrayReplaceSubDimension (ByRef $avArray1, $iIndex1, $avArray2)
  $iSizeofArray2 = UBound ($avArray2)
  For $iLoopIndex = 0 To $iSizeofArray2 - 1
	$avArray1[$iIndex1][$iLoopIndex] = $avArray2[$iLoopIndex]
  Next
EndFunc

Func ArrayClearSubDimension (ByRef $avArray, $iIndex)
  $iSizeofSubDim = UBound ($avArray, 2)
  For $iLoopIndex = 0 To $iSizeofSubDim - 1
	$avArray[$iIndex][$iLoopIndex] = 0
  Next
EndFunc

Func ArrayFindFirst ($avArray, $sValue)
  For $iLoopIndex = 0 To Ubound ($avArray) - 1
	If $avArray[$iLoopIndex] = $sValue Then Return $iLoopIndex
  Next
  Return -1
EndFunc

;End of.. um... Everything
