;=====================================================================
; SQL Based Instant Messenger
;  Store all messages for security reasons
;  display a set amount of messages
;  Track in DB, when it was posted, date, time, who posted, 
;    
;       >Created by MikeOsdx<
;---------------------------------------------------------
;Database setup: have the DB be NT authentication.
; Script was written for SQL 2005 Trial edition.
;
; Users Table:  HDcommUsers
;	Fields			Type					Notes:
;	UserName		varchar(50), not null	This will store the @UserName of the user that is currently logged into network, also add group names as users
;	Display 		varchar(50), not null	How many message they want displayed at a time
;  	Groups			varchar(max), null		This will be any groups that the users is assigned to
;
;
; Messages Table:  HDcomm
;	Fields			Type					Notes:
;	TimeStamp		varchar(18), not null	This will store the time stamp of when the message was created
;	Creator			varchar(50), not null	This will store the @Username of the logged on user that wrote this message
;	Recipient		varchar(50), not null	This will store the @Username or group that the message is being sent to
;	Message			text, null				This will store the actual message that is being sent
;	Display			varchar(3), not null	This should always be Yes.  if set to No then the message will not be displayed to anyone.  use instead of deletion
;	ConversationID	PK, Numeric(18,0), not null		This self generating number will be used to sort the messages
;
;
; Some sample groups could be Everyone, Management, Technical, Floor 14,  Right now I have the code for a max of 8 groups an individual can be assigned to
;  All users must be assigned to at least one group.
;

#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt("RunErrorsFatal", 0)
$oMyError = ObjEvent("AutoIt.Error", "COMErrFunc")


Dim $MyGroups = "", $DisplayCount = "10", $UserCmboDta = "", $NewData, $Identity = 0, $LastID = 0, $CurrentDisplay  = ""


;Connect into the database on launch of the application
$sqlCon = ObjCreate("ADODB.Connection")
$sqlCon.Open("Provider=SQLOLEDB;Server=QAHDCOMM;Trusted_Connection=yes;")
if @error Then
	MsgBox(0, "ERROR", "Failed to connect to the database")
	Exit
EndIf
;The database will be left connected until the application closes

;Create a new Recordset to the Database
$sqlUser = ObjCreate ("ADODB.Recordset")
if not @error Then
	;Launch a connection into the HDcommUsers table to retrieve users and 
	; the individuals information, Order alphabetically by UserName
	$sqlUser.open("Select * From HDcommUsers Order by UserName", $sqlCon)
	if not @error Then
		With $sqlUser
			;If there are records found then continue
			If .RecordCount Then
				;Loop until the end of file
				While Not .EOF
					;Retrieve the UserName from the Database
					$UserName = .Fields('UserName').value
					;if the Username is the current user than retrieve the
					; DisplayCount and what Groups they are assigned to
					if $UserName = @UserName then 
						$DisplayCount = .Fields('DisplayCount').Value
						$MyGroups = .Fields('Groups').Value
					EndIf
					;Add this user to the list
					$UserCmboDta = $UserCmboDta & "|" & $UserName
					.MoveNext
				WEnd
			EndIf
		EndWith
	EndIf
	;Close this RecordSet
	$sqlUser.Close
EndIf

;Split the groups this user is assigned to into an array.
if $MyGroups <> "" then	$MyGroupsA = StringSplit(StringStripWS($MyGroups, 8), ",")

;Generate the GUI window that will be displayed to the end user
$IMgui = GUICreate("", 330, 464, 192, 125, -1, $WS_EX_TOPMOST)

;Custom Image Title bar.  the current color scheme was used to match this image.
;~ GUICtrlCreatePic("Titlebar1.jpg", 0, 0, 0, 0)

;This is the Edit box that will display all of the current messages
$Messages = GUICtrlCreateEdit("", 8, 55, 314, 228, $ES_MULTILINE + $ES_READONLY + $WS_VSCROLL, $WS_EX_CLIENTEDGE)
;This is the edit box that you use to write a new message
$NewMsg = GUICtrlCreateEdit("", 8, 312, 314, 105, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL, $WS_EX_CLIENTEDGE)
;This ComboBox will store all Users and Groups
$Users = GUICtrlCreateCombo("", 50, 428, 145, 21)
;Add the Users and Groups to the ComboBox
GUICtrlSetData(-1, $UserCmboDta, "")
GUICtrlCreateLabel("To:", 18, 430, 20, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 9, 600)
;The Send button
$btnSend = GUICtrlCreateButton("Send", 220, 428, 89, 25)
GUICtrlCreateLabel("New Message", 8, 296, 72, 14)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("Current Messages", 8, 40, 89, 14)
GUICtrlSetColor(-1, 0xFFFFFF)
GUISetBkColor(0x0B3A8B, $IMgui)
GUICtrlSetBkColor($Messages, 0x009FC5)

;Launch an initial retrevial of messages
if Not _RetrieveMessages() Then
	MsgBox(0, "ERROR", "Error, Unable to retrieve the messages")
	Exit
EndIf
;Display the GUI window
GUISetState(@SW_SHOW)
;Enable the Retrieval of messages function to launch every 1/2 second
AdlibEnable("_RetrieveMessages", 500)
;loop to wait for a button to be clicked on the GUI
While 1
	$msg = GuiGetMsg()
	Select
	;The GUI was closed
	Case $msg = $GUI_EVENT_CLOSE
		;Close the SQL Database connection
		$sqlCon.Close
		;Set the DB variable to Null
		$sqlCon = ""
		;Exit the loop closing the program
		ExitLoop
		
	;The Send button is clicked
	Case $msg = $btnSend
		;Launch the _CreateMessage() Function
		_CreateMessage()
		
	Case Else
		;Just a filler in case an unexpected message is encountered
	EndSelect
WEnd
Exit


;Function used to create a new message
Func _CreateMessage()
	;Specifiy the fields that we are going to update in the Database
	$sqlfields = "Recipient, Display, Creator, TimeStamp, Message"
	;Get who the message is being sent to
	$newReciepient = GUICtrlRead($Users)
	;if the To is not empty than continue
	if $newReciepient <> "" Then
		;AutoSet Display to Yes
		$NewDisplay = "Yes"
		;AutoSet the Creator as the current User
		$newCreator = @UserName
		;AutoSet the TimeStamp with MM/DD/YY HH:MM
		$newTimeStamp = @MON & "/" & @MDAY & "/" & StringRight(@YEAR, 2) & " " & @HOUR & ":" & @MIN
		;Retreive the text of the new message that was typed in
		$newMessage = GUICtrlRead($NewMsg)
		;put all the data together into the sqldata string
		$sqldata = "'" & $newReciepient & "', '" & $NewDisplay & "', '" & $newCreator & "', '" & $newTimeStamp & "', '" & $newMessage & "'"
		;Execute the SQL command string to populate the database with the above information
		$sqlCon.Execute ("INSERT INTO HDcomm(" & $SQLFields & ") Values (" & $SQLData & ")")
		;if there were no errors then continue
		If Not @error Then
			;Retrieve the current messages then clear the New Message edit box
			if _RetrieveMessages() Then	GUICtrlSetData($NewMsg, "")
			;Close this function as successfull
			return 1
		Else
			;If there was an error display this message
			MsgBox(0, "ERROR", "Unable to add the new message")
			;Close this function as Errored
			Return 0
		EndIf
	Else
		;If the ComboBox was empty then throw this message
		MsgBox(0, "Error", "Please select a recipient from the To: combo box")
		;Close this function as Errored
		return 0
	EndIf
EndFunc


;Function used to retrieve the current messages
Func _RetrieveMessages()
;Clears and sets the CurrentMessages variable
$CurrentMessages = ""
;Create a new Recordset on the Database
$sqlRs = ObjCreate ("ADODB.Recordset")
;If there is no error then continue
if not @error Then
	;Pull messages assigned to the current user.
	;This case statement will retrieve messages assigned to up to 8 groups
	; Every user must be assigned to at least one group.
	Select
	Case $MyGroupsA[0] = 1
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' Order by ConversationID DESC", $sqlCon)
	
	Case $MyGroupsA[0] = 2
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' Order by ConversationID DESC", $sqlCon)

	Case $MyGroupsA[0] = 3
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' Order by ConversationID DESC", $sqlCon)
	
	Case $MyGroupsA[0] = 4
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' or Recipient = '" & $MyGroupsA[4] & "' Order by ConversationID DESC", $sqlCon)
	
	Case $MyGroupsA[0] = 5
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' or Recipient = '" & $MyGroupsA[4] & "' or Recipient = '" & $MyGroupsA[5] & "' Order by ConversationID DESC", $sqlCon)
	
	Case $MyGroupsA[0] = 6
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' or Recipient = '" & $MyGroupsA[4] & "' or Recipient = '" & $MyGroupsA[5] & "' or Recipient = '" & $MyGroupsA[6] & "' Order by ConversationID DESC", $sqlCon)
	
	Case $MyGroupsA[0] = 7
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' or Recipient = '" & $MyGroupsA[4] & "' or Recipient = '" & $MyGroupsA[5] & "' or Recipient = '" & $MyGroupsA[6] & "' or Recipient = '" & $MyGroupsA[7] & "' Order by ConversationID DESC", $sqlCon)
		
	Case $MyGroupsA[0] = 8
		$sqlRS.open("Select TOP " & $DisplayCount & " * From HDcomm Where (Display = 'Yes' and Creator = '" & @UserName & "') or Recipient =  '" & @UserName & "' or Recipient = '" & $MyGroupsA[1] & "' or Recipient = '" & $MyGroupsA[2] & "' or Recipient = '" & $MyGroupsA[3] & "' or Recipient = '" & $MyGroupsA[4] & "' or Recipient = '" & $MyGroupsA[5] & "' or Recipient = '" & $MyGroupsA[6] & "' or Recipient = '" & $MyGroupsA[7] & "' or Recipient = '" & $MyGroupsA[8] & "' Order by ConversationID DESC", $sqlCon)
	EndSelect
		With $sqlRS
			;If there are records found then continue
			If .RecordCount Then
				;Loop until the end of file
				While Not .EOF
					;Retrieve data from the following fields
					$Reciepient = .Fields('Recipient').Value
					$Display = .Fields('Display').Value
					$Creator = .Fields('Creator').Value
					$TimeStamp = .Fields('TimeStamp').Value
					$RowMessage = .Fields('Message').Value
					$ConversationID = .Fields('ConversationID').Value
					;Put all the messages into one Variable
					$CurrentMessages = $Creator & " - " & $TimeStamp & ":  " & $RowMessage & @CRLF & "------------------------------------" & @CRLF & $CurrentMessages
					.MoveNext
				WEnd
			EndIf
		EndWith
		;Close this RecordSet
		$sqlRs.close
		;If the messages that were just retrieved different than what is currently displayed then continue
		if $CurrentMessages <> $CurrentDisplay Then 
			;Set the Messages edit box with the newly retieved messages
			GUICtrlSetData($Messages, $CurrentMessages)
			;Set the new messages as the CurrentDisplay to match for the next loop of this function
			$CurrentDisplay = $CurrentMessages
			;Move the current messages edit box to the bottom to view the new messages
			_GUICtrlEditLineScroll ($Messages, 0, _GUICtrlEditGetLineCount($Messages))
			;If there are new messages then make sure the window is activated.
			if not WinActive($IMgui, "") Then WinActivate($IMgui, "")
		EndIf
		;Close this function as Successfull	
		return 1
	EndIf
;If there was an error creating the Recordset then close this function as Errored
return 0
EndFunc


