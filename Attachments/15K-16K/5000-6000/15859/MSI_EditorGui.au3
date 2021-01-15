; http://msdn2.microsoft.com/en-us/library/aa372865.aspx
; http://msdn2.microsoft.com/en-us/library/aa367810.aspx
; Run MSIEXEC /? for more info.

opt("GUIOnEventMode", 1)

;Includes
#include <GuiConstants.au3>
#include <GuiListView.au3>
#Include <GuiTreeView.au3>
#include <GuiTab.au3>
#include <Array.au3>
#NoTrayIcon

;Declare Vars
Dim $sPath, $DB, $ATab[1], $ATab2[1], $ATabT[1],  $TabFol, $TablesFields
Dim $Font ="Arial Bold"

Global $TreeView
Global Const $WM_NOTIFY = 0x004E
Global Const $DebugIt = 1
;Events
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)
Global Const $NM_RCLICK = ($NM_FIRST - 5)

Global Const $TVM_HITTEST = ($TV_FIRST + 17)


;Declare Objects
$WI = ObjCreate("WindowsInstaller.Installer")

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;-----------------------------------------  Main GUI ------------------------------------

$Gui = GuiCreate("MSI Editor v1.0", 975, 571,(@DesktopWidth-975)/2, (@DesktopHeight-571)/2 , _ 
$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIevent") ; Close GuiEvent

;Menu Controls
$Filemenu = GUICtrlCreateMenu("File")
$OpenDB = GUICtrlCreateMenuItem("Open/Create Database", $Filemenu)
GUICtrlSetOnEvent(-1,"OpenDB")
$CloseDB = GUICtrlCreateMenuItem("Close Database", $Filemenu)
GUICtrlSetOnEvent(-1,"CloseDB")

$Helpmenu = GUICtrlCreateMenu ("?")
$Helpitem = GUICtrlCreateMenuitem ("Help",$Helpmenu)
$Infoitem = GUICtrlCreateMenuitem ("Info",$Helpmenu)

;Combo Control
$cTabName=GUICtrlCreateCombo ("No Database Open", 10,6,160,40)

;Button Control
$cButton1=GUICtrlCreateButton ("Clear All Data",180,6,100,20)
GUICtrlSetOnEvent(-1,"ClearAllTables")
$cButton2=GUICtrlCreateButton ("Clear Table",290,6,100,20)
GUICtrlSetOnEvent(-1,"ClearTable")
$cButton3=GUICtrlCreateButton ("Embedded CAB's",400,6,100,20)
GUICtrlSetOnEvent(-1,"GetCABList")

;Tab Control
$Tab=GUICtrlCreateTab (175,30, 800,520)
GUICtrlSetResizing ($Tab,$GUI_DOCKAUTO)

;TreeView
$TreeView= GUICtrlCreateTreeView(8, 30, 165, 518, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, _
           $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
GUICtrlSetImage (-1, "mmcndmgr.dll",13)

$Menu = GUICtrlCreateContextMenu($TreeView)
$contexCut = GUICtrlCreateMenuitem("Cut", $Menu)
$contexCopy = GUICtrlCreateMenuitem("Copy", $Menu)
$contexPaste = GUICtrlCreateMenuitem("Paste", $Menu)

;Tab1
$Tab1=GUICtrlCreateTabitem ("Table Data ")

;ListView Control
$ListView = GUICtrlCreateListView("Table1|Table2|Table3|Table4|Table5|Table6|Table7", _
			180, 60, 790, 483,-1,$LVS_EX_HEADERDRAGDROP+$LVS_EX_FULLROWSELECT) ;Drag&Drop Columns
GUICtrlSetResizing ($Listview,$GUI_DOCKAUTO)
GUICtrlSetState($ListView,$GUI_FOCUS)
GUICtrlSetImage ($ListView, "objsel.dll",2) ;Set Icons for records
_GUICtrlListViewSetColumnWidth ($listview, 0,130) ;Set Column with

;Tab2
$Tab2=GUICtrlCreateTabitem ("SQL Entry ")
$SQLinsertLabel1 = GUICtrlCreateLabel("Enter SQL Commands:", 180, 60, 500, 20)
$SQLinsertLabel2 = GUICtrlCreateLabel("IMPORTANT Case Sensitive Syntax !! " & _
									   "Example : SELECT `Name`, `Type`, `Number` FROM `_Columns` WHERE `Table` = 'Property'", 180, 300, 700, 20)
$SQLInsert = GUICtrlCreateInput("", 180, 80, 500, 150,$ES_MULTILINE+$ES_WANTRETURN)

$Button4 = GUICtrlCreateButton("Process SQL - {F9}", 180, 250, 110, 24)
GUICtrlSetOnEvent(-1,"CommitSQL")
HotKeySet("{F9}", "CommitSQL")  

;Tab3
$Tab3=GUICtrlCreateTabitem ("Summary Info ")

$Listbox1 = GUICtrlCreateList("", 180, 70, 785, 325,"")
GUICtrlSetResizing ($Listview,$GUI_DOCKAUTO)
GUICtrlCreateLabel("MSI Details: ",180,55)
GUICtrlSetColor(-1,0xff0000) 										;Set Red color
GUICtrlSetFont (-1,7.5, 100, 4, $font)								;Set Font

GUICtrlSetState($Tab1,$GUI_SHOW) ; Show first Tab as default
GUICtrlSetState($ListView,$GUI_FOCUS) ;Set focus on the Excel Object

;GUI handling
;------------
GuiSetState()

;Register WM_NOTIFY  events
;GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")

While 1
	Sleep(100)
WEnd


;----------------------------- Main -------------------------------------------
Func OpenDB()
	Local $Rec, $TVdata, $TablesNames
	GuiSetState(@SW_LOCK)
	_GUICtrlTreeViewDeleteAllItems ($TablesNames)
	GuiSetState(@SW_UNLOCK)
	$sPath = FileOpenDialog("Select a MSI file...", @ScriptDir, "MSI (*.msi)")
	If $sPath = "" Then Return ; Exit
		$WISumInfo = $WI.SummaryInformation($sPath)
		$DB = $WI.OpenDatabase($sPath, 1)

;--------------------------- Get Tables --------------------------------------
	$View = $DB.OpenView("SELECT `Name` FROM _Tables")
    $View.Execute 

	$index = 1
    While 1
        $Rec = $View.Fetch
            If Not IsObj($Rec) Then ExitLoop 		  ; = Vbscript If Record Is Nothing 
				
            $sTable = $Rec.StringData(1)
		  
            If (StringLeft($sTable, 1) <> "_") Then   ;-- Don't load _validation table. it's just a copy of all tables combined.
			$TablesNames = GUICtrlCreateTreeViewitem($sTable, $Treeview)
				GUICtrlSetColor(-1, 0x0000C0)
				GUICtrlSetOnEvent($TablesNames,"TreeDBTableClick") ; Get TableData on Click
				
;--------------------------- Get Fields --------------------------------------
			  $ViewT = $DB.OpenView("SELECT `Name` FROM `_Columns` WHERE `Table` ='" & $sTable & "'")
			  $ViewT.Execute()
				While 1  
                  $RecT = $ViewT.Fetch
				  If Not IsObj($RecT) Then ExitLoop
					$Fields = $RecT.FieldCount
					For $i = 1 to $Fields
						$TVdata = $TVData & $RecT.StringData($i)
					Next
				$TablesFields = GUICtrlCreateTreeViewitem($TVdata, $TablesNames)
				$TVData = ""
				WEnd
				$ViewT.Close
		    EndIf
		$index += 1
      WEnd
    $View.Close
	
;----------------------------Summary info --------------------------------------------------
GUICtrlSetData($Listbox1,"# of Properties : " & $WISumInfo.PropertyCount ) 
GUICtrlSetData($Listbox1," ")
GUICtrlSetData($Listbox1,"Code page: " & $WISumInfo.Property(1) )
GUICtrlSetData($Listbox1, "Title: " & $WISumInfo.Property(2) )
GUICtrlSetData($Listbox1, "Subject: " & $WISumInfo.Property(3) )
GUICtrlSetData($Listbox1, "Author: " & $WISumInfo.Property(4) )
GUICtrlSetData($Listbox1, "Keywords: " & $WISumInfo.Property(5) )
GUICtrlSetData($Listbox1, "Comment: " & $WISumInfo.Property(6) )
GUICtrlSetData($Listbox1, "Template: " & $WISumInfo.Property(7) )
GUICtrlSetData($Listbox1, "Last Author: " & $WISumInfo.Property(8) )
GUICtrlSetData($Listbox1, "Revision number: " & $WISumInfo.Property(9) )
GUICtrlSetData($Listbox1, "Edit Time: " & $WISumInfo.Property(10) )
GUICtrlSetData($Listbox1, "Last Printed: " & $WISumInfo.Property(11) )
GUICtrlSetData($Listbox1, "Creation Date: " & $WISumInfo.Property(12) )
GUICtrlSetData($Listbox1, "Last Saved: " & $WISumInfo.Property(13) )
GUICtrlSetData($Listbox1, "Page Count: " & $WISumInfo.Property(14) )
GUICtrlSetData($Listbox1, "Word Count: " & $WISumInfo.Property(15) )
GUICtrlSetData($Listbox1, "Character Count: " & $WISumInfo.Property(16) )
GUICtrlSetData($Listbox1, "Application Name: " & $WISumInfo.Property(18))
GUICtrlSetData($Listbox1, "Security: " & $WISumInfo.Property(19) )
	
;---------------------------- sort out tables and columns. ----------------------------------  
    For $y in $ATab

        ReDim $ATab[30]  ;-- reinitialize $ATab array. up to 30 columns.
        ReDim $ATab2[30] ;-- type array. (string or numeric)
        ReDim $ATabT[30] ;-- specific type array.

            ;-- for each table name get all of its columns from the Column table.
            ;-- getting Type is a doozy. Microsoft has deliberately hidden the Type
            ;-- field of the _columns table. Iteration of this table is the
            ;-- best that one can do for discovering table columns, as clunky as it is.
            ;-- But it's worse than that. Discovering the data type of the Column
            ;-- is a secret, apparently available only to Microsoft buddies. The type
            ;-- Column is a string that represents a number(!), which is a bit mask.
            ;-- HD00 (3328) seems to indicate a string, while H200 indicates the string
            ;-- is a property or constant to be translated. This script is not concerned with
            ;-- working out all properties of each Column. It just looks for strings and calls
            ;-- the rest integers, because it only uses 2 type: CHAR(255) and INT.
	        ;-- columns in all the 80-odd MSI tables.
            $View = $DB.OpenView("SELECT `Name`, `Type`, `Number` FROM `_Columns` WHERE `Table` ='" & $sTable & "'")
            $View.Execute()
              While 1
                 $Rec = $View.Fetch
                    If Not IsObj($Rec) Then ExitLoop
					
                $iTyp = Number($Rec.StringData(2))  ;-- secret Type field.
                $iCnt = $Rec.IntegerData(3)  ;-- Column position.
                $ATab[$iCnt] = $Rec.StringData(1) ;--Column name.
                  If ($iTyp And 3328) = 3328 Then  ;-- string
                     $ATab2[$iCnt] = 1  ;-- string.
                   Else
                     $ATab2[$iCnt] = 0 ;-- integer.
                  EndIf    
                    $ATabT[$iCnt] = $iTyp ;-- add specific type.
				ConsoleWrite("Type " & $iTyp & @CRLF)	
				ConsoleWrite("Cnt " & $iCnt & @CRLF)
				ConsoleWrite("Col Name " & $ATab[$iCnt] & @CRLF)
				ConsoleWrite("---------"& @CRLF)
				WEnd
            $View.Close()
	Next
EndFunc

; ----------------  clear the database. WARNING!!! All data will be lost in this MSI file.
Func ClearAllTables()
	Dim $sTName, $ViewC, $ViewR, $RecC, $RetC

	  $RetC = MsgBox(4,"Erase All Data !!","CAUTION: This will remove all data from the file - " & @CRLF  & "Proceed?")
    If $RetC = 2 Then Return ;Exit
	
	If $sPath = "" Then 
		Msgbox (0,"Error","No Database Loaded !!")
	Else
     
    $ViewC = $DB.OpenView("DELETE FROM `_Streams`")
    $ViewC.Execute()
	$DB.Commit()
	$ViewC.Close()
	
	$ViewC = ""
    $ViewC = $DB.OpenView("DELETE FROM `_Storages`")
    $ViewC.Execute()
	$DB.Commit()
    $ViewC.Close()
	
    $ViewC = ""
	$ViewC = $DB.OpenView("SELECT `Name` FROM _Tables")
    $ViewC.Execute()
	While 1  
        $RecC = $ViewC.Fetch
		If Not IsObj($RecC) Then ExitLoop
		$sTName = $RecC.StringData(1)
		
	ConsoleWrite($sTName & @CRLF)
	  RemoveTable($sTName)
    WEnd
	$RecC = ""
	$DB.Commit()
		GuiSetState(@SW_LOCK)
	_GUICtrlTreeViewDeleteAllItems ($TreeView)
		GuiSetState(@SW_UNLOCK)
    $ViewC.Close()

  
   EndIf
EndFunc

;---------------------------------- Clear Table ------------------------------------
Func ClearTable()
	Local $TVData
	
	If $sPath = "" Then 
		Msgbox (0,"Error","No Database Loaded")
	Else
		DeleteList()
    	If _GUICtrlTreeViewGetParentID($TreeView) = 0 then
			$sSelTab = GUICtrlRead(GUICtrlRead($treeview),1)
		EndIf	
	EndIf
		
	If _GUICtrlTreeViewGetParentID($TreeView) = 1 Then	
		MsgBox(0,"Error","Nothing Selected, Try again ...")
	Else
	
	RemoveTable($sSelTab)

	GuiSetState(@SW_LOCK)
	_GUICtrlTreeViewDeleteItem ($Gui, $treeview,$sSelTab)
	GuiSetState(@SW_UNLOCK)
	EndIf
EndFunc

;----------------------------- Remove a database table. ------------------------------------
Func RemoveTable($sTab)
	;MsgBox(0,"Error",$sTab)
  Dim $ViewR
	If (StringLeft($sTab, 1) <> "_") Then
		$ViewR = $DB.OpenView("DROP TABLE `" & $sTab & "`")
		$ViewR.Execute()
		;$DB.Commit()
		$ViewR.Close()
		$ViewR = ""  
    EndIf
EndFunc

;----------------------------- TreeView Click -----------------------------
Func TreeDBTableClick()
	DeleteList()
    	If _GUICtrlTreeViewGetParentID($TreeView) = 0 then
			$TVText = GUICtrlRead(GUICtrlRead($treeview),1)
			GetTableContent($TVText)
			$TVText = ""
	    EndIf
EndFunc

;----------------------------- Getdata ------------------------------------
Func GetTableContent($sTabName)
 Local $ViewT, $RecT, $LVdata
 $LVdata = ""
 DeleteList()
 GuiSetState(@SW_LOCK)
 
	If $sPath = "" Then 
		Msgbox (0,"Error","No Database Loaded !!")
	Else
	$ViewT = $DB.OpenView("SELECT * FROM " & $sTabName)
           $ViewT.Execute()
			While 1  
                  $RecT = $ViewT.Fetch
                       If Not IsObj($RecT) Then ExitLoop
					$Fields = $RecT.FieldCount
				For $i = 1 to $Fields
					; ConsoleWrite( $RecT.StringData($i) & "|")
					$LVdata = $LVData & $RecT.StringData($i) & "|"
					
				Next
				; ConsoleWrite(@CRLF)
			GUICtrlCreateListViewItem($LVdata,$listview)
				$LVdata = ""
			Wend	
    $ViewT.Close
	; GUICtrlSetState($tab1,$GUI_SHOW) 	; Show Tab1
	EndIf
GuiSetState(@SW_UNLOCK)

;--------------------------- Get Fields --------------------------------------
 Local $index
 $index = 0
 	For $i = 1 to 10
			_GUICtrlListViewSetColumnHeaderText($ListView,$index,"")
			$index += 1
	Next
 $index = 0
  $ViewT = $DB.OpenView("SELECT `Name` FROM `_Columns` WHERE `Table` ='" & $sTabName & "'")
			$ViewT.Execute()
				While 1  
                  $RecT = $ViewT.Fetch
				  If Not IsObj($RecT) Then ExitLoop
					$Fields = $RecT.FieldCount
					For $i = 1 to $Fields
						$TVdata = $RecT.StringData($i)
						_GUICtrlListViewSetColumnHeaderText($ListView,$index,$TVData)
						$index += 1
					Next
				WEnd
			$ViewT.Close
		   
EndFunc

;--------------------------------- list embedded CABs --------------------------------
    ;-- return list of embedded CABs, MergeModule.CABinet if it's an MSM.
    ;-- NOTE that this function does not list all CABs but only embedded CABs.
    ;-- This function is generally not of much use. It;s included here only
    ;-- for people who may be using this class with an MSI used for
    ;-- software installation.
  
Func GetCABList()
	Local $ViewC, $RecC, $sCabList3, $s2, $ARet[1], $Return
	$LVdata = ""
    $sCabList3 = ""
	
	If $sPath = "" Then 
		Msgbox (0,"Error","No Database Loaded !!")
	Else
	DeleteList()
 
    $ViewC = $DB.OpenView("SELECT `Cabinet` FROM Media")
    $ViewC.execute()
		While 1
         $RecC = $ViewC.Fetch
              If Not IsObj($RecC) Then ExitLoop
           $s2 = $RecC.stringdata(1)          
             If StringInstr(1, $s2, "MergeModule.", 1) > 0 Then
                 ReDim $ARet[2]
                 $ARet[1] = "1"
                 $ARet[2] = $s2
                 $Return = $ARet
                 Return
             Else
                 If (StringLeft($s2, 1) = "#") Then
                     $sCabList3 = $sCabList3 & Chr(1) & (StringRight($s2, (StringLen($s2) - 1)))
                 EndIf
             EndIf
			  GUICtrlCreateListViewItem($s2,$listview)
		Wend
			_GUICtrlListViewSetColumnHeaderText($ListView,0,"Embedded Cabinet class ID")
		$ViewC.Close
		$RecC = ""
        $ViewC = ""
	EndIf
EndFunc	   

;-------------------------------------  Extract CAB file from MSM or MSI  -----------------------
Func ExtractCAB($sCabName)
	Local $Return
 Dim $ViewE, $RecE, $DLen, $FSO2, $TS2, $s2, $sFile2

    $sErr = ""  ;-- clear ErrorString.
	$FSO2 = ObjCreate("Scripting.FileSystemObject")
	If ($FSO2.FolderExists(@ScriptDir) = 0) Then
       $sErr = "ExtractCAB: No file loaded."
       $Return = 1
       $FSO2 = ""
       Return
    EndIf

    $ViewE = $DB.OpenView("SELECT `Name`,`Data` FROM _Streams WHERE `Name`= '" & $sCabName & "'")
    $ViewE.execute()
      $RecE = $ViewE.Fetch
          If $RecE == "" Then
                $ViewE = ""
               $sErr = "ExtractCAB: Failed to extract CAB."
                 If (@error <> 0) Then 
                    $Return = @error
                 Else        
                     $Return = 2  ;--just make up a non-zero error number if this is somehow not an MSI error.
                 EndIf  
                     $FSO2 = ""
				 Return
           EndIf
         $DLen = $RecE.datasize(2)
         $s2 = $RecE.ReadStream(2, $DLen, 2)
         $sFile2 = $sCabName

     If (StringUpper(StringRight($sFile2, 4)) <> ".CAB") Then $sFile2 = $sFile2 & ".cab"
    $TS2 = $FSO2.CreateTextFile($sPath & $sFile2, 1, 0)
       $TS2.Write ($s2)
       $TS2.Close()
    $TS2 = ""
 $FSO2 = ""
 $Rec = ""
 $View = ""
     If (@error <> 0) Then $sErr = "ExtractCAB: Error - " 
  $Return = @error
	Return $Return
EndFunc

;------------------------------- Delete List ----------------------------------
Func DeleteList()
	GuiSetState(@SW_LOCK)
	_GUICtrlListViewDeleteAllItems ($listview)
	GuiSetState(@SW_UNLOCK)
EndFunc

;------------------------------- Close DB -------------------------------------
Func CloseDB()
	GuiSetState(@SW_LOCK)
	_GUICtrlTreeViewDeleteAllItems ($TreeView)
	GuiSetState(@SW_UNLOCK)
	$WISumInfo = ""
	$DB = ""
	$sPath = ""
	$View = ""
	$ViewC = ""
	$ViewR = ""
	$ViewT = ""
	DeleteList()
EndFunc

;----------------------------- CommitSQL ------------------------------------
Func CommitSQL()
Local $ViewT, $RecT, $LVdata

 $LVdata = ""
 DeleteList()
 
; SELECT `Name`, `Type`, `Number` FROM `_Columns` WHERE `Table` = 'Property'

If $sPath = "" Then 
		Msgbox (0,"Error","No Database Loaded !!")
	Else
	If StringInStr(GUICtrlRead($SQLInsert), "SELECT") Then
			$ViewT = $DB.OpenView(StringStripWS(GUICtrlRead($SQLInsert), 3))
			$ViewT.Execute()
			While 1  
                  $RecT = $ViewT.Fetch
                       If Not IsObj($RecT) Then ExitLoop
					$Fields = $RecT.FieldCount
				For $i = 1 to $Fields
					$LVdata = $LVData & $RecT.StringData($i) & "|"
					
				Next
			GUICtrlCreateListViewItem($LVdata,$listview)
				$LVdata = ""
			Wend	
				$ViewT.Close
		GUICtrlSetState($tab1,$GUI_SHOW) 	;Jump to and show Tab1
	
	Else
		Msgbox (0,"Error","No SELECT entered, try again")
	Endif
EndIf	
EndFunc

;----------------------------- Gui Events ------------------------------------
Func GUIevent()
	Exit
EndFunc

;------------------------------ This is a COM Error handler --------------------------------
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc
