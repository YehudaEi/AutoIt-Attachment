Dim $id
Dim $pass
Dim $chars
Dim $pathOfBackup
Dim $pathSave
$file = FileOpen("C:\Documents and Settings\Administrator\My Documents\DevTrack_backup_config.txt", 0)

; Check if file opened for reading OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit        
EndIf

; Read in lines of text until the EOF is reached
While 1
	;$line = FileReadLine($file)
	
	If @error = -1 Then ExitLoop
		$line = FileReadLine($file,1)
		$chars = FileRead($file, 2)
		MsgBox(0,"read",$chars)
		If $chars = "//" Then
		EndIf
		
		$line = FileReadLine($file, 2)
		$chars = FileRead($file, 5)
		MsgBox(0,"read1",$chars)
		If $chars = "Id = " Then
			$id = $line
		EndIf
		
			$line = FileReadLine($file, 3)
			$chars = FileRead($file, 7)
			MsgBox(0,"read2",$chars)
		If $chars = "Pass = " Then
			$pass = $line
		EndIf
			$line = FileReadLine($file, 6)
			$chars = FileRead($file, 6)	
			MsgBox(0,"read3",$chars)
		If $chars = "Path =" Then
			$pathOfBackup = $line
		EndIf	
			$line = FileReadLine($file, 9)
			$chars = FileRead($file, 1)	
			MsgBox(0,"read4",$chars)
		If $chars = "=" Then
			$pathSave = $line
		EndIf	
			
	
	MsgBox(0,"s", $pathSave)
	MsgBox(0,"back", $pathOfBackup)
	MsgBox(0,"bak", $pass)
	MsgBox(0,"ba", $id)
WEnd