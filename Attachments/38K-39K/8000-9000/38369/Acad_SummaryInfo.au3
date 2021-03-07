;
; Works with AutoCad 2012
;
; IAcadSummaryInfo: IAcadSummaryInfo Interface
; Property values:
;   Author = ""
;   Comments = ""
;   HyperlinkBase = ""
;   Keywords = ""
;   LastSavedBy = "Main"
;   RevisionNumber = ""
;   Subject = ""
;   Title = ""
; Methods supported:
;   AddCustomInfo (2)
;   GetCustomByIndex (3)
;   GetCustomByKey (2)
;   NumCustomInfo ()
;   RemoveCustomByIndex (1)
;   RemoveCustomByKey (1)
;   SetCustomByIndex (3)
;   SetCustomByKey (2)
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Install a custom error handler
Dim $oAcad
$oAcad = ObjGet("","AutoCAD.Application")
If Not IsObj($oAcad) Then
	$oAcad = ObjCreate("AutoCAD.Application")
	If NOT IsObj($oAcad) Then
		msgbox(0,"0010","error capturing autocad")
	EndIf
EndIf
$oAcadActDoc = $oAcad.activedocument
;==========================================
;   Properties
;==========================================
ConsoleWrite("$oAcadActDoc.SummaryInfo.Author" & @TAB & @TAB & $oAcadActDoc.SummaryInfo.Author& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.Comments" & @TAB & $oAcadActDoc.SummaryInfo.Comments& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.HyperlinkBase" & @TAB & $oAcadActDoc.SummaryInfo.HyperlinkBase& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.Keywords" & @TAB & $oAcadActDoc.SummaryInfo.Keywords& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.LastSavedBy" & @TAB & $oAcadActDoc.SummaryInfo.LastSavedBy& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.RevisionNumber" & @TAB & $oAcadActDoc.SummaryInfo.RevisionNumber& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.Subject" & @TAB & $oAcadActDoc.SummaryInfo.Subject& @CRLF)
ConsoleWrite("$oAcadActDoc.SummaryInfo.Title" & @TAB & @TAB & $oAcadActDoc.SummaryInfo.Title& @CRLF)
;==========================================
;   Methods
;==========================================
;   AddCustomInfo (2)			Works
;   GetCustomByIndex (3)		Works - Garbled Data
;   GetCustomByKey (2)			Works - Garbled Data
;   NumCustomInfo ()			Works
;   RemoveCustomByIndex (1)		Works
;   RemoveCustomByKey (1)		Works
;   SetCustomByIndex (3)		Works
;   SetCustomByKey (2)			Works
;==========================================
;
;   NumCustomInfo () [No Arguments]
;
ConsoleWrite("NumCustomInfo " &  @TAB & $oAcadActDoc.SummaryInfo.NumCustomInfo& @CRLF)
;
;   RemoveCustomByIndex (1)
;	(1) Integer ; 	Index location
;
Dim $i = 0
while $oAcadActDoc.SummaryInfo.NumCustomInfo > 0
	$oAcadActDoc.SummaryInfo.RemoveCustomByIndex (0)
	$i += 1
	ConsoleWrite("RemoveCustomByIndex " & $i & @CRLF)
wend
;
;   AddCustomInfo (1,2)
;	(1) String ; 	Key Name
;   (2) String ; 	Value Name
;
Dim $sKey1 = '1',	$sValue1 = 'Value One'
Dim $sKey2 = 'One',	$sValue2 = 'Value 2'
$oAcadActDoc.SummaryInfo.AddCustomInfo ($sKey1,$sValue1)
$oAcadActDoc.SummaryInfo.AddCustomInfo ($sKey2,$sValue2)
ConsoleWrite("AddCustomInfo" & @CRLF)
;
;	SetCustomByIndex (1,2,3)
;	(1) Integer ; 	Index location
;	(2) String ; 	Key Name
;   (3) String ; 	Value Name
;
For $i = 0 to $oAcadActDoc.SummaryInfo.NumCustomInfo -1
	$oAcadActDoc.SummaryInfo.SetCustomByIndex ($i,$i,$i)
	ConsoleWrite("SetCustomByIndex " & $i & @CRLF)
Next
;
;   SetCustomByKey (1,2)
;	(1) String ; 	Key Name
;   (2) String ; 	Value Name
;
$oAcadActDoc.SummaryInfo.SetCustomByKey ('0','new data')
ConsoleWrite("SetCustomByKey" & @CRLF)
;
;   RemoveCustomByKey (1)
;	(1) String ; 	Key Name
;
$oAcadActDoc.SummaryInfo.RemoveCustomByKey('0')
ConsoleWrite("RemoveCustomByKey" & @CRLF)
;
;   GetCustomByIndex (1,2,3)
;	(1) Integer ; 	Index location
;	(2) String ; 	Key Name 		Container for return from AutoCad		Returns Garbled Data
;   (3) String ; 	Value Name		Container for return from AutoCad		Returns Garbled Data
;
dim $sKeyContainer_1
dim $sValueContainer_1
For $i = 0 to $oAcadActDoc.SummaryInfo.NumCustomInfo -1
	$oAcadActDoc.SummaryInfo.GetCustomByIndex($i,$sKeyContainer_1,$sValueContainer_1)
	ConsoleWrite("GetCustomByIndex " & $i  & @TAB & "Key:" & $sKeyContainer_1 &@CRLF& "  Value:" & $sValueContainer_1 & @CRLF)
Next
;
;   GetCustomByKey (1,2)
;	(1) String ; 	Key Name
;   (2) String ; 	Value Name		Container for return from AutoCad		Returns Garbled Data
;
dim $sValueContainer_2
$oAcadActDoc.SummaryInfo.GetCustomByKey('1',$sValueContainer_2)
ConsoleWrite("GetCustomByKey" & @TAB & @TAB & "Value:" & @TAB & $sValueContainer_2 &@CRLF)
;ConsoleWrite(VarGetType($sValueContainer_2) & @CRLF)
;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤  Com Error Handler ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
Func MyErrFunc()
  Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"      & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & hex($oMyError.number,8)  & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )

    Local $err = $oMyError.number
    If $err = 0 Then $err = -1

    SetError($err)
Endfunc
