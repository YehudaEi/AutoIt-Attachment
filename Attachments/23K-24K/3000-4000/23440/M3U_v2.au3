#include <GUIConstantsEx.au3>
#include <ListboxConstants.au3>
#Include <GuiListBox.au3>
#include <WindowsConstants.au3>
#include <String.au3>

;HotKeySet("!o", "_ArDisplay")

Opt('MustDeclareVars', 1)

Global $guictrl[8]
Global $files[200]
Global $arraypos = 0
Global $last_selected
Global $name = "playlist.m3u"

_main()

Func _main()
    Local $msg
	Local $title = "M3U Creator"
	
    GUICreate($title, 700, 233)
	GUISetFont(7.5)
    GUISetState(@SW_SHOW)
	$guictrl[0] = GUICtrlCreateButton("Add ", 10, 40, 45)
	$guictrl[1] = GUICtrlCreateList("", 65, 10, 625, 225,  BitOR($WS_HSCROLL, $WS_VSCROLL, $LBS_EXTENDEDSEL))
	$guictrl[2] = GUICtrlCreateButton("Save ", 10, 70, 45)
	$guictrl[3] = GUICtrlCreateButton("Delete ", 10, 100, 45)
	$guictrl[4] = GUICtrlCreateButton(" ^ ", 20, 130, 25)
	$guictrl[5] = GUICtrlCreateButton(" v ", 20, 160, 25)
	$guictrl[6] = GUICtrlCreateButton("Clear", 10, 190, 45)
	
	$guictrl[7] = GUICtrlCreateButton("Import", 10, 10, 45)

	GUICtrlSetFont($guictrl[1], 8.5, "", "", "Courier New")

    While 1
        $msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $guictrl[7]
				_Import()
			Case $msg = $guictrl[0]
				_OpenDialog()
			Case $msg = $guictrl[2]
				_Save($title)
			Case $msg = $guictrl[3]
				_Delete()
			Case $msg = $guictrl[4]
				_MoveUp()
			Case $msg = $guictrl[5]
				_MoveDown()
			Case $msg = $guictrl[6]
				_ClearArray()
		EndSelect
    WEnd
	
    GUIDelete()
EndFunc

