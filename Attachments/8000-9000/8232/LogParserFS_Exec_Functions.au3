; See LogParser Helpfile to start with
; Look here to get started
; http://www.microsoft.com/technet/community/columns/scripts/sg0105.mspx
;                                        
; ptrex 28/04/06


Dim $oLogQuery
Dim $oInputFormat
Dim $oRecordSet
Dim $StrQuery, $oRecords
Dim $f

; Define Objects
$oLogQuery = ObjCreate("MSUtil.LogQuery")
$oInputFormat=ObjCreate("MSUtil.LogQuery.FileSystemInputFormat")

; Initialize SvenP 's  error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;~ ; Set Input Format Parameter -> Boolian
$oInputFormat.recurse = 1 ; default -1 = All SubDir
$oInputFormat.preserveLastAccTime = 1 
$oInputFormat.useLocalTime = 1

; Create an SQL query text. To check for hidden files, we use LIKE ‘%H%’; to check for encrypted files, we use LIKE ‘%E%’; and so on. 
$StrQuery = "SELECT TOP 10 TO_LOWERCASE (Name) AS NewName, Size FROM " & "'C:\Program Files\AutoIt3\*.*' WHERE NOT Attributes LIKE '%D%' ORDER BY Size DESC"

; Execute query and receive a LogRecordSet, 
; Opposed to "ExecuteBatch" which is directly displaying information, it grabs that data and holds it in a recordset in memory (varaibles)
$oRecordSet = $oLogQuery.Execute($strQuery,$oInputFormat)

$oRecords = $oRecordSet.getColumnCount() ; # of Columns
; Column Name
         MsgBox(0,"Columns", "# Of Columns " & $oRecords)
 
For $f = 0 To $oRecords -1

    While not $oRecordSet.atEnd	; Get records till end
	$oRecord = $oRecordSet.getRecord
        ; Display record information
         MsgBox(0,"fields", "Name : " & $oRecord.getValue("NewName")&" Size : " & $oRecord.getValue(1)/1000&" Bytes") ; By name or Index = 0 based")
		$oRecordSet.moveNext ; Get next records
	WEnd
Next

; Close LogRecordSet
$oRecordSet.close()

;This is Sven P's custom error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc