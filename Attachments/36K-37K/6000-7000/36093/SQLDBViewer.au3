;SQLDBViewer

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIListBox.au3>
#Include <GuiListView.au3>
#include <Array.au3>

Global $g_eventerror = 0
Global $oMyError = 0

Dim $DEBUG = True
;Dim $DEBUG = False

Dim $arConnectInfo[1]
$arConnectInfo[0] = 0

Dim $FormHwnd, $LabelID, $cboConnInfo, $btnConnect
Dim $gbConInfo, $lblServer, $txtServer, $lblCat, $txtCatalog, $lblUser, $txtuser, $lblPasword, $txtPassword
Dim $gbTableListDisplay, $lbTables
Dim $gbTableDisplay, $pb, $txtQuery, $lvTable

Dim $IniBuf = ""
Dim $SelectedConnectionInformation = ""
Dim $bCheckConInfo = False
Dim $bCheckSelectedTable = False
Dim $CurrentTableName = "" ; the table that is currently selected. Will change if a new selection is made.

Dim $TableData = "";includes the query, the column names and tab-separated column values for CRLF-separated records, populated when a query is run

HotKeySet ( "^!c", "CopyData" );ctrl-alt-c
HotKeySet ( "{F5}", "RunUserQuery" )

Main()

Func Main()
	ReadIniData()
	DoUI()
EndFunc

;-----------UI Functions-----------
Func DoUI()
	$FormHwnd = GUICreate ( "SQL Server Tool", @DesktopWidth / 2 - 175, 200, 200, @DesktopHeight / 2 - 45, 0x00040000 + 0x00010000, 0x00000018 )	; $WS_SIZEBOX + $WS_MAXIMIZEBOX, WS_EX_ACCEPTFILES
	GUISetBkColor ( 0x00E0FFFF )	;window backgrd = light blue
	$LabelID = GUICtrlCreateLabel ( "Select Database", 2, 2, 200 )
	GUICtrlSetResizing ( $LabelID, $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKTOP )

	$cboConnInfo = GUICtrlCreateCombo ( "", 2, 22, 118, 25, BitOR ( $CBS_DROPDOWN,$CBS_AUTOHSCROLL ) )
	GUICtrlSetResizing ( $cboConnInfo, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )
	if $arConnectInfo [ 0 ] > 0 Then
		Dim $ConnBuffer = _ArrayToString ( $arConnectInfo )
		$ConnBuffer = StringRight ( $ConnBuffer, StringLen ( $ConnBuffer ) - StringInStr ( $ConnBuffer, @CRLF ) - 2 )
		GUICtrlSetData ( $cboConnInfo, $ConnBuffer )
	EndIf

	$btnConnect = GUICtrlCreateButton ( "New Connection", 120, 20, 98, 22 )
	GUICtrlSetOnEvent($btnConnect, "ConnectBtnOnClick")
	GUICtrlSetResizing ( $btnConnect, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )
#region Connection Infomation groupbox
	$gbConInfo = GUICtrlCreateGroup("Connection Information", 220, 8, 260, 81)
	GUICtrlSetResizing ( $gbConInfo, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $gbConInfo, $GUI_HIDE )

	$lblServer = GUICtrlCreateLabel("Server", 230, 24, 35, 17)
	GUICtrlSetResizing ( $lblServer, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $lblServer, $GUI_HIDE )

	$txtServer = GUICtrlCreateInput("", 270, 24, 70, 21)
	GUICtrlSetResizing ( $txtServer, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $txtServer, $GUI_HIDE )

	$lblCat = GUICtrlCreateLabel("Catalog", 230, 56, 40, 17)
	GUICtrlSetResizing ( $lblCat, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $lblCat, $GUI_HIDE )

	$txtCatalog = GUICtrlCreateInput("", 270, 56, 70, 21)
	GUICtrlSetResizing ( $txtCatalog, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $txtCatalog, $GUI_HIDE )

	$lblUser = GUICtrlCreateLabel("User", 350, 24, 26, 17)
	GUICtrlSetResizing ( $lblUser, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $lblUser, $GUI_HIDE )

	$txtuser = GUICtrlCreateInput ( "", 400, 24, 70, 21 )
	GUICtrlSetResizing ( $txtuser, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $txtuser, $GUI_HIDE )

	$lblPasword = GUICtrlCreateLabel("Password", 350, 56, 50, 17)
	GUICtrlSetResizing ( $lblPasword, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $lblPasword, $GUI_HIDE )

	$txtPassword = GUICtrlCreateInput ( "", 400, 56, 70, 21, $ES_PASSWORD )
	GUICtrlSetResizing ( $txtPassword, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $txtPassword, $GUI_HIDE )

	GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion End Connection Infomation groupbox



#region Available Table List groupgbox
	$gbTableListDisplay = GUICtrlCreateGroup("Table List", 2, 42, 210, @DesktopHeight / 2 - 376)
	GUICtrlSetResizing ( $gbTableListDisplay, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKBOTTOM )
	GUICtrlSetState ( $gbTableListDisplay, $GUI_HIDE )

	$lbTables = GUICtrlCreateList ( "", 4, 56, 206, @DesktopHeight / 2 - 392, $LBS_NOINTEGRALHEIGHT )
	GUICtrlSetResizing ( $lbTables, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKBOTTOM )
	GUICtrlSetState ( $lbTables, $GUI_HIDE )

	GUICtrlCreateGroup("", -99, -99, 1, 1)

#endregion Available Table List groupgbox

#region Table display groupgbox
	$gbTableDisplay = GUICtrlCreateGroup("Table", 220, 2, @DesktopWidth / 2 - 400, @DesktopHeight / 2 - 336)
	GUICtrlSetResizing ( $gbTableDisplay, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM )
	GUICtrlSetState ( $gbTableDisplay, $GUI_HIDE )

	$pb = GUICtrlCreateProgress ( 222, 16, @DesktopWidth / 2 - 404, 17, 0x01 )	; 0x01 = $PBS_SMOOTH
	GUICtrlSetColor ( $pb, 0x00FF00 ); set progress bar color to green
	GUICtrlSetState ( $pb, $GUI_HIDE )

	$txtQuery = GUICtrlCreateEdit ( "", 222, 16, @DesktopWidth / 2 - 404, 60, $ES_MULTILINE )
	GUICtrlSetResizing ( $txtQuery, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT )
	GUICtrlSetState ( $txtQuery, $GUI_HIDE )

	$lvTable = GUICtrlCreateListView ( "", 222, 78, @DesktopWidth / 2 - 404, 98 )
	GUICtrlSetResizing ( $lvTable, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM )
	GUICtrlSetState ( $lvTable, $GUI_HIDE )

	GUICtrlCreateGroup("", -99, -99, 1, 1)

#endregion Table display groupgbox

	GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

	GUISetState()  ; display the GUI

	While 1
		if StringLen ( GUICtrlRead ( $cboConnInfo ) ) = 0 Then
			GUICtrlSetData ( $btnConnect, "New Connection" )
		Else
			GUICtrlSetData ( $btnConnect, "Connect" )
		EndIf
		if $bCheckConInfo Then
			CheckConInfo()
		EndIf
		if $bCheckSelectedTable Then
			CheckTableSelection()
		EndIf
		Sleep(500)
	WEnd
	GUIDelete( $FormHwnd )
	Exit
EndFunc

Func ConnectBtnOnClick()
	$SelectedConnectionInformation = GUICtrlRead ( $cboConnInfo )
	if StringLen ( $SelectedConnectionInformation ) = 0 And StringLen ( GUICtrlRead ( $txtPassword ) ) > 0 Then
		$SelectedConnectionInformation = GUICtrlRead ( $txtServer ) & @TAB & GUICtrlRead ( $txtCatalog ) & @TAB & GUICtrlRead ( $txtUser ) & @TAB & GUICtrlRead ( $txtPassword )
	EndIf
	Dim $InfoItemNumber = _ArrayTokenNum ( $SelectedConnectionInformation, @TAB )
	if $InfoItemNumber < 4 Then
		FillConInfoWithExistingInfo ( $InfoItemNumber )
		DisplayConInfoGroupBox ( $GUI_SHOW )
		GUICtrlSetState ( $btnConnect,  $GUI_DISABLE )
		$bCheckConInfo =  True
	Else
		$bCheckConInfo =  False	; stop checking connection info user filled controls
		ClearConInfoGBData ()	; clear the server, catalog, user and password edit boxes and hide the connection info groupbox with its contents
		DisplayConInfoGroupBox ( $GUI_HIDE )
		if ShowDBTables() Then
			SaveIni()
		EndIf
	EndIf
EndFunc

Func OnExit()
	Exit
EndFunc

;-----------Helper Functions-------------

Func _ArrayTokenNum ( $SeparatedString, $Separator )
	if StringInStr ( $SeparatedString, $Separator ) = 0 Then
		if StringLen ( $SeparatedString ) > 0 Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Dim $arTokens = StringSplit ( $SeparatedString, $Separator, 1 )
		Return $arTokens [ 0 ]
	EndIf
EndFunc

Func CheckConInfo()
	if StringLen ( GUICtrlRead ( $txtCatalog ) ) > 0 And _
		StringLen ( GUICtrlRead ( $txtUser ) ) > 0 And _
		StringLen ( GUICtrlRead ( $txtPassword ) ) > 0 Then
		GUICtrlSetState ( $btnConnect,  $GUI_ENABLE )
		GUICtrlSetData ( $btnConnect, "Connect" ) ; update the button text to let user know they can try connecting
		$SelectedConnectionInformation = GUICtrlRead ( $txtServer ) & @TAB & GUICtrlRead ( $txtCatalog ) & @TAB & GUICtrlRead ( $txtUser ) & @TAB & GUICtrlRead ( $txtPassword )
	EndIf
EndFunc

Func CheckTableSelection()
	Dim $SelectedTable = GUICtrlRead ( $lbTables )
	if StringLen ( $SelectedTable ) = 0 then Return	; no selection
	if $CurrentTableName = $SelectedTable Then Return ; no new selection
	GUICtrlSetData ( $txtQuery, "select * from " & $SelectedTable )
	DisplayTableGroup ( $GUI_SHOW )
	RunUserQuery()
	$CurrentTableName = $SelectedTable	; set the current table for future verification of user table selection change
EndFunc

Func ClearConInfoGBData ()
	GUICtrlSetData ( $txtServer, "" )
	GUICtrlSetData ( $txtCatalog, "" )
	GUICtrlSetData ( $txtUser, "" )
	GUICtrlSetData ( $txtPassword, "" )
EndFunc

Func CopyData ()
	ClipPut ( $TableData )
EndFunc

Func DisplayConInfoGroupBox ( $Setting )
	GUICtrlSetState ( $gbConInfo, $Setting )
	GUICtrlSetState ( $lblServer, $Setting )
	GUICtrlSetState ( $txtServer, $Setting )
	GUICtrlSetState ( $lblCat, $Setting )
	GUICtrlSetState ( $txtCatalog, $Setting )
	GUICtrlSetState ( $lblUser, $Setting )
	GUICtrlSetState ( $txtUser, $Setting )
	GUICtrlSetState ( $lblPasword, $Setting )
	GUICtrlSetState ( $txtPassword, $Setting )
EndFunc

Func DisplayTableGroup ( $Setting )
	GUICtrlSetState ( $gbTableDisplay, $Setting )
	GUICtrlSetState ( $txtQuery, $Setting )
	GUICtrlSetState ( $lvTable, $Setting )
EndFunc

Func DisplayTableListGroup ( $Setting )
	GUICtrlSetState ( $gbTableListDisplay, $Setting )
	GUICtrlSetState ( $lbTables, $Setting )
EndFunc

Func FillConInfoWithExistingInfo ( $InfoItemNumber )
	if $InfoItemNumber > 0 Then
		Dim $arConInfoValues = StringSplit ( $SelectedConnectionInformation, @CRLF, 1 )
		GUICtrlSetData ( $txtServer, $arConInfoValues [ 1 ] )
		if $InfoItemNumber > 1 Then GUICtrlSetData ( $txtCatalog, $arConInfoValues [ 2 ] )
		if $InfoItemNumber > 2 Then GUICtrlSetData ( $txtUser, $arConInfoValues [ 3 ] )
	EndIf
EndFunc

Func IsValidQuery ( $Query )
	; this can't be thouroughly checked here. Just make sure once leading and trailing spaces, tabs, CR, LF are stripped, it starts with "select " or "update " or "insert "
	While StringLeft ( $Query, 1 ) = " " Or StringLeft ( $Query, 1 ) = @TAB Or StringLeft ( $Query, 1 ) = @CR Or StringLeft ( $Query, 1 ) = @LF
		$Query = StringTrimLeft ( $Query, 1 )
	WEnd
	While StringRight ( $Query, 1 ) = " " Or StringRight ( $Query, 1 ) = @TAB Or StringRight ( $Query, 1 ) = @CR Or StringRight ( $Query, 1 ) = @LF
		$Query = StringTrimRight ( $Query, 1 )
	WEnd
	if StringLeft ( StringLower ( $Query ), 7 ) = "select " And StringLen ( $Query ) > 7 Then return True
	if StringLeft ( StringLower ( $Query ), 7 ) = "update " And StringLen ( $Query ) > 7 Then return True
	if StringLeft ( StringLower ( $Query ), 7 ) = "insert " And StringLen ( $Query ) > 7 Then return True
EndFunc

Func ReadIniData()
	if FileExists(@ScriptDir & "\" & "SQLDBViewer.ini") Then
		$IniBuf = FileRead ( @ScriptDir & "\SQLDBViewer.ini" )
		if @error = 0 Then
			; $IniBuf is of tab- and CRLCF-format. Each line contains tab separated values <server><catalog><user><password>; if it becomes necessary, will encrypt and decrypt
			$arConnectInfo = StringSplit ( $IniBuf, @CRLF )
		EndIf
	EndIf
EndFunc

Func RecSetOpenError()
	if $oMyError = 0 then Return
	Dim $HexNumber = hex ( $oMyError.number, 8 )
	Msgbox ( 0, "COM Error !", "Error number" & @LF & $HexNumber & @LF & _
				"description is: " & $oMyError.windescription )
	$g_eventerror = 1 ; something to check for when this function returns
EndFunc

;-----------------------------
; Function RunQuery
; Input:
;  SQry = string containing the SQL query
;  $bFirstRowHasColumns = boolean, set to true to return the columns as the first item in the return array
; Output:
;  an array where item 0 contains the size of the array, and each item contains a tab-separated list of values for one record
; Caveat: if the database returns an error for eg bad credentials, AutoIT cannot handle the error and crashes.
;  This happens at the line "$oRS.open ( $Qry, $sqlCon, 3, -1)".
Func RunQuery ( $Qry, $bFirstRowHasColumns = False )
Dim $sqlCon
Dim $oRS
Dim $ani1
Dim $intNbLignes
Dim $adLockOptimistic =3 ;Verrouillage optimiste, un enregistrement à la fois. Le fournisseur utilise le verrouillage optimiste et ne verrouille les enregistrements qu'à l'appel de la méthode Update.
Dim $adOpenKeyset = 1 ;Utilise un curseur à jeu de clés. Identique à un curseur dynamique mais ne permettant pas de voir les enregistrements ajoutés par d'autres utilisateurs (les enregistrements supprimés par d'autres utilisateurs ne sont pas accessibles à partir de votre Recordset). Les modifications de données effectuées par d'autres utilisateurs demeurent visibles.
Dim $Ret = ""
Dim $arConTokens = StringSplit ( $SelectedConnectionInformation, @TAB )
Dim $ServerName = $arConTokens [ 1 ]
Dim $CatalogName = $arConTokens [ 2 ]
Dim $User = $arConTokens [ 3 ]
Dim $Pwd = $arConTokens [ 4 ]
Dim $RetAr[2]
	$RetAr[0] = 0
	$sqlCon = ObjCreate("ADODB.Connection")
	if $sqlCon = 0 Then
		MsgBox(0,"","failed to create a connection object")
		Exit
	EndIf
	$oMyError = ObjEvent("AutoIt.Error","RecSetOpenError") ; Install a custom error handler
    $ani1 = GUICtrlCreateAvi(@SystemDir & "\shell32.dll", 165, 50, 10)
	GUISetState()
	GUICtrlSetState($ani1, 1)

	if $ServerName = "." or $ServerName = "" Then
		dim $ConString = "Provider=SQLOLEDB; Data Source=.\" & $CatalogName & "; Initial Catalog=" & $CatalogName & "; User ID=" & $User & "; Password=" & $Pwd & ";"
		$sqlCon.Open($ConString)
	Else
		$sqlCon.Open("Provider=SQLOLEDB; Data Source=" & $ServerName & "\" & $CatalogName & "; Initial Catalog=" & $CatalogName & "; User ID=" & $User & "; Password=" & $Pwd & ";")
	EndIf
	GUICtrlDelete ( $ani1 )
	if $g_eventerror then
		Msgbox(0,"SQLDBViewer","Error opening a recordset.")
		Return $RetAr
	EndIf
	$oRS = ObjCreate ( "ADODB.Recordset" )
	if $oRS = 0 then return $RetAr
	$oRS.CursorLocation = 2 ;adUseServer
	if StringLeft ( StringLower ( $Qry ), 7 ) = "select " Then

		$oRS.open ( $Qry, $sqlCon, 3, -1)	; adOpenStatic, lock type unspecified
		$intNbLignes = $oRS.recordCount
		if $intNbLignes > 0 Then
			$oRS.MoveFirst
			if $bFirstRowHasColumns = True Then
				for $iField = 0 to $oRS.Fields.Count - 1
					if $iField = 0 Then
						$RetAr [ 1 ] = $oRS.Fields.Item(0).name
					Else
						$RetAr [ 1 ] &= @TAB & $oRS.Fields.Item($iField).name
					EndIf
				Next
			EndIf
			if $bFirstRowHasColumns Then
				ReDim $RetAr [ $intNbLignes + 2 ]
				$RetAr [ 0 ] = $intNbLignes + 1
			Else
				ReDim $RetAr [ $intNbLignes + 1]
				$RetAr [ 0 ] = $intNbLignes
			EndIf
			For $i = 1 To $intNbLignes
				if ControlCommand ( "SQL Server Tool", "", "[CLASS:msctls_progress32; INSTANCE:1]", "IsVisible" ) Then
					GUICtrlSetData ( $pb, ($i * 100) / $intNbLignes )
				EndIf
				for $j = 1 to $oRS.Fields.Count
					if $j > 1 Then
						if $bFirstRowHasColumns Then
							$RetAr [ $i + 1 ] &= @TAB & $oRS.Fields.Item($j - 1).value
						Else
							$RetAr [ $i ] &= @TAB & $oRS.Fields.Item($j - 1).value
						EndIf
					Else
						if $bFirstRowHasColumns Then
							$RetAr [ $i + 1 ] = $oRS.Fields.Item(0).value
						Else
							$RetAr [ $i ] = $oRS.Fields.Item(0).value
						EndIf
					EndIf
				Next
				$oRS.MoveNext
			Next
		EndIf
		$oRS.close
	EndIf
	Return $RetAr
EndFunc

Func RunUserQuery()
	; check if part of the text in $txtQuery is selected
	Dim $OldClipValue = ClipGet()
	ClipPut("")
	ControlSend ( "SQL Server Tool", "", "[CLASS:Edit; INSTANCE:5]", "^c" )
	Dim $Query = ClipGet()
	ClipPut ( $OldClipValue ); restore the clipboard old value
	if StringLen ( $Query ) = 0 Then
		$Query = GUICtrlRead ( $txtQuery )
	EndIf
	Dim $arQryEditPos = ControlGetPos ( "SQL Server Tool", "", "[CLASS:Edit; INSTANCE:6]" )
	GUICtrlSetPos ( $txtQuery, 222, 33, $arQryEditPos [ 2 ] - 4, 60)
	if Not IsValidQuery ( $Query ) Then
		MsgBox(0, "SQLDBViewer", "The query" & @LF & $Query & @LF & "is not a valid query.")
		$TableData = $Query
		Return
	EndIf
	Dim $arTableData = RunQuery ( $Query, True )
	GUICtrlSetPos ( $txtQuery, 222, 16, $arQryEditPos [ 2 ] - 4, 98 )
	; fix the listview columns
	GUICtrlDelete ( $lvTable ); it's easier to just delete and recreate the listview than to clear it and remove its columns...
	; gather the data needed to calculate where the listview should be recreated
	Dim $arGBPos = ControlGetPos ( "SQL Server Tool", "", "[CLASS:Button; INSTANCE:6]" )
	$LVTable = GUICtrlCreateListView ( "", $arQryEditPos[0], $arQryEditPos[1] + $arQryEditPos[3], $arQryEditPos[2], $arGBPos[1] + $arGBPos[3] - $arQryEditPos[1] - $arQryEditPos[3] )
	GUICtrlSetResizing ( $lvTable, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM )
	GUISetState()  ; display the GUI including the new listview
	Dim $arCols = StringSplit ( $arTableData [ 1 ], @TAB )
	for $iCol = 1 to $arCols [ 0 ]	; create and populate the missing column headers
		_GUICtrlListView_AddColumn ( $LVTable, $arCols [ $iCol ] )
	Next
	; show the progressbar and resize the input control to make room for it
	GUICtrlSetState ( $pb, $GUI_SHOW )
	GUICtrlSetPos ( $pb, 222, 16, $arQryEditPos [ 2 ] - 4, 17 )
	GUICtrlSetPos ( $txtQuery, 222, 33, $arQryEditPos [ 2 ] - 4, 60)

	for $iRow = 2 to UBound ( $arTableData ) - 1	; row 1 is the column names, skip
		GUICtrlSetData ( $pb, $iRow * 100 / $arTableData [ 0 ] ); show progress
		GUICtrlCreateListViewItem ( StringReplace ( $arTableData [ $iRow ], @TAB, "|" ), $LVTable )
	Next
	; hide the progressbar and restore the former size to the input control
	GUICtrlSetState ( $pb, $GUI_HIDE )
	GUICtrlSetPos ( $txtQuery, 222, 16, $arQryEditPos [ 2 ] - 4, 98 )
	;create the buffer that will store the data for copying to the clipboard
	$TableData = _ArrayToString ( $arTableData, @CRLF )
	$TableData = StringRight ( $TableData, StringLen ( $TableData ) - StringInStr ( $TableData, @CRLF ) + 2 )
	$TableData = GUICtrlRead ( $txtQuery ) & @CRLF & "--------------" & @CRLF & $TableData
EndFunc

Func SaveINI()
	if StringInStr ( @CRLF & $IniBuf & @CRLF, @CRLF & $SelectedConnectionInformation & @CRLF ) = 0 Then
		if StringLen ( $IniBuf ) < 8 Then
			$IniBuf = $SelectedConnectionInformation
		Else
			$IniBuf &= @CRLF & $SelectedConnectionInformation
		EndIf
	EndIf
	FileDelete( @ScriptDir & "\SQLDBViewer.ini" )
	FileWrite ( @ScriptDir & "\SQLDBViewer.ini", $IniBuf )
EndFunc

Func ShowDBTables()
	Dim $arTableInfo = RunQuery ( "select TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.TABLES", False )
	if $arTableInfo [ 0 ] > 0 Then
		Dim $TableList = _ArrayToString ( $arTableInfo )
		$TableList = StringRight ( $TableList, StringLen ( $TableList ) - StringInStr ( $TableList, @CRLF ) - 2 );strip leading array size and CRLF
		if StringLeft ( $TableList, 1 ) = @TAB Then
			GUICtrlSetData ( $lbTables, StringReplace ( $TableList, @TAB, "" ) ); there is no schema name before the table, just display table names
		else
			GUICtrlSetData ( $lbTables, StringReplace ( $TableList, @TAB, "." ) ); the 1st column is the schema name, the tables should be of format schemaName.tableName
		EndIf
		DisplayTableListGroup ( $GUI_SHOW )
		$bCheckSelectedTable = True
		Return True
	Else
		MsgBox(0,"","No tables, or connection failed...")
		Return False
	EndIf
EndFunc