Func _Import()
	Local $import
	Local $i = 0
	Local $filesize	
	Local $k = 0
	Local $skip = 0
	
	$import = FileOpenDialog("Select M3U file.", @WorkingDir, "Playlist (*.M3U)")
	$i = FileGetSize($import) - 1
	If @error Or $i = -1 Then
		MsgBox("", "Error", "File is empty")
		Return
	EndIf
	$filesize = StringLen(StringAddCR(FileRead($import, $i))) - $i + 1
	$i = 0
	
	Local $temp[$filesize]

	While $i < $filesize
		$skip = 0
		$k = 0
		$temp[$i] = FileReadLine($import, $i + 1)
		
		If StringInStr($temp[$i], "\") Then
		Else
			$temp[$i] = _StringInsert($temp[$i], @WorkingDir & "\", 0)
		EndIf
		While $k < $arraypos
			If $temp[$i] = $files[$k] Then
				MsgBox(0, "", '"' & $temp[$i] & '" is allready in the library')
				$skip = 1
			EndIf
			$k += 1
		WEnd
		$k = 0
		If $skip = 0 Then
			$files[$arraypos] = $temp[$i]
			$arraypos += 1
		EndIf
		$i += 1
	WEnd
	
	_UpdateList()
EndFunc

Func _OpenDialog()
	Local $odfile
	Local $pos
	Local $i = 1
	Local $k = 0
	Local $temp[200]
	Local $skip = 0
	
	$odfile = FileOpenDialog("Select Files", @WorkingDir, "Music (*.MP3; *.WMA; *.ASF; *.AC3; *.FLAC; *.OGG;*.M4A; *.MKA; *.TTA; *.WV; *.WAV)", 4)
	If @error Then Return

	If StringInStr($odfile, "|") Then
		$temp = StringSplit($odfile, "|")

		While $i < $temp[0]
			$skip = 0
			While $k < $arraypos
				If $temp[1] & "\" & $temp[$i + 1] = $files[$k] Then
					MsgBox(0, "", '"' & $temp[$i + 1] & '" is allready in the library')
					$skip = 1
				EndIf
				$k += 1
			WEnd
			$k = 0
			If $skip = 0 Then
				$files[$arraypos] = $temp[1] & "\" & $temp[$i + 1]
				$arraypos += 1
			EndIf
			$i += 1
		WEnd
	Else
		While $k < $arraypos
			If $odfile = $files[$k] Then
				MsgBox(0, "", '"' & $odfile & '" is allready in the library')
				$skip = 1
			EndIf
			$k += 1
		WEnd
		$k = 0
		If $skip = 0 Then
			$files[$arraypos] = $odfile
			$arraypos += 1
		EndIf
	EndIf
	
	_UpdateList()
EndFunc

Func _UpdateList()
	Local $i
	Local $strlen
	Local $horiz_fit
	Local $max_len = 0

	GUICtrlSetData($guictrl[1], "")
	While $i < $arraypos
		GUICtrlSetData($guictrl[1], $files[$i])
		$strlen = StringLen($files[$i])
		If $strlen > 88 Then
			If $strlen > $max_len Then
				$max_len = $strlen
			EndIf
		EndIf
		$i += 1
	WEnd
	$horiz_fit = Round($max_len * 7.08)
	_GUICtrlListBox_SetHorizontalExtent($guictrl[1], $horiz_fit)
	_GUICtrlListBox_SetSel($guictrl[1], $last_selected)
EndFunc

Func _Save(ByRef $title)
	Local $i = 0
	Local $saveas
	Local $file_name
	Local $overwrite
	Local $temp_namer[20]
	
	$saveas = FileSaveDialog("Save As", @WorkingDir, "Playlist (*.m3u)", "", $name)
	If @error Then Return
	If StringInStr($saveas, ".") Then
		$file_name = $saveas
	Else
		$file_name = $saveas & ".m3u"
	EndIf
		

	If FileExists($file_name) Then
		$overwrite = MsgBox(276, "Overwrite?", "Would you like to Overwrite this file?")
		If $overwrite = 6 Then
			FileDelete($file_name)
		Else
			Return
		EndIf
	EndIf
	
	While $i < $arraypos
		FileWriteLine($file_name, $files[$i])
		$i += 1
	WEnd
	
	$temp_namer = StringSplit($file_name, "\")
	$name = $temp_namer[$temp_namer[0]]

	If StringLen($title & " - " & $file_name) > 97 Then
		If StringLen($title & " - " & $temp_namer[1] & "\ . . . \" & $temp_namer[$temp_namer[0] - 2] & "\" & $temp_namer[$temp_namer[0] - 1] & "\" & $temp_namer[$temp_namer[0]]) > 97 Then
			WinSetTitle($title, "", $title & " - " & $temp_namer[1] & "\ . . . \" & $temp_namer[$temp_namer[0] - 1] & "\" & $temp_namer[$temp_namer[0]])
		Else
			WinSetTitle($title, "", $title & " - " & $temp_namer[1] & "\ . . . \" & $temp_namer[$temp_namer[0] - 2] & "\" & $temp_namer[$temp_namer[0] - 1] & "\" & $temp_namer[$temp_namer[0]])
		EndIf
	Else
		WinSetTitle($title, "", $title & " - " & $file_name)
	EndIf
EndFunc

Func _ClearArray()
	Local $i
	Local $clear
	
	$clear = MsgBox(276, "Clear playlist?", "Are you sure you want to clear your playlist?")
	If $clear = 6 Then
	Else
		Return
	EndIf
	
	GUICtrlSetData($guictrl[1], "")
	While $i < $arraypos
		$files[$i] = ""
		$i += 1
	WEnd
	$last_selected = ""
	$arraypos = 0
EndFunc

Func _Delete()
	Local $i = 0
	Local $k = 0
	Local $temp
	
	$temp = GUICtrlRead($guictrl[1])
	
	While $i < $arraypos
		If $temp = $files[$i] Then
			$files[$i] = ""
			$k = $i
			While $k < $arraypos
				$files[$k] = $files[$k + 1]
				$k += 1
			WEnd
			$arraypos -= 1
			$last_selected = $i
			_UpdateList()
			Return
		EndIf
		$i += 1
	WEnd
EndFunc

Func _MoveUp()
	Local $i
	Local $temp
	
	$temp = GUICtrlRead($guictrl[1])
	
	While $i < $arraypos
		If $temp = $files[$i] Then
			If $i = 0 Then
				MsgBox(0,"Error", "Sorry, This file is allready at the top of the list.")
				Return
			EndIf
			_Swap($i, $i - 1)
			Return
		EndIf
		$i += 1
	WEnd
EndFunc

Func _MoveDown()
	Local $i
	Local $temp
	
	$temp = GUICtrlRead($guictrl[1])
	
	While $i < $arraypos
		If $temp = $files[$i] Then
			If $i = $arraypos - 1 Then
				MsgBox(0,"Error", "Sorry, This file is allready at the bottom of the list.")
				Return
			EndIf
			_Swap($i, $i + 1)
			Return
		EndIf
		$i += 1
	WEnd
EndFunc

Func _Swap($pos1, $pos2)
	Local $temp
	
	If $pos1 > $pos2 Then
		$last_selected = $pos1 - 1
	Else
		$last_selected = $pos1 + 1
	EndIf
	$temp = $files[$pos1]
	$files[$pos1] = $files[$pos2]
	$files[$pos2] = $temp
	_UpdateList()
EndFunc


;Func _ArDisplay()
;	_ArrayDisplay($files)
;	MsgBox(0, "", $arraypos)
;EndFunc