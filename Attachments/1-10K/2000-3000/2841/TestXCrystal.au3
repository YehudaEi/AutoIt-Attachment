#include <GUIConstants.au3>
;
; Embedding an Crystal Reports Viewer control inside an AutoIt GUI
;
; THIS EXAMPLE REQUIRES THE CRYSTAL REPORTS ACTIVEX VIEWER CONTROL V8.0 or higher !!
;
; The Crystal Reports ActiveX viewer is a component from the Crystal Reports suite and can not be obtained separately
;
; See also: http://support.businessobjects.com/ , search for "ActiveX"

; Initialize my error handler
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

; You can test this from:
;                                                                                 
; expand the cab and run regsvr32.exe on the file crviewer.dll
$oCRViewer		= ObjCreate("CRViewer.CRViewer")	; Create a Crystal Reports Viewer control

$oCRViewerEvt	= ObjEvent($oCRViewer,"CRViewerEvent_")  ; Catch events from the control

if IsObj($oCRViewer) then
	
	$oCRViewer.DisplayBorder = False          ;MAKES REPORT FILL ENTIRE FORM 
    $oCRViewer.DisplayTabs = False            ;THIS REPORT DOES NOT DRILL DOWN, NOT NEEDED 
    $oCRViewer.EnableDrillDown = False        ;REPORT DOES NOT SUPPORT DRILL-DOWN 
    $oCRViewer.EnableRefreshButton = False    ;ADO RECORDSET WILL NOT CHANGE, NOT NEEDED 

#comments-start
	; Using a local database and the crystal reports application
	; Example from: http://www.vbmysql.com/samplecode/cr9vbmysql.html
	
	; Open your data source here....
	$conn = CreateObj("ADODB.Connection")
    $conn.CursorLocation = $adUseClient       ;SERVER-SIDE NOT RECCOMENDED 
    $conn.ConnectionString = "DRIVER={MySQL ODBC 3.51 Driver};" _ 
        & "SERVER=127.0.0.1;" _ 
        & "DATABASE=test;" _ 
        & "UID=testuser;" _ 
        & "PWD=12345;" _ 
        & "OPTION=" & 1 + 2 + 8 + 32 + 2048 + 16384    ;SET ALL PARAMETERS 
    $conn.Open    	
	
	; Create a recordset
    $rs = CreateObj("ADODB.Recordset")
    $rs.Open("SELECT * FROM report", $conn, $adOpenStatic, $adLockReadOnly)
	
	; Link the data source to your report
    $oCrystal = CreateObj("CRAXDRT.Application")  ;MANAGES REPORTS 
     
    $oReport = $oCrystal.OpenReport($Path & "\report1.rpt")  ;OPEN OUR REPORT 
    $oReport.DiscardSavedData                      ;CLEARS REPORT SO WE WORK FROM RECORDSET 
    $oReport.Database.SetDataSource $rs            ;LINK REPORT TO RECORDSET 
	
	; Now link the viewer with the report
	$oCRViewer.ReportSource = $oReport 
	
#comments-end	

	; Using a web server connection
	; See also: http://support.businessobjects.com/communityCS/TechnicalPapers/cr_troubleshooting_activex_viewer.pdf
	
	$oWebBroker = ObjCreate("WebReportBroker.WebReportBroker")
	$oWebSource = ObjCreate("WebReportSource.WebReportSource")
	$oWebSource.ReportSource = $oWebBroker
	$oWebSource.URL = "file:///c:/report.rpt"		; Change this to your URL.
	$oWebSource.PromptOnRefresh = True
	
	; Now link the viewer with the report
	$oCRViewer.ReportSource = $oWebSource     
	
	; Create a simple GUI for our output
	GUICreate ( "Embedded ActiveX Test", 640, 580 )
	; Create File Menu
	$GUI_FileMenu   = GUICtrlCreateMenu     ("&File")
	$GUI_FileNew    = GUICtrlCreateMenuitem ("&New"         ,$GUI_FileMenu)
	$GUI_FileOpen   = GUICtrlCreateMenuitem ("&Open..."     ,$GUI_FileMenu)
	$GUI_FileSave   = GUICtrlCreateMenuitem ("&Save"        ,$GUI_FileMenu)
	$GUI_FileSaveAs = GUICtrlCreateMenuitem ("Save As..."   ,$GUI_FileMenu)
	$GUI_FileSepa   = GUICtrlCreateMenuitem (""             ,$GUI_FileMenu)    ; create a separator line
	$GUI_FileExit   = GUICtrlCreateMenuitem ("E&xit"        ,$GUI_FileMenu)

	$GUI_ActiveX	= GUICtrlCreateObj		( $oCRViewer,	10, 10 , 400 , 400 )
	$GUI_Edit		= GUICtrlCreateEdit	( "",				10, 420 , 300 , 120 )

	GUISetState ()       ;Show GUI

    $oCRViewer.ViewReport                         ;SHOW REPORT 
	
	; Waiting for user to close the window
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE or $msg = $GUI_FileExit Then ExitLoop
	Wend

	GUIDelete ()

EndIf


Exit

; This is my custom error handler
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

; -----Catch all CRViewer events

Func CRViewerEvent_($Event)
	If Isdeclared("GUI_Edit") then GUICtrlSetData($GUI_Edit,"CRViewer Unused Event: " & $Event & @CRLF, "append")
EndFunc

; Catch the print button event

Func CRViewerEvent_PrintButtonClicked()
	MSgbox (0,"Print?","Print button clicked!")
EndFunc
