; ----------------------------------------------------------------------------
;
; Script:			Tristate TreeView
; Version:			0.3
; AutoIt Version:	3.2.0.X
; Author:			Holger Kotsch
;
; Script Function:
;	Demonstrates a tristate treeview control -> just more like a fifthstate treeview ;)
;
;	5 item checkbox! states are usable:
;	(can only used with TreeView with TVS_CHECKBOXES-style)
;		- $GUI_CHECKED
;		- $GUI_UNCHECKED
;		- $GUI_INDETERMINATE
;		- $GUI_DISABLE + $GUI_CHECKED
;		- $GUI_DISABLE + $GUI_UNCHECKED
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <array.au3>
#include <File.au3>
#include <GuiTreeView.au3>
#include "TristateTreeViewLib.au3"   ; MAKE SURE THIS IS LAST

; You could also use a integrated bmw (with ResourceHacker)
; Please see TristateTreeViewLib.au3 in line 257 (LoadStateImage)
; !!! You must not compiled it full with UPX, just use after compiling: upx.exe --best --compress-resources=0 xyz.exe !!!
; If you choose another reource number then 170 you have to change the LoadStateImage() function
;
; Userfunction My-WM_Notify() is registered in TristateTreeViewLib.au3 !
;
; You can get other check bitmaps also together with freeware install programs like i.e. NSIS
; it must have 5 image states in it:
; 1.empty, 2.unchecked, 3.checked, 4.disabled and unchecked, 5.disabled and checked

;Global $sStateIconFile = @ScriptDir & "\simple.bmp"
Global $sStateIconFile = @ScriptDir & "\modern.bmp"
Global $hImageList
GUICreate("Tristate Treeview", 600, 600)

GUICtrlCreateLabel("Source Directory:", 10, 15, 120, 20)
$nCombo	= GUICtrlCreateLabel("", 150, 10, 200, 20, $SS_SUNKEN)
$nTV	= GUICtrlCreateTreeView(50, 50, 500, 500, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_CHECKBOXES), $WS_EX_CLIENTEDGE)
;$nBtn	= GUICtrlCreateButton("Test", 10, 200, 70, 20)


; Get a list of all Movies in the Source Directory
Local $aFolderList[9][2][2]

; Manually Populate the Array for testing
$aFolderList[0][0][0] = 8
$aFolderList[1][0][0] = "Movie1Dir"
$aFolderList[1][1][0] = "Movie1"
$aFolderList[2][0][0] = "Movie1Dir"
$aFolderList[2][1][0] = "Movie2"
$aFolderList[3][0][0] = "SingleMovie1Dir"
$aFolderList[3][1][0] = "Movie1"
$aFolderList[4][0][0] = "SingleMovie2Dir"
$aFolderList[4][1][0] = "Movie1"
$aFolderList[5][0][0] = "EpisodesMovie1Dir\Episode1"
$aFolderList[5][1][0] = "Movie1"
$aFolderList[6][0][0] = "Movie2Dir"
$aFolderList[6][1][0] = "Movie1"
$aFolderList[7][0][0] = "Movie1Dir"
$aFolderList[7][1][0] = "Movie3"
$aFolderList[8][0][0] = "SingleMovie3Dir"
$aFolderList[8][1][0] = "Movie1"




$nTop	= GUICtrlCreateTreeViewItem("All Movies", $nTV)
For $i = 1 To $aFolderList[0][0][0]

	; Create Parents if necessary
	$aArray = StringSplit($aFolderList[$i][0][0], "\")
	For $j = 1 to $aArray[0]
		$hParent = _GUICtrlTreeView_FindItem($nTV, $aArray[$j])
		If $hParent = 0 Then
			If $j > 1 Then
				$hParent = _GUICtrlTreeView_FindItem($nTV, $aArray[$j - 1])
				_GUICtrlTreeView_AddChild($nTV, $hParent, $aArray[$j])
			Else
				GUICtrlCreateTreeViewItem($aArray[$j], $nTop)
			EndIf
		Else
			_GUICtrlTreeView_AddChild($nTV, $hParent, $aArray[$j])
		EndIf
	Next

	; Create Movies under Parent
	If $aFolderList[$i][0][0] = "" Then
		_GUICtrlTreeView_AddChild($nTV, $nTop,$aFolderList[$i][1][0])
	Else
		$hParent = _GUICtrlTreeView_FindItem($nTV, $aArray[$aArray[0]])
		_GUICtrlTreeView_AddChild($nTV, $hParent,$aFolderList[$i][1][0])
	EndIf
Next

LoadStateImage($nTV, $sStateIconFile)
GUISetState()

; Select All Items if top level isn't checked
GUICtrlSetState($nTop, $GUI_EXPAND)
If MyCtrlGetItemState($nTV, $nTop) = 4 Then
	MyCtrlSetItemState($nTV, $nTop, $GUI_CHECKED)
EndIf

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
;~ 		Case $nBtn
;~ 			; Find out what items are checked.  We will loop through the Folder list array and then
;~ 			; search for the movie in the Treeview.  Once found, we need to make sure the item is not
;~ 			; a parent.

;~ 			For $i = 1 To $aFolderList[0][0][0]
;~ 				$iRet = _GUICtrlTreeView_FindItem($nTV, $aFolderList[$i][1][0])
;~ 				If $iRet > 0 Then
;~ 					; Check to see if it is a parent.  This would happen if a movie name is the same name as the parent
;~ 					If _GUICtrlTreeView_GetChildCount($nTV, $iRet) > -1 Then
;~ 						$iRet = _GUICtrlTreeView_GetFirstChild($nTV, $iRet)
;~ 						;$iRet = _GUICtrlTreeView_FindItem($nTV, $aFolderList[$i][1][0], -1, $iRet + 1)
;~ 					EndIf
;~ 					If _GUICtrlTreeView_GetChecked($nTV, $iRet) Then
;~ 						$aFolderList[$i][1][1] = 1
;~ 					Else
;~ 						$aFolderList[$i][1][1] = 0
;~ 					EndIf
;~ 				Else
;~ 					; ERROR
;~ 					MsgBox(0,"ERROR", "Movie not found in TreeView")
;~ 				EndIf
;~ 				; Check to see if item is a parent. If it is, Ignore
;~ 			Next


;~ 			For $i = 1 to $aFolderList[0][0][0]
;~ 				ConsoleWrite($aFolderList[$i][0][0] & "    " & $aFolderList[$i][1][0] & "    " & $aFolderList[$i][1][1] & @CRLF)
;~ 			Next
	EndSwitch
WEnd

GUIDelete()

Exit






