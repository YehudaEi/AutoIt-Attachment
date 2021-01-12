; http://www.tek-tips.com/faqs.cfm?fid=3894
; http://support.microsoft.com/kb/208520

#include "C:\_\Apps\AutoIT3\COM\Excel\ExcelCOM_UDF.au3"
#include <C:\_\Apps\AutoIT3\COM\Word\Word.au3>

Opt("WinTitleMatchMode", 4) ; Allow ClassName lookup to avoid window confusion

; C:\_\Apps\AutoIT3\COM\COM Library Properties.au3 to Generate the Constants !!
Const $olReply = 0
Const $olReplyAll = 1
Const $olForward = 2
Const $olReplyFolder = 3
Const $olRespond = 4
Const $olOmitOriginalText = 0
Const $olEmbedOriginalItem = 1
Const $olIncludeOriginalText = 2
Const $olIndentOriginalText = 3
Const $olLinkOriginalItem = 4
Const $olUserPreference = 5
Const $olReplyTickOriginalText = 1000
Const $olOpen = 0
Const $olSend = 1
Const $olPrompt = 2
Const $olDontShow = 0
Const $olMenu = 1
Const $olMenuAndToolbar = 2
Const $olByValue = 1
Const $olByReference = 4
Const $olEmbeddeditem = 5
Const $olOLE = 6
Const $olFree = 0
Const $olTentative = 1
Const $olBusy = 2
Const $olOutOfOffice = 3
Const $olSunday = 1
Const $olMonday = 2
Const $olTuesday = 4
Const $olWednesday = 8
Const $olThursday = 16
Const $olFriday = 32
Const $olSaturday = 64
Const $olFolderDeletedItems = 3
Const $olFolderOutbox = 4
Const $olFolderSentMail = 5
Const $olFolderInbox = 6
Const $olFolderCalendar = 9
Const $olFolderContacts = 10
Const $olFolderJournal = 11
Const $olFolderNotes = 12
Const $olFolderTasks = 13
Const $olFolderDrafts = 16
Const $olPublicFoldersAllPublicFolders = 18
Const $olUser = 0
Const $olDistList = 1
Const $olForum = 2
Const $olAgent = 3
Const $olOrganization = 4
Const $olPrivateDistList = 5
Const $olRemoteUser = 6
Const $olEditorText = 1
Const $olEditorHTML = 2
Const $olEditorRTF = 3
Const $olEditorWord = 4
Const $olNoFlag = 0
Const $olFlagComplete = 1
Const $olFlagMarked = 2
Const $olFolderDisplayNormal = 0
Const $olFolderDisplayFolderOnly = 1
Const $olFolderDisplayNoNavigation = 2
Const $olDefaultRegistry = 0
Const $olPersonalRegistry = 2
Const $olFolderRegistry = 3
Const $olOrganizationRegistry = 4
Const $olUnspecified = 0
Const $olFemale = 1
Const $olMale = 2
Const $olImportanceLow = 0
Const $olImportanceNormal = 1
Const $olImportanceHigh = 2
Const $olSave = 0
Const $olDiscard = 1
Const $olPromptForSave = 2
Const $olMailItem = 0
Const $olAppointmentItem = 1
Const $olContactItem = 2
Const $olTaskItem = 3
Const $olJournalItem = 4
Const $olNoteItem = 5
Const $olPostItem = 6
Const $olDistributionListItem = 7
Const $olAssociatedContact = 1
Const $olNone = 0
Const $olHome = 1
Const $olBusiness = 2
Const $olOther = 3
Const $olOriginator = 0
Const $olTo = 1
Const $olCC = 2
Const $olBCC = 3
Const $olOrganizer = 0
Const $olRequired = 1
Const $olOptional = 2
Const $olResource = 3
Const $olMeetingTentative = 2
Const $olMeetingAccepted = 3
Const $olMeetingDeclined = 4
Const $olNonMeeting = 0
Const $olMeeting = 1
Const $olMeetingReceived = 3
Const $olMeetingCanceled = 5
Const $olNetMeeting = 0
Const $olNetShow = 1
Const $olExchangeConferencing = 2
Const $olBlue = 0
Const $olGreen = 1
Const $olPink = 2
Const $olYellow = 3
Const $olWhite = 4
Const $olApplication = 0
Const $olNamespace = 1
Const $olFolder = 2
Const $olRecipient = 4
Const $olAttachment = 5
Const $olAddressList = 7
Const $olAddressEntry = 8
Const $olFolders = 15
Const $olItems = 16
Const $olRecipients = 17
Const $olAttachments = 18
Const $olAddressLists = 20
Const $olAddressEntries = 21
Const $olAppointment = 26
Const $olMeetingRequest = 53
Const $olMeetingCancellation = 54
Const $olMeetingResponseNegative = 55
Const $olMeetingResponsePositive = 56
Const $olMeetingResponseTentative = 57
Const $olRecurrencePattern = 28
Const $olExceptions = 29
Const $olException = 30
Const $olAction = 32
Const $olActions = 33
Const $olExplorer = 34
Const $olInspector = 35
Const $olPages = 36
Const $olFormDescription = 37
Const $olUserProperties = 38
Const $olUserProperty = 39
Const $olContact = 40
Const $olDocument = 41
Const $olJournal = 42
Const $olMail = 43
Const $olNote = 44
Const $olPost = 45
Const $olReport = 46
Const $olRemote = 47
Const $olTask = 48
Const $olTaskRequest = 49
Const $olTaskRequestUpdate = 50
Const $olTaskRequestAccept = 51
Const $olTaskRequestDecline = 52
Const $olExplorers = 60
Const $olInspectors = 61
Const $olPanes = 62
Const $olOutlookBarPane = 63
Const $olOutlookBarStorage = 64
Const $olOutlookBarGroups = 65
Const $olOutlookBarGroup = 66
Const $olOutlookBarShortcuts = 67
Const $olOutlookBarShortcut = 68
Const $olDistributionList = 69
Const $olPropertyPageSite = 70
Const $olPropertyPages = 71
Const $olSyncObject = 72
Const $olSyncObjects = 73
Const $olSelection = 74
Const $olLink = 75
Const $olLinks = 76
Const $olSearch = 77
Const $olResults = 78
Const $olViews = 79
Const $olView = 80
Const $olItemProperties = 98
Const $olItemProperty = 99
Const $olReminders = 100
Const $olReminder = 101
Const $olLargeIcon = 0
Const $olSmallIcon = 1
Const $olOutlookBar = 1
Const $olFolderList = 2
Const $olPreview = 3
Const $olApptNotRecurring = 0
Const $olApptMaster = 1
Const $olApptOccurrence = 2
Const $olApptException = 3
Const $olRecursDaily = 0
Const $olRecursWeekly = 1
Const $olRecursMonthly = 2
Const $olRecursMonthNth = 3
Const $olRecursYearly = 5
Const $olRecursYearNth = 6
Const $olRemoteStatusNone = 0
Const $olUnMarked = 1
Const $olMarkedForDownload = 2
Const $olMarkedForCopy = 3
Const $olMarkedForDelete = 4
Const $olResponseNone = 0
Const $olResponseOrganized = 1
Const $olResponseTentative = 2
Const $olResponseAccepted = 3
Const $olResponseDeclined = 4
Const $olResponseNotResponded = 5
Const $olTXT = 0
Const $olRTF = 1
Const $olTemplate = 2
Const $olMSG = 3
Const $olDoc = 4
Const $olHTML = 5
Const $olVCard = 6
Const $olVCal = 7
Const $olICal = 8
Const $olNormal = 0
Const $olPersonal = 1
Const $olPrivate = 2
Const $olConfidential = 3
Const $olSortNone = 0
Const $olAscending = 1
Const $olDescending = 2
Const $olTaskNotDelegated = 0
Const $olTaskDelegationUnknown = 1
Const $olTaskDelegationAccepted = 2
Const $olTaskDelegationDeclined = 3
Const $olNewTask = 0
Const $olDelegatedTask = 1
Const $olOwnTask = 2
Const $olUpdate = 2
Const $olFinalStatus = 3
Const $olTaskSimple = 0
Const $olTaskAssign = 1
Const $olTaskAccept = 2
Const $olTaskDecline = 3
Const $olTaskNotStarted = 0
Const $olTaskInProgress = 1
Const $olTaskComplete = 2
Const $olTaskWaiting = 3
Const $olTaskDeferred = 4
Const $olTrackingNone = 0
Const $olTrackingDelivered = 1
Const $olTrackingNotDelivered = 2
Const $olTrackingNotRead = 3
Const $olTrackingRecallFailure = 4
Const $olTrackingRecallSuccess = 5
Const $olTrackingRead = 6
Const $olTrackingReplied = 7
Const $olOutlookInternal = 0
Const $olText = 1
Const $olNumber = 3
Const $olDateTime = 5
Const $olYesNo = 6
Const $olDuration = 7
Const $olKeywords = 11
Const $olPercent = 12
Const $olCurrency = 14
Const $olFormula = 18
Const $olCombination = 19
Const $olMaximized = 0
Const $olMinimized = 1
Const $olNormalWindow = 2
Const $olSyncStopped = 0
Const $olSyncStarted = 1
Const $olFormatUnspecified = 0
Const $olFormatPlain = 1
Const $olFormatHTML = 2
Const $olFormatRichText = 3
Const $olHeaderOnly = 0
Const $olFullItem = 1
Const $olExcelWorkSheetItem = 8
Const $olWordDocumentItem = 9
Const $olPowerPointShowItem = 10
Const $olViewSaveOptionThisFolderEveryone = 0
Const $olViewSaveOptionThisFolderOnlyMe = 1
Const $olViewSaveOptionAllFoldersOfType = 2
Const $olTableView = 0
Const $olCardView = 1
Const $olCalendarView = 2
Const $olIconView = 3
Const $olTimelineView = 4

