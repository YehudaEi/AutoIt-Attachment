; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

$file = FileOpen("Input_script.au3", 0)

; Check if file opened for reading OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

$file1 = FileOpen("Main_script.au3",1)

If $file1 = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf


$lib_path="C:\test\lib\"
$extn=".au3"

$linenum=1

While $linenum <=9
$file2 = FileReadLine("C:\test\scripts\Input_script.au3",$linenum)

MsgBox(0, "Line read:", $file1)

If StringInStr($file2,"ait_") Then

	$search = FileFindFirstFile($lib_path & $file1 & $extn)  

	; Check if the search was successful
		If $search = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit(1)
		EndIf
	While 1
		$file3 = FileFindNextFile($search) 
		If @error Then Exitloop

		MsgBox(4096, "File:", $file3)
	WEnd

	; Close the search handle
	FileClose($search)

	$temp=$lib_path & $file3
	
	MsgBox(0, "filepath", $temp)

	$file4=FileOpen($lib_path & $file2,0)

	If $file4 = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
	EndIf

	$file5= FileRead("$lib_path & $file3,FileGetSize($lib_path & $file3)")
	FileWrite($file1, @CR & @LF & $file5)
	
	FileClose($temp)
EndIf

FileWrite($file1, @CR & @LF & $file2)

$linenum=$linenum+1
WEnd

FileClose($file1)
FileClose($file)
