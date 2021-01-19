#include <Array.au3>
#include <GuiListBox.au3>

Dim $var = _ArrayCreate("")

$Form1 = GUICreate("Form1", 600, 240, 193, 125)
$Label1 = GUICtrlCreateLabel("Please select your target selections for backup from the list below.", 0, 16, 600, 17, $SS_CENTER)
$Label2 = GUICtrlCreateLabel("Be sure to hold the CTRL for multiple object selections.", 0, 56, 600, 17, $SS_CENTER)
$list1 = _GUICtrlListBox_Create($Form1, "", 5, 70, 595, 100, $WS_VSCROLL + $LBS_EXTENDEDSEL)
$Button1 = GUICtrlCreateButton("Show me my Selections", 120, 200, 120, 30, 0)
$Button2 = GUICtrlCreateButton("Cancel", 360, 200, 120, 30, 0)

$current = FileSelectFolder("Locate the root directory", "c:\")

GUISetState(@SW_SHOW)
dirSearch($current)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button2
			Exit
		Case $Button1
			$selection = _GUICtrlListBox_GetSelItemsText($list1)
			_ArrayDisplay($selection, "")
	EndSwitch
WEnd

Func dirSearch($current)

Local $search = FileFindFirstFile($current & "\*.*")
While 1
    $file = FileFindNextFile($search)
	If @error Or StringLen($file) < 1 Then ExitLoop
    If StringInStr(FileGetAttrib($current & "\" & $file), "D") And ($file <> "." Or $file <> "..") Then
			_GUICtrlListBox_AddString($list1, $current & "\" & $file)
			dirSearch($current & "\" & $file)
	Endif
WEnd
EndFunc


