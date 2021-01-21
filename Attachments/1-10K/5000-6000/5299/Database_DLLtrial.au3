#include <Array.au3>
#include <GuiConstants.au3>
#include <GUIListview.au3>
#Include <GuiTreeView.au3>
;#include "..\Arrays\2DArray.au3"
#include "SQLite.au3"
#include "CommonActions.au3"

opt("GUIOnEventMode", 1)
opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced
opt("MouseCoordMode", 0)        ;1=absolute, 0=relative, 2=client

; Initialize SvenP 's error handler
$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

;Set up the SQLite DLL
Global $DLL
Global $DBHandle
$DLL = @ScriptDir & "\sqlite3.dll"
_SQLite_Startup($DLL)
;$DLL = dllopen(@ScriptDir & "\sqlite3.dll")

;Get SQLite Version
$Version = _SQLite_LibVersion()
;$Version = SQLite_Version($DLL)

Global $ExcelLV
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
Global $StatusLabel
global $ErrorMsg

#region GUI CREATION
;GUI variables
$xBorderL = 9;distance from left side of gui
$xBorderR = 9;distance from right side of gui
$yBorderTier1 = 1;Tier 1 distance from top of gui
$yBorderTier2 = 415 ;Tier 2 distance from top of gui
$yBorderTier3 = 440 ;Tier 3 distance from top of gui
$yBorderTier4 = 735
$xSpacing = 5;distance between controls in the x dimension
$ySpacing = 5;distance between controls in the y dimension

$GUIWidth = 1000
$GUIHeight = 775
$GUIText = "SQLite GUI - v3"
$Main = GUICreate($GUIText, $GUIWidth, $guiheight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2,$ws_visible+$ws_clipsiblings+$WS_OVERLAPPEDWINDOW)
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

$StatusLabel = guictrlcreatelabel("",$xborderl-3,$ybordertier4,500,18,$SS_SUNKEN)
$DatabasePathLabel = guictrlcreatelabel("",$xborderl-3+500+$xspacing,$ybordertier4,$guiwidth-2*$xborderl-600,18,$SS_SUNKEN)

$VersionLabel = guictrlcreatelabel("SQLite v" & $Version,$xborderl-3+500+2*$xspacing+$guiwidth-2*$xborderl-600,$ybordertier4,95,18,$SS_SUNKEN)

$TabHeight = $GUIHeight - $yBorderTier2 - 23 - 18
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
;GUICtrlSetOnEvent($bNewP, "AddPart")

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
;GUICtrlSetOnEvent(-1, "VacuumDatabase")

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
;GUICtrlSetOnEvent($NewFieldButton, "NewFieldNewTable")

$NewFieldsLVHeight = 140
$NewFieldsLV = GUICtrlCreateListView("Name|Type", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight + $NewTableInputHeight + $NewFieldButtonHeight+$ySpacing, $Group1width-10, $NewFieldsLVHeight)

$NewTableButton = GUICtrlCreateButton("Create TABLE", $Group1ItemXStart, $Group1ItemYStart + $NewTableLabelHeight + $NewTableInputHeight + $NewFieldButtonHeight+$ySpacing+$NewFieldsLVHeight, 100, 23)
;GUICtrlSetOnEvent(-1, "NewTable")

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
;GUICtrlSetOnEvent(-1, "RenameTable")

$bTableDyStart = $bTableRYstart + $bTableRheight + $ySpacing
$bTableD = GUICtrlCreateButton("Delete Table", $bTableRxStart, $bTableDyStart, $bTableRwidth, $bTableRheight)
;GUICtrlSetOnEvent(-1, "DeleteTable")

$bFieldAyStart = $bTableDyStart + $bTableRheight + 5 * $ySpacing
$bFieldA = GUICtrlCreateButton("Insert Field", $bTableRxStart, $bFieldAyStart, $bTableRwidth, $bTableRheight)
;guictrlsetonevent(-1,"NewFieldExistingTable")
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
guictrlsetstate(-1, $gui_disable)

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
;GUICtrlSetOnEvent($bNewR, "AddRecord")

