; project: ODBC Data Source Manual Setup Automation Script
; programmer: O'Ryan
; email: krypitol56@yahoo.com
; date: 20091016


; Prompt the user to run the script
MsgBox(4, "Begining Automation", "This will automate the manual process to  setup an ODBC Data Source.")

; Start the odbcad32.exe application
Run("odbcad32.exe")


;##############################################################
;       The First Form - "ODBC Data Source Administrator"
;##############################################################



; Wait for the odbcad32 become active - it is titled "ODBC Data Source Administrator"
WinWaitActive("ODBC Data Source Administrator")


; Now send Ctrl+D to press the `A&dd...` button
Send("!d")



;##############################################################
;           The Second Form - "Create New Data Source"
;##############################################################


; Wait for the Create New Data Source become active - it is titled "Create New Data Source"
WinWaitActive("Create New Data Source")


; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!
; !! 	This is the location where  a while loop needs to run, checking the curretly 
; !! 	selected item in the list box and if its not `Microsoft Visual FoxPro Driver` keep sending {DOWN 1}
; !!	until correct and then exit form;
; !! 		-OR-
; !! 	Gets the list items from the list box as a collection, and searches for the `Microsoft Visual FoxPro Driver`
; !! 	and then when it finds the index, and then presses {DOWN X}, X = index, and then exit form.
; !!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


; Select "Microsoft Visual FoxPro Driver" in the list box
Send("{DOWN 19}")

; Press enter to Press the `Finish` button to exit form
Send("{ENTER}")


;##############################################################
;         The Third Form - "ODBC Visual FoxPro Setup"
;##############################################################


; Wait for the ODBC Visual FoxPro Setup become active - it is titled "ODBC Visual FoxPro Setup"
WinWaitActive("ODBC Visual FoxPro Setup")

; Enter the Name of the ODBC Data Souce into the `Data Source Name:` text field
Send("test database")

; Navigate down to the `Path:` text field
Send("{TAB 3}")

; Enter the Path of the ODBC Database into the `Path:` text field
Send("C:\\EI\DATA\500\EI.DBC")

; Press enter to Press the `Ok` button
Send("{ENTER}")


;##############################################################
;      The Forth Form - "ODBC Data Source Administrator"
;##############################################################

; Wait for the odbcad32 become active - it is titled "ODBC Data Source Administrator"
WinWaitActive("ODBC Data Source Administrator")

MsgBox(4, "Automation Complete", "The Automation has completed, the script will now close obdcad32.exe.")

; Now quit by sending a "close" request to the odbcad32.exe
WinClose("ODBC Data Source Administrator")