Dim $objOL, $objNS, $objFolder, $objExcel
Dim $iItemCount, $colItems, $I
Dim $sAppWindow

_WordErrorHandlerRegister() ; use this handler of Word instead of the COM handler

;$sAppWindow = WinGetHandle("classname=rctrl_renwnd32")
;If ProcessExists($sAppWindow) Then
;    MsgBox(0, "", "Window exists")
;Else ;
;	MsgBox(0, "", "Window does not exists")
;EndIf

$objOL = ObjCreate("Outlook.Application")
$objNS = $objOL.GetNameSpace("MAPI")
$objFolder = $objNS.GetDefaultFolder($olFolderContacts)

;$objFolder.display()
;$objFolder.Items.Find('[BalanceDue]=500') ; to locate a contact with a userdefined field 'BalanceDue' set to a numeric value.

$iItemCount = $objFolder.Items.count

;$colItems = $objFolder.Items ; includes every item including blank items, result in COM Errors
; Solutions is Restrict selection

$strWhere = "[Email1Address] <> '' " & _
            "Or [Email2Address] <> '' " & _
			"Or [Email3Address] <> '' "

$colItems = $objFolder.Items.Restrict($strWhere) ; Don' t show blank items Selection
;$colItems.SetColumns ("Fullnmae, Email1Address") ; Caching field properties for fast access

