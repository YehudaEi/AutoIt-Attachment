#Tidy_Parameters= /gd 1  /gds 1 /nsdp
#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=Y
#include-once
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <OutlookExConstants.au3>
; #INDEX# =======================================================================================================================
; Title .........: Microsoft Outlook Function Library (MS Outlook 2003 and later)
; AutoIt Version : 3.3.9.2 (New COM error handler)
; UDF Version ...: 0.9.0
; Language ......: English
; Description ...: A collection of functions for accessing and manipulating Microsoft Outlook
; Author(s) .....: wooltown, water
; Modified.......: 20121007 (YYYYMMDD)
; Contributors ..: progandy (CSV functions taken and modified from http://www.autoitscript.com/forum/topic/114406-csv-file-to-multidimensional-array)
;                  Ultima, PsaltyDS for the basis of the __OL_ArrayConcatenate function
; Resources .....: Outlook 2003 Visual Basic Reference: http://msdn.microsoft.com/en-us/library/aa271384(v=office.11).aspx
;                  Outlook 2007 Developer Reference:    http://msdn.microsoft.com/en-us/library/bb177050(v=office.12).aspx
;                  Outlook 2010 Developer Reference:    http://msdn.microsoft.com/en-us/library/ff870432.aspx
;                  Outlook Examples:                                                                      
; ===============================================================================================================================

#region #VARIABLES#
; #VARIABLES# ===================================================================================================================
Global $__iOL_Debug = 0 ; Debug level. 0 = no debug information, 1 = Debug info to console, 2 = Debug info to MsgBox, 3 = Debug Info to File
Global $__sOL_DebugFile = @ScriptDir & "\Outlook_Debug.txt" ; Debug file if $__iOL_Debug is set to 3
Global $__oOL_Error ; COM Error handler
Global $__bOL_AlreadyRunning = False ; Is Outlook already running?
; ===============================================================================================================================
#endregion #VARIABLES#

; #CURRENT# =====================================================================================================================
;_OL_Open
;_OL_Close
;_OL_ErrorNotify
;_OL_AccountGet
;_OL_AddressListGet
;_OL_AddressListMemberGet
;_OL_ApplicationGet
;_OL_AppointmentGet
;_OL_BarGroupAdd
;_OL_BarGroupDelete
;_OL_BarGroupGet
;_OL_BarShortcutAdd
;_OL_BarShortcutDelete
;_OL_BarShortcutGet
;_OL_CategoryAdd
;_OL_CategoryDelete
;_OL_CategoryGet
;_OL_DistListMemberAdd
;_OL_DistListMemberDelete
;_OL_DistListMemberGet
;_OL_DistListMemberOf
;_OL_FolderAccess
;_OL_FolderArchiveGet
;_OL_FolderArchiveSet
;_OL_FolderCopy
;_OL_FolderCreate
;_OL_FolderDelete
;_OL_FolderExists
;_OL_FolderFind
;_OL_FolderGet
;_OL_FolderModify
;_OL_FolderMove
;_OL_FolderRename
;_OL_FolderSelectionGet
;_OL_FolderSet
;_OL_FolderTree
;_OL_Item2Task
;_OL_ItemAttachmentAdd
;_OL_ItemAttachmentDelete
;_OL_ItemAttachmentGet
;_OL_ItemAttachmentSave
;_OL_ItemConflictGet
;_OL_ItemCopy
;_OL_ItemCreate
;_OL_ItemDelete
;_OL_ItemDisplay
;_OL_ItemExport
;_OL_ItemFind
;_OL_ItemForward
;_OL_ItemGet
;_OL_ItemImport
;_OL_ItemModify
;_OL_ItemMove
;_OL_ItemPrint
;_OL_ItemRecipientAdd
;_OL_ItemRecipientCheck
;_OL_ItemRecipientDelete
;_OL_ItemRecipientGet
;_OL_ItemRecipientSelect
;_OL_ItemRecurrenceDelete
;_OL_ItemRecurrenceExceptionGet
;_OL_ItemRecurrenceExceptionSet
;_OL_ItemRecurrenceGet
;_OL_ItemRecurrenceSet
;_OL_ItemReply
;_OL_ItemSave
;_OL_ItemSearch
;_OL_ItemSend
;_OL_ItemSendReceive
;_OL_ItemSync
;_OL_MailheaderGet
;_OL_MaiLSignatureCreate
;_OL_MaiLSignatureDelete
;_OL_MaiLSignatureGet
;_OL_MaiLSignatureSet
;_OL_OOFGet
;_OL_OOFSet
;_OL_PSTAccess
;_OL_PSTClose
;_OL_PSTCreate
;_OL_PSTGet
;_OL_RecipientFreeBusyGet
;_OL_ReminderDelay
;_OL_ReminderDismiss
;_OL_ReminderGet
;_OL_RuleActionGet
;_OL_RuleActionSet
;_OL_RuleAdd
;_OL_RuleConditionGet
;_OL_RuleConditionSet
;_OL_RuleDelete
;_OL_RuleExecute
;_OL_RuleGet
;_OL_StoreGet
;_OL_VersionInfo
;_OL_Wrapper_CreateAppointment
;_OL_Wrapper_SendMail
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;__OL_ArrayConcatenate
;__OL_CheckProperties
;__Outlook_ErrorHandler
;__WriteCSV
;__OL_Property2Hex
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_Open
; Description ...: Opens a connection to Microsoft Outlook.
; Syntax.........: _OL_Open([$bWarningClick = False[, $sWarningProgram = ""[, $iWinCheckTime = 1000[, $iCtrlCheckTime = 1000[, $sProfileName = ""[, $sPassword = ""]]]]])
; Parameters ....: $bWarningClick      - Optional: If set to True a function will click away the Outlook security warning messages (default = False)
;                  $sWarningProgram    - Optional: Complete path to the WarningProgram, e.g.: "C:\OLext\_OL_Warnings.exe"
;                  + (default = @ScriptDir & "\_OL_Warnings.exe" which is part of this UDF)
;                  $iWinCheckTime      - Optional: Time in milliseconds to wait before a check for a warning window is performed (default = 1000 milliseconds = 1 second)
;                  $iCtrlCheckTime     - Optional: How long, in milliseconds, we will wait before we check that the controls we click are enabled (default = 1000)
;                  $sProfileName       - Optional: Name of the profile to be used for logon. The default profile will be used if none is specified (default = "")
;                  $sPassword          - Optional: The password associated with the profile (default = "")
; Return values .: Success - New object identifier and sets @extended:
;                  |0 - Outlook was not running. When using _OL_Open you need not to set parameter $bForceClose to True to stop the Outlook process (optional)
;                  |1 - Outlook was already up and running. When using _OL_Open you have to set parameter $bForceClose to True to stop the Outlook process (optional)
;                  Failure - Returns 0 and sets @error:
;                  |1 - Unable to create Outlook Object. See @extended for details (@error returned by ObjCreate)
;                  |3 - $bWarningClick is invalid. Has to be True or False
;                  |4 - $iWinCheckTime is invalid. Has to be an integer
;                  |5 - File $sWarningProgram does not exist. Has to be an executable that can be startet using the run command
;                  |6 - Run error when running $sWarningProgram. Please check @extended for more information
;                  |7 - $iCtrlCheckTime is invalid. Has to be an integer
;                  |8 - Unable to logon to the default profile. See @extended for details (@error returned by Logon)
;                  |9 - No profile has been configured or there is no default profile for Outlook
;                  |10 - You specified a profile name to logon to but Outlook is already running
; Author ........: Wooltown
; Modified ......: water
; Remarks .......: Create your own $sWarningProgram Exe if the window title or messages have changed or are displayed in another language.
;                  If Outlook is already running a specified profile name is ignored because no logon is needed.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _OL_Open($bWarningClick = False, $sWarningProgram = "", $iWinCheckTime = 1000, $iCtrlCheckTime = 1000, $sProfileName = "", $sPassword = "")

	Local $oOL = ObjGet("", "Outlook.Application")
	If $oOL <> 0 Then $__bOL_AlreadyRunning = True
	If Not IsBool($bWarningClick) Then Return SetError(3, 0, 0)
	If Not IsInt($iWinCheckTime) Then Return SetError(4, 0, 0)
	If Not IsInt($iCtrlCheckTime) Then Return SetError(7, 0, 0)
	If $__bOL_AlreadyRunning And $sProfileName <> "" Then Return SetError(10, 0, 0)
	; Activate the COM error handler for older AutoIt versions
	If $__iOL_Debug = 0 And Number(StringReplace(@AutoItVersion, ".", "")) < 3392 Then _OL_ErrorNotify(1)
	If Not $__bOL_AlreadyRunning Then
		$oOL = ObjCreate("Outlook.Application")
		If @error Or Not IsObj($oOL) Then Return SetError(1, @error, 0)
	EndIf
	If $bWarningClick Then
		If StringStripWS($sWarningProgram, 3) = "" Then $sWarningProgram = @ScriptDir & "\_OL_Warnings.exe"
		If Not FileExists($sWarningProgram) Then Return SetError(5, 0, 0)
		Run($sWarningProgram & " " & @AutoItPID & " " & $iWinCheckTime & " " & $iCtrlCheckTime & " " & $oOL.Version & " " & $oOL.LanguageSettings.LanguageID($msoLanguageIDUI), "", @SW_HIDE)
		If @error Then Return SetError(6, @error, 0)
	EndIf
	Local $aVersion = StringSplit($oOL.Version, '.')
	; Logon to the specified or the default profile if Outlook wasn't already running (for Outlook 2007 and later)
	If Not $__bOL_AlreadyRunning And Int($aVersion[1]) >= 12 Then
		If StringStripWS($sProfileName, 3) = "" Then $sProfileName = $oOL.DefaultProfileName
		If StringStripWS($sProfileName, 3) = "" Then Return SetError(9, 0, 0)
		Local $oNamespace = $oOL.GetNamespace("MAPI")
		$oNamespace.Logon($sProfileName, $sPassword, False, False)
		If @error Then Return SetError(8, @error, 0)
	EndIf
	If $__bOL_AlreadyRunning Then Return SetError(0, 1, $oOL)
	Return $oOL

EndFunc   ;==>_OL_Open

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_Close
; Description ...: Closes the connection to Microsoft Outlook.
; Syntax.........: _OL_Close($oOL[, $bForceClose = False])
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $bForceClose - Optional: If True Outlook is closed even when it was running at _OL_Open time (default = False)
; Return values .: Success - Returns 1 and sets @extended to 1 if Outlook was already running
;                  Failure - Returns 0 and sets @error
;                  |1 - Error with Session.Logoff. Please check @extended for more information
;                  |2 - Error with Application.Quit. Please check @extended for more information
;                  |3 - Error with Quit. Please check @extended for more information
; Author ........: Wooltown
; Modified ......: water
; Remarks .......: If Outlook was already running when _OL_Open was called you have to use flag $bForceClose to close Outlook.
;                  If Outlook was already running when _OL_Open was called @extended is set to 1 to indicate this
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _OL_Close(ByRef $oOL, $bForceClose = False)

	If Not $__bOL_AlreadyRunning Or $bForceClose Then
		$oOL.Session.Logoff
		If @error Then Return SetError(1, @error, 0)
		$oOL.Application.Quit
		If @error Then Return SetError(2, @error, 0)
		; The associated Outlook session is closed completely.
		; The user is logged out of the messaging system and any changes to items not already saved are discarded
		$oOL.Quit
		If @error Then Return SetError(3, @error, 0)
	EndIf
	$oOL = 0
	$__iOL_Debug = 0
	$__sOL_DebugFile = @ScriptDir & "\Outlook_Debug.txt"
	$__oOL_Error = 0
	If $__bOL_AlreadyRunning Then
		$__bOL_AlreadyRunning = False
		Return SetError(0, 1, 1)
	EndIf
	Return 1

EndFunc   ;==>_OL_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_ErrorNotify
; Description ...: Sets or queries the debug level.
; Syntax.........: _OL_ErrorNotify($iDebug[, $sDebugFile = @ScriptDir & "\Outlook_Debug.txt"])
; Parameters ....: $iDebug     - Debug level. Allowed values are:
;                  |-1 - Return the current settings
;                  |0  - Disable debugging
;                  |1  - Enable debugging. Output the debug info to the console
;                  |2  - Enable Debugging. Output the debug info to a MsgBox
;                  |3  - Enable Debugging. Output the debug info to a file defined by $sDebugFile
;                  $sDebugFile - Optional: File to write the debugging info to if $iDebug = 3 (Default = @ScriptDir & "\Outlook_Debug.txt")
; Return values .: Success (for $iDebug => 0) - 1, sets @extended to:
;                  |0 - The COM error handler for this UDF was already active
;                  |1 - A COM error handler has been initialized for this UDF
;                  Success (for $iDebug = -1) - one based one-dimensional array with the following elements:
;                  |1 - Debug level. Value from 0 to 3. Check parameter $iDebug for details
;                  |2 - Debug file. File to write the debugging info to as defined by parameter $sDebugFile
;                  |3 - True if the COM error handler has been defined for this UDF. False if debugging is set off or a COM error handler was already defined
;                  Failure - 0, sets @error to:
;                  |1 - $iDebug is not an integer or < -1 or > 3
;                  |2 - Installation of the custom error handler failed. @extended is set to the error code returned by ObjEvent
;                  |3 - COM error handler already set to another function
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ErrorNotify($iDebug, $sDebugFile = "")

	If Not IsInt($iDebug) Or $iDebug < -1 Or $iDebug > 3 Then Return SetError(1, 0, 0)
	If $sDebugFile = "" Then $sDebugFile = @ScriptDir & "\Outlook_Debug.txt"
	Switch $iDebug
		Case -1
			Local $avDebug[4] = [3]
			$avDebug[1] = $__iOL_Debug
			$avDebug[2] = $__sOL_DebugFile
			$avDebug[3] = IsObj($__oOL_Error)
			Return $avDebug
		Case 0
			$__iOL_Debug = 0
			$__sOL_DebugFile = ""
			$__oOL_Error = 0
		Case Else
			$__iOL_Debug = $iDebug
			$__sOL_DebugFile = $sDebugFile
			; A COM error handler will be initialized only if one does not exist
			If ObjEvent("AutoIt.Error") = "" Then
				$__oOL_Error = ObjEvent("AutoIt.Error", "__Outlook_ErrorHandler") ; Creates a custom error handler
				If @error <> 0 Then Return SetError(2, @error, 0)
				Return SetError(0, 1, 1)
			ElseIf ObjEvent("AutoIt.Error") = "__Outlook_ErrorHandler" Then
				Return SetError(0, 0, 1) ; COM error handler already set by a call to this function
			Else
				Return SetError(3, 0, 0) ; COM error handler already set to another function
			EndIf
	EndSwitch
	Return 1

EndFunc   ;==>_OL_ErrorNotify

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_AccountGet
; Description ...: Returns information about the accounts available for the current profile.
; Syntax.........: _OL_AccountGet($oOL)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - AccountType
;                  |1 - Displayname
;                  |2 - SMTPAddress
;                  |3 - Username
;                  +For Outlook 2010 and later the following information is returned in addition:
;                  |4 - OlAutoDiscoverConnectionMode constant that specifies the type of connection to use for the auto-discovery service of the Microsoft Exchange server
;                  |5 - OlExchangeConnectionMode constant that indicates the current connection mode for the Microsoft Exchange Server
;                  |6 - Name of the Microsoft Exchange Server that hosts the account mailbox
;                  |7 - Full version number of the Microsoft Exchange Server that hosts the account mailbox <major version>.<minor version>.<build number>.<revision>
;                  Failure - Returns "" and sets @error:
;                  |1 - Function is only supported for Outlook 2007 and later
; Author ........: water
; Modified ......:
; Remarks .......: This function only works for Outlook 2007 and later.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_AccountGet($oOL)

	Local $aVersion = StringSplit($oOL.Version, '.')
	If Int($aVersion[1]) < 12 Then Return SetError(1, 0, "")
	Local $iIndex = 0, $iColumns = 4
	If Int($aVersion[1]) > 12 Then $iColumns = 8
	Local $aAccount[$oOL.Session.Accounts.Count + 1][$iColumns] = [[$oOL.Session.Accounts.Count, $iColumns]]
	For $oAccount In $oOL.Session.Accounts
		$iIndex = $iIndex + 1
		$aAccount[$iIndex][0] = $oAccount.AccountType
		$aAccount[$iIndex][1] = $oAccount.DisplayName
		$aAccount[$iIndex][2] = $oAccount.SMTPAddress
		$aAccount[$iIndex][3] = $oAccount.UserName
		If Int($aVersion[1]) > 12 Then
			$aAccount[$iIndex][4] = $oAccount.AutoDiscoverConnectionMode
			$aAccount[$iIndex][5] = $oAccount.ExchangeConnectionMode
			$aAccount[$iIndex][6] = $oAccount.ExchangeMailboxServerName
			$aAccount[$iIndex][7] = $oAccount.ExchangeMailboxServerVersion
		EndIf
	Next
	Return $aAccount

EndFunc   ;==>_OL_AccountGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_AddressListGet
; Description ...: Returns information about all Addresslists.
; Syntax.........: _OL_AddressListGet($oOL[, $bResolve = True])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $bResolve - Optional: If True only addresslists that are used when resolving recipient names are returned (default = True)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Constant from the OlAddressListType enumeration representing the type of the Addresslist
;                  |1 - Display name for the object
;                  |2 - Index indicating the position of the AddressList within the collection
;                  |3 - Integer that represents the order of this Addresslist to be used when resolving recipient names
;                  +    -1 means the Addresslist is not used to resolve addresses
;                  |4 - A string representing the unique identifier for the addresslist
; Author ........: water
; Modified ......:
; Remarks .......: Use the GetContactsFolder method to obtain a folder object that represents the contacts folder
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_AddressListGet($oOL, $bResolve = True)

	Local $iIndex = 1, $iIndex1, $oAddressList
	Local $aAddressLists[$oOL.Session.AddressLists.Count + 1][5]
	For $iIndex1 = 1 To $oOL.Session.AddressLists.Count
		$oAddressList = $oOL.Session.AddressLists($iIndex1)
		If $bResolve = False Or $oAddressList.ResolutionOrder <> -1 Then
			$aAddressLists[$iIndex][0] = $oAddressList.AddressListType
			$aAddressLists[$iIndex][1] = $oAddressList.Name
			$aAddressLists[$iIndex][2] = $iIndex1
			$aAddressLists[$iIndex][3] = $oAddressList.ResolutionOrder
			$aAddressLists[$iIndex][4] = $oAddressList.ID
			$iIndex += 1
		EndIf
	Next
	ReDim $aAddressLists[$iIndex][UBound($aAddressLists, 2)]
	$aAddressLists[0][0] = $iIndex - 1
	$aAddressLists[0][1] = UBound($aAddressLists, 2)
	Return $aAddressLists

EndFunc   ;==>_OL_AddressListGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_AddressListMemberGet
; Description ...: Returns information about all members of an address list.
; Syntax.........: _OL_AddressListMemberGet($oOL, $vID)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
;                  $vID - Number or name of an address list in the address lists collection as returned by _OL_AddressListGet
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - E-mail address of the AddressEntry
;                  |1 - Display name for the AddressEntry
;                  |2 - Constant from the OlAddressEntryUserType enumeration representing the user type of the AddressEntry
;                  |3 - Unique identifier for the object (string)
;                  |4 - Object of the AddressEntry
;                  Failure - Returns "" and sets @error:
;                  |1 - No address list index specified
;                  |2 - Address list specified by $vID could not be found
; Author ........: water
; Modified.......:
; Remarks .......: To access an AddressList by number please use the Index returned by _OL_AddressListGet in column 3
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_AddressListMemberGet($oOL, $vID)

	If StringStripWS($vID, 3) = "" Then Return SetError(1, 0, "")
	Local $oItems = $oOL.Session.AddressLists.Item($vID).AddressEntries
	If @error Then Return SetError(2, @error, 0)
	Local $aMembers[$oItems.Count + 1][5] = [[$oItems.Count, 5]], $iIndex = 1
	For $oItem In $oItems
		$aMembers[$iIndex][0] = $oItem.Address ; <== ??
		$aMembers[$iIndex][1] = $oItem.Name
		$aMembers[$iIndex][2] = $oItem.AddressEntryUserType
		$aMembers[$iIndex][3] = $oItem.ID
		; Exchange user that belongs to the same or a different Exchange forest
		If $oItem.AddressEntryUserType = $olExchangeUserAddressEntry Or $oItem.AddressEntryUserType = $olExchangeRemoteUserAddressEntry Then
			$aMembers[$iIndex][4] = $oItem.GetExchangeUser
			$aMembers[$iIndex][0] = $aMembers[$iIndex][4] .PrimarySmtpAddress
		EndIf
		; Address entry in an Outlook Contacts folder
		If $oItem.AddressEntryUserType = $olOutlookContactAddressEntry Then
			$aMembers[$iIndex][4] = $oItem.GetContact
			$aMembers[$iIndex][0] = $aMembers[$iIndex][4] .Email1Address
		EndIf
		$iIndex += 1
	Next
	Return $aMembers

EndFunc   ;==>_OL_AddressListMemberGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ApplicationGet
; Description ...: Returns information about the Outlook application.
; Syntax.........: _OL_ApplicationGet($oOL)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - Name of the default profile
;                  |2 - LanguageSettings: Execution mode language
;                  |3 - LanguageSettings: Help language
;                  |4 - LanguageSettings: Install language
;                  |5 - LanguageSettings: User interface language
;                  |6 - Name of the application
;                  |7 - Product code. String specifying the Microsoft Outlook globally unique identifier (GUID
;                  |8 - Product version (n.n.n.n)
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ApplicationGet($oOL)

	Local $aApplication[9] = [8]
	$aApplication[1] = $oOL.DefaultProfileName
	$aApplication[2] = $oOL.LanguageSettings.LanguageID($msoLanguageIDExeMode)
	$aApplication[3] = $oOL.LanguageSettings.LanguageID($msoLanguageIDHelp)
	$aApplication[4] = $oOL.LanguageSettings.LanguageID($msoLanguageIDInstall)
	$aApplication[5] = $oOL.LanguageSettings.LanguageID($msoLanguageIDUI)
	$aApplication[6] = $oOL.Name
	$aApplication[7] = $oOL.ProductCode
	$aApplication[8] = $oOL.Version
	Return $aApplication

EndFunc   ;==>_OL_ApplicationGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_AppointmentGet
; Description ...: Returns appointments in a specified time frame plus (optional) recurrences.
; Syntax.........: _OL_AppointmentGet($oOL, $vFolder[, $sStart = Default[, $sEnd = Default[, $bInclRecurrences = True[, $bInclSpan = True]]]])
; Parameters ....: $oOL              - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder          - Calendar folder object as returned by _OL_FolderAccess or full name of folder where the search will be started
;                  $sStart           - Optional: Start date/time (default = Today 00:00)
;                  $sEnd             - Optional: End date/time (default = Today+1 00:00)
;                  $bInclRecurrences - Optional: True includes recurring appointments (default = True)
;                  $bInclSpan        - Optional: True includes appointments that span the time frame or that only end or only start in the time frame (default = True)
; Return values .: Success - One based two-dimensional array with the following properties:
;                  |0 - EntryId of the item
;                  |1 - Object of the item
;                  |2 - Start date and time
;                  |3 - End date and time
;                  |4 - Subject of the item
;                  |5 - True if the item is a recurring appointment
;                  Failure - Returns "" and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - Error accessing the specified folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |3 - The specified folder is not a calendar folder
;                  |4 - Error accessing the items of the specified folder. See @extended for errorcode returned when accessing the Items property
;                  |4 - Error executing the Restrict method to filter appointments. See @extended for errorcode returned by the Restrict method
; Author ........: water
; Modified ......:
; Remarks .......: To get all appointments of a whole day set $sStart to "date 00:00" and $sEnd to "date+1 00:00".
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_AppointmentGet($oOL, $vFolder, $sStart = Default, $sEnd = Default, $bInclRecurrences= True, $bInclSpan = True)

	Local $aTemp, $iCounter = 0, $sFilter
	If Not IsObj($oOL) Then Return SetError(1, 0, "")
	If Not IsObj($vFolder) Then
		$aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(2, @error, "")
		$vFolder = $aTemp[1]
	EndIf
	If $vFolder.DefaultItemType <> $olAppointmentItem Then Return SetError(3, 0, "")
	If $sStart = Default Then $sStart = _NowDate() & " 00:00"
	If $sEnd = Default Then
		Local $tDate = _Date_Time_GetSystemTime()
		$sEnd = _DateTimeFormat(_DateAdd("D", 1, _Date_Time_SystemTimeToDateStr($tDate, 1)), 2) & " 00:00"
	EndIf
	Local $oItems = $vFolder.Items
	If @error Or Not IsObj($oItems) Then Return SetError(4, @error, "")
	$oItems.Sort("[Start]", False)
	$oItems.IncludeRecurrences = $bInclRecurrences
	If $bInclSpan Then
		$sFilter = "[Start]<='" & $sEnd & "' AND [End]>='" & $sStart & "'"
	Else
		$sFilter = "[Start]>='" & $sStart & "' AND [End]<='" & $sEnd & "'"
	EndIf
	If $bInclRecurrences = False Then $sFilter = $sFilter & " AND [IsRecurring]=False"
	$oItems = $oItems.Restrict($sFilter)
	If @error Or Not IsObj($oItems) Then Return SetError(5, @error, "")
	; Counter property is not correctly set when IncludeRecurrences is used
	For $oItem In $oItems
		$iCounter += 1
	Next
	Local $aItems[$iCounter + 1][6] = [[$iCounter, 6]]
	$iCounter = 0
	; Fill array with some properties - can't use ItemProperties as in _OL_ItemFind because the ItemProperties property is not
	; set for a recurring appointments
	For $oItem In $oItems
		$iCounter += 1
		$aItems[$iCounter][0] = $oItem.EntryId
		$aItems[$iCounter][1] = $oItem
		$aItems[$iCounter][2] = $oItem.Start
		$aItems[$iCounter][3] = $oItem.End
		$aItems[$iCounter][4] = $oItem.Subject
		$aItems[$iCounter][5] = $oItem.IsRecurring
	Next
	Return $aItems

EndFunc   ;==>_OL_AppointmentGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarGroupAdd
; Description ...: Adds a group to the OutlookBar.
; Syntax.........: _OL_BarGroupAdd($oOL, $sGroupname[, $iPosition = 1])
; Parameters ....: $oOL        - Outlook object returned by a preceding call to _OL_Open()
;                  $oGroupname - Name of the group to be created
;                  $iPosition  - Optional: Position at which the new group will be inserted in the Shortcuts pane (default = 1 = at the top of the bar)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the Outlookbar pane. For details please see @extended
;                  |2 - Error creating the group. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarGroupAdd($oOL, $sGroupname, $iPosition = 1)

	Local $oPane = $oOL.ActiveExplorer.Panes("OutlookBar")
	If @error Then Return SetError(1, @error, 0)
	$oPane.Contents.Groups.Add($sGroupname, $iPosition)
	If @error Then Return SetError(2, @error, 0)
	Return 1

EndFunc   ;==>_OL_BarGroupAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarGroupDelete
; Description ...: Deletes a group from the OutlookBar.
; Syntax.........: _OL_BarGroupDelete($oOL, $vGroupname)
; Parameters ....: $oOL        - Outlook object returned by a preceding call to _OL_Open()
;                  $vGroupname - Name or 1-based index value of the group to be deleted
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $vGroupname is empty
;                  |2 - Error accessing the specified group. For details please see @extended
;                  |3 - Error removing the specified group. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......: To delete a group by name isn't possible in Outlook 2002
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarGroupDelete($oOL, $vGroupname)

	If StringStripWS($vGroupname, 3) = "" Then Return SetError(1, 0, 0)
	Local $oGroups = $oOL.ActiveExplorer.Panes.Item("OutlookBar").Contents.Groups
	If @error Then Return SetError(2, @error, 0)
	$oGroups.Remove($vGroupname)
	If @error Then Return SetError(3, @error, 0)
	Return 1

EndFunc   ;==>_OL_BarGroupDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarGroupGet
; Description ...: Returns all groups in the OutlookBar.
; Syntax.........: _OL_BarGroupGet($oOL)
; Parameters ....: $oOL    - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Display name of the group
;                  |1 - $OlOutlookBarViewType constant representing the view type of the group
;                  Failure - Returns "" and sets @error:
;                  |1 - Error accessing the Outlookbar pane. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarGroupGet($oOL)

	Local $iIndex = 1
	Local $oPane = $oOL.ActiveExplorer.Panes("OutlookBar")
	If @error Then Return SetError(1, @error, "")
	Local $aGroups[$oPane.Contents.Groups.Count + 1][2]
	For $oGroup In $oPane.Contents.Groups
		$aGroups[$iIndex][0] = $oGroup.Name
		$aGroups[$iIndex][1] = $oGroup.ViewType
		$iIndex += 1
	Next
	$aGroups[0][0] = $iIndex - 1
	$aGroups[0][1] = UBound($aGroups, 2)
	Return $aGroups

EndFunc   ;==>_OL_BarGroupGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarShortcutAdd
; Description ...: Adds a shortcut to a group in the OutlookBar.
; Syntax.........: _OL_BarShortcutAdd($oOL, $vGroupname, $sShortcutname, $sTarget[, $iPosition = 1[, $sIcon = ""]])
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vGroupname    - Name or 1-based index value of the group where the shortcut will be created
;                  $oShortcutname - Name of the shortcut to be created
;                  $sTarget       - Target of the shortcut being created. Can be an Outlook folder, filesystem folder, filesystem path or URL
;                  $iPosition     - Optional: Position at which the new shortcut will be inserted in the group (default = 0 = first shortcut in an empty group)
;                  $sIcon         - Optional: The path of the icon file e.g. C:\temp\sample.ico (default = no icon)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the group specified by $vGroupname. For details please see @extended
;                  |2 - Error creating the shortcut. For details please see @extended
;                  |3 - Specified icon file could not be found
;                  |4 - Error setting the icon for the created shortcut. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......: Specify $iPosition = 1 to position a shortcut at the top of a non empty group
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarShortcutAdd($oOL, $vGroupname, $sShortcutname, $sTarget, $iPosition = 0, $sIcon = "")

	Local $oGroup = $oOL.ActiveExplorer.Panes.Item("OutlookBar").Contents.Groups.Item($vGroupname)
	If @error Or Not IsObj($oGroup) Then Return SetError(1, @error, 0)
	Local $oShortCut = $oGroup.Shortcuts.Add($sTarget, $sShortcutname, $iPosition)
	If @error Then Return SetError(2, @error, 0)
	If $sIcon <> "" Then
		If Not FileExists($sIcon) Then Return SetError(3, 0, 0)
		$oShortCut.SetIcon($sIcon)
		If @error Then Return SetError(4, @error, 0)
	EndIf
	Return 1

EndFunc   ;==>_OL_BarShortcutAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarShortcutDelete
; Description ...: Deletes a Shortcut from the OutlookBar.
; Syntax.........: _OL_BarShortcutDelete($oOL, $vGroupname, $vShortcutname)
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vGroupname    - Name or 1-based index value of the group from where the shortcut will be deleted
;                  $vShortcutname - Name or 1-based index value of the shortcut to be deleted
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $vShortcutname is empty
;                  |2 - $vGroupname is empty
;                  |3 - Error accessing the specified group. For details please see @extended
;                  |4 - Error removing the specified Shortcut. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......: To delete a shortcut by name isn't possible in Outlook 2002
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarShortcutDelete($oOL, $vGroupname, $vShortcutname)

	If StringStripWS($vShortcutname, 3) = "" Then Return SetError(1, 0, 0)
	If StringStripWS($vGroupname, 3) = "" Then Return SetError(2, 0, 0)
	Local $oGroup = $oOL.ActiveExplorer.Panes.Item("OutlookBar").Contents.Groups.Item($vGroupname)
	If @error Then Return SetError(3, @error, 0)
	$oGroup.Shortcuts.Remove($vShortcutname)
	If @error Then Return SetError(4, @error, 0)
	Return 1

EndFunc   ;==>_OL_BarShortcutDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_BarShortcutGet
; Description ...: Returns all shortcuts of a group in the OutlookBar.
; Syntax.........: _OL_BarShortcutGet($oOL, $vGroup)
; Parameters ....: $oOL    - Outlook object returned by a preceding call to _OL_Open()
;                  $vGroup - Name or 1-based index value of the group
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Display name of the shortcut
;                  |1 - Variant indicating the target of the specified shortcut in a Shortcuts pane group
;                  Failure - Returns "" and sets @error:
;                  |1 - $vGroup is empty
;                  |2 - Error accessing the specified group. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/bb176723(v=office.12).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _OL_BarShortcutGet($oOL, $vGroup)

	Local $iIndex = 1
	If StringStripWS($vGroup, 3) = "" Then Return SetError(1, 0, "")
	Local $oGroup = $oOL.ActiveExplorer.Panes.Item("OutlookBar").Contents.Groups.Item($vGroup)
	If @error Then Return SetError(2, @error, "")
	Local $aShortcuts[$oGroup.Shortcuts.Count + 1][2]
	For $oShortCut In $oGroup.Shortcuts
		$aShortcuts[$iIndex][0] = $oShortCut.Name
		$aShortcuts[$iIndex][1] = $oShortCut.Target
		$iIndex += 1
	Next
	$aShortcuts[0][0] = $iIndex - 1
	$aShortcuts[0][1] = UBound($aShortcuts, 2)
	Return $aShortcuts

EndFunc   ;==>_OL_BarShortcutGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_CategoryAdd
; Description ...: Adds a category.
; Syntax.........: _OL_CategoryAdd($oOL, $sCategory[, $iColor = $olCategoryColorNone[, $sShortcut = $olCategoryShortcutKeyNone]])
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $sCategory - Name of the category to be created
;                  $iColor    - Optional: Color for the new category (default = OlCategoryColorNone)
;                  $iShortcut - Optional: Shortcut key for the new category (default = OlCategoryShortcutKeyNone)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the Session.Categories object. For details please see @extended
;                  |2 - Error creating the category. For details please see @extended
;                  |3 - Specified category already exists
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_CategoryAdd($oOL, $sCategory, $iColor = $olCategoryColorNone, $iShortcut = $olCategoryShortcutKeyNone)

	Local $oCategories = $oOL.Session.Categories
	If @error Then Return SetError(1, @error, 0)
	; Check if category already exists
	Local $aCategories = _OL_CategoryGet($oOL)
	If IsArray($aCategories) Then
		For $iIndex = 1 To $aCategories[0][0]
			If $aCategories[$iIndex][5] = $sCategory Then Return SetError(3, 0, 0)
		Next
	EndIf
	$oCategories.Add($sCategory, $iColor, $iShortcut)
	If @error Then Return SetError(2, @error, 0)
	Return 1

EndFunc   ;==>_OL_CategoryAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_CategoryDelete
; Description ...: Deletes a category.
; Syntax.........: _OL_CategoryDelete($oOL, $sCategory)
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $sCategory - Name, CategoryID or 1-based index value of the category to be deleted
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $sCategory is empty
;                  |2 - Error accessing the categories. For details please see @extended
;                  |3 - Specified category does not exist
;                  |4 - Error removing the specified category. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_CategoryDelete($oOL, $sCategory)

	If StringStripWS($sCategory, 3) = "" Then Return SetError(1, 0, 0)
	Local $oCategories = $oOL.Session.Categories
	If @error Then Return SetError(2, @error, 0)
	; Check if category exists
	Local $bFound = False
	Local $aCategories = _OL_CategoryGet($oOL)
	If IsArray($aCategories) Then
		For $iIndex = 1 To $aCategories[0][0]
			If $aCategories[$iIndex][5] = $sCategory Then
				$bFound = True
				ExitLoop
			EndIf
		Next
	EndIf
	If $bFound = False Then Return SetError(3, 0, 0)
	$oCategories.Remove($sCategory)
	If @error Then Return SetError(4, @error, 0)
	Return 1

EndFunc   ;==>_OL_CategoryDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_CategoryGet
; Description ...: Returns all categories by which Outlook items can be grouped.
; Syntax.........: _OL_CategoryGet($oOL)
; Parameters ....: $oOL    - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - CategoryBorderColor: OLE_COLOR value that represents the border color of the color swatch for a category
;                  |1 - CategoryGradientBottomColor: OLE_COLOR value that represents the bottom gradient color of the color swatch for a category
;                  |2 - CategoryGradientTopColor: OLE_COLOR value that represents the top gradient color of the color swatch for a category
;                  |3 - CategoryID: String value that represents the unique identifier for the category
;                  |4 - Color: OlCategoryColor constant that indicates the color used by the category object
;                  |5 - Name: Display name for the category
;                  |6 - ShortcutKey: OlCategoryShortcutKey constant that specifies the shortcut key used by the category
;                  Failure - Returns "" and sets @error:
;                  |1 - Error accessing the Session.Categories object. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_CategoryGet($oOL)

	Local $iIndex = 1
	Local $oCategories = $oOL.Session.Categories
	If @error Then Return SetError(1, @error, "")
	Local $aCategories[$oCategories.Count + 1][7]
	For $oCategory In $oCategories
		$aCategories[$iIndex][0] = $oCategory.CategoryBorderColor
		$aCategories[$iIndex][1] = $oCategory.CategoryGradientBottomColor
		$aCategories[$iIndex][2] = $oCategory.CategoryGradientTopColor
		$aCategories[$iIndex][3] = $oCategory.CategoryID
		$aCategories[$iIndex][4] = $oCategory.Color
		$aCategories[$iIndex][5] = $oCategory.Name
		$aCategories[$iIndex][6] = $oCategory.ShortcutKey
		$iIndex += 1
	Next
	$aCategories[0][0] = $iIndex - 1
	$aCategories[0][1] = UBound($aCategories, 2)
	Return $aCategories

EndFunc   ;==>_OL_CategoryGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_DistListMemberAdd
; Description ...: Adds one or multiple members to a distribution list.
; Syntax.........: _OL_DistListMemberAdd($oOL, $vItem, $sStoreID, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""]]]]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the distribution list item
;                  $sStoreID - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vP1      - Member to add to the distribution list. Either a recipient object or the recipients name to be resolved
;                  +           or a zero based one-dimensional array with unlimited number of members
;                  $vP2      - Optional: member to add to the distribution list. Either a recipient object or the recipients name to be resolved
;                  $vP3      - Optional: Same as $vP2
;                  $vP4      - Optional: Same as $vP2
;                  $vP5      - Optional: Same as $vP2
;                  $vP6      - Optional: Same as $vP2
;                  $vP7      - Optional: Same as $vP2
;                  $vP8      - Optional: Same as $vP2
;                  $vP9      - Optional: Same as $vP2
;                  $vP10     - Optional: Same as $vP2
; Return values .: Success - Distribution list object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No distribution list item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error adding member to the distribution list. @extended = number of the invalid member (zero based)
;                  |4 - Member name could not be resolved. @extended = number of the invalid member (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of members
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_DistListMemberAdd($oOL, $vItem, $sStoreID, $vP1, $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "")

	Local $oRecipient, $aRecipients[10]
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move members into an array
	If Not IsArray($vP1) Then
		$aRecipients[0] = $vP1
		$aRecipients[1] = $vP2
		$aRecipients[2] = $vP3
		$aRecipients[3] = $vP4
		$aRecipients[4] = $vP5
		$aRecipients[5] = $vP6
		$aRecipients[6] = $vP7
		$aRecipients[7] = $vP8
		$aRecipients[8] = $vP9
		$aRecipients[9] = $vP10
	Else
		$aRecipients = $vP1
	EndIf
	; add members to the distribution list
	For $iIndex = 0 To UBound($aRecipients) - 1
		; member is an object = recipient name already resolved
		If IsObj($aRecipients[$iIndex]) Then
			$vItem.AddMember($aRecipients[$iIndex])
			If @error Then Return SetError(3, $iIndex, 0)
		Else
			If StringStripWS($aRecipients[$iIndex], 3) = "" Then ContinueLoop
			$oRecipient = $oOL.Session.CreateRecipient($aRecipients[$iIndex])
			If @error Or Not IsObj($oRecipient) Then Return SetError(4, $iIndex, 0)
			$oRecipient.Resolve
			If @error Or Not $oRecipient.Resolved Then Return SetError(4, $iIndex, 0)
			$vItem.AddMember($oRecipient)
			If @error Then Return SetError(3, $iIndex, 0)
		EndIf
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_DistListMemberAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_DistListMemberDelete
; Description ...: Deletes one or multiple members from a distribution list.
; Syntax.........: _OL_DistListMemberDelete($oOL, $vItem, $sStoreID, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""]]]]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the distribution list item. Use the keyword "Default" to use the users mailbox
;                  $sStoreID - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vP1      - Member to delete from the distribution list. Either a recipient object or the recipients name to be deleted
;                  +           or a zero based one-dimensional array with unlimited number of members
;                  $vP2      - Optional: member to delete from the distribution list. Either a recipient object or the recipients name
;                  $vP3      - Optional: Same as $vP2
;                  $vP4      - Optional: Same as $vP2
;                  $vP5      - Optional: Same as $vP2
;                  $vP6      - Optional: Same as $vP2
;                  $vP7      - Optional: Same as $vP2
;                  $vP8      - Optional: Same as $vP2
;                  $vP9      - Optional: Same as $vP2
;                  $vP10     - Optional: Same as $vP2
; Return values .: Success - Distribution list object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No distribution list item specified
;                  |2 - Distribution list item could not be found. EntryID might be wrong
;                  |3 - Error removing member from the distribution list. @extended = number of the invalid member (zero based)
;                  |4 - Member name could not be resolved. @extended = number of the invalid member (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of members
;+
;                  No error is returned if a specified member is not a member of this distribution list
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_DistListMemberDelete($oOL, $vItem, $sStoreID, $vP1 = "", $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "")

	Local $oRecipient, $aRecipients[10]
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move members into an array
	If Not IsArray($vP1) Then
		$aRecipients[0] = $vP1
		$aRecipients[1] = $vP2
		$aRecipients[2] = $vP3
		$aRecipients[3] = $vP4
		$aRecipients[4] = $vP5
		$aRecipients[5] = $vP6
		$aRecipients[6] = $vP7
		$aRecipients[7] = $vP8
		$aRecipients[8] = $vP9
		$aRecipients[9] = $vP10
	Else
		$aRecipients = $vP1
	EndIf
	; Delete members from the distribution list
	For $iIndex = 0 To UBound($aRecipients) - 1
		; member is an object = recipient name already resolved
		If IsObj($aRecipients[$iIndex]) Then
			$vItem.RemoveMember($aRecipients[$iIndex])
			If @error Then Return SetError(3, $iIndex, 0)
		Else
			If StringStripWS($aRecipients[$iIndex], 3) = "" Then ContinueLoop
			$oRecipient = $oOL.Session.CreateRecipient($aRecipients[$iIndex])
			If @error Or Not IsObj($oRecipient) Then Return SetError(4, $iIndex, 0)
			$oRecipient.Resolve
			If @error Or Not $oRecipient.Resolved Then Return SetError(4, $iIndex, 0)
			$vItem.RemoveMember($oRecipient)
			If @error Then Return SetError(3, $iIndex, 0)
		EndIf
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_DistListMemberDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_DistListMemberGet
; Description ...: Gets all members of a distribution list.
; Syntax.........: _OL_DistListMemberGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the distribution list item
;                  $sStoreID - Optional: StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Recipient object of the member
;                  |1 - Name of the member
;                  |2 - EntryID of the member
;                  Failure - Returns "" and sets @error:
;                  |1 - No distribution list item specified
;                  |2 - Item could not be found. EntryID might be wrong
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_DistListMemberGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	Local $aMembers[$vItem.MemberCount + 1][3] = [[$vItem.MemberCount, 3]]
	For $iIndex = 1 To $vItem.MemberCount
		$aMembers[$iIndex][0] = $vItem.GetMember($iIndex)
		$aMembers[$iIndex][1] = $vItem.GetMember($iIndex).Name
		$aMembers[$iIndex][2] = $vItem.GetMember($iIndex).EntryID
	Next
	Return $aMembers

EndFunc   ;==>_OL_DistListMemberGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_DistListMemberOf
; Description ...: Returns information about all distribution lists the Exchange user is a member of.
; Syntax.........: _OL_DistListMemberOf($oExchangeUser)
; Parameters ....: $oExchangeUser - Resolved object of an Exchange user as returned by _OL_ItemRecipientCheck
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Exchange Distribution list object
;                  |1 - Name of the Exchange Distribution list the user is a member of
;                  |2 - ID of the Exchange Distribution list
;                  Failure - Returns "" and sets @error:
;                  |1 - $oExchangeUser is not an object
;                  |2 - $oExchangeUser is not resolved
;                  |3 - $oExchangeUser is not an Exchange user
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_DistListMemberOf($oExchangeUser)

	If Not IsObj($oExchangeUser) Then SetError(1, 0, "")
	If Not $oExchangeUser.Resolved Then SetError(2, 0, "")
	Local $oAddressEntry = $oExchangeUser.AddressEntry
	If $oAddressEntry.Type <> "EX" Then Return SetError(3, 0, "")
	Local $oExUser = $oAddressEntry.GetExchangeUser()
	Local $oListEntries = $oExUser.GetMemberOfList()
	Local $aAddressLists[$oListEntries.Count + 1][3] = [[$oListEntries.Count, 3]], $iIndex = 1
	For $oEntry In $oListEntries
		$aAddressLists[$iIndex][0] = $oEntry
		$aAddressLists[$iIndex][1] = $oEntry.Name
		$aAddressLists[$iIndex][2] = $oEntry.ID
		$iIndex += 1
	Next
	Return $aAddressLists

EndFunc   ;==>_OL_DistListMemberOf

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderAccess
; Description ...: Accesses a folder.
; Syntax.........: _OL_FolderAccess($oOL[, $sFolder = "" [, $iFolderType = Default[, $iItemType = Default]]])
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $sFolder     - Optional: Name of folder to access (default = default folder of current user (class specified by $iFolderType))
;                  |  "rootfolder\subfolder\...\subfolder" to access any public folder or any folder of the current user
;                  +      "rootfolder" for the current user can be replaced by "*"
;                  |  "\\firstname name" to access the default folder of another user (class specified by $iFolderType)
;                  |  "\\firstname name\\subfolder\...\subfolder" to access a subfolder of the default folder of another user (class specified by $iFolderType)
;                  |  "\\firstname name\subfolder\..\subfolder" to access any subfolder of another user
;                  +      "firstname name" for the current user can be replaced by "*"
;                  |  "" to access the default folder of the current user (class specified by $iFolderType)
;                  |  "\subfolder" to access a subfolder of the default folder of the current user (class specified by $iFolderType)
;                  $iFolderType - Optional: Type of folder if you want to access a default folder. Is defined by the Outlook OlDefaultFolders enumeration (default = Default)
;                  $iItemType   - Optional: Type of item which is used to select the default folder. Is defined by the Outlook OlItemType enumeration (default = Default)
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - Object to the folder
;                  |2 - Default item type (integer) for the specified folder. Defined by the Outlook OlItemType enumeration
;                  |3 - StoreID (string) of the store to access the folder by ID
;                  |4 - EntryID (string) of the folder to access the folder by ID
;                  |5 - Folderpath (string)
;                  Failure - Returns "" and sets @error:
;                  |1 - $iFolderType is missing or not a number
;                  |2 - Could not resolve specified User in $sFolder
;                  |3 - Error accessing specified folder
;                  |4 - Specified folder could not be found. @extended is set to the index of the subfolder in error (1 = root folder)
;                  |5 - Neither $sFolder, $iFolderType nor $iItemType was specified
;                  |6 - No valid $iItemType was found to set the default folder $iFolderType accordingly
; Author ........: water
; Modified.......:
; Remarks .......: If you only specify $iItemType then $iFolderType is set to the default folder for this item type.
;                  Supported item types are: $olAppointmentItem, $olContactItem, $olDistributionListItem, $olJournalItem, $olMailItem, $olNoteItem and $olTaskItem
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderAccess($oOL, $sFolder = "", $iFolderType = Default, $iItemType = Default)

	Local $oFolder, $aFolders, $aResult[6] = [5]
	; Set $iFolderType based on $iItemType
	If $sFolder = "" And $iFolderType = Default Then
		If $iItemType = Default Then Return SetError(5, 0, "")
		Local $aFolders[8][2] = [[7, 2],[$olAppointmentItem, $olFolderCalendar],[$olContactItem, $olFolderContacts],[$olDistributionListItem, $olFolderContacts], _
				[$olJournalItem, $olFolderJournal],[$olMailItem, $olFolderDrafts],[$olNoteItem, $olFolderNotes],[$olTaskItem, $olFolderTasks]]
		Local $bFound = False
		For $iIndex = 1 To $aFolders[0][0]
			If $iItemType = $aFolders[$iIndex][0] Then
				$iFolderType = $aFolders[$iIndex][1]
				$bFound = True
				ExitLoop
			EndIf
		Next
		If $bFound = False Then SetError(6, 0, "")
	EndIf
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If $sFolder = "" Or (StringLeft($sFolder, 1) = "\" And _ ; No folder specified. Use default folder depending on $iFolderType
			StringMid($sFolder, 2, 1) <> "\") Then ; Folder starts with "\" = subfolder in default folder depending on $iFolderType
		If $iFolderType = Default Or Not IsNumber($iFolderType) Then Return SetError(1, 0, "") ; Required $iFolderType is missing
		$oFolder = $oNamespace.GetDefaultFolder($iFolderType)
		If @error Or Not IsObj($oFolder) Then Return SetError(3, @error, "")
		If $sFolder <> "" Then
			$aFolders = StringSplit(StringMid($sFolder, 2), "\")
			SetError(0) ; Reset @error possibly set by StringSplit
			For $iIndex = 1 To $aFolders[0]
				$oFolder = $oFolder.Folders($aFolders[$iIndex])
				If @error Or Not IsObj($oFolder) Then Return SetError(4, $iIndex, "")
			Next
		EndIf
	Else
		If StringLeft($sFolder, 2) = "\\" Then ; Access a folder of another user
			If $iFolderType = Default Or Not IsNumber($iFolderType) Then Return SetError(1, 0, "") ; Required $iFolderType is missing
			$aFolders = StringSplit(StringMid($sFolder, 3), "\") ; Split off Recipient
			SetError(0) ; Reset @error possibly set by StringSplit
			If $aFolders[1] = "*" Then $aFolders[1] = $oOL.GetNameSpace("MAPI").CurrentUser.Name
			Local $oDummy = $oNamespace.CreateRecipient("=" & $aFolders[1]) ; Create Recipient. "=" sets resolve to strict
			$oDummy.Resolve ; Resolve
			If Not $oDummy.Resolved Then Return SetError(2, 0, "")
			If $aFolders[0] > 1 And StringStripWS($aFolders[2], 3) = "" Then ; Access a subfolder of the specified default folder of another user
				$oFolder = $oNamespace.GetSharedDefaultFolder($oDummy, $iFolderType)
				If @error Or Not IsObj($oFolder) Then Return SetError(3, @error, "")
			Else ; Access any folder of another user
				$oFolder = $oNamespace.GetSharedDefaultFolder($oDummy, $iFolderType).Parent
				If @error Or Not IsObj($oFolder) Then Return SetError(3, @error, "")
			EndIf
		Else
			$aFolders = StringSplit($sFolder, "\") ; Folder specified. Split and get the object
			SetError(0) ; Reset @error possibly set by StringSplit
			If $aFolders[1] = "*" Then $aFolders[1] = $oNamespace.GetDefaultFolder($olFolderInbox).Parent.Name
			$oFolder = $oNamespace.Folders($aFolders[1])
			If @error Or Not IsObj($oFolder) Then Return SetError(4, 1, "")
		EndIf
		If $aFolders[0] > 1 Then ; Access subfolders
			For $iIndex = 2 To $aFolders[0]
				If $aFolders[$iIndex] <> "" Then
					$oFolder = $oFolder.Folders($aFolders[$iIndex])
					If @error Or Not IsObj($oFolder) Then Return SetError(4, $iIndex, "")
				EndIf
			Next
		EndIf
	EndIf
	$aResult[1] = $oFolder
	$aResult[2] = $oFolder.DefaultItemType
	$aResult[3] = $oFolder.StoreID
	$aResult[4] = $oFolder.EntryID
	$aResult[5] = $oFolder.FolderPath
	Return $aResult

EndFunc   ;==>_OL_FolderAccess

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderArchiveGet
; Description ...: Returns the auto-archive properties of a folder.
; Syntax.........: _OL_FolderArchiveGet($oFolder)
; Parameters ....: $oFolder - Folder object of the folder to be changed as returned by _OL_FolderAccess
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - AgeFolder:   TRUE: Archive or delete items in the folder as specified
;                  |2 - DeleteItems: TRUE: Delete, instead of archive, items that are older than the aging period
;                  |3 - FileName:    File for archiving aged items
;                  |4 - Granularity: Unit of time for aging, whether archiving is to be calculated in units of months, weeks, or days.
;                  +Valid granularity: 0=Months, 1=Weeks, 2=Days
;                  |5 - Period :     Amount of time in the given granularity. Value between 1 and 999
;                  |6 - Default:     Indicates which settings should be set to the default.
;                  |0: Nothing assumes a default value
;                  |1: Only the file location assumes a default value.
;                  +This is the same as checking Archive this folder using these settings and Move old items to default archive folder in the AutoArchive
;                  +tab of the Properties dialog box for the folder
;                  |3: All settings assume a default value. This is the same as checking Archive items in this folder using default settings in the AutoArchive
;                  +tab of the Properties dialog box for the folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error creating $oStorage. Please check @extended for details
;                  |2 - Error creating $oPA. Please check @extended for details
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderArchiveGet($oFolder)

	Local Const $sProptagURL = "http://schemas.microsoft.com/mapi/proptag/"
	Local Const $sPR_AGING_AGE_FOLDER = $sProptagURL & "0x6857000B"
	Local Const $sPR_AGING_PERIOD = $sProptagURL & "0x36EC0003"
	Local Const $sPR_AGING_GRANULARITY = $sProptagURL & "0x36EE0003"
	Local Const $sPR_AGING_DELETE_ITEMS = $sProptagURL & "0x6855000B"
	Local Const $sPR_AGING_FILE_NAME_AFTER9 = $sProptagURL & "0x6859001E"
	Local Const $sPR_AGING_DEFAULT = $sProptagURL & "0x685E0003"

	Local $aAutoArchive[7] = [6]
	; Create or get solution storage in given folder by message class
	Local $oStorage = $oFolder.GetStorage("IPC.MS.Outlook.AgingProperties", $olIdentifyByMessageClass)
	If @error Or Not IsObj($oStorage) Then Return SetError(1, @error, 0)
	Local $oPA = $oStorage.PropertyAccessor
	If @error Or Not IsObj($oPA) Then Return SetError(2, @error, 0)
	$aAutoArchive[1] = $oPA.GetProperty($sPR_AGING_AGE_FOLDER)
	$aAutoArchive[2] = $oPA.GetProperty($sPR_AGING_GRANULARITY)
	$aAutoArchive[3] = $oPA.GetProperty($sPR_AGING_DELETE_ITEMS)
	$aAutoArchive[4] = $oPA.GetProperty($sPR_AGING_PERIOD)
	$aAutoArchive[5] = $oPA.GetProperty($sPR_AGING_FILE_NAME_AFTER9)
	$aAutoArchive[6] = $oPA.GetProperty($sPR_AGING_DEFAULT)
	Return $aAutoArchive

EndFunc   ;==>_OL_FolderArchiveGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderArchiveSet
; Description ...: Sets the auto-archive properties of a folder and (optional) all subfolders.
; Syntax.........: _OL_FolderArchiveSet($oFolder, $bRecursive, $bAgeFolder[, $bDeleteItems = Default[, $sFileName = Default[, $iGranularity = Default[, $iPeriod = Default[, $iDefault = Default]]]]])
; Parameters ....: $oFolder      - Folder object of the folder to be changed as returned by _OL_FolderAccess
;                  $bRecursive   - TRUE: Set properties for the specified folder and all subfolders
;                  $bAgeFolder   - TRUE: Archive or delete items in the folder as specified
;                  $bDeleteItems - Optional: TRUE: Delete, instead of archive, items that are older than the aging period (default = Default)
;                  $sFileName    - Optional: File for archiving aged items. If this is an empty string, the default archive file, archive.pst, will be used (default = Default)
;                  $iGranularity - Optional: Unit of time for aging, whether archiving is to be calculated in units of months, weeks, or days (default = Default).
;                  +Valid granularity: 0=Months, 1=Weeks, 2=Days
;                  $iPeriod      - Optional: Amount of time in the given granularity. Valid period: 1-999 (default = Default)
;                  $iDefault     - Optional: Indicates which settings should be set to the default (default = Default):
;                  |0: Nothing assumes a default value
;                  |1: Only the file location assumes a default value.
;                  +This is the same as checking Archive this folder using these settings and Move old items to default archive folder in the AutoArchive
;                  +tab of the Properties dialog box for the folder
;                  |3: All settings assume a default value. This is the same as checking Archive items in this folder using default settings in the AutoArchive
;                  +tab of the Properties dialog box for the folder
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oFolder is not an object
;                  |2 - $bRecursive is not boolean
;                  |3 - $bAgeFolder is not boolean
;                  |4 - $bDeleteItems is not boolean
;                  |5 - $iGranularity is not an integer or <0 or > 2
;                  |6 - $iPeriod is not an integer or < 1 or > 999
;                  |7 - $iDefault is not an integer or an invalid number (must be 0, 1 or 3)
;                  |8 - Error creating $oStorage. Please check @extended for details
;                  |9 - Error creating $oPA. Please check @extended for details
;                  |10 - Error saving changed properties. Please check @extended for details
; Author ........: water
; Modified ......:
; Remarks .......: More links:
;                  http://msdn.microsoft.com/en-us/library/ff870123.aspx (Outlook 2010)
;                  https://blogs.msdn.com/b/jmazner/archive/2006/10/30/setting-autoarchive-properties-on-a-folder-hierarchy-in-outlook-2007.aspx?Redirected=true
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/bb176434(v=office.12).aspx (Outlook 2007)
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderArchiveSet($oFolder, $bRecursive, $bAgeFolder, $bDeleteItems = Default, $sFileName = Default, $iGranularity = Default, $iPeriod = Default, $iDefault = Default)

	Local Const $sProptagURL = "http://schemas.microsoft.com/mapi/proptag/"
	Local Const $sPR_AGING_AGE_FOLDER = $sProptagURL & "0x6857000B"
	Local Const $sPR_AGING_PERIOD = $sProptagURL & "0x36EC0003"
	Local Const $sPR_AGING_GRANULARITY = $sProptagURL & "0x36EE0003"
	Local Const $sPR_AGING_DELETE_ITEMS = $sProptagURL & "0x6855000B"
	Local Const $sPR_AGING_FILE_NAME_AFTER9 = $sProptagURL & "0x6859001E"
	Local Const $sPR_AGING_DEFAULT = $sProptagURL & "0x685E0003"

	If Not IsObj($oFolder) Then Return SetError(1, 0, 0)
	If Not IsBool($bRecursive) Then Return SetError(2, 0, 0)
	If Not IsBool($bAgeFolder) Then Return SetError(3, 0, 0)
	If $bDeleteItems <> Default And Not IsBool($bDeleteItems) Then Return SetError(4, 0, 0)
	If $iGranularity <> Default And Not IsInt($iGranularity) Or $iGranularity < 0 Or $iGranularity > 2 Then Return SetError(5, 0, 0)
	If $iPeriod <> Default And (Not IsInt($iPeriod) Or $iPeriod < 1 Or $iPeriod > 999) Then Return SetError(6, 0, 0)
	If $iDefault <> Default And (Not IsInt($iDefault) Or ($iDefault <> 0 And $iDefault <> 1 And $iDefault <> 3)) Then Return SetError(7, 0, 0)
	; Create or get solution storage in given folder by message class
	Local $oStorage = $oFolder.GetStorage("IPC.MS.Outlook.AgingProperties", $olIdentifyByMessageClass)
	If @error Or Not IsObj($oStorage) Then Return SetError(8, @error, 0)
	Local $oPA = $oStorage.PropertyAccessor
	If @error Or Not IsObj($oPA) Then Return SetError(9, @error, 0)
	; Set the 6 aging properties in the solution storage
	$oPA.SetProperty($sPR_AGING_AGE_FOLDER, $bAgeFolder)
	If $iGranularity <> Default Then $oPA.SetProperty($sPR_AGING_GRANULARITY, $iGranularity)
	If $bDeleteItems <> Default Then $oPA.SetProperty($sPR_AGING_DELETE_ITEMS, $bDeleteItems)
	If $iPeriod <> Default Then $oPA.SetProperty($sPR_AGING_PERIOD, $iPeriod)
	If $sFileName <> Default Then $oPA.SetProperty($sPR_AGING_FILE_NAME_AFTER9, $sFileName)
	If $iDefault <> Default Then $oPA.SetProperty($sPR_AGING_DEFAULT, $iDefault)
	; Save changes as hidden messages to the associated portion of the folder
	$oStorage.Save
	If @error Then Return SetError(10, @error, 0)
	; Process subfolders
	If $bRecursive Then
		For $oSubFolder In $oFolder.Folders
			_OL_FolderArchiveSet($oSubFolder, $bRecursive, $bAgeFolder, $bDeleteItems, $sFileName, $iGranularity, $iPeriod, $iDefault)
			If @error Then Return SetError(@error, @extended, 0)
		Next
	EndIf
	Return 1

EndFunc   ;==>_OL_FolderArchiveSet

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderCopy
; Description ...: Copies a folder, all subfolders and all contained items.
; Syntax.........: _OL_FolderCopy($oOL, $vSourceFolder, $vTargetFolder)
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vSourceFolder - Source folder name or object of the folder to be copied
;                  $vTargetFolder - Target folder name or object of the folder to be copied to
; Return values .: Success - Folder object of the copied folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the specified source folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |2 - Error accessing the specified target folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |3 - Source folder has not been specified or is empty
;                  |4 - Target folder has not been specified or is empty
;                  |5 - Source and target folder are the same
;                  |6 - Error copying the folder to the target folder. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderCopy($oOL, $vSourceFolder, $vTargetFolder)

	Local $aTemp
	If Not IsObj($vSourceFolder) Then
		If StringStripWS($vSourceFolder, 3) = "" Then Return SetError(3, 0, 0)
		$aTemp = _OL_FolderAccess($oOL, $vSourceFolder)
		If @error Then Return SetError(1, @error, 0)
		$vSourceFolder = $aTemp[1]
	EndIf
	If Not IsObj($vTargetFolder) Then
		If StringStripWS($vTargetFolder, 3) = "" Then Return SetError(4, 0, 0)
		$aTemp = _OL_FolderAccess($oOL, $vTargetFolder)
		If @error Then Return SetError(2, @error, 0)
		$vTargetFolder = $aTemp[1]
	EndIf
	If $vSourceFolder = $vTargetFolder Then Return SetError(5, 0, 0)
	Local $vFolder = $vSourceFolder.CopyTo($vTargetFolder)
	If @error Then Return SetError(6, @error, 0)
	Return $vFolder

EndFunc   ;==>_OL_FolderCopy

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderCreate
; Description ...: Creates a folder and subfolders.
; Syntax.........: _OL_FolderCreate($oOL, $sFolder, $iFolderType[, $vStartFolder = ""])
; Parameters ....: $oOL          - Outlook object returned by a preceding call to _OL_Open()
;                  $sFolder      - Folder(s) to be created
;                  $iFolderType  - Type of folder(s) to be created. Is defined by the Outlook OlDefaultFolders enumeration
;                  $vStartFolder - Optional: Folder object as returned by _OL_FolderAccess or full name of folder to create the new
;                  +folder in (default is root folder)
; Return values .: Success - Folder object of the created folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - $iFolderType is missing or not a number
;                  |2 - Folder could not be created. See @extended for COM error code
;                  |3 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
;                  |4 - Folder already exists
;                  |5 - Error adding folder. See @extended for the error code of the Add method
; Author ........: water
; Modified.......:
; Remarks .......: The folder and subfolders all have the same type specified by $iFolderType.
;                  To set properties of a folder please use _OL_FolderModfiy
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderCreate($oOL, $sFolder, $iFolderType, $vStartFolder = "")

	If Not IsNumber($iFolderType) Then Return SetError(1, 0, 0) ; Required $iFolderType is missing
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If Not IsObj($vStartFolder) Then
		If StringStripWS($vStartFolder, 3) = "" Then ; Startfolder is not specified - use root folder
			Local $oInbox = $oNamespace.GetDefaultFolder($olFolderInbox)
			$vStartFolder = $oInbox.Parent
		Else
			Local $aTemp = _OL_FolderAccess($oOL, $vStartFolder)
			If @error Then Return SetError(3, @error, 0)
			$vStartFolder = $aTemp[1]
		EndIf
	EndIf
	Local $aSubFolders = StringSplit($sFolder, "\")
	SetError(0)
	For $iIndex = 1 To $aSubFolders[0]
		; Check if folder already exists
		For $oFolder In $vStartFolder.Folders
			If $oFolder.Name = $aSubFolders[$iIndex] Then Return SetError(4, 0, 0)
		Next
		$vStartFolder = $vStartFolder.Folders.Add($aSubFolders[$iIndex], $iFolderType)
		If @error Or Not IsObj($vStartFolder) Then Return SetError(5, @error, 0)
	Next
	Return $vStartFolder

EndFunc   ;==>_OL_FolderCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderDelete
; Description ...: Deletes a folder, all subfolders and all contained items.
; Syntax.........: _OL_FolderDelete($oOL, $sFolder[, $iFlags = 0])
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Folder object as returned by _OL_FolderAccess or full name of folder to be deleted
;                  $iFlags  - Optional: Specifies what should be deleted. Can be a combination of the following:
;                  |0: Deletes the folder, all subfolders and all contained items (default)
;                  |1: Deletes all items (but no folders) in the specified folder
;                  |2: Recursively deletes all items (but no folders) in the specified folder and all subfolders
;                  |4: Deletes all subfolders and their items in the specified folder (but not the items in the specified folder)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
;                  |2 - Folder could not be deleted. See @extended for COM error code
;                  |3 - Folder has not been specified or is empty
;                  |4 - Subfolder could not be deleted. See @extended for COM error code
;                  |5 - Item could not be deleted. See @extended for COM error code
; Author ........: water
; Modified.......:
; Remarks .......: Flag usage:
;                  To empty the trash folder (or any Outlook system folder) and delete all items plus all subfolders use $iFlags = 5
;                  To delete all items in all folders and subfolders but retain the folder structure use $iFlags = 3
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderDelete($oOL, $vFolder, $iFlags = 0)

	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then Return SetError(3, 0, 0)
		Local $aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(1, @error, 0)
		$vFolder = $aTemp[1]
	EndIf
	; Delete the folder, all subfolders and all contained items
	If $iFlags = 0 Then
		$vFolder.Delete
		If @error Then Return SetError(2, @error, 0)
		Return 1
	EndIf
	; Delete items recursively
	If BitAND($iFlags, 2) = 2 Then
		For $oSubFolder In $vFolder.Folders
			$aTemp = _OL_FolderDelete($oOL, $oSubFolder, $iFlags)
			If @error Then Return SetError(2, @error, "")
		Next
	EndIf
	; Just delete all items in the specified folder
	If BitAND($iFlags, 1) = 1 Or BitAND($iFlags, 2) = 2 Then
		For $iIndex = $vFolder.Items.Count To 1 Step -1
			$vFolder.Items($iIndex).Delete
			If @error Then Return SetError(5, @error, 0)
		Next
	EndIf
	; Delete all subfolders and all contained items
	If BitAND($iFlags, 4) = 4 Then
		For $iIndex = $vFolder.Folders.Count To 1 Step -1
			$vFolder.Folders($iIndex).Delete
			If @error Then Return SetError(4, @error, 0)
		Next
	EndIf
	Return 1

EndFunc   ;==>_OL_FolderDelete

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderExists
; Description ...: Checks if the specified folder exists.
; Syntax.........: _OL_FolderExists($oOL, $sFolder)
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $sFolder - Full name of folder to be checked
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderExists($oOL, $sFolder)

	_OL_FolderAccess($oOL, $sFolder)
	If @error Then Return SetError(1, @error, 0)
	Return 1

EndFunc   ;==>_OL_FolderExists

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderFind
; Description ...: Finds folders filtered by name and/or default item type.
; Syntax.........: _OL_FolderFind($oOL, $vFolder[, $iRecursionlevel = 0[, $sFolderName = ""[, $iStringMatch = 1[, $iDefaultItemType = Default]]]])
; Parameters ....: $oOL               - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder           - Folder object as returned by _OL_FolderAccess or full name of folder where the search will be started.
;                  +If you want to search a default folder you have to specify the folder object.
;                  $iRecursionlevel   - Optional: Number of subfolders to search. 0 means only the specified folder is searched (default = 0)
;                  $sFolderName       - Optional: String to search for in the folder name. The matching mode (exact or substring) is specified by the next parameter (default = "")
;                  +Can be combined with $iDefaultItemType
;                  $iStringMatch      - Optional: Matching mode (default = 1). Can be one of the following:
;                  |  1: Exact match
;                  |  2: Substring
;                  $iDefaultItemType  - Optional: Only return folders which can hold items of the following item type. Is defined by the Outlook OlItemType enumeration.
;                  +Can be combined with $sFolderName (default = Default)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Object of the folder
;                  |1 - FolderPath
;                  |2 - Name
;                  Failure - Returns "" and sets @error:
;                  |1 - $sFolderName and $iDefaultItemType have not been set
;                  |2 - Error accessing the specified folder. See @extended for errorcode returned by _OL_FolderAccess
; Author ........: water
; Modified ......:
; Remarks .......: You have to specify at least $sFolderName or $iDefaultItemType
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderFind($oOL, $vFolder, $iRecursionlevel = 0, $sFolderName = "", $iStringMatch = 1, $iDefaultItemType = Default)

	Local $iIndex1 = 1, $aTemp, $bFound
	If $vFolder = "" And $iDefaultItemType = Default Then Return SetError(1, 0, "")
	If Not IsObj($vFolder) Then
		$aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(2, @error, "")
		$vFolder = $aTemp[1]
	EndIf
	Local $aFolders[$vFolder.Folders.Count + 1][3]
	For $vFolder In $vFolder.Folders
		$bFound = False
		If $sFolderName <> "" Then
			If $iStringMatch = 1 And $vFolder.Name == $sFolderName Then $bFound = True
			If $iStringMatch = 2 And StringInStr($vFolder.Name, $sFolderName) > 0 Then $bFound = True
		EndIf
		If $iDefaultItemType <> Default And $vFolder.DefaultItemType = $iDefaultItemType Then $bFound = True
		If $bFound Then
			$aFolders[$iIndex1][0] = $vFolder
			$aFolders[$iIndex1][1] = $vFolder.FolderPath
			$aFolders[$iIndex1][2] = $vFolder.Name
			$iIndex1 += 1
		EndIf
		If $iRecursionlevel > 0 Then
			$aTemp = _OL_FolderFind($oOL, $vFolder, $iRecursionlevel - 1, $sFolderName, $iStringMatch, $iDefaultItemType)
			__OL_ArrayConcatenate($aFolders, $aTemp, 0)
		EndIf
	Next
	If UBound($aFolders, 1) > 1 Then
		_ArraySort($aFolders, 1, 1, 0, 1)
		For $iIndex1 = 1 To UBound($aFolders, 1) - 1
			If $aFolders[$iIndex1][0] = "" Then
				ReDim $aFolders[$iIndex1][UBound($aFolders, 2)]
				ExitLoop
			EndIf
		Next
		_ArraySort($aFolders, 0, 1, 0, 1)
	EndIf
	$aFolders[0][0] = UBound($aFolders, 1) - 1
	$aFolders[0][1] = UBound($aFolders, 2)
	Return $aFolders

EndFunc   ;==>_OL_FolderFind

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderGet
; Description ...: Returns information about the current or any other folder.
; Syntax.........: _OL_FolderGet($oOL[, $vFolder = ""])
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Optional: Folder object as returned by _OL_FolderAccess or full name of folder (default = "" = current folder)
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1  - Object to the folder
;                  |2  - Default item type (integer) for the specified folder. Defined by the Outlook OlItemType enumeration
;                  |3  - StoreID (string) of the store to access the folder by ID
;                  |4  - EntryID (string) of the folder to access the folder by ID
;                  |5  - Display name of the folder
;                  |6  - The path of the selected folder
;                  |7  - Number of unread items in the folder
;                  |8  - Total number of items in the folder
;                  |9  - Address Book Name for a contacts folder
;                  |10 - Determines which views are displayed on the View menu
;                  |11 - Default message class for items in the folder
;                  |12 - Description of the folder
;                  |13 - Determines if the folder will be synchronized with the e-mail server
;                  |14 - Determines if the folder is a Microsoft SharePoint Server folder
;                  |15 - Specifies if the contact items folder will be displayed as an address list in the Outlook Address Book
;                  |16 - Indicates if to display the number of unread messages in the folder or the total number of items in the folder in the Navigation Pane
;                  |17 - Indicates the Web view state for the folder
;                  |18 - URL of the Web page that is assigned with the folder
;                  Failure - Returns "" and sets @error:
;                  |1 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
; Author ........: water
; Modified.......:
; Remarks .......: The current folder is the one displayed in the active explorer
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderGet($oOL, $vFolder = "")

	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then
			$vFolder = $oOL.ActiveExplorer.CurrentFolder
		Else
			Local $aTemp = _OL_FolderAccess($oOL, $vFolder)
			If @error Then Return SetError(1, @error, 0)
			$vFolder = $aTemp[1]
		EndIf
	EndIf
	Local $aFolder[19] = [18]
	$aFolder[1] = $vFolder
	$aFolder[2] = $vFolder.DefaultItemType
	$aFolder[3] = $vFolder.StoreID
	$aFolder[4] = $vFolder.EntryID
	$aFolder[5] = $vFolder.Name
	$aFolder[6] = $vFolder.FolderPath
	$aFolder[7] = $vFolder.UnReadItemCount
	$aFolder[8] = $vFolder.Items.Count
	$aFolder[9] = $vFolder.AddressBookName
	$aFolder[10] = $vFolder.CustomViewsOnly
	$aFolder[11] = $vFolder.DefaultMessageClass
	$aFolder[12] = $vFolder.Description
	$aFolder[13] = $vFolder.InAppFolderSyncObject
	$aFolder[14] = $vFolder.IsSharePointFolder
	$aFolder[15] = $vFolder.ShowAsOutlookAB
	$aFolder[16] = $vFolder.ShowItemCount
	$aFolder[17] = $vFolder.WebViewOn
	$aFolder[18] = $vFolder.WebViewURL
	Return $aFolder

EndFunc   ;==>_OL_FolderGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderModify
; Description ...: Modifies the properties of a folder.
; Syntax.........: _OL_FolderModify($oOL, $vFolder[, $sAddressBookName = ""[, $bCustomViewsOnly = Default[, $sDescription = ""[, $bInAppFolderSyncObject = Default[, $sName = ""[, $bShowAsOutlookAB = Default[, $iShowItemCount = Default[, $bWebViewOn = Default[, $sWebViewURL = ""]]]]]]]]])
; Parameters ....: $oOL                    - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder                - Folder object as returned by _OL_FolderAccess or full name of folder to modify
;                  $sAddressBookName       - Address Book name if the folder represents a contacts folder (default = "" = do not change property)
;                  $bCustomViewsOnly       - True/False. Determines which views are displayed on the view menu (default = keyword "Default" = do not change property)
;                  $sDescription           - Description of the folder (default = "" = do not change property)
;                  $bInAppFolderSyncObject - True/False. Determines if the folder will be synchronized with the e-mail server. (default = keyword "Default" = do not change property)
;                  $sName                  - Display name for the folder (default = "" = do not change property)
;                  $bShowAsOutlookAB       - True/False. Specifies whether the folder will be displayed as an address list in the Outlook Address Book (folder thas to be a contacts folder) (default = keyword "Default" = do not change property)
;                  $iShowItemCount         - OlShowItemCount enumeration. Indicates the itemcount to display - if any (default = keyword "Default" = do not change property)
;                  $bWebViewOn             - True/False. Indicates the web view state (default = keyword "Default" = do not change property)
;                  $sWebViewURL            - URL of the Web page for this folder (default = "" = do not change property)
; Return values .: Success - Folder object of the created folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - $vFolder has not been specified
;                  |2 - Error accessing the specified folder. See @extended for errorcode returned by GetFolderFromID
;                  |3 - Error setting propery $sAddressBookName. See @extended for more details
;                  |4 - Error setting propery $bCustomViewsOnly. See @extended for more details
;                  |5 - Error setting propery $sDescription. See @extended for more details
;                  |6 - Error setting propery $bInAppFolderSyncObject. See @extended for more details
;                  |7 - Error setting propery $sName. See @extended for more details
;                  |8 - Error setting propery $bShowAsOutlookAB. See @extended for more details
;                  |9 - Error setting propery $iShowItemCount. See @extended for more details
;                  |10 - Error setting propery $bWebViewOn. See @extended for more details
;                  |11 - Error setting propery $sWebViewURL. See @extended for more details
; Author ........: water
; Modified ......:
; Remarks .......: To reset a string property set the corresponding value to " ".
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderModify($oOL, $vFolder, $sAddressBookName = "", $bCustomViewsOnly = Default, $sDescription = "", $bInAppFolderSyncObject = Default, $sName = "", $bShowAsOutlookAB = Default, $iShowItemCount = Default, $bWebViewOn = Default, $sWebViewURL = "")

	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then Return SetError(1, 0, 0)
		Local $aFolder = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(2, @error, 0)
		$vFolder = $aFolder[1]
	EndIf
	If $sAddressBookName <> "" Then
		$vFolder.AddressBookName = $sAddressBookName
		If @error Then Return SetError(3, @error, 0)
	EndIf
	If $bCustomViewsOnly <> Default Then
		$vFolder.CustomViewsOnly = $bCustomViewsOnly
		If @error Then Return SetError(4, @error, 0)
	EndIf
	If $sDescription <> "" Then
		$vFolder.Description = $sDescription
		If @error Then Return SetError(5, @error, 0)
	EndIf
	If $bInAppFolderSyncObject <> Default Then
		$vFolder.InAppFolderSyncObject = $bInAppFolderSyncObject
		If @error Then Return SetError(6, @error, 0)
	EndIf
	If $sName <> "" Then
		$vFolder.Name = $sName
		If @error Then Return SetError(7, @error, 0)
	EndIf
	If $bShowAsOutlookAB <> Default Then
		$vFolder.ShowAsOutlookAB = $bShowAsOutlookAB
		If @error Then Return SetError(8, @error, 0)
	EndIf
	If $iShowItemCount <> Default Then
		$vFolder.ShowItemCount = $iShowItemCount
		If @error Then Return SetError(9, @error, 0)
	EndIf
	If $bWebViewOn <> Default Then
		$vFolder.WebViewOn = $bWebViewOn
		If @error Then Return SetError(10, @error, 0)
	EndIf
	If $sWebViewURL <> "" Then
		$vFolder.WebViewURL = $sWebViewURL
		If @error Then Return SetError(11, @error, 0)
	EndIf
	Return $vFolder

EndFunc   ;==>_OL_FolderModify

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderMove
; Description ...: Moves a folder plus subfolders to a new target folder.
; Syntax.........: _OL_FolderMove($oOL, $vSourceFolder, $vTargetFolder)
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vSourceFolder - Folder object as returned by _OL_FolderAccess or full name of folder to move
;                  $vTargetFolder - Folder object as returned by _OL_FolderAccess or full name of folder to move to
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the specified source folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |2 - Error accessing the specified target folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |3 - Source folder has not been specified or is empty
;                  |4 - Target folder has not been specified or is empty
;                  |5 - Source and target folder are the same
;                  |6 - Error moving the folder to the target folder. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderMove($oOL, $vSourceFolder, $vTargetFolder)

	Local $aTemp
	If Not IsObj($vSourceFolder) Then
		If StringStripWS($vSourceFolder, 3) = "" Then Return SetError(3, 0, 0)
		$aTemp = _OL_FolderAccess($oOL, $vSourceFolder)
		If @error Then Return SetError(1, @error, 0)
		$vSourceFolder = $aTemp[1]
	EndIf
	If Not IsObj($vTargetFolder) Then
		If StringStripWS($vTargetFolder, 3) = "" Then Return SetError(4, 0, 0)
		$aTemp = _OL_FolderAccess($oOL, $vTargetFolder)
		If @error Then Return SetError(2, @error, 0)
		$vTargetFolder = $aTemp[1]
	EndIf
	If $vSourceFolder = $vTargetFolder Then Return SetError(5, 0, 0)
	$vSourceFolder.MoveTo($vTargetFolder)
	If @error Then Return SetError(6, @error, 0)
	Return 1

EndFunc   ;==>_OL_FolderMove

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderRename
; Description ...: Renames a folder.
; Syntax.........: _OL_FolderRename($oOL, $sFolder, $sName)
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Folder object as returned by _OL_FolderAccess or full name of folder to be renamed
;                  $sName   - New display name of the folder
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
;                  |2 - Folder could not be renamed. See @extended for COM error code
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderRename($oOL, $vFolder, $sName)

	If Not IsObj($vFolder) Then
		Local $aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(1, @error, 0)
		$vFolder = $aTemp[1]
	EndIf
	$vFolder.Name = $sName
	If @error Then Return SetError(2, @error, 0)
	Return 1

EndFunc   ;==>_OL_FolderRename

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderSelectionGet
; Description ...: Returns all items selected in the active explorer (folder).
; Syntax.........: _OL_FolderSelectionGet($oOL)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Object of the selected item
;                  |1 - EntryID of the selected item
;                  |2 - OlObjectClass constant indicating the object's class
;                  Failure - Returns "" and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - Error accessing the selected folder or no folder was selected. See @extended for the error code of method ActiveExplorer.Selection
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderSelectionGet($oOL)

	If Not IsObj($oOL) Then Return SetError(1, 0, "")
	Local $oSelection = $oOL.ActiveExplorer.Selection
	If @error Or Not IsObj($oSelection) Then Return SetError(2, @error, 0)
	Local $aSelection[$oSelection.Count + 1][3] = [[$oSelection.Count, 2]]
	For $iIndex = 1 To $oSelection.Count
		$aSelection[$iIndex][0] = $oSelection.Item($iIndex)
		$aSelection[$iIndex][1] = $oSelection.Item($iIndex).EntryId
		$aSelection[$iIndex][2] = $oSelection.Item($iIndex).Class
	Next
	Return $aSelection

EndFunc   ;==>_OL_FolderSelectionGet

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_FolderSet
; Description ...: Sets a new folder as the current folder.
; Syntax.........: _OL_FolderSet($oOL, $vFolder)
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Folder object as returned by _OL_FolderAccess or full name of folder that will become the new current folder
; Return values .: Success - Object of the folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - Folder has not been specified or is empty
;                  |2 - Error accessing specified folder. See @extended for the error code of _OL_AccessFolder
;                  |3 - Error setting the current folder. See @extended for more error information
; Author ........: water
; Modified.......:
; Remarks .......: The current folder is the one displayed in the active explorer
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderSet($oOL, $vFolder)

	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then Return SetError(1, 0, 0)
		Local $aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(2, @error, 0)
		$vFolder = $aTemp[1]
	EndIf
	$oOL.ActiveExplorer.CurrentFolder = $vFolder
	If @error Then Return SetError(3, @error, 0)
	Return $vFolder

EndFunc   ;==>_OL_FolderSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderTree
; Description ...: Returns all folders and subfolders starting with a specified folder.
; Syntax.........: _OL_FolderTree($oOL, $vFolder[, $iLevel = 9999])
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Folder object as returned by _OL_FolderAccess or full name of folder to start
;                  $iLevel  - Optional: Number of levels to list (default = 9999).
;                  |1 = just the level specified in $vFolder
;                  |2 = The level specified in $vFolder plus the next level
; Return values .: Success - one-dimensional zero based array with the folderpath of each folder
;                  Failure - Returns "" and sets @error:
;                  |1 - Source folder has not been specified or is empty
;                  |2 - Error accessing a folder. See @extended for errorcode returned by _OL_FolderAccess
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderTree($oOL, $vFolder, $iLevel = 9999)

	Local $aTemp, $aFolderTree[1]
	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then Return SetError(1, 0, "")
		$aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(2, @error, "")
		$vFolder = $aTemp[1]
	EndIf
	$aFolderTree[0] = $vFolder.FolderPath
	$iLevel = $iLevel - 1
	If $iLevel > 0 Then
		For $oFolder In $vFolder.Folders
			$aTemp = _OL_FolderTree($oOL, $oFolder, $iLevel)
			If @error Then Return SetError(2, @error, "")
			_ArrayConcatenate($aFolderTree, $aTemp)
		Next
	EndIf
	Return $aFolderTree

EndFunc   ;==>_OL_FolderTree

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_Item2Task
; Description ...: Marks an item as a task and assigns a task interval for the item.
; Syntax.........: _OL_Item2Task($oOL, $vItem, $sStoreID, $iInterval)
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem     - EntryID or object of the item
;                  $sStoreID  - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $iInterval - Time period for which the item is marked as a task. Defined by the $OlMarkInterval Enumeration
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No Outlook item specified
;                  |2 - Item could not be found. EntryID might be wrong. Check @extended for more information
;                  |3 - $iInterval is not a number
;                  |4 - Method MarkAsTask returned an error. Check @extended for more information
; Author ........: water
; Modified ......:
; Remarks .......: This function sets the value of several other properties, depending on the value provided in $iInterval.
;                  For more information about the properties set see the link below (OlMarkInterval Enumeration)
;                  +
;                  To change this or set further properties please call _OL_ItemModify
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/bb208108(v=office.12).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _OL_Item2Task($oOL, $vItem, $sStoreID, $iInterval)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If Not IsInt($iInterval) Then SetError(3, 0, 0)
	$vItem.MarkAsTask($iInterval)
	If @error Then Return SetError(4, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_Item2Task

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemAttachmentAdd
; Description ...: Adds one or more attachments to an item.
; Syntax.........: _OL_ItemAttachmentAdd($oOL, $vItem, $sStoreID, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""[, $sDelimiter = ","]]]]]]]]]])
; Parameters ....: $oOL        - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem      - EntryID or object of the item
;                  $sStoreID   - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vP1        - The source of the attachment. This can be a file (represented by the full file system path (drive letter or UNC path) with a file name) or an
;                  +Outlook item (EntryId or object) that constitutes the attachment
;                  +or a zero based one-dimensional array with unlimited number of attachments.
;                  |Every attachment parameter can consist of up to 4 sub-parameters separated by commas or parameter $sDelimiter:
;                  | 1 - Source: The source of the attachment as described above
;                  | 2 - (Optional) Type: The type of the attachment. Can be one of the OlAttachmentType constants (default = $olByValue)
;                  | 3 - (Optional) Position: For RTF format. Position where the attachment should be placed within the body text (default = Beginning of the item)
;                  | 4 - (Optional) DisplayName: For RTF format and Type = $olByValue. Name is displayed in an Inspector object or when viewing the properties of the attachment
;                  $vP2        - Optional: Same as $vP1 but no array is allowed
;                  $vP3        - Optional: Same as $vP2
;                  $vP4        - Optional: Same as $vP2
;                  $vP5        - Optional: Same as $vP2
;                  $vP6        - Optional: Same as $vP2
;                  $vP7        - Optional: Same as $vP2
;                  $vP8        - Optional: Same as $vP2
;                  $vP9        - Optional: Same as $vP2
;                  $vP10       - Optional: Same as $vP2
;                  $sDelimiter - Optional: Delimiter to separate the sub-parameters of the attachment parameters $vP1 - $vP10 (default = ",")
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No Outlook item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error adding attachment to the item list. @extended = number of the invalid attachment (zero based)
;                  |4 - Attachment could not be found. @extended = number of the invalid attachment (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of attachments.
;                  For more details about sub-parameters 2-4 please check MSDN for the Attachments.Add method
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemAttachmentAdd($oOL, $vItem, $sStoreID, $vP1, $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "", $sDelimiter = ",")

	Local $aAttachments[10]
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move attachments into an array
	If Not IsArray($vP1) Then
		$aAttachments[0] = $vP1
		$aAttachments[1] = $vP2
		$aAttachments[2] = $vP3
		$aAttachments[3] = $vP4
		$aAttachments[4] = $vP5
		$aAttachments[5] = $vP6
		$aAttachments[6] = $vP7
		$aAttachments[7] = $vP8
		$aAttachments[8] = $vP9
		$aAttachments[9] = $vP10
	Else
		$aAttachments = $vP1
	EndIf
	; add attachments to the item
	For $iIndex = 0 To UBound($aAttachments) - 1
		Local $aTemp = StringSplit($aAttachments[$iIndex], $sDelimiter)
		ReDim $aTemp[5] ; Make sure the array has 4 elements (element 2-4 might be empty)
		If StringMid($aTemp[1], 2, 1) = ":" Or StringLeft($aTemp[1], 2) = "\\" Then ; Attachment specified as file (drive letter or UNC path)
			If Not FileExists($aTemp[1]) Then Return SetError(4, $iIndex, 0)
		ElseIf Not IsObj($aTemp[1]) Then ; Attachment specified as EntryID
			If StringStripWS($aAttachments[$iIndex], 3) = "" Then ContinueLoop
			$aTemp[1] = $oOL.Session.GetItemFromID($aTemp[1], $sStoreID)
			If @error Then Return SetError(4, $iIndex, 0)
		EndIf
		If $aTemp[2] = "" Then $aTemp[2] = $olByValue ; The attachment is a copy of the original file
		If $aTemp[3] = "" Then $aTemp[3] = 1 ; The attachment should be placed at the beginning of the message body
		$vItem.Attachments.Add($aTemp[1], $aTemp[2], $aTemp[3], $aTemp[4])
		If @error Then Return SetError(3, $iIndex, 0)
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_ItemAttachmentAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemAttachmentDelete
; Description ...: Deletes one or multiple attachments from an item.
; Syntax.........: _OL_ItemAttachmentDelete($oOL, $vItem, $sStoreID, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""]]]]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vP1      - Number of the attachment to delete from the attachments collection
;                  +or a zero based one-dimensional array with unlimited number of attachments
;                  $vP2      - Optional: Number of the attachment to delete from the attachments collection
;                  $vP3      - Optional: Same as $vP2
;                  $vP4      - Optional: Same as $vP2
;                  $vP5      - Optional: Same as $vP2
;                  $vP6      - Optional: Same as $vP2
;                  $vP7      - Optional: Same as $vP2
;                  $vP8      - Optional: Same as $vP2
;                  $vP9      - Optional: Same as $vP2
;                  $vP10     - Optional: Same as $vP2
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error removing attachment from the item. @extended = number of the invalid attachment parameter (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of numbers
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemAttachmentDelete($oOL, $vItem, $sStoreID, $vP1 = "", $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "")

	Local $aAttachments[10]
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move numbers into an array
	If Not IsArray($vP1) Then
		$aAttachments[0] = $vP1
		$aAttachments[1] = $vP2
		$aAttachments[2] = $vP3
		$aAttachments[3] = $vP4
		$aAttachments[4] = $vP5
		$aAttachments[5] = $vP6
		$aAttachments[6] = $vP7
		$aAttachments[7] = $vP8
		$aAttachments[8] = $vP9
		$aAttachments[9] = $vP10
	Else
		$aAttachments = $vP1
	EndIf
	; Delete attachments from the item
	For $iIndex = 0 To UBound($aAttachments) - 1
		If StringStripWS($aAttachments[$iIndex], 3) = "" Then ContinueLoop
		$vItem.Attachments.Remove($aAttachments[$iIndex])
		If @error Then Return SetError(3, $iIndex, 0)
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_ItemAttachmentDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemAttachmentGet
; Description ...: Returns a list of attachments of an item.
; Syntax.........: _OL_ItemAttachmentGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = users mailbox)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Object to the attachment
;                  |1 - DisplayName: String representing the name, which does not need to be the actual file name, displayed below the icon representing the embedded attachment
;                  |2 - FileName: String representing the file name of the attachment
;                  |3 - PathName: String representing the full path to the linked attached file
;                  |4 - Position: Integer indicating the position of the attachment within the body of the item
;                  |5 - Size: Integer indicating the size (in bytes) of the attachment
;                  |6 - Type: OlAttachmentType constant indicating the type of the specified object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No Outlook item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no attachments
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemAttachmentGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If $vItem.Attachments.Count = 0 Then Return SetError(3, 0, 0)
	Local $aAttachments[$vItem.Attachments.Count + 1][7] = [[$vItem.Attachments.Count, 7]]
	Local $iIndex = 1
	For $oAttachment In $vItem.Attachments
		$aAttachments[$iIndex][0] = $oAttachment
		$aAttachments[$iIndex][1] = $oAttachment.DisplayName
		$aAttachments[$iIndex][2] = $oAttachment.FileName
		$aAttachments[$iIndex][3] = $oAttachment.PathName
		$aAttachments[$iIndex][4] = $oAttachment.Position
		$aAttachments[$iIndex][5] = $oAttachment.Size
		$aAttachments[$iIndex][6] = $oAttachment.Type
		$iIndex += 1
	Next
	Return $aAttachments

EndFunc   ;==>_OL_ItemAttachmentGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemAttachmentSave
; Description ...: Saves a single attachment of an item in the specified path.
; Syntax.........: _OL_ItemAttachmentSave($oOL, $vItem, $sStoreID, $iAttachment, $sPath)
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem       - EntryID or object of the item of which to save the attachment
;                  $sStoreID    - StoreID of the source store as returned by _OL_FolderAccess. Use the keyword "Default" to use the users mailbox
;                  $iAttachment - Number of the attachment to save as returned by _OL_ItemAttachmentGet (one based)
;                  $sPath       - Path (drive, directory[, filename]) where to save the item.
;                                 If filename or extension is missing it is set to the filename/extension of the attachment.
;                                 In this case the directory needs a trailing backslash.
;                                 If the directory does not exist it is created
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $sPath is missing
;                  |2 - Specified directory does not exist. It could not be created
;                  |3 - Specified item could not be found
;                  |4 - Output file already exists
;                  |5 - Error saving an attachment. For details check @extended
;                  |6 - No item has been specified
;                  |7 - $sPath not specified completely. Drive, dir, name or extension is missing
;                  |8 - $iAttachment is either not numeric or < 1 or > # of attachments as returned by _OL_ItemAttachmentGet. @extended is the number of attachments
; Author ........: water
; Modified ......:
; Remarks .......: If the file you want the attachment to be saved already exists an error is returned.
;                  _OL_ItemSave saves all attachments but can create distinct filenames by adding a number between 00 and 99 at the end
; Related .......: _OL_ItemSave
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemAttachmentSave($oOL, $vItem, $sStoreID, $iAttachment, $sPath)

	Local $sDrive, $sDir, $sFName, $sExt
	If StringStripWS($sPath, 3) = "" Then Return SetError(1, 0, 0)
	_PathSplit($sPath, $sDrive, $sDir, $sFName, $sExt)
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(6, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If Not IsObj($vItem) Then Return SetError(3, 0, 0)
	EndIf
	Local $aAttachments = _OL_ItemAttachmentGet($oOL, $vItem, $sStoreID)
	If Not (IsNumber($iAttachment)) Or $iAttachment < 1 Or $iAttachment > $aAttachments[0][0] Then Return SetError(8, $aAttachments[0][0], 0)
	; Set filename/extension to name/extension of the attachment
	Local $iPos = StringInStr($aAttachments[$iAttachment][2], ".")
	If $sFName = "" Then $sFName = StringLeft($aAttachments[$iAttachment][2], $iPos - 1)
	If $sExt = "" Then $sExt = StringMid($aAttachments[$iAttachment][2], $iPos)
	; Replace invalid characters from filename with underscore
	$sFName = StringRegExpReplace($sFName, '[ \/:*?"<>|]', '_')
	If $sDrive = "" Or $sDir = "" Or $sFName = "" Or $sExt = "" Then Return SetError(7, 0, 0)
	If Not FileExists($sDrive & $sDir) Then
		If DirCreate($sDrive & $sDir) = 0 Then Return SetError(2, 0, 0)
	EndIf
	$sPath = $sDrive & $sDir & $sFName & $sExt
	If FileExists($sPath) = 1 Then Return SetError(4, 0, 0)
	; Save attachment
	$aAttachments[$iAttachment][0] .SaveAsFile($sPath)
	If @error Then Return SetError(5, @error, 0)
	Return 1

EndFunc   ;==>_OL_ItemAttachmentSave

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemConflictGet
; Description ...: Returns a list of items that are in conflict with the selected item.
; Syntax.........: _OL_ItemConflictGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = users mailbox)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Object of the item in conflict
;                  |1 - Class of the object in conflict. Defined by the  OlObjectClass enumeration
;                  |2 - Name of the object in conflict
;                  Failure - Returns 0 and sets @error:
;                  |1 - No Outlook item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no conflicts
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemConflictGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If $vItem.Conflicts.Count = 0 Then Return SetError(3, 0, 0)
	Local $aConflicts[$vItem.Conflicts.Count + 1][3] = [[$vItem.Conflicts.Count, 3]]
	Local $iIndex = 1
	For $oConflict In $vItem.Conflicts
		$aConflicts[$iIndex][0] = $oConflict
		$aConflicts[$iIndex][1] = $oConflict.Type
		$aConflicts[$iIndex][2] = $oConflict.Name
		$iIndex += 1
	Next
	Return $aConflicts

