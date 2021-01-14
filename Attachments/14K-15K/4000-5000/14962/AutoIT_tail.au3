;========================================================
;Some notes
;This utility went through a few modifications !!
;It allows you to select a directory _
;	in this case the script will look for the latest file to be changed
;	this means that if a logfile changes name after each hour or at
;	a certain size - the tail will just follow the latest updated file
;You can select a specific file to monitor
;
;You will see in the code below the following line
;             Dim $aTails[1][12]
; The original plan was to be able to tial more than one file at the same time
; holding the output for each in its own tab. For each new "tail" the $aTails array can be redim'ed
;to be able to monitor as many files as you like ...however ....
; with the changes listed below - the increase in speed allowed you to select
; a different logfile or directory containing the log files and almost instantly tail the file.
;Originally it used FileFindFileFirst/Next to scan directories to find files that
;were being updated - but I found this to be too slow - especially over VPN
;Over VPN - Typically it could take up to 10 seconds to retrieve data from 100 possible
;log files to determine which one was the file to be "tailed" - using DOS and STDOUT
;reduced this to a couple of seconds.
;On a LAN - both these options this would just take a fraction of a second.
;You will also see from the code that the file handle is saved in the tail array -
; it is not opened and closed for each read of the log file - this saves quite a bit of time -
;the handle is closed when a new file is "tailed"
#include "TailRW.au3"
#include <ListViewConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("OnExitFunc", "endscript")

Global $aTails
Dim $aTails[1][12]
Global Const $cTailName = 1
Global Const $cDirName = 2
Global Const $cFileName = 3
Global Const $cFileModifyTime = 4
Global Const $cFileSize = 5
Global Const $cFileSizePrevious = 6
Global Const $cDisplayLines = 7
Global Const $MaxLinesInTailDisplay = 8
Global Const $TailMsg = 9
Global Const $TailHnd = 10
Global Const $Directory = 11
Global Const $MaxLines = 100
Global Const $initial_file_read = 8000 ;bytes ?
Global $No_of_tails = 0
Global $Tail_No = 0
Global $get_tail = False
Global $Tail_display_name = ""
Global $Edit1, $st_file, $st_time, $comb_list
Global $newfilecounter = 0
Global $Convert_to_UNC
Global $last_time_file_changed
Global $poll_time  ; time in milliseconds - default 1000
Global $no_change_rescan ;default 20 - after 20 x $poll time ~20 seconds - if file being
;tailed has not changed - rescan folder to see if new logfile
Global $editor
;has been created
Initialize()


Global $Saved_Tail_List = GetSavedListFromIni()

Create_GUI()

GUISetState(@SW_SHOW)

While 1
	Sleep($poll_time)
	If $get_tail Then tail($Tail_No)
