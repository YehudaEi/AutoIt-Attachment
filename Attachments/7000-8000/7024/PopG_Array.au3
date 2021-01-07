; PopG_Array.au3 - Andy Swarbrck (c) 2005-6 - Extends Array functionality, primarily in two dimensions.
#Region		Doc:
#Region		Doc: Notes
; Extends Array functionality, primarily in two dimensions.
;
; You are allowed to freely use this code without restriction.
;
; If you have questions, suggestions or wish to report a bug please do this at 
; http://www.autoitscript.com/forum/index.php?showtopic=21542
#EndRegion	Doc: Notes
#Region		Doc: Function List
; _ArrayAdd1							As per _ArrayAdd, but adds an array.
; _ArrayAdd2							As per _ArrayAdd1, but for two dimensional arrays.
; _ArrayDelete2							Deletes either a row or a column from a two dimensional array.
; _ArrayDisplay2						As per _ArrayDisplay but for two dimensional arrays.
; _ArraySwap2ByKey						Swaps two rows or columns in a 2-d array, the hooks being position (in development)
; _ArraySwap2ByIndex					Swaps two rows or columns in a 2-d array, the hooks being position
#EndRegion	Doc: Function List
#Region		Doc: History
; 20-Feb-06 Als Updated		_ArrayAdd1		Bug fixed re [0] entry set incorrectly to one more that it should be.
; 19-Feb-06 Als Updated		_ArrayDisplay2	Altered to fully support 1 dimensional arrays, and thus support timeouts.
; 18-Feb-06 Als Extended 	_ArrayDisplay2	Copes with up to 3 dimensions
; 18-Feb-06 Als Extended 	_ArrayDisplay2	Support msgbox timeout.
; 05-Feb-06 Als Added 		_ArraySwap2ByIndex
; 05-Feb-06 Als Added 		_ArrayDelete2
#EndRegion	Doc: History
#Region		Doc: Requirements
; Au3 build 3.1.1.109 or better.
; Also uses Au3 include libraries GuiConstants and Array.
; Also uses PopG include library _Delim.
#EndRegion	Doc: Requirements
#EndRegion	Doc:
#Region		Init:
#Region		Init: Includes
	#include-once
	#include <GUIConstants.au3>
	#include <array.au3>
	#include "..\PopGincl\PopG_Delim.au3"
#EndRegion	Init: Includes
#Region		Init: Autoit options
	Opt('MustDeclareVars',True)
	Opt('RunErrorsFatal',False)
#EndRegion	Init: Autoit options
#EndRegion	Init:
#Region		Run:
#Region		Run: Test Harness
#Region		Run: Test _ArraySwap2ByIndex
;~ 	Dim $grid[2][8]=[	[1, "AJim", "ARichard", "ALouis",1, "AJim", "ARichard", "ALouis"], _
;~ 						[3, 1160.68, 1275.16, 1320.00,3, 1160.68, 1275.16, 1320.00]] ;, _
;~ 						;[0, "DJim", "dRichard", "dLouis"]] ;, [0, 4160.68, 4275.16, 4320.00]]
;~ 	_ArrayDisplay2($grid,'$grid')
;~ 	_ArraySwap2ByIndex($grid,2,5,4)
;~ 	If @error Then
;~ 		MsgBox(0,'error',@error)
;~ 	Else
;~ 		_ArrayDisplay2($grid,'$grid')
;~ 	EndIf
;~ 	Exit
#EndRegion	Run: Test _ArraySwap2ByIndex
#Region		Run: Test _ArrayDelete2
;~ 	Dim $grid[4][4]=[	[3, "AJim", "ARichard", "ALouis"], [3, 1160.68, 1275.16, 1320.00], _
;~ 						[0, "DJim", "dRichard", "dLouis"], [0, 4160.68, 4275.16, 4320.00]]
;~ 	_ArrayDisplay2($grid,'$grid')
;~ 	_ArrayDelete2($grid,3,1)
;~ 	If @error Then
;~ 		MsgBox(0,'error',@error)
;~ 	Else
;~ 		_ArrayDisplay2($grid,'$grid')
;~ 	EndIf
;~ 	Exit
#EndRegion	Run: Test _ArrayDelete2
#Region		Run: Test for ArrayDisplay2
	Local $msg,$Form1
	Local $Test_ArrayDisplay2,$Test_ArrayAdd1,$Test_ArrayAdd2
	Local $OneArr1[2],$OneArr2[3]
	$OneArr1[0]=1
	$OneArr1[1]='alpha'
	$OneArr2[0]=2
	$OneArr2[1]='a'
	$OneArr2[2]='b'
	;
	Local $TwoArr1[2][2]
	$TwoArr1[0][0]=1
	$TwoArr1[1][0]=1
	$TwoArr1[0][1]='alpha'
	$TwoArr1[1][1]='beta'
	;
	Local $TwoArr2[3][2]
	$TwoArr2[0][0]=2
	$TwoArr2[0][1]='alpha'
	$TwoArr2[1][0]='beta'
	$TwoArr2[1][1]=1
	$TwoArr2[2][0]='c'
	$TwoArr2[2][1]='d'
	$Form1 = GUICreate('array display 2 test', 250, 170, 192, 125)
	GUICtrlCreateLabel('Select from the functions below to initiate a test.',	10, 10, 251, 34)
	$Test_ArrayDisplay2		=GUICtrlCreateButton('$Test_ArrayDisplay2',			10, 40, 200, 21)
	GUICtrlSetTip($Test_ArrayDisplay2,'Click me to run two tests.')
	Local $Test_ArrayAdd1			=GUICtrlCreateButton('$Test_ArrayAdd1',		10, 70, 200, 21)
	GUICtrlSetTip($Test_ArrayAdd1,'Click me to add a 1dim array to another 1dim array. You will see three dialog boxes'&@LF&'1. OneArr1 before'&@LF&'2. OneArr2 before'&@LF&'3. OneArr1 after'&@LF&'remember the first value is the number of entries')
	Local $Test_ArrayAdd2			=GUICtrlCreateButton('$Test_ArrayAdd2',		10, 100, 200, 21)
	GUICtrlSetTip($Test_ArrayAdd2,'Click me to add a 2dim array to another 2dim array. You will see three dialog boxes'&@LF&'1. TwoArr1 before'&@LF&'2. TwoArr2 before'&@LF&'3. TwoArr1 after'&@LF&'remember the first value is the number of entries')
	Local $DoneBtn				=GUICtrlCreateButton('$DoneBtn', 				10, 130, 100, 21)
	GUISetState(@SW_SHOW)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $Test_ArrayDisplay2
			_ArrayDisplay2($TwoArr1,'Array List for a 2x2 array')
		Case $msg = $Test_ArrayAdd1
			_ArrayDisplay($OneArr1,'$OneArr1 before')
			_ArrayDisplay($OneArr2,'$OneArr2 before')
			_ArrayAdd1($OneArr1,$OneArr2,1)
			_ArrayDisplay($OneArr1,'$OneArr1 after')
		Case $msg = $Test_ArrayAdd2
			_ArrayDisplay2($TwoArr2,'$TwoArr2 before')
			_ArrayDisplay2($OneArr2,'$OneArr2 before')
			_ArrayAdd2($TwoArr2,$OneArr2,1,1)
			_ArrayDisplay2($TwoArr2,'$TwoArr2 after')
		Case $msg = $GUI_EVENT_CLOSE Or $msg=$DoneBtn
			ExitLoop
		Case Else
			;;;;;;;
		EndSelect
	WEnd
	Exit
#EndRegion	Run: Test for ArrayDisplay2
#EndRegion	Run: TestHarness
#Region 	Run: Functions
; _ArrayAdd1							As per _ArrayAdd, but adds an array
;
; Notes:
; I recommend you familiarise yourself with _ArrayAdd before using this function.
;
; Parameters:
; $ArrA				One-dimensional array which is added to.
; $ArrB				One dimensional array that is appended to $ArrA.
; $Lower			Index of $ArrB from which to start adding.  Typically this will be 0 or 1.  Default is 0.
; $Upper			Index of $ArrB at which adding ends.
;
; History:
; 20-Feb-06 Als Updated	_ArrayAdd1	Bug fixed re [0] entry set incorrectly to one more that it should be.
Func _ArrayAdd1(ByRef $ArrA,$ArrB,$Lower=0,$Upper=0)
	If Not IsArray($ArrA) Then
		SetError(1)
		Return '_ArrayAdd1'&'Not arrayA'
	EndIf
	If Not IsArray($ArrB) Then
		SetError(2)
		Return '_ArrayAdd1'&'Not arrayB'
	EndIf
	If UBound($ArrA,0)<>1 Then
		SetError(3)
		Return '_ArrayAdd1: first argument is not 1-dimensioned array'
	EndIf
	If UBound($ArrB,0)<>1 Then
		SetError(4)
		Return '_ArrayAdd1: second argument is not 1-dimensioned array'
	EndIf
	Local $ubA=UBound($ArrA)
	Local $ubB=UBound($ArrB)
	Local $ubBL=0
	Local $ubBU=$ubB
	If $Lower>0 Then $ubBL=$Lower
	If $Upper>0 And $Upper<$ubB Then $ubBU=$Upper
	ReDim $ArrA[$ubA+$ubBU-$ubBL]
	Local $j=0
	For $i=$ubBL to $ubBU-1
		$ArrA[$j+$ubA]=$ArrB[$i]
		$j=$j+1
	Next
	$ArrA[0]=UBound($ArrA+1)-1
	Return
