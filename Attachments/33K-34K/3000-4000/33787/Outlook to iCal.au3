;===============================================================================
; Description:		Export a calendar from Outlook to an iCal file
;					that can be subscribed to by an iPhone via Dropbox,
;					a free cloud storage system.
;
;					Run this script as a Windows scheduled item to
;					automatically export your calendar items to your
;					local Dropbox "Public" folder as frequently as you
;					want. Dropbox will automatically publish the file
;					to your online storage.
;
;					On your iPhone, "Subscribe" to the public URL of
;					the exported calendar file through the "Settings"
;					Menu under "Mail, Contacts, Calendars", "Add Accounts",
;					"Other", "Add Subscribed Calendar". The public URL
;					of the exported calendar file can be found by
;					right-clicking the exported calendar file and
;					choosing "Copy Public Link" from the Dropbox menu.
;
;					As written, this script only exports events from the current
;					day plus 30 days. Only essential Outlook calendar fields
;					are exported. Customize as desired.
;
; Author:			mlowery
;
; Last revision:	2011-04-23 9:00 pm
#include <Date.au3>


;===============================================================================
; Description:
;
; AutoIt Version:	3.3.6.1

; Outlook Object Documentation
; 	http://msdn.microsoft.com/en-us/library/bb176631%28v=office.12%29.aspx

; iCal format Documentation
; 	                                 

; Includes functions from Outlook UDF by Wooltown
;	http://www.autoitscript.com/forum/topic/89321-outlook-udf/page__hl__outlook+udf

; Includes functions from CRC32 UDF by Yudin Dmitry (Lazycat)


;===============================================================================

; ------------------------------------------------------------------------------
; CONFIGURATION
; ------------------------------------------------------------------------------
; Seek backward is necessary to detect non-recurring events that span multiple days.
; An event starting yesterday and continuing through tomorrow would disappear from
; today's list, since the event_start is earlier than today. Instead, we examine events
; before today, and only include them if they have not yet ended.

Global $seek_backward = -30 ; number of days before today to scan events
Global $seek_forward = 30 ; number of days after today to scan events
Global $DISABLE_ALL_DAY_ALARM = True ; whether to create alarms for all-day events or not (they often sound in the middle of the night)

; ------------------------------------------------------------------------------
; VARIABLES
; ------------------------------------------------------------------------------

Global $ical_filename = "Calendar.ics" ; default filename for calendar - can be overridden by specifying commandline parameter 1
Global $dest_pathname = @ScriptDir & "\" & $ical_filename ; Defaults to current directory - can be overridden by specifying commandline parameter 1
Global $temp_pathname = @TempDir & "\ical.ics"

Global $iCal_contents = "" ; iCal data will be added to this string
Global $iCal_events = 0 ; number of events in the iCal_contents file
Global $set_alarm ; T/F whether to allow alarm or not for each event
Global $organizer_name ; display name for event organizer
Global $organizer_email ; email address of event organizer

Global $DROPBOX_EXE = "" ; Path to Dropbox - can be overridden by specifying commandline parameter 2


; ------------------------------------------------------------------------------
; CONSTANTS
; ------------------------------------------------------------------------------
Const $MAX_LINE_LENGTH = 64 ; maximum line width for text wrapping
Enum $EVENTFORMAT_DATETIME, $EVENTFORMAT_DATEONLY ; iCal date formats

; Outlook Constants
Const $olFolderCalendar = 9

; Dropbox Constants
Const $DROPBOX_EXE_FOLDER = "\Dropbox\bin\Dropbox.exe"
Const $DROPBOX_PROCESS = "Dropbox.exe"

;===============================================================================
; MAIN
;===============================================================================

; ------------------------------------------------------------------------------
; Initialize destination pathname from command line parameter
; Dest path should be to a filepath in a Dropbox 'public' folder so it
; can be subscribed to
; ------------------------------------------------------------------------------

