#include-once
#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <GuiStatusBar.au3>

;===============================================================================
;
; Description:			_GuiCtrlEditFind
; Parameter(s):		$h_gui = gui id
;							$h_edit - controlID
;							$b_replace - show replace option (optional: default is False)
; Requirement:			$ES_NOHIDESEL style should be used with edit control
; Return Value(s):	None
; User CallTip:		_GuiCtrlEditFind(ByRef $h_gui, ByRef $h_edit[, $b_replace = False]) Search Edit control for text edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				
;
;===============================================================================
Func _GuiCtrlEditFind(ByRef $h_gui, ByRef $h_edit, $b_replace = False ,$s_WinTitle = "", $s_WinText = "")
   Local $gui_Search, $Input_Search, $Input_Replace, $lbl_replace, $msg_find, $Replace
   Local $s_find = "", $s_replace = "", $pos = 0, $case, $whole, $occurance = 0, $Replacements = 0
   Local $chk_wholeonly, $chk_matchcase, $btn_FindNext, $btn_replace, $btn_close, $StatusBar1
	Local $s_text, $a_sel
	If $s_WinTitle <> "" Then
		$s_text = ControlGetText($s_WinTitle,$s_WinText,$h_edit)
		$a_sel = _GUICtrlEditGetSel ($h_edit)
	Else
		$s_text = GUICtrlRead($h_edit)
		$a_sel = _GUICtrlEditGetSel ($h_edit)
	EndIf
   
   $gui_Search = GUICreate("Find", 349, 200, -1, -1, BitOR($WS_CHILD, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU), -1, $h_gui)
   GUISetIcon(@SystemDir & "\shell32.dll", 22, $gui_Search)
   GUICtrlCreateLabel("Find what:", 9, 10, 53, 16, $SS_CENTER)
   $Input_Search = GUICtrlCreateInput("", 80, 8, 257, 21)
   If ($a_sel == $EC_ERR) Then
      ; do nothing
   ElseIf (IsArray($a_sel)) Then
      GUICtrlSetData($Input_Search, StringMid($s_text, $a_sel[1] + 1, $a_sel[2] - $a_sel[1]))
		If $a_sel[1] <> $a_sel[2] Then $pos = $a_sel[1]
   EndIf
   $lbl_replace = GUICtrlCreateLabel("Replace with:", 9, 42, 69, 17, $SS_CENTER)
   $Input_Replace = GUICtrlCreateInput("", 80, 40, 257, 21)
   $chk_wholeonly = GUICtrlCreateCheckbox("Match whole word only", 9, 72, 145, 17)
   $chk_matchcase = GUICtrlCreateCheckbox("Match case", 9, 96, 145, 17)
   $btn_FindNext = GUICtrlCreateButton("Find Next", 168, 72, 161, 21, 0)
   $btn_replace = GUICtrlCreateButton("Replace", 168, 96, 161, 21, 0)
   $btn_close = GUICtrlCreateButton("Close", 104, 136, 161, 21, 0)
	$StatusBar1 = _GuiCtrlStatusBarCreate ($gui_Search, -1, "")
	_GuiCtrlStatusBarSetSimple($StatusBar1)
	
   If $b_replace = False Then
      GUICtrlSetState($lbl_replace, $GUI_HIDE)
      GUICtrlSetState($Input_Replace, $GUI_HIDE)
      GUICtrlSetState($btn_replace, $GUI_HIDE)
  Else
	  
		_GuiCtrlStatusBarSetText ($StatusBar1, "Replacements: " & $Replacements, 255)
   EndIf
   GUISetState(@SW_SHOW)
   
   While 1
      $msg_find = GUIGetMsg()
      Select
         Case $msg_find = $GUI_EVENT_CLOSE Or $msg_find = $btn_close
            ExitLoop
         Case $msg_find = $btn_FindNext
            _FindText($h_edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $s_WinTitle, $s_WinText)
			_GUICtrlEditScroll($h_edit, $SB_SCROLLCARET)
         Case $msg_find = $btn_replace
            If $pos Then
               _GUICtrlEditReplaceSel ($h_edit, True, GUICtrlRead($Input_Replace))
					$Replacements += 1
					_GuiCtrlStatusBarSetText ($StatusBar1, "Replacements: " & $Replacements, 255)
				EndIf
				_FindText($h_edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $s_WinTitle, $s_WinText)
				_GUICtrlEditScroll($h_edit, $SB_SCROLLCARET)
	Case Else
            ;;;;;;;
      EndSelect
   WEnd
   GUIDelete($gui_Search)
