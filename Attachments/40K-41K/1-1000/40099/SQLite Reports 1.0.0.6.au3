#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SQLite2.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=SQL based Report Generator for SQLite databases
#AutoIt3Wrapper_Res_Description=SQLite Report Generator
#AutoIt3Wrapper_Res_Fileversion=1.0.0.6
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         GreenCan

	Other contributors:
	_ParseCSV: ProgAndy
	_DateCalc: Sean Hart <autoit@hartmail.ca>
	WM_NOTIFY() issue and some code optimization: jpm

	Script Function:
	SQL based Report Generator for SQLite databasess

	Known problem:
	None

	Updates:
	1.0.0.6:
		Bug fixes (thanks jpm)
		Better GUI windows management
		Excel export optimized
		_COMError implemented

#ce ----------------------------------------------------------------------------
#include <Misc.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <Date.au3>

If _Singleton(@ScriptName, 1) = 0 Then Exit
Opt("MustDeclareVars", 1)
Opt("TrayIconHide", 1) ; hide the tray Icon

; Initializes COM handler
;~ Global $oAppError ; COM Error handler
Global $oAppError = ObjEvent("AutoIt.Error", "_COMError")

Global $iDebug = 1
If Not @Compiled Then ConsoleWrite(@ScriptLineNumber & " Debug enabled" & @CR)

#region Declare
Const $iDark_Blue = 0x2601D3
Const $iLight_Green = 0xEAFFE8

; postion of main window at startup
Local $SM_VIRTUALWIDTH = 78
Global $VirtualDesktopWidth = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]


Global $Menu_ListView, $DoubleClicked, $iIndex = 1 ; _ArrayMenu() requires $Menu_ListView and $DoubleClicked to be declared as Global variables.
Global $ListDelimiter = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sList") ; Retrieve standard delimiter symbol
Global $sDecimal = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDecimal") ; decimal symbol
; GUI settings:
; _ArrayMenu
Global $iAM_Width = 400, $iAM_Height = 400, $iAM_Left = -1, $iAM_Top = -1, $iAM_OffsetWidth = Default, $iAM_OffsetHeight = Default
; Multiline GUI
Global $hGUI_Multiline, $View_Multiline, $ColName
Global $MultiLine_Width = 300, $MultiLine_Height = 300, $MultiLine_OffsetWidth = Default, $MultiLine_OffsetHeight = Default, $MultiLine_Left = 0, $MultiLine_Top = 0
; $SQLResultWindow GUI
Local $SQLResultWindow, $iLV_Width = 800, $iLV_Height = 400, $iLV_OffsetWidth = Default, $iLV_OffsetHeight = Default, $iLV_Left = -1, $iLV_Top = -1
; Vertical View
Global $GUI_VerticalView, $aVertView, $VertView_hListView, $bVerticalView_Resize, $VertView_Width = 250, $VertView_Height = 480, $VertView_OffsetWidth = 0, $VertView_OffsetHeight = 0, $VertView_Left = $VirtualDesktopWidth - $VertView_Width - 15, $VertView_Top = 0, $VerticalView_Copy, $bVerticalView_GUI = False
Global $iLastItem = -1, $iLastsubitemNR = -1 ; used in WM_NOTIfY2
Global $aNames ; Column titles
Global $Choice ; menu selected item
Global $FileHandle, $hListView
; Menu Loop vars
Local $aParameter, $Parameter1, $Parameter2, $lblParameter1, $lblParameter2, $TitleParams, $sSQL, $iIndex, $iKeeppreviousIndex = 0, $sRow, $size
Local $BtSQL, $BtClose, $BtExport, $DataBase, $hQuery, $aRow, $aResult, $Result, $Active_win, $To_Clip
#endregion Declare

#region ini
Local $iniFileName = @ScriptDir & "\SQLite Reports.ini"
If Not FileExists($iniFileName) Then Exit MsgBox(48, "Error", $iniFileName & " not found") ; startup error, keep the message
Global $Db = IniRead($iniFileName, "General", "Database", "-")
If Not FileExists(@ScriptDir & "\" & $Db) Then Exit MsgBox(48, "Error", "Database not found:" & @CR & @ScriptDir & "\" & $Db)
Global $sDbDateFormat = IniRead($iniFileName, "General", "DateFormat", "YYYY/MM/DD")

Local $_DesktopWidth = IniRead($iniFileName, "General", "DesktopWidth", 0) ; Desktop width of the previous session
If $_DesktopWidth = $VirtualDesktopWidth Then
	; same desktop width so we can use the stored window coordinates
	; _ArrayMenu
	$Result = IniRead($iniFileName, "General", "Menu", $iAM_Width & "," & $iAM_Height & "," & $iAM_Left & "," & $iAM_Top )
	$aResult = StringSplit($Result, ",")
	$iAM_Width = $aResult[1]
	$iAM_Height = $aResult[2]
	$iAM_Left = $aResult[3]
	$iAM_Top = $aResult[4]
	; Vertical View
	$Result = IniRead($iniFileName, "General", "VerticalView", $VertView_Width & "," & $VertView_Height & "," & $VertView_Left & "," & $VertView_Top )
	$aResult = StringSplit($Result, ",")
	$VertView_Width = $aResult[1]
	$VertView_Height = $aResult[2]
	$VertView_Left = $aResult[3]
	$VertView_Top = $aResult[4]
	; $SQLResultWindow (Listview)
	$Result = IniRead($iniFileName, "General", "SQLResultView", $iLV_Width & "," & $iLV_Height & "," & $iLV_Left & "," & $iLV_Top )
	$aResult = StringSplit($Result, ",")
	$iLV_Width = $aResult[1]
	$iLV_Height = $aResult[2]
	$iLV_Left = $aResult[3]
	$iLV_Top = $aResult[4]
	; Multiline GUI
	$Result = IniRead($iniFileName, "General", "MultilineView", $MultiLine_Width & "," & $MultiLine_Height & "," & $MultiLine_Left & "," & $MultiLine_Top )
	$aResult = StringSplit($Result, ",")
	$MultiLine_Width = $aResult[1]
	$MultiLine_Height = $aResult[2]
	$MultiLine_Left = $aResult[3]
	$MultiLine_Top = $aResult[4]
EndIf

Global $aSQL = IniReadSection($iniFileName, "SQL")
Global $aReportTitles = IniReadSection($iniFileName, "Titles")
Global $aParameters = IniReadSection($iniFileName, "Parameters")
; make a single array out of the multi-dimentional array
Dim $aMenu[$aReportTitles[0][0]]
For $i = 0 To $aReportTitles[0][0] - 1
	$aMenu[$i] = $aReportTitles[$i + 1][1]
Next
#endregion ini

#region SQL Startup
;~ If @AutoItX64 Then
;~ 	Local $sSQliteDll = _SQLite_Startup(@ScriptDir & "SQLite3_x64.dll")
;~ 	If @error > 0 Then Exit MsgBox(16, "SQLite Error", "SQLite3_x64.dll Can't be Loaded!")
;~ Else
;~ 	Local $sSQliteDll = _SQLite_Startup(@ScriptDir & "\SQLite3.dll")
;~ 	If @error > 0 Then Exit MsgBox(16, "SQLite Error", "SQLite3.dll Can't be Loaded!")
;~ EndIf
Local $sSQliteDll = _SQLite_Startup()
If Not @Compiled Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ") : SQLite3.dll Loaded " & $sSQliteDll & " (" & _SQLite_LibVersion() & ")" & @CRLF)
#endregion SQL Startup

While 1 ; Menu loop
	$Choice = _ArrayMenu($aMenu, "Reports", "Select", $iIndex - 1, $iAM_Width, $iAM_Height, $iAM_Left, $iAM_Top)
	If $Choice == "" Then _Exit()
	$iIndex = _ArraySearch($aReportTitles, $Choice, 1, 0, 0, 0, 1, 1) ; find selected element number
	; If Not @Compiled Then ConsoleWrite(@ScriptLineNumber & " You selected: " & $Choice  & " ==> " & $iIndex & " ==> " & $aSQL[$iIndex][1] & @CR)

	#region ini debug
	; if debug is enabled, reread the essential SQL sections
	; this will allow to modify the SQL sections, titles and parameters and run the report without having to restart the script
	If $iDebug Then
		$aSQL = IniReadSection($iniFileName, "SQL")
		$aReportTitles = IniReadSection($iniFileName, "Titles")
		$aParameters = IniReadSection($iniFileName, "Parameters")

		; make a single array out of the multi-dimentional array
		Dim $aMenu[$aReportTitles[0][0] + 1]
		For $i = 0 To $aReportTitles[0][0] - 1
			$aMenu[$i] = $aReportTitles[$i + 1][1]
		Next
	EndIf
	#endregion ini debug

	#region Parameters
	; string parameters, maximum 2: %1% and %2%
	; date parameters: %d1% and %d2%
	If StringInStr($aSQL[$iIndex][1], "1%") > 0 Then ; capture if SQL contains dynamic parameters
		If $iIndex <> $iKeeppreviousIndex Then ; remember the parameter only if the selection does not change
			$Parameter1 = ""
			$Parameter2 = ""
		EndIf

		If StringInStr($aSQL[$iIndex][1], "%2%") > 0 Then
			; 2 string parameters
			$lblParameter1 = StringTrimRight($aParameters[$iIndex][1], StringLen($aParameters[$iIndex][1]) - StringInStr($aParameters[$iIndex][1], ",") + 1)
			$lblParameter2 = StringTrimLeft($aParameters[$iIndex][1], StringLen($lblParameter1) + 1)

			$aParameter = _InputBox("Parameters", _
					StringTrimRight($lblParameter1, StringLen($lblParameter1) - StringInStr($lblParameter1, "|") + 1) & ": ", $Parameter1, "", StringTrimLeft($lblParameter1, StringInStr($lblParameter1, "|")), _
					StringTrimRight($lblParameter2, StringLen($lblParameter2) - StringInStr($lblParameter2, "|") + 1) & ": ", $Parameter2, "", StringTrimLeft($lblParameter2, StringInStr($lblParameter2, "|")), _
					Default , Default , $iAM_Left + ($iAM_Width - 250)/2, $iAM_Top + ($iAM_Height - 170)/2 )
			If @error = 1 Then ContinueLoop ; Escape
			$Parameter1 = $aParameter[0]
			$Parameter2 = $aParameter[1]
			$sSQL = StringReplace($aSQL[$iIndex][1], "%1%", $aParameter[0])
			$sSQL = StringReplace($sSQL, "%2%", $aParameter[1])
			$TitleParams = " - " & StringTrimRight($lblParameter1, StringLen($lblParameter1) - StringInStr($lblParameter1, "|") + 1) & " : " & $Parameter1 & " - " & _
					StringTrimRight($lblParameter2, StringLen($lblParameter2) - StringInStr($lblParameter2, "|") + 1) & " : " & $Parameter2 & " "
		ElseIf StringInStr($aSQL[$iIndex][1], "%1%") > 0 Then
			; 1 string parameter
			$lblParameter1 = $aParameters[$iIndex][1]

			$aParameter = _InputBox("Parameter", StringTrimRight($lblParameter1, StringLen($lblParameter1) - StringInStr($lblParameter1, "|") + 1) & ": ", $Parameter1, "", StringTrimLeft($lblParameter1, StringInStr($lblParameter1, "|")), _
				"", "", "", "", _
				Default , Default , $iAM_Left + ($iAM_Width - 250)/2, $iAM_Top + ($iAM_Height - 170)/2 )
			If @error = 1 Then ContinueLoop ; Escape
			$Parameter1 = $aParameter[0]
			$sSQL = StringReplace($aSQL[$iIndex][1], "%1%", $aParameter[0])
			$TitleParams = " - " & StringTrimRight($lblParameter1, StringLen($lblParameter1) - StringInStr($lblParameter1, "|") + 1) & " : " & $Parameter1
		ElseIf StringInStr($aSQL[$iIndex][1], "%d2%") > 0 Then
			; 2 date parameters
			$lblParameter1 = StringTrimRight($aParameters[$iIndex][1], StringLen($aParameters[$iIndex][1]) - StringInStr($aParameters[$iIndex][1], ",") + 1)
			$lblParameter2 = StringTrimLeft($aParameters[$iIndex][1], StringLen($lblParameter1) + 1)
			$aParameter = _InputDate($Parameter1, $Parameter2)
			If @error Then ContinueLoop ; Escape
			$Parameter1 = DateFormat($aParameter[1], $sDbDateFormat)
			$sSQL = StringReplace($aSQL[$iIndex][1], "%d1%", $Parameter1)
			$Parameter2 = DateFormat($aParameter[2], $sDbDateFormat)
			$sSQL = StringReplace($sSQL, "%d2%", $Parameter2)
			$TitleParams = " - From " & $Parameter1 & " to " & $Parameter2 & " [" & $aParameter[0] + 1 & " days] "
		Else
			; 1 date parameters
			$lblParameter1 = $aParameters[$iIndex][1]
			$aParameter = _InputDate($Parameter1, Default, False)
			If @error Then ContinueLoop ; Escape
			$Parameter1 = DateFormat($aParameter[1], $sDbDateFormat)
			$sSQL = StringReplace($aSQL[$iIndex][1], "%d1%", $Parameter1)
			$TitleParams = " - On " & $Parameter1

		EndIf
		$iKeeppreviousIndex = $iIndex
	Else
		$TitleParams = ""
		$sSQL = $aSQL[$iIndex][1]
	EndIf
	;If Not @Compiled Then ConsoleWrite ("SQL: " & $sSQL & @CRLF)
	#endregion Parameters

	; first open a new file
	$FileHandle = FileOpen(@TempDir & "\" & $Choice & ".csv", 2)
	If $FileHandle = -1 Then
		MsgBox(16, "Error", "Can't open file:" & @LF & @TempDir & "\" & $Choice & ".csv" & @LF & "Please check if the file is not in use!")
		ContinueLoop
	EndIf

	ToolTip("Creating Report, please wait", $iLV_Left + ($iLV_Width)/2, $iLV_Top + ($iLV_Height)/2, "Reports", 0, 2)

	#region SQL Open
	$DataBase = _SQLite_Open(@ScriptDir & "\" & $Db, $SQLITE_OPEN_READWRITE)
	If @error Then Exit MsgBox(16, "_SQLite_Open Error " & @error, "Can't Load Database " & @ScriptDir & "\" & $Db & @LF & "@extended " & @extended)
	#endregion SQL Open

	; Create Listview GUI
	$SQLResultWindow = GUICreate($Choice, $iLV_Width, $iLV_Height, $iLV_Left, $iLV_Top, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
	If $iLV_OffsetWidth = Default Then
		; remember the difference between the result of WinGetClientSize and the initial Width and Height of the GUI
		$size = WinGetClientSize($SQLResultWindow)
		$iLV_OffsetWidth = $iLV_Width - $size[0]
		$iLV_OffsetHeight = $iLV_Height - $size[1]
	EndIf
	$BtSQL = GUICtrlCreateButton('SQL', 5, $iLV_Height - 28, 85, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)

	$BtClose = GUICtrlCreateButton('Close', $iLV_Width - 90, $iLV_Height - 28, 85, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)

	$BtExport = GUICtrlCreateButton('Export Excel', $iLV_Width - 180, $iLV_Height - 28, 85, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)

	$hListView = GUICtrlCreateListView('', 0, 0, $iLV_Width, $iLV_Height - 30, Default, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	GUICtrlSetResizing($hListView, $GUI_DOCKBORDERS)
	GUISetIcon("SQLite2.ico", 0)
	; will display all records of an SQL

	$Result = _SQLite_Query(-1, $sSQL & ";", $hQuery)
	If $Result = $SQLITE_OK Then
		;If Not @Compiled Then ConsoleWrite("SELECT success" & @LF & @LF)
		; Set the Titles in the listview
		_SQLite_FetchNames($hQuery, $aNames) ; Read out Column Names
		If UBound($aNames) = 1 And $aNames[0] = "" Then
			ToolTip("")
			FileClose($FileHandle)
			GUIDelete($SQLResultWindow)
			MsgBox(64, "SQLite Info", "Command " & $sSQL & " performed")
			FileDelete(@TempDir & "\" & $Choice & ".csv")
			ContinueLoop
		Else
			ExportData($aNames)
			For $i = 0 To UBound($aNames) - 1
				_GUICtrlListView_InsertColumn($hListView, $i, $aNames[$i], 50)
			Next

			; Rows
			While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
				ExportData($aRow)
			WEnd
		EndIf
	Else
		ToolTip("")
		FileClose($FileHandle)
		If _SQLite_ErrMsg() = "not an error" Then ; command that does not return results but has not to be considered as an error
			GUIDelete($SQLResultWindow)
			MsgBox(64, "SQLite Info", "Command " & $sSQL & " performed")
			FileDelete(@TempDir & "\" & $Choice & ".csv")
			ContinueLoop
		Else
			GUIDelete($SQLResultWindow)
			MsgBox(48, "SQLite Error", "Error:  " & _SQLite_ErrMsg() & @CR & "Query:  " & $sSQL)
			FileDelete(@TempDir & "\" & $Choice & ".csv")
			ContinueLoop
		EndIf
	EndIf

	#region SQL Close
	_SQLite_Close()
	#endregion SQL Close

	FileClose($FileHandle)

	$aResult = _ParseCSV(@TempDir & "\" & $Choice & ".csv", $ListDelimiter) ; convert csv into an array to populate the Listview

	If UBound($aResult) = 0 Then
		ToolTip("")
		GUIDelete($SQLResultWindow)
		MsgBox(64, "SQLite Info", "Command " & $sSQL & " performed")
		FileDelete(@TempDir & "\" & $Choice & ".csv")
		ContinueLoop
	EndIf

	WinSetTitle($Choice, '', $Choice & $TitleParams & " (" & UBound($aResult) - 1 & " rows)")
	GUISetState(@SW_SHOW, $SQLResultWindow)

	_GUICtrlListView_RegisterSortCallBack($hListView, True, True)
	_GUICtrlListView_BeginUpdate($hListView)

;_ArrayDisplay($aResult, @ScriptLineNumber)
	For $i = 1 To UBound($aResult) - 1 ; start at row 2 to skip titles
		$sRow = ""
		For $ii = 0 To UBound($aResult, 2) - 1
			$sRow &= $aResult[$i][$ii] & "|"
		Next
		$sRow = StringTrimRight($sRow, 1)
		GUICtrlCreateListViewItem($sRow, $hListView) ; create the listview elements
	Next
	For $i = 0 To UBound($aNames) - 1
		GUICtrlSendMsg($hListView, $LVM_SETCOLUMNWIDTH, $i, -1)
		GUICtrlSendMsg($hListView, $LVM_SETCOLUMNWIDTH, $i, -2) ; title
	Next
	_GUICtrlListView_EndUpdate($hListView)
	GUIRegisterMsg($WM_NOTIfY, "WM_NOTIfY2") ; new WM_NOTIfY2 to capture click and double click in this listview
	ToolTip("")

	While 1
		Switch GUIGetMsg()

			Case $GUI_EVENT_CLOSE
				; Check If Active window closed is  "Vertical View" , If correct, Then only close this GUI
				$Active_win = WinGetActive()
				If $Active_win[0] = "Vertical View" Then
					$size = WinGetPos($GUI_VerticalView)
					$VertView_Left = $size[0]
					$VertView_Top = $size[1]
					$size = WinGetClientSize($GUI_VerticalView)
					$VertView_Width = $size[0] + $VertView_OffsetWidth
					$VertView_Height = $size[1] + $VertView_OffsetHeight
					GUIDelete($GUI_VerticalView)
					$bVerticalView_GUI = False
					WinActivate($SQLResultWindow)
				ElseIf $Active_win[0] = "Cell Content" Then
					$size = WinGetPos($hGUI_Multiline)
					$MultiLine_Left = $size[0]
					$MultiLine_Top = $size[1]
					$size = WinGetClientSize($hGUI_Multiline)
					$MultiLine_Width = $size[0] + $MultiLine_OffsetWidth
					$MultiLine_Height = $size[1] + $MultiLine_OffsetHeight
					GUIDelete($hGUI_Multiline)
					WinActivate($SQLResultWindow)
				Else
					ExitLoop
				EndIf

			Case $BtClose
				; Check If Active window closed is  "Vertical View" , If correct, Then only close this GUI
				$Active_win = WinGetActive()
				If $Active_win[0] = "Vertical View" Then
					$size = WinGetPos($GUI_VerticalView)
					$VertView_Left = $size[0]
					$VertView_Top = $size[1]
					$size = WinGetClientSize($GUI_VerticalView)
					$VertView_Width = $size[0] + $VertView_OffsetWidth
					$VertView_Height = $size[1] + $VertView_OffsetHeight
					GUIDelete($GUI_VerticalView)
					$bVerticalView_GUI = False
					WinActivate($SQLResultWindow)
				ElseIf $Active_win[0] = "Cell Content" Then
					$size = WinGetPos($hGUI_Multiline)
					$MultiLine_Left = $size[0]
					$MultiLine_Top = $size[1]
					$size = WinGetClientSize($hGUI_Multiline)
					$MultiLine_Width = $size[0] + $MultiLine_OffsetWidth
					$MultiLine_Height = $size[1] + $MultiLine_OffsetHeight
					GUIDelete($hGUI_Multiline)
					WinActivate($SQLResultWindow)
				Else
					ExitLoop
				EndIf

			Case $bVerticalView_GUI And $VerticalView_Copy ; only allow copy to clipboard If Vertical Vew is open
				$To_Clip = ""
				For $i_I = 0 To UBound($aVertView) - 1
					; exact column Order
					For $i_C = 0 To UBound($aVertView, 2) - 1
						$To_Clip = $To_Clip & $aVertView[$i_I][$i_C] & $ListDelimiter
					Next
					$To_Clip = StringTrimRight($To_Clip, 1) & @CRLF
				Next
				; put to clipboard
				ClipPut($To_Clip)
				;MsgBox(0, "_ArrayToClip() Test", ClipGet())

			Case $BtSQL
				View_SQL($sSQL, $Choice)

			Case $hListView ; clicked column header, thus sort
				If UBound($aResult) > 200 Then
					ToolTip("Sorting", Default, Default, "Please wait", 1, 2)
				EndIf
				_GUICtrlListView_SortItems($hListView, GUICtrlGetState($hListView))
				ToolTip("")

			Case $BtExport
				$Result = FileMove(@TempDir & "\" & $Choice & ".csv", @MyDocumentsDir, 1)
				If $Result = 0 Then
					MsgBox(16, "Error", "Can't copy file:" & @LF & @TempDir & "\" & $Choice & ".csv to " & @MyDocumentsDir & @LF & "Please check if the file is not in use!")
				Else
					Local $oExcel = ObjCreate("Excel.Application")
					If Not IsObj($oExcel) Then ; Excel not found, another program maybe?
						ShellExecute(Chr(34) & @MyDocumentsDir & "\" & $Choice & ".csv" & Chr(34))
					Else
						; any error will be intercepted by the Comm error handler
						With $oExcel
							.Visible = 1
							.WorkBooks.OpenText(Chr(34) & @MyDocumentsDir & "\" & $Choice & ".csv" & Chr(34), _
								Default, 1, 1, -4142, False, False, False, False, False, True, $ListDelimiter)
							.ActiveWorkbook.Sheets(1).Select()
							.ActiveSheet.Range(.Columns(1), .Columns(_GUICtrlListView_GetColumnCount($hListView))).AutoFit
							.ActiveSheet.Range(.Rows(1), .Rows(_GUICtrlListView_GetItemCount($hListView)+1)).AutoFit
							.Activesheet.Range("A2").Select
							.ActiveWindow.FreezePanes = True
						EndWith

					EndIf
				EndIf

		EndSwitch
	WEnd
	$size = WinGetPos($SQLResultWindow)
	$iLV_Left = $size[0]
	$iLV_Top = $size[1]
	$size = WinGetClientSize($SQLResultWindow)
	$iLV_Width = $size[0] + $iLV_OffsetWidth
	$iLV_Height = $size[1] + $iLV_OffsetHeight
	GUIDelete($SQLResultWindow)
	FileDelete(@TempDir & "\" & $Choice & ".csv")
WEnd
_Exit()
#FUNCTION# ==============================================================
Func _Exit()
	IniWrite($iniFileName, "General", "DesktopWidth", $VirtualDesktopWidth) ; remember desktop width
	; write GUI coordinates
	IniWrite($iniFileName, "General", "Menu", $iAM_Width & "," & $iAM_Height & "," & $iAM_Left & "," & $iAM_Top )
	IniWrite($iniFileName, "General", "VerticalView", $VertView_Width & "," & $VertView_Height & "," & $VertView_Left & "," & $VertView_Top )
	IniWrite($iniFileName, "General", "SQLResultView", $iLV_Width & "," & $iLV_Height & "," & $iLV_Left & "," & $iLV_Top )
	IniWrite($iniFileName, "General", "MultilineView", $MultiLine_Width & "," & $MultiLine_Height & "," & $MultiLine_Left & "," & $MultiLine_Top )
	Exit
EndFunc   ;==>_Exit
#FUNCTION# ==============================================================
Func View_MultilineCell($Cell_content, $Column_name = "")
	Local $Msg2, $window_open, $size

	If $Cell_content = "" Then
		; clicked on no-nmultiline cell, so close the window
		$window_open = WinList("Cell Content")
		If $window_open[0][0] > 0 Then
			$size = WinGetPos($hGUI_Multiline)
			$MultiLine_Left = $size[0]
			$MultiLine_Top = $size[1]
			$size = WinGetClientSize($hGUI_Multiline)
			$MultiLine_Width = $size[0] + $MultiLine_OffsetWidth
			$MultiLine_Height = $size[1] + $MultiLine_OffsetHeight
			GUIDelete($hGUI_Multiline)
		EndIf
		Return
	Else
		$window_open = WinList("Cell Content") ; check If window already exists
		If $window_open[0][0] = 0 Then
			; If the window does not exist yet, create it
			Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
			Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
			Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
			$hGUI_Multiline = GUICreate("Cell Content", $MultiLine_Width, $MultiLine_Height, $MultiLine_Left, $MultiLine_Top, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX), $WS_EX_TOPMOST, $SQLResultWindow);($WS_POPUPWINDOW), $WS_EX_TOPMOST,$SQLResultWindow) ;( $WS_POPUPWINDOW $WS_BORDER) $WS_EX_TOPMOST,$SQLResultWindow)
			$ColName = GUICtrlCreateLabel("Content of " & $Column_name, 5, 2, $MultiLine_Width, 20)
			$View_Multiline = GUICtrlCreateEdit($Cell_content, 5, 20, $MultiLine_Width - 10, $MultiLine_Height - 50, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
			GUICtrlSetResizing($View_Multiline, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKLEFT)
			GUICtrlSetResizing($ColName, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
			GUICtrlSetColor(-1, $iDark_Blue)
			GUICtrlSetBkColor(-1, $iLight_Green)
			GUICtrlCreateLabel("Click on any non-multiline cell to hide this pop-up", 35, $MultiLine_Height - 15, $MultiLine_Width)
			GUICtrlSetFont(-1, 7, 400)
			GUISetIcon("SQLite2.ico", 0)
			If $MultiLine_OffsetWidth = Default Then
				; remember the difference between the result of WinGetClientSize and the initial Width and Height of the GUI
				$size = WinGetClientSize($hGUI_Multiline)
				$MultiLine_OffsetWidth = $MultiLine_Width - $size[0]
				$MultiLine_OffsetHeight = $MultiLine_Height - $size[1]
			EndIf
		Else
			; window already exist so only change the content
			GUICtrlSetData($ColName, "Content of " & $Column_name) ; column title
			GUICtrlSetData($View_Multiline, $Cell_content) ; cell content
		EndIf
		GUISetState()
		Return

	EndIf
EndFunc   ;==>View_MultilineCell
#FUNCTION# ==============================================================
Func WinGetActive()
	; Default Retrieving active window in AutoIt
	; So I've had this problem for a long time and I've never figured out how to do it until now.
	; This function returns an array with two values:
	; $aWindow[0] returns the title of the window
	; $aWindow[1] returns the window handle
	Dim $aWindow[2]
	Dim $aWinlist
	$aWinlist = WinList()
	For $i_I = 1 To $aWinlist[0][0]
		If $aWinlist[$i_I][0] <> "" And IsVisible($aWinlist[$i_I][1]) Then
			$aWindow[0] = $aWinlist[$i_I][0]
			$aWindow[1] = $aWinlist[$i_I][1]
			ExitLoop
		EndIf
	Next
	Return $aWindow
EndFunc   ;==>WinGetActive
#FUNCTION# ==============================================================
Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name...........: _ParseCSV
; Description ...: Reads a CSV-file
; Syntax.........: _ParseCSV($sFile, $sDelimiters=',', $sQuote='"', $iFormat=0)
; Parameters ....: $sFile       - File to read or string to parse
;                  $sDelimiters - [optional] Fieldseparators of CSV, mulitple are allowed (default: ,;)
;                  $sQuote      - [optional] Character to quote strings (default: ")
;                  $iFormat     - [optional] Encoding of the file (default: 0):
;                  |-1     - No file, plain data given
;                  |0 or 1 - automatic (ASCII)
;                  |2      - Unicode UTF16 Little Endian reading
;                  |3      - Unicode UTF16 Big Endian reading
;                  |4 or 5 - Unicode UTF8 reading
; Return values .: Success - 2D-Array with CSV data (0-based)
;                  Failure - 0, sets @error to:
;                  |1 - could not open file
;                  |2 - error on parsing data
;                  |3 - wrong format chosen
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WriteCSV
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ParseCSV($sFile, $sDelimiters = ',;', $sQuote = '"', $iFormat = 0)
	Local Static $aEncoding[6] = [0, 0, 32, 64, 128, 256]
	If $iFormat < -1 Or $iFormat > 6 Then
		Return SetError(3, 0, 0)
	ElseIf $iFormat > -1 Then
		Local $hFile = FileOpen($sFile, $aEncoding[$iFormat]), $sLine, $aTemp, $aCSV[1], $iReserved, $iCount
		If @error Then Return SetError(1, @error, 0)
		$sFile = FileRead($hFile)
		FileClose($hFile)
	EndIf
	If $sDelimiters = "" Or IsKeyword($sDelimiters) Then $sDelimiters = ',;'
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	$sQuote = StringLeft($sQuote, 1)
	Local $srDelimiters = StringRegExpReplace($sDelimiters, '[\\\^\-\[\]]', '\\\0')
	Local $srQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
	Local $sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?', ',', $srDelimiters, 0, 1), '"', $srQuote, 0, 1)
	Local $aREgex = StringRegExp($sFile, $sPattern, 3)
	If @error Then Return SetError(2, @error, 0)
	$sFile = '' ; save memory
	Local $iBound = UBound($aREgex), $iIndex = 0, $iSubBound = 1, $iSub = 0
	Local $aResult[$iBound][$iSubBound]
	For $i = 0 To $iBound - 1
		Select
			Case StringLen($aREgex[$i]) < 3 And StringInStr(@CRLF, $aREgex[$i])
				$iIndex += 1
				$iSub = 0
				ContinueLoop
			Case StringLeft(StringStripWS($aREgex[$i], 1), 1) = $sQuote
				$aREgex[$i] = StringStripWS($aREgex[$i], 3)
				$aResult[$iIndex][$iSub] = StringReplace(StringMid($aREgex[$i], 2, StringLen($aREgex[$i]) - 2), $sQuote & $sQuote, $sQuote, 0, 1)
			Case Else
				$aResult[$iIndex][$iSub] = $aREgex[$i]
		EndSelect
		$aREgex[$i] = 0 ; save memory
		$iSub += 1
		If $iSub = $iSubBound Then
			$iSubBound += 1
			ReDim $aResult[$iBound][$iSubBound]
		EndIf
	Next
	If $iIndex = 0 Then $iIndex = 1
	ReDim $aResult[$iIndex][$iSubBound]
	Return $aResult
EndFunc   ;==>_ParseCSV
#FUNCTION# ==============================================================
Func ExportData($aRow)
	; will export all records fetched by SQL
	Local $Row = ""
	For $ColItem In $aRow
		If StringIsFloat($ColItem) Then
			$ColItem = StringReplace($ColItem, ".", $sDecimal) ; convert Floating Point with decimal separator compliant with Excel
		Else ; If StringInStr($ColItem,@LF)>0 Then
			$ColItem = Chr(34) & StringReplace($ColItem, Chr(34), "'") & Chr(34) ;Replace all " by ' before putting the string between double quotes to avoid Excel conflicts
		EndIf

		$Row &= $ColItem & $ListDelimiter
	Next

	$Row = StringTrimRight($Row, 1) & @CRLF
	FileWriteLine($FileHandle, $Row)

	Return
EndFunc   ;==>ExportData
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayMenu
; Description ...: Creates a menu from Array items
; Syntax ........: _ArrayMenu($aMenu[, $sGUITitle= ""[, $sTitle = "Select"[, [$RowSelected = 1[, $iWidth = Default[, $iHeight = Default[, $iLeft = Default[, $iTop = Default]]]]]]])
; Parameters ....: $aMenu   	   - A single dimension array containing the items to display as a menu
;				   $sGUITitle	   - [optional] Title for the selection
;                  $sTitle         - [optional] The title of the selection box (default = "Select")
;                  $RowSelected    - [optional] The Row that has focus in the selection box (default = 1)
;                  $iWidth         - [optional] The width of the window.
;                  $iHeight        - [optional] The height of the window.
;                  $iLeft		   - [optional] The left side of the dialog box. By default (-1), the window is centered. If defined, top must also be defined.
;                  $iTop	       - [optional] The top of the dialog box. Default (-1) is centered
;
; Return values .: Success (if a selection was made) - Returns Name of element
;				   Failure (if escape was pressed) - Returns an empty string
;
; Requirements ..: _ArrayMenu requires $Menu_ListView and $DoubleClicked to be declared as Global variables.
;				   Global $Menu_ListView, $DoubleClicked
; Author ........: Greencan
; Related .......:
; Remarks .......: _ArrayMenu always shows TOPMOST
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayMenu($aMenu, $sGUITitle = "", $sTitle = "Select", $RowSelected = 1, $iWidth = Default, $iHeight = Default, $iLeft = Default, $iTop = Default)
	$DoubleClicked = False ; Declared as Global var
	Local $mainmsg, $size
;~ 	Local $Menu_Window = GuiCreate("  " & $sGUITitle, $iWidth, $iHeight, $iLeft, $iTop, $WS_DLGFRAME, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
;~ 	Local $Menu_Window = GUICreate("  " & $sGUITitle, $iWidth, $iHeight, $iLeft, $iTop, Default, $WS_EX_TOPMOST)
	Local $Menu_Window = GUICreate("  " & $sGUITitle, $iWidth, $iHeight, $iLeft, $iTop, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX), $WS_EX_TOPMOST)
	Local $aSize = WinGetClientSize($Menu_Window)
	If $iLV_OffsetWidth = Default Then
		; remember the difference between the result of WinGetClientSize and the initial Width and Height of the GUI
		$iAM_Width = $iWidth
		$iAM_Height = $iHeight
		$iAM_OffsetWidth = $iAM_Width - $aSize[0]
		$iAM_OffsetHeight = $iAM_Height - $aSize[1]
	EndIf
	Local $Menu_ListView = GUICtrlCreateListView($sTitle, 5, 30, $aSize[0] - 10, $aSize[1] - 65, BitOR($LVS_NOCOLUMNHEADER, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL))
	GUICtrlCreateLabel($sTitle, 5, 10, $iWidth - 10, 15)

	For $i = 0 To UBound($aMenu) - 1
		GUICtrlCreateListViewItem($aMenu[$i], $Menu_ListView) ; Menu item
	Next

	Local $MainbuttonGo = GUICtrlCreateButton("Go", 5, $aSize[1] - 32, 100, 30, $BS_DEFPUSHBUTTON)
	Local $MainbuttonExit = GUICtrlCreateButton("Exit", $aSize[0] - 105, $aSize[1] - 32, 100, 30)
	GUISetIcon("SQLite2.ico", 0)

	; Finished - Change the column width to fit the item text
	GUICtrlSendMsg($Menu_ListView, $LVM_SETCOLUMNWIDTH, 0, -1)
	GUICtrlSendMsg($Menu_ListView, $LVM_SETCOLUMNWIDTH, 0, -2) ; title

	GUIRegisterMsg($WM_NOTIfY, "WM_NOTIFY") ; double click

	GUISetState(@SW_SHOW, $Menu_Window)

	_GUICtrlListView_ClickItem($Menu_ListView, $RowSelected)

	; Run the GUI until the dialog is closed
	While 1
		$mainmsg = GUIGetMsg()
		Select

			Case $DoubleClicked Or $mainmsg = $MainbuttonGo
				$DoubleClicked = False
				$Choice = StringTrimRight(GUICtrlRead(GUICtrlRead($Menu_ListView)), 1)
				If $Choice <> "" Then
					$size = WinGetPos($Menu_Window)
					$iAM_Left = $size[0]
					$iAM_Top = $size[1]
					$size = WinGetClientSize($Menu_Window)
					$iAM_Width = $size[0] + $iAM_OffsetWidth
					$iAM_Height = $size[1] + $iAM_OffsetHeight
					GUIDelete($Menu_Window)
					Return $Choice
				EndIf

			Case $mainmsg = $GUI_EVENT_CLOSE Or $mainmsg = $MainbuttonExit; The End
					$size = WinGetPos($Menu_Window)
					$iAM_Left = $size[0]
					$iAM_Top = $size[1]
					$size = WinGetClientSize($Menu_Window)
					$iAM_Width = $size[0] + $iAM_OffsetWidth
					$iAM_Height = $size[1] + $iAM_OffsetHeight
				GUIDelete($Menu_Window)
				Return ""

		EndSelect

	WEnd ; Loop 1

	Return
EndFunc   ;==>_ArrayMenu
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _InputBox
; Description ...: Alternative InputBox for one or two inputs
; Syntax ........: _InputBox($sTitle, $sPrompt1[, $sDefault1 = ""[, $sPwdChar1 = ""[, $sInputSetTip1 = ""[, $sPrompt2 = ""[, $sDefault2 = ""[, $sPwdChar2 = ""[, $sInputSetTip2 = ""[, $iWidth = Default[, $iHeight = Default[, $iLeft = Default[, $iTop = Default, $hwnd = Default]]]]]]]]]]])
; Parameters ....: $sTitle   	   - The title of the input box.
;				   $sPrompt1	   - Message to the user indicating what kind of input is expected.
;                  $sDefault1      - [optional] The value that the input box starts with (default = "")
;                  $sPwdChar1      - [optional] Password character if required, usualy '*' (default = "")
;				   $sInputSetTip1  - [optional] Tip text associated with the input (default = "")
;				   $sPrompt2	   - [optional] Second Message to the user indicating what kind of input is expected.
;                  $sDefault2      - [optional] The value that the Second input box starts with (default = "")
;                  $sPwdChar2      - [optional] Password character if required, usualy '*' (default = "")
;				   $sInputSetTip2  - [optional] Tip text associated with the Second input (default = "")
;                  $iWidth         - [optional] The width of the window.
;                  $iHeight        - [optional] The height of the window.
;                  $iLeft		   - [optional] The left side of the dialog box. By default (-1), the window is centered. If defined, top must also be defined.
;                  $iTop	       - [optional] The top of the dialog box. Default (-1) is centered
;				   $hwnd		   - [optional] The window handle to use as the parent for this dialog
;
; Return values .: Success - Returns a single dimension array containing two elements:
;							element 0 contains the value of input 1 and element 1 contains the value of input2
;							If input 2 is not used, value of element 1 will be empty
;				   Failure - Returns @error 1
;
; Requirements ..:
; Author ........: Greencan
; Related .......:
; Remarks .......: The size of the dialog window will adapt dynamically to the number of required inputs
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _InputBox($sTitle, $sPrompt1, $sDefault1 = "", $sPwdChar1 = "", $sInputSetTip1 = "", $sPrompt2 = "", $sDefault2 = "", $sPwdChar2 = "", $sInputSetTip2 = "", $iWidth = Default, $iHeight = Default, $iLeft = Default, $iTop = Default, $hwnd = Default)
	Local $sInput1, $sInput2, $bOK, $bCancel, $msg, $avArray[2]
	; ConsoleWrite(@ScriptLineNumber & " >" & $sInputSetTip1 & "< - >" & $sInputSetTip2 & "<" & @CR)
	If $iWidth = Default Then $iWidth = 250
	If $iHeight = Default Then
		If $sPrompt2 <> "" Then
			$iHeight = 170
		Else
			$iHeight = 130
		EndIf
	EndIf

	GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, $WS_SYSMENU, -1, $hwnd)
	GUICtrlCreateLabel($sPrompt1, 10, 10, $iWidth - 20, 20)
	If $sPwdChar1 <> "" Then
		$sInput1 = GUICtrlCreateInput($sDefault1, 15, 30, $iWidth - 30, 20, $ES_PASSWORD)
	Else
		$sInput1 = GUICtrlCreateInput($sDefault1, 15, 30, $iWidth - 30, 20)
	EndIf
	If $sInputSetTip1 <> "" Then GUICtrlSetTip(-1, $sInputSetTip1)

	If $sPrompt2 <> "" Then
		GUICtrlCreateLabel($sPrompt2, 10, 60, $iWidth - 20, 20)
		If $sPwdChar2 <> "" Then
			$sInput2 = GUICtrlCreateInput($sDefault2, 15, $iHeight - 90, $iWidth - 30, 20, $ES_PASSWORD)
		Else
			$sInput2 = GUICtrlCreateInput($sDefault2, 15, $iHeight - 90, $iWidth - 30, 20)
		EndIf
		If $sInputSetTip2 <> "" Then GUICtrlSetTip(-1, $sInputSetTip2)
	EndIf

	$bOK = GUICtrlCreateButton("OK", 30, $iHeight - 55, 77, 22, $BS_DEFPUSHBUTTON)
	$bCancel = GUICtrlCreateButton("Cancel", $iWidth - 107, $iHeight - 55, 77, 22)
	GUISetState()

	$msg = 0
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $bOK
				$avArray[0] = GUICtrlRead($sInput1)
				If $sPrompt2 <> "" Then $avArray[1] = GUICtrlRead($sInput2)
				GUIDelete()
				Return $avArray
			Case $msg = $bCancel Or $msg = $GUI_EVENT_CLOSE
				GUIDelete()
				Return SetError(1, 0, 0)
		EndSelect
	WEnd
EndFunc   ;==>_InputBox
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _InputDate
; Description ...: Creates a Dialog for a single day or a period entry
; Syntax ........: _InputDate([$dFrom = Default[, $dTill = Default[, $bPeriod = Default[, $bLegality = Default]]]])
; Parameters ....: $dFrom   	   - [optional] Date (if $bPeriod is True, starting the period ) (default = Default)
;				   $dTill		   - [optional] Date ending the Period, unused if $bPeriod is False  (default = Default)
;                  $bPeriod        - [optional] Bolean, if false, dialog will input one date (default = Default)
;                  $bLegality	   - [optional] Period Legality Check (default = Default)
;
; Return values .: Success	- A single dimension array containing following elemnts:
;						[0] - Number of days between From and Till ( is 0 if single date input)
;						[1] - From date
;    					[2] - Till date ( is empty if single date input)
;					Failure	- Returns @error
;                  |1 - Escape pressed
;                  |2 - $bPeriod is not boolean
;                  |3 - $bLegality is not boolean
;
; Requirements ..:
; Author ........: Greencan
; Related .......:
; Remarks .......: Input dates Default to Date_Time_GetLocalTime() unless provided
;				   in 'yyyy/mm/dd' format
;				   Illegal formats will be replaced by Date_Time_GetLocalTime()
;				   function uses DateCalc.au3 (_DateCalc udf) from Sean Hart
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _InputDate($dFrom = Default, $dTill = Default, $bPeriod = Default, $bLegality = Default)

	If $dFrom = Default Then $dFrom = ""
	If $dTill = Default Then $dTill = ""
	If $bPeriod = Default Then $bPeriod = True
	If Not IsBool($bPeriod) Then Return SetError(2, 0, 0)
	If $bLegality = Default Then $bLegality = True
	If Not IsBool($bLegality) Then Return SetError(3, 0, 0)

	Local $_msg, $_ok, $Days_between, $sTitle, $iHeight
	Local $sDateFormat = RegRead("HKCU\Control Panel\International", "sShortDate") ; get system locale short Dateformat

	If $bPeriod Then
		$sTitle = "Set Period"
		$iHeight = 170
	Else
		$sTitle = "Set Date"
		$iHeight = 130
	EndIf

;~ 	Default , Default , $iAM_Left + (170 - 250)/2, $iAM_Top + ($iHeight - 170)/2 )
;~ $iAM_Width & "," & $iAM_Height & "," & $iAM_Left & "," & $iAM_Top
ConsoleWrite(@ScriptLineNumber & " $iAM_Left:" & $iAM_Left & " $iAM_Top:" & $iAM_Top & " $iAM_Width:" &  $iAM_Width & " $iAM_Height:" & $iAM_Height & " " & $iAM_Left + (172)/2 & " " & $iAM_Top + ( $iHeight)/2 & @CR)
;~ 	Local $input_Window = GUICreate($sTitle, 170, $iHeight, -1, -1, 0x00800000) ; $WS_BORDER = 0x00800000 requires #include <WindowsConstants.au3>
	Local $input_Window = GUICreate($sTitle, 170, $iHeight, $iAM_Left + ($iAM_Width - 172)/2, $iAM_Top + ($iAM_Height - $iHeight)/2, 0x00800000) ; $WS_BORDER = 0x00800000 requires #include <WindowsConstants.au3>

	If $bPeriod Then
		; period
		GUICtrlCreateLabel("From:", 10, 22)
		$dFrom = GUICtrlCreateDate($dFrom, 50, 20, 100, 20, 0) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
		GUICtrlCreateLabel("To:", 10, 52)
		$dTill = GUICtrlCreateDate($dTill, 50, 50, 100, 20, 0) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
	Else
		; Single date
		GUICtrlCreateLabel("Date:", 10, 22)
		$dFrom = GUICtrlCreateDate($dFrom, 50, 20, 100, 20, 0) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
	EndIf

	$_ok = GUICtrlCreateButton("OK", 50, $iHeight - 60, 70, 20, 0x0001) ; $BS_DEFPUSHBUTTON = 0x0001 requires #include <ButtonConstants.au3>

	GUISetState()

	; Run the GUI until the dialog is closed
	Do
		$_msg = GUIGetMsg()
		If $_msg = $_ok Then
			If $bPeriod Then
				$Days_between = _DateDiff('D', _DateCalc(GUICtrlRead($dFrom), $sDateFormat), _DateCalc(GUICtrlRead($dTill), $sDateFormat))
				; period legality check
				If $bLegality = 1 And $Days_between < 0 Then
					GUICtrlCreateLabel("Incorrect Period", 48, 82, 120)
					GUICtrlSetColor(-1, 0xff0000)
					Beep(2000, 10)
					ContinueLoop
				Else
					Dim $Period[3]
					$Period[0] = $Days_between
					$Period[1] = GUICtrlRead($dFrom)
					$Period[2] = GUICtrlRead($dTill)
					GUIDelete($input_Window)
					Return $Period
				EndIf
			Else
				Dim $Period[3]
				$Period[0] = 0
				$Period[1] = GUICtrlRead($dFrom)
				$Period[2] = ""
				GUIDelete($input_Window)
				Return $Period
			EndIf
			GUISetState()
		EndIf
	Until $_msg = -3 ; $GUI_EVENT_CLOSE = -3  requires #include <GUIConstantsEx.au3>
	GUIDelete($input_Window)
	Return SetError(1, 0, 0)

EndFunc   ;==>_InputDate
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _DateCalc
; Description ...: Returns the Date [and time] in format YYYY/MM/DD [HH:MM:SS],
;				   give the date / time in the system or specified format.
; Syntax ........: _DateCalc($sSysDateTime[, $dFormat = ""[, $tFormat = ""]])
; Parameters ....: $sSysDateTime	- Input date [and time]
;				   $dFormat		   - [optional] Format of input date (default = "")
;				   $tFormat		   - [optional] Format of input time (default = "")
;
; Return values .: Success - Returns Date in in format YYYY/MM/DD [HH:MM:SS]
;					Failure	- Returns @error
;                  |1 - input date badly formatted
;                  |2 - input time badly formatted
;
; Requirements ..: None
; Author ........: Sean Hart <autoit@hartmail.ca>
; Related .......:
; Remarks .......: Date format can be provided without any separators only in
;				   the format YYYYMMDD.
;				   If system format is used it is current user format, NOT
;				   default user format (which may be different).
;				   2 digit years converted: 	81 - 99 -> 1981-1999
;												00 - 80 -> 2000-2080²
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _DateCalc($sSysDateTime, $dFormat = "", $tFormat = "")
	Local $sDay, $sMonth, $sYear, $sHour, $sMin, $sSec, $dSep, $tSep, $am, $pm, $split1[9], $split2[9], $sSysDate, $sSysTime, $isAM, $isPM, $sTestDate
	;Local $dFormat, $tFormat

	; Read default system time formats and separators from registry unless provided
	If $dFormat = "" Then
		$dFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$dSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDate")
	Else
		; Extract separator from date format by finding first non recognised character
		For $x = 1 To StringLen($dFormat)
			If (Not (StringMid($dFormat, $x, 1) = "y")) And (Not (StringMid($dFormat, $x, 1) = "m")) And (Not (StringMid($dFormat, $x, 1) = "d")) Then
				$dSep = StringMid($dFormat, $x, 1)
				ExitLoop
			EndIf
		Next
	EndIf
	If $tFormat = "" Then
		$tFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$tSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDate")
		$am = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		$pm = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s2359")
	Else
		; Extract separator from time format by finding first non hour character
		For $x = 1 To StringLen($tFormat)
			If (Not (StringMid($tFormat, $x, 1) = "h")) Then
				$tSep = StringMid($tFormat, $x, 1)
				ExitLoop
			EndIf
		Next
		$am = "AM"
		$pm = "PM"
	EndIf

	; Separate date and time if included (make break at first space)
	If StringInStr($sSysDateTime, " ") Then
		$sSysDate = StringLeft($sSysDateTime, StringInStr($sSysDateTime, " ") - 1)
		$sSysTime = StringStripWS(StringReplace($sSysDateTime, $sSysDate, ""), 1)
	Else
		$sSysDate = $sSysDateTime
		$sSysTime = ""
	EndIf

	; Simple check of input date format (look for separators and unexpected non numeric characters)
	$sTestDate = StringReplace($sSysDate, $dSep, "")
	$sTestDate = "1" & $sTestDate
	If (String(Number($sTestDate)) <> $sTestDate) Then
		SetError(1)
		Return
	EndIf
	If (StringInStr($sSysDate, $dSep) = 0) And ($dSep <> "") Then
		SetError(1)
		Return
	EndIf
	If $sSysTime <> "" Then
		$sTestDate = StringReplace($sSysTime, $tSep, "")
		$sTestDate = StringReplace($sTestDate, $am, "")
		$sTestDate = StringReplace($sTestDate, $pm, "")
		$sTestDate = StringReplace($sTestDate, " ", "")
		$sTestDate = "1" & $sTestDate
		If (StringInStr($sSysTime, $tSep) = 0) Or (String(Number($sTestDate)) <> $sTestDate) Then
			SetError(2)
			Return
		EndIf
	EndIf

	; Break up date components (using format as a template), unless format is YYYYMMDD
	If $dFormat = "YYYYMMDD" Then
		$sYear = StringMid($sSysDate, 1, 4)
		$sMonth = StringMid($sSysDate, 5, 2)
		$sDay = StringMid($sSysDate, 7, 2)
	Else
		$split1 = StringSplit($dFormat, $dSep)
		$split2 = StringSplit($sSysDate, $dSep)
		For $x = 1 To $split1[0]
			If StringInStr($split1[$x], "M") Then $sMonth = $split2[$x]
			If StringInStr($split1[$x], "d") Then $sDay = $split2[$x]
			If StringInStr($split1[$x], "y") Then $sYear = $split2[$x]
		Next
	EndIf

	; Pad values with 0 if required and fix 2 digit year
	If StringLen($sMonth) = 1 Then $sMonth = "0" & $sMonth
	If StringLen($sDay) = 1 Then $sDay = "0" & $sDay
	If StringLen($sYear) = 2 Then
		If $sYear > 80 Then
			$sYear = "19" & $sYear
		Else
			$sYear = "20" & $sYear
		EndIf
	EndIf

	; Break up time components (if given)
	If $sSysTime <> "" Then
		; Look for AM/PM and note it, Then remove from the string
		$isPM = 0
		If StringInStr($sSysTime, $am) Then
			$sSysTime = StringReplace($sSysTime, " " & $am, "")
			$isPM = 1
		ElseIf StringInStr($sSysTime, $pm) Then
			$sSysTime = StringReplace($sSysTime, " " & $pm, "")
			$isPM = 2
		EndIf
		$split1 = StringSplit($tFormat, $tSep)
		$split2 = StringSplit($sSysTime, $tSep)
		$sSec = "00"
		For $x = 1 To $split2[0]
			If StringInStr($split1[$x], "h") Then $sHour = $split2[$x]
			If StringInStr($split1[$x], "m") Then $sMin = $split2[$x]
			If StringInStr($split1[$x], "s") Then $sSec = $split2[$x]
		Next

		; Clean up time values (change hour to 24h and 0 pad values)
		If ($isPM = 1) And ($sHour = 12) Then $sHour = "00"
		If ($isPM = 2) And ($sHour < 12) Then $sHour = $sHour + 12
		If StringLen($sHour) = 1 Then $sHour = "0" & $sHour
		If StringLen($sMin) = 1 Then $sMin = "0" & $sMin
		If StringLen($sSec) = 1 Then $sSec = "0" & $sSec

		; Return date with time
		Return $sYear & "/" & $sMonth & "/" & $sDay & " " & $sHour & ":" & $sMin & ":" & $sSec
	Else
		; Return date only
		Return $sYear & "/" & $sMonth & "/" & $sDay
	EndIf
EndFunc   ;==>_DateCalc
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: DateFormat
; Description ...: Universal date format converter
;					Converts the (default regional setting) PC Date format into any other specIfied date format:
;					- convert date into another date format (for example ddd dd MMMM, yyyy)
;					- convert date into day (d or dd)
;					- convert date into month ( m, mm or mmm)
;					- convert date into year (yy or yyyy)
; Syntax ........: DateFormat($InputDate[, $DateFmt = "mm/dd/yyyy"])
; Parameters ....: $InputDate      - Date to be converted
;				   $DateFmt		   - [optional] Date format to convert to (default = "mm/dd/yyyy")
;
; Return values .: Success - Returns Date in in requested format
;				   Failure (if escape was pressed) - Returns an empty string
; Return values .: Success	- A single dimension array containing following elemnts:
;						[0] - Number of days between From and Till ( is 0 if single date input)
;						[1] - From date
;    					[2] - Till date ( is empty if single date input)
;					Failure	- Returns @error
;                  |1 - Input date badly formatted
;                  |2 - Invalid Year in Date
;                  |3 - Invalid Month in Date
;                  |4 - Invalid Day in Date
;
; Requirements ..: _DateCalc() - The udf is included in this script
; Author ........: Greencan
; Related .......:
; Remarks .......:  Part of source code was borrowed from the Date conversion example provided by DaRam
;						http://www.autoitscript.com/forum/index.php?showtopic=76984&view=findpost&p=557834
;					DateCalc.au3 (_DateCalc udf) by Sean Hart
;						http://www.autoitscript.com/forum/index.php?showtopic=14084&view=findpost&p=96173
; Link ..........;
; Example .......; Yes
;					DateFormat( _NowCalcDate() , "dd-MM-yyyy" )
; ===============================================================================================================================
Func DateFormat($InputDate, $DateFmt = "mm/dd/yyyy")
	If StringLen($InputDate) < 6 Then Return SetError(1, 0, 0) ; Invalid Date ==> ddmmyy = 6

	Local $sDateFormat = RegRead("HKCU\Control Panel\International", "sShortDate") ; get system locale short Dateformat
	If $DateFmt = "" Then $DateFmt = "dd/mm/yyyy"
	Local $DateValue = _DateCalc($InputDate, $sDateFormat) ; convert the date to yyyy/mm/dd
	$DateValue = StringSplit($DateValue, "/")
	; error checking
	If @error Then Return SetError(1, 0, 0) ; Invalid Input Date
	If $DateValue[0] < 3 Then Return SetError(1, 0, 0) ; less than 3 parts in date not possible
	If Int(Number($DateValue[1])) < 0 Then Return SetError(2, 0, 0) ; Invalid Year in Date
	If Int(Number($DateValue[2])) < 1 Or Int(Number($DateValue[2])) > 12 Then Return SetError(3, 0, 0) ; Invalid Month in Date
	If Int(Number($DateValue[3])) < 1 Or Int(Number($DateValue[3])) > 31 Then Return SetError(4, 0, 0) ; Invalid Day in Date

	If Int(Number($DateValue[1])) < 100 Then $DateValue[1] = StringLeft(@YEAR, 2) & $DateValue[1]
	$InputDate = $DateFmt
	$InputDate = StringReplace($InputDate, "d", "@") ; Convert All Day References to @
	$InputDate = StringReplace($InputDate, "m", "#") ; Convert All Month References to #
	$InputDate = StringReplace($InputDate, "y", "&") ; Convert All Year References to &
	$InputDate = StringReplace($InputDate, "&&&&", $DateValue[1]) ; Century and Year
	$InputDate = StringReplace($InputDate, "&&", StringRight($DateValue[1], 2)) ; Year Only
	$InputDate = StringReplace($InputDate, "&", "") ; Discard leftover Year Indicator
	$InputDate = StringReplace($InputDate, "####", _DateToMonth($DateValue[2], 0)) ; Long Month Name
	$InputDate = StringReplace($InputDate, "###", _DateToMonth($DateValue[2], 1)) ; Short Month Name
	If StringLen($DateValue[1]) < 2 Then
		$InputDate = StringReplace($InputDate, "##", "0" & $DateValue[2]) ; Month Number 2 Digit
	Else
		$InputDate = StringReplace($InputDate, "##", $DateValue[2]) ; Month Number 2 Digit
	EndIf
	$InputDate = StringReplace($InputDate, "#", Int($DateValue[2])) ; Month Number
	Local $iPos = _DateToDayOfWeek($DateValue[1], $DateValue[2], $DateValue[3]) ; Day of Week Number
	$InputDate = StringReplace($InputDate, "@@@@", _DateDayOfWeek($iPos, 0)) ; Long Weekday Name
	$InputDate = StringReplace($InputDate, "@@@", _DateDayOfWeek($iPos, 1)) ; Short Weekday Name
	$InputDate = StringReplace($InputDate, "@@", $DateValue[3]) ; Day Number 2 Digit
	$InputDate = StringReplace($InputDate, "@", Int($DateValue[3])) ; Day Number

	Return $InputDate
EndFunc   ;==>DateFormat
#FUNCTION# ==============================================================
Func WM_NOTIFY($hwnd, $MsgID, $wParam, $lParam)
	; notify used for Double click in Main menu
	Local $tagNMHDR, $code
	$tagNMHDR = DllStructCreate("struct; hwnd hWndFrom;uint_ptr IDFrom;INT Code; endstruct", $lParam)
	If @error Then Return 0
	$code = DllStructGetData($tagNMHDR, 3)
	;If $wParam = $Menu_ListView And $code = -3 Then
	If $code = -3 Then
		$DoubleClicked = True
	EndIf
	;If $wParam = $Menu_ListView Then $DoubleClicked = True
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
#FUNCTION# ==============================================================
Func WM_NOTIfY2($hwnd, $iMsg, $wParam, $lParam)
	; this udf will show a window with the content of a cell. Displays only If the data contains @CRLF (multiline)
	; the udf replaces WM_NOTIfY in Listviewer ($hListView)
	Local $hWndFrom, $iCode, $tNMHDR, $hWndListView, $tInfo, $iItem, $subitemNR, $Column_attribute, $sToolTipData, $aTitle, $ColumnOrder, $aItem, $Position, $Rows_to_Clip
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $NM_CLICK;
					$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					$iItem = DllStructGetData($tInfo, "Item")
					$subitemNR = DllStructGetData($tInfo, "SubItem")
					$Column_attribute = _GUICtrlListView_GetColumn($hListView, $subitemNR)
					If $iLastItem = $iItem And $iLastsubitemNR = $subitemNR Then Return 0
					$iLastItem = $iItem
					$iLastsubitemNR = $subitemNR
					$sToolTipData = _GUICtrlListView_GetItemText($hListView, $iItem, $subitemNR)
					; Check LF, CR only
					; first check If LF in the memo
					$Position = StringInStr($sToolTipData, @LF)
					If $Position > 0 Then
						; Then check If @CRLF in the memo
						$Position = StringInStr($sToolTipData, @CRLF)
						If $Position > 0 Then ;can be displayed as is
							View_MultilineCell($sToolTipData, $Column_attribute[5] & " Row " & $iItem + 1)
						Else ; must convert @LF to @CRLF before displaying
							View_MultilineCell(StringReplace($sToolTipData, @LF, @CRLF), $Column_attribute[5] & " Row " & $iItem + 1)
						EndIf
					Else
						$Position = StringInStr($sToolTipData, @CR)
						If $Position > 0 Then
							; Then check If @CRLF in the memo
							$Position = StringInStr($sToolTipData, @CRLF)
							If $Position > 0 Then ;can be displayed as is
								View_MultilineCell($sToolTipData, $Column_attribute[5] & " Row " & $iItem + 1)
							Else ; must convert @CR to @CRLF before displaying
								View_MultilineCell(StringReplace($sToolTipData, @CR, @CRLF), $Column_attribute[5] & " Row " & $iItem + 1)
							EndIf
						Else
							View_MultilineCell("")
						EndIf
					EndIf
				Case $NM_DBLCLK
					$ColumnOrder = _GUICtrlListView_GetColumnOrderArray($hListView) ; exact column order, required If the user changed the layout in the listview
					; exact column Order
					; titles first
					$aTitle = $aNames
					Dim $aVertView[UBound($aTitle) + 1][2]
					$aVertView[0][0] = "Column title"
					$aVertView[0][1] = "Content"
					; Set the titles according to column setting
					For $i_C = 1 To UBound($ColumnOrder) - 1
						; only export the column If width > 0
						If _GUICtrlListView_GetColumnWidth($hListView, $i_C - 1) > 0 Then $aVertView[$i_C][0] = $aTitle[$ColumnOrder[$i_C]]
					Next
					$Rows_to_Clip = StringSplit(_GUICtrlListView_GetSelectedIndices($hListView), "|")
					For $i_I = 1 To UBound($Rows_to_Clip) - 1
						; exact column Order
						For $i_C = 1 To UBound($ColumnOrder) - 1
							$aItem = _GUICtrlListView_GetItem($hListView, $Rows_to_Clip[$i_I] + 0, $ColumnOrder[$i_C])
							; only export the column If width > 0
							If _GUICtrlListView_GetColumnWidth($hListView, $i_C - 1) > 0 Then $aVertView[$i_C][1] = $aItem[3]
						Next
					Next
					; cleanup empty elements in array
					For $i_C = UBound($aVertView) - 1 To 1 Step -1
						If $aVertView[$i_C][0] = "" Then _ArrayDelete($aVertView, $i_C)
					Next
					_ArrayDisplay2($aVertView, "Vertical View", 2, -1, 0, ";")

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIfY2
#FUNCTION# ==============================================================
Func View_SQL($sSQL, $sTitle)
	Local $msg
	; get the coordiantes of $SQLResultWindow
	$size = WinGetPos($SQLResultWindow)
	$iLV_Left = $size[0]
	$iLV_Top = $size[1]
	$size = WinGetClientSize($SQLResultWindow)
	$iLV_Width = $size[0] + $iLV_OffsetWidth
	$iLV_Height = $size[1] + $iLV_OffsetHeight

	Local $window_width = $iLV_Width - 100
	Local $window_heigth = $iLV_Height - 100

	; format SQL script a bit
	; the formating does not consider UNION,
	Local $stempSQL, $sSQLPart1, $sSQLPart2, $sSQLPart3, $sSQLPart4, $sSQLPart5, $sSQLPart6
	$stempSQL = $sSQL

	; LIMIT - should be after FROM !
	If StringInStr($stempSQL, "LIMIT", 0, -1) > 0 Then
		If StringInStr($stempSQL, "LIMIT", 0, -1) > StringInStr($stempSQL, "FROM", 0, -1) Then
			$sSQLPart6 = @CRLF & "LIMIT" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "LIMIT", 0, -1) + 5)
			$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "LIMIT", 0, -1) + 1), 2)
		EndIf
	EndIf

	; ORDER BY - should be after FROM !
	If StringInStr($stempSQL, "ORDER BY", 0, -1) > 0 Then
		If StringInStr($stempSQL, "ORDER BY", 0, -1) > StringInStr($stempSQL, "FROM", 0, -1) Then
			$sSQLPart5 = @CRLF & "ORDER BY" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "ORDER BY", 0, -1) + 8)
			$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "ORDER BY", 0, -1) + 1), 2)
		EndIf
	EndIf

	; GROUP BY - should be after FROM !
	If StringInStr($stempSQL, "GROUP BY", 0, -1) > 0 Then
		If StringInStr($stempSQL, "GROUP BY", 0, -1) > StringInStr($stempSQL, "FROM", 0, -1) Then
			$sSQLPart4 = @CRLF & "GROUP BY" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "GROUP BY", 0, -1) + 8)
			$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "GROUP BY", 0, -1) + 1), 2)
		EndIf
	EndIf

	; WHERE - should be after FROM !
	If StringInStr($stempSQL, "WHERE", 0, -1) > 0 Then
		If StringInStr($stempSQL, "WHERE", 0, -1) > StringInStr($stempSQL, "FROM", 0, -1) Then
			$sSQLPart3 = @CRLF & "WHERE" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "WHERE", 0, -1) + 5)
			$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "WHERE", 0, -1) + 1), 2)
		EndIf
	EndIf

	; INNER JOIN
	If StringInStr($stempSQL, "INNER JOIN", 0, -1) > 0 Then
		$stempSQL = StringReplace($stempSQL, "INNER JOIN", @CRLF & @TAB & @TAB & "INNER JOIN")
	EndIf

	; FROM
	If StringInStr($stempSQL, "FROM", 0, -1) > 0 Then
		$sSQLPart2 = @CRLF & "FROM" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "FROM", 0, -1) + 4)
		$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "FROM", 0, -1) + 1), 2)
	EndIf

	; SELECT
	If StringInStr($stempSQL, "SELECT", 0, 1) > 0 Then
		$sSQLPart1 = "SELECT" & @CRLF & @TAB & StringTrimLeft($stempSQL, StringInStr($stempSQL, "SELECT", 0, 1) + 6)
		$stempSQL = StringStripWS(StringTrimRight($stempSQL, StringLen($stempSQL) - StringInStr($stempSQL, "SELECT", 0, 1) + 1), 2)
	EndIf

	Local $hGUI_View_SQL = GUICreate("SQL", $window_width, $window_heigth, $iLV_Left + 50, $iLV_Top + 50, $WS_CAPTION, $WS_EX_TOPMOST, $SQLResultWindow)
	GUICtrlCreateLabel($sTitle, 10, 2, 600)
	Local $ViewSQL = GUICtrlCreateEdit($sSQLPart1 & $sSQLPart2 & $sSQLPart3 & $sSQLPart4 & $sSQLPart5 & $sSQLPart6 & @CRLF, 5, 25, $window_width - 10, $window_heigth - 80, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
	GUICtrlSetColor(-1, $iDark_Blue)
	GUICtrlSetBkColor(-1, $iLight_Green)
	Local $buttonOK = GUICtrlCreateButton("OK", 10, $window_heigth - 35, 60, 20, $BS_DEFPUSHBUTTON)

	#region Perforated Image
	; Perforated Image
	# ==> Start
	Local $_Left_pos, $_Top_pos, $_GUI_NAME
	$_Left_pos = $window_width - 145; 338 ; Replace with correct position
	$_Top_pos = $window_heigth - 20; 521 ; Replace with correct position
	_GuiImageHole($hGUI_View_SQL, $_Left_pos, $_Top_pos, 136, 41)
	# <== End
	#endregion Perforated Image

	GUISetState()
	Do
		$msg = GUIGetMsg()
		Select
			Case $msg = $buttonOK Or $msg = -3
				GUIDelete($hGUI_View_SQL)
				Return

		EndSelect
	Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>View_SQL
#FUNCTION# ==============================================================
#region Perforated Image
#comments-start
	The lines below will generate the perforated image (bewteen start and end)
	Move these lines into your GUI code, usually just before GUISetState()
	Don't forget to fill in the correct coordinates for $Left_pos, $Top_pos
	and enter the GUI Window Handle in the last line

	# ==> Start
	Local $_Left_pos, $_Top_pos, $_GUI_NAME
	$_Left_pos = 10 ; Replace with correct position
	$_Top_pos = 10 ; Replace with correct position
	$_GUI_NAME = 'The name of your GUI window'
	_GuiImageHole($_GUI_NAME, $_Left_pos, $_Top_pos, 136, 45)
	# <== End

#comments-end

#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================
; Name...........: _GuiImageHole
; Description....: Create a perforated image in a GUI Window
; Syntax.........: _GuiImageHole($window_handle, $pos_x, $pos_y,$Image_Width ,$Image_Height)
; Parameters ....: $window_handle 	- Window Handle of the GU to be perforated
;				   $pos_x			- Upper left position of the perforation
;				   $pos_y			- Upper Top position of the perforation
;				   $Image_Width		- Image width
;				   $Image_Height	- Image heigth
; Return values .: Success - Nothing returned
;                  Failure - Function does not fail
; Authors........: GreenCan
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================
Func _GuiImageHole($window_handle, $pos_x, $pos_y, $Image_Width, $Image_Height)
	Local $aClassList, $aM_Mask, $aMask
	#region picture array
	Local $aPicture[262] = [ _
			'3,1,48,1', '50,1,137,1', '3,2,48,2', '50,2,93,2', '94,2,137,2', '1,3,2,3', '4,3,47,3', '49,3,92,3', '95,3,137,3', '1,4,3,4', '5,4,25,4', '28,4,46,4', '48,4,92,4', '95,4,137,4', '1,5,3,5', '5,5,25,5', '29,5,45,5', '48,5,92,5', '95,5,137,5', '1,6,4,6', _
			'6,6,24,6', '30,6,45,6', '47,6,92,6', '96,6,137,6', '1,7,5,7', '7,7,9,7', '10,7,23,7', '30,7,38,7', '42,7,44,7', '46,7,93,7', '96,7,137,7', '1,8,6,8', '11,8,24,8', '29,8,37,8', '45,8,66,8', '68,8,93,8', '96,8,137,8', '1,9,6,9', '13,9,24,9', '30,9,36,9', _
			'44,9,66,9', '69,9,87,9', '91,9,93,9', '97,9,137,9', '1,10,6,10', '13,10,23,10', '31,10,37,10', '43,10,65,10', '71,10,86,10', '92,10,93,10', '97,10,137,10', '1,11,6,11', '12,11,22,11', '32,11,35,11', '42,11,65,11', '71,11,86,11', '92,11,93,11', '97,11,137,11', '1,12,6,12', '15,12,22,12', _
			'32,12,34,12', '43,12,50,12', '54,12,65,12', '70,12,86,12', '97,12,137,12', '1,13,5,13', '18,13,21,13', '32,13,33,13', '44,13,49,13', '55,13,65,13', '72,13,86,13', '96,13,137,13', '1,14,5,14', '15,14,16,14', '44,14,48,14', '55,14,64,14', '73,14,86,14', '96,14,137,14', '1,15,4,15', '15,15,20,15', _
			'45,15,48,15', '54,15,64,15', '74,15,85,15', '96,15,137,15', '1,16,4,16', '17,16,19,16', '46,16,48,16', '55,16,63,16', '75,16,84,16', '96,16,137,16', '1,17,5,17', '17,17,18,17', '46,17,47,17', '56,17,63,17', '76,17,84,17', '97,17,137,17', '1,18,5,18', '17,18,18,18', '46,18,47,18', '56,18,63,18', _
			'77,18,84,18', '97,18,137,18', '1,19,6,19', '16,19,18,19', '33,19,34,19', '57,19,63,19', '77,19,84,19', '98,19,137,19', '1,20,6,20', '16,20,17,20', '32,20,34,20', '58,20,63,20', '77,20,84,20', '98,20,137,20', '1,21,6,21', '16,21,17,21', '32,21,34,21', '58,21,63,21', '78,21,83,21', '98,21,137,21', _
			'1,22,6,22', '32,22,34,22', '58,22,63,22', '78,22,83,22', '98,22,137,22', '1,23,6,23', '57,23,64,23', '78,23,82,23', '98,23,137,23', '1,24,6,24', '57,24,65,24', '78,24,82,24', '98,24,137,24', '1,25,6,25', '58,25,65,25', '77,25,82,25', '99,25,137,25', '1,26,6,26', '58,26,64,26', '76,26,83,26', _
			'99,26,137,26', '1,27,7,27', '32,27,33,27', '46,27,47,27', '58,27,64,27', '77,27,83,27', '100,27,137,27', '1,28,7,28', '31,28,33,28', '46,28,47,28', '58,28,65,28', '77,28,83,28', '99,28,137,28', '2,29,7,29', '31,29,33,29', '59,29,65,29', '78,29,84,29', '98,29,137,29', '7,30,8,30', '16,30,18,30', _
			'31,30,33,30', '46,30,47,30', '59,30,65,30', '79,30,84,30', '96,30,137,30', '8,31,10,31', '15,31,18,31', '25,31,26,31', '31,31,34,31', '45,31,47,31', '60,31,62,31', '79,31,85,31', '95,31,137,31', '3,32,6,32', '8,32,10,32', '15,32,21,32', '25,32,26,32', '33,32,34,32', '42,32,48,32', '60,32,62,32', _
			'78,32,85,32', '95,32,137,32', '34,33,35,33', '39,33,40,33', '42,33,49,33', '60,33,62,33', '76,33,86,33', '95,33,120,33', '125,33,130,33', '135,33,137,33', '38,34,39,34', '44,34,51,34', '76,34,88,34', '95,34,122,34', '125,34,129,34', '131,34,134,34', '135,34,137,34', '47,35,51,35', '55,35,60,35', '64,35,65,35', _
			'76,35,88,35', '95,35,121,35', '123,35,124,35', '126,35,128,35', '130,35,134,35', '135,35,137,35', '49,36,51,36', '56,36,62,36', '65,36,66,36', '69,36,70,36', '76,36,81,36', '83,36,88,36', '95,36,120,36', '122,36,124,36', '126,36,127,36', '129,36,137,36', '56,37,58,37', '66,37,70,37', '76,37,78,37', '84,37,88,37', _
			'95,37,120,37', '122,37,124,37', '126,37,127,37', '129,37,131,37', '135,37,137,37', '67,38,71,38', '77,38,79,38', '84,38,89,38', '95,38,119,38', '126,38,127,38', '129,38,132,38', '134,38,137,38', '32,39,33,39', '85,39,89,39', '95,39,118,39', '120,39,124,39', '126,39,127,39', '129,39,132,39', '134,39,137,39', '18,40,24,40', _
			'26,40,41,40', '86,40,89,40', '95,40,117,40', '121,40,123,40', '127,40,128,40', '134,40,137,40', '14,41,46,41', '85,41,89,41', '95,41,137,41', '9,42,52,42', '88,42,89,42', '97,42,137,42', '7,43,55,43', '57,43,59,43', '62,43,65,43', '67,43,69,43', '70,43,73,43', '100,43,137,43', '6,44,79,44', '100,44,137,44', _
			'4,45,81,45', '100,45,137,45']
	#endregion picture array
	; get the size of the active window
	Local $size = WinGetClientSize($window_handle)
	Local $window_width = $size[0]
	Local $Window_height = $size[1] + 33 ; including the title bar
	; First hide the window
	$aClassList = StringSplit(_WinGetClassListEx($window_handle), @LF)
	$aM_Mask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', 0, 'long', 0)
	; rectangle A - left side
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $pos_x, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle B - Top
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $window_width, 'long', $pos_y)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle C - Right side
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', $pos_x + $Image_Width, 'long', 0, 'long', $window_width + 30, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle D - Bottom
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', $pos_y + $Image_Height, 'long', $window_width, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; now unhide all regions as defined  in array $aPicture
	For $i_I = 0 To (UBound($aPicture) - 1)
		Local $Block_value = StringSplit($aPicture[$i_I], ',')
		$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', $pos_x + $Block_value[1] - 1, 'long', $pos_y + $Block_value[2], 'long', $pos_x + $Block_value[3], 'long', $pos_y + $Block_value[4] - 1)
		DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	Next
	DllCall('user32.dll', 'long', 'SetWindowRgn', 'hwnd', $window_handle, 'long', $aM_Mask[0], 'int', 1)
	$aPicture = '' ; empty array
EndFunc   ;==>_GuiImageHole
#FUNCTION# ==============================================================
Func _WinGetClassListEx($sTitle)
	Local $sClassList = WinGetClassList($sTitle)
	Local $aClassList = StringSplit($sClassList, @LF)
	Local $sRetClassList = '', $sHold_List = '|'
	Local $aiInHold, $iInHold
	For $i_I = 1 To UBound($aClassList) - 1
		If $aClassList[$i_I] = '' Then ContinueLoop
		If StringRegExp($sHold_List, '\|' & $aClassList[$i_I] & '~(\d+)\|') Then
			$aiInHold = StringRegExp($sHold_List, '.*\|' & $aClassList[$i_I] & '~(\d+)\|.*', 1)
			$iInHold = Number($aiInHold[UBound($aiInHold) - 1])
			If $iInHold = 0 Then $iInHold += 1
			$aClassList[$i_I] &= '~' & $iInHold + 1
			$sHold_List &= $aClassList[$i_I] & '|'
			$sRetClassList &= $aClassList[$i_I] & @LF
		Else
			$aClassList[$i_I] &= '~1'
			$sHold_List &= $aClassList[$i_I] & '|'
			$sRetClassList &= $aClassList[$i_I] & @LF
		EndIf
	Next
	Return StringReplace(StringStripWS($sRetClassList, 3), '~', '')
EndFunc   ;==>_WinGetClassListEx
#endregion Perforated Image
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDisplay2
; Description ...: Displays given 1D or 2D array in a listview.
; Syntax.........: _ArrayDisplay(Const ByRef $avArray[, $sTitle = "Array: ListView Display", [$iColumnTitle = 0][, $iItemLimit = -1[, $iTranspose = 0[, $sDelimiter = ""[, $sReplace = "|"]]]]])
; Parameters ....: $avArray    		- Array to display
;                  $sTitle     		- [optional] Title to use for window
;	        	   $iColumnTitles	- [optional]
;										0 = Default 'Col x' (same as _ArrayDisplay)
;										1 = Display Column Titles defined as Row 0 in $avArray
;										2 = Display Column Titles, don't show Row numbers (not valid for $iTranspose <> 0)
;                  $iItemLimit 		- [optional] Maximum number of listview items (rows) to show
;                  $iTranspose 		- [optional] If set dIfferently than default, will transpose the array If 2D
;                  $sDelimiter 		- [optional] Change Opt("GUIDataSeparatorChar") on-the-fly
;                  $sReplace   		- [optional] String to replace any occurrence of $sDelimiter with in each array element
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has too many Dimensions (only up to 2D supported)
; Author ........: randallc, Ultima
; ModIfied.......: Gary Frost (gafrost) / Ultima: modIfied to be self-contained (no longer depends on "GUIListView.au3")
;				   Greencan  added optional Column Title / Hide Column numbers, correct positioning of ListView GUI on screen
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayDisplay2(Const ByRef $avArray, $sTitle = "Array: ListView Display", $iColumnTitle = 0, $iItemLimit = -1, $iTranspose = 0, $sDelimiter = "", $sReplace = "|")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)
	Local $size

	; Delimiter handling
	If $sDelimiter = "" Then $sDelimiter = Chr(124)

	; Declare variables
	Local $i_I, $i_J, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 250, $iLVIAddUDFThreshold = 4000;, $VertView_Width = 640, $VertView_Height = 480
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataDelimiterChar = Opt("GUIDataSeparatorChar", $sDelimiter)

	; Swap Dimensions If transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for Dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUBound Then $iLVIAddUDFThreshold = $iUBound

	; Column Titles
	If $iColumnTitle = 0 Then
		; Set header up
		For $i_I = 0 To $iSubMax
			$sHeader &= $sDelimiter & "Col " & $i_I
		Next
		Local $StartRow = 0
		Local $StartCol = 0
	Else
		; no first column with row number
		If $iColumnTitle = 2 Then $sHeader = ""
		; Set header with array row 0
		For $i_I = 0 To $iSubMax
			Local $StartCol
			If $iTranspose Then
				$sHeader = "Title"
				For $i_I = 1 To $iSubMax
					$sHeader &= $sDelimiter & "Col " & $i_I
				Next
				$StartCol = 1
			Else
				If $iDimension = 1 Then
					$sHeader &= $sDelimiter & $avArray[$i_I]
				Else
					$sHeader &= $sDelimiter & $avArray[0][$i_I]
				EndIf
				$StartCol = 0
			EndIf
		Next
		Local $StartRow = 1
		If StringLeft($sHeader, 1) = $sDelimiter Then $sHeader = StringTrimLeft($sHeader, 1)
	EndIf

	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1]
	For $i_I = $StartRow To $iUBound + $StartCol
		If $iColumnTitle <> 0 And $iTranspose Then
			If $iDimension = 1 Then
				$avArrayText[$i_I - $StartRow] = "[" & $avArray[$i_I - $StartRow] & "]"
			Else
				$avArrayText[$i_I - $StartRow] = "[" & $avArray[0][$i_I - $StartRow] & "]"
			EndIf
		Else
			If $iColumnTitle < 2 Then
				$avArrayText[$i_I - $StartRow] = "[" & $i_I & "]"
			EndIf
		EndIf
		For $i_J = $StartCol To $iSubMax
			; Get current item
			If $iDimension = 1 Then
				If $iTranspose Then
					$vTmp = $avArray[$i_J]
				Else
					$vTmp = $avArray[$i_I]
				EndIf
			Else
				If $iTranspose Then
					If $iColumnTitle <> 0 Then
						$vTmp = $avArray[$i_J][$i_I - $StartRow]
					Else
						$vTmp = $avArray[$i_J][$i_I]
					EndIf
				Else
					$vTmp = $avArray[$i_I][$i_J]
				EndIf
			EndIf

			; Add to text array
			$vTmp = StringReplace($vTmp, $sDelimiter, $sReplace, 0, 1)
			$avArrayText[$i_I - $StartRow] &= $sDelimiter & $vTmp

			; Set max buffer size
			$vTmp = StringLen($vTmp)
			If $vTmp > $iBuffer Then $iBuffer = $vTmp
		Next
		If StringLeft($avArrayText[$i_I - $StartRow], 1) = $sDelimiter Then $avArrayText[$i_I - $StartRow] = StringTrimLeft($avArrayText[$i_I - $StartRow], 1)
	Next
	$iBuffer += 1

	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVIf_PARAM = 0x4
	Local Const $_ARRAYCONSTANT_LVIf_TEXT = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH = (0x1000 + 29)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMA = (0x1000 + 7)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMA = (0x1000 + 6)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIf_TEXT, $_ARRAYCONSTANT_LVIf_PARAM)
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	; Set interface up
	Local $window_open = WinList("Vertical View") ; check If window already exists
	;Local $GUI_VerticalView
;~ 	ConsoleWrite ( @ScriptLineNumber & " $VertView_Width:" & $VertView_Width & " $VertView_Height:" & $VertView_Height & " $VertView_Left:" & $VertView_Left & " $VertView_Top:" & $VertView_Top & @CR)

	If $window_open[0][0] > 0 Then
;~ 		$bVerticalView_Resize = False
		$bVerticalView_GUI = False
		$size = WinGetPos($GUI_VerticalView)
		$VertView_Left = $size[0]
		$VertView_Top = $size[1]
		$size = WinGetClientSize($GUI_VerticalView)
		$VertView_Width = $size[0] + $VertView_OffsetWidth
		$VertView_Height = $size[1] + $VertView_OffsetHeight
		GUIDelete($GUI_VerticalView)
		$GUI_VerticalView = GUICreate($sTitle, $VertView_Width, $VertView_Height, $VertView_Left, $VertView_Top, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX), $WS_EX_TOPMOST, $SQLResultWindow)
	Else
		$GUI_VerticalView = GUICreate($sTitle, $VertView_Width, $VertView_Height, $VertView_Left, $VertView_Top, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX), $WS_EX_TOPMOST, $SQLResultWindow)
		$bVerticalView_GUI = True
		If $VertView_OffsetWidth = 0 Then
			; remember the difference between the result of WinGetClientSize and the initial Width and Height of the GUI
			$size = WinGetClientSize($GUI_VerticalView)
			$VertView_OffsetWidth = $VertView_Width - $size[0]
			$VertView_OffsetHeight = $VertView_Height - $size[1]
		EndIf
	EndIf
;~ ConsoleWrite ( @ScriptLineNumber & " $VertView_Width:" & $VertView_Width & " $VertView_Height:" & $VertView_Height & " $VertView_Left:" & $VertView_Left & " $VertView_Top:" & $VertView_Top & @CR)

	Local $aiGUISize = WinGetClientSize("Vertical View")
	Local $VertView_hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	$VerticalView_Copy = GUICtrlCreateButton("Copy to Clipboard", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)
	GUICtrlSetResizing($VertView_hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($VerticalView_Copy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)
	GUISetIcon("DATABASE.ICO", 0)
	; Fill listview
	For $i_I = 0 To $iLVIAddUDFThreshold
		GUICtrlCreateListViewItem($avArrayText[$i_I], $VertView_hListView)
	Next

	For $i_I = ($iLVIAddUDFThreshold + 1) To $iUBound
		$aItem = StringSplit($avArrayText[$i_I], $sDelimiter)
		DllStructSetData($tBuffer, "Text", $aItem[1])

		; Add listview item
		DllStructSetData($tItem, "Item", $i_I)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "Mask", $iAddMask)
		GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_INSERTITEMA, 0, $pItem)

		; Set listview subitem text
		DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIf_TEXT)
		For $i_J = 2 To $aItem[0]
			DllStructSetData($tBuffer, "Text", $aItem[$i_J])
			DllStructSetData($tItem, "SubItem", $i_J - 1)
			GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next
	; calibrate columns
;~ 	$VertView_Width = 0
	For $i_I = 0 To $iSubMax + 1
		GUICtrlSendMsg($VertView_hListView, 0x1000 + 30, $i_I, -2) ; added this to calibrate column width correctly

;~ 		If $bVerticalView_Resize Then $VertView_Width += GUICtrlSendMsg($VertView_hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i_I, 0)
	Next
;~ 	If $bVerticalView_Resize Then
;~ 		; postion of main window at startup
;~ 		;Local $VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 78)
;~ 		Local $iCentre = (@DesktopWidth - $VertView_Width - 20) / 2

;~ 		If $VertView_Width + 20 > $VirtualDesktopWidth Then ; If Listview larger than $VirtualDesktopWidth limit to the visible size
;~ 			$VertView_Width = $VirtualDesktopWidth - 20
;~ 			$iCentre = ($VirtualDesktopWidth - $VertView_Width - 20) / 2
;~ 		ElseIf $VertView_Width + 20 <= @DesktopWidth Then ; If Listview smaller than @DesktopWidth center on first screen
;~ 			$iCentre = (@DesktopWidth - $VertView_Width - 20) / 2
;~ 		ElseIf $VertView_Width < 250 Then ; Minimal size of Listview is 250
;~ 			$VertView_Width = 250
;~ 			$iCentre = (@DesktopWidth - $VertView_Width - 20) / 2
;~ 		EndIf
;~ 		$VertView_Left = $VirtualDesktopWidth - $VertView_Width - 20
;~ 		WinMove($GUI_VerticalView, "", $VertView_Left, Default, $VertView_Width + 20)
;~ 	EndIf
;~ 	ConsoleWrite ( @ScriptLineNumber & " $VertView_Width:" & $VertView_Width & " $VertView_Height:" & $VertView_Height & " $VertView_Left:" & $VertView_Left & " $VertView_Top:" & $VertView_Top & @CR)

	; Show dialog
	GUISetState(@SW_SHOW, $GUI_VerticalView)

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataDelimiterChar)

	Return 1
EndFunc   ;==>_ArrayDisplay2
#FUNCTION# ==============================================================
Func _COMError()

	Local $bHexNumber = Hex($oAppError.number, 8)
	Local $sError = "COM Error Encountered in " & @ScriptName & @CRLF & _
			"@AutoItVersion = " & @AutoItVersion & @CRLF & _
			"@AutoItX64 = " & @AutoItX64 & @CRLF & _
			"@Compiled = " & @Compiled & @CRLF & _
			"@OSArch = " & @OSArch & @CRLF & _
			"@OSVersion = " & @OSVersion & @CRLF & _
			"Scriptline = " & $oAppError.scriptline & @CRLF & _
			"NumberHex = " & $bHexNumber & @CRLF & _
			"Number = " & $oAppError.number & @CRLF & _
			"WinDescription = " & StringStripWS($oAppError.WinDescription, 2) & @CRLF & _
			"Description = " & StringStripWS($oAppError.description, 2) & @CRLF & _
			"Source = " & $oAppError.Source & @CRLF & _
			"HelpFile = " & $oAppError.HelpFile & @CRLF & _
			"HelpContext = " & $oAppError.HelpContext & @CRLF & _
			"LastDllError = " & $oAppError.LastDllError

	If $iDebug > 0 Then
		If $iDebug = 1 Then ConsoleWrite($sError & @CRLF & "========================================================" & @CRLF)
		If $iDebug = 2 Then MsgBox(64, "SQLite Reports - Debug Info", $sError)
	EndIf
	Return SetError(999, $oAppError.number, 0)

EndFunc   ;==>_COMError
#FUNCTION# ==============================================================