;Excel
$objExcel = _ExcelBookNew()

; Header Row
Local $x =1
Local $y = 1
_ExcelWriteCell($objExcel, "FullName", $y, $x )
	_ExcelFontSetProperties ($objExcel,"A1",1,1,1,True,False,False) 
_ExcelWriteCell($objExcel, "Email Address", $y, $x+1)
	_ExcelFontSetProperties ($objExcel,"B1",1,1,4,True,False,False) 
_ExcelWriteCell($objExcel,$iItemCount, $y, $x+2)
	_ExcelFontSetProperties ($objExcel,"C1",1,1,4,True,False,False) 
; Detailed Rows
	For $sItem in $colItems
		$y += 1	
		_ExcelWriteCell($objExcel, $sItem.fullName, $y, $x )
		_ExcelWriteCell($objExcel, $sItem.email1address, $y, $x+1 )
	Next
	$objExcel.Columns("A:A").EntireColumn.AutoFit
	$objExcel.Columns("B:B").EntireColumn.AutoFit

Sleep(3000)
_ExcelBookClose($objExcel)

; Word
$oWordApp = _WordCreate ("")
$oDoc = _WordDocAdd ($oWordApp)
	For $sItem in $colItems
	$oDoc.Range.insertAfter ($sItem.fullName & @TAB&@TAB&@TAB&@TAB & $sItem.email1address & @CRLF)
	Next
Sleep(4000)
_WordQuit ($oWordApp, 0)


