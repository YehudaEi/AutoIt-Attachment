; Open Setanta Website and Save Each Javascript Generated EPG File for TVxB to Process
;
;Declare Variables for File Names
$Date = @YEAR&@MON&@MDAY
;
#include <IE.au3>
;
$oIE = _IECreate()
;
; Open Setanta Website
;
_IENavigate($oIE,"                                            ")
;
; Save it; InetGet is no good for Javascript pages as urls only
;
_IEAction($oIE, "saveas") "C:\Utils\TVXB\TVXB04Test\cache\TVxb-setanta.hk-" & $Date & ".html"
;
; Move onto the next day using Javascript command
;
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')")
;
; Save it; 
;
_IEAction($oIE, "saveas")
;
; Save it; Move onto the next day using Javascript command; Save it; etc etc
;
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')")
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')")
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')")
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')")
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$btnNextWeek','')")