; If given, uses command-line parameter as full pathname to final output iCal file
If $CmdLine[0] >= 1 Then $dest_pathname = $CmdLine[1]

If Not _iCalPathIsValid($dest_pathname) Then
	MsgBox(16, "Outlook to iCal", "Destination path is not valid")
	Exit
EndIf


; ------------------------------------------------------------------------------
; Initialize Outlook object
; ------------------------------------------------------------------------------
$oDict = ObjCreate("Scripting.Dictionary")
$oOutlook = _OutlookOpen()
If @error Then Exit

Sleep(3000) ; Wait for Outlook object to initialize

; ------------------------------------------------------------------------------
; Get appointment information from Outlook
; ------------------------------------------------------------------------------

; Fetch data beginning TODAY - $seekbackward through TODAY + $seek_forward
$today_date = @YEAR & "-" & @MON & "-" & @MDAY & " 00:00" ; Today format for _Date functions
$today_outlook = @YEAR & @MON & @MDAY & "000000" ; Today format for Outlook comparison

$date_start = _DateAdd("D", $seek_backward, $today_date)
$date_end = _DateAdd("D", $seek_forward, $today_date)

$appointments = _OutlookGetAppointments($oOutlook, $date_start, $date_end)
; ### if no appointments, then should just exit - we could set a var=TRUE in the $oItem loop, since it only executes if not NULL. if var not TRUE, then delete temp file and quit

; ------------------------------------------------------------------------------
; Create iCal as $iCal_contents
; ------------------------------------------------------------------------------

_iCalWrite("BEGIN", "VCALENDAR")
_iCalWrite("VERSION", "2.0")
_iCalWrite("PRODID", "//Outlook//NONSGML Outlook to iCal//EN") ; ### ARBITRARY string, required by spec, but not actually used

_iCalWrite("METHOD", "PUBLISH")

For $oItem In $appointments

	; if the item ended before today, don't include it in the iCal
	If $oItem.End < $today_outlook Then ContinueLoop

	; otherwise, create an event record
	_iCalWrite("BEGIN", "VEVENT")

	; start/end date/time
	If $oItem.AllDayEvent Then ; To show as an all day event, format DTs as dates without times
		_iCalWrite("DTSTART;VALUE=DATE", _iCalDateTime($oItem.Start, $EVENTFORMAT_DATEONLY))
		_iCalWrite("DTEND;VALUE=DATE", _iCalDateTime($oItem.End, $EVENTFORMAT_DATEONLY))
		If $DISABLE_ALL_DAY_ALARM Then $set_alarm = False
	Else
		_iCalWrite("DTSTART", _iCalDateTime($oItem.Start, $EVENTFORMAT_DATETIME))
		_iCalWrite("DTEND", _iCalDateTime($oItem.End, $EVENTFORMAT_DATETIME))
		$set_alarm = True
	EndIf

	_iCalWrite("DTSTAMP", _iCalDateTime($oItem.LastModificationTime, $EVENTFORMAT_DATETIME))

	_iCalWrite("SUMMARY", $oItem.Subject) ; title/name of event

	If $oItem.Location <> "" Then _iCalWrite("LOCATION", $oItem.Location)
	If $oItem.Body <> "" Then _iCalWrite("DESCRIPTION", $oItem.Body) ; description

	; event organizer name and email
	$organizer_name = $oItem.Organizer
	$organizer_email = _OutlookContactNameToEmail($organizer_name)
	_iCalWrite('ORGANIZER;CN="' & _iCalFormatOrganizerName($organizer_name) & '":MAILTO', $organizer_email)

	_iCalWrite("UID", $oItem.EntryID & $oItem.Start & $oItem.End) ; UID is arbitrary. It must be unique and present or else the item won't show up

	If $oItem.ReminderSet And $set_alarm Then
		_iCalWrite("BEGIN", "VALARM")
		_iCalWrite("TRIGGER", "-PT" & $oItem.ReminderMinutesBeforeStart & "M")
		_iCalWrite("ACTION", "DISPLAY")
		_iCalWrite("DESCRIPTION", "Reminder")
		_iCalWrite("END", "VALARM")
	EndIf

	_iCalWrite("END", "VEVENT")
	$iCal_events += 1

