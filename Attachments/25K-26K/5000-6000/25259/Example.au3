; FUNCTIONS
; _SetProg(), FreeDBQuery()

Global $Button_use, $Combo_agen
Global $Input_acat, $Input_an, $Input_ast, $Input_ayr, $Input_comm, $Input_tra, $Input_trn
Global $Label_wait, $ListView_tta, $Progress_query

Global $aCDInfos, $aCDTracks, $AddNew, $aDGCD, $aQuery, $aRead, $aSS, $CDResults, $Choose
Global $dbalb, $dbart, $dbcat, $dbgen, $dbyr, $drv, $genres, $hBut_AskFreeDB, $hBut_OK
Global $hComb_Drive, $hLab_Text, $hListV, $hTi, $hWinmmDLL, $i, $iProg, $More, $Query
Global $quit, $sCombostring, $sDatabase, $sQuery, $ta, $tn, $wait

#include "CDDB.au3"
#Include <GuiListView.au3>

;Example for CDDB.au3 - By GtaSpider (modified by TheSaint for his version of CDDB.au3)

$aDGCD = DriveGetDrive("CDROM")
$sCombostring = ''
For $i = 1 To $aDGCD[0]
	$sCombostring &= StringUpper($aDGCD[$i]) & "|"
Next
StringTrimRight($sCombostring, 1)

$Choose = GUICreate("Choose one drive", 150, 95, -1, -1, -1, 128);$WS_EX_TOOLWINDOW
$hComb_Drive = GUICtrlCreateCombo("", 10, 10, 50, 22)
GUICtrlSetData(-1, $sCombostring, $aDGCD[1])
$hBut_AskFreeDB = GUICtrlCreateButton("Ask FreeDB", 65, 10, 80, 22, 1) ; Style = $BS_DEFPUSHBUTTON
$hLab_Text = GUICtrlCreateLabel('Please choose one of the CD drives and click on "Ask FreeDB" to receive informations of the CD.', 10, 35, 130, 60)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $hBut_AskFreeDB
			$drv = GUICtrlRead($hComb_Drive)
			GUIDelete($Choose)
			FreeDBQuery()
			ExitLoop
		Case - 3 ;$GUI_EVENT_CLOSE = -3
			Exit
	EndSwitch
WEnd

Exit

Func FreeDBQuery()
	; This code is TheSaint's modified version of example provided by GtaSpider for his CDDB.au3
	; (as used in CDIni Database - available soon from TheSaint's Toolbox at the AutoIt Forum)
	; TheSaint has added several elements, modified some error code in a few segments, duplicated
	; and modified a section to work with many FreeDB returns for a query, and most importantly
	; added a delay feature to cater for a return that includes long track entries (i.e. Various
	; Artist CD's with artist name & track title in the same field ... especially for Duet names)
	; This example, also includes the OPEN & CLOSE dll portions of code, that was originally in
	; CDDB.au3 - I separated this element, so that the DLL is not open needlessly (i.e when the
	; originating program is open for long periods, like my CDIni Database program)
	;
	; Please note that some elements below are disabled - they only work with my CDIni Database
	; (those elements could be modified to write directly to your Windows Cdplayer.ini file)
	;
	$wait = InputBox("FreeDB Query", "If not all tracks etc are returned, then" & @LF & _
		"enter a number (for seconds to delay)" & @LF & _
		"to increase chances of a full return on" & @LF & _
		"a retry (i.e.  6  ... for 'Various Artists').", "", "", 220, 160)
	If @error > 0 Or $wait < 1 Then
		$wait = ""
	Else
		$wait = $wait * 1000
	EndIf
	
	Global $hWinmmDLL = DllOpen("winmm.dll")
	Global $Progress_query
	;
	$Query = GUICreate("FreeDB Query", 150, 65, -1, -1, -1, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	$Label_wait = GUICtrlCreateLabel("Please wait until the CDDB query for drive " & $drv & "\ finishes.", 10, 30, 130, 25)
	$Progress_query = GUICtrlCreateProgress(10, 10, 130, 14, 8)
	GUICtrlSetColor(-1, 0)
	
	GUISetState()
	
	While 1
		Switch GUIGetMsg()
		Case - 3 ;$GUI_EVENT_CLOSE = -3
			ExitLoop
		Case Else
			ExitLoop
		EndSwitch
	WEnd
	
	Global $iProg = 0
	AdlibEnable("_SetProg", 100)
	;
	$hTi = TimerInit()
	$sQuery = _CDDBCreateQuery($drv)
	If @error Or (Not $sQuery) Then
		GUIDelete($Query)
		MsgBox(262160, "Error 1", "errorcode " & @error)
	Else
		ConsoleWrite($sQuery & @CRLF)
		;
		$sDatabase = _FreeDBRecvDB($sQuery, $wait)
		If @error = 1 Or (Not $sDatabase) Or StringInStr($sDatabase, "202 No match for disc ID") Then
			GUIDelete($Query)
			MsgBox(262160, "Error 2", "2errorcode " & @error & @CRLF & $sDatabase)
		Else
			$quit = ""
			;
			If StringInStr($sDatabase, "211 Found inexact matches") _
				Or StringInStr($sDatabase, "210 Found exact matches") Then
				$More = GUICreate("More than just one found", 250, 185, -1, -1, -1, $WS_EX_TOPMOST)
				$hListV = GUICtrlCreateListView("Matches Found", 10, 10, 200, 150)
				GUICtrlSendMsg(-1, 0x101E, 0, 180)
				$aSS = StringSplit($sDatabase, @CRLF, 1)
				For $i = 2 To $aSS[0] - 2
					GUICtrlCreateListViewItem($aSS[$i], $hListV)
					If $i = 2 Then GUICtrlSetState(-1,256);$GUI_FOCUS
				Next
				$hBut_OK = GUICtrlCreateButton("OK", 10, 165, 200, 15,1)
				
				GUISetState()
				While 1
					Switch GUIGetMsg()
						Case $hBut_OK
							$aRead = StringSplit(StringTrimRight(GUICtrlRead(GUICtrlRead($hListV)), 1), " ")
							GUIDelete($More)
							$aQuery = StringSplit($sQuery, " ")
							If StringInStr($sDatabase, "210 Found exact matches") Then
								$sQuery = StringReplace($sQuery, $aQuery[3], $aRead[1] & $aRead[2])
								$quit = 2
							Else
								$sQuery = StringReplace($sQuery, $aQuery[3], $aRead[2])
							EndIf
							ConsoleWrite($sQuery & @CRLF)
							$sDatabase = _FreeDBRecvDB($sQuery, $wait)
							If @error = 1 Or (Not $sDatabase) Or StringInStr($sDatabase, "202 No match for disc ID") Then
								$quit = 1
								MsgBox(16, "Error 3", "2errorcode " & @error & @CRLF & $sDatabase)
							EndIf
							ExitLoop
						Case - 3 ;$GUI_EVENT_CLOSE = -3
							ExitLoop
					EndSwitch
				WEnd
			EndIf
			If $quit = 2 Then
				If StringInStr($sDatabase, "211 Found inexact matches") Then
					$More = GUICreate("More than just one found", 220, 185, -1, -1, -1, $WS_EX_TOPMOST)
					$hListV = GUICtrlCreateListView("Matches Found", 10, 10, 200, 150)
					GUICtrlSendMsg(-1, 0x101E, 0, 180)
					$aSS = StringSplit($sDatabase, @CRLF, 1)
					For $i = 2 To $aSS[0] - 2
						GUICtrlCreateListViewItem($aSS[$i], $hListV)
						If $i = 2 Then GUICtrlSetState(-1,256);$GUI_FOCUS
					Next
					$hBut_OK = GUICtrlCreateButton("OK", 10, 165, 200, 15,1)
					
					GUISetState()
					While 1
						Switch GUIGetMsg()
							Case $hBut_OK
								$aRead = StringSplit(StringTrimRight(GUICtrlRead(GUICtrlRead($hListV)), 1), " ")
								GUIDelete($More)
								$aQuery = StringSplit($sQuery, " ")
								$sQuery = StringReplace($sQuery, $aQuery[3], $aRead[2])
								ConsoleWrite($sQuery & @CRLF)
								$sDatabase = _FreeDBRecvDB($sQuery, $wait)
								If @error = 1 Or (Not $sDatabase) Or StringInStr($sDatabase, "202 No match for disc ID") Then
									$quit = 1
									MsgBox(16, "Error 4", "2errorcode " & @error & @CRLF & $sDatabase)
								EndIf
								ExitLoop
							Case - 3 ;$GUI_EVENT_CLOSE = -3
								ExitLoop
						EndSwitch
					WEnd
				EndIf
			EndIf
			If $quit <> 1 Then
				$aCDInfos = _FreeDBRetCDInfos($sDatabase)
				$aCDTracks = _FreeDBRetCDTracks($sDatabase)
				$hTi = TimerDiff($hTi)
				AdlibDisable()
				GUIDelete($Query)
				;
				$CDResults = GUICreate("Query for the CD took " & Round($hTi / 1000, 1) & " seconds", 680, 160)
				GUICtrlCreateLabel("CD Title:", 8, 10, 50)
				GUICtrlCreateInput($aCDInfos[1], 55, 8, 210, 18)
				GUICtrlCreateLabel("CD Artist:", 8, 30, 50)
				GUICtrlCreateInput($aCDInfos[0], 55, 28, 210, 18)
				GUICtrlCreateLabel("CD Genre:", 8, 50, 50)
				GUICtrlCreateInput($aCDInfos[2], 55, 48, 210, 18)
				GUICtrlCreateLabel("CD Year:", 8, 70, 50)
				GUICtrlCreateInput($aCDInfos[3], 55, 68, 210, 18)
				GUICtrlCreateLabel("CD Extd:", 8, 90, 50)
				GUICtrlCreateInput($aCDInfos[4], 55, 88, 210, 18)
				;
				$Button_use = GUICtrlCreateButton("USE THESE DETAILS", 60, 120, 160, 30)
				GUICtrlSetFont($Button_use, 9, 600)
				GUICtrlSetTip($Button_use, "Enter current details into the Scan dialog fields!")
				;
				$hListV = GUICtrlCreateListView("No.|Track Title|Time|Start", 270, 8, 400, 149)
				GUICtrlSendMsg(-1, 0x101E, 0, 90)
				GUICtrlSendMsg(-1, 0x101E, 1, 35)
				GUICtrlSendMsg(-1, 0x101E, 2, 35)
				For $i = 0 To UBound($aCDTracks) - 1
					GUICtrlCreateListViewItem($i + 1 & "|" & $aCDTracks[$i][0] & "|" & $aCDTracks[$i][1] & "|" & $aCDTracks[$i][2], $hListV)
				Next
				;
				_GUICtrlListViewSetColumnWidth($hListV, 1, $LVSCW_AUTOSIZE)
				_GUICtrlListViewSetColumnWidth($hListV, 2, $LVSCW_AUTOSIZE)
				_GUICtrlListViewSetColumnWidth($hListV, 3, $LVSCW_AUTOSIZE_USEHEADER)
				_GUICtrlListViewSetColumnWidth($hListV, 0, $LVSCW_AUTOSIZE_USEHEADER)

				GUISetState()
				While 1
					Switch GUIGetMsg()
						Case $Button_use
							;GUISwitch($AddNew)
							$dbart = $aCDInfos[0]
							;GUICtrlSetData($Input_an, $dbart)
							$dbalb = $aCDInfos[1]
							;GUICtrlSetData($Input_ast, $dbalb)
							$dbyr = $aCDInfos[3]
							;GUICtrlSetData($Input_ayr, $dbyr)
							$dbgen = $aCDInfos[2]
							If $dbgen <> "" Then
								If $dbgen = "Rock" Or $dbgen = "Misc" Or $dbgen = "Classical" _
									Or $dbgen = "Blues" Or $dbgen = "Country" Or $dbgen = "Jazz" _
									Or $dbgen = "Folk" Or $dbgen = "Reggae" Or $dbgen = "Newage" _
									Or $dbgen = "Soundtrack" Then
									;GUICtrlSetData($Combo_agen, "", "")
									;GUICtrlSetData($Combo_agen, $genres, $dbgen)
								Else
									$dbcat = $dbgen
									;GUICtrlSetData($Input_acat, $dbcat)
									$dbgen = ""
								EndIf
							EndIf
							;GUICtrlSetData($Input_comm, $aCDInfos[4])
							For $i = 0 To UBound($aCDTracks) - 1
								$tn = $aCDTracks[$i][0]
								If StringInStr($tn, " / ") > 0 Then
									$tn = StringSplit($tn, " / ", 1)
									$ta = $tn[1]
									$tn = $tn[2]
									If $tn <> "" Then
										;_GUICtrlListViewSetItemText($ListView_tta, $i, 1, $tn)
									EndIf
									;_GUICtrlListViewSetItemText($ListView_tta, $i, 2, $ta)
									If $i = 0 Then
										;If $tn <> "" Then GUICtrlSetData($Input_trn, $tn)
										;GUICtrlSetData($Input_tra, $ta)
									EndIf
								Else
									If $tn <> "" Then
										;_GUICtrlListViewSetItemText($ListView_tta, $i, 1, $tn)
										;If $i = 0 Then GUICtrlSetData($Input_trn, $tn)
									EndIf
								EndIf
							Next
							;
							;_GUICtrlListViewSetColumnWidth($ListView_tta, 1, $LVSCW_AUTOSIZE)
							;DetermineColumnThreeWidth()
							;GUISwitch($CDResults)
							GUIDelete($CDResults)
							ExitLoop
						Case - 3 ;$GUI_EVENT_CLOSE = -3
							GUIDelete($CDResults)
							ExitLoop
					EndSwitch
				WEnd
			EndIf
		EndIf
	EndIf
	;
	__SendMCIString("close cd1")
	DllClose($hWinmmDLL)
EndFunc ;=> FreeDBQuery (GUI)


Func _SetProg()
	$iProg += 1
	GUICtrlSetData($Progress_query, $iProg)
EndFunc   ;==>_SetProg
