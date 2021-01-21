;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Martin Burt (Accounting Systems)
;
; Script Function:
;   Copy oracle bacs file outputs into 1 file that is used by Ablany and then renames and moves the Orginal Oracle output files
;


; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "Oracle BACS File Convert", "This script will combine all Oracle BACS files outputs into " & Chr(13) & " once file for Albany.    Run?")


; Check the user's answer to the prompt 
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(4096, "Oracle BACS File Convert", "No files copied.  Bye!")
    Exit
EndIf


; Loop around until the user gives a valid "593L or 731L" answer
$bLoop = 1
While $bLoop = 1
    $text = InputBox("Oracle BACS Payment Entity", "Please type the Entity Of the Paying Unit ""593 or 731"" and click Yes")
    If @error = 1 Then
        MsgBox(4096, "Oracle BACS Cancel", "You pressed 'Cancel' - Bye!")
	Exit
    Else
        ; They clicked OK, but did they type the right thing?
        If $text <> "593" Then
		If $text <> "731" Then
		MsgBox(4096, "Oracle BACS Error", "You typed " & $text & " which is the wrong thing - try again!")
		Else
            	$bLoop = 0    ; Exit the loop - ExitLoop would have been an alternative too :)
		EndIf
	Else
	$bLoop = 0    	
        EndIf
    EndIf

;Call Functtion to check value entered is correct before copying files.
Call ("FunctCheckEntity")

WEnd


; Map X drive to Albany
DriveMapAdd("X:", "\\Uk01nt12\Bacs Files\AP\"&$text)
FileChangeDir("X:\Bacs Files\AP\"&$text)

; Get details of the mapping
MsgBox(0, "Drive X: is mapped to", DriveMapGet("X:"))


;Delete Paybacs file in main directory.  This is the last payment file created

$FilePathDel = DriveMapGet("X:") &"\Opaybacs" & $text & ".dat"
FileDelete($FilePathDel)


;Back Up new Oracle dat files
;Source is from Oracle with date and time stamp
$SourceOracleFilesDat = DriveMapGet("X:") &"\paybacs" & $text & "*.dat"

;Source oracle files are back up
$SourceFilesBck = DriveMapGet("X:") &"\*.bck"

;Source Oracle file combined into 1 file for Albany
$SourceAlbanyFilesDat = DriveMapGet("X:") &"\Opaybacs" & $text & ".dat"

;Copy file to back up
FileCopy($SourceOracleFilesDat, $SourceFilesBck,1)


;Combine Oracle file into 1 File

$sPath1 = "X:\Bacs Files\AP\" & $text & "\paybacs*.dat"
$sPath2 = "X:\Bacs Files\AP\" & $text & "\Opaybacs" & $text & ".dat"

msgbox (4,"Path check","Path copy from" & $sPath1 &  chr(13) & "Path copy to " & $sPath2)

Run ('@COMSPEC /X COPY "' & $sPath1 & '$sPath2', "", @SW_HIDE)

;Delete Oracle dat files
;FileDelete($SourceOracleFilesDat)



; Print the success message
MsgBox(496," Paybaces","Paybacs File Ready to transmit", )

; Finished!


;>>>>>>>FUNCTIONS

Func FunctCheckEntity()
;this function check with the user that they are sure they Entity enter is correct.
If $bLoop <1 Then
   ; Prompt the user to check answer entered
   $answer1 = MsgBox(4, "Oracle BACS File Convert"& $text, "Combine all Oracle BACS files for Entity " & $text & " for Albany." & Chr(13) & " Click OK to Run?")

   ; Check the user's answer to the prompt 
   ; If "No" was clicked (7) then exit the script
   If $answer1 = 7 Then
   MsgBox(4096, "Oracle BACS File Convert", "No files copied, Aborted!")
   Exit
EndIf 
EndIf
EndFunc




