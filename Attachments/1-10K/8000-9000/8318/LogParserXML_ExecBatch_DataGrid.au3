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
$oInputFormat=ObjCreate("MSUtil.LogQuery.XMLInputFormat") ; XML
$oOutputFormat = ObjCreate("MSUtil.LogQuery.DataGridOutputFormat")  ; DataGrid

;~ ; Set Input Format Parameter -> Boolian
	With $oInputFormat
		.fMode = "Tree" ; Branch | Tree | Node | Auto
		.iTsFormat = "dd MMM, yyyy" ; Default yyyy-MM-dd?hh:mm:ss
		;.dtNodes = -1
		.fNames = "Compact"
	EndWith
	
; Set Output Format Parameters -> Boolian
	With $oOutputFormat
		.rtp= 10 ; Default
		.autoScroll = 1
	EndWith

; Create a SQL query text
$StrQuery = "SELECT title, category, link#CDATA, description#CDATA, PubDate FROM http://www.autoitscript.com/rss.php"

; Execbatch is used for combining input and output parameters when executing
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
