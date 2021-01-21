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

Global $oExcel
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
Global $CurListIndex
Global $FieldGUI
Global $FieldGUIwidth
Global $FieldInputBox
Global $UpdatedLabel
Global $rgAllowDefaults
global $UseExcelLV
Global $LastNumOfHeadings = 1
global $LastNumOfRows = 1
;MsgBox(0, "Feedback", "Hello from SQLite version" & $oDb.Version & "!")
#region GUI CREATION
;GUI variables
$xBorderL = 9;distance from left side of gui
$xBorderR = 9;distance from right side of gui
$yBorderTier1 = 1;Tier 1 distance from top of gui
$yBorderTier2 = 415 ;Tier 2 distance from top of gui
$yBorderTier3 = 440 ;Tier 3 distance from top of gui
$xSpacing = 5;distance between controls in the x dimension
$ySpacing = 5;distance between controls in the y dimension

$GUIWidth = 1000
$GUIHeight = 775
$GUIText = "SQLite GUI"
$Main = GUICreate($GUIText, $GUIWidth, $guiheight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2,$WS_CLIPCHILDREN+$WS_OVERLAPPEDWINDOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIevent") ;This line tells the GUI to close when the "X" is clicked

$Helpmenu = GUICtrlCreateMenu("File")
$Helpitem = GUICtrlCreateMenuItem("Open/Create Database", $Helpmenu)
guictrlsetonevent(-1,"ButtonOpenDB")

$Infoitem = GUICtrlCreateMenuItem("Do Not Click", $Helpmenu)


$InputDBheight = 20
$InputDBwidth = 250
$InputDBPath = GUICtrlCreateInput("", $xBorderL, $yBorderTier1, $InputDBwidth, $InputDBheight)

$TreeDBwidth = $InputDBwidth
$TreeDBheight = 375
$TreeDB = GUICtrlCreateTreeView($xBorderL, $yBorderTier1 + $InputDBheight + $ySpacing, $TreeDBwidth, $TreeDBheight)

$ListVDBxPos = $InputDBwidth + $xBorderL + $xSpacing

$UseExcelLV = true
if $UseExcelLV = false Then
	$ListVDB = GUICtrlCreateListView("Field Names...", $ListVDBxPos, $yBorderTier1, $GUIWidth - $ListVDBxPos - $xBorderR, $TreeDBheight + $ySpacing + $InputDBheight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
Else
	$ListVDB = _GUIctrlcreatelistviewenhanced("Field Names...", $ListVDBxPos, $yBorderTier2, $GUIWidth - $ListVDBxPos - $xBorderR, $TreeDBheight + $ySpacing + $InputDBheight)
EndIf

$TabHeight = $GUIHeight - $yBorderTier2 - 23
$Tab1 = GUICtrlCreateTab(5, $ybordertier2, $GUIWidth - 10,$TabHeight)
GUICtrlSetResizing($Tab1,$gui_dockauto)

$Tab_View = GUICtrlCreateTabItem("   Database View   ")

;Tier 3------------------------------------------
$TreeWidth = 250
$TreeHeight = 350
$ComboHeight = 20

;$Tree = GUICtrlCreateTreeView($xBorderL, $yBorderTier2 + $ComboHeight + $ySpacing, $TreeWidth, $TreeHeight)

;$Combo = GUICtrlCreateCombo("ComboBox", $xBorderL, $yBorderTier2, $TreeWidth, $ComboHeight)

;$ListViewWidth = $GUIWidth - ($xBorderL + $TreeWidth + $xSpacing + $xBorderR)
;$ListViewHeight = $TreeHeight + $ComboHeight + $ySpacing



;$ListView = GUICtrlCreateListView("1|2|3|4", $xBorderL + $TreeWidth + $xSpacing, $yBorderTier2, $ListViewWidth, $ListViewHeight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
;End Tier Two

;Tier 3-------------------------------------------

$bNewPwidth = 100
$bNewPHeight = 100
$bNewP = GUICtrlCreateButton("New Part", $GUIWidth - ($bNewPwidth + $xBorderR+20), $yBorderTier3, $bNewPwidth, $bNewPHeight)
GUICtrlSetOnEvent($bNewP, "AddPart")

;End Tier 3
GUICtrlCreateTabItem("")


$Tab_Database = GUICtrlCreateTabItem("   Raw View   ")
GUICtrlSetState(-1, $GUI_SHOW)
#region

;Database controls
$Group0Ystart = $yBorderTier3
$Group0Xstart = $xBorderL
$Group0width = 90
$Group0Height = $TabHeight -37
GUICtrlCreateGroup("Database", $Group0Xstart, $Group0Ystart, $Group0width, $Group0Height )

$bNewDwidth = 80
$bNewDHeight = 40
$bNewDxStart = $group0xstart+ ($Group0width - $bNewDwidth) / 2
$bNewDyStart = $Group0Ystart + 15
$bNewD = GUICtrlCreateButton("Open/Create Database", $bNewDxStart, $bNewDyStart, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent($bNewD, "ButtonOpenDB")

$bRefreshD = GUICtrlCreateButton("Refresh Database", $bNewDxStart, $bNewDyStart + $ySpacing + $bNewDHeight, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent(-1, "RefreshDatabase")

$bVacuumD = GUICtrlCreateButton("Vacuum Database", $bNewDxStart, $bNewDyStart + 6 * $ySpacing + 2 * $bNewDHeight, $bNewDwidth, $bNewDHeight, $BS_MULTILINE)
GUICtrlSetOnEvent(-1, "VacuumDatabase")

GUICtrlCreateGroup("", -99, -99, 1, 1)


;Table Controls
$Group1Ystart = $yBorderTier3
$Group1Xstart = $Group0Xstart + $Group0width + $xSpacing + 20
$Group1width = 210
GUICtrlCreateGroup("Create New Table", $Group1Xstart, $Group1Ystart, $Group1width, $Group0Height)

$Group1ItemYStart = $Group1Ystart + 20
$Group1ItemXStart = $Group1Xstart + 5
$NewTableLabelHeight = 20
GUICtrlCreateLabel("Table Name:", $Group1Xstart + $xSpacing, $Group1ItemYStart, 100, $NewTableLabelHeight)

$NewTableInputHeight = 21
$NewTableInput = GUICtrlCreateInput("", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight - 5, 200, $NewTableInputHeight)

$NewFieldButtonHeight = 23
$NewFieldButton = GUICtrlCreateButton("New FIELD", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight + $NewTableInputHeight, 100, $NewFieldButtonHeight)
GUICtrlSetOnEvent($NewFieldButton, "NewFieldNewTable")

$NewFieldsLVHeight = 140
$NewFieldsLV = GUICtrlCreateListView("Name|Type", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight + $NewTableInputHeight + $NewFieldButtonHeight+$ySpacing, $Group1width-10, $NewFieldsLVHeight)

$NewTableButton = GUICtrlCreateButton("Create TABLE", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight + $NewTableInputHeight + $NewFieldButtonHeight+$ySpacing+$NewFieldsLVHeight, 100, 23)
GUICtrlSetOnEvent(-1, "NewTable")
GUICtrlCreateGroup("", -99, -99, 1, 1)


$Group2Ystart = $yBorderTier3
$Group2Xstart = $Group1Xstart + $Group1width + $xSpacing
$Group2width = 125
$Group2Height = $Group0Height
GUICtrlCreateGroup("Modify Selected Table", $Group2Xstart, $Group2Ystart, $Group2width, $Group2Height)

$bTableRYstart = $Group1ItemYStart
$bTableRwidth = $Group2width - 10
$bTableRheight = 25
$bTableRxStart = $group2xstart+($Group2width - $bTableRwidth) / 2
$bTableR = GUICtrlCreateButton("Rename Table", $bTableRxStart, $bTableRYstart, $bTableRwidth, $bTableRheight)
GUICtrlSetOnEvent(-1, "RenameTable")

$bTableDyStart = $bTableRYstart + $bTableRheight + $ySpacing
$bTableD = GUICtrlCreateButton("Delete Table", $bTableRxStart, $bTableDyStart, $bTableRwidth, $bTableRheight)
GUICtrlSetOnEvent(-1, "DeleteTable")

$bFieldAyStart = $bTableDyStart + $bTableRheight + 5 * $ySpacing
$bFieldA = GUICtrlCreateButton("Insert Field", $bTableRxStart, $bFieldAyStart, $bTableRwidth, $bTableRheight)
guictrlsetonevent(-1,"NewFieldExistingTable")
GUICtrlSetState(-1, $gui_disable)

$cFieldComboWidth = $Group2width - 25
$cFieldComboXStart = $group2xstart+ ($Group2width - $cFieldComboWidth) / 2
$cFieldComboYStart = $bFieldAyStart + $bTableRheight + 2*$ySpacing
$cFieldCombo = GUICtrlCreateCombo("", $bTableRxStart, $cFieldComboYStart, $bTableRwidth, $bTableRheight)
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
$Group3Xstart = $Group2Xstart + $Group2width + $xSpacing + 20
$Group3width = 115
$Group3Height = $Group0Height
GUICtrlCreateGroup("Modify Records", $Group3Xstart, $Group3Ystart, $Group3width, $Group3Height)

$bNewRWidth = $Group3Width - 10
$bNewRHeight = 25
$bNewRxStart = $group3xstart+($Group3width - $bNewRWidth) / 2
$bNewRyStart = $Group1ItemYStart
$bNewR = GUICtrlCreateButton("New Record", $bNewRxStart, $bNewRyStart, $bNewRWidth, $bNewRHeight)
GUICtrlSetOnEvent($bNewR, "AddRecord")

$bEditRHeight = $bNewRHeight + 11
$bEditR = GUICtrlCreateButton("Edit Selected Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $ySpacing, $bNewRWidth, $bEditRHeight, $BS_MULTILINE)
GUICtrlSetOnEvent($bEditR, "EditRecord")

$bDeleteR = GUICtrlCreateButton("Delete Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $bEditRHeight + 2 * $ySpacing, $bNewRWidth, $bNewRHeight)
GUICtrlSetOnEvent(-1, "DeleteRecord")

GUICtrlCreateGroup("", -99, -99, 1, 1)

;Index Controls
$Group4Ystart = $yBorderTier3
$Group4Xstart = $Group3Xstart + $Group3width + $xSpacing + 20
$Group4width = 125
$Group4Height = $Group0Height
GUICtrlCreateGroup("Modify Indexes", $Group4Xstart, $Group4Ystart, $Group4width, $Group4Height)

$cIndexComboWidth = $Group4width - 10
$cIndexComboXStart = $group4xstart+ ($Group4width - $cIndexComboWidth) / 2

$iLabelHeight = 20
GUICtrlCreateLabel("Choose Fields to index:",$group4xstart+ ($Group4width - $cIndexComboWidth) / 2,$Group4Ystart + 20,$Group4width - 15,$iLabelHeight)

$cIndexComboYStart = $Group4Ystart + 15 + $iLabelHeight
$cIndexCombo = GUICtrlCreateInput("", $cIndexComboXStart, $cIndexComboYStart, $cIndexComboWidth, 20)

$RadioGroup1xStart = $cIndexComboXStart
$RadioGroup1yStart = $cIndexComboYStart + 3 * $ySpacing
$RadioGroup1Width = $Group4width - 10
GUICtrlCreateGroup("", $RadioGroup1xStart, $RadioGroup1yStart, $RadioGroup1Width, 55)
$DescendRadio = GUICtrlCreateRadio("Descend (A-Z)", $RadioGroup1xStart + 5, $RadioGroup1yStart + 10, $RadioGroup1Width-15, 20)
GUICtrlSetState(-1, $GUI_CHecked)

$AscendRadio = GUICtrlCreateRadio("Ascending (Z-A)", $RadioGroup1xStart + 5, $RadioGroup1yStart + 20 + $ySpacing, $RadioGroup1Width-15, 25)

GUICtrlCreateGroup("", -99, -99, 1, 1)


$RadioGroup2xStart = $cIndexComboXStart
$RadioGroup2yStart = $RadioGroup1yStart + 52
GUICtrlCreateGroup("", $RadioGroup2xStart, $RadioGroup2yStart, $RadioGroup1Width, 55)
$UniqueRadio = GUICtrlCreateRadio("Unique", $RadioGroup2xStart + 5, $RadioGroup2yStart + 10, $RadioGroup1Width-15, 20)
GUICtrlSetState(-1, $GUI_CHecked)

$NUniqueRadio = GUICtrlCreateRadio("Not Unique", $RadioGroup2xStart + 5, $RadioGroup2yStart + 20 + $ySpacing, $RadioGroup1Width-15, 25)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$bCreateIndexYstart = $RadioGroup2yStart + 55 + $ySpacing
$bCreateIndex = GUICtrlCreateButton("Create Index", $cIndexComboXStart + 5, $bCreateIndexYstart, $Group4width - 25, 23)
GUICtrlSetOnEvent(-1, "CreateIndex")

$bDeleteIndex = GUICtrlCreateButton("Delete Index", $cIndexComboXStart + 5, $bCreateIndexYstart + 23 + 3 * $ySpacing, $Group4width - 25, 23)
guictrlsetonevent(-1,"DeleteIndex")

GUICtrlCreateGroup("", -99, -99, 1, 1)

;Misc Controls
$Group5Ystart = $yBorderTier3
$Group5Xstart = $Group4Xstart + $Group4width + $xSpacing + 20
$Group5width = 110
$Group5Height = $Group0Height
GUICtrlCreateGroup("Misc", $Group5Xstart, $Group5Ystart, $Group5width, $Group5Height)

$bExcelInWidth = $Group5width-10
$bExcelInHeight = 30
$bExcelInxStart = $group5xstart+ ($Group5width - $bExcelInWidth) / 2
$bExcelInyStart = $Group5Ystart + 20
$bExcelIn = GUICtrlCreateButton("CSV Import", $bExcelInxStart, $bExcelInyStart, $bExcelInWidth, $bExcelInHeight)
GUICtrlSetOnEvent(-1,"CSVImport")

$bExcelOutHeight = $bExcelInHeight
$bExcelOut = GUICtrlCreateButton("CSV Export", $bExcelInxStart, $bExcelInyStart + $bExcelInHeight + $ySpacing, $bExcelInWidth, $bExcelOutHeight, $BS_MULTILINE)
GUICtrlSetState(-1, $gui_disable)

$cBeginner = GUICtrlCreateCheckbox("Beginner Mode", $bExcelInxStart, $bExcelInyStart + 2 * $bExcelInHeight + 2 * $ySpacing, $bExcelInWidth, 25)
GUICtrlSetOnEvent(-1, "Beginner")

GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
GUICtrlCreateTabItem("")

$SQL_View = GUICtrlCreateTabItem("   SQL Entry   ")
#region ;SQL View Tab

$SQLinsertY = $yBorderTier2 + 30
$SQLlabelHeight = 20
$SQLinsertLabel = GUICtrlCreateLabel("Enter SQL Commands:", $xBorderL + 10, $SQLinsertY, 500, $SQLlabelHeight)
$SQLInsert = GUICtrlCreateInput("", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight, 500, 100)

$SQLcommit = GUICtrlCreateButton("Process SQL", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 110, 90, 24)
GUICtrlSetOnEvent(-1, "CommitSQL")

#endregion
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW, $Main)
While 1
	Sleep(8000)
WEnd
Exit

#endregion - GUI Creation

Func OpenDatabase($DBPath1)
	
	Dim $oStmt
	Dim $GetIndices
	Dim $GetFieldNames
	Dim $GetTableNames
	Dim $TableNames[15]
	
	;Close the database connection so you know it isn't open
	$odb.close ();
	
	;If the database is being refreshed you dont ask for a path
	If $DBPath1 = "" Then
		$DBPath = FileOpenDialog("New or Existing Database...", "C:\Kevin\AutoItScripts\PartsDatabase", "DB (*.db)")
		
		;Ensure the .db extension is applied
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
	$SQL = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
	$GetTableNames = $odb.prepare ($SQL)
	
	If $BeginnerMode = True Then
		MsgBox(0, "Gather CREATE statements", $SQL)
	EndIf
	
	$Data = ""
	;NameCount is a count of all tables... used to expand the TableNames array if it exceeds 15
	$NameCount = 0
	
	$HaveLog = false

	While $GetTableNames.step () = 0
		;Put the table name in $Data
		$Data = $GetTableNames.ColumnValue (0)
		
		if $data = "z_SQL_Log" Then
			$HaveLog = True	
		EndIf
		
		;Put the table name in the table name array
		If $NameCount > 14 Then
			_ArrayInsert($TableNames, UBound($TableNames))
		EndIf
		
		$TableNames[$NameCount] = $Data
		$NameCount = $NameCount + 1
		
		;Create TreeView item for table
		$CurTree = GUICtrlCreateTreeViewItem($Data, $TreeDB)
		GUICtrlSetOnEvent($CurTree, "TreeDBTableClick")
		
		;Getting the field names from the current table
		$SQL = "SELECT * FROM " & $Data
		$GetFieldNames = $oDb.Prepare ($SQL)
		
		$ColumnCount = $GetFieldNames.columncount
		
		;Getting the field type requires parsing the original CREATE statement of the table located in the sql field
		$GetFieldType = $odb.prepare ("SELECT name,sql FROM sqlite_master WHERE tbl_name='" & $Data & "'")
			
		;This section grabs the CREATE statement for the current table or index and puts it in the treeview
		While $GetFieldType.step () = 0
			
			;FirstIndex tells the program that this is the first index for a given table.  This way
			;only one index tree item is created for each table
			$FirstIndex = True
			$FirstMiscIndex = True
			
			For $NewColCount = 0 To $GetFieldType.columncount - 1
				
				;Grab the CREATE statement
				$Type = $getfieldtype.columnvalue ($NewColCount)
				
				;Each statement has two "columns", one is the tablename and the other is the CREATE statement. We dont want the name part.
				If $Type <> $Data Then
					;There are three types of CREATES, TABLE and INDEX and Misc (Misc catches things I dont know about!)
					If StringInStr($Type, "TABLE", 1) Then

						
						$Junk = stringinstr($type,"(",1,1)
						
						$TempType = stringtrimleft($type,$junk)
						$TempArray = stringsplit($TempType,",")
						
						;Ok now that you have the data available (Field Name and Type), time to go back and put it together
						For $Count = 0 To $ColumnCount - 1
							;Column Name
							$Data1 = $GetFieldNames.columnname ($Count)
							
							;Parse Column Type

							$ColType = StringStripWS($TempArray[$count+1], 3)
							If StringRight($ColType, 1) = ")" Then $ColType = StringTrimRight($ColType, 1)
							
							;Put Column name and Column Type in the Tree underneath table item
							GUICtrlCreateTreeViewItem($ColType, $CurTree)
							ControlFocus("Parts Database", "", $InputDBPath)
							$Data1 = ""
						Next
					ElseIf StringInStr($Type, "INDEX", 1) Then
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
					Else
						;If it's the first Misc for the table you need to create an INDEX item
						If $FirstMiscIndex = True Then
							$IndexItem = GUICtrlCreateTreeViewItem("Misc", $CurTree)
							$FirstMiscIndex = False
						EndIf
						
						If $Type = "0" Then
							
						EndIf
						
						GUICtrlCreateTreeViewItem($Type, $IndexItem)
					EndIf
				EndIf
			Next
		WEnd
	WEnd
	
	if $HaveLog = false Then
		$SQL = "CREATE TABLE z_SQL_Log(TimeStamp TEXT DEFAULT CURRENT_TIMESTAMP , Comment TEXT , SQLEntry TEXT)"
		$odb.execute("BEGIN TRANSACTION")
		$odb.execute($SQL)
;		msgbox(0,"","INSERT INTO _SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Initialize Log Table')")
		$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Initialize Log Table')")
		$ODB.execute("COMMIT TRANSACTION")
	EndIf
	
EndFunc   ;==>OpenDatabase

Func TreeDBTableClick()
	Dim $GetFieldNames
	Dim $Data1 = ""
	
	;Get the current selected table from the TreeView
	$ItemID = _GUICtrlTreeViewItemGetTree ($GUIText, $TreeDB, "|")
	$TempArray = StringSplit($ItemID, "|")
	
	;Store the Current Table for future reference
	If $TempArray[1] <> "" Then
		
		$CurTable = $TempArray[1]
		
		;Get field names so you can put them at the top of the ListView control
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
		
		;Get the CREATE statement for this table so you can get the FieldTypes
		$SQL = "SELECT sql FROM sqlite_master WHERE tbl_name='" & $CurTable & "'"
		$GetFieldType = $odb.prepare ($SQL)
		
		If $BeginnerMode = True Then
			MsgBox(0, "Get the CREATE statements from table", $SQL)
		EndIf
		
		;This grabs the table CREATE statement (there are different types, INDEX for example)
		While $getfieldtype.step () = 0
			For $NewColCount = 0 To $GetFieldType.columncount - 1
				$TempString = $getfieldtype.columnvalue ($NewColCount)
				
				If StringInStr($TempString, "CREATE TABLE", 1) Then
					$Type = $GetFieldType.columnvalue ($NewColCount)
				EndIf
			Next
		WEnd
		
		If $BeginnerMode = True Then
			MsgBox(0, "A Sample CREATE statement", $Type)
		EndIf
		
		;We want the first column of the listview to be the interanal SQLite rowid
		$Data1 = "RowID*"
		
		;Generate the new header columns for the ListView
		For $Count = 0 To $ColumnCount - 1
			
			;Column Name
			If StringInStr($Type, "TABLE", 1) Then
				$Data1 = $Data1 & "|" & $GetFieldNames.columnname ($Count)
				
				$FieldNames[$Count][0] = $getfieldnames.columnname ($Count)
				
				$Junk = stringinstr($type,"(",1,1)
				
				$TempType = stringtrimleft($type,$junk)
				$TempArray = stringsplit($TempType,",")
					
				;Parse Column Type
				$ColType = StringStripWS($TempArray[$Count+1], 3)
				If StringRight($ColType, 1) = ")" Then $ColType = StringTrimRight($ColType, 1)
					
					
				$FieldNames[$Count][1] = $ColType
				If StringInStr($ColType, "PRIMARY KEY", 1) <> 0 Then
					$Data1 = $Data1 & "*"
				EndIf
			EndIf
		Next
		
		;Reset the ListView control and put in all data from the selected table
		
		;Regen listview...
		if $UseExcelLV = false Then
			GUICtrlDelete($ListVDB)
			GUISwitch($Main, $Tab_Database)
			$ListVDB = GUICtrlCreateListView($Data1, $ListVDBxPos, $yBorderTier2, $GUIWidth - $ListVDBxPos - $xBorderR, $TreeDBheight + $ySpacing + $InputDBheight, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
			GUICtrlSetState($Tab_Database, $GUI_SHOW)
		Else
			with $oexcel
				For $Headercount = 1 to $LastNumOfHeadings
					.activewindow.columnheadings($HeaderCount).caption = $headercount				
				Next
			
				$TempColHeadings = stringsplit($data1,"|",1)
				;_arraydisplay($tempcolheadings,"")

				.ActiveSheet.Range("A1:IV" & $lastnumofrows).Clear
				$LastNumOfHeadings = $tempcolheadings[0]
				for $HeaderCount = 1 to $TempColHeadings[0]
					.activewindow.columnheadings($HeaderCount).caption = $TempColHeadings[$HeaderCount]
					.columns($HeaderCount).autofit
				Next
			EndWith
		EndIf
		
		;Grab all data from database table and display in ListView
		$SQL = "SELECT rowid,* FROM " & $CurTable & " ORDER BY rowid"
		$TableData = $oDb.Prepare ($SQL)
		
		If $BeginnerMode = True Then
			MsgBox(0, "Select all data, order by rowid", $SQL)
		EndIf
		
		;Read data into table... lock listview so it doesn't flicker
		if $UseExcelLV = false Then
			GUISetState(@SW_LOCK)
			While $tabledata.step () = 0
				$Data = ""
				For $Count = 0 To $ColumnCount
					$Data = $Data & "|" & $tabledata.ColumnValue ($Count)
				Next
				GUICtrlCreateListViewItem($Data, $ListVDB)
				$Data = StringTrimLeft($Data, 1)
			WEnd
			GUISetState(@SW_UNLOCK)				
		Else
			$SSRow = 1
			While $tabledata.step () = 0

				for $SSCol = 1 to $columncount+1
					If $tabledata.ColumnValue ($SSCol-1) = "" Then
						$oexcel.cells($SSRow,$SSCol).value = " "
					Else
						$oexcel.cells($SSRow,$SSCol).value =$tabledata.ColumnValue ($SSCol-1) 
					EndIf
				Next
				
				$SSRow = $SSRow +1
			WEnd
			
			for $ColCOunt = 1 to $columncount+1
				$oexcel.columns($colcount).autofit
			Next
			
			$LastNumOfRows = $SSRow
		EndIf
		
		
		$TableData.Close ();
	EndIf
EndFunc   ;==>TreeDBTableClick

Func NewTable()
;This function creates a new table.  It assumes the user has already filled out the necessary data in the GUI.

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
			
			;Get the field name and type data from the field listview... put it together for SQL
			if _GUICtrlListViewGetItemCount($NewFieldsLV) > 0 Then
				For $LVcount = 0 To _GUICtrlListViewGetItemCount ($NewFieldsLV) - 1
					$LVdata = _GUICtrlListViewGetItemText ($NewFieldsLV, $LVcount)
					
					$TempArray = StringSplit($LVdata, "|")
					$FieldParamStr = $FieldParamStr & "," & " " & $TempArray[1] & " " & $TempArray[2]
				Next
				
				$FieldParamStr = StringTrimLeft($FieldParamStr, 2)
				
				$SQL = "CREATE TABLE " & $TableName & " (" & $FieldParamStr & ")"
				$oDb.Execute ($SQL)
				
				If $BeginnerMode = False Then
					MsgBox(0, "Create the table", $SQL)
				EndIf
				
				OpenDatabase($DBPath)
			Else
				msgbox(0,"Add Fields","You need to add fields using the Add Fields button.")
			EndIf
			
		EndIf
	EndIf
EndFunc   ;==>NewTable

Func NewFieldNewTable()
	CreateNewField(False)
EndFunc

Func NewFieldExistingTable()
	if FileExists($DBPath) = 0 Then
		msgbox(0,"Open Database","You need to open a database first.")
	ElseIf not IsArray($fieldnames) Then
		msgbox(0,"Choose Table","You need to choose a table from the tree first.")
	Else
		CreateNewField(True)
	EndIf
EndFunc

Func CreateNewField($AddToExisting)
;This function starts the creation of a new field for a new table.  It creates the GUI for creation.
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "Open a Database", "Please open a database.")
	Else
		$FieldGUIwidth = 550
		$FieldGUI = GUICreate("Put Field together", $FieldGUIwidth, 390)
		GUISetOnEvent($GUI_EVENT_CLOSE, "FieldGUIClose") ;This line tells the GUI to close when the "X" is clicked
		
		$Shpiel = "Insert the new field name and it's parameters. Insert parameters, then modifiers, then Defaults. ONLY the first parameter, any modifiers, and the first DEFAULT will be used. For example: FName::Param1,Modifier1,Modifier2,Default1" & @CR & @CR & _
				"Parameters:" & @CR & _
				"1 = TEXT" & @CR & _
				"2 = NUMERIC" & @CR & _
				"3 = BLOB" & @CR & _
				"4 = INTEGER" & @CR & @CR & _
				"Some Modifiers:" & @CR & _
				"5 = PRIMARY KEY" & @CR & _
				"6 = UNIQUE (not needed if PRIMARY KEY is used)" & @CR & _
				"7 = COLLATE NOCASE" & @CR & @CR & _
				"Column Default Values:" & @CR & _
				"8 = CURRENT_TIME [HH:MM:SS]" & @CR & _
				"9 = CURRENT_DATE [YYYY-MM-DD]" & @CR & _
				"0 = CURRENT_TIMESTAMP [YYYY-MM-DD HH:MM:SS]"
		
		$NewFieldLabel = GUICtrlCreateLabel($Shpiel, 5, 5, $FieldGUIwidth - 10, 300)
		
		$UpdatedLabel = GUICtrlCreateLabel("Preview Appears Here...", 5, 315, $FieldGUIwidth - 10, 20)
		
		$FieldInputBox = GUICtrlCreateInput("", 5, 335, $FieldGUIwidth - 10, 20)
		
		$PreviewButton = GUICtrlCreateButton("Preview", 50, 360, 75, 25)
		GUICtrlSetOnEvent($FieldInputBox, "FieldInputEvent")
		
		$AddFieldButton = GUICtrlCreateButton("Add Field", 170, 360, 75, 25)
		if $AddToExisting = false Then
			GUICtrlSetOnEvent($AddFieldButton, "NewFieldName")
		elseif $addtoexisting = True Then
			GUICtrlSetOnEvent($AddFieldButton, "AddFieldToExisting")
		EndIf
		
		GUISetState(@SW_SHOW, $FieldGUI)
	EndIf
EndFunc   ;==>CreateNewField

Func AddFieldToExisting()
	$FieldText = GUICtrlRead($FieldInputBox)
	$ParsedFieldText = InputFieldParse($FieldText,2)
	
	$TempArray = StringSplit($FieldText, "::", 1)
	
	If $FieldText <> "" And IsArray($TempArray) Then
		$SQL = "ALTER TABLE " & $curtable & " COLUMN " & $ParsedFieldText
		
		if $BeginnerMode = True Then
			msgbox(0,"Add Index",$SQL)
		EndIf
		
		$odb.execute("BEGIN TRANSACTION")
		$odb.execute($SQL)
		$odb.execute("COMMIT TRANSACTION")
		
		guidelete($FieldGUI)
		
		TreeDBTableClick()
	Else
		MsgBox(0, "Incorrect entry", "Please reenter the data.  Don't forget the :: delimiter.")
	EndIf

EndFunc

Func FieldInputEvent()
;This function is the function called when you click on a new field... it is deleted!
	$FieldText = InputFieldParse(GUICtrlRead($FieldInputBox))
	GUICtrlSetData($UpdatedLabel, $FieldText)
EndFunc   ;==>FieldInputEvent

Func FieldGUIClose()
	GUIDelete($FieldGUI)
EndFunc   ;==>FieldGUIClose

Func NewFieldName()
;This is the function that is called when the user presses the Add Field button on the new field GUI. It just adds the field info to
;	the new field listview

	$FieldText = GUICtrlRead($FieldInputBox)
	$ParsedFieldText = InputFieldParse($FieldText)
	
	$TempArray = StringSplit($FieldText, "::", 1)
	
	If $FieldText <> "" And IsArray($TempArray) Then
		$Item = $TempArray[1] & "|" & StringReplace($ParsedFieldText, $TempArray[1] & " ", "", 1)
		
		$NewFieldItem = GUICtrlCreateListViewItem($Item, $NewFieldsLV)
		
		;Set the GUI to automatically delete the new field if it is clicked
		GUICtrlSetOnEvent($NewFieldItem, "DeleteField")
		GUIDelete($FieldGUI)
	Else
		MsgBox(0, "Incorrect entry", "Please reenter the data.  Don't forget the :: delimiter.")
	EndIf
EndFunc   ;==>NewFieldName

Func InputFieldParse($iString,$AddExisting=1)
	
	If $iString <> "" Then
		$TempArray = StringSplit($iString, "::", 1)
		
		If $TempArray[0] > 1 Then
			$NewFName = StringStripWS($TempArray[1], 8)
			$Parameters = StringSplit(StringStripWS($TempArray[2], 8), ",")
			
			;These three booleans tell whether the first datatype, Unique/Pri Key identifier, or Default field have been reached
			$param = False
			$Key = False
			$Default = False
			
			For $PCount = 1 To $Parameters[0]
				If $Parameters[$PCount] = "1" And $param = False Then
					$Parameters[$PCount] = "TEXT"
					$param = True
				ElseIf $Parameters[$PCount] = "2" And $param = False Then
					$Parameters[$PCount] = "NUMERIC"
					$param = True
				ElseIf $Parameters[$PCount] = "3" And $param = False Then
					$Parameters[$PCount] = "BLOB"
					$param = True
				ElseIf $Parameters[$PCount] = "4" And $param = False Then
					$Parameters[$PCount] = "INTEGER"
					$param = True
				ElseIf $Parameters[$PCount] = "5" And $Key = False and $AddExisting = 1 Then
					$Parameters[$PCount] = "PRIMARY KEY"
					$Key = True
				ElseIf $Parameters[$PCount] = "6" And $Key = False and $AddExisting = 1 Then
					$Parameters[$PCount] = "UNIQUE"
					$Key = True
				ElseIf $Parameters[$PCount] = "7" Then
					$Parameters[$PCount] = "COLLATE NOCASE"
				ElseIf $Parameters[$PCount] = "8" And $Default = False and $AddExisting = 1 Then
					$Parameters[$PCount] = "DEFAULT CURRENT_TIME"
					$Default = True
				ElseIf $Parameters[$PCount] = "9" And $Default = False and $AddExisting = 1 Then
					$Parameters[$PCount] = "DEFAULT CURRENT_DATE"
					$Default = True
				ElseIf $Parameters[$PCount] = "0" And $Default = False and $AddExisting = 1 Then
					$Parameters[$PCount] = "DEFAULT CURRENT_TIMESTAMP"
					$Default = True
				Else
					;If the user has typed in their own parameters... we assume they know what they are doing!
					If IsNumber(Number($Parameters[$PCount])) Then
						$Parameters[$PCount] = ""
					Else
						$Parameters[$PCount] = StringUpper($Parameters[$PCount])
					EndIf
				EndIf
				
				If $Parameters[$PCount] <> "" Then
					$NewFName = $NewFName & " " & $Parameters[$PCount]
				EndIf
			Next
			
			Return $NewFName
		Else
			return "Don't forget the :: delimiter!!"
		EndIf
		
	EndIf
	
EndFunc   ;==>InputFieldParse

Func DeleteField()
	_GUICtrlListViewDeleteItemsSelected ($NewFieldsLV)
EndFunc   ;==>DeleteField

Func EditRecord()
;This function starts the process to edit a record. It gets the current listview selection and then calls the 
;	function to create the edit GUI.  When you click 'edit' in the GUI you run RecordEdit.
	dim $CurRecord[2]
	
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "Open Database", "You Need to open a valid database.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Select Table", "You need to select a table before choosing this action.")
	Else
		if $UseExcelLV = false Then
			if _GUICtrlListViewGetSelectedCount ($ListVDB) < 1 Then
				MsgBox(0, "Select Record", "You need to select a record before choosing this action.")
			Else
				$CurRecord = _GUICtrlListViewGetItemTextArray ($ListVDB)
				$CurListIndex = $CurRecord[1]
			EndIf
		Else
			dim $CurRecord[$LastNumOfHeadings]
			
			$CurRow = $oexcel.selection.row
			$curlistindex = $oexcel.cells($currow,1).value	
			
			if $currow < 1 then
				msgbox(0, "Select Record", "You need to select a record before choosing this action.")
			Else
				;Pull record from database so that numbers aren't screwed up by Excel
				$Record = $odb.prepare("SELECT * FROM " & $CurTable & " WHERE rowid=" & $CurListIndex)
				
				while $Record.step() = 0
					for $cCount = 0 to $Record.columncount-1
						$CurRecord[$cCount+1] = $Record.columnvalue($cCount)
					Next
				WEnd
			EndIf
		EndIf
		DisplayRecGUI($CurRecord)
	EndIf
	
EndFunc   ;==>EditRecord

Func RecordEdit()
;After you have input the changes you now have to update the database!

	$ColumnNames = ""
	$ColumnData = ""
	
	$KeyFound = False
	
	For $Count = 0 To UBound($FieldNames, 1) - 1
		If StringInStr($FieldNames[$Count][1], "PRIMARY") = 0 Then
			$TempData = stringreplace(GUICtrlRead($InputBoxes[$Count]),"'","''")
			$ColumnData = $ColumnData & " , " & $FieldNames[$Count][0] & "='" & $TempData & "'"
		Else
			$PriKey = $FieldNames[$Count][0]
			$PriNum = $CurListIndex
			$KeyFound = True
		EndIf
	Next
	
	If $KeyFound = False Then
		$PriNum = $CurListIndex
		$PriKey = "rowid"
	EndIf
	
	$ColumnData = StringTrimLeft($ColumnData, 3)

	$SQL = "UPDATE " & $CurTable & " SET " & $ColumnData & " WHERE " & $PriKey & "= " & $PriNum

	If $BeginnerMode = True	 Then
		MsgBox(0, "Update the record", $SQL)
	EndIf
	$odb.execute ("BEGIN TRANSACTION")
	$odb.execute ($SQL)
	$SQL = stringreplace($SQL,"'","''")
	$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Record Edit')")
	$odb.execute ("COMMIT TRANSACTION")
	
	GUIDelete($RecordGUI)
	TreeDBTableClick()
	
EndFunc   ;==>RecordEdit

Func AddRecord()
;This function starts the insert new record process.  It launches the GUI.  Records are actually inserted
;	in InsertRecord.
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "", "You need to open a valid database.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Select a Table", "Please select a table first.")
	Else
		DisplayRecGUI("")
	EndIf
	
EndFunc   ;==>AddRecord

Func InsertRecord()
;This function inserts the new record into the database.

	$NewRecord = ""
	Dim $ColumnNames = ""
	Dim $ColumnData = ""
	
	$oDb.Execute ("BEGIN TRANSACTION")
	
	;Build the list of columns and the list of values for the SQL statment
	For $FieldCount = 0 To UBound($InputBoxes) - 1
		
		;If the field is a PRIMARY KEY it won't get updated and doesn't need to be in the SQL Statement.
		If StringInStr($FieldNames[$FieldCount][1], "PRIMARY KEY") Then
			$ColumnNames = $ColumnNames & "," & $FieldNames[$FieldCount][0]
			$ColumnData = $ColumnData & "," & "null"
			
		;If the user has left the inputs empty, either there is no information or the field has a default value
		;	If there is no information add a space so that nothing appears.  If it is a default, do nothing.
		ElseIf GUICtrlRead($InputBoxes[$FieldCount]) = "" Then
			If StringInStr($FieldNames[$FieldCount][1], "DEFAULT") = 0 Then
				$ColumnNames = $ColumnNames & "," & $FieldNames[$FieldCount][0]
				$ColumnData = $ColumnData & ",' '"
			EndIf
		
		;A normal field gets updated with the user input text.
		Else
			$ColumnNames = $ColumnNames & "," & $FieldNames[$FieldCount][0]
			$ColumnData = $ColumnData & ",'" & GUICtrlRead($InputBoxes[$FieldCount]) & "'"
		EndIf
	Next
	
	;Clean up the column names and values
	$ColumnNames = StringTrimLeft($ColumnNames, 1)
	While StringLeft($ColumnData, 1) = ","
		$ColumnData = StringTrimLeft($ColumnData, 1)
	WEnd
	
	;Insert the data into the database
	$SQL= "INSERT INTO " & $CurTable & "(" & $ColumnNames & ") VALUES( " & $ColumnData & ")"
	$odb.execute ($SQL)
	$SQL = stringreplace($SQL,"'","''")
	$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Record Insert')")
	$oDb.Execute ("COMMIT TRANSACTION")
	
	If $BeginnerMode = True Then
		MsgBox(0, "Insert Record", $SQL)
	EndIf
	
	GUIDelete($RecordGUI)
	TreeDBTableClick()
EndFunc   ;==>InsertRecord

Func DeleteRecord()
;Deletes the currently selected record

	If FileExists($DBPath) = 0 Then
		MsgBox(0, "Open Database", "You Need to open a valid database.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Select Table", "You need to select a table before choosing this action.")
	Else
		if $UseExcelLV = false Then
			$CurRecord = _GUICtrlListViewGetItemTextArray ($ListVDB)
			$DBIndex = $CurRecord[1]
		Else
			$DBIndex = $oexcel.selection.row
			$dbindex = $oexcel.cells($dbindex,1).value
		EndIf

		$Confirm = MsgBox(1, "Delete Record?", "Are you sure you want to delete Record# " & $DBIndex & "?  All data will be lost!")
		
		If $Confirm = 1 Then
			
			$SQL = "DELETE FROM " & $CurTable & " WHERE rowid=" & $DBIndex
			$odb.execute ("BEGIN TRANSACTION")
			$odb.execute ($SQL)
			$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Record Delete')")

			$odb.execute ("COMMIT TRANSACTION")
			
			If $BeginnerMode = True Then
				MsgBox(0, "Delete record", $SQL)
			EndIf
			
			TreeDBTableClick()
		EndIf
	EndIf
EndFunc   ;==>DeleteRecord

Func AddPart()
	
EndFunc   ;==>AddPart

Func RefreshDatabase()
	If FileExists($DBPath) Then
		OpenDatabase($DBPath)
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	EndIf
EndFunc   ;==>RefreshDatabase

Func RenameTable()
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't rename a table.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Choose Table", "You need to choose a table for this action.")
	Else
		$CheckEnd = UBound($TableNames) - 1

		$NewName = InputBox("Give a new name", "Please enter the new name you would like to give the table.", $CurTable)

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
				$SQL = "ALTER TABLE " & $CurTable & " RENAME TO " & $NewName
				$odb.execute ("BEGIN TRANSACTION")
				$odb.execute ($SQL)
				$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Table Rename')")

				$odb.execute ("COMMIT TRANSACTION")
				
				If $BeginnerMode = True Then
					MsgBox(0, "Rename the table", $SQL)
				EndIf
				
				OpenDatabase($DBPath)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>RenameTable

Func DeleteTable()
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Choose Table", "You need to choose a table for this action.")
	elseif $curtable = "z_SQL_Log" Then
		msgbox(0,"","Please don't delete this table...")
	Else
		$Confirm = MsgBox(1, "Delete Table?", "If you delete this table >< " & $CurTable & " >< all information will be lost.  Continue?")
		
		If $Confirm = 1 Then
			$SQL = "DROP TABLE " & $CurTable
			$odb.execute ("BEGIN TRANSACTION")
			$odb.execute ($SQL)
			$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Table Delete')")
			$odb.execute ("COMMIT TRANSACTION")
			
			If $BeginnerMode = True Then
				MsgBox(0, "Delete Table", $SQL)
			EndIf
			
			OpenDatabase($DBPath)
			
		EndIf
	EndIf
	
EndFunc   ;==>DeleteTable

Func VacuumDatabase()
	If GUICtrlRead($InputDBPath) <> "" Then
		$SQL = "VACUUM"
		$odb.execute ($SQL)
		$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Database Vacuum')")
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
				
				For $ColCount = 0 To $ColumnCount
					$ColString = $ColString & "|" & $ColCount
				Next
				
				$ColString = StringTrimLeft($ColString, 1)
				
				if $UseExcelLV = false Then
					GUICtrlDelete($ListVDB)
	
					GUISwitch($Main, $SQL_View)
					$ListVDB = GUICtrlCreateListView($ColString, $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 140, $GUIWidth - 40, $guiheight- ($SQLinsertY + $SQLlabelHeight + 180))
					GUICtrlSetState($SQL_View, $GUI_SHOW)
					
					GUISetState(@SW_LOCK)
					While $DataOut.step () = 0
						$Data = ""
						For $Count = 0 To $ColumnCount
							$Data = $Data & "|" & $dataout.ColumnValue ($Count)
						Next
						
						$Data = StringTrimLeft($Data, 1)
						
						GUICtrlCreateListViewItem($Data, $ListVDB)
						
					WEnd
					_GUICtrlListViewSetColumnWidth ($ListVDB, 0, $LVSCW_AUTOSIZE)
					GUISetState(@SW_UNLOCK)
				Else
					with $oexcel
						For $Headercount = 1 to $LastNumOfHeadings
							.activewindow.columnheadings($HeaderCount).caption = $headercount				
						Next
						
						.ActiveSheet.Range("A1:IV" & $lastnumofrows).Clear
						
						for $HeaderCount = 1 to $ColumnCount+1
							.activewindow.columnheadings($HeaderCount).caption = $HeaderCount
							.columns($HeaderCount).autofit
						Next
						$SSRow = 1
						while $dataout.step()=0
							for $ColCount = 0 to $columncount	
								if $dataout.columnvalue($ColCount) <> "" Then
									$oexcel.cells($SSRow,$colcount+1).value = $dataout.columnvalue($ColCount)
								Else
									$oexcel.cells($SSRow,$colcount+1).value = " "
								EndIf
							Next
							$SSRow=$SSRow+1
						wend
						$LastNumOfHeadings = $ColumnCount+1
					EndWith
				
				EndIf
				
			EndIf
		Else
			$odb.execute ("BEGIN TRANSACTION")
			$odb.execute (GUICtrlRead($SQLInsert))
			$odb.execute ("COMMIT TRANSACTION")
			
			;GUICtrlCreateListViewItem("Look in the Raw View to see if the change occured.", $SQLresult)
			;_GUICtrlListViewSetColumnWidth ($SQLresult, 0, $LVSCW_AUTOSIZE)
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

Func DisplayRecGUI($rgRecord = "")
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
	
	;pixels per character seems about right for width
	$LabelMaxWidth = $LabelMaxWidth * 6
	
	;Set up and make the GUI
	$RecordGUIheight = UBound($FieldNames, 1) * 25 + 75
	$RecordGUIwidth = (Ceiling(UBound($FieldNames, 1) / 15)) * ($LabelMaxWidth + 150 + 20)
	$RecordGUI = GUICreate("Edit/New Record", $RecordGUIwidth, $RecordGUIheight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ChildGUIDelete")
	
	If IsArray($rgRecord) Then
		$InsertText = "Update"
	Else
		$InsertText = "Insert"
	EndIf
	
	$rgInsert = GUICtrlCreateButton($InsertText, $RecordGUIwidth / 2 + 5, $RecordGUIheight - 25, 80, 20)
	If IsArray($rgRecord) Then
		GUICtrlSetOnEvent($rgInsert, "RecordEdit")
	Else
		GUICtrlSetOnEvent($rgInsert, "InsertRecord")
	EndIf
	
	$rgClose = GUICtrlCreateButton("Close", $RecordGUIwidth / 2 - 85, $RecordGUIheight - 25, 80, 20)
	GUICtrlSetOnEvent(-1, "ChildGUIDelete")
	
	$rgAllowDefaults = GUICtrlCreateCheckbox("Allow changing DEFAULT fields", $rgXborder, $RecordGUIheight - 50, $RecordGUIwidth, 20)
	GUICtrlSetOnEvent(-1, "AllowDefaults")
	
	$LabelXStart = $rgXborder
	$InputXStart = $rgXborder + $LabelMaxWidth + 10
	
	For $FieldCount = 0 To UBound($FieldNames, 1) - 1
		if $fieldcount = 16 Then
			$LabelXStart = $rgXborder + $LabelMaxWidth + 150 + 3*$xspacing
			$InputXStart = $rgXborder + 2* $LabelMaxWidth + 150 + 2*$xspacing +10
			$rgYborder = 20
		EndIf
		
		GUICtrlCreateLabel($FieldNames[$FieldCount][0], $LabelXStart, $rgYborder+2, $LabelMaxWidth, 20,$SS_RIGHT )
		
		If IsArray($rgRecord) Then
			
			
			If $rgRecord[$FieldCount + 1] <> "" Then
				$Text = $rgRecord[$FieldCount + 1]
			Else
				$Text = ""
			EndIf
		Else
			$Text = ""
		EndIf
		
		
		$InputBoxes[$FieldCount] = GUICtrlCreateInput($Text,$InputXStart , $rgYborder, 150, 20)
		
		If StringInStr($FieldNames[$FieldCount][1], "PRIMARY") Then
			GUICtrlSetState($InputBoxes[$FieldCount], $gui_disable)
		EndIf
		
		If StringInStr($FieldNames[$FieldCount][1], "DEFAULT") Then
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

Func AllowDefaults()
	$Checked = GUICtrlRead($rgAllowDefaults)
		
	If $Checked = $GUI_CHecked Then
		for $count = 0 to ubound($InputBoxes)-1
			if StringInStr($FieldNames[$count][1],"PRIMARY KEY",1) = 0 Then
				GUICtrlSetState($inputboxes[$count],$GUI_ENABLE)
			EndIf
		Next
	ElseIf $Checked = $gui_unchecked Then
		for $count = 0 to ubound($InputBoxes)-1
			if StringInStr($FieldNames[$count][1],"PRIMARY KEY",1) = 0 and StringInStr($fieldnames[$count][1],"DEFAULT",1) <> 0 Then
				GUICtrlSetState($inputboxes[$count],$GUI_DISABLE)
			EndIf
		Next
	EndIf
EndFunc   ;==>AllowDefaults

Func CreateIndex()
	If FileExists($DBPath) = 0 Then
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't rename a table.")
	ElseIf Not IsArray($FieldNames) Then
		MsgBox(0, "Choose Table", "You need to choose a table for this action.")
	Else
		$IndexName = InputBox("Insert Index Name", "Please insert a name for the index.")
		
		$ColumnData = ""
		
		If $IndexName <> "" And @error = 0 Then
			$Fields = GUICtrlRead($cIndexCombo)
			
			$TempArray = StringSplit($Fields, ",")
			_ArrayDisplay($TempArray, "")
			
			$found = False
			
			$FieldCount = UBound($FieldNames, 1) - 1
			
			If GUICtrlRead($UniqueRadio) = $GUI_CHecked Then
				$Unique = "UNIQUE "
			Else
				$Unique = ""
			EndIf
			
			If GUICtrlRead($AscendRadio) = $GUI_CHecked Then
				$Direction = " ASC"
			Else
				$Direction = " DESC"
			EndIf
			
			If $TempArray[0] = 1 Then
				For $Count = 0 To $FieldCount
					If $TempArray[1] = $FieldNames[$Count][0] Then
						$found = True
						$ColumnData = $TempArray[1] & $Direction
						ExitLoop
					EndIf
				Next
				
				
			Else
				For $InCount = 1 To $TempArray[0]
					$found = False
					For $Count = 0 To $FieldCount
						If $TempArray[$InCount] = $FieldNames[$Count][0] Then
							$found = True
							$ColumnData = $ColumnData & " , " & $TempArray[$InCount] & $Direction
							ExitLoop
						EndIf
					Next
					
					If $found = False Then
						MsgBox(0, "Invalid Field Names", "You're using an invalid field name somewhere.")
						ExitLoop
					EndIf
				Next
			EndIf
			
			If $found = True Then
				
				If StringLeft($ColumnData, 3) = " , " Then $ColumnData = StringTrimLeft($ColumnData, 3)
				
				$SQL = "CREATE " & $Unique & "INDEX " & $IndexName & " ON " & $CurTable & "(" & $ColumnData & ")"
				
				if $BeginnerMode = true Then
					MsgBox(0, "Create Index", $SQL)
				EndIf
				
				$odb.execute ("BEGIN TRANSACTION")
				$odb.execute ($SQL)
				$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Index Create')")

				$odb.execute ("COMMIT TRANSACTION")
				
				TreeDBTableClick()
			EndIf
		EndIf
		
	EndIf
EndFunc   ;==>CreateIndex

Func DeleteIndex()
	$IndexName = inputbox("Delete Index","Type the name of an index from this table.  Index names can be found in the Tree on the left.")
	
	if $IndexName <> "" and @error = 0 Then
		
		$SQL = "DROP INDEX " & $IndexName
		
		$odb.execute("BEGIN TRANSACTION")
		$odb.execute($SQL)
		$odb.execute("INSERT INTO z_SQL_Log(SQLEntry, Comment) VALUES('" & $SQL & "','Index Delete')")
		$odb.execute("COMMIT TRANSACTION")
		
		if $BeginnerMode = true Then
			MsgBox(0, "Delete Index", $SQL)
		EndIf
	EndIf
EndFunc

Func ButtonOpenDB()
	OpenDatabase("")
EndFunc   ;==>ButtonOpenDB

Func CSVImport()
	if FileExists($dbpath) = 0 Then
		msgbox(0,"Open a Database","You need to open a database.")
	Else
		$CSVPath = FileOpenDialog("Choose a CSV file to import...", "C:\Kevin\AutoItScripts\PartsDatabase", "CSV (*.csv)")
		
		if $csvpath = ""  or @error <> 0 Then			
			msgbox(0,"Error Opening File","Not a valid file.")
		Elseif fileexists($CSVPath) Then
			
			$CSVFile = fileopen($CSVPath,0)
			
			While 1
				$Line = FileReadLine($csvFile)
				
				If @error = -1 Then ExitLoop
				
				;$TempArray = 
				
			Wend
	
		endif
	EndIf
EndFunc

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

func _GUICtrlCreateListViewEnhanced($col_names, $x_pos,$y_pos,$width,$height)	
	;Create Spreadsheet object.
	;$oExcel = ObjCreate("OWC10.spreadsheet"); Office XP
	;If not IsObj($oExcel) Then    
	;	$oExcel = ObjCreate("OWC9.spreadsheet"); Office 2000
	;EndIf
	if not isobj($oExcel) then
		$oExcel = ObjCreate("OWC11.spreadsheet"); Office 2003
	EndIf
	
	If IsObj($oExcel) Then
		with $oExcel
			.AllowPropertyToolbox = True
			.DisplayOfficeLogo = false
			.DisplayPropertyToolbox = False 
			.DisplayTitleBar = False 
			.DisplayToolbar = False
			.ViewOnlyMode = True
			;.autofit = True
			;.Maxwidth = 1000
			;.Maxheight = 1000
		EndWith

		With $oexcel.ActiveWindow
			.DisplayGridlines = True
			.DisplayHorizontalScrollBar = True
			.DisplayVerticalScrollBar = True
			.DisplayColumnHeadings = True
			
			.DisplayRowHeadings = False    
			.DisplayWorkbookTabs = False        
			.EnableResize = false
		EndWith
		
		$owcWbook = $oExcel.ActiveWorkbook
		$owcWSheet=$owcWbook.ActiveSheet
		
		$GUI_ActiveX = GUICtrlCreateObj($oExcel,265,1,730,415) 	
		guictrlsetstyle(-1,$ws_visible)
		GUICtrlSetResizing($GUI_ActiveX,$gui_dockAuto)
		;$oexcel.activesheet.rows(2).Select
		;$oexcel.ActiveWindow.FreezePanes = True	
		;$owcwsheet.cells(2,1).Select
		
		$TempHeadingArray = stringsplit($col_names,"|")

	with $oexcel
		for $i = 1 to $tempheadingarray[0]
			;.cells(1,$i).value = $tempheadingarray[1]
			.activewindow.columnheadings($i).caption = $Tempheadingarray[$i]
			.columns($i).autofit
		next  
	EndWith
	
	;~ With $owcWSheet.Protection()
	;~ 	.AllowDeletingColumns = 0
	;~ 	.AllowDeletingRows = 0
	;~ 	.AllowInsertingColumns = 0
	;~ 	.AllowInsertingRows = 0
	;~ 	.AllowSorting = 1
	;~ 	.Enabled = 1
	;~ 	
	;~ EndWith
	
	Else
	   MsgBox(0,"Reply","Not an Object",4)
   EndIf
   
EndFunc