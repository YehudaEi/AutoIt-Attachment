;Script create by kmeleon
;kmeleon@gazeta.pl

#include <File.au3>
#include <GUIConstants.au3>
#Include <GuiEdit.au3>
#NoTrayIcon
;--------------------------------------------------------------------
$AddSuffixToFilePath = _PathFull(@ScriptDir)
;--------------------------------------------------------------------
; ini create or read
$suffix = IniReadSection("AddSuffixToFile.ini", "suffix")
If @error Then
	$file = FileOpen("AddSuffixToFile.ini", 1)
	FileWriteLine($file, "[suffix]")
	FileWriteLine($file, "1=")
	FileWriteLine($file, "2=")
	FileWriteLine($file, "3=")
	FileWriteLine($file, "4=")
	FileWriteLine($file, "5=")
	FileWriteLine($file, "6=")
	FileWriteLine($file, "7=")
	FileWriteLine($file, "8=")
	FileClose($file)
	$suffix1 = ""
	$suffix2 = ""
	$suffix3 = ""
	$suffix4 = ""
	$suffix5 = ""
	$suffix6 = ""
	$suffix7 = ""
	$suffix8 = ""
Else 
    $suffix1 = $suffix[1][1]
	$suffix2 = $suffix[2][1]
	$suffix3 = $suffix[3][1]
	$suffix4 = $suffix[4][1]
	$suffix5 = $suffix[5][1]
	$suffix6 = $suffix[6][1]
	$suffix7 = $suffix[7][1]
	$suffix8 = $suffix[8][1]
EndIf
;--------------------------------------------------------------------
;GUI
GuiCreate("Add Suffix fo file", 200, 140)
GUICtrlCreateLabel("1. ", 5, 5, 20, 20)
$text_1 = GUICtrlCreateInput(""&$suffix1, 25, 3, 60, 20)
GUICtrlSetTip(-1, "suffix 1")
GUICtrlCreateLabel("2. ", 5, 26, 20, 20)
$text_2 = GUICtrlCreateInput(""&$suffix2, 25, 24, 60, 20)
GUICtrlSetTip(-1, "suffix 2")
GUICtrlCreateLabel("3. ", 5, 47, 20, 20)
$text_3 = GUICtrlCreateInput(""&$suffix3, 25, 45, 60, 20)
GUICtrlSetTip(-1, "suffix 3")
GUICtrlCreateLabel("4. ", 5, 68, 20, 20)
$text_4 = GUICtrlCreateInput(""&$suffix4, 25, 66, 60, 20)
GUICtrlSetTip(-1, "suffix 4")

GUICtrlCreateLabel("5. ", 105, 5, 20, 20)
$text_5 = GUICtrlCreateInput(""&$suffix5, 125, 3, 60, 20)
GUICtrlSetTip(-1, "suffix 5")
GUICtrlCreateLabel("6. ", 105, 26, 20, 20)
$text_6 = GUICtrlCreateInput(""&$suffix6, 125, 24, 60, 20)
GUICtrlSetTip(-1, "suffix 6")
GUICtrlCreateLabel("7. ", 105, 47, 20, 20)
$text_7 = GUICtrlCreateInput(""&$suffix7, 125, 45, 60, 20)
GUICtrlSetTip(-1, "suffix 7")
GUICtrlCreateLabel("8. ", 105, 68, 20, 20)
$text_8 = GUICtrlCreateInput(""&$suffix8, 125, 66, 60, 20)
GUICtrlSetTip(-1, "suffix 8")

$get_file_name = GUICtrlCreateButton("Choose File",35,95,125,25)
GUICtrlSetTip(-1, "Choose File to RENAME...")
;--------------------------------------------------------------------
Dim $szDrive, $szDir, $szFName, $szExt, $aRecords

GuiSetState()
While 1
	$MSG = GUIGetMsg()

		$_text_1 = GUICtrlRead($text_1)
		$_text_2 = GUICtrlRead($text_2)
		$_text_3 = GUICtrlRead($text_3)
		$_text_4 = GUICtrlRead($text_4)
		$_text_5 = GUICtrlRead($text_5)
		$_text_6 = GUICtrlRead($text_6)
		$_text_7 = GUICtrlRead($text_7)
		$_text_8 = GUICtrlRead($text_8)

if $MSG = $get_file_name Then
;choose file and open
	$path_file_name = FileOpenDialog( "Choose file ...", "Choose file ... ", "All files (*.*)")
	_FileReadToArray(""&$path_file_name,$aRecords)
	If @error Then
 	Else
	_PathSplit($path_file_name, $szDrive, $szDir, $szFName, $szExt)
;------------- FILE 1 -----------------------
if $_text_1 = "" Then
	Else
	$_new_file_1 = FileOpen(""&$szFName &$_text_1 &$szExt , 2)
	_FileWriteFromArray($_new_file_1, $aRecords, 1)
	FileClose($_new_file_1)
EndIf
;------------- FILE 2 -----------------------
if $_text_2 = "" Then
	Else
	$_new_file_2 = FileOpen(""&$szFName &$_text_2 &$szExt , 2)
	_FileWriteFromArray($_new_file_2, $aRecords, 1)
	FileClose($_new_file_2)
EndIf
;------------- FILE 3 -----------------------
if $_text_3 = "" Then
	Else
	$_new_file_3 = FileOpen(""&$szFName &$_text_3 &$szExt , 2)
	_FileWriteFromArray($_new_file_3, $aRecords, 1)
	FileClose($_new_file_3)
EndIf
;------------- FILE 4 -----------------------
if $_text_4 = "" Then
	Else
	$_new_file_4 = FileOpen(""&$szFName &$_text_4 &$szExt , 2)
	_FileWriteFromArray($_new_file_4, $aRecords, 1)
	FileClose($_new_file_4)
EndIf
;------------- FILE 5 -----------------------
if $_text_5 = "" Then
	Else
	$_new_file_5 = FileOpen(""&$szFName &$_text_5 &$szExt , 2)
	_FileWriteFromArray($_new_file_5, $aRecords, 1)
	FileClose($_new_file_5)
EndIf
;------------- FILE 6 -----------------------
if $_text_6 = "" Then
	Else
	$_new_file_6 = FileOpen(""&$szFName &$_text_6 &$szExt , 2)
	_FileWriteFromArray($_new_file_6, $aRecords, 1)
	FileClose($_new_file_6)
EndIf
;------------- FILE 7 -----------------------
if $_text_7 = "" Then
	Else
	$_new_file_7 = FileOpen(""&$szFName &$_text_7 &$szExt , 2)
	_FileWriteFromArray($_new_file_7, $aRecords, 1)
	FileClose($_new_file_7)
EndIf
;------------- FILE 8 -----------------------
if $_text_8 = "" Then
	Else
	$_new_file_8 = FileOpen(""&$szFName &$_text_8 &$szExt , 2)
	_FileWriteFromArray($_new_file_8, $aRecords, 1)
	FileClose($_new_file_8)
EndIf

MsgBox(0,"Info", "Done")

EndIf
EndIf

if $MSG = $GUI_EVENT_CLOSE Then
	$_AddSuffixToFilePath = ""&$AddSuffixToFilePath&"\AddSuffixToFile.ini"
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "1", ""&$_text_1)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "2", ""&$_text_2)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "3", ""&$_text_3)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "4", ""&$_text_4)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "5", ""&$_text_5)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "6", ""&$_text_6)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "7", ""&$_text_7)
	IniWrite(""&$_AddSuffixToFilePath, "suffix", "8", ""&$_text_8)
Exit
EndIf

WEnd