WEnd
Func tail($Tail_No)
	If $aTails[$Tail_No][$cFileName] = "" Then ; first run - get file name
		FindNewestFile($aTails[$Tail_No][$cDirName], 0)
	EndIf
	If $aTails[$Tail_No][$TailHnd] = -1 Then ; if unable to get handle on file - return to loop
		$aTails[$Tail_No][$cFileName] = ""
		Return
	EndIf
	$aTails[$Tail_No][$cFileSize] = FileGetSize($aTails[$Tail_No][$cFileName])
	$timer = TimerInit()
	If $aTails[$Tail_No][$cFileSize] <> $aTails[$Tail_No][$cFileSizePrevious] Then
		$newfilecounter = 0 ; if file size has changed - reset counter to 0
	Else
		If Not $aTails[$Tail_No][$Directory] Then Return ;What this is saying is this
		; If we are monitoring a specific file - if that file size does not change - so what
		; - we will wait until it does
		; If we are monitoring a directory, and the file we are tailing doesn't change, we
		; need to find out if another logfile has been created - we will wait for a number of loops
		; (default 20) and then see if any new files have been updated. Instead of polling
		; he directory - we could / should set up a wait function that will return when there are any
		; changes to the directory.
		$newfilecounter += 1
		If $newfilecounter > $no_change_rescan Then
			$newfilecounter = 0
			FindNewestFile($aTails[$Tail_No][$cDirName], $aTails[$Tail_No][$cFileModifyTime] - 1)
			$aTails[$Tail_No][$cFileSize] = FileGetSize($aTails[$Tail_No][$cFileName])
		Else
			Return
		EndIf
	EndIf
	; This next section sets up a value for "Previous file size" that we can use later on.
	; What we are trying to achieve is this. If this is the first tail of a file - we want the last 8000 bytes (say)
	; or if the file is smaller than this - we wnt to read the whole file
	If $aTails[$Tail_No][$cFileSize] - $aTails[$Tail_No][$cFileSizePrevious] > $initial_file_read Then
		$aTails[$Tail_No][$cFileSizePrevious] = $aTails[$Tail_No][$cFileSize] - $initial_file_read
	ElseIf $aTails[$Tail_No][$cFileSizePrevious] > $aTails[$Tail_No][$cFileSize] Then
		$aTails[$Tail_No][$cFileSizePrevious] = $aTails[$Tail_No][$cFileSize] - $initial_file_read
	EndIf
	If $aTails[$Tail_No][$cFileSizePrevious] < 0 Then $aTails[$Tail_No][$cFileSizePrevious] = 0
	If $aTails[$Tail_No][$TailHnd] <> -1 Then
		; if we have a handle on the file - lets do some work.
		;We will set a file pointer to the previous file size - then read the rest of the file
		_APIFileSetPos ($aTails[$Tail_No][$TailHnd], $aTails[$Tail_No][$cFileSizePrevious])
		Local $tmp_msg = _APIFileRead ($aTails[$Tail_No][$TailHnd], $aTails[$Tail_No][$cFileSize] - $aTails[$Tail_No][$cFileSizePrevious])
		If @error <> 0 Then
			; Now we have the "tail" - we need to display it.
			;I would like to display the "tail" in an edit box - but I am only going to show 100 lines (cofigurable)
			; in the edit box. When the line number grows to say 140 then chop off the first 40 lines displayed
			; so well will always see the last 100 lines in the edit box
			$aTails[$Tail_No][$TailMsg] &= $tmp_msg
			Local $a_tmpLF = StringSplit($aTails[$Tail_No][$TailMsg], @LF)
			If $a_tmpLF[0] > $aTails[$Tail_No][$MaxLinesInTailDisplay] + 40 Then $aTails[$Tail_No][$TailMsg] = StringRight($aTails[$Tail_No][$TailMsg], StringLen($aTails[$Tail_No][$TailMsg]) - StringInStr($aTails[$Tail_No][$TailMsg], @LF, 0, -$aTails[$Tail_No][$MaxLinesInTailDisplay]))
			$aTails[$Tail_No][$cFileSizePrevious] = $aTails[$Tail_No][$cFileSize]
			GUICtrlSetData($st_time, StringFormat("%.2f", TimerDiff($timer)) & " msec")
			;Some log files use @LF as a line break, some use @CRLF. The edit box uses
			; @CRLF as a line break so add in the @CR bit if necessary
			If StringInStr($aTails[$Tail_No][$TailMsg], @CRLF) Then
				GUICtrlSetData($Edit1, $aTails[$Tail_No][$TailMsg])
			Else
				GUICtrlSetData($Edit1, StringReplace($aTails[$Tail_No][$TailMsg], @LF, @CRLF))
			EndIf
			GUICtrlSetData($last_time_file_changed, "Updated " & @MDAY & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
			; This moves curser to bottom of edit box so end of edit box is always visible
			; Thanks to Gary Frost - these UDFs are brilliant
			_GUICtrlEditLineScroll($Edit1, 0, _GUICtrlEditGetLineCount($Edit1))
		Else
			$aTails[$Tail_No][$cFileName] = ""
			MsgBox(0, "error return from _APIFileRead", _LastErr (), 1)
		EndIf
	Else
		MsgBox(0, "", "No file handle for :" & $aTails[$Tail_No][$cFileName])
		$aTails[$Tail_No][$cFileName] = ""
	EndIf
EndFunc   ;==>tail
Func FindNewestFile($Dir, $t = 0)
	; This version of AutoIT_Tail uses DOS Dir command and STDOUT to get directory
	; listing
	Local $file = ""
	Local $tmptime
	Local $time = $t
	Local $rtn = ""
	Local $h_files = Run(@ComSpec & " /c " & '"dir ' & $Dir & '/TC /O-D /B"', "", @SW_HIDE, 2)
	While 1
		$rtn &= StdoutRead($h_files)
		If @error Then ExitLoop
	WEnd
	Local $a_files = StringRegExp(StringStripCR($rtn), "(.*)", 1)
	If @error = 0 Then
		If $a_files[0] <> "" Then $file = $Dir & $a_files[0]
	EndIf
	;msgbox(0,"",Timerdiff($findtime))
	$aTails[$Tail_No][$TailHnd] = -1
	If $file <> "" Then
		If $aTails[$Tail_No][$cFileName] <> $file Then $aTails[$Tail_No][$cFileSizePrevious] = 0
		$aTails[$Tail_No][$cFileName] = $file
		$aTails[$Tail_No][$cFileModifyTime] = $time
		_APIFileClose ($aTails[$Tail_No][$TailHnd])
		$aTails[$Tail_No][$TailHnd] = _APIFileOpen ($aTails[$Tail_No][$cFileName])
		GUICtrlSetData($st_file, $aTails[$Tail_No][$cFileName])
	Else
		GUICtrlSetData($st_file, "**ERROR** - path does not exist  :" & $Dir)
		GUICtrlSetBkColor($st_file, 0xFF0000)
		GUICtrlSetBkColor($st_time, 0xFF0000)
		GUICtrlSetBkColor($last_time_file_changed, 0xFF0000)
	EndIf
EndFunc   ;==>FindNewestFile
Func Pause()
	$get_tail = False
	GUICtrlSetBkColor($st_time, 0xFFAA55)
	GUICtrlSetBkColor($st_file, 0xFFAA55)
	GUICtrlSetBkColor($last_time_file_changed, 0xFFAA55)
	GUICtrlSetData($st_time, "Paused")
EndFunc   ;==>Pause
Func Open_In_Editor()
	Run('"' & $editor & '" "' & $aTails[$Tail_No][$cFileName] & '"')
EndFunc   ;==>Open_In_Editor
Func Make_GUI_bigger()
	$size = WinGetPos("Attempt at Tail by steve8tch")
	WinMove("Attempt at Tail by steve8tch", "", $size[0], $size[1], $size[2], @DesktopHeight * .75)
EndFunc   ;==>Make_GUI_bigger
Func Make_GUI_smaller()
	$size = WinGetPos("Attempt at Tail by steve8tch")
	WinMove("Attempt at Tail by steve8tch", "", $size[0], $size[1], $size[2], @DesktopHeight * .2)
EndFunc   ;==>Make_GUI_smaller
Func CLOSEClicked()
	Exit
EndFunc   ;==>CLOSEClicked
Func Create_GUI()
	#Region ### START Koda GUI section ### Form=
	Global $Form1 = GUICreate("Attempt at Tail by steve8tch", 904, 163, 88, 135, $WS_OVERLAPPEDWINDOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	Global $Button0 = GUICtrlCreateButton("Go !", 670, 8, 50, 18, $BS_DEFPUSHBUTTON)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	;GUICtrlSetBkColor(-1, 0x00FF00)
	GUICtrlSetOnEvent($Button0, "Go")
	; Just a note -  at present $BS_DEFPUSHBUTTON doesn't seem to work well with
	;coloured buttons. I hope a later release will fix this
	Global $ButtonA = GUICtrlCreateButton("Add", 635, 5, 25, 12)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetOnEvent($ButtonA, "Add")
	Global $ButtonD = GUICtrlCreateButton("Del", 635, 20, 25, 12)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetOnEvent($ButtonD, "Del")

	Global $Button1 = GUICtrlCreateButton("Pause", 727, 8, 50, 18)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	;GUICtrlSetBkColor(-1, 0xFFAA55)
	GUICtrlSetOnEvent($Button1, "Pause")
	Global $Button2 = GUICtrlCreateButton("Open file", 784, 8, 113, 18)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetOnEvent($Button2, "Open_In_Editor")
	Global $btn_browse = GUICtrlCreateButton("Browse for dir", 8, 8, 113, 18)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetOnEvent($btn_browse, "F_browse")
	$comb_list = GUICtrlCreateCombo("", 126, 8, 500, 18)
	GUICtrlSetData($comb_list, $Saved_Tail_List)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetOnEvent($comb_list, "F_combo")
	$Edit1 = GUICtrlCreateEdit("", 8, 35, 889, 103)
	GUICtrlSetData(-1, "")
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetFont(-1, 8, 300, -1, "Arial")
	GUICtrlSetBkColor(-1, 0xF1EC85)
	Global $Button8 = GUICtrlCreateButton("-", 776, 143, 49, 18, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetFont(-1, 12, 400, -1, "Arial")
	GUICtrlSetOnEvent($Button8, "Make_GUI_smaller")
	Global $Button9 = GUICtrlCreateButton("+", 832, 143, 49, 18, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetFont(-1, 12, 400, -1, "Arial")
	GUICtrlSetOnEvent($Button9, "Make_GUI_bigger")
	Global $st_time = GUICtrlCreateLabel("", 8, 143, 80, 18, $SS_SUNKEN)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)
	Global $st_file = GUICtrlCreateLabel("", 93, 143, 525, 18, $SS_SUNKEN)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)
	Global $last_time_file_changed = GUICtrlCreateLabel("", 623, 143, 142, 18, $SS_SUNKEN)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)
EndFunc   ;==>Create_GUI
Func F_combo()
	
EndFunc   ;==>F_combo
Func F_browse()
	Local $Initial_Dir = IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Log_file_location", "My Computer")
	If $Initial_Dir = "My Computer" Then $Initial_Dir = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	Local $entry = FileOpenDialog("Select File or Folder", $Initial_Dir, "All (*.*)", 2, "To_open_folder_just_click_Open")
	If Not @error Then
		If StringInStr($entry, "To_open_folder_just_click_Open") Then
			$entry = StringLeft($entry, StringInStr($entry, "\", 0, -1))
		EndIf
		If $Convert_to_UNC Then $entry = _Convert_to_UNC($entry)
		$Saved_Tail_List &= "|" & $entry
		GUICtrlSetData($comb_list, $Saved_Tail_List, $entry)
	EndIf
EndFunc   ;==>F_browse
Func _Convert_to_UNC($x)
	$drive = StringLeft($x, (StringInStr($x, ":") - 1))
	If DriveGetType($drive & ":\") = "Network" Then
		$x = StringReplace($x, $drive & ":", DriveMapGet($drive & ":"))
	EndIf
	Return $x
EndFunc   ;==>_Convert_to_UNC
Func Add()
	Local $add = GUICtrlRead($comb_list)
	If $add <> "" Then
		IniAdd($add)
		GUICtrlSetData($comb_list, "|" & GetSavedListFromIni(), $add)
	EndIf
EndFunc   ;==>Add
Func Del()
	If GUICtrlRead($comb_list) <> "" Then
		IniDel(GUICtrlRead($comb_list))
		GUICtrlSetData($comb_list, "|" & GetSavedListFromIni())
	EndIf
EndFunc   ;==>Del
Func IniDel($x)
	Local $list = ""
	Local $aList = IniReadSection(@ScriptDir & "\Tail.ini", "Saved_List")
	Local $counter = 1
	If Not @error Then
		For $i = 1 To $aList[0][0]
			If $aList[$i][1] <> $x Then
				$list &= $counter & "=" & $aList[$i][1] & @LF
				$counter += 1
			EndIf
		Next
	EndIf
	UpdateIni($list)
EndFunc   ;==>IniDel
Func IniAdd($x)
	Local $list = ""
	Local $aList = IniReadSection(@ScriptDir & "\Tail.ini", "Saved_List")
	Local $counter = 1
	If Not @error Then
		$list &= $counter & "=" & $x & @LF
		$counter += 1
		For $i = 1 To $aList[0][0]
			If $aList[$i][1] <> "" Then
				If $aList[$i][1] = $x Then
					ContinueLoop
				EndIf
				$list &= $counter & "=" & $aList[$i][1] & @LF
				$counter += 1
			EndIf
		Next
	EndIf
	$list = StringTrimRight($list, 1)
	UpdateIni($list)
EndFunc   ;==>IniAdd
Func UpdateIni($x)
	IniDelete(@ScriptDir & "\Tail.ini", "Saved_List")
	IniWriteSection(@ScriptDir & "\Tail.ini", "Saved_List", $x)
EndFunc   ;==>UpdateIni

Func Go()
	$get_tail = True
	$Tail_No = 0
	GUICtrlSetBkColor($st_time, 0xBBFFBB)
	GUICtrlSetBkColor($st_file, 0xBBFFBB)
	GUICtrlSetBkColor($last_time_file_changed, 0xBBFFBB)
	$tmp_longname = GUICtrlRead($comb_list)
	;This sets up the tail array with appropraite data read from combo control
	If StringRight($tmp_longname, 1) = "\" Then
		; rem - "\" means scan directory for files that change
		$aTails[$Tail_No][$cTailName] = $Tail_No
		$aTails[$Tail_No][$cDirName] = $tmp_longname
		$aTails[$Tail_No][$cFileName] = ""
		$aTails[$Tail_No][$cFileModifyTime] = ""
		$aTails[$Tail_No][$cFileSize] = 0
		$aTails[$Tail_No][$cFileSizePrevious] = 0
		$aTails[$Tail_No][$cDisplayLines] = 0
		$aTails[$Tail_No][$MaxLinesInTailDisplay] = $MaxLines
		$aTails[$Tail_No][$TailMsg] = ""
		$aTails[$Tail_No][$Directory] = True
	Else
		$tmpfile = StringTrimLeft($tmp_longname, (StringInStr($tmp_longname, "\", 0, -1)))
		$tmpdir = StringReplace($tmp_longname & "xxx", $tmpfile & "xxx", "")
		;This checks to see if the same name has been selected as the previous tail
		; If is is the same - we can just use some of the old data
		If $aTails[$Tail_No][$cFileName] = $tmp_longname And $aTails[$Tail_No][$cTailName] = $Tail_No Then
			;proceed
		Else
			$aTails[$Tail_No][$cTailName] = $Tail_No
			$aTails[$Tail_No][$cDirName] = $tmpdir
			$aTails[$Tail_No][$cFileName] = $tmp_longname
			$aTails[$Tail_No][$cFileModifyTime] = ""
			$aTails[$Tail_No][$cFileSize] = 0
			$aTails[$Tail_No][$cFileSizePrevious] = 0
			$aTails[$Tail_No][$cDisplayLines] = 0
			$aTails[$Tail_No][$MaxLinesInTailDisplay] = $MaxLines
			$aTails[$Tail_No][$TailMsg] = ""
			$aTails[$Tail_No][$Directory] = False
			If $aTails[$Tail_No][$cFileName] <> "" Then
				$aTails[$Tail_No][$cFileSizePrevious] = 0
				; This closes off any pevious handle before opening new file
				_APIFileClose ($aTails[$Tail_No][$TailHnd])
				$aTails[$Tail_No][$TailHnd] = -1
				$aTails[$Tail_No][$TailHnd] = _APIFileOpen ($aTails[$Tail_No][$cFileName])
				GUICtrlSetData($st_file, $aTails[$Tail_No][$cFileName])
			Else
				Return
			EndIf
		EndIf
	EndIf
	tail($Tail_No)
EndFunc   ;==>Go


Func _GUICtrlEditLineScroll($h_edit, $i_horiz, $i_vert)
	If IsHWnd($h_edit) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_edit, "int", $EM_LINESCROLL, "int", $i_horiz, "int", $i_vert)
		Return $a_ret[0]
	Else
		Return GUICtrlSendMsg($h_edit, $EM_LINESCROLL, $i_horiz, $i_vert)
	EndIf
EndFunc   ;==>_GUICtrlEditLineScroll
Func _GUICtrlEditGetLineCount($h_edit)
	If IsHWnd($h_edit) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_edit, "int", $EM_GETLINECOUNT, "int", 0, "int", 0)
		Return $a_ret[0]
	Else
		Return GUICtrlSendMsg($h_edit, $EM_GETLINECOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditGetLineCount
Func GetSavedListFromIni()
	Local $list = ""
	Local $aList = IniReadSection(@ScriptDir & "\Tail.ini", "Saved_List")
	If @error Then Return $list
	For $i = 1 To $aList[0][0]
		$list &= $aList[$i][1] & "|"
	Next
	Return $list
EndFunc   ;==>GetSavedListFromIni

Func endscript()
	For $Tail_No = 0 To UBound($aTails) - 1
		_APIFileClose ($aTails[$Tail_No][$TailHnd])
	Next
EndFunc   ;==>endscript
Func Initialize()
	;If you have a "default log file area" - or a default search path - set it up here.
	If IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Log_file_location", "999") = "999" Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Log_file_location", "My Computer")
	EndIf
	
	; If you are like me and you jump around from one mapped drive to another
	; then this will convert any mapped drives you are using to UNC drives
	; freeing up mapped drive letter for reuse
	; By default - turn this option "ON"
	If IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Convert_to_UNC", "999") Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Convert_to_UNC", "1")
	EndIf
	$Convert_to_UNC = IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Convert_to_UNC", "999")
	If $Convert_to_UNC = "0" Then
		$Convert_to_UNC = False
	Else
		$Convert_to_UNC = True
	EndIf
	; Poll_timer - 1000 = 1 second
	If IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Poll_Timer", "XXX") = "XXX" Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Poll_Timer", "1000")
	EndIf
	$poll_time = IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Poll_Timer", "XXX")
	If Not IsNumber($poll_time) Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Poll_Timer", "1000")
		$poll_time = 1000
	EndIf
	;Folder rescan when file being tailed hasn't changed in last "20" polls
	If IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Folder_Rescan", "XXX") = "XXX" Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Folder_Rescan", "20")
	EndIf
	$no_change_rescan = IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Folder_Rescan", "XXX")
	If Not IsNumber($no_change_rescan) Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Folder_Rescan", "20")
		$no_change_rescan = 20
	EndIf
	;Set path to editor you want to use if you open up the whole log file
	; by default it is just set to "notepad" - and this should just work
	; but you can put in the full path to your own editor in the ini file.
	If IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Editor", "999") = "999" Then
		IniWrite(@ScriptDir & "\Tail.ini", "Defaults", "Editor", "notepad.exe")
	EndIf
	$editor = IniRead(@ScriptDir & "\Tail.ini", "Defaults", "Editor", "999")
EndFunc   ;==>Initialize