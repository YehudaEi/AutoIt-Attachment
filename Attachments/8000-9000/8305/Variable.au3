;Create a Varirable
;Prompt for Serial Number
;Search if the File Exist
;If found, replace
;If not found, create one
;Create a log file with Serial Number as the File Name
;Open log and Print
;Close when done.

;Ser variable
$var = EnvSet("snum", "Serial Number")
;Prompt User to Enter Serial Number
$var = InputBox("Get Serial Number", "Please Type or Scan Serial Number, click OK")
;Search for File on Directory
If FileExists("V:"& "\" & ($var) & ".log" )Then 
$answer = MsgBox(4, "File Already Exist", "Do you want to replace it?") 
;If answer is yes to replace to create
;if answer is no to create one	
If $answer = 7 Then
;Create the file or over-write	
    $file = Fileopen("V:"& "\" & ($var) & ".log", 2)
	EndIf
Else
;messeage the user that file has been created
	MsgBox(4096, "Good Job", "The Serial Number has been Crated")       
;    EndIf
;command here to open file and printed.
;command here to close all windows.
EndIf



