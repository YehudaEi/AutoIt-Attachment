#include <GUIConstants.au3>
Opt("TrayIconDebug", 1)
Opt("WinTitleMatchMode", 2)

Global $file[2][5], $fileopn, $recentfile
$count = 4

$mainwindow = GUICreate("HEAT Utility", 175, 25)
$filemenu = GUICtrlCreateMenu("&File")
$open = GUICtrlCreateMenuItem("Open...", $filemenu)
$parse = GUICtrlCreateMenuItem("Parse...", $filemenu)
$recentopen = GUICtrlCreateMenu("Recent Open", $filemenu)
$recentparse = GUICtrlCreateMenu("Recent Parse", $filemenu)
$quit = GUICtrlCreateMenuItem("Exit", $filemenu)
$heat = GUICtrlCreateMenu("&HEAT")
$run = GUICtrlCreateMenuItem("HEAT Search", $heat)
$noneopen = GUICtrlCreateMenuItem("(None)", $recentopen)
$noneparse = GUICtrlCreateMenuItem("(None)", $recentparse)

GUICtrlSetState($noneopen, $GUI_DISABLE)
GUICtrlSetState($noneparse, $GUI_DISABLE)

While 1
	$msg = GUIGetMsg()

	Select
		Case $msg = $open
			$fileopn = FileOpenDialog("Choose file...",@ScriptDir & "\searches","INI File (*.ini)")
			If @error <> 1 then
				Run(@ComSpec & " /c notepad.exe " & $fileopn, "", @SW_HIDE)
			EndIf
			GUICtrlDelete($noneopen)
			$slash = StringInStr($fileopn, "\", 0, -1)
			$filerecent = StringTrimLeft($fileopn, $slash)
			$recentopen = GUICtrlCreateMenuItem($filerecent, $recentopen)
		Case $msg = $parse
			$fileparse = FileOpenDialog("Choose file...",@ScriptDir & "\searches","INI File (*.ini)")
			If @error <> 1 then
				ParseFile()
			EndIf
			GUICtrlDelete($noneparse)
			$slash = StringInStr($fileparse, "\", 0, -1)
			$filerecent = StringTrimLeft($fileparse, $slash)
			$recentparse = GUICtrlCreateMenuItem($filerecent, $recentparse)
		Case $msg = $run
			Run("HEATSearch.exe")
			WinActivate("HEAT Utility")
		Case $msg = $recentopen
			Run(@ComSpec & " /c notepad.exe " & $fileopn, "", @SW_HIDE)
		Case $msg = $recentparse
			ParseFile()
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $quit
			ExitLoop
	EndSelect
WEnd

Func ParseFile()
	If $msg = $recentparse then
		IniWrite(@ScriptDir & "\ini\parsefile.ini", "FileToParse", "File", $recentparse)
	Else
		IniWrite(@ScriptDir & "\ini\parsefile.ini", "FileToParse", "File", $fileparse)
	EndIf
	Run(@ScriptDir & "\parseini.exe")
EndFunc;==>ParseFile

Func Quit()
	Exit
EndFunc;==>Quit