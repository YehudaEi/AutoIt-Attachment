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
$oInputFormat=ObjCreate("MSUtil.LogQuery.ADSInputFormat") ; ADS
$oOutputFormat = ObjCreate("MSUtil.LogQuery.ChartOutputFormat") ; Chart

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
	
; Chart Types :
; Chart type; one of: Line, LineMarkers, LineStacked, LineStackedMarkers, LineStacked100,  LineStacked100Markers, Line3D, 
; LineOverlapped3D, LineStacked3D, LineStacked1003D, SmoothLine, SmoothLineMarkers, SmoothLineStacked , SmoothLineStackedMarkers,
; SmoothLineStacked100, SmoothLineStac, ked100Markers, BarClustered,  BarStacked, BarStacked100, Bar3D, BarClustered3D, BarStacked3D,
; BarStacked1003D, ColumnClustered, ColumnStacked, ColumnStacked100, Column3D, ColumnClustered3D, ColumnStacked3D, ColumnStacked1003D,
; Pie, PieExploded, PieStacked, Pie3D, PieExploded3D, ScatterMarkers, ScatterSmoothLine, ScatterSmoothLine, Markers, ScatterLine,
; ScatterLineMarkers, ScatterLineFilled, Bubble, BubbleLine, Area, AreaStacked, AreaStacked100, Area3D, AreaOverlapped3D,
; AreaStacked3D, AreaStacked1003D, Doughnut, DoughnutExploded, RadarLine, RadarLineMarkers, RadarLineFilled, RadarSmoothLine,
; RadarSmoothLineMarkers, StockHLC, StockOHLC, PolarMarkers, PolarLine, PolarLineMarkers, PolarSmoothLine, PolarSmoothLineMarkers 
; [defaultvalue=Line]
; Set Output Format Parameters -> Boolian
	With $oOutputFormat
		.chartType = "Pie3D"
		.categories = "Off"
		.maxCategoryLabels = 0 ; -1 unlimited
		.legend = "On" ;"Auto"
		.values = "On" ;"Auto" 
		.groupSize = "640x480"
		.fileType = "jpg"
		.chartTitle = "ADS Count USERS by DEPARTMENT"
		;.config = 
		;.oTsFormat = 
		.view = 1
	EndWith
	
; Create a SQL query text
$StrQuery = "SELECT PropertyValue, COUNT(*) AS Dept INTO " & @ScriptDir& "\graph.jpg FROM LDAP://Domain.Company.com " & _
			"WHERE ObjectClass = 'user' AND PropertyName = 'department' GROUP BY PropertyValue ORDER BY Dept Desc"

; Execbatch is used for combining input and output parameters when execution
; The ExecuteBatch method executes a script and then displays/saves the output in a command window, an HTML file, a SQL database, whatever.
$oLogQuery.ExecuteBatch($StrQuery , $oInputFormat , $oOutputFormat) 

$oLogQuery = ""
$oInputFormat = ""
$oOutputFormat = ""

;This is Sven P's custom error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"LogParserCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
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
