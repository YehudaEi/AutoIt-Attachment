; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include<GUIConstants.au3>
#include<GuiListView.au3>
#include<Array.au3>
#include<FileWriteToLine.au3>

opt("GUIOnEventMode", 1)  ; Change to OnEvent mode
opt("GUICloseOnESC", 0)
opt("TrayIconDebug", 1)

Dim $DefaultPath = "C:\GTK\RnD\QA\TestMaster\"
Dim $ActionPath = ($DefaultPath & "Actions\")
Dim $SourcePath = ($DefaultPath & "Source\")
Dim $Actfilename = "GlobalSuite"

Dim $SynapseActions = "Synapse";	This is the array of actions/tests in Synapse templates
Dim $GlobalSuiteActions = "GlobalSuite";	This is the array of actions/tests in GlobalSuite templates

Dim $VRegA ;         \
Dim $VRegB ;          |_ "Virtual Registers", used for
Dim $VRegC ;          |  holding data between GUIs.
Dim $VRegD ;          |
Dim $VRegE[4] ;       |
Dim $WinList[2][1] ; /

; ==========================================================================================================
; TO DO: 	Find a way to remove lines from a file, insert lines in a file, overwrite a line in a file, etc.
; 			Take that info and use it to edit & delete actions in the action files
; ==========================================================================================================

$mainHandle = _TM_Initialize()
While 1
	Sleep(100)
	$actionSelected = GUICtrlRead($VRegE[0])
	if $actionSelected and $actionSelected <> $oldAction then _TM_TemplateViewActionValues($actionSelected)
	$oldAction = $actionSelected
WEnd

#region Window Array
Func _TM_WinArrPush($WinName, $WinHandle)
	$WLIndex = UBound($WinList, 2)
	If $WinList[0][0] <> "" Or $WLIndex > 1 Then $WLIndex = $WLIndex + 1
	
	Dim $NewList[2][$WLIndex]
	For $i = 0 To $WLIndex - 2
		$NewList[0][$i] = $WinList[0][$i]
		$NewList[1][$i] = $WinList[1][$i]
	Next
	$NewList[0][$WLIndex - 1] = $WinName
	$NewList[1][$WLIndex - 1] = $WinHandle
	$WinList = $NewList
	Return $WinList
EndFunc   ;==>_TM_WinArrPush

Func _TM_WinArrPop()
	Dim $popped[2]
	
	$WLIndex = UBound($WinList, 2)
	
	$popped[0] = $WinList[0][$WLIndex - 1]
	$popped[1] = $WinList[1][$WLIndex - 1]
	If $WLIndex < 2 Then
		Dim $emptyList[2][1]
		$WinList = $emptyList
		Return $popped
	EndIf
	
	$newDecrement = $WLIndex - 1
	Dim $NewList[2][$newDecrement]
	
	For $i = 0 To $WLIndex - 2
		$NewList[0][$i] = $WinList[0][$i]
		$NewList[1][$i] = $WinList[1][$i]
	Next
	$WinList = $NewList
	Return $popped
EndFunc   ;==>_TM_WinArrPop

Func _TM_WinArrGlanceBack($NumWins = 0)
	Dim $glance[2]
	
	$WLIndex = UBound($WinList, 2)
	
	If $WLIndex < 2 And $WinList[0][0] == "" Then
		Return 0
	ElseIf $NumWins > $WLIndex Then
		Return 0
	EndIf
	
	$glance[0] = $WinList[0][$WLIndex - $NumWins - 1]
	$glance[1] = $WinList[1][$WLIndex - $NumWins - 1]
	Return $glance
EndFunc   ;==>_TM_WinArrGlanceBack
#endregion

; --- _TM_Initialize() ---
; GUI = {} -> Guest-Tek Testmaster
; Control = {} -> {}
; ------------------------
Func _TM_Initialize()
	$mainwindow = GUICreate("Guest-Tek TestMaster", 520, 560)
	GUISetBkColor(0x7A9AAA)
	GUISwitch($mainwindow)
	GUISetState()
	
	_TM_WinArrPush("Guest-Tek TestMaster", $mainwindow)
	
	;	$Arrcurr = _TM_WinArrGlanceBack()
	;	ConsoleWrite("contents = "&$Arrcurr[0]&", handle = "&$Arrcurr[1]&@CR)
	
	$TMmenu = GUICtrlCreateMenu("&File")
	$TMmenuNewFile = GUICtrlCreateMenu("New Template", $TMmenu)
	$TMmenuGSuiteFile = GUICtrlCreateMenuItem("For GlobalSuite", $TMmenuNewFile)
	$TMmenuSynapseFile = GUICtrlCreateMenuItem("For Synapse", $TMmenuNewFile)
	$TMmenuOpenFile = GUICtrlCreateMenuItem("Open Existing Template", $TMmenu)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	$TMmenuSaveFile = GUICtrlCreateMenuItem("Save Template", $TMmenu)
	GUICtrlCreateMenuItem("", $TMmenu)
	$TMmenuExitFile = GUICtrlCreateMenuItem("Exit TestMaster", $TMmenu)
	
	$addAction = GUICtrlCreateButton("Add Action", 10, 10, 80, 20)
	$editAction = GUICtrlCreateButton("Edit Action", 90, 10, 80, 20)
	$delAction = GUICtrlCreateButton("Delete Action", 170, 10, 80, 20)
	
	$addSuite = GUICtrlCreateButton("Add Suite", 265, 10, 80, 20)
	$editSuite = GUICtrlCreateButton("Edit Suite", 345, 10, 80, 20)
	$delSuite = GUICtrlCreateButton("Delete Suite", 425, 10, 80, 20)
	
	$fnList = GUICtrlCreateListView("Name|Act/Tst", 10, 40, 132, 300)
	$VRegE[0] = $fnList
	
	$Act2Suite = GUICtrlCreateButton("+", 150, 50, 25, 20, $BS_BITMAP)
	$RemActFrmSuite = GUICtrlCreateButton("-", 150, 70, 25, 20, $BS_BITMAP)
	$Act2Template = GUICtrlCreateButton("++", 150, 100, 25, 20, $BS_BITMAP)
	
	$suiteList = GUICtrlCreateListView("Name|Actions", 182, 40, 132, 300)
	$VRegE[1] = $suiteList
	$Suite2Template = GUICtrlCreateButton("+", 323, 50, 25, 20, $BS_BITMAP)
	$RemSuiteFrmTemplate = GUICtrlCreateButton("-", 323, 70, 25, 20, $BS_BITMAP)
	$ActFrmTemplate = GUICtrlCreateButton("--", 323, 100, 25, 20, $BS_BITMAP)
	
	$usingList = GUICtrlCreateListView("Name|Act/Tst/Suite", 355, 40, 150, 300)
	$VRegE[2] = $usingList
	
	$InfoDisplay = GUICtrlCreateEdit("== Data Displayed Here ==", 10, 350, 500, 180, 0x0800)
	$VRegE[3] = $InfoDisplay
	
	_TM_TemplateLoadActionArray()
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TM_CLOSEClicked")
	
	GUICtrlSetOnEvent($TMmenuGSuiteFile, "_TM_TemplateNewGS")
	GUICtrlSetOnEvent($TMmenuSynapseFile, "_TM_TemplateNewSynapse")
	GUICtrlSetOnEvent($TMmenuOpenFile, "_TM_TemplateOpen")
	GUICtrlSetOnEvent($TMmenuSaveFile, "_TM_TemplateSave")
	GUICtrlSetOnEvent($TMmenuExitFile, "_TM_CLOSEClicked")
	
	GUICtrlSetOnEvent($fnList, "_TM_SortViewList")
;	GUICtrlSetOnEvent($suiteList, "_TM_SortViewList")
	
	GUICtrlSetOnEvent($addAction, "_TM_ActionAdd")
	GUICtrlSetOnEvent($delAction, "_TM_TemplateDeleteAction")
	
	Return $mainwindow
EndFunc   ;==>_TM_Initialize

; --- _TM_CLOSEClicked() ---
; GUI = ANY GUI
; Control = Cancel button, File -> Exit, Frame "X"
; --------------------------
Func _TM_CLOSEClicked()
	ConsoleWrite("-" & @GUI_WinHandle & @CR)
	If @GUI_WinHandle == $mainHandle Then
		Exit
	Else
		GUIDelete(@GUI_WinHandle)
	EndIf
	_TM_WinArrPop()
EndFunc   ;==>_TM_CLOSEClicked

; --- _TM_SortViewList() ---
; GUI = Any
; Control = ListView (any)
; Description: Sorts the ListView by the column selected
Func _TM_SortViewList()
	$column2SortBy = GUICtrlGetState(@GUI_CtrlId)
	$target = @GUI_CtrlId
	_GUICtrlListViewSort ($target, 0, $column2SortBy)
	GUISetState(@SW_SHOW, "Guest-Tek TestMaster")
	Return 0
EndFunc   ;==>_TM_SortViewList

#region template
; ---- _TM_TemplateNewGS() ----
; GUI = Guest-Tek Testmaster
; Control = File -> New
; ---------------------------
Func _TM_TemplateNewGS()
	GUIDelete(@GUI_WinHandle)
	_TM_WinArrPop()
	$Actfilename = "GlobalSuite"
	$mainHandle = _TM_Initialize()
EndFunc   ;==>_TM_TemplateNewGS

; ---- _TM_TemplateNewGS() ----
; GUI = Guest-Tek Testmaster
; Control = File -> New
; ---------------------------
Func _TM_TemplateNewSynapse()
	GUIDelete(@GUI_WinHandle)
	_TM_WinArrPop()
	$Actfilename = "Synapse"
	$mainHandle = _TM_Initialize()
EndFunc   ;==>_TM_TemplateNewSynapse

; --- _TM_TemplateOpen() ---
; GUI = Guest-Tek Testmaster
; Control = File -> Open
; --------------------------
Func _TM_TemplateOpen()
	If Not FileExists($ActionPath) Then DirCreate($ActionPath)
	$file = FileOpenDialog("Choose file...", $ActionPath, "QA Templates (*.gtt)|All (*.*)")
EndFunc   ;==>_TM_TemplateOpen

; --- _TM_TemplateSave() ---
; GUI = Guest-Tek Testmaster
; Control = File -> Save
; --------------------------
Func _TM_TemplateSave()
	If Not FileExists($ActionPath) Then DirCreate($ActionPath)
	$file = FileSaveDialog("Save Template", $ActionPath, "QA Templates (*.gtt)", 16)
EndFunc   ;==>_TM_TemplateSave

Func _TM_TemplateDeleteAction()
	$victim = GUICtrlRead($VregE[0])
	if $victim == 0 then return 0
	
	$victimName = StringSplit(GUICtrlRead($victim), "|")
	$confirmation = MsgBox(4, "Delete Action", "Are you sure you want to delete "&StringLower($victimName[2])&" '"&$victimName[1]&"'?")
	if $confirmation == 7 then return 0

	$readingFile = FileOpen($ActionPath & $Actfilename & ".xml", 0)
	If $readingFile == -1 Then Return 0
		
	$deathzone = _TM_ActionFind($victimName[1])
	;ConsoleWrite("and the winner is... line "&$deathzone&": "&FileReadLine($readingFile, $deathzone)&@CR)

	Do
		_FileWriteToLine($ActionPath&$Actfilename&".xml", $deathzone, "", 1)
	until StringInStr(FileReadLine($readingFile, $deathzone), "<action>") or StringInStr(FileReadLine($readingFile, $deathzone), "</xml>")
	
	GUICtrlDelete($victim)
	
	GUISetState(@SW_SHOW, "Guest-Tek TestMaster")
	FileClose($readingFile)
EndFunc   ;==>_TM_TemplateDeleteAction

; --- _TM_TemplateLoadActionArray($functionList) ---
; GUI = Guest-Tek Testmaster
; Control = none
; Description: Populated the Action List with data
Func _TM_TemplateLoadActionArray()
	$i = 1
	while (_TM_ActionGet("", $i) <> 0)
		$i = $i + 1
		$listActionName = $VRegA[0]
		$listActionType = "Action"
		If $VRegA[1] <> "" Then $listActionType = "Test"
		$thisAction = GUICtrlCreateListViewItem($listActionName & "|" & $listActionType, $VRegE[0])
	WEnd
	GUISetState(@SW_SHOW, "Guest-Tek TestMaster")
	Return 0
EndFunc   ;==>_TM_TemplateLoadActionArray

Func _TM_TemplateViewActionValues($itemSelected)
	$focusAction = $itemSelected
	$focusActData = StringSplit(GUICtrlRead($focusAction), "|")
	if _TM_ActionGet($focusActData[1]) == 0 or $focusActData[0] == 0 then return 0
	
	GUICtrlSetData($VregE[3], "Name: "&$VRegA[0]&"   Type: "&$VRegA[1]&@CRLF&"Screenshots: {")
	if $VRegA[2] then GUICtrlSetData($VregE[3], " Before", 1)
	if $VRegA[3] then GUICtrlSetData($VregE[3], " After", 1)
	if $VRegA[4] then GUICtrlSetData($VregE[3], " OnError", 1)

	GUICtrlSetData($VregE[3], " }"&@CRLF&"URL: ["&$VregA[5]&"]->["&$VregA[6]&"]"&@CRLF&"Inputs: {", 1)
	for $i = 0 to UBound($VRegB)-1 
		$ActInpString = StringSplit($VRegB[$i], "|")
		GUICtrlSetData($VRegE[3], @CRLF&" "&$ActInpString[1]&"("&$ActInpString[2]&") = '"&$ActInpString[3]&"'",1)
	Next
	GUICtrlSetData($VRegE[3], "}"&@CRLF&"Data: {",1)
	
	for $i = 0 to UBound($VRegC)-1 
		$ActDatString = StringSplit($VRegC[$i], "|")
		GUICtrlSetData($VRegE[3], @CRLF&" "&$ActDatString[1]&"("&$ActDatString[2]&") = '"&$ActDatString[3]&"'",1)
	Next
	GUICtrlSetData($VRegE[3], "}",1)
	
	;GUISetState(@SW_SHOW, @GUI_WinHandle)
EndFunc

#endregion
#region action
; --- _TM_ActionAdd() ---
; GUI = Guest-Tek Testmaster -> Add Action
; Control = Add Action button -> {}
; -----------------------
Func _TM_ActionAdd(); Uses all Virtual Registers
	Dim $ActTotal[3][9]
	Dim $FinalInList
	Dim $FinalDatList
	
	$addActionGUI = GUICreate("Add Action", 350, 300)
	GUISwitch($addActionGUI)
	GUISetState()
	ConsoleWrite(@GUI_WinHandle & "+ ... Add Action" & @CR)
	_TM_WinArrPush("Add Action", $addActionGUI)
	
	$CheckTest = GUICtrlCreateCheckbox("Test", 220, 10)
	GUICtrlCreateLabel("Action Name:", 10, 14)
	$ActName = GUICtrlCreateInput("", 77, 10, 120, 20)
	GUICtrlCreateLabel("Take Screenshot:", 10, 44)
	$CheckSSBefore = GUICtrlCreateCheckbox("Before", 105, 40)
	$CheckSSAfter = GUICtrlCreateCheckbox("After", 165, 40)
	$CheckSSError = GUICtrlCreateCheckbox("Error", 220, 40)
	
	GUICtrlCreateLabel("Starting URL:", 10, 70)
	$StartURL = GUICtrlCreateInput("", 10, 85, 160, 20)
	GUICtrlCreateLabel("Ending URL:", 180, 70)
	$EndURL = GUICtrlCreateInput("", 180, 85, 160, 20)
	$AddInput = GUICtrlCreateButton("Add Input", 20, 115, 60, 20)
	$DelInput = GUICtrlCreateButton("Delete", 95, 115, 60, 20)
	$AddData = GUICtrlCreateButton("Add Data", 190, 115, 60, 20)
	$DelData = GUICtrlCreateButton("Delete", 265, 115, 60, 20)
	$InputList = GUICtrlCreateListView("Input |Type |Value", 10, 145, 160, 120)
	$VRegB = $InputList
	ConsoleWrite("Input List = " & $InputList & @CR)
	$DataList = GUICtrlCreateListView("Data |Type |Contains", 180, 145, 160, 120)
	$VRegC = $DataList
	$SubmitAction = GUICtrlCreateButton("Add", 90, 275, 50, 20)
	$CancelAddAction = GUICtrlCreateButton("Cancel", 150, 275, 50, 20)
	$HelpAddAction = GUICtrlCreateButton("Help", 210, 275, 50, 20)
	
	$ActTotal[0][0] = "Name"
	$ActTotal[0][1] = "Test"
	$ActTotal[0][2] = "BeforeSS"
	$ActTotal[0][3] = "AfterSS"
	$ActTotal[0][4] = "ErrorSS"
	$ActTotal[0][5] = "StartURL"
	$ActTotal[0][6] = "EndURL"
	$ActTotal[0][7] = "Input"
	$ActTotal[0][8] = "Data"
	$ActTotal[1][0] = $ActName
	$ActTotal[1][1] = $CheckTest
	$ActTotal[1][2] = $CheckSSBefore
	$ActTotal[1][3] = $CheckSSAfter
	$ActTotal[1][4] = $CheckSSError
	$ActTotal[1][5] = $StartURL
	$ActTotal[1][6] = $EndURL
	$ActTotal[1][7] = $InputList
	$ActTotal[1][8] = $DataList
	
	$VRegD = $ActTotal
	
	GUICtrlSetOnEvent($AddInput, "_TM_InputAdd2Action")
	GUICtrlSetOnEvent($DelInput, "_TM_ActionDeleteInput")
	
	GUICtrlSetOnEvent($AddData, "_TM_DataAdd2Action")
	GUICtrlSetOnEvent($DelData, "_TM_ActionDeleteData")
	
	GUICtrlSetOnEvent($CheckTest, "_TM_ActionDef")
	GUICtrlSetOnEvent($ActName, "_TM_ActionDef")
	GUICtrlSetOnEvent($CheckSSBefore, "_TM_ActionDef")
	GUICtrlSetOnEvent($CheckSSAfter, "_TM_ActionDef")
	GUICtrlSetOnEvent($CheckSSError, "_TM_ActionDef")
	GUICtrlSetOnEvent($StartURL, "_TM_ActionDef")
	GUICtrlSetOnEvent($EndURL, "_TM_ActionDef")
	
	GUICtrlSetOnEvent($SubmitAction, "_TM_ActionProcess")
	GUICtrlSetOnEvent($CancelAddAction, "_TM_CLOSEClicked")
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TM_CLOSEClicked")
	Return $addActionGUI
EndFunc   ;==>_TM_ActionAdd

Func _TM_ActionDef()
	$foundI = -1
	For $i = 0 To 8
		;ConsoleWrite($VRegA[0][$i]&" = "&@GUI_CtrlId&"?... ")
		If $VRegD[1][$i] == @GUI_CtrlId Then
			;ConsoleWrite("yep"&@CR)
			$VRegD[2][$i] = GUICtrlRead(@GUI_CtrlId)
			$foundI = $i
		Else
			;ConsoleWrite("nope"&@CR)
		EndIf
	Next
	Return $foundI
EndFunc   ;==>_TM_ActionDef

; --- _TM_ActionProcess() ---
; GUI = Add Action
; Control = Add Action button -> {}
; -----------------------------
Func _TM_ActionProcess()
	$myname = GUICtrlRead($VRegD[1][0])
	$nameExists = _TM_ActionFind($myname)
	if (Not StringIsAlpha(StringLeft($myname, 1))) or (Not StringIsAlNum($myname))Then
		MsgBox(0, "Error", "Name is not a valid Action Name" & @CR & "Alphanumeric only please")
		Return 0
	elseif $nameExists Then
		MsgBox(0, "Error", "'"&$myname&"' already exists" & @CR & "Please rename")
		Return 0
	EndIf
	
	$AFN = "" & $ActionPath & $Actfilename & ".xml"
	$existingFile = FileExists($AFN)

	$ActFile = FileOpen($AFN, 1)
	
	If $ActFile = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	
	if not $existingFile then
		FileWriteLine($ActFile, "<xml>")
	Else
		$lastline = _FileCountLines($AFN)
		_FileWriteToLine($AFN, $lastline, "", 1)
	EndIf

	FileWriteLine($ActFile, "")
	FileWriteLine($ActFile, "<Action>")
	For $i = 0 To 6
		FileWriteLine($ActFile, " <" & $VRegD[0][$i] & ">" & $VRegD[2][$i] & "</" & $VRegD[0][$i] & ">")
	Next
	
	; Fills out the Action Inputs if any
	$InputCount = _GUICtrlListViewGetItemCount ($VRegD[1][7])
	FileWrite($ActFile, " <ActionInput>")
	If $InputCount > 0 Then
		FileWriteLine($ActFile, "")
		For $i = 1 To $InputCount
			FileWriteLine($ActFile, " <Input>" & _GUICtrlListViewGetItemText ($VRegD[1][7], $i - 1) & "</Input>")
			FileWrite($ActFile, " ")
		Next
	EndIf
	FileWriteLine($ActFile, "</ActionInput>")
	
	; Fills out the Action Data if any
	$DataCount = _GUICtrlListViewGetItemCount ($VRegD[1][8])
	FileWrite($ActFile, " <ActionData>")
	If $DataCount > 0 Then
		FileWriteLine($ActFile, "")
		For $i = 1 To $DataCount
			FileWriteLine($ActFile, " <Data>" & _GUICtrlListViewGetItemText ($VRegD[1][7], $i - 1) & "</Data>")
			FileWrite($ActFile, " ")
		Next
	EndIf
	FileWriteLine($ActFile, "</ActionData>")
	FileWriteLine($ActFile, "</Action>")
	FileWriteLine($ActFile, "</xml>")
	FileClose($ActFile)
	
	; Get back to previous GUI to add Item to ViewList
	$prevGUI = _TM_WinArrGlanceBack(1)
	GUISwitch($prevGUI[1])
	
	$thisActTest = "Action"
	If $VRegD[2][1] == 1 Then $thisActTest = "Test"
	$thisAction = GUICtrlCreateListViewItem($VRegD[2][0] & "|" & $thisActTest, $VRegE[0])
	GUISetState(@SW_SHOW, "Guest-Tek TestMaster")
	ConsoleWrite("Adding to " & $VRegE[0] & " in " & @GUI_WinHandle & ": " & GUICtrlRead($VRegE[0]) & @CR)
	ConsoleWrite(GUICtrlRead($VRegE[0]) & @CR)
	
	_TM_CLOSEClicked()
	Return $thisAction
EndFunc   ;==>_TM_ActionProcess

; --- _TM_ActionDeleteInput() ---
; GUI = Add Action
; Control = Remove Input button -> {}
; -----------------------------
Func _TM_ActionDeleteInput()
	$friedInput = GUICtrlRead($VRegB)
	$friedIVal = GUICtrlRead($friedInput)
	If $friedInput <> "" Then
		Return GUICtrlDelete($friedInput)
		;		for $i = 0 to UBound($inMat)
	Else
		Return 0
	EndIf
EndFunc   ;==>_TM_ActionDeleteInput

; --- _TM_ActionDeleteData() ---
; GUI = Add Action
; Control = Remove Data button -> {}
; -----------------------------
Func _TM_ActionDeleteData()
	$friedInput = GUICtrlRead($VRegC)
	If $friedInput <> "" Then
		Return GUICtrlDelete($friedInput)
	Else
		Return 0
	EndIf
EndFunc   ;==>_TM_ActionDeleteData

; --- _TM_ActionFind($AName[, $AFileHandle]) ---
; GUI = None
; Control = None
; -----------------------------
Func _TM_ActionFind($AName, $AFileHandle = "")
	Dim $AFileHandle
	If $AFileHandle <> "" Then
		$readingFile = $AFileHandle
	Else
		$readingFile = FileOpen($ActionPath & $Actfilename & ".xml", 0)
		If $readingFile = -1 Then
			MsgBox(0, "Error", "Unable to open " & $ActionPath & $Actfilename)
			Return 0
		EndIf
	EndIf
	
	$lineCounter = 1
	$endOfFile = 0
	$currentLine = FileReadLine($readingFile, $lineCounter)
	while (Not $endOfFile)
		If @error = -1 Then $endOfFile = 1
		If Not StringInStr($currentLine, "<Name>" & $AName & "</Name>") Then
			$lineCounter = $lineCounter + 1
		Else
			ExitLoop
		EndIf
		If StringInStr($currentLine, "<Test>") Then $lineCounter = $lineCounter + 8
		;		ConsoleWrite("AF -> "&$currentLine&@CR)
		$currentLine = FileReadLine($readingFile, $lineCounter)
	WEnd ; counting
	If $AFileHandle == "" Then FileClose($readingFile)
	If $endOfFile Then ; EOF found 1st
		Return 0
	Else  ; Action record found
		;		ConsoleWrite("AF => "&FileReadLine($readingFile, $lineCounter)&@CR)
		Return $lineCounter - 1
	EndIf ; which was found 1st
EndFunc   ;==>_TM_ActionFind

; --- _TM_ActionGet([, $AName [, $ANumber]]) ---
; GUI = None
; Control = None
; Descr: Gets an action from the action file.
;		Either an action named [$AName] or action number [$ANumber].
;		VRegA holds action info, VRegB holds input and VRegC holds data
; -----------------------------
Func _TM_ActionGet($AName = "", $ANumber = 0) 
	Dim $lineAnchor = 1
	
	If $AName <> "" And $ANumber <> 0 Then
		MsgBox(0, "Error", "Multiple non-congruent search criteria" & @CR & "Name = " & $AName & @CR & "Action# = " & $ANumber)
		Return 0
	EndIf
	
	$readingFile = FileOpen($ActionPath & $Actfilename & ".xml", 0)
	If $readingFile = -1 Then ; no file to read!!!!
		MsgBox(0, "Error", "Unable to open " & $ActionPath & $Actfilename)
		Return 0
	EndIf
	
	; === Count Action Records to get to target as specified by $AName or $ANumber ===
	If $AName <> "" Then
		$lineAnchor = _TM_ActionFind($AName, $readingFile)
		;ConsoleWrite($lineAnchor&"====> "&FileReadLine($readingFile, $lineAnchor)&@CR)
	ElseIf $ANumber <> 0 Then ; must be using record numbers; look through the records
		$i = 0
		While $i < $ANumber
			$currentLine = FileReadLine($readingFile, $lineAnchor)
			If @error = -1 Then ; EOF reached before getting to the Action record
				;MsgBox(0, "Error", "Unexpected end of file" & @CR & "Less than " & $ANumber & " Actions")
				Return 0
			EndIf ; premature EOF
			
			If StringInStr($currentLine, "<Action>") Then ; increment line anchor & skip chunk of record
				$i = $i + 1
				If $i < $ANumber Then $lineAnchor = $lineAnchor + 10
			Else
				$lineAnchor = $lineAnchor + 1
			EndIf
			;ConsoleWrite("By Number... i = "&$i&", Line Anchor = "&$lineAnchor&" --> '"&$currentLine&"'"&@CR)
		WEnd ; counting action records
	Else
		MsgBox(0, "Error", "ActionGet Failed:" & @CR & "No criteria specified")
		Return 0
	EndIf ; count action records to get target
	
	; === Create array and populate with action data ===
	Dim $ActionArray[9]
	For $i = 0 To 6 ; Now to read the lines and put them in some arrays.
		$parameterLine = FileReadLine($readingFile, $lineAnchor + $i + 1)
		$StringSplits = StringSplit($parameterLine, "><")
		;ConsoleWrite("["&$i&"]="&$StringSplits[0]&":"&$StringSplits[3]&"  ")
		$ActionArray[$i] = $StringSplits[3] ; the middle one
	Next
	$lineAnchor = $lineAnchor + 8 ; skip to inputs & data sub-section
	;ConsoleWrite(@CR)
	
	; === Create array and populate with the Action Inputs, if any ===
	Dim $ActInpArray
	$ActInpLine = FileReadLine($readingFile, $lineAnchor)
	While Not StringInStr($ActInpLine, "<ActionInput>")
		ConsoleWrite("NOT INPUT! {" & $ActInpLine & "} ... ")
		$lineAnchor = $lineAnchor + 1
		$ActInpLine = FileReadLine($readingFile, $lineAnchor)
	WEnd
	$AILcount = StringSplit($ActInpLine, "><")
	If $AILcount[0] < 5 Then
		$inpCounter = 0
		While Not StringInStr($ActInpLine, "</ActionInput>")
			$ActInpLine = FileReadLine($readingFile, $lineAnchor + $inpCounter + 1)
			If Not StringInStr($ActInpLine, "</ActionInput>") Then
				;ConsoleWrite("ICount:"&$inpCounter&": "&$ActInpLine&@CR)
				$inpCounter = $inpCounter + 1
			EndIf
		WEnd
		Dim $TempArray[$inpCounter]
		For $i = 0 To $inpCounter - 1
			$parameterLine = FileReadLine($readingFile, $lineAnchor + $i + 1)
			$StringSplits = StringSplit($parameterLine, "><")
			;ConsoleWrite($i&"I:Line "&$lineAnchor+$i&" = "&$StringSplits[3]&@CR)
			$TempArray[$i] = $StringSplits[3]
		Next
		$ActInpArray = $TempArray
		$ActionArray[7] = $inpCounter
		$lineAnchor = $lineAnchor + $inpCounter + 1
	Else
		$ActionArray[7] = ""
	EndIf
	$lineAnchor = $lineAnchor + 1
	
	; === Create array and populate with the Action Data, if any ===
	Dim $ActDatArray
	$ActDatLine = FileReadLine($readingFile, $lineAnchor)
	While Not StringInStr($ActDatLine, "<ActionData>")
		ConsoleWrite("NOT DATA! <" & $ActDatLine & "> ... ")
		$lineAnchor = $lineAnchor + 1
		$ActDatLine = FileReadLine($readingFile, $lineAnchor)
	WEnd
	$ADLcount = StringSplit($ActDatLine, "><")
	If $ADLcount[0] < 5 Then
		$datCounter = 0
		While Not StringInStr($ActDatLine, "</ActionData>")
			$ActDatLine = FileReadLine($readingFile, $lineAnchor + $datCounter + 1)
			If Not StringInStr($ActDatLine, "</ActionData>") Then
				;ConsoleWrite("DCount:"&$datCounter&": "&$ActDatLine&@CR)
				$datCounter = $datCounter + 1
			EndIf
		WEnd
		Dim $TempArray[$datCounter]
		For $i = 0 To $datCounter - 1
			$parameterLine = FileReadLine($readingFile, $lineAnchor + $i + 1)
			$StringSplits = StringSplit($parameterLine, "><")
			;ConsoleWrite($i&"D:Line "&$lineAnchor+$i&" = "&$StringSplits[3]&@CR)
			$TempArray[$i] = $StringSplits[3]
		Next
		$ActDatArray = $TempArray
		$ActionArray[8] = $datCounter
		$lineAnchor = $lineAnchor + 2
	Else
		$ActionArray[8] = ""
	EndIf
	
	$VRegA = $ActionArray
	$VRegB = $ActInpArray
	$VRegC = $ActDatArray
	Return $ActionArray
EndFunc   ;==>_TM_ActionGet

#endregion
#region Action Inputs
; --- _TM_InputAdd2Action() ---
; GUI = Add Action -> New Input
; Control = Add Input button -> {}
; -----------------------------
Func _TM_InputAdd2Action() ; Uses Virtual Register A
	$InputParamsGUI = GUICreate("New Input", 320, 150)
	
	Dim $InputMatrix[2][3]
	
	GUISwitch($InputParamsGUI)
	GUISetState()
	_TM_WinArrPush("New Input", $InputParamsGUI)
	ConsoleWrite(@GUI_WinHandle & "+ ... New Input" & @CR)
	
	GUICtrlCreateLabel("Input Type:", 10, 18)
	$InParamType = GUICtrlCreateCombo("Text Field", 10, 35, 100, 10, $CBS_DROPDOWNLIST) ; create first item
	GUICtrlSetData(-1, "Button|Submit|Drop-down|Checkbox|Radio Button|URL|Proxy|DHCP|DNS")
	GUICtrlCreateLabel("Input/Tag Name:", 120, 18)
	$InParamName = GUICtrlCreateInput("", 120, 35, 190)
	GUICtrlCreateLabel("Input Value:", 10, 63)
	$InParamValue = GUICtrlCreateInput("", 10, 80, 300)
	$SubmitInput4Action = GUICtrlCreateButton("Add", 70, 120, 50, 20)
	$CancelInput4Action = GUICtrlCreateButton("Cancel", 135, 120, 50, 20)
	$HelpInput4Action = GUICtrlCreateButton("Help", 200, 120, 50, 20)
	
	$InputMatrix[0][0] = $InParamType
	$InputMatrix[0][1] = $InParamName
	$InputMatrix[0][2] = $InParamValue
	$InputMatrix[1][0] = GUICtrlRead($InParamType)
	$InputMatrix[1][1] = GUICtrlRead($InParamName)
	$InputMatrix[1][2] = GUICtrlRead($InParamValue)
	
	$VRegA = $InputMatrix
	
	GUICtrlSetOnEvent($InParamType, "_TM_InputDef")
	GUICtrlSetOnEvent($InParamName, "_TM_InputDef")
	GUICtrlSetOnEvent($InParamValue, "_TM_InputDef")
	GUICtrlSetOnEvent($SubmitInput4Action, "_TM_InputProcess")
	
	GUICtrlSetOnEvent($CancelInput4Action, "_TM_CLOSEClicked")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TM_CLOSEClicked")
	
	Return $InputParamsGUI
EndFunc   ;==>_TM_InputAdd2Action

; --- _TM_InputDef() ---
; GUI = New Input
; Control = Input Parameter {Type, Name, Value}
; -----------------------------
Func _TM_InputDef()
	$foundI = -1
	For $i = 0 To 2
		;ConsoleWrite($VRegA[0][$i]&" = "&@GUI_CtrlId&"?... ")
		If $VRegA[0][$i] == @GUI_CtrlId Then
			;ConsoleWrite("yep"&@CR)
			$VRegA[1][$i] = GUICtrlRead(@GUI_CtrlId)
			$foundI = $i
		Else
			;ConsoleWrite("nope"&@CR)
		EndIf
	Next
	Return $foundI
EndFunc   ;==>_TM_InputDef

; --- _TM_InputProcess() ---
; GUI = New Input
; Control = Add Button
; -----------------------------
Func _TM_InputProcess()
	$okayInput = 1
	Select
		Case $VRegA[1][1] == ""
			$okayInput = 0
		Case $VRegA[1][0] == "Button" Or $VRegA[1][0] == "Submit"
			If $VRegA[1][2] == "click" Or $VRegA[1][2] == "" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayInput = 1
			Else
				$okayInput = 0
			EndIf
		Case $VRegA[1][0] == "Checkbox"
			If $VRegA[1][2] == "check" Or $VRegA[1][2] == "checked" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayInput = 1
			ElseIf $VRegA[1][2] == "uncheck" Or $VRegA[1][2] == "unchecked" Or $VRegA[1][2] == "false" Or $VRegA[1][2] == "0" Then
				$okayInput = 1
			Else
				$okayInput = 0
			EndIf
		Case $VRegA[1][0] == "Proxy" Or $VRegA[1][0] == "DHCP" Or $VRegA[1][0] == "DNS"
			If $VRegA[1][2] == "enable" Or $VRegA[1][2] == "enabled" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayInput = 1
			ElseIf $VRegA[1][2] == "disable" Or $VRegA[1][2] == "disabled" Or $VRegA[1][2] == "false" Or $VRegA[1][2] == "0" Then
				$okayInput = 1
			Else
				$okayInput = 0
			EndIf
	EndSelect
	ConsoleWrite($VRegA[1][1] & " (" & $VRegA[1][0] & ") = " & $VRegA[1][2] & "..." & $okayInput & @CR)
	If $okayInput <> 0 Then
		$prevGUI = _TM_WinArrGlanceBack(1)
		GUISwitch($prevGUI[1])
		$thisItem = GUICtrlCreateListViewItem("" & $VRegA[1][1] & "|" & $VRegA[1][0] & "|" & $VRegA[1][2], $VRegB)
		GUISetState(@SW_SHOW, "Add Action")
		;		ConsoleWrite("Adding to "&$VRegB&": "&$VRegA[1][1]&"|"&$VRegA[1][0]&"|"&$VRegA[1][2]&@CR)
		ConsoleWrite("Adding to " & $VRegB & " in " & @GUI_WinHandle & ": " & GUICtrlRead($VRegB) & @CR)
		ConsoleWrite(GUICtrlRead($VRegB) & @CR)
		; .... need to add register value holding the listview's ID, so we know what we're looking at and adding listviewitems to.
		
		_TM_CLOSEClicked()
	Else
		MsgBox(-1, "Error", "You have entered invalid parameters" & @CR & "for this input. Please re-enter.")
	EndIf
	
EndFunc   ;==>_TM_InputProcess
#endregion

#region Action Data
; --- _TM_DataAdd2Action() ---
; GUI = Add Action -> New Data
; Control = Add Data button -> {}
; -----------------------------
Func _TM_DataAdd2Action() ; Uses Virtual Register A
	$DataParamsGUI = GUICreate("New Data", 320, 150)
	
	Dim $DataMatrix[2][3]
	
	GUISwitch($DataParamsGUI)
	GUISetState()
	_TM_WinArrPush("New Data", $DataParamsGUI)
	ConsoleWrite(@GUI_WinHandle & "+ ... New Data" & @CR)
	
	GUICtrlCreateLabel("Data Type:", 10, 18)
	$DatParamType = GUICtrlCreateCombo("Title", 10, 35, 100, 10, $CBS_DROPDOWNLIST) ; create first item
	GUICtrlSetData(-1, "Text|Link|Button|Submit|Checkbox|RadioButton|Proxy|DHCP|DNS")
	GUICtrlCreateLabel("Data/Tag Name:", 120, 18)
	$DatParamName = GUICtrlCreateInput("", 120, 35, 190)
	GUICtrlCreateLabel("Data Contains:", 10, 63)
	$DatParamValue = GUICtrlCreateInput("", 10, 80, 300)
	$SubmitData4Action = GUICtrlCreateButton("Add", 70, 120, 50, 20)
	$CancelData4Action = GUICtrlCreateButton("Cancel", 135, 120, 50, 20)
	$HelpData4Action = GUICtrlCreateButton("Help", 200, 120, 50, 20)
	
	$DataMatrix[0][0] = $DatParamType
	$DataMatrix[0][1] = $DatParamName
	$DataMatrix[0][2] = $DatParamValue
	$DataMatrix[1][0] = GUICtrlRead($DatParamType)
	$DataMatrix[1][1] = GUICtrlRead($DatParamName)
	$DataMatrix[1][2] = GUICtrlRead($DatParamValue)
	
	$VRegA = $DataMatrix
	
	GUICtrlSetOnEvent($DatParamType, "_TM_DataDef")
	GUICtrlSetOnEvent($DatParamName, "_TM_DataDef")
	GUICtrlSetOnEvent($DatParamValue, "_TM_DataDef")
	GUICtrlSetOnEvent($SubmitData4Action, "_TM_DataProcess")
	
	GUICtrlSetOnEvent($CancelData4Action, "_TM_CLOSEClicked")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TM_CLOSEClicked")
	
	Return $DataParamsGUI
EndFunc   ;==>_TM_DataAdd2Action

; --- _TM_InputDef() ---
; GUI = New Data
; Control = Data Parameter {Type, Name, Contains}
; -----------------------------
Func _TM_DataDef()
	$foundD = -1
	For $i = 0 To 2
		;ConsoleWrite($VRegA[0][$i]&" = "&@GUI_CtrlId&"?... ")
		If $VRegA[0][$i] == @GUI_CtrlId Then
			;ConsoleWrite("yep"&@CR)
			$VRegA[1][$i] = GUICtrlRead(@GUI_CtrlId)
			$foundD = $i
		Else
			;ConsoleWrite("nope"&@CR)
		EndIf
	Next
	Return $foundD
EndFunc   ;==>_TM_DataDef

; --- _TM_DataProcess() ---
; GUI = New Data
; Control = Add Button
; -----------------------------
Func _TM_DataProcess()
	$okayData = 1
	Select
		Case $VRegA[1][1] == ""
			$okayData = 0
		Case $VRegA[1][0] == "Button" Or $VRegA[1][0] == "Submit"
			If $VRegA[1][2] == "click" Or $VRegA[1][2] == "" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayData = 1
			Else
				$okayData = 0
			EndIf
		Case $VRegA[1][0] == "Checkbox"
			If $VRegA[1][2] == "check" Or $VRegA[1][2] == "checked" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayData = 1
			ElseIf $VRegA[1][2] == "uncheck" Or $VRegA[1][2] == "unchecked" Or $VRegA[1][2] == "false" Or $VRegA[1][2] == "0" Then
				$okayData = 1
			Else
				$okayData = 0
			EndIf
		Case $VRegA[1][0] == "Proxy" Or $VRegA[1][0] == "DHCP" Or $VRegA[1][0] == "DNS"
			If $VRegA[1][2] == "enable" Or $VRegA[1][2] == "enabled" Or $VRegA[1][2] == "true" Or $VRegA[1][2] == "1" Then
				$okayData = 1
			ElseIf $VRegA[1][2] == "disable" Or $VRegA[1][2] == "disabled" Or $VRegA[1][2] == "false" Or $VRegA[1][2] == "0" Then
				$okayData = 1
			Else
				$okayData = 0
			EndIf
	EndSelect
	ConsoleWrite($VRegA[1][1] & " (" & $VRegA[1][0] & ") = " & $VRegA[1][2] & "..." & $okayData & @CR)
	If $okayData <> 0 Then
		$prevGUI = _TM_WinArrGlanceBack(1)
		GUISwitch($prevGUI[1])
		$thisItem = GUICtrlCreateListViewItem("" & $VRegA[1][1] & "|" & $VRegA[1][0] & "|" & $VRegA[1][2], $VRegC)
		GUISetState(@SW_SHOW, "Add Action")
		;		ConsoleWrite("Adding to "&$VRegB&": "&$VRegA[1][1]&"|"&$VRegA[1][0]&"|"&$VRegA[1][2]&@CR)
		ConsoleWrite("Adding to " & $VRegC & " in " & @GUI_WinHandle & ": " & GUICtrlRead($VRegC) & @CR)
		ConsoleWrite(GUICtrlRead($VRegC) & @CR)
		$VRegD[2][8] = $VRegA
		; .... need to add register value holding the listview's ID, so we know what we're looking at and adding listviewitems to.
		_TM_CLOSEClicked()
	Else
		MsgBox(-1, "Error", "You have entered invalid parameters" & @CR & "for this data. Please re-enter.")
	EndIf
	
EndFunc   ;==>_TM_DataProcess
#endregion
