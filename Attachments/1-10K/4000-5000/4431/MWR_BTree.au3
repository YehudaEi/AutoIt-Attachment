; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.55
; Author:         Mike Ratzlaff <mike@ratzlaff.org>
;
; Script Function:
;	Binary Tree UDFs
;
; Script revision version:
;	20050630A
;   - 5 Oct 2005 - Will Mooar - added all blindwig's changes up to today
;
; ----------------------------------------------------------------------------

#include-once
#include <Array.au3>
#include <Math.au3>
#include <MWR_String.au3>

;a BTree is a pseudo binary tree
;it is a 2-d array, where the second dimension is 4
;[0][0]=size of 1st dimension
;[0][1]=link to top-most element
;[x][0]=unique key
;[x][1]=link to lesser key
;[x][2]=link to greater key
;[x][3]=stored value

Func _BTreeCreate($Length = 100)
	Local $aNew[$Length][4]
	Return $aNew
EndFunc   ;==>_BTreeCreate

;Attempts to assign value $Value to key $Key in $BTree.  A new key is created if needed.
;on success, empty string is returned, array index containing $Key is in @extended
;on failure, @error is set and return is a human-readable error message string
Func _BTreeSet(ByRef $BTree, $Key, $Value, $Increase = 20)
	;make sure we've got the structure of a tree
	If UBound($BTree, 0) <> 2 Or UBound($BTree, 2) <> 4 Then
		SetError(1)
		Return 'This is not a binary tree'
	EndIf
	
	;find a leaf to plant the key/value into
	Local $InsertPoint = 0, $CurPtr, $Max = UBound($BTree, 1)
	If $BTree[0][1] = 0 Then
		$InsertPoint = 1
		$BTree[0][1] = 1
	Else
		$CurPtr = $BTree[0][1]
		While $InsertPoint = 0
			Select
				Case (IsNumber($Key) = IsNumber($BTree[$CurPtr][0]) And $Key < $BTree[$CurPtr][0]) Or (IsNumber($Key) <> IsNumber($BTree[$CurPtr][0]) And String($Key) < String($BTree[$CurPtr][0]))
					;go to lower branch
					If $BTree[$CurPtr][1] = 0 Then
						$InsertPoint = $BTree[0][0] + 1
						$BTree[$CurPtr][1] = $InsertPoint
					Else
						$CurPtr = $BTree[$CurPtr][1]
					EndIf
				Case (IsNumber($Key) = IsNumber($BTree[$CurPtr][0]) And $Key > $BTree[$CurPtr][0]) Or (IsNumber($Key) <> IsNumber($BTree[$CurPtr][0]) And String($Key) > String($BTree[$CurPtr][0]))
					;go to lower branch ;go to higher branch
					If $BTree[$CurPtr][2] = 0 Then
						$InsertPoint = $BTree[0][0] + 1
						$BTree[$CurPtr][2] = $InsertPoint
					Else
						$CurPtr = $BTree[$CurPtr][2]
					EndIf
				Case Else
					;use this branch
					$InsertPoint = $CurPtr
			EndSelect
		WEnd
	EndIf
	
	;plant the key/value
	If $InsertPoint >= $Max Then ReDim $BTree[$Max + $Increase][4]
	If $InsertPoint >= $BTree[0][0] Then $BTree[0][0] = $InsertPoint
	$BTree[$InsertPoint][0] = $Key
	$BTree[$InsertPoint][3] = $Value
	SetExtended($InsertPoint)
	Return ''
EndFunc   ;==>_BTreeSet

;Attempts to retrieve the value associated with $Key in $BTree
;on success, value is returned and the array index is in @extended
;on failure, @error is set and return is a human-readable error message string
Func _BTreeGet(ByRef $BTree, $Key)
	$BTCur = $BTree[0][1]
	While $BTCur <> 0 And $BTree[$BTCur][0] <> $Key
		Select
			Case (IsNumber($Key) = IsNumber($BTree[$BTCur][0]) And $Key < $BTree[$BTCur][0]) Or (IsNumber($Key) <> IsNumber($BTree[$BTCur][0]) And String($Key) < String($BTree[$BTCur][0]))
				$BTCur = $BTree[$BTCur][1]
			Case (IsNumber($Key) = IsNumber($BTree[$BTCur][0]) And $Key > $BTree[$BTCur][0]) Or (IsNumber($Key) <> IsNumber($BTree[$BTCur][0]) And String($Key) > String($BTree[$BTCur][0]))
				$BTCur = $BTree[$BTCur][2]
		EndSelect
	WEnd
	If $BTCur = 0 Then
		SetError(1) ;$Key was not found in this tree
		Return 'The key "' & $Key & '" was not found in the tree.'
	Else
		SetExtended($BTCur)
		Return $BTree[$BTCur][3]
	EndIf
