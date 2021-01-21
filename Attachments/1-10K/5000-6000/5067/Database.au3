#include <Array.au3>
#include <GuiConstants.au3>
#include <GUIListview.au3>
#Include <GuiTreeView.au3>

;#include "F:\Settings\AutoIt-Scripts\Database\DatabaseActions.au3"

opt ("GUIOnEventMode", 1)
opt ("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced
Opt ("MouseCoordMode", 0)        ;1=absolute, 0=relative, 2=client

; Initialize SvenP 's error handler
$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

;Set up the database object
Global $oDb
$oDb = ObjCreate( "LiteX.LiteConnection")

global $CurTree
global $TreeVDB
global $DBPath
global $RecordGUI
Global $FieldNames
Global $New
global $InputBoxes
Global $CurTable
;MsgBox(0, "Feedback", "Hello from SQLite version" & $oDb.Version & "!")

;GUI variables
$xBorderL = 7;distance from left side of gui
$xBorderR = 7;distance from right side of gui
$yBorderTier1 = 1;Tier 1 distance from top of gui
$yBorderTier2 = 30 ;Tier 2 distance from top of gui
$yBorderTier3 = 400;Tier 3 distance from top of gui
$xSpacing = 5;distance between controls in the x dimension
$ySpacing = 5;distance between controls in the y dimension

$GUIWidth = 1000
$GUIHeight = 710
$Main = GUICreate("Parts Database - 04 NOV 05", $GUIWidth, $guiheight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIevent") ;This line tells the GUI to close when the "X" is clicked

$Helpmenu = GUICtrlCreateMenu("?")
$Helpitem = GUICtrlCreateMenuItem("Help", $Helpmenu)
$Infoitem = GUICtrlCreateMenuItem("Info", $Helpmenu)

;Tier 1------------------------------------------
$Tab = GUICtrlCreateTab(5, $yBorderTier1, $GUIWidth - 5 - 5, $guiheight-$ybordertier1-25)

;End Tier 1

$Tab_View = GUICtrlCreateTabItem("Database View")

#region ;Database View Tab

;Tier 2------------------------------------------
$TreeWidth = 250
$TreeHeight = 350
$ComboHeight = 20

$Tree = GUICtrlCreateTreeView($xBorderL, $yBorderTier2 + $ComboHeight + $ySpacing, $TreeWidth, $TreeHeight)

$Combo = GUICtrlCreateCombo("ComboBox", $xBorderL, $yBorderTier2, $TreeWidth, $ComboHeight)

$ListViewWidth = $GUIWidth - ($xBorderL + $TreeWidth + $xSpacing + $xBorderR)
$ListViewHeight = $TreeHeight + $ComboHeight + $ySpacing
$ListView = GUICtrlCreateListView("1|2|3|4", $xBorderL + $TreeWidth + $xSpacing, $yBorderTier2, $ListViewWidth, $ListViewHeight)
;End Tier Two

;Tier 3-------------------------------------------

$bNewPwidth = 100
$bNewPHeight = 100
$bNewP = GUICtrlCreateButton("New Part", $GUIWidth - ($bNewPwidth + $xBorderR), $yBorderTier3, $bNewPwidth, $bNewPHeight)
GUICtrlSetOnEvent($bNewP, "AddPart")

;End Tier 3
#endregion
;GUICtrlCreateTabItem("")


$Tab_Database = GUICtrlCreateTabItem("Database")
GUICtrlSetState(-1, $GUI_SHOW)
#region
$InputDBheight = 20
$InputDBwidth = 250
$InputDBPath = guictrlcreateinput("",$xborderl,$ybordertier2,$inputdbwidth,$inputdbheight)

$TreeDBwidth = $inputdbwidth
$TreeDBheight = 350
$TreeDB = GUICtrlCreateTreeView($xBorderL, $ybordertier2+$inputdbheight+$yspacing, $TreeDBwidth, $TreeDBheight)
GUICtrlCreateTabItem("")

$bNewDwidth = 100
$bNewDHeight = 100
$bNewD = GUICtrlCreateButton("Open Database", $GUIWidth - ($bNewDwidth + $xBorderR), $yBorderTier3+10, $bNewDwidth, $bNewDHeight)
GUICtrlSetOnEvent($bNewD, "OpenDatabase")

$bNewR = GUICtrlCreateButton("New Record", $GUIWidth - ($bNewDwidth + $xBorderR+150+150), $yBorderTier3+10, $bNewDwidth, $bNewDHeight)
GUICtrlSetOnEvent($bNewR, "NewRecord")

$bEditR = GUICtrlCreateButton("Edit Record", $GUIWidth - ($bNewDwidth + $xBorderR+150), $yBorderTier3+10, $bNewDwidth, $bNewDHeight)
GUICtrlSetOnEvent($bEditR, "EditRecord")

$ListVDBxPos = $inputdbwidth+$xborderl+$xspacing
$ListVDB = guictrlcreatelistview("Field Names...",$ListVDBxPos,$ybordertier2,$GUIWidth-$listvdbxpos-$xborderr,$treedbheight+$yspacing+$inputdbheight,$LVS_SHOWSELALWAYS+$LVS_SINGLESEL,$LVS_EX_GRIDLINES+$LVS_EX_FULLROWSELECT)

$Group1Ystart = $ybordertier3+$yspacing+10
$Group1Xstart = $xborderl+5
$Group1width = 210
guictrlcreategroup("Create New Table",$Group1Xstart,$Group1Ystart, $Group1Width, $guiheight-$group1ystart-35)

$NewTableLabelHeight = 20
$Group1ItemYStart = $group1ystart+20
GUICtrlCreateLabel("Table Name:",$group1xstart+5,$group1itemystart,100,$NewTableLabelHeight)
$NewTableInput = guictrlcreateinput("",$group1xstart+5,$group1itemystart+$NewTableLabelHeight-5,200,21)

$NewFieldButton = GUICtrlCreateButton("New FIELD",$group1xstart+5,$group1itemystart+$newtablelabelheight-5+21+5,200,21)
GUICtrlSetOnEvent($newfieldbutton,"CreateNewField")

$NewFieldsLV = GUICtrlCreateListView("Name|Type",$group1xstart+5,$group1itemystart+$newtablelabelheight-5+21+5+21+5,200,140)

$NewTableButton = GUICtrlCreateButton("Create TABLE",$group1xstart+5,$group1itemystart+$newtablelabelheight-5+21+5+21+5+140+5,200,20)
guictrlsetonevent(-1,"NewTable")

#endregion
GUICtrlCreateTabItem("")


GUISetState(@SW_SHOW, $Main)
While 1
	Sleep(8000)
WEnd
Exit


Func OpenDatabase($dbpath="")
	
	Dim $oStmt
	Dim $GetIndices
	dim $GetFieldNames
	dim $GetTableNames
	
	$odb.close();
		if $dbpath = "" Then
		$dbPath = FileOpenDialog("New or Existing Database...", "C:\Kevin\AutoItScripts\PartsDatabase", "DB (*.db)")
		If StringRight($dbPath, 3) <> ".db" Then
			$dbPath = $dbPath & ".db"
		EndIf
	EndIf
	;if $dbpath <> GUICtrlRead($inputdbpath) Then
		guictrlsetdata($inputdbpath,$dbpath)
		
		_GUICtrlTreeViewDeleteAllItems($treedb)
		
		$oDb.Open ($dbPath);Open the DB file
		
		;Find all Tables and columns and put them on the Tree Control for easy reference
		$GetTableNames = $odb.prepare ("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
		
		$Data = ""
		
		; $Param = $oStmt.ParameterCount()
		While $GetTableNames.step () = 0
			$Data = $GetTableNames.ColumnValue (0)
			
			$CurTree = GUICtrlCreateTreeViewItem($Data, $TreeDB)
			GUICtrlSetOnEvent(-1,"TreeDBTableClick")
			
			
			$GetFieldNames = $oDb.Prepare ("SELECT * FROM " & $Data)
			
			$ColumnCount = $GetFieldNames.columncount
			
			$GetFieldType = $odb.prepare("SELECT sql FROM sqlite_master WHERE tbl_name='" & $data & "'")
			
			;This grabs the CREATE statement for the current table
			while $getfieldtype.step()=0
				$Type = $getfieldtype.columnvalue(0)
			WEnd
			
			dim $fieldnames[$columncount][$columncount]
			
			For $Count = 0 To $ColumnCount - 1
				;Column Name
				$Data1 = $GetFieldNames.columnname ($Count)
				$Fieldnames[$count][0] = $data1
				
				;Column Type
				$TempArray = StringSplit($type,"(",1)
				$TempArray = stringsplit($Temparray[2],",",1)
				$ColType = StringStripWS(StringReplace($temparray[$count+1] & " ",$Data1, ""),3)
				if stringright($coltype,1) = ")" then $Coltype = stringleft($coltype,stringlen($coltype)-1)
				
				;Put Column name and Column Type in the Tree
				GUICtrlCreateTreeViewItem($Data1 & "  " & $ColType, $CurTree)
				$Data1 = ""
				$data2 = ""
			Next
		WEnd
	;Else
	;	msgbox(0,"","This database is already open!")
	;EndIf
	
EndFunc   ;==>OpenDatabase

Func TreeDBTableClick()
	dim $GetFieldNames
	dim $Data1=""
	
	$ItemID = GUICtrlRead($treedb)
	$ItemText = GUICtrlRead($itemid, 1)
	
	;Get field names and put them at the top of the ListView control
	$GetFieldNames = $oDb.Prepare ("SELECT * FROM " & $ItemText[0])
	
	$ColumnCount = $GetFieldNames.columncount
	
	
	dim $FieldNames[$columncount][$columncount]
	
	For $Count = 0 To $ColumnCount - 1
		;Column Name
		$Data1 = $Data1 & "|" & $GetFieldNames.columnname ($Count)
		$FieldNames[$count][0] = $getfieldnames.columnname($count)
		
		$GetFieldType = $odb.prepare("SELECT sql FROM sqlite_master WHERE tbl_name='" & $itemtext[0] & "'")
		
		;This grabs the CREATE statement for the current table
		while $getfieldtype.step()=0
			$Type = $getfieldtype.columnvalue(0)
		WEnd
		
		;Column Type
		$TempArray = StringSplit($type,"(",1)
		$TempArray = stringsplit($Temparray[2],",",1)
		$ColType = StringStripWS(StringReplace($temparray[$count+1] & " ",$Data1, ""),3)
		if stringright($coltype,1) = ")" then $Coltype = stringleft($coltype,stringlen($coltype)-1)
		
		$Type1 = ""
		
		$Temparray = stringsplit($coltype," ")
		for $TypeCount = 1 to $temparray[0]
			$Type1 = $Type1 & " " & $temparray[$Typecount]
		Next
		
		$type = StringTrimLeft($type1,1)
		
		$fieldnames[$count][1] = $type1
	Next
	
	guictrldelete($listvdb)
	if stringleft($data1,1) = "|" then $data1 = stringtrimleft($data1,1)
	$ListVDB = guictrlcreatelistview($data1,$ListVDBxPos,$ybordertier2,$GUIWidth-$listvdbxpos-$xborderr,$treedbheight+$yspacing+$inputdbheight,$LVS_SHOWSELALWAYS+$LVS_SINGLESEL,$LVS_EX_GRIDLINES+$LVS_EX_FULLROWSELECT)

	;Grab all data in table and display in ListView	
	$TableData = $oDb.Prepare ( "SELECT * FROM " & $itemtext[0] & " ORDER BY " & $fieldnames[0][0])
	$curtable = $itemtext[0]
	While $tabledata.step () = 0
		$Data = ""
		for $Count = 0 to $ColumnCount - 1 
			$Data = $Data & "|" & $tabledata.ColumnValue($count)
		Next
		if stringleft($data,1) = "|" then $data = stringtrimleft($data,1)
		$ListItemTableData = GUICtrlCreateListViewItem($Data, $ListVDB)
	WEnd
	$TableData.Close ();
	
EndFunc

Func NewTable()
	$FieldParamStr = ""
	if not fileexists($dbpath)  Then
		msgbox(0,"DB does not exist","There is no database to add that table to.")
	elseif guictrlread($NewTableInput) = "" Then
		msgbox(0,"No Table Name","Please insert a tablename.")
	Else
		$TableName = guictrlread($NewTableInput)
		for $LVcount = 0 to _GUICtrlListViewGetItemCount($newfieldslv)-1
			$LVdata = _GUICtrlListViewGetItemText($newfieldslv, $lvcount)
			
			$Temparray = stringsplit($lvdata,"|")
			$FieldParamStr = $fieldparamstr & "," & " " & $Temparray[1] & " " & $Temparray[2]
		Next
		
		$fieldparamstr = stringtrimleft($fieldparamstr,2)
		
		if stringinstr($fieldparamstr,"PRIMARY KEY") Then
			$oDb.Execute("CREATE TABLE " & $TableName & " (" & $fieldparamstr & ")")
			OpenDatabase($dbpath)
		Else
			msgbox(0,"Need PRIMARY KEY datatype","Please insert a field with the PRIMARY KEY datatype.")
		EndIf
	EndIf
	
EndFunc   ;==>NewTable

func CreateNewField()
	$UserInput = InputBox("New Field...","Insert the new field name and it's parameters. For example: FName::Param1,Param2,Param3" & @cr & @cr & _
						"Parameters:" & @cr & _
						"0 = TEXT" & @cr & _
						"1 = NUMERIC" & @cr & _
						"2 = BLOB" & @cr & _
						"3 = INTEGER PRIMARY KEY","","",-1,220)
	$TempArray = stringsplit($userinput,"::",1)
	
	if $temparray[0]=2 Then
		$NewFName = $Temparray[1] & "|"
		$Parameters = stringsplit($temparray[2],",")
		
		for $PCount = 1 to $Parameters[0]
			Select 
				case $Parameters[$pcount] = 0
					$Parameters[$pcount] = "TEXT"
				case $Parameters[$pcount] = 1
					$Parameters[$pcount] = "NUMERIC"
				case $Parameters[$pcount] = 2
					$Parameters[$pcount] = "BLOB"
				case $Parameters[$pcount] = 3
					$Parameters[$pcount] = "INTEGER PRIMARY KEY"
				case Else
					msgbox(0,"Parameter Error","Please repick your parameters.")
			EndSelect
			$NewFName = $NewFName & " " & $Parameters[$pcount]	
		Next
		
		$NewFieldItem = GUICtrlCreateListViewItem($NewFName,$NewFieldsLV)
		GUIctrlSetOnEvent($newfielditem,"DeleteField")
	Else	
		msgbox(0,"Incorrect entry","Please reenter the data.  Don't forget the :: delimiter.")
	EndIf
EndFunc

func DeleteField()
	_GUICtrlListViewDeleteItemsSelected($newfieldslv)
EndFunc

Func NewRecord()
	$new = True
	editaddrecord()
EndFunc

func EditRecord()
	$new = False
	editaddrecord()
EndFunc

func EditAddRecord()
	if not FileExists($dbpath) Then
		msgbox(0,"","You need to open a valid database.")
	ElseIf not isarray($fieldnames) then
		msgbox(0,"Select a Table","Please select a table first.")
	Else
		$rgXborder = 5
		$rgYborder = 20
		$LabelMaxWidth = 0
		dim $RecordText[ubound($fieldnames,1)]
		$FieldCount = 0
		dim $InputBoxes[ubound($fieldnames,1)]
		for $fieldcount = 0 to UBound($fieldnames,1)-1
			if $labelmaxwidth < stringlen($fieldnames[$fieldcount][0]) Then
				$labelmaxwidth = stringlen($fieldnames[$fieldcount][0])
			EndIf
		Next

		if $new = false Then
			if _GUICtrlListViewGetSelectedCount($listvdb)>0 Then
				$Temp = _GUICtrlListViewGetItemText($listvdb)
				
				$RecordText = stringsplit($temp,"|")
			Else
				msgbox(0,"Select Record","Please select a record to edit.")
			EndIf
		EndIf
		
		
		$LabelMaxWidth = $labelmaxwidth * 7
		
		$RecordGUIheight = UBound($Fieldnames,1) * 25 + 50
		$RecordGUIwidth = (Ceiling(ubound($Fieldnames,1)/15))*($labelmaxwidth+150+20)
		
		$RecordGUI = guicreate("Edit/New Record",$RecordGUIwidth,$RecordGUIheight)
		GUISetOnEvent($GUI_EVENT_CLOSE, "ChildGUIDelete") ;This line tells the GUI to close when the "X" is clicked
		
		$rgClose = GUICtrlCreateButton("Insert",$recordguiwidth/2+5,$recordguiheight-25,80,20)
		GUICtrlSetOnEvent(-1,"InsertRecord")		
		
		$rgClose = GUICtrlCreateButton("Close",$recordguiwidth/2-85,$recordguiheight-25,80,20)
		GUICtrlSetOnEvent(-1,"ChildGUIDelete")
		
		for $FieldCount = 0 to ubound($Fieldnames,1)-1
			GUICtrlCreateLabel($fieldnames[$fieldcount][0],$rgXborder,$rgYborder,$LabelMaxWidth,20)
			if $new = false then 
				$Text = $RecordText[$fieldcount+1]
			Else
				$Text = ""
			EndIf
			
			$InputBoxes[$fieldcount] = GUICtrlCreateInput($Text,$rgxborder+$labelmaxwidth + 5,$rgyborder,150,20)
			;msgbox(0,"",$fieldnames[$fieldcount][1])
			if stringinstr($fieldnames[$fieldcount][1] ,"PRIMARY") Then
				guictrlsetstate($inputboxes[$fieldcount],$gui_disable)
			EndIf
			$rgYborder = $rgYborder + 25
			
		Next
		
		guisetstate(@sw_show,$RecordGUI)
	EndIf

EndFunc

Func InsertRecord()
	;msgbox(0,"",$new)
	$NewRecord = ""
	dim $ColumnNames = ""
	dim $ColumnData = ""
	
	for $Count = 0 to ubound($inputboxes)-1
		$NewRecord = $NewRecord & "|" & guictrlread($inputboxes[$count])
	Next

	if stringleft($NewRecord,1) = "|" then $NewRecord = stringtrimleft($NewRecord,1)
	
	if $new = True Then
		$ListItemTableData = GUICtrlCreateListViewItem($newrecord, $ListVDB)
		
		$TempRecord = StringSplit($newrecord,"|")
		
		$oDb.Execute ( "BEGIN TRANSACTION")
		; Insert values in the 
		$QuestionMarks = ""
		For $FieldCount = 1 To $temprecord[0]
			$ColumnNames = $Columnnames & "," & $fieldnames[$fieldcount-1][0]
			if stringinstr($fieldnames[$fieldcount-1][1],"PRIMARY") Then
				$ColumnData = $ColumnData & "," & "null"
			Else
				$ColumnData = $ColumnData & ",'" & $temprecord[$fieldcount] & "'"
			EndIf
			$QuestionMarks = $questionmarks & ",?"
		Next
		
		$Columnnames = stringtrimleft($columnnames,1)
		while stringleft($columndata,1) = ","
			$columndata = stringtrimleft($columndata,1)
		WEnd
		$questionmarks = "(" & stringtrimleft($questionmarks,1) & ")"
		
		;$oDb.Execute ( "INSERT INTO test( b, c, d ) VALUES (?,?,:three)", "Data:" & $i, Random(-10, 10, 1), Random(1, 10))
		;msgbox(0,"","INSERT INTO " & $CurTable & "(" & $columnnames & ") VALUES( " & $columndata & ")")
		$odb.execute("INSERT INTO " & $CurTable & "(" & $columnnames & ") VALUES( " & $columndata & ")")
		
		
		$oDb.Execute ( "COMMIT TRANSACTION")
	elseif $new = False Then
		
	EndIf
	
	GUIDelete($recordgui)
EndFunc

Func AddPart()
	MsgBox(0, "", "In the function!")
	
EndFunc   ;==>AddPart

func ChildGUIDelete()
	guidelete($recordgui)
endfunc	

Func GUIevent()
	Exit
EndFunc   ;==>GUIevent






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
