#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Automate TestDirector Spreadsheet format

; Start and log into DTT
; Assumption - Open last model checkbox should be activated
; Assumption - The model should have been previously opened on the currently used machine
Run("C:\Program Files\Critical Logic\DTT.exe")
WinWaitActive("DTT Logon")
ControlClick("DTT Logon", "", "[CLASS:Edit; INSTANCE:1]")
ControlSend("DTT Logon", "", "[CLASS:Edit; INSTANCE:1]", "C:\Documents and Settings\Sean\Desktop\DTT Validation\Automation models\Automation_TestDirectorSpreadsheet.dtt")
Send("{ENTER}")

; Wait for DTT and model to open
; Assumption - The model being used should be the last opened model
; Assumption - The model has been generated
WinWaitActive("DTT - Functional Modeling")

; Open Reports menu
ControlClick("DTT - Functional Modeling", "", "[CLASS:ThunderRT6PictureBoxDC; INSTANCE:12]")
WinWaitActive("Reports")

ControlClick("Reports", "", "[CLASS:ThunderRT6OptionButton; INSTANCE:6]"); Activate TD Spreadsheet radio button
ControlClick("Reports", "", "[CLASS:ThunderRT6PictureBoxDC; INSTANCE:3]"); Trigger Reports button

WinWaitActive("QC/TD Spreadsheet")
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:9]"); Target Subject textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:9]", "A Subject"); Enter Subject
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:8]"); Target Test Name textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:8]", "Test@"); Enter TestName - Note that the test name should always end with "@"
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:7]"); Target Designer textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:7]", "The Designer"); Enter Designer
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:6]"); Target Status textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:6]", "The Status"); Enter Status
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:3]"); Target Function textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:3]", "A Function"); Enter Function
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]"); Target Creation Date textbox
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "01/01/1970"); Enter Date
ControlClick("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:5]"); Target the Description textarea
ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:5]", "A Description"); Enter Description

; Following code will be used to change the displayed tab textarea box, all 3 tabs are currently the same CLASS/INSTANCE so
; solution will be needed to specifically identify selection of the CLASS/INSTANCE without accidentally selecting an
; unexpected tab. Possibilities could be mouse position or tab then right button. Best solution would be for TEXT to be
; added to the screen for each individual tab.

; Section of code commented until solution found!

;Send("{RIGHT}"); Change tab of textarea
;ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:4]", "A Test Objective"); Enter Test Objective
;Send("{RIGHT}"); Change tab of textarea
;ControlSend("QC/TD Spreadsheet", "", "[CLASS:ThunderRT6TextBox; INSTANCE:1]", "A Comment")

ControlClick("QC/TD Spreadsheet", "", "[TEXT:Show Technical Description]"); Activate the Show Technical Description radio button

; If statements to determine if Checkboxes are activated, if activated then deactivate
If(ControlCommand("QC/TD Spreadsheet", "", "[TEXT:Create line for Actual Results]", "IsChecked", ""))Then(ControlClick("QC/TD Spreadsheet", "", "[TEXT:Create line for Actual Results]")EndIf
If(ControlCommand("QC/TD Spreadsheet", "", "[TEXT:Show Context Once]", "IsChecked", ""))Then(ControlClick("QC/TD Spreadsheet", "", "[TEXT:Show Context Once]")EndIf
If(ControlCommand("QC/TD Spreadsheet", "", "[TEXT:Show Effects in Description]", "IsChecked", ""))Then(ControlClick("QC/TD Spreadsheet", "", "[TEXT:Show Effects in Description]")EndIf
If(ControlCommand("QC/TD Spreadsheet", "", "[TEXT:Show Trace Points]", "IsChecked", ""))Then(ControlClick("QC/TD Spreadsheet", "", "[TEXT:Show Trace Points]")EndIf

; Trigger Export button and Save
; Assumption - If this script has previously been run then the .csv file should be deleted before attempting to run this script again
ControlClick("QC/TD Spreadsheet", "", "[TEXT:Export]")
WinWaitActive("Export TD Spreadsheet")
ControlClick("Export TD Spreadsheet", "", "[TEXT:&Save]")

; Run the report comparison tool - Code may be added or included to this script
