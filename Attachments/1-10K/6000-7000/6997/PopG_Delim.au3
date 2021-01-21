; PopG_Delim.au3 - Andy Swarbrick (c) 2005-6
#Region		Doc:
#Region		Doc: Notes
; Provides "delimited list" support which is so, so useful to Au3 features such as GuiCtrlListView and almost every aspect of Au3 life.
; Au3 build 3.1.1.109 or better.
; This library is one of a suite of extensions to Au3.  
#EndRegion	Doc: Notes
#Region		Doc: Requirements
; Au3 build 3.1.1.109 or better.
; <array.au3>
#EndRegion	Doc: Requirements
#Region		Doc: History
; 19-Feb-03 Als Updated	_DelimListReplaceItem with a bugfix.
; 19-Feb-06 Als Renamed	_DelimListSplit to _DelimListSplit
; 19-Feb-06 Als Updated	_DelimListSplit with optional delimiter argument, defaulting to GUIDataSeparatorChar.
; 19-Feb-06 Als Added	_DelimListSort
; 18-Feb-06 Als Updated	_DelimListGetIndex by adding optional case-sensitivity argument (defaulting to case-insensitive).
; 05-Feb-06 Als Added	_DelimListSplit
#EndRegion	Doc: History
#Region		Doc: FunctionList
; _DelimListGetIndex					Returns the index position of one string in a delimited string.
; _DelimListGetText						Returns the text at an index position in a delimited string.
; _DelimListPadDelims					Ensures that there are at least a certain number of delimiters in a string
; _DelimListReplaceItem					Replaces a subitem in a string, such as one used in a ListView using StringReplaceby searching for the substring
; _DelimListSetItem						Replaces a subitem in a string, such as one used in a ListView by occurence of delimiters in the string.
; _DelimListSort						Returns a delimited list in sorted order
; _DelimListSplit						Splits a delimted list into left and right at the specified occurence of delimter.
#EndRegion	Doc: FunctionList
#EndRegion	Doc:
#Region		Init:
#Region		Init: Includes
	#include-once
	#include <array.au3>
#EndRegion	Init: Includes
#EndRegion	Init:
#Region		Run:
#Region		Run: TestHarness
#Region		Run: Test _DelimListSort
;~ 	$Str=_DelimListSort('za|ab|alpha|xyz')
;~ 	ConsoleWrite('@@ Debug(29) : $Str = ' & $Str & @lf & '>Error code: ' & @error & @lf) ;### Debug Console
#Region		Run: Test _DelimListPadDelims
;~ 	Local $str='fred|joe'
;~ 	Local $Qty=09
;~ 	$str=_DelimListPadDelims($str,$Qty)
;~ 	MsgBox(0,'padded str',$str)
#EndRegion	Run: Test _DelimListPadDelims
#EndRegion	Run: TestHarness
#Region		Run: Functions
; _DelimListGetIndex					Returns the index position of one string in a delimited string.
;
; Parameters:
; $List			The list from which to find the index of a given string
; $Item			The item from the list for which you wish to know the index
; $Case			Whether you wish to do a case-sensitive check (1/True) or not, default is case-insensitive (0/False)
;
; History:
; 18-Feb-06 Als Updated _DelimListGetIndex by adding optional case-sensitivity argument (defaulting to case-insensitive).
Func _DelimListGetIndex($List,$Item,$Case=False)
	Local $Dlm=Opt('GUIDataSeparatorChar')
	Local $ListArr=StringSplit($List,$Dlm)
	For $Idx=1 To $ListArr[0]
		If $Case Then
			If $ListArr[$Idx]==$Item Then Return $Idx
		Else
			If $ListArr[$Idx]=$Item Then Return $Idx
		EndIf
	Next
	Return 0
EndFunc ;_DelimListGetIndex
; _DelimListGetText						Returns the text at an index position in a delimited string.
;
; Parameters:
; $List			The list from which you wish to get text.
; $Idx			The posiotion (1-based) that you wish to return.
; $Dlm			The list delimiter to be used, defaults to GUIDataSeparatorChar.
Func _DelimListGetText($List,$Idx,$Dlm='')
	If $Dlm='' Then $Dlm=Opt('GUIDataSeparatorChar')
	Local $ListArr=StringSplit($List,$Dlm)
	Return $ListArr[$Idx]
