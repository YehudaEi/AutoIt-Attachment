; Determine workgroup and shift  (These are hardcoded here but can be determined any way you want)
Local $workgroupName = _WorkGroup()
Local $shift = _Time()

; Build header to search the text file for
Local $contactHeader = $workgroupName & $shift

; Declare variable to hold the body of the contact info to display
Local $contactBody = ""

; Create file handle
Local $file = FileOpen(@DesktopDir & "\ContactInfo.txt", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Read in lines of text until the EOF is reached
While 1
    ; Read line
	Local $line = FileReadLine($file)
    ;Handle Error
	If @error = -1 Then ExitLoop
    
	; search for workgroup header
	if $line = $contactHeader then
	
		; Read next line
		$line = FileReadLine($file)
		
		; Build contact info body until terminator is reached
		Do 		
			; Add current line to contact body plus a carriage return ASCII code 
			;   so that a new line begins next time through the loop
			$contactBody = $contactBody & $line & chr(13)
			; Read next line
			$line = FileReadLine($file)
		
		Until $line = ";"
	
		; Exit while loop to read file
		ExitLoop
	
	EndIf
	
WEnd

; Close file
FileClose($file)

; Populate label for message box
Local $contactString = "Workgroup: " & _WorkGroup() & chr(13)
$contactString = $contactString & "Shift: " & _Time() & chr(13) & chr(13)
$contactString = $contactString & $contactBody

; Display message box
MsgBox(4096, "Contact Info", $contactString)

Func _Time()
	Local $AMPM, $hour
	If @HOUR <= 05 Then
        $hour = ("Night")
	ElseIf @hour >= 18 Then
		$hour = ("Night")
	ElseIf
		$hour = ("Day")
    EndIf
    Return $hour
EndFunc ;==>_Time

Func _WorkGroup()
	Local $AMPM, $hour
	If @HOUR >= 02 And @HOUR <=11 Then
        $hour = ("Workgroup2")
	ElseIf @HOUR >= 03 And @HOUR <= 19  Then
		$hour = ("Workgroup3")
	ElseIf @HOUR >= 23 And @HOUR <= 08 Then
		$hour = ("Workgroup1")
    EndIf
    Return $hour
EndFunc ;==>_Time

