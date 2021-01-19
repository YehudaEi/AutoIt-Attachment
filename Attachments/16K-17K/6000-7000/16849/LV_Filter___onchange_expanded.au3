#cs -------------------------------------------------
	
	Author:			John Bailey
	Modifier: 		name
	Date Modified: 	today's date
	ScriptFunction:	description of this script's function
	AutoIt Ver: 	version
	
	Script Version: 1.0.0 (base code).(improved/added features).(script errors corrected)
	
	Script Update History:
			1.1.0 - AdvFilter updated to allow for multiple filtering on single column


	To-Do List (not in importance order):
	->	1. Contextmenu for the search input control using the SearchType options.
	
	-> = working on

#ce -------------------------------------------------


#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <GuiCombo.au3>
#include <File.au3>
#include <Array.au3>


#include <ControlConstants.au3>

Opt ("GUIOnEventMode", 1)
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 1)

;==== Row Entries
; Delim. 
Global $SettingsIR_delimiter = '†'
; File 
Global $dbRowEntriesFile = @ScriptDir&'\LV Filter - onchange expand.txt'
; Array
Global $dbRowEntriesArray
;Array 2D
Global $dbRowEntriesArray2D
;Array 2D Column Count
Global $dbRowEntriesArray2DCount
;====
Global $DoubleClicked   = False
Global $checkedSymbol = chr(149)
Global $unCheckedSymbol = chr(32)

Local $LVHeaders = 'First Name|Last Name|Number|Access'
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
$AppWin = GUICreate("Search Example", 1066, 623, -1, -1)
;GUISetBkColor(0x716F64)
$Input = GUICtrlCreateInput("", 31, 39, 240, 22)
GUICtrlSetFont(-1, 9, 800, 0, "Rockwell")
$Label1 = GUICtrlCreateLabel("Search", 31, 20, 36, 17)
GUICtrlSetColor(-1, 0xC0C0C0)
$LV_Main = GUICtrlCreateListView($LVHeaders, 31, 65, 510, 495)
GUICtrlSendMsg($LV_Main, 0x101E, 0, 120)
GUICtrlSendMsg($LV_Main, 0x101E, 1, 178)
GUICtrlSendMsg($LV_Main, 0x101E, 2, 40)
GUICtrlSendMsg($LV_Main, 0x101E, 3, 70)
;GUICtrlSetBkColor($LV_Main, 0xD4D0C8)

Global $TotalColumns = _GUICtrlListViewGetSubItemsCount($LV_Main)
$dbRowEntriesArray2D =  _setupRowEntries()

$Label2 = GUICtrlCreateLabel("Column To Search", 278, 19, 126, 17)
GUICtrlSetColor($Label2, 0xC0C0C0)
$ColumnToSearchCB = GUICtrlCreateCombo("All", 277, 39, 128, 25)
GUICtrlSetData($ColumnToSearchCB,$LVHeaders)

$SearchTypeCB = GUICtrlCreateCombo("Contains", 412, 39, 128, 25)
GUICtrlSetData($SearchTypeCB, "Does Not Contain|Begins With|Does Not Begin With|Equals|Not Equal|Greater Than|Greater Than or Equal|Less Than|Less Than or Equal|Is Empty|Not Empty|Checked|Not Checked")
$Label3 = GUICtrlCreateLabel("Search Type", 413, 18, 98, 17)
GUICtrlSetColor($Label3, 0xC0C0C0)

$Group1 = GUICtrlCreateGroup("", 563, 81, 457, 370)
$Label4 = GUICtrlCreateLabel("Advanced Filter Section", 639, 101, 286, 17, $SS_CENTER)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Label7 = GUICtrlCreateLabel("Search", 736, 136, 36, 17)
GUICtrlSetColor(-1, 0xC0C0C0)
$Input1 = GUICtrlCreateInput("", 735, 158, 121, 21)
$Input2 = GUICtrlCreateInput("", 735, 190, 121, 21)
$Input3 = GUICtrlCreateInput("", 735, 224, 121, 21)

$Label5 = GUICtrlCreateLabel("Column To Search", 591, 136, 126, 17)
GUICtrlSetColor(-1, 0xC0C0C0)
$Combo6 = GUICtrlCreateCombo("First Name", 590, 158, 136, 25)
GUICtrlSetData(-1, $LVHeaders)
$Combo7 = GUICtrlCreateCombo("Last Name", 591, 190, 136, 25)
GUICtrlSetData(-1, $LVHeaders)
$Combo8 = GUICtrlCreateCombo("Number", 591, 224, 136, 25)
GUICtrlSetData(-1, $LVHeaders)
$Combo9 = GUICtrlCreateCombo("Access", 590, 255, 136, 25)

$Label6 = GUICtrlCreateLabel("Search Type", 864, 136, 98, 17)
GUICtrlSetColor(-1, 0xC0C0C0)
$Combo2 = GUICtrlCreateCombo("Contains", 863, 158, 128, 25)
GUICtrlSetData(-1, "Does Not Contain|Begins With|Does Not Begin With|Equals|Not Equal|Greater Than|Greater Than or Equal|Less Than|Less Than or Equal|Is Empty|Not Empty|Checked|Not Checked")
$Combo3 = GUICtrlCreateCombo("Contains", 863, 191, 128, 25)
GUICtrlSetData(-1, "Does Not Contain|Begins With|Does Not Begin With|Equals|Not Equal|Greater Than|Greater Than or Equal|Less Than|Less Than or Equal|Is Empty|Not Empty|Checked|Not Checked")
$Combo4 = GUICtrlCreateCombo("Contains", 863, 224, 128, 25)
GUICtrlSetData(-1, "Does Not Contain|Begins With|Does Not Begin With|Equals|Not Equal|Greater Than|Greater Than or Equal|Less Than|Less Than or Equal|Is Empty|Not Empty|Checked|Not Checked")
$Combo5 = GUICtrlCreateCombo("", 863, 255, 128, 25)
GUICtrlSetData(-1, "Checked|Not Checked")






$StatusBar = GUICtrlCreateLabel("", 0, 604, 1066, 17, $SS_SUNKEN)

GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

GUISetOnEvent($GUI_EVENT_CLOSE, "_GUIEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_GUIEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "_GUIEvents")

GUICtrlSetOnEvent($ColumnToSearchCB, "ButtonPressed")
GUICtrlSetOnEvent($Combo2, "ButtonPressed")
GUICtrlSetOnEvent($Combo3, "ButtonPressed")
GUICtrlSetOnEvent($Combo4, "ButtonPressed")
GUICtrlSetOnEvent($Combo5, "ButtonPressed")
GUICtrlSetOnEvent($SearchTypeCB, "ButtonPressed")


GUISetState(@SW_SHOW)

_loadRowEntries($LV_Main)

While GUIGetMsg() <> -3
    Sleep(10)
    If $DoubleClicked Then
        DoubleClickFunc()
        $DoubleClicked = False
    EndIf
WEnd


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
	Local $LVtofilter = $LV_Main
	Local $fil_searchInput = $Input
	Local $fil_Array = $dbRowEntriesArray
	Local $fil_Array2D = $dbRowEntriesArray2D
	Local $fil_Array2DColumns = $dbRowEntriesArray2DCount
	Local $fil_SearchTypeCB = $SearchTypeCB
	Local $fil_checkedSymbol = $checkedSymbol
	
	Local $fil_SearchText = GUICtrlRead($fil_searchInput)
	Local $SearchCharLen = StringLen($fil_SearchText)
	_GUICtrlListViewDeleteAllItems($LVtofilter)
	If $fil_SearchText <> '' OR $fil_SearchType = 'Is Empty' OR $fil_SearchType = 'Not Empty' OR $fil_SearchType = 'Checked' OR $fil_SearchType = 'Not Checked' Then
		
		If $fil_SearchType = 'Contains' Then
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array[$a],$fil_SearchText) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_SearchText) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Does Not Contain' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array[$a],$fil_SearchText) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_SearchText) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array2D[$a][$fil_columntoSearch-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result = $fil_SearchText Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Local $String = $fil_Array2D[$a][$fil_columntoSearch-1]
					Local $stringlen = StringLen($String)
					Local $result = StringTrimRight($String, $stringlen-$SearchCharLen)
					
					If $result <> $fil_SearchText Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Equals' Then
			Local $fil_SearchText = GUICtrlRead($fil_searchInput)
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText = $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText = $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Not Equal' Then
			Local $fil_SearchText = GUICtrlRead($fil_searchInput)
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <> $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <> $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Greater Than' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText > $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText > $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Greater Than or Equal' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText >= $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText >= $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Less Than' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText < $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText < $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Less Than or Equal' Then
			Local $fil_SearchText = Number(GUICtrlRead($fil_searchInput))
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <= $fil_Array[$a] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If $fil_SearchText <= $fil_Array2D[$a][$fil_columntoSearch-1] Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
					If $fil_add <> 0 Then _FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Switch Number($fil_SearchText)
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$fil_columntoSearch-1],Number($fil_SearchText)) = '' Then
								_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
							EndIf
						Case Else
							If $fil_Array2D[$a][$fil_columntoSearch-1] = '' Then
								_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
					If $fil_add <> 0 Then _FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					Switch Number($fil_SearchText)
						Case 1,2,3,4,5,6,7,8
							If StringStripWS($fil_Array2D[$a][$fil_columntoSearch-1],Number($fil_SearchText)) <> '' Then
								_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
							EndIf
						Case Else
							If $fil_Array2D[$a][$fil_columntoSearch-1] <> '' Then
								_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
							EndIf
					EndSwitch
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Checked' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array[$a],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		ElseIf	$fil_SearchType = 'Not Checked' Then 
			If $fil_columntoSearch = 0 Then
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array[$a],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			Else
				For $a = 1 to UBound($fil_Array)-1
					If NOT StringInStr($fil_Array2D[$a][$fil_columntoSearch-1],$fil_checkedSymbol) Then
						_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
					EndIf
				Next
			EndIf
		Else ; Search Type is not setup
			MsgBox(0,'Search Type Error',$fil_SearchType&' is not set in the code')
			For $a = 1 to UBound($fil_Array)-1
				_FilterLV_AddtoLV($LVtofilter,$fil_Array,$SettingsIR_delimiter)
			Next
		EndIf
		
	; Full List - No Filter - Blank Input Area
	Else
		For $a = 1 to UBound($fil_Array)-1
			_FilterLV_AddtoLV($LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
	Local $fil_LVtofilter = $LV_Main
	Local $fil_Array = $dbRowEntriesArray
	Local $fil_Array2D = $dbRowEntriesArray2D
	Local $fil_checkedSymbol = $checkedSymbol
	
	Local $sSplit = StringSplit($faaa_string,$SettingsIR_delimiter)
	_GUICtrlListViewDeleteAllItems($fil_LVtofilter)
	For $a = 1 to UBound($fil_Array)-1
		Local $faaa_yes = 1
		Local $count
		For $count =  1 to $sSplit[0]
			Local $cSplit = StringSplit($sSplit[$count],'‡')
			Local $LVHeadersArray=StringSplit($LVHeaders,'|',1)
			Local $fil_ColumnToSearch= _ArraySearch($LVHeadersArray,$cSplit[3],1)
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
			_FilterLV_AddtoLV($fil_LVtofilter,$fil_Array[$a],$SettingsIR_delimiter)
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
Func _FilterLV_AddtoLV(ByRef $fL_LVtofilter, ByRef $fL_LinetoAdd,$fL_delimiter='†')
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


Func _setupRowEntries() ;set it up after the columns are setup
	
	_FileReadToArray($dbRowEntriesFile,$dbRowEntriesArray)
	If @error Then
		Msgbox(0,'File not read to Array',$dbRowEntriesFile&@LF&' to $dbRowEntriesArray')
	EndIf
	Local $headerSplit = StringSplit($LVHeaders,'|',1)
	$dbRowEntriesArray2DCount = $headerSplit[0]
	Local $sre_dbRowEntriesArray2D[UBound($dbRowEntriesArray)][$dbRowEntriesArray2DCount]
	
	Local $x = 1
	For $x = 1 to UBound($dbRowEntriesArray)-1
		Local $readSplitArray = StringSplit($dbRowEntriesArray[$x],$SettingsIR_delimiter,1)
		Local $xx = 0	
		For $xx = 1 to $readSplitArray[0]
			$sre_dbRowEntriesArray2D[$x][$xx-1] = $readSplitArray[$xx]
		Next
	Next
	
	Return $sre_dbRowEntriesArray2D
EndFunc

Func _loadRowEntries(ByRef $lvID)
	For $x = 1 to Ubound($dbRowEntriesArray2D)-1
		Local $itemLine = ''
		For $xx = 1 to $dbRowEntriesArray2DCount
			If $xx = $dbRowEntriesArray2DCount Then
				$itemLine &= $dbRowEntriesArray2D[$x][$xx-1]
				;If $dbRowEntriesArray2D[$x][$xx-1] = 'true' Then
				;	$itemLine &= $checkedSymbol
				;ElseIf $dbRowEntriesArray2D[$x][$xx-1] = 'false' Then
				;	$itemLine &= $checkedSymbol
				;EndIf
			Else
				$itemLine &= $dbRowEntriesArray2D[$x][$xx-1]&'|'
			EndIf
		Next
		GUICtrlCreateListViewItem($itemLine, $lvID)
	Next
EndFunc


Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    ; gaFrost for monitoring inputfield change
	Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

	Switch $nID
        Case $Input
            Switch $nNotifyCode
                Case $EN_CHANGE
					_FilterLVItems(GUICtrlRead($SearchTypeCB),_GUICtrlComboGetCurSel ( $ColumnToSearchCB ))	
			EndSwitch
		Case $Input1, $Input2, $Input3
			Local $df = GUICtrlRead($Input1)&'‡'&GUICtrlRead($Combo2)&'‡'&GUICtrlRead($Combo6)&'†'&GUICtrlRead($Input2)&'‡'&GUICtrlRead($Combo3)&'‡'&GUICtrlRead($Combo7)&'†'&GUICtrlRead($Input3)&'‡'&GUICtrlRead($Combo4)&'‡'&GUICtrlRead($Combo8)&'†'&'blank'&'‡'&GUICtrlRead($Combo5)&'‡'&GUICtrlRead($Combo9)
			_FilterAdv($df)
    EndSwitch
    ; Proceed the default Autoit3 internal message commands.
    ; You also can complete let the line out.
    ; !!! But only 'Return' (without any value) will not proceed
    ; the default Autoit3-message in the future !!!
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND

;==>WM_Notify_Events

Func ButtonPressed()
	Switch @GUI_CTRLID
		case $ColumnToSearchCB
			Local $CBcurrentIndex = _GUICtrlComboGetCurSel ( $ColumnToSearchCB )
			_FilterLVItems(GUICtrlRead($SearchTypeCB),$CBcurrentIndex)
		
		Case $SearchTypeCB
			Local $CBcurrentIndex = _GUICtrlComboGetCurSel ( $ColumnToSearchCB )
			_FilterLVItems(GUICtrlRead($SearchTypeCB),$CBcurrentIndex)
			
		Case $Combo2,$Combo3,$Combo4,$Combo5
			Local $df = GUICtrlRead($Input1)&'‡'&GUICtrlRead($Combo2)&'‡'&GUICtrlRead($Combo6)&'†'&GUICtrlRead($Input2)&'‡'&GUICtrlRead($Combo3)&'‡'&GUICtrlRead($Combo7)&'†'&GUICtrlRead($Input3)&'‡'&GUICtrlRead($Combo4)&'‡'&GUICtrlRead($Combo8)&'†'&'blank'&'‡'&GUICtrlRead($Combo5)&'‡'&GUICtrlRead($Combo9)
			_FilterAdv($df)

	EndSwitch
EndFunc

Func DoubleClickFunc()
    MsgBox(64, "OK", "Double Clicked: " & GUICtrlRead(GUICtrlRead($LV_Main)))
EndFunc

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam)
    If @error Then Return 0
    $code = DllStructGetData($tagNMHDR, 3)
    If $wParam = $LV_Main And $code = -3 Then $DoubleClicked = True
    Return $GUI_RUNDEFMSG
EndFunc

Func _GUIEvents()
    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            Exit        
			
        Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
            
        Case @GUI_CTRLID = $GUI_EVENT_RESTORE
            
    EndSelect
    
EndFunc
