$filelist = FileFindFirstFile("*-TitleList.index")
If $filelist <> -1 Then	; -1 means no more files to read
	While 1		; Loop thru index files
		$file = FileFindNextFile($filelist) 	
		If @error Then ExitLoop
		$filein=FileOpen($file,0)
		$fileout = FileOpen($file & ".new",2)
		While 2 = 2							; loop thru records in the file
			$line = FileReadLine($filein)
			If @error = -1 Then 			; no more lines to read
				ExitLoop
			EndIf
			$array=StringSplit($line,"|"); lets not add delimiters we don't need
			If $array[0] < 4 Then
				$line = $line & "|"
			EndIf
			FileWriteLine($fileout,$line)
		Wend
		FileClose($filein)
		FileClose($fileout)
		FileDelete($file)
		FileMove($file & ".new",$file)
	WEnd
EndIf
FileClose($filelist)
MsgBox(0,"","Done")