EndFunc   ;==>_BTreeGet


;This will optimize the binary tree (make sure all the branches are balanced)
Func _BTreeOptimize(ByRef $BTree, $ProgressTitle = @ScriptName)
	If $ProgressTitle <> '' Then ProgressOn($ProgressTitle, 'Optimizing Binary Tree...', 'Gathering Keys...')
	Local $aKeys[$BTree[0][0] + 1][3]
	$aKeys = _BTreeToTable($BTree)
	If $ProgressTitle <> '' Then ProgressSet(50, 'Restructuring Tree...')
	$BTree[0][1] = __BTreeOpt($BTree, 1, $BTree[0][0], $aKeys)
	If $ProgressTitle <> '' Then ProgressSet(99)
	If $ProgressTitle <> '' Then ProgressOff()
EndFunc   ;==>_BTreeOptimize

;private
Func __BTreeOpt(ByRef $BTree, $min, $Max, ByRef $aKeys)
	If $min = $Max Then
		$BTree[$aKeys[$min][2]][1] = 0
		$BTree[$aKeys[$min][2]][2] = 0
		Return $aKeys[$min][2]
	EndIf
	$mid = Int(($min + $Max) / 2)
	If $min = $mid Then
		$BTree[$aKeys[$mid][2]][1] = 0
	Else
		$BTree[$aKeys[$mid][2]][1] = __BTreeOpt($BTree, $min, $mid - 1, $aKeys)
	EndIf
	If $mid = $Max Then
		$BTree[$aKeys[$mid][2]][2] = 0
	Else
		$BTree[$aKeys[$mid][2]][2] = __BTreeOpt($BTree, $mid + 1, $Max, $aKeys)
	EndIf
	Return $aKeys[$mid][2]
EndFunc   ;==>__BTreeOpt

;Returns a string that shows the layout of the keys in $BTree in an ASCII-ART format
;$Length affects how deep the tree appears to be - cosmetic only, has no effect on values or order
Func _BTreePrintKeys(ByRef $BTree, $Length = 8)
	Local $Out = ''
	$Length = _Max (1, Int($Length))
	__BTreePrintKeys($BTree, $BTree[0][1], $Out, $Length, '', 0)
	Return $Out
EndFunc   ;==>_BTreePrintKeys

;private
Func __BTreePrintKeys(ByRef $BTree, $ptr, ByRef $Out, $Length, $Prefix, $Parent)
	Select
		Case $Parent > 0
			If $BTree[$ptr][1] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][1], $Out, $Length, $Prefix & _StringPadRight ('|', $Length), -1)
			$Out = $Out & $Prefix & _StringPadRight ("'", $Length, '-') & $BTree[$ptr][0] & @CRLF
			If $BTree[$ptr][2] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][2], $Out, $Length, $Prefix & _StringRepeat(' ', $Length), 1)
		Case $Parent < 0
			If $BTree[$ptr][1] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][1], $Out, $Length, $Prefix & _StringRepeat(' ', $Length), -1)
			$Out = $Out & $Prefix & _StringPadRight (',', $Length, '-') & $BTree[$ptr][0] & @CRLF
			If $BTree[$ptr][2] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][2], $Out, $Length, $Prefix & _StringPadRight ('|', $Length), 1)
		Case Else
			If $BTree[$ptr][1] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][1], $Out, $Length, _StringRepeat(' ', $Length), -1)
			$Out = $Out & $Prefix & _StringRepeat('-', $Length) & $BTree[$ptr][0] & @CRLF
			If $BTree[$ptr][2] <> 0 Then __BTreePrintKeys($BTree, $BTree[$ptr][2], $Out, $Length, _StringRepeat(' ', $Length), 1)
	EndSelect
EndFunc   ;==>__BTreePrintKeys

