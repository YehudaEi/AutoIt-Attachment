#include <GUIConstants.au3>
#include <GuiListView.au3>

;Const $adNumeric = 131
Const $adVarWChar = 202 ; 200 ; More DataTypes http://www.w3schools.com/ado/ado_datatypes.asp
Const $adLongVarWChar = 203
Const $MaxCharacters = 255 
Const $adPersistXML = 1 ; or $adPersistADGT = 0
Const $Pagesize = 25
Const $Path = "C:\_\Apps\AutoIT3\Vbs2Au3\Test.xml"

Dim $ador, $items, $item1, $item2
Dim $sField0 = "Name"
Dim $sField1 = "Memo"
Dim $iPage, $iPageCount , $iPosition, $Step
Dim $iRecords, $iFields
Dim $oMyError

HotKeySet("{DOWN}", "_MoveNext")
HotKeySet("{UP}", "_MovePrevious")
HotKeySet("{HOME}", "_MoveFirst")
HotKeySet("{END}", "_MoveLast")
HotKeySet("{PGDN}", "_NextPage")
HotKeySet("{PGUP}", "_PreviousPage")

; Initializes COM handler
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

; same as "ADODB.Connection" but faster and less overhead for DB on clients only
$ador = ObjCreate( "ADOR.Recordset" )    
										 
	With $ador
		$ador.Fields.append ($sField0, $adVarWChar, $MaxCharacters)
		.Fields.append ($sField1, $adLongVarWChar, $MaxCharacters)
		.Open
	EndWith

