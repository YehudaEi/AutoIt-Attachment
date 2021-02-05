#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <SQLite.au3>
#include <sqlite.dll.au3>
#include <file.au3>
#Include <GuiListView.au3>
Opt("GUIOnEventMode", 1)
Global $EditGUI, $viewGUI, $sDBFile = @ScriptDir & "\contacts.db"
Global $contactlist, $hQuery, $aRow
_SQLite_Startup ()
If Not FileExists($sDBFile) Then
	_CreateDB ()
EndIf
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

$hDB = _SQLite_Open ($sDBFile)

ViewClick ()

While 1
	Sleep (100)
WEnd

Func ViewClick()
	$viewGUI = GUICreate("View Contacts", 637, 443, 253, 151)
	GUISetOnEvent($GUI_EVENT_CLOSE, "mainClose")
	$edit_menu = GUICtrlCreateMenu("Edit")
	$edit = GUICtrlCreateMenuItem("Edit Contact", $edit_menu)
		GUICtrlSetOnEvent(-1, "editClick")

	$contactlist = GUICtrlCreateListView("#|First Name|Last Name|Address|Address 2|Home Ph#|Cell Ph#|Work #", 0, 0, 634, 422)
	GUICtrlSendMsg(-1, 0x101E, 0, 25)
	GUICtrlSendMsg(-1, 0x101E, 1, 100)
	GUICtrlSendMsg(-1, 0x101E, 2, 100)
	GUICtrlSendMsg(-1, 0x101E, 3, 100)
	GUICtrlSendMsg(-1, 0x101E, 4, 100)
	GUICtrlSendMsg(-1, 0x101E, 5, 100)
	GUICtrlSendMsg(-1, 0x101E, 6, 100)
	GUICtrlSendMsg(-1, 0x101E, 7, 100)
	GUISetState(@SW_SHOW)
	_SQLite_Query($hDB, "SELECT ROWID, * FROM Contacts;", $hQuery)

	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
    GUICtrlCreateListViewItem($aRow[0] & '|' & $aRow[1] & '|' & $aRow[2] & '|' & $aRow[3] & '|' & _
							$aRow[4] & '|' & $aRow[5] & '|' & $aRow[6] & '|' & $aRow[7], $contactlist)
	WEnd

EndFunc

Func editClick()
	If $NM_DBLCLK Then
		$recs = _GUICtrlListView_GetHotItem($contactlist)
	Else
		$recs = StringSplit(GuiCtrlRead(GuiCtrlRead($contactlist)), '|')
		If $recs[0] = 0 Then
			MsgBox(48, "Select Contact", "Please select a contact to edit.")
			Return
		EndIf
	EndIf
	GUIDelete($viewGUI)
	$EditGUI = GUICreate("Edit Contact", 637, 443, 253, 151)
		GUISetOnEvent($GUI_EVENT_CLOSE, "mainClose")
	$edit_menu = GUICtrlCreateMenu("Edit")
	$edit = GUICtrlCreateMenuItem("Edit Contact", $edit_menu)
		GUICtrlSetOnEvent(-1, "editClick")


	If $NM_DBLCLK Then
		_SQLite_Query($hDB, "SELECT ROWID, * FROM Contacts WHERE (ROWID=" & $recs & ");", $hQuery)
	Else
		_SQLite_Query($hDB, "SELECT ROWID, * FROM Contacts WHERE (ROWID=" & $recs[1] & ");", $hQuery)
	EndIf
		_SQLite_FetchData ($hQuery, $aRow)

	If Not IsArray($aRow) Then
		MsgBox(48, "Select Contact", "Please select a valid contact to edit.")
		ViewClick ()
		Return
	EndIf
	GUICtrlSetState($contactlist, $GUI_HIDE)
	$fname = GUICtrlCreateInput($aRow[1], 118, 88, 177, 21)
	GUICtrlSetState(-1, $GUI_FOCUS)
	GUICtrlCreateLabel("First Name", 38, 88, 54, 17)
	GUICtrlCreateLabel("Home Phone Number", 318, 136, 106, 17)
	$lname = GUICtrlCreateInput($aRow[2], 118, 136, 177, 21, $WS_TABSTOP)
	GUICtrlCreateLabel("Last Name", 38, 136, 55, 17)
	$address1 = GUICtrlCreateInput($aRow[3], 118, 184, 177, 21, $WS_TABSTOP)
	GUICtrlCreateLabel("Address", 38, 184, 42, 17)
	GUICtrlCreateLabel("Address 2", 38, 232, 51, 17)
	$address2 = GUICtrlCreateInput($aRow[4], 118, 232, 177, 21, $WS_TABSTOP)
	$cellnum = GUICtrlCreateInput($aRow[6], 438, 88, 169, 21, $WS_TABSTOP)
	GUICtrlCreateLabel("Cell Phone Number", 318, 88, 95, 17)
	$homenum = GUICtrlCreateInput($aRow[5], 438, 136, 169, 21, $WS_TABSTOP)
	$worknum = GUICtrlCreateInput($aRow[7], 438, 184, 169, 21, $WS_TABSTOP)
	GUICtrlCreateLabel("Work Phone Number", 318, 184, 104, 17)
	$c_view = GUICtrlCreateButton("View Contacts", 391, 312, 90, 25, 0)
	GUICtrlSetOnEvent(-1, "ViewClick")
	GUISetState(@SW_SHOW)
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
    $hWndListView = $contactlist
    If Not IsHWnd($contactlist) Then $hWndListView = GUICtrlGetHandle($contactlist)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
    Case $hWndListView

        if $iCode = $NM_DBLCLK Then
                editClick ()
        EndIf

    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _CreateDB ()
	_SQLite_Exec($hDB, "CREATE TABLE Contacts (FirstName, LastName, address, address2, cellnum, homenum, worknum);")
EndFunc

Func mainClose ()
	Exit
EndFunc
