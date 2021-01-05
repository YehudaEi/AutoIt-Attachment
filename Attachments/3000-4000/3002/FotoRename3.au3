; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.0
; Author:         Dan Merschi <danmero@gmail.com>
;
; Script Function:
;	Rename pictures from Olympus Digital Camera by date.
;   Original file name look like P1010001.jpg
;   Second character is: 1 to C in Hexadecimals (the month value)
;   Third & Forth character is the date: from 01 to 31
;	The last four caracters are the file serial name: 0001 to 9999
; ----------------------------------------------------------------------------
$var = FileSelectFolder("Select the picture folder.", "")
$dirLocation= $var & "\" 
$fileSearch = FileFindFirstFile($dirLocation & "P*.jpg")
$fileCount= 0
$s="_"
If $fileSearch = -1 Then 
    MsgBox(48, "Error", "No new picture on this folder" & @crlf & "Bye !")
    Exit 
EndIf
While 1  
		$oldFileName = FileFindNextFile($fileSearch) 
	If @error Then ExitLoop 
		$fullFileName = $dirLocation & $oldFileName
		$t = FileGetTime($fullFileName, 0, 0)
		If  $t[0] &$t[1] &$t[2] = 20020101 then
			; If file date is 2002/01/01 Camera clock error/ Set date modified
			$t =  FileGetTime($fullFileName, 1, 0) 
			$varOriginalCopy = "_a"
		ElseIf FileGetTime($fullFileName, 0, 1) < FileGetTime($fullFileName, 1, 1) Then
			;If dateModified > dateCreated Set dateModified/Copy
			$t =  FileGetTime($fullFileName, 0, 0) 		
			$varOriginalCopy = "_c"
		Else 
			$t =  FileGetTime($fullFileName, 1, 0) 
			$varOriginalCopy = "_M"
		EndIf
	$varTime = $t[0] & $s & $t[1] & $s & $t[2]		;Set Time Format
	$array=StringSplit($oldFileName,"")				;Split Old File Name
	$newFileName= $varTime & $s & $array[5] &$array[6] &$array[7] & _ 
	$array[8] & $varOriginalCopy & ".jpg"			;Create New File Name
	;Rename File
	FileMove($dirLocation & $oldFileName, $dirLocation & $newFileName,1)	
	$fileCount= $fileCount + 1	;Set Counter + 1
WEnd
	MsgBox (64,"File Renamed", "I rename " & $fileCount & " pictures for you !" & @CRLF & "Have a nice day !")	
; Close the search handle
FileClose($fileSearch)