; Filename search and replace

#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>

Global $dir = "C:\"
Global $folder

; GUI
$Form1 = GUICreate("Filename Search & Replace", 478, 110, 272, 275)
$Input1 = GUICtrlCreateInput($dir, 113, 5, 281, 21, -1, $WS_EX_CLIENTEDGE)
$Input2 = GUICtrlCreateInput("", 113, 29, 121, 21, -1, $WS_EX_CLIENTEDGE)
$Input3 = GUICtrlCreateInput("", 113, 53, 121, 21, -1, $WS_EX_CLIENTEDGE)
$Button1 = GUICtrlCreateButton("Browse", 397, 3, 75, 25)
GUICtrlCreateLabel("Directory to search in:", 5, 8, 107, 17)
GUICtrlCreateLabel("Find in filename:", 32, 32, 80, 17)
GUICtrlCreateLabel("Replace with:", 43, 56, 69, 17)
$Button2 = GUICtrlCreateButton("Do!", 389, 72, 83, 33)
GUICtrlCreateLabel("Status:", 8, 88, 37, 17)
$status = GUICtrlCreateLabel("Ready", 48, 88, 235, 17)

GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
		
	Case $msg = $Button1
		$folder1 = FileSelectFolder("Choose Search Folder", "", 1, $dir)
		If @error = 1 Then
			GUICtrlSetData($Input1, $dir)
		Else
			GUICtrlSetData($Input1, $folder1)
			$dir = $folder1
		EndIf
		
	Case $msg = $Button2
		$search = GUICtrlRead($Input2)
		$replace = GUICtrlRead($Input3)
		$filelist = _FileListToArray($dir)
		Dim $outputlist[$filelist[0] + 1]
		For $x = 1 to $filelist[0]
			$in = $dir & "\" & $filelist[$x]
			$out = StringReplace($filelist[$x], $search, $replace)
			$outputlist[$x] = $dir & "\" & $out
			FileMove($in, $outputlist[$x])
			GUICtrlSetData($status, "Renaming " & $x & " of " & $filelist[0] & " files")
		Next
		GUICtrlSetData($status, "Completed")
		
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