Next

_iCalWrite("END", "VCALENDAR")

; ------------------------------------------------------------------------------
; If new iCal has events write it. Move it to destination if changed, or discard it
; ------------------------------------------------------------------------------
If $iCal_events > 0 Then

	; Write temp iCal file
	$filehandle = FileOpen($temp_pathname, 10)
	FileWrite($filehandle, $iCal_contents)
	FileClose($filehandle)

	;Compare contents of temp and existing iCal files
	If FastCRC32FilePath($temp_pathname) <> FastCRC32FilePath($dest_pathname) Then
		FileMove($temp_pathname, $dest_pathname, 9)
	Else
		FileDelete($temp_pathname)
	EndIf

EndIf

$oOutlook = 0 ; Clear the Outlook object
$oDict = 0 ; Clear the dictionary object

; ------------------------------------------------------------------------------
; If Dropbox isn't running, start it before exiting
; ------------------------------------------------------------------------------

; Get optional Dropbox path from 2nd command-line parameter or infer from default install location
$DROPBOX_EXE = _DropboxGetEXEPath()
If Not ProcessExists($DROPBOX_PROCESS) And $DROPBOX_EXE <> "" Then Run($DROPBOX_EXE)

Exit

;===============================================================================
; Description:		Write text line to temporary iCal file
; Parameter(s):		$field		fieldname
;					$txt		field text
;					$escape		TRUE = escape special characters, FALSE = write text as is
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _iCalWrite($field, $txt)
	$txt = $field & ":" & _iCalEscapeString($txt)

	If StringLen($txt) > $MAX_LINE_LENGTH Then
		$txt = wrapText($txt)
	EndIf

	$iCal_contents &= $txt & @CRLF

EndFunc

;===============================================================================
; Description:		Escape special characters in a string
; Parameter(s):		$string		text to escape
; Requirement(s):   None
; Return Value(s):	Escaped text
; Note(s):
;===============================================================================
Func _iCalEscapeString($string)
	$string = StringReplace($string, ",", "\,")
	$string = StringReplace($string, ";", "\;")
	$string = StringReplace($string, @CRLF, "\n")
	Return $string
EndFunc

;===============================================================================
; Description:		Wrap long strings to fit $MAX_LINE_LENGTH
; Parameter(s):		$text		string to wrap
; Requirement(s):   $MAX_LINE_LENGTH must be defined and > 0
; Return Value(s):	Wrapped text
; Note(s):
;===============================================================================
Func wrapText($text)
	$lines_to_wrap = Int(StringLen($text) / $MAX_LINE_LENGTH)
	If $lines_to_wrap < 1 Then Return $text

	$wrapped_text = StringMid($text, 1, $MAX_LINE_LENGTH) ; First line unindented

	For $i = 1 To $lines_to_wrap ; remaining lines indented
		$wrapped_text &= @CRLF & @TAB & StringMid($text, ($i * $MAX_LINE_LENGTH) + 1, $MAX_LINE_LENGTH)
	Next

	Return $wrapped_text
EndFunc

;===============================================================================
; Description:		Return datetime string in iCAL format
; Parameter(s):		$outlook_datetime		string from Outlook as YYYYMMDDHHMMSS
;					$format
;						$EVENTFORMAT_DATETIME 	returns YYYYMMDDTHHMMSS
;						$EVENTFORMAT_DATEONLY	returns YYYYMMDD
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _iCalDateTime($outlook_datetime, $format)

	If $format = $EVENTFORMAT_DATEONLY Then
		Return StringLeft($outlook_datetime, 8)
	Else
		Return StringLeft($outlook_datetime, 8) & "T" & StringRight($outlook_datetime, 6)
	EndIf

EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _iCalPathIsValid($path)
	$valid = True

	If Not StringRegExp($dest_pathname, "^.:\.*") Then $valid = False
	If Not StringRight($dest_pathname, 4) == ".ics" Then $valid = False

	Return $valid
EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _iCalFormatOrganizerName($name)
	If StringInStr($name, ", ") Then
		$split = StringSplit($name, ", ", 1)
		If $split[0] > 1 Then
			Return $split[2] & " " & $split[1]
		EndIf
	EndIf
	Return $name

EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _OutlookContactNameToEmail($cname)
	; if the cname has already been resolved, then use the cached result
	If $oDict.Item($cname) <> "" Then Return $oDict.Item($cname)

	; if the cname contains an @, assume it is an email address and don't attempt to resolve it
	If StringInStr($cname, "@") Then Return $cname

	; create an object and resolve the cname
	Local $oRecip = $oOutlook.Application.Session.CreateRecipient($cname)
	$oRecip.Resolve
	If Not $oRecip.Resolved Then Return "no_email"

	; get the email address from the object
	Local $address = $oRecip.AddressEntry.Address
	If Not StringInStr($address, "@") And StringInStr($address, "/cn=") Then ; if not a direct email in the address, is an exchange user
		$address = $oRecip.AddressEntry.GetExchangeUser.PrimarySmtpAddress
	EndIf

	If $address == "" Then
		Return "no_email"
	Else
		$oDict.Item($cname) = $address
		Return $address
	EndIf

EndFunc

;===============================================================================
; Description:		Get events from Outlook between $sStartDate and $sEndDate
; Parameter(s):
; Requirement(s):   None
; Return Value(s):	Returns an OBJ containing events
; Note(s):
;===============================================================================
Func _OutlookGetAppointments($oOutlook, $sStartDate = "", $sEndDate = "")
	Local $sFilter = "", $fAllDayEvent, $oFilteredItems

	Local $oNamespace = $oOutlook.GetNamespace("MAPI")
	Local $oFolder = $oNamespace.GetDefaultFolder($olFolderCalendar)
	Local $oColItems = $oFolder.Items

	$oColItems.Sort("[Start]")

	$oColItems.IncludeRecurrences = True

	If $sStartDate <> "" Then
		If Not _DateIsValid($sStartDate) Then Return SetError(1, 0, 0)
		If $sFilter <> "" Then $sFilter &= ' And '
		$sFilter &= '[Start] >= "' & $sStartDate & '"'
	EndIf
	If $sEndDate <> "" Then
		If Not _DateIsValid($sEndDate) Then Return SetError(1, 0, 0)
		If $sFilter <> "" Then $sFilter &= ' And '
		$sFilter &= '[End] <= "' & $sEndDate & '"'
	EndIf

	$oFilteredItems = $oColItems.Restrict($sFilter)
	If $sFilter = "" Then Return SetError(1, 0, 0)

	Return $oFilteredItems

EndFunc

;===============================================================================
;
; Function Name:    _OutlookOpen()
; Description:      Open a connection to Microsoft Outlook.
; Syntax.........:  _OutlookOpen()
; Parameter(s):     None
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
; Return Value(s): 	On Success 		- Returns new object identifier
;                   On Failure   	- Returns 0 and sets @ERROR > 0
;					@ERROR = 1   	- Unable to Create Outlook Object.
; Author(s):        Wooltown
; Created:          2009-02-09
; Modified:         -
;
;===============================================================================
Func _OutlookOpen()
	Local $oOutlook = ObjCreate("Outlook.Application")
	If @error Or Not IsObj($oOutlook) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $oOutlook
EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func _DropboxGetEXEPath()
	Select
		Case $CmdLine[0] >= 2 ; Command line parameter
			$path = $CmdLine[2]

		Case FileExists(@AppDataDir & $DROPBOX_EXE_FOLDER) ; Default installation location
			$path = @AppDataDir & $DROPBOX_EXE_FOLDER

		Case FileExists(StringLeft(@ScriptFullPath, 2) & "\Program Files" & $DROPBOX_EXE_FOLDER); Same drive as script, inside program files directory
			$path = StringLeft(@ScriptFullPath, 2) & "\Program Files" & $DROPBOX_EXE_FOLDER

		Case Else
			$path = ""
	EndSelect

	Return $path

EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================

Func FastCRC32File($sPath, $sFile)
	Local $nBufSize = 16384 * 8
	Local $CRC32 = 0

	local $hFile = FileOpen($sPath & "\" & $sFile, 16)
	For $i = 1 To Ceiling(FileGetSize($sPath & "\" & $sFile) / $nBufSize)
		$CRC32 = FastCRC32(FileRead($hFile, $nBufSize), BitNOT($CRC32))
	Next
	FileClose($hFile)
	Return $CRC32

EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================
Func FastCRC32FilePath($sFilepath)
		Local $nBufSize = 16384 * 8
	Local $CRC32 = 0

	local $hFile = FileOpen($sFilepath, 16)
	For $i = 1 To Ceiling(FileGetSize($sFilepath) / $nBufSize)
		$CRC32 = FastCRC32(FileRead($hFile, $nBufSize), BitNOT($CRC32))
	Next
	FileClose($hFile)
	Return $CRC32
EndFunc

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):   None
; Return Value(s):
; Note(s):
;===============================================================================

Func FastCRC32($vBuffer, $nCRC32 = 0xFFFFFFFF)
    Local $nLen, $vTemp
    If DllStructGetSize($vBuffer) = 0 Then ; String passed
        If IsBinary($vBuffer) Then
            $nLen = BinaryLen($vBuffer)
        Else
            $nLen = StringLen($vBuffer)
        EndIf
        $vTemp = DllStructCreate("byte[" & $nLen & "]")
        DllStructSetData($vTemp, 1, $vBuffer)
        $vBuffer = $vTemp
    EndIf

    ; Machine code hex strings (created by Laszlo)
    Local $CRC32Init = "0x33C06A088BC85AF6C101740AD1E981F12083B8EDEB02D1E94A75EC8B542404890C82403D0001000072D8C3"
    Local $CRC32Exec = "0x558BEC33C039450C7627568B4D080FB60C08334D108B55108B751481E1FF000000C1EA0833148E403B450C89551072DB5E8B4510F7D05DC3"

    ; Create machine code stubs
    Local $CRC32InitCode = DllStructCreate("byte[" & BinaryLen($CRC32Init) & "]")
    DllStructSetData($CRC32InitCode, 1, $CRC32Init)
    Local $CRC32ExecCode = DllStructCreate("byte[" & BinaryLen($CRC32Exec) & "]")
    DllStructSetData($CRC32ExecCode, 1, $CRC32Exec)

    ; Structure for CRC32 Lookup table
    Local $CRC32LookupTable = DllStructCreate("int["& 256 &"]")

    ; CallWindowProc under WinXP can have 0 or 4 parameters only, so pad remain params with zeros
    ; Execute stub for fill lookup table
    DllCall("user32.dll", "int", "CallWindowProc", "ptr", DllStructGetPtr($CRC32InitCode), _
                                                   "ptr", DllStructGetPtr($CRC32LookupTable), _
                                                   "int", 0, _
                                                   "int", 0, _
                                                   "int", 0)
    ; Execute main stub
    Local $ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", DllStructGetPtr($CRC32ExecCode), _
                                                                 "ptr", DllStructGetPtr($vBuffer), _
                                                                 "uint", DllStructGetSize($vBuffer), _
                                                                 "uint", $nCRC32, _
                                                                 "ptr", DllStructGetPtr($CRC32LookupTable))
    Return $ret[0]
EndFunc