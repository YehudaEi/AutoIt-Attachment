#cs
vi:ts=4 sw=4:
#include <windows.h>
#include <stdio.h>

#define BUFFER_SIZE 1024*64

void DisplayEntries( )
{
    HANDLE h;
    EVENTLOGRECORD *pevlr; 
    BYTE bBuffer[BUFFER_SIZE]; 
    DWORD dwRead, dwNeeded, dwThisRecord; 
 
    // Open the Application event log. 
 
    h = OpenEventLog( NULL,    // use local computer
             "Application");   // source name
    if (h == NULL) 
    {
        printf("Could not open the Application event log."); 
        return;
    }
 
    pevlr = (EVENTLOGRECORD *) &bBuffer; 
 
    // Get the record number of the oldest event log record.

    GetOldestEventLogRecord(h, &dwThisRecord);

    // Opening the event log positions the file pointer for this 
    // handle at the beginning of the log. Read the event log records 
    // sequentially until the last record has been read. 
 
    while (ReadEventLog(h,                // event log handle 
                EVENTLOG_FORWARDS_READ |  // reads forward 
                EVENTLOG_SEQUENTIAL_READ, // sequential read 
                0,            // ignored for sequential reads 
                pevlr,        // pointer to buffer 
                BUFFER_SIZE,  // size of buffer 
                &dwRead,      // number of bytes read 
                &dwNeeded))   // bytes in next record 
    {
        while (dwRead > 0) 
        { 
            // Print the record number, event identifier, type, 
            // and source name. 
 
            printf("%03d  Event ID: 0x%08X  Event type: ", 
                dwThisRecord++, pevlr->EventID); 

            switch(pevlr->EventType)
            {
                case EVENTLOG_ERROR_TYPE:
                    printf("EVENTLOG_ERROR_TYPE\t  ");
                    break;
                case EVENTLOG_WARNING_TYPE:
                    printf("EVENTLOG_WARNING_TYPE\t  ");
                    break;
                case EVENTLOG_INFORMATION_TYPE:
                    printf("EVENTLOG_INFORMATION_TYPE  ");
                    break;
                case EVENTLOG_AUDIT_SUCCESS:
                    printf("EVENTLOG_AUDIT_SUCCESS\t  ");
                    break;
                case EVENTLOG_AUDIT_FAILURE:
                    printf("EVENTLOG_AUDIT_FAILURE\t  ");
                    break;
                default:
                    printf("Unknown ");
                    break;
            }

            printf("Event source: %s\n", 
                (LPSTR) ((LPBYTE) pevlr + sizeof(EVENTLOGRECORD))); 
 
            dwRead -= pevlr->Length; 
            pevlr = (EVENTLOGRECORD *) 
                ((LPBYTE) pevlr + pevlr->Length); 
        } 
 
        pevlr = (EVENTLOGRECORD *) &bBuffer; 
    } 
 
    CloseEventLog(h); 
}

#ce
Global $SYS_APPLICATION_EVENT_LOG	= 0
Global $SYS_SECURITY_EVENT_LOG		= 1
Global $SYS_SYSTEM_EVENT_LOG		= 2

$SystemHandle	= _OpenEventLog($SYS_APPLICATION_EVENT_LOG)
if $SystemHandle Then MsgBox(0,"","Opened Event Log: " & @CRLF & _ReadEventLog($SystemHandle,1))

_CloseEventLog($SystemHandle)
exit

;msgbox(0,"",_SysLogWrite($a,"\\edward"))

Func _OpenEventLog($iLogFile,$szComputer="")
	Local $ret,$szSystem,$szLogFile

	SetError(0)
	Select
		Case $iLogFile = 0
			$szLogFile	= "Application"
		Case $iLogFile = 1
			$szLogFile	= "Security"
		Case $iLogFile = 2
			$szLogFile	= "System"
		Case Else
			SetError(-1)
			Return 0
	EndSelect

	;open a handle for the eventlog
	If $szComputer = "" Then ; local machine
		$ret	= DllCall("Advapi32.dll","int","OpenEventLog",_
						"ptr",0,_
						"str",$szLogFile)
	Else
		If StringLeft($szComputer,2) = "\\" Then
			$szSystem = $szComputer
		Else
			$szSystem = "\\" & $szComputer
		EndIf
		$ret	= DllCall("Advapi32.dll","int","OpenEventLog",_
						"str",$szSystem,_
						"str",$szLogFile)
	EndIf

	Return $ret[0]
EndFunc

Func _CloseEventLog(ByRef $fdHandle)
	if $fdHandle Then
		DllCall("Advapi32.dll","int","CloseEventLog",_
				"int",$fdHandle)
	EndIf
	$fdHandle = 0
EndFunc

Func _GetNumberOfEventLogRecords($fdHandle)
	Local $ret,$p,$i=0

	SetError(0)
	$p	= DllStructCreate("dword")
	If @Error Then Return 0

	$ret	= DllCall("Advapi32.dll","int","GetNumberOfEventLogRecords",_
					"int",$fdHandle,_
					"ptr",DllStructGetPtr($p))

	if $ret[0] Then $i	= DllStructGetData($p,1)
	DllStructDelete($p)
	Return $i
EndFunc

Func _GetOldestEventLogRecord($fdHandle)
	Local $ret,$p,$i=0

	SetError(0)
	$p	= DllStructCreate("dword")
	If @Error Then Return 0

	$ret	= DllCall("Advapi32.dll","int","GetOldestEventLogRecord",_
					"int",$fdHandle,_
					"ptr",DllStructGetPtr($p))

	if $ret[0] Then $i	= DllStructGetData($p,1)
	DllStructDelete($p)
	Return $i