$bEditRHeight = $bNewRHeight + 11
$bEditR = GUICtrlCreateButton("Edit Selected Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $ySpacing, $bNewRWidth, $bEditRHeight, $BS_MULTILINE)
GUICtrlSetOnEvent($bEditR, "EditRecord")

$bDeleteR = GUICtrlCreateButton("Delete Record", $bNewRxStart, $bNewRyStart + $bNewRHeight + $bEditRHeight + 2 * $ySpacing, $bNewRWidth, $bNewRHeight)
;GUICtrlSetOnEvent(-1, "DeleteRecord")

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
guictrlsetstate(-1, $GUI_CHecked)

$AscendRadio = GUICtrlCreateRadio("Ascending (Z-A)", $RadioGroup1xStart + 5, $RadioGroup1yStart + 20 + $ySpacing+3, $RadioGroup1Width-15, 25)

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
;GUICtrlSetOnEvent(-1, "CreateIndex")

$bDeleteIndex = GUICtrlCreateButton("Delete Index", $cIndexComboXStart + 5, $bCreateIndexYstart + 23 + 3 * $ySpacing, $Group4width - 25, 23)
;guictrlsetonevent(-1,"DeleteIndex")

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
$bExcelIn = GUICtrlCreateButton("Excel Import New", $bExcelInxStart, $bExcelInyStart, $bExcelInWidth, $bExcelInHeight)
;GUICtrlSetOnEvent(-1,"XLSImportNew")

$bExcelIn2 = GUICtrlCreateButton("Excel Import Existing", $bExcelInxStart, $bExcelInyStart+30 +$ySpacing, $bExcelInWidth, $bExcelInHeight)
;GUICtrlSetOnEvent(-1,"XLSImportExisting")

$bExcelOutHeight = $bExcelInHeight
$bExcelOut = GUICtrlCreateButton("CSV Export", $bExcelInxStart, $bExcelInyStart + 2*$bExcelInHeight + 2*$ySpacing, $bExcelInWidth, $bExcelOutHeight, $BS_MULTILINE)
;GUICtrlSetState(-1, $gui_disable)

$cBeginner = GUICtrlCreateCheckbox("Beginner Mode", $bExcelInxStart, $bExcelInyStart + 3 * $bExcelInHeight + 3 * $ySpacing, $bExcelInWidth, 25)
;GUICtrlSetOnEvent(-1, "Beginner")

GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
GUICtrlCreateTabItem("")

$SQL_View = GUICtrlCreateTabItem("   SQL Entry   ")
#region ;SQL View Tab

$SQLinsertY = $yBorderTier2 + 30
$SQLlabelHeight = 20
$SQLinsertLabel = GUICtrlCreateLabel("Enter SQL Commands:", $xBorderL + 10, $SQLinsertY, 500, $SQLlabelHeight)
$SQLInsert = GUICtrlCreateInput("", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight, 500, 100,$ES_MULTILINE+$ES_WANTRETURN)

$SQLcommit = GUICtrlCreateButton("Process SQL", $xBorderL + 10, $SQLinsertY + $SQLlabelHeight + 110, 90, 24)
;GUICtrlSetOnEvent(-1, "CommitSQL")

$SQLcombo = GUICtrlCreateCombo("SELECTs",$xborderl+10+$xspacing+500,$SQLinsertY,100,$sqllabelheight)
GUICtrlSetData(-1,"VIEWs") ; add other item snd set a new default



#endregion
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW, $Main)
$MousePos = MouseGetPos ()
$tmp = wingetpos($GUIText)
mouseclick("left",$tmp[0]+210,$tmp[1]-45,1,0)
mousemove($MousePos[0],$mousepos[1],0)

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
	_SQLite_Close($DBhandle)
	guictrlsetdata($StatusLabel,"")
	
	;If the database is being refreshed you dont ask for a path
	If $DBPath1 = "" Then
		$DBPath = FileOpenDialog("New or Existing Database...", "C:\Kevin\AutoItScripts\PartsDatabase", "DB (*.db)")
		
		;Ensure the .db extension is applied
		If StringRight($DBPath, 3) <> ".db" and $dbpath <> "" Then
			$DBPath = $DBPath & ".db"
		EndIf
	ElseIf $DBPath1 <> "" Then
		$DBPath = $DBPath1
	EndIf
	
	if $dbpath <> "" Then
		;Open the database file (creates it if it does not exist)
		$DBhandle = _SQLite_Open($dbpath)
		
		;Put database path into the path inputbox
		GUICtrlSetData($InputDBPath, $DBPath)
		GUICtrlSetData($DatabasePathLabel,"Current Database: " &  $DBPath)
		
		;Reset Grid (ListView or Excel Grid)
		guisetstate(@SW_LOCK)
		if $UseExcelLV = false Then
			_GUICtrlListViewDeleteAllItems($TreeDB)
		Else
			ResetGrid($ExcelLV,$LastNumOfHeadings,$LastNumOfRows)
			
		EndIf
		_GUICtrlTreeViewDeleteAllItems($TreeDB)
		guisetstate(@sw_unlock)
		
		;Find all Tables and columns and put them in TableNames for easy reference
		$ResultRows = 0
		$ResultCols = 0
		$TableNames = GetTableNames($DBHandle)
 
		$HaveLog = False
		
		if Not isarray($TableNames) then
			GUICtrlSetData($StatusLabel,"Error Getting Table Names: " &  $tablenames)
		Else
			GUISetState(@SW_LOCK)
			for $Count = 1 to ubound($TableNames,2)-1
				$FirstIndex = True
				$FirstMisc = True
				
				;Check for log table
				if $TableNames[0][$Count] = "z_LOG" Then $HaveLog = True
				
				
				;Put each table in the treeview
				$CurTree = GUICtrlCreateTreeViewItem($TableNames[0][$Count],$TreeDB)
				GUICtrlSetOnEvent($CurTree, "TreeDBTableClick")
				
				
				;Get field names and types, and put them below the table name
				$TempData = GetFieldNames($DBhandle,$tablenames[0][$count])
				
				if not isarray($tempdata) Then
					GUICtrlSetData($StatusLabel,"Error Getting Field Names: " &  $tempdata)
				else					
					for $Count1 = 0 to ubound($tempdata,2)-1
						GUICtrlCreateTreeViewItem($tempdata[0][$Count1] & " " & $tempdata[1][$Count1],$CurTree)
					Next
				EndIf
				
				;Get all indexes for the current table.
				$SQL = "SELECT name,sql FROM sqlite_master WHERE type='index' AND tbl_name ='" & $tablenames[0][$count] & "'"
				$TempRows = 0
				$TempCols = 0
				dim $Indexes =0
				$Error = _SQLite_GetTable($DBHandle, $SQL, $Indexes, $TempRows, $TempCols, $ErrorMsg)
				
				if not isarray($Indexes) Then
					if $indexes <> "" Then
						;GUICtrlCreateTreeViewItem($tempdata[0][$Count1] & " " & $tempdata[1][$Count1],$CurTree)
					EndIf
				Else	
					for $Count1 = 1 to ubound($Indexes,2)-1
						if stringinstr($Indexes[1][$Count1],"CREATE INDEX") Then 
							if $FirstIndex = True Then
								$IndexItem = GUICtrlCreateTreeViewItem("Indexes",$CurTree)
							EndIf
							GUICtrlCreateTreeViewItem($Indexes[1][$Count1],$IndexItem)
							$FirstIndex = False
						Else
							if $FirstIndex = True Then
								$IndexItem = GUICtrlCreateTreeViewItem("Indexes",$CurTree)
							EndIf							
							GUICtrlCreateTreeViewItem($Indexes[0][$Count1],$IndexItem)							
							$FirstIndex = False
						EndIf
					Next
				EndIf
	
				;Get all misc stuff for the current table
				$SQL = "SELECT name,sql FROM sqlite_master WHERE type<>'index' AND type<>'table' AND tbl_name='" & $tablenames[0][$count] & "'"
				dim $Misc = 0
				$Error = _SQLite_GetTable($DBHandle, $SQL, $Misc, $TempRows, $TempCols, $ErrorMsg)
				
				if not isarray($Misc) Then
					if $Misc <> "" Then
						GUICtrlCreateTreeViewItem($tempdata[0][$Count1] & " " & $tempdata[1][$Count1],$CurTree)
					EndIf
				Else	
					$IndexItem = GUICtrlCreateTreeViewItem("Indexes",$CurTree)
					
					for $Count1 =1 to ubound($Misc,2)-1
						if $FirstMisc = True Then
							$IndexItem = GUICtrlCreateTreeViewItem("Misc",$CurTree)
						EndIf
						GUICtrlCreateTreeViewItem($Misc[1][$Count1] & " | " & $Misc[0][$Count1],$IndexItem)
						$FirstMisc = False
					Next
				EndIf
				
			Next
			guisetstate(@sw_unlock)		
			
			if $HaveLog = false Then
				$SQL = "CREATE TABLE z_LOG(TimeStamp TEXT DEFAULT CURRENT_TIMESTAMP , Type TEXT , Comment TEXT , SQLEntry TEXT)"

				$Error = _SQLite_Exec($dbhandle, $SQL, $ErrorMsg)
				if $Error <> 0 Then
					GUICtrlSetData($StatusLabel,"Error Creating Log: " &  $Error)
				Else
					$error = _SQLite_Exec($dbhandle, "INSERT INTO z_LOG(SQLEntry, Type, Comment) VALUES('" & $SQL & "' , 'CREATE TABLE' , 'Initialize Log Table')", $ErrorMsg)
					if $Error <> 0 Then
						GUICtrlSetData($StatusLabel,"Error Inserting Into Log: " &  $Error)					
					EndIf
				EndIf
			EndIf		
		endif
	EndIf
EndFunc   ;==>OpenDatabase

Func TreeDBTableClick()
	Dim $GetFieldNames
	Dim $Data1 = ""
	guisetstate(@sw_lock)
	
	;Get the current selected table from the TreeView
	$ItemID = _GUICtrlTreeViewItemGetTree ($GUIText, $TreeDB, "|")
	$TempArray = StringSplit($ItemID, "|")
	
	;Store the Current Table for future reference
	If $TempArray[1] <> "" Then
		
		$CurTable = $TempArray[1]
		
		;Get field names so you can put them at the top of the ListView control
		$FieldNames = GetFieldNames($DBHandle, $CurTable)
		
		;_displayarray($fieldnames)
			
		if Not IsArray($fieldnames) Then
			GUICtrlSetData($DatabasePathLabel,"Error Getting Table Fields: " &  $FieldNames)
		Else
			;We want the first column of the listview to be the interanal SQLite rowid
			$Data1 = "RowID*"
			
			;Generate the new header columns for the ListView
			For $Count = 0 To ubound($fieldnames,2) - 1
				
				;Column Name
				$Data1 = $Data1 & "|" & $fieldnames[0][$Count]
					
				If StringInStr($fieldnames[1][$Count], "PRIMARY KEY", 1) <> 0 Then
					$Data1 = $Data1 & "*"
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
				with $ExcelLV
					ResetGrid($ExcelLV,$LastNumOfHeadings,$LastNumOfRows)
					
					$TempColHeadings = stringsplit($data1,"|",1)
					
					if $lastnumofrows = 0 Then $lastnumofrows = 1
					
					$LastNumOfHeadings = $tempcolheadings[0]
					
					for $HeaderCount = 1 to $TempColHeadings[0]
						.activewindow.columnheadings($HeaderCount).caption = $TempColHeadings[$HeaderCount]
						.columns($HeaderCount).autofit
					Next
				EndWith
			EndIf
			guisetstate(@sw_unlock)
			
			;Grab all data from database table and display in ListView			
			guictrlsetdata($StatusLabel,"Getting Data... ")
			guisetstate(@sw_lock)
			
			$SQL = "SELECT rowid,* FROM " & $CurTable & " ORDER BY rowid"
			
			SQLite_ToGrid($DLL, $DBhandle, $ExcelLV, $SQL, $lastnumofrows,$LastNumOfHeadings,True,$StatusLabel)
			
			guictrlsetdata($StatusLabel,"Table '" & $curtable & "' Displayed with " & $lastnumofrows-1 & " rows")
		EndIf
	EndIf
	guisetstate(@SW_UNLOCK)