EndFunc   ;==>_OL_ItemConflictGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemCopy
; Description ...: Copies an item (contact, appointment ...) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemCopy($oOL, $vItem[, $sStoreID = Default[, $vTargetFolder = ""]])
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem         - EntryID or object of the item to copy
;                  $sStoreID      - Optional: StoreID of the source store as returned by _OL_FolderAccess (default = users mailbox)
;                  $vTargetFolder - Optional: Target folder (object) as returned by _OL_FolderAccess or full name of folder
; Return values .: Success - Item object of the copied item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No or an invalid item has been specified
;                  |2 - Error accessing the specified target folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |3 - Source and target folder are of different types
;                  |4 - Error moving the copied item to the target folder. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: If $vTargetFolder is omitted the copy is created in the same folder as the source item
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemCopy($oOL, $vItem, $sStoreID = Default, $vTargetFolder = "")

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(1, @error, 0)
	EndIf
	Local $oSourceFolder = $vItem.Parent
	If Not IsObj($vTargetFolder) Then
		If StringStripWS($vTargetFolder, 3) = "" Then
			$vTargetFolder = $oSourceFolder
		Else
			Local $aTemp = _OL_FolderAccess($oOL, $vTargetFolder)
			If @error Then Return SetError(2, @error, 0)
			$vTargetFolder = $aTemp[1]
		EndIf
	EndIf
	If $oSourceFolder.DefaultItemType <> $vTargetFolder.DefaultItemType Then Return SetError(3, 0, 0)
	Local $vItemCopied = $vItem.Copy
	$vItemCopied.Close(0)
	; Move the copied item to another folder
	If $oSourceFolder <> $vTargetFolder Then
		$vItemCopied = _OL_ItemMove($oOL, $vItemCopied, $sStoreID, $vTargetFolder)
		If @error Then Return SetError(4, @error, 0)
	EndIf
	Return $vItemCopied

