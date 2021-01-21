$search = FileFindFirstFile("*.*")  

; Check if the search was successful
If $search = -1 Then
    MsgBox(0, "Error", "No files/directories matched the search pattern")
    Exit
EndIf

While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop
	
    $file1 = FileOpen("c:\list.txt", 2)
	FileWriteLine($file1, $file & @CRLF)
	FileClose($file1)
	Run ("iexplore c:\list.txt")

	;If( $file <> "list.au3") Then 
	;	MsgBox( 4096, "File:" & $file , $file )
	;EndIf
WEnd

; Close the search handle
FileClose($search)