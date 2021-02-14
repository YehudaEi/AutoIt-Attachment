#include <Process.au3>
$search = FileFindFirstFile("C:\ftp\*.jpg")  
$file = "string"
$modified_dt = 0

If $search = -1 Then
	MsgBox(0, "Error", "No files/directories matched the search pattern")
	Exit
EndIf
While 1
	$file = FileFindNextFile($search) 
	If @error Then ExitLoop
	if FileGetTime($file,0,1) > $modified_dt Then
		$modified_dt = FileGetTime($file,0,1)
		$latestFile = $file
	EndIf

WEnd
FileClose($search)
_RunDOS("Start C:\ftp\" & $latestFile)