;Returns a table of [x][3], where [x][0]=key, [x][1]=value, [x][2]=original index
Func _BTreeToTable(ByRef $BTree)
	Dim $aOut[$BTree[0][0] + 1][3]
	If $BTree[0][1] <> 0 Then __BTreeToTable($BTree, $BTree[0][1], $aOut)
	Return $aOut
EndFunc   ;==>_BTreeToTable
;private
Func __BTreeToTable(ByRef $BTree, $ptr, ByRef $aKey)
	If $BTree[$ptr][1] <> 0 Then __BTreeToTable($BTree, $BTree[$ptr][1], $aKey)
	$aKey[0][0] = $aKey[0][0] + 1
	$aKey[$aKey[0][0]][0] = $BTree[$ptr][0]
	$aKey[$aKey[0][0]][1] = $BTree[$ptr][3]
	$aKey[$aKey[0][0]][2] = $ptr
	If $BTree[$ptr][2] <> 0 Then __BTreeToTable($BTree, $BTree[$ptr][2], $aKey)
EndFunc   ;==>__BTreeToTable

;Find the key $Key in Binary Tree $BTree, returns it's parent value (or 0 if $key is at root)
;Also sets @Extended to point to the array index of the parent item.
Func _BTreeFindParentKey(ByRef $BTree, $Key)
	Local $BTCur = $BTree[0][1], $BTLast = 0
	While $BTCur <> 0 And $BTree[$BTCur][0] <> $Key
		Select
			Case (IsNumber($Key) = IsNumber($BTree[$BTCur][0]) And $Key < $BTree[$BTCur][0]) Or (IsNumber($Key) <> IsNumber($BTree[$BTCur][0]) And String($Key) < String($BTree[$BTCur][0]))
				$BTLast = $BTCur
				$BTCur = $BTree[$BTCur][1]
			Case (IsNumber($Key) = IsNumber($BTree[$BTCur][0]) And $Key > $BTree[$BTCur][0]) Or (IsNumber($Key) <> IsNumber($BTree[$BTCur][0]) And String($Key) > String($BTree[$BTCur][0]))
				$BTLast = $BTCur
				$BTCur = $BTree[$BTCur][2]
		EndSelect
	WEnd
	If $BTCur = 0 Then
		SetError(1) ;$Key was not found in this tree
		Return 'The key "' & $Key & '" was not found in the tree.'
	Else
		SetExtended($BTLast)
		If $BTLast = 0 Then
			Return 0
		Else
			Return $BTree[$BTLast][0]
		EndIf
	EndIf
EndFunc   ;==>_BTreeFindParentKey

;This function will remove a key from the binary tree.
;Note that it does not actually remove it, it only orpahns it by re-routing the links around it.
Func _BTreeDelete(ByRef $BTree, $Key)
	;Locate $key in $BTree
	Local $RetVal = _BTreeGet($BTree, $Key), $ptr = @extended
	If Not @error Then
		;Gather a list of sub-branches under this key
		Local $aBranch[$BTree[0][0]][3]
		If $BTree[$ptr][1] <> 0 Then __BTreeToTable($BTree, $BTree[$ptr][1], $aBranch)
		If $BTree[$ptr][2] <> 0 Then __BTreeToTable($BTree, $BTree[$ptr][2], $aBranch)
		_BTreeFindParentKey($BTree, $Key)
		;graft the new sub-branch onto the parent branch
		Local $ParentPtr = @extended
		If $ParentPtr = 0 Then
			$BTree[0][1] = __BTreeOpt($BTree, 1, $aBranch[0][0], $aBranch)
		ElseIf $BTree[$ParentPtr][1] = $ptr Then
			$BTree[$ParentPtr][1] = __BTreeOpt($BTree, 1, $aBranch[0][0], $aBranch)
		ElseIf $BTree[$ParentPtr][2] = $ptr Then
			$BTree[$ParentPtr][2] = __BTreeOpt($BTree, 1, $aBranch[0][0], $aBranch)
		EndIf
		;remove branches from the original item
		$BTree[$ptr][1] = 0
		$BTree[$ptr][2] = 0
	Else
		SetError(1)
		Return $RetVal
	EndIf
	
EndFunc   ;==>_BTreeDelete