EndFunc   ;==>TreeDBTableClick

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
			
			$CurRow = $ExcelLV.selection.row
			$curlistindex = $ExcelLV.cells($currow,1).value	
			
			if $currow < 1 then
				msgbox(0, "Select Record", "You need to select a record before choosing this action.")
			Else
				;Pull record from database so that numbers aren't screwed up by Excel
				$Dummy = 0
				dim $Record = 0 
				
				$TempRows = 0
				$TempCols = 0
				$SQL = "SELECT * FROM " & $CurTable & " WHERE rowid=" & $CurListIndex
				
				_SQLite_GetTable($dbhandle, $SQL, $Record, $TempRows, $TempCols, $ErrorMsg)
				
				if not isarray($record) then
					guictrlsetdata($StatusLabel,"Error getting record to edit: " & $record)
				Else
					for $cCount = 0 to ubound($record,1)-1
						$CurRecord[$cCount+1] = $record[$ccount][1]
					Next
				EndIf
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
	
	For $Count = 0 To UBound($FieldNames, 2) - 1
		If StringInStr($FieldNames[1][$count], "PRIMARY") = 0 Then
			$TempData = GUICtrlRead($InputBoxes[$Count])
			

			$Numerical = number($tempdata)
			
			if stringlen($Numerical) = stringlen($tempdata) Then						
				if $tempdata <> "0" and $numerical = 0 Then
					$tempdata = "'" & $TempData & "'"						
				Else
					if stringleft($tempdata,1) == 0 Then $tempdata = "''" & $tempdata
				EndIf

			Else
				if stringleft($tempdata,1) == 0 Then $tempdata = "''" & $tempdata
				$TempData = stringreplace($tempdata,"'","''")
				$TempData = "'" & $TempData & "'"
			EndIf

			$ColumnData = $ColumnData & " , " & $FieldNames[0][$Count] & "=" & $TempData
		Else
			$PriKey = $FieldNames[$Count][0]
			$PriNum = $CurListIndex
			$KeyFound = True
		EndIf
	Next
		
	GUIDelete($RecordGUI)

	If $KeyFound = False Then
		$PriNum = $CurListIndex
		$PriKey = "rowid"
	EndIf
	
	$ColumnData = StringTrimLeft($ColumnData, 3)

	$SQL = "UPDATE " & $CurTable & " SET " & $ColumnData & " WHERE " & $PriKey & "= " & $PriNum

	$Error = _SQLite_Exec($DBhandle, $SQL, $ErrorMsg)
	
	if $error = 0 Then
		guictrlsetdata($StatusLabel,"")
		TreeDBTableClick()
	Else
		guictrlsetdata($StatusLabel,"Error Editing Record: " & $error)			
	EndIf
	
	
