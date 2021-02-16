; Open Setanta Website and Save Each Javascript Generated EPG File for TVxB to Process
;
;Global $ctl00
;Global $cphForm
;Global $AllCols
;Global $tvlHeader
;Global $rptDays
;Global $ctl02
;Global $btnDay
Global $ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay
;
#include <IE.au3>
;
$oIE = _IECreate()
_IENavigate($oIE,"                                            ")
;
_IENavigate($IE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')")