;Returns a Binary Tree keyed with values found in 1-d array $aIn
Func _BTreeFromArray1(ByRef $aIn, $iBase = 1)
	Local $i, $InTop, $Next = 0
	
	;Create the output structure
	If $iBase Then
		$iBase = 1
		$InTop = $aIn[0]
	Else
		$iBase = 0
		$InTop = UBound($aIn, 1) - 1
	EndIf
	Dim $btOut[$InTop + 2 - $iBase][4]
	For $i = $iBase To $InTop
		$btOut[0][0] = $btOut[0][0] + 1
		$btOut[$btOut[0][0]][0] = $aIn[$i]
	Next
	
	_ArraySort($btOut, 0, 1, $btOut[0][0], 2, 0)
	
	;Remove duplicates
	$i = $iBase
	While $i <= $btOut[0][0] - $Next
		While $i + $Next + 1 <= $btOut[0][0] And $btOut[$i][0] = $btOut[$i + $Next + 1][0]
			$Next = $Next + 1
		WEnd
		$i = $i + 1
		If $Next And $i + $Next + 1 <= $btOut[0][0] Then
			$btOut[$i][0] = $btOut[$i + $Next][0]
		EndIf
	WEnd
	$btOut[0][0] = $i - 1
	ReDim $btOut[$i][4]
	
	;Build Tree Structure
	$btOut[0][1] = __BTreeFromArray($btOut, 1, $btOut[0][0])
	
	Return $btOut
EndFunc   ;==>_BTreeFromArray1

;Returns a Binary Tree keyed with values found in 2-d array $aIn
;keys are taken from $aIn[x][$iKey] and data is taken from $aIn[x][$iData]
Func _BTreeFromArray2(ByRef $aIn, $iBase = 1, $iKey = 0, $iData = 1)
	Local $i, $InTop, $Next = 0
	
	;Create the output structure
	If $iBase Then
		$iBase = 1
		$InTop = $aIn[0][0]
	Else
		$iBase = 0
		$InTop = UBound($aIn, 1) - 1
	EndIf
	Dim $btOut[$InTop + 2 - $iBase][4]
	For $i = $iBase To $InTop
		$btOut[0][0] = $btOut[0][0] + 1
		$btOut[$btOut[0][0]][0] = $aIn[$i][$iKey]
		$btOut[$btOut[0][0]][3] = $aIn[$i][$iData]
	Next
	
	_ArraySort($btOut, 0, 1, $btOut[0][0], 4, 0)
	
	;Remove duplicates
	$i = 1
	While $i <= $btOut[0][0] - $Next
		While $i + $Next + 1 <= $btOut[0][0] And $btOut[$i][0] = $btOut[$i + $Next + 1][0]
			$Next = $Next + 1
		WEnd
		$i = $i + 1
		If $Next And $i + $Next + 1 <= $btOut[0][0] Then
			$btOut[$i][0] = $btOut[$i + $Next][0]
			$btOut[$i][3] = $btOut[$i + $Next][3]
		EndIf
	WEnd
	$btOut[0][0] = $i - 1
	ReDim $btOut[$i][4]
	
	;Build Tree Structure
	$btOut[0][1] = __BTreeFromArray($btOut, 1, $btOut[0][0])
	
	Return $btOut
EndFunc   ;==>_BTreeFromArray2

;private
Func __BTreeFromArray(ByRef $BTree, $min, $Max)
	If $min = $Max Then
		$BTree[$min][1] = 0
		$BTree[$min][2] = 0
		Return $min
	EndIf
	$mid = Round(($min + $Max) / 2)
	If $min = $mid Then
		$BTree[$mid][1] = 0
	Else
		$BTree[$mid][1] = __BTreeFromArray($BTree, $min, $mid - 1)
	EndIf
	If $mid = $Max Then
		$BTree[$mid][2] = 0
	Else
		$BTree[$mid][2] = __BTreeFromArray($BTree, $mid + 1, $Max)
	EndIf
	Return $mid
EndFunc   ;==>__BTreeFromArray





;version check
Dim $temp = StringSplit(@AutoItVersion, '.')
If not ($temp[0] >= 4 And $temp[1] >= 3 And $temp[2] >= 1 And $temp[3] >= 1 And $temp[4] >= 55) Then
	MsgBox(8192, 'MWR_BTree UDF - Error', 'Please be sure that you are running the latest beta!')
	Exit
EndIf