EndFunc   ;==>_GuiCtrlEditFind

;===============================================================================
;
; Description:			_FindText
; Parameter(s):		$h_edit - controlID
;							$Input_Search - controlID
;							$chk_matchcase - controlID
;							$chk_wholeonly - controlID
;							$pos - position of text found
;							$occurance - occurance to find
; Requirement:			_GuiCtrlEditFind function
; Return Value(s):	None
; User CallTip:		
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				
;
;===============================================================================
Func _FindText(ByRef $h_edit, ByRef $Input_Search, ByRef $chk_matchcase, ByRef $chk_wholeonly, ByRef $pos, ByRef $occurance, $s_WinTitle = "", $s_WinText = "")
   Local $case = 0, $whole = 0
   Local $s_text, $exact = False
   Local $s_find = GUICtrlRead($Input_Search)
	If $s_WinTitle <> "" Then
		$s_text = ControlGetText($s_WinTitle,$s_WinText,$h_edit)
		ConsoleWrite("Read: " & @LF & $s_text & @LF)
	Else
		$s_text = GUICtrlRead($h_edit)
	EndIf
   
   If BitAND(GUICtrlRead($chk_matchcase), $GUI_CHECKED) = $GUI_CHECKED Then $case = 1
   If BitAND(GUICtrlRead($chk_wholeonly), $GUI_CHECKED) = $GUI_CHECKED Then $whole = 1
   If $s_find <> "" Then
      $occurance += 1
      $pos = StringInStr($s_text, $s_find, $case, $occurance)
      If $whole And $pos Then
			Local $c_compare2 = StringMid($s_text, $pos + StringLen($s_find), 1)
			If $pos = 1 Then 
				If ($pos + StringLen($s_find)) - 1 = StringLen($s_text) Or _
					($c_compare2 = " " Or $c_compare2 = @LF Or $c_compare2 = @CR Or _
					$c_compare2 = @CRLF Or $c_compare2 = @TAB) Then
					$exact = True
				EndIf
			Else
				Local $c_compare1 = StringMid($s_text, $pos - 1, 1)
				If ($pos + StringLen($s_find)) - 1 = StringLen($s_text) Then 
					If ($c_compare1 = " " Or $c_compare1 = @LF Or $c_compare1 = @CR Or _
						$c_compare1 = @CRLF Or $c_compare1 = @TAB) Then 
						$exact = True
					EndIf
				Else
					If ($c_compare1 = " " Or $c_compare1 = @LF Or $c_compare1 = @CR Or _
						$c_compare1 = @CRLF Or $c_compare1 = @TAB) And _
						($c_compare2 = " " Or $c_compare2 = @LF Or $c_compare2 = @CR Or _
						$c_compare2 = @CRLF Or $c_compare2 = @TAB) Then
							$exact = True
					EndIf
				EndIf
         EndIf
         If $exact = False Then
            _FindText($h_edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $s_WinTitle, $s_WinText)
         Else
            _GUICtrlEditSetSel ($h_edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
         EndIf
      ElseIf Not $whole Then
         If Not $pos Then ; wrap around search and select
            $occurance = 1
            _GUICtrlEditSetSel ($h_edit, -1, 0)
            $pos = StringInStr($s_text, $s_find, $case, $occurance)
            If Not $pos Then
               $occurance = 1
					MsgBox(48,"Find","Can not find the string '" & $s_find & "'")
            Else
               _GUICtrlEditSetSel ($h_edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
            EndIf
         Else ; set selection
            _GUICtrlEditSetSel ($h_edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
         EndIf
      ElseIf $whole Then
         If Not $pos Then
            $occurance = 1
				MsgBox(48,"Find","Can not find the string '" & $s_find & "'")
			EndIf
      EndIf
   EndIf
EndFunc   ;==>_FindText
