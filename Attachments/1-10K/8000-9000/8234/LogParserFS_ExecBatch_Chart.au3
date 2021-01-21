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
$oLogQuery= ObjCreate("MSUtil.LogQuery") ; LP
$oInputFormat=ObjCreate("MSUtil.LogQuery.FileSystemInputFormat") ; FS
$oOutputFormat = ObjCreate("MSUtil.LogQuery.ChartOutputFormat") ; Chart

; Initialize SvenP 's  error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;~ ; Set Input Format Parameter -> Boolian
	With $oInputFormat
		.recurse = 1 ; default -1 = All SubDir
		.preserveLastAccTime = 1 
		.useLocalTime = 1
	EndWith	

; Set Output Format Parameters -> Boolian
	With $oOutputFormat
		.chartType = "Column3D"
		.categories = "Auto"
		.maxCategoryLabels = 0 ; -1 unlimited
		.legend = "Auto"
		.values = "Auto" 
		.groupSize = "640x480"
		.fileType = "jpg"
		.chartTitle = "TOP 10 Size in Bytes"
		;.config = 
		;.oTsFormat = 
		.view = 1
	EndWith
	
; Create a SQL query text
$StrQuery = "SELECT TOP 10 Name, Size INTO " & @ScriptDir& "\graph.jpg FROM 'C:\Program Files\AutoIt3\*.*' ORDER BY Size DESC"

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
