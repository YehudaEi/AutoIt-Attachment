#NoTrayIcon



;================================================================================
; START INCLUDE
;================================================================================

#include <GUIConstants.au3>
#include <Misc.au3>
#include "md5.au3"

;================================================================================
; END INCLUDE
;================================================================================



;================================================================================
; START VARS
;================================================================================

Global Const $name = "Edit"
Global Const $ver = "1.0.1.2"
Global Const $auth = "Erifash"
Global Const $w = 768 - 6 - 2
Global Const $h = 538 - 32 - 2
Global Const $help = "Hotkeys:" & @CRLF & @CRLF & "Ctrl + n = New" & @CRLF & "Ctrl + o = Open" & @CRLF & "Ctrl + s = Save" & @CRLF & "Ctrl + p = Print" & @CRLF & "Ctrl + m = MD5 checksum of selected text" & @CRLF & "Ctrl + F5 = Run the saved AutoIt script currently loaded"

Global $loaded = "Untitled"
Global $fullname = ""
Global $wrap = 0
Global $indent = 1

Global $edit
Global $gui

$already = 0

;================================================================================
; END VARS
;================================================================================



;================================================================================
; START GUICTRLS
;================================================================================

$gui = GUICreate($loaded & " - " & $name, $w, $h, -1, -1, $WS_OVERLAPPEDWINDOW)

$m_file = GUICtrlCreateMenu("&File")
$mi_new = GUICtrlCreateMenuItem("&New", $m_file)
$mi_open = GUICtrlCreateMenuItem("&Open...", $m_file)
$mi_save = GUICtrlCreateMenuItem("&Save", $m_file)
$mi_saveas = GUICtrlCreateMenuItem("&Save As...", $m_file)
GUICtrlCreateMenuItem("", $m_file)
$mi_print = GUICtrlCreateMenuItem("&Print...", $m_file)
GUICtrlCreateMenuItem("", $m_file)
$mi_exit = GUICtrlCreateMenuItem("&Exit", $m_file)

$m_edit = GUICtrlCreateMenu("&Edit", -1, 1)
$mi_font = GUICtrlCreateMenuItem("&Font...", $m_edit)
$mi_color = GUICtrlCreateMenuItem("&Color...", $m_edit)
GUICtrlCreateMenuItem("", $m_edit)
$mi_wrap = GUICtrlCreateMenuItem("&Word Wrap", $m_edit)
$mi_indent = GUICtrlCreateMenuItem("Auto &Indent", $m_edit)
GUICtrlCreateMenuItem("", $m_edit)
$mi_select = GUICtrlCreateMenuItem("Select &All", $m_edit)
$mi_time = GUICtrlCreateMenuItem("&Time/Date", $m_edit)

$m_prog = GUICtrlCreateMenu("&Program")
$mi_run = GUICtrlCreateMenuItem("&Run AutoIt Script", $m_prog)
$mi_md5 = GUICtrlCreateMenuItem("&MD5 Checksum", $m_prog)

$m_help = GUICtrlCreateMenu("&Help")
$mi_info = GUICtrlCreateMenuItem("&Info", $m_help)
$mi_help = GUICtrlCreateMenuItem("&Help", $m_help)

$edit = GUICtrlCreateEdit("", 0, 0, 760, 484)
_SetFont("Lucida Console", 10)

GUICtrlSetState($mi_wrap, $GUI_UNCHECKED)
GUICtrlSetState($mi_indent, $GUI_CHECKED)
GUISetState()

;================================================================================
; END GUICTRLS
;================================================================================



;================================================================================
; START MAIN
;================================================================================

If $CmdLine[0] = 1 and FileExists($CmdLine[1]) Then _Load($CmdLine[1])

_ReduceMemory()

While 1
	$msg = GUIGetMsg()
	Select
		Case WinActive($gui, "") and not $already
			HotKeySet("^n", "_New")
			HotKeySet("^o", "_Open")
			HotKeySet("^s", "_DecideSave")
			HotKeySet("^p", "_Print")
			HotKeySet("{TAB}", "_Tab")
			HotKeySet("^a", "_SelectAll")
			HotKeySet("^{F5}", "_AutoRun")
			HotKeySet("^m", "_ClipMD5")
			If $indent Then _IndentSet(1)
			$already = 1
		Case not WinActive($gui, "") and $already
			HotKeySet("^n")
			HotKeySet("^o")
			HotKeySet("^s")
			HotKeySet("^p")
			HotKeySet("{TAB}")
			HotKeySet("^a")
			HotKeySet("^{F5}")
			HotKeySet("^m")
			_IndentSet(0)
			$already = 0
			_ReduceMemory()
	EndSelect
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $mi_new
			_New()
			_ReduceMemory()
		Case $mi_open
			_Open()
			_ReduceMemory()
		Case $mi_save
			_DecideSave()
			_ReduceMemory()
		Case $mi_saveas
			_SaveAs()
		Case $mi_print
			_Print()
		Case $mi_exit
			Exit
		Case $mi_font
			_GetSetFont()
		Case $mi_color
			_GetSetColor()
		Case $mi_wrap
			If $wrap Then
				_WrapSet(0)
				GUICtrlSetState($mi_wrap, $GUI_UNCHECKED)
			Else
				_WrapSet(1)
				GUICtrlSetState($mi_wrap, $GUI_CHECKED)
			EndIf
		Case $mi_indent
			If $indent Then
				_IndentSet(0)
				GUICtrlSetState($mi_indent, $GUI_UNCHECKED)
			Else
				_IndentSet(1)
				GUICtrlSetState($mi_indent, $GUI_CHECKED)
			EndIf
		Case $mi_select
			_SelectAll()
		Case $mi_time
			_DateTime($edit)
		Case $mi_run
			_AutoRun()
			_ReduceMemory()
		Case $mi_md5
			_ClipMD5()
			_ReduceMemory()
		Case $mi_info
			MsgBox(0 + 64 + 0 + 8192 + 262144, "Info", $name & @CRLF & "Version: " & $ver & @CRLF & "Author: " & $auth)
		Case $mi_help
			MsgBox(0 + 64 + 0 + 8192 + 262144, "Help", $help)
	EndSwitch
	Sleep(1)
Wend

;================================================================================
; END MAIN
;================================================================================



;================================================================================
; START FUNCS
;================================================================================

Func _New()
	GUICtrlSetData($edit, "")
	WinSetTitle($gui, "", "Untitled - " & $name)
	$loaded = "Untitled"
	$fullname = ""
EndFunc

Func _Open()
	Local $f = FileOpenDialog("Open", "", "All Files (*.*)", 1)
	If @ERROR Then Return
	_Load($f)
EndFunc

Func _Load($f)
	Local $filename = StringSplit($f, "\")
	$filename = $filename[$filename[0]]
	GUICtrlSetData($edit, FileRead($f, FileGetSize($f)))
	WinSetTitle($gui, "", $filename & " - " & $name)
	$loaded = $filename
	$fullname = $f
	Send("^{HOME}")
EndFunc

Func _DecideSave()
	If $loaded = "Untitled" Then
		_SaveAs()
	Else
		_HotSave()
	EndIf
EndFunc

Func _HotSave()
	_WriteTo($fullname)
EndFunc

Func _SaveAs()
	Local $f = FileSaveDialog("Save", "", "All Files (*.*)", 16)
	If @ERROR Then Return
	_WriteTo($f)
	Local $filename = StringSplit($f, "\")
	$loaded = $filename[$filename[0]]
	$fullname = $f
	WinSetTitle($gui, "", $loaded & " - " & $name)
EndFunc

Func _WriteTo($f)
	If FileExists($f) Then FileDelete($f)
	FileWrite($f, GUICtrlRead($edit))
EndFunc

Func _Print()
	Local $f = FileOpenDialog("Print", "", "All Files (*.*)", 1)
	If @ERROR Then Return
	FileMove($f, $f & ".txt")
	_FilePrint($f)
	FileMove($f & ".txt", $f)
EndFunc

Func _FilePrint($s_File, $i_Show = @SW_HIDE)
	Local $a_Ret = DllCall("shell32.dll", "long", "ShellExecute", _
			"hwnd", 0, _
			"string", "print", _
			"string", $s_File, _
			"string", "", _
			"string", "", _
			"int", $i_Show)
	If $a_Ret[0] > 32 And Not @error Then
		Return 1
	Else
		SetError($a_Ret[0])
		Return 0
	EndIf
EndFunc   ;==>_FilePrint

Func _GetSetFont()
	Local $f = _ChooseFont()
	If @error Then Return
	GUICtrlSetFont($edit, $f[3], $f[4], $f[1], $f[2])
	GUICtrlSetColor($edit, $f[7])
EndFunc

Func _GetSetColor()
	Local $c = _ChooseColor()
	If @error Then ContinueLoop
	GUICtrlSetColor($edit, $c)
EndFunc

Func _SelectAll()
	Send("^{HOME}")
	Send("^+{END}")
EndFunc

Func _DateTime($e)
	GUICtrlSetData($e, @HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "/" & @MDAY & "/" & @YEAR, 1)
EndFunc

Func _Tab()
	Local $bak = ClipGet()
	ClipPut(@TAB)
	Send("^v")
	ClipPut($bak)
EndFunc

Func _WrapSet($b)
	$wrap = $b
	If $wrap Then Return GUICtrlSetStyle($edit, 0x50200104)
	GUICtrlSetStyle($edit, $GUI_SS_DEFAULT_EDIT)
EndFunc

Func _IndentSet($b)
	If $b Then
		$indent = 1
		Return HotKeySet("{ENTER}", "_Indent")
	EndIf
	$indent = 0
	Return HotKeySet("{ENTER}")
EndFunc

Func _Indent()
	Local $bak = ClipGet()
	ClipPut("")
	ControlSend($gui, "", "Edit1", "{HOME}")
	Send("{CTRLDOWN}{SHIFTDOWN}")
	ControlSend($gui, "", "Edit1", "{RIGHT}{LEFT}")
	Send("{CTRLUP}{SHIFTUP}")
	Send("^c")
	ControlSend($gui, "", "Edit1", "{END}{ENTER}")
	If ClipGet() <> "" Then Send("^v")
	ClipPut($bak)
EndFunc

Func _AutoRun()
	Local $temp = $fullname, $del = 0, $dir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
	If $dir = "" Then Return mError("AutoIt is not installed!")
	If $loaded = "Untitled" or StringRight($fullname, 4) <> ".au3" Then
		$temp = _AutoFile()
		$del = 1
	EndIf
	RunWait('"' & $dir & '\AutoIt3.exe" "' & $temp & '"', @WorkingDir, @SW_SHOWDEFAULT)
	If $del Then FileDelete($temp)
EndFunc

Func _AutoFile()
	Local $t
	Do
		$t = "~"
		While StringLen($t) < 8
			$t = $t & Chr(Random(97, 122, 1))
		Wend
		$t = @TempDir & "\" & $t & ".au3"
	Until not FileExists($t)
	_WriteTo($t)
	Return $t
EndFunc

Func _SetFont($name, $size, $attrib = 0)
	GUICtrlSetFont($edit, $size, 400, $attrib, $name)
EndFunc

Func mError($sText, $iFatal = 0, $sTitle = "Error", $iOpt = 0)
	Local $ret = MsgBox(48 + 4096 + 262144 + $iOpt, $sTitle, $sText)
	If $iFatal Then Exit
	Return $ret
EndFunc

Func _ClipMD5()
	ClipPut("")
	Send("^c")
	Local $txt = ClipGet()
	If $txt = "" Then $txt = GUICtrlRead($edit)
	ClipPut(_md5($txt))
;	MsgBox(0 + 0 + 0 + 8192 + 262144, $name, "The MD5 checksum of the selected text has been copied to the clipboard.")
EndFunc

Func _ReduceMemory()
	DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
EndFunc   ;==>_ReduceMemory()

;================================================================================
; END FUNCS
;================================================================================