EndFunc   ;==>RecordEdit

Func DisplayRecGUI($rgRecord = "")
	$rgXborder = 5
	$rgYborder = 20
	$LabelMaxWidth = 0
	
	$FieldCount = 0
	
	Dim $InputBoxes[UBound($FieldNames, 2) ]
	
	;Find the max number of characters in a label, this will help determine the width of
	; the GUI
	For $FieldCount = 0 To UBound($FieldNames, 2) - 1
		If $LabelMaxWidth < StringLen($FieldNames[0][$FieldCount]) Then
			$LabelMaxWidth = StringLen($FieldNames[0][$FieldCount])
		EndIf
	Next
	
	;pixels per character seems about right for width
	$LabelMaxWidth = $LabelMaxWidth * 6
	
	;Set up and make the GUI
	$RecordGUIheight = UBound($FieldNames, 2) * 25 + 75
	$RecordGUIwidth = (Ceiling(UBound($FieldNames, 2) / 15)) * ($LabelMaxWidth + 150 + 20)
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
	
	For $FieldCount = 0 To UBound($FieldNames, 2) - 1
		if $fieldcount = 16 Then
			$LabelXStart = $rgXborder + $LabelMaxWidth + 150 + 3*$xspacing
			$InputXStart = $rgXborder + 2* $LabelMaxWidth + 150 + 2*$xspacing +10
			$rgYborder = 20
		EndIf
		
		GUICtrlCreateLabel($FieldNames[0][$FieldCount], $LabelXStart, $rgYborder+2, $LabelMaxWidth, 20,$SS_RIGHT )
		
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
		
		If StringInStr($FieldNames[1][$FieldCount], "PRIMARY") Then
			GUICtrlSetState($InputBoxes[$FieldCount], $gui_disable)
		EndIf
		
		If StringInStr($FieldNames[1][$FieldCount], "DEFAULT") Then
			GUICtrlSetState($InputBoxes[$FieldCount], $gui_disable)
		EndIf
		$rgYborder = $rgYborder + 25
		
	Next
	
	GUISetState(@SW_SHOW, $RecordGUI)
	
