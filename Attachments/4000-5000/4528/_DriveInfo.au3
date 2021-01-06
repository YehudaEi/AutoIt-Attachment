#cs
	Author: 		BusySignal
	AutoIt Ver: 	3.1.1.80(beta)
	Language: 		English
	Platform: 		Windows
	Script Name:	_DriveInfo()
	Script Ver:		0.0.5
	Script Function:
		Test _DriveInfo($ListView) function. Display "ALL" drives on system.
#ce

#include <GUIConstants.au3>
#include <GUIListView.au3>

GUICreate("Drive Info - by Busysignal", 450, 225, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
$btnExit = GUICtrlCreateButton("E&xit", 340, 170, 80)

; Set window size and functionality
$List_View = GUICtrlCreateListView("Drive|Label|Type|Total Space|Free Space|Status           ", 10, 10, 430, 150, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP, $LVS_EX_FLATSB))
_DriveInfo($List_View)

GUISetState()
Do
	$msg = GUIGetMsg()
	If $msg = $btnExit Then Exit
Until $msg = $GUI_EVENT_CLOSE
	
Exit

; ******************************************************************************

;===============================================================================
;
; Function Name:	_DriveInfo()
; AutoItVer:		3.1.1.80
; Description:		Reads all drive info into a list view for display
; Required Lib:		<GUIConstants.au3>
;					<GUIListView.au3>
; Author(s):		Rewritten by Busysignal
;					For the original version, thanks to:
;						"Drive Scan" - by Rakudave, Pangaea WorX
; AutoItForum:		http://www.autoitscript.com/forum/index.php?showtopic=16479
;						"Drive Info" - Rewritten by LazyCoder
;										For the original version, thanks to:
;										Brian Keene <brian_keene@yahoo.com> & Jos van der Zande
; AutoItForum:		??
;===============================================================================

Func _DriveInfo(ByRef $List_View)
	Local $Drives = DriveGetDrive( "all")
	Local $SpaceTotal, $FreeSpace
	
	#Region --- CFCCodeWizard generated code Start --- ; Add a little color
		If Not IsDeclared('Cadet_Blue') Then Dim $Cadet_Blue = 0x5f9ea0
		GUISetBkColor($Cadet_Blue)
	#EndRegion --- CFCCodeWizard generated code End ---

	_GUICtrlListViewDeleteAllItems ($List_View) ; Clear List View
	If @error = 1 Then Exit ; <== Expand on this later for DriveGetError
	For $i = 1 To $Drives[0]
		If (DriveGetType($Drives[$i]) == "Unknown") Then
			;
			GUICtrlCreateListViewItem(StringUpper($Drives[$i]) & "|" & DriveGetLabel($Drives[$i]) & "|" & DriveGetType($Drives[$i]), $List_View)
		ElseIf (DriveGetType($Drives[$i]) == "Network") Then
			$SpaceTotal = DriveSpaceTotal($Drives[$i]) ; Calcualte TotalSpace
			If ($SpaceTotal > 1024) Then
				$SpaceTotal = Round($SpaceTotal / 1024, 0) & " GB"
			Else
				$SpaceTotal = Round($SpaceTotal, 0) & " MB"
			EndIf
			$FreeSpace = DriveSpaceFree($Drives[$i]) ; Calculate FreeSpace
			If ($FreeSpace > 1024) Then
				$FreeSpace = Round($FreeSpace / 1024, 0) & " GB"
			Else
				$FreeSpace = Round($FreeSpace, 0) & " MB"
			EndIf
			;
			GUICtrlCreateListViewItem(StringUpper($Drives[$i]) & "|" & DriveGetLabel($Drives[$i]) & "|" & DriveGetType($Drives[$i]) & "|" & $SpaceTotal & "|" & $FreeSpace & "|" & DriveStatus($Drives[$i]), $List_View)
		Else
			$SpaceTotal = DriveSpaceTotal($Drives[$i]) ; Calcualte TotalSpace
			If ($SpaceTotal = 1 And @error) Then
				$SpaceTotal = ""
			ElseIf ($SpaceTotal > 1024) Then
				$SpaceTotal = Round($SpaceTotal / 1024, 0) & " GB"
			Elseif ($SpaceTotal > 0) Then
				$SpaceTotal = Round($SpaceTotal, 0) & " MB"
			EndIf
			$FreeSpace = DriveSpaceFree($Drives[$i]) ; Calculate FreeSpace
			If ($FreeSpace = 1 And @error) Then
				$FreeSpace = ""
			ElseIf ($FreeSpace > 1024) Then
				$FreeSpace = Round($FreeSpace / 1024, 0) & " GB"
			ElseIf ($FreeSpace > 0) Then
				$FreeSpace = Round($FreeSpace, 0) & " MB"
			EndIf
			;
			GUICtrlCreateListViewItem(StringUpper($Drives[$i]) & "|" & DriveGetLabel($Drives[$i]) & "|" & DriveGetType($Drives[$i]) & "|" & $SpaceTotal & "|" & $FreeSpace & "|" & DriveStatus($Drives[$i]), $List_View)
		EndIf
	Next
	
	;_GUICtrlListViewSetColumnWidth($List_View, 0, 50)
	;_GUICtrlListViewSetColumnWidth($List_View, 1, 75)
	;_GUICtrlListViewSetColumnWidth($List_View, 2, 75)
	;_GUICtrlListViewSetColumnWidth($List_View, 3, 75)
	;_GUICtrlListViewSetColumnWidth($List_View, 4, 300)
	
EndFunc   ;==>_DriveInfo