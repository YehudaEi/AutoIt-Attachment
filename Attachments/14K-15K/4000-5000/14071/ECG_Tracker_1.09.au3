#region Include
#include <GUIConstants.au3>
#include <Date.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <GuiCombo.au3>

#endregion Include

Opt("GUIOnEventMode", 1)

#region Define Variables
Global $rsCurrent[25] ;recordset for data
;key#
;username created
;date/time created
;status (active or deleted)
;site
;department
;employee
;first contact
;point person
;received on
;method
;issue
;resolution
;contacted by
;date contacted
;status (pending, closed)
;username closed
;date/time closed
;username edited
;date/time edited
;
;
;
;
;
Global $rsFileData[500] ;main file data
Global $aSearchResults ;search results
Global $rsSearch[25] ;search criteria recordset
Global $rsLoaded[25] ;loaded from file recordset
Global $fsIni ;string where ini file is located
Global $fsProgramData ;string where program data is located
Global $fsDataBackup ;string where data backup is located
Global $sSite
Global $sDept
Const $pink = 0xFF8080
Const $white = 0xFFFFFF
Const $green = 0x808000
Const $red = 0xFF0000

#endregion Define Variables

#Region Forms
$fECGTracker = GUICreate("ECG Tracker", 593, 474, 215, 139)
GUISetIcon(@ScriptDir & "\OLG.ico")
GUISetFont(10, 400, 0, "Tahoma")
GUISetBkColor(0xFFFFFF)
GUISetOnEvent($GUI_EVENT_CLOSE, "fECGTrackerClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "fECGTrackerMinimize")
GUISetOnEvent($GUI_EVENT_RESTORE, "fECGTrackerRestore")
$pECGLogo = GUICtrlCreatePic(@ScriptDir & "\ECG-logo.gif", 15, 15, 75, 75, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "pECGLogoClick")
$pOLGLogo = GUICtrlCreatePic(@ScriptDir & "\OLG-Gaming-Logo.gif", 475, 15, 100, 63, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "pOLGLogoClick")
$lEmployee = GUICtrlCreateLabel("Employee:", 50, 110, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iEmployee = GUICtrlCreateInput("", 130, 110, 100, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iEmployeeChange")
$lFirstContact = GUICtrlCreateLabel("First Contact:", 50, 140, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iFirstContact = GUICtrlCreateInput("", 130, 140, 100, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iFirstContactChange")
$lPointPerson = GUICtrlCreateLabel("Point Person:", 50, 170, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iPointPerson = GUICtrlCreateInput("", 130, 170, 100, 24)
GUICtrlSetFont(-1,8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iPointPersonChange")
$lReceivedOn = GUICtrlCreateLabel("Received On:", 50, 200, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iReceivedOn = GUICtrlCreateInput("", 130, 200, 100, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetState(-1,$GUI_DISABLE)
$lRespondBy = GUICtrlCreateLabel("Respond By:", 50, 230, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iRespondBy = GUICtrlCreateInput("", 130, 230, 100, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetOnEvent(-1, "iRespondByChange")
$lMethod = GUICtrlCreateLabel("Method:", 50, 260, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$cMethod = GUICtrlCreateCombo("", 130, 260, 100, 25)
GUICtrlSetData(-1, "In Person|Phone Call|Email (Work)|Email (Home)|Any")
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "cMethodChange")
$eSuggestion = GUICtrlCreateEdit("", 250, 140, 330, 143, BitOR($ES_AUTOVSCROLL,$WS_VSCROLL,$ES_WANTRETURN))
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "eSuggestionChange")
$lSuggestion = GUICtrlCreateLabel("Suggestion / Concern / Issue:", 250, 110, 201, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label8 = GUICtrlCreateLabel("I", 15, 115, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label9 = GUICtrlCreateLabel("N", 15, 135, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label10 = GUICtrlCreateLabel("C", 15, 155, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label11 = GUICtrlCreateLabel("O", 15, 175, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label12 = GUICtrlCreateLabel("M", 15, 195, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label13 = GUICtrlCreateLabel("I", 15, 215, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label14 = GUICtrlCreateLabel("N", 15, 235, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label15 = GUICtrlCreateLabel("G", 15, 255, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label16 = GUICtrlCreateLabel("O", 15, 299, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label17 = GUICtrlCreateLabel("U", 15, 319, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label18 = GUICtrlCreateLabel("T", 15, 339, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label19 = GUICtrlCreateLabel("G", 15, 359, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label20 = GUICtrlCreateLabel("O", 15, 379, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label21 = GUICtrlCreateLabel("I", 15, 399, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label22 = GUICtrlCreateLabel("N", 15, 419, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$Label23 = GUICtrlCreateLabel("G", 15, 439, 18, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x000080)
$eResolution = GUICtrlCreateEdit("", 50, 325, 330, 135, BitOR($ES_AUTOVSCROLL,$WS_VSCROLL,$ES_WANTRETURN))
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "eResolutionChange")
$lResolution = GUICtrlCreateLabel("Summary of Resolution:", 50, 295, 201, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$lContactedBy = GUICtrlCreateLabel("Contacted By:", 400, 325, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iContactedBy = GUICtrlCreateInput("", 480, 325, 100, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iContactedByChange")
$lDate = GUICtrlCreateLabel("Date:", 400, 355, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$lStatusLabel = GUICtrlCreateLabel("Status:", 400, 385, 80, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$lStatus = GUICtrlCreateLabel("PENDING", 400, 415, 160, 39, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 18, 800, 0, "Tahoma")
GUICtrlSetColor(-1, $green)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$d1 = GUICtrlCreateDate("", 480, 355, 100, 25, $WS_TABSTOP)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "d1Change")
$iRecord1 = GUICtrlCreateInput("1", 220, 15, 65, 24, $ES_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iRecord1Change")
$ud1 = GUICtrlCreateUpdown($iRecord1, BitOR($UDS_ALIGNRIGHT,$UDS_HORZ))
GUICtrlSetOnEvent(-1, "ud1Change")
GUICtrlSetPos(-1, 270, 15, 40, 24)
$lRecord = GUICtrlCreateLabel("Record", 170, 15, 50, 25, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$lOf = GUICtrlCreateLabel("of", 310, 15, 30, 25, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iRecord2 = GUICtrlCreateInput("1", 340, 15, 50, 24, $ES_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "iRecord2Change")
GUICtrlSetState(-1,$GUI_DISABLE)
$bChange = GUICtrlCreateButton("Change", 375, 45, 60, 25, $BS_MULTILINE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bChangeClick")
$bExport = GUICtrlCreateButton("Export", 360, 75, 60, 25, BitOR($BS_VCENTER,$BS_MULTILINE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bExportClick")
$lCurrentView = GUICtrlCreateLabel("Current View:", 140, 45, 85, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$lView = GUICtrlCreateLabel("New Entry", 225, 45, 150, 25, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
GUICtrlSetColor(-1, 0x000080)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$bEdit = GUICtrlCreateButton("Edit", 220, 75, 60, 25, BitOR($BS_VCENTER,$BS_MULTILINE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bEditClick")
$bDelete = GUICtrlCreateButton("Delete", 290, 75, 60, 25, BitOR($BS_VCENTER,$BS_MULTILINE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bDeleteClick")
$bSave = GUICtrlCreateButton("Save", 150, 75, 60, 25, BitOR($BS_VCENTER,$BS_MULTILINE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bSaveClick")
$bSearch = GUICtrlCreateButton("Search", 355, 75, 60, 25, BitOR($BS_VCENTER,$BS_MULTILINE))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetOnEvent(-1, "bSearchClick")
GUICtrlSetState(-1, $GUI_HIDE)
$lSearch = GUICtrlCreateLabel("Enter the search criteria and click", 155, 75, 200, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetColor(-1, 0x000080)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1,$GUI_HIDE)
#EndRegion Forms

#region Main Program
;check for program updates
;$fsIni = @ScriptDir & "\ECG Tracker.ini"
;$DTM_SETFORMAT = 0x1005
;$v1 = "MMM-dd-yyyy"
;GuiCtrlSendMsg($d1, $DTM_SETFORMAT, 0, $v1)
$fsIni = "H:\ECG Tracker.ini"
If LoadIniData($fsIni) = 1 Then
	CheckFiles()
	LoadForm()
	GUISetState(@SW_SHOW)
	While 1
		Sleep(100)
	WEnd
Else
	MsgBox(16,"Error!","Cannot find 'EPG Tracker.ini', unable to start the application.")
EndIf
#endregion Main Program		
#region Form Functions
Func bChangeClick()
	ChangeView()
EndFunc
		
Func bDeleteClick()
	DeleteRecord()
EndFunc
		
Func bEditClick()
	EditForm()
EndFunc
		
Func bExportClick()
	
EndFunc
		
Func bSaveClick()
	SaveRecord()
EndFunc

Func bSearchClick()
	If GUICtrlRead($bSearch) = "Search" Then ;search for records using criteria
		LoadSearchResults()
	Else ;new search, clear all
		GUICtrlSetData($lView,"Search")
		LoadForm()
	EndIf
EndFunc
		
Func cMethodChange()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func d1Change()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func eResolutionChange()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func eSuggestionChange()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func fECGTrackerClose()
	Exit
EndFunc
		
Func fECGTrackerMinimize()

EndFunc
		
Func fECGTrackerRestore()

EndFunc
		
Func iContactedByChange()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func iEmployeeChange()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func iFirstContactChange()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func iPointPersonChange()
	UpdateForm()
	UpdateRecord()
	UpdateStatus()
EndFunc
		
Func iReceivedOnChange()

EndFunc
		
Func iRecord1Change()
	If Int(GUICtrlRead($iRecord2)) > 0 Then
		If Int(GUICtrlRead($iRecord1)) > Int(GUICtrlRead($iRecord2)) Then
			GUICtrlSetData($iRecord1,GUICtrlRead($iRecord2))
			Beep(500,100)
		Else
			If Int(GUICtrlRead($iRecord1)) < 1 Then
				GUICtrlSetData($iRecord1, "1")
				Beep(500,100)
			EndIf			
		EndIf
	Else
		If Int(GUICtrlRead($iRecord1)) <> 0 Then
			GUICtrlSetData($iRecord1,"0")
			Beep(500,100)
		EndIf
	EndIf
	ViewRecord(Int(GUICtrlRead($iRecord1)))
EndFunc
		
Func iRecord2Change()

EndFunc
		
Func iRespondByChange()

EndFunc
		
Func pECGLogoClick()

EndFunc
		
Func pOLGLogoClick()

EndFunc
		
Func ud1Change()

EndFunc
#endregion Form Functions

#region Initialize
Func ClearForm()
	GUICtrlSetData($iEmployee,"")
	GUICtrlSetData($iFirstContact,"")
	GUICtrlSetData($iPointPerson,"")
	GUICtrlSetData($iReceivedOn,"")
	GUICtrlSetData($iRespondBy,"")
	GUICtrlSetData($eSuggestion,"")
	GUICtrlSetData($eResolution,"")
	GUICtrlSetData($iContactedBy,"")
	_GUICtrlComboSetCurSel ($cMethod,0)
	GUICtrlSetData($d1,_NowCalcDate())
EndFunc

Func ClearCurrentRecord()
	Local $v1
	$rsCurrent[0] = 0
	$v1 = 1
	While $v1 < 25
		$rsCurrent[$v1] = ""
		$v1 = $v1 + 1
	WEnd
EndFunc

Func ClearLoadedRecord()
	Local $v1
	$rsLoaded[0] = 0
	$v1 = 1
	While $v1 < 25
		$rsLoaded[$v1] = ""
		$v1 = $v1 + 1
	WEnd	
EndFunc

Func ClearSearchRecord()
	Local $v1
	$rsSearch[0] = 0
	$v1 = 1
	While $v1 < 25
		$rsSearch[$v1] = ""
		$v1 = $v1 + 1
	WEnd	
EndFunc
#endregion Initialize

#region Program Functions
Func ChangeView()
	Switch GUICtrlRead($lView)
	Case "New Entry"
		GUICtrlSetData($lView,"Pending")
	Case "Pending"
		GUICtrlSetData($lView,"Critical")
	Case "Critical"
		GUICtrlSetData($lView,"Closed")
	Case "Closed"
		GUICtrlSetData($lView,"Search")
	Case "Search"
		GUICtrlSetData($lView,"New Entry")
	Case "Search Results"
		GUICtrlSetData($lView,"New Entry")
	EndSwitch
	LoadForm()
EndFunc

Func EditForm()
	If $rsLoaded[15] = 1 Then ;only pending can be edited (for now)
		EnableIncoming()
	Else
		If $rsLoaded[15] = 2 Then
			MsgBox(64,"Cannot Edit!","You cannot edit a previously closed record.")
		EndIf
	EndIf
EndFunc

Func SaveRecord()
	Local $v1
	$v1 = ValidateForm()
	If $v1 > 0 Then
		Switch $v1
		Case 1 ;incoming has changed
			If $rsCurrent[1] = "" Then ;to be pending entry
				$rsCurrent[1] = @UserName
				$rsCurrent[2] = _NowCalc()
			Else ;edited entry
				$rsCurrent[18] = @UserName
				$rsCurrent[19] = _NowCalc()
			EndIf
			$rsCurrent[15] = 1
		Case 2 ;outgoing has changed
			If $rsCurrent[16] = "" Then ;to be closed entry
				$rsCurrent[16] = @UserName
				$rsCurrent[17] = _NowCalc()
			Else ;edited entry
				$rsCurrent[18] = @UserName
				$rsCurrent[19] = _NowCalc()
			EndIf
			$rsCurrent[15] = 2
		Case 3 ;both have changed
			If $rsCurrent[1] = "" Then ;to be pending entry
				$rsCurrent[1] = @UserName
				$rsCurrent[2] = _NowCalc()
				$rsCurrent[15] = 1
			EndIf
			If $rsCurrent[16] = "" Then ;to be closed entry
				$rsCurrent[16] = @UserName
				$rsCurrent[17] = _NowCalc()
				$rsCurrent[15] = 2
			Else ;edited entry
				$rsCurrent[18] = @UserName
				$rsCurrent[19] = _NowCalc()
			EndIf				
		EndSwitch
		If WriteRecord($fsProgramData,$rsCurrent) Then ;success, clear form and update records
			LoadForm()
			Return 1
		Else ;didn't save
			MsgBox(53,"NOT SAVED!","There was an error saving this record. (Error " & @error & ")")
			Return 0
		EndIf
	Else
		If $v1 <> -1 Then ;missing information
			MsgBox(48,"Missing Information!","Please make sure all highlighted fields are filled out before saving.")
			Return 0
		Else ;no changes, save not needed
			Return 1
		EndIf
	EndIf
EndFunc

Func ViewRecord($recnum)
	Local $a1
	If $recnum <> 0 Then 
		$a1 = StringSplit($rsFileData[$recnum - 1],",") ;don't set directly to rsloaded in case of error
		If UBound($a1) > 24 Then ;copy into loaded recordset
			$rsLoaded = $a1
			_arraypush($rsLoaded,"")
			$rsCurrent = $rsLoaded
		Else
			ClearLoadedRecord()
		EndIf
	Else
		ClearLoadedRecord()
	EndIf
	GUICtrlSetData($iReceivedOn,$rsLoaded[9]) ;populate form
	If $rsLoaded[9] <> "" Then
		GUICtrlSetData($iRespondBy,_DateAdd("D",3,$rsLoaded[9]))
	Else
		GUICtrlSetData($iRespondBy,"")
	EndIf
	GUICtrlSetData($iEmployee,$rsLoaded[6])
	GUICtrlSetData($iFirstContact,$rsLoaded[7])
	GUICtrlSetData($iPointPerson,$rsLoaded[8])
	If $rsLoaded[10] <> "" Then
		GUICtrlSetData($cMethod,$rsLoaded[10])
	Else
		_GUICtrlComboSetCurSel($cMethod,0)
	EndIf
	GUICtrlSetData($eSuggestion,$rsLoaded[11])
	GUICtrlSetData($eResolution,$rsLoaded[12])
	GUICtrlSetData($iContactedBy,$rsLoaded[13])
	GUICtrlSetData($d1,$rsLoaded[14])
	;UpdateStatus() shouldn't be needed, as each change in field calls this function
EndFunc

Func DeleteRecord()
	If $rsLoaded[0] <> 0 Then ;existing record
		If MsgBox(291,"Confirm Delete","Are you sure you want to delete this record?") = 6 Then
			$rsLoaded[3] = 2 ;set deleted flag
			$rsLoaded[20] = @UserName
			$rsLoaded[21] = _NowCalc()
			$rsCurrent = $rsLoaded
			If WriteRecord($fsProgramData,$rsCurrent) Then ;success, clear form and update records
				LoadForm()
				Return 1
			Else ;didn't save
				MsgBox(53,"Error!","There was an error deleting this record. (Error " & @error & ")")
				Return 0
			EndIf
		EndIf
	Else
		MsgBox(64,"Delete","Please select a record before hitting the delete button.")
	EndIf
EndFunc

Func LoadNew()
	GUICtrlSetData($lView,"New Entry")
	DisableRecords()
	EnableIncoming()
	DisableOutgoing()
	DisableSearch()
EndFunc

Func LoadPending()
	GUICtrlSetData($lView,"Pending")
	EnableRecords()
	DisableIncoming()
	EnableOutgoing()
	DisableSearch()
	LoadRecords()
EndFunc

Func LoadClosed()
	GUICtrlSetData($lView,"Closed")
	EnableRecords()
	DisableIncoming()
	DisableOutgoing()
	DisableSearch()
	LoadRecords()
EndFunc

Func LoadCritical()
	GUICtrlSetData($lView,"Critical")
	EnableRecords()
	DisableIncoming()
	EnableOutgoing()
	DisableSearch()
	LoadRecords()
EndFunc

Func LoadSearch()
	GUICtrlSetData($lView,"Search")
	GUICtrlSetData($bSearch,"Search")
	GUICtrlSetData($lSearch,"Enter the search criteria and click")
	DisableRecords()
	EnableIncoming()
	EnableOutgoing()
	EnableSearch()
EndFunc

Func LoadSearchResults()
	GUICtrlSetData($lView,"Search Results")
	GUICtrlSetData($bSearch,"New")
	GUICtrlSetData($lSearch,"To start a new search, click")
	DisableRecords()
	EnableIncoming()
	EnableOutgoing()
	EnableSearch()
	LoadRecords()
EndFunc

Func LoadRecords()
	Local $aTemp[500]
	Local $v1,$v2
	Local $fp1
	$rsFileData = $aTemp ;clear array
	$fp1 = FileOpen($fsProgramData,0)
	If $fp1 <> -1 Then
		$v1 = CountFileRecords($fp1)
		$v2 = 499
		While $v1 > 0 And $v2 >= 0 
			$rsFileData[$v2] = FileReadLine($fp1,$v1)
			If @error <> -1 Then
				If ValidRecord($rsFileData[$v2]) Then
					$v2 = $v2 - 1
				EndIf
			Else
				MsgBox(48,"File Error!","Cannot open the data file! (Error LoadRecords2)")
				$v2 = -1
			EndIf
			$v1 = $v1 - 1
		WEnd
		;If $v1 <> 0 there were more records than the recordset can hold
		GUICtrlSetData($iRecord2,499 - $v2)
		If $v2 <> 499 Then ;there is records
			GUICtrlSetData($iRecord1,1)
			_ArrayReverse($rsFileData) ;place records newest first
		Else
			GUICtrlSetData($iRecord1,0)
		EndIf
		ViewRecord(Int(GUICtrlRead($iRecord1)))
	Else
		MsgBox(48,"File Error!","Cannot open the data file! (Error LoadRecords1)")
	EndIf
EndFunc

Func ValidRecord($sRecord) ;check if record is member of current view recordset
	Local $aTemp
	$aTemp = StringSplit($sRecord,",")
	_arraypush($aTemp,"")
	If UBound($aTemp) > 24 Then ;there is at least 25 elements in the array
		Switch GUICtrlRead($lView)
		Case "Pending"
			If $aTemp[1] <> "" And $aTemp[16] = "" And $aTemp[3] = 1 Then
				Return 1
			Else
				Return 0
			EndIf
		Case "Critical"
			If _DateDiff("D",$aTemp[9],_NowCalc()) > 3 And $aTemp[3] = 1 Then
				Return 1
			Else
				Return 0
			EndIf
		Case "Closed"
			If $aTemp[1] <> "" And $aTemp[16] <> "" And $aTemp[3] = 1 Then
				Return 1
			Else
				Return 0
			EndIf		
		Case "Search Results"
			If (StringInStr($aTemp[6],$rsSearch[6]) Or StringInStr($aTemp[7],$rsSearch[7]) Or StringInStr($aTemp[8],$rsSearch[8]) Or StringInStr($aTemp[11],$rsSearch[11]) Or StringInStr($aTemp[12],$rsSearch[12]) Or StringInStr($aTemp[13],$rsSearch[13])) And $aTemp[3] = 1 Then
				Return 1
			Else
				Return 0
			EndIf		
		EndSwitch
	Else
		Return 0
	EndIf
EndFunc

Func DisableIncoming()
	GUICtrlSetState($iEmployee,$GUI_DISABLE)
	GUICtrlSetState($iFirstContact,$GUI_DISABLE)
	GUICtrlSetState($iPointPerson,$GUI_DISABLE)
	GUICtrlSetState($cMethod,$GUI_DISABLE)
	GUICtrlSetState($eSuggestion,$GUI_DISABLE)
EndFunc

Func EnableIncoming()
	GUICtrlSetState($iEmployee,$GUI_ENABLE)
	GUICtrlSetState($iFirstContact,$GUI_ENABLE)
	GUICtrlSetState($iPointPerson,$GUI_ENABLE)
	GUICtrlSetState($cMethod,$GUI_ENABLE)
	GUICtrlSetState($eSuggestion,$GUI_ENABLE)
EndFunc

Func EnableOutgoing()
	GUICtrlSetState($eResolution,$GUI_ENABLE)
	GUICtrlSetState($iContactedBy,$GUI_ENABLE)
	GUICtrlSetState($d1,$GUI_ENABLE)
EndFunc

Func DisableOutgoing()
	GUICtrlSetState($eResolution,$GUI_DISABLE)
	GUICtrlSetState($iContactedBy,$GUI_DISABLE)
	GUICtrlSetState($d1,$GUI_DISABLE)
EndFunc

Func EnableRecords()
	GUICtrlSetState($lRecord,$GUI_SHOW)
	GUICtrlSetState($lOf,$GUI_SHOW)
	GUICtrlSetState($iRecord1,$GUI_SHOW)
	GUICtrlSetState($iRecord2,$GUI_SHOW)
	GUICtrlSetState($ud1,$GUI_SHOW)
	GUICtrlSetPos($iRecord1, 220, 15, 75, 24)
	GUICtrlSetPos($iRecord1, 220, 15, 65, 24)
	GUICtrlSetPos($ud1, 270, 15, 50, 24)
	GUICtrlSetPos($ud1, 270, 15, 40, 24)
EndFunc

Func DisableRecords()
	GUICtrlSetState($lRecord,$GUI_HIDE)
	GUICtrlSetState($lOf,$GUI_HIDE)
	GUICtrlSetState($iRecord1,$GUI_HIDE)
	GUICtrlSetState($iRecord2,$GUI_HIDE)
	GUICtrlSetState($ud1,$GUI_HIDE)
EndFunc

Func EnableSearch()
	GUICtrlSetState($bSave,$GUI_HIDE)
	GUICtrlSetState($bEdit,$GUI_HIDE)
	GUICtrlSetState($bDelete,$GUI_HIDE)
	GUICtrlSetState($bExport,$GUI_HIDE)
	GUICtrlSetState($bSearch,$GUI_SHOW)
	GUICtrlSetState($bSearch,$GUI_ENABLE)
	GUICtrlSetState($lSearch,$GUI_SHOW)
EndFunc

Func DisableSearch()
	GUICtrlSetState($bSave,$GUI_SHOW)
	GUICtrlSetState($bEdit,$GUI_SHOW)
	GUICtrlSetState($bDelete,$GUI_SHOW)
	GUICtrlSetState($bExport,$GUI_SHOW)
	GUICtrlSetState($bSearch,$GUI_HIDE)
	GUICtrlSetState($bSearch,$GUI_DISABLE)
	GUICtrlSetState($lSearch,$GUI_HIDE)
EndFunc

Func LoadForm()
	ClearForm()
	ClearCurrentRecord()
	ClearLoadedRecord()
	ClearSearchRecord()
	Switch GUICtrlRead($lView)
	Case "New Entry"
		LoadNew()
	Case "Pending"
		LoadPending()
	Case "Critical"
		LoadCritical()		
	Case "Closed"
		LoadClosed()
	Case "Search"
		LoadSearch()
	Case "Search Results"
		LoadSearchResults()
	EndSwitch
	UpdateStatus()
EndFunc

Func WriteRecord($fn,$rs)
	Local $fp1
	Local $v1
	If $rs[0] <> 0 Then ;update existing record
		$v1 = _ArrayToString($rs,",")
		_ArrayDisplay($rs,"")
		If $v1 <> "" Then
			If _FileWriteToLine($fn,$rs[0],$v1,1) Then
				Return 1
			Else
				SetError(5)
				Return 0
			EndIf
		Else
			SetError(4)
			Return 0
		EndIf
	Else ;new record
		$fp1 = FileOpen($fn,1) ;lock file for writing
		If $fp1 Then
			$rs[0] = CountFileRecords($fp1) + 1
			$v1 = _ArrayToString($rs,",")
			If $v1 <> "" Then
				If FileWriteLine($fp1,$v1) Then ;success
					FileClose($fp1)
					Return 1
				Else ;failed
					SetError(3)
					FileClose($fp1)
					Return 0
				EndIf
			Else
				SetError(2)
				FileClose($fp1)
				Return 0
			EndIf
		Else
			SetError(1)
			FileClose($fp1)
			Return 0
		EndIf
	EndIf
EndFunc

Func ReadRecord($fn,$rs,$rn)
	
EndFunc

Func CheckFiles() ;check if data exists, requires a backup, requires a recovery or requires archiving (if more than 2 ? years old)

EndFunc

Func LoadIniData($filename)
	Local $a1
	Local $v1
	$v1 = 1 ;set flag for return value
	$a1 = IniReadSection($filename,"File Locations")
	If @error = 1 Then ;check to make sure ini file exists
		If FileExists($filename) Then ;section not found
			SetError(1)
			$v1 = 0
		Else ;file not found
			SetError(2)
			$v1 = 0
		EndIf
	Else
		If $a1[1][0] = "Program Data" Then 
			$fsProgramData = $a1[1][1]
			If $a1[2][0] = "Data Backup" Then 
				$fsDataBackup = $a1[2][1]
			Else ;key not found
				SetError(3)
				$v1 = 0
			EndIf
		Else ;key not found
			SetError(3)
			$v1 = 0
		EndIf
		$a1 = IniReadSection($filename,"Settings")
		If $a1[1][0] = "Site" Then 
			$sSite = $a1[1][1]
			If $a1[2][0] = "Department" Then 
				$sDept = $a1[2][1]
			Else ;key not found
				SetError(3)
				$v1 = 0
			EndIf
		Else ;key not found
			SetError(3)
			$v1 = 0
		EndIf
	EndIf
	Return $v1
EndFunc

Func ValidateForm()
	Local $v1
	$v1 = CompareRecords()
	Switch $v1
	Case 0
		Return -1 ;no changes
	Case 1
		If ValidateNew() Then
			Return 1
		Else
			Return 0
		EndIf
	Case 2
		If ValidatePending() Then
			Return 2
		Else
			Return 0
		EndIf				
	Case 3
		If ValidateNew() And ValidatePending() Then
			Return 3
		Else
			Return 0
		EndIf
	EndSwitch
EndFunc

Func ValidateNew()
	If GUICtrlRead($iEmployee) <> "" Then
		GUICtrlSetBkColor($iEmployee,$white)
		If GUICtrlRead($iFirstContact) <> "" Then
			GUICtrlSetBkColor($iFirstContact,$white)
			If GUICtrlRead($iPointPerson) <> "" Then
				GUICtrlSetBkColor($iPointPerson,$white)
				If GUICtrlRead($cMethod) <> "" Then
					GUICtrlSetBkColor($cMethod,$white)
					If GUICtrlRead($eSuggestion) <> "" Then
						GUICtrlSetBkColor($eSuggestion,$white)
						Return 1
					Else
						GUICtrlSetBkColor($eSuggestion,$pink)
						Return 0
					EndIf
				Else
					GUICtrlSetBkColor($cMethod,$pink)
					Return 0
				EndIf
			Else
				GUICtrlSetBkColor($iPointPerson,$pink)
				Return 0
			EndIf
		Else
			GUICtrlSetBkColor($iFirstContact,$pink)
			Return 0
		EndIf
	Else
		GUICtrlSetBkColor($iEmployee,$pink)
		Return 0
	EndIf
EndFunc

Func ValidatePending()
	If GUICtrlRead($eResolution) <> "" Then
		GUICtrlSetBkColor($eResolution,$white)
		If GUICtrlRead($iContactedBy) <> "" Then
			GUICtrlSetBkColor($iContactedBy,$white)
			Return 1
		Else
			GUICtrlSetBkColor($iContactedBy,$pink)
			Return 0
		EndIf
	Else
		GUICtrlSetBkColor($eResolution,$pink)
		Return 0
	EndIf
EndFunc

Func CompareRecords() ;returns 0 for exact match, 1 for first subset, 2 for second subset, and 3 for both
	Local $v1 = 4
	Local $v2 = 0
	Local $v3 = 0
	While $v1 < 12 And $v2 = 0
		If $rsCurrent[$v1] <> $rsLoaded[$v1] Then
			$v2 = 1
		EndIf
		$v1 = $v1 + 1
	WEnd
	$v1 = 12
	While $v1 < 15 And $v3 = 0
		If $rsCurrent[$v1] <> $rsLoaded[$v1] Then
			$v3 = 2
		EndIf
		$v1 = $v1 + 1
	WEnd	
	Return $v2 + $v3
EndFunc

Func UpdateRecord() ;update recordset from form
	If GUICtrlRead($lView) <> "Search" Then ;save to current recordset
		$rsCurrent[3] = 1 ;status is active
		$rsCurrent[4] = $sSite
		$rsCurrent[5] = $sDept
		$rsCurrent[6] = GUICtrlRead($iEmployee)
		$rsCurrent[7] = GUICtrlRead($iFirstContact)
		$rsCurrent[8] = GUICtrlRead($iPointPerson)
		$rsCurrent[9] = GUICtrlRead($iReceivedOn)
		$rsCurrent[10] = GUICtrlRead($cMethod)
		$rsCurrent[11] = GUICtrlRead($eSuggestion)
		$rsCurrent[12] = GUICtrlRead($eResolution)
		$rsCurrent[13] = GUICtrlRead($iContactedBy)
		If GUICtrlGetState($d1) = 80 Then ;enabled
			$rsCurrent[14] = GUICtrlRead($d1) ;otherwise, a new record has a discrepancy
		EndIf
	Else ;save to search recordset
		$rsSearch[6] = GUICtrlRead($iEmployee)
		$rsSearch[7] = GUICtrlRead($iFirstContact)
		$rsSearch[8] = GUICtrlRead($iPointPerson)
		$rsSearch[9] = GUICtrlRead($iReceivedOn)
		$rsSearch[10] = GUICtrlRead($cMethod)
		$rsSearch[11] = GUICtrlRead($eSuggestion)
		$rsSearch[12] = GUICtrlRead($eResolution)
		$rsSearch[13] = GUICtrlRead($iContactedBy)
		$rsSearch[14] = GUICtrlRead($d1)
	EndIf
EndFunc

Func UpdateForm()
	If GUICtrlRead($iEmployee) <> "" And GUICtrlRead($iFirstContact) <> "" And GUICtrlRead($iPointPerson) <> "" And GUICtrlRead($iReceivedOn) = "" Then
		GUICtrlSetData($iReceivedOn, _NowCalc())
		GUICtrlSetData($iRespondBy, _DateAdd('d',3,_NowCalc()))
	EndIf
	If GUICtrlRead($d1) > _NowDate() Then
		MsgBox(48,"Date Error!","You cannot choose a future date for the date of contact!")
		GUICtrlSetData($d1,_NowCalcDate())
	EndIf	
EndFunc

Func UpdateStatus() ;check if status needs to be changed to closed
	If $rsCurrent[6] <> "" And $rsCurrent[7] <> "" And $rsCurrent[8] <> "" And $rsCurrent[9] <> "" And $rsCurrent[11] <> "" Then
		;status is pending, check to see if closed
		If $rsCurrent[12] <> "" And $rsCurrent[13] <> "" And $rsCurrent[14] <> "" Then ;status is closed
			GUICtrlSetData($lStatus,"CLOSED")
			GUICtrlSetColor($lStatus,$green)
		Else
			If _DateDiff("D",$rsCurrent[9],_NowCalc()) > 3 Then ;critical
				GUICtrlSetData($lStatus,"CRITICAL")
				GUICtrlSetColor($lStatus,$red)
			Else
				GUICtrlSetData($lStatus,"PENDING")
				GUICtrlSetColor($lStatus,$green)
			EndIf
		EndIf
	Else ;not enough data for pending or closed
		GUICtrlSetData($lStatus,"")
	EndIf
EndFunc

Func CountFileRecords($f1)
	Local $v1
	$v1 = 0
	While @error = 0
		If FileReadLine($f1) <> "" Then
			$v1 = $v1 + 1
		EndIf
	WEnd
	$v1 = $v1 - 1
	Return $v1
EndFunc

#endregion Program Functions
