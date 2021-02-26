#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>

$left = RegRead("HKEY_CURRENT_USER\Software\renameTitle", "Left")
$top = RegRead("HKEY_CURRENT_USER\Software\renameTitle", "Top")
Global $sDrive, $sDir, $sFName, $sExt, $vDrive, $vDir, $vFName, $vExt, $video, $subtitle, $newsubtitle
if $left = "" then $left = 0
if $top = "" then $top = 0
$Form1 = GUICreate("Title Renamer by jsiklosi@sbb.rs", 420, 100, $left, $top,    BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST+ $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_DROPPED, "RenameFunc")
$Input1 = GUICtrlCreateInput("", 50, 16, 353, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Input2 = GUICtrlCreateInput("", 50, 50, 353, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Label1 = GUICtrlCreateLabel("Movie", 10, 22, 33, 17)
$Label2 = GUICtrlCreateLabel("Subtitle", 8, 56, 39, 17)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$l = WinGetPos("Title Renamer by jsiklosi@sbb.rs")
			RegWrite("HKEY_CURRENT_USER\Software\renameTitle", "Left", "REG_SZ", $l[0])
			RegWrite("HKEY_CURRENT_USER\Software\renameTitle", "Top", "REG_SZ", $l[1])
			Exit
		case $GUI_EVENT_DROPPED
			RenameFunc()
	EndSwitch
WEnd

Func RenameFunc()
    if GUICtrlRead($input1) > "" Then
		if GUICtrlRead($input2) > "" Then
			$video = GUICtrlRead($input1)
			$subtitle = GUICtrlRead($input2)
			_PathSplit($video, $vDrive, $vDir, $vFName, $vExt)
			_PathSplit($subtitle, $sDrive, $sDir, $sFName, $sExt)
			$newsubtitle = $vDrive & $vDir & $vFName & $sExt
			$m = MsgBox (4,"rename: " & $subtitle , "to: " & $newsubtitle)
		if $m = 6 Then
			FileCopy($subtitle,$newsubtitle)
			FileDelete($subtitle)
			GUICtrlSetData($input1,"")
			GUICtrlSetData($input2,"")
			endif
		EndIf
	EndIf
EndFunc