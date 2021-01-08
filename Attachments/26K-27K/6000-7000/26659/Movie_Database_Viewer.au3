#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Au3check=n
#AutoIt3Wrapper_Au3Check_Parameters=-U
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <ListViewConstants.au3>
; *** End added by AutoIt3Wrapper ***
#Region Includes
#include <IsPressed_UDF.au3>
#include <file.au3>
#include <array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <string.au3>
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#EndRegion Includes
#Region Declarations
Local $qQuery
Local $aRow
Local $sTitle
Local $sPath
Local $aTitleAndPath[1][2]
Local $aTitle
Local $aPath
Local $lListView
Local $lCountLabel
Local $inInput
Local $dll
#EndRegion Declarations
#Region File Installs
FileInstall("e:\movie.db", @ScriptDir & "\")
#Region Options
Opt("wintitlematchmode", 3)
#EndRegion Options
#Region SQLite Initialisations
_SQLite_Startup()
$dbMovie = _SQLite_Open(@ScriptDir & "\Movie.db")
#EndRegion SQLite Initialisations
;~ _SQLite_Exec(-1, "PRAGMA synchronous = OFF;")
_SQLite_Query(-1, "SELECT * FROM Movies;", $qQuery)
$sPath = ""
$sTitle = ""
While _SQLite_FetchData($qQuery, $aRow) = $SQLITE_OK
	$sTitle &= $aRow[0] & '%&'
	$sPath &= $aRow[1] & '$%'
WEnd
$aTitle = StringSplit($sTitle, '%&', 3)
;~ _ArrayDisplay($aTitle)
;~ ConsoleWrite($sPath & @CRLF)
$aPath = StringSplit($sPath, '$%', 3)
;~ _ArrayDisplay($aPath)
Dim $aTitleAndPath[UBound($aTitle)][2]
For $i = 0 To UBound($aTitle) - 1
	$aTitleAndPath[$i][0] = $aTitle[$i]
	$aTitleAndPath[$i][1] = $aPath[$i]
Next
_SQLite_Close()
_SQLite_Shutdown()
;~ MsgBox(0, "", __GetKeyType("BACKSPACE",1))
_DisplayResults()
Func _DisplayResults()
	$gDisplayGui = GUICreate("Movies", @DesktopWidth * 0.7, @DesktopHeight * 0.7, -1, -1, BitOR($WS_MAXIMIZEBOX, $WS_SIZEBOX))
	$aWinPos = WinGetPos("Movies")
	$bSearchButton = GUICtrlCreateButton("Search Titles", $aWinPos[2] * 0.01, $aWinPos[3] * 0.89)
;~     $lListView = _GUICtrlListView_Create($gDisplayGui, "Title|Path", 0, 0, $aWinPos[2] * 0.994, $aWinPos[3] * 0.7)
	$lListView = GUICtrlCreateListView("Title|Path", 0, 0, $aWinPos[2] * 0.994, $aWinPos[3] * 0.7)
	$bShowAll = GUICtrlCreateButton("Show All", $aWinPos[2] * 0.15, $aWinPos[3] * 0.89)
	$lCountLabel = GUICtrlCreateLabel("", $aWinPos[2] * 0.01, $aWinPos[3] * 0.80, 200, 21)
	$inInput = GUICtrlCreateInput("", $aWinPos[2] * 0.01, $aWinPos[3] * 0.75, $aWinPos[2] * 0.20, 21)
	_GUICtrlListView_SetExtendedListViewStyle($lListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_LABELTIP))
	_GUICtrlListView_AddArray($lListView, $aTitleAndPath)
	GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
	_GUICtrlListView_SetColumnWidth($lListView, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth($lListView, 1, $LVSCW_AUTOSIZE)
	GUICtrlSetResizing($gDisplayGui, $GUI_DOCKAUTO)
	GUISetState()
	GUICtrlSetState($inInput, $GUI_FOCUS)
	$dll = DllOpen("user32.dll")
	While 1
		$mesg = GUIGetMsg()
		Select
			Case $mesg = $GUI_EVENT_CLOSE
				DllClose($dll)
				Exit
			Case $mesg = $bSearchButton
				_SearchTitles()
			Case $mesg = $bShowAll
				_ShowAll()
		EndSelect
		If _IsPressed("0D", $dll) Then
			If WinActive("Movies") Then
				_SearchTitles()
			EndIf
		EndIf
		If _IsPressed("08", $dll) Then
			_SearchTitles()
		EndIf
		If _IsAlphaNumKeyPressed($dll) Then
			_SearchTitles()
		EndIf
	WEnd
EndFunc   ;==>_DisplayResults
Func _SearchTitles()
	$sTitles = ""
	$input = GUICtrlRead($inInput)
	If $input = "*" Or $input = "" Then
		GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
;~         GUICtrlSetData($lCountLabel, "0 Titles match the search term")
		_GUICtrlListView_AddArray($lListView, $aTitleAndPath)
		GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
;~         GUICtrlSetState($inInput, $GUI_FOCUS)
	Else
		$iArrayIndex = _ArrayFindAll($aTitleAndPath, $input, 0, 0, 0, 1)
;~ 	MsgBox(0, "", $iArrayIndex)
		If $iArrayIndex = -1 Then
			GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
		Else
			Dim $aFound[UBound($iArrayIndex)][2]
			For $iIterate = 0 To UBound($iArrayIndex) - 1
				$aFound[$iIterate][0] = $aTitleAndPath[$iArrayIndex[$iIterate]][0]
				$aFound[$iIterate][1] = $aTitleAndPath[$iArrayIndex[$iIterate]][1]
			Next
;~             _GUICtrlListView_DeleteAllItems($lListView)
			GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
			_GUICtrlListView_AddArray($lListView, $aFound)
		EndIf
		GUICtrlSetData($lCountLabel, UBound($iArrayIndex) & " Titles match the search term")
;~         GUICtrlSetState($inInput, $GUI_FOCUS)
	EndIf
EndFunc   ;==>_SearchTitles
Func _ShowAll()
	GUICtrlSetData($inInput, "")
;~     _GUICtrlListView_DeleteAllItems($lListView)
	GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
	_GUICtrlListView_AddArray($lListView, $aTitleAndPath)
	GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
	GUICtrlSetState($inInput, $GUI_FOCUS)
EndFunc   ;==>_ShowAll
DllClose($dll)
