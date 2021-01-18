#include-once
#include <GuiCtrlEdit.au3>
#include <File.au3>

;globals
;===============================================================================
Global $c_Id,$w_Title,$w_Text,$n_Title,$f_Open,$f_Text,$z_Save,$f_Save,$f_Ext,$f_Print,$t_File
;===============================================================================

; function list
;===============================================================================
; _TextEditCutText
; _TextEditCopyText
; _TextEditPasteText
; _TextEditSelectAll
; _TextEditOpenFile
; _TextEditNewFile
; _TextEditSaveFile
; _TextEditSaveFileAs
; _TextEditPrint
; _TextEditOnClose
;===============================================================================

;functions
;===============================================================================
;
; Description:		_TextEditCutText
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditReplaceSel in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Cuts selected text from edit box and puts it to the clipboard.
;					
;===============================================================================
Func _TextEditCutText($c_Id,$w_Title,$w_Text = "")
	ClipPut(ControlCommand($w_Title,$w_Text,$c_Id,"GetSelected",""))
	_GUICtrlEditReplaceSel($c_Id,"True","")
EndFunc
;===============================================================================
;
; Description:		_TextEditCopyText
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditReplaceSel in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Copies selected text from edit box and puts it to the clipboard.
;					
;===============================================================================
Func _TextEditCopyText($c_Id,$w_Title,$w_Text = "")
	ClipPut(ControlCommand($w_Title,$w_Title,$c_Id,"GetSelected",""))
EndFunc
;===============================================================================
;
; Description:		_TextEditPasteText
; Parameter(s):		$c_Id - Control ID of the Edit Control
; Requirement:		_GUICtrlEditReplaceSel in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Pastes selected text to edit box from the clipboard.
;					
;===============================================================================
Func _TextEditPasteText($c_Id)
	$clipboard = ClipGet()
	_GUICtrlEditReplaceSel($c_Id,"True",$clipboard)
EndFunc
;===============================================================================
;
; Description:		_TextEditSelectAll
; Parameter(s):		$c_Id - Control ID of the Edit Control
; Requirement:		_GUICtrlEditSetSel in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Selects all text in an edit box.
;					
;===============================================================================
Func _TextEditSelectAll($c_Id)
	_GUICtrlEditSetSel($c_Id, 0, -1)
EndFunc
;===============================================================================
;
; Description:		_TextEditOpenFile
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditEmptyUndoBuffer in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Opens a standard text file and displays its contents in an edit box and its path in the title bar.
;					
;===============================================================================
Func _TextEditOpenFile($c_Id,$w_Title,$w_Text = "")
	$z_Modify = _GUICtrlEditGetModify($edit)
	if $z_Modify <> 0 then
		$z_Save = MsgBox(3,"Info","Would you like to save the current document?")
		if $z_Save = 7 then
			$f_Open = FileOpenDialog("Open File", "","Text Files(*.txt)")
			if @error then
			else
				$n_Title = WinGetTitle($w_Title,$w_Text)
				WinSetTitle($n_Title,"",$w_Title & " - " & $f_Open & "")
				$f_Text = FileRead($f_Open)
				GUICtrlSetData($c_Id,$f_Text)
				_GUICtrlEditEmptyUndoBuffer($c_Id)
			endif
		elseif $z_Save = 6 then
			_TextEditSaveFile($c_Id,$w_Title,$w_Text)
			$f_Open = FileOpenDialog("Open File", "","Text Files(*.txt)")
			if @error then
			else
				$n_Title = WinGetTitle($w_Title,$w_Text)
				WinSetTitle($n_Title,"",$w_Title & " - " & $f_Open & "")
				$f_Text = FileRead($f_Open)
				GUICtrlSetData($c_Id,$f_Text)
				_GUICtrlEditEmptyUndoBuffer($c_Id)
			endif
		elseif $z_Save = 2 then
		endif
	else
		$f_Open = FileOpenDialog("Open File", "","Text Files(*.txt)")
		if @error then
		else
			$n_Title = WinGetTitle($w_Title,$w_Text)
			WinSetTitle($n_Title,"",$w_Title & " - " & $f_Open & "")
			$f_Text = FileRead($f_Open)
			GUICtrlSetData($c_Id,$f_Text)
			_GUICtrlEditEmptyUndoBuffer($c_Id)
		endif
	endif
EndFunc
;===============================================================================
;
; Description:		_TextEditNewFile
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditEmptyUndoBuffer and _GUICtrlEditGetModify in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Clears an edit box with option to save 
;					
;===============================================================================
Func _TextEditNewFile($c_Id,$w_Title,$w_Text = "")
	$z_Modify = _GUICtrlEditGetModify($c_Id)
	if $z_Modify <> 0 then
		$yesno = MsgBox(3,"Save File","Would you like to save the current document?")
		$n_Title = WinGetTitle($w_Title,$w_Text)
		if $z_Save = 7 then
			WinSetTitle($n_Title,"",$w_Title)
			GUICtrlSetData($c_Id, "")
			_GUICtrlEditEmptyUndoBuffer($c_Id)
		elseif $z_Save = 6 then
			_TextEditSaveFile($c_Id,$w_Title,$w_Text)
			WinSetTitle($n_Title,"",$w_Title)
			GUICtrlSetData($c_Id, "")
			_GUICtrlEditEmptyUndoBuffer($c_Id)
		elseif $z_Save = 2 then
		endif
	else
		WinSetTitle($n_Title,"",$w_Title)
		GUICtrlSetData($c_Id, "")
		_GUICtrlEditEmptyUndoBuffer($c_Id)
	endif
EndFunc
;===============================================================================
;
; Description:		_TextEditSaveFile
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditEmptyUndoBuffer and _GUICtrlEditGetModify in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Saves currently open text file or calls _TextEditSaveFileAs to save new text file.
;					
;===============================================================================
Func _TextEditSaveFile($c_Id,$w_Title,$w_Text = "")
	$n_Title = WinGetTitle($w_Title,$w_Text)
	if $n_Title = $w_Title then
		_TextEditSaveFileAs($c_Id,$w_Title,$w_Text)
	else
		$f_Save = StringTrimLeft($n_Title,12)
		FileDelete($f_Save)
		FileWrite($f_Save,GuiCtrlRead($c_Id))
		_GUICtrlEditSetModify($c_Id,"False")
	endif
EndFunc
;===============================================================================
;
; Description:		_TextEditSaveFileAs
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditSetModify in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Saves new text file.
;					
;===============================================================================
Func _TextEditSaveFileAs($c_Id,$w_Title,$w_Text = "")
	$f_Save = FileSaveDialog("Save File","","Securepad Files(*.spt)|Text Files(*.txt)")
	if @error then
	else
		$f_Ext = StringRight($f_Save, 3)
		if $f_Ext <> "txt" then
			$f_Save &= ".txt"
		endif
		FileWrite($f_Save,GuiCtrlRead($c_Id))
		$n_Title = WinGetTitle($w_Title,$w_Text)
		WinSetTitle($n_Title,"",$w_Title & " - " & $f_Save & "")
		_GUICtrlEditSetModify($c_Id,"False")
	endif
EndFunc
;===============================================================================
;
; Description:		_TextEditPrint
; Parameter(s):		$c_Id - Control ID of the Edit Control
; Requirement:		_FilePrint in Filet.au3
; Return Value(s):	None
; User CallTip:		None
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Prints whatever is currently in edit box
;					
;===============================================================================
Func _TextEditPrint($c_Id)
	$f_Print = GUICtrlRead($c_Id)
	FileWrite(@TempDir & "\texteditprint.txt",$f_Print)
	$t_File = @TempDir & "\texteditprint.txt"
	_FilePrint($t_File)
	Sleep(500)
	FileDelete(@TempDir & "\texteditprint.txt")
EndFunc
;===============================================================================
;
; Description:		_TextEditOnClose
; Parameter(s):		$c_Id - Control ID of the Edit Control
;					$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		_GUICtrlEditGetModify in GuiCtrlEdit.au3
; Return Value(s):	None
; User CallTip:		Call before GuiDelete
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Checks if file has been modified and asks to save.
;					
;===============================================================================
Func _TextEditOnClose($c_Id,$w_Title,$w_Text = "")
	$z_Modify = _GUICtrlEditGetModify($c_Id)
	if $z_Modify <> 0 then
		$z_Save = MsgBox(4,"Info","Would you like to save the current document?")
		if $z_Save = 7 then
		elseif $z_Save = 6 then
			_TextEditSaveFile($c_Id,$w_Title,$w_Text)
		endif
	endif
EndFunc