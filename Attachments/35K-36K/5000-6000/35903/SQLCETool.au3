#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Images\136.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#Include <GuiListView.au3>
#Include <GuiListBox.au3>
#Include <GuiButton.au3>
#include <WindowsConstants.au3>
#Include <Misc.au3>
#include <EditConstants.au3>

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

; Form and control handles
Dim $FormHwnd, $FileInputID, $LBTablesID
Dim $ViewTableBtnID, $TableGBID, $QueryEditID, $LVTableID
Dim $OpenBtnID, $RunQryBtnID, $RecNumID
Dim $CopyDataBtnID, $PB, $SizeMoveBtnID, $LabelID
Dim $fGuiRolledUp = 0, $iTitleBarWidth = 150, $iTitleBarHeight = 20, $dllUser32 = DllOpen( "user32.dll" )

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

	$OpenBtnID = GUICtrlCreateButton ( "Open DB File", 226, 36, 74, 20 )
	GUICtrlSetOnEvent ( $OpenBtnID, "OpenBtnOnClick" )
	GUICtrlSetResizing ( $OpenBtnID, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )

	$LBTablesID = GUICtrlCreateList ( "", 310, 1, 150, 60 )
	GUICtrlSetResizing ( $LBTablesID, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE )
	GUICtrlSetOnEvent ( $LBTablesID, "LBTablesOnClick" )

	;---Table Groupbox
	$TableGBID = GUICtrlCreateGroup ( "Table", 5, 62, 455, 115 )
	GUICtrlSetResizing ( $TableGBID, $GUI_DOCKBORDERS )

	$PB = GUICtrlCreateProgress ( 7, 70, 451, 17, 0x01 )	; $PBS_SMOOTH
	GUICtrlSetColor ( $PB, 0x00FF00 )
	GUICtrlSetState ( $PB, $GUI_HIDE )
	GUICtrlSetResizing ( $PB, $GUI_DOCKBORDERS )

	$RunQryBtnID = GUICtrlCreateButton ( "Run Query", 50, 70, 90, 20 )
	GUICtrlSetResizing ( $RunQryBtnID, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )
	_GUICtrlButton_SetImage ( $RunQryBtnID, @ScriptDir & "\images\1981.ico" )
	GUICtrlSetOnEvent ( $RunQryBtnID, "RunQryBtnOnClick" )
	GUICtrlSetState ( $RunQryBtnID, $GUI_HIDE )

	$CopyDataBtnID = GUICtrlCreateButton ( "Copy Data", 145, 70, 90, 20 )
	GUICtrlSetOnEvent ( $CopyDataBtnID, "CopyDataBtnOnClick" )
	GUICtrlSetState ( $CopyDataBtnID, $GUI_HIDE )
	GUICtrlSetResizing ( $CopyDataBtnID, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT )

	$RecNumID = GUICtrlCreateLabel ( "", 240, 70, 200, 18 )
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

	GUIRegisterMsg( $WM_ACTIVATE, "OnWM_ACTIVATEMsg" )

	GUISetState()  ; display the GUI

	ReadInputParms ()	; in case this was started from a double click on an sdf file in explorer

	While 1
		Sleep(1000)
		ResizeLVTable ()
		If $fGuiRolledUp Then
			Sleep( 200 )
			Local $mPos = MouseGetPos()
			Local $wPos = WinGetPos( $FormHwnd )
			If $mPos[0] > $wPos[0] And $mPos[0] < $wPos[0] + $iTitleBarWidth _
				And $mPos[1] > $wPos[1] And $mPos[1] < $wPos[1] + $iTitleBarHeight Then
				RollGuiDown( $FormHwnd )
			EndIF
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

Func OnExit ()
	Exit
EndFunc

;-------------------

Func OnWM_ACTIVATEMsg ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
	  Case $FormHwnd
	   If Not $wParam Then
		If Not $fGuiRolledUp Then
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

Func RunQryBtnOnClick ()
Dim $Query = GUICtrlRead ( $QueryEditID )
	if $Query = "" then Return
	ClearColumns ()
	PopulateTable ( $Query, GUICtrlRead ( $FileInputID ) )
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

	GUICtrlSetData ( $RecNumID, $arLines [ 0 ] - 1 & " records were returned" )
EndFunc

;-------------------

Func ReadInputParms ()
	if $CmdLine[0] = 0 Then Return
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
	GUICtrlSetPos ( $LVTableID, $arQryEditPos[0], $arQryEditPos[1] + $arQryEditPos[3], $arQryEditPos[2], $arWinSize[1] - $arQryEditPos[1] - $arQryEditPos[3] )
EndFunc

;-------------------

Func RollGuiUp( $hWnd )
	Global $hRollGuiUp
	Local $wPos = WinGetPos( $hWnd )
	Local $sBarName = WinGetTitle ( $hWnd )
	$hRollGuiUp = GUICreate( $sBarName, $iTitleBarWidth, 0, $wPos[0], $wPos[1], BitXOR( $GUI_SS_DEFAULT_GUI, $WS_SYSMENU ), BitOR( $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST ) )
	GUISetState( @SW_SHOW )
	  DllCall( $dllUser32, "int", "AnimateWindow", "hwnd", $FormHwnd, "int", 200, "long", "0x3000A" )
	$fGuiRolledUp = 1
EndFunc

Func RollGuiDown( $hWnd )
	Global $hRollGuiUp
	  DllCall( $dllUser32, "int", "AnimateWindow", "hwnd", $FormHwnd, "int", 200, "long", "0x20005" )
	WinActivate( $hWnd )
	GUIDelete( $hRollGuiUp )
	$fGuiRolledUp = 0
EndFunc

Func RunCEQuery ( $Query, $DBFile, $bReturnColumns = False )
Dim $intNbLignes
Dim $Ret = ""
	Dim $sqlCon = ObjCreate("ADODB.Connection")
	$sqlCon.Open("Provider=Microsoft.SQLSERVER.CE.OLEDB.4.0;Data Source=" & $DBFile)
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