EndFunc   ;==>_OL_ItemCopy

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_ItemCreate
; Description ...: Creates an item.
; Syntax.........: _OL_ItemCreate($oOL, $iItemType, $vFolder = ""[, $sTemplate = ""[,$sP1 = ""[, $sP2 = ""[, $sP3 = ""[, $sP4 = ""[, $sP5 = ""[, $sP6 = ""[, $sP7 = ""[, $sP8 = ""[, $sP9 = ""[, $sP10 = ""]]]]]]]]]]])
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $iItemType   - Type of item to create. Is defined by the Outlook OlItemType enumeration
;                  $vFolder     - Optional: Folder object as returned by _OL_FolderAccess or full name of folder where the item will be created.
;                  |If not specified the default folder for the item type specified by $iItemType will be selected
;                  $sTemplate   - Optional: Path and file name of the Outlook template for the new item
;                  $sP1         - Optional: Item property in the format: propertyname=propertyvalue
;                  |or a zero based one-dimensional array with unlimited number of properties in the same format
;                  $sP2         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP3         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP4         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP5         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP6         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP7         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP8         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP9         - Optional: Item property in the format: propertyname=propertyvalue
;                  $sP10        - Optional: Item property in the format: propertyname=propertyvalue
; Return values .: Success - Item object of the created item
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |2 - Error moving the Item to the specified folder. See @extended for errorcode returned by _OL_ItemMove
;                  |3 - Property doesn't contain a "=" to separate name and value. @extended = number of property in error (zero based)
;                  |4 - Error creating the item. @extended = error returned by the COM interface
;                  |5 - Invalid or no $iItemType specified
;                  |6 - Specified template file does not exist
;                  |1xx - Error checking the properties $sP1 to $sP10 as returned by __OL_CheckProperties.
;                  +      @extended is the number of the property in error (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $sP2 to $sP10 will be ignored if $sP1 is an array of properties
;                  Be sure to specify the properties in correct case e.g. "FirstName" is valid, "Firstname" is invalid
;                  +
;                  If you want to create a meeting request and send it to some attendees you have to create an appointment and set property
;                  +MeetingStatus to one of the OlMeetingStatus enumeration
;                  +
;                  Note: Mails are created in the drafts folder if you do not specify $vFolder
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemCreate($oOL, $iItemType, $vFolder = "", $sTemplate = "", $sP1 = "", $sP2 = "", $sP3 = "", $sP4 = "", $sP5 = "", $sP6 = "", $sP7 = "", $sP8 = "", $sP9 = "", $sP10 = "")

	Local $aProperties[10], $iPos, $oItem
	If Not IsNumber($iItemType) Then Return SetError(5, 0, 0)
	If $sTemplate <> "" And Not FileExists($sTemplate) Then Return SetError(6, 0, 0)
	If Not IsObj($vFolder) Then
		Local $aFolderToAccess = _OL_FolderAccess($oOL, $vFolder, Default, $iItemType)
		If @error Then Return SetError(1, @error, 0)
		$vFolder = $aFolderToAccess[1]
	EndIf
	If StringStripWS($sTemplate, 3) = "" Then
		$oItem = $vFolder.Items.Add($iItemType)
		If $iItemType = $olMailItem Then $oItem.GetInspector ; Add the signature to the mail item if defined
	Else
		$oItem = $oOL.CreateItemFromTemplate($sTemplate, $vFolder) ; create item based on a template
	EndIf
	If @error Then Return SetError(4, @error, 0)
	; Move property parameters into an array
	If Not IsArray($sP1) Then
		$aProperties[0] = $sP1
		$aProperties[1] = $sP2
		$aProperties[2] = $sP3
		$aProperties[3] = $sP4
		$aProperties[4] = $sP5
		$aProperties[5] = $sP6
		$aProperties[6] = $sP7
		$aProperties[7] = $sP8
		$aProperties[8] = $sP9
		$aProperties[9] = $sP10
	Else
		$aProperties = $sP1
	EndIf
	; Check properties
	If Not __OL_CheckProperties($oItem, $aProperties) Then Return SetError(@error, @extended, 0)
	; Set properties of the Item
	For $iIndex = 0 To UBound($aProperties) - 1
		If $aProperties[$iIndex] <> "" Then
			$iPos = StringInStr($aProperties[$iIndex], "=")
			If $iPos <> 0 Then
				$oItem.ItemProperties.Item(StringStripWS(StringLeft($aProperties[$iIndex], $iPos - 1), 3)).value = _
						StringStripWS(StringMid($aProperties[$iIndex], $iPos + 1), 3)
			Else
				Return SetError(3, $iIndex, 0)
			EndIf
		EndIf
	Next
	$oItem.Close(0)
	; Mails: Move the Item from the drafts folder to another folder if folder was specified and sourcefolder <> targetfolder
	If IsObj($vFolder) And $vFolder.FolderPath <> $oItem.Parent.FolderPath Then
		$oItem = _OL_ItemMove($oOL, $oItem, $oItem.Parent.StoreID, $vFolder)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	Return $oItem

EndFunc   ;==>_OL_ItemCreate

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemDelete
; Description ...: Deletes an item (contact, appointment ...) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemDelete($oOL, $sEntryId[, $sStoreID = Default)
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item to delete
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = the users mailbox)
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item could not be deleted. Please see @extended for more information
; Author ........: water
; Modified ......:
; Remarks .......: To cancel a meeting you have to set property "MeetingStatus" to $olMeetingCanceled and send the meeting again
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemDelete($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	$vItem.Delete
	If @error Then Return SetError(3, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemDisplay
; Description ...: Displays an item (contact, appointment ...) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemDisplay($oOL, $sEntryId[, $sStoreID = Default[, $iWidth = 0[, $iHeight = 0[, $iLeft = 0[, $iTop = 0[, $iState = $olNormalWindow]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item to display
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
;                  $iWidth   - Optional: The width of the window in pixel (default = 0 = Use Outlook default)
;                  $iHeight  - Optional: The height of the window in pixel (default = 0 = Use Outlook default)
;                  $iLeft    - Optional: The left position of the window in pixel (default = 0 = Use Outlook default)
;                  $iTop     - Optional: The top position of the window in pixel (default = 0 = Use Outlook default)
;                  $iState   - Optional: State of the window. Defined by the Outlook OlWindowState enumeration (default = $olNormalWindow)
; Return values .: Success - Object of the Inspector where the item is displayed
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item could not be displayed. Please see @extended for more information
;                  |4 - Error setting properties of the window. Please see @extended for more information
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemDisplay($oOL, $vItem, $sStoreID = Default, $iWidth = 0, $iHeight = 0, $iLeft = 0, $iTop = 0, $iState = $olNormalWindow)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	$vItem.Display()
	If @error Then Return SetError(3, @error, 0)
	If $iWidth > 0 Then $vItem.GetInspector.Width = $iWidth
	If $iHeight > 0 Then $vItem.GetInspector.Height = $iHeight
	If $iLeft > 0 Then $vItem.GetInspector.left = $iLeft
	If $iTop > 0 Then $vItem.GetInspector.Top = $iTop
	$vItem.GetInspector.WindowState = $iState
	If @error Then Return SetError(4, @error, 0)
	Return $vItem.GetInspector

EndFunc   ;==>_OL_ItemDisplay

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemExport
; Description ...: Exports items from an array to a file.
; Syntax.........: _OL_ItemExport($sPath, $sDelimiter, $sQuote, $iFormat, $sHeader, $aData)
; Parameters ....: $sPath      - Drive, Directory, Filename and Extension of the output file
;                  $sDelimiter - Optional: Fieldseparator (default = , (comma))
;                  $sQuote     - Optional: Quote character (default = " (double quote))
;                  $iFormat    - Character encoding of file:
;                  |0 or 1 - ASCII writing
;                  |2      - Unicode UTF16 Little Endian writing (with BOM)
;                  |3      - Unicode UTF16 Big Endian writing (with BOM)
;                  |4      - Unicode UTF8 writing (with BOM)
;                  |5      - Unicode UTF8 writing (without BOM)
;                  $sHeader    - Header line with comma separated list of properties to export
;                  $aData      - 1-based two-dimensional array
; Return values .: Success - Number of records exported
;                  Failure - Returns 0 and sets @error:
;                  |1 - Parameter $sPath is empty
;                  |2 - File $sPath already exists
;                  |3 - $iType is not numeric or an invalid number
;                  |4 - $sHeader is empty
;                  |5 - $aData is empty or not a two-dimensional array
;                  |6 - Error writing header line to file $sPath. Please see @extended for error of function __WriteCSV
;                  |7 - Error writing data lines to file $sPath. Please see @extended for error of function __WriteCSV
; Author ........: water
; Modified ......:
; Remarks .......: Fill the array with data using _OL_ItemFind
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemExport($sPath, $sDelimiter, $sQuote, $iFormat, $sHeader, ByRef $aData)

	If StringStripWS($sPath, 3) = "" Then Return SetError(1, 0, 0)
	If FileExists($sPath) Then Return SetError(2, 0, 0)
	If Not IsNumber($iFormat) Or $iFormat > 5 Then Return SetError(3, 0, 0)
	If StringStripWS($sHeader, 3) = "" Then Return SetError(4, 0, 0)
	If Not IsArray($aData) Or UBound($aData, 0) <> 2 Then Return SetError(5, 0, 0)
	If $sDelimiter = "" Or IsKeyword($sDelimiter) Then $sDelimiter = ","
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	; Write header to file
	Local $aHeaderSplit = StringSplit($sHeader, ",")
	Local $aHeaderTab[2][$aHeaderSplit[0]] = [[1, $aHeaderSplit[0]]]
	For $iIndex = 1 To $aHeaderSplit[0]
		$aHeaderTab[1][$iIndex - 1] = $aHeaderSplit[$iIndex]
	Next
	Local $iResult = __WriteCSV($sPath, $aHeaderTab, $sDelimiter, $sQuote, $iFormat)
	If @error Then Return SetError(6, @error, 0)
	; Write data to file
	$iResult = __WriteCSV($sPath, $aData, $sDelimiter, $sQuote, $iFormat)
	If @error Then Return SetError(7, @error, 0)
	Return $iResult

EndFunc   ;==>_OL_ItemExport

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemFind
; Description ...: Finds items (contacts, appointments ...) returning an array of all specified properties.
; Syntax.........: _OL_ItemFind($oOL, $vFolder[, $iObjectClass = Default[, $sRestrict = ""[, $sSearchName = ""[, $sSearchValue = ""[, $sReturnProperties = ""[, $sSort = ""[, $iFlags = 0[, $sWarningClick = ""]]]]]]]])
; Parameters ....: $oOL               - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder           - Folder object as returned by _OL_FolderAccess or full name of folder where the search will be started.
;                  +If you want to search a default folder you have to specify the folder object.
;                  $iObjectClass      - Optional: Class of items to search for. Defined by the Outlook OlObjectClass enumeration (default = Default = $olContact)
;                  $sRestrict         - Optional: Filter text to restrict number of items returned (exact match). For details please see Remarks
;                  $sSearchName       - Optional: Name of the property to search for (without brackets)
;                  $sSearchValue      - Optional: String value of the property to search for (partial match)
;                  $sReturnProperties - Optional: Comma separated list of properties to return (default = depending on $iObjectClass. Please see Remarks)
;                  $sSort             - Optional: Property to sort the result on plus optional flag to sort descending (default = None). E.g. "[Subject], True" sorts the result descending on the subject
;                  $iFlags            - Optional: Flags to set different processing options. Can be a combination of the following:
;                  |  1: Subfolders will be included
;                  |  2: Row 1 contains column headings. Therefore the number of rows/columns in the table has to be calculated using UBound
;                  |  4: Just return the number of records. You don't get an array, just a single integer denoting the total number of records found
;                  $sWarningClick     - Optional: The Entire SearchString to 'OutlookWarning2.exe' (default = None)
; Return values .: Success - One based two-dimensional array with the properties specified by $sReturnProperties
;                  Failure - Returns "" and sets @error:
;                  |1 - You have to specifiy $sSearchName AND $sSearchValue or none of them
;                  |2 - $sWarningClick not found
;                  |3 - Error accessing the specified folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |4 - Error accessing specified property. For details check @extended
;                  |1xx - Error checking $sReturnProperties as returned by __OL_CheckProperties. @extended is the number of the property in error (zero based)
; Author ........: water
; Modified ......:
; Remarks .......: Be sure to specify the values in $sReturnProperties and $sSearchName in correct case e.g. "FirstName" is valid, "Firstname" is invalid
;+
;                  $sRestrict: Filter can be a Jet query or a DASL query with the @SQL= prefix. Jet query language syntax:
;                  Restrict filter:  Filter LogicalOperator Filter ...
;                  LogicalOperator:  And, Or, Not. Use ( and ) to change the processing order
;                  Filter:           "[property] operator 'value'" or '[property] operator "value"'
;                  Operator:         <, >, <=, >=, <>, =
;                  Example:          "[Start]='2011-02-21 08:00' And [End]='2011-02-21 10:00' And [Subject]='Test'"
;                  See: http://msdn.microsoft.com/en-us/library/cc513841.aspx              - "Searching Outlook Data"
;                       http://msdn.microsoft.com/en-us/library/bb220369(v=office.12).aspx - "Items.Restrict Method"
;+
;                  N.B.: Pass time as HH:MM, HH:MM:SS is invalid and returns no result
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemFind($oOL, $vFolder, $iObjectClass = Default, $sRestrict = "", $sSearchName = "", $sSearchValue = "", $sReturnProperties = "", $sSort = "", $iFlags = 0, $sWarningClick = "")

	Local $bChecked = False, $oItems, $aTemp, $iRecCounter = 0, $iCounter = 0
	If $sWarningClick <> "" Then
		If FileExists($sWarningClick) = 0 Then Return SetError(2, 0, "")
		Run($sWarningClick)
	EndIf
	If $iObjectClass = Default Then $iObjectClass = $olContact ; Set Default ObjectClass
	; Set default return properties depending on the class of items
	If StringStripWS($sReturnProperties, 3) = "" Then
		Switch $iObjectClass
			Case $olContact
				$sReturnProperties = "FirstName,LastName,Email1Address,Email2Address,MobileTelephoneNumber"
			Case $olDistributionList
				$sReturnProperties = "Subject,Body,MemberCount"
			Case $olNote, $olMail
				$sReturnProperties = "Subject,Body,CreationTime,LastModificationTime,Size"
			Case Else
		EndSwitch
	EndIf
	If Not IsObj($vFolder) Then
		$aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(3, @error, "")
		$vFolder = $aTemp[1]
	EndIf
	If ($sSearchName <> "" And $sSearchValue = "") Or ($sSearchName = "" And $sSearchValue <> "") Then Return SetError(1, 0, "")
	Local $aReturnProperties = StringSplit(StringStripWS($sReturnProperties, 8), ",")
	Local $iIndex = $aReturnProperties[0]
	If $aReturnProperties[0] < 2 Then $iIndex = 2
	Local $aItems[$vFolder.Items.Count + 1][$iIndex] = [[0, $aReturnProperties[0]]]
	If StringStripWS($sRestrict, 3) = "" Then
		$oItems = $vFolder.Items
	Else
		$oItems = $vFolder.Items.Restrict($sRestrict)
	EndIf
	If BitAND($iFlags, 4) <> 4 And $sSort <> "" Then
		$aTemp = StringSplit($sSort, ",")
		If $aTemp[0] = 1 Then
			$oItems.Sort($sSort)
		Else
			$oItems.Sort($aTemp[1], True)
		EndIf
	EndIf
	For $oItem In $oItems
		If $oItem.Class <> $iObjectClass Then ContinueLoop
		; Get all properties of first item and check for existance and correct case
		If BitAND($iFlags, 4) <> 4 And Not $bChecked Then
			If Not __OL_CheckProperties($oItem, $aReturnProperties, 1) Then Return SetError(@error, @extended, "")
			$bChecked = True
		EndIf
		If $sSearchName <> "" And StringInStr($oItem.ItemProperties.Item($sSearchName).value, $sSearchValue) = 0 Then ContinueLoop
		; Fill array with the specified properties
		$iCounter += 1
		If BitAND($iFlags, 4) <> 4 Then
			For $iIndex = 1 To $aReturnProperties[0]
				$aItems[$iCounter][$iIndex - 1] = $oItem.ItemProperties.Item($aReturnProperties[$iIndex]).value
				If @error Then Return SetError(4, @error, "")
				If BitAND($iFlags, 2) = 2 And $iCounter = 1 Then $aItems[0][$iIndex - 1] = $oItem.ItemProperties.Item($aReturnProperties[$iIndex]).name
			Next
		EndIf
		If BitAND($iFlags, 4) <> 4 And BitAND($iFlags, 2) <> 2 Then $aItems[0][0] = $iCounter
	Next
	If BitAND($iFlags, 4) = 4 Then
		$iRecCounter += $oItems.Count
		; Process subfolders
		If BitAND($iFlags, 1) = 1 Then
			For $vFolder In $vFolder.Folders
				$iRecCounter += _OL_ItemFind($oOL, $vFolder, $iObjectClass, $sRestrict, $sSearchName, $sSearchValue, $sReturnProperties, $sSort, $iFlags, $sWarningClick)
			Next
		EndIf
		Return $iRecCounter
	Else
		ReDim $aItems[$iCounter + 1][$aReturnProperties[0]] ; Process subfolders
		If BitAND($iFlags, 1) = 1 Then
			For $vFolder In $vFolder.Folders
				$aTemp = _OL_ItemFind($oOL, $vFolder, $iObjectClass, $sRestrict, $sSearchName, $sSearchValue, $sReturnProperties, $sSort, $iFlags, $sWarningClick)
				__OL_ArrayConcatenate($aItems, $aTemp, $iFlags)
			Next
		EndIf
		Return $aItems
	EndIf

EndFunc   ;==>_OL_ItemFind

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemForward
; Description ...: Creates a copy of an item (contact, appointment ...) which then can be forwarded to other users.
; Syntax.........: _OL_ItemForward($oOL, $vItem, $sStoreID, $iType)
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - StoreID where the EntryID is stored. Use "Default" to access the users mailbox
;                  $iType    - Type of forwarded item. Valid values are:
;                  |0 - $iType is ignored for mail items
;                  |1 - ForwardAsVCard: Item is forwarded in vCard format. Valid for appointment and contact items
;                  |    In Outlook 2002 a contact is forwarded in the vCal format
;                  |2 - ForwardAsBusinessCard: Item is forwarded as Electronic Business Card (EBC). Valid for contact items
; Return values .: Success - Object of the forwarded item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item could not be forwarded. @extended = error returned by .Forward
;                  |4 - Item could not be saved. @extended = error returned by .Close
;                  |5 - Specified mail item has not been sent. You can't forward a mail which hasn't been sent before
; Author ........: water
; Modified ......:
; Remarks .......: This function doesn't actually forward the item but creates a copy that you can forward.
;                  Use _OL_ItemRecipientAdd to set the recipient of the forwarded item and then call _OL_ItemSend to forward it.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemForward($oOL, $vItem, $sStoreID, $iType)

	Local $vItemForward
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Mail: Simple forward
	; Appointment: ForwardAsVcal
	; Contact: ForwardAsVcal (Outlook 2002 as Vcard) or ForwardAsBusinessCard
	If $vItem.Class = $olMail Then
		If $vItem.Sent = False Then Return SetError(5, 0, 0)
		$vItemForward = $vItem.Forward
	ElseIf $vItem.Class = $olContact Then
		If $iType = 1 Then
			If $vItem.OutlookVersion = "10.0" Then
				$vItemForward = $vItem.ForwardAsVcal
			Else
				$vItemForward = $vItem.ForwardAsVcard
			EndIf
		EndIf
		If $iType = 2 Then $vItemForward = $vItem.ForwardAsBusinessCard
	Else
		$vItemForward = $vItem.ForwardAsVcal
	EndIf
	If @error Then Return SetError(3, @error, 0)
	$vItemForward.Save()
	If @error Then Return SetError(4, @error, 0)
	Return $vItemForward

EndFunc   ;==>_OL_ItemForward

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemGet
; Description ...: Returns all or selected properties of an item (contact, appointment ...) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemGet($oOL, $vItem[, $sStoreID = Default[, $sProperties = ""]])
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem       - EntryID or object of the item
;                  $sStoreID    - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
;                  $sProperties - Optional: Comma separated list of properties to return (default = "" = return all properties)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Name of the property
;                  |1 - Value of the property
;                  |2 - Type of the property. Defined by the Outlook OlUserPropertyType enumeration
;                  Failure - Returns "" and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemGet($oOL, $vItem, $sStoreID = Default, $sProperties = "")

	Local $vValue
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, "")
	EndIf
	$sProperties = "," & StringReplace($sProperties, " ", "") & ","
	Local $aProperties[$vItem.ItemProperties.Count + 1][3] = [[$vItem.ItemProperties.Count, 3]]
	Local $iCounter = 1
	For $oProperty In $vItem.ItemProperties
		If Not ($sProperties = ",," Or StringInStr($sProperties, "," & $oProperty.name & ",") > 0) Then ContinueLoop
		$aProperties[$iCounter][0] = $oProperty.name
		$aProperties[$iCounter][2] = $oProperty.type
		Switch $oProperty.type
			Case $olKeywords
				$vValue = $oProperty.value
				$aProperties[$iCounter][1] = _ArrayToString($vValue)
			Case Else
				$aProperties[$iCounter][1] = $oProperty.value
		EndSwitch
		$iCounter += 1
	Next
	ReDim $aProperties[$iCounter][UBound($aProperties, 2)]
	$aProperties[0][0] = UBound($aProperties, 1) - 1
	_ArraySort($aProperties, 0, 1)
	Return $aProperties

EndFunc   ;==>_OL_ItemGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemImport
; Description ...: Imports items from a file.
; Syntax.........: _OL_ItemImport($oOL, $sPath, $sDelimiters, $sQuote, $iFormat, $vFolder, $iItemType)
; Parameters ....: $oOL         - Outlook object
;                  $sPath       - Path (drive, directory, filename) where the data to be imported is stored
;                  $sDelimiters - Optional: Fieldseparators of CSV, multiple are allowed (default = ,;)
;                  $sQuote      - Optional: Character to quote strings (default = ")
;                  $iFormat     - Character encoding of file:
;                  |0 or 1 - ASCII writing
;                  |2      - Unicode UTF16 Little Endian writing (with BOM)
;                  |3      - Unicode UTF16 Big Endian writing (with BOM)
;                  |4      - Unicode UTF8 writing (with BOM)
;                  |5      - Unicode UTF8 writing (without BOM)
;                  $vFolder     - Folder object as returned by _OL_FolderAccess or full name of folder where the objects will be stored
;                  $iItemType   - Type of the items that will be created in the $vFolder. Defined by the Outlook OlItemType enumeration
; Return values .: Success - Number of records imported
;                  Failure - Returns 0 and sets @error:
;                  |1 - Parameter $sPath is empty
;                  |2 - File $sPath does not exist
;                  |3 - $vFolder is empty
;                  |4 - $iItemType is not numeric
;                  |5 - Error processing input file $sPath. Please see @extended for the returncode of __ParseCSV
;                  |6 - Error accessing folder $vFolder. Please see @extended for more information
;                  |7 - Error creating item in folder $vFolder. Please see @extended for more information
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemImport($oOL, $sPath, $sDelimiters, $sQuote, $iFormat, $vFolder, $iItemType)

	If StringStripWS($sPath, 3) = "" Then Return SetError(1, 0, 0)
	If Not FileExists($sPath) Then Return SetError(2, 0, 0)
	If Not IsObj($vFolder) Then
		If StringStripWS($vFolder, 3) = "" Then Return SetError(3, 0, 0)
		Local $aTemp = _OL_FolderAccess($oOL, $vFolder)
		If @error Then Return SetError(6, @error, "")
		$vFolder = $aTemp[1]
	EndIf
	If Not IsNumber($iItemType) Then Return SetError(4, 0, 0)
	Local $aData, $sString, $aItemData
	$aData = __ParseCSV($sPath, $sDelimiters, $sQuote, $iFormat)
	If @error Then Return SetError(5, @error, 0)
	For $iIndex1 = 1 To UBound($aData, 1) - 1
		$sString = ""
		For $iIndex2 = 0 To UBound($aData, 2) - 1
			$sString = $sString & "|" & $aData[0][$iIndex2] & "=" & $aData[$iIndex1][$iIndex2]
		Next
		$aItemData = StringSplit($sString, "|", 2)
		$sString = StringMid($sString, 2) ; Get rid of first |
		_OL_ItemCreate($oOL, $iItemType, $vFolder, "", $aItemData)
		If @error Then Return SetError(7, @error, 0)
	Next
	Return UBound($aData, 1) - 1

EndFunc   ;==>_OL_ItemImport

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_ItemModify
; Description ...: Modifies an item by setting the specified properties to the specified values.
; Syntax.........: _OL_ItemModify($oOL, $vItem[, $oStoreID = Default, $sP1 = ""[, $sP2 = ""[, $sP3 = ""[, $sP4 = ""[, $sP5 = ""[, $sP6 = ""[, $sP7 = ""[, $sP8 = ""[, $sP9 = ""[, $sP10 = ""]]]]]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - Optional: StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $sP1      - Property to modify in the format: propertyname=propertyvalue
;                  +or a zero based one-dimensional array with unlimited number of properties in the same format
;                  $sP2      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP3      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP4      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP5      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP6      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP7      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP8      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP9      - Optional: Property to modify in the format: propertyname=propertyvalue
;                  $sP10     - Optional: Property to modify in the format: propertyname=propertyvalue
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Property doesn't contain a "=" to separate name and value. @extended = number of property in error (zero based)
;                  |4 - Item could not be saved. @extended = error returned by .save
;                  |1xx - Error checking the properties $sP1 to $sP10 as returned by __OL_CheckProperties.
;                  +      @extended is the number of the property in error (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $sP2 to $sP10 will be ignored if $sP1 is an array of properties
;                  Be sure to specify the properties in correct case e.g. "FirstName" is valid, "Firstname" is invalid
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemModify($oOL, $vItem, $sStoreID, $sP1, $sP2 = "", $sP3 = "", $sP4 = "", $sP5 = "", $sP6 = "", $sP7 = "", $sP8 = "", $sP9 = "", $sP10 = "")

	Local $aProperties[10], $iPos
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move property parameters into an array
	If Not IsArray($sP1) Then
		$aProperties[0] = $sP1
		$aProperties[1] = $sP2
		$aProperties[2] = $sP3
		$aProperties[3] = $sP4
		$aProperties[4] = $sP5
		$aProperties[5] = $sP6
		$aProperties[6] = $sP7
		$aProperties[7] = $sP8
		$aProperties[8] = $sP9
		$aProperties[9] = $sP10
	Else
		$aProperties = $sP1
	EndIf
	; Check properties
	If Not __OL_CheckProperties($vItem, $aProperties) Then Return SetError(@error, @extended, "")
	; Set properties of the item
	For $iIndex = 0 To UBound($aProperties) - 1
		If $aProperties[$iIndex] <> "" Then
			$iPos = StringInStr($aProperties[$iIndex], "=")
			If $iPos <> 0 Then
				$vItem.ItemProperties.Item(StringStripWS(StringLeft($aProperties[$iIndex], $iPos - 1), 3)).value = StringStripWS(StringMid($aProperties[$iIndex], $iPos + 1), 3)
			Else
				Return SetError(3, $iIndex, 0)
			EndIf
		EndIf
	Next
	$vItem.Save
	If @error Then Return SetError(4, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemModify

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemMove
; Description ...: Moves an item (contact, appointment ...) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemMove($oOL, $vItem, $sStoreID, $vTargetFolder[, $iFolderType = Default])
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem         - EntryID or object of the item to move
;                  $sStoreID      - StoreID of the source store as returned by _OL_FolderAccess. Use "Default" to access the users mailbox
;                  $vTargetFolder - Target folder object as returned by _OL_FolderAccess or full name of folder
;                  $iFolderType   - Optional: Type of target folder if you specify the folder name of another user. Is defined by the Outlook OlDefaultFolders enumeration (default = Default)
; Return values .: Success - Item object of the moved item
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing the specified target folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |2 - Source and target folder are of different types
;                  |3 - Source and target folder are the same
;                  |4 - Target folder has not been specified or is empty
;                  |5 - Error moving the item to the target folder. For details check @extended
;                  |6 - No or an invalid item has been specified
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemMove($oOL, $vItem, $sStoreID, $vTargetFolder, $iFolderType = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(6, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(6, @error, 0)
	EndIf
	Local $oSourceFolder = $vItem.Parent
	If Not IsObj($vTargetFolder) Then
		If StringStripWS($vTargetFolder, 3) = "" Then Return SetError(4, 0, 0)
		Local $aTemp = _OL_FolderAccess($oOL, $vTargetFolder, $iFolderType)
		If @error Then Return SetError(1, @error, 0)
		$vTargetFolder = $aTemp[1]
	EndIf
	If $oSourceFolder = $vTargetFolder Then Return SetError(3, 0, 0)
	If $oSourceFolder.DefaultItemType <> $vTargetFolder.DefaultItemType Then Return SetError(2, 0, 0)
	Local $oItemMoved = $vItem.Move($vTargetFolder)
	If @error Then Return SetError(5, @error, 0)
	Return $oItemMoved

EndFunc   ;==>_OL_ItemMove

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemPrint
; Description ...: Prints an item (contact, appointment ...) using all the default settings.
; Syntax.........: _OL_ItemPrint($oOL, $vItem, $sStoreID)
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem         - EntryID or object of the item to print
;                  $sStoreID      - Optional: StoreID of the source store as returned by _OL_FolderAccess (default = keyword "Default" = the users mailbox)
; Return values .: Success - Item object of the printed item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryId/StoreId might be invalid. For details please check @extended
;                  |3 - Error printing the specified item. For details please check @extended
; Author ........: water
; Modified ......:
; Remarks .......: Item is printed on the default printer with default settings.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemPrint($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	Local $oItemPrinted = $vItem.PrintOut()
	If @error Then Return SetError(3, @error, 0)
	Return $oItemPrinted

EndFunc   ;==>_OL_ItemPrint

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecipientAdd
; Description ...: Adds one or multiple recipients to an item.
; Syntax.........: _OL_ItemRecipientAdd($oOL, $vItem, $sStoreID, $iType, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""[, $bAllowUnresolved = True]]]]]]]]]])
; Parameters ....: $oOL              - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem            - EntryID or object of the item item
;                  $sStoreID         - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $iType            - Integer representing the type of recipient. For details see Remarks
;                  $vP1              - Recipient to add to the item. Either a recipient object or the recipients name to be resolved
;                  +or a zero based one-dimensional array with unlimited number of recipients
;                  $vP2              - Optional: recipient to add to the item. Either a recipient object or the recipients name to be resolved
;                  $vP3              - Optional: Same as $vP2
;                  $vP4              - Optional: Same as $vP2
;                  $vP5              - Optional: Same as $vP2
;                  $vP6              - Optional: Same as $vP2
;                  $vP7              - Optional: Same as $vP2
;                  $vP8              - Optional: Same as $vP2
;                  $vP9              - Optional: Same as $vP2
;                  $vP10             - Optional: Same as $vP2
;                  $bAllowUnresolved - Optional: True doesn't return an error even when unresolvable SMTP addresses have been found (default = True)
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |5 - $iType is missing or not a number
;                  |3nn - Error adding recipient to the item. @extended = error code returned by the Recipients.Add method, nn = number of the invalid recipient (zero based)
;                  |4nn - Recipient name could not be resolved. @extended = error code returned by the Resolve method, nn = number of the invalid recipient (zero based)
;                  |6nn - Recipient object could not be created. @extended = error code returned by the CreateRecipient method, nn = number of the invalid recipient (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of recipients
;                  +
;                  Valid $iType parameters:
;                  MailItem recipient: one of the following OlMailRecipientType constants: olBCC, olCC, olOriginator, or olTo
;                  MeetingItem recipient: one of the following OlMeetingRecipientType constants: olOptional, olOrganizer, olRequired, or olResource
;                  TaskItem recipient: one of the following OlTaskRecipientType constants: olFinalStatus, or olUpdate
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecipientAdd($oOL, $vItem, $sStoreID, $iType, $vP1, $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "", $bAllowUnresolved = True)

	Local $oRecipient, $aRecipients[10], $oTempRecipient
	If Not IsNumber($iType) Then Return SetError(5, 0, 0)
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move members into an array
	If Not IsArray($vP1) Then
		$aRecipients[0] = $vP1
		$aRecipients[1] = $vP2
		$aRecipients[2] = $vP3
		$aRecipients[3] = $vP4
		$aRecipients[4] = $vP5
		$aRecipients[5] = $vP6
		$aRecipients[6] = $vP7
		$aRecipients[7] = $vP8
		$aRecipients[8] = $vP9
		$aRecipients[9] = $vP10
	Else
		$aRecipients = $vP1
	EndIf
	; add recipients to the item
	For $iIndex = 0 To UBound($aRecipients) - 1
		; recipient is an object = recipient name already resolved
		If IsObj($aRecipients[$iIndex]) Then
			$vItem.Recipients.Add($aRecipients[$iIndex])
			If @error Then Return SetError(3, $iIndex, 0)
		Else
			If StringStripWS($aRecipients[$iIndex], 3) = "" Then ContinueLoop
			$oRecipient = $oOL.Session.CreateRecipient($aRecipients[$iIndex])
			If @error Or Not IsObj($oRecipient) Then Return SetError(600 + $iIndex, @error, 0)
			$oRecipient.Resolve
			If @error Or Not $oRecipient.Resolved Then
				If Not (StringInStr($aRecipients[$iIndex], "@")) Or Not ($bAllowUnresolved) Then Return SetError(400 + $iIndex, @error, 0)
			EndIf
			#forceref $oTempRecipient ; to prevent the AU3Check warning: $oTempRecipient: declared, but not used in func.
			$oTempRecipient = $vItem.Recipients.Add($oRecipient)
			If @error Then Return SetError(300 + $iIndex, @error, 0)
			$oTempRecipient.Type = $iType
		EndIf
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_ItemRecipientAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecipientCheck
; Description ...: Checks one/more recipients to be valid.
; Syntax.........: _OL_ItemRecipientCheck($oOL, $vRecipients)
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $vRecipients - Name, Alias or SMPT mail address of one or multiple recipients separated by ";"
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Recipient derived from the list of recipients in $vRecipients
;                  |1 - True if the recipient could be resolved successfully
;                  |2 - Recipient object as returned by the Resolve method
;                  |3 - AddressEntry object
;                  |4 - Recipients mail address (empty for distribution lists). This can be:
;                  |     PrimarySmtpAddress for an Exchange User
;                  |     Email1Address for an Outlook contact
;                  |     Empty for Exchange or Outlook distribution lists
;                  |5 - Display type is one of the OlDisplayType enumeration that describes the nature of the recipient
;                  |6 - Display name of the recipient
;                  Failure - Returns "" and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - $vRecipients is empty
;                  |3 - Error creating recipient object. @extended contains the error returned by method CreateRecipient
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecipientCheck($oOL, $vRecipients)

	Local $oRecipient
	If Not IsObj($oOL) Then Return SetError(1, 0, "")
	If StringStripWS($vRecipients, 3) = "" Then Return SetError(2, 0, "")
	Local $asRecipients = StringSplit($vRecipients, ";")
	Local $asResult[$asRecipients[0] + 1][7] = [[$asRecipients[0], 7]]
	For $iIndex = 1 To $asRecipients[0]
		$asResult[$iIndex][0] = $asRecipients[$iIndex]
		If StringStripWS($asRecipients[$iIndex], 3) = "" Then ContinueLoop
		$oRecipient = $oOL.Session.CreateRecipient($asRecipients[$iIndex])
		If @error Or Not IsObj($oRecipient) Then Return SetError(3, @error, "")
		$oRecipient.Resolve
		If @error Or Not $oRecipient.Resolved Then
			$asResult[$iIndex][1] = False
		Else
			$asResult[$iIndex][1] = True
			$asResult[$iIndex][2] = $oRecipient
			Switch $oRecipient.AddressEntry.AddressEntryUserType
				; Exchange user that belongs to the same or a different Exchange forest
				Case $olExchangeUserAddressEntry, $olExchangeRemoteUserAddressEntry
					$asResult[$iIndex][3] = $oRecipient.AddressEntry.GetExchangeUser
					$asResult[$iIndex][4] = $oRecipient.AddressEntry.GetExchangeUser.PrimarySmtpAddress
					; Address entry in an Outlook Contacts folder
				Case $olOutlookContactAddressEntry
					$asResult[$iIndex][3] = $oRecipient.AddressEntry.GetContact
					$asResult[$iIndex][4] = $oRecipient.AddressEntry.GetContact.Email1Address
					; Address entry in an Exchange Distribution list
				Case $olExchangeDistributionListAddressEntry
					$asResult[$iIndex][3] = $oRecipient.AddressEntry.GetExchangeDistributionList
					; Address entry in an an Outlook distribution list
				Case $olOutlookDistributionListAddressEntry
					$asResult[$iIndex][3] = $oRecipient.AddressEntry
				Case Else
			EndSwitch
			$asResult[$iIndex][5] = $oRecipient.DisplayType
			$asResult[$iIndex][6] = $oRecipient.Name
		EndIf
	Next
	Return $asResult

EndFunc   ;==>_OL_ItemRecipientCheck

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecipientDelete
; Description ...: Deletes one or multiple recipients from an item.
; Syntax.........: _OL_ItemRecipientDelete($oOL, $vItem, $sStoreID, $vP1 = ""[, $vP2 = ""[, $vP3 = ""[, $vP4 = ""[, $vP5 = ""[, $vP6 = ""[, $vP7 = ""[, $vP8 = ""[, $vP9 = ""[, $vP10 = ""]]]]]]]]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vP1      - Number of the recipient to delete from the recipients collection
;                  +or a zero based one-dimensional array with unlimited number of recipients
;                  $vP2      - Optional: Number of the recipient to delete from the recipients collection
;                  $vP3      - Optional: Same as $vP2
;                  $vP4      - Optional: Same as $vP2
;                  $vP5      - Optional: Same as $vP2
;                  $vP6      - Optional: Same as $vP2
;                  $vP7      - Optional: Same as $vP2
;                  $vP8      - Optional: Same as $vP2
;                  $vP9      - Optional: Same as $vP2
;                  $vP10     - Optional: Same as $vP2
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error removing recipient from the item. @extended = number of the invalid recipient parameter (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: $vP2 to $vP10 will be ignored if $vP1 is an array of numbers
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecipientDelete($oOL, $vItem, $sStoreID, $vP1 = "", $vP2 = "", $vP3 = "", $vP4 = "", $vP5 = "", $vP6 = "", $vP7 = "", $vP8 = "", $vP9 = "", $vP10 = "")

	Local $aRecipients[10]
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Move recipients into an array
	If Not IsArray($vP1) Then
		$aRecipients[0] = $vP1
		$aRecipients[1] = $vP2
		$aRecipients[2] = $vP3
		$aRecipients[3] = $vP4
		$aRecipients[4] = $vP5
		$aRecipients[5] = $vP6
		$aRecipients[6] = $vP7
		$aRecipients[7] = $vP8
		$aRecipients[8] = $vP9
		$aRecipients[9] = $vP10
	Else
		$aRecipients = $vP1
	EndIf
	; Delete recipients from the item
	For $iIndex = 0 To UBound($aRecipients) - 1
		If StringStripWS($aRecipients[$iIndex], 3) = "" Then ContinueLoop
		$vItem.Recipients.Remove($aRecipients[$iIndex])
		If @error Then Return SetError(3, $iIndex, 0)
	Next
	$vItem.Close(0)
	Return $vItem

EndFunc   ;==>_OL_ItemRecipientDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecipientGet
; Description ...: Returns all recipients of an item.
; Syntax.........: _OL_ItemRecipientGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Recipient object
;                  |1 - Name of the recipient
;                  |2 - EntryID of the recipient
;                  Failure - Returns "" and sets @error:
;                  |1 - No item specified
;                  |2 - Item could not be found. EntryID might be wrong
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecipientGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	Local $aMembers[$vItem.Recipients.Count + 1][3] = [[$vItem.Recipients.Count, 3]]
	For $iIndex = 1 To $vItem.Recipients.Count
		$aMembers[$iIndex][0] = $vItem.Recipients.Item($iIndex)
		$aMembers[$iIndex][1] = $vItem.Recipients.Item($iIndex).Name
		$aMembers[$iIndex][2] = $vItem.Recipients.Item($iIndex).EntryID
	Next
	Return $aMembers

EndFunc   ;==>_OL_ItemRecipientGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecipientSelect
; Description ...: Displays the Recipient Selection Dialog and returns the selected recipients.
; Syntax.........: _OL_ItemRecipientSelect($oOL[, $sRecipients = ""[, $iRecipientType = Default[, $bForceResolution = Default[, $sInitialAddressList = Default[, $iDefaultMode = Default[, $bAllowMultipleSelection = Default[, $sCaption = Default]]]]]]])
; Parameters ....: $oOL                     - Outlook object returned by a preceding call to _OL_Open()
;                  $sRecipients             - Optional: String of one or multiple recipient names separated by ";" to be preset
;                                             in the selection field defined by $iRecipientType (default = "")
;                  $iRecipientType          - Optional: Sets the selection field where $sRecipients should be displayed (default = Default)
;                                             Has to be one of the following enumerations:
;                                               JournalItem recipient: the OlJournalRecipientType constant olAssociatedContact.
;                                               MailItem recipient: one of the following OlMailRecipientType constants: olBCC, olCC, olOriginator, or olTo.
;                                               MeetingItem recipient: one of the following OlMeetingRecipientType constants: olOptional, olOrganizer, olRequired, or olResource.
;                                               TaskItem recipient: either of the following OlTaskRecipientType constants: olFinalStatus, or olUpdate.
;                  $bForceResolution        - Optional: True determines that all recipients must be resolved before the user can click OK (default = Default)
;                  $sInitialAddressList     - Optional: Name of the initial address list to be displayed (default = Default)
;                  $iDefaultMode            - Optional: Sets the default display mode. Has to be one of the OlDefaultSelectNamesDisplayMode enumeration (default = Default)
;                  $bAllowMultipleSelection - Optional: True allows more than one address entry to be selected (default = Default)
;                  $sCaption                - Optional: Caption for the selection dialog (default = Default)
; Return values .: Success - zero based one-dimensional array with the recipient objects of the selected recipients.
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - Specified inital address list not found
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecipientSelect($oOL, $sRecipients = "", $iRecipientType = Default, $bForceResolution = Default, $sInitialAddressList = Default, $iDefaultMode = Default, $bAllowMultipleSelection = Default, $sCaption = Default)

	If Not IsObj($oOL) Then Return SetError(1, 0, "")
	Local $oSelectionDialog = $oOL.Session.GetSelectNamesDialog()
	If $sRecipients <> "" Then
		Local $oRecipients = $oSelectionDialog.Recipients.Add($sRecipients)
		#forceref $oRecipients
		If $iRecipientType <> Default Then $oRecipients.Type = $iRecipientType
	EndIf
	If $bForceResolution <> Default Then $oSelectionDialog.ForceResolution = $bForceResolution
	If $sInitialAddressList <> Default Then
		Local $bFound = False
		For $oAL In $oOL.Session.AddressLists
			If $oAL.Name = $sInitialAddressList Then
				$bFound = True
				$oSelectionDialog.InitialAddressList = $oAL
				ExitLoop
			EndIf
		Next
		If Not $bFound Then Return SetError(2, 0, "")
	EndIf
	If $iDefaultMode <> Default Then $oSelectionDialog.SetDefaultDisplayMode($iDefaultMode)
	If $bAllowMultipleSelection <> Default Then $oSelectionDialog.AllowMultipleSelection = $bAllowMultipleSelection
	If $sCaption <> Default Then $oSelectionDialog.Caption = $sCaption
	Local $bClicked = $oSelectionDialog.Display()
	If $bClicked = False Then Return False ; User cancelled the selection dialog
	Local $aoRecipients[$oSelectionDialog.Recipients.Count]
	For $iIndex = 1 To $oSelectionDialog.Recipients.Count
		$aoRecipients[$iIndex - 1] = $oSelectionDialog.Recipients.Item($iIndex)
	Next
	Return $aoRecipients

EndFunc   ;==>_OL_ItemRecipientSelect

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecurrenceDelete
; Description ...: Deletes recurrence information of an item (appointment or task).
; Syntax.........: _OL_ItemRecurrenceDelete($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the appointment or task item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No appointment or task item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no recurrence information
;                  |4 - Error with ClearRecurrencePattern. For more info please see @extended
;                  |5 - Error with Save. For more info please see @extended
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecurrenceDelete($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Recurrence object of the appointment
	If $vItem.IsRecurring = False Then Return SetError(3, 0, 0)
	$vItem.ClearRecurrencePattern
	If @error Then Return SetError(4, @error, 0)
	$vItem.Save
	If @error Then Return SetError(5, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemRecurrenceDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecurrenceExceptionGet
; Description ...: Returns all exceptions in the recurrence information of an item (appointment or task).
; Syntax.........: _OL_ItemRecurrenceExceptionGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the appointment or task item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - AppointmentItem: The AppointmentItem object that is the exception. Not valid for deleted appointments
;                  |2 - Deleted:         Returns True if the AppointmentItem was deleted from the recurring pattern
;                  |3 - OriginalDate:    A Date indicating the original date and time of an AppointmentItem before it was altered.
;                  +Will return the original date even if the AppointmentItem has been deleted.
;                  +However, it will not return the original time if deletion has occurred
;                  Failure - Returns "" and sets @error:
;                  |1 - No appointment or task item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no recurrence information
;                  |4 - Error with GetRecurrencePattern. For more info please see @extended
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecurrenceExceptionGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, "")
	EndIf
	; Recurrence object of the appointment
	If $vItem.IsRecurring = False Then Return SetError(3, 0, "")
	Local $oRecurrence = $vItem.GetRecurrencePattern
	If @error Then Return SetError(4, @error, "")
	Local $aExceptions[$oRecurrence.Exceptions.Count + 1][3] = [[$oRecurrence.Exceptions.Count, 3]]
	Local $iIndex = 1
	For $oException In $oRecurrence.Exceptions
		$aExceptions[$iIndex][0] = $oException.AppointmentItem
		$aExceptions[$iIndex][1] = $oException.Deleted
		$aExceptions[$iIndex][2] = $oException.OriginalDate
		$iIndex += 1
	Next
	Return $aExceptions

EndFunc   ;==>_OL_ItemRecurrenceExceptionGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecurrenceExceptionSet
; Description ...: Defines an exception in the recurrence information of an item (appointment or task).
; Syntax.........: _OL_ItemRecurrenceExceptionSet($oOL, $vItem, $sStoreID, $sStartDate[, $sNewStartDate = ""[, $sNewEndDate = ""[, $sNewSubject = ""[, $sNewBody = ""]]]]
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem         - EntryID or object of the appointment or task item
;                  $sStoreID      - StoreID where the EntryID is stored. Use "Default" if you use the users mailbox
;                  $sStartDate    - Start date and time of the item to be changed
;                  $sNewStartDate - Optional: New start date and time
;                  $sNewEndDate   - Optional: New end date and time or duration in minutes
;                  $sNewSubject   - Optional: New subject
;                  $sNewBody      - Optional: New body
; Return values .: Success - item object of the exception item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No appointment or task item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no recurrence information
;                  |4 - Error with GetRecurrencePattern. For more info please see @extended
;                  |5 - Error accessing the specified occurrence. Date/time might be invalid. For more info please see @extended
;                  |6 - Error saving the exception. For more info please see @extended
; Author ........: water
; Modified.......:
; Remarks .......: To change more properties please use _OL_ItemModify
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecurrenceExceptionSet($oOL, $vItem, $sStoreID, $sStartDate, $sNewStartDate = "", $sNewEndDate = "", $sNewSubject = "", $sNewBody = "")

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Recurrence object of the appointment
	If $vItem.IsRecurring = False Then Return SetError(3, 0, 0)
	Local $oRecurrence = $vItem.GetRecurrencePattern
	If @error Then Return SetError(4, @error, 0)
	Local $oOccurrenceItem = $oRecurrence.GetOccurrence($sStartDate)
	If @error Then Return SetError(5, @error, 0)
	If $sNewStartDate <> "" Then $oOccurrenceItem.Start = $sNewStartDate
	If $sNewEndDate <> "" Then
		If IsNumber($sNewEndDate) Then
			$oOccurrenceItem.Duration = $sNewEndDate
		Else
			$oOccurrenceItem.End = $sNewEndDate
		EndIf
	EndIf
	If $sNewSubject <> "" Then $oOccurrenceItem.Subject = $sNewSubject
	If $sNewBody <> "" Then $oOccurrenceItem.Body = $sNewBody
	$oOccurrenceItem.Save
	If @error Then Return SetError(6, @error, 0)
	Return $oOccurrenceItem

EndFunc   ;==>_OL_ItemRecurrenceExceptionSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecurrenceGet
; Description ...: Returns recurrence information of an item (appointment or task).
; Syntax.........: _OL_ItemRecurrenceGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the appointment or task item
;                  $sStoreID - Optional: StoreID where the EntryID is stored (default = keyword "Default" = the users mailbox)
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1  - DayOfMonth:       Integer indicating the day of the month on which the recurring appointment or task occurs
;                  |2  - DayOfWeekMask:    OlDaysOfWeek constant representing the mask for the days of the week on which the recurring appointment or task occurs
;                  |3  - Duration:         Integer indicating the duration (in minutes) of the RecurrencePattern
;                  |4  - EndTime:          Time indicating the end time for a recurrence pattern
;                  |5  - Instance:         Integer specifying the count for which the recurrence pattern is valid for a given interval
;                  |6  - Interval:         Integer specifying the number of units of a given recurrence type between occurrences
;                  |7  - MonthOfYear:      Integer indicating which month of the year is valid for the specified recurrence pattern
;                  |8  - NoEndDate:        Boolean value that indicates True if the recurrence pattern has no end date
;                  |9  - Occurrences:      Integer indicating the number of occurrences of the recurrence pattern
;                  |10 - PatternEndDate:   Date indicating the end date for the recurrence pattern
;                  |11 - PatternStartDate: Date indicating the start date for the recurrence pattern
;                  |12 - RecurrenceType:   OlRecurrenceType constant specifying the frequency of occurrences for the recurrence pattern
;                  |13 - StartTime:        Time indicating the start time for a recurrence pattern
;                  Failure - Returns "" and sets @error:
;                  |1 - No appointment or task item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Item has no recurrence information
;                  |4 - Error with GetRecurrencePattern. For more info please see @extended
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecurrenceGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, "")
	EndIf
	; Recurrence object of the appointment
	If $vItem.IsRecurring = False Then Return SetError(3, 0, "")
	Local $oRecurrence = $vItem.GetRecurrencePattern
	If Not IsObj($oRecurrence) Or @error Then Return SetError(4, @error, "")
	Local $aPattern[14] = [14]
	$aPattern[1] = $oRecurrence.DayOfMonth
	$aPattern[2] = $oRecurrence.DayOfWeekMask
	$aPattern[3] = $oRecurrence.Duration
	$aPattern[4] = $oRecurrence.EndTime
	$aPattern[5] = $oRecurrence.Instance
	$aPattern[6] = $oRecurrence.Interval
	$aPattern[7] = $oRecurrence.MonthOfYear
	$aPattern[8] = $oRecurrence.NoEndDate
	$aPattern[9] = $oRecurrence.Occurrences
	$aPattern[10] = $oRecurrence.PatternEndDate
	$aPattern[11] = $oRecurrence.PatternStartDate
	$aPattern[12] = $oRecurrence.RecurrenceType
	$aPattern[13] = $oRecurrence.StartTime
	Return $aPattern

EndFunc   ;==>_OL_ItemRecurrenceGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemRecurrenceSet
; Description ...: Sets recurrence information of an item (appointment or task).
; Syntax.........: _OL_ItemRecurrenceSet($oOL, $vItem, $sStoreID, $sPatternStartDate, $sStartTime, $vPatternEndDate, $vEndTime, $iRecurrenceType, $iDayOf, $iInterval, $iInstance, $iOccurrences)
; Parameters ....: $oOL               - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem             - EntryID or object of the appointment or task item
;                  $sStoreID          - StoreID where the EntryID is stored. Use "Default" if you use the users mailbox
;                  $sPatternStartDate - Date indicating the start date for the recurrence pattern
;                  $sStartTime        - Time indicating the start time for the recurrence pattern
;                  $vPatternEndDate   - Date indicating the end date for the recurrence pattern OR
;                  +                    "" that indicates the recurrence pattern has no end date OR
;                  +                    an integer indicating the number of occurrences of the recurrence pattern
;                  $vEndTime          - Time indicating the end time for the recurrence pattern OR
;                  +                    an integer indicating the duration (in minutes) of the recurrence pattern
;                  $iRecurrenceType   - Constant specifying the frequency of occurrences for the recurrence pattern.
;                  +                    Is defined by the Outlook OlRecurrenceType enumeration
;                  $iDayOf            - DayOfWeekMask (mask for the days of the week on which the recurring appointment or task occurs) OR
;                  +                    DayOfMonth (integer indicating the day of the month on which the recurring appointment or task occurs) if $sRecurrenceType = $olRecursMonthly OR
;                  +                    DayOfMonth/MonthOfYear (integer indicating the day of the month and month of the year on which the recurring appointment or task occurs) if $sRecurrenceType = $olRecursYearly
;                  $iInterval         - Integer specifying the number of units of a given recurrence type between occurrences
;                  $iInstance         - Integer specifying the count for which the recurrence pattern is valid for a given interval.
;                                       Only valid for $sRecurrenceType $olRecursMonthNth and $olRecursYearNth
; Return values .: Success - Item object
;                  Failure - Returns 0 and sets @error:
;                  |1 - No appointment or task item specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error with Save. For more info please see @extended
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemRecurrenceSet($oOL, $vItem, $sStoreID, $sPatternStartDate, $sStartTime, $vPatternEndDate, $vEndTime, $iRecurrenceType, $iDayOf, $iInterval, $iInstance)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Recurrence object of the item
	Local $oRecurrence = $vItem.GetRecurrencePattern
	#forceref $oRecurrence ; to prevent the AU3Check warning: $oRecurrence: declared, but not used in func.
	; Set properties of the reccurrence
	$oRecurrence.RecurrenceType = $iRecurrenceType
	$oRecurrence.PatternStartDate = $sPatternStartDate
	$oRecurrence.StartTime = $sStartTime
	; Set PatternEndDate to date, number of occurrences or NoEndDate
	If IsInt($vPatternEndDate) Then
		$oRecurrence.Occurrences = $vPatternEndDate
	ElseIf $vPatternEndDate <> "" Then
		$oRecurrence.PatternEndDate = $vPatternEndDate
	Else
		$oRecurrence.NoEndDate = True
	EndIf
	; Set PatternEndTime to time or duration
	If IsInt($vEndTime) Then
		$oRecurrence.Duration = $vEndTime
	Else
		$oRecurrence.EndTime = $vEndTime
	EndIf
	; Set DayOfWeekMask or DayOfMonth and MonthOfYear
	If $iRecurrenceType = $olRecursYearly Then
		Local $aTemp = StringSplit($iDayOf, "/")
		$oRecurrence.DayOfMonth = $aTemp[1]
		$oRecurrence.MonthofYear = $aTemp[2]
	EndIf
	If $iRecurrenceType = $olRecursWeekly Or $iRecurrenceType = $olRecursMonthNth Or $iRecurrenceType = $olRecursYearNth And $iDayOf <> "" Then $oRecurrence.DayOfWeekMask = $iDayOf
	If $iRecurrenceType = $olRecursMonthly And $iDayOf <> "" Then $oRecurrence.DayOfMonth = $iDayOf
	; Set Interval
	If $iInterval <> 0 Then $oRecurrence.Interval = $iInterval
	; Set Instance
	If $iRecurrenceType = $olRecursMonthNth Or $iRecurrenceType = $olRecursYearNth And $iInstance <> 0 Then $oRecurrence.Instance = $iInstance
	$vItem.Save
	If @error Then Return SetError(3, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemRecurrenceSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemReply
; Description ...: Replies/responds to an item.
; Syntax.........: _OL_ItemReply($oOL, $vItem[, $sStoreID[, $bReplyAll = False[, $iResponse = $olMeetingAccepted]]])
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem     - EntryID or object of the item to move
;                  $sStoreID  - Optional: StoreID of the source store as returned by _OL_FolderAccess (default = keyword "Default" = the users mailbox)
;                  $bReplyAll - Optional: False: reply to the original sender (default), True: reply to all recipients
;                  $iResponse - Optional: Indicates the response to a meeting request. Is defined by the Outlook OlMeetingResponse enumeration
;                  +(default = $olMeetingAccepted = The meeting was accepted)
; Return values .: Success - object of the created item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No item has been specified
;                  |2 - Item could not be found. EntryID might be wrong
;                  |3 - Error with method .Reply, .ReplyAll or .Respond. For more info please see @extended
;                  |4 - Error with Save. For more info please see @extended
; Author ........: water
; Modified ......:
; Remarks .......: $bReplyAll is used for mail items and ignored for all other items
;                  $iResponse is used for meeting and task items and ignored for all other items
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemReply($oOL, $vItem, $sStoreID = Default, $bReplyAll = False, $iResponse = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	; Mail: reply or replyall
	If $vItem.Class = $olMail Then
		If $bReplyAll Then
			$vItem = $vItem.Reply
			If @error Then Return SetError(3, @error, 0)
		Else
			$vItem = $vItem.Reply
			If @error Then Return SetError(3, @error, 0)
		EndIf
	EndIf
	; Meeting request: Respond
	If $vItem.Class = $olAppointment Then
		If $iResponse = Default Then $iResponse = $olMeetingAccepted
		$vItem = $vItem.Respond($iResponse)
		If @error Then Return SetError(3, @error, 0)
	EndIf
	; Task: Respond
	If $vItem.Class = $olTask Then
		If $iResponse = Default Then $iResponse = $olTaskAccept
		$vItem = $vItem.Respond($iResponse)
		If @error Then Return SetError(3, @error, 0)
	EndIf
	$vItem.Close(0)
	If @error Then Return SetError(4, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemReply

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemSave
; Description ...: Saves an item (contact, appointment ...) and/or all attachments in the specified path with the specified type.
; Syntax.........: _OL_ItemSave($oOL, $vItem, $sStoreID, $sPath, $iType[, $iFlags = 0])
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem         - EntryID or object of the item to save
;                  $sStoreID      - StoreID of the source store as returned by _OL_FolderAccess. Use the keyword "Default" to use the users mailbox
;                  $sPath         - Path (drive, directory[, filename]) where to save the item.
;                                   If the filename is missing it is set to the item subject. In this case the directory needs a trailing backslash.
;                                   The extension is always set according to $iType.
;                                   If the directory does not exist it is created
;                  $iType         - The file type to save. Is defined by the Outlook OlSaveAsType enumeration
;                  $iFlags        - Optional: Flags to set different processing options. Can be a combination of the following:
;                  |  1: Save the item (default)
;                  |  2: Save attachments. Will be saved into the same directory as the item itself.
;                  +Name is Filename of the item, underscore plus name of attachment plus (optional) unterscore plus integer so multiple att. with the same name
;                  +can be saved
; Return values .: Success - Object of the saved item
;                  Failure - Returns 0 and sets @error:
;                  |1 - $sPath is missing
;                  |2 - Specified directory does not exist. It could not be created
;                  |3 - $iType is missing or invalid
;                  |4 - Error saving the item. For details check @extended
;                  |5 - Error saving an attachment. For details check @extended
;                  |6 - No or an invalid item has been specified
;                  |7 - Invalid $iType specified
;                  |8 - Could not save attachment. More than 99 files with the same filename encountered. @extended is set to the attachment number in error (1 based)
;                  |9 - Error retrieving attachments. @extended is set to the error code as returned by _OL_ItemAttachmentGet
;                  |10 - An attachment doesn't have filename/extension so it can't be saved. @extended is set to the attachment number in error (1 based). Use function _OL_ItemAttachmentSave to save such attachments
; Author ........: water
; Modified ......:
; Remarks .......: $iFlags: 1 = save the item without attachments, 2 = save attachments only, 3 = save item + attachments
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemSave($oOL, $vItem, $sStoreID, $sPath, $iType, $iFlags = 1)

	Local $aType2Ext[11][2] = [[$olDoc, ".doc"],[$olHTML, ".html"],[$olICal, ".ics"],[$olMHTML, ".mht"],[$olMSG, ".msg"],[$olMSGUnicode, ".msg"], _
			[$olRTF, ".rtf"],[$olTemplate, ".oft"],[$olTXT, ".txt"],[$olVCal, ".vcs"],[$olVCard, "vcf"]]
	Local $sDrive, $sDir, $sFName, $sExt
	If StringStripWS($sPath, 3) = "" Then Return SetError(1, 0, 0)
	_PathSplit($sPath, $sDrive, $sDir, $sFName, $sExt)
	If Not FileExists($sDrive & $sDir) Then
		If DirCreate($sDrive & $sDir) = 0 Then Return SetError(2, 0, 0)
	EndIf
	If Not IsNumber($iType) Then Return SetError(3, 0, 0)
	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(6, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(6, @error, 0)
	EndIf
	; Set filename to item subject if filename is empty
	If $sFName = "" Then $sFName = $vItem.Subject
	; Replace invalid characters from filename with underscore
	$sFName = StringRegExpReplace($sFName, '[ \/:*?"<>|]', '_')
	; Select extension according to $iType
	For $iIndex = 0 To UBound($aType2Ext) - 1
		If $aType2Ext[$iIndex][0] = $iType Then $sExt = $aType2Ext[$iIndex][1]
	Next
	If $sExt = "" Then Return SetError(7, 0, 0)
	$sPath = $sDrive & $sDir & $sFName & $sExt
	; Save item
	If BitAND($iFlags, 1) = 1 Then
		$vItem.SaveAs($sPath, $iType)
		If @error Then Return SetError(4, @error, 0)
	EndIf
	; Save attachments
	If BitAND($iFlags, 2) = 2 Then
		Local $aAttachments = _OL_ItemAttachmentGet($oOL, $vItem, $sStoreID)
		If @error = 0 Then
			For $iIndex = 1 To $aAttachments[0][0]
				If $aAttachments[$iIndex][2] = "" Then Return SetError(10, $iIndex, 0)
				If FileExists($sDrive & $sDir & $sFName & "_" & $aAttachments[$iIndex][2]) = 1 Then
					Local $aTemp = StringSplit($aAttachments[$iIndex][2], ".")
					For $iIndex2 = 1 To 99
						If FileExists($sDrive & $sDir & $sFName & "_" & $aTemp[1] & "_" & $iIndex2 & "." & $aTemp[2]) = 0 Then ExitLoop
					Next
					If $iIndex2 > 99 Then Return SetError(8, $iIndex, 0)
					$aAttachments[$iIndex][0] .SaveAsFile($sDrive & $sDir & $sFName & "_" & $aTemp[1] & "_" & $iIndex2 & "." & $aTemp[2])
					If @error Then Return SetError(5, @error, 0)
				Else
					$aAttachments[$iIndex][0] .SaveAsFile($sDrive & $sDir & $sFName & "_" & $aAttachments[$iIndex][2])
					If @error Then Return SetError(5, @error, 0)
				EndIf
			Next
		Else
			Return SetError(9, @error, 0)
		EndIf
	EndIf
	Return $vItem

EndFunc   ;==>_OL_ItemSave

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemSearch
; Description ...: Find items (extended search) using a DASL query returning an array of all specified properties.
; Syntax.........: _OL_ItemSearch($oOL, $vFolder, $avSearch, $sReturnProperties)
; Parameters ....: $oOL                  - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder           - Folder object as returned by _OL_FolderAccess or full name of folder where the search will be started.
;                  +If you want to search a default folder you have to specify the folder object.
;                  $avSearch          - Can bei either a string containing the full DASL query or a one based two-dimensional array with unlimited number of rows containing the elements to build the DASL query:
;                  |0: Property to query. This can be either the hex value or the name of the property. The function translates the name to the hex value. Unknown names set @error
;                  |1: Type of comparison operator: 1 = "=", 2 = "ci_startswith", 3 = "ci_phrasematch", 4 = "like"
;                  |2: Value to search for
;                  |3: Operator to concatenate the next comparison. Has to be "and", "or", "or not" or "and not"
;                      For details please see Remarks
;                  $sReturnProperties - Comma separated list of properties to return. Can be the property name (e.g. "subject") or the MAPI proptag (e.g. "http://schemas.microsoft.com/mapi/proptag/0x10F4000B")
; Return values .: Success - One based two-dimensional array with the properties specified by $sReturnProperties
;                  Failure - Returns "" and sets @error:
;                  |1  - $oOL is not an object
;                  |2  - Error accessing the specified folder. See @extended for errorcode returned by _OL_FolderAccess
;                  |3  - $sReturnProperties is empty
;                  |4  - $avSearch is an array but not a two dimensional array or the first row doesn't contain the numbers of rows and columns
;                  |5  - Specified search property could not be translated to a hex code. @extended is set to the row in $avSearch
;                  |6  - Specified search operator is not an integer or < 1 or > 4. @extended is set to the row in $avSearch
;                  |7  - Specified search value is empty. @extended is set to the row in $avSearch
;                  |8  - Invalid search operator. Must be "and" or "or". @extended is set to the row in $avSearch
;                  |9  - The last entry in the search array has a search operator
;                  |10 - The entry in the search array has no operator but more search arguments follow
;                  |11 - Error executing the search operation. @extended is set to the error returned by method GetTable
;                  |12 - No records returned by the search operation
;                  |13 - Error adding $sReturnProperties to the result set. @extended is the number of the property in error
;                  |14 - Error filling the result table. @extended is set to the error returned by method GetRowCount
; Author ........: water
; Modified ......:
; Remarks .......: DASL syntax: "Searching Outlook Data" - http://msdn.microsoft.com/en-us/library/cc513841.aspx"
;                  List of MAPI proptags:                - http://www.dimastr.com/redemption/enum_MAPITags.htm
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemSearch($oOL, $vFolder, $avSearch, $sReturnProperties)

    Local $asOperator[5] = [4, "=", "ci_startswith", "ci_phrasematch", "like"]
    Local $sFilter = '@SQL=', $aTemp, $sProperty, $iRows, $iCols, $oRow
    If Not IsObj($oOL) Then Return SetError(1, 0, "")
    If Not IsObj($vFolder) Then
        $aTemp = _OL_FolderAccess($oOL, $vFolder)
        If @error Then Return SetError(2, @error, "")
        $vFolder = $aTemp[1]
    EndIf
    If StringStripWs($sReturnProperties, 7) = "" Then Return SetError(3, 0, "")
    Local $aReturnProperties = StringSplit(StringStripWS($sReturnProperties, 8), ",")
    ; Build search string
    If IsArray($avSearch) Then
        If UBound($avSearch, 0) <> 2 Or Not IsInt($avSearch[0][0]) Or Not IsInt($avSearch[0][1]) Then Return SetError(4, 0, "")
        Local Const $sPropTag = "http://schemas.microsoft.com/mapi/proptag/"
        For $iIndex = 1 To $avSearch[0][0]
            If IsInt($avSearch[$iIndex][0]) Then
                $sProperty = "0x" & Hex(Int($avSearch[$iIndex][0]))
            Else
                $sProperty = __OL_Property2Hex($avSearch[$iIndex][0])
                If @error Then Return SetError(5, $iIndex, "")
            Endif
            If Not IsInt($avSearch[$iIndex][1]) Or $avSearch[$iIndex][1] < 1 Or $avSearch[$iIndex][1] > 4 Then Return SetError(6, $iIndex, "")
            $avSearch[$iIndex][2] = StringStripWS($avSearch[$iIndex][2], 7)
            If $avSearch[$iIndex][2] = "" Then Return SetError(7, $iIndex, "")
            $avSearch[$iIndex][3] = StringStripWS($avSearch[$iIndex][3], 7)
            If $avSearch[$iIndex][3] <> "" Then
                If $avSearch[$iIndex][3] <> "and" And $avSearch[$iIndex][3] <> "or" And _
                    $avSearch[$iIndex][3] <> "and not" And $avSearch[$iIndex][3] <> "or not" _
                    Then Return SetError(8, $iIndex, "")
                If $iIndex = $avSearch[0][0] Then Return SetError(9, $iIndex, "")
            Else
                If $iIndex < $avSearch[0][0] Then Return SetError(10, $iIndex, "")
            EndIf
            $sFilter = $sFilter & '"' & $sPropTag & $sProperty & '" ' & $asOperator[$avSearch[$iIndex][1]] & " '" & $avSearch[$iIndex][2] & "'"
            If $avSearch[$iIndex][3] <> "" Then $sFilter = $sFilter & " " & $avSearch[$iIndex][3] & " "
        Next
    Else
        $sFilter = $avSearch
    EndIf
    ; execute the search
    Local $oTable = $vFolder.GetTable($sFilter)
    If @error Or Not IsObj($oTable) Then Return SetError(11, @error, "")
    If $oTable.GetRowCount = 0 Then Return SetError(12, 0, "")
    ; http://msdn.microsoft.com/en-us/library/bb176396%28v=office.12%29.aspx
    ; Remove all columns in the default column set
    $oTable.Columns.RemoveAll
    ; Specify desired properties
    For $iIndex = 1 To $aReturnProperties[0]
        $oTable.Columns.Add($aReturnProperties[$iIndex])
        If @error Then Return SetError(13, $iIndex, "")
    Next
    ; Create and fill the result table
    $iRows = $oTable.GetRowCount + 1
    If @error Then Return SetError(14, @error, "")
    $iCols = $aReturnProperties[0]
    Local $avResult[$iRows][$iCols] = [[$iRows - 1]]
	If UBound($avResult, 2) > 1 Then $avResult[0][1] = $iCols
    Local $iIndex2 = 1
    While Not $oTable.EndOfTable
        $oRow = $oTable.GetNextRow
        For $iIndex = 1 To $aReturnProperties[0]
            $avResult[$iIndex2][$iIndex-1] = $oRow($aReturnProperties[$iIndex])
        Next
        $iIndex2 = $iIndex2 + 1
    WEnd
    Return $avResult

EndFunc   ;==>_OL_ItemSearch

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemSend
; Description ...: Sends an item (appointment, mail, task) using the specified EntryID and StoreID.
; Syntax.........: _OL_ItemSend($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the item to send
;                  $sStoreID - Optional: StoreID of the source store as returned by _OL_FolderAccess (default = keyword "Default" = the users mailbox)
; Return values .: Success - Object of the item
;                  Failure - Returns 0 and sets @error:
;                  |1 - No or an invalid item has been specified
;                  |2 - Error sending the item. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemSend($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, 0)
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(1, @error, 0)
	EndIf
	$vItem.Send()
	If @error Then Return SetError(2, @error, 0)
	Return $vItem

EndFunc   ;==>_OL_ItemSend

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemSendReceive
; Description ...: Initiates immediate delivery of all undelivered messages and immediate receipt of mail for all accounts in the current profile.
; Syntax.........: _OL_ItemSendReceive($oOL[, $bShowProgress = False])
; Parameters ....: $oOL           - Outlook object returned by a preceding call to _OL_Open()
;                  $bShowProgress - Optional: If True show the Outlook Send/Receive progress dialog box (default = False)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1  - Error executing the SendAndReceive method. For details check @extended
;                  |99 - Function not available for this Outlook version. @extended denotes the lowest required Outlook version to run the function
; Author ........: water
; Modified ......:
; Remarks .......: Only available for Outlook 2007 and later
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemSendReceive($oOL, $bShowProgress = False)

	Local $aVersion = StringSplit($oOL.Version, '.')
	If Int($aVersion[1]) < 12 Then Return SetError(99, 12, 0)
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	$oNamespace.SendAndReceive($bShowProgress)
	If @error Then Return SetError(1, @error, 0)
	Return 1

EndFunc   ;==>_OL_ItemSendReceive

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ItemSync
; Description ...: Starts synchronization for all or a single Send/Receive group(s) set up for the user.
; Syntax.........: _OL_ItemSync($oOL[, $sGroup = ""])
; Parameters ....: $oOL    - Outlook object returned by a preceding call to _OL_Open()
;                  $sGroup - Optional: Name of the Send/Receive group to be synchronized (default = all)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error returned by method Start. For details please check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ItemSync($oOL, $sGroup = "")

	Local $oNamespace = $oOL.GetNamespace("MAPI")
	For $iIndex = 1 To $oNamespace.SyncObjects.Count
		If $sGroup = "" Or $sGroup = $oNamespace.SyncObjects.Item($iIndex).Name Then
			$oNamespace.SyncObjects.Item($iIndex).Start
			If @error Then Return SetError(1, @error, 0)
		EndIf
	Next
	Return 1

EndFunc   ;==>_OL_ItemSync

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_MailheaderGet
; Description ...: Returns the headers of a mail item using the specified EntryID and StoreID.
; Syntax.........: _OL_MailheaderGet($oOL, $vItem[, $sStoreID])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the mail item
;                  $sStoreID - Optional: StoreID of the source store as returned by _OL_FolderAccess (default = keyword "Default" = the users mailbox)
; Return values .: Success - Returns a string with the mail headers
;                  Failure - Returns "" and sets @error:
;                  |1 - Error getting the mail object from the specified EntryID and StoreID
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_MailheaderGet($oOL, $vItem, $sStoreID = Default)

	Local $sPR_MAIL_HEADER_TAG = "http://schemas.microsoft.com/mapi/proptag/0x007D001E"
	If Not IsObj($vItem) Then $vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
	If @error Then Return SetError(1, @error, "")
	Local $oPA = $vItem.PropertyAccessor
	Return $oPA.GetProperty($sPR_MAIL_HEADER_TAG)

EndFunc   ;==>_OL_MailheaderGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_MailSignatureCreate
; Description ...: Creates a new/modifies an existing e-mail signature.
; Syntax.........: _OL_MailSignatureCreate($sName, $oWord, $oRange[, $bNewMessage = False[, $bReplyMessage = False]])
; Parameters ....: $sName          - Name of the signature to be created/modified.
;                  $oWord          - Object of an already running Word Application
;                  $oRange         - Range (as defined by the word range method) that contains the signature text + formatting
;                  $bNewMessage    - Optional: True sets the signature as the default signature to be added to new email messages (default = False)
;                  $bReplyMessage  - Optional: True sets the signature as the default signature to be added when you reply to an email messages (default = False)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oWord is not an object
;                  |2 - $sName is empty
;                  |3 - $oRange is not an object
;                  |4 - Error adding signature. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: If the signature already exists $bNewMessage and $bReplyMessage can be set but not unset. Use _OL_MailSignatureSet in this case.
; Related .......:
; Link ..........: http://technet.microsoft.com/en-us/magazine/2006.10.heyscriptingguy.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _OL_MailSignatureCreate($sName, $oWord, $oRange, $bNewMessage = False, $bReplyMessage = False)

	If Not IsObj($oWord) Then Return SetError(1, 0, "")
	If StringStripWS($sName, 3) = "" Then Return SetError(2, 0, "")
	If Not IsObj($oRange) Then Return SetError(3, 0, "")
	Local $oEmailOptions = $oWord.EmailOptions
	Local $oSignatureObject = $oEmailOptions.EmailSignature
	Local $oSignatureEntries = $oSignatureObject.EmailSignatureEntries
	$oSignatureEntries.Add($sName, $oRange)
	If @error Then Return SetError(4, @error, 0)
	If $bNewMessage Then $oSignatureObject.NewMessageSignature = $sName
	If $bReplyMessage Then $oSignatureObject.ReplyMessageSignature = $sName
	Return 1

EndFunc   ;==>_OL_MailSignatureCreate

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_MailSignatureDelete
; Description ...: Deletes an existing e-mail signature.
; Syntax.........: _OL_MailSignatureDelete($sSignature[, $oWord = 0])
; Parameters ....: $sSignature - Name of the signature to be created/modified
;                  $oWord      - Optional: Object of an already running Word Application (default = 0 = no Word Application running)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oWord is not an object
;                  |2 - $sSignature is empty
;                  |3 - $sSignature does not exist
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_MailSignatureDelete($sSignature, $oWord = 0)

	If StringStripWS($sSignature, 3) = "" Then Return SetError(2, 0, "")
	Local $bWordStart = False
	If $oWord = 0 Then
		$oWord = ObjCreate("Word.Application")
		$bWordStart = True
	EndIf
	If @error Or Not IsObj($oWord) Then Return SetError(1, @error, "")
	; Check if the specified signatures exist
	_OL_MaiLSignatureGet($sSignature, $oWord)
	If @error Then
		If $bWordStart = True Then
			$oWord.Quit
			$oWord = 0
		EndIf
		Return SetError(3, 0, 0)
	EndIf
	Local $oEmailOptions = $oWord.EmailOptions
	Local $oSignatureObject = $oEmailOptions.EmailSignature
	Local $oSignatureEntries = $oSignatureObject.EmailSignatureEntries
	$oSignatureEntries.Item($sSignature).Delete
	Local $iError = @error, $iExtended = @extended
	If $bWordStart = True Then
		$oWord.Quit
		$oWord = 0
	EndIf
	If $iError <> 0 Then Return SetError($iError, $iExtended, 0)
	Return 1

EndFunc   ;==>_OL_MailSignatureDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_MailSignatureGet
; Description ...: Returns a list of e-mail signatures used when you create/edit e-mail messages and replies.
; Syntax.........: _OL_MailSignatureGet([$sSignature = ""[, $oWord = 0]])
; Parameters ....: $sSignature - Optional: Name of a signature to check for existance. The result contains this single signature or is set to error.
;                  $oWord      - Optional: Object of an already running Word Application (default = 0 = no Word Application running)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Name of the signature
;                  |1 - True if the signature is used when creating new messages
;                  |2 - True if the signature is used when replying to a message
;                  Failure - Returns "" and sets @error:
;                  |1 - Error accessing word object. For details check @extended
;                  |2 - Specified signature does not exist
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_MailSignatureGet($sSignature = "", $oWord = 0)

	Local $bWordStart = False
	If $oWord = 0 Then
		$oWord = ObjCreate("Word.Application")
		$bWordStart = True
	EndIf
	If @error Or Not IsObj($oWord) Then Return SetError(1, @error, "")
	Local $oEmailOptions = $oWord.EmailOptions
	Local $oSignatureObject = $oEmailOptions.EmailSignature
	Local $oSignatureEntries = $oSignatureObject.EmailSignatureEntries
	Local $sNewMessageSig = $oSignatureObject.NewMessageSignature
	Local $sReplyMessageSig = $oSignatureObject.ReplyMessageSignature
	Local $aSignatures[$oSignatureEntries.Count + 1][3]
	Local $iIndex = 0
	For $oSignatureEntry In $oSignatureEntries
		If $sSignature = "" Or $sSignature == $oSignatureEntry.Name Then
			$iIndex = $iIndex + 1
			$aSignatures[$iIndex][0] = $oSignatureEntry.Name
			If $aSignatures[$iIndex][0] = $sNewMessageSig Then
				$aSignatures[$iIndex][1] = True
			Else
				$aSignatures[$iIndex][1] = False
			EndIf
			If $aSignatures[$iIndex][0] = $sReplyMessageSig Then
				$aSignatures[$iIndex][2] = True
			Else
				$aSignatures[$iIndex][2] = False
			EndIf
		EndIf
	Next
	ReDim $aSignatures[$iIndex + 1][3]
	$aSignatures[0][0] = $iIndex
	$aSignatures[0][1] = UBound($aSignatures, 2)
	If $bWordStart = True Then
		$oWord.Quit
		$oWord = 0
	EndIf
	If $sSignature <> "" And $aSignatures[0][0] = 0 Then Return SetError(2, 0, "")
	Return $aSignatures

EndFunc   ;==>_OL_MailSignatureGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_MailSignatureSet
; Description ...: Sets the signature to be added to new email messages and/or when you reply to an email message.
; Syntax.........: _OL_MailSignatureSet($sNewMessage, $sReplyMessage[, $oWord = 0])
; Parameters ....: $sNewMessage   - Name of the signature to be added to new email messages. "" removes the default signature. Keyword Default leaves the signature unchanged
;                  $sReplyMessage - Name of the signature to be added when you reply to an email messages. "" removes the default signature. Keyword Default leaves the signature unchanged
;                  $oWord         - Optional: Object of an already running Word Application (default = 0 = no Word Application running)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oWord is not an object
;                  |2 - Error getting list of signatures using _OL_MailSignatureGet. Please check @extended
;                  |3 - $sNewMessage could not be found in the list of already defined signatures.
;                  |4 - $sReplyMessage could not be found in the list of already defined signatures.
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_MailSignatureSet($sNewMessage, $sReplyMessage, $oWord = 0)

	Local $bWordStart = False
	If $oWord = 0 Then
		$oWord = ObjCreate("Word.Application")
		$bWordStart = True
	EndIf
	If @error Or Not IsObj($oWord) Then Return SetError(1, @error, "")
	; Check if the specified signatures exist
	If $sNewMessage <> Default And $sNewMessage <> "" Then
		_OL_MaiLSignatureGet($sNewMessage, $oWord)
		If @error Then
			If $bWordStart = True Then
				$oWord.Quit
				$oWord = 0
			EndIf
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	If $sReplyMessage <> Default And $sReplyMessage <> "" Then
		_OL_MaiLSignatureGet($sReplyMessage, $oWord)
		If @error Then
			If $bWordStart = True Then
				$oWord.Quit
				$oWord = 0
			EndIf
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	; Set Signatures
	Local $oEmailOptions = $oWord.EmailOptions
	Local $oSignatureObject = $oEmailOptions.EmailSignature
	#forceref $oSignatureObject
	If $sNewMessage <> Default Then $oSignatureObject.NewMessageSignature = $sNewMessage
	If $sReplyMessage <> Default Then $oSignatureObject.ReplyMessageSignature = $sReplyMessage
	If $bWordStart = True Then
		$oWord.Quit
		$oWord = 0
	EndIf
	Return 1

EndFunc   ;==>_OL_MailSignatureSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_OOFGet
; Description ...: Returns information about the OOF (Out of Office) setting of the specified store.
; Syntax.........: _OL_OOFGet($oOL[, $sStore = "*"])
; Parameters ....: $oOL    - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore - Optional: Store for which the OOF should be retrieved.
;                            Use "*" to denote your default store or specify the store of another user
; Return values .: Success - one-dimensional one based array with the following information:
;                  |0 - State of the OOF. True = OOF is set, False = OOF is not set
;                  |1 - OOF text for internal senders
;                  Failure - Returns "" and sets @error:
;                  |1 - The specified store could not be accessed
;                  |2 - Error accessing the internal OOF mail item. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://social.msdn.microsoft.com/Forums/en-US/outlookdev/thread/3e3dd60b-a9ce-4484-b974-6b78766e376b
; Example .......: Yes
; ===============================================================================================================================
Func _OL_OOFGet($oOL, $sStore = "*")

	Local $oItem, $aOOF[3] = [2]
	Local $aFolder = _OL_FolderAccess($oOL, "\\" & $sStore, $olFolderInbox)
	If @error Then Return SetError(1, @error, 0)
	If $sStore = "*" Then $sStore = $aFolder[1] .Parent.Name
	; Get the status of the OOF for the specified store
	$aOOF[1] = $oOL.Session.Stores.Item($sStore).PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x661D000B")
	; Get the text of the internal OOF
	$oItem = $aFolder[1] .GetStorage("IPM.Note.Rules.OofTemplate.Microsoft", $olIdentifyByMessageClass)
	If @error Then Return SetError(2, @error, 0)
	$aOOF[2] = $oItem.Body
	Return $aOOF

EndFunc   ;==>_OL_OOFGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_OOFSet
; Description ...: Sets the OOF (Out of Office) message for your or another users Exchange Store and/or activates/deactivates the OOF.
; Syntax.........: _OL_OOFSet($oOL, $sStore, $bOOFActivate, $sOOFText)
; Parameters ....: $oOL          - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore       - Store for which the OOF should be set. Use "*" to denote your default store or specify the store of another user if you have write permission
;                  $bOOFActivate - If set to True the OOF is activated. Keyword Default leaves the status unchanged
;                  $sOOFText     - OOF reply text for internal messages. "" clears the text. Keyword Default leaves the text unchanged
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error returned by _OL_FolderAccess (the error code of this function can be found in @extended)
;                  |2 - Invalid StoreType. Has to be $olPrimaryExchangeMailbox or $olExchangeMailbox
;                  |3 - Error returned by Outlook GetStorage method for the internal OOF. For details please see @extended
;                  |4 - Error returned by Outlook Save method for the internal OOF. For details please see @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://social.msdn.microsoft.com/Forums/en-US/outlookdev/thread/99b07ca3-e26c-4eab-b644-2c7749638f0e
; Example .......: Yes
; ===============================================================================================================================
Func _OL_OOFSet($oOL, $sStore, $bOOFActivate, $sOOFText)

	Local $oItem
	Local $aFolder = _OL_FolderAccess($oOL, "\\" & $sStore, $olFolderInbox)
	If @error Then Return SetError(1, @error, 0)
	If $sStore = "*" Then $sStore = $aFolder[1] .Parent.Name
	Local $iStoreType = $oOL.Session.Stores.Item($sStore).ExchangeStoreType
	If $iStoreType <> $olPrimaryExchangeMailbox And $iStoreType <> $olExchangeMailbox Then Return SetError(2, 0, 0)
	; Set the text of the internal OOF
	If $sOOFText <> Default Then
		$oItem = $aFolder[1] .GetStorage("IPM.Note.Rules.OofTemplate.Microsoft", $olIdentifyByMessageClass)
		If @error Then Return SetError(3, @error, 0)
		$oItem.Body = $sOOFText
		$oItem.Save
		If @error Then Return SetError(4, @error, 0)
	EndIf
	; Set the status of the OOF for the specified store
	If $bOOFActivate <> Default Then _
			$oOL.Session.Stores.Item($sStore).PropertyAccessor.SetProperty("http://schemas.microsoft.com/mapi/proptag/0x661D000B", $bOOFActivate)
	Return 1

EndFunc   ;==>_OL_OOFSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_PSTAccess
; Description ...: Accesses a PST file so Outlook can access it as a folder.
; Syntax.........: _OL_PSTAccess($oOL, $sPSTPath[, $sDisplayName = ""])
; Parameters ....: $oOL          - Outlook object returned by a preceding call to _OL_Open()
;                  $sPSTPath     - Path of the PST file (including filename & extension)
;                  $sDisplayName - Optional: Displayname of the resulting Outlook folder (default = let Outlook set the display name)
; Return values .: Success - Object to the folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - PST file $sPSTPath does not exist
;                  |2 - Error accessing namespace object. For details check @extended
;                  |3 - Error adding the PST file as an Outlook folder. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: You can pass element 1 of the resulting array to _OL_Folderget to get further information.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_PSTAccess($oOL, $sPSTPath, $sDisplayName = "")

	If FileExists($sPSTPath) = 0 Then Return SetError(1, 0, 0)
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If @error Or Not IsObj($oNamespace) Then Return SetError(2, 0, 0)
	$oNamespace.AddStore($sPSTPath)
	If @error Then Return SetError(3, @error, 0)
	If $sDisplayName <> "" Then $oNamespace.Folders.GetLast.Name = $sDisplayName ; Set Displayname
	Return $oNamespace.Folders.GetLast

EndFunc   ;==>_OL_PSTAccess

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_PSTClose
; Description ...: Closes a PST file and removes the Outlook folder.
; Syntax.........: _OL_PSTClose($oOL, $oFolder)
; Parameters ....: $oOL     - Outlook object returned by a preceding call to _OL_Open()
;                  $vFolder - Object of the Outlook folder representing the PST file or the displayname of the folder
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing Namespace object. For details check @extended
;                  |2 - Error accessing the specified folder. For details check @extended
;                  |3 - Error removing the specified folder. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: You can pass element 1 of the resulting array to _OL_Folderget to get further information.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_PSTClose($oOL, $oFolder)

	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If @error Or Not IsObj($oNamespace) Then Return SetError(1, 0, 0)
	If Not IsObj($oFolder) Then
		$oFolder = $oNamespace.Folders.Item($oFolder)
		If @error Or Not IsObj($oFolder) Then Return SetError(2, @error, 0)
	EndIf
	$oNamespace.RemoveStore($oFolder)
	If @error Then Return SetError(3, @error, 0)
	Return 1

EndFunc   ;==>_OL_PSTClose

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_PSTCreate
; Description ...: Creates a new (empty) PST file and accesses it in Outlook as a folder.
; Syntax.........: _OL_PSTCreate($oOL, $sPSTPath[, $sDisplayName = ""[, $iPSTType = $olStoreANSI]])
; Parameters ....: $oOL          - Outlook object returned by a preceding call to _OL_Open()
;                  $sPSTPath     - Path of the PST file (including filename & extension)
;                  $sDisplayName - Optional: Displayname of the resulting Outlook folder (default = let Outlook set the display name)
;                  $iPSTType     - Optional: Type of the PST file. Possible values:
;                  |$olStoreANSI    - ANSI format compatible with all previous versions of Microsoft Office Outlook format (default)
;                  |$olStoreDefault - Default format compatible with the mailbox mode in which Microsoft Office Outlook runs on the Microsoft Exchange Server
;                  |$olStoreUnicode - Unicode format compatible with Microsoft Office Outlook 2003 and later
; Return values .: Success - Object to the folder
;                  Failure - Returns 0 and sets @error:
;                  |1 - PST file $sPSTPath already exists
;                  |2 - Error accessing Namespace object. For details check @extended
;                  |3 - Error creating the PST file. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_PSTCreate($oOL, $sPSTPath, $sDisplayName = "", $iPSTType = $olStoreANSI)

	If FileExists($sPSTPath) = 1 Then Return SetError(1, 0, 0)
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If @error Or Not IsObj($oNamespace) Then Return SetError(2, 0, 0)
	$oNamespace.AddStoreEx($sPSTPath, $iPSTType)
	If @error Then Return SetError(3, @error, 0)
	If $sDisplayName <> "" Then $oNamespace.Folders.GetLast.Name = $sDisplayName ; Set Displayname
	Return $oNamespace.Folders.GetLast

EndFunc   ;==>_OL_PSTCreate

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_PSTGet
; Description ...: Returns a list of currently accessed PST files.
; Syntax.........: _OL_PSTGet($oOL)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Displayname of the folder
;                  |1 - Object of the folder
;                  |2 - Path to the PST file in the filesystem
;                  Failure - Returns "" and sets @error:
;                  |1 - Error accessing namespace object. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: You can pass element 1 of the resulting array to _OL_Folderget to get further information.
; Related .......:
; Link ..........:                                                                                  
; Example .......: Yes
; ===============================================================================================================================
Func _OL_PSTGet($oOL)

	Local $sFolderSubString, $sPath, $iIndex1 = 0, $iIndex2, $iPos, $aPST[1][3] = [[0, 3]]
	Local $oNamespace = $oOL.GetNamespace("MAPI")
	If @error Or Not IsObj($oNamespace) Then Return SetError(1, 0, "")
	For $oFolder In $oNamespace.Folders
		$sPath = ""
		For $iIndex2 = 1 To StringLen($oFolder.StoreID) Step 2
			$sFolderSubString = StringMid($oFolder.StoreID, $iIndex2, 2)
			If $sFolderSubString <> "00" Then $sPath &= Chr(Dec($sFolderSubString))
		Next
		If StringInStr($sPath, "mspst.dll") > 0 Then ; PST file
			$iPos = StringInStr($sPath, ":\")
			If $iPos > 0 Then
				$sPath = StringMid($sPath, $iPos - 1)
			Else
				$iPos = StringInStr($sPath, "\\")
				If $iPos > 0 Then $sPath = StringMid($sPath, $iPos)
			EndIf
			ReDim $aPST[UBound($aPST, 1) + 1][UBound($aPST, 2)]
			$iIndex1 = $iIndex1 + 1
			$aPST[$iIndex1][0] = $oFolder.Name
			$aPST[$iIndex1][1] = $oNamespace.GetFolderFromID($oFolder.EntryID, $oFolder.StoreID)
			$aPST[$iIndex1][2] = $sPath
			$aPST[0][0] = $iIndex1
		EndIf
	Next
	Return $aPST

EndFunc   ;==>_OL_PSTGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RecipientFreeBusyGet
; Description ...: Returns free/busy information for the recipient.
; Syntax.........: _OL_RecipientFreeBusyGet($oOL, $vRecipient, $sStart[, $iMinPerChar = 30[, $bCompleteFormat = False]])
; Parameters ....: $oOL             - Outlook object returned by a preceding call to _OL_Open()
;                  $vRecipient      - Name of a recipient or resolved object of a recipient
;                  $sStart          - The start date for the returned period of free/busy information
;                  $iMinPerChar     - Optional: The number of minutes per character represented in the returned free/busy string (default = 30)
;                  $bCompleteFormat - Optional: True if the returned string should contain not only free/busy information, but also values for
;                  +each character according to the OlBusyStatus constants (default = False)
; Return values .: Success - String of free/busy information
;                  Failure - Returns "" and sets @error:
;                  |1 - No recipient has been specified
;                  |2 - Error creating recipient object. For details check @extended
;                  |3 - Recipient could not be resolved. For details check @extended
;                  |4 - Error retrieving the free/busy inforamtion. For details check @extended
; Author ........: water
; Modified ......:
; Remarks .......: The default is to return a string representing one month of free/busy information.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RecipientFreeBusyGet($oOL, $vRecipient, $sStart, $iMinPerChar = 30, $bCompleteFormat = False)

	; Recipient specified as name - resolve
	If Not IsObj($vRecipient) Then
		If StringStripWS($vRecipient, 3) = "" Then Return SetError(1, 0, "")
		$vRecipient = $oOL.Session.CreateRecipient($vRecipient)
		If @error Or Not IsObj($vRecipient) Then Return SetError(2, @error, "")
		$vRecipient.Resolve
		If @error Or Not $vRecipient.Resolved Then Return SetError(3, @error, "")
	EndIf
	Local $sFreeBusy = $vRecipient.FreeBusy($sStart, $iMinPerChar, $bCompleteFormat)
	If @error Or $sFreeBusy = "" Then Return SetError(4, @error, "")
	Return $sFreeBusy

EndFunc   ;==>_OL_RecipientFreeBusyGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ReminderDelay
; Description ...: Delays the reminder by a specified time.
; Syntax.........: _OL_ReminderDelay($oReminder[, $iDelayTime = 5])
; Parameters ....: $oReminder  - Represents a reminder object
;                  $iDelayTime - Optional: amount of time (in minutes) to delay the reminder (default = 5)
; Return values .: Success - 1
;                  Failure - 0 and sets @error:
;                  |1 - You didn't specify our you specified an invalid object
;                  |2 - $iDelayTime is not an integer
;                  |3 - Error returned by method .Snooze. For more information check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ReminderDelay($oReminder, $iDelayTime = 5)

	If Not IsObj($oReminder) Then Return SetError(1, 0, 0)
	If Not IsInt($iDelayTime) Then Return SetError(2, 0, 0)
	$oReminder.Snooze($iDelayTime)
	If @error Then Return SetError(3, @error, 0)
	Return 1

EndFunc   ;==>_OL_ReminderDelay

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ReminderDismiss
; Description ...: Dismisses the specified reminder.
; Syntax.........: _OL_ReminderDismiss($oOL, $iReminder)
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $iReminder - Index number of the object in the reminders collection
; Return values .: Success - 1
;                  Failure - 0 and sets @error:
;                  |1 - The reminder has to be visible to be dismissed
;                  |2 - Error returned by method .Dismiss. For more information check @extended
; Author ........: water
; Modified ......:
; Remarks .......: The Dismiss method will fail if there is no visible reminder
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ReminderDismiss($oOL, $iReminder)

	If $oOL.Reminders.Item($iReminder).IsVisible = False Then Return SetError(1, 0, 0)
	$oOL.Reminders.Item($iReminder).Dismiss()
	If @error Then Return SetError(2, @error, 0)
	Return 1

EndFunc   ;==>_OL_ReminderDismiss

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ReminderGet
; Description ...: Returns all or only visible reminders.
; Syntax.........: _OL_ReminderGet($oOL[, $bIsVisible = True])
; Parameters ....: $oOL        - Outlook object returned by a preceding call to _OL_Open()
;                  $bIsVisible - Optional: Only return visible reminders (default = True)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - String representing the title
;                  |1 - OlObjectClass constant indicating the object's class of the specified outlook item (see element 4)
;                  |2 - Boolean that determines if the reminder is currently visible
;                  |3 - Object corresponding to the Reminder
;                  |4 - Object corresponding to the specified Outlook item (AppointmentItem, MailItem, ContactItem, TaskItem)
;                  |5 - Date that indicates the next date and time the specified reminder will occur
;                  |6 - Date that specifies the original date and time that the specified reminder is set to occur
;                  Failure - Returns "" and sets @error:
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ReminderGet($oOL, $bIsVisible = True)

	Local $iIndex = 1, $aReminders[$oOL.Reminders.Count + 1][7]
	For $oReminder In $oOL.Reminders
		If $bIsVisible = False Or ($bIsVisible = True And $oReminder.IsVisible) Then
			$aReminders[$iIndex][0] = $oReminder.Caption
			$aReminders[$iIndex][1] = $oReminder.Item.Class
			$aReminders[$iIndex][2] = $oReminder.IsVisible
			$aReminders[$iIndex][3] = $oReminder
			$aReminders[$iIndex][4] = $oReminder.Item
			$aReminders[$iIndex][5] = $oReminder.NextReminderDate
			$aReminders[$iIndex][6] = $oReminder.OriginalReminderDate
			$iIndex += 1
		EndIf
	Next
	ReDim $aReminders[$iIndex][UBound($aReminders, 2)]
	$aReminders[0][0] = $iIndex - 1
	$aReminders[0][1] = UBound($aReminders, 2)
	Return $aReminders

EndFunc   ;==>_OL_ReminderGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleActionGet
; Description ...: Returns all actions for a specified rule.
; Syntax.........: _OL_RuleActionGet($oRule[, $bEnabled = True])
; Parameters ....: $oRule    - Rule object returned by a preceding call to _OL_RuleGet in element 0
;                  $bEnabled - Optional: Only returns enabled actions if set to True (default = True)
; Return values .: Success - two-dimensional one based array with the following information:
;                  Elements 0 - 2 are the same for every action type. The other elements (if any) depend on the action type.
;                  |0 - OlRuleActionType constant indicating the type of action that is taken by the rule action
;                  |1 - OlObjectClass constant indicating the class of the rule action
;                  |2 - True if the action is enabled
;                  |AssignToCategoryRuleAction
;                  |3 - Categories assigned to the message separated by the pipe character
;                  |MoveOrCopyRuleAction
;                  |3 - Object of the folder where the message will be copied/moved to
;                  |4 - Name of the folder where the message will be copied/moved to
;                  |SendRuleAction
;                  |3 - Recipients collection (object) that represents the recipient list for the cc/forward/redirect action
;                  |4 - Recipients (string) separated by the pipe character
;                  |MarkAsTaskRuleAction
;                  |3 - String that represents the label of the flag for the message
;                  |4 - constant in the OlMarkInterval enumeration representing the interval before the task is due
;                  |NewItemAlertRuleAction
;                  |3 - Text to be displayed in the new item alert dialog box
;                  |PlaySoundRuleAction
;                  |3 - Full file path to a sound file (.wav)
;                  Failure - Returns "" and sets @error:
;                  |1 - The ActionType can not be handled by this function. @extended contains the ActionType in error
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleActionGet($oRule, $bEnabled = True)

	Local $iIndex = 1
	Local $aActions[$oRule.Actions.Count + 1][5] = [[$oRule.Actions.Count, 5]]
	For $oAction In $oRule.Actions
		If $bEnabled = False Or $oAction.Enabled = True Then
			; Properties that apply to all action types
			$aActions[$iIndex][0] = $oAction.ActionType
			$aActions[$iIndex][1] = $oAction.Class
			$aActions[$iIndex][2] = $oAction.Enabled
			; Properties that apply to individual action types
			Switch $oAction.ActionType
				Case $olRuleActionAssignToCategory ; AssignToCategoryRuleAction object
					Local $aCategories = $oAction.Categories ; array of strings representing the categories assigned to the message
					$aActions[$iIndex][3] = _ArrayToString($aCategories)
				Case $olRuleActionMoveToFolder, $olRuleActionCopyToFolder ; MoveOrCopyRuleAction object
					$aActions[$iIndex][3] = $oAction.Folder ; Folder object that represents the folder to which the rule moves or copies the message
					If IsObj($oAction.Folder) Then $aActions[$iIndex][4] = $oAction.Folder.Name
				Case $olRuleActionCcMessage, $olRuleActionForward, $olRuleActionForwardAsAttachment, $olRuleActionRedirect ; SendRuleAction object
					$aActions[$iIndex][3] = $oAction.Recipients ; collection that represents the recipient list for the send action
					Local $sRecipients
					For $oRecipient In $oAction.Recipients
						$sRecipients = $sRecipients & $oRecipient.Name & "|"
					Next
					$aActions[$iIndex][4] = StringLeft($sRecipients, StringLen($sRecipients) - 1)
				Case $olRuleActionMarkAsTask ; MarkAsTaskRuleAction object
					$aActions[$iIndex][3] = $oAction.FlagTo ; String that represents the label of the flag for the message
					$aActions[$iIndex][4] = $oAction.MarkInterval ; constant in the OlMarkInterval enumeration representing the interval before the task is due
				Case $olRuleActionNewItemAlert ; NewItemAlertRuleAction object
					$aActions[$iIndex][3] = $oAction.Text ; String that represents the text displayed in the new item alert dialog box
				Case $olRuleActionPlaySound ; PlaySoundRuleAction object
					$aActions[$iIndex][3] = $oAction.FilePath ; Full file path to a sound file (.wav)
				Case $olRuleActionClearCategories, $olRuleActionDelete, $olRuleActionDeletePermanently, _ ; Actions without additional properties
						$olRuleActionDesktopAlert, $olRuleActionNotifyDelivery, $olRuleActionNotifyRead, $olRuleActionStop
				Case $olRuleActionServerReply, $olRuleActionTemplate, $olRuleActionFlagForActionInDays, _ ; Types not yet handled by Outlook object model
						$olRuleActionFlagColor, $olRuleActionFlagClear, $olRuleActionImportance, $olRuleActionSensitivity, _
						$olRuleActionPrint, $olRuleActionMarkRead, $olRuleActionDefer, $olRuleActionStartApplication
				Case Else
					Return SetError(1, $oAction.ActionType, "")
			EndSwitch
			$iIndex += 1
		EndIf
	Next
	ReDim $aActions[$iIndex][UBound($aActions, 2)]
	$aActions[0][0] = $iIndex - 1
	Return $aActions

EndFunc   ;==>_OL_RuleActionGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleActionSet
; Description ...: Adds a new or overwrites an existing action of an existing rule of the specified store.
; Syntax.........: _OL_RuleActionSet($oOL, $sStore, $sRuleName, $iRuleActionType, $bEnabled[, $sP1 = ""[, $sP2 = ""]])
; Parameters ....: $oOL             - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore          - Name of the Store where the rule will be defined. "*" = your default store
;                  $sRuleName       - Name of the rule
;                  $iRuleActionType - Type of the rule action. Please see the OlRuleActionType enumeration
;                  $bEnabled        - True sets the rule action to enabled
;                  $sP1             - Optional: Data to create the rule action depending on $iRuleActionType. Please check remarks for details
;                  $sP2             - Optional: Same as $sP1
; Return values .: Success - Object of the added action
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified store. For details please check @extended
;                  |2 - Error accessing the rule collection. For details please check @extended
;                  |3 - Error accessing the specified rule. For details please check @extended
;                  |4 - Error creating the action for the specified rule. For details please check @extended
;                  |5 - Error saving the specified rule. For details please check @extended
;                  |6 - $sP1 is not an folder object for rule action type $olRuleActionMoveToFolder or $olRuleActionCopyToFolder
;                  |7 - Error adding a recipient. For details please check @extended
;                  |8 - Error resolving recipients. @extended is the 1-based number of the recipient in error
;                  |9 - The specified rule action is not valid for the rule type (send/receive)
;                  |10 - The specified wav sound file could not be found
;                  |11 - The specified $iRuleActionType is invalid
;                  |12 - The specified $iRuleActionType is not supported by the Outlook object model at the moment
; Author ........: water
; Modified ......:
; Remarks .......: Not all possible rule actions can be created using the COM model.
;                  To remove an action from a rule set $bEnabled to False.
;                  Remarks for different types of actions:
;+
;                  $olRuleActionAssignToCategory:
;                  $sP1: Specify a string of categories to be assigned to the message separated by the pipe character e.g. "Birthday|Private"
;+
;                  $olRuleActionMoveToFolder, $olRuleActionCopyToFolder:
;                  $sP1: Folder object that represents the folder to which the rule moves or copies the message
;+
;                  $olRuleActionCcMessage, $olRuleActionForward, $olRuleActionForwardAsAttachment, $olRuleActionRedirect
;                  $sP1: collection that represents the recipient list for the send action e.g. "George Smith;John Doe"
;+
;                  $olRuleActionMarkAsTask:
;                  $sP1: String that represents the label of the flag for the message e.g. "Very urgent!"
;                  $sP2: constant in the OlMarkInterval enumeration representing the interval before the task is due
;+
;                  $olRuleActionNewItemAlert:
;                  $sP1: String that represents the text displayed in the new item alert dialog box
;+
;                  $olRuleActionPlaySound:
;                  $sP1: Full file path to a sound file (.wav) e.g. "C:\Windows\Media\Tada.wav"
;+
;                  $olRuleActionClearCategories, $olRuleActionDelete, $olRuleActionDeletePermanently, $olRuleActionDesktopAlert,
;                  $olRuleActionNotifyDelivery, $olRuleActionNotifyRead, $olRuleActionStop:
;                  No parameters need to be set
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/bb206764(v=office.12).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleActionSet($oOL, $sStore, $sRuleName, $iRuleActionType, $bEnabled, $sP1 = "", $sP2 = "")

	Local $oAction
	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oStore = $oOL.Session.Stores.Item($sStore)
	If @error Then Return SetError(1, @error, 0)
	Local $oRules = $oStore.GetRules()
	If @error Then Return SetError(2, @error, 0)
	Local $oRule = $oRules.Item($sRuleName)
	If @error Then Return SetError(3, @error, 0)
	; Properties that apply to individual action types
	Switch $iRuleActionType
		Case $olRuleActionAssignToCategory ; AssignToCategoryRuleAction object
			$oAction = $oRule.Actions.AssignToCategory
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			$oAction.Categories = StringSplit($sP1, "|", 2) ; array of strings representing the categories assigned to the message
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olRuleActionMoveToFolder, $olRuleActionCopyToFolder ; MoveOrCopyRuleAction object
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionMoveToFolder Then Return SetError(9, 0, 0)
			If Not IsObj($sP1) Then Return SetError(6, 0, 0)
			If $iRuleActionType = $olRuleActionMoveToFolder Then $oAction = $oRule.Actions.MoveToFolder
			If $iRuleActionType = $olRuleActionCopyToFolder Then $oAction = $oRule.Actions.CopyToFolder
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			$oAction.Folder = $sP1 ; Folder object that represents the folder to which the rule moves or copies the message
		Case $olRuleActionCcMessage, $olRuleActionForward, $olRuleActionForwardAsAttachment, $olRuleActionRedirect ; SendRuleAction object
			If $oRule.RuleType = $olRuleReceive And $iRuleActionType = $olRuleActionCcMessage Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionForward Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionForwardAsAttachment Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionRedirect Then Return SetError(9, 0, 0)
			If $iRuleActionType = $olRuleActionCcMessage Then $oAction = $oRule.Actions.CC
			If $iRuleActionType = $olRuleActionForward Then $oAction = $oRule.Actions.Forward
			If $iRuleActionType = $olRuleActionForwardAsAttachment Then $oAction = $oRule.Actions.ForwardAsAttachment
			If $iRuleActionType = $olRuleActionRedirect Then $oAction = $oRule.Actions.Redirect
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			Local $aRecipients = StringSplit($sP1, ";")
			Local $oRecipient
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
			For $iIndex = 1 To $aRecipients[0] ; collection that represents the recipient list for the send action
				$oRecipient = $oAction.Recipients.Add($aRecipients[$iIndex])
				If @error Then Return SetError(7, @error, 0)
				If $oRecipient.Resolve = False Then Return SetError(8, $iIndex, 0)
			Next
		Case $olRuleActionMarkAsTask ; MarkAsTaskRuleAction object
			If $oRule.RuleType = $olRuleSend Then Return SetError(9, 0, 0)
			$oAction = $oRule.Actions.MarkAsTask
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			$oAction.FlagTo = $sP1 ; String that represents the label of the flag for the message
			$oAction.MarkInterval = $sP2 ; constant in the OlMarkInterval enumeration representing the interval before the task is due
		Case $olRuleActionNewItemAlert ; NewItemAlertRuleAction object
			If $oRule.RuleType = $olRuleSend Then Return SetError(9, 0, 0)
			$oAction = $oRule.Actions.NewItemAlert
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			$oAction.Text = $sP1 ; String that represents the text displayed in the new item alert dialog box
		Case $olRuleActionPlaySound ; PlaySoundRuleAction object
			If $oRule.RuleType = $olRuleSend Then Return SetError(9, 0, 0)
			If FileExists($sP1) = 0 Then Return SetError(10, 0, 0)
			$oAction = $oRule.Actions.PlaySound
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
			$oAction.FilePath = $sP1 ; Full file path to a sound file (.wav)
		Case $olRuleActionClearCategories, $olRuleActionDelete, $olRuleActionDeletePermanently, _ ; Actions without additional properties
				$olRuleActionDesktopAlert, $olRuleActionNotifyDelivery, $olRuleActionNotifyRead, $olRuleActionStop
			If $oRule.RuleType = $olRuleReceive And $iRuleActionType = $olRuleActionNotifyDelivery Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleReceive And $iRuleActionType = $olRuleActionNotifyRead Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionDelete Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionDeletePermanently Then Return SetError(9, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleActionType = $olRuleActionDesktopAlert Then Return SetError(9, 0, 0)
			If $iRuleActionType = $olRuleActionNotifyDelivery Then $oAction = $oRule.Actions.NotifyDelivery
			If $iRuleActionType = $olRuleActionNotifyRead Then $oAction = $oRule.Actions.NotifyRead
			If $iRuleActionType = $olRuleActionDelete Then $oAction = $oRule.Actions.Delete
			If $iRuleActionType = $olRuleActionDeletePermanently Then $oAction = $oRule.Actions.DeletePermanently
			If $iRuleActionType = $olRuleActionDesktopAlert Then $oAction = $oRule.Actions.DesktopAlert
			If @error Then Return SetError(4, @error, 0)
			$oAction.Enabled = $bEnabled
		Case $olRuleActionServerReply, $olRuleActionTemplate, $olRuleActionFlagForActionInDays, _ ; Types not yet handled by Outlook object model
				$olRuleActionFlagColor, $olRuleActionFlagClear, $olRuleActionImportance, $olRuleActionSensitivity, _
				$olRuleActionPrint, $olRuleActionMarkRead, $olRuleActionDefer, $olRuleActionStartApplication
			Return SetError(12, $iRuleActionType, 0)
		Case Else
			Return SetError(11, $iRuleActionType, 0)
	EndSwitch
	; Update the server
	$oRules.Save
	If @error Then Return SetError(5, @error, 0)
	Return $oAction

EndFunc   ;==>_OL_RuleActionSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleAdd
; Description ...: Adds a new rule to the specified store.
; Syntax.........: _OL_RuleAdd($oOL, $sStore, $sRuleName[, $bEnabled = True[, $iRuleType = $olRuleReceive[, $iExecutionOrder = 0]]])
; Parameters ....: $oOL             - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore          - Name of the Store where the rule will be defined. "*" = your default store
;                  $sRuleName       - Name of the rule
;                  $bEnabled        - Optional: True sets the rule to enabled (default = True)
;                  $iRuleType       - Optional: Can be $olRuleSend or $olRuleReceive (default = $olRuleReceive)
;                  $iExecutionOrder - Optional: Integer indicating the order of execution of the rule among other rules (default = 1)
; Return values .: Success - Object of the created rule
;                  Failure - Returns 0 and sets @error:
;                  |1 - Rule already exists for the specified store
;                  |2 - Error returned by method .GetRules. For more information check @extended
;                  |3 - Error creating the rule. For more information check @extended
;                  |4 - Error saving the rule collection. For more information check @extended
; Author ........: water
; Modified ......:
; Remarks .......: A newly added rule is always a client rule till you add actions which can be executed on the server
; Related .......:
; Link ..........:                                                                
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleAdd($oOL, $sStore, $sRuleName, $bEnabled = True, $iRuleType = $olRuleReceive, $iExecutionOrder = 1)

	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oRules = $oOL.Session.Stores.Item($sStore).GetRules
	If @error Then Return SetError(2, @error, 0)
	For $oRule In $oRules
		If $oRule.Name = $sRuleName Then Return SetError(1, 0, 0)
	Next
	$oRule = $oRules.Create($sRuleName, $iRuleType)
	If @error Then Return SetError(3, @error, 0)
	$oRule.Enabled = $bEnabled
	$oRule.ExecutionOrder = $iExecutionOrder
	$oRules.Save
	If @error Then Return SetError(4, @error, 0)
	Return $oRule

EndFunc   ;==>_OL_RuleAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleConditionGet
; Description ...: Returns all conditions or condition exceptions for a specified rule.
; Syntax.........: _OL_RuleConditionGet($oRule[, $bEnabled = True[, $bExceptions = False]])
; Parameters ....: $oRule       - Rule object returned by a preceding call to _OL_RuleGet in element 0
;                  $bEnabled    - Optional: Only returns enabled conditions if set to True (default = True)
;                  $bExceptions - Optional: Only returns defined exceptions to the conditions if set to True (default = False)
; Return values .: Success - two-dimensional one based array with the following information:
;                  Elements 0 - 2 are the same for every condition type. The other elements (if any) depend on the condition type.
;                  |0 - OlRuleConditionType constant indicating the type of condition that is taken by the rule condition
;                  |1 - OlObjectClass constant indicating the class of the rule condition
;                  |2 - True if the condition is enabled
;                  |AccountRuleCondition
;                  |3 - Account object that represents the account used to evaluate the rule condition
;                  |AddressRuleCondition
;                  |3 - array of strings to evaluate the address rule condition
;                  |CategoryRuleCondition
;                  |3 - array of strings representing the categories evaluated by the rule condition
;                  |FormNameRuleCondition
;                  |3 - array of form identifiers
;                  |FromRssFeedRuleCondition
;                  |3 - array of String elements that represent the RSS subscriptions
;                  |ImportanceRuleCondition
;                  |3 - OlImportance constant indicating the relative level of importance for the message
;                  |SenderInAddressListRuleCondition
;                  |3 - AddressList object that represents the address list
;                  |4 - Name of the addresslist object
;                  |TextRuleCondition
;                  |3 - array of String elements that represents the text to be evaluated
;                  |ToOrFromRuleCondition
;                  |3 - collection that represents the recipient list for the evaluation of the rule condition
;                  |4 - Recipients (string) separated by the pipe character
;                  Failure - Returns "" and sets @error:
;                  |1 - The ConditionType can not be handled by this function. @extended contains the ConditionType in error
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleConditionGet($oRule, $bEnabled = True, $bExceptions = False)

	Local $iIndex = 1
	Local $oConditionOrException = $oRule.Conditions
	If $bExceptions = True Then $oConditionOrException = $oRule.Exceptions
	Local $aConditions[$oConditionOrException.Count + 1][5] = [[$oConditionOrException.Count, 5]]
	For $oObject In $oConditionOrException
		If $bEnabled = False Or $oObject.Enabled = True Then
			; Properties that apply to all condition types
			$aConditions[$iIndex][0] = $oObject.ConditionType
			$aConditions[$iIndex][1] = $oObject.Class
			$aConditions[$iIndex][2] = $oObject.Enabled
			; Properties that apply to individual condition types
			Switch $oObject.ConditionType
				Case $olConditionAccount ; AccountRuleCondition object
					$aConditions[$iIndex][3] = $oObject.Account ; Account object that represents the account used to evaluate the rule condition
				Case $olConditionRecipientAddress, $olConditionSenderAddress ; AddressRuleCondition object
					Local $aAddress = $oObject.Address ; array of strings to evaluate the address rule condition
					$aConditions[$iIndex][3] = _ArrayToString($aAddress)
				Case $olConditionCategory ; CategoryRuleCondition object
					Local $aCategories = $oObject.Categories ; array of strings representing the categories evaluated by the rule condition
					$aConditions[$iIndex][3] = _ArrayToString($aCategories)
				Case $olConditionFormName ; FormNameRuleCondition object
					Local $aForms = $oObject.FormName ; array of form identifiers
					$aConditions[$iIndex][3] = _ArrayToString($aForms)
				Case $olConditionFromRssFeed ; FromRssFeedRuleCondition object
					Local $aFeeds = $oObject.FromRssFeed ; array of String elements that represent the RSS subscriptions
					$aConditions[$iIndex][3] = _ArrayToString($aFeeds)
				Case $olConditionImportance ; ImportanceRuleCondition object
					$aConditions[$iIndex][3] = $oObject.Importance ; OlImportance constant indicating the relative level of importance for the message
				Case $olConditionSenderInAddressBook ; SenderInAddressListRuleCondition object
					$aConditions[$iIndex][3] = $oObject.AddressList ; AddressList object that represents the address list
					If IsObj($oObject.AddressList) Then $aConditions[$iIndex][4] = $oObject.AddressList.Name
				Case $olConditionBody, $olConditionBodyOrSubject, $olConditionMessageHeader, $olConditionSubject ; TextRuleCondition object
					Local $aText = $oObject.Text ; array of String elements that represents the text to be evaluated
					$aConditions[$iIndex][3] = _ArrayToString($aText)
					; Conditions that the Rules object model supports for rules created by the Wizard but not for those created by the object model
				Case $olConditionSentTo, $olConditionFrom ; ToOrFromRuleCondition object
					$aConditions[$iIndex][3] = $oObject.Recipients
					Local $sRecipients
					For $oRecipient In $oObject.Recipients
						$sRecipients = $sRecipients & $oRecipient.Name & "|"
					Next
					$aConditions[$iIndex][4] = StringLeft($sRecipients, StringLen($sRecipients) - 1)
				Case $olConditionAnyCategory, $olConditionCc, $olConditionFromAnyRssFeed, $olConditionHasAttachment, _ ; Conditions without additional properties
						$olConditionLocalMachineOnly, $olConditionMeetingInviteOrUpdate, $olConditionNotTo, $olConditionOnlyToMe, _
						$olConditionOtherMachine, $olConditionTo, $olConditionToOrCc
				Case $olConditionSensitivity, $olConditionFlaggedForAction, $olConditionOOF, $olConditionSizeRange, _ ; Types not yet handled by Outlook object model
						$olConditionDateRange, $olConditionProperty
				Case Else
					Return SetError(1, $oObject.ConditionType, "")
			EndSwitch
			$iIndex += 1
		EndIf
	Next
	ReDim $aConditions[$iIndex][UBound($aConditions, 2)]
	$aConditions[0][0] = $iIndex - 1
	Return $aConditions

EndFunc   ;==>_OL_RuleConditionGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleConditionSet
; Description ...: Adds a new or overwrites an existing condition or condition exception to an existing rule of the specified store.
; Syntax.........: _OL_RuleConditionSet($oOL, $sStore, $sRuleName, $iRuleConditionType, $bEnabled[, $sP1 = ""])
; Parameters ....: $oOL                - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore             - Name of the Store where the rule will be defined. "*" = your default store
;                  $sRuleName          - Name of the rule
;                  $iRuleConditionType - Type of the rule condition. Please see the OlRuleCOnditionType enumeration
;                  $bEnabled           - Optional: True sets the rule condition to enabled (default = True)
;                  $bExceptions        - Optional: Sets exceptions to the rule conditions if set to True (default = False)
;                  $sP1                - Optional: Data to create the rule condition depending on $iRuleConditionType
; Return values .: Success - Object of the added condition
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error accessing specified store. For details please check @extended
;                  |2 - Error accessing the rule collection. For details please check @extended
;                  |3 - Error accessing the specified rule. For details please check @extended
;                  |4 - Error creating the condition for the specified rule. For details please check @extended
;                  |5 - Error saving the specified rule. For details please check @extended
;                  |6 - The specified rule condition is not valid for the rule type (send/receive)
;                  |7 - Error adding a recipient. For details please check @extended
;                  |8 - Error resolving recipients. @extended is the 1-based number of the recipient in error
;                  |9 - The specified $iRuleConditionType is invalid
;                  |10 - The specified $iRuleConditionType is not supported by the Outlook object model at the moment
; Author ........: water
; Modified ......:
; Remarks .......: Not all possible rule conditions can be created using the COM model.
;                  To remove an action from a rule set $bEnabled to False.
;                  Remarks for different types of conditions:
;+
;                  $olConditionAccount:
;                  $sP1: Account object that represents the account used to evaluate the rule condition
;+
;                  $olConditionBody, $olConditionBodyOrSubject, $olConditionMessageHeader, $olConditionSubject:
;                  $sP1: Specify a string of elements that represent the text to be evaluated separated by the pipe character e.g. "Vacation|return"
;+
;                  $olConditionCategory:
;                  $sP1: Specify a string of elements that represent the categories separated by the pipe character e.g. "Birthday|Private"
;+
;                  $olConditionFormName:
;                  $sP1: Specify a string of form identifiers to be evaluated by the rule condition separated by the pipe character
;+
;                  $olConditionFrom, $olConditionSentTo:
;                  $sP1: Specify a string of elements that represents the recipient list separated by ";" e.g. "George Smith;John Doe"
;+
;                  $olFromRSSFeed:
;                  $sP1: Specify a string of elements that represent the RSS subscriptions separated by the pipe character
;+
;                  $olConditionImportance:
;                  $sP1: OlImportance constant indicating the relative level of importance
;+
;                  $olConditionRecipientAddress, $olConditionSenderAddress:
;                  $sP1: Specify a string of elements to evaluate the address rule condition separated by ";"
;+
;                  $olConditionSenderInAddressList:
;                  $sP1: AddressList object that represents the address list used to evaluate the rule condition
;+
;                  $olConditionAnyCategory, $olConditionCC, $olConditionFromAnyRSSFeed, $olConditionHasAttachment, $olConditionMeetingInviteOrUpdate,
;                  $olConditionNotTo, $olConditionLocalMachineOnly, $olConditionOnlyToMe, $olConditionTo, $olConditionToOrCC:
;                  No parameters need to be set
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/bb206766(v=office.12).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleConditionSet($oOL, $sStore, $sRuleName, $iRuleConditionType, $bEnabled = True, $bExceptions = False, $sP1 = "")

	Local $oObject
	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oStore = $oOL.Session.Stores.Item($sStore)
	If @error Then Return SetError(1, @error, 0)
	Local $oRules = $oStore.GetRules()
	If @error Then Return SetError(2, @error, 0)
	Local $oRule = $oRules.Item($sRuleName)
	If @error Then Return SetError(3, @error, 0)
	Local $oConditionOrException = $oRule.Conditions
	If $bExceptions = True Then $oConditionOrException = $oRule.Exceptions
	; Properties that apply to individual condition types
	Switch $iRuleConditionType
		Case $olConditionAccount ; AccountRuleCondition object
			$oObject = $oConditionOrException.Account
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.Account = $sP1 ; Account object that represents the account used to evaluate the rule condition
		Case $olConditionBody, $olConditionBodyOrSubject, $olConditionMessageHeader, $olConditionSubject ; TextRuleCondition object
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionMessageHeader Then Return SetError(6, 0, 0)
			If $iRuleConditionType = $olConditionBody Then $oObject = $oConditionOrException.Body
			If $iRuleConditionType = $olConditionBodyOrSubject Then $oObject = $oConditionOrException.BodyOrSubject
			If $iRuleConditionType = $olConditionMessageHeader Then $oObject = $oConditionOrException.MessageHeader
			If $iRuleConditionType = $olConditionSubject Then $oObject = $oConditionOrException.Subject
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.Text = StringSplit($sP1, "|", 2) ; array of string elements that represents the text to be evaluated
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olConditionCategory ; CategoryRuleCondition object
			$oObject = $oConditionOrException.Category
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.Categories = StringSplit($sP1, "|", 2) ; array of strings representing the categories assigned to the message
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olConditionFormName ; FormNameRuleCondition object
			$oObject = $oConditionOrException.FormName
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.FormName = StringSplit($sP1, "|", 2) ; represents an array of form identifiers to be evaluated by the rule condition
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olConditionFrom, $olConditionSentTo ; ToOrFromRuleCondition object
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionFrom Then Return SetError(6, 0, 0)
			If $iRuleConditionType = $olConditionFrom Then $oObject = $oConditionOrException.From
			If $iRuleConditionType = $olConditionFrom Then $oObject = $oConditionOrException.SentTo
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			Local $aRecipients = StringSplit($sP1, ";")
			Local $oRecipient
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
			For $iIndex = 1 To $aRecipients[0] ; collection that represents the recipient list
				$oRecipient = $oObject.Recipients.Add($aRecipients[$iIndex])
				If @error Then Return SetError(7, @error, 0)
				If $oRecipient.Resolve = False Then Return SetError(8, $iIndex, 0)
			Next
		Case $olConditionFromRssFeed ; FromRSSFeedRuleCondition object
			If $oRule.RuleType = $olRuleSend Then Return SetError(6, 0, 0)
			$oObject = $oConditionOrException.FromRSSFeed
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.FromRSSFeed = StringSplit($sP1, "|", 2) ; array of string elements that represent the RSS subscriptions
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olConditionImportance ; ImportanceRuleCondition object
			$oObject = $oConditionOrException.Importance
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.Importance = $sP1 ; OlImportance constant indicating the relative level of importance
		Case $olConditionRecipientAddress, $olConditionSenderAddress ; AddressRuleCondition object
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionSenderAddress Then Return SetError(6, 0, 0)
			If $iRuleConditionType = $olConditionRecipientAddress Then $oObject = $oConditionOrException.RecipientAddress
			If $iRuleConditionType = $olConditionSenderAddress Then $oObject = $oConditionOrException.SenderAddress
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.Address = StringSplit($sP1, ";", 2) ; array of string elements to evaluate the address rule condition
			SetError(0) ; Reset an error raised by StringSplit when nothing to split
		Case $olConditionSenderInAddressBook ; SenderInAddressListRuleCondition object
			If $oRule.RuleType = $olRuleSend Then Return SetError(6, 0, 0)
			$oObject = $oConditionOrException.SenderInAddressList
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
			$oObject.AddressList = $sP1 ; AddressList object that represents the address list used to evaluate the rule condition
		Case $olConditionAnyCategory, $olConditionCc, $olConditionFromAnyRssFeed, $olConditionHasAttachment, _ ; Conditions without additional properties
				$olConditionMeetingInviteOrUpdate, $olConditionNotTo, $olConditionLocalMachineOnly, $olConditionOnlyToMe, $olConditionTo, _
				$olConditionToOrCc
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionFromAnyRssFeed Then Return SetError(6, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionNotTo Then Return SetError(6, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionOnlyToMe Then Return SetError(6, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionTo Then Return SetError(6, 0, 0)
			If $oRule.RuleType = $olRuleSend And $iRuleConditionType = $olConditionToOrCc Then Return SetError(6, 0, 0)
			If $iRuleConditionType = $olConditionAnyCategory Then $oObject = $oConditionOrException.AnyCategory
			If $iRuleConditionType = $olConditionCc Then $oObject = $oConditionOrException.CC
			If $iRuleConditionType = $olConditionFromAnyRssFeed Then $oObject = $oConditionOrException.FromAnyRSSFeed
			If $iRuleConditionType = $olConditionHasAttachment Then $oObject = $oConditionOrException.HasAttachment
			If $iRuleConditionType = $olConditionMeetingInviteOrUpdate Then $oObject = $oConditionOrException.MeetingInviteOrUpdate
			If $iRuleConditionType = $olConditionNotTo Then $oObject = $oConditionOrException.NotTo
			If $iRuleConditionType = $olConditionLocalMachineOnly Then $oObject = $oConditionOrException.OnLocalMachine
			If $iRuleConditionType = $olConditionOnlyToMe Then $oObject = $oConditionOrException.OnlyToMe
			If $iRuleConditionType = $olConditionTo Then $oObject = $oConditionOrException.ToMe
			If $iRuleConditionType = $olConditionToOrCc Then $oObject = $oConditionOrException.ToOrCC
			If @error Then Return SetError(4, @error, 0)
			$oObject.Enabled = $bEnabled
		Case $olConditionDateRange, $olConditionFlaggedForAction, $olConditionOOF, $olConditionOtherMachine, _ ; Types not yet handled by Outlook object model
				$olConditionProperty, $olConditionSensitivity, $olConditionSizeRange, $olConditionUnknown
			Return SetError(10, $iRuleConditionType, 0)
		Case Else
			Return SetError(9, $iRuleConditionType, 0)
	EndSwitch
	; Update the server
	$oRules.Save
	If @error Then Return SetError(5, @error, 0)
	Return $oObject

EndFunc   ;==>_OL_RuleConditionSet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleDelete
; Description ...: Deletes a rule from the specified store.
; Syntax.........: _OL_RuleDelete($oOL, $sStore, $sRuleName)
; Parameters ....: $oOL       - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore    - Name of the Store where the rule will be deleted from. "*" = your default store
;                  $sRuleName - Name of the rule to be deleted
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Rule doesn't exist in the specified store
;                  |2 - Error returned by method .GetRules. For more information check @extended
;                  |3 - Error deleting the rule. For more information check @extended
;                  |4 - Error saving the changed rules. For details please check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleDelete($oOL, $sStore, $sRuleName)

	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oRules = $oOL.Session.Stores.Item($sStore).GetRules
	If @error Then Return SetError(2, @error, 0)
	Local $bFound = False
	For $oRule In $oRules
		If $oRule.Name = $sRuleName Then $bFound = True
	Next
	If $bFound = False Then Return SetError(1, 0, 0)
	$oRules.Remove($sRuleName)
	If @error Then Return SetError(3, @error, 0)
	; Update the server
	$oRules.Save
	If @error Then Return SetError(4, @error, 0)
	Return 1

EndFunc   ;==>_OL_RuleDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleExecute
; Description ...: Applies a rule as an one-off operation.
; Syntax.........: _OL_RuleExecute($oOL, $sStore, $sRuleName, $oFolder[, $bIncludeSubfolders = False[, $iExecuteOption = $olRuleExecuteAllMessages[, $bShowProgress = False]]])
; Parameters ....: $oOL                - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore             - Name of the Store where the rule will be deleted from. "*" = your default store
;                  $sRuleName          - Name of the rule to be deleted
;                  $oFolder            - Object of the folder to which to apply the rule
;                  $bIncludeSubfolders - Optional: Subfolders will be included if set to True (default = False)
;                  $iExecuteOption     - Optional: Specifies the type of messages in the specified folder or folders that a rule should be applied to (default = $olRuleExecuteAllMessages)
;                  $bShowProgress      - Optional: When set to True displays the progress dialog box when the rule is executed (default = False)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Rule doesn't exist in the specified store
;                  |2 - Error returned by method .GetRules. For more information check @extended
;                  |3 - Error executing the rule. For more information check @extended
;                  |4 - $oFolder is not of type object
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleExecute($oOL, $sStore, $sRuleName, $oFolder, $bIncludeSubfolders = False, $iExecuteOption = $olRuleExecuteAllMessages, $bShowProgress = False)

	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oRules = $oOL.Session.Stores.Item($sStore).GetRules
	If @error Then Return SetError(2, @error, 0)
	If Not IsObj($oFolder) Then Return SetError(4, 0, 0)
	Local $bFound = False
	For $oRule In $oRules
		If $oRule.Name = $sRuleName Then
			$bFound = True
			ExitLoop
		EndIf
	Next
	If $bFound = False Then Return SetError(1, 0, 0)
	$oRule.Execute($bShowProgress, $oFolder, $bIncludeSubfolders, $iExecuteOption)
	If @error Then Return SetError(3, @error, 0)
	Return 1

EndFunc   ;==>_OL_RuleExecute

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_RuleGet
; Description ...: Returns a list of rules for the specified store.
; Syntax.........: _OL_RuleGet($oOL[, sOL_Store = "*" [, $bEnabled = True]])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $sStore   - Optional: Store to query for rules. Use "*" to denote the default store or specify the name of another store (default = "*")
;                  $bEnabled - Optional: Only returns enabled rules if set to True (default = True)
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Rule object
;                  |1 - Boolean value that determines if the rule is to be applied
;                  |2 - Integer indicating the order of execution of the rule in the rules collection
;                  |3 - Boolean value that indicates if the rule executes as a client-side rule
;                  |4 - String representing the name of the rule
;                  |5 - Constant from the OlRuleType enumeration indicating if the rule applies to messages being sent or received
;                  Failure - Returns "" and sets @error:
;                  |1 - No rules found for the specified store
;                  |2 - Error returned by method .GetRules. For more information check @extended
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_RuleGet($oOL, $sStore = "*", $bEnabled = True)

	If $sStore = "*" Then $sStore = $oOL.Session.DefaultStore.DisplayName
	Local $oRules = $oOL.Session.Stores.Item($sStore).GetRules
	If @error Then Return SetError(2, @error, "")
	If $oRules.Count = 0 Then Return SetError(1, 0, "")
	Local $aRules[$oRules.Count + 1][6] = [[$oRules.Count, 6]]
	Local $iIndex = 1
	For $oRule In $oRules
		If $bEnabled = False Or $oRule.Enabled = True Then
			$aRules[$iIndex][0] = $oRule
			$aRules[$iIndex][1] = $oRule.Enabled
			$aRules[$iIndex][2] = $oRule.ExecutionOrder
			$aRules[$iIndex][3] = $oRule.IsLocalRule
			$aRules[$iIndex][4] = $oRule.Name
			$aRules[$iIndex][5] = $oRule.RuleType
			$iIndex += 1
		EndIf
	Next
	ReDim $aRules[$iIndex][UBound($aRules, 2)]
	$aRules[0][0] = $iIndex - 1
	Return $aRules

EndFunc   ;==>_OL_RuleGet

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_StoreGet
; Description ...: Returns information about the Stores in the current profile.
; Syntax.........: _OL_StoreGet($oOL)
; Parameters ....: $oOL - Outlook object returned by a preceding call to _OL_Open()
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - display name of the Store object
;                  |1 - Constant in the OlExchangeStoreType enumeration that indicates the type of an Exchange store
;                  |2 - Full file path for a Personal Folders File (.pst) or an Offline Folder File (.ost) store
;                  |3 - True if the store is a cached Exchange store
;                  |4 - True if the store is a store for an Outlook data file (Personal Folders File (.pst) or Offline Folder File (.ost))
;                  |5 - True if Instant Search is enabled and operational
;                  |6 - True if the Store is open
;                  |7 - String identifying the Store
;                  |8 - True if the OOF (Out Of Office) is set for this store
;                  Failure - Returns "" and sets @error:
;                  |1 - Function is only supported for Outlook 2007 and later
; Author ........: water
; Modified ......:
; Remarks .......: This function only works for Outlook 2007 and later.
;                  It always returns a valid filepath for PST files where function _OL_PSTGet might not (hebrew characters in filename etc.)
;                  +
;                  A store object represents a file on the local computer or a network drive that stores e-mail messages and other items.
;                  If you use an Exchange server, you can have a store on the server, in an Exchange Public folder, or on a local computer
;                  in a Personal Folders File (.pst) or Offline Folder File (.ost).
;                  For a POP3, IMAP, and HTTP e-mail server, a store is a .pst file.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_StoreGet($oOL)

	Local $aVersion = StringSplit($oOL.Version, '.')
	If Int($aVersion[1]) < 12 Then Return SetError(1, 0, "")
	Local $iIndex = 0
	Local $aStore[$oOL.Session.Stores.Count + 1][9] = [[$oOL.Session.Stores.Count, 9]]
	For $oStore In $oOL.Session.Stores
		$iIndex = $iIndex + 1
		$aStore[$iIndex][0] = $oStore.DisplayName
		$aStore[$iIndex][1] = $oStore.ExchangeStoreType
		$aStore[$iIndex][2] = $oStore.FilePath
		$aStore[$iIndex][3] = $oStore.IsCachedExchange
		$aStore[$iIndex][4] = $oStore.IsDataFileStore
		$aStore[$iIndex][5] = $oStore.IsInstantSearchEnabled
		$aStore[$iIndex][6] = $oStore.IsOpen
		$aStore[$iIndex][7] = $oStore.StoreId
		If $oStore.ExchangeStoreType = $olExchangeMailbox Or $oStore.ExchangeStoreType = $olPrimaryExchangeMailbox Then
			$aStore[$iIndex][8] = $oStore.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x661D000B")
		EndIf
	Next
	Return $aStore

EndFunc   ;==>_OL_StoreGet

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_VersionInfo
; Description ...: Returns an array of information about the OutlookEX.au3 UDF.
; Syntax.........: _OL_VersionInfo()
; Parameters ....: None
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - Release Type (T=Test or V=Production)
;                  |2 - Major Version
;                  |3 - Minor Version
;                  |4 - Sub Version
;                  |5 - Release Date (YYYYMMDD)
;                  |6 - AutoIt version required
;                  |7 - List of authors separated by ","
;                  |8 - List of contributors separated by ","
; Author ........: water
; Modified.......:
; Remarks .......: Based on function _IE_VersionInfo written bei Dale Hohm
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_VersionInfo()

	Local $aVersionInfo[9] = [8, "V", 0, 9, 0, "20121007", "3.3.9.2", "wooltown, water", _
			"progandy (CSV functions), Ultima, PsaltyDS (basis of the __OL_ArrayConcatenate function)"]
	Return $aVersionInfo

EndFunc   ;==>_OL_VersionInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_Wrapper_CreateAppointment
; Description ...: Creates an appointment (wrapper function).
; Syntax.........: _OL_Wrapper_CreateAppointment($oOL, $sSubject, $sStartDate[, $vEndDate = ""[, $sLocation = ""[, $bAllDayEvent = False[, $sBody = ""[, $sReminder = 15[, $sShowTimeAs = ""[, $iImportance = ""[, $iSensitivity = ""[, $iRecurrenceType = ""[, $sPatternStartDate = ""[, $sPatternEndDate = ""[, $iInterval = ""[, $iDayOfWeekMask = ""[, $iDay_MonthOfMonth_Year = ""[, $iInstance = ""]]]]]]]]]]]]]]])
; Parameters ....: $oOL                    - Outlook object returned by a preceding call to _OL_Open()
;                  $sSubject               - The Subject of the Appointment.
;                  $sStartDate             - Start date & time of the Appointment, format YYYY-MM-DD HH:MM - or what is set locally.
;                  $vEndDate               - Optional: End date & time of the Appointment, format YYYY-MM-DD HH:MM - or what is set locally OR
;                                            Number of minutes. If not set 30 minutes is used.
;                  $sLocation              - Optional: The location where the meeting is going to take place.
;                  $bAllDayEvent           - Optional: True or False(default), if set to True and the appointment is lasting for more than one day, end Date
;                                            must be one day higher than the actual end Date.
;                  $sBody                  - Optional: The Body of the Appointment.
;                  $sReminder              - Optional: Reminder in Minutes before start, 0 for no reminder
;                  $sShowTimeAs            - Optional: $olBusy=2 (default), $olFree=0, $olOutOfOffice=3, $olTentative=1
;                  $iImportance            - Optional: $olImportanceNormal=1 (default), $olImportanceHigh=2, $olImportanceLow=0
;                  $iSensitivity           - Optional: $olNormal=0, $olPersonal=1, $olPrivate=2, $olConfidential=3
;                  $iRecurrenceType        - Optional: $olRecursDaily=0, $olRecursWeekly=1, $olRecursMonthly=2, $olRecursMonthNth=3, $olRecursYearly=5, $olRecursYearNth=6
;                  $sPatternStartDate      - Optional: Start Date of the Reccurent Appointment, format YYYY-MM-DD - or what is set locally.
;                  $sPatternEndDate        - Optional: End Date of the Reccurent Appointment, format YYYY-MM-DD - or what is set locally.
;                  $iInterval              - Optional: Interval between the Reccurent Appointment
;                  $iDayOfWeekMask         - Optional: Add the values of the days the appointment shall occur. $olSunday=1, $olMonday=2, $olTuesday=4, $olWednesday=8, $olThursday=16, $olFriday=32, $olSaturday=64
;                  $iDay_MonthOfMonth_Year - Optional: DayOfMonth or MonthOfYear, Day of the month or month of the year on which the recurring appointment or task occurs
;                  $iInstance              - Optional: This property is only valid for recurrences of the $olRecursMonthNth and $olRecursYearNth type and allows the definition of a recurrence pattern that is only valid for the Nth occurrence, such as "the 2nd Sunday in March" pattern. The count is set numerically: 1 for the first, 2 for the second, and so on through 5 for the last. Values greater than 5 will generate errors when the pattern is saved.
; Return values .: Success - Object of the appointment
;                  Failure - Returns 0 and sets @error:
;                  |1    - $sStartDate is invalid
;                  |2    - $sBody is missing
;                  |4    - $sTo, $sCc and $sBCc are missing
;                  |1xxx - Error returned by function _OL_FolderAccess
;                  |2xxx - Error returned by function _OL_ItemCreate
;                  |3xxx - Error returned by function _OL_ItemModify
;                  |4xxx - Error returned by function _OL_ItemRecurrenceSet
; Author ........: water
; Modified.......:
; Remarks .......: This is a wrapper function to simplify creating an appointment. If you have to set more properties etc. you have to do all steps yourself
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_Wrapper_CreateAppointment($oOL, $sSubject, $sStartDate, $vEndDate = "", $sLocation = "", $bAllDayEvent = False, $sBody = "", $sReminder = 15, $sShowTimeAs = "", $iImportance = "", $iSensitivity = "", $iRecurrenceType = "", $sPatternStartDate = "", $sPatternEndDate = "", $iInterval = "", $iDayOfWeekMask = "", $iDay_MonthOfMonth_Year = "", $iInstance = "")

	If Not _DateIsValid($sStartDate) Then Return SetError(1, 0, 0)
	Local $sEnd, $oItem
	; Access the default calendar
	Local $aFolder = _OL_FolderAccess($oOL, "", $olFolderCalendar)
	If @error Then Return SetError(@error + 1000, @extended, 0)
	; Create an appointment item in the default calendar and set properties
	If _DateIsValid($vEndDate) Then
		$sEnd = "End=" & $vEndDate
	Else
		$sEnd = "Duration=" & Number($vEndDate)
	EndIf
	$oItem = _OL_ItemCreate($oOL, $olAppointmentItem, $aFolder[1], "", "Subject=" & $sSubject, "Location=" & $sLocation, "AllDayEvent=" & $bAllDayEvent, _
			"Start=" & $sStartDate, "Body=" & $sBody, "Importance=" & $iImportance, "BusyStatus=" & $sShowTimeAs, $sEnd, "Sensitivity=" & $iSensitivity)
	If @error Then Return SetError(@error + 2000, @extended, 0)
	; Set reminder properties
	If $sReminder <> 0 Then
		$oItem = _OL_ItemModify($oOL, $oItem, Default, "ReminderSet=True", "ReminderMinutesBeforeStart=" & $sReminder)
		If @error Then Return SetError(@error + 3000, @extended, 0)
	Else
		$oItem = _OL_ItemModify($oOL, $oItem, Default, "ReminderSet=False")
		If @error Then Return SetError(@error + 3000, @extended, 0)
	EndIf
	; Set recurrence
	$iDayOfWeekMask = ""
	If $iRecurrenceType <> "" Then
		Local $sSDate, $sSTime, $sEDate, $sETime
		$sSDate = StringLeft($sPatternStartDate, 10)
		$sSTime = StringStripWS(StringMid($sPatternStartDate, 11), 3)
		$sEDate = StringLeft($sPatternEndDate, 10)
		$sETime = StringStripWS(StringMid($sPatternEndDate, 11), 3)
		If $iDayOfWeekMask <> "" Then $iDay_MonthOfMonth_Year = $iDayOfWeekMask
		$oItem = _OL_ItemRecurrenceSet($oOL, $oItem, Default, $sSDate, $sSTime, $sEDate, $sETime, $iRecurrenceType, $iDay_MonthOfMonth_Year, $iInterval, $iInstance)
		If @error Then Return SetError(@error + 4000, @extended, 0)
	EndIf
	Return $oItem

EndFunc   ;==>_OL_Wrapper_CreateAppointment

; #FUNCTION# ====================================================================================================================
; Name...........: _OL_Wrapper_SendMail
; Description ...: Creatse and sends a mail (wrapper function).
; Syntax.........: _OL_Wrapper_SendMail($oOL[, $sTo = ""[, $sCc= ""[, $sBCc = ""[, $sSubject = ""[, $sBody = ""[, $sAttachments = ""[, $iBodyFormat = $olFormatUnspecified[, $iImportance = $olImportanceNormal]]]]]]]])
; Parameters ....: $oOL          - Outlook object returned by a preceding call to _OL_Open()
;                  $sTo          - Optional: The recipiant(s), separated by ;
;                  $sCc          - Optional: The CC recipiant(s) of the mail, separated by ;
;                  $sBCc         - Optional: The BCC recipiant(s) of the mail, separated by ;
;                  $sSubject     - Optional: The Subject of the mail
;                  $sBody        - Optional: The Body of the mail
;                  $sAttachments - Optional: Attachments, separated by ;
;                  $iBodyFormat  - Optional: The Bodyformat of the mail as defined by the OlBodyFormat enumeration (default = $olFormatUnspecified)
;                  $iImportance  - Optional: The Importance of the mail as defined by the OlImportance enumeration (default = $olImportanceNormal)
; Return values .: Success - Object of the sent mail
;                  Failure - Returns 0 and sets @error:
;                  |1    - $iBodyFormat is not a number
;                  |2    - $sBody is missing
;                  |4    - $sTo, $sCc and $sBCc are missing
;                  |1xxx - Error returned by function _OL_FolderAccess
;                  |2xxx - Error returned by function _OL_ItemCreate
;                  |3xxx - Error returned by function _OL_ItemModify
;                  |4xxx - Error returned by function _OL_ItemRecipientAdd
;                  |5xxx - Error returned by function _OL_ItemAttachmentAdd
;                  |6xxx - Error returned by function _OL_ItemSend
; Author ........: water
; Modified.......:
; Remarks .......: This is a wrapper function to simplify sending an email. If you have to set more properties etc. you have to do all steps yourself
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_Wrapper_SendMail($oOL, $sTo = "", $sCc = "", $sBCc = "", $sSubject = "", $sBody = "", $sAttachments = "", $iBodyFormat = $olFormatPlain, $iImportance = $olImportanceNormal)

	If Not IsInt($iBodyFormat) Then SetError(1, 0, 0)
	If StringStripWS($sBody, 3) = "" Then SetError(2, 0, 0)
	If StringStripWS($sTo, 3) = "" And StringStripWS($sCc, 3) = "" And StringStripWS($sBCc, 3) = "" Then SetError(3, 0, 0)
	; Access the default outbox folder
	Local $aFolder = _OL_FolderAccess($oOL, "", $olFolderOutbox)
	If @error Then Return SetError(@error + 1000, @extended, 0)
	; Create a mail item in the default folder
	Local $oItem = _OL_ItemCreate($oOL, $olMailItem, $aFolder[1], "", "Subject=" & $sSubject, "BodyFormat=" & $iBodyFormat, "Importance=" & $iImportance)
	If @error Then Return SetError(@error + 2000, @extended, 0)
	; Set the body according to $iBodyFormat
	If $iBodyFormat = $olFormatHTML Then
		_OL_ItemModify($oOL, $oItem, Default, "HTMLBody=" & $sBody)
	Else
		_OL_ItemModify($oOL, $oItem, Default, "Body=" & $sBody)
	EndIf
	If @error Then Return SetError(@error + 3000, @extended, 0)
	; Add recipients (to, cc and bcc)
	Local $aRecipients
	If $sTo <> "" Then
		$aRecipients = StringSplit($sTo, ";", 2)
		_OL_ItemRecipientAdd($oOL, $oItem, Default, $olTo, $aRecipients)
		If @error Then Return SetError(@error + 4000, @extended, 0)
	EndIf
	If $sCc <> "" Then
		$aRecipients = StringSplit($sCc, ";", 2)
		_OL_ItemRecipientAdd($oOL, $oItem, Default, $olCC, $aRecipients)
		If @error Then Return SetError(@error + 4000, @extended, 0)
	EndIf
	If $sBCc <> "" Then
		$aRecipients = StringSplit($sBCc, ";", 2)
		_OL_ItemRecipientAdd($oOL, $oItem, Default, $olBCC, $aRecipients)
		If @error Then Return SetError(@error + 4000, @extended, 0)
	EndIf
	; Add attachments
	If $sAttachments <> "" Then
		Local $aAttachments = StringSplit($sAttachments, ";", 2)
		_OL_ItemAttachmentAdd($oOL, $oItem, Default, $aAttachments)
		If @error Then Return SetError(@error + 5000, @extended, 0)
	EndIf
	; Send mail
	_OL_ItemSend($oOL, $oItem, Default)
	If @error Then Return SetError(@error + 6000, @extended, 0)
	Return $oItem

EndFunc   ;==>_OL_Wrapper_SendMail

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __OL_ArrayConcatenate
; Description ...: Concatenates 2D arrays.
; Syntax.........: __OL_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - The array to concatenate onto
;                  $avArraySource - The array to concatenate from - Must be 1D or 2D to match $avArrayTarget,
;                                   and if 2D, then Ubound($avArraySource, 2) <= Ubound($avArrayTarget, 2).
;                  $iFlags        - Flags as defined in function call for _OL_ItemFind
; Return values .: Success - Index of last added item
;                  Failure - -1, sets @error to 1 and @extended per failure (see code below)
; Author ........: Ultima
; Modified.......: PsaltyDS - 1D/2D version, changed return value and @error/@extended to be consistent with __ArrayAdd()
;                  water - removed 1D array support, support for row 1 containing the number of rows/columns
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================
Func __OL_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource, $iFlags)

	If Not IsArray($avArrayTarget) Then Return SetError(1, 1, -1); $avArrayTarget is not an array
	If Not IsArray($avArraySource) Then Return SetError(1, 2, -1); $avArraySource is not an array
	Local $iUBoundTarget0 = UBound($avArrayTarget, 0), $iUBoundSource0 = UBound($avArraySource, 0)
	If $iUBoundTarget0 <> $iUBoundSource0 Then Return SetError(1, 3, -1); 1D/2D dimensionality did not match
	If $iUBoundTarget0 > 2 Then Return SetError(1, 4, -1); At least one array was 3D or more
	Local $iUBoundTarget1 = UBound($avArrayTarget, 1), $iUBoundSource1 = UBound($avArraySource, 1)
	Local $iNewSize = $iUBoundTarget1 + $iUBoundSource1 - 1
	Local $iUBoundTarget2 = UBound($avArrayTarget, 2), $iUBoundSource2 = UBound($avArraySource, 2)
	If $iUBoundSource2 > $iUBoundTarget2 Then Return SetError(1, 5, -1); 2D boundry of source too large for target
	ReDim $avArrayTarget[$iNewSize][$iUBoundTarget2]
	For $r = 1 To $iUBoundSource1 - 1
		For $c = 0 To $iUBoundSource2 - 1
			$avArrayTarget[$iUBoundTarget1 + $r - 1][$c] = $avArraySource[$r][$c]
		Next
	Next
	If BitAND($iFlags, 2) <> 2 Then
		$avArrayTarget[0][0] = $iNewSize - 1
		If UBound($avArrayTarget, 0) > 1 Then $avArrayTarget[0][1] = UBound($avArrayTarget, 2)
	EndIf
	Return $iNewSize - 1

EndFunc   ;==>__OL_ArrayConcatenate

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __OL_CheckProperties
; Description ...: Checks if specified properties exist for the item and have the correct case.
; Syntax.........: __OL_CheckProperties($oItem, $aProperties)
; Parameters ....: $oItem       - Object of the item to check
;                  $aProperties - Zero based array of property names. Format "propertyname=propertyvalue" is valid as well
;                  $iFlag       - 0: Array $aProperties is zero based, 1: Array $aProperties is one based
; Return values .: Success - 1
;                  Failure - 0 and sets @error:
;                  |100 - Property is not valid for this type of item. @extended = number of property in error (zero based)
;                  |101 - Property has wrong case (e.g. "firstname" is wrong, "FirstName" is correct). @extended = number of property in error (zero based)
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================
Func __OL_CheckProperties($oItem, $aProperties, $iFlag = 0)

	Local $sItemProperties = ",", $aTemp, $iIndex, $iEnd
	For $oProperty In $oItem.ItemProperties
		$sItemProperties = $sItemProperties & $oProperty.name & ","
	Next
	If $iFlag = 1 Then
		$iIndex = 1
		$iEnd = $aProperties[0]
	Else
		$iIndex = 0
		$iEnd = UBound($aProperties) - 1
	EndIf
	For $iIndex = $iIndex To $iEnd
		$aTemp = StringSplit($aProperties[$iIndex], "=")
		If $aTemp[1] <> "" And StringInStr($sItemProperties, "," & $aTemp[1] & ",", 0) = 0 Then Return SetError(100, $iIndex, 0)
		If $aTemp[1] <> "" And StringInStr($sItemProperties, "," & $aTemp[1] & ",", 1) = 0 Then Return SetError(101, $iIndex, 0)
	Next
	Return 1

EndFunc   ;==>__OL_CheckProperties

; #INTERNAL_USE_ONLY#============================================================================================================
; Name ..........: __Outlook_ErrorHandler
; Description ...: Called if an ObjEvent error occurs.
; Syntax.........: __Outlook_ErrorHandler()
; Parameters ....: None
; Return values .: None
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Outlook_ErrorHandler()

	Local $bHexNumber = Hex($__oOL_Error.number, 8)
	Local $aVersionInfo = _OL_VersionInfo()
	Local $sError = "COM Error Encountered in " & @ScriptName & @CRLF & _
			"OutlookEx UDF version = " & $aVersionInfo[2] & "." & $aVersionInfo[3] & "." & $aVersionInfo[4] & @CRLF & _
			"@AutoItVersion = " & @AutoItVersion & @CRLF & _
			"@AutoItX64 = " & @AutoItX64 & @CRLF & _
			"@Compiled = " & @Compiled & @CRLF & _
			"@OSArch = " & @OSArch & @CRLF & _
			"@OSVersion = " & @OSVersion & @CRLF & _
			"Scriptline = " & $__oOL_Error.scriptline & @CRLF & _
			"NumberHex = " & $bHexNumber & @CRLF & _
			"Number = " & $__oOL_Error.number & @CRLF & _
			"WinDescription = " & StringStripWS($__oOL_Error.WinDescription, 2) & @CRLF & _
			"Description = " & StringStripWS($__oOL_Error.description, 2) & @CRLF & _
			"Source = " & $__oOL_Error.Source & @CRLF & _
			"HelpFile = " & $__oOL_Error.HelpFile & @CRLF & _
			"HelpContext = " & $__oOL_Error.HelpContext & @CRLF & _
			"LastDllError = " & $__oOL_Error.LastDllError
	If $__iOL_Debug > 0 Then
		If $__iOL_Debug = 1 Then ConsoleWrite($sError & @CRLF & "========================================================" & @CRLF)
		If $__iOL_Debug = 2 Then MsgBox(64, "Outlook UDF - Debug Info", $sError)
		If $__iOL_Debug = 3 Then FileWrite($__sOL_DebugFile, @YEAR & "." & @MON & "." & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @CRLF & _
				"-------------------" & @CRLF & $sError & @CRLF & "========================================================" & @CRLF)
	EndIf

EndFunc   ;==>__Outlook_ErrorHandler

; #INTERNAL_USE_ONLY#============================================================================================================
; Name ..........: _OL_TestEnvironmentCreate
; Description ...: Deletes and recreates the OutlookEX UDF test environment.
; Syntax.........: _OL_TestEnvironmentCreate($oOL[, $vDontAsk = ""[, $vDontDelete= ""]])
; Parameters ....: $oOL         - Outlook object returned by a preceding call to _OL_Open()
;                  $vDontAsk    - Optional: Return error if folder already exists? 1 = no, 4 = yes, "" = read value from ini file
;                  $vDontDelete - Optional: Delete test environment if it already exists? 1 = no, 4 = yes, "" = read value from ini file
; Return values .: Success - 1
;                  Failure - 0 and sets @error:
;                  |1 - Folder *\Outlook-UDF-Test already exists and user denied to delete/recreate the testenvironment
;                  |2 - Error deleting folder. @extended is @error as returned by _OL_FolderDelete
;                  |3xx - Error creating source folder. @extended is set to @error as returned by _OL_FolderCreate
;                  |4xx - Error creating target folder. @extended is set to @error as returned by _OL_FolderCreate
;                  |5xx - Error creating item in source folder. @extended is set to @error as returned by _OL_<itemtype>Create
;                  |6xx - Error creating item in target folder. @extended is set to @error as returned by _OL_<itemtype>Create
; Author ........: water
; Modified ......:
; Remarks .......: The test environment consists of the following items:
;                    * Folder Outlook-UDF-Test, subfolders plus items
;                    * Group "Outlook-UDF-Test" in the Outlook bar
;                    * Shortcut int the "Outlook-UDF-Test" group in the Outlook bar
;                    * Category "Outlook-UDF-Test" in the Outlook bar
;                    * Mail signature "Outlook-UDF-Test"
;                    * PST "Outlook-UDF-Test" in "C:\temp\Outlook-UDF-Test.pst"
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _OL_TestEnvironmentCreate($oOL, $vDontAsk = "", $vDontDelete = "")

	Local $vResult, $sCurrentUser = $oOL.GetNameSpace("MAPI").CurrentUser.Name
	;---------------------------------
	; Delete existing folder structure
	;---------------------------------
	If _OL_FolderExists($oOL, "*\Outlook-UDF-Test") Then
		If StringStripWS($vDontAsk, 3) = "" Then $vDontAsk = IniRead("_OL_TestEnvironment.ini", "Configuration", "DontAsk", "4") ; checked = 1, unchecked = 4
		If StringStripWS($vDontDelete, 3) = "" Then $vDontDelete = IniRead("_OL_TestEnvironment.ini", "Configuration", "DontDelete", "4") ; checked = 1, unchecked = 4
		If $vDontDelete = 4 Then
			If $vDontAsk = 4 Then
				Local $iResult = MsgBox(35, "OutlookEX UDF - Create Test Environment", "Testenvironment already exists. Should it be deleted and recreated?")
				If $iResult = 2 Then Return SetError(1, 0, 0)
				If $iResult = 7 Then Return 1
			EndIf
			If $vDontAsk = 1 Or $iResult = 6 Then _OL_FolderDelete($oOL, "*\Outlook-UDF-Test")
		Else
			Return 1
		EndIf
		If @error Then Return SetError(2, @error, 0)
	EndIf
	;------------------------------------------------------------
	; Create Source Folder plus one subfolder for every item type
	;------------------------------------------------------------
	Local $oSourceFolderCalendar = _OL_FolderCreate($oOL, "Outlook-UDF-Test\SourceFolder\Calendar", $olFolderCalendar)
	If @error Then Return SetError(300, @error, 0)
	Local $oSourceFolderContact = _OL_FolderCreate($oOL, "Contacts", $olFolderContacts, "*\Outlook-UDF-Test\SourceFolder")
	If @error Then Return SetError(301, @error, 0)
	; Mark the folder as address book and change the name
	$oSourceFolderContact.ShowAsOutlookAB = True
	$oSourceFolderContact.AddressBookName = "Outlook-UDF-Test"
	If @error Then Return SetError(302, @error, 0)
	Local $oSourceFolderMail = _OL_FolderCreate($oOL, "Mail", $olFolderInbox, "*\Outlook-UDF-Test\SourceFolder")
	If @error Then Return SetError(303, @error, 0)
	Local $oSourceFolderNotes = _OL_FolderCreate($oOL, "Notes", $olFolderNotes, "*\Outlook-UDF-Test\SourceFolder")
	If @error Then Return SetError(304, @error, 0)
	Local $oSourceFolderTasks = _OL_FolderCreate($oOL, "Tasks", $olFolderTasks, "*\Outlook-UDF-Test\SourceFolder")
	If @error Then Return SetError(305, @error, 0)
	;-----------------------------------
	; Create test items in Source Folder
	;-----------------------------------
	; Appointment
	Local $sStartTime = StringMid(_DateAdd("n", -10, _NowCalc()), 12, 5)
	Local $sEndTime = StringMid(_DateAdd("h", 3, _NowCalc()), 12, 5)
	Local $oItem = _OL_ItemCreate($oOL, $olAppointmentItem, $oSourceFolderCalendar, "", "Subject=TestAppointment", _
			"Start=" & _NowCalcDate() & " " & $sStartTime, "End=" & _NowCalcDate() & " " & $sEndTime, _
			"ReminderMinutesBeforeStart=15", "ReminderSet=True", "Location=Building A, Room 10")
	If @error Then Return SetError(500, @error, 0)
	; Appointment: Add optional recipient
	_OL_ItemRecipientAdd($oOL, $oItem, Default, $olOptional, $sCurrentUser)
	If @error Then Return SetError(501, @error, 0)
	; Appointment: Add recurrence: Daily with defined start and end date/time
	_OL_ItemRecurrenceSet($oOL, $oItem, Default, _NowCalcDate(), $sStartTime, _DateAdd("D", 14, _NowCalcDate()), $sEndTime, $olRecursDaily, "", "", "")
	If @error Then Return SetError(502, @error, 0)
	; Define exception
	Local $sTemp = _DateAdd("D", 1, _NowCalcDate())
	_OL_ItemRecurrenceExceptionSet($oOL, $oItem, Default, $sTemp & " " & $sStartTime & ":00", $sTemp & " 08:00:00", $sTemp & " 14:00:00", "TestException", "ExceptionBody")
	If @error Then Return SetError(503, @error, 0)
	; Appointment: Create a conflict
	$oItem = _OL_ItemCreate($oOL, $olAppointmentItem, $oSourceFolderCalendar, "", "Subject=TestAppointment-Conflict", _
			"Start=" & _NowCalcDate() & " " & $sStartTime, "End=" & _NowCalcDate() & " " & $sEndTime)
	If @error Then Return SetError(504, @error, 0)
	; Contact
	_OL_ItemCreate($oOL, $olContactItem, $oSourceFolderContact, "", "FirstName=TestFirstName", "LastName=TestLastName")
	If @error Then Return SetError(505, @error, 0)
	; Distribution List + Member
	$vResult = _OL_ItemCreate($oOL, $olDistributionListItem, $oSourceFolderContact, "", "Subject=TestDistributionList", "Importance=" & $olImportanceHigh)
	If @error Then Return SetError(506, @error, 0)
	_OL_DistListMemberAdd($oOL, $vResult, Default, $sCurrentUser)
	If @error Then Return SetError(507, @error, 0)
	; Mail plus attachment
	$vResult = _OL_ItemCreate($oOL, $olMailItem, $oSourceFolderMail, "", "Subject=TestMail", "BodyFormat=" & $olFormatHTML, "HTMLBody=Bodytext in <b>bold</b>.", "To=" & $sCurrentUser)
	If @error Then Return SetError(508, @error, 0)
	_OL_ItemAttachmentAdd($oOL, $vResult, Default, @ScriptDir & "\The_Outlook.jpg")
	If @error Then Return SetError(509, @error, 0)
	; Note
	_OL_ItemCreate($oOL, $olNoteItem, $oSourceFolderNotes, "", "Body=TestNote", "Width=350")
	If @error Then Return SetError(510, @error, 0)
	; Task
	_OL_ItemCreate($oOL, $olTaskItem, $oSourceFolderTasks, "", "Subject=TestSubject", "StartDate=" & _NowDate())
	If @error Then Return SetError(511, @error, 0)
	;------------------------------------------------------------
	; Create Target Folder plus one subfolder for every item type
	;------------------------------------------------------------
	_OL_FolderCreate($oOL, "TargetFolder\Calendar", $olFolderCalendar, "*\Outlook-UDF-Test")
	If @error Then Return SetError(400, @error, 0)
	_OL_FolderCreate($oOL, "Contacts", $olFolderContacts, "*\Outlook-UDF-Test\TargetFolder")
	If @error Then Return SetError(401, @error, 0)
	_OL_FolderCreate($oOL, "Mail", $olFolderInbox, "*\Outlook-UDF-Test\TargetFolder")
	If @error Then Return SetError(402, @error, 0)
	_OL_FolderCreate($oOL, "Notes", $olFolderNotes, "*\Outlook-UDF-Test\TargetFolder")
	If @error Then Return SetError(403, @error, 0)
	_OL_FolderCreate($oOL, "Tasks", $olFolderTasks, "*\Outlook-UDF-Test\TargetFolder")
	If @error Then Return SetError(404, @error, 0)
	Return 1

EndFunc   ;==>_OL_TestEnvironmentCreate

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ParseCSV
; Description ...: Reads a CSV-file
; Syntax.........: __ParseCSV($sFile, $sDelimiters=',', $sQuote='"', $iFormat=0)
; Parameters ....: $sFile       - File to read or string to parse
;                  $sDelimiters - [optional] Fieldseparators of CSV, multiple are allowed (default = ,;)
;                  $sQuote      - [optional] Character to quote strings (default = ")
;                  $iFormat     - [optional] Encoding of the file (default = 0):
;                  |-1     - No file, plain data given
;                  |0 or 1 - automatic (ASCII)
;                  |2      - Unicode UTF16 Little Endian reading
;                  |3      - Unicode UTF16 Big Endian reading
;                  |4 or 5 - Unicode UTF8 reading
; Return values .: Success - 2D-Array with CSV data (0-based)
;                  Failure - 0, sets @error to:
;                  |1 - could not open file
;                  |2 - error on parsing data
;                  |3 - wrong format chosen
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: __WriteCSV
; Link ..........: http://www.autoitscript.com/forum/topic/114406-csv-file-to-multidimensional-array
; Example .......:
; ===============================================================================================================================
Func __ParseCSV($sFile, $sDelimiters = ',;', $sQuote = '"', $iFormat = 0)

	Local Static $aEncoding[6] = [0, 0, 32, 64, 128, 256]
	If $iFormat < -1 Or $iFormat > 6 Then
		Return SetError(3, 0, 0)
	ElseIf $iFormat > -1 Then
		Local $hFile = FileOpen($sFile, $aEncoding[$iFormat])
		If @error Then Return SetError(1, @error, 0)
		$sFile = FileRead($hFile)
		FileClose($hFile)
	EndIf
	If $sDelimiters = "" Or IsKeyword($sDelimiters) Then $sDelimiters = ',;'
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	$sQuote = StringLeft($sQuote, 1)
	Local $srDelimiters = StringRegExpReplace($sDelimiters, '[\\\^\-\[\]]', '\\\0')
	Local $srQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
	Local $sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?', ',', $srDelimiters, 0, 1), '"', $srQuote, 0, 1)
	Local $aREgex = StringRegExp($sFile, $sPattern, 3)
	If @error Then Return SetError(2, @error, 0)
	$sFile = '' ; save memory
	Local $iBound = UBound($aREgex), $iIndex = 0, $iSubBound = 1, $iSub = 0
	Local $aResult[$iBound][$iSubBound]
	For $i = 0 To $iBound - 1
		Select
			Case StringLen($aREgex[$i]) < 3 And StringInStr(@CRLF, $aREgex[$i])
				$iIndex += 1
				$iSub = 0
				ContinueLoop
			Case StringLeft(StringStripWS($aREgex[$i], 1), 1) = $sQuote
				$aREgex[$i] = StringStripWS($aREgex[$i], 3)
				$aResult[$iIndex][$iSub] = StringReplace(StringMid($aREgex[$i], 2, StringLen($aREgex[$i]) - 2), $sQuote & $sQuote, $sQuote, 0, 1)
			Case Else
				$aResult[$iIndex][$iSub] = $aREgex[$i]
		EndSelect
		$aREgex[$i] = 0 ; save memory
		$iSub += 1
		If $iSub = $iSubBound Then
			$iSubBound += 1
			ReDim $aResult[$iBound][$iSubBound]
		EndIf
	Next
	If $iIndex = 0 Then $iIndex = 1
	ReDim $aResult[$iIndex][$iSubBound]
	Return $aResult

EndFunc   ;==>__ParseCSV

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __WriteCSV
; Description ...: Writes a CSV-file (appends to an existing file)
; Syntax.........: __WriteCSV($sFile, Const ByRef $aData, $sDelimiter, $sQuote, $iFormat=0)
; Parameters ....: $sFile      - Destination file
;                  $aData      - [Const ByRef] 1-based 2D-Array with data
;                  $sDelimiter - [optional] Fieldseparator (default = ,)
;                  $sQuote     - [optional] Quote character (default = ")
;                  $iFormat    - [optional] character encoding of file (default = 0)
;                  |0 or 1 - ASCII writing
;                  |2      - Unicode UTF16 Little Endian writing (with BOM)
;                  |3      - Unicode UTF16 Big Endian writing (with BOM)
;                  |4      - Unicode UTF8 writing (with BOM)
;                  |5      - Unicode UTF8 writing (without BOM)
; Return values .: Success - Number of records written
;                  Failure - 0, sets @error to:
;                  |1 - No valid 2D-Array
;                  |2 - Could not open file
; Author ........: ProgAndy
; Modified.......: water
; Remarks .......:
; Related .......: __ParseCSV
; Link ..........: http://www.autoitscript.com/forum/topic/114406-csv-file-to-multidimensional-array
; Example .......:
; ===============================================================================================================================
Func __WriteCSV($sFile, Const ByRef $aData, $sDelimiter = ',', $sQuote = '"', $iFormat = 0)

	Local Static $aEncoding[6] = [9, 9, 41, 73, 137, 265] ; Mode + 1 (append to end of file) + 8 (create dir structure)
	If $sDelimiter = "" Or IsKeyword($sDelimiter) Then $sDelimiter = ','
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	Local $iBound = UBound($aData, 1), $iSubBound = UBound($aData, 2)
	If Not $iSubBound Then Return SetError(1, 0, 0)
	Local $hFile = FileOpen($sFile, $aEncoding[$iFormat])
	If @error Then Return SetError(2, @error, 0)
	For $i = 1 To $iBound - 1
		For $j = 0 To $iSubBound - 1
			FileWrite($hFile, $sQuote & StringReplace($aData[$i][$j], $sQuote, $sQuote & $sQuote, 0, 1) & $sQuote)
			If $j < $iSubBound - 1 Then FileWrite($hFile, $sDelimiter)
		Next
		FileWrite($hFile, @CRLF)
	Next
	FileClose($hFile)
	Return $iBound - 1

EndFunc   ;==>__WriteCSV

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __OL_Property2Hex
; Description ...: Translates MAPI property names to hex
; Syntax.........: __OL_Property2Hex($sProperty)
; Parameters ....: $sProperty - MAPI property name to translate
; Return values .: Success - Hex value of the specified property
;                  Failure - "", sets @error to:
;                  |1 - Property name could not be found in the table
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __OL_Property2Hex($sProperty)

    Local $aProperties[100][2] = [[2, 2],["subject", "0x0037001E"],["SenderName","0x0C1A001F"]]
    For $i = 1 To $aProperties[0][0]
        If $aProperties[$i][0] = $sProperty Then Return $aProperties[$i][1]
    Next
    Return SetError(1, 0, "")

EndFunc   ;==>__OL_Property2Hex