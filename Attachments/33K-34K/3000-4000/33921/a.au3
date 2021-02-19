;used to open an application
Run("C:\Program Files\DataFlux\dfPower Tools\8.0\dbmswin8.exe")
;used to make sure the window appears with 4 buttons
WinWaitActive("Welcome to dfPower DBMS/Copy!")
;This is usd to select Open Batch
Send("O")
;used to specify the location of file
Send("C C:\Users\eSpace\Desktop\Studies\Newlink\prg\dov.prg")
Send("{ENTER}")
;used to open the File menu
Send("{ALT}+F")
;used to select RUN option in file menu
Send("RUN")
;used to wait unit the processing window opens up
WinWaitActive("Processing","",30)
;used to make sure the processing is complete and the main window becomes active
WinWaitActive("dfPower DBMS/Copy for Windows V8.0.0","",30)
WinWaitActive("dfPower DBMS/Copy for Windows V8.0.0","",30)
Send("{ALT}+F")
Send("Op")
Send("C:\Users\eSpace\Desktop\Studies\Newlink\prg\ds.prg")
Send("{ENTER}")
Send("{ALT}+F")
Send("RUN")
WinWaitActive("Processing","",30)
WinWaitActive("dfPower DBMS/Copy for Windows V8.0.0","",30)
WinWaitActive("dfPower DBMS/Copy for Windows V8.0.0","",30)
Send("{ALT}+F")
Send("Op")
Send("C:\Users\eSpace\Desktop\Studies\Newlink\prg\ex.prg")
Send("{ENTER}")
Send("{ALT}+F")
Send("RUN")
WinWaitActive("Processing","",30)
WinWaitActive("dfPower DBMS/Copy for Windows V8.0.0","",30)