GUICreate("No ODBC no DNS no DB no Query - ListView Navigation 1.0", 600, 500, (@DesktopWidth/2)-300, (@DesktopHeight/2)-350, _ 
$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$listview = GUICtrlCreateListView ("Names |Comments  ",10,10,200,400)

GUICtrlCreateGroup ("Keyboard Navigation", 250, 100, 300, 300)


$btn_1 = GUICtrlCreateButton ("Build the DB", 250,  15, 90, 20)
GUICtrlSetTip(-1,"Create an in Memory DB with 10000 records")
$btn_2 = GUICtrlCreateButton ("Sort data", 250, 35, 90, 20)
GUICtrlSetTip(-1,"Sort the data on the first Column")
$btn_3 = GUICtrlCreateButton ("Export XML", 350, 35, 90, 20)
GUICtrlSetTip(-1,"Save data to an XML file")
$btn_6 = GUICtrlCreateButton ("|| <<", 10,  415, 40, 20)
GUICtrlSetTip(-1,"Go to the First Record")
$btn_7 = GUICtrlCreateButton ("<", 60,  415, 40, 20)
GUICtrlSetTip(-1,"Go to the Previous Record")
$btn_8 = GUICtrlCreateButton (">", 110,  415, 40, 20)
GUICtrlSetTip(-1,"Go to the Next Record")
$btn_9 = GUICtrlCreateButton (">> ||", 160, 415, 40, 20)
GUICtrlSetTip(-1,"Go to the Last Record")
$btn_10 = GUICtrlCreateButton ("Next Page", 110, 435, 90, 20)
GUICtrlSetTip(-1,"Go to the Next Page")
$btn_11 = GUICtrlCreateButton ("Previous Page", 10, 435, 90, 20)
GUICtrlSetTip(-1,"Go to the Previous Page")

$Label_1 = guictrlcreatelabel("",0,480,50,20,$SS_SUNKEN) 
$Label_2 = guictrlcreatelabel("",50,480,100,20,$SS_SUNKEN)
$Label_3 = guictrlcreatelabel("",150,480,100,20,$SS_SUNKEN)
$Label_4 = guictrlcreatelabel("",250,480,400,20,$SS_SUNKEN) 
$Label_6 = guictrlcreatelabel("Debug",300,440,400,20)
$Label_7 = guictrlcreatelabel("Press HOME to move to the First record",280,150,250,20)
$Label_8 = guictrlcreatelabel("Press END to move to the Last record",280,170,250,20)
$Label_9 = guictrlcreatelabel("Press PAGE UP to move to the previous page",280,230,250,20)
$Label_10 = guictrlcreatelabel("Press PAGE DOWN to move to the next page",280,250,250,20)
$Label_11 = guictrlcreatelabel("Press ARROW UP to move to the previous record",280,310,250,20)
$Label_12 = guictrlcreatelabel("Press ARROW DOWN to move to the next record",280,330,250,20)

$Contextmenu = GUICtrlCreateContextMenu($listview)
$Copyitem = GUICtrlCreateMenuitem ("Copy 2 Clipboard",$Contextmenu)

GUISetState()

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $btn_1
		_Build_DB()
		Case $msg = $btn_2
		 _Sort()
		Case $msg = $btn_3
		_SaveXML()
		Case $msg = $btn_6
		_MoveFirst()
		Case $msg = $btn_7
		_MovePrevious()
		Case $msg = $btn_8
		_MoveNext()
		Case $msg = $btn_9
		_MoveLast()
		Case $msg = $btn_10
		_NextPage()
		Case $msg = $btn_11
		_PreviousPage()
		Case $msg = $Copyitem
		_CopyItem()
	EndSelect
WEnd
	$ador.Close
Exit

Func _Build_DB ()
Local $iRecord
If not IsObj($ador) Then
	MsgBox(0,"Error","Cannot create Object")
EndIf
	GUISetState(@SW_LOCK)
	With $ador
		For $i = 1 To 10023
			.AddNew
			.Fields(0).Value = "Name" & $i
		$item1= .Fields(0).Value
			.Fields(1).Value = "Added some more"
		$item2= .Fields(1).Value
		Next
	EndWith
; Initialize Counters
	_PageCount()
	_RecordPosition()
	_MoveFirst()
	For $iRecord = $ador.AbsolutePosition() To $ador.PageSize
			If $ador.EOF <> 0 Then ExitLoop
			$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
			$ador.MoveNext()
		Next
	_MoveFirst()
	GUISetState(@SW_UNLOCK)
	ControlFocus("","",$listview)
	_GUICtrlListViewSetColumnWidth($listview,0,80)
	_GUICtrlListViewSetItemSelState ($listview, $ador.AbsolutePosition()-1)
	_RecordCount()
	_Bof_EoF()
EndFunc

Func _NextPage()
Local $iRecord
If $ador.EOF <> 0 Then
	_Bof_EoF()
	ElseIf 	$ador.AbsolutePage=$ador.PageCount Then
	_Bof_EoF()
Else
	_GUICtrlListViewDeleteAllItems ($listview)
	GUISetState(@SW_LOCK)
			For $iRecord = 1 To ($ador.PageSize*$ador.AbsolutePage)+1-$ador.AbsolutePosition
				If $ador.EOF <> 0 Then _Bof_EoF()
				$ador.MoveNext()
			Next
			For $iRecord = 1 To ($ador.PageSize*$ador.AbsolutePage)+1-$ador.AbsolutePosition
				If $ador.EOF <> 0 Then ExitLoop
				$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
				$ador.MoveNext()
			Next
			For $iRecord = 1 To ($ador.PageSize*$ador.AbsolutePage)+1-$ador.AbsolutePosition
				If $ador.BOF <> 0 Then _Bof_EoF()
				$ador.MovePrevious()
			Next
	GUISetState(@SW_UNLOCK)
EndIf
	ControlFocus("","",$listview)
	_GUICtrlListViewSetItemSelState ($listview, ($ador.AbsolutePosition-1)-($ador.PageSize()*($ador.AbsolutePage-1)))
	_Bof_EoF()
EndFunc
	
Func _PreviousPage()
If $ador.BOF <> 0 Then 
	_Bof_EoF()
	ElseIf 	$ador.AbsolutePage=1 Then
	_Bof_EoF()
	Else
	_GUICtrlListViewDeleteAllItems ($listview)
	GUISetState(@SW_LOCK)
		For $iRecord = 1 To $ador.AbsolutePosition-1-($ador.PageSize*($ador.AbsolutePage-2))
			If $ador.BOF <> 0 Then _Bof_EoF()
			$ador.MovePrevious()
		Next
		For $iRecord = 1 To $ador.AbsolutePosition-1-($ador.PageSize*($ador.AbsolutePage-2))
			If $ador.BOF <> 0 Then ExitLoop
			$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
			$ador.MoveNext()
		Next
		For $iRecord = 1 To $ador.AbsolutePosition-1-($ador.PageSize*($ador.AbsolutePage-2))
			If $ador.EOF <> 0 Then _Bof_EoF()
			$ador.MovePrevious()
		Next
	GUISetState(@SW_UNLOCK)
EndIf
	ControlFocus("","",$listview)
	_GUICtrlListViewSetItemSelState ($listview, ($ador.AbsolutePosition-1)-($ador.PageSize()*($ador.AbsolutePage-1)))
	_Bof_EoF()
Endfunc

Func _MoveFirst()
If $ador.BOF <> 0 Then
	_Bof_EoF()
	ElseIf $ador.AbsolutePosition = 1 Then
	_Bof_EoF()
	ElseIf $ador.RecordCount < $ador.PageSize Then
	_GUICtrlListViewDeleteAllItems ($listview)
	GUISetState(@SW_LOCK)
 	$ador.MoveFirst()
		For $iRecord = 1 To $ador.RecordCount
			If $ador.BOF <> 0 Then $ador.MoveNext()
			$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
			$ador.MoveNext()
		Next
	GUISetState(@SW_UNLOCK)
	Else
	_GUICtrlListViewDeleteAllItems ($listview)
	GUISetState(@SW_LOCK)
	$ador.MoveFirst()
		For $iRecord = 1 To $ador.PageSize
			If $ador.BOF <> 0 Then $ador.MoveNext()
			$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
			$ador.MoveNext()
		Next
	GUISetState(@SW_UNLOCK)
EndIf
	$ador.MoveFirst()
	ControlFocus("","",$listview)
	_GUICtrlListViewSetItemSelState ($listview, $ador.AbsolutePosition()-1)
	_Bof_EoF()
EndFunc

Func _MoveNext()
If $ador.EOF <> 0 Then
		_Bof_EoF()
	ElseIf $ador.AbsolutePosition() = $ador.PageSize()*$ador.AbsolutePage() Then 
		_Bof_EoF()
	Else
	 $ador.MoveNext()
	 _GUICtrlListViewSetItemSelState ($listview, ($ador.AbsolutePosition()-1)-($ador.PageSize()*($ador.AbsolutePage-1)))
EndIf
	ControlFocus("","",$listview)
	_Bof_EoF()
EndFunc

Func _MovePrevious()
If $ador.BOF <> 0 Then
		_Bof_EoF()
	ElseIf $ador.AbsolutePosition() = $ador.PageSize()*$ador.AbsolutePage()-$ador.PageSize() Then 
		_Bof_EoF()
	ElseIf $ador.AbsolutePosition() = ($ador.PageSize()*($ador.AbsolutePage()-1)+1) Then 
	   _Bof_EoF()
	Else
	$ador.MovePrevious()
	 _GUICtrlListViewSetItemSelState ($listview, ($ador.AbsolutePosition-1)-($ador.PageSize()*($ador.AbsolutePage-1)))
EndIf
	ControlFocus("","",$listview)
	_Bof_EoF()
EndFunc

Func _MoveLast()
If $ador.EOF <> 0 Then
	_Bof_EoF()
	Else
	_GUICtrlListViewDeleteAllItems ($listview)
	GUISetState(@SW_LOCK)
 	$ador.MoveLast()
	_RecordPosition()
	GUICtrlSetData($Label_3,"Page "&$ador.AbsolutePage&"/"&$iPageCount)
		For $iRecord = 1 To $iPosition-1-($ador.PageSize*($ador.PageCount-1))
			If $ador.BOF <> 0 Then $ador.MoveNext(); ExitLoop
			$ador.MovePrevious()
		Next
		For $iRecord = 1 To $iPosition-($ador.PageSize*($ador.PageCount-1))
			If $ador.BOF <> 0 Then ExitLoop
			$items=GUICtrlCreateListViewItem($ador.Fields(0).Value & "|" & $ador.Fields(1).Value, $listview)
			$ador.MoveNext()
		Next
		For $iRecord = 1 To $iPosition-($ador.PageSize*($ador.PageCount-1))
			If $ador.BOF <> 0 Then $ador.MoveNext(); ExitLoop
			$ador.MovePrevious()
		Next
	GUISetState(@SW_UNLOCK)
	_GUICtrlListViewSetItemSelState ($listview, ($ador.AbsolutePosition-1)-($ador.PageSize()*($ador.AbsolutePage-1)))
	_Bof_EoF()
EndIf
	ControlFocus("","",$listview)
EndFunc

Func _RecordCount()
	_FieldCount()
	$iRecords = $ador.RecordCount()
	GUICtrlSetData($Label_4,"# of Records " & $iRecords & " "&", # of Fields "& $iFields)
	Return $iRecords
EndFunc

Func _FieldCount()
	$iFields = $ador.Fields.Count()
	Return $iFields
EndFunc

Func _RecordPosition()
	$iPosition = $ador.AbsolutePosition()
	Return $iPosition
EndFunc

Func _PageCount()
	$ador.PageSize = $Pagesize 
		$iPageCount = $ador.PageCount 
		For $iPage = 1 To $iPageCount Step 1
		$ador.AbsolutePage = $iPage
		Next
	Return $iPage
	Return $iPageCount
EndFunc

Func _Bof_EoF()
	Select
		Case $ador.BOF <> 0
		GUICtrlSetData($Label_1," BOF")
		GUICtrlSetData($Label_2, "1/" & $iRecords)
		GUICtrlSetData($Label_3,"Page "&$ador.AbsolutePage&"/"&$iPageCount)
		GUICtrlSetData($Label_4,"# of Records = " & $iRecords & " "&", # of Fields = "& $iFields)
		GUICtrlSetData($Label_6,"Abs.Pos."&$ador.AbsolutePosition& " Abs.Pag. "&$ador.AbsolutePage)
		Case $ador.EOF <> 0
		GUICtrlSetData($Label_1," EOF")
		GUICtrlSetData($Label_2,$iRecords &"/"& $iRecords)
		GUICtrlSetData($Label_3,"Page "&$ador.AbsolutePage&"/"&$iPageCount)
		GUICtrlSetData($Label_4,"# of Records = " & $iRecords & " "&", # of Fields = "& $iFields)
		GUICtrlSetData($Label_6,"Abs.Pos."&$ador.AbsolutePosition& " Abs.Pag. "&$ador.AbsolutePage)
		Case Else
		GUICtrlSetData($Label_1,"")
		GUICtrlSetData($Label_2,$ador.AbsolutePosition&"/"& $iRecords)
		GUICtrlSetData($Label_3,"Page "&$ador.AbsolutePage&"/"&$iPageCount)
		GUICtrlSetData($Label_4,"# of Records = " & $iRecords & " "&", # of Fields = "& $iFields)
		GUICtrlSetData($Label_6,"Abs.Pos."&$ador.AbsolutePosition& " Abs.Pag. "&$ador.AbsolutePage)
	EndSelect
EndFunc

Func _SaveXML()
	$ador.Save ($Path,  $adPersistXML)
Endfunc

Func _Sort()
	$ador.Sort = $sField0
	_MoveLast()
	_MoveFirst()
EndFunc

Func _CopyItem()
	Local $Text
	$Text = _GUICtrlListViewGetItemText ($listview, -1,-1)
	ClipPut($Text)
EndFunc	

; This is Sven P's custom error handler added by ptrex
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Errors","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.Description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.Windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.Scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.Source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.Helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.Helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc