; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
;AutoItSetOption("WinTitleMatchMode", 4)


; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------
#Include <File.au3>
#include <GUIConstants.au3>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                          Initialize global variables
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global $sChoice
Global $iIndex2, $iState, $iChoices
Global $gSelector, $gOk, $gCancel
Dim $aDrives
Dim $agItem[7]
Dim $aChoices[7]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       Script specific functions
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If (@OSVersion = "WIN_XP") Then
   $iGSpace = 25
Else
   $iGSpace = 5
EndIf

; ----------------------------------------------------------------------------
;												MAIN
; ----------------------------------------------------------------------------

If ($sChoice = "") Then
	$aChoices[0] = "Choice01"
	$aChoices[1] = "Choice02"
	$aChoices[2] = "Choice03"
	$aChoices[3] = "Choice04"
	$aChoices[4] = "Choice05"
	$aChoices[5] = "Choice06"
	$aChoices[6] = "Choice07"

	GUICreate("Selector", 180, 180, (@DesktopWidth - 180) / 2, (@DesktopHeight - 180) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$gSelector = GUICtrlCreateTreeView(25, 10, 130, 7*16, $TVS_CHECKBOXES)
	Global $iIndex2
	For $iIndex2 = 0 To 6
	   $agItem[$iIndex2] = GUICtrlCreateTreeViewItem($aChoices[$iIndex2], $gSelector)
	Next
	GuiSetState(@SW_SHOW, $gSelector)
	;$gLabel = GUICtrlCreateLabel ( "Choices=", 20, 130, 130)
	$gOk = GUICtrlCreateButton ("OK", 20, 180-30, 60)    ; add the button that will close the GUI
	GUICtrlSetResizing ($gOk,$GUI_DOCKBOTTOM+$GUI_DOCKSIZE+$GUI_DOCKVCENTER)
	GUICtrlSetState($gOk, $GUI_DISABLE)
	$gCancel = GUICtrlCreateButton ("Annuler", 100,  180-30, 60)   ; add the button that will close the GUI
	GUICtrlSetResizing ($gCancel,$GUI_DOCKBOTTOM+$GUI_DOCKSIZE+$GUI_DOCKVCENTER)
	GUICtrlSetState($gCancel, $GUI_DEFBUTTON)
	GUISetState()
	$iState = 0
	$iChoices = 0
	While 1
	   $iMsg = GUIGetMsg()
		Select
			Case ($iMsg = $gCancel) Or ($iMsg = $GUI_EVENT_CLOSE)
		      $sDomainName = ""
		      $iChoices = -1
		      ExitLoop

		   Case $iMsg = $gOk
		      GUISetState(@SW_HIDE, $gSelector)
		      If ($iChoices > 1) Then
			   	$iConfirm = MsgBox(36, "Confirmation", "Do you confirm your " & $iChoices & " choices?")
			   Else
			      $iConfirm = MsgBox(36, "Confirmation", "Do you confirm your choice?")
			   EndIf
		      If $iConfirm = 6 Then ExitLoop
		      GUISetState(@SW_SHOW, $gSelector)
	
			Case Else
				For $iIndex2 = 0 To 6
					If ($iMsg = $agItem[$iIndex2]) Then
						$iChoices = 0
						$iState = 0
						For $iIndex3 = 0 To 6
							If (BitAND(GuiCtrlRead($agItem[$iIndex3]), $GUI_CHECKED)) Then
								$iState = $iState + 2^$iIndex3
								$iChoices = $iChoices + 1
							EndIf
						Next
						ExitLoop
					EndIf
				Next
		EndSelect
		If ($iState = 0) Then
			If (BitAND(GUICtrlGetState($gOk), $GUI_ENABLE)) Then GUICtrlSetState($gOk, $GUI_DISABLE)
		Else
			If (BitAND(GUICtrlGetState($gOk), $GUI_DISABLE)) Then GUICtrlSetState($gOk, $GUI_ENABLE)
		EndIf
;		GUICtrlSetData ( $gLabel, "Choices=[" & $iChoices & "] State=" & $iState)
	WEnd
EndIf

If ($iChoices < 0) Then
	MsgBox(0, "DEBUG", "Choices < 0!" & @CRLF & "Must have CANCEL / CLOSED...")
ElseIf ($iChoices = 0) Then
	MsgBox(0, "DEBUG", "No selection!" & @CRLF & "How can that be?")
Else
	For $iIndex2 = 0 To 6
		If (BitAND($iState, 2^$iIndex2)) Then
				MsgBox(0, "DEBUG", "Selected: " & $aChoices[$iIndex2])
		EndIf
	Next
EndIf

Exit