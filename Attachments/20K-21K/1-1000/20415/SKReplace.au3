#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icons\SKReplace.ico
#AutoIt3Wrapper_Outfile=SKReplace.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIListBox.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <File.au3>
Opt("GUIOnEventMode", 1)
Global $listitems = 0
Global $ActItem = ""
Global $WM_DROPFILES = 0x233
Global $DroppedFiles[1]
#Region ###
$frmSAR = GUICreate("SKGeiger - Search And Replace", 626, 445, 193, 125, $GUI_SS_DEFAULT_GUI, $WS_EX_ACCEPTFILES)
;~ GUICtrlCreateLabel("", 0,  0, 626, 445); Dummy label to catch the drop.
$lstFiles = GUICtrlCreateList("", 8, 8, 609, 240)
GUICtrlSetOnEvent(-1, "_ClickList")
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$edtSearch = GUICtrlCreateEdit("", 8, 268, 233, 133)
GUICtrlCreateLabel("search string", 8, 252, 233, 15)
$edtReplace = GUICtrlCreateEdit("", 248, 268, 233, 133)
GUICtrlCreateLabel("replace string", 248, 252, 233, 15)
$btnOpen = GUICtrlCreateButton("open textfile", 488, 265, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_OpenFiles")
$btnClear = GUICtrlCreateButton("clear list", 488, 294, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_ClearList")
$btnReplace = GUICtrlCreateButton("replace", 488, 323, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_Replace")
$btnHelp = GUICtrlCreateButton("Help", 488, 352, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_Help")
$chkCase = GUICtrlCreateCheckbox("case sensitiv", 488, 384, 129, 20, 0)
$btnExit = GUICtrlCreateButton("Exit", 488, 410, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_Exit")
$status = GUICtrlCreateProgress(8, 410, 473, 25)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC") ; drag 'n drop function
GUISetState(@SW_SHOW, $frmSAR)
$frmHelp = GUICreate("SAR Help", 632, 477, 193, 125, $WS_POPUP, -1, $frmSAR)
$HelpTxt = "SKGeiger Search 'N Relpace Help" & @crlf & @CRLF
$HelpTxt &= "1. File-import" & @crlf
$HelpTxt &= @TAB & "The import of files to change can be done in different ways." & @CRLF
$HelpTxt &= @TAB & "Files can be opened by pressing the open files Button and select multiple files." & @CRLF
$HelpTxt &= @TAB & "Also files can be open as commandline parameters, seperated with spaces and in apostrophes if necessary," & @CRLF
$HelpTxt &= @TAB & "as well as drag and drop multiple selected files from the filesystemon the list." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "2. Clicking on listitems" & @crlf
$HelpTxt &= @TAB & "This opens the clicked file for viewing with the normal application assigned for this fileextension." & @CRLF
$HelpTxt &= @TAB & "If the fileextension is not assigned to an application the file will open with Notepad." & @CRLF
$HelpTxt &= @TAB & "It will help you to copy the search term including multiple lines." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "3. Search string editfield" & @crlf
$HelpTxt &= @TAB & "Here you can specify the text(as well multiple lines) which is searched in the list of files." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "4. Replace string editfield" & @crlf
$HelpTxt &= @TAB & "Here you can specify the text(as well multiple lines) which will replace the search term in the list of files." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "5. Case sensitiv option" & @crlf
$HelpTxt &= @TAB & "By selecting this option the search term within the files have to be exact in upper and lower case." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "6. Clear list" & @crlf
$HelpTxt &= @TAB & "The list with all imported files will be cleared." & @CRLF
$HelpTxt &= @crlf
$HelpTxt &= "7. Replace" & @crlf
$HelpTxt &= @TAB & "By clicking on this button the replacement is started and the search string is searched" & @CRLF
$HelpTxt &= @TAB & "in all files in the list. After completed the action a message window gives the count of replaces." & @CRLF
$edtHelp = GUICtrlCreateEdit($HelpTxt, 16, 8, 601, 430, $ES_READONLY)
$btnHelp = GUICtrlCreateButton("close", 490, 439, 129, 25, 0)
GUICtrlSetOnEvent(-1, "_CloseHelp")
#EndRegion ###
If $cmdLine[0] Then
	For $i = 1 To $cmdLine[0]
		GUICtrlSetData($lstFiles, $cmdLine[$i])
		$listitems = 1
	Next
EndIf
While 1
	Sleep(10)
WEnd
Func _ClickList()
	$ActItem = GUICtrlRead($lstFiles)
	If $ActItem Then ShellExecute(GUICtrlRead($lstFiles))
	If @error = 1 Then
		ShellExecute("NOTEPAD.EXE", GUICtrlRead($lstFiles))
	EndIf
EndFunc   ;==>_ClickList
Func _Exit()
	Exit
EndFunc   ;==>_Exit
Func _Help()
	$pos = WinGetPos("")
	WinMove("SAR Help","",$pos[0],$pos[1],$pos[2],$pos[3])
	GUISetState(@SW_SHOW, $frmHelp)
	_GUICtrlButton_Enable($btnHelp,True)
	$y = 0
	For $x = 255 to 15 step -15
		WinSetTrans("SKGeiger - Search And Replace", "", $x)
		$y = $y + 15
		WinSetTrans("SAR Help", "", $y)
		sleep(1)
	Next
	WinSetTrans("SKGeiger - Search And Replace", "", 15)
	WinSetTrans("", "SKGeiger Search 'N Relpace Help", 255)
EndFunc   ;==>_Help
Func _CloseHelp()
	_GUICtrlButton_Enable($btnHelp,False)
	$y = 255
	For $x = 15 to 255 step 15
		WinSetTrans("SKGeiger - Search And Replace", "", $x)
		$y = $y - 15
		WinSetTrans("", "SKGeiger Search 'N Relpace Help", $y)
		sleep(1)
	Next
	WinSetTrans("SKGeiger - Search And Replace", "", 255)
	WinSetTrans("", "SKGeiger Search 'N Relpace Help", 0)
	GUISetState(@SW_HIDE, $frmHelp)
EndFunc
Func _Replace()
	If $listitems = 0 Then
		MsgBox(0, "missing files", "First open some text-files for search and replacement!")
	ElseIf GUICtrlRead($edtSearch) = "" Then
		MsgBox(0, "missing search string", "First write a search string in the search string field!")
	ElseIf GUICtrlRead($edtReplace) = "" Then
		$Quest = MsgBox(36, "missing replace string", "Replace string field is  empty, so the search string will be deleted within the files!" & @CRLF & @CRLF & "Would you proceed?")
		If $Quest = 6 Then
			_ReplaceText()
		EndIf
	Else
		_ReplaceText()
	EndIf
EndFunc   ;==>_Replace
Func _ReplaceText()
	$text = ""
	$replaces = 0
	If GUICtrlRead($chkCase) = 4 Then
		$Case = 0
	Else
		$Case = 1
	EndIf
	For $i = 0 To _GUICtrlListBox_GetCount($lstFiles) - 1
		$text = ""
		$readfile = FileOpen(_GUICtrlListBox_GetText($lstFiles, $i), 0)
		If $readfile = -1 Then Return -1
		While 1
			$text = $text & FileRead($readfile, 1)
			If @error = -1 Then ExitLoop
		WEnd
		FileClose($readfile)
		$text = StringReplace($text, _GUICtrlEdit_GetText($edtSearch), _GUICtrlEdit_GetText($edtReplace), 0, $Case)
		$replaces += @extended
		$writefile = FileOpen(_GUICtrlListBox_GetText($lstFiles, $i), 2)
		If $writefile = -1 Then Return -1
		FileWriteLine($writefile, $text)
		FileClose($writefile)
		GUICtrlSetData($status, (100 / _GUICtrlListBox_GetCount($lstFiles)) * $i)
	Next
	GUICtrlSetData($status, 100)
	MsgBox(0, "Finished", $replaces & " entries have been replaced in accordance to the parameters", 10)
EndFunc   ;==>_ReplaceText
Func _OpenFiles()
	$file = FileOpenDialog("open textbased files", "", "All (*.*)", 7)
	If Not @error Then
		If StringInStr($file, "|") Then
			$Pfad = StringLeft($file, StringInStr($file, "|") - 1)
			$file = StringReplace($file, $Pfad & "|", $Pfad & "\")
			$file = StringReplace($file, "|", "|" & $Pfad & "\", 2)
		EndIf
		GUICtrlSetData($lstFiles, $file)
		$listitems = 1
	EndIf
	_CheckList()
EndFunc   ;==>_OpenFiles
Func _CheckList()
	For $i = 0 To _GUICtrlListBox_GetCount($lstFiles)
		$List1 = _GUICtrlListBox_GetText($lstFiles, $i)
		For $a = $i + 1 To _GUICtrlListBox_GetCount($lstFiles)
			$List2 = _GUICtrlListBox_GetText($lstFiles, $a)
			If $List1 = $List2 Then
				_GUICtrlListBox_DeleteString($lstFiles, $a)
			EndIf
		Next
	Next
EndFunc   ;==>_CheckList
Func _ClearList()
	GUICtrlSetData($lstFiles, "")
	$listitems = 0
EndFunc   ;==>_ClearList
Func WM_DROPFILES_FUNC($hWnd, $MsgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)

	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $DroppedFiles[$i + 1]
		$DroppedFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
	_GetDroppedFiles()
	_CheckList()
EndFunc   ;==>WM_DROPFILES_FUNC
Func _GetDroppedFiles()
	Local $nbrFiles
	Local $i
	Local $path

	$nbrFiles = UBound($DroppedFiles) - 1; -- global
	For $i = 0 To $nbrFiles
		If FileExists($DroppedFiles[$i]) Then $path = $path & $DroppedFiles[$i] & "|"
	Next
	GUICtrlSetData($lstFiles, $path)
	$listitems = 1
EndFunc   ;==>GetDroppedFiles