EndFunc ; _DelimListGetText
; _DelimListPadDelims					Ensures that there are at least a certain number of delimiters in a string
;
; Parameters:
; $List				The list that may need padding with additional delimiters.
; $Qty				The number of entries you want in the list.  Number of delimiters will be one less than this value.
Func _DelimListPadDelims($List,$Qty)
	Local $Dlm=Opt('GUIDataSeparatorChar')
	If $Qty<=0 Then Return $List
	While StringInStr($List,$Dlm,0,$Qty)=0
		$List=$List&$Dlm
	WEnd
	Return $List
EndFunc ;_DelimListPadDelims
; _DelimListReplaceItem					Replaces a subitem in a string, such as one used in a ListView using StringReplaceby searching for the substring
;
; Notes:
; Follows same search and replace rules as StringReplace
; StringReplace by start position is not supported.
;
; Parameters:
; $List				The list in which the item is to be found.
; $OldItem			The new text that is to be inerted.
; $NewItem			The new text that is to be inerted.
; $Case				Whether the search test should be case-sensitive=(1/True), ddefault is case-insenstitive (0/false).
; $Occur			Optional: Enables you to replace multiple occurences, default is first occcurence.
;
; History:
; 19-Feb-03 Als Updated _DelimListReplaceItem with a bugfix.
Func _DelimListReplaceItem($List,$OldItem,$NewItem,$Case=False,$Occur=1)
	Local $Dlm=Opt('GUIDataSeparatorChar')
	Local $r=StringMid(StringReplace($Dlm&$List&$Dlm, $Dlm&$OldItem&$Dlm, $Dlm&$NewItem&$Dlm, $Case, $Occur),2)
	Return StringLeft($r,StringLen($r)-1)
EndFunc ;_DelimListReplaceItem
; _DelimListSetItem						Replaces a subitem in a string, such as one used in a ListView by occurence of delimiters in the string.
;
; Notes:
; Follows same search and Set rules as StringSet.
;
; Parameters:
; $List				The list in which the item is to be replaced.
; $NewItem			The new text to be inserted.
; $Index			The position (1-based) that need to be replaced.
Func _DelimListSetItem($List,$NewItem,$Index)
	Local $Dlm=Opt('GUIDataSeparatorChar')
	Local $Pos1=StringInStr($Dlm&$List,$Dlm,0,$Index+1)-1
	Local $Pos2=StringInStr($Dlm&$List,$Dlm,0,$Index+2)-1
	$List=StringLeft($List,$Pos1) &$NewItem& StringMid($List,$Pos2)
	Return $List
EndFunc ;_DelimListSetItem
; _DelimListSplit						Splits a delimted list into left and right at the specified occurence of delimter.
;
; Paremeters:
; $List				The list to be split
; $Left				Returned value (ByRef) of the left-hand side of the $List
; $Right			Returned value (ByRef) of the right-hand side of $List
; $Occur			The occurence of the delimiter at which the split should be made
;
; History:
; 19-Feb-06 Als Updated _DelimListSplit with optional delimiter argument, defaulting to GUIDataSeparatorChar.
; 19-Feb-06 Als Renamed _DelimListSplit to _DelimListSplit
Func _DelimListSplit($List,ByRef $Left,ByRef $Right,$Occur=1, $Dlm='')
	If $Dlm='' Then $Dlm=Opt('GUIDataSeparatorChar')
	Local $Pos
	$Pos	=StringInStr	($List,$Dlm,False,$Occur)
	$Left	=StringLeft		($List,$Pos-1)
	$Right	=StringMid		($List,$Pos+1)
EndFunc ; _DelimListSplit
; _DelimListSort						Returns a delimited list in sorted order
;
; Paramters:
; $List				The list to be sorted
; $i_descending		Whether to sort ascending=(0/True) (default) or descending(=True/1)
;
; History:
; 19-Feb-06 Als Added _DelimListSort
Func _DelimListSort($List,$i_descending=0)
	Local $Dlm=Opt('GUIDataSeparatorChar')
	Local $ListArr=StringSplit($List,$Dlm)
	If $ListArr[0]<=1 Then Return $List
	;
	Local $i,$NewList
	_ArraySort($ListArr,$i_descending,1)
	$NewList=$ListArr[1]
	For $i=2 To $ListArr[0]
		$NewList=$NewList&$Dlm&$ListArr[$i]
	Next
	Return $NewList
EndFunc
#EndRegion	Run: Functions
#EndRegion	Run:
