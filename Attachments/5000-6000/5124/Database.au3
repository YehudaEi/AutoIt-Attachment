#include <Array.au3>
#include <GuiConstants.au3>
#include <GUIListview.au3>
#Include <GuiTreeView.au3>

opt("GUIOnEventMode", 1)
opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced
opt("MouseCoordMode", 0)        ;1=absolute, 0=relative, 2=client

; Initialize SvenP 's error handler
$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

;Set up the database object
Global $oDb
$oDb = ObjCreate( "LiteX.LiteConnection")

Global $CurTree
Global $TreeVDB
Global $DBPath
Global $RecordGUI
Global $FieldNames
Global $New
Global $InputBoxes
Global $CurTable
Global $BeginnerMode
Global $TableNames[15]
;MsgBox(0, "Feedback", "Hello from SQLite version" & $oDb.Version & "!")

;GUI variables
$xBorderL = 7;distance from left side of gui
$xBorderR = 7;distance from right side of gui
$yBorderTier1 = 1;Tier 1 distance from top of gui
$yBorderTier2 = 30 ;Tier 2 distance from top of gui
$yBorderTier3 = 410;Tier 3 distance from top of gui
$xSpacing = 5;distance between controls in the x dimension
$ySpacing = 6;distance between controls in the y dimension

$GUIWidth = 1000
$GUIHeight = 710
$Main = GUICreate("Parts Database - 04 NOV 05", $GUIWidth, $guiheight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIevent") ;This line tells the GUI to close when the "X" is clicked

$Helpmenu = GUICtrlCreateMenu("?")
$Helpitem = GUICtrlCreateMenuItem("Help", $Helpmenu)
$Infoitem = GUICtrlCreateMenuItem("Info", $Helpmenu)

;Tier 1------------------------------------------
$Tab = GUICtrlCreateTab(5, $yBorderTier1, $GUIWidth - 5 - 5, $GUIHeight - $yBorderTier1 - 25, $TCS_SINGLELINE)

;End Tier 1

$Tab_View = GUICtrlCreateTabItem("   Database View   ")
#region ;Database View Tab

;Tier 2------------------------------------------
$TreeWidth = 250
$TreeHeight = 350
$ComboHeight = 20

$Tree = GUICtrlCreateTreeView($xBorderL, $yBorderTier2 + $ComboHeight + $ySpacing, $TreeWidth, $TreeHeight)

$Combo = GUICtrlCreateCombo("ComboBox", $xBorderL, $yBorderTier2, $TreeWidth, $ComboHeight)

$ListViewWidth = $GUIWidth - ($xBorderL + $TreeWidth + $xSpacing + $xBorderR)
$ListViewHeight = $TreeHeight + $ComboHeight + $ySpacing
$ListView = GUICtrlCreateListView("1|2|3|4", $xBorderL + $TreeWidth + $xSpacing, $yBorderTier2, $ListViewWidth, $ListViewHeight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
;End Tier Two

;Tier 3-------------------------------------------

$bNewPwidth = 100
$bNewPHeight = 100
$bNewP = GUICtrlCreateButton("New Part", $GUIWidth - ($bNewPwidth + $xBorderR), $yBorderTier3, $bNewPwidth, $bNewPHeight)
GUICtrlSetOnEvent($bNewP, "AddPart")

;End Tier 3
#endregion
GUICtrlCreateTabItem("")


$Tab_Database = GUICtrlCreateTabItem("   Raw View   ")
GUICtrlSetState(-1, $GUI_SHOW)
#region
$InputDBheight = 20
$InputDBwidth = 250
$InputDBPath = GUICtrlCreateInput("", $xBorderL, $yBorderTier2, $InputDBwidth, $InputDBheight)

$TreeDBwidth = $InputDBwidth
$TreeDBheight = 350
$TreeDB = GUICtrlCreateTreeView($xBorderL, $yBorderTier2 + $InputDBheight + $ySpacing, $TreeDBwidth, $TreeDBheight)

$ListVDBxPos = $InputDBwidth + $xBorderL + $xSpacing
$ListVDB = GUICtrlCreateListView("Field Names...", $ListVDBxPos, $yBorderTier2, $GUIWidth - $ListVDBxPos - $xBorderR, $TreeDBheight + $ySpacing + $InputDBheight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)


;Database controls
$Group0Ystart = $yBorderTier3
$Group0Xstart = $xBorderL + 2
$Group0width = 100
GUICtrlCreateGroup("Database", $Group0Xstart, $Group0Ystart, $Group0width, $GUIHeight - $Group0Ystart - 35)

$bNewDwidth = 80
$bNewDHeight = 40
$bNewDxStart = $group0xstart+ ($Group0width - $bNewDwidth) / 2
$bNewDyStart = $Group0Ystart + 15
$bNewD = GUICtrlCreateButton("Open Database", $bNewDxStart, $bNewDyStart, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent($bNewD, "ButtonOpenDB")

$bRefreshD = GUICtrlCreateButton("Refresh Database", $bNewDxStart, $bNewDyStart + 2 * $ySpacing + $bNewDHeight, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent(-1, "RefreshDatabase")

$bVacuumD = GUICtrlCreateButton("Vacuum Database", $bNewDxStart, $bNewDyStart + 6 * $ySpacing + 2 * $bNewDHeight, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent(-1, "VacuumDatabase")

GUICtrlCreateGroup("", -99, -99, 1, 1)


;Table Controls
$Group1Ystart = $yBorderTier3
$Group1Xstart = $Group0Xstart + $Group0width + $xSpacing + 25
$Group1width = 210
GUICtrlCreateGroup("Create New Table", $Group1Xstart, $Group1Ystart, $Group1width, $GUIHeight - $Group1Ystart - 35)

$NewTableLabelHeight = 20
$Group1ItemYStart = $Group1Ystart + 20
GUICtrlCreateLabel("Table Name:", $Group1Xstart + 5, $Group1ItemYStart, 100, $NewTableLabelHeight)
$NewTableInput = GUICtrlCreateInput("", $Group1Xstart + 5, $Group1ItemYStart + $NewTableLabelHeight - 5, 200, 21)

$NewFieldButton = GUICtrlCreateButton("New FIELD", $Group1Xstart + 5, $Group1ItemYStart + $NewTableLabelHeight - 5 + 21 + 5, 100, 23)
GUICtrlSetOnEvent($NewFieldButton, "CreateNewField")

$NewFieldsLV = GUICtrlCreateListView("Name|Type", $Group1Xstart + 5, $Group1ItemYStart + $NewTableLabelHeight - 5 + 21 + 5 + 21 + 5, 200, 140)

$NewTableButton = GUICtrlCreateButton("Create TABLE", $Group1Xstart + 5, $Group1ItemYStart + $NewTableLabelHeight - 5 + 21 + 5 + 21 + 5 + 140 + 5, 100, 23)
GUICtrlSetOnEvent(-1, "NewTable")
GUICtrlCreateGroup("", -99, -99, 1, 1)


$Group2Ystart = $yBorderTier3
$Group2Xstart = $Group1Xstart + $Group1width + $xSpacing
$Group2width = 150
$Group2Height = $GUIHeight - $Group1Ystart - 35
GUICtrlCreateGroup("Modify Selected Table", $Group2Xstart, $Group2Ystart, $Group2width, $Group2Height)

$bTableRYstart = $Group2Ystart + 20
$bTableRwidth = $Group2width - 25
$bTableRheight = 25
$bTableRxStart = $group2xstart+ ($Group2width - $bTableRwidth) / 2
$bTableR = GUICtrlCreateButton("Rename Table", $bTableRxStart, $bTableRYstart, $bTableRwidth, $bTableRheight)
GUICtrlSetOnEvent(-1, "RenameTable")

$bTableDyStart = $bTableRYstart + $bTableRheight + $ySpacing
$bTableD = GUICtrlCreateButton("Delete Table", $bTableRxStart, $bTableDyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetOnEvent(-1, "DeleteTable")

$bFieldAyStart = $bTableDyStart + $bTableRheight + 5 * $ySpacing
$bFieldA = GUICtrlCreateButton("Insert Field", $bTableRxStart, $bFieldAyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetState(-1, $gui_disable)


$cFieldComboWidth = $Group2width - 25
$cFieldComboXStart = $group2xstart+ ($Group2width - $cFieldComboWidth) / 2
$cFieldComboYStart = $bFieldAyStart + $bTableRheight + $ySpacing
$cFieldCombo = GUICtrlCreateCombo("", $cFieldComboXStart, $cFieldComboYStart, $cFieldComboWidth, $bTableRheight)
GUICtrlSetState(-1, $gui_disable)


$bFieldRyStart = $cFieldComboYStart + $bTableRheight + $ySpacing
$bFieldR = GUICtrlCreateButton("Edit Field Name", $bTableRxStart, $bFieldRyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetState(-1, $gui_disable)

$bFieldTyStart = $bFieldRyStart + $bTableRheight + $ySpacing
$bFieldT = GUICtrlCreateButton("Edit Field Type", $bTableRxStart, $bFieldTyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetState(-1, $gui_disable)

$bFieldNyStart = $bFieldTyStart + $bTableRheight + $ySpacing
$bFieldN = GUICtrlCreateButton("Delete Field", $bTableRxStart, $bFieldNyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetState(-1, $gui_disable)

GUICtrlCreateGroup("", -99, -99, 1, 1)



;Record Controls
$Group3Ystart = $yBorderTier3
$Group3Xstart = $Group2Xstart + $Group2width + $xSpacing + 25
$Group3width = 125
$Group3Height = $GUIHeight - $Group1Ystart - 35
GUICtrlCreateGroup("Modify Records", $Group3Xstart, $Group3Ystart, $Group3width, $Group3Height)

$bNewRWidth = 100
$bNewRHeight = 30
$bNewRxStart = $group3xstart+ ($Group3width - $bNewRWidth) / 2
$bNewRyStart = $Group3Ystart + 20
$bNewR = GUICtrlCreateButton("New Record", $bNewRxStart, $bNewRyStart, $bNewRWidth, $bNewRHeight)
GUICtrlSetOnEvent($bNewR, "AddRecord")

$bEditRHeight = $bNewRHeight + 6
$bEditR = GUICtrlCreateButton("Edit Selected Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $ySpacing, $bNewRWidth, $bEditRHeight, $BS_MULTILINE)
GUICtrlSetOnEvent($bEditR, "EditRecord")

$bDeleteR = GUICtrlCreateButton("Delete Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $bEditRHeight + 2 * $ySpacing, $bNewRWidth, $bNewRHeight)
GUICtrlSetState(-1, $gui_disable)

GUICtrlCreateGroup("", -99, -99, 1, 1)

;Index Controls
$Group4Ystart = $yBorderTier3
$Group4Xstart = $Group3Xstart + $Group3width + $xSpacing + 25
$Group4width = 125
$Group4Height = $GUIHeight - $Group1Ystart - 35
GUICtrlCreateGroup("Modify Indexes", $Group4Xstart, $Group4Ystart, $Group4width, $Group4Height)

$cIndexComboWidth = $Group4width - 15
$cIndexComboXStart = $group4xstart+ ($Group4width - $cIndexComboWidth) / 2
$cIndexComboYStart = $Group4Ystart + 20
$cIndexCombo = GUICtrlCreateCombo("", $cIndexComboXStart, $cIndexComboYStart, $cIndexComboWidth, $bTableRheight)
;GUICtrlSetState(-1, $gui_disable)

$RadioGroup1xStart = $cIndexComboXStart
$RadioGroup1yStart = $cIndexComboYStart + 3 * $ySpacing
GUICtrlCreateGroup("", $RadioGroup1xStart, $RadioGroup1yStart, $Group4width - 15, 55)
$DescendRadio = GUICtrlCreateRadio("Descend (A-Z)", $RadioGroup1xStart + 5, $RadioGroup1yStart + 10, $Group4width - 30, 20)
GUICtrlSetState(-1, $GUI_CHecked)
GUICtrlSetState(-1, $gui_disable)

$AscendRadio = GUICtrlCreateRadio("Ascending (Z-A)", $RadioGroup1xStart + 5, $RadioGroup1yStart + 20 + $ySpacing, $Group4width - 30, 25)
GUICtrlSetState(-1, $gui_disable)

GUICtrlCreateGroup("", -99, -99, 1, 1)


$RadioGroup2xStart = $cIndexComboXStart
$RadioGroup2yStart = $RadioGroup1yStart + 52
GUICtrlCreateGroup("", $RadioGroup2xStart, $RadioGroup2yStart, $Group4width - 15, 55)
$UniqueRadio = GUICtrlCreateRadio("Unique", $RadioGroup2xStart + 5, $RadioGroup2yStart + 10, $Group4width - 30, 20)
GUICtrlSetState(-1, $GUI_CHecked)
GUICtrlSetState(-1, $gui_disable)

$NUniqueRadio = GUICtrlCreateRadio("Not Unique", $RadioGroup2xStart + 5, $RadioGroup2yStart + 20 + $ySpacing, $Group4width - 30, 25)
GUICtrlSetState(-1, $gui_disable)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$bCreateIndexYstart = $RadioGroup2yStart + 55 + $ySpacing
$bCreateIndex = GUICtrlCreateButton("Create Index", $cIndexComboXStart + 5, $bCreateIndexYstart, $Group4width - 25, 23)
GUICtrlSetState(-1, $gui_disable)

$bDeleteIndex = GUICtrlCreateButton("Delete Index", $cIndexComboXStart + 5, $bCreateIndexYstart + 23 + 3 * $ySpacing, $Group4width - 25, 23)
GUICtrlSetState(-1, $gui_disable)


GUICtrlCreateGroup("", -99, -99, 1, 1)


;Misc Controls
$Group5Ystart = $yBorderTier3
$Group5Xstart = $Group4Xstart + $Group4width + $xSpacing + 25
$Group5width = 135
$Group5Height = $GUIHeight - $Group1Ystart - 35
GUICtrlCreateGroup("Misc", $Group5Xstart, $Group5Ystart, $Group5width, $Group5Height)
$bExcelInWidth = 100
$bExcelInHeight = 30
$bExcelInxStart = $group5xstart+ ($Group5width - $bExcelInWidth) / 2
$bExcelInyStart = $Group5Ystart + 20
$bExcelIn = GUICtrlCreateButton("Excel Import", $bExcelInxStart, $bExcelInyStart, $bExcelInWidth, $bExcelInHeight)
GUICtrlSetState(-1, $gui_disable)

$bExcelOutHeight = $bExcelInHeight
$bExcelOut = GUICtrlCreateButton("Excel Export", $bExcelInxStart, $bExcelInyStart + $bExcelInHeight + $ySpacing, $bExcelInWidth, $bExcelOutHeight, $BS_MULTILINE)
GUICtrlSetState(-1, $gui_disable)

$cBeginner = GUICtrlCreateCheckbox("Beginner Mode", $bExcelInxStart, $bExcelInyStart + 2 * $bExcelInHeight + 2 * $ySpacing, $bExcelInWidth, 25)
GUICtrlSetOnEvent(-1, "Beginner")

GUICtrlCreateGroup("", -99, -99, 1, 1)
;$SQLEdit = GUICtrlCreateInput("Type in SQL statements...",$xborderl+5,$yBorderTier3 + $ySpacing + 10,700,20)
#endregion
GUICtrlCreateTabItem("")

$SQL_View = GUICtrlCreateTabItem("   SQL Entry   ")
#region ;Database View Tab

$SQLinsertY = $yBorderTier2 + 20
$SQLlabelHeight = 20
$SQLinsertLabel = GUICtrlCreateLabel("Enter SQL Commands:", $xBorderL + 10, $SQLinsertY, 500, $SQLlabelHeight)
$SQLInsert = GUICtrlCreateInput("", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight, 500, 100)

$SQLcommit = GUICtrlCreateButton("Process SQL", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 110, 90, 24)
GUICtrlSetOnEvent(-1, "CommitSQL")

$SQLresult = GUICtrlCreateListView("Results", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 140, $GUIWidth - 40, $guiheight- ($SQLinsertY + $SQLlabelHeight + 180))

#endregion
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW, $Main)
While 1
	Sleep(8000)
WEnd
Exit

Func ButtonOpenDB()
	OpenDatabase("")
EndFunc   ;==>ButtonOpenDB

Func OpenDatabase($DBPath1)
	
	Dim $oStmt
	Dim $GetIndices
	Dim $GetFieldNames
	Dim $GetTableNames
	Dim $TableNames[15]
	
	$odb.close ();
	If $DBPath1 = "" Then
		$DBPath = FileOpenDialog("New or Existing Database...", "C:\Kevin\AutoItScripts\PartsDatabase", "DB (*.db)")
		If StringRight($DBPath, 3) <> ".db" Then
			$DBPath = $DBPath & ".db"
		EndIf
	ElseIf $DBPath1 <> "" Then
		$DBPath = $DBPath1
	EndIf
	
	;Put database path into the path inputbox
	GUICtrlSetData($InputDBPath, $DBPath)
	
	;Reset Tree
	_GUICtrlTreeViewDeleteAllItems ($TreeDB)
	
	;Open the database file (creates it if it does not exist)
	$oDb.Open ($DBPath)
	
	;Find all Tables and columns and put them on the Tree Control for easy reference
	$GetTableNames = $odb.prepare ("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
	
	If $BeginnerMode = True Then
		MsgBox(0, "Get Table Names", "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
	EndIf
	
	$Data = ""
	$NameCount = 0
	
	While $GetTableNames.step () = 0
		;Put the table name in $Data
		$Data = $GetTableNames.ColumnValue (0)
		
		;Put the table name in the table name array
		If $NameCount > 14 Then
			_ArrayInsert($TableNames, UBound($TableNames))
		EndIf
		$TableNames[$NameCount] = $Data
		$NameCount = $NameCount + 1
		
		$CurTree = GUICtrlCreateTreeViewItem($Data, $TreeDB)
		GUICtrlSetOnEvent($CurTree, "TreeDBTableClick")
		
		;Getting the field names from the current table
		$GetFieldNames = $oDb.Prepare ("SELECT * FROM " & $Data)
		
		$ColumnCount = $GetFieldNames.columncount
		
		;Getting the field type requires parsing the original CREATE statement of the table located in the sql field
		$GetFieldType = $odb.prepare ("SELECT sql FROM sqlite_master WHERE tbl_name='" & $Data & "'")
		
		;FirstIndex tells the program that this is the first index for a given table.  This way
		;only one index tree item is created for each table
		$FirstIndex = True
		
		;This grabs the CREATE statement for the current table or index and puts it in the treeview
		While $getfieldtype.step () = 0
			For $NewColCount = 0 To $GetFieldType.columncount - 1
				
				;Grab the CREATE statement
				$Type = $getfieldtype.columnvalue ($NewColCount)
				
				;There are two types of CREATES, TABLE and INDEX
				If Not StringInStr($Type, "INDEX", 1) Then
					
					;Ok now that you have the data available (Field Name and Type), time to go back and put it together
					For $Count = 0 To $ColumnCount - 1
						;Column Name
						$Data1 = $GetFieldNames.columnname ($Count)
						
						;Column Type
						$TempArray = StringSplit($Type, "(", 1)
						$TempArray = StringSplit($TempArray[2], ",", 1)
						$ColType = StringStripWS(StringReplace($TempArray[$Count + 1] & " ", $Data1, ""), 3)
						If StringRight($ColType, 1) = ")" Then $ColType = StringLeft($ColType, StringLen($ColType) - 1)
						
						;Put Column name and Column Type in the Tree
						GUICtrlCreateTreeViewItem($Data1 & "  " & $ColType, $CurTree)
						ControlFocus("Parts Database", "", $InputDBPath)
						$Data1 = ""
						$data2 = ""
					Next
				Else
					;If it's the first index for the table you need to create an INDEX item
					If $FirstIndex = True Then
						$IndexItem = GUICtrlCreateTreeViewItem("Indexes for " & $Data, $CurTree)
						$FirstIndex = False
					EndIf
					
					;I may parse the index down a bit... for now I'm not!
					If StringInStr($Type, "UNIQUE", 1) Then
						GUICtrlCreateTreeViewItem($Type, $IndexItem)
						ControlFocus("Parts Database", "", $InputDBPath)
					Else
						GUICtrlCreateTreeViewItem($Type, $IndexItem)
						ControlFocus("Parts Database", "", $InputDBPath)
					EndIf
				EndIf
			Next
		WEnd
	WEnd
	$CurTable = $TableNames[0]
	ControlFocus("Parts Database", "", $InputDBPath)
	
EndFunc   ;==>OpenDatabase

Func TreeDBTableClick()
	Dim $GetFieldNames
	Dim $Data1 = ""
	
	$ItemID = GUICtrlRead($TreeDB)
	
	;ItemText[0] will contain the name of the table selected in the tree
	$ItemText = GUICtrlRead($ItemID, 1)
	;msgbox(0,"",$curtable & "|" & $ItemText[0])
	;Store the Current Table for future reference
	If $ItemText[0] <> "0" Then
		$CurTable = $ItemText[0]
	EndIf
	;MsgBox(0,"",$CurTable & "|" & $ItemText[0])
	
	;msgbox(0,"","SELECT * FROM " & $CurTable)
	;Get field names and put them at the top of the ListView control
	$GetFieldNames = $oDb.Prepare ("SELECT * FROM " & $CurTable)
	
	$ColumnCount = $GetFieldNames.columncount
	
	;Now you need to put the Field Name and Type in an array to save for
	; other functions' reference
	
	;Get the FieldNames array set for entering in field data
	If $ColumnCount = 1 Then
		Dim $FieldNames[$ColumnCount][$ColumnCount + 1]
	Else
		Dim $FieldNames[$ColumnCount][$ColumnCount]
	EndIf
	
	
	$GetFieldType = $odb.prepare ("SELECT sql FROM sqlite_master WHERE tbl_name='" & $CurTable & "'")
	If $BeginnerMode = True Then
		MsgBox(0, "Get the CREATE statements from table", "SELECT sql FROM sqlite_master WHERE tbl_name='" & $CurTable & "'")
	EndIf
	
	;This grabs the CREATE statement for the current table
	While $getfieldtype.step () = 0
		For $NewColCount = 0 To $GetFieldType.columncount - 1
			$TempString = $getfieldtype.columnvalue ($NewColCount)
			
			If StringInStr($TempString, "CREATE TABLE", 1) Then
				$Type = $getfieldtype.columnvalue ($NewColCount)
			EndIf
		Next
	WEnd
	
	If $BeginnerMode = True Then
		MsgBox(0, "A Sample CREATE statement", $Type)
	EndIf
	
	;Generate the new header columns for the ListView
	For $Count = 0 To $ColumnCount - 1
		
		;Column Name
		If Not StringInStr($Type, "INDEX", 1) Then
			$Data1 = $Data1 & "|" & $GetFieldNames.columnname ($Count)
			
			$FieldNames[$Count][0] = $getfieldnames.columnname ($Count)
			
			;Column Type
			$TempArray = StringSplit($Type, "(", 1)
			$TempArray = StringSplit($TempArray[2], ",", 1)
			$ColType = StringStripWS(StringReplace($TempArray[$Count + 1], $FieldNames[$Count][0], ""), 3)
			If StringRight($ColType, 1) = ")" Then $ColType = StringLeft($ColType, StringLen($ColType) - 1)
			
			$FieldNames[$Count][1] = $ColType
		EndIf
	Next
	
	;Reset the ListView control and put in all data from the selected table
	GUICtrlDelete($ListVDB)
	
	If StringLeft($Data1, 1) = "|" Then $Data1 = StringTrimLeft($Data1, 1)
	
	GUISwitch($Main, $Tab_Database)
	$ListVDB = GUICtrlCreateListView($Data1, $ListVDBxPos, $yBorderTier2, $GUIWidth - $ListVDBxPos - $xBorderR, $TreeDBheight + $ySpacing + $InputDBheight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
	GUICtrlSetState($Tab_Database, $GUI_SHOW)
	
	;Grab all data from database table and display in ListView
	$TableData = $oDb.Prepare ("SELECT * FROM " & $CurTable & " ORDER BY " & $FieldNames[0][0])
	
	If $BeginnerMode = True Then
		MsgBox(0, "Grab all data from table", "SELECT * FROM " & $CurTable & " ORDER BY " & $FieldNames[0][0])
	EndIf
	
	GUISetState(@SW_LOCK)
	While $tabledata.step () = 0
		$Data = ""
		For $Count = 0 To $ColumnCount - 1
			$Data = $Data & "|" & $tabledata.ColumnValue ($Count)
		Next
		If StringLeft($Data, 1) = "|" Then $Data = StringTrimLeft($Data, 1)
		
		GUICtrlCreateListViewItem($Data, $ListVDB)
		
	WEnd
	GUISetState(@SW_UNLOCK)
	
	$TableData.Close ();
EndFunc   ;==>TreeDBTableClick

Func NewTable()
	$FieldParamStr = ""
	$Refresh = False
	If Not FileExists($DBPath) Then
		MsgBox(0, "DB does not exist", "There is no database to add that table to.")
	ElseIf GUICtrlRead($NewTableInput) = "" Then
		MsgBox(0, "No Table Name", "Please insert a tablename.")
	Else
		$Proceed = False
		$TableName = GUICtrlRead($NewTableInput)
		$CheckEnd = UBound($TableNames) - 1
		
		;Loop through table names, only proceed if name is not in list
		While $Proceed = False
			For $Check = 0 To $CheckEnd
				If $TableNames[$Check] = $TableName Then
					$TableName = InputBox("Duplicate Table", "You need to choose a different table name... the one you used is already used.", $TableName)
					$Proceed = False
					ExitLoop
				ElseIf $Check = $CheckEnd Then
					$Proceed = True
				EndIf
			Next
		WEnd
		
		If $Proceed = True Then
			
			;Get the field name and type data from the listview... put it together for SQL
			For $LVcount = 0 To _GUICtrlListViewGetItemCount ($NewFieldsLV) - 1
				$LVdata = _GUICtrlListViewGetItemText ($NewFieldsLV, $LVcount)
				
				$TempArray = StringSplit($LVdata, "|")
				$FieldParamStr = $FieldParamStr & "," & " " & $TempArray[1] & " " & $TempArray[2]
			Next
			
			$FieldParamStr = StringTrimLeft($FieldParamStr, 2)
			
			;Force the user to create a Primary Key field
			If StringInStr($FieldParamStr, "PRIMARY KEY") Then
				;MsgBox(0,"","CREATE TABLE " & $TableName & " (" & $FieldParamStr & ")")
				$oDb.Execute ("CREATE TABLE " & $TableName & " (" & $FieldParamStr & ")")
				
				If $BeginnerMode = True Then
					MsgBox(0, "Create the table", "CREATE TABLE " & $TableName & " (" & $FieldParamStr & ")")
				EndIf
				
				$Refresh = True
			Else
				MsgBox(0, "Need PRIMARY KEY datatype", "Please insert a field with the PRIMARY KEY datatype.")
			EndIf
		EndIf
	EndIf
	
	If $Refresh = True Then OpenDatabase($DBPath)
EndFunc   ;==>NewTable

Func CreateNewField()
	$UserInput = InputBox("New Field...", "Insert the new field name and it's parameters. For example: FName::Param1,Param2,Param3" & @CR & @CR & _
			"Parameters:" & @CR & _
			"0 = TEXT" & @CR & _
			"1 = NUMERIC" & @CR & _
			"2 = BLOB" & @CR & _
			"3 = INTEGER PRIMARY KEY", "", "", -1, 220)
	
	$TempArray = StringSplit($UserInput, "::", 1)
	
	If $TempArray[0] = 2 Then
		
		$NewFName = $TempArray[1] & "|"
		$Parameters = StringSplit($TempArray[2], ",")
		
		For $PCount = 1 To $Parameters[0]
			If $Parameters[$PCount] = "0" Then
				$Parameters[$PCount] = "TEXT"
			ElseIf $Parameters[$PCount] = "1" Then
				$Parameters[$PCount] = "NUMERIC"
			ElseIf $Parameters[$PCount] = "2" Then
				$Parameters[$PCount] = "BLOB"
			ElseIf $Parameters[$PCount] = "3" Then
				$Parameters[$PCount] = "INTEGER PRIMARY KEY"
			Else
				If IsNumber($Parameters[$PCount]) Then
					$Parameters[$PCount] = ""
				Else
					$Parameters[$PCount] = StringUpper($Parameters[$PCount])
				EndIf
			EndIf
			
			If $Parameters[$PCount] <> "" Then
				$NewFName = $NewFName & " " & $Parameters[$PCount]
			EndIf
		Next
		
		$NewFieldItem = GUICtrlCreateListViewItem($NewFName, $NewFieldsLV)
		
		;Set the GUI to automatically delete the new field if it is clicked
		GUICtrlSetOnEvent($NewFieldItem, "DeleteField")
	Else
		MsgBox(0, "Incorrect entry", "Please reenter the data.  Don't forget the :: delimiter.")
	EndIf
EndFunc   ;==>CreateNewField

Func DeleteField()
	_GUICtrlListViewDeleteItemsSelected ($NewFieldsLV)
EndFunc   ;==>DeleteField

Func EditRecord()
	
	$CurRecordNum = _GUICtrlListViewGetSelectedIndices ($ListVDB)
	
	$CurRecord = _GUICtrlListViewGetItemTextArray ($ListVDB)
	
	$PriKeyNum = -1
	;Find which field is the PRIMARY KEY
	For $Count = 0 To UBound($FieldNames, 1) - 1
		;	msgbox(0,"",$fieldnames[$count][1])
		If StringInStr($FieldNames[$Count][1], "PRIMARY", 1) Then
			$PriKeyNum = $Count
			ExitLoop
		EndIf
	Next
	
	If $PriKeyNum = -1 Then
		MsgBox(0, "No PRIMARY KEY", "There is no primary key.  You can't be sure you edit the record you have highlighted!")
	Else
		DisplayRecGUI($CurRecord)
	EndIf
	
EndFunc   ;==>EditRecord

Func RecordEdit()
	$ColumnNames = ""
	$ColumnData = ""
	For $Count = 0 To UBound($FieldNames, 1) - 1
		If StringInStr($FieldNames[$Count][1], "PRIMARY") = 0 Then
			$ColumnData = $ColumnData & " , " & $FieldNames[$Count][0] & "='" & GUICtrlRead($InputBoxes[$Count]) & "'"
		Else
			$PriKey = $FieldNames[$Count][0]
			$PriNum = GUICtrlRead($InputBoxes[$Count])
		EndIf
	Next
	
	$ColumnData = StringTrimLeft($ColumnData, 3)
	;MsgBox(0,"","UPDATE " & $curtable & " SET " & $ColumnData & " WHERE " & $PriKey & "= " & $PriNum)
	$odb.execute ("BEGIN TRANSACTION")
	$odb.execute ("UPDATE " & $CurTable & " SET " & $ColumnData & " WHERE " & $PriKey & "= " & $PriNum)
	$odb.execute ("COMMIT TRANSACTION")
	
	If $BeginnerMode = True Then
		MsgBox(0, "Update the record", "UPDATE " & $CurTable & " SET " & $ColumnData & " WHERE " & $PriKey & "= " & $PriNum)
	EndIf
	
	GUIDelete($RecordGUI)
	ControlFocus("Parts Database", "", $TreeDB)
	TreeDBTableClick()
	
EndFunc   ;==>RecordEdit

Func AddRecord()
	If Not FileExists($DBPath) Then
		MsgBox(0, "", "You need to open a valid database.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Select a Table", "Please select a table first.")
	Else
		$rgXborder = 5
		$rgYborder = 20
		$LabelMaxWidth = 0
		
		$FieldCount = 0
		
		Dim $InputBoxes[UBound($FieldNames, 1) ]
		
		;Find the max number of characters in a label, this will help determine the width of
		; the GUI
		For $FieldCount = 0 To UBound($FieldNames, 1) - 1
			If $LabelMaxWidth < StringLen($FieldNames[$FieldCount][0]) Then
				$LabelMaxWidth = StringLen($FieldNames[$FieldCount][0])
			EndIf
		Next
		
		;7 pixels per character seems about right for width
		$LabelMaxWidth = $LabelMaxWidth * 7
		
		;Set up and make the GUI
		$RecordGUIheight = UBound($FieldNames, 1) * 25 + 50
		$RecordGUIwidth = (Ceiling(UBound($FieldNames, 1) / 15)) * ($LabelMaxWidth + 150 + 20)
		$RecordGUI = GUICreate("Edit/New Record", $RecordGUIwidth, $RecordGUIheight)
		GUISetOnEvent($GUI_EVENT_CLOSE, "ChildGUIDelete")
		
		$rgInsert = GUICtrlCreateButton("Insert", $RecordGUIwidth / 2 + 5, $RecordGUIheight - 25, 80, 20)
		GUICtrlSetOnEvent(-1, "InsertRecord")
		
		$rgClose = GUICtrlCreateButton("Close", $RecordGUIwidth / 2 - 85, $RecordGUIheight - 25, 80, 20)
		GUICtrlSetOnEvent(-1, "ChildGUIDelete")
		
		For $FieldCount = 0 To UBound($FieldNames, 1) - 1
			GUICtrlCreateLabel($FieldNames[$FieldCount][0], $rgXborder, $rgYborder, $LabelMaxWidth, 20)
			
			$Text = ""
			
			$InputBoxes[$FieldCount] = GUICtrlCreateInput($Text, $rgXborder + $LabelMaxWidth + 5, $rgYborder, 150, 20)
			
			If StringInStr($FieldNames[$FieldCount][1], "PRIMARY") Then
				GUICtrlSetState($InputBoxes[$FieldCount], $gui_disable)
			EndIf
			$rgYborder = $rgYborder + 25
			
		Next
		
		GUISetState(@SW_SHOW, $RecordGUI)
	EndIf
	
EndFunc   ;==>AddRecord

Func InsertRecord()
	$NewRecord = ""
	Dim $ColumnNames = ""
	Dim $ColumnData = ""
	
	$oDb.Execute ("BEGIN TRANSACTION")
	; Insert values in the
	
	;Build the list of columns and the list of values for the SQL statment
	For $FieldCount = 0 To UBound($InputBoxes) - 1
		$ColumnNames = $ColumnNames & "," & $FieldNames[$FieldCount][0]
		If StringInStr($FieldNames[$FieldCount][1], "PRIMARY") Then
			$ColumnData = $ColumnData & "," & "null"
		Else
			$ColumnData = $ColumnData & ",'" & GUICtrlRead($InputBoxes[$FieldCount]) & "'"
		EndIf
	Next
	
	;Clean up the column names and values
	$ColumnNames = StringTrimLeft($ColumnNames, 1)
	While StringLeft($ColumnData, 1) = ","
		$ColumnData = StringTrimLeft($ColumnData, 1)
	WEnd
	
	;Insert the data into the database
	$odb.execute ("INSERT INTO " & $CurTable & "(" & $ColumnNames & ") VALUES( " & $ColumnData & ")")
	$oDb.Execute ("COMMIT TRANSACTION")
	
	If $BeginnerMode = True Then
		MsgBox(0, "Insert Record", "INSERT INTO " & $CurTable & "(" & $ColumnNames & ") VALUES( " & $ColumnData & ")")
	EndIf
	
	;Pull the data you just entered back out (this allows PRIMARY KEY fields to autoincrement)
	;and put the data in the listview
	GUIDelete($RecordGUI)
	ControlFocus("Parts Database", "", $TreeDB)
	TreeDBTableClick()
	
	
	
EndFunc   ;==>InsertRecord

Func AddPart()
	MsgBox(0, "", "In the function!")
	
EndFunc   ;==>AddPart

Func RefreshDatabase()
	If GUICtrlRead($InputDBPath) <> "" Then
		OpenDatabase($DBPath)
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	EndIf
EndFunc   ;==>RefreshDatabase

Func RenameTable()
	If GUICtrlRead($InputDBPath) <> "" Then
		$NewName = InputBox("Give a new name", "Please enter the new name you would like to give the table.", $CurTable)
		$CheckEnd = UBound($TableNames) - 1
		If $NewName <> "" And @error = 0 Then
			$Proceed = False
			;Loop through table names, only proceed if name is not in list
			While $Proceed = False
				For $Check = 0 To $CheckEnd
					If $TableNames[$Check] = $NewName Then
						$NewName = InputBox("Duplicate Table", "You need to choose a different table name... the one you used is already used.", $NewName)
						$Proceed = False
						ExitLoop
					ElseIf $Check = $CheckEnd Then
						$Proceed = True
					EndIf
				Next
			WEnd
			
			If $Proceed = True Then
				$odb.execute ("BEGIN TRANSACTION")
				$odb.execute ("ALTER TABLE " & $CurTable & " RENAME TO " & $NewName)
				$odb.execute ("COMMIT TRANSACTION")
				If $BeginnerMode = True Then
					MsgBox(0, "Rename the table", "ALTER TABLE " & $CurTable & " RENAME TO " & $NewName)
				EndIf
				OpenDatabase($DBPath)
			EndIf
		EndIf
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	EndIf
EndFunc   ;==>RenameTable

Func DeleteTable()
	$Confirm = MsgBox(1, "Delete Table?", "If you delete this table !< " & $CurTable & " >! all information will be lost.  Continue?")
	
	If $Confirm = 1 Then
		$odb.execute ("BEGIN TRANSACTION")
		$odb.execute ("DROP TABLE " & $CurTable)
		$odb.execute ("COMMIT TRANSACTION")
		
		If $BeginnerMode = True Then
			MsgBox(0, "Delete Table", "DROP TABLE " & $CurTable)
		EndIf
		
		OpenDatabase($DBPath)
		
		
	EndIf
	
EndFunc   ;==>DeleteTable

Func VacuumDatabase()
	If GUICtrlRead($InputDBPath) <> "" Then
		$odb.execute ("VACUUM")
		OpenDatabase($DBPath)
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	EndIf
	
EndFunc   ;==>VacuumDatabase

Func CommitSQL()
	Dim $DataOut
	If GUICtrlRead($InputDBPath) <> "" Then
		If StringInStr(GUICtrlRead($SQLInsert), "SELECT") Then
			$ColString = ""
			
			$DataOut = $odb.prepare (StringStripWS(GUICtrlRead($SQLInsert), 3))
			
			$ColumnCount = $DataOut.columncount - 1
			If $ColumnCount <> "" And IsObj($DataOut) Then
				GUICtrlDelete($SQLresult)
				
				For $ColCount = 0 To $ColumnCount
					$ColString = $ColString & "|" & $ColCount
				Next
				
				$ColString = StringTrimLeft($ColString, 1)
				
				GUISwitch($Main, $SQL_View)
				
				$SQLresult = GUICtrlCreateListView($ColString, $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 140, $GUIWidth - 40, $guiheight- ($SQLinsertY + $SQLlabelHeight + 180))
				
				GUICtrlSetState($SQL_View, $GUI_SHOW)
				
				GUISetState(@SW_LOCK)
				While $DataOut.step () = 0
					$Data = ""
					For $Count = 0 To $ColumnCount
						$Data = $Data & "|" & $dataout.ColumnValue ($Count)
					Next
					
					$Data = StringTrimLeft($Data, 1)
					
					GUICtrlCreateListViewItem($Data, $SQLresult)
					
				WEnd
				_GUICtrlListViewSetColumnWidth ($SQLresult, 0, $LVSCW_AUTOSIZE)
				GUISetState(@SW_UNLOCK)
				
			EndIf
		Else
			$odb.execute ("BEGIN TRANSACTION")
			$odb.execute (GUICtrlRead($SQLInsert))
			$odb.execute ("COMMIT TRANSACTION")
			
			GUICtrlCreateListViewItem("Look in the Raw View to see if the change occured.", $SQLresult)
			_GUICtrlListViewSetColumnWidth ($SQLresult, 0, $LVSCW_AUTOSIZE)
		EndIf
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database...")
	EndIf
	
EndFunc   ;==>CommitSQL

Func ChildGUIDelete()
	GUIDelete($RecordGUI)
EndFunc   ;==>ChildGUIDelete

Func GUIevent()
	Exit
EndFunc   ;==>GUIevent

Func DisplayRecGUI($rgRecord)
	$rgXborder = 5
	$rgYborder = 20
	$LabelMaxWidth = 0
	
	$FieldCount = 0
	
	Dim $InputBoxes[UBound($FieldNames, 1) ]
	
	;Find the max number of characters in a label, this will help determine the width of
	; the GUI
	For $FieldCount = 0 To UBound($FieldNames, 1) - 1
		If $LabelMaxWidth < StringLen($FieldNames[$FieldCount][0]) Then
			$LabelMaxWidth = StringLen($FieldNames[$FieldCount][0])
		EndIf
	Next
	
	;7 pixels per character seems about right for width
	$LabelMaxWidth = $LabelMaxWidth * 7
	
	;Set up and make the GUI
	$RecordGUIheight = UBound($FieldNames, 1) * 25 + 50
	$RecordGUIwidth = (Ceiling(UBound($FieldNames, 1) / 15)) * ($LabelMaxWidth + 150 + 20)
	$RecordGUI = GUICreate("Edit/New Record", $RecordGUIwidth, $RecordGUIheight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ChildGUIDelete")
	
	$rgInsert = GUICtrlCreateButton("Insert", $RecordGUIwidth / 2 + 5, $RecordGUIheight - 25, 80, 20)
	If IsArray($rgRecord) Then
		GUICtrlSetOnEvent($rgInsert, "RecordEdit")
	Else
		GUICtrlSetOnEvent($rgInsert, "InsertRecord")
	EndIf
	
	$rgClose = GUICtrlCreateButton("Close", $RecordGUIwidth / 2 - 85, $RecordGUIheight - 25, 80, 20)
	GUICtrlSetOnEvent(-1, "ChildGUIDelete")
	
	For $FieldCount = 0 To UBound($FieldNames, 1) - 1
		GUICtrlCreateLabel($FieldNames[$FieldCount][0], $rgXborder, $rgYborder, $LabelMaxWidth, 20)
		
		If IsArray($rgRecord) Then
			If $rgRecord[$FieldCount + 1] <> "" Then
				$Text = $rgRecord[$FieldCount + 1]
			Else
				$Text = ""
			EndIf
		Else
			$Text = ""
		EndIf
		
		$InputBoxes[$FieldCount] = GUICtrlCreateInput($Text, $rgXborder + $LabelMaxWidth + 5, $rgYborder, 150, 20)
		
		If StringInStr($FieldNames[$FieldCount][1], "PRIMARY") Then
			GUICtrlSetState($InputBoxes[$FieldCount], $gui_disable)
		EndIf
		$rgYborder = $rgYborder + 25
		
	Next
	
	GUISetState(@SW_SHOW, $RecordGUI)
	
EndFunc   ;==>DisplayRecGUI

Func Beginner()
	$Checked = GUICtrlRead($cBeginner)
	
	If $Checked = $GUI_CHecked Then
		$BeginnerMode = True
	ElseIf $Checked = $gui_unchecked Then
		$BeginnerMode = False
	EndIf
EndFunc   ;==>Beginner

; This is SvenP's custom error handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	MsgBox(0, "AutoItCOM Test", "We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & $HexNumber & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
			)
	SetError(1) ; to check for after this function returns
EndFunc   ;==>MyErrFunc