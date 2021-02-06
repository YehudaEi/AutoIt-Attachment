#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#Include <File.au3>
#Include <Array.au3>

; Script Start - Add your code below here
dim $rootdir = FileSelectFolder ("Select Root folder for Zip", "", 4)		; select the root folder from which recursive zipping will start

ZipDir($rootdir)

Func ZipDir($dir)


FileChangeDir($dir)

MsgBox(64, "Directory", "Dir is: " & $dir)
$dirList=_FileListToArray($dir, "*", 2)
If @Error=1 Then
    MsgBox (0,"","Folder Not Found.")
Else
	_ArrayDelete($dirList, 0)
	for $directory in $dirList
		ZipDir($directory)
	Next
EndIf

;MsgBox(64, "Directory", "Dir is: " & $dir)								; Debugging: ensure correct folder is selected
; Put all files from the root of the folder into an array
$FileList=_FileListToArray($dir,"*",1)
If @Error=4 Then
    ;MsgBox (0,"","No Files Found.")
    Return
Else
	;_ArrayDisplay($FileList,"$FileList")									; Debugging: Display list of files in root folder

; remove .ZIP files from the array, these are not to be added to the archive
$sSearch = ".zip"
$noZips = 0
Do																		; loop through array until no more .zip files are found
	$iIndex = _ArraySearch($FileList, $sSearch, 0, 0, 0, 1)
	if @error Then
		;MsgBox(0, "Not Found", '"' & $sSearch & '" was not found in the array.')
		$noZips = 1														; search cannot find any files with .zip and will exit loop
	Else
		;MsgBox(0, "Found", '"' & $sSearch & '" was found in the array at position ' & $iIndex & ".")
		_ArrayDelete($FileList, $iIndex)								;search found file with .zip extension and removed it from the array
	EndIf
Until $noZips = 1
_ArrayDelete($FileList, 0)
;_ArrayDisplay($FileList,"$FileList")									; Debugging: Display list of files in root folder after zips removed

$folders = StringSplit ($dir,"\")										;find the name of the current working folder and strip out the path to generate a file name for the new zip
$folder = _ArrayPop($folders)

;MsgBox(64, "folder", "folder: " & $folder)

for $file in $FileList
runwait('zg -add "' & $folder & '.zip" C5 +"' & $file & '"')
Next
EndIf

EndFunc
