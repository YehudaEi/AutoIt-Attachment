#include <GUIConstants.au3>
#Include <Misc.au3>
#include <IE.au3> 

Opt("TrayIconHide", 0)

dim $clipboard_check
dim $file

GUICreate("Clipboard Collector", 320, 240)
GUICtrlCreateLabel("Select link types to gather", 10, 10)
$web_check = GUICtrlCreateCheckbox(".html, .htm", 10, 30)
$image_check = GUICtrlCreateCheckbox(".bmp, .gif, .jpg, .png", 10, 50)
$archive_check = GUICtrlCreateCheckbox(".zip, .rar, .iso", 10, 70)
GUISetState()

$filename = "cbc-"& @MDAY & @MON & @YEAR &".txt"

Func AddClip()
	FileWriteLine($file, $clipboard_check)
	ClipPut("")
EndFunc

$file = FileOpen($filename, 1)


While 1
	$clipboard_check = ClipGet()
	$clipboard_len = StringLen($clipboard_check)
	$web_gather = GUICtrlRead($web_check)
	$image_gather = GUICtrlRead($image_check)
	$archive_gather = GUICtrlRead($archive_check)
	
	if $web_gather=1 Then
		If StringTrimLeft($clipboard_check,$clipboard_len-5)=".html" or StringTrimLeft($clipboard_check,$clipboard_len-4)=".htm" Then
			AddClip()
		EndIf
	EndIf
	
	if $image_gather=1 Then
		if StringTrimLeft($clipboard_check,$clipboard_len-4)=".jpg" Or StringTrimLeft($clipboard_check,$clipboard_len-4)=".gif" Or StringTrimLeft($clipboard_check,$clipboard_len-4)=".png" or StringTrimLeft($clipboard_check,$clipboard_len-4)=".bmp" Then
			AddClip()
		EndIf
	EndIf
	
	if $archive_gather=1 Then
		if StringTrimLeft($clipboard_check,$clipboard_len-4)=".zip" Or StringTrimLeft($clipboard_check,$clipboard_len-4)=".rar" Or StringTrimLeft($clipboard_check,$clipboard_len-4)=".iso" Then
			AddClip()
		EndIf
	EndIf
	
	$msg = GUIGetMsg()
	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			FileClose($filename)
			ShellExecute($filename)
			Exit
	EndSelect
	sleep(10)
WEnd