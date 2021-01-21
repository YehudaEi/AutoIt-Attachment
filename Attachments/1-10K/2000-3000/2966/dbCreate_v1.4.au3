#cs
	File:		dbCreate-v?.au3
	
	HISTORY:
	Date	      	Version	Description
	---------------	-------	--------------------------------------------------------------------------------------------
	21/Jun/2005		1.0.0	First created
	21/Jun/2005		1.0.0	First Release
	22/Jun/2005		1.1		First design GUI interface
	23/Jun/2005		1.2		Change the GUI by added child windows and setting up sections.	
	24/Jun/2005		1.3		Added Clear Button to clear fields of data
							Added Default Button setting a predefined set of values
	---------------------------------------------------------+---------------------------------------------------------
	Copyright© John-Paul. All rights reserved.
	---------------------------------------------------------+---------------------------------------------------------
#ce
#include <GUIConstants.au3>
#include <Date.au3>
#include <String.au3>

Dim $Version = " v1.3"
Dim $Title = "Avalanche db-Manager"
Dim $g_szVersion = $Title & $Version
Dim $W_HEIGHT = 458, $W_WIDTH = 555, $FONTWEIGHT = 400, $FONTSELECTED[9]

opt("TrayIconHide", 1)          ;0=show, 1=hide tray icon

; Check if we are running
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)

; PREDEFINED VARIABLES
$ScriptDir = @ScriptDir
$VRScript = @ScriptName
$ScriptFull = @ScriptFullPath
;---------------------------------------------------------+---------------------------------------------------------
; HERE WE COLLECT THE CURRENT DATE AND TIME VALUE.
Func _today()  ;Return the current date in dd.mm.yyyy form
	return (@MDAY & "." & @MON & "." & @YEAR)
EndFunc   ;==>_today

Func _time()  ;Return the current time in hh.mm form
	return (@HOUR & "." & @MIN)
EndFunc   ;==>_time

Global $OldSec = @SEC; Added: 17/June/2005 - Used for clock in GUI
Global $OldMin = @MIN; Added: 17/June/2005 - Used for control GUI refresh
;---------------------------------------------------------+---------------------------------------------------------

;_Main()

;---------------------------------------------------------+---------------------------------------------------------
; MAIN GUI
;Func _Main()

; Header label and size
$MAIN_WINDOW = GUICreate($TITLE, $W_WIDTH, $W_HEIGHT)

;==================================================================
; create the Header child window
;==================================================================
$HEADER_WINDOW = GUICreate("Header ID", $W_WIDTH, 52, 0, 0, $WS_CHILD + $WS_DLGFRAME, -1, $MAIN_WINDOW)

; make title label and comment description
GUISetFont(14, 400, 0, "Verdana")
GUICtrlCreateLabel("Create && Delete Database", 161, 5, 240)
GUISetFont(8.5, 400, 0, "Verdana")
GUICtrlCreateLabel("Avalanche single user Med-DB deployment utility", 137, 30, 280)
GUICtrlSetColor(-1, 0xff9900)

;==================================================================
; create the Data child window
;==================================================================
$DATA_WINDOW = GUICreate("DATA WINDOW", $W_WIDTH, 230, 0, 0, $WS_CHILD + $WS_DLGFRAME, -1, $MAIN_WINDOW)
	
; Time details
GUISetFont(8.5, 400, 0, "Verdana")
$_StartTimeGlobal = GUICtrlCreateLabel("Time : 00:00:00", 435, 59)
	
;frame and title around the main fields of information
GUICtrlCreateGroup(" db Data Entry  ", 15, 65, 520, 155)   ; x, y, w, h
	
; Label Names
; Placed together to allow for correct font formatting, if seperate GUI fails to display correctly
GUISetFont(8.5, 400, 0, "Verdana")
GUICtrlCreateLabel("Server Name", 30, 93)
GUICtrlCreateLabel("Database Name", 30, 123)
GUICtrlCreateLabel("User ID", 30, 153)
GUICtrlCreateLabel("Password", 30, 183)
	
; Fields
GUISetFont(8.5, 400, 0, "Verdana")
$sServerName = GUICtrlCreateInput("Server Name", 160, 90, 135, 20, $ES_UPPERCASE + $WS_TABSTOP)
GUICtrlSetTip(-1, "The server you wish to connect to.")
GUICtrlSetColor(-1, 0x4B0082)
$sDatabaseName = GUICtrlCreateInput("Database Name", 160, 120, 135, 20, $WS_TABSTOP)
GUICtrlSetTip(-1, "The database to create/delete.")
GUICtrlSetColor(-1, 0x4B0082)
$sUserID = GUICtrlCreateInput("Admin ID", 160, 150, 135, 20, $WS_TABSTOP)
GUICtrlSetTip(-1, "Logon to SQL server as DBA.")
GUICtrlSetColor(-1, 0x4B0082)
$sPasswordID = GUICtrlCreateInput("Admin Password", 160, 180, 135, 20, $WS_TABSTOP)
GUICtrlSetTip(-1, "Password required to logon to SQL server.")
GUICtrlSetColor(-1, 0x4B0082)
	
; BUTTONS - Create, Delete, Add Tables, Exit
$btnCreate = GUICtrlCreateButton("&Create database", 350, 88, 130, 23, $BS_DEFPUSHBUTTON)
GUICtrlSetTip($btnCreate, "Create a new database")
$btnDelete = GUICtrlCreateButton("&Delete database", 350, 109, 130, 23)
GUICtrlSetTip($btnDelete, "Delete an existing database")
$btnAddTables = GUICtrlCreateButton("&Add Tables", 350, 131, 130, 23)
GUICtrlSetTip($btnAddTables, "Add tables to new or existing database")
$btn_Clear = GUICtrlCreateButton("C&lear", 350, 156, 65, 23)
GUICtrlSetTip($btn_Clear, "Clear ALL the fields")
$btn_Default = GUICtrlCreateButton("De&fault", 415, 156, 65, 23)
GUICtrlSetTip($btn_Default, "Use predefined default values")
$btnExit = GUICtrlCreateButton("E&xit", 350, 178, 130, 23)
GUICtrlSetTip($btnExit, "Quit the program")

;==================================================================
; create the Tabs child window
;==================================================================
$TABS_WINDOW = GUICreate("TABS WINDOW", $W_WIDTH, 454, 0, 0, $WS_CHILD + $WS_DLGFRAME, -1, $MAIN_WINDOW)

; TAB
$TAB = GUICtrlCreateTab(15, 250, 520, 195)

GUICtrlCreateTabItem("Help Menu")
Dim $Our_Light = 0xeeff00
GUICtrlSetBkColor($TAB, $Our_Light)
GUISetFont(9, 700, 0, "Verdana")
GUICtrlCreateLabel("System Requirements", 205, 285, 180, 20)
GUICtrlSetColor(-1, 0x000099)

GUISetFont(8.5, 400, 0, "Verdana")
$txt1Text = GUICtrlCreateEdit("", 45, 310, 460, 105, $WS_VSCROLL + $WS_DLGFRAME + $ES_MULTILINE + $ES_READONLY + $SS_SUNKEN )
GUICtrlSetData ($txt1Text,"For the successful use of this application the following dependencies (software) must be installed on your system." _
				& @CRLF & @CRLF & "Microsoft .NET Framework 2.0" _
				& @CRLF & "Microsoft SQL 2005 Server Express Edition" _
				& @CRLF & @CRLF & "Use the field help Tabs to better guide you and help you understand the way this program works." _
				& @CRLF & @CRLF & "The above listed dependencies have been used during the creation of this program and therefore I can not comment on any other applications that may or may not be able to be used in conjunction with this program. I am referring to the full blown version of Microsoft SQL 2005 Server, Microsoft SQL 2000 Server or MSDE 2000." _
				& @CRLF & @CRLF & "I suspect however that all these are capable of being used in conjunction with this program.")
GUICtrlCreateTabItem("")    ; end tabitem definition

GUICtrlCreateTabItem("Server field")
GUISetFont(8.5, 400, 0, "Verdana")
$txt2Text = GUICtrlCreateEdit("", 45, 290, 460, 125, $WS_VSCROLL + $WS_DLGFRAME + $ES_MULTILINE + $ES_READONLY + $SS_SUNKEN )
GUICtrlSetData ($txt2Text,"Server Name Field" _
				& @CRLF & @CRLF & "Enter the name of your SQL server e.g. DELL\LAPTOP (not a /)." _
				& @CRLF & @CRLF & "In the above example DELL denotes the network server followed by the \ then LAPTOP denotes our local PC or Laptop." _
				& @CRLF & @CRLF & "In our instance we are using a local server based on local name not a network server or SQL Server located on another machine. You can identify the local server in several ways." _
				& @CRLF & @CRLF & "One way is to go to the Control Panel and select System, then select the Computer Name tab. Now use the name shown next to Full computer name this is the local PC ID Name and name used by Microsoft SQL 2005 (which we are using at this time)." _
				& @CRLF & @CRLF & "A second way is to start the SQL Server Configuration Manager which was installed during the installation process of Microsoft SQL Server 2005 Express Edition, select the SQL Server 2005 Services group, and select the SQL Server (MSSQLSERVER) item, which is the old MSDE 2000 Manager and double click on it to open up the properties. Now select the Service tab, and listed here you will find under Host Name the server e.g. MY_COMPUTER." _
				& @CRLF & @CRLF & "Not having a server I am unable to provide the accurate process for SQL Server identification at this time.")
GUICtrlCreateTabItem("")    ; end tabitem definition

GUICtrlCreateTabItem("Database name field")
GUISetFont(8.5, 400, 0, "Verdana")
$txt3Text = GUICtrlCreateEdit("", 45, 290, 460, 125, $WS_VSCROLL + $WS_DLGFRAME + $ES_MULTILINE + $ES_READONLY + $SS_SUNKEN )
GUICtrlSetData ($txt3Text,"Database Name Field" _
				& @CRLF & @CRLF & "CREATING" _
				& @CRLF & "Enter the name of the database you wish to create e.g. mpdata (Medical Practice Data)." _
				& @CRLF & @CRLF & "In the above example 'mpdata' denotes the default database we have hard coded and wish to create, if however you wish to use another name you can do so instead of using the default." _
				& @CRLF & @CRLF & "Note that changing the name does not change the fields and criteria we create, as this is hard coded into this program." _
				& @CRLF & @CRLF & "DELETING" _
				& @CRLF & "If the database has already been created and you wish to delete it you can do so by placing the name of the database here e.g. mpdata." _
				& @CRLF & @CRLF & "Any database that exists in MS SQL 2005 Express Edition and possibly SQL Server 2005 can be deleted by placing its name in this field and using the Delete option. As the original source for this program was using MSDE 2000 it may also delete databases in MSDE 2000. though I have not used MSDE 2000 so can not accurately say that it does." _
				& @CRLF & @CRLF & "CAUTION: Before deleting any database ensure there is a backup taken." _
				& @CRLF & @CRLF & "This program does not address this issue so you may wish to either do a straight copy of the DB or use a third party application like MSDE Manager from Vale Software or Teratrax Database Manager from Teratrax Inc. Both programs have free trial periods to evaluate them and are fully working versions. It is recommened to use one of these applications or another SQL manager to backup your databases." _
				& @CRLF & @CRLF & "At the time of building this application both programs work with MS SQL 2005 Express Edition.")
GUICtrlCreateTabItem("")    ; end tabitem definition

GUICtrlCreateTabItem("User ID field")
GUISetFont(8.5, 400, 0, "Verdana")
$txt4Text = GUICtrlCreateEdit("", 45, 290, 460, 125, $WS_VSCROLL + $WS_DLGFRAME + $ES_MULTILINE + $ES_READONLY + $SS_SUNKEN )
GUICtrlSetData ($txt4Text,"User Name Field" _
				& @CRLF & @CRLF & "Enter the name of the administrator account holder e.g. sa (System Administrator)." _
				& @CRLF & @CRLF & "This is the Administrator Name/ID used to gain access to the Microsoft SQL 2005 Express Edition server." _
				& @CRLF & @CRLF & "By default this account name is created during the installation of Microsoft SQL 2005 Express Edition Server and for our purposes is perfectly appropriate to use.")
GUICtrlCreateTabItem("")    ; end tabitem definition

GUICtrlCreateTabItem("Password field")
GUISetFont(8.5, 400, 0, "Verdana")
$txt4Text = GUICtrlCreateEdit("", 45, 290, 460, 125, $WS_VSCROLL + $WS_DLGFRAME + $ES_MULTILINE + $ES_READONLY + $SS_SUNKEN )
GUICtrlSetData ($txt4Text,"Password Field" _
				& @CRLF & @CRLF & "This is the password we use together with the User ID to access the SQL server." _
				& @CRLF & @CRLF & "By default the 'sa' account does not have a password and so this field can be left blank and is reflected by the absense of one when you start this program." _
				& @CRLF & @CRLF & "If we choose to login as another account holder with differing permissions and accesses we need to ensure the correct password is placed in this field so that we can access the SQL server and database." _
				& @CRLF & @CRLF & "During the installation of Microsoft SQL 2005 Express Edition Server, the 'sa' account holder was prompted for a password for use in mixed mode. This may be a one off or may be the actual new installation process, to which I am unsure at this time." _
				& @CRLF & @CRLF & "For this installation we used 'chicken' as our 'sa' password. We could have used 'egg' but which came first?")
GUICtrlCreateTabItem("")    ; end tabitem definition

	; Set the defaults (server name input, default button[create], etc)
	GUICtrlSetState($sServerName, $GUI_FOCUS + $GUI_DEFBUTTON)
	
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $HEADER_WINDOW)
	GUISetState(@SW_SHOW, $DATA_WINDOW)
	GUISetState(@SW_SHOW, $TABS_WINDOW)	
	
	; In this loop we use variables to keep track of changes to the radios.
	While 1
		Sleep(10)
		$msg = GUIGetMsg()

		Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
				
			Case $msg = $btnExit ; User clicked the Exit button
				Exit
				
				; This is the function for the Clock on the GUI and shows the time in second increments
			Case $OldSec <> @SEC
				GUICtrlSetData($_StartTimeGlobal, StringFormat("Time : %2d:%02d:%02d", @HOUR, @MIN, @SEC))
				$OldSec = @SEC
				
				; For refresh
			Case $OldMin <> @MIN
				$TickTock = _today() & "_" & _time()
				$OldMin = @MIN
				
				; Buttons
			Case $msg = $btnCreate ; User clicked the Create Database button
				_dbCreate()
				
			Case $msg = $btnDelete ; User clicked the Delete Database button
				_dbDelete()

			; USE THIS FUNCTION TO CLEAR ALL ITEMS			
			Case $msg = $btn_Clear ; User clicked the Reset button
				GUICtrlSetData($sServerName,"")
				GUICtrlSetData($sDatabaseName,"")
				GUICtrlSetData($sUserID,"")
				GUICtrlSetData($sPasswordID,"")
				
			; USE THIS FUNCTION TO CLEAR ALL ITEMS			
			Case $msg = $btn_Default ; User clicked the Reset button
				GUICtrlSetData($sServerName,"My Computer") ; Use logical name as 127.0.0.1 will not work
				GUICtrlSetData($sDatabaseName,"mpdata1")
				GUICtrlSetData($sUserID,"sa")
				GUICtrlSetData($sPasswordID,"chicken")
		EndSelect
	WEnd

	GUIDelete($TABS_WINDOW)
	GUIDelete($DATA_WINDOW)	
	GUIDelete($HEADER_WINDOW)
	GUIDelete($MAIN_WINDOW)

;EndFunc   ;==>_Main

;---------------------------------------------------------+---------------------------------------------------------
; THIS IS THE DATABASE CREATE FUNCTION
Func _dbCreate()
	
	$msg = $GUI_UNCHECKED
	
	Dim $good, $Server, $Database, $Account, $Password
	Dim $MsgTitle
	Local $MsgTitle = "Avalanche db-Manager - Create"
	
	$good = 0
	
	; Collect the input data for processing
	; Check Server Name
	If StringInStr(StringUpper(GUICtrlRead($sServerName)), "SERVER NAME") Then
		MsgBox(0, $MsgTitle, "No Server Name Entered")
	ElseIf GUICtrlRead($sServerName) = "" Then
		MsgBox(0, $MsgTitle, "No Server Name Entered - Field Empty")
	Else
		$Server = GUICtrlRead($sServerName)
		If IsString($Server) Then
			$good = $good + 1
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Server")
		EndIf
	EndIf

	; Check Database Name
	If StringInStr(StringUpper(GUICtrlRead($sDatabaseName)), "DATABASE NAME") Then
		MsgBox(0, $MsgTitle, "No Database Entered")
	ElseIf GUICtrlRead($sDatabaseName) = "" Then
		MsgBox(0, $MsgTitle, "No Database Entered - Field Empty")
	Else
		$Database = GUICtrlRead($sDatabaseName)
		If IsString($Database) Then
			$good = $good + 2
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Database")
		EndIf
	EndIf
	
	; Check User Account
	If StringInStr(StringUpper(GUICtrlRead($sUserID)), "ADMIN ID") Then
		MsgBox(0, $MsgTitle, "No Admin User Name Entered")
	ElseIf GUICtrlRead($sUserID) = "" Then
		MsgBox(0, $MsgTitle, "No User Entered - Field Empty")
	Else
		$Account = GUICtrlRead($sUserID)
		If IsString($Account) Then
			$good = $good + 3
		Else
			MsgBox(0, $MsgTitle, "Error in verifying User Account")
		EndIf
	EndIf

	; Check Account Password
	If StringInStr(StringUpper(GUICtrlRead($sPasswordID)), "ADMIN PASSWORD") Then
		MsgBox(0, $MsgTitle, "No Admin Password Entered")
	ElseIf GUICtrlRead($sPasswordID) = "" Then
		MsgBox(0, $MsgTitle, "No Password Entered - Field Empty")
	Else
		$Password = GUICtrlRead($sPasswordID)
		If IsString($Password) Then
			$good = $good + 4
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Account Password")
		EndIf
	EndIf
		
	If $good = 10 Then
		$sqlCon = ObjCreate ("ADODB.Connection")
		$sqlCon.Open ("Provider = SQLOLEDB; _
		Data Source = " & $Server & "; _
		User ID = " & $Account & "; _
		Password = " & $Password & "; """)
		$sqlCon.Execute ("CREATE DATABASE " & $Database)
	Else
		SplashTextOn($MsgTitle, @LF & " An error has occurred in one or more of the data " & @LF & " fields or they have not been filled in correctly! " & @LF & @LF & "Please fill in all the fields again and restart the Create Process.", 300, 120, -1, -1, 0, "Arial", 10)
		Sleep(10000)
		SplashOff()
	EndIf
	
EndFunc   ;==>_dbCreate
;---------------------------------------------------------+---------------------------------------------------------
; THIS IS THE DATABASE DELETE FUNCTION
Func _dbDelete()
	
	$msg = $GUI_UNCHECKED
	
	Dim $good, $Server, $Database, $Account, $Password
	Dim $MsgTitle
	Local $MsgTitle = "Avalanche db-Manager - Delete"
	
	$good = 0
	
	; Collect the input data for processing
	; Check Server Name
	If StringInStr(StringUpper(GUICtrlRead($sServerName)), "SERVER NAME") Then
		MsgBox(0, $MsgTitle, "No Server Name Entered")
	ElseIf GUICtrlRead($sServerName) = "" Then
		MsgBox(0, $MsgTitle, "No Server Name Entered - Field Empty")
	Else
		$Server = GUICtrlRead($sServerName)
		If IsString($Server) Then
			$good = $good + 1
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Server")
		EndIf
	EndIf

	; Check Database Name
	If StringInStr(StringUpper(GUICtrlRead($sDatabaseName)), "DATABASE NAME") Then
		MsgBox(0, $MsgTitle, "No Database Entered")
	ElseIf GUICtrlRead($sDatabaseName) = "" Then
		MsgBox(0, $MsgTitle, "No Database Entered - Field Empty")
	Else
		$Database = GUICtrlRead($sDatabaseName)
		If IsString($Database) Then
			$good = $good + 2
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Database")
		EndIf
	EndIf
	
	; Check User Account
	If StringInStr(StringUpper(GUICtrlRead($sUserID)), "ADMIN ID") Then
		MsgBox(0, $MsgTitle, "No Admin User Name Entered")
	ElseIf GUICtrlRead($sUserID) = "" Then
		MsgBox(0, $MsgTitle, "No User Entered - Field Empty")
	Else
		$Account = GUICtrlRead($sUserID)
		If IsString($Account) Then
			$good = $good + 3
		Else
			MsgBox(0, $MsgTitle, "Error in verifying User Account")
		EndIf
	EndIf

	; Check Account Password
	If StringInStr(StringUpper(GUICtrlRead($sPasswordID)), "ADMIN PASSWORD") Then
		MsgBox(0, $MsgTitle, "No Admin Password Entered")
	ElseIf GUICtrlRead($sPasswordID) = "" Then
		MsgBox(0, $MsgTitle, "No Password Entered - Field Empty")
	Else
		$Password = GUICtrlRead($sPasswordID)
		If IsString($Password) Then
			$good = $good + 4
		Else
			MsgBox(0, $MsgTitle, "Error in verifying Account Password")
		EndIf
	EndIf

	If $good = 10 Then
		$sqlCon = ObjCreate ("ADODB.Connection")
		$sqlCon.Open ("Provider = SQLOLEDB; _
		Data Source = " & $Server & "; _
		User ID = " & $Account & "; _
		Password = " & $Password & "; """)
		$sqlCon.Execute ("DROP DATABASE " & $Database)
	Else
		SplashTextOn($MsgTitle, @LF & " An error has occurred in one or more of the data " & @LF & " fields or they have not been filled in correctly! " & @LF & @LF & "Please fill in all the fields again and restart the Create Process.", 300, 120, -1, -1, 0, "Arial", 10)
		Sleep(10000)
		SplashOff()
	EndIf
	
EndFunc   ;==>_dbDelete

