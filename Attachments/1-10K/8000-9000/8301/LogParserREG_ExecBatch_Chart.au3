; See LogParser Helpfile to start with
; Look here to get started
; http://www.microsoft.com/technet/community/columns/scripts/sg0105.mspx
;                                        
; ptrex 29/04/06

Dim $oLogQuery
Dim $oInputFormat
Dim $oOutputFormat
Dim $StrQuery
Dim $oMyError

; Define Objects
$oLogQuery= ObjCreate("MSUtil.LogQuery")
$oInputFormat=ObjCreate("MSUtil.LogQuery.RegistryInputFormat") ; Registry
$oOutputFormat = ObjCreate("MSUtil.LogQuery.ChartOutputFormat") ; Chart

;~ ; Set Input Format Parameter -> Boolian
	With $oInputFormat
		.recurse = -1 ; default -1 = All SubDir
		.binaryFormat = "PRINT" ; ASC or HEX
	EndWith

; Set Output Format Parameters -> Boolian
	With $oOutputFormat
		.chartType = "Column3D"
		.categories = "Auto"
		.maxCategoryLabels = 0 ; -1 unlimited
		.legend = "Auto"
		.values = "On" ;"Auto" 
		.groupSize = "640x480"
		.fileType = "jpg"
		.chartTitle = "REG KEYS COUNT by TYPE"
		;.config = 
		;.oTsFormat = 
		.view = 1
	EndWith
	
; Create a SQL query text
$StrQuery = "SELECT ValueType, COUNT(*) INTO " & @ScriptDir& "\graph.jpg FROM \HKLM GROUP BY ValueType ORDER BY COUNT(*) Desc"

; Execbatch is used for combining input and output parameters when execution
; The ExecuteBatch method executes a script and then displays/saves the output in a command window, an HTML file, a SQL database, whatever.
$oLogQuery.ExecuteBatch($StrQuery , $oInputFormat , $oOutputFormat) 

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
