#include "_Base64.au3"
Local $TextIn, $file, $Base64Text, $TextOut, $type, $name, $fsize, $fsizeOrg, $filehand, $Wfilehand, $iTime, $tmp, $TimeEnd, $line, $line2, $out, $loc

;FIRST EXAMPLE basic encode and decode Base64
$TextIn = InputBox("Encode", "Enter String to Convert to base64")
If @error Then
Else
	;Encode the text, with no line breaks(faster)
	$Base64Text = _Base64Encode ($TextIn, False)
	MsgBox(0, "Result of string to base64", "Base64" & @CRLF & "->" & $Base64Text & "<-")
	
	;Decode the string
	$TextOut = _Base64Decode ($Base64Text)
	MsgBox(0, "Result of base64 to string", "String" & @CRLF & "->" & $TextOut & "<-")
EndIf

;SECOND EXAMPLE encode & decode a file
If MsgBox(260, "Warning", "This is a slow process! Please do not pick a file over 1024k" & @CRLF & "This will encode then decode any file" & @CRLF & "THIS WILL OVERWRITE FILES FROM PREVIOUS RUNS OF THIS PROGRAM") = 6 Then
	$file = FileOpenDialog("Base64 Encode->Decode->Compare File", "", "All (*.*)", 1)
	If @error Then
	Else
		$type = StringSplit($file, ".")
		$name = StringSplit($type[$type[0] - 1], "\")
		$name = $name[$name[0]]
		$type = $type[$type[0]]
		
		$fsize = FileGetSize($file)
		$fsizeOrg = $fsize
		$filehand = FileOpen($file, 16)
		$Wfilehand = FileOpen($file & '.base64', 18)
		
		$iTime = TimerInit()
		;Encode the file, with line breaks (Slower) and show progress (slower)
		$tmp = _Base64Encode (BinaryToString(FileRead($filehand, $fsize)), True, "File Size: " & $fsize & " ")
		$TimeEnd = Round(TimerDiff($iTime) / 1000, 3)
		
		FileWrite($Wfilehand, $tmp)
		FileClose($Wfilehand)
		MsgBox(0, 'Finished Encoding', 'Time: ' & $TimeEnd & ' seconds')
		
		
		$fsize = FileGetSize($file & '.base64')
		$filehand = FileOpen($file & '.base64', 16)
		$Wfilehand = FileOpen($file & '.original.' & $type, 18)
		$iTime = TimerInit()
		
		
		;Decode the file, show progress (slower)
		$tmp = _Base64Decode (BinaryToString(FileRead($filehand, $fsize)), "File Size: " & $fsize & " ")
		$TimeEnd = Round(TimerDiff($iTime) / 1000, 3)
		
		FileWrite($Wfilehand, $tmp)
		FileClose($Wfilehand)
		
		;Comparing Files
		If $fsizeOrg <> FileGetSize($file & '.original.' & $type) Then
			$tmp = "False"
		Else
			$filehand = FileOpen($file, 16)
			$Wfilehand = FileOpen($file & '.original.' & $type, 16)
			While 1
				$line = FileReadLine($filehand)
				If @error = -1 Then ExitLoop
				$line2 = FileReadLine($Wfilehand)
				If @error = -1 Then ExitLoop
				If $line = $line2 Then
					ContinueLoop
				Else
					$tmp = "False"
				EndIf
			WEnd
			$tmp = "True"
		EndIf
		
		MsgBox(0, 'Finished Decoding', 'Time: ' & $TimeEnd & ' seconds' & @CRLF & "Files are the same: " & $tmp)
	EndIf
EndIf

;Third EXAMPLE encode a picture directly into a html page
If MsgBox(260, "Warning", "This is a slow process! Please do not pick a file over 50k" & @CRLF & "This will encode a picture into a html page" & @CRLF & "The html file will will be appened if it all ready exists") = 6 Then
	$file = FileOpenDialog("Image To Html, Base64 Encoder", "", "Images (*.png;*.gif;*.jpg;*.jpeg;*.bmp;*tif;*.tiff)", 1)
	If @error Then Exit
	
	$type = StringSplit($file, ".")
	$name = StringSplit($type[$type[0] - 1], "\")
	$name = $name[$name[0]]
	$type = $type[$type[0]]
	
	$fsize = FileGetSize($file)
	$filehand = FileOpen($file, 16)
	$iTime = TimerInit()
	;Encode the file with no line breaks (Faster) and no progess bar (faster)
	$tmp = _Base64Encode (BinaryToString(FileRead($filehand, $fsize)), False, False)
	MsgBox(0, "Time Difference", 'Time: ' & Round(TimerDiff($iTime) / 1000, 3) & ' seconds')
	
	$out = '<img src="data:image/' & $type & ';base64,' & @CRLF & $tmp & @CRLF & '"/>'
	
	$loc = StringReplace($file, $name & "." & $type, "") & $name & "[" & $type & "].htm"
	FileWrite($loc, $out)
	
	MsgBox(0, "Done!", "File has been converted and saved as:" & @CRLF & @CRLF & $loc & @CRLF & @CRLF & "Use Firefox to view html page")
EndIf