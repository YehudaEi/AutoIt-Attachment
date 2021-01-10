$logFilePath="c:\scripts\"
$logFileName="autoItDebugLog"

dim $logFileHandle  
_openLogFile()
_addToLog("info","Application started")

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;This function open the latest logfile for use. If the file is too large, a new logfile is created and opened.
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func _openLogFile()
	;Find the file with the latest date/time stamp, while matchine the filename
	FileChangeDir($logFilePath)
	$logFileHandle=FileFindFirstFile($logFileName & "*")
	$searchDate=0
	$searchName=$logFileName & "-" & @YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR  & @MIN & @SEC & ".txt"
	while 1
		$tmpfName=FileFindNextFile($logFileHandle)
		if @error then ExitLoop
		$tmpfdate=FileGetTime($tmpfName,0,1) 
		if $searchDate<$tmpfdate then 
			$searchDate=$tmpfdate
			$searchName=$tmpfName
		EndIf
	WEnd

	;If the current file is too large (more than 200kb), then create a new file in stead of appending to the old file
	if FileGetSize($searchName)>200000 then $searchName =  $logFileName & "-" & @YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR &  @MIN &  @SEC & ".txt"
	$logFileHandle=FileOpen($searchName,1)
	if $logFileHandle=-1 then 
		MsgBox(0,"Error","Unable to open logfile: " & $logFilePath & $searchName)
		Exit
	EndIf
EndFunc

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;This function append one line to the logfile $logFileHandle that was previosuly opened/created with _openLogFile()
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func _addToLog($logGroup, $logStr)
	;First adjust the $logGroup parameter to a 8 digit string, fixed length, left aligned
	if StringLen($logGroup) > 8 then 
		$logGroup=StringRight($logGroup,8)
	Else
		$logGroup=$logGroup&StringRight("        ",8-StringLen($logGroup))
	EndIf
	FileWriteLine($logFileHandle,@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":"&  @MIN & ":"& @SEC &" |" & $logGroup & "|  " & $logStr )
EndFunc
