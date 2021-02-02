; Shows the filenames of all files in the current directory.
$search = FileFindFirstFile("Y:\IN\TEST\*.*")  

; Check if the search was successful
If $search = -1 Then
	MsgBox(0, "Error", "No files/directories matched the search pattern")
	Exit
EndIf

While 1
	$file1 = FileFindNextFile($search) 
	If @error Then ExitLoop
	$filename = StringLeft($file1,4)

if $filename = "HMRC" Then
	; Read in lines of text until the EOF is reached
	$file = FileOpen("Y:\IN\TEST\" & $file1, 0)

	$line = FileReadLine($file,4)
	$payeref1 = StringMid($line, 11, 10)
	$payeref =StringStripWS($payeref1 , 2)
	FileClose($file)
	FileMove("Y:\IN\TEST\" & $file1, "Y:\IN\TEST\"& $payeref &"-HMRC-EDI-DATA.gff",9)
	
	EndIf

WEnd

; Close the search handle
FileClose($search)
