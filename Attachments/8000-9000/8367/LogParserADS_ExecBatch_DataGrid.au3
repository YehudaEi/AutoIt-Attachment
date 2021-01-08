; See LogParser Helpfile to start with
; Look here to get started
; http://www.microsoft.com/technet/community/columns/scripts/sg0105.mspx
;                                        
; ptrex 28/04/06

Dim $oLogQuery
Dim $oInputFormat
Dim $oOutputFormat
Dim $StrQuery
Dim $oMyError

; Define Objects
$oLogQuery= ObjCreate("MSUtil.LogQuery")
$oInputFormat=ObjCreate("MSUtil.LogQuery.ADSInputFormat") ; ADS
$oOutputFormat = ObjCreate("MSUtil.LogQuery.DataGridOutputFormat")  ; DataGrid

; Initialize SvenP 's  error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;~ ; Set Input Format Parameter -> Boolian
	With $oInputFormat
		;.objClass =
		;.username =
		;.password =
		.recurse = -1 ; default -1 = All SubDir
		.multiValuedSep = "|"
		.ignoreDSErrors = 1
		.parseBinary = 0
		.binaryFormat = "PRINT"
	EndWith	

; Set Output Format Parameters -> Boolian
	With $oOutputFormat
		.rtp= 40 ; Default
		.autoScroll = 1
	EndWith

; Create a SQL query text
$StrQuery = "SELECT * FROM LDAP://Domain.Company.com WHERE PropertyName = 'department' AND ObjectClass = 'user'"

; Execbatch is used for combining input and output parameters when executing
; The ExecuteBatch method executes a script and then displays/saves the output in a command window, an HTML file, a SQL database, whatever.
$oLogQuery.ExecuteBatch($StrQuery , $oInputFormat , $oOutputFormat) 

$oLogQuery = ""
$oInputFormat = ""
$oOutputFormat = ""

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