EndFunc   ;==>DisplayRecGUI

Func AllowDefaults()
	$Checked = GUICtrlRead($rgAllowDefaults)
		
	If $Checked = $GUI_CHecked Then
		for $count = 0 to ubound($InputBoxes)-1
			if StringInStr($FieldNames[1][$count],"PRIMARY KEY",1) = 0 Then
				GUICtrlSetState($inputboxes[$count],$GUI_ENABLE)
			EndIf
		Next
	ElseIf $Checked = $gui_unchecked Then
		for $count = 0 to ubound($InputBoxes)-1
			if StringInStr($FieldNames[1][$count],"PRIMARY KEY",1) = 0 and StringInStr($fieldnames[1][$count],"DEFAULT",1) <> 0 Then
				GUICtrlSetState($inputboxes[$count],$GUI_DISABLE)
			EndIf
		Next
	EndIf
EndFunc   ;==>AllowDefaults

Func ChildGUIDelete()
	GUIDelete($RecordGUI)
EndFunc   ;==>ChildGUIDelete

Func InsertRecord()
;This function inserts the new record into the database.

	$NewRecord = ""
	Dim $ColumnNames = ""
	Dim $ColumnData = ""
	
	;Build the list of columns and the list of values for the SQL statment
	For $FieldCount = 0 To UBound($InputBoxes) - 1
		
		;If the field is a PRIMARY KEY it won't get updated and doesn't need to be in the SQL Statement.
		If StringInStr($FieldNames[1][$FieldCount], "PRIMARY KEY") Then
			$ColumnNames = $ColumnNames & "," & $FieldNames[0][$FieldCount]
			$ColumnData = $ColumnData & "," & "null"
			
		;If the user has left the inputs empty, either there is no information or the field has a default value
		;	If there is no information add a space so that nothing appears.  If it is a default, do nothing.
		ElseIf GUICtrlRead($InputBoxes[$FieldCount]) = "" Then
			If StringInStr($FieldNames[1][$FieldCount], "DEFAULT") = 0 Then
				$ColumnNames = $ColumnNames & "," & $FieldNames[0][$FieldCount]
				$ColumnData = $ColumnData & ",' '"
			EndIf
		
		;A normal field gets updated with the user input text.
		Else
			$TempData = GUICtrlRead($InputBoxes[$FieldCount])
			
			if $TempData == 0 then
				if number($tempdata) <> "" Then
					$columndata = $columndata & " , " & 0
				Else
					$columndata = $columndata & " ,' ' "	
				EndIf
			Else
				$Numerical = number($tempdata)
				
				if stringlen($Numerical) = stringlen($tempdata) Then						
					if $tempdata <> "0" and $numerical = 0 Then
						$columndata = $columndata & " , '" & $TempData & "'"						
					Else
						if stringleft($tempdata,1) == 0 Then $tempdata = "''" & $tempdata
						$columndata = $columndata & " , " & $TempData
					EndIf
	
				Else
					if stringleft($tempdata,1) == 0 Then $tempdata = "''" & $tempdata
					$TempData = stringreplace($tempdata,"'","''")
					$columndata = $columndata & " , '" & $TempData & "'"
				EndIf
			EndIf
			
			$ColumnNames = $ColumnNames & "," & $FieldNames[0][$FieldCount]
		EndIf
	Next
	
	GUIDelete($RecordGUI)
	
	;Clean up the column names and values
	$ColumnNames = StringTrimLeft($ColumnNames, 1)
	While StringLeft($ColumnData, 3) = " , "
		$ColumnData = StringTrimLeft($ColumnData, 3)
	WEnd
	
	;Insert the data into the database
	$SQL= "INSERT INTO " & $CurTable & "(" & $ColumnNames & ") VALUES( " & $ColumnData & ")"
	$error = _SQLite_Exec($dbhandle, $SQL, $ErrorMsg)
	if $error = 0 Then
		guictrlsetdata($StatusLabel,"")
		TreeDBTableClick()
	Else
		guictrlsetdata($StatusLabel,"Error Inserting Record: " & $error)			
	EndIf
	
EndFunc   ;==>InsertRecord









Func RefreshDatabase()
	If FileExists($DBPath) Then
		OpenDatabase($DBPath)
	Else
		MsgBox(0, "No Database open", "You have not yet opened a database... you can't refresh it.")
	EndIf
EndFunc   ;==>RefreshDatabase

Func GUIevent()
	_SQLite_Shutdown()
	Exit
EndFunc   ;==>GUIevent

Func ButtonOpenDB()
	OpenDatabase("")
EndFunc   ;==>ButtonOpenDB

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
	;if RegRead("HKCR\OWC9.spreadsheet","") then $ExcelLV = ObjCreate("OWC9.spreadsheet")
	if RegRead("HKCR\OWC10.spreadsheet","") then $ExcelLV = ObjCreate("OWC10.spreadsheet")
	if RegRead("HKCR\OWC11.spreadsheet","") then $ExcelLV = ObjCreate("OWC11.spreadsheet")
	
	;$ExcelLV = ObjCreate("OWC10.spreadsheet"); Office XP
	;If not IsObj($ExcelLV) Then    
	;$ExcelLV = ObjCreate("OWC9.spreadsheet"); Office 2000
	;EndIf
	;if not isobj($ExcelLV) then
	;	$ExcelLV = ObjCreate("OWC11.spreadsheet"); Office 2003
	;EndIf
	
	If IsObj($ExcelLV) Then
		with $ExcelLV
			.AllowPropertyToolbox = True
			.DisplayOfficeLogo = false
			.DisplayPropertyToolbox = False 
			.DisplayTitleBar = False 
			.DisplayToolbar = False
			;.ViewOnlyMode = True
			;.autofit = True
			;.Maxwidth = 1000
			;.Maxheight = 1000
		EndWith

		With $ExcelLV.ActiveWindow
			.DisplayGridlines = True
			.DisplayHorizontalScrollBar = True
			.DisplayVerticalScrollBar = True
			.DisplayColumnHeadings = True
			
			.DisplayRowHeadings = False    
			.DisplayWorkbookTabs = False        
			.EnableResize = false
		EndWith
		
		$owcWbook = $ExcelLV.ActiveWorkbook
		$owcWSheet=$owcWbook.ActiveSheet
		
		$GUI_ActiveX = GUICtrlCreateObj($ExcelLV,265,1,730,415) 	
		guictrlsetstyle(-1,$ws_visible)
		GUICtrlSetResizing($GUI_ActiveX,$gui_dockAuto)
		;$ExcelLV.activesheet.rows(2).Select
		;$ExcelLV.ActiveWindow.FreezePanes = True	
		;$owcwsheet.cells(2,1).Select
		
		$TempHeadingArray = stringsplit($col_names,"|")

	with $ExcelLV
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
	   MsgBox(0,"Reply","You don't appear to have the office web components installed. If you are using Office 2000, the components do not support spreadsheets. Sorry.",4)
   EndIf
   
EndFunc
