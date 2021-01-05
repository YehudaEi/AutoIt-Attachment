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
If $fileSearch = -1 Then 
    MsgBox(0, "Error", "No new picture on this folder" & @crlf & "Bye !")
    Exit 
EndIf
While 1  
		$oldFileName = FileFindNextFile($fileSearch) 
	If @error Then ExitLoop 
		$array=StringSplit($oldFileName,"")
			If $array[2]="a" then
				$array[2]="0"
				$array[1]="1"
			ElseIf $array[2]="b" then
				$array[2]="1"
				$array[1]="1"
			ElseiF $array[2]="c" then
				$array[2]="1"
				$array[1]="1"
			Else
				$array[1]="0"
			EndiF		
	$newFileName= @YEAR & $array[1] & $array[2] & $array[3] & $array[4] &"_M" &$array[5] &$array[6] &$array[7] &$array[8] & ".jpg"
	MsgBox (0,"",$dirLocation & $oldFileName & @cr & $dirLocation & $newFileName)
	;FileMove($dirLocation & $oldFileName, $dirLocation & $newFileName,1)
WEnd
; Close the search handle
FileClose($fileSearch)