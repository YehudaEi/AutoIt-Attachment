#include-once

;Setup Globals
Global $lvfil_LVtofilter 
Global $lvfil_searchInput
Global $lvfil_Array
Global $lvfil_Array2D
Global $lvfil_Array2DColumns
Global $lvfil_SearchTypeCB
Global $lvfil_checkedSymbol
Global $lvfil_delimiter
Global $lvfil_LVHeaders

;Globals must be setup with this version of the script (i'd like to do something different, but in keeping it simple something is evading me)
Func _LVFilter_SetupGlobals( _
	byRef $lvfil_LV_v, _ ; The Listview Control you want to show the results in 
	byRef $lvfil_searchInput_v, _  ; The Input Control where you will type what you want to filter
	byRef $lvfil_Array_v, _ ; The Array that contains the "raw" database
	ByRef $lvfil_Array2D_v, _  ; The 2D Array that contains the database split into columns for each entry similar to how a listview is setup
	ByRef $lvfil_Array2DColumns_v, _ ; How many columns are in the 2D Array
	ByRef $lvfil_SearchTypeCB_v, _ ; The combobox control for the search Input control
	ByRef $lvfil_checkedSymbol_v, _ ; What is the symbol you are using for a column that is checked
	ByRef $lvfil_delimiter_v, _ ; The delimiter that is used to signify where the "raw" database items are split into columns
	ByRef $lvfil_LVHeaders_v _  ; The name of the column headers for the Listview Control
	)
	
	$lvfil_LVtofilter = $lvfil_LV_v
	$lvfil_searchInput = $lvfil_searchInput_v
	$lvfil_Array = $lvfil_Array_v
	$lvfil_Array2D = $lvfil_Array2D_v
	$lvfil_Array2DColumns = $lvfil_Array2DColumns_v
	$lvfil_SearchTypeCB = $lvfil_SearchTypeCB_v
	$lvfil_checkedSymbol = $lvfil_checkedSymbol_v
	$lvfil_delimiter = $lvfil_delimiter_v
	$lvfil_LVHeaders = $lvfil_LVHeaders_v
 EndFunc


#include <GuiListView.au3>
#include <GuiCombo.au3>
;===============================================================================
;
; Function Name:    _()
; Description:      
; Parameter(s):     
;					$				-  string	- Optional: 
;															0 = (Default) 1
;															1 = 1
;
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns 1 
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = 
;								- 1 = 
;								- 2 = 
;								- 3 = 
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _FilterLVItems($fil_SearchType='Contains',$fil_columntoSearch=0)
	
	Local $fil_LVtofilter = $lvfil_LVtofilter
	Local $fil_searchInput = $lvfil_searchInput
	Local $fil_Array = $lvfil_Array
	Local $fil_Array2D = $lvfil_Array2D
	Local $fil_Array2DColumns = $lvfil_Array2DColumns
	Local $fil_SearchTypeCB = $lvfil_SearchTypeCB
	Local $fil_checkedSymbol = $lvfil_checkedSymbol
	
	Local $fil_SearchText = GUICtrlRead($fil_searchInput)
	Local $SearchCharLen = StringLen($fil_SearchText)
	_GUICtrlListViewDeleteAllItems($fil_LVtofilter)
	If $fil_SearchText <> '' OR $fil_SearchType = 'Is Empty' OR $fil_SearchType = 'Not Empty' OR $fil_SearchType = 'Checked' OR $fil_SearchType = 'Not Checked' Then
		
		If $fil_SearchType = 'Contains' Then
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array[$a],$fil_SearchText) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_SearchText) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Does Not Contain' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array[$a],$fil_SearchText) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_SearchText) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf $fil_SearchType = 'Begins With' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array[$a]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					If $result = $fil_SearchText Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array2D[$a][$fil_columntoSearch-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result = $fil_SearchText Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf $fil_SearchType = 'Does Not Begin With' Then
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array[$a]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					If $result <> $fil_SearchText Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array2D[$a][$fil_columntoSearch-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result <> $fil_SearchText Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Equals' Then
			Local $fil_SearchText = GUICtrlRead($fil_searchInput)
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText = $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText = $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Not Equal' Then
			Local $fil_SearchText = GUICtrlRead($fil_searchInput)
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <> $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <> $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Greater Than' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText > $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText > $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Greater Than or Equal' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText >= $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText >= $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Less Than' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText < $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText < $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Less Than or Equal' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <= $fil_Array[$a] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <= $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
			
			
		ElseIf	$fil_SearchType = 'Is Empty' Then
			
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					Local $fil_subCounter=0
					Local $fil_add = 0
					For $fil_subCounter=1 to $fil_Array2DColumns
						Switch Number($fil_SearchText)
							Case 1,2,3,4,5,6,7,8
								If StringStripWS($fil_Array2D[$a][$fil_subCounter-1],Number($fil_SearchText)) = '' Then
									$fil_add = 1
								EndIf
							Case Else
								If $fil_Array2D[$a][$fil_subCounter-1] = '' Then
									$fil_add = 1
								EndIf
						EndSwitch
					Next
					If $fil_add <> 0 Then _FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Switch Number($fil_SearchText)
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$fil_columntoSearch-1],Number($fil_SearchText)) = '' Then
								_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
							EndIf
						Case Else
							If $fil_Array2D[$a][$fil_columntoSearch-1] = '' Then
								_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
							EndIf
					EndSwitch
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Not Empty' Then
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					Local $fil_subCounter=0
					Local $fil_add = 0
					For $fil_subCounter=1 to $fil_Array2DColumns
						Switch Number($fil_SearchText)
							Case 1,2,3,4,5,6,7,8
								If StringStripWS($fil_Array2D[$a][$fil_subCounter-1],Number($fil_SearchText)) <> '' Then
									$fil_add = 1
								EndIf
							Case Else
								If $fil_Array2D[$a][$fil_subCounter-1] <> '' Then
									$fil_add = 1
								EndIf
						EndSwitch
					Next
					If $fil_add <> 0 Then _FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Switch Number($fil_SearchText)
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$fil_columntoSearch-1],Number($fil_SearchText)) <> '' Then
								_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
							EndIf
						Case Else
							If $fil_Array2D[$a][$fil_columntoSearch-1] <> '' Then
								_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
							EndIf
					EndSwitch
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Checked' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array[$a],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Not Checked' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array[$a],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
					EndIf
				Next
			EndIf
		Else ; Search Type is not setup
			MsgBox(0,'Search Type Error',$fil_SearchType&' is not set in the code')
			For $a = 1 to UBound($fil_Array)-1
				_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array,$lvfil_delimiter)
			Next
		EndIf
		
	; Full List - No Filter - Blank Input Area
	Else
		For $a = 1 to UBound($fil_Array)-1
			_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
		Next
	EndIf
EndFunc


;===============================================================================
;
; Function Name:    _FilterAdv()
; Description:      
; Parameter(s):     
;					$				-  string	- Optional: 
;															0 = (Default) 1
;															1 = 1
;
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns 1 
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = 
;								- 1 = 
;								- 2 = 
;								- 3 = 
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _FilterAdv($faaa_string)
	
	Local $fil_LVtofilter = $lvfil_LVtofilter
	Local $fil_searchInput = $lvfil_searchInput
	Local $fil_Array = $lvfil_Array
	Local $fil_Array2D = $lvfil_Array2D
	Local $fil_Array2DColumns = $lvfil_Array2DColumns
	Local $fil_SearchTypeCB = $lvfil_SearchTypeCB
	Local $fil_checkedSymbol = $lvfil_checkedSymbol
	
	Local $sSplit = StringSplit($faaa_string,$lvfil_delimiter)
	_GUICtrlListViewDeleteAllItems($fil_LVtofilter)
	For $a = 1 to UBound($fil_Array)-1
		
		Local $faaa_yes = 1
		Local $count
		For $count =  1 to $sSplit[0]
			Local $cSplit = StringSplit($sSplit[$count],'�')
			Local $lvfil_LVHeadersArray=StringSplit($lvfil_LVHeaders,'|',1)
			Local $fil_ColumnToSearch= _ArraySearch($lvfil_LVHeadersArray,$cSplit[3],1)
			Local $counter = $fil_ColumnToSearch
			If $cSplit[1] <> '' Then
				If $cSplit[2] = 'Contains' Then
					If NOT StringInStr($fil_Array2D[$a][$counter-1],$cSplit[1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Does Not Contain' Then
					If StringInStr($fil_Array2D[$a][$counter-1],$cSplit[1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Begins With' Then
					Local $SearchCharLen = StringLen($cSplit[1])
					Local $String = $fil_Array2D[$a][$counter-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result <> $cSplit[1] Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Does Not Begin With' Then
					Local $SearchCharLen = StringLen($cSplit[1])
					Local $String = $fil_Array2D[$a][$counter-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result = $cSplit[1] Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Equals' Then
					If $cSplit[1] <> $fil_Array2D[$a][$counter-1] Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Not Equal' Then
					If $cSplit[1] = $fil_Array2D[$a][$counter-1] Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Greater Than' Then
					If Number($cSplit[1]) >= Number($fil_Array2D[$a][$counter-1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Greater Than or Equal' Then
					If Number($cSplit[1]) > Number($fil_Array2D[$a][$counter-1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Less Than' Then
					If Number($cSplit[1]) <= Number($fil_Array2D[$a][$counter-1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Less Than or Equal' Then
					If Number($cSplit[1]) < Number($fil_Array2D[$a][$counter-1]) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Is Empty' Then
					Switch Number($cSplit[1])
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$counter-1],Number($cSplit[1])) <> '' Then
								$faaa_yes = 0
							EndIf
						Case Else
							If $fil_Array2D[$a][$counter-1] <> '' Then
								$faaa_yes = 0
							EndIf
					EndSwitch
				ElseIf $cSplit[2] = 'Not Empty' Then
					Switch Number($cSplit[1])
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$counter-1],Number($cSplit[1])) = '' Then
								$faaa_yes = 0
							EndIf
						Case Else
							If $fil_Array2D[$a][$counter-1] = '' Then
								$faaa_yes = 0
							EndIf
					EndSwitch
				ElseIf $cSplit[2] = 'Checked' Then
					If NOT StringInStr($fil_Array2D[$a][$counter-1],$fil_checkedSymbol) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = 'Not Checked' Then
					If StringInStr($fil_Array2D[$a][$counter-1],$fil_checkedSymbol) Then
						$faaa_yes = 0
					EndIf
				ElseIf $cSplit[2] = '' Then
					;
				Else
					MsgBox(0,'Search Type Error',$cSplit[2]&' is not set in the code')
				EndIf
			EndIf
		Next	
		
		If $faaa_yes = 1 Then
			_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$lvfil_delimiter)
		EndIf
	Next
EndFunc



;===============================================================================
;
; Function Name:    _()
; Description:      
; Parameter(s):     
;					$				-  string	- Optional: 
;															0 = (Default) 1
;															1 = 1
;
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns 1 
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = 
;								- 1 = 
;								- 2 = 
;								- 3 = 
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _FilterLV_AddtoLV(ByRef $fL_LVtofilter, ByRef $fL_LinetoAdd,$fL_delimiter='�')
	Local $itemLineArray = StringSplit($fL_LinetoAdd,$fL_delimiter,1)
	Local $itemLine = ''
	Local $b
	For $b = 1 to $itemLineArray[0]
		If $b = $itemLineArray[0] Then
			$itemLine &= $itemLineArray[$b]
		Else
			$itemLine &= $itemLineArray[$b]&'|'
		EndIf
	Next
	GUICtrlCreateListViewItem($itemLine, $fL_LVtofilter)
EndFunc