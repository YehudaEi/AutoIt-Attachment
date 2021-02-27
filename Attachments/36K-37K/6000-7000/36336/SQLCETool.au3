#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Images\136.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; this testing program was created by Xavier Harel, 11/15/2011
; feel free to copy, plagiarize, improve, enjoy, etc.

#include <GUIConstantsEx.au3>
#Include <GuiListView.au3>
#Include <GuiListBox.au3>
#Include <GuiButton.au3>
#include <WindowsConstants.au3>
#Include <Misc.au3>
#include <EditConstants.au3>

#include <Array.au3>

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

Dim $InQuery = ""; optional input parameter value

; Form and control handles
Dim $FormHwnd, $FileInputID, $LBTablesID
Dim $ViewTableBtnID, $TableGBID, $QueryEditID, $LVTableID
Dim $OpenBtnID, $RunQryBtnID, $RecNumID
Dim $CopyDataBtnID, $PB, $SizeMoveBtnID, $LabelID
Dim $UndoBtn, $RedoBtn, $StoreUndoRedoBtn, $LockOpenChk

; Form-level variables
Dim $fGuiRolledUp = 0, $iTitleBarWidth = 150, $iTitleBarHeight = 20, $dllUser32 = DllOpen( "user32.dll" )
Dim $bResizeLockedOpen = False	; set by $LockOpenChk checkbox, window will only roll up if false
Dim $UndoRedoData [ 1 ]	; undo redo info storage array
$UndoRedoData [ 0 ] = ""

; debug
;Dim $DEBUG = True
Dim $DEBUG = False

HotKeySet("{ESC}", "OnExit")
HotKeySet ( "{F5}", "RunQryBtnOnClick" )

Main ()

Func Main ()
	$FormHwnd = GUICreate ( "SQL CE Tool", @DesktopWidth / 2 - 175, 200, 200, @DesktopHeight / 2 - 45, 0x00040000 + 0x00010000, 0x00000018 )	; $WS_SIZEBOX + $WS_MAXIMIZEBOX, WS_EX_ACCEPTFILES
	GUISetBkColor(0x00E0FFFF)	;window backgrd = light blue

	$LabelID = GUICtrlCreateLabel ( "SDF File", 2, 2, 200 )
	GUICtrlSetResizing ( $LabelID, $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKTOP )
	$FileInputID = GUICtrlCreateInput("", 2, 16, 300, 20)
	GUICtrlSetState ( $FileInputID, $GUI_DROPACCEPTED)
	GUICtrlSetResizing ( $FileInputID, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )

	$LockOpenChk = GUICtrlCreateCheckbox ( "Lock Open", 10, 36, 74, 20 )
	GUICtrlSetState ( $LockOpenChk, $GUI_CHECKED )
	GUICtrlSetOnEvent ( $LockOpenChk, "LockOpenChkOnClick" )
	GUICtrlSetResizing ( $LockOpenChk, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )

	$OpenBtnID = GUICtrlCreateButton ( "Open DB File", 226, 36, 74, 20 )
	GUICtrlSetOnEvent ( $OpenBtnID, "OpenBtnOnClick" )
	GUICtrlSetResizing ( $OpenBtnID, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )

	$LBTablesID = GUICtrlCreateList ( "", 310, 1, 150, 60 )
	GUICtrlSetResizing ( $LBTablesID, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )
	GUICtrlSetOnEvent ( $LBTablesID, "LBTablesOnClick" )

	;---Table Groupbox
	$TableGBID = GUICtrlCreateGroup ( "Table", 5, 62, 455, 115 )
	GUICtrlSetResizing ( $TableGBID, $GUI_DOCKBORDERS )

	$PB = GUICtrlCreateProgress ( 7, 70, 451, 17, 0x01 )	; 0x01 = $PBS_SMOOTH
	GUICtrlSetColor ( $PB, 0x00FF00 )
	GUICtrlSetState ( $PB, $GUI_HIDE )
	GUICtrlSetResizing ( $PB, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT )

	$RunQryBtnID = GUICtrlCreateButton ( "Run Query", 60, 70, 90, 20 )
	GUICtrlSetResizing ( $RunQryBtnID, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )
	_GUICtrlButton_SetImage ( $RunQryBtnID, @ScriptDir & "\images\1981.ico" )
	GUICtrlSetOnEvent ( $RunQryBtnID, "RunQryBtnOnClick" )
	GUICtrlSetState ( $RunQryBtnID, $GUI_HIDE )

	$CopyDataBtnID = GUICtrlCreateButton ( "Copy Data", 155, 70, 70, 20 )
	GUICtrlSetOnEvent ( $CopyDataBtnID, "CopyDataBtnOnClick" )
	GUICtrlSetState ( $CopyDataBtnID, $GUI_HIDE )
	GUICtrlSetResizing ( $CopyDataBtnID, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$UndoBtn = GUICtrlCreateButton ( "U", 5, 75, 16, 15 )
	GUICtrlSetOnEvent ( $UndoBtn, "UndoBtnOnClick" )
	GUICtrlSetState ( $UndoBtn, $GUI_HIDE + $GUI_DISABLE )
	GUICtrlSetResizing ( $UndoBtn, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$RedoBtn = GUICtrlCreateButton ( "R", 22, 75, 16, 15 )
	GUICtrlSetOnEvent ( $RedoBtn, "RedoBtnOnClick" )
	GUICtrlSetState ( $RedoBtn, $GUI_HIDE + $GUI_DISABLE )
	GUICtrlSetResizing ( $RedoBtn, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$StoreUndoRedoBtn = GUICtrlCreateButton ( "S", 42, 75, 16, 15 )
	GUICtrlSetOnEvent ( $StoreUndoRedoBtn, "StoreUndoRedoBtnOnClick" )
	GUICtrlSetState ( $StoreUndoRedoBtn, $GUI_HIDE )
	GUICtrlSetResizing ( $StoreUndoRedoBtn, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$RecNumID = GUICtrlCreateLabel ( "", 240, 75, 200, 18 )
	GUICtrlSetState ( $RecNumID, $GUI_HIDE )
	GUICtrlSetResizing ( $RecNumID, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$QueryEditID = GUICtrlCreateEdit ( "", 7, 88, 451, 32, 0x0100 + 0x004 + 0x1000 )	;$ES_NOHIDESEL+$ES_MULTILINE+$ES_WANTRETURN
	GUICtrlSetState ( $QueryEditID, $GUI_HIDE )
	GUICtrlSetResizing ( $QueryEditID, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT )

	$LVTableID = GUICtrlCreateListView ( "", 7, 120, 451, 57 )
	GUICtrlSetState ( $LVTableID, $GUI_HIDE )

	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

	GUICtrlSetState ( $TableGBID, $GUI_HIDE )
	;---End Table Groupbox

	GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

	;GUIRegisterMsg( $WM_ACTIVATE, "OnWM_ACTIVATEMsg" )

	GUISetState()  ; display the GUI

	ReadInputParms ()	; in case this was started from a double click on an sdf file in explorer


	While 1
		Sleep(500)
		if StringLen ( $InQuery ) > 0 Then
			RunInputQuery()
			$InQuery = ""	; make sure this does not run again and again
		EndIf
		ResizeLVTable ()
		Sleep( 200 )
		Local $mPos = MouseGetPos()
		Local $wPos = WinGetPos( $FormHwnd )
		If $fGuiRolledUp Then
			If $mPos[0] > $wPos[0] And $mPos[0] < $wPos[0] + $iTitleBarWidth _
				And $mPos[1] > $wPos[1] And $mPos[1] < $wPos[1] + $iTitleBarHeight Then
				RollGuiDown( $FormHwnd )
			EndIF
		Else
			DoTooltip()
		EndIf
	WEnd

	GUIRegisterMsg( $WM_ACTIVATE, "" )
	GUIDelete( $FormHwnd )
	Exit
EndFunc

;======================================
;---------- Event Functions -----------
;======================================

Func CopyDataBtnOnClick ()
	Dim $ClipboardData = RunCEQuery ( GUICtrlRead ( $QueryEditID ), GUICtrlRead ( $FileInputID ) )
	ClipPut ( $ClipboardData )
EndFunc

;-------------------

Func LBTablesOnClick ()
Dim $SelectedTable = ControlCommand ("SQL CE Tool", "", "[CLASS:ListBox; INSTANCE:1]", "GetCurrentSelection", '')
Dim $DBFileName = GUICtrlRead ( $FileInputID )
Dim $Query = "Select * from " & $SelectedTable
	if $SelectedTable = "" Or $DBFileName = "" Then Return
	ShowTableGroup ( True )
	GUICtrlSetData ( $QueryEditID, $Query )
	PopulateTable ( $Query, $DBFileName )
EndFunc

;-------------------

Func LockOpenChkOnClick ()
	if GUICtrlRead ( $LockOpenChk ) = $GUI_CHECKED Then
		;$bResizeLockedOpen = True
		GUIRegisterMsg( $WM_ACTIVATE, "" )
	Else
		;$bResizeLockedOpen = False
		GUIRegisterMsg( $WM_ACTIVATE, "OnWM_ACTIVATEMsg" )
	EndIf
EndFunc

Func OnExit ()
	if WinActive ( "SQL CE Tool" ) Then Exit
EndFunc

;-------------------

Func OnWM_ACTIVATEMsg ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $FormHwnd
			If Not $wParam Then
				If Not $fGuiRolledUp Then ;And Not $bResizeLockedOpen Then
					RollGuiUp( $FormHwnd )
				EndIf
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

Func OpenBtnOnClick ()
Dim $DBFileName = GUICtrlRead ( $FileInputID )
	if $DBFileName = "" Then Return
	if StringRight ( StringLower ( $DBFileName ), 4 ) <> ".sdf" then
		MsgBox ( 0, "LBTablesOnClick()", "Invalid .sdf file, exiting..." )
		GUICtrlSetData ( $FileInputID, "" )
		_GUICtrlListBox_ResetContent ( $LBTablesID )
		ShowTableGroup ( False )
		Return
	EndIf
Dim $TableList = RunCEQuery ( "SELECT table_name FROM INFORMATION_SCHEMA.TABLES", $DBFileName )
	if $TableList = "" Then Return
	GUICtrlSetData ( $LBTablesID, "|" & StringReplace ( StringReplace ( $TableList, @TAB, "" ), @CRLF, "|" ) )
	GUICtrlSetState ( $ViewTableBtnID, $GUI_SHOW )
EndFunc

;-------------------

Func RedoBtnOnClick ()
	_ArrayPush ( $UndoRedoData, $UndoRedoData [ UBound ( $UndoRedoData ) - 1 ], 1 )	; last $UndoRedoData [ UBound ( $UndoRedoData ) - 1 ] is moved to the start of the array, becomes $UndoRedoData [ 0 ], the other items go up by a notch.
	GUICtrlSetData ( $QueryEditID, $UndoRedoData [ 0 ] )
	GUICtrlSetState ( $UndoBtn,  $GUI_ENABLE )
	if $DEBUG Then ConsoleWrite ( @LF & "Redo action, now array contains" & @LF & _ArrayToString($UndoRedoData, @LF) & @LF & "---End Array---" )
EndFunc

;-------------------

Func RunQryBtnOnClick ()
	if Not WinActive ( "SQL CE Tool" ) Then Return
	Dim $Query = GUICtrlRead ( $QueryEditID )
	if $Query = "" then Return
	ClearColumns ()
	PopulateTable ( $Query, GUICtrlRead ( $FileInputID ) )
EndFunc

;-------------------

Func StoreUndoRedoBtnOnClick ()
	Dim $QueryData = GUICtrlRead ( $QueryEditID )
	if StringLen ( $QueryData ) = 0 then
		If $DEBUG Then ConsoleWrite ( "will not store empty string" )
		Return	; don't store an empty string
	EndIf
	if UBound ( $UndoRedoData ) = 1 and $UndoRedoData [ 0 ] = "" Then
		$UndoRedoData [ 0 ] = $QueryData	; get rid of array initialization empty string
		GUICtrlSetState ( $UndoBtn,  $GUI_ENABLE )	; can undo
		if $DEBUG Then ConsoleWrite ( @LF & "Store action, stored " & @LF & $QueryData & @LF & ", now array contains" & @LF & _ArrayToString ( $UndoRedoData, @LF ) & @LF & "---End Array---" )
		Return
	ElseIf $UndoRedoData [ 0 ] = $QueryData Then
		If $DEBUG Then ConsoleWrite ( "will not store dupe string" )
		Return	; don't store again and again the same string
	EndIf
	ReDim $UndoRedoData [ UBound ( $UndoRedoData ) + 1 ]
	_ArrayPush ( $UndoRedoData, $QueryData, 1 )	; add to start of array
	GUICtrlSetState ( $UndoBtn,  $GUI_ENABLE )	; can undo
	if $DEBUG Then ConsoleWrite ( @LF & "Store action, stored " & @LF & $QueryData & @LF & ", now array contains" & @LF & _ArrayToString ( $UndoRedoData, @LF ) & @LF & "---End Array---" )
EndFunc

;-------------------

Func UndoBtnOnClick ()
	_ArrayPush ( $UndoRedoData, $UndoRedoData [ 0 ], 0 )	; move $UndoRedoData [ 0 ] to the end of the array, the other elements move down by a notch
	GUICtrlSetData ( $QueryEditID, $UndoRedoData [ 0 ] )
	GUICtrlSetState ( $RedoBtn,  $GUI_ENABLE )	; can redo
	if $DEBUG Then ConsoleWrite ( @LF & "Undo action, now array contains" & @LF & _ArrayToString($UndoRedoData, @LF) & @LF & "---End Array---" )
EndFunc

;======================================
;--------- Helper Functions -----------
;======================================

Func ClearColumns ()
	Dim $ColumnCount = _GUICtrlListView_GetColumnCount ( $LVTableID )
	if $ColumnCount > 1 Then
		_GUICtrlListView_SetColumn ( $LVTableID, 0, "" )
		for $iCol = $ColumnCount to 1 Step -1
			_GUICtrlListView_DeleteColumn ( $LVTableID, $iCol )
		Next
	EndIf
EndFunc

;-------------------

Func DoTooltip ()
	Local $mPos = MouseGetPos()	; get the mouse cursor position relative to top left screen corner into array $mPos
	Local $wPos = WinGetPos( $FormHwnd )	; get the window top left corner position into array $wPos
	if $mPos [1] > 95 + $wPos [ 1 ] And  $mPos [ 1 ] < 110 + $wPos [ 1 ] Then
		if $mPos [0] > 5 + $wPos [ 0 ] And  $mPos [ 0 ] < 20 + $wPos [ 0 ] Then
			; the mouse cursor is on the Undo button
			ToolTip ( "Undo", $mPos[0], $mPos[1] )
		ElseIf $mPos [0] > 25 + $wPos [ 0 ] And  $mPos [ 0 ] < 40 + $wPos [ 0 ] Then
			; the mouse cursor is on the Redo button
			ToolTip ( "Redo", $mPos[0], $mPos[1] )
		ElseIf $mPos [0] > 45 + $wPos [ 0 ] And  $mPos [ 0 ] < 60 + $wPos [ 0 ] Then
			; the mouse cursor is on the StoreUndoRedoInfo button
			ToolTip ( "Store Undo-Redo Information", $mPos[0], $mPos[1] )
		Else
			ToolTip ( "" )	; hide tooltip
		EndIf
	ElseIf $mPos [1] > 56 + $wPos [ 1 ] And  $mPos [ 1 ] < 77 + $wPos [ 1 ] _
		And $mPos [0] > 10 + $wPos [ 0 ] And  $mPos [ 0 ] < 84 + $wPos [ 0 ] _
		Then
		ToolTip ( "If checked, this window will not roll up when focus is lost", $mPos[0], $mPos[1] )
	ElseIf $mPos [1] > 21 + $wPos [ 1 ] And  $mPos [ 1 ] < 80 + $wPos [ 1 ] _
		And $mPos [0] > 310 + $wPos [ 0 ] And  $mPos [ 0 ] < 460 + $wPos [ 0 ] _
		Then
		ToolTip ( "Tables are listed here. To display a table's contents, select the table.", $mPos[0], $mPos[1] )
	Else
		ToolTip ( "" )
	EndIf
EndFunc

;-------------------

Func PopulateTable ( $Query, $DBFileName )
Dim $TableData, $arLines
	GUICtrlSetData ( $RecNumID, "Querying the data..." )
	$TableData = RunCEQuery ( $Query, $DBFileName, True )	; run the query, true = first row returned is the column names
	; trim leading CRLFs
	While StringLeft ( $TableData, 2 ) = @CRLF
		$TableData = StringRight ( $TableData, StringLen ( $TableData ) - 2 )
	WEnd
	$arLines = StringSplit ( $TableData, @CRLF, 1 )
	; check 1st line to see how many columns are needed
	GUICtrlDelete ( $LVTableID )
	Dim $arQryEditPos = ControlGetPos ( "SQL CE Tool", "", "[CLASS:Edit; INSTANCE:2]" )
	Dim $arGBPos = ControlGetPos ( "SQL CE Tool", "", "[CLASS:Button; INSTANCE:2]" )
	$LVTableID = GUICtrlCreateListView ( "", $arQryEditPos[0], $arQryEditPos[1] + $arQryEditPos[3], $arQryEditPos[2], $arGBPos[1] + $arGBPos[3] - $arQryEditPos[1] - $arQryEditPos[3] )
	GUISetState()  ; display the GUI
	Dim $arCols = StringSplit ( $arLines [ 1 ], @TAB )
	for $iCol = 1 to $arCols [ 0 ]	; create and populate the missing column headers
		_GUICtrlListView_AddColumn ( $LVTableID, $arCols [ $iCol ] )
	Next
	GUICtrlSetState ( $PB, $GUI_SHOW )
	GUICtrlSetState ( $RunQryBtnID, $GUI_HIDE )
	GUICtrlSetState ( $CopyDataBtnID, $GUI_HIDE )
	GUICtrlSetState ( $RecNumID, $GUI_HIDE )
	GUICtrlSetState ( $UndoBtn, $GUI_HIDE )
	GUICtrlSetState ( $RedoBtn, $GUI_HIDE )
	GUICtrlSetState ( $StoreUndoRedoBtn, $GUI_HIDE )
	Sleep ( 200 )	; allow painting time
	; populate each row
	for $iRow = 2 to $arLines [ 0 ]
		GUICtrlSetData ( $PB, $iRow * 100 / $arLines [ 0 ] )
		GUICtrlCreateListViewItem ( StringReplace ( $arLines [ $iRow ], @TAB, "|" ), $LVTableID )
	Next
	GUICtrlSetState ( $PB, $GUI_HIDE )
	GUICtrlSetState ( $RunQryBtnID, $GUI_SHOW )
	GUICtrlSetState ( $CopyDataBtnID, $GUI_SHOW )
	GUICtrlSetState ( $RecNumID, $GUI_SHOW )
	GUICtrlSetState ( $UndoBtn, $GUI_SHOW )
	GUICtrlSetState ( $RedoBtn, $GUI_SHOW )
	GUICtrlSetState ( $StoreUndoRedoBtn, $GUI_SHOW )

	GUICtrlSetData ( $RecNumID, $arLines [ 0 ] - 1 & " records were returned" )
	;StoreUndoRedoBtnOnClick ()	; store initial query
EndFunc

;-------------------

Func ReadInputParms ()
	if $CmdLine[0] = 0 Then Return
	if StringInStr ( $CmdLineRaw, " /query=" ) > 0 Then
		$InQuery = StringRight ( $CmdLineRaw, StringLen ( $CmdLineRaw ) - StringInStr ( StringLower ( $CmdLineRaw ), " /query=" ) - 7 )
		$CmdLineRaw = StringLeft ( $CmdLineRaw, StringInStr ( StringLower ( $CmdLineRaw ), " /query=" ) - 1 )
	ElseIf StringInStr ( $CmdLineRaw, " -query=" ) > 0 Then
		$InQuery = StringRight ( $CmdLineRaw, StringLen ( $CmdLineRaw ) - StringInStr ( StringLower ( $CmdLineRaw ), " -query=" ) - 7)
		$CmdLineRaw = StringLeft ( $CmdLineRaw, StringInStr ( StringLower ( $CmdLineRaw ), " /query=" ) - 1 )
	EndIf
	Dim $InputData = StringReplace ( $CmdLineRaw, """", "")	; strip quotes
	if StringRight ( StringLower ( $InputData ), 4 ) = ".sdf" Then
		GUICtrlSetData($FileInputID, $InputData)
		OpenBtnOnClick ()
	ElseIf $InputData = "-i" or $InputData = "/i" Then	; this was only tested under windows xp sp3
		RegWrite ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\OpenWithList", "a", "REG_SZ", "SQLCETool.exe" )
		RegWrite ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\OpenWithList", "MRUList", "REG_SZ", "a" )
		RegWrite ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\UserChoice", "ProgID", "REG_SZ", "Applications\SQLCETool.exe" )
		RegWrite ( "HKEY_CLASSES_ROOT\Applications\SQLCETool.exe\shell\open\command", "", "REG_SZ", '"' & @ScriptFullPath & '" "%1"' )
		RegWrite ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf", "Application", "REG_SZ", "SQLCETool.exe" )
		Exit
	ElseIf $InputData = "-u" or $InputData = "/u" Then	; this was only tested under windows xp sp3
		RegDelete ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\OpenWithList", "a" )
		RegDelete ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\OpenWithList", "MRUList" )
		RegDelete ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf\UserChoice", "ProgID" )
		RegDelete ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sdf", "Application" )
		RegWrite ( "HKEY_CLASSES_ROOT\Applications\SQLCETool.exe\shell\open\command", "", "REG_SZ", "" )
		Exit
	EndIf
EndFunc

;-------------------

Func ResizeLVTable ()
	if ControlCommand ( "SQL CE Tool", "", "[CLASS:SysListView32; INSTANCE:1]", "IsVisible", "" ) = 0 Then return
	Dim $arQryEditPos = ControlGetPos ( "SQL CE Tool", "", "[CLASS:Edit; INSTANCE:2]" )
	Dim $arWinSize = WinGetClientSize ( "SQL CE Tool" )
	Dim $arQryLVPos = ControlGetPos ( "SQL CE Tool", "", "[CLASS:SysListView32; INSTANCE:1]" )
	if $arQryEditPos[0] <> $arQryLVPos _
		Or $arQryEditPos[1] + $arQryEditPos[3] <> $arQryLVPos[1] _
		Or $arQryEditPos[2] <> $arQryLVPos[2] _
		Or $arWinSize[1] - $arQryEditPos[1] - $arQryEditPos[3] <> $arQryEditPos[3] _
		Then
		GUICtrlSetPos ( $LVTableID, $arQryEditPos[0], $arQryEditPos[1] + $arQryEditPos[3], $arQryEditPos[2], $arWinSize[1] - $arQryEditPos[1] - $arQryEditPos[3] )
	EndIf
EndFunc

;-------------------

Func RollGuiUp( $hWnd )
	Global $hRollGuiUp
	Local $wPos = WinGetPos( $hWnd )
	Local $sBarName = WinGetTitle ( $hWnd )
	$hRollGuiUp = GUICreate( $sBarName, $iTitleBarWidth, 0, $wPos[0], $wPos[1], BitXOR ( $GUI_SS_DEFAULT_GUI, $WS_SYSMENU ), BitOR ( $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST ) )
	GUISetState( @SW_SHOW )
	  DllCall( $dllUser32, "int", "AnimateWindow", "hwnd", $FormHwnd, "int", 200, "long", "0x3000A" )
	$fGuiRolledUp = 1
EndFunc

;-------------------

Func RollGuiDown( $hWnd )
	Global $hRollGuiUp
	  DllCall( $dllUser32, "int", "AnimateWindow", "hwnd", $FormHwnd, "int", 200, "long", "0x20005" )
	WinActivate( $hWnd )
	GUIDelete( $hRollGuiUp )
	$fGuiRolledUp = 0
EndFunc

;-------------------

Func RunCEQuery ( $Query, $DBFile, $bReturnColumns = False )
Dim $intNbLignes
Dim $Ret = ""
	Dim $sqlCon = ObjCreate("ADODB.Connection")
	$sqlCon.Open ( "Provider=Microsoft.SQLSERVER.CE.OLEDB.4.0;Data Source=" & $DBFile )
	Dim $oRS = ObjCreate ( "ADODB.Recordset" )
	$oRS.open ( $Query, $sqlCon, 3, -1)	; adOpenStatic, lock type unspecified
	$intNbLignes = $oRS.recordCount
	if $intNbLignes > 0 or StringLen ( $DBFile ) > 0 Then
		if $bReturnColumns Then
			for $iField = 0 to $oRS.Fields.Count - 1
				if $iField = 0 Then
					$Ret = $Ret & @CRLF & $oRS.Fields.Item(0).name
				Else
					$Ret = $Ret & @TAB & $oRS.Fields.Item($iField).name
				EndIf
			Next
		EndIf
		if $oRS.EOF And $oRS.BOF Then Return $Ret
		$oRS.MoveFirst
		Dim $iRec = 1
		While not $oRS.EOF
			for $iField = 0 to $oRS.Fields.Count - 1
				if $iField = 0 Then
					$Ret = $Ret & @CRLF & $oRS.Fields.Item(0).value
				Else
					$Ret = $Ret & @TAB & $oRS.Fields.Item($iField).value
				EndIf
			Next
			$oRS.MoveNext
		WEnd
		if StringLen ( $Ret ) > 2 Then $Ret = StringRight ( $Ret, StringLen ( $Ret ) - 2 )
	EndIf
	$oRS.close
	Return $Ret
EndFunc

;-------------------

Func RunInputQuery()
Dim $DBFileName = GUICtrlRead ( $FileInputID )
Dim $SelectedTable = ""
	if StringLeft ( StringLower ( $InQuery ), 7 ) = "select " Then
		Dim $QrySubstring = StringRight ( $InQuery, StringLen ( $InQuery ) - StringInStr ( StringLower ( $InQuery ), " from " ) - 5 )
		Dim $iOffs = StringInStr ( $SelectedTable, " " )
		if $iOffs > 0 Then
			$SelectedTable = StringLeft ( $QrySubstring, StringInStr ( $SelectedTable, " " ) )
		Else
			$SelectedTable = $QrySubstring
		EndIf
	EndIf
	if StringLen ( $SelectedTable ) = 0 Then Return;insert or update are not supported in command line
	ShowTableGroup ( True )
	GUICtrlSetData ( $QueryEditID, $InQuery )
	PopulateTable ( $InQuery, $DBFileName )
EndFunc

;-------------------

Func ShowTableGroup ( $bShow )
Dim $Mode
	if $bShow Then
		$Mode = $GUI_SHOW
	Else
		$Mode = $GUI_HIDE
	EndIf
	GUICtrlSetState ( $RunQryBtnID, $Mode )
	GUICtrlSetState ( $TableGBID, $Mode )
	GUICtrlSetState ( $QueryEditID, $Mode )
	GUICtrlSetState ( $LVTableID, $Mode )
	GUICtrlSetState ( $RecNumID, $Mode )
	GUICtrlSetState ( $CopyDataBtnID, $Mode )
EndFunc

;-------------------

Func StringToken ( $In, $Delim, $1bIndex )
	Dim $arToks = StringSplit ( $In, $Delim, 1 )
	if $1bIndex = "last" Then
		Return $arToks [ $arToks [ 0 ] ]
	Else
		if $arToks [ 0 ] >= $1bIndex Then Return $arToks [ $1bIndex ]
	EndIf
EndFunc