EndFunc   ;==>_ArrayAdd1
; _ArrayAdd2							As per _ArrayAdd1, but for two dimensional arrays
;
; Notes:
; I recommend you familiarise yourself with _ArrayAdd first and then with _ArrayAdd1 before using this function.
;
; Parameters:
; $ArrA				A two-dimensional array (eg. Dim $arr[3][5])
; $ArrB				A one dimensional array to be added to $ArrA
; $RowOrCol			1=Add a row,2=Add a column.  Default is to add a row.
; $Lower			Index of $ArrB from which to start adding.  Typically this will be 0 or 1.  Default is 0.
; $Upper			Index of $ArrB at which adding ends.
;
; History:
; 20-Jan-06 Als Updated	_ArrayAdd2	added default for $RowOrCol
; 20-Jan-06 Als Updated	_ArrayAdd2	added $Lower and $Upper.
Func _ArrayAdd2(ByRef $ArrA,ByRef $ArrB,$RowOrCol=1,$Lower=0,$Upper=-1)
	If Not IsArray($ArrA) Then
		SetError(1)
		Return '_ArrayAdd2'&'not arrA'
	EndIf
	If Not IsArray($ArrB) Then
		SetError(2)
		Return '_ArrayAdd2'&'not arrB'
	EndIf
	If UBound($ArrA,0)<>2 Then
		SetError(3)
		Return '_ArrayAdd2: first argument must be 2-dimensioned array'
	EndIf
	If UBound($ArrB,0)<>1 Then
		SetError(4)
		Return '_ArrayAdd2: second argument must be 1-dimensioned array'
	EndIf
	Local $ubA1	=UBound($ArrA,1)
	Local $ubA2	=UBound($ArrA,2)
	Local $ubB	=UBound($ArrB)
	;
	If $Lower<0 Then $Lower=0
	;
	Select 
	Case $RowOrCol=1
		If $ubA1<>$ubB Then
			SetError(3)
			Return '_ArrayAdd2 A B not same size'
		EndIf
		If $Upper<0 Or $Upper>$ubB-1 Then $Upper=$ubB-1
		ReDim $ArrA[$ubA1][$ubA2+1]
		For $i=$Lower to $Upper
			$ArrA[$i][$ubA2] = $ArrB[$i]
		Next
	Case $RowOrCol=2
		If $ubA2<>$ubB Then
			SetError(5)
			Return 0
		EndIf
		If $Upper<0 Or $Upper>$ubB-1 Then $Upper=$ubB-1
		ReDim $ArrA[$ubA1+1][$ubA2]
		For $i=$Lower to $Upper
			$ArrA[$ubA1][$i] = $ArrB[$i]
		Next
	Case Else
		SetError(6)
		Return '_ArrayAdd2 Rowcol wrong ='&$RowOrCol
	EndSelect
EndFunc   ;==>_ArrayAdd2
; _ArrayDelete2							Deletes either a row or a column from a two dimensional array.
;
; Parameters:
; $avArray				The array tobe modified.
; $iElement				The row or column to be deleted.
; $RowOrCol				Whether it is a row (0/False) or a column (1/true) to be deleted.
Func _ArrayDelete2(ByRef $avArray,$iElement,$RowOrCol=0)
	Local $avNewArray							; temporary array
	Local $RowDim								; No Rows of original array
	Local $ColDim								; No Cols of original array
	Local $NewDim								; No of Rows or Cols for the changed dimension of the new array
	Local $RowIdx								;Counter for rows
	Local $ColIdx								;Counter for cols
	If $RowOrCol=0 Then							;Do we want to delete an entry from a single dimensional array, if so then do that and nothing more
		_ArrayDelete($avArray,$iElement)
		Return False
	EndIf
	If $RowOrCol<>1 And $RowOrCol<>2 Then		;Make sure RowCol is legal
		SetError(1)
		Return False
	EndIf
	If Not IsArray($avArray) Then				;Make sure we are dealing with an array
		SetError(2)
		Return False
	EndIf
	If UBound($avArray,0)<>2 Then				;Make sure we are dealing with a 2-dim array
		SetError(3)
		Return False
	EndIf
	If $iElement<0 Then $iElement=0
	$RowDim = UBound($avArray,1)				; No Rows of original array
	$ColDim = UBound($avArray,2)				; No Cols of original array
	If $RowOrCol=1 Then
		If $RowDim=1 Then						; If the array is only 1 element in size then we can't delete the 1 element.
			SetError(4)
			Return False
		EndIf
		$NewDim=$RowDim-1
		Dim $avNewArray[$NewDim][$ColDim]
		If $iElement>$NewDim Then $iElement=$NewDim
		For $RowIdx=0 To $NewDim-1
			For $ColIdx=0 To $ColDim-1
				If $RowIdx<$iElement Then
					$avNewArray[$RowIdx][$ColIdx]=$avArray[$RowIdx][$ColIdx]
				Else
					$avNewArray[$RowIdx][$ColIdx]=$avArray[$RowIdx+1][$ColIdx]
				EndIf
			Next
		Next
	EndIf
	If $RowOrCol=2 Then
		If $ColDim = 1 Then						; If the array is only 1 element in size then we can't delete the 1 element.
			SetError(4)
			Return False
		EndIf
		$NewDim=$ColDim-1
		Dim $avNewArray[$RowDim][$NewDim]
		If $iElement>($NewDim) Then $iElement=$NewDim
		For $ColIdx=0 To $NewDim-1
			For $RowIdx=0 To $RowDim-1
				If $ColIdx<$iElement Then
					$avNewArray[$RowIdx][$ColIdx]=$avArray[$RowIdx][$ColIdx]
				Else
					$avNewArray[$RowIdx][$ColIdx]=$avArray[$RowIdx+1][$ColIdx]
				EndIf
			Next
		Next
	EndIf
	$avArray=$avNewArray
	SetError(0)
	Return True
EndFunc ; _ArrayDelete2
;_ArrayDisplay2							Displays elements of a one, two or three dimensional array
;
; Notes:
; Supports arrays of up the three dimensions.  Familiarise yourself with _ArrayDisplay before using this function.
;
; Parameters:
; $ArrA					The array to be displayed.
; $sTitle				The title for the dialog box.
; $Timeout				Optional number of seconds after which the dialogue box is automatically dismissed.
;
; Result:
; @error=1		$arrA is not an array
; @error=2		Number of dimensions is not supported.
;
; History:
; 05-Feb-06 Als Added 		_ArrayDelete2
Func _ArrayDisplay2(ByRef $ArrA, $sTitle, $Timeout=0)
	If (Not IsArray($ArrA)) Then
		SetError(1)
		Return @LF&'_ArrayDisplay2: not array'
	EndIf
	Local $adMsg = ''
	;
	Local $NoDims=UBound($ArrA,0)
	If $NoDims>3 Then
		SetError(2)
		Return @LF&'_ArrayDisplay2: number of dimensions not supported.'
	EndIf
	;
	Local $x=0
	Local $ubA1=UBound($ArrA,1)
	If $NoDims>=2 Then 
		Local $ubA2=UBound($ArrA,2)
		Local $y=0
	EndIf
	If $NoDims>=3 Then 
		Local $ubA3=UBound($ArrA,3)
		Local $z=0
	EndIf
	For $x = 0 To  $ubA1-1
		If $NoDims=1 Then
			$adMsg = $adMsg &'['&$x&']=' &@TAB& StringStripCR($ArrA[$x]) & @CR
		Else
			For $y = 0 To $ubA2-1
				If $NoDims=2 Then
					$adMsg = $adMsg &'['&$x&']['&$y&']=' &@TAB& StringStripCR($ArrA[$x][$y]) & @CR
				Else	;$NoDim=3
					For $z=0 To $ubA3-1
						$adMsg = $adMsg &'['&$x&']['&$y&']['&$z&']=' &@TAB& StringStripCR($ArrA[$x][$y][$z]) & @CR
					Next
				EndIf
			Next
		EndIf
	Next
	MsgBox(4096, $sTitle, $adMsg, $Timeout)
EndFunc   ; _ArrayDisplay2
; _ArraySwap2ByIndex							Swaps two rows or columns in a 2-d array, the hooks being position
;
; Parameters:
; $Arr			Is the array to be processed
; $RowOrCol		If 1 then a row is swapped, if 2 then a column is swapped
; $rcA			Is the first row or column index (
; $rcB			Is the second row or column index
;               $rcA is to be swapped with $rcB
; $Beg			beginning of subitems from the row/col (defaults to 0)
; $End			end of subitems from the row/col to be swapped (defaults to maximum)
; $OkKey		indicates the leftmost field of the swap is a keyfield and should not be swapped.
;
; Results:
; @error=1		If $Arr is not an array
; @error=2		If $Arr is not a two-dimensional array
; @error=3		If $RowOrCol is not correctly specified.
; @error=4 		If $rcA, $rcB, $Beg or $End are not correctly specified.
;
; History:
; 19-Feb-06 Als Updated	_ArrayDisplay2 altered to fully support 1 dimensional arrays, and thus support timeouts.
Func _ArraySwap2ByIndex(ByRef $Arr,$RowOrCol,$rcA,$rcB,$Beg=0,$End=999,$OkKey=False)
	Local $Idx
	Local $Jdx
	Local $RowDim
	Local $ColDim
	Local $ValA
	Local $ValB
	Local Const $Dlm=Opt('GUIDataSeparatorChar')
	Local $NewA
	Local $NewB
	Local $RestA
	Local $RestB
	If Not IsArray($Arr) Then			;Make sure we are dealing with an array!
		SetError(1)
		Return False
	EndIf
	If UBound($Arr,0)<>2 Then		;Make sure it is a two dimensional array
		SetError(2)
		Return False
	EndIf
	If $RowOrCol<>1 And $RowOrCol<>2 Then
		SetError(3)
		Return False
	EndIf
	If $rcA<0 Or $rcB<0 Or $Beg<0 Or $End<0 Or $End<$Beg Or $rcA=$rcB Then
		SetError(4)
		Return False
	EndIf
	$RowDim=UBound($Arr,1)
	$ColDim=UBound($Arr,2)
	If $RowOrCol=1 Then
		If ($rcA > $RowDim) Or ($rcB > $RowDim) Then
			SetError(5)
			Return False
		EndIf
		If $Beg>$ColDim Then
			SetError(6)
			Return False
		EndIf
		If $End>$ColDim-1 Then $End=$ColDim-1
		For $Idx=$Beg To $End
			If $OkKey Then
				_DelimListSplit($Arr[$rcA][$Idx],$ValA,$RestA)
				_DelimListSplit($Arr[$rcB][$Idx],$ValB,$RestB)
				$Arr[$rcA][$Idx]=$ValA&$Dlm&$RestB
				$Arr[$rcB][$Idx]=$ValB&$Dlm&$RestA
			Else
				$ValA=$Arr[$rcA][$Idx]
				$ValB=$Arr[$rcB][$Idx]
				$Arr[$rcA][$Idx]=$ValB
				$Arr[$rcB][$Idx]=$ValA
			EndIf
		Next
	EndIf
	If $RowOrCol=2 Then
		If $rcA>$ColDim Or $rcB>$ColDim Then
			SetError(5)
			Return False
		EndIf
		If $Beg>$RowDim Then
			SetError(6)
			Return False
		EndIf
		If $End>$RowDim-1 Then $End=$RowDim-1
		For $Idx=$Beg to $End
			If $OkKey Then
				_DelimListSplit($Arr[$Idx][$rcA],$ValA,$RestA)
				_DelimListSplit($Arr[$Idx][$rcB],$ValB,$RestB)
				$Arr[$Idx][$rcA]=$ValA&$Dlm&$RestB
				$Arr[$Idx][$rcB]=$ValB&$Dlm&$RestA
			Else
				$ValA=$Arr[$Idx][$rcA]
				$ValB=$Arr[$Idx][$rcB]
				$Arr[$Idx][$rcA]=$ValB
				$Arr[$Idx][$rcB]=$ValA
			EndIf
		Next
	EndIf
	Return True
EndFunc ;_ArraySwap2ByIndex
; _ArraySwap2ByKey							Swaps two rows or columns in a 2-d array, the hooks being position
; $Arr			Is the array to be processed
; $RowOrCol		If 1 then a row is swapped, if 2 then a column is swapped
; $rcA			Is the first row or column index (
; $rcB			Is the second row or column index
;               $rcA is to be swapped with $rcB
; $Beg			beginning of subitems from the row/col (defaults to 0)
; $End			end of subitems from the row/col to be swapped (defaults to maximum)
; $OkKey		indicates the leftmost field of the swap is a keyfield and should not be swapped.
;~ Func _ArraySwap2ByKey(ByRef $Arr,$RowOrCol,$rcA,$rcB,$Beg=0,$End=999)
;~ 	Local $Idx
;~ 	Local $Jdx
;~ 	Local $JdxA
;~ 	Local $JdxB
;~ 	Local $RowDim
;~ 	Local $ColDim
;~ 	Local $ValA
;~ 	Local $ValB
;~ 	Local Const $Dlm=Opt('GUIDataSeparatorChar')
;~ 	Local $NewA
;~ 	Local $NewB
;~ 	Local $RestA
;~ 	Local $RestB
;~ 	If Not IsArray($Arr) Then			;Make sure we are dealing with an array!
;~ 		SetError(1)
;~ 		Return False
;~ 	EndIf
;~ 	If UBound($Arr,0)<>2 Then		;Make sure it is a two dimensional array
;~ 		SetError(2)
;~ 		Return False
;~ 	EndIf
;~ 	If $RowOrCol<>1 And $RowOrCol<>2 Then
;~ 		SetError(3)
;~ 		Return False
;~ 	EndIf
;~ 	If $rcA<0 Or $rcB<0 Or $Beg<0 Or $End<0 Or $End<$Beg Or $rcA=$rcB Then
;~ 		SetError(4)
;~ 		Return False
;~ 	EndIf
;~ 	$RowDim=UBound($Arr,1)
;~ 	$ColDim=UBound($Arr,2)
;~ 	If $RowOrCol=1 Then
;~ 		If $Beg>$ColDim Then
;~ 			SetError(6)
;~ 			Return False
;~ 		EndIf
;~ 		$JdxA=0
;~ 		$JdxB=0
;~ 		For $Jdx=1 To $Arr[$Jdx][0]
;~ 			If $JdxA=0 Then
;~ 				_DelimListSplit($Arr[$Jdx][0],$ValA,$RestA)
;~ 				If $ValA=$rcA Then $JdxA=$Jdx
;~ 			ElseIf $JdxB=0
;~ 				_DelimListSplit($Arr[$Jdx][0],$ValB,$RestB)
;~ 				If $ValB=$rcB Then 
;~ 					$JdxB=$Jdx
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 		If $JdxB=0
;~ 			SetError(7)
;~ 			Return False
;~ 		EndIf
;~ 		$Arr[$JdxA][0]=$ValA&$Dlm&$RestB
;~ 		$Arr[$JdxB][0]=$ValB&$Dlm&$RestA
;~ 	ElseIf $RowOrCol=2 Then
;~ 		If $Beg>$RowDim Then
;~ 			SetError(6)
;~ 			Return False
;~ 		EndIf
;~ 		$JdxA=0
;~ 		$JdxB=0
;~ 		For $Jdx=1 To $Arr[0]
;~ 			If $JdxA=0 Then
;~ 				_DelimListSplit($Arr[0][$Jdx],$ValA,$RestA)
;~ 				If $ValA=$rcA Then $JdxA=$Jdx
;~ 			ElseIf $JdxB=0
;~ 				_DelimListSplit($Arr[0][$Jdx],$ValB,$RestB)
;~ 				If $ValB=$rcB Then 
;~ 					$JdxB=$Jdx
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 		If $JdxB=0
;~ 			SetError(7)
;~ 			Return False
;~ 		EndIf
;~ 		$Arr[0][$JdxA]=$ValA&$Dlm&$RestB
;~ 		$Arr[0][$JdxB]=$ValB&$Dlm&$RestA
;~ 	EndIf
;~ 	Return True
;~ EndFunc ;_ArraySwap2ByKey
#EndRegion	Run: Functions
#EndRegion	Run:
