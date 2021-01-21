#NoTrayIcon
#include <GUIConstants.au3>
#include <GUIListView.au3>
Dim $_APP_VERSION = "0.1 build 051014"
Dim $_APP_TITLE = "AutoIt3 RegExp Tester"

;Generated with Form Designer preview
$MainForm = GUICreate($_APP_TITLE, 292, 309, -1, -1)
GUICtrlCreateLabel("&String to check:", 8, 8, 272, 12)
$MainForm_String = GUICtrlCreateInput("", 8, 24, 273, 21)
GUICtrlCreateLabel("Regular &Expression:", 8, 56, 274, 12)
$MainForm_RegExp = GUICtrlCreateInput("", 8, 72, 273, 21)
$MainForm_Info = GUICtrlCreateButton("&i", 8, 104, 25, 25)
GUICtrlSetStyle(-1, 0)
$MainForm_Reset = GUICtrlCreateButton("&Reset", 127, 104, 73, 25)
GUICtrlSetStyle(-1, 0)
$MainForm_Check = GUICtrlCreateButton("&Check", 208, 104, 73, 25, $BS_DEFPUSHBUTTON)
;~ GUICtrlCreateLabel("Flag:", 8, 108, 46, 12)
;~ $MainForm_Flag1 = GUICtrlCreateRadio("1", 56, 108, 41, 17)
;~ GUICtrlSetState(-1, $GUI_CHECKED)
;~ $MainForm_Flag3 = GUICtrlCreateRadio("3", 112, 108, 41, 17)
$MainForm_StatusText = GUICtrlCreateLabel("Waiting for message...", 8, 136, 268, 12)
$MainForm_ResultList = GUICtrlCreateListView("No.|Matched Group Value", 8, 152, 273, 145, $LVS_SINGLESEL, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT))
;~ _GUICtrlListViewJustifyColumn(-1, 0, 2)
_GUICtrlListViewSetColumnWidth(-1, 0, 33)
_GUICtrlListViewSetColumnWidth(-1, 1, 215)
GUISetState()

Dim $MatchedResult, $MatchedAmount, $String, $RegExp, $CheckType, $AboutDialog = 0, $About_ButtonOK
Dim $StatusDefault = GUICtrlRead($MainForm_StatusText)
While 1
	$msg = GuiGetMsg(1)
	Select
	Case $msg[1] = $MainForm
		Select
			
		Case $msg[0] = $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $msg[0] = $MainForm_String
			_WriteStatus($StatusDefault, 0)
			
		Case $msg[0] = $MainForm_RegExp
			_WriteStatus($StatusDefault, 0)
			
		Case $msg[0] = $MainForm_Info
	;~ 		#Region --- CodeWizard generated code Start ---
	;~ 		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	;~ 		MsgBox(64,"About", "Appliction Version: " & $_APP_VERSION & @CRLF & "AutoIt Version: " & @AutoItVersion)
	;~ 		#EndRegion --- CodeWizard generated code End ---
				;Generated with Form Designer preview
				$AboutDialog = GUICreate("About " & $_APP_TITLE, 225, 100, -1, -1, BitOR($WS_POPUP, $WS_CAPTION), -1, $MainForm)
				GUICtrlCreateIcon(@SystemDir & "\user32.dll", 4, 14, 14, 32, 32)
				GUICtrlCreateLabel("Version: " & $_APP_VERSION & @CRLF & @CRLF & "AutoIt build: " & @AutoItVersion, 62, 14, 156, 39)
				$About_ButtonOK = GUICtrlCreateButton("OK", 72, 64, 81, 25, $BS_DEFPUSHBUTTON)
				GUISetState()
				GUISetState(@SW_DISABLE, $MainForm)
				
		Case $msg[0] = $MainForm_Reset
			GUICtrlSetData($MainForm_String, "")
			GUICtrlSetData($MainForm_RegExp, "")
			GUICtrlSetState($MainForm_String, $GUI_FOCUS)
			_WriteStatus($StatusDefault, 0)
			
		Case $msg[0] = $MainForm_Check
			_GUICtrlListViewDeleteAllItems($MainForm_ResultList)
			$String = GUICtrlRead($MainForm_String)
			$RegExp = GUICtrlRead($MainForm_RegExp)
			Select
			Case $String = ""
				_WriteStatus("String empty.", 1)
				GUICtrlSetState($MainForm_String, $GUI_FOCUS)
					
			Case $RegExp = ""
				_WriteStatus("Regular expression empty.", 1)
				GUICtrlSetState($MainForm_RegExp, $GUI_FOCUS)
				
			Case Else
	;~ 			Select
	;~ 			Case BitAND(GUICtrlRead($MainForm_Flag1), $GUI_CHECKED) = $GUI_CHECKED
	;~ 				$CheckType = 1
	;~ 			
	;~ 			Case BitAND(GUICtrlRead($MainForm_Flag3), $GUI_CHECKED) = $GUI_CHECKED
	;~ 				$CheckType = 3
	;~ 			
	;~ 			EndSelect
				$CheckType = 3
				$MatchedResult = StringRegExp($String, $RegExp, $CheckType)
				Select
	
				Case @error = 2
					_WriteStatus("Regular expression invalid.", 1)
					GUICtrlSetState($MainForm_RegExp, $GUI_FOCUS)
					
				Case @extended = 0
					_WriteStatus("Match not found.", 0)
					
				Case @extended = 1
					If $MatchedResult = "" Then
						_WriteStatus("Match found. (No groups in regular exp.)", 2)
						
					Else
						$MatchedAmount = UBound($MatchedResult)
						_WriteStatus("Match found: " & $MatchedAmount, 2)
						For $i = 0 To $MatchedAmount - 1
							GUICtrlCreateListViewItem(($i + 1) & "|" & $MatchedResult[$i], $MainForm_ResultList)
						Next
						
					EndIf
					
				EndSelect
			
			EndSelect
		
		EndSelect

	Case $AboutDialog <> 0 And $msg[1] = $AboutDialog

		Select
			
		Case $msg[0] = $About_ButtonOK
			GUISetState(@SW_ENABLE, $MainForm)
			GUIDelete($AboutDialog)
		
		Case Else 
			
		EndSelect
	
	EndSelect
WEnd
Exit

Func _WriteStatus($vMessage = "", $vColorType = 0)
	Dim $tCtrl = $MainForm_StatusText
	GUICtrlSetData($tCtrl, $vMessage)
	Select
	
	Case $vColorType = 0
		GUICtrlSetColor($MainForm_StatusText, -1) ; Restore to default
	
	Case $vColorType = 1
		GUICtrlSetColor($MainForm_StatusText, 0xff0000)
		
	Case $vColorType = 2
		GUICtrlSetColor($MainForm_StatusText, 0x0000ff)
		
	Case Else
		; Color no change
		
	EndSelect
EndFunc