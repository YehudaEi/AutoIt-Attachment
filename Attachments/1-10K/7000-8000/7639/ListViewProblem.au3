#include <Constants.au3>
#include <GuiConstants.au3>
#Include <GuiListView.au3>
#include 'ListViewProblemVars.au3'

$Title = 'List View Problem'
$WSUS_Svr = 'http://update.microsoft.com'
$Advice = 'Get a life!'
$NumMISSING = 16
$Browser = RegRead ( 'HKEY_CLASSES_ROOT\HTTP\shell\open\command', '' ) & ' '

#region GUI Variables
Dim $iMsgBoxAnswer
Dim $ListItems[$NumOfUpdates+1]
Dim $ContextMenu[$NumOfUpdates+1]
Dim $BulletinContext[$NumOfUpdates+1]
Dim $KbContext[$NumOfUpdates+1]
$DesktopWidth = @DesktopWidth
$DesktopHeight = @DesktopHeight
;$DesktopWidth = 1024	; Used for testing only
;$DesktopHeight = 768	; Used for testing only
$GuiLeft = 0
$GuiTop = 0
$GuiWidth = 800
$GuiHeight = 470
If $DesktopWidth > 640 Then $GuiLeft = ($DesktopWidth-$GuiWidth)/2
If $DesktopHeight > 480 Then $GuiTop = ($DesktopHeight-$GuiHeight)/4
; At 1024x768, $GuiLeft =112, $GuiTop = 75

Dim $ListIndex[$NumOfUpdates+1][8]
; ListIndex Elements
; Element 0 = List Item ControlID ($ListItems[x]
; Element 1 = ControlID which list it belongs to - $InstalledList or $MissingList
; Element 2 = Zero based index of item (0 through n) in the list it belongs to
;
; Element 3 = Update Index #
; Element 4 = KBID
; Element 5 = Update Description
; Element 6 = Download File Name
; Element 7 = Download URL

; ListIndex ZERO Elements
$ListIndex[0][0] = 0	; Total Number of items
$ListIndex[0][1] = 0	; Installed List counter - for index of list's item#
$ListIndex[0][2] = 0	; Missing List counter - for index of list's item#
#endregion GUI Variables

#region GUI Define
; Main Window
$WSUS_Report = GUICreate($Title, $GuiWidth, $GuiHeight, $GuiLeft, $GuiTop )

; SUS Server
GUICtrlCreateLabel("Update Server: " & $WSUS_Svr, 16, 8, 380, 20 )
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

; Total Updates Label
GUICtrlCreateLabel("    Total Updates: " & $NumOfUpdates, 640,  8, 190, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

; Missing Updates Label
GUICtrlCreateLabel("Missing Updates: " & $NumMISSING,   640, 28, 190, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
If $NumMISSING Then
	GUICtrlSetColor(-1, 0xFF0000)
Else
	GUICtrlSetColor(-1, 0x008000)
EndIf

$InstallButton = GUICtrlCreateButton("&Install Selected Missing Updates", 8, 424, 273, 33, _
					BitOR ($BS_DEFPUSHBUTTON, $BS_CENTER, $BS_VCENTER) )
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

$ExitButton = GUICtrlCreateButton("&Exit", 648, 424, 137, 33, _
					BitOR($BS_DEFPUSHBUTTON,$BS_CENTER,$BS_VCENTER) )
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

; Tab "Sheet"
$TabLeft = 5
$TabTop = 40
$TabWidth = $GuiWidth-10	; 790
$TabHeight = $GuiHeight-100	; 370
$Tab1 = GUICtrlCreateTab($TabLeft, $TabTop, $TabWidth, $TabHeight )

; Tab1 - Missing Updates list
$MissingSheet = GUICtrlCreateTabItem("Missing Updates")
$MissingList = GUICtrlCreateListView("UpdateID|BulletinID|KBID|Type|Severity|Title", _
	$TabLeft+5, $TabTop+25, $TabWidth-10, $TabHeight-30, _
	$LVS_REPORT + $LVS_SINGLESEL + $LVS_NOSORTHEADER, _
	$LVS_EX_FULLROWSELECT + $LVS_EX_GRIDLINES + $LVS_EX_CHECKBOXES )

; Tab2 - Installed Updates list
$InstalledSheet = GUICtrlCreateTabItem("Installed Updates")
$InstalledList = GUICtrlCreateListView("UpdateID|BulletinID|KBID|Type|Severity|Title", _
	$TabLeft+5, $TabTop+25, $TabWidth-10, $TabHeight-30, _
	$LVS_REPORT + $LVS_SINGLESEL + $LVS_NOSORTHEADER, _
	$LVS_EX_FULLROWSELECT + $LVS_EX_GRIDLINES + $LVS_EX_CHECKBOXES )

;Tab3 - Advice
$AdviceSheet = GUICtrlCreateTabItem( "Advice" )
$AdviceEdit = GUICtrlCreateEdit( @CRLF & $Advice, $TabLeft+5, $TabTop+25, $TabWidth-10, $TabHeight-30, $ES_MULTILINE + $ES_READONLY )
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

;$TabSheet2 = GUICtrlCreateTabItem("Notes")
$NotesSheet = GUICtrlCreateTabItem ( "Notes" )
$Notes = "Technician's Notes: " & @CRLF & @CRLF
$Notes = $Notes & '---------------------------------------------------------------------' & @CRLF
$Notes = $Notes & 'WSUS Check - ' & @MON & '/' & @MDAY & '/' & @YEAR & ' - ' & @HOUR & ':' & @MIN & @CRLF
$Notes = $Notes & '===============================' & @CRLF
$Notes = $Notes & 'Computer: ' & @ComputerName & @CRLF
$Notes = $Notes & '  UserID: ' & @UserName & @CRLF & @CRLF
If $NumMISSING <> 0 Then
	$Notes = $Notes & 'Missing Hotfixes:' & @CRLF
	$Notes = $Notes & 'Update ID   Bulletin ID   KBID     Type   Severity   Title' & @CRLF
	$Notes = $Notes & '=========   ===========   ======   ====   ========   ====================================================================================' & @CRLF
	For $i = 1 to $NumOfUpdates
		If $Updates[$i][6] <> 'true' Then
			$Notes = $Notes & StringFormat ( '%-9s   %-11s   %-6s   %-4s   %-8s   %-s', _
							$Updates[$i][1], $Updates[$i][3], $Updates[$i][4], _
							$Updates[$i][5], $Updates[$i][7], $Updates[$i][9] ) & @CRLF
		EndIf
	Next
EndIf
$Notes = $Notes & @CRLF & @CRLF & 'Installed Hotfixes:' & @CRLF
$Notes = $Notes & 'Update ID   Bulletin ID   KBID     Type   Severity   Title' & @CRLF
$Notes = $Notes & '=========   ===========   ======   ====   ========   ====================================================================================' & @CRLF
For $i = 1 to $NumOfUpdates
	If $Updates[$i][6] = 'true' Then
		$Notes = $Notes & StringFormat ( '%-9s   %-11s   %-6s   %-4s   %-8s   %-s', _
						$Updates[$i][1], $Updates[$i][3], $Updates[$i][4], _
						$Updates[$i][5], $Updates[$i][7], $Updates[$i][9] ) & @CRLF
	EndIf
Next
$NotesControl = GUICtrlCreateEdit ( $Notes, $TabLeft+5, $TabTop+25, $TabWidth-10, $TabHeight-30 )
GUICtrlSetFont(-1, 10, 800, 0, "Courier New")
GUICtrlCreateTabItem ( '' )		; This is needed to tell the GUI that we've reached the end of the tab items!

For $i = 1 To $NumOfUpdates
	$ListIndex[0][0] = $ListIndex[0][0] +1
	$ListIndex[$i][0] = $ListItems[$i]		; The Item's List controlID
	$ListIndex[$i][3] = $i
	$ListIndex[$i][4] = $Updates[$i][4]		; KBID
	$ListIndex[$i][5] = $Updates[$i][9]		; Description
	$ListIndex[$i][6] = $Updates[$i][13]	; Download File Name
	$ListIndex[$i][7] = $Updates[$i][12]	; Download URL
	$sListText = $Updates[$i][1] & '|' & $Updates[$i][3] & '|' & $Updates[$i][4] & '|'  & _
				 $Updates[$i][5] & '|' & $Updates[$i][7] & '|' & $Updates[$i][9]
	If $Updates[$i][6] = 'true' Then
		$ListItems[$i] = GUICtrlCreateListViewItem ( $sListText, $InstalledList )
		$ListIndex[$i][1] = $InstalledList		; The List's Control ID
		$ListIndex[$i][2] = $ListIndex[0][1]	; The Item's zero based offset in the list
		$ListIndex[0][1] = $ListIndex[0][1] +1	; It's incremented AFTER we use it
		_GUICtrlListViewSetCheckState ( $ListIndex[$i][1], $ListIndex[$i][2], 0 )
		GUICtrlSetState ( $ListItems[$i], $GUI_UNCHECKED )
		$ContextMenu[$i] = GUICtrlCreateContextMenu ( $ListItems[$i] )
		$BulletinContext[$i] = GUICtrlCreateMenuitem ( 'Open Bulletin URL: ' & $Updates[$i][10], $ContextMenu[$i], 0 )
		If $Updates[$i][10] = 'N/A' Then GUICtrlSetState ( $BulletinContext[$i], $GUI_DISABLE )
		$KbContext[$i] = GUICtrlCreateMenuitem ( 'Open KB URL: http://support.microsoft.com/kb/' & $Updates[$i][4], $ContextMenu[$i], 1 )
	Else
		$ListItems[$i] = GUICtrlCreateListViewItem ( $sListText, $MissingList )
		$ListIndex[$i][1] = $MissingList
		$ListIndex[$i][2] = $ListIndex[0][2]	; This is a zero based index so...
		$ListIndex[0][2] = $ListIndex[0][2] +1
		_GUICtrlListViewSetCheckState ( $ListIndex[$i][1], $ListIndex[$i][2], 1 )
		$ContextMenu[$i] = GUICtrlCreateContextMenu ( $ListItems[$i] )
		$BulletinContext[$i] = GUICtrlCreateMenuitem ( 'Open Bulletin URL: ' & $Updates[$i][10], $ContextMenu[$i], 0 )
		If $Updates[$i][10] = 'N/A' Then GUICtrlSetState ( $BulletinContext[$i], $GUI_DISABLE )
		$KbContext[$i] = GUICtrlCreateMenuitem ( 'Open KB URL: http://support.microsoft.com/kb/' & $Updates[$i][4], $ContextMenu[$i], 1 )
	EndIf
Next

_GUICtrlListViewSetColumnWidth ( $InstalledList, 0, $LVSCW_AUTOSIZE )
_GUICtrlListViewSetColumnWidth ( $InstalledList, 5, $LVSCW_AUTOSIZE )

If $NumMISSING Then
	_GUICtrlListViewSetColumnWidth ( $MissingList, 0, $LVSCW_AUTOSIZE )
	_GUICtrlListViewSetColumnWidth ( $MissingList, 5, $LVSCW_AUTOSIZE )
EndIf
#endregion GUI Define

#region GUI Display and Process Input
GUISetState ( @SW_SHOW, $WSUS_Report )
If $NumMISSING = 0 Then
	Sleep ( 500 )
	GUICtrlSetState ( $InstalledSheet, $GUI_SHOW )
EndIf
While 1
	$msg = GuiGetMsg()
	For $i = 1 To $NumOfUpdates
		If $msg = $BulletinContext[$i] Then
			Run ( $Browser & $Updates[$i][10] )
		ElseIf $msg = $KbContext[$i] Then
			Run ( $Browser & 'http://support.microsoft.com/kb/' & $Updates[$i][4] )
		ElseIf $msg = $GUI_EVENT_CLOSE Then
			Exit
		EndIf
		If $msg = $ListIndex[$i][0] AND $ListIndex[$i][1] = $InstalledList Then
			_GUICtrlListViewSetCheckState ( $ListIndex[$i][1], $ListIndex[$i][2], 0 )
		EndIf
	Next
	Select
		Case $msg = $GUI_EVENT_CLOSE OR $msg = $ExitButton
			ExitLoop
		Case $msg = $InstallButton
			$MBMsg = 'You have chosen to install the following updates:' & @CRLF & @CRLF
			$SelectedCount = 0
			For $i = 1 to $NumOfUpdates
				If $ListIndex[$i][1] = $MissingList AND _GUICtrlListViewGetCheckedState ( $ListIndex[$i][1], $ListIndex[$i][2] ) Then
					$MBMsg = $MBMsg & @TAB & 'KB ' & $ListIndex[$i][4] & ' - ' & $ListIndex[$i][5] & @CRLF
					$SelectedCount = $SelectedCount + 1
				EndIf
			Next
			$MBMsg = $MBMsg & @CRLF & $SelectedCount & ' update(s) selected.' & @CRLF & 'Cick [YES] to continue, [NO] to change your selections, or [Cancel] to quit.'
			$iMsgBoxAnswer = MsgBox ( $MB_YESNOCANCEL + $MB_ICONASTERISK + $MB_SYSTEMMODAL, $Title, $MBMsg )
			Select
				Case $iMsgBoxAnswer = $IDYES
					MsgBox ( 0, $Title, GUICtrlRead ( $NotesControl ) )
					ExitLoop
				Case $iMsgBoxAnswer = $IDNO
				Case $iMsgBoxAnswer = $IDCANCEL
					ExitLoop
			EndSelect
	EndSelect
WEnd
#endregion GUI Display and Process Input
