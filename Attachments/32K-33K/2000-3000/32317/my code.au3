dim $FolderName = "C:\Documents and Settings\hnaveed\Desktop\Profiles"
Dim $FileCount = 0




ScanFolder($FolderName)

MsgBox(0, "Message", "The files has been updated") 
MsgBox(0,"Done","Folder Scan Complete.  Scanned " & $FileCount & " Files")


 
Func ScanFolder($SourceFolder)
    
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath

	$Search = FileFindfirstFile("*.pcf")

 
	While 1
		

		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		
		$FindText = "SDIUseHardwareToken=1"
		$ReplaceText = "SDIUseHardwareToken=0"
 
		
		$FileContents = FileRead($file)
		If StringRegExp( $FileContents, "SDIUseHardwareToken=0") Then
        MsgBox(0, "Oops", "Match")
		$FileContents = StringRegExpReplace($FileContents,$FindText,$ReplaceText)
		FileDelete($file)
		FileWrite($file,$FileContents)
    Else
        MsgBox(0, "Oops", "No match")
		If StringRegExp($FileContents, "SDIUseHardwareToken=0") Then
			exit  
		Else
			FileWriteLine($file,$ReplaceText)
		
			
		EndIf
		
    EndIf
		
	
		

 
	WEnd
 
	FileClose($Search)
	EndFunc




 
Func LogFile($FileName)
	FileWriteLine(@ScriptDir & "\FileList2.txt",$FileName)
	$FileCount += 1
	ToolTip($FileName,0,0)
EndFunc
