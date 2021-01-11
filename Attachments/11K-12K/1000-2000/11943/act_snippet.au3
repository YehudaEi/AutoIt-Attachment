#include <ActFieldConstants.au3>

$actdb = "c:/Qu.dbf" ;the name of the database to be opened

$sDate = ("11.11.2001")   ; to be used later 

;creates the act object.
$objACT = ObjCreate("ACTOLE.APPOBJECT")
If @error Then
     MsgBox(262192,"Woops!","Could not attach Act Object")
    Exit
EndIf
 
With $objACT
    .OpenDB ($actdb)   ;opens desired database
                         ; if login is required for script, autoit waits for login before resuming
    .Maximize ;Maximizes the screen
EndWith

;creates the contact object
$objActContact = $objACT.Views.Create (1, "CV")
$objActContact.MoveFirst  ;: alternatively:  First, Next, Last, Previous

$Id = $objActContact.GetCurrentId   ;  Getting the unique ID of the contact
MsgBox(262208,"Act Sample","Your UId is:" & $Id)
$objActContact.Goto($Id)   ; junping to the contact described by the unique ID, stored in $Id



;Accessing the "history"
;'Set Notes/History to be the active tab.
$objActContact.SetActiveTab("Notes/History")
;Create the Grid object.
$objActGrid = $objActContact.NotesHistory
;'Add a note. The Unique ID is returned in uid as a string.
$uid = $objActContact.AddNoteHistoryEx(100); adding an empty notice
;'Get the row number.
$RN = $objActGrid.GetRowNumber($uid)

$objActGrid.SetField($NHF_Text, $RN, "Dies ist EIN Test");Stores the string to field "$NFH_Text"
$objActGrid.SetField($NHF_UserTime, $RN , "10.10.98 8:00"); Storing Date and Time. European natation. Maybe the US-Version needs another format.


$objActContact.AttachFile("c:/myfile.txt") ;attaching a file to the history
										; also allows to specify a directory/ a programm to be displayed/executed

	
;Acessing the "activities"
;'Create a timeless Activity for 10 days from today
$objActContact.SetActiveTab("Activities")  ; activating register "Activities"
$objActGrid = $objActContact.Activities
$Auid = $objActContact.AddNewActivityEx ($Id , $sDate, 1, 1,"Send another introductory letter alongthwith Catalogues","30")


;Accessing the "database"
With $objActContact
    $Name = .GetField($CF_Name);gets field and stores it to variable $Name
    $Company = .GetField($CF_Company)
EndWith

;sleep(1000)
MsgBox(262208,"Act Sample","Hello " & $Name & @CRLF & "You Work For " & $Company)