EndFunc


Func _ReadEventLog($fdHandle,$iEvent)
	Local $p,$s="",$ret,$dwords,$oldest,$eventtype,$dwRead,$Length

	$dwords	= DllStructCreate("dword;dword")
	if @error then return ""

	$p		= DllStructCreate("byte[65536]")
	if @error then
		DllStructDelete($dwords)
		return ""
	Endif

	$EVENT_LOG_RECORD	= DllStructCreate("dword[6];short[4];dword[6]",DllStructGetPtr($p))
	if @error then
		DllStructDelete($dwords)
		DllStructDelete($p)
		return ""
	Endif

	$oldest	= _GetOldestEventLogRecord($fdHandle)

	do
		$ret	= DllCall("Advapi32.dll","int","ReadEventLog",_
						"int",$fdHandle,_
						"int",BitOr(0x0001,0x0004),_
						"int",0,_
						"ptr",DllStructGetPtr($p),_
						"int",65536,_
						"ptr",DllStructGetPtr($dwords,1),_
						"ptr",DllStructGetPtr($dwords,2))

		if $ret[0] Then
			$dwRead	= DllStructGetData($dwords,1)
			While $dwRead > 0
				$s	&= StringFormat("%03d  Event ID: 0x%08X  Event type: ",_
									$oldest, DllStructGetData($EVENT_LOG_RECORD,1,6))
				$oldest		+= 1
				$eventtype	= DllStructGetData($EVENT_LOG_RECORD,2,1)
				Select
					case $eventtype = 0x0001
						$s	&= "EVENTLOG_ERROR_TYPE"
					case $eventtype = 0x0010
						$s	&= "EVENTLOG_AUDIT_FAILURE"
					case $eventtype = 0x0008
						$s	&= "EVENTLOG_AUDIT_SUCCESS"
					case $eventtype = 0x0004
						$s	&= "EVENTLOG_INFORMATION_TYPE"
					case $eventtype = 0x0002
						$s	&= "EVENTLOG_WARNING_TYPE"
					case Else
						$s	&= "UNKNOWN"
				EndSelect

				$Length	= DllStructGetData($EVENT_LOG_RECORD,1,1)

				$source	= DllStructCreate("char[" & $Length & "]",DllStructGetPtr($EVENT_LOG_RECORD) + DllStructGetSize($EVENT_LOG_RECORD))
				if @error Then
					DllStructDelete($p)
					DllStructDelete($dwords)
					return ""
				Endif
				$s	&= "  Event Source: " & DllStructGetData($source,1) & @CRLF
				
				$dwRead	-= $Length

				$EVENT_LOG_RECORD	= DllStructCreate("dword[6];short[4];dword[6]",DllStructGetPtr($EVENT_LOG_RECORD) + $Length)
			Wend
		EndIf
		$EVENT_LOG_RECORD	= DllStructCreate("dword[6];short[4];dword[6]",DllStructGetPtr($p))
	until $ret[0] = 0

	DllStructDelete($p)
	DllStructDelete($dwords)

	Return $s
EndFunc

Func _SysLogWrite($LogEntry,$szComputer="")
	Local $ret,$event_handle=0,$p,$i,$arraylen
	Local $struct_str="int",$szSystem

	if IsArray($LogEntry) Then ; passed an array
		$arraylen	= UBOUND($LogEntry)
		$struct_str	&= ";ptr[" & $arraylen & "]"

		For $i = 0 to $arraylen-1
			$struct_str	&= ";char[" & StringLen($LogEntry[$i]) + 1 & "]"
		Next

		$p	= DllStructCreate($struct_str)
		if @Error Then Return 0

		DllStructSetData($p,1,$arraylen);# of strings
		For $i = 0 To $arraylen-1
			DllStructSetData($p,2,DllStructGetPtr($p,$i+3),$i+1);ptr to string
			DllStructSetData($p,$i+3,$LogEntry[$i]);copy the string
		Next
	Else; $LogEntry is a string
		$struct_str	&= ";ptr;char[" & StringLen($LogEntry)+1 & "]"

		$p	= DllStructCreate($struct_str)
		If @Error Then Return 0

		DllStructSetData($p,1,1);1 string
		DllStructSetData($p,2,DllStructGetPtr($p,3));ptr to the string
		DllStructSetData($p,3,$LogEntry);copy the string
	EndIf

	
	;open a handle for the eventlog
	If $szComputer = "" Then ; local machine
		$ret	= DllCall("Advapi32.dll","int","RegisterEventSource",_
						"ptr",0,_
						"str","System")
	Else
		If StringLeft($szComputer,2) = "\\" Then
			$szSystem = $szComputer
		Else
			$szSystem = "\\" & $szComputer
		EndIf
		$ret	= DllCall("Advapi32.dll","int","RegisterEventSource",_
						"str",$szSystem,_
						"str","System")
	EndIf

	If $ret[0] Then
		$event_handle = $ret[0]
	Else
		return 0
	EndIf

	$ret	= DllCall("Advapi32.dll","int","ReportEvent",_
					"int",$event_handle,_
					"int",4,_
					"int",0,_
					"int",0,_
					"ptr",0,_
					"int",DllStructGetData($p,1),_
					"int",0,_
					"ptr",DllStructGetPtr($p,2),_
					"ptr",0)
	DllStructDelete($p)

	;close the handle
	if $event_handle Then
		DllCall("Advapi32.dll","int","DeregisterEventSource",_
				"int",$event_handle)
	EndIf

	return $ret[0]
EndFunc

