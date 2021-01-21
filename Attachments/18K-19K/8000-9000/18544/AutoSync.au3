#include <File.au3>

Local $file
If ($CmdLine[0] > 0) And FileExists($CmdLine[1]) Then
	$file = $CmdLine[1]
Else
	$file = FileOpenDialog("Choose Playlist", @MyDocumentsDir, "Playlista (*.m3u)", 1)
	If(Not(FileExists($file))) Then
		MsgBox(0x10, "AutoSync.au3", "Playlist not specified or doesn't exist.", 30)
		Exit
	EndIf
EndIf

Local $folder
If ($CmdLine[0] > 1) And FileExists($CmdLine[2]) Then
	$folder = $CmdLine[2]
Else
	$folder = FileSelectFolder("Choose Destination Folder", "", 7)
	If(Not(FileExists($folder))) Then
		MsgBox(0x10, "AutoSync.au3", "Folder not specified or doesn't exist.", 30)
		Exit
	EndIf
EndIf

Dim $syncList
If(Not(_FileReadToArray($file, $syncList))) Then
	MsgBox(0x10, "AutoSync.au3", "Error reading playlist file.", 30)
	Exit
EndIf

Local $percent = 0
ProgressOn("AutoSync.au3 - Copying Files", "Copying Files...", "", -1, -1, 18)
For $x = 1 to $syncList[0]
	FileCopy($syncList[$x], $folder, 1)
	$percent = ((Int(($syncList[0]-$x)/($syncList[0]/100))-100)*-1)
	ProgressSet($percent, String($percent) & "% Complete")
Next
Sleep(500)
